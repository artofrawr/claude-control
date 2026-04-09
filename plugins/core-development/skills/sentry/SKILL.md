---
name: Sentry
description: This skill should be used when the user asks to "add error tracking", "sentry setup", "capture exception", "add breadcrumbs", "performance monitoring", "error boundary with sentry", "track errors", "add observability", or works with Sentry for error tracking, performance monitoring, and application observability in React and NestJS applications.
version: 1.1.0
disable-model-invocation: false
---

# Sentry

## When to Use

- Adding error tracking or performance monitoring to React or NestJS
- Wrapping components or routes with error boundaries
- Enriching error reports with user context, tags, or breadcrumbs
- Configuring sampling rates, filtering, or source maps

When NOT to use:
- Structured logging (use a logger like Pino/Winston — Sentry is for exceptions, not log aggregation)
- Business analytics or user behavior tracking — use a product analytics tool
- Health check endpoints or expected 4xx responses — these are not errors

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Initialize Sentry in src/sentry.ts, imported before React renders in main.tsx"
- "Only report 5xx errors from NestJS — 4xx are expected and filtered"
- "All mutations wrap errors with tags: { source: 'mutation', feature: '<name>' }"
- "Use withScope for payment/checkout flows to isolate fingerprints"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Init timing**: `Sentry.init()` must run before any React rendering or NestJS bootstrapping. If it runs late, early errors are lost silently.
- **Sampling rate confusion**: `tracesSampleRate` controls performance transactions, not error events. Errors are always captured (unless filtered by `beforeSend`). Setting `tracesSampleRate: 0.2` does not mean you lose 80% of errors.
- **`SentryModule.forRoot()` must be first import**: In NestJS, it must be the first entry in the `imports` array or instrumentation misses early modules.
- **4xx errors flooding Sentry**: The NestJS `SentryGlobalFilter` reports all unhandled exceptions including 4xx. Filter by status code in a custom filter or `beforeSend` to avoid noise.
- **`ignoreErrors` is regex-matched against message only**: It won't filter by error class or stack trace. Use `beforeSend` for complex filtering logic.
- **Breadcrumb overload**: Sentry auto-captures console logs, DOM clicks, and fetch calls. In noisy apps this buries useful breadcrumbs. Use `beforeBreadcrumb` to filter debug-level console breadcrumbs.
- **Source maps in production**: Without `sentryVitePlugin` (or equivalent) and `sourcemap: true` in the build config, stack traces show minified code. Also use `filesToDeleteAfterUpload` to avoid shipping `.map` files to users.
- **Replay privacy**: `replayIntegration()` defaults may capture sensitive text. Use `maskAllText: true` and `blockAllMedia: true` until you've audited what's safe to record.
- **Scope leaking**: `setTag`/`setUser` modify the global scope. Use `withScope` to isolate context for specific operations (e.g., payment flows) so tags don't leak to unrelated errors.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Report an error with isolated context | `Sentry.withScope` + `captureException` |
| Group related errors together | Custom fingerprint via `scope.setFingerprint` |
| Track multi-step operation timing | `Sentry.startSpan` with nested child spans |
| Filter noisy/expected errors | `beforeSend` returning `null` for known patterns |
| Reduce performance data volume | `tracesSampler` function with per-route rates |
| Always trace critical paths (checkout, payment) | Return `1.0` from `tracesSampler` for those routes |
| Drop health check transactions | Return `0.01` from `tracesSampler` for `/health` |
| Track errors per feature area | Add `tags: { feature: 'checkout' }` to `captureException` |
| React component crash isolation | Wrap sections in `Sentry.ErrorBoundary` with feature-specific fallbacks |
| NestJS error reporting | Custom exception filter that only reports `status >= 500` |
