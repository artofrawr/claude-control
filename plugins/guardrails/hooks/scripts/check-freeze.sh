#!/usr/bin/env bash
# check-freeze.sh — Block edits outside the frozen directory
# Gate: exit immediately if freeze mode is not enabled
FREEZE_FILE="$HOME/.claude/guardrails-freeze-dir.txt"
if [[ ! -f "$FREEZE_FILE" ]]; then
  exit 0
fi

ALLOWED_DIR=$(cat "$FREEZE_FILE")
if [[ -z "$ALLOWED_DIR" ]]; then
  exit 0
fi

# Read tool input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Resolve both paths for comparison (portable: python3 fallback for macOS)
resolve_path() {
  python3 -c "import os; print(os.path.realpath('$1'))"
}
RESOLVED_ALLOWED=$(resolve_path "$ALLOWED_DIR")
RESOLVED_FILE=$(resolve_path "$FILE_PATH")

# Check if file is within the allowed directory
if [[ "$RESOLVED_FILE" != "$RESOLVED_ALLOWED"* ]]; then
  echo "{\"permissionDecision\":\"deny\",\"message\":\"FREEZE: Edits are restricted to ${RESOLVED_ALLOWED}. File ${RESOLVED_FILE} is outside the allowed directory. Use /unfreeze to remove this restriction.\"}"
  exit 0
fi

exit 0
