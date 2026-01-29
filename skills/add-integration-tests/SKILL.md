---
name: add-integration-tests
description:
  "Add or improve integration tests across components (DB/queue/cache/API boundaries) using the
  repo's existing tooling and conventions. Use when the user asks to verify multiple components
  working together."
---

# add-integration-tests

## Purpose

- Provide a concise checklist for integration tests that exercise real component boundaries.

## When to Use

- Follow the trigger guidance in the frontmatter description.

## Inputs

- Target integration slice (DB, queue, cache, internal API).
- Existing infra tooling (compose, testcontainers, scripts).
- Required environment variables or secrets (if any).

## Outputs

- Integration tests with clear setup and cleanup.
- A runnable command and prerequisites.

## Steps

1. Detect existing integration tooling and conventions (compose files, testcontainers usage, CI
   scripts).
2. Select a concrete integration slice aligned with the user request.
3. Choose the lightest environment strategy that matches the repo (reuse existing containers or
   scripts).
4. Implement tests with isolation and cleanup (unique DB/schema, reset state, close resources).
5. Use real drivers for the boundary under test (DB driver, queue client) while keeping scope tight.
6. Add or confirm a run command using the repo's standard scripts or targets.
7. Run the smallest relevant test subset and capture how to reproduce.
8. Report files changed, prerequisites, and any remaining risks.

## Notes

- Keep tests deterministic; avoid real internet calls.
- Never call real external services; use local stubs or test doubles.
- Prefer ephemeral infrastructure and clean teardown.
- Prevent flakes: fix seeds, avoid time dependence, clean up resources, isolate state.
- Keep test names and structure aligned to requirements and behaviors.
- If new dependencies or a new test framework would be required, stop and ask the user first.
- Document any required services, ports, and env vars.
