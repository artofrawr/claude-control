# claude-control

Private Claude Code plugin marketplace.

## Repository Structure

```
claude-control/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace registry — lists all available plugins
├── plugins/
│   └── <plugin-name>/
│       ├── .claude-plugin/
│       │   └── plugin.json     # Plugin metadata (name, description, version)
│       ├── skills/                    # Required: at least one skill
│       │   └── <skill-name>/
│       │       ├── SKILL.md           # Skill definition (frontmatter + instructions)
│       │       ├── scripts/           # Optional bundled scripts
│       │       └── references/        # Optional reference docs
│       ├── commands/                  # Optional slash commands
│       │   └── <command-name>.md
│       ├── agents/                    # Optional autonomous agents
│       │   └── <agent-name>.md
│       ├── hooks/                     # Optional event hooks
│       │   ├── hooks.json
│       │   └── scripts/
│       └── README.md                  # Plugin documentation
├── schemas/
│   ├── plugin.schema.json      # JSON Schema for plugin.json
│   └── marketplace.schema.json # JSON Schema for marketplace.json
├── scripts/
│   └── validate.sh             # Plugin validation script
├── .github/
│   └── workflows/
│       └── validate.yml        # CI workflow — runs validation on PRs and pushes to main
├── .githooks/
│   └── pre-commit              # Local pre-commit hook — runs validation before commit
├── .claude/
│   └── commands/
│       └── create-plugin.md    # Slash command to scaffold new plugins
├── .gitignore                  # Standard ignores (OS files, editor files)
├── CLAUDE.md                   # This file — project conventions
└── README.md                   # Marketplace docs with Available Plugins section
```

## Plugin Conventions

- **Directory names**: lowercase kebab-case (e.g., `my-plugin`)
- **`name` in plugin.json must match directory name**
- **Versioning**: semantic versioning, starting at `1.0.0`
- **plugin.json schema**: `{ "name": string, "description": string, "version": string }` — optional fields: `author`, `keywords`, `license`, `homepage`, `repository`
- **SKILL.md frontmatter**: `name`, `description`, `disable-model-invocation` (boolean)
- **Every plugin must have a `README.md`** with a skills table, usage section, and version
- **marketplace.json**: the `plugins` array must be kept sorted alphabetically by `name`
- **marketplace.json `tags`**: optional array of lowercase strings for categorizing plugins (e.g., `["example", "testing"]`)
- **JSON Schemas**: `schemas/plugin.schema.json` and `schemas/marketplace.schema.json` define the expected structure of plugin and marketplace files
- **Validation**: run `bash scripts/validate.sh` to check all plugins for correct structure and metadata

## Component Conventions

### Skills (required)

Every plugin must have at least one skill under `skills/<skill-name>/SKILL.md`. Skills are the primary component type. If a skill needs bundled scripts or reference files, place them in subdirectories under the skill folder and reference them using `${CLAUDE_PLUGIN_ROOT}` (e.g., `${CLAUDE_PLUGIN_ROOT}/skills/my-skill/scripts/run.sh`).

### Commands (optional)

Slash commands live under `commands/<command-name>.md`. Each file must have frontmatter with `name` and `description` fields, followed by imperative instructions.

### Agents (optional)

Autonomous agents live under `agents/<agent-name>.md`. Each file must have frontmatter with:

- `name`: kebab-case agent name
- `description`: what the agent does and when to use it
- `model`: one of `inherit`, `sonnet`, `opus`, `haiku`
- `color`: one of `blue`, `cyan`, `green`, `yellow`, `magenta`, `red`
- `tools` (optional): comma-separated list of tools the agent can use

The body is the agent's system prompt.

### Hooks (optional)

Event hooks live under `hooks/hooks.json`. The file must contain a top-level `hooks` object where each key is an event type (`PreToolUse`, `PostToolUse`, `Stop`, `SessionStart`, `SessionEnd`) mapping to an array of hook entries. Command-type hooks should reference scripts via `${CLAUDE_PLUGIN_ROOT}` (e.g., `${CLAUDE_PLUGIN_ROOT}/hooks/scripts/my-hook.sh`).

## Root README Convention

The root `README.md` must contain an **"Available Plugins"** section with links to each plugin's README, kept in alphabetical order.

## Slash Commands

- `/create-plugin <name> <description>` — scaffolds a new plugin with all required files and updates the marketplace registry and root README. Run with no arguments for interactive mode, which supports scaffolding commands, agents, and hooks in addition to skills.
