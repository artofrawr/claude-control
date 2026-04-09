---
name: guard
description: Activate both destructive command warnings and directory freeze
user_facing: true
arguments:
  - name: directory
    description: The directory to restrict edits to (absolute or relative path)
    required: true
---

```bash
# Activate careful mode
touch "$HOME/.claude/guardrails-careful-active"
echo "CAREFUL:ACTIVE"

# Activate freeze mode
DIR="$1"
if [[ -z "$DIR" ]]; then
  echo "ERROR: Please provide a directory path. Usage: /guard <directory>"
  exit 1
fi
RESOLVED=$(python3 -c "import os; print(os.path.realpath('$DIR'))")
echo "$RESOLVED" > "$HOME/.claude/guardrails-freeze-dir.txt"
echo "FROZEN:$RESOLVED"
```

Guard mode is now **fully active**:

1. **Careful mode** — destructive command warnings enabled
2. **Freeze mode** — file edits restricted to: **`$1`**

Use `/unfreeze` to remove the directory restriction. Delete `~/.claude/guardrails-careful-active` to disable careful mode.
