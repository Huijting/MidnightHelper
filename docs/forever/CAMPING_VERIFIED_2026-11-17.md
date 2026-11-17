# Camping in WoW Forever — controle van het onderzoek, 17 nov 2026

Controle door mh-research (alleen gelezen) van `CAMPING_RESEARCH_2026-11-17.md`. Elke bewering met een ID of getal is
tegen Blizzards eigen tabellen gelegd. De voordeur (`_probe.py`) is NIET gebruikt. Verder is niets onder `docs/` gelezen.

**Legenda:** ✅ klopt · ❌ fout of onvolledig → juiste waarde · ❓ niet te meten. **G** = GEMETEN, **A** = AFGELEID.

**Bronnen (alle gelezen op 17 nov 2026):**
- **[DB2]** lokale cache `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\` — Blizzards
  clienttabellen, build 1.60.1.70938: SpellName, Spell, SpellEffect, SpellMisc, SpellDuration, SpellCastTimes,
  SpellCooldowns, SpellReagents, SpellTotems, SpellLevels, SkillLine, SkillLineAbility, ItemSparse, ItemEffect,
  ItemXItemEffect, QuestV2, QuestLineXQuest, GlobalStrings, AreaTable, UiMap, Creature (per taal waar aanwezig).
- **[wago]** `wago.tools/db2/SpellRadius/csv` en `.../SpellRange/csv`, build 1.60.1.70938 (zaten niet in de cache).
- **[WH-tip]** `nether.wowhead.com/forever/tooltip/npc/<id>` (naam, zone, spawnpunten).
- **[Spoken]** `_forever_\Interface\AddOns\Spoken_Quests\Data\Compendium.lua` en `QuestText.lua` (kop: gemaakt uit
  Forever 1.60.1.70450). Spoken heeft titels, ketens (`prev`), inlever-NPC (`ender`) en rassen. **Spoken heeft GEEN
  questgever-ID en GEEN coördinaten.**
- **[Zygor]** `_forever_\...\ZygorGuidesViewerForever\Guides-Forever\Leveling\*.lua` — alleen als aanwijzing voor zone,
  NPC en coördinaat; waar het kon tegen [WH-tip] gelegd.

**Voorbehoud bij vlaggen en effectnummers.** De getallen (bits, effect-ID's) zijn G. De NAAM van een bit ("alleen
buiten", "niet in combat") komt uit de bekende openbare attributenlijst en is A. Eén ijkpunt is G: Extra Strength 1230172
heeft `Attributes_0 = 128` en Wowhead noemt die "Aura is hidden" (eerder onderzoek).

---

## 0. Uitkomst in het kort

**70 beweringen: 57 ✅ · 3 ❌ · 10 ❓.** Alle gaten uit hoofdstuk 6 die DB2 kan vullen, zijn gevuld.

De drie fouten:
1. **"The Great Outdoors" is onvolledig.** Het onderzoek noemt 5 startzones; het zijn er **7**. Er ontbreken
   **Dun Morogh 96608** en **Teldrassil 96606**. De 5 genoemde ID's kloppen.
2. **Het vuur maak je niet direct.** Het recept maakt een ITEM, **Basic Campfire Kit (279981)**; dat item gebruik je om
   het vuur te bouwen (spell 1307227). De stappen in het bouwvoorstel missen dus één stap. Dit geldt voor alle
   kampobjecten: recept → item → item gebruiken. (G in DB2; in het spel nameten.)
3. **"35 yd = bereik van het object-effect" klopt niet als uitleg.** Het getal 35 klopt, maar het zit op de
   PLAATS-spells (zoeken rond de plek waar je neerzet; A: "Requires a Campfire nearby"). Camp Benefits zelf zoekt
   objecten binnen **20 yd**.

Belangrijkste nieuwe feiten: plaatsen en maken kost **10 s cast**; het vuur staat zelf ook **15 min**; een nieuw vuur
mag niet binnen **100 yd** van een bestaand vuur; **elk soort object maar één keer per kamp**; de tent heeft een eigen
timer van **30 s**; Expert Campfire vraagt **Cooking 220**.

---

## 1. Controle per bewering — hoofdstuk 1 (Systeem)

| # | Bewering | Oordeel | Waarde en bron |
|---|---|---|---|
| A1 | Het is WoW Forever | ✅ G | Alle ID's bestaan in build 1.60.1.70938 [DB2] |
| A2 | Quests heten "Camping 101: <beroep>" | ✅ G | 85 quests met die titel in [Spoken] Compendium r.4562-4729 en 4764-4766 (regelnummers iets anders dan het onderzoek). Alle ID's staan in QuestV2 [DB2]; QuestV2 heeft er 86 (97930 ontbreekt in Spoken) |
| A3 | Geen eigen beroep | ✅ G | Geen SkillLine "Camping" (zelfde zoekopdracht vond 13 andere beroepen); recepten hangen in SkillLineAbility onder de bestaande beroepen. "Kost geen beroepsplek" = A |
| A4 | The Great Outdoors: Elwynn 95998, Zephras 96101, Durotar 96604, Mulgore 96605, Tirisfal 96607 | ❌ onvolledig | Die 5 kloppen. Er zijn er **7**: ook **Dun Morogh 96608** en **Teldrassil 96606** ([Spoken] r.4593, 4595; QuestV2; zone via [Zygor] + [WH-tip]). Zie hoofdstuk 6 |
| A5 | Opdracht: /sit bij het vuur → "Boosted Rest" | ✅ G ([Zygor]) | Zygor-doelen: "Use the /sit Emote Near the Campfire" en "Gain the Boosted Rest Buff". Boosted Rest = 1229451 [DB2] |
| A6 | Dat duurt ~1 min | ❓ | Zygor-tip zegt 1 minuut. [DB2]: tent-timer 1229487 = 30 s, vuur-timer 1229739 = 60 s. Welke de quest gebruikt: niet gemeten |
| A7 | Camping 101: Cooking 96626 = Elwynn | ✅ G | [Spoken] ender 1430; [Zygor]: Tomas, Goldshire |
| A8 | Skinning 96056 / 97924, Mining 96046 | ✅ G | Bestaan in [Spoken] en QuestV2. 96056 = Dun Morogh, 97924 = Elwynn ([Zygor]) |
| A9 | Ontgrendelen rond level 4-6 | ❓ | Niet in DB2. Spells en items hebben GEEN level-eis (SpellLevels 0, RequiredLevel 0) |
| A10 | Basic Campfire vanaf Cooking 1 | ✅ G | SkillLineAbility: SkillLine 185, MinSkillLineRank 1; item 279981 vraagt Cooking 1 |
| A11 | 1 Simple Wood (4470) + Flint and Tinder (4471, gereedschap) | ✅ G | SpellReagents 1229737: 4470 ×1. SpellTotems 1229737: Totem_0 = 4471 (wordt niet verbruikt). Let op fout 2: je maakt een kit |
| A12 | Beide te koop bij de Cooking-trainer | ❓ | Verkoperslijsten staan niet in DB2. MH heeft al verkopers van 4471 in `ForeverVendorSpots.lua` |
| A13 | 3 / 5 / 10 objecten per vuur | ✅ G | SpellEffect basispunten: 1307227 = 3, 1307252 = 5, 1307237 = 10 |
| A14 | Journeyman: blueprint + Star Wood; Expert: blueprint + Thick Logs | ✅ G | Items "Blueprint: Journeyman Campfire" 273087 en "Blueprint: Expert Campfire" 273101. Grondstof 11291 ×1 resp. 272941 ×1; gereedschap 4471 |
| A15 | Journeyman op Cooking 90 | ✅ G | ItemSparse 279961: RequiredSkill 185, rank 90. "Was 140" niet gemeten (oudere build) |
| A16 | Vuur 5 min cooldown | ✅ G | SpellCooldowns categorie 300000 ms; ItemEffect categorie 2511, 300000 ms |
| A17 | Alleen buiten, niet in combat, niet in shapeshift, niet in arena/raid | ✅ G bits, A namen | 1307227/1307237 `Attributes_0 = 0x10018010`, `Attributes_4 = 0x10000`, `Attributes_6 = 0x800`. "Niet in instances" als losse regel: niet gemeten |
| A18 | Niet midden in een stad (Spoken r.17345) | ✅ G | Citaat staat op r.17345 (en r.17341). Het is questtekst, geen spelregel |
| A19 | Vuur doet schade; niet onder level 5 | ❓ | Niet in de gelezen tabellen te vinden |
| A20 | Campfire Nearby 1283391, passief, 100 yd | ✅ G | `Attributes_0 = 0x40`; effect 128 met radius-index 12 = 100 yd [wago] |
| A21 | Welcoming Campfire 1229739 (variant 1289723), 1 min | ✅ G | Beide DurationIndex 3 = 60000 ms; periodiek effect 60000 ms dat 1229741 start |
| A22 | Craften mag, bewegen niet | ✅ G | Tekst 1289723: "You may also craft using tradeskills, as long as you do not move." |
| A23 | Stoel/slapen/liggen/knielen tellen; casten mag | ❓ | Staat niet in DB2 |
| A24 | Camp Benefits 1229741, 1 uur, één regel per object | ✅ G | DurationIndex 42 = 3600000 ms; tekst zie hoofdstuk 4 |
| A25 | Deel-auras verborgen (1230172, 1229513, 1230164, 1229519, 1229718) | ✅ G bit, A naam | Alle NEGEN deel-auras hebben `Attributes_0 = 128`, hetzelfde als 1230172 |
| A26 | Buffs van verschillende objecten tellen op | ✅ G | Camp Benefits-tekst toont per aanwezige deel-aura een eigen regel |
| A27 | Elke kampbuff sluit één class-buff uit | ✅ G | Staat in elke plaats-spell ("mutually exclusive with …") |
| A28 | Permanence: DB2-basis 100 groepsbuff / 50 kamp | ✅ G | Spell 1225502: effect 1 = 100, effect 2 = 50; tekst "…benefits you gain from resting at a camp last $s2% longer" |
| A29 | Pouch of Violet Dust verlengt Camp Benefits | ✅ G bestaan, A "+1 uur" | Item 289439; Violet Flames 1328375: "Campfire effects gained while affected have increased duration", basispunten 100 |
| A30 | Alle objecten delen 1 uur cooldown | ✅ G | Tekst "All camping features share a cooldown of $1308027d"; 1308027 = 3600000 ms; ItemEffect categorie 97, 3600000 ms. "1 object per speler" volgt hieruit (A) |
| A31 | Object gaat op bij neerzetten | ✅ G | ItemEffect Charges = -1 |
| A32 | Verhandelbaar | ✅ G | ItemSparse Bonding = 0; stapelt tot 20 |
| A33 | Neerzetten vraagt het beroep op skillniveau | ✅ G | ItemSparse RequiredSkill + RequiredSkillRank 20 (tier 1) |
| A34 | Object staat 15 min | ✅ G in DB2 | Alle plaats-spells én de drie vuren: DurationIndex 347 = 900000 ms. In het spel niet gemeten |
| A35 | Geen groep nodig | ❓ | Niet in DB2. Tooltips zeggen "you and others sitting nearby" |
| A36 | Faction Banner alleen eigen factie | ✅ G | 1307239 "members of the Alliance", 1307240 "members of the Horde" |

## 2. Controle — hoofdstuk 2 (objecten), 3, 4 en 5

| # | Bewering | Oordeel | Waarde en bron |
|---|---|---|---|
| B1-B11 | De 11 rijen van de objectentabel (effect, botst met, grondstoffen, ID's) | ✅ G (11×) | Alles klopt; de lege vakjes zijn gevuld. Zie de volledige tabel in hoofdstuk 3 |
| B12 | Tier 1 = skill 20 | ✅ G | ItemSparse: alle 11 items RequiredSkillRank 20. De eis om het recept te LEREN staat niet in DB2 |
| B13 | Effect schaalt met character level | ✅ G | Tooltips gebruiken `$PL` (player level) |
| B14 | Recept-spells 1230171, 1230564, 1229517, 1230161 | ✅ G | Kloppen alle vier |
| B15 | Tier 2 = 140 (Tanning Rack 125), tier 3 = 300 | ✅ G | ItemSparse, zie hoofdstuk 6 |
| B16 | Hogere tiers via blueprints | ✅ G | 27 items "Blueprint: …" (273085-273141) |
| B17 | Blueprints komen uit dungeons | ❓ | Drops staan niet in DB2 |
| B18 | Hogere tier vervangt tier 1 en houdt de buff, behalve Anarchist's Workbench | ✅ G | Plaats-teksten. Ook zonder buff: Repair Bot, Cookie's Feast en Iron Oven |
| B19 | Fishing Rack van Gelihast, Tanning Rack van Razorclaw | ❓ | Niet in DB2 |
| C1 | Gedeelde cooldown = spell 1308027, 60 min | ✅ G | Naam "Camping", 3600000 ms |
| C2 | 60 s zitten óf craften, binnen 20 yd | ✅ G getal, A uitleg | Dummy-effect van 1229739/1289723 heeft radius-index 9 = 20 yd |
| C3 | Camp Benefits blijft als je opstaat | ❓ | Niet in DB2 |
| C4 | 12 tier-1-recepten incl. Basic Campfire | ✅ G | 12 beroepen in SkillLineAbility (Tailoring heeft 2 varianten) |
| C5 | 35 yd = bereik object-effect | ❌ uitleg | 35 yd (index 21) zit op de plaats-spells. Camp Benefits 1229741 zoekt binnen 20 yd (index 9) |
| D1-D7 | MH-code: ForeverProfGuide r.16-18, ForeverToolGuard:53 (4471), ForeverVendorSpots (4471), ForeverReagentData (4470), ForeverBuffs (`ns.Aura.HasPlayerAura`, r.105), ForeverItemTips + ForeverDoNow bestaan, ForeverWarnings:211 (secret values) | ✅ G (7×) | Zelf in `Modules/` nagekeken |
| E1 | Stappen "hout + Flint and Tinder → vuur → object" | ❌ stap mist | Recept maakt een kit-item; dat gebruik je. Zie fout 2 |
| E2 | Aura-ID's 1283391, 1229739/1289723, 1229741, 1229451 | ✅ G | Bestaan met die namen |
| E3 | Zijn ze leesbaar in de client (ook in combat)? | ❓ | Alleen in het spel te meten |

---

## 3. Volledige tabel tier 1 (alle gaten gevuld) — G, [DB2]

Keten per object: **recept-spell** (maakt item, 10 s cast) → **item** (vraagt beroep op skill 20) → **plaats-spell**
(item gebruiken, 10 s cast, object staat 900 s) → **deel-aura** binnen Camp Benefits.

| Object | Beroep (SkillLine) | Recept | Item | Plaats-spell | Deel-aura | Grondstoffen | Botst met |
|---|---|---|---|---|---|---|---|
| Camp Chair | Skinning (393) | 1229517 | 279979 | 1307229 | 1229519 Boosted Critical Chance | 3× Light Leather 2318, 2× Simple Wood 4470 | Moonkin Aura |
| Sharpening Wheel | Blacksmithing (164) | 1230171 | 279944 | 1307392 | 1230172 Extra Strength | 1× Rough Stone 2835, 1× Copper Bar 2840 | Strength of Earth Totem |
| Incense Candle | Herbalism (182) | 1229705 | **279962** | 1307251 | 1229513 Boosted Intellect | 1× Peacebloom 2447, 1× Silverleaf 765 | Arcane Intellect |
| Mana Well | Alchemy (171) | 1230564 | 279956 | 1307259 | **1230587 Boosted Mana Regeneration** | 1× Peacebloom 2447, 1× Empty Vial 3371 | Blessing of Wisdom |
| Lodestone | Mining (186) | 1230161 | 279960 | 1307254 | 1230164 Boosted Attack Power | 1× Rough Stone 2835, 1× Copper Bar 2840 | Blessing of Might |
| Fish Bowl | Fishing (356) | **1229745** | **279967** | 1307245 | **1230098 Boosted Stats** | 1× Raw Brilliant Smallfish 6291, 1× Empty Vial 3371 | Blessing of Kings |
| First Aid Kit | First Aid (129) | **1230117** | **279968** | **1307244** | **1230124 Boosted Stamina** | 3× Linen Bandage 1251, 1× Refreshing Spring Water 159 | Power Word: Fortitude |
| Faction Banner (Horde) | Tailoring (197) | 1229504 | **279972** | **1307240** | 1229718 Boosted Spirit | 1× Bolt of Linen Cloth 2996, 1× Coarse Thread 2320 | Divine Spirit |
| Faction Banner (Alliance) | Tailoring (197) | 1263425 | **279973** | **1307239** | 1229718 Boosted Spirit | zelfde | Divine Spirit |
| Enchanted Lute | Enchanting (333) | **1230643** | **279976** | **1307234** | **1230653 Boosted Stats** | 1× Simple Wood 4470, 1× Strange Dust 10940 | Mark of the Wild |
| Camp Tent | Leatherworking (165) | 1229432 | 279978 | 1307230 | timer 1229487 "Camp Tent" (30 s) → 1229451 Boosted Rest (1 uur) | 5× Light Leather 2318 | – |
| Reagent Bot | Engineering (202) | **1230656** | **279950** | **1307266** | geen | 1× Handful of Copper Bolts 4359, 1× Copper Tube 4361 | – |

Welke banner bij welke factie hoort: de plaats-tekst noemt de factie (G); de rasmaskers op item en recept passen erbij (A).

**De drie vuren** (Cooking, SkillLine 185):

| Vuur | Recept | Item (kit) | Skill voor het item | Plaats-spell | Plekken | Grondstof | Gereedschap | Blueprint |
|---|---|---|---|---|---|---|---|---|
| Basic Campfire | 1229737 | 279981 Basic Campfire Kit | Cooking 1 | 1307227 | 3 | 1× Simple Wood 4470 | Flint and Tinder 4471 | – |
| Journeyman Campfire | 1283400 | 279961 Journeyman Campfire Kit | Cooking 90 | 1307252 | 5 | 1× Star Wood 11291 | 4471 | 273087 |
| Expert Campfire | 1291341 | 279974 Expert Campfire Kit | Cooking **220** | 1307237 | 10 | 1× Thick Logs 272941 | 4471 | 273101 |

De oude Classic-spell 818 "Basic Campfire" (direct vuur, 1× Simple Wood) staat ook nog in de data. Of een kok in
Forever die ook krijgt: niet gemeten.

**Leer-spells** (effect "leer spell", G): 1255248 → Camp Tent, 1255249 → Faction Banner (Alliance), 1255250 → Camp
Chair, 1255251 → Incense Candle, 1255254 → Fish Bowl, 1255255 → First Aid Kit, 1255256 → Lodestone, 1255257 →
Sharpening Wheel, 1255259 → Mana Well, 1255260 → Enchanted Lute, 1255261 → Reagent Bot, 1290398 → Faction Banner
(Horde), 1290 → Basic Campfire. Wie ze geeft (trainer of quest): niet in DB2.

## 4. Buffs, timers en afstanden — G, [DB2] + [wago]

| Aura | ID | Duur | Icoon | Wat de data zegt |
|---|---|---|---|---|
| Campfire Nearby | 1283391 | geen (passief) | 7808147 | Gebiedsaura, radius-index 12 = **100 yd**. Tekst: "The pleasant smoke of a campfire drifts in the air from somewhere nearby." |
| Welcoming Campfire | 1229739, variant 1289723 | **60 s** | 135805 | Na 60 s start hij 1229741. Zoek-effect met radius-index 9 = **20 yd** (A: zoekt het vuur/de objecten) |
| Camp Benefits | 1229741 | **3600 s** | 7808144 | Twee zoek-effecten met radius-index 9 = **20 yd** (A: spelers en objecten). Bit 0x80000000 (A: niet weg te klikken). Geen "blijft na dood"-bit (A: weg bij doodgaan) |
| Camp Tent (timer) | 1229487 | **30 s** | 134250 | "Increases Rested Experience after $d spent resting near the tent. You may only gain this benefit once per hour." Radius-index 13 = **10 yd** |
| Boosted Rest | 1229451 | 3600 s | 1001982 | "You cannot gain more rested experience from a Camp Tent for $d." Debuff-bit, blijft na dood (A) |
| Camping | 1308027 | 3600 s | 136090 | De gedeelde cooldown van kampobjecten. Debuff-bit, blijft na dood (A). Of hij als debuff op de speler staat: niet gemeten |

Camp Benefits-tekst (G, letterlijk de regels): Mana Well: "Restores X Mana every 5 seconds." · Sharpening Wheel:
"Strength increased by X." · Enchanted Lute: "Armor increased by X, all attributes increased by X, and all resistances
increased by X." · First Aid Kit: "Stamina increased by X." · Fish Bowl: "All stats increased by X%." · Incense Candle:
"Intellect increased by X." · Lodestone: "Melee Attack Power increased by X." · Camp Chair: "Critical strike chance with
all spells and attacks increased by X%." · Faction Banner: "Spirit increased by X."

Verborgen (alle `Attributes_0 = 128`): de 9 deel-auras, `[DNT] Boosted Rest` 1325299 en `Boosted Spell Power` 1230552
(die laatste komt in de Camp Benefits-tekst niet voor; A: ongebruikt). Verder `Campfire` 1229736: verborgen puls om de
5 s, radius-index 18 = **15 yd**, 900 s.

**Afstanden op een rij** (getallen G; wat ze in het spel doen is A en niet gemeten):

| Getal | Waar het staat |
|---|---|
| 100 yd | Campfire Nearby; en nieuw vuur niet binnen 100 yd van een bestaand vuur (GlobalStrings 57727, G) |
| 35 yd | Plaats-spells van objecten (zoeken rond de plek; A: "campfire nearby") |
| 20 yd | Welcoming Campfire en Camp Benefits (objecten/spelers zoeken) |
| 15 yd | Verborgen puls van het vuur (1229736) |
| 10 yd | Tent-timer (1229487) |
| 2-3 yd | Bereik "Campfire" (SpellRange 566): het vuur komt 2-3 yd voor je |
| 1 yd | Bereik "1 Yard" (SpellRange 517): objecten zet je vlak voor je neer |

Vuistregel voor tekst: "ga dicht bij het vuur zitten". Noem geen getal tot Rob het in het spel gemeten heeft.

## 5. Effect per level — G uit de tooltip-formules [DB2]

Dit zijn de getallen die de TOOLTIP van het object toont op dat level. De deel-aura zelf heeft in DB2 alleen de
level-60-waarde. Dat de echte buff hetzelfde getal geeft is A; de Camp Benefits-buff toont in het spel het echte getal.

| Object | Stat | 10 | 20 | 30 | 40 | 50 | 60 | Grenzen in de formule |
|---|---|---|---|---|---|---|---|---|
| Camp Chair | crit % | 2 | 2 | 2 | 2 | 2 | 2 | vast |
| Fish Bowl | alle stats % | 8 | 8 | 8 | 8 | 8 | 8 | vast |
| Sharpening Wheel | Strength | 6 | 6 | 11 | 20 | 20 | 34 | <24: 6 · <38: 11 · <52: 20 · anders 34 |
| Incense Candle | Intellect | 2 | 6 | 12 | 12 | 18 | 25 | <14: 2 · <28: 6 · <42: 12 · <56: 18 · anders 25 |
| Mana Well | mana per 5 s | 10 | 10 | 15 | 20 | 24 | 29 | <24: 10 · <34: 15 · <44: 20 · <54: 24 · anders 29 |
| Lodestone | melee AP | 12 | 20 | 32 | 49 | 67 | 90 | <12: 12 · <22: 20 · <32: 32 · <42: 49 · <52: 67 · anders 90 |
| First Aid Kit | Stamina | 3 | 8 | 21 | 34 | 45 | 56 | <12: 3 · <24: 8 · <36: 21 · <48: 34 · <60: 45 · anders 56 |
| Faction Banner | Spirit | 14 | 14 | 14 | 19 | 27 | 32 | <40: 14 · <50: 19 · <60: 27 · anders 32 |
| Enchanted Lute | Armor | 71 | 114 | 163 | 211 | 260 | 308 | <10: 28 · <20: 71 · <30: 114 · <40: 163 · <50: 211 · <60: 260 · anders 308 |
| Enchanted Lute | alle stats | 2 | 4 | 7 | 9 | 12 | 13 | vanaf 10: 2 · 20: 4 · 30: 7 · 40: 9 · 50: 12 · 60: 13 (onder 10: niets) |
| Enchanted Lute | alle resistances | – | – | 6 | 12 | 16 | 22 | vanaf 30: 6 · 40: 12 · 50: 16 · 60: 22 (onder 30: niets) |
| Camp Tent | rested XP | tot 5% van een level, op elk level | | | | | | vast; werkt niet als je al meer rested hebt |

Level-60-waarden in SpellEffect (G): Intellect 25, crit 2, Spirit 32, stats 8%, Stamina 56, AP 90, Strength 34,
mana 29 per 5000 ms, Lute 308 armor / 13 stats / 22 op zes resistances.

## 6. Quests — [Spoken] + QuestV2 [DB2] + [WH-tip] + [Zygor]

Keten per startzone: **The Adventurer** (loop naar de avonturier) → **The Great Outdoors** → **Camping 101: Cooking**
en per beroep een **Camping 101: <beroep>**. Volgorde volgens [Spoken] `prev`: 95998 ← 96627, 96608 ← 96628,
96101 ← 96638, 96607 ← 96656; bij 96604, 96605 en 96606 noemt Spoken geen `prev`.

| Startzone (uiMapID) | Avonturier (NPC-ID) | Plek [WH-tip] | Plek [Zygor] | The Adventurer | The Great Outdoors | Camping 101: Cooking (inlever-NPC) |
|---|---|---|---|---|---|---|
| Elwynn Forest (1429) | Sam Sarsaparilla (263399) | 44.8, 63.2 | 44.91, 63.34 | 96627 | **95998** | 96626 (1430) |
| Dun Morogh (1426) | Eric Brighthammer (265813) | 46.6, 53.8 | 46.71, 53.95 | 96628 | **96608** | 96629 (1699) |
| Teldrassil (1438) | Lyreena Duskblade (265811) | 57.4-57.6, 56.6 | 57.57, 56.64 | 96630 | **96606** | 96634 (6286) |
| Zephras Isle (2521) | Raan Wildwind (263664) | 41.6, 44.8 | 41.67, 44.80 | 96638 | **96101** | 96646 (251905) |
| Tirisfal Glades (1420) | Eleanor Shackleton (265812) | 57.2, 55.4-55.6 | 57.27, 55.49 | 96656 | **96607** | 96658 (265944) |
| Mulgore (1412) | Kaga Wildhoof (265810) | 46.2, 67.2 | 46.18, 67.22 | 96659 | **96605** | 96661 (3067) |
| Durotar (1411) | Brakk (265809) | 52.0, 47.4 | 52.02, 47.31 | 96652 | **96604** | 96655 (3191) |

- G: quest-ID's en titels ([Spoken] + QuestV2), NPC-naam, zone en punt ([WH-tip], zone-ID's nagekeken in AreaTable),
  uiMapID's (UiMap). De avonturier is in [Spoken] de `ender` van The Adventurer; dat past op de NPC van [Zygor].
- A: dat de avonturier ook The Great Outdoors GEEFT (zo staat het in [Zygor]; Spoken heeft geen gever-veld).
- Zephras Isle heeft twee UiMap-rijen (2521 en 2665); 2521 is de zonekaart (A).
- De quest-NPC's staan niet in de Creature-tabel van DB2 (controle: 2671 werd in dezelfde zoekopdracht wél gevonden).
- De quests staan in geen enkele QuestLine (controle: 91564 werd wél gevonden).

**Camping 101 per beroep** — elk beroep heeft 7 varianten (Tailoring en Enchanting 8). Elke groep deelt één
`UniqueBitFlag` in QuestV2 (G). A: één variant af = allemaal af; in de client nameten voor MH erop bouwt.

| Quest | UniqueBitFlag | Quest-ID's |
|---|---|---|
| The Great Outdoors | 69451 | 95998, 96101, 96604, 96605, 96606, 96607, 96608 |
| The Adventurer | 70022 | 96627, 96628, 96630, 96638, 96652, 96656, 96659 |
| Cooking | 70021 | 96626, 96629, 96634, 96646, 96655, 96658, 96661 |
| Leatherworking | 69473 | 96031, 97906, 97922, 97934, 97946, 97958, 97969 |
| Blacksmithing | 69486 | 96044, 97900, 97916, 97928, 97939, 97952, 97964 |
| Alchemy | 69487 | 96045, 97899, 97915, 97927, 97938, 97951, 97963 |
| Mining | 69488 | 96046, 97907, 97923, 97935, 97948, 97959, 97970 |
| First Aid | 69489 | 96047, 97903, 97919, 97931, 97942, 97955, 97965 |
| Fishing | 69492 | 96050, 97904, 97920, 97932, 97943, 97956, 97967 |
| Herbalism | 69497 | 96055, 97905, 97921, 97933, 97944, 97957, 97968 |
| Skinning | 69498 | 96056, 97908, 97924, 97936, 97949, 97960, 97971 |
| Tailoring | 69499 | 96057, 96102, 97925, 97937, 97950, 97961, 97972, 97973 |
| Engineering | 69500 | 96058, 97902, 97918, 97930, 97941, 97954, 98285 |
| Enchanting | 69501 | 96059, 97901, 97917, 97929, 97940, 97953, 98284, 98286 |

Welk blok bij welke zone hoort (A, anker = de Skinning-quest die [Zygor] per zone noemt + rassen in [Spoken]):
Dun Morogh 96031-96059 · Durotar 97899-97908 + 96102 · Elwynn 97915-97925 · Mulgore 97927-97937 · Teldrassil
97938-97950 · Tirisfal 97951-97961 · Zephras 97963-97973 + 98284-98286.

**Hogere tiers** (ItemSparse, G): tier 2 vraagt 140, tier 3 vraagt 300.

| Geeft de buff van | Tier 2 (item) | Tier 3 (item) |
|---|---|---|
| Camp Chair | Field Guide 279969 | Trapper's Workbench 279938 |
| Sharpening Wheel | Anvil 279988 | Master Forge 279955 |
| Incense Candle | Greenhouse 279964 | Seed Hybridizer 279947 |
| Mana Well | Fermenter 279970 | Alchemy Laboratory 279990 |
| Lodestone | Rock Garden 279948 | Molten Foundry 279952 |
| Fish Bowl | Fishing Rack 279965 | Fishing Hut 279966 |
| First Aid Kit | Toxin Study 279940 | Plague Doctor's Laboratory 279951 |
| Faction Banner | Spinning Wheel 279943 | Loom 279959 |
| Enchanted Lute | Arcane Salvager 279985 | Arcane Forge 279987 |
| Camp Tent | Tanning Rack 279941 (**125**) | Sewing Machine 279945 |
| Reagent Bot (geen buff) | Repair Bot 279949 | Anarchist's Workbench 279989 (vervangt niets) |
| Cooking (geen buff, "Requires a Cooking Fire nearby") | Cookie's Feast 279957 | Iron Oven 279982 |

## 7. Nieuwe of andere feiten

1. **Kit-stap** (G): elk recept maakt een item; het item gebruik je om te plaatsen. Zie fout 2.
2. **10 s cast** voor maken én plaatsen (G: CastingTimeIndex 7 = 10000 ms). In het spel niet gemeten.
3. **Het vuur staat 15 min** (G, 900000 ms), met 5 min cooldown.
4. **Foutmeldingen in de client** (G, GlobalStrings enUS, ook vertaald in de/fr/es/esMX/pt/ru):
   - 57727 "You cannot place a new campfire within 100 yards of an existing campfire."
   - 57726 "No room for more features at this camp."
   - 57735 "This camp already has that feature." → één per soort per kamp.
   - 57725 "You cannot place a feature that close to a creature or object."
5. **Expert Campfire Kit vraagt Cooking 220**, Journeyman 90, Basic 1 (G).
6. **Tent** (G): eigen zichtbare timer "Camp Tent" 1229487 van 30 s; daarna 1 uur Boosted Rest. Boosted Rest is dus de
   blokkade, niet de bonus.
7. **Geen level-eis** in spell- of itemdata (G).
8. **Permanence** 1225502 (G): groepsbuffs +100%, kampbuffs +50%.
9. **"Camping" 1308027** (A): als deze debuff op de speler staat, kan MH de object-cooldown aflezen. Nameten.
10. **Camp Benefits bij doodgaan** (A): geen "blijft na dood"-bit → waarschijnlijk weg. Nameten.
11. **Italiaans**: de itIT-bestanden van SpellName en GlobalStrings bevatten voor deze regels Engelse tekst (G voor de
    34 gelezen regels). A: Forever heeft geen Italiaanse namen; gebruik Engels in itIT.
12. **esES en esMX verschillen** op vijf spellnamen en de drie kit-items (zie namentabel).
13. Bestaan als item, niet verder uitgezocht: Cozy Sleeping Bag 211527, Adventurer's Tent 288185, Scarlet Banner
    278030, Pouch of Violet Dust 289439 (spell "Throw Violet Dust" 1328348: "Requires WoW: Forever Launch Celebration").
14. Recepten: SkillLineAbility heeft voor tier 1 MinSkillLineRank 1 en beide grijs-grenzen op 20 (G). A: het recept
    geeft geen skillpunten vanaf 20.
15. Plaats-spell 1307230 (Camp Tent) en 1307254 (Lodestone) zetten twee objecten neer; de vuren hebben ook een
    oproep-effect met creature-ID 260300 (G: effecten in SpellEffect; wat ze in het spel doen is niet gemeten).

## 8. Niet te meten met deze bronnen (open)

- Leesbaarheid van 1283391, 1229739/1289723, 1229741, 1229451, 1229487 en 1308027 in de client, buiten en in combat.
- Echte afstanden in het spel; echte staduur; of Camp Benefits blijft bij opstaan, weglopen of doodgaan.
- Bij wie je recepten leert en op welke skill; waar blueprints vallen; wie Simple Wood verkoopt.
- Level waarop de quests beschikbaar komen; of het vuur schade doet.
- Of een kok ook de oude spell 818 krijgt.
- Of je in een groep moet zitten voor andermans object.

---

## 9. Wat de schrijver mag gebruiken

Veilig (G, Blizzards data):
- Kamperen is geen beroep. Elk beroep maakt één kampobject; Cooking maakt het vuur.
- Vuur: maak een **Basic Campfire Kit** (1 Simple Wood, gereedschap Flint and Tinder, Cooking 1) en gebruik de kit.
  Alleen buiten, niet in combat. 5 minuten cooldown. Plek voor 3 objecten (Journeyman 5, Expert 10).
- Object: maak het met je beroep (skill 20 om het te plaatsen), zet het bij een vuur. Het item gaat op. Alle objecten
  delen 1 uur cooldown. Elk soort object maar één keer per kamp.
- Ga bij het vuur zitten. Je krijgt **Welcoming Campfire** (60 seconden; craften mag, lopen niet). Daarna
  **Camp Benefits**, 1 uur, met één regel per object.
- Effect per object en per level: de tabel in hoofdstuk 5. "Botst met": de tabel in hoofdstuk 3.
- Tent: 30 seconden bij de tent rusten → rested XP tot 5% van een level, één keer per uur (**Boosted Rest** = de
  blokkade van 1 uur).
- Faction Banner werkt alleen voor de eigen factie. Reagent Bot geeft geen buff maar verkoopt reagents.
- Startquest **The Great Outdoors** in 7 startzones; gever en plek: tabel in hoofdstuk 6.
- Namen per taal: hoofdstuk 10.

Alleen met "waarschijnlijk" of pas na Robs test: afstanden in yards, 15 minuten staduur, 10 seconden cast, "weg bij
doodgaan", de 1 minuut van de startquest, één quest-variant af = alle af.

Niet gebruiken: "35 yd bereik van het object", "direct vuur maken uit hout", "5 startzones", verkopers en dropplekken.

## 10. Namentabel per taal — G, SpellName en ItemSparse per locale [DB2]

Itemnaam = spellnaam, behalve bij de drie kits (aparte regels). itIT: Engels (zie 7.11). nlNL en enUS: Engels.

**Buffs**

| ID | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 1283391 | Campfire Nearby | Lagerfeuer in der Nähe | Feu de camp proche | Hoguera cercana | Hoguera cercana | Fogueira Próxima | Кострище неподалеку |
| 1229739 / 1289723 | Welcoming Campfire | Einladendes Lagerfeuer | Feu de camp accueillant | Hoguera agradable | Hoguera acogedora | Fogueira Acolhedora | Приветливый костер |
| 1229741 | Camp Benefits | Lagervorteile | Avantages du camp | Beneficios de campamento | Beneficios de campamento | Benefícios de Acampamento | Бонусы лагеря |
| 1229451 | Boosted Rest | Verbesserter Ruhebonus | Repos amplifié | Descanso mejorado | Descanso mejorado | Descanso Melhorado | Улучшенный отдых |
| 1308027 | Camping | Lager aufschlagen | Campement | Acampando | Campamento | Acampamento | Разбить лагерь |

**Vuren en kits**

| ID | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| spell 1229737 / 1307227 | Basic Campfire | Einfaches Lagerfeuer | Feu de camp basique | Hoguera básica | Hoguera básica | Fogueira Básica | Обычный костер |
| item 279981 | Basic Campfire Kit | Einfaches Lagerfeuerset | Kit de feu de camp basique | Equipo de hoguera básica | Hoguera básica | Kit de Fogueira Básica | Набор для разведения костра |
| spell 1283400 | Journeyman Campfire | Lagerfeuer des Gesellen | Feu de camp de compagnon | Hoguera de oficial | Hoguera de oficial | Fogueira Profissional | Костер подмастерья |
| item 279961 | Journeyman Campfire Kit | Lagerfeuerset des Gesellen | Kit de feu de camp de compagnon | Equipo de hoguera de oficial | Hoguera de oficial | Kit de Fogueira Profissional | Набор подмастерья для разведения костра |
| spell 1291341 | Expert Campfire | Expertenlagerfeuer | Feu de camp de spécialiste | Hoguera de experto | Hoguera de experto | Fogueira do Especialista | Костер умельца |
| item 279974 | Expert Campfire Kit | Expertenlagerfeuerset | Kit de feu de camp de spécialiste | Equipo de hoguera de experto | Hoguera de experto | Kit de Fogueira do Especialista | Набор умельца для разведения костра |
| item 4470 | Simple Wood | Einfaches Holz | Bois simple | Madera simple | Madera simple | Madeira Simples | Простая древесина |
| item 4471 | Flint and Tinder | Feuerstein und Zunder | Silex et amadou | Sílex y Yesca | Sílex y yesca | Pederneira e Lenha | Кремень и трут |

**De 11 objecten**

| Item | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 279979 | Camp Chair | Lagerstuhl | Chaise du camp | Silla de campamento | Silla de campamento | Cadeira de Acampamento | Лагерный стул |
| 279944 | Sharpening Wheel | Schleifstein | Meule à aiguiser | Rueda de afilar | Rueda de afilar | Roda de Afiar | Круг для заточки |
| 279962 | Incense Candle | Räucherkerze | Bougie d’encens | Vela de incienso | Vela de incienso | Vela de Incenso | Ароматная свеча |
| 279956 | Mana Well | Manabrunnen | Puits de mana | Pozo de maná | Pozo de maná | Poço de Mana | Колодец маны |
| 279960 | Lodestone | Leitstein | Magnétite | Magnetita | Magnetita | Magnetita | Магнетит |
| 279967 | Fish Bowl | Fischglas | Bocal à poisson | Cuenco con pescado | Cuenco de pescado | Aquário | Аквариум |
| 279968 | First Aid Kit | Verbandtasche | Trousse de premiers soins | Equipo de primeros auxilios | Equipo de primeros auxilios | Kit de Primeiros Socorros | Набор первой помощи |
| 279972 / 279973 | Faction Banner | Fraktionsbanner | Bannière de faction | Estandarte de facción | Estandarte de facción | Estandarte de Facção | Знамя фракции |
| 279976 | Enchanted Lute | Verzauberte Laute | Luth enchanté | Laúd encantado | Laúd encantado | Alaúde Encantado | Зачарованная лютня |
| 279978 | Camp Tent | Lagerzelt | Tente du camp | Tienda de campamento | Tienda de campamento | Barraca de Acampamento | Лагерная палатка |
| 279950 | Reagent Bot | Materialbot | Robot vendeur de composants | Robot de componentes | Robot de componentes | Robô de Reagentes | Реагентобот |

**Verborgen deel-auras** (alleen nodig voor diagnose)

| ID | enUS | deDE | frFR | esES | esMX | ptBR | ruRU |
|---|---|---|---|---|---|---|---|
| 1229519 | Boosted Critical Chance | Verbesserte kritische Trefferchance | Chances de coup critique amplifiées | Probabilidad de golpe crítico mejorada | Probabilidad de crítico mejorada | Chance de Acerto Crítico Melhorada | Повышенная вероятность критического удара |
| 1230172 | Extra Strength | Zusätzliche Stärke | Force supplémentaire | Fuerza extra | Fuerza adicional | Força Adicional | Дополнительная сила |
| 1229513 | Boosted Intellect | Verbesserte Intelligenz | Intelligence amplifiée | Intelecto mejorado | Intelecto mejorado | Intelecto Melhorado | Повышенный интеллект |
| 1230587 | Boosted Mana Regeneration | Verbesserte Manaregeneration | Régénération de mana amplifiée | Regeneración de maná mejorada | Regeneración de maná mejorada | Regeneração de Mana Melhorada | Ускоренное восполнение маны |
| 1230164 | Boosted Attack Power | Verbesserte Angriffskraft | Puissance d’attaque amplifiée | Poder de ataque mejorado | Poder de ataque mejorado | Poder de Ataque Melhorado | Повышенная сила атаки |
| 1230098 / 1230653 | Boosted Stats | Verbesserte Grundwerte | Caractéristiques amplifiées | Estadísticas mejoradas | Estadísticas mejoradas | Atributos Melhorados | Повышенные характеристики |
| 1230124 | Boosted Stamina | Verbesserte Ausdauer | Endurance amplifiée | Aguante mejorado | Aguante mejorado | Vigor Melhorado | Повышенная выносливость |
| 1229718 | Boosted Spirit | Verbesserte Willenskraft | Esprit amplifié | Espíritu mejorado | Espíritu mejorado | Espírito Melhorado | Повышенный дух |

esES ≠ esMX bij: Welcoming Campfire, Camping, Fish Bowl, Boosted Critical Chance, Extra Strength, en de drie kit-items
(esMX laat "Equipo de" weg) plus de hoofdletter in Flint and Tinder.
