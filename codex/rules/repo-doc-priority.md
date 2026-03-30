# Global Repo Doc Priority

Use this as shared global guidance for Codex setups managed by this `codex-config` repository.

## Intent

When working inside a repository, prefer repo-local instructions over guesswork.

## Working Rule

At the start of meaningful repo work:

1. Check whether `AGENTS.md` exists in the repo root.
2. Check whether `PROJECT_SPEC.md` exists in the repo root.
3. If both exist, read them before making product, architecture, workflow, or roadmap changes.
4. Treat `PROJECT_SPEC.md` as the current project truth.
5. Use `LivingSpecArchive/INDEX.md` and archived specs when older decisions or wording matter.

## Why This Exists

Skills may not be directly injected into already-running threads, but repo-local documents can still guide behavior when agents read the workspace. This file records the intended global preference for repo-doc-first operation across machines.

## Important Limitation

This file is a shared guidance artifact, not a guaranteed platform-level system prompt. The most reliable always-on layer remains:

- repo-local `AGENTS.md`
- repo-local `PROJECT_SPEC.md`
- explicit skill use when starting a new project
