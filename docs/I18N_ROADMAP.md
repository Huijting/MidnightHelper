# i18n roadmap — Midnight Helper

**Laatste update:** 2026-05-23  
**Versie op schijf:** `MidnightHelper.toc` → **1.3.2**  
**CurseForge:** pas uploaden als **CF release gate** hieronder volledig is ✅

Dit document is de **vaste draad** voor vertalingen. Chatgeschiedenis sync niet tussen PC’s — start een nieuwe Agent met `@docs/I18N_ROADMAP.md` en `@docs/NEXT_SESSION.md`.

---

## CF release gate (niet pushen tot alles ✅)

**Doel:** één “grote” CF-release met alle gewenste retail-talen **af**, niet alleen UI-shell.

### Talen op de lijst (6 packs)

| Code | Naam | Auto client? | Phase B | Phase C | Polish | Blizzard-check |
|------|------|--------------|---------|---------|--------|----------------|
| `enUS` | English | ja | ✅ bron | ✅ bron | ✅ | — |
| `nlNL` | Nederlands (addon) | nee (handmatig) | ✅ | ✅ | 🟡 doorlopend | — |
| `deDE` | Deutsch | ja | ✅ | ✅ | 🟡 Sie→du | in-game DE |
| `frFR` | Français | ja | ✅ | ✅ | 🟡 tu/ton | in-game FR |
| `esES` | Español | ja (+ `esMX`→`esES`) | ✅ | ✅ | 🟡 profundidad | in-game ES |
| `ptBR` | Português (BR) | ja | ✅ | ✅ | 🟡 | in-game ptBR |

**Phase B** = UI-shell, `GuideGroups`, `ConsumablesNotes`, `GuideTips` + `DelveTips` merges, broker-knop.  
**Phase C** = `GUIDE_ADVISOR_*` (~1128) + per-spec `GUIDE_GEAR_*` (~165) — zie `Locales/GuideAdvisor.lua`.  
**Polish** = Blizzard-termen, `{SPELL:…}` intact, toon (du/tu), geen “profundización” e.d.

### Bewust buiten scope (tenzij later besloten)

| Code | Reden |
|------|--------|
| `ruRU` | Geen pack; oude `ru`/`ruRU`-voorkeur → `auto` (UI = `enUS` op RU-client) |
| `itIT`, `koKR`, `zhCN`, `zhTW` | Geen pack; auto → `enUS` + status “pack pending” |

### CF-tekst bij release

- About/changelog: **EN · DE · FR · ES · NL · PT** (geen “alleen EN/NL”).
- Vermeld dat **NL** handmatig blijft (`/mh lang nl`).
- Geen upload bij open Phase C-regels in de tabel.

---

## Wat er nu in de addon zit

| Fase | Status | Beschrijving |
|------|--------|--------------|
| **A — Auto-locale** | ✅ Done | `locale = "auto"` volgt `GetLocale()`; `nlNL` nooit auto; fallback `enUS` |
| **B — deDE / frFR / esES** | ✅ Done | UI-shell + groups + tips + delve bodies |
| **B — ptBR** | ✅ Done | Shell + groups + tips/delve + broker **Português** |
| **C — deDE / frFR / esES** | ✅ Done | `Locales/GuideAdvisor.lua` (~1288 keys × 3) |
| **C — ptBR** | ✅ Done | `ptBR_PHASE_C` in `GuideAdvisor.lua` |
| **Polish** | 🟡 Doorlopend | Per taal na C |

### Locale-packs geladen (TOC-volgorde)

```
enUS.lua → deDE.lua → frFR.lua → esES.lua → ptBR.lua → nlNL.lua
→ ConsumablesNotes.lua → GuideTips.lua → GuideTipSpellNames.lua → GuideTipText.lua
→ GuideGroups.lua → GuideAdvisor.lua → DelveTips.lua → Locale.lua
```

### Handmatig vs automatisch

| Code | Auto bij WoW-client? | Opmerking |
|------|----------------------|-----------|
| `enUS` | ja (EN/EN-GB) | Default + fallback |
| `deDE` | ja | |
| `frFR` | ja | |
| `esES` | ja | |
| `esMX` | ja (alias → `esES`) | Zelfde pack als EU-Spaans |
| `nlNL` | **nee** | Altijd handmatig |
| `ptBR` | ja | Eigen Blizzard-termen (Grande Câmara, profundidade opulenta) |
| `ruRU` | ja → **enUS** | Geen addon-pack |
| overige | nee | Auto → EN + “pack pending” |

### Commando’s

```text
/mh lang auto   — WoW-clienttaal (als pack bestaat)
/mh lang en     — English
/mh lang de     — Deutsch
/mh lang fr     — Français
/mh lang es     — Español
/mh lang nl     — Nederlands (addon)
/mh lang pt     — Português (BR)
```

Minimap → Instellingen: rij 1 **Auto / EN / DE / FR** — rij 2 **ES / PT / NL**.

---

## Werkmijlsten per taal

### ptBR (Brazil) — Phase B then C

1. `tools/build_ptBR.py` (kopie `build_esES.py`)
2. `Locales/ptBR.lua` + TOC + broker-knop **Português**
3. `GuideGroups` → `SHARED_PT` / `GROUP_PT`
4. `ConsumablesNotes` → `PT`
5. `GuideTips.lua` + `DelveTips.lua` merge `ptBR`
6. Blizzard (client ptBR): **Profundidades** / **Grande Câmara** (exacte strings verifiëren)
7. Phase C via `tools/build_guide_phase_c.py --locales ptBR`

### Phase C (deDE, frFR, esES — nu)

- Bron: `Locales/enUS.lua` keys `GUIDE_ADVISOR_*` + `GUIDE_GEAR_(MAGE|DK|…)_*`
- Uitvoer: `Locales/GuideAdvisor.lua` (merge per taal)
- `nlNL` al volledig in `nlNL.lua` — geen merge nodig
- Generator: `python tools/build_guide_phase_c.py`

### Polish (na C, alle CF-talen)

- [x] **deDE:** Sie→du (shell + GuideTips + DelveTips + GuideAdvisor Phase C), Tiefen-termen, `TAB_DELVES`
- [x] **frFR:** vous→tu/ton (shell + GuideAdvisor + GuideTips); in-game check share-knoppen
- [x] **esES:** Delve Coach→profundidades; changelog/share strings
- [x] **ptBR:** Delve Coach→profundidades (shell)
- [ ] **In-game test** alle 6 packs (zie testchecklist)

---

## Blizzard-termen (niet machinevertalen)

### Deutsch

| Engels | Duits (Blizzard) | Niet gebruiken |
|--------|------------------|----------------|
| Delve(s) | **Tiefe / Tiefen** | Tauchplatz |
| Bountiful Delve | **großzügige Tiefe** | |
| Great Vault | **Große Schatzkammer** | Tresor, Gewölbe |
| Delver's Journey | **Reise des Tiefenforschers** | |

### Français

| Engels | Français (Blizzard) |
|--------|---------------------|
| Delve(s) | **Gouffre** |
| Great Vault | **Grande chambre forte** |
| Tab kort | **Gouffres & Chambre** |

### Español

| Engels | Español (Blizzard) |
|--------|-------------------|
| Delve(s) | **Profundidad / Profundidades** |
| Bountiful | **profundidad pródiga** |
| Great Vault | **Gran Bóveda** |
| Tab kort | **Profundidades & Bóveda** |

### Português (BR) — te verifiëren in client

| Engels | ptBR (verwacht) |
|--------|-----------------|
| Delve(s) | **Profundidade(s)** |
| Great Vault | **Grande Câmara** (check) |

**Engels laten in UI (alle packs):** Keys, Shards, Undercoins, ilvl, TomTom, veel itemnamen.

---

## Bestanden (i18n)

| Bestand | Rol |
|---------|-----|
| `Locales/Locale.lua` | Resolver, auto, aliases (`esMX`→`esES`); migreert oude `ru`/`ruRU` → `auto` |
| `Locales/enUS.lua` | Bron + advisor/gear EN |
| `Locales/nlNL.lua` | Volledige NL |
| `Locales/deDE.lua` / `frFR.lua` / `esES.lua` | Shell (geen advisor/gear in pack-merge) |
| `Locales/GuideAdvisor.lua` | Phase C merges |
| `Locales/GuideTips.lua` / `DelveTips.lua` | Tip bodies |
| `Locales/GuideGroups.lua` / `ConsumablesNotes.lua` | Groups + consumables |
| `tools/build_*` | Generators per taal / fase |
| `tools/polish_formality.py` | Sie→du, vous→tu, Delve-termen (`de` `fr` `es` `pt`) |

**Niet committen:** `tools/_guide_groups_*.txt`, tijdelijke snippets.

---

## Adviesvolgorde (agent)

1. ✅ Roadmap + CF gate (dit document)  
2. ✅ **Phase C** — `deDE`, `frFR`, `esES`, `ptBR`  
3. **Polish** alle 6 CF-talen  
4. **In-game test**  
5. About/changelog + TOC-versie → **CF upload**

---

## Testchecklist (vóór CF)

- [ ] `/reload` — geen Lua-errors met alle packs geladen
- [ ] Per taal: `/mh lang XX` — Leveling Guide → tab Advisor + Gear **niet** Engels (behalve bewust EN termen)
- [ ] `/mh lang auto` op `deDE` / `frFR` / `esES` / `ptBR` client
- [ ] Delve Coach + share-knoppen passen op breedte per taal
- [ ] `ValidateDelveTipLocales()` groen (of bewust gedocumenteerd)
