# macOS storage evidence

Use for a macOS audit. Probe available local commands and permissions; do not
install utilities or require particular connectors. User/target instructions
decide the executing Mac. Use current facts rather than old host names or paths.

## Bounded measurements

Useful read-only probes, adapted to the selected filesystem and scope:

```sh
uname -n
df -k /System/Volumes/Data
du -x -k -d 1 /absolute/local/root
tmutil listlocalsnapshots /
diskutil apfs list
diskutil apfs listSnapshots /System/Volumes/Data
```

`du -x` stays on one device and ordinarily does not traverse symlinks. Keep
stderr and exit status; permission failures make totals lower bounds. Mounted
simulator images, external disks and aliases can duplicate attribution. Use
`os.statvfs(path).f_bavail * f_frsize` when an exact available-byte observation is
needed, with a timestamp and filesystem identity. Sample before/after promptly;
other workloads can erase the visible gain.

Stage the investigation. Common locations include project roots; user Developer,
Caches and Application Support folders; selected hidden package/model stores;
installed applications; /Library; and /Users/Shared. Scope personal media and
other users' data separately from project artifacts. Avoid repetitive root walks.

Include [Codex cache inspection](codex-caches.md) when Codex is present. Its state,
runtime and desktop-cache locations can sit outside both Development and the
usual user Library/Caches folder; measure relevant leaves separately.

Do not recursively enumerate iCloud/OneDrive/File Provider trees by default.
Enumeration itself can stall a provider or trigger remote work; deletion may
sync to the cloud. Cloud eviction and cloud deletion are separate decisions.
Do not infer that an inaccessible or placeholder tree consumes no local space.

## Usage and dependencies

- `lsof -n -Fpcn` or a narrower cwd/file query can establish current consumers.
  Keep only relevant paths, PIDs and command names in the record. A permission
  warning, missing process visibility or unavailable command is a limitation;
  absence of matching handles is not proof of no future or root-owned consumer.
- Read installed launch plist path fields and relevant environment path values
  without exposing credentials. Query loaded/running state only when accessible.
  Do not start/stop services or enable schedules as part of measurement.
- Follow product-specific activation pointers and selected profile path fields.
  Keep both active and required previous generations; more than two generations
  may have live consumers. Map dependency packs to retained release contracts
  before calling them orphans. A Python service can run from `candidates/`.
- Use `GIT_OPTIONAL_LOCKS=0` with bounded Git status/worktree checks. Protect dirty
  and detached worktrees, ignored state, and local-only revisions. Do not prune
  registrations merely because a path is missing, or fetch to refresh refs
  without the needed network/source authority.

## Interpret common large folders

| Area | Evidence needed before cleanup |
|---|---|
| Package download caches | Distinguish downloads from installed formulae, virtual environments and node_modules. Check current consumers and accept future redownloads. |
| Xcode DerivedData | Generated data; distinguish it from Archives, UserData, device support, result bundles and package sources. Check the actual leaf and any nested worktree. |
| `.xcarchive`, dSYMs, `.xcresult`, AppStore assets | Release symbols, diagnostics and acceptance evidence may be unique. Preserve or selectively retire under explicit retention decisions. |
| Simulator devices | Installed apps and persisted test/user data. A recent plist mtime is a usage signal, not a reliable last-used timestamp. |
| Simulator runtimes | Match installed OS versions to required compatibility testing. Use supported Xcode/simctl management after approval and inspect current local help. Do not manually remove AssetsV2, mounted images or Preboot/Cryptex data. |
| Physical-device support | Check which connected/target device OS it supports. One large current symbol set is not an accumulation of obsolete versions. |
| App state/cache/indexes/models | Resolve the active stateRoot and consumers. A corpus named cache may be the live authoritative representation. Model downloads may still be required for offline or scheduled work. |
| Retained fixtures/staging/packages | Check open/launch/profile/symlink references, source tracking, recovery and evidence purpose. Repeated sizes do not prove equal contents or independent physical blocks. |
| Relocated macOS installer data | Inspect the exact subtree, old payload dates, current OS/recovery operations and owner permissions. Preserve unrelated relocated configuration. The parent name alone is insufficient. |
| Backup software and snapshots | Operational metadata and historical recovery points. Do not treat Backblaze metadata, Time Machine snapshots or recovery volumes as disposable caches. |

A package-manager dry run is evidence, not an approval mechanism. Read the full
proposal: cleanup may include old interpreters, autoremove libraries or links
used outside the manager's dependency graph. Never execute its whole output on
the strength of a cache-only approval.

## Reclamation and permission limits

macOS/APFS can retain deleted blocks in clones or snapshots. File allocation
totals can therefore fall dramatically with little immediate available-space
change. Record measured free bytes and the retained-snapshot observation; do
not claim a particular snapshot holds particular blocks without evidence.

Missing DiskManagement access, TCC denial or an admin password boundary affects
only the relevant evidence/action. Do not weaken SIP, TCC, ACLs, encryption or
backup settings, change ownership, request credentials in chat, or try another
interface to bypass an access rejection. Use a normal authorized local admin
handoff for a proven exact target when necessary. Verify the result afterward;
an unrun launcher is not a completed removal.
