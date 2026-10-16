# Mount run: routes in stappen (onderzoek 16 okt 2026)

Alleen onderzoek: geen code veranderd, niets gecommit. Geen web gebruikt; alles komt uit lokale bestanden.
Elke regel zegt of hij **GEMETEN** is (gelezen in bestand:regel) of **AFGELEID** (mijn redenering).
"Gemeten" betekent hier: *gelezen in die bron*. Het is niet in de client nagemeten, behalve waar MH zelf
"Rob gemeten" zegt (Delves.lua).

## 1. Samenvatting

- `ns.MOUNTRUN_RAIDS` (MRD:19-312) heeft **47 rijen** en **45 unieke ingangen**. ANT en ANT_ARGUS delen
  een ingang, BOD en BOD_GMOD ook. GEMETEN.
- **Volledig gedekt: 45.** Elk portaal, elke boot, elke NPC en de ingang heeft een coördinaat uit een lokale
  bron. Stappen als "vlieg naar zone X" hebben geen tussenpunt nodig, want de pijl gaat direct naar het
  volgende punt.
- **Deels: 2.** Dat zijn ANT en ANT_ARGUS (Antorus). Het Lightforged Beacon in Legion Dalaran staat in Zygor.
  Drie dingen ontbreken in beide bronnen: waar Legion Dalaran ligt gezien vanaf Azsuna, de
  navigatieconsole van de Vindicaar, en het afdalen naar de Antoran Wastes.
- **Niet gedekt: 0.**
- **Ingang wijkt meer dan 1.0 af van HandyNotes:** ONY (2.32), HFC (2.11), TOS (1.47) en SOO (1.01, randgeval).
  In alle vier ligt MRD binnen 0.7 van Zygor. Tijdens het spel wint de pin van de client
  (MountRun.lua:137-146). Deze afwijking telt dus alleen als de client geen pin geeft. GEMETEN (getallen),
  AFGELEID (gevolg).
- **De kaart klopt niet altijd met waar het portaal je neerzet** (AFGELEID, belangrijk voor de pijl):
  - T4W en VP staan op kaart 249 (oud Uldum), maar het portaal landt op 1527.
  - SOO staat op 390 (oude Vale), maar de Vale kan ook 1530 zijn.
  - COS en DS wijzen naar de grotmond op Tanaris (71). Het portaal zet je al binnen (74), en de echte
    instance-portalen liggen op 75.
  - Bij Stratholme (Horde) landt het portaal in Tirisfal op kaart 18 of 2070. De bronnen zijn het oneens.
- **MOUNTRUN_HOW-zinnen:** 2 echte mismatches (ZG Horde en DFC "elevator"), 3 twijfelgevallen (SOO Zidormi,
  NP quest of achievement, KARA Horde-richting) en 1 weglating (VA/AOF noemen de toegangsquest niet).
  Zie §3.

### Bronnen (afkortingen in de tabellen)

| Afk. | Bestand | Versie / datum bestand |
|---|---|---|
| ZT | `ZygorGuidesViewer/Libs-Retail/LibRover-1.0/data_transit.lua` | Zygor 9.6, 25-08-2026 |
| ZD | `ZygorGuidesViewer/Libs-Retail/LibRover-1.0/data_dungeons.lua` | 13-10-2026 |
| ZB | `ZygorGuidesViewer/Libs-Retail/LibRover-1.0/data_borders.lua` | 14-08-2026 (vóór S2) |
| ZF | `ZygorGuidesViewer/Libs-Retail/LibRover-1.0/data_floorcrossings.lua` | datum niet gemeten |
| ZM | `ZygorGuidesViewer/Libs-Retail/LibRover-1.0/data.lua` (`MapIDsByName`, regel 14+) | 13-10-2026 |
| ZG | `ZygorGuidesViewer/Guides-Retail/PetsMounts/ZygorMountsAllianceCATA.lua` | 25-03-2026 (oud) |
| HC | `HandyNotes_MapNotes/Nodes/Retail/RetailCapitals.lua` | MapNotes 3.6.9, 07-10-2026 |
| HZ | `HandyNotes_MapNotes/Nodes/Retail/RetailZoneNodesLocation.lua` | 07-10-2026 |
| HD | `HandyNotes_MapNotes/Nodes/Retail/RetailZoneDungeonNodesLocation.lua` | 07-10-2026 |
| HG | `HandyNotes_MapNotes/Nodes/Retail/RetailGeneralZoneNodes.lua` | 07-10-2026 |
| HI | `HandyNotes_MapNotes_Instances/Nodes/InstanceLocations.lua` | 1.3.1, 12-08-2026 (vóór S2) |
| MHD | `MidnightHelper/Modules/Delves.lua` (`MIDNIGHT_PORTALS`) | 14-10-2026 |
| MRD | `MidnightHelper/Modules/MountRunData.lua` | — |
| EN | `MidnightHelper/Locales/enUS.lua` (MOUNTRUN_HOW_*, regels 950-974 en 1000-1021) | — |

Gevonden HandyNotes-mappen: HandyNotes, _MapNotes, _MapNotes_Instances, _RitualSites, _WarWithin,
_TheWarWithin, _DragonflightTreasures, _ShadowlandsTreasures, _WorldOfWarcraft, _WrathOfTheLichKing en
_Midnight. GEMETEN (Glob `HandyNotes*/*.toc`). Alleen MapNotes en MapNotes_Instances hebben portalen en
ingangen. HandyNotes_Midnight heeft alleen portaal-iconen voor rares (grep "portal" gaf 11 treffers, geen route).

## 2. Zygor-zonenamen naar uiMap

Zygor schrijft `Zone/verdieping x,y`. Het uiMap-nummer komt uit Zygor's eigen tabel `data.MapIDsByName`
(ZM). Alles hieronder is GEMETEN op de genoemde ZM-regel.

| Zygor-naam | uiMap | ZM | | Zygor-naam | uiMap | ZM |
|---|---|---|---|---|---|---|
| Stormwind City/0 | 84 | 516 | | Orgrimmar/1 | 85 | 553 |
| Dalaran/1 | 125 | 585 | | Dalaran L/10, /12 | 627, 629 | 629 |
| Tanaris/0, /17, /18 | 71, 74, 75 | 561 | | Shattrath City | 111 | 578 |
| Isle of Quel'Danas | 122 | 876 | | Netherstorm / Terokkar | 109 / 108 | 576 / 579 |
| Deadwind Pass | 42 | 497 | | Northern Stranglethorn | 50 | 511 |
| Dustwallow Marsh | 70 | 540 | | Mount Hyjal | 198 | 760 |
| Uldum / Uldum New | 249 / 1527 | 566 / 466 | | Deepholm | 207 | 870 |
| The Jade Forest | 371 | 598 | | Townlong Steppes | 388 | 604 |
| Isle of Thunder | 504 | 877 | | Kun-Lai Summit | 379 | 600 |
| Vale of E.B. / New | 390 / 1530 | 605 / 467 | | Stormshield / Warspear | 622 / 624 | 619 / 622 |
| Tanaan Jungle / Gorgrond | 534 / 543 | 621 / 613 | | Azsuna / Suramar | 630 / 680 | 626 / 636 |
| Broken Shore | 646 | 627 | | Antoran Wastes /0, /6 | 885, 887 | 625 |
| Krokuun /1 (Vindicaar) | 831 | 633 | | Boralus | 1161 | 402 |
| Zuldazar | 862 | 411 | | Dazar'alor /0, /1 | 1165, 1163 | 412 |
| Tiragarde Sound / Nazmir | 895 / 863 | 405 / 409 | | Oribos /0, /1 | 1670, 1671 | 327 |
| The Maw / Zereth Mortis | 1543 / 1970 | 335 / 369 | | Valdrakken / Thaldraszus | 2112 / 2025 | 277 / 270 |
| The Emerald Dream / Ohn'ahran | 2200 / 2023 | 296 / 264 | | Dornogal / Isle of Dorn | 2339 / 2248 | 154 / 155 |
| The Ringing Deeps | 2214 | 156 | | Azj-Kahet / Nerub'ar /1 | 2255 / 2213 | 158 / 159 |
| Undermine / K'aresh / Tazavesh | 2346 / 2371 / 2472 | 171 / 182 / 181 | | Silvermoon City M | 2393 | 53 |
| Eversong Woods M | 2395 | 42 | | Isle of Quel Danas M | 2424 | 46 |
| The Coiled Isle / Vaults of Atal'Utek | 2512 / 2509 | 124 / 122 | | The Lycaneum | 2649 | 114 |
| Eastern Plaguelands | 23 | 501 | | Tirisfal Glades / "L" | 18 / 2070 | 565 / 376 |
| Ironforge / Deeprun Tram | 87 / 499 | 507 / 498 | | Borean T. / Dragonblight / Howling F. | 114 / 115 / 117 | 583 / 586 / 588 |
| Icecrown / Storm Peaks / Wintergrasp | 118 / 120 / 123 | 590 / 592 / 895 | | Crystalsong Forest | 127 | 584 |

Positieve controle dat "Stormwind City/0" echt 84 is en "Orgrimmar/1" echt 85 (GEMETEN):

- Uldum-portaal in Stormwind: ZT:1641 geeft 75.24,20.50, HC:1197 geeft `nodes[84]` 75.23,20.55.
- Uldum-portaal in Orgrimmar: ZT:1399 geeft 48.87,38.55, HC:132 geeft `nodes[85]` 48.86,38.51.

## 3. MOUNTRUN_HOW: wat niet klopt

Alle 47 HOW-sleutels (EN:950-974 en EN:1000-1021) zijn naast de bronnen gelegd. In de tabel staan alleen de afwijkingen; de rest klopt
(lijst onder de tabel).

| Sleutel (EN) | Zin zegt | Bronnen zeggen | Oordeel |
|---|---|---|---|
| HOW_ZG (EN:1009) | Horde: portaal op de zeppelintoren naar Tirisfal, dan het Grom'gol-portaal | Er gaat een **directe zeppelin** van Orgrimmar 85 52.52,53.15 naar Northern Stranglethorn 50 37.17,52.49 (ZT:2843; HC:146 52.37,53.30). Het portaal Tirisfal→Grom'gol bestaat alleen in de fases Old Undercity en UndercityCharred (ZT:1780, ZT:1850). HOW_KARA (EN:959) gebruikt de directe zeppelin al wel. | **MISMATCH**: omweg. GEMETEN |
| HOW_DFC (EN:1021) | "take the elevator down to the Ringing Deeps" | Vanuit Dornogal zelf ga je via een gat: 2339 38.87,59.81 naar 2214 38.03,28.36 (ZB:336). De liften staan op **Isle of Dorn**, niet in Dornogal, en zitten achter een quest: 2214 49.20,44.59 ↔ 2248 67.35,31.01 (ZT:512, quest 82195) en 2214 61.53,76.95 ↔ 2248 37.41,72.86 (ZT:516, quest 84220). HZ:852-853 bevestigt beide liften. | **MISMATCH** in de woorden. GEMETEN |
| HOW_SOO (EN:968) | "Zidormi switches the Vale to the right time" | Beide fases hebben een ingang: 390 (HD:433; ZD:752) en 1530 (HD:436-437; ZD:753). | **TWIJFEL**: Zidormi is misschien niet nodig. AFGELEID, in-game checken |
| HOW_NP (EN:1013) | tunnel naar Azj-Kahet "(needs a quest)" | ZT:508 noemt een tunnel met quest 78248 of 79573. HC:3386 noemt een *portaal* met achievement 19559. Er is ook een route zonder voorwaarde via de Ringing Deeps (ZB:336 + ZB:343). | **TWIJFEL** over het soort voorwaarde. GEMETEN (bronnen), AFGELEID (oordeel) |
| HOW_KARA (EN:959) | Horde: Grom'gol, "then fly north" | Grom'gol ligt op 50 37.17,52.49 en Karazhan op 42. Deadwind Pass ligt noordoost van Northern Stranglethorn. | **KLEIN**: noordoost, niet noord. AFGELEID |
| HOW_VA, HOW_AOF (EN:1017-1018) | "then the portal to the Coiled Isle", zonder voorwaarde | Het portaal zit achter een quest: 96004 (MHD:288, door MH gecontroleerd) of 96525 (ZT:206). | **WEGLATING**. GEMETEN |
| HOW_ANT (EN:1001) | Beacon in Legion Dalaran, schip naar de Antoran Wastes | Beacon: 627 74.22,49.26 (ZT:2349). Console en afdalen staan in geen enkele bron. | **NIET TE CONTROLEREN** (deels) |
| HOW_COS, HOW_DS (EN:961-962) | zinnen kloppen | Het datapunt in MRD is de grotmond op 71, niet het portaal op 75 (zie §5.12-5.13). | Fout in de **data**, niet in de zin |

Geen afwijking gevonden in: OS, EOE, VOA, ICC, ULDUAR, UP, TK, SETHEKK, MT, RTK, COS, DS, ONY, FL, T4W, TOT,
MSV, HFC, BRF, NH, BOD, AMI, SFO, TOS, ANT_ARGUS, SOD, NYA, BOD_GMOD, STRAT, VP, SC, FH, UR, DOTI, LOU, MFO,
MOQD, WRS en MTN.

- Dit is GEMETEN voor de reisstappen en AFGELEID voor windrichtingen. De windrichtingen zijn bepaald uit de
  coördinaten.
- **Niet gecontroleerd** (geen reisstap): spelclaims in de zinnen, zoals "only while your faction holds
  Wintergrasp", drop-voorwaarden en lockouts.

## 4. Hubs: knooppunten die de code kan hergebruiken

De sleutelnamen zijn een voorstel (AFGELEID). De coördinaten zijn GEMETEN in de genoemde bron. "→" geeft
aan waar je aankomt.

### 4a. Stormwind (uiMap 84). Start voor Alliance.

| Sleutel | Wat → aankomst (uiMap x,y) | x | y | Bron | Voorwaarde (uit de bron) |
|---|---|---|---|---|---|
| SW_ROOM | Portaalkamer (marker HandyNotes) | 48.72 | 87.98 | HC:1204 | – |
| SW_ARRIVE | Plek waar je aankomt bij portalen naar SW | 46.35 | 90.23 | ZT:21 | – |
| SW_P_DALARAN_NR | → 125 55.92,46.79 | 44.36 | 88.71 | ZT:1666 | – |
| SW_P_SHATTRATH | → 111 54.97,40.23 | 44.91 | 85.72 | ZT:1692 | level ≥10 |
| SW_P_COT | → 74 54.60,28.30 | 43.72 | 85.35 | ZT:1674 | – |
| SW_P_JADE | → 371 46.18,85.07 | 45.70 | 87.16 | ZT:1680 | quest 31735 of level ≥40 |
| SW_P_STORMSHIELD | → 622 31.71,52.48 | 41.36 | 89.82 | ZT:1684 | – |
| SW_P_AZSUNA | → 630 47.00,40.89 | 42.08 | 91.34 | ZT:1670 | – |
| SW_P_BORALUS | → 1161 70.62,16.98 | 40.85 | 92.75 | ZT:1688 | – |
| SW_P_ORIBOS | → 1670 20.34,50.31 | 47.55 | 94.98 | ZT:787 | quest 60151 of level ≥50 |
| SW_P_VALDRAKKEN | → 2112 59.55,41.46 | 48.89 | 93.43 | ZT:1700 | quest 67030 |
| SW_P_DORNOGAL | → 2339 41.29,27.45 | 48.13 | 91.95 | ZT:451 | level ≥70 + quest 80321 of 79573 |
| SW_P_SILVERMOON | → 2393 52.85,65.51 | 48.77 | 95.23 | ZT:164 | quest 86852 of achievement 41806 |
| SW_E_HYJAL | Earthshrine → 198 63.49,23.37 | 76.20 | 18.69 | ZT:1651 (HC:1199 76.21,18.69) | quest 25316 of level ≥50 |
| SW_E_ULDUM | Earthshrine → 1527 54.90,34.25 | 75.24 | 20.50 | ZT:1644 (HC:1197 75.23,20.55) | – (ZT:1641: naar 249 in de oude fase) |
| SW_E_DEEPHOLM | Earthshrine → 207 48.73,53.56 | 73.19 | 19.65 | ZT:1647 (HC:1200 73.17,19.66) | quest 27123 of level ≥50 |
| SW_TRAM | Deeprun Tram → Ironforge 87 76.93,51.25 | 69.62 | 31.11 | ZT:2878, ZT:2882 | – (HC:1216 zet de "Carriage" op 66.78,34.55) |
| SW_SHIP_BOREAN | Boot → 114 59.68,69.41 | 18.02 | 25.84 | ZT:2869 (HC:1212 18.12,25.55) | – |

AFGELEID: de Zygor-coördinaten van de losse portalen liggen tussen x 40.85-48.89 en y 85.35-97.45. De marker
van HandyNotes (48.72,87.98) ligt aan de rand daarvan. Of dat één grote kamer is, is niet vastgesteld.

### 4b. Orgrimmar (uiMap 85). Start voor Horde.

HC:129 zegt welke portalen op de begane grond staan en welke in de kelder:

- **Begane grond:** Valdrakken, Oribos, Razorwind Shores, Dornogal, Jade Forest, Dalaran (Northrend),
  Silvermoon (Midnight).
- **Kelder:** Silvermoon (oud), Azsuna, Zuldazar, Shattrath, Caverns of Time, Warspear, Dark Portal.

Dit is GEMETEN. Coördinaten zeggen niets over de verdieping. De pijl-tekst moet dus "boven" of "kelder"
zeggen. Dat laatste is AFGELEID.

| Sleutel | Wat → aankomst | x | y | Etage | Bron | Voorwaarde |
|---|---|---|---|---|---|---|
| ORG_ROOM | Pathfinder's Den (marker HandyNotes) | 57.34 | 89.74 | – | HC:129 | – |
| ORG_ARRIVE | Plek waar je aankomt bij portalen naar Org | 57.10 | 89.81 | – | ZT:43 | – |
| ORG_P_DALARAN_NR | → 125 55.92,46.79 | 56.23 | 91.74 | boven | ZT:1482 | – |
| ORG_P_SHATTRATH | → 111 53.01,49.21 | 57.51 | 91.65 | kelder | ZT:1460 | level ≥10 |
| ORG_P_COT | → 74 54.60,28.30 | 56.40 | 92.56 | kelder | ZT:1449 | – |
| ORG_P_JADE | → 371 28.56,13.98 | 57.46 | 92.28 | boven | ZT:1468 | quest 31769 of level ≥40 |
| ORG_P_WARSPEAR | → 624 44.42,35.53 | 55.18 | 92.05 | kelder | ZT:1453 | – |
| ORG_P_AZSUNA | → 630 47.00,40.89 | 57.23 | 88.21 | kelder | ZT:1446 | – |
| ORG_P_ZULDAZAR | → 1163 71.96,82.78 | 57.89 | 89.84 | kelder | ZT:1456 | – |
| ORG_P_ORIBOS | → 1670 20.34,50.31 | 58.32 | 87.85 | boven | ZT:798 | quest 60151 of level ≥50 |
| ORG_P_VALDRAKKEN | → 2112 59.55,41.46 | 57.11 | 87.30 | boven | ZT:1472 | quest 67030 |
| ORG_P_DORNOGAL | → 2339 41.29,27.45 | 58.58 | 91.36 | **oneens** | ZT:466 | level ≥70 + quest 80321 of 79573 |
| ORG_P_SILVERMOON | → 2393 52.85,65.51 | **56.25** | **88.57** | boven | MHD:163 (**Rob gemeten**); ZT:177 zegt 55.98,88.20 | quest 86852 of achievement 41806 (ZT:179) |
| ORG_E_HYJAL | → 198 63.49,23.37 | 51.13 | 38.28 | – | ZT:1408 (HC:134 51.20,38.32) | quest 25316 of level ≥50 |
| ORG_E_ULDUM | → 1527 54.90,34.25 | 48.87 | 38.55 | – | ZT:1402 (HC:132 48.86,38.51) | level ≥10 |
| ORG_E_DEEPHOLM | → 207 50.59,52.94 | 50.84 | 36.29 | – | ZT:1405 (HC:135 50.86,36.28) | quest 27123 of level ≥50 |
| ORG_Z_GROMGOL | Zeppelin → 50 37.17,52.49 | 52.52 | 53.15 | – | ZT:2843 (HC:146 52.37,53.30) | – |
| ORG_Z_TIRISFAL | Portaal op de toren → Tirisfal 69.30,62.75 | 50.74 | 55.57 | – | ZT:1432 (HC:130 50.76,55.61) | uiMap bij aankomst: ZT zegt 2070 (ZM:376), HC:130 zegt 18. **Oneens** |
| ORG_Z_BOREAN | Zeppelin → 114 41.38,53.61 | 44.75 | 62.30 | – | ZT:2846 (HC:144 44.67,62.39) | – |

Over Dornogal zijn de bronnen het oneens. HC:129 zet het portaal boven. Zygor's opmerking bij ZT:466 rekent
"20s downstairs penality". Dit is GEMETEN.

### 4c. Overige hubs

| Hub | uiMap | Element → aankomst | x | y | Factie | Bron | Voorwaarde / opmerking |
|---|---|---|---|---|---|---|---|
| Dalaran (NR) | 125 | Aankomst | 55.92 | 46.79 | beide | ZT:65 | – |
| Dalaran (NR) | 125 | Kristal naar Violet Stand → 127 15.81,42.85 | 55.93 | 46.77 | beide | ZT:1948 (HC:2658 55.90,46.78) | optioneel |
| Shattrath | 111 | Aankomst A / H | 54.97 / 53.01 | 40.23 / 49.21 | A / H | ZT:1692 / ZT:1460 | – |
| Shattrath | 111 | Portaal → Isle of Quel'Danas 122 48.25,34.48 | 48.57 | 42.02 | beide | ZT:1908 (HC:2433 48.61,42.03) | – |
| Caverns of Time | 74 | Aankomst | 54.60 | 28.30 | beide | ZT:1674, ZT:1449 | – |
| Caverns of Time | 75 | Culling-portaal | 60.11 | 82.72 | beide | HD:56 | ZD:77 zegt 57.40,82.60 |
| Caverns of Time | 75 | Dragon Soul-portaal | 60.87 | 21.15 | beide | HD:112 | ZD:734 zegt 61.97,26.97; ZG:5021 zegt 61.84,26.61 |
| Jade Forest | 371 | Aankomst A / H | 46.18 / 28.56 | 85.07 / 13.98 | A / H | ZT:1680 / ZT:1468 | – |
| Townlong Steppes | 388 | Portaal → Isle of Thunder (A) | 49.74 | 68.67 | A | ZT:1997 (HZ:350) | → 504 64.08,72.48; quest 32644 |
| Townlong Steppes | 388 | Portaal → Isle of Thunder (H) | 50.65 | 73.40 | H | ZT:2037 (HZ:342 50.65,73.39) | → 504 33.25,32.43; quest 32212 |
| Vale (oud / 8.3) | 390 / 1530 | Zidormi | 80.48 / 80.97 | 31.96 / 29.48 | beide | HG:821-822 (ZT:2061) | wisselt de fase |
| Uldum (oud / 8.3) | 249 / 1527 | Zidormi | 56.01 | 35.14 | beide | HG:28-29 | wisselt de fase |
| Stormshield | 622 | Portaal → Lion's Watch 534 57.53,60.32 | 36.38 | 41.15 | A | ZT:2097 (HC:1841 36.23,41.13) | quest 38445 |
| Warspear | 624 | Portaal → Vol'mar 534 60.9,47.3 | 53.16 | 43.91 | H | ZT:2119 (HC:772 53.18,43.84) | quest 37935 |
| Legion Dalaran | 627 | Lightforged Beacon → Vindicaar 831 61.15,81.36 | 74.22 | 49.26 | beide | ZT:2349 | staat niet in HandyNotes |
| Legion Dalaran | 627 | Gloeiend plateau → 629 63.38,23.87 | 49.26 | 47.62 | beide | ZT:2222 (HC:2863 49.32,47.58) | ZT-voorwaarde `IsLegionOn()` |
| Legion Dalaran | 629 | Portaal → Karazhan 42 47.24,75.40 | 31.95 | 71.43 | beide | ZT:1945 | staat niet in HandyNotes |
| Legion Dalaran | 627 | Manapoof → EPL 23 43.23,19.96 | 58.61 | 39.34 | beide | ZT:2206 | quest 56491 |
| Boralus | 1161 | Grand Admiral Jes-Tereth (boot) → Nazmir 863 61.95,39.92 | 67.95 | 26.69 | A | ZT:2961 (HC:2013 67.95,26.70) | quest 51571 |
| Boralus | 1161 | Manapoof → EPL 23 43.23,19.96 | 50.05 | 46.69 | A | ZT:2628 | quest 56491 |
| Dazar'alor | 1163 | Uitgang Hall of Ancient Paths → 1165 | 48.59 | 17.52 | H | HC:971 | – |
| Dazar'alor | 1165 | Manapoof → EPL 23 43.23,19.96 | 56.32 | 30.79 | H | ZT:2696 | quest 56491 + 46931 |
| Zuldazar | 862 | Dread-Admiral Tattersail (boot) → Tiragarde 895 88.20,51.16 | 58.46 | 62.99 | H | ZT:3020 (HZ:653 58.46,62.98) | quest 51800 |
| Oribos | 1670 | Aankomst | 20.34 | 50.31 | beide | ZT:787, ZT:798 | – |
| Oribos | 1670 | Ring of Transference → 1671 (vier stuks) | 52.08 / 52.10 / 57.14 / 47.02 | 57.92 / 42.74 / 50.36 / 50.34 | beide | ZT:816-825 (HC:3045-3048) | – |
| Oribos | 1671 | Lichtzuil → Maw 1543 44.95,40.99 | 49.27 | 50.88 | beide | ZT:840 (HC:3031 49.40,51.27) | – |
| Oribos | 1671 | Portaal → Zereth Mortis 1970 33.27,69.43 | 49.59 | 25.44 | beide | ZT:804 (HC:3033 49.53,25.66) | quest 64957 |
| Valdrakken | 2112 | Portaal → Emerald Dream 2200 50.61,62.50 | 62.60 | 57.42 | beide | ZT:650 (HC:3188 62.72,57.32) | quest 77572 actief of 77887 klaar |
| Ohn'ahran Plains | 2023 | Portaal ↔ Emerald Dream 2200 73.05,52.52 | 18.37 | 52.37 | beide | ZT:647 (HD:728 18.85,51.24) | geen voorwaarde in ZT |
| Dornogal | 2339 | Tunnel/portaal → Azj-Kahet 2255 57.48,41.61 | 63.61 | 52.59 | beide | ZT:508 (HC:3386 63.61,52.05) | ZT: quest 78248 of 79573; HC: achievement 19559 |
| Dornogal | 2339 | Teleportplaat → Undermine 2346 27.83,54.02 | 52.47 | 50.47 | beide | ZT:588 (HC:3388 52.46,50.47) | ZT: quest 83137 of ach. 40900 + level ≥80; HC: quest 86535 |
| Dornogal | 2339 | Spatial Rift → Tazavesh 2472 62.58,94.40 | 40.31 | 22.70 | beide | ZT:481 (HC:3389 40.31,22.67) | quest 84957 |
| Dornogal | 2339 | Gat → Ringing Deeps 2214 38.03,28.36 | 38.87 | 59.81 | beide | ZB:336 | – |
| Silvermoon | 2393 | Aankomst | 52.85 | 65.51 | beide | ZT:164, ZT:177 | – |
| Silvermoon | 2393 | Portaal → Coiled Isle 2512 58.17,48.48 | **56.83** | **67.38** | beide | MHD:288-289 (ZT:206 56.88,67.48) | MH: quest 96004; ZT: quest 96525 |
| Silvermoon | 2393 | Uitgang noord → Isle of Quel'Danas 2424 | 45.73 | 6.48 | beide | HC:3496 | – |
| Silvermoon | 2393 | Uitgangen zuid → Eversong 2395 | 37.44 / 45.66 / 60.98 | 90.41 / 91.45 / 91.77 | beide | HC:3497-3499 | west: 17.87,44.55 (HC:3500) |
| Silvermoon | 2393 | Portaal → The Lycaneum 2649 56.46,14.00 | 47.93 | 51.95 | beide | ZT:199 | quest 96233 |
| Coiled Isle | 2512 | Aankomst / terugportaal | 58.17 / 58.25 | 48.48 / 48.46 | beide | ZT:206 / MHD:294-295 | – |
| Coiled Isle | 2512 | Tunnel oost → Vaults 2509 51.24,82.08 | 45.37 | 64.90 | beide | ZB:367-369 (ZF:16; HD:800 46.86,64.87) | – |
| Coiled Isle | 2512 | Tunnel noord → Vaults 2509 58.36,36.10 | 43.30 | 44.27 | beide | ZB:359-361 (HD:802 44.37,44.21) | – |
| Coiled Isle | 2512 | Tunnel west → Vaults 2509 42.43,89.80 | 31.87 | 64.88 | beide | ZB:351-353 (HD:801 30.20,64.75) | – |

In de Vaults van Atal'Utek (2509) kun je niet vliegen: `flyable=false` (ZM:1647). GEMETEN.

## 5. Per instance, in de volgorde van MOUNTRUN_RAIDS

"Ingang" vergelijkt MRD met HandyNotes (HD of HI) en met Zygor (ZD). Δ is de afstand in kaart-%.
**⚑** betekent dat het verschil met HandyNotes groter is dan 1.0. De afstanden heb ik zelf uitgerekend uit
gemeten getallen.

Elke tabel heeft dezelfde kolommen: stap, uiMap, x, y, factie, bron en status (G = GEMETEN, A = AFGELEID).

### Northrend

#### 5.1 Obsidian Sanctum (`MOUNTRUN_R_OS`, MRD:23-24)

**Ingang:**

- MRD: 115 60.02,57.02
- HD:383: 60.00,57.01 (Δ0.02)
- ZD:713: 60.00,56.85 (Δ0.17)

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR), aankomst 125 55.92,46.79 | 84 | 44.36 | 88.71 | A | ZT:1666 | G |
| 1 | Idem, op de begane grond | 85 | 56.23 | 91.74 | H | ZT:1482, HC:129 | G |
| 2 | Vlieg naar de ingang onder Wyrmrest Temple | 115 | 60.00 | 57.01 | beide | HD:383 | G (vlucht A) |

HOW_OS klopt.

#### 5.2 Eye of Eternity (`MOUNTRUN_R_EOE`, MRD:29-30)

**Ingang:**

- MRD: 114 27.52,26.74
- HD:391: 27.52,26.73 (Δ0.01)
- ZD:715: 27.55,26.65

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR) | 84 / 85 | 44.36 / 56.23 | 88.71 / 91.74 | A / H | ZT:1666 / ZT:1482 | G |
| 2 | Ingang bovenop de Nexus: het bovenste portaal (ZG:4917-4918) | 114 | 27.52 | 26.73 | beide | HD:391 | G |
| alt | Boot SW → Valiance Keep 114 59.68,69.41 | 84 | 18.02 | 25.84 | A | ZT:2869 | G |
| alt | Zeppelin Org → Warsong Hold 114 41.38,53.61 | 85 | 44.75 | 62.30 | H | ZT:2846 | G |

HOW_EOE klopt.

#### 5.3 Vault of Archavon (`MOUNTRUN_R_VOA`, MRD:35-36)

**Ingang:**

- MRD: 123 50.06,11.18
- HD:390: 50.04,11.68 (Δ0.50)
- Zygor heeft hier geen ingang. Grep "Archavon" in ZD gaf 0 treffers. Dezelfde grep vond wel de andere
  Northrend-raids (positieve controle).

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR) | 84 / 85 | 44.36 / 56.23 | 88.71 / 91.74 | A / H | ZT:1666 / ZT:1482 | G |
| 2 | Vlieg naar Wintergrasp Fortress, ingang | 123 | 50.04 | 11.68 | beide | HD:390 | G |

HOW_VOA klopt voor de route. Dat de raid alleen open is als jouw factie Wintergrasp heeft, is **niet
gecontroleerd**.

#### 5.4 Icecrown Citadel (`MOUNTRUN_R_ICC`, MRD:41-42)

**Ingang:**

- MRD: 118 53.91,87.41
- HD:386: 53.80,87.09 (Δ0.34)
- ZD:721: 53.83,87.15

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR) | 84 / 85 | 44.36 / 56.23 | 88.71 / 91.74 | A / H | ZT:1666 / ZT:1482 | G |
| 2 | Vlieg naar ICC, zuid-Icecrown | 118 | 53.80 | 87.09 | beide | HD:386 (ZG:4989 53.79,87.02) | G |

HOW_ICC klopt.

#### 5.5 Ulduar (`MOUNTRUN_R_ULDUAR`, MRD:46-47)

**Ingang:**

- MRD: 120 41.55,17.58
- HD:384: 41.57,17.79 (Δ0.21)
- ZD:717: 41.56,17.81

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR) | 84 / 85 | 44.36 / 56.23 | 88.71 / 91.74 | A / H | ZT:1666 / ZT:1482 | G |
| 2 | Vlieg naar Ulduar, uiterste noorden van Storm Peaks | 120 | 41.57 | 17.79 | beide | HD:384 | G |

HOW_ULDUAR klopt.

#### 5.6 Utgarde Pinnacle (`MOUNTRUN_R_UP`, MRD:51-52)

**Ingang:**

- MRD: 117 57.29,46.89
- HD:354: 57.22,46.49 (Δ0.41)
- ZD:257: 57.27,46.69

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dalaran (NR) | 84 / 85 | 44.36 / 56.23 | 88.71 / 91.74 | A / H | ZT:1666 / ZT:1482 | G |
| 2 | Vlieg naar Utgarde Keep, Pinnacle-deur bovenop | 117 | 57.22 | 46.49 | beide | HD:354 | G |

HOW_UP klopt.

### Outland en Classic

#### 5.7 Tempest Keep, The Eye (`MOUNTRUN_R_TK`, MRD:61-62)

**Ingang:**

- MRD: 109 73.88,63.74
- HD:337: 73.59,63.72 (Δ0.29)
- ZD:699: 73.56,63.71

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Shattrath, aankomst 111 54.97,40.23 | 84 | 44.91 | 85.72 | A | ZT:1692 | G |
| 1 | Portaal Shattrath (kelder), aankomst 111 53.01,49.21 | 85 | 57.51 | 91.65 | H | ZT:1460, HC:129 | G |
| 2 | Vlieg naar Netherstorm, oostkant | 109 | 73.59 | 63.72 | beide | HD:337 | G |

HOW_TK klopt.

#### 5.8 Sethekk Halls (`MOUNTRUN_R_SETHEKK`, MRD:66-67)

**Ingang:**

- MRD: 108 45.06,65.62
- HD:309: 44.59,65.60 (Δ0.47)
- ZD:229: 44.95,65.61

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Shattrath | 84 / 85 | 44.91 / 57.51 | 85.72 / 91.65 | A / H | ZT:1692 / ZT:1460 | G |
| 2 | Vlieg zuid naar Auchindoun, Sethekk-deur | 108 | 44.59 | 65.60 | beide | HD:309 | G |

HOW_SETHEKK klopt.

#### 5.9 Magisters' Terrace, de oude (`MOUNTRUN_R_MT`, MRD:71-72)

**Ingang:**

- MRD: 122 61.52,31.10
- HD:197: 60.97,30.73 (Δ0.66)
- HI:873: 61.30,30.90 (Δ0.30)
- ZD:179: 61.28,30.92

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Shattrath | 84 / 85 | 44.91 / 57.51 | 85.72 / 91.65 | A / H | ZT:1692 / ZT:1460 | G |
| 2 | Portaal naar Isle of Quel'Danas (oud), aankomst 122 48.25,34.48 | 111 | 48.57 | 42.02 | beide | ZT:1908 (HC:2433 48.61,42.03) | G |
| 3 | Ingang | 122 | 61.30 | 30.90 | beide | HI:873 | G |

HOW_MT klopt.

#### 5.10 Karazhan (`MOUNTRUN_R_KARA`, MRD:76-77)

**Ingang:**

- MRD: 42 46.59,74.11
- HD:225: 46.98,74.90 (Δ0.88)
- ZD:679: 46.81,74.60 (Δ0.54)

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Vlieg zuidoost via Elwynn en Duskwood naar Deadwind Pass (geen portaal) | – | – | – | A | – | A |
| 1 | Zeppelin naar Grom'gol, aankomst 50 37.17,52.49 | 85 | 52.52 | 53.15 | H | ZT:2843 (HC:146) | G |
| 2 | (H) vlieg noordoost naar Deadwind Pass | – | – | – | H | – | A |
| 3 | Ingang | 42 | 46.98 | 74.90 | beide | HD:225 | G |
| alt | Legion Dalaran: plateau 627 49.26,47.62 → 629, dan het portaal naar Karazhan (aankomst 42 47.24,75.40) | 629 | 31.95 | 71.43 | beide | ZT:2222, ZT:1945 | G (alleen Zygor) |

HOW_KARA: zie §3 (Horde "north" moet noordoost zijn).

#### 5.11 Return to Karazhan (`MOUNTRUN_R_RTK`, MRD:81-82)

**Ingang:**

- MRD: 42 46.37,70.66
- HD:171: 46.86,69.79 (Δ0.998, net onder de grens)
- ZD:400: 46.72,70.20 (Δ0.58)

De route is dezelfde als 5.10. De laatste stap is de ingang op 42 46.86,69.79 (HD:171, G). Extra
mogelijkheid: met de Keystone-teleport (spell 373262) kom je aan op 42 46.72,70.20 (ZT:3163, G).

HOW_RTK klopt.

#### 5.12 Culling of Stratholme (`MOUNTRUN_R_COS`, MRD:87-88)

**⚑ Andere kaart.** MRD wijst naar 71 64.86,49.97. Dat is de grotmond op de Tanaris-kaart; het
portaal-icoon in HZ:59 staat ernaast op 71 65.98,49.60. Maar het portaal zet je al **binnen** neer (74), en
het echte instance-portaal ligt op **75**.

**Ingang op 75:**

- HD:56: 60.11,82.72
- ZD:77: 57.40,82.60. De bronnen verschillen 2.71.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Caverns of Time, aankomst 74 54.60,28.30 | 84 | 43.72 | 85.35 | A | ZT:1674 | G |
| 1 | Idem (kelder) | 85 | 56.40 | 92.56 | H | ZT:1449, HC:129 | G |
| 2 | Loop naar beneden, de grot in (kaart 75) | – | – | – | beide | ZM:561 | A |
| 3 | Culling-portaal | 75 | 60.11 | 82.72 | beide | HD:56 | G |

HOW_COS klopt.

#### 5.13 Dragon Soul (`MOUNTRUN_R_DS`, MRD:92-93)

**⚑ Andere kaart**, net als bij 5.12.

**Ingang op 75:**

- HD:112: 60.87,21.15
- ZD:734: 61.97,26.97
- ZG:5021: 61.84,26.61. De bronnen verschillen tot 5.9.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Caverns of Time | 84 / 85 | 43.72 / 56.40 | 85.35 / 92.56 | A / H | ZT:1674 / ZT:1449 | G |
| 2 | Spiraaltunnel af, eerste gang rechts onderaan (tip in ZG:5018) | – | – | – | beide | ZG:5018 | G (tekst) |
| 3 | Dragon Soul-portaal | 75 | 60.87 | 21.15 | beide | HD:112 | G (bronnen oneens) |

HOW_DS klopt.

#### 5.14 Onyxia's Lair (`MOUNTRUN_R_ONY`, MRD:99-100)

**Ingang ⚑:**

- MRD: 70 52.90,78.15
- HD:97: 52.21,75.93 (**Δ2.32**)
- ZD:709: 52.89,77.46 (Δ0.69)

Waarschijnlijk is HD de grotmond en ZD het portaal binnen de grot. Dat is AFGELEID.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Vlieg vanuit Org zuid via Northern Barrens naar Dustwallow Marsh | – | – | – | H | – | A |
| 1 | Portaal Caverns of Time, dan noord vliegen | 84 | 43.72 | 85.35 | A | ZT:1674 | G (vlucht A) |
| 2 | Grot (HandyNotes) | 70 | 52.21 | 75.93 | beide | HD:97 | G |
| 3 | Portaal in de grot (Zygor) | 70 | 52.89 | 77.46 | beide | ZD:709 | G |

HOW_ONY klopt.

### Cataclysm en Pandaria

#### 5.15 Firelands (`MOUNTRUN_R_FL`, MRD:109-110)

**Ingang:**

- MRD: 198 47.00,78.24
- HD:95: 46.79,78.38 (Δ0.25)
- ZD:736: 47.43,78.00

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Earthshrine: portaal Hyjal, aankomst 198 63.49,23.37 | 84 | 76.20 | 18.69 | A | ZT:1651 (HC:1199) | G |
| 1 | Idem | 85 | 51.13 | 38.28 | H | ZT:1408 (HC:134) | G |
| 2 | Vlieg zuid naar Sulfuron Spire, ingang | 198 | 46.79 | 78.38 | beide | HD:95 | G |

Voorwaarde: quest 25316 of level ≥50 (ZT:1408, ZT:1651). HOW_FL klopt.

#### 5.16 Throne of the Four Winds (`MOUNTRUN_R_T4W`, MRD:115-116)

**⚑ Kaartfase.** MRD gebruikt 249 (oud Uldum). Het portaal landt op **1527** ("Uldum New", ZT:1644 en
ZT:1402). ZT:1641 en ZT:1399 gaan naar 249 als je in de oude fase zit.

**Ingang:**

- 1527: 38.23,80.69 (HD:108, "echte ingang") en 38.25,80.69 (ZD:741)
- 249: 38.38,80.60 (ZD:740). Het icoon in HD:103 staat op 37.00,81.43.
- MRD 249 38.24,80.70 ligt Δ0.17 van ZD:740.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Earthshrine: portaal Uldum, aankomst 1527 54.90,34.25 | 84 | 75.24 | 20.50 | A | ZT:1644 (HC:1197) | G |
| 1 | Idem | 85 | 48.87 | 38.55 | H | ZT:1402 (HC:132) | G |
| 2 | Vlieg naar het uiterste zuidwesten, ingang | 1527 | 38.23 | 80.69 | beide | HD:108 | G |

HOW_T4W klopt.

#### 5.17 Throne of Thunder (`MOUNTRUN_R_TOT`, MRD:120-121)

**Ingang:**

- MRD: 504 63.82,32.05
- HD:432: 63.83,32.03 (Δ0.02)
- ZD:757: 63.64,32.37

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Jade Forest, aankomst 371 46.18,85.07 | 84 | 45.70 | 87.16 | A | ZT:1680 | G |
| 1 | Portaal Jade Forest, aankomst 371 28.56,13.98 | 85 | 57.46 | 92.28 | H | ZT:1468 | G |
| 2 | Vlieg naar Shado-Pan Garrison, portaal Isle of Thunder, aankomst 504 64.08,72.48 | 388 | 49.74 | 68.67 | A | ZT:1997 (HZ:350) | G |
| 2 | Idem, aankomst 504 33.25,32.43 | 388 | 50.65 | 73.40 | H | ZT:2037 (HZ:342) | G |
| 3 | Ingang, noordoost op het eiland | 504 | 63.83 | 32.03 | beide | HD:432 | G |

Voorwaarden voor het portaal:

- **Alliance:** quest 32644 (ZT:1997). Daarvóór landt het op 504 34.86,89.85 (ZT:1981, quest 32681).
- **Horde:** quest 32212 (ZT:2037). Daarvóór landt het op 504 28.39,52.90 (ZT:2029, quest 32680).
- Zonder 32681 (A) of 32680 (H) bestaat het portaal volgens ZT niet. HOW_TOT zegt "needs a quest", dat klopt.

#### 5.18 Mogu'shan Vaults (`MOUNTRUN_R_MSV`, MRD:126-127)

**Ingang:**

- MRD: 379 59.50,39.34
- HD:431: 59.60,39.17 (Δ0.20)
- ZD:750: 59.58,39.20

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Jade Forest | 84 / 85 | 45.70 / 57.46 | 87.16 / 92.28 | A / H | ZT:1680 / ZT:1468 | G |
| 2 | Vlieg naar Kun-Lai, ingang | 379 | 59.60 | 39.17 | beide | HD:431 | G |

HOW_MSV klopt.

#### 5.19 Siege of Orgrimmar (`MOUNTRUN_R_SOO`, MRD:131-132)

**Ingang ⚑ (randgeval):**

- MRD: 390 74.30,41.66
- HD:433: 73.71,42.48 (**Δ1.01**)
- ZD:752: 73.96,42.15 (Δ0.60, fase OldVale)
- In de 8.3-Vale (1530): 72.68,42.08 (HD:437, "echte ingang"), 74.11,40.14 (HD:436, icoon) en 72.86,41.91
  (ZD:753).

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Jade Forest | 84 / 85 | 45.70 / 57.46 | 87.16 / 92.28 | A / H | ZT:1680 / ZT:1468 | G |
| 2 | Vlieg naar de oostkant van de Vale | – | – | – | beide | – | A |
| 3a | Ingang (oude Vale) | 390 | 73.71 | 42.48 | beide | HD:433 | G |
| 3b | Ingang (8.3-Vale) | 1530 | 72.68 | 42.08 | beide | HD:437 | G |
| opt | Zidormi (fase wisselen) | 390 / 1530 | 80.48 / 80.97 | 31.96 / 29.48 | beide | HG:821-822 | G |

HOW_SOO: zie §3. Volgens beide bronnen is Zidormi waarschijnlijk niet nodig.

### Mythic-raids (Draenor, Legion, BfA, DF, SL)

#### 5.20 Hellfire Citadel (`MOUNTRUN_R_HFC`, MRD:141-142)

**Ingang ⚑:**

- MRD: 534 45.22,53.84
- HD:476: 46.96,52.64 (**Δ2.11**)
- ZD:771: 45.60,53.54 (Δ0.48)

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Stormshield, aankomst 622 31.71,52.48 | 84 | 41.36 | 89.82 | A | ZT:1684 | G |
| 1 | Portaal Warspear (kelder), aankomst 624 44.42,35.53 | 85 | 55.18 | 92.05 | H | ZT:1453 | G |
| 2 | Portaal Lion's Watch, aankomst 534 57.53,60.32 (quest 38445) | 622 | 36.38 | 41.15 | A | ZT:2097 (HC:1841) | G |
| 2 | Portaal Vol'mar, aankomst 534 60.9,47.3 (quest 37935) | 624 | 53.16 | 43.91 | H | ZT:2119 (HC:772) | G |
| 3 | Ingang | 534 | 46.96 | 52.64 | beide | HD:476 | G (bronnen oneens) |

HOW_HFC klopt.

#### 5.21 Blackrock Foundry (`MOUNTRUN_R_BRF`, MRD:146-147)

**Ingang:**

- MRD: 543 51.59,27.11
- HD:478: 51.56,27.19 (Δ0.09)
- ZD:767: 51.55,27.23

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Stormshield of Warspear | 84 / 85 | 41.36 / 55.18 | 89.82 / 92.05 | A / H | ZT:1684 / ZT:1453 | G |
| 2 | Vlieg noord naar Gorgrond, ingang | 543 | 51.56 | 27.19 | beide | HD:478 | G |

HOW_BRF klopt.

#### 5.22 The Nighthold (`MOUNTRUN_R_NH`, MRD:151-152)

**Ingang:**

- MRD: 680 44.23,59.51
- HD:528: 44.14,59.79 (Δ0.29)
- ZD:784: 44.13,59.80

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Azsuna, aankomst 630 47.00,40.89 | 84 | 42.08 | 91.34 | A | ZT:1670 | G |
| 1 | Idem (kelder) | 85 | 57.23 | 88.21 | H | ZT:1446 | G |
| 2 | Vlieg naar Suramar City, ingang | 680 | 44.14 | 59.79 | beide | HD:528 | G |

HOW_NH klopt.

#### 5.23 Battle of Dazar'alor, Jaina (`MOUNTRUN_R_BOD`, MRD:158-159)

**Ingang:**

- MRD Horde: 862 54.28,30.03. HD:582 zegt 54.26,29.93 (Δ0.10).
- MRD Alliance: 1161 70.65,35.06. HI:1226 zegt 70.44,35.55 (Δ0.53).

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Boralus, aankomst 1161 70.62,16.98 | 84 | 40.85 | 92.75 | A | ZT:1688 | G |
| 2 | Loop zuid door de haven naar de ingang | 1161 | 70.44 | 35.55 | A | HI:1226 (ook 895 74.38,28.37, HD:645) | G |
| 1 | Portaal Zuldazar (kelder), aankomst 1163 71.96,82.78 | 85 | 57.89 | 89.84 | H | ZT:1456 | G |
| 2 | Uitgang Hall of Ancient Paths | 1163 | 48.59 | 17.52 | H | HC:971 | G |
| 3 | Ingang in Dazar'alor | 1165 | 38.92 | 2.89 | H | HI:1180 (ZD:800 38.90,2.79; op 862: 54.26,29.93, HD:582) | G |

HOW_BOD klopt.

#### 5.24 Amirdrassil (`MOUNTRUN_R_AMI`, MRD:163-164)

**Ingang:**

- MRD: 2200 27.25,31.03
- HD:719: 27.31,31.04 (Δ0.06)
- ZD:834: 27.29,31.04

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Valdrakken (quest 67030), aankomst 2112 59.55,41.46 | 84 / 85 | 48.89 / 57.11 | 93.43 / 87.30 | A / H | ZT:1700 / ZT:1472 | G |
| 2 | Portaal Emerald Dream, aankomst 2200 50.61,62.50 (quest 77572 actief of 77887 klaar) | 2112 | 62.60 | 57.42 | beide | ZT:650 (HC:3188) | G |
| alt | Ohn'ahran Plains-portaal, aankomst 2200 73.05,52.52 (geen voorwaarde in ZT) | 2023 | 18.37 | 52.37 | beide | ZT:647 | G |
| 3 | Ingang | 2200 | 27.31 | 31.04 | beide | HD:719 | G |

HOW_AMI klopt.

#### 5.25 Sepulcher of the First Ones (`MOUNTRUN_R_SFO`, MRD:168-169)

**Ingang:**

- MRD: 1970 81.00,53.33
- HD:686: 80.49,53.40 (Δ0.51)
- ZD:818: 81.02,53.40

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Oribos (quest 60151 of level ≥50), aankomst 1670 20.34,50.31 | 84 / 85 | 47.55 / 58.32 | 94.98 / 87.85 | A / H | ZT:787 / ZT:798 | G |
| 2 | Ring of Transference naar boven (dichtstbijzijnde van vier, zie 4c) | 1670 | 47.02 | 50.34 | beide | ZT:816-825 | G |
| 3 | Portaal Zereth Mortis, aankomst 1970 33.27,69.43 (quest 64957) | 1671 | 49.59 | 25.44 | beide | ZT:804 (HC:3033) | G |
| 4 | Vlieg oost, ingang | 1970 | 80.49 | 53.40 | beide | HD:686 | G |

HOW_SFO klopt.

### Legion en Shadowlands

#### 5.26 Tomb of Sargeras (`MOUNTRUN_R_TOS`, MRD:183-184)

**Ingang ⚑:**

- MRD: 646 64.97,20.26
- HD:527: 64.00,21.36 (**Δ1.47**)
- ZD:787: 64.53,20.81 (Δ0.70)

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Azsuna | 84 / 85 | 42.08 / 57.23 | 91.34 / 88.21 | A / H | ZT:1670 / ZT:1446 | G |
| 2 | Vlieg zuidoost naar Broken Shore, noordoostkust | 646 | 64.00 | 21.36 | beide | HD:527 | G (bronnen oneens) |

HOW_TOS klopt. LFR-NPC Archmage Timear staat op 627 63.53,54.88 (HC:2763), G.

#### 5.27 Antorus, Felhounds (`MOUNTRUN_R_ANT`, MRD:188-189). DEELS gedekt

**Ingang:**

- MRD: 885 54.70,62.80
- HD:531: 54.82,62.53 (Δ0.30)
- ZD:790: 54.85,62.59

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Azsuna | 84 / 85 | 42.08 / 57.23 | 91.34 / 88.21 | A / H | ZT:1670 / ZT:1446 | G |
| 2 | Vlieg omhoog naar Legion Dalaran (627) | **?** | **?** | **?** | beide | **ontbreekt** in ZT en HN | – |
| 3 | Lightforged Beacon, aankomst Vindicaar 831 61.15,81.36 | 627 | 74.22 | 49.26 | beide | ZT:2349 | G (alleen Zygor) |
| 4 | Navigatieconsole: verplaats het schip naar Antoran Wastes | **?** | **?** | **?** | beide | **ontbreekt** | – |
| 5 | Afdalen van het schip naar de grond | **?** | **?** | **?** | beide | **ontbreekt** | – |
| 6 | Ingang, midden Antoran Wastes | 885 | 54.82 | 62.53 | beide | HD:531 | G |

Het schip kan in de Antoran Wastes liggen: ZT:2355 noemt een portaal van 887 33.83,55.94 terug naar Dalaran,
met als voorwaarde `IsVindicaarIn('Antoran Wastes')`. Dat is GEMETEN.

#### 5.28 Antorus, Argus (`MOUNTRUN_R_ANT_ARGUS`, MRD:193-194). DEELS gedekt

Zelfde route en ingang als 5.27. HOW_ANT_ARGUS bevat geen extra reisstap.

#### 5.29 Sanctum of Domination (`MOUNTRUN_R_SOD`, MRD:198-199)

**Ingang:**

- MRD: 1543 69.75,32.01
- HD:688: 69.74,32.01 (Δ0.01)
- ZD:815: 69.79,31.89

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Oribos | 84 / 85 | 47.55 / 58.32 | 94.98 / 87.85 | A / H | ZT:787 / ZT:798 | G |
| 2 | Ring of Transference naar boven | 1670 | 47.02 | 50.34 | beide | ZT:816-825 | G |
| 3 | Spring in de lichtzuil in het midden, aankomst Maw 1543 44.95,40.99 | 1671 | 49.27 | 50.88 | beide | ZT:840 (HC:3031 49.40,51.27) | G |
| 4 | Vlieg noordoost, ingang | 1543 | 69.74 | 32.01 | beide | HD:688 | G |

HOW_SOD klopt.

#### 5.30 Ny'alotha (`MOUNTRUN_R_NYA`, MRD:203-204)

**Ingang Uldum:**

- MRD: 1527 55.18,43.96
- HD:109: 55.18,43.95 (Δ0.01)
- ZD:101: 55.17,43.93 (fase UldumInvasionCenter)

**Ingang Vale**, in de week dat de raid daar staat:

- HD:435: 1530 40.04,45.56
- ZD:760: 40.08,45.52 (fase ValeInvasionRight)

**MRD kent de Vale-variant niet.**

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Earthshrine: portaal Uldum, aankomst 1527 | 84 / 85 | 75.24 / 48.87 | 20.50 / 38.55 | A / H | ZT:1644 / ZT:1402 | G |
| 2 | Alleen als je op 249 staat: Zidormi | 249 / 1527 | 56.01 | 35.14 | beide | HG:28-29 | G |
| 3 | Ingang boven Vir'naal Dam | 1527 | 55.18 | 43.95 | beide | HD:109 | G |
| alt | Week met de Vale: Jade Forest-portaal, Zidormi 390 80.48,31.96 (HG:821), ingang | 1530 | 40.04 | 45.56 | beide | HD:435 | G |

HOW_NYA klopt. HD:109 noemt de wekelijkse wissel.

#### 5.31 Battle of Dazar'alor, G.M.O.D. (`MOUNTRUN_R_BOD_GMOD`, MRD:208-210)

Zelfde route en ingang als 5.23. De LFR-NPC's in HOW_BOD_GMOD staan ook in de bronnen, GEMETEN:

- Kiku: 1161 74.19,13.52 (HC:1939)
- Eppu: 1165 49.91,44.47 (HC:958)

### Dungeons

#### 5.32 Stratholme Service Entrance (`MOUNTRUN_R_STRAT`, MRD:221-222)

**Ingang:**

- MRD: 23 43.25,18.54
- HI:919: 43.25,18.54 (Δ0)
- ZD:119: 43.82,17.42. Zygor wijkt 1.26 af; HandyNotes is hetzelfde als MRD.
- De Main Gate (niet deze ingang): HD:195 27.07,11.51.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal bovenop de zeppelintoren naar Tirisfal (aankomst 69.30,62.75) | 85 | 50.74 | 55.57 | H | ZT:1432 (HC:130 50.76,55.61) | G |
| 2 | (H) vlieg oost via Western Plaguelands naar EPL | – | – | – | H | – | A |
| 1 | Deeprun Tram naar Ironforge, aankomst 87 76.93,51.25 | 84 | 69.62 | 31.11 | A | ZT:2878, ZT:2882 | G |
| 2 | (A) vlieg noord naar EPL | – | – | – | A | – | A |
| 3 | Service Entrance (oostkant) | 23 | 43.25 | 18.54 | beide | HI:919 | G |
| opt | Manapoof-portaal (quest 56491), aankomst EPL 43.23,19.96, 1.4 van de deur | 627 / 1161 / 1165 | 58.61 / 50.05 / 56.32 | 39.34 / 46.69 / 30.79 | beide / A / H | ZT:2206 / ZT:2628 / ZT:2696 | G |

Op welke kaart je in Tirisfal landt, is onzeker: 2070 volgens ZT/ZM:376, 18 volgens HC:130. Zidormi staat
daar op 18/2070 69.45,62.80 (HG:275, HG:279), GEMETEN.

HOW_STRAT klopt. Het Manapoof-portaal zou een nuttige aanvulling zijn.

#### 5.33 Vortex Pinnacle (`MOUNTRUN_R_VP`, MRD:226-227)

**Ingang:**

- MRD: 249 76.84,84.59
- HD:60: 249 76.70,84.35 (Δ0.28)
- HD:64: 1527 76.70,84.35
- ZD:89-90: 76.81,84.55 (249) en 76.84,84.61 (1527)

**⚑ Kaartfase**, net als bij T4W.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Earthshrine: portaal Uldum | 84 / 85 | 75.24 / 48.87 | 20.50 / 38.55 | A / H | ZT:1644 / ZT:1402 | G |
| 2 | Vlieg naar de zuidoosthoek, ingang | 1527 | 76.70 | 84.35 | beide | HD:64 | G |

HOW_VP klopt.

#### 5.34 The Stonecore (`MOUNTRUN_R_SC`, MRD:231-232)

**Ingang:**

- MRD: 207 47.83,51.90
- HD:57: 47.38,52.05 (Δ0.47)
- ZD:311: 47.70,51.98

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Earthshrine: portaal Deepholm, aankomst 207 48.73,53.56 | 84 | 73.19 | 19.65 | A | ZT:1647 (HC:1200) | G |
| 1 | Idem, aankomst 207 50.59,52.94 | 85 | 50.84 | 36.29 | H | ZT:1405 (HC:135) | G |
| 2 | Ingang naast de Temple of Earth | 207 | 47.38 | 52.05 | beide | HD:57 | G |

Voorwaarde: quest 27123 of level ≥50. HOW_SC klopt.

#### 5.35 Zul'Gurub (`MOUNTRUN_R_ZG`, MRD:236-237)

**Ingang:**

- MRD: 50 72.25,32.91
- HD:175: 72.08,32.91 (Δ0.17)
- ZD:140: 72.18,32.91

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Vlieg zuid via Elwynn en Duskwood | – | – | – | A | – | A |
| 1 | **Zeppelin naar Grom'gol**, aankomst 50 37.17,52.49 | 85 | 52.52 | 53.15 | H | ZT:2843 (HC:146) | G |
| 2 | Vlieg noordoost, ingang | 50 | 72.08 | 32.91 | beide | HD:175 | G |

**HOW_ZG: MISMATCH**, zie §3.

#### 5.36 Freehold (`MOUNTRUN_R_FH`, MRD:242-243)

**Ingang:**

- MRD: 895 83.82,79.25
- HD:625: 84.56,78.78 (Δ0.88)
- ZD:413: 84.45,78.88 (Δ0.73)

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Boralus, vlieg zuid | 84 | 40.85 | 92.75 | A | ZT:1688 | G |
| 1 | Portaal Zuldazar (kelder) | 85 | 57.89 | 89.84 | H | ZT:1456 | G |
| 2 | (H) uitgang Hall of Ancient Paths | 1163 | 48.59 | 17.52 | H | HC:971 | G |
| 3 | (H) Dread-Admiral Tattersail, boot naar Tiragarde 895 88.20,51.16 (quest 51800) | 862 | 58.46 | 62.99 | H | ZT:3020 (HZ:653) | G |
| 4 | Vlieg zuid, ingang | 895 | 84.56 | 78.78 | beide | HD:625 | G |

HOW_FH klopt.

#### 5.37 The Underrot (`MOUNTRUN_R_UR`, MRD:247-248)

**Ingang:**

- MRD: 863 51.08,64.29
- HD:572: 51.25,64.64 (Δ0.39)
- ZD:434: 51.38,64.83

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Zuldazar, dan uitgang 1163 48.59,17.52 | 85 | 57.89 | 89.84 | H | ZT:1456, HC:971 | G |
| 2 | (H) vlieg noordoost naar Nazmir | – | – | – | H | – | A |
| 1 | Portaal Boralus | 84 | 40.85 | 92.75 | A | ZT:1688 | G |
| 2 | (A) Jes-Tereth, boot naar Nazmir 863 61.95,39.92 (quest 51571) | 1161 | 67.95 | 26.69 | A | ZT:2961 (HC:2013) | G |
| 3 | Ingang, midden Nazmir | 863 | 51.25 | 64.64 | beide | HD:572 | G |

HOW_UR klopt.

#### 5.38 Dawn of the Infinite (`MOUNTRUN_R_DOTI`, MRD:252-253)

**Ingang:**

- MRD: 2025 61.29,84.73
- HD:707: 61.14,84.46 (Δ0.31)
- ZD:831: 61.16,84.49

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Valdrakken (quest 67030) | 84 / 85 | 48.89 / 57.11 | 93.43 / 87.30 | A / H | ZT:1700 / ZT:1472 | G |
| 2 | Vlieg zuid naar de Temporal Conflux, ingang | 2025 | 61.14 | 84.46 | beide | HD:707 | G |

HOW_DOTI klopt.

### Groepsinhoud

#### 5.39 Nerub-ar Palace (`MOUNTRUN_R_NP`, MRD:263-264)

**Ingang:**

- MRD: 2255 43.46,90.44
- HD:783: 43.55,90.29 (Δ0.17)
- Zygor alleen op 2213: 34.78,72.83 (ZD:841). HD:785 zegt op 2213 35.04,72.42.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dornogal (level ≥70 + quest 80321 of 79573), aankomst 2339 41.29,27.45 | 84 / 85 | 48.13 / 58.58 | 91.95 / 91.36 | A / H | ZT:451 / ZT:466 | G |
| 2 | Tunnel oostkant, aankomst 2255 57.48,41.61 | 2339 | 63.61 | 52.59 | beide | ZT:508 (HC:3386 63.61,52.05) | G (voorwaarde oneens) |
| alt | Gat naar Ringing Deeps (2214 38.03,28.36), dan 2214 38.58,67.00 naar Azj-Kahet 68.00,28.00 | 2339 | 38.87 | 59.81 | beide | ZB:336, ZB:343 | G |
| 3 | Ingang, uiterste zuiden | 2255 | 43.55 | 90.29 | beide | HD:783 | G |

HOW_NP: zie §3.

#### 5.40 Liberation of Undermine (`MOUNTRUN_R_LOU`, MRD:269-270)

**Ingang:**

- MRD: 2346 42.12,50.41
- HD:787: 42.04,50.31 (Δ0.13)
- ZD:844: 42.11,50.41

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dornogal | 84 / 85 | 48.13 / 58.58 | 91.95 / 91.36 | A / H | ZT:451 / ZT:466 | G |
| 2 | Gloeiende teleportplaat, aankomst 2346 27.83,54.02 | 2339 | 52.47 | 50.47 | beide | ZT:588 (HC:3388) | G (voorwaarde oneens, zie 4c) |
| 3 | Ingang, midden van de stad | 2346 | 42.04 | 50.31 | beide | HD:787 | G |

HOW_LOU klopt.

#### 5.41 Manaforge Omega (`MOUNTRUN_R_MFO`, MRD:275-276)

**Ingang:**

- MRD: 2371 41.66,21.53
- HD:788: 41.66,21.52 (Δ0.01)
- ZD:847: 41.71,21.53

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dornogal | 84 / 85 | 48.13 / 58.58 | 91.95 / 91.36 | A / H | ZT:451 / ZT:466 | G |
| 2 | Spatial Rift, aankomst Tazavesh 2472 62.58,94.40 (quest 84957) | 2339 | 40.31 | 22.70 | beide | ZT:481 (HC:3389) | G |
| 3 | Vlieg noord K'aresh in (grens Tazavesh/K'aresh: ZM:1287), ingang | 2371 | 41.66 | 21.52 | beide | HD:788 | G |

HOW_MFO klopt.

#### 5.42 March on Quel'Danas (`MOUNTRUN_R_MOQD`, MRD:280-281)

**Ingang:**

- MRD: 2424 52.61,85.30
- HD:824: 52.60,85.29 (Δ0.01)
- ZD:863: 52.60,85.11

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Silvermoon, aankomst 2393 52.85,65.51 | 84 | 48.77 | 95.23 | A | ZT:164 | G |
| 1 | Idem (Rob gemeten) | 85 | 56.25 | 88.57 | H | MHD:163 | G |
| 2 | Noorduitgang van Silvermoon | 2393 | 45.73 | 6.48 | beide | HC:3496 | G |
| 3 | Vlieg naar de zuidpunt van het eiland, ingang | 2424 | 52.60 | 85.29 | beide | HD:824 | G |

Voorwaarde voor het portaal: quest 86852 of achievement 41806 (ZT:164, ZT:177). HOW_MOQD klopt.

#### 5.43 The Venomous Abyss, Ula'tek (`MOUNTRUN_R_VA`, MRD:285-286)

**Ingang:**

- MRD: 2509 47.23,22.86
- HD:826: 47.23,22.86 (Δ0)
- ZD:872: 47.25,20.51. Zygor wijkt 2.35 af; HandyNotes is hetzelfde als MRD.

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Silvermoon | 84 / 85 | 48.77 / 56.25 | 95.23 / 88.57 | A / H | ZT:164 / MHD:163 | G |
| 2 | Portaal Coiled Isle, aankomst 2512 58.17,48.48 (MH: quest 96004) | 2393 | 56.83 | 67.38 | beide | MHD:288 (ZT:206 56.88,67.48) | G |
| 3 | Noordtunnel in, uitkomst 2509 58.36,36.10 | 2512 | 43.30 | 44.27 | beide | ZB:359-361 (HD:802 44.37,44.21) | G; keuze A |
| 4 | Lopen (niet vliegbaar, ZM:1647), ingang in het noorden | 2509 | 47.23 | 22.86 | beide | HD:826 | G |

AFGELEID: de noordtunnel ligt het dichtst bij de raid. Twee andere tunnels staan in 4c. HOW_VA klopt, maar
noemt de quest niet (§3).

#### 5.44 Altar of Fangs (`MOUNTRUN_R_AOF`, MRD:290-291)

**Ingang:**

- MRD: 2509 47.24,68.13
- HD:816: 47.24,68.12 (Δ0.01)
- ZD:569: 47.24,68.55

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1-2 | Als bij 5.43, tot en met het Coiled Isle-portaal | – | – | – | beide | – | G |
| 3 | Oosttunnel in, uitkomst 2509 51.24,82.08 | 2512 | 45.37 | 64.90 | beide | ZB:367-369 (ZF:16; HD:800 46.86,64.87) | G; keuze A |
| 4 | Ingang in het zuiden | 2509 | 47.24 | 68.12 | beide | HD:816 | G |

HOW_AOF klopt, maar noemt de quest niet.

#### 5.45 Windrunner Spire (`MOUNTRUN_R_WRS`, MRD:295-296)

**Ingang:**

- MRD: 2395 35.45,78.83
- HD:808: 35.45,78.82 (Δ0.01)
- ZD:551: 35.37,78.82

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Silvermoon | 84 / 85 | 48.77 / 56.25 | 95.23 / 88.57 | A / H | ZT:164 / MHD:163 | G |
| 2 | Zuiduitgang naar Eversong (westelijkste van drie) | 2393 | 37.44 | 90.41 | beide | HC:3497 | G; keuze A |
| 3 | Vlieg zuidwest, ingang | 2395 | 35.45 | 78.82 | beide | HD:808 | G |

HOW_WRS klopt.

#### 5.46 Magisters' Terrace, de nieuwe (`MOUNTRUN_R_MTN`, MRD:300-301)

**Ingang:**

- MRD: 2424 63.46,15.39
- HD:807: 63.46,15.38 (Δ0.01)
- ZD:557: 63.53,15.48

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Silvermoon | 84 / 85 | 48.77 / 56.25 | 95.23 / 88.57 | A / H | ZT:164 / MHD:163 | G |
| 2 | Noorduitgang | 2393 | 45.73 | 6.48 | beide | HC:3496 | G |
| 3 | Ingang noordoost op het eiland | 2424 | 63.46 | 15.38 | beide | HD:807 | G |
| alt | Portaal naar The Lycaneum, aankomst 2649 56.46,14.00 (quest 96233). Lycaneum ↔ eiland: 2424 64.01,29.12 (ZF:49) | 2393 | 47.93 | 51.95 | beide | ZT:199 | G (alleen Zygor) |

HOW_MTN klopt.

#### 5.47 Darkflame Cleft (`MOUNTRUN_R_DFC`, MRD:305-306)

**Ingang:**

- MRD: 2214 55.54,21.42
- HD:759: 55.45,21.62 (Δ0.22)
- ZD:509: 55.50,21.50

| # | Stap | uiMap | x | y | Factie | Bron | Status |
|---|---|---|---|---|---|---|---|
| 1 | Portaal Dornogal | 84 / 85 | 48.13 / 58.58 | 91.95 / 91.36 | A / H | ZT:451 / ZT:466 | G |
| 2 | Vlieg het gat in, aankomst Ringing Deeps 2214 38.03,28.36 | 2339 | 38.87 | 59.81 | beide | ZB:336 | G |
| 3 | Ingang in het noorden | 2214 | 55.45 | 21.62 | beide | HD:759 | G |

**HOW_DFC: MISMATCH**. Er is geen lift in Dornogal, zie §3.

## 6. Wat in beide lokale bronnen ontbreekt

Dit is gecontroleerd met grep in ZT/ZD/ZB/ZM en in HandyNotes_MapNotes. Een leeg resultaat is hier alleen
geteld als dezelfde grep elders wél iets vond.

1. **Antorus:**
   - waar Legion Dalaran ligt op de Azsuna-kaart of de Broken Isles-kaart (om naartoe te vliegen);
   - de navigatieconsole van de Vindicaar;
   - het afdalen naar 885.

   Grep "Vindicaar|Lightforged Beacon|Argus" in HN gaf geen route-node. In ZT staat alleen het Beacon
   (ZT:2349).
2. **Het Karazhan-portaal in Legion Dalaran (629)** staat alleen in Zygor (ZT:1945). HN heeft alleen het
   plateau naar 629 (HC:2863).
3. **Het portaal van Silvermoon naar de Coiled Isle** staat niet in HN (grep `mnID = 2512` vond geen
   portaal). Het staat wel in Zygor (ZT:206) en in MH zelf (MHD:288), en MH heeft de quest-voorwaarde
   gecontroleerd.
4. **Het portaal van Stormwind naar Silvermoon** staat alleen in Zygor (ZT:164). MHD:159 zegt dat Rob het
   nog niet heeft gemeten.
5. **De ingang van Vault of Archavon** staat niet in Zygor. HN heeft hem wel.
6. **Of jouw factie Wintergrasp heeft** (voor VoA) staat in geen van beide bronnen.

Web niet gebruikt. Wil je deze gaten dichten, dan zijn de meetpunten: Antorus (punt 1), en de
Stormwind→Silvermoon-coördinaat met `/mh coord`.

## 7. Advies voor de code (alles AFGELEID)

- **Laat de client-pin winnen bij de laatste stap.** Dat doet MountRun.lua:137-146 al. Daarmee zijn de vier
  ⚑-ingangen alleen een probleem als terugval.
- **Kies tussen fasekaarten met `C_Map.GetBestMapForUnit("player")`:**
  - Uldum: 249 of 1527 (T4W, VP, NYA)
  - Vale: 390 of 1530 (SOO, NYA)
  - Tirisfal: 18 of 2070 (STRAT Horde)

  Of sla beide kaarten op. HandyNotes doet dat ook (HD:60/64, HD:103/107-108, HD:433/436-437).
- **COS en DS:** de pijl hoort na het portaal naar 75 te wijzen, niet naar 71.
- **Sla de hubs uit §4 één keer op en verwijs ernaar** vanuit elke instance. Gebruik een gesloten
  `requiresQuest`-poort, zoals `MIDNIGHT_PORTALS` al doet (MHD:288 en MHD:340+). De quest- en
  achievement-nummers in deze tabellen komen uit Zygor en HandyNotes en zijn **niet in de client gemeten**;
  alleen 96004 is door MH gecontroleerd.
- **Orgrimmar:** zet "boven" of "kelder" in de pijltekst (HC:129). Dornogal is daar onzeker.
