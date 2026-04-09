---
name: code-review
description: Mandatory code reviews via /code-review before commits and deploys
disable-model-invocation: false
---

# Code Review Skill

*Load with: base.md*

**Purpose:** Enforce automated code reviews as a mandatory guardrail before every commit and deployment. Uses the official Claude Code Review plugin for comprehensive analysis.

---

## Core Philosophy

```
┌─────────────────────────────────────────────────────────────────┐
│  CODE REVIEW IS NON-NEGOTIABLE                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  Every commit must pass code review.                            │
│  Every PR must be reviewed before merge.                        │
│  Every deployment must include review sign-off.                 │
│                                                                 │
│  AI catches what humans miss. Humans catch what AI misses.      │
│  Together: fewer bugs, cleaner code, better security.           │
├─────────────────────────────────────────────────────────────────┤
│  INVOKE: /code-review                                           │
│  PLUGIN: code-review@claude-plugins-official                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## When to Run Code Review

### Mandatory Review Points

| Trigger | Action | Command |
|---------|--------|---------|
| **Before commit** | Review staged changes | `/code-review` |
| **Before PR** | Review all changes vs base | `/code-review` |
| **Before merge** | Final review of PR | `/code-review` |
| **Before deploy** | Review deployment diff | `/code-review` |

### Automatic Integration

**Run code review automatically before every commit:**

```
┌─────────────────────────────────────────────────────────────────┐
│  COMMIT WORKFLOW                                                │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  1. Write code                                                  │
│  2. Run tests (TDD - must pass)                                 │
│  3. Run /code-review  ← MANDATORY                               │
│  4. Address critical/high issues                                │
│  5. Commit                                                      │
│  6. Push                                                        │
│                                                                 │
│  Skip step 3? ❌ NO COMMIT ALLOWED                              │
└─────────────────────────────────────────────────────────────────┘
```

---

## Using the Code Review Plugin

### Basic Usage

```bash
# Review current changes
/code-review

# Review specific files
/code-review src/auth/*.ts

# Review a PR
/code-review --pr 123

# Review with specific focus
/code-review --focus security
/code-review --focus performance
/code-review --focus architecture
```

### Review Categories

The code review plugin analyzes:

| Category | What It Checks |
|----------|----------------|
| **Security** | Vulnerabilities, injection risks, auth issues, secrets |
| **Performance** | N+1 queries, memory leaks, inefficient algorithms |
| **Architecture** | Design patterns, SOLID principles, coupling |
| **Code Quality** | Readability, complexity, duplication |
| **Best Practices** | Language idioms, framework conventions |
| **Testing** | Coverage gaps, test quality, edge cases |
| **Documentation** | Missing docs, outdated comments |

### Severity Levels

| Level | Action Required | Can Commit? |
|-------|-----------------|-------------|
| 🔴 **Critical** | Must fix immediately | ❌ NO |
| 🟠 **High** | Should fix before commit | ❌ NO |
| 🟡 **Medium** | Fix soon, can commit | ✅ YES |
| 🟢 **Low** | Nice to have | ✅ YES |
| ℹ️ **Info** | Suggestions only | ✅ YES |

---

## Pre-Commit Hook Integration

### Install Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Running code review..."

# Run Claude code review on staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx|py|go|rs)$')

if [ -n "$STAGED_FILES" ]; then
    # Invoke code review (requires claude CLI)
    claude --print "/code-review $STAGED_FILES" > /tmp/code-review-result.txt 2>&1

    # Check for critical/high issues
    if grep -q "🔴\|Critical\|🟠\|High" /tmp/code-review-result.txt; then
        echo "❌ Code review found critical/high issues:"
        cat /tmp/code-review-result.txt
        echo ""
        echo "Fix these issues before committing."
        exit 1
    fi

    echo "✅ Code review passed"
fi

exit 0
```

### Make Hook Executable

```bash
chmod +x .git/hooks/pre-commit
```

---

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/code-review.yml
name: Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  code-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get changed files
        id: changed-files
        run: |
          echo "files=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | tr '\n' ' ')" >> $GITHUB_OUTPUT

      - name: Run Claude Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          npx @anthropic-ai/claude-code --print "/code-review ${{ steps.changed-files.outputs.files }}" > review.md

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');

            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.issue.number,
              body: `## 🔍 Claude Code Review\n\n${review}`
            });

      - name: Check for Critical Issues
        run: |
          if grep -q "Critical\|🔴" review.md; then
            echo "❌ Critical issues found"
            exit 1
          fi
```

---

## Review Checklist

### Before Every Commit

- [ ] Run `/code-review` on staged changes
- [ ] No critical (🔴) issues
- [ ] No high (🟠) issues
- [ ] Security concerns addressed
- [ ] Performance issues considered

### Before Every PR

- [ ] Full code review of all changes
- [ ] All critical/high issues resolved
- [ ] Tests added for new functionality
- [ ] Documentation updated if needed

### Before Every Deployment

- [ ] Final review of deployment diff
- [ ] Security scan passed
- [ ] No new vulnerabilities introduced
- [ ] Rollback plan documented

---

## Common Review Findings

### Security Issues (Always Fix)

| Issue | Example | Fix |
|-------|---------|-----|
| SQL Injection | `query = f"SELECT * FROM users WHERE id = {id}"` | Use parameterized queries |
| XSS | `innerHTML = userInput` | Sanitize or use textContent |
| Secrets in code | `apiKey = "sk-xxx"` | Use environment variables |
| Missing auth | Unprotected endpoints | Add authentication middleware |
| Insecure crypto | MD5/SHA1 for passwords | Use bcrypt/argon2 |

### Performance Issues (Should Fix)

| Issue | Example | Fix |
|-------|---------|-----|
| N+1 queries | Loop with individual queries | Use batch/eager loading |
| Memory leak | Unclosed connections | Use connection pooling |
| Missing index | Slow queries | Add database indexes |
| Large payload | Fetching unused fields | Select only needed fields |
| No pagination | Loading all records | Implement pagination |

### Code Quality (Nice to Fix)

| Issue | Example | Fix |
|-------|---------|-----|
| Long function | 100+ lines | Extract into smaller functions |
| Deep nesting | 5+ levels | Early returns, extract methods |
| Magic numbers | `if (status === 3)` | Use named constants |
| Duplicate code | Copy-pasted blocks | Extract shared function |
| Missing types | `any` everywhere | Add proper TypeScript types |

---

## Integration with TDD Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  TDD + CODE REVIEW WORKFLOW                                     │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  1. RED: Write failing tests                                    │
│  2. GREEN: Write code to pass tests                             │
│  3. REFACTOR: Clean up code                                     │
│  4. REVIEW: Run /code-review  ← NEW STEP                        │
│  5. FIX: Address critical/high issues                           │
│  6. VALIDATE: Lint + TypeCheck + Coverage                       │
│  7. COMMIT: Only after review passes                            │
│                                                                 │
│  Review catches what tests miss:                                │
│  - Security vulnerabilities                                     │
│  - Performance issues                                           │
│  - Architecture problems                                        │
│  - Code maintainability                                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Review Response Template

When code review finds issues, respond with:

```markdown
## Code Review Results

### 🔴 Critical Issues (Must Fix)
1. **SQL Injection in userController.ts:45**
   - Issue: User input directly interpolated into query
   - Fix: Use parameterized query
   - Code: `db.query('SELECT * FROM users WHERE id = $1', [userId])`

### 🟠 High Issues (Should Fix)
1. **Missing authentication on /api/admin endpoints**
   - Issue: Admin routes accessible without auth
   - Fix: Add auth middleware

### 🟡 Medium Issues (Fix Soon)
1. **N+1 query in getOrders function**
   - Consider eager loading or batch query

### 🟢 Low Issues (Nice to Have)
1. **Consider extracting validation logic to separate file**

### ✅ Strengths
- Good test coverage
- Clear function names
- Proper error handling

### 📊 Summary
- Critical: 1 | High: 1 | Medium: 1 | Low: 1
- **Status: ❌ BLOCKED** - Fix critical/high issues before commit
```

---

## Claude Instructions

### When to Invoke Code Review

Claude should automatically suggest or run code review:

1. **After completing a feature** → "Let me run a code review before we commit"
2. **Before creating a PR** → "Running code review on all changes"
3. **When user says "commit"** → "First, let me review the changes"
4. **After fixing bugs** → "Reviewing the fix for any issues"

### Review Focus Areas

Prioritize review based on change type:

| Change Type | Focus Areas |
|-------------|-------------|
| Auth/Security code | Security, input validation, crypto |
| Database code | SQL injection, N+1, transactions |
| API endpoints | Auth, rate limiting, validation |
| Frontend code | XSS, state management, performance |
| Infrastructure | Secrets, permissions, logging |

---

## Quick Reference

### Commands

```bash
# Basic review
/code-review

# Review specific files
/code-review src/auth.ts src/users.ts

# Review with focus
/code-review --focus security

# Review PR
/code-review --pr 123
```

### Severity Actions

```
🔴 Critical → STOP. Fix now. No commit.
🟠 High     → STOP. Fix now. No commit.
🟡 Medium   → Note it. Fix soon. Can commit.
🟢 Low      → Optional. Nice to have.
ℹ️ Info     → FYI only.
```

### Workflow

```
Code → Test → Review → Fix → Commit → Push → PR → Review → Merge → Deploy
              ↑                              ↑                    ↑
           /code-review                /code-review          /code-review
```
