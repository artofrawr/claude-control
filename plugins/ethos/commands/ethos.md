---
name: ethos
description: View or edit your personal principles
---

```bash
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

echo "=== ETHOS PRINCIPLES ==="

if [[ -n "$CLAUDE_PROJECT_DIR" ]] && [[ -f "$CLAUDE_PROJECT_DIR/.claude/ethos.local.md" ]]; then
  echo "SOURCE: project-local ($CLAUDE_PROJECT_DIR/.claude/ethos.local.md)"
  cat "$CLAUDE_PROJECT_DIR/.claude/ethos.local.md"
elif [[ -f "$HOME/.claude/ethos.local.md" ]]; then
  echo "SOURCE: user-global (~/.claude/ethos.local.md)"
  cat "$HOME/.claude/ethos.local.md"
else
  echo "SOURCE: plugin-default"
  cat "$PLUGIN_ROOT/skills/principles/SKILL.md"
fi
```

Here are your currently active principles. They are loaded at session start and re-injected before context compaction.

**Priority order:**
1. **Project-local**: `.claude/ethos.local.md` in the project directory
2. **User-global**: `~/.claude/ethos.local.md`
3. **Plugin default**: Built-in template principles

To customize, create an `ethos.local.md` file at either the project or user level. Changes take effect at the next session start.

Would you like me to help you create or edit a personalized `ethos.local.md`?
