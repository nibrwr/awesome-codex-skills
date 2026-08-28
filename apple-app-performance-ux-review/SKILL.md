---
name: apple-app-performance-ux-review
description: Audit an existing Apple-platform app for performance, code efficiency, accessibility, and alignment with current UI/UX patterns. Use for evidence-driven app review and optimization recommendations; do not treat it as authorization to implement fixes.
---

# Apple App Performance & UX Review

Produce a repository-specific audit that separates measured problems from plausible code risks and validates the product against current Apple guidance and relevant popular apps.

The normal outcome is a review, not source changes. If the user also requests implementation, complete the audit first and change only what the user's implementation request authorizes.

## Preserve scope

- Read repository instructions such as `AGENTS.md` before taking project actions.
- Inspect Git identity, branch, status, upstream, and relevant project documentation. Preserve unknown work and do not clean, reset, stash, or rewrite it.
- Treat builds, tests, simulator use, profiling, and web research as review activities. Do not edit tracked files merely to make profiling easier unless implementation is explicitly authorized.
- Do not turn competitive research into market research, copied design, or unsolicited feature expansion.
- Never expose credentials, signing material, private user data, HealthKit samples, or other sensitive runtime content.

## Establish the product and technical baseline

Map only what is needed to understand the app:

- product question and primary workflows;
- supported Apple platforms and deployment targets;
- SwiftUI, UIKit, AppKit, SwiftData, Core Data, networking, and service boundaries;
- navigation, state ownership, persistence, synchronization, and dependency structure;
- build schemes, test targets, fixture modes, and documented validation commands.

Identify the app's intended scale before calling an operation inefficient. A linear scan can be appropriate for ten records and problematic for ten thousand.

## Collect evidence proportionally

Prefer existing project commands and a dynamically selected simulator or destination.

When applicable, collect:

- Xcode and SDK versions;
- project and scheme listing;
- clean build and relevant unit/UI tests;
- static analyzer results;
- existing large-data or reconciliation tests;
- launch, responsiveness, CPU, memory, allocation, or view-update evidence;
- screenshots of important light, dark, compact, large, empty, loading, error, and populated states.

Use Release/on-device Instruments evidence for conclusions about hitches, view-body cost, memory, or launch time when available. SwiftUI, Time Profiler, Allocations, Leaks, and Points of Interest are useful choices, but select only what can answer a concrete question.

Never present these as equivalent:

- shell command duration and time-to-interactive;
- Debug Simulator memory and production device memory;
- a test's wall-clock duration and UI responsiveness;
- code inspection and trace-confirmed performance behavior.

If a tool or device is unavailable, record the limitation and continue with the strongest safe evidence available.

## Review code efficiency

Trace important user actions through views, state, persistence, and services. Look especially for:

- repeated collection scans or calculations in view bodies and computed properties;
- broad queries when a predicate, limit, aggregate, or count would suffice;
- unstable identity, forced `.id` churn, or unnecessary subtree recreation;
- observation or environment dependencies that invalidate more UI than necessary;
- expensive work, persistence, or I/O on the main actor;
- unbounded initial imports, lists, image decoding, or caches;
- overlapping asynchronous work, duplicate requests, cancellation gaps, or unsafe state advancement;
- redundant persisted derived values;
- generalized abstractions without current consumers;
- locale, date, unit, migration, error-recovery, and privacy correctness issues.

For each finding, state:

1. user impact;
2. evidence and exact file location;
3. measured, code-backed, or speculative confidence;
4. smallest effective correction;
5. validation needed after the correction.

Call out healthy architecture and deliberate tradeoffs as well as defects.

## Validate UI and UX

Inspect the running app rather than inferring the experience entirely from source. Review:

- information hierarchy and glanceability;
- navigation and task completion cost;
- loading, success, empty, limited-access, offline, and error states;
- copy density, repeated explanation, and status accuracy;
- Dynamic Type, VoiceOver labels and order, contrast, color-independent meaning, reduced motion/transparency, hit targets, and keyboard behavior;
- light/dark appearance and the smallest and largest supported layouts;
- appropriate use of semantic colors, materials, typography, symbols, and native controls;
- consistency between displayed state and what platform APIs can actually prove.

Do not assume system colors automatically create sufficient contrast in every foreground/background pairing. Include a dedicated accessibility section in the report even when the result is positive.

## Research current comparable apps

Because popularity and current design patterns change, browse the web for this portion unless the user explicitly forbids it.

- Start with current Apple Human Interface Guidelines, Apple developer documentation, and Apple first-party apps.
- Use official product help/documentation and current App Store listings for comparable apps.
- Select roughly four to eight relevant, actively maintained products. Prefer direct workflow comparables over famous but unrelated apps.
- Use current rating volume, editorial recognition, platform prominence, or official adoption evidence when describing an app as popular; avoid unsupported popularity claims.
- Cite every time-sensitive claim with a direct link near the claim.
- Compare interaction patterns, hierarchy, defaults, recovery, privacy language, and accessibility—not exact colors, branding, assets, or layouts.

Classify benchmark conclusions as:

- **Validated:** the app's current choice matches a strong contemporary pattern;
- **Opportunity:** a proven pattern could materially simplify or improve the workflow;
- **Avoid:** adopting the competitor behavior would dilute the product question or add unjustified complexity.

Do not recommend feature breadth merely because large fitness apps contain it.

## Report the result

Lead with the overall outcome and highest-impact action. Keep the report usable by an implementer.

Include:

1. repository and test state;
2. concise performance evidence with environment and limitations;
3. prioritized findings ordered by user impact, risk, and effort;
4. current-app UI/UX benchmark with citations;
5. accessibility recommendations;
6. positive findings and decisions worth preserving;
7. a smallest-coherent implementation sequence;
8. profiling or validation still needed;
9. confirmation of whether files were changed and the final worktree state.

Use clickable absolute file links with tight line references. Avoid enormous successful logs. Do not invent timings, test counts, device results, or source findings.

When no material issue exists, say so plainly instead of manufacturing recommendations. When implementation follows, preserve measured baselines so the post-change audit can demonstrate whether the work helped.
