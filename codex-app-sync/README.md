# Codex App Skill Sync

This folder tracks the skills installed in this Codex app environment.

- User-installed skills from `~/.codex/skills` are copied into top-level skill directories in this repo.
- Plugin-bundled skills are tracked in `installed-skills-manifest.json` because plugins can contain duplicate skill names and should be restored through Codex plugin installation.

Run the sync script from the repo root:

```bash
python3 scripts/sync-codex-skills.py
```

The daily automation uses this script, scans changed files for obvious secrets, then commits and pushes to the personal fork when safe.
