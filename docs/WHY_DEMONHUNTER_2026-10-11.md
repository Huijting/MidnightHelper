# Demon Hunter: why lines, quiz and "good to know" (Havoc 577, Vengeance 581, Devourer 1480)

Research done 11 Oct 2026 (mh-research). I edited no repo files. MEASURED = seen in a named, dated source (GEMETEN).
INFERRED = reasoned from measured facts (AFGELEID).

## Sources (every claim below points at one of these)

| tag | source | date / build |
|---|---|---|
| DB2 | wago.tools DB2 as CSV (`/db2/<Table>/csv?build=..&filter[..]=exact:..`, curl works for CSV): Spell, SpellName, SpellEffect, SpellCooldowns, SpellCategories, SpellCategory, SpellAuraOptions, SpellMisc, SpellDuration, SpellPower, SpecializationSpells | live **12.1.0.69933**, PTR **12.1.5.70077**, read 11 Oct 2026. Raw DB2, so live **hotfixes are not in it** |
| DUMP | SimC `midnight` `SpellDataDump/demonhunter.txt` + `demonhunter_ptr.txt` (Blizzard spell data incl. hotfixes) | "12.1.0.69933 Live (hotfix 2026-10-07)" and "12.1.5.70077 PTR (hotfix 2026-10-07)" |
| APL-H / APL-V / APL-D | SimC `midnight` `ActionPriorityLists/default/demonhunter_havoc / _vengeance / _devourer.simc` | last commits **8 Sep**, **5 Oct** (rewrite), **20 Aug 2026** |
| IV-H / IV-V / IV-D | Icy Veins rotation pages | **30 Aug** / **10 Aug** (before S2 start, says "updated for 12.1") / **17-18 Aug 2026** ("August 18th tuning") |
| M-H / M-V / M-D | Method "Playstyle & Rotation" | **17 Sep** / **27 Aug** / **18 Sep 2026** |
| WH-H / WH-V / WH-D | Wowhead rotation guides (via Exa fetch, `?nocache=20261011`; direct curl gives 403) | **17 Aug** / **12 Aug** / **2 Sep 2026** |
| PTR | EU forum thread 627464 as JSON: 6 posts (3 Sep x3, 15 Sep, 22 Sep, 29 Sep); posts #2 and #3 are empty | fetched 11 Oct, `last_posted_at` 29 Sep |
| CODE | `Modules/PlayCards.lua`, `Locales/enUS.lua`, `Locales/nlNL.lua` (read only) | 11 Oct 2026 |

Not used: the in-app browser (tab cap reached, all tabs belonged to other agents; I opened and closed nothing). Wowhead
tooltips: not read separately; DB2 replaced them.

**All 31 `{SPELL:id}` on the three cards resolve to the expected name** (DB2 SpellName 69933, MEASURED). 187827 is the
Vengeance Metamorphosis (SpecializationSpells 581: 187827 overrides 191427, MEASURED). 1245412 = Voidblade,
1246167 = The Hunt (Devourer's own version), 1221150 = Collapsing Star (MEASURED).

---

## 1. Havoc Demon Hunter (577): S1-S5 + AOE

### W1 (S1: Metamorphosis once Eye Beam and Blade Dance are on cooldown; The Hunt when ready)
EN: `{SPELL:191427} makes you a demon for a while and, with the {SPELL:388112} talent, makes {SPELL:198013} and {SPELL:188499} ready again at once. So use those two first: the reset then hands you a free extra round. {SPELL:370965} rushes you to your target and leaves a wound that keeps hurting the enemies in your path.`

NL: `{SPELL:191427} maakt je een tijdje een demon en zet, met het talent {SPELL:388112}, {SPELL:198013} en {SPELL:188499} meteen weer klaar. Gebruik die twee dus eerst: dan geeft de reset je gratis een extra ronde. {SPELL:370965} laat je naar je doelwit stormen en laat een wond achter die de vijanden op je pad blijft raken.`

- Metamorphosis: demon form for 20 s (SpellMisc DurationIndex 18 = 20000 ms), +20% Haste, Chaos Strike -> Annihilation and Blade Dance -> Death Sweep (162264 effects 4, 6, 7). MEASURED: DB2 + DUMP.
- The reset comes **only from the talent** Chaotic Transformation (388112): "When you activate Metamorphosis, the cooldowns of Blade Dance and Eye Beam are immediately reset." MEASURED: DB2 Spell. The old passive 320645 ("Rank 4", same text) is **not** in Havoc's SpecializationSpells (positive control: 188499 and 203555 are). MEASURED: DB2.
- "Use those two first": IV-H ("make absolutely sure that both Blade Dance and Eye Beam are on cooldown before pressing it"), WH-H, APL-H (`!cooldown.blade_dance.up&cooldown.eye_beam.remains>8`). MEASURED.
- The Hunt: charge, root, damage-over-time on enemies in your path, 90 s cooldown. MEASURED: DB2 370965 + SpellCooldowns 90000.

### W2 (S2: Vengeful Retreat, then Eye Beam; demon after the beam)
EN: `{SPELL:198793} wakes up {SPELL:388108}: your next hits crit more often for a few seconds, so start {SPELL:198013} right after. With the {SPELL:213410} talent the beam then makes you a demon for a few seconds.`

NL: `{SPELL:198793} maakt {SPELL:388108} weer wakker: een paar seconden crit je vaker, dus start {SPELL:198013} meteen daarna. Met het talent {SPELL:213410} word je na de straal ook een paar seconden een demon.`

- Initiative (388108, talent): "Damaging an enemy before they damage you increases your critical strike chance by 10% for 5 sec. Vengeful Retreat refreshes your potential to trigger this effect on any enemies you are in combat with." MEASURED: DB2 Spell + SpellEffect 391215 (10) + SpellDuration 28 (5000 ms).
- Pairing VR with Eye Beam: IV-H, WH-H ("about a global before Eye Beam comes off cooldown for Initiative"), M-H ("Vengeful Retreat paired with Eye Beam"), APL-H. MEASURED. VR also triggers Exergy (+5% damage, 20 s), the S2 pick per IV-H and M-H. MEASURED (DUMP 208628, guides). Left out of the line to keep it short.
- Demonic (213410): "Eye Beam causes you to enter demon form for 5 sec after it finishes dealing damage." MEASURED: DB2 SpellEffect 5000.

### W3 (S3: Essence Break, then Blade Dance; Death Sweep as a demon)
EN: `{SPELL:258860} marks the enemies in front of you for a few seconds: every {SPELL:188499} and {SPELL:162794} then deals extra damage to them. So follow it with your blades at once. As a demon {SPELL:210152} hits harder and is ready again sooner.`

NL: `{SPELL:258860} markeert de vijanden voor je een paar seconden: elke {SPELL:188499} en {SPELL:162794} doet ze dan extra schade. Laat er dus meteen je messen op volgen. Als demon slaat {SPELL:210152} harder en is hij sneller weer klaar.`

- Essence Break: frontal slash, then for 4 s "Chaos Strike and Blade Dance deal [extra] Chaos damage to them" (flat damage now, IV-H "flat damage rather than a multiplier"). 12.1 4-piece: +2 s. MEASURED: DB2 Spell 258860, SpellMisc 320338 -> duration 35 = 4000 ms, DUMP 1296612.
- Cooldowns: Blade Dance 15 s, Death Sweep 9 s (same category 1640). MEASURED: DB2 SpellCooldowns. "Hits harder": Metamorphosis tooltip "greatly empowering your Chaos Strike and Blade Dance". MEASURED.
- EB on cooldown in S2 because of the tier set, but hold it if Eye Beam is ready within 4 s: WH-H, IV-H, M-H, APL-H (`essence_break,if=cooldown.eye_beam.remains>4`). MEASURED. Not in the line.

### W4 (S4: spare Fury on Chaos Strike / Annihilation)
EN: `Your Fury bar stops when it is full, so Fury you earn after that is lost. {SPELL:162794} turns spare Fury into damage and sometimes hands part of it back. Just keep enough for {SPELL:188499} and {SPELL:198013}: they come first.`

NL: `Je Fury-balk stopt als hij vol is, dus Fury die je daarna verdient ben je kwijt. {SPELL:162794} maakt van extra Fury schade en geeft je er soms een deel van terug. Houd wel genoeg over voor {SPELL:188499} en {SPELL:198013}: die gaan voor.`

- Chaos Strike costs 40 Fury and has a 20% chance to refund 20 Fury. MEASURED: DB2 SpellPower 40; DUMP 197125 (proc 20%) + 193840 (20).
- "Lost when full": INFERRED (a capped resource). Guides say the same thing: WH-H "Avoid Fury Waste", IV-H "always have enough Fury for Blade Dance/Death Sweep and Eye Beam; cast Chaos Strike as frequently as possible". MEASURED (guide).

### W5 (S5: low on Fury -> Felblade and Immolation Aura)
EN: `Your auto attacks fill Fury by themselves, but slowly. {SPELL:232893} and {SPELL:258920} give a quick extra scoop when you run dry, so your blades keep going.`

NL: `Je gewone aanvallen vullen vanzelf Fury, maar langzaam. {SPELL:232893} en {SPELL:258920} geven snel een extra schep als je bijna leeg bent, zodat je messen door kunnen.`

- Demon Blades (203555) is baseline for Havoc: "Your auto attacks ... generate Fury". MEASURED: DB2 SpecializationSpells 577 + Spell. Main Fury source per IV-H and M-H. MEASURED (guide).
- Felblade gives 15 Fury (12 s cooldown); Havoc's Immolation Aura gives 20 Fury on cast (more over time with the talent Burning Hatred). MEASURED: DB2 SpellEffect 213243 (15), 258920 effect 1 (20), SpellCooldowns 12000.

### WAOE (AOE: Immolation Aura up, never at 2 charges; Blade Dance over Chaos Strike)
EN: `{SPELL:258920} burns everything around you; with the {SPELL:427775} talent it holds 2 charges, and while both are full no new one is charging. {SPELL:188499} hits every enemy near you, {SPELL:162794} only one.`

NL: `{SPELL:258920} verbrandt alles om je heen; met het talent {SPELL:427775} heeft hij 2 charges, en zolang ze allebei vol zijn laadt er geen nieuwe op. {SPELL:188499} raakt elke vijand bij je, {SPELL:162794} maar één.`

- A Fire Inside (427775): +1 charge, 6 s shorter recharge, several auras at once. MEASURED: DB2 Spell + SpellEffect (1, -6000). Base Immolation Aura has 1 charge. MEASURED: DB2 SpellCategory 1676 (MaxCharges 1).
- "No new one charging while full": INFERRED (how charges work). IV-H: "avoid leaving it at 2 charges". MEASURED (guide).
- Blade Dance hits nearby enemies; Chaos Strike "Slice your target". MEASURED: DB2 descriptions.

### TERMS (Good to know): demon form carries the card (S2, S3, S4 and MISTAKE all lean on it)
EN: `Demon form: {SPELL:191427} turns you into a demon for a while, and with the {SPELL:213410} talent every {SPELL:198013} does it for a few seconds too. As a demon, {SPELL:162794} becomes {SPELL:201427} and {SPELL:188499} becomes {SPELL:210152}: the same buttons, only stronger.`

NL: `Demonvorm: {SPELL:191427} maakt je een tijdje een demon, en met het talent {SPELL:213410} doet elke {SPELL:198013} dat ook een paar seconden. Als demon wordt {SPELL:162794} {SPELL:201427} en wordt {SPELL:188499} {SPELL:210152}: dezelfde knoppen, alleen sterker.`

All MEASURED (DB2 162264 override effects, 213410). No numbers on purpose: the talent Shattered Destiny makes demon form last longer (DUMP 388116), so "20 s" is only the base. If Rob wants numbers: 20 s and 5 s are MEASURED base values.
Second candidate, not drafted: **Fury** (IDEA, S4, S5).

### Quiz (Havoc)
| step | last {SPELL} (default answer) | fair? | proposal |
|---|---|---|---|
| S1 | 370965 The Hunt | no: the step is about Metamorphosis timing, The Hunt is a side sentence | `[1] = 191427` |
| S2 | 198013 Eye Beam | yes ("after the beam" is a fair hint) | keep |
| S3 | 210152 Death Sweep ("as a demon it becomes ___") | weak: the step's new button is Essence Break | `[3] = 258860` |
| S4 | 201427 Annihilation | weak: the step is "spend Fury on Chaos Strike" | `[4] = 162794` |
| S5 | 258920 Immolation Aura | weak: also asked in AOE; Felblade is the main generator | `[5] = 232893` |
| AOE | 162794 Chaos Strike ("Blade Dance beats ___") | no: asks the losing button | `AOE = 258920` |

Proposal: `quizAnswer = { [1] = 191427, [3] = 258860, [4] = 162794, [5] = 232893, AOE = 258920 }`. Downside: Annihilation and
Death Sweep are never asked (the TERMS line covers them). No step lacks a spell.

### Card errors / outdated points (Havoc)
1. **S1 "{SPELL:370965} whenever it is ready" is outdated at max level.** The apex talent Eternal Hunt (1270898) makes The Hunt empower your next Eye Beam (+100%). MEASURED: DUMP/DB2. Every source times it: WH-H "Cast The Hunt when Eye Beam cooldown is less than 10 seconds"; IV-H "If Metamorphosis is available, hold to buff Abyssal Gaze" (Fel-Scarred); Aldrachi Reaver must throw its Reaver's Glaive first (IV-H, WH-H); APL-H `the_hunt,if=...cooldown.eye_beam.remains<10&cooldown.metamorphosis.remains>15...`. MEASURED. Without the apex (below 90) "whenever ready" is fine. Suggested S1 tail: `{SPELL:370965} when {SPELL:198013} is almost ready: it makes the next beam stronger.` W1 would then end with: `With the Eternal Hunt talent {SPELL:370965} also makes your next {SPELL:198013} much stronger.`
2. **HERO1 "Fel-Scarred (best this season)": the sources disagree.** IV-H 30 Aug: Fel-Scarred best in raid and M+ ("Fel-Scarred remains the go-to"). WH-H 17 Aug: "Mythic+ is Fel-Scarred, and in raid Aldrachi Reaver". M-H gives no verdict. The card follows the newest (IV). MEASURED. Optional: give the plain-text names IDs: Abyssal Gaze `{SPELL:452497}`, Consuming Fire `{SPELL:452487}` (456640 is the A Fire Inside version, same name). MEASURED: DB2 SpellName + override aura 452489.
3. AOE "never let it sit at 2 charges" only holds with A Fire Inside (talent, row 10). IV-H, WH-H and M-H builds take it. MEASURED. Optional wording: "(2 charges with A Fire Inside)". Minor.
4. MISTAKE needs Chaotic Transformation (talent, see W1). Guides treat it as standard. No change needed.
5. No ID errors. S2-S5, IDEA and HERO2 match DB2 and the guides. HERO2 order "Chaos Strike and Blade Dance" matches IV-H/WH-H/M-H (Chaos Strike first applies Reaver's Mark; Blade Dance second gets Bladecraft). MEASURED. APL-H uses Blade Dance first on one target (`annihilation,if=buff.rending_strike.up&buff.glaive_flurry.down&...`); IV-H: "stacks aren't a huge concern". Small difference, not an error.

---

## 2. Vengeance Demon Hunter (581): S1-S5 + AOE

### W1 (S1: Demon Spikes when no other defensive runs; keep it rolling)
EN: `{SPELL:203720} gives you thick armor and a better chance to parry for a short while, so ordinary hits hurt much less. It is your small defensive that comes back fast: use it to fill the gaps between {SPELL:204021} and {SPELL:187827}.`

NL: `{SPELL:203720} geeft je even dik harnas en meer kans op een parry, dus gewone klappen doen veel minder pijn. Het is je kleine defensive die snel terugkomt: gebruik hem om de gaten tussen {SPELL:204021} en {SPELL:187827} te vullen.`

- Armor +75% of Agility, Parry +8% (321028 is a Vengeance spec spell), lasts 12 s; 1 charge, 20 s recharge (+1 charge with the talent Demonic Resilience 1266307; Calcified Spikes 389720 also cuts damage taken). MEASURED: DB2 SpellEffect 203819, SpellMisc -> duration 29 = 12000 ms, SpellCategory 1586 (MaxCharges 1, 20000), SpecializationSpells 581.
- "Fill the gaps": WH-V "Whenever you do not have any other defensives active"; M-V "use your lower value defensive Demon Spikes to cover situations when Fiery Brand or Metamorphosis are not available". MEASURED. M-V also says that with Feed the Demon it reaches about 100% uptime, and APL-V presses it whenever it is not up. "Keep it rolling" covers both.

### W2 (S2: Fiery Brand and Metamorphosis taking turns)
EN: `{SPELL:204021} makes you take far less damage and sets the enemy on fire. {SPELL:187827} gives you extra health and much more armor. Each lasts only a short time, so use them one after the other: then one of them is nearly always protecting you.`

NL: `{SPELL:204021} laat je veel minder schade nemen en zet de vijand in brand. {SPELL:187827} geeft je extra health en veel meer harnas. Elk duurt maar kort, dus gebruik ze na elkaar: dan beschermt er bijna altijd een je.`

- Fiery Brand: you take 40% less damage from everything for 12 s, the target burns; 1 charge, 60 s (2 charges with Down in Flames). MEASURED: DB2 SpellEffect 207771 (-40, school mask 127), duration 29 = 12 s, SpellCategory 1541. IV-V says the same.
- Metamorphosis (Vengeance): +40% current and maximum health, armor +200%, 15 s, 120 s. MEASURED: DB2 Spell 187827, duration 8 = 15000 ms, SpellCategory 2469; IV-V.
- "Taking turns": IV-V "maintaining a high spread of defensive uptime"; M-V "use them as often as possible". MEASURED (guide).

### W3 (S3: Fracture before 2 charges; Immolation Aura and Sigil of Flame on cooldown)
EN: `{SPELL:263642} saves up to 2 charges; at 2 it stops charging, so every second it waits there you lose a free {SPELL:263642}. Each one breaks souls out of the enemy and gives Fury. {SPELL:258920} and {SPELL:204596} also give Fury, and with the right talents souls too.`

NL: `{SPELL:263642} spaart tot 2 charges op; bij 2 laadt hij niet meer bij, dus elke seconde dat hij daar wacht verlies je een gratis {SPELL:263642}. Elke klap slaat souls uit de vijand en geeft Fury. {SPELL:258920} en {SPELL:204596} geven ook Fury, en met de juiste talenten ook souls.`

- Fracture: 2 charges, 5.5 s recharge, shatters 2 Lesser Soul Fragments, 25 Fury (Metamorphosis adds 1 soul + Fury). MEASURED: DB2 SpellCategory 1552, SpellEffect 263642 (2, 25), Spell 187827.
- "Stops charging at 2": INFERRED (charge mechanic). All guides: Fracture at or near 2 charges. MEASURED.
- Sigil of Flame gives 25 Fury; souls only with the talent **Soul Sigils** (395446: "Afflicting an enemy with a Sigil generates 1 Soul Fragment"), a choice node with Soul Barrier. Immolation Aura gives Fury; souls only with **Fallout** (227174: "initial burst has a chance to shatter Soul Fragments"). MEASURED: DB2 Spell + SpellEffect 389787 (25), DUMP talent rows. That is why the line says "with the right talents". See card error 1.

### W4 (S4: 5+ souls Spirit Bomb, otherwise Soul Cleave)
EN: `Every soul you eat heals you, and {SPELL:247454} and {SPELL:228477} hit harder for each soul they eat. {SPELL:247454} eats up to 5 at once but has a cooldown; {SPELL:228477} eats up to 2, hits what is in front of you and heals you on top.`

NL: `Elke soul die je opeet heelt je, en {SPELL:247454} en {SPELL:228477} slaan harder voor elke soul die ze opeten. {SPELL:247454} eet er tot 5 tegelijk maar heeft een cooldown; {SPELL:228477} eet er tot 2, raakt wat voor je staat en heelt je er ook nog bij.`

- Spirit Bomb: up to 5 souls, +20% damage per soul, 40 Fury, **25 s cooldown** (new in Midnight). MEASURED: DB2 SpellEffect 247454 (20, 5, 8), SpellPower 40, SpellCooldowns CategoryRecoveryTime 25000 (same in 70077). IV-V calls it "the new version of Spirit Bomb".
- Soul Cleave: up to 2 souls, 35 Fury, frontal hit + self-heal. MEASURED: DB2 SpellEffect 228477 (2), SpellPower 35, Spell description.
- Apex Untethered Rage (1270448) lets both eat 1 more (3 and 6). MEASURED: DUMP; IV-V; M-V uses "Spirit Bomb with 6 souls", "Soul Cleave with 3 souls". Numbers 5 and 2 are the point of the step (thresholds).
- Each soul heals 6% of the damage taken in the last 5 s, at least 1% of maximum health. MEASURED: DUMP 203783 (6, 5, 1); IV-V says the same.

### W5 (S5: Fel Devastation when ready)
EN: `{SPELL:212084} breathes fire on everything in front of you for a moment, and the damage also heals you. Keep facing the enemies until it is done.`

NL: `{SPELL:212084} spuwt even vuur op alles voor je, en de schade heelt je ook. Blijf naar de vijanden kijken tot hij klaar is.`

- Frontal Fire channel, 2 s, 50 Fury, 40 s; heals because Fel Devastation Rank 2 (320639) is a Vengeance spec spell. MEASURED: DB2 Spell 212084, SpellCooldowns 40000, SpecializationSpells 581.
- "Keep facing": INFERRED (it hits only what is in front of you, cone 75 degrees in DUMP 212105).

### WAOE (AOE: Spirit Bomb matters more, Fel Devastation up, Sigil of Flame under the pack)
EN: `{SPELL:247454} explodes around you and hits every enemy close by, so it gets better the bigger the pack. {SPELL:212084} hits the whole group in front of you. {SPELL:204596} lands after a moment and burns everything standing in it.`

NL: `{SPELL:247454} ontploft om je heen en raakt elke vijand vlakbij, dus hoe groter de groep, hoe beter. {SPELL:212084} raakt de hele groep voor je. {SPELL:204596} komt na een ogenblik neer en verbrandt alles wat erin staat.`

- Spirit Bomb hits nearby enemies (less beyond 8 targets); Sigil of Flame activates after 2 s and burns all enemies in it. MEASURED: DB2 Spell 247454 + 204596. Fel Devastation higher in AoE: WH-V. MEASURED.

### TERMS (Good to know): souls carry the card (IDEA, S3, S4, MISTAKE, HERO lines)
EN: `Souls are little orbs that break out of enemies, mostly from {SPELL:263642}. Eating one heals you, more if you just took a lot of damage. {SPELL:228477} eats up to 2 and {SPELL:247454} up to 5, and both hit harder for every soul they eat.`

NL: `Souls zijn kleine bolletjes die uit vijanden breken, vooral door {SPELL:263642}. Eet je er een op, dan heel je; meer als je net veel schade kreeg. {SPELL:228477} eet er hoogstens 2 en {SPELL:247454} hoogstens 5, en allebei slaan ze harder voor elke soul die ze opeten.`

MEASURED: DB2 (2, 5, Fracture 2 souls), DUMP 203783 (heal based on recent damage). IV-V also says that above 6 souls on the
ground the oldest is consumed automatically and souls expire after 30 s (MEASURED guide only, not in DB2; left out).
Player-known ID for "souls": Shattered Souls `{SPELL:204254}` (Vengeance spec spell). MEASURED.

### Quiz (Vengeance)
| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 203720 Demon Spikes (only spell) | yes | keep |
| S2 | 187827 Metamorphosis | yes (both spells are the point) | keep |
| S3 | 204596 Sigil of Flame | no: the step is "Fracture before 2 charges"; Sigil of Flame is asked in AOE | `[3] = 263642` |
| S4 | 228477 Soul Cleave | yes | keep |
| S5 | 212084 Fel Devastation (only spell) | yes | keep |
| AOE | 204596 Sigil of Flame ("put ___ under the pack") | yes | keep (option: 247454 so Spirit Bomb gets asked once) |

Proposal: `quizAnswer = { [3] = 263642 }`. No step lacks a spell.

### Card errors / outdated points (Vengeance)
1. **S3 "they give Fury and souls" is only half true.** Immolation Aura gives souls only with Fallout, Sigil of Flame only with Soul Sigils (a choice node against Soul Barrier). MEASURED: DB2. IV-V: "Immolation Aura with Fallout talented"; no guide says Sigil of Flame makes souls. APL-V only uses Sigil of Flame for souls when `talent.soul_sigils`. MEASURED. Suggested: `{SPELL:258920} and {SPELL:204596} on cooldown: they give Fury (and souls with the right talents).`
2. S4 is fine as a threshold but misses that Spirit Bomb now has a 25 s cooldown (MEASURED, see W4) and that at max level the apex makes it 6 (M-V "Spirit Bomb with 6 souls"). Optional: `5 or more souls (6 with the apex talent): {SPELL:247454} when it is ready.` Minor.
3. HERO1 "Annihilator (best this season)": only IV-V says so (10 Aug, "best choice" for single target and AoE). WH-V and M-V give no verdict. MEASURED. Source is pre-S2 dated; I found no newer contradiction.
4. HERO1 Voidfall: Fracture has a 35% chance to give 1 stack, max 3; with Meteoric Fall (1253391), Spirit Bomb and Soul Cleave spend all 3. The card is right. MEASURED: DB2 SpellEffect (35, 1, 3), SpellAuraOptions 1256301 = 3.
5. HERO2 order Fracture then Soul Cleave matches IV-V ("always use Fracture first and Soul Cleave second"), M-V and WH-V. MEASURED. APL-V sometimes goes Soul Cleave first (`prio_slashes`); small difference, not an error.
6. No ID errors.

---

## 3. Devourer Demon Hunter (1480): S1-S5 + AOE

### W1 (S1: Void Metamorphosis with enough souls; demon until Fury runs out)
EN: `Every soul you pick up counts toward {SPELL:1217605}; when you have enough, it lights up. As a void demon all your spells hit harder, but your Fury slowly drains away, and the form ends when it reaches zero.`

NL: `Elke soul die je oppakt telt mee voor {SPELL:1217605}; heb je er genoeg, dan licht hij op. Als void-demon slaan al je spells harder, maar je Fury loopt langzaam leeg, en bij nul is de vorm voorbij.`

- Needs 50 collected souls (35 with Soul Glutton, -15). MEASURED: DB2 SpellAuraOptions 1225789 CumulativeAura 50; DUMP 1247534 (-15). The count is shown on the button (1225789 "Set Action Button Spell Count"). MEASURED: DUMP.
- Tooltip of the form (1217607): "Your spells are empowered and your Fury is slowly draining. Effect ends upon reaching 0 Fury." MEASURED: DB2 AuraDescription.
- I left out "stay in longer": Void-Scarred (the recommended tree) wants short, frequent forms (IV-D, M-D "Short Meta"). MEASURED. That advice would be wrong for them.

### W2 (S2: Reap at 4+ souls; Cull as a demon)
EN: `{SPELL:1226019} pulls in up to 4 souls at once, and each soul gives Fury and counts toward your demon form. With fewer around you waste part of it, so wait for 4. As a demon it becomes the stronger {SPELL:1245453}.`

NL: `{SPELL:1226019} trekt tot 4 souls tegelijk naar je toe, en elke soul geeft Fury en telt mee voor je demonvorm. Liggen er minder, dan verspil je een deel, dus wacht op 4. Als demon wordt hij de sterkere {SPELL:1245453}.`

- "Reap gathers up to 4 nearby souls" (1227619 effect 2 = 4). Each collected soul gives 4 Fury and heals 1%. Reap: 8 s, instant. MEASURED: DB2 Spell + SpellEffect, SpellCategory 2409; DUMP 1223412/1223628/1266301.
- In demon form Cull replaces Reap (override aura 1217607 effect 15). MEASURED: DUMP. "Significantly more damage": IV-D. MEASURED (guide).
- "Wait for 4": IV-D, M-D, WH-D all say Reap at 4+ souls (S2 tier set: 4+ souls gives a 20% Soulburst chance, DB2/DUMP 1296615). MEASURED. "Waste part of it" is INFERRED (cooldown spent on fewer souls; Soulshaper +8% per soul, DUMP 1238739).

### W3 (S3: Void Ray at 100 Fury; free as a demon)
EN: `{SPELL:473728} is your big beam: it needs 100 Fury and turns it into heavy damage, so do not let Fury pile up and go to waste. As a demon it costs nothing and even slows your Fury drain while it runs.`

NL: `{SPELL:473728} is je grote straal: hij heeft 100 Fury nodig en maakt daar flinke schade van, dus laat Fury niet ophopen en verloren gaan. Als demon kost hij niets en remt hij zelfs je Fury-verlies af zolang hij loopt.`

- Requires 100 Fury, 3 s channel. MEASURED: DB2 SpellPower 100, SpellMisc duration 27 = 3000 ms.
- In demon form: "Void Ray reduces your Fury drain, deals increased damage, and no longer consumes Fury". MEASURED: DB2 Spell 1217605. It gets a hasted 16 s cooldown in the form (14 with Voidpurge): IV-D. MEASURED (guide). WH-D says 14 s (probably with Voidpurge). Small source difference.

### W4 (S4: Soul Immolation when not running, not as a demon)
EN: `{SPELL:1241937} sets your soul on fire for a few seconds: it heals you, gives Fury and breaks souls loose while you keep casting. In demon form your time is better spent on {SPELL:1217610}, so use it outside.`

NL: `{SPELL:1241937} zet je soul een paar seconden in brand: hij heelt je, geeft Fury en maakt souls los terwijl je gewoon doorcast. In demonvorm kun je die tijd beter aan {SPELL:1217610} besteden, dus gebruik hem daarbuiten.`

- Heals a share of maximum health, gives Fury and shatters 3 souls over 5 s; 60 s, 1 charge (Tempered Soul: shorter cooldown + charge). MEASURED: DB2 Spell 1241937, SpellMisc duration 28 = 5000 ms, SpellCategory 2450; DUMP 1246555.
- "While you keep casting": INFERRED (it is a periodic aura).
- Not in demon form: IV-D "due to how much stronger Devour is, we do not want to be using Soul Immolation inside of Void Metamorphosis"; M-D the same, except for self-healing or dispelling. MEASURED. Exception: Void-Scarred AoE uses it at the very end of the form (IV-D, WH-D).

### W5 (S5: Consume as filler; Devour as a demon)
EN: `{SPELL:473662} has no cooldown and you can cast it while moving, so it fills every gap and earns Fury (with a talent, a soul too). As a demon it becomes {SPELL:1217610}, which also makes {SPELL:1245453} ready sooner.`

NL: `{SPELL:473662} heeft geen cooldown en je kunt hem lopend casten, dus hij vult elk gat en levert Fury op (met een talent ook een soul). Als demon wordt hij {SPELL:1217610}, en die zet {SPELL:1245453} ook sneller klaar.`

- Consume: "Castable while moving", 8 Fury, a soul with Predator's Thirst (1215617, row 2). Devour: overrides Consume in the form, reduces Reap's cooldown by 1 s (Cull shares Reap's category 2409). MEASURED: DB2 Spell 473662/1217610, DUMP 1261710, 1217607 effects 6 and 14, SpellCategories.

### WAOE (AOE: skip plain Reap; Eradicate after a full Void Ray, about 10 souls)
EN: `Plain {SPELL:1226019} would eat the souls you are saving up. After a full {SPELL:473728}, {SPELL:1225826} hits a whole cone of enemies and can pull in up to 10 souls at once, so let them pile up for it.`

NL: `Gewone {SPELL:1226019} zou de souls opeten die je aan het sparen bent. Na een volle {SPELL:473728} raakt {SPELL:1225826} een hele waaier vijanden en kan hij tot 10 souls tegelijk binnenhalen, dus laat ze daarvoor liggen.`

- Eradicate (talent 1226033): "Fully channeling Void Ray upgrades your Reap to Eradicate"; it hits a cone and gathers up to 4 souls; Moment of Craving (1238488, after a full Void Ray) adds 6 and resets Reap. 4 + 6 = 10. MEASURED: DB2 Spell + SpellEffect 1238495 (6), 1227619 (4).
- "Reap robs souls from Eradicate": WH-D, IV-D ("Reap should not be cast for Void-Scarred"), M-D ("should not be pressed in AoE"). MEASURED (guide). Max 10 souls lie on the ground before they auto-collect: IV-D, WH-D. MEASURED (guide only).

### TERMS (Good to know): souls carry the card (IDEA, S1, S2, S4, AOE)
EN: `Souls are little orbs that pop out of enemies you hit. Each one you pick up gives you Fury and counts toward {SPELL:1217605}, which needs 50 of them (35 with the {SPELL:1247534} talent). {SPELL:1226019} pulls in up to 4 nearby souls at once.`

NL: `Souls zijn kleine bolletjes die uit vijanden springen als je ze raakt. Elke soul die je oppakt geeft Fury en telt mee voor {SPELL:1217605}; daarvoor heb je er 50 nodig (35 met het talent {SPELL:1247534}). {SPELL:1226019} trekt er in één keer tot 4 uit de buurt naar je toe.`

All numbers MEASURED (DB2 1225789 = 50, DUMP Soul Glutton -15, DB2 1227619 = 4, DUMP 1223628 Fury). Player-known ID
for "souls": Shattered Souls `{SPELL:1227619}` (Devourer spec spell: "Damaging an enemy has a 4% chance to shatter a lesser soul fragment"). MEASURED.

### Quiz (Devourer)
| step | last {SPELL} | fair? | proposal |
|---|---|---|---|
| S1 | 1217605 Void Metamorphosis (only spell) | yes | keep |
| S2 | 1245453 Cull ("as a demon it becomes ___") | weak: the step is "Reap at 4 souls" | `[2] = 1226019` |
| S3 | 473728 Void Ray (only spell) | yes | keep |
| S4 | 1241937 Soul Immolation (only spell) | yes | keep |
| S5 | 1217610 Devour | weak: the step is the filler Consume | `[5] = 473662` |
| AOE | 1225826 Eradicate | yes (the point of the step) | keep |

Proposal: `quizAnswer = { [2] = 1226019, [5] = 473662 }`. Cull and Devour are then never asked. No step lacks a spell.

### Card errors / outdated points (Devourer)
1. **HERO1 "press the slashes that light up" is loose.** In the form, Voidblade becomes Pierce the Veil, The Hunt becomes Predator's Wake and Hungering Slash becomes Reaper's Toll. Only Reaper's Toll is a slash; the other two are charges ("charge to your target"). MEASURED: DUMP override auras 452435/1245496/1245523, DB2 SpellName. Suggested: `... then press {SPELL:1245483}, {SPELL:1259431} and {SPELL:1245470} when they light up.` "Best this season" is right: IV-D 18 Aug ("currently the strongest tree in all situations"), WH-D 2 Sep (Void-Scarred is the default). MEASURED.
2. **HERO1 goes stale in 12.1.5** (see section 4): from then on, entering the form no longer resets The Hunt.
3. HERO2: Collapsing Star (1221167) is a **spec** talent (row 4), not an Annihilator talent. MEASURED: DUMP. On live, Void-Scarred skips it (IV-D "does not make use of it at all", M-D "should never be pressed" in melee builds), so putting it under Annihilator is right **for 12.1.0**. MEASURED.
4. AOE "about 10 souls" needs Moment of Craving (row 4); S1 "enough souls" = 50 or 35. Both are fine as written.
5. No ID errors.

---

## 4. Patch 12.1.5 (PTR notes 627464 + DB2 70077)

The three DH cards have no `why` entry yet. Once they get `why = { interface = 120100 }` like the other cards, the why lines
hide themselves on a 120105 client (CODE header). What changes:

- **Havoc and Vengeance: nothing.** The thread has DH changes only in post #1 (3 Sep) and post #4 (15 Sep), both Devourer-only. MEASURED: PTR, positive control "DEMON HUNTER" header found. The DB2/DUMP diff between 69933 and 70077 shows only live-hotfix markers on Aldrachi Reaver spells (Art of the Glaive, Reaver's Glaive, Reaver's Mark), with the same values. MEASURED: DUMP diff (33 differences, 31 of them Devourer or hotfix artifacts).
- **Devourer, Void-Scarred (affects HERO1, maybe HERO2 and S4):**
  - Violent Transformation: "Entering Void Metamorphosis resets the cooldown of Voidblade and **Soul Immolation**" (The Hunt removed). MEASURED: DB2 Spell 452409 in 70077 vs 69933; PTR post #1.
  - Demonic Intensity: "... greatly empowers The Hunt and **casting Collapsing Star resets its cooldown**". MEASURED: DB2 452415 in 70077; PTR post #1 (also The Hunt +30%).
  - Dev note: "Collapsing Star is intended to be a feature ability of Devourer's rotation regardless of which Hero Talents are selected". MEASURED: PTR.
  - Consequence for HERO1 ("{SPELL:1245412} and {SPELL:1246167} right before {SPELL:1217605}"): the reason for The Hunt before the form is gone; Voidblade still resets. Void-Scarred will probably press Collapsing Star. INFERRED. Re-check guides after 13/14 Oct before rewriting.
  - Consequence for S4/W4: Soul Immolation now resets on entering the form (Void-Scarred), so guides may say "Soul Immolation just before the form". INFERRED. W4's "use it outside the form" stays true as written.
- **Devourer, all builds:** Collapsing Star loses its 5 s cooldown after a cancel (DB2 SpellCooldowns 1221150: 5000 -> 0) and slows Fury drain only for a limited time; extra range once the cast starts; Voidpurge 2 -> 2.5 s; Eradicate and The Hunt move from row 10 to row 5. MEASURED: DB2 + DUMP + PTR. None of this changes a W line or TERMS line.
- Live-only hotfix values (Consume, Devour, Reap, Eradicate, Collapsing Star coefficients) look "reverted" in the PTR dump. They are hotfixes the PTR build does not have, not 12.1.5 changes. INFERRED from the "Hotfixed" markers.

---

## 5. Spell IDs for buff, proc and talent names (all MEASURED: DB2 SpellName 12.1.0.69933)

| name | ID to use | note |
|---|---|---|
| Demonic | 213410 | Havoc talent |
| Chaotic Transformation | 388112 | Havoc talent (320645 has the same text but is not a Havoc spec spell) |
| Initiative | 388108 | talent (buff is 391215) |
| Exergy / Inertia | 206476 / 427640 | talents (buffs 208628 / 427641) |
| A Fire Inside | 427775 | talent |
| Demon Blades | 203555 | Havoc baseline passive |
| Cycle of Hatred | 258887 | talent |
| Demonsurge | 452402 | Fel-Scarred. **On Devourer the same ID shows "Demonsurge"**, so for Void-Scarred use Voidsurge 1246160 |
| Abyssal Gaze / Consuming Fire | 452497 / 452487 (456640) | Fel-Scarred demon-form versions |
| Art of the Glaive | 442290 | Aldrachi Reaver |
| Shattered Souls ("souls") | 204254 (Vengeance), 1227619 (Devourer) | spec passives |
| Fallout / Soul Sigils | 227174 / 395446 | Vengeance talents that make souls |
| Calcified Spikes / Feed the Demon / Demonic Resilience | 389720 / 218612 / 1266307 | Demon Spikes talents |
| Fiery Demise | 389220 | talent |
| Untethered Rage | 1270444 | Vengeance apex |
| Voidfall / Meteoric Fall | 1253304 / 1253391 | Annihilator |
| Void Metamorphosis (talent) | 471306 | ability is 1217605 |
| Soul Glutton | 1247534 | Devourer talent (35 souls) |
| Eradicate (talent) / Moment of Craving | 1226033 / 1238488 | ability is 1225826 |
| Collapsing Star (talent) | 1221167 | ability is 1221150 |
| Hungering Slash | 1239519 (talent), 1239123 (ability) | |
| Pierce the Veil / Predator's Wake / Reaper's Toll | 1245483 / 1259431 / 1245470 | Void-Scarred demon-form versions |
| Voidsurge | 1246160 | damage spell named "Voidsurge" |

## Work files (scratch, not deliverables)
`C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\b858ebb6-31f0-46dc-b5df-bd5769253a2b\scratchpad\why\dh_work\`:
wago1-3.txt (DB2 rows), specspells.csv, card_ids_live.txt, havoc_mech.txt / veng_mech.txt / dev_mech.txt (DUMP blocks),
ptr_diff.txt, t627464.txt, the three .simc APLs, iv_*/m_* page texts.
