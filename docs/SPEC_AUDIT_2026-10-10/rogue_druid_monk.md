# Spec audit 10 Oct 2026 — Rogue, Druid, Monk (live 12.1.0.69933)

Scope: Rogue 259/260/261, Druid 102/103/104/105, Monk 268/269/270. Read only; no code or locale file changed.

Labels per claim: **GEMETEN** = seen in a named, dated source (mostly wago.tools DB2, build 12.1.0.69933, read 10 Oct 2026).
**AFGELEID** = reasoned from that data or from a guide; needs the client to settle.
Severity (from the task): **WRONG** = tells the player something false / a button that cannot work; **RISK** = one half of a
talent choice node shown as if everyone has it; **STALE** = comment or unrendered data only.

## Sources

- wago.tools DB2, build **12.1.0.69933**, tables: SpellName, SkillLineAbility, SpecializationSpells, SkillLineXTraitTree,
  TraitTree, TraitNode, TraitNodeEntry, TraitNodeXTraitNodeEntry, TraitDefinition, TraitNodeGroupXTraitNode,
  TraitNodeGroupXTraitCond, TraitNodeXTraitCond, TraitCond, SpecSetMember, SpellCooldowns, SpellCategories, SpellCategory,
  SpellMisc, SpellEffect, SpellPower, ChrSpecialization, **AssistedCombat + AssistedCombatStep + AssistedCombatRule**
  (Blizzard's own Single-Button Assistant, "SBA" below). Read 10 Oct 2026.
- Live talent trees per class (GEMETEN, SkillLineXTraitTree): Rogue 921 -> tree **852**, Druid 798 -> **793**,
  Monk 829 -> **1000**. Monk tree **781** has no SkillLineXTraitTree row: it is the orphaned old tree. A spell that only
  sits in tree 781 is not in the 12.1 game.
- Icy Veins 12.1 rotation pages: Assassination, Outlaw, Subtlety, Feral, Balance, Brewmaster, Restoration Druid
  ("Last Updated Aug 10, 2026"), Windwalker (Aug 11), Mistweaver (Aug 12). ⚠️ All dated before 18 Aug; they do carry the
  Season 2 tier-set text. For the poison question the SBA tables (build 69933) are the post-S2 authority.
- Method Assassination 12.1 (12 Aug 2026): no poison text. Wowhead live tooltip Starfall 191034 (read 10 Oct).

⚠️ **Method warning, measured during this audit.** "No SkillLineAbility / SpecializationSpells / TraitDefinition row" does
NOT prove a spell is gone: Brewmaster Blackout Kick **205523** and Balance **Solar Eclipse 1233346** have no such row, yet
both are steps in Blizzard's 12.1 SBA (AssistedCombatStep 4627 for spec 268; list 90 for spec 102). So every WRONG below
cites positive evidence for the replacement id, not only absence of the old one. 205523 was a draft finding and is now in
the "checked and correct" list.

## Verify-only: the poison fix of today

| Question | Verdict | Evidence |
|---|---|---|
| Assassination prefers Deadly Poison 2823 (`MissingBuffData.lua:108`) | **CORRECT** | GEMETEN: Deadly Poison = TraitNode 90783 (tree 852), visible only for spec set [259]. SBA list for 259 (AssistedCombat 4) starts Deadly, Deadly, Amplifying, Amplifying. Icy Veins Assa (10 Aug): "Lethal ... always Deadly Poison and Amplifying Poison". |
| Outlaw/Subtlety get Instant Poison 315584 | **CORRECT (PvE)** | GEMETEN: Deadly/Amplifying nodes are visible for [259] only, so the engine falls back to Instant (SkillLineAbility Rogue, baseline). SBA 260/261: Instant when "PvP Rules Enabled (134735)" is absent; Wound only with that aura. Icy Veins Outlaw: "Lethal ... always Instant"; Subtlety opener "Instant Poison and Atrophic Poison". |
| Non-lethal choice | **WRONG** — see W1 | MH always offers Crippling. |
| Assassination two lethals | **GAP** (not a false statement) — see O1 | |

## Findings

### WRONG

**W1 — Non-lethal poison: Crippling for every rogue, even with Atrophic/Numbing talented.**
`MissingBuffData.lua:112-116` (order Crippling, Numbing, Atrophic) + `MissingBuff.lua:305-321` (first known wins).
- MH says: "cast Crippling Poison" whenever no non-lethal is up, on all three specs.
- 12.1: Numbing/Atrophic are one choice node (90763, class tree) — GEMETEN. Blizzard's SBA for 259, 260 and 261 tries
  **Atrophic, then Numbing, then Crippling**; the Crippling step only fires when neither Numbing nor Atrophic is up
  (AssistedCombatRule on steps 12755 / 12997 / 13033) — GEMETEN. Icy Veins: Atrophic for raids (Assa, Outlaw), Sub opens
  with Atrophic — GEMETEN (guides dated 10 Aug).
- Same bug type as "every Rogue Instant Poison": one choice for all, against the player's own talent pick.
- Fix: order the non-lethal list Atrophic 381637, Numbing 5761, Crippling 3408 (the talent you took wins; Crippling is the fallback).

**W2 — Mistweaver core heals: Renewing Mist has the HoT-aura id 119611.** `HealerCooldowns.lua:203`
- MH lists `{ id = 119611 }`; `RoleAcademy.lua:564-576` (OwnedOnly) drops every row where `IsPlayerSpell(id)` is false
  on your own spec.
- 12.1: the Mistweaver button is **115151** (SpecializationSpells spec 270) — GEMETEN; Icy Veins MW links 115151 — GEMETEN.
  119611 only has a SkillLineAbility row with AcquireMethod 0 (the same marker as removed/helper spells such as Cenarion
  Ward 102352) — GEMETEN. That `IsPlayerSpell(119611)` is false, so MW's own "core heals" list loses its first heal —
  AFGELEID; settle with the /run below.
- Fix: `id = 115151`.

**W3 — Mistweaver play card uses the same aura id.** `Locales/enUS.lua:1542, 1543, 1544, 1546`
(PLAYCARD_270_IDEA / EASY / S1 / S3), plus the same `{SPELL:119611}` in `nlNL.lua` and `Translations2026.lua`.
- Effect: the hyperlink/tooltip is the aura, and below max level the step greys as "not yet learned" (PlayCardWindow
  `Greying`) — AFGELEID. The key behind the name still resolves through LiveKeys' name fallback.
- Fix: `{SPELL:115151}` in all packs (enUS 4 lines + the copies; 119611+315508 together: enUS 5, nlNL 5, Translations2026 25 — GEMETEN by grep).

**W4 — Outlaw play card: Roll the Bones is the old id 315508.** `Locales/enUS.lua:1459` (PLAYCARD_260_S2) + copies.
- 12.1: Outlaw's Roll the Bones is **1214909** (SpecializationSpells 260, and the step in Blizzard's SBA list 327) —
  GEMETEN. 315508 is in no learn table and in no SBA list — GEMETEN; the card's text already describes the new 4-stage
  version, so the tooltip of the old spell can contradict it — AFGELEID.
- Fix: `{SPELL:1214909}` in all packs.

**W5 — Mistweaver personal defensive: Fortifying Brew 243435.** `HealerCooldowns.lua:247`
- 12.1: Fortifying Brew is a Monk class talent, node 101173 in tree 1000, TraitDefinition 388917 with VisibleSpellID
  **115203** (6 min, SpellCooldowns 360000) — GEMETEN; Icy Veins BM links 388917 — GEMETEN. 243435 has no learn path and a
  7-min cooldown row (420000) — GEMETEN. AFGELEID (lower confidence than W2, see the method warning): `IsPlayerSpell(243435)`
  is false, so OwnedOnly removes MW's only defensive and the heading disappears.
- Fix: `{ id = 115203, cd = 360 }` after the /run confirms.

**W6 — Balance macro "Cursor Starfall" describes a ground spell that is not one.** `TeamMacrosData.lua:97-104`
- MH says "Cast Starfall at your cursor" with `/cast [@cursor] Starfall`.
- 12.1: every SpellEffect of Starfall 191034 targets TARGET_UNIT_CASTER (area trigger on you), none a destination —
  GEMETEN (SpellEffect, filter SpellID=191034). Wowhead tooltip: "upon enemies within 40 yds" — GEMETEN. The `@cursor`
  does nothing; the sentence is false. The macro itself still casts.
- Fix: drop the macro, or make it a plain `/cast Starfall` without the "at your cursor" claim.

**Check in the client before fixing W2, W4, W5** (one line, under 255 chars):
`/run for _,i in ipairs({119611,115151,243435,115203,315508,1214909,205523,100784})do print(i,IsPlayerSpell(i),C_SpellBook.IsSpellKnown(i))end`
Expected (AFGELEID): on a Mistweaver 115151/115203 true, 119611/243435 false; on an Outlaw 1214909 true, 315508 false;
on a Brewmaster 205523 true.

### RISK (one half of a choice node shown as if everyone has it)

| # | file:line | What MH says | 12.1 (GEMETEN, tree + node) | Fix in one line |
|---|---|---|---|---|
| R1 | `enUS.lua:1549` PLAYCARD_270_AOE | "Revival, or Yu'lon in raids and Chi-Ji in dungeons. Not all at the same time." | Revival/Restoral = node 101131; Yu'lon/Chi-Ji = node 101129 (tree 1000). A MW has exactly one celestial. | "Revival (or Restoral), and your celestial: Yu'lon or Chi-Ji, whichever you picked." |
| R2 | `enUS.lua:1535` PLAYCARD_269_S2 | "Whirling Dragon Punch when it lights up, Strike of the Windlord on cooldown." | WDP/SotW = one choice node 101207. Icy Veins WW (11 Aug) priority uses WDP only. | "WDP or SotW (the one you picked)". |
| R3 | `enUS.lua:1335` PLAYCARD_103_S1 | "Convoke goes in the same window." | Feral node 82114 = Incarnation: Avatar of Ashamane / Convoke. Icy Veins Feral (10 Aug) recommends Berserk + Convoke, so the card follows the default, but an Incarnation player has no Convoke. | add "(if you took it instead of Incarnation)". |
| R4 | `TeamMacrosData.lua:597-604, 615-622, 633-640` | "Mouseover Tricks" offered to all three rogue specs, unfiltered (`InterruptMacros.lua:129-143`). | Tricks of the Trade / Blackjack = choice node 90686 (class tree). MH's own `GroupPlan.lua:26` already calls it a talent choice. | say "only if you took Tricks of the Trade (not Blackjack)", or hide when not known. |
| R5 | `TeamMacrosData.lua:125-131` | Guardian "Cursor Vortex". | Ursol's Vortex / Mass Entanglement = choice node 82207. | same note / hide when not known. |
| R6 | `TeamMacrosData.lua:434-441` | MW "Mouseover Jade Statue" (the macro is `@cursor`, the name says mouseover). | Summon Jade Serpent Statue / Jade Infusion = choice node 101164 (visible [270]). | note + rename to "Cursor Jade Statue". |
| R7 | `TeamMacrosData.lua:445-451` | WW "Cursor Ring of Peace". | Ring of Peace / Song of Chi-Ji = choice node 101136 (class tree). | same note / hide when not known. |
| R8 | `HealerCooldowns.lua:123-124`, `:141-142` | Tree of Life + Convoke; Chi-Ji + Yu'lon, both listed (Yu'lon/Chi-Ji without a "choice" comment). | Resto node 82064 = Tree of Life / Convoke; MW node 101129 = Yu'lon / Chi-Ji. On your own spec OwnedOnly hides the unpicked half (fine); the **preview** of another spec shows both as yours. | comment "choice node" on both; optional "A or B" row in previews. |
| R9 | `DpsToolkit.lua:44, 45, 55` | Balance: Incarnation + Convoke; Feral: Incarnation + Convoke; WW: SotW. | Balance node 88206 = Incarnation: Chosen of Elune / Convoke; Feral 82114 as R3; WW SotW is the half of 101207 that Icy Veins does not take. Own spec filtered (fine), preview shows both. | comment the pairs; low priority. |
| R10 | `enUS.lua:1332` PLAYCARD_102_HERO1 | Elune's Chosen line: "Press Fury of Elune". | Fury of Elune / New Moon = choice node 88224. Low: it is a hero-tree line. | "Fury of Elune (if you took it over New Moon)". |
| R11 | `enUS.lua:1665-1666` GROUP_NOTE_YU_LON / CHI_JI | "not at the same moment as Revival" | A Restoral player (node 101131) has no Revival. The rows themselves are ownership-filtered. | "... as Revival or Restoral". |
| R12 | `TeamMacrosData.lua:105-112, 605-612` | Balance "Mouseover Decurse" (Remove Corruption); Assassination "Focus Blind". | Not choice nodes, but talents: Remove Corruption node 82241 (talent for 102/103/104), Blind node 90684 (granted only to Outlaw). Low. | "talent; does nothing without it". |

### STALE (comment or unrendered data)

| # | file:line | Says | 12.1 (GEMETEN) | Fix |
|---|---|---|---|---|
| S1 | `DpsToolkit.lua:107` (+ comment `:96`) | WW defensive Dampen Harm 122278 | Dampen Harm exists only in the orphaned Monk tree 781; tree 1000 has no Dampen Harm. Not rendered (`RoleAcademy.lua:891-893`). | drop the row. |
| S2 | `DpsToolkit.lua:60` | Goremaw's Bite "(reworked in 12.1; id unconfirmed)" | 426591 exists, Sub node 90724 (tree 852), cd 45000; also in Sub's SBA list. | "GEMETEN 12.1.0.69933". |
| S3 | `TankToolkit.lua:121` | Survival Instincts "(2 charges baseline)" | SpellCategory 1469: MaxCharges 1, recharge 180 s (base). A second charge from a talent was not measured. | "1 charge base". |
| S4 | `KeybindRoles_Monk.lua:55-57, 199` | Fortifying Brew "baseline"; variants 120954 / 201318 / 243435 | Class talent (node 101173, def 388917 -> 115203). None of the three variants has a learn path. Entry itself uses 115203 (fine). | fix the comment. |
| S5 | `KeybindRoles_Rogue.lua:39-41, 65` | "Baseline: ... Cloak, Evasion, Blind, Gouge, Tricks"; Shiv "baseline alle 3 specs" | Gouge = choice node 90741 (with Airborne Irritant); Tricks = choice 90686 (with Blackjack); Blind node 90684 (granted only Outlaw); Cloak node 90697 (granted only Sub); Evasion node 90762 (talent); Shiv node 90740 (granted only Assa). Spellbook matching makes this harmless. | fix the comment. |
| S6 | `KeybindRoles_Druid.lua:60-61, 238-250` | Wild Charge, Cyclone, Soothe, Ursol's Vortex under "baseline" | Wild Charge / Tiger Dash = choice 82198; Soothe / Cyclone = choice 82229; Ursol's / Mass Entanglement = choice 82207. Harmless (spellbook matching). | fix the comment. |
| S7 | `KeybindRoles_Druid.lua:182, 194, 259`; `KeybindRoles_Monk.lua:98` | "measured on Guardian only" / "id Wowhead, not client-measured" | Now GEMETEN in DB2: Heart of the Wild 1261867 = one class node 82231 for all specs; Thrash 77758 and Bear Form 5487 = Druid SkillLineAbility baseline; Keg Smash 121253 = BM node 101088. | update the notes. |

### OPEN (could not settle — not counted as findings)

- **O1 Assassination two lethals.** Dragon-Tempered Blades 381801 (Assa node 94553) exists; Blizzard's SBA applies Deadly
  **and** Amplifying when it is known (rules on steps 12657/12658), Icy Veins says the same. MH only warns when no lethal
  is up, so an Assassination rogue with only Deadly gets no nudge. A gap, not a false statement — GEMETEN.
- **O2 Mana Tea id** (`enUS.lua:1550`, {SPELL:115294}). Talent 115869 (passive, MW node 101132); aura 115867 triggers 115294;
  Icy Veins links 197908 (cd 90 s, no learn path either). Which id is the 12.1 button is not settled. The text ("drink it
  before 20 stacks") agrees with Icy Veins' "Mana Tea if at 20 stacks".
- **O3 Mark for Death 1293340** (`KeybindRoles_Rogue.lua:105`): no learn path found and not in the Sub SBA list. Spellbook
  matching hides it if dead. Needs the client.
- **O4 Lifetreading** (Resto node 103874, overrides Efflorescence 145205): Icy Veins says Efflorescence then follows the
  Lifebloom target; whether "Cursor Efflorescence" (`TeamMacrosData.lua:151-158`) still places anything is not settled.
- **O5 GROUP_NOTE_STAMPEDING_ROAR** "it turns you into Bear Form": not verified for 12.1 (Wowhead redirected to MoP Classic).
- **O6 Shadowstep 36554 / Transcendence: Transfer 119996**: learn path not visible in these tables (same blind spot as
  205523); both are spellbook-matched only, so no risk.

## Checked and found correct (so silence is not "not looked")

| File | Checked | Correct | Notes |
|---|---|---|---|
| `MissingBuffData.lua` | DRUID 5 defs + 7 poison ids | 12 ids correct, learn paths match the comments | Moonkin 24858 = node 82208 granted to 102; Cat 768 / Bear 5487 / MotW 1126 = SkillLineAbility; Symbiotic 474750 = class node 100173. Order of the non-lethal list = W1. No Rogue/Druid/Monk pet or stance rows (correct). |
| `MissingBuff.lua` | poison logic, lethal + non-lethal | lethal correct (verify table above) | non-lethal = W1. |
| `HealerCooldowns.lua` | 105: 5 CDs, 5 core heals, 1 def, 1 dispel; 270: 6 CDs, 4 core heals, 1 def, 1 dispel; NONHEALER DRUID 1, MONK 1 (26 rows) | 24 | W2, W5; preview pairs R8. Every cd matches SpellCooldowns/SpellCategory (Tranquility 180, Tree 180, Convoke 120, Ironbark 90, Innervate 180, Revival/Restoral 180, Chi-Ji/Yu'lon 120, Cocoon 120 charge, Conduit 90, Barkskin 60). Nature's Cure 88423 and Detox 115450 = SpecializationSpells; Remove Corruption 2782 = node for 102/103/104; Detox 218164 = nodes for 268/269. |
| `DpsToolkit.lua` | DPS_COOLDOWNS 25 rows (102,103,269,259,260,261); DPS_DEFENSIVES 11 rows | 25 + 10 | All cds match DB2: Shadow Dance 1 charge/20 s, Zenith 2 charges/90 s, CA 180, FoE 60, FoN 60, TF 30, Feral Frenzy 45, Deathmark 120, Kingsbane 60, Shiv 30, AR 180, KS 180, Blade Flurry 30, Blade Rush 60, Shadow Blades 90, Secret Technique 25, Goremaw 45, FoF 24, SotW 35, Xuen 120 (Conduit hero node 101243 only — comment says so). S1, S2. |
| `TankToolkit.lua` | 104: 2 mitigation, 2 CDs, taunt/kick/stun + 2 AoE; 268: 3 mitigation, 1 CD, taunt/kick/stun + 2 AoE (18) | 18 | Celestial Brew/Infusion share charge category 2293 (1 × 90 s) as the comment says. Mighty Bash = choice with Incapacitating Roar (82237) but the stun row is ownership-filtered. S3. |
| `SurvivalPlan.lua` | logic only (no data) | — | Ownership + passive filter confirmed in code (`LiveName`). |
| `KeybindRoles_Rogue.lua` | 53 entries | 51 ids with a 12.1 learn path or SBA step | O3 Mark for Death, O6 Shadowstep. S5. Roll the Bones entry already uses 1214909. |
| `KeybindRoles_Druid.lua` | 75 entries | all ids live (Solar Eclipse 1233346 confirmed via Balance SBA list; Lunar Eclipse 1233272 only as its transform, not measured separately) | S6, S7. Removed spells confirmed gone: Renewal and Rage of the Sleeper (no spell by that name in any learn table), Flourish 197721 and Grove Guardians 1226140 (PASSIVE nodes), Cenarion Ward (only SkillLineAbility AcquireMethod 0). |
| `KeybindRoles_Monk.lua` | 55 entries | 53 live in tree 1000, SkillLineAbility, SpecializationSpells or an SBA step; Mana Tea (O2) and Transcendence: Transfer (O6) open. Blackout Kick survivalId[268]=205523 **correct** (SBA 268 step) | S4, S7. Removed spells confirmed gone from tree 1000: Weapons of Order, Storm Earth and Fire, Diffuse Magic active 122783 (now passive 1243287), Zen Meditation, Dampen Harm (S1). |
| `InterruptMacrosData.lua` | 10 (Rogue 3, Druid 4, Monk 3) | 10 | Solar Beam node visible [102] only; Skull Bash node visible [103,104] only; so Resto has no kick (false is right). Spear Hand Strike nodes in tree 1000 for [268] and [269] only, so MW false is right. Spec order matches ChrSpecialization OrderIndex (Monk: BM 0, MW 1, WW 2). |
| `DispelHelper.lua` OFFENSIVE_PURGES | Rogue/Druid/Monk | 0 rows (deliberate) | Nothing false. |
| `PlayCardWindow.lua` ENEMY_DISPELS | DRUID Soothe 2908 | ok | Soothe/Cyclone choice node 82229, but filtered by ownership on your own spec. |
| `MythicPlusData.lua` / `Locales/MythicPlus.lua`, `DungeonTips.lua`, `RaidTips.lua`, `DelveTips.lua`, `RitualTips.lua`, `Codex.lua` | grep for every Rogue/Druid/Monk spell name used above | 0 class spell mentions | Positive control: the same pattern found the enUS play-card lines. |
| `HealerSolo.lua` | 105: 5 steps, 270: 5 steps | 10 | Starsurge 197626 / Starfire 197628 = nodes visible for 103/104/105. |
| `ConsumableReadyCheck.lua` RAID_BUFF_DEFS | DRUID Mark of the Wild 1126 | 1 | |
| `GroupPlan.lua` | 102, 103, 104 (4 rows each), 105 (6), 268 (2), 269 (2), 270 (8) = 30 rows | 30 ids live; rows are ownership-filtered | Rogue "no tab" reason (Tricks is a choice) GEMETEN. Rebirth note "(costs Rage)" GEMETEN: SpellPower 20484 = 30 Rage with RequiredAura Bear Form 5487. R11, O5. |
| `GroupRezLust.lua` | DRUID Rebirth 20484 | 1 | |
| `TeamMacrosData.lua` | Druid 7, Monk 5, Rogue 5 = 17 macros | 9 | W6, R4-R7, R12. Ground targeting GEMETEN (ImplicitTarget 87 = destination): Ursol's Vortex, both statues, Ring of Peace, Efflorescence, Grappling Hook. |
| `PlayCards.lua` + `enUS.lua` PLAYCARD_* | 10 cards, 95 lines, every {SPELL:id} | all ids except 119611 and 315508 | W3, W4, R1-R3, R10. 205523 (BM Blackout Kick) is correct: Blizzard's BM SBA uses it. Zenith 2 charges, Renewing Mist 2 charges, Purifying Brew 2 charges, Celestial Brew 90 s all GEMETEN. Brewmaster "Tiger Palm" advice matches Icy Veins (Blackout Combo build; Press the Advantage would replace Tiger Palm, node 101193). |
| `RoleAcademy.lua`, `KeyBlock.lua`, `LiveKeys.lua` | grep for class tokens and spec ids | 0 class-specific rows | They render the tables above (OwnedOnly / spellbook). |
| `TankPullSummary.lua` | [104] Ironfur, [268] Stagger | 2 | |

Not checked (out of the two bug types): `ConsumablesWowheadData.lua` (consumables per spec), `VaultAdvisorData.lua`,
`GearExport.lua`, `SimcExport.lua`, Barkskin 45 s for Guardian (`TankToolkit.lua:120`, not re-measured; base is 60 s),
hero-talent sentences on the play cards beyond the ids, and which half of R4-R7 the 12.1 guides prefer.
