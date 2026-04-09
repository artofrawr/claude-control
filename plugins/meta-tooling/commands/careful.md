---
name: careful
description: Activate destructive command warnings
---

```bash
touch "$HOME/.claude/guardrails-careful-active"
echo "ACTIVE"
```

Careful mode is now **active**. I'll prompt for confirmation before executing any of these destructive patterns:

- `rm -rf` / `rm -r` (except safe targets like node_modules, dist, build, .cache, .next, __pycache__, .turbo, coverage)
- `DROP TABLE` / `DROP DATABASE` / `TRUNCATE`
- `git push --force` / `git push -f`
- `git reset --hard`
- `git checkout .` / `git restore .`
- `kubectl delete`
- `docker rm -f` / `docker system prune`

To deactivate, delete `~/.claude/guardrails-careful-active`.
