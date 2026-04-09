#!/usr/bin/env bash
# check-new-file.sh — Prompt before creating files that don't already exist
# Gate: exit immediately if careful mode is not enabled
CAREFUL_FLAG="$HOME/.claude/guardrails-careful-active"
if [[ ! -f "$CAREFUL_FLAG" ]]; then
  exit 0
fi

# Read tool input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# If the file already exists, allow the write (it's an overwrite, not a new file)
if [[ -e "$FILE_PATH" ]]; then
  exit 0
fi

echo "{\"permissionDecision\":\"ask\",\"message\":\"CAREFUL: Creating new file ${FILE_PATH}. Confirm this was requested.\"}"
exit 0
