# Retail macros, part B (Hunter, Mage, Monk, Paladin): notes

Date: 10 Nov 2026. Data file: `retail_macros_B.lua` (60 rows, 5 per spec, `luac -p` clean). Generator and checks:
`mac_b_rows.py` (row data) + `mac_b_check.py` (tree check, names, lengths, writes the Lua). All in this scratchpad.

Labels: **GEMETEN** = seen in a named, dated source or measured in DB2. **AFGELEID** = my reasoning.

**Nobody has tested these macros in game: not me, and not any source I read.** The guides are editor pages. They are
not tests that I ran.

## 1. Spec list (GEMETEN)

`run gamedata db2 ChrSpecialization ClassID=2,3,8,10 --game retail`, build **12.1.5.70783**:

| Class | OrderIndex 0 | 1 | 2 | (4 = "Initial", the level-1-10 no-spec entry) |
|---|---|---|---|---|
| HUNTER (3) | 253 Beast Mastery | 254 Marksmanship | 255 Survival | 1448 |
| MAGE (8) | 62 Arcane | 63 Fire | 64 Frost | 1449 |
| MONK (10) | 268 Brewmaster | **270 Mistweaver** | **269 Windwalker** | 1450 |
| PALADIN (2) | 65 Holy | 66 Protection | 70 Retribution | 1451 |

Spec index = OrderIndex + 1. The Monk order is not the ID order: index 2 = Mistweaver, 3 = Windwalker. That index
rule is AFGELEID from the table, but it matches what MH already uses: `TeamMacrosData.lua` MONK[2] holds the Vivify and
Jade Serpent Statue macros (Mistweaver spells), and the `InterruptMacrosData.lua` comment says "Brewmaster, Mistweaver,
Windwalker (client spec order)". I did not ask the client (`GetSpecializationInfo`) myself.

## 2. Sources (all read 10 Nov 2026, through Exa or WebFetch)

| Family | Pages | Page date (seen on the page) | Notes |
|---|---|---|---|
| **WH** Wowhead "<Spec> UI & Macros - Midnight" | 12 class guide pages | "Updated: 2026/10/13" seen on MM, SV, Frost, BrM, WW, Holy, Prot, Ret. **Not seen** on BM, Arcane, Fire, MW (I only got search snippets) | Same authors as IV on 4 pages: MM (Azortharion), BrM (Sinzhu), WW (Babylonius), Ret (Bolas). The texts are not copies, so I counted them separately. AFGELEID: drop 1 from those counts if you treat one author as one voice. The MM macro section was cut off in my read (UI strings came first). |
| **IV** Icy Veins "<Spec> Macros and Addons 12.1.5" | 12 pages | "Last Updated: Oct 12, 2026" on all 12 (changelog "Reviewed for Patch 12.1.5") | The hunter pages share one "Generic Macros for Hunters" block. BM changelog, 04 Sep 2026: "Removed the Barbed Shot Mouseover macro". |
| **ME** Method "Interface and Macros" | 12 pages | 13 to 16 Oct 2026, patch 12.1.5 | Short lists, 2 to 12 macros. |
| **PA** Parse Academy `parseacademy.com/macros/<class>` | 4 class pages | no date on the page. Its menu links "Patch 12.1.5 notes", so AFGELEID it is from Sep 2026 or later | A class-wide "every macro worth having" index (10-14 per class), not per spec. I counted it for every spec that has that spell. |
| **WT** wow-tracker.com BM PvP macros | 1 page (BM only) | no date | Counted for BM only. |
| not counted | Skill Capped Ret PvP macros ("Updated August 21, 2026"); wowlazymacros GSE threads; houseofmacros | | PvP party/arena keys, or full rotation sequences. Not the same thing. |

**Counting** (same idea as FOREVER_MACROS_POPULAR §1): per spec, a family counts once if it lists a macro for that
spell with the same job (mouseover, focus, cursor, cancel, nochanneling). A "replace the sample text with X" list
counts as a mention. **Players: 0 counted.** I ran one search for Midnight player posts about paladin macros and found
none that name macros. I did not search for hunter, mage or monk players. This is a gap, not a finding.
**Ranking (AFGELEID):** most families first. On a tie: (a) an id MH already has in TeamMacrosData, (b) the class
interrupt, (c) the spec's big cooldown, (d) the total across the class's three specs.

## 3. Top 5 per spec, and what just missed

Counts are GEMETEN (from the pages above). The ranking is AFGELEID.

| Spec | 1 | 2 | 3 | 4 | 5 | Just missed (count) |
|---|---|---|---|---|---|---|
| BM | Freezing Trap @cursor (5) | Kill Command + pet basic attacks (4) | Turtle cancel (4) | Counter Shot focus (4) | Misdirection (4, one is the TankMD addon form) | Tranquilizing Shot mouseover (4: WH,IV,WT,PA); Barbed Shot mouseover (2: WH,ME); pet reset (2) |
| MM | Misdirection (4, two are TankMD) | Freezing Trap (3) | Turtle (3) | Counter Shot (3) | Aimed Shot nochanneling (2) | Volley @cursor (2, TeamMacros cursor_volley); Trueshot + trinket (2); Disengage stopcasting (2); Tranq (2) |
| SV | Freezing Trap (4) | Turtle (3) | Misdirection (3) | Kill Command with pet check (2) | Muzzle focus (2) | Wildfire Bomb mouseover / nochanneling (2); Harpoon mouseover (1, TeamMacros) |
| Arcane | Ice Block cancel (3) | Remove Curse mouseover (3) | Counterspell focus (2) | Arcane Surge + trinkets (2) | Spellsteal focus/mouseover (2) | Alter Time cancel (2); Blink stopcasting (2); Touch of the Magi castsequence (1); Presence of Mind (1) |
| Fire | Remove Curse (4) | Flamestrike @cursor (3) | Counterspell (3) | Combustion + trinkets (3) | Alter Time cancel (3) | Meteor @cursor (3); Spellsteal (3); Ice Block (2); Blink (2); Scorch focus (1) |
| Frost | Blizzard @cursor (4) | Remove Curse (4) | Counterspell (3) | Ice Block (2) | Alter Time cancel (2) | Spellsteal (2); Polymorph focus (2); Freeze @cursor (1); Water Elemental pet keys (1) |
| Brewmaster | Provoke mouseover (4) | Detox mouseover (3) | Tiger's Lust mouseover (3) | Spear Hand Strike focus (2) | Ring of Peace @cursor (2) | Vivify mouseover (2); Exploding Keg @cursor (2); cancel Blessing of Protection (1); trinket (1) |
| Mistweaver | Vivify mouseover + Resuscitate (2) | Renewing Mist mouseover (2) | Detox mouseover (2) | Soothing Mist mouseover (2) | Tiger's Lust (2) | Life Cocoon (1); Jade Serpent Statue @cursor (1, TeamMacros); Crackling Jade Lightning mouseover (1); Paralysis (2, only as WH's Detox/Paralysis combo) |
| Windwalker | Spear Hand Strike focus (4) | Detox mouseover (4) | Tiger Palm no-clip (3) | Tiger's Lust (3) | Paralysis focus (3) | Ring of Peace @cursor (2, TeamMacros); Zenith + trinket (1); WDP/SotW (1) |
| Holy | Holy Shock mouseover (4) | Lay on Hands mouseover (3) | Blessing of Freedom (2) | Blessing of Sacrifice (2) | Word of Glory (2) | Blessing of Protection (2); Intercession (2); Beacon of Light (1, TeamMacros); Cleanse (1); Divine Toll/Holy Prism (1) |
| Protection | Freedom (4) | Lay on Hands (4) | Word of Glory (4) | Cleanse Toxins (4) | Rebuke focus (4) | **Divine Shield / BoP cancel (3: WH,IV,ME, TeamMacros bubble_cancel)**; BoP (3); BoS (3); Intercession (3); Avenger's Shield focus (2) |
| Retribution | Freedom (4) | Sacrifice (4) | Lay on Hands (4) | Blessing of Protection (3) | Rebuke focus (3) | Cleanse Toxins (3); Intercession (2); Avenging Wrath + trinkets (1) |

TeamMacrosData ids that are **not** in this top 5 (still in the Utility tab): BM mouseover_barbed_shot,
mouseover_hunter_s_mark (all hunters), MM cursor_volley, SV mouseover_harpoon, Arcane focus_polymorph, Fire
ice_block_cancel, BrM cursor_dave, MW help_harm_buttons and mouseover_jade_statue, Holy mouseover_beacon, all three
paladin bubble_cancel, Prot mouseover_blessings and mouseover_taunt (Hand of Reckoning), Ret
mouseover_execution_sentence.

The 10 kick rows overlap the existing Interrupt tab (InterruptMacrosData: Counter Shot BM/MM, Muzzle SV, Counterspell
x3, Spear Hand Strike BrM/WW, Rebuke Prot/Ret, Mistweaver and Holy none). The brief asked for class-wide kicks, so I kept
them. Rob may prefer to drop them and move the "just missed" row up.

## 4. Spell ids and talent flags (GEMETEN, retail 12.1.5.70783)

All 45 ids I queried (every id in the templates, plus a few checks) gave the expected English name in `SpellName`. Talent status comes from TraitDefinition ->
TraitNodeEntry -> TraitNode -> TraitCond (CondType 0 + spend = normal gated talent, 1 + spec set = only visible to that
spec, 2 + spec set + granted = free for that spec; these meanings are AFGELEID from the rows).

- **Baseline (talent=false), not in any TraitDefinition:** Freezing Trap 187650, Aspect of the Turtle 186265, Call Pet 1
  883, Revive Pet 982, Counterspell 2139, Provoke 115546, Vivify 116670, Resuscitate 115178, Tiger Palm 100780, Detox
  115450 (Mistweaver, SpecializationSpells 270), Word of Glory 85673. Pet attacks Claw 16827, Bite 17253, Smack 49966
  sit on the pet family skill lines.
- **Renewing Mist 115151: talent=false** (my call). SpecializationSpells lists it as a Mistweaver spec spell. It is also
  a TraitDefinition, but only in monk tree 781 (spec-visible for MW), not in tree 1000.
- **Talent=true:** Kill Command 34026 (BM-only node), Kill Command 259489 (SV-only), Aimed Shot 19434 (MM-only), Counter
  Shot 147362 (BM and MM nodes, not SV), Muzzle 187707 (SV-only), Misdirection 34477 (class, gated); Remove Curse 475,
  Spellsteal 30449, Ice Block 45438, Alter Time 342245 (class tree 658); Arcane Surge 365350 (Arcane), Combustion 190319
  and Flamestrike 2120 (Fire), Blizzard 190356 (Frost); Holy Shock 20473 (Holy-only); Rebuke 96231 (Prot and Ret nodes,
  not Holy); Cleanse Toxins 213644 (Prot and Ret, not Holy); Blessing of Freedom 1044, Sacrifice 6940, Protection 1022
  (class tree 790); Lay on Hands 633 (class tree, **granted free to Holy and Protection**, a pick for Ret); Detox 218164
  (BrM and WW nodes), Spear Hand Strike 116705 (in tree 1000: BrM and WW nodes only), Tiger's Lust 116841, Ring of Peace
  116844, Soothing Mist 115175, Paralysis 115078 (in tree 1000 **granted free to all three monk specs**).
- **Two monk trees.** TraitTreeLoadout links all three monk specs to tree 781 **and** tree 1000. Tree 1000 matches MH's
  own note that Spear Hand Strike is Brewmaster/Windwalker only, so I read 1000 as the live one (AFGELEID). In tree 781
  Spear Hand Strike is a plain class node.
- Holy has a different dispel: Cleanse 4987 overrides 440013 (also named "Cleanse Toxins") in SpecializationSpells 65.
  The Prot/Ret rows use 213644, the id in their trees.
- Alter Time: the cancel line uses 342246 (the buff), the tooltip 342245 (the spell). Both have the same name in all 7
  locales I measured.

## 5. Template decisions

- Spells only as `{id}`. No localized word inside `[...]`. Because of that:
  - **Brewmaster statue taunt** (IV, WH, ME all have one) left out: it needs `/targetexact Black Ox Statue`, an NPC
    name that differs per language. Only the mouseover Provoke line is kept.
  - **No-clip rows** (MM Aimed Shot, WW Tiger Palm) use plain `[nochanneling]`. The sources use
    `[nochanneling:Rapid Fire]` / `/stopmacro [channeling:Fists of Fury]`. AFGELEID difference: plain `[nochanneling]`
    also waits during other channels. For Windwalker that includes Spinning Crane Kick, which IV deliberately allows.
    If the builder may put `{id}` inside a conditional (the client would get its own spell name there), the source form
    is closer. I did not do that, because of the rule.
  - **Racial lines dropped** from Arcane Surge and Combustion (IV and ME add Berserking / Blood Fury / Ancestral Call by
    name). Only `/use 13` and `/use 14` are kept.
- Kick rows: `[@focus,harm,nodead][@mouseover,harm,nodead][]`. That is the IV Windwalker M+ tips order. Counterspell
  adds `/stopcasting`, as the Forever row and the IV Rebuke macro do.
- Helpful rows: `[@mouseover,help,nodead][help,nodead][@player]`. Blessing of Sacrifice has no `@player` fallback,
  because the sources give none.
- **Lengths (GEMETEN):** filled with the enUS, deDE, frFR, esES, itIT, ptBR and ruRU SpellName tables of 12.1.5.70783.
  The longest is `hu_sv_killcmd` at 196 bytes (ruRU). Next are `hu_bm_killcmd` at 175 (ruRU) and the paladin
  blessing rows at 166 (ruRU). **No row needs a tplShort.** koKR, zhCN, zhTW and esMX were not measured.
- Names are 12 characters or fewer, descriptions are 110 or fewer, keys are unique. The script checks all three (0
  problems).

## 6. Macro-rule changes in 12.0 / 12.1 (GEMETEN, with source)

1. **1 Mar 2026**, Blizzard post by Linxy, US forum thread 2261956 ("Macro Changes Now Live: Target Markers and Chat
   Messages"), and Wowhead news 380594 the same day:
   - Macros can no longer set a target marker on more than 3 units within a very short time.
   - In an active encounter, macros cannot chat in channels outside the group.
   - Group chat from macros is throttled, and every member must be inside the instance.
   - Whispers only go to people inside the instance, also throttled.
2. **21 Mar 2026**, Wowhead news 380900 (quoting Blizzard on the WoWUI Discord):
   - `/wm` and `/cwm` in macros are limited to 3 per second.
   - Macros cannot send BNet whispers during an encounter.
3. **Patch 12.1**: new commands `/pingspell` and `/pingitem` (Wowhead news 381906, 19 Jun 2026; Icy Veins, 29 Jun 2026).
   On the PTR, pinging a macro did not ping its spell (Icy Veins).
4. **Patch 12.1.5**: "Pinging a macro containing a `#showtooltip` line now pings the corresponding spell". New API
   `C_ActionBar.IsMacroActionWithShowTooltip` (warcraft.wiki.gg "Patch 12.1.5/API changes"; no date on the page).
- None of these sources mentions a change to `/cast`, `@mouseover`/`@focus`/`@cursor`, `/cancelaura`, `/stopcasting`,
  `/castsequence` or the 255 limit. That is AFGELEID and not proof that nothing changed.
- **Player claim, not confirmed:** in the same thread (1 Mar 2026), Jayde writes that nochanneling macros stopped
  working, and that macros with `/stopmacro [channeling]` lock all casts for a few seconds. No Blizzard reply on page 1.
  IV, WH and ME still recommend nochanneling macros in Oct 2026. This matters for `hu_mm_aimed` and `mo_ww_noclip`, so
  test those two first.

## 7. Unsettled

- No macro has been tried in game.
- Live monk tree is 781 or 1000. AFGELEID: 1000.
- The `talent` flag follows the TraitDefinition rule. Lay on Hands (Holy/Prot) and Paralysis (all monks) are free
  grants there, so a player always knows them.
- Ice Cold replaces Ice Block when talented. The cancel line then does nothing (AFGELEID, not measured).
- Flamestrike and Blizzard @cursor only help with the ground-targeted talent choice (IV, ME). I did not check which
  choice node that is in DB2.
- Kill Command + pet: the three `/use` lines only fire the pet's basic attack if its family has Claw, Bite or Smack
  (WH, ME say these three cover every family; not measured).
- Wowhead dates for BM, Arcane, Fire and MW were not seen. The WH MM macro section was not read in full.
- Player posts were not counted (section 2).
