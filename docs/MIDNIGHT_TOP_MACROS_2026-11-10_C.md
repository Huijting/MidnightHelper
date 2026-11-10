# Retail top macros, part C (Priest, Rogue, Shaman, Warlock, Warrior): notes, 10 Nov 2026

Data: `retail_macros_C.lua` in this scratchpad (75 rows, 15 specs x 5). Labels: **GEMETEN** = seen in a named, dated
source or in DB2. **AFGELEID** = my reasoning.

**Nobody has tested these macros in the game.** Not me, and the guide counts say nothing about whether a macro fires.

## 1. Spec list and order (GEMETEN, wago DB2 ChrSpecialization, retail 12.1.5.70783)

| Class (ClassID) | OrderIndex 0 / 1 / 2 | spec index used in the data |
|---|---|---|
| Warrior (1) | Arms 71 / Fury 72 / Protection 73 | 1 / 2 / 3 |
| Rogue (4) | Assassination 259 / Outlaw 260 / Subtlety 261 | 1 / 2 / 3 |
| Priest (5) | Discipline 256 / Holy 257 / Shadow 258 | 1 / 2 / 3 |
| Shaman (7) | Elemental 262 / Enhancement 263 / Restoration 264 | 1 / 2 / 3 |
| Warlock (9) | Affliction 265 / Demonology 266 / Destruction 267 | 1 / 2 / 3 |

There is also an "Initial" spec per class with OrderIndex 4 (1444-1454); it is the pre-spec state and gets no rows.
Index = OrderIndex + 1: AFGELEID from DB2, and it matches MH's own data (TeamMacrosData PRIEST [3] = Shadow,
InterruptMacrosData PRIEST {false, false, Silence}). Not checked in the client.

## 2. Sources (all read 10 Nov 2026 with Exa / WebFetch)

| Family | Pages | Date on the page | Notes |
|---|---|---|---|
| **IV** Icy Veins | `icy-veins.com/wow/<spec>-<class>-pve-<role>-macros-addons` x15 | all "Last Updated Oct 12, 2026", patch 12.1.5 | Full macro text. |
| **WH** Wowhead | `wowhead.com/guide/classes/<class>/<spec>/addons-macro-ui-imports` x15 | Arms/Fury "Updated 2026/10/13"; others say "Midnight", date not in the text I got | Read through Exa. The `[...]` conditionals and some spell names were stripped from the text, so WH is counted by its description ("mouseover", "cursor", "focus"), not by exact text. |
| **MT** Method | `method.gg/guides/<spec>-<class>/interface-and-macros` x15 | 13 to 25 Oct 2026, patch 12.1.5 | Full macro text. Destruction read with WebFetch. |
| **OB** myoffbar.com | `/combat/` (one page, all classes) | "Beta, updated Oct 22, 2026", Midnight S2 12.1 | Class-level. Marks some macros "Works for us 2026-09-22" (their own claim). |
| **EZ** ezmacro.io | `/macros/<class>` x5 | entries dated 10 Mar 2026 (2 warlock ones Jun 2026) | Class-level, with **copy counts** (the only usage signal I found). AI-made site; it lists dead spells (Vendetta, Dark Soul, Flagellation) and a wrong name ("Spell Reflect"), so treat counts as weak. Only the first 12 of 60 per class were visible. |
| boostmatch.gg | Fury guide | 6 Apr 2026 | Only used for Fury Recklessness+Avatar. |
| dving.net | Warrior guide | no date | Only mentioned (focus Taunt). |
| Players | EU forum "Mouseover casting" (2 Feb 2026); Wowhead comment by cooksta262 on the Shadow page (no date visible) | | See §4. |

Not counted: Elvenbane's "Useful Macro Templates" (Blizzard forum, 2018/2019 thread, sections marked 10.1.7, so not
Midnight-dated; Icy Veins Holy credits it). parseacademy.com (one generated page per spell, no ranking).
wowlazymacros / houseofmacros (GSE one-button rotations, a different kind of macro). Not reached: Reddit threads, class
Discords' own pages, a Blizzard UI & Macro forum thread per class (one Exa search, nothing Midnight-dated about these
classes came back; an empty search proves nothing).

**Counting** (same idea as the Forever POPULAR doc §1): per spec, a family counts once when its page for that spec, or
its class page (OB, EZ), has that macro or a close variant. Copies count once. `src` in the Lua gives the number, the
families, EZ copy counts, and "TM <id>" / "IM" when MH's TeamMacrosData / InterruptMacrosData already has it. The
choice of 5 is AFGELEID: most families first; at a tie, the class-wide kinds Rob asked for (interrupt on focus,
mouseover heal/dispel, @cursor ground spell, defensive with cancel, pet control) win.

## 3. Spell ids (GEMETEN, DB2 retail 12.1.5.70783)

Every `{id}` and `need` is in SpellName in enUS, deDE, frFR, ruRU, esES, ptBR and itIT (script `rmc_check.py`).
`talent` = true when the spell is only in TraitDefinition (no baseline row): baseline = SkillLineAbility on the class
skill line (Priest 804, Warrior 840, Warlock 849, Rogue 921, Shaman 924) with AcquireMethod 2 or 4, or
SpecializationSpells for that spec. The meaning of AcquireMethod (2 = learned automatically by level, 3 = never
learned automatically) is from memory of the TrinityCore enum: AFGELEID. It fits the data: Kick/Pummel/Taunt are 2,
while Blind/Tricks/Cloak of Shadows are 3 and have a TraitDefinition.

Points worth knowing (all GEMETEN in DB2):
- **Earthquake**: 61882 "is cast at a selected location" (used, @cursor); 462620 "is cast at your target" is the other
  choice. Same for **Rain of Fire**: 5740 location (used), 1214467 target.
- **Execute**: Arms/Prot 163201 (class line); Fury has 5308, which overrides 163201 (SpecializationSpells).
- **Silence** 15487 is a Shadow spec spell only (no talent row). Disc and Holy have no Silence.
- **Wind Shear** 57994, **Purge** 370, **Capacitor Totem** 192058: talents. **Purify Spirit** 77130 = Resto spec spell
  (overrides Cleanse Spirit 440012). **Flame Shock** 470411 baseline.
- **Purify** 527 = Disc/Holy spec spell (overrides 440006). Shadow's Purify Disease 213634 is a talent.
- **Spell Lock / Axe Toss** are pet spells (not on the warlock lines). The rows use **Command Demon** 119898
  (warlock baseline), like InterruptMacrosData does.
- **Coup de Grace** 441423 is the hero talent; its text says your next Eviscerate "will be performed as a Coup de
  Grace". The castable spell has another id; the macro casts by the name of 441423. That both have the same name in
  every language is AFGELEID.
- **Grappling Hook** 195457 is an Outlaw spec spell (talent=false for Outlaw). **Shadowstep** Sub = 394935.
- **Ignore Pain**: 190456 used; 1277297 is a second "Ignore Pain" with its own talent row (purpose not checked).

**Length** (GEMETEN, filled with each locale's names): longest = priest Dispel, 252 bytes in ruRU. All others
<= 167. The Dispel rows carry a `tplShort` (without the `known:` checks) as margin. koKR/zhCN/zhTW not measured.

**Template rules kept**: spells only as `{id}`; no `{id}` inside `[...]` (checked by script); the only ids in brackets
are literal numbers in `known:` (Icy Veins Assassination, 12 Oct 2026: "[known:SPELLNAME] or [known:SPELLID]").

**Keys**: the same macro in several specs gets `_1/_2/_3` (e.g. `ro_kick_1`, `ro_kick_2`). Rows with the same base
have the same tpl and desc, so one RMAC_ string can serve all of them if the build chat prefers.

## 4. Macro rule changes found (12.0 / 12.1)

1. **GEMETEN, Blizzard via Wowhead news 380594 and MMO-Champion, 1 Mar 2026** ("Macro Changes Now Live to Prevent
   Workarounds for Addon Restrictions"): macros may not set a target marker on more than 3 units within a very short
   time. During an active encounter only: no macro chat to non-group channels; group channels rate-limited and only when
   the whole group is in the instance; whispers only to someone in the instance, rate-limited. None of the 75 rows
   uses /tm or chat.
2. **GEMETEN (addon author)**, SilverDragon changelog v2026.14: "a Blizzard hotfix meant `exists` causes errors with
   /tm". Date of that entry not visible (between 12.0 launch and 12.0.5). Matters only for marker macros.
3. **GEMETEN (players)**, EU forum "Mouseover casting" (2 and 28 Feb 2026): two posters say Blizzard's built-in
   Mouseover Cast option stopped working at the pre-patch; others say their mouseover macros work, and one says the
   option never applied to macros. Not a confirmed change.
4. **GEMETEN (guide)**, Icy Veins warlock pages (12 Oct 2026): the Soulstone mouseover macro is a "workaround for the
   current bug related to mouseover dead allies" (it targets, casts, then targets back). A US forum post from Feb 2024
   reports the same bug since Dragonflight. My Soulstone rows follow that workaround: AFGELEID wording, untested.
5. **GEMETEN (guide)**, Icy Veins Discipline (note added 11 Aug 2026): clipping Penance is intended this patch, so the
   `[nochanneling:Penance]` macro is not advised. Not a rule change, but it is why no no-clip row is in Disc.
6. Claims I did not measure: OB says Restoration's Wind Shear has a 30 s cooldown, Psychic Horror is gone and Shackle
   Undead is now Shackle Horror (Icy Veins Shadow changelog 10 Feb 2026 agrees on Shackle Horror).

No change to the 255-character limit or to the conditionals was found. An empty search proves nothing.

## 5. Per spec: the 5 chosen, and the next ones (for Rob to swap)

Counts = families (see `src` in the Lua for the list).

- **Discipline**: PW Shield mouseover 4, Power Infusion 3 (+2 other pages), Angelic Feather 3, Dispel all-in-one 5
  (parts), Penance mouseover 2. Next: Pain Suppression mouseover (OB, EZ 46), PW: Barrier @cursor (TM, EZ 35; Method
  advises against it).
- **Holy**: Sanctify @cursor 2 (+TM), Power Infusion 4, Leap of Faith 3, Feather 3, Dispel all-in-one 4. Next:
  Guardian Spirit mouseover (OB, EZ 47), Shackle Horror focus (IV), cancel Spirit of Redemption (IV).
- **Shadow**: Silence 3, Power Infusion 5, SW: Pain mouseover 3, Mass Dispel @cursor 3, Dispersion with cancel 1 + 1
  player. Next: Tentacle Slam mouseover (WH, TM), Vampiric Touch mouseover (IV). **Left out on purpose**: the Void
  Torrent no-clip macros (IV, MT, TM; 3 families) need `[nochanneling:Void Torrent]`, a spell NAME inside the brackets.
  That breaks the "conditionals literal" rule; whether `channeling:` takes a spell id is unknown. TM has them with
  English names, which a non-English client will not match (AFGELEID).
- **Assassination**: Kick 4, Deathmark + trinkets 3, Tricks 2 (+2 sub pages), Kidney Shot 2, Blind 2. Next: Distract
  @cursor (WH), Cloak of Shadows with cancel (OB).
- **Outlaw**: Grappling Hook @cursor 3, Kick 4, Kidney Shot 3, Tricks 2, Blind 2. Next: Adrenaline Rush + trinket
  (EZ 35 only).
- **Subtlety**: Shadow Dance combo 3, Coup de Grace / Black Powder 3, Shadowstep mouseover 4, Kick 4, Tricks 4. Next:
  Shadow Blades + trinkets (IV), Shadowstrike/Backstab (WH).
- **Elemental**: Earthquake @cursor 4, Wind Shear 3, Capacitor @cursor 4, Purge 3, Flame Shock mouseover 2. Next: Wind
  Rush Totem @cursor (IV, MT), Ancestral Swiftness + Lava Burst (IV; WH opener).
- **Enhancement**: Wind Shear 4, Surging Totem 2 (hero talent Totemic), self Healing Surge 2, Capacitor 2, Cleanse
  Spirit 3. Next: Totemic Projection + Stormstrike (IV, WH), Hex focus (IV/WH generic, OB, EZ 38).
- **Restoration**: Healing Rain @cursor 2 (+TM), Riptide / Flame Shock help-harm 4, Wind Shear 4, Purify Spirit 3,
  Capacitor 3. Next: Spirit Link Totem @cursor (EZ 70), Hex focus (MT, OB).
- **Affliction**: Agony 2, Corruption 2, pet interrupt 3, Soulstone 4, Shadowfury 4. Next: Demonic Circle summon/port
  (IV x3, EZ 56), Healthstone + Soulburn (MT, WH; it needs an item, the template has no item placeholder), Banish focus
  (IV x3).
- **Demonology**: pet interrupt 3, Demonbolt mouseover 2, Soulstone 4, Shadowfury 5, pet control 1 (IV on all 3
  warlock pages). Next: the Grimoire macro (IV, WH; uses `known:1276467` / `known:1276452`; not chosen because a row
  can name only one `need`).
- **Destruction**: Havoc mouseover 3, Rain of Fire @cursor 3, Summon Infernal @cursor 4, pet interrupt 3, Soulstone 5.
  Next: Cataclysm @cursor (IV, MT, WH = 3, a tie), Shadowfury.
- **Arms**: Pummel 5, Heroic Leap @cursor 5, Execute mouseover 2, Charge + Victory Rush 2, Colossus Smash + Avatar 3.
  Next: one-key stance swap (IV, WH), Bladestorm/Ravager switch (IV).
- **Fury**: Pummel 5, Heroic Leap 5, Execute mouseover 2, Recklessness + Avatar 4, Charge + Victory Rush 2. Next:
  Bloodthirst mouseover (MT), Thunder Clap/Whirlwind switch (IV, WH).
- **Protection**: Pummel 4, Taunt mouseover 2, Intervene/Charge 4, Heroic Leap 4, Ignore Pain + Shield Slam 1 (IV only;
  weakest row of the 75). Next: Heroic Throw mouseover (IV), Avatar + trinket (WH).

TeamMacrosData rows **not** in the top 5 for these classes: Disc `cursor_barrier`, Shadow `mouseover_tentacle_slam`
and the three Void Torrent ones, Affliction `focus_fear`, Arms `cursor_ravager` and `mouseover_intervene`, Fury
`cursor_spear`.

## 6. Not settled

- **No in-game test of anything.** Most open: the Soulstone target-swap version; `/petmoveto [mod:shift,@cursor]`
  (IV shows `/petmoveto [@cursor]`, the modifier mix is mine); `/cast Command Demon` by name (same as MH's
  InterruptMacros, also untested); Coup de Grace by the talent's name; the Dispel all-in-one.
- Victory Rush with Impending Victory talented: IV says naming Victory Rush keeps working (GEMETEN guide claim, not
  measured). Same open question for Purge vs Greater Purge 378773, and Colossus Smash vs Warbreaker (EZ uses
  Warbreaker; not looked up in DB2).
- Agony 980, Riptide 61295, Healing Rain 73920 and Sanctify 34861 are talent-only in DB2 although they are core spells
  of their spec (probably a free node in the spec tree: AFGELEID). With talent=true the row is hidden until known,
  which is harmless here.
- Wowhead dates for 12 of the 15 pages and the exact WH macro text were not visible (see §2).
- koKR/zhCN/zhTW byte lengths not measured.
