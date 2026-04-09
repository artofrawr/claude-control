---
description: Resume executing a plan from a previous conversation or external source
name: plan-execution
---

You are resuming execution of a previously created plan. This command is for continuing work that was started in another conversation or executing a plan provided externally. If you just created a plan with `/plan` in this conversation, you don't need this — just start executing.

<plan_description>
$ARGUMENTS
</plan_description>

## Execution Protocol

### 1. Locate the Spec

The plan should contain ordered slices with behavioral assertions (Given/When/Then). If it doesn't:
- If it's a high-level plan without slices, decompose it into vertical slices first (follow the slicing methodology from the `/plan` command)
- If it's already decomposed, proceed to execution

### 2. Execute Slice by Slice

For each slice in order:

1. **Read the acceptance criteria** — understand what "done" looks like before writing code
2. **Write the test first** when practical — translate the Given/When/Then into an actual test. If the slice isn't unit-testable (e.g., visual change, config file), note what you'll verify manually instead
3. **Implement** — write the minimum code to pass the test/meet the criteria. Load relevant skills for domain-specific guidance
4. **Verify** — run the test, check types compile, lint passes:
   ```bash
   tsc --noEmit
   eslint --max-warnings=0 [changed files]
   jest --passWithNoTests [related test files]
   ```
5. **Move on** only when the slice is green. If it's not, fix it before proceeding — compound failures from skipping ahead are much harder to debug

### 3. Handle Blockers

When a slice can't be implemented as specified:

**Trivial** (fix directly): Missing imports, typos, simple type annotations

**Minor** (fix and note): Algorithm tweaks, error handling additions, performance adjustments within the same approach. Document what changed and why:
```markdown
## Deviation: [what changed]
**Reason:** [why the spec's approach didn't work]
**Impact:** [effects on remaining slices]
```

**Major** (stop and ask): Fundamental approach changes, architecture modifications, changes that invalidate later slices. Don't silently deviate from the agreed plan.

### 4. Wrap Up

After all slices are complete:
- Run the full test suite, not just slice-specific tests
- Confirm every acceptance criterion from the spec is met
- List any deviations and their rationale
- Note remaining work or follow-up items
