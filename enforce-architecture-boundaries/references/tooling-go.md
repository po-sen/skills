# Go tooling guidance

## Default tool

Prefer `golangci-lint` with `depguard` if the repo already uses golangci-lint. Fallback to a small
`go list`-based checker if depguard cannot express the rules.

## Minimal workflow

1. Extend `.golangci.yml` with a `depguard` ruleset that mirrors `architecture/boundaries.yml`.
2. Add a local command that runs `golangci-lint run` with the depguard rules enabled.
3. Keep module path mapping consistent with `go.mod`.

## Mapping tips

- Map `rules[].from`/`rules[].forbid` to depguard lists by package import path.
- When bounded contexts are enabled, expand rules per component/module.
- Use a script fallback when import paths do not map cleanly to filesystem paths.
