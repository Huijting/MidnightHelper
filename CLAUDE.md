# CLAUDE.md — Midnight Helper

Guidance for Claude when working in this repository. Read this first every session.

## What this is

**Midnight Helper** is an all-in-one utility addon for **World of Warcraft Retail** (patch 12.0.7 "Midnight", interface `120007`), written in **Lua**. It covers weekly planning, Delves, Great Vault, achievement hunts, a live class-layout coach, on-screen combat helpers, standalone route guidance, and reference guides — localized in 7 languages.

The maintainer (**Rob**) is a non-developer but tests every change in-game. A second tester (**Cisca**) is used for big changes.

## How to work with Rob (important)

- **Respond in Dutch, concise and direct.** Minimal fluff.
- **Never-lie / verify, don't guess.** Never invent spell IDs, coordinates, texcoords, API names or achievement criteria. Verify via: Wowhead (12.0.7), in-game macro dump, cross-check against installed addons, or the official WoW API wiki. Prefer "I don't know, let's check" over a plausible guess. Rob/Cisca confirm in-game.
- **Rob's in-game `/reload` is the final syntax check.** Do a static check too where possible (see Build & verify), but assume Rob will reload and report errors.
- **Git & CurseForge are Rob's job.** Provide the exact commands + checklist, but do not push releases or trigger uploads unless Rob explicitly says to run them. (In Claude Code you *can* run git with permission — still confirm with Rob before commit/push/tag on a release.)
- **Version bumps & releases only when Rob says "af"/"go".** Don't bump the version or write release docs pre-emptively.
- **Big releases: consider Beta-first on CurseForge** (Cisca-test) before Release — Rob decides.

## Build & verify

- **Syntax check Lua** before handing off. If `luacheck` or `luac` is available, use it; otherwise a Lua parser. Rob's `/reload` is the final word.
- **Package for CurseForge:** `powershell -ExecutionPolicy Bypass -File tools\package.ps1` → `dist\MidnightHelper-<version>.zip` (reads version from the `.toc`). The script **fails the build** if any `.bat`/`.cmd`/`.ps1`/`.py`/`.exe` slips into the zip. Zip root must be exactly `MidnightHelper/`; `tools/`, `data/`, `docs/` and dev markdown are excluded.
- See `RELEASE_CHECKLIST.md` for the full release flow.
- Note: the live WoW AddOns folder and the git repo are **separate**, synced by a script. In Claude Code, work in the git repo.

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
- Per-content icon/colour comes from an `OWNER_STYLE` table. If **WaypointUI** is installed the arrow stands down (its pin drives); if **TomTom** is driving, it stays idle; with neither, our arrow guides.

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
- `RELEASE_NOTES.html` (repo root) — **the CurseForge release notes**. The packager uploads it *verbatim* (`.pkgmeta` → `manual-changelog`), so it must hold **only the current release**, and any maintainer note must sit inside an `<!-- HTML comment -->` or it renders on the public page. **HTML, not Markdown**: CF's changelog field is a WYSIWYG box and printed our Markdown source literally at 2.6.0; HTML renders correctly whether the field is WYSIWYG/HTML or Markdown.
- `CHANGELOG.md` (full history)
- `docs/CURSEFORGE_<ver>.md` (per-version Markdown archive, paste-ready if the CF page needs fixing by hand)
- `CURSEFORGE_DESCRIPTION.md` (repo root — the **canonical** CF page description; there is only this one). The packager does **not** upload this; Rob pastes it.

Full procedure: `docs/RELEASE_CHECKLIST.md`.

## Gotchas

- Some older files use **CRLF** line endings; keep them consistent when editing.
- Match the existing indentation style (tabs) in Lua files.
- Don't reintroduce library dependencies that were deliberately removed (e.g. borrowed `HereBeDragons`); prefer the game's own `C_Map` world coordinates.
