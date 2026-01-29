---
name: add-functional-tests
description:
  "Add or improve functional (black-box) tests for an API or service by exercising real endpoints
  and verifying user-visible behavior. Use when the user asks for functional or end-to-end API
  tests."
---

# add-functional-tests

## Purpose

- Provide a concise checklist for black-box tests that validate user-visible behavior.

## When to Use

- Follow the trigger guidance in the frontmatter description.

## Inputs

- Target flows, endpoints, and acceptance criteria.
- Existing functional or e2e test tooling and locations.
- Required environment setup (services, env vars, auth).

## Outputs

- Functional tests that exercise real endpoints.
- A runnable command and prerequisites.

## Steps

1. Define the functional flow, actors, preconditions, and expected responses.
2. Detect existing functional test tooling and follow repo conventions.
3. Decide how to run the system under test (in-process, spawned server, or compose).
4. Implement scenario-style tests with stable assertions (status, schema, key fields).
5. Validate negative cases (auth, validation errors, not found, conflicts).
6. Handle async side effects via polling with timeouts; avoid fixed sleeps.
7. Add or confirm a run command and document required setup.
8. Run the smallest relevant test subset and report files changed and risks.

## Notes

- Treat the system as a black box; avoid white-box coupling.
- Avoid UI/browser flows unless the repo is a frontend app.
- Never call real external services; use local stubs when needed.
- Prevent flakes: fix seeds, avoid time dependence, clean up resources, isolate state.
- Keep test names and structure aligned to requirements and behaviors.
- If new dependencies or a new test framework would be required, stop and ask the user first.
