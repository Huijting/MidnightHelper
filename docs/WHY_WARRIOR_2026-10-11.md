# Warrior: why lines, quiz, "good to know" (Arms 71, Fury 72, Protection 73)

Research date 11 Oct 2026, read-only. No repo file was changed. MEASURED = GEMETEN (seen in a named, dated
source), INFERRED = AFGELEID (reasoned). Not seen in the game: no client test was done.

## Sources (each one fetched 11 Oct 2026)

| tag | source | date of content |
|---|---|---|
| DB2-L | wago.tools DB2, build **12.1.0.69933** (live), read in the browser through the Inertia JSON: Spell, SpellName, SpellEffect, SpellMisc + SpellDuration, SpellCooldowns, SpellCategory, SpellAuraOptions, SpellPower, SpecializationSpells, TraitDefinition, SkillLineAbility | build 12.1.0.69933 |
| DB2-P | the same tables, build **12.1.5.70077** (PTR). Diff against DB2-L for 48 warrior spells × 6 tables (SpellEffect, SpellPower, SpellAuraOptions, SpellMisc, SpellCooldowns, SpellCategories) + descriptions of 70 spells | build 12.1.5.70077 |
| APL | SimC `midnight`, `ActionPriorityLists/default/warrior_arms.simc` (last commit ede6c4771a, **1 Sep 2026**), `warrior_fury.simc` (e3c2e66e91, **11 Aug 2026**), `warrior_protection.simc` (a08a306d0f, **4 Oct 2026**). Git history via the GitHub API | see commits |
| SC | SimC `midnight`, `engine/class_modules/sc_warrior.cpp` (has `wowv >= 12.1.0` branches; **no** 12.1.5 branches for warriors) | fetched 11 Oct |
| IV-A / IV-F | Icy Veins Arms / Fury rotation, Archimtiros (SimC dev), "Last Updated **Aug 10, 2026**", changelog "Updated for Patch 12.1" | 10 Aug 2026 |
| IV-P | Icy Veins Prot rotation, Mwahi, "Last Updated **Aug 18, 2026**" | 18 Aug 2026 |
| M-A / M-F / M-P | Method Arms (Danwarr, **25 Sep 2026**), Fury (Danwarr, **11 Aug 2026**), Prot (Nate, **11 Aug 2026**), all "Patch 12.1" | as listed |
| WH-A / WH-F / WH-P | Wowhead rotation guides: Arms (Archimtiros, **2026/08/20**, "Midnight Season 2"), Fury (**2026/08/12**), Prot (Pumps, **2026/08/12**) | as listed |
| EU | EU forum thread 627464 as JSON: 6 posts (3 Sep ×3, 15 Sep, 22 Sep, 29 Sep), `last_posted_at` **2026-09-29T20:58Z**. Nothing after 29 Sep | 3-29 Sep 2026 |
| CODE | `Modules/PlayCards.lua` `ns.GetPlayCardQuiz` (lines 338-399) and `ns.PlayCardWhyState` (321-333) | repo, 11 Oct |

Note on dates: IV-A and IV-F are dated 10 Aug, so before Season 2 (18 Aug). They say "Updated for Patch 12.1", and
every priority I use from them matches the 12.1 APL (Cleave applies Rend, Heroic Strike, Rend under 5 s, Reckless
Abandon). So these are 12.1 texts, not 12.0.7 leftovers. WH-A (20 Aug) and M-A (25 Sep) say the same.

All 26 spell IDs on the three cards resolve to the right name in DB2-L (MEASURED): 12294 Mortal Strike, 167105
Colossus Smash, 107574 Avatar, 772 Rend, 163201 Execute, 7384 Overpower, 1464 Slam, 260708 Sweeping Strikes, 845
Cleave, 227847 Bladestorm, 436358 Demolish, 184367 Rampage, 1719 Recklessness, 23881 Bloodthirst, 85288 Raging Blow,
5308 Execute (Fury), 190411 Whirlwind, 385059 Odyn's Fury, 6343 Thunder Clap, 435222 Thunder Blast, 23922 Shield
Slam, 2565 Shield Block, 190456 Ignore Pain, 1160 Demoralizing Shout, 385952 Shield Charge, 6572 Revenge.
163201 is a Warrior class spell (SkillLineAbility SkillLine 840), shared by Arms and Prot (MEASURED). In 12.1.5 its
SpellPower has separate rows for the Prot spec aura 137048 (MEASURED, DB2-P).

---

# ARMS WARRIOR (71)

Card: 4 steps + AOE, 2 hero lines.

### W1 (S1: Colossus Smash + Avatar)
**EN:** `{SPELL:167105} cracks the enemy's armor: for a while, everything you do to it hits harder. {SPELL:107574} makes all your damage stronger too. The two add up, so save your hardest hits for that moment.`
**NL:** `{SPELL:167105} kraakt het harnas van de vijand: een tijdje raakt alles wat je hem aandoet harder. {SPELL:107574} maakt al je schade ook sterker. Die twee tellen op, dus bewaar je hardste klappen voor dat moment.`
- Colossus Smash hits all enemies within its radius and gives "increasing damage you deal to them by $208086s1% for $208086d"; the debuff 208086 is +30% damage taken from the caster (aura 271, base 30) for 10 s (SpellDuration 1). DB2-L. **MEASURED.** Unchanged in DB2-P. **MEASURED.**
- Avatar: "increasing all damage you deal by $s1% ... for $d". DB2-L 107574. **MEASURED.**
- "They add up": in SC, Colossus Smash is a per-target multiplier (`warrior_attack_t::composite_target_multiplier`) and Avatar is a separate player buff. **MEASURED in SimC code**; that the game stacks them the same way is **INFERRED**.
- Use them together: WH-A "Avatar shortly before or with Colossus Smash"; IV-A "Cast Avatar with or just before Colossus Smash"; APL `avatar,if=debuff.colossus_smash.up|cooldown.colossus_smash.remains<10...`. **MEASURED.**
- No numbers in the line on purpose (30%, 10 s are tuning).

### W2 (S2: Rend)
**EN:** `{SPELL:772} is a bleed: one hit, then the enemy keeps bleeding on its own for a while. That is free damage, as long as it never runs out. Just before {SPELL:167105}, renew it a bit earlier, so it keeps bleeding through that whole moment.`
**NL:** `{SPELL:772} is een bloeding: één klap, en daarna blijft de vijand een tijdje vanzelf bloeden. Gratis schade, zolang hij nooit afloopt. Vlak voor {SPELL:167105} vernieuw je hem iets eerder, zodat hij dat hele moment doorbloedt.`
- Rend: "$s1 Physical damage instantly and an additional ... Bleed damage over $388539d"; the bleed 388539 lasts 15 s (SpellDuration 8), ticks every 3 s (EffectAuraPeriod 3000). DB2-L. **MEASURED.**
- Renew under 5 s: IV-A ("Cast Rend/Cleave to refresh Rend with less than 5 seconds remaining"), WH-A (same, 20 Aug), APL `slayer_st ... rend_dot.remains<=5`. **MEASURED.**
- Renew under 10 s right before Colossus Smash: IV-A, WH-A ("when less than 10 seconds remaining and Colossus Smash off cooldown"), APL `cooldown.colossus_smash.remains<2&dot.rend_dot.remains<=10`. **MEASURED.** Why: Colossus Smash lasts 10 s (MEASURED) and boosts every warrior attack on that enemy, the bleed included (SC: `rend_dot_t` is a `warrior_attack_t`, which carries the multiplier; MEASURED in code), so a Rend with under 10 s left would stop inside the window. **INFERRED.**
- Not claimed: whether renewing early keeps the leftover time (pandemic). Not measured.

### W3 (S3: Mortal Strike; Execute and Heroic Strike lit up)
**EN:** `{SPELL:12294} is your main hit, so it never waits. A lit-up {SPELL:163201} costs nothing, works at any health and hits as if you paid full Rage; Heroic Strike is an upgraded {SPELL:1464} that shows up by itself. Both fade after a while, so use them.`
**NL:** `{SPELL:12294} is je belangrijkste klap, dus die wacht nooit. Een oplichtende {SPELL:163201} kost niets, werkt op elke vijand, hoe gezond ook, en raakt alsof je volle Rage betaalde; Heroic Strike is een opgewaardeerde {SPELL:1464} die vanzelf verschijnt. Allebei verdwijnen ze na een tijdje, dus gebruik ze.`
- "Main hit": WH-A "the most important of which are typically Mortal Strike and Execute"; IV-A "skipping an extra cast of Slam is less important than missing a Mortal Strike". **MEASURED.** Several talents feed it: Martial Prowess 1273062 (Overpower and Slam raise the next Mortal Strike, up to 3 stacks), Executioner's Precision 386634, Battlelord 386630 (Overpower can reset it). DB2-L. **MEASURED.**
- Sudden Death (Arms) buff 52437: "Execute costs no Rage, can be used on any target, regardless of their health and deals damage as if you spent $29725s1 Rage"; stacks to 2 (CumulativeAura 2), 12 s (SpellDuration 29). DB2-L. **MEASURED.**
- Heroic Strike: talent Master of Warfare 1269314 "Your single target melee abilities have a chance to upgrade Slam to Heroic Strike"; the proc buff 1269391 overrides 1464 with 1269383, 1 charge, 15 s (SpellDuration 8). DB2-L. **MEASURED.** Ranked above Slam: IV-A "Heroic Strike has a higher priority than normal Slam casts". **MEASURED.**
- "Lit up" = glow: Sudden Death carries aura 408 on 163201. That 408 is the button glow is **INFERRED**.

### W4 (S4: Overpower, Slam, Execute in execute range)
**EN:** `{SPELL:7384} is a sure hit: it cannot be dodged, blocked or parried. {SPELL:1464} just spends spare Rage. Once the enemy is low, {SPELL:163201} turns that same Rage into a much bigger hit.`
**NL:** `{SPELL:7384} is een zekere klap: hij kan niet ontweken, geblokt of gepareerd worden. {SPELL:1464} geeft alleen je overgebleven Rage uit. Is de vijand bijna dood, dan maakt {SPELL:163201} van diezelfde Rage een veel grotere klap.`
- Overpower: "Cannot be blocked, dodged, or parried." DB2-L 7384. **MEASURED.**
- Execute: "Only usable on enemies that have less than 20% health", damage "based on Rage spent". DB2-L 163201. **MEASURED.** The Massacre talent raises the line (206315; APL `execute_phase` = 35% with Massacre). **MEASURED.**
- "Much bigger hit" than Slam: every execute priority puts Execute above Slam (WH-A, IV-A, APL `slayer_execute`). No damage numbers were compared. **INFERRED.**
- Optional extra sentence, only if Rob wants the talent in: `With the Martial Prowess talent, {SPELL:7384} and {SPELL:1464} also make your next {SPELL:12294} stronger.` / NL `Met het talent Martial Prowess maken {SPELL:7384} en {SPELL:1464} ook je volgende {SPELL:12294} sterker.` (1273062, a talent per TraitDefinition 140689; IV-A shows it as a toggle, so not every build takes it. **MEASURED**)

### WAOE
**EN:** `{SPELL:260708} makes your next few single-target hits also strike a second enemy close by. {SPELL:845} hits everyone in front of you and puts {SPELL:772} on all of them in one press.`
**NL:** `{SPELL:260708} laat je volgende paar klappen op één doelwit ook een tweede vijand vlakbij raken. {SPELL:845} raakt iedereen voor je en zet in één klik {SPELL:772} op ze allemaal.`
- Sweeping Strikes in 12.1: "Your next $s4 damaging single-target abilities hit $s1 additional target(s) within 8 yds for $s2% damage. Lasts $d." DB2-L 260708. **MEASURED.** SC 12.1 branch gives the buff effect-4 stacks (charges). **MEASURED.** "A second target": IV-A, WH-A ("cleave its normal single target rotation onto a secondary target"). **MEASURED.**
- Cleave: "Strikes all enemies in front of you ... If you know Rend, inflicts Rend on all targets." DB2-L 845; SC `cleave_t::impact` applies the Rend bleed when `wowv >= 12.1.0`. **MEASURED.**

### TERMS (Arms): Rage carries the card (IDEA "never waste Rage", MISTAKE)
**EN:** `Rage is your fuel. It starts empty, fills mostly as your weapon swings by itself, and almost every attack spends it. It drains away after a fight. With the Anger Management talent, every bit you spend also brings {SPELL:167105} and {SPELL:107574} back sooner.`
**NL:** `Rage is je brandstof. Hij begint leeg, vult zich vooral doordat je wapen vanzelf zwaait, en bijna elke aanval kost Rage. Na een gevecht loopt hij weg. Met het talent Anger Management brengt elk beetje Rage dat je uitgeeft ook {SPELL:167105} en {SPELL:107574} sneller terug.`
- Mostly from auto attacks: IV-A "the majority generated through auto-attack swings"; WH-A "Arms generates the majority of its rage from auto-attacks". **MEASURED.** "Nearly every ability Arms uses spends Rage" (IV-A). **MEASURED.**
- Starts at zero, drains out of combat: WH-A "Rage starts from zero and decays out of combat"; IV-P "decays at a rate of 1 per second when out of combat. In combat, Rage does not decay". **MEASURED.**
- Anger Management 152278: "Every $s1 Rage you spend on attacks reduces the remaining cooldown on Avatar and Colossus Smash by 1 sec." DB2-L. **MEASURED.** It is a talent (TraitDefinition), and IV-A, WH-A and M-A all build around it. **MEASURED.**
- No maximum Rage number on purpose: talents change it (the Fury APL tests `rage>100`). **INFERRED.**
- Other words a beginner may not know: "lights up" (Sudden Death, Heroic Strike proc), "bleed". W3 and W2 explain them.

### Quiz (Arms)
| step | last {SPELL} now | fair? | proposal |
|---|---|---|---|
| S1 | 107574 Avatar | Weak: Avatar is the minor half here (WH-A: "only a basic damage bonus"); the point is Colossus Smash | `quizAnswer[1] = 167105` |
| S2 | 772 Rend | Fair | keep (or `[2] = 772` if S2 gets the Cleave clause below) |
| S3 | 163201 Execute | Answerable, but the step is about Mortal Strike first | `quizAnswer[3] = 12294` (needed anyway if "Heroic Strike" becomes `{SPELL:1269383}`, which would become the last spell) |
| S4 | 1464 Slam | **Broken.** Slam is in S4 twice. `GetPlayCardQuiz` blanks only the first one (`text:gsub(..., "{BLANK}", 1)`, PlayCards.lua:373), so "instead of Slam" stays visible and gives the answer away. MEASURED in CODE | `quizAnswer[4] = 163201` ("Target almost dead? ___ instead of Slam"), or 7384 |
| AOE | 772 Rend | Answerable, but the step is about Cleave / Sweeping Strikes | `quizAnswer.AOE = 845` |

Every step has a spell. Pool = 9 spells (10 with 1269383), well over 3.

### Card errors (Arms), for 12.1 Season 2
1. **S2 misses Cleave, and the "best" build never presses Rend.** Since 12.1, Cleave puts Rend on every target it hits (DB2-L 845; SC 12.1 branch). WH-A 20 Aug, Slayer single target: "Cleave to apply or refresh Rend" (Rend itself only on the Colossus list). M-A 25 Sep opener: "Rend (Cleave if talented into Cleave AND Rend)". APL (1 Sep): `rend,if=!talent.cleave&...`, so with Cleave taken it presses Cleave. All **MEASURED.** HERO1 calls Slayer "best this season", so most players will apply Rend with Cleave.
   Proposal S2 EN: `Keep {SPELL:772} on the target; with the Cleave talent, {SPELL:845} puts it on for you. Renew it when less than 5 seconds are left.` NL: `Houd {SPELL:772} op het doelwit; met het talent Cleave zet {SPELL:845} hem er voor je op. Vernieuw hem als er minder dan 5 seconden over zijn.` Then `quizAnswer[2] = 772`.
2. **S3 "Heroic Strike" now has a confirmed 12.1 ID: 1269383.** SpellName "Heroic Strike" with its own description (DB2-L); SC `spell.heroic_strike = find_spell( 1269383 )`; the proc buff 1269391 overrides 1464 → 1269383. **MEASURED.** It can become `{SPELL:1269383}`, which gives it a tooltip and a name in every language. If so, set `quizAnswer[3]`.
3. **HERO2 "Stand still while it hits"** is stricter than the game. IV-A: "Demolish is a channeled effect that severely reduces movement speed", and Charge, Heroic Leap and Intervene can be used during it. **MEASURED (guide).** The DB2 text does not mention movement at all. "Nothing can stun you" is right: "immune to stuns, knockbacks, and forced movement effects" + less damage taken (DB2-L 436358). **MEASURED.** Optional wording: `You barely move while it hits; nothing can stun you then.` / `Je komt bijna niet vooruit terwijl hij slaat; niemand kan je dan stunnen.`
4. Checked and right (MEASURED against IV-A, WH-A, M-A, APL): IDEA; S1; S3/S4 order (MS > Sudden Death Execute > Overpower > Slam); AOE (Sweeping Strikes on cooldown, Cleave the main button); MISTAKE (IV-A: spend Rage "so long as it will not keep you from casting a follow on Mortal Strike"); HERO1 (IV-A marks Slayer "best choice" for single and multi target; Bladestorm in Colossus Smash per IV-A/WH-A/APL; "Consuming Sudden Death reduces the cooldown of Bladestorm based on the number of Executioner stacks", IV-A = Unrelenting Onslaught 444780 in DB2-L. Note: with 0 Executioner stacks it gives nothing).

---

# FURY WARRIOR (72)

Card: 4 steps + AOE, 2 hero lines.

### W1 (S1: Recklessness + Avatar)
**EN:** `{SPELL:1719} makes you earn Rage much faster and crit more often, so you can press {SPELL:184367} far more often. {SPELL:107574} adds extra damage on top, so press them together.`
**NL:** `{SPELL:1719} laat je veel sneller Rage verdienen en vaker critten, zodat je {SPELL:184367} veel vaker kunt drukken. {SPELL:107574} doet er nog extra schade bovenop, dus druk ze samen.`
- Recklessness: "increasing all Rage generation by $s1% and granting your abilities $s4% increased critical strike chance for $d". DB2-L 1719. **MEASURED.** With Reckless Abandon it also gives Rage when pressed (396749). **MEASURED.**
- More Rampage: IV-F "enhanced Rage generation, allowing Rampage to be used more frequently"; WH-F "Increases rage generation to enable much more regular use of Rampage". **MEASURED.**
- Avatar: "increasing all damage you deal". DB2-L. **MEASURED.** For Fury it is on a choice node with Bladestorm (IV-F), so "if you have it" on the card is right. **MEASURED.** Same cooldown, can be macroed together (IV-F, WH-F). **MEASURED.**

### W2 (S2: Rampage)
**EN:** `{SPELL:184367} is four fast hits, and it makes you Enraged: for a few seconds all your damage is higher. Pressing it again before that runs out keeps it going. Rage above a full bar is lost, so spend it before the bar is full.`
**NL:** `{SPELL:184367} is vier snelle klappen, en hij maakt je Enraged: een paar seconden lang doe je meer schade. Druk je hem opnieuw voordat dat afloopt, dan blijft het doorgaan. Rage boven een volle balk ben je kwijt, dus geef het uit voordat de balk vol is.`
- Rampage: "Unleash a series of $s1 brutal strikes" (SpellEffect base 4), "Enrages you", costs 80 Rage (SpellPower 800). DB2-L 184367. **MEASURED.**
- Enrage 184362: 4 s base (SpellDuration 35); "Damage done increased by $76856s3%" (Mastery: Unshackled Fury "Increases damage done while Enraged"). DB2-L. **MEASURED.**
- Pressing again keeps it going: SC re-triggers the buff (`p()->enrage()` → `buff.enrage->trigger()`). **MEASURED in code**; in-game refresh behaviour **INFERRED.**
- Rage above full is lost: IV-P "any further Rage generation is lost" (same resource). **MEASURED (guide)**, for Fury **INFERRED.** APL: `rampage,if=buff.enrage.remains<gcd|rage>=100`. **MEASURED.**

### W3 (S3: Bloodthirst and Raging Blow)
**EN:** `Both give you Rage. {SPELL:23881} also heals you a little and can make you Enraged by itself. With the Reckless Abandon talent, {SPELL:1719} upgrades them to Bloodbath and Crushing Blow, which hit harder.`
**NL:** `Allebei geven ze je Rage. {SPELL:23881} heelt je ook een beetje en kan je zelf Enraged maken. Met het talent Reckless Abandon maakt {SPELL:1719} er Bloodbath en Crushing Blow van, en die raken harder.`
- Bloodthirst: "restoring $117313s1% of your health ... Generates ... Rage and has a $s3% chance to Enrage you". Raging Blow: "Generates ... Rage". DB2-L. **MEASURED.**
- Reckless Abandon 396749: "while Recklessness is active, Raging Blow and Bloodthirst are upgraded to Crushing Blow and Bloodbath ... Deals increased damage". DB2-L. **MEASURED.** It is a talent (TraitDefinition). **MEASURED.** SC: `bloodbath_t::ready()` needs Reckless Abandon and Recklessness. **MEASURED.**

### W4 (S4: Execute; Whirlwind as filler)
**EN:** `{SPELL:5308} is a big finishing hit that normally only works on badly hurt enemies. When it lights up (Sudden Death), it works on any enemy, so use it. {SPELL:190411} fills the gaps, so you never waste a moment.`
**NL:** `{SPELL:5308} is een grote afmaakklap die normaal alleen werkt op zwaargewonde vijanden. Licht hij op (Sudden Death), dan werkt hij op elke vijand, dus gebruik hem. {SPELL:190411} vult de gaten, zodat je nooit een moment verspilt.`
- Execute (Fury): "Only usable on enemies that have less than 20% health". DB2-L 5308. **MEASURED.** Massacre raises it (APL 35%). **MEASURED.**
- Sudden Death (Fury) 280721: "chance to reset the cooldown of Execute and make it usable on any target, regardless of their health"; buff 280776 stacks to 2, 12 s. DB2-L. **MEASURED.**
- Whirlwind filler: IV-F "Fury should never have any free global cooldowns, due to Whirlwind always being available"; WH-F "Whirlwind when nothing else is available". **MEASURED.**
- Left out on purpose: "Execute costs no Rage". That is the talent Improved Execute 316402 (TraitDefinition rows). **MEASURED**; whether every build has it is not measured.

### WAOE
**EN:** `{SPELL:190411} charges up your next few single-target hits, so each one also strikes several enemies around you. {SPELL:385059} hits everyone nearby, makes them bleed and makes you Enraged in one go.`
**NL:** `{SPELL:190411} laadt je volgende paar klappen op één doelwit op, zodat elke klap ook een paar vijanden om je heen raakt. {SPELL:385059} raakt iedereen dichtbij, laat ze bloeden en maakt je in één keer Enraged.`
- Improved Whirlwind 12950 (talent): "Whirlwind causes your next $85739u single-target attacks to strike up to $85739s1 additional targets for $85739s2% damage". DB2-L. **MEASURED.** WH-F: cleaves "to 4 additional targets". **MEASURED (guide).**
- Odyn's Fury: damage plus a bleed "to all enemies within ... yards", "Enrages you and generates ... Rage". DB2-L 385059. **MEASURED.**

### TERMS (Fury): "Enraged" carries the card (IDEA, S2, MISTAKE)
**EN:** `Enraged is a short buff: while it is on, all your damage is higher. {SPELL:184367} always gives it, {SPELL:385059} too, and {SPELL:23881} sometimes. It lasts only a few seconds, so keep it going by pressing {SPELL:184367} again before it runs out.`
**NL:** `Enraged is een korte buff: zolang hij aan staat, doe je meer schade. {SPELL:184367} geeft hem altijd, {SPELL:385059} ook, en {SPELL:23881} soms. Hij duurt maar een paar seconden, dus houd hem vast door {SPELL:184367} opnieuw te drukken voordat hij afloopt.`
- Enrage 184362: damage done up by the mastery value, 4 s base; talents add haste + speed (Frenzied Enrage 383848), mastery + leech (Powerful Enrage 440277), less damage taken (Warpaint 208154), or a longer Enrage from Bloodthirst (Deft Experience 383295). DB2-L. **MEASURED.** Hence "a few seconds", not "4".
- Sources: Rampage "Enrages you", Odyn's Fury "Enrages you", Bloodthirst "chance to Enrage you", Fresh Meat 215568 (talent) "always Enrages you the first time you strike a target". DB2-L. **MEASURED.**

### Quiz (Fury)
| step | last {SPELL} now | fair? | proposal |
|---|---|---|---|
| S1 | 107574 Avatar | Weak: "with ___ if you have it"; the step is about Recklessness | `quizAnswer[1] = 1719` |
| S2 | 184367 Rampage | Fair | keep |
| S3 | 1719 Recklessness | Answerable ("In ___ they turn into stronger versions"), but the step is about the Rage builders, and the upgrade needs a talent | `quizAnswer[3] = 23881` (85288 equally fine) |
| S4 | 190411 Whirlwind | Fair ("Nothing else ready? ___"), but Execute is the point | optional `quizAnswer[4] = 5308` |
| AOE | 385059 Odyn's Fury | Weak: "___ on cooldown" fits any cooldown | `quizAnswer.AOE = 190411` |

No answer spell appears twice in its step. Pool = 8 spells.

### Card errors (Fury)
1. **S3 "In Recklessness they turn into stronger versions"** is true only with the talent Reckless Abandon (DB2-L 396749, TraitDefinition). **MEASURED.** All three guides use Crushing Blow/Bloodbath in every list (IV-F, WH-F, M-F), so the default builds take it. **MEASURED.** Optional: `... With the Reckless Abandon talent, {SPELL:1719} turns them into stronger versions: keep pressing them.`
2. **AOE "Whirlwind first, so your next hits also hit..."** needs the talent Improved Whirlwind (12950, TraitDefinition). **MEASURED.** WH-F describes it as the normal AoE base. Fine as it stands; noted only.
3. Checked and right (MEASURED): S1 (Avatar a choice node, IV-F); S2 = APL/IV-F/WH-F/M-F "Rampage over 100 rage or if Enrage is about to expire"; S4; MISTAKE; HERO1 (IV-F: "always be enraged before using [Bladestorm], preferably immediately after a fresh Rampage", Bladestorm in Recklessness; APL `rampage,if=buff.recklessness.up&cooldown.bladestorm.ready`); HERO2 (Crashing Thunder 436707: "Improved Whirlwind, Meat Cleaver, Storm of Blood, and Barbaric Training affect Thunder Clap in addition to Whirlwind", and Thunder Clap costs no Rage and gives Rage for Fury; Thunder Blast buff 435615 holds at most 2 (CumulativeAura 2); IV-F/WH-F/M-F "Thunder Blast with 2 stacks").

---

# PROTECTION WARRIOR (73)

Card: 4 steps + AOE, 2 hero lines.

### W1 (S1: Shield Block)
**EN:** `{SPELL:2565} blocks every melee hit for a few seconds, and while it is up your {SPELL:23922} hits harder. It has 2 charges: while both are full, no new one is charging, so that is wasted time. Pressing it while it is still up adds the time on.`
**NL:** `{SPELL:2565} blokt een paar seconden lang elke melee-aanval, en zolang hij aan staat raakt je {SPELL:23922} harder. Hij heeft 2 charges: staan ze allebei vol, dan laadt er geen nieuwe op, en dat is verspilde tijd. Druk je hem terwijl hij nog loopt, dan komt de tijd erbij.`
- "blocking all melee attacks against you for $132404d ... Increases Shield Slam damage by $132404s2% while active"; buff 132404: block chance +100%, Shield Slam +30%, 6 s (SpellDuration 32); costs 30 Rage (SpellPower 300). DB2-L. **MEASURED.**
- 2 charges: 231847 "Shield Block has ${$s1+1} charges" (s1 = 1), a Prot spec spell (SpecializationSpells spec 73); recharge 16 s (SpellCategory 1385). DB2-L. **MEASURED.**
- "No new one charging while both are full": the general charge rule. **INFERRED** (not measured here). Guides: M-P "Shield Block if it's not up or you are about to cap charges"; IV-P "you have close to 2 charges". **MEASURED.**
- "Adds the time on": SC `shield_block_t::execute` uses `extend_duration_or_trigger`; APL presses it at `remains<=10`. **MEASURED in SimC**; in-game **INFERRED.**

### W2 (S2: Ignore Pain)
**EN:** `{SPELL:190456} soaks up half of every hit until its shield is used up, and pressing it again tops the shield up, up to a limit. Rage above a full bar is lost, so a bit of extra shield always beats wasted Rage.`
**NL:** `{SPELL:190456} vangt de helft van elke klap op tot het schild op is, en opnieuw drukken vult het schild bij, tot een grens. Rage boven een volle balk ben je kwijt, dus een beetje extra schild is altijd beter dan verspilde Rage.`
- "ignoring $s2% of damage taken ... until ... damage has been prevented. Repeated uses of Ignore Pain accumulate, up to ${$mhp*$s4/100} total"; s2 = 50, s4 = 30; 12 s (SpellDuration 29); 35 Rage (SpellPower 350). DB2-L 190456. **MEASURED.**
- Not on the global cooldown: SpellCooldowns StartRecoveryTime 0, RecoveryTime 1000 ms. DB2-L. **MEASURED.** (This backs the card's "does not block your other buttons".)
- IV-P: "Ignore Pain will take priority over any other ability if your next cast would put you past your maximum Rage". **MEASURED.**

### W3 (S3: Avatar, Demoralizing Shout, Shield Slam)
**EN:** `{SPELL:23922} is your main Rage maker, and your other attacks can make it ready again early, so keep an eye on it. {SPELL:107574} makes you hit harder and take less damage; {SPELL:1160} makes the enemies around you hit you softer.`
**NL:** `{SPELL:23922} is je belangrijkste bron van Rage, en je andere aanvallen kunnen hem eerder weer klaarzetten, dus let erop. {SPELL:107574} laat je harder slaan en minder schade krijgen; {SPELL:1160} laat de vijanden om je heen zachter slaan.`
- Shield Slam: 15 Rage (`$/10;s3`, effect base 150), 9 s cooldown. DB2-L 23922. **MEASURED.** Main source over a fight: WH-P "this will generate the most rage/threat/damage". **MEASURED (guide)**; my reason (short cooldown + resets) is **INFERRED.**
- Early reset: Strategist 384041 (talent) "Devastate, Thunder Clap, Revenge, and Execute have a ... chance to reset the remaining cooldown on Shield Slam". DB2-L. **MEASURED.** IV-P says the same. **MEASURED.**
- Avatar for Prot: "increasing all damage you deal by $s1% ... and reducing all damage you take by $s8%". DB2-L 107574 (c3 branch). **MEASURED.**
- Demoralizing Shout: "reducing the damage they deal to you by $s1% for $d"; with Booming Voice (202743, talent) +20 Rage and more damage to them. DB2-L. **MEASURED.**

### W4 (S4: Thunder Clap, Shield Charge, Revenge, Execute)
**EN:** `{SPELL:6343} hits every enemy around you and gives Rage. {SPELL:385952} rushes in, hits a whole group and turns on {SPELL:2565} for free. Spare Rage goes to {SPELL:6572}, which sometimes lights up for free; on a nearly dead enemy, {SPELL:163201} hits harder.`
**NL:** `{SPELL:6343} raakt elke vijand om je heen en geeft Rage. {SPELL:385952} stormt erop af, raakt een hele groep en zet gratis {SPELL:2565} aan. Overgebleven Rage gaat naar {SPELL:6572}, die soms gratis oplicht; bij een bijna dode vijand slaat {SPELL:163201} harder.`
- Thunder Clap: "Blasts all enemies within $A1 yards ... Generates ... Rage" (Prot branch). DB2-L 6343. **MEASURED.**
- Shield Charge: "granting you Shield Block and dealing ... damage to it and ... to all enemies within 10 yards ... stuns", 20 Rage (385954 energize 200), 45 s cooldown. DB2-L. **MEASURED.**
- Revenge: "Your successful dodges, parries, and auto-attacks have a chance to make your next Revenge cost no Rage"; buff 5302 "Your next Revenge is free". DB2-L. **MEASURED.**
- Execute over Revenge at low health: IV-P "Execute should be used over Revenge as soon as the targets hits the health threshold". **MEASURED (guide).** "Hits harder" is **INFERRED** from that. In 12.1.5 Prot Execute gets +30% damage (see below), so the line only gets truer.

### WAOE
**EN:** `Enemies go after whoever bothers them most. {SPELL:6343} hits every enemy around you at once, so the whole pack turns to you instead of your friends.`
**NL:** `Vijanden gaan achter degene aan die hen het meest dwarszit. {SPELL:6343} raakt alle vijanden om je heen tegelijk, dus de hele groep keert zich naar jou in plaats van naar je vrienden.`
- Thunder Clap hits all enemies within its radius. DB2-L. **MEASURED.**
- IV-P: "worth casting Thunder Clap (or Revenge ...) over Shield Slam in order to pick up those enemies". **MEASURED.**
- The threat mechanic itself (damage makes threat, a tank makes extra threat) is **INFERRED**; not measured.

### TERMS (Prot): Rage carries the card (IDEA "that is your armor", S2, MISTAKE)
**EN:** `Rage is your fuel. It starts empty; you get it from your attacks ({SPELL:23922} above all) and when enemies hit you. You spend it on {SPELL:2565} and {SPELL:190456} to stay alive, and Rage above a full bar is lost.`
**NL:** `Rage is je brandstof. Hij begint leeg; je krijgt hem van je aanvallen (vooral {SPELL:23922}) en als vijanden jou raken. Je geeft hem uit aan {SPELL:2565} en {SPELL:190456} om in leven te blijven, en Rage boven een volle balk ben je kwijt.`
- IV-P 18 Aug: "empty by default", "3 Rage is gained every time an enemy auto-attack hits you", "if you cap out on Rage ... any further Rage generation is lost". **MEASURED.**
- Shield Slam 15 Rage, Shield Block 30, Ignore Pain 35. DB2-L. **MEASURED.** "Above all": WH-P. **MEASURED (guide)** / **INFERRED** (see card error 1).
- "Charges" (S1) is explained in W1, so no second term line is needed.

### Quiz (Prot)
| step | last {SPELL} now | fair? | proposal |
|---|---|---|---|
| S1 | 2565 Shield Block | Fair | keep |
| S2 | 190456 Ignore Pain | Fair | keep |
| S3 | 23922 Shield Slam | Fair, it is the point | keep |
| S4 | 6572 Revenge | **Broken.** Revenge is in S4 twice; only the first is blanked (PlayCards.lua:373), so "instead of Revenge" gives the answer away. MEASURED in CODE | `quizAnswer[4] = 163201` ("Enemy almost dead? ___ instead of Revenge"), or 6343 / 385952 |
| AOE | 6343 Thunder Clap | Fair | keep |

Pool = 9 spells.

### Card errors (Prot)
1. **S3 "it gives the most Rage" is not true per press.** Shield Slam gives 15 (DB2-L 23922), Shield Charge 20 (385954), Demoralizing Shout with Booming Voice 20 (202743). **MEASURED.** It is the main source over a fight because it comes back every 9 s plus resets (**INFERRED**; WH-P says "the most rage", which is a guide claim). Proposal: EN `... {SPELL:23922} every time it is ready: it is your main source of Rage.` NL `... {SPELL:23922} elke keer als hij klaar is: het is je belangrijkste bron van Rage.`
2. **HERO2 "Demolish on cooldown": the APL and the guides disagree.** APL commit a08a306d0f (**4 Oct 2026**) changed `demolish,if=buff.colossal_might.stack>=3` to `>=5`. The Colossal Might buff 440989 holds at most 5 (CumulativeAura 5), and each stack makes the next Demolish stronger (429634: "increases damage dealt by your next Demolish ... Shield Slam grants a stack"). Demolish has a 30 s cooldown (SpellCooldowns 30000). All **MEASURED.** The guides (IV-P 18 Aug, M-P 11 Aug, WH-P 12 Aug) say "on cooldown". The APL is the newest source, but a wait for full stacks is a damage detail, not a beginner rule. Rob decides: keep, or `{SPELL:436358} once Colossal Might shows 5 stacks, best with {SPELL:107574}.`
3. **S3 "Demoralizing Shout when ready"**: the APL presses it for damage only with Booming Voice (`demoralizing_shout,if=talent.booming_voice.enabled`). Without that talent it is a defensive shout (DB2-L 1160). **MEASURED.** Not wrong for a beginner card; noted only.
4. Checked and right (MEASURED): IDEA; S1 (2 charges); S2 (off the GCD); S4 (Mountain Thane order in M-P; Execute over Revenge in IV-P); AOE (IV-P); MISTAKE; HERO1 (Thunder Blast talent 435607 "Shield Slam and Bloodthirst have a $s1% chance to grant you Thunder Blast, stacking up to 2 charges"; Avatar of the Storm 437134 "Casting Avatar grants you $s1 charges of Thunder Blast and resets the cooldown of Thunder Clap" with s1 = 2; APL `thane_st=thunder_blast` first). "Thunder Clap sometimes turns into Thunder Blast" is literal: Thunder Clap's `ready()` refuses while the Thunder Blast buff is up (SC), and the buff text says "Your next Thunder Clap becomes a Thunder Blast".

---

# 12.1.5 (PTR build 12.1.5.70077; live 13/14 Oct)

**EU thread 627464** (JSON, fetched 11 Oct; 6 posts, last one 29 Sep 2026, so there is nothing later). Warrior changes are Protection only:
- 3 Sep (post 1): Execute without extra Rage + 100% damage. **Reverted** on 15 Sep (post 4, struck through) and replaced by "**Execute damage increased by 30%**". **MEASURED.**
- 3 Sep (post 1), repeated 29 Sep (post 6, "active in last week's PTR build"): Colossus **Practiced Strikes** "Execute and Revenge Rage cost reduced by 10". **MEASURED.**
- Arms and Fury: no entries. **MEASURED.**

**DB2 diff 12.1.0.69933 → 12.1.5.70077** (48 warrior spells × 6 tables, + descriptions). Only these differences:
- 429647 Practiced Strikes: new effects 5/6 (−10 Rage on Revenge and Execute) and a longer description. Matches the thread. **MEASURED.**
- 137048 (Protection spec aura) effect 10 on Execute: 20 → 56, so ×1.20 → ×1.56 = +30%. Matches the thread. **MEASURED.**
- 163201 Execute SpellPower split into per-spec rows (cost still 20 + 20 optional). 52437 Sudden Death got an extra −100% modifier (misc 34) on Execute; what it does is **not established**. 260708 Sweeping Strikes lost one attribute flag (meaning unknown). 1269391 (Heroic Strike proc buff) got a tooltip text "Slam has been upgraded to Heroic Strike.". **MEASURED.**
- All 26 card spells: descriptions, costs, durations, charges and stacks are the same, including Shield Block 2 charges, Ignore Pain 50%/30%, Rampage 80 Rage, Enrage 4 s, Thunder Blast max 2, Avatar of the Storm 2. **MEASURED.**

**Effect on the lines:** none of the W lines, TERMS lines or card steps above becomes false in 12.1.5. Prot W4 ("Execute hits harder") and HERO2 ("spare Rage goes to Revenge", now 10 Rage cheaper for Colossus) only get more true. **INFERRED** from the measured changes.

**Practical point (MEASURED in CODE):** `ns.PlayCardWhyState` hides W and TERMS lines when the client interface is higher than `why.interface` (PlayCards.lua:327-329). With `interface = 120100`, the warrior why lines would disappear on 12.1.5 day (120105). Nothing warrior-related changed, so for these three cards `interface = 120105` is supported by DB2-P + the thread. Caveat: the final 12.1.5 patch notes are not out yet (expected with the release), so a last-minute change is still possible. **INFERRED.**

---

# What I could not measure
- Whether renewing Rend early keeps the leftover time (pandemic). Not in the lines.
- That a full set of charges stops recharging (W1 Prot): general rule, not measured.
- Threat (Prot WAOE): general rule, not measured.
- The maximum Rage per spec: left out on purpose.
- Whether every Fury build has Improved Execute (Execute costs no Rage): left out.
- How far you can move during Demolish: only IV-A's "severely reduces movement speed"; the DB2 text says nothing about movement.
- Nothing was checked in the game client.
