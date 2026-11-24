# Codex cache inspection

Read during local developer storage audits when Codex is present, and whenever
the user names Codex's cache. This is inspection guidance, not cache-clearing
authority. An instruction to update this skill does not authorize a cleanup.

## Require evidence of regenerability

An on-disk cache can survive restarts; persistence on disk does not distinguish
derived cache data from unique user state. Classify each exact leaf as
**regenerable cache**, **persistent state**, **installed code**, **mixed**, or
**unknown**. Discovery paths below are not declarations of temporary contents.

For a regenerable-cache finding, record the producer and its actual role, the
authoritative inputs/download source, and evidence from the current implementation
or applicable vendor documentation that the leaf is derived and can be rebuilt.
Check that required inputs/access are available and disclose offline/redownload
tradeoffs. Confirm that the exact target excludes unique user data, unfinished
work, settings, auth state, required executables and their dependency manifests.
Normal consumer/path preflight and explicit removal approval still apply.

Metadata inspection, an empty open-file result, an old timestamp, an expired
entry, or a process that recreates the directory is insufficient by itself.
An app can recreate an empty cookie/history database while losing the previous
data. Do not clear real user data or restart/reset the running app to test this
assumption. Use source/docs or an authorized isolated representative test;
otherwise mark regeneration **not established** and keep the leaf out of the
cache-removal list. This holds only the uncertain leaf, not unrelated audit work.

## Discover actual locations

Resolve `CODEX_HOME` from the current environment when set; otherwise use
`~/.codex`. OpenAI documents this as a state directory containing configuration,
credentials, history, logs and caches, rather than a wholly disposable cache.
[Official state-location documentation](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations).

Inspect only relevant directory metadata initially. These are discovery
candidates observed in local installations, not a guaranteed cross-version
layout or an automatically approved deletion list:

| Candidate location | Interpretation and review |
|---|---|
| `$CODEX_HOME/cache/` | Catalog/tool metadata candidates. The exact leaf's regeneration source must be established; the parent name alone does not certify that every JSON or temporary file is disposable. |
| `$CODEX_HOME/.tmp/` | Temporary Git, plugin and installation work can live here. Inspect nested repositories and in-progress work; the name does not prove abandonment. |
| `$CODEX_HOME/plugins/cache/` | May contain installed plugin versions, skills and MCP/server code. Preserve referenced/enabled/current and required rollback versions. Treat removal of installed code as dependency retirement, not ordinary download-cache cleaning. |
| `~/.cache/codex-runtimes/`, and an equivalent under `XDG_CACHE_HOME` if present | Downloaded or installed tool/runtime bundles. Discover the paths actually used; do not assume Codex honors every cache-root convention. Keep executable environments required by this chat or other tools, even when no file is open at the instant checked. |
| `~/Library/Caches/Codex/` on macOS | Mixed discovery root, not an approval target. Inspect exact HTTP/code-cache leaves beneath profile/partition directories; protect any state or storage in the same tree. |
| Discovered cache leaves under `~/Library/Application Support/Codex/` on macOS | Examples include `Cache`, `Code Cache`, `GPUCache` and shader-cache directories when present. Inventory specific leaves; the parent also contains persistent application/browser state. |

Respect discovered overrides, aliases and current client naming. Missing paths
are not an error; inaccessible paths have unknown size. Do not create missing
directories, change settings or install Codex to complete an inventory. Deduplicate
aliases/overlapping roots so state and cache subtotals are not counted twice.

The official plugin documentation confirms that installed copies may be loaded
from `~/.codex/plugins/cache/<marketplace>/<plugin>/<version>/`. A `cache` name
therefore cannot establish disposability.
[Official plugin loading documentation](https://developers.openai.com/plugins/build/plugins#how-local-marketplaces-work).

## Protect persistent state and active consumers

Keep session/history records, archived sessions, databases and their WAL/SHM
files, configuration, authentication material, worktrees, automations, rules,
skills, generated images, visualizations and attachments outside a cache-only
approval. App/browser profiles, cookies, local/session storage and installation
metadata may also be persistent. Do not open raw conversations, database rows,
auth files or broad configuration/log contents to classify disk usage.

For proposed cache leaves, check relevant Codex, desktop/browser, plugin/MCP,
runtime and installation/update consumers, process cwd/open files, retained
runtime paths, symlinks and configured plugin versions. An empty `lsof` result
alone cannot establish that an installed plugin or runtime is unused. Do not
uninstall a plugin, remove an active runtime, reset an app profile or interrupt
the current chat as a side effect of cache inspection. Any needed interruption
or reset must be within actual user authority; otherwise report that leaf blocked.

For Chromium/Electron-style profiles, distinguish HTTP/generated-code caches from
cookies, history, login data, preferences, IndexedDB, local/session storage,
service-worker storage, CacheStorage, blobs and artifact-session stores. Treat
the latter as persistent or unknown state, even beneath a directory named cache.
The Electron API distinguishes HTTP cache clearing from broader storage clearing,
and documents generated V8 code-cache behavior. This is supporting evidence about
the storage types, not proof that a particular Codex directory maps to that API.
[Electron session documentation](https://www.electronjs.org/docs/latest/api/session#sesclearcache).
Do not substitute an unrestricted storage clear or app-profile reset for a
cache-only cleanup.

Keep the cleanup driver and its receipts outside every approved target; a
running cleanup must not delete its own interpreter, loaded skill or evidence.
Retire only explicit, reviewed leaves or inactive generations after the normal
fresh preflight and authorization checks in
[approved removal](approved-removal.md). Reopening a chat or an app that needs
preserved state is a different proof from checking that a cache directory is gone.

## Report the Codex contribution

List measured Codex cache candidates separately from protected Codex state and
installed code. Give each leaf's classification, role, size, producer/regeneration
evidence, consumer evidence and decision. Unverified candidates are not counted
as confirmed disposable cache space. Record absent/inaccessible locations and
current layout uncertainty.
Report allocated files removed and actual net free-space change separately;
snapshot/clone behavior still applies. Never recommend deleting all of
`CODEX_HOME` or the whole Application Support directory to clear caches.
