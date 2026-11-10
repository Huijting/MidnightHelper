# Retail (Midnight 12.1) macros, part A: Death Knight, Demon Hunter, Druid, Evoker

Research date: 10 Nov 2026. Data file: `retail_macros_A.lua` (same folder, 48 rows, `luac -p` clean).
Labels: **GEMETEN** = seen in a named, dated source (or measured in DB2). **AFGELEID** = my reasoning.
**Nobody has tested any of these macros in the live client: not me, and none of the guide pages says it did.**

---

## 1. Specs and their order (GEMETEN, wago DB2 `ChrSpecialization`, retail build 12.1.5.70783)

| Class (ClassID) | OrderIndex 0 | 1 | 2 | 3 |
|---|---|---|---|---|
| DEATHKNIGHT (6) | Blood 250 | Frost 251 | Unholy 252 | |
| DEMONHUNTER (12) | Havoc 577 | Vengeance 581 | **Devourer 1480** | |
| DRUID (11) | Balance 102 | Feral 103 | Guardian 104 | Restoration 105 |
| EVOKER (13) | Devastation 1467 | Preservation 1468 | Augmentation 1473 | |

Each class also has an "Initial" row with OrderIndex 4 (1455, 1456, 1447, 1465). That is the spec before you
pick one, not a real spec. Demon Hunter's third spec is Devourer (GEMETEN).
Spec index = OrderIndex + 1: AFGELEID. It matches MH's own `InterruptMacrosData.lua` comments ("Havoc, Vengeance,
Devourer"; "Balance, Feral, Guardian, Restoration (client spec order)"). I did not measure it in the client.

## 2. Sources and how they were counted

Same method as `FOREVER_MACROS_POPULAR_2026-11-10.md` §1, with retail sources. **Named x/3** = how many of the
three named guide families list that macro (or a close variant) for that spec: Wowhead (WH), Icy Veins (IV),
Method (ME). Other families are listed after the count. A copy counts once.

| Family | Pages read (10 Nov 2026, through Exa) | Date on the page |
|---|---|---|
| **Wowhead** (named) | `/guide/classes/<class>/<spec>/addons-macro-ui-imports`, all 13 specs | "Updated: 2026/10/13" (DK, DH Havoc, Druid Balance, Evoker Pres/Aug seen); others say "Midnight" with no date in the extract |
| **Icy Veins** (named) | `<spec>-<class>-pve-<role>-macros-addons`, all 13 specs | "Last Updated: Oct 12, 2026", "Reviewed for Patch 12.1.5" |
| **Method** (named) | `method.gg/guides/<spec>-<class>/interface-and-macros`, all 13 specs | "Patch 12.1.5, Last Updated" 13 to 28 Oct 2026 |
| Dreamgrove (druid Discord) | GitHub `dreamgrove/data/blog/balance/compendium.mdx` | patch 12.0.7 (only Balance found). Same author (Gamz) as WH and ME Balance. |
| gearinsight.app | `/wow/en/macros/death-knight/blood`, `/demon-hunter/devourer` | "12.1", no date. Its Blood list has the same four macros as IV with the same conditionals, so I read it as derived from IV. |
| Skill-Capped | Havoc DH PvP macros | "Updated August 21, 2026" (PvP) |
| ezmacro.io, slashmacros.com, parseacademy.com | aggregator pages | ezmacro entries dated Mar 10 2026 with copy counts; others undated |
| Players | US forum thread 2234111 (11 posts, 22 Jan to 12 Apr 2026); Wowhead comments (ceejai on Havoc; Nizzari + guide author Jereico on Aug, 2 Jul 2026; OMGJesuis on Pres); Shadarek's Devourer video guide (Midnight Season 1, date not visible) | |

Not counted: wowlazymacros.com and houseofmacros (GSE rotation sequences, not single macros), kiratank (video only),
gerritalex.de "Useful Evoker Macros" by Xepheris (published 2 Jul 2025, "Updated Dec 7": before the 1 Mar 2026 cut).

**Limits (GEMETEN about my own reading):**
- **Exa drops the `[...]` conditionals from Wowhead's macro text** (it shows e.g. `#showtooltip /cast Disrupt`). So for
  Wowhead I saw which macros it lists and what it says they do, but mostly not its exact conditionals.
- Wowhead was not opened in the browser (no CAPTCHA risk taken). WebFetch got only the page head (date 2026/10/13).
- **Reddit: not reached.** An Exa `site:reddit.com` search returned nothing; I did not fetch reddit directly.
- Class Discords: only Dreamgrove (Balance). Acherus (DK), Fel Hammer (DH) and the Evoker Discord guides were not found.
- Exa can serve an old copy of a page (CLAUDE.md, 3 Sep). Every page above shows an October 2026 date itself, so
  that risk looks small here, but it is not zero.
- An empty search proves nothing.

## 3. Macro-rule changes in 12.0 / 12.1

1. **GEMETEN, Blizzard.** US forum thread 2261956 "Macro Changes Now Live: Target Markers and Chat Messages",
   posted 1 Mar 2026 by Linxy (Community Manager; JSON says staff/moderator/admin). In short:
   - At all times: a macro cannot set a target marker on more than 3 units within a very short time.
   - During an active encounter: no macro chat to channels that are not group-only (custom, guild, communities).
   - During an encounter: /party, /raid and /rw still work, but rate-limited, and only when every group member is
     inside the instance. Whispers still work if the target is in the instance, also rate-limited.
   - AFGELEID: none of the 48 rows sends chat or sets markers, so this does not touch them.
2. **GEMETEN, players, no Blizzard reply found.** US Bug Report thread 2234111 "Nochanelling and stopmacro when
   channeling broken": 11 posts, 22 Jan to 12 Apr 2026, several classes (DH Void Ray / Eye Beam, Evoker, Shadow
   Priest, Frost Mage). `/stopmacro [channeling]` and `[channeling:Void Ray]` macros sometimes lock you out of
   casting for about 3 to 5 seconds after the channel. Gurk (12 Apr) says `/cast [nochanneling] X` works better, though
   the problem still happens sometimes. A blue post or a fix note was not found. Status in 12.1: **not known.** An
   unrelated Shadow Priest thread (2396900, 31 Oct to 3 Nov 2026) has a poster "using the macro without the no
   channeling part". That is a hint, not proof.
   - Icy Veins Devourer (12 Oct 2026): the no-channel macros "do not currently work with Void-Scarred" (their words).
   - Shadarek's video: says the Void Shard macro is bugged and he has heard of random macro bugs. He mentions an EU
     support post saying the devs know. I did not see that post.
   - → Row `dh_consume` uses the `[nochanneling]` form and has `warn = "channelbug"`.
3. **GEMETEN, Wowhead Augmentation comments, 2 Jul 2026 (12.0.7):** the cursor Breath of Eons macro stopped working
   ("spell not available"). The guide author's fix: write Deep Breath in the macro instead of Breath of Eons. The page
   now says the same thing.
4. **GEMETEN, Wowhead Devastation/Augmentation (Oct 2026):** the default UI now has a mouseover-casting setting. It
   can cast Living Flame on allies by accident, so Wowhead advises using it only with a modifier key.
5. **GEMETEN, weak source.** wowcarry.com (a commercial boosting site, undated) says 12.1 has 120 general and
   30 character macro slots. Not checked anywhere else.
6. **Not found:** any 12.0/12.1 change to `/cast` conditionals, `@cursor`, `/castsequence`, `#showtooltip` or the
   255-character limit. Method (Oct 2026) still prints a `/castsequence reset=2 Blur, null` macro, and Icy Veins
   Feral a `/castsequence [@cursor] reset=20 Ursol's Vortex, Typhoon`. The warcraft.wiki.gg "Patch 12.0.0/API changes"
   page lists the chat-lockdown API (`C_ChatInfo.InChatMessagingLockdown`) but nothing about macro commands, in the
   part I could read. An empty search proves nothing.

## 4. Template rules applied

- Spells only as `{id}`. Conditionals are literal. No localized word inside `[...]`. So these source forms were
  changed or left out: `[channeling:Void Ray]` (→ unnamed `[nochanneling]`), `[known:Ursol's Vortex]` (Method Feral),
  `[known:Temporal Burst]` (Wowhead Aug), `[@PlayerName-Realm]` (Method Aug). `[nostance:1]` stays: it is a number.
- Every row filled with each client's own names, all 11 client locales (enUS deDE frFR esES esMX ptBR itIT ruRU koKR
  zhCN zhTW), GEMETEN from wago SpellName per locale: longest = 179 bytes (`dr_nsregrowth`, ruRU). So no `tplShort`.
- Each spec has exactly 5 rows: its own rows plus the class's `spec = 0` rows. A `spec = 0` row is in the top 5 of
  every spec of that class. When one macro is in some (not all) specs' top 5, it appears once per spec with a digit
  on the key (`dh_misery1`/`dh_misery3`, `dr_innervate1`/`2`, `dr_skullbash2`/`3`, `dr_decurse2`/`3`). The twins
  have the same `tpl` and `desc`. AFGELEID design choice; the builder may prefer another shape.
- Extra fields, not in the asked list: `bytes` (longest filled size) and `warn` (only on `dh_consume`).

## 5. Top 5 per spec, with the counts (Named x/3 = WH, IV, ME)

Ranking = named count first, then extra families, then "everyone in the class can use it" (AFGELEID).

**Death Knight, all specs (spec 0):** Mind Freeze focus/mouseover (3/3, IV focus+mouseover form), Raise Ally
mouseover (3/3), Death Grip mouseover (3/3 across specs; ezmacro 135 copies).
- **Blood:** + Death and Decay cursor, Ctrl = feet (3/3), + Gorefiend's Grasp (2/3: WH, IV).
  Below: Control Undead re-control (2/3: WH, IV; uses `/run PetDismiss()`), Dark Command mouseover (ME), Cancel
  Blessing of Protection (IV), Asphyxiate (gearinsight).
  - AFGELEID: IV's Blood DnD macro is `[@cursor] DnD; [mod:ctrl, @player] DnD`. The first clause always matches, so
    its Ctrl part can never fire. The row uses gearinsight's order `[mod:ctrl,@player][@cursor]`.
- **Frost:** + Pillar of Frost burst (3/3, three different mixes; merged, AFGELEID), + Anti-Magic Zone cursor
  (2/3: IV, ME). Below: Asphyxiate mouseover (WH), Howling Blast / Chains of Ice mouseover (ME), Breath of Sindragosa
  burst (ME), Control Undead (WH, IV).
- **Unholy:** + Ghoul Leap + `/petattack` (3/3 pet-attack family; Wowhead form), + Outbreak mouseover (2/3).
  Below: DnD cursor (2/3), AMZ cursor (2/3), pet dismiss/resummon (WH, IV, ME), Army/Dark Transformation opener (WH,
  ME), Soul Reaper mouseover (ME).

**Demon Hunter, all specs:** Disrupt focus/mouseover (3/3 Havoc+Vengeance, 2/3 Devourer), Consume Magic
focus/mouseover (Havoc 2/3, Vengeance 3/3, Devourer IV). Both merged from separate focus and mouseover macros
(AFGELEID).
- **Havoc:** + Metamorphosis cursor, Alt = in place (3/3 + Skill-Capped; Alt idea from a Wowhead comment by ceejai),
  + Sigil of Misery cursor (2/3), + Imprison focus/mouseover (WH + Skill-Capped PvP). Below: Eye Beam "don't cancel"
  template (WH calls it "extremely important"; but see the channel bug in §3), mouseover focus-set (WH, ME), Throw
  Glaive mouseover (ME), Blur castsequence (ME), Eye Beam cancel (ME).
- **Vengeance:** + Sigil of Flame cursor (3/3), + Infernal Strike cursor/Ctrl in place (3/3), + Torment mouseover
  (3/3). Below: Sigil of Misery (WH, ME), Imprison (WH, ME), Reaver's Glaive (WH, ME; a hero-talent override, no own
  DB2 hit), Cancel Blessing of Protection (WH, IV), Demon Spikes + Fracture (IV).
- **Devourer:** + Consume that never cuts Void Ray (2/3 + gearinsight + Shadarek; `[nochanneling]` form, warn),
  + Shift cursor (ME + Shadarek), + Sigil of Misery cursor (IV only). Below: Void Nova mouseover (ME), Blur (ME),
  Void Ray cancel (ME). Devourer has the thinnest source base of the DH specs.

**Druid, all specs:** Rebirth mouseover (3/3; ezmacro 90 copies).
- **Balance:** + Celestial Alignment cursor = Orbital Strike (3/3 + Dreamgrove), + Force of Nature cursor (3/3 +
  Dreamgrove), + Innervate mouseover (3/3), + Sunfire mouseover (2/3). Below: Remove Corruption mouseover (2/3: IV,
  ME, tied with Sunfire), Moonfire mouseover, stopcasting Bear Form / Wild Charge (WH), Heart of the Wild bear macro
  (IV). WH: the CA macro still works when Incarnation is talented (GEMETEN, their claim).
- **Feral:** + Skull Bash focus/mouseover (2/3), + Ursol's Vortex cursor (3/3), + Innervate (2/3), + Remove
  Corruption mouseover (IV only; tied with WH's Berserk/Tiger's Fury opener and ME's Entangling Roots). MH's existing
  Feral "Mouseover Regrowth" (Predatory Swiftness) has no named source this round.
- **Guardian:** + Skull Bash (3/3), + Moonfire mouseover (2/3 + WH names it), + Remove Corruption (2/3 + WH names
  it), + Growl mouseover (IV + WH names it; MH has it). Below: Cancel Blessing of Protection (IV, WH), Incarnation +
  trinket (WH), Regrowth / Innervate mouseover (ME).
- **Restoration:** + Rejuvenation mouseover chain (3/3, the template for every heal), + Efflorescence cursor (ME +
  MH), + Nature's Swiftness + Regrowth (2/3 NS combos; AFGELEID fallback), + Innervate on yourself (WH only,
  AFGELEID conditional). Below: Ironbark mouseover (only aggregators), Nature's Cure mouseover (template only),
  Ursol's Vortex cursor (ME), shapeshift/cancelform keys (IV, ME). All three guides also point to Clique/Clicked
  instead of macros for healing.

**Evoker, all specs:** Rescue mouseover (3/3, many variants; ezmacro 61 copies), Verdant Embrace mouseover chain
(Dev 2/3, Aug 2/3 incl. WH self version, Pres template; AFGELEID chain).
- **Devastation:** + Quell focus/mouseover (WH only by name; class-wide interrupt rule; AFGELEID), + Deep Breath
  cursor (2/3; ME: for Flameshaper), + Cauterizing Flame mouseover (2/3). Below: Deep Breath cancel + filler (ME,
  WH), Spatial Paradox + Time Spiral (ME, WH), Fire Breath + trinket on Shift (IV), Dragonrage + cancel Deep Breath
  (WH), Emerald Blossom mouseover (IV).
- **Preservation:** + Emerald Blossom mouseover chain (2/3 + WH template), + Naturalize mouseover (AFGELEID: no
  source names it, all three say "make one for every spell"), + Time Dilation mouseover (AFGELEID: aggregator only).
  Below: Wowhead's one-press Rescue (`/cast Rescue`, `/target`, `/stopspelltarget`; conditionals not visible in the
  extract), Echo / Dream Breath mouseovers (template only). **Preservation is the weakest spec in this file.**
- **Augmentation:** + Prescience mouseover (3/3), + Black Attunement + Eruption (3/3, `[nostance:1]`), + Blistering
  Scales mouseover (2/3). Below: Tip the Scales cancel (IV, WH; WH's form has `[known:...]`), Deep Breath cursor for
  Chronowarden (ME, WH; write Deep Breath, not Breath of Eons), Cauterizing Flame (IV, WH), Bronze Attunement mount
  macro (IV; uses `/run C_MountJournal.SummonByID(0)`).

## 6. Spell-id evidence (GEMETEN unless marked)

All from wago DB2, retail build 12.1.5.70783: `SpellName` (names in 11 locales), `SkillLineAbility` (class lines
DK 796, Druid 798, DH 1848, Evoker 2810, from `SkillLine`), `SpecializationSpells`, `TraitDefinition`. Positive
control: every name in the macro list returned rows (raw counts printed where no class hit was found).

| id | name | how it is learned (DB2) | talent |
|---|---|---|---|
| 47528 | Mind Freeze | TraitDefinition 101215 | true |
| 61999 | Raise Ally | SkillLineAbility DK | false |
| 49576 | Death Grip | SkillLineAbility DK | false |
| 43265 | Death and Decay | SkillLineAbility DK | false |
| 108199 | Gorefiend's Grasp | TraitDefinition 101172 | true |
| 51271 | Pillar of Frost | TraitDefinition 130705 | true |
| 46585 | Raise Dead (Blood/Frost) | TraitDefinition 101203; Unholy's 46584 overrides it (SpecializationSpells) | (inside dk_pillar) |
| 49020 | Obliterate | TraitDefinition 101248 | (inside dk_pillar) |
| 51052 | Anti-Magic Zone | TraitDefinition 101196 | true |
| 47482 | Leap (ghoul) | SkillLineAbility 782 (a pet line, not the DK line) | need = 46584 |
| 46584 | Raise Dead (Unholy) | SpecializationSpells Unholy | false |
| 77575 | Outbreak | TraitDefinition 101328 | true |
| 183752 | Disrupt | SkillLineAbility DH | false |
| 278326 | Consume Magic | TraitDefinition 117931 | true |
| 191427 | Metamorphosis (Havoc) | SkillLineAbility DH (Vengeance has 187827, SpecializationSpells) | false |
| 207684 | Sigil of Misery | TraitDefinition 117864 | true |
| 217832 | Imprison | TraitDefinition 117932 | true |
| 204596 | Sigil of Flame | SkillLineAbility DH + SpecializationSpells Vengeance | false |
| 189110 | Infernal Strike | SpecializationSpells Vengeance | false |
| 185245 | Torment | SkillLineAbility DH | false |
| 473662 | Consume | SpecializationSpells Devourer | false |
| 1234796 | Shift | SpecializationSpells Devourer | false |
| 20484 | Rebirth | SkillLineAbility Druid | false |
| 194223 | Celestial Alignment | TraitDefinition 114854 has SpellID 395022 with VisibleSpellID 194223; Wowhead tooltip: 194223 has the 3 min cooldown | true |
| 205636 | Force of Nature | TraitDefinition 114849 | true |
| 29166 | Innervate | TraitDefinition 108329 | true |
| 93402 | Sunfire | TraitDefinition 121114 | true |
| 106839 | Skull Bash | TraitDefinition 108327 | true |
| 102793 | Ursol's Vortex | TraitDefinition 133392 | true |
| 2782 | Remove Corruption | TraitDefinition 108325 | true |
| 8921 | Moonfire | SkillLineAbility Druid | false |
| 6795 | Growl | SkillLineAbility Druid | false |
| 774 | Rejuvenation | TraitDefinition 108300 | true |
| 145205 | Efflorescence | TraitDefinition 108116 | true |
| 132158 | Nature's Swiftness | TraitDefinition 108106 | true |
| 8936 | Regrowth | SkillLineAbility Druid | (inside dr_nsregrowth) |
| 370665 | Rescue | TraitDefinition 92687 / 120608 | true |
| 360995 | Verdant Embrace | TraitDefinition 92717 / 120667 | true |
| 351338 | Quell | TraitDefinition 92694 / 120657 / 120702 | true |
| 357210 | Deep Breath | SkillLineAbility Evoker | false |
| 374251 | Cauterizing Flame | TraitDefinition 92702 / 120614 | true |
| 355913 | Emerald Blossom | SkillLineAbility Evoker (Dev/Aug/Initial have 365261 via SpecializationSpells) | false |
| 360823 | Naturalize | SpecializationSpells Preservation | false |
| 357170 | Time Dilation | TraitDefinition 92615 / 120662 | true |
| 409311 | Prescience | TraitDefinition 120687 | true |
| 395160 | Eruption | TraitDefinition 120510 | true |
| 403264 | Black Attunement | not in SkillLineAbility / Spec / Trait; Wowhead tooltip: 403264 has the 3 sec cooldown, 403295 is the 100-yd aura | (inside ev_blackattune) |
| 360827 | Blistering Scales | TraitDefinition 120520 | true |

## 7. Unsettled (say these to Rob)

1. **Not tested in game.** No row, no conditional, no fallback chain.
2. **`need` ids that may not answer "known" the way the builder expects** (AFGELEID risk, check in the client with
   `IsPlayerSpell`/`IsSpellKnownOrOverridesKnown`): 194223 vs 395022 (Celestial Alignment), 46585 for Frost vs 46584
   for Unholy (Raise Dead), 355913 vs 365261 (Emerald Blossom; Preservation row uses 355913), and `dk_leap` uses the
   Unholy Raise Dead 46584 because the ghoul's Leap is a pet spell.
3. **`talent = true` includes free spec nodes.** TraitDefinition also holds nodes every player of that spec gets
   (e.g. Eye Beam, Void Ray, Obliterate). So a `talent` row may be known for everyone in that spec. I tried to read
   the spec gate from TraitCond/SpecSetMember; it gave odd answers (Expunge "gated" to Preservation), so spec
   placement comes from the guides, not from that analysis.
4. **Wowhead's exact conditionals were not visible** (Exa strips them). Wowhead counts are "lists this macro".
5. **The channel bug (§3.2)**: `dh_consume` may lock casting for seconds, or not; status in 12.1 unknown.
6. **Evoker colour subtexts**: Wowhead writes `Cauterizing Flame(Red)`, `Verdant Embrace(Green)`, `Prescience(Bronze)`.
   IV, ME and MH's existing TeamMacros use the plain name. The rows use plain names. Not tested.
7. **Preservation** (Naturalize, Time Dilation) and **Devourer** (Sigil of Misery) have only one or zero named sources.
8. **Spec index = OrderIndex + 1** is AFGELEID from MH's own code comments, not measured by me in the client.
9. **Wowhead/Icy Veins share authors** with Method on several specs (e.g. Taeznak DK, Meyra Vengeance, Voulk Resto
   on WH + IV, Gamz Balance on WH + ME + Dreamgrove). Counted as separate families, like the Forever method, but the
   independence is lower than the count suggests.
