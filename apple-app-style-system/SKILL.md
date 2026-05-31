---
name: apple-app-style-system
description: Use when creating, scaffolding, styling, or reviewing new iOS, iPadOS, macOS, or shared SwiftUI apps for this user. Applies the user's default Apple app design standard, visual aesthetic, reusable SwiftUI tokens/components, platform-native shell patterns, accessibility requirements, and project-setup expectations.
---

# Apple App Style System

Use this skill whenever the user starts or restyles an iOS, iPadOS, macOS, or shared SwiftUI app.

## Default Aesthetic

Build native Apple utility apps with a calm, professional, workflow-first feel.

- Prefer semantic system colors, system materials, and native control behavior.
- Use `Color.accentColor` as the default primary action color unless the app has a clear brand reason for a custom accent.
- Keep layouts dense enough for productivity, but not visually cramped.
- Use cards/panels only for real grouped content, repeated items, modals, and framed tools.
- Avoid one-off gradients, large decorative backgrounds, oversized rounded cards, and custom chrome unless the product domain needs it.
- Status must use icon + text + color, never color alone.

## Required Layers

Start every non-trivial app with these layers:

1. Shared tokens: colors, typography roles, spacing, radii, materials, status tones, motion.
2. Shared components: panel, section header, status badge, empty state, loading state, error state, primary/secondary/destructive buttons.
3. Platform shell: native navigation, toolbar, settings, menus, keyboard shortcuts, sheets, inspectors, or tabs as appropriate.
4. Feature views: small views named for their responsibility.

Bundled starter files live in `assets/AppleAppFoundation/`. Copy the relevant files into the new app's `Support/` or `UI/` folder before building feature screens.

## Token Rules

Use semantic names instead of hard-coded styling in feature views.

- Radius: `8` compact controls, `12` standard panels, `16` prominent panels. Avoid larger radii unless a media/editor surface needs them.
- Spacing: `4`, `8`, `12`, `16`, `20`, `24`.
- Surfaces: default to `.background`, `.regularMaterial`, `.thinMaterial`, and platform system grouped/control backgrounds.
- Borders: use separator colors with contrast-aware opacity.
- Shadows: subtle only; no heavy floating UI for normal utility panels.
- Typography: system fonts; title/headline/body/caption roles; monospaced digits only for values, counters, logs, and telemetry.

## Platform Rules

Do not force identical layouts across platforms.

macOS:
- Prefer `NavigationSplitView` for sidebar-detail apps.
- Keep sidebars native: source-list rows, one leading symbol, one title, optional short detail.
- Use toolbar actions, commands, keyboard shortcuts, settings scenes, inspectors, popovers, context menus, pointer affordances, and resizable windows.
- Let the sidebar and window use native backgrounds unless the user explicitly requests a branded custom shell.

iOS:
- Prefer focused `NavigationStack` or `TabView` flows.
- Use touch-sized targets, clear primary actions, readable section rhythm, and bottom-safe-area-aware controls.
- Avoid desktop-density sidebars on compact width.

iPadOS:
- Adapt from iOS compact flows to split layouts, inspectors, drag and drop, keyboard shortcuts, and pointer support when they improve productivity.

## Accessibility Gate

Accessibility is part of implementation, not a final pass.

For every new screen or component:
- Add labels, values, hints, traits, and identifiers where native semantics are insufficient.
- Support Dynamic Type, high contrast, Reduce Motion, Reduce Transparency, light/dark mode, and text truncation.
- Keep hit targets practical for touch and pointer.
- Ensure loading, empty, success, warning, and error states are perceivable without color alone.
- Hide decorative imagery from accessibility, but provide useful representations for custom controls, charts, canvases, previews, and generated media.

## New App Workflow

1. Choose the platform shell first: macOS split/window app, iOS stack/tab app, iPad adaptive app, menu bar app, document app, or utility window.
2. Create the project structure before filling in UI:
   - `App/`
   - `Views/`
   - `Models/`
   - `Stores/`
   - `Services/`
   - `Support/` or `UI/`
3. Copy `AppDesign.swift` and `AppComponents.swift` into the project.
4. Copy `MacAppShell.swift` or `IOSAppShell.swift` only when useful for the app's initial root layout.
5. Build the first screen using tokens/components, then verify compile errors before expanding.
6. Include an explicit accessibility review in the final handoff.

## OS Availability

Support the current major OS release and one previous major OS release selected for the project.

- Keep the core visual system on broadly available SwiftUI APIs.
- Gate current-OS-only APIs with `#available`.
- Keep fallbacks close to the code that needs them.

## Review Checklist

Before final handoff, verify:

- Feature views use `AppDesign` tokens rather than ad hoc colors/radii/materials.
- macOS feels like macOS; iOS feels like iOS.
- No giant all-in-one `ContentView` for non-trivial apps.
- No opaque custom sidebar/window painting unless deliberate.
- Empty/loading/error/success states exist for async workflows.
- Keyboard, pointer, touch, and assistive-technology behavior are covered for the platform.
- The app builds, or the exact blocker is reported.
