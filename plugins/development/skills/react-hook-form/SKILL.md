---
name: React Hook Form
description: This skill should be used when the user asks to "create a form", "add form validation", "implement field arrays", "use react-hook-form", "handle form submission", "integrate Zod with forms", "build dynamic forms", or works with complex form implementations requiring validation, field arrays, or performance optimization. Provides patterns for performant, validated forms with minimal re-renders.
version: 1.1.0
disable-model-invocation: false
---

# React Hook Form

## When to Use

- Forms with 3+ fields or non-trivial validation logic
- Dynamic or conditional fields that appear/disappear based on user input
- Multi-step wizards where state persists across steps
- Field arrays (add/remove/reorder rows dynamically)
- Any form integrated with Zod schema validation

When NOT to use:
- Single input (search bar, toggle) — `useState` is simpler and sufficient
- Forms fully managed by a UI library that has its own form state (e.g., Ant Design Form)
- Server-only form handling (Next.js Server Actions with no client-side validation)

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Always use zodResolver — never use register-level validation rules"
- "Wrap all forms in FormProvider so nested components use useFormContext"
- "Define Zod schemas in a shared schemas/ directory, co-located with the API types"
- "Use mode: 'onBlur' as default, mode: 'onChange' only for search/filter forms"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **`watch()` causes full re-renders**: Calling `watch()` with no arguments subscribes to ALL field changes. Use `watch('specificField')` or `useWatch({ name })` in a child component to isolate re-renders.
- **Mixing `register` validation with `zodResolver`**: Pick one approach. If you use `zodResolver`, don't also pass validation rules to `register()` — they'll conflict and produce confusing error behavior.
- **Field arrays: using array index as key**: Always use `field.id` from `useFieldArray` as the React key, never the index. Index-based keys cause inputs to retain stale values when items are reordered or removed.
- **Conditional fields leaking values**: When a field is hidden (conditional render), its value stays in form state. Use `unregister` in a `useEffect` cleanup when removing conditional fields, or the hidden field's value will be submitted.
- **`reset()` after async data load**: Don't set `defaultValues` and then try to override with `setValue` when data arrives. Use `reset(serverData)` instead — it properly updates both values and the dirty/touched tracking baseline.
- **`handleSubmit` swallows errors silently**: If your `onSubmit` throws, `handleSubmit` catches it and does nothing. Always add error handling inside `onSubmit` or use `onError` callback as the second argument.
- **`valueAsNumber` with empty inputs**: An empty number input returns `NaN`, not `undefined`. Your Zod schema will get `NaN` and fail with a confusing "expected number" error. Use `z.coerce.number()` or preprocess the value.
- **FormProvider performance**: Wrapping in `FormProvider` doesn't itself cause re-renders, but child components using `useFormContext` will re-render when form state changes. Keep heavy components outside the provider or memoize them.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Simple form, few fields | `useForm` with `register` directly — no need for `FormProvider` |
| Deeply nested form components | `FormProvider` + `useFormContext` in children |
| Need to react to a field value | `useWatch({ name })` in an isolated component (not `watch()` in parent) |
| Controlled component (DatePicker, Select) | `Controller` component or `useController` hook |
| Dynamic add/remove rows | `useFieldArray` — always key on `field.id` |
| Multi-step wizard | Single `useForm` in parent, `FormProvider` to steps, `trigger(stepFields)` on Next |
| Validate on blur, re-validate on change | `mode: 'onBlur'`, `reValidateMode: 'onChange'` |
| Server-returned validation errors | `setError('field', { type: 'server', message })` in submit handler |
| Form with expensive async validation | Debounce in `onBlur` handler, not in `register` validate function |
| Pre-populate from API data | `reset(apiData)` when data arrives, not `setValue` for each field |
