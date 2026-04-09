---
description: Create a development plan using focused skills
name: plan
---

You are creating a development plan in two phases: first align on approach, then decompose into a testable spec. Present Phase 1 to the user for alignment before proceeding to Phase 2.

## Phase 1: Approach

Establish the high-level direction before breaking anything down.

1. **Understand the task** — What are we building/changing and why? What does "done" look like?
2. **Gather context** — Read relevant code, identify existing patterns, check for prior art in the codebase
3. **Propose approach** — Using architecture-review skill thinking where relevant:
   - Technical approach and key design decisions
   - Which parts of the codebase are affected
   - Trade-offs considered and why this approach wins
   - Risks or unknowns that could change the plan
   - Which library skills are relevant (tanstack-query, prisma, zod, etc.)

**Present Phase 1 to the user and wait for alignment before proceeding to Phase 2.**

If the user pushes back or suggests a different direction, revise. Don't move to decomposition until the approach is agreed on — decomposing the wrong approach wastes effort.

## Phase 2: Spec

Once the approach is aligned, decompose into an ordered list of **vertical slices**. Each slice is a small, independently testable unit of work.

### How to Slice

Good slices are **vertical** (they deliver a thin piece of working functionality end-to-end) not **horizontal** (don't do "all the database models first, then all the services, then all the UI").

Rules for slicing:
- Each slice should be completable in roughly 5-20 lines of changes
- Each slice must be independently verifiable — you can prove it works without completing later slices
- Each slice builds on the previous ones — order matters
- If a slice can't be verified independently, it's too thin — merge it with the next one
- If a slice touches more than 2-3 files, it's probably too thick — split it

### Spec Format

For each slice, write:

```
### Slice N: <short description>

**Changes**: <files to create/modify>

**Acceptance criteria**:
- Given <precondition>, when <action>, then <expected outcome>
- Given <precondition>, when <action>, then <expected outcome>

**Notes**: <any context, edge cases, or pitfalls from relevant skills>
```

The behavioral assertions (`Given/When/Then`) should be concrete enough that they can be directly translated into test cases. Avoid vague criteria like "works correctly" — specify the input, action, and expected output.

### Examples of Good vs Bad Slices

**Bad** (horizontal, not independently testable):
1. Create all Prisma models
2. Create all NestJS services
3. Create all controllers
4. Create all frontend components

**Good** (vertical, each delivers testable functionality):
1. Create User model + seed script — Given the seed runs, then 3 users exist in the database
2. Add GET /users endpoint — Given seeded users, when GET /users, then returns paginated user list with 3 results
3. Add user list page — Given the API returns users, when visiting /users, then the table renders with name and email columns
4. Add user search — Given 3 users exist, when typing "jane" in the search field, then only matching users appear

### Wrapping Up the Spec

After all slices, include:

**Execution guidance**:
- Work through slices in order, one at a time
- For each slice: write the test/assertion first when practical, then implement until it passes
- Verify each slice before moving to the next (tsc, lint, tests)
- If a slice can't be implemented as specified, stop and reassess — don't silently deviate

Task to plan: {user will provide the task}

Note: Adjust depth based on task size. A 2-slice bugfix doesn't need the full treatment. A multi-day feature does.
