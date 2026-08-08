# CLAUDE.md — Midnight Helper

Guidance for Claude when working in this repository. Read this first every session.

## What this is

**Midnight Helper** is an all-in-one utility addon for **World of Warcraft Retail** (patch 12.0.7 "Midnight", interface `120007`), written in **Lua**. It covers weekly planning, Delves, Great Vault, achievement hunts, a live class-layout coach, on-screen combat helpers, standalone route guidance, and reference guides — localized in 7 languages.

The maintainer (**Rob**) is a non-developer but tests every change in-game. A second tester (**Cisca**) is used for big changes.

## How to work with Rob (important)

- **Respond in Dutch, concise and direct.** Minimal fluff.
- **Never-lie / verify, don't guess.** Never invent spell IDs, coordinates, texcoords, API names or achievement criteria. Prefer "I don't know, let's check" over a plausible guess. Rob/Cisca confirm in-game.
  - ⚠️ **The other installed addons are a place to find CANDIDATES, never proof.** They go stale, they guard calls behind `if`, and they contain combat-log samples full of monsters' spell IDs. On 8 Aug 2026 `LEARNED_SPELL_IN_TAB` was registered because the name appeared four times across them; 12.x threw "Attempt to register unknown event" on the next reload. The same night, grepping for "Arcane Explosion" produced 22271 — a Blackwing Mage's version of it.
  - **Ask the client instead.** Write the answer to `ns.db.<something>`, have Rob `/reload`, then read the SavedVariables file. `scannedIds` in the automap dump and `/mh events` exist for exactly this. Wowhead (12.0.7) and the official API wiki are fine for candidates too — the client settles it.
- **Rob's in-game `/reload` is the final syntax check.** Do a static check too where possible (see Build & verify), but assume Rob will reload and report errors.
- **Git & CurseForge are Rob's job.** Provide the exact commands + checklist, but do not push releases or trigger uploads unless Rob explicitly says to run them. (In Claude Code you *can* run git with permission — still confirm with Rob before commit/push/tag on a release.)
- **Version bumps & releases only when Rob says "af"/"go".** Don't bump the version or write release docs pre-emptively.
- **Big releases: consider Beta-first on CurseForge** (Cisca-test) before Release — Rob decides.

## Build & verify

- **Syntax check Lua** before handing off. If `luacheck` or `luac` is available, use it; otherwise a Lua parser. Rob's `/reload` is the final word.
- **Package for CurseForge:** `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist\MidnightHelper-<version>.zip` (reads version from the `.toc`). The script **fails the build** if any `.bat`/`.cmd`/`.ps1`/`.py`/`.exe` slips into the zip. Zip root must be exactly `MidnightHelper/`; `tools/`, `data/`, `docs/` and dev markdown are excluded.
- See `RELEASE_CHECKLIST.md` for the full release flow.
- ⚠️ **The repo IS the live AddOns folder.** There is no sync script and no staging copy — every
  edit lands in Rob's running game immediately. (This file used to claim they were separate; that
  was wrong, and the mistake below is what it cost.)
- ⚠️ **Write files ATOMICALLY.** A plain `open(path, "w")` truncates first and writes after, so
  there is a window where the file on disk is empty or half-finished. On 2026-07-22 Rob logged in
  during exactly that window while `Locales/enUS.lua` was being rewritten: the locale table broke
  off mid-file and his Great Vault popup rendered raw keys (`VAULT_REMINDER_POPUP_TITLE`). Nothing
  was wrong with the addon. Always write to a temp file and rename — `os.replace` is atomic, so the
  game sees either the old file or the new one, never something in between:
  ```python
  io.open(p + ".tmp", "w", encoding="utf-8", newline="").write(t)
  os.replace(p + ".tmp", p)
  ```
  The Write/Edit tools are fine; this applies to scripted rewrites.

## Layout

- `MidnightHelper.toc` — load order + metadata (`## Version`, `## Interface 120007`). Adding a module = add its file here.
- `Core.lua`, `UI.lua`, `Config.lua` — bootstrap, main window, config.
- `Modules/` — one file per feature (e.g. `NativeArrow.lua`, `MissingBuff.lua`, `Openables.lua`, `FastMark.lua`, `KeyboardLayoutPrototype.lua`, `KeybindAutoMap.lua`, `KeybindRoles_*.lua`, `Achievements.lua`, `Delves.lua`, `Changelog.lua`, `SettingsPage.lua`).
- `Locales/` — one pack per language + the resolver + a fill-file (see Localization).
- `docs/` — dev notes, per-release CurseForge notes (`CURSEFORGE_<version>.md`), plans, handoffs. `docs/NEXT_SESSION.md` is the running state/handoff log — read it for current context.

## Key systems & conventions

### Localization (`ns:L`)
- `ns:L(key)` resolves against the active pack and **falls back to `enUS`** if a key is missing — so a missing translation shows English, never a raw key. Nothing is "broken" if only `enUS` has a key.
- Language packs: `Locales/<code>.lua` (`enUS`, `deDE`, `frFR`, `esES`, `ptBR`, `itIT`, `nlNL`) register into `ns._mhLocales[code]`. Settings-page strings live in `Locales/SettingsPage.lua`.
- `Locales/Translations2026.lua` is a **fill-only merge** (`fill(code, patch)` sets a key only if the pack lacks it) that adds post-2025 translations for **de/fr/es/pt/it**. Add new translations here — it never overwrites existing ones.
- **Workflow for a new user-facing string:** add it to `enUS.lua` (and `nlNL.lua`), then add translations to the other 5 via `Translations2026.lua`. `nlNL` is manual-only (never auto-selected). `CHANGELOG_*` keys stay **English** on purpose (fallback).

### Route arrow / navigation (`Modules/NativeArrow.lua`)
- A shared on-screen arrow + Blizzard user-waypoint driver for every route type.
- **Ownership convention:** a route claims the arrow with `ns._mhRouteOwner = "<type>"` (`rare`/`treasure`/`achievement`/`reset`) and sets it to `nil` **only when the route is truly finished — never on a zone change**.
- **Never couple arrow lifetime to `ns.lastTarget` alone** — several modules nil `ns.lastTarget` in zone handlers, which used to kill the arrow. NativeArrow caches its own `activeLead` and keys off the stable `_mhRouteOwner`. Modules that nil `ns.lastTarget` expose `ns.GetNearestIncomplete<X>Lead()` for the arrow to follow.
- Per-content icon/colour comes from an `OWNER_STYLE` table. If **TomTom** is driving, our arrow stays idle — its crazy arrow is the same kind of thing as ours. Otherwise **we draw**, including alongside WaypointUI.
- ⚠️ **Changed 5 Aug 2026.** We used to stand down for **WaypointUI** too, which quietly cancelled the route arrow for everyone who has that addon — most of Rob's testers. `/mh arrow` on his own machine, with TomTom off, read "wij sturen: ja / onze pijl getekend: nee". A feature a release announced and that silently never appears is worse than two indicators, and the two are not even the same: WaypointUI draws a pin at a place, ours gives a direction, a distance and the next stop's name. Restore the old behaviour per player with `/mh arrow yield`.
- **`/mh arrow`** prints who is driving and whether a route ever published a target. Use it before debugging a "the arrow does not work" report: standing down on purpose and being genuinely broken look identical from outside.

### Secure frames (WoW 12.x — read before touching markers/casting UI)
- Since patch 12.0, `SetRaidTarget` and `PlaceRaidMarker` are **protected**. Set raid target icons via a secure button `type="macro"`, `macrotext="/tm N"` (N=1–8, 0=clear); world markers via `type="worldmarker"`, `marker=N`, `action="set"/"clear"`. (See `FastMark.lua`.)
- A `SecureActionButtonTemplate` can only be re-anchored to its own parent or `UIParent`. A frame that **parents** a secure button (or is anchored-to by one) becomes **protected** and cannot be re-anchored/shown/hidden **in combat**; protection propagates up the parent chain.
- The clickable-in-combat pattern (see `MissingBuff.lua`): a separate non-secure visual frame stays visible; a secure button parented to `UIParent`, positioned independently out of combat, with `RegisterStateDriver(btn, "visibility", "[combat] hide; nil")`, strata `DIALOG`, `RegisterForClicks("AnyUp","AnyDown")`, and **cast by spell-ID** (names break on renamed pets).
- Draggable bars that parent secure buttons: only move/show/hide them **out of combat** (guard with `InCombatLockdown()`; defer to `PLAYER_REGEN_ENABLED`).

### 12.x "secret values"
- Other units' aura `spellId`/tooltip `leftText` can be secret. Guard with `issecretvalue()` before comparing/using.

### In-game changelog
- `Modules/Changelog.lua` holds `CHANGELOG_ENTRIES` (newest first: `{ version = "x.y.z", lines = { "CHANGELOG_XYZ_1", ... } }`), with the line texts as `CHANGELOG_<ver>_N` keys in `enUS.lua` (English only).

### Release artifacts (keep in sync on a version bump)
- `MidnightHelper.toc` `## Version`
- `Modules/Changelog.lua` + `CHANGELOG_<ver>_*` in `enUS.lua` (**enUS only** — the in-game changelog has been English-only since 2.4.0)
- `RELEASE_NOTES.md` (repo root) — **the CurseForge release notes**. The packager uploads it *verbatim* (`.pkgmeta` → `manual-changelog`, `markup-type: markdown`), so it must hold **only the current release**, pure Markdown starting with a plain `# heading`, and stay identical to `docs/CURSEFORGE_<ver>.md`.
  - ⭐ **KEEP IT SHORT — under ~40 lines and without bullet lists.** For months the auto-upload arrived backslash-escaped with its newlines collapsed (`\## Know your role`) and Rob had to paste it by hand every release. Four releases settled it:

    | Release | Lines | Chars | Bullets | Auto-upload |
    |---|---|---|---|---|
    | 2.8.2 | 65 | 3164 | 9 | ❌ mangled |
    | 2.8.3 | 30 | 1433 | 1 | ✅ clean |
    | 2.8.4 | 55 | 2775 | 6 | ❌ mangled |
    | 2.9.0 | 38 | 1785 | 0 | ✅ clean |
    | 2.11.1 | 22 | 1110 | 0 | ✅ clean |
    | 2.12.0 | 37 | 1652 | 0 | ✅ clean |
    | 2.13.0 | 39 | 1937 | 0 | ✅ clean |

    Short and plain uploads clean; long and bullet-heavy does not. **Seven for seven** now, Rob confirming each on the page itself — 2.13.0 on 6 Aug 2026, at 39 lines the longest of the clean ones. That last one narrows it: 2.8.4 was mangled at 55 lines with 6 bullets, and 39 lines with 0 bullets is fine, so line count alone is not the trigger. Bullets remain the strongest single suspect, but no clean upload has ever carried one, so nothing separates "no bullets" from "short and plain" yet. Still a reliable rule rather than a diagnosis. Put the long prose in `docs/CURSEFORGE_<ver>.md` if you want it.
  - **Earlier theories, all DISPROVEN — do not revive them.** HTML in the file (2.7.0), then a leading `<!-- HTML comment -->` (2.8.0), then "pure Markdown fixes it" (2.8.1, still mangled at 60+ lines). Rob also pasted the *identical* source into CF's own editor and it rendered perfectly, which puts the fault in the upload path, not the file's contents.
  - If a release still arrives wrong: CF page → the file → Changelog → Markdown mode → paste `docs/CURSEFORGE_<ver>.md`. And if a SHORT file ever arrives mangled, this rule is dead — the next lead is the floating `BigWigsMods/packager@v2` tag in `.github/workflows/release.yml`, since 2.6.0 rendered clean and something may have changed underneath us.
- `CHANGELOG.md` (full history)
- `docs/CURSEFORGE_<ver>.md` (per-version Markdown archive, paste-ready if the CF page needs fixing by hand)
- `CURSEFORGE_DESCRIPTION.md` (repo root — the **canonical** CF page description; there is only this one). The packager does **not** upload this; Rob pastes it.

Full procedure: `docs/RELEASE_CHECKLIST.md`.

## Gotchas

- Some older files use **CRLF** line endings; keep them consistent when editing.
- Match the existing indentation style (tabs) in Lua files.
- Don't reintroduce library dependencies that were deliberately removed (e.g. borrowed `HereBeDragons`); prefer the game's own `C_Map` world coordinates.
