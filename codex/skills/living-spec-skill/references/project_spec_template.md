# PROJECT SPEC TEMPLATE

Use this template when creating a new `PROJECT_SPEC.md` or restoring a broken spec to the required layout.

Use the ASCII-safe headings below unless the existing spec already uses emoji and the user wants to preserve them.

````md
# PROJECT SPECIFICATION (LIVING DOCUMENT)

Related documents:
- Human/project overview: [README.md](README.md)
- Repo agent instructions: [AGENTS.md](AGENTS.md)
- Recent lightweight updates: [CHANGE_STACK.md](CHANGE_STACK.md)
- Archive catalog: [LivingSpecArchive/INDEX.md](LivingSpecArchive/INDEX.md)

## 1. REVISION HEADER (HUMAN READABLE)

**Version:** vX.X  
**Last Updated:** YYYY-MM-DD  
**Status:** Planning

### What changed in this revision
- ...

---

## 2. ONE-PAGER OVERVIEW

### Product Vision
...

### Core Problem
...

### Target Outcome
...

### Key Features
...

### System Concept
...

### Current State
...

---

## 3. CURRENT ARCHITECTURE

...

---

## 4. DEVELOPMENT ROADMAP

...

---

## 5. DECISIONS & RATIONALE

...

---

## 6. KNOWN GAPS / OPEN QUESTIONS

...

---

## 7. MACHINE-READABLE STATE

```yaml
project:
  name: ""
  version: "vX.X"
  status: ""

product:
  vision: ""
  core_problem: ""
  target_outcome: ""

features:
  active:
    - name: ""
      status: ""
  planned:
    - name: ""

architecture:
  components:
    - name: ""
      role: ""
  data_flow:
    - step: ""

roadmap:
  current_phase: ""
  next_steps:
    - ""

decisions:
  - id: ""
    description: ""
    rationale: ""

open_questions:
  - ""

revision:
  last_updated: ""
  summary: ""
```

---

## 8. ARCHIVE & REVISION HISTORY

Archive location:
- [LivingSpecArchive/](LivingSpecArchive/)
- [LivingSpecArchive/INDEX.md](LivingSpecArchive/INDEX.md)

Revision history:

| Version | Date | Archive File | Summary |
|---|---|---|---|
| vX.X | YYYY-MM-DD | `LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md` | ... |
````

Archive files must use this naming pattern:

`LivingSpec_<ProjectName>_<YYYY-MM-DD>_vX.X.md`
