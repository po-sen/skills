.PHONY: install-skills clean-skills

CODEX_HOME ?= $(HOME)/.codex
SKILLS_DIR := $(CODEX_HOME)/skills
SKILL_INSTALLER := $(CODEX_HOME)/skills/.system/skill-installer/scripts/install-skill-from-github.py
SKILL_REPO ?= po-sen/skills
SKILL_REF ?= master
SKILL_PATHS := \
	skills/clean-architecture-hexagonal-components \
	skills/conventional-commit \
	skills/go-project-layout \
	skills/spec-driven-development
SKILL_NAMES := $(notdir $(SKILL_PATHS))

install-skills:
	rm -rf $(addprefix $(SKILLS_DIR)/,$(SKILL_NAMES))
	python3 "$(SKILL_INSTALLER)" --repo $(SKILL_REPO) --ref $(SKILL_REF) --path $(SKILL_PATHS)

clean-skills:
	rm -rf $(addprefix $(SKILLS_DIR)/,$(SKILL_NAMES))
