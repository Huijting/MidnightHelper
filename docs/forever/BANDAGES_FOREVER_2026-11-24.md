# Bandages in WoW Forever (24 nov 2026, tweede meting)

Gemeten door een mh-research-helper op 24 nov 2026, alleen via `tools/gamedata.py` (voordeur `_probe.py`).

**Bronnen**
- **DB2** = wago.tools DB2-CSV, product `wowf`, build **1.60.1.71037** (nieuwste Forever-build op wago, 2026-11-20).
  Tabellen: ItemSparse, Item, ItemXItemEffect, ItemEffect, SpellName, SpellEffect, SpellMisc, SpellDuration,
  SkillLine, Map.
- **TT** = Wowhead Forever tooltip-JSON (`nether.wowhead.com/forever/tooltip/item/<id>`), opgehaald 2026-11-24.

**Wat de kolommen betekenen**
- `RequiredLevel` en `First Aid` = ItemSparse `RequiredLevel` en `RequiredSkillRank`. `RequiredSkill` is bij elke
  bandage **2942**. SkillLine 2942 heet "First Aid" en heeft als ouder 129 ("First Aid"). GEMETEN (DB2).
- `spell` = de spell die het item gebruikt: ItemXItemEffect -> ItemEffect.SpellID. GEMETEN (DB2). Elke heal-spell in
  tabel 1 en 2 heet in SpellName "First Aid". Alle bandage-effecten zitten in SpellCategoryID **150** (42 ItemEffect-rijen
  in die categorie, alle 42 nagelopen), ook de
  anti-venoms, poultices en tourniquets (zie onder). GEMETEN (DB2).
- `heal` = de tekst in de tooltip ("Heals X damage over Y sec."). GEMETEN (TT). De DB2 zegt hetzelfde: SpellEffect
  Effect 6 / Aura 8 met een tik per 1000 ms, keer de duur uit SpellMisc -> SpellDuration. Die vermenigvuldiging is
  AFGELEID, maar klopt bij alle 28 bandages met de tooltip.
- Een `RequiredLevel` van 0 betekent: geen level-eis in de DB2. GEMETEN.

## 1. Bandages die overal werken (beste eerst)

| # | item | naam | RequiredLevel | First Aid | spell | heal | status | build |
|---|---|---|---|---|---|---|---|---|
| 1 | 232433 | Dense Runecloth Bandage | 50 | 300 | 470345 | 3400 over 8 s (425 per tik) | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 2 | 23684 | Crystal Infused Bandage | 0 | 225 | 30020 | 2500 over 10 s (250 per tik) | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 3 | 14530 | Heavy Runecloth Bandage | 0 | 225 | 18610 | 2000 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 4 | 14529 | Runecloth Bandage | 0 | 200 | 18608 | 1360 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 5 | 8545 | Heavy Mageweave Bandage | 0 | 175 | 10839 | 1104 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 6 | 8544 | Mageweave Bandage | 0 | 150 | 10838 | 800 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 7 | 6451 | Heavy Silk Bandage | 0 | 125 | 7927 | 640 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 8 | 6450 | Silk Bandage | 0 | 100 | 7926 | 400 over 8 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 9 | 3531 | Heavy Wool Bandage | 0 | 75 | 3268 | 301 over 7 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 10 | 3530 | Wool Bandage | 0 | 50 | 3267 | 161 over 7 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 11 | 2581 | Heavy Linen Bandage | 0 | 20 | 1159 | 114 over 6 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |
| 12 | 1251 | Linen Bandage | 0 | 1 | 746 | 66 over 6 s | GEMETEN (DB2 + TT) | 1.60.1.71037 |

- De volgorde is op **totale heal**. AFGELEID (een keuze). Crystal Infused (2500 in 10 s) en Heavy Runecloth (2000 in
  8 s) healen allebei 250 per seconde; Crystal Infused healt alleen langer.
- **Niet uit de oude Classic-lijst:** 232433 Dense Runecloth Bandage, met "Manual: Dense Runecloth Bandage" (232434,
  First Aid 300, BuyPrice 110000 koper). Dat beide in de Forever-DB2 staan: GEMETEN. Dat ze nieuw zijn ten opzichte
  van de oude Classic: AFGELEID (uit het hoge item-id, niet vergeleken met een andere build). Waar je de Manual koopt
  of vindt: NIET gemeten.
- Waar je 23684 Crystal Infused Bandage krijgt in Forever: NIET gemeten.
- Item-klasse (Item.ClassID/SubclassID, DB2): alle bandages hierboven zijn 0/7, behalve 232433, dat is 0/8. GEMETEN.

## 2. Bandages die alleen in een battleground werken

Zelfde heal als de gewone bandage met dezelfde waarde, maar alleen bruikbaar in die battleground. Allemaal "Binds
when picked up". Reputatie-eis en "Usable only inside ..." komen uit de tooltip. GEMETEN (TT); id, level, rank,
spell GEMETEN (DB2), build 1.60.1.71037.

| item | naam | RequiredLevel | First Aid | spell | heal | waar | eis (TT) |
|---|---|---|---|---|---|---|---|
| 19307 | Alterac Heavy Runecloth Bandage | 0 | 225 | 23696 | 2000 / 8 s | Alterac Valley | Stormpike Guard of Frostwolf Clan Friendly; stack 100 |
| 19066 | Warsong Gulch Runecloth Bandage | 45 | 225 | 23567 | 2000 / 8 s | Warsong Gulch | Silverwing Sentinels of Warsong Outriders Friendly |
| 19067 | Warsong Gulch Mageweave Bandage | 35 | 175 | 23568 | 1104 / 8 s | Warsong Gulch | idem |
| 19068 | Warsong Gulch Silk Bandage | 25 | 125 | 23569 | 640 / 8 s | Warsong Gulch | idem |
| 20066 | Arathi Basin Runecloth Bandage | 45 | 225 | 24414 | 2000 / 8 s | Arathi Basin | geen reputatieregel in de tooltip |
| 20065 | Arathi Basin Mageweave Bandage | 35 | 175 | 24413 | 1104 / 8 s | Arathi Basin | idem |
| 20067 | Arathi Basin Silk Bandage | 25 | 125 | 24412 | 640 / 8 s | Arathi Basin | idem |
| 20234 | Defiler's Runecloth Bandage | 45 | 225 | 24414 | 2000 / 8 s | Arathi Basin | The Defilers Friendly |
| 20232 | Defiler's Mageweave Bandage | 35 | 175 | 24413 | 1104 / 8 s | Arathi Basin | idem |
| 20235 | Defiler's Silk Bandage | 25 | 125 | 24412 | 640 / 8 s | Arathi Basin | idem |
| 20243 | Highlander's Runecloth Bandage | 45 | 225 | 24414 | 2000 / 8 s | Arathi Basin | The League of Arathor Friendly |
| 20237 | Highlander's Mageweave Bandage | 35 | 175 | 24413 | 1104 / 8 s | Arathi Basin | idem |
| 20244 | Highlander's Silk Bandage | 25 | 125 | 24412 | 640 / 8 s | Arathi Basin | idem |
| 272058 | Darkspear Islands Runecloth Bandage | 45 | 225 | 1290865 | 2000 / 8 s | Darkspear Islands | Theramore Expeditionary Force of Darkspear Raiders Friendly |
| 272057 | Darkspear Islands Mageweave Bandage | 35 | 175 | 1290863 | 1104 / 8 s | Darkspear Islands | idem |
| 272056 | Darkspear Islands Silk Bandage | 25 | 125 | 1290867 | 640 / 8 s | Darkspear Islands | idem |

- **Darkspear Islands** bestaat in de Forever-DB2: Map 2997 "Darkspear Islands", InstanceType 3, ExpansionID 0.
  GEMETEN (DB2). Dat hij nieuw is in Forever: AFGELEID (niet vergeleken met een andere build). Dat InstanceType 3 "battleground" betekent: AFGELEID (de gewone betekenis van die waarde). Of die
  battleground nu speelbaar is: NIET gemeten.
- De tooltip schrijft de twee reputaties onder elkaar ("Requires A - Friendly / Requires B - Friendly"). Dat het
  "de reputatie van jouw factie" is, is AFGELEID.

## 3. Wel in de bandage-categorie, maar geen heal (genezen van gif, ziekte, bloeding)

Allemaal SpellCategoryID 150 met 60000 ms cooldown in ItemEffect. GEMETEN (DB2). Tekst GEMETEN (TT).

| item | naam | RequiredLevel | First Aid | spell | wat het doet (TT) | klasse (DB2) |
|---|---|---|---|---|---|---|
| 19440 | Powerful Anti-Venom | 0 | 300 | 23786 | gif tot level 65 | 0/8 |
| 255715 | Potent Anti-Venom | 0 | 0 | 1259326 | gif tot level 45 | 7/11 |
| 6453 | Strong Anti-Venom | 0 | 0 | 7933 | gif tot level 35 | 0/8 |
| 6452 | Anti-Venom | 0 | 0 | 7932 | gif tot level 25 | 0/8 |
| 255719 | Powerful Poultice | 0 | 0 | 1259334 | ziekte tot level 65, niet in combat | 7/11 |
| 255718 | Superior Poultice | 0 | 0 | 1259333 | ziekte tot level 45, niet in combat | 7/11 |
| 255717 | Clever Poultice | 0 | 0 | 1259332 | ziekte tot level 35, niet in combat | 7/11 |
| 255716 | Simple Poultice | 0 | 0 | 1259330 | ziekte tot level 25, niet in combat | 7/11 |
| 255722 | Surgical Tourniquet | 0 | 0 | 1259337 | bloeding tot level 65, niet in combat | 7/11 |
| 255721 | Leather Tourniquet | 0 | 0 | 1259336 | bloeding tot level 45, niet in combat | 7/11 |
| 255720 | Woolen Tourniquet | 0 | 0 | 1259335 | bloeding tot level 30, niet in combat | 7/11 |

- Potent Anti-Venom en alle poultices en tourniquets (item-id's 255715-255722) bestaan in Forever: GEMETEN (DB2 + TT).
  Dat ze nieuw zijn in Forever: AFGELEID (uit de hoge id's). Dat ze bij First Aid horen (gemaakt met First Aid): NIET
  gemeten; alleen de gedeelde spell-categorie 150 is gemeten. Geen van hen heeft een First Aid-eis, behalve 19440.

## 4. Gevonden, maar geen bandage voor spelers

| item | naam | wat het is | status |
|---|---|---|---|
| 272126 | Makeshift Bandages | Quest Item, Unique: "Dress the injuries of a wounded soldier." Spell 1290242 "Apply Bandage" (koppelt naar 1290240 "Bleeding") | GEMETEN (DB2 + TT) |
| 16991 | Triage Bandage | Quest Item, 20 charges, spell 20804 "Triage" | GEMETEN (DB2 + TT) |
| 9332 | Crusted Bandages | geen gebruik-effect (0 rijen in ItemXItemEffect), wel verkoopbaar | GEMETEN (DB2 + TT) |
| 21634, 21636, 21637, 21657, 21658 | Test AQ Resource - ... Bandage(s) | testdoos ("Right Click to Open") | GEMETEN (DB2; TT alleen 21634) |
| 211332, 211838, 215419, 220921 | Waylaid Supplies: Heavy ... Bandages | voorraadkist, geen bandage | GEMETEN (DB2, naam) |
| 16112, 16113, 232434 | Manual: ... Bandage | recept | GEMETEN (DB2) |
| 271899, 271900, 271901 | ? | Staan in ItemXItemEffect met de spells 23569 / 23568 / 23567 (de Warsong Gulch-heals 640 / 1104 / 2000), maar hebben GEEN rij in Item of ItemSparse en Wowhead Forever geeft 404 | GEMETEN dat ze ontbreken; wat het is: ONBEKEND (AFGELEID: nog niet uitgegeven items) |

- SpellName 11196 "Recently Bandaged" bestaat in de Forever-DB2. GEMETEN. Dat elke bandage hem geeft en hoe lang hij
  duurt: NIET gemeten in deze ronde.

## 5. Vergelijking met de code (GEMETEN in de bestanden, 24 nov)

- `Modules/ForeverMacros.lua:31` `BANDAGES = { 14530, 14529, 8545, 8544, 6451, 6450, 3531, 3530, 2581, 1251 }`.
  Daar ontbreken **232433 Dense Runecloth Bandage** (beste heal, 3400) en **23684 Crystal Infused Bandage** (2500).
- `Modules/ForeverBagFull.lua:140` noemt 6452 6453 19440 232433 255715 als "bandage or anti-venom" buiten de gewone
  item-klasse. De poultices en tourniquets (255716-255722) zijn ook klasse 7/11, net als 255715, maar staan niet in
  die lijst. Of dat een fout is, hangt af van de bedoeling van die module: niet beoordeeld.

## 6. Lua-blok

Beste eerst (meeste totale heal). `lvl` = RequiredLevel, `skill` = First Aid-rank, beide GEMETEN in DB2
1.60.1.71037. Alleen bandages die overal werken. De keuze om de battleground-bandages apart te houden is AFGELEID:
een macro die "de beste die je draagt" kiest, zou buiten de battleground een bandage kiezen die daar niet werkt.

```lua
bandage = {
	{ item = 232433, lvl = 50, skill = 300 }, -- Dense Runecloth Bandage, 3400 / 8 s
	{ item = 23684, lvl = 0, skill = 225 },   -- Crystal Infused Bandage, 2500 / 10 s
	{ item = 14530, lvl = 0, skill = 225 },   -- Heavy Runecloth Bandage, 2000 / 8 s
	{ item = 14529, lvl = 0, skill = 200 },   -- Runecloth Bandage, 1360 / 8 s
	{ item = 8545, lvl = 0, skill = 175 },    -- Heavy Mageweave Bandage, 1104 / 8 s
	{ item = 8544, lvl = 0, skill = 150 },    -- Mageweave Bandage, 800 / 8 s
	{ item = 6451, lvl = 0, skill = 125 },    -- Heavy Silk Bandage, 640 / 8 s
	{ item = 6450, lvl = 0, skill = 100 },    -- Silk Bandage, 400 / 8 s
	{ item = 3531, lvl = 0, skill = 75 },     -- Heavy Wool Bandage, 301 / 7 s
	{ item = 3530, lvl = 0, skill = 50 },     -- Wool Bandage, 161 / 7 s
	{ item = 2581, lvl = 0, skill = 20 },     -- Heavy Linen Bandage, 114 / 6 s
	{ item = 1251, lvl = 0, skill = 1 },      -- Linen Bandage, 66 / 6 s
},
```

Battleground-bandages, apart (zelfde bron en build; `zone` = de map uit de tooltip):

```lua
bandage_bg = {
	{ item = 19307, lvl = 0, skill = 225, zone = "Alterac Valley" },       -- 2000 / 8 s
	{ item = 19066, lvl = 45, skill = 225, zone = "Warsong Gulch" },       -- 2000 / 8 s
	{ item = 20066, lvl = 45, skill = 225, zone = "Arathi Basin" },        -- 2000 / 8 s
	{ item = 20234, lvl = 45, skill = 225, zone = "Arathi Basin" },        -- 2000 / 8 s, The Defilers
	{ item = 20243, lvl = 45, skill = 225, zone = "Arathi Basin" },        -- 2000 / 8 s, League of Arathor
	{ item = 272058, lvl = 45, skill = 225, zone = "Darkspear Islands" },  -- 2000 / 8 s
	{ item = 19067, lvl = 35, skill = 175, zone = "Warsong Gulch" },       -- 1104 / 8 s
	{ item = 20065, lvl = 35, skill = 175, zone = "Arathi Basin" },        -- 1104 / 8 s
	{ item = 20232, lvl = 35, skill = 175, zone = "Arathi Basin" },        -- 1104 / 8 s, The Defilers
	{ item = 20237, lvl = 35, skill = 175, zone = "Arathi Basin" },        -- 1104 / 8 s, League of Arathor
	{ item = 272057, lvl = 35, skill = 175, zone = "Darkspear Islands" },  -- 1104 / 8 s
	{ item = 19068, lvl = 25, skill = 125, zone = "Warsong Gulch" },       -- 640 / 8 s
	{ item = 20067, lvl = 25, skill = 125, zone = "Arathi Basin" },        -- 640 / 8 s
	{ item = 20235, lvl = 25, skill = 125, zone = "Arathi Basin" },        -- 640 / 8 s, The Defilers
	{ item = 20244, lvl = 25, skill = 125, zone = "Arathi Basin" },        -- 640 / 8 s, League of Arathor
	{ item = 272056, lvl = 25, skill = 125, zone = "Darkspear Islands" },  -- 640 / 8 s
},
```

⚠️ De `zone`-teksten zijn Engels, uit de enUS-tooltip. In een niet-Engelse client heet de map anders; vergelijk dus op
map-id, niet op deze tekst. Alleen Darkspear Islands (Map 2997) is in deze ronde als map-id gemeten.

## 7. Niet gemeten in deze ronde

- Of elk item in Forever echt te krijgen is (vendor, drop, recept). De DB2 en de tooltip zeggen alleen dat het item
  bestaat.
- Waar de Manual voor Dense Runecloth Bandage te krijgen is, en de bron van Crystal Infused Bandage.
- De hoogste First Aid-rank in Forever (de DB2 noemt 300 als hoogste eis op een item).
- Of Darkspear Islands nu speelbaar is.
- De duur van "Recently Bandaged" (11196).
- In de client zelf (Rob in-game) is niets gemeten.
