# App Store Screenshot Review Rules

Read this reference when selecting screenshot dimensions, composing public marketing artwork, or assessing App Review readiness.

## Authoritative Sources

- Screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/
- Upload screenshots and previews: https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots/
- App Review Guidelines, especially section 2.3: https://developer.apple.com/app-store/review/guidelines/
- Product-page guidance: https://developer.apple.com/app-store/product-page/
- Asset best practices: https://developer.apple.com/app-store/asset-best-practices/

These requirements change. Verify the current Apple pages before each release that creates or replaces screenshots, then update `screenshots.json` with the verification date and accepted dimensions. Do not silently trust the template’s historical defaults.

## Baseline Verified on 2026-08-31

The bundled template uses:

- iPhone 6.9-inch portrait: `1320 × 2868` pixels, captured for and framed as iPhone 17 Pro Max Portrait.
- iPad 13-inch portrait: `2064 × 2752` pixels, captured for and framed as iPad Pro 2024 13 Portrait.

Apple currently accepts one to ten screenshots per device size in PNG or JPEG format without transparency. When the user interface is equivalent across device sizes, Apple can scale the highest-resolution required set for smaller display classes. An iPad set remains required when the app runs on iPad.

## Accuracy and Content

- Screenshots must show the app in use, not only title art, a splash screen, or a login screen.
- Text and image overlays may explain or highlight the experience but must not obscure it.
- The device and product imagery must match the App Store Connect device type.
- Metadata must accurately represent the submitted build and remain appropriate for a broad public audience.
- Clearly identify featured content or functionality that requires an in-app purchase or subscription.
- Avoid prices, irrelevant metadata, unverifiable claims, Apple-designated awards, and imagery from other mobile platforms.
- Use fictional account data and secure the rights to every visible asset.

## Sequence and Copy

- The first one to three screenshots may appear in search results when no app preview precedes them.
- Make the first three understandable as a compact story: value, action, differentiation.
- Use short phrases that enhance the visual rather than narrating every visible control.
- Keep all essential text and focal artwork inside a generous central safe area.
- Include Dark Mode when it materially represents the app, not as a mandatory decorative variant.
- Localize marketing text for every screenshot localization and verify that the captured app UI uses the matching language.

## Final Manual Review

Automated validation cannot judge marketing accuracy, readability, rights, or whether the UI matches the submitted build. Inspect the complete sequence at full size and at App Store search-result scale, then use App Store Connect Preview before submission.
