# WoW Forever — Warlock: spells tot 60 + VOORSTEL voor het toetsenblok

> 🌙 **Nacht 5→6 nov 2026, onderzoek door mh-research (één helper per class). NIET goedgekeurd door Rob, NIET in de
> addon.** Alleen een goedgekeurde tabel komt in `Modules/ForeverBlock_<Class>.lua`.
>
> **Zelf nagekeken in de nacht (GEMETEN):**
> - beginspells staan in Blizzards data met AcquireMethod 2: Shadow Bolt 686, Demon Skin 687 (wago wowf 1.60.1.70790, SkillLineAbility);
> - de concepttabel hieronder laadt in de échte motor (`Modules/ForeverBlock.lua`, offline met nagebootste spells):
>   elke spellnaam bestaat in SpellName, elke toets is een blok-plek, geen spell op twee toetsen;
> - stance/vorm-nummers: SpellShapeshiftForm.BonusActionBar (Cat 1, Bear 3, Stealth 1, Battle 1, Defensive 2,
>   Berserker 3, Moonkin/Shadowform/Ghost Wolf 0).
> - Niet in het spel getest. Elke toetskeuze is een voorstel (AFGELEID).
> - Voor alle classes geldt (helpers, GEMETEN in de data): een account-perk 'Talented' geeft al talentpunten vanaf
>   level 5-9, dus talent-levels hieronder kunnen tot 5 levels vroeger zijn.

**Aandachtspunten van de nachtcontrole:**
- E (onderbreken) blijft leeg: de Warlock heeft zelf geen interrupt (Spell Lock is van de Felhunter, een pet-spell).

---

# WoW Forever Warlock: spells 1-60, states, key-block proposal (client 1.60.1.70790)

Researched night of 5-6 Nov 2026. Read only: nothing in the repo was changed. Draft for Rob's review.
I did NOT open anything under `MidnightHelper/docs/` (my standing rule). I used the scratchpad copy of the Druid spell
list (`scratchpad/forever_druid_spells.md`) and the code (`Modules/ForeverBlock.lua`, `ForeverBlock_Druid.lua`,
`KeyBlock.lua`) as the example instead of `docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md`.

## Sources
- **DB2** = wago.tools, product `wowf`, build **1.60.1.70790** (the caller's offline copy in `scratchpad/wago_wowf/`,
  fetched 5 Nov 2026 ~23:25, see its README). Tables: SkillLineAbility (SkillLine 355 Affliction, 354 Demonology,
  593 Destruction, pet lines 188/189/204/205/206/207/2887, racial lines 754/125/220/753/733/2980), SpellName, Spell,
  SpellLevels, SpellMisc (passive bit 0x40, hidden bit 0x80), SpellShapeshift, SpellShapeshiftForm, SpellEffect
  (teach spells = Effect 36), SpellCooldowns, Trait* tables.
- Extra DB2 I fetched myself with curl (night 5-6 Nov, HTTP 200 each): `SkillLineXTraitTree`, `ChrRaces`,
  `CharBaseInfo` (build 70790); `SkillLineAbility` + `SpellLevels` for build **1.60.1.70707** (churn check);
  `SkillLineAbility` + `SpellName` + `SpellLevels` for **Classic Era 1.15.9.70576** (what Forever changed).
- **Zygor** = `_forever_\Interface\AddOns\ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua`, WARLOCK block
  (lines 1043-1251; file date 5 Nov 2026 18:56) and the leveling guides in `Guides-Forever\Leveling\`.
- **Blizzard UI source**, github.com/Gethe/wow-ui-source branch `forever`:
  `Interface/AddOns/Blizzard_ActionBarController/ActionBarController.lua` (fetched night 5-6 Nov 2026).
- **EllesmereUI** `_forever_\Interface\AddOns\EllesmereUIActionBars\EUI_ActionBars_Paging.lua` (file date 5 Nov 2026 19:37).
- **Conquest Capped**, "WoW Forever Warlock overview", page says "Updated 05 Nov 2026" (read through WebFetch, so
  through a summary model: I treat it as a second opinion, never as the only source for an ID or a level).
- **MH code**: `Modules/KeyBlock.lua` lines 22-59 (BLOCK) and 78-115 (anchors, overflow order),
  `Modules/ForeverBlock.lua` header (table format), `Modules/ForeverBlock_Druid.lua` (approved example).
- Wowhead Forever (`/forever/spells/abilities/warlock`) answered **HTTP 403** to curl. Not used. I did not open a browser for it.

## Positive control: PASSES (GEMETEN, DB2 70790)
- Level-1 starting spells (SkillLineAbility AcquireMethod 2): **Shadow Bolt Rank 1 (686)**, Destruction tab, and
  **Demon Skin Rank 1 (687)**, Demonology tab. Both also unchanged vs Classic Era 1.15.9 (my diff lists no
  name/level/AcquireMethod change for them).
- Also level 1, not starting: **Immolate Rank 1 (348)** = trainer (Zygor level-1 list: `{348,10, rank=1}`), and
  **Summon Imp (688)** = class quest (Zygor guide: turn in *The Stolen Tome* 1598 (A) / *Piercing the Veil* 1470 (H),
  next step "Summon Your Imp").
- Spec: ChrSpecialization **1490 "Warlock"**, ClassID 9 (one spec per class). Talent tree: SkillLine 354 ->
  SkillLineXTraitTree 164 -> **TraitTree 1116**.
- Not measured in Rob's client: Rob has no Warlock measured (that I know of). The first in-game check is a level-1
  Warlock's spellbook: Shadow Bolt, Demon Skin (+ Immolate after the trainer).

## Spell list (active spells only; 172 rows)
Legend: Level with `*` = talent; the number is the earliest level its row opens (AFGELEID, see "Talent tree").
Form = "none" for every row: only 3 Warlock spells have a SpellShapeshift row at all; the two with a value are
Metamorphosis 403789 (AcquireMethod 3, not learnable) and Soul Link 19028 (only an "excluded in form 22" bit). No
Warlock spell has a "needs form" mask (GEMETEN). "GEMETEN (DB2)" covers ID, rank, level and tab;
"+ Zygor" means Zygor's trainer list has the same ID at the same level.

| Spell | Rank | ID | Level | How learned | Tab | Form | Measured? |
|---|---|---|---|---|---|---|---|
| Demon Skin | Rank 1 | 687 | 1 | starting spell (DB2 AcquireMethod 2) | Demonology | none | GEMETEN (DB2) |
| Immolate | Rank 1 | 348 | 1 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 1 | 686 | 1 | starting spell (DB2 AcquireMethod 2) | Destruction | none | GEMETEN (DB2) |
| Summon Imp | Summon | 688 | 1 | class quest (Zygor guide: turn in The Stolen Tome 1598 (A) / Piercing the Veil 1470 (H), then 'Summon Your Imp') | Demonology | none | GEMETEN (DB2) |
| Corruption | Rank 1 | 172 | 4 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Curse of Weakness | Rank 1 | 702 | 4 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 1 | 1454 | 6 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 2 | 695 | 6 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 1 | 980 | 8 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Fear | Rank 1 | 5782 | 8 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Create Healthstone | Rank 1 | 6201 | 10 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Demon Skin | Rank 2 | 696 | 10 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Drain Soul | Rank 1 | 1120 | 10 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 2 | 707 | 10 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Summon Voidwalker | Summon | 697 | 10 | class quest at 10 (Conquest Capped 5 Nov; DB2 teach spells 1385/11520) | Demonology | none | GEMETEN (DB2) |
| Curse of Weakness | Rank 2 | 1108 | 12 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 1 | 755 | 12 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 3 | 705 | 12 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 2 | 6222 | 14 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Curse of Recklessness | Rank 1 | 704 | 14 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 1 | 689 | 14 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 2 | 1455 | 16 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Unending Breath | - | 5697 | 16 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 2 | 1014 | 18 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Create Soulstone | Rank 1 | 693 | 18 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Searing Pain | Rank 1 | 5676 | 18 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Amplify Curse | - | 18288 | 20* | TALENT (Affliction section, row 3) | Affliction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says None |
| Curse of the Elements | Rank 1 | 440892 | 20 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Demon Armor | Rank 1 | 706 | 20 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Demonic Sacrifice | - | 18788 | 20* | TALENT (Demonology section, row 3) | Demonology | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says None |
| Health Funnel | Rank 2 | 3698 | 20 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 3 | 1094 | 20 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Rain of Fire | Rank 1 | 5740 | 20 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Ritual of Summoning | - | 698 | 20 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 4 | 1088 | 20 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Shadowburn | Rank 1 | 17877 | 20* | TALENT (Destruction section, row 3) | Destruction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule) |
| Summon Incubus | Summon | 713 | 20 | level 20, alternative to Succubus (Conquest Capped 5 Nov); DB2 teach spell 366815; which quest/trainer NOT measured | Demonology | none | GEMETEN (DB2) |
| Summon Succubus | Summon | 712 | 20 | class quest at 20 (Conquest Capped 5 Nov; DB2 teach spells 1403/11519) | Demonology | none | GEMETEN (DB2) |
| Create Healthstone | Rank 2 | 6202 | 22 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of Weakness | Rank 3 | 6205 | 22 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 2 | 699 | 22 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Eye of Kilrogg | Summon | 126 | 22 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 3 | 6223 | 24 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Mana | Rank 1 | 5138 | 24 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Soul | Rank 2 | 8288 | 24 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Sense Demons | - | 5500 | 24 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadowburn | Rank 2 | 18867 | 24 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Conflagrate | Rank 1 | 1293817 | 25* | TALENT (Destruction section, row 4) | Destruction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule) |
| Curse of Exhaustion | - | 18223 | 25* | TALENT (Affliction section, row 4) | Affliction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says None |
| Fel Domination | - | 18708 | 25* | TALENT (Demonology section, row 4) | Demonology | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says None |
| Curse of Tongues | Rank 1 | 1714 | 26 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Detect Invisibility | Rank 1 | 132 | 26 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 3 | 1456 | 26 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Searing Pain | Rank 2 | 17919 | 26 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 3 | 6217 | 28 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Banish | Rank 1 | 710 | 28 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Create Firestone | Rank 1 | 6366 | 28 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of Recklessness | Rank 2 | 7658 | 28 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 3 | 3699 | 28 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 5 | 1106 | 28 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Havoc | - | 1225228 | 30* | TALENT (Destruction section, row 5) | Destruction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says 1 |
| Create Soulstone | Rank 2 | 20752 | 30 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of the Elements | Rank 2 | 1311676 | 30 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Demon Armor | Rank 2 | 1086 | 30 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 3 | 709 | 30 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Hellfire | Rank 1 | 1949 | 30 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 4 | 2941 | 30 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Siphon Life | Rank 1 | 18265 | 30* | TALENT (Affliction section, row 5) | Affliction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule) |
| Soul Link | - | 19028 | 30* | TALENT (Demonology section, row 5) | Demonology | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule); DB2 SpellLevels says 1 |
| Subjugate Demon | Rank 1 | 1098 | 30 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Summon Felhunter | Summon | 691 | 30 | class quest at 30 (Conquest Capped 5 Nov; DB2 teach spells 1373/8717) | Demonology | none | GEMETEN (DB2) |
| Conflagrate | Rank 2 | 1293818 | 32 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Curse of Weakness | Rank 4 | 7646 | 32 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Fear | Rank 2 | 6213 | 32 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Shadow Ward | Rank 1 | 6229 | 32 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadowburn | Rank 3 | 18868 | 32 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 4 | 7648 | 34 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Create Healthstone | Rank 3 | 5699 | 34 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Drain Mana | Rank 2 | 6226 | 34 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Rain of Fire | Rank 2 | 6219 | 34 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Searing Pain | Rank 3 | 17920 | 34 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Create Firestone | Rank 2 | 17951 | 36 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Create Spellstone | Rank 1 | 2362 | 36 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 4 | 3700 | 36 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 4 | 11687 | 36 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 6 | 7641 | 36 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 4 | 11711 | 38 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Detect Invisibility | Rank 2 | 2970 | 38 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 4 | 7651 | 38 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Soul | Rank 3 | 8289 | 38 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Siphon Life | Rank 2 | 18879 | 38 | trainer (Zygor), needs the talent | Affliction | none | GEMETEN (DB2 + Zygor) |
| Conflagrate | Rank 3 | 17962 | 40 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Create Soulstone | Rank 3 | 20755 | 40 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of the Elements | Rank 3 | 1311677 | 40 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Demon Armor | Rank 3 | 11733 | 40 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Howl of Terror | Rank 1 | 5484 | 40 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 5 | 11665 | 40 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Incinerate | Rank 1 | 412758 | 40* | TALENT (Destruction section, row 7) | Destruction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule) |
| Shadowburn | Rank 4 | 18869 | 40 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Wrack | Rank 1 | 1316697 | 40* | TALENT (Affliction section, row 7) | Affliction | none | GEMETEN (DB2 tree 1116); level AFGELEID (row rule) |
| Curse of Recklessness | Rank 3 | 7659 | 42 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Curse of Weakness | Rank 5 | 11707 | 42 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Death Coil | Rank 1 | 6789 | 42 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Hellfire | Rank 2 | 11683 | 42 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Searing Pain | Rank 4 | 17921 | 42 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Shadow Ward | Rank 2 | 11739 | 42 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 5 | 11671 | 44 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Mana | Rank 3 | 11703 | 44 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 5 | 11693 | 44 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 7 | 11659 | 44 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Subjugate Demon | Rank 2 | 11725 | 44 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Create Firestone | Rank 3 | 17952 | 46 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Create Healthstone | Rank 4 | 11729 | 46 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 5 | 11699 | 46 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 5 | 11688 | 46 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Rain of Fire | Rank 3 | 11677 | 46 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 5 | 11712 | 48 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Banish | Rank 2 | 18647 | 48 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Conflagrate | Rank 4 | 18930 | 48 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Create Spellstone | Rank 2 | 17727 | 48 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadowburn | Rank 5 | 18870 | 48 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Siphon Life | Rank 3 | 18880 | 48 | trainer (Zygor), needs the talent | Affliction | none | GEMETEN (DB2 + Zygor) |
| Soul Fire | Rank 1 | 6353 | 48 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Create Soulstone | Rank 4 | 20756 | 50 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of Tongues | Rank 2 | 11719 | 50 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Curse of the Elements | Rank 4 | 1311680 | 50 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Death Coil | Rank 2 | 17925 | 50 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Demon Armor | Rank 4 | 11734 | 50 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Detect Invisibility | Rank 3 | 11743 | 50 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 6 | 11667 | 50 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Incinerate | Rank 2 | 1293812 | 50 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Inferno | Summon | 1122 | 50 | quest at 50 (Conquest Capped 5 Nov; Zygor guide: Kroshius' Infernal Core 7603; DB2 teach spells 1413/366430) | Demonology | none | GEMETEN (DB2) |
| Searing Pain | Rank 5 | 17922 | 50 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Curse of Weakness | Rank 6 | 11708 | 52 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Soul | Rank 4 | 11675 | 52 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 6 | 11694 | 52 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 8 | 11660 | 52 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Shadow Ward | Rank 3 | 11740 | 52 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Conflagrate | Rank 5 | 18931 | 54 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 6 | 11672 | 54 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Life | Rank 6 | 11700 | 54 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Drain Mana | Rank 4 | 11704 | 54 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Hellfire | Rank 3 | 11684 | 54 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Howl of Terror | Rank 2 | 17928 | 54 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Create Firestone | Rank 4 | 17953 | 56 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Curse of Recklessness | Rank 4 | 11717 | 56 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Fear | Rank 3 | 6215 | 56 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Life Tap | Rank 6 | 11689 | 56 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Shadowburn | Rank 6 | 18871 | 56 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Soul Fire | Rank 2 | 17924 | 56 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Bane of Agony | Rank 6 | 11713 | 58 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Create Healthstone | Rank 5 | 11730 | 58 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Death Coil | Rank 3 | 17926 | 58 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Rain of Fire | Rank 4 | 11678 | 58 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Searing Pain | Rank 6 | 17923 | 58 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Siphon Life | Rank 4 | 18881 | 58 | trainer (Zygor), needs the talent | Affliction | none | GEMETEN (DB2 + Zygor) |
| Subjugate Demon | Rank 3 | 11726 | 58 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Bane of Doom | - | 603 | 60 | trainer (Zygor) | Affliction | none | GEMETEN (DB2 + Zygor) |
| Conflagrate | Rank 6 | 18932 | 60 | trainer (Zygor), needs the talent | Destruction | none | GEMETEN (DB2 + Zygor) |
| Corruption | Rank 7 | 25311 | 60 | not at a trainer (not in Zygor's list); source NOT measured (probably a book, AFGELEID) | Affliction | none | GEMETEN (DB2) |
| Create Soulstone | Rank 5 | 20757 | 60 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Create Spellstone | Rank 3 | 17728 | 60 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Demon Armor | Rank 5 | 11735 | 60 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Health Funnel | Rank 7 | 11695 | 60 | trainer (Zygor) | Demonology | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 7 | 11668 | 60 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Immolate | Rank 8 | 25309 | 60 | not at a trainer (not in Zygor's list); source NOT measured (probably a book, AFGELEID) | Destruction | none | GEMETEN (DB2) |
| Incinerate | Rank 3 | 1293813 | 60 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Portal of Summoning | - | 437169 | 60 | NOT in Zygor's trainer list, no teach spell found: source NOT measured | Demonology | none | GEMETEN (DB2) |
| Ritual of Doom | - | 18540 | 60 | quest at 60 (Conquest Capped 5 Nov: Doomguard via Ritual of Doom; DB2 teach spell 20700); quest name NOT measured | Demonology | none | GEMETEN (DB2) |
| Shadow Bolt | Rank 9 | 11661 | 60 | trainer (Zygor) | Destruction | none | GEMETEN (DB2 + Zygor) |
| Shadow Bolt | Rank 10 | 25307 | 60 | not at a trainer (not in Zygor's list); source NOT measured (probably a book, AFGELEID) | Destruction | none | GEMETEN (DB2) |
| Shadow Ward | Rank 4 | 28610 | 60 | NOT in Zygor's trainer list; source NOT measured | Demonology | none | GEMETEN (DB2) |

Notes on the table:
- "trainer (Zygor)" = the ID is in Zygor's Forever trainer list at that level. Zygor marks talent ranks with
  `talent=`; those rows say "needs the talent". Zygor's Warlock list matches DB2 70790 one-for-one (all 147 Zygor IDs
  are Warlock spells in DB2, same levels; GEMETEN).
- Summons: the quest names for Voidwalker/Succubus/Felhunter are in Zygor's guides (*The Binding* 1689 and 1739,
  *Tome of the Cabal* 1758 on the Alliance side), but which quest gives which spell is AFGELEID from the guide order
  plus the DB2 "Teach Summon ..." spells. Conquest Capped (5 Nov) says the same: class quests at 10, 20, 30.
- Rows left out on purpose: passive spells (SpellMisc bit 0x40), hidden spells (bit 0x80: *Metamorphosis : Demon
  Charge* 412783, *Bane of Doom Effect* 18662), effect spells with no description (*Pyroclasm* 18093, four *Master
  Demonologist* auras 23759-23762), and every AcquireMethod-3 spell (list below).

### Racials (GEMETEN, DB2 SkillLineAbility + CharBaseInfo)
Races that can be a Warlock in Forever (CharBaseInfo ClassID 9): **Human, Orc, Undead, Gnome, Troll**.
**Skyborne cannot** (High Order Skyborne 95 = Warrior/Hunter/Rogue/Mage/Druid; Windshaper Skyborne 96 =
Warrior/Hunter/Rogue/Shaman/Druid). Troll Warlock is new vs Classic Era (CharBaseInfo row 920; AFGELEID that it is new,
I did not diff CharBaseInfo against Era).

| Race | Active racial | ID | Cooldown (DB2) | Note |
|---|---|---|---|---|
| Human | Perception | 20600 | 3 min | stealth detection |
| Human | Will to Survive | 1259718 | 3 min | NEW: removes all stuns |
| Orc | Blood Fury | 20572 | 2 min | attack power + spell power |
| Orc | Shatter Curse | 1299026 | 3 min | NEW: removes Curses and Banes, less magic damage taken |
| Undead | Will of the Forsaken | 7744 | 2 min | removes charm/fear/sleep |
| Undead | Cannibalize | 20577 | 2 min | eat a corpse |
| Gnome | Escape Artist | 20589 | 2 min | removes movement impairment |
| Gnome | Eureka! | 1259821 | 2 min | NEW, Warlock version (ClassMask 256): cheaper, stronger non-periodic spells |
| Troll | Berserking | 20554 | 3 min | haste |
| Troll | Rapid Regeneration | 1260270 | 3 min | NEW: heal over time, cancels on any action; no "Racial" subtext in DB2 |

### Talent tree (GEMETEN: TraitTree 1116, 52 nodes, 3 sections)
- 51 points: TraitCurrency 3820 SourcedMax 51, and TraitCurrencySource has one point per level, "Level 10" to
  "Level 60" (GEMETEN). So you have k points at level 9+k.
- Row gates count points **in the same section only** (GEMETEN: each gate TraitCond has TraitNodeGroupID = that
  section's group, e.g. Wrack's cond 43497 counts group 11629 = the 17 Affliction nodes). Row r needs 5*(r-1) points
  spent above it, so row 3 opens at 20, row 4 at 25, row 5 at 30, row 7 at 40 (AFGELEID; DB2 SpellLevels agrees for
  Shadowburn 20, Conflagrate 25, Siphon Life 30, Wrack 40, Incinerate 40).
- The 11 active talent spells (all others are passive):
  - Affliction: Amplify Curse 18288 (row 3), Curse of Exhaustion 18223 (row 4, needs Amplify Curse),
    Siphon Life 18265 (row 5), Wrack 1316697 (row 7, needs Siphon Life).
  - Demonology: Demonic Sacrifice 18788 (row 3), Fel Domination 18708 (row 4, needs Master Summoner),
    Soul Link 19028 (row 5, needs Demonic Sacrifice).
  - Destruction: Shadowburn 17877 (row 3), Conflagrate 1293817 (row 4), Bane of Havoc 1225228 (row 5),
    Incinerate 412758 (row 7, needs Bane of Havoc).
- **Wrack and Incinerate can never both be known** (AFGELEID, arithmetic on GEMETEN data): each needs 31 points in its
  own section, 62 > 51. Wrack also excludes Soul Link and Bane of Havoc (31 + 21 > 51); Incinerate also excludes
  Siphon Life and Soul Link. The draft uses this: Wrack and Incinerate share one key.

### In the data but NOT learnable (AcquireMethod 3, GEMETEN)
Metamorphosis 403789 (Shapeshift), Chaos Bolt 403629, Shadow Cleave 403835-403852 (10 ranks), Fel Armor 403619,
Menace, Demon Charge, Demonic Howl, Metamorphosis : Demonic Howl, Vengeance, Grimoire of Synergy, Shadowflame (2),
Invocation (5), Demonic Grace, a second Drain Life line 403677-403689 (6 ranks, Demonology tab), Curse of Idiocy 1010,
Hellfire Effect (3), Ritual of Doom Effect. These look like Season of Discovery rune spells (AFGELEID). The
`Engraving` skill line 2851 still exists in DB2 with 352 rows, including "Engrave Gloves - Metamorphosis" 403938
(GEMETEN). Whether runes can be used in Forever is NOT measured. Against it (AFGELEID): Incinerate 412758 went from
AcquireMethod 3 in Era to a Forever talent, and other rune effects (Pandemic, Decimation, Demonic Pact, Soul Harvest)
are now talent nodes.

### What Forever changed vs Classic Era 1.15.9.70576 (GEMETEN by my DB2 diff unless marked)
- Renamed: Curse of Agony -> **Bane of Agony** (980 etc.), Curse of Doom -> **Bane of Doom** (603). Conquest Capped:
  one Bane and one Curse can sit on the same target.
- **Stone and Detect spells now share one name per family**: "Create Healthstone (Minor/Lesser/Greater/Major)" ->
  "Create Healthstone" Rank 1-5; same for Create Soulstone, Create Spellstone, Create Firestone, and
  Detect Lesser/Greater Invisibility -> "Detect Invisibility". So `/cast Create Healthstone` gets the highest rank
  (rule 2 works for them now; it would not have in Era).
- **Removed from the client**: Curse of Shadow (17862, 17937) and Dark Pact (18220, 18937, 18938) are not in
  SpellName any more. Conquest Capped: Curse of Shadows was removed because Curse of the Elements now covers Shadow.
- **Curse of the Elements**: new IDs 440892 / 1311676 / 1311677 / 1311680 at 20/30/40/50 (Era: 1490/11721/11722 at 32/46/60).
- **New**: Bane of Havoc (talent), Wrack (talent), Conflagrate Rank 1 (1293817, talent at 25) and Rank 2 (1293818, 32;
  the old 17962 is now Rank 3 at 40), Incinerate as a talent (412758) with trainer ranks 1293812 (50) and 1293813 (60).
- **Summon Incubus** 713 at level 20 (Conquest Capped: an alternative to the Succubus).
- **Portal of Summoning** 437169 moved to level 60 (Era SpellLevels said 1).
- **Summon Felsteed / Summon Dreadsteed** moved from the Demonology tab to the Mounts skill line (777). Zygor's guide
  has the *Summon Felsteed* quests 4487/4488/4490 and *Dreadsteed of Xoroth* 7631.
- Racials: Will to Survive, Shatter Curse, Eureka! and Rapid Regeneration are new (not checked against Era, AFGELEID).

### Build churn: none (GEMETEN)
SkillLineAbility + SpellLevels for the three Warlock lines are identical in 70707 (30 Oct) and 70790 (388 rows each).
Positive control in the same script: on the Druid lines it finds the known 70707 -> 70790 changes (Ferocious Bite
1328618 added, Lacerate 1328617 added, Primal Bite Rank 4 removed). So Zygor's data is safe to use for the Warlock.

### Demon pet abilities (not on the block, for reference; GEMETEN DB2)
Imp: Firebolt, Blood Pact, Fire Shield, Phase Shift. Voidwalker: Torment (taunt), Suffering (area taunt), Sacrifice
(shield), Consume Shadows. Succubus/Incubus: Lash of Pain, Soothing Kiss, Seduction (humanoid CC), Lesser
Invisibility. Felhunter: **Spell Lock** (silence/counterspell, 30 s; from 36), **Devour Magic** (dispel/purge; from 30),
Tainted Blood, Paranoia. Infernal and Doomguard lines hold only passives.

## States + conditions
**The Warlock has no state at all.** GEMETEN:
- No Warlock spell needs a form (SpellShapeshift: only 3 rows, no "needs form" mask).
- SpellShapeshiftForm: the only Warlock form is 22 "Metamorphosis", and its **BonusActionBar is 0** (so even if it
  were learnable it would not page the bar). Metamorphosis 403789 is AcquireMethod 3 (never learned).
- Blizzard's `ActionBarController.lua` (forever branch) pages the main bar only through
  `C_ActionBar.HasBonusActionBar()` / `GetBonusBarIndex()` (plus vehicle/override/possess/temp-shapeshift), i.e. only
  from a form's BonusActionBar. For reference, the forms that do page (BonusActionBar > 0): Cat 1, Stealth 1,
  Battle 1, Defensive 2, Berserker 3, Bear 3, Dire Bear 3. Moonkin Form is 0.
- EllesmereUI's Forever paging has no Warlock entry (`CLASS_DEFAULTS` = DRUID and ROGUE only); for every class it adds
  the generic `[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10`, which never fires for a Warlock
  (AFGELEID from the BonusActionBar values above).
So `states = {}` and no `baseGuard`. Every key is one plain `/cast` (or a "first known wins" list).
Possible macro conditions that are NOT states (AFGELEID, not tested): `[pet:Felhunter]` etc. for pet spells, and
`[combat]` pairs. The draft uses neither.

## Proposal per key
The block's fixed jobs come from `KeyBlock.lua` (GEMETEN). Which Warlock spell gets which job is my judgment
(AFGELEID). Level = earliest level the key has something; `*` = talent (row rule).
"Option B" is the draft: Ctrl-1/2/3 used as "extra" (the task name is "form N / extra", and KeyBlock's own overflow
order starts with CTRL-1..3), summons go to block D. Option A (summons on Ctrl) is in the open questions.

| Key | Task | Spell (no states, so one column) | From level | Why / judgment |
|---|---|---|---|---|
| 1 | main button | Shadow Bolt | 1 | starting spell, the filler |
| 2 | rotation | Corruption | 4 | DoT |
| 3 | rotation | Immolate | 1 | DoT + hit; Conflagrate/Incinerate need it |
| 5 | rotation | Bane of Agony | 8 | the Bane DoT |
| 4 | spender | Drain Soul | 10 | the Warlock's "finisher": kill with it, get a Soul Shard (AFGELEID: no real spender exists before 20) |
| Shift-4 | 2nd spender | Shadowburn* | 20* | execute that costs a shard (talent, Destruction row 3) |
| Shift-1 | AoE | Rain of Fire | 20 | |
| Shift-2 | AoE | Hellfire | 30 | |
| Q | big cooldown | Soul Fire | 48 | 60 s category cooldown (DB2), biggest nuke |
| F1 | cooldown 2 | Bane of Doom | 60 | 60 s cooldown, bosses only ("cannot be cast on players") |
| Shift-3 | cooldown 3 | Amplify Curse* | 20* | 3 min (talent, Affliction row 3) |
| F3 | cooldown 4 | Inferno | 50 | 1 h, outdoors only (DB2 text) |
| Shift-F1 | cooldown 2, second | Fel Domination* | 25* | 5 min, fast re-summon (talent, Demonology row 4) |
| E | interrupt | (empty) | - | the Warlock has no interrupt of its own; Spell Lock is the Felhunter's (pet spell, see questions) |
| R | movement | Curse of Exhaustion* | 25* | no self-movement spell exists; this is the kiting tool (talent, Affliction row 4) |
| Shift-R | movement 2 | Unending Breath | 16 | water utility, like Druid's Aquatic Form on R (weak fit, AFGELEID) |
| F | taunt / help | Life Tap | 6 | no taunt; the most-pressed utility (health -> mana) |
| Z | small defensive | Shadow Ward | 32 | 30 s, absorbs Shadow damage |
| X | defensive 2 | Death Coil | 42 | 2 min, horror + heal (also CC) |
| C | big heal | Drain Life | 14 | the Warlock's own big heal |
| F2 | quick heal | Health Funnel | 12 | heals the demon (the only "heal" spell besides drains) |
| F4 | heal over time | Siphon Life* | 30* | DoT that heals you (talent, Affliction row 5) |
| V | CC | Fear | 8 | |
| Shift-Q | CC | Banish | 28 | demons and elementals only |
| Shift-F | CC | Howl of Terror | 40 | area fear, 40 s |
| Shift-V | CC / dispel | Curse of Weakness, from 20 Curse of the Elements | 4 / 20 | no dispel of its own; "your curse" slot (list: Elements wins once learned) |
| Shift-Z | small def., second | Demon Skin, from 20 Demon Armor | 1 / 20 | self armor buff (Druid had Thorns here) |
| Shift-X | defensive 2, second | Soul Link* | 30* | damage shared with the demon (talent, Demonology row 5) |
| Shift-C | big def., second | Demonic Sacrifice* | 20* | sacrifice the demon for a buff (talent, Demonology row 3) |
| Shift-E | racial | Will to Survive / Blood Fury / Will of the Forsaken / Escape Artist / Berserking | 1 | one per race; the other racial goes to block D |
| Ctrl-1 | form 1 / extra | Conflagrate* | 25* | uses up Immolate, 10 s (talent, Destruction row 4) |
| Ctrl-2 | form 2 / extra | Wrack* or Incinerate* | 40* | never both (see Talent tree); first known wins |
| Ctrl-3 | form 3 / extra | Bane of Havoc* | 30* | two-target Bane (talent, Destruction row 5) |
| T / Shift-T / G | fixed | potion / Healthstone / trinket | - | not spells (KeyBlock fixed) |

All four rules: rule 1 holds trivially (no states). Rule 2: every entry is a name, and the stone names are now one
name per family (see "changed"). Rule 3: an unknown spell leaves its key empty (engine behaviour). Rule 4: all 11 talent
actives have a fixed key (Wrack/Incinerate share one that can only ever hold one of them).

**Block D (toBlockD, 12 places)**, in this order: Summon Imp, Summon Voidwalker, Summon Succubus, Summon Incubus,
Summon Felhunter, Create Healthstone, Create Soulstone, Searing Pain, Curse of Recklessness, Curse of Tongues,
Ritual of Summoning, and the race's second racial (Perception / Shatter Curse / Cannibalize / Eureka! / Rapid
Regeneration). At level 60 that is exactly 12 known spells (11 if Incubus and Succubus are not both learned).
**Not placed, but counted as handled (`listed`)**, for the player's own bars: Shoot (wand; Wands skill line,
ClassMask includes Warlock, GEMETEN), Create Spellstone, Create Firestone, Drain Mana, Subjugate Demon, Eye of Kilrogg,
Sense Demons, Detect Invisibility, Ritual of Doom, Portal of Summoning. Curse of Weakness has no place after 20 (Elements
takes Shift-V). Mounts (Summon Felsteed/Dreadsteed) are left out: they are on the Mounts skill line, and the engine's
`Known()` asks the spellbook (AFGELEID that a mount fails that check; not tested).

## Draft Lua table (for review; NOT in the repo)
```lua
ns.FOREVER_BLOCK_CLASSES.WARLOCK = {
	-- No forms, stances or stealth (GEMETEN, see the research file): no bar paging, so no states and no base guard.
	states = {},
	baseGuard = nil,
	keys = {
		["1"] = { base = "Shadow Bolt" },
		["2"] = { base = "Corruption" },
		["3"] = { base = "Immolate" },
		["4"] = { base = "Drain Soul" },
		["SHIFT-4"] = { base = "Shadowburn" },
		["5"] = { base = "Bane of Agony" },
		["SHIFT-1"] = { base = "Rain of Fire" },
		["SHIFT-2"] = { base = "Hellfire" },
		["Q"] = { base = "Soul Fire" },
		["F1"] = { base = "Bane of Doom" },
		["SHIFT-3"] = { base = "Amplify Curse" },
		["F3"] = { base = "Inferno" },
		["SHIFT-F1"] = { base = "Fel Domination" },
		-- E stays empty on purpose: no interrupt of its own (Spell Lock belongs to the Felhunter).
		["R"] = { base = "Curse of Exhaustion" },
		["SHIFT-R"] = { base = "Unending Breath" },
		["F"] = { base = "Life Tap" },
		["Z"] = { base = "Shadow Ward" },
		["X"] = { base = "Death Coil" },
		["C"] = { base = "Drain Life" },
		["F2"] = { base = "Health Funnel" },
		["F4"] = { base = "Siphon Life" },
		["V"] = { base = "Fear" },
		["SHIFT-Q"] = { base = "Banish" },
		["SHIFT-F"] = { base = "Howl of Terror" },
		["SHIFT-V"] = { base = { "Curse of the Elements", "Curse of Weakness" } },
		["SHIFT-Z"] = { base = { "Demon Armor", "Demon Skin" } },
		["SHIFT-X"] = { base = "Soul Link" },
		["SHIFT-C"] = { base = "Demonic Sacrifice" },
		["SHIFT-E"] = { base = { "Will to Survive", "Blood Fury", "Will of the Forsaken", "Escape Artist", "Berserking" } },
		["CTRL-1"] = { base = "Conflagrate" },
		-- Wrack (31 Affliction points) and Incinerate (31 Destruction points) can never both be known (51 points).
		["CTRL-2"] = { base = { "Wrack", "Incinerate" } },
		["CTRL-3"] = { base = "Bane of Havoc" },
	},
	toBlockD = { "Summon Imp", "Summon Voidwalker", "Summon Succubus", "Summon Incubus", "Summon Felhunter",
		"Create Healthstone", "Create Soulstone", "Searing Pain", "Curse of Recklessness", "Curse of Tongues",
		"Ritual of Summoning", "Perception", "Shatter Curse", "Cannibalize", "Eureka!", "Rapid Regeneration" },
	listed = { "Shoot", "Create Spellstone", "Create Firestone", "Drain Mana", "Subjugate Demon", "Eye of Kilrogg",
		"Sense Demons", "Detect Invisibility", "Ritual of Doom", "Portal of Summoning" },
}
```
Every name above is exactly as in SpellName.csv 70790 (checked: all are in the active spell list or racial table
above, including "Eureka!" with the "!"). With no states, `base` and `all` give the same macro; I used `base`.
`baseGuard = nil` is the same as leaving the field out.

**Checks on the draft (GEMETEN, offline, night 5-6 Nov):**
- `luac -p` passes (control: a file with a missing `}` is rejected).
- A name check finds all 65 names in SpellName 70790 and in the active-spell/racial lists (control: an invented name
  is reported).
- Run through the real `Modules/ForeverBlock.lua` with stubbed APIs (`warlock_work/test_warlock.lua`, same method as
  the Druid test): a level-1 Human gets 4 macros (1 Shadow Bolt, 3 Immolate, Shift-Z Demon Skin, Shift-E Will to
  Survive) and block D = Summon Imp, Perception; a level-60 Destruction Orc gets 26 macros (Ctrl-2 = Incinerate,
  Shift-V = Curse of the Elements, Shift-Z = Demon Armor) and 11 block D spells; a level-40 Affliction Undead gets
  Ctrl-2 = Wrack, F4 = Siphon Life, R = Curse of Exhaustion, Shift-3 = Amplify Curse. The "not in MH's list" line
  reports only the invented "Mystery Spell" (Attack, Shoot, racials and starting spells count as handled).
  The stubs say nothing about the real client: Rob's `/reload` on a Warlock is the real test.

## Open questions for Rob
1. **E (interrupt) and the pet.** The Warlock's only interrupt is the Felhunter's Spell Lock (from 36). Leave E empty
   (draft), or put `/cast Spell Lock` there? Not tested: whether a macro can cast a pet spell in Forever, and whether the
   engine's `Known()` finds pet spells (it checks the spellbook). Same idea would fit Devour Magic on Shift-V (dispel),
   Seduction (CC) and Torment on F (taunt).
2. **Ctrl-1/2/3: demons or extra?** Option B (draft): Conflagrate / Wrack-or-Incinerate / Bane of Havoc, summons on
   block D. Option A: Ctrl-1 Imp, Ctrl-2 Voidwalker, Ctrl-3 Felhunter (or Succubus), "the demon is the Warlock's
   stance". Option A has no room for three talent spells (breaks rule 4) unless Inferno, Banish and another spell move
   off the block. Downside of B: at level 1-9 Summon Imp sits on block D, not on the block.
3. **Which curse on Shift-V?** Draft: Curse of the Elements once learned, Curse of Weakness before that. Groups often
   want Recklessness (melee) or Tongues (casters) instead. A per-character choice would follow "players choose, not us".
4. **4 = Drain Soul or Conflagrate?** Draft puts Drain Soul (every Warlock from 10) on 4 and Conflagrate on Ctrl-1.
   The other way round makes 4 a true "spender" but leaves 4 empty for non-Destruction Warlocks.
5. **Racial per race on Shift-E**: Human Will to Survive (stun break) or Perception? Gnome Escape Artist or Eureka!
   (damage cooldown)? The other one goes to block D.
6. **Shift-T for a Warlock**: the fixed Healthstone place could cast Create Healthstone out of combat. That is a
   KeyBlock change, not part of this table.
7. **Succubus and Incubus**: both on block D. Can one character learn both? Not measured.
8. **Mounts** (Felsteed 40, Dreadsteed 60): leave to MH's mount features (draft), or try them on R/Shift-R?
9. Not measured: how Portal of Summoning (60) is learned; Shadow Ward Rank 4 (28610) and the rank-60 Shadow Bolt X /
   Immolate VIII / Corruption VII are not in Zygor's trainer list.

## What is GEMETEN vs AFGELEID
GEMETEN (named, dated source above):
- Every ID, rank, level and tab in the spell table (DB2 70790); trainer levels where marked "+ Zygor".
- Starting spells Shadow Bolt R1 and Demon Skin R1 (AcquireMethod 2); Immolate R1 at the level-1 trainer (Zygor).
- Warlock races: Human, Orc, Undead, Gnome, Troll; Skyborne cannot be a Warlock (CharBaseInfo 70790).
- Racial spells and cooldowns; talent tree 1116, its 11 active spells, prerequisites, per-section gates, 51 points,
  one point per level 10-60.
- No Warlock spell needs a form; Metamorphosis is AcquireMethod 3 and form 22 has BonusActionBar 0; Blizzard's paging
  only uses the bonus bar; EllesmereUI has no Warlock paging.
- Changes vs Classic Era 1.15.9.70576 (my DB2 diff): Banes, one-name stones, removed Curse of Shadow and Dark Pact, new
  Curse of the Elements ranks, new talents and ranks, Felsteed/Dreadsteed moved to Mounts.
- No churn between 70707 and 70790 for the Warlock (with a positive control on the Druid lines).
- Cooldowns and spell texts quoted in the proposal (SpellCooldowns, Spell descriptions).
AFGELEID (reasoned):
- Talent levels from the row rule (20/25/30/40); DB2 SpellLevels agrees for 5 of the 11.
- That Wrack and Incinerate can never both be known (arithmetic on the gate data).
- Which quest teaches which summon (guide order + teach spells; Conquest Capped agrees for 10/20/30).
- That AcquireMethod-3 spells and Engraving runes are not usable in Forever.
- That the generic EllesmereUI bonus-bar clause never fires for a Warlock.
- That a mount spell fails the engine's spellbook check.
- Every key choice in the proposal and the order of block D.
NOT measured: anything in Rob's client for a Warlock; Portal of Summoning's source; the rank-60 book spells' source;
whether Succubus and Incubus can both be learned; whether macros can cast pet spells in Forever.
