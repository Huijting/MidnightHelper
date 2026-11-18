# fable_G1 — nakijkronde Forever-bazengids, stap 1 (9 dungeons)

Nagekeken 18 nov 2026, onafhankelijk (geen rapporten of notes van anderen gelezen; alleen code, data, teksten en bronnen).
Bereik: maps 389, 3065, 2999, 43, 36, 33, 34, 48, 2998 — 59 bazen, 192 tekstsleutels x 7 talen (+ esMX-overlay), 27 items.

**Uitkomst in één oogopslag**

| Soort | Aantal | Waar |
|---|---|---|
| FOUT (zeker) | 8 | A1-A8 |
| RISICO | 10 | B1-B10 |
| In orde (nagemeten) | npc-id's 59/59, encounter-id's 62/62, items 27/27 ("Dropped by" + stats), 192 sleutels in 7 packs, 160 van de 165 does/tip-regels (de 5 andere: A1, B2, B5, B6, B7) | C |

GEMETEN = zelf gezien in de genoemde bron op 18 nov 2026. AFGELEID = beredeneerd.
Niet te meten vanaf hier (geen client): wat het naamplaatje echt toont, of `GET_ITEM_INFO_RECEIVED` in Forever afgaat,
of `GetRealZoneText(mapID)` in Forever een naam teruggeeft.

---

## A. FOUT (zeker)

### A1. Baron Aquanis (BFD): er staat niet bij dat alleen een Horde-speler hem kan oproepen
- Sleutel `FDG_BFD_5_D1` = "Optional; fought in the water."
- GEMETEN, 3 bronnen: Wowhead Forever BFD-gids (bijgewerkt 13 nov 2026): quest *Amongst the Ruins* (Horde) "Summons Baron
  Aquanis when Fathom Core picked up"; Warcraft Tavern Forever BFD (gelezen 18 nov): "summoned when Horde party members loot
  the Fathom Stone for a dungeon quest"; conquestcapped (bijgewerkt 7 nov 2026): "only appears when a Horde player loots
  the Fathom Stone in the water of the Moonshrine Ruins", tabel: "whom only the Horde can summon".
- Gevolg: een Alliance-groep zoekt een baas die nooit komt; niemand weet wat je moet klikken. Foutsoort: factie-filter +
  "wat moet je precies doen".
- De `-- src:`-regel (Data.lua:393) noemt alleen MOB+SK; WT en CQ zijn gemist.
- Object GEMETEN: Wowhead Forever object 177964 = "Fathom Stone" (zone 719). Per taal (zelfde bron): de Tiefenstein,
  fr Pierre de la Brasse, esES/esMX Piedra de las profundidades, pt Pedra das Profundezas, ru Глубинный Камень.
- **Reparatie** — nieuwe Engelse tekst:
  `FDG_BFD_5_D1 = "Optional: only appears when a Horde player on the quest loots the Fathom Stone under water; the fight is in the water.",`
  Vertalingen staan in `fable_G1_<taal>.txt`.

### A2. Volgorde van de bazen klopt niet met de looproute (Deadmines en Ruins of Lordaeron)
De gids nummert de bazen (`ForeverDungeonGuide.lua:166`, "%d. %s"). De volgorde in de data is de DB2-`OrderIndex`
(GEMETEN: DungeonEncounter 1.60.1.70959), niet de volgorde waarin je ze tegenkomt.
- **Deadmines** (Data.lua:224-247): data = 5. Captain Greenskin, 6. Mr. Smite. Looproute: eerst Mr. Smite, dan Greenskin.
  GEMETEN in 3 bronnen: Icy Veins Forever Deadmines (18 okt 2026), Mobalytics (12 nov 2026), ForeverDungeonJournal
  `Data/Dungeons.lua:811-816` — alle drie Smite vóór Greenskin.
  Reparatie: Mr. Smite vóór Captain Greenskin zetten. (Cookie vóór VanCleef mag blijven: Cookie is optioneel, VanCleef is de eindbaas.)
- **Ruins of Lordaeron** (Data.lua:86-121): data = 1 Witherfang, 2 The Abandoned, 3 The Baron, 4 Viktor, 5 Bjork, 6 Rath'mael.
  GEMETEN in 4 bronnen (Icy Veins 19 okt 2026, GameSpot 3 nov 2026, Method, wowforeverguides 29 sep 2026):
  Witherfang, The Baron, Viktor the Vile, The Abandoned, Bjork, Rath'mael. (Mobalytics: ook The Baron als tweede.)
  Reparatie: volgorde Witherfang, The Baron, Viktor the Vile, The Abandoned, Bjork, Rath'mael, Lordaeron Captain.
- Het bestand is gegenereerd: de volgorde hoort in de bron van `dg_gen.lua`, niet met de hand in het databestand.
- De andere 7 dungeons: volgorde in orde (GEMETEN tegen IV/WT). Miner Johnson na Sneed laten staan (DB2-index 1500; IV en
  FDJ zetten hem ervoor, geen derde bron — AFGELEID: niet aankomen).

### A3. deDE: "Kette" is niet het woord van de Duitse client
- GEMETEN: DB2 ItemSubClass 4/3 deDE (1.60.1.70959) = "Schwere Rüstung". De pack schrijft "Brustteil aus Kette" en "Kettenträger".
- Sleutels: `FDG_THANES_L2`, `FDG_BFD_L3`, `FDG_WC_L3`, `FDG_EXCAV_L3`. Nieuwe regels in `fable_G1_deDE.txt`.

### A4. ptBR: "bordão" is niet het woord van de client, en "Defias" mist het accent
- GEMETEN: ItemSubClass 2/10 ptBR = "Cajado" (staff). Sleutels `FDG_LORD_L1`, `FDG_WC_L2`, `FDG_BFD_L2`.
- GEMETEN: Wowhead Forever ptBR npc 598 "Minerador Défias", 636 "Guardião das Sombras Défias". De pack schrijft "Defias"
  in `FDG_DM_3_D2`, `FDG_DM_6_T`, `FDG_DM_8_D2`, `FDG_DM_8_T`. Nieuwe regels in `fable_G1_ptBR.txt`.

### A5. esES: "malla" moet "mallas" zijn (esMX blijft "malla")
- GEMETEN: ItemSubClass 4/3 esES = "Mallas", esMX = "Malla". Sleutels `FDG_THANES_L2`, `FDG_BFD_L3`, `FDG_WC_L3`,
  `FDG_EXCAV_L3`. Klein, maar het is de namenregel. Nieuwe esES-regels in `fable_G1_esES.txt`; de esMX-overlay krijgt dan
  dezelfde 4 sleutels met "malla" (`fable_G1_esMX.txt`), anders ziet Mexico het Spaanse woord.

### A6. frFR-naam Twilight Lord Kelris: hoofdletter wijkt af van het naamplaatje
- Data.lua:402 frFR = "Seigneur du Crépuscule Kelris" (de DB2-vorm). GEMETEN Wowhead Forever npc 4832 frFR =
  "Seigneur du crépuscule Kelris". Volgens de namenregel wint Wowhead als die een eigen naam heeft.
- Reparatie: `frFR = "Seigneur du crépuscule Kelris"`.

### A7. nlNL: taalfout in de waarschuwing boven de drie nieuwe dungeons
- `FDG_RECHECK` = "... er zijn er nog weinig gidsen over ..." (dubbel "er"). Nieuwe regel in `fable_G1_nlNL.txt`.

### A8. Bronregel klopt niet: "vier plekken 2x MOB+WT" (Lady Anacondra)
- Data.lua:141. GEMETEN: Warcraft Tavern zegt alleen "randomly spawns at one of the ritual circles" — geen getal. Het getal
  4 staat alleen bij Mobalytics (14 nov 2026: "1 of 4 random locations"). Het is dus een getal uit één bron, maar de baas
  heeft geen `one = true`. Zie B6 voor de tekst.

---

## B. RISICO

### B1. Itemnamen kunnen als "#272996" blijven staan (code)
- `ForeverDungeonGuide.lua:111-122` + `:363`: `ItemName` probeert alleen `C_Item.GetItemNameByID`, vraagt dan
  `RequestLoadItemDataByID` en wacht op `GET_ITEM_INFO_RECEIVED`.
- GEMETEN in MH's eigen code: precies dit patroon bleef op Forever hangen. `ForeverVendors.lua:66` ("Rob, 11 Nov 2026: still
  "(loading...)" a day after the first fix") en `:571-573` ("Why the event did not land is not measured"). En
  `RaidShoppingList.lua:726`: `RequestLoadItemDataByID` antwoordt met `ITEM_DATA_LOAD_RESULT`, niet met `GET_ITEM_INFO_RECEIVED`.
- Gevolg (AFGELEID): bij de eerste keer openen staan de 3 items per dungeon als "#id", wit, tot er toevallig een ander
  event komt of je het venster opnieuw opent.
- **Reparatie** (zelfde aanpak als `ForeverVendors.lua:66-73` en `:597-619`):
  1. In `ItemName` een tweede weg: `local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo` → naam uit `pcall(info, id)`.
  2. Een bestand-lokale vlag `missingItem = true` zetten als de naam ontbreekt (bovenaan `ns.ForeverDungeonGuideText` op false).
  3. In `Fill()` na `SetText`: als `missingItem` en er loopt nog geen ticker → `C_Timer.NewTicker(0.5, …)` die `Fill()`
     opnieuw doet, stopt na 10 keer, of als niets meer ontbreekt, of als het venster dicht is.
  Geen nieuw event registreren zonder `pcall` (onbekend event = fout bij laden).

### B2. Thanes/Magmatus-tip: "him" wijst naar de verkeerde
- `FDG_THANES_2_T` = "Kill the Summoner first; ranged stay away from him." Taalkundig is "him" de Summoner. Bedoeld
  (GEMETEN: Warcraft Tavern "Ranged players should stay away from Magmatus"; IV, GameSpot 19 okt, Method 17 nov: tank trekt
  Magmatus weg van de groep) is de baas. In alle 7 talen dezelfde dubbelzinnigheid.
- Reparatie: `FDG_THANES_2_T = "Kill the Summoner first; ranged stay away from the boss.",` (bewust "the boss": DB2 noemt
  encounter 3495 "Infurnus", Wowhead "Magmatus"). Vertalingen in de txt-bestanden.

### B3. Lordaeron Captain heeft wél een npc-id
- Data.lua:122 heeft geen `npc` ("A boss without a known npc id"). GEMETEN: Wowhead Forever npc **255699** = "Lordaeron
  Captain", Undead, Rare Elite, zone 16611 (Ruins of Lordaeron). Namen per taal op dat id = de namen die al in de data
  staan (de Hauptmann von Lordaeron, fr Capitaine de Lordaeron, es/esMX Capitán de Lordaeron, pt Capitão de Lordaeron,
  ru Лордеронский капитан) — alle 6 GEMETEN.
- Reparatie: `npc = 255699` toevoegen; dan werkt "MH markeert je target" ook voor hem. Na te meten in het spel met
  `/mh bosses check` (toont "target npc").

### B4. Bazennamen: het tweede deel van de namenregel geeft hier waarschijnlijk NIET het naamplaatje
- De data volgt de regel correct (alle 59 npc's x 6 talen nagelopen; alleen A6 wijkt af). Maar: waar Wowhead Forever de
  Engelse naam geeft, valt de data terug op DB2 DungeonEncounter.
- GEMETEN: Wowhead **Forever** deDE = Wowhead **Classic** deDE (Captain Greenskin, Mr. Smite, Cookie, Rethilgore, Baron
  Silverlaine, Kam Deepfury, Old Serra'kis); Wowhead **retail** deDE = de DB2-namen (Kapitän Grünhaut, Handlanger Pein,
  Krümel, Rotkralle, Baron Silberlein, Kam Tiefenzorn, Alter Serra'kis). In dezelfde dungeons geeft Wowhead Forever wél
  Duitse namen ("Kommandant Springvale", "Twilight-Lord Kelris", "Bruegal Eisenfaust"), dus die Engelse namen zijn geen gat.
- AFGELEID: de DB2-tabel draagt retail-namen; het naamplaatje toont de Classic-naam. Dan staan er 11 namen in de gids die
  de speler niet op het scherm ziet:
  - deDE (7): Kapitän Grünhaut → Captain Greenskin; Handlanger Pein → Mr. Smite; Krümel → Cookie; Rotkralle → Rethilgore;
    Baron Silberlein → Baron Silverlaine; Kam Tiefenzorn → Kam Deepfury; Alter Serra'kis → Old Serra'kis.
  - frFR (3): Rethiltripe → Rethilgore; Kam Furie-du-fond → Kam Deepfury; Ghamoo-Ra → Ghamoo-ra.
  - esES (1): Ghamoo-Ra → Ghamoo-ra.
- Niet te bewijzen zonder een Duitse/Franse Forever-client. Keuze voor Rob: (a) zo laten, (b) Wowhead Forever altijd laten
  winnen, ook als de naam Engels is. Mijn advies: b.
- Klein, zelfde soort: frFR-namen in de data hebben een krul-apostrof (’, zoals DB2), Wowhead Forever een rechte (').
  Alleen uiterlijk.

### B5. Old Serra'kis: "No special moves" klinkt zekerder dan de bronnen
- `FDG_BFD_6_D1` = "No special moves; the whole fight is under water."
- GEMETEN: Icy Veins (19 okt), Mobalytics (12 nov) en Wowhead (13 nov: "Abilities: None") zeggen geen vaardigheden.
  Warcraft Tavern: "will periodically heal himself when attacking"; conquestcapped (7 nov): "casts Leech Pulse, which
  drains health". DB2 SpellName Forever kent "Leech Pulse" (8433, 8434; geen beschrijving). 3 tegen 2.
- Reparatie (veilig in beide gevallen): `FDG_BFD_6_D1 = "The whole fight is under water.",`
  nl "Het hele gevecht is onder water." · de "Der ganze Kampf ist unter Wasser." · fr "Tout le combat a lieu sous l’eau." ·
  es "Todo el combate es bajo el agua." · pt "A luta toda é debaixo d’água." · ru "Весь бой идёт под водой."

### B6. Lady Anacondra: "one of four spots" — getal uit één bron
- `FDG_WC_1_D2`. Zie A8. Twee nette uitwegen: `one = true` op de baas, of de tekst
  `"Stands at one of a few spots in the first big cave."` (zoals bij Lorgus Jett, waar MOB 3 en CQ 4 plekken telt).

### B7. Twilight Lord Kelris: "a shadow blast you can interrupt" — één gids zegt van niet
- `FDG_BFD_7_D2`. GEMETEN: Icy Veins "Mind Blast that can be interrupted", Mobalytics "Kick, Pummel, Shield Bash ... should be
  used"; Warcraft Tavern: "Kelris casts Sleep and Mind Blast. They cannot be interrupted." 2 tegen 1 — laten staan, wel weten.

### B8. Kleur van "(your target)" bij een rare baas (code, alleen uiterlijk)
- `ForeverDungeonGuide.lua:167-171`: bij een rare die je target staat `|cff9d9d9d(rare…)|r` binnen het groene blok; na die
  `|r` is de rest niet meer groen (AFGELEID: zo werkt `|r` in oudere clients). Reparatie: bij `here` het rare-stuk zonder
  eigen kleur plakken, of het groen opnieuw openen vóór `FDG_TARGET`.

### B9. Rol bij de Repurposed Rack (Stockade)
- `FDG_STOCKS_L3` = "tank (shield)". GEMETEN (Wowhead Forever item 273811): +6 Strength én "+7 damage and healing done by
  magical spells". Icy Veins: "Strength/Spellpower Shield". De rol is AFGELEID; het is vooral een paladin/shaman-schild.
  Voorstel: "tank or paladin (shield, +6 Strength)". Niet dringend.

### B10. Highland Horror (Excavation): npc-id klopt, maar Wowhead legt hem in de Wetlands
- npc 260808: Wowhead Forever zone 11 (Wetlands), level 28, 10 punten; de andere drie bazen staan in zone 16732.
  FDJ gebruikt hetzelfde id ("quest target, Wowhead Forever") en de quest zegt "Kill a Highland Horror within Excavation
  Sites". AFGELEID: de dungeon ligt op de Wetlands-kaart; mogelijk meer dan één exemplaar. De teksten kloppen met 4 gidsen.
  Geen actie; in het spel nameten met `/mh bosses check`.

---

## C. Nagemeten en in orde

**Id's (GEMETEN, Wowhead Forever tooltips + DB2 DungeonEncounter 1.60.1.70959)**
- 59 npc-id's (58 bazen + Sneed's Shredder 642): naam en zone kloppen. Rare-vlag klopt met "Rare Elite": 5912, 3586, 3872, 1720.
- 62 encounter-id's (55 + 7 `encounterAlt` bij BFD): kloppen. De twee afwijkende DB2-namen staan al als MEASURE in de
  data (3495 Infurnus, 3355 The Butcher). `encounter` wordt door de code niet gebruikt.
- 27 items: "Dropped by" = de baas in de data, bij alle 27. Alle getallen in de roltekst kloppen met de tooltip
  (+33 healing, +18/+24/+34/+32/+8 spell power, +45 healing, +12 attack power, +11/+10 Strength, +9/+5/+6 Agility,
  +18 healing/+6 Spirit, +12 Stamina/+hit, main-hand / one-hand / two-hand / off-hand / trinket).

**Does/tip-regels (GEMETEN tegen minstens 2 Forever-bronnen, behalve waar `one = true` staat)**
- Ragefire Chasm 12/12 — Icy Veins 19 okt, Mobalytics 12 nov, conquestcapped 7 nov.
- Hall of Thanes 13/14 (de 14e = B2, alleen formulering) — Icy Veins 19 okt, Mobalytics 12 nov, Warcraft Tavern, GameSpot 19 okt,
  Method 17 nov. Curse "attacks and spells": ook GEMETEN in DB2 Spell 1292602 ("reducing attack speed and casting speed").
  Method doodt Durgen vóór de golems; 4 andere gidsen de golems eerst, zoals de tip.
- Ruins of Lordaeron 21/21 — Icy Veins 19 okt, Mobalytics 13 okt, GameSpot 3 nov, Method, wowforeverguides 29 sep.
  Captain: Icy Veins + MSPaintWoW 20 okt + Warcraft Tavern + FDJ. "Waves of undead" is AFGELEID (bronnen: "mobs").
- Wailing Caverns 23/24 (de 24e = B6, het getal) — Icy Veins 19 okt, Mobalytics 14 nov, Warcraft Tavern, wowcalc. "Hits the tank very
  hard" (Verdan) heeft nu 2 bronnen (MOB + wowcalc); `one` mag daar weg, hoeft niet.
- Deadmines 21/21 — Icy Veins 18 okt, Mobalytics 12 nov.
- Shadowfang Keep 24/24 — Icy Veins 19 okt, Mobalytics 12 nov, Warcraft Tavern. "worgs and worgen" bij Rethilgore: WT
  ("two elite Bleak Worgs and one Shadowfang Whitescalp"). Beter kan: Silverlaine-tip — IV en WT zeggen dat de curse te
  verwijderen is ("decurse"); de tip noemt dat niet.
- Stockade 15/15 — Icy Veins 19 okt, Mobalytics 18 nov, Wowhead-gids.
- Blackfathom Deeps 19/22 — zie A1, B5, B7. Rest: Icy Veins 19 okt, Mobalytics 12 nov, conquestcapped 7 nov, WT.
- Excavation Site 12/12 — GameSpot 3 nov, Warcraft Tavern, wowforeverguides 3 okt, wowfdb, wowforeverinfo 20 okt.
- De overige `-- src:`-regels kloppen met wat de bronnen zeggen (o.a. Magmatus/MOB, Bazzalan/MOB, Springvale-volgorde,
  Fenrus-voidwalkers, Targorr 30%/20%, Rath'mael- en Living Root-loot zonder MOB).

**Teksten (GEMETEN met scratch `fable_G1_keys.py`)**
- 192 sleutels in de data = 192 in enUS = 192 in nlNL, deDE, frFR, esES, ptBR, ruRU; esMX-overlay 7. Geen dubbele, geen
  ontbrekende, geen regel gelijk aan het Engels, alle getallen gelijk, geen rechte " in een tekst.
- Clientwoorden GEMETEN (GlobalStrings + ItemSubClass + Wowhead Forever per taal): stats, slots, wapensoorten, Alliance/Horde,
  Disciple of Naralex, Voidwalker, Lady Anacondra — kloppen, behalve A3-A5. esES "Intelecto" klopt (item-tooltip:
  ITEM_MOD_INTELLECT_SHORT = "intelecto"). ruRU en frFR: geen naamfouten.
- Betekenis gelijk aan het Engels in alle talen. Twee zinnen zijn onduidelijk: frFR en ptBR `FDG_LORD_3_T`
  ("provoque-le" / "provoque-o" leest als "taunt de tank") — verbeterd in de txt-bestanden. deDE `FDG_BFD_4_T` is krom
  ("mit Magie bannen") — verbeterd.

**Code** — verder geen fouten gevonden: nil-paden gedekt (baas zonder npc, target zonder GUID, onbekende map), geen
secure frames, GUID-splitsing goed (6e veld), `d.instance` in het overzicht = `d.map`.

---

## D. Bestanden
- `fable_G1_enUS.txt` — 2 nieuwe Engelse regels (A1, B2).
- `fable_G1_nlNL.txt`, `_deDE.txt`, `_frFR.txt`, `_esES.txt`, `_esMX.txt`, `_ptBR.txt`, `_ruRU.txt` — alleen verbeterde regels.
  De regels voor `FDG_THANES_2_T` en `FDG_BFD_5_D1` horen bij de nieuwe Engelse tekst. Niet door een moedertaalspreker nagekeken.
- `fable_G1_keys.py` — het leescontrole-script (schrijft niets).

## E. Bronnen (alle gelezen op 18 nov 2026; datum = "last updated" op de pagina)
- Spel-data: `gamedata` — DB2 wowf 1.60.1.70959 (DungeonEncounter, Spell, SpellName, GlobalStrings, ItemSubClass, per locale);
  Wowhead Forever tooltips (npc, item, object; per locale); `dg_items.py` voor "Dropped by".
- Icy Veins Forever (Neryssa): `icy-veins.com/wow-forever/<dungeon>-guide` — ragefire-chasm, hall-of-thanes,
  ruins-of-lordaeron, wailing-caverns, deadmines, shadowfang-keep, the-stockade, blackfathom-deeps (18-19 okt 2026).
- Mobalytics Forever: `mobalytics.gg/wow-forever/dungeons/…` — rage-fire-chasm-dungeon-guide (12 nov),
  the-hall-of-thanes-dungeon-guide (12 nov), ruins-of-lordaeron-dungeon-guide (13 okt), wailing-caverns-dungeon-guide (14 nov),
  the-deadmines-dungeon-guide (12 nov), shadowfang-keep-guide (12 nov), the-stockade-dungeon-guide (18 nov),
  blackfathom-deeps-guide (12 nov).
- Warcraft Tavern Forever: `warcrafttavern.com/forever/guides/…` — hall-of-thanes, shadowfang-keep, blackfathom-deeps
  (hele pagina); wailing-caverns, excavation-site-wetlands, the-ruins-of-lordaeron, the-stockade (zoekuittreksel).
  Geen datum op de pagina's.
- GameSpot: Hall of Thanes (19 okt 2026), Ruins of Lordaeron (3 nov 2026), Excavation Site: Wetlands (3 nov 2026).
- Method: `method.gg/wow-forever/dungeons/hall-of-thanes` (17 nov 2026), `…/ruins-of-lordaeron`.
- Wowhead Forever-gidsen (via zoekuittreksel; de pagina zelf geeft 403): blackfathom-deeps (13 nov 2026),
  the-stockade, wailing-caverns (27 okt 2026); npc-pagina `wowhead.com/forever/npc=255699/lordaeron-captain`.
- conquestcapped: Ragefire Chasm en Blackfathom Deeps (beide bijgewerkt 7 nov 2026).
- Verder: wowforeverguides.com (RoL 29 sep, Excavation 3 okt), wowforeverinfo.com (Excavation 20 okt), wowfdb.com,
  wowcalc.net, mspaintwow.com (Lordaeron Captain, 20 okt).
- ForeverDungeonJournal (lokaal): `Data/Dungeons.lua`, `Data/Bosses.lua` — alleen als tweede bron (volgorde Deadmines,
  Lordaeron Captain "Horde only", npc-id's Lordaeron en Excavation).
