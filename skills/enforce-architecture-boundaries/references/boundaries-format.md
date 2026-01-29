# boundaries.yml format

## Required keys

- `root`: Source root relative to repo root (prefer `src`).
- `layout.bounded_contexts.enabled`: `true` or `false`.
- `layout.bounded_contexts.kind`: `components`, `modules`, or `single`.
- `rules`: Ordered list of rule objects.
- `exclude`: Optional list of globs to ignore (recommended).

## Optional keys (recommended)

- `paths`: Named glob aliases used by generators or tooling mapping.

## Rule shape (minimal)

- `id`: Stable identifier used in error messages.
- `from`: Glob or path for the source side.
- `forbid`: List of globs that must not be imported.
- `allow`: Optional list of globs that are allowed (used for bounded-context rules).
- `enabled_when_any_exists`: Optional globs; enable the rule only if any path exists.
- `forbid_cross_context_domain_application`: Optional boolean for bounded-context isolation.

## Semantics: forbid_cross_context_domain_application

When `forbid_cross_context_domain_application: true` and bounded contexts are enabled:

- For any context root `components/<A>/` (or `modules/<A>/`), forbid imports to
  `components/<B>/{domain,application}/**` (or `modules/<B>/{domain,application}/**`) for `A != B`,
  except paths matched by `allow` (e.g., `shared_kernel/**`).

## Example

Recommended location: `architecture/boundaries.yml`.

```yaml
root: src
layout:
  bounded_contexts:
    enabled: true
    kind: components
exclude:
  - "node_modules/**"
  - "dist/**"
  - "build/**"
  - "generated/**"
  - ".venv/**"
  - "vendor/**"
  - "__pycache__/**"
paths:
  shared_kernel: shared_kernel/**
  domain: "**/domain/**"
  application: "**/application/**"
  adapters_inbound: "**/adapters/inbound/**"
  adapters_outbound: "**/adapters/outbound/**"
  infrastructure: "**/infrastructure/**"
  bootstrap: "**/bootstrap/**"
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
  - id: outbound_no_inbound_or_usecases
    from: "**/adapters/outbound/**"
    forbid:
      - "**/application/ports/in/**"
      - "**/application/use_cases/**"
  - id: no_cross_context_direct_imports
    enabled_when_any_exists:
      - "components/**"
      - "modules/**"
    allow:
      - "shared_kernel/**"
    forbid_cross_context_domain_application: true
```

## Mapping guidance

- Treat globs as relative to `root`.
- Apply `exclude` first before evaluating rules.
- Rule evaluation precedence:
  - If an import matches `exclude`, ignore it.
  - For a given rule, if a dependency matches both `allow` and `forbid`, `allow` wins (it is an
    explicit exception).
  - Rules are evaluated independently; a single violating rule should fail the check.
- Expand bounded-context rules by component/module name when generating tool configs.
- Keep rule ids stable to make CI diffs readable.
