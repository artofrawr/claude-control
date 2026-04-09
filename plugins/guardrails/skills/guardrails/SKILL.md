---
name: guardrails
description: Safety guardrails overview — explains available guard modes and how to activate them
disable-model-invocation: true
---

This plugin provides safety guardrails for Claude Code sessions.

## Available Commands

- `/careful` — Activate destructive command warnings (rm -rf, DROP TABLE, force push, etc.)
- `/freeze <dir>` — Restrict file edits to a specific directory
- `/unfreeze` — Remove directory freeze restriction
- `/guard <dir>` — Activate both careful + freeze together

## How It Works

- **Careful mode** hooks into Bash tool calls and prompts for confirmation on destructive patterns
- **Freeze mode** hooks into Edit/Write tool calls and blocks modifications outside the allowed directory
- State is stored in `~/.claude/guardrails-careful-active` and `~/.claude/guardrails-freeze-dir.txt`
