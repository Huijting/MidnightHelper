# Onafhankelijke controle: "Weapon class quests" (ForeverClassQuests.lua)

Datum: 18 nov 2026. Build: Forever 1.60.1.70959 (wago DB2). Alleen gelezen, niets in de repo aangeraakt.
Gecontroleerd: `Modules/ForeverClassQuests.lua` regels 1651-1884 (blok), 2012-2020 (8 NPC_NAMES-rijen), motor
(`O`, `ObjFinished`, `MyChains`, `Ready`, `Current`, `PreStep`, `Step`, `NowSkip`, `NowPick`, `ForeverClassQuestList`),
`Locales/enUS.lua` regels 7060-7089 (30 teksten).

Bronnen (allemaal vandaag, 18 nov 2026, opgehaald):
- **WH-F tip** = Wowhead Forever tooltip-JSON via `run gamedata quest|npc|item|object … --game forever` (ook per taal).
- **WH-F pagina** = www.wowhead.com/forever/quest=… gelezen met WebFetch (geeft wel de questtekst en de Series, NIET de
  Quick Facts start/eind en NIET de comments: die zijn JavaScript).
- **DB2** = wago ItemSparse / Item / CharBaseInfo / UiMap 1.60.1.70959.
- **SP** = Spoken `Spoken_Quests/Data/Compendium.lua` + `Locale/Names/*.lua`. **ZY** = Zygor Forever (kandidaat).
- Gidsen met datum: conquestcapped (bijgewerkt 19 okt 2026), lfcarry (16 nov 2026), expcarry (14 okt 2026),
  magicgameworld (12 nov 2026). warcraft.wiki.gg (Classic-data, "remains in Classic and Forever").
- NIET kunnen lezen: Questie-Forever-data (QF) en foreverquestlog (FQL) zelf (niet lokaal, site niet gevonden),
  Wowhead-comments, icy-veins (403), metaforge (403). Waar de code alleen QF/FQL noemt, heb ik dat dus niet nagemeten.

Werkwijze-noot: gamedata is aangeroepen MET argumenten, zoals de opdracht vroeg (wijkt af van de vaste voordeur-regel
in CLAUDE.md; er kwam geen weigering).

---

## FOUT 1 - de pijl voor het ritueel (Heed My Call) staat ~9 kaartpunten naast de plek

`ForeverClassQuests.lua:1689` `steamPools = { m = 1441, x = 31.0, y = 45.8 }` (bron in de code: alleen FQL).

- GEMETEN (WH-F tip npc 216474 "Ravaging Tempest", Level 38-40 Elite, Forever): spawns 36.7,39.1 / 36.7,39.5 /
  36.8,41.4 / 36.9,37.9 / 37.5,39.1 en 54.0,41.2. Het npc-id komt van warcraft.wiki.gg "Ravaging Tempest" (216474).
- GEMETEN (WH-F tip npc 216474, omgeving `classic`): alleen 53.4-55.8,40.4-43.2 = de oude Season of Discovery-richel.
  De 54.0,41.2 in de Forever-lijst is dus een restant; de vijf nieuwe punten zijn de Forever-plek. (AFGELEID)
- GEMETEN (WH-F tip npc 10756 Scalding Elemental + 10757 Boiling Elemental, volledige lijst uit de cache): de
  stoompoelen liggen op 32.4-40.6, 32.4-39.8. 36.8,39.2 ligt in het zuidelijke deel daarvan; 31.0,45.8 ligt er
  6 punten ten zuiden/westen buiten.
- GEMETEN (lfcarry 16 nov 2026): "the steam pools beneath Darkcloud Pinnacle". Questtekst 79366 (WH-F pagina): "begin
  your cleansing at the steam pools to the west".
- De code zelf verwerpt FQL-coordinaten elders als ze met WH-F botsen (regel 1678, de Summoner).

Reparatie, regel 1689:
```lua
	-- Ravaging Tempest 216474: WH-F 5 spawns 36.7-37.5,37.9-41.4 (centre AFGELEID; a 6th, 54.0,41.2, is the old Season of
	-- Discovery ledge). The steam pools = Scalding/Boiling Elemental 10756/10757, WH-F 32.4-40.6,32.4-39.8; lfcarry
	-- (16 Nov): "beneath Darkcloud Pinnacle". FQL "31.0,45.8" NOT used (conflicts with WH-F).
	steamPools = { m = 1441, x = 36.8, y = 39.2 },
```
TESTLIJST: een shaman kijkt of de blauwe cirkel daar ligt.

## FOUT 2 - Orahil: de tekst zegt niet WANNEER je de steen gebruikt

`enUS.lua:7076` `FCQ_OBJ_WL_ORAHIL_SPIRIT` = "… use the gem from your bags on a felhound (the ruby) or an infernal (the
emerald) for the Imprisoned Spirit". De code zegt op regel 1783 "NOT measured: how the gem is used".

- GEMETEN (WH-F pagina quest 4962 en 4963, Description): "It works very similar to spells you already know: when the
  creature is close to dying, use the gem and it should do the rest of the work for you." en "After you're successful,
  take both the captured spirit and your ruby to Menara."
- GEMETEN (WH-F tip item 12647/12646): "Use: Captures the spirit of a Felhound / an Infernal …".

Reparatie `enUS.lua:7076`:
```lua
	FCQ_OBJ_WL_ORAHIL_SPIRIT = "at Mannoroc Coven, fight a felhound (if you have the ruby) or an infernal (if you have the emerald) and use the gem from your bags when it is almost dead, for the Imprisoned Spirit (keep the gem: Menara wants it back too)",
```
En regel 1783 in de Lua: "NOT measured: how the gem is used …" vervangen door
"The gem: use it when the demon is close to dying (WH-F 4962/4963 description, GEMETEN 18 Nov 2026)."
Let op: de vertalingen van deze sleutel staan al in `Locales/ForeverClassQuests_<taal>.lua` en `nlNL.lua` -> meenemen
+ `check_drift`.

## FOUT 3 - commentaar belooft iets dat de motor niet doet (Windshaper-shaman)

`ForeverClassQuests.lua:1849-1850`: "a Windshaper with one of these quests in the log still gets the route through
MyChains' 'another race's route' rule".

- GEMETEN (code 2320-2346): `out` wordt alleen gevuld vanuit `own`; een vreemde route komt er alleen in als VERVANGER
  van een eigen route met dezelfde `key`. Een Windshaper heeft geen eigen keten met key "tempest" -> de Horde-keten
  verschijnt nooit, ook niet met 79360 in het log.
- Of een Windshaper de keten mag doen: lfcarry (16 nov) zegt ja; QF/FQL (volgens de code) nee; SP geeft alleen een
  factiemasker. NIET beslist.

Reparatie, kies een:
- (a) alleen het commentaar: "…a Windshaper gets nothing here, also with one of these quests in the log (MyChains only
  swaps a foreign route in for an own route with the same key)."
- (b) de belofte waarmaken, in `MyChains` na de `for _, c in ipairs(own)`-lus (na regel 2346):
```lua
	-- A route of another race with a quest done or in your log, for a key you have no own route for (a Windshaper
	-- shaman on The Tempest's Weapons): show it too. CHAINS order, so the result is stable.
	local ownKey = {}
	for _, c in ipairs(own) do
		ownKey[c.key] = true
	end
	for _, c in ipairs(CHAINS[token] or {}) do
		if foreign[c.key] == c and not ownKey[c.key] then
			out[#out + 1] = c
			pos[c] = #out
		end
	end
```
  (raakt ook de troll-warlock bij de WL_ORC-ketens: die krijgt dan de route zodra hij zo'n quest heeft; lijkt gewenst.)

---

## RISICO 1 (middel/hoog) - Orahil: wie eerst de Infernal Orb loot, krijgt de steen-stap nooit te zien

`ForeverClassQuests.lua:1790-1794`. De twee item-stappen (pad kiezen, geest vangen) staan in `objs` van 1799.

- GEMETEN (code 2656): `if e.objs and not ObjDone(q)` - zodra de client 1799 "compleet" noemt, slaat de motor ALLE
  objs over. Het enige echte doel van 1799 is de Infernal Orb (WH-F tip: 1 requirement).
- GEMETEN (WH-F tip item 7291): Infernal Orb, Burning Blade Summoner, 18,55%. De Summoners staan tussen de felhounds en
  infernals (WH-F spawns 50-53,72-84). Loot je de orb voor je een geest hebt, dan zegt MH "ga naar Tabetha" en loop je
  Desolace uit zonder Imprisoned Spirit. Aan het eind biedt Menara 4964/4975 dan niet aan (SP: prev 4962 / 4963) en
  moet je terug naar Desolace. (gevolg AFGELEID)

Reparatie (lost ook de LIMIT uit regel 1781-1782 op): de twee stappen naar `pre`, met een kleine uitbreiding van
`PreStep`.
Regel 1790-1794 wordt:
```lua
		{ q = 1799, from = Q.menara,
			-- `pre`, not `objs`: objs are skipped once the client says 1799 is complete (the Infernal Orb is its only
			-- objective), so a player who loots the orb first would never see the shard steps. unlessDone: the shard
			-- quest is handed in (gem and spirit are gone from your bags then).
			pre = {
				{ items = { 12647, 12646, 12648, 12649 }, place = Q.acolytes, textKey = "FCQ_OBJ_WL_ORAHIL_PATH", unlessDone = { 4962, 4963 } }, -- QF 4962 start 6254 (ruby 12647), 4963 start 6252 (emerald 12646)
				{ items = { 12648, 12649 }, place = Q.mannoroc, textKey = "FCQ_OBJ_WL_ORAHIL_SPIRIT", unlessDone = { 4962, 4963 } }, -- WH-F 4962/4963
			},
			objs = { O(Q.mannoroc, "FCQ_OBJ_WL_INFERNAL_ORB", 1) }, -- WH-F "Infernal Orb"; item 7291 <- Burning Blade Summoner 4668
			to = MA.tabetha }, -- QF start 6266 end 6546; SP ender 6546; FQL (3)
```
`PreStep`, tak `elseif p.items then` (regel 2581-2590), een lus erbij voor de `if not any …`:
```lua
			-- unlessDone = { quest ids }: the items went with one of these quests (handed in), so nothing is missing.
			for _, dq in ipairs(p.unlessDone or {}) do
				if Done(dq) then
					any = true
				end
			end
```
plus een regel in het kopcommentaar van `PreStep` (2550-2557). `/mh classquest` toont pre-stappen niet als "steps";
dat is nu ook al zo bij de Dreadsteed.

## RISICO 2 (laag) - Agamand-rekken: object-id's van bijl en zwaard kloppen niet met Wowhead

`ForeverClassQuests.lua:1667-1668` (commentaar: rackAxe = 105169, rackSword = 105170; overgenomen van ZY H 23608/23614).

- GEMETEN (WH-F tip object): 105169 op 52.6,25.9; 105170 op 51.7,25.7; 105171 op 51.9,27.1; 105172 op 52.6,26.9.
  De code zet "Axe, 105169" op 51.70,25.69 en "Sword, 105170" op 52.65,25.86: precies andersom. Mace (105172) en
  Dagger (105171) kloppen wel.
- NIET te meten: welk rek welk wapen bevat (Wowhead-tab "Contains" is JavaScript; classicdb en de wiki geven het niet).
  Twee mogelijkheden: alleen Zygors id's zijn verwisseld (dan kloppen de coordinaten; past bij het patroon
  105169-105172 = 7566-7569, AFGELEID), of Zygors plekken voor bijl en zwaard zijn verwisseld.
- Gevolg als het fout is: klein. De rekken staan ~40 meter uit elkaar in dezelfde crypte; de speler pakt het zwaard
  waar "bijl" staat en de pijl blijft dan op een leeg rek wijzen.

Reparatie: nu alleen het commentaar eerlijk maken (id's volgens WH-F omdraaien of "id's volgens Zygor, WH-F zegt
andersom"), en op de TESTLIJST: een Undead-warrior kijkt welk wapen uit welk rek komt.

## RISICO 3 (laag) - eerste wapen via de route van een ander ras wordt pas getoond NA het aannemen

- GEMETEN (code 2312-2331, 2360): een vreemde route telt pas als `Active` wanneer een quest ervan klaar is of in het
  log zit. Voorbeeld: Night Elf-warrior die de Human-route deed (1665 klaar). Zijn eigen keten (needs 1683) is nooit
  `Ready`; de Human-keten (needs 1665, wel klaar) wordt pas ingewisseld als hij 1666 zelf al heeft aangenomen. Tot dan:
  niets in "Do this now", en de Class quests-pagina toont "later: Elanaria" (die hem niets aanbiedt). (AFGELEID uit code)
- In de praktijk klein: Harry Burlguard biedt 1666 direct aan bij het inleveren van 1665.

Reparatie (optie), in `Active(c)` van `MyChains` (regel 2312), als eerste regel:
```lua
			if c.needs and Done(c.needs) then
				return true -- its gate quest is done: this is the route you are on (first weapon after another race's stance route)
			end
```

## RISICO 4 (laag) - "eerst Felcloth, dan Felwood" werkt alleen als Inferno al klaar is

- GEMETEN (code 2737-2745 + 405): Inferno is een spell-keten (pas 1), An Imp's Request een item-keten (pas 2), beide
  level 50. "Do this now" stuurt een level-50 warlock dus eerst naar Niby/Impsy in Felwood voor Inferno, zonder de
  Felcloth-regel (commentaar 1810-1811 belooft het omgekeerde). Impsy biedt daar 8420 Hot and Itchy aan.
- Niet erg: Felcloth komt van satyrs in Felwood zelf (questtekst 8419 volgens warcraft.wiki.gg; Classic-data).
Reparatie: geen code nodig; hooguit het commentaar 1810-1811 aanvullen ("only when Inferno is done or on the Class
quests page"). Echte oplossing zou een waarschuwing bij Inferno's eerste stap zijn (keuze bouwchat).

## RISICO 5 (laag) - Twisted Fire Totem: de pijl wijst naar het zwaardere kamp

`ForeverClassQuests.lua:1687` totemFire = Badlands 26.2,58.5.
- GEMETEN (WH-F tip): daar staan Dustbelcher Ogre 38-39 en Brute 39-40. Dustbelcher Warrior 2906 (35-37) en Mystic 2907
  (36-37) staan op 63.4-66.6, 22.0-25.6 (en Mystic ook 48.8-50.6,73.5-73.9).
- conquestcapped (19 okt 2026) noemt "Dustbelcher Brute, Ogre, Warrior, and other ogres" als bron (1 gids).
- De tekst "level 35-42" klopt met die lijst (Warrior 35 … Mauler/Murdaloc 42). GEMETEN.
Optie: `totemFire = { m = 1418, x = 65.0, y = 23.8 }` (midden AFGELEID) als het lichtere kamp de voorkeur heeft. Dat
Warriors/Mystics de totem droppen rust op 1 gids: eerst in het spel zien.

## RISICO 6 - Horde-route Tempest: mijn lezing van de questteksten steunt de gebouwde route (blijft TESTLIJST)

WH-F pagina's, 18 nov 2026 (GEMETEN = de tekst; wie hem zegt = AFGELEID):
- 79360 progress: "Danger? There's been no reports of anything like that. And our wind riders are far too busy …" ->
  inleveren bij Rau (Freewind Post), niet bij Bath'rah. Steunt `to = Q.rau`.
- 79364 description: "The note you found says … Return to your allies …", doel "Speak with Prate Cloudseer" -> van Rau
  naar Prate. Klopt met de code.
- 79361 doel: "… for Prate Cloudseer in Thousand Needles"; description "Take this tome". Klopt. LET OP: progress en
  completion op dezelfde pagina zijn in troll-dialect ("We be cookin' now") = oude Season of Discovery-tekst van
  Bath'rah. De pagina spreekt zichzelf dus tegen; het doel is de Forever-tekst. (AFGELEID)
- 79366 description: "… then report back to Rau Cliffrunner with your success. You should begin your cleansing at the
  steam pools to the west." -> gever is niet Rau, inleveren bij Rau. Klopt met `from = S.prate, to = Q.rau`.
- 79442 description: "Our people cannot thank you enough … an old shaman in the Alterac mountains" -> van Rau naar
  Bath'rah. Klopt. Beloning (WH-F pagina): kies Lightning's Grasp / Tidebringer's Claw / Rage of the Storm, plus
  Elementalist's Guard en Rune of the Storm. Klopt met het commentaar.
- 79365 With Wind Beneath Your Wings: description is Bath'rah (troll-dialect, Squall-breakers Potion 212982, NIET in
  ItemSparse 70959) -> Rau. Staat niet in de WH-F Series. Weglaten is verdedigbaar.
- lfcarry (16 nov) zegt nog steeds "79360 inleveren bij Bath'rah"; expcarry (14 okt) noemt Rau en Bath'rah allebei.
Geen reparatie; de TESTLIJST-regel in het commentaar (1847) blijft nodig.

## Kleine tekstpunten (RISICO laag, wel "wat moet je precies doen")

1. `enUS.lua:7064` FCQ_OBJ_WR_ELUNITE_ORE: de kratten liggen op de zeebodem. GEMETEN (WH-F pagina 1686): "a ship crashed
   upon the rocks near the Auberdine lighthouse, scattering many crates of elunite ore along the ocean floor".
   Voorstel: `"open Crates of Elunite on the sea floor off the coast (dive down) for 8 Elunite Ore"`. Het commentaar op
   regel 1724 ("under water = AFGELEID") kan dan "GEMETEN, quest text" worden.
2. `enUS.lua:7078` FCQ_OBJ_WL_ORB_DEMON: GEMETEN (WH-F pagina 4961): "You must kill the demon once I release it. And
   you'll have to be quick. If you take too long then he'll return to the orb and we'll have to start over!"
   Voorstel: `"defeat the Demon of the Orb that Tabetha releases, and be quick: if it takes too long it goes back into the orb and you start over (a level 40 elite: bring help)"`.
3. `enUS.lua:7089` FCQ_OBJ_SH_TEMPEST_RITUAL: GEMETEN (WH-F tip item 268582): Corrupted Totems, icoon `inv_misc_bag_10`
   (een zak), "Use: Begins the final ritual summoning. (10 Min Cooldown)"; conquestcapped (19 okt): "Stand on the rune
   circle by the steam pools and use Corrupted Totems from your bags." "Click the bag" en "use the Corrupted Totems" zijn
   dus waarschijnlijk hetzelfde ding (AFGELEID). Voorstel voor het middenstuk:
   `"… stand on the small blue circle and use the Corrupted Totems from your bags (the item looks like a bag); …"`.
4. Verouderde kopcommentaren in de Lua: regel 242 ("Not built: An Imp's Request"), 498 ("Not built yet: the level 10
   weapon …"), 910-911 ("Not built: The Tempest's Weapons"). Nu wel gebouwd.
5. Commentaar regel 1836 "quest level 38 (totems)": de WH-F pagina's 79358 en 79361 linken de XP-rekenaar op level 43,
   de tooltip toont geen level. Niet zichtbaar voor spelers; alleen het commentaar is onzeker.

---

## Wat klopt (nagemeten, geen actie)

Quest-id's, namen, doelen, aantallen en doel-volgorde (GEMETEN, WH-F tip 18 nov):
- 1667 Badge (1e regel) + Key; 1681 Umbral Ore; 1686 Elunite Ore x 8, Elura's Medallion; 1503 Forged Steel Bars;
  1821 Axe, Dagger, Mace, Sword (= idx 1-4 in de code); 1740 Fragment x 3, Large Fragment; 1799 Infernal Orb;
  4961 Demon of the Orb; 4962/4963 Imprisoned Spirit; 4964/4975 "Wait for Menara …"; 8419/8420 Felcloth;
  8421 Rotting Wood x 10, Bloodvenom Essence x 4; 8422 Amber/Blue/Green x 2; 96264/79360 Tattered Note;
  79358/79361 Water, Earth, Fire, Air x 5 (= idx 1-4); 96135/79366 Eye of the Tempest.
  Dat de tooltip-volgorde de client-index is, blijft AFGELEID (staat ook zo in de file).
- Voorgangers en inleveraars (GEMETEN SP Compendium): 1666 prev 1665 ender 294; 1667 prev 1666; 1680 prev 1678 ender
  6031; 1681 prev 1680; 1682 prev 1681; 1686 prev 1683; 1692 prev 1686 ender 6142; 1693 prev 1692; 1502 prev 1498 ender
  5878; 1503 prev 1502; 1820 prev 1819 ender 1500; 1821 prev 1820; 1822 prev 1821; 1799 prev 4965 ender 6546; 4961 prev
  1799; 4976 prev 4961 ender 6266; 4962/4963 ender 6266 (Menara); 4964 prev 4962; 4975 prev 4963; 8419 ender 14470; 8421
  prev 8419; 8422 prev 8421; 79366 prev 79361; 79442 prev 79366. De WH-F Series bevestigt de warrior-volgordes en de
  Tempest-volgorde (Alliance: Call of Air -> Elemental Aid -> Storm, Earth, and Fire -> Heed My Call -> The Tempest's
  Weapons; Horde met Eyes on the Sky ertussen).
- Orahil-gevers (GEMETEN warcraft.wiki.gg, Classic-data): 4965 Briarthorn/Ironforge, 4968 Demisette Cloyce/Stormwind,
  4967 Zevrost/Orgrimmar, 4969 Kaal Soulreaper/Undercity. SP-maskers: 4965+4968 Alliance, 4967+4969 Horde.
- Factie/ras (GEMETEN DB2 CharBaseInfo 70959): warlock = Human, Gnome, Orc, Undead, Troll (geen Skyborne) -> de maskers
  HUM/GNO/ORCTROLL/UD dekken alles. Shaman = Orc, Tauren, Troll, Dwarf, Windshaper. Warrior = alle 8 + beide Skyborne.
  SP-maskers warrior-quests = hele factie incl. Skyborne.
- Alliance Tempest-gevers (GEMETEN WH-F pagina, dwergen-dialect + doeltekst): 96264, 79358, 96135 Veyric -> Veyric;
  96016 Veyric -> Bath'rah.
- Items (GEMETEN DB2 ItemSparse/Item 70959): alle 31 quest-items en 30 beloningen (6 warlock, 4 shaman, 20 warrior) bestaan met de id's uit de code;
  warrior-wapens item level 15, geen levelvereiste; Rage of the Storm = two-handed mace, de twee Claws = fist, Guard =
  shield. 20536/20534/20530 ontbreken in ItemSparse (positieve controle in dezelfde run) maar hebben een WH-F tooltip
  (Soul Harvester staff 52, Abyss Shard trinket, Robes of Servitude). Dar'Orahil = Shadow, Noh'Orahil = Fire (WH-F tip).
  Dead-tooth's Key: "Use: Opens Dead-tooth's Strongbox", drop van Dead-Tooth Jack (WH-F tip) -> de afleiding in het
  commentaar 1707-1709 is nu GEMETEN.
- Plekken (GEMETEN WH-F tip spawns; kaart-id's GEMETEN DB2 UiMap 70959): alle WQ_P-plekken behalve steamPools vallen in
  de Wowhead-spawns; Haggard, Mathiel en Rau ook in Zygor Forever (84.61,69.38 / 59.48,45.38 / 46.14,51.72).
- Levels in de teksten (GEMETEN WH-F tip): Mirefin 35-38, Lost Ones 34-39, Maraudine 37-40, Dustbelcher 35-42,
  Demon of the Orb 40 elite, Dead-Tooth Jack en Shade of Elura 11 normaal, Charlga 33 elite.
- NPC_NAMES, de 8 rijen (5878, 294, 6031, 6142, 1500, 6247, 6266, 4722) x deDE/frFR/esES/esMX/ptBR/ruRU: alle 48 namen
  GEMETEN gelijk aan WH-F per taal (controle npc 233 vertaald in elke run). Spoken is het eens waar het de naam heeft.
  4722 ptBR "Rau Corta Montes" = alleen Wowhead (Spoken ptBR heeft hem niet), zoals het commentaar al zegt.
- enUS: 30 sleutels op 7060-7089, elke textKey uit het blok bestaat.

## Niet gemeten (zeg ik liever dan weglaten)

- Start-NPC per quest uit Wowheads Quick Facts, en vereist level per quest (JavaScript; alleen via QF/SP/wiki/tekst).
- Of 1799 de verwijs-quest nodig heeft; of 79365 in Forever nog wordt aangeboden; of een Windshaper de Tempest-keten mag.
- Welk Agamand-rek welk wapen bevat. Of de sleutel van Dead-tooth een eigen client-doel is (maakt voor de code niet uit).
- Alles in het spel zelf.
