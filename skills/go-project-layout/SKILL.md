---
name: go-project-layout
description: |
  Enforce Go project directory structure using golang-standards/project-layout with pragmatic
  defaults and official Go module/package guidance. Use when creating or refactoring Go repos so
  code placement, visibility, and boundaries stay consistent.
---

# Go Project Layout

## Purpose

- Place Go code in predictable directories with clear visibility boundaries.
- Keep layouts minimal by default and scale only when project complexity requires it.

## When to Use

- Follow the trigger guidance in the frontmatter description.

## Inputs

- Change request or feature scope.
- Existing tree (`go.mod`, folders, binaries/libraries, deployment targets).
- Whether the repo is single-binary, multi-binary, service, or shared library.
- Existing constraints (monorepo rules, CI paths, proto/openapi generation, container packaging).

## Outputs

- New or updated directory tree that matches the project type.
- Files moved/created in the correct directories with imports fixed.
- Updated Go entry points and package boundaries (`internal` vs `pkg`) with no cycles.
- Validation evidence from `go list ./...` and the chosen test workflow (`go test -short ./...`,
  plus full/e2e runs when required), or a clear reason if skipped.

## Decision Cheatsheet

- Single-binary service: `cmd/<app>/main.go` plus `internal/<domain>/...`.
- Multi-binary repo: `cmd/<app>/main.go` per app plus `internal/<app>/<domain>/...`.
- Reusable library: organize packages under the module root (for example `foo/`, `bar/`), and use
  optional `pkg/<name>` only for intentional, stable public APIs.
- Mixed apps plus library: keep app logic in `internal/`; expose only intentional public APIs in
  `pkg/`.

## Steps

1. Detect current shape before editing:
   - Run `go env GOMOD` and `go env GOWORK`, then scan top-level folders.
   - If `go env GOMOD` is empty or `/dev/null`, the repo likely has no module yet. Initialize with
     `go mod init <module>` unless the task explicitly disallows it.
   - If module initialization is intentionally skipped, record the reason and skip `go list ./...`
     until a module exists.
   - If `go env GOWORK` is non-empty, the repo may be in workspace mode. Keep layout decisions
     scoped to the current module unless the task explicitly targets workspace-level structure.
   - If a module exists, run `go list ./...` and ensure no import cycles.
2. Classify the repo:
   - Single deployable app
   - Multiple deployable binaries
   - Reusable library
   - Mixed (apps + library)
3. Start from the smallest viable layout:
   - Keep `go.mod` and `go.sum` at repo root.
   - Do not add `src/`; place Go code at module root or subfolders.
4. Place executable entry points in `cmd/<app>/main.go`:
   - `cmd` only contains wiring/bootstrap code.
   - Move business logic out of `cmd` into packages.
5. Place non-exported app code in `internal/`:
   - Use `internal/<domain>` or `internal/<app>/<domain>` for services, handlers, repositories, and
     use cases.
   - Treat `internal` as default for code not intended for external import.
   - Decision rule:
     - Single-binary service: prefer `internal/<domain>` to keep structure shallow.
     - Multi-binary or mixed apps: prefer `internal/<app>/<domain>` to avoid collisions.
6. Use `pkg/` only for genuinely reusable public packages:
   - If a package is not meant for outside consumers, keep it in `internal/`.
   - Avoid mirroring everything under both `internal/` and `pkg/`.
   - For any `pkg/` package, require clear ownership, semantic version tags, and compatibility
     commitments.
   - If publishing v2+, ensure the module path uses the `/vN` suffix (for example `.../v2`).
7. Add optional folders only when they have concrete artifacts:
   - `api/` for OpenAPI, protobuf, or API contracts and generator settings only.
   - `configs/` for example/default config files (not secrets).
   - `scripts/` for dev/CI scripts.
   - `build/` and `deployments/` for packaging/deploy manifests.
   - `test/` for black-box/integration test assets; keep unit tests next to code.
   - Do not place handlers, controllers, or server implementations in `api/`.
   - If `test/` contains slow tests, isolate them with build tags (for example
     `//go:build integration` or `//go:build e2e`) or `-short` workflows.
8. Keep package boundaries clean:
   - Prevent cyclic imports (`go list ./...` must pass).
   - Keep package names short, lowercase, and purpose-driven.
   - Prefer composition interfaces near consumers to reduce cross-package coupling.
9. For multi-binary repos, share code through `internal/` first:
   - Use `internal/platform` or `internal/shared` only when sharing is real and stable.
   - Promote to `pkg/` only when external reuse is intentional and versioned.
10. For multi-module needs, split modules deliberately:
    - Default to one module per repo.
    - Introduce extra modules only with explicit release or ownership boundaries.
    - If multiple modules are required, wire them with `go work` and document ownership.
11. Verify after edits:
    - Use the repo/CI formatter when present (for example `goimports` or `golangci-lint` format
      rules); otherwise run `go fmt ./...`.
    - `go mod tidy`
    - `go list ./...`
    - Prefer `go test -short ./...` for default CI/local verification.
    - Run full tests separately when needed (for example on nightly/release: `go test ./...`).
    - Run e2e tests separately with explicit build tags/jobs (for example
      `go test -tags=e2e ./...`).
    - `go vet ./...` (when enabled in repo/CI)
12. Document non-obvious layout decisions:
    - Add or update top-level comments or README sections when creating new major folders.
    - Explain why `pkg/` exists (or why everything stays in `internal/`).

## Notes

- `golang-standards/project-layout` is a widely used reference, not an official Go standard; treat
  it as a toolbox, not a mandatory checklist.
- Common baseline for applications:

```text
.
├── go.mod
├── go.sum
├── cmd/
│   └── <app>/main.go
├── internal/
│   ├── <domain>/...        # or internal/<app>/<domain>/...
│   └── platform/           # optional, only for real shared platform code
├── api/            # optional
├── configs/        # optional
├── scripts/        # optional
├── build/          # optional
├── deployments/    # optional
└── test/           # optional integration/e2e assets
```

- Example tree: single-binary service.

```text
.
├── go.mod
├── cmd/
│   └── billing-api/main.go
└── internal/
    ├── billing/
    │   ├── service.go
    │   └── repository.go
    └── platform/
        └── httpserver/server.go
```

- Example tree: multi-binary repo.

```text
.
├── go.mod
├── cmd/
│   ├── api/main.go
│   └── worker/main.go
└── internal/
    ├── api/
    │   └── orders/handler.go
    └── worker/
        └── orders/consumer.go
```

- Example tree: reusable library.
- Use `pkg/` only when you intentionally ship a stable public API/SDK; otherwise prefer packages
  under the module root.

```text
.
├── go.mod
├── parser/
│   └── parser.go
└── validate/
    └── rules.go
```

- Directory intent from project-layout:
  - `cmd/`: executable programs.
  - `internal/`: private code enforced by the Go compiler.
  - `pkg/`: public/reusable packages (optional, convention only; not compiler-enforced).
  - `api/`: API contracts only (OpenAPI/proto), not runtime server implementations.
  - `configs/`, `scripts/`, `build/`, `deployments/`, `test/`: operational/supporting artifacts.
- Anti-patterns:
  - Creating deep folder trees before they are needed.
  - Putting domain logic in `cmd/`.
  - Putting runtime handler/impl code in `api/`.
  - Using `pkg/` as a generic dumping ground.
  - Adding `src/` just because other languages do it.
- Priority order when rules conflict:
  1. Keep build/test green and avoid import cycles.
  2. Preserve minimal, clear boundaries (`cmd` vs `internal` vs optional `pkg`).
  3. Add optional folders only for real, present needs.
