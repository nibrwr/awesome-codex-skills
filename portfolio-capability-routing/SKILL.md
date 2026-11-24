---
name: portfolio-capability-routing
description: Use when executing a CO-YYYY-NNN Codex orchestrator handoff that includes a Codex capability plan, when asked to verify Codex plugin/skill/MCP availability, when reconciling declared versus runtime Codex capabilities, or when reporting planned versus actual capability use. Do not trigger merely because an ordinary coding task could use a plugin.
metadata:
  short-description: Route portfolio work through verified Codex capabilities
---

# Portfolio Capability Routing

## Purpose

Use the Codex environment's declared and runtime capability evidence to execute
an approved portfolio handoff without widening its authority.

## Authority first

Before capability routing:

1. read the target repository instructions;
2. read the approved handoff/task packet;
3. identify the approved execution envelope;
4. identify mandatory stop conditions;
5. treat those boundaries as higher priority than capability availability.

A plugin, skill, MCP server, browser, Computer Use surface, or other capability
never grants additional authority.

## Capability verification

When runtime capability state matters, use:

`~/Development/codex-environment/scripts/capability-report.sh`

Use `--json` when structured comparison is helpful.

Do not install, enable, authenticate, update, or reconfigure a capability merely
because the report says it is absent or unknown.

## Required capabilities

When the handoff labels a capability `REQUIRED`:

- verify it at the level required by the task;
- if verified, use it when its trigger point is reached;
- if unavailable or unknown and the handoff provides an authorized fallback,
  use that fallback;
- if unavailable or unknown and no authorized fallback exists, stop and return
  a blocker.

Do not silently substitute a materially different workflow.

## Optional capabilities

When the handoff labels a capability `OPTIONAL`:

- use it when it materially improves execution and is available;
- if unavailable, use the handoff's stated fallback or the ordinary in-scope
  workflow;
- do not stop solely because an optional capability is absent.

## No explicit capability plan

Older handoffs may not contain a capability plan.

In that case:

- do not invent a new mandatory capability requirement;
- normal Codex skill/plugin auto-routing may still occur;
- preserve the handoff scope;
- report capability use only when it is knowable and material.

## Specialist routing

Prefer a named specialist workflow when the handoff names one and it is
available.

Do not claim that a specialist skill auto-triggered unless that fact is visible
to you.

## Permissions and external systems

Plugin visibility does not prove that an included app is connected or that the
user has permission to the underlying system.

If an app-backed action requires authentication, new permission, credential
change, service change, or another consequential action outside the handoff,
stop at the normal authority boundary.

## Return evidence

When capability planning was material, include:

### Capability usage evidence

| Capability | Requirement | Runtime evidence | Used | Result / fallback |
|---|---|---|---|---|

Report:

- planned capabilities actually used;
- planned capabilities not used;
- unavailable or unknown planned capabilities;
- authorized fallback behavior;
- material unplanned capabilities used;
- whether capability limitations affected acceptance evidence.

State explicit versus automatic skill selection only when known.

Never guess which skill auto-triggered.
