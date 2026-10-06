# Craftshop: waar haal je een recept? (6 okt 2026)

Onderzoek voor de knop "wijs de weg" bij een niet-geleerd recept in `/mh craftshop`.
Alleen onderzoek. Er is geen code of locale veranderd.

Data per recept: `data/craftshop_recipe_places.tsv` (391 regels).

⚠️ Het eerdere rapport `docs/CRAFTSHOP_RESEARCH_2026-10-06.md` heb ik **niet** gelezen. Mijn opdracht
verbood me om iets in `docs/` te lezen. Punt 4 en 5 daarvan heb ik dus niet vergeleken.

## Het korte antwoord

- Het meeste werk is **al gedaan**. Elk recept met een vaste plek heeft nu een coördinaat.
- Er zijn maar **39 plekken**: 23 handelaren, 3 questgevers, 9 dungeons en 4 raids.
- **32 van de 39** komen uit Blizzards eigen speldata. De andere 7 komen uit Zygor en Wowhead,
  en die twee bronnen zijn het met elkaar eens.
- MH kent er nu al **17** (5 handelaren en 12 ingangen).
- Nog te doen: de tabel in Lua zetten, één knop bouwen, en ongeveer **11 plekken** in het spel nalopen.
- Bij ongeveer 60 recepten bestaat geen vaste plek, bijvoorbeeld "elke delve-kist" of "schatten in een
  zone". Daar kan geen pijl naartoe. Daar blijft de tekst staan.

## Bronnen

| bron | wat | datum / build | hoe sterk |
|---|---|---|---|
| wago.tools DB2 `SourceInfo` | precies de tekst van `GetRecipeSourceText` | build **12.1.0.69933** (live, 22 sep 2026), gelezen op 6 okt | GEMETEN |
| wago.tools DB2 `SkillLineAbility`, `SkillLine`, `SpellName` | welke recepten bij Midnight horen | zelfde build | GEMETEN |
| wago.tools DB2 `CollectableSourceVendorSparse` + `UiMapAssignment` | plek van handelaren (wereldcoördinaat, omgerekend naar kaart) | zelfde build | GEMETEN-DB2 (zie onder) |
| wago.tools DB2 `AreaPOI` | ingangen van dungeons en raids | zelfde build | GEMETEN-DB2 |
| wago.tools DB2 `ItemSparse`, `SpellReagents`, `ModifiedCraftingSpellSlot` e.a. | reagent-ID's en hun beschrijving | zelfde build | GEMETEN |
| Zygor `Data-Retail/NPCData.lua` | NPC-plekken | bestand van 15 jul 2026 | KANDIDAAT |
| Zygor `Guides-Retail/...MID.lua` | questgevers, Jennara | 3 en 23 sep 2026 | KANDIDAAT |
| HandyNotes_MapNotes | renown-quartermasters | 29 sep 2026 | KANDIDAAT |
| Wowhead (npc- en itempagina's) | NPC-plekken en itembronnen | gelezen op 6 okt 2026 | KANDIDAAT |
| MH zelf | `DelveTipMarkup.lua` `ns.VENDOR_WAYPOINTS`, `DungeonRosterData.lua`, `RaidCoachData.lua`, `ProfessionGuidedData.lua` | huidige werkmap | KANDIDAAT (staat zo in de code) |

**De tabel is de juiste (GEMETEN).** Rob mat met `/mh craftshop probe` 8 voorbeeldteksten. Daarvan heb
ik er 6 woord voor woord teruggevonden in `SourceInfo`, met dezelfde valuta-ID's. Bijvoorbeeld 1237577
*Blessed Pango Charm* "Quest: The Medicine Loa's Shrine, Zone: Zul'Aman" en 1237486 met `currency:3263`.
De andere 2 zijn spec-recepten; die heb ik alleen op soort vergeleken.
De recipeID die de client geeft, is het `SpellID` in DB2.

**Wat "GEMETEN-DB2" betekent.** De coördinaat komt uit Blizzards eigen data. Ik heb die zelf omgerekend
naar kaartcoördinaten. De rekenregel heb ik eerst getest op 6 plekken die we al kenden, en alle 6
klopten tot op 0,05:

| NPC | DB2 omgerekend | al bekend |
|---|---|---|
| Caeris Fairdawn | 2395 43,46 / 47,42 | MH en MapNotes: 43,46 / 47,42 |
| Magovu | 2437 45,95 / 65,92 | MH: 45,95 / 65,92 |
| Melaris | 2393 47,04 / 51,66 | Zygor: 47,04 / 51,66 |
| Naynar | 2413 50,95 / 50,73 | MapNotes: 50,95 / 50,73 (MH: 50,99 / 50,75) |
| Void Researcher Anomander | 2405 52,59 / 72,90 | MH: 52,57 / 72,89 |
| Jan'sari the Watchful | 2512 58,78 / 45,95 | MH: 58,80 / 46,00 |

Toch heeft nog niemand in het spel naast deze plekken gestaan. Daarom heet de status GEMETEN-DB2 en
niet "in-game gemeten".

## Vraag 1: hoeveel recepten, per soort bron (GEMETEN, DB2 12.1.0.69933)

Midnight-recepten zijn de rijen in `SkillLineAbility` met een Midnight-skilllijn (2906-2918).
Dat zijn 1041 rijen. Van die rijen hebben er **882 een `SourceInfo`-rij**. De andere 159 zijn
schijnrecepten zoals "Quality", "Sparks", "Knowledge" en "Skill" (9 per beroep). Daarnaast zitten er de
skilllijn-spreuken zelf bij, Disenchant, en een handvol echte recepten zonder bronrij, zoals Odious Alloy,
Chiseled Amani Tablet en G-00.

### Ambachtsberoepen (de 9 van de craftshop)

| beroep | trainer | Jennara | spec | ontdekking | automatisch | handelaar | quest | dungeon | raid | delve-kist | zone-schatten | overal | Pinnacle-kist | vis-fles/AH | geen tekst | **totaal** |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Alchemy | 5 | | 9 | 15 | 4 | 11 | | | | 2 | 1 | | | | 4 | **51** |
| Blacksmithing | 30 | | 23 | | 2 | 38 | | 2 | 3 | | | 1 | | 2 | 1 | **102** |
| Cooking | 41 | | | | 3 | 3 | 1 | | | | | | | | 2 | **50** |
| Enchanting | 18 | 24 | 13 | | 5 | 23 | | 4 | 1 | 7 | 2 | | 1 | | | **98** |
| Engineering | 26 | | 22 | | 35 | 22 | | | | | | 1 | | 3 | | **109** |
| Inscription | 18 | | 24 | 10 | 3 | 33 | | | | | | | 1 | 1 | 1 | **91** |
| Jewelcrafting | 34 | | 18 | | 3 | 18 | | 2 | 1 | 2 | 1 | 6 | | | | **85** |
| Leatherworking | 30 | | 18 | | 3 | 40 | 1 | 5 | 2 | 4 | 2 | | | 1 | | **106** |
| Tailoring | 27 | | 17 | | 3 | 25 | 1 | 3 | 1 | 2 | 1 | | 1 | 1 | 4 | **86** |
| **samen** | **229** | **24** | **144** | **25** | **61** | **213** | **3** | **16** | **8** | **17** | **7** | **8** | **3** | **8** | **12** | **778** |

Wat de soorten betekenen:
- **trainer**: "Profession Trainer: Midnight X (skill)". De tekst noemt geen NPC. MH gebruikt daarvoor
  zijn eigen trainer-pins.
- **Jennara**: de 24 *Gleeful Glamour*-recepten van Enchanting. Die leer je bij **Jennara Sunglow**, niet
  bij Dolothos. De tekst zegt zelf "Trainer: Jennara Sunglow, Zone: Silvermoon City".
- **spec**: "Specialization: <boom> - <knoop>". Dit is een kennisboom en geen plek.
- **automatisch**: "Profession: X (skill)" en Engineering "Recycling". Die krijg je vanzelf.
- **dungeon**: een baas, de *Challenger's Cache* of de *Chest of Proven Valor* in een dungeon. De plek
  is de **ingang**. *Altar of Fangs* (1 recept, "Treasure: Altar of Fangs") hoort hier ook bij, maar dat is
  AFGELEID uit de naam.
- **raid**: een baas in een raid. Of het een raid of een dungeon is, staat in DB2 `Map.InstanceType`
  (2 = raid). GEMETEN voor The Voidspire, The Dreamrift, March on Quel'Danas en The Venomous Abyss.
- **delve-kist**: "Drop: Heavy Trunk, Zone: Delves". Dat is elke delve, dus geen vaste plek.
- **zone-schatten**: "Eversong / Zul'Aman / Harandar / Voidstorm Treasures" en "Ritual Sites: Treasures".
- **overal**: "World Creatures", "Midnight Dungeons", "World Nodes", en *Challenger's Cache* zonder zone.
- **Pinnacle-kist**: "Victorious Stormarion Pinnacle Cache". Wat dat is, heb ik **niet** uitgezocht.
- **vis-fles/AH**: "Thalassian Recipe in a Bottle", wat de tekst zelf "Purchasable on the Auction House"
  noemt.

### Verzamelberoepen (aparte telling)

| beroep | spec | ontdekking | automatisch | handelaar | geen tekst | totaal |
|---|---|---|---|---|---|---|
| Herbalism | 3 | 34 | | | | 37 |
| Mining | | 25 | 1 | | | 26 |
| Skinning | 9 | | | | | 9 |
| Fishing | | 20 | 9 | 2 (Jan'sari, Sluggs) | 1 | 32 |

Samen met de ambachten is dat 778 + 104 = **882**. Dat klopt met het aantal `SourceInfo`-rijen.

### Unieke plekken (voor de soorten die géén trainer zijn)

| soort | recepten | unieke plekken |
|---|---|---|
| handelaar | 213 (+2 bij Fishing) | **23 NPC's** (plus "World Vendors", wat geen plek is) |
| quest | 3 | **3 questgevers** |
| dungeon | 16 | **9 ingangen** |
| raid | 8 | **4 ingangen** |
| **samen** | 242 | **39** |

Er zijn ook nog 2 trainers met een eigen plek: **Jennara Sunglow** (24 recepten) en de Cooking-trainer
(41 recepten, zie Bijvangst).

**82 recepten worden door twee handelaren verkocht** (GEMETEN). Telkens is één van de twee **Lyrendal**.
Wowhead noemt hem *Artisan's Consortium Quartermaster*. De andere is de beroepshandelaar naast de trainer:
Deynna, Eriden, Lelorian, Gelanthis, Melaris, Lyna, Zaralda of Yatheon. Er gaat dus een keuze nodig zijn
over waar de pijl naartoe wijst. Zie de werk-inschatting.

## Vraag 2: welke plekken hebben al een coördinaat?

| soort | plekken | Blizzard DB2 | Zygor | HandyNotes | MH nu | Wowhead | **zonder coördinaat** |
|---|---|---|---|---|---|---|---|
| handelaar | 23 | **19** | 19 in NPCData (+3 als praat-regel in een gids, niet uitgelezen) | 6 (MapNotes, renown-QM's) | 5 | Lyrendal, Mirvedon, Gelanthis gecheckt; **Otoola alleen hier** | **0** |
| questgever | 3 | 0 | 3 | 0 | 0 | 3 | **0** |
| dungeon-ingang | 9 | **9** | (dit is MH's bron, Zygor LibRover; niet zelf nagekeken) | niet nagekeken | **8** (Altar of Fangs ontbreekt) | – | **0** |
| raid-ingang | 4 | **4** | idem | niet nagekeken | **4** | – | **0** |
| **samen** | **39** | **32** | | | **17** | | **0** |

De 19 handelaren met een DB2-plek:

| plek | handelaren |
|---|---|
| Silvermoon (2393) | Deynna, Eriden, Lelorian, Melaris, Lyna, Zaralda, Yatheon, Construct V'anore |
| Eversong (2395), rond 43,5 / 47,5 | Caeris Fairdawn, Armorer Goldcrest, Apprentice Diell, Neriv, Ranger Allorn |
| elk één | Magovu (2437), Naynar (2413), Anomander (2405), Jan'sari (2512), Second Mate Sluggs (2512), Skull of Er'inye (2509) |

Zygor NPCData en DB2 zijn het voor deze handelaren op 0,01 na eens. Daarom vertrouw ik Zygors waarden
voor Lyrendal (44,96 / 55,40), Mirvedon (34,01 / 81,25) en Gelanthis (48,01 / 55,03) ook. Wowhead geeft
45,0/55,4, 34,0/81,2 en 48,0/55,0. Ze blijven wel KANDIDAAT.

**HandyNotes helpt niet voor recepten** (GEMETEN). In de zone-bestanden van `HandyNotes_Midnight` staat
**0 keer** `Recipe(`. Als controle vond diezelfde zoekopdracht in `HandyNotes_WorldOfWarcraft/zul_gurub.lua`
er 53.

### Ingangen: DB2 tegenover MH (GEMETEN)

| ingang | DB2 `AreaPOI` | MH nu | verschil |
|---|---|---|---|
| Murder Row | 2393 57,22 / 61,05 | 57,20 / 61,06 | klein |
| Windrunner Spire | 2395 35,45 / 78,83 | 35,37 / 78,82 | klein |
| Magisters' Terrace | 2424 63,46 / 15,39 | 63,53 / 15,48 | klein |
| Maisara Caverns | 2437 43,84 / 39,51 | 43,74 / 39,43 | klein |
| Den of Nalorakk | 2437 29,83 / 84,50 | 29,79 / 84,51 | klein |
| The Blinding Vale | 2413 26,47 / 78,05 | 26,24 / 78,09 | klein |
| Nexus-Point Xenas | 2405 64,98 / 61,78 | 64,93 / 61,78 | klein |
| Voidscar Arena | 2444 53,65 / 33,39 | 53,67 / 33,08 | klein |
| **Altar of Fangs** | 2509 **47,24 / 68,13** | **ontbreekt** | nieuw |
| The Voidspire | 2405 45,24 / 64,83 | 45,21 / 64,79 | klein |
| The Dreamrift | 2413 61,38 / 62,89 | 61,33 / 63,01 | klein |
| March on Quel'Danas | 2424 52,61 / 85,30 | 52,60 / 85,11 | klein |
| **The Venomous Abyss** | 2509 47,23 / **22,86** | 47,25 / **20,51** | **2,35 in y: nalopen** |

## Werk-inschatting: wat ligt klaar, wat moet nog

**Klaar (vandaag gemeten):**
- Een tabel met recipeID → plek: `data/craftshop_recipe_places.tsv`. Er staan 297 handelaar-regels in
  (215 recepten, sommige met 2 handelaren), 3 quests, 24 baas-recepten, 24 Jennara-recepten, en 43
  regels zonder plek met hun brontekst.
- Alle 39 plekken hebben een coördinaat. 32 komen uit DB2, 7 uit Zygor en/of Wowhead.
- MH heeft de bouwstenen al:
  - klikbare weg-links (`ns:GetWayLinkMarkup`, `mhway` in `DelveTipMarkup.lua`);
  - de route naar een ingang (`ns.RouteDungeonEntrance`);
  - `ns.VENDOR_WAYPOINTS`;
  - de melding "je staat op een andere kaart" na een klik.
- Dit is AFGELEID uit het lezen van de code, niet getest.

**Nog te doen (bouwen), AFGELEID:**
1. Zet de TSV om in een Lua-tabel. Dat is mechanisch werk: ongeveer 41 plekken plus ongeveer 300
   koppelingen van recipeID naar plek. Gebruik **recipeID** als sleutel en niet de NPC-naam uit de tekst.
   De tekst van `GetRecipeSourceText` is vermoedelijk vertaald op een Duitse of Franse client (AFGELEID,
   niet gemeten), en dan vindt een naam-zoektocht niets.
2. Eén knop of klikbare regel onder de rode regel "nog niet geleerd".
3. Bij twee handelaren kiezen. Mijn voorstel is de beroepshandelaar naast de trainer en niet Lyrendal,
   maar **Rob kiest**. Of Lyrendal een renown-eis heeft, heb ik niet gemeten.
4. Voor soorten zonder plek (delve-kist, zone-schatten, overal, Pinnacle, vis-fles, spec, ontdekking) komt
   er geen pijl. De tekst blijft staan. Eventueel: "spec → open je kennisboom".
5. Bij quests een waarschuwing. De quest heeft een voorganger. Zygor zet bij *The Medicine Loa's Shrine*
   "only if haveq(87317) or completedq(87317)". Een pijl naar een questgever die je quest nog niet heeft,
   stuurt je voor niets op pad.

**Nog te doen (meten in het spel), ongeveer 11 plekken:**

| plek | status nu | waar |
|---|---|---|
| Lyrendal | KANDIDAAT | 2393 44,96 / 55,40 |
| Mirvedon | KANDIDAAT | 2393 34,01 / 81,25 |
| Gelanthis | KANDIDAAT | 2393 48,01 / 55,03 |
| Navigator Otoola (npc 253843) | KANDIDAAT, alleen Wowhead | 2512 57,2 / 48,2 |
| Jennara Sunglow (npc 254051) | KANDIDAAT | 2393 39,54 / 51,00, bovenverdieping |
| Cooking-trainer Sylann (npc 257913) | KANDIDAAT | 2393 56,36 / 69,83, binnen |
| Solwin Brightstitch (quest 91389) | KANDIDAAT | 2395 46,93 / 35,58 |
| Kulzi (quest 92531) | KANDIDAAT | 2437 38,78 / 44,85 |
| Ney'leia (quest 90602) | KANDIDAAT | 2413 49,69 / 23,31 |
| Ingang The Venomous Abyss | MH en DB2 verschillen 2,35 | 2509 |
| Ingang Altar of Fangs | nieuw (DB2) | 2509 47,24 / 68,13 |

**Mijn eerlijke inschatting (AFGELEID):** dit is klein werk. Er is één bouwsessie nodig plus één ronde
door Silvermoon en de Coiled Isle met `/mh here`. Het zware deel, uitzoeken waar 242 recepten vandaan
komen, is gedaan. Blizzards eigen tabel bleek het antwoord al te bevatten.

## Vraag 3: reagents zonder uitleg

Bronnen:
- ID's en beschrijving: DB2 `ItemSparse` 12.1.0.69933 (GEMETEN).
- Herkomst: Wowhead, gelezen op 6 okt 2026 (KANDIDAAT), tenzij de DB2-beschrijving het zelf zegt.

| reagent | item-ID's (alle rangen) | waar vandaan | bron |
|---|---|---|---|
| **Mote of Wild Magic** | 236951 (één rang) | Vooral uit **Wild**-ertsaders (Wild Refulgent Copper / Brilliant Silver / Umbral Tin, rond 90%), van de plant-NPC Vengeful Lasher en van de Rumbling Oreling. Zo goed als alles in **Zul'Aman**. Ook via Alchemy *Transmute: Mote of Wild Magic* (recept 1230887, trainer, skill 5). Een klein beetje via villen en vissen. | Wowhead; transmute = DB2 `SourceInfo` |
| **Peerless Plumage** | 238522 (één rang) | **Skinning** van gevederde beesten. Wowhead noemt er 63, bijvoorbeeld Netherscythe (Voidstorm), Lumenfin (Harandar) en hawkstriders (Eversong). | DB2-beschrijving zegt "gathered from feathered creatures with the Skinning skill" (GEMETEN) + Wowhead |
| **Dusk-Shrouded Stone** | 242788 + 242789 (twee rangen) | **Jewelcrafting**: prospecten van erts. | DB2-beschrijving (GEMETEN); Zygor gebruikt dezelfde twee ID's |
| **Cursebound Globe** | 274781 (één rang, nieuw in 12.1) | Uit **Cursed**-kruiden (Cursed Tranquility Bloom rond 93%, ook Azeroot, Argentleaf, Sanguithorn en Mana Lily) en **Cursed**-ertsaders, alleen op **The Coiled Isle**. | Wowhead |
| **Neutralized Venom Clot** | 274777 (één rang, nieuw in 12.1) | **Skinning** op **The Coiled Isle**, bijvoorbeeld Corroded Cliffcharger (684/707) en Siltmouth. | DB2-beschrijving zegt "after neutralizing venom on the Coiled Isle" (GEMETEN) + Wowhead |
| **Stabilized Derivate** | 242651 (één rang) | **Te koop** bij Herbataur <Master Botanist> (npc 224342), Silvermoon 45,2 / 80,4, voor 25 zilver. **Staat niet in `VENDOR`.** | Wowhead (KANDIDAAT: nalopen) |
| **Petrified Root** | 251285 (één Midnight-rang). Let op: 45911 is een **oud Wrath-item** met dezelfde naam. Niet gebruiken. | Uit **delve-kisten**: Mislaid Curiosity, Bountiful Heavy Trunk, Nemesis Strongbox, Sanctified Spoils. Er bestaan ook *Bundle of Petrified Roots* 251286 en *Generous Bundle* 251287; daarvan is de herkomst onbekend. | Wowhead |
| **Wondrous Synergist** | 241283 + 241282 (twee rangen) | **Je maakt hem zelf met Alchemy** (recept 1230856). Dat recept komt uit de spec "Transmutation Authority - Synthesis Synergy". Wowhead zegt ook dat **241282 te koop is bij Herbataur** voor 5g 82s 50c. | DB2 `SourceInfo` + beschrijving "Created by experienced alchemists" (GEMETEN); verkoop = Wowhead |

⚠️ **Herbataur verdient een eigen controle.** Volgens Wowhead verkoopt hij 50 dingen, ook Midnight-kruiden
(één rang van elk), Nocturnal Lotus, Composite Flora, drankjes en Oil of Heartwood. Dat zou veel uitmaken
voor de "koop"-regels. Ik heb het alleen op Wowhead gezien (KANDIDAAT). Rob moet het in het spel bekijken
voordat er iets in `VENDOR` komt.

### Veelgebruikte Midnight-reagents die in geen van onze lijsten staan

Telling: in hoeveel Midnight-ambachtsrecepten het item een **basis**-reagent is.
Dat komt uit DB2 `SpellReagents` voor reagents met één rang, en uit `ModifiedCraftingSpellSlot` +
`MCRSlotXMCRCategory` + `CraftingReagentQuality` voor reagents met rangen (GEMETEN).
De bron in de laatste kolom komt uit de DB2-beschrijving (GEMETEN), tenzij er "Wowhead" staat.

| ID('s) | naam | recepten | soort | bron |
|---|---|---|---|---|
| 251283 | Tormented Tantalum | 98 | **onbekend** | De DB2-beschrijving noemt geen bron. Wowhead linkt alleen een "Prey Guide". Uitzoeken. |
| 236951 | Mote of Wild Magic | 88 | farm (Wild-knopen, Zul'Aman) | zie boven |
| 256963 | Thalassian Lumber | 80 | farm (houtobjecten in alle zones) | DB2-beschrijving + Wowhead |
| 236950 | Mote of Primal Energy | 77 | farm (**Primal**-kruiden en -erts, vooral Harandar) | Wowhead |
| 236949 | Mote of Light | 69 | farm (**Lightfused**-kruiden en -erts) | Wowhead |
| 251285 | Petrified Root | 66 | delve-kisten | Wowhead |
| 237366 | Dazzling Thorium | 48 | Mining, zeldzaam uit gewone aders (1-2%) | DB2-beschrijving + Wowhead |
| 236952 | Mote of Pure Void | 45 | farm (**Voidbound**-kruiden en -erts, Voidstorm) | Wowhead |
| 245345 | Fused Vitality | 36 | valuta-handelaar Chel the Chip / Abyss Angler | DB2-beschrijving. MH liet hem bewust weg ("kost valuta"). |
| 243599/243600, 243602/243603, 243605/243606 | Eversinging Dust, Radiant Shard, Dawn Crystal | 96, 87, 50 | disenchanten (Enchanting) | DB2-beschrijving |
| 238518/238519, 238520/238521 | Void-Tempered Hide, Void-Tempered Plating | 20, 14 | Skinning | DB2-beschrijving |
| 238528, 238530, 238529 | Majestic Claw, Fin, Hide | 24, 14, 13 | Skinning van Renowned Beasts | DB2-beschrijving |
| 238525, 238523 | Fantastic Fur, Carving Canine | 18, 16 | Skinning (soortspecifiek) | DB2-beschrijving |
| 274777, 274781 | Neutralized Venom Clot, Cursebound Globe | 19, 13 | Coiled Isle (zie boven) | |
| 242651 | Stabilized Derivate | 12 | handelaar Herbataur? | Wowhead, nalopen |
| 237015/237016, 237018/237017, 236963/236965 | Sunfire Silk, Arcanoweave, Bright Linen | 10, 10, 1 | stof van humanoïden | DB2-beschrijving |
| 242788/242789, 242787/242786 + edelstenen | Dusk-Shrouded Stone, Crystalline Glass, gems | 42, 6, … | prospecten (JC) | DB2-beschrijving |
| 242640, 242639 | Plant Protein, Practically Pork | 13, 10 | drop van beesten | DB2-beschrijving + Wowhead |
| 253403 | Thalassian Fillet | 16 | gemaakt met Cooking | DB2-beschrijving |
| div. vis (238383 Eversong Trout, 274589 Ula'tek Snakehead, …) | | 1-4 | vissen | DB2-beschrijving |

Tussenproducten zoals Evercore (101), Sin'dorei Armor Banding (61) en Sterling Alloy (56) heb ik weggelaten.
Die dekt MH al via "dit maak je zelf", maar alleen als je het recept kent.

## Bijvangst (los van de vragen, maar raakt de pijl)

1. **Cooking heeft geen trainer-pin in MH** (GEMETEN). `ProfessionGuidedData.lua` `ns.PROF_GUIDES` heeft
   11 beroepen en geen 185 (Cooking). Ook `ResetRoutine.lua` `TRAINER_PINS` mist hem. Toch zijn er 41
   Cooking-trainerrecepten. Zygor zet de Midnight-Cooking-trainer **Sylann** (npc 257913) op 2393
   56,36 / 69,83, "inside the building" (KANDIDAAT). Dat is dicht bij MH's pin "Inn & Cooking"
   (56,28 / 70,33).
2. **De 24 Gleeful Glamour-recepten van Enchanting leer je niet bij Dolothos** (GEMETEN, DB2-tekst).
   Een trainer-pijl via `PROF_GUIDES[333]` wijst dus naar de verkeerde NPC. MH's eigen
   `PROFGUIDE_LVL_ENCHANTING` noemt Jennara al op "39.5, 51.0, top floor".
3. Het eerdere `/mh craftshop probe` mat 504 Leatherworking-recepten, waarvan 417 niet geleerd. Dat zijn
   alle uitbreidingen samen. Midnight-Leatherworking heeft in DB2 115 rijen (GEMETEN), en daarvan zijn er
   106 met een bron.

## Wat ik niet gemeten heb

- Niets in het spel. Elke coördinaat is "nog niet in-game nagelopen".
- Of `GetRecipeSourceText` op een Duitse of Franse client vertaald is (AFGELEID: waarschijnlijk wel).
- Of Lyrendal, Mirvedon (PvP-hoek, "Competitor's Recipes") of Herbataur iets vragen, zoals renown of honor.
  De DB2-teksten noemen wel valuta-ID's. `currency:1792` komt 67 keer voor, net zo vaak als er
  Mirvedon-recepten zijn. Dat heb ik niet regel voor regel gecontroleerd, en welke valuta 1792 is, heb ik
  niet opgezocht.
- Wat de "Victorious Stormarion Pinnacle Cache" is.
- Waar Tormented Tantalum vandaan komt.
- HandyNotes_MapNotes_Instances (ingangen) heb ik niet doorzocht.
