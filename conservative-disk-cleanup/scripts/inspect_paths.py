#!/usr/bin/env python3
"""Bounded, metadata-only disk inspection. No file-body reads or deletion."""

import argparse
import datetime
import json
import math
import os
from pathlib import Path
import platform
import shutil
import stat
import subprocess
import time


CLOUD_NAMES = {"CloudStorage", "Mobile Documents", "iCloud Drive", "OneDrive"}
ARCHIVE_SUFFIXES = (".xcarchive", ".dSYM", ".xcresult")


def absolute(value):
    return Path(os.path.abspath(os.path.expanduser(str(value))))


def within(path, root):
    return path == root or root in path.parents


def filesystem(path):
    try:
        data = os.statvfs(path)
        return {"device": os.stat(path).st_dev,
                "available_bytes": data.f_bavail * data.f_frsize,
                "free_bytes": data.f_bfree * data.f_frsize,
                "total_bytes": data.f_blocks * data.f_frsize}
    except (OSError, AttributeError) as error:
        return {"error": type(error).__name__}


def inspect(root, excluded, budget_seconds):
    started = time.monotonic()
    result = {"path": str(root), "status": "complete", "errors": [],
              "exclusions": [], "symlink_ancestors": [], "children": [],
              "git_markers": [], "archive_packages": [], "marker_counts": {},
              "symlink_samples": [],
              "regular_files": 0, "directories": 0, "symlinks": 0,
              "duplicate_hardlinks": 0, "logical_bytes": 0,
              "allocated_bytes": None, "latest_file_mtime_ns": None}
    allocated = 0
    allocation_known = True
    seen = set()
    children = {}

    def limited_append(key, value):
        result["marker_counts"][key] = result["marker_counts"].get(key, 0) + 1
        if len(result[key]) < 40:
            result[key].append(value)

    def skip(path, reason):
        result["status"] = "partial"
        result["exclusions"].append({"path": str(path), "reason": reason})

    def error(path, exc):
        result["status"] = "partial"
        if len(result["errors"]) < 50:
            result["errors"].append({"path": str(path), "type": type(exc).__name__,
                                     "errno": getattr(exc, "errno", None)})
        result["error_count"] = result.get("error_count", 0) + 1

    # Inspect ancestors before lstat(root), which would otherwise traverse them.
    for parent in reversed(root.parents):
        try:
            if parent.is_symlink():
                result["symlink_ancestors"].append(str(parent))
        except OSError as exc:
            error(parent, exc)
    if result["symlink_ancestors"]:
        result["status"] = "skipped"
        result["skip_reason"] = "symlink ancestor; target was not traversed"
        return result
    if any(part in CLOUD_NAMES for part in root.parts):
        result["status"] = "skipped"
        result["skip_reason"] = "cloud provider path; no recursive enumeration"
        return result
    if any(within(root, entry) for entry in excluded):
        result["status"] = "skipped"
        result["skip_reason"] = "explicit exclusion"
        return result
    try:
        first = root.lstat()
    except OSError as exc:
        error(root, exc)
        return result
    result["identity"] = {"device": first.st_dev, "inode": first.st_ino,
                          "uid": first.st_uid, "mtime_ns": first.st_mtime_ns}
    result["filesystem_before"] = filesystem(root.parent if root.is_symlink() else root)
    root_device = first.st_dev
    stack = [(root, first)]
    while stack:
        if time.monotonic() - started >= budget_seconds:
            skip(root, "time budget reached; totals are lower bounds")
            break
        current, metadata = stack.pop()
        child_name = current.relative_to(root).parts[0] if current != root else None
        bucket = None
        if child_name is not None:
            bucket = children.setdefault(child_name, {"name": child_name,
                "logical_bytes": 0, "allocated_bytes": 0, "entries": 0})
        if current != root and (metadata.st_dev != root_device or os.path.ismount(current)):
            skip(current, "nested filesystem or mount; not traversed")
            continue
        if any(within(current, entry) for entry in excluded):
            skip(current, "explicit exclusion")
            continue
        if current.name in CLOUD_NAMES:
            skip(current, "cloud provider directory; not traversed")
            continue
        if bucket is not None:
            bucket["entries"] += 1
        mode = metadata.st_mode
        is_directory = stat.S_ISDIR(mode)
        is_file = stat.S_ISREG(mode)
        is_link = stat.S_ISLNK(mode)
        if current.name == ".git":
            limited_append("git_markers", str(current))
        if current.name.endswith(ARCHIVE_SUFFIXES):
            limited_append("archive_packages", str(current))
        if is_link:
            result["symlinks"] += 1
            if len(result["symlink_samples"]) < 40:
                try:
                    target = os.readlink(current)
                    lexical = Path(os.path.abspath(os.path.join(str(current.parent), target)))
                    result["symlink_samples"].append({"path": str(current),
                        "target": target, "lexical_target": str(lexical),
                        "outside_root": not within(lexical, root)})
                except OSError as exc:
                    error(current, exc)
        elif is_directory:
            result["directories"] += 1
        elif is_file:
            result["regular_files"] += 1
            result["logical_bytes"] += metadata.st_size
            if bucket is not None:
                bucket["logical_bytes"] += metadata.st_size
            result["latest_file_mtime_ns"] = max(
                result["latest_file_mtime_ns"] or 0, metadata.st_mtime_ns)
        else:
            skip(current, "special file; excluded from size totals")
            continue
        duplicate = False
        if is_file and metadata.st_nlink > 1:
            identity = (metadata.st_dev, metadata.st_ino)
            duplicate = identity in seen
            seen.add(identity)
            result["duplicate_hardlinks"] += int(duplicate)
        blocks = getattr(metadata, "st_blocks", None)
        if blocks is None:
            allocation_known = False
        elif not duplicate:
            amount = blocks * 512
            allocated += amount
            if bucket is not None:
                bucket["allocated_bytes"] += amount
        if is_directory:
            try:
                with os.scandir(current) as entries:
                    for entry in entries:
                        if time.monotonic() - started >= budget_seconds:
                            skip(current, "time budget reached during enumeration")
                            stack.clear()
                            break
                        child = Path(entry.path)
                        try:
                            stack.append((child, entry.stat(follow_symlinks=False)))
                        except OSError as exc:
                            error(child, exc)
            except OSError as exc:
                error(current, exc)
    result["allocated_bytes"] = allocated if allocation_known else None
    result["symlink_samples_limited"] = result["symlinks"] > len(result["symlink_samples"])
    result["children"] = sorted(children.values(),
        key=lambda entry: (entry["allocated_bytes"], entry["name"]), reverse=True)
    if not allocation_known:
        for child in result["children"]:
            child["allocated_bytes"] = None
    result["filesystem_after"] = filesystem(root.parent if stat.S_ISLNK(first.st_mode) else root)
    result["elapsed_seconds"] = round(time.monotonic() - started, 3)
    if stat.S_ISLNK(first.st_mode):
        result["root_kind"] = "symlink; target not traversed"
    else:
        result["root_kind"] = "directory" if stat.S_ISDIR(first.st_mode) else "file"
    return result


def open_files(roots):
    executable = shutil.which("lsof")
    if not executable:
        return {"status": "unavailable", "matches": [], "reason": "lsof not installed"}
    try:
        data = subprocess.run([executable, "-n", "-Fpcn"], capture_output=True,
                              text=True, timeout=20)
    except (OSError, subprocess.TimeoutExpired) as exc:
        return {"status": "unavailable", "matches": [], "reason": type(exc).__name__}
    matches = set()
    pid = command = ""
    for line in data.stdout.splitlines():
        if line.startswith("p"):
            pid = line[1:]
        elif line.startswith("c"):
            command = line[1:]
        elif line.startswith("n") and line[1:].startswith("/"):
            candidate = absolute(line[1:])
            for root in roots:
                if within(candidate, root):
                    matches.add((str(root), pid, command))
    return {"status": "partial" if data.returncode or data.stderr else "visible-process-scan",
            "exit_code": data.returncode, "stderr_present": bool(data.stderr),
            "matches": [{"root": root, "pid": pid, "command": cmd}
                        for root, pid, cmd in sorted(matches)],
            "limitation": "Visible processes only; no match does not establish non-use. Aliases, root-owned consumers and future jobs need separate checks."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="+", help="Explicit local paths; symlinks are not followed")
    parser.add_argument("--exclude", action="append", default=[], help="Exact subtree to skip; repeatable")
    parser.add_argument("--budget-seconds", type=float, default=30,
                        help="Per-root traversal budget (default 30); kernel filesystem calls may still block")
    parser.add_argument("--open-files", action="store_true", help="Check visible consumers with lsof")
    parser.add_argument("--output", help="Create a new private JSON file outside inspected roots; otherwise stdout")
    args = parser.parse_args()
    if not math.isfinite(args.budget_seconds) or args.budget_seconds <= 0:
        parser.error("--budget-seconds must be finite and positive")
    roots = list(dict.fromkeys(absolute(value) for value in args.paths))
    excluded = [absolute(value) for value in args.exclude]
    output = absolute(args.output) if args.output else None
    if output is not None:
        if output.exists() or output.is_symlink():
            parser.error("output already exists; no file will be overwritten")
        if any(within(output.resolve(strict=False), root.resolve(strict=False)) for root in roots):
            parser.error("output must be outside every inspected root")
        if not output.parent.is_dir():
            parser.error("output parent must already exist")
    result = {"schema_version": 1,
              "measured_at_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
              "host": platform.node(), "platform": platform.system(),
              "interpretation": "Read-only metadata. Allocated bytes deduplicate hard links within each root only, not APFS clones or cross-root sharing. Partial totals are lower bounds; file mtime is not last use. Symlink samples are bounded; lexical targets do not resolve link chains. This report grants no removal authority.",
              "overlapping_roots": [{"parent": str(left), "child": str(right)}
                   for left in roots for right in roots if left != right and within(right, left)],
              "roots": [inspect(root, excluded, args.budget_seconds) for root in roots]}
    if args.open_files:
        result["open_files"] = open_files(roots)
    if output is None:
        print(json.dumps(result, indent=2))
    else:
        flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL | getattr(os, "O_NOFOLLOW", 0)
        with os.fdopen(os.open(output, flags, 0o600), "w") as target:
            json.dump(result, target, indent=2)
            target.write("\n")
        print(json.dumps({"output": str(output), "roots": len(roots),
                          "partial_or_skipped": sum(x["status"] != "complete" for x in result["roots"])}))


if __name__ == "__main__":
    main()
