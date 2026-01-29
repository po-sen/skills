# Python tooling guidance

## Default tool

Prefer `import-linter` when the repo has a clear top-level package and imports resolve cleanly.
Fallback to a small AST-based checker script when package resolution is ambiguous.

## Minimal workflow

1. Add `import-linter` to dev dependencies.
2. Configure contracts in `pyproject.toml` that mirror `architecture/boundaries.yml` rules.
3. Add a local command that runs `lint-imports` and fails on violations.

## Mapping tips

- Derive the root package name from the source layout.
- Map boundary rules to "forbidden" contracts.
- Use a script fallback when the repo is not structured as a Python package.
