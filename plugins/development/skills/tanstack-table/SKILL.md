---
name: TanStack Table
description: This skill should be used when the user asks to "create a data table", "implement table sorting", "add table filtering", "paginate table data", "virtualize large tables", "create column definitions", "use TanStack Table", or works with @tanstack/react-table on complex data grid implementations. Provides patterns for building performant, feature-rich data tables with full TypeScript support.
version: 1.1.0
disable-model-invocation: false
---

# TanStack Table

## When to Use

- Interactive data grids needing sorting, filtering, pagination, or row selection
- Full control over table markup and styling (headless — you render everything)
- Complex features like column resizing, pinning, grouping, or virtualization

When NOT to use:
- Simple static tables with no interactivity — use plain `<table>` elements
- Display-only lists without sorting/filtering — a simple `.map()` is clearer
- Spreadsheet-level editing (cell formulas, real-time collaboration) — consider a dedicated datagrid library

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Reusable DataTable component lives in `src/components/ui/DataTable.tsx`"
- "Column definitions are always memoized with useMemo"
- "Server-side pagination is the default; client-side only for < 100 rows"
- "Use createColumnHelper<T>() for type-safe column defs, never raw ColumnDef[]"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Columns and data must be memoized or stable references**: Passing a new array literal each render (`columns={[...]}`) causes the entire table to re-initialize every render. Always `useMemo` for columns and ensure data has a stable reference.
- **Headless means zero default UI**: Unlike other table libraries, nothing renders without your markup. Every header, cell, pagination button, and sort indicator must be explicitly rendered with `flexRender` and the table API.
- **Row models are additive and order matters**: You must explicitly add each feature's row model (`getSortedRowModel()`, `getFilteredRowModel()`, `getPaginationRowModel()`). Missing one means that feature silently does nothing. Filtering should come before sorting, which should come before pagination.
- **`accessorKey` with dots accesses nested properties**: `accessorKey: 'address.city'` traverses the object. If your actual key contains a dot, use `accessorFn` instead.
- **Client-side pagination holds all data in memory**: For datasets > 1,000 rows, use `manualPagination: true` with server-side pagination. For 1,000-10,000 rows without server pagination, use row virtualization.
- **`manualSorting`/`manualFiltering` disables built-in logic entirely**: When using server-side operations, you must set these flags. Otherwise TanStack Table applies its own sorting/filtering on top of the server's, producing wrong results.
- **Column `id` is required for non-accessor columns**: Display columns (actions, checkboxes) and `accessorFn` columns need an explicit `id`. Without it, the column silently breaks or collides.
- **`getToggleSortingHandler()` vs `toggleSorting()`**: The handler version is for DOM event props (`onClick`). Calling `toggleSorting()` directly in an event handler works but doesn't handle multi-sort (shift-click) automatically.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| < 100 rows, interactive | Client-side everything (sorting, filtering, pagination row models) |
| 100-1,000 rows | Client-side with `getPaginationRowModel()` |
| 1,000-10,000 rows | Client-side data + row virtualization (`@tanstack/react-virtual`) |
| > 10,000 rows | Server-side pagination (`manualPagination`, `manualSorting`, `manualFiltering`) |
| Type-safe column definitions | `createColumnHelper<T>()` — better inference than raw `ColumnDef<T>[]` |
| Action buttons / checkboxes | Display column with `id` (no accessor), `enableSorting: false` |
| Searchable table | Global filter with debounced input, not per-column filters |
| Faceted filters (status badges with counts) | `getFacetedRowModel()` + `getFacetedUniqueValues()` |
| Columns user can show/hide | `columnVisibility` state + toggle UI |
| Sticky first/last columns | Column pinning state (`left: ['name']`, `right: ['actions']`) |
| Need data from TanStack Query | Server-side pagination params from table state fed into `useQuery` key |
