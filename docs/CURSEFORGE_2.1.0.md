# CurseForge release 2.1.0 — copy/paste

**Upload:** `dist/MidnightHelper-2.1.0.zip` (build with `tools\package.ps1`).
**Description:** **bijwerken** — nieuwe Achievements-tab (treasures, peaks, lore, rare-hunters) met routing, renown + collectibles, en de Light Up the Night-meta.

> ⚠️ **Vóór upload:** in-game `/reload`-test met Lua-errors aan — geen fout bij login, changelog-popup toont **2.1.0** bovenaan. Open de **Achievements-tab** (Me-kamer): kaarten tonen progress, Route werkt, checklist klapt uit met hover-tooltips, en de overzichtsregel klopt. Test ook op een **lager-level alt** (geen `ADDON_ACTION_BLOCKED` meer bij login — de StaticPopupDialogs-taintfix).

---

## Short summary (one line)

Midnight Helper 2.1 adds a full **Achievements tab** — track Treasures, The Highest Peaks, Midnight Lore Hunter and every zone's rare hunters across all four Midnight zones, with live progress, one-click TomTom routing, per-card renown + collectible status, and a Light Up the Night meta summary toward the Brilliant Petalwing mount.

---

## Changelog — paste below (since 2.0.0)

### 2.1.0 — 2026-06-30

A new Achievements tab for Midnight's collectible hunts.

#### New

- **Achievements tab** (Me room) — track the **Treasures, The Highest Peaks (telescopes), Midnight Lore Hunter** and the **zone rare-hunter** achievements across Eversong Woods, Zul'Aman, Harandar and Voidstorm, with live per-node progress and **one-click TomTom routing** to whatever you still miss. The arrow auto-advances as you loot or kill, and survives crossing zones, sub-areas and portals.
- **Rare hunters** — every zone's rares (A Bloody Song, Tallest Tree in the Forest, Leaf None Behind, The Ultimate Predator) as a routable checklist, verified against the in-game achievement criteria.
- **Per-card renown and collectible** — each card shows the faction renown the achievement feeds (with your current renown level) and its completion reward — pet, mount or toy — with a collected check read live from your journals.
- **Expandable checklists** with a Waypoint button and a how-to tooltip on every row, plus a step-by-step hint toast for the multi-step treasures.
- **Tab summary** — achievements done, collectibles owned, and live progress on the **Light Up the Night** meta toward the **Brilliant Petalwing** mount.
- **Route nearest open** — one button sends the arrow to the closest objective you still need across every tracked achievement.
- **Sorting & hiding** — open achievements sort to the top, completed ones to the bottom; hide finished or unwanted ones from Settings > Tabs or the "all done — hide it?" prompt.
- **Shift-click** a card to link the achievement in chat; **Ctrl-click** to open Blizzard's achievement panel.

#### Fixed

- Removed a taint vector (reassigning the `StaticPopupDialogs` global) that could block Blizzard's spellbook from opening on lower-level alts.

---

## CF page description — suggested additions

Add to the existing description (or refresh the top):

> **New in 2.1 — Achievements tab.** Track Midnight's collectible hunts (treasures, telescopes, lore objects and zone rares) with live progress and one-click TomTom routing, per-card renown + collectible status, and a Light Up the Night summary toward the Brilliant Petalwing mount.

---

## Upload checklist

| Field | Value |
|-------|--------|
| **File** | `dist/MidnightHelper-2.1.0.zip` |
| **Display version** | **2.1.0** |
| **Game version** | Retail — interface **120007** (12.0.7) |
| **Release type** | **Release** |

```powershell
powershell -ExecutionPolicy Bypass -File tools\package.ps1
```

**CF-regels:**

- Geen `.bat` / `.cmd` / `.ps1` / `.py` / `.exe` in de zip; controleer de zip-inhoud (`tools/` met scripts en `docs/` mogen er NIET in).
- Zip-root = exact `MidnightHelper/`; geen docs/tools/dev-bestanden of `Locales/i18n_*`-werkbladen.
- Changelog hierboven plakken; juiste game version + release type kiezen.

### Test (na upload, schone AddOns-map)

- `/reload` met Lua-errors aan — geen fouten bij login, ook niet op een lager-level alt.
- In-game changelog-popup toont **2.1.0** bovenaan met de nieuwe regels.
- **Achievements-tab:** 4 zones × treasures/peaks + lore + rares verschijnen als kaarten; progress klopt; **Route** zet de pijl; checklist klapt uit met per-rij Waypoint + hover-tooltip; **Route dichtstbijzijnde open** werkt.
- **Overzichtsregel:** achievements X/Y · collectibles N/M · Light Up the Night A/B (reward: Brilliant Petalwing) — vinkjes kloppen.
- **Renown/collectible-regel** per kaart toont de juiste factie + level en de collectible-status.
- **Settings > Tabs:** per-achievement zichtbaarheid + "voltooide automatisch verbergen" werken; verbergen/sorteren klopt.
- **Talen:** `/mh lang nl` (of de/fr/es/pt/it) → tab-chrome, summary, knoppen en tooltips vertaald (achievement- en collectible-namen komen live uit de API).
