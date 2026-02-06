---
name: spec-driven-development
description: >-
  Convert rough ideas into Spec-Driven Development artifacts: problem statement, requirements,
  design, task plan, and test plan. Use when the user asks for SDD/specs, to clarify requirements,
  or to turn a rough idea into an implementable plan before coding.
---

# spec-driven-development

## Purpose

- Turn rough ideas into a clear, verifiable spec package before coding.

## When to Use

- Follow the trigger guidance in the frontmatter description.

## File IO rule

- Always create/update files in the repo (not only chat output).
- Must create `specs/YYYY-MM-DD-slug/` and write the spec files there.
- If the user only wants a draft, still write files, but mark them via the document header:
  - Set `status: DRAFT` in YAML frontmatter.
  - Do NOT add any text before the leading `---` (keeps frontmatter valid).

## Inputs

- Rough idea or problem statement.
- Target users or stakeholders and goals.
- In-scope vs out-of-scope.
- Constraints (tech, time, cost, compliance).
- Integrations or dependencies.
- Non-functional requirements or quality targets.

## Outputs

- A spec folder under `specs/YYYY-MM-DD-slug/`.
- Quick mode required output:
  - `00_problem.md`
  - `01_requirements.md`
  - `03_tasks.md`
- Quick mode optional output:
  - `04_test_plan.md`
- Full mode output:
  - `00_problem.md`
  - `01_requirements.md`
  - `02_design.md`
  - `03_tasks.md`
  - `04_test_plan.md`
- Explicit assumptions and open questions.

## Conventions

- Spec folder: `specs/YYYY-MM-DD-slug/` (slug = kebab-case, short and specific).

### Document header rules

- Every spec file MUST start with YAML frontmatter (`---` ... `---`).
- Fill these fields in every produced file:
  - `spec_date`: real date like `2026-01-31` (templates use `null`)
  - `slug`: real slug like `payment-webhook-retry` (templates use `null`)
  - `mode`: `Quick` or `Full` (match selected mode)
  - `status`: `DRAFT`, `READY`, or `DONE`
  - `owners`: `[]` allowed only in DRAFT; add at least one owner before READY/DONE
  - `depends_on`: `[]` or a list of prerequisite spec folder names (`YYYY-MM-DD-slug`) that must be
    `DONE` before this spec can become `READY`
  - Keep `spec_date`, `slug`, `mode`, `status`, and `depends_on` consistent across docs in the same
    spec folder.
- Links MUST NOT point to non-existent files:
  - Keep a consistent key set in all docs: `problem`, `requirements`, `design`, `tasks`,
    `test_plan`.
  - Use `null` when a doc is not produced (e.g., `links.design: null` in Quick mode).
  - If you later produce the doc, update links in the other spec docs immediately.

### Status lifecycle

- `DRAFT`: spec is being prepared; placeholders or open questions may remain.
- `READY`: spec is complete, spec-lint passes, and implementation can start.
- `DONE`: implementation and validation are complete, and the spec reflects final behavior/scope.

### Cross-spec dependencies

- Use `depends_on` to declare prerequisite specs for this spec.
- Format:

  - No prerequisites: `depends_on: []`
  - With prerequisites:

    ```yaml
    depends_on:
      - 2026-01-20-auth-foundation
      - 2026-01-25-shared-api-contract
    ```

  - Non-empty inline list form is not supported: do not use `depends_on: [a, b]`.

- Dependency gate:
  - Before setting this spec to `READY`, every `depends_on` entry must resolve to an existing folder
    under `specs/` and that folder must be folder-wide `status: DONE`.
  - `depends_on` must not include the current spec's own slug.
- Source of truth:
  - `00_problem.md` is canonical for dependency gate checks.
  - Keep `depends_on` aligned across all spec docs in the same folder to avoid drift.
  - Dependency order follows `00_problem.md`; other docs must match the same order.

### Slug rules

- Source: 3-5 keywords from the problem or title.
- Format: lowercase, kebab-case, no punctuation.
- Remove filler words (a/an/the/of/for/and, etc.).
- Max length: 40 characters.
- Example: `add-user-login`.

### IDs and traceability

- Requirement IDs:
  - Functional: `FR-001`, `FR-002`, ...
  - Non-functional: `NFR-001`, ...
- Task IDs: `T-001`, `T-002`, ...
- Test case IDs: `TC-001`, `TC-002`, ...
- Traceability rule:
  - Every `T-XXX` MUST reference one or more `FR/NFR` IDs.
  - Every `TC-XXX` MUST reference one or more `FR/NFR` IDs.

## Quality bar

- Requirements must be verifiable (acceptance criteria / measurable targets, e.g., p95 latency <=
  200 ms).
- Design must cover: flows, data, contracts, failure modes, observability, security.
- Task plan must be ordered, small, independently verifiable, and traceable.

## Modes

### Quick mode (default for small changes)

Use when:

- 1-2 endpoints / a small feature flag / a simple refactor
- No new integrations, no new persistent data model, no risky rollout

Produce:

- Required:
  - `00_problem.md`
  - `01_requirements.md`
  - `03_tasks.md`
- Optional:
  - `04_test_plan.md` (recommended)

Skip:

- `02_design.md` unless any of these are true:
  - New DB schema / migrations
  - New external integration
  - Non-trivial failure modes / async flow
  - Meaningful NFR impact (latency, availability, security)

### Full mode

Use when any of the "Skip" triggers above apply. Produce all 5 files. If unsure, default to Quick
during scaffolding and re-evaluate after clarifying questions.

## Steps

1. Scaffold first (must happen before writing content):
   - Derive `YYYY-MM-DD` and `slug` using "Slug rules".
   - Create `specs/YYYY-MM-DD-slug/` if missing.
   - Create required Quick-mode files by copying templates (not empty files):
     - `00_problem.md` from `assets/00_problem_template.md`
     - `01_requirements.md` from `assets/01_requirements_template.md`
     - `03_tasks.md` from `assets/03_tasks_template.md`
   - Populate document headers (`spec_date`, `slug`, `mode`, `status`, `owners`, `depends_on`)
     immediately.
     - Default `mode: Quick` and `status: DRAFT` during scaffolding (safe defaults).
     - After mode is decided, update `mode` (and `links`) across all produced files to match.
2. Ask the minimum clarifying questions needed to fill gaps (goal/value, scope, constraints,
   acceptance criteria, integrations, NFRs, and upstream spec dependencies). If answers are missing,
   state assumptions explicitly.
   - If mode is unclear, keep `mode: Quick` from scaffolding and confirm after these questions.
3. Decide mode (Quick or Full) using the triggers under "Modes" and record the decision and
   rationale in `03_tasks.md` under "Mode decision".
   - After deciding mode:
     - Update YAML frontmatter `mode` in every already-produced spec file to match (Quick/Full).
     - If switching to Full:
       - Create `02_design.md` from template and set `links.design` to `02_design.md`.
       - Create `04_test_plan.md` from template and set `links.test_plan` to `04_test_plan.md`.
       - After creating new docs, immediately update their YAML frontmatter fields (`spec_date`,
         `slug`, `mode`, `status`, and `links`) to match the selected mode.
       - Update links in `00_problem.md`, `01_requirements.md`, `03_tasks.md`, and
         `04_test_plan.md`:
         - `links.design: 02_design.md`
         - `links.test_plan: 04_test_plan.md` (in `00_problem.md`, `01_requirements.md`,
           `03_tasks.md`)
     - If staying Quick:
       - Keep `links.design: null`.
       - If you decide to produce `04_test_plan.md`, create it and set `links.test_plan` in
         `00_problem.md`, `01_requirements.md`, and `03_tasks.md`.
       - Keep `links.design: null` in `04_test_plan.md` for Quick mode.
4. Fill `00_problem.md` from `assets/00_problem_template.md` with concrete context, goals,
   non-goals, and success metrics.
5. Fill `01_requirements.md` from `assets/01_requirements_template.md`. Ensure every functional
   requirement has acceptance criteria and NFRs are measurable.
6. If Full mode (or any "Skip" triggers apply):
   - Ensure `02_design.md` exists (create if missing), then fill it from
     `assets/02_design_template.md`.
7. Fill `03_tasks.md` from `assets/03_tasks_template.md`. Order tasks, make each independently
   verifiable, and link tasks back to requirements. Keep task validation steps even when a separate
   test plan exists.
8. If producing `04_test_plan.md`:
   - In Full mode: MUST produce `04_test_plan.md`.
   - In Quick mode: OPTIONAL (recommended) to produce `04_test_plan.md`.
   - Ensure `04_test_plan.md` exists (create if missing), then fill it from
     `assets/04_test_plan_template.md`.
   - Cover unit/integration/e2e as appropriate, plus edge cases and NFR verification.
   - If produced:
     - Set `links.test_plan: 04_test_plan.md` in `00_problem.md`, `01_requirements.md`,
       `03_tasks.md`.
     - If Full mode, set `links.design: 02_design.md` in `04_test_plan.md`.
9. Provide a readiness checklist. Do not change code until the spec package exists. If the user
   requests immediate coding, produce a minimal spec package first and proceed with explicit,
   labeled assumptions (do not invent integrations/constraints silently).
10. If the Ready-to-code checklist is satisfied:
    - Before setting `READY`, run the spec-lint checks below and ensure they pass.
    - If `depends_on` is non-empty, every dependency must already be `DONE`; otherwise keep this
      spec in `DRAFT`.
    - Update `status: READY` in the YAML frontmatter of every produced spec file in the folder (keep
      statuses consistent across docs).
11. After implementation and validation tied to the spec are complete:
    - Update `status: DONE` in the YAML frontmatter of every produced spec file in the folder (keep
      statuses consistent across docs).

## Spec-lint (recommended)

Run these checks against the spec folder before marking `status: READY` or `status: DONE`. The
canonical lint implementation is `scripts/spec-lint.sh`.

```bash
# From repo root:
SPEC_DIR="specs/YYYY-MM-DD-slug" bash skills/spec-driven-development/scripts/spec-lint.sh

# Or from the skill directory:
SPEC_DIR="specs/YYYY-MM-DD-slug" bash scripts/spec-lint.sh
```

## Ready-to-code checklist

### Quick mode checklist

- [ ] `specs/YYYY-MM-DD-slug/` exists and contains `00_problem.md`, `01_requirements.md`,
      `03_tasks.md`
- [ ] Document headers are filled (`spec_date`, `slug`, `mode`, `status`, `owners`, `depends_on`)
      with real values (no `null`/`[]` placeholders except `depends_on: []` when no prerequisites)
- [ ] `owners` includes at least one owner or team
- [ ] Every `depends_on` entry points to an existing `specs/YYYY-MM-DD-slug/` folder and each
      dependency folder is `status: DONE`
- [ ] Frontmatter values are consistent across docs (`spec_date`, `slug`, `mode`, `status`,
      `depends_on`)
- [ ] Every spec doc has the full `links` key set (`problem`, `requirements`, `design`, `tasks`,
      `test_plan`)
- [ ] Mode decision and rationale is recorded in `03_tasks.md`
- [ ] Every `FR-XXX` has acceptance criteria
- [ ] Every `NFR-XXX` is measurable (targets, limits, SLO-like) if applicable
- [ ] Every `T-XXX` links to `FR/NFR` IDs
- [ ] If `04_test_plan.md` is skipped, `03_tasks.md` includes explicit validation steps per task
- [ ] In Quick mode, `links.design` remains `null`
- [ ] All YAML links are valid (either `null` or pointing to existing files)
- [ ] Spec-lint checks pass
- [ ] Set `status: READY` across produced docs (keep statuses consistent)

### Full mode checklist

- [ ] `specs/YYYY-MM-DD-slug/` exists and contains all 5 files
- [ ] Document headers are filled (`spec_date`, `slug`, `mode`, `status`, `owners`, `depends_on`)
      with real values (no `null`/`[]` placeholders except `depends_on: []` when no prerequisites)
- [ ] `owners` includes at least one owner or team
- [ ] Every `depends_on` entry points to an existing `specs/YYYY-MM-DD-slug/` folder and each
      dependency folder is `status: DONE`
- [ ] Frontmatter values are consistent across docs (`spec_date`, `slug`, `mode`, `status`,
      `depends_on`)
- [ ] Every spec doc has the full `links` key set (`problem`, `requirements`, `design`, `tasks`,
      `test_plan`)
- [ ] Every `FR-XXX` has acceptance criteria
- [ ] Every `NFR-XXX` is measurable (targets, limits, SLO-like)
- [ ] Design covers flows, data, contracts, failure modes, observability, security
- [ ] Every `T-XXX` links to `FR/NFR` IDs
- [ ] Every `TC-XXX` links to `FR/NFR` IDs
- [ ] All YAML links are valid (either `null` or pointing to existing files)
- [ ] Spec-lint checks pass
- [ ] Set `status: READY` across all docs (keep statuses consistent)

## Done checklist

- [ ] Implementation tasks in `03_tasks.md` are complete
- [ ] Validation evidence is recorded (tests/manual checks/metrics as applicable)
- [ ] Spec docs reflect final behavior and scope (including any approved changes)
- [ ] Set `status: DONE` across produced docs (keep statuses consistent)

## Notes

- Treat the spec as the source of truth; update the spec before changing code.
- Keep templates minimal. Adapt to existing repo conventions (ADR/RFC/docs) but preserve the section
  structure.
- Example spec package (Full mode): `examples/specs/2026-02-06-lint-pass-example/`.
- Avoid inventing integrations or requirements. Ask or mark as assumptions.
- Prefer concise, testable statements over narrative prose.
- Use `DONE` only after implementation and validation are complete; otherwise keep `READY`.
