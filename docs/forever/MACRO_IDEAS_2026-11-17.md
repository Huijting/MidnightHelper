# Forever macro ideas — measured facts (17 Nov 2026)

Research for ten new rows in `Modules/ForeverMacros.lua` (asked by the build chat for Rob). Facts only; the build
chat writes the code. Every claim says **GEMETEN** (seen in a named, dated source) or **AFGELEID** (reasoned).
Nothing here was run in the game client. The Forever Leveling Guide addon was not opened or used.

## 0. Sources and how to read the tags

| Tag | Source | Date |
|---|---|---|
| `DB2:<Table>` | Blizzard client tables, wago.tools CSV, product `wowf`, build **1.60.1.70938**: `https://wago.tools/db2/<Table>?build=1.60.1.70938` (read through `tools/gamedata.py`'s cache) | build listed 13 Nov 2026 |
| `UI:<file>` | Blizzard's own UI source for Forever: `https://github.com/Gethe/wow-ui-source/tree/forever/Interface/AddOns/<file>`, commit `bebcb6bf309cf41b41bd74f8ca651e6a105b2676`, message "1.60.1 (70938)" | 13 Nov 2026 |
| `EXE` | Rob's own client `E:\World of Warcraft\_forever_\Wow.exe`, version string 1.60.1.70938 in the binary, string scan only | file dated 13 Nov 2026 |
| `WH` | Wowhead Forever tooltip JSON `https://nether.wowhead.com/forever/tooltip/spell/<id>` | read 17 Nov 2026 |
| `RB` | Rankedboost `https://rankedboost.com/world-of-warcraft/forever/macros/` | published 25 Sep 2026, updated 13 Nov 2026 |
| `RB-<class>` | `https://rankedboost.com/world-of-warcraft/forever/macros/<class>/` (mage, warlock, hunter, druid, priest, shaman, rogue: published 1 Oct, updated 13 Nov 2026; paladin: 25 Sep, updated 10 Nov 2026) | see left |
| `KL` | Kami-labs `https://kami-labs.fr/en/wow-forever/macros-wow-forever-9-classes/` | published 1 Oct 2026 |
| `CC-<class>` | Conquestcapped `https://conquestcapped.com/guides/wow-forever/wow-forever-<class>-abilities/` (mage, priest, druid, paladin, hunter, warlock) | release 7 Nov 2026 |
| `CC-all` | `https://conquestcapped.com/guides/wow-forever/wow-forever-spells-by-level/` | release 9 Nov 2026 |

Rules used:
- "Learn level" = `SpellLevels.SpellLevel` (`DB2:SpellLevels`). Cross-checked: for every trainer spell in this file
  that RB or CC also names, the level is the same number (Polymorph 8, Evocation 20, Totemic Call 22, Prayer of
  Fortitude 48 …). For a talent the number is not the level you get it (Repentance: table 20, CC says 30).
- "Class spell" = the spell has a `DB2:SkillLineAbility` row with that class's mask. Positive control in the same
  run: 853 Hammer of Justice, 118 Polymorph, 355 Taunt all printed their row.
- "Talent" = the spell id is in `DB2:TraitDefinition` (SpellID / VisibleSpellID / OverridesSpellID). Positive control
  in the same run: Moonkin Form 24858, Trueshot Aura 1299346, Repentance 20066, Prayer of Mending 401859 are found.
  The old `Talent` table still exists (432 rows) but is not the Forever talent system (Divine Spirit and Blessing of
  Kings are in it and are trainer spells now, see idea 2).
- ⚠️ The web pages (RB, KL, CC) were read through a fetch tool that summarises a page. Numbers were checked against
  DB2 where DB2 has them; sentences in quotes are as the tool returned them.
- DB2 cannot say who sells or teaches something (server data). Where that matters it says "not measured".

### 0.1 Base id or rank id — advice for MH

| Fact | Status | Source |
|---|---|---|
| Every rank is its own spell id with the same name; the rank is in `Spell.NameSubtext_lang` ("Rank 1" …) | GEMETEN | `DB2:SpellName`, `DB2:Spell` |
| "`/cast Spell Name` is enough, the game picks the current version on its own"; a macro without a rank number "always casts the highest rank you know" | GEMETEN (guide claim) | KL |
| `FillTpl` writes the NAME of `{id}`, so any rank's id gives the same macro text | GEMETEN | `Modules/ForeverMacros.lua` r.323-346 |
| For the Rogue spells checked (Stealth, Sprint, Vanish, Eviscerate, Slice and Dice, Sap, Gouge, Backstab …), Battle Shout, Prowl and Dire Bear Form each higher rank has `SupercedesSpell` = the rank below. For the caster ranks checked (Shadow Bolt, Polymorph, Fear, the buffs, Conjure, totems, Aspect of the Hawk) it is 0 | GEMETEN | `DB2:SkillLineAbility` |
| Whether `IsPlayerSpell(rank-1 id)` stays true after a rank that supersedes it is trained | **not measured** (MH already relies on it: Sap 6770, Sinister Strike 1752) | — |

**Advice (AFGELEID):** use the **rank-1 (base) id** in `tpl` and in `need`; use rank ids only (a) in `{id:rank}` for
a deliberate low rank and (b) to map a conjure/create rank to its item. Test line for the open point, on a rogue of
level 6 or higher: `/dump IsPlayerSpell(1752), IsSpellKnown(1752)`.

### 0.2 Macro syntax in Forever — what is measured

| Question | Answer | Status | Source |
|---|---|---|---|
| Macro length | 255. String `MACROFRAME_CHAR_LIMIT` = "%d/255 Characters Used"; the edit box is `<EditBox name="MacroFrameText" … letters="255">` | GEMETEN (twice) | `DB2:GlobalStrings`; `UI:Blizzard_MacroUI/Blizzard_MacroUI.xml` line 123 |
| Bytes or characters for `EditMacro` | not measured (matters for ruRU names) | not measured | — |
| Macro slots | `MAX_ACCOUNT_MACROS` 120, `MAX_CHARACTER_MACROS` 30 (ten extra rows count against the 30) | GEMETEN | `UI:Blizzard_APIDocumentationGenerated/MacroConstantsDocumentation.lua` |
| `/use item:<id>` — Lua side | `/use` runs `SecureCmdItemParse(action)`; when `C_Item.GetItemInfo(name)` is non-nil it calls `C_Item.UseItemByName(name, target)`, else `CastSpellByName(action)` | GEMETEN | `UI:Blizzard_ChatFrameBase/Shared/SlashCommands.lua` lines 378-388; `…/Shared/ChatFrameUtil.lua` lines 1212-1236 |
| `/use item:<id>` — does it use the item | The two C functions must accept the text "item:123". Same Lua as retail, where it works. If the item is not in the client cache, GetItemInfo is nil and the line silently does nothing | AFGELEID, not run in the client | — |
| `/castsequence` | Defined: `SecureCmdList["CASTSEQUENCE"]`; `reset=` takes seconds, `target`, `combat`, `shift`/`ctrl`/`alt`; items allowed; resets on death. The file is loaded by the .toc without a game-type limit. String `SLASH_CASTSEQUENCE1` = "/castsequence" | GEMETEN (code exists and loads) | `UI:Blizzard_ChatFrameBase/Shared/CastSequenceManager.lua` lines 129-258; `UI:Blizzard_ChatFrameBase/Blizzard_ChatFrameBase.toc` line 23; `DB2:GlobalStrings` |
| `/castsequence` behaviour | "A step advances only after its cast succeeds … presses during a cast do nothing. The list resets on death." | GEMETEN (guide claim) | RB |
| `!spell` | Blizzard's Forever Lua knows the prefix: cast-sequence names are stripped with `gsub(action, "!*(.*)", "%1")`. The "do not toggle off" part is inside C `CastSpellByName` | Lua part GEMETEN, effect AFGELEID | `UI:…/CastSequenceManager.lua` line 26 |
| `!spell` | "The `!` symbol placed before a form stops a second press from kicking you back out of it." | GEMETEN (guide claim) | KL |
| `[known:…]` | **Not proven.** The macro-option word table sits in the binary as one block (source path `Mainline\Source\Ui\UIMacroOptions.cpp`): overridebar, possessbar, shapeshift, extrabar, canexitvehicle, unithasvehicleui, petbattle, resting, worn, equipped, vehicleui, channeling, actionbar, btn, bonusbar, bar, stealth, mounted, form, stance, outdoors, indoors, flying, swimming, harm, exists, flyable, dead, pvpcombat, talent, house, advflyable. "known" is in the binary once, outside that block — and so are mod, combat, help, pet, group, which MH's existing rows already use. The block has options newer than retail's `known` (house, advflyable) | word list GEMETEN; "it works" AFGELEID | `EXE` (offsets 0x42742B8-0x42744C8; "known" at 0x4170B34) |
| `[form:n]`, `[stance:n]`, `[stealth]`, `[bonusbar:n]` | The words are in that block | GEMETEN (word exists) | `EXE` |
| `#showtooltip` with no argument above a `/use` item list | **Not measured** (C side). RB says: "With no spell name, it shows the spell the macro will cast." MH's Heal row already does this | not measured | RB |
| `/cancelform` | Defined: calls `CancelShapeshiftForm()` | GEMETEN | `UI:…/SlashCommands.lua` lines 414-418 |
| `/petattack`, `/petfollow`, `/petstay`, `/petpassive` | Defined: `PetAttack(target)`, `PetFollow()`, `PetWait()`, `PetPassiveMode()` | GEMETEN | `UI:…/SlashCommands.lua` lines 661-694 |
| `/cancelaura` with a number | `tonumber(spell)` → `C_Spell.CancelSpellByID(id)`; a name still works. So `/cancelaura <spell id>` is language-safe | GEMETEN (Lua) | `UI:…/SlashCommands.lua` lines 402-412 |
| `/tm !8` | "Prefixing with an "!" will prevent toggling the marker if it's already assigned"; `~` = only when the unit has no marker. (The Skull row's comment says this was not measured.) | GEMETEN (Lua) | `UI:…/SlashCommands.lua` lines 1451-1478 |
| Eat and drink on one press | Food spells are category 11, drink spells category 59 (two separate cooldown groups). RB: "`/use YOUR DRINK` `/use YOUR FOOD` — Uses your drink and food together." | categories GEMETEN; one press AFGELEID + guide claim | `DB2:SpellCategories`; RB |

### 0.3 One-line tests for Rob (not run yet)

| What it settles | Line |
|---|---|
| Control for the next line: must print "ja" out of combat | `/run print(SecureCmdOptionParse("[nocombat] ja; nee"))` |
| `[known:]` — on a mage who knows Polymorph it must print "ja"; then try an id the mage does not know (e.g. 5782 Fear), which must print "nee" | `/run print(SecureCmdOptionParse("[known:118] ja; nee"))` |
| Druid form numbers on this character | `/run for i=1,GetNumShapeshiftForms() do print(i,GetShapeshiftFormInfo(i)) end` |
| Rank-1 id still "known" after rank 2 (rogue 6+) | `/dump IsPlayerSpell(1752), IsSpellKnown(1752)` |
| `/use item:<id>` and the icon | make the Heal row with a potion in the bags, put it on a bar, press it |

---

## 1. Eat + drink on one button (Ctrl = mage makes water)

Already in MH: nothing for food or water (DEFS has Heal, Bandage only).

### 1a. Mage Conjure Water / Conjure Food (all class Mage, skill Arcane, not talents)

| Spell | id | Rank | Learn | Makes item (id, item needs level) | Status | Source |
|---|---|---|---|---|---|---|
| Conjure Water | 5504 | 1 | 4 | 5350 Conjured Water (1) | GEMETEN | `DB2:SpellEffect` (effect 24), `DB2:SpellLevels`, `DB2:ItemSparse` |
| Conjure Water | 5505 | 2 | 10 | 2288 Conjured Fresh Water (5) | GEMETEN | same |
| Conjure Water | 5506 | 3 | 20 | 2136 Conjured Purified Water (15) | GEMETEN | same |
| Conjure Water | 6127 | 4 | 30 | 3772 Conjured Spring Water (25) | GEMETEN | same |
| Conjure Water | 10138 | 5 | 40 | 8077 Conjured Mineral Water (35) | GEMETEN | same |
| Conjure Water | 10139 | 6 | 50 | 8078 Conjured Sparkling Water (45) | GEMETEN | same |
| Conjure Water | 10140 | 7 | 60 | 8079 Conjured Crystal Water (55) | GEMETEN | same |
| Conjure Water | 468766 | 8 | 60 | 231778 Mountain Spring Water (55) | GEMETEN in DB2 and WH; **how it is learned: not measured** (CC-mage lists 7 ranks) | same; WH |
| Conjure Food | 587 | 1 | 6 | 5349 Conjured Muffin (1) | GEMETEN | same |
| Conjure Food | 597 | 2 | 12 | 1113 Conjured Bread (5) | GEMETEN | same |
| Conjure Food | 990 | 3 | 22 | 1114 Conjured Rye (15) | GEMETEN | same |
| Conjure Food | 6129 | 4 | 32 | 1487 Conjured Pumpernickel (25) | GEMETEN | same |
| Conjure Food | 10144 | 5 | 42 | 8075 Conjured Sourdough (35) | GEMETEN | same |
| Conjure Food | 10145 | 6 | 52 | 8076 Conjured Sweet Roll (45) | GEMETEN | same |
| Conjure Food | 28612 | 7 | 60 | 22895 Conjured Cinnamon Roll (55) | GEMETEN | same |

- Levels of ranks 1-7 are the same in CC-mage (GEMETEN, second source). RB-mage: Conjure Water from level 4; "Conjured
  items vanish if you stay logged out for more than fifteen minutes"; its water macro tries Crystal first, plain
  Conjured Water last, Ctrl conjures.
- MH: `tpl` = base ids 5504 / 587 (the name casts the highest known rank, 0.1).

### 1b. Plain water, best first (use-spell named "Drink", one effect, no buff)

"Strength" = raw `EffectBasePointsF` of the mana-regen aura; only the ORDER is meant. `b` = `BuyPrice` in copper.
Within a tier all items restore the same; putting conjured first is an AFGELEID choice (free, and it vanishes).
"Sold by a vendor" is **not measured**; the old vendor line has the price series 25/125/500/1000/2000/4000 (GEMETEN).

| Strength | Item needs level | Items (id name) | Status | Source |
|---|---|---|---|---|
| 850 | 55 | 231778 Mountain Spring Water (conjured, rank 8) | GEMETEN | `DB2:ItemSparse`, `ItemEffect`, `ItemXItemEffect`, `SpellEffect` |
| 700 | 55 | 8079 Conjured Crystal Water; 18300 Hyjal Nectar (b4000) | GEMETEN | same |
| 489 | 45 | 8078 Conjured Sparkling Water; **8766 Morning Glory Dew** (b4000); 23161 Freshly-Squeezed Lemonade (b4000); 287964 Morning Glory Dew (needs level 1, new id, what it is: not measured) | GEMETEN | same |
| 332 | 35 | 8077 Conjured Mineral Water; **1645 Moonberry Juice** (b2000); 19300 Bottled Winterspring Water (b2000) | GEMETEN | same |
| 249 | 25 | 3772 Conjured Spring Water; **1708 Sweet Nectar** (b1000); 4791 Enchanted Water; 17405 Green Garden Tea | GEMETEN | same |
| 174 | 15 | 2136 Conjured Purified Water; **1205 Melon Juice** (b500); 9451 Bubbling Water; 19299 Fizzy Faire Drink | GEMETEN | same |
| 104 | 5 | 2288 Conjured Fresh Water; **1179 Ice Cold Milk** (b125); 17404 Blended Bean Brew; 252027 Gustberry Juice (new in Forever, b25) | GEMETEN | same |
| 42 | 1 | 5350 Conjured Water; **159 Refreshing Spring Water** (b25); 252031 Crisp Spring Water (new in Forever, b25) | GEMETEN | same |

Flat list, best first: `231778, 8079, 18300, 8078, 8766, 23161, 287964, 8077, 1645, 19300, 3772, 1708, 4791, 17405,
2136, 1205, 9451, 19299, 2288, 1179, 17404, 252027, 5350, 159, 252031`.
Left out on purpose: drinks with a second effect (19318 Bottled Alterac Spring Water, 13813 Blessed Sunfruit Juice,
holiday drinks) and items flagged deprecated.

### 1c. Plain food, best first (use-spell named "Food", one effect, no buff)

**Bold** = the old six vendor lines (meat, cheese, fruit, bread, mushroom; price series as above — vendor status
AFGELEID). ⚠️ The cooked-fish vendor line (787, 4592, 4593, 4594, 6887) is buff food in Forever ("Nutritious Food",
GEMETEN in `DB2:SpellName`) and is not in this list.

| Strength | Item needs level | Items (id name) | Status | Source |
|---|---|---|---|---|
| 530 | 55 | 22895 Conjured Cinnamon Roll | GEMETEN | `DB2:` same tables as 1b |
| 358 | 45 | 8076 Conjured Sweet Roll; **8952 Roasted Quail; 8932 Alterac Swiss; 8953 Deep Fried Plantains; 8950 Homemade Cherry Pie; 8948 Dried King Bolete**; 11415 Mixed Berries; 11444 Grim Guzzler Boar; 12763 Un'Goro Etherfruit; 16171 Shinsollo; 19225 Deep Fried Candybar; 21031 Cabbage Kimchi; 21033 Radish Kimchi; 22324 Winter Kimchi; 23160 Friendship Bread; 250081 Clam Linguine; 260627 Savory Shen'dralar Steak; 260628 Stuffed Pumpkin; 278122 Carrot Salad; 287963 Roasted Quail (needs level 1, new id) | GEMETEN | same |
| 232 | 35 | 8075 Conjured Sourdough; **4599 Cured Ham Steak; 3927 Fine Aged Cheddar; 4602 Moon Harvest Pumpkin; 4601 Soft Banana Bread; 4608 Raw Black Truffle**; 9681 Grilled King Crawler Legs; 16168 Heaven Peach; 16766 Undermine Clam Chowder; 17408 Spicy Beefstick; 18635 Bellara's Nutterbar; 19306 Crunchy Frog; 21030 Darnassus Kimchi Pie; 21552 Striped Yellowtail; 260624 Pristine Peach; 260625 Garnished Rice Cake; 13546 Bloodbelly Fish (25); needs 45: 13893 Large Raw Mightfish, 18255 Runn Tum Tuber, 249796 Hyjal Berries | GEMETEN | same |
| 162 | 25 | 1487 Conjured Pumpernickel; **3771 Wild Hog Shank; 1707 Stormwind Brie; 4539 Goldenbark Apple; 4544 Mulgore Spice Bread; 4607 Delicious Cave Mold**; 6807 Frog Leg Stew; 16169 Wild Ricecake; 17407 Graccu's Homemade Meat Pie; 18632 Moonbrook Riot Taffy; 19224 Red Hot Wings; 260623 Candied Fruit Sampler; 278118 Rich Broth; 278120 Fruit Platter; 13755 Raw Winter Squid (35) | GEMETEN | same |
| 115 | 15 | 1114 Conjured Rye; **3770 Mutton Chop; 422 Dwarven Mild; 4538 Snapvine Watermelon; 4542 Moist Cornbread; 4606 Spongy Morel**; 5478 Dig Rat Stew; 5845 Flank of Meat; 7228 Tigule's Strawberry Ice Cream; 16170 Steamed Mandu; 19305 Pickled Kodo Foot; 248613 Lightning in a Bottle; 278121 Smoked Sausage | GEMETEN | same |
| 58 | 5 | 1113 Conjured Bread; **2287 Haunch of Meat; 414 Dalaran Sharp; 4537 Tel'Abim Banana; 4541 Freshly Baked Bread; 4605 Red-speckled Mushroom**; 1326 Sauteed Sunfish; 5066 Fissure Plant; 5526 Clam Chowder; 12238 Darkshore Grouper; 16167 Versicolor Treat; 17119 Deeprun Rat Kabob; 17406 Holiday Cheesewheel; 18633 Styleen's Sour Suckerpop; 19304 Spiced Beef Jerky; 252026 Gustberry Pie; 252029 Hippogryph Flank; 252030 Pungent Skycheddar; 252032 Red Delicious Stormapple; 278117 Hard Boiled Eggs | GEMETEN | same |
| 17 | 1 | 5349 Conjured Muffin; **117 Tough Jerky; 2070 Darnassian Bleu; 4536 Shiny Red Apple; 4540 Tough Hunk of Bread; 4604 Forest Mushroom Cap**; 961 Healing Herb; 2679 Charred Wolf Meat; 4656 Small Pumpkin; 5057 Ripe Watermelon; 5525 Boiled Clams; 7097 Leg Meat; 16166 Bean Soup; 17344 Candy Cane; 19223 Darkmoon Dog; 251917 Falorne's Homemade Tart; 252022 Galestrider Jerky; 252023 Zaalanarr Sharp; 252028 Fresh Gustberry Bread; 267474 Galeswept Forestshroom; 278119 Bread with Butter; 278569 Yesterday's Leftovers | GEMETEN | same |

- Not in the table: raw fish that can be eaten (item class 7, e.g. 6289, 6308, 6362, 4603, 13754-13760, 8959, 13888,
  13889), 3448 Senggin Root (restores health and mana, strength 70), and all food with a second effect (well-fed
  food, battleground rations, holiday candy). 385 items in total have a food or drink use-spell (GEMETEN count).
- ⚠️ A character can carry food it is too low to eat. The tier's "needs level" is in the table; MH should skip a
  carried item above the player's level (AFGELEID advice).

---

## 2. Buff: mouse target → target → yourself, Ctrl = group version

Already in MH: Druid row "Wild Buffs" (`{21849}` Gift on Shift, `{467}` Thorns on Ctrl, `{1126}` Mark).

| Spell | Class | Base id (learn) | Higher ranks: id (learn) | Talent? | Group version: id (learn), reagent | Status | Source |
|---|---|---|---|---|---|---|---|
| Arcane Intellect | Mage | 1459 (1) | 1460 (14), 1461 (28), 10156 (42), 10157 (56) | no | Arcane Brilliance 23028 (56), 1× 17020 Arcane Powder | GEMETEN | `DB2:SpellName`, `SpellLevels`, `SkillLineAbility`, `SpellReagents`; levels also CC-mage, RB-mage |
| Power Word: Fortitude | Priest | 1243 (1) | 1244 (12), 1245 (24), 2791 (36), 10937 (48), 10938 (60) | no | Prayer of Fortitude 21562 (48), 1× 17028 Holy Candle; rank 2 21564 (60), 1× 17029 Sacred Candle | GEMETEN | same; CC-priest, RB-priest |
| Divine Spirit | Priest | 14752 (30) | 14818 (40), 14819 (50), 27841 (60) | **no** (not in TraitDefinition) | Prayer of Spirit 27681 (60), 1× 17029 Sacred Candle | GEMETEN | same; RB-priest: "Every Priest learns Divine Spirit at level thirty in WoW Forever; it is no longer a talent." |
| Shadow Protection | Priest | 976 (30) | 10957 (42), 10958 (56) | no | Prayer of Shadow Protection 27683 (56), 1× 17029 Sacred Candle | GEMETEN | same; CC-priest |
| Mark of the Wild | Druid | 1126 (1) | 5232 (10), 6756 (20), 5234 (30), 8907 (40), 9884 (50), 9885 (60) | no | Gift of the Wild 21849 (50), 1× 17021 Wild Berries; rank 2 21850 (60), 1× 17026 Wild Thornroot | GEMETEN | same; CC-druid |
| Thorns | Druid | 467 (6) | 782 (14), 1075 (24), 8914 (34), 9756 (44), 9910 (54) | no | none | GEMETEN | same; CC-druid |
| Blessing of Might | Paladin | 19740 (4) | 19834 (12), 19835 (22), 19836 (32), 19837 (42), 19838 (52), 25291 (60) | no | Greater Blessing of Might 25782 (52), rank 2 25916 (60); 1× 21177 Symbol of Kings | GEMETEN | same; CC-paladin |
| Blessing of Wisdom | Paladin | 19742 (14) | 19850 (24), 19852 (34), 19853 (44), 19854 (54), 25290 (60) | no | Greater Blessing of Wisdom 25894 (54), rank 2 25918 (60); 1× 21177 Symbol of Kings | GEMETEN | same; CC-paladin |
| Blessing of Kings | Paladin | 20217 (20) | — | **no** (not in TraitDefinition) | Greater Blessing of Kings 25898 (60); 1× 21177 Symbol of Kings | GEMETEN | same; CC-paladin: "Consecration and Blessing of Kings no longer need a talent." |

More facts:

| Fact | Status | Source |
|---|---|---|
| All group versions above exist in Forever as class spells and on Wowhead Forever (checked there: 23028, 21562, 21849, 25898) | GEMETEN | `DB2:SkillLineAbility`; WH |
| Blessing of Salvation, Blessing of Sanctuary, Greater Blessing of Salvation/Sanctuary/Light: no spell with that name in the game data at all; Blessing of Light exists only as 26650 without a class row | GEMETEN (same run found Blessing of Might) | `DB2:SpellName` |
| "Blessing of Salvation and Greater Blessing of Salvation were removed, together with Blessing of Light and Sense Undead." | GEMETEN (guide claim) | CC-paladin |
| A Greater Blessing goes to "all members of the raid or group that share the same class with the target" — it is a per-class buff, not a whole-party buff | GEMETEN | `DB2:Spell` (description of 25782, 25894, 25898) |
| Arcane Brilliance / Prayer of Fortitude / Gift of the Wild reach "the target's party and raid" / "all party and raid members" | GEMETEN | `DB2:Spell` |
| Trainer or book? "Every class in WoW Forever learns its spells from a class trainer." Arcane Brilliance: source "Class trainer". Priest, druid, paladin group buffs sit in the same level tables without a quest mark | GEMETEN (guide claim) | CC-all, CC-mage, CC-priest, CC-druid, CC-paladin |
| The old books still exist as items that teach these spells and are not flagged deprecated: 18600 Tome of Arcane Brilliance, 17413 / 17414 Codex: Prayer of Fortitude (II), 22393 Codex: Prayer of Shadow Protection, 17682 / 17683 Book: Gift of the Wild (II). No such item for Prayer of Spirit or the Greater Blessings | GEMETEN (item exists) | `DB2:ItemEffect` (trigger type 6), `ItemSparse` |
| Do those books still drop, and does the trainer teach the spell without them | **not measured** (server data) | — |
| Blessings last 1 hour ("Blessings now last 1 hour instead of 5 minutes") | GEMETEN (guide claim); the Wowhead tooltips of 20217 and 25898 also say 1 hour | CC-paladin; WH |

MH: base ids in the table are the `need`. A Ctrl press without the reagent fails; MH can count the reagent item
with its `Count()` (AFGELEID advice). For MH it makes no difference whether trainer or book: `need` asks the client.

---

## 3. Healthstone, Soulstone, Mana Gem

Already in MH: `STONES = { 9421, 5510, 5509, 5511, 5512 }` in the Heal row.

### 3a. Warlock (skill Demonology, not talents; every create spell costs 1× 6265 Soul Shard)

| Spell | id | Rank | Learn | Makes item | Status | Source |
|---|---|---|---|---|---|---|
| Create Healthstone | 6201 | 1 | 10 | 5512 Minor Healthstone (item needs 1) | GEMETEN (description names the stone) | `DB2:Spell`, `SpellLevels`, `SpellReagents` |
| Create Healthstone | 6202 | 2 | 22 | 5511 Lesser Healthstone (12) | level GEMETEN; stone per rank AFGELEID (order) | same |
| Create Healthstone | 5699 | 3 | 34 | 5509 Healthstone (24) | same | same |
| Create Healthstone | 11729 | 4 | 46 | 5510 Greater Healthstone (36) | same | same |
| Create Healthstone | 11730 | 5 | 58 | 9421 Major Healthstone (48) | same | same |
| Create Soulstone | 693 | 1 | 18 | 5232 Minor Soulstone | GEMETEN | `DB2:SpellEffect` (effect 24) |
| Create Soulstone | 20752 | 2 | 30 | 16892 Lesser Soulstone | GEMETEN | same |
| Create Soulstone | 20755 | 3 | 40 | 16893 Soulstone | GEMETEN | same |
| Create Soulstone | 20756 | 4 | 50 | 16895 Greater Soulstone | GEMETEN | same |
| Create Soulstone | 20757 | 5 | 60 | 16896 Major Soulstone | GEMETEN | same |

- The five trainable Create Healthstone spells have a script effect (77), not a create-item effect; the items come
  from helper spells 23517-23519 (Minor), 23520-23522 (Lesser), 23813-23815 (Healthstone), 23816-23818 (Greater),
  23819-23821 (Major). GEMETEN (`DB2:SpellEffect`).
- Those helpers also make ten variant stones with the same names: 19004, 19005 (Minor), 19006, 19007 (Lesser),
  19008, 19009 (Healthstone), 19010, 19011 (Greater), 19012, 19013 (Major). GEMETEN. In Classic they came from the
  Improved Healthstone talent; **no talent with "Healthstone" in its name is in Forever's TraitDefinition** (GEMETEN,
  same run found Improved Sprint and Improved Slice and Dice), so the variants are probably never made (AFGELEID).
- Raw heal value per stone (`EffectBasePointsF`): 5512 = 120, 5511 = 300, 5509 = 600, 5510 = 960, 9421 = 1440;
  variants 19004 = 110, 19005 = 120, 19006 = 275, 19007 = 300, 19008 = 550, 19009 = 600, 19010 = 880, 19011 = 960,
  19012 = 1320, 19013 = 1440. GEMETEN (`DB2:SpellEffect`).
- **Healthstone, best first:** `9421, 5510, 5509, 5511, 5512` (as MH has). With variants, harmless to add:
  `9421, 19013, 19012, 5510, 19011, 19010, 5509, 19009, 19008, 5511, 19007, 19006, 5512, 19005, 19004`.
- **Soulstone, best first:** `16896, 16895, 16893, 16892, 5232`. Use-spell "Soulstone Resurrection" (20765, 20764,
  20763, 20762, 20707), 30-minute shared cooldown (`CategoryCoolDownMSec` 1800000). GEMETEN (`DB2:ItemEffect`).
- Levels of all ten ranks are the same in CC-warlock. RB-warlock: "Healthstones share one cooldown, so each press
  eats one stone"; "Create Healthstone takes a three second cast and a Soul Shard"; "A dead target gets nothing, so
  stone your healer before the pull." (guide claims)
- Healthstones and mana gems carry the same item cooldown group (`SpellCategoryID` 1153, 120 s). GEMETEN
  (`DB2:ItemEffect`).

### 3b. Mage (skill Arcane, not talents, no reagent) — each gem is a different spell NAME

| Spell | id | Learn | Makes item (item needs level) | Raw mana value | Status | Source |
|---|---|---|---|---|---|---|
| Conjure Mana Agate | 759 | 28 | 5514 Mana Agate (23) | 400 | GEMETEN | `DB2:SpellEffect`, `SpellLevels`, `ItemSparse` |
| Conjure Mana Jade | 3552 | 38 | 5513 Mana Jade (38) | 600 | GEMETEN | same |
| Conjure Mana Citrine | 10053 | 48 | 8007 Mana Citrine (48) | 850 | GEMETEN | same |
| Conjure Mana Ruby | 10054 | 58 | 8008 Mana Ruby (58) | 1100 | GEMETEN | same |
| Evocation | 12051 | 20 | — (8-minute cooldown: `RecoveryTime` 480000) | — | GEMETEN | `DB2:SpellLevels`, `SpellCooldowns`; RB-mage, CC-mage |

- **Gem, best first:** `8008, 8007, 5513, 5514`. Levels also in RB-mage and CC-mage. No spell named "Conjure Mana
  Gem" or "Conjure Mana Emerald" exists (GEMETEN, `DB2:SpellName`).
- "Ctrl = make a gem" needs the highest KNOWN conjure spell: check 10054, 10053, 3552, 759 in that order (AFGELEID).

---

## 4. Hunter aspects (skill Beast Mastery, none is a talent)

Already in MH: `!{13163}` (Monkey) in the Deterrence spec row.

| Aspect | Base id | Learn | Higher ranks: id (learn) | Obtainable | Status | Source |
|---|---|---|---|---|---|---|
| Monkey | 13163 | 4 | — | trainer | GEMETEN | `DB2:SkillLineAbility`, `SpellLevels`; RB-hunter, CC-hunter |
| Hawk | 13165 | 10 | 14318 (18), 14319 (28), 14320 (38), 14321 (48), 14322 (58), 25296 (60) | trainer | GEMETEN | same |
| Cheetah | 5118 | 20 | — | trainer | GEMETEN | same |
| Beast | 13161 | 30 | 1299445 (40), 1299446 (50), 1299447 (60) — new Forever ids | trainer | GEMETEN | `DB2`; CC-hunter |
| Pack | 13159 | 40 | — | trainer | GEMETEN | `DB2`; RB-hunter, CC-hunter |
| Wild | 20043 | 46 | 20190 (56) | trainer | GEMETEN | `DB2`; CC-hunter |
| Viper | 415423 | 1 (in the table) | — | **not measured** — a Hunter class row and a Wowhead Forever page exist, but RB-hunter and CC-hunter do not list it | exists GEMETEN, obtainable unknown | `DB2`; WH |
| Falcon | 469145 | 60 | — | **not measured**, same as Viper | exists GEMETEN, obtainable unknown | `DB2`; WH |

- "Only one aspect can be active at a time, so each press swaps the other off." "Cheetah dazes you when you take
  damage." (guide claims, RB-hunter; the DB2 descriptions say the same.)
- Beast in Forever: "becoming untrackable and increasing Melee Attack Power" (GEMETEN, `DB2:Spell` 13161).
- Advice (AFGELEID): leave Viper and Falcon out, or give them their own `need` so they stay hidden until known.

---

## 5. Druid: leave form, Prowl from any form, form numbers

Already in MH: Travel row (`[swimming] {1066}; [outdoors] {783}; {768}`, warn "formbar"), `/cancelform` in four rows.

| Spell | id | Learn | How learned | Form id | StanceBarOrder | Status | Source |
|---|---|---|---|---|---|---|---|
| Bear Form | 5487 | 10 | class quest (CC-druid) | 5 | no row | GEMETEN (ids, level); quest = guide claim | `DB2:SpellEffect` (aura 36), `SpellShapeshift`, `SpellLevels`; CC-druid |
| Dire Bear Form | 9634 | 40 | trainer; supersedes 5487 | 8 | 0 | GEMETEN | same |
| Aquatic Form | 1066 | 16 | class quest chain (CC-druid) | 4 | 1 | GEMETEN | same |
| Cat Form | 768 | 20 | class quest (CC-druid) | 1 | 2 | GEMETEN | same |
| Travel Form | 783 | 30 | trainer | 3 | 3 | GEMETEN | same |
| Moonkin Form | 24858 | talent (TraitDefinition 134257, 134398, 137673) | Balance talent | 31 | 4 | GEMETEN | `DB2:TraitDefinition`; CC-druid |
| Prowl | 5215 | 20 | rank 1 with Cat Form; 6783 (40), 9913 (60), each supersedes the one before | — (needs Cat Form: `ShapeshiftMask_0` = 1) | — | GEMETEN | `DB2:SpellShapeshift`, `SkillLineAbility` |

| Fact | Status | Source |
|---|---|---|
| Order on the form bar by `StanceBarOrder`: Bear/Dire Bear, Aquatic, Cat, Travel, Moonkin | GEMETEN | `DB2:SpellShapeshift` |
| `[form:n]` = the n-th form **this character knows**, in that order. All four known: Bear 1, Aquatic 2, Cat 3, Travel 4, Moonkin 5. Without Aquatic: Cat 2, Travel 3, Moonkin 4 | AFGELEID (from the order + the two guide claims below), not run in the client | — |
| "[form:n] and [stance:n]: True in the stance or form at that position on your stance bar, counted from the left among those you know." | GEMETEN (guide claim) | RB |
| Example `/cast [noform:3] !Cat Form` + `/cast [form:3] Dash`; the 3 "matches the order in which you learned your forms: if nothing happens, swap it for 2" | GEMETEN (guide claim) | KL |
| Bear, Aquatic and Cat come from class quests, so a druid can miss one and the numbers shift | GEMETEN (guide claim) | CC-druid |
| The client tells the real number: Blizzard's own form bar loops `GetNumShapeshiftForms()` and reads `texture, isActive, isCastable, spellID = GetShapeshiftFormInfo(i)` | GEMETEN (API used in Forever's UI) | `UI:Blizzard_ActionBar/Shared/StanceBar.lua` lines 61-70, 154-155 |
| Bonus action bar per form: Cat 1, Bear and Dire Bear 3, all other druid forms 0 (so `[bonusbar:1]` = Cat) | number GEMETEN; the conditional's result AFGELEID | `DB2:SpellShapeshiftForm` |
| Shifting and then casting takes two presses ("shifting form triggers its own global cooldown") | GEMETEN (guide claim) | KL |
| Warrior for comparison: Battle (no row), Defensive 1, Berserker 2 — MH's `[stance:1..3]` rows fit that | GEMETEN | `DB2:SpellShapeshift` |
| Tree of Life 439733 is in the data (form 2, order 4) but "is not a Druid talent or trainer spell in WoW Forever" | data GEMETEN; not available = guide claim | `DB2`; CC-druid |

**Advice (AFGELEID):** do not hard-code the cat number. At build time find `i` where `GetShapeshiftFormInfo(i)`
returns spell 768 and write `[form:i]` / `[noform:i]`; rebuild when forms change. "Leave form" needs no number:
`/cancelform`.

---

## 6. Warlock: Shadow Bolt + /petattack, Ctrl = /petfollow

Already in MH: `/petattack` in the Searing Pain spec row, `/petfollow` in the Fear row.

| Spell | Base id | Learn | Higher ranks: id (learn) | Talent? | Status | Source |
|---|---|---|---|---|---|---|
| Shadow Bolt | 686 | 1 (known from the start: `AcquireMethod` 2) | 695 (6), 705 (12), 1088 (20), 1106 (28), 7641 (36), 11659 (44), 11660 (52), 11661 (60), 25307 (60) | no | GEMETEN | `DB2:SkillLineAbility`, `SpellLevels`; CC-warlock |

- `/petattack [cond] ` → `PetAttack(target)`, `/petfollow` → `PetFollow()`. GEMETEN (`UI:…/SlashCommands.lua` 661-675).
- RB-warlock has exactly this idea: "Each Shadow Bolt also sends your demon at your target." "Ctrl casts nothing at
  all, so it is a safe way to pull your demon out of a fight." (guide claims)

---

## 7. Resurrect on the mouse target

Already in MH: Druid spec row "Rebirth" (`{20484}` in combat, `{437138}` out of combat).

| Spell | Class | Base id | Learn | Higher ranks: id (learn) | In combat? | Status | Source |
|---|---|---|---|---|---|---|---|
| Resurrection | Priest | 2006 | 10 | 2010 (22), 10880 (34), 10881 (46), 20770 (58) | no ("Cannot be cast when in combat") | GEMETEN | `DB2:Spell`, `SpellLevels`; RB-priest, CC-priest |
| Ancestral Spirit | Shaman | 2008 | 12 | 20609 (24), 20610 (36), 20776 (48), 20777 (60) | no | GEMETEN | `DB2`; RB-shaman |
| Redemption | Paladin | 7328 | 12 | 10322 (24), 10324 (36), 20772 (48), 20773 (60) | no | GEMETEN | `DB2`; CC-paladin |
| Revive | Druid | 437138 | 12 | 1237948 (24), 1237949 (36), 1237950 (48), 1237951 (60) | no | GEMETEN | `DB2`; CC-druid |
| Rebirth | Druid | 20484 | 20 | 20739 (30), 20742 (40), 20747 (50), 20748 (60) | yes; 1× 17034 Maple Seed (rank 1), 30-minute cooldown | GEMETEN | `DB2:SpellReagents`, `SpellCooldowns` |

None is a talent. `dead`, `help`, `exists` are in the client's option word list (GEMETEN, `EXE`).

---

## 8. Crowd control on the focus

Already in MH: Mage Polymorph (focus → mouse → target), Warlock Fear (Ctrl = Banish), Rogue Sap and Blind.

| Spell | Class | Base id | Learn | Higher ranks: id (learn) | Talent? | Works on | Status | Source |
|---|---|---|---|---|---|---|---|---|
| Polymorph | Mage | 118 | 8 | 12824 (20), 12825 (40), 12826 (60); 28271 Turtle (60), 28272 Pig (60) | no | Beasts, Humanoids, Critters | GEMETEN | `DB2:Spell`, `SpellLevels`; RB-mage |
| Shackle Undead | Priest | 9484 | 20 | 9485 (40), 10955 (60) | no | Undead | GEMETEN | `DB2`; RB-priest, CC-priest |
| Hibernate | Druid | 2637 | 18 | 18657 (38), 18658 (58) | no | Beasts, Dragonkin | GEMETEN | `DB2`; CC-druid |
| Fear | Warlock | 5782 | 8 | 6213 (32), 6215 (56) | no | one target | GEMETEN | `DB2`; RB-warlock |
| Banish | Warlock | 710 | 28 | 18647 (48) | no | Demons, Elementals (RB-warlock) | GEMETEN | `DB2`; RB-warlock |
| Sap | Rogue | 6770 | 10 | 2070 (28), 11297 (48), each supersedes | no | Humanoids out of combat; "Does not break Stealth" | GEMETEN | `DB2` |
| Freezing Trap | Hunter | 1499 | 20 | 14310 (40), 14311 (60) | no | placed at your feet — a trap has no target, so no focus line | GEMETEN | `DB2`; RB-hunter: "Traps can now be laid in combat" |
| Entangling Roots | Druid | 339 | 8 | 1062 (18), 5195 (28), 5196 (38), 9852 (48), 9853 (58) | no | — | GEMETEN | `DB2`; CC-druid |
| Scare Beast | Hunter | 1513 | 14 | 14326 (30), 14327 (46) | no | Beasts | GEMETEN | `DB2`; CC-hunter |
| Turn Undead | Paladin | 2878 | 24 | 5627 (38), 10326 (52) | no | Undead | GEMETEN | `DB2`; CC-paladin |
| Repentance | Paladin | 20066 | talent (TraitDefinition 135224) | — | **yes** | — | GEMETEN | `DB2:TraitDefinition` |
| Wyvern Sting | Hunter | — | not a player spell in Forever (five ids, none with a class row) | — | — | — | GEMETEN | `DB2:SkillLineAbility`; CC-hunter |

RB's pattern for "CC that remembers its enemy": `/focus [@focus,noexists][@focus,dead][mod:ctrl] target`, then cast
on focus, else target (guide claim, RB). `/focus` and `/clearfocus` are defined (GEMETEN, `DB2:GlobalStrings`).

---

## 9. Rogue: Stealth, Sprint, Vanish, Eviscerate, Slice and Dice (none is a talent)

Already in MH: Opener row, Sap row (`!{1784}`), Preparation spec row (`{1856}`, `{5277}`, `{2983}`).

| Spell | Base id | Learn | Higher ranks: id (learn) — each supersedes the one before | Notes | Status | Source |
|---|---|---|---|---|---|---|
| Stealth | 1784 | 1 | 1785 (20), 1786 (40), 1787 (60) | no global cooldown, 10 s cooldown group | GEMETEN | `DB2:SkillLineAbility`, `SpellLevels`, `SpellCooldowns`; RB-rogue |
| Sprint | 2983 | 10 | 8696 (34), 11305 (58) | "Does not break stealth"; no global cooldown; 5 min | GEMETEN | `DB2`; RB-rogue |
| Vanish | 1856 | 22 | 1857 (42) | 1× 5140 Flash Powder; no global cooldown; 5 min | GEMETEN | `DB2:SpellReagents`; RB-rogue |
| Eviscerate | 2098 | 1 (known from the start: `AcquireMethod` 2) | 6760 (8), 6761 (16), 6762 (24), 8623 (32), 8624 (40), 11299 (48), 11300 (56), 31016 (60) | finishing move | GEMETEN | `DB2`; RB-rogue |
| Slice and Dice | 5171 | 10 | 6774 (42) | finishing move | GEMETEN | `DB2`; RB-rogue |

- RB-rogue: "Neither Vanish nor Sprint triggers the global cooldown, so both fire together." RB writes Stealth as
  `/cast [nostealth] Stealth` (no "!"); MH writes `!{1784}`. Both forms are AFGELEID to work; neither was run.
- All five have superseding ranks → this is the place where the open point of 0.1 bites first.

---

## 10. Shaman: Totemic Call / Recall, Searing Totem, Magma Totem (none is a talent)

Already in MH: Totems row (`[mod:shift] {36936}; [mod:ctrl] {437009}; {66842}`), Fire Nova row (`{3599}` on Shift).

| Spell | Base id | Learn | Higher ranks: id (learn) | What it does | Status | Source |
|---|---|---|---|---|---|---|
| Totemic Recall | 36936 | 20 | — | "Returns your totems to the earth, giving you 25% of the mana" of each; no cooldown | GEMETEN | `DB2:Spell`, `SpellLevels`; WH; RB-shaman |
| Totemic Call | 437009 | 22 | — | "Relocates your active totems to your location."; 30 s cooldown; 25% of base mana | GEMETEN | `DB2`, `DB2:SpellCooldowns`; WH; RB-shaman |
| Call of the Elements | 66842 | 20 | — | places up to 4 totems set in the Totem Bar | GEMETEN | `DB2`; RB-shaman |
| Call of the Ancestors | 66843 | 30 | — | second set | GEMETEN | `DB2`; RB-shaman |
| Call of the Spirits | 66844 | 40 | — | third set | GEMETEN | `DB2` |
| Searing Totem | 3599 | 10 | 6363 (20), 6364 (30), 6365 (40), 10437 (50), 10438 (60) | one enemy | GEMETEN | `DB2`; RB-shaman |
| Magma Totem | 8190 | 26 | 10585 (36), 10586 (46), 10587 (56) | area around the totem | GEMETEN | `DB2`; RB-shaman |
| Fire Nova | 408341 | 12 | 408342 (22), 408343 (32), 408344 (42), 408345 (52) | "Fire Nova Totem is gone; Fire Nova is a level twelve spell that bursts from your Fire totem." | GEMETEN | `DB2`; RB-shaman |

**Both exist and are different spells:** Recall removes the totems and refunds mana; Call moves them to you.
"Totemic Call is a trainer spell from level twenty two"; "Totemic Recall and three Call spells … are new trainer
spells." (guide claims, RB-shaman). RB's own totem macro: plain = Totemic Call, Ctrl = Totemic Recall.

---

## 11. Open points (not measured — say so in the code comments)

1. **`/use item:<id>`, `!spell`, `[known:]`, `[form:n]`, `#showtooltip` on an item list**: Lua side and word lists
   are measured, the behaviour is not. Tests in 0.3.
2. **Rank-1 id as `need` when a rank supersedes it** (rogue, warrior, Prowl, Dire Bear): not measured; one `/dump`.
3. **Aspect of the Viper (415423) and Falcon (469145)**: in the data, not in the two guides' trainer lists.
4. **Conjure Water rank 8 (468766 → 231778)**: in the data and on Wowhead Forever, not in CC's rank list.
5. **Trainer or book** for Arcane Brilliance, Prayer of Fortitude, Gift of the Wild, Prayer of Shadow Protection:
   one guide site says trainer; the old books still exist as items. Not measured in game. No effect on `need`.
6. **Vendor status** of every food and water item: not measured (server data). 287963 / 287964 (level-1 copies of
   Roasted Quail / Morning Glory Dew): unknown what they are.
7. **Healthstone variants 19004-19013**: probably never created (no Improved Healthstone talent found).
8. **Druid form numbers**: computed from DB2 order, not seen in the client; read them from the client instead.
9. **Bytes or characters** in the 255 limit for `EditMacro`: not measured.
10. Web guides were read through a summarising fetch tool; their sentences are claims, not client measurements.

Raw dumps of this run (temporary, session scratchpad): `fmi_spells_out.txt`, `fmi_items_out.txt`,
`fmi_more_out.txt`, and the fetched UI files under `ui_forever/`.
