# CurseForge release 1.5.3 — copy/paste

**Upload:** `dist/MidnightHelper-1.5.3.zip` (build with `tools\package.ps1`).

**Als CF nog op 1.5.0 staat:** gebruik **`docs/CURSEFORGE_1.5.3_FROM_1.5.0.md`** (alles in één changelog).

**Als CF al 1.5.2 heeft:** plak alleen het **Hotfix**-blok hieronder.

---

## Short summary (one line)

Hotfix: world boss weekly status resets correctly after reset day; login cache error fixed; safe CurseForge packaging (no .bat in zip).

---

## Changelog — hotfix only (since 1.5.2)

### 1.5.3 — 2026-06-03

**Since 1.5.2**

#### Fixes

- **World boss** on Home / Delves: no longer shows “defeated this week” from **last week's** kill after the weekly reset.
- **World boss:** fixed `attempt to call a nil value` on login when refreshing SMC / Home shortcuts.
- **CurseForge zip:** dev sync `.bat` and scripts are excluded from the release package (build validation).

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-1.5.3.zip` |
| **Display version** | **1.5.3** |
| **Game version** | Retail — interface **120005** |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

### Test

- `/reload` — no Lua errors on login.
- **Home** after reset day — world boss not “done” unless you killed it this week.
- Delve + Platynator — no secret `poiId` errors (1.5.2 fix, still included).
