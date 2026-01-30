---
name: draft-commit-message
description: |
  Generate a Conventional Commits message when the user asks for a commit message or a
  Conventional Commits format. Transform a change summary (and/or staged diff) into a compliant
  `type(scope): summary` line and optional body/footer, including BREAKING CHANGE details when
  applicable.
  Only run `git commit` when the user explicitly asks to commit (e.g., "commit this", "run git commit").
---

# Draft Commit Message

## Purpose

- Draft a Conventional Commits message from a user-provided change summary.
- Commit the staged changes using the drafted message only when explicitly requested.
- Enforce format rules and best practices for clarity and consistency.

## When to Use

- Follow the trigger guidance in the frontmatter description; do not add new criteria here.

## Inputs

- Change summary (required unless it can be inferred from the staged diff).
- Explicit request to commit (required to perform `git commit`).
- Staging intent if the user wants to commit and there are no staged changes (required when needed).
- Optional: preferred type, scope, breaking-change details, ticket/issue references, extra context
  for a body.

## Outputs

- Conventional commit message with a single-line header.
- Optional body and footer when needed (for context or breaking changes).
- Draft-only: return only the commit message.
- Commit mode: show the commit message first, then run `git commit` and report the new commit hash
  on success.

## Steps

0. Determine intent: draft-only vs. draft-and-commit.
   - If the user did not explicitly ask to commit, do not run `git commit`.
   - If draft-only and the user provided a clear change summary, draft the message without running
     git commands unless diff inspection is needed. Skip Step 1 and proceed to Steps 4 to 10.
1. If repo context is needed (commit mode or diff inspection), check staging state:
   - `git status --porcelain`
   - `git diff --cached --stat`
   - When inferring type/scope, inspect content with `git diff --cached`.
   - If both staged and unstaged changes exist:
     - If the user wants to commit, ask whether to commit only staged changes or to stage additional
       changes first (then proceed to Step 2).
     - Otherwise, remind the user that only staged changes would be committed.
   - If git commands fail (e.g., not a git repo), fall back to drafting from the user-provided
     summary and ask for minimal missing context. Do not attempt to commit in this case.
2. If the user wants to commit and nothing is staged, ask whether to stage all changes
   (`git add -A`), interactively select hunks (`git add -p`), or stage specific paths
   (`git add <paths...>`); do not proceed until there are staged changes.
3. Ask only for missing essentials that cannot be inferred from staged diff or user text: change
   summary and whether the change is breaking. Type/scope are optional and may be inferred.
4. Choose a type that matches the change: feat, fix, docs, style, refactor, perf, test, build, ci,
   chore, revert.
5. Decide whether a scope adds clarity; keep scope lowercase, short, and consistent with module or
   domain names.
6. Write an imperative summary under 72 characters; avoid trailing periods.
7. Compose the header as `type(scope): summary` or `type: summary` if no scope.
8. If the change is breaking, add `!` after the type or scope and include a
   `BREAKING CHANGE: <what changed> <how to migrate>` footer.
9. Add a body only when it adds value (rationale, notable behavior changes, migration notes);
   separate sections with blank lines.
10. Generate the full commit message and show it to the user.
11. If the user asked to commit, write the message to a temp file (e.g., via `mktemp`) and commit
    with `git commit -F <tmpfile>`. Clean up the temp file afterward (best effort).
12. If the commit succeeds, report the new short commit hash and the final commit message.
13. If the commit fails (e.g., hooks), return the final commit message and the error summary; do not
    retry blindly.
14. If the user did not ask to commit, return only the final commit message.

## Notes

- Prefer the smallest scope that still adds clarity.
- Do not invent details; ask clarifying questions if the summary is ambiguous.
- Keep issue IDs in the body or footer unless the user requests them in the summary.
- Do not commit unless explicitly requested, and do not commit if there are no staged changes.
- Do not run `git add` unless the user explicitly requested staging.
- Use `revert:` only when reverting a known prior commit and the user explicitly requested a revert.
- Reference `references/conventional-commits.md` for the v1.0.0 spec.
