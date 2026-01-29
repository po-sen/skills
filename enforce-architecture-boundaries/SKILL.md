---
name: enforce-architecture-boundaries
description: |
  Enforce Clean Architecture + Hexagonal (Ports & Adapters) import boundaries and bounded-context
  isolation by creating a single boundary config and wiring automated checks (TS/JS, Python, Go).
  Use when adding or updating CI boundary checks, or when preventing layer/component import
  violations in clean architecture or hexagonal codebases.
---

# Enforce Architecture Boundaries (Clean/Hex)

## Purpose

Enforce import boundaries for Clean Architecture + Hexagonal using a single source of truth and
automated checks that fail on violations.

## When to Use

- Add CI checks that prevent forbidden imports across layers or bounded contexts.
- Standardize boundary rules across multiple languages or packages.
- Stabilize architecture during refactors or module extraction.

## Inputs

- Repo root and source root (prefer `src/` if present).
- Language/tooling signals (`package.json`, `tsconfig.json`, `pyproject.toml`, `requirements.txt`,
  `go.mod`).
- Existing CI workflow files (GitHub Actions preferred).
- Layout signals (`src/components/*`, `src/modules/*`, or single-module).
- Existing alias/module resolution config (tsconfig paths, Python package layout, Go module path).

## Outputs

- `architecture/boundaries.yml` as the single source of truth.
- Boundary check implementation(s) for each language present.
- Local entrypoint command (`npm run lint:boundaries`, `make lint-boundaries`,
  `just lint-boundaries`, or `task lint:boundaries`).
- CI step that fails on boundary violations.
- Brief usage note in README/CONTRIBUTING.

## Steps

1. Detect repo root and source root; prefer `src/` and keep all globs relative to that root.
2. Detect languages and existing tooling; prefer extending existing lint/CI configuration.
3. Detect architecture layout:
   - Enable bounded contexts if `components/*` or `modules/*` exists.
   - Otherwise treat as single-module.
4. Create or update `architecture/boundaries.yml`:
   - Keep rules minimal and stable.
   - Include layer rules and bounded-context isolation when enabled.
5. Implement boundary checks per language:
   - If a tool already exists, map it to `architecture/boundaries.yml`.
   - If no tool exists, add the lightest standard tool for that language.
   - If the tool cannot express all rules, add a small checker script and derive its config from
     `architecture/boundaries.yml`.
6. Add a unified local entrypoint using the repo's existing task runner or script convention.
7. Integrate CI:
   - Run on `pull_request` and default-branch pushes.
   - Cache dependencies and fail fast on violations.
   - If multiple languages exist, run each boundary checker in its own CI step/job; all must pass.
8. Validate UX:
   - Print each violation with source file, forbidden import, rule id, and a short hint.
   - Use a stable format: `BOUNDARY_VIOLATION <rule_id> <from_file> -> <to_import> : <hint>`.
9. Document how to run the check locally and how violations are reported.
10. Avoid unrelated linters, formatters, or architectural refactors.
11. Exclusions:
    - Prefer reading `exclude` globs from `architecture/boundaries.yml`.
    - If `exclude` is missing, default to excluding `node_modules`, `dist`, `build`, `generated`,
      `.venv`, `vendor`, `__pycache__`.

## Boundary Schema (Minimum)

If `references/boundaries-format.md` is not present, use this minimal schema:

```yaml
root: src
layout:
  bounded_contexts:
    enabled: true
    kind: components|modules|single
exclude:
  - "node_modules/**"
  - "dist/**"
  - "build/**"
  - "generated/**"
  - ".venv/**"
  - "vendor/**"
  - "__pycache__/**"
rules:
  - id: domain_no_outer
    from: "**/domain/**"
    forbid:
      - "**/application/**"
      - "**/adapters/**"
      - "**/infrastructure/**"
      - "**/bootstrap/**"
  - id: application_no_outer
    from: "**/application/**"
    forbid:
      - "**/adapters/**"
      - "**/infrastructure/**"
      - "**/bootstrap/**"
  - id: shared_kernel_independent
    from: "shared_kernel/**"
    forbid:
      - "components/**"
      - "modules/**"
```

## Default Boundary Rules (Required)

Always enforce at minimum:

- `**/domain/**` forbids `**/application/**`, `**/adapters/**`, `**/infrastructure/**`,
  `**/bootstrap/**`.
- `**/application/**` forbids `**/adapters/**`, `**/infrastructure/**`, `**/bootstrap/**`.
- `shared_kernel/**` forbids `components/**` and `modules/**`.
- `**/adapters/outbound/**` forbids `**/application/ports/in/**` and `**/application/use_cases/**`.
- If bounded contexts are enabled: forbid cross-context domain/application imports (allow
  `shared_kernel/**`).

## Notes

- Use `references/boundaries-format.md` for the boundary schema and default rules.
- Use tool guidance references:
  - `references/tooling-node.md`
  - `references/tooling-python.md`
  - `references/tooling-go.md`
- Use `references/tooling-ci.md` for a GitHub Actions baseline workflow.
- Prefer fail-fast rules; use temporary allowlists only when explicitly requested.
- Keep `shared_kernel/` dependency-free with respect to feature modules.
