# Delve Coach — handoff (live boss preview fix)

**Commit:** search git log for subject `Fix Delve Coach live boss 3D preview` (after push).

## Problem (what broke after multi-boss / story work)

- **Preview** (Delve Coach picker, open world): boss name + 3D model OK.
- **Live delve** after `/reload`: empty boss box, no name, no animation.
- Last **CurseForge** build (≈ `ef502b8`) worked in live delves.

## Root causes

1. **`ResolveDelveBossShowcaseIndex`** returned `nil` for multi-boss delves when story could not be resolved → entire boss panel hidden (no name, no model). Single-boss delves were less affected but model load still failed.
2. **Model API order** changed to `SetCreature` before `SetCreatureData`. In instances `SetCreature` often “succeeds” without a visible model; CF used **`SetCreatureData` first**.
3. **Gulkat creature ID**: CF used **256817**; a later change used only **251600**. Live vs preview may need both (primary + fallback).
4. **UIParent reparent** experiment for `PlayerModel` did not help; reverted — model stays child of `modelHost` in the coach panel.
5. **Syntax slip**: extra `end` in `ResolveDelveBossShowcaseIndex` (fixed before this commit).

## What we fixed (keep this behavior)

| Area | Fix |
|------|-----|
| `DelveBossShowcase.lua` | `SetCreatureData` → `SetCreature` → `SetDisplayInfo`; verify model via `GetModelFileID` / `GetCreatureID` |
| Gulkat | `256817` primary, `251600` in `creatureIdFallback` |
| Multi-boss | Never hide panel on unknown story; fall back to `GetDelveBossShowcaseIndex` (saved / manual `<` `>`) |
| `DelveCoach.lua` | Reverted UIParent model parenting; light retries in live delve only |
| Apply model | Full `ClearDelveBossCreatureModel` before load (CF behaviour) |

## Verified by user

- **The Darkway** live after `/reload`: boss spotlight + name + 3D works again.

## Next on laptop (TODO)

1. **Grudge Pit** live: story line + correct boss (Brightthorn / Gyrospore / Mycomight) — story detection still uses POI cache, criteria hints, `storyDaily` in saved vars. Creature IDs: Brightthorn `247397`, Mycomight `247526`, Gyrospore `247910`.
2. If wrong boss shows but model works: use **Boss `<` `>`** or fix `ResolveDelveStoryBoss` / `/mh debug` story signals — not the 3D loader.
3. **Collegiate / Gulf / Sunkiller**: multi-boss filtering in tips; Sunkiller may still return `nil` index for “Not What I Expected” (no final boss) — intentional.
4. Optional: CF release notes + version bump when packaging.

## Quick test checklist

- `/reload` inside delve vs preview from hub.
- Multi-boss delve before final boss: panel visible, name shown, model or loading/portrait fallback.
- Target boss → portrait fallback if 3D fails.

## Files touched in this fix

- `Modules/DelveBossShowcase.lua`
- `Modules/DelveCoach.lua`
