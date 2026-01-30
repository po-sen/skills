# Shared Codex Skills

This repo hosts shareable Codex skills you can reuse across projects.

## How to Use

1. Add or update a skill in `skills/<skill-name>/`.
2. Ensure each skill folder contains a `SKILL.md` at the root.
3. Keep skills focused and minimal.

## Install in Codex

```
$skill-installer install --repo po-sen/skills --path skills/<skill> --ref master
```

## Skills

- skills/add-functional-tests
- skills/add-integration-tests
- skills/add-unit-tests
- skills/clean-architecture-hexagonal-components
- skills/enforce-architecture-boundaries
- skills/draft-commit-message
- skills/dockerize-compose-multi-env
- skills/setup-lint-format
- skills/sdd-spec

## Skill Structure

```
skills/<skill-name>/
  SKILL.md
  references/   (optional)
  scripts/      (optional)
  assets/       (optional)
```

## Conventions

- Skill names use lowercase letters, digits, and hyphens.
- `SKILL.md` should include: Purpose, When to Use, Inputs, Outputs, Steps, Notes.
- Avoid extra docs inside skill folders.

## Getting Started

- Create a new folder under `skills/`.
- Draft `SKILL.md` following the conventions above.
- Keep instructions procedural and testable.
