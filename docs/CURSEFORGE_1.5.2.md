# CurseForge release 1.5.2 — copy/paste

**Live on CurseForge today:** 1.5.1 → upload **1.5.2**.

Upload `dist/MidnightHelper-1.5.2.zip`. **Description** unchanged unless you want edits — same as 1.5.1. **Changelog** below is the only required text update.

---

## Short summary (one line)

Hotfix: fixes Lua errors in delves when nameplate addons show aura tooltips (secret POI ID compare on 12.x).

---

## Changelog (release notes field) — paste on CF

### 1.5.2 — 2026-06-02

**Since 1.5.1**

#### Fixes

- **Delve story tooltip hook** no longer listens to **UnitAura** and other non-map tooltip types. Stops errors like `attempt to compare local 'poiId' (a secret number value)` in delves when **Platynator** (or similar) updates nameplate tooltips.
- Map **Area POI** story detection unchanged; POI IDs are validated with 12.x secret-value guards before compare.

---

## CurseForge upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.5.2.zip` |
| **Game version** | Retail — interface **120005** |
| **Release type** | **Release** |
| **Display version** | **1.5.2** |

### Build zip

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

### Post-upload

- [ ] **Changelog** = section above
- [ ] Smoke-test: delve + Platynator nameplates, `/reload`, no errors
- [ ] `/mh changelog` shows **1.5.2** at top
