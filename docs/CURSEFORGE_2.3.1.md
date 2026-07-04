# CurseForge release 2.3.1 — copy/paste

**Upload:** `dist/MidnightHelper-2.3.1.zip` (build with `tools\package.ps1`).
**Release type:** **Release** (small hotfix — no Beta needed).
**Game version:** Retail 12.0.7 (interface 120007).
**Description:** no change needed (`CURSEFORGE_DESCRIPTION.md` stays as-is).

> ⚠️ **Vóór upload:** in-game `/reload` met Lua-errors aan → changelog-popup toont **2.3.1** bovenaan.
> Ga een gevecht/ritual in en bevestig dat de `ADDON_ACTION_BLOCKED`-fout **weg** is, en dat
> Missing Buff klik-om-te-casten (buiten combat) nog werkt (bv. Hunter pet / Mage Arcane Intellect).

---

## Short summary (one line)

Midnight Helper 2.3.1 fixes a combat error introduced in 2.3.0 where the Missing Buff reminder could spam a blocked-action error when a buff dropped or was reapplied mid-fight.

---

## Changelog — paste below (since 2.3.0)

### 2.3.1 — 2026-07-04

Hotfix for a combat error introduced in 2.3.0.

**Fixed**

- **Missing Buff reminder no longer throws a blocked-action error in combat.** When a maintainable
  buff dropped or was reapplied mid-fight (for example on entering a ritual), the reminder tried to
  hide/show its icon while that icon was treated as "protected" — producing an `ADDON_ACTION_BLOCKED`
  error (and repeated spam). The click-to-cast button is now positioned independently of the reminder
  icon instead of being anchored to it, so the icon is never protected and can hide/show freely during
  combat. Click-to-cast (out of combat) still works exactly as before.
