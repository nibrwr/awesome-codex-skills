---
name: apple-platform-design
description: Use when designing or implementing UI or app code for macOS, iOS, iPadOS, or shared SwiftUI code that should feel consistent across Apple platforms while respecting platform-specific interaction patterns, layout density, navigation, accessibility, OS availability, system materials, semantic colors, and Apple platform guidelines.
---

# Apple Platform Design

Use this skill when the user wants design or UI implementation guidance that stays aligned across macOS, iOS, and iPadOS projects.

## Goals

- Preserve one product identity across Apple platforms.
- Share design tokens, information architecture, and component naming where possible.
- Avoid fake parity that makes the Mac app feel like an iPad app or the iPhone app feel like a desktop app.

## Default Stance

Start from a shared design system, then adapt the interaction model per platform.

Keep these layers separate:

1. Shared brand layer
2. Shared design-token layer
3. Shared component semantics
4. Platform-specific layout and interaction layer

## Shared Rules

Unless the user says otherwise, keep the following aligned across projects:

- Color roles and semantic color naming
- Type scale relationships
- Spacing scale
- Corner radius scale
- Elevation or material rules
- Icon style and symbol usage
- Empty, loading, error, and success states
- Naming of shared components and screens
- Content hierarchy and feature priority

Prefer semantic tokens over hard-coded values. If code is involved, centralize tokens in one place and reference them from both platform targets.

## Platform Compatibility Requirement

When building macOS, iOS, or iPadOS apps, maintain compatibility with the current major OS release and one major previous OS release.

For the visual system:

- Start with system materials and semantic colors.
- Use platform-provided colors, materials, typography, layout behavior, and accessibility defaults before custom styling.
- Gate newer glass APIs and other current-OS-only visual APIs behind explicit availability checks.
- Provide a visually coherent fallback for the previous major OS release.
- Avoid making the core visual system depend on APIs unavailable to the supported OS baseline.

For Swift and SwiftUI code:

- Use `#available`, `@available`, or platform-specific availability checks when calling newer APIs.
- Keep fallback paths close to the feature they support so behavior is reviewable.
- Verify that shared code compiles and behaves correctly for macOS, iOS, and iPadOS targets that the project supports.

## Platform Compliance and Efficiency

The codebase should remain compliant and efficient with macOS, iOS, and iPadOS guidelines respectively.

Apply platform guidance to:

- Navigation, windowing, sidebar, toolbar, menu, tab, sheet, inspector, and popover behavior
- Keyboard, pointer, touch, drag-and-drop, focus, and accessibility interactions
- Layout density, hit targets, safe areas, resizable windows, multitasking, and dynamic type
- Performance, memory use, power impact, animation cost, and rendering efficiency
- Privacy, permissions, storage, networking, signing, and entitlement behavior

When a shared implementation conflicts with platform guidelines, split the platform-specific layer rather than weakening the native experience.

## Accessibility Requirement

Accessibility must be integrated during app development, not deferred to a final pass.

While building views, controls, navigation, and interactions:

- Add current accessibility traits, labels, values, hints, actions, and identifiers as needed for the platform and control.
- Preserve correct VoiceOver, Voice Control, Switch Control, Full Keyboard Access, focus, pointer, touch, and keyboard behavior.
- Support Dynamic Type, text scaling, contrast modes, Reduce Motion, Reduce Transparency, differentiating without color, and other relevant system accessibility settings.
- Keep reading order, focus order, hit targets, gesture alternatives, and semantic grouping coherent as UI is implemented.
- Use native controls and system semantics when they provide better accessibility than custom views.
- Gate newer accessibility APIs behind availability checks when they are not available on the supported OS baseline.

When custom controls, gestures, drawing, canvas, charts, maps, or visualization products are introduced, define the accessible representation at the same time as the visual implementation.

## Accessibility Review Gate

Every Codex app creation or review workflow for macOS, iOS, iPadOS, watchOS, tvOS, visionOS, or shared Apple-platform SwiftUI must include an explicit accessibility review before final handoff. This applies even when the user does not ask for accessibility by name.

For implementation work, verify and report on:

- Semantic structure: headings, landmarks/regions, grouped controls, labels, values, hints, selected states, disabled states, and error/status announcements.
- Interaction coverage: VoiceOver, Voice Control names, Full Keyboard Access, Switch Control-compatible actions, pointer hover/help, focus order, keyboard shortcuts, and non-pointer alternatives.
- Visual accessibility: contrast, text scaling, truncation, hit target size, Reduce Motion, Reduce Transparency, Differentiate Without Color, light/dark mode, and high-contrast appearances.
- State changes: loading, progress, success, failure, empty states, validation, sheets, popovers, and generated output must be perceivable without relying on color, motion, or visual placement alone.
- Custom UI: any custom buttons, cards-as-controls, Canvas/Shape drawing, gestures, charts, maps, previews, or generated imagery need explicit accessibility representation or must be hidden when decorative.

For review-only work, include a dedicated Accessibility Recommendations section with prioritized findings, file references when code is available, and concrete verification steps. If the surface cannot be tested with assistive technologies in the current environment, state that limitation and still review semantics, focus, keyboard access, contrast risk, and dynamic type/layout behavior from code.

## Documentation Requirement

Treat visualization artifacts as a standard project documentation deliverable for development work.

Unless the user says otherwise, produce or maintain visuals such as:

- Ladder diagrams
- Maps and flows
- Navigation or screen maps
- State or lifecycle diagrams
- System interaction diagrams

Use diagrams when they reduce ambiguity around architecture, user flow, platform divergence, or component relationships. Prefer concise visuals over long prose when a picture makes the decision easier to review.

## Platform Adaptation Rules

Do not force identical layouts.

For iOS:

- Optimize for focused, linear flows
- Prefer tab-based or stack-based navigation where appropriate
- Use larger touch targets and clearer primary actions
- Assume compact width first unless context says otherwise

For iPadOS:

- Support adaptive layouts across compact, regular, Split View, Stage Manager, and external display contexts when relevant
- Prefer multi-column navigation, sidebars, inspectors, drag-and-drop, keyboard shortcuts, and pointer affordances when they improve productivity
- Preserve touch-first ergonomics even when adding desktop-like capabilities

For macOS:

- Optimize for information density, scanning, and multi-pane workflows
- Prefer sidebars, split views, toolbars, menus, keyboard shortcuts, and inspectors when they improve throughput
- Use hover, right-click, drag-and-drop, and window-level affordances where appropriate
- Allow more simultaneous context on screen

## SwiftUI Guidance

When implementing shared SwiftUI across Apple platforms:

- Share tokens, models, and component intent first
- Split platform-specific presentation when interaction or density diverges
- Use conditional compilation sparingly and only where platform behavior actually differs
- Prefer small wrapper layers over one oversized cross-platform view full of `#if os(...)`
- Gate current-OS-only APIs behind availability checks and keep previous-major-OS fallbacks intact
- Apply accessibility modifiers and traits as part of each component's implementation, especially for custom controls and composed views

## Decision Framework

When proposing or implementing a design, explicitly decide:

1. What must be identical across platforms
2. What should be equivalent but not identical
3. What should be platform-native and intentionally different

If the user request is ambiguous, preserve brand consistency but favor native platform behavior.

## Output Expectations

For substantial design or UI tasks, provide:

- Shared design principles
- Platform-specific differences that matter
- The token or component structure needed to keep both apps aligned
- OS availability decisions and fallback behavior when newer APIs are used
- Visualization artifacts when they clarify structure, flow, or behavior
- Platform guideline, accessibility, and efficiency concerns that affect the implementation
- Accessibility traits, labels, focus behavior, scaling, contrast, motion, and assistive-technology behavior that changed or need validation
- Any places where forcing parity would hurt usability

If writing code, call out where the shared design system lives and where platform-specific behavior begins.
