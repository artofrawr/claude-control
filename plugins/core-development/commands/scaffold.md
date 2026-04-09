---
description: Generate boilerplate using skill patterns
name: scaffold
---

You are generating project boilerplate using patterns from the plugin's skills. This ensures consistent, best-practice code across the project.

## Available Scaffolds

### `scaffold form` - Form with Validation

Uses: **react-hook-form** + **zod** + **chakra-ui** skills

Generates:
- Zod validation schema
- React Hook Form setup with `zodResolver`
- Chakra UI form layout with error display
- Submit handler with loading state

```
/scaffold form [entity-name]
Example: /scaffold form user-profile
```

### `scaffold table` - Data Table with Server Data

Uses: **tanstack-table** + **tanstack-query** + **chakra-ui** skills

Generates:
- Column definitions with type safety
- TanStack Query hook for data fetching
- Table component with sorting, filtering, pagination
- Chakra UI table layout

```
/scaffold table [entity-name]
Example: /scaffold table orders
```

### `scaffold convex-feature` - Full Convex Feature

Uses: **convex** + **zod** + **chakra-ui** skills

Generates:
- Convex schema table definition
- Query function with index
- Mutation function (create + update)
- React component with `useQuery` and `useMutation`

```
/scaffold convex-feature [feature-name]
Example: /scaffold convex-feature tasks
```

### `scaffold api-endpoint` - NestJS REST Endpoint

Uses: **nestjs** + **zod** + **prisma** skills

Generates:
- NestJS controller with CRUD methods
- Service with Prisma queries
- Zod DTOs for request validation
- Response type definitions

```
/scaffold api-endpoint [resource-name]
Example: /scaffold api-endpoint users
```

### `scaffold search` - Typesense Search Feature

Uses: **typesense** + **tanstack-query** + **chakra-ui** skills

Generates:
- Typesense collection schema
- Search query hook with TanStack Query
- Search component with faceted filters
- Sync function for indexing

```
/scaffold search [collection-name]
Example: /scaffold search products
```

## Scaffold Process

1. **Parse the request** - Identify scaffold type and entity name
2. **Check existing code** - Look for existing patterns, naming conventions, directory structure
3. **Load relevant skills** - Get best-practice patterns for the scaffold type
4. **Generate code** - Create files following project conventions
5. **Adapt to project** - Match existing code style, imports, and patterns

## Important

- Always check for existing similar code in the project first
- Match the project's naming conventions (camelCase, kebab-case, etc.)
- Use existing shared components and utilities where available
- Add Sentry error boundaries for new page-level components
- Follow the project's directory structure
