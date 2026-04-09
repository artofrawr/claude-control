# Core Development Plugin

Focused skills for modern React/TypeScript development. Provides library-specific patterns and best practices for common development tasks.

## Skills

| Skill | Description |
|-------|-------------|
| **accessibility** | Run comprehensive accessibility audits on web projects using axe-core and eslint-plugin-jsx-a11y |
| **agentic-development** | Build AI agents with Pydantic AI (Python) and Claude SDK (Node.js) |
| **architecture-review** | Systematic architecture review methodology and pattern analysis |
| **audit-website** | Audit websites for SEO, performance, security, and 15 other categories with 230+ rules using squirrelscan CLI |
| **aws-cdk** | AWS Cloud Development Kit (CDK) for building cloud infrastructure with TypeScript/Python |
| **base** | Universal coding patterns, constraints, TDD workflow, atomic todos |
| **better-auth** | Configure Better Auth server and client, set up database adapters, manage sessions, add plugins |
| **chakra-ui** | Accessible components, theming, and responsive design with @chakra-ui/react |
| **clickhouse** | ClickHouse schema, query, and configuration review with 28 production rules |
| **cloudflare-workers** | Review and author Cloudflare Workers code against production best practices |
| **code-deduplication** | Prevent semantic code duplication with capability index and check-before-write |
| **convex** | Real-time backend, serverless functions, document database with Convex |
| **credentials** | Centralized API key management from Access.txt |
| **d3js** | Creating interactive data visualizations using d3.js - custom charts, graphs, network diagrams, geographic visualizations |
| **database-schema** | Schema awareness - read before coding, type generation, prevent column errors |
| **dockerfile** | Create, generate, and write Dockerfiles and multi-stage Docker images |
| **firecrawl** | Web scraping, search, crawling, and page interaction via the Firecrawl CLI |
| **git-worktrees** | Create isolated git worktrees with smart directory selection and safety verification |
| **i18n** | Guides better-i18n integration decisions - SDK selection, CDN vs GitHub workflow, AI-powered translation management |
| **llm-patterns** | AI-first application patterns, LLM testing, prompt management |
| **mcp-builder** | Guide for creating high-quality MCP servers that enable LLMs to interact with external services |
| **ms-teams-apps** | Microsoft Teams bots and AI agents - Claude/OpenAI, Adaptive Cards, Graph API |
| **neon-postgres** | Guides and best practices for working with Neon Serverless Postgres |
| **nestjs** | Progressive Node.js framework with modules, guards, interceptors |
| **nextjs** | Next.js best practices - file conventions, RSC boundaries, data patterns, metadata, error handling |
| **nodejs-backend** | Node.js backend patterns with Express/Fastify, repositories |
| **nx-monorepo** | Workspace organization, library creation, build optimization with Nx |
| **postgres** | Execute read-only SQL queries against multiple PostgreSQL databases for exploration and analysis |
| **prisma** | Type-safe ORM for database schema, migrations, and data access |
| **project-tooling** | gh, vercel, supabase, render CLI and deployment platform setup |
| **pwa-development** | Progressive Web Apps - service workers, caching strategies, offline, Workbox |
| **python** | Python development with ruff, mypy, pytest - TDD and type safety |
| **react-hook-form** | Performant forms with validation, field arrays, and Zod integration |
| **react-native** | React Native mobile patterns, platform-specific code |
| **react-web** | React web development with hooks, React Query, Zustand |
| **reddit-api** | Reddit API with PRAW (Python) and Snoowrap (Node.js) |
| **remotion** | Best practices for Remotion - video creation in React |
| **sanity** | Sanity development best practices for schema design, GROQ queries, TypeGen, Visual Editing, and framework integrations |
| **security** | OWASP security patterns, secrets management, security testing |
| **sentry** | Error tracking, performance monitoring, and error boundaries |
| **shopify-apps** | Shopify app development - Remix, Admin API, checkout extensions |
| **subagent-development** | Use when executing implementation plans with independent tasks in the current session |
| **supabase** | Core Supabase CLI, migrations, RLS, Edge Functions |
| **supabase-nextjs** | Next.js with Supabase and Drizzle ORM |
| **supabase-node** | Express/Hono with Supabase and Drizzle ORM |
| **supabase-python** | FastAPI with Supabase and SQLAlchemy/SQLModel |
| **tanstack-query** | Server state management, caching, mutations with @tanstack/react-query |
| **tanstack-table** | Data tables with sorting, filtering, pagination, virtualization |
| **tinybird** | Tinybird file formats, SQL rules, optimization patterns for datasources, pipes, endpoints, and materialized views |
| **typescript** | TypeScript strict mode with eslint and jest |
| **typesense** | Typo-tolerant search engine, indexing, faceted navigation |
| **web-artifacts-builder** | Create elaborate, multi-component claude.ai HTML artifacts using React, Tailwind CSS, shadcn/ui |
| **web-asset-generator** | Generate web assets including favicons, app icons (PWA), and social media meta images |
| **web-payments** | Stripe Checkout, subscriptions, webhooks, customer portal |
| **zod** | Schema validation, type inference, data transformation with Zod |

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
