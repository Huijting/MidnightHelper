# Shaman per rol — feiten voor "How you play" (WoW Forever)

Onderzoek: 17 nov 2026, mh-research. Build van de spel-data: **1.60.1.70938**.
Doel: mh-writer schrijft hiermee `ROLES.SHAMAN` in `Modules/ForeverHowToPlay.lua`, in de vorm van `ROLES.DRUID` (r. 373-453).
Dit bestand bevat alleen feiten. Geen kant-en-klare tekst.

## Hoe je dit leest

- **[G …]** = GEMETEN: gezien in de genoemde bron (code staat in hoofdstuk 12).
- **[A]** = AFGELEID: beredeneerd uit gemeten feiten. De redenering staat erbij.
- "r." = regelnummer in een Lua-bestand van de addon. Bij DB2 staat een rij-ID of spell-ID, geen regelnummer.
- Staat er geen getal, dan is het getal niet (betrouwbaar) gemeten. Verzin er dan geen.
- Toetsen komen letterlijk uit `Modules/ForeverBlock_Shaman.lua` (BLK). Niets is verzonnen.
- Spreuknamen zijn Engels, zoals de client ze toont (DB2 `SpellName`, build 70938).

## 0. Kort

- Band 1 = **Elemental**, band 2 = **Enhancement**, band 3 = **Restoration**. [G, zie 1]
- De gidsen noemen **Enhancement** de boom om mee te levelen. Elemental kan, maar is zwakker en kost veel mana. Restoration is traag in je eentje en goed in dungeons. [G, zie 5-7]
- **Tanken**: Blizzard zegt zelf dat Enhancement een "temporary tank in small group gameplay" kan zijn. Er is geen tank-boom, geen taunt en geen verdedigings-cooldown. [G, zie 6.5]
- 🔴 **Hotfix-probleem**: Blizzard veranderde op 10 nov (live 12 nov) Stormstrike, Mental Dexterity en Maelstrom Weapon. De spelbestanden van build 70938 hebben nog de oude getallen. Noem voor die drie liever geen getal. [G, zie 9.1]
- 🔴 **Niet noemen**: Lava Burst, Elemental Mastery, Totemic Projection, Two-Handed Axes and Maces (talent), Parry (talent). Zie 10.

## 1. Welke boom is welke band

| Band | Boom | PosX in DB2 | Aantal talenten | Bewijs |
|---|---|---|---|---|
| 1 | Elemental | 1020-2820 | 16 | bevat Convection, Concussion, Lightning Mastery |
| 2 | Enhancement | 5020-6820 | 18 | bevat Stormstrike, Maelstrom Weapon, Rage of the Farseer |
| 3 | Restoration | 9080-10880 | 16 | bevat Water Shield, Mana Tide Totem, Riptide |

- De shaman-boom is `TraitTree` **1082**. [G DB2 TraitTree ID 1082; MAC r.676]
- 50 nodes: 104724-104773. [G DB2 TraitNode, filter TraitTreeID=1082]
- Band-grenzen in de addon: PosX < 4000 = 1, < 8000 = 2, anders 3. [G MAC r.705]
- De namen bij de banden: `SPEC_NAMES.SHAMAN.enUS = { "Elemental", "Enhancement", "Restoration" }`. [G MAC r.636]
- `TalentTab`: Elemental OrderIndex 0, Enhancement 1, Restoration 2 (ClassMask 64). [G DB2 TalentTab ID 261, 263, 262]
- MH's eigen richting-zinnen zeggen hetzelfde: `FDIR_SHAMAN_1` = "Lightning and fire from a distance.", `_2` = "Hit up close with a big weapon…", `_3` = "Heal with nature magic… (healer)". [G Locales/enUS.lua r.5090-5092]
- Rob zag in het spel: Shaman 1 = Elemental. Dat klopt hiermee. [G opdracht]
- Dat de band-naam bij de inhoud hoort, is [A]: de talenten in elke band passen bij die naam, en de volgorde 0/1/2 in `TalentTab` is dezelfde.
- `TalentTab.RoleMask` is 0 voor alle drie. De rol (damage/tank/healer) staat dus niet in die tabel. [G DB2 TalentTab]

## 2. De talentboom van Forever (alle 50 talenten)

### 2.1 De regel voor het vroegste level

- Je krijgt 1 talentpunt per level, vanaf level 10 tot en met 60 (51 punten). [G DB2 TraitCurrencySource, 51 rijen "Level 10"…"Level 60", currency 3820]
- Elke rij van een boom vraagt 5 punten meer in díé boom: rij 2 = 5, rij 3 = 10, rij 4 = 15, rij 5 = 20, rij 6 = 25, rij 7 = 30. [G DB2 TraitCond 42795-42812 + TraitNodeGroupXTraitCond 20416-20433]
- Vroegste level = 10 + benodigde punten. [A: het 16e punt krijg je op level 25, enz.]
  Rij 1 = 10, rij 2 = 15, rij 3 = 20, rij 4 = 25, rij 5 = 30, rij 6 = 35, rij 7 = 40.
- `TraitCond.RequiredLevel` is 0 bij alle 18 rijen: de boom zelf vraagt geen level. [G DB2 TraitCond]
- Legacy-perk **Talented**: 5 rangen, elk geeft 1 extra punt, op level 9, 8, 7, 6 en 5. [G DB2 TraitCurrencySource 37163-37167]
  Dus tot 5 levels eerder. [A] Icy Veins zegt hetzelfde: "one level ahead of the curve per point". [G IV-ENH]
- Blizzard: één-punts "milestone"-talenten op het 11e, 16e, 21e en 31e punt. [G BLIZ-DD] Dat past: rij 3, 4, 5 en 7 hebben elk een talent met 1 rang.

### 2.2 Elemental (band 1)

| Vroegste level | Talent (rangen) | Wat het doet (client-tekst, kort) |
|---|---|---|
| 10 | Convection (5) | Shocks, Lightning Bolt en Chain Lightning kosten minder mana |
| 10 | Concussion (5) | meer damage van Lightning Bolt, Chain Lightning, Earth Shock |
| 15 | Elemental Devastation (3) | een crit met een spell geeft even meer melee-crit |
| 15 | Reverberation (5) | kortere cooldown op je Shocks |
| 15 | Elemental Alacrity (3) | Lightning Bolt en Chain Lightning casten sneller |
| 15 | Call of Flame (3) | meer damage van Fire-totems, Flame Shock, Fire Nova; Flame Shock duurt langer |
| 20 | **Elemental Focus (1)** | 10% kans dat je volgende damage-spell geen mana kost |
| 20 | Elemental Warding (3) | minder damage van Fire, Frost en Nature |
| 25 | Trial by Fire (2) | sterkere Fire Nova, kortere cooldown; Magma Totem duurt langer |
| 25 | Eye of the Storm (3) | Lightning Bolt en Chain Lightning lopen minder vertraging op als je geraakt wordt |
| 25 | **Earthbound (1)** | Earthbind Totem zet vijanden 5 sec vast, op het moment dat je hem neerzet |
| 30 | Elemental Reach (2) | meer bereik voor Lightning Bolt, Chain Lightning, Fire Nova |
| 30 | **Call of Thunder (1)** | +5% crit op Lightning Bolt en Chain Lightning |
| 30 | Lightning Overload (3) | kans op een gratis tweede spell (halve damage, geen threat) |
| 35 | Elemental Fury (5) | grotere crits |
| 40 | **Lightning Mastery (1)** | knop: 15 sec lang Lightning Bolt 0,5 sec sneller en Chain Lightning zonder cooldown; cooldown 3 min |

[G DB2 TraitNode/TraitNodeXTraitNodeEntry/TraitNodeEntry/TraitDefinition/SpellName/Spell; levels [A] volgens 2.1]
Getallen bij 1-rangs talenten: Elemental Focus 10% en -100% [G DB2 SpellEffect 16164, 16246]; Earthbound 5 sec [G SpellMisc 1238289 → SpellDuration 28 = 5000]; Call of Thunder 5 [G SpellEffect 16120]; Lightning Mastery -500 ms, -100% cooldown, 15 sec, 180000 ms [G SpellEffect 16166, SpellDuration 8, SpellCooldowns 55129].
Volgorde-eisen: Call of Thunder → Lightning Mastery; Elemental Alacrity → Lightning Overload → Elemental Fury. [G DB2 TraitEdge 136760-136762]
De richting van zo'n pijl (links = eerst nodig) is [A]. Hij klopt met Blizzard voor Stormstrike → Improved Stormstrike en Mental Dexterity → Flurry [G BLIZ-DD], en met classicwowforever voor Call of Thunder → Lightning Mastery [G CWF-ELE].

### 2.3 Enhancement (band 2)

| Vroegste level | Talent (rangen) | Wat het doet (client-tekst, kort) |
|---|---|---|
| 10 | Earth's Grasp (2) | sterkere Stoneclaw Totem, groter bereik Earthbind Totem |
| 10 | Thundering Strikes (5) | meer crit met alle spells en aanvallen |
| 10 | Ancestral Knowledge (5) | meer Intellect |
| 15 | Guardian Totems (2) | sterkere Stoneskin en Windwall Totem; kortere cooldown Grounding Totem |
| 15 | Mental Dexterity (3) | Intellect telt mee als Attack Power |
| 15 | Improved Lightning Shield (3) | meer damage van Lightning Shield |
| 20 | Elemental Weapons (3) | sterkere weapon buffs (Rockbiter, Windfury, Flametongue, Frostbrand) |
| 20 | **Shamanistic Focus (1)** | Shocks en Lightning Shield kosten 45% minder mana |
| 20 | Anticipation (3) | meer dodge |
| 25 | Toughness (5) | meer Stamina |
| 25 | Flurry (5) | sneller slaan na een melee-crit |
| 25 | **Stormstrike (1)** | knop: directe klap met je wapen; je volgende Lightning Bolt, Chain Lightning of Earth Shock op dat doel doet 20% meer, 12 sec lang |
| 25 | Improved Ghost Wolf (2) | Ghost Wolf sneller (2/2: direct) en ook binnen te gebruiken |
| 30 | **Spirit Weapons (1)** | kans op parry; 30% minder threat zonder Rockbiter Weapon, 30% meer threat mét Rockbiter Weapon |
| 30 | Mental Quickness (2) | Intellect geeft spell damage en healing |
| 30 | Improved Stormstrike (2) | Stormstrike geeft kans op mana-regeneratie tijdens casten; dodge of parry kan de cooldown van Stormstrike resetten |
| 35 | Maelstrom Weapon (5) | melee-klappen maken je volgende Lightning Bolt sneller en goedkoper; tot 5 stapels, 30 sec |
| 40 | **Rage of the Farseer (1)** | knop: 30% sneller slaan, 25 sec; cooldown 3 min |

[G zelfde tabellen als 2.2; levels [A]]
Improved Ghost Wolf "2/2: direct" komt niet uit DB2 maar uit Blizzard ("Rank 2 now makes Ghost Wolf Instant") en Icy Veins. [G BLIZ-DD; G IV-ENH]
Getallen: Shamanistic Focus -45 [G SpellEffect 1223030]; Stormstrike +20% en 12 sec [G SpellEffect 695309, SpellDuration 29]; Spirit Weapons -30 en +30 [G SpellEffect 693487, 1344362]; Maelstrom 5 stapels, 30 sec [G SpellAuraOptions 223900, SpellDuration 9]; Rage of the Farseer 30, 25 sec, 180000 ms [G SpellEffect 1103080, SpellDuration 63, SpellCooldowns 86894].
Volgorde-eisen: Mental Dexterity → Flurry; Stormstrike → Improved Stormstrike; Mental Quickness → Rage of the Farseer. [G DB2 TraitEdge 136317, 124583, 124584]
🔴 Stormstrike-damage en -cooldown, Mental Dexterity-% en Maelstrom-kans: zie 9.1 (hotfix).
⚠️ Stormstrike heeft in `SpellLevels` level 40 (oude classic-waarde). [G DB2 SpellLevels 102859] De boom zet hem op rij 4 (15 punten). Blizzard: "Moved from the 31-point … to the 16-point gold medal talent". [G BLIZ-DD] Icy Veins: "25 | Stormstrike can be reached". [G IV-ENH] MH gebruikt al 25. [G MAC r.478-481; HTP r.311]

### 2.4 Restoration (band 3)

| Vroegste level | Talent (rangen) | Wat het doet (client-tekst, kort) |
|---|---|---|
| 10 | Improved Healing Wave (5) | Healing Wave cast sneller |
| 10 | Tidal Focus (5) | heals kosten minder mana; meer kans om te raken |
| 15 | Mindfulness (3) | een deel van je mana-regeneratie loopt door tijdens casten |
| 15 | Natural Grace (3) | minder threat van je spells |
| 15 | Totemic Focus (5) | totems kosten minder mana |
| 15 | Improved Reincarnation (2) | kortere cooldown Reincarnation, meer health |
| 20 | Ancestral Healing (3) | een heal-crit geeft het doel even meer armor |
| 20 | Healing Focus (3) | heals lopen minder vertraging op als je geraakt wordt |
| 20 | **Water Shield (1)** | knop: 3 waterbollen; word je geraakt of crit een spell van jou, dan krijg je 2% van je mana terug per bol; duurt 10 min |
| 25 | Tidal Mastery (5) | meer crit op heals |
| 25 | Restorative Totems (5) | sterkere Mana Spring en Healing Stream Totem |
| 25 | **Mana Tide Totem (1)** | knop: totem die je groep mana teruggeeft; cooldown 5 min |
| 30 | Healing Way (3) | Healing Wave heelt meer |
| 30 | **Nature's Swiftness (1)** | knop: je volgende Nature-spell (cast korter dan 10 sec) is direct; cooldown 3 min |
| 35 | Purification (5) | al je heals helen meer |
| 40 | **Riptide (1)** | knop: heal over 15 sec; Chain Heal die je direct op dat doel cast heelt 25% meer; cooldown 12 sec |

[G zelfde tabellen; levels [A]]
Getallen: Water Shield 3 bollen, 2%, 600 sec [G SpellAuraOptions 223904, SpellEffect 1072688, SpellDuration 6]; Mana Tide 300000 ms [G SpellCooldowns 55056]; Nature's Swiftness 180000 ms [G SpellCooldowns 55054]; Riptide 15 sec, 25, 12000 ms [G SpellDuration 8, SpellEffect 1072709, SpellCooldowns 84834].
Volgorde-eis: Healing Way → Riptide. [G DB2 TraitEdge 132566]
Riptide heeft in build 70938 geen directe heal: de tekst zegt alleen "Heals … over $d". [G DB2 Spell 408521]
Sterkere rangen bij de trainer: Mana Tide Totem op 38, 48, 58; Riptide op 50 en 60. [G TD r.1080, 1115, 1144, 1119, 1151]

### 2.5 Getallen bij talenten met meer rangen

Niet gemeten. De DB2-waarde van de eerste rang is niet op één manier om te rekenen naar de hoogste rang (soms per rang, soms het eindgetal). Noem daar geen getal, of neem het uit een gids mét bron.

## 3. MH's vaste toetsen (overnemen, niets verzinnen)

[G BLK r.22-63]

| Toets | Spreuk | Toets | Spreuk |
|---|---|---|---|
| **1** | Lightning Bolt | **E** | Earth Shock |
| **2** | Flame Shock | **R** | Ghost Wolf |
| **3** | Stormstrike | **Shift-R** | Totemic Call |
| **4** | Frost Shock | **F** | Stoneclaw Totem |
| **5** | Searing Totem | **Z** | Stoneskin Totem |
| **Shift-1** | Chain Lightning | **X** | Grounding Totem |
| **Shift-2** | Chain Heal | **C** | Healing Wave |
| **Shift-3** | Nature's Swiftness | **V** | Earthbind Totem |
| **Shift-4** | Fire Nova | **Shift-Z** | Water Shield, anders Lightning Shield |
| **Q** | Lightning Mastery of Rage of the Farseer | **Shift-X** | Strength of Earth Totem |
| **F1** | Mana Tide Totem | **Shift-C** | Cure Poison |
| **F2** | Lesser Healing Wave | **Shift-V** | Cure Disease |
| **F3** | Ancestral Spirit | **Shift-Q** | Purge |
| **F4** | Healing Stream Totem | **Shift-F** | Tremor Totem |
| **Shift-F1** | Riptide | **Shift-E** | race-spell |
| **Ctrl-1** | Call of the Elements | **Ctrl-2 / Ctrl-3** | Call of the Ancestors / Call of the Spirits |

- **Blok D** (eigen Alt-toetsen, geen vaste toets): Rockbiter Weapon, Flametongue Weapon, Frostbrand Weapon, Windfury Weapon, Magma Totem, Totemic Recall, Astral Recall, Water Walking. [G BLK r.57-59]
- **Geen toets, via de totem-balk of het spellbook**: Frost Resistance Totem, Flametongue Totem, **Mana Spring Totem**, Poison Cleansing Totem, Fire Resistance Totem, Disease Cleansing Totem, Nature Resistance Totem, **Windfury Totem**, Sentry Totem, Windwall Totem, **Grace of Air Totem**, Water Breathing, Far Sight. [G BLK r.61-63]
- Heb je Water Shield, dan cast Shift-Z Water Shield en niet meer Lightning Shield. [G HTP r.318] Lightning Shield heeft dan geen toets op het blok. [A]
- Lightning Mastery en Rage of the Farseer delen Q. Ze vragen elk 30 punten in hun boom; samen kan dat niet met 51 punten (56 met Talented). [A uit 2.1]
- Reincarnation is passief ("Passive" in DB2): geen toets nodig. [G DB2 Spell 20608]

## 4. Totems (hoort bij elke rol)

- Vier elementen; per element één Totem-item uit een class-quest: Earth (level 4; 3 voor Skyborne), Fire (10), Water (20), Air (30). [G HTP r.285; G IV-ENH "Leveling Milestones"; G WFI]
- De quests heten Call of Earth, Call of Fire, Call of Water, Call of Air. [G IV-ENH; G PS]
- Welk item een totem vraagt: [G DB2 SpellTotems + TotemCategory]
  - **Earth Totem**: Stoneskin, Earthbind, Stoneclaw, Strength of Earth, Tremor.
  - **Fire Totem**: Searing, Magma.
  - **Water Totem**: Healing Stream, Mana Spring, Mana Tide.
  - **Air Totem**: Grounding, Windfury Totem.
- Eerste rang uit de quest: Stoneskin Totem (4), Searing Totem (10), Healing Stream Totem (20). [levels: G DB2 SpellLevels 8071/3599/5394; niet bij de trainer: G TD, rang 2 heeft `req` naar die id's, r.1007, 1022, 1052; "uit de quest": G HTP r.295, 300, 308 en G PS (beloningen van Call of Earth/Fire/Water)]
- Vanaf 20 de totem-balk met Call of the Elements (20), Call of the Ancestors (30), Call of the Spirits (40): tot 4 totems tegelijk, cast 3 sec. [G TD r.1016, 1050, 1083; G DB2 Spell 66842-66844; SpellCastTimes 14 = 3000]
- Totemic Recall (20, blok D); Totemic Call (22, Shift-R): haalt je totems naar je toe, cooldown 30 sec. [G TD r.1023, 1027; G DB2 Spell 437009, SpellCooldowns 88785]
- De meeste totems staan 5 minuten (Strength of Earth, Stoneskin, Tremor, Healing Stream). Kort blijven: Searing rang 1 (30 sec), Magma (20 sec), Earthbind en Grounding (45 sec), Stoneclaw (15 sec). [G DB2 SpellMisc → SpellDuration 5, 9, 18, 22, 8]
- Icy Veins over Call of the Elements: cast van 3 sec, en je hebt zelden alle 4 nodig; los neerzetten is vaak makkelijker, de Call vooral vóór een gevaarlijke pull. [G IV-ENH, IV-ELE]
- Icy Veins over Totemic Call: kost veel mana. [G IV-ENH] classicwowforever: 25% van je basis-mana. [G CWF-ENH] Mana-kosten niet in DB2 nagemeten.
- Welke totem per element (Icy Veins): Earth = Strength of Earth (damage) of Stoneskin (verdediging); Fire = Searing, of Magma tegen meer vijanden als je mana het toelaat; Water = Mana Spring; Air = Windfury Totem bij melee, Grounding tegen casters. [G IV-ENH, IV-ELE, IV-RES]

## 5. Rol: Elemental

- **band** = 1 [G, zie 1]
- **Voorgestelde title**: `Elemental: damage from a distance`

### 5.1 Intro-feiten

- Vanaf level 1: Lightning Bolt is een startspreuk. [G DB2 SpellLevels 403 = 1; niet in TD, wel als `req` r.994]
- Flame Shock komt op 10, Chain Lightning op 32. [G TD r.998, 1057]
- Lightning Mastery is het laatste talent: 40 op zijn vroegst. [A uit 2.2]
- Gidsen: Elemental kan, maar is niet de eerste keus om mee te levelen. Icy Veins: "not quite as good of a specialization to level with … due to its current Mana and low damage concerns". [G IV-ELE] wowfdb en wowforeverinfo noemen Enhancement de level-boom. [G WFDB, WFI]
- Zwak punt volgens Icy Veins: "Extremely high Mana costs", "needs to stand and cast", "Easily overwhelmed by multiple enemies". [G IV-ELE]
- Tip van Icy Veins: is de vijand bijna dood, sla hem dan met je wapen dood in plaats van nog een spell te betalen. [G IV-ELE]

### 5.2 Simple order (met toetsen)

Bronnen: Icy Veins Elemental leveling (4 nov) en classicwowforever Elemental (11 nov). Ze zijn het op de volgorde eens.

Vooraf: Lightning Shield (**Shift-Z**, vanaf 8). Searing Totem (**5**, vanaf 10) neerzetten vóór de pull. [G CWF-ELE; G IV-ELE]

1. Open van ver met Lightning Bolt (**1**). [G IV-ELE; G CWF-ELE]
2. Flame Shock (**2**, vanaf 10) op een vijand die lang leeft. [G IV-ELE "Keep Flame Shock active on your main target"; G CWF-ELE]
3. Lightning Bolt (**1**) als vulling. [G IV-ELE]
4. Drie of meer vijanden: Fire Nova (**Shift-4**, vanaf 12) en Chain Lightning (**Shift-1**, vanaf 32) zodra ze klaar zijn. [G IV-ELE]
5. Lightning Mastery (**Q**, vanaf 40) voor een elite of een grote groep. [G IV-ELE]
6. Earth Shock (**E**) bewaren voor als de vijand cast. [G CWF-ELE "keep Earth Shock for interrupts"; G HTP r.305]

Te weinig health: Healing Wave (**C**). [G HTP r.305]
Vijand te dichtbij: Earthbind Totem (**V**) of Frost Shock (**4**, vanaf 20). [G IV-ELE "Great for kiting"]

### 5.3 Per 10 levels

- **10**: Lightning Bolt (**1**, 1), Earth Shock (**E**, 4), Lightning Shield (**Shift-Z**, 8), Flame Shock (**2**, 10), Searing Totem (**5**, 10, quest). [G TD r.990, 995, 998; DB2 SpellLevels 3599]
  Talenten vanaf 10: Convection, Concussion (passief). [A uit 2.2]
  Daarna: Fire Nova (**Shift-4**) op 12, Purge (**Shift-Q**) op 12, Tremor Totem (**Shift-F**) op 18. [G TD r.1002, 1004, 1015]
- **20**: Frost Shock (**4**), Ghost Wolf (**R**), Call of the Elements (**Ctrl-1**). [G TD r.1017, 1019, 1016] Elemental Focus (talent, passief, 20 op zijn vroegst). [A]
  Daarna: Totemic Call (**Shift-R**) op 22; Earthbound (talent, 25): Earthbind Totem (**V**) zet vijanden 5 sec vast; Magma Totem (blok D) op 26. [G TD r.1027, 1040; A]
- **30**: Call of Thunder (talent, passief, 30 op zijn vroegst). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passief). [G TD r.1051, 1050, 1054]
  Daarna: Chain Lightning (**Shift-1**) op 32. [G TD r.1057] Lightning Overload (talent, passief, 30+). Elemental Fury (talent, passief, 35). [A]
- **40**: Lightning Mastery (**Q**, talent): 15 sec lang Lightning Bolt 0,5 sec sneller en Chain Lightning zonder cooldown; cooldown 3 min. [G DB2, zie 2.2] Call of the Spirits (**Ctrl-3**). Chain Heal (**Shift-2**). Mail-armor bij de trainer. [G TD r.1083, 1084, 1090]
- **50**: sterkere rangen: Lightning Bolt (50, 56), Chain Lightning (48, 56), Earth Shock (48), Flame Shock (52), Fire Nova (52), Searing Totem (50). Niets nieuws voor deze rol. [G TD r.1118, 1135, 1109, 1131, 1110, 1123, 1122, 1120]
- **60**: sterkere rangen: Earth Shock, Searing Totem. Niets nieuws. [G TD r.1147, 1152]

Vaste feiten bij deze spreuken:
- Chain Lightning: cast 2,5 sec, cooldown 6 sec. [G DB2 SpellCastTimes 19, SpellCooldowns 52993]
- De drie Shocks delen één cooldown van 6 sec. [G DB2 SpellCooldowns 54150, 54158, 54116 (elk 6000, category); G HTP r.313; G IV-ENH-ROT]
- Fire Nova: raakt vijanden rond je actieve Fire-totem; cooldown 10 sec. [G DB2 Spell 408341, SpellCooldowns 84815]
- Chain Lightning kost veel meer mana dan Lightning Bolt (classicwowforever: 495 tegen 220; getal niet in DB2 nagemeten). [G CWF-ELE]

### 5.4 Beginner mistakes (kandidaten, elk met bewijs)

- **Earth Shock voor damage in een groep.** De client-tekst zegt: "Causes a high amount of threat." [G DB2 Spell 8042] En hij deelt de cooldown met Flame Shock, dus daarna geen interrupt. [G HTP r.313]
- **Chain Lightning op één vijand.** Kost veel mana, cooldown 6 sec. [G CWF-ELE; G DB2]
- **Lightning Mastery (Q) met weinig mana.** "It spends a lot of Mana". [G CWF-ELE] Cooldown 3 min. [G DB2]
- **Denken dat Earthbound blijft werken.** De totem zet vijanden alleen vast op het moment dat je hem neerzet ("when cast"), 5 sec. Daarna vertraagt hij alleen. [G DB2 Spell 1222988]
- **Elke vijand met een spell afmaken.** Mana is je grens; sla een bijna dode vijand met je wapen. [G IV-ELE]
- Al in de class-tekst (niet herhalen, of kort): Fire Nova zonder Fire-totem; casten in Ghost Wolf; Shift-Z wordt Water Shield. [G HTP r.314, 316, 318]

## 6. Rol: Enhancement

- **band** = 2 [G, zie 1]
- **Voorgestelde title**: `Enhancement: damage up close`

### 6.1 Intro-feiten

- Vanaf level 1: je slaat met je wapen, met Rockbiter Weapon erop (trainer, level 1). [G TD r.989]
- Stormstrike is een talent, 25 op zijn vroegst. Windfury Weapon komt op 30 bij de trainer. [A uit 2.3; G TD r.1056]
- Gidsen: dit is de boom om mee te levelen. Icy Veins: "a comfy experience once you have your build set up". wowfdb: "The leveling spec." wowforeverinfo: "Enhancement is the comfortable choice". [G IV-ENH, WFDB, WFI]
- Wapen: een langzaam tweehandig wapen. [G IV-ENH "Aim for a slow 2-Handed weapon"; G CWF-ENH; G ForeverDirection.lua r.182]
- Two-handed axes en maces zijn geen talent meer. [G WFDB; G CWF-ENH; G 2.3: niet in de boom] Icy Veins: leer ze bij een weapon trainer in Orgrimmar of Ironforge. [G IV-ENH] Zelf niet in de client gemeten.
- Mana is de grens. Icy Veins: "Extremely high Mana costs". Tip: stop met casten en sla gewoon door als je mana laag is. [G IV-ENH]
- Weapon buff volgens Icy Veins: Rockbiter Weapon als je alleen speelt, Flametongue Weapon in een groep, Windfury Weapon vanaf 30. [G IV-ENH]

### 6.2 Simple order (met toetsen)

Bronnen: Icy Veins Enhancement leveling (13 nov), Wowhead Enhancement rotation (Yebb, 29 okt), classicwowforever Enhancement (16 nov).

Vooraf: weapon buff aan (blok D). Lightning Shield (**Shift-Z**). Searing Totem (**5**) of je totems neer. [G IV-ENH]

1. Pull met Lightning Bolt (**1**). [G IV-ENH; G CWF-ENH]
2. Stormstrike (**3**, vanaf 25) zodra hij klaar is. [G IV-ENH; G WH-ENH; G CWF-ENH]
3. Lightning Bolt (**1**) bij 5 stapels Maelstrom Weapon (vanaf 35): dan is hij direct en gratis. [G IV-ENH; G WH-ENH; A: 5 × 20% per stapel, G DB2 SpellEffect 1072673/1072674 en BLIZ-HF]
4. Earth Shock (**E**). In een groep afwisselen met Flame Shock (**2**). [G IV-ENH]
5. Fire Nova (**Shift-4**, vanaf 12) als er een Fire-totem staat en je mana over hebt; vooral bij meer vijanden. [G IV-ENH; G WH-ENH]
6. Rage of the Farseer (**Q**, vanaf 40) voor een elite of een grote pull. [G CWF-ENH; G IV-ENH-ROT]
7. Verder gewoon slaan. [G IV-ENH "Auto-attack until the enemy dies"]

Na het gevecht: Healing Wave (**C**). In nood tijdens het gevecht: Lesser Healing Wave (**F2**, vanaf 20). [G IV-ENH]

### 6.3 Per 10 levels

- **10**: Rockbiter Weapon (blok D, 1), Lightning Bolt (**1**), Earth Shock (**E**, 4), Lightning Shield (**Shift-Z**, 8), Flame Shock (**2**, 10), Searing Totem (**5**, 10), Strength of Earth Totem (**Shift-X**, 10), Flametongue Weapon (blok D, 10). [G TD r.989, 990, 995, 998, 1000, 999]
  Talenten vanaf 10: Thundering Strikes e.a. (passief). Mental Dexterity (passief) vanaf 15. [A uit 2.3]
  Daarna: Fire Nova (**Shift-4**) op 12. [G TD r.1002]
- **20**: Ghost Wolf (**R**), Frost Shock (**4**), Lesser Healing Wave (**F2**), Call of the Elements (**Ctrl-1**). [G TD r.1019, 1017, 1020, 1016] Shamanistic Focus (talent, passief, 20): Shocks en Lightning Shield kosten 45% minder mana. [G DB2; A level]
  Daarna: **Stormstrike (3, talent) op 25**. Flurry (passief, 25+). Improved Ghost Wolf (talent, 25+): Ghost Wolf direct en ook binnen. Magma Totem (blok D) op 26. [A; G TD r.1040]
- **30**: Windfury Weapon (blok D). [G TD r.1056] Improved Stormstrike en Spirit Weapons (talenten, 30 op zijn vroegst). [A] Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**). [G TD r.1051, 1050]
  Daarna: Windfury Totem op 32 (geen toets: totem-balk), Chain Lightning (**Shift-1**) op 32, Maelstrom Weapon (talent, passief, 35). [G TD r.1063, 1057; A]
- **40**: Rage of the Farseer (**Q**, talent): 30% sneller slaan, 25 sec, cooldown 3 min. [G DB2, zie 2.3] Call of the Spirits (**Ctrl-3**). Mail-armor. Sterkere Windfury Weapon. [G TD r.1083, 1090, 1092]
  Daarna: Grace of Air Totem op 42 (geen toets: totem-balk). [G TD r.1095]
- **50**: sterkere rangen: Windfury Weapon (50), Rockbiter Weapon (44, 54), Earth Shock (48), Lightning Bolt (50, 56), Strength of Earth Totem (52). Niets nieuws. [G TD r.1121, 1100, 1129, 1110, 1118, 1135, 1125]
- **60**: sterkere rangen: Windfury Weapon, Earth Shock. Niets nieuws. [G TD r.1153, 1147]

⚠️ "40 is geen regel" voor Rage of the Farseer: Icy Veins (13 nov) neemt na de hotfix maar 1 punt Maelstrom Weapon en gaat eerst naar Restoration voor mana (Mindfulness op 38, Water Shield op 46). mobalytics neemt Rage of the Farseer pas op 51. wowforeverinfo, classicwowforever en leprestore nemen hem op 40. [G IV-ENH; G mobalytics (Exa-fragment, bijgewerkt 13 nov); G WFI; G CWF-ENH]
⚠️ Improved Ghost Wolf: 25 op zijn vroegst, maar de gidsen nemen hem op heel verschillende levels (26-27, 31-32, 42-43). [G WFI, leprestore, CWF-ENH]
Stormstrike heeft geen sterkere rangen bij de trainer. [G TD: geen Stormstrike-rij; positieve controle: Riptide en Mana Tide Totem staan er wél met rangen]

### 6.4 Beginner mistakes (kandidaten, elk met bewijs)

- **Lightning Bolt casten met minder dan 5 stapels.** Icy Veins: "not below 5 as this resets the swing timer". [G IV-ENH-ROT] Maelstrom Weapon werkt alleen op Lightning Bolt, niet op heals of Chain Lightning. [G DB2 Spell 408498 "your next Lightning Bolt spell"]
- **De verkeerde weapon buff in een groep, als je Spirit Weapons hebt.** Met Rockbiter Weapon maak je 30% meer threat, zonder 30% minder. Als damage-dealer in een groep dus géén Rockbiter. [G DB2 Spell 16268; G CWF-ENH "Flametongue or Windfury is the safe imbue in a group"]
- **Earth Shock blijven drukken als vijanden naar jou komen.** "Causes a high amount of threat." Icy Veins: "Switch to Frost Shock over Earth Shock if threat is an issue". [G DB2 Spell 8042; G IV-ENH]
- **Alles op mana spelen.** Stop met casten als je mana laag is; je klappen kosten niets. [G IV-ENH]
- **Een taunt zoeken.** De Shaman heeft er geen. Stoneclaw Totem (**F**) laat vijanden de totem aanvallen, niet jou. [G DB2 Spell 5730; G WFDB "no taunt beyond Stoneclaw Totem"; G TD: geen taunt in de trainerlijst]
- **Toets 3 leeg vóór 25.** Stormstrike is een talent. [A uit 2.3; G BLK]
- **Windfury Weapon op een vaste toets zoeken.** Hij staat op blok D. [G BLK r.57]

### 6.5 Kan Enhancement tanken? (gemeten, niet aangenomen)

**Antwoord: ja, als noodtank in een kleine groep (dungeon). Het is geen echte tankrol.** [A uit de punten hieronder]

Wat Blizzard zegt:
- "Spirit Weapons: (Formerly Parry.) This 21-point talent now also reduces threat while you are not using Rockbiter Weapon, and increases threat while you are using Rockbiter Weapon. This talent will help Enhancement Shaman manage their threat now that their damage is competitive, while also retaining their unique ability to generate high threat and serve as a temporary tank in small group gameplay." [G BLIZ-DD, 7 okt 2026]
- Improved Stormstrike: "…more active Stormstrike usage when serving as a temporary tank." [G BLIZ-DD]
- "They are among the sturdiest of classes, with the use of Mail armor and a Shield." [G BLIZ-DD]

Wat de spel-data zegt (build 70938):
- Spirit Weapons: kans op parry; -30% threat zonder Rockbiter Weapon, +30% met. Rij 5 → 30 op zijn vroegst. [G DB2 Spell/SpellEffect 16268; A level]
- Rockbiter Weapon: "…allowing melee attacks to cause additional threat". [G DB2 Spell 8017]
- Earth Shock: "Causes a high amount of threat." [G DB2 Spell 8042]
- Stoneclaw Totem: "taunts creatures … to attack it" (de totem, niet jou); cooldown 30 sec. [G DB2 Spell 5730, SpellCooldowns 53689]
- Anticipation (dodge), Toughness (Stamina), Improved Stormstrike (dodge/parry reset Stormstrike). [G DB2 Spell 16254, 16252, 1223031]
- Een Shaman mag vanaf level 1 een schild dragen (skill 433, ClassMask 67) en vanaf 40 mail (skill 413, MinLevel 40). [G DB2 SkillRaceClassInfo ID 246, ID 145]
- Er staat geen taunt en geen verdedigings-cooldown in de trainerlijst of de boom. [G TD r.989-1153; G 2.2-2.4]

Wat de gidsen zeggen:
- wowfdb: "No tank spec at launch, and no taunt beyond Stoneclaw Totem." [G WFDB]
- classicwowforever (16 nov): "Blizzard pitches this as a stand-in tank for small groups; we haven't tested it in the 40 to 60 dungeons." [G CWF-ENH]
- conquestcapped (23 okt, uit de beta tot level 30): kan in dungeons; "There is no tank spec and no taunt", geen verdedigings-cooldown; tank met een eenhandig wapen en een schild; "Skip Stoneclaw Totem". Niet als hoofdtank in raids. [G CC-TANK]
- realmfirst (10 nov): "Not as a dedicated role"; de echte tanks zijn Warrior Protection, Paladin Protection en Feral Druid. [G realmfirst, Exa-fragment]

Keuze voor Rob / de bouwchat (niet door mij beslist):
- **Optie A**: één zin in de Enhancement-tekst ("kan in een dungeon even tank zijn: Rockbiter Weapon aan").
- **Optie B**: een vierde entry, `band = 2`, title `Enhancement: tank in a small group`, zoals de Druid twee entries met band 2 heeft.

Volgorde als noodtank (alleen uit de beta-gids CC-TANK plus de client-teksten; niet getest op 40-60):
Rockbiter Weapon aan (blok D) → Lightning Shield (**Shift-Z**) → totems neer → pull met Lightning Bolt (**1**) → Earth Shock (**E**) → Stormstrike (**3**) → Fire Nova (**Shift-4**) bij een groep. Geen taunt: loopt een vijand weg, dan Earth Shock erop.
Fout die erbij hoort: tanken zonder Rockbiter Weapon (dan 30% mínder threat). [G DB2 Spell 16268; G CC-TANK]

## 7. Rol: Restoration

- **band** = 3 [G, zie 1]
- **Voorgestelde title**: `Restoration: healer`

### 7.1 Intro-feiten

- Vanaf level 1: Healing Wave is een startspreuk. [G DB2 SpellLevels 331 = 1; G HTP r.292]
- Lesser Healing Wave op 20, Chain Heal op 40. Riptide is het laatste talent: 40 op zijn vroegst. [G TD r.1020, 1084; A uit 2.4]
- Gidsen: niet aangeraden om alleen mee te levelen; goed in een groep. Icy Veins: "it is not recommended to solo level as Restoration, but it is a good specialization to use while in a group or as an off-spec for dungeon clearing." [G IV-RES] warcraftmaps: "Restoration is slow when you play alone." [G WM-RES]
- Tussen dungeons door quest je met Lightning Bolt en Flame Shock. [G CWF-RES]
- Healing Wave is je hoofd-heal tijdens het levelen. [G IV-RES]
- Dual specialization gaat open op level 40. [G BLIZ-DD]
- Een Shaman kan Poison en Disease weghalen (Cure Poison 16, Cure Disease 22), geen curses en geen magie bij vrienden. [G TD r.1008, 1024: geen andere genees-spreuk in de lijst; G WFDB "No curse removal, no friendly magic dispel"]
- Ancestral Spirit (F3): "Cannot be cast when in combat." [G DB2 Spell 2008]
- Shamans kunnen geen wand gebruiken (skill 228 geldt alleen voor Priest, Mage, Warlock). [G DB2 SkillRaceClassInfo ID 144, ClassMask 400]

### 7.2 Simple order (in een groep, met toetsen)

Bronnen: Icy Veins Restoration leveling (4 nov), Wowhead Restoration rotation (Woah), classicwowforever Restoration (11 nov), warcraftmaps (16 nov).

Vooraf: Water Shield (**Shift-Z**, vanaf 20). Totems neer: Call of the Elements (**Ctrl-1**, vanaf 20) of Healing Stream Totem (**F4**, vanaf 20). [G IV-RES; G CWF-RES]

1. Riptide (**Shift-F1**, vanaf 40) op de tank of op wie damage krijgt. [G IV-RES; G WH-RES; G CWF-RES]
2. Chain Heal (**Shift-2**, vanaf 40) op datzelfde doel als meer mensen gewond zijn. [G IV-RES; G WH-RES; G DB2 Spell 408521]
3. Healing Wave (**C**) voor één persoon of de tank. [G IV-RES; G CWF-RES]
4. Lesser Healing Wave (**F2**, vanaf 20) als het snel moet. [G CWF-RES; G WM-RES]
5. Nood: Nature's Swiftness (**Shift-3**, vanaf 30), dan Healing Wave (**C**). [G CWF-RES; G WM-RES; G DB2 Spell 16188]
6. Mana Tide Totem (**F1**, vanaf 25) als de mana opraakt. [G CWF-RES "on long fights"; G WM-RES "around half mana"]
7. Niemand gewond: Lightning Bolt (**1**). [G IV-RES]

### 7.3 Per 10 levels

- **10**: Healing Wave (**C**, 1). [G HTP r.292] Talenten vanaf 10: Improved Healing Wave (snellere Healing Wave), Tidal Focus (passief). [A uit 2.4]
  Daarna: Ancestral Spirit (**F3**, buiten een gevecht) op 12, Cure Poison (**Shift-C**) op 16, Tremor Totem (**Shift-F**) op 18. [G TD r.1001, 1008, 1015]
- **20**: Lesser Healing Wave (**F2**), Healing Stream Totem (**F4**, quest), Call of the Elements (**Ctrl-1**), Ghost Wolf (**R**). [G TD r.1020, 1016, 1019; DB2 SpellLevels 5394] **Water Shield (Shift-Z, talent, 20 op zijn vroegst)**. [A]
  Daarna: Cure Disease (**Shift-V**) op 22, **Mana Tide Totem (F1, talent) op 25**, Mana Spring Totem op 26 (geen toets: totem-balk). [G TD r.1024, 1041; A]
- **30**: **Nature's Swiftness (Shift-3, talent, 30 op zijn vroegst)**. Healing Way (passief, 30+). Grounding Totem (**X**), Call of the Ancestors (**Ctrl-2**), Reincarnation (passief). [A; G TD r.1051, 1050, 1054]
  Daarna: Purification (passief, 35), sterkere Mana Tide Totem op 38. [A; G TD r.1080]
- **40**: Chain Heal (**Shift-2**), **Riptide (Shift-F1, talent, 40 op zijn vroegst)**, Call of the Spirits (**Ctrl-3**), mail-armor. [G TD r.1084, 1083, 1090; A]
- **50**: sterkere rangen: Riptide (50), Chain Heal (46, 54), Healing Wave (48, 56), Lesser Healing Wave (44, 52), Mana Tide Totem (48, 58), Healing Stream Totem (50). Niets nieuws. [G TD r.1119, 1102, 1127, 1113, 1134, 1097, 1124, 1115, 1144, 1117]
- **60**: sterkere rangen: Riptide, Lesser Healing Wave, Healing Stream Totem, Ancestral Spirit. Niets nieuws. [G TD r.1151, 1149, 1148, 1146]

### 7.4 Beginner mistakes (kandidaten, elk met bewijs)

- **Chain Heal op iemand anders dan je Riptide-doel.** De bonus geldt alleen voor Chain Heal die je direct op dat doel cast. [G DB2 Spell 408521 "casts directly on that target"; G WM-RES]
- **Denken dat Riptide meteen heelt.** Hij heelt over 15 sec, niet in één keer. [G DB2 Spell 408521; G CWF-RES "Since 2 November it has no direct heal"]
- **Alleen Nature's Swiftness drukken.** Hij heelt zelf niets: hij maakt je vólgende Nature-spell direct. Druk daarna Healing Wave. Cooldown 3 min, dus bewaar hem voor nood. [G DB2 Spell 16188, SpellCooldowns 55054]
- **Water Shield laten aflopen.** Duurt 10 min, 3 bollen. [G DB2; G WM-RES]
- **Mana Tide Totem neerzetten en je andere Water-totem kwijt zijn.** Eén totem per element; Mana Tide vraagt ook het Water Totem-item. [A uit HTP r.284 + G DB2 SpellTotems 12791]
- **Mana Spring Totem op een toets zoeken.** Hij staat niet op het blok; zet hem op de totem-balk. [G BLK r.61]
- **Een curse willen weghalen.** Kan een Shaman niet; alleen Poison (Shift-C) en Disease (Shift-V). [G TD; G WFDB]
- **Alleen levelen als healer.** Vijanden gaan traag dood; de gidsen raden het af. [G IV-RES; G WM-RES]

## 8. Wat alle rollen delen (handig voor de schrijver)

- Shocks: Earth Shock (E, 4, interrupt + veel threat), Flame Shock (2, 10, damage over 12 sec), Frost Shock (4, 20, vertraagt 8 sec). Eén gedeelde cooldown van 6 sec. [G DB2 Spell 8042/8050/8056, SpellDuration 29, 31]
- Ghost Wolf (R, 20): cast 3 sec, alleen buiten. [G DB2 Spell 2645, SpellCastTimes 14]
- Lightning Shield (Shift-Z, 8): 3 ballen, 10 min. [G DB2 SpellAuraOptions 116231, SpellDuration 6]
- Reincarnation (30, passief): cooldown 60 min. [G TD r.1054; DB2 SpellCooldowns 55435] Icy Veins: vraagt een Ankh, je staat op met 20% health en mana. [G IV-ENH] Ankh niet in DB2 nagemeten.
- Mail-armor: level 40, bij de trainer. [G TD r.1090; G DB2 SkillRaceClassInfo ID 145]

## 9. Gidsen oneens (en gids tegen spel-data)

### 9.1 🔴 Hotfix van 10 nov tegen de spelbestanden

Blizzard, hotfixes 10 nov 2026 (voor de Shaman pas live op 12 nov, 10:45 PST): [G BLIZ-HF; G wow-forever.gg 12 nov]
- Stormstrike: **100%** weapon damage (was 150%), cooldown **8 sec** (was 6).
- Mental Dexterity: 33/66/100% van Intellect als Attack Power (was 50/100/150%).
- Maelstrom Weapon: 20% per stapel op elke rang (was 4/8/12/16/20%); de rang bepaalt hoe vaak hij afgaat (6-10 keer per minuut).
- Weapon buffs en weapon-totems werken nu samen (Windfury Weapon + Windfury Totem).

De spelbestanden van build 70938 hebben nog de oude waarden: Stormstrike 150 en 6000 ms; de tekst van Windfury Weapon zegt nog "disables any benefit you personally receive from Windfury Totem". [G DB2 SpellEffect 1368308, SpellCooldowns 55241, Spell 8232]
classicwowforever (16 nov): "The talent tooltips for Stormstrike, Mental Dexterity and Maelstrom Weapon still show their numbers from before 10 November, because the game files don't have the change yet." [G CWF-ENH]
Wie wat zegt: Icy Veins rotation (13 nov), classicwowforever, warcraftmaps, foreversixty: 8 sec / 100%. leprestore en wowforeverinfo (data 5 nov): 6 sec / 150%. [G]
**Advies**: noem geen getal voor Stormstrike-damage, Mental Dexterity of de Maelstrom-kans. Heb je de cooldown nodig: 8 sec volgens Blizzard, maar de tooltip in het spel kan nog 6 tonen. Rob kan het in het spel timen.

### 9.2 Overige verschillen

- **Rage of the Farseer: alleen slaan, of ook casten?** Client-tekst: "Increases your attack speed". [G DB2 Spell 425336] Blizzard: "increases your attack speed by 30%". [G BLIZ-DD] wowfdb en leprestore: niet voor spells. Method en foreverguide.app: ook cast speed. [G, Exa-fragmenten] → Schrijf: sneller slaan.
- **Riptide**: warcraftmaps (build 70685) zegt "instant heal … 6 second cooldown". Build 70938: alleen heal over tijd, 12 sec. [G WM-RES; G DB2] → 70938 volgen.
- **Polestar** (gecontroleerd op build 70450; de plannen staan "paused"): noemt Lava Burst (30) en Elemental Mastery (40), Improved Ghost Wolf op 18-19 en Stormstrike op 30. Dat is een oudere boom. [G PS] → Niet volgen.
- **Wanneer Chain Heal**: classicwowforever "when three people are hurt"; warcraftmaps "two or more". [G] → Schrijf "meer mensen".
- **Welke Shock voor Enhancement**: Icy Veins leveling: meestal Earth Shock. Wowhead en Icy Veins rotation (level 60): eerst Flame Shock erop houden, dan Earth Shock. [G IV-ENH, WH-ENH, IV-ENH-ROT]
- **Enhancement-talenten rond 35-50**: zie de ⚠️ onder 6.3.
- **Method**: noemt Earth Shock een "taunt". [G, Exa-fragment] De client zegt "high amount of threat"; een taunt is het niet. [G DB2]
- **Windfury Totem + eigen Windfury Weapon**: zie 9.1.
- **Dwarf en de Air Totem**: wowfdb zegt dat de Dwarf-quest voor de Air Totem nog niet in de spel-data staat; Polestar noemt wél "Call of Air and the Tempest's Weapons (Alliance)". [G WFDB, PS] Niet gemeten.

## 10. Niet noemen (oude of verdwenen namen)

De 50 talenten in 2.2-2.4 zijn de hele boom van build 70938. Wat daar niet in staat, bestaat niet als talent.

- **Lava Burst**: weg sinds Blizzards notes van 2 nov; Call of Thunder staat op die plek. [G WFDB; G CWF-ELE; G 2.2]
- **Elemental Mastery**: spell 16166 heet nu Lightning Mastery. [G DB2 SpellName 16166]
- **Totemic Projection**: spell 437009 heet nu Totemic Call. [G DB2 SpellName; G TD r.1027] (Icy Veins gebruikt de oude naam nog in één kopje.)
- **Parry** als talent: heet nu Spirit Weapons. [G DB2 SpellName 16268; G BLIZ-DD]
- **Two-Handed Axes and Maces**, **Shield Specialization**, **Enhancing Totems**, **Weapon Mastery**, **Improved Weapon Totems**, **Totemic Mastery**, **Nature's Guidance**: staan nog in de oude `Talent`-tabel (classic), niet in de Forever-boom. [G DB2 Talent ID 617, 612, 610, 1643, 1647, 582, 583 + SpellName, tegen 2.2-2.4]
- **Bloodlust / Heroism**: niet voor de Shaman; Rage of the Farseer is er volgens Blizzard op geïnspireerd, maar alleen voor jezelf. [G BLIZ-DD]
- **Tranquil Air Totem**: volgens wowfdb uit de client. [G WFDB] Niet zelf gemeten; staat niet in de trainerlijst. [G TD]
- De oude classic `Talent`-tabel zit nog in de build (Stormstrike op rij 7 enz.). Die niet gebruiken. [G DB2 Talent ID 901]

## 11. Niet gemeten

- Of de talent-levels (10 + punten) in het spel precies zo uitkomen. De som is [A]; Icy Veins bevestigt 25 voor Stormstrike.
- De echte tooltips ná de hotfix (zie 9.1). De voordeur en het spel zijn niet gebruikt.
- Of de Group Finder een Shaman als tank laat aanmelden.
- Hoe Enhancement-tanken gaat in dungeons van 40-60 (geen bron heeft het getest).
- Dual wield: gidsen zeggen dat de Forever-Shaman het niet heeft (foreversixty: "No dual wield"). `SkillRaceClassInfo` heeft wel een rij Dual Wield voor ClassMask 64 (ID 2455). Dat bewijst niets over leren. Niet noemen.
- Waar en wanneer je two-handed axes/maces leert (Icy Veins: weapon trainer Orgrimmar of Ironforge; niet in de client gemeten).
- Mana-kosten (Totemic Call, Chain Lightning, Stormstrike): alleen uit gidsen.
- Getallen van talenten met meer rangen (zie 2.5).
- De totem-quests zelf (NPC's, plekken, de Dwarf-Air-quest): niet opnieuw gemeten; levels uit HTP r.285 en de gidsen.
- De Ankh voor Reincarnation: alleen uit Icy Veins.
- Wowhead: de gidspagina's zelf gaven een lege pagina bij ophalen. Alleen het fragment van de rotation-pagina's (Enhancement, Restoration) is gezien. De Wowhead Elemental-pagina is niet gezien.
- De map `docs/` is niet gelezen (regel van deze helper). Een eerder Shaman-onderzoek in `docs/forever/` is dus niet vergeleken.

## 12. Bronnen (alle gezien op 17 nov 2026)

Lokaal:
- **DB2** = `C:\Users\RobHu\AppData\Local\MidnightHelper\gamedata_cache\db2\1.60.1.70938\<Tabel>.enUS.csv` (TraitTree, TraitNode, TraitNodeXTraitNodeEntry, TraitNodeEntry, TraitDefinition, TraitCond, TraitNodeGroupXTraitNode, TraitNodeGroupXTraitCond, TraitEdge, TraitCurrencySource, TalentTab, Talent, SpellName, Spell, SpellEffect, SpellCooldowns, SpellMisc, SpellDuration, SpellCastTimes, SpellAuraOptions, SpellLevels, SpellTotems, TotemCategory, SkillRaceClassInfo). Getallen achter een tabelnaam zijn rij-ID's of spell-ID's.
- **TD** = `Modules/ForeverTrainerData.lua` r.988-1154.
- **BLK** = `Modules/ForeverBlock_Shaman.lua`.
- **HTP** = `Modules/ForeverHowToPlay.lua` r.279-319 (`CLASSES.SHAMAN`).
- **MAC** = `Modules/ForeverMacros.lua` (r.470-494 `SPEC_MACROS`, r.635-643, r.673-705).
- `Modules/ForeverDirection.lua` r.145-184; `Locales/enUS.lua` r.5090-5092.

Controle van `SPEC_MACROS` tegen de boom: Lightning Mastery 40, Stormstrike 25, Rage of the Farseer 40, Nature's Swiftness 30, Riptide 40 kloppen met 2.2-2.4. `boltchain` level 1, `earthbind` level 6 en `shockswing` level 10 zijn het level van de macro; Chain Lightning zelf komt op 32 en Frost Shock op 20. [G MAC r.471-493; G TD]

Internet (via Exa):
- **BLIZ-DD** = Blizzard News, 7 okt 2026, "Class Deep Dives — Mage and Shaman": https://news.blizzard.com/en-us/article/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman
- **BLIZ-HF** = Blizzard-hotfixes 10 nov 2026, overgenomen door Wowhead News (11 nov): https://www.wowhead.com/forever/news/hunter-pet-nerf-and-enhancement-shaman-changes-wow-forever-hotfixes-for-november-383837 — live-datum: https://wow-forever.gg/news/2026-11-12-enhancement-shaman-hotfix-november-10/
- **IV-ENH** = Icy Veins, Enhancement leveling, bijgewerkt 13 nov: https://www.icy-veins.com/wow-forever/enhancement-shaman-leveling
- **IV-ENH-ROT** = Icy Veins, Enhancement rotation, bijgewerkt 13 nov: https://www.icy-veins.com/wow-forever/enhancement-shaman-melee-dps-pve-rotation-cooldowns-abilities
- **IV-ELE** = Icy Veins, Elemental leveling, bijgewerkt 4 nov: https://www.icy-veins.com/wow-forever/elemental-shaman-leveling
- **IV-RES** = Icy Veins, Restoration leveling, bijgewerkt 4 nov: https://www.icy-veins.com/wow-forever/restoration-shaman-leveling
- **WH-ENH** = Wowhead Forever, Enhancement rotation (Yebb, 29 okt): https://www.wowhead.com/forever/guide/classes/shaman/enhancement/rotation-cooldowns-pve-dps
- **WH-RES** = Wowhead Forever, Restoration rotation (Woah, datum niet gezien): https://www.wowhead.com/forever/guide/classes/shaman/restoration/rotation-cooldowns-pve-healer
- **CWF-ENH / -ELE / -RES** = classicwowforever.com (Garazon; 16 nov / 11 nov / 11 nov; spell-build 70862): https://classicwowforever.com/class-guides/shaman/enhancement/ , …/elemental/ , …/restoration/
- **PS** = Polestar: https://polestar.guide/guides/class/shaman (build 70450) en https://polestar.guide/docs/players/talent-plans
- **WFDB** = https://wowfdb.com/classes/shaman/ (datum niet gezien; noemt build 70938 en de hotfix van 10 nov)
- **WFI** = https://wowforeverinfo.com/guides/shaman-leveling/ (22 okt; talent-data 5 nov)
- **CC-TANK** = https://conquestcapped.com/guides/wow-forever/wow-forever-shaman-tank/ (23 okt; beta-build 15 okt)
- **WM-RES / WM-ENH** = https://warcraftmaps.com/classes/shaman/restoration/rotation , …/enhancement/rotation (16-17 nov; build 70685)
- Alleen als fragment gezien: realmfirst.net (10 nov), mobalytics.gg (13 nov), leprestore.com, foreversixty.gg, method.gg, foreverguide.app, nossuary.com.
