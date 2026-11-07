# WoW Forever (client 1.60.1): main primary stats per class while LEVELING (1-60)

Research date: 7 Nov 2026 (Forever has been live since 4 Nov 2026). Read-only research for Midnight Helper; nothing in the repo was read or changed.

- **GEMETEN** = read in the named source (URL + date given).
- **AFGELEID** = my own reasoning from GEMETEN facts.
- An empty search proves nothing. Where I found nothing, I say "not found", not "does not exist".
- Classic Era guides were **not used as a source** for any row. Every "Forever vs Classic" remark below comes from Blizzard's own "was X" lines or from comparing the Forever client with the Classic Era client.

---

## 0. Bottom line (short)

1. **The Forever client has no primary stat per class or spec.** MH must ship its own table (section 7). GEMETEN, see 1a.
2. **Agility gives melee Attack Power only to Hunters and Rogues (and Druids in Cat Form).** Warriors get only ranged AP from it. Shamans and Paladins get no AP from Agility. GEMETEN client strings + Icy Veins, see 1b.
3. **Forever's big change is Intellect.** Talents turn it into Attack Power (Enhancement Shaman, Hunter) or spell damage (Retribution Paladin). That is why some guides now put Intellect above Strength for Ret and Enhancement. GEMETEN Blizzard, see 2.
4. **Spirit gained new uses.** Life Tap scales with Spirit, and many specs got "Spirit regen while casting" talents. GEMETEN Blizzard, see 2.
5. Guides mostly agree on pure classes. They disagree on Ret Paladin, Enhancement Shaman and caster Spirit vs Intellect (section 5). The table takes the stats that sit in the top two in most named sources, and says where it chose.

---

## 1. Hard facts from the Forever client (wago.tools)

Source [WG]: wago.tools DB2 tables for Forever build **1.60.1.70862** (wago "Detected At 2026-11-07 04:43", branch `wowf`), and Classic Era build **1.15.9.70576** for comparison. All read 2026-11-07.

### 1a. No primary stat in the client — GEMETEN

`https://wago.tools/db2/ChrSpecialization?build=1.60.1.70862`
- The table has exactly one row per class (Mage 1482, Druid 1484, Hunter 1485, Paladin 1486, Priest 1487, Rogue 1488, Shaman 1489, Warlock 1490, Warrior 1491). Every one has `PrimaryStatPriority = 0` and Role "2 (DPS)".
- There are no rows for the 27 talent trees.
- Positive control in the same read: the pet row "Default" (1493) has `PrimaryStatPriority = 3`, so the column is read correctly.
- AFGELEID: an addon cannot ask the Forever client "what is my primary stat". A spec API cannot tell the role either, because there are no spec rows. MH needs its own table.

### 1b. Stat tooltip strings — GEMETEN

`https://wago.tools/db2/GlobalStrings?build=1.60.1.70862` with BaseTag filters `_AGILITY_TOOLTIP`, `STRENGTH_TOOLTIP`, `INTELLECT_TOOLTIP`, `SPIRIT_TOOLTIP`, `STAMINA_TOOLTIP`, and text filter "Attack Power".

| String (ID) | What it lists (shortened, colour codes removed) |
|---|---|
| DEFAULT_AGILITY_TOOLTIP (14239) | Critical Strike, Armor, Dodge — **no Attack Power line** |
| HUNTER_AGILITY_TOOLTIP (14243) | Crit, **Attack Power**, **Ranged Attack Power**, Armor, Dodge |
| ROGUE_AGILITY_TOOLTIP (14257) | Crit, **Attack Power**, **Ranged Attack Power**, Armor, Dodge |
| DRUID_AGILITY_TOOLTIP (59037) | Crit, "Attack Power **in Cat Form**", Armor, Dodge |
| WARRIOR_AGILITY_TOOLTIP (59038) | Crit, **Ranged** Attack Power, Armor, Dodge — no melee AP |
| DEFAULT_STRENGTH_TOOLTIP (14238) | Attack Power |
| WARRIOR / PALADIN / SHAMAN_STRENGTH_TOOLTIP (14267/14266/14265) | Attack Power + Block Value |
| DEFAULT_INTELLECT_TOOLTIP (14242) | Mana, Spell Critical Strike, Weapon Skill rate |
| WARRIOR / ROGUE_INTELLECT_TOOLTIP (59052/59053) | only Weapon Skill improvement rate |
| DEFAULT_SPIRIT_TOOLTIP (59054) | Health regen out of combat; Mana regen while not casting; halted 5 sec after spending Mana |
| WARRIOR / ROGUE_SPIRIT_TOOLTIP (59055/59056) | only Health regen out of combat |
| DEFAULT_STAMINA_TOOLTIP (14241) | Health |

Searched and **not found** with the `_AGILITY_TOOLTIP` filter: a SHAMAN_, PALADIN_, PRIEST_, MAGE_ or WARLOCK_ version (the same filter did return five other rows).

Compared with Classic Era 1.15.9.70576 (same filter): only DEFAULT, HUNTER and ROGUE agility strings exist there. Classic Era's DEFAULT text started with "Increases attack power with ranged weapons". DRUID_ and WARRIOR_AGILITY_TOOLTIP are **new in the Forever client**. Classic Era's DEFAULT_SPIRIT_TOOLTIP has no 5-second-rule line.

AFGELEID:
- Classes without their own string use the DEFAULT one. So **Shaman and Paladin Agility shows no Attack Power** in Forever.
- Icy Veins backs this up (GEMETEN, 4 Nov 2026). The Enhancement guide says Shamans have no AP modifier from Agility. The Arms, Fury and Protection Warrior guides say Agility gives Warriors no AP.
- The strings show *which* effects each class gets, not *how much*. The numbers are filled in at runtime.
- The Forever tooltip rewrite drops the ranged-AP line for the DEFAULT classes. Whether the mechanic itself changed is **not measured**.

**Positive check Rob can do in game (AFGELEID, suggestion):** open the character sheet and hover Agility. Expect no "Attack Power" line on a Shaman or Paladin. Expect AP and Ranged AP lines on a Hunter or Rogue, and "Attack Power in Cat Form" on a Druid.

---

## 2. Blizzard: talents and rules that change what a stat is worth (final values)

Sources:
- [BZ-HD] Blizzard News, *Class Deep Dives — Hunter and Druid*, 2026-09-30, https://news.blizzard.com/en-us/article/24301515/world-of-warcraft-forever-class-deep-dives-hunter-and-druid
- [BZ-PW] *Priest and Warrior*, 2026-09-30, https://news.blizzard.com/en-us/article/24301514/world-of-warcraft-forever-class-deep-dives-priest-and-warrior
- [BZ-MS] *Mage and Shaman*, 2026-10-07, https://news.blizzard.com/en-us/article/24302097/world-of-warcraft-forever-class-deep-dives-mage-and-shaman
- [BZ-RW] *Rogue and Warlock*, 2026-10-07, https://news.blizzard.com/en-us/article/24310968/world-of-warcraft-forever-class-deep-dives-rogue-and-warlock
- [BZ-PA] *Paladin*, 2026-10-15, https://news.blizzard.com/en-us/article/24302099/world-of-warcraft-forever-class-deep-dives-paladin
- [BZ-DN] Blizzard forum thread *WoW Forever Beta Development Notes – Updated November 2* (Kaivax), https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-updated-november-2/2360696. I read the posts of Sep 24, Oct 1, Oct 8, Oct 16 and Oct 26, and **post #9 (3 Nov 2026 03:20, the "November 2" notes, the last before launch)** in full.

All rows are GEMETEN, unless marked AFGELEID.

| Class | Change | Value | Source | vs Classic |
|---|---|---|---|---|
| Shaman (Enh) | Mental Dexterity: Intellect → Attack Power | **50/100/150 %** of Int (was 33/67/100) | BZ-DN #9 | new talent (BZ-MS "New row 2") |
| Shaman (Enh) | Mental Quickness: Int → spell damage and healing | "a percentage" (BZ-MS); client text up to 15/30 % (wowforever.ninja, a third-party site, date not shown) | BZ-MS | new |
| Shaman (Enh) | Ancestral Knowledge now % Intellect; Toughness now % Stamina | — | BZ-MS | was max Mana / armor |
| Shaman | Improved Stormstrike, Mindfulness: Spirit regen while casting | — | BZ-MS | new |
| Hunter (MM, also taken by BM leveling builds) | Careful Aim: Int → melee + ranged AP | 20/40/60/80/100 % | BZ-HD | new |
| Hunter | Bestial Discipline (BM), Rapid Recuperation (MM), Resourcefulness (SV): Spirit regen while casting | — | BZ-HD | new |
| Hunter | Lightning Reflexes | 3–15 % Agility | BZ-DN #9 | changed |
| Paladin (Ret) | Champion of the Light: Int → spell damage | **12/24/36/48/60 %** of Int | BZ-DN #9 | new; needs 25 Ret points (wowforeverbuilder, client data, date not shown) |
| Paladin | Sacred Duty no longer gives Stamina; Vindication no longer gives AP | — | BZ-DN #9 | — |
| Paladin (Holy) | Reverence: 30 % of Spirit regen while casting | — | BZ-PA | new |
| Warlock | **Life Tap scales with Spirit** | Wowhead: each Spirit adds 1 mana per Life Tap, or 1.2 with 2/2 Improved Life Tap | BZ-RW; tooltip fix BZ-DN Sep 24; numbers from Wowhead Affliction stat guide (Zephan, date not shown) | new |
| Warlock | Demonic Embrace no longer lowers Spirit; pets scale with the warlock's stats; pets get 2 HP per point of Stamina | was 7.5 HP | BZ-RW; BZ-DN #9 | changed |
| Priest | Meditation: mana from Spirit "increased substantially"; Divine Spirit baseline at 30 | — | BZ-PW | changed |
| Priest (Shadow) | Dark Inspiration: +3–15 % Spirit for you and your party | — | BZ-DN Oct 16 | new |
| Priest (Disc) | Mental Strength: +2–10 % Intellect | — | BZ-DN Oct 16 | was % Mana |
| Mage | Mage Armor and Arcane Meditation: more regen from Spirit; Arcane Mind now % Int | — | BZ-MS | changed |
| Mage (Arcane) | Arcane Blast 12 % Int as spell damage per stack; Arcane Resilience armor up to 75 % of Int | — | BZ-DN #9 | new |
| Druid (Feral) | Natural Instinct: spell healing 12/25 % of Int | — | BZ-DN Oct 8 | new |
| Druid (Resto) | Bloom heals for 100 % of Spirit; Living Spirit +Spirit %; Reflection stronger | — | BZ-DN #9, BZ-HD | new / changed |
| Warrior | Victory Rush heals 10 % of max health | — | BZ-PW | new baseline |
| Warrior | Bug fixed where more Stamina gear meant less Rage | — | BZ-DN Oct 8 | — |
| All races | Base stats corrected (e.g. Tauren Warrior +5 Str vs Human, was +2); Human Spirit racial now 10 % | — | BZ-DN #9 | — |
| Healers | Warcraft Tavern: every healer spec has an in-combat mana-regen talent, so Spirit is strong for healers | — | WT Stats guide (date not shown) | — |

---

## 3. Main table (default solo-leveling spec per class)

Guide sources (all Forever-specific, after launch unless noted):
- [IV] Icy Veins WoW Forever leveling guides, each page shows "Last Updated: Nov 4, 2026": `https://www.icy-veins.com/wow-forever/<spec>-leveling` (arms-warrior, fury-warrior, protection-warrior, retribution-paladin, protection-paladin, beast-mastery-hunter, combat-rogue, shadow-priest, discipline-priest, holy-priest, enhancement-shaman, elemental-shaman, restoration-shaman, frost-mage, affliction-warlock, demonology-warlock, feral-druid, balance-druid, restoration-druid). The holy-paladin guide was seen only as a search excerpt (published 2026-10-17).
- [FX] Fextralife WoW Forever Wiki: `https://wowforever.wiki.fextralife.com/<Class>_Leveling`. Mage, Priest, Shaman, Druid, Hunter, Warrior and Rogue were read in full ("last edited on 4 November 2026"). Paladin and Warlock were seen as search excerpts only, date not seen. The Leveling_Guides overview was edited 3 Nov 2026.
- [MB] Mobalytics: Hunter leveling by Sanctum (date not shown); Priest leveling by Yumytv (2026-11-02); Druid leveling (date not shown); Warlock leveling (date not shown).
- [WT] Warcraft Tavern Forever: Mage leveling (after the Nov 2 notes, because it mentions Ice Lance's 8-second cooldown), Priest leveling, Stats guide. Dates not shown.
- [WH] Wowhead Forever: Arms leveling (shoop, updated 2026/11/04). The leveling "Stats" tabs did not come through in the fetch. I also used the endgame stat pages for Ret (Surveillant), Fury (Babyhoof), Affliction (Zephan) and Feral (Lexolas); these say they are beta-based and show no date.
- [3P] Lower-trust anonymous data sites, used only to show disagreement: wowhandbook.com (client 1.60.1.70790), wowfdb.com, wowforeverbuilder.com, wowforeverclasses.com, theforeverguides.com tier list (2026-10-28), polestar.guide, conquestcapped.com (2026-10-13 / 2026-11-01).

"Stamina tie-break = yes" means: if two rewards are equal on the main stats, prefer Stamina. I set "yes" when at least two named sources put Stamina right after the main stats.

| Class | Default leveling spec | **Main stats (best first)** | Stamina tie-break | Evidence (GEMETEN unless marked) | Forever-specific remark |
|---|---|---|---|---|---|
| **Warrior** | Arms (theforeverguides, polestar). FX picks Protection; the stats are the same either way. | **STRENGTH, AGILITY** | yes | IV Fury: Str > Agi. IV Prot: Str > Agi > Armor & Stamina. FX: Strength is the most useful main stat, then Agility, then Stamina. WH Fury (endgame): Str > Agi > Sta. **IV Arms is the outlier:** it puts Agility & Crit above Strength (crit gives Rage and Deep Wounds). | Agility gives no melee AP (client WARRIOR_AGILITY_TOOLTIP). Tie-break AFGELEID: Victory Rush heals 10 % of max health, and Stamina no longer costs Rage. |
| **Paladin** | Retribution (FX, polestar, theforeverguides; wowfdb calls Ret the default for solo leveling) | **STRENGTH, INTELLECT**; from Champion of the Light 5/5 (lvl ~39): **INTELLECT, STRENGTH** | yes (weak) | **Disputed.** IV Ret: Spell Power > **Int** > Crit > **Str** > Agi, and says Int becomes very useful once Champion of the Light is unlocked. WH Ret (endgame): Int > Str. FX Ret: Strength is the key main stat for physical damage, Int matters later. wowhandbook: Strength first, then Stamina/Spirit, Int after 40. wowfdb: Champion of the Light 5/5 at levels 35–39. | The level split is AFGELEID: before Champion of the Light, Int gives only mana and spell crit (client). Strength gives 2 AP (WH, FX, IV). Paladin Agility gives no AP. |
| **Hunter** | Beast Mastery (all sources) | **AGILITY, SPIRIT**; with Careful Aim (BM builds take it after 31 BM points, so level 41+): **AGILITY, INTELLECT** | no | IV BM: Agi > Crit > Int (with Careful Aim) > Spirit > Sta. IV also says Int matters little early, and that Careful Aim comes after 31 BM points. MB Sanctum: Agi > Int (with 5/5 Careful Aim) > Spirit > Str (melee weaving) > Sta > Int (without Careful Aim). FX: Agi > Sta > Int > Spi > Str; FX ignores Careful Aim and says never to prioritize Spirit. | Agility gives AP + Ranged AP (client). Spirit is worth more than in Classic because Bestial Discipline gives Spirit regen while casting (BZ-HD). |
| **Rogue** | Combat (all sources) | **AGILITY, STRENGTH** | yes | IV Combat: Agi > Crit > Str > Sta. FX: Agi > Str > Sta > Spi > Int. | Agility gives AP (client). No Forever stat change found (empty search, proves nothing). |
| **Priest** | Shadow (FX, polestar, theforeverguides; WT advises against leveling mainly as a healer) | **INTELLECT, SPIRIT** | yes | IV Shadow: Int > Spirit > Stamina (all after Spell Power, Crit and Hit). FX: Int > Spirit > Stamina. WT: Int/Spell Damage > Stamina/Spirit. **MB Yumytv (Nov 2): Spirit first, Intellect last** (Spirit Tap + Meditation). | Spirit is stronger than in Classic: Meditation buffed, Dark Inspiration. |
| **Shaman** | Enhancement (FX, polestar, theforeverguides, wowforeverclasses) | **STRENGTH, INTELLECT**; from Mental Dexterity 3/3 (row 2, lvl ~17): **INTELLECT, STRENGTH** | no | **Disputed.** IV Enh: Weapon DPS > **Int** > **Str** > Spi > Agi > Sta, and says Strength is stronger than Int at low levels. Note: IV still uses the old Mental Dexterity value (1 AP per Int). FX: Str > Agi > Sta > Int > Spi. wowhandbook: Str first, then Int. wowforeverclasses: Method has Agility first, Mobalytics has Int first. | The level split is AFGELEID. Mental Dexterity is now 150 % Int → AP (BZ-DN #9), while Strength gives 2 AP. **No AP from Agility for Shamans** (client + IV). |
| **Mage** | Frost (all sources) | **INTELLECT, SPIRIT** | yes | FX: Int is the best main stat, then Spirit (no special synergy), then Stamina. **IV Frost: Spirit > Int > Sta.** WT Frost: Int > Stamina > Spirit; WT Arcane: Int > Spirit > Stamina. | Int is top-2 in all three sources; Spirit is second in two of them. Mage Armor and Arcane Meditation get more from Spirit (BZ-MS). |
| **Warlock** | Affliction (theforeverguides, polestar, wowforeverclasses); FX picks Demonology. The stats are the same. | **INTELLECT, STAMINA** | (Stamina is a main stat) | MB: Int is the main primary stat, Stamina the other one, Spirit after both. FX: Int is the best main stat, Stamina also important (Life Tap). conquestcapped: Stamina > Int > Spirit. **IV Affliction (unnumbered list): Spirit before Int & Stamina**; IV Demonology: Int & Stamina before Spirit. | Spirit now feeds Life Tap (BZ-RW). It is a Forever change, but most sources still put it third. |
| **Druid** | Feral (FX, polestar, theforeverguides, wowhandbook) | **AGILITY, STRENGTH** | yes (first when bear-tanking) | IV Feral: Agi > Str > Sta (after Weapon DPS, Hit/Expertise, Crit). FX: Agi > Str > Sta > Spi > Int. MB: Agi = Sta = Spi > Str. wowhandbook: Str = Agi. WH Feral: Stamina becomes number 1 if you tank. | Agility gives AP only in Cat Form (client DRUID_AGILITY_TOOLTIP, new in Forever). How much AP Strength gives in Cat Form is disputed (see 5). |

---

## 4. Hybrids by role, and which role to assume

All GEMETEN from IV (Nov 4 2026) unless marked. Only the primary stats are shown; in every caster/healer list, Spell Power, Healing or Hit sits above them.

| Class | Role | Main stats | Source order (primary stats only) |
|---|---|---|---|
| Paladin | **Retribution (default)** | STRENGTH, INTELLECT → INTELLECT, STRENGTH from ~lvl 39 | see section 3 |
| Paladin | Holy | INTELLECT, SPIRIT | IV Holy Paladin (search excerpt, 2026-10-17): Healing Power > Int > MP5 > Crit > Haste > Spirit |
| Paladin | Protection | STAMINA, STRENGTH | IV Prot: Stamina > Spell Power > Strength > … > Int > Agi |
| Shaman | **Enhancement (default)** | STRENGTH, INTELLECT → INTELLECT, STRENGTH from ~lvl 17 | see section 3 |
| Shaman | Elemental | INTELLECT, SPIRIT | IV: Int > MP5 > Spirit > Stamina |
| Shaman | Restoration | INTELLECT, SPIRIT | IV: Int > Spirit > MP5 > Stamina |
| Druid | **Feral (default)** | AGILITY, STRENGTH | see section 3 |
| Druid | Bear tank | STAMINA, AGILITY | AFGELEID from IV Feral (Stamina much more useful when tanking) + WH Feral (Stamina number 1 for tanking) |
| Druid | Balance | INTELLECT, SPIRIT | IV: Int > Spell Power > … > Spirit |
| Druid | Restoration | INTELLECT, SPIRIT | IV: Spell Power > Healing > Int > … > Spirit |
| Priest | **Shadow (default)** | INTELLECT, SPIRIT | see section 3 |
| Priest | Discipline | INTELLECT, SPIRIT | IV: Healing > MP5 > Int > Spirit > Crit |
| Priest | Holy | SPIRIT, INTELLECT | IV: Healing > MP5 > Spirit > Int > Crit |
| Warrior | Protection | STRENGTH, AGILITY | IV Prot Warrior: Strength > Agility > Armor & Stamina ("mostly end game") |

**Default for a solo leveler — GEMETEN choice, reasons from the sources:**
- **Paladin → Retribution.** FX, polestar and theforeverguides pick it. wowfdb: Ret is the default and needs no switch for solo leveling. IV Holy Paladin: healers level more slowly because they kill slowly.
- **Shaman → Enhancement.** FX: Elemental cannot keep up with Enhancement's sustained damage. polestar and theforeverguides agree.
- **Druid → Feral.** FX: shapeshifting gives the smoothest experience. polestar and theforeverguides agree. Use Bear stats only for a tank.
- **Priest → Shadow.** FX: strong damage plus a DoT-and-wand playstyle is the smoothest choice. polestar and theforeverguides agree. WT: leveling mainly as a healer is not recommended.

How MH could guess the role (AFGELEID, **not checked against the Forever client**): count talent points per tree (Classic-style talent API) and use the tree with the most points. Before level 10, or with 0 points, use the default role. The spec API cannot help, because ChrSpecialization has no spec rows (1a).

---

## 5. Where sources disagree (shown, not hidden)

1. **Ret Paladin: Strength vs Intellect.** IV and WH put Int first; FX, wowhandbook and wowfdb put Strength first. I chose a level split: Strength first until Champion of the Light, Int first after (AFGELEID). Pick Rob's preference if he wants one order.
2. **Enhancement Shaman: Strength vs Intellect vs Agility.** IV and Mobalytics: Int. FX and wowhandbook: Strength. Method (via wowforeverclasses): Agility. Agility gives a Shaman no AP (client). I chose a split at Mental Dexterity (AFGELEID).
3. **Arms Warrior:** IV Arms puts Agility above Strength; IV Fury, IV Prot, FX and WH put Strength first.
4. **Mage:** IV Frost puts Spirit above Intellect; FX and WT put Intellect first. WT Frost puts Spirit last.
5. **Shadow Priest:** MB Yumytv puts Spirit first and Intellect last; IV, FX and WT put Intellect first.
6. **Warlock:** only IV Affliction lists Spirit before Intellect & Stamina, and that list is unnumbered.
7. **Hunter second stat:** IV and MB say Spirit until Careful Aim, then Intellect. FX says Stamina and ignores Careful Aim.
8. **Druid Strength in Cat Form:** IV says 2 AP per Strength; FX says 1 AP (2 in Bear Form); Warcraft Tavern and foreverdb.net say 2. Not measured. It does not change the order.
9. **Ranged AP from Agility** (Warriors/Rogues): Warcraft Tavern says 1 per Agility, foreverdb.net and eternadex say 2. Not measured; not relevant for this table.
10. **Mental Dexterity value:** Blizzard's Nov 2 notes say 150 %; IV Enh (updated Nov 4) still describes 1 AP per Int.

---

## 6. Open / not verified

- **Nothing was measured in game.** The positive check in 1b is the cheapest one.
- The Wowhead leveling "Stats" tabs did not come through (Arms, Frost, Arcane). The Ret, Enh, Feral and Shadow leveling URLs on Wowhead failed to fetch. That is not a negative result.
- Forum post #8 of the dev-notes thread (between 26 Oct and 3 Nov) was not read. I saw no Careful Aim change after 30 Sep, but an empty search proves nothing. IV (Nov 4) describes 1 AP per Int at max rank, which fits 100 %.
- The talent levels in the Lua (Mental Dexterity ~17, Champion of the Light ~39, Careful Aim 41+) are AFGELEID: first point at 10, one per level, row requirements as quoted. With the Legacy perk "Talented" (points from level 5–9) everything can come up to 5 levels earlier (perk text GEMETEN on bindonforever.com/leveling and nossuary.com, both third-party, dates not shown). Checking the talent rank directly is safer than checking the level.
- The [3P] sites are anonymous; they were only used to show disagreement, never as the deciding vote.

---

## 7. Lua table

Keys are exactly STRENGTH / AGILITY / INTELLECT / SPIRIT / STAMINA.
- `main` = the default leveling spec, best stat first. It is always present, so a simple consumer can just read `.main`.
- `later` = optional switch once a talent is in. `level` is the earliest normal level (AFGELEID); checking the talent itself is safer.
- `stamTie = true` = prefer Stamina when the main stats tie.
- `roles` / `default` exist only for hybrids.

```lua
-- WoW Forever 1.60.1 leveling main stats. Research 2026-11-07, see FOREVER_MAIN_STATS.md.
-- The client has no primary stat (ChrSpecialization.PrimaryStatPriority = 0 for every class row).
FOREVER_MAIN_STATS = {
  WARRIOR = { main = { "STRENGTH", "AGILITY" }, stamTie = true,
    note = "Str = 2 AP. Agility gives Warriors crit/armor/dodge, no melee AP. Icy Arms alone ranks Agility first." },

  PALADIN = { main = { "STRENGTH", "INTELLECT" }, stamTie = true, default = "RETRIBUTION",
    later = { talent = "Champion of the Light", level = 39, main = { "INTELLECT", "STRENGTH" } },
    note = "Disputed: Icy/Wowhead put Int above Str (Champion of the Light: 60% Int -> spell damage). Agility gives no AP.",
    roles = {
      RETRIBUTION = { main = { "STRENGTH", "INTELLECT" }, stamTie = true,
        later = { talent = "Champion of the Light", level = 39, main = { "INTELLECT", "STRENGTH" } } },
      HOLY        = { main = { "INTELLECT", "SPIRIT" },   stamTie = false },
      PROTECTION  = { main = { "STAMINA", "STRENGTH" },   stamTie = true },
    } },

  HUNTER = { main = { "AGILITY", "SPIRIT" }, stamTie = false,
    later = { talent = "Careful Aim", level = 41, main = { "AGILITY", "INTELLECT" } },
    note = "Agility = AP + ranged AP. Careful Aim turns up to 100% of Int into AP (BM builds take it after 31 BM points)." },

  ROGUE = { main = { "AGILITY", "STRENGTH" }, stamTie = true,
    note = "Agility = AP, crit, dodge. Strength = AP only." },

  PRIEST = { main = { "INTELLECT", "SPIRIT" }, stamTie = true, default = "SHADOW",
    note = "Mobalytics ranks Spirit first (Spirit Tap, buffed Meditation); Icy/Fextralife/Warcraft Tavern rank Int first.",
    roles = {
      SHADOW     = { main = { "INTELLECT", "SPIRIT" }, stamTie = true },
      DISCIPLINE = { main = { "INTELLECT", "SPIRIT" }, stamTie = false },
      HOLY       = { main = { "SPIRIT", "INTELLECT" }, stamTie = false },
    } },

  SHAMAN = { main = { "STRENGTH", "INTELLECT" }, stamTie = false, default = "ENHANCEMENT",
    later = { talent = "Mental Dexterity", level = 17, main = { "INTELLECT", "STRENGTH" } },
    note = "Shamans get no AP from Agility. Mental Dexterity: 150% of Int -> AP. Fextralife still ranks Strength first.",
    roles = {
      ENHANCEMENT = { main = { "STRENGTH", "INTELLECT" }, stamTie = false,
        later = { talent = "Mental Dexterity", level = 17, main = { "INTELLECT", "STRENGTH" } } },
      ELEMENTAL   = { main = { "INTELLECT", "SPIRIT" },   stamTie = false },
      RESTORATION = { main = { "INTELLECT", "SPIRIT" },   stamTie = false },
    } },

  MAGE = { main = { "INTELLECT", "SPIRIT" }, stamTie = true,
    note = "Icy Frost ranks Spirit above Int; Fextralife/Warcraft Tavern rank Int first." },

  WARLOCK = { main = { "INTELLECT", "STAMINA" }, stamTie = true,
    note = "Stamina feeds Life Tap. New in Forever: Life Tap also scales with Spirit (3rd stat; Icy Affliction lists it first)." },

  DRUID = { main = { "AGILITY", "STRENGTH" }, stamTie = true, default = "FERAL",
    note = "Agility gives AP only in Cat Form; Strength gives AP in all forms.",
    roles = {
      FERAL       = { main = { "AGILITY", "STRENGTH" }, stamTie = true },
      BEAR        = { main = { "STAMINA", "AGILITY" },  stamTie = true },
      BALANCE     = { main = { "INTELLECT", "SPIRIT" }, stamTie = false },
      RESTORATION = { main = { "INTELLECT", "SPIRIT" }, stamTie = false },
    } },
}
```
