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

## Install All (Overwrite)

```bash
SKILLS_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
rm -rf \
  "$SKILLS_DIR/add-functional-tests" \
  "$SKILLS_DIR/add-integration-tests" \
  "$SKILLS_DIR/add-unit-tests" \
  "$SKILLS_DIR/clean-architecture-hexagonal-components" \
  "$SKILLS_DIR/dockerize-compose-multi-env" \
  "$SKILLS_DIR/draft-commit-message" \
  "$SKILLS_DIR/enforce-architecture-boundaries" \
  "$SKILLS_DIR/sdd-spec" \
  "$SKILLS_DIR/setup-lint-format"
```

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo po-sen/skills \
  --ref master \
  --path \
  skills/add-functional-tests \
  skills/add-integration-tests \
  skills/add-unit-tests \
  skills/clean-architecture-hexagonal-components \
  skills/dockerize-compose-multi-env \
  skills/draft-commit-message \
  skills/enforce-architecture-boundaries \
  skills/sdd-spec \
  skills/setup-lint-format
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
