---
name: add-unit-tests
description: "Add or improve unit tests for a specific function or module using the repo's existing test framework and conventions. Use when the user asks to add unit tests, increase coverage, or prevent regressions."
---

# add-unit-tests

## Purpose
- Provide a concise checklist for writing unit tests before making changes.

## When to Use
- Follow the trigger guidance in the frontmatter description.

## Inputs
- Target unit (function/class/module) and change summary.
- Existing test framework and conventions (if any).
- Known bugs or edge cases to cover.

## Outputs
- New or updated unit tests in the repo's standard location.
- A brief run command and summary of coverage.

## Steps
1. Detect the existing test stack by scanning config files and current tests.
2. Identify the unit under test, its public API, and observable behaviors.
3. Enumerate happy paths, edge cases, and error conditions to cover.
4. Write deterministic tests using Arrange-Act-Assert and the repo's naming patterns.
5. Mock only external boundaries (I/O, network, time, randomness); avoid overspecifying internals.
6. Refactor minimally to improve testability only when necessary and preserve behavior.
7. Run the smallest relevant test command and record how to reproduce.
8. Report files changed, why cases were chosen, and any remaining gaps.

## Notes
- Prefer behavior tests over implementation tests.
- Avoid real network, real DB, and sleeps.
- Prevent flakes: fix seeds, avoid time dependence, clean up resources, isolate state.
- Keep test names and structure aligned to requirements and behaviors.
- Use table-driven or parameterized tests when it improves clarity.
- If no framework exists, ask before introducing one.
- If new dependencies or a new test framework would be required, stop and ask the user first.
