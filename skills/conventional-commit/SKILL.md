---
name: conventional-commit
description: |
  Generate a Conventional Commits message from the current working tree and commit by default.
  Stage all changes, infer type/scope from the diff, produce a compliant header with optional
  body/footer, and run git commit. Use draft-only mode only when the user explicitly asks for a
  message without committing.
---

# Conventional Commit

## Purpose

- Draft a Conventional Commits message from the current working tree.
- Default to staging all changes and committing with the drafted message.
- Keep message generation rules separate from git execution steps for clarity.

## When to Use

- Follow the trigger guidance in the frontmatter description; do not add new criteria here.

## Inputs

- Optional change summary or constraints provided by the user.
- Repo state and diffs (when available).
- Optional: preferred type, scope, breaking-change details, references, or test notes.

## Outputs

- Conventional commit message with a single-line header.
- Optional body and footer when they add value.
- Draft-only mode: return only the commit message.
- Default mode: stage all changes, show the final message, run `git commit`, and report the new
  commit hash on success.

## Steps

### 1) Mode Selection

- Commit mode (default): stage all changes and run `git commit`.
- Draft-only mode: only when the user explicitly asks for message-only output (e.g., "draft only",
  "message only", "no commit", "message only please").

### 2) Commit Message Spec

#### Header

- Format: `type(scope): summary` or `type: summary`
- Imperative mood; no trailing period
- Header length (including type/scope): <= 72 characters

#### Body (optional, recommended when needed)

Body is optional. Include it only when rationale is needed, risk is higher, behavior changes, or the
diff is non-obvious.

Non-trivial examples: public API change, business logic change, data schema/migration, auth/payment,
error handling, concurrency.

- Default body: prefer a short Why (1-3 lines).
- Add `Tests:` only when tests were run, risk is higher, or behavior changed.
- For `Tests:` trigger rules and format, follow Inference Rules -> Tests (body note).
- Include What only when the diff is non-obvious or spans multiple areas (for example: `- api: ...`,
  `- ci: ...`).
- Include Impact only when there is behavior change, compatibility/migration concerns, or likely
  pitfalls (1-3 lines).

Line wrapping: wrap body lines at ~72 characters when practical.

#### Footer

- Breaking changes:
  - Add `!` in header (`type(scope)!: summary` or `type!: summary`)
  - Add `BREAKING CHANGE: <what changed> <how to migrate>`
- References: keep in footer unless user requests otherwise.

### 3) Inference Rules

#### Type (priority heuristics)

1. docs-only -> `docs`
2. test-only -> `test`
3. ci/workflows -> `ci`
4. build/deps/tooling -> `build`
5. perf-only or clear performance improvement -> `perf`
6. formatting-only or lint-only -> `style`
7. behavior change: new -> `feat`, bug fix -> `fix`
8. no behavior change -> `refactor`
9. explicit revert request -> `revert`
10. otherwise -> `chore`

If reverting, use header `revert: <original summary>` and include `This reverts commit <hash>.` in
the body when the hash is available.

#### Scope

- Use the smallest meaningful scope (lowercase).
- Keep scope length <= 16 characters; if longer, omit scope.
- If spanning many areas, omit scope or use `repo` and list key areas in the body.
- If mixed changes clearly include multiple areas, still commit by default but summarize the
  sections in the body (for example: `- api: ...`, `- ci: ...`, `- docs: ...`).

#### Breaking change

- Likely breaking if public APIs, routes, config contracts, or schemas change.
- If unclear, ask only: "Is this a breaking change?"

#### Untracked files

- If untracked files exist:
  - If <= 10: list them in Body "What"
  - If > 10: summarize count and list the first 10

#### Tests (body note)

- Add a `Tests:` section when either is true:
  - Tests were run.
  - Risk is higher or externally observable behavior changed.
- Treat risk as higher for changes like API/route contracts, schema/migrations, auth/payment,
  concurrency, or error-handling behavior.
- Keep only tests that can run in this repo; do not include commands/tooling unrelated to this repo.
- If test coverage items are many, list only high-signal tests (for example: highest-risk paths,
  changed behavior paths, and one happy path). Do not enumerate every test case.
- When omitting long test lists, add one summary line for the remainder (for example:
  `- plus <n> additional checks`).
- Format:
  - `Tests:`
  - `- <command>`
  - `- manual - <scenario>`
  - `- not run (reason)`

#### Body inclusion heuristics

- This section clarifies the Body rules above; if conflicts arise, follow Commit Message Spec.
- `feat` / `fix` / `perf`: usually add Why; add `Tests:` when run or risk is higher.
- `refactor`: add Why/Impact only when diff is non-obvious or risk is higher.
- `docs` / `style` / `ci` / `build` / `test`: usually no body; if needed, add only a 1-line Why and
  a `Tests:` section with `- not run (reason)` when a Tests note is needed.

### 4) Execution Steps

1. `git rev-parse --is-inside-work-tree`
2. If not a repo: draft from user summary; do not commit.
3. `git status --porcelain`
4. If no changes: report "nothing to commit" and stop.
5. If unmerged paths exist (`git diff --name-only --diff-filter=U`): stop and ask to resolve
   conflicts before committing.
6. Commit mode:
   - `git add -A`
   - Inspect: `git --no-pager diff --cached --stat` and `git --no-pager diff --cached`
7. Draft-only mode:
   - Inspect: `git --no-pager diff --stat` and `git --no-pager diff`
8. Generate final message and show it to the user.
9. Commit (commit mode):
   - Use `mktemp`, write message, run `git commit -F <tmpfile>`
   - Clean up temp file (best effort)
10. On success: report short hash and final message.
11. On failure: return message and error summary; do not retry blindly.

## Notes

- Do not invent details; ask for missing essentials only when inference is unclear.
- Prefer consistency in type/scope naming across the repo.
- Default to staging all changes and committing without extra confirmation.
- Reference `references/conventional-commits.md` for the v1.0.0 spec.
