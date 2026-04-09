# ethos

Personal principles that persist across all projects and survive context compaction.

## How It Works

The ethos plugin injects your personal principles into every Claude Code session via two hooks:

- **SessionStart** — principles are loaded when the conversation begins
- **PreCompact** — principles are re-injected before context compaction so they survive into the compressed context

## Principles Resolution

Three-tier fallback (first match wins):

1. **Project-local**: `$CLAUDE_PROJECT_DIR/.claude/ethos.local.md`
2. **User-global**: `~/.claude/ethos.local.md`
3. **Plugin default**: `skills/principles/SKILL.md`

## Commands

| Command | Description |
|---------|-------------|
| `/ethos` | View active principles and their source |

## Customizing

Create an `ethos.local.md` file to override the defaults:

```bash
# User-global (applies to all projects)
cat > ~/.claude/ethos.local.md << 'EOF'
---
name: my-principles
description: My personal working principles
---

Your principles here...
EOF
```

Or project-local:

```bash
mkdir -p .claude
cat > .claude/ethos.local.md << 'EOF'
---
name: project-principles
description: Principles for this specific project
---

Project-specific principles here...
EOF
```

## Tips

- Keep principles concise (~150-200 words) to maximize survival through compaction
- Focus on principles that meaningfully shape behavior, not generic advice
- Changes take effect at the next session start
- The `.local.md` files are gitignored by convention to keep principles personal
