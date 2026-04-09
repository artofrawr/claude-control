#!/usr/bin/env bash
# check-careful.sh — Warn on destructive commands when careful mode is active
# Gate: exit immediately if careful mode is not enabled
CAREFUL_FLAG="$HOME/.claude/guardrails-careful-active"
if [[ ! -f "$CAREFUL_FLAG" ]]; then
  exit 0
fi

# Read tool input from stdin
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

# Safe targets for rm — these are expected to be deleted regularly
SAFE_TARGETS="node_modules|\.next|dist|__pycache__|\.cache|build|\.turbo|coverage"

# Check for destructive rm patterns
if echo "$COMMAND" | grep -qE 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*|--recursive)\s'; then
  # Check if ALL rm targets are safe directories
  # Extract the arguments after rm and its flags
  RM_ARGS=$(echo "$COMMAND" | grep -oE 'rm\s+.*' | sed -E 's/^rm[[:space:]]+//' | sed -E 's/^(-[a-zA-Z]+[[:space:]]+)*//')
  ALL_SAFE=true
  for TARGET in $RM_ARGS; do
    # Skip flags
    if [[ "$TARGET" == -* ]]; then
      continue
    fi
    BASENAME=$(basename "$TARGET")
    if ! echo "$BASENAME" | grep -qE "^($SAFE_TARGETS)$"; then
      ALL_SAFE=false
      break
    fi
  done
  if [[ "$ALL_SAFE" == "false" ]]; then
    echo '{"permissionDecision":"ask","message":"CAREFUL: Recursive delete detected. Please confirm this is intentional."}'
    exit 0
  fi
fi

# Check for SQL destructive operations
if echo "$COMMAND" | grep -qiE '(DROP\s+(TABLE|DATABASE)|TRUNCATE\s)'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: Destructive SQL operation detected. Please confirm this is intentional."}'
  exit 0
fi

# Check for force push
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(-f|--force)'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: Force push detected. This rewrites remote history. Please confirm."}'
  exit 0
fi

# Check for git reset --hard
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: Hard reset detected. Uncommitted work will be lost. Please confirm."}'
  exit 0
fi

# Check for git checkout . or git restore .
if echo "$COMMAND" | grep -qE 'git\s+(checkout|restore)\s+\.'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: Discarding all uncommitted changes. Please confirm."}'
  exit 0
fi

# Check for kubectl delete
if echo "$COMMAND" | grep -qE 'kubectl\s+delete\s'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: kubectl delete detected. This may affect production. Please confirm."}'
  exit 0
fi

# Check for docker destructive operations
if echo "$COMMAND" | grep -qE 'docker\s+(rm\s+-f|system\s+prune)'; then
  echo '{"permissionDecision":"ask","message":"CAREFUL: Destructive Docker operation detected. Please confirm."}'
  exit 0
fi

exit 0
