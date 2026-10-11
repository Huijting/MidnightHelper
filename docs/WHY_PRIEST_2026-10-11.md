# Priest: why lines, quiz, good to know (Discipline 256, Holy 257, Shadow 258)

Research by mh-research, 11 Oct 2026. Read only, no repo files touched. Cards read from `Modules/PlayCards.lua` and
`Locales/enUS.lua` / `nlNL.lua` (live folder, 11 Oct). Model read: `PLAYCARD_64_*`, `PLAYCARD_262_*`, `CARDS[64]`, `CARDS[262]`.

## Sources (all fetched 11 Oct 2026, `?nocache=20261011`)

Ground truth (game data):
- **[D1]** SimC `SpellDataDump/priest.txt`, branch `midnight`. Header: *SimulationCraft 1210-01 for 12.1.0.69933 Live*.
  Last commit 22 Sep 2026 ("[live] Game data update (Build 69933)"). This is Blizzard's DB2 plus the hotfix cache
  (it marks hotfixed values, e.g. Atonement's new "+40% outside a raid" effect).
- **[D2]** SimC `SpellDataDump/priest_ptr.txt`. Header: *12.1.5.70077 PTR*. Commit 30 Sep 2026.
- **[D3]** wago.tools DB2 in the browser: `Spell` 12.1.0.69933 for 33076 / 81749 / 228260 / 1227280 / 1253590 (text
  identical to D1, without hotfixes); `PowerType` 12.1.0.69933 (Insanity); `SpellMisc` 1253591 on 69933 and 70077;
  `SpellDuration` 70077 (index 3 = 60000 ms, index 9 = 30000 ms).
- **[A1]** SimC APL `ActionPriorityLists/default/priest_shadow.simc`, `midnight`, last commit 27 Sep 2026. Also read at
  commit c6da5e6 (11 Aug 2026) and 7970bb9 (18 May 2026, pre-12.1) to see what is new in 12.1.
  MEASURED: the `default` folder on `midnight` has **no** `priest_discipline.simc` or `priest_holy.simc` (GitHub API
  listing; direct raw URLs give 404). For Disc and Holy the ground truth is the DB2 only.
- **[F]** EU forum thread 627464 "Midnight: 12.1.5 PTR Development Notes": posts 3 Sep, 16 Sep (EU date; 15 Sep US),
  22 Sep, 29 Sep. Thread shows 6/6 posts; nothing after 29 Sep on 11 Oct.

Guides:
- **[G1]** Icy Veins Disc rotation, "Last Updated Aug 17, 2026" (Clandon). Hero badges read from the HTML: Oracle =
  "best choice" for Mythic Plus, Voidweaver = "best choice" for Raid.
- **[G2]** Method Disc playstyle, "Last Updated 17th Sep, 2026".
- **[G3]** Icy Veins Holy rotation, "Aug 25, 2026" (Niphyr). Oracle = best choice for Raid and M+.
- **[G4]** Method Holy playstyle, "17th Sep, 2026".
- **[G5]** Icy Veins Shadow rotation, "Aug 11, 2026" (Publik). Before 18 Aug, but the text is 12.1: it has Tentacle
  Slam, the 12.1 tier set and "pool Insanity if Voidform is ready in 25 s or less", which matches the 12.1 APL of
  11 Aug [A1] and is absent from the 18 May APL. Archon = best ST, Voidweaver = best AoE.
- **[G6]** Method Shadow playstyle, "27th Aug, 2026".
- **[G7]** Wowhead Shadow rotation, "Updated 2026/08/12" (EllipsisPriest).
- Not read: Wowhead Disc and Holy pages, individual Wowhead tooltips (the DB2 dump was used instead).

Every spell ID on the three cards exists in D1 (12.1.0.69933) with the expected name. Note the 12.1 names:
335467 = **Shadow Word: Madness**, 228260 = **Voidform**, 1227280 = Tentacle Slam, 1242173 = Void Volley,
1253593 = Void Shield, 186263 = Shadow Mend, 450215 = Void Blast (Disc), 450983 = Void Blast (Shadow). The client
resolves `{SPELL:id}`, so the names are not a problem.

---

## 256 Discipline Priest

### 1-2. W lines

**W1** (S1, Shadow Word: Pain)
- enUS: `{SPELL:589} keeps hurting the enemy on its own, and every tick heals your friends who have {SPELL:81749}. Its ticks can also power up your next {SPELL:47540}.`
- nl: `{SPELL:589} blijft de vijand vanzelf pijn doen, en elke tik healt je vrienden die {SPELL:81749} hebben. De tikken kunnen ook je volgende {SPELL:47540} sterker maken.`
- Mechanic: Atonement (81749) triggers on "Magic Hostile Spell, **Periodic**", so DoT ticks heal too. SW:P = 16 s DoT,
  tick every 2 s. Power of the Dark Side (198068, Disc talent row 2): SW:P has a chance (RPPM 1) to make the next
  Penance 30% stronger. D1 (12.1.0.69933, 22 Sep): **MEASURED**. "Keep SW:P applied at all times": G2 (17 Sep),
  G1 (17 Aug): **MEASURED**. That the talent is in the usual builds: G1 mentions Power of the Dark Side procs as
  normal play: **MEASURED** in G1; that every player has it: **INFERRED** (hence "can").

**W2** (S2, Power Word: Shield / Void Shield)
- enUS: `{SPELL:17} gives a friend {SPELL:81749} and a shield that soaks up damage. Sometimes the button turns into {SPELL:1253593}: that one shields several friends at once, so use it soon.`
- nl: `{SPELL:17} geeft een vriend {SPELL:81749} en een schild dat schade opvangt. Soms verandert de knop in {SPELL:1253593}: die schermt meerdere vrienden tegelijk af, dus gebruik hem snel.`
- Mechanic: PW:S absorbs damage for 15 s and applies Atonement (81749 description). Void Shield (1253593) "Shields
  $s2 allies", s2 = 3 (can be changed by Improved PW:S). It is not a separate button: the buff Master the Darkness
  (1253591) is an "Override Action Spell: Void Shield overrides Power Word: Shield". It comes from the Disc apex node
  Master the Darkness: rank 1 (1253590) Penance 25% chance; top rank (1253827) "Casting Mind Blast upgrades your next
  PW:S to Void Shield" and Void Shield reflects 10% of damage taken to enemies as Atonement healing. D1: **MEASURED**.
  The buff lasts 60 s live and **30 s on 12.1.5** (D3 SpellMisc DurationIndex 3 -> 9; F 16 Sep): **MEASURED**, hence
  "use it soon" without a number. G1: Penance proc works as a "4-card deck" (1 in 4 guaranteed): **MEASURED** in G1.
  Whether Void Shield puts Atonement on all three: G1 implies it ("maintain a non-insignificant number of Atonements
  naturally" through Void Shield), not stated in the DB2 text: **INFERRED**, so the line does not claim it.

**W3** (S3, Mind Blast + Penance)
- enUS: `Your damage heals every friend with {SPELL:81749}, so hitting on cooldown keeps the healing going. {SPELL:47540} hits hard and works while you walk; {SPELL:8092} can also turn your next {SPELL:17} into {SPELL:1253593}.`
- nl: `Je schade healt elke vriend met {SPELL:81749}, dus raken op cooldown houdt het healen gaande. {SPELL:47540} raakt hard en werkt terwijl je loopt; {SPELL:8092} kan ook je volgende {SPELL:17} in {SPELL:1253593} veranderen.`
- Mechanic: Atonement heals for a % of spell damage (s1 = 46) **MEASURED** D1. Penance "Castable while moving", can heal
  an ally instead, 3 bolts of SP 0.932 each (+1 bolt with Castigation) **MEASURED** D1. Mind Blast -> Void Shield =
  Master the Darkness top rank **MEASURED** D1; G1 "Mind Blast forcing a proc" **MEASURED** (17 Aug). Penance being
  the biggest hit: **INFERRED** from coefficients (see card error 1), so the line says "hits hard".

**W4** (S4, Smite / Shadow Mend / Flash Heal)
- enUS: `{SPELL:585} costs almost no Mana and still heals your {SPELL:81749} friends. {SPELL:186263} heals more than {SPELL:2061}, but at a price: your friend takes a little shadow damage afterwards.`
- nl: `{SPELL:585} kost bijna geen Mana en healt toch je vrienden met {SPELL:81749}. {SPELL:186263} healt meer dan {SPELL:2061}, maar het heeft een prijs: je vriend krijgt daarna wat shadow-schade.`
- Mechanic: Smite costs 0.4% base mana for Disc, the cheapest Disc damage spell (SW:P 1.8%, Mind Blast 1.5%, Penance
  1.28%) **MEASURED** D1. Shadow Mend (talent 1252217, row 8) "Flash Heal is upgraded to Shadow Mend, a stronger heal
  with a higher mana cost"; SP 8.74 vs Flash Heal 6.82; "the ally will take $s1/20 damage every tick until they have
  taken $s1/2 total damage from all sources, or leave combat" **MEASURED** D1. Both apply Atonement (81749 text)
  **MEASURED**. "a little" **INFERRED** (the counter includes damage they take anyway, so in a fight it ends fast).

**WAOE** (Power Word: Radiance + Evangelism)
- enUS: `{SPELL:194509} heals up to five friends at once and gives them all {SPELL:81749}, so your next hits heal the whole group. {SPELL:472433} casts a stronger one right away and makes your next two instant.`
- nl: `{SPELL:194509} healt tot vijf vrienden tegelijk en geeft ze allemaal {SPELL:81749}, dus je volgende klappen healen de hele groep. {SPELL:472433} cast er meteen een sterkere en maakt je volgende twee instant.`
- Mechanic: Radiance heals the target and s3 = 4 injured allies (5 total) and applies Atonement at 60% of its normal
  duration. Evangelism (472433, 90 s): "Immediately Power Word: Radiance your target at 150% effectiveness, and causes
  your next 2 casts of Power Word: Radiance to be instant cast with 40% reduced mana cost." D1 **MEASURED**. G2
  (17 Sep): Evangelism "doesn't extend your Atonements anymore, but instead applies five on its own and makes your next
  two Radiances instant" **MEASURED**. "five" and "two" are the point of the line and are DB2 values.

### 3. TERMS (Good to know): **Atonement** carries the card.
- enUS: `{SPELL:81749} is a mark you put on a friend with {SPELL:17}, {SPELL:194509}, {SPELL:2061} or {SPELL:186263}. While it lasts, part of all the damage you deal heals that friend. With more than 5 marked friends, each one gets a bit less.`
- nl: `{SPELL:81749} is een merkteken dat je op een vriend zet met {SPELL:17}, {SPELL:194509}, {SPELL:2061} of {SPELL:186263}. Zolang het er staat, healt een deel van al je schade die vriend. Met meer dan 5 vrienden met het merkteken krijgt ieder een beetje minder.`
- Mechanic: 81749 description lists exactly PW:S, Flash Heal, Shadow Mend, Plea, PW:Radiance; "Healing is reduced
  when healing more than $s2 targets", s2 = 5 **MEASURED** D1/D3. G1 (17 Aug) and G2 (17 Sep) both describe the
  falloff past 5 **MEASURED**. Duration (15 s, aura 194384) left out on purpose: Oracle's Preemptive Care changes it
  for Disc, Radiance gives 60%.

### 4. Quiz (pool = 589, 17, 81749, 1253593, 8092, 47540, 585, 186263, 2061, 194509, 472433)
| Step | Asked now (last {SPELL}) | Fair? | Proposal |
|---|---|---|---|
| S1 | 589 Shadow Word: Pain | yes | none |
| S2 | 1253593 Void Shield | yes, unambiguous ("When ___ lights up") | Keep. The point is 17, but blanking 17 is ambiguous: 194509, 2061 and 186263 also "give Atonement" to a friend, and two of them are drawn as wrong choices in about half the quizzes (INFERRED, 3 of 10 pool spells). Same pattern as Frost S1 (Glacial Spike), which has no override. Override 17 only if S2 says "a shield" (see card error 2). |
| S3 | 47540 Penance | yes | none |
| S4 | 2061 Flash Heal | no: asks the "if you did not pick the talent" fallback | `quizAnswer[4] = 585` ("Nothing else ready? ___") |
| AOE | 472433 Evangelism | so-so | `quizAnswer.AOE = 194509` ("___ gives everyone Atonement" is the point; only Radiance fits) |
Side note: 81749 is a hidden passive, so "Atonement" can show up as a wrong choice that is not a button. Harmless.

### 5. Card errors (Disc)
1. **S3 "your strongest hits"** is not true for Mind Blast as such. DB2 coefficients: Mind Blast SP 0.783 (+50% Disc
   passive), Smite SP 0.987 (+40% Disc passive), Penance 3 x 0.932. So a plain Mind Blast is no bigger than a Smite
   (INFERRED from D1 coefficients; other multipliers not simulated). Voidweaver's Overwhelming Shadows (1266883)
   doubles Mind Blast for Disc, so there it is a big hit (MEASURED D1). The real 12.1 reason to press Mind Blast on
   cooldown is Void Shield and, as Voidweaver, Entropic Rift (G1, G2, D1). Suggested text: `{SPELL:8092} and
   {SPELL:47540} whenever they are ready: they hit hard and power up your shields.` (W3 above is written so it is true
   with either text.)
2. **S2 "When {SPELL:1253593} lights up, use that."** Void Shield is not a separate button: PW:S turns into it
   (override aura, D1). From 12.1.5 the upgrade lasts 30 s instead of 60 s (D3, F). Suggested:
   `{SPELL:17} on a friend about to get hit: a shield, and it gives {SPELL:81749}. When it turns into {SPELL:1253593}, use it soon.`
3. **AOE "gives everyone"**: Radiance = target + 4 injured allies (D1). Everyone in a 5-player group, not in a raid.
   Minor; "gives up to five friends" would be exact.
4. HERO1/HERO2 "best in raids / best in dungeons": matches G1 badges (MEASURED). HERO2 "Penance gets a second charge":
   Oracle keystone Guiding Light (1248423) "Penance gains an additional charge" MEASURED D1. "PW:S right after each
   Penance": G2 (17 Sep) gives the reason, Weal and Woe (390786, a Disc talent, not Oracle): Penance bolts make the next
   PW:S bigger, 10 stacks. Correct as advice.
5. HERO1 Voidweaver: MEASURED D1. Disc Entropic Rift: "Mind Blast tears open an Entropic Rift" (447444). Void Blast
   (450405) "Entropic Rift upgrades Smite into Void Blast while it is active"; 450215 has a 1.5 s cast, so "stand
   still" is right. G2: stand still and chain Void Blast (Greater Smite). Possible addition: "(it takes the place of
   {SPELL:585})".
6. IDEA, EASY, S1, S4, MISTAKE: no errors found.

---

## 257 Holy Priest

### 1-2. W lines

**W1** (S1, Prayer of Mending)
- enUS: `{SPELL:33076} waits on a friend and heals them the moment they get hit, then jumps to another friend. Because it waits, casting it early is almost never wasted.`
- nl: `{SPELL:33076} wacht op een vriend en healt hem zodra hij geraakt wordt, en springt dan door naar een volgende. Omdat hij wacht, is vroeg casten bijna nooit verspild.`
- Mechanic: 33076 "Places a ward on an ally that heals them the next time they take damage, and then jumps to another
  ally. Jumps up to $s1 times and lasts $41635d after each jump" (41635 = 30 s); 12 s recharge, hasted for Holy. D1 + D3
  **MEASURED**. G4 (17 Sep): "Cast it as much as possible, even if everyone is at full health" **MEASURED**.
  "almost never wasted" **INFERRED** (it expires after 30 s without damage).

**W2** (S2, Holy Word: Serenity)
- enUS: `{SPELL:2050} is one of your biggest heals and costs less Mana than {SPELL:2061}. Every {SPELL:2061} you cast takes a few seconds off its cooldown, so it really comes back fast.`
- nl: `{SPELL:2050} is een van je grootste heals en kost minder Mana dan {SPELL:2061}. Elke {SPELL:2061} die je cast haalt een paar seconden van de cooldown af, dus hij komt echt snel terug.`
- Mechanic: Serenity SP 21.45 vs Flash Heal 6.82; mana 2.375% vs 2.61% base; 60 s cooldown, "Cooldown reduced by 6 sec
  when you cast Flash Heal" (Serendipity 63733). D1 **MEASURED**. G3 (25 Aug): "Holy Word: Serenity - 6 seconds each
  from Flash Heal" and "casting Flash Heal instead of Holy Word: Serenity" is the named mistake **MEASURED**.

**W3** (S3, Flash Heal with Surge of Light)
- enUS: `Your heals and {SPELL:585} sometimes light up Surge of Light: then {SPELL:2061} is instant and much cheaper. Every {SPELL:2061} also brings {SPELL:2050} back sooner.`
- nl: `Je heals en {SPELL:585} laten soms Surge of Light oplichten: dan is {SPELL:2061} instant en veel goedkoper. Elke {SPELL:2061} haalt ook {SPELL:2050} sneller terug.`
- Mechanic: Surge of Light (109186, class talent): "Your healing spells and Smite have a 8% chance to make your next
  Flash Heal instant and cost 50% less mana. Stacks to 2" (proc 114255, 20 s). D1 **MEASURED**.

**W4** (S4, Chastise / Holy Fire / Smite)
- enUS: `When nobody needs healing, hitting still helps: {SPELL:585} brings {SPELL:88625} back sooner and can light up Surge of Light. {SPELL:88625} also stops the enemy for a moment.`
- nl: `Als niemand heals nodig heeft, helpt slaan toch: {SPELL:585} haalt {SPELL:88625} sneller terug en kan Surge of Light laten oplichten. {SPELL:88625} legt de vijand ook even stil.`
- Mechanic: Serendipity: "Smite and Holy Nova reduce the cooldown of Holy Word: Chastise by 4 sec"; Chastise deals
  damage and incapacitates (stuns with Censure); Smite costs 0.2% base mana for Holy. D1 **MEASURED**. G3: Smite/Holy
  Nova as the cheap raid damage that also makes Surge of Light **MEASURED**.

**WAOE** (Prayer of Healing, Sanctify, Divine Hymn, Apotheosis)
- enUS: `{SPELL:596} heals five friends at once and brings {SPELL:34861} back sooner. {SPELL:64843} heals everyone near you and makes all healing on them stronger; {SPELL:200183} makes your Holy Words ready again right away.`
- nl: `{SPELL:596} healt vijf vrienden tegelijk en haalt {SPELL:34861} sneller terug. {SPELL:64843} healt iedereen om je heen en maakt alle heals op hen sterker; {SPELL:200183} maakt je Holy Words meteen weer klaar.`
- Mechanic: PoH heals target + ($s3-1) = 4 allies; Sanctify "Cooldown reduced by 6 sec when you cast Prayer of
  Healing"; with Ultimate Serenity PoH feeds Serenity instead (2050 text). Divine Hymn (180 s): heals all party/raid
  within 40 yd over 5 s, each heal +4% healing taken, stacking (5 max), and you gain Guardian Spirit while channeling.
  Apotheosis (120 s): resets the Holy Words (or gives a charge with Miracle Worker) and for 20 s triples their
  cooldown reduction and cuts their cost 70%. D1 **MEASURED**. G4 (17 Sep): Hymn "+20% healing taken ... Guardian
  Spirit", Apotheosis "reduces their mana cost by 70%" **MEASURED**.

### 3. TERMS (Good to know): **Holy Words** carries the card (IDEA, S2, AOE, HERO1).
- enUS: `Holy Words are three strong spells with a long cooldown: {SPELL:2050} for one friend, {SPELL:34861} for a group, {SPELL:88625} for an enemy. Each comes back sooner when you cast its partner: {SPELL:2061}, {SPELL:596} and {SPELL:585}.`
- nl: `Holy Words zijn drie sterke spells met een lange cooldown: {SPELL:2050} voor één vriend, {SPELL:34861} voor een groep, {SPELL:88625} voor een vijand. Elk komt sneller terug als je zijn partner cast: {SPELL:2061}, {SPELL:596} en {SPELL:585}.`
- Mechanic: Serendipity (63733) text, D1 **MEASURED**; G3 table of the same pairs **MEASURED**. Optional third
  sentence because of Ultimate Serenity (see 12.1.5): `A talent can replace {SPELL:34861}; then {SPELL:596} feeds {SPELL:2050}.` / nl: `Een talent kan {SPELL:34861} vervangen; dan voedt {SPELL:596} {SPELL:2050}.`

### 4. Quiz (pool = 33076, 2050, 2061, 88625, 14914, 585, 596, 34861, 64843, 200183)
| Step | Asked now | Fair? | Proposal |
|---|---|---|---|
| S1 | 33076 Prayer of Mending | yes | none |
| S2 | 2050 Serenity | yes | none |
| S3 | 2061 Flash Heal | yes | none |
| S4 | 585 Smite | yes (filler, and W4 explains it) | none |
| AOE | 200183 Apotheosis | fair ("for more Holy Words" only fits one spell) but not the point | `quizAnswer.AOE = 64843` ("Everyone low: ___") teaches the big group cooldown; default is acceptable |

### 5. Card errors (Holy)
1. **IDEA "Every normal heal you cast makes them come back sooner"** is too wide. Only Flash Heal (Serenity), Prayer of
   Healing (Sanctify, or Serenity with Ultimate Serenity) and Smite/Holy Nova (Chastise) do (D1 Serendipity, G3).
   PoM and Halo only with Voice of Harmony (G3, G4). Renew, Divine Hymn: no. Suggested:
   `Heal with your Holy Words. {SPELL:2061}, {SPELL:596} and {SPELL:585} make them come back sooner.`
   Same in EASY step 2: Flash Heal makes **{SPELL:2050}** come back sooner, not "your Holy Words".
2. AOE: guide order is Sanctify before Prayer of Healing (G3 raid and dungeon lists), and G3 says do not cast PoH in
   raid without Lightweaver or Surge of Light. G4's dungeon Oracle build has no PoH/Sanctify at all ("you only have
   Holy Word: Serenity, Prayer of Mending and Flash Heal", because Ultimate Serenity replaces Sanctify, D1). "if you
   have them" already covers it; no hard error.
3. S2 "Don't save it": G3 agrees (rotational). G4 adds two nuances: never sit on 2 charges (Miracle Worker), and in
   M+ keep Serenity for strong damage intake. Mild disagreement between the guides, not an error.
4. S3 (Surge of Light on Flash Heal): with Archon's Spiritwell both guides spend Surge of Light on PoH instead (G3, G4).
   Hero-specific; not an error for the card's base steps.
5. HERO1 Archon (Halo 120517, 60 s cooldown, before Apotheosis or Divine Hymn): D1 cooldown + G3 **MEASURED**.
   HERO2 Oracle: Guiding Light "Prayer of Mending gains an additional charge" **MEASURED** D1; casting on hurt friends:
   Prompt Prognosis "Casting Prayer of Mending heals your target" D1 + G3 **MEASURED**.
6. S1, S4, MISTAKE: no errors. MISTAKE is exact: Flash Heal costs more (2.61% vs 2.375%) and heals far less (D1).

---

## 258 Shadow Priest

### 1-2. W lines

**W1** (S1, Vampiric Touch + Shadow Word: Pain, Tentacle Slam)
- enUS: `Every shadow spell ticking on the enemy makes all your damage to it a bit stronger. {SPELL:34914} also heals you, and {SPELL:1227280} puts it on up to six enemies in one press.`
- nl: `Elke shadow-spell die op de vijand tikt, maakt al je schade op hem een beetje sterker. {SPELL:34914} healt jou ook, en {SPELL:1227280} zet hem in één klik op tot zes vijanden.`
- Mechanic: Mastery: Shadow Weaving (343690) "Your damage is increased by X% for each of Vampiric Touch, Shadow Word:
  Pain, and Shadow Word: Madness on the target. During Voidform, all targets receive the maximum effect." VT heals you
  for 30% of its damage. Tentacle Slam (1227280): 2 charges, "Applies Vampiric Touch to up to $s3 enemies", s3 = 6.
  Misery (238558, choice with Invoked Nightmare): VT also applies SW:P. D1 **MEASURED**. G5/G6/G7: keep both DoTs up
  **MEASURED**.

**W2** (S2, Voidform + Power Infusion)
- enUS: `{SPELL:228260} makes all your spells hit harder for a while, and {SPELL:10060} makes you cast faster. Both come back every two minutes, so use them together, once your shadow spells are already ticking.`
- nl: `{SPELL:228260} laat al je spells een tijdje harder raken, en {SPELL:10060} laat je sneller casten. Allebei komen ze elke twee minuten terug, dus gebruik ze samen, als je shadow-spells al tikken.`
- Mechanic: Voidform 228260: 1.5 s cast, 120 s cooldown, spell damage up for 20 s (194249), fires a Void Volley and
  turns into Void Volley up to 3 times. Power Infusion 10060: +20% haste for 15 s, 120 s cooldown. D1 **MEASURED**.
  APL [A1, 27 Sep]: `power_infusion,if=(buff.voidform.up|!talent.voidform)`, `voidform,if=active_dot.shadow_word_pain>=active_dot.vampiric_touch`,
  and the whole cds list only runs when `variable.dots_up` **MEASURED**. G6 Rule 1 "apply your DoTs BEFORE going into
  your cooldown windows" **MEASURED**.

**W3** (S3, Shadow Word: Madness)
- enUS: `The Insanity bar stops at 100 and does not drain in a fight, so anything you earn on a full bar is lost. Recasting {SPELL:335467} early is safe: the damage still left is added to the new one.`
- nl: `De Insanity-balk stopt bij 100 en loopt in een gevecht niet leeg, dus wat je op een volle balk verdient, ben je kwijt. {SPELL:335467} vroeg opnieuw casten kan geen kwaad: de schade die nog over was, komt bij de nieuwe.`
- Mechanic: wago PowerType 12.1.0.69933, INSANITY: MaxBasePower 10000 / DisplayModifier 100 = 100, RegenCombat 0,
  RegenPeace -100 (drains only out of combat) **MEASURED** D3. SW:M 335467: costs 50 Insanity (Mind's Eye -5,
  Distorted Reality +5), 6 s, "When reapplied to a target, all remaining damage is added to the new effect" **MEASURED**
  D1. APL [A1]: spend at `insanity.deficit<=35`, when SW:M has ≤ 1 GCD left, or always in Voidform **MEASURED**;
  G5 (11 Aug) same thresholds **MEASURED** (matches the 12.1 APL, so not a leftover). G7: "keep your insanity from
  capping at 100" **MEASURED**.

**W4** (S4, Mind Blast + Void Volley, Mind Flay)
- enUS: `{SPELL:8092} and {SPELL:1242173} give a lot of Insanity. {SPELL:1242173} shows up on the {SPELL:228260} button, during {SPELL:228260} or as a free bonus; {SPELL:15407} fills the gaps, and you may stop it as soon as something better is ready.`
- nl: `{SPELL:8092} en {SPELL:1242173} geven veel Insanity. {SPELL:1242173} verschijnt op de knop van {SPELL:228260}, tijdens {SPELL:228260} of als gratis extraatje; {SPELL:15407} vult de gaten, en je mag hem afbreken zodra er iets beters klaar is.`
- Mechanic: Void Volley 1242173 generates 10 Insanity, Mind Blast 6 (Shadow passive), Mind Flay 18 over a 4.5 s
  channel. Void Volley only exists as an override of the Voidform button: during Voidform (3 uses), Crushing Void
  (1279437, after Voidform ends) and the 12.1 tier 4pc (1296580: "Tentacle Slam has a 100% chance to grant a free use
  of Void Volley"). D1 **MEASURED**. Mind Flay clipping: APL `interrupt_if=ticks>=2` [A1] and G5 FAQ **MEASURED**.
  This also explains why G5/G6 openers cast Void Volley **before** Voidform: the free Void Volley sits on that button.

**WAOE** (Tentacle Slam on the pack, then Vampiric Touch)
- enUS: `{SPELL:1227280} puts {SPELL:34914} on up to six enemies in one press. Your direct hits then also splash onto every enemy with {SPELL:34914} (that is Psychic Link), so a dotted pack takes damage from every big hit.`
- nl: `{SPELL:1227280} zet {SPELL:34914} in één klik op tot zes vijanden. Je directe klappen spatten dan ook over op elke vijand met {SPELL:34914} (dat is Psychic Link), dus een groep met DoTs krijgt schade van elke grote klap.`
- Mechanic: Psychic Link (199484, Shadow talent row 2): "Your direct damage spells inflict 20% of their damage on all
  other targets afflicted by your Vampiric Touch" (hotfixed 25 -> 20) D1 **MEASURED**. G6 (27 Aug): "Every spell we
  have in our rotation cleaves from Psychic Link" **MEASURED**. "Enemies that live a while": APL hard-casts VT only
  when `target.time_to_die>12`, G5 says not under 18 s **MEASURED**. That everyone takes Psychic Link (row 2):
  **INFERRED**.

### 3. TERMS (Good to know): **Insanity** carries the card (IDEA, S3).
- enUS: `Insanity is your Shadow bar. {SPELL:8092}, {SPELL:34914}, {SPELL:15407} and your other spells fill it; {SPELL:335467} spends it. It stops at 100 and does not drain in a fight, so spend it before it is full.`
- nl: `Insanity is je Shadow-balk. {SPELL:8092}, {SPELL:34914}, {SPELL:15407} en je andere spells vullen hem; {SPELL:335467} geeft hem uit. Hij stopt bij 100 en loopt in een gevecht niet leeg, dus geef hem uit voordat hij vol is.`
- Mechanic: as W3 (D3 PowerType, D1 energize effects on MB/VT/MF/SW:P/Tentacle Slam/Void Volley) **MEASURED**.
  If TERMS is used, W3 could drop its first sentence to avoid saying it twice.

### 4. Quiz (pool = 34914, 589, 1227280, 228260, 10060, 335467, 8092, 1242173, 15407)
| Step | Asked now | Fair? | Proposal |
|---|---|---|---|
| S1 | 34914 Vampiric Touch | **no: gives itself away.** VT is in S1 twice; `GetPlayCardQuiz` blanks only the first (`gsub(..., 1)`), so "Tentacle Slam puts **Vampiric Touch** on many enemies" stays visible | `quizAnswer[1] = 589` (VT is still asked in AOE). Alternative: 1227280 |
| S2 | 10060 Power Infusion | no: the step is about Voidform | `quizAnswer[2] = 228260` |
| S3 | 335467 Shadow Word: Madness | yes | none |
| S4 | 15407 Mind Flay | yes ("Nothing else ready? ___") | none |
| AOE | 34914 Vampiric Touch | yes | none (alternative 1227280 if S1 takes 589 and you want Tentacle Slam asked somewhere) |

### 5. Card errors (Shadow)
1. **S3 "...or when it is about to run out."** "it" reads as the Insanity bar, which does not run out in combat (D3).
   Meant is the SW:M DoT on the target (APL: `dot.shadow_word_madness.remains<=gcd.max`). Missing: in Voidform you
   spend every time (APL `|buff.voidform.up`, G5 "while in Voidform to keep the burst window active"). Suggested:
   `Spend Insanity on {SPELL:335467} before the bar is full, or when {SPELL:335467} on the target is about to run out. During {SPELL:228260}: every time you can.`
2. S4 "{SPELL:1242173} whenever ready" is a simplification, not an error: it is only on the Voidform button (D1), the
   guides put it low in ST (G5, G6 Archon, G7), and the APL banks it for Resonant Energy as Archon but casts it first
   when Voidform is ready (to free the button). W4 explains where it appears.
3. HERO1 Archon: correct and 12.1-specific. In 12.1 Surge of Insanity (391399) only buffs Mind Flay; the only source of
   Mind Flay: Insanity in D1 is Archon's Manifested Power (453783): "Creating a Halo upgrades your next Mind Flay to Mind
   Flay: Insanity". APL order `halo` then `voidform` **MEASURED** [A1].
4. HERO2 Voidweaver: correct. Void Torrent 263165 "tearing open an Entropic Rift"; 450405 "Entropic Rift upgrades Mind
   Blast into Void Blast while it is active"; aura 450404 also halves the Mind Blast/Void Blast recharge **MEASURED** D1.
5. IDEA, S1, S2, AOE, MISTAKE: no errors. S2 nuance: guides say put Power Infusion on an ally when you have Twins of the
   Sun Priestess (G5, G7); the card's "together" is still right.

---

## 6. 12.1.5 (PTR 12.1.5.70077, live 13/14 Oct)

**Forum [F]**, priest lines only: 16 Sep (15 Sep US) Disc "Master the Darkness duration reduced to 30 seconds (was 1
minute)"; Holy "Holy Celerity and Ultimate Serenity have swapped positions on the specialization tree" (dev note:
moved up so M+ Holy priests reach it with less investment). 3, 22, 29 Sep: nothing for priests. **MEASURED**.

**DB2 [D2 vs D1, full diff of every priest spell]**: the only real changes are the same two, plus one not in the notes:
Discipline talent Divine Procession (472361) now needs 20 points instead of 8 (not on the card). Every other diff line is
a "Hotfixed" marker whose value is identical on both builds (Mind Flay, SW:Madness, Psychic Link, MF:Insanity coefficients
are already the hotfixed live values). Master the Darkness duration change confirmed in wago (SpellMisc 1253591
DurationIndex 3 = 60 s on 69933, 9 = 30 s on 70077) **MEASURED**.

Effect on the drafts and cards:
- Disc W2 / S2: no number used, so nothing breaks; "use it soon" becomes more true. Card S2 rewording above is optional.
- Holy: Ultimate Serenity (replaces Sanctify) becomes cheaper to reach, so more Holy players will not have
  {SPELL:34861}. AOE's "if you have them" already covers it; use the optional Ultimate Serenity sentence in the Holy
  TERMS line.
- Shadow: no change at all.
- **Code consequence (INFERRED from `PlayCardWhyState`)**: with `why = { interface = 120100 }`, the priest W lines,
  TERMS and quiz explanations hide on 13/14 Oct, because 12.1.5 is interface 120105. Nothing in 70077 invalidates them,
  so `interface = 120105` is defensible, with the caveat that 70077 is the 30 Sep PTR build and a live re-check after
  patch day is the safe route. Rob's call.

## Aside (not researched, INFERRED)
`PlayCardKnowsSpell` greys out spells the character "does not have". Void Shield, Void Volley, both Void Blasts and Mind
Flay: Insanity are override-only spells (D1 "Override Action Spell"), so they may show grey outside their window even
for a player who has the talent. Not tested in the client.
