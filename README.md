# claude-control

Claude Code plugin marketplace with opinionated skills and workflows

## How to use

### Add the marketplace

In Claude Code, run:

```
/plugin marketplace add artofrawr/claude-control
```

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

## Validation

Run the validation script to check all plugins for correct structure and metadata:

```bash
bash scripts/validate.sh
```

## Available Plugins

- [design](plugins/design/README.md) - Design skills: UI/UX patterns, design systems, and visual design workflows.
- [development](plugins/development/README.md) - Technology skill library and development workflows: focused skills for NestJS, Prisma, Zod, Chakra UI, Sentry, TanStack, Typesense, and more.
- [ethos](plugins/ethos/README.md) - Personal principles that persist across all projects and survive context compaction.
- [guardrails](plugins/guardrails/README.md) - Safety guardrails: destructive command warnings, directory freeze, and combined guard mode.
- [learning](plugins/learning/README.md) - Learning skills: tutorials, explanations, and knowledge building patterns.
- [marketing](plugins/marketing/README.md) - Marketing skills: SEO, content strategy, analytics, and campaign optimization.
- [media](plugins/media/README.md) - Media skills: image, audio, and video processing workflows.
- [meta-tooling](plugins/meta-tooling/README.md) - Tooling for managing Claude Code plugins, skills, and workflows.
- [testing](plugins/testing/README.md) - Testing skills: test strategies, frameworks, and quality assurance patterns.
- [workflows](plugins/workflows/README.md) - Reusable workflow patterns and process automation skills.
- [writing](plugins/writing/README.md) - Writing skills: copywriting, documentation, editing, and content creation.
