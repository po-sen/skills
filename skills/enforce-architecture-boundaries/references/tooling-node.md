# Node/TS tooling guidance

## Default tool

Prefer `dependency-cruiser` unless the repo already uses an import-boundary tool.

## Minimal workflow

1. Add `dependency-cruiser` as a dev dependency.
2. Create `.dependency-cruiser.cjs` that mirrors `architecture/boundaries.yml` rules.
3. Add `npm run lint:boundaries` that runs `depcruise` with `--config` and fails on violations.
4. Resolve path aliases from `tsconfig.json` if present.

## Mapping tips

- Translate each `rules[].from`/`rules[].forbid` to a `forbidden` rule using regex paths.
- Use a small generator script if you want to avoid manual duplication.
- Keep `doNotFollow` for `node_modules`, and set `enhancedResolveOptions.extensions` for TS/JS.
