---
name: app-store-assets
description: Create, refresh, or audit App Store screenshot packages for iOS and iPadOS using deterministic UI captures, Apple device frames, benefit-led marketing compositions, organized project assets, and submission validation. Use for new app scaffolding, screenshot updates, product-page work, or App Review preparation.
---

# App Store Assets

Build a reproducible App Store screenshot package whose final images are accurate, current, localized, visually compelling, and ready for App Store Connect.

## Required Outcome

For every new iOS or iPadOS app, add an `AppStore/` directory at the repository root by adapting `assets/AppStore/`. Keep it outside application target membership.

For an existing app, preserve a sound asset pipeline and migrate ambiguous or mixed directories only when the requested work includes that cleanup. Never mix raw captures, generated frames, and uploadable files.

An App Review–ready package must include:

- deterministic source captures for every declared shot;
- exact device frames produced with the `frames` CLI;
- localized, benefit-led marketing copy and restrained supporting graphics;
- opaque final images at current App Store Connect dimensions;
- a manifest recording devices, dimensions, locales, shot order, and the date Apple’s specification was verified;
- automated validation plus a human review of the final sequence;
- an image-rights record when screenshots contain third-party media.

If the app runs on iPad, the iPad screenshot set is required. Do not create an iPad set for an iPhone-only app merely to satisfy the template.

## Workflow

1. Read `references/review-rules.md` when selecting dimensions, writing marketing copy, or preparing an App Review submission.
2. Inspect the app’s supported devices, localizations, visual identity, primary journeys, purchase boundaries, and existing UI-test fixtures.
3. Copy `assets/AppStore/` to the project root as `AppStore/` when the project has no equivalent structured pipeline. Adapt `screenshots.json`, localized copy, and theme values before generating assets.
4. Add project-specific UI tests that enter stable states and save captures with the manifest shot IDs. `assets/AppStore/UITestSupport/AppStoreScreenshotSupport.swift` provides the attachment helper.
5. Capture real app UI on the current shipping OS with fictional data. Exclude Simulator chrome, notifications, debug overlays, keyboards unless essential, real personal data, and irrelevant third-party content.
6. Run `frames --json info` before framing. Confirm supported device and color names with `frames list` or `frames list-colors` when exact names matter.
7. Frame with the exact manifest `device` value. Do not rely on automatic newest-variant resolution for release assets.
8. Compose the framed image onto the exact final canvas. The app UI must remain prominent and readable; `frames` output alone is an intermediate, not an App Store deliverable.
9. Run `AppStore/scripts/build.sh`. Review every final image and the sequence at thumbnail size before calling the package complete.

## Marketing Direction

- Lead with core value, primary workflow, and the strongest differentiator; the first one to three screenshots carry the product story.
- Give each image one focal benefit. Prefer a short headline and one supporting line over paragraphs or feature inventories.
- Use the app’s palette and visual character. Keep graphics current and restrained, with enough safe area for different App Store placements.
- Show what the released build actually does. Do not imply unavailable functionality, free access to paid content, current prices, awards, or guarantees that cannot be verified.
- Localize both the app state and the marketing copy. Do not reuse English artwork for a declared localized set unless the user explicitly chooses that product-page behavior.
- Use fictional account information and record the rights for visible photography, illustrations, trademarks, or other third-party material.

## Naming and Ownership

- Use locale directories such as `en-US` and device-set directories such as `iphone-6.9` and `ipad-13`.
- Use two-digit narrative prefixes and lowercase kebab-case shot IDs, for example `01-core-value`.
- Name final files `<shot-id>-<width>x<height>.png`.
- Treat `sources/`, `copy/`, `screenshots.json`, `scripts/`, and `rights/` as maintained inputs.
- Treat `.build/` as generated and ignored.
- Keep only validated uploadable images under `deliverables/`; do not place contact sheets or archives there.

## Verification and Handoff

Run:

```bash
AppStore/scripts/build.sh
```

Before handoff, report:

- the validated device sets, locales, dimensions, and shot count;
- the Apple specification verification date recorded in the manifest;
- whether strict OCR validation ran;
- any manual checks still required in App Store Connect Preview;
- any physical-device or live-data states that could not be represented in Simulator captures.

Do not claim that screenshots were uploaded or approved unless that separate action actually occurred.
