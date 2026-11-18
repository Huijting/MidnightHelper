# Bazengids Forever, stap 2a: bronnen per deel (18 nov 2026)

Drie mh-research-helpers (Opus), elk een deel; daarna twee onafhankelijke controles
(`DUNGEONGIDS_CONTROLE2A_A_2026-11-18.md`, `DUNGEONGIDS_CONTROLE2A_BC_2026-11-18.md`): samen 0 FOUT en 23 RISICO.
Alle RISICO's met een tekstreparatie zijn doorgevoerd (33 Engelse regels, opnieuw vertaald), behalve:
- namen per taal (DB2-encounternaam tegenover de npc-naam op het naamplaatje, fr/de/es/ru): keuze voor Rob;
- Gahz'rilla: optie (a) gekozen (2 bronnen), niet (b) (1 bron per deel);
- Celebras-deel (`part`), Krol'dok Ashka-fear, Toof-start, Antu'sul/Obsidian Sentinel "optional": zo gelaten.
De data zelf staat als commentaar per regel in `Modules/ForeverDungeonGuideData.lua` (bronnen per regel).
Hieronder de notities van de drie onderzoekers zoals ze ze schreven (vóór de controles; waar een controle iets
anders zegt, wint de controle).

---

# Deel A: Gnomeregan, Razorfen Kraul, Scarlet Monastery, Razorfen Downs

# Bazengids Forever, stap 2a, deel A: bronnen en open punten (18 nov 2026)

Bij `dg2a_A.lua` (zelfde map). Repo niet aangeraakt, `probe_job.txt` niet gebruikt. G = GEMETEN (gezien in een
genoemde bron met datum), A = AFGELEID.

## Syntaxcontrole

- `tools/lua_syntax_check.py <bestand>` **negeert zijn argument** (G: r.52-57 globt alleen `Addons/`, `Locales/`,
  `Modules/` van de repo). Zijn "Lua syntax OK (390 files)" zegt dus niets over mijn bestand. Voor de bouwchat: het
  argument doet niets.
- Daarom zelf: `scratch dg2a_A_luac.py` draait `luac -p` (C:\Users\RobHu\AppData\Local\Programs\Lua\bin\luac.EXE) op
  `dg2a_A.lua` (G: rc=0, geen BOM), met positieve controle: een opzettelijk kapot bestand gaf rc=1 "unexpected
  symbol near <eof>" (G). Daarna `lua.exe` + `dofile` om te tellen (G, tabel hieronder).

## Wat erin zit (G: geteld met lua.exe)

| Map | Dungeon | Bazen | Items | rare | optional | recheck | one |
|---|---|---|---|---|---|---|---|
| 90 | Gnomeregan | 6 | 3 | 1 | 0 | 0 | 0 |
| 47 | Razorfen Kraul | 8 | 3 | 2 | 1 (Roogug) | 0 | 0 |
| 189 | Scarlet Monastery (4 vleugels, `part`) | 11 (GY 5, Lib 2, Arm 1, Cath 3) | 12 (3 per vleugel) | 3 | 0 | 0 | 0 |
| 129 | Razorfen Downs | 6 | 3 | 1 | 1 (Plaguemaw) | 0 | 0 |

Totaal 31 bazen, 21 items, 7 rare, 2 optional, 0 recheck, 0 one.
Geen `recheck`: alle vier zijn klassiek (brief). Forever voegde **geen nieuwe bazen** toe (G: DB2 Forever en Classic
Era 1.15.9 hebben dezelfde rijen), wel nieuwe items (274xxx, zie onder).

Volgorde: DB2 OrderIndex. Rares zonder DB2-rij achteraan (zoals stap 1) bij Gnomeregan en RFK. **Bij SM** volgens de
brief "zoals je ze tegenkomt": de drie Graveyard-rares tussen Vishas en Thalnos (kerkhof; IV, WT, WCALC), Mograine
voor Whitemane. **Afwijking bij RFD**: Glutton (ord 4000) voor Ragglesnout (ord 3000), want je komt Glutton eerst
tegen (WH-volgorde, FDJ "after Mordresh" / Ragglesnout "near the top"; WFG via warcraft.wiki). Let op: bij
Gnomeregan/RFK staan rares dus achteraan, bij SM niet; dat is een keuze voor de bouwchat.

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): wago.tools `DungeonEncounter` build 1.60.1.70959, enUS + 6 locales (elk 376 rijen, uit de cache van
  stap 1, `scratch dg_names.py 90,47,189,129`). Vergeleken met Classic Era 1.15.9.70576.
- **WHT** (G): `run gamedata npc|item ... --game forever` (+ `--locale` deDE/frFR/esES/esMX/ptBR/ruRU voor de 7 npc's
  zonder DB2-rij), volledige item-tooltips met `scratch dg_items.py`. Alle 31 npc-id's en alle 21 items bevestigd.
  Positieve controle `--locale esMX`: geeft een andere naam dan esES (Clamatierras vs Clamor de Tierra Halmgar), dus
  esMX bestaat bij Wowhead (stap 1 dacht van niet).
- **FC** (G): foreverchanges.pro/dungeons/{gnomeregan, razorfen-kraul, razorfen-downs, scarlet-monastery-graveyard,
  -library, -armory, -cathedral}, build 70959, data "as of" 3-11 okt 2026 (per pagina in de Lua-kop).
- **IV** (G): Icy Veins Forever: Gnomeregan, RFK, SM Graveyard, SM Library (Last Updated 18 okt 2026), SM Armory en
  Cathedral (17 nov 2026). **Geen IV-Forever-bazengids voor RFD gevonden** (de URL's `razorfen-downs-guide` en
  `-dungeon-guide` bestaan niet bij Exa; alleen de questpagina, 10 nov 2026). Een leeg resultaat bewijst niet dat hij
  niet bestaat.
- **WH** (G): Wowhead Forever-gidsen direct gelezen (via Exa): Gnomeregan 16 nov, RFK 9 nov, RFD 14 nov, SM Graveyard
  10 nov, Armory 6 nov, Cathedral 10 nov; SM Library alleen als zoekfragment (Jurdi, geen datum gezien).
- **WT** (G): Warcraft Tavern Forever (Luxrah), alle zeven pagina's, geen datum.
- **MOB** (G): Gnomeregan 16 nov, RFK 5 nov 2026. Voor SM alleen questpagina's (12 nov) gevonden; RFD niet gezocht.
  Let op: in de MOB-RFK-tekst ontbreken de koppen boven de baas-alinea's; ik heb ze gekoppeld in de volgorde van
  de inhoudsopgave (Aggem, Jargba, Ramtusk, Agathelos, Charlga). A: dat klopt met de inhoud (boar, mind control,
  Spearhides, enrage, chain lightning).
- Verder: CQ (Gnomeregan, 7 nov), MG (Gnomeregan), UGT (Gnomeregan), GG (SM, 14 okt), SK (RFK, 14 nov), HP (RFD,
  16 nov), WCALC (SM), WFDB (Gnomeregan, SM, RFD-loot), WFG (citeert WH: niet als tweede bron naast WH geteld), IVC
  (Icy Veins Classic RFD, 2024: alleen samen met een Forever-bron).
- **FDJ** (G): `Data/Bosses.lua` r.59-95 (levels) en r.446-489 (npc-id-kandidaten), `Data/Dungeons.lua` r.2530-2734
  (Gnomeregan), r.2842-3097 (RFK), r.3150-3294, 3475-3544, 3641-3676, 3827-3924 (SM), r.4039-4209 (RFD). Gebruikt als
  kandidaat-id's en als derde controle (locaties, Plaguemaw-event, Scarlet Key). Niets overgenomen; elk feit eruit
  heeft een tweede bron in `src`. Alle WHT-levels = FDJ-levels (G).
- **Spoken**: niet nodig gehad (FDJ gaf alle kandidaat-id's, WHT bevestigde ze). Niet geraadpleegd.

## Forever t.o.v. Classic (wat ik zag)

- DB2 (G): alle rijen van deze vier kaarten hebben in Forever `Flags` 1024 (Classic Era 0). Gnomeregan 2768-2772
  hadden in Classic Era DifficultyID 201; in Forever **2768 Grubbis = 1, 2769-2772 = 0** (zelfde patroon als BFD in
  stap 1). Set 2899-2940 (DifficultyID 198, SoD-raid) staat er nog; niet opgenomen.
- Gidsen (G): WT en CQ zeggen dat de gevechten gelijk bleven ("hasn't changed much except loot"; "keeps its Classic
  layout and boss fights"). Mechaniek uit Classic heb ik alleen gebruikt waar een Forever-bron hem bevestigt.
- Nieuwe items (G, FC "New" + WHT): o.a. 274043/274042 (Grubbis), 274068 + 274049 (Crowd Pummeler), 274149/274152/
  274155 (Roogug), 274158/274159 (Aggem), 274161 (Ramtusk), 274160 (Agathelos), 274290 (Vishas), 274291 (Thalnos),
  274292 (Loksey), 274293/274294 (Doan); WHT-only: 274295 (Herod), 274381 (Amnennar). Gekozen in de loot: 274068,
  274158, 274291, 274290, 274293, 274295, 274381.
- Stats veranderd (G, WHT): bv. Hydrocane heeft nu +36 spell power (CQ zegt hetzelfde).

## Regels met maar 1 bron

Geen (`one` = 0). Wat ik daarvoor heb weggelaten (telkens 1 bron of bronnen spreken elkaar tegen):

- Electrocutioner 6000 onderbreken: MOB/CQ/UGT ja, WT/WFDB "kan niet" → niet in de tekst.
- Thalnos onderbreken: IV ja, WT/WFDB nee → weggelaten.
- Jargba kill-volgorde: IV helpers eerst, WH/MOB Jargba eerst → alleen "crowd-control".
- Amnennar's geesten: WH aanvallen, WT ontwijken, IVC negeren → alleen "calls frost ghosts".
- Herod: wanneer hij spint (IV vanaf de helft, GG elke 15-25 s) → geen moment genoemd.
- Viscous Fallout immuun voor frost: WT + WFDB, mogelijk van elkaar overgenomen (bijna dezelfde zin) → weggelaten.
- Viscous Fallout locatie: CQ zegt de gang naar de Grubbis-grot, IV/WH/MOB de benedenvloer → meerderheid gevolgd.
- Agathelos "speelt dood" en "verzegeld door mobs": alleen WT. Fallen Champion "sterker bij weinig leven": alleen IV.
- Fairbanks "fakkel opent de kamer": alleen IV → `measure`.
- Dark Iron Ambassador's vuurschild: IV "immuun voor vuur", CQ "brandt wie dichtbij staat" → weggelaten.
- Blind Hunter "blijf ver weg": alleen WT; de tip zegt alleen "stop met casten" (IV + WH).

## Eigen woorden

Na het schrijven heb ik elke tip naast de gidszinnen gelegd (les uit controle 3, WC_7_T). Tien tips stonden te dicht
bij een zin uit een gids en zijn herschreven: Thermaplugg (CQ), Crowd Pummeler (CQ), Electrocutioner (CQ), Aggem
(IV/WH), Charlga (WH), Azshir (WH), Doan (IV), Tuten'kash (WH), Ragglesnout (WH), Amnennar (HP). A: de rest is
gewone taal ("Interrupt his heal", "Melee stand behind him") die in elke gids voorkomt.

## Namen per taal

- Standaard DB2 per locale (G). Alle Engelse DB2-namen = npc-naam (G), dus **geen `encName`** in dit deel.
- 7 bazen zonder DB2-rij (G: rij ontbreekt): Dark Iron Ambassador, Earthcaller Halmgar, Blind Hunter, Azshir,
  Fallen Champion, Ironspine, **Scarlet Commander Mograine**. Hun `names` uit WHT `--locale`, ook esMX (G). Voor
  Mograine is WHT de enige bron: de Forever-`Creature`-DB2 heeft maar 189 rijen en deze npc's niet (G).
  ptBR Azshir = "Ashir, o Insone" (zo staat het bij WHT, G).
- **WHT deDE wijkt af van DB2** bij drie bazen (G): Charlga "Razorflank" (DB2 Klingenflanke), Fairbanks
  "Hochinquisitor Fairbanks" (DB2 Schönufer), Whitemane "Hochinquisitor Whitemane" (DB2 Hochinquisitorin
  Weißsträhne). Data volgt DB2 (regel). A: Wowhead heeft hier waarschijnlijk oude Classic-namen (zelfde als RISICO 2
  van controle 3). Alleen deDE nagelopen; de andere talen niet.
- DB2 ruRU Electrocutioner 6000 en Crowd Pummeler 9-60 bevatten zelf aanhalingstekens: `"Электрошокер-6000"`,
  `"Толпогон 9-60"` (G); zo overgenomen (in Lua ge-escaped). frFR Tuten’kash met typografische apostrof (G, DB2).

## Niet gemeten / open

- `ENCOUNTER_START` in Forever: niet gemeten (zoals stap 1). **Mograine** heeft geen DB2-rij; het gevecht heet in DB2
  rij 450 "High Inquisitor Whitemane". `encounter = nil` + `measure`. Geen `extraNpc` op Whitemane gezet (Mograine
  heeft een eigen regel; anders lichten bij targeten twee regels op).
- **Ragglesnout rare?** WT, FC, FDJ (en WFG/IVC) zeggen rare; WHT zegt "Elite", niet "Rare Elite" (Forever en
  Classic, G), en hij heeft een DB2-rij (2783). `rare = true` + `measure`.
- **Fairbanks**: hoe je zijn kamer opent (IV: fakkel; FDJ: deur achter de kapel). `measure`. Niet als `optional`
  gemarkeerd: alleen WCALC noemt hem optioneel (WH: "No quest needs him").
- **Grubbis optioneel?** Alleen CQ zegt "optional event boss"; de rest zegt "event met Emi". Niet als `optional`
  gemarkeerd; het event staat in `does`.
- Item-stats: WHT is van vandaag, maar HP (16 nov) meldt dat sommige RFD-items in het spel andere stats hadden dan
  Wowhead (Deathchill Armor, Robes of the Lich; HP spreekt zichzelf ook tegen). Die twee heb ik daarom NIET gekozen.
  Rollen blijven AFGELEID uit WHT.
- Band of Crimson Light (274295, Herod) en Coldbringer Spine (274381, Amnennar): wel WHT "Dropped by" + IV resp.
  WH + WFDB, maar **niet op de FC-pagina** (FC-data van begin oktober). In `src` vermeld.
- Mograine's Might rol "strength/intellect hybrid" = A (IV noemt hem "Strength/Intellect 2H Mace").
- Wie welk item mag dragen beslist de client (rol = A).

## Gereedschap

- `dg2a_A_luac.py` (deze map): `luac -p` + positieve controle + telling met lua.exe. Draaien via
  `_probe.py scratch dg2a_A_luac.py`.
- Hergebruikt uit stap 1 (map bcc6113e...): `dg_names.py`, `dg_items.py`.

---

# Deel B: Uldaman, Zul'Farrak, Maraudon

# Bazengids Forever stap 2a, DEEL B: bronnen en open punten (18 nov 2026)

Bij `dg2a_B.lua` (zelfde map). Repo niet aangeraakt, `probe_job.txt` niet aangeraakt. G = GEMETEN (gezien in een
genoemde bron met datum), A = AFGELEID.

Syntax: `tools/lua_syntax_check.py` negeert een bestandsargument en controleert alleen de addon (G: "390 files").
Daarom zelf `luac.EXE -p dg2a_B.lua`: geen fout (G). Positieve controle: dezelfde luac op `dg2a_brief.md` geeft
"syntax error near 'maakt'" (G).

## Wat erin zit

| Map | Dungeon | Bazen | Items | recheck | one | measure |
|---|---|---|---|---|---|---|
| 70 | Uldaman | 8 | 3 | 1 item | - | 1 (Archaedas) |
| 209 | Zul'Farrak | 12 (8 DB2 + Sergeant Bly + 3 rares) | 3 | 1 item | 3 (de rares) | - |
| 349 | Maraudon | 9 (8 DB2 + 1 rare), met `part` | 4 (één per part) | - | - | 1 (Gizlock) |

Totaal 29 bazen, 10 items. `recheck = true` 2x: alleen de twee items die nieuw zijn in Forever (Dark Golem
Breastplate 274428, Theka's Last Breath 274641). Bazen: klassiek, geen recheck. `optional` 2x (Gahz'rilla, Sergeant
Bly), `rare` 4x (Zerillis, Sandarr Dunereaver, Dustwraith, Meshlok the Harvester).

Volgorde: DB2 OrderIndex, met drie uitzonderingen. (1) Sergeant Bly (geen DB2-rij) staat op zijn plek in het
trappen-event, tussen Sezz'ziz en Ukorz. (2) Rares achteraan (ZF) of achteraan hun part (Maraudon). (3) Maraudon is per
part geordend; in Earth Song Falls staat Gizlock (DB2 1500) na Landslide, en de prinses als laatste (route van WOWF/WFG).

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): wago.tools `DungeonEncounter` 1.60.1.70959, 7 locales (elk 376 rijen). Positieve controle: in dezelfde
  query kwamen RFC 2732-2735 terug. Uldaman 547-549, 551-554, 1887; ZF 593-600; Maraudon 422-429. Classic Era
  1.15.9.70576 heeft precies dezelfde rijen, namen en OrderIndex; Forever veranderde alleen `Flags` 0 -> 1024 (ook bij
  RFC, dus algemeen, niet per dungeon).
- **WHT** (G): alle 33 npc's (bazen + Ruuzlu, Bly, Weegli, rares) in enUS en deDE/frFR/esES/esMX/ptBR/ruRU; alle
  10 items + 9 kandidaten, volledige tooltip met "Dropped by" (via `scratch dg_items.py`). esMX bestaat WEL bij
  Wowhead (G: positieve controle 7023 "Centinela obsidiana" = DB2 esMX, 250660 "El barón").
- **CQ** conquestcapped (Kir): Uldaman + ZF "Updated 07 Nov 2026", Maraudon "Updated 15 Nov 2026". Meest complete
  Forever-bron (noemt ook Forever-statwijzigingen).
- **MOB** Mobalytics ZF (Ruse_Cruize), 12 nov 2026: alleen Antu'sul, Zum'rah, Ukorz, Gahz'rilla. Mobalytics heeft ook
  Uldaman en Maraudon (G: dungeon-lijst), maar de URL vond ik niet (gegokte URL's: CRAWL_NOT_FOUND).
- **WT** Warcraft Tavern Forever: Uldaman (geen datum, "retains the same layout and bosses ... with a few updates to its
  loot"), Maraudon (Luxrah, geen datum, "currently based on WoW Classic since this instance was not accessible in the
  WoW Forever Beta"). ZF-pagina niet gevonden (CRAWL_NOT_FOUND).
- **IVQ** Icy Veins Forever questgidsen Uldaman + ZF, "Last Updated Nov 18, 2026". **IVO** overzicht (11 nov): de
  dungeongidsen voor Uldaman, ZF en Maraudon zijn "Coming Soon" (G). Er is dus GEEN Icy Veins Forever-bazengids.
- **HP** hearthproof ZF (geen datum, na 8 nov). Markeert zelf bijna alles als CLASSIC; bij Antu'sul (chain lightning,
  heal) en Gahz'rilla (Icicle, Freeze Solid) "values new in Forever" (BETA change). Ik noem geen getallen, dus geen effect.
- **IVC** Icy Veins Classic (Abide, 18 nov 2024), **WHC** Wowhead Classic (Maraudon-gids Quissy 2024/11/29;
  Archaedas-commentaren), **BRADY** BradyGames Uldaman-PDF, **CMG** cmangos #2058, **WW** warcraft.wiki: CLASSIC (of
  retail). Alleen gebruikt waar een Forever-bron hetzelfde zegt of niets tegenspreekt; in `src` staat het erbij.
- **WOWF** wowf.io Maraudon, **WFBE** wowforever.be ZF/Maraudon, **AW** azeroth.wiki Uldaman, **EXP** expcarry Uldaman:
  geen datum. EXP is vaag (alleen als tweede bron bij Ironaya).
- **Niet onafhankelijk** (niet meegeteld): WFG (citeert IVC en WOWF), WFDB Uldaman (parafraseert WT: zelfde
  kill-volgorde en tips). WT Forever Maraudon = WT Classic Maraudon (zelfde tekst).
- **Wowhead Forever-gidsen** (Uldaman/ZF/Maraudon, ZF "Last updated 2026/11/14"): inhoud NIET leesbaar via Exa of
  WebFetch (alleen titel/menu). Browser niet gebruikt.
- **FDJ** (feitenbron): `Data/Dungeons.lua` r.4235-4711 (Uldaman), 4712-5254 (ZF), 8116-8469 (Maraudon) en
  `Data/Bosses.lua` (npc-id's). Gebruikt voor: kandidaat-npc-id's (alle door WHT bevestigd), Lost Dwarves alleen Horde,
  Bly als baas, Ruuzlu in het Ukorz-gevecht, mage-quest bij de Sentinel, speler-bevestigde Forever-items. Elk feit heeft
  een tweede bron. Niets overgenomen. FDJ's Maraudon-plekken spreken elkaar en de gidsen tegen (Noxxion "Orange
  (Vyletongue) wing", Celebras "Wicked Grotto", Landslide en Gizlock "Foulspore Cavern"): daar niet gebruikt.
- **Spoken**: niet gebruikt (alle npc-id's direct in WHT gemeten).

## Regels met maar één bron (`one = true`)

- ZF Zerillis: tip "om een hoek trekken" (1x HP).
- ZF Sandarr Dunereaver: tip "casters op afstand" (1x HP).
- ZF Dustwraith: tip "gif weghalen" (1x HP).
Alle andere regels hebben 2 bronnen (zie `src`).

## Weggelaten omdat er maar één bron was of bronnen elkaar tegenspreken

- Ironaya: tank verliest threat bij de knockback (alleen IVC); immuun voor DoT (alleen WT).
- Ancient Stone Keeper: het zand vertraagt en legt spells stil (alleen WT); DoT-immuun (alleen WT).
- Revelosh: eerst de troggs (WT) of eerst Revelosh (CQ): tegenstrijdig, alleen "onderbreken" in de tip.
- Archaedas: WT zegt eerst alle adds dood; CQ + IVC zeggen bij de grote wachters de baas afmaken. Tip volgt CQ + IVC.
  De vier Stone Keepers ontploffen als ze sterven (BRADY + WHC, beide Classic): niet opgenomen (regel al lang).
- Velratha: knockback en frost bolt (alleen HP).
- Sezz'ziz: waar de healer staat (HP/WFBE: op afstand; CQ: dicht bij elkaar).
- Gizlock: IVC Classic zegt casters op afstand, WT + CQ + WHC + WFBE zeggen iedereen achter hem in melee. Tip volgt de vier.
- Theradras: waar de tank haar zet (WT: achterin het platform; CQ: weg van de randen).
- Noxxion: "neem iemand mee die gif weghaalt" (alleen WOWF).
- Getallen (Theka 15 s volgens CQ, 30 s volgens HP; Sentinel 66%/33% alleen WT; Archaedas 66%/33% Classic): weggelaten.

## Formaat-keuzes die de bouwchat moet weten

- **`part` bij Maraudon** (mag van de opdrachtgever): "Orange side" (Noxxion, Razorlash), "Purple side" (Lord
  Vyletongue), "Poison Falls" (Celebras, rare Meshlok), "Earth Song Falls" (Landslide, Gizlock, Rotgrip, Theradras).
  Vier delen zoals WT, WOWF, WFG en WFBE (G). CQ en IVC Classic gebruiken drie (oranje, paars, binnen). Loot heeft ook
  `part` (één item per part).
  - Clientnamen: Forever `AreaTable` heeft geen "Poison Falls", "Wicked Grotto" of "Foulspore Cavern" (G; positieve
    controle met dezelfde filter: "Dustbelch Grotto", "Thunder Falls" gevonden). "Earth Song Falls" staat wel in de
    client, in de tooltip van item 17191 Scepter of Celebras (WHT --locale, G): deDE "Fällen des irdenen Gesangs"
    (datief), frFR "chutes de Chanteterre", esES "Cascadas del Canto de la Tierra", ptBR "Cachoeiras da Canção
    Telúrica", ruRU "Песне Земли" (datief). De andere drie labels moet de vertaler zelf maken.
- **Tinkerer Gizlock, welk deel?** Tegenstrijdig, daarom `measure`. Classic: Earth Song Falls (IVC Inner-gids, WHC,
  WT-tekst "bottom of the ramp ... before Princess Theradras", WW: "Patch 4.0.3a: Moved from Earth Song Falls to the
  Wicked Grotto"). Paars: CQ, WFBE, wowfdb en de retail Journal (G: JournalEncounter 425 UiMapID 280, dezelfde kaart als
  Noxxion/Razorlash/Vyletongue). A: Forever heeft Classic-data voor hem (WHT level 50 = Classic; retail verlaagde naar 35),
  dus waarschijnlijk Earth Song Falls. Niet gemeten.
- **Meshlok, welk deel?** WT, WOWF en WW: bij/boven Poison Falls; FDJ: paarse vleugel; CQ: "between the orange and
  purple sides"; IVC zet hem in de oranje gids. Gekozen: Poison Falls (A).
- **The Lost Dwarves**: één DB2-rij (548), drie npc's. `npc = 6906` Baelog, `extraNpc = 6907` Eric. Olaf (6908) past
  niet in het formaat (één extraNpc). Wie Olaf target, krijgt de gids niet. Voorstel: extraNpc als lijst (codewijziging).
- **Chief Ukorz**: `extraNpc = 7797` Ruuzlu (WHT, G). In Forever heeft Ruuzlu eigen buit (FDJ + CQ), maar geen DB2-rij.
- **Nekrum en Sezz'ziz**: twee DB2-rijen (598, 599), dus twee bazen, al is het één gevecht. De retail Journal voegt ze
  samen ("Nekrum & Sezz'ziz", G), DB2 niet.
- **Sergeant Bly**: geen DB2-rij, `encounter = nil`, `optional = true`. FDJ, HP en CQ behandelen hem als baas.

## Namen per taal

- Bazen met DB2-rij: `names` = DB2 per locale (G). Alle Engelse DB2-namen = WHT npc-naam (G), dus geen `encName`.
- **WHT npc-naam wijkt per taal af van DB2** (G) - zelfde patroon als RISICO 2 van controle 3 (Wowhead heeft waarschijnlijk
  oude Classic-namen, A). Data volgt DB2:
  - frFR (7): Ancient Stone Keeper "Ancien gardien en pierre"/WHT "Ancien Gardien des pierres"; Galgann "Martel-de-Feu"/
    "Firehammer"; Grimlok "Grimelok"/"Grimlok"; Zum'rah "Féticheur"/"Sorcier-docteur"; Nekrum "Mâchentrailles"/
    "Mâchetripes"; Noxxion "Noxcion"/"Noxxion"; Gizlock "Bricoleur Kadenaz"/"Artisan Gizlock".
  - ruRU (6): Древний каменный хранитель/Древний Хранитель Камня; Гидромантка/Гидромант Велрата; Жрец Тьмы/Темный жрец
    Шезз'зиз; Песчаный Череп/Песчаная Плешь; Келебрас/Селебрас Проклятый; Обвал/Сель.
  - deDE, esES, esMX, ptBR: alle gelijk.
  - ptBR "Galnann Martelígneo" (sic) staat zo in DB2 én WHT.
- Bazen zonder DB2-rij (Bly, 3 ZF-rares, Meshlok): WHT --locale, ook esMX (G). Dustwraith heet per taal heel anders:
  deDE "Karaburan", frFR "Ame en peine poudreuse" (zonder circonflexe, zo bij Wowhead), esES "Suciespectro", esMX
  "Ánima de polvo", ptBR "Assombração de Poeira", ruRU "Пыльный призрак". Meshlok ptBR "Meshloc, o Ceifador" (sic).
- **Spelnamen in de teksten** (voor de vertaler; WHT --locale, G; esMX niet gemeten):

  | Item (id) | deDE | frFR | esES | ptBR | ruRU |
  |---|---|---|---|---|---|
  | The Shaft of Tsol (7741) | Der Schaft von Tsol | La Hampe de Tsol | El bastón de Tsol | O Bastão de Tsol | Стержень Тсола |
  | Gni'kiv Medallion (7740) | Gni'kiv-Medaillon | Médaillon de Gni'kiv | Medallón Gni'kiv | Medalhão de Gni'kiv | Медальон Гни'кива |
  | Staff of Prehistoria (7733) | Stab der Prähistorie | Bâton de la préhistoire | Bastón de Prehistoria | Cajado da Pré-história | Посох Древнейшей Истории |
  | Mallet of Zul'Farrak (9240) | Schlaghammer von Zul'Farrak | Marteau de Zul'Farrak | Marra de Zul'Farrak | Marreta de Zul'Farrak | Молот Зул'Фаррака |
  | Divino-matic Rod (8548) | Wünschel-mato-Rute | Bâtonnet divino-matic | Vara Divinomática | Bastão Divinomático | Изыскательский стержень |
  | Celebrian Rod (17702) | Celebriangriff | Bâtonnet de Celebras | Vara de Celebras | Bastão de Celebras | Келебрийский жезл |
  | Celebrian Diamond (17703) | Celebriandiamant | Diamant de Celebras | Diamante de Celebras | Diamante de Celebras | Келебрийский бриллиант |
  | Scepter of Celebras (17191) | Szepter von Celebras | Sceptre de Celebras | Cetro de Celebras | Cetro de Celebras | Скипетр Селебраса |

  Let op (G): ruRU WHT-item zegt "Селебраса", DB2-baas zegt "Келебрас" (zelfde Classic-naamkwestie).
  npc's in de teksten: Weegli Blastfuse = deDE "Weegli Lunte", frFR "Weegli Blastfuse", esES "Weegli Plomofundido",
  esMX "[Weegli Blastfuse]" (Wowhead-placeholder), ptBR "Weegli Pavio Quente", ruRU "Вигиль Фитиль". Ruuzlu = overal
  "Ruuzlu", ruRU "Руузлу". Baelog/Eric/Olaf: deDE Eric "Der Flinke", frFR Eric "l'Agile", esES Eric "El Suave", ptBR
  "Eric, o Veloz", ruRU Бейлог / Эрик "Быстрый" / Олаф.

## Buit (alles G in de volledige WHT-tooltip, 18 nov 2026; rol = A)

- Uldaman: Galgann's Firehammer 9419 (Main Hand mace, +54 spell power; Forever-stats, CQ zegt het ook), Grimlok's Charge
  9416 (Two-Hand polearm, +15 Agi +10 Str +15 Sta), Dark Golem Breastplate 274428 (plate chest, +1% parry; nieuw, FC
  "New", recheck).
- ZF: Theka's Last Breath 274641 (trinket, 6 mana per 5 s; nieuw, FC heeft hem niet want FC-ZF = Classic-lijst; WHT +
  CQ + FDJ-speler-screenshot; recheck), Big Bad Pauldrons 9476 (plate shoulders, +12 Str +12 Sta), Gahz'rilla Fang 9467
  (WHT "One-Hand" dagger).
- Maraudon: Heart of Noxxion 17744 (trinket), Satyr's Lash 17752 (WHT "One-Hand" dagger, +5 Agi), Claw of Celebras
  17738 (WHT "Off Hand" fist weapon), Eye of Theradras 17715 (cloth head, +19 Int +10 Spi).
- Niet gekozen: Zum'rah's Vexing Cane 18082 (WHT heeft GEEN "Dropped by", G); Putridus Wall 275864 (nieuw, maar alleen
  WHT + FDJ); Inventor's Focal Sword 17719 (Gizlock, part onzeker); The Chief's Enforcer 9477 (CQ noemt 56 spell power,
  de WHT-tooltip heeft die NIET, G: tegenstrijdig).
- Wowhead "Dropped by" voor de Gni'kiv Medallion zegt "Baelog 2.63%" (G); WT, CQ, IVC en FC zeggen: de kist in hun kamer.
  De tekst volgt de kist.

## Niet gemeten / open

- Of `ENCOUNTER_START` in Forever vuurt en met welk id (zoals stap 1).
- **Archaedas (`measure`)**: hoeveel spelers moeten de twee altaren klikken? Classic drie (CMG gameobject 130511
  data0=3; Wowhead Classic-commentaar), BRADY zegt "at least four"; CQ: één speler wekt Archaedas; IVC/WFG: iedereen.
  Voor Forever geen bron gevonden.
- **Gizlock (`measure`)**: welk deel van Maraudon (zie boven).
- Alle drie dungeons: de bazengidsen zijn Classic-gebaseerd (WT Maraudon zegt het letterlijk; CQ: "keeps its Classic
  layout"; HP: CLASSIC). Of Blizzard mechaniek veranderde, is per baas niet te zien. Alleen HP meldt nieuwe waarden
  (Antu'sul, Gahz'rilla); ik noem geen getallen.
- Forever-nieuw (G): Ruuzlu heeft eigen buit (FDJ, CQ); Sergeant Bly heeft nieuwe buit (FDJ, CQ); Obsidian Sentinel heeft
  een eigen buitlijst (FC "New", CQ); Ironaya/Archaedas/Ancient Stone Keeper kregen elk een nieuw wapen (FDJ, CQ).
  Bazen zelf: geen nieuwe (DB2 gelijk aan Classic Era).
- Factie (G): alleen The Lost Dwarves (vriendelijk voor de Alliance; WT + FDJ + IVC; WHT-ondertitel "Ironforge").
  Overige bazen: geen factie-beperking gevonden (A, op basis van dezelfde bronnen).
- Wie welk item mag dragen (rol = A).
- Positieve controles in deze run: DB2-query gaf RFC-rijen; luac weigert een niet-Lua-bestand; AreaTable-filter vond
  andere "Falls"/"Grotto"-namen; WHT esMX gaf bekende namen terug.

---

# Deel C (nieuw in Forever): City of Dalaran, The Drowned City, Krol'dok Stronghold, Alcaz Prison

# Bazengids Forever stap 2a, deel C: bronnen en open punten (18 nov 2026)

Bij `dg2a_C.lua` (zelfde map). Repo niet aangeraakt, `probe_job.txt` niet aangeraakt. G = GEMETEN (gezien in een
genoemde bron met datum), A = AFGELEID.

**Syntaxcheck.** `tools/lua_syntax_check.py <bestand>` negeert het argument (G: het script controleert alleen de
390 repo-bestanden en zei "OK"; mijn bestand zat er niet bij). Daarom `luac.EXE -p dg2a_C.lua` direct gedraaid: geen
fout. Positieve controle in dezelfde ronde: `dg2a_C_luac_negtest.lua` (bewust kapot) gaf "'}' expected" (G). Dat
testbestand mag weg.

## Wat erin zit

| Map | Dungeon | Bazen | Items | Bijzonder |
|---|---|---|---|---|
| 2959 | City of Dalaran | 8 (1 optioneel: Lyn) | 3 | DB2 heeft 9 rijen; Mana Wraith (3312) niet opgenomen |
| 2970 | The Drowned City | 9 (1 optioneel, 3 rares) | 3 | 2 Glowing Pearls nodig voor de weg naar Deathless Marrow |
| 3039 | Krol'dok Stronghold | 7 (1 zonder DB2-rij: Bossman Toof; 1 rare) | 3 | DB2 MapDifficulty zegt 10 spelers (zie onder) |
| 2994 | Alcaz Prison | 5 | 3 | Wrex' sleutelbos opent de benedenverdieping |

Totaal 29 bazen, 12 items, 41 keer `recheck = true` (alles). `one = true`: 3 (Braxton, Kroog, Katerina).
`optional`: 2 (Lyn, Primeval Elemental). `rare`: 4 (Umbra, Gill, Braxton, Kroog). `encName` + `measure`: 4
(Mana Elemental, Deathless Guardians, Handler Ashka, Overseer Mugg). Nog 2 `measure` (Min'loth extraNpc, Katerina).
`extraNpc`: Blazeroar = 255707 Zarla Ober (G: WHT; warcraftmaps noemt dezelfde id), Min'loth = 260274 (kandidaat).

Volgorde: Drowned en Krol'dok = DB2 OrderIndex (klopt met de gidsen); rares/Toof zoals de route. Dalaran en Alcaz
NIET DB2-volgorde (G: Dalaran zet Atrexis op 7000 en Lyn op 6000, Alcaz zet Wrex vooraan), maar de route van IV/WH/GS
resp. WH/MOBU (A: zo lopen spelers).

## Echt een 5-speler-dungeon? Factie? (DB2 build 1.60.1.70959, G)

- `Map.InstanceType` = 1 voor 2959, 2970, 2994, 3039 (positieve controle: RFC 389 en Thanes 3065 ook 1).
- `MapDifficulty` DifficultyID 1 (= "Normal", Min/MaxPlayers 5 in `Difficulty`): MaxPlayers 5 voor 2959, 2970, 2994.
  **3039 Krol'dok: MaxPlayers 10** in zowel rij 6144 (DifficultyID 1) als 6145 (DifficultyID 201). RFC 389 heeft ook een
  201-rij met 10. `GroupFinderActivity` 1986 (Krol'dok) zegt wel MaxPlayers 5, en alle gidsen (WT, CQ, WFA, apocanow)
  zeggen 5 spelers. A: restant in de data; niet in het spel gemeten.
- `GroupFinderActivity` 1983/1985/1986/1980: DifficultyID 1, MaxPlayers 5, **PlayerConditionID 0** (RFC 923 en Stockade
  924 zijn factiegebonden) -> open voor beide facties. Levels 28-35, 35-42, 40-47, 48-55.
- `LFGDungeons` 3271/3270/3275/3269: Faction -1 (RFC rij 3: Faction 0). Let op: de kolom MapID is 0 in deze rijen, dus
  `LFGDungeons MapID=...` geeft 0 treffers; zoeken op naam of ContentTuningID werkt.
- `DungeonEncounter`: alle 25 rijen Faction -1, DifficultyID 0 -> geen baas alleen voor Horde of Alliance.
  Flags: Dalaran en Var'Taka/Primeval 1024, de rest 1028. Betekenis onbekend.
- Toegang (gidsen, G): Dalaran: Horde heeft een groepslid met de Dalaran Sewer Key nodig (IV 18 okt, WH 9 nov, GS 2 nov);
  Alliance krijgt de sleutel na "An Alarming Request" (GS); de stad zelf is vijandig voor Horde (IV + GS). Drowned: onder
  water, geen sleutel (CQ). Krol'dok: geen sleutel nodig om binnen te komen (CQ); een Compound Key (quest) en een Ogre Key
  (van Mugg, shortcut) bestaan. Alcaz: zelfde portaal voor beide en geen sleutel om binnen te komen (apocanow; CQ noemt
  geen toegangssleutel); binnen is de trap naar beneden dicht tot je Wrex' sleutelbos hebt (CQ + FDJ).

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): DungeonEncounter in enUS, deDE, frFR, esES, esMX, ptBR, ruRU (25 rijen per taal), plus Map, MapDifficulty,
  Difficulty, LFGDungeons, GroupFinderActivity.
- **WHT** (G): alle baas-npc's, de staging-kopieën en 12 items (volledige tooltip via `scratch dg_items.py`). `--locale`
  voor deDE/frFR/esES/esMX/ptBR/ruRU. esMX werkt wel (positieve controle: 250660 = "El barón", zoals controle 3).
- **IVDB** db.icy-veins.com (via Exa-zoekfragment): welke npc-id de buit heeft: Deathless Marrow 260202, Primeval
  Elemental 263886, Min'loth 260243; Dreadfrost Saber 274603 "Dropped By Captain Dreadrise #260042".
- **FC**: city-of-dalaran (item-id's per baas, "Drops seen in game are as of 2026-10-19", build 70959); alcaz-prison en
  the-drowned-city: geen buit. FC Drowned noemt 260274 als het wezen waarvan de dood telt voor de Legacy-uitdaging.
- **IV** (Neryssa): Dalaran Last Updated Oct 18, 2026; Drowned City Nov 17, 2026. Krol'dok: alleen quests (Nov 11),
  dungeongids "Coming Soon". Alcaz: geen gids gevonden (directe URL bestaat niet bij Exa).
- **WH**: Dalaran (Riyani) 2026/11/09; Drowned (Jurdi) 2026/11/14; Krol'dok (Jurdi) 2026/11/14; Alcaz (Jurdi) 2026/11/15.
- **MOB** Dalaran (PhaseShifter) Nov 12; **MOBU** (Uncas) Drowned Nov 11, Krol'dok Nov 11, Alcaz Nov 16.
- **GS** Dalaran (Aaron Down) 2 nov. **CQ** (Kir) Drowned 7 nov, Krol'dok 8 nov, Alcaz 8 nov. **OL** Drowned (Steven
  Mills) Nov 13. **WT** Krol'dok (Luxrah, geen datum; hele pagina gelezen); WT Drowned: ALLEEN het Exa-fragment gelezen
  (parels + altaar van Marrow). **WFA** (geen datum). **GG** Dalaran 14 okt. **CX** Dalaran 9 okt. **GGA** Krol'dok 7 nov.
- **FDJ**: `Data/Dungeons.lua` (bazen, npc-id's, item-id's, quests), `Data/Bosses.lua` (levels, staging-id's),
  `Core/Journal.lua` r.296-319 (Alcaz: trap naar verdieping 2 met Wrex' sleutelbos; Katerina en Blazeroar op
  verdieping 2). Alleen feiten, elk met een tweede bron; niets overgenomen.
- **Spoken_Bosses** `Data/Bosses.lua`: heeft map 2959 (r.356, zelfde namen als DB2), maar geen rijen voor 2970, 3039,
  2994 (grep `\[(2970|3039|2994)\] = \{` leeg; het formaat klopt, want r.356 is `[2959] = {`; de positieve controle zat
  wel niet in dezelfde grep). Niet gebruikt.
- YouTube: geen video bekeken. GGA en OL citeren video's (Ahmpy, Saucy722, tygarlily); die telden via hun tekst.

### Bronnen die NIET apart tellen (A, op grond van bijna gelijke zinnen)

- method.gg Drowned en Krol'dok = zelfde auteur als WH (Jurdi), zelfde inhoud. **Let op voor stap 1:** daar telde
  "MG (Jurdi)" naast WH voor Ruins of Lordaeron; of WH RoL ook Jurdi is, heb ik niet nagekeken.
- Mobalytics Alcaz (PhaseShifter, 13 nov) volgt CQ zin voor zin ("six to eight Alcaz Jailers", "room fills with fire").
- apocanow (13 nov) volgt WT ("leftmost wall", "beefed-up Centurion") en CQ ("Keep the tank topped up").
- ssegold, mmonerds volgen WH; warcraftmaps citeert CQ; wowfdb is een verzamelsite.
- IV en WH Dalaran beschrijven Arcane Anomaly bijna hetzelfde (tegen de klok in, adds aan de rand). Voor de draaiende
  straal heb ik daarom IV+GS gebruikt; "adds aan de rand" staat alleen in die twee (mogelijk één bron).

## Regels met maar 1 bron (`one = true`)

- Drowned "Pyromancer" Braxton: kopstoot die de tank stunt + tip (1x IV). Rare en plek zijn wel 2x.
- Krol'dok Kroog: geen enkele bron noemt vaardigheden; does zegt alleen "rare", tip zegt eerlijk "No tactics are known
  yet; pull him on his own" (0 bronnen voor het tweede deel, A).
- Alcaz Katerina: tip "Chaplains eerst, ze healen" (1x WH; de rest citeert WH).

## Weggelaten omdat het maar 1 bron had of bronnen elkaar tegenspreken

- Dalaran Lyn: Shadow Bolt Volley onderbreken (IV: kan niet; WFA: wel). Mana Devourer "makkelijk te missen" (expcarry +
  WH-commentaar). Unstable Sentinel "wind-up te stunnen" (GS + WFA: wel 2x, maar niet nodig in de tip).
- Drowned Zul'Alai: welke spell op de tank zit (IV en WH ruilen bij Min'loth ook de namen Drench/Deluge om).
- Krol'dok Zarmok: enrage op 30% (alleen WH/method). Ashka: fear (alleen GGA). Grox: MOBU en CQ zeggen "geen
  vaardigheden", WH en WT noemen gevangenen + stun: die laatste twee zijn gevolgd.
- Alcaz Wrex: Mortal Strike (alleen WH). CQ wil Wrex de gang in trekken, WH en MOBU de kamers eerst leeg: WH+MOBU gevolgd.
  Katerina: gif op de tank (alleen WH); "zware vuurschade op de groep" (alleen CQ) -> `measure`. Blazeroar: "vuur doet
  niets" (alleen CQ; MOB-PhaseShifter kopieert CQ). Moment van de draak: WH 30%, MOBU ~20% -> geen getal.

## Namen-keuzes (bouwchat)

- Standaard DB2 DungeonEncounter per locale (G). Bij `encName` en zonder DB2-rij: WHT `--locale` (G).
- **Vier DB2-rijen hebben een andere Engelse naam dan de npc** (G):
  - 3301 "Mana Elemental" = npc 246016 **"Arcanic Enigma"** (WHT, FC, IV, WH, MOB, GS, FDJ).
  - 3478 "Deathless Guardians" (de adds) = npc 260202 **"Deathless Marrow"** (WHT, IV, WH, OL, Blizzard-hotfix 9 nov via WH).
  - 3453 "Handler Ashka" = npc 259281 **"War Handler Ashka"** (WHT, WH, WT, CQ). MOBU schrijft "Handler Ashka".
  - 3451 "Overseer Mugg" = npc 258968 **"Overlord Mugg"** (WHT, WH, WT, CQ; GGA: naamplaatje in een stream).
- Twijfel: WHT frFR voor Ashka = "Marchande de guerre Ashka" (G, letterlijk "oorlogskoopvrouw"), DB2 frFR = "Dresseuse
  Ashka". Ik volg de regel (npc-naam), maar dit ziet eruit als een vertaalfout bij Blizzard. Meten op een frFR-client.
- deDE "Captain Dreadrise" en "Blazeroar": DB2 deDE en WHT deDE zijn allebei Engels (G). Zarla Ober heet in WHT deDE
  "[Zarla Ober]" (placeholder).
- Bossman Toof frFR "Boss Kof" (WHT + FDJ-commentaar: zelfde naam). Rares Gill/Umbra/Braxton/Kroog: WHT per locale.
- Primeval Elemental en Min'loth: WHT-namen = DB2-namen (positieve controle), op frFR "Elémentaire" vs DB2 "Élémentaire"
  na (accent). DB2 gebruikt.

## Niet gemeten / open

- Of ENCOUNTER_START in Forever vuurt, en met welk id (zoals stap 1).
- **Mana Wraith** (DB2 3312, WHT npc 246931 Elite, 17 spawns in zone 36): geen gids kent het gevecht. Niet opgenomen.
  Misschien een add of weggelaten baas (A). In het spel kijken.
- **Min'loth extraNpc 260274**: WHT "Humanoid (Normal)", geen zone; FC: telt voor de Legacy-uitdaging. Of het de
  slangvorm is: niet gemeten. 260243 heeft de buit (IVDB, G).
- Primeval Elemental: twee npc-id's (263886 Humanoid Elite met buit; 273738 Elemental Elite, geen zone). 263886 gekozen.
- Deathless Marrow: drie id's (260202, 269586, 270885 = staging). 260202 gekozen (zone 16550 + buit).
- Krol'dok MaxPlayers 10 in MapDifficulty (zie boven).
- Katerina: vuur (CQ) of wurgdraad/gif (WH) of rugsteek (MOBU)? `measure`.
- Volgorde Alcaz: de Questioner staat als derde (route WH/MOBU), maar de tip zegt "als laatste doden". Bouwchat mag hem
  ook achteraan zetten.
- WT Drowned is maar als zoekfragment gelezen; als volledige bron niet nagelopen.
- Buit: Dalaran 3 items met FC; de andere 9 items hebben als tweede bron alleen gidsen (CQ, WFA, IV, WH, OL), geen FC.
  Rol = A uit de stats. Shadowlight Athame is **Main Hand** (G), niet one-hand.
- Bazen-levels: niet in de data gezet (WHT geeft geen level).
