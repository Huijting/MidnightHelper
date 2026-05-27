# CurseForge release 1.4.0 — copy/paste

**Live on CurseForge today:** 1.3.2 → upload **1.4.0**.

Upload `dist/MidnightHelper-1.4.0.zip`. Refresh project **Description** from `CURSEFORGE_DESCRIPTION.md`. Add **3+ screenshots** (Great Vault Advisor panel, beta sidebar block, settings with beta toggles).

---

## Short summary (one line)

Since 1.3.2: Great Vault Advisor on the Blizzard vault screen, beta sidebar tabs (Guide, Leveling Guides, Macros, Role Academy) with per-tab settings, vault reminder options.

---

## Changelog (release notes field) — paste on CF

### 1.4.0 — 2026-05-27

**Since the last CurseForge release (1.3.2)**

#### Great Vault Advisor (new)

- Side panel on Blizzard’s **Great Vault** loot screen ranks vault choices vs. your equipped gear (item level, guide stat weights, tier sets).
- **Auto / Raid / M+** stat profiles; optional **Pawn** integration.
- Settings in **Esc → AddOns → Midnight Helper** (all six UI languages).

#### Beta sidebar tabs (new)

- **Beta** tab block between Professions and Consumables: **Guide**, **Leveling Guides**, **Macros**, **Role Academy** (Beta badges + tooltips).
- Master switch and per-tab toggles in addon settings.

#### Vault reminders

- Chat summary, minimap ping, and login popup options in settings.

#### Fixes

- Beta tab settings no longer throw Lua errors when toggling checkboxes.

---

## Post-upload

- [ ] **About** text = `CURSEFORGE_DESCRIPTION.md` (feature list, not a patch diary)
- [ ] **Changelog** = section above (this *is* where patch details belong)
- [ ] Interface `120005`, type **Release**
- [ ] Smoke-test zip on clean AddOns folder
