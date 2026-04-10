# development

Technology skill library and development workflows: focused skills for NestJS, Prisma, Zod, Chakra UI, Sentry, TanStack, Typesense, and more.

**Version:** 2.0.0

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
| **cloudflare-workers** | Review and author Cloudflare Workers code against production best practices |
| **code-deduplication** | Prevent semantic code duplication with capability index and check-before-write |
| **credentials** | Centralized API key management from Access.txt |
| **d3js** | Creating interactive data visualizations using d3.js - custom charts, graphs, network diagrams, geographic visualizations |
| **database-schema** | Schema awareness - read before coding, type generation, prevent column errors |
| **dockerfile** | Create, generate, and write Dockerfiles and multi-stage Docker images |
| **git-worktrees** | Create isolated git worktrees with smart directory selection and safety verification |
| **i18n** | Guides better-i18n integration decisions - SDK selection, CDN vs GitHub workflow, AI-powered translation management |
| **llm-patterns** | AI-first application patterns, LLM testing, prompt management |
| **mcp-builder** | Guide for creating high-quality MCP servers that enable LLMs to interact with external services |
| **nestjs** | Progressive Node.js framework with modules, guards, interceptors |
| **nextjs** | Next.js best practices - file conventions, RSC boundaries, data patterns, metadata, error handling |
| **nodejs-backend** | Node.js backend patterns with Express/Fastify, repositories |
| **nx-monorepo** | Workspace organization, library creation, build optimization with Nx |
| **postgres** | Execute read-only SQL queries against multiple PostgreSQL databases for exploration and analysis |
| **prisma** | Type-safe ORM for database schema, migrations, and data access |
| **project-tooling** | gh, vercel, supabase, render CLI and deployment platform setup |
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
| **stripe** | Stripe Checkout, subscriptions, webhooks, customer portal |
| **subagent-development** | Use when executing implementation plans with independent tasks in the current session |
| **supabase** | Core Supabase CLI, migrations, RLS, Edge Functions |
| **supabase-nextjs** | Next.js with Supabase and Drizzle ORM |
| **supabase-node** | Express/Hono with Supabase and Drizzle ORM |
| **supabase-python** | FastAPI with Supabase and SQLAlchemy/SQLModel |
| **tanstack-query** | Server state management, caching, mutations with @tanstack/react-query |
| **tanstack-table** | Data tables with sorting, filtering, pagination, virtualization |
| **typescript** | TypeScript strict mode with eslint and jest |
| **typesense** | Typo-tolerant search engine, indexing, faceted navigation |
| **web-asset-generator** | Generate web assets including favicons, app icons (PWA), and social media meta images |
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

Some skills include reference files for advanced patterns:

### architecture-review
- `references/review-checklist.md` - Comprehensive checklist for thorough architecture reviews

### prisma
- `references/migrations.md` - Migration workflows, seeding, production strategies

## Combining with Other Plugins

This plugin works well with:

- **meta-tooling** - For creating new skills
- **testing** - For E2E testing with Playwright and visual regression testing
- **design** - For UI/UX patterns when implementing frontend features

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
