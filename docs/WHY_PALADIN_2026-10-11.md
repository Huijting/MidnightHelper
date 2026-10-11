# Paladin: why lines, quiz and "good to know" (Ret 70, Prot 66, Holy 65)

Research done 11 Oct 2026 (mh-research). I edited no repo files. MEASURED = seen in a named, dated source (GEMETEN).
INFERRED = reasoned from measured facts (AFGELEID).

## Sources (every claim below points at one of these)

| tag | source | date / build |
|---|---|---|
| DB2 | wago.tools DB2, read in the browser: Spell, SpellName, SpellEffect, SpellPower, SpellMisc + SpellDuration + SpellCastTimes, SpellCategories + SpellCategory, SpellCooldowns, SpellAuraOptions, SpecializationSpells, PowerType, SkillLineAbility, TraitDefinition | live **12.1.0.69933**, PTR **12.1.5.70077**, read 11 Oct 2026 |
| APL-R | SimC `midnight` `ActionPriorityLists/default/paladin_retribution.simc` | last commit 25 Aug 2026 (02b39ce), before that 19 Aug |
| APL-P | SimC `midnight` `paladin_protection.simc` | last commit **25 Sep 2026** (a69b069), a big rewrite that day; earlier 13 Sep, 4 Sep, 11 Aug |
| (none) | SimC has **no Holy APL**: the folder has only `paladin_protection.simc` + `paladin_retribution.simc` (GitHub contents API, 11 Oct) | MEASURED |
| IV-R | Icy Veins Ret rotation + talents | updated 25 Aug 2026 |
| IV-P | Icy Veins Prot rotation | updated 21 Aug 2026 |
| IV-H | Icy Veins Holy rotation | updated **10 Aug 2026** (before S2; it does name the 12.1 tier set) |
| M-R / M-P / M-H | Method Ret / Prot / Holy "Playstyle & Rotation" | 6 Oct / 3 Sep / 27 Aug 2026 |
| WH-R / WH-P / WH-H | Wowhead Ret / Prot / Holy rotation guides | 8 Sep / 7 Oct / 8 Oct 2026 |
| PTR | EU forum 627464 as JSON: 6 posts (3 Sep x3, 15 Sep, 22 Sep, 29 Sep), no later post in the 11 Oct fetch | MEASURED |
| CODE | `Modules/PlayCards.lua` (read only) | 11 Oct 2026 |

All 28 `{SPELL:id}` on the three cards resolve to the expected name in DB2 12.1.0.69933 (MEASURED, SpellName).
Spec IDs MEASURED in SpecializationSpells: 275779 = Prot Judgment (overrides 20271), 275773 = Holy Judgment (overrides 20271),
415091 = Holy Shield of the Righteous (overrides 53600). Ret uses base Judgment 20271.

---

## 1. Retribution Paladin (70): steps S1-S4, no AOE

### W1 (S1: Avenging Wrath + Execution Sentence together)
EN: `{SPELL:31884} makes all your hits stronger for a while. {SPELL:343527} drops a hammer that lands later and adds a part of all the damage you did to those enemies in the meantime: press them together and hit hard while it falls.`

NL: `{SPELL:31884} maakt al je klappen een tijdje sterker. {SPELL:343527} laat een hamer vallen die later landt en er een deel bij doet van alle schade die je die vijanden intussen gaf: druk ze samen en sla hard terwijl hij valt.`

- Avenging Wrath raises damage, healing and crit chance for 20 s. MEASURED: DB2 31884 description, SpellMisc duration 20000 ms (same index in 70077).
- Execution Sentence: a blast first, then after 10 s the target takes 20% of the Holy damage you did to the targets the blast hit. MEASURED: DB2 343527 (description, effect 1 = 20, duration 10000 ms).
- "All damage" and not just Holy damage: WH-R 8 Sep says all damage to the targets hit counts. MEASURED (guide). DB2 text says "Holy damage". Ret damage is almost all Holy or Radiant: INFERRED.
- Pair them: M-R 6 Oct says AW "should always be paired with Execution Sentence if talented". MEASURED. IV-R 25 Aug, WH-R 8 Sep and APL-R all list AW first, then ES. APL-R fires ES only once AW has just been used (`cooldown.avenging_wrath.remains>15`) and Wake of Ashes is nearly ready. MEASURED.

### W2 (S2: spend at 5 on Final Verdict / Divine Storm at 2+)
EN: `Holy Power stops at 5: everything you make on top of that is lost. {SPELL:383328} hits one enemy hard, {SPELL:53385} hits every enemy around you, so from 2 enemies it does more.`

NL: `Holy Power stopt bij 5: alles wat je daarboven maakt, ben je kwijt. {SPELL:383328} raakt één vijand hard, {SPELL:53385} raakt alle vijanden om je heen, dus vanaf 2 vijanden doet die meer.`

- Cap of 5: PowerType HOLY_POWER has MaxBasePower 3, and Boundless Conviction (115675) adds 2: "You may store an additional 2 Holy Power beyond the maximum of 3. No ability ever consumes more than 3 Holy Power." Every paladin learns it automatically (SkillLineAbility AcquireMethod 2, ClassMask 2). MEASURED: DB2, identical in 70077.
- Points above the cap are lost: INFERRED from the cap. IV-R also says not to keep building at 5. MEASURED (guide).
- Final Verdict hits one target. Divine Storm hits all nearby enemies, with less damage beyond 5. Both cost 3. MEASURED: DB2 383328 and 53385 (effect s2 = 5), SpellPower 3 each.
- Switch at 2 enemies. MEASURED: APL-R `ds_castable = active_enemies>=2`, IV-R ("swap to the AoE rotation at 2 or more targets"), M-R and WH-R AoE lists.
- Not in the line: IV-R says "you can simply spend Holy Power as soon as possible", and M-R/WH-R also spend at 3-4 further down the list. So S2's "at 5" is the cap rule, not the only time you spend. MEASURED.

### W3 (S3: Wake of Ashes + Divine Toll when ready)
EN: `{SPELL:255937} hits everything in front of you, sets it on fire and gives 3 Holy Power at once. {SPELL:375576} throws an extra strong {SPELL:20271} at several enemies with one press.`

NL: `{SPELL:255937} raakt alles vóór je, zet het in brand en geeft in één keer 3 Holy Power. {SPELL:375576} gooit met één klik een extra sterke {SPELL:20271} naar meerdere vijanden.`

- Wake of Ashes does frontal Radiant damage, adds the Truth's Wake burn (403695, 9 s) and gives 3 Holy Power (SpellEffect energize, power 9, 3 points). MEASURED: DB2 255937.
- Divine Toll for Ret casts Judgment on up to 5 targets, and "Divine Toll's Judgment deals 50% increased damage" (effect 5 = 50). MEASURED: DB2 375576.
- I left out "spend first if you are at 5" on purpose. **The sources disagree there.** IV-R, WH-R and M-R put "Final Verdict at 5 Holy Power" above Wake of Ashes. APL-R (25 Aug) only calls the spenders at 5 Holy Power *when Wake is on cooldown*, so with Wake ready the APL presses Wake even at 5. MEASURED both ways.

### W4 (S4: fill with Blade of Justice, then Judgment; Judgment becomes Hammer of Wrath in AW)
EN: `{SPELL:184575} and {SPELL:20271} are your quick Holy Power makers, and {SPELL:20271} makes the enemy take more damage from your next spender. During {SPELL:31884} that button becomes {SPELL:24275}, which hits harder.`

NL: `{SPELL:184575} en {SPELL:20271} zijn je snelle Holy Power-makers, en {SPELL:20271} laat de vijand meer schade nemen van je volgende spender. Tijdens {SPELL:31884} wordt die knop {SPELL:24275}, en die slaat harder.`

- Blade of Justice gives 1 Holy Power. MEASURED: DB2 184575 effect 1.
- Judgment gives 1 Holy Power through 220637, when 315867 is known. 315867 is in Ret's SpecializationSpells, so it is baseline. MEASURED: DB2.
- "More damage from your next spender" is **Greater Judgment (231663), and that is a talent** (TraitDefinition 107595): "Judgment causes the target to take X% increased damage from your next Holy Power ability". MEASURED: DB2. That the standard builds take it is INFERRED. M-R 6 Oct backs the idea: keep the Judgment debuff up because it "massively" raises spender damage. MEASURED (guide).
- During AW, Judgment becomes Hammer of Wrath. MEASURED: DB2 1241288 ("During Avenging Wrath, Judgment is empowered into Hammer of Wrath") and override aura 1241410 (20271 -> 24275). IV-R says the same: it "converts Judgment into Hammer of Wrath, upgrading its effects".
- "Hits harder": IV-R "upgrading its effects". MEASURED (guide). I did not compare the damage numbers.
- Optional extra (not in the line): Art of War (406064) gives auto attacks a chance to reset Blade of Justice. Guides spend it at 2 stacks. MEASURED: DB2, IV-R, WH-R.

### TERMS (Good to know): Holy Power carries the card
EN: `Holy Power is your paladin points. You can hold up to 5; {SPELL:184575} and {SPELL:20271} give 1, {SPELL:255937} gives 3, and a spender like {SPELL:383328} or {SPELL:53385} costs 3. Anything above 5 is lost.`

NL: `Holy Power zijn je paladin-punten. Je kunt er hoogstens 5 hebben; {SPELL:184575} en {SPELL:20271} geven er 1, {SPELL:255937} geeft er 3, en een spender zoals {SPELL:383328} of {SPELL:53385} kost er 3. Alles boven 5 ben je kwijt.`

All numbers are MEASURED (DB2 PowerType + 115675, SpellEffect energize values, SpellPower 3), and unchanged in 70077.

### Quiz (Ret)
| step | last {SPELL} (asked by default) | fair? | proposal |
|---|---|---|---|
| S1 | 343527 Execution Sentence | yes ("Avenging Wrath and ___ together") | keep |
| S2 | 53385 Divine Storm (the side option in brackets) | weak: the step is about spending at 5 | `[2] = 383328` (same reasoning as Elemental S4). Downside: Divine Storm is then never asked, because Ret has no AOE step |
| S3 | 375576 Divine Toll | yes | keep |
| S4 | 24275 Hammer of Wrath ("Judgment turns into ___") | ok, but the button the step is about is Blade of Justice | `[4] = 184575` |

Proposal: `quizAnswer = { [2] = 383328, [4] = 184575 }`. No step lacks a spell. The pool has 9 spells.

### Card errors (Ret)
- **No hard errors found.** IDs, S1-S4, MISTAKE and HERO2 match DB2 and the guides.
- HERO1 "(3 Holy Power)": **correct, but DB2 contradicts itself.** SpellPower for Hammer of Light 427453 says **3** Holy Power (rows for Ret 137027 and Prot 137028). Boundless Conviction says no ability consumes more than 3. But the Light's Guidance tooltip text (427445) still has a hard-coded "Costs 5 Holy Power." MEASURED. In game, the tooltip may show 5. Worth one look by Rob.
- HERO1 window: Hammer of Light stays for 20 s after Wake of Ashes. MEASURED: 427441 duration 20000 ms, override of the Wake of Ashes class mask. "Press it right away" fits IV-R, WH-R and M-R (top after ES). MEASURED.
- S1 build note: IV-R talents (25 Aug) default to Herald of the Sun **with** Execution Sentence, and offer Radiant Glory as an M+ swap. Radiant Glory "replaces Avenging Wrath" and makes Wake of Ashes trigger AW (DB2 458359/454353). Those players have no AW button, so S1 does not fit them. Not an error for the default build. MEASURED.
- Source line: Method is now dated 6 Oct and Wowhead Ret 8 Sep (the card says Method 27 Aug).

---

## 2. Protection Paladin (66): S1-S5 + AOE

### W1 (S1: Avenging Wrath / Sentinel + Divine Toll)
EN: `{SPELL:31884} makes you hit harder for a while and turns {SPELL:275779} into Hammer of Wrath. {SPELL:375576} throws {SPELL:31935} at several enemies at once and every hit gives Holy Power, so press it when your Holy Power is low.`

NL: `{SPELL:31884} laat je een tijdje harder slaan en maakt van {SPELL:275779} Hammer of Wrath. {SPELL:375576} gooit {SPELL:31935} naar meerdere vijanden tegelijk en elke treffer geeft Holy Power, dus druk hem als je Holy Power laag is.`

- AW raises damage, healing and crit for 20 s. MEASURED: DB2.
- For Prot, Judgment becomes Hammer of Wrath. MEASURED: DB2 aura **1277026** (override 275779 -> 1241413 Hammer of Wrath, text = 1241288). IV-P 21 Aug and WH-P 7 Oct say the same. (The Ret/Holy aura 1241410 does not list 275779; Prot has its own.) Hammer of Wrath is not a {SPELL} on the Prot card, so it stays plain text.
- Divine Toll for Prot casts Avenger's Shield on up to 5 targets and "Generates 1 Holy Power per target hit". MEASURED: DB2 375576 (spec 2, s5 = 1, s1 = 5).
- "When low": WH-P 7 Oct: "Divine Toll if you have 0 Holy Power" (Templar AoE list: 0-2). MEASURED. APL-P (25 Sep) instead uses DT inside AW. Both fit "low", because AW makes Holy Power fast.
- Sentinel (not in the line): 15 stacks of Divine Resolve, more max health and less damage taken per stack. Stacks drop after a delay, and every 3 Holy Power spent delays the loss. MEASURED: DB2 389539, 20 s. IV-P: since 12.1 Sentinel keeps the crit bonus too.

### W2 (S2: Shield of the Righteous at 3+)
EN: `{SPELL:53600} raises your armor for a few seconds, so every hit on you hurts less. It does not wait for your other buttons, so you can slip it in between them and keep it up almost all the time.`

NL: `{SPELL:53600} verhoogt een paar seconden je armor, dus elke klap op jou doet minder pijn. Hij wacht niet op je andere knoppen, dus je kunt hem ertussen drukken en hem bijna altijd aan houden.`

- Armor buff 132403 lasts 4.5 s. MEASURED: DB2 SpellMisc duration 4500 ms. The cost is 3 Holy Power. MEASURED: SpellPower.
- Off the global cooldown: SpellCooldowns 53600 has StartRecoveryTime 0 and its own 1 s cooldown. MEASURED: DB2. IV-P and M-P say the same.
- Near-full uptime. MEASURED: IV-P ("active nearly all of the time"), M-P ("close to 100% uptime").
- Talent note: Instrument of the Divine (1277162, in IV-P's build) lets Shield of the Righteous eat up to 2 more Holy Power for more damage (SpellPower OptionalCost 2). MEASURED. "3 or more" still holds.

### W3 (S3: Judgment + Blessed Hammer on cooldown)
EN: `{SPELL:275779} and {SPELL:204019} each give Holy Power, so never let them sit ready. {SPELL:204019} also makes the next hit of each enemy it touches a little weaker.`

NL: `{SPELL:275779} en {SPELL:204019} geven allebei Holy Power, laat ze dus nooit klaar liggen. {SPELL:204019} maakt ook de volgende klap van elke vijand die hij raakt wat zwakker.`

- Blessed Hammer gives 1 Holy Power and lowers "the next damage they deal to you". MEASURED: DB2 204019.
- Judgment gives 1 Holy Power through 220637/315867, and 315867 is in Prot's spec spells. MEASURED.
- "On cooldown": WH-P 7 Oct: "keep both Judgment and Blessed Hammer on cooldown as much as possible". MEASURED.
- Blessed Hammer and Hammer of the Righteous are a talent choice. MEASURED: IV-P, WH-P.

### W4 (S4: Avenger's Shield; stand in Consecration)
EN: `{SPELL:31935} jumps on to more enemies and stops a spell your target is casting. {SPELL:26573} burns every enemy that stands in it, and some of your talents and your tier set work better there.`

NL: `{SPELL:31935} springt door naar meer vijanden en onderbreekt een spell die je doelwit cast. {SPELL:26573} brandt elke vijand die erin staat, en sommige van je talenten en je tier set werken daar beter.`

- Avenger's Shield does damage, interrupts and silences the non-player target, and jumps to more enemies. MEASURED: DB2 31935.
- Consecration damages enemies in the area for 12 s. MEASURED: DB2 26573, 12000 ms.
- "Works better there". MEASURED (guides): IV-P says the S2 2-piece gives +5% crit against enemies inside Consecration. M-P names Sanctuary and new Consecration sustain talents.

### W5 (S5: Hand of Reckoning on the pull / taunt; AoE first on a pack)
EN: `{SPELL:62124} makes one enemy attack you right away. Enemies chase whoever hurts them most, so on a pack your hits that land on many at once, like {SPELL:26573} and {SPELL:31935}, pull them all to you.`

NL: `{SPELL:62124} laat één vijand meteen jou aanvallen. Vijanden gaan achter wie ze het meest pijn doet aan, dus bij een pack trekken klappen die veel vijanden tegelijk raken, zoals {SPELL:26573} en {SPELL:31935}, ze allemaal naar jou.`

- Hand of Reckoning forces the target to attack you and raises your threat for a while. MEASURED: DB2 62124. IV-P adds an 8 s cooldown and a 3 s fixate.
- Threat comes from damage, and tanks get a large threat multiplier. MEASURED: IV-P 21 Aug. "Chase whoever hurts them most" is a simplification of that: INFERRED.
- WH-P 7 Oct opener: Hand of Reckoning on the pull "so no DPS/Healers get punched". MEASURED.

### WAOE (AOE: Avenger's Shield moves up)
EN: `{SPELL:31935} jumps from enemy to enemy, so with more enemies one throw hits more of them. Then it is worth more than a button that hits only one.`

NL: `{SPELL:31935} springt van vijand naar vijand, dus met meer vijanden raakt één worp er meer. Dan is hij meer waard dan een knop die er maar één raakt.`

- The jump is MEASURED (DB2 31935). The AoE ranking is MEASURED: IV-P AoE list has AS right after Shield of the Righteous; M-P: "Avenger's Shield if there are 2 or more targets". "Worth more" is INFERRED from that ranking.

### TERMS (Good to know): Holy Power
EN: `Holy Power is your paladin points. You can hold up to 5; {SPELL:275779} and {SPELL:204019} give 1, {SPELL:375576} gives 1 for every enemy it hits, and {SPELL:53600} needs 3. Anything above 5 is lost.`

NL: `Holy Power zijn je paladin-punten. Je kunt er hoogstens 5 hebben; {SPELL:275779} en {SPELL:204019} geven er 1, {SPELL:375576} geeft er 1 per vijand die hij raakt, en {SPELL:53600} heeft er 3 nodig. Alles boven 5 ben je kwijt.`

All numbers MEASURED (DB2). I wrote "needs 3" rather than "costs 3" because of Instrument of the Divine (see W2).

### Quiz (Prot)
| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 31884 Avenging Wrath, which appears **twice** | **giveaway**: the code blanks only the first one, so the question still says "replaces Avenging Wrath on the same button" | code fix (see the end), or `[1] = 375576` |
| S2 | 53600 | yes | keep |
| S3 | 204019 | yes | keep |
| S4 | 26573 Consecration ("Stand in your ___") | yes | keep (Avenger's Shield gets asked in AOE) |
| S5 | 62124 Hand of Reckoning, which appears **twice** | **giveaway** ("...taunt it with Hand of Reckoning" stays visible) | code fix; without it, reword S5 so the spell appears once ("taunt it with the same button") |
| AOE | 53600 ("moves up to right after ___") | weak: the step is about Avenger's Shield moving up | `AOE = 31935` |

Proposal: `quizAnswer = { [1] = 375576, AOE = 31935 }`, plus the code fix for S5.

### Card errors (Prot)
- **HERO2 timing (Lightsmith): the sources disagree. The card matches the majority.**
  - Card: "Press it when AW (or Sentinel) is not running."
  - IV-P 21 Aug: "Sacred Weapon if you do not have Avenging Wrath active". MEASURED.
  - WH-P 7 Oct: "Sacred Weapon if you aren't inside Avenging Wrath" and "Holy Bulwark if you have any charges". MEASURED.
  - M-P 3 Sep: Holy Bulwark at 2 charges and outside AW. Sacred Weapon when its buff has under 20 s left. But its notes recommend lining Sacred Weapon up with wings, and Holy Bulwark just *before* AW. MEASURED.
  - APL-P 25 Sep: `holy_armaments,if=cooldown.avenging_wrath.remains<=gcd|time_to_die<30|charges=2`, i.e. just before AW, or at 2 charges. MEASURED.
  - Advice: keep the card, optionally add "never sit at 2 charges", which all four sources support.
  - Also MEASURED in DB2: 2 charges with a 60 s recharge (SpellCategory 2220). Holy Bulwark "Becomes Sacred Weapon after use" and back again (432459/432472).
- HERO1 "it is your hardest hit": **no source says that** (IV-P, M-P, WH-P, DB2). Unverified, not proven wrong. Suggest dropping that clause.
- HERO1 "after Divine Toll, Hammer of Light lights up". MEASURED: DB2 427445 says Prot's (137028) Divine Toll is replaced by Hammer of Light; override aura 1246643 (375576 -> 427453, 20 s). Cost 3. "Press it right away" fits IV-P's opener and WH-P "Hammer of Light on cooldown". APL-P first makes sure the Judgment debuff is on. Small nuance only.
- S1-S5, AOE, MISTAKE and IDs: no errors found.
- Source line: Wowhead Prot is now 7 Oct (the card says 12 Aug), Method 3 Sep.

---

## 3. Holy Paladin (65): S1-S4 + AOE (+ EASY)

### W1 (S1: Divine Toll + Avenging Wrath; Divine Toll fills Holy Power)
EN: `{SPELL:375576} casts {SPELL:20473} on several friends at once, and each one gives Holy Power: your bar fills in one press, so use it when the bar is low. {SPELL:31884} makes all your healing stronger for a while.`

NL: `{SPELL:375576} cast {SPELL:20473} op meerdere vrienden tegelijk, en elk daarvan geeft Holy Power: je balk loopt in één klik vol, gebruik hem dus als de balk laag is. {SPELL:31884} maakt al je heals een tijdje sterker.`

- Divine Toll for Holy casts Holy Shock (at reduced effectiveness) on up to 5 targets. MEASURED: DB2 375576.
- Holy Shock gives 1 Holy Power. MEASURED: DB2 20473.
- M-H 27 Aug: Divine Toll "generates a full bar of Holy Power". MEASURED.
- "When the bar is low": WH-H 8 Oct "only use Divine Toll with 2 or fewer Holy Power". MEASURED.
- AW raises healing, damage and crit. MEASURED: DB2.

### W2 (S2: Flash of Light with Infusion of Light, then Holy Shock)
EN: `Infusion of Light makes your next {SPELL:19750} instant and much stronger: one of your best heals. You can hold only one, so spend it before you press {SPELL:20473} again.`

NL: `Infusion of Light maakt je volgende {SPELL:19750} instant en veel sterker: een van je beste heals. Je kunt er maar één hebben, dus gebruik hem voordat je weer {SPELL:20473} drukt.`

- Holy Shock has a 10% chance (53576, effect 10) to give buff 54149. The buff gives +200% Flash of Light healing and -100% cast time, so it is instant. MEASURED: DB2.
- **The buff lasts 15 s.** MEASURED: SpellMisc DurationIndex 8 = 15000 ms in 69933 and 70077. See the card errors below.
- "Hold only one": SpellAuraOptions 54149 has CumulativeAura 0 and ProcCharges 1. MEASURED (base spell; I did not check talents that might add a charge). WH-H 8 Oct: spend procs "before casting more Holy Shock which can generate new ones". MEASURED.
- "One of your best heals": WH-H: "Flash of Light with Infusion of Light is one of our strongest spells". MEASURED.

### W3 (S3: Word of Glory / Eternal Flame on the lowest friend; spend at 5)
EN: `{SPELL:85673} is one big heal for 3 Holy Power, so give it to the friend who needs it most: healing above full health is wasted. At 5 every new point is lost, so spend right away.`

NL: `{SPELL:85673} is één grote heal voor 3 Holy Power, geef hem dus aan de vriend die hem het hardst nodig heeft: healen boven vol leven is weggegooid. Op 5 ben je elk nieuw punt kwijt, dus meteen uitgeven.`

- Word of Glory and Eternal Flame cost 3 Holy Power. MEASURED: SpellPower. The cap of 5 is MEASURED (see Ret W2).
- Overheal is wasted: INFERRED (general rule). All three guides say to switch to Light of Dawn when the single-target heal would overheal a lot. MEASURED.
- Eternal Flame is the best spender. MEASURED: WH-H, M-H.

### W4 (S4: Judgment + Shield of the Righteous on the enemy when nobody needs healing)
EN: `{SPELL:275773} hurts the enemy and gives Holy Power. {SPELL:415091} spends Holy Power on damage, gives you some Mana back and makes {SPELL:20473} ready sooner.`

NL: `{SPELL:275773} doet de vijand pijn en geeft Holy Power. {SPELL:415091} geeft Holy Power uit aan schade, geeft je wat Mana terug en maakt {SPELL:20473} sneller klaar.`

- Holy Judgment gives Holy Power through 220637/315867, and 315867 is in Holy's spec spells. MEASURED.
- 415091 does damage, "reducing the cooldown of Holy Shock … and granting … mana", and costs 3 Holy Power. MEASURED: DB2 description + SpellPower.
- Guides agree: WH-H "returns a good bit of mana"; M-H gives a figure of 1.5% mana. MEASURED.

### WAOE (AOE: Beacon of Virtue as damage lands, then Divine Toll; Light of Dawn vs overheal)
EN: `{SPELL:200025} marks a few hurt friends for a short time, and they all get a part of every other heal you cast: that is why {SPELL:375576} comes right after. {SPELL:85222} heals several friends near you at once, better when one big heal would be too much.`

NL: `{SPELL:200025} markeert een paar gewonde vrienden voor korte tijd, en die krijgen allemaal een deel van elke andere heal die je cast: daarom komt {SPELL:375576} er direct achteraan. {SPELL:85222} healt meerdere vrienden om je heen tegelijk, beter als één grote heal te veel zou zijn.`

- Beacon of Virtue goes on your target plus 4 injured allies (s2 = 4) for 9 s. They are healed for a share of your other healing. MEASURED: DB2 200025, duration 9000 ms.
- Divine Toll inside Beacon of Virtue. MEASURED: M-H, IV-H, WH-H. Note that WH-H 8 Oct calls this pairing "likely overkill" in M+.
- Light of Dawn heals up to 5 injured allies around you for 3 Holy Power. MEASURED: DB2 85222 + SpellPower.

### TERMS (Good to know): Holy Power
EN: `Holy Power is your paladin points. You can hold up to 5; {SPELL:20473} gives 1, {SPELL:375576} can fill the whole bar, and every spender ({SPELL:85673}, {SPELL:85222}, {SPELL:415091}) costs 3. Anything above 5 is lost.`

NL: `Holy Power zijn je paladin-punten. Je kunt er hoogstens 5 hebben; {SPELL:20473} geeft er 1, {SPELL:375576} kan de hele balk vullen, en elke spender ({SPELL:85673}, {SPELL:85222}, {SPELL:415091}) kost er 3. Alles boven 5 ben je kwijt.`

All numbers MEASURED (DB2). "Fill the whole bar" is 5 Holy Shocks x 1 Holy Power (DB2) plus M-H.

### Quiz (Holy)
| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 375576 Divine Toll, which appears **twice** | **giveaway** ("Divine Toll fills your Holy Power" stays visible) | code fix; without it `[1] = 31884` |
| S2 | 20473 Holy Shock, which appears **twice** | **giveaway**, and not the point (the step is about Flash of Light) | `[2] = 19750` |
| S3 | 156322 Eternal Flame (in brackets) | the side option | `[3] = 85673` |
| S4 | 415091 Shield of the Righteous | yes | keep |
| AOE | 85673 ("when ___ would overheal") | not the point | `AOE = 200025` |

Proposal: `quizAnswer = { [2] = 19750, [3] = 85673, AOE = 200025 }`, plus `[1] = 31884` if the code stays as it is.

### Card errors (Holy)
- **S2 "for 10 seconds" is WRONG: the buff lasts 15 seconds.** Infusion of Light 54149 has SpellMisc DurationIndex 8 = 15000 ms in 12.1.0.69933 and in 12.1.5.70077. It is the only buff that 53576 triggers. MEASURED: DB2 (SpellEffect: 53576 triggers 54149; no SpellEffect triggers the other IoL ID 458213).
  - The "10" is in **all 7 packs**: enUS:1323, nlNL:1268, Translations2026.lua:10073 (de), 10577 (fr), 11081 (es), 11585 (pt), 12089 (it).
  - Fix: write 15, or drop the number ("for a short while").
- EASY line: Flash of Light "1.5 sec" and Holy Light "2 sec" are correct. MEASURED: SpellCastTimes 1500 / 2000 ms.
- MISTAKE (Divine Toll on an enemy hits enemies). MEASURED: IV-H ("If you are targetting an enemy, then it will prioritize casting the 5 Holy Shocks on enemies") and WH-H 8 Oct.
- HERO1: Herald's Dawnlight comes from Divine Toll **or Holy Prism**. MEASURED: DB2 431377. WH-H: 2 Dawnlights per cast. The card only names Divine Toll. Not wrong, because the two are a choice node (IV-H).
- HERO2: Holy Bulwark on a friend (squishy, or yourself so Solidarity sends the second one to a tank), Sacred Weapon on yourself. MEASURED: IV-H, WH-H. For Holy, Holy Armaments also gives Holy Power (DB2 432459 description, spec 1).
- Source line: Wowhead Holy is now 8 Oct (the card says 20 Sep). IV-H dates from 10 Aug, which is before Season 2.

---

## 4. 12.1.5 (PTR notes + 12.1.5.70077 DB2)

- **PTR notes: no Paladin section in any of the 6 posts** (3 Sep x3, 15 Sep, 22 Sep, 29 Sep). MEASURED.
  - Positive control: the same text gives DEMON HUNTER, DRUID, EVOKER, HUNTER, MAGE, MONK, PRIEST, ROGUE, SHAMAN and WARRIOR headings.
  - The fetch of 11 Oct holds no post after 29 Sep.
- **DB2 69933 vs 70077: no change in 67 paladin spells.** MEASURED. Compared per spell: Spell description + aura description, SpellEffect (effect, aura, base points, misc, trigger, class mask) and SpellPower.
  - Covers every card spell, the hero-talent spells, and the talents the W lines lean on: 1241288/1241410, 427441/427445/427453, 431377, 458359, 1277162, 115675, 53576/54149, 1263782 and others.
  - Positive control: the same comparison does flag Nature's Bounty 1263879 (redesigned on the 15 Sep PTR) and Soulforged Blades 1272432 (15 -> 18).
  - SpellMisc duration indices for 10 key spells, PowerType HOLY_POWER (max 3) and Boundless Conviction are identical. MEASURED.
- **Not compared:** damage/healing coefficients (EffectBonusCoefficient etc.) and talent-tree layout (TraitNode). Those do not touch the W lines as written: no damage numbers are in them.
- **Conclusion: nothing in 12.1.5 changes a W line, a TERMS line or the cards** (MEASURED for what was compared).
  - The `why = { checked = "2026-10-11", interface = 120100 }` gate will hide the W lines on 120105 anyway. Based on this check, bumping it to 120105 is safe for these three cards. INFERRED.

---

## 5. Quiz code finding (all three cards)

`Modules/PlayCards.lua:373`: `local blanked = text:gsub("{SPELL:" .. answer .. "}", "{BLANK}", 1)` blanks only the **first** occurrence. MEASURED: CODE.

When the answer spell appears twice in a step, the second copy gives the answer away. Measured cases on these cards: Prot S1 (31884), Prot S5 (62124), Holy S1 (375576), Holy S2 (20473). Frost and Elemental have no such step.

Fix: drop the `, 1` so every copy is blanked. The overrides above then stay only where the last spell is not the point of the step.

Smaller point (INFERRED): wrong choices are drawn from the whole card, so a choice can be a spell that is printed in the same question (e.g. Ret S4 with answer Blade of Justice can offer Judgment). That makes it easy to rule out, but it is not wrong.
