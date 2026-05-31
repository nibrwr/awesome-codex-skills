# Codex App Skill Sync

This folder tracks the skills installed in this Codex app environment.

- User-installed skills from `~/.codex/skills` are copied into top-level skill directories in this repo.
- Missing top-level skills from this repo can be installed into `~/.codex/skills`.
- Plugin-bundled skills are tracked in `installed-skills-manifest.json` because plugins can contain duplicate skill names and should be restored through Codex plugin installation.

Run the upstream install check and sync scripts from the repo root:

```bash
python3 scripts/install-missing-repo-skills.py
python3 scripts/sync-codex-skills.py
```

The daily automation first fetches upstream changes into the fork checkout, installs any newly added repo skills that are not already present in this Codex app, then syncs the resulting local skill set back to the personal fork. It scans changed files for obvious secrets before committing and pushing.
