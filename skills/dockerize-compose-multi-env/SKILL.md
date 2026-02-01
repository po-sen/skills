---
name: dockerize-compose-multi-env
description:
  Create production-ready Dockerfile(s), docker-compose base + environment override YAMLs,
  .dockerignore, and .env.example by inspecting a repo's runtime/ports/dependencies and by asking
  the user a short Q&A for required env vars and which environment YAML files to generate
  (prod/staging/test or custom). Use when a user asks to dockerize a project, add
  Dockerfile/compose, or support multiple environments.
---

# Purpose

Create best-practice Dockerfile and docker-compose configurations for multi-environment deployments,
grounded in repo inspection and explicit user confirmation of env vars and environment YAML files.

## When to Use

Use for requests to dockerize a project or add Dockerfile/compose for production, staging, and test.
See description for triggers.

## Inputs

- Repository contents (source, README, configs, existing Docker/compose files).
- User answers to the Q&A (runtime/build/test commands, ports, env vars, env file names, required
  services, and environment YAML filenames).

## Outputs

- `Dockerfile`
- `.dockerignore`
- `docker-compose.yml`
- `docker-compose.<env>.yml` (prod/staging/test or custom per user)
- `.env.example`

## Steps

1. Inspect the repo to infer stack and runtime.

- List top-level files and check for existing `Dockerfile`, `docker-compose*.yml`, `.env*`, README.
- Detect stack and lockfiles (Node, Python, etc.).
- Identify build/run/test commands from `package.json`, `pyproject.toml`, `README`, or scripts.
- Find ports and entrypoints using search (e.g., `rg 'PORT|listen\(|EXPOSE|uvicorn|gunicorn'`).
- Check for Kubernetes/Helm or existing environment YAML files to mirror.

1. Infer dependent services and env vars.

- Search for DB/cache/queue/object storage usage and env vars (e.g., `DATABASE_URL`, `POSTGRES_*`,
  `REDIS_URL`, `BROKER_URL`, `S3_*`).
- Classify services as required vs optional based on code/config evidence.
- Note multi-process roles (worker/scheduler/migrate) based on tooling found.
- Inspect existing `.env*` files to extract required variables.

1. Ask mandatory Q&A before generating files.

- Confirm/override runtime command and build command.
- Confirm container port and host port mapping.
- Confirm which environments are needed and the exact YAML filenames to generate (default:
  `docker-compose.prod.yml`, `docker-compose.staging.yml`, `docker-compose.test.yml`).
- Confirm which env files should exist per environment (default: `.env.production`, `.env.staging`,
  `.env.test`) and whether any already exist.
- Gather the full list of required env vars (including secrets), defaults, and which envs differ.
- Confirm dependent services to include (db/redis/queue/search), versions, and data persistence
  needs.
- Confirm migrations strategy (manual one-off service vs `RUN_MIGRATIONS=1` flag).
- Confirm test command and whether to include a `tests` service.
- If any item is unknown, propose defaults and ask for explicit approval before proceeding.

Q&A checklist (ask in order, keep answers short):

- Runtime command (start) and build command?
- Container port and host port mapping?
- Environments and YAML filenames (prod/staging/test or custom)?
- Env files per environment (e.g., `.env.production`), and which already exist?
- Required env vars (including secrets) and per-env differences?
- Dependent services (db/redis/queue/search), versions, and persistence?
- Migrations strategy (one-off service or `RUN_MIGRATIONS=1`)?
- Test command and need for `tests` service?

1. Create or update `.dockerignore`.

- Use a conservative baseline (see `references/dockerignore.md`) and remove any ignores that would
  break the build.
- Ensure secrets and local env files are excluded.

1. Write a production-grade `Dockerfile`.

- Use multi-stage builds, non-root user, minimal runtime image, deterministic installs.
- Select a template based on stack:
  - Node: use `references/dockerfile-node.md`.
  - Python: use `references/dockerfile-python.md`.
  - Go: use `references/dockerfile-go.md`.
  - Other stacks: follow the same principles and keep runtime minimal.
- Set `CMD`/`ENTRYPOINT` to the confirmed runtime command.
- Do not auto-run migrations by default; wire it behind a flag or a one-off service.

1. Create compose files (base + overrides).

- Base `docker-compose.yml` defines common services, networks, volumes, and healthchecks (see
  `references/compose-base.md`).
- Environment override files set `APP_ENV`, ports, restart policies, resources, and env-specific
  values (see `references/compose-overrides.md`).
- Add `worker`, `scheduler`, `migrate`, and `tests` services only if confirmed.
- Keep secrets out of YAML; rely on env vars and `--env-file`.

1. Generate `.env.example`.

- Include all required env vars for app and dependencies.
- Group by Common / Production / Staging / Test.
- Provide safe placeholders for secrets and sane defaults where safe.
- Align names with compose files and app config (see `references/env-example.md`).

1. Validate.

- Run
  `docker compose -f docker-compose.yml -f docker-compose.<env>.yml --env-file .env.<env> config`
  for each environment.
- If Docker is unavailable, note the exact commands for the user to run.
- Optionally bring up staging or test once and run the `tests` service if defined.

## Notes

- Do not add services or integrations unless found in the repo or confirmed by the user.
- If Docker/compose files already exist, confirm before overwriting or removing content.
- Keep differences in override files; avoid duplicating the full compose.
- Prefer pinned base images and lockfiles for reproducibility.
- Use healthchecks for stateful services and `depends_on` with `service_healthy` where supported.
