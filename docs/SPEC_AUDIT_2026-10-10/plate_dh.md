# Spec audit 10 Oct 2026: Warrior, Paladin, Death Knight, Demon Hunter

Scope: Arms 71, Fury 72, Prot Warrior 73, Holy 65, Prot Paladin 66, Ret 70, Blood 250, Frost 251, Unholy 252,
Havoc 577, Vengeance 581, Devourer 1480 (Devourer exists in 12.1: ChrSpecialization ID 1480, class 12, OrderIndex 2,
so spec index 3. MEASURED).

Two bug types: (1) one choice for all specs where specs differ, (2) spells that are gone, passive, or one half
of a talent choice node shown as if everyone has it.

Labels: **MEASURED** (GEMETEN) = seen in Blizzard's DB2 on wago.tools, build **12.1.0.69933**, read 10 Oct 2026
(tables SpellName, Spell, SpellEffect, SpellCooldowns, SpellLearnSpell, SkillLineAbility, SkillLineXTraitTree,
SpecializationSpells, TraitDefinition, TraitNodeEntry, TraitNodeXTraitNodeEntry, TraitNode, TraitCond,
TraitNodeGroupXTraitCond, SpecSetMember, TraitSubTree, ChrSpecialization), or in a named, dated guide page.
**DERIVED** (AFGELEID) = reasoned from that data or from the code; not seen in the game.

Live talent trees (SkillLineXTraitTree, MEASURED): Warrior 850, Paladin 790, Death Knight 750, Demon Hunter 854.
A spell that only sits in another tree (880, 898, ...) is not in the 12.1 game.
"Choice node" = TraitNode Type 2. "granted" = TraitCond type 2 for that spec (free); "visible" = type 1.

Guides used (all labelled 12.1 by the site; most predate Season 2 on 18 Aug, which is a weakness):
Icy Veins Holy Paladin builds (last updated 10 Aug 2026), Ret spell list (11 Aug 2026), Havoc / Vengeance /
Devourer spell lists (10 Aug 2026), Arms and Fury builds (25 Aug 2026).

Severity: **WRONG** = tells the player something false or gives a button that cannot work. **STALE** = comment
or unreachable code only. **RISK** = one half of a choice node shown as if everyone has it.

---

## WRONG

### W1. Devourer has no interrupt in MH
- **Where:** `Modules/InterruptMacrosData.lua:20` `DEMONHUNTER = { [1] = "Disrupt", [2] = "Disrupt" }`. No `[3]`.
- **What MH says:** for Devourer (spec index 3) `ns.MH_GetInterruptSpell` returns nil. The Macros tab shows
  `MACROS_ERR_EMPTY_SPEC` (enUS:2441, "No interrupt macro is listed for this spec (e.g. Disc/Holy Priest)").
  ActionPrompt.lua never draws the interrupt icon (`noSpellForClass`), and InterruptScore.lua tracks nothing.
- **What is true:** Disrupt 183752 is a Demon Hunter class spell (SkillLineAbility, skill line 1848, class mask DH).
  No spec restriction and no override for 1480. MEASURED. The Icy Veins Devourer spell list (10 Aug 2026) lists
  Disrupt. MEASURED (guide).
- **Fix:** `DEMONHUNTER = { [1] = "Disrupt", [2] = "Disrupt", [3] = "Disrupt" }`.

### W2. Holy Paladin gets a Rebuke macro it cannot cast
- **Where:** `Modules/InterruptMacrosData.lua:29` `PALADIN = { [1] = "Rebuke", ... }` (index 1 = Holy).
- **What is true:** Rebuke 96231 is a talent node only for Prot (node 81604, visible to 66) and Ret (node 110093,
  visible to 70). It has no SkillLineAbility row and no SpecializationSpells row, so Holy cannot learn it. MEASURED.
  `KeybindRoles_Paladin.lua:59` already has `specs = { 66, 70 }`.
- **Effect:** Holy gets two Rebuke macros that do nothing, and InterruptScore treats "rebuke" as Holy's kick. DERIVED.
- **Fix:** `PALADIN = { [1] = false, [2] = "Rebuke", [3] = "Rebuke" }`.

### W3. Breath of Sindragosa uses the old spell ID
- **Where:** `Modules/DpsToolkit.lua:37` `{ id = 152279, cd = 120 }`. PLAYCARD_251_S1 `{SPELL:152279}` in
  `Locales/enUS.lua:1373`, `Locales/nlNL.lua:1323` and `Locales/Translations2026.lua` lines 10007, 10484, 10961,
  11438 and 11915.
- **What is true:** 152279 only appears in the old tree 898. The 12.1 talent is **1249658** (Frost node 76093,
  single node). Its cooldown is **90 s**; 152279 had 120 s. MEASURED (TraitNode, SpellCooldowns).
  `KeybindRoles_DeathKnight.lua:122` already uses 1249658.
- **Effect:** a Frost DK who has Breath of Sindragosa does not see it in the toolkit (`IsPlayerSpell(152279)` is
  false). The card shows the name in grey, as if the player does not have it. A preview shows 120 s. DERIVED.
- **Fix:** use 1249658 with cd 90 in DpsToolkit and in all 7 card texts.

### W4. Devourer's The Hunt uses Havoc's ID
- **Where:** `Modules/DpsToolkit.lua:74` `[1480] = { ..., { id = 370965, cd = 90 }, ... }` (the comment says AFGELEID).
- **What is true:** The Hunt 370965 (node 90921) is visible only to Havoc 577. Devourer has its own The Hunt
  **1246167** (node 109503, visible to 1480, cooldown 90 s, Cosmic damage). MEASURED. PLAYCARD_1480_HERO1 already
  uses 1246167.
- **Effect:** a Devourer never sees The Hunt in its toolkit. A preview shows Havoc's spell. DERIVED.
- **Fix:** `{ id = 1246167, cd = 90 }`.

### W5. Unholy "Pet Hook" macro: the pet has no Hook
- **Where:** `Modules/TeamMacrosData.lua:47-54`, DEATHKNIGHT [3] `pet_hook`, `/cast [@focus,harm,nodead][] Hook`,
  described as "Commands your pet to use Abomination Hook".
- **What is true:**
  - Hook 212468 and 212469 belong only to skill line 2216 "Pet - Abomination". MEASURED.
  - Unholy's permanent pet is the Ghoul: Raise Dead 46584 is a SpecializationSpells row for 252. The ghoul skill
    line 782 has Claw, Gnaw, Leap, Huddle, Sweeping Claws and Monstrous Blow, but no Hook. MEASURED.
  - Raise Abomination 1242608 is a passive talent (dummy auras only) on a choice node with Summon Gargoyle 1242147
    (node 76176, Unholy). Its description: "Army of the Dead now raises an Abomination for [duration] ...".
    MEASURED.
  - So the Abomination is a temporary Army summon, not a pet you command. DERIVED.
- **Effect:** the macro cannot work. Players who picked Gargoyle don't get an Abomination at all.
- **Fix:** remove `pet_hook`. If you want a ghoul macro instead (for example Gnaw or Leap), check it in the game first.

### W6. Havoc "Cursor Sigil" macro casts a spell Havoc does not have
- **Where:** `Modules/TeamMacrosData.lua:59-66`, DEMONHUNTER [1] (Havoc) `cursor_sigil`,
  `/cast [@cursor] Sigil of Flame`.
- **What is true:**
  - Sigil of Flame (204596, 320794) appears only as SpecializationSpells rows for Vengeance 581. It has no node in
    the live tree 854. MEASURED.
  - The Icy Veins Havoc spell list (10 Aug 2026) does not list Sigil of Flame. Sigil of Misery and Metamorphosis are
    on the same page, so the search did find spells there (positive control). MEASURED (guide).
- **Fix:** remove it, or replace it with Sigil of Misery 207684 (a class talent) at the cursor.
- **Checked and fine:** the Havoc "Cursor Metamorphosis" macro next to it is correct. 191427 targets a ground spot
  (ImplicitTarget 87), and Icy Veins says "Leap up to 40 yards to your targeted area".

### W7. Prot/Ret told they can dispel Magic
- **Where:** `Modules/HealerCooldowns.lua:296` `NONHEALER_DISPELS.PALADIN` row
  `{ id = 4987, types = { "magic" } } -- Cleanse (DBM: Magic for non-Holy)`.
- **What is true:** Cleanse 4987 is a SpecializationSpells row for Holy 65 only, with no talent node. MEASURED.
  Prot and Ret have only Cleanse Toxins 213644 (node 81507, visible to 66 and 70), which removes Poison and Disease.
  MEASURED.
- **Effect:** on your own spec the IsPlayerSpell filter hides the row. But `PlayCardWindow.lua:490-499`
  (FriendlyDispels) gives the whole class list when you look at a spec that is not your active one. So a Holy
  Paladin looking at the Prot or Ret card reads "removes Magic". DERIVED.
- **Fix:** delete the 4987 row from NONHEALER_DISPELS.PALADIN, and correct the comment.

### W8 (minor). Aura Mastery note says "only works with Devotion Aura"
- **Where:** `Locales/enUS.lua:1698` `GROUP_NOTE_AURA_MASTERY` = "only works with Devotion Aura on; ...".
- **What is true:** Aura Mastery 31821 "Empowers your chosen aura". With Devotion Aura you get more damage
  reduction, with Crusader Aura more mount speed, and with Concentration Aura immunity to interrupts and silences.
  MEASURED (Spell description). All three auras exist for every Paladin spec: Auras of the Resolute 385633 is
  granted to 65, 66 and 70 (node 81600) and teaches 465, 317920 and 32223 (SpellLearnSpell). MEASURED.
- **Fix:** "the extra damage reduction only comes with Devotion Aura on; ..." (and the other 6 packs).

---

## RISK (half of a choice node shown to everyone)

### R1. Beacon of Light reminder for Holy players with Beacon of Virtue
- **Where:** `Modules/MissingBuffData.lua:85` (Beacon of Light 53563, kind "ally", specs {65}), used by
  `MissingBuff.lua:253-277`.
- **What is true:** Beacon of Virtue 200025 overrides 53563. It sits on a choice node with Beacon of Faith
  (node 81554). MEASURED. Icy Veins Holy (10 Aug) says you can switch between Faith and Virtue per fight, and MH's own
  PLAYCARD_65_AOE uses Virtue. MEASURED (guide).
- **Effect:** `IsKnown()` uses `IsSpellKnownOrOverridesKnown`, so it is true for a Virtue player. Nobody in the group
  carries aura 53563, because Virtue lasts only seconds. So the player sees "buff ally: Beacon of Light" in every
  group, and the secure button casts the override, Beacon of Virtue, which has a cooldown. DERIVED.
- **Fix:** skip the 53563 entry when `IsPlayerSpell(200025)`, for example with a new field `unlessSpell = 200025`.

### R2. Arms "Cursor Ravager" macro
- **Where:** `Modules/TeamMacrosData.lua:741-748`. The description says "Ravager or Bladestorm"; the macro only
  casts Ravager.
- **What is true:** for Arms, Ravager 228920 is on a choice node with Bladestorm 227847 (node 90441). MEASURED.
  Icy Veins Arms (25 Aug 2026) builds use Bladestorm ("Slayer is focused on Execute and Bladestorm") and do not name
  Ravager. MEASURED (guide). Bladestorm is not aimed at the cursor.
- **Fix:** change the description to "only with the Ravager talent", or drop the macro for Arms.

### R3. Arms "Mouseover Intervene" macro
- **Where:** `Modules/TeamMacrosData.lua:749-756`.
- **What is true:** for Arms, Intervene 3411 is on a choice node with Interpose 1244088 (node 108676). Interpose is
  aimed at the ground. MEASURED. Low impact.
- **Fix:** add a note to the description.

### R4. No keybind entry for Avenging Crusader
- **Where:** `Modules/KeybindRoles_Paladin.lua`. There is no Avenging Crusader entry, and the header (lines 43-45)
  says it was "removed ... (passive changes to Avenging Wrath)".
- **What is true:** Avenging Crusader 394088 (visible spell 216331, cooldown 60 s) is a live Holy choice node with
  Avenging Wrath (node 81584). MEASURED. Icy Veins Holy (10 Aug) has a "Lightsmith Raiding - Avenging Crusader Build".
  MEASURED (guide). `HealerCooldowns.lua:114` already lists it.
- **Effect:** a Holy player with Avenging Crusader gets their biggest cooldown as `unclassified`, with no key. The
  site's standard block puts Avenging Wrath on Q for Holy. DERIVED.
- **Fix:** add `["Avenging Crusader"] = { id = 216331, role = "cooldown_bar", blockQ = { [65] = true }, specs = { 65 } }`
  with an `excludes` against Avenging Wrath. Note that adding an entry can move keys, so that is the lead's call.

### R5. Site standard key block puts spells on specs that cannot have them
- **Where:** `tools/keyblock_specs.lua:46-49,111` treats every KeybindRoles entry without `specs` as known by every
  spec of the class. The output is `data/keyblock_specs.json`. MEASURED in that file.
  - **Vengeance:** The Hunt 370965 on F1. Vengeance has no The Hunt in 12.1 (node 90921 is visible to 577 only).
    Icy Veins Vengeance (10 Aug) mentions The Hunt only in the Art of the Glaive text. MEASURED.
  - **Devourer:**
    - The Hunt with ID 370965 instead of 1246167.
    - Felblade, which has nodes only for 577 (91008) and 581 (108722).
    - Immolation Aura on key 3 and Soul Immolation on Shift-3. For 1480, Soul Immolation overrides Immolation Aura
      (node 107344), so that is one button on two keys.
    - All MEASURED. Icy Veins Devourer (10 Aug) lists neither Felblade nor Immolation Aura; Disrupt, The Hunt and
      Soul Immolation are found on the same page.
  - **Holy:**
    - Cleanse Toxins on Shift-Q. It is Prot/Ret only (node 81507). MEASURED.
    - Divine Protection shown with Ret's ID 403876. Holy's is 498 (SpecializationSpells 65). MEASURED.
- **Root cause:**
  - `KeybindRoles_DemonHunter.lua`: line 67 (Felblade) and line 96 (Immolation Aura) have no `specs`.
  - `KeybindRoles_DemonHunter.lua:72` (The Hunt) has no `specs` and only Havoc's ID.
  - `KeybindRoles_Paladin.lua:82` (Cleanse Toxins) has no `specs`.
- **Fix:**
  - Felblade `{577,581}`, Immolation Aura `{577,581}`, Cleanse Toxins `{66,70}`.
  - The Hunt `{577}`, plus a separate Devourer entry (another table key, for example `"The Hunt (Devourer)"`) with
    `id = 1246167`.
  - Then regenerate the JSON. It is already older than the code: Prot Paladin there still has Hammer of the
    Righteous as 88263, while KeybindRoles has 53595 since 7 Oct.
  - The in-game block uses the live spellbook and is not affected (`KeyBlock.lua:17-18`).

### R6. Holy dispel types assume a talent
- **Where:** `Modules/HealerCooldowns.lua:265` `HEALER_DISPELS[65] = { types = { "magic", "poison", "disease" } }`.
- **What is true:** Holy's Cleanse removes Magic. Poison and Disease need Improved Cleanse 393024 (a Holy talent,
  node 81508, not granted). MEASURED. Most builds take it (DERIVED, not checked). Low impact.
- **Fix:** add the talent condition to the comment, or check `IsPlayerSpell(393024)`.

### R7. Holy play card names one half of three choice nodes
- **Where:** `Locales/enUS.lua:1289, 1293, 1294, 1295` (PLAYCARD_65_S1, AOE, MISTAKE, HERO1).
- **What is true:** each name is one half of a Holy choice node. MEASURED.
  - Divine Toll 375576 (other half: Holy Prism, node 81496).
  - Avenging Wrath 31884 (other half: Avenging Crusader, node 81584).
  - Beacon of Virtue 200025 (other half: Beacon of Faith, node 81554).
- **Why it is low:** the card greys out spells you do not have, and HERO2 says "Lightsmith: no Divine Toll".

### R8. Prot Paladin card names only Blessed Hammer
- **Where:** `Locales/enUS.lua:1240` (PLAYCARD_66_S3).
- **What is true:** Blessed Hammer 204019 is on a choice node with Hammer of the Righteous 53595 (node 81469).
  MEASURED. Low impact.

### R9. Holy toolkit has no Holy Prism
- **Where:** `Modules/HealerCooldowns.lua:112-119`.
- **What is true:** the Holy cooldown list has Divine Toll but not Holy Prism, the other half of node 81496. A Holy
  Prism player gets no row for it. This is a gap, not a false statement.

### R10. DPS toolkit preview shows both halves of a choice
- **Where:** `Modules/DpsToolkit.lua:68-69`.
- **What is true:** the two halves of a choice are listed side by side. MEASURED nodes:
  - Arms: Bladestorm with Ravager (node 90441).
  - Fury: Avatar with Bladestorm (node 90415).
- **Effect:** on your own spec you only see the half you picked (`RoleAcademy.lua:846-868`). A preview of another
  spec shows both halves with no "or". Low impact.

---

## STALE (comment only, or code that is never reached)

1. **`KeybindRoles_Paladin.lua:43-45`:** "Avenging Crusader (passive changes to Avenging Wrath)" was removed. That is
   false; see R4.
2. **`KeybindRoles_Paladin.lua:16-18`:** "Rebuke ... (alle 3 specs kunnen 'm leren)" is false. The code at line 59 is
   already right. Lines 162-166 say Holy is "NOT measured" for Hand of Reckoning: 62124 is a class baseline spell
   (SkillLineAbility line 800, acquire 2), so all three specs have it. MEASURED.
3. **`KeybindRoles_DemonHunter.lua:39-41`:** the comment says "Baseline (BEIDE specs 577+581): ... Felblade, The Hunt".
   The Hunt 370965 is Havoc only; Felblade is Havoc and Vengeance. MEASURED. See R5.
4. **`KeybindRoles_DeathKnight.lua:145`:** the comment says "Unholy 108194". 108194 is in no live tree, has no
   SkillLineAbility row and no SpecializationSpells row. MEASURED.
5. **`DpsToolkit.lua:108`:** `DPS_DEFENSIVES[70]` has Shield of Vengeance 184662. That is no longer a button:
   Divine Protection 403876 casts it when you have talent 1261562. MEASURED. Nothing renders this table
   (`RoleAcademy.lua:891`).
6. **`KeybindingData.lua:337-416`:** the Paladin hand-maps (`paladin_early`, `paladin_retribution`) are never reached.
   `KeybindLayoutSlug.lua:48-58` always returns nil, and `KeybindSlugFromGuidePreview` is never called. They hold
   85256 Templar's Verdict, which Final Verdict replaces (node 81532). MEASURED. `enUS.lua:2480` (LAYOUT_NO_MAP_HINT)
   and `enUS.lua:2801` (INFO_DRAWER_BODY_GUIDE) still advertise a Paladin key map. Low impact.

---

## Checked and found correct (so silence means "looked", not "skipped")

Every ID below was looked up in the DB2 tables above for build 12.1.0.69933.

| File | What was checked | Right | Finding |
|---|---|---|---|
| `MissingBuffData.lua` + `MissingBuff.lua` | Battle Shout; 3 stances with their spec mapping; 2 Rites; Beacon of Light/Faith; Paladin aura 465; DK pet 46584 | 10 of 11 | R1 |
| `HealerCooldowns.lua` (65 + Paladin non-healer) | 6 cooldowns, 5 core heals, 2 defensives, 1 dispel, 2 non-healer dispels | 14 of 16 | W7, R6 (R9 gap) |
| `DpsToolkit.lua` (251, 252, 577, 70, 71, 72, 1480) | 31 cooldowns, 12 defensives | 29 + 11 | W3, W4, S5 (R10) |
| `TankToolkit.lua` (66, 73, 250, 581) | 6 mitigation, 17 cooldowns, 23 taunt/kick/stun/AoE | 46 of 46 | — |
| `TankPullSummary.lua` | 4 uptime auras (Bone Shield 195181 aura exists) | 4 | — |
| `GroupPlan.lua` (66, 71, 72, 73, 250, 251, 252, 65, 70) | 43 rows; ownership filter covers Intervene/Interpose, Spellwarding, Berserker Shout | 43 | W8 (the note text) |
| `GroupRezLust.lua` | Intercession 391054 and Raise Ally 61999 (both class baseline, SkillLineAbility acquire 2) | 2 | — |
| `ConsumableReadyCheck.lua` | Battle Shout 6673 | 1 | — |
| `HealerSolo.lua` [65] | 5 IDs (Holy Judgment 275773, Holy SotR 415091 are SpecializationSpells 65) | 5 | — |
| `PlayCardWindow.lua` ENEMY_DISPELS (DH) | Consume Magic 278326, a class talent for all 3 DH specs | 2 | — |
| `DispelHelper.lua` OFFENSIVE_PURGES | No entries for my 4 classes (DH purposely left out) | n/a | — |
| `InterruptMacrosData.lua` | 12 spec slots | 10 | W1, W2 |
| `TeamMacrosData.lua` | 21 macros (DK 5, DH 4, Paladin 7, Warrior 5) | 16 | W5, W6, R2, R3 |
| `GearEnchantCheck.lua` | DK gets no weapon enchant (runeforge) at lines 580 and 809 | ok | — |
| `KeybindRoles_Warrior.lua` | 53 entries | all IDs live; choice halves noted in comments | — |
| `KeybindRoles_Paladin.lua` | about 50 entries | live | R4, R5, STALE 1-2 |
| `KeybindRoles_DeathKnight.lua` | about 46 entries | live | STALE 4 |
| `KeybindRoles_DemonHunter.lua` | about 49 entries | live | R5, STALE 3 |
| `KeyBlock.lua` (in-game) | uses the live spellbook | ok | — |
| `PlayCards.lua` + PLAYCARD_* in enUS (12 specs, 115 keys, about 108 spell refs) | spell IDs plus all 24 HERO lines | 24 of 24 hero pairs right | W3, R7, R8 |
| enUS GROUP_NOTE_* / SURVIVAL_NOTE_* for my classes | names in the text checked; Final Stand 204077, Shining Light 321136 and Infusion of Light 53576 exist | ok | W8 |

### Details behind the table

**Missing buff.** The stance mapping is right. Defensive Stance is granted to 71, 72 and 73; Battle Stance to 71 and
73; Berserker Stance to 72 (MEASURED). Which stance each spec should use (Arms Battle, Fury Berserker, Prot Defensive)
is DERIVED and was not checked against a dated guide this session. Devotion Aura as the default for all three specs
is DERIVED; all three auras exist for every spec (MEASURED).

**Hero trees.** All 24 HERO lines on the play cards name the right pair (MEASURED via the TraitSubTree selection
nodes):

| Spec | Hero trees |
|---|---|
| Blood | San'layn / Deathbringer |
| Frost | Deathbringer / Rider |
| Unholy | Rider / San'layn |
| Havoc | Fel-Scarred / Aldrachi |
| Vengeance | Annihilator / Aldrachi |
| Devourer | Void-Scarred / Annihilator |
| Ret | Templar / Herald |
| Prot Paladin | Templar / Lightsmith |
| Holy | Herald / Lightsmith |
| Arms | Slayer / Colossus |
| Fury | Slayer / Mountain Thane |
| Prot Warrior | Mountain Thane / Colossus |

Light's Guidance replaces Divine Toll for Prot and Wake of Ashes for Ret with Hammer of Light (MEASURED). That matches
PLAYCARD_66_HERO1 and PLAYCARD_70_HERO1.

**Override and proc spells.** These have no talent node, which is expected. Their names exist in SpellName:
Annihilation, Death Sweep, Reaver's Glaive, Devour, Cull, Eradicate 1225826, Collapsing Star, Hungering Slash,
Vampiric Strike 433895, Thunder Blast 435222 and Sacred Weapon 432472.

---

## Not checked (so nobody reads this as "fine")
- Nothing was tested in the game. Every "Effect" line is DERIVED from the code.
- Cooldown numbers were not audited. Only 1249658, 1246167 and 216331 were compared with SpellCooldowns.
- Not looked at: ConsumablesWowheadData, VaultAdvisorData, TierSetData, SimcExport and GearExport.
- Locale text was searched by spell name (enUS only). Translations were checked only to find where 152279 sits.
- The guide pages are mostly from 10-11 Aug 2026, before Season 2. The Arms and Fury pages are from 25 Aug 2026.
