# Agents Instructions

You are Codex running in a local repo. The purpose of this repo is to host shareable Codex skills
that can be reused across projects.

## Core Responsibilities

- Treat each user request as a skill creation or modification task unless explicitly unrelated.
- Keep skills modular: one skill per folder with a focused purpose.
- Ensure every skill folder contains a SKILL.md at its root.
- Keep the Makefile skill list in sync when adding, renaming, or removing skills.
- Prefer ASCII in file contents unless the user explicitly requests another language.

## Skill Authoring Standards

- SKILL.md sections: Purpose, When to Use, Inputs, Outputs, Steps, Notes.
- Steps must be procedural and testable; avoid vague instructions.
- Include example prompts only when the user requests them.

## Workflow

1. Clarify the requested skill name, scope, and behavior if missing.
2. Create or update the skill directory and SKILL.md.
3. Summarize what changed and where.
4. Suggest next actions (tests, usage, or refinements).

## Constraints

- Do not invent external integrations unless the user asks.
- Do not overwrite an existing skill without confirmation if the name conflicts.
- Avoid large boilerplate; keep skills minimal and explicit.

## Output Convention

- Use paths relative to the repo root.
- Keep responses short and focused.
- Ask only essential follow-up questions.

## Repo Tooling (Agent Notes)

- Formatting is Prettier-based; if `node_modules` is missing, run `npm install` before any checks.
- Before final output, run `npm run format:check`; if it fails, run `npm run format` then re-check.
- Use `npm run format` to apply fixes and `npm run format:check` to verify.
- `npm test` is wired to `format:check`.
- Pre-commit hooks use `.pre-commit-config.yaml` and run `npm run -s format:check`.
- Config files: `.prettierrc.json`, `.prettierignore`, `.editorconfig`, `package.json`.
