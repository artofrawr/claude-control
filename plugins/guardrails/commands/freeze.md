---
name: freeze
description: Restrict file edits to a specific directory
user_facing: true
arguments:
  - name: directory
    description: The directory to restrict edits to (absolute or relative path)
    required: true
---

```bash
DIR="$1"
if [[ -z "$DIR" ]]; then
  echo "ERROR: Please provide a directory path. Usage: /freeze <directory>"
  exit 1
fi
# Resolve to absolute path
RESOLVED=$(python3 -c "import os; print(os.path.realpath('$DIR'))")
echo "$RESOLVED" > "$HOME/.claude/guardrails-freeze-dir.txt"
echo "FROZEN:$RESOLVED"
```

Freeze mode is now **active**. All Edit and Write operations are restricted to:

**`$1`**

Any attempt to modify files outside this directory will be blocked. Use `/unfreeze` to remove this restriction.

> **Note:** Freeze covers the Edit and Write tools. Bash redirects (e.g., `echo > file.txt`) are not covered in this version.
