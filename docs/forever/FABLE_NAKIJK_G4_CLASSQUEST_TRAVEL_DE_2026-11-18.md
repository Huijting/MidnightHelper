# Nakijkronde G4 — class-quest-voorwaarden, Travel, Disenchant (Forever-werk van 18 nov 2026)

Nagekeken op 18 nov 2026, onafhankelijk: alleen de code, de teksten en eigen metingen. Geen rapporten van anderen gelezen.
Repo niet aangeraakt. GEMETEN = zelf gezien in de genoemde bron op 18 nov 2026. AFGELEID = beredeneerd.

Bronnen (allemaal 18 nov 2026 geraadpleegd):
- **DB2** = wago.tools, Forever build 1.60.1.70959 (via `tools/gamedata.py`), ook per taal.
- **WH-F** = Wowhead Forever tooltip-JSON (npc, quest, item, object, spell), ook per taal.
- **UI-bron** = Blizzards eigen UI-code, `github.com/Gethe/wow-ui-source`, branch `forever` (bijgewerkt 17 nov 2026).
- Gidsen: Wowhead Forever "Collecting Library Books" (13 nov 2026), Wowhead Forever "Zephras Isle Zone Overview"
  (22 okt 2026), warcraft.wiki.gg (Research Access, Study, Library book, Zephras Isle), games.gg "WoW Forever Travel
  Guide" (nov 2026), lfcarry Dreadsteed-gids (17 nov 2026), theforeverguides Dreadsteed (31 okt 2026), leprestore
  Dreadsteed (27 okt 2026), wow-professions / conquestcapped / forevermastery (disenchant), sheephappens.app (boeken).
- Rekenscript (alleen lezen): `scratchpad/fable_g4_calc.py` (`travel`, `flight`, `de`, `loc`).
- De gedownloade Blizzard-bestanden (SecureTemplates.lua/.xml, ContainerFrame) staan in `scratchpad/fable_g4_dl/`.

## Kort

| # | Soort | Waar | Wat |
|---|---|---|---|
| F1 | **FOUT** (code) | `ForeverDisenchant.lua:345` | De "Disenchant next"-knop doet niets als de spelinstelling "cast on key down" aan staat (de gewone stand). |
| F2 | **FOUT** (code) | `ForeverClassQuests.lua:370-394` + `Step()` 2358 | De waarschuwing "koop eerst Shadowy Potions" komt niet als je de drie materiaal-quests van Mor'zul ook in je log hebt (het gewone geval). |
| F3 | **FOUT** (tekst+code) | `ForeverTravel.lua:439-440` | De veerboot terug van Feathermoon heet in de lijst "The boat to Feralas", terwijl je al in Feralas bent. |
| F4 | **FOUT** (vertaling) | de/fr/es/esMX/pt/ru | Het woord voor "skycutter" in de Thunder Bluff-zin is zelf bedacht; deDE ook in `FTRAVEL_SKY_FMT`. De client zegt iets anders. |
| R1 | RISICO | `FTRAVEL_NOTE_TB` | "Fly to Orgrimmar with Tal" kan alleen als je het vliegpunt Orgrimmar al kent. |
| R2 | RISICO | `FCITY_SUB_FLIGHT` | "from any other one you know" klopt alleen op hetzelfde continent. |
| R3 | RISICO | `FDE_TIP_UNSURE` | "probably can be disenchanted" leunt de verkeerde kant op: de enige bron zegt juist "kan niet". |
| R4 | RISICO | `FCQ_PRE_WL_RITUAL` | "first buy … needs all three" is te stellig: een warlock die de drie spullen al heeft mag het ritueel doen (250 goud bespaard). |
| R5 | RISICO | `FCQ_MA_BOOK_GET_FMT` | Het voorwerp in de wereld heet anders dan het boek ("Library Book", "Gnomish Tome"…); Ta'zo is een muurtekening. |
| R6 | RISICO (code) | `ForeverClassQuests.lua:279` | Ur'dan heeft geen naam in de data: de goud-zin zegt "you pay it at Felwood" (de: "bei Teufelswald", fr: "auprès de …"). |
| R7 | RISICO (code) | `ForeverTravel.lua:453-455` | `TitleCase` werkt niet op Russisch: de rijen beginnen daar met een kleine letter. |
| R8 | RISICO | `ForeverTravel.lua` LINKS | Menethil → Southshore ontbreekt in de zoeklijst (de boot stopt daar wel). |
| R9 | RISICO | `ForeverCitySpots.lua:175-239` | Vluchtmeesters staan met hun Engelse naam, ook op een Russische/Spaanse client (zelfde patroon als de bankiers van 17 nov). |
| R10 | RISICO (code) | `ForeverVendors.lua:205,236` | Het oude reserve-venster is te laag voor 15 knoppen (de onderste twee vallen over de hint). Wordt alleen getoond als de Find-tab ontbreekt. |
| R11 | RISICO | `ForeverDisenchant.lua` PickNext 276-291 | De knop pakt ook paarse (epic) items. Eén verkeerde klik is een item kwijt. Voorstel: schakelaar. |
| R12 | RISICO (klein) | `ForeverClassQuests.lua:1106` en `:1221` | High Priest Rohan staat op twee plekken (24.73,8.16 en 26.98,7.30). |

Alles wat hieronder niet als FOUT of RISICO staat, is nagemeten en klopt.

---

## (a) Class-quest-voorwaarden — `Modules/ForeverClassQuests.lua`

### Nagemeten en goed

| Bewering in code/tekst | Uitkomst | Bron |
|---|---|---|
| Paladin 7637: 150 goud, bij High Priest Rohan | klopt: "donation of 150 gold", Money:150 | GEMETEN WH-F quest 7637 |
| Paladin 7642: 5 Stratholme Holy Water, 10 Arthas' Tears, 40 Runecloth, 6 Arcanite Bars, 150 goud, Grimand Elmore | klopt, in die volgorde (doel 1-4) + Money:150 | GEMETEN WH-F quest 7642 |
| Grimand Elmore 59.71,33.77 Stormwind | klopt (59.6,34.0 in het Forever-kader; 51.6,12.x is het oude Classic-kader) | GEMETEN WH-F npc 1416 |
| Lord Grayson 48.43,50.22 | klopt (48.4-48.6, 50.0) | GEMETEN WH-F npc 928 |
| Warlock 7623: "Purchase Shadowy Potions from Gorzeeki … travel through Jaedenar … Lord Banehollow" | klopt | GEMETEN WH-F quest 7623 |
| Shadowy Potion 18802: 6 goud per 3 | klopt: BuyPrice 60000, VendorStackCount 3; gids: "6g for a stack of 3"; werkt 20 minuten | GEMETEN DB2 ItemSparse + spell 23179 (WH-F) + theforeverguides 31 okt, lfcarry 17 nov |
| Xorothian Stardust 18687: 150 goud bij Ur'dan, die naast Banehollow staat | klopt: BuyPrice 1500000; Ur'dan 36.2,44.4, Banehollow 36.0,44.4 | GEMETEN DB2 + WH-F npc 14522/9516 + lfcarry 17 nov |
| Ritueel 7631: J'eevee's Jar 150 + Black Lodestone 50 + Xorothian Glyphs 50 = 250 goud, bij Gorzeeki | klopt | GEMETEN DB2 (1500000/500000/500000) + lfcarry 17 nov |
| Gorzeeki 12.43,31.63 / Mor'zul 12.69,31.64 Burning Steppes | klopt (12.4-12.6, 31.4-31.6) | GEMETEN WH-F npc 14437/14436 |
| Volgorde 7623 → 7624 → 7625 (→ 7629), 7631 na 7629 + 7630 | klopt met drie gidsen | GEMETEN leprestore 27 okt, lfcarry 17 nov; AFGELEID voor de precieze `needs` |
| Overige Dreadsteed-aantallen: 30 Blood, 10 Elixir, 6 Shards + 25 Dark Iron Ore, 35 Dragonscales, 3 Arcanite | klopt alle vijf | GEMETEN WH-F quest 7563/7626/7627/7628/7630 |
| Priest: "Lesser Heal (Rank 2)" in 5624, 5625, 5621, 5648, 5650 | klopt, alle vijf noemen Rank 2 | GEMETEN WH-F |
| Rank 2 = spell 2052 op level 4; Rank 3 = 2053 op level 10 | klopt | GEMETEN DB2 SpellLevels |
| De vijf dorps-trainers (Josetta, Maxan Anvol, Laurna, Tai'jin, Beryl) zijn Priest Trainer, plekken kloppen | klopt | GEMETEN WH-F npc 377/1226/3600/3706/2129 |
| Mage 1948: 10 Witherbark Totem Sticks | klopt: het gebruik van de stok (spell 9055) vraagt 9 extra sticks; tooltip "Gather 10 totem sticks, and use them at the Stone of Outer Binding"; quest toont "x 10" | GEMETEN DB2 ItemEffect 98276 + SpellReagents 9055 + WH-F spell 9055 + quest 1948 |
| 1948 doelen: 1 = Jade, 2 = Bolt Charged Bramble | klopt (volgorde in de tooltip) | GEMETEN WH-F; dat de client-index gelijk is = AFGELEID |
| Research Access 97286: de bibliothecaris biedt hem aan na je eerste boek; geeft Study | klopt | GEMETEN warcraft.wiki.gg (Research Access), Wowhead-gids 13 nov, sheephappens |
| Study 1302508: level 6, 1 uur cooldown | klopt: "Requires level 6", "1 hour cooldown" (de Wowhead-gids zegt "one-day"; de spell-tooltip wint) | GEMETEN WH-F spell + DB2 SpellLevels (6) |
| Garion Wendell 48.9,86.5 Stormwind; Owen Thadd 73.4,33.0 Undercity | klopt (48.8,86.6 / 73.4,33.0) | GEMETEN WH-F npc 211033/211022 |
| START_BOOKS, 6 gemeten plekken (Tower of Azora 65.4,70.1; Hall of Explorers 75.7,10.5; Thelsamar 35.6,48.9; Brill 59.4,52.3; Ratchet 62.7,36.3; Sepulcher 43.4,41.2) | klopt alle zes | GEMETEN WH-F object 386759/386691/408014/405879/407566/410299 |
| START_BOOKS, 2 gids-plekken (Sentinel Hill 52.7,53.8; Ta'zo Orgrimmar 38.7,78.4) | klopt met drie bronnen | GEMETEN Wowhead-gids 13 nov, warcraft.wiki.gg, sheephappens |
| Boek-items en hun namen (7 stuks), boek-quests 78124-79949 (20 van de 40 nagekeken) | klopt | GEMETEN DB2 ItemSparse + WH-F quest |
| Kant per boek (Alliance: Theocritus, Antonidas, Rumi; Horde: Primer, Ta'zo, Ataeric; Baxtan neutraal) | klopt | GEMETEN sheephappens ("Alliance only" / "Horde only") |
| Alle spelnamen in de zes vertalingen van de PRE-, BOOK- en STICKS-teksten (8 items, Lesser Heal, Research Access, Dire Maul, Jaedenar, Circle of Outer Binding, Gorzeeki) | klopt, elk gelijk aan de client | GEMETEN DB2 ItemSparse/SpellName/AreaTable per taal + WH-F quest 97286 per taal |

Opmerking bij de boeken: de item-tooltips van **203754 (Antonidas)** en **207972 (Ta'zo)** dragen op Wowhead het label
"Added in Season of Discovery. May not be in WoW: Forever." Dat label is verouderd: de Wowhead-gids van 13 nov, de wiki
en een speler-reactie ("I could loot and turn in the Orgrimmar one") zeggen dat ze er zijn. Geen wijziging nodig.

### F2 — FOUT (code): de potion-waarschuwing komt niet in het gewone geval

`WlDreadsteed` is een `strict`-keten. `Current(c)` (regel 2131-2144) neemt dan **de eerste quest van de tabel die in je
log staat**. De tabel-volgorde is 7562, 7563, 7564, **7626, 7627, 7628, 7630**, 7623, 7624, 7625, 7629, 7631.
Mor'zul geeft 7626, 7627 en 7628 tegelijk (staat zo in het commentaar op regel 359, en in de gidsen). Wie die drie
aanneemt en daarna 7623 bij Gorzeeki, heeft als "huidige" quest 7626. `PreStep` kijkt alleen naar de huidige quest.
Gevolg: de zin "first buy Shadowy Potions … Bring 150 gold too" (regel 381) komt niet, juist op het moment dat je bij
Gorzeeki staat. Hij komt pas als 7626, 7627, 7628 en 7630 klaar zijn. (GEMETEN in de code; dat spelers alles tegelijk
aannemen = AFGELEID, de gidsen raden het aan.) Hetzelfde geldt voor de goud-check van 7624 en 7625.
De check van 7631 (ritueel-spullen) werkt wel: dan is al het andere klaar.

Reparatie (klein, verandert de volgorde niet): in `Step(c)`, direct na `local e = Current(c)` / de `if not e`-tak
(regel 2362-2365), toevoegen:

```lua
	-- strict chains run quests side by side: a "buy it here" warning (a pre with onlyMap) of ANY quest in your log
	-- comes first, also when another quest of the chain is the current one (second check, 18 Nov 2026).
	if c.strict then
		for _, o in ipairs(c.quests) do
			local oq = (o ~= e) and not AnyDone(o) and LogQuest(o)
			if oq then
				for _, p in ipairs(o.pre or {}) do
					if p.onlyMap then
						local s = PreStep({ pre = { p } }, oq)
						if s then
							return s
						end
					end
				end
			end
		end
	end
```

Andere mogelijkheid (keuze voor de bouwchat): het blok 7623, 7624, 7625, 7629 in de tabel vóór 7626 zetten. Dan komen de
reis-stappen (Felwood, Scholomance) vóór de materiaal-stappen. Dat verandert wel de volgorde die gisteren is nagekeken.

### R4 — RISICO: `FCQ_PRE_WL_RITUAL` is te stellig

De drie ritueel-spullen zijn herbruikbaar en soulbound. Een warlock die ze al heeft kan het ritueel voor je doen; dan
hoef jij ze niet te kopen (GEMETEN: lfcarry 17 nov "reusable BoP item"; leprestore 27 okt "Do not buy a personal set
before checking whether a Warlock in your party can bring usable tools"). Of dat in Forever zo werkt is niet in het
spel gezien. Nieuwe Engelse tekst:

`FCQ_PRE_WL_RITUAL = "first buy J'eevee's Jar, a Black Lodestone and Xorothian Glyphs from Gorzeeki (about 250 gold together): the ritual in Dire Maul needs all three. Not needed if a warlock who already owns them comes along and does the ritual",`

### R5 — RISICO: wat moet je precies aanklikken bij een boek

De tekst zegt "Click it where it lies", met de naam van het boek. In de wereld heet het voorwerp anders (GEMETEN WH-F
object-tooltips): 386759 en 386691 "Library Book", 408014 "Gnomish Tome", 405879 "Apothecary Society Primer",
407566 "Goblin Tome", 410299 "Arcane Secrets". The Lessons of Ta'zo is geen boek maar een stenen muurtekening
(sheephappens: "use the stone mural just before the mage lodge sign to trace it"). Nieuwe Engelse tekst:

`FCQ_MA_BOOK_GET_FMT = "first get a library book: %s. Click it where it lies (the object in the world can have another name, such as Library Book or Gnomish Tome; books are not drops). Then bring it to %s, and the librarian offers Research Access",`

Aanvulling (geen fout): Study kost elke keer een **Light Feather** en werkt alleen in de bibliotheek (GEMETEN WH-F spell
1302508: "Reagents: Light Feather … Requires a suitable library"). `FCQ_CHAIN_MA_STUDY` zegt dat niet.

### R6 — RISICO (code): "you pay it at Felwood"

`WL_P.urdan` (regel 279) heeft geen `npc`. `PreStep` (regel 2329) valt dan terug op de zone-naam. De zin wordt
"first get 150g: you pay it at Felwood …"; in het Duits "bei Teufelswald", in het Frans "auprès de Gangrebois" (een
voorzetsel voor een persoon). Reparatie:

- `ForeverClassQuests.lua:279`: `urdan = { npc = "Ur'dan", id = 14522, m = 1448, x = 36.17, y = 44.46 },`
- in `NPC_NAMES` (bij regel 1822): `[14522] = { ruRU = "Ур'дан" },` (GEMETEN WH-F npc 14522 ruRU; de andere talen
  schrijven "Ur'dan", zie hun `FCQ_OBJ_WL_STARDUST`-tekst, AFGELEID).

Daarna zijn alle `at`-plekken personen. Dan leest "you pay it at %s" in het Engels, Spaans en Portugees beter als
"to %s" / "a %s" (zie de taalbestanden; klein).

### R12 — RISICO (klein): Rohan op twee plekken

`PR_P.rohan` = 24.73, 8.16 (regel 1106) en `PA_P.rohan` = 26.98, 7.30 (regel 1221), zelfde npc 11406. Wowhead Forever
geeft negen punten tussen 23.4,7.0 en 26.8,7.6 (hij loopt, of is verplaatst). Het verschil is ruim 2 kaartpunten in
Ironforge (dezelfde hal): je ziet hem vanaf beide plekken (AFGELEID). Eén waarde gebruiken is netter (regel in de repo: trainers uit HandyNotes =
24.73, 8.16).

### Code nagelopen, geen fout gevonden
`BookStep` (2262-2282), `NearestBook` (2238-2258), `PreStep` (2311-2356): nil-veilig (pcall rond de API's, `list[1]`
als terugval, `here` alleen bij `onlyMap`), de `turn`-fase van 7642 komt na de vier doelen, `unlessItem` werkt.
Eén randgeval bij 1948 (regel 1596): net nadat je de 10 sticks hebt gebruikt en vóór je de Bramble oppakt (ongeveer tien
seconden) zegt de stap weer "defeat Witherbark trolls for 10 sticks". Het herstelt zichzelf.

---

## (b) Travel — `ForeverTravel.lua`, `ForeverCitySpots.lua` (`flight`), `ForeverVendors.lua`

### Nagemeten en goed

- **Alle 14 overtochten** (LINKS A1-A4, H1, H2, N1, N2, S1, S2 + TRAVEL_EXTRA X1, X2): elke halte opnieuw uitgerekend uit
  DB2 `TaxiPathNode` (de knopen met Delay > 0) en `UiMapAssignment`. **Alle 24 coördinaten zijn op 0,01 gelijk** aan de
  code (GEMETEN DB2 + eigen omrekening, `fable_g4_calc.py travel`). Pad-nummers in het commentaar kloppen
  (11616, 293, 11167, 292, 302, 285, 241, 11391, 11398, 11457, 301, 303).
- De lus 11167 loopt Menethil (index 7) → Southshore (20) → Auberdine (34) → Menethil: `A3a`, `A3c`, `A3m` en
  "one way only" kloppen (GEMETEN DB2; games.gg noemt dezelfde lus).
- **De lijst van routes is volledig**: games.gg telt 13 routes en het zijn precies deze (plus het portaal bij
  Rut'theran). Geen zeppelin naar Thunder Bluff (GEMETEN games.gg + DB2). De vlucht TB ↔ Orgrimmar bestaat
  (GEMETEN DB2 TaxiPath 387 en 42).
- Skycutters: Zephras 65.84,83.81 ↔ Dalaran 12.83,51.17 en Zephras 57.78,81.01 ↔ Mulgore 34.33,26.05 kloppen met de
  Wowhead-gids van 22 okt (65.9,83.5 / 12.5,51.8 / 57.9,80.9 / 34.3,25.8) en de wiki.
- **Orgrimmar-toren**: "South side: Undercity. North side: Grom'gol" klopt. Undercity-halte 50.98,13.91 (zuid),
  Grom'gol-halte 50.47,12.69 (noord) (GEMETEN DB2); zeppelin-meesters Frezza (Undercity) 50.8,13.4-13.6 en Snurk
  Bucksquick (Grom'gol) 50.6,12.8 (GEMETEN WH-F npc 9564/12136). "Main (south) gate, turn left (east)": de toren ligt
  een paar honderd meter oost van het midden van Orgrimmar (Doras, de vluchtmeester, staat op Durotar-x 44.5; de
  haltes op x 50.5-51.0) (AFGELEID uit DB2-posities; de poort zelf niet gemeten).
- **Undercity-toren**: "walk out to the north … by the road to Brill" klopt: de toren (60.6-61.9, 58.9) ligt recht
  noord van de stad (61.2, 75.3) (GEMETEN DB2). Zapetta (Orgrimmar) staat op 60.8,58.8, Hin Denburg (Grom'gol) op
  61.8,59.0 (GEMETEN WH-F).
- **65 vluchtmeesters**: alle 65 npc-id's en namen kloppen (GEMETEN WH-F), alle 65 kanten kloppen met DB2 `TaxiNodes`
  (Flags 1025 = Alliance, 1026 = Horde, 1027 = beide), alle 65 plekken liggen binnen 0,6 van de DB2-knoop
  (`fable_g4_calc.py flight`: 0 afwijkingen). De 65 zijn precies alle actieve knopen. Weggelaten en terecht: Nighthaven
  62/63 (alleen druids), de vier torens in Eastern Plaguelands 84-87, Tidegear Coast 3205 en Powderfuse Port 3274/3275
  (geen vliegroutes in DB2 `TaxiPath`).
- **Khaelyn Steelwing en Georgia (Light's Hope)**: de waarden 71.7,49.6 en 70.5,47.6 zijn goed. De Forever-kaart van
  Eastern Plaguelands heeft andere randen dan Classic (GEMETEN DB2 `UiMapAssignment` 1423). Wowhead toont daar nog het
  oude kader (81.5,59.2). Tweede bewijs: het boek "A Study of the Light" bij Light's Hope staat in de wiki als
  [81.7,57.8] én [71.8,48.2]. "CHECK IN GAME" in het commentaar kan weg.
  ⚠️ Voor de anderen: **elke Wowhead-coördinaat in Eastern Plaguelands is het oude kader** en moet worden omgerekend.
- Plaatsnamen in de vijf vertalingen van de reis-teksten (Undercity, Thunder Bluff, Brill, Feathermoon Stronghold,
  Zephras Isle, Rut'theran, Deeprun Tram): alle gelijk aan de client (GEMETEN DB2 `AreaTable` per taal).
- `FCITY_SUB_TRANSPORT` noemt de knop "Show the way"; dat is `FOV_GO` in elke taal (GEMETEN in de packs).

### F3 — FOUT: "The boat to Feralas" op Sardor Isle

`X2` (regel 439-440) heeft alleen `bName`. De terugweg (halte 31.01,39.51, bij Feathermoon Stronghold) krijgt de naam
van de kaart: "The boat to Feralas". Je bent daar al in Feralas. De boot gaat naar de Forgotten Coast (GEMETEN:
games.gg "Feathermoon Stronghold to the Forgotten Coast"; DB2 `AreaTable` 1108 "The Forgotten Coast").

Reparatie, `ForeverTravel.lua:439-440`:
```lua
	{ id = "X2", kind = "boat", side = "A", a = { MAP.FERALAS, 43.13, 42.76 }, b = { MAP.FERALAS, 31.01, 39.51 },
		aName = "FTRAVEL_FORGOTTEN_COAST", bName = "FTRAVEL_FEATHERMOON" },
```
Nieuwe sleutel `FTRAVEL_FORGOTTEN_COAST = "the Forgotten Coast",` (namen per taal gemeten, zie de taalbestanden).

### F4 — FOUT (vertaling): het woord voor skycutter

De client noemt het voertuig in quest 94946 (GEMETEN WH-F per taal): en "skycutter", de "Himmelssegler(schiff)",
fr "perceciel", es en esMX "cortacielos", pt "rasgacéus", ru "неборез".
- `FTRAVEL_NOTE_TB` zegt in de: "Himmelsschiff", fr: "vaisseau du ciel", es/esMX: "nave voladora", pt: "nave voadora",
  ru: "небесный корабль". Geen van die woorden staat in de client, en ze wijken af van `FTRAVEL_SKY_FMT` in dezelfde taal.
- deDE `FTRAVEL_SKY_FMT` (Translations2026.lua:20610) zegt "Himmelsschneider": ook niet het client-woord.
- fr/es/pt `FTRAVEL_SKY_FMT` hebben het goede woord, maar met een hoofdletter midden in de zin (klein).
Verbeterde regels staan in de taalbestanden.

### R1 — RISICO: `FTRAVEL_NOTE_TB`

"fly to Orgrimmar with Tal" werkt alleen als je het vliegpunt Orgrimmar al hebt. Een nieuwe Tauren heeft dat niet
(GEMETEN games.gg: "Flight paths only work once you've picked them up" en "a run through the Barrens to Orgrimmar
unless you already have the Orgrimmar flight path"). Nieuwe Engelse tekst:

`FTRAVEL_NOTE_TB = "Looking for a zeppelin? Thunder Bluff has none. If you know the Orgrimmar flight point, fly there with Tal and take the zeppelin; the first time you walk there, through the Barrens. This skycutter goes to Zephras Isle.",`

### R2 — RISICO: `FCITY_SUB_FLIGHT`

Vluchten gaan niet over zee: Stormwind vliegt alleen naar knopen in de Eastern Kingdoms, Orgrimmar en Thunder Bluff
alleen naar Kalimdor (GEMETEN DB2 `TaxiPath` voor knoop 2, 22, 23; voor de rest AFGELEID). Nieuwe Engelse tekst:

`FCITY_SUB_FLIGHT = "The flight masters of your side and the neutral ones. Nearest first. Talk to one once to learn that flight point; after that you can fly there from the other flight masters you know on the same continent.",`

### Kleinere punten
- **R7 (code)**: `TitleCase` (regel 453-455) gebruikt `%l`; dat pakt geen Cyrillische letters. Russische rijen heten
  "корабль (куда: …)" met een kleine letter. Reparatie:
  ```lua
  local function TitleCase(s)
  	local a, b = s:byte(1, 2)
  	if a == 0xD0 and b and b >= 0xB0 and b <= 0xBF then -- Cyrillic а-п
  		return string.char(0xD0, b - 0x20) .. s:sub(3)
  	elseif a == 0xD1 and b and b >= 0x80 and b <= 0x8F then -- Cyrillic р-я
  		return string.char(0xD0, b + 0x20) .. s:sub(3)
  	end
  	return (s:gsub("^%l", string.upper))
  end
  ```
- **R8**: in Menethil staat alleen "The boat to Darkshore (stay on board past Hillsbrad Foothills)". Wie naar Southshore
  wil, vindt niets. Voorstel in `TRAVEL_EXTRA`:
  `{ id = "X3", kind = "boat", side = "A", oneway = true, a = { MAP.WETLANDS, 4.49, 56.66 }, b = { MAP.HILLSBRAD, 50.67, 70.44 } },`
  (zelfde haltes als A3m, GEMETEN DB2).
- De Undercity-zin noemt geen kanten, de Orgrimmar-zin wel. Gemeten: west = Orgrimmar (60.64), oost = Grom'gol
  (61.92). Voorstel: "… West side: Orgrimmar. East side: Grom'gol." (staat in de taalbestanden).
- S1/S2 staan op kant A en H. Beide facties mogen op beide skycutters (GEMETEN Wowhead-gids 22 okt: "Players of both
  factions can take either skyboat"). De keuze is verdedigbaar (Dalaran is een Alliance-stad); alleen ter info.
- **R9**: de vluchtmeester-rijen tonen `name` uit de data, dus Engels, op elke client. Zelfde patroon als bank en
  veilinghuis van 17 nov. De namenregel vraagt de naam van de client.
- **R10**: reserve-venster `ForeverVendors.lua`: `H = 480` (regel 205), knoppen op `-50 - (i-1)*28` (regel 236). Met 15
  categorieën eindigt de laatste knop op 466 pixels van boven; de hint staat rond 450-462 (uitgerekend, AFGELEID).
  Voorstel: `H = 540`.
- A5 (portaal) en A6 (tram) staan niet in DB2; niet te meten. De Stormwind-kant van de tram (69.31,30.56) past bij het
  nieuwe Stormwind-kader (AFGELEID).

---

## (c) Disenchant — `ForeverDisenchant.lua`, `ForeverDisenchantData.lua`

### Nagemeten en goed

- **De 54 banden**: `brackets` is rij voor rij gelijk aan DB2 `ItemDisenchantLoot` (54 = 54, geen verschil). Elke rij
  heeft Subclass -1, SkillRequired 0, ExpansionID -2 (GEMETEN, `fable_g4_calc.py de`).
- **De 1615 "nooit"-items**: `noDisenchant` is precies de verzameling wapens en armor van kwaliteit 2-4 met
  `ItemSparse.Flags_0` bit 0x8000 (1615 = 1615, geen verschil) (GEMETEN).
- De andere regels van de code dekken de rest: 2 items met Bonding 4 (quest), 2 stapelbare, 29 buiten elke band
  (item level 1-4, of paars onder 40). Een wapen of armor met een zone- of instance-binding zonder de vlag
  vond ik niet (0 treffers, maar zonder positieve controle op die kolommen: dus AFGELEID, niet bewezen). TrinityCore
  weigert zulke items en ook items met de "conjured"-vlag; de code kijkt daar niet naar. 3083 items krijgen "ja",
  407 "niet zeker" (geen verkoopprijs) (GEMETEN).
- Geen skill-eis: drie gidsen zeggen "Enchanting skill 1 is enough" (wow-professions, conquestcapped, forevermastery).
  Groen/blauw/paars, wapens en armor (ook ringen, kettingen, trinkets, mantels, schilden), paars vanaf item level 40.
- Spell 13262 "Disenchant" is de enige spell met die naam en hoort bij Enchanting (GEMETEN DB2 `SpellName` +
  `SkillLineAbility` 7316, SkillLine 333).
- De client-woorden `ITEM_DISENCHANT_ANY_SKILL` "Disenchantable" en `ITEM_DISENCHANT_NOT_DISENCHANTABLE` "Cannot be
  disenchanted" bestaan (GEMETEN DB2 `GlobalStrings` 16772/16773, enUS).
- De volgorde van de `GetItemInfo`-uitkomsten op regel 87 klopt met de bekende API-volgorde (quality 3, ilvl 4,
  stack 8, sellPrice 11, classID 12, bindType 14) (AFGELEID: niet in de Forever-client zelf gezien).
- De veilige knop: `type1 = "spell"`, `spell = 13262`, `target-bag`, `target-slot` kloppen met de UI-bron:
  `SECURE_ACTIONS.spell` roept `CastSpellByID` aan (regel 396-405) en daarna `C_Container.UseContainerItem(bag, slot)`
  als de spell een item wil (regel 768-777). `alt-type1 = ""` is "geen actie". Verbergen in combat via de state driver.
- De tas-haken: `ContainerFrameMixin:UpdateItems`, `EnumerateValidItems`, `ContainerFrameItemButtonMixin:GetBagID`,
  `ContainerFrameContainer.ContainerFrames` en `ContainerFrameCombinedBags` bestaan in de UI-bron (Mainline
  `ContainerFrame.lua`, die Forever volgens zijn eigen `Camelot/ContainerFrame.lua` gebruikt; dat laatste AFGELEID).

### F1 — FOUT (code): de knop reageert niet met "cast on key down" aan

`ForeverDisenchant.lua:345` registreert alleen `"LeftButtonUp"`. In Blizzards Forever-code
(`SecureTemplates.lua` 792-826, GEMETEN):

```lua
local useOnKeyDown = not isSecureMousePress and (SecureActionButton_ShouldUseOnKeyDown(self) or pressAndHoldAction);
local clickAction = (down and useOnKeyDown) or (not down and not useOnKeyDown);
```
Voor een knop van een addon is `isSecureAction` leeg ("for now AddOns won't be able to have isKeyPress or
isSecureAction set", `SecureTemplates.xml` regel 6-7). Dan beslist de instelling `ActionButtonUseKeyDown`. Staat die
aan, dan telt alleen de klik **omlaag**; de knop krijgt alleen **omhoog** → er gebeurt niets. De repo weet dit al:
`FastMark.lua:155` zegt "an unpinned useOnKeyDown follows a CVar that can leave the button dead", en de andere veilige
knoppen registreren `"AnyUp", "AnyDown"` (grep: MissingBuff 811, Openables 449, Delves 4301, ForeverPartyPanel 218;
niet elk afzonderlijk nagelezen); FastMark 156-157 zet `useOnKeyDown` vast. Dat de instelling in Forever standaard aan
staat = AFGELEID (niet gemeten; Rob kan het zien met `/dump GetCVar("ActionButtonUseKeyDown")`).

Reparatie, direct na regel 345:
```lua
	btn:RegisterForClicks("LeftButtonUp")
	-- Pin the click phase: without this the CVar ActionButtonUseKeyDown decides, and "on" leaves an Up-only button
	-- dead (Forever SecureTemplates.lua, SecureActionButton_ShouldUseOnKeyDown; FastMark.lua has the same pin).
	btn:SetAttribute("useOnKeyDown", false)
```
(`SecureActionButton_ShouldUseOnKeyDown` leest eerst dit attribuut; `false` blijft `false`, regel 792-800 en 119-141.)

### R3 — RISICO: `FDE_TIP_UNSURE` leunt de verkeerde kant op

De enige bron over items zonder verkoopprijs is TrinityCore, en die zegt: kan **niet**. Niets zegt dat het wel kan.
"probably can be disenchanted" klinkt dus zekerder (en de andere kant op) dan de bron. Het gaat om 407 items, zoals
Benediction, Drakefire Amulet, Tome of Sacrifice (GEMETEN DB2). Nieuwe Engelse tekst:

`FDE_TIP_UNSURE = "MH: not sure this can be disenchanted (it has no sell price; such items often cannot)",`

### R11 — RISICO: de knop pakt ook paarse items
`PickNext` neemt het eerste "ja"-item in je tassen, ook een epic of een BoE die je wilde verkopen. De knop toont welk
item, en hij staat standaard uit, maar één klik te veel is definitief. Voorstel (spelers kiezen): een schakelaar
"ook paarse items", standaard uit; of paars alleen met Shift.

### Kleine punten
- `/mh disenchant` drukt "spell 13262 known (spellbook)" af. In Forever staat Disenchant niet in het spellbook maar in
  het Professions-venster (GEMETEN wow-professions, forevermastery). Die regel kan dus "false" zeggen bij een echte
  enchanter. Alleen de diagnose-tekst; `Enchanter()` kijkt naar het beroep en is goed.
- `OnDragStop` (regel 359-365) roept `StopMovingOrSizing()` aan zonder combat-check. Begin je te slepen en kom je dan in
  een gevecht, dan kan dat een geblokkeerde actie geven. Zeldzaam.

---

## Teksten in 7 talen

Nagekeken: alle `FTRAVEL_*`, `FCITY_CAT_/SUB_TRANSPORT/FLIGHT`, `FOV_FIND_SEC_TRAVEL`, `FDE_*`,
`FOV_Q_DISENCHANT*`, `FCQ_PRE_*`, `FCQ_MA_BOOK_*`, `FCQ_WAIT_MA_BOOK`, `FCQ_OBJ_MA_STICKS/BRAMBLE`,
`FCQ_OBJ_PA_ARCANITE`, `FCQ_OBJ_WL_STARDUST/RITUAL` in enUS, nlNL, deDE, frFR, esES (+ esMX), ptBR, ruRU.
Elke sleutel bestaat in elke taal. Spelnamen gemeten per taal (zie boven); alleen het skycutter-woord is fout (F4).
Verbeterde regels: `fable_G4_<taal>.txt` (enUS, nlNL, deDE, frFR, esES, esMX, ptBR, ruRU), alleen regels in de vorm
`<tab>KEY = "tekst",`. Welke regel bij welke bevinding hoort:

| Sleutel | Hoort bij | Talen |
|---|---|---|
| `FTRAVEL_SKY_FMT` | F4 (de: fout woord; fr/es/pt: alleen de hoofdletter) | de, fr, es, pt |
| `FTRAVEL_NOTE_TB` | F4 (skycutter-woord) + R1 (vliegpunt) | alle; en/nl alleen R1 |
| `FTRAVEL_FORGOTTEN_COAST` | F3, **nieuwe sleutel** (hoort bij de codewijziging) | alle behalve esMX (zelfde als esES) |
| `FTRAVEL_NOTE_UC` | aanvulling: kanten van de toren | alle behalve esMX |
| `FCITY_SUB_FLIGHT` | R2 | alle behalve esMX |
| `FDE_TIP_UNSURE` | R3 | alle behalve esMX |
| `FCQ_PRE_WL_RITUAL` | R4 | alle, ook esMX |
| `FCQ_MA_BOOK_GET_FMT` | R5 | alle behalve esMX |
| `FCQ_PRE_GOLD_FMT` | alleen ná R6 (dan is elke plek een persoon) | en, es, pt |

De vertalingen zijn door mij gemaakt, niet door een moedertaalspreker nagekeken. Elke spelnaam erin is gemeten
(DB2 `AreaTable`, `ItemSparse`, `ChrClasses` per taal; WH-F quest 94946 per taal).
Waar ze nu staan: `FTRAVEL_SKY_FMT` de/fr/es/pt in `Translations2026.lua` (20610, 20749, 20888, 21027); de rest in
`ForeverClassQuests_<taal>.lua`, `enUS.lua`, `nlNL.lua`; esMX alleen `FTRAVEL_NOTE_TB` (regel 154) en
`FCQ_PRE_WL_RITUAL` (regel 220).
Klein, nlNL: `FCQ_WAIT_MA_BOOK` zegt "bibliotheekboek", de drie `FCQ_MA_BOOK_*`-regels zeggen "library book".

## Niet kunnen meten (hoort op de testlijst)

1. Of `ActionButtonUseKeyDown` in Forever standaard aan staat (F1 is hoe dan ook veilig).
2. Of `CastSpellByID(13262)` werkt terwijl Disenchant niet in het spellbook staat.
3. Of `TooltipDataProcessor` in Forever bestaat (niet gevonden op het pad dat ik probeerde; de code vangt het af en
   `/mh disenchant` zegt het).
4. Of de server een item zonder verkoopprijs weigert (R3).
5. Vanaf welk level je een boek mag inleveren (wiki: "Requires 1", maar dat blad is van Season of Discovery).
6. Of een warlock met eigen ritueel-spullen in Forever echt voor een ander mag werken (R4).
7. De plek van de Orgrimmar-poort zelf, en A5/A6 (portaal, tram).
