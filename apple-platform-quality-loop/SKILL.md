---
name: apple-platform-quality-loop
description: Standard quality review loop for iOS, iPadOS, macOS, and WidgetKit app development. Use when asked to test, retest, audit, harden, prepare for TestFlight/App Review, or look for gaps in functionality, usability, UI/UX, code efficiency, performance, privacy, or security in Apple platform projects.
---

# Apple Platform Quality Loop

Use this skill to run a repeatable quality loop before or after implementation work on Apple platform apps.

## Loop Shape

Run at least three passes unless the user asks for a narrower review:

1. Functionality and UX pass
2. Code efficiency and maintainability pass
3. Security, privacy, and App Review readiness pass

After those passes, run verification commands that fit the project and report findings first, ordered by severity.

## Pass 1: Functionality and UX

- Identify the main user journeys from the app structure, current request, and screenshots.
- Exercise first run, permission prompts, empty states, failure states, primary actions, settings, deep links, widgets, and platform-specific affordances.
- For iOS/iPadOS, prefer simulator verification when the user asks for Simulator work; include physical-device gaps when features depend on Photos, widgets, background refresh, camera, location, iCloud, or push.
- For macOS, check menu commands, window sizing, toolbar behavior, keyboard navigation, sandbox entitlements, and document/app lifecycle.
- Check that labels match behavior. Rename, remove, or implement UI that advertises unavailable functionality.
- Capture screenshots when visual layout, truncation, overlap, or widget rendering is part of the risk.

## Pass 2: Code Efficiency and Maintainability

- Look for repeated expensive work in SwiftUI body properties, synchronous disk or PhotoKit work on the main actor, large values stored in WidgetKit timeline entries, repeated image decoding, and unbounded library scans.
- Check task cancellation, stale async results, cache invalidation, memory pressure, and background refresh assumptions.
- Prefer small mitigations that fit the existing architecture before adding new abstractions.
- Add focused tests for pure logic, cache behavior, formatting, model transformations, and routing decisions. Do not fake OS services unless the project already has a test seam for them.

## Pass 3: Security, Privacy, and Review

- Search for credentials, tokens, arbitrary networking, pasteboard use, hidden file writes, insecure URL handling, excessive entitlements, analytics/tracking SDKs, and privacy-copy mismatches.
- Verify Info.plist usage strings, entitlements, app groups, background modes, URL schemes, and App Review notes.
- For Photos apps, distinguish developer-operated networking from Apple system services such as PhotoKit iCloud retrieval, Maps rendering, reverse geocoding, and WidgetKit.
- Ensure local caches containing user media are stored in the intended container and excluded from backup when using fallback storage.
- Validate that App Privacy answers and in-app privacy copy match actual behavior.

## Verification

Use the project's existing tools and schemes. Typical commands:

```bash
git diff --check
xcodebuild -project <App>.xcodeproj -scheme "<Scheme>" -destination 'platform=iOS Simulator,name=<Device>' build
xcodebuild -project <App>.xcodeproj -scheme "<Scheme>" -destination 'platform=iOS Simulator,name=<Device>' test
```

For widgets, also inspect timeline provider payload size, placeholder behavior, stale-cache behavior, and tap deep links.

## Report Format

Lead with findings:

- Severity and user impact
- File and line reference
- Recommended fix or mitigation
- Verification status

Then include residual risks and next recommended actions. Do not claim a full security audit unless the security-specific toolchain and artifacts were actually run.
