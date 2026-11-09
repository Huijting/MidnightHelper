# WoW: Forever macros: Mage, Warlock, Priest, Druid

Research date: 9 Nov 2026. Client meant: WoW Forever launch, build 1.60.1.70790 (Interface 16001).
Midnight Helper's own macro code and docs were NOT read (as asked).

**Kort voor Rob (NL):** Macro's werken in Forever zoals in Classic. Er is wel veel veranderd: nieuwe namen (Bane of
Agony, Primal Bite, Subjugate Demon), lage ranks zijn zwakker, en powershiften via Cat Form bestaat bijna niet meer
(een talent doet het nu). Niets hieronder is door mij in de game getest.

## Labels

- **GEMETEN** = I saw it in a named, dated source (URL below). "Seen in a guide" does NOT mean "tested in the client".
  Almost every guide says it has not tested its macros on live servers.
- **AFGELEID** = my own reasoning or my own combination of seen parts.
- **[CLASSIC-RULE]** = depends on a Classic Era rule that no Forever source confirms yet.
- Local addons under `E:\World of Warcraft\_forever_\Interface\AddOns` are used as **candidates only**:
  Zygor's Forever trainer table `ZygorGuidesViewerForever\Data-Forever\Skill_Training.lua` (spell levels) and
  MagePlan `Supplies.lua` (conjured item IDs). Not proof.

All 44 macro texts below were counted with a script: every one is 255 characters or less (longest: 249).

---

## 1. What changed for macros in Forever (read this first)

| # | Fact | Label + source |
|---|------|----------------|
| F1 | Macros, `/cast`, `/castsequence`, `/stopcasting`, `[@mouseover]`, `[help]/[harm]/[nodead]`, `[mod:]`, `[stance:]/[form:]` exist. 255 characters per macro. | GEMETEN: SenseOS, 26 Oct, updated 5 Nov 2026 (S7); RankedBoost hub, updated 7 Nov 2026 (S5) |
| F2 | Focus exists. Blizzard's 15 Oct notes fixed a focus macro (Paladin Light's Vigil). Blizzard's launch-day notes mention "Clear Focus" in the target menu. | GEMETEN: SenseOS (S7); Warcraft Tavern, 4 Nov 2026 (S3) |
| F3 | **Learning a new spell no longer puts it on your bars by itself.** A spell already on a bar does NOT move up to the new rank. `/cast Spell` with no rank always casts the highest rank you know. So rankless macros are the easy fix while levelling. | GEMETEN: Blizzard, Kaivax, "Beta Development Notes – Updated November 2", post #9, 3 Nov 2026 (S1); Kami-labs, 1 Oct 2026 (S10); Wowhead user guide, 20 Oct 2026 (S15) |
| F4 | **Downranking was weakened.** Ranks "vastly below your current level" get less from Spell Damage and Spell Healing. Blizzard published no formula. | GEMETEN: Blizzard 1 Oct 2026 beta notes, mirrored by Wowhead News 1 Oct 2026 (S2) |
| F5 | Proc penalty: on 1 Oct, a Rank 1 Frostbolt at 60 had 0% Frostbite chance. On 2 Nov Blizzard removed the trigger penalty for talents. **Only the spell Blizzard keeps it**: lower chance for Arcane Concentration, Frostbite and Fingers of Frost when cast with a rank learned more than 12 levels below you. | GEMETEN: S2 (1 Oct); S1 (2 Nov, Blizzard forum) |
| F6 | Community measurement (heals, beta, up to level 30 only): a rank keeps its full Spell Healing bonus for about 17 levels after you can learn it. After that it loses about 5% per level, and at about 37 levels it has nothing left. It is **not proven** above level 30 or for damage spells. | GEMETEN as a claim: ForeverWisp 10 Oct 2026 and Wowdee 13 Oct 2026, both citing ForeverChanges (S11); DoubleZug video says 18 levels (S11) |
| F7 | Classic's penalty for spells learned below level 20 is gone from Forever's spell data. So early ranks scale better while you level. | GEMETEN: bindonforever 12 Oct 2026; foreverdb downrank page (S11) |
| F8 | New and renamed spells break old Classic macros: Curse of Agony is now **Bane of Agony**, Curse of Doom is now **Bane of Doom**, Mangle is now **Primal Bite**, Enslave Demon is now **Subjugate Demon**. Curse of Shadow and Dark Pact were removed. | GEMETEN: SenseOS (S7); 60.tools warlock page, 4 Nov 2026 (S6); metabot warlock (S9) |
| F9 | Powershifting for energy is mostly gone. Furor (5 points) lets you regain Energy outside Cat Form as if you were in it, and going into Bear Form loses that Energy. A quick leave-and-return with an empty bar no longer gives the old fixed 40 Energy. The new talent **Shifting Power** gives 40 Energy for a lot of Mana. | GEMETEN: Warcraft Tavern deep dive, 30 Sep 2026 (S4); wow.gg Feral overview, 19 Sep 2026 (S12, early beta) |
| F10 | Every form change still removes movement-slowing effects (snares and roots). | GEMETEN: RankedBoost druid page (S5) |
| F11 | Druid form numbers (`[form:3]` = Cat and so on) are **not confirmed** for Forever. A user guide lists Bear/Dire Bear=1, Aquatic=2, Cat=3, Travel=4, Moonkin=5. Kami-labs warns Cat may be 2. In Classic the number depends on which forms you know. | GEMETEN: Wowhead user guide (S15); SenseOS says "not yet checked" (S7); Kami-labs (S10). **[CLASSIC-RULE]** |
| F12 | The `!` prefix on forms: Kami-labs and 60.tools use `/cast !Cat Form` as "go into Cat, never toggle out". In TBC-era clients `!` would powershift. Which one Forever does is **not confirmed**. | GEMETEN: S10, S6; warcraft.wiki.gg Powershifting (S14). **[CLASSIC-RULE]** |
| F13 | RankedBoost says Alt is kept for self-cast, so none of its macros use Alt. To be safe, the macros below use Shift and Ctrl only. | GEMETEN (claim): S5. Default self-cast key not checked in the client. |

---

## 2. Mage

Levels: the web source is named per line. Zygor's Forever trainer table (candidate) agrees on every level listed here.

**M1. Polymorph on mouseover, then focus, then target** (Polymorph: level 8)
```
#showtooltip Polymorph
/cast [@mouseover,harm,nodead][@focus,harm,nodead][harm,nodead] Polymorph
```
Sheeps the enemy under your mouse. If there is none, it sheeps your focus, and if there is no focus either, your target.
- Mouseover-then-target version: GEMETEN, 60.tools mage page, 4 Nov 2026 (S6). Focus clause: AFGELEID, since focus exists (F2).
- Level 8: GEMETEN, RankedBoost Arcane page (S5).

**M1b. Polymorph that sets its own focus** (dungeon CC)
```
#showtooltip Polymorph
/focus [@focus,noexists][@focus,dead][mod:ctrl]
/cast [@focus,harm,nodead][harm,nodead] Polymorph
```
The first press makes your target the focus and sheeps it. Later presses re-sheep that same mob, even if you target
something else. Ctrl+press moves the focus to your current target.
- AFGELEID: the RankedBoost priest Shackle macro (P7) adapted to Polymorph. Not seen for Mage as written.

**M2. Counterspell, even while you are casting** (level 24)
```
#showtooltip Counterspell
/stopcasting
/cast [@mouseover,harm,nodead][] Counterspell
```
Stops your own cast and counters the enemy under your mouse, or your target.
- GEMETEN: SenseOS (S7, level 24); WoW Forever Codex blog, 30 Sep 2026 (S8).

**M3. Frost Nova, hold Ctrl for Blink** (Frost Nova 10, Blink 20)
```
#showtooltip
/stopcasting
/cast [mod:ctrl] Blink; Frost Nova
```
Stops your cast and freezes the enemies around you. Holding Ctrl blinks you away instead.
- GEMETEN: RankedBoost mage page, updated 7 Nov 2026 (S5), with the levels.

**M4. Drink, Shift = conjure water, Ctrl = conjure food** (Conjure Water 4, Conjure Food 6)
```
#showtooltip
/cast [mod:shift] Conjure Water; [mod:ctrl] Conjure Food
/stopmacro [mod:shift][mod:ctrl]
/use Conjured Sparkling Water
```
A plain press drinks. Shift makes your highest-rank water and Ctrl your highest-rank food.
- Conjure line: GEMETEN, 60.tools (Shift = food) (S6); Icy Veins Classic uses a right-click version (S13).
- Drink line plus /stopmacro: AFGELEID.
- **Change the water name to the one you actually have.** Classic names are Conjured Water (rank 1, level 4), Fresh (10),
  Purified (20), Spring (30), Mineral (40) and Sparkling (50). These names are AFGELEID from Classic. MagePlan's Forever
  addon tracks the same Classic item IDs (5350, 2288, 2136, 3772, 8077, 8078, 8079): candidate only.
  The rank levels are in Zygor (candidate). **[CLASSIC-RULE]** item names.

**M5. Use whichever mana gem you have** (Agate 28, Jade 38, Citrine 48, Ruby 58)
```
#showtooltip
/use Mana Ruby
/use Mana Citrine
/use Mana Jade
/use Mana Agate
```
Tries the best gem first.
- GEMETEN: 60.tools (S6). It says "the item names are the Classic ones". Gem levels: 60.tools.
- AFGELEID: this relies on the gems sharing one cooldown, so that only one fires. **[CLASSIC-RULE]**

**M6. Ice Block, hold Ctrl to cancel it** (Frost talent)
```
#showtooltip Ice Block
/stopcasting [nomod:ctrl]
/cancelaura [mod:ctrl] Ice Block
/cast [nomod:ctrl] Ice Block
```
A plain press stops your cast and blocks. Ctrl+press ends the block early once you are safe.
- GEMETEN: RankedBoost Frost page, 7 Nov 2026 (S5). Ice Block is a talent in Forever: GEMETEN, metabot mage (S9) and
  RankedBoost.

**M7. Frostbolt, hold Shift for Rank 1 (cheap, fast slow)** (Frostbolt 4)
```
#showtooltip Frostbolt
/cast [mod:shift] Frostbolt(Rank 1); Frostbolt
```
A plain press casts your top rank. Shift casts Rank 1 for a quick, cheap slow.
- GEMETEN: 60.tools (S6). RankedBoost has the same idea on Ctrl (S5). Icy Veins Classic uses it on Alt (S13).
- Forever caveat: Rank 1 gets almost no spell power at high level (F4, F6). Since 2 Nov it can trigger Frostbite again
  (F5, AFGELEID from the wording). It is still good for the slow itself.
- The `(Rank N)` syntax is used by 60.tools, RankedBoost and Zockify. I have not tested it in the client.

**M8. Remove Lesser Curse on mouseover / target / you** (level 18)
```
#showtooltip Remove Lesser Curse
/cast [@mouseover,help,nodead][help,nodead][@player] Remove Lesser Curse
```
Removes a curse from the friend under your mouse, your friendly target, or yourself.
- GEMETEN: 60.tools (S6); RankedBoost uses the same idea with /stopcasting (S5). In Forever it **also removes Banes**:
  GEMETEN, 60.tools and RankedBoost.

Extras (shorter):
- MX1. Arcane Missiles you can mash: `#showtooltip Arcane Missiles` / `/cast [nochanneling:Arcane Missiles] Arcane Missiles`.
  GEMETEN: 60.tools, RankedBoost, Icy Veins Classic.
- MX2. Arcane Explosion, Rank 1 out of combat (finds stealthed rogues cheaply): `#showtooltip Arcane Explosion` /
  `/cast [combat] Arcane Explosion; Arcane Explosion(Rank 1)`. GEMETEN: Icy Veins Classic (S13); 60.tools (S6).

Mage Forever notes:
- Ice Lance shares an 8-second cooldown with Fire Blast. GEMETEN: S3.
- Frost Blast (added 15 Oct) was removed on 2 Nov. GEMETEN: S3 and S1.
- Frostfire Bolt is trained at 40. GEMETEN: RankedBoost, metabot, Zygor (candidate).
- Teleport: Dalaran is new at level 50. GEMETEN: metabot (S9); 60.tools (S6).

---

## 3. Warlock

**W1. Shadow Bolt and send the pet, Ctrl = call the pet back** (level 1)
```
#showtooltip Shadow Bolt
/petfollow [mod:ctrl]
/stopmacro [mod:ctrl]
/petattack [@target,harm,nodead]
/cast [@target,harm,nodead] Shadow Bolt
```
Every Shadow Bolt also sends your demon at the target. Ctrl calls the demon back and casts nothing.
- GEMETEN: RankedBoost warlock page, 7 Nov 2026 (S5).

**W2. Fear on mouseover, or your target** (level 8)
```
#showtooltip Fear
/cast [@mouseover,harm,nodead][] Fear
```
Fears a second enemy without losing your main target.
- GEMETEN: 60.tools (S6). Level 8: RankedBoost (S5) and Zygor (candidate).

**W2b. Fear and pull the demon off; Ctrl = Banish** (Fear 8, Banish 28)
```
#showtooltip [mod:ctrl] Banish; Fear
/petfollow
/cast [mod:ctrl,@target,harm,nodead] Banish; [@target,harm,nodead] Fear
```
Calls your demon back (so it does not break the fear) and fears the target. Ctrl banishes instead (demons and
elementals only).
- GEMETEN: RankedBoost (S5).

**W3. Health Funnel that does not restart; Shift = stop** (level 12)
```
#showtooltip Health Funnel
/stopcasting [mod:shift]
/stopmacro [mod:shift]
/cast [@pet,exists,nodead,nochanneling:Health Funnel] Health Funnel
```
Heals your demon. Extra presses do not restart the channel. Shift stops it once the pet is healthy.
- GEMETEN: 60.tools (S6). Level 12: RankedBoost Demonology (S5).

**W4. Soulstone on mouseover or target** (Create Soulstone: 18; ranks at 30, 40, 50, 60 in Zygor, candidate)
```
#showtooltip
/use [@mouseover,help,nodead][] Major Soulstone
/use [@mouseover,help,nodead][] Greater Soulstone
/use [@mouseover,help,nodead][] Soulstone
/use [@mouseover,help,nodead][] Lesser Soulstone
/use [@mouseover,help,nodead][] Minor Soulstone
```
Puts whatever soulstone you carry on the healer under your mouse, or on your target. 249 characters.
- GEMETEN: 60.tools (S6), which says names were checked against live client data. The Soulstone mechanics themselves are
  not covered by any Forever change list I found (metabot, RankedBoost). **[CLASSIC-RULE]** item names.

**W5. Healthstone; Shift = create one** (Create Healthstone: 10; ranks at 22, 34, 46, 58 in Zygor, candidate)
```
#showtooltip
/cast [mod:shift] Create Healthstone
/stopmacro [mod:shift]
/use Major Healthstone
/use Greater Healthstone
/use Healthstone
/use Lesser Healthstone
/use Minor Healthstone
```
A plain press eats your best healthstone. Shift makes a new one.
- The /use lines: GEMETEN, 60.tools (S6). Shift-create: AFGELEID, after warcraft.wiki.gg's retail "one-button
  Healthstone". It relies on healthstones sharing one cooldown. **[CLASSIC-RULE]**

**W6. Drain Life you can mash; Shift = Drain Soul; Ctrl = Life Tap** (Life Tap 6, Drain Soul 10, Drain Life 14)
```
#showtooltip
/cast [mod:ctrl] Life Tap; [nochanneling,mod:shift] Drain Soul; [nochanneling] Drain Life
```
Mashing does not restart your drain. Ctrl turns health into mana.
- AFGELEID: a simplified 60.tools "one button for your channels" macro, without Wrack and with Life Tap moved off Alt
  (S6). Levels: Zygor (candidate) and RankedBoost (Drain Life 14, Drain Soul 10).
- Forever: Life Tap gives more mana as your Spirit rises. GEMETEN: RankedBoost (S5).
- Forever: Drain Soul's chance for a shard on damage (not on the kill) was greatly reduced. GEMETEN: S3.

**W7. DoT one button for levelling** (Immolate 1, Corruption 4, Bane of Agony 8)
```
#showtooltip
/petattack [harm,nodead]
/castsequence reset=target/combat Corruption, Bane of Agony, Immolate
```
Each press puts the next DoT on the target. It starts over on a new target or after combat.
- GEMETEN: Codex blog, 30 Sep 2026 (S8, castsequence); 60.tools (petattack line, S6). Bane of Agony level 8: SenseOS (S7).
- AFGELEID: a castsequence gets stuck when one step fails (out of range, for example). Press again or change target.

**W8. Your demon's main button** (Voidwalker 10, Succubus 20, Felhunter 30 per 60.tools)
```
#showtooltip
/cast [pet:imp] Fire Shield; [pet:voidwalker] Sacrifice; [pet:felhunter] Spell Lock; [pet:succubus] Seduction
```
One key does whatever matters for the demon you have out: Spell Lock (interrupt), Seduction (CC), Sacrifice (shield).
- GEMETEN: 60.tools (S6).
- Forever caveat: the **Incubus is a separate summon** in Forever. 60.tools has not confirmed whether it has Seduction.
  Add `[pet:incubus]` only once you know.

Extra:
- WX1. Death Coil, Ctrl = Howl of Terror (Death Coil 42, Howl 40). GEMETEN: RankedBoost (S5); 60.tools has a mouseover
  version.
  ```
  #showtooltip [mod:ctrl] Howl of Terror; Death Coil
  /stopcasting
  /cast [mod:ctrl] Howl of Terror; [@target,harm,nodead] Death Coil
  ```

Warlock Forever notes:
- A Bane takes its own slot next to your Curse. GEMETEN: RankedBoost (S5).
- Curse of the Elements comes at level 20 and covers every magic school. GEMETEN: 60.tools; Zygor (candidate).
- Fel Domination's cooldown is now 5 min. GEMETEN: metabot; 60.tools.

---

## 4. Priest

**P1. Power Word: Shield on mouseover / target / you, cuts your cast** (level 6)
```
#showtooltip Power Word: Shield
/stopcasting
/cast [@mouseover,help,nodead][@target,help,nodead][@player] Power Word: Shield
```
Shields the friend under your mouse first. It stops your own slow heal so the shield goes out now.
- GEMETEN: RankedBoost priest page, 7 Nov 2026 (S5).
- Forever: a shield can be replaced by a shield of equal or higher rank. GEMETEN: S3.

**P2. Renew on mouseover / target / you** (level 8)
```
#showtooltip Renew
/cast [@mouseover,help,nodead][help,nodead][@player] Renew
```
- GEMETEN: wowforeversite.wiki macro guide, 29 Oct 2026 (S17). Level 8: RankedBoost downranking table (S5).

**P3. Flash Heal on mouseover / target / you** (level 20)
```
#showtooltip Flash Heal
/cast [@mouseover,help,nodead][@target,help,nodead][@player] Flash Heal
```
- GEMETEN: Codex blog (S8); 60.tools (S6).

**P4. Dispel Magic on friend or foe; Ctrl = Abolish Disease** (Dispel 18, Abolish Disease 32; before 32 write Cure Disease, learned at 14)
```
#showtooltip
/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,@target,help,nodead][mod:ctrl,@player] Abolish Disease; [@mouseover,help,nodead][@target,help,nodead][@mouseover,harm,nodead][@target,harm,nodead][@player] Dispel Magic
```
Cleanses a friend, or strips a buff from an enemy, starting with the unit under your mouse. 230 characters.
- GEMETEN: RankedBoost (S5), levels included. Cure Disease at 14: Zygor (candidate).
- Forever: Cure Disease and Abolish Disease no longer take you out of Shadowform. GEMETEN: S3.

**P5. Psychic Scream; Shift = Fade, both cut your cast** (Scream 14, Fade 8)
```
#showtooltip [mod:shift] Fade; Psychic Scream
/stopcasting
/cast [mod:shift] Fade; Psychic Scream
```
- GEMETEN: 60.tools (S6). Levels: RankedBoost (S5).

**P6. Downranked heal on Ctrl**
Levelling version (Heal Rank 2 is learned at 22, Heal at 16):
```
#showtooltip Heal
/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] Heal(Rank 2); [@mouseover,help,nodead][help,nodead][@player] Heal
```
Level 60 version (Greater Heal Rank 2 is learned at 46):
```
#showtooltip Greater Heal
/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] Greater Heal(Rank 2); [@mouseover,help,nodead][help,nodead][@player] Greater Heal
```
A plain press casts the top rank. Ctrl casts the cheaper rank for small damage.
- Pattern: GEMETEN, 60.tools uses `Greater Heal(Rank 1)` and `Renew(Rank 5)` (S6). My rank choice: AFGELEID.
- Rank levels: GEMETEN, RankedBoost priest downranking table, updated 4 Nov 2026 (S5). Heal ranks are at 16/22/28/34
  and Greater Heal at 40/46/52/58/60.
- **Forever rule of thumb (AFGELEID from F6, unproven above level 30):** only use a rank you could learn at most
  about 17 levels ago. At 60 that means ranks learned at 43 or later: Greater Heal R2-R4, Flash Heal R6-R7,
  Renew R8-R9. The classic "Heal(Rank 2) at 60" trick probably gives almost no +healing now.
- If your character does not know the rank yet, the Ctrl half fails. Change the number.

**P7. Shackle Undead that remembers its target** (level 20)
```
#showtooltip Shackle Undead
/focus [@focus,noexists][@focus,harm,dead][mod:ctrl] target
/cast [@focus,harm,nodead][@target,harm,nodead] Shackle Undead
```
The first press makes the undead your focus and shackles it. When it breaks loose, press again: it re-shackles the
focus, whatever you have targeted. Ctrl moves the focus to a new target.
- GEMETEN: RankedBoost (S5).

**P8. Prayer of Healing; Ctrl = Inner Focus first** (Prayer of Healing 30; Inner Focus is a Discipline talent)
```
#showtooltip Prayer of Healing
/cast [mod:ctrl] Inner Focus
/cast [@mouseover,help,nodead][help,nodead][@player] Prayer of Healing
```
Heals the whole party of the friend you aim at. Ctrl makes it free with Inner Focus.
- GEMETEN: RankedBoost Discipline page (S5).
- Forever: Prayer of Healing heals **the target's party**, not only your own. GEMETEN: 60.tools ("Blizzard confirms",
  S6) and RankedBoost.

Extras:
- PX1. Resurrection on a dead mouseover (level 10). GEMETEN: 60.tools.
  `#showtooltip Resurrection` / `/cast [@mouseover,help,dead][help,dead] Resurrection`
- PX2. Shadow priest: drop Shadowform and Flash Heal. GEMETEN: 60.tools (RankedBoost uses `/cancelform`).
  ```
  #showtooltip Flash Heal
  /cancelaura Shadowform
  /cast [@mouseover,help,nodead][help,nodead][@player] Flash Heal
  ```

Priest Forever notes:
- Shadow Word: Death is trained at 32. GEMETEN: S5; Zygor (candidate).
- Its backlash when it fails to kill: Warcraft Tavern 4 Nov says 30% of max health (S3); 60.tools says 10% (S6).
  **CONFLICT.** The newer source (S3, Blizzard launch notes) says 30%.
- Fear Ward and Devouring Plague are now for every priest. GEMETEN: 60.tools (S6).
- Binding Heal was removed and Holy Binding (a talent) replaced it. GEMETEN: S3. 60.tools also says Binding Heal is
  missing from the live client data. Zygor still lists Binding Heal ranks: outdated.

---

## 5. Druid

**D1. Cat Form that never toggles you out (and the powershift question)** (Cat Form 20)
```
#showtooltip Cat Form
/cast !Cat Form
```
Goes into Cat Form. Pressing again in Cat does nothing (Forever reading).
- GEMETEN: Kami-labs, 1 Oct 2026 (S10): `!` keeps you in the form.
- **[CLASSIC-RULE]** Old clients used `!` to powershift. Test it once: in Cat Form, press it and watch whether you leave
  and come back, or nothing happens.

The 60.tools "powershift" version, which needs two presses (out, then in):
```
#showtooltip Cat Form
/cancelform [noform:3]
/cast [form:3] Cat Form
/cast [noform:3] !Cat Form
```
- GEMETEN: 60.tools (S6). It uses form number 3 (F11, unconfirmed).
- **Forever:** powershifting for Energy no longer pays (F9). Use the Shifting Power talent instead (DX2). A form change is
  still worth it to break roots and snares (F10).

**D2. One key: Aquatic in water, Travel outdoors, Cat indoors** (Aquatic 16, Cat 20, Travel 30)
```
#showtooltip
/cast [swimming] Aquatic Form; [outdoors] Travel Form; Cat Form
```
Pressing again in that form turns you back to normal. Before 30, delete the Travel Form part.
- GEMETEN: RankedBoost druid page, 7 Nov 2026 (S5), with the levels. Also Icy Veins Classic (S13) and 60.tools (S6).

**D3. Cat, or Bear with Shift** (Bear Form ~10 via a quest in Forever; Dire Bear Form 40)
```
#showtooltip [mod:shift] Bear Form; Cat Form
/dismount
/cast [mod:shift] Bear Form; Cat Form
```
At 40, change "Bear Form" to "Dire Bear Form".
- GEMETEN: 60.tools (S6). Bear Form comes from a quest in Forever: GEMETEN, Warcraft Tavern druid guide (S4).
  Level ~10: AFGELEID from Zygor (bear abilities at 10, candidate). Dire Bear 40: Zygor (candidate).

**D4. Innervate on mouseover / target / you, leaves your form** (level 40)
```
#showtooltip Innervate
/cancelform
/cast [@mouseover,help,nodead][help,nodead][@player] Innervate
```
- GEMETEN: RankedBoost (S5) and 60.tools (S6). Level 40: RankedBoost; Zygor (candidate).
- Forever: Innervate works in **Moonkin Form**, so Balance druids should delete `/cancelform`. GEMETEN: RankedBoost.
  Warcraft Tavern says Moonkin can now cast all non-healing spells (S4). Every press drops your form, so keep it off a
  tanking bar.

**D5. Rebirth in combat, Revive out of combat, one key** (Rebirth 20, Revive 12)
```
#showtooltip
/cancelform [@mouseover,help,dead][help,dead]
/cast [combat,@mouseover,help,dead][combat,help,dead] Rebirth; [@mouseover,help,dead][help,dead] Revive
```
Resurrects the dead friend under your mouse, or your dead target. It only leaves your form when there is a dead friend.
- GEMETEN: RankedBoost (S5).
- **Revive is new in Forever:** an out-of-combat resurrection at level 12. GEMETEN: Warcraft Tavern 30 Sep (S4),
  60.tools, Zockify. It has ranks at 24/36/48/60: GEMETEN, metabot (S9).

**D6. Barkskin; Shift = Nature's Grasp** (Nature's Grasp 10, Barkskin 44)
```
#showtooltip [mod:shift] Nature's Grasp; Barkskin
/cast [mod:shift] Nature's Grasp; Barkskin
```
- GEMETEN: 60.tools (S6). In Forever **both work in any form**, so no `/cancelform` is needed. Barkskin no longer costs
  mana. Nature's Grasp is a baseline spell at 10. GEMETEN: metabot (S9), Warcraft Tavern (S4), RankedBoost (S5).
- Barkskin at 44: GEMETEN, 60.tools ("Level 44+"); Zygor (candidate).

**D7. Entangling Roots on mouseover / target, from any form** (level 8)
```
#showtooltip Entangling Roots
/cancelform
/cast [@mouseover,harm,nodead][harm,nodead] Entangling Roots
```
- Mouseover roots: GEMETEN, 60.tools (S6). The /cancelform line: AFGELEID, from Kami-labs' advice to add /cancelform to
  caster spells (S10). Balance: delete /cancelform.
- Forever: Roots work **indoors** now. GEMETEN: RankedBoost; 60.tools. **Only one target** can be rooted at a time.
  GEMETEN: metabot (S9); 60.tools.

**D8. Healing Touch; Ctrl = cheaper rank** (Healing Touch 1; Rank 4 at 20)
```
#showtooltip Healing Touch
/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] Healing Touch(Rank 4); [@mouseover,help,nodead][help,nodead][@player] Healing Touch
```
- GEMETEN: RankedBoost Restoration page (S5).
- Forever (AFGELEID from F6): at 60, Rank 4 (learned at 20) gets almost no +healing. Use Rank 8 (44), 9 (50) or 10 (56)
  instead. Those levels are from Zygor (candidate). All heals fail in animal forms and in Moonkin. GEMETEN: RankedBoost.

Extras:
- DX1. Remove Curse; Ctrl = Abolish Poison, from any form (Remove Curse 24, Abolish Poison 26). GEMETEN: RankedBoost.
  Remove Curse also removes Banes (GEMETEN, RankedBoost and Zockify).
  ```
  #showtooltip
  /cancelform
  /cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl,help,nodead][mod:ctrl,@player] Abolish Poison; [@mouseover,help,nodead][help,nodead][@player] Remove Curse
  ```
- DX2. Shred; Shift = Shifting Power (the Forever replacement for powershifting). GEMETEN: Zockify druid macros,
  31 Oct 2026. Shifting Power is a row-7 Feral talent that needs Predatory Discipline (GEMETEN: S3).
  ```
  #showtooltip
  /startattack [nomod:shift,harm,nodead]
  /cast [mod:shift] Shifting Power; [harm,nodead] Shred
  ```
- DX3. Growl on mouseover (Growl 10). GEMETEN: Zockify; 60.tools.
  `#showtooltip Growl` / `/cast [@mouseover,harm,nodead][harm,nodead] Growl`

Druid Forever notes and conflicts:
- Mangle was renamed Primal Bite (S7). On 2 Nov Primal Bite became a row-7 talent replacing Berserk, and Berserk was
  removed (S3). 60.tools also says Berserk is missing from the live client data.
- Lacerate: the 30 Sep deep dive says it is baseline at 42 (S4), and Zygor agrees. The 4 Nov notes say it is a Feral
  talent now (S3). **CONFLICT.** The newer source wins: talent.
- Faerie Fire in Bear and Cat Form: Warcraft Tavern and 60.tools say it is free with a 6-second cooldown. RankedBoost's
  Feral page says it costs Mana. **CONFLICT.**

---

## 6. Sources (all dated after 18 Aug 2026, except S13 and S14)

- S1 Blizzard (Kaivax), "WoW Forever Beta Development Notes – Updated November 2", post #9, 3 Nov 2026:
  https://us.forums.blizzard.com/en/wow/t/wow-forever-beta-development-notes-%E2%80%93-updated-november-2/2360696/9
  (read via search excerpt; mirrored at forev.eu and gamespot.com, 3 Nov 2026)
- S2 Blizzard Oct 1 beta notes (spell rank tooltip and Frostbolt example), via Wowhead News, 1 Oct 2026:
  https://www.wowhead.com/forever/news/level-30-now-available-forever-beta-patch-notes-383217 ; also Wowhead 9 Oct 2026:
  https://www.wowhead.com/forever/news/downranking-spells-significantly-nerfed-in-wow-forever-383285
- S3 Warcraft Tavern, pre-launch class changes, 4 Nov 2026:
  https://www.warcrafttavern.com/forever/news/wow-forever-pre-launch-class-changes-bug-fixes/
- S4 Warcraft Tavern, "Powershifting is Back (Sort of)", 30 Sep 2026:
  https://www.warcrafttavern.com/forever/news/powershifting-is-back-sort-of-hunter-druid-deep-dive-for-wow-forever/ ;
  druid guide https://www.warcrafttavern.com/forever/guides/druid/ (undated, Nov 2026 links)
- S5 RankedBoost Forever macros, published 1 Oct and updated 7 Nov 2026: https://rankedboost.com/world-of-warcraft/forever/macros/
  (mage, warlock, priest and druid pages plus spec pages); downranking hub and priest table, updated 4 Nov 2026:
  https://rankedboost.com/world-of-warcraft/forever/downranking/priest/
- S6 60.tools macros, 4 Nov 2026: https://www.60.tools/macros/mage , /warlock , /priest , /druid
- S7 SenseOS macros guide, 26 Oct, updated 5 Nov 2026 (launch client 1.60.1.70790): https://senseos.gg/guides/wow-forever/macros/
- S8 WoW Forever Codex blog, 30 Sep 2026: https://wowforevercodex.com/blog/2026-09-30-wow-forever-macros-for-every-class
- S9 metabot.gg change lists (client 1.60.1.70790, undated): https://metabot.gg/en/wow-forever/changes/mage (also warlock, priest, druid)
- S10 Kami-labs, 1 Oct 2026: https://kami-labs.fr/en/wow-forever/macros-wow-forever-9-classes/
- S11 Downranking measurement: ForeverWisp 10 Oct 2026 https://www.foreverwisp.com/guides/wow-forever-downranking-spell-ranks ;
  Wowdee 13 Oct 2026 https://wowdee.com/articles/wow-forever-downranking-spell-ranks ; bindonforever 12 Oct 2026
  https://bindonforever.com/articles/downranking-spell-power-and-procs ; Forever Mastery 29 Oct 2026
  https://forevermastery.com/en/guides/wow-forever-downranking ; DoubleZug video https://www.youtube.com/watch?v=zsyBlnLctpw
- S12 wow.gg Feral overview, 19 Sep 2026 (early beta): https://wow.gg/guides/druid-feral-combat-forever-overview
- S13 Icy Veins **Classic** macro guides (Classic Era/Anniversary, updated Nov 2024, NOT Forever):
  https://icy-veins.com/wow-classic/classic-guide-to-mages-best-macros (also the priests, druids and warlocks pages)
- S14 warcraft.wiki.gg Powershifting (undated): https://warcraft.wiki.gg/wiki/Powershifting
- S15 Wowhead user guide (user-submitted), updated 20 Oct 2026:
  https://www.wowhead.com/forever/guide/beginners-guide-to-writing-macros-in-wow-forever-34950
- S16 Zockify: mage macros, updated 1 Nov 2026, https://www.zockify.com/forever/mage/macros/ ; druid macros, updated
  31 Oct 2026, https://www.zockify.com/forever/druid/macros/
- S17 wowforeversite.wiki, 29 Oct 2026: https://wowforeversite.wiki/guides/macros/

Not usable or not reached: Icy Veins and playnews.gg returned 403 to WebFetch (Icy Veins was read through another
fetcher). No Reddit thread about Forever macros was found. **An empty search proves nothing.**
playautotechnologies.org was skipped as unreliable: it gives `/cast ... Soulstone Resurrection`, which is not how
Soulstone works in Classic.

## 7. Side note (candidate, not about macros)

MagePlan (a Forever addon, `Drink.lua`) says in its code comments that the Forever client can hide your mana from addons
as "secret" values, and it works around this with `C_CurveUtil`. If that is true, it matters for Midnight Helper in
Forever. Not verified.
