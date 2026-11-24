# Consumables in WoW Forever — gemeten id's voor het party-bord (24 nov 2026)

Bron, tenzij anders gezegd: **wago DB2, game `wowf`, build 1.60.1.71037** (20 nov 2026), via `tools/gamedata.py`
(tabellen Item, ItemSparse, ItemXItemEffect, ItemEffect, SpellEffect, SpellMisc, SpellDuration, SpellName, Spell,
SpellCategory, GlobalStrings, SkillLineAbility, Talent). Tooltip-teksten: **Wowhead Forever tooltip-JSON**
(`nether.wowhead.com/forever/tooltip`), opgehaald 24 nov 2026.

- **GEMETEN** = zo in die bron gezien. **AFGELEID** = mijn redenering op gemeten data.
- Keten per item (GEMETEN): `ItemXItemEffect.ItemID` → `ItemEffect.SpellID` (TriggerType 0 = bij gebruik).
- Aura-id = gebruiks-spell zelf (GEMETEN): bij alle elixers en flasks hieronder is die spell `Effect 6`
  (APPLY_AURA) op jezelf (`ImplicitTarget 1`). Bij eten zit de buff één stap verder: de "Food"-spell triggert na
  10 s (`EffectAuraPeriod 10000`, aura 23/226/227) de buff-spell (`EffectTriggerSpell`).
- Volgorde "beste eerst" is **AFGELEID** (RequiredLevel, dan sterkte, dan duur). Wat "beste" is hangt van class
  en zone af; het bord kan beter "heeft iets" tonen dan "heeft het beste".

---

## 1. Elixers en flasks

### Flasks (2 uur, blijven na dood) — GEMETEN

| Item | Naam | Req | Aura | Effect (tooltip / DB2) |
|---|---|---|---|---|
| 13510 | Flask of the Titans | 50 | 17626 | +1200 max HP |
| 13512 | Flask of Supreme Power | 50 | 17628 | +150 spell damage |
| 13511 | Flask of Distilled Wisdom | 50 | 17627 | +2000 max mana |
| 13513 | Flask of Chromatic Resistance | 50 | 17629 | +25 alle resistances |
| 274273 | Flask of Natural Accuracy | 55 | 1293740 | +30 Sta; in Hyjal/Hyjal Summit/Barrow Deeps +2% hit |
| 274274 | Flask of Natural Aggression | 55 | 1293741 | idem, +2% crit |
| 274275 | Flask of Natural Precision | 55 | 1293742 | idem, 2% minder dodge/parry |
| 274276 | Flask of Natural Swiftness | 55 | 1293743 | idem, +2% haste |

- Duur: `SpellMisc.DurationIndex 367` = 7 200 000 ms (GEMETEN). Tooltip: *"You can only have the effect of one
  flask at a time. This effect persists through death."* (GEMETEN).
- ⚠️ **Naamfout in Blizzards data** (GEMETEN): spell **1293743** (van Natural *Swiftness*) heet in SpellName én in de
  Wowhead-spelltooltip **"Flask of Natural Accuracy"**, net als 1293740. Op naam zijn die twee niet te scheiden: check
  op **id**.
- Niet op het bord: 13506 Flask of Petrification (aura 17624, 1 minuut, geen buff).

### Elixers voor een gevecht — GEMETEN (item, Req, aura, duur)

Duur uit `SpellMisc.DurationIndex`: 42 = 1 u, 30 = 30 min, 40 = 20 min (GEMETEN via SpellDuration).

| Item | Naam | Req | Aura | Duur | Wat (DB2-effect / tooltip) |
|---|---|---|---|---|---|
| 250328 | Elixir of Cunning | 55 | 1250918 | 30m | +25 Agi, +25 Int |
| 250329 | Elixir of the Phalanx | 55 | 1250920 | 30m | +400 HP, +500 armor |
| 250333 | Greater Cleric's Elixir | 55 | 1250926 | 30m | +40 healing |
| 250335 | Elixir of Greater Fortitude | 55 | 1250931 | 30m | +400 HP |
| 250336 | Elixir of Wicked Regeneration | 55 | 1250932 | 30m | 9 hp + 10 mana per 5 s |
| 250337 | Elixir of the Owl | 55 | 1250940 | 30m | +25 Int, +2% crit |
| 250338 | Elixir of Sages | 55 | 1250941 | 30m | +25 Spi, +2% crit |
| 250341 | Greater Mageblood Elixir | 55 | 1250948 | 30m | +20 mp5 |
| 250343 | Elixir of Nature Power | 55 | 1250972 | 30m | +40 nature damage |
| 250347 | Elixir of Greater Spirit | 55 | 1250979 | 30m | +18 Spi |
| 250348 | Elixir of the Whale | 55 | 1250981 | 30m | +25 Spi, +2% crit |
| 250350 | Elixir of Ferocity | 55 | 1250985 | 30m | +18 Str, +18 Agi |
| 250351 | Elixir of the Grizzly | 55 | 1250986 | 30m | +25 Str, +2% crit |
| 20004 | Major Troll's Blood Elixir | 53 | 24361 | 1u | +20 hp5 |
| 9206 | Elixir of Greater Strength | 48 | 11405 | 1u | +25 Str |
| 13454 | Greater Arcane Elixir | 47 | 17539 | 1u | +35 spell damage |
| 13452 | Elixir of the Mongoose | 46 | 17538 | 30m | +25 Agi, +2% crit |
| 13453 | Elixir of Brute Force | 45 | 17537 | 1u | +18 Str, +18 Sta |
| 250332 | Cleric's Elixir | 45 | 1250925 | 30m | +30 healing |
| 250334 | Elixir of Fortitude | 45 | 1250928 | 30m | +200 HP |
| 250346 | Elixir of Spirit | 45 | 1250978 | 30m | +10 Spi |
| 250349 | Elixir of Strength | 45 | 1250984 | 30m | +10 Str |
| 250354 | Elixir of Intellect | 45 | 1250989 | 30m | +10 Int |
| 12820 | Winterfall Firewater | 45 | 17038 | 20m | +35 melee AP, groter |
| 246948 | Distilled Firewater | 45 | 17038 | 20m | zelfde spell als 12820 |
| 13445 | Elixir of Greater Defense | 43 | 11348 | 1u | +450 armor |
| 20007 | Mageblood Elixir | 40 | 24363 | 1u | +12 mp5 |
| 9264 | Elixir of Shadow Power | 40 | 11474 | 30m | +40 shadow damage |
| 21546 | Elixir of Holy Power | 40 | 1310077 | 30m | +40 holy damage |
| 9187 | Elixir of Greater Agility | 38 | 11334 | 1u | +25 Agi |
| 13447 | Elixir of the Sages | 38 | 17535 | 1u | +18 Int, +18 Spi |
| 9088 | Gift of Arthas | 38 | 11371 | 30m | +10 shadow res + proc |
| 9179 | Elixir of Greater Intellect | 37 | 11396 | 1u | +25 Int |
| 9155 | Arcane Elixir | 37 | 11390 | 30m | +20 spell damage |
| 8951 | Elixir of Defense | 29 | 11349 | 1u | +250 armor |
| 17708 | Elixir of Frost Power | 28 | 21920 | 30m | +15 frost damage |
| 217398 | Lesser Arcane Elixir | 28 | 439959 | 30m | +14 spell damage |
| 8949 | Elixir of Agility | 27 | 11328 | 1u | +15 Agi |
| 3826 | Troll's Blood Elixir | 26 | 3223 | 1u | +12 hp5 |
| 3825 | Elixir of Lesser Fortitude | 25 | 3593 | 1u | +120 HP |
| 250331 | Lesser Cleric's Elixir | 25 | 1250924 | 30m | +20 healing |
| 250340 | Lesser Mageblood Elixir | 25 | 1250944 | 30m | +6 mp5 |
| 250342 | Lesser Arcane Elixir | 25 | 1250971 | 30m | +15 spell damage |
| 250345 | Elixir of Lesser Spirit | 25 | 1250976 | 30m | +6 Spi |
| 250353 | Elixir of Lesser Intellect | 25 | 1250988 | 30m | +6 Int |
| 3391 | Elixir of Ogre Strength | 20 | 3164 | 1u | +8 Str |
| 3390 | Elixir of Lesser Agility | 18 | 3160 | 1u | +8 Agi |
| 6373 | Elixir of Fire Power | 18 | 7844 | 30m | +10 fire damage |
| 3389 | Elixir of Lesser Defense | 16 | 3220 | 1u | +150 armor |
| 3388 | Lesser Troll's Blood Elixir | 15 | 3222 | 1u | +6 hp5 |
| 3383 | Elixir of Wisdom | 10 | 3166 | 30m | +3 Int (DB2-basiswaarde) |
| 250330 | Minor Cleric's Elixir | 5 | 1250922 | 30m | +10 healing |
| 250339 | Minor Mageblood Elixir | 5 | 1250942 | 30m | +3 mp5 |
| 250344 | Elixir of Minor Spirit | 5 | 1250974 | 30m | +3 Spi |
| 2457 | Elixir of Minor Agility | 2 | 2374 | 1u | +4 Agi |
| 2458 | Elixir of Minor Fortitude | 2 | 2378 | 1u | +27 HP |
| 2454 | Elixir of Minor Strength | 1 | 2367 | 1u | +4 Str |
| 3382 | Minor Troll's Blood Elixir | 1 | 3219 | 1u | +2 hp5 |
| 5997 | Elixir of Minor Defense | 1 | 673 | 1u | +50 armor |
| 247754 | Minor Arcane Elixir | 1 | 1245244 | 30m | +5 spell damage |
| 247755 | Elixir of Minor Force | 1 | 1245249 | 30m | +1 physical damage |

**"Endless"-elixers** (GEMETEN in DB2 en tooltip; **herkomst onbekend** — Req 1, ilvl 30, verkoopprijs 1 koper,
stapelt tot 5×; of spelers ze kunnen krijgen heb ik niet kunnen meten):
289083 Endless Power (aura 1327737, +3% schade), 289086 Endless Rapidity (1327751, +4% haste), 289087 Endless
Opportunity (1327753, +4% crit), 289082 Endless Intellect (1327736, +2% Int), 289084 Endless Healing (1327738, +2%
healing), 289321 Endless Mana (1328032, +30% mana regen). Allemaal 1 uur.

**Niet op het bord** (wel subclass Elixir/Flask, maar hulpmiddel of kort; GEMETEN): 3828 Detect Lesser Invisibility,
5996 / 18294 Water Breathing, 8827 Water Walking, 9154 Detect Undead, 9233 Detect Demon, 9197 Dream Vision,
10592 Catseye Draught, 6662 Giant Growth (2 min), 8529 / 289081 Noggenfogger, 3386 Poison Cleansing, 9224 Potion of
Demon Slaying (5 min), 250327 Potion of Predatory Senses (90 s, potion-cooldown), 289329 Endless Growth, 289334
Endless Experience (+200% XP), 13506 Petrification. Plus 2460 en 250326: in de Item-tabel, maar zonder
ItemSparse-rij en Wowhead geeft 404 (niet te benoemen).

Telling (GEMETEN): Item-tabel ClassID 0 / SubclassID 2 (Elixir) of 3 (Flask) = **94** items = 8 flasks + 61
elixers + 6 Endless + 19 niet-bord.

### Kent Forever Battle/Guardian Elixir? — NIET TE METEN in de client-data

- GlobalStrings (27 403 rijen): **0** rijen met "Elixir"; controle "Potion" in dezelfde tabel: 10 rijen. GEMETEN.
- SpellCategory: enige elixer-categorie is **2593 "Item - Elixir / Flask"** (zoek "Guardian": 0; controle "Elixir": 1).
  Die hangt aan elke elixer/flask in ItemEffect met `CategoryCoolDownMSec 3000`: een gedeelde **3 s-cooldown**, geen
  stapelregel. GEMETEN.
- Spell.Description met "Elixir": 12 rijen, geen enkele zegt Battle of Guardian. GEMETEN.
- Wowhead-tooltips van ~20 elixers/flasks: niets over Battle/Guardian. Flasks zeggen wél "one flask at a time".
  GEMETEN.
- **Conclusie (AFGELEID):** Battle/Guardian staat niet in de client-data. Welke elixers samen mogen staan bepaalt de
  server; dat kan ik hier niet meten. Alleen "max. één flask" staat er letterlijk. Wil je het zeker weten: in-game
  twee elixers drinken (bv. Mongoose + Greater Arcane) en kijken of de eerste verdwijnt.
- Extra (GEMETEN): spell **1225504** bestaat: *"Increases the duration of beneficial effects from elixirs and flasks
  by $s1%."* Waar die vandaan komt (beroep? talent?) heb ik niet gemeten. Gevolg (AFGELEID): een aura kan langer
  duren dan de DB2-duur hierboven.

---

## 2. Eten — Well Fed

### Alle "Well Fed"-aura's in Forever (SpellName, naam precies "Well Fed": 30 stuks) — GEMETEN

| Aura | Wat | Duur | Wie geeft hem (keten GEMETEN) |
|---|---|---|---|
| 1248406 | Stamina (waarde uit het eten) | 15m | 20 items, o.a. Savory Turtle Stew, Monster Omelet |
| 1248420 | Agility | 15m | 15 items, o.a. Flank au Poivre, Tender Wolf Steak |
| 1248421 | Intellect | 15m | 17 items, o.a. Soaring Pamplona, Runn Tum Tuber Surprise |
| 1248422 | Strength | 15m | 15 items, o.a. Smoked Desert Dumplings |
| 1249519 | Attack Power (+ranged AP) | 15m | 7 vissen, o.a. Mightfish Steak (40) |
| 1249520 | Spell damage | 15m | 8 items, o.a. Lobster Stew, Nightfin Soup |
| 1249523 | +1% crit | 15m | Grilled Squid, Hot Smoked Bass |
| 1249926 | Spirit | 15m | 6 Smoothies |
| 1249927 | Healing | 15m | 6 Teas (Sage's Tea 44) |
| 1225778 | +25 Str, +10 Sta | 15m | 238637 Prowler Steak |
| 1225779 | +25 Agi, +10 Sta | 15m | 238638 Filet o' Flank |
| 1225780 | +25 SpD, +55 heal, +10 Sta | 15m | 238639 Sunrise Omelette |
| 1319310 | +150 armor | 15m | 286152 Plated Armorfish |
| 19705 | +2 Sta, +2 Spi | 15m | snoep/feestdagen: 7806, 7807, 7808, 11584, 17197, 17198, 206177 |
| 19708 | +6 Sta, +6 Spi | 15m | 5527 Goblin Deviled Clams |
| 19710 | +12 Sta, +12 Spi | 15m | 16971 Clamlette Surprise |
| 24870 | Sta + Spi | 15m | 20516 Bobbing Apple, 21254 Winter Veil Cookie — **AFGELEID** (tooltip zegt "well fed"; DB2 legt geen link) |
| 1249521 | Fishing-skill (hulpmiddel) | 15m | 6 vissen, o.a. Rockscale Cod |
| 1249907 | Herbalism-skill (hulpmiddel) | 15m | 10841 Goldthorn Tea |
| 1248688 | +15% snelheid in Westfall (hulpmiddel) | 15m | 733 Westfall Stew |
| 1294007 | +15% snelheid in Hyjal (hulpmiddel) | 15m | 267341 Sweetpaw Jam |
| 19709 | +8 Sta, +8 Spi | 15m | alleen item 12211 — geen naam (geen ItemSparse, Wowhead 404) |
| 1302064 | stat (waarde 10) | 15m | alleen item 277313 — geen naam |
| 19706, 19711, 24799, 25694, 25941, 1225782 | oude/ongebruikte varianten | 15m | food-spell bestaat, **geen item** gevonden |
| 1283082 | dummy-aura | 15m | geen trigger, geen item gevonden |

- Duur `DurationIndex 347` = 900 000 ms (GEMETEN).
- **De sterkte zit in het eten, niet in de aura** (GEMETEN): de nieuwe aura's (1248406 enz.) hebben basiswaarde 1;
  de food-spell geeft de echte waarde mee (aura 227). Vijf tooltips bevestigen dat (Steaming Stag Steak 20 Str, Sage's
  Tea 44 healing, Rockscale Cod 12 Fishing, Plated Armorfish 150 armor, Grilled Squid 1% crit).
- Ook in de data: **1243969 "Well Fed XP Boost"** (+5% XP van kills, duur -1). Bijna elke Forever-eettooltip zegt
  *"Additionally, experience gained from kills is increased by 5%"* (GEMETEN). Dat 1243969 die extra is, is
  **AFGELEID** (geen trigger-link in DB2). Telt niet als buff voor het bord.

### Eten dat een buff geeft die NIET "Well Fed" heet — GEMETEN

| Item | Naam | Req | Aura | Naam aura | Wat | Duur |
|---|---|---|---|---|---|---|
| 21023 | Dirge's Kickin' Chimaerok Chops | 45 | 25661 | Increased Stamina | +25 Sta | 15m |
| 232436 | Darkclaw Bisque | 45 | 470361 | Increased Spell Damage | +12 SpD | 10m |
| 232438 | Smoked Redgill | 35 | 470367 | Increased Healing Power | +22 healing | 10m |
| 13810 | Blessed Sunfruit | 45 | 18125 | Blessed Sunfruit | +10 Str | 10m |
| 13813 | Blessed Sunfruit Juice | 45 | 18141 | Blessed Sunfruit Juice | +10 Spi | 10m |

(Ook spell 18192 "Increased Agility" bestaat als food-buff, maar geen item gebruikt hem — GEMETEN.)

Telling eten (GEMETEN): 124 item-koppelingen naar een Well Fed-food-spell; 5 daarvan zonder naam (12211, 17199,
246916, 252024, 277313) laat ik weg → **119** + 5 niet-Well-Fed + 2 feestdag-items (AFGELEID) = **126** in het
Lua-blok. Alle items met naam, Req en aura staan in het Lua-blok onderaan.

---

## 3. Health- en mana potions — GEMETEN

Allemaal `SpellCategoryID 4` "Item - Combat Consumable (Potion)", 120 s gedeelde cooldown (GEMETEN).
"Heal" = DB2-basiswaarde (`EffectBasePointsF`, het midden); tooltip-bereik waar ik het heb opgehaald.

### Health

| Item | Naam | Req | Spell | Heal | Let op |
|---|---|---|---|---|---|
| 13446 | Major Healing Potion | 45 | 17534 | 1400 (1050–1750) | |
| 282011 | Restored Healing Potion | 1 | 1312698 | 30% HP | BoP; plek in de rij AFGELEID |
| 3928 | Superior Healing Potion | 35 | 4042 | 800 (700–900) | |
| 288896 | Superior Healing Potion | 1 | 4042 | 800 | ilvl 30-versie |
| 18839 | Combat Healing Potion | 35 | 4042 | 800 | BoP, PvP-rang 5 |
| 1710 | Greater Healing Potion | 21 | 2024 | 520 | |
| 287977 | Greater Healing Potion | 1 | 2024 | 520 (455–585) | Binds to Account |
| 929 | Healing Potion | 12 | 441 | 320 | |
| 268883 | Perishable Healing Potion | 12 | 441 | 320 (280–360) | Conjured |
| 858 | Lesser Healing Potion | 3 | 440 | 160 | |
| 268882 | Perishable Lesser Healing Potion | 3 | 440 | 160 | Conjured |
| 287967 | Lesser Healing Potion | 1 | 440 | 160 | account-versie |
| 118 | Minor Healing Potion | 1 | 439 | 80 | |
| 268881 | Perishable Minor Healing Potion | 1 | 439 | 80 | Conjured |
| 287966 | Minor Healing Potion | 1 | 439 | 80 (70–90) | Binds to Account |
| 18253 | Major Rejuvenation Potion | 50 | 22729 | 1600 HP + 1600 mana | ook mana |
| 9144 | Wildvine Potion | 35 | 11387 | 750 HP + 750 mana | ook mana |
| 2456 | Minor Rejuvenation Potion | 5 | 2370 | 120 HP + 120 mana | ook mana |
| 241650 | Major Discolored Healing Potion | 60 | 1231578 | 2800 (2625–2975) | Forever-nieuw: je krijgt 75% terug als gif/ziekte |
| 247242 | Superior Discolored Healing Potion | 35 | 1244867 | 1600 (1500–1700) | idem |
| 247241 | Greater Discolored Healing Potion | 21 | 1244866 | 1040 | idem |
| 247240 | Discolored Healing Potion | 12 | 1244865 | 640 | idem |
| 247239 | Lesser Discolored Healing Potion | 3 | 1244864 | 320 | idem |
| 4596 | Minor Discolored Healing Potion | 5 | 1244863 | 160 (150–170) | idem |
| 223913 | Major Healing Potion | 40 | 450106 | 1500 | Wowhead: "Added in Season of Discovery. May not be in WoW: Forever." |
| 223914 | Greater Healing Potion | 20 | 450107 | 650 | idem (SoD) |

Niet meegenomen: 241655 / 241656 "Mishandled Healing Potion" (geen ItemEffect-rij, GEMETEN); Whipper Root Tuber en
Night Dragon's Breath heb ik **niet** gemeten.

### Mana

| Item | Naam | Req | Spell | Mana | Let op |
|---|---|---|---|---|---|
| 13444 | Major Mana Potion | 49 | 17531 | 1800 (1350–2250) | |
| 282013 | Restored Mana Potion | 1 | 1312702 | 20% mana | BoP; plek AFGELEID |
| 13443 | Superior Mana Potion | 41 | 17530 | 1200 | |
| 288897 | Superior Mana Potion | 1 | 17530 | 1200 (900–1500) | ilvl 30-versie |
| 18841 | Combat Mana Potion | 41 | 17530 | 1200 | BoP, PvP-rang 5 |
| 6149 | Greater Mana Potion | 31 | 11903 | 800 | |
| 3827 | Mana Potion | 22 | 2023 | 520 | |
| 3385 | Lesser Mana Potion | 14 | 438 | 320 | |
| 287969 | Lesser Mana Potion | 1 | 438 | 320 | account-versie |
| 2455 | Minor Mana Potion | 5 | 437 | 160 | |
| 287968 | Minor Mana Potion | 1 | 437 | 160 | account-versie |

(+ de drie Rejuvenation Potions hierboven geven ook mana.)

---

## 4. Healthstones — GEMETEN

15 items met "Healthstone" in de naam. Elke stone heeft `SpellCategoryID 1153`, 120 s cooldown — **een andere
categorie dan potions (4)**: stone en potion kunnen dus allebei (GEMETEN categorie; "allebei" AFGELEID).

| Rang | Basis-item | Heal | Talent-varianten (Improved Healthstone) | Req |
|---|---|---|---|---|
| Major | 9421 (spell 11732) | 1440 | 19012 = 1320, 19013 = 1440 | 48 |
| Greater | 5510 (5723) | 960 | 19010 = 880, 19011 = 960 | 36 |
| Healthstone | 5509 (5720) | 600 | 19008 = 550, 19009 = 600 | 24 |
| Lesser | 5511 (6263) | 300 | 19006 = 275, 19007 = 300 | 12 |
| Minor | 5512 (6262) | 120 | 19004 = 110, 19005 = 120 | 1 |

- Talent bestaat in Forever (GEMETEN): Talent 1221, TabID 303, SpellRank 18692 / 18693 "Improved Healthstone".
- ⚠️ Opvallend (GEMETEN in DB2 én Wowhead-tooltip): de **basis**-stone heelt al evenveel als de talent-rang-2-stone
  (5512 = 120 = 19005), en rang 1 heelt minder (19004 = 110). Waarom: niet gemeten.
- Welke stone de server maakt (basis of talent) is niet te meten: Create Healthstone is `Effect 77` (script).
- Create Healthstone staat in `ForeverSpellIds.lua`: { 6201, 6202, 5699, 11729, 11730 }. Klopt (GEMETEN):
  precies deze vijf staan in SkillLineAbility (Warlock, skill 354); Spell-tekst koppelt 6201 → Minor, 6202 → Lesser,
  5699 → Healthstone, 11729 → Greater, 11730 → Major. Andere "Create Healthstone"-id's (23517–23522, 23813–23821,
  20018, 28023, 657, 11731) zijn geen spelerspells.
- Niet meegenomen: 5408 "Deprecated Minor Bloodstone" (gebruikt ook spell 6262).

---

## 5. Class-buffs voor anderen — `Modules/ForeverSpellIds.lua` nagemeten

Methode (GEMETEN): per buff alle id's met die naam in SpellName, dan SkillLineAbility (= wat een speler kan leren).

| Buff | In ForeverSpellIds | = SkillLineAbility? | Andere id's met die naam (geen spelerspell) |
|---|---|---|---|
| Arcane Intellect | 1459, 1460, 1461, 10156, 10157 | ja | 13326, 16876, 364161 |
| Arcane Brilliance | 23028 | ja | — |
| Power Word: Fortitude | 1243, 1244, 1245, 2791, 10937, 10938 | ja | 10939, 10940, 13864, 23947, 23948 |
| Prayer of Fortitude | 21562, 21564 | ja | 450086 |
| Mark of the Wild | 1126, 5232, 6756, 5234, 8907, 9884, 9885 | ja | 5286, 5287, 8908, 16878, 24752, 364163, 1291335, 1310503 |
| Gift of the Wild | 21849, 21850 | ja | — |
| Blessing of Might | 19740, 19834–19838, 25291 | ja | — |
| Blessing of Wisdom | 19742, 19850, 19852, 19853, 19854, 25290 | ja | — |
| Blessing of Kings | 20217 | ja | 1213408 |
| Greater Blessing of Might | 25782, 25916 | ja | — |
| Greater Blessing of Wisdom | 25894, 25918 | ja | — |
| Greater Blessing of Kings | 25898 | ja | — |
| Divine Spirit | 14752, 14818, 14819, 27841 | ja | 16875 |
| Prayer of Spirit | 27681 | ja | — |
| Shadow Protection | 976, 10957, 10958 | ja | 7235, 7241–7244, 16874 |
| Prayer of Shadow Protection | 27683 | ja | — |

- **Niets ontbreekt** (GEMETEN, build 71037): voor alle 16 namen is de lijst in ForeverSpellIds precies de
  SkillLineAbility-set.
- **Bestaan in Forever niet** (GEMETEN: zoek "Blessing" in SpellName gaf 110 rijen, mét Might/Wisdom/Kings, maar
  géén van deze): **Blessing of Salvation, Blessing of Sanctuary, Greater Blessing of Light, Greater Blessing of
  Salvation, Greater Blessing of Sanctuary**. Ook de klassieke id's 1038, 20911–20914, 19977–19979, 25890, 25895,
  25899 geven 0 rijen.
- **Blessing of Light**: er is één spell 26650 met die naam, maar hij staat **niet** in SkillLineAbility (controle
  20217 wel) → geen spelerspell (GEMETEN). Voor het bord: bestaat niet.
- Wel in de data maar geen talent: "Improved Blessing of Salvation" 20194/20195 (Talent-tabel: 0 rijen; controle
  Improved Blessing of Might 20042 en Improved Healthstone 18692 wel) — GEMETEN.
- Let op (AFGELEID): de id's in de rechterkolom zijn NPC-/itemversies. Een partylid kan zo'n aura ooit hebben
  (bv. 1213408 Blessing of Kings, bron niet gemeten). Een check alleen op speler-id's mist die; een check op naam niet.

---

## Lua-blok (kant-en-klaar)

Velden: `item`, `aura` (spell-id op de speler), `lvl` (= ItemSparse.RequiredLevel), `dur` (seconden, uit DB2),
`kind`. Eten: `util = true` = hulpmiddel-buff (beroep/snelheid), `wf = false` = buff heet niet "Well Fed",
`derived = true` = koppeling AFGELEID. Potions/stones: `heal`/`mana` = DB2-basiswaarde (`pct` = procent).
Elke lijst: beste eerst (AFGELEID, zie boven). Gemeten op wago `wowf` 1.60.1.71037, 24 nov 2026.

```lua
-- WoW Forever party consumables. Measured on wago DB2 wowf 1.60.1.71037 (ItemXItemEffect -> ItemEffect.SpellID,
-- SpellEffect, SpellMisc/SpellDuration, ItemSparse.RequiredLevel) + Wowhead Forever tooltips, 24 Nov 2026.
-- Order inside each list = "best first" by RequiredLevel, then strength, then duration (a judgement, not data).
ns.FOREVER_CONSUMABLES = {
	-- Flasks (2 h, persist through death, one at a time) and pre-fight elixirs.
	flask = {
		{ item = 13510, aura = 17626, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of the Titans: +1200 HP
		{ item = 13512, aura = 17628, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Supreme Power: +150 SpD
		{ item = 13511, aura = 17627, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Distilled Wisdom: +2000 mana
		{ item = 13513, aura = 17629, lvl = 50, kind = "flask", dur = 7200 },   -- Flask of Chromatic Resistance
		{ item = 274273, aura = 1293740, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Accuracy (hit, Hyjal zones)
		{ item = 274274, aura = 1293741, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Aggression (crit)
		{ item = 274275, aura = 1293742, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Precision (dodge/parry)
		{ item = 274276, aura = 1293743, lvl = 55, kind = "flask", dur = 7200 }, -- Flask of Natural Swiftness (haste); spell is NAMED "Flask of Natural Accuracy"
		{ item = 250328, aura = 1250918, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Cunning
		{ item = 250329, aura = 1250920, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Phalanx
		{ item = 250333, aura = 1250926, lvl = 55, kind = "elixir", dur = 1800 }, -- Greater Cleric's Elixir
		{ item = 250335, aura = 1250931, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Greater Fortitude
		{ item = 250336, aura = 1250932, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Wicked Regeneration
		{ item = 250337, aura = 1250940, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Owl
		{ item = 250338, aura = 1250941, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Sages
		{ item = 250341, aura = 1250948, lvl = 55, kind = "elixir", dur = 1800 }, -- Greater Mageblood Elixir
		{ item = 250343, aura = 1250972, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Nature Power
		{ item = 250347, aura = 1250979, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Greater Spirit
		{ item = 250348, aura = 1250981, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Whale
		{ item = 250350, aura = 1250985, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of Ferocity
		{ item = 250351, aura = 1250986, lvl = 55, kind = "elixir", dur = 1800 }, -- Elixir of the Grizzly
		{ item = 20004, aura = 24361, lvl = 53, kind = "elixir", dur = 3600 },    -- Major Troll's Blood Elixir
		{ item = 9206, aura = 11405, lvl = 48, kind = "elixir", dur = 3600 },     -- Elixir of Greater Strength
		{ item = 13454, aura = 17539, lvl = 47, kind = "elixir", dur = 3600 },    -- Greater Arcane Elixir
		{ item = 13452, aura = 17538, lvl = 46, kind = "elixir", dur = 1800 },    -- Elixir of the Mongoose
		{ item = 13453, aura = 17537, lvl = 45, kind = "elixir", dur = 3600 },    -- Elixir of Brute Force
		{ item = 250332, aura = 1250925, lvl = 45, kind = "elixir", dur = 1800 }, -- Cleric's Elixir
		{ item = 250334, aura = 1250928, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Fortitude
		{ item = 250346, aura = 1250978, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Spirit
		{ item = 250349, aura = 1250984, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Strength
		{ item = 250354, aura = 1250989, lvl = 45, kind = "elixir", dur = 1800 }, -- Elixir of Intellect
		{ item = 12820, aura = 17038, lvl = 45, kind = "elixir", dur = 1200 },    -- Winterfall Firewater
		{ item = 246948, aura = 17038, lvl = 45, kind = "elixir", dur = 1200 },   -- Distilled Firewater (same aura)
		{ item = 13445, aura = 11348, lvl = 43, kind = "elixir", dur = 3600 },    -- Elixir of Greater Defense
		{ item = 20007, aura = 24363, lvl = 40, kind = "elixir", dur = 3600 },    -- Mageblood Elixir
		{ item = 9264, aura = 11474, lvl = 40, kind = "elixir", dur = 1800 },     -- Elixir of Shadow Power
		{ item = 21546, aura = 1310077, lvl = 40, kind = "elixir", dur = 1800 },  -- Elixir of Holy Power
		{ item = 9187, aura = 11334, lvl = 38, kind = "elixir", dur = 3600 },     -- Elixir of Greater Agility
		{ item = 13447, aura = 17535, lvl = 38, kind = "elixir", dur = 3600 },    -- Elixir of the Sages
		{ item = 9088, aura = 11371, lvl = 38, kind = "elixir", dur = 1800 },     -- Gift of Arthas
		{ item = 9179, aura = 11396, lvl = 37, kind = "elixir", dur = 3600 },     -- Elixir of Greater Intellect
		{ item = 9155, aura = 11390, lvl = 37, kind = "elixir", dur = 1800 },     -- Arcane Elixir
		{ item = 8951, aura = 11349, lvl = 29, kind = "elixir", dur = 3600 },     -- Elixir of Defense
		{ item = 17708, aura = 21920, lvl = 28, kind = "elixir", dur = 1800 },    -- Elixir of Frost Power
		{ item = 217398, aura = 439959, lvl = 28, kind = "elixir", dur = 1800 },  -- Lesser Arcane Elixir
		{ item = 8949, aura = 11328, lvl = 27, kind = "elixir", dur = 3600 },     -- Elixir of Agility
		{ item = 3826, aura = 3223, lvl = 26, kind = "elixir", dur = 3600 },      -- Troll's Blood Elixir
		{ item = 3825, aura = 3593, lvl = 25, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Fortitude
		{ item = 250331, aura = 1250924, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Cleric's Elixir
		{ item = 250340, aura = 1250944, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Mageblood Elixir
		{ item = 250342, aura = 1250971, lvl = 25, kind = "elixir", dur = 1800 }, -- Lesser Arcane Elixir
		{ item = 250345, aura = 1250976, lvl = 25, kind = "elixir", dur = 1800 }, -- Elixir of Lesser Spirit
		{ item = 250353, aura = 1250988, lvl = 25, kind = "elixir", dur = 1800 }, -- Elixir of Lesser Intellect
		{ item = 3391, aura = 3164, lvl = 20, kind = "elixir", dur = 3600 },      -- Elixir of Ogre Strength
		{ item = 3390, aura = 3160, lvl = 18, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Agility
		{ item = 6373, aura = 7844, lvl = 18, kind = "elixir", dur = 1800 },      -- Elixir of Fire Power
		{ item = 3389, aura = 3220, lvl = 16, kind = "elixir", dur = 3600 },      -- Elixir of Lesser Defense
		{ item = 3388, aura = 3222, lvl = 15, kind = "elixir", dur = 3600 },      -- Lesser Troll's Blood Elixir
		{ item = 3383, aura = 3166, lvl = 10, kind = "elixir", dur = 1800 },      -- Elixir of Wisdom
		{ item = 250330, aura = 1250922, lvl = 5, kind = "elixir", dur = 1800 },  -- Minor Cleric's Elixir
		{ item = 250339, aura = 1250942, lvl = 5, kind = "elixir", dur = 1800 },  -- Minor Mageblood Elixir
		{ item = 250344, aura = 1250974, lvl = 5, kind = "elixir", dur = 1800 },  -- Elixir of Minor Spirit
		{ item = 2457, aura = 2374, lvl = 2, kind = "elixir", dur = 3600 },       -- Elixir of Minor Agility
		{ item = 2458, aura = 2378, lvl = 2, kind = "elixir", dur = 3600 },       -- Elixir of Minor Fortitude
		{ item = 2454, aura = 2367, lvl = 1, kind = "elixir", dur = 3600 },       -- Elixir of Minor Strength
		{ item = 3382, aura = 3219, lvl = 1, kind = "elixir", dur = 3600 },       -- Minor Troll's Blood Elixir
		{ item = 5997, aura = 673, lvl = 1, kind = "elixir", dur = 3600 },        -- Elixir of Minor Defense
		{ item = 247754, aura = 1245244, lvl = 1, kind = "elixir", dur = 1800 },  -- Minor Arcane Elixir
		{ item = 247755, aura = 1245249, lvl = 1, kind = "elixir", dur = 1800 },  -- Elixir of Minor Force
		-- "Endless" elixirs: in the data, stack to 5, sell for 1 copper; where players get them is NOT measured.
		{ item = 289083, aura = 1327737, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Power
		{ item = 289086, aura = 1327751, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Rapidity
		{ item = 289087, aura = 1327753, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Opportunity
		{ item = 289082, aura = 1327736, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Intellect
		{ item = 289084, aura = 1327738, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Healing
		{ item = 289321, aura = 1328032, lvl = 1, kind = "elixir", dur = 3600, endless = true }, -- Endless Mana
	},

	food = {
		-- Every spell named exactly "Well Fed" in Forever (30). Strength of the new ones comes from the food, not the aura.
		auras = {
			1248406, 1248420, 1248421, 1248422,            -- Stamina / Agility / Intellect / Strength
			1249519, 1249520, 1249523, 1249926, 1249927,   -- AP / spell damage / 1% crit / Spirit / healing
			1225778, 1225779, 1225780, 1319310,            -- lvl 55 foods (Str / Agi / caster) and Plated Armorfish
			19705, 19706, 19708, 19709, 19710, 19711,      -- classic Stamina+Spirit versions
			24799, 24870, 25694, 25941, 1225782, 1283082, 1302064, -- older/unused (24870 = Bobbing Apple, derived)
			1249521, 1249907, 1248688, 1294007,            -- utility: Fishing, Herbalism, speed in Westfall / Hyjal
		},
		-- Food buffs that are NOT named "Well Fed" (measured).
		auras_other = { 25661, 470361, 470367, 18125, 18141 }, -- Increased Stamina, Increased Spell Damage, Increased Healing Power, Blessed Sunfruit, Blessed Sunfruit Juice
		-- 1243969 "Well Fed XP Boost" (+5% kill XP) is an extra, not a combat buff: left out on purpose.
		items = {
			{ item = 238639, aura = 1225780, lvl = 55 }, -- Sunrise Omelette: 25 SpD, 55 heal, 10 Sta
			{ item = 238637, aura = 1225778, lvl = 55 }, -- Prowler Steak: 25 Str, 10 Sta
			{ item = 238638, aura = 1225779, lvl = 55 }, -- Filet o' Flank: 25 Agi, 10 Sta
			{ item = 267341, aura = 1294007, lvl = 55, util = true }, -- Sweetpaw Jam: speed in Hyjal
			{ item = 13934, aura = 1249519, lvl = 45 },  -- Mightfish Steak: 40 AP
			{ item = 249870, aura = 1249927, lvl = 45 }, -- Sage's Tea: 44 healing
			{ item = 13933, aura = 1249520, lvl = 45 },  -- Lobster Stew: 28 SpD
			{ item = 13935, aura = 1249520, lvl = 45 },  -- Baked Salmon: 28 SpD
			{ item = 21023, aura = 25661, lvl = 45, wf = false }, -- Dirge's Kickin' Chimaerok Chops: 25 Sta
			{ item = 250068, aura = 1248406, lvl = 45 }, -- Savory Turtle Stew: 20 Sta
			{ item = 250069, aura = 1248420, lvl = 45 }, -- Flank au Poivre: 20 Agi
			{ item = 250072, aura = 1248420, lvl = 45 }, -- Swiftstrike Steak: 20 Agi
			{ item = 250066, aura = 1248421, lvl = 45 }, -- Soaring Pamplona: 20 Int
			{ item = 250067, aura = 1248421, lvl = 45 }, -- Bat Hachee: 20 Int
			{ item = 250075, aura = 1248421, lvl = 45 }, -- Prehistoric Pulled Raptor: 20 Int
			{ item = 20452, aura = 1248422, lvl = 45 },  -- Smoked Desert Dumplings: 20 Str
			{ item = 250070, aura = 1248422, lvl = 45 }, -- Bear Bruscitti: 20 Str
			{ item = 250071, aura = 1248422, lvl = 45 }, -- Steaming Stag Steak: 20 Str
			{ item = 249876, aura = 1249926, lvl = 45 }, -- Wicked Smoothie: 20 Spi
			{ item = 232436, aura = 470361, lvl = 45, wf = false }, -- Darkclaw Bisque: 12 SpD, 10 min
			{ item = 13810, aura = 18125, lvl = 45, wf = false },   -- Blessed Sunfruit: 10 Str, 10 min
			{ item = 13813, aura = 18141, lvl = 45, wf = false },   -- Blessed Sunfruit Juice: 10 Spi, 10 min
			{ item = 8957, aura = 1249521, lvl = 45, util = true }, -- Spinefin Halibut: Fishing
			{ item = 16971, aura = 19710, lvl = 40 },    -- Clamlette Surprise: 12 Sta + 12 Spi
			{ item = 13932, aura = 1249519, lvl = 35 },  -- Poached Sunscale Salmon: 40 AP
			{ item = 249869, aura = 1249927, lvl = 35 }, -- Sunny Tea: 33 healing
			{ item = 13927, aura = 1249519, lvl = 35 },  -- Cooked Glossy Mightfish: 30 AP
			{ item = 6887, aura = 1249520, lvl = 35 },   -- Spotted Yellowtail: 22 SpD
			{ item = 13931, aura = 1249520, lvl = 35 },  -- Nightfin Soup: 22 SpD
			{ item = 232438, aura = 470367, lvl = 35, wf = false }, -- Smoked Redgill: 22 healing, 10 min
			{ item = 12218, aura = 1248406, lvl = 35 },  -- Monster Omelet: 15 Sta
			{ item = 17222, aura = 1248406, lvl = 35 },  -- Spider Sausage: 15 Sta
			{ item = 12212, aura = 1248420, lvl = 35 },  -- Jungle Stew: 15 Agi
			{ item = 18045, aura = 1248420, lvl = 35 },  -- Tender Wolf Steak: 15 Agi
			{ item = 18254, aura = 1248421, lvl = 35 },  -- Runn Tum Tuber Surprise: 15 Int
			{ item = 250076, aura = 1248421, lvl = 35 }, -- Raptor Rouladen: 15 Int
			{ item = 250065, aura = 1248422, lvl = 35 }, -- Savory Stag Sliders: 15 Str
			{ item = 249875, aura = 1249926, lvl = 35 }, -- Spicy Smoothie: 15 Spi
			{ item = 13928, aura = 1249523, lvl = 35 },  -- Grilled Squid: 1% crit
			{ item = 13929, aura = 1249523, lvl = 35 },  -- Hot Smoked Bass: 1% crit
			{ item = 286152, aura = 1319310, lvl = 35 }, -- Plated Armorfish: 150 armor
			{ item = 13930, aura = 1249521, lvl = 35, util = true }, -- Filet of Redgill: Fishing
			{ item = 21217, aura = 1249520, lvl = 30 },  -- Sagefish Delight: 7 SpD
			{ item = 249868, aura = 1249927, lvl = 25 }, -- Triage Tea: 22 healing
			{ item = 8364, aura = 1249519, lvl = 25 },   -- Mithril Head Trout: 20 AP
			{ item = 274971, aura = 1249520, lvl = 25 }, -- Briny Seafood Stew: 14 SpD
			{ item = 6038, aura = 1248406, lvl = 25 },   -- Giant Clam Scorcho: 10 Sta
			{ item = 12215, aura = 1248406, lvl = 25 },  -- Heavy Kodo Stew: 10 Sta
			{ item = 250078, aura = 1248406, lvl = 25 }, -- Giant Scrambled Eggs: 10 Sta
			{ item = 3728, aura = 1248420, lvl = 25 },   -- Tasty Lion Steak: 10 Agi
			{ item = 13851, aura = 1248420, lvl = 25 },  -- Hot Wolf Ribs: 10 Agi
			{ item = 20074, aura = 1248420, lvl = 25 },  -- Heavy Crocolisk Stew: 10 Agi
			{ item = 4457, aura = 1248421, lvl = 25 },   -- Barbecued Buzzard Wing: 10 Int
			{ item = 12216, aura = 1248421, lvl = 25 },  -- Spiced Chili Crab: 10 Int
			{ item = 250073, aura = 1248421, lvl = 25 }, -- Raging Raptor Ribs: 10 Int
			{ item = 250074, aura = 1248422, lvl = 25 }, -- Bear Brisket: 10 Str
			{ item = 274976, aura = 1248422, lvl = 25 }, -- Plain Ol' Paletusk: 10 Str
			{ item = 249874, aura = 1249926, lvl = 25 }, -- Calcified Smoothie: 10 Spi
			{ item = 4594, aura = 1249521, lvl = 25, util = true },  -- Rockscale Cod: Fishing
			{ item = 10841, aura = 1249907, lvl = 25, util = true }, -- Goldthorn Tea: Herbalism
			{ item = 249867, aura = 1249927, lvl = 15 }, -- Root Tea: 11 healing
			{ item = 5527, aura = 19708, lvl = 15 },     -- Goblin Deviled Clams: 6 Sta + 6 Spi
			{ item = 3665, aura = 1248406, lvl = 15 },   -- Curiously Tasty Omelet: 5 Sta
			{ item = 3666, aura = 1248406, lvl = 15 },   -- Gooey Spider Cake: 5 Sta
			{ item = 3729, aura = 1248406, lvl = 15 },   -- Soothing Turtle Bisque: 5 Sta
			{ item = 12214, aura = 1248406, lvl = 15 },  -- Mystery Stew: 5 Sta
			{ item = 1017, aura = 1248420, lvl = 15 },   -- Seasoned Wolf Kabob: 5 Agi
			{ item = 3664, aura = 1248420, lvl = 15 },   -- Crocolisk Gumbo: 5 Agi
			{ item = 3727, aura = 1248420, lvl = 15 },   -- Hot Lion Chops: 5 Agi
			{ item = 12209, aura = 1248420, lvl = 15 },  -- Lean Wolf Steak: 5 Agi
			{ item = 12210, aura = 1248421, lvl = 15 },  -- Roast Raptor: 5 Int
			{ item = 2685, aura = 1248422, lvl = 15 },   -- Succulent Pork Ribs: 5 Str
			{ item = 5480, aura = 1248422, lvl = 15 },   -- Lean Venison: 5 Str
			{ item = 249873, aura = 1249926, lvl = 15 }, -- Mrrggl Smrrthle: 5 Spi
			{ item = 4593, aura = 1249521, lvl = 15, util = true },  -- Bristle Whisker Catfish: Fishing
			{ item = 21072, aura = 1249520, lvl = 10 },  -- Smoked Sagefish: 4 SpD
			{ item = 4592, aura = 1249519, lvl = 5 },    -- Longjaw Mud Snapper: 10 AP
			{ item = 249866, aura = 1249927, lvl = 5 },  -- Royal Tea: 7 healing
			{ item = 5479, aura = 1248406, lvl = 5 },    -- Crispy Lizard Tail: 3 Sta
			{ item = 12213, aura = 1248406, lvl = 5 },   -- Carrion Surprise: 3 Sta
			{ item = 250080, aura = 1248406, lvl = 5 },  -- Breakfast Omelette: 3 Sta
			{ item = 268912, aura = 1248406, lvl = 5 },  -- Expiring Crab Cake: 3 Sta
			{ item = 268913, aura = 1248406, lvl = 5 },  -- Expiring Crocolisk Steak: 3 Sta
			{ item = 2684, aura = 1248420, lvl = 5 },    -- Coyote Steak: 3 Agi
			{ item = 3662, aura = 1248420, lvl = 5 },    -- Crocolisk Steak: 3 Agi
			{ item = 1082, aura = 1248421, lvl = 5 },    -- Redridge Goulash: 3 Int
			{ item = 2683, aura = 1248421, lvl = 5 },    -- Crab Cake: 3 Int
			{ item = 250077, aura = 1248421, lvl = 5 },  -- Twice-Spiced Raptor Slice: 3 Int
			{ item = 724, aura = 1248422, lvl = 5 },     -- Goretusk Liver Pie: 3 Str
			{ item = 2687, aura = 1248422, lvl = 5 },    -- Dry Pork Ribs: 3 Str
			{ item = 3220, aura = 1248422, lvl = 5 },    -- Blood Sausage: 3 Str
			{ item = 3726, aura = 1248422, lvl = 5 },    -- Big Bear Steak: 3 Str
			{ item = 249872, aura = 1249926, lvl = 5 },  -- Slimy Smoothie: 3 Spi
			{ item = 263509, aura = 1248406, lvl = 5 },  -- Skywall Souffle: 1 Sta
			{ item = 263512, aura = 1248421, lvl = 5 },  -- Pincer Bites: 1 Int
			{ item = 5095, aura = 1249520, lvl = 5 },    -- Rainbow Fin Albacore: 1 SpD
			{ item = 5476, aura = 1249521, lvl = 5, util = true },  -- Fillet of Frenzy: Fishing
			{ item = 6316, aura = 1249521, lvl = 5, util = true },  -- Loch Frenzy Delight: Fishing
			{ item = 733, aura = 1248688, lvl = 5, util = true },   -- Westfall Stew: speed in Westfall
			{ item = 287973, aura = 1248420, lvl = 1 },  -- Tender Wolf Steak (account-bound): 15 Agi
			{ item = 287974, aura = 1249523, lvl = 1 },  -- Grilled Squid (account-bound): 1% crit
			{ item = 787, aura = 1249519, lvl = 1 },     -- Slitherskin Mackerel: 6 AP
			{ item = 249865, aura = 1249927, lvl = 1 },  -- Peace Tea: 2 healing
			{ item = 6290, aura = 1249519, lvl = 1 },    -- Brilliant Smallfish: 2 AP
			{ item = 206177, aura = 19705, lvl = 1 },    -- Pine Nut Butter: 2 Sta + 2 Spi
			{ item = 7806, aura = 19705, lvl = 1 },      -- Lollipop
			{ item = 7807, aura = 19705, lvl = 1 },      -- Candy Bar
			{ item = 7808, aura = 19705, lvl = 1 },      -- Chocolate Square
			{ item = 11584, aura = 19705, lvl = 0 },     -- Cactus Apple Surprise
			{ item = 17197, aura = 19705, lvl = 1 },     -- Gingerbread Cookie
			{ item = 17198, aura = 19705, lvl = 1 },     -- Egg Nog
			{ item = 20516, aura = 24870, lvl = 0, derived = true }, -- Bobbing Apple (tooltip says well fed; no DB2 link)
			{ item = 21254, aura = 24870, lvl = 0, derived = true }, -- Winter Veil Cookie (idem)
			{ item = 3663, aura = 1248406, lvl = 1 },    -- Murloc Fin Soup: 1 Sta
			{ item = 5472, aura = 1248406, lvl = 1 },    -- Kaldorei Spider Kabob: 1 Sta
			{ item = 5474, aura = 1248406, lvl = 1 },    -- Roasted Kodo Meat: 1 Sta
			{ item = 6888, aura = 1248406, lvl = 1 },    -- Herb Baked Egg: 1 Sta
			{ item = 2680, aura = 1248420, lvl = 1 },    -- Spiced Wolf Meat: 1 Agi
			{ item = 2682, aura = 1248421, lvl = 1 },    -- Cooked Crab Claw: 1 Int
			{ item = 5477, aura = 1248421, lvl = 1 },    -- Strider Stew: 1 Int
			{ item = 12224, aura = 1248421, lvl = 1 },   -- Crispy Bat Wing: 1 Int
			{ item = 250079, aura = 1248421, lvl = 1 },  -- Tasty Raptor Bites: 1 Int
			{ item = 2681, aura = 1248422, lvl = 1 },    -- Roasted Boar Meat: 1 Str
			{ item = 2888, aura = 1248422, lvl = 1 },    -- Beer Basted Boar Ribs: 1 Str
			{ item = 6890, aura = 1248422, lvl = 1 },    -- Smoked Bear Meat: 1 Str
			{ item = 249871, aura = 1249926, lvl = 1 },  -- Venomous Smoothie: 1 Spi
		},
	},

	-- Health potions: plain first, then rejuvenation (also mana), then Discolored (75% comes back as poison/disease),
	-- then two Season of Discovery copies Wowhead says "may not be in WoW: Forever". All share potion category 4 (120 s).
	hpot = {
		{ item = 13446, lvl = 45, heal = 1400 },             -- Major Healing Potion
		{ item = 282011, lvl = 1, pct = 30 },                -- Restored Healing Potion (BoP, 30% HP; place in the list is a guess)
		{ item = 3928, lvl = 35, heal = 800 },               -- Superior Healing Potion
		{ item = 288896, lvl = 1, heal = 800 },              -- Superior Healing Potion (ilvl 30 copy)
		{ item = 18839, lvl = 35, heal = 800 },              -- Combat Healing Potion (PvP rank 5)
		{ item = 1710, lvl = 21, heal = 520 },               -- Greater Healing Potion
		{ item = 287977, lvl = 1, heal = 520 },              -- Greater Healing Potion (account-bound)
		{ item = 929, lvl = 12, heal = 320 },                -- Healing Potion
		{ item = 268883, lvl = 12, heal = 320 },             -- Perishable Healing Potion (conjured)
		{ item = 858, lvl = 3, heal = 160 },                 -- Lesser Healing Potion
		{ item = 268882, lvl = 3, heal = 160 },              -- Perishable Lesser Healing Potion
		{ item = 287967, lvl = 1, heal = 160 },              -- Lesser Healing Potion (account copy)
		{ item = 118, lvl = 1, heal = 80 },                  -- Minor Healing Potion
		{ item = 268881, lvl = 1, heal = 80 },               -- Perishable Minor Healing Potion
		{ item = 287966, lvl = 1, heal = 80 },               -- Minor Healing Potion (account-bound)
		{ item = 18253, lvl = 50, heal = 1600, mana = 1600, kind = "rejuv" }, -- Major Rejuvenation Potion
		{ item = 9144, lvl = 35, heal = 750, mana = 750, kind = "rejuv" },    -- Wildvine Potion
		{ item = 2456, lvl = 5, heal = 120, mana = 120, kind = "rejuv" },     -- Minor Rejuvenation Potion
		{ item = 241650, lvl = 60, heal = 2800, kind = "discolored" },        -- Major Discolored Healing Potion
		{ item = 247242, lvl = 35, heal = 1600, kind = "discolored" },        -- Superior Discolored Healing Potion
		{ item = 247241, lvl = 21, heal = 1040, kind = "discolored" },        -- Greater Discolored Healing Potion
		{ item = 247240, lvl = 12, heal = 640, kind = "discolored" },         -- Discolored Healing Potion
		{ item = 247239, lvl = 3, heal = 320, kind = "discolored" },          -- Lesser Discolored Healing Potion
		{ item = 4596, lvl = 5, heal = 160, kind = "discolored" },            -- Minor Discolored Healing Potion
		{ item = 223913, lvl = 40, heal = 1500, kind = "sod" },               -- Major Healing Potion (SoD)
		{ item = 223914, lvl = 20, heal = 650, kind = "sod" },                -- Greater Healing Potion (SoD)
	},

	mpot = {
		{ item = 13444, lvl = 49, mana = 1800 },             -- Major Mana Potion
		{ item = 282013, lvl = 1, pct = 20 },                -- Restored Mana Potion (BoP, 20% mana; place is a guess)
		{ item = 13443, lvl = 41, mana = 1200 },             -- Superior Mana Potion
		{ item = 288897, lvl = 1, mana = 1200 },             -- Superior Mana Potion (ilvl 30 copy)
		{ item = 18841, lvl = 41, mana = 1200 },             -- Combat Mana Potion (PvP rank 5)
		{ item = 6149, lvl = 31, mana = 800 },               -- Greater Mana Potion
		{ item = 3827, lvl = 22, mana = 520 },               -- Mana Potion
		{ item = 3385, lvl = 14, mana = 320 },               -- Lesser Mana Potion
		{ item = 287969, lvl = 1, mana = 320 },              -- Lesser Mana Potion (account copy)
		{ item = 2455, lvl = 5, mana = 160 },                -- Minor Mana Potion
		{ item = 287968, lvl = 1, mana = 160 },              -- Minor Mana Potion (account copy)
	},

	-- Healthstones: own cooldown category 1153 (not the potion one). 19004-19013 = Improved Healthstone talent copies.
	hs = {
		{ item = 9421, lvl = 48, heal = 1440 },  -- Major Healthstone
		{ item = 19013, lvl = 48, heal = 1440 }, -- Major Healthstone (talent copy)
		{ item = 19012, lvl = 48, heal = 1320 }, -- Major Healthstone (talent copy)
		{ item = 5510, lvl = 36, heal = 960 },   -- Greater Healthstone
		{ item = 19011, lvl = 36, heal = 960 },  -- Greater Healthstone (talent copy)
		{ item = 19010, lvl = 36, heal = 880 },  -- Greater Healthstone (talent copy)
		{ item = 5509, lvl = 24, heal = 600 },   -- Healthstone
		{ item = 19009, lvl = 24, heal = 600 },  -- Healthstone (talent copy)
		{ item = 19008, lvl = 24, heal = 550 },  -- Healthstone (talent copy)
		{ item = 5511, lvl = 12, heal = 300 },   -- Lesser Healthstone
		{ item = 19007, lvl = 12, heal = 300 },  -- Lesser Healthstone (talent copy)
		{ item = 19006, lvl = 12, heal = 275 },  -- Lesser Healthstone (talent copy)
		{ item = 5512, lvl = 1, heal = 120 },    -- Minor Healthstone
		{ item = 19005, lvl = 1, heal = 120 },   -- Minor Healthstone (talent copy)
		{ item = 19004, lvl = 1, heal = 110 },   -- Minor Healthstone (talent copy)
	},
}
```

## Wat ik NIET kon meten

- Battle/Guardian-indeling en welke elixers samen mogen staan (serverregel, staat niet in de client-data).
- Waar de "Endless"-elixers vandaan komen, en of spelers ze kunnen krijgen.
- Of de SoD-potions 223913/223914 en Darkclaw Bisque/Smoked Redgill (232436/232438) echt in Forever te krijgen zijn.
- Welke healthstone (basis of talent) de server maakt, en waarom de basis-stone al de rang-2-waarde heeft.
- Waar spell 1225504 (langere elixer/flask-duur) vandaan komt.
- Of Bobbing Apple / Winter Veil Cookie echt aura 24870 geven (tooltip ja, DB2-link nee).
- Whipper Root Tuber, Night Dragon's Breath en scrolls: niet gemeten.
- Juju's, Zanza en Blasted Lands vielen buiten de opdracht, maar zijn wél gemeten (zelfde build; item → aura, duur):
  Blasted Lands (1 u, eigen categorie 103): 8410 R.O.I.D.S. → 10667 (+25 Str), 8411 Lung Juice Cocktail → 10668
  (+25 Sta), 8412 Ground Scorpok Assay → 10669 (+25 Agi), 8423 Cerebral Cortex Compound → 10692 (+25 Int), 8424
  Gizzard Gum → 10693 (+25 Spi). Zanza (2 u, Req 55): 20079 Spirit of Zanza → 24382 (+50 Sta, +50 Spi), 20080 Sheen
  of Zanza → 24417, 20081 Swiftness of Zanza → 24383 (+20% snelheid). Juju: 12451 Power → 16323 (+30 Str, 30 min),
  12458 Guile → 16327 (+30 Int, 30 min), 12460 Might → 16329 (+40 AP, 10 min), 12455 Ember → 16326 en 12457 Chill
  → 16325 (10 min), 12450 Flurry → 16322 (20 s), 12459 Escape → 16321 (10 s).
