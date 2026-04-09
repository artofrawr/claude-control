# Core Development Plugin

Focused skills for modern React/TypeScript development. Provides library-specific patterns and best practices for common development tasks.

## Skills

### Library-Specific Skills

| Skill | Triggers | Purpose |
|-------|----------|---------|
| **tanstack-table** | "create data table", "add sorting", "filter table", "@tanstack/react-table" | Data tables with sorting, filtering, pagination, virtualization |
| **react-hook-form** | "create form", "form validation", "field arrays", "react-hook-form" | Performant forms with validation and field arrays |
| **zod** | "create schema", "validate with zod", "z.infer", "parse data" | Schema validation, type inference, data transformation |
| **tanstack-query** | "fetch data", "cache data", "optimistic updates", "@tanstack/react-query" | Server state management, caching, mutations |
| **chakra-ui** | "create chakra component", "chakra theme", "add dark mode", "@chakra-ui/react" | Accessible components, theming, responsive design |
| **convex** | "create convex function", "convex query", "convex mutation", "convex schema" | Real-time backend, serverless functions, document database |
| **nestjs** | "create a controller", "add a guard", "create a nestjs module", "build a nest microservice" | Progressive Node.js framework with modules, guards, interceptors |
| **nx-monorepo** | "create a library", "run nx affected", "manage a monorepo", "configure nx caching" | Workspace organization, library creation, build optimization |
| **prisma** | "create a prisma schema", "run migrations", "write prisma queries", "handle transactions" | Type-safe ORM for database schema, migrations, data access |
| **typesense** | "create a typesense collection", "build a search index", "implement faceted search" | Typo-tolerant search engine, indexing, faceted navigation |
| **architecture-review** | "review architecture", "design patterns", "technical review" | Architecture assessment and pattern recommendations |
| **sentry** | "add error tracking", "sentry setup", "capture exception", "performance monitoring" | Error tracking, performance monitoring, error boundaries |

### How Skills Work

Skills use **progressive disclosure** for context efficiency:

1. **Metadata** (~100 words) - Always loaded, contains trigger phrases
2. **SKILL.md** (~1,800 words) - Loads when skill triggers, contains core patterns
3. **references/** - Loads on-demand, contains deep-dive content

This means you only pay the context cost for what you actually need.

## Commands

| Command | Usage | Purpose |
|---------|-------|---------|
| `/coordinate` | `/coordinate [task]` | Coordinate tasks using multiple skills |
| `/plan` | `/plan [feature]` | Create implementation plan using skills |
| `/plan-execution` | `/plan-execution [plan]` | Execute a plan with skill-guided incremental steps |
| `/debug` | `/debug [issue]` | Systematic debugging using relevant skills |
| `/review` | `/review [files]` | Code review using skill-based perspectives |
| `/test` | `/test` | Analyze changes and suggest appropriate testing strategies |
| `/scaffold` | `/scaffold [type]` | Generate boilerplate using skill patterns |

### When to Use Which Command

- **`/plan`** - Starting a new feature, need to think before coding
- **`/coordinate`** - Mid-implementation, combining multiple library patterns
- **`/plan-execution`** - Have a detailed plan, want managed multi-step execution
- **`/debug`** - Something is broken, need systematic investigation
- **`/review`** - Code is written, need quality assessment
- **`/test`** - Changes are ready, need to determine what testing is appropriate
- **`/scaffold`** - Starting a common pattern, want consistent boilerplate

## Usage Examples

### Building a Data Table with Server Data

```
I need to build a users table with sorting, filtering, and pagination that fetches from our API
```

Skills loaded: `tanstack-table` + `tanstack-query`

### Creating a Form with Validation

```
Create a signup form with email, password confirmation, and async username validation
```

Skills loaded: `react-hook-form` + `zod`

### API Response Validation

```
Add type-safe validation to our /api/users endpoint response
```

Skills loaded: `zod` + `tanstack-query`

### Architecture Decision

```
/review src/features/auth - check if the auth flow follows best practices
```

Skills loaded: `architecture-review`

### Building a Dashboard with Real-Time Data

```
I need a dashboard with Chakra UI that shows live user activity from Convex
```

Skills loaded: `chakra-ui` + `convex`

### Creating a Themed Component Library

```
Set up a custom Chakra theme with dark mode and brand colors
```

Skills loaded: `chakra-ui`

### NestJS API with Prisma

```
Create a REST API endpoint with NestJS that queries users from Prisma with pagination
```

Skills loaded: `nestjs` + `prisma`

### Search with Sync Pipeline

```
Set up a Typesense search index that syncs from our Prisma database
```

Skills loaded: `typesense` + `prisma`

### Monorepo Library Setup

```
Create a shared UI library in our Nx workspace with Chakra components
```

Skills loaded: `nx-monorepo` + `chakra-ui`

## Skill Reference Files

Each skill includes reference files for advanced patterns:

### tanstack-table
- `references/column-definitions.md` - Column config, custom cells, grouping, pinning
- `references/sorting-filtering.md` - Sort functions, faceted filters, fuzzy search
- `references/pagination-virtualization.md` - Server pagination, infinite scroll, virtualization

### react-hook-form
- `references/form-patterns.md` - Multi-step forms, dependent fields, persistence
- `references/validation-integration.md` - Zod integration, async validation, i18n
- `references/field-arrays.md` - Dynamic forms, nested arrays, drag-and-drop

### zod
- `references/schema-patterns.md` - Recursive schemas, branded types, composition
- `references/transformations.md` - Preprocess, transform, pipelines, coercion
- `references/error-handling.md` - Custom messages, i18n, form integration

### tanstack-query
- `references/query-patterns.md` - Key factories, dependent queries, suspense
- `references/mutations-optimistic.md` - Optimistic updates, rollback, form integration
- `references/caching-strategies.md` - Stale time, prefetching, persistence

### chakra-ui
- `references/component-patterns.md` - Layout, forms, modals, drawers, feedback components
- `references/theming-styling.md` - Custom themes, design tokens, color mode, global styles
- `references/responsive-design.md` - Breakpoints, responsive arrays, show/hide, mobile-first

### convex
- `references/schema-queries.md` - Schema patterns, indexes, pagination, relationships
- `references/mutations-actions.md` - Mutations, actions, scheduled functions, file storage
- `references/auth-patterns.md` - Authentication setup, protected functions, RBAC

### nestjs
- `references/module-patterns.md` - Dynamic modules, circular dependency resolution, custom providers
- `references/microservices.md` - Transport layers, message patterns, hybrid applications
- `references/testing.md` - Unit testing modules, e2e testing, mocking providers

### nx-monorepo
- `references/library-patterns.md` - Library types, shared code, publishable libraries
- `references/generators.md` - Custom generators, workspace generators, plugin development
- `references/build-optimization.md` - Caching, affected commands, distributed execution

### prisma
- `references/query-patterns.md` - Advanced queries, raw SQL, computed fields
- `references/migrations.md` - Migration workflows, seeding, production strategies
- `references/transactions.md` - Interactive transactions, nested writes, optimistic concurrency

### typesense
- `references/search-patterns.md` - Multi-search, synonyms, curations, geo-search, vector search
- `references/sync-strategies.md` - PostgreSQL sync, incremental updates, real-time indexing
- `references/faceted-search.md` - Faceted filtering, geo-search, multi-search patterns

### architecture-review
- `references/review-checklist.md` - Comprehensive checklist for thorough architecture reviews
- `references/pattern-catalog.md` - Detailed patterns with when to use and trade-offs
- `references/decision-frameworks.md` - ADR templates, trade-off analysis, decision matrices

### sentry
- `references/error-tracking.md` - Error capture, breadcrumbs, context enrichment
- `references/performance-monitoring.md` - Transactions, spans, web vitals
- `references/integration-patterns.md` - React error boundaries, NestJS integration, Convex action monitoring

## Combining with Other Plugins

This plugin works well with:

- **plugin-dev** - For creating new skills
- **playwright-testing** - For visual regression and e2e testing during development
- **playwright-synthetic** - For persona-based UX testing to discover friction points
- **specialized-domains** - Has a `convex-specialist` agent for deep Convex work; core-development's `convex` skill provides patterns/reference while the specialist agent handles complex debugging and architecture

### Combination Patterns

| Workflow | Plugins | Example |
|----------|---------|---------|
| Design-to-code | frontend-designer + core-development | Design with ui-designer, implement with chakra-ui + react-hook-form |
| Visual regression | core-development + playwright-testing | Build feature with /plan, verify with /visual-test |
| E2E testing | core-development + playwright-testing | Build feature with /plan, verify with /run-scenario |
| UX testing | core-development + playwright-synthetic | Build feature with /plan, test usability with /simulate-user |
| Deep Convex work | core-development + specialized-domains | Patterns from convex skill + convex-specialist agent |

## Adding New Skills

To add a new library skill:

1. Create `skills/[library-name]/SKILL.md` with:
   - YAML frontmatter with trigger phrases
   - Core patterns (~1,500-2,000 words)
   - Code examples

2. Add `references/` for advanced content:
   - Deep-dive patterns
   - Edge cases
   - Advanced configurations

See existing skills for the pattern to follow.
