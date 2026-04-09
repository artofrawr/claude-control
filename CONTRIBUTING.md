# Contributing to claude-control

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- This repo cloned locally

## Creating a Plugin

The easiest way to create a plugin is with the `/create-plugin` slash command:

```
/create-plugin my-plugin A short description of what it does
```

This scaffolds all required files (`plugin.json`, `SKILL.md`, `README.md`), updates the marketplace registry, and updates the root README. Run `/create-plugin` with no arguments for an interactive walkthrough.

See `CLAUDE.md` for full plugin structure and conventions.

## Plugin Structure

Each plugin lives under `plugins/<name>/` with this layout:

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json            # name, description, version
├── skills/                    # Required: at least one skill
│   └── <skill-name>/
│       ├── SKILL.md           # Skill definition with frontmatter
│       ├── scripts/           # Optional bundled scripts
│       └── references/        # Optional reference docs
├── commands/                  # Optional slash commands
│   └── <command-name>.md
├── agents/                    # Optional autonomous agents
│   └── <agent-name>.md
├── hooks/                     # Optional event hooks
│   ├── hooks.json
│   └── scripts/
└── README.md                  # Plugin documentation
```

## Validation

Run the validation script before submitting a PR:

```bash
bash scripts/validate.sh
```

It checks all plugins for correct structure, valid JSON, required fields, and marketplace consistency.

### Local git hook

To run validation automatically before every commit, configure the repo to use the included hooks:

```bash
git config core.hooksPath .githooks
```

This only needs to be done once per clone.

### CI

Validation also runs automatically via GitHub Actions on all PRs targeting `main` and on pushes to `main`.

## PR Checklist

Before opening a pull request, confirm:

- [ ] `bash scripts/validate.sh` passes with no errors
- [ ] `.claude-plugin/marketplace.json` is updated (new plugin entry added, sorted alphabetically)
- [ ] Root `README.md` "Available Plugins" section is updated
- [ ] Plugin has a `README.md` with skills table, usage section, and version
- [ ] If hooks are included, `hooks/hooks.json` is valid JSON with a top-level `hooks` object
- [ ] If agents are included, agent `.md` files have required frontmatter (`name`, `description`, `model`, `color`)
- [ ] If commands are included, command `.md` files have required frontmatter (`name`, `description`)

## Questions?

Contact @artofrawr.
