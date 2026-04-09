Create a new plugin for the claude-control marketplace.

## Input

Arguments: `$ARGUMENTS`

Parse the arguments as `<plugin-name> <description>` where the first word is the plugin name and the rest is the description.

**If `$ARGUMENTS` is empty (interactive mode)**, ask the user for:
1. Plugin name (must be lowercase kebab-case, e.g., `my-plugin`)
2. One-line description of the plugin
3. First skill name (lowercase kebab-case)
4. Skill description (one line)
5. Whether the skill should be auto-invocable by the model (default: no — user-invoked only via slash command)
6. Additional components to scaffold (comma-separated: `commands`, `agents`, `hooks` — or "none"). Default: none.

For each selected component type, prompt for details:

**Commands** — for each command:
- Command name (lowercase kebab-case, e.g., `run-tests`)
- One-line description of what the command does

**Agents** — for each agent:
- Agent name (lowercase kebab-case, e.g., `code-reviewer`)
- Description including example usage (e.g., "Reviews code for best practices. Use when the user asks for a code review.")
- Model: one of `inherit`, `sonnet`, `opus`, `haiku` (default: `sonnet`)
- Color: one of `blue`, `cyan`, `green`, `yellow`, `magenta`, `red` (default: `cyan`)
- Optional: specific tools the agent should have access to (comma-separated, or blank for all)

**Hooks** — for each hook:
- Event type: one of `PreToolUse`, `PostToolUse`, `Stop`, `SessionStart`, `SessionEnd`
- Hook type: `command` (runs a shell script) or `prompt` (injects a prompt)
- Matcher (for PreToolUse/PostToolUse only): tool name pattern to match, or blank for all
- For command hooks: a brief description of what the script should do

If arguments are provided but only contain a name without a description, ask for the missing information.

## Validation

Before creating anything, validate:
- **Name format**: must be lowercase kebab-case (only lowercase letters, numbers, and hyphens; no leading/trailing hyphens)
- **Name uniqueness**: must not already exist as a directory under `plugins/` or as an entry in `.claude-plugin/marketplace.json`

If validation fails, tell the user what's wrong and stop.

## When arguments are provided (quick mode)

If a description is provided via arguments but no skill details, derive sensible defaults:
- Skill name: use the plugin name (or a simplified version)
- Skill description: derive from the plugin description
- Auto-invocable: default to `false` (user-invoked only, `disable-model-invocation: true`)
- **No additional components** — quick mode scaffolds skills only

## Files to Create

### 1. `plugins/<name>/.claude-plugin/plugin.json`
```json
{
  "name": "<name>",
  "description": "<description>",
  "version": "1.0.0"
}
```

### 2. `plugins/<name>/skills/<skill-name>/SKILL.md`
Create with frontmatter:
```
---
name: <skill-name>
description: <A clear triggering description — what the skill does and when to invoke it>
disable-model-invocation: <true if user-invoked only, false if auto-invocable>
---
```
Below the frontmatter, write concise, imperative instructions for the skill — NOT placeholder text. The instructions should:
- Describe what the skill does and guide Claude on how to execute it
- Use imperative voice (e.g., "Read the file...", "Generate a report...")
- Base this on the plugin description and skill description provided

If the skill needs scripts, reference files, or other assets, create subdirectories under the skill folder (e.g., `scripts/`, `references/`) and reference them using `${CLAUDE_PLUGIN_ROOT}` — for example:
```
Run the script at ${CLAUDE_PLUGIN_ROOT}/skills/<skill-name>/scripts/run.sh
```

### 3. `plugins/<name>/commands/<command-name>.md` (if commands were selected)
Create one file per command with frontmatter and body:
```markdown
---
name: <command-name>
description: <one-line description>
---

<Imperative instructions for how Claude should execute this command.>
```

### 4. `plugins/<name>/agents/<agent-name>.md` (if agents were selected)
Create one file per agent with full frontmatter and a system prompt body:
```markdown
---
name: <agent-name>
description: <description with example usage>
model: <inherit|sonnet|opus|haiku>
color: <blue|cyan|green|yellow|magenta|red>
tools: <comma-separated tool list, or omit for all tools>
---

<System prompt for the agent — describe its role, capabilities, and behavior.>
```

### 5. `plugins/<name>/hooks/hooks.json` (if hooks were selected)
Create a hooks configuration file:
```json
{
  "hooks": {
    "<EventType>": [
      {
        "type": "<command|prompt>",
        "matcher": "<tool-pattern or omit>",
        "command": "<path to script or prompt text>"
      }
    ]
  }
}
```
For command-type hooks, also create `plugins/<name>/hooks/scripts/<script-name>.sh` with a stub shell script that includes a descriptive comment and basic structure. Reference scripts using `${CLAUDE_PLUGIN_ROOT}`:
```json
"command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/<script-name>.sh"
```

### 6. `plugins/<name>/README.md`
Generate a README with sections for each component type that was scaffolded:

```markdown
# <name>

<description>

## Skills

| Skill | Description |
|-------|-------------|
| `<skill-name>` | <skill-description> |
```

If **commands** were scaffolded, add:
```markdown

## Commands

| Command | Description |
|---------|-------------|
| `<command-name>` | <command-description> |
```

If **agents** were scaffolded, add:
```markdown

## Agents

| Agent | Description | Model |
|-------|-------------|-------|
| `<agent-name>` | <agent-description> | <model> |
```

If **hooks** were scaffolded, add:
```markdown

## Hooks

| Event | Type | Description |
|-------|------|-------------|
| `<event-type>` | <command\|prompt> | <brief description> |
```

Always end with:
```markdown

## Usage

After installing this plugin from the claude-control marketplace, use the `/<skill-name>` slash command in Claude Code.

## Version

1.0.0
```

## Files to Update

### 7. `.claude-plugin/marketplace.json`
Add a new entry to the `plugins` array:
```json
{
  "name": "<name>",
  "source": "./plugins/<name>",
  "description": "<description>",
  "tags": []
}
```
Add relevant tags (lowercase strings) if the user provides them, otherwise leave as an empty array.
Keep the `plugins` array sorted alphabetically by `name`.

### 8. `README.md` (root)
Add a line to the "Available Plugins" section:
```markdown
- [<name>](plugins/<name>/README.md) - <description>
```
Keep entries sorted alphabetically by plugin name.

## Output

After creating/updating all files, output a summary:
- List all files created and updated
- Remind the user to commit, push, and test with `/reload-plugins`
