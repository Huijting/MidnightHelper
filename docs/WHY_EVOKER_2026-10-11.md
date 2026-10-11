# Evoker: why lines, quiz and "good to know" (Devastation 1467, Preservation 1468, Augmentation 1473)

Research done 11 Oct 2026 by mh-research. Nothing in the repo was edited. MEASURED = seen in a named, dated source
(GEMETEN). INFERRED = my own reasoning (AFGELEID).

## Sources (all read 11 Oct 2026)

| tag | source | date on the page / commit |
|---|---|---|
| DB2 | wago.tools DB2, build **12.1.0.69933**: Spell, SpellName, SpellEffect, SpellMisc, SpellDuration, SpellCooldowns, SpellCategory(ies), SpellPower, SpellAuraOptions, SpellDescriptionVariables, TraitDefinition, PowerType, SpecializationSpells | live build |
| PTR-DB2 | the same tables for **12.1.5.70077**, compared ID by ID against 69933 | PTR build |
| PTR-notes | EU forum thread 627464 "Midnight: 12.1.5 PTR Development Notes", all 6 posts (3 Sep x3, 15 Sep, 22 Sep, 29 Sep; last post 29 Sep 2026) | 3-29 Sep 2026 |
| APL-Dev | SimC `midnight` `ActionPriorityLists/default/evoker_devastation.simc` | last commit 15 Sep 2026 (d87a103); 12.1 rewrite 11 Aug 2026 (c6da5e6) |
| APL-Aug | SimC `midnight` `ActionPriorityLists/default/evoker_augmentation.simc` | last commit 19 Sep 2026 (849a7be); 12.1 rewrite 11 Aug 2026 (c6da5e6) |
| IV-Dev | Icy Veins Devastation rotation | updated 10 Aug 2026 ("Adjustments made for Season 2") |
| M-Dev | Method Devastation playstyle & rotation | 25 Aug 2026 |
| WH-Dev | Wowhead Devastation rotation (Preheat) | 9 Sep 2026 |
| IV-Pres | Icy Veins Preservation rotation | 13 Aug 2026 (12.1 update 10 Aug) |
| M-Pres | Method Preservation playstyle & rotation | 20 Aug 2026 |
| WH-Pres | Wowhead Preservation rotation | 21 Sep 2026 |
| IV-Aug | Icy Veins Augmentation rotation | 10 Aug 2026 |
| M-Aug | Method Augmentation playstyle & rotation | 25 Aug 2026 (**partly stale**: names Nexus-King Salhadaar and Dimensius, TWW 11.2 bosses) |
| WH-Aug | Wowhead Augmentation rotation | 17 Aug 2026 |

There is no SimC APL for Preservation (the `default` folder only has `evoker_augmentation.simc` and
`evoker_devastation.simc`, MEASURED via the GitHub contents API, midnight branch).

All 21 spell IDs on the three cards resolve to the right name and a 12.1 description in DB2 69933 (MEASURED):
375087 Dragonrage, 370553 Tip the Scales, 359073 Eternity Surge, 357208 Fire Breath, 356995 Disintegrate,
361469 Living Flame, 362969 Azure Strike, 357211 Pyre, 357210 Deep Breath, 373861 Temporal Anomaly,
355936 Dream Breath, 364343 Echo, 355913 Emerald Blossom, 360995 Verdant Embrace, 363534 Rewind,
359816 Dream Flight, 395152 Ebon Might, 409311 Prescience, 403631 Breath of Eons, 396286 Upheaval, 395160 Eruption.

### Empower spells in plain words (applies to all three cards)
- You hold the key; the spell charges up through levels I, II, III (IV with the Font of Magic talent 375783/408083/
  411212, "maximum level is increased by 1"); you let go to cast it at the level you reached. MEASURED (DB2 descriptions
  of 357208/355936/359073/396286 list I/II/III; Font of Magic text).
- **Fire Breath and Dream Breath: every level does the same total.** DB2 SpellDescriptionVariables 357208: level I =
  hit + 10 units over 20 s, II = hit + 3 units now + 7 over 14 s, III = hit + 6 now + 4 over 8 s (IV: + 9 now + 1 over
  2 s). Dream Breath 355936: I = s3 now + 8 ticks over 16 s, II = s3+2 now + 6 over 12 s, III = s3+4 now + 4 over 8 s.
  Same total at every level; a higher level only moves healing/damage from the over-time part to the first hit.
  MEASURED. M-Pres says the same in words ("always do the same healing/damage, but do more of it upfront").
- Eternity Surge: I/II/III hits 1/2/3 enemies (2/4/6 with Eternity's Span 375757). Upheaval: I/II/III/IV = 3/6/9/12 yd
  radius. MEASURED (DB2).
- Not measured: whether the 12.1 client offers a "tap instead of hold" option for empowers. The texts below say
  "hold the key", which is the default described by the spells themselves ("Inhale ... Release to exhale").

---

# 1. Devastation Evoker (1467)

Card now: S1 Dragonrage, then TtS + Eternity Surge · S2 FB + ES on cooldown, first level · S3 Disintegrate / Essence
Burst · S4 Living Flame, Azure Strike on the move · AOE Azure Strike filler, Pyre at 5+.

## 1.1 W lines

**PLAYCARD_1467_W1**
- en: `{SPELL:375087} makes {SPELL:361469} and {SPELL:362969} always light up Essence Burst: lots of free {SPELL:356995}s. With the Animosity talent every empower spell makes it last longer, and {SPELL:370553} makes the next one instant.`
- nl: `{SPELL:375087} zorgt dat {SPELL:361469} en {SPELL:362969} altijd Essence Burst laten oplichten: veel gratis {SPELL:356995}s. Met het talent Animosity maakt elke empower-spell hem langer, en {SPELL:370553} maakt de volgende instant.`
- Mechanic:
  - Dragonrage 375087: "For $d, Essence Burst's chance to occur is increased to $s2%"; SpellEffect #1 = 100, duration
    18 s (SpellMisc dur idx 85), cooldown 120 s (SpellCooldowns), exhales 3 Pyres (375088 = 3). MEASURED DB2 69933.
  - "guarantees Essence Burst procs from Living Flame and Azure Strike" WH-Dev 9 Sep; IV-Dev 10 Aug same. MEASURED.
  - Animosity 375797 (talent): each empower cast extends Dragonrage by 5 s, 25% less each time. MEASURED DB2. All three
    guides build around it (M-Dev "bread and butter", WH-Dev, IV-Dev "only possible when talented into Animosity").
    MEASURED.
  - Tip the Scales 370553: "next empowered spell cast instantly at its maximum empower level", 120 s cooldown. MEASURED.

**PLAYCARD_1467_W2**
- en: `Empower spells charge up while you hold the key; let go to cast. A higher level of {SPELL:357208} does no more damage in total, it only burns shorter, and {SPELL:359073} only hits more enemies. So on one enemy the first level is quickest and loses nothing.`
- nl: `Empower-spells laden op zolang je de toets ingedrukt houdt; laat los om te casten. Een hoger niveau van {SPELL:357208} doet in totaal niet meer schade, hij brandt alleen korter, en {SPELL:359073} raakt alleen meer vijanden. Bij één vijand is het eerste niveau dus het snelst en kost het niets.`
- Mechanic: see "Empower spells" above (FB same total, ES targets per level). MEASURED DB2. Single-target rank 1 for both:
  IV-Dev, M-Dev, WH-Dev, APL-Dev (`fb_*` and `es` lists start with `empower_to=1` for 1 target). MEASURED.
  "Quickest": holding longer takes more cast time, WH-Aug 17 Aug ("requires additional cast time"). MEASURED.

**PLAYCARD_1467_W3**
- en: `{SPELL:356995} is your big beam and costs 3 Essence. Essence Burst makes the next one free, but you can't save up many, so use it before a new one lights up.`
- nl: `{SPELL:356995} is je grote straal en kost 3 Essence. Essence Burst maakt de volgende gratis, maar je kunt er maar weinig bewaren, dus gebruik hem voordat er een nieuwe oplicht.`
- Mechanic: Disintegrate costs 3 Essence (SpellPower, power type 19), 3 s channel. Essence Burst 359618 "Your next
  Disintegrate or Pyre costs no Essence", 15 s, holds 1 (SpellAuraOptions CumulativeAura 1), 2 with Essence Attunement
  375722 ("stacks 2 times"). MEASURED DB2. "use it before a new one" = INFERRED from the stack cap (WH-Aug says the same
  for Aug: "only stacks up to 2 ... spend when capped", MEASURED).

**PLAYCARD_1467_W4**
- en: `{SPELL:361469} and {SPELL:362969} fill the gaps and can light up Essence Burst. {SPELL:362969} is instant, so it is your button while you run.`
- nl: `{SPELL:361469} en {SPELL:362969} vullen de gaten en kunnen Essence Burst laten oplichten. {SPELL:362969} is instant, dus die druk je als je moet lopen.`
- Optional third sentence ONLY if the card's S4 gets Azure Sweep (see 1.5 E1):
  en `After {SPELL:359073} it turns into the stronger Azure Sweep for a while: use that first.` /
  nl `Na {SPELL:359073} wordt hij een tijdje de sterkere Azure Sweep: gebruik die eerst.`
- Mechanic: Ruby Essence Burst 376872 = Living Flame 20%, Azure Essence Burst 375721 = Azure Strike 15% chance (both
  talents, TraitDefinition). MEASURED DB2. "filler spells that generate Essence Burst" WH-Dev. MEASURED. Azure Strike is
  instant: IV-Aug FAQ and M-Pres ("it is instant"). MEASURED. Azure Sweep talent 1265867: "Eternity Surge upgrades your
  next Azure Strike to Azure Sweep, damaging all nearby enemies and dealing 75% additional damage"; buff 1265871 30 s.
  MEASURED DB2.
- Not measured: the exact cost of Living Flame / Azure Strike (I did not read their SpellPower rows), so the line does
  not say "free".

**PLAYCARD_1467_WAOE**
- en: `{SPELL:362969} hits 2 enemies at once. {SPELL:357211} costs the same 3 Essence as {SPELL:356995} but hits everything around your target, so on a big pack it does more.`
- nl: `{SPELL:362969} raakt 2 vijanden tegelijk. {SPELL:357211} kost dezelfde 3 Essence als {SPELL:356995}, maar raakt alles rond je doelwit: bij een grote groep doet hij dus meer.`
- If the AOE text gets the Eternity Surge sentence (1.5 E2), add: en `{SPELL:359073} hits one more enemy per level, so hold it longer on a pack.` / nl `{SPELL:359073} raakt per niveau één vijand meer, dus houd hem langer vast bij een groep.`
- Mechanic: Azure Strike "Project intense energy onto $s1 enemies", s1 = 2. Pyre "your target and all enemies within
  $A1 yds", 3 Essence. Disintegrate 3 Essence, one target. MEASURED DB2. Pyre wins at 3+ (IV-Dev FAQ), 4+ (M-Dev), 5+
  (IV-Dev Scalecommander M+, APL-Dev `sc` list). MEASURED; the line avoids the number on purpose.

## 1.2 TERMS (PLAYCARD_1467_TERMS) - one word carries the card: Essence
- en: `Essence is your Evoker bar: up to 5 orbs (6 with a talent) that slowly fill by themselves. {SPELL:356995} and {SPELL:357211} cost 3. Essence Burst is a free charge: the next one costs nothing.`
- nl: `Essence is je Evoker-balk: tot 5 bolletjes (6 met een talent) die vanzelf langzaam vollopen. {SPELL:356995} en {SPELL:357211} kosten er 3. Essence Burst is een gratis lading: de volgende kost niets.`
- Mechanic: PowerType ESSENCE (enum 19): MaxBasePower 5, regen 0.2/s in and out of combat. Power Nexus 369908 "Increases
  your maximum Essence" (talent). Disintegrate/Pyre cost 3. MEASURED DB2. Empower levels are explained in W2, so TERMS
  does not repeat them.
- Spell ID for "Essence Burst" if you want it as {SPELL}: the Devastation passive 359565 is **not** a talent
  (no TraitDefinition row) and **not** in SpecializationSpells for 1467, so I cannot say the client reports it as known.
  The talents the player actually picks are 376872 "Ruby Essence Burst" and 375721 "Azure Essence Burst" (both
  TraitDefinition, MEASURED). Recommendation: keep "Essence Burst" as plain words on this card.

## 1.3 Quiz (last {SPELL} per step, and whether that is fair)

| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 359073 Eternity Surge | no, the step is about Dragonrage | `[1] = 375087` |
| S2 | 359073 Eternity Surge | half; ES is also in S1, Fire Breath is asked nowhere | `[2] = 357208` |
| S3 | 356995 Disintegrate | yes | - |
| S4 | 362969 Azure Strike | no, Azure Strike is the moving exception; the filler is Living Flame | `[4] = 361469` |
| AOE | 356995 Disintegrate | no, that is the spell you STOP using | `AOE = 357211` |

Proposed: `quizAnswer = { [1] = 375087, [2] = 357208, [4] = 361469, AOE = 357211 }`. Pool = 8 spells, enough.
Plain-text mentions of an answer spell: none ("Essence Burst" is plain but never an answer).
If S4/AOE are rewritten as proposed in 1.5, the overrides above still point at a spell in that step's text.

## 1.4 Where the two routes disagree
- **Tip the Scales target.** M-Dev (SC opener: Dragonrage, "Tip the Scales & on use trinket", Eternity Surge) and WH-Dev
  (SC priority: Dragonrage, Tip the Scales, Eternity Surge) put TtS on Eternity Surge, like card S1. APL-Dev `sc` list
  uses TtS when Fire Breath is ready, after the ES list (also before 12.1). IV-Dev does not mention TtS in its
  single-target lists. For Flameshaper all agree TtS goes on ES (APL `use_tts`, WH-Dev "Do not use Tip the Scales on Fire
  Breath. This is a massive damage loss"). MEASURED. Card S1 follows two guides: no change proposed.
- **Fire Breath level in AoE.** IV/M/WH: Fire Breath always level 1. APL-Dev since 15 Sep (d87a103): Scalecommander
  uplevels FB to 2/3/4 at 2/3/4 targets. MEASURED. Card MISTAKE ("first level is best") stays right on one target.
- **AoE filler.** M-Dev (Azure Strike on 3+), WH-Dev AoE and IV-Dev SC M+ agree with card AOE; APL keeps Living Flame
  above Azure Strike at every target count. MEASURED.

## 1.5 Card errors / gaps (Devastation)
- **E1 - S4 misses Azure Sweep (all four sources).** IV-Dev: "Cast Azure Sweep when available" above Living Flame
  (SC and FS); M-Dev: "Cast Azure Sweep as filler if you have a stack, if not use Living Flame"; WH-Dev: "Azure Sweep if
  not capped on Essence Burst" above "Living Flame as filler"; APL-Dev 15 Sep: `azure_sweep` above the Living Flame filler
  in both hero lists. MEASURED. It is the Azure Strike button after Eternity Surge (talent 1265867, MEASURED). Proposal S4:
  `Nothing else ready? After {SPELL:359073}, {SPELL:362969} turns into {SPELL:1265867}: press it. Otherwise {SPELL:361469}. On the move: {SPELL:362969}.`
  (1265867 is the talent the player knows, named "Azure Sweep"; not client-checked that it shows gold.)
- **E2 - AOE misses "hold Eternity Surge longer".** IV-Dev SC M+: "Eternity Surge at rank 1 or matching the target
  count, 2/4/6 targets for each Empower level"; M-Dev multi-target SC: "Eternity Surge matching the rank with the amount of
  enemies"; APL-Dev 15 Sep: ES level = enemy count (halved with Eternity's Span). Only WH-Dev (9 Sep, older than the APL
  change) says upranking is not worth it. MEASURED. Proposal: add to AOE `Hold {SPELL:359073} longer: each level hits more enemies.`
- **E3 (optional) - Unbound Flame is nowhere on the card.** Rising Fury (apex, talent 1271788): when Dragonrage ends
  "Dragonrage becomes Unbound Flame", 4 casts (SpellAuraOptions CumulativeAura 4), each always crits and gives Essence
  Burst (1292321). MEASURED DB2. IV-Dev, M-Dev, WH-Dev and APL all use it. Plain text recommended: the cast spell 1292321
  only exists while Dragonrage is swapped, and the talent 1271788 is named "Rising Fury", not "Unbound Flame".
- Everything else checked and right: Dragonrage every 2 minutes (120 s, MEASURED); HERO1 (Deep Breath on cooldown, before
  Dragonrage, cancel the flight: IV-Dev, WH-Dev "Use the Deep Breath cancel macro", APL `deep_breath` first in `sc` with
  `cancel_if`); HERO2 (Consume Flame 444088: "Disintegrate consumes 1.0 sec of Fire Breath ... detonating it for 150%",
  Pyre 4 s for 115%; "no TtS on Fire Breath" WH-Dev). Source line dates match the pages.

## 1.6 12.1.5
- PTR-notes: no Devastation entry in any post (Evoker entries only under Preservation and Augmentation). MEASURED.
- PTR-DB2: no change for any Devastation ID used above (descriptions, effects, cooldowns, charges, costs, aura options,
  durations). MEASURED. -> No change to W, TERMS or card. The `why` gate hides these lines on 120105 anyway.

---

# 2. Preservation Evoker (1468)

Card now: S1 Temporal Anomaly · S2 Dream Breath first level, lights Merithra's Blessing · S3 Echo / Essence Burst ->
Emerald Blossom · S4 Merithra's Blessing (plain text) · S5 Verdant Embrace / Living Flame on enemy · AOE Echo, Rewind /
Dream Flight.

## 2.1 W lines

**PLAYCARD_1468_W1**
- en: `{SPELL:373861} flies forward in a line: it shields everyone it touches and puts a weaker Echo on up to 5 of them. It needs no Essence, so your Essence stays free for more Echo.`
- nl: `{SPELL:373861} vliegt in een rechte lijn vooruit: hij geeft iedereen die hij raakt een schild en zet een zwakkere Echo op hoogstens 5 van hen. Hij kost geen Essence, dus je Essence blijft vrij voor meer Echo.`
- Mechanic: "Send forward a vortex ... absorbing damage on you and any allies in its path ... Applies Echo at $s4%
  effectiveness on the first $s2 allies" (s2 = 5, s4 = 30); cost 7.5% mana, no Essence; 15 s cooldown. MEASURED DB2.
  IV-Pres "most of your Echos will come through Temporal Anomaly"; M-Pres "most efficient way to apply Echo to multiple
  targets"; WH-Pres "Cast Temporal Anomaly the moment it comes off cooldown". MEASURED.
- Do NOT call it cheap: WH-Pres calls it "our most expensive spell" (mana). MEASURED.

**PLAYCARD_1468_W2**
- en: `Every level of {SPELL:355936} heals the same in total; the first level just spreads it over a longer time and is quickest to cast. Every {SPELL:355936} also lights up Merithra's Blessing for you.`
- nl: `Elk niveau van {SPELL:355936} healt in totaal evenveel; het eerste niveau spreidt het alleen over een langere tijd en is het snelst gecast. Elke {SPELL:355936} laat ook Merithra's Blessing voor je oplichten.`
- Mechanic: Dream Breath totals per level (see Empower section). MEASURED DB2; M-Pres "Its total healing stays the same
  regardless of Empower rank, so you will usually cast it at Rank 1". MEASURED. Merithra's Blessing rank 1256689 (talent):
  "Dream Breath has a $s2% chance to grant Merithra's Blessing", s2 = 100. MEASURED DB2; M-Pres "always grants", WH-Pres
  "pressing Dream Breath guarantees you a Merithra's Blessing proc", IV-Pres "guarantee procs". MEASURED. That the
  max-level player has this apex rank is INFERRED (all three guides assume it).

**PLAYCARD_1468_W3**
- en: `{SPELL:364343} costs 2 Essence and makes your next heal also land on that friend. {SPELL:355913} costs 3, so cast it when Essence Burst makes it free: it does not use up your Echoes.`
- nl: `{SPELL:364343} kost 2 Essence en laat je volgende heal ook op die vriend landen. {SPELL:355913} kost 3, dus cast hem als Essence Burst hem gratis maakt: hij gebruikt je Echo's niet op.`
- Mechanic: Echo cost 2 Essence, Emerald Blossom 3 Essence (SpellPower). Preservation Essence Burst 369299 "Your next Echo,
  Emerald Blossom, or Disintegrate is free"; Echo "Essence spells cannot be Echoed". MEASURED DB2. "Emerald Blossom no
  longer consumes Echo": IV-Pres, M-Pres, WH-Pres. "only cast it when you have Essence Burst": IV-Pres FAQ. MEASURED.
  Twin Echoes 1242031 (talent): Emerald Blossom makes your next Echo also hit a nearby ally, stacks 2 (MEASURED) - left out
  to keep the line short.

**PLAYCARD_1468_W4** (the step itself has no {SPELL}, see 2.4)
- en: `Merithra's Blessing is a stronger {SPELL:366155} that shows up on that button: it heals your target and then jumps to 4 more friends. Everyone with Echo gets a copy too, so cast it when Echo is out.`
- nl: `Merithra's Blessing is een sterkere {SPELL:366155} die op die knop verschijnt: hij healt je doelwit en springt daarna door naar 4 andere vrienden. Iedereen met Echo krijgt ook een kopie, dus cast hem als er Echo uitstaat.`
- Mechanic: talent 1256577 "Essence abilities have a chance to infuse your next Reversion ... upgrading it to Merithra's
  Blessing"; aura 1256579 "Reversion is upgraded to Merithra's Blessing"; cast 1256581 heals the target "and up to
  ${$x2-1} other allies within $s3 yards", chain targets 5 -> 4 others, 30 yd. MEASURED DB2. M-Pres: "first heals the
  primary target, then bounces up to 4 additional times"; WH-Pres: Echo "duplicate[s] whatever spell you cast to all of
  them", "Merithra's Blessing also puts a full strength Reversion on the target"; IV-Pres M+: "placing Reversion on every
  player who had Echo". MEASURED.
- {SPELL:366155} (Reversion) is not on the card yet; it is a real Preservation talent (TraitDefinition, MEASURED). If
  you prefer no new spell in a W line, write "a stronger Reversion" in plain words.
- No duration in the line on purpose: the proc lasts 60 s on 12.1.0 and 30 s on 12.1.5 (see 2.6).

**PLAYCARD_1468_W5**
- en: `{SPELL:360995} flies you to one friend and heals them a lot at once: your fastest help for one person. {SPELL:361469} on an enemy gives back some mana and can light up Essence Burst.`
- nl: `{SPELL:360995} vliegt je naar één vriend en healt die meteen flink: je snelste hulp voor één persoon. {SPELL:361469} op een vijand geeft wat mana terug en kan Essence Burst laten oplichten.`
- Mechanic: Verdant Embrace "Fly to an ally and heal them", 24 s charge. MEASURED DB2. M-Pres "your go-to single-target
  heal ... strong direct heal". MEASURED. Living Flame on an enemy refunds mana: IV-Pres ("cast offensively, it will refund
  some of the mana cost"), WH-Pres ("large mana refund"). MEASURED. Preservation Essence Burst 369297: Living Flame 20%,
  Reversion 15% chance. MEASURED DB2 (M-Pres quotes the same 20%/15%).

**PLAYCARD_1468_WAOE**
- en: `Echo first, heal second: one heal then lands on everyone with Echo, so set it up before the damage comes. {SPELL:363534} gives back part of the damage everyone near you took in the last few seconds; {SPELL:359816} heals everyone you fly over.`
- nl: `Eerst Echo, dan healen: één heal landt dan op iedereen met Echo, dus zet het klaar vóór de schade komt. {SPELL:363534} geeft iedereen bij je een deel terug van de schade van de laatste paar seconden; {SPELL:359816} healt iedereen waar je overheen vliegt.`
- Mechanic: Rewind "Rewind X% of damage taken in the last N seconds by all allies within Y yds", 240 s; Dream Flight "fly
  to the targeted location, healing all allies in your path", 120 s, talent. MEASURED DB2. "prepare first, heal second" /
  "build an Echo ramp" M-Pres. MEASURED.

## 2.2 TERMS (PLAYCARD_1468_TERMS) - one word carries the card: Echo
- en: `Echo is a bronze mark on a friend. The next heal you cast (not an Essence spell) is also cast on everyone with Echo, a bit weaker. {SPELL:364343} gives a full Echo for 2 Essence; {SPELL:373861} gives weaker ones without Essence.`
- nl: `Echo is een bronzen merkje op een vriend. De volgende heal die je cast (geen Essence-spell) wordt ook gecast op iedereen met Echo, iets zwakker. {SPELL:364343} geeft een volle Echo voor 2 Essence; {SPELL:373861} geeft zwakkere zonder Essence.`
- Mechanic: Echo 364343 (Bronze) "causing your next healing spell to cast an additional time on that ally at 70%",
  "Essence spells cannot be Echoed"; Temporal Anomaly "Echo at 30% effectiveness". MEASURED DB2. WH-Pres: "The next
  spell you cast on any target will consume all Echo buffs you have out and duplicate whatever spell you cast to all of
  them"; consumed by Living Flame, Verdant Embrace, Reversion, Dream Breath, not by Emerald Blossom. MEASURED.
- The EASY line already gives the short version; TERMS adds the two exceptions a beginner trips over.

## 2.3 Quiz

| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 373861 Temporal Anomaly | yes | - |
| S2 | 355936 Dream Breath | yes ("Merithra's Blessing" is plain text and never an answer) | - |
| S3 | 355913 Emerald Blossom | acceptable; the step's main point is "spend Essence on Echo", and Echo is asked nowhere else | optional `[3] = 364343` |
| S4 | **no {SPELL} at all** | **cannot be asked** (flag) | see 2.4 E1; then `[4] = 1256577` |
| S5 | 361469 Living Flame | no; LF is already the MISTAKE, the step's point is the spot heal | `[5] = 360995` |
| AOE | 359816 Dream Flight | no; it is the optional talent ("if you took it") | `AOE = 363534` |

Proposed: `quizAnswer = { [5] = 360995, AOE = 363534 }` (+ `[3] = 364343` if you want Echo asked; + `[4] = 1256577` after
the S4 rewrite). Plain-text "Echo" stands in IDEA, S1, S4 and AOE; none of those steps has Echo as its answer, and S3
(where Echo would be the answer) has no plain "Echo". Plain "Merithra's Blessing" in S2 is harmless; in S4 it would leak
the answer if S4 asks 1256577, so the rewrite below drops the plain name from S4.

## 2.4 Card errors / gaps (Preservation)
- **E1 - S4 has no spell, so it is not in the quiz, and it never says WHERE Merithra's Blessing appears.** It is the
  Reversion button lighting up (aura 1256579 "Reversion is upgraded to Merithra's Blessing", MEASURED DB2; IV/M/WH all
  call it an upgraded Reversion, MEASURED). Reversion is nowhere on the card, while M-Pres calls it "your main maintenance
  HoT" (MEASURED). Proposal S4:
  `{SPELL:366155} lit up as {SPELL:1256577}? Press it: everyone with Echo gets it too.`
  (1256577 = the talent named "Merithra's Blessing", TraitDefinition MEASURED; not client-checked that it shows gold.
  S2 can keep its plain "Merithra's Blessing".)
- **E2 (nuance, no change) - Dream Breath uses up Echoes.** WH-Pres: Echo is consumed by Living Flame, Verdant Embrace,
  Reversion and Dream Breath; Chronowarden "Cast it after you have consumed Echo buffs". But IV-Pres M+ (Flameshaper) says
  Echoing Dream Breath is your most important Echo in M+. Sources disagree, so S2 stays.
- Checked and right: S1, S3, S5, AOE, MISTAKE (Living Flame healing is mana-expensive: IV-Pres, WH-Pres), EASY. HERO1:
  Legacy of the Lifebinder 1264269 "Dream Breath and Fire Breath gain an additional charge" (MEASURED DB2), WH-Pres "keep
  one Dream Breath charge on cooldown at all times and use both when we're in danger", Flameshaper recommended in all
  content (WH-Pres, IV-Pres, M-Pres raid). HERO2: Temporal Burst 431695 (TtS -> haste) and Primacy 431657 ("For each
  healing over time effect from Verdant Embrace, gain 3% haste, up to 9%"). MEASURED DB2.
- Not an error: Spiritbloom is absent from the card, and none of the three 12.1 guides uses it. Temporal Barrier
  1291636 is a talent that replaces Temporal Anomaly (TraitDefinition OverridesSpellID 373861, MEASURED), but no guide
  picks it.

## 2.5 Where the two routes disagree
No Preservation APL exists, so only guides vs DB2. They agree on every number used above (Echo/Emerald Blossom costs,
Living Flame/Reversion Essence Burst chances, Merithra's Blessing 4 bounces, Dream Breath always granting it).

## 2.6 12.1.5
- PTR-notes 15 Sep: "Merithra's Blessing duration reduced to 30 seconds (was 1 minute)." PTR-DB2 confirms: SpellMisc
  1256579 DurationIndex 3 (60 000 ms) on 69933 -> 9 (30 000 ms) on 70077. MEASURED both. No card or W text states the
  duration, so nothing breaks; it only makes S4 ("press it") more urgent. W4 avoids the number on purpose.
- PTR-notes 29 Sep: "Consume Flame no longer double dips from healing increases on the target"; two Chronowarden bug
  fixes. Tuning/bugs only, no text impact. MEASURED.
- PTR-DB2: no other change for the Preservation IDs above. MEASURED.

---

# 3. Augmentation Evoker (1473)

Card now: S1 Ebon Might, recast at 4 s or less · S2 Prescience on two best · S3 Breath of Eons on cooldown, then TtS +
Fire Breath · S4 FB + Upheaval during Ebon Might, first level · S5 Eruption, Living Flame · AOE hold Upheaval longer.

## 3.1 W lines

**PLAYCARD_1473_W1**
- en: `{SPELL:395152} makes your damage dealers stronger with part of your own main stat, and you hit harder too. Recast it with a few seconds left: the leftover time is added on, so there is no gap.`
- nl: `{SPELL:395152} maakt je schadespelers sterker met een deel van je eigen main stat, en jij raakt zelf ook harder. Cast hem opnieuw als er nog een paar seconden over zijn: de resttijd komt erbij, dus er zit geen gat in.`
- Mechanic: "Increase all damage dealing allies' primary stat by X% of your own and increase your own damage by 20% for
  $d" (395296 s1 = 20), 10 s, 30 s cooldown. MEASURED DB2. Pandemic: WH-Aug "add the remaining duration onto the new
  spell cast, provided that this is less than 30% of the base duration ... re-cast with no more than 3-4 seconds
  remaining"; IV-Aug "Cast Ebon Might if it has 4 or less seconds remaining". APL-Aug threshold
  `(remains - cast_time) <= duration * 0.4`. MEASURED. Card S1's "4 seconds" agrees with all of them.

**PLAYCARD_1473_W2**
- en: `{SPELL:409311} gives one friend extra crit, and with the Fate Mirror talent some of their hits get a small extra copy. Your best players get the most out of it, so give it to them.`
- nl: `{SPELL:409311} geeft één vriend extra crit, en met het talent Fate Mirror krijgen sommige van hun klappen een kleine extra kopie. Je beste spelers halen er het meest uit, dus geef hem aan hen.`
- Mechanic: Prescience "increasing their critical strike chance ... and occasionally copying their damage and healing
  spells at 15% power" (with Fate Mirror 412774), buff 18 s, 2 charges, 12 s recharge; with no ally targeted it picks a
  nearby damage dealer with cooldowns active. MEASURED DB2. IV-Aug "target the highest performing players"; WH-Aug "choose
  2-3 of your strongest dps players". MEASURED. Season 2 tier 4pc (1296638): Upheaval raises Fate Mirror to 45% for 8 s
  (MEASURED DB2 + IV-Aug).

**PLAYCARD_1473_W3**
- en: `{SPELL:403631} marks the enemies you fly over: while the mark lasts, part of all damage from your {SPELL:395152} friends is saved up and hits them again. It also calls a copy of you (Duplicate talent), so pressing it on cooldown beats waiting; {SPELL:370553} then makes {SPELL:357208} instant at its top level.`
- nl: `{SPELL:403631} markeert de vijanden waar je overheen vliegt: zolang het merk duurt, wordt een deel van alle schade van je {SPELL:395152}-vrienden gespaard en raakt het ze nog een keer. Hij roept ook een kopie van jou op (talent Duplicate), dus op cooldown drukken is beter dan wachten; {SPELL:370553} maakt daarna {SPELL:357208} instant op het hoogste niveau.`
- Mechanic: Breath of Eons 120 s; Temporal Wound 409560 10 s, "15% of damage dealt by allies affected by Ebon Might is
  copied as additional Arcane damage ... after 10 s". Duplicate 1259173 (apex talent): "Breath of Eons summons a version of
  you from the future ... casts Eruption, Fire Breath, and Upheaval", 20 s. MEASURED DB2. IV-Aug FAQ: "use Breath of Eons
  on cooldown to maximise the uptime of Duplicate". MEASURED. TtS -> FB: WH-Aug opener "Fire Breath at Max Rank from Tip
  the Scales", IV-Aug "Cast Tip the Scales if Fire Breath is up", APL-Aug TtS `if ... cooldown.fire_breath.up`. MEASURED.
- This is 3 clauses; if too long, drop the TtS clause (S3's quiz answer will be Breath of Eons anyway).

**PLAYCARD_1473_W4** (two versions: pick the one that matches what you decide for S4, see 3.4 E1)
- (a) card keeps "first level": en `Each empower spell makes {SPELL:395152} last a bit longer, so only cast them while it runs. {SPELL:396286} only gets a bigger circle when you hold it longer, so on one enemy the first level is enough.`
  nl `Elke empower-spell laat {SPELL:395152} iets langer duren, dus cast ze alleen terwijl hij loopt. {SPELL:396286} krijgt alleen een grotere cirkel als je hem langer vasthoudt, dus bij één vijand is het eerste niveau genoeg.`
- (b) card changes to "Fire Breath to the top level": add en `A top-level {SPELL:357208} makes your next {SPELL:361469} fly at more targets, and each one can light up Essence Burst.` / nl `Een {SPELL:357208} op het hoogste niveau laat je volgende {SPELL:361469} op meer doelen afvliegen, en elk kan Essence Burst laten oplichten.`
- Mechanic: Sands of Time 395153: empower spells extend Ebon Might by 2 s (s2 = 2000), Eruption 1 s, Breath of Eons /
  Deep Breath 5 s. Upheaval "Empowering expands the area of effect", 3/6/9(/12) yd. Leaping Flames 369939 "Fire Breath
  causes your next Living Flame to strike 1 additional target per empower level". MEASURED DB2. IV-Aug FAQ: "You should
  not cast them if it is down as it will waste the extension". WH-Aug: higher FB rank -> more Leaping Flames projectiles,
  "each ... has an individual chance to generate Essence Burst". MEASURED.

**PLAYCARD_1473_W5**
- en: `Each {SPELL:395160} makes {SPELL:395152} last a little longer, so that is where your Essence goes. {SPELL:361469} fills the gaps and can light up Essence Burst: a free {SPELL:395160}.`
- nl: `Elke {SPELL:395160} laat {SPELL:395152} iets langer duren, dus daar gaat je Essence naartoe. {SPELL:361469} vult de gaten en kan Essence Burst laten oplichten: een gratis {SPELL:395160}.`
- Mechanic: Eruption costs 3 Essence; Sands of Time +1 s per Eruption. Augmentation Essence Burst 396187 (talent): Living
  Flame 20%, Azure Strike 15% chance "to make your next Eruption cost no Essence". MEASURED DB2. APL-Aug: `eruption ... if
  buff.ebon_might_self.remains>execute_time`. MEASURED.

**PLAYCARD_1473_WAOE**
- en: `{SPELL:396286}'s circle grows with every level you hold it, so hold it until the circle covers the whole pack.`
- nl: `De cirkel van {SPELL:396286} groeit met elk niveau dat je hem vasthoudt, dus houd hem vast tot de cirkel de hele groep raakt.`
- Mechanic: Upheaval radius 3/6/9/12 yd per level. MEASURED DB2. WH-Aug "uprank Upheaval such that as many enemies as
  possible are within the area of effect"; M-Aug "uprank to make sure all enemies will be in its radius"; IV-Aug "at the
  lowest rank that can fit all enemies". MEASURED. (APL-Aug always uses level 1: it has no target-radius logic.)

## 3.2 TERMS (PLAYCARD_1473_TERMS) - the card leans on "spend while Ebon Might runs"
- en: `Essence is your Evoker bar: up to 5 orbs (6 with a talent) that slowly fill by themselves; {SPELL:395160} costs 3. While {SPELL:395152} runs, every {SPELL:395160}, empower spell and {SPELL:403631} makes it last longer: that is why you spend inside it.`
- nl: `Essence is je Evoker-balk: tot 5 bolletjes (6 met een talent) die vanzelf langzaam vollopen; {SPELL:395160} kost er 3. Zolang {SPELL:395152} loopt, maakt elke {SPELL:395160}, empower-spell en {SPELL:403631} hem langer: daarom geef je binnen die tijd uit.`
- Mechanic: PowerType ESSENCE max 5, regen 0.2/s; Power Nexus 369908; Eruption 3; Sands of Time 1 s / 2 s / 5 s.
  MEASURED DB2.

## 3.3 Quiz

| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 395152 Ebon Might | yes | - |
| S2 | 409311 Prescience | yes | - |
| S3 | 357208 Fire Breath | no, the step is about Breath of Eons | `[3] = 403631` |
| S4 | 395152 Ebon Might | no, that is the condition (and S1's answer) | `[4] = 357208` |
| S5 | 361469 Living Flame | no, the step's point is spending Essence on Eruption | `[5] = 395160` |
| AOE | 396286 Upheaval | yes | - |

Proposed: `quizAnswer = { [3] = 403631, [4] = 357208, [5] = 395160 }`. No plain-text answer leaks ("Essence" is plain
but never an answer).

## 3.4 Card errors / gaps (Augmentation)
- **E1 - S4 "Let go at the first level" is wrong for Fire Breath in 3 of 4 sources.** IV-Aug (10 Aug): "Cast Fire Breath
  at the highest rank available"; WH-Aug (17 Aug): "Fire Breath at Rank 1 or Max Rank ... consider casting Fire Breath at
  Rank 1 if Upheaval is off cooldown, or if there is less than 4-5 seconds ... remaining", otherwise max rank for Leaping
  Flames; APL-Aug (12.1 rewrite 11 Aug, unchanged in the 19 Sep version): `fire_breath,empower_to=1,if=...cooldown.upheaval.up`
  and `empower_to=3,if=...!cooldown.upheaval.up`. Only M-Aug says "Use Fire Breath at rank 1", and that page carries TWW
  11.2 boss names, so it is partly stale. MEASURED. Upheaval at level 1 on one target: all four agree. Proposal S4:
  `{SPELL:357208} and {SPELL:396286} on cooldown while {SPELL:395152} is up. {SPELL:396286}: let go at the first level. {SPELL:357208}: hold it to the top, unless {SPELL:396286} is ready too.`
  (last spell then = 396286; keep the override `[4] = 357208`.)
- **E2 - card source line cites "Method 25 Aug"**, whose Augmentation page mentions Nexus-King Salhadaar and Dimensius
  (Manaforge Omega, TWW). MEASURED. Worth knowing when the card is rechecked; its "Fire Breath at rank 1" is the one
  outlier in E1.
- **E3 (unverified, low priority) - HERO2 "The buttons stay the same."** IV-Aug's priority has "Cast Deep Breath on
  cooldown" right after Breath of Eons, and APL-Aug has an unconditional `deep_breath` line. I could not establish from
  DB2 whether an Augmentation Scalecommander really has both buttons. INFERRED only; check in game before changing.
- Checked and right: S1 (4 s), S2, S3 (TtS + Fire Breath after Breath of Eons), S5, AOE, MISTAKE (IV-Aug: do not cast
  empowers/Eruption without Ebon Might "as it will waste the extension"), HERO1 (Temporal Burst 431695 "increasing your
  haste, movement speed, and cooldown recovery rate"; IV-Aug: Chronowarden best for raid and high keys; WH-Aug "treat
  Temporal Burst from Tip the Scales as a major DPS cooldown and cast it alongside your Breath of Eons"), HERO2's "Eruption
  hits harder" (Mass Eruption 438587: empower spells make the next Eruption hit up to N targets, more damage per missing
  target). MEASURED.

## 3.5 Where the two routes disagree
- Fire Breath level: see E1 (APL + IV + WH vs Method).
- Filler: IV-Aug says Azure Strike is the better single-target builder for Scalecommander; WH-Aug "Living Flame as
  filler in nearly all situations"; APL-Aug picks by talents (`azure_st_filler`). Card S5 (Living Flame) is fine.
- Upheaval in AoE: guides uplevel for radius; APL always level 1 (no radius logic). Card AOE follows the guides.

## 3.6 12.1.5
- PTR-notes 29 Sep: Chronowarden "Temporality duration is now increased by Mastery: Timewalker. Temporal Burst duration is
  now increased by Mastery: Timewalker."; Scalecommander "Melt Armor damage increased by 100%". MEASURED. HERO1 ("makes you
  faster") stays true.
- PTR-DB2: Eruption 395160 SpellEffect #0 EffectBonusCoefficient 2.80 -> 3.22 (+15% damage). Nothing else changed for the
  Augmentation IDs above. MEASURED. No text uses damage numbers, so no W/TERMS/card change.

---

# 4. 12.1.5 summary for all three
- The only text-relevant change: Preservation's Merithra's Blessing proc lasts 30 s instead of 60 s (PTR-notes 15 Sep +
  PTR-DB2 SpellMisc). No line states the duration, so no rewrite is needed.
- Positive control for the DB2 diff: the same comparisons that found "no change" did find the Eruption coefficient
  (SpellEffect) and the Merithra's Blessing duration (SpellMisc), so they work. Compared: 75 Evoker IDs in Spell,
  SpellEffect, SpellCooldowns, SpellCategories, SpellAuraOptions, SpellPower; charge categories 2456/2054/2207/2010/
  2463/2471/2035 in SpellCategory; 27 IDs in SpellMisc (durations); TraitDefinition rows for 13 talents. A full-text scan
  of all 12.1.5 Spell descriptions naming an Evoker spell found only a wording change in Nozdormu Adept 431715.
- 70077 is a PTR build; the live 12.1.5 build may differ. The `why` gate (interface 120100) will hide these lines on
  120105 until someone rechecks; on the evidence above, the recheck should find nothing false.

# 5. Not measured (said so instead of left out)
- In-game: none of the proposed {SPELL} IDs (1265867, 1256577, 366155) was checked with IsPlayerSpell; they are
  TraitDefinition talents in DB2, which is a strong but not a client-side proof.
- Whether the client has a tap-instead-of-hold option for empowers.
- Living Flame / Azure Strike costs (their SpellPower rows were not read), so no line calls them free.
- Whether an Augmentation Scalecommander has Deep Breath besides Breath of Eons (3.4 E3).
