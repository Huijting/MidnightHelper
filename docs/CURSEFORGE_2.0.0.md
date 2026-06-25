# CurseForge release 2.0.0 — copy/paste

**Upload:** `dist/MidnightHelper-2.0.0.zip` (build with `tools\package.ps1`).
**Description:** **bijwerken** — major redesign (4-kamer-navigatie) + volledige lokalisatie. Vermeld de 7 talen.

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.0.0** bovenaan. Test ook één niet-Engelse taal (`/mh lang de`) op de nieuwe nav/Launchpad/onboarding.

---

## Short summary (one line)

Midnight Helper 2.0 is a full navigation redesign — four rooms (Me, Codex, Tools, Settings), a global search bar with favourites, a breadcrumb, a Tools launchpad and adjustable text size — and the whole addon is now translated into 7 languages.

---

## Changelog — paste below (since 1.8.6)

### 2.0.0 — 2026-06-25

A major redesign of how you navigate Midnight Helper, plus full localization.

#### New

- **Four-room navigation** — the sidebar is reorganised into **Me, Codex, Tools and Settings**, each filtering the tabs to what fits the room you're in.
- **Global search bar** at the top: type a tab, tool or Codex topic and jump straight there, with a **favourites row (+)** for one-click returns.
- **Breadcrumb** in the title bar, and a **"Read in Codex"** button on tabs that have a matching Codex article.
- **Tools Launchpad** — open every floating helper window (Delve Coach, consumable board, dungeon boss window, curios advisor, ritual boss coach) from one place.
- **Adjustable content text size** (A- / A+) in Settings.
- **Gem advisor** alongside the enchant checker: flags empty sockets and suggests stat-matched gems for your spec.
- **Full localization** — the entire addon is now translated into **German, French, Spanish, Portuguese, Italian and Dutch** (alongside English), including a first-run onboarding tour for the new layout and a Warband Bank explainer in the Codex.

#### Changed

- **One settings home** — every option now lives in the in-addon Settings tab (Vault and Tabs as their own categories). Right-click the minimap icon or `/mh settings` opens it; the old Blizzard interface panel and quick-settings popup are retired.
- **The "after the reset" route auto-advances** — the arrow moves to the next open stop as you claim the Great Vault and pick up your weeklies.

#### Fixed

- The Info button now reflects the tab that's actually open.
- More rares show a 3D model preview.
- The profession trainer-weekly hint no longer mentions Enchanting on every profession.
- The treasure arrow now survives crossing continents.
- The Tools Launchpad now follows your chosen language.

---

## CF page description — suggested additions

Add to the existing description (or refresh the top):

> **Now in 7 languages** — English, Deutsch, Français, Español, Português, Italiano and Nederlands. Auto-selects on your WoW client language (Dutch via `/mh lang nl`).
>
> **Redesigned navigation (2.0)** — four rooms, a global search bar, favourites, breadcrumbs and a Tools launchpad.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-2.0.0.zip` |
| **Display version** | **2.0.0** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud (let op: `tools/` met scripts en `docs/` mogen er NIET in).
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden of `Locales/i18n_*`-werkbladen.
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` met Lua-errors aan — geen fouten bij login.
- In-game changelog-popup toont **2.0.0** bovenaan met de nieuwe regels.
- **Nav:** de vier kamers (Me/Codex/Tools/Settings) wisselen; zoekbalk springt naar tabs; favorieten-rij (+) werkt.
- **Talen:** `/mh lang de` (of fr/es/pt/it) → nav, Launchpad, onboarding en Codex zijn vertaald; `/mh lang nl` idem.
- **Settings:** rechtermuis op minimap-icoon → opent de Settings-tab; Vault- en Tabs-categorie aanwezig.
