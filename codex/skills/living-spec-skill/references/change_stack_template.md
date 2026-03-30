# CHANGE STACK TEMPLATE

Use this template when creating or normalizing `CHANGE_STACK.md`.

````md
# CHANGE STACK

Tracks lightweight updates that are not yet worth a formal `PROJECT_SPEC.md` revision.

Current stable spec:
- [PROJECT_SPEC.md](PROJECT_SPEC.md)
- Stable version: `vX.X`

## Promotion Rule

Promote these items into `PROJECT_SPEC.md` only when:

- the user asks to sync or formalize docs
- stable project truth has materially changed
- architecture, roadmap, scope, or key decisions changed
- enough approved changes have accumulated that the spec is drifting

## Active Items

### YYYY-MM-DD

- status: approved
  area: roadmap
  note: Short bullet describing the recent change or decision.

- status: implemented
  area: implementation
  note: Short bullet describing what now exists or changed.

## Recently Promoted

- YYYY-MM-DD: Promoted into `vX.X`
````
