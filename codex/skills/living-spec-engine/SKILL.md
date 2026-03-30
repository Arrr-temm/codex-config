---
name: living-spec-engine
description: Bootstrap and maintain a repo-local documentation system made of `README.md`, `AGENTS.md`, and a versioned `PROJECT_SPEC.md` with archive history. Use when Codex needs to start a new project from an idea, turn rough planning into durable project docs, repair or normalize repo guidance files, update the living project spec with full-state archives, or keep agent instructions, human onboarding, and product truth aligned as development evolves.
---

# Living Spec Engine

## Overview

Create and maintain a three-document repo guidance system:

- `README.md` for human-oriented project orientation
- `AGENTS.md` for repo-local agent behavior and collaboration rules
- `PROJECT_SPEC.md` for the current project truth, backed by `LivingSpecArchive/`

Treat all three as living documents. Only `PROJECT_SPEC.md` uses strict versioning and append-only archival. `README.md` and `AGENTS.md` are updated in place as the project matures.

## Core Contract

- Treat `/PROJECT_SPEC.md` as the single active project spec.
- Treat `/LivingSpecArchive/` as append-only history for project spec snapshots only.
- Treat `/README.md` as the human entrypoint to the repo.
- Treat `/AGENTS.md` as the repo-local operating guide for agents working in this project.
- Keep the three files cross-linked so a reader can move between orientation, operating rules, and project truth.
- Keep the docs mutually consistent. If the roadmap changes, update the spec. If working practices change, update `AGENTS.md`. If setup or scope framing changes, update `README.md`.

## Document Roles

### README.md

Use `README.md` to explain, in simple language:

- what the project is
- why it exists
- the current state
- how to run or inspect it
- where to find `AGENTS.md` and `PROJECT_SPEC.md`

Keep it useful for a human who may not be technical.

### AGENTS.md

Use `AGENTS.md` to explain how agents should work in this repo:

- read `PROJECT_SPEC.md` before product or architecture changes
- explain plans and important decisions in clear non-technical language
- ask for approval at meaningful forks in the road
- work autonomously once a direction is approved
- keep documentation current as work progresses

Assume the human collaborator is a non-developer unless the repo clearly indicates otherwise.

### PROJECT_SPEC.md

Use `PROJECT_SPEC.md` as the source of truth for:

- current product vision
- core problem and target outcome
- architecture
- roadmap
- decisions and rationale
- open questions
- machine-readable project state

This is the only file that must be versioned and archived on every revision.

## Initialization Workflow

Use this workflow when the repo does not yet have the three core docs, or when the docs exist but need normalization.

### 1. Build context from the idea

- Read any brief, notes, or rough concept the user provides.
- If the project is still fuzzy, help the user iterate the idea into a clear plan before writing final docs.
- Prefer simple language and concrete framing over technical jargon.

### 2. Create the three living docs

- Create `README.md` from [references/readme_template.md](references/readme_template.md)
- Create `AGENTS.md` from [references/agents_template.md](references/agents_template.md)
- Create `PROJECT_SPEC.md` from [references/project_spec_template.md](references/project_spec_template.md)

### 3. Cross-link them

- `README.md` must point to `AGENTS.md` and `PROJECT_SPEC.md`
- `AGENTS.md` must point to `README.md` and `PROJECT_SPEC.md`
- `PROJECT_SPEC.md` must mention `README.md` and `AGENTS.md`

### 4. Populate them coherently

- Put the human-friendly project summary in `README.md`
- Put the collaboration and agent workflow rules in `AGENTS.md`
- Put the detailed product and system truth in `PROJECT_SPEC.md`

### 5. Present the path forward

- Before major implementation begins, summarize a step-by-step development path in simple language.
- Ask for approval on that path if the project is new, ambiguous, or has major tradeoffs.
- After approval, work autonomously within that direction and only pause for important decisions or blockers.

## Project Spec Workflow

### 1. Read the current state

- Load `PROJECT_SPEC.md` if it exists.
- If the user points to a legacy or differently named spec file, use it as input context, but do not rename or migrate files unless asked or clearly necessary.
- Read `README.md` and `AGENTS.md` too when they exist, so updates stay aligned.

### 2. Determine archive metadata

- Derive `ProjectName` in this order:
  1. `project.name` from the machine-readable YAML
  2. an explicit user-provided project name
  3. the repository or workspace folder name
- Normalize `ProjectName` to PascalCase with no spaces or punctuation.
- Use the current local date for the archive filename.
- Parse the current version from the revision header or machine-readable YAML. If both exist and disagree, repair them to a single value before proceeding.

### 3. Archive before editing

- Ensure `LivingSpecArchive/` exists.
- Write the current full spec to `LivingSpecArchive/LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md`
- Never overwrite an existing archive file.

### 4. Apply the revision

- Update the revision header:
  - `Version`
  - `Last Updated`
  - `Status`
  - `What changed in this revision`
- Update the one-pager, architecture, roadmap, decisions, open questions, and machine-readable YAML so they reflect the same project state.
- If the change materially affects onboarding or repo behavior, update `README.md` and `AGENTS.md` in the same pass.

### 5. Bump the version

- Use semantic versioning:
  - Major: strategy reset, scope break, or fundamental architecture change
  - Minor: meaningful feature or workflow addition
  - Patch: minor correction, clarification, or small state update
- Update the version in both the revision header and machine-readable YAML.

### 6. Write the new root files

- Overwrite only `PROJECT_SPEC.md` after the archive has been written.
- Update `README.md` and `AGENTS.md` in place when needed.
- Keep all three documents self-consistent.

## Collaboration Guidance

- Explain technical decisions in plain language first, then include technical detail only if helpful.
- When there is a meaningful fork in the road, present the options, tradeoffs, and your recommendation clearly.
- Avoid asking for approval on every small step. Default to autonomous progress after the user approves a direction.
- Surface uncertainty openly. If details are missing, make a minimal reasonable assumption and note it.
- Keep the current step and next step visible to the user.

## Editing Guidance

- Prefer small, internally consistent rewrites over partial edits that leave stale sections behind.
- When creating from scratch, use the reference templates rather than improvising structure.
- When repairing malformed docs, restore the expected structure first, then fill content.
- Keep `AGENTS.md` general enough to stay reusable across many tasks in the repo, but specific enough to guide behavior in this project.
- Keep `README.md` approachable for a non-technical collaborator.

## Common Requests

- "Start a new project from this idea and create the docs."
- "Apply the living spec system to this repo."
- "Set up README, AGENTS, and PROJECT_SPEC before we start building."
- "Update the project truth and keep the repo guidance docs aligned."
- "Repair the living project docs so the naming and archive workflow are consistent."

## Output Expectations

- Report which files were created or updated.
- Report the project spec version change when an archive was written.
- Report the archive path you created when applicable.
- Mention any assumptions, especially project naming, scope framing, or approval points.
