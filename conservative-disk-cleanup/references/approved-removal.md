# Approved removal

Read when the user has authorized removal. This skill deliberately supplies a
read-only inspection helper rather than a generic apply command: authorization,
product dependencies and recovery purpose cannot be derived from file age or a
JSON flag. Codex still carries out approved removal with task-specific exact
paths and the available filesystem tools.

## Bind existing authority to concrete paths

Resolve an approved group from the manifest reviewed in this session. Keep a
compact record with fields equivalent to:

```json
{
  "host": "executing host",
  "filesystem": "measured device/mount identity",
  "path": "/absolute/exact/target",
  "role": "historical test fixture",
  "allocated_bytes": 123456,
  "identity": {"device": 1, "inode": 123},
  "usage_evidence": "selected live profiles and consumers inspected",
  "recovery": "user approved retirement; technical receipts retained",
  "authorization": "reference to actual user instruction",
  "status": "approved; preflight pending"
}
```

These are records of evidence, not sources of authority. Omit unavailable fields
honestly. Reject overlapping paths and targets that encompass the host root,
home, whole project/Library/state/backup collections beyond the specific
approval. A recreation, alias change, new filesystem or new protected content
requires renewed inspection; unchanged authority need not be requested again.

## Fresh preflight

- Refresh path identity, type, owner, size and current role. Inspect the target
  and every ancestor for symlink indirection. Inspect every descendant that will
  be removed for other filesystems/mounts, special files, repositories/worktrees,
  release archives/symbols and protected state. Stop the affected path for an
  unresolved finding; do not quietly widen its approval.
- Recheck visible open files/cwds, relevant installed launch references, current
  runtime/profile pointers and retained symlinks pointing into the target.
  Inspect command arguments only if needed for a specific reference and keep
  credential values out of output. Preserve all required generations, not just
  the newest directory. Document visibility gaps proportionately to the risk.
- Confirm task-specific retention/recovery requirements and evidence scope.
  For a cache-only approval, require evidence that the exact leaf contains
  derived data with a viable regeneration source. Record that evidence in the
  manifest. A cache name, age, no open handles, or automatic creation of an empty
  replacement does not prove that the prior data is expendable. Keep mixed,
  unknown, persistent-state and installed-code targets outside cache-only scope;
  use the appropriate separately authorized retirement decision for those roles.
  Small, useful technical receipts can be retained outside the removed tree
  within the approved task. Keep copies private and bounded; exclude secrets,
  raw histories, user input and irrelevant logs. Verify retained copies and
  describe them as evidence rather than a full payload backup.
- Record filesystem available bytes immediately before mutation. Ensure task
  records are outside every deletion target and will survive the operation.

## Exact-path execution and partial failure

Use a structured filesystem API or correctly quoted literal operands. Avoid
shell-evaluated interpolation, globs, broad age filters and recursive cleanup of
an unreviewed parent. A task-local script should embed the exact allowlist,
refuse changed indirection/mounts, recheck consumers immediately before removal,
use a symlink-safe implementation, and write an incremental receipt for each
target. Outward symlinks are unlinked, never followed into live model/state
trees. Do not run the previous task's literal script against new circumstances.

Prefer the least privilege available. Existing approved authentication may be
used; the skill does not authorize changing credentials, permissions or security
settings. If ordinary owner/admin access is unavailable, preserve that target
and finish unaffected approved targets. Prepare the exact guarded action for a
local admin handoff instead of repeatedly requesting the same deletion approval.
Keep password entry local to the OS/Terminal.

On failure, record removed, retained, partial and unknown outcomes accurately.
Reinspect residue before retrying. Continue only while diagnosis produces
evidence and the repair remains within scope. Do not recursively chmod/chown,
disable protections, expand the allowlist or mask errors to force completion.
Report an automatic approval-review rejection as such if it blocks delivery,
with the rejected action and stated reason; do not attribute a sudo password
prompt to that reviewer.

## Verify and return

For each target, check actual absence or exact retained residue. Verify live
pointers, representative protected paths, affected source state, retained
evidence integrity and observable runtime availability. Distinguish a process
check from application journey testing. Compare available bytes on the same
filesystem and timestamps, allowing for concurrent writers.

Use a current status manifest plus immutable earlier receipts. Report removed
allocation, actual net free-space change, and remaining unknowns separately.
Deletion can be complete while an actual-space recovery criterion remains
unmet. Snapshot thinning, cloud deletion, backup-retention changes, uninstalling
tools and additional approval groups require their own sufficient authority;
do not infer it from a disappointing free-space delta.
