---
name: Zod Schema Validation
description: This skill should be used when the user asks to "create a schema", "validate data with Zod", "parse API response", "create type-safe validation", "define types with Zod", "transform data", "handle validation errors", "use z.infer", or works with Zod for runtime type safety and validation. Provides patterns for schema design, transformations, and TypeScript integration.
version: 1.1.0
disable-model-invocation: false
---

# Zod Schema Validation

## When to Use

- Validating external data boundaries (API payloads, form input, env vars, config files)
- Creating a single source of truth for both runtime validation and TypeScript types
- Transforming data shape at system boundaries (e.g., snake_case API to camelCase internal)

When NOT to use:
- Internal types with no runtime boundary — use plain TypeScript interfaces
- Simple type narrowing that a type guard handles fine
- Performance-critical hot paths parsing thousands of objects per second — Zod adds measurable overhead

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "All API response schemas live in `src/schemas/` and are named `<entity>Schema`"
- "Always use `z.infer` for types — never duplicate a type alongside a schema"
- "Form schemas go in the same file as the form component"
- "Use branded types for all entity IDs (UserId, PostId, etc.)"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **`z.object()` strips unknown keys by default**: Data passes validation but extra fields silently disappear. Use `.passthrough()` when forwarding data you don't fully own, `.strict()` when you want to reject unexpected fields.
- **`.optional()` vs `.nullable()` vs `.nullish()`**: These are not interchangeable. APIs typically send `null`, forms send `undefined`. Pick the one that matches your actual boundary.
- **`z.infer` gives you the output type**: After transforms and defaults. Use `z.input<typeof schema>` when you need the pre-transform type (e.g., for form initial values).
- **`.refine()` errors are invisible to `.flatten()`**: Custom refinements don't attach to a field path by default. Always pass `{ path: ['fieldName'] }` or the error lands in `formErrors` instead of `fieldErrors`.
- **Cross-field validation with `.refine()` runs after all fields validate**: If a field-level check fails, the cross-field check never runs and its error never shows. Use `.superRefine()` with `ctx.addIssue()` when you need to report multiple errors simultaneously.
- **`z.coerce.number()` turns empty strings into `0`**: This silently passes `.positive()` or `.min(1)` checks. For form inputs, use `.preprocess()` to convert empty strings to `undefined` first.
- **Schema composition with `.merge()` discards refinements**: If schema A has a `.refine()`, merging it with schema B loses that refinement. Use `.and()` (intersection) instead, or re-apply refinements after merge.
- **Async refinements require `.parseAsync()`/`.safeParseAsync()`**: Using `.parse()` with an async refinement silently skips the check. No error, no warning.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| API response with unknown shape | `safeParse` + handle error branch (never `.parse()` and hope) |
| Form validation with React Hook Form | Schema with `zodResolver`, use `z.input` for default values |
| Env vars at startup | `z.coerce` for type conversion, `.parse(process.env)` (crash early is fine) |
| Shared types between frontend and backend | Single schema file, export `z.infer` types |
| Discriminated API responses (success/error) | `z.discriminatedUnion` on a status/type field |
| Schema reuse across create/update | Base schema + `.partial()` for update, `.pick()` for specific forms |
| Data transformation at boundary | `.transform()` on the schema — keeps parse and transform atomic |
| Multiple related validation errors | `.superRefine()` with `ctx.addIssue()` for each, not chained `.refine()` |
