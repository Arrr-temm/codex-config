---
name: living-spec-engine
description: Maintain a versioned, file-system-backed living specification with one active root spec and an append-only archive. Use when Codex needs to create, repair, migrate, or update `PROJECT_SPEC.md`, preserve historical snapshots in `LivingSpecArchive/`, increment semantic versions, or keep a project specification synchronized with the latest product and architecture truth.
---

# Living Spec Engine

## Overview

Maintain a single-source-of-truth project specification in the workspace root while preserving every prior full-state version in a deterministic archive. Favor exact filesystem operations, explicit version bumps, and updates that keep the human-readable and machine-readable portions in sync.

## Core Contract

- Treat `/PROJECT_SPEC.md` as the only active spec file.
- Treat `/LivingSpecArchive/` as append-only history.
- Archive the current root spec before writing any update.
- Preserve full-state snapshots. Every archive file must stand on its own.
- Increment version on every revision.
- Keep file names deterministic: `LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md`

## Update Workflow

### 1. Read the current state

- Load `PROJECT_SPEC.md` if it exists.
- If the user points to a legacy or differently named spec file, use it as input context, but do not rename or migrate files unless the user asks or the task clearly requires normalization.
- Read the full spec before editing so architecture, roadmap, decisions, and open questions stay internally consistent.

### 2. Determine archive metadata

- Derive `ProjectName` in this order:
  1. `project.name` from the machine-readable YAML
  2. An explicit user-provided project name
  3. The repository or workspace folder name
- Normalize the archive `ProjectName` to PascalCase with no spaces or punctuation.
- Use the current local date for the archive filename.
- Parse the current version from the revision header or machine-readable YAML. If both exist and disagree, repair them to a single value before proceeding.

### 3. Archive before editing

- Ensure `LivingSpecArchive/` exists.
- Write the current full spec to `LivingSpecArchive/LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md`.
- Never overwrite an existing archive file. If the exact target name already exists, confirm whether the version/date should change before writing another archive.

### 4. Apply the revision

- Update the revision header:
  - `Version`
  - `Last Updated`
  - `Status`
  - `What changed in this revision`
- Update the one-pager, architecture, roadmap, decisions, open questions, and machine-readable YAML so they describe the same project state.
- Preserve the document structure from the template. If a section is missing but needed, add it back rather than inventing a new layout.
- Preserve any existing revision-history appendix. If no appendix exists, capture the current change summary in section 1 instead of adding extra scaffolding unless the user asks for a history section.

### 5. Bump the version

- Use semantic versioning:
  - Major: strategy reset, scope break, or fundamental architecture change
  - Minor: meaningful feature or workflow addition
  - Patch: minor correction, clarification, or small state update
- Update the version in both the revision header and machine-readable YAML.

### 6. Write the new root spec

- Overwrite only `PROJECT_SPEC.md` with the revised latest state after the archive has been saved.
- Keep the new root file fully self-contained.

## Editing Guidance

- Prefer small, internally consistent rewrites over partial edits that leave stale sections behind.
- When information is missing, make the smallest reasonable inference and label uncertainty in `Known Gaps / Open Questions`.
- Keep status values concrete, for example `Planning`, `In Progress`, `MVP`, `Scaling`, or `Stable`.
- When repairing malformed specs, restore the required structure first, then fill content.
- When creating a new spec from scratch, load [references/project_spec_template.md](references/project_spec_template.md) and fill it completely instead of improvising the layout.

## Common Requests

- "Update the living spec with today's progress."
- "Archive the current spec and promote this draft to the latest truth."
- "Convert this project brief into a proper `PROJECT_SPEC.md` system."
- "Repair the spec so the archive naming and versioning follow the living spec rules."

## Output Expectations

- Report the version change you made.
- Report the archive path you created when an archive was written.
- Mention any assumptions, especially project name inference or version-bump rationale.
