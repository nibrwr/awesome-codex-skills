#!/usr/bin/env python3
"""Frame declared App Store source captures with exact Apple device assets."""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "screenshots.json"


def fail(message: str) -> "NoReturn":
    raise SystemExit(f"App Store framing failed: {message}")


def run_json(command: list[str]) -> object:
    result = subprocess.run(command, check=False, capture_output=True, text=True)
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip() or "unknown error"
        fail(f"{' '.join(command)}: {detail}")
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as error:
        fail(f"{' '.join(command)} returned invalid JSON: {error}")


def main() -> None:
    if shutil.which("frames") is None:
        fail("the `frames` command is unavailable")
    if not MANIFEST_PATH.is_file():
        fail(f"missing {MANIFEST_PATH}")

    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    run_json(["frames", "--json", "doctor"])

    generated = 0
    for locale in manifest["locales"]:
        for screenshot_set in manifest["sets"]:
            platform = screenshot_set["platform"]
            if not manifest["platforms"].get(platform, False):
                continue

            set_id = screenshot_set["id"]
            source_directory = ROOT / "sources" / locale / set_id
            output_directory = ROOT / ".build" / "framed" / locale / set_id
            expected = [source_directory / f"{shot_id}.png" for shot_id in screenshot_set["shots"]]
            missing = [str(path) for path in expected if not path.is_file()]
            if missing:
                fail("missing source capture(s): " + ", ".join(missing))

            run_json(["frames", "--json", "info", *map(str, expected)])
            output_directory.mkdir(parents=True, exist_ok=True)
            for stale in output_directory.glob("*_framed.png"):
                stale.unlink()

            command = [
                "frames",
                "--json",
                "frame",
                "--device",
                screenshot_set["device"],
                "--output",
                str(output_directory),
            ]
            frame_color = screenshot_set.get("frameColor", "").strip()
            if frame_color:
                command.extend(["--color", frame_color])
            command.extend(map(str, expected))

            result = run_json(command)
            records = result.get("frames", [result]) if isinstance(result, dict) else []
            if len(records) != len(expected):
                fail(f"{set_id}/{locale} produced {len(records)} frames for {len(expected)} captures")
            for record in records:
                if record.get("device") != screenshot_set["device"]:
                    fail(
                        f"{set_id}/{locale} resolved {record.get('device')!r}; "
                        f"expected {screenshot_set['device']!r}"
                    )
            generated += len(records)
            print(f"Framed {len(records)} {locale}/{set_id} screenshot(s)")

    if generated == 0:
        fail("the manifest contains no enabled screenshot sets")
    print(f"App Store framing complete: {generated} image(s)")


if __name__ == "__main__":
    main()
