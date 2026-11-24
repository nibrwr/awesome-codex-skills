---
name: conservative-disk-cleanup
description: "Audit local project and developer disk usage, including Codex caches, identify obsolete assets conservatively, and execute explicitly approved filesystem cleanup. Use for low disk space, project-versus-storage reviews, stale build/runtime assets, or continuing an approved cleanup list. Excludes cloud-account deletion, ordinary code cleanup, and automatic backup or snapshot pruning."
---

# Conservative Disk Cleanup

Recover usable space while protecting current projects, unique data, and required
recovery evidence. Treat an audit as read-only. Execute removal only within the
user's existing approval; a previously approved named group resolves to the exact
paths in its reviewed manifest. Continue that scope without asking again.

Creating or invoking this skill grants no deletion, installation, credential,
service-reconfiguration, cloud-sync, or scheduling authority. Old task receipts
are historical evidence, never approval for another machine or a recreated path.

## Establish the target and smallest useful proof

- Resolve the executing host, intended filesystem, free space, and approved
  endpoint: an assessment, removal of named assets, or actual space recovery.
  Refresh changed paths and relevant evidence on continuation rather than
  restarting an unchanged audit. Follow current host instructions; do not assume
  every Mac is a compute client or every task belongs on one fixed host.
- Measure free bytes on the target filesystem before extensive work. Check
  read/write access and owner/admin needs early. A normal shell sandbox
  escalation does not provide root privileges. Complete independent authorized
  work when a particular path needs user authentication.
- Find a few large contributors first, then relate them to current usage. Avoid
  full-disk recursive scans when bounded top-level measurements already identify
  the useful targets. On macOS, read [macOS storage evidence](references/macos.md).
- Include Codex's cache locations in developer storage audits where present,
  even when they sit outside project directories. Read
  [Codex cache inspection](references/codex-caches.md) to discover the actual
  locations and distinguish caches from persistent state and installed runtimes.

## Relate size to current usage

Measure allocated and logical size separately. Record inaccessible, excluded,
mounted, timed-out, and partially scanned areas; unknown is not zero. Do not add
parent/child measurements together. Hard links, APFS clones, sparse files and
snapshots prevent directory allocation totals from proving recoverable bytes.

Use the bundled metadata-only helper for bounded local paths when useful:

```sh
python3 /path/to/conservative-disk-cleanup/scripts/inspect_paths.py \
  /absolute/project/path /absolute/cache/path \
  --open-files --output /absolute/task-record/inspection.json
```

The helper never reads file bodies or deletes data. It lists immediate child
totals, flags archive/Git markers, samples symlink targets, skips cloud provider
trees and nested filesystems, and records scan limits. Samples are bounded and
do not resolve link chains; inspect omitted links before removal. An incomplete
or unreferenced scan does not make a path safe. See `--help`; choose an output
outside scanned roots.

Cross-check the largest candidates against relevant evidence:

- Visible project registrations and applicable project instructions; Git HEAD,
  status, ignored/untracked assets and worktree registrations. Inspect nested
  repositories before treating a parent as build output. Cached remote refs or
  a clean checkout do not prove that every asset is backed up.
- Observable process file/cwd use, installed launch definitions, current and
  previous release pointers, runtime symlinks, and narrowly selected application
  profile path fields. An installed service definition does not establish that
  it is running. An empty open-file result is only one moment of evidence.
- Actual contents and purpose: release archives/symbols, test-result bundles,
  evaluation corpora, user-created media, state databases, restore fixtures,
  downloaded packages, installed dependencies and reproducible build output.

Collect metadata first. Avoid document bodies, credentials, environment values,
raw chat history or bulk configuration reads. Use supported chat/project tools
only when a specific unresolved dependency needs that evidence; never build a
private-history index. Restrict task records containing paths to local private
storage and avoid exposing secret-bearing process arguments or logs.

## Produce a reviewable cleanup list

Use risk and recovery purpose, not folder age, Git-ignored status, or names such
as `cache`, `build`, `candidate`, `staging`, `tmp` or `old`.

Before labelling a leaf disposable cache, establish its producer, authoritative
source and supported regeneration behavior, and exclude unique state or required
installed code from the exact target. A recreated empty file or directory does
not prove its previous contents are recoverable. Mark insufficiently understood
or mixed contents as unknown/keep; metadata alone cannot certify disposability.

Distinguish reproducible caches/intermediates, historical assets requiring a
retention decision, optional user history/backups, and live or unique assets to
keep. These labels are assessment results, not a fixed A/B/C policy. Inspect
contents before classifying; an ignored `build/` can contain release archives
and dSYMs, or an active worktree.

For each proposed target record its exact absolute path, filesystem/identity,
measured allocation, role, usage evidence, recovery expectations, unresolved
conditions, authorization and proposed action. Keep target paths disjoint.
Link one compact manifest and enough evidence for review. Name the actual
directories before requesting any still-missing deletion decision.

Prefer verified recovery for unique data when the task requires recoverability.
Do not invent a universal backup gate for disposable caches or an explicitly
approved retirement of known historical assets. A metadata inventory or retained
receipt is not a restorable backup. Do not create large copies, change backup
retention or use another volume without the necessary scope and resources.

## Execute an approved list

Read [approved removal](references/approved-removal.md) at the point of deletion.
It covers path identity, fresh consumer checks, symlinks, mounts, small evidence,
partial failure and owner/admin handoff. Use exact approved paths, never a broad
name/age glob, shell expansion, blanket package-manager cleanup, or a stale
machine-specific script copied from another task.

Preserve current applications, required dependency and rollback generations,
user data, source changes, cloud content, backup operational metadata, snapshots,
release symbols and acceptance evidence unless those exact assets have their
own sufficient approval. Analyze unaffected items while a real boundary blocks
another. Do not silently broaden an asset approval to reclaim backup snapshots.

## Verify the usable result

Verify target absence or exact retained residue, preserved live pointers and
paths, relevant source state and representative runtime availability. Choose
proportionate read-only health checks when available; do not trigger ingest,
inference, builds, installs or app-data migrations just to validate a disk audit.
Report process availability separately from full application journey testing.

Measure available bytes on the same filesystem again. Report both allocated
files removed and the observed net free-space change; record concurrent-write,
snapshot, clone and purgeable-storage uncertainty. If actual recovery remains
unproven, say so even when every unlink succeeded. Do not claim the directory
total was recovered or automatically thin snapshots to make the estimate pass.

Update the current manifest and keep earlier reports clearly marked historical.
Return what was removed, what was preserved, actual space measurements,
verification results, any partial/admin blockage, and the next genuine decision.
Use PASS, FAIL, BLOCKED, NOT RUN and NOT APPLICABLE accurately. Keep schedules,
other approval groups and unrelated repository state outside the execution.
