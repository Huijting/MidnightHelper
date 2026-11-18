# Nakijkronde G2 — Forever-bazengids, 11 dungeons van stap 2a (18 nov 2026)

Deel: City of Dalaran (2959), Gnomeregan (90), Razorfen Kraul (47), Scarlet Monastery (189), The Drowned City (2970),
Razorfen Downs (129), Krol'dok Stronghold (3039), Uldaman (70), Zul'Farrak (209), Maraudon (349), Alcaz Prison (2994).
Nagekeken: `Modules\ForeverDungeonGuide.lua`, `Modules\ForeverDungeonGuideData.lua` (regels 453-1095), 349 tekstsleutels
(`FDG_*` + acht `FDGP_*`) in 7 talen. Repo niet aangeraakt.

GEMETEN = zelf gelezen op 18 nov 2026 in de genoemde bron. AFGELEID = beredeneerd uit wat gemeten is.

**Uitkomst**
- **FOUT: 4 bevindingen** — F1 één feit (Azshir); F2 een clientnaam die Engels bleef in 5 talen (Angry Tome); F3 een
  spelwoord in ptBR (7 regels); F4 zes baasnamen (5 frFR, 1 ruRU) die de naamregel niet volgen.
- **RISICO** — 22 Engelse tekstregels met een reparatie (B), 3 punten in de code (C), 30 vertaalregels (nl 1, de 5,
  fr 4, es 4, mx 3, pt 9, ru 4; D), plus een handvol punten die alleen in het spel te beslissen zijn.
- In orde bevonden: alle 89 npc-id's, alle 72 encounter-id's, alle 43 loot-rijen ("Dropped by" + rol), de Engelse
  baasnamen, de namen in deDE/esES/esMX/ptBR, de vleugel-logica, `IsBoss`, het level-bereik.

Detailbestanden (volledige bewijs-tabellen per regel, met URL en datum):
`fable_G2_part_W1.md` (Dalaran, Drowned City, Krol'dok, Alcaz) · `fable_G2_part_W2.md` (Gnomeregan, RFK, SM, RFD) ·
`fable_G2_part_W3.md` (Uldaman, ZF, Maraudon) · `fable_G2_part_T1.md` (nl, de, fr) · `fable_G2_part_T2.md` (es, mx, pt, ru).
Vertaalregels: `fable_G2_nlNL.txt` (24), `fable_G2_deDE.txt` (29), `fable_G2_frFR.txt` (28), `fable_G2_esES.txt` (28),
`fable_G2_esMX.txt` (4), `fable_G2_ptBR.txt` (40), `fable_G2_ruRU.txt` (28). Elk: eerst de 23 nieuwe teksten, dan de
verbeterde bestaande regels, vorm `<tab>KEY = "tekst",`. Zelf vertaald, niet door een moedertaalspreker nagekeken.

⚠️ `ForeverDungeonGuide.lua` is tijdens deze ronde gewijzigd (de naam-ticker en `ItemName` met `ContinueOnItemLoad`,
regels 111-144 en 341-366). De regelnummers hieronder zijn die van de nieuwe versie (454 regels).

---

## A. FOUT

### F1 · `FDG_SM_2_D2` (Azshir the Sleepless) — de fear raakt één speler, niet de groep
- Nu: "Fears the group; his curse hurts when it runs out."
- GEMETEN, Wowhead Forever-tooltip spell 7399 Terrify: "Terrifies an enemy, causing it to flee in fear for 4 sec. Only 1
  target can be terrified at a time." Method (15 nov 2026): "Azshir will cast Terrify, which will cause the target to run
  away in fear for 4 seconds." ConquestCapped (7 nov 2026): "fears with Terrify". Alleen Icy Veins (18 okt, bèta) zegt
  "AOE Fear". AFGELEID: dat hij spell-id 7399 gebruikt (twee gidsen noemen de spellnaam).
- Reparatie: `FDG_SM_2_D2 = "Fears one player for a few seconds; his curse hurts when it runs out.",`
  De tip (`FDG_SM_2_T`) blijft goed. Vertalingen: in alle zeven `fable_G2_<taal>.txt`.

### F2 · `FDG_DAL_6_D2` — "Angry Tomes" staat Engels in vijf talen
- deDE, frFR, esES, ptBR, ruRU hebben de Engelse naam in de zin; de clients tonen een eigen naam.
- GEMETEN, Wowhead Forever npc 254856 per taal: Wütender Foliant / Tome en colère / Tomo enfadado (esES en esMX) /
  Tomo Zangado / Злой фолиант.
- Reparatie: de regel `FDG_DAL_6_D2` in `fable_G2_deDE.txt`, `_frFR`, `_esES`, `_ptBR`, `_ruRU`. (esMX = esES, geen overlay.)
  De tip `FDG_DAL_6_T` ("the tomes") is in die bestanden meegenomen.

### F3 · ptBR — "bordão" moet "cajado" zijn (7 loot-regels)
- Sleutels: `FDG_DAL_L1`, `FDG_GNOMER_L2`, `FDG_RFK_L2`, `FDG_SM_L4`, `FDG_SM_L5`, `FDG_DROWN_L1`, `FDG_RFD_L1`.
- GEMETEN: DB2 `ItemSubClass` 2/10 ptBR = "Cajado" (build 1.60.1.70959); Wowhead Forever-tooltip item 9452 ptBR toont
  "Duas mãos / Cajado". Reparatie: de zeven regels in `fable_G2_ptBR.txt`.

### F4 · Baasnamen per taal — 6 namen volgen de naamplaat-regel niet (data, `names`)
De regel (kop van `ForeverDungeonGuide.lua`, keuze "B"): de naam van de Wowhead Forever-npc per taal; alleen als Wowhead
daar Engels geeft, de DB2-naam. Mijn script (`fable_g2_names.py`) vergeleek 89 bazen × 6 talen met Wowhead én DB2
`DungeonEncounter` per taal. GEMETEN: deDE 87/89, esES 88, esMX 88, ptBR 88 gelijk aan Wowhead (de rest = The Lost
Dwarves, een encounter-naam, en Charlga in deDE via de uitzondering). In frFR en ruRU staat op deze plekken de
DB2-spelling terwijl Wowhead een eigen, andere naam geeft:

| npc | taal | nu in de data (DB2) | Wowhead Forever = naamplaat | 
|---|---|---|---|
| 6235 | frFR | Électrocuteur 6000 | **Electrocuteur 6000** |
| 4542 | frFR | Grand inquisiteur Fairbanks | **Grand Inquisiteur Fairbanks** (Whitemane heeft al de hoofdletter) |
| 263886 | frFR | Élémentaire primitif | **Elémentaire primitif** |
| 7357 | frFR | Mordresh Œil-de-Feu | **Mordresh Oeil-de-feu** |
| 7358 | frFR | Amnennar le Porte-Froid | **Amnennar le Porte-froid** |
| 6229 | ruRU | "Толпогон 9-60" (met aanhalingstekens) | **Толпогон 9-60** |

- Reparatie: die zes waarden in de brondata van `ForeverDungeonGuideData.lua` (rijen met `npc = 6235`, `4542`, `263886`,
  `7357`, `7358`: veld `frFR`; rij `npc = 6229`: veld `ruRU`) en opnieuw genereren.
- Gaat `263886` om, dan gaat frFR `FDG_DROWN_8_D1` mee (staat in `fable_G2_frFR.txt`). De andere vier frFR-namen komen in
  geen zin voor (GEMETEN door de frFR-controle).
- De afwijking is GEMETEN; dat de Franse/Russische client precies de Wowhead-spelling op het naamplaatje zet is de
  aanname van de regel zelf (AFGELEID). Klein: het gaat om accenten, hoofdletters en aanhalingstekens.

---

## B. RISICO — feiten in de Engelse tekst (met reparatie)

Elke regel: twee of meer Forever-bronnen gelezen; bewijs met citaat, URL en datum in het genoemde detailbestand. De
spell-tooltips hieronder heb ik zelf nog eens opgehaald (GEMETEN, Wowhead Forever, 18 nov 2026); dat de baas die spell-id
gebruikt is steeds AFGELEID (naam komt overeen met de gids).

| # | Sleutel | Wat schuurt | Nieuwe Engelse tekst | Bewijs |
|---|---|---|---|---|
| R1 | `FDG_ALCAZ_3_D2` | Katerina's hoofdaanval ontbreekt | "Appears behind a random player and stabs them; the wound keeps bleeding until that player is healed above 90% health." | spell 1271761 Grievous Garrote: "…215 Physical damage every 3 sec until healed past 90%" + Wowhead-gids 15 nov (W1 R1) |
| R2 | `FDG_ALCAZ_3_T` | idem | "Crowd-control or kill the two Chaplains first: they heal. Healer: heal the stabbed player up at once." | idem |
| R3 | `FDG_KROL_4_D3` | "crowd-control … to free them" klopt niet | "Takes control of a player for up to 20 seconds; it ends sooner when that player drops to half health. Crowd-control them or damage them carefully." | spell 1280259 Convert: "for up to 20 sec or until the target's health is reduced to 50%" + Method 15 nov (W1 R2) |
| R4 | `FDG_DAL_3_D1` | "slowly" heeft geen bron (twee zeggen 3 seconden) | "Fires a long arcane beam that turns around the room; it can kill you." | spell 1241501 Focal Blast "3 sec cast" (W1 R3) |
| R5 | `FDG_DAL_3_D3` | adds komen pas bij de pull | "When the fight starts, small adds appear at the edge of the room." | Wowhead 9 nov, Icy Veins, wowfdb (W1 R8) |
| R6 | `FDG_DAL_6_T` | frontale cleave ontbreekt | "Kill the tomes first and turn it away from the group; ranged keep their distance, melee leave as soon as it starts winding up." | Method, wowfdb, Wowhead-journal "Arcing Smash" (W1 R7) |
| R7 | `FDG_DAL_8_D2` | de bol keert terug naar zijn beginpunt, niet naar de baas | "Throws an orb at a player that flies out and comes back to where it started; it hurts everyone in its path." | spell 1241515 Bounding Mana: "travels out and returns to its origin" (W1 R4) |
| R8 | `FDG_ALCAZ_2_D2` | één sleutelbos, voor één speler; dropkans onduidelijk | "One player gets the Overseer's Keyring from him: it opens the locked door to the lower floor." | item 263992: "Unique … Dropped by: Overseer Wrex, Drop Chance: 9.99%" (ter vergelijking Workshop Key 67,33%) + Warcraft Tavern, wowfdb (W1 R5) |
| R9 | `FDG_ALCAZ_4_D1` | de draak begint met vol leven (één auteur) | "Starts as the prisoner Zarla Ober, casting fire; when low she turns into a red dragon with full health." | Wowhead-gids 15 nov; twee npc's 255707/255702 (W1 R6). Optioneel |
| R10 | `FDG_KROL_7_T` + data | tip heeft 0 bronnen, de grijze regel zegt "één gids" | "No tactics are known yet." en `one = true` weg op de Kroog-rij | (W1 R9) |
| R11 | `FDG_GNOMER_2_D2` | gif staat in 2 gidsen, 3 noemen geen vaardigheden | "Most guides list no special moves; some warn of poison, so keep a cure ready." | (W2 RISICO 1) |
| R12 | `FDG_SM_6_D2` | "when his health is low" staat in één gids | "Speeds up his own and his hounds' attacks with Bloodlust; a priest or shaman can dispel it." | spell 6742 Bloodlust + Method, Tavern, ConquestCapped (W2 RISICO 2) |
| R13 | `FDG_RFD_2_D2` | "one after another" leest als losse mobs | "Before him, waves of enemies attack Belnistrasz; if he dies, the quest fails." | Tavern, ConquestCapped 7 nov (W2 RISICO 4) |
| R14 | `FDG_RFD_2_T` | "easy fight" verzwijgt de stilte-wolk | "Keep every enemy off Belnistrasz; against Plaguemaw, casters and healer stay at range: his stench stops spells near him." | spell 12946 Putrid Stench "…preventing them from casting spells" + ConquestCapped (W2 RISICO 5). Optioneel |
| R15 | `FDG_RFK_3_T` | "the caster's spells": wiens? | "Crowd-control his two helpers if you can, and interrupt every spell you can." | (W2 RISICO 7) |
| R16 | `FDG_MARA_1_D2` | hij is een vaste tijd weg, niet "tot de kopieën dood zijn" | "Now and then he vanishes for a short while and leaves small copies of himself; kill those, then go back to him." | spell 21708 "Channeled (15 sec cast)" + wowfdb (W3 R2) |
| R17 | `FDG_MARA_1_T` | belofte "sneller dood = eerder terug" heeft één bron | "Kill the small copies quickly while he is gone, and cure the poison if you can." | idem |
| R18 | `FDG_ULDA_8_D1` | "click": hoeveel spelers? bronnen: één / drie / hele groep | "To reach him: click the altar between four stone statues, several players at the same time (in Classic it took three); the statues wake one at a time, and the door opens when all four are dead." | (W3 R3) — in het spel meten |
| R19 | `FDG_ULDA_8_D2` | idem | "Click the altar in front of him to wake him; if one click does nothing, click it together. He brings stone dwarves to life, later big stone guards." | idem |
| R20 | `FDG_ULDA_3_T` | "everyone else" kan niet: melee staat in de stomp | "Tank: turn her away from the group; healer and ranged stay out of her stomp range." | spell 11876 War Stomp "nearby enemies" (W3 R4) |
| R21 | `FDG_MARA_8_D1` | Rotgrip is een crocolisk ("crocodile" bestaat niet in WoW) | "A big crocolisk in the water under the princess's platform; clear the hydras there first." | drie gidsen; clientwoord per taal uit DB2 `CreatureFamily` 6 (W3 R5) |
| R22 | `FDG_ZF_6_D2` | "come up": geen bron (hearthproof: "to the foot of the stairs") | "Nekrum and Shadowpriest Sezz'ziz come together as the last wave." | (W3 R6) |

Alle 22 + F1 staan vertaald bovenaan elk `fable_G2_<taal>.txt` (esMX: alleen `FDG_RFD_2_T` wijkt af van esES).

**Geen tekstwijziging, wel in het spel meten (staat grotendeels al als MEASURE in de data):**
- Tinkerer Gizlock, deel van Maraudon (`part = "FDGP_EARTH_SONG_FALLS"`): bronnen verdeeld. Nieuw, GEMETEN: Classic Era
  1.15.9.70576 geeft hem in DB2 óók OrderIndex 1500, en daar staat hij in Earth Song Falls. Het DB2-argument voor "paars"
  vervalt dus; MH's keuze is de best gesteunde (W3 R1).
- Ragglesnout `rare = true`: twee Forever-gidsen zeggen rare; de tooltip zegt "Elite", maar de Classic-tooltip ook
  (positieve controle: Halmgar en Azshir zijn in beide "Rare Elite"). Beslist niets (W2 RISICO 6).
- `FDG_SM_7_D2` "about half health": alleen ConquestCapped; "about" dekt het af. Geen wijziging nodig.
- Meshlok staat in MH ná Celebras; op de route komt hij ervóór (bovenaan Poison Falls). Optioneel de twee rijen omwisselen.
- Zul'Farrak en Maraudon: Warcraft Tavern zegt zelf "currently based on WoW Classic"; geen enkele bron heeft deze drie
  (Uldaman, ZF, Maraudon) in Forever gezien. Hard zijn alleen de Forever-tooltips (60+ spells, 12 items; W3).
- Alle "WH"-poten in de `-- src:`-commentaren van Gnomeregan/RFK/SM/RFD konden niet geopend worden (wowhead.com gaf een
  lege pagina); die regels zijn met Tavern/ConquestCapped/Method/Mobalytics bevestigd. De codes GS, WFA, GG, GGA waren
  niet thuis te brengen. Icy Veins-pagina voor RFD, Krol'dok en Alcaz: niet gevonden.
- Niet in MH en dat is terecht: DB2-encounter 3312 "Mana Wraith" (npc 246931, straat-elite, door niemand als baas
  gevochten) en de haai Zin'aka in de Drowned City (geen baas, geen loot).

---

## C. RISICO — code (`Modules\ForeverDungeonGuide.lua`)

### C1 · `ItemName` stapelt laad-callbacks: mogelijk een hapering bij de eerste keer openen (r.133-141) — AFGELEID
- Elke `Fill()` waarin een itemnaam nog ontbreekt, roept voor élk ontbrekend item opnieuw
  `Item:CreateFromItemID(id):ContinueOnItemLoad(...)` aan. Blizzards `ItemEventListener:AddCallback` voegt elke callback
  toe (geen ontdubbeling; AFGELEID uit Blizzards FrameXML, niet gemeten in de Forever-client). `Fill()` draait bij
  OnShow, twee keer in `ShowForeverDungeonGuide` (r.379 en r.383), elke 0,5 s door de ticker, bij elk
  `GET_ITEM_INFO_RECEIVED` en `PLAYER_TARGET_CHANGED`, én vanuit elke callback zelf.
- Gevolg: komt item A binnen, dan draaien al zijn callbacks elk een `Fill()`, en elke `Fill()` meldt zich opnieuw aan voor
  B, C, …: het aantal verdubbelt per item. Scarlet Monastery heeft 12 items op één pagina; in het slechtste geval zijn
  dat duizenden `Fill()`'s in één frame bij een koude item-cache. Of items één voor één binnenkomen is niet gemeten.
- Reparatie (één callback per item):
  ```lua
  local waitingItem = {} -- item id -> true while a load callback is registered (one per item, not one per Fill)
  ...
  	if Item and Item.CreateFromItemID and not waitingItem[id] then
  		waitingItem[id] = true
  		pcall(function()
  			Item:CreateFromItemID(id):ContinueOnItemLoad(function()
  				waitingItem[id] = nil
  				if ns.ForeverDungeonGuideRefresh then
  					ns.ForeverDungeonGuideRefresh()
  				end
  			end)
  		end)
  	end
  ```
  De ticker (r.341-358) blijft het vangnet als een callback nooit komt.

### C2 · De dungeonlijst springt terug terwijl je scrolt (r.319-329) — AFGELEID
- `Fill()` scrolt de lijst naar de gekozen dungeon zodra diens knop buiten beeld is. `Fill()` draait ook bij elk
  `GET_ITEM_INFO_RECEIVED` (elk item van elke addon), elke doelwissel en de ticker. 28 dungeons × 28 px = 784 px op een
  venster van ±380 px: scrol je naar beneden om een andere dungeon te kiezen, dan zet het eerstvolgende event de lijst terug.
- Reparatie: alleen scrollen als de keuze veranderd is, en pas afvinken als het scrollbereik bekend is (houdt de
  "eerste keer openen"-herkansing van r.380-384 heel):
  ```lua
  		if b.map == selected and f.list and f.scrolledFor ~= selected then
  			local top, view = (i - 1) * 28, f.list:GetHeight() or 0
  			local range = f.list:GetVerticalScrollRange() or 0
  			if view > 0 and (range > 0 or #f.btns * 28 <= view) then
  				local cur = f.list:GetVerticalScroll() or 0
  				if top < cur or top + 28 > cur + view then
  					f.list:SetVerticalScroll(math.max(0, math.min(top, range)))
  				end
  				f.scrolledFor = selected
  			end
  		end
  ```

### C3 · De tekst blijft op de oude scrollstand staan bij een andere dungeon (r.262-265, r.339) — AFGELEID
- Kies je onderaan een lange pagina (Scarlet Monastery) een andere dungeon, dan wordt de scrollstand alleen afgekapt op
  de nieuwe hoogte, niet teruggezet: de nieuwe pagina opent halverwege, baas 1 staat boven beeld.
- Reparatie, in `Fill()` vlak vóór `f.body:SetText(...)`:
  ```lua
  	if f.shownMap ~= selected then
  		f.shownMap = selected
  		f.scroll:SetVerticalScroll(0)
  	end
  ```

### Kleiner (geen fout)
- `optional = true` in de data wordt nergens gelezen (alleen `rare`, `one`, `recheck`, `part`); "Optional:" staat in de
  D1-tekst zelf. Dode vlag: gebruiken (grijs label zoals bij `rare`) of weglaten. GEMETEN (Grep: 0 keer `.optional` in dit bestand).
- Lyn the Ignored (npc 247032) is bij Wowhead Forever "Rare Elite"; de data zegt `optional`, de tekst legt het oproepen
  uit. In orde, alleen ter info.
- Commentaar r.182 ("the wing names are the English ones the dungeon list already uses") klopt niet meer: het zijn
  `FDGP_*`-sleutels.
- In orde bevonden door de code te lezen: `Order()` (één pagina per map, bereik over alle rijen: SM 30-46), kopjes per
  `part`, `IsBoss` met getal of lijst, `byNpc` zonder nil-sleutel, loot-rij met `part`, `#Order()` in `/mh bosses check`,
  GUID-splitsing (zesde veld = npc-id). Niet in het spel gezien.

---

## D. RISICO — vertalingen en namen (reparaties in de taalbestanden)

Volledige lijst met oud → nieuw: `fable_G2_part_T1.md` en `fable_G2_part_T2.md`. Kern:
- **Betekenis:** in geen van de zes talen zegt een regel iets anders dan het Engels (349 regels per taal gelezen).
  Vorm en markup in orde; nlNL houdt Engelse spelnamen en zegt nergens "spreuken".
- **`FDG_DROWN_2_D1`** (alle zes): "Brinescale Priestess" stond (half) Engels. Vervangen door het clanwoord van de client
  (GEMETEN in npc 258799/258804: der Laugenschuppen / écaille-de-mer / Escamasalada / escamasalada / Escamoura / из клана
  Соленой Чешуи); de naam van de Priestess zelf is AFGELEID (geen id gevonden; npc-id's 258500-259400 afgezocht).
- **`FDG_DROWN_2_D3`, `FDG_DROWN_3_D3`** (de, fr, es, pt, ru): "Glowing Pearl" stond Engels; vervangen door een
  omschrijving in kleine letters. Objectnaam NIET gemeten (geen id). Overslaan mag tot de naam gemeten is.
- **esES `FDG_ALCAZ_3_D1`**: "Alcaz Chaplain" → "capellanes de Alcaz" (Wowhead esES geeft "[Alcaz Chaplain]" = gat, niet gemeten; esMX wel gemeten).
- **Armory**: esMX nieuwe overlay-regels "Arsenal" (`FDGP_ARMORY`, `FDG_SM_7_D3`), ptBR "Arsenal" → "Armaria". AFGELEID uit
  Wrath Classic `LFGDungeons` 3.80.2.70522; Forever heeft zelf geen vleugelnamen (GEMETEN: `LFGDungeons` 1.60.1.70959
  heeft één rij "Scarlet Monastery", `AreaTable` geen subzones voor map 189/349/90).
- **ptBR**: "placa" → "placas" (3 regels), "Resistência à Natureza" (1). **ruRU** `FDG_ULDA_3_D1`: "комнате с макетом
  Ульдамана" (tekst op de staf zelf, item 7733). **deDE** `FDG_ZF_1_T`, `FDG_ALCAZ_2_T` en **nlNL** `FDG_SM_9_D1`: dubbelzinnig.
- **esMX-overlay**: voor elke gemeten Mexicaanse naam die afwijkt van esES staat de sleutel in de overlay (0 ontbrekend).
- **"The Shaft of Tsol" / "The Scarlet Key"**: de clientnaam draagt het lidwoord (item 7741, 7146; GEMETEN). De packs
  doen dat goed; het Engels laat "The" weg, dat leest gewoon.

**frFR-apostrofs (geen wijziging voorgesteld):** bij 13 frFR-namen verschilt de data alleen in het teken ’ (DB2) tegen '
(Wowhead), en bij « Pyromancien » Braxton in het soort spatie. Of Wowhead het teken platslaat of de client het echt zo
toont, is niet te meten; in mijn 89 namen gaf Wowhead nergens een ’. Laten staan tot één naam in de Franse client gezien is.

**Vijf namen via de DB2-uitzondering (volgens de regel, ter info):** frFR Hérode, Galgann Martel-de-Feu, Grimelok,
Noxcion en deDE Charlga Klingenflanke: Wowhead geeft daar de Engelse naam, de data de DB2-naam. Dat is de regel; op het
naamplaatje staat dan waarschijnlijk de Engelse naam (AFGELEID).

**Niet te meten (zeg ik liever dan weglaten):** Glowing Pearl (object), Brinescale Priestess, Archmage Modera in de
dungeon (geen id's); Violet Hold, Violet Citadel, Hall of Gears (alleen retail-`AreaTable`, dus AFGELEID voor Forever);
Poison Falls en de vier SM-vleugels (nergens een rij: gewone vertalingen); Zarla Ober (Wowhead: in geen taal vertaald).

---

## E. Gemeten en in orde

- **npc-id's**: alle 89 bazen + 6 `extraNpc`'s (Chomper 6215, Ruuzlu 7797, Eric 6907, Olaf 6908, Zarla Ober 255707,
  Min'loth 260274) bestaan in Wowhead Forever met de naam uit de data; rare-vlaggen kloppen met "Rare Elite" (behalve
  Ragglesnout, zie B). Krol'dok-npc's en Zarla Ober hebben bij Wowhead geen zone; de naam klopt.
- **encounter-id's**: alle 72 gelijk aan DB2 `DungeonEncounter` 1.60.1.70959 (79 rijen voor deze 11 maps; de 7 extra
  zijn Gnomeregans tweede difficulty (6) en Mana Wraith). De vier naamverschillen DB2 ↔ npc (Mana Elemental, Deathless
  Guardians, Handler Ashka, Overseer Mugg) staan al als MEASURE in de data.
- **loot**: alle 43 rijen: Wowhead Forever-tooltip "Dropped by" = de baas in de data, en type/stat in de roltekst klopt
  met de tooltip (script `fable_g2_items.py`).
- **tooltips die de bevindingen dragen** (zelf opgehaald): spells 7399, 5137, 1271761, 1280259, 21708, 1241515, 1241501,
  6742, 12946; items 263992, 6893.
- **clientnamen in de teksten**, per taal gemeten (Wowhead Forever): 13 items (Tome of Dalaran 275989, Black Tome
  276561, Workshop Key 6893, The Scarlet Key 7146, The Shaft of Tsol 7741, Gni'kiv Medallion 7740, Staff of Prehistoria
  7733, Mallet of Zul'Farrak 9240, Divino-matic Rod 8548, Celebrian Rod 17702, Celebrian Diamond 17703, Scepter of
  Celebras 17191, Overseer's Keyring 263992) en 22 npc's (o.a. Emi Shortfuse 7998, Angry Tome 254856, Mana Phantom
  269475, Undying Offering 263899, Alcaz Chaplain 255262).

## F. Hulpscripts (scratchpad, alleen lezen)
`fable_g2_names.py` (namen per taal tegen Wowhead + DB2), `fable_g2_items.py` (volledige tooltips; loot-rijen),
`fable_g2_scan.py` (namen in 7 talen; id-reeks afzoeken), `fable_g2_t2.py` (DB2-woorden per taal).
