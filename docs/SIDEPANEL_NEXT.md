# Side panels — fixes to apply to the remaining modules

`Modules/SidePanel.lua` (the shared helper) and `Modules/KeystoneSidePanel.lua` are
built. The handoff also contained `MountJournalSidePanel.lua` and
`EncounterJournalSidePanel.lua`. **Do not paste those in as-is** — repo checks on
2026-07-21 turned up three problems.

## 1. Encounter Journal index misses 14 of 57 bosses (HARD)

The handoff's `BuildIndex()` reads only `b.encounterID`:

```lua
AddEntry(b.encounterID, d.key, b)
```

But `ns.DUNGEON_ROSTER` stores ids in two fields, and **14 of its 57 boss rows carry
only `dungeonEncounterID`** (measured, not estimated) — the whole Blinding Vale,
Sentinel of Winter, Lightwarden Ruia and others. Those would silently never match and
the panel would stay blank for them.

The irony is worth keeping: the handoff has a section warning about exactly these two
id spaces, and then indexes one of them. Fix:

```lua
AddEntry(b.encounterID, d.key, b)
AddEntry(b.dungeonEncounterID, d.key, b)
```

`AddEntry` already type-checks and does not overwrite, so adding the second call is safe.

## 2. Mount panel anchors to an inner frame (likely wrong position)

The handoff anchors to `MountJournal`. That is a tab *inside* `CollectionsJournal` —
BlizzMove treats `CollectionsJournal` as the top-level movable frame and does not list
`MountJournal` at all (BlizzMove/Frames.lua:830). Anchoring `TOPRIGHT` of an inner
frame puts the panel inside the collections window rather than beside it.

Anchor to `CollectionsJournal`, keep `MountJournal` only as the "is the mount tab
actually showing?" test. Confirm in-game — three seconds with the window open.

## 3. Two functions the handoff calls do not exist

- **`ns.OpenCodexEntry`** — used by the crafting-Codex NavSearch snippet. Check how the
  existing Codex rows in `NavSearch.lua` open an entry and copy that instead.
- **`ns.GetMidnightUnspentKnowledge`** — Spec 22 states this already exists and reads
  KP dynamically via `C_ProfSpecs`/`C_Traits`. It does not. Spec 22's "the data
  plumbing is already good" premise is therefore wrong: that part still has to be
  built, and the API needs verifying first.

## Verified, no action needed

- `GetMythicGainSteps` / `PrintMythicGain` / `GetWishlistSummary` (returns `have, total`
  as assumed) / `GetMountWishlistSteps` / `ShowDungeonBossWindow(dungeonKey, bossKey)` /
  `ns:SafeL` / `ApplyMidnightDialogBackdrop` / `GetContentFontScale` / `MHScalableFont`
- `MOUNTWISH_HEADER` / `MOUNTWISH_SUMMARY_FMT` / `MOUNTWISH_EMPTY` already exist
- Step shape `{ text=, color= }` with `prog`/`good` matches the helper's COLORS table
- `ChallengesKeystoneFrame` + `Blizzard_ChallengesUI` confirmed via BlizzMove,
  EllesmereUIQoL and BossHelper — no in-game dump needed
- The "proven pattern" claim holds: VaultAdvisor really does parent to UIParent and
  guard with `_mhVaultAdvisorHook`. (DelveCuriosAdvisor is a *centred popup*, not a side
  panel — same taint posture, different anchoring.)
