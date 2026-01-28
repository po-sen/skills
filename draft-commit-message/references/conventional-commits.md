# Conventional Commits v1.0.0 Reference

Spec (authoritative): https://www.conventionalcommits.org/en/v1.0.0/

Key points to apply:
- Format: `type(scope)!: summary` where scope is optional.
- Breaking change: Use `!` in the header and include a `BREAKING CHANGE: ...` footer.
- Body: Optional; add for context, rationale, or migration guidance.
- Footer: Use for breaking changes or metadata (e.g., issue references).
- Revert: Use `revert: <summary>` and include a footer referencing the reverted commit when known.

Recommended types (common convention): feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
