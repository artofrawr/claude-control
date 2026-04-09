---
description: Conduct comprehensive code review using focused skills
name: review
---

You are conducting a thorough code review using specialized skills for different perspectives.

Files/code to review: {user will provide files or code}

## Review Process

1. **Architecture Review** - Use architecture-review skill
   - Design patterns and consistency
   - Component boundaries
   - Integration approach
   - Long-term maintainability

2. **Library Usage Review** - Apply relevant library skills
   Based on what libraries are used in the code:
   - **tanstack-query** - Query key patterns, caching strategy, mutation handling
   - **react-hook-form** - Form patterns, validation integration, performance
   - **zod** - Schema design, type inference, error handling
   - **tanstack-table** - Column definitions, state management, performance
   - **chakra-ui** - Component usage, theme consistency, accessibility
   - **convex** - Function patterns, real-time subscriptions, auth integration
   - **nestjs** - Module structure, guard/interceptor usage, dependency injection
   - **prisma** - Query efficiency, relation handling, transaction usage
   - **typesense** - Search query patterns, index design, sync approach
   - **nx-monorepo** - Library boundaries, import rules, build configuration
   - **sentry** - Error boundary coverage, breadcrumb quality, performance instrumentation

3. **Code Quality Review**
   - Code maintainability
   - Complexity analysis
   - Potential improvements
   - Consistency with codebase patterns

4. **Type Safety Review** - Use typescript-expertise skill
   - Type correctness
   - Generic usage
   - Strict mode compliance

5. **Performance Review** - Use react-expertise skill (if applicable)
   - Render optimization
   - Memoization usage
   - State management efficiency

## Review Output

Synthesize findings into categorized report:

**Critical Issues** (must fix before merge):
- [List with clear rationale]

**Important Improvements** (should fix soon):
- [List with suggestions]

**Nice-to-Haves** (could fix in future):
- [List optional improvements]

**Positive Highlights**:
- [List good practices found]

**Overall Recommendation**:
- Approve / Request changes / Reject with clear rationale

Note: Skip review aspects that aren't relevant to the changes (e.g., no need for tanstack-query review on code that doesn't fetch data).
