---
name: development-project-documentation
description: Use when making, reviewing, committing, pushing, or preparing changes for any development project, to ensure project documentation including text, diagrams, images, maps, and other visualization products is updated when behavior, architecture, workflows, or user-facing surfaces change.
---

# Development Project Documentation

Use this skill for development work that may be committed, pushed, or handed off.

## Core Requirement

When committing and pushing changes, project documentation must be updated to capture any necessary changes.

Documentation includes:

- Text docs such as README files, architecture notes, setup guides, runbooks, changelogs, and inline docs
- Images and screenshots
- Diagrams, maps, ladder diagrams, navigation maps, state diagrams, flow diagrams, and system interaction diagrams
- Generated docs or structured references used by contributors or users

## Documentation Gate

Before committing, pushing, opening a PR, or declaring implementation complete:

1. Review the code changes and identify whether behavior, configuration, architecture, data flow, user workflows, deployment, setup, or troubleshooting changed.
2. Update the relevant documentation artifacts when the change would help a future developer, operator, tester, or user understand the project.
3. Update visualization products when a diagram, map, screenshot, or image would reduce ambiguity better than prose.
4. If no documentation update is needed, state that explicitly in the final response or commit summary context.

## What To Update

Update docs when changes affect:

- Public APIs, command-line behavior, app workflows, screens, or user-visible behavior
- Project setup, local development, testing, deployment, configuration, or environment variables
- Architecture, module boundaries, data models, state machines, queues, background jobs, or external integrations
- Security, permissions, privacy, signing, entitlements, networking, or storage behavior
- Design-system rules, visual language, screen maps, or platform-specific UI behavior

## Visualization Defaults

Prefer a visualization artifact when the project change involves:

- Multi-step workflows
- Multiple systems, services, screens, or actors
- State transitions or lifecycle behavior
- Spatial relationships, maps, navigation, routing, or hierarchy
- Platform divergence between macOS, iOS, web, server, or tooling surfaces

Keep visuals close to the source documentation they support, and prefer editable or source-controlled formats when the repo already has a convention.

## Practical Judgment

Do not add noisy documentation for trivial internal edits. The bar is whether documentation would prevent repeated explanation, onboarding friction, incorrect usage, or future implementation mistakes.

When documentation is stale but outside the immediate change, make the smallest update that keeps the committed work coherent. Call out larger documentation debt separately instead of mixing it into unrelated code changes.
