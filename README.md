# claude-control

Claude Code Marketplace

## How to use

### Add the marketplace

1. Run Claude Code
2. Use the `/plugin` command, hit return
3. Navigate using arrow keys to **Marketplaces**, "+ Add Marketplace" should be highlighted, hit return
4. Paste in `artofrawr/claude-control`, hit return
5. Should now see `x` plugins available to be installed

### Install a plugin

1. Run Claude Code
2. Use the `/plugin` command, hit return
3. Navigate using arrow keys to **Marketplaces**, navigate down to "claude-control", hit return
4. Navigate down to **Browse plugins**, hit return
5. Use the space bar to select which plugins you want to install, hit return

> May need to use `/reload-plugins` or restart Claude for all updates to take effect.

### Update the marketplace

1. Run Claude Code
2. Use the `/plugin` command, hit return
3. Navigate using arrow keys to **Marketplaces**, navigate down to "claude-control" and click `u`

> May need to use `/reload-plugins` for all updates to take effect.

### Update a single plugin

1. Run Claude Code
2. Use the `/plugin` command, hit return
3. Navigate using arrow keys to **Installed**, navigate down to the desired plugin, hit return
4. Navigate down to **Update Now**, hit return

> May need to use `/reload-plugins` for all updates to take effect.

### Create a new plugin

1. Run Claude Code from the claude-control repo
2. Use the `/create-plugin` slash command with a name and description:
   ```
   /create-plugin my-plugin A short description of what it does
   ```
3. Claude will scaffold all required files (`plugin.json`, `SKILL.md`, `README.md`), update the marketplace registry, and update this README
4. Commit, push, and run `/reload-plugins` to test

You can also run `/create-plugin` with no arguments for an interactive walkthrough that supports scaffolding commands, agents, and hooks in addition to skills.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to create plugins, validate your work, and submit PRs.

## Validation

Run the validation script to check all plugins for correct structure and metadata:

```bash
bash scripts/validate.sh
```

## Available Plugins

- [core-development](plugins/core-development/README.md) - Technology skill library and development workflows.
- [ethos](plugins/ethos/README.md) - Personal principles that persist across all projects and survive context compaction.
- [guardrails](plugins/guardrails/README.md) - Safety guardrails: destructive command warnings, directory freeze, and combined guard mode.
- [hello-world](plugins/hello-world/README.md) - A simple test plugin that greets the user.
