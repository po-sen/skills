---
name: draft-commit-message
description: "Draft a Conventional Commits message when the user asks for help writing a commit message or requests a conventional commit format. Use to transform a change summary into a compliant `type(scope): summary` line and optional body/footer, including BREAKING CHANGE details when applicable."
---

# Draft Commit Message

## Purpose
- Draft a Conventional Commits message from a user-provided change summary.
- Enforce format rules and best practices for clarity and consistency.

## When to Use
- Follow the trigger guidance in the frontmatter description; do not add new criteria here.

## Inputs
- Change summary (required).
- Optional: preferred type, scope, breaking-change details, ticket/issue references, extra context for a body.

## Outputs
- Conventional commit message with a single-line header.
- Optional body and footer when needed (for context or breaking changes).

## Steps
1. Ask for missing essentials: change summary, intended type or scope, and whether the change is breaking.
2. Choose a type that matches the change: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
3. Decide whether a scope adds clarity; keep scope lowercase, short, and consistent with module or domain names.
4. Write an imperative summary under 72 characters; avoid trailing periods.
5. Compose the header as `type(scope): summary` or `type: summary` if no scope.
6. If the change is breaking, add `!` after the type or scope and include a `BREAKING CHANGE: <details>` footer.
7. Add a body only when it adds value (rationale, notable behavior changes, migration notes); separate sections with blank lines.
8. Return only the final commit message unless the user asks for alternatives or explanation.

## Notes
- Prefer the smallest scope that still adds clarity.
- Do not invent details; ask clarifying questions if the summary is ambiguous.
- Keep issue IDs in the body or footer unless the user requests them in the summary.
- Reference `references/conventional-commits.md` for the v1.0.0 spec.
