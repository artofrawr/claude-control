---
description: Coordinate systematic debugging using focused skills
name: debug
---

You are orchestrating a systematic debugging process to identify and resolve issues efficiently.

Issue to debug: {user will describe the issue}

## Debugging Protocol

### Phase 1: Investigation & Diagnosis

1. **Initial Analysis**
   - Analyze symptoms and error messages
   - Reproduce the issue if possible
   - Gather diagnostic information (logs, stack traces, environment)
   - Form initial hypotheses
   - Identify affected components

2. **Domain-Specific Investigation**
   Based on issue type, apply relevant skills:
   - **Data fetching issues** - Use tanstack-query skill for caching/state debugging
   - **Form issues** - Use react-hook-form skill for validation/state debugging
   - **Validation errors** - Use zod skill for schema debugging
   - **Table rendering** - Use tanstack-table skill for column/filter debugging
   - **UI/styling issues** - Use chakra-ui skill for theme/responsive debugging
   - **Backend errors** - Use nestjs skill for module/guard/interceptor debugging
   - **Database issues** - Use prisma skill for query/migration debugging
   - **Search problems** - Use typesense skill for index/query debugging
   - **Real-time sync** - Use convex skill for subscription/mutation debugging
   - **Build/workspace** - Use nx-monorepo skill for dependency/build debugging
   - **Error tracking** - Use sentry skill to check captured errors, breadcrumbs, and context
   - **Performance issues** - Use react-expertise skill for render optimization
   - **Type errors** - Use typescript-expertise skill for type debugging

### Phase 2: Root Cause Identification

3. **Root Cause Analysis**
   - Synthesize findings from Phase 1
   - Narrow down to specific root cause
   - Identify contributing factors
   - Assess impact and severity

4. **Architecture Assessment** (if needed)
   Use architecture-review skill to:
   - Determine if issue stems from architectural/design problem
   - Evaluate if fix requires architectural changes
   - Assess long-term implications

### Phase 3: Solution Implementation

5. **Write a failing test first**
   - Before touching the fix, write a test that reproduces the bug — it should fail now and pass after the fix
   - Use the behavioral format: Given <setup that triggers the bug>, when <action>, then <expected correct behavior>
   - If the bug isn't unit-testable (visual glitch, timing issue), document the manual reproduction steps instead
   - This test becomes your proof that the fix works and your regression guard

6. **Implement Fix**
   - Apply patterns from relevant skills
   - Ensure fix addresses root cause, not just symptoms
   - Consider edge cases and side effects
   - The failing test from step 5 should now pass

7. **Verify Resolution**
   - Confirm the reproduction test passes
   - Run the broader test suite to check for side effects
   - Validate against the original symptoms from Phase 1

### Phase 4: Prevention & Documentation

8. **Document Learnings**
   - Issue pattern
   - Root cause
   - Solution approach
   - Prevention measures

## Deliverables

At completion, provide:

### Debug Summary
- **Issue**: Brief description
- **Root Cause**: Technical explanation
- **Resolution**: What was changed
- **Prevention**: Steps to avoid recurrence

### Action Items
- [ ] Fix implemented
- [ ] Regression tests added
- [ ] Documentation updated
- [ ] Similar issues checked
