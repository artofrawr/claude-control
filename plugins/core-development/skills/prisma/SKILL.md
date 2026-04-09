---
name: Prisma
description: This skill should be used when the user asks to "create a prisma schema", "add a database model", "run migrations", "write prisma queries", "define relations", "use findMany", "handle transactions", "optimize database queries", or works with Prisma ORM for database schema design, migrations, and data access patterns.
version: 1.1.0
disable-model-invocation: false
---

# Prisma

## When to Use

- Designing or modifying database schemas
- Writing queries involving relations, filtering, or aggregation
- Managing migrations (especially breaking changes)
- Working with transactions that need atomicity guarantees

When NOT to use:
- Simple key-value lookups or caching — use Redis or in-memory stores
- Read-heavy analytics — consider raw SQL or a dedicated analytics layer
- Schema-less or document-oriented data — consider MongoDB directly

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Always use cursor-based pagination for public APIs, offset for admin"
- "Put PrismaService in a shared database module, never instantiate PrismaClient directly"
- "All models must have createdAt/updatedAt fields"
- "Use @map/@@@map to keep DB column names snake_case while code uses camelCase"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **N+1 queries**: Always use `include` or `select` with relations rather than querying in a loop. If you see a `findMany` followed by per-record `findUnique` calls, combine them.
- **`select` vs `include`**: Cannot use both at the same level — `select` limits fields returned, `include` adds relations to full result. Pick one.
- **Interactive vs array transactions**: Use `$transaction([...])` (array) for independent operations. Use `$transaction(async (tx) => {...})` (interactive) when later operations depend on earlier results. The array form is simpler but you can't reference created IDs.
- **Required column migrations**: Never add a required column in one step on a table with existing data. Add as optional → backfill → make required (see `references/migrations.md`).
- **`updateMany` returns count, not records**: Unlike `update`, `updateMany` doesn't return the updated records — only `{ count: number }`.
- **Unique constraint errors**: Catch `PrismaClientKnownRequestError` with code `P2002` for duplicate key violations. Don't let these bubble as 500s.
- **JSON field queries**: The `path` syntax varies by database provider (PostgreSQL vs MySQL). Always check which provider you're targeting.
- **Implicit many-to-many**: Prisma auto-creates the join table, but you lose control over it. For join tables that need extra fields (e.g., `assignedAt`), use explicit many-to-many with a relation model.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Need created record's ID in same transaction | Interactive transaction (`$transaction(async (tx) => {})`) |
| Independent batch operations | Array transaction (`$transaction([...])`) |
| High-contention updates (inventory, balance) | Optimistic concurrency with version field, or `FOR UPDATE` row lock |
| Paginating public API results | Cursor-based pagination (stable under concurrent writes) |
| Paginating admin/internal lists | Offset pagination (simpler, page jumping) |
| Complex filtering from user input | Build `where` object dynamically using `Prisma.UserWhereInput` type |
| Need fields from multiple relations | `include` with nested `select` to avoid over-fetching |
| Reporting/analytics queries | Raw SQL via `$queryRaw` — Prisma's query builder isn't designed for complex aggregations |

## References

- **`references/migrations.md`** — Safe migration patterns for breaking schema changes (adding required columns, renaming, type changes, production workflows). Consult when making non-trivial schema changes.
