# CurseForge release 1.3.2 — copy/paste

**Live on CurseForge today:** 1.3.0 → upload **1.3.2** (skips unpublished 1.3.1).

Upload `dist/MidnightHelper-1.3.2.zip`. Refresh project **Description** from `CURSEFORGE_DESCRIPTION.md`. Add **3+ screenshots** (main window in DE or FR, Delve Coach, delve items or curio advisor).

---

## Short summary (one line)

Since 1.3.0: six languages (EN DE FR ES PT NL), Valeera curio advisor, delve consumables polish, leveling In groups + SMC checklist.

---

## Changelog (release notes field) — paste on CF

### 1.3.2 — 2026-05-23

**Since the last CurseForge release (1.3.0)**

#### Localization (new)

- Full UI and guide content in **English, Deutsch, Français, Español, Português (BR), and Nederlands**.
- **`/mh lang auto`** uses your WoW client language when supported; **`/mh lang nl`** for Dutch (not auto-selected).
- Delve Coach tips, Leveling Guides advisor/gear, consumable notes, and guide groups translated for all six packs (previously EN/NL only on CF 1.3.0).

#### New features

- **Valeera curio advisor** (Delves tab + repair/gossip popup).
- **Delve consumables** — session tracking, `/mh items mark` / `reset`, stable secure item buttons in delves.
- **Bounty toast** for Trovehunter's Bounty when relevant.
- Leveling Guides **In groups** tab (interrupts, defensives, party tips by role).
- Leveling Guides **Layout** tab (keyboard prototype).
- **SMC City Guide** weekly checklist (configurable quest IDs).

#### Fixes

- Delve consumables popup: no Lua errors; Midnight-safe tracking (no forbidden combat-log registration).

---

## Post-upload

- [ ] **About** text = `CURSEFORGE_DESCRIPTION.md` (feature list, not a patch diary)
- [ ] **Changelog** = section above (this *is* where languages belong)
- [ ] Interface `120005`, type **Release**
- [ ] Smoke-test zip on clean AddOns folder
