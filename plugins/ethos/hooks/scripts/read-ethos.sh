#!/usr/bin/env bash
# read-ethos.sh — Read personal principles with three-tier fallback
# Used by both SessionStart and PreCompact hooks

PLUGIN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# Three-tier fallback:
# 1. Project-local ethos
# 2. User-global ethos
# 3. Plugin default principles
ETHOS_FILE=""
ETHOS_SOURCE=""

if [[ -n "$CLAUDE_PROJECT_DIR" ]] && [[ -f "$CLAUDE_PROJECT_DIR/.claude/ethos.local.md" ]]; then
  ETHOS_FILE="$CLAUDE_PROJECT_DIR/.claude/ethos.local.md"
  ETHOS_SOURCE="project-local"
elif [[ -f "$HOME/.claude/ethos.local.md" ]]; then
  ETHOS_FILE="$HOME/.claude/ethos.local.md"
  ETHOS_SOURCE="user-global"
else
  ETHOS_FILE="$PLUGIN_ROOT/skills/principles/SKILL.md"
  ETHOS_SOURCE="plugin-default"
fi

if [[ ! -f "$ETHOS_FILE" ]]; then
  exit 0
fi

# Extract body after YAML frontmatter (skip --- delimited block)
BODY=$(awk '
  BEGIN { in_frontmatter=0; past_frontmatter=0 }
  /^---$/ {
    if (!past_frontmatter) {
      if (in_frontmatter) { past_frontmatter=1; next }
      else { in_frontmatter=1; next }
    }
  }
  past_frontmatter { print }
' "$ETHOS_FILE")

# If no frontmatter found, use the whole file
if [[ -z "$BODY" ]]; then
  BODY=$(cat "$ETHOS_FILE")
fi

# Build the full message and escape for JSON
FULL_MESSAGE="[ethos: ${ETHOS_SOURCE}] These are the user's personal principles. Follow them throughout the conversation:

${BODY}"

echo "$FULL_MESSAGE" | python3 -c '
import json, sys
msg = sys.stdin.read()
print(json.dumps({"systemMessage": msg}))
'
