---
name: unfreeze
description: Remove directory freeze restriction
---

```bash
FREEZE_FILE="$HOME/.claude/guardrails-freeze-dir.txt"
if [[ -f "$FREEZE_FILE" ]]; then
  PREV=$(cat "$FREEZE_FILE")
  rm "$FREEZE_FILE"
  echo "REMOVED:$PREV"
else
  echo "NOT_ACTIVE"
fi
```

Freeze mode has been **deactivated**. File edits are no longer restricted to any specific directory.
