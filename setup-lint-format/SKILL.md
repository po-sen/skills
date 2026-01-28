---
name: setup-lint-format
description:
  Set up or modernize repo-wide linting and formatting for code and docs, select a toolchain based
  on detected stack and existing standards, wire scripts/hooks/CI, and provide check/fix workflows.
  Use when adding or updating linters/formatters, formatting a whole repo, or fixing lint/format CI
  failures.
---

# Purpose

Ensure consistent lint/format coverage for code and docs with a minimal, maintainable toolchain
wired to local scripts, hooks, and CI.

# When to Use

Follow when this skill is triggered by the frontmatter description; confirm scope and preferences if
unclear.

# Inputs

- Repo root path
- Language stack and package managers detected
- Existing lint/format tools and configs
- CI platform (GitHub Actions, Azure DevOps, GitLab CI, etc.)
- User preferences (toolchain choice, line length, hook preference)

# Outputs

- Updated or new config files (.editorconfig, tool configs, ignore files)
- Local scripts/commands for lint and format
- Hook configuration (pre-commit or husky/lefthook)
- CI lint/format check job
- Summary of changes and how to run locally/CI

# Steps

1. Scan the repo and summarize the current state.
   - Detect languages, frameworks, and package managers (Python/Node/Docs/CI).
   - Find existing lint/format tools and configs (ruff/black/isort/flake8/mypy,
     eslint/prettier/biome, markdownlint/remark/vale).
   - Identify existing scripts, hooks, and CI workflows.
   - If no frameworks/languages are detected, pause and ask which stack/frameworks apply; provide a
     short menu of common options to choose from before proceeding.

2. Propose toolchain options and select a default.
   - Prefer continuing existing standards; only replace when tooling is absent or clearly
     inconsistent.
   - Offer clear choices for Python, JS/TS, Docs, Hooks, and CI; pick defaults when unambiguous.
   - If no preference and both Python+TS are present, default to: ruff (lint+format),
     eslint+prettier, prettier for docs, pre-commit, and the existing CI platform.
   - If the stack is unknown or ambiguous, do not assume; wait for the user to confirm the
     framework(s) and package manager before choosing tools.

3. Implement baseline formatting consistency.
   - Add or update .editorconfig for core file types (.py/.js/.ts/.md/.yml/.yaml/.json).
   - Ensure line length is consistent (reuse existing value; else use 100).

4. Implement language-specific tooling.
   - Python: configure ruff (or black+ruff) in pyproject.toml; create a minimal pyproject.toml if
     missing; set excludes (.venv, build, dist, node_modules, generated).
   - JS/TS: configure eslint+prettier or biome; add scripts: lint, lint:fix, format, format:check.
   - Docs/configs: ensure prettier covers md/yaml/json; optionally add markdownlint with scripts.

5. Implement ignore strategy.
   - Add .prettierignore and align tool excludes with build, vendor, lock, and generated paths.
   - Ensure eslint ignores dist/build/node_modules.

6. Wire hooks.
   - Prefer pre-commit with local hooks to avoid version guessing; call the selected toolchain
     (ruff/black, eslint/biome, prettier/markdownlint).
   - If husky/lefthook is required, mirror the same checks.
   - Add brief usage notes in README/CONTRIBUTING (install hook, run all).

7. Wire CI checks (check-only).
   - Add or update a lint/format job that runs format-check and lint separately.
   - Ensure CI installs dependencies and fails with actionable commands (e.g., run format or
     lint:fix locally).

8. Run strategy to limit diff size.
   - Run check mode first; tune rules to reduce noise.
   - Run fix mode in batches if changes are large.
   - Prefer formatter alignment first, then incrementally tighten lint rules.

9. Report deliverables.
   - List modified files, local commands, CI workflow changes, toolchain choice, and excluded paths.

# Notes

- Avoid large diffs when possible; propose phased rollout if needed.
- Do not add new external integrations unless the user requests them.
- Keep configs minimal; avoid copying large rule sets without justification.
