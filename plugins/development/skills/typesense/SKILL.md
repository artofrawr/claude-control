---
name: Typesense
description: This skill should be used when the user asks to "create a typesense collection", "build a search index", "write typesense queries", "implement faceted search", "add full-text search", "sync search data", or works with Typesense search engine for collection schemas, indexing, querying, and search result optimization.
version: 1.1.0
disable-model-invocation: false
---

# Typesense

## When to Use

- Implementing full-text search, autocomplete, or typeahead
- Building faceted navigation (filter sidebar with counts)
- Need typo-tolerant search with minimal configuration
- Syncing a PostgreSQL/Prisma data source to a search index

When NOT to use:
- Primary data store — Typesense is a search index, not a database. Always keep the source of truth in PostgreSQL.
- Complex aggregations or analytics — use SQL or a dedicated analytics tool
- Log search or time-series data — use Elasticsearch or a logging platform
- Small datasets (< 1000 records) where a simple SQL `LIKE` or `ILIKE` query suffices

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Always use collection aliases ('products') pointing to versioned collections ('products_v3')"
- "Sync is queue-based via BullMQ — never sync inline in request handlers"
- "All collections must have an updatedAt int64 field for incremental sync"
- "Use scoped API keys on the client — never expose the admin key"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **`default_sorting_field` is immutable**: You must set it at collection creation time and it cannot be changed later. Pick a field you'll commonly sort by (usually a timestamp). It must be `int32`, `int64`, or `float`.
- **`facet: true` must be set at schema time**: You cannot facet on a field unless the schema declares `facet: true`. Adding it later requires reindexing (create new collection, reimport, swap alias).
- **Schema changes require reindexing**: Unlike databases, you can't alter field types or add facets to existing fields. Use the alias swap pattern: create new collection with updated schema, full sync, swap alias, delete old collection.
- **Bulk import error handling**: `documents().import()` returns an array of results per document — it does NOT throw on partial failures. Always check for items where `success === false`.
- **`filter_by` syntax gotchas**: Equality uses `:=` not `=`. Multiple values in the same field use `:=[A, B]` (OR). Cross-field filters use `&&`. Getting the syntax wrong returns empty results, not an error.
- **Geo fields are `[lat, lng]`**: The array order is latitude first, then longitude. Reversing them gives results in the wrong hemisphere.
- **`per_page: 0` for count-only queries**: If you only need the `found` count (e.g., for facet range counts), set `per_page: 0` to skip document retrieval.
- **Scoped search keys for client-side**: Never expose the admin API key to the browser. Generate scoped search keys server-side with embedded `filter_by` for multi-tenant isolation.
- **Sync drift**: If you sync inline in request handlers, failures silently desync the index. Use a queue (BullMQ) with retries and dead-letter handling, plus periodic drift detection.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Initial data load | Batch import with `action: 'upsert'`, 1000 docs per batch |
| Real-time sync from Prisma writes | Queue-based sync (BullMQ) triggered by Prisma middleware |
| Periodic catch-up sync | Incremental sync using `updatedAt >= lastSyncTime` |
| Schema change (add facet, change type) | Zero-downtime reindex: new collection, full sync, alias swap |
| Client-side search in multi-tenant app | Scoped search key with embedded `filter_by: 'tenantId:=X'` |
| Autocomplete / typeahead | `prefix: true` with `per_page: 5` on a lightweight `query_by` field |
| Faceted navigation with price ranges | Multiple `per_page: 0` queries with range `filter_by`, or manual range buckets |
| Search across multiple collections | `client.multiSearch.perform()` with separate search objects per collection |
| Group results by category | `group_by: 'category'` with `group_limit` for max items per group |
| Hybrid text + semantic search | Add `float[]` field with `num_dim`, use `vector_query` with `alpha` for weighting |
