---
name: NestJS
description: This skill should be used when the user asks to "create a controller", "add a guard", "create a nestjs module", "implement dependency injection", "create a service", "add an interceptor", "build a nest microservice", "add middleware", "create a pipe", or works with NestJS backend architecture requiring modules, providers, guards, or microservices patterns.
version: 1.1.0
disable-model-invocation: false
---

# NestJS

## When to Use

- Structuring backend features into modules with clear boundaries
- Implementing cross-cutting concerns (auth, logging, validation, error handling)
- Designing provider patterns (DI scope, dynamic modules, factory providers)
- Building microservices or hybrid HTTP + message-based applications

When NOT to use:
- Simple scripts or CLI tools — NestJS module overhead is not worth it
- Serverless functions with cold-start constraints — consider lightweight alternatives
- Frontend code — this is backend-only architecture

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "One module per domain feature (users, orders, payments), never cross-import services directly"
- "Always use async ConfigModule.forRootAsync() for external config, never hardcode"
- "Global exception filter on AppModule, feature-specific filters only when response shape differs"
- "Use repository pattern: controller -> service -> repository, never inject PrismaService into controllers"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Circular dependencies**: `forwardRef()` is a band-aid, not a fix. If two modules need each other, extract the shared logic into a third module. Circular deps silently cause `undefined` injections at runtime.
- **Request-scoped providers cascade**: Marking one provider as `Scope.REQUEST` makes every provider that depends on it request-scoped too. This kills performance for providers that don't actually need per-request state.
- **Guard execution order**: Guards run in the order they're listed in `@UseGuards()`, but global guards run before controller-level guards. If your auth guard depends on data set by another guard, ordering matters.
- **`exports` vs `providers`**: Declaring a service in `providers` makes it available within the module. You must also add it to `exports` for other modules to inject it. Forgetting `exports` causes "Nest can't resolve dependencies" errors.
- **ValidationPipe with `transform: true`**: Enables implicit type conversion, which silently coerces `"123"` to `123`. This is convenient but can mask bugs. Pair with `whitelist: true` and `forbidNonWhitelisted: true` to catch unexpected properties.
- **Interceptor vs Middleware**: Middleware runs before the route handler is resolved (no access to handler metadata). Interceptors wrap the handler and can transform responses. Use middleware for request-level concerns (logging, CORS), interceptors for response transformation.
- **Testing module setup**: `Test.createTestingModule` doesn't auto-register global pipes/guards/filters. Your unit tests will pass without validation that would reject the request in production. Either add them in the test module or test E2E separately.
- **Microservice error handling**: HTTP exception classes (`NotFoundException`, etc.) don't serialize properly over TCP/Redis transports. Use `RpcException` instead, or errors will arrive as generic "Internal server error" on the client side.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Sharing a service across modules | Export from source module, import module (not service) in consumer |
| Config that varies by environment | `ConfigModule.forRootAsync()` with factory, never `forRoot()` with hardcoded values |
| Per-request data (user, tenant) | Request-scoped provider or `cls-hooked` context — avoid cascading scope if possible |
| Auth + role check | Two separate guards (`AuthGuard` then `RolesGuard`), not one combined guard |
| Background job processing | Bull queue with `@nestjs/bull`, not in-process `setTimeout` |
| Feature needs lazy loading | `LazyModuleLoader` — but only for rarely-used heavy modules |
| Testing a service in isolation | Mock all injected dependencies via `useValue` in test module |
| Testing full request lifecycle | E2E test with `supertest` — includes pipes, guards, interceptors |
