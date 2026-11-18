# Dungeon-gids Forever, stap 1: bronnen en open punten (18 nov 2026)

Bij `dungeon_guide_data.lua` (zelfde map). Repo niet aangeraakt. G = GEMETEN (gezien in een genoemde bron met datum),
A = AFGELEID. `luac -p` heb ik niet gedraaid (opdracht); een eigen ruwe controle (`dg_check.py`: accolades, quotes,
komma's) gaf 0 fouten. Dat is geen Lua-parser.

## Wat erin zit

| Map | Dungeon | Bazen | Items | recheck |
|---|---|---|---|---|
| 389 | Ragefire Chasm | 4 | 3 | - |
| 3065 | The Hall of Thanes (nieuw) | 4 | 3 | ja |
| 2999 | Ruins of Lordaeron (nieuw) | 7 (1 rare) | 3 | ja |
| 43 | Wailing Caverns | 9 (1 rare) | 3 | - |
| 36 | The Deadmines | 8 (1 rare) | 3 | - |
| 33 | Shadowfang Keep | 9 (1 rare) | 3 | - |
| 34 | The Stockade | 6 (1 rare) | 3 | - |
| 48 | Blackfathom Deeps | 8 (1 optioneel) | 3 | - |
| 2998 | Excavation Site: Wetlands (nieuw) | 4 (1 optioneel) | 3 | ja |

Totaal 59 bazen, 27 items. 24 keer `recheck = true` (alle bazen en items van de drie nieuwe dungeons).
Volgorde van bazen = DB2 OrderIndex; rares zonder DB2-rij achteraan. Uitzondering: Lordaeron Captain (DB2 ord 2000)
staat achteraan, omdat hij pas komt als de rest dood is (IV + MM).

## Bronnen (alle gelezen 18 nov 2026)

- **DB2** (G): wago.tools `DungeonEncounter`, build 1.60.1.70959 (wowf, 17 nov 2026), enUS + deDE, frFR, esES, esMX,
  ptBR, ruRU. Positieve controle: alle 7 locale-CSV's 376 rijen. Ook `Difficulty` (Forever) en `DungeonEncounter`
  Classic Era 1.15.9.70576 ter vergelijking.
- **WHT** (G): Wowhead Forever tooltip-JSON via `run gamedata npc|item ... --game forever` (+ `--locale` voor 5
  namen). Volledige item-tooltips gelezen uit de cache met `scratch dg_items.py` (zie "Gereedschap" onderaan).
- **FC** (G): foreverchanges.pro/dungeons/{ragefire-chasm, the-stockade, blackfathom-deeps, hall-of-thanes,
  ruins-of-lordaeron, excavation-site}: item-id's per baas; build 70959; "drops seen in game as of 2026-10-03".
- **IV** (G): Icy Veins Forever (Neryssa), Last Updated 18 okt 2026 (Deadmines, Excavation Site), 19 okt (rest).
- **MOB** (G): Mobalytics Forever: RFC 12 nov (Ruse_Cruize), Stockade 18 nov (PhaseShifter), BFD 12 nov, DM 12 nov,
  WC 14 nov (Ruse_Cruize), SFK 12 nov, Hall of Thanes 12 nov, Ruins of Lordaeron 13 okt (Ruse_Cruize).
  De MOB-DM-tekst is nu helemaal leesbaar (bij de eerste ronde brak hij af na Mr. Smite).
- **WH**: Wowhead Forever-gidsen (RFC, WC, BFD 25 sep, SFK, RoL 25 sep, via Exa); datum vaak niet zichtbaar.
- **WT**: Warcraft Tavern Forever (RFC, WC, SFK, Hall of Thanes, Excavation Site); geen datum. SFK-pagina toont
  wel "Hotfixes - November 17, 2026" in de zijbalk.
- Verder, telkens met datum in de Lua-kop: GS (GameSpot), CQ (conquestcapped), GG (gamer-guides), SK (sportskeeda),
  FH (forever-hub), WFI (wowforeverinfo), RF (raidforever), MM (mmonster), MG (method.gg), WFDB (wowfdb.com),
  WFG (wowforeverguides.com, verzamelsite die IV/WH citeert: ik tel hem alleen mee waar hij iets eigens zegt).
- **FDJ** (ForeverDungeonJournal): alleen als controle. Gebruikt: `Data/Bosses.lua` r.409-433 als KANDIDAAT voor
  npc-id's (Viktor 256035; daarna door WHT bevestigd) en `Core/Journal.lua` r.496 ("Highland Horror is not a boss
  but the quest's target"). Niets overgenomen. De mechaniek-teksten van FDJ staan niet in de data-bestanden die ik
  zag; daar heb ik niet verder naar gezocht.
- **Spoken_Bosses** `Data/Creatures.lua`: alleen kandidaat-npc-id's. Let op (G): Spoken koppelt "the butcher" aan
  250660, maar WHT zegt dat 250660 "The Baron" is.
- Reddit en Blizzard-forum: een gerichte zoekopdracht (Silverlaine) gaf geen treffer daar; dat bewijst niets.
  YouTube: video's gevonden (Jurdi RoL, Recoil Mojo DM), NIET bekeken. WFG zegt dat de target frame in Jurdi's video
  (3:00) "The Baron" toont; niet zelf gezien.

## Wat er veranderd is t.o.v. de voorbeelddata (DM, WC, SFK)

- **Alle 9 voorbeeld-items hebben in WHT wel "Dropped by"** (G, volledige tooltip). De tweede controle zag dat alleen
  bij 5193 en 273643; oorzaak (G): `tools/gamedata.py` regel 256 print maar 8 tooltipregels (`extra[:8]`), en
  "Dropped by" staat onderaan. Voor de bouwchat: misschien een `--full`-optie. Ik heb de tool niet aangeraakt.
- Stats nu allemaal uit WHT Forever. Rollen bijgewerkt: Living Root = "+45 healing" (niet alleen Spirit), Robes of
  Arugal "+18 healing", Cruel Barb "+12 attack power".
- Springvale-tip was "kill the Guardsman first": dat zegt alleen IV; MOB en WH doden eerst de Servitor. Nu: "houd de
  zwijg-wacht weg bij de healer, onderbreek de heal" (alle drie).
- Sneed-tip stond bijna letterlijk in MOB ("Do not relax when the Shredder dies"); nu eigen woorden.
- Kresh "dik pantser" en Verdan "slaat de tank hard" bleken maar 1 bron (IV resp. MOB): nu `one = true`.
- Skum-tip "spread out" was 1x IV (MOB zegt: de bliksem doet weinig); nu "easy tank-and-spank" (2x).
- Greenskin, VanCleef, Cookie hebben nu 2 bronnen (MOB-tekst compleet). Greenskin kreeg "Poisons the tank" (MOB+FH).
- Odo "sterker bij weinig leven": WT nu zelf nagelezen (Howling Rage) + WFDB = 2x.
- Fenrus: voidwalkers 2x IV+MOB, maar WT zegt "geen adds" en WFDB "helpers bij zijn dood". Geen tijdstip genoemd.
- Deathsworn Captain: cleave weggelaten (IV: "geen vaardigheden"; WT en WFG: cleave).
- Silverlaine: zonder "curse", zonder aantal doelwitten; `measure` staat erin. Nieuw (G, via Exa-zoekfragment van
  wowhead.com/forever/spell=23224): er bestaat ook 23224 "Veil of Shadow", 75%, 8 s, "for an enemy". En
  efficient.games/wowf/npcs/id3887 zegt "1.5 sec cast, Interruptible, ... for an enemy ... 15 sec" (geen datum).
  Nog steeds niet te zeggen welke spell hij in Forever gebruikt.
- Pythas "Thunderclap" (spellnaam) herschreven; ook smoke bomb, shield slam, lightning shield en molten metal.

## Regels met maar 1 bron (`one = true`)

- WC Kresh: tip "dik pantser, armor-verlagende aanvallen helpen" (1x IV).
- WC Verdan: "Hits the tank very hard" (1x MOB).
- WC Deviate Faerie Dragon: "geen vaardigheden, gevaar = mobs ernaast" en de tip (1x IV).
- DM Miner Johnson: "just a tougher Defias Miner" en de tip (1x IV; WFI zegt hetzelfde, mogelijk overgenomen).
- SFK Deathsworn Captain: "rare" (IV + WHT "Rare Elite") en de tip (1x IV).

## Namen per taal: keuzes die de bouwchat moet weten

- Standaard: DB2 DungeonEncounter per locale (G). Rares zonder rij: `names = nil`.
- **Drie DB2-rijen hebben een andere Engelse naam dan de npc** (G):
  - 3495 "Infurnus" = npc 261316 **"Magmatus"** (WHT, IV, MOB, WT, GS, CQ, FC, FDJ).
  - 3355 "The Butcher" = npc 250660 **"The Baron"** (WHT, FC, IV, MOB, GS, MG).
  - 2914/2763 "Geilhast" (enUS, esES, ptBR) = npc 6243 **"Gelihast"** (WHT enUS/esES/ptBR; DB2 deDE/frFR/esMX/ruRU
    zeggen ook Gelihast). Tikfout in de DB2-rij.
  Voor die drie: `name` en de afwijkende `names` uit WHT `--locale` (esMX bestaat niet bij Wowhead: nil). `encName`
  bewaart de DB2-naam. Magmatus en The Baron hebben `measure`.
- Positieve controle voor WHT `--locale` (G): Witherfang deDE "Welkzahn", frFR "Croc-Flétri", esES "Colmimarchito",
  ptBR "Sugapresa", ruRU "Сухожвал" = precies de DB2-namen.
- **Let op (G):** encounter-naam en npc-naam kunnen per taal verschillen, ook als het Engels gelijk is. Mr. Smite
  esES: DB2 "Don Mamporro", WHT-npc "Sr. Golpin". De client toont de npc-naam boven het hoofd; welke naam MH in de
  gids zet is een keuze (Rob). Niet voor alle bazen nagelopen.
- Baron Aquanis heeft geen 5-speler-rij; `names` komen uit DB2-rij 2694 (DifficultyID 198, 10 spelers). A: zelfde naam.

## Niet gemeten / open

- Of `ENCOUNTER_START` in Forever vuurt, en met welk id. **BFD**: drie sets in DB2. Ik zet `encounter` = 2910-2916 en
  `encounterAlt` = 2761-2767. Reden (A): Forever veranderde bij 2913-2916 DifficultyID 1 -> 0 (G: Classic Era
  1.15.9.70576 heeft daar 1, Forever 0), dus aan die set is gewerkt. Difficulty 1 = "Normal" 5 spelers, 201 = ook
  "Normal" 5 spelers, 198 = 10 spelers (G, DB2 Difficulty). Welke het spel gebruikt: in het spel meten.
- Lordaeron Captain: geen npc-id (Wowhead, Spoken en FDJ hebben er geen). `npc = nil`.
- Highland Horror npc 260808: WHT zet hem in zone 11 (Wetlands) met 10 spawn-punten, niet in de instance-zone 16732
  (G). Level 28 klopt met de gidsen; FDJ gebruikt dezelfde id in de dungeon. Of het dezelfde mob is: in het spel zien.
- Silverlaine's spell (7068 / 460755 / 23224): zie boven.
- Bazen in de nieuwe dungeons hebben bij WHT geen level (G: "Elemental (Elite)" zonder getal).
- Wie welk item mag dragen (rol = A uit de stats; de client beslist).
- Of de buit sinds 3 okt (FC) of 19 okt (IV) veranderd is: alleen WHT is van vandaag, en die bevestigt alle 27.
- Haunting Blade (6641, Lordaeron Captain): WHT heeft geen "Dropped by"; daarom niet als item opgenomen.
- Shrine achter Gelihast: CQ zegt "water breathing", Wowhead-commentaren (Classic) en warcraft.wiki zeggen +Int/Spirit
  en frost. Tegenstrijdig: weggelaten.
- Fel Steed / Shadow Charger (SFK, drie paarden, IV + MOB + WH): geen DB2-rij en npc-id's niet gemeten; niet opgenomen.
- `DB2 ItemSparse` Forever (19326 rijen) bevat de meeste dungeon-items NIET (G: 5191, 6324, 273643 ontbreken; eerste
  rij 25 "Worn Shortsword" bestaat wel). Item-id's kwamen daarom van FC en zijn met WHT bevestigd.

## Gereedschap (scratchpad, niet in de repo)

- `dg_items.py`: print de VOLLEDIGE Wowhead-tooltip uit de gamedata-cache (na `run gamedata item ...`).
- `dg_names.py`: print DB2-namen per locale als Lua, uit de gamedata-cache.
- `dg_check.py`: ruwe controle van accolades/quotes/komma's in de Lua.
