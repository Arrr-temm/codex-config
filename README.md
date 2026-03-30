# codex-config

Portable Codex configuration that can be installed on a fresh machine with one command.

This repository intentionally stores only non-secret, portable Codex state:

- `codex/config.toml`
- custom skills in `codex/skills/`
- optional non-secret shared guidance in `codex/rules/`

This repository must never store:

- `auth.json`
- session databases
- logs
- machine-specific approval state
- API tokens or other secrets

## First-time install

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/Arrr-temm/codex-config/main/bootstrap/install.ps1 | iex
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Arrr-temm/codex-config/main/bootstrap/install.sh | bash
```

## Daily update command

After the first install, open a new shell and run:

```powershell
get-codex-config
```

That command updates the local checkout in `~/.codex/vendor_imports/codex-config` and re-syncs the managed files into `~/.codex/`.

## What gets installed

- `codex/config.toml` -> `~/.codex/config.toml`
- each skill under `codex/skills/` -> `~/.codex/skills/<skill-name>`
- each rule under `codex/rules/` -> `~/.codex/rules/<rule-file>`

Existing managed files are backed up before replacement.

## Global Guidance

This repo also installs a shared guidance file at `~/.codex/rules/repo-doc-priority.md`.

Its purpose is to record the preferred cross-project behavior:

- check `AGENTS.md` first when it exists
- check `PROJECT_SPEC.md` for current project truth
- use `LivingSpecArchive/INDEX.md` when older project decisions matter

Important: this is best treated as shared guidance, not as a guaranteed platform-level always-on system rule. The most reliable behavior still comes from repo-local docs plus explicit skill usage at project start.

## Codex Cloud

Codex cloud tasks do not automatically inherit your local `~/.codex` folder. To reuse this setup in a cloud task, clone this repo into the task workspace or point the agent at the relevant files in this repository.
