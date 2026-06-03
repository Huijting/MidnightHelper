# CurseForge release 1.5.2 — copy/paste

**Gebruik voor upload na 1.5.0:** volledige changelog **1.5.0 → 1.5.2** staat in **`docs/CURSEFORGE_1.5.2_FROM_1.5.0.md`** (1.5.1 + 1.5.2 gecombineerd).

Onderstaand is alleen de **1.5.1 → 1.5.2** hotfix-tekst (niet gebruiken als CF nog op 1.5.0 staat).

---

## Short summary (one line)

Hotfix: fixes Lua errors in delves when nameplate addons show aura tooltips (secret POI ID compare on 12.x).

---

## Changelog (release notes field) — paste on CF

### 1.5.2 — 2026-06-02

**Since 1.5.1** *(alleen als 1.5.1 al live was)*

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
