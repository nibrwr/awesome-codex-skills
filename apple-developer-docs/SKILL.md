---
name: apple-developer-docs
description: Use when verifying Apple platform APIs, Swift or SwiftUI behavior, AppKit/UIKit/Foundation details, Human Interface Guidelines, Swift Evolution proposals, Apple sample code, or Swift package documentation with the local Cupertino documentation index. Trigger for macOS, iOS, iPadOS, watchOS, tvOS, visionOS, Swift, SwiftUI, Xcode, API availability, sample-code lookup, symbol lookup, package selection, and Apple design guidance that should be checked against current local docs.
---

# Apple Developer Docs

Use Cupertino as the primary local source for Apple platform documentation before relying on memory for Apple APIs, Swift language behavior, Human Interface Guidelines, sample-code patterns, package docs, or platform availability.

## Preferred Workflow

1. Search narrowly enough to identify the relevant document, proposal, sample, symbol, or package.
2. Read the full result before implementing or making claims; do not rely only on search excerpts.
3. Apply deployment target filters when compatibility matters.
4. Cite or summarize the specific document, URI, sample project, proposal, or package that informed the decision.

## MCP Usage

When Cupertino MCP tools are available, use them before shelling out. Expected tools include:

- `search` for unified search across Apple docs, HIG, samples, Swift Evolution, Swift.org, the Swift Book, packages, and Apple Archive.
- `read_document`, `list_frameworks`, `list_documents`, and `list_children` for Apple documentation and guide content.
- `list_samples`, `read_sample`, and `read_sample_file` for Apple sample projects.
- `search_symbols`, `search_property_wrappers`, `search_concurrency`, `search_conformances`, `search_generics`, and `get_inheritance` for indexed Swift/API symbol analysis.

Prefer JSON or structured tool output when available so code can be checked programmatically.

## CLI Fallback

If MCP tools are not available in the current session, use the installed CLI:

```bash
cupertino doctor
cupertino list-sources
cupertino search "NavigationSplitView selection" --source apple-docs --framework swiftui --format json
cupertino read "apple-docs://swiftui/navigationsplitview" --format json
```

Use the `uri`, project ID, or file path returned by search results when reading other documents or samples.

Use source filters to avoid noisy results:

- `--source apple-docs` for current Apple API documentation.
- `--source hig` for Human Interface Guidelines.
- `--source samples` plus `list-samples`, `read-sample`, and `read-sample-file` for working sample code.
- `--source swift-evolution` for proposals; add `--swift 6.0` or the relevant Swift version when needed.
- `--source swift-book` or `--source swift-org` for language and Swift.org guidance.
- `--source apple-archive` for legacy guides such as Core Animation, Quartz 2D, KVO, and KVC.
- `--source packages` or `package-search` for Swift package documentation.

For platform availability, filter by target:

```bash
cupertino search "ShareLink" --source apple-docs --framework swiftui --platform iOS --min-version 16.0 --format json
cupertino search-symbols --query Task --kind struct --limit 3 --format json
```

For sample code, first find the project ID, then read the README or specific files:

```bash
cupertino search "document based app SwiftUI" --source samples --format json
cupertino read-sample swiftui-building-a-document-based-app-using-swiftdata --format json
cupertino read-sample-file swiftui-building-a-document-based-app-using-swiftdata Start/FlashCard/Support/UTType+FlashCards.swift --format json
```

For package decisions:

```bash
cupertino package-search "SwiftUI charting package with iOS 17 support" --platform iOS --min-version 17.0 --swift-tools 5.9
```

## Operating Rules

- Run `cupertino doctor` if search/read commands fail unexpectedly.
- If databases are missing, tell the user `cupertino setup` is required and note that it downloads large local documentation indexes.
- Prefer local project source and build errors for project-specific behavior; use Cupertino to verify Apple/platform facts.
- For generated code, translate documentation into code that matches the repository's deployment target and existing architecture.
- For design work, pair this skill with Apple platform design guidance when Human Interface Guidelines or platform-native behavior matter.
