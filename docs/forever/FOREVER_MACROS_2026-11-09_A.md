# WoW: Forever macros, part A: ground rules, races, universal macros

Research date: 9 Nov 2026. Client checked: Forever build **1.60.1.70862** (wago.tools branch `wowf`, DB2 tables viewed 9 Nov 2026 in the browser).
Labels: **GEMETEN** = seen in a named, dated source (URL + date given). **AFGELEID** = my reasoning, not tested.
Nothing here was tested in game. A string or row in the client's DB2 shows that the client contains that data. It does not prove that a command works.
MH's own macro code and docs were not used. I opened two files in `E:\World of Warcraft\_forever_\WTF\...\macros-cache.txt` (Joey-Whatever, Ima-Tinyroque). They turned out to be MH-generated ("MH 1", ...), so I stopped and used nothing from them.

---

## 0. Biggest findings

1. **Focus exists in Forever.** Classic Era does not have it. GEMETEN: Blizzard dev notes 16 Oct 2026 ("Fixed an issue where using a focus macro to cast Light's Vigil...") and 3 Nov 2026 ("Added Gamepad support for targeting a previously assigned Focus Target"). Source: https://us.forums.blizzard.com/en/wow/t/2360696 (fetched 9 Nov 2026).
2. **New ranks do not reach your action bars, but a rank-less macro casts your highest rank.** That makes macros extra useful in Forever. GEMETEN: Blizzard 3 Nov 2026 ("Learning new spells will no longer cause them to be automatically added to your action bars"). MaxRank addon page (2 Nov 2026): a trained rank "doesn't change your action bars". Players in the forum thread "Forever macros" (2 to 3 Nov 2026): "If you don't specify the rank it assumes max rank known". One counter-report (5 Nov) is listed in §1.
3. **The racials are completely reworked.** Each race has 4 racials (2 active, 2 passive). There is a new race, **Skyborne**: High Order = Alliance, Windshaper = Horde. Most old vanilla racials are gone (weapon specs, resistances). Details in §3.
4. **The client spells it "Read Leyline", not "Read Ley Line".** Icy Veins and Warcraft Tavern use the wrong spelling, and a macro needs the exact name. GEMETEN: wago SpellName 1259705 = "Read Leyline" (build 1.60.1.70862, 9 Nov 2026).
5. **All four "burst" racials are off the GCD in the client data.** These are Blood Fury, Berserking, Elune's Light and Eureka!, so they can go on the same line set as your main spell. The defensive and break-free racials are on the GCD. GEMETEN: wago SpellCooldowns `StartRecoveryTime` (§3). I don't know whether the wago view had hotfixes applied.

---

## 1. Ground rules for the Forever macro system

| Feature | Status in Forever | Label + source |
|---|---|---|
| Max length 255 characters | Yes | **GEMETEN**: GlobalStrings `MACROFRAME_CHAR_LIMIT` = "%d/255 Characters Used", build 1.60.1.70862 (wago.tools, 9 Nov 2026). Also rankedboost (updated 7 Nov 2026), Macro Manager Forever CF page (18 Oct 2026, 1.60.1). mmonster.co (updated 3 Nov 2026): macro name max 16 characters. |
| Number of macros (120 general / 18 per char in Era) | Unknown | **Not verified.** mmonster.co (3 Nov 2026) lists it as "still open". |
| General vs character-specific lists | Separate | **GEMETEN**: Blizzard 8 Oct 2026, "Fixed an issue where Specific Macros were showing General Macros." |
| Editing macros in combat | Not possible | **GEMETEN** (claim): mmonster.co 3 Nov 2026 says the "New" button is greyed out in combat. AFGELEID: this matches every modern client. |
| `#showtooltip` | Works | **GEMETEN** (string/claims): rankedboost, wow4ever ("seen working in the beta"). Rank caveat: `#showtooltip Healing Touch` keeps showing max rank. Use a bare `#showtooltip` in rank macros. Source: forum thread "Downranking spells", 8 Nov 2026, https://us.forums.blizzard.com/en/wow/t/downranking-spells/2406434 |
| `[mod:shift/ctrl/alt]`, `[nomod]` | Works | **GEMETEN** (claims): rankedboost, foreverdb, mmonster. A player test of `[nomod] / [mod:shift] / [mod:ctrl]` with ranks "works as expected for me" (forum, 8 Nov 2026). |
| `[@mouseover]` | Works | **GEMETEN**: forum posts with mouseover macros (thread 2399184, 2 to 5 Nov 2026). wow4ever lists it among commands "seen working in the beta". |
| Built-in Mouseover Cast option | Yes, **unit frames only** | **GEMETEN**: GlobalStrings `ENABLE_MOUSEOVER_CAST`, `MOUSEOVER_CAST_KEY`. Tooltip text: "mousing over a unit frame and casting a spell ... will cast it directly on that unit" (build 1.60.1.70862). Method.gg 30 Sep 2026 calls it "A new feature for Classic players". AFGELEID: for 3D characters in the world you still need `[@mouseover]` macros. |
| `[@focus]`, `/focus`, `/clearfocus` | Works | **GEMETEN**: Blizzard 16 Oct + 3 Nov 2026 (above). EU forum 24 Sep 2026: "/focus in Forever is possible, is this a intended change?" (https://eu.forums.blizzard.com/en/wow/t/focus-targeting-focus-in-forver/631216). GlobalStrings `SLASH_FOCUS1`, `BINDING_NAME_FOCUSTARGET`, `OPTION_TOOLTIP_FOCUS_CAST_*_KEY` (focus-cast key option). |
| Blizzard focus **frame** on screen | Probably yes | Partly GEMETEN: Edit Mode Enhanced (CF, Forever-only, 1.60.1, 8 Oct 2026) lists "Focus Frame" as a supported Blizzard element. foreverdb.net (9 Nov 2026) says the client has a focus frame. GlobalStrings `LOCK_FOCUS_FRAME`. Not seen in game by me. |
| Focus in Classic Era | Missing | **GEMETEN** (claims): foreverdb.net ("Classic Era hides the focus target"). The "Focused!" addon (Classic Era 1.15.x, 16 Sep 2026) "restores the missing Blizzard focus frame". |
| `[harm]`, `[help]`, `[dead]/[nodead]`, `[exists]`, `[combat]` | Works | **GEMETEN** (claims): rankedboost 7 Nov, foreverdb 9 Nov, warcraftmaps. AFGELEID: standard secure-command options, see warcraft.wiki.gg Macro_conditionals (edited 27 Oct 2025). |
| `[stance:n]` / `[form:n]` | Works; **numbers not verified** | Claims: rankedboost, warcraftmaps (stance 1/2/3 = Battle/Defensive/Berserker). senseos.gg says it has not checked the numbers on live servers. Druid form numbers follow learn order (warcraftmaps), unverified. |
| `[nochanneling]` / `[channeling]` | Probably yes | Claim: rankedboost lists `[nochanneling]`. AFGELEID: standard conditional (wiki). |
| `[stealth]`, `[mounted]`, `[swimming]`, `[pet]`, `[equipped:]/[worn:]`, `[@cursor]`, `[@pet]` | Probably yes | Claims: foreverdb, wow4ever (`@cursor`, `worn:` "seen working"). Not tested by me. |
| `[known:]` (retail 10.0.2+) | Unknown | AFGELEID: wow4ever says Forever runs "the modern game's macro system underneath". Untested. |
| `/castsequence` + `reset=` | Works | **GEMETEN**: GlobalStrings `SLASH_CASTSEQUENCE1`. rankedboost: reset accepts seconds/target/combat/shift/ctrl/alt; a step advances only on a successful cast; the sequence resets on death. Beta bug (19 Sep 2026): `/castsequence reset=target/combat/10 Curse of Weakness, Bane of Agony, ...` stalled when CoW rank 2+ was first. Fix status unknown (https://us.forums.blizzard.com/en/wow/t/forever-warlock-cast-sequence-bug/2354983). |
| `/startattack`, `/stopattack` | Exists | **GEMETEN** (string): `SLASH_STARTATTACK1`, `SLASH_STOPATTACK1`. wow4ever: seen working. |
| `/stopcasting`, `/stopmacro` | Exists | **GEMETEN** (string): `SLASH_STOPCASTING1`, `SLASH_STOPMACRO1`. |
| `/cancelaura`, `/cancelform` | Exists | **GEMETEN** (string): `SLASH_CANCELAURA1`, `SLASH_CANCELFORM1`. kami-labs (1 Oct 2026) Druid macro uses `/cancelform`. |
| `/cancelqueuedspell` (`/cqs`) | Exists | **GEMETEN** (string): `SLASH_CANCELQUEUEDSPELL1/3`. |
| `/use <name>`, `/use 13`/`14`, `/use <bag> <slot>` | name/slot yes; bag slot probably | **GEMETEN** (string) `SLASH_USE1`. warcraft.wiki.gg MACRO_use: accepts name, link, "bagID slot" (e.g. `0 1`), inventory slot. AFGELEID for Forever: bag-slot form not seen in any Forever source. |
| `/equipslot` weapon swaps | Several per GCD again | **GEMETEN**: Blizzard 8 Oct 2026, "Players will once again be able to swap multiple weapons within the same GCD, for example via a macro". |
| Scrolls | On GCD | **GEMETEN**: Blizzard 16 Oct 2026, "Scrolls now incur a global cooldown when used." So a macro cannot use a scroll and cast a GCD spell on the same press (AFGELEID). |
| `/tm` (`/targetmarker`) | Exists | **GEMETEN** (string) `SLASH_TARGET_MARKER1` = /tm. warcraft.wiki.gg MACRO_targetmarker (edited 8 Nov 2026): `!8` = set without toggling off. |
| `/dismount`, `/click`, `/castrandom`, `/userandom`, `/usetoy` | Exist | **GEMETEN** (strings). |
| `/cc` (`/clickcasting`) | Exists | **GEMETEN** (string) `SLASH_CLICKCASTING1/3`. Built-in Click Cast Bindings (mmonster claim). |
| **Spell ranks:** `/cast Frostbolt` = highest known rank | Yes (mostly) | **GEMETEN**: forum "Forever macros" 2 to 3 Nov 2026 (Æonic, Andrew). **Counter-report**: Atheren, 5 Nov 2026: `/cast [@mouseover,help,nodead][help][@player]Healing Touch` cast Rank 1 with Rank 2 learned. Andrew: macros "don't auto-downrank like the spell pulled out of your spell book will" (for low-level targets). Thread: https://us.forums.blizzard.com/en/wow/t/forever-macros/2399184 |
| **Spell ranks:** `/cast Healing Touch(Rank 1)` | Works per player test | **GEMETEN**: forum 8 Nov 2026. A player copy-pasted `/cast [nomod] Healing Touch; [mod:shift] Healing Touch(Rank 2); [mod:ctrl] Healing Touch(Rank 1)`: "it works as expected for me". The poster had first said "Downranking macros worked in Era but cast the max rank here", which turned out to be a keybind/tooltip issue. mmonster + foreverdb: no space before the bracket. wow4ever.quest: "nobody has confirmed it". Treat it as **likely, not certain**. German client: `(Rang 1)` (mmonster claim). |
| Click casting and ranks | Does not follow new ranks | **GEMETEN**: forum bug report 5 to 6 Nov 2026 (https://us.forums.blizzard.com/en/wow/t/2402539). |
| Cooldown Manager and ranks | One entry per spell | **GEMETEN**: Blizzard 16 Oct 2026, "Spells with different rankings now behaves as a single entry in the Cooldown Manager." |
| Midnight-style addon restrictions | Announced, unconfirmed | Claim: mmonster cites a "developer Q&A of September 17" with no link. Not verified. AFGELEID: macro conditionals are secure commands and should not be affected. Retail-Midnight limits on macro chat in instances: unconfirmed for Forever. |

### Forever vs. Classic Era (macro-relevant)
- Focus: present in Forever, missing in Era (see table).
- Mouseover Cast option for unit frames: new for "Classic players" (Method.gg, 30 Sep 2026).
- Rank syntax: same as Era (forum, 8 Nov 2026).
- Action bars do not auto-add new spells and do not upgrade ranks. GEMETEN: Blizzard 3 Nov; MaxRank 2 Nov 2026.
- Renamed spells break old Era macros. Warlock **Bane of Agony / Bane of Doom** (curses and banes are separate groups). Druid **Mangle → Primal Bite**. GEMETEN: senseos.gg (cites Blizzard 24 Sep notes); TalentsForeverBook Data.lua renames table (local addon, `## Version: 0.38.21.20261109`).
- Weapon swaps per GCD (8 Oct) and scrolls on GCD (16 Oct): see table.
- Potion cooldowns: every healing, mana and rejuvenation potion shares one 2-min cooldown. Healthstones share a separate 2-min cooldown with mana gems. Bandages have none. GEMETEN (claim, from client extraction): foreverdb.net, build 1.60.1.70862, 9 Nov 2026. Not verified by me.

---

## 2. Playable races in Forever

There are 8 classic races + **Skyborne** (neutral elves). At creation you pick **High Order (Alliance)** or **Windshaper (Horde)**. Icy Veins counts "10 races" (Skyborne counted twice). GEMETEN: Icy Veins race guide, updated 27 Oct 2026 (https://www.icy-veins.com/wow-forever/race-guide). Warcraft Tavern racial page (https://www.warcrafttavern.com/forever/guides/racial-abilities/, no date). TalentsForeverBook Data.lua (local, 9 Nov 2026).
New race/class combos (Icy Veins, 27 Oct 2026): Human Hunter, Dwarf Shaman, Gnome Priest, Orc Mage, Undead Paladin, Troll Warlock. Skyborne: Druid, Hunter, Rogue, Warrior, Mage (Alliance only), Shaman (Horde only).

---

## 3. Racials worth a macro, per race

Spell names and IDs are **GEMETEN** in wago SpellName, build 1.60.1.70862 (9 Nov 2026). "CD / GCD" = wago SpellCooldowns `RecoveryTime` / `StartRecoveryTime` in that build (GEMETEN; hotfix state of the view unknown). Effect texts come from wago Spell `Description_lang` or the sources in §2.
Passives (no macro) are left out: Ruthless, The Human Spirit, Artisan's Precision, Big Game Hunter, Quickness, Wisp Spirit, Expansive Mind, Engineering Specialization, Command, Hardiness, Underwater Breathing, Touch of the Grave, Endurance, Plainsrunning, Beast Slaying, Regeneration, Elemental Insight, Wind Blessed.

### Reusable burst template (Blood Fury / Berserking / Elune's Light / Eureka!)
All four have GCD = 0 in the client data (GEMETEN, below). So they fire together with trinkets and your main spell on one press (AFGELEID).
Separate burst button:
```
#showtooltip
/use 13
/use 14
/cast Blood Fury
```
Fires both trinkets and the racial at once. Swap in `Berserking`, `Elune's Light` or `Eureka!`.
Folded into your main nuke (fires the racial on every press when ready):
```
#showtooltip Shadow Bolt
/cast Blood Fury
/cast Shadow Bolt
```
The racial is used automatically when ready. Downside: you also burn it on trash. Use the separate button if you want control. With `#showtooltip <spell>` the icon shows max rank (forum 8 Nov 2026).

### Human
- **Will to Survive** (1259718). "Instantly removes all Stun effects" (wago Spell). CD 180 s, GCD 1.5 s. New in Forever (Warcraft Tavern).
```
#showtooltip Will to Survive
/cast Will to Survive
```
Free stun-break. Put it on an easy key. Nothing else belongs in the macro: you can't cast while stunned anyway (AFGELEID).
- **Perception** (20600). Stealth detection, CD 180 s, GCD 1.5 s. A plain button is enough. Optional macro for the icon only:
```
#showtooltip Perception
/cast Perception
```

### Dwarf
- **Stoneform** (20594). Removes and gives immunity to Bleed/Poison/Disease, and reduces physical damage for 8 s (TalentsForeverBook; Icy Veins). CD 180 s, **GCD 1.5 s**.
```
#showtooltip Stoneform
/stopcasting
/cast Stoneform
```
Stops your current cast so Stoneform fires at once (AFGELEID).
- **Find Treasure** (2481). Tracking "until cancelled", stacks with other tracking (Icy Veins). No macro needed.

### Night Elf
- **Shadowmeld** (20580). "Lasts until cancelled or upon moving. Using this ability in combat discourages enemies from attacking you, but increases the cooldown to 2 min." (wago Spell, GEMETEN). Base CD 10 s (CategoryRecoveryTime 10000), GCD 0.
```
#showtooltip Shadowmeld
/stopattack
/stopcasting
/petfollow
/cast Shadowmeld
```
Drop-aggro button. It stops your swings, your cast and your pet first, so nothing breaks the meld (AFGELEID; foreverdb uses `/stopattack /petfollow /cast Shadowmeld`).
- **Elune's Light** (1259799). +10% crit for 15 s. CD 180 s, **GCD 0**. Use the burst template. New in Forever.

### Gnome
- **Escape Artist** (20589). Breaks movement-impairing effects and gives short immunity (wago Spell). CD **120 s** in DB2 (Icy Veins says 1 min: conflict), **GCD 1.5 s**.
```
#showtooltip Escape Artist
/stopcasting
/cast Escape Artist
```
Root/snare break that also works mid-cast (AFGELEID).
- **Eureka!** (1259823). For 8 s, non-periodic abilities cost 10% less and do 10% more (TalentsForeverBook; Icy Veins). CD 120 s, **GCD 0**. "Cannot be used while in Stealth or invisible" (Icy Veins). Use the burst template. Rogues: not in a stealth opener. The `!` is part of the name: `/cast Eureka!` (AFGELEID that the trailing `!` parses fine; an in-game test is needed).

### Orc
- **Blood Fury** (20572). +10% AP and SP for 15 s. CD 120 s (Blizzard 26/27 Oct: "reduced to 2 minutes (was 3 minutes)"), **GCD 0**. Use the burst template.
- **Shatter Curse** (1299026). "Instantly removes all Curses and Banes, and reduces all Magical damage taken" (wago Spell). CD 180 s, GCD 1.5 s. New in Forever.
```
#showtooltip Shatter Curse
/stopcasting
/cast Shatter Curse
```
Self-decurse, also mid-cast (AFGELEID).

### Undead
- **Will of the Forsaken** (7744). Removes Charm, Fear and Sleep (TalentsForeverBook; Icy Veins). CD 120 s, GCD 1.5 s.
```
#showtooltip Will of the Forsaken
/cast Will of the Forsaken
```
Fear-break on an easy key (AFGELEID: nothing else is useful in it).
- **Cannibalize** (20577). Needs a Humanoid or Undead corpse within 5 yd. Heals over time; movement, actions or damage cancel it (TalentsForeverBook). CD 120 s, GCD 1.5 s. Blizzard 3 Nov 2026: "can once again be used while immune to Physical damage".
```
#showtooltip Cannibalize
/stopattack
/cast Cannibalize
```
Stops auto-attack first so a swing doesn't cancel the channel (AFGELEID).

### Tauren
- **War Stomp** (20549). Stuns up to 5 enemies within 8 yd for 2 s, 0.5 s cast (TalentsForeverBook). CD **90 s** (Blizzard 16 Oct: "reduced to 90 seconds"), GCD 0.
```
#showtooltip War Stomp
/stopcasting
/cast War Stomp
```
Cancels your own cast so the stomp starts at once (AFGELEID).
- **Cultivation** (20552). Grows a gatherable herb copy; 15 min CD in play (TalentsForeverBook). Plain button.

### Troll
- **Berserking** (20554). +10% haste. Duration **15 s** (Blizzard 26/27 Oct: "increased to 15 seconds (was 10 seconds)"; Icy Veins still says 12 s, which is outdated). CD 180 s, **GCD 0**. Use the burst template.
- **Rapid Regeneration** (1260270). Regenerate a % of max health; "Any movement, action, or damage taken will cancel the effect" (wago Spell). CD 180 s, GCD 0.
```
#showtooltip Rapid Regeneration
/stopattack
/cast Rapid Regeneration
```
Out-of-combat self-heal (AFGELEID: don't combine with food; eating is an action and would cancel it).

### Skyborne
- **Walk on Air** (1259416, both factions). "Glide downward through the air for $d while controlling your direction of travel" (wago Spell). CD 90 s (Blizzard 16 Oct), GCD 1.5 s.
```
#showtooltip Walk on Air
/cancelaura [mod:shift] Walk on Air
/stopmacro [mod:shift]
/cast Walk on Air
```
Press to glide. Shift-press to drop the glide early (AFGELEID: aura name assumed to be "Walk on Air"; a second spell 1308663 has the same name).
- **Read Leyline** (1259705, **High Order / Alliance only**). 2 min CD, GCD 1.5 s. +Health/Mana regen. Cannot be used while Innervate is active (TalentsForeverBook; Icy Veins). Exact name **"Read Leyline"** (GEMETEN, see §0.4).
```
#showtooltip Read Leyline
/cast Read Leyline
```
- **Skysight** (1259686, **Windshaper / Horde only**). "increasing your movement and mounted movement speeds" (wago Spell). 2 min CD, GCD 1.5 s.
```
#showtooltip Skysight
/cast Skysight
```
- Note: foreverdb.net suggests `/cast [mod:shift] Read Leyline; Skysight`. That is useless: one character has only one of the two (faction split, GEMETEN TalentsForeverBook + Warcraft Tavern). AFGELEID.

### Priest-only race spells (for the class report)
Forever ties extra priest spells to race (TalentsForeverBook "Spell text from the beta client"; Warcraft Tavern):
- Human: Divine Grace, Feedback
- Dwarf: Chastise, Desperate Prayer
- Night Elf: Elune's Grace, Starshards
- Gnome: Confounding Flash, Contingency Plan
- Undead: Dark Sacrifice, Touch of Weakness
- Troll: Hex of Weakness, Shadowguard

Two of them take a friendly target: Divine Grace ("Cannot be cast on self") and Contingency Plan. A mouseover-help macro fits them (AFGELEID):
```
#showtooltip
/cast [@mouseover,help,nodead][help,nodead] Divine Grace
```

---

## 4. Universal macros (every class)

Item names are **GEMETEN** in wago ItemSparse, build 1.60.1.70862: potions 118/858/929/1710/3928/13446 (Minor → Major Healing Potion), new Perishable Minor/Lesser/Healing Potion 268881-268883, healthstones Minor/Lesser/(plain)/Greater/Major Healthstone (5512/5511/5509/5510/9421, talent variants 19004-19013 share the names), and bandages Linen → Heavy Runecloth (1251 ... 14530). Being in DB2 does not prove an item is obtainable.

**U1. Mount on/off**
```
#showtooltip
/dismount [mounted]
/cast [nomounted] <your mount name>
```
One key to get on and off. Replace the placeholder with your mount's exact name. AFGELEID: mounts are collected (mein-mmo 4 Nov 2026: account-wide unlocks), so `/cast <mount name>` should work like modern WoW. Alternative: the client has the string `MOUNT_JOURNAL_SUMMON_RANDOM_FAVORITE_MOUNT` (GEMETEN), so a "Summon Random Favorite Mount" button can probably be dragged to a bar. Not seen in game.

**U2. Healthstone, potion on Shift**
```
#showtooltip
/use [mod:shift] Major Healing Potion; Major Healthstone
```
Normal press = stone, Shift = potion. Swap in the ranks you carry (AFGELEID).

**U3. Panic heal (stone + potion fallback)**
```
#showtooltip
/use Major Healthstone
/use Major Healing Potion
```
Fires the stone, and the potion too if you have it. Without a stone, only the potion fires. AFGELEID: neither item has a GCD and their cooldown groups differ (foreverdb claim). So with both ready, **both** are used on one press. Use U2 if you want one at a time.

**U4. Leveling heal (several ranks)**
```
#showtooltip
/use Major Healthstone
/use Greater Healthstone
/use Healthstone
/use Superior Healing Potion
/use Greater Healing Potion
/use Healing Potion
```
Uses whatever you carry. AFGELEID: a second item from the same cooldown group should fail as "not ready". Untested.

**U5. Bandage on self (or mouseover friend)**
```
#showtooltip
/use [@mouseover,help,nodead][@player] Heavy Runecloth Bandage
```
Bandages without losing your target. Swap the bandage name per level: Linen, Heavy Linen, Wool, Heavy Wool, Silk, Heavy Silk, Mageweave, Heavy Mageweave, Runecloth, Heavy Runecloth (all GEMETEN in DB2). AFGELEID that `/use [@player]` targets the bandage. foreverdb uses this exact form.

**U6. Eat and drink in one press**
```
#showtooltip
/use <your drink>
/use <your food>
```
Drink and eat together. Replace the placeholders with exact item names. GEMETEN as a template on rankedboost (7 Nov 2026).

**U7. Trinkets**
```
/use 13
/use 14
```
Both trinket slots. GEMETEN template (rankedboost, warcraftmaps).

**U8. Skull on mouseover or target**
```
/tm [@mouseover,exists,nodead][] !8
```
Marks with skull and never toggles it off by accident. `!` per warcraft.wiki.gg (edited 8 Nov 2026); `/tm` string GEMETEN. Four markers on one key (foreverdb, verbatim):
```
/tm [@mouseover,exists,nodead,mod:shift][mod:shift] !5; [@mouseover,exists,nodead,mod:ctrl][mod:ctrl] !6; [@mouseover,exists,nodead,mod:alt][mod:alt] !7; [@mouseover,exists,nodead][] !8
```
Clear: `/tm [@mouseover,exists][] 0`

**U9. Rare finder**
```
/cleartarget
/targetexact Rare Name
/tm [exists,nodead] !8
```
Targets the rare and skulls it if it is in view. Put in the exact rare name (for example from HandyNotes_WoWForever). AFGELEID: you lose your target if the rare isn't there, so use it out of combat. `/tar <part of name>` is looser and can also hit friendly NPCs. `/tar` is an alias of `/target` (mmonster).

**U10. Set or clear focus (Forever only, not Era)**
```
/clearfocus [mod:shift]
/stopmacro [mod:shift]
/focus [@mouseover,exists,nodead][]
```
Sets focus from mouseover, else from your target. Shift clears it. Template from warcraftmaps/foreverdb; focus GEMETEN (Blizzard 16 Oct / 3 Nov).

**U11. Target nearest enemy + attack (melee/levelling)**
```
/targetenemy [noharm][dead]
/startattack
```
GEMETEN template (warcraftmaps).

**U12. Assist focus (tank's target)**
```
/assist [@focus,exists,nodead]
/startattack [harm,nodead]
```
GEMETEN template (warcraftmaps, foreverdb).

**Rank tip (applies to every class):** write spells **without** a rank. The macro then casts your highest rank after every trainer visit, while plain bar buttons keep the old rank (§0.2). For a lower rank: `/cast Spell(Rank 1)` with a bare `#showtooltip`.

---

## 5. Not verified for Forever specifically (Classic Era / modern client knowledge only)

1. **`(Rank N)` syntax.** Only one player says it works (8 Nov 2026). There is a counter-report that a rank-less heal cast Rank 1 (5 Nov). No blue post.
2. **Stance and form numbers** (`[stance:n]`, `[form:n]`): nobody has confirmed them on live servers.
3. **Two non-GCD `/use` lines firing together** (U3/U4), and same-cooldown-group behaviour: not tested.
4. **Bag-slot `/use 0 1`**, `[known:]`, `[@cursor]`, `[nochanneling]`: only general wiki docs or third-party claims, no Forever test.
5. **Focus frame visible by default**: indirect evidence only. Focus *targeting* is confirmed.
6. **Cooldown numbers.** Taken from DB2 without knowing whether hotfixes were applied. Escape Artist (DB2 120 s vs Icy Veins 60 s) and Berserking duration (Icy Veins 12 s vs Blizzard 15 s) conflict.
7. **Midnight-style addon/macro restrictions in Forever**: announced per mmonster (17 Sep Q&A), no primary source found.
8. **`/castsequence` beta bug** (19 Sep 2026): fixed or not is unknown.
9. **Mount summon** by name or via the random-favorite button: not seen in game.
10. **Eureka!** with the trailing `!` in `/cast`: parsing not tested.

## Sources (all fetched 9 Nov 2026)
- Blizzard, WoW Forever Beta Development Notes (24 Sep to 4 Nov 2026): https://us.forums.blizzard.com/en/wow/t/2360696
- Blizzard forum "Forever macros" (2 to 5 Nov 2026): https://us.forums.blizzard.com/en/wow/t/forever-macros/2399184
- Blizzard forum "Downranking spells" (8 Nov 2026): https://us.forums.blizzard.com/en/wow/t/downranking-spells/2406434
- Blizzard forum "WOWF Click Casting not updated with new spell ranks?" (5 to 6 Nov 2026): https://us.forums.blizzard.com/en/wow/t/2402539
- Blizzard forum "Forever: Warlock Cast Sequence Bug" (19 Sep 2026): https://us.forums.blizzard.com/en/wow/t/forever-warlock-cast-sequence-bug/2354983
- EU forum "Focus targeting /focus in forver?" (24 Sep 2026): https://eu.forums.blizzard.com/en/wow/t/focus-targeting-focus-in-forver/631216
- wago.tools DB2, build 1.60.1.70862: GlobalStrings, SpellName, Spell, SpellCooldowns, ItemSparse (via browser)
- Icy Veins, WoW Forever Racial Guide (updated 27 Oct 2026): https://www.icy-veins.com/wow-forever/race-guide
- Warcraft Tavern, Racial Abilities (no date): https://www.warcrafttavern.com/forever/guides/racial-abilities/
- TalentsForeverBook addon, local: `E:\World of Warcraft\_forever_\Interface\AddOns\TalentsForeverBook\Data.lua` (Interface 16001, version 0.38.21.20261109)
- foreverdb.net/macros (client extraction 1.60.1.70862, 9 Nov 2026): https://foreverdb.net/macros
- mmonster.co (first published 21 Oct, updated 3 Nov 2026): https://mmonster.co/wow-forever/guides/macros
- rankedboost (updated 7 Nov 2026): https://rankedboost.com/world-of-warcraft/forever/macros/
- kami-labs (1 Oct 2026): https://kami-labs.fr/en/wow-forever/macros-wow-forever-9-classes/
- warcraftmaps.com/guides/macros, senseos.gg/guides/wow-forever/macros/, wow4ever.quest/en/articles/macros-wow-forever (third-party, undated or beta-era)
- Method.gg, Forever UI (30 Sep 2026): https://www.method.gg/wow-forever/understanding-wow-forevers-ui
- CurseForge: MaxRank (2 Nov 2026), Macro Manager Forever (18 Oct 2026), Edit Mode Enhanced (8 Oct 2026), Focused! Classic Era (16 Sep 2026)
- mein-mmo, Forever mounts (4 Nov 2026): https://mein-mmo.de/en/wow-forever-mounts-unlocking-requirements-level-and-more-about-the-mounts-of-azeroth,1594797/
- warcraft.wiki.gg: Macro_conditionals (27 Oct 2025), MACRO_use (29 Feb 2020), MACRO_targetmarker (8 Nov 2026)
