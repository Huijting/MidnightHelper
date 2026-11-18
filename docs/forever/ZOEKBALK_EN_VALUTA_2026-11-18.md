# Forever: een zoekbalk zoals in Midnight + valuta en reputaties — onderzoek 18 nov 2026

Rob (via Sparring 18-11), letterlijk: *"wat we nog missen in de forever versie is net zo een uitgebreide zoek functie (bar)
als in de midnight versie."* en *"ja dat mag nu al, het uitzoeken van de zoekbalk , laat hem nog niets bouwen maar met een
voorstel komen , in principe moet je alles kunnen vinden. ook moeten we kijken wat voor een currencies, reputaties ed in
forever zijn die belangrijk zijn :)"*. Alleen onderzoek; niets gebouwd. Geen Fable (Robs regel deze week).

## Deel A — de zoekbalk

### Hoe de Midnight-balk werkt (GEMETEN in de code)
- Motor: `Modules/NavSearch.lua` (1822 regels). `BuildNavIndex()` (r. 106-1030) bouwt bij elke toetsaanslag een lijst
  van bestemmingen; een opmerking (r. 1431) noemt ~1500 regels, offline gemeten op 3 nov.
- Soorten (`cat`, ook als filter `@mount`, `@boss` …): tab, tool, codex, boss, mount, rare, treasure, place, command,
  macro. Drie lagen: ACTIE (zet een route) boven NAV (tab/tool) boven INHOUD (mounts, rares) (r. 62-64).
- Zoeken: woorden + typfouten (`Edits`, r. 1068), synoniemen per taal (`SynMap`, r. 1265), hoofdletters ook voor
  Cyrillisch/accenten (`ULower`).
- Tonen: uitklaplijst onder de balk, 8 regels zichtbaar, tot 60 met scrollen (r. 22-28); grijze tekst = waar het zit.
- Klik/Enter: voert `go` uit — tab openen (`OpenTab` → `ns.SelectTab`), venster openen, of route + pijl zetten.
  Zwakke treffers vallen terug op het diepe Codex-zoeken in UI.lua.

### Hoe het nu in Forever zit (GEMETEN)
- `NavSearch.lua` laadt wél in Forever (`MidnightHelper_Camelot.toc` r. 200), maar hangt aan de balk van het oude
  venster. Dat venster komt in Forever niet meer: `ShowMainUI`/toggle gaan naar het overzicht (`UI.lua` r. 5122-5299).
  Dus: de grote balk is in Forever onbereikbaar. (De afleiding van sparring klopt.)
- `NavSearch.lua` kent `ns.IS_FOREVER` niet (0 treffers; dezelfde grep vond wel de andere patronen). De index is
  bijna helemaal Midnight-inhoud (Delves, rares, mounts, Silvermoon-pins).
- Het enige zoekvak in Forever: tandwiel → All commands (`ForeverOverview.lua` r. 1259), zoekt alleen commando's.

### Wat in Forever doorzoekbaar zou moeten zijn (regels geteld met grep = ruwe maat, AFGELEID als "aantal dingen")
| Bron | Waar | Ruw aantal |
|---|---|---|
| Overzicht: 7 tabs + subpagina's (How you play, Class quests, Camping, Legacy, This week, Quiet, Tools, Commands) | ForeverOverview | ~15 |
| Class quests (stappen) | ForeverClassQuests.lua | ~366 regels |
| Class-trainers | ForeverTrainerSpots.lua | ~218 |
| Beroepstrainers | ForeverProfTrainerSpots.lua | ~314 |
| Verkopers (shops, gereedschap) | ForeverVendorSpots.lua / ForeverVendors.lua | ~420 / 13 categorieën |
| In town: bank, AH, brievenbus, herberg | ForeverCitySpots.lua | 116 plekken (handoff 17 nov) |
| Wapenmeesters / wapenvaardigheden | ForeverWeapons.lua | ~8 |
| Dungeons (+ ingang, level) | ForeverDungeons.lua | ~35 |
| Macro's | ForeverMacros.lua | ~17 |
| Reisplekken | ForeverTravel.lua | ~14 |
| Stille helpers (schakelaars) | ForeverOverview QUEST-lijst | 19 |
| /mh-commando's | MH_COMMANDS | gedeeld met Midnight |
Samen ruim 1500 dingen: even groot als de Midnight-index.

## Deel B — valuta en reputaties (mh-research Opus, 18 nov; DB2 wago Forever 1.60.1.70959)

### Valuta (CurrencyTypes Forever: precies 9 rijen, GEMETEN)
- **Honor Points** 1792 — PvP-geld voor PvP-uitrusting; max 25000 (GEMETEN; oudere gidsen zeggen 15000).
- **Rank Points** 3468 — laten je PvP-rang (1-14) stijgen; weekcap in curve 102601 (GEMETEN; "x-as = week" AFGELEID).
- **Merchant's Favor** 3402 — recepten, tabard, titels bij ACA (Alliance) / DSL (Horde); uit gevulde Waylaid Crates.
- **Tarnished Undermine Real** 3469 — 1 per baas vanaf level 55 in BRD/LBRS/UBRS/DM/Scholo/Strat, 1× per dag; te
  besteden bij Pix Xizzix (Booty Bay). Cap: DB2 zegt 165, de item-tooltip 250 → client beslist (NIET gemeten).
- **Darkmoon Prize Ticket** 515 — kermis één week per maand (dec: Mulgore 7-13 dec, gids).
- Verborgen tellers (niet voor spelers): 3473 PvP-rang, 3485 Legacy-baan, 3498/3499 reset-tellers.
- ⚠️ Legacy Points zijn GEEN valuta maar trait-punten (`ForeverLegacy.lua`). Rep-tokens (Scourgestones, Feathers, Beads,
  Horns, Waylaid Crate …) zijn gewone tasspullen.

### Reputaties (Faction met ReputationIndex: 75 rijen, GEMETEN; kant A/H AFGELEID uit de racemaskers)
Het belangrijkst voor een Forever-speler (beloningen uit gidsen 14-17 nov, tenzij GEMETEN gezegd):
- **Guardians of Hyjal** 2765 (beide, 59-60): Rousing Seed Pod bij Revered = 2 Artisan's Tier-stukken dragen
  (eis GEMETEN in ItemSparse 274379). Hoe je Revered haalt: nog onbekend.
- **Barkskin Burrow** 2747 (54+): tas 18 vakjes, wapens; Deadwood Tribal Beads per 8.
- **Argent Dawn** 529: recepten, schouder-enchants; Scourgestones (20/10/1 per inlevering).
- **Timbermaw Hold** 576: recepten; Feathers/Beads per 5, nieuw: Legashi Horns/Blackmaw Pouches per 5.
- **Thorium Brotherhood** 59, **Cenarion Circle** 609: recepten (60).
- **Kirin Tor** 2740 (alleen A) / **Earthen Ring** 2787 (alleen H): Azure/Cloudy-recepten.
- **Nightclaw Druids** 2758 (Zephras Isle), **ACA** 2586 / **DSL** 2587 (Merchant's Favor, writs).
- Battleground-facties AB/WSG/AV + nieuw **Darkspear Islands** (2799 A / 2798 H): Exalted bij elk = 1 Legacy Point
  (gidsen; de achievements 62046-62049 zijn GEMETEN).
- Steamwheedle-steden (Booty Bay, Gadgetzan, Ratchet, Everlook, nieuw Powderfuse 2827): levelgear.
- Hydraxian/Zandalar/Brood of Nozdormu: hun raids zitten (nog) niet in Forever → nu nutteloos (AFGELEID).
- Legacy-perk **Diplomat** (spell 1225485): +10% rep (GEMETEN; per rang of totaal: onduidelijk).

### Wat MH al heeft (GEMETEN, grep met positieve controle "Argent Dawn" = 2 treffers in Modules)
- Legacy: `ForeverLegacy.lua` (C_MajorFactions 2802 werkt in Forever: 17 nov "earned 0" bij Rob, r. 91).
- PvP: één regel in This week (`ForeverWeek.lua`, `FWEEK_PVP_FMT`). Darkmoon alleen via de kalender.
- Losse vermeldingen: Argent Dawn-verkoper (`ForeverVendorSpots.lua:90`), Manna Biscuits (`enUS.lua:6003`).
- NIETS voor Merchant's Favor, Undermine Real, Prize Ticket, Rank Points (0 treffers in Modules en enUS.lua).
- Herbruikbaar uit Midnight (laadt niet in Forever): `C_Reputation.GetFactionDataByID` (CurrencyGuide.lua:35),
  `C_CurrencyInfo.GetCurrencyInfo` (AltOverview.lua:327-342).

### NIET gemeten
Of `C_Reputation.*`, `C_CurrencyInfo.GetCurrencyInfo` en `C_Item.GetItemCount` in de Forever-client werken; alle
servergetallen (rep per kill, Favor per krat); Hyjal-Revered; de Real-cap; namen in andere talen; Robs eigen reps.

## Voorstel (naar sparring, 18 nov)
Zie het bericht aan Sparring 18-11; samengevat in IDEEEN.md.
