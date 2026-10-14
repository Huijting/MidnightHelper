# The Labyrinth of Kindo'jan: room boss abilities (research, 14 Oct 2026)

Read-only research for Midnight Helper. No addon file was edited. Read on 14 Oct 2026 (EU-live 12.1.5.70391).

## Sources and how strong each link is

| tag | source | build/date | what it proves |
|---|---|---|---|
| DE | wago.tools DB2 `DungeonEncounter` (filter MapID=3043, plus full CSV) | **12.1.5.70391** (page header), read 14 Oct | encounter id and name. Blizzard data. |
| DB2 | wago.tools DB2 `SpellName` + `Spell` (full CSV, 416,202 rows) | 12.1.5.70391 (current build on wago), read 14 Oct | spell id, name and official description. **A description that names the boss ("Shadowhunter Jo'din fractures...") is the strongest spell-to-boss link we have.** |
| WH-NPC | Wowhead NPC page, "Abilities" list (`g_listviews.abilities`) | read 14 Oct (Wowhead gives no date for this list) | Wowhead says this NPC uses this spell. It is Wowhead's data, not the client. |
| WH-TT | Wowhead tooltip (`nether.wowhead.com/tooltip/spell/<id>`) | read 14 Oct | cast time, duration, %. **Flat damage numbers are unscaled (e.g. "3 Shadow damage"), so ignore them.** |
| WH-G | Wowhead guide 34973 (Sinzhu), header "Updated: 2026/10/13" | read 14 Oct | Kindo'jan tactics and links to spell ids. |
| ZYG | local Zygor `ZygorDungeonCommonMID.lua` (mtime 14 Oct 07:49:58) | read 14 Oct | objectives, NPC ids, a few tactic tips. |

- `JournalEncounter` has **no** entry for the Labyrinth: filter Name=Kindo, and DungeonEncounterID=3646, both "No entries found". Positive check: the same filter on "Nalorakk" returns 2 rows. So there is no Dungeon Journal text to read. (MEASURED, DB2 12.1.5.70391)
- `BroadcastText` (boss emotes) and the client `Creature` table are no help here. wago's BroadcastText CSV holds only 10,841 rows and stops at ID 317379. A filter on "Jo'din" finds nothing. The Creature CSV (23,141 rows) contains none of our boss ids. (MEASURED, 14 Oct)
- "Blood Contract" (1248109) shows up on almost every Wowhead NPC list. It is **Valeera's** mark on an enemy ("Valeera marks a random enemy for death...", DB2). It is not a boss ability, so it is left out below.

Status column: **MEASURED** = seen in the named source. **DERIVED** = my reasoning. **candidate** = a name or id near the boss's spells, with no link to the boss in data or a guide.

---

## Priority 1

### Sha'Kuro: encounter 3528

Wowhead lists two NPCs. **262930 "Sha'Kuro <Vile Wraith>"** (Undead, location 16913) has 5 abilities. **264495 "Sha'Kuro <Lich Ascendant>"** (Humanoid, troll sounds) has **no** abilities on Wowhead. ZYG uses 262930 in "Reliquary Ritual" (scenario 3349) and 264495 after Head Ritualist Malakk (scenario 3679) and in other tasks.

| spell | id | what it does (official description) | extra (WH-TT) | source | status |
|---|---|---|---|---|---|
| Soul Storm | 1288806 (+1288948 damage, 1288872/1288907/1288939, 1289040 Summon Souls all point to it) | "rips life from nearby Unfortunate Souls, gaining protection and inflicting Shadow damage to all players" until all Souls are destroyed | 16 sec channel, 30 sec cd | WH-NPC 262930 + DB2 | MEASURED (only for 262930) |
| Rotten Cascade | 1289267 / 1289269 | necrotic energy spills across the arena; anyone caught is hit and **rooted 5 sec** | 1289269: 3.5 sec cast. The root is a **Curse**. | WH-NPC 262930 (also on Jun'ala) + DB2 | MEASURED |
| Vile Bolt | 1289330 | "Launch a vile bolt at the enemy" | 2 sec cast, 3 sec cd | WH-NPC 262930 + DB2 | MEASURED |
| Soul Ritual | 1289056 | "Siphoning power from nearby unfortunate souls, the caster is immune to interrupt effects and takes reduced damage" | – | DB2 only: no Wowhead NPC lists it. The id is next to Soul Storm, and the text uses the same "unfortunate souls". | **candidate** (DERIVED) |

- 264495 (Lich Ascendant): **no spell data anywhere** (Wowhead lists nothing; no DB2 description names "Sha'Kuro"). DBM: an empty stub. **Not known.**
- Wowhead comment on npc=262930 (ruddvan, 14 Oct 01:20 CDT): *"Don't kill him before the 2nd burrow and soul storm or it won't give the kill credit"*. **That is one player's claim, not confirmed.** It does fit our launch-bug line (Sha'Kuro is on that list). MEASURED that the comment exists; the claim itself is unverified.

### Shadowhunter Jo'din: encounter 3646

Wowhead NPC **275050** ("Shadowhunter Jo'din", first seen 120105, no location, no abilities, no comments). ZYG: not present (positive check: the same grep finds "Treasure Hunter" in other guides).

| spell | id | what it does | extra (WH-TT) | source | status |
|---|---|---|---|---|---|
| Soul Shatter | **1317484** | "**Shadowhunter Jo'din** fractures your soul, inflicting Shadow damage every 2 sec for 30 sec. This applies 3 applications and creates a soul fragment for each application. Gathering each soul fragment removes an application." | **1.5 sec cast**, 50 yd, 30 sec DoT, tick every 2 sec | DB2 (the description names him) + WH-TT | **MEASURED** |
| Soul Shatter (same name, no text) | 1317487, 1317490, 1317491, 1317564 | – (helper spells, likely the fragment/pick-up parts) | – | DB2 | DERIVED |
| Hex Bomb | 1317482 | "Transforms an enemy into a frog, rendering it unable to attack or cast spells" | – | DB2. The id sits right next to Soul Shatter and fits a shadowhunter; nothing links it to him. | **candidate** |
| Throw Spear / Stalker Spear | 1317426 / 1317449 | throws a weapon, Physical damage / (no text) | – | DB2, nearby id | **candidate** |
| Fixate | 1317528 | "chasing them down while ignoring all others" | – | DB2, nearby id | **candidate** |
| Serpent Ward → Flame Spit | 1317601 → 1317598 | totem that spits flame at random players | – | DB2, nearby id; Wowhead: Serpent Ward summons an NPC | **candidate** |

- Our current tip text ("Shadow damage-over-time with 3 stacks, every stack leaves a soul shard: pick the shards up") matches 1317484 word for word. MEASURED. New: it has a **1.5 sec cast**, so it can probably be interrupted. That last part is DERIVED; interruptibility is not in DB2 or the tooltip.

### Treasure Hunter Taltrois: encounter 3642

Wowhead NPC **274554** "Treasure Hunter Taltrois **<Relic Raiders>**" (first seen 120105, no location, no abilities, no comments). ZYG: not present.

| spell | id | what it does | source | status |
|---|---|---|---|---|
| – | – | **No spell found.** No DB2 description names "Taltrois". A keyword scan (treasure hunter, relic raider, excavat, dynamite, plunder, loot) over all spell ids ≥ 1,280,000 gives nothing tied to him. | DB2 + WH-NPC | **not known** |

- MEASURED: his tag is **Relic Raiders**, the same tag as Cynthra Buttonsmasher, The Drill Sergeant and the Pit Boss (Wowhead NPC data). So "maybe the leader of the graverobbers" in our tip can become "one of the Relic Raiders, the looters, like Cynthra and the Drill Sergeant". The WGE guide (12 Oct) also says the looters are "led in at least one chamber by Treasure Hunter Taltrois". That is a guide statement, not data.
- Candidate, very weak: **Excavating Blast** 1305201 ("Nature damage within X yards and more every few sec... Blast Chunks rain down"). Nothing links it to Taltrois. Note that Wowhead's NPC **page** for 266370 is titled "Looter Excavator" (see Pit Boss). Do **not** use it.

---

## Other bosses with an encounter id

### Jun'ala: encounter 3526 (NPC 264183, "The Vile Necromancer")

| spell | id | what it does | extra (WH-TT) | source | status |
|---|---|---|---|---|---|
| Forbidden Ritual | 1291717 (+1291903) | "completes a dark ritual, calling forth spirits to aid the caster in battle" | **8 sec channel**, 30 sec cd | WH-NPC + DB2 | MEASURED |
| Beckoning Death | 1292001 | frontal: damage to enemies in front, **knockback**, then damage every 3 sec for 15 sec | 3 sec cast, 20 yd. The DoT is a **Curse**. | WH-NPC (also on Den'Zara) + DB2 | MEASURED |
| Vile Bolts | 1292020 / 1292023 | "Launch a volley of vile bolts at the enemy" | instant | WH-NPC + DB2 | MEASURED |
| Rotten Cascade | 1289267 | arena-wide necrotic wave, **root 5 sec** (Curse) | instant | WH-NPC (also on Sha'Kuro) + DB2 | MEASURED |

- Our tip says "Her Forbidden Ritual cannot be interrupted". DB2 and the tooltip **do not say** whether it can be interrupted. Not measurable here; I assume it comes from Rob's own PTR run.

### Sullied Revenant: encounter 3527 (NPC 264203)

| spell | id | what it does | extra | source | status |
|---|---|---|---|---|---|
| Necrotic Sweep | 1292666 | "swings its ghostly weapon in a wide arc", Shadow damage, DoT 15 sec (**Curse**), **knocks back** enemies in front | 3 sec cast, 20 yd | WH-NPC + DB2 | MEASURED |
| Soul Traps | 1292905 / 1293042 | traps souls in "sinister jars". The traps call **Tormented Souls** and release a Redeemed Soul when defeated. "Destroying the traps may free the souls." | 1292905: 4 sec cast | WH-NPC + DB2 | MEASURED |
| Deluge of Torment | 1293191 | "coalesces a Tormented Soul to join the battle" | – | DB2 only; the id and the "Tormented Soul" wording fit Soul Traps | **candidate** |

### Den'Zara: encounter 3556 (NPC 266742, "Vilebranch Warlord")

The DB2 encounter name is **"Den'Zara"** (capital Z). Our label "Den'zara" still matches, because the matcher lowercases both sides (DelveCoach.lua:1907-1910).

| spell | id | what it does | extra | source | status |
|---|---|---|---|---|---|
| Storm of Torment | 1292178 / 1292424 (+1292127/28/29/30/40/46) | "A whirling storm of necrotic energy **pulls** nearby enemies and damages those caught in its wake" | 3 sec cast. Aura 1292141: "Spirits grasp at your feet, rooting you". | WH-NPC + DB2 | MEASURED |
| Beckoning Death | 1292001 | frontal + knockback + 15 sec Curse DoT | 3 sec cast | WH-NPC + DB2 | MEASURED |
| Vile Bolts | 1292023 | volley of bolts | – | WH-NPC + DB2 | MEASURED |

- Our tip ("Not known yet: ... Den'zara's attacks") is out of date. The three above are known. MEASURED (Wowhead + DB2). Method (10 Oct) calls her "fairly easy to take down".

### Drill Sergeant: encounter 3622 (NPC 273069, Wowhead name "**The** Drill Sergeant <Relic Raiders>")

Wowhead lists no abilities for 273069. The link comes from the descriptions, which **name "Drill Sergeant"**. The only 12.x NPC with that name on Wowhead is 273069 (the others are 11.1: 231925, 234773, 235046). So the link is MEASURED by name and DERIVED by elimination.

| spell | id | what it does | extra (WH-TT) | source | status |
|---|---|---|---|---|---|
| Glitching Shield | **1312409** | "Drill Sergeant initiates a defensive shield, reducing damage taken... **Collision with large objects can cause the shield to fail.**" | 1.5 sec cast, **-90% damage taken for 30 sec**, buff type **Magic** | DB2 + WH-TT | MEASURED |
| Overcharge Engine → Engine Fire | **1312418** → 1312420 | +20% attack speed and Fire damage to everyone within 30 yd every 1.5 sec, for 15 sec | 1.5 sec cast | DB2 + WH-TT | MEASURED |
| Seismic Detonation | **1312423** (+1312481, 1313027 rocks, 1313032/1313484/1313485) | drills into the ground: Nature damage within 10 yd, and launched rocks that hit and **knock back** within 6 yd of where they land | **3 sec cast** | DB2 + WH-TT | MEASURED |

- Zygor's tip "Aim the charge so it hits a rock to remove the damage shield" (ZYG, 14 Oct) matches Glitching Shield's text. MEASURED in both. Being Magic means a purge or dispel *might* remove it; that is DERIVED and not tested.
- Wowhead also lists NPC **273713 "Drill Driver" <Relic Raiders>** (elite, in the Labyrinth), no abilities. DERIVED: possibly his vehicle or rider.

### The Undead Trollbunal: encounter 3632 (NPC 272655)

| spell | id | what it does | source | status |
|---|---|---|---|---|
| – | – | **No spell found.** No Wowhead abilities and no comments. No DB2 description names "Trollbunal". A keyword scan (tribunal, judge, verdict, court, sentence) over ids ≥ 1,280,000 gives only unrelated spells. | DB2 + WH-NPC | **not known** |

- Blizzard forum bug report (14 Oct 03:39): "Killed The Undead Trollbunal. Did not get credit and won't progress", plus 1 "same exact issue". MEASURED. It matches our launch-bug line.

### Grukk: encounter 3636 (NPC 274331)

| spell | id | what it does | extra | source | status |
|---|---|---|---|---|---|
| Chaotic Frenzy → Chaotic Impact | 1315279 (+1315278, 1315293) → **1315287** | "**Grukk** jumps around furiously, inflicting Nature damage to all players within 14 yds of where he lands" | 2.5 sec cast | DB2 (names him) + WH-NPC | MEASURED |
| Interrupting Shout | 1315273 | "screams, inflicting Physical damage to nearby enemies, **interrupting spellcasting**" | **3 sec cast** | WH-NPC + DB2 | MEASURED |
| Ground Smash | 1315268 | slams the ground: Nature damage and **stuns nearby enemies 4 sec** | **3.5 sec cast**, 5 sec cd | WH-NPC + DB2 | MEASURED |
| Spectral Regeneration | 1315264 | "Heals the caster every 2 sec for 6 sec" | 6 sec channel. The heal buff is **Magic**. | WH-NPC + DB2 | MEASURED |

- Our tip only says "He jumps around and hits where he lands". DERIVED, worth adding: casters should step away during Interrupting Shout; melee should step out of Ground Smash; Spectral Regeneration is a self-heal, so kick or purge it. Whether it can be kicked is **not** measured.

### King of Souls: encounter 3648 (NPC 269822)

| spell | id | what it does | extra | source | status |
|---|---|---|---|---|---|
| Frost Strike | 1305700 | (no DB2 text) tooltip: "Reduces the movement speed of the target by 50% for 12 sec. Inflicts Physical damage" | **0.5 sec cast**, 3 sec cd, 10 yd | WH-NPC + WH-TT | MEASURED |
| Bonestorm | 1305698 / 1305699 | "Whirl a storm of bones around the caster, inflicting Physical damage" | 2 sec cast, 8 yd, lasts 8 sec | WH-NPC + DB2 | MEASURED |
| Bone Armor | 1305701 | "Encases the caster in bone armor, absorbing damage" for 1 min | 2 sec cast, buff type **Magic** | WH-NPC + DB2 | MEASURED |
| Bone Spikes → Bone Spike | 1305702 (+1305706) → 1305704/1305703/1305705 | "periodically summons spikes of bone, inflicting Physical damage and **stunning** enemies" | 2 sec cast | WH-NPC + DB2 | MEASURED |

- Our tip says "His Frost Strike cannot be interrupted". DB2 says nothing about it. The tooltip shows a 0.5 sec cast, which fits "in practice you cannot kick it" (DERIVED). Bonestorm is the one to walk away from (8 yd). DERIVED.

### Cynthra Buttonsmasher: encounter 3653 (NPC 275274, <Relic Raiders>)

| spell | id | what it does | extra | source | status |
|---|---|---|---|---|---|
| Mine All Mines → Mine Go Boom | 1317917 (+1317928/35/37/39) → **1317950** | "**Cynthra** throws out mines that explode if touched", Fire damage, **knockback** within 2 yd | – | DB2 (names her) + WH-NPC | MEASURED |
| The Big Boom-Boom | 1318122 → 1318138 | Fire damage and **knockback** within 12 yd of the impact | **3 sec cast** | WH-NPC + DB2/WH-TT | MEASURED |
| Boom-Stick | 1318149 | frontal: Physical damage and knockback to everyone in front | 2.5 sec cast | WH-NPC + WH-TT | MEASURED |
| Throw Bomb | 1317885 | Fire damage within 3 yd of the impact | 2 sec cast | WH-NPC + WH-TT | MEASURED |

---

## Room bosses WITHOUT an encounter id

`DungeonEncounter` MapID 3043 has exactly 12 rows (table at the end). A name scan over the full CSV (1,359 rows) for Pit Boss, Malakk, Death Steward, Daakajin, Nesh'ikar, Rav'iki, Prisoner, Kaz'kara and Excavator finds no Labyrinth row. MEASURED. **DERIVED: these 7 never fire ENCOUNTER_START, so the panel can only find them through the unit (creature id or name).**

| boss (NPC) | spell | id | what it does | source | status |
|---|---|---|---|---|---|
| **Pit Boss** (266370) | Bombardment | 1296949 (desc → 404443) | targets up to 3 players; each bomb explodes **after 5 sec**, Fire damage within 4 yd | WH-NPC + DB2 + WH-TT (3 sec cast, 20 sec cd) | MEASURED |
| Pit Boss | Flame Wave | 1296958 | frontal: Fire damage and **knockback** | WH-NPC + WH-TT (3 sec cast) | MEASURED |
| Pit Boss | [DNT] Boss's Intimidation | 1322575 | (script spell, no text) | WH-NPC | MEASURED |
| **Head Ritualist Malakk** (263898) | Necrotic Bolt | 325386 | Shadow bolt, 2.5 sec cast | WH-NPC + WH-TT (an old shared spell) | MEASURED |
| Malakk | Shadowbolt Volley | 419223 | Shadow damage to everyone within 50 yd, 2.5 sec cast, 13 sec cd | WH-NPC + WH-TT (an old shared spell) | MEASURED |
| **Death Steward** (271909, and 270030 with the same list) | Fury of the Loa | 1289870 / 1289874 | 4.5 sec channel; **+20% attack speed for every 1.5 sec it channels**, lasts 8 sec | WH-NPC + DB2/WH-TT | MEASURED |
| Death Steward | Shadow Eruption | 1315574 / 1315576 | darkness erupts **under a player** every 1.5 sec for 3 sec | WH-NPC + DB2 (2 sec cast, 12 sec cd) | MEASURED |
| **Daakajin** (272017) | Daakajin Health Trigger | 1310108 | (script spell, no text) | DB2 + Wowhead search | MEASURED that it exists. DERIVED: this is the "weaken it until it turns friendly" trigger. No attacks known. |
| **Nesh'ikar** (269188, "Chosen of Nalorakk") | Axe Throw | 1236870 | thrown axe, Physical damage, 2 sec cast | WH-NPC + DB2 | MEASURED |
| Nesh'ikar | Berserk | 1236871 | **Enrage**: more attack speed and damage for 15 sec | WH-NPC + DB2/WH-TT | MEASURED (Enrage type, so soothe/tranq *might* work: DERIVED) |
| Nesh'ikar | Chop | 279039 | (no text; old shared spell) | WH-NPC | MEASURED |
| **Bone-Flayer Rav'iki** (270594) | Sacrificial Ritual | 1306965 | (no text) tooltip: **3 min cast** | WH-NPC + WH-TT | MEASURED. DERIVED: this is the "stop the ritual" objective. |
| Rav'iki | Spirit Burst | 1307329 | Shadow explosion within 10 yd of the impact, 3 sec cast | WH-NPC + DB2 | MEASURED |
| Rav'iki | Withering Siphon | 1258498 | leech; **-10% damage done**, 10 sec, debuff type **Magic** | WH-NPC + DB2/WH-TT | MEASURED |
| Rav'iki | Call for Help / Necrotic Bolt | 1318983 / 325386 | calls nearby allies / Shadow bolt | WH-NPC + DB2 | MEASURED |
| **The Prisoner** (271525) | Invigorating Chill | 1308624 | "**Ancient Prisoner heals 90% of maximum health every 1 sec.** Others take 1% of max health as Frost every 5 sec" | WH-NPC + DB2/WH-TT | MEASURED. DERIVED: he cannot be beaten by damage alone, which is why the task is "carry the tears to the flames". |
| The Prisoner | Frostbolt Volley, Frost Eruption, Crashing Ice, Ghostly Strike, Ethereal (immune), Predatory Focus (fixate), Tempest Rage | 457334, 377608, 386700, 258179, 163671, 406798, 1310784 | mostly old shared spells, many without text | WH-NPC | MEASURED that Wowhead lists them. **Not verified that he really casts them all.** |

---

## Kindo'jan: encounter 3548 (NPC 266500; Wowhead also has 266600 "Kindo'Jan <The First Hash'ey>", no abilities)

| spell | id | what it does | extra (WH-TT) | source | status |
|---|---|---|---|---|---|
| Disgraceful Display | 1303494 | "At three stacks, the loa will deem your soul unworthy to continue facing the First Hash'ey." | debuff lasts **5 min**. WH-G: "3 stacks within 5 minutes → instantly slain, tanks too". | DB2 + WH-TT + WH-G + LittleWigs aura | MEASURED |
| Eruption of Mojo | 1300491 (marker 1301288 "Targeted by Kindo'jan"; also 1298635/37, 1300479/80, 1301294/1301303) | "latent mojo... violently erupts, inflicting damage to nearby enemies and **launching them away**"; root aura (Curse) | instant | DB2 + WH-G + LittleWigs | MEASURED |
| Erratic Mojo | 1300767 | puddle left behind: "**33% of maximum health** every 1.5 sec... Death is close..." | – | DB2/WH-TT + WH-G + LittleWigs | MEASURED |
| Whirling Axes | 1301203 → 1300768 | spirit axes cross the platform: **66% of max health** as Physical damage | 2 sec cast | DB2/WH-TT + WH-G | MEASURED |
| Crushing Blow | 1299117 (+1299144) | "**Kindo'jan** slams the ground... within 20 yards of impact and summons an Amani Juggernaut" | **4 sec cast** | DB2 (names him) + WH-G | MEASURED |
| Hash'ey's Command | 1298647 / 1298656 | "**Kindo'Jan** summons 4 Amani Headhunters" | instant | DB2 (names him) + WH-G | MEASURED |
| Axe Barrage (Headhunter 267443) | 1298765 (+1298669/70, 1298762) | "series of axes... Physical damage to enemies hit" | – | WH-NPC + DB2 | MEASURED |
| Phalanx Charge (Juggernaut 267520) | 1298834 / 1300466 | charge with knockback (WH-G) | **5 sec cast**, 60 yd | WH-NPC + WH-TT + WH-G | MEASURED |
| Amani Aegis (Juggernaut) | 1301380 / 1301394 | shield: **-33% damage taken** for the caster and allies nearby | 3 sec cast, 10 sec cd, buff type **Magic** | WH-NPC + DB2/WH-TT | MEASURED |
| Amani Inspiration (Juggernaut) | 1305218 | "immune to loss of control effects" | – | WH-NPC + DB2 | MEASURED (= WH-G "cannot be stunned or crowd controlled") |
| De Rising Storm (Ahn'joli 269447 → Visage of Akil'zon 268237) | 1300374 / 1304644 (Furious Gale 1299561/1299646) | wind gusts: Nature damage and knockback, every few sec | – | WH-NPC + DB2 | MEASURED |
| Gambit in de Shadows (Zen'toka 269444) → Predator's Guile (Shadow of Halazzi 268152) | 1304837/1304638 → 1300206 | stuns a target and sends a Shadow of Halazzi plus **3 false images**; the leap hits the first enemy in its path, **lethal if that is the target** | – | WH-NPC + DB2 | MEASURED |
| Ursine Rampage (Bindu 269445 → Fury of Nalorakk 268094) | 1304641 → 1300045 | several Fury of Nalorakk charge forward: damage and knockback | – | WH-NPC + DB2 | MEASURED |
| Cleansing Flame (Rotahn 269449) | 1299201 / 1304640 → 1299249 | Fire damage to nearby enemies; "**If no enemies are nearby, the flames violently combust**" across the platform | – | WH-NPC + DB2 | MEASURED |
| Enrage | – | "eventually enrage after being in combat for over 10 minutes" | – | WH-G (13 Oct) + Wowhead comment npc=266500 (Katreyn, 14 Oct: "Enrage timer is 10 minutes") + WGE guide | MEASURED in guides only. No DB2 spell found. |

- Our tip says "Not known yet: his enrage timer". Now known: **about 10 minutes** (two independent sources: the Wowhead guide and a player comment). Still not in Blizzard data.
- Our tip lists only Crushing Blow, Hash'ey's Command and Disgraceful Display as his attacks. **Eruption of Mojo** (and its Erratic Mojo puddle, 33% max health per tick) and **Whirling Axes** (66% max health) are missing.
- Our tip says "only when you clear all 9 rooms in one run". Wowhead guide (13 Oct), Icy Veins (9 Oct), Skycoach (12 Oct) and ConquestCapped (13 Oct) all say: **only the first time**. After the door is open, a route to Akil'zon's Roost is enough (Icy Veins: Chamber of Rites, then Halazzi's Lair or The Cave Towers, then Akil'zon's Roost). Method and WGE do not mention repeat runs. MEASURED (guides), not seen in the client.

---

## What changed since 13 Oct

- **DBM (local)**: `DBM-Delves-Midnight` **r265**, files dated 13 Oct 21:52. All 12 Labyrinth modules are **still empty**: 12 lines each, revision 20261013182813, EncounterID only, `SetCreatureID` still `--TODO`. **Upstream (GitHub DeadlyBossMods/DBM-Dungeons)**: one commit after that, `1c7ac2df9d` 14 Oct 04:28 UTC, "forgot to actually add 12.1.5 toc". It changes only `.toc` files. **No abilities yet.** MEASURED.
- **LittleWigs**: **not installed** locally (Glob `*Wigs*` in AddOns: nothing; the same Glob finds the DBM folder). Upstream BigWigsMods/LittleWigs has **one** Labyrinth module, `Midnight/Delves/LabyrinthOfKindojan/Kindojan.lua` (commit `d59177e072`, 13 Oct 05:45 UTC). It contains encounter 3548, map 3043, and aura alerts for 1301288 Eruption of Mojo, 1300767 Erratic Mojo and 1303494 Disgraceful Display. **No room-boss modules.** `Trash.lua` adds only auto-gossip 141655 (Warlord Kaz'kara). The last commit is 13 Oct 15:28; nothing on 14 Oct. MEASURED.
- **Wowhead guide 34973**: header still "Updated: 2026/10/13". New since then: comments from 13-14 Oct (Gambit in de Shadows: stand on the line whose circle is under Valeera; do not stand *on* Valeera, the pounce splashes). **Wowhead NPC data** now lists abilities for 262930, 263898, 264183, 264203, 266370, 266742, 269188, 269822, 270030, 270594, 271525, 271909, 274331, 275274 and the Kindo'jan adds and speakers. I cannot tell when these were added; Wowhead shows no date. **Jo'din, Taltrois, Trollbunal, Drill Sergeant, Daakajin, Sha'Kuro 264495 and Kindo'jan himself still have no Wowhead ability list.**
- **Wowhead comments, 14 Oct**: Sha'Kuro 262930: "don't kill him before the 2nd burrow and soul storm or no kill credit" (one player, unverified). Kindo'jan: "enrage timer is 10 minutes".
- **Zygor**: the local `ZygorDungeonCommonMID.lua` is still the 14 Oct 07:49:58 version; nothing newer on disk. It has **no** Jo'din or Taltrois steps. The only boss-ability tips are the Drill Sergeant (charge into a rock) and Kindo'jan (loa order). I cannot measure what changed from 13 Oct to 14 Oct 07:49, because there is no old copy to compare.
- **Other guides**: Method (10 Oct), Icy Veins (9 Oct), Skycoach (12 Oct), WGE (12 Oct) and ConquestCapped (13 Oct) cover only Kindo'jan and rewards; nothing on room bosses. The Blizzard forum has a bug report (14 Oct) on Trollbunal kill credit.

---

## encounterID ↔ name (for an id table that also works on non-English clients)

| encounterID | DB2 name (enUS, 12.1.5.70391) | MapID | DBM module (r265) | LittleWigs | our panel label / creatureId | note |
|---|---|---|---|---|---|---|
| 3526 | Jun'ala | 3043 | Junala.lua (empty) | – | Jun'ala / 264183 | |
| 3527 | Sullied Revenant | 3043 | SulliedRevenant.lua (empty) | – | Sullied Revenant / 264203 | |
| 3528 | Sha'Kuro | 3043 | ShaKuro.lua (empty) | – | Sha'Kuro / 264495 (+262930) | Which of the two NPCs starts it is not measured. |
| 3548 | Kindo'jan | 3043 | Kindojan.lua (empty) | Kindojan.lua (3 auras) | Kindo'jan / 266500 | Wowhead also has NPC 266600. |
| 3556 | **Den'Zara** | 3043 | DenZara.lua (empty; en name "Den'Zara") | – | Den'zara / 266742 | Case differs; the matcher lowercases, so it still works. |
| 3622 | Drill Sergeant | 3043 | DrillSergeant.lua (empty) | – | Drill Sergeant / 273069 | Wowhead NPC name "The Drill Sergeant". |
| 3632 | The Undead Trollbunal | 3043 | TheUndeadTrollbunal.lua (empty) | – | The Undead Trollbunal / 272655 | |
| 3636 | Grukk | 3043 | Grukk.lua (empty) | – | Grukk / 274331 | |
| 3642 | Treasure Hunter Taltrois | 3043 | TreasureHunterTaltrois.lua (empty) | – | Treasure Hunter Taltrois / 274554 | |
| 3646 | Shadowhunter Jo'din | 3043 | ShadowhunterJodin.lua (empty) | – | Shadowhunter Jo'din / 275050 | |
| 3648 | King of Souls | 3043 | KingofSouls.lua (empty) | – | King of Souls / 269822 | |
| 3653 | Cynthra Buttonsmasher | 3043 | CynthraButtonsmasher.lua (empty) | – | Cynthra Buttonsmasher / 275274 | |
| – | (none) | – | – | – | Pit Boss 266370, Head Ritualist Malakk 263898, Death Steward 271909, Daakajin 272017, Nesh'ikar 269188, Bone-Flayer Rav'iki 270594, The Prisoner 271525 | No DungeonEncounter, so no ENCOUNTER_START (DERIVED). |

The DB2 encounter ids and the DBM `SetEncounterID` values match 12 out of 12. MEASURED.

Name and id remarks for the panel (all MEASURED on Wowhead, 14 Oct):
- 266370: Wowhead's NPC **page** is titled "**Looter Excavator**", but the zone NPC list and Zygor say "**Pit Boss** <Relic Raiders>". The creature-id match is not affected; a name-only match on "Pit Boss" would miss if the client says "Looter Excavator".
- Death Steward has two ids: **271909** <Custodian of the Bound> and **270030**. Both have the same ability list. Our panel has only 271909; the name match covers 270030.
- Kindo'jan has two ids: **266500** and **266600**.
- Other Wowhead NPCs in zone 16913 that are elite: Drill Driver 273713 <Relic Raiders>, Keeper of the Key 273788 (Executioner's Reave 1293457, Wild Swings, Bloodied Enrage 1314932), Amani Juggernaut 267520, Amani Headhunter 267443.
