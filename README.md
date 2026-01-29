# Shared Codex Skills

This repo hosts shareable Codex skills you can reuse across projects.

## How to Use

1. Add or update a skill in its own folder.
2. Ensure each skill folder contains a `SKILL.md` at the root.
3. Keep skills focused and minimal.

## Install in Codex

```
$skill-installer install --repo po-sen/skills --path <skill> --ref master
```

## Skills

- add-functional-tests
- add-integration-tests
- add-unit-tests
- clean-architecture-hexagonal-components
- enforce-architecture-boundaries
- draft-commit-message
- dockerize-compose-multi-env
- setup-lint-format

## Skill Structure

```
<skill-name>/
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

- Create a new folder for your skill.
- Draft `SKILL.md` following the conventions above.
- Keep instructions procedural and testable.
