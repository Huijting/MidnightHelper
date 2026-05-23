# i18n roadmap — Midnight Helper

**Laatste update:** 2026-05-23  
**Versie op schijf:** `MidnightHelper.toc` → **1.3.1**  
**Git:** na commit `i18n Phase A+B` — DE shell + auto-locale live in repo

Dit document is de **vaste draad** voor vertalingen. Chatgeschiedenis sync niet tussen PC’s — start een nieuwe Agent met `@docs/I18N_ROADMAP.md` en `@docs/NEXT_SESSION.md`.

---

## Wat er nu in de addon zit

| Fase | Status | Beschrijving |
|------|--------|--------------|
| **A — Auto-locale** | ✅ Done | `locale = "auto"` volgt `GetLocale()`; `nlNL` nooit auto; fallback `enUS` |
| **B — deDE shell** | ✅ Done | `Locales/deDE.lua` (~546 UI-keys); merge uit `enUS` voor rest |
| **C — deDE inhoud** | 🔲 Open | Delve Coach tip bodies, `GUIDE_ADVISOR_*`, per-spec `GUIDE_GEAR_*` |
| **D — frFR shell** | ✅ Done | `Locales/frFR.lua` + `GROUP_FR`; Blizzard: **Gouffre** / **Grande chambre forte** |
| **D2 — frFR polish** | 🔲 Open | Advisor/gear EN; Delve tip bodies EN; resterende vous-vorm UI |
| **DE polish** | 🟡 Deels | Academy/INFO **du**; `TAB_DELVES` → **Tiefen & Große Schatzkammer** |
| **E — esES shell** | ✅ Done | `Locales/esES.lua` + `GROUP_ES`; Blizzard: **Profundidades** / **Gran Bóveda** |
| **E2 — esES polish** | 🔲 Open | Advisor/gear EN; resterende machinevertaling UI |
| **F — ptBR / …** | 🔲 Later | Per prioriteit CurseForge / spelersbasis |

### Locale-packs geladen (TOC-volgorde)

```
enUS.lua → deDE.lua → frFR.lua → esES.lua → nlNL.lua → GuideTips → GuideGroups → DelveTips → Locale.lua
```

### Handmatig vs automatisch

| Code | Auto bij WoW-client? | Opmerking |
|------|----------------------|-----------|
| `enUS` | ja (EN/EN-GB) | Default + fallback |
| `deDE` | ja | UI shell DE; advisor/tips deels EN |
| `nlNL` | **nee** | Altijd handmatig (`/mh lang nl` of knop) |
| `frFR` | ja | UI shell FR; advisor/tips deels EN |
| `esES` | ja | UI shell ES; advisor/gear deels EN |
| `esMX`, … | nee (tot pack bestaat) | Auto → EN + status “pack pending” |

### Commando’s

```text
/mh lang auto   — WoW-clienttaal (als pack bestaat)
/mh lang en     — Engels
/mh lang de     — Deutsch
/mh lang fr     — Français
/mh lang es     — Español
/mh lang nl     — Nederlands (addon)
```

Minimap → Instellingen → knoppen **Automatisch / English / Deutsch / Français** (rij 1) en **Español / Nederlands** (rij 2).

---

## Phase B — Duits (`deDE`) — detail

### Wat wél Duits is

- Volledige **UI-shell** (tabs, settings, account snapshot, delve-knoppen, macros, academy, …)
- **`GuideGroups`** — tab “In Gruppen” + groepsadvies (DE)
- Korte **filter/sort-knoppen** + dynamische breedte (`AltOverview.lua`, `Delves.lua`)

### Wat nog Engels blijft (bewust)

- `GUIDE_ADVISOR_*` — honderden per-spec leveling-regels
- `GUIDE_GEAR_MAGE_*`, `GUIDE_GEAR_DK_*`, … — per-spec gear overrides
- **Delve Coach tip bodies** — alleen in `DelveTips.lua` voor `enUS` + `nlNL` (DE krijgt EN-fallback via `ns:L`)

### Blizzard-termen (DE) — gebruik deze, niet machinevertaling

| Engels | Duits (Blizzard) | Niet gebruiken |
|--------|------------------|----------------|
| Delve(s) | **Tiefe / Tiefen** | Tauchplatz, Tauchgang |
| Bountiful Delve | **großzügige Tiefe** | großzügiger Tauchplatz |
| Great Vault | **Große Schatzkammer** | Tresor, Gewölbe, Great Vault |
| Raids | **Schlachtzüge** | Überfälle |
| Restored Coffer Key | **Restaurierter Kastenschlüssel** | Kassettenschlüssel |
| Delver's Journey | **Reise des Tiefenforschers** | Delvers Reise |
| Adventure Guide | **Abenteuerführer** | — |
| Delve tier | **Stufe** | Tier (ok in UI als “Tier” soms EN) |

**Engels laten in UI (zoals NL-pack):** Keys, Shards, Undercoins, ilvl, RAID-R Mini, TomTom, veel itemnamen.

### Bekende DE-polish (backlog)

- [ ] **Sie → du** en formele zinnen (veel Academy/Info-teksten nog “Sie”)
- [ ] `TAB_DELVES` → optioneel `Tiefen & Schatzkammer`
- [ ] Delve tooltip regel **“Bountiful”** hardcoded in `Delves.lua` → locale key
- [ ] `DelveTips.lua` merge-blok voor `deDE` (minimaal `DELVE_NAME_*`)

### Generator (opnieuw bouwen deDE)

```powershell
cd Interface\AddOns\MidnightHelper
pip install deep-translator   # eenmalig
python tools/build_deDE.py      # ~8 min; overschrijft Locales/deDE.lua
```

Daarna **handmatig** `tools/build_deDE.py` → dict `fixes` controleren (Blizzard-termen).  
**Niet committen:** `tools/_guide_groups_de.lua` (tijdelijke snippet).

---

## Phase D — Frans (`frFR`) — plan voor volgende sessie

1. Kopieer patroon `deDE.lua` (merge + `OVERRIDES`)
2. `Locales/frFR.lua` + regel in `MidnightHelper.toc`
3. `GuideGroups.lua` → `SHARED_FR` + `GROUP_FR`
4. Broker-knop **Français** (als gewenst; nu EN/DE/NL)
5. Blizzard-check: **Gouffre généreux**, **Grande chambre forte** (of exacte client-string uit FR-client verifiëren)
6. Korte knoplabels + `FitToolbarButton` (al generiek)

---

## Bestanden (i18n)

| Bestand | Rol |
|---------|-----|
| `Locales/Locale.lua` | Resolver, auto, `ns:L`, slash aliases |
| `Locales/enUS.lua` | Bron + default |
| `Locales/deDE.lua` | DE shell + merge |
| `Locales/nlNL.lua` | Volledige NL (handmatig) |
| `Locales/GuideGroups.lua` | EN / DE / NL “In groups” |
| `Locales/DelveTips.lua` | EN + NL delve bodies |
| `Locales/GuideTips.lua` | Extra guide strings |
| `Core.lua` | `locale = "auto"`, migrate |
| `Modules/Broker.lua` | Taal-knoppen settings |
| `tools/build_deDE.py` | DE generator |

---

## Testchecklist (DE)

- [ ] `/mh lang de` + `/reload` — UI Duits, geen Lua errors
- [ ] Knop **Nächste großzügige Tiefe finden** (geen Tauchplatz)
- [ ] Account snapshot: **Sort.: …**, **Relog nötig**, **Mit Keys** — passen op knop
- [ ] Great Vault-teksten: **Große Schatzkammer** (geen “Great Vault” / Tresor)
- [ ] Delve Coach: tips nog EN is OK voor Phase B; titels/secties DE
- [ ] Auto op **deDE WoW-client** → DE; op EN-client + auto → EN

---

## CurseForge

- **1.3.1** staat in TOC; CF-upload alleen als gebruiker het vraagt.
- Bij release: changelog vermelden **Deutsch (UI shell)** + auto-locale.

---

## Adviesvolgorde (agent / volgende chat)

1. **deDE polish** — Sie→du, DelveTips DE namen, eventueel top 3 delve tip-secties NL→DE handmatig  
2. **frFR Phase B** — shell + GuideGroups + Blizzard-term check  
3. **ptBR** of **esES polish** — naar bereik  
4. **Phase C** per taal — advisor + gear (groot; per PR/taal splitsen)
