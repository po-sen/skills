---
name: sdd-spec
description: >-
  Convert rough ideas into Spec-Driven Development artifacts: problem statement, requirements,
  design, task plan, and test plan. Use when the user asks for SDD/specs, to clarify requirements,
  or to turn a rough idea into an implementable plan before coding.
---

# sdd-spec

## Purpose

- Turn rough ideas into a clear, verifiable spec package before coding.

## When to Use

- Follow the trigger guidance in the frontmatter description.

## File IO rule

- Always create/update files in the repo (not only chat output).
- Must create `specs/<YYYY-MM-DD>-<slug>/` and write the spec files there.
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

- A spec folder under `specs/<YYYY-MM-DD>-<slug>/`.
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

- Spec folder: `specs/<YYYY-MM-DD>-<slug>/` (slug = kebab-case, short and specific).

### Document header rules

- Every spec file MUST start with YAML frontmatter (`---` ... `---`).
- Fill these fields in every produced file:
  - `spec_date`: `<YYYY-MM-DD>` (real date)
  - `slug`: `<slug>` (real slug)
  - `mode`: `Quick` or `Full` (match selected mode)
  - `status`: `DRAFT` or `READY`
  - `owners`: at least one owner/team if known, else keep placeholder
- Links MUST NOT point to non-existent files:
  - Use `null` when a doc is not produced (e.g., `links.design: null` in Quick mode).
  - If you later produce the doc, update links in the other spec docs immediately.

### Slug rules

- Source: 3-5 keywords from the problem or title.
- Format: lowercase, kebab-case, no punctuation.
- Remove filler words (a/an/the/of/for/and, etc.).
- Max length: 40 characters.

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

- Requirements must be verifiable (acceptance criteria / measurable targets).
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

Use when any of the "Skip" triggers above apply. Produce all 5 files.

## Steps

0. Scaffold first (must happen before writing content):
   - Derive `<YYYY-MM-DD>` and `<slug>` using "Slug rules".
   - Create `specs/<YYYY-MM-DD>-<slug>/` if missing.
   - Create required Quick-mode files by copying templates (not empty files):
     - `00_problem.md` from `assets/00_problem_template.md`
     - `01_requirements.md` from `assets/01_requirements_template.md`
     - `03_tasks.md` from `assets/03_tasks_template.md`
   - Populate document headers (`spec_date`, `slug`, `mode`, `status`) immediately.
     - Default `mode: Quick` and `status: DRAFT` during scaffolding (safe defaults).
     - After mode is decided, update `mode` (and `links`) across all produced files to match.
1. Ask the minimum clarifying questions needed to fill gaps (goal/value, scope, constraints,
   acceptance criteria, integrations, NFRs). If answers are missing, state assumptions explicitly.
2. Decide mode (Quick or Full) using the triggers under "Modes" and record the decision and
   rationale in `03_tasks.md` (or `00_problem.md` if you prefer).
   - After deciding mode:
     - Update YAML frontmatter `mode` in every already-produced spec file to match (Quick/Full).
     - If switching to Full:
       - Create `02_design.md` from template and set `links.design` to `02_design.md`.
       - Create `04_test_plan.md` from template and set `links.test_plan` to `04_test_plan.md`.
       - After creating new docs, immediately update their YAML frontmatter fields (`spec_date`,
         `slug`, `mode`, `status`, and `links`) to match the selected mode.
       - Update links in `00_problem.md`, `01_requirements.md`, `03_tasks.md`:
         - `links.design: 02_design.md`
         - `links.test_plan: 04_test_plan.md`
     - If staying Quick:
       - Keep `links.design: null`.
       - If you decide to produce `04_test_plan.md`, create it and set `links.test_plan` in all
         produced docs.
3. Fill `00_problem.md` from `assets/00_problem_template.md` with concrete context, goals,
   non-goals, and success metrics.
4. Fill `01_requirements.md` from `assets/01_requirements_template.md`. Ensure every functional
   requirement has acceptance criteria and NFRs are measurable.
5. If Full mode (or any "Skip" triggers apply):
   - Ensure `02_design.md` exists (create if missing), then fill it from
     `assets/02_design_template.md`.
6. Fill `03_tasks.md` from `assets/03_tasks_template.md`. Order tasks, make each independently
   verifiable, and link tasks back to requirements.
7. If producing `04_test_plan.md`:
   - In Full mode: MUST produce `04_test_plan.md`.
   - In Quick mode: OPTIONAL (recommended) to produce `04_test_plan.md`.
   - Ensure `04_test_plan.md` exists (create if missing), then fill it from
     `assets/04_test_plan_template.md`.
   - Cover unit/integration/e2e as appropriate, plus edge cases and NFR verification.
   - If produced:
     - Set `links.test_plan: 04_test_plan.md` in `00_problem.md`, `01_requirements.md`,
       `03_tasks.md`.
8. Provide a readiness checklist. Do not change code until the spec package exists. If the user
   requests immediate coding, produce a minimal spec package first and proceed with explicit,
   labeled assumptions (do not invent integrations/constraints silently).
9. If the Ready-to-code checklist is satisfied:
   - Before setting `READY`, run the spec-lint checks below and ensure they pass.
   - Update `status: READY` in the YAML frontmatter of every produced spec file in the folder (keep
     statuses consistent across docs).

## Spec-lint (recommended)

Run these checks against the spec folder before marking `status: READY`.

```bash
# Replace <SPEC_DIR> with specs/<YYYY-MM-DD>-<slug>
SPEC_DIR="<SPEC_DIR>"

set -euo pipefail
fail() { echo "❌ $1" >&2; exit 1; }

# 1) Header placeholders must be gone before READY
if rg -n "<YYYY-MM-DD>|<slug>|<name-or-team>" "$SPEC_DIR"; then
  fail "header placeholders remain"
fi

# 2) Traceability placeholders must be gone
if rg -n "FR-\\?\\?\\?|NFR-\\?\\?\\?|T-\\?\\?\\?|TC-\\?\\?\\?" "$SPEC_DIR"; then
  fail "traceability placeholders remain"
fi

# 3) Required link integrity (no dangling links)
if rg -n "^\\s*design:\\s*02_design\\.md\\s*$" "$SPEC_DIR" >/dev/null; then
  test -f "$SPEC_DIR/02_design.md" || fail "links.design points to missing 02_design.md"
fi
if rg -n "^\\s*test_plan:\\s*04_test_plan\\.md\\s*$" "$SPEC_DIR" >/dev/null; then
  test -f "$SPEC_DIR/04_test_plan.md" || fail "links.test_plan points to missing 04_test_plan.md"
fi

# 4) Mode consistency (no mixed Quick/Full in the same spec folder)
HAS_QUICK=0
HAS_FULL=0
if rg -n "^mode:\\s*Quick\\s*$" "$SPEC_DIR" >/dev/null; then HAS_QUICK=1; fi
if rg -n "^mode:\\s*Full\\s*$" "$SPEC_DIR" >/dev/null; then HAS_FULL=1; fi
if [ "$HAS_QUICK" -eq 1 ] && [ "$HAS_FULL" -eq 1 ]; then
  fail "mode mismatch: both Quick and Full exist in the same spec folder"
fi

# 5) Full mode completeness + link sanity
if [ "$HAS_FULL" -eq 1 ]; then
  test -f "$SPEC_DIR/02_design.md" || fail "Full mode requires 02_design.md"
  test -f "$SPEC_DIR/04_test_plan.md" || fail "Full mode requires 04_test_plan.md"
  if rg -n "^\\s*design:\\s*null\\s*$" "$SPEC_DIR"; then
    fail "Full mode must not have links.design: null"
  fi
  if rg -n "^\\s*test_plan:\\s*null\\s*$" "$SPEC_DIR"; then
    fail "Full mode must not have links.test_plan: null"
  fi
fi

# 6) Status consistency (no mixed READY/DRAFT in the same spec folder)
HAS_READY=0
HAS_DRAFT=0
if rg -n "^status:\\s*READY\\s*$" "$SPEC_DIR" >/dev/null; then HAS_READY=1; fi
if rg -n "^status:\\s*DRAFT\\s*$" "$SPEC_DIR" >/dev/null; then HAS_DRAFT=1; fi
if [ "$HAS_READY" -eq 1 ] && [ "$HAS_DRAFT" -eq 1 ]; then
  fail "status mismatch: both READY and DRAFT exist in the same spec folder"
fi
```

## Ready-to-code checklist

### Quick mode checklist

- [ ] `specs/<YYYY-MM-DD>-<slug>/` exists and contains `00_problem.md`, `01_requirements.md`,
      `03_tasks.md`
- [ ] Document headers are filled (`spec_date`, `slug`, `mode`, `status`) with real values (no
      `<...>` placeholders)
- [ ] Mode decision and rationale is recorded (and why `02_design.md` is skipped)
- [ ] Every `FR-XXX` has acceptance criteria
- [ ] Every `NFR-XXX` is measurable (targets, limits, SLO-like) if applicable
- [ ] Every `T-XXX` links to `FR/NFR` IDs
- [ ] If `04_test_plan.md` is skipped, `03_tasks.md` includes explicit validation steps per task
- [ ] Spec-lint checks pass
- [ ] Set `status: READY` across produced docs (keep statuses consistent)

### Full mode checklist

- [ ] `specs/<YYYY-MM-DD>-<slug>/` exists and contains all 5 files
- [ ] Document headers are filled (`spec_date`, `slug`, `mode`, `status`) with real values (no
      `<...>` placeholders)
- [ ] Every `FR-XXX` has acceptance criteria
- [ ] Every `NFR-XXX` is measurable (targets, limits, SLO-like)
- [ ] Design covers flows, data, contracts, failure modes, observability, security
- [ ] Every `T-XXX` links to `FR/NFR` IDs
- [ ] Every `TC-XXX` links to `FR/NFR` IDs
- [ ] Spec-lint checks pass
- [ ] Set `status: READY` across all docs (keep statuses consistent)

## Notes

- Treat the spec as the source of truth; update the spec before changing code.
- Keep templates minimal. Adapt to existing repo conventions (ADR/RFC/docs) but preserve the section
  structure.
- Avoid inventing integrations or requirements. Ask or mark as assumptions.
- Prefer concise, testable statements over narrative prose.
