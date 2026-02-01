---
name: clean-architecture-hexagonal-components
description: |
  Apply strict Clean Architecture + Hexagonal (Ports & Adapters) with optional component (bounded
  context) packaging. Use when creating or modifying features that must enforce
  domain/application/adapter boundaries, inward dependencies, and (when enabled) cross-component
  isolation.
---

# Clean Architecture Hexagonal (Components Optional)

## Purpose

Enforce a Clean Architecture + Hexagonal (Ports & Adapters) structure with strict dependency and
layering rules, using component (bounded context) packaging when appropriate. Components may also be
named `modules/` or similar; treat them equivalently as bounded contexts.

## When to Use

Use when building or refactoring features that must follow strict Clean Architecture + Hexagonal
boundaries. Components (bounded contexts) are optional for small projects.

## Inputs

- Feature request or change description.
- Existing architecture cues and folder structure (if any).
- Target component (bounded context) name if components are used; otherwise the module name.
- Inbound interface(s) (HTTP, CLI, MQ, etc.).
- IO needs (persistence, external services, messaging).
- Existing code conventions and DI/composition patterns.

## Outputs

- Coherent patch that creates/updates files, moves files if needed, and fixes imports.
- Component-structured directories when components are enabled; otherwise a single-module layout.
- Thin inbound controllers/handlers and pure domain logic.
- Tests aligned to domain, use case, and adapter layers.
- No forbidden imports across layers or components.

## Steps

1. Scan the repo for existing architecture cues (e.g., a `components/` or `modules/` directory,
   `bounded_contexts/`, `domain/`); summarize what you found.
2. Default to the existing structure. If none exists, default to a single-module layout unless there
   are clear signs of multiple bounded contexts (e.g., distinct feature folders or multiple
   domains).
3. If components are used, identify the target component (bounded context). If unspecified, infer it
   from domain language; ask a question only if strictly necessary to avoid incorrect placement.
4. Ensure the directory structure exists for `shared_kernel/` and `bootstrap/`, plus
   `components/<component>/` (or equivalent such as `modules/<module>/`) when bounded contexts are
   enabled. Place these at the project source root (repo root or optional `src/`).
5. Define or extend a single inbound port per use case in `application/ports/in`, using
   command-style input and explicit output DTOs.
6. Implement the use case in `application/use_cases`, orchestrating domain behavior and interacting
   with external systems only via outbound ports (no direct drivers/framework calls).
7. Define outbound ports in `application/ports/out` for any IO needs; shape them by core needs, not
   external APIs.
8. For query-heavy read use cases, define a read-side outbound port (`*ReadModel` / `*QueryService`
   / `*Finder`) returning DTOs/views, separate from aggregate repositories.
9. Implement outbound adapters in `adapters/outbound/*`, mapping through ACLs for external systems
   and using infrastructure drivers as needed.
10. Implement inbound adapters in `adapters/inbound/*`: validate input, map to command/DTO, call the
    inbound port or command bus, map errors.
11. Wire dependencies only in composition roots (`components/<name>/infrastructure/di` when
    components are used, otherwise the module-level DI area) and in the bootstrap entry point (e.g.,
    `bootstrap/main.*`).
12. Add tests: domain unit tests, use case tests with mocked outbound ports, adapter
    integration/contract tests.
13. Verify dependency boundaries by checking imports; fix any violations before finalizing.

## Notes

Default structure (components optional for small projects; adjust layout to fit your language's
conventions):

```text
shared_kernel/
  domain/
    events/
    value_objects/
    specifications/
  application/
    events/
    messaging/
components/ (optional)
  <component_name>/
    domain/
      entities/
      value_objects/
      services/
      policies/
      events/
    application/
      ports/
        in/
        out/
      use_cases/
      dto/
      mappers/
    adapters/
      inbound/
        http/
          controllers/
          middleware/
        cli/
        mq/
      outbound/
        persistence/
        external/
        messaging/
    infrastructure/
      drivers/
      di/
bootstrap/
  main.*
```

Single-module structure (when components are not used; adjust layout to fit your language's
conventions):

```text
domain/
  entities/
  value_objects/
  services/
  policies/
  events/
application/
  ports/
    in/
    out/
  use_cases/
  dto/
  mappers/
adapters/
  inbound/
    http/
      controllers/
      middleware/
    cli/
    mq/
  outbound/
    persistence/
    external/
    messaging/
infrastructure/
  drivers/
  di/
bootstrap/
  main.*
```

Note: The above directory structure is illustrative. Adjust the top-level placement to fit your
language's standard project layout. For example, some projects keep source code in `src/` or
`src/main` (common in Java/.NET), while others place the folders at the repository root (common in
Go, Python, etc.). Follow the standard conventions of your language, as long as the separation of
architectural layers (domain, application, adapters, etc.) remains intact.

Non-negotiable rules (treat violations as errors):

The following are strict architecture boundaries. Treat violations as errors, regardless of language
or tooling.

- Domain must not import `application/`.
- Domain must not import `adapters/`, `infrastructure/`, or `bootstrap/`.
- Domain and application may import `shared_kernel/` (but `shared_kernel/` must be dependency-free
  with respect to feature modules; no imports from `components/` or `modules/`).
- Domain events live in `domain/events` and describe in-model state changes. Cross-component
  communication uses integration events in `shared_kernel/domain/events` (or equivalent path if
  already present, or explicit ports), never direct imports. Do not place feature-specific DTOs in
  shared_kernel.
- Application may import `domain/`, `shared_kernel/`, and other `application/**` modules.
  Application must not import `adapters/`, `infrastructure/`, or `bootstrap/`.
- Inbound adapters must not execute domain business logic or mutate aggregates. They may reference
  domain types (value objects, error codes) for parsing and error mapping, but must call the use
  case (inbound port or bus) to perform any business action. Perform transport validation/parsing in
  inbound adapters before calling the use case. Business validation/invariants are enforced in
  domain/application.
- Adapters may import `application/ports/**`, application DTOs, and domain types as needed for
  mapping, but must not move business logic into adapters.
- Transport-specific schemas/validators live in `adapters/inbound/<transport>/middleware` (or
  equivalent), not in `application/` or `domain/`.
- Vendor/SDK DTOs must not appear in application/domain. Map them in outbound adapters/ACL to
  application DTOs or domain types.
- Outbound adapters implement application outbound ports; may use infrastructure drivers.
- Components/modules (bounded contexts) must not import each other's domain/application directly.
  Use shared_kernel events, outbound ACLs, or explicit query ports.
- Ports live inside application core; adapters live outside.
- One use case equals one inbound port/handler.
- Outbound ports represent required capabilities (repositories, gateways, publishers) and are shaped
  by core needs.
- Use cases orchestrate: load entities, invoke domain behavior, persist, publish application events
  if needed.
- Prefer value objects/policies/specifications for pure rules; use domain services only when the
  logic does not fit naturally on an entity/value object.
- Domain services contain domain logic that does not naturally belong to a single entity/value
  object. They have no IO and no repository dependencies.
- Pure domain rules (policies/strategies) live in `domain/policies`.
- Repository ports are only for aggregate persistence (get/save by aggregate identity). For queries,
  use `*ReadModel` / `*QueryService` / `*Finder` returning DTOs/views.
- Repository ports must accept/return aggregates (or aggregate IDs). They must not return view
  models/DTOs.
- Read-side ports must return DTOs/views and must not return aggregates.
- Transport payloads (HTTP/MQ/CLI) must be mapped in inbound adapters to application DTOs/commands.
  Do not leak transport DTOs into application/domain.
- Outbound adapters must not call inbound ports/use cases. All orchestration happens in application
  use cases.
- Errors are structured (type + code + message + optional metadata). Inbound adapters map these
  errors to transport-specific responses.
- Only composition roots may bind ports to adapter implementations. Do not instantiate drivers/SDK
  clients inside domain/application.
- Command bus interface (if used) lives in `application/ports/in`. In-memory bus may live in
  application; framework-driven bus wiring stays in infrastructure.

Output requirements:

- Keep controllers/handlers thin; no business logic in adapters.
- Keep domain pure; no frameworks, IO, or persistence models.
- Do not add external integrations unless requested; use ports and adapters with clear boundaries.
- Do not introduce new architectural concepts (e.g., CQRS, event sourcing, command bus) unless
  requested or already present in the repo.

Naming guidance:

- Inbound: `<Verb><Noun>UseCase` / `<Verb><Noun>Handler` / `<Verb><Noun>Port`.
- Outbound: `<Noun>Repository` / `<Capability>Gateway` / `<Capability>Publisher`.
- Query read side: `<Noun>ReadModel` / `<Noun>QueryService` / `<Noun>Finder`.
- External vendors: `<Vendor><Capability>Client` with ACL mappers in outbound adapters.
