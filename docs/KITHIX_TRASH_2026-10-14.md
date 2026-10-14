# Kith'ix trash: research notes (14 Oct 2026, EU-live 12.1.5.70391)

Labels: MEASURED (GEMETEN) = seen in a named, dated source. DERIVED (AFGELEID) = my reasoning.
"Candidate" = id not tied to the NPC by a source.

Sources used (all read on 14 Oct 2026):
- WH = Wowhead database pages (npc=, spell=, zone=17059, quest=95211) and the tooltip API, read live.
- WH-guide = Wowhead "The Unbinding of Kith'ix Raid Guide" by Daylea, updated 2026/10/13.
- W = wago.tools DB2, build 12.1.5.70391 (the build shown in the page header): Spell, SpellName, SpellMisc,
  SpellCategories, SpellInterrupts, SpellCastTimes, Difficulty, MapDifficulty, UiMap, UiMapGroupMember.
- BLZ = Blizzard "12.1.5 Content Update Notes" (news.blizzard.com, 1 Oct 2026; bluetracker EU copy 13 Oct 2026).
- IV-news = Icy Veins news "Complete Ki'thix Raid for a Hero Neck or Ring - Story Mode Available", 14 Oct 2026.
- ZY = local Zygor (ZygorGuidesViewer.toc Interface 120105, Version 9.6): ZygorLevelingCommonMID.lua 20717-20728,
  ZygorDungeonCommonMID.lua 2699-2733, LibRover data.lua:143 and data_dungeons.lua:850/1863.
- DBM = local DBM-Lairs-Midnight (Version 12.1.13; Kithix.lua revision 20260914201948) and DBM-Raids-Midnight.

---

## 1. Shadowspeaker Ip'thosh

| Fact | Value | Label |
|---|---|---|
| NPC id | **272687** | MEASURED (WH npc=272687, 14 Oct 2026) |
| Classification / type | Elite, Beast (sound kit "MON_Aqir_Caster") | MEASURED (WH) |
| Where | Inside the raid, zone 17059. The floor is "The Tomb of Ula'tek" at 76.5, 56.1 (one spawn). | MEASURED (WH mapper) |
| That floor = uiMap 2670 | UiMapGroupMember 1504 "The Tomb of Ula'tek" = UiMap 2670, FloorIndex 0. UiMap 2669 = "Kith'ix' Prison", FloorIndex 1. Both have parent 2613. | MEASURED (W 70391) |
| Difficulties his spells are logged on | modes 14 Normal, 15 Heroic, 17 Raid Finder, 233 Mythic Flex | MEASURED (WH listview data); 233 = "Mythic - Flexible Raiding" (W Difficulty) |
| Added | patch 12.1.5 | MEASURED (WH) |

His abilities (WH lists 6). All ids are in W SpellName 70391, and the descriptions name Ip'thosh in W Spell 70391.

| Spell id | Name | DB2 data (W 70391 + WH spell page) | Label |
|---|---|---|---|
| **1316702** | Shadow Barrage | **2 sec cast** (CastingTimeIndex 5 = 2000 ms), **channel of 4 sec**, 300 yd. Flags (WH): Channeled, Track Target in Channel, **Ignore Line of Sight**, **AI Primary Ranged Attack**. Text: "conjures a relentless flurry of shadows to strike his target for X Shadow damage every 0.25 sec for 4 sec." | MEASURED |
| 1316703 | Shadow Barrage | Instant. This is the damage hit of the barrage (1316702's text uses $1316703s1). | MEASURED (id + text); "damage tick" = DERIVED |
| 1316577 | Shadow Barrage | Self, channel of 7 days, no visible cast time; same text on WH. | MEASURED (data); what it does is unknown |
| **1316782** | Curse of Despair | **4 sec cast**, 8 sec. **Dispel type: Curse** (SpellCategories DispelType 2; WH "Curse"). Hits all players (radius 300): Shadow damage every 1 sec and **50% slower movement** for 8 sec. | MEASURED |
| **1316802** | Piercing Shadows | Instant. 5 sec debuff "Targeted for Piercing Shadows" (WH: big boss-aura icon). Text: swirling shadows **focus on random players**, then after 5 sec **tear through them in a straight line**, hitting **players in their path**. | MEASURED |
| 1316805 | Piercing Shadows | The line damage (Shadow); WH shows a separate LFR value. | MEASURED |

Damage numbers: WH tooltips show 125,011 per tick for Shadow Barrage on the "Mythic" display.
I left them out on purpose: they depend on difficulty and group size. MEASURED that WH shows them; DERIVED that a tip should not use them.

### Interruptible? No source says so, either way.
- No guide covers this trash (see §2). WH-guide says "Interrupts: none", but that line is about the **boss** only. MEASURED.
- DB2 hint. This is DERIVED, uses the unofficial emulator model, and **must not go into the tip unconfirmed**:
  - Shadow Barrage 1316702 has **no SpellCategories row** (PreventionType 0).
  - Curse of Despair 1316782 has PreventionType 0.
  - Shadewarder's Shadow Bolt Volley 1317992 and Dark Skitterer's Shadow Bolt 1318194 have **PreventionType 3** (silence + pacify).
  - In the TrinityCore server model, only PreventionType "silence" casts can be kicked. So by that model, Barrage and Curse are probably **not kickable**, and the two Shadow Bolts probably are.
  - InterruptFlags are 13 on almost all of these spells. That is the default (move/stun/combat), so it tells us nothing.
  - Check in game: a kickable cast shows a normal cast bar, not the grey shielded bar.

### What a player can do against Ip'thosh
Everything here is DERIVED from the official texts above.
- **Shadow Barrage**:
  - What it is: his main ranged attack (flag "AI Primary Ranged Attack"). It is a 4-second channel on **one target**.
  - What doesn't work: line of sight does not stop it (flag "Ignore Line of Sight").
  - Who should take it: let a tank (or whoever he targets) take it, using a defensive.
  - Solo: alone you take every tick. That fits Rob's near-instant death solo on Normal.
- **Curse of Despair**: it hits everyone. Decurse it (Curse dispel), or heal through 8 sec of damage plus 50% slow.
- **Piercing Shadows**: random players get marked for 5 sec, then a straight line hits everyone in its path. Marked players move apart, so the lines don't cross the group.
  - The text does not say where the line starts. "Lines from the boss" would be a guess.

---

## 2. Other trash in the raid

All these NPCs are listed by WH zone=17059 with location only 17059. The ids are MEASURED (WH, 14 Oct 2026).
WH's list is crowd-sourced from its client, so it may not be complete. An absence proves nothing.

### Floor "The Tomb of Ula'tek" (uiMap 2670), the same floor as Ip'thosh

| NPC | id | Where (WH) | Abilities (W 70391 + WH) |
|---|---|---|---|
| **Venomspeaker Shrix** (Elite) | 272688 | 60.5, 41.1 (1 spawn) | **Venom Barrage** 1316808: 2 sec cast, 4 sec channel, Ignore LoS, AI Primary Ranged Attack. It is the poison twin of Shadow Barrage. Instant part: 1316807. **Toxic Whirl** 1316354 / 1318637: endless toxic whirlwinds that envenom players **on contact**. Nature damage over time and -20% speed for 5 sec, **stacks**, **dispel type Poison**. **Volatile Eruption** 1316812: **4 sec cast**, Nature damage to **all players + knockback**. |
| **Shadewarder** (Elite) | 272689 | 3 spawns: 30.5,41.1 / 37.0,31.4 / 37.1,50.5 | **Shadow Bolt Volley** 1317992: **4 sec cast**, hits all players, PreventionType 3. **Shadow Blast** 1317993: 1.5 sec, current target. **Shade Ward** 1317994 (2 sec cast, channel) / 1317997: absorb shield on itself. **While the shield holds, all players take Shadow damage every 2 sec.** |
| Dark Skitterer (Elite) | 273943 | many pins around 30-45 / 29-52, a few on the other floor | Shadow Bolt 1318194 (2.5 sec, PreventionType 3), Darkskitter 1318198 (steps through shadows and strikes a player) |
| Heartstinger (Elite) | 273944 | many pins, same area | Heartsting 1317754: flies to a player, Nature damage over time for 8 sec, **dispel type Poison** |

### Floor "Kith'ix' Prison" (uiMap 2669), the boss floor

| NPC | id | Where (WH) | Abilities |
|---|---|---|---|
| **Colossal Earthbreaker** (Elite) | 273462 | 47.8-50.0 / 38.4-42.2 (15 pins) | **Heavy Landing** 1313319: on landing, Physical damage within 25 yd plus knockback. WH logs it on LFR only. **Crimson Spray** 1318731: 2.5 sec cast, damage over time plus a **heal absorb** for 15 sec. **Heaving Assault** 1318796: **4 sec cast**, **frontal cone** toward its current target, knock away. Hit players take **200% more damage from the next Heaving Assault for 30 sec (stacks)**. **Break Earth** 1318858: **5 sec cast**, damage to all players plus knock-up, and "creatures come to the caster's aid". |
| Burster Beetle (Elite) | 275675 | 44-48 / 37-46 (203 pins) | **Caustic Burst** 1318849/1318850: on death, a stacking Nature damage over time on players **within 10 yd** of the impact |
| Dark Skitterer (Elite) | 275676 | same area (274 pins) | Shadow Bolt 1318194, Darkskitter 1318198 |
| Heartstinger (Elite) | 275674 | same area (162 pins) | Heartsting 1317754 (Poison) |

Allies seen at the same spot as the Earthbreaker. All MEASURED (WH npc + W SpellName):
- Lor'themar Theron 273170: Shatter Carapace 1318607/1318618. He charges his target, which then takes +100% damage and is stunned 10 sec.
- Zul'jarra 273172: Akil'zon's Talons 1313759. It hurls wind blades that kill enemies instantly.
- Lady Liadrin 273171: Aegis of the Blood Knights 1318606 (+100% crit and +100% healing in its radius) and Light's Chosen 1313959.

DERIVED: on the Prison floor, the Earthbreaker plus its summoned swarm looks like a scripted fight that these three NPCs help with. It sits between the floor entrance and the boss.

Not trash (boss adds, so leave them out of a trash tip): Venomous Hulk 268190, Voidweaver 268192, Mindstinger 269351, Mindstinger Egg 268201. All four have pins only at the boss or in the arena. MEASURED (WH). The adds also appear in JournalEncounterCreature, as already recorded in MH's patch_12_1_5_ids.tsv.

### Route and "is the trash required?"
- The boss is at 48.4, 26.6 on the Prison floor. MEASURED (WH). ZY gives 48.35, 27.12.
- ZY LibRover:
  - Entering from the Underbelly puts you on Zygor floor "/1" at 82.42, 73.57.
  - The stairs link "/1" 36.99, 43.44 with "/0" 48.47, 79.84.
  - ZY data.lua maps /0 = 2669 and /1 = 2670.
  - MEASURED (local file). But ZY's boss step uses "/1" (2670) while WH puts the boss on floor 1 = 2669. **Disagreement.** The coordinates match, so ZY probably mislabels the floor. DERIVED.
- DERIVED route: entrance (2670 ~82,74) → **Ip'thosh (76.5,56.1), the first pack** → Shrix (60.5,41.1) → 3 Shadewarders (30-37, 31-50) → stairs (2670 ~37,43) → Prison (2669 ~48,80) → Earthbreaker event (~48,40) → Kith'ix (48,27).
  - This fits Rob's "first trash pack" report.
- **Whether the trash is required: no source says.**
  - The pin layout suggests a single corridor (DERIVED), but it does not prove you can't skip packs.
  - SkillCarry (a boost seller, no date) says "no trash wing". That is about run length, not about whether packs can be skipped. It is a weak source and conflicts with the elite trash that exists.
  - The WH-guide line "treacherous journey littered with enemies" is about the **outdoor Underbelly** route **to** the entrance (it comes with /way #2613 74.0 7.4), not about inside the raid. MEASURED.
- **DBM has no trash mod** for this raid. DBM-Lairs-Midnight has only Kithix.lua (boss, encounter 3513, zone 3095). DBM-Raids-Midnight has no trash files at all. MEASURED, local files. The positive control worked: the same grep found Kithix.lua. The local DBM is v12.1.13 (rev 14 Sep 2026), so a newer DBM could differ.
- No guide found with a trash section: WH-guide, Icy Veins boss guide, Method, Skycoach, raidstrats, warcraft.wiki. The search was empty, which proves nothing.

---

## 3. Story Mode, Raid Finder, solo or small group

| Claim | Label / source |
|---|---|
| The raid has **Story Mode, Raid Finder, Normal, Heroic, Mythic**. Mythic is flexible, 15-25 players. | MEASURED: BLZ patch notes (1 Oct 2026), WH-guide (13 Oct). |
| Blizzard's "12.1.5 arrives October 13" article lists only "Story Mode, Normal, Heroic, and Mythic", without Raid Finder. | MEASURED (news.blizzard.com). **Disagreement** with the patch notes. Warcraft Wiki lists all five opening 13 Oct 2026. WH-guide says "all difficulties" on 13 Oct, and Raid Finder ilvl is still "TBD". |
| DB2: map 3095 has difficulties 14, 15, 17, **220**, 233 | MEASURED (W MapDifficulty 70391). |
| Difficulty 220 = "Story", Min/Max players **10/10**. The MapDifficulty row has LockID 0 and ResetInterval 0 (no lockout). | MEASURED (W). That it is a 10-slot group filled with NPCs is DERIVED. |
| Story Mode is live now. You enter it by talking to the **Memory of Ancient Darkness** near the raid entrance, at the back of the Underbelly. | MEASURED: IV-news 14 Oct 2026; the same in epiccarry (no date). WH: NPC **276393** "Memory of Ancient Darkness", Underbelly (16990), around 71-73 / 8-10. |
| Quest **95211** "The Unbinding of Kith'ix" has three objectives: "Complete the Unbinding of Kith'ix raid on any difficulty", "Speak to Lady Liadrin to enter the story mode raid", "Stay a while and listen". Reward: Hiveborne Hearthstone. | MEASURED (WH quest=95211, 14 Oct). ZY: gossip "<Enter The Unbinding of Kith'ix in story mode>" on Lady Liadrin 275672 at Underbelly 71.55, 7.62. The tip says you can skip it and do the raid with a group. |
| Liadrin vs Memory of Ancient Darkness | **Two entry NPCs named by different sources.** DERIVED: Liadrin probably handles the quest step and Memory the general entry (queue). Unconfirmed. |
| **Solo Story Mode for Kith'ix**: **no source says it explicitly.** | — |
| Solo Story Mode in general (Midnight) | MEASURED, but for **other** raids:<br>• WH news 24 Mar 2026 (Voidspire): Story Mode lets you see the story "without the need to queue for a group".<br>• WH news 25 Aug 2026 (Venomous Abyss): Story Mode is a simplified version of the final bosses, entered via an NPC at the entrance. User comments report an "NPC team".<br>• warcraft.wiki "Story Mode" (no date): an extension of Follower Dungeons, players are accompanied by Story Mode NPCs.<br>Applying this to Kith'ix is DERIVED. |
| Does Story Mode have the trash (Ip'thosh)? | Unknown. WH logged no mode 220 for **any** NPC here, the boss included. So the absence on the trash proves nothing. Story Mode in other Midnight raids only gives the final boss(es), so it probably skips trash. DERIVED, weak. |
| Raid Finder solo / small group | No source specific to Kith'ix. Raid Finder is a matchmade queue (theclick.gg); MapDifficulty 17 MaxPlayers 30 (W). So you queue alone or as a small group and get filled with other players. You cannot clear it as a small group on your own. DERIVED from general LFR rules. |
| Normal solo | Rob entered Normal solo and died to the first pack. MEASURED (Rob's screenshot). Normal is flex: MapDifficulty 14 MaxPlayers 30 (W). The trash is elite and built for a group (DERIVED). |
| Unreliable source, not used | oreateai.com (likely AI-written) says Story Mode is "1-5 players". That conflicts with DB2's 10/10. Ignored. |

---

## Suggested tip content (DERIVED, for the writer, not verified in game)
- First pack: Shadowspeaker Ip'thosh (elite) is meant for a group. Solo on Normal he kills you fast. For the story, use **Story Mode** (Memory of Ancient Darkness / Lady Liadrin by the entrance), or queue Raid Finder.
- Shadow Barrage: a 2-sec cast, then 4 sec of shadow bolts on one target. Hiding behind a pillar does not help. Use a defensive or let the tank take it.
- Curse of Despair: everyone is slowed and takes damage for 8 sec. Decurse.
- Piercing Shadows (marked): move away from the group before the line comes.
- Next: Venomspeaker Shrix (poison twin: Venom Barrage, stacking Toxic Whirl (poison), Volatile Eruption knockback). Then 3 Shadewarders: break Shade Ward fast, and Shadow Bolt Volley is possibly kickable (not confirmed).
- Before the boss: Colossal Earthbreaker with Lor'themar, Zul'jarra and Liadrin. Dodge Heaving Assault (frontal, stacking). Burster Beetles burst on death (10 yd).
- Do not write "interrupt Shadow Barrage" until someone has seen whether the cast bar has a shield.
