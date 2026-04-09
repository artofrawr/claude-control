---
name: Nx Monorepo
description: This skill should be used when the user asks to "create a library", "run nx affected", "use nx generate", "manage a monorepo", "create a shared library", "view the project graph", "run nx build", "configure nx caching", or works with Nx workspace organization, library creation, build optimization, and dependency management patterns.
version: 1.1.0
disable-model-invocation: false
---

# Nx Monorepo

## When to Use

- Organizing apps and libraries in an Nx workspace
- Creating new libraries and deciding on library type/scope
- Configuring caching, affected commands, or CI pipelines
- Setting up or enforcing module boundary rules
- Understanding why a build is slow or cache is missing

When NOT to use:
- Single-package repos or simple npm workspaces without Nx
- Questions about bundlers/compilers themselves (Webpack, esbuild) — use those tools' docs
- General TypeScript or Node.js questions unrelated to workspace structure

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Library naming: libs/{scope}/{type}-{name} (e.g., libs/users/data-access-profile)"
- "Tags: always use both type: and scope: tags on every project"
- "All new libraries must be buildable unless they're pure types"
- "Use @myorg/ import prefix for all library paths"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Cache misses from unlisted inputs**: If a target depends on an env var, root config file, or codegen output, you must declare it in `inputs` or the cache will serve stale results. Use `{ "env": "VAR" }` and `{ "externalDependencies": [...] }` explicitly.
- **`--buildable` vs `--publishable`**: Buildable gives independent build output for caching. Publishable adds `package.json` and import path for npm publishing. Don't use `--publishable` for internal-only libraries — it adds unnecessary config.
- **Circular dependency detection is lazy**: Nx won't always catch circular deps until you run `nx graph` or lint with `@nx/enforce-module-boundaries`. Check the graph when adding cross-library imports.
- **`affected` base ref in CI**: If you don't set `--base` correctly (or use `nrwl/nx-set-shas`), affected will compare against the wrong commit and either rebuild everything or miss changes.
- **Generators mutate the tree, not the filesystem**: Custom generators write to a virtual tree. If you shell out to `execSync` inside a generator, those changes won't be part of the dry-run preview.
- **Moving libraries breaks import paths**: `@nx/workspace:move` updates `tsconfig.base.json` paths, but won't catch dynamic imports, string references in configs, or CI scripts that hardcode paths.
- **`run-many --all` ignores `dependsOn`**: If you run `--all` without `--target` having `dependsOn: ["^build"]`, dependencies may not build first. Always verify your task pipeline in `nx.json`.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| New shared code used by 2+ apps | Create a library — don't duplicate code across apps |
| Shared types only (no runtime code) | `@nx/js:library` with `--bundler=none`, no buildable flag needed |
| Library used by many projects, changes rarely | Make it `--buildable` for independent caching |
| Need to publish to npm | Use `--publishable --importPath=@scope/name` |
| Enforcing dependency rules | Tag projects (`type:`, `scope:`) + `@nx/enforce-module-boundaries` ESLint rule |
| CI running too many tasks | Use `nx affected` with correct base/head refs + Nx Cloud for distributed caching |
| Custom scaffolding for team patterns | Write a workspace generator under `tools/generators/` — prefer this over copy-paste templates |
| Build is slow locally | Check `nx graph --target=build` for unnecessary deps in the critical path; tune `parallel` count |
