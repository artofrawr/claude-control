---
name: Chakra UI
description: This skill should be used when the user asks to "create chakra component", "add dark mode", "style with chakra", "chakra theme", "use chakra ui", "responsive layout with chakra", or works with @chakra-ui/react for building accessible, themeable React interfaces. Provides patterns for components, theming, and responsive design.
version: 1.1.0
disable-model-invocation: false
---

# Chakra UI

## When to Use

- Building UI components that need dark mode, theming, or design token consistency
- Creating responsive layouts with mobile-first breakpoints
- Wrapping form controls with accessible labels, errors, and helper text
- Building compound components (Dialog, Drawer, Alert) with consistent patterns

When NOT to use:
- Highly custom animations or interactions — use Framer Motion or CSS directly
- One-off styled elements where a plain `<div>` with Tailwind/CSS would be simpler
- Performance-critical lists with thousands of items — style props add overhead per element

## Our Conventions

<!-- Add project-specific patterns here as you establish them -->
<!-- Examples of what belongs here:
- "Always use semantic tokens (bg.default, text.muted) instead of raw color values"
- "Use Dialog for confirmations, Drawer for mobile navigation only"
- "All pages wrap content in Container maxW='container.xl'"
- "Use VStack/HStack for layout, not raw Flex unless you need wrap or custom alignment"
-->

- _No project-specific conventions established yet. Add patterns here as the team adopts them._
- Project-specific CLAUDE.md or README conventions take priority over these defaults.

## Common Pitfalls

- **Chakra v3 API changes**: `createSystem`/`defineConfig` replaced `extendTheme`. `Dialog` replaced `Modal`. `Field.Root` replaced `FormControl`. Don't use v2 patterns.
- **`_dark` prop vs `useColorModeValue`**: Prefer `_dark` on the element for co-located styles. Use `useColorModeValue` only when you need the value in JS logic (e.g., passing to a non-Chakra component).
- **Semantic tokens vs raw colors**: `bg="gray.800"` breaks in light mode. Use semantic tokens (`bg="bg.default"`) or pair with `_dark` to handle both modes.
- **`spacing` vs `gap`**: Stack components use `gap` (not `spacing`) in v3. Using `spacing` silently does nothing.
- **`Show`/`Hide` vs `display` prop**: `Show`/`Hide` unmount children (triggers re-renders). `display={{ base: 'none', md: 'block' }}` just hides visually — better for content that's expensive to re-mount.
- **Recipe vs inline styles**: For components reused 3+ times with variants, define a recipe (`defineRecipe`). Don't scatter identical style props across files.
- **Missing `ColorModeProvider`**: Color mode hooks fail silently if `ColorModeProvider` isn't in the tree. Wrap it inside `ChakraProvider`.
- **SSR flash**: Without `ColorModeScript` in the document head, SSR apps flash the wrong theme on load.

## Decision Guide

| Situation | Approach |
|-----------|----------|
| Same style pattern used 3+ times | Define a recipe with `defineRecipe` |
| Responsive show/hide for cheap content | `display` prop with breakpoint object |
| Responsive show/hide for expensive content | `Show`/`Hide` components (unmounts children) |
| Dark mode for co-located styles | `_dark` pseudo prop on the element |
| Dark mode value needed in JS | `useColorModeValue` hook |
| Form field with label + error | `Field.Root` > `Field.Label` + `Input` + `Field.ErrorText` |
| Confirmation dialog | `Dialog.Root` with `Dialog.Backdrop` + `Dialog.Positioner` |
| Mobile navigation panel | `Drawer.Root` with placement="start" |
| Dynamic value based on breakpoint | `useBreakpointValue` hook (has SSR fallback option) |
| Custom color palette for the app | Define tokens in `defineConfig` > `theme.tokens.colors` |
