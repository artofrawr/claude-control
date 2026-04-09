---
description: Analyze changes and suggest appropriate testing strategies
name: test
---

You are analyzing recent code changes to determine the appropriate testing strategy.

## Analysis Process

### Step 1: Identify Changes

Run `git diff --stat` and `git diff --name-only` to see what files have changed. Categorize each changed file:

| File Pattern | Category | Testing Approach |
|-------------|----------|-----------------|
| `src/components/**`, `src/pages/**` | Visual/UI | Component tests + visual regression |
| `src/hooks/**`, `src/utils/**`, `src/lib/**` | Logic | Unit tests with Jest |
| `src/api/**`, `src/services/**` | API/Integration | Integration tests |
| `convex/**` | Backend functions | Convex function tests |
| `prisma/**` | Database | Migration tests + query tests |
| `*.test.*`, `*.spec.*` | Tests themselves | Run the modified tests |

### Step 2: Recommend Testing Strategy

Based on the categorized changes:

**Visual/UI Changes:**
- If `playwright-testing` plugin is available: Suggest `/visual-test` or `/responsive-test`
- Otherwise: Recommend component-level tests with React Testing Library
- Check if Chakra UI components are affected (load chakra-ui skill for testing patterns)

**User Flows / E2E:**
- If `playwright-testing` plugin is available: Suggest `/run-test` for ad-hoc flow testing or `/run-scenario` for predefined scenarios
- Recommend for changes that affect multi-step user journeys (auth, checkout, onboarding)
- Pair with visual testing for comprehensive coverage

**UX/Usability:**
- If `playwright-synthetic` plugin is available: Suggest `/simulate-user` for persona-based usability testing
- Recommend when changes affect onboarding, navigation, or user-facing flows
- Useful for catching friction points that pass/fail tests miss

**Logic Changes:**
- Recommend Jest unit tests
- If using Zod schemas: validate schema edge cases
- If using TanStack Query hooks: test query/mutation behavior
- If using React Hook Form: test form submission and validation flows

**Backend Changes:**
- NestJS controllers/services: recommend e2e tests with supertest
- Convex functions: recommend Convex test harness
- Prisma schema changes: verify migration + test queries

**Full-Stack Changes:**
- Recommend both unit and integration tests
- Suggest visual regression if UI is affected
- Check for Sentry instrumentation on new error paths

### Step 3: Generate Test Suggestions

For each category of change, provide:

1. **What to test** - specific behaviors/scenarios
2. **How to test** - patterns from relevant skills
3. **Edge cases** - common pitfalls for the libraries involved
4. **Commands to run** - exact test commands

### Step 4: Run Tests

```bash
# Run affected tests
npx jest --passWithNoTests --changedSince=HEAD~1

# Type check
npx tsc --noEmit

# Lint changed files
npx eslint [changed files]
```

Report results and suggest additional test coverage if gaps are found.
