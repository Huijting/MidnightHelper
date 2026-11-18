# Bazengids Forever, stap 2b: bronnen per deel (18 nov 2026)

Vier mh-research-helpers (Opus), elk een deel; daarna twee onafhankelijke controles
(`DUNGEONGIDS_CONTROLE2B_DE_2026-11-18.md`, `DUNGEONGIDS_CONTROLE2B_FG_2026-11-18.md`): samen 2 FOUT en 24 RISICO.
Alle FOUT en RISICO met een reparatie zijn doorgevoerd (30 Engelse regels, opnieuw vertaald). Uitzondering: Malor the
Zealous kreeg geen `optional` (bronnen spreken elkaar tegen; staat als measure).
Namen per taal volgen Robs keuze **"B"** (naamplaatje = Wowhead Forever npc-naam per locale); de meting voor de 147
bazen van stap 1 + 2a staat onderaan (52 namen vervangen; alleen apostrof/accent/spatie/hoofdletter = niet vervangen;
groepsgevechten houden hun groepsnaam).
De data zelf staat als commentaar per regel in `Modules/ForeverDungeonGuideData.lua`. Hieronder de notities zoals de
onderzoekers ze schreven (vóór de controles; waar een controle iets anders zegt, wint de controle).

---

# Deel D: Sunken Temple, Blackrock Depths

# Dungeongids Forever, stap 2b, DEEL D: bronnen en open punten (18 nov 2026)

Bij `dg2b_D.lua` (zelfde map). Repo niet aangeraakt, geen `probe_job.txt` geschreven. G = GEMETEN (gezien in een
genoemde bron met datum), A = AFGELEID.

Syntax (G): `dg2b_D_luac.py` (deze map) draait `luac -p` met een positieve controle (een kapot bestand geeft rc=1,
"unexpected symbol near <eof>") en laadt het bestand daarna met `lua.exe`: rc=0, geen BOM, 0 fouten in de veldcontrole
(name/tip/src/does 1-3 regels, names alleen strings, loot item/boss/role).

## Wat erin zit

| Map | Dungeon | Bazen | Items | optional | measure |
|---|---|---|---|---|---|
| 109 | Sunken Temple | 9 (1 groep van 6) | 3 | 2 | 1 |
| 230 | Blackrock Depths | 21 (2 groepen) | 3 | 6 | 5 |

Totaal 30 bazen, 6 items. recheck 0, one 0, rare 0, optional 8, measure 6 (G: telling door `lua.exe`).

Geen `recheck`: beide zijn klassieke dungeons en Forever voegde geen bazen toe (G: DB2 heeft dezelfde bazen als Classic
Era 1.15.9.70576). Wel nieuw in Forever, zie "Wat Forever veranderde".

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): wago.tools `DungeonEncounter` build 1.60.1.70959, enUS + 6 locales (`scratch dg_names.py 109,230`; alle
  locale-CSV's 376 rijen). Ter vergelijking Classic Era 1.15.9.70576. `Difficulty` Forever: rij 1, 201 en 215 bestaan,
  rij 0 niet (positieve controle in dezelfde call).
- **WHT** (G): Wowhead Forever tooltip-JSON, `run gamedata npc ... --game forever` (enUS) en met `--locale deDE, frFR,
  esES, esMX, ptBR, ruRU` voor 29 npc's. Items: `run gamedata item ...` + `scratch dg_items.py` (volledige tooltip met
  "Dropped by", cache 18 nov 18:02).
- **WHTC** (G): Wowhead CLASSIC tooltip (`--game classic`) voor 9024, 9041, 8923, 5708, 9476 (rare of niet).
- **WH** (G): Wowhead Forever "The Temple of Atal'Hakkar Dungeon Overview Guide" (published 2026-10-26) en "Blackrock
  Depths Dungeon Overview Guide", beide "By Wowhead Updated: 2026/11/04". Volledige tekst via Exa.
- **CQ** (G): conquestcapped.com (Kir): Sunken Temple "Updated 07 Nov 2026", Blackrock Depths "Updated 17 Nov 2026".
- **MOB** (G): Mobalytics Forever Sunken Temple (PhaseShifter), "Updated on Nov 12, 2026". Algemeen van toon (tank/healer/
  dps-lijstjes). Voor BRD staat er een gids in hun lijst, maar de URL heb ik niet gevonden (drie gokken: CRAWL_NOT_FOUND).
- **IV Forever**: GEEN gids. Het IV-overzicht (Neryssa, "Last Updated: Nov 11, 2026") zegt bij Sunken Temple en
  Blackrock Depths "Coming Soon" (G).
- **IVC** (G): Icy Veins Classic (Abide): Sunken Temple "Last Updated: Apr 11, 2024"; BRD Detention Block en Upper City
  "Nov 18, 2024". Classic-bron.
- **WTC** (G): Warcraft Tavern Forever-pagina's ST en BRD (Luxrah), geen datum, met de zin "This guide is currently based
  on WoW Classic since this instance was not accessible in the WoW Forever Beta". Daarom als Classic-bron geteld.
- **FC** (G): foreverchanges.pro ST en BRD: geeft baas -> item, maar zegt zelf "Nobody has seen these drops yet: the stats
  and chances are Classic's for now". Alleen als Classic-lijst bij loot.
- **CWF** (G): classicwowforever.com ST, "Published 12 Nov Updated 12 Nov". Zijn bronnenlijst: Wowhead (Classic-gids +
  Forever-overzicht). Telt dus niet naast WH; alleen gebruikt voor zijn eigen label "Optional" bij Atal'alarion.
- **WFDB** wowfdb.com ST: verzamelsite, alleen "ook".
- **FDJ** (G): `ForeverDungeonJournal/Data/Dungeons.lua` r.6858-7541 (ST) en r.10092-10911 (BRD), `Data/Bosses.lua`
  r.121-137, 212-240, 519-545, 592-608: kandidaat-npc-id's (alle door WHT bevestigd) en controle. Niets overgenomen.
- Niet geteld: warcraftmaps.com (zegt zelf "Everything below this note is from original Classic"), wythic.com,
  fextralife-wiki, mmonster.co, wowhandbook.com, senseos.gg, azeroth.wiki.

Werkwijze (A): mechaniek staat erin met twee Forever-bronnen (WH + CQ, of WH/CQ + MOB), of met een Classic-bron (IVC,
WTC) die door een Forever-bron bevestigd wordt. Waar alleen de vaardighedenlijst van WH iets bevestigt, staat in `src`
"WH(lijst)".

## Wat Forever veranderde (aan deze twee dungeons)

- **Nieuwe DB2-set voor Sunken Temple** (G): 3582-3589, DifficultyID 0, bestaat niet in Classic Era 1.15.9.70576. De oude
  set 486-493 + 2814 (DifficultyID 201) en de SoD-set 2952-2959 (215, 20 spelers) bestaan in allebei. `encounter` = set 0,
  `encounterAlt` = set 201 (A, zoals Gnomeregan en BFD). Welke ENCOUNTER_START echt geeft: NIET gemeten. De OrderIndex
  van set 0 is een vreemde volgorde (Atal'alarion 0, Avatar 1000, Shade 2000, Hazzas 3000, Morphaz 4000, Weaver 5000,
  Dreamscythe 6000, Jammal'an 7000); ik volg de route van WH en CQ.
- **Flags** (G): alle rijen van map 109 en 230 hebben in Forever Flags 1024, in Classic Era 0. Betekenis niet gezocht.
- **Rare of niet** (G): Pyromancer Loregrain (9024) en Warder Stilgiss (9041) zijn in Wowhead Classic "Rare Elite", in
  Wowhead Forever "Elite". WH (Forever) zet bij Stilgiss "(Rare Spawn)", FC noemt Loregrain "Rare spawn". Niet als `rare`
  gezet; wel `measure`. Panzor (8923) is in beide "Rare Elite".
- **Items** (G, WHT): Kindling Stave 11750 nu +60 spell power (CQ zegt hetzelfde). Nieuw in Forever, met "Dropped by" in
  WHT: Backroom Bulwark 276879 (Phalanx), Brewmancer Nightcap 276877 (Plugger), Savage Gladiator Shoulders 277117
  (Grizzle, zesde stuk van The Gladiator; FC: "Not seen dropping yet"). Alleen als commentaar, niet als loot-regel: hun
  tweede bron is FDJ, en FDJ haalt ze zelf van Wowhead Forever (dus niet onafhankelijk).
- Nieuwe questbeloningen (FDJ + CQ/CWF, niet nagemeten in WHT): ST Leggings of Freedom and Sorrow 270115, Shapeshifter's
  Helm 270117; BRD o.a. Boots of Requite 270120, Ragnar's Favorite Hat 270123, Dark Iron Signet 270119. CQ: nieuwe quest
  Fragment of the Firelands, fragment valt van Magmus (FDJ: item 277129). Niet in de gids opgenomen.

## Keuzes per dungeon

**Sunken Temple.** De zes trollen op de balkons staan als een groep ("Atal'ai Defenders", npc 5714 Loro + extraNpc de vijf
anderen), want alle gidsen behandelen ze zo en ze moeten dood voor Jammal'an. De vier draken staan apart, want DB2 set 0
heeft vier aparte rijen. Ogom (5711) is extraNpc bij Jammal'an (geen eigen rij in set 0 of 201).
Weggelaten: Spawn of Hakkar (5708: WHT en WHTC "Elite", geen rare; CQ noemt hem wel rare; FC heeft zijn buit),
Veyzhak the Cannibal (5399) en Zekkis (5400) (WHT "Rare Elite", maar buiten de portal volgens WH en CWF), Kazkaz the
Unholy (buiten de portal, WH). De Hakkari Bloodkeepers zijn deel van het Avatar-gevecht.

**Blackrock Depths.** Alle 21 DB2-rijen staan erin: elk heeft een quest of bekende buit (regel 3 van de opdracht).
Volgorde = DB2 OrderIndex, behalve The Vault (14500), die naast Warder Stilgiss staat (allebei in de Black Vault).
Weggelaten: Panzor the Invincible (rare, geen quest, buit niet bijzonder), Theldren (alleen met de Banner of
Provocation uit een level-60 questreeks), Overmaster Pyron (WHT: zone 51, 14 spawns, buiten de instance), Verek
(extraNpc bij Stilgiss), High Justice Grimstone (roept de Ring of Law af), de willekeurige Dark Keepers.

`optional` alleen als twee bronnen het zeggen (G): Atal'alarion (CQ + CWF), Avatar of Hakkar (WH + CQ), Loregrain (WH
"optional boss" + FC "rare spawn"), The Vault (WH + CQ: alleen na twaalf kisten), Hurley (WH + WTC), Ribbly (IVC + WTC),
Plugger (WH + WTC), Moira (WH + WTC). WH noemt OOK Roccor, Grebmar, Fineous, Bael'Gar, Incendius, Angerforge en
Argelmach "optional"; maar een bron, dus niet gezet. Flamelash noemt WTC "mandatory".

## Bewust weggelaten omdat de bronnen het oneens zijn

- Jammal'an: kill-volgorde (WH, MOB, IVC: Ogom eerst; CQ: Jammal'an eerst).
- Hazzas + Morphaz: los te trekken of niet (IVC, WTC, CWF: altijd samen; WH: "try not to pull both").
- Shade of Eranikus: wie de slaap krijgt (WH: hoogste threat; IVC: hoogste threat behalve de tank; MOB: ook de tank).
  En CQ zegt dat hij pas aan te vallen is na Jammal'an: maar een bron, weggelaten.
- Watchman Doomgrip: aantal stenen wachters (WTC zegt in dezelfde tekst vier en drie).
- Hurley en Ribbly: eerst de helpers of eerst de baas (IVC tegen WH/WTC).
- Lord Roccor: stun dichtbij (alleen IVC en WTC, Classic; de WH-lijst noemt hem niet).
- Emperor: "roept iedereen in zijn kamer" (alleen IVC).

## Regels met maar een bron

Geen (`one` = 0). Let op: deze regels steunen op een Classic-bron + de vaardighedenlijst van WH, niet op twee
Forever-teksten: Roccor onderbreekt spells; Grebmar sneller; Incendius' vloek en decurse; Stilgiss onderbreken; Phalanx'
vuurballen healen; Argelmach golems eerst; Emperor (vuur, stun, extra slagen) en tank healen; Moira's spells.

## Namen per taal (naamplaatje = Wowhead Forever npc-tooltip, Rob "B")

- Alle `names` komen uit WHT `--locale` (G), behalve de drie groepen zonder eigen naamplaatje: Atal'ai Defenders (DB2
  2954, dat is de 20-speler-set: er is geen 5-speler-rij), Ring of Law (DB2 230) en The Seven (DB2 243). Die drie hebben een
  `measure`. Voor de generator (A): zet 5714 en 9039 in `KEEP_GROUP` als `DG_PLATES` gebruikt wordt (Ring of Law heeft
  `npc = nil`, die slaat de plate-stap vanzelf over). Ter info (G): het naamplaatje van 9039 is per taal Doom'rel /
  Un'rel / Tragi'rel / Doom'rel / Condena'rel / Ruine'rel / Рок'рел.
- **esMX-placeholder** (G): 9476 Watchman Doomgrip esMX = "[Watchman Doomgrip]" -> `esMX = nil`. Geen andere placeholders.
- **encName** (G): DB2 2791 heet "The Vault" (deDE Das Gewölbe, frFR Le Coffre, esES/esMX Las Arcas, ptBR A Caixa-forte,
  ruRU Свод); de baas is npc 9476 Watchman Doomgrip. Dit is A: DB2 heeft een aparte rij voor Stilgiss (233), en WH, CQ,
  IVC en WTC noemen Doomgrip als het gevecht na de twaalf kisten. `measure` staat erin.
- **Naamplaatje wijkt af van de DB2-encounternaam** (G, beide van vandaag):

| npc | baas | taal | naamplaatje (in `names`) | DB2 DungeonEncounter |
|---|---|---|---|---|
| 5720 | Weaver | ptBR | Tecelão | 3587: Tecelã (487: Tecelão) |
| 9018 | High Interrogator Gerstahn | frFR | Grand Interrogateur Gerstahn | Grande interrogatrice Gerstahn |
| 9024 | Pyromancer Loregrain | frFR | Pyromancien Loregrain | Pyromancien Blé-du-savoir |
| 9024 | Pyromancer Loregrain | ruRU | Пироман Зерно Мудрости | Пиромант Зерно Мудрости |
| 9056 | Fineous Darkvire | deDE | Fineous Darkvire | Fineous Dunkelader |
| 9056 | Fineous Darkvire | frFR | Fineous Darkvire | Fineous Sombrevire |
| 9056 | Fineous Darkvire | ruRU | Точень Темнострой | Финий Темнострой |
| 9537 | Hurley Blackbreath | frFR | Hurley Blackbreath | Hurley Soufflenoir |
| 9537 | Hurley Blackbreath | ruRU | Харли Пьянодых | Харли Чернопых |
| 9502 | Phalanx | ruRU | Фаланкс | Фаланг |
| 9543 | Ribbly Screwspigot | deDE | Ribbly Screwspigot | Ribbly Schraubstutz |
| 9543 | Ribbly Screwspigot | frFR | Ribbly Screwspigot | Ribbly Fermevanne |
| 9499 | Plugger Spazzring | deDE | Plugger Spazzring | Stöpsel Zapfring |
| 9499 | Plugger Spazzring | frFR | Plugger Spazzring | Lanfiche Brouillecircuit |
| 8929 | Princess Moira Bronzebeard | frFR | Princesse Moira Bronzebeard | Princesse Moira Barbe-de-Bronze |
| 9476 | Watchman Doomgrip | alle | (zie hierboven) | The Vault |

  Dit past bij wat `dg2nb.py` eerder vond (A): Wowhead Forever toont bij oude bazen vaak de oude (Classic-tijd) naam in
  deDE/frFR/ruRU, DB2 de nieuwere. Welke naam de client op het naamplaatje zet, is NIET gemeten.
- **Alleen apostrof** (G): frFR naamplaatje heeft de rechte ' , DB2 de typografische ’ bij Atal'alarion, Jammal'an le
  prophète, Ombre d'Eranikus, Avatar d'Hakkar en Bael'Gar. Ik zet de rechte (naamplaatje). De generator houdt bij alleen
  een apostrofverschil de oude spelling; hier is er geen oude.
- Positieve controle WHT `--locale` (G): in dezelfde calls gaven Jammal'an (5710) en Shade (5709) precies de DB2-namen in
  alle zes talen (op de apostrof na), en 9476 esMX gaf zichtbaar een placeholder.

## Niet gemeten / open

- Welke encounterset ENCOUNTER_START in Forever meegeeft (ST: 358x of 48x). Of 2791 vuurt voor Doomgrip. Of 230 vuurt
  bij het binnenlopen of bij de baasgolf.
- Of Loregrain en Stilgiss in Forever altijd staan (zie boven).
- Of de groepsnaam (Atal'ai Defenders, Ring of Law, The Seven) de juiste titel in de gids is.
- Item-stats van niet-gekozen items: veel ST- en BRD-buit heeft volgens CQ nog Classic-stats. De zes gekozen items hebben
  WHT "Dropped by" en Forever-stats (G). Smoldering Claw 12243 en Spire of Hakkar 10844 hebben in WHT GEEN "Dropped by"
  (G), daarom niet gekozen. Rollen = A uit de stats.
- Wie welk item mag dragen (client beslist). Geen drop-kansen opgenomen.

## Gereedschap (scratchpad, niet in de repo)

- `dg2b_D_luac.py`: luac -p met positieve controle + laden en tellen met lua.exe.
- Gebruikt, niet aangepast: `dg_items.py` en `dg_names.py` (stap-1-scratchpad, via `_probe.py scratch`).

---

# Deel E: Dire Maul, Blackrock Spire

# Dungeongids Forever, stap 2b, DEEL E: Dire Maul + Blackrock Spire (18 nov 2026)

Bij `dg2b_E.lua` (zelfde map). Repo niet aangeraakt. G = GEMETEN (gezien in een genoemde bron met datum),
A = AFGELEID. Syntax: `luac -p` via `scratch dg2b_E_luac.py` = rc 0 (G); positieve controle in dezelfde run: een
expres kapot bestand gaf rc 1 "unexpected symbol near <eof>" (G). Geen BOM, geen CR. `lua.exe` laadde het bestand en
telde (G): elke baas heeft 1-3 does-regels, tip, src, npc en alle 6 names.

## Wat erin zit

| Map | Vleugel | Bazen | Items | rare | optional | measure |
|---|---|---|---|---|---|---|
| 429 Dire Maul | East | 5 | 3 | - | - | - |
| 429 Dire Maul | North | 7 | 3 | - | - | 1 (Cho'Rush/Gordok) |
| 429 Dire Maul | West | 6 | 3 | 1 (Tsu'zee) | - | 1 (Tsu'zee) |
| 229 Blackrock Spire | Lower | 10 | 3 | 1 (Bannok) | 1 (Urok) | - |
| 229 Blackrock Spire | Upper | 7 | 3 | 1 (Jed) | 2 (Solakar, Goraluk) | - |

Totaal 35 bazen, 15 items. `recheck` 0 (klassiek, geen nieuwe bazen: zie DB2 hieronder). `one` 0. `encounter = nil`
bij 4 bazen (Bannok, Solakar, Goraluk, Jed; G: geen DB2-rij). `extraNpc` 3x: Pimgib 14349, Ferra 14308, Gyth 10339
(G: WHT-naam). Alle npc-id's en itemnamen GEMETEN in WHT Forever, 18 nov 2026.

## Upper Blackrock Spire = 10 spelers (opdracht: "meet dat in DB2")

- G, DB2 Forever 1.60.1.70959 `GroupFinderActivity`: 837 "Upper Blackrock Spire" MaxPlayers **10** (MinLevel 59,
  MaxLevelSuggestion 60, Flags 2, DisplayType 0); 812 "Lower Blackrock Spire" MaxPlayers **5** (55-60, Flags 66).
  Dire Maul 813/814/815 (East/West/North) MaxPlayers 5. Dus `ten = true` in ForeverDungeons.lua klopt.
- G, `MapDifficulty` map 229: DifficultyID 1 MaxPlayers 10 (ID 24, "You must be at least level 48 to enter.") en
  DifficultyID 201 MaxPlayers 10. `Map` 229 MaxPlayers 10, map 429 MaxPlayers 5. Dat geldt voor de HELE kaart 229
  (Lower en Upper zijn een instance); alleen GroupFinderActivity maakt het verschil 5 vs 10.
- G: de levels in ForeverDungeons.lua (DM_E 54-60, DM_N/DM_W 56-60, LBRS 55-60, UBRS 59-60) zijn precies de
  GroupFinderActivity MinLevel/MaxLevelSuggestion.
- G, `LFGDungeons` 31 "Lower Blackrock Spire" en 43 "Upper Blackrock Spire": alle getal-kolommen 0 behalve
  ContentTuningID 5239 (beide). Geeft geen groepsgrootte.
- Bijvangst (G): MapDifficulty 429 zegt "You must be at least level **31** to enter." (map 229: 48). Niet nagelopen.
- Bijvangst (G): DM-activiteiten hebben PlayerConditionID 67462; die rij staat NIET in DB2 `PlayerCondition` Forever
  (0 rijen). Wat de voorwaarde is: niet te meten.
- Bronnen zeggen hetzelfde: WTC UBRS ("actually a 10-man instance"), CQ ("up to 10 in Classic; no different cap
  announced for Forever"), warcraftmaps (client data: Lower 5, Upper 10).

## DB2: klassiek, niets nieuws (G)

`DungeonEncounter` MapID 429,229: Forever 70959 en Classic Era 1.15.9.70576 hebben dezelfde 33 rijen, zelfde ID,
naam, DifficultyID (0) en OrderIndex. Verschil alleen `Flags`: Classic 0, Forever 1024 (Immol'thar 349: 1152).
Alle 31 gebruikte Engelse DB2-namen = de Engelse WHT-npc-naam (G, scratch `dg2b_E_names.py`): geen `encName` nodig.
Rijen: DM 343-350, 361-368, 2792 Pusillin, 2793 Lord Hel'nurath, 2794 Tsu'zee; BRS 267-275, 3062 Emberseer,
3063 Rend, 3068 The Beast, 3069 Drakkisath, 3070 Lord Valthalak. Gyth, Solakar, Goraluk, Jed, Bannok: geen rij.

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G) wago.tools, zie hierboven. **WHT** (G) Wowhead Forever tooltip-JSON, enUS + 6 locales.
- **WH** (G) Wowhead Forever: Warpwood Quarter/East, Capital Gardens/West, Gordoks Commons/North "Updated 2026/11/04";
  LBRS en UBRS (Paryah) "Updated 2026/11/06". De UBRS-tekst noemt nog "Phase 5" (= overgenomen uit Classic).
  Fout in de WH-North-tekst (G): "King Gordok is a caster ... interrupt his Heal" hoort bij Cho'Rush; niet gebruikt.
- **CQ** (G) conquestcapped (Kir): Dire Maul "Updated 07 Nov 2026", LBRS "Updated 07 Nov 2026", UBRS "Updated
  16 Nov 2026"; UBRS-sleutelgids (Dmitro) 16 nov. Let op (A): CQ volgt soms de volgorde/woorden van WH
  (Hydrospawn "burn him or AoE the adds" staat in beide). Ik heb CQ als aparte bron geteld zoals stap 2a, maar waar
  het kon staat er een derde bron bij.
- **WTC** (G) Warcraft Tavern Forever (Luxrah), DM East/West/North, LBRS, UBRS; geen datum; elke pagina zegt zelf
  "based on WoW Classic since this instance was not accessible in the WoW Forever Beta" -> Classic-bron.
- **IVC** (G) Icy Veins Classic (Abide) DM East + LBRS, "Last Updated: Nov 18, 2024". Classic.
- **WMC** (G) warcraftmaps.com (Miisuto): BRS-gids "Updated 30 Oct 2026" (build 70938), DM-gids (datum niet gezien);
  beide "everything below this note is from original Classic". Classic.
- **FC** (G) foreverchanges.pro: DM East/West/North "Nobody has seen these drops yet: the stats and chances are
  Classic's for now"; LBRS "9 bosses, 7 rare spawns", "13 of the 93 drops have been seen in game"; UBRS "7 bosses,
  1 rare spawn", "21 of the 89". Geen datum zichtbaar. Alle 15 gekozen items staan bij de juiste baas.
- **FDJ** (G) `ForeverDungeonJournal/Data/Dungeons.lua` r.8607-8913 (DM East/West), 9233-9339 (North),
  11139-11273 (UBRS), 11523-11753 (LBRS): bazenlijsten, `rare = true` (Tsu'zee, Jed, de LBRS-rares), Hel'nurath
  `optional/trackerHidden`, Valthalak en Mor Grayhoof "0.5 Quest Event". Alleen als controle/"ook".
- Niet geteld: wowforeverguides.com (8 nov, verzamelsite), wowforeveraddon.com, mmonster.co ("the tactics here are
  the Classic ones"), wowforever.be, ssegold.com.
- Icy Veins heeft (voor zover gevonden) GEEN Forever-gids voor DM of BRS: de Forever-hub gaf 403 (WebFetch) en een
  lege pagina (Exa); zoeken vond alleen de Classic-gidsen. Bewijst niets.

## Volgorde (A, met bron)

- DM East: route WH + WTC + IVC: Pusillin, Lethtendris, Hydrospawn, Zevrim, Alzzin. DB2 OrderIndex wijkt af (G).
  wowforever.be zet Zevrim voor Hydrospawn; FDJ en CQ volgen DB2.
- DM North: DB2 OrderIndex = route WH/WMC.
- DM West: DB2 OrderIndex (Tendris, Illyanna, Kalendris, Immol'thar, Tortheldrin) = CQ en mmonster; WH en WTC doen
  Kalendris voor Illyanna. Tsu'zee bij Kalendris (WTC, WH, CQ).
- Vleugels East, North, West = volgorde in ForeverDungeons.lua (en de opdracht).
- LBRS: DB2 OrderIndex = route WH/WTC; Bannok op zijn plek (voor Mother Smolderweb).
- UBRS: route WH/CQ: Emberseer, Solakar, Goraluk, Jed, Rend, The Beast, Drakkisath (WH: vaak Beast voor Drakkisath).

## Weggelaten (opdracht punt 3: alleen als ze iets betekenen)

- **Lord Hel'nurath** (14506, DB2 2793): alleen bij de warlock-epic-mountquest (WH, WTC, CQ); een gewone groep komt
  hem niet tegen. warcraftmaps: "Nothing tells us yet how he's reached in Forever."
- **Lord Valthalak** (16042, DB2 3070), **Isalien** (16097, geen rij), **Mor Grayhoof** (FDJ 16080, geen rij):
  opgeroepen met de Brazier uit de Dungeon Set 2-questketen (WH, CQ, WTC). CQ: Valthalak-buit "the Forever database
  does not list his loot yet".
- **Zes LBRS-rares** (WHT "Rare Elite", G): Spirestone Butcher 9219, Spirestone Battle Lord 9218, Spirestone Lord
  Magus 9217, Crystal Fang 10376, Ghok Bashguud 9718, Burning Felguard 10263 (komt soms uit een warlock-portaal).
  Geen quest; buit gewoon. Bannok Grimaxe wel opgenomen: Plans: Arcanite Reaper (WH, CQ, WTC, IVC).
- **Old Ironbark** (11491) en **Mizzle the Crafty** (14353): geen gevecht; staan in de tekst van Alzzin resp. Gordok.

## Twijfels en tegenstrijdigheden (niet in de tekst gezet)

- **Tsu'zee rare?** WTC, CQ, WH ("silver elite"), FDJ: rare. WHT (G): "Elite", niet "Rare Elite"; wel een DB2-rij.
  `measure` staat erin (zelfde geval als Ragglesnout in 2a).
- **Cho'Rush + King Gordok** = een gevecht met twee DB2-rijen (367, 368). Twee aparte bazen gemaakt, beide met
  "same fight" in de tekst; `measure` bij Cho'Rush (welk ENCOUNTER_START-id vuurt).
- **Urok Doomhowl**: WHT (G) "Rare Elite", maar alle gidsen: opgeroepen met Omokks hoofd. `optional`, niet `rare`.
- **Bannok-plek**: WH + WTC "tenten voor Mother Smolderweb" (gebruikt); CQ "Hordemar City"; FDJ "near the
  Storehouse"; IVC "Firebrand Legion camp".
- **Zigris**: CQ "blijf in melee (hij schiet casters)", WTC "spread out voor de bom". Weggelaten.
- **Voone**: WH "Cleave", CQ "Throw Axe + Mortal Strike", IVC beide. Geen aanvalsnamen in de tekst.
- **Rend**: start van het event verschilt (WH: tanks bij de noordpoort; CQ: praten met Lord Victor Nefarius).
  Weggelaten. Moment dat Rend eraf springt: WH en WTC 20%, CQ "partway": zonder getal.
- **Tendris**: WH "Entangle is te dispellen", WTC "niet". Wortels weggelaten.
- **Kromcrush**: "melee achter hem" alleen WTC/WMC (Classic): weggelaten.
- **Drakkisath, paniek-vuur**: beschreven door WTC + WMC (beide Classic); WH (Forever) noemt dezelfde spell
  (Conflagration) in zijn lijst, CQ niet. Volgens de regel toegestaan (Forever spreekt niet tegen); zo in `src`.

## Namen per taal (opdracht punt 1: het naamplaatje = WHT --locale)

`names` komen uit WHT (G, 18 nov, alle 35 npc's x 6 locales; esMX bestaat en wijkt 9x af van esES, dus echt een
aparte taal). Vergeleken met DB2 DungeonEncounter per locale (G, alle 7 CSV's 376 rijen):

| npc | taal | DB2 encounter | WHT (gebruikt) |
|---|---|---|---|
| 14326 Guard Mol'dar | deDE | Wache Mol'dar | Wache  Mol'dar (TWEE spaties, staat zo in de WHT-JSON; lua heeft bewust een spatie, controle 2b DE R9) |
| 14325 Captain Kromcrush | deDE | Hauptmann Krombruch | Captain Kromcrush (Engels) |
| 14325 Captain Kromcrush | frFR | Capitaine Kromcrabouille | Capitaine Kromcrush |
| 11490 Zevrim Thornhoof | frFR | Zevrim Sabot-de-Ronce | Zevrim Thornhoof (Engels) |
| 11488 Illyanna Ravenoak | frFR | Illyanna Corvichêne | Illyanna Ravenoak (Engels) |
| 10429 Rend Blackhand | frFR | Chef de guerre Rend Main-noire | Chef de guerre Rend Blackhand |
| 10429 Rend Blackhand | esES | Jefe de Guerra Rend Puño Negro | Jefe de Guerra Desgarro Puño Negro |
| 11487 Magister Kalendris | esES | Magíster Kalendris | Magister Kalendris |
| 9236 Vosh'gajin | ptBR | Caçador Sombrio Vosh'gajin | Caçadora Sombria Vosh'gajin |
| 9816 Pyroguard Emberseer | ruRU | Пиростраж Углевзор | Пиростраж Созерцатель Углей |

- frFR apostrof: DB2 schrijft ’ (Tsu’zee, Immol’thar, Mol’dar, Slip’kik, Cho’Rush l’Observateur, Vosh’gajin,
  Gizrul l’esclavagiste), WHT schrijft '. WHT gebruikt.
- Ook zonder DB2-rij zijn enkele frFR-WHT-namen Engels: Bannok Grimaxe, Goraluk Anvilcrack, Jed Runewatcher.
- A: Wowhead kan voor sommige frFR/deDE-npc's terugvallen op Engels. Of de Franse/Duitse client echt "Zevrim
  Thornhoof" / "Captain Kromcrush" toont: **in het spel te zien** (bouwchat/Rob beslist; ik heb de regel gevolgd).
  Mol'dar: WHT (Forever en Classic) heeft twee spaties, maar in de lua staat EEN spatie ("Wache Mol'dar"). Bewust zo
  gelaten: `names` wordt alleen getoond, niet vergeleken, en een spatie leest beter (controle 2b DE R9, 18 nov).
- Geen placeholders (`[Naam]`) gevonden: geen enkele `nil`.

## Buit (G, volledige WHT-tooltip met "Dropped by")

Id's: DB2 ItemSparse Classic Era 1.15.9.70576 (naam -> id; Forever-ItemSparse mist ze, stap 1) en daarna WHT Forever
(naam, stats, "Dropped by" = de juiste baas). In Classic Era bestaan ook 2280xx-kopieen (Season of Discovery): niet
gebruikt. Per vleugel 3: East 18321 Energetic Rod, 18310 Fiendish Machete (Alzzin), 18311 Quel'dorai Channeling Rod
(Lethtendris); North 18503 Kromcrush's Chestplate, 18526 Crown of the Ogre King, 18524 Leggings of Destruction;
West 18396 Mind Carver (Tortheldrin), 18383 Force Imbued Gauntlets (Illyanna), 18391 Eyestalk Cord (Immol'thar);
Lower 13167 Fist of Omokk, 12653 Riphook (Vosh'gajin), 16718 Wildheart Spaulders (Gizrul); Upper 12602 Draconian
Deflector (Drakkisath), 12940 Dal'Rend's Sacred Charge (Rend), 12926 Flaming Band (Emberseer). Wapentype letterlijk:
Energetic Rod, Mind Carver, Dal'Rend's Sacred Charge = Main Hand; Fiendish Machete = One-Hand. `role` = A.

## Niet gemeten / open

- Of ENCOUNTER_START vuurt en met welk id (vooral Cho'Rush/Gordok, en Rend: Gyth heeft geen rij).
- Of Tsu'zee echt rare is.
- Welke naam de de/fr/es-client toont waar DB2 en WHT verschillen (tabel hierboven).
- WHT heeft voor de DM-bazen 0 spawn-punten en voor BRS 1 punt op 0,0: geen coordinaten.
- Of de Classic-tactieken in Forever kloppen: WTC zegt zelf dat DM en BRS niet in de beta zaten; mmonster
  (7 nov): "no group has posted a Forever run yet". De Forever-bronnen (WH, CQ) zijn van 4-16 nov.

## Gereedschap (scratchpad, niet in de repo)

- `dg2b_E_names.py`: WHT-namen per locale als Lua + verschillen met DB2 (uit de gamedata-cache).
- `dg2b_E_luac.py`: `luac -p` met positieve controle + telling met `lua.exe`.
- Gebruikt van stap 1: `dg_items.py` (volledige item-tooltip).

---

# Deel F: Scholomance, Stratholme

# Bazengids Forever, stap 2b, DEEL F: Scholomance en Stratholme (18 nov 2026)

Bij `dg2b_F.lua` (zelfde map). Repo niet aangeraakt, `probe_job.txt` niet aangeraakt. G = GEMETEN (gezien in een
genoemde bron met datum), A = AFGELEID. Niets is in het spel getest.

Syntax (G): `luac -p` via `scratch dg2b_F_luac.py`: positieve controle (kapot bestand) faalt met rc=1, `dg2b_F.lua`
rc=0, geen BOM. Daarna met `lua.exe` geladen en geteld (zie tabel).

## Wat erin zit

| Map | Dungeon | Bazen | Items | rare | optional | one | measure |
|---|---|---|---|---|---|---|---|
| 289 | Scholomance | 14 | 3 | 0 | 2 (Kirtonos, Kormok) | 1 (Kormok) | 4 |
| 329 | Stratholme, Main Gate | 11 | 3 | 2 (Skul, Forresten) | 4 (Ezra Grimm, Malown, Malor, Hammersmith) | 1 (Hammersmith) | 2 |
| 329 | Stratholme, Service Gate | 8 | 3 | 1 (Stonespine) | 1 (Black Guard Swordsmith) | 0 | 1 |

Totaal 33 bazen, 9 items, 0 recheck (klassieke dungeons), 2 `one`, 3 rare, 7 optional, 7 measure (G, lua-telling).

Volgorde. Scholomance: DB2 OrderIndex (-1000 ... 12000), en die valt samen met de route van IVC, CQ en WH (A),
behalve op een plek: DB2 zet Kormok (-46) voor Ras (-31); de lua zet Kormok na Ras, omdat hij in Ras' kamer wordt
opgeroepen (controle 2b FG R11).
Stratholme: vleugel, daarbinnen de route van WH, CQ en WT(C); DB2 OrderIndex volgt daar de route niet (G: The
Unforgiven 6500, rares en opgeroepen bazen 13000-18000).

## Binnenkomen: Forever tegen Classic (de vraag uit de opdracht)

- **Scholomance** (G, Forever-gidsen; A: niet in het spel bekeken). De deur voor het portaal zit op slot. Open met de
  Skeleton Key (13704; WHT Forever: "Quest Item, Unique") uit de keten "The Key to Scholomance" (Chillwind Camp of The
  Bulwark), Lockpicking 280, een Powerful Seaforium Charge (Engineering 275), of iemand die binnen is trekt de fakkel.
  Bronnen: WH "Updated 2026/11/06", CQ Scholomance 7 nov + CQ Attunements 16 nov, WFG 9 nov (via wowf.io), LFC 15 nov,
  FX 13 nov, MM 10 nov ("the Skeleton Key chain are unchanged in the launch data"). Classic: hetzelfde (IVC, 2024).
  **Geen enkele Forever-bron meldt een verschil met Classic.** Binnen nog een sleutel: de Viewing Room Key van
  Rattlegore (staat in zijn `does`).
- **Stratholme Main Gate** (G): geen sleutel (WFG: "Key needed: No"; CQ).
- **Stratholme Service Gate** (G, Forever-gidsen): op slot. Key to the City (12382; WHT Forever 18 nov: "Dropped by:
  Magistrate Barthilas"), Lockpicking 300, of Seaforium. Wie hem nog niet heeft, gaat de eerste keer door de Main Gate
  naar Barthilas. Bronnen: CQ 7 nov en Attunements 16 nov ("Key to the City, opens the service entrance"), WFG 9 nov,
  wowforeveraddon.com, WT(C), MM(C). Classic hetzelfde. **Geen Forever-bron meldt een verschil**, maar geen enkele
  bron beschrijft een echte Forever-run: daarom `measure` bij Barthilas.
- **Scarlet Bastion (Main Gate), mogelijk verschil** (G voor Classic, open voor Forever): in Classic Era moet de
  Bastion-deur (en de Hoard-deur naar Willey) open met The Scarlet Key uit SM Library of met Lockpicking (IVC, WT(C),
  MM(C) "In Classic the Bastion door needs The Scarlet Key"; in retail verviel dat in 3.2, warcraft.wiki). Geen
  Forever-gids noemt het: WH, CQ, MOB, WFG zwijgen erover, en CQ's sleutellijst (16 nov) noemt The Scarlet Key alleen
  voor SM. Zwijgen bewijst niets: `measure` bij Cannon Master Willey.
- DB2 helpt hier niet (G): `GameObjects` Forever heeft 1526 rijen (positieve controle), maar 0 voor map 289 en 329.
- Forever-wijzigingen die wel vaststaan (G, BLZ hotfixes): 9 nov "Fixed an issue that allowed players to mount inside
  Stratholme"; 13 nov "Defeating Balnazzar should now correctly count toward the Legacy Challenge Master Spelunker";
  13 nov ook een fix voor mobs die in Stratholme onverwacht aggro gaven (bij resurrect).

## Bronnen (gelezen 18 nov 2026)

- **DB2** (G): DungeonEncounter Forever 1.60.1.70959, 7 locales, MapID 289 en 329: 33 rijen. Classic Era 1.15.9.70576:
  dezelfde 33 rijen (namen, id's, OrderIndex); alleen Flags 0 -> 1024.
- **WHT** (G): npc-tooltips Forever voor 34 npc's in 6 locales; item-tooltips volledig via `scratch dg_items.py`.
- **WH** (G): Wowhead Forever-gidsen via Exa: Scholomance 2026/11/06; Stratholme Live en Undead 2026/11/04.
- **MOB** (G): Mobalytics PhaseShifter: Scholomance, Strat Live, Strat Undead, alle drie 13 nov 2026.
- **CQ** (G): conquestcapped Scholomance en Stratholme (Kir, 7 nov), Attunements (Dmitro, 16 nov), Strat Quests (18 nov).
- **WFG** (G): wowforeverguides.com 9 nov; vat wowf.io samen. Telt als EEN bron.
- **FX** (G): fextralife WoW Forever Wiki (Scholomance 13 nov; Strat Main Gate: Ezra Grimm en Malor).
- **LFC** (G): lfcarry Scholomance, 15 nov.
- **WT(C)**, **MM(C)** (G): zeggen zelf dat hun tactiek Classic is. Alleen gebruikt waar een Forever-bron het bevestigt
  of niet tegenspreekt; in `src` staat (C).
- **IVC** (G): Icy Veins Classic. Icy Veins Forever heeft voor beide nog "Coming Soon" (overzicht 11 nov).
- **BLZ** (G): Blizzard hotfix-notes 9-17 nov.
- **FDJ** (G): `Data/Bosses.lua` r.138-211 en r.572-626 (kandidaat-npc-id's; alle door WHT bevestigd),
  `Data/Dungeons.lua` (Scholomance r.7543-8094, Strat Living r.9415-9740, Strat Undead r.9779-10053),
  `Data/DungeonEntrances.lua` r.102-143. Elk feit eruit heeft hier een tweede bron. Niets overgenomen.
- Niet gevonden: een spelersverslag van een echte Forever-run van Scholomance of Stratholme (Exa, gericht gezocht).
  MM schreef 10 nov: "As of November 7 no group has posted a Forever run yet". Dat bewijst niets over vandaag.

## Regels met maar 1 bron (`one = true`)

- Kormok, tip "tank pakt de skeletten, area damage": 1x WT(C). WH en CQ zeggen alleen hoe je hem oproept, MOB heeft
  hem niet.
- Crimson Hammersmith, tip "niet klikken midden in een pull": 1x WT(C) (WFG zegt hetzelfde bij de Black Guard Swordsmith).

## Namen per taal (regel B: naamplaatje = WHT `--locale`)

- Alle `names` uit WHT Forever `--locale` (G, 18 nov). esMX bestaat bij Wowhead (G).
- **Placeholder** (G): Black Guard Swordsmith esMX = "[Black Guard Swordsmith]" -> `nil`.
- **Engels in DB2 anders dan de npc** (G) -> `encName` + `measure`:
  - 2805 "Kirtonos" = npc 10506 "Kirtonos the Herald" (DB2 zegt in ALLE 7 talen alleen Kirtonos/Киртонос).
  - 2810 "Ras Frostwhisperer" = npc 10508 "Ras Frostwhisper".
- **Per taal: DB2-encounternaam anders dan het naamplaatje** (G; in de Lua staat het naamplaatje):
  - deDE: Kirtonos (DB2 "Kirtonos"); Marduk Blackpool (DB2 "Marduk Schwarzborn").
  - frFR: Kirtonos (DB2 "Kirtonos"); Hearthsinger Forresten (WHT Engels, DB2 "Chanteloge Forrestin"); Baron Rivendare
    (WHT Engels, DB2 "Baron Vaillefendre"); Instructor Malicia (WHT "Instructeur", DB2 "Instructrice"); Stonespine
    (WHT "Echine-de-pierre", DB2 "Échine-de-pierre"); Nerub'enkan en de Swordsmith (DB2 krul-apostrof ’, WHT recht ').
    WHT Classic frFR geeft dezelfde Engelse namen voor Forresten en Rivendare (G): Wowhead mist hier geen Forever-data,
    de oude creature-namen zijn zo. Welke de client toont: niet gemeten.
  - esES: Kirtonos; Marduk (WHT "Marduz Pozonegro", DB2 "Marduk Pozonegro": lijkt een tikfout bij Wowhead, A);
    Ras (WHT "Ras Levescarcha", DB2 "Ras Murmuhielo"); Malicia (WHT "Instructor", DB2 "Instructora"); Crimson
    Hammersmith (WHT "Forjador de martillos carmesí", DB2 "Forjamartillos Carmesí").
  - esMX: Kirtonos; Black Guard Swordsmith (WHT placeholder, DB2 "Armero Guardia Negra").
  - ptBR: alleen Kirtonos.
  - ruRU: Kirtonos; Timmy the Cruel (WHT "Тайлер", DB2 "Тимми Беспощадный": staat in zijn `measure`); Malicia (WHT
    "Коварница", DB2 "Коварнесса"); Jandice (WHT "Джандис Баров", DB2 "Джандис Барова"); Illucia (WHT "Баров",
    DB2 "Барова"); Polkelt (WHT "Сказитель", DB2 "Хранитель знаний"); Ras (WHT "Снегошепот", DB2 "Ледяной Шепот");
    Crimson Hammersmith (alleen hoofdletter: "Легиона" / "легиона").
- Positieve controle WHT `--locale` (G): Rattlegore deDE "Blutrippe" = DB2; Ras deDE "Ras Frostraunen" = DB2.

## Keuzes en twijfels

- **Timmy the Cruel**: WHT zegt "Rare Elite" (G), maar WT(C), WFG, MM(C) en FDJ zeggen dat hij komt als Crusaders'
  Square leeg is. `rare` niet gezet; `measure`. CQ noemt het plein "market square".
- **Jandice Barov**: niet `optional`. WT(C) en IVC zeggen optioneel/vaak overgeslagen, WFG (wowf.io) "Skippable: No".
- **Marduk Blackpool en Vectus**: niet `optional`, wel `measure`. WT(C) en IVC: neutraal, meestal overgeslagen zonder
  Dawn's Gambit; WFG: niet over te slaan; MOB: studenten eerst neutraal.
- **Malor the Zealous**: `optional` op MM(C) + FDJ. Nieuw in Forever (G): eigen buit 276397 Hand of the Zealous,
  276398 Scarlet Malice, 276399 Plate of the Scarlet Bastion (WHT "Dropped by: Malor the Zealous"; CQ en FX noemen
  ze ook). WH (4 nov) en MM zeiden nog "geen eigen buit": ouder dan WHT.
- **Ezra Grimm**: nieuw in Forever (G, WHT 18 nov): 276394 Luxurious Smoking Jacket, 276395 Grimm's Packing Gloves,
  276396 Ezra's Seal of Authenticity, alle drie "Dropped by: Ezra Grimm". WH (4 nov) en MM zeggen "geen eigen buit".
  Alleen WHT + FDJ: daarom niet als item opgenomen. De quest heet in CQ (7 nov) "The Great Fras Siabi", in MOB, WT en
  CQ-quests (18 nov) "The Great Ezra Grimm": in de tekst staat daarom alleen "a quest from Smokey LaRue".
- **Crimson Hammersmith en Black Guard Swordsmith**: WH, WT(C), WFG en MM(C): komen als iemand de Blacksmithing Plans
  aanklikt. CQ (7 nov) zegt "als je zijn kamer nadert / zijn plek passeert". Meerderheid gevolgd; verschil hier genoteerd.
- **Postmaster Malown**: FDJ zegt dat de brievenbussen open gaan met de Key to the City; WH, CQ, WT(C), WFG zeggen:
  sleutels van de Stratholme Courier. Meerderheid gevolgd.
- **Baron Rivendare, 45 minuten**: wanneer de klok start verschilt (WT(C), WFG: de Gauntlet-poort; CQ: als je de
  dode kant binnengaat). Daarom zonder startmoment.
- **Kill-volgorde Lord Alexei Barov** verschilt (WT(C) Barov eerst, MOB de wachters eerst): niet in de tip.
- **Jandice-kopieën**: CQ en WFG zeggen area damage, WH zegt "You can't AoE them down": weggelaten.
- **Getallen weggelaten** waar bronnen verschillen: Krastinov-enrage (50% / onder de helft / "laat"), Dathrohan wordt
  Balnazzar ("rond" / "op" de helft / geen getal), Timmy-enrage (WFG 20%, rest geen getal).
- **WH-fout** (G): bij Kirtonos geeft WH de vaardigheden van de Blood Steward; niet gebruikt. WH's Lady Illucia-tekst
  breekt af en loopt over in Gandling.
- **Bastion-sleutel**: zie "Binnenkomen". **Service Gate-sleutel**: idem.

## Weggelaten bazen (bewust)

- Scholomance: Blood Steward of Kirtonos (14861, WHT Demon Elite, geen DB2-rij; trash-elite die de Blood of Innocents
  draagt: staat in de Kirtonos-tekst) en Death Knight Darkreaver (14516, geen DB2-rij; alleen paladin-/shaman-
  klassequest).
- Stratholme: Jarien and Sothos (16101/16102, geen DB2-rij; Dungeon Set 2), Stratholme Courier (geen DB2-rij; sleutels
  bij Malown), Balzaphon (alleen tijdens een event, WH).

## Buit: wat niet is opgenomen en waarom

- Deathcharger's Reins 13335 (G): WHT Forever "Mount (Account-wide)", maar GEEN "Dropped by" in de tooltip. CQ, MOB en
  WH noemen hem bij Baron Rivendare. Niet als item opgenomen (regel: "Dropped by" in WHT).
- Hammer of the Grand Crusader 18717 en Demonshear 13348: WHT zonder "Dropped by" (CQ: vallen ook van trash).
- MM (10 nov) noemt twee nieuwe Forever-questitems: "Headmaster's Records" (Gandling) en "Grain Shipment Records"
  (Baron). 1x MM, item-id's niet gevonden: niet opgenomen, niet gemeten.

## Niet gemeten / open

- Alle 7 `measure`-vragen in de Lua (namen Kirtonos en Ras, Marduk/Vectus optioneel, Timmy rare + ruRU-naam, Bastion-
  sleutel, Service Gate-sleutel).
- Of `ENCOUNTER_START` in Forever vuurt, en met welke id.
- Rol per item = A uit de stats; wie het mag dragen beslist de client.
- Of de tactiek in Forever klopt: geen enkele bron beschrijft een echte Forever-run (zie Bronnen).

---

# Deel G (nieuw in Forever): Blackmaw Hold, The Shaper's Terrace

# Dungeongids Forever, stap 2b, DEEL G: Blackmaw Hold en The Shaper's Terrace (18 nov 2026)

Bij `dg2b_G.lua` (zelfde map). Repo niet aangeraakt. G = GEMETEN (gezien in een genoemde bron met datum),
A = AFGELEID. Syntax: `luac -p` via `scratch dg2b_G_luac.py`: controlebestand faalt (rc=1, "unexpected symbol near
<eof>"), `dg2b_G.lua` rc=0, geen BOM, geen CR; daarna met `lua.exe` geladen en geteld (G).

## Wat erin zit

| Map | Dungeon | Bazen | Items | one | measure |
|---|---|---|---|---|---|
| 2974 | Blackmaw Hold (nieuw) | 10 (7 met DB2-rij + 3 rares) | 3 | 3 | 2 |
| 3001 | The Shaper's Terrace (nieuw) | 11 (alle met DB2-rij, 1 rare) | 3 | 4 | 3 |

Totaal 21 bazen, 6 items. `recheck = true` op alle 21 bazen en alle 6 items. 4 rares. Geen `optional` (zie open
punten). Alle 18 DB2-rijen van beide maps zitten erin (G: DungeonEncounter MapID=2974,3001 = 18 rijen).

## DB2-controle: 5 spelers en factie (G, build 1.60.1.70959, 18 nov 2026)

- **5-speler-dungeon, allebei.** Map 2974 en 3001: InstanceType 1 (party). MapDifficulty: 2974 rij 5941
  (DifficultyID 1) en 6344 (201), 3001 rij 6015 (1) en 6345 (201), alle vier MaxPlayers 5. Geen 10-speler-rij.
  GroupFinderActivity 1979 (Blackmaw) en 1978 (Shaper's): MaxPlayers 5. Map.MaxPlayers zelf is 0 (ook bij 2998).
- **Geen factieslot.** LFGDungeons 3268 (Blackmaw) en 3267 (Shaper's): Faction -1 (Ragefire 3: 0).
  GroupFinderActivity PlayerConditionID 0 bij allebei; positieve controle in dezelfde run: Ragefire 798 = 923,
  Stockades 802 = 924. Gidsen zeggen hetzelfde: beide facties, zelfde ingang (CQ, MMN, WFA, undying).
- Let op (G): LFGDungeons.MapID is in Forever 0, ook bij Ragefire; filter daar op naam, niet op MapID.
- DungeonEncounter: alle 18 rijen DifficultyID 0 (MapDifficulty kent alleen 1 en 201). Eén set per map, dus
  geen `encounterAlt`. Welk id ENCOUNTER_START meegeeft: niet gemeten.
- Levels (G, uitleg A): GroupFinderActivity MinLevel 55 / MaxLevelSuggestion 60 (Blackmaw) en 58 / 60 (Shaper's).
  ContentTuning 4550 (Blackmaw) MinLevelSquish 55, 7033 (Shaper's) 60. Twee sites (topbuilds, metammo) zeggen
  daarom "Shaper's pas vanaf 60 naar binnen". MH zegt min 58 (`ForeverDungeons.lua` r.93). Of CT 60 een
  toegangseis is: NIET gemeten (Ragefire heeft CT 13 maar de toegangstekst zegt level 10).
- Vlaggen zonder bekende betekenis (G): GroupFinderActivity Flags 66 (Blackmaw, net als RFC) en 2 (Shaper's).
  DungeonEncounter Flags 1024, maar 1028 bij Behemoth en Varrox en 1152 bij Unbound Spirit. Bit 4 betekent hier
  NIET "optioneel": Varrox (laatste baas) heeft hem ook (stap 1 dacht dat bij Highland Horror).
- Subzones (G, AreaTable): Blackmaw (16554) Defiled Peak, Festering Grotto, Blackmaw Grove, Blackmaw Stillwater,
  Bonesnout's Thicket. Shaper's (16667) o.a. Pillar of Assimilation, Lost Tar Pits, Walk of Communion.
  Ik gebruik in `does` geen subzone-namen (dan hoeft de vertaler geen clientnamen op te zoeken).

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): zie boven; plus DungeonEncounter in 7 locales.
- **DBS** (G): DB2 Spell-teksten die de baas noemen: Writhing Mass 1302780 ("summoning a Flesh Maggot" in
  Withermaw), Imps! 1243318, Profane Bulwark 1277406 ("The Satyr's rituals empower Bonesnout ... per stack"),
  Profane Protection 1247237 (totems beschermen de Unbound Spirit), Best Served Cold 1244493/1245095 (Clawbert,
  100% heal, "Enraged"), Crimson Wrest 1246453/1246456 ("Forced to walk towards Varrox and unable to act"),
  Nightmare Detonation 1246362 (ontploffen + poel), Nanaya-slam 1290463 (stun rond haar). Bewijst dat de spell in
  de client staat, niet dat de baas hem nu gebruikt (A).
- **WHT** (G): npc- en item-tooltips, ook `--locale` deDE/frFR/esES/esMX/ptBR/ruRU; items volledig via
  `scratch dg_items.py` (cache 18 nov 18:03).
- **WT** Warcraft Tavern: Blackmaw (Luxrah) en Shaper's; geen datum zichtbaar. De rijkste bron voor beide.
- **MOBU** Mobalytics Uncas, Blackmaw "Updated on Nov 16, 2026". Uncas' YouTube-video (zoekfragment) zegt ook
  "interrupt the behemoth's roar"; zelfde auteur, telt niet apart. Voor Shaper's heeft Mobalytics alleen een lege
  questpagina (Graysfordays, 3 nov).
- **MMN** mmonerds Blackmaw (Fred the Purifier), "Updated Nov 17 2026". Zijn vaardigheden (Writhing Mass,
  Profane Bulwark, Nightmare Detonation) kloppen met DBS, dus waarschijnlijk uit de Wowhead-database; zijn tactiek
  is eigen tekst. In stap 2a volgde mmonerds Wowhead-gidsen; voor Blackmaw bestaat geen Wowhead-gids (Serenal,
  overzicht 15 nov: "not much information"), dus hier tel ik MMN mee (A).
- **CQ** conquestcapped: Blackmaw (Kir) "Updated 08 Nov 2026": vrijwel geen tactiek ("Boss guides do not exist
  yet"). Shaper's (Dmitro) toont "Updated 05 Nov 2026", maar de tekst zegt "nine days later" (dus ca. 13 nov).
- **HBW** halfbakedwarcraft (Brondulf, 5 nov): beschrijving van Blizzards Launch Overview (3 nov). De video zelf
  NIET bekeken.
- **BLZ** Blizzard news: "Explore the New Dungeons" (20 okt): Shaper's = kristallen uit Un'Goro bij consoles.
  Hotfixes (pagina 16 nov, regel 9 nov): Vitrix, Snowtalon, Cinder geven nu buit; Cinder verschijnt na het
  Archival Panel.
- **REX** forever.rexas.tools (verzamel-addon, 1 kill per baas), **WFA** wowforeveraddon.com, **MMO** mmonster.co
  (10 nov), **IVDB** db.icy-veins.com (King Op: Rare Elite, Gorilla).
- **FDJ**: `Data/Dungeons.lua` r.5957-6856 (bazen, npc-id's, item-id's, quests), `Data/Bosses.lua` r.19-42 en
  690-722 (levels, npc-id's). Alleen feiten, telkens met tweede bron. FDJ heeft voor deze twee dungeons GEEN
  mechaniek-teksten. King Op en Clawbert staan er niet in.
- Niet geteld (volgen anderen, G door vergelijken): wowfdb.com (zinnen van WT), apocanow, undying.app (15 nov) en
  gametruth (13 nov) volgen CQ, epiccarry volgt WT/MOBU, manlepnote volgt WT; warcraftmaps, wythic: verzamelsites.
- Icy Veins: overzicht 11 nov zegt "Coming Soon" voor Blackmaw; geen gids gevonden voor beide. Wowhead: geen
  dungeongids gevonden. Reddit/forum: niets bruikbaars gevonden (zegt niets).

## Volgorde

- Blackmaw: drie grove-bazen in DB2-volgorde (Withermaw, Impaan, Bonesnout), dan de hold in de route die WT en
  MOBU allebei geven (Unbound Spirit, Bloodmane, Behemoth, Varrox); rares achteraan. Varrox = laatste baas (WT,
  MOBU, FDJ; CQ: zijn kill telt voor Master Spelunker). wythic noemt een andere kill-volgorde (slow-fall-shortcut
  naar de Behemoth, WT beschrijft die ook).
- Shaper's: DB2 OrderIndex (eindigt netjes op Nanaya 8000). Geen vaste route (WT).

## Namen per taal (2b-regel: het naamplaatje = WHT `--locale`)

Vergeleken met DB2 DungeonEncounter per taal (G, regel voor regel naast elkaar gelegd):

| Baas | Taal | WHT (in de Lua) | DB2 |
|---|---|---|---|
| Impaan (3316) | frFR | Diablaan l'Enfermeur | Diablaan l’Enfermeur (alleen de apostrof) |
| Bonesnout (3322) | frFR | Muflos l'Indompté | Muflos l’Indompté (alleen de apostrof) |
| Thunderhoof (3500) | esES | Pezuña Trueno | Pezuñatrueno |
| Thunderhoof (3500) | esMX | Cascotrueno | Pezuña Trueno |
| Direhorn Matriarch (3507) | esES | Matriarca cuernoatroz | Matriarca Cuernoatroz (hoofdletter) |
| Ravasaur Hunters (3499) | allen | zie hieronder | Ravasaurusjäger / Ravasaures chasseurs / Ravasaurios cazadores / Cazadores ravasaurios / Ravassauros Caçadores / Равазавры-охотники |

De andere 13 encounter-namen (18 rijen min deze 5): WHT = DB2 in alle zes talen. Rares hebben geen DB2-rij: alleen WHT.

- **Ravasaur Hunters** (`encName`): twee naamplaatjes, Tor'Rel 261811 en Izha'Rel 253218 (WHT "Normal").
  WHT zet alle drie de raptor-items op "Dropped by: Tor'Rel" (G), dus `npc` = Tor'Rel, `extraNpc` = Izha'Rel
  (FDJ gebruikt 253218 als hoofd-id). Tor'Rel: deDE/frFR "Tor'Rel", esES/esMX/ptBR/ruRU placeholder "[Tor'Rel]".
  Izha'Rel: overal "Izha'Rel", ruRU "Изха'рел". Mijn keuze (A): `name` = "Tor'Rel & Izha'Rel", `names` alleen
  deDE/frFR; de andere vier ontbreken (geen vertaling van Tor'Rel). **Keuze voor de bouwchat/Rob**: (a) zo laten,
  (b) de DB2-encounternaam per taal (alle zes bekend), (c) alleen "Tor'Rel". `measure` staat erin.
- WHT esMX gaf bij 269104, 250034 en 262127 (en ptBR bij 247231) een extra Engelse regel onder de naam; het
  naamveld zelf is vertaald. Betekenis van die regel: niet uitgezocht.
- frFR-apostrof: WHT heeft ' , DB2 ’. Wat de client op het naamplaatje zet: niet gemeten.

## Regels met maar 1 bron (`one = true`)

- Blackmaw rares (3x): tip "niets bijzonders, nauwelijks sterker dan gewone mobs" 1x WT.
- Titanosaur: staart-knockback 1x CQ; "packs eerst" 1x WT.
- Tor'Rel & Izha'Rel: extra raptors aan het eind 1x WT; "Tor'Rel eerst" 1x WT.
- King Op: tip zonder bron (eerlijke regel, zoals Kroog in 2a). Rare + gorilla wel 2x.
- Vitrix: "slaat hard" 1x WT, "gif op melee" 1x CQ, tip stuns 1x CQ.

## Weggelaten (1 bron, of tegenstrijdig)

- Blackmaw: vierde rare "Mopes" (alleen MMN, geen npc-id gevonden); Clawbert-npc-id (niet gevonden; naam niet in de
  tekst, wel in `src` en `measure`); naam van de elder bij Unbound Spirit (alleen WT); Withermaw ziektes (alleen WT)
  en "lava" (CQ uit de Blizzard-video; HBW hoorde "larvae", en WT/MOBU/DBS zeggen maden: A, CQ verhoorde zich
  waarschijnlijk); aantal ritualisten "vier" (alleen WT); Bloodmane "devotees eerst" (alleen WT) en wolven doden
  of niet (MOBU en MMN zeggen het tegengestelde); Behemoth stun-brul na het opeten (alleen WT); Varrox onderbreken
  (alleen MOBU); plekken van de rares (alleen WT).
- Shaper's: thunderclap (CQ), nature resistance bij Thunderhoof (WT), stomp van Venomridge (CQ), bloeding van de
  Direhorn (CQ), Bolt immuun voor Nature (CQ), Bolt bij Venomridge (WT), Snowtalon wegdraaien (WT) en "kristallen
  stillen" (CQ), Stone Guardians bij de pilaar (WT; CQ alleen in een fotobijschrift), Titanosaur-route over de weg
  (WT), "Crimson Devilsaurs" (HBW uit de Blizzard-video; geen DB2-rij, onbekend).

## Niet gemeten / open (`measure` en meer)

- **Vitrix en Nanaya** (`measure`): WT zegt dat het groene paneel voeden zonder Vitrix te doden genoeg is; CQ zegt
  dat Nanaya pas komt als alle vier de console-bazen dood zijn. En "groen = Vitrix" is bij CQ alleen wegstrepen.
  De Nanaya-tekst zegt daarom alleen "als alle vier de panelen gebruikt zijn".
- **Hoeveel bazen verplicht** (Shaper's): WT "maar vijf van de tien nodig", maar niet welke. Daarom geen `optional`.
  Blackmaw: Impaan kon in opgenomen runs overgeslagen worden (wythic); ook geen `optional`.
- **Unbound Spirit** (`measure`): MMN noemt vuurspreuken en een onkwetsbare fase; WT en MOBU alleen het totem-gevecht.
- **Clawbert** (`measure`): geen npc-id, geen clientnaam per taal.
- **Thunderhoof esES/esMX** en **Ravasaur Hunters**: zie Namen (`measure`).
- Bolt: CQ "gorilla", WFA "storm raptor" (statistiek-icoon is een gorilla volgens wowforeverguides): niet in de tekst.
- Of de Shaper's-toegang level 58 of 60 is (zie DB2-controle).
- Wie welk item mag dragen (rol = A uit de stats). Drop-kansen niet opgenomen.

## Buit (G: WHT "Dropped by", volledige tooltip)

- Blackmaw: 280063 Bloodfur Bulwark (Withermaw, schild), 280057 Robes of Dark Summons (Impaan, stof, +21 spell
  damage and healing), 280059 Tuskblade Halberd (Bonesnout, polearm +14 Agility). Tweede bron: MMN, REX, WFA.
- Shaper's: 280023 Nanaya's Control Spire (Nanaya, staf +72), 280018 Hammer of Thundering Hooves (Thunderhoof,
  +24 Strength), 280014 Raptorscale Bulwark ("Dropped by: Tor'Rel", schild). Tweede bron: CQ, REX.
- Niet gekozen: 280027 Crownroar Chestplate en 280031 Sparklance Wand hebben bij WHT geen "Dropped by" (G).

## Gereedschap (scratchpad, niet in de repo)

- `dg2b_G_luac.py`: `luac -p` met negatieve controle, laadt de Lua met `lua.exe` en telt.
- Gebruikt uit stap 1: `dg_items.py` (volledige item-tooltip uit de cache).

---

# Naamplaatje-meting (stap 1 + 2a)

# dg2_names_B -- naamplaatje (Wowhead Forever npc-naam) vs `names` in ForeverDungeonGuideData.lua

Gemaakt 2026-11-18 door scratchpad `dg2nb.py`. Bron naamplaatje: GEMETEN, Wowhead Forever tooltip-JSON
(`nether.wowhead.com/forever/tooltip/npc/<id>?locale=xxXX`, via `tools/gamedata.py`, cache 2026-11-18 15:30 .. 2026-11-18 17:58).
Bron `nu`: het `names`-veld in `Modules/ForeverDungeonGuideData.lua` (gelezen 2026-11-18).

## Aantallen

- Bazen in het bestand: 148; met npc: 147 (147 unieke npc's); zonder npc (overgeslagen): 1 -- Lordaeron Captain (regel 122)
- Gemeten naam-cellen (npc x taal, niet-nil): 882 van 882
- Verschillen totaal: 91

| taal | verschillen |
|---|---|
| deDE | 13 |
| frFR | 50 |
| esES | 9 |
| esMX | 1 |
| ptBR | 1 |
| ruRU | 17 |

Soort verschil: alleen apostrof 23, alleen hoofdletters 6, alleen soort spatie (nu U+0020+U+0020+U+0020, plaatje U+00A0+U+00A0+U+0020) 1, anders 61

## Verschillen

| npc | baas | taal | nu | naamplaatje | soort |
|---|---|---|---|---|---|
| 11520 | Taragaman the Hungerer | frFR | Taragaman l’Affameur | Taragaman l'Affameur | alleen apostrof |
| 11518 | Jergosh the Invoker | frFR | Jergosh l’Invocateur | Jergosh l'Invocateur | alleen apostrof |
| 250631 | The Abandoned | frFR | L’Abandonné | L'Abandonné | alleen apostrof |
| 250657 | Rath'mael | frFR | Rath’mael | Rath'mael | alleen apostrof |
| 3671 | Lady Anacondra | ruRU | Леди Анакондра | Повелительница Анакондра | anders |
| 5775 | Verdan the Everliving | frFR | Verdan l’Immortel | Verdan l'Immortel | alleen apostrof |
| 5775 | Verdan the Everliving | ruRU | Вердан Вечноживущий | Вердан Бессмертный | anders |
| 644 | Rhahk'Zor | frFR | Rhahk’Zor | Rhahk'Zor | alleen apostrof |
| 647 | Captain Greenskin | deDE | Kapitän Grünhaut | Captain Greenskin | anders |
| 647 | Captain Greenskin | esES | Capitán Verdetez | Capitán Verdepel | anders |
| 646 | Mr. Smite | deDE | Handlanger Pein | Mr. Smite | anders |
| 646 | Mr. Smite | frFR | M. Châtiment | M. Smite | anders |
| 646 | Mr. Smite | esES | Don Mamporro | Sr. Golpin | anders |
| 645 | Cookie | deDE | Krümel | Cookie | anders |
| 645 | Cookie | esES | Cocinitas | El Chef | anders |
| 3914 | Rethilgore | deDE | Rotkralle | Rethilgore | anders |
| 3914 | Rethilgore | frFR | Rethiltripe | Rethilgore | anders |
| 3887 | Baron Silverlaine | deDE | Baron Silberlein | Baron Silverlaine | anders |
| 3887 | Baron Silverlaine | frFR | Baron d’Argelaine | Baron d'Argelaine | alleen apostrof |
| 3887 | Baron Silverlaine | ruRU | Барон Сильверлейн | Барон Сребролен | anders |
| 4278 | Commander Springvale | deDE | Kommandant Grüntal | Kommandant Springvale | anders |
| 4278 | Commander Springvale | frFR | Commandant Printeval | Commandant Springvale | anders |
| 4278 | Commander Springvale | ruRU | Командир Спрингвейл | Командир Ручьедол | anders |
| 4279 | Odo the Blindwatcher | frFR | Odo l’Aveugle | Odo l'Aveugle | alleen apostrof |
| 4279 | Odo the Blindwatcher | esES | Odo el vigía ciego | Odo el Cegato | anders |
| 1666 | Kam Deepfury | deDE | Kam Tiefenzorn | Kam Deepfury | anders |
| 1666 | Kam Deepfury | frFR | Kam Furie-du-fond | Kam Deepfury | anders |
| 1663 | Dextren Ward | esES | Dextren Ward | Dextren Tutor | anders |
| 4887 | Ghamoo-ra | frFR | Ghamoo-Ra | Ghamoo-ra | alleen hoofdletters |
| 4887 | Ghamoo-ra | esES | Ghamoo-Ra | Ghamoo-ra | alleen hoofdletters |
| 4830 | Old Serra'kis | deDE | Alter Serra'kis | Old Serra'kis | anders |
| 4830 | Old Serra'kis | frFR | Vieux Serra’kis | Vieux Serra'kis | alleen apostrof |
| 4832 | Twilight Lord Kelris | frFR | Seigneur du Crépuscule Kelris | Seigneur du crépuscule Kelris | alleen hoofdletters |
| 4829 | Aku'mai | frFR | Aku’mai | Aku'mai | alleen apostrof |
| 247032 | Lyn the Ignored | frFR | Lyn l’Ignoré | Lyn l'Ignoré | alleen apostrof |
| 246020 | Shade of the Archmage | frFR | Ombre de l’archimage | Ombre de l'archimage | alleen apostrof |
| 6235 | Electrocutioner 6000 | frFR | Électrocuteur 6000 | Electrocuteur 6000 | anders |
| 6235 | Electrocutioner 6000 | ruRU | "Электрошокер-6000" | Электрошокер 6000 | anders |
| 6229 | Crowd Pummeler 9-60 | frFR | Disperseur de foule 9-60 | Faucheur de foule 9-60 | anders |
| 6229 | Crowd Pummeler 9-60 | ruRU | "Толпогон 9-60" | Толпогон 9-60 | anders |
| 7800 | Mekgineer Thermaplugg | frFR | Mekgénieur Thermojoncteur | Mekgénieur Thermaplugg | anders |
| 7800 | Mekgineer Thermaplugg | ruRU | Анжинер Термоштепсель | Мекжинер Термоштепсель | anders |
| 4424 | Aggem Thorncurse | frFR | Aggem Malépine | Aggem Mantépine | anders |
| 4428 | Death Speaker Jargba | esES | Portavoz de la muerte Jargba | Médium Jargba | anders |
| 4420 | Overlord Ramtusk | ruRU | Властитель Злоклык | Властитель Таранный Клык | anders |
| 4422 | Agathelos the Raging | frFR | Agathelos le Déchaîné | Agathelos l'Enragé | anders |
| 4421 | Charlga Razorflank | deDE | Charlga Klingenflanke | Charlga Razorflank | anders |
| 3983 | Interrogator Vishas | frFR | Interrogateur Vislar | Interrogateur Vishas | anders |
| 4543 | Bloodmage Thalnos | ruRU | Волшебник крови Талнос | Волшебник Крови Талнос | alleen hoofdletters |
| 3975 | Herod | frFR | Hérode | Herod | anders |
| 3975 | Herod | ruRU | Ирод | Герод | anders |
| 4542 | High Inquisitor Fairbanks | deDE | Hochinquisitor Schönufer | Hochinquisitor Fairbanks | anders |
| 4542 | High Inquisitor Fairbanks | frFR | Grand inquisiteur Fairbanks | Grand Inquisiteur Fairbanks | alleen hoofdletters |
| 3977 | High Inquisitor Whitemane | deDE | Hochinquisitorin Weißsträhne | Hochinquisitor Whitemane | anders |
| 3977 | High Inquisitor Whitemane | frFR | Grande inquisitrice Blanchetête | Grand Inquisiteur Whitemane | anders |
| 258905 | Zul'Alai | frFR | Zul’Alai | Zul'Alai | alleen apostrof |
| 258924 | Var'Taka | frFR | Var’Taka | Var'Taka | alleen apostrof |
| 263886 | Primeval Elemental | frFR | Élémentaire primitif | Elémentaire primitif | anders |
| 260243 | Min'loth the Serpent | frFR | Min’loth le Serpent | Min'loth le Serpent | alleen apostrof |
| 260468 | "Pyromancer" Braxton | frFR | « Pyromancien » Braxton | « Pyromancien » Braxton | alleen soort spatie (nu U+0020+U+0020+U+0020, plaatje U+00A0+U+00A0+U+0020) |
| 7355 | Tuten'kash | frFR | Tuten’kash | Tuten'kash | alleen apostrof |
| 7356 | Plaguemaw the Rotting | esES | Faucepeste el Podrido | Fauzpeste el Putrefacto | anders |
| 7357 | Mordresh Fire Eye | frFR | Mordresh Œil-de-Feu | Mordresh Oeil-de-feu | anders |
| 7358 | Amnennar the Coldbringer | frFR | Amnennar le Porte-Froid | Amnennar le Porte-froid | alleen hoofdletters |
| 258964 | Nar'gurk | deDE | Nar'gurk | Nar'guk | anders |
| 258964 | Nar'gurk | frFR | Nar’gurk | Nar'gurk | alleen apostrof |
| 6906 | The Lost Dwarves | deDE | Die verschollenen Zwerge | Baelog | anders |
| 6906 | The Lost Dwarves | frFR | Les nains perdus | Baelog | anders |
| 6906 | The Lost Dwarves | esES | Los enanos desaparecidos | Baelog | anders |
| 6906 | The Lost Dwarves | esMX | Los enanos desaparecidos | Baelog | anders |
| 6906 | The Lost Dwarves | ptBR | Os Anões Perdidos | Baelog | anders |
| 6906 | The Lost Dwarves | ruRU | Потерянные дворфы | Бейлог | anders |
| 7023 | Obsidian Sentinel | frFR | Sentinelle d’obsidienne | Sentinelle d'obsidienne | alleen apostrof |
| 7206 | Ancient Stone Keeper | frFR | Ancien gardien en pierre | Ancien Gardien des pierres | anders |
| 7206 | Ancient Stone Keeper | ruRU | Древний каменный хранитель | Древний Хранитель Камня | anders |
| 7291 | Galgann Firehammer | frFR | Galgann Martel-de-Feu | Galgann Firehammer | anders |
| 4854 | Grimlok | frFR | Grimelok | Grimlok | anders |
| 7795 | Hydromancer Velratha | ruRU | Гидромантка Велрата | Гидромант Велрата | anders |
| 7273 | Gahz'rilla | frFR | Gahz’rilla | Gahz'rilla | alleen apostrof |
| 8127 | Antu'sul | frFR | Antu’sul | Antu'sul | alleen apostrof |
| 7271 | Witch Doctor Zum'rah | frFR | Féticheur Zum’rah | Sorcier-docteur Zum'rah | anders |
| 7796 | Nekrum Gutchewer | frFR | Nekrum Mâchentrailles | Nekrum Mâchetripes | anders |
| 7275 | Shadowpriest Sezz'ziz | frFR | Prêtre des ombres Sezz’ziz | Prêtre des ombres Sezz'ziz | alleen apostrof |
| 7275 | Shadowpriest Sezz'ziz | ruRU | Жрец Тьмы Шезз'зиз | Темный жрец Шезз'зиз | anders |
| 7267 | Chief Ukorz Sandscalp | ruRU | Вождь Укорз Песчаный Череп | Вождь Укорз Песчаная Плешь | anders |
| 13282 | Noxxion | frFR | Noxcion | Noxxion | anders |
| 12225 | Celebras the Cursed | ruRU | Келебрас Проклятый | Селебрас Проклятый | anders |
| 12203 | Landslide | ruRU | Обвал | Сель | anders |
| 13601 | Tinkerer Gizlock | frFR | Bricoleur Kadenaz | Artisan Gizlock | anders |
| 255997 | Tidemistress Ca'zass | frFR | Maîtresse des marées Ca’zass | Maîtresse des marées Ca'zass | alleen apostrof |
| 256236 | The Questioner | frFR | L’Interrogateur | L'Interrogateur | alleen apostrof |

## Niet te meten (nil: geen vertaling op Wowhead, placeholder of geen data)

Niets: elke npc gaf in elke taal een echte naam.

## Twijfels en notities

- **The Lost Dwarves (npc 6906)**: het naamplaatje van npc 6906 is *Baelog* (alle talen, ruRU Бейлог) -- GEMETEN. Dit is een groepsbaas (extraNpc 6907, 6908 niet gemeten). De groepsnaam vervangen door 'Baelog' verandert de betekenis; AFGELEID advies: deze ene baas apart beslissen (groepsnaam houden of drie namen).
- **Klassieke bazen, deDE/frFR/ruRU/esES**: de meeste 'anders'-regels zijn oude (Classic-tijd) namen op het naamplaatje tegen nieuwere (retail) namen in `names`. GEMETEN 2026-11-18 voor 647, 646, 3914, 4542 in deDE: Wowhead Forever = Wowhead Classic (Captain Greenskin, Mr. Smite, Rethilgore, Hochinquisitor Fairbanks), Wowhead retail = de `names`-waarde (Kapitän Grünhaut, Handlanger Pein, Rotkralle, Hochinquisitor Schönufer). Of Wowhead Forever die namen echt uit de Forever-client haalt of van Classic overneemt, is NIET gemeten; alleen de client beslist (bv. één blik op Kapitän/Captain Greenskin op een Duitse client).
- **Apostrof (23x, alleen frFR)**: `names` heeft de typografische ’ (U+2019), Wowhead de rechte ' (U+0027). Welke de client op het naamplaatje toont, is niet gemeten (Wowhead kan normaliseren). Laag belang.
- **« Pyromancien » Braxton (frFR)**: zelfde letters; Wowhead heeft een harde spatie (U+00A0) binnen de « », `names` een gewone. Laag belang.
- **Hoofdletters (6x)** en **É/Œ zonder accent of ligatuur** (frFR Electrocuteur 6000, Elémentaire primitif, Oeil-de-feu): zo staat het op Wowhead Forever; niet in de client nagemeten.
- **ruRU 6235 en 6229**: `names` heeft aanhalingstekens om de naam ("Электрошокер-6000", "Толпогон 9-60"), het naamplaatje niet.
- **Placeholders**: geen enkele van de 147 npc's gaf een '[...]'-naam of een lege naam (882 van 882 cellen echt). Positieve controle dat zo'n placeholder wel herkend wordt: npc 270910 frFR = '[Brinescale Priestess]' in dezelfde cache.
- **Nar'gurk (258964) deDE**: Wowhead Forever zegt *Nar'guk* (zonder r; alle andere talen Nar'gurk). GEMETEN zo; of het een tikfout bij Blizzard of Wowhead is, weet ik niet.
- **Bron van de cache**: alle cellen komen uit gamedata.py's eigen tooltip-cache van vandaag (15:30-17:58). 21 esMX-cellen heb ik zelf opgehaald (`run gamedata npc ... --locale esMX`); de rest stond er al (door gamedata zelf, eerder vandaag) en is wat dezelfde call teruggeeft (cache geldt 3 dagen). deDE heb ik ook zelf door de call gehaald (positieve controle Witherfang 250483 = Welkzahn: klopt).
- **Lordaeron Captain** (regel 122, LORD) heeft geen npc en is overgeslagen.

## Bijzaak: enUS-naamplaatje wijkt af van het `name`-veld

| npc | name (nu) | enUS-naamplaatje |
|---|---|---|
| 6906 | The Lost Dwarves | Baelog |
