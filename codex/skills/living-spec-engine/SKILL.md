---
name: living-spec-engine
description: Bootstrap and maintain a lightweight repo-local documentation system for `README.md`, `AGENTS.md`, `PROJECT_SPEC.md`, and an optional `CHANGE_STACK.md`. Use when Codex needs to start a new project from an idea, keep project state durable across stop-start work, stage small changes without rewriting every document, promote meaningful approved changes into the versioned project spec, or keep human onboarding, agent instructions, and project truth aligned with minimal token overhead.
---

# Living Spec

## Overview

Create and maintain a lightweight repo documentation system with four roles:

- `README.md` for human-oriented project orientation
- `AGENTS.md` for repo-local agent behavior and collaboration rules
- `PROJECT_SPEC.md` for stable current project truth
- `CHANGE_STACK.md` for small, recent, unpromoted changes and working notes

Treat all four as living docs, but do not rewrite them all on every interaction. The default is low-churn maintenance:

- `README.md` changes rarely
- `AGENTS.md` changes rarely
- `PROJECT_SPEC.md` changes only when the stable project truth has meaningfully changed
- `CHANGE_STACK.md` absorbs lightweight updates between formal spec revisions

Only `PROJECT_SPEC.md` uses strict versioning and append-only archival in `LivingSpecArchive/`.

## Core Contract

- Treat `/PROJECT_SPEC.md` as the single active project spec.
- Treat `/LivingSpecArchive/` as append-only history for project spec snapshots only.
- Maintain `/LivingSpecArchive/INDEX.md` as the archive catalog when archived specs exist.
- Treat `/README.md` as the human entrypoint to the repo.
- Treat `/AGENTS.md` as the repo-local operating guide for agents working in this project.
- Treat `/CHANGE_STACK.md` as the lightweight buffer for recent state that is not yet worth a formal spec promotion.
- Keep the docs cross-linked so a reader can move between orientation, operating rules, stable truth, and recent lightweight state.
- Prefer small edits and staged updates over full rewrites.

## Update Philosophy

### Default mode: staged updates

When the user is exploring, clarifying, or making small incremental progress:

- do not rewrite every document
- do not archive the spec
- do not bump the spec version
- capture only the smallest durable state needed

Use `CHANGE_STACK.md` for:

- recent progress bullets
- approved but not-yet-promoted changes
- notable implementation notes
- open loops worth remembering across sessions
- concise "what changed since the last spec sync" notes

### Promotion mode: formal spec update

Promote changes from `CHANGE_STACK.md` into `PROJECT_SPEC.md` only when one of these is true:

- the user asks to sync, formalize, or update the project docs
- the stable product truth has materially changed
- architecture, roadmap, scope, or key decisions changed
- enough approved changes have accumulated that the spec is drifting out of date
- a milestone, handoff, release, or major checkpoint has been reached

When promoting:

1. Archive the current `PROJECT_SPEC.md`
2. Bump the version once for the grouped change set
3. Fold the relevant staged changes into `PROJECT_SPEC.md`
4. Update revision history and `LivingSpecArchive/INDEX.md`
5. Trim or reset `CHANGE_STACK.md` so only unresolved or fresh items remain

## What Not To Do

- Do not rewrite `README.md`, `AGENTS.md`, and `PROJECT_SPEC.md` on every prompt.
- Do not bump the spec version for trivial clarifications, temporary ideas, or tiny progress notes.
- Do not archive the spec if the stable project truth did not meaningfully change.
- Do not treat brainstorming chatter as a formal revision unless the user wants it recorded that way.

## Document Roles

### README.md

Use `README.md` to explain, in simple language:

- what the project is
- why it exists
- the current stable state
- how to run or inspect it
- where to find `AGENTS.md`, `PROJECT_SPEC.md`, and `CHANGE_STACK.md`

Update it only when onboarding, framing, setup, or current status materially changes.

### AGENTS.md

Use `AGENTS.md` to explain how agents should work in this repo:

- read `PROJECT_SPEC.md` before product or architecture changes
- read `CHANGE_STACK.md` for recent lightweight state when it exists
- explain plans and important decisions in clear non-technical language
- ask for approval at meaningful forks in the road
- work autonomously once a direction is approved
- keep documentation current without over-updating it

Update it only when collaboration rules or workflow conventions change.

### PROJECT_SPEC.md

Use `PROJECT_SPEC.md` as the stable source of truth for:

- current product vision
- core problem and target outcome
- architecture
- roadmap
- decisions and rationale
- open questions
- machine-readable project state

This is the only file that must be versioned and archived on formal revision.

### CHANGE_STACK.md

Use `CHANGE_STACK.md` as the low-cost memory layer between formal revisions.

Keep it concise. Favor bullets, short dated sections, and statuses such as:

- `proposed`
- `approved`
- `implemented`
- `deferred`
- `promoted`

## Initialization Workflow

Use this workflow when the repo does not yet have the core docs, or when the docs exist but need normalization.

### 1. Build context from the idea

- Read any brief, notes, or rough concept the user provides.
- If the project is still fuzzy, help the user iterate the idea into a clear plan before writing final docs.
- Prefer simple language and concrete framing over technical jargon.

### 2. Create the docs

- Create `README.md` from [references/readme_template.md](references/readme_template.md)
- Create `AGENTS.md` from [references/agents_template.md](references/agents_template.md)
- Create `PROJECT_SPEC.md` from [references/project_spec_template.md](references/project_spec_template.md)
- Create `CHANGE_STACK.md` from [references/change_stack_template.md](references/change_stack_template.md)
- Create `LivingSpecArchive/INDEX.md` from [references/archive_index_template.md](references/archive_index_template.md) when initializing archival structure

### 3. Cross-link them

- `README.md` must point to `AGENTS.md`, `PROJECT_SPEC.md`, and `CHANGE_STACK.md`
- `AGENTS.md` must point to `README.md`, `PROJECT_SPEC.md`, and `CHANGE_STACK.md`
- `PROJECT_SPEC.md` must mention `README.md`, `AGENTS.md`, and `CHANGE_STACK.md`
- `PROJECT_SPEC.md` must point to `LivingSpecArchive/` and reference revision history
- `CHANGE_STACK.md` must identify the current spec version it is stacking against

### 4. Present the path forward

- Before major implementation begins, summarize a step-by-step development path in simple language.
- Ask for approval on that path if the project is new, ambiguous, or has major tradeoffs.
- After approval, work autonomously within that direction and only pause for important decisions or blockers.

## Reading Order

When resuming work in a repo:

1. Read `README.md` for orientation
2. Read `AGENTS.md` for working rules
3. Read `PROJECT_SPEC.md` for stable current truth
4. Read `CHANGE_STACK.md` for recent lightweight changes
5. Read `LivingSpecArchive/INDEX.md` only if older decisions matter

## Low-Churn Update Rules

### Small update

Use a small update when the new information is local, recent, or not yet worth formalizing.

Examples:

- a few implementation progress notes
- a newly discovered risk
- a short list of next actions
- a clarified but not yet promoted product idea

Action:

- update `CHANGE_STACK.md` only

### Medium update

Use a medium update when recent changes should be visible to both humans and agents, but the stable project truth is still mostly intact.

Examples:

- a meaningful shift in current priorities
- a revised immediate next step
- a clear implementation direction that does not change core architecture

Action:

- update `CHANGE_STACK.md`
- optionally make a small targeted update to `README.md`
- do not bump the spec version unless stable truth changed

### Formal update

Use a formal update when the project truth has genuinely moved.

Examples:

- approved scope change
- architecture change
- roadmap or milestone change
- important decision locked in
- enough stacked changes that the spec is stale

Action:

- archive the current spec
- bump the version once
- update `PROJECT_SPEC.md`
- update revision history and archive index
- trim promoted items from `CHANGE_STACK.md`

## Collaboration Guidance

- Explain technical decisions in plain language first, then include technical detail only if helpful.
- When there is a meaningful fork in the road, present the options, tradeoffs, and your recommendation clearly.
- Avoid asking for approval on every small step. Default to autonomous progress after the user approves a direction.
- Surface uncertainty openly. If details are missing, make a minimal reasonable assumption and note it.
- Keep the current step and next step visible to the user.

## Editing Guidance

- Prefer small, surgical edits over full-document rewrites.
- When creating from scratch, use the reference templates rather than improvising structure.
- When repairing malformed docs, restore the expected structure first, then fill content.
- Keep `AGENTS.md` general enough to stay reusable across many tasks in the repo, but specific enough to guide behavior in this project.
- Keep `README.md` approachable for a non-technical collaborator.
- Keep `CHANGE_STACK.md` short and easy to scan. It should reduce token load, not create a second giant spec.

## Common Requests

- "Start a new project from this idea and create the docs."
- "Apply the living spec system to this repo."
- "Capture today's progress without rewriting the full spec."
- "Stage these changes first, don't formalize them yet."
- "Sync the stacked changes into the official project docs."
- "Update the project truth and archive the previous stable spec."

## Output Expectations

- Report which files were created or updated.
- Distinguish between staged updates and formal spec promotions.
- Report the project spec version change only when an archive was written.
- Report the archive path you created when applicable.
- Report whether the revision history and archive index were updated.
- Mention any assumptions, especially project naming, scope framing, or promotion rationale.
