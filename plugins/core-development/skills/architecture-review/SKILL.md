---
name: Architecture Review
description: This skill should be used when the user asks to "review architecture", "assess design", "evaluate scalability", "check technical debt", "review system design", "analyze patterns", "assess microservices boundaries", "evaluate technology choices", or discusses architectural decisions. Provides systematic architecture review methodology and pattern analysis.
version: 1.1.0
disable-model-invocation: false
---

# Architecture Review

## When to Use

- Evaluating system designs or proposing architectural changes
- Assessing technology choices or migration strategies
- Reviewing microservices boundaries and integration patterns
- Identifying and prioritizing technical debt
- Writing or reviewing Architecture Decision Records (ADRs)

When NOT to use:
- Code-level review (style, naming, test coverage) — that's a code review, not architecture
- Simple implementation questions ("how do I use X library")
- Operational troubleshooting (debugging a specific failure)

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "All architectural decisions must have an ADR in docs/adrs/"
- "Services communicate via async events unless sub-200ms latency is required"
- "New services must pass the review checklist before production deployment"
- "We use the modular monolith pattern — extract to microservice only when proven necessary"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Review Methodology

### Phase 1: Context First

Before evaluating anything, answer:
1. What problem does this system solve and for whom?
2. What are the scale requirements (users, data volume, request rate)?
3. What constraints exist (team size, budget, timeline, existing tech)?
4. What is the expected evolution path over 6-12 months?

Skip this and the review will be shallow.

### Phase 2: Systematic Assessment

For each major component, evaluate:
1. Does the pattern fit the actual requirements (not hypothetical future ones)?
2. Are boundaries and data ownership clear?
3. What are the failure modes?
4. What operational burden does this add?

### Phase 3: Prioritized Output

Organize findings as:
- **Critical** — must fix before production (security holes, data loss risks, single points of failure)
- **Important** — should address within next cycle (scalability bottlenecks, missing observability)
- **Minor** — nice-to-have improvements
- **Strengths** — what to reinforce and not accidentally break

## Common Pitfalls

- **Reviewing against hypothetical scale**: Don't penalize a monolith serving 1K users for not being microservices-ready. Review against actual requirements and the 6-12 month horizon.
- **Confusing operational complexity with bad design**: Microservices trade development simplicity for deployment complexity. That's a deliberate trade-off, not a flaw — unless the team can't operate it.
- **Missing the distributed monolith**: Services that must deploy together, share a database, or make synchronous call chains are a distributed monolith — all the operational cost with none of the benefits.
- **Ignoring team context**: An elegant hexagonal architecture is wrong if the team has 3 months of experience. Architecture must match team capability.
- **Skipping failure mode analysis**: Every integration point is a failure point. Ask: "what happens when X is down?" for every external dependency.
- **ADRs that don't record alternatives**: The value of an ADR is capturing *why* you chose this approach over others. A decision without alternatives is just documentation.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Small team, unclear domain boundaries | Modular monolith — extract services later when boundaries prove stable |
| Components need independent scaling/deployment | Microservices, but only after confirming team can operate them |
| High-throughput async workflows | Event-driven architecture with idempotent consumers |
| Read and write patterns differ dramatically | CQRS — but only if the complexity is justified by measurable performance needs |
| Choosing between technologies | Weighted decision matrix; time-box PoC to 2-3 days testing the hardest integration point |
| Irreversible decision (DB schema, public API) | Full ADR with alternatives; get team consensus |
| Reversible decision (internal library, pattern) | Decide quickly, document lightly, iterate |
| Prioritizing technical debt | Impact/effort matrix: high-impact/low-effort first, deprioritize low-impact/high-effort |

## References

- **`references/review-checklist.md`** — Comprehensive checklist covering business alignment, quality attributes, operational readiness, and technology choices. Use as a systematic walkthrough for formal reviews.
