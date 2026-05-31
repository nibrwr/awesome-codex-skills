# Apple Platform Alignment Checklist

Use this checklist when reviewing a new macOS, iOS, or iPadOS screen.

## Brand Consistency

- Does the screen use the shared semantic color roles?
- Does typography match the shared type hierarchy?
- Are iconography and tone consistent with the rest of the product?

## Component Consistency

- Are the same concepts represented by the same component names?
- Are shared states handled consistently?
- Are spacing and radius tokens taken from the shared scale?

## OS Compatibility

- Does the visual system support the current major OS release and one major previous OS release?
- Are system materials and semantic colors used before custom styling?
- Are newer glass APIs and other current-OS-only APIs gated behind availability checks?
- Is there a coherent fallback for the previous major OS release?

## iOS Fit

- Is the primary action obvious and touch-friendly?
- Is the flow focused enough for smaller screens?
- Does navigation feel native to iPhone or iPad?

## iPadOS Fit

- Does the layout adapt across compact, regular, Split View, Stage Manager, and external display contexts where relevant?
- Are sidebars, multi-column layouts, pointer interactions, keyboard shortcuts, or drag-and-drop used where they improve productivity?
- Does the experience remain touch-first even with desktop-like capabilities?

## macOS Fit

- Does the layout support scanability and faster multi-step work?
- Should the screen use a sidebar, toolbar, inspector, or menu command?
- Are keyboard and pointer interactions supported where useful?

## Platform Compliance

- Does the implementation follow the relevant macOS, iOS, and iPadOS interaction guidelines?
- Are accessibility, dynamic type, focus, safe areas, resizing, and input modes handled appropriately?
- Is rendering, animation, memory, and power use efficient for each target platform?

## Accessibility

- Are accessibility traits, labels, values, hints, actions, and identifiers added where needed?
- Do VoiceOver, Voice Control, Switch Control, Full Keyboard Access, focus, pointer, touch, and keyboard interactions remain coherent?
- Does the UI support Dynamic Type, text scaling, contrast modes, Reduce Motion, Reduce Transparency, and differentiating without color?
- Are reading order, focus order, hit targets, gesture alternatives, and semantic grouping handled during implementation?
- Do custom controls, charts, maps, drawings, or visualizations have an accessible representation?
- Are newer accessibility APIs gated when they exceed the supported OS baseline?

## Architecture

- Which tokens are shared?
- Which components are shared?
- Which views should be split by platform?

## Documentation

- Which visual artifacts should exist for this project or feature?
- Is there a diagram for navigation, system interaction, or state flow where one would reduce ambiguity?
- Are the visuals current with the implemented behavior?
