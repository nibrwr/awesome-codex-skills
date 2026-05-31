#!/usr/bin/env python3
"""Sync locally installed Codex skills into this repository.

User-installed skills from $CODEX_HOME/skills are copied into top-level
directories. Plugin-bundled skills are tracked in a manifest because plugin
skill names can collide across plugins and should be restored through plugin
installation, not by flattening them into the user skills directory.
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
CODEX_HOME = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex")).expanduser()
MANIFEST_DIR = REPO_ROOT / "codex-app-sync"
MANIFEST_PATH = MANIFEST_DIR / "installed-skills-manifest.json"

EXCLUDED_DIRS = {
    ".git",
    ".svn",
    ".hg",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    "node_modules",
    ".venv",
    "venv",
}
EXCLUDED_FILES = {
    ".DS_Store",
    ".env",
    ".env.local",
    ".env.production",
}
EXCLUDED_SUFFIXES = {
    ".pyc",
    ".pyo",
    ".swp",
    ".tmp",
    ".log",
    ".pem",
    ".key",
    ".p12",
}


@dataclass(frozen=True)
class SkillEntry:
    kind: str
    name: str
    source: str
    skill_md_sha256: str
    tree_sha256: str
    plugin: str | None = None
    version: str | None = None


def display_path(path: Path) -> str:
    home = Path.home()
    try:
        return "~/" + str(path.resolve().relative_to(home))
    except ValueError:
        return str(path.resolve())


def is_excluded(path: Path) -> bool:
    if path.name in EXCLUDED_DIRS or path.name in EXCLUDED_FILES:
        return True
    if path.suffix in EXCLUDED_SUFFIXES:
        return True
    if path.name.startswith(".env."):
        return True
    return False


def ignore_names(directory: str, names: list[str]) -> set[str]:
    directory_path = Path(directory)
    return {name for name in names if is_excluded(directory_path / name)}


def file_sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def tree_sha256(root: Path) -> str:
    digest = hashlib.sha256()
    for path in sorted(root.rglob("*")):
        if is_excluded(path) or any(part in EXCLUDED_DIRS for part in path.relative_to(root).parts):
            continue
        if path.is_file():
            rel = path.relative_to(root).as_posix()
            digest.update(rel.encode("utf-8"))
            digest.update(b"\0")
            digest.update(file_sha256(path).encode("ascii"))
            digest.update(b"\0")
    return digest.hexdigest()


def skill_dirs(root: Path) -> list[Path]:
    if not root.exists():
        return []
    return sorted(
        path.parent
        for path in root.glob("*/SKILL.md")
        if path.parent.name != ".system" and not is_excluded(path.parent)
    )


def plugin_skill_dirs() -> list[Path]:
    roots = [
        CODEX_HOME / "plugins" / "cache",
        Path.home() / ".cache" / "codex-runtimes" / "codex-primary-runtime" / "plugins",
    ]
    found: list[Path] = []
    for root in roots:
        if root.exists():
            found.extend(path.parent for path in root.rglob("skills/*/SKILL.md"))
    return sorted(set(found))


def plugin_metadata(skill_dir: Path) -> tuple[str | None, str | None]:
    parts = skill_dir.parts
    if "plugins" in parts and "skills" in parts:
        try:
            skills_index = parts.index("skills")
            version = parts[skills_index - 1]
            plugin = parts[skills_index - 2]
            return plugin, version
        except IndexError:
            return None, None
    return None, None


def entry(kind: str, skill_dir: Path, plugin: str | None = None, version: str | None = None) -> SkillEntry:
    return SkillEntry(
        kind=kind,
        name=skill_dir.name,
        source=display_path(skill_dir),
        skill_md_sha256=file_sha256(skill_dir / "SKILL.md"),
        tree_sha256=tree_sha256(skill_dir),
        plugin=plugin,
        version=version,
    )


def copy_user_skills(user_dirs: list[Path]) -> None:
    for skill_dir in user_dirs:
        dest = REPO_ROOT / skill_dir.name
        if dest.exists():
            shutil.rmtree(dest)
        shutil.copytree(skill_dir, dest, ignore=ignore_names)


def write_manifest(user_entries: list[SkillEntry], plugin_entries: list[SkillEntry]) -> None:
    MANIFEST_DIR.mkdir(exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "codex_home": display_path(CODEX_HOME),
        "copied_user_skills": [asdict(item) for item in user_entries],
        "monitored_plugin_skills": [asdict(item) for item in plugin_entries],
    }
    MANIFEST_PATH.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def main() -> int:
    user_dirs = skill_dirs(CODEX_HOME / "skills")
    user_entries = [entry("user", path) for path in user_dirs]

    plugin_entries: list[SkillEntry] = []
    for path in plugin_skill_dirs():
        plugin, version = plugin_metadata(path)
        plugin_entries.append(entry("plugin", path, plugin=plugin, version=version))

    copy_user_skills(user_dirs)
    write_manifest(user_entries, plugin_entries)

    print(f"Copied {len(user_entries)} user skills into {REPO_ROOT}")
    print(f"Tracked {len(plugin_entries)} plugin-bundled skills in {MANIFEST_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
