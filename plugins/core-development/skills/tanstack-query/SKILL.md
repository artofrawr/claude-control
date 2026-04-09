---
name: TanStack Query
description: This skill should be used when the user asks to "fetch data", "cache API data", "implement optimistic updates", "use TanStack Query", "handle loading states", "invalidate queries", "prefetch data", "implement infinite scroll", "manage server state", or works with @tanstack/react-query for server state management. Provides patterns for efficient data fetching, caching, and synchronization.
version: 1.1.0
disable-model-invocation: false
---

# TanStack Query

## When to Use

- Fetching, caching, and synchronizing server state in React
- Any data that lives on a server and can become stale
- Scenarios needing background refetch, optimistic updates, or cache invalidation

When NOT to use:
- Client-only state (UI toggles, form drafts, theme) — use React state or Zustand
- One-shot fetches that never need caching (e.g., file download trigger)
- Static data baked into the build — just import it

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "All query keys use the factory pattern from `src/lib/queryKeys.ts`"
- "Default staleTime is 5 minutes; override per-query only with justification"
- "Custom hooks live in `src/hooks/queries/` named `use<Entity>.ts`"
- "Always wrap queries in custom hooks — never use `useQuery` directly in components"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Query keys must be serializable and deterministic**: Objects with unstable references (new object each render) cause infinite refetches. Always use a query key factory or stable references.
- **`staleTime` vs `gcTime` confusion**: `staleTime` controls when a background refetch triggers (0 = always refetch). `gcTime` controls when inactive cache entries are garbage collected. Setting `staleTime > gcTime` is pointless — the data gets garbage collected before it could be considered fresh.
- **Forgetting `enabled: false` causes waterfall bugs**: A dependent query without `enabled: !!parentData` fires immediately with `undefined`, producing a bad request or wrong cache entry.
- **`onSuccess`/`onError` on `useQuery` are deprecated in v5**: Move side effects to the `queryFn` itself, or use `useEffect` watching the query result. Only `useMutation` still has callbacks.
- **Optimistic updates need all three callbacks**: `onMutate` (optimistic set + snapshot), `onError` (rollback from snapshot), `onSettled` (invalidate to sync). Missing the rollback means stale UI on server error. Missing the invalidate means the optimistic value never gets reconciled.
- **`invalidateQueries` triggers refetch only for active queries**: Inactive queries get marked stale but don't refetch until a component mounts with that key. Use `refetchType: 'all'` if you need inactive queries to also refetch.
- **`placeholderData` vs `initialData`**: `placeholderData` is UI-only (never written to cache, shows loading skeleton semantics). `initialData` is treated as real cached data with a `dataUpdatedAt`. Using `initialData` without `staleTime` means it's immediately stale and triggers a refetch.
- **`select` runs on every render if not memoized**: Wrap your `select` function in `useCallback` or define it outside the component. Otherwise it creates a new reference each render and the derived data is recomputed unnecessarily.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Standard CRUD page | Custom hook wrapping `useQuery` + `useMutation` with invalidation |
| Dependent data (user then user's posts) | Chain with `enabled: !!parentData`, not nested components |
| Dashboard with multiple independent fetches | Separate `useQuery` calls (they run in parallel automatically) |
| Dynamic number of queries | `useQueries` with a mapped array |
| Paginated list | `keepPreviousData` for seamless page transitions |
| Infinite scroll | `useInfiniteQuery` with `getNextPageParam` |
| Prefetch on hover/route | `queryClient.prefetchQuery` in event handler or route loader |
| Form submission | `useMutation` with `onSuccess` invalidation, not `useQuery` |
| Toggle/like button (instant feedback) | Optimistic update with rollback pattern in `onMutate`/`onError` |
| Real-time data (WebSocket/SSE) | Use `queryClient.setQueryData` from the socket handler + `staleTime: Infinity` |
| SSR/Next.js | `prefetchQuery` in server component + `HydrationBoundary` |
