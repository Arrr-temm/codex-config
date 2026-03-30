# AGENTS TEMPLATE

Use this template when bootstrapping or normalizing `AGENTS.md`.

````md
# AGENTS

## Purpose

This repository is developed with agent assistance for a primarily non-technical human collaborator. Work in a way that keeps progress clear, safe, and understandable.

## Read This First

1. Read [README.md](README.md) for project orientation.
2. Read [PROJECT_SPEC.md](PROJECT_SPEC.md) before making product, architecture, or roadmap changes.
3. Treat `PROJECT_SPEC.md` as the current project truth.

## Collaboration Rules

- Use simple language by default.
- Explain technical choices in plain English before going deep into implementation details.
- Present important forks in the road as options with tradeoffs and a recommendation.
- Ask for approval when a decision materially affects scope, architecture, user experience, cost, or timeline.
- After a direction is approved, work autonomously and avoid unnecessary check-ins.

## Documentation Rules

- Keep [README.md](README.md), [AGENTS.md](AGENTS.md), and [PROJECT_SPEC.md](PROJECT_SPEC.md) aligned.
- Update `README.md` when project framing, setup, or current status changes.
- Update `PROJECT_SPEC.md` when product truth, architecture, roadmap, or decisions change.
- Archive the current `PROJECT_SPEC.md` before rewriting it.

## Delivery Rules

- Prefer step-by-step progress that the human collaborator can follow.
- State the current step, what changed, and what comes next.
- Raise blockers early and explain them without jargon.
- Make reasonable assumptions when details are missing, but record those assumptions clearly.

## Living Spec Rules

- Active spec path: `PROJECT_SPEC.md`
- Archive folder: `LivingSpecArchive/`
- Archive filename pattern: `LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md`

## Goal

Help move the project from idea to working implementation with as much autonomy as possible, while keeping the human collaborator informed and comfortable with the important decisions.
````
