# guardrails

Safety guardrails for Claude Code sessions: destructive command warnings and directory freeze.

**Version:** 1.0.0

## Skills

| Skill | Description |
|-------|-------------|
| **guardrails** | Safety guardrails overview — explains available guard modes and how to activate them |

## Commands

| Command | Description |
|---------|-------------|
| `/careful` | Activate destructive command warnings |
| `/freeze <dir>` | Restrict file edits to a specific directory |
| `/unfreeze` | Remove directory freeze restriction |
| `/guard <dir>` | Activate both careful + freeze |

## How It Works

### Careful Mode

Hooks into all Bash tool calls and prompts for confirmation when destructive patterns are detected:

- `rm -rf` / `rm -r` (except safe targets like node_modules, dist, build, .cache, .next, __pycache__, .turbo, coverage)
- `DROP TABLE` / `DROP DATABASE` / `TRUNCATE`
- `git push --force` / `git push -f`
- `git reset --hard`
- `git checkout .` / `git restore .`
- `kubectl delete`
- `docker rm -f` / `docker system prune`

Uses `permissionDecision: "ask"` so you always get final say.

### Freeze Mode

Hooks into Edit and Write tool calls and blocks any file modification outside the specified directory. Uses `permissionDecision: "deny"` for a hard block.

## State Files

Both modes use flag files in `~/.claude/`:

- `guardrails-careful-active` — touch file, presence enables careful mode
- `guardrails-freeze-dir.txt` — contains the absolute path of the allowed directory

State files persist across sessions. Delete them manually to deactivate outside of a session.

## Known Limitations

- Freeze only covers Edit/Write tools, not Bash redirects (`echo > file.txt`)
- `rm` safe-target matching is basename-based (heuristic) — the `"ask"` permission means you always get final say
- State files persist across sessions — delete manually to deactivate
