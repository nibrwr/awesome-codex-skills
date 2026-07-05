---
name: apple-app-quality-test-loop
description: Run a rigorous quality testing loop for iOS, iPadOS, macOS, and shared SwiftUI apps. Use automatically for Apple app development, implementation, bug fixing, code review, release prep, or final handoff when Codex needs to test an app as a new user, verify UX/UI, exercise every feature/control/process, audit accessibility, and check device resource usage and performance.
---

# Apple App Quality Test Loop

## Overview

Use this skill as a required quality gate before handing off iOS, iPadOS, macOS, or shared SwiftUI app work. Start broad as a first-time user, then focus into UX/UI, full functionality, accessibility, and resource/performance behavior.

Do not claim a pass was tested unless there is concrete evidence from running the app, tests, simulator/device automation, screenshots, logs, or inspected code. If a platform, device, or tool is unavailable, state the exact limitation and perform the strongest fallback review possible.

## Test Setup

1. Discover the project structure, schemes, targets, supported platforms, feature modules, existing tests, fixtures, entitlements, and launch requirements.
2. Build a feature inventory from views, navigation routes, commands, settings, menus, toolbar items, buttons, sliders, toggles, pickers, forms, gestures, shortcuts, onboarding, permissions, import/export flows, networking, persistence, and background processes.
3. Define the platform matrix before testing:
   - iOS: representative compact iPhone simulator/device, portrait and landscape when supported.
   - iPadOS: regular-width iPad, multitasking/Split View behavior when relevant, pointer and keyboard behavior when supported.
   - macOS: local app or Mac target, small/default/large windows, menu and keyboard behavior.
4. Prefer XcodeBuildMCP tools when available for Apple build, run, simulator, UI, screenshot, and log workflows. Use `xcodebuild`, `xcrun simctl`, XCTest, UI tests, Instruments, or installed SDK tools as fallbacks.
5. Reset state for new-user testing when possible: uninstall the app, clear containers, use fresh simulator state, or start with a clean local data store.

## Loop Order

Run the passes in this order. Fix blockers and high-severity issues, then rerun the affected pass and any regression-prone earlier pass.

### 1. New User Pass

Use the app with no project knowledge.

- Launch from a clean install and observe first-run comprehension, onboarding, empty states, default data, permission prompts, and initial navigation.
- Try to complete the app's main job without reading code or internal docs first.
- Record confusion, dead ends, unclear labels, missing feedback, surprising defaults, and flows that require hidden knowledge.
- Verify failure states a new user can hit: denied permissions, offline/network errors, invalid input, missing files/accounts, canceled operations, and empty results.

### 2. UX/UI Pass

Evaluate whether the app feels native, coherent, and usable on each supported platform.

- Check navigation structure, window behavior, safe areas, resizing, rotation, scrolling, split views, sheets, popovers, inspectors, sidebars, tabs, menus, and toolbars.
- Check text fit, truncation, alignment, density, tap/click targets, hover states, focus states, disabled states, selection states, loading/progress states, empty/error/success states, and light/dark/high-contrast appearances.
- Verify controls communicate state and affordance without relying on color alone.
- Confirm iOS remains touch-first, iPadOS adapts to wider and multitasking contexts, and macOS supports keyboard, menu, pointer, and resizable-window expectations.

### 3. Functionality Pass

Exercise every feature, control, and process from the inventory.

- Trigger every visible button, toolbar item, menu command, context-menu item, shortcut, tab, navigation link, sheet action, alert action, slider, stepper, toggle, picker, text field, drag/drop target, gesture, and custom control.
- Test common, boundary, invalid, canceled, repeated, undo/redo, persistence, restart, and concurrent-use cases.
- Verify async workflows: loading, cancellation, retry, partial failure, progress, timeout, duplicate submission, and recovery.
- Verify system integrations: file import/export, pasteboard, sharing, notifications, permissions, networking, storage, background tasks, widgets, app intents, and documents when present.
- Add or update focused tests when the task changes code in a way that can regress.

### 4. Accessibility Pass

Treat accessibility as a release requirement, not a best-effort review.

- Verify labels, values, hints, traits, headings, grouping, selected/disabled states, error/status announcements, and custom accessibility actions.
- Check VoiceOver order, keyboard focus order, Full Keyboard Access, Switch Control-compatible actions, Voice Control names, pointer alternatives, and gesture alternatives.
- Test Dynamic Type/text scaling, high contrast, Reduce Motion, Reduce Transparency, Differentiate Without Color, dark mode, and light mode where possible.
- Ensure custom drawing, Canvas/Shape content, charts, maps, previews, media, and custom controls have useful accessible representations or are hidden when decorative.

### 5. Resource And Performance Pass

Measure behavior at a level appropriate to the change and platform.

- Check cold launch, warm launch, main-flow responsiveness, animation smoothness, scrolling, rendering cost, and UI hangs.
- Watch memory growth, leaks, CPU spikes, battery/power impact, thermal pressure, network usage, disk writes, cache growth, and background activity.
- Exercise lifecycle transitions: background/foreground, sleep/wake, scene changes, rotation/resizing, termination/relaunch, and low-resource conditions when practical.
- Use XCTest metrics, Instruments, logs, activity monitors, simulator/device diagnostics, or code-level analysis depending on what tools are available.

## Severity

- Blocker: crash, data loss, unusable primary flow, severe accessibility exclusion, severe performance/resource issue, or app cannot build/run on a required platform.
- High: broken important feature, misleading state, major platform convention violation, inaccessible critical control, repeated hang, or obvious leak/resource runaway.
- Medium: degraded secondary flow, confusing UX, missing edge-case handling, layout issue, incomplete state feedback, or avoidable performance cost.
- Low: polish issue, copy tweak, minor layout inconsistency, or non-blocking test coverage gap.

## Handoff

Every substantial Apple app development handoff must include a quality test summary with:

- Build/test commands or tools used.
- Devices, simulators, OS versions, and app targets covered.
- New-user findings.
- UX/UI findings.
- Functionality coverage and any untested controls/processes.
- Accessibility findings.
- Resource/performance findings.
- Fixes made during the loop.
- Remaining risks, tool limitations, and recommended next tests.
