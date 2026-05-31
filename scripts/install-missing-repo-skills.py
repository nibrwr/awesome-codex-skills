#!/usr/bin/env python3
"""Install repo skills that are missing from this Codex app environment."""

from __future__ import annotations

import os
import shutil
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
CODEX_HOME = Path(os.environ.get("CODEX_HOME", Path.home() / ".codex")).expanduser()
SKILLS_DIR = CODEX_HOME / "skills"
SYSTEM_SKILLS_DIR = SKILLS_DIR / ".system"

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


def repo_skill_dirs() -> list[Path]:
    return sorted(
        path.parent
        for path in REPO_ROOT.glob("*/SKILL.md")
        if not is_excluded(path.parent)
    )


def is_installed_elsewhere(name: str) -> bool:
    return (SKILLS_DIR / name / "SKILL.md").exists() or (SYSTEM_SKILLS_DIR / name / "SKILL.md").exists()


def main() -> int:
    SKILLS_DIR.mkdir(parents=True, exist_ok=True)

    installed: list[str] = []
    skipped: list[str] = []
    for skill_dir in repo_skill_dirs():
        name = skill_dir.name
        if is_installed_elsewhere(name):
            skipped.append(name)
            continue
        shutil.copytree(skill_dir, SKILLS_DIR / name, ignore=ignore_names)
        installed.append(name)

    if installed:
        print("Installed missing repo skills:")
        for name in installed:
            print(f"- {name}")
    else:
        print("No missing repo skills to install.")

    print(f"Skipped {len(skipped)} already-installed skills.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
