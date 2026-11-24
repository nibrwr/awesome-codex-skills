# App Store Assets

This directory contains the reproducible screenshot package for App Store Connect. It is project support material and must not be added to the application target.

## Maintained Inputs

- `screenshots.json`: device sets, current accepted dimensions, visual theme, locales, and shot order.
- `copy/<locale>.json`: localized marketing copy keyed by shot ID.
- `sources/<locale>/<device-set>/`: deterministic, unframed app captures.
- `scripts/`: frame, compose, and validate the package.
- `rights/image-rights.md`: provenance and usage rights for visible third-party media.

Generated frame intermediates go under `.build/`. Only validated uploadable images belong under `deliverables/`.

## Initial Setup

1. Confirm the app’s iPhone and iPad support and update `platforms` in `screenshots.json`.
2. Check Apple’s current screenshot specification and update the accepted dimensions and `verifiedOn` date.
3. Replace the sample localized copy and theme with the app’s real product story and visual identity.
4. Copy `UITestSupport/AppStoreScreenshotSupport.swift` into the UI-test target and create project-specific tests that capture each declared shot ID.
5. Export each unframed capture as `<shot-id>.png` into the matching `sources` directory.
6. Run `scripts/build.sh` from any working directory.

The default package expects at least three screenshots because the opening sequence should communicate the app’s value, primary workflow, and differentiator. Apple permits up to ten.

## Commands

```bash
AppStore/scripts/frame.py
swift AppStore/scripts/compose.swift AppStore
AppStore/scripts/validate.sh

# Complete pipeline
AppStore/scripts/build.sh
```

Strict OCR checks are enabled by default and require `tesseract`. To run structural validation without OCR for a non-release draft:

```bash
APPSTORE_STRICT_OCR=0 AppStore/scripts/validate.sh
```

Do not disable strict OCR for the final App Review readiness check.
