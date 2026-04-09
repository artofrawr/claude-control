---
description: Detect project technologies and surface relevant skill guidance
hooks:
  - event: session_start
---

Inspect the current project to identify which core-development skills are relevant. Run these checks silently and only mention findings that are actionable.

## Detection Checks

1. **Check for `convex/` directory**
   - If found: Note that Convex patterns are available via the `convex` skill
   - Check `convex/schema.ts` for schema complexity

2. **Check for `nx.json`**
   - If found: Note that Nx workspace management is available via the `nx-monorepo` skill
   - Check workspace structure for library organization

3. **Check for `prisma/schema.prisma`**
   - If found: Note that Prisma patterns are available via the `prisma` skill

4. **Check `package.json` for `@sentry/*` dependencies**
   - If found: Remind that new features should include Sentry instrumentation (error boundaries, breadcrumbs)
   - If not found but project is production-facing: Suggest considering Sentry for observability

5. **Check `tsconfig.json` for strict mode**
   - If `strict` is not `true`: Warn that strict mode is not enabled, which may affect type safety guidance from skills

## Output Format

Only mention technologies that are detected. Keep it brief:

```
Detected: [list of found technologies]
Available skills: [matching skills]
[Any warnings, e.g., strict mode not enabled]
```

If nothing notable is detected, say nothing.
