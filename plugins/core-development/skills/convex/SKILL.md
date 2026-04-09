---
name: Convex
description: This skill should be used when the user asks to "create convex function", "convex query", "convex mutation", "convex schema", "use convex", "convex database", "real-time data", or works with convex for building reactive backends with TypeScript.
version: 1.1.0
disable-model-invocation: false
---

# Convex

## When to Use

- Building features that need real-time reactivity (data syncs automatically to UI)
- CRUD operations with end-to-end TypeScript type safety
- Scheduling background jobs or cron tasks without infrastructure
- File uploads with built-in storage

When NOT to use:
- Complex relational queries with JOINs across many tables — Convex is a document database, not SQL
- Workloads requiring raw SQL or stored procedures
- Applications that need to run fully offline-first (Convex requires connectivity)
- High-volume analytics or bulk data processing — Convex functions have execution time limits

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "All tables must have createdAt (v.number()) and updatedAt fields"
- "Use a shared requireUser() helper for auth, never inline ctx.auth.getUserIdentity() checks"
- "Put internal functions in convex/internal/ to separate them from public API"
- "Always define compound indexes for queries that filter on multiple fields"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Queries cannot have side effects**: Queries must be pure reads. No `ctx.db.insert/patch/delete`, no `fetch()`, no `console.log` with external state. These will fail at runtime. Use mutations for writes, actions for external calls.
- **Actions cannot read/write the database directly**: Actions run in Node.js and have no `ctx.db`. You must call `ctx.runQuery()` or `ctx.runMutation()` to interact with the database from an action. Each call is a separate transaction.
- **Missing indexes cause full table scans**: `.filter()` after `.query("table")` scans every document. Always use `.withIndex()` for equality and range checks. Add the index to your schema first.
- **Index field order matters**: In a compound index `["orgId", "status", "createdAt"]`, you can query `orgId` alone, or `orgId + status`, but NOT `status` alone or `status + createdAt`. The leftmost prefix must always be included.
- **`.collect()` loads everything into memory**: On large tables, `.collect()` will load all matching documents. Use `.paginate()` for user-facing lists, `.take(n)` for bounded results, or `.first()` when you only need one.
- **`useQuery` returns `undefined` while loading**: Not `null`, not an empty array — `undefined`. Check for `undefined` (loading) vs `null` (authenticated no-result) vs actual data. Rendering `undefined.map()` is a common crash.
- **Mutations are transactions but actions are not**: A mutation runs atomically — if it throws, all writes roll back. An action calling multiple `runMutation` calls does NOT roll back earlier mutations if a later one fails. Design for partial failure.
- **`v.optional()` vs missing field**: `v.optional(v.string())` means the field can be `undefined` in TypeScript, but Convex distinguishes between a field set to `undefined` and a field not present at all. Use `patch` carefully — passing `undefined` does not remove a field.
- **Scheduled function arguments must be serializable**: You cannot pass callbacks, class instances, or Dates to `ctx.scheduler.runAfter`. Use plain objects and numbers (timestamps instead of Date objects).

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Read data reactively in UI | `query` + `useQuery` — auto-updates when data changes |
| Write data (create, update, delete) | `mutation` — runs as an atomic transaction |
| Call external API or use Node.js libs | `action` — then call `runMutation` to save results |
| Recurring background job | `crons.ts` with `cronJobs()` targeting `internalMutation` or `internalAction` |
| One-time delayed task | `ctx.scheduler.runAfter(delayMs, internal.fn, args)` inside a mutation |
| Large list in UI | `usePaginatedQuery` with `paginationOptsValidator` in the query |
| Auth-protected function | Helper `requireUser(ctx)` that throws if `ctx.auth.getUserIdentity()` is null |
| Multi-table write that must be atomic | Single mutation that does all writes (not an action with multiple runMutation calls) |
| Need to filter on two fields | Compound index with both fields, equality fields first, range field last |
| File upload | `ctx.storage.generateUploadUrl()` mutation, POST file to URL, save `storageId` |
