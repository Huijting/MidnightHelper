# Spec audit 10 Oct 2026: cloth (Mage 62/63/64 · Priest 256/257/258 · Warlock 265/266/267)

Read-only audit. No code or locale file was changed.

## Sources and method

**DB2 (MEASURED).** wago.tools, build **12.1.0.69933**. The full CSVs were loaded in the browser on 10 Oct 2026:
SpellName, SpecializationSpells, SkillLineAbility, TraitDefinition, TraitNodeEntry, TraitNodeXTraitNodeEntry,
TraitNode, TraitCond, TraitNodeXTraitCond, TraitNodeGroupXTraitNode, TraitNodeGroupXTraitCond, SpecSetMember,
SkillLineXTraitTree, TraitSubTree, SpellLearnSpell and SpellCooldowns. Single rows came from the JSON route for
Spell (description), SpellMisc (passive = `Attributes_0 & 0x40`), SpellEffect, SpellCategories and SpellCategory.

- Live talent trees, from SkillLineXTraitTree: Mage **658**, Priest **795**, Warlock **720**. Tree 877 is an old
  warlock tree and is not live.
- Class skill lines: Mage 904, Priest 804, Warlock 849. Pet skill lines: Imp 188, Felhunter 189, Felguard 761.
- An id counts as **live** when one of these grants it: SpecializationSpells, the class SkillLineAbility, a node
  in a live tree, or SpellLearnSpell from such a node. Otherwise it counts as **not granted in 12.1**. A DB2 keeps
  removed spells, so being in SpellName alone proves nothing.
- **Choice node** means TraitNode.Type = 2.
- ⚠️ The CSVs are the build's own DB2 without the hotfix overlay (the "Use Hotfixes" toggle is off).

**Guides (DERIVED):**
- Icy Veins Affliction rotation page (Last Updated 31 Aug 2026, §6.3 "Demon Choice")
- Icy Veins Destruction rotation page (31 Aug 2026, §5.4 "Pet Choice")
- Wowhead Affliction talent builds (2026/08/12) and Method Affliction (12 Aug 2026): neither names a pet in text.

Severity:
- **WRONG** = tells the player something false, or a button that cannot work.
- **RISK** = one half of a talent choice (or one pick for every spec) shown to everyone.
- **STALE** = a comment, an unused table, or a label.

---

## Findings

### WRONG

**C1. `Modules/MissingBuffData.lua:43`: the Arcane Familiar button can never work.**
- **What MH does:** for Arcane, while buff 210126 is missing, it shows "MISSING Arcane Familiar". The secure button
  casts spell id 205022 (`MissingBuff.lua:253-277`, attributes at `:754-758`).
- **What is true in 12.1:** 205022 is a **passive**: SpellMisc has the passive bit set, and the SpellEffect is aura 4
  (dummy). Its description says "Casting Arcane Intellect summons a Familiar ... for $210126d". You cannot cast
  205022, so clicking does nothing. The talent is Arcane node n102469.
- **Evidence:** MEASURED (DB2 plus a reading of the code).
- **Fix:** `{ spell = 1459, reqSpell = 205022, buff = 210126, kind = "self", specs = { 62 }, ... }`. The engine already
  supports `reqSpell` (`MissingBuff.lua:253`), so the button casts Arcane Intellect, which summons the Familiar.

**C2. `Modules/TeamMacrosData.lua:693-700`: the "Cursor Vile Taint" macro (Affliction) casts a spell that is gone.**
- **What MH does:** `/cast [@cursor] Vile Taint`.
- **What is true in 12.1:** none of the 2 Vile Taint ids is granted. 278350 is only in the dead tree 877. The macro
  casts nothing.
- **Evidence:** MEASURED.
- **Fix:** remove it. A possible replacement is `/cast [@cursor] Demonic Gateway`: 111771 is a live class talent,
  node n71955. That replacement is DERIVED.

**C3. `Modules/TeamMacrosData.lua:711-718`: the "Cursor Guillotine" macro (Demonology's only utility macro) casts a spell that is gone.**
- **What MH does:** `/cast [@cursor] Guillotine`.
- **What is true in 12.1:** none of the 14 Guillotine ids is granted. 386833 is only in the dead tree 877.
- **Evidence:** MEASURED.
- **Fix:** remove it, or replace it with the same Demonic Gateway cursor macro.

**C4. `Modules/DpsToolkit.lua:53`: Fire's list has Living Bomb `{ id = 44457, cd = 30 }`, a dead row.**
- **What is true in 12.1:** 30 SpellName ids are called Living Bomb, and none of them is granted.
- **Who sees it today:** nobody. On your own spec, `RoleAcademy.lua:850-859` filters on IsPlayerSpell, and a Mage
  has no non-DPS spec that would show this list as a preview. `KeybindRoles_Mage.lua:164` reaches the same
  conclusion.
- **Evidence:** MEASURED.
- **Fix:** delete the entry.

**C5. `Modules/MissingBuffData.lua:126` + `MissingBuff.lua:344-351`: Affliction and Destruction get "SUMMON PET" = Summon Imp (688).**
- **This is the same bug type as the Demonology Imp.**
- **The contradiction with MH itself:** MH's own interrupt advice for Affliction and Destruction is Spell Lock
  through the Felhunter:
  - `KeybindRoles_Warlock.lua:121-122`
  - Stay-alive card, survival override 119910
  - interrupt macro `/cast Command Demon` (`InterruptMacrosData.lua:33`)
- **What happens if you follow MH's button:** with an Imp out, Command Demon becomes Singe Magic. 89808 is on the
  Imp's skill line 188, and Spell Lock 19647 is on the Felhunter's skill line 189. So the interrupt macro stops
  interrupting, and Spell Lock drops off the Stay-alive card.
- **What the guides say (Icy Veins, 31 Aug 2026, both specs):**
  - Sayaad is best for single-target damage.
  - Felhunter "whenever an interrupt or a purge effect is required".
  - Imp only for a defensive dispel or for distant target swaps.
- **Who can summon what:** Summon Felhunter 691 and Summon Sayaad 366222 are baseline class spells (SkillLine 849).
- **Severity:** WRONG in combination with MH's own interrupt advice; RISK on its own.
- **Evidence:** MEASURED (skill lines) + DERIVED (guides).
- **Fix:** remember the demon the player last had (`UnitCreatureFamily("pet")` per spec in `ns.db`) and re-summon
  that one. Fall back to Felhunter 691 for 265/267, and offer a switch (players choose).

### RISK

**C6. `Modules/HealerCooldowns.lua:148-149`: Discipline lists both Ultimate Penitence 421453 and Power Word: Barrier 62618.**
- **What is true in 12.1:** these are the two halves of one choice node, n82564.
- **Where both show:**
  - Your own active spec is filtered (`RoleAcademy.lua:564-576`).
  - `/mh healcds` prints both unfiltered (`HealerCooldowns.lua:607`).
  - A Shadow Priest's healer preview shows both (`RoleAcademy.lua:565-567, 583`).
- **Evidence:** MEASURED.
- **Fix:** filter `/mh healcds` on IsPlayerSpell. In the preview, mark the pair as "one of these two".

**C7. `Modules/TeamMacrosData.lua:533-540`: "Cursor Barrier" (Discipline) is one half of a choice.**
- Power Word: Barrier is one half of node n82564. A Discipline Priest who picked Ultimate Penitence gets a dead
  macro.
- **Evidence:** MEASURED.
- **Fix:** gate it on IsPlayerSpell(62618), or add the GroupPlan sentence "only if you picked it instead of Ultimate
  Penitence".

**C8. `Modules/TeamMacrosData.lua:551-558`: "Cursor Sanctify" (Holy) can point at a spell the player does not have.**
- The Holy talent Ultimate Serenity 1246517 (node n103900) has `OverridesSpellID = 34861`. With that talent, Holy
  Word: Sanctify is gone.
- **Evidence:** MEASURED.
- **Fix:** gate it on IsPlayerSpell(34861), or add a note.

**C9. `Locales/enUS.lua:1520` (`PLAYCARD_267_AOE`) + `TeamMacrosData.lua:729-736`: Havoc is one half of a choice.**
- **What MH says:** "2 enemies: Havoc on the second one", plus a "Mouseover Havoc" macro.
- **What is true in 12.1:** Havoc 80240 shares choice node n71979 with Mayhem 387506, which is passive. A
  Destruction Warlock who picked Mayhem has no Havoc.
- **Evidence:** MEASURED.
- **Fix:** add "(with Mayhem this happens by itself)" to the card, and gate the macro.

**C10. `Locales/enUS.lua:1517` (`PLAYCARD_267_S3`): Soul Fire is one half of a choice.**
- **What MH says:** "{Soul Fire} whenever it is ready".
- **What is true in 12.1:** Soul Fire 6353 shares choice node n108681 with Dimensional Rift 1280868, which is
  **passive** in 12.1 (a proc on Chaos Bolt or Shadowburn).
- **Evidence:** MEASURED.
- **Fix:** "... if you picked it".
- **Note:** the 5 Oct removal "Dimensional Rift not castable" (`KeybindRoles_Warlock.lua:205`) is **correct**.
  Icy Veins Destruction §5.1 still says Rift "generates fragments on cast", which is stale guide text.

**C11. `Locales/enUS.lua:1510` (`PLAYCARD_266_AOE`): Implosion is one half of a choice.**
- **What MH says:** "{Implosion} when 6 or more Wild Imps".
- **What is true in 12.1:** Implosion 196277 shares choice node n101893 with Power Siphon 264130.
- **Evidence:** MEASURED.
- **Fix:** name the Power Siphon alternative.

**C12. Same name, two spells: the "cast at your target" variants.**
- **The three pairs** (the second id is the "This spell is cast at your target" variant, and neither id overrides
  the other):
  - Blizzard 190356 / 1248829 (n108864, Frost)
  - Flamestrike 2120 / 1254851 (n109409, Fire)
  - Rain of Fire 5740 / 1214467 (n72069, Destruction)
- **Problem 1, the cards:** the play cards use the ground id (`enUS.lua:1273, 1283, 1520`). For a player who
  picked the variant, IsPlayerSpell on that id is false, so the card greys out a spell they have.
- **Problem 2, the macros:** the `[@cursor]` macros (`TeamMacrosData.lua:366-373, 386-393, 721-728`) aim a
  target-cast spell at the cursor.
- **Evidence:** MEASURED (DB2). The client behaviour is DERIVED.
- **Fix:** give the card both ids, and add "not needed with the at-target version" to the macros.

**C13. `Modules/TeamMacrosData.lua:346-355, 374-383, 394-403`: "Ice Block Cancel" is offered to all three Mage specs.**
- **What is true in 12.1:** Ice Cold 414659 is a class node (n62085, single, spent 20). Through an aura 332 effect
  it replaces Ice Block with 414658 Ice Cold, which grants no immunity and does not stop you from moving or casting.
  With Ice Cold there is nothing to cancel, and `/cancelaura Ice Block` does nothing.
- **Evidence:** MEASURED (DB2). The macro behaviour is DERIVED.
- **Fix:** add the note "not needed with Ice Cold", or check `GetOverrideSpell(45438) == 414658`.

**C14. `Modules/HealerSolo.lua:46-47`: Holy lists both Holy Fire 14914 and Shadow Word: Pain 589.**
- **What is true in 12.1:** the Holy Fire talent (node n108730) has `OverridesSpellID = 589`. With Holy Fire, the
  Shadow Word: Pain step names a button that now casts Holy Fire.
- **Evidence:** MEASURED (the override). That `C_SpellBook.IsSpellKnown(589)` still answers true is DERIVED and
  needs a client test.
- **Fix:** merge the two into one step, `ids = { 14914, 589 }`.

**C15. `Modules/InterruptMacrosData.lua:33`: the Warlock interrupt macro is `Command Demon` for all three specs.**
- **When it interrupts:** only with a Felhunter out (Spell Lock) or a Felguard out (Axe Toss 89766, skill line 761).
  With any other demon out it casts that demon's own ability. This follows from C5.
- **Evidence:** MEASURED (skill lines) + DERIVED.
- **Fix:** add the note "an interrupt only with Felhunter (Affliction, Destruction) or Felguard (Demonology)".

**C16. `Modules/DpsToolkit.lua:57`: Void Torrent 263165 is only in the Voidweaver hero tree.**
- **What is true in 12.1:** it is granted only inside the Voidweaver hero tree for spec 258.
- **Where it shows anyway:** a Discipline or Holy Priest's Shadow DPS preview is unfiltered, so it lists Void
  Torrent with no hero note.
- **Severity:** low.
- **Evidence:** MEASURED.
- **Fix:** add a hero hint in the preview.

**C17. `Modules/HealerCooldowns.lua:299`: Warlock Singe Magic 89808 is the Imp's own ability.**
- **What is true in 12.1:** 89808 sits on skill line 188 (Pet - Imp). The Grimoire of Sacrifice version is 132411.
- **Where it shows:** on your own spec IsPlayerSpell filters it, which presumably means it never shows (DERIVED).
  Another spec's play card shows the unfiltered class list (`PlayCardWindow.lua:498`).
- **Severity:** low.
- **Fix:** use `ids { 89808, 132411 }` plus the note "Imp only".

### STALE (comments, unused data, labels)

**S1. `Modules/DpsToolkit.lua:65`: the comment says "Dark Harvest / Malevolence: ids not verified".**
- MEASURED now:
  - Dark Harvest is 1257052 (Affliction node n109860, 60 s).
  - Malevolence is 442726 (Hellcaller, learned through 430014, 60 s).
- `PLAYCARD_265_S3` already uses 1257052.
- **Fix:** add both rows. IsPlayerSpell filters the hero half.

**S2. `Modules/KeybindRoles_Warlock.lua:69-72`: the header contradicts the code.**
- The header says Malevolence's `specs` "stay { 265 }". The code at `:145` has `{ 265, 267 }`, which is correct:
  DB2 shows Hellcaller for both specs.

**S3. `Modules/KeybindRoles_Warlock.lua:21, 108-110`: "Command Demon id unchecked".**
- MEASURED: 119898 is Command Demon, on SkillLine 849 (baseline).

**S4. `Modules/KeybindRoles_Mage.lua`: three comments disagree with DB2.**
- `:46`, `:112`, `:121` call Remove Curse and Spellsteal "baseline". Both are class-tree talents: n62116 and
  n62084, each spent 8.
- `:172` says Meteor is "ook Frost". DB2 has it as Fire-only (n101021).

**S5. `Modules/KeybindRoles_Priest.lua`: the header still names removed cooldowns.**
- `:46-51` still lists Rapture, Spirit Shell, Holy Word: Salvation and Symbol of Hope as cooldown slots.
- `:81` calls Angelic Feather "baseline". It is a class talent (n82703).
- MEASURED as not granted in 12.1 and absent from all live MH data:
  - Rapture 47536, Spirit Shell 109964, Symbol of Hope 64901, Holy Word: Salvation 265202
  - Power Word: Life 373481, Mindbender 200174/123040, Dark Ascension 391109
  - Renew 139, Heal 2060, Void Shift 108968

**S6. `Modules/TeamMacrosData.lua:543-550`: the Holy macro called "Mouseover Life" casts Leap of Faith.**
- Power Word: Life (373481) is not granted. Players see the name.
- **Fix:** rename it to "Mouseover Leap".

**S7. `Modules/KeybindingData.lua:184`: the frost_mage hand map puts Alter Time 108978 on Shift+Z.**
- 108978 is not granted; the live Alter Time is 342245.
- The map is no longer used for the Layout (`KeybindLayoutSlug.lua:53-58`).

**S8. `Modules/DpsToolkit.lua:90-120`: DPS_DEFENSIVES is not rendered any more (`RoleAcademy.lua:881-891`).**
- All of its cloth ids are live.

---

## Already fixed today: verify only

| Question | Answer | |
|---|---|---|
| Is Summon Felguard 30146 right? | Yes. It is a live **talent** node, n109257 (Demonology spec tree, single node, visible to 266 only), not baseline. The `IsKnown` gate is correct; a Demonology Warlock without the talent falls back to the Imp. | MEASURED |
| Which demon for Affliction / Destruction, and is the Imp default right? | No, see C5. Icy Veins (31 Aug 2026): Sayaad for single-target damage, Felhunter when an interrupt or purge is needed, Imp only for a dispel or for range swaps. | DERIVED + MEASURED |
| Is Grimoire of Sacrifice 108503 / 196099 still live? | Yes. 108503 shares choice node n72037 (Affliction) / n71971 (Destruction) with Summoner's Embrace 453105, a passive +damage talent. Its SpellEffect 64 triggers **196099**, so the buff id is correct. Gated by `IsKnown`. ⚠️ A sacrificed Imp gives Singe Magic, not Spell Lock, which ties into C5. | MEASURED |
| Is DpsToolkit's Living Bomb (44457) dead? | Yes, see C4. | MEASURED |
| Are Rapture, Spirit Shell and Symbol of Hope gone? | Yes: none is granted in 12.1, and none is in live MH data (grep over `*.lua`; only history comments remain). | MEASURED |

---

## Checked and found correct (so silence means "looked")

All cooldown seconds below were matched against SpellCooldowns, or for charge spells against SpellCategory:
Pain Suppression 180, Ray of Frost 60, Touch of the Magi 45, Ice Block 240.

| File | Checked | OK | Findings |
|---|---|---|---|
| MissingBuffData.lua + MissingBuff.lua (cloth parts) | 9 values | 7: 1459, 21562, 232698 (SpecializationSpells 258), 108503, 196099, demoSpec 266, 30146 | C1, C5 |
| HealerCooldowns.lua (256/257 rows + MAGE/PRIEST/WARLOCK dispels) | 22 rows, 11 cooldowns | 20 rows, 11/11 cooldowns | C6 (pair), C17 |
| DpsToolkit.lua DPS_COOLDOWNS (62/63/64/258/265/266/267) | 17 rows | 16. All cooldowns match. Ice Nova (choice with Freezing Cold) and Channel Demonfire (choice with a passive) are hidden by the IsPlayerSpell filter on your own spec | C4, C16, S1 |
| DpsToolkit.lua DPS_DEFENSIVES (cloth) | 14 | 14 ids live | S8 |
| GroupPlan.lua (cloth specs) | 31 rows | 31. Ownership-filtered; the Barrier note is right | none |
| HealerSolo.lua (256/257) | 10 | 9 | C14 |
| PlayCards (`enUS` `PLAYCARD_62…267`) | 89 `{SPELL}` references, 9 cards | All ids exist. 9 are proc/override ids that are not granted directly: 186263, 1253593 (Disc apex Master the Darkness), 199786 (Icicles), 153595 (Comet Storm talent 1247777), 1295924 (Arcane apex), 450215/450983 (Entropic Rift), 391403, 1242173 (Voidform). Each has a live talent pointing at it: MEASURED via the description search. The Drain Soul / Shadow Bolt choice is handled correctly in 265_S5 | C9–C12 |
| TeamMacrosData.lua (MAGE/PRIEST/WARLOCK) | 19 macros | 7: Focus Polymorph, Mouseover Shield, Tentacle Slam, 3× Void Torrent macros (their Voidweaver texts are right), Focus Fear | C2, C3, C7, C8, C9, C12, C13, S6 |
| InterruptMacrosData.lua | 9 spec slots | 6: Mage Counterspell ×3 (baseline), Priest false/false/Silence (Silence = SpecializationSpells 258 only) | C15 |
| DispelHelper OFFENSIVE_PURGES + PlayCardWindow ENEMY_DISPELS | 4 | 4: Dispel Magic 528 and Spellsteal 30449 are class talents, and both paths check IsPlayerSpell | none |
| ConsumableReadyCheck.lua RAID_BUFF_DEFS + Healthstone rule | 3 | 3 | none |
| GroupRezLust.lua (Soulstone 20707, Time Warp 80353) | 2 | 2 | none |
| Delves.lua mage Teleport/Portal Silvermoon (1259190/1259194) | 2 | 2 (SkillLine 904) | none |
| KeybindRoles_Mage.lua | 50 entries | 50 live (name-matched, own spellbook only) | S4 |
| KeybindRoles_Priest.lua | 50 entries | 50 live. Shadow Mend 186263 is MEASURED as Flash Heal's override through 1252217 (aura 332) | S5 |
| KeybindRoles_Warlock.lua | 51 entries + 6 "REMOVED" lines | 51 live. All 6 removals MEASURED correct: Nether Tempest, Living Bomb, Call Felhunter, Doom 460555 and Malefic Rapture are not granted; Cauterize and Dimensional Rift are passive | S2, S3 |
| KeybindingData.lua frost_mage (unused) | 17 ids | 16 live | S7 |
| SurvivalPlan.lua (via the KeybindRoles tags) | cloth survival tags | All ids live. Spell Lock and Axe Toss override ids 119910 and 119914 exist | none |
| Locale text, enUS (GROUP_NOTE_*, SURVIVAL_*, MBUFF_*, REZLUST, PURGE) | 25 keys | 25. Spell names exist, e.g. Twins of the Sun Priestess 373466 is a live class passive. The numbers inside the texts were not checked | none |
| MythicPlusData.lua MPLUS_KICKS, TankToolkit.lua, KeyBlock.lua | — | No cloth-class content (dungeon-keyed, tank-only, classifier-driven) | none |

## Not checked (so it is not read as "fine")

- Numbers inside texts: percentages and durations such as "10% for 10 sec" or "30 sec after".
- Rotation claims that only come from guides.
- Locale packs other than enUS.
- ConsumablesWowheadData, VaultAdvisorData, StatCoach and SimcExport (no spell advice).
- Whether the Shadowform aura 232698 stays up during Voidform. If it drops, MissingBuff would show "USE FORM" in
  combat. Client test: `/mh mbuff` during Voidform.
- What `IsPlayerSpell` and `IsSpellKnown` return for an overridden base spell (C14) and for pet spells (C17).
