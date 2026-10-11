# Why lines + quiz + good to know: Death Knight (250 Blood, 251 Frost, 252 Unholy)

Researched 11 Oct 2026 (mh-research). Read-only: no repo file edited.
Labels: **MEASURED** = GEMETEN (seen in a named, dated source). **INFERRED** = AFGELEID (reasoned).

## Sources (all fetched 11 Oct 2026, `?nocache=20261011`)

| tag | source | date / build |
|---|---|---|
| D1 | SimC `SpellDataDump/deathknight.txt`, branch `midnight` (DB2 extract) | header "12.1.0.69933 Live" |
| D2 | SimC `SpellDataDump/deathknight_ptr.txt` | header "12.1.5.70077 PTR" |
| APL-B | SimC `deathknight_blood.simc` | last generated 11 Aug 2026; source = PR #11652 "Blood APL 12.1", merged 2 Aug |
| APL-F | SimC `deathknight_frost.simc` | last generated 1 Sep 2026 ("Tweak target thresholds in Frost APL") |
| APL-U | SimC `deathknight_unholy.simc` | last generated 29 Sep 2026; Epidemic threshold changed 6 Sep |
| SC | SimC `engine/class_modules/sc_death_knight.cpp` (midnight) | fetched 11 Oct |
| IV-B | Icy Veins Blood rotation | Last Updated 10 Aug 2026 ("Updated for Patch 12.1") - **before 18 Aug** |
| IV-F | Icy Veins Frost rotation | page 14 Sep, changelog entry 25 Sep 2026 |
| IV-U | Icy Veins Unholy rotation | 8 Sep 2026 |
| M-B | Method Blood (Reholy) | 4 Sep 2026 |
| M-F | Method Frost (Taeznak) | 27 Sep 2026 |
| M-U | Method Unholy (Taeznak) | 24 Sep 2026 |
| F | EU forum thread 627464 (JSON) | 6 posts: 3 Sep (x3), 15, 22, 29 Sep; `last_posted_at` 29 Sep |

Not read: **Wowhead** (curl gives 403; the shared in-app browser was at its tab cap, and I did not close other agents' tabs). So route 1 = Icy Veins + Method only.

The guide dates are the same as the card's `source` fields, so the guides have not changed since the cards were written (MEASURED).

**Spell ID check (MEASURED, D1 + D2):** all 26 `{SPELL}` IDs on the three cards resolve to the expected name in 12.1.0.69933: 49998 Death Strike, 195181 Bone Shield, 195182 Marrowrend, 49028 Dancing Rune Weapon, 43265 Death and Decay, 50842 Blood Boil, 206930 Heart Strike, 433895 Vampiric Strike, 439843 Reaper's Mark, 49020 Obliterate, 49143 Frost Strike, 51271 Pillar of Frost, 279302 Frostwyrm's Fury, 1249658 Breath of Sindragosa, 49184 Howling Blast, 47568 Empower Rune Weapon, 207230 Frostscythe, 194913 Glacial Advance, 85948 Festering Strike, 55090 Scourge Strike, 47541 Death Coil, 42650 Army of the Dead, 1233448 Dark Transformation, 77575 Outbreak, 1247378 Putrefy, 207317 Epidemic. None is removed in the 12.1.5.70077 dump (the live-vs-PTR diff lists no "REMOVED" entries; the same diff did find 31 other differences, so the tool works).

---

# 250 Blood Death Knight

## 1+2. W lines (enUS + nl)

**PLAYCARD_250_W1**
- enUS: `{SPELL:49998} heals you for part of the damage you took in the last 5 seconds, so it heals most right after a big hit. Your Runic Power bar stops filling when it is full, so spend it before that happens.`
- nl: `{SPELL:49998} heelt je voor een deel van de schade die je de laatste 5 seconden kreeg, dus hij heelt het meest vlak na een harde klap. Je Runic Power-balk vult niet verder als hij vol is, dus geef hem uit voordat dat gebeurt.`
- Death Strike heals a % of all damage taken in the last `$s4` = 5 sec, minimum a % of max health. MEASURED, D1 49998 (12.1.0.69933). IV-B (10 Aug) says the same and says not to cap Runic Power. M-B (4 Sep): "You should never overcap Runic Power". MEASURED.
- "Stops filling when full" is how every capped bar works. INFERRED.

**PLAYCARD_250_W2**
- enUS: `{SPELL:195181} gives you extra armor and makes your Runes refill faster. Each hit you take uses up a charge, and with 5 or more charges your {SPELL:49998} costs less (Ossuary talent), so {SPELL:195182} adds 3 new charges before you drop below that.`
- nl: `{SPELL:195181} geeft je extra armor en laat je Runes sneller opladen. Elke klap die je krijgt kost een charge, en met 5 of meer charges kost {SPELL:49998} minder (talent Ossuary), dus {SPELL:195182} zet er 3 nieuwe bij voordat je daaronder zakt.`
- Bone Shield: armor from Strength, each melee attack against you consumes a charge (2.5 s internal cooldown), 30 sec. Haste comes from Marrowrend Rank 2 (316746, baseline at level 41) and Improved Bone Shield (374715, talent). MEASURED, D1 195181/316746/374715.
- "Haste makes Runes refill faster": IV-B says the Haste "is essential for Rune regeneration". MEASURED (guide).
- Ossuary (219786, Blood talent row 4): at least `$s1` = 5 charges, then Death Strike costs 5 less Runic Power. MEASURED, D1. Marrowrend gives `$s3` = 3 charges. MEASURED, D1 195182.
- "One hit = one charge" drops the 2.5 s internal cooldown on purpose (child-level simplification). INFERRED.

**PLAYCARD_250_W3**
- enUS: `{SPELL:49028} calls a floating copy of your weapon that copies your attacks: more damage and more Runic Power for a short time, and more parry. Standing in {SPELL:43265} makes {SPELL:206930} hit more enemies, and with the right talents you hit harder and heal more there.`
- nl: `{SPELL:49028} roept een zwevende kopie van je wapen op die je aanvallen nadoet: even meer schade, meer Runic Power en meer parry. In {SPELL:43265} raakt {SPELL:206930} meer vijanden, en met de juiste talents doe je daar ook meer schade en krijg je meer healing.`
- DRW "mirrors your melee attacks and bolsters your defenses", parry aura 81256. MEASURED, D1 49028/81256. "Primarily a resource and throughput cooldown" (more Runic Power): IV-B. MEASURED.
- In DnD, Heart Strike hits extra targets only with Cleaving Strikes (316916, class talent). Sanguine Ground (391458, Blood talent row 9) gives more damage and healing inside DnD. MEASURED, D1 43265/188290/316916/391458. "The right talents" covers both. INFERRED wording.

**PLAYCARD_250_W4**
- enUS: `{SPELL:50842} costs no Runes and refills its charges by itself, but the refill stops when all charges are full, so use one before then. {SPELL:206930} spends a Rune and gives Runic Power; keep Runes refilling, because only 3 refill at the same time.`
- nl: `{SPELL:50842} kost geen Runes en laadt zijn charges vanzelf op, maar dat stopt als alle charges vol zijn, dus gebruik er eerder een. {SPELL:206930} geeft een Rune uit en levert Runic Power op; houd Runes aan het opladen, want er laden er maar 3 tegelijk op.`
- Blood Boil: no Rune cost, 2 charges, 7.5 s recharge. MEASURED, D1 50842. "Never cap Blood Boil charges": IV-B + M-B. MEASURED.
- Heart Strike: 1 Rune, generates Runic Power. MEASURED, D1 206930.
- "At most 3 runes can be charging at the same time ... keep at least 3 on cooldown": IV-B (also IV-F, IV-U). MEASURED (guide; not found in D1 as a number).
- "The refill stops when full" = how charges work. INFERRED.

**PLAYCARD_250_WAOE**
- enUS: `{SPELL:50842} hits every enemy near you and gives them all Blood Plague, and with the Hemostasis talent each enemy it hits makes your next {SPELL:49998} stronger. {SPELL:43265} under the pack hurts them all, and inside it {SPELL:206930} hits more of them.`
- nl: `{SPELL:50842} raakt elke vijand om je heen en geeft ze allemaal Blood Plague; met het talent Hemostasis maakt elke geraakte vijand je volgende {SPELL:49998} sterker. {SPELL:43265} onder de groep raakt ze allemaal, en daarin raakt {SPELL:206930} er meer tegelijk.`
- Blood Boil hits all enemies within 10 yd and infects them with Blood Plague. MEASURED, D1 50842. Hemostasis (273946, Blood talent row 5): +8% per enemy hit, up to 5 stacks. MEASURED, D1 273946/273947. DnD damages everything in the area. MEASURED, D1 43265. Heart Strike in DnD: see W3 (Cleaving Strikes).

## 3. TERMS (Good to know)
The card leans on **Runes / Runic Power** (S1 "Runic Power above 70") and on Bone Shield charges (covered by W2).
- enUS `PLAYCARD_250_TERMS`: `Death Knights have two resources. You have 6 Runes; they refill by themselves, but only 3 at a time, so keep spending them. Every Rune you spend fills your Runic Power bar, and {SPELL:49998} spends that.`
- nl: `Death Knights hebben twee resources. Je hebt 6 Runes; die laden vanzelf op, maar slechts 3 tegelijk, dus blijf ze uitgeven. Elke Rune die je uitgeeft vult je Runic Power-balk, en {SPELL:49998} geeft die weer uit.`
- 6 Runes and 3 refilling at once: IV-B/IV-F/IV-U 12.1 pages. MEASURED (guide only, not DB2). Spending Runes gives Runic Power: D1 shows a Runic Power gain on every Rune spender (for example Heart Strike, Marrowrend, Death's Caress). MEASURED. I deliberately left out "10 Runic Power per Rune" (IV says it, but D1 shows Heart Strike gives more).

## 4. Quiz (last `{SPELL}` per step)

| step | default answer | fair? | proposal |
|---|---|---|---|
| S1 | 49998 Death Strike (only spell) | yes | none |
| S2 | 195182 Marrowrend | yes (Bone Shield stays visible as a hint, which is fine) | none |
| S3 | 43265 Death and Decay | yes. DRW would be ambiguous: "[ ] when ready" also fits Reaper's Mark (HERO2: on cooldown) | none |
| S4 | 206930 Heart Strike ("Nothing else ready? [ ]") | yes, a filler question like Frost Mage S5 | none |
| AOE | 43265 Death and Decay | **no**: DnD is already the S3 answer; the AoE point is "Blood Boil more often" | `AOE = 50842` |

Proposal: `quizAnswer = { AOE = 50842 }`. The five answers are then all different (DS, Marrowrend, DnD, Heart Strike, Blood Boil). No step lacks a spell.

## 5. Card errors / disagreements (Blood)

1. **S2 threshold is one too low. Fix recommended.** "Fewer than 5 Bone Shield charges? Marrowrend" means you only refresh at 4 or less, so you have already lost Ossuary's Death Strike discount, which needs **at least 5** (D1 219786 `$s1`=5). M-B (4 Sep): "Maintain at least 5 Bone Shield charges via Marrowrend". IV-B: "maintain Bone Shield at 5+ stacks" and "use Marrowrend when you have seven or fewer". APL-B: `marrowrend,if=buff.bone_shield.stack<6`. All MEASURED.
   - Suggested enUS: `5 or fewer {SPELL:195181} charges? {SPELL:195182}. Never let it drop off.`
   - nl: `5 charges {SPELL:195181} of minder? {SPELL:195182}. Laat hem nooit verdwijnen.`
2. **MISTAKE vs S1, minor tension.** S1 says Death Strike at 70+ Runic Power, but MISTAKE says never at full health. IV-B: "capping your Runic Power while not using Death Strike should also be avoided". Suggest adding "unless your Runic Power is almost full". MEASURED source, INFERRED wording.
3. **S3 "put DnD down again when it runs out" vs San'layn, sources disagree.** APL-B `sanlayn` list uses DnD only with a Crimson Scourge proc (`any_dnd,if=buff.crimson_scourge.remains`). IV-B (San'layn, outside Gift): DnD only with Crimson Scourge or on 4+ targets. M-B (4 Sep) San'layn: "Death And Decay, this should be considered a maintenance buff". Deathbringer: all three say maintain it. So 2 sources against 1 for the hero tree the card calls best. MEASURED. Low priority, but the card should not overclaim.
4. **HERO1 "Blood Boil once" in DRW, sources disagree.** The pre-12.1 APL had `san_gift ... blood_boil,if=!drw.bp_ticking` (= once). The 12.1 APL (PR #11652, generated 11 Aug) **removed** that line; Blood Boil in Gift is now only with Boiling Point or as a late filler. IV-B (10 Aug) and M-B (4 Sep) still say "Blood Boil once". MEASURED (diff of commit c6da5e6). By the brief's rule, IV-B's sentence matches the pre-12.1 APL, but M-B repeats it after Season 2 started. Keep the card; just know it is disputed. INFERRED judgement.
5. **HERO2 "Reaper's Mark first, then DRW", APL disagrees.** IV-B: "Reaper's Mark first, then Dancing Rune Weapon". M-B: RM before DRW "as Reaper's Mark is not duplicated by DRW". APL-B: `dancing_rune_weapon,if=!buff.exterminate.up&!debuff.reapers_mark_debuff.up&...` (DRW waits while the mark is up; the condition existed before 12.1 too). Two guides with a stated reason beat the APL here. Keep the card. MEASURED.
6. "When Marrowrend lights up, use it before it runs out": the Exterminate buff lasts 30 s (D1 441416) and IV-B says use it when < 3 s remain. MEASURED. Whether the Marrowrend button actually glows is not in D1. INFERRED.
7. Not an error, an omission: **Consumption** (1263824, Blood talent row 9, empowered, 45 s cooldown) is in both guides and both APL hero lists. **Death's Caress** for Bone Shield (APL, IV, M) is also not on the card. Card length is deliberate; noted only.

## 6. 12.1.5 (Blood)
No change. F has no Death Knight entry in any post (searched "death knight|blood|rune|marrowrend|bone shield|death strike|deathbringer|san'layn|class"; the same regex found the Hunter "Blood Fletching" line and the Mage Frost lines, so it works). D2 vs D1 for Blood spells: only "Hotfixed" lines missing in the PTR data (for example the Death Strike AP coefficient, the Blood spec aura 137008). These are live hotfixes that the PTR extract does not carry, not 12.1.5 changes. MEASURED diff, INFERRED meaning. No W, TERMS or card change.

---

# 251 Frost Death Knight

## 1+2. W lines

**PLAYCARD_251_W1**
- enUS: `{SPELL:51271} makes you much stronger for a few seconds, so put your biggest hits inside it. {SPELL:279302} sends a frost dragon through the enemies in front of you, and {SPELL:1249658} keeps breathing frost longer every time you use a Killing Machine or Rime.`
- nl: `{SPELL:51271} maakt je een paar seconden veel sterker, dus zet je grootste klappen daarin. {SPELL:279302} stuurt een ijsdraak door de vijanden voor je, en {SPELL:1249658} blijft langer ijs spuwen elke keer dat je een Killing Machine of Rime gebruikt.`
- Pillar: +20% Strength for 12 s, 45 s cooldown. FWF: a frostwyrm breathes on all enemies in front (damage, stun, slow), 90 s. BoS 1249658: 60 Runic Power, 8 s, "Consuming Killing Machine or Rime increases the duration". MEASURED, D1. IV-F + M-F: BoS always with Pillar, FWF in the Pillar window. MEASURED.

**PLAYCARD_251_W2**
- enUS: `Killing Machine makes your next {SPELL:49020} a sure crit with frost damage, so it hits far harder; it mostly comes from your normal attacks, and you can hold only 2. Rime makes your next {SPELL:49184} free and much stronger; you get it from {SPELL:49143}.`
- nl: `Killing Machine maakt je volgende {SPELL:49020} een zekere crit met frost-schade, dus hij raakt veel harder; hij komt vooral van je gewone aanvallen, en je kunt er maar 2 bewaren. Rime maakt je volgende {SPELL:49184} gratis en veel sterker; die krijg je van {SPELL:49143}.`
- Killing Machine 51128/51124: auto-attack crits give a chance; the next Obliterate deals Frost damage and is a guaranteed crit; **max 2 stacks**, 10 s. MEASURED, D1. Also from ERW, Obliteration, Exterminate (IV-F), hence "mostly". MEASURED.
- Rime 59057/59052: Frost Strike **and Glacial Advance** have a `$s2` = 45% chance; the next Howling Blast costs no Runes and deals +275%. MEASURED, D1; IV-F confirms 45%. The line names only Frost Strike because Glacial Advance is the AoE button (WAOE). INFERRED choice.

**PLAYCARD_251_W3**
- enUS: `{SPELL:49143} turns Runic Power into a strong frost hit, can light up Rime, and sometimes gives you a Rune back. Empty? {SPELL:47568} gives you a Killing Machine plus new Runic Power, so you skip a weak plain {SPELL:49020}.`
- nl: `{SPELL:49143} maakt van Runic Power een sterke frost-klap, kan Rime laten oplichten en geeft je soms een Rune terug. Leeg? {SPELL:47568} geeft je een Killing Machine plus nieuwe Runic Power, zodat je een zwakke gewone {SPELL:49020} overslaat.`
- Frost Strike 35 Runic Power. Runic Empowerment 81229 (Frost baseline, level 11): each Runic Power spent has a 1.8% chance to grant a Rune. MEASURED, D1; M-F says the same.
- ERW 47568: "grants you Killing Machine", gives 40 Runic Power (1230959 energize 400), 2 charges / 30 s. MEASURED, D1. IV-F: "use ERW to avoid no-KM Obliterate". MEASURED.
- I did not write "off the GCD": D1 shows GCD 0.75 s although IV/M call it off-GCD. Unresolved, so left out.

**PLAYCARD_251_W4**
- enUS: `A plain {SPELL:49020} hits weakly, but it spends Runes and fills your Runic Power for {SPELL:49143}. Runes only refill 3 at a time, so a full Rune bar is wasted time.`
- nl: `Een gewone {SPELL:49020} raakt zwak, maar hij geeft Runes uit en vult je Runic Power voor {SPELL:49143}. Runes laden maar 3 tegelijk op, dus een volle Rune-balk is verspilde tijd.`
- Obliterate: 2 Runes, +20 Runic Power. MEASURED, D1 49020. IV-F: the no-KM Obliterate "does very little damage ... primarily a builder". MEASURED. 3 Runes at a time: IV-F. MEASURED (guide).

**PLAYCARD_251_WAOE**
- enUS: `{SPELL:207230} slashes every enemy in front of you, and with Killing Machine its crit hits 4 times as hard. {SPELL:194913} sends ice spikes in a line through the pack, so stand at the edge and face the group.`
- nl: `{SPELL:207230} hakt in op elke vijand voor je, en met Killing Machine raakt zijn crit 4 keer zo hard. {SPELL:194913} stuurt ijspieken in een lijn door de groep, dus ga aan de rand staan met je gezicht naar de groep.`
- Frostscythe: 120° cone, all enemies in front, reduced beyond 5. Killing Machine makes its crit deal `$s2` = 4x (51128). MEASURED, D1. IV-F: "4x the normal damage, up from the standard 2x". MEASURED. "4" is the reason Killing Machine goes to Frostscythe in AoE, so it stays in. It could change with a patch.
- Glacial Advance: spikes advance forward from you and apply Razorice. MEASURED, D1 194913. IV-F: "stand at the edge of a pack and face inward". MEASURED.

## 3. TERMS
The IDEA leans on **Runes / Runic Power** (Killing Machine and Rime are explained in W2).
- enUS `PLAYCARD_251_TERMS`: `Death Knights have two resources. You have 6 Runes for {SPELL:49020}; they refill by themselves, but only 3 at a time. Spending Runes fills your Runic Power bar, and {SPELL:49143} spends that.`
- nl: `Death Knights hebben twee resources. Je hebt 6 Runes voor {SPELL:49020}; die laden vanzelf op, maar slechts 3 tegelijk. Runes uitgeven vult je Runic Power-balk, en {SPELL:49143} geeft die weer uit.`
- Same sources as Blood TERMS (IV-F 6 Runes / 3 at a time, MEASURED guide). Max Runic Power for Frost is 100 per IV-F, but it is not needed in the line.

## 4. Quiz

| step | default answer | fair? | proposal |
|---|---|---|---|
| S1 | 1249658 Breath of Sindragosa | **no**: optional talent ("if you have it"); the point is Pillar | `[1] = 51271` |
| S2 | 49184 Howling Blast | yes (the classic Rime lesson) | none |
| S3 | 47568 Empower Rune Weapon | **no**: the main point is "spend Runic Power on Frost Strike"; ERW is the fallback | `[3] = 49143` |
| S4 | 49020 Obliterate | yes | none |
| AOE | 49143 Frost Strike | **no**: that is what you STOP using | `AOE = 207230` (194913 Glacial Advance is equally valid) |

Proposal: `quizAnswer = { [1] = 51271, [3] = 49143, AOE = 207230 }`. All answers are different (Pillar, Howling Blast, Frost Strike, Obliterate, Frostscythe).

## 5. Card errors / disagreements (Frost)

1. **HERO1 "Reaper's Mark right before Pillar of Frost", sources disagree on the order.** IV-F (25 Sep): opener puts RM before the Pillar macro, and "Simply macro it with your Pillar of Frost every time". M-F (27 Sep): its opener and priority put Pillar first and RM after in the same press; its prose says use RM "before you start your Pillar of Frost window". APL-F: `reapers_mark,...,if=buff.pillar_of_frost.up|cooldown.pillar_of_frost.remains>5` (after Pillar). MEASURED. Safe wording: "together with {SPELL:51271} (one macro)". INFERRED.
   - "It gives extra Killing Machines": after the mark explodes (12 s or 40 stacks, D1 434765) you get Exterminate charges (2, or 1 with Reaper's Onslaught). For Frost each one's first scythe has `$s6` = 100% chance to grant Killing Machine (D1 441378). IV-F: "two Exterminates which give two procs of Killing Machine". MEASURED. "To spend inside it" only holds if the mark explodes before Pillar ends (both 12 s). INFERRED.
2. **Optional:** IV-F changed its default raid build to **Deathbringer + Breath of Sindragosa** on 14 Sep ("best choice" for raid and M+). M-F gives no verdict. HERO1 could carry "(best this season)" like Blood/Elemental. MEASURED source, low priority.
3. MISTAKE "Howling Blast without Rime" is right for normal play (M-F: "not worth ... the 1 rune cost"; IV-F: Rime is "the only time when we use this ability"). One expert exception: APL-F's lowest Pillar line `howling_blast,if=!buff.killing_machine.react&(talent.obliteration&buff.pillar_of_frost.up)`. IV-F's Breath build uses Obliteration, which makes Howling Blast grant Killing Machine during Pillar (D1 281238). Not worth putting on a beginner card. MEASURED, INFERRED judgement.
4. AOE threshold 3+ matches APL-F (`frostscythe_priority=3`, Glacial Advance at `>=3`, changed 1 Sep), IV-F (31 Aug changelog) and M-F. Correct. MEASURED.
5. S1 to S4 and HERO2 (Rider: "no extra button") match: Rider's Champion 444005 "Spending Runes has a chance to call forth the aid of a Horseman", and Apocalypse Now 444040 makes Army/Frostwyrm's Fury call all 4. MEASURED, D1. No other errors found.

## 6. 12.1.5 (Frost)
No class change in F. D2 vs D1: Pillar of Frost effect #5 (Remorseless Winter damage bonus) shows 450 live vs 400 on PTR, plus several Obliterate/Exterminate/Reaper's Mark coefficients. In every case D1 carries a "Hotfixed (x -> y)" line and D2 the pre-hotfix value, so these are live hotfixes absent from the PTR extract, not 12.1.5 nerfs. MEASURED diff, INFERRED meaning. None of them touches a W, TERMS or card statement.

---

# 252 Unholy Death Knight

## 1+2. W lines

**PLAYCARD_252_W1**
- enUS: `{SPELL:1233448} turns your ghoul into a monster, and with the Commander of the Dead talent your other undead hit harder too, so press it when {SPELL:42650} brings its ghouls. It comes back twice as fast as the army, so in between you use it on its own.`
- nl: `{SPELL:1233448} verandert je ghoul in een monster, en met het talent Commander of the Dead slaan je andere ondoden ook harder, dus druk hem als {SPELL:42650} zijn ghouls brengt. Hij is twee keer zo snel terug als het leger, dus daartussen gebruik je hem alleen.`
- DT: pet +200% damage, 15 s, **45 s** cooldown; Army: Lesser Ghoul army for 30 s, **90 s** cooldown. MEASURED, D1 1233448/42650.
- Commander of the Dead 390259 (Unholy talent row 9): DT empowers Gargoyle, Abomination, Magus and Lesser Ghouls for 30 s, +25% damage. MEASURED, D1.
- IV-U: "Send Dark Transformation every 45 seconds and Army of the Dead every 90 seconds, always aligning them". MEASURED.

**PLAYCARD_252_W2**
- enUS: `Dread Plague from {SPELL:77575} is what lights up {SPELL:47541}, so it must stay on. {SPELL:1247378} throws a ghoul that explodes, and {SPELL:1233448} makes it hit harder (Commander of the Dead), so spend it then.`
- nl: `Dread Plague van {SPELL:77575} is wat {SPELL:47541} laat oplichten, dus die moet blijven staan. {SPELL:1247378} gooit een ghoul die ontploft, en {SPELL:1233448} laat die harder raken (Commander of the Dead), dus gebruik hem dan.`
- Outbreak applies Dread Plague + Virulent Plague. Sudden Doom 49530: "Dread Plague has a `$s2` = 35% chance ...". Dread Plague: 1 host at a time. MEASURED, D1 77575/49530/1240996.
- Putrefy: summons a Lesser Ghoul that strikes and explodes. MEASURED, D1 1247378. IV-U: Putrefy gets "the large buff ... via Commander of the Dead", so it is used during DT windows. MEASURED.

**PLAYCARD_252_W3**
- enUS: `When {SPELL:47541} lights up (Sudden Doom) it costs less and hits harder, so use it before the light fades. Festering Scythe makes your diseases tick faster for a while, and faster ticks light up {SPELL:47541} more often.`
- nl: `Licht {SPELL:47541} op (Sudden Doom), dan kost hij minder en raakt hij harder, dus gebruik hem voordat het licht uitgaat. Festering Scythe laat je ziektes een tijdje sneller tikken, en snellere tikken laten {SPELL:47541} vaker oplichten.`
- Sudden Doom 81340: the next Death Coil or Epidemic costs 15 less Runic Power and deals +35%, lasts 10 s. MEASURED, D1.
- Festering Scythe 458128: a free slash after Festering Strike; plagues on the targets it hits tick 35% faster for 25 s (1241077). MEASURED, D1. IV-U: the faster tick rate "increases the proc chance of both Sudden Doom and Forbidden Knowledge". MEASURED.

**PLAYCARD_252_W4**
- enUS: `{SPELL:85948} charges your weapon so your next few {SPELL:55090}s each call a Lesser Ghoul to fight for you. {SPELL:55090} also makes your diseases burst for extra damage.`
- nl: `{SPELL:85948} laadt je wapen op, zodat je volgende paar {SPELL:55090}s elk een Lesser Ghoul oproepen die voor je vecht. {SPELL:55090} laat ook je ziektes openbarsten voor extra schade.`
- Festering Strike: "causing your next `$s3-$s4` (2-3) Scourge Strikes to summon a Lesser Ghoul". Stack buff 1254252: max 8, 30 s. Scourge Strike: plagues "erupt, dealing their damage an additional time at 35%", and it applies or spreads Virulent Plague. MEASURED, D1. "Next few" is used instead of "2-3" because the count is not the point.

**PLAYCARD_252_W5**
- enUS: `{SPELL:47541} spends Runic Power that would otherwise overflow, keeps your diseases and {SPELL:1233448} going a little longer, and spending Runic Power can make your Runes refill faster.`
- nl: `{SPELL:47541} geeft Runic Power uit die anders overloopt, houdt je ziektes en {SPELL:1233448} iets langer aan, en Runic Power uitgeven kan je Runes sneller laten opladen.`
- Death Coil: 30 Runic Power; extends Dread and Virulent Plague by 1.0 s; "Death Coil and Epidemic extends the duration of [Dark Transformation]". MEASURED, D1 47541/1233448.
- Runic Corruption 51462 (Unholy baseline): each Runic Power spent has a 2.0% chance to speed up Rune regeneration by 100% for 3 s. MEASURED, D1; IV-U and M-U say the same.

**PLAYCARD_252_WAOE**
- enUS: `{SPELL:207317} makes the plague on every enemy burst at once, so with 3 or more enemies it does more than {SPELL:47541}. With the Cycle of Death talent, each enemy standing in your {SPELL:43265} makes {SPELL:1247378} come back sooner.`
- nl: `{SPELL:207317} laat de plague op elke vijand tegelijk openbarsten, dus bij 3 of meer vijanden doet hij meer dan {SPELL:47541}. Met het talent Cycle of Death laat elke vijand in je {SPELL:43265} {SPELL:1247378} sneller terugkomen.`
- Epidemic: "each of your Virulent Plagues flare up"; Virulent Plague "spreads to all nearby enemies". MEASURED, D1 207317/191587. The 3+ threshold: APL-U changed it from 4+ to 3+ on 6 Sep (`epidemic_prio ... active_enemies>=3`); M-U (24 Sep) also says 3+. MEASURED.
- Cycle of Death 1290864 (Unholy talent row 6): "Death and Decay reduces the cooldown of Putrefy by 0.3 sec for each enemy it damages, up to 3.0 sec" (plus Putrefy -> DnD 1 s). MEASURED, D1.

## 3. TERMS
The word that carries this card is **Lesser Ghoul** (IDEA and S4).
- enUS `PLAYCARD_252_TERMS`: `A Lesser Ghoul is a small helper that fights for a short time. {SPELL:85948} gives you charges for them, and each {SPELL:55090} spends one charge to call a ghoul; the number on the {SPELL:55090} button shows how many are left.`
- nl: `Een Lesser Ghoul is een klein hulpje dat even voor je vecht. {SPELL:85948} geeft je charges ervoor, en elke {SPELL:55090} gebruikt er één om een ghoul op te roepen; het getal op de {SPELL:55090}-knop laat zien hoeveel er nog over zijn.`
- Charges = buff 1254252 "Next N Scourge Strikes will summon a Lesser Ghoul", with the effect "Set Action Button Spell Count: Scourge Strike". MEASURED, D1. Lesser Ghoul summons last 6-8 s (275430 / 1277098). MEASURED, D1.
- That the count really **shows** on the button is INFERRED: likely on Blizzard bars, not checked in game. Rob should look once. During Army of the Dead the ghouls get "Orders" instead (IV-U, D1 42650). Left out of the line.
- If the build chat prefers Runes/Runic Power for every DK card, the Blood TERMS line with {SPELL:47541} instead of Death Strike works too.

## 4. Quiz

| step | default answer | fair? | proposal |
|---|---|---|---|
| S1 | 1233448 Dark Transformation | yes | none |
| S2 | 1247378 Putrefy | yes (Outbreak stays visible) | none |
| S3 | 85948 Festering Strike (inside the parenthesis) | **no**: the point is Death Coil on the proc and Festering Scythe timing | see below |
| S4 | 55090 Scourge Strike | yes | none |
| S5 | 47541 Death Coil | yes | none |
| AOE | 47541 Death Coil | **no**: that is what you STOP using | `AOE = 207317` |

S3 has two options:
- (a) **Preferred:** write Festering Scythe as `{SPELL:458128}` and set `[3] = 458128`. 458128 is the 12.1 "Festering Scythe" button spell: D1 shows buff 458123 "Override Action Spell: Festering Scythe overrides Festering Strike, Base Value 458128". The ID is MEASURED in D1. That the client renders the name is INFERRED, but `{SPELL}` resolution works on any valid ID.
- (b) `[3] = 47541`: this duplicates the S5 answer (Death Coil twice).

Proposal: `quizAnswer = { [3] = 458128, AOE = 207317 }` (with change a), or `{ [3] = 47541, AOE = 207317 }`.

## 5. Card errors / disagreements (Unholy)

1. **S3 "when its buff on you is almost gone", ambiguous, half wrong.** The tick-speed effect 1241077 sits on the **enemies hit**: D1 458128 says "hastening all of your plagues on targets hit". SC maps the game's rule `AC_AURA_MISSING_TARGET` for 1241077 (and only models it as `buff.festering_scythe_tt` for convenience). M-U (24 Sep): "Festering Scythe if any target is missing the debuff". IV-U calls it "the buff on yourself", which is wrong per DB2. There **is** also a buff on you: 458123, "Your next Festering Strike has become Festering Scythe", 15 s. APL-U uses both (press when either has <= 3 s left). MEASURED.
   - Suggested enUS: `{SPELL:47541} when it lights up. {SPELL:458128} (it follows {SPELL:85948}) when its effect on the enemy is almost gone.`
   - nl: `{SPELL:47541} als hij oplicht. {SPELL:458128} (komt na {SPELL:85948}) als het effect op de vijand bijna op is.`
2. **AOE "Put DnD under the pack" only pays with Cycle of Death.** IV-U: DnD "is generally not worth using for its damage"; with Cycle of Death it is worth it at 3+. M-U: 2+ targets "and have Cycle Of Death talented ... entirely used for its cooldown reduction provided to Putrefy". APL-U: `death_and_decay,if=active_enemies>=3&talent.cycle_of_death&...`. MEASURED. Suggest adding "(with the Cycle of Death talent)".
3. **S1 "Army and DT together when ready" can read as "hold DT for Army".** DT has a 45 s cooldown, Army 90 s (D1); IV-U uses DT every 45 s and aligns every second one. MEASURED. Suggested: `{SPELL:1233448} when ready, every second time together with {SPELL:42650}: your big moment.` Low to medium.
4. **Optional:** IV-U marks **San'layn** "best choice" for raid and M+ (8 Sep). M-U gives no verdict. HERO2 could carry "(best this season)". MEASURED source.
5. MISTAKE is correct: Sudden Doom procs only from Dread Plague (D1 49530); IV-U: plagues "are also the source of your important Sudden Doom ... procs". MEASURED.
6. HERO2 is correct: Gift of the San'layn 434152 "While ... Dark Transformation is active ... Vampiric Strike replaces your ... Scourge Strike"; Essence of the Blood Queen 433925 stacks with a 20 s duration. MEASURED, D1. HERO1 (Rider, no extra button): see Frost point 5. MEASURED.
7. Omissions (not errors): **Soul Reaper** + Reaping and **Blightfall** are in both guides and the APL. Noted only.

## 6. 12.1.5 (Unholy)
No class change in F. D2 vs D1: Blightfall 1271974 effect 100 live vs 200 PTR; D1 carries "Hotfixed (200 -> 100)", so this is a live hotfix that the PTR data does not have. Not a 12.1.5 change, and Blightfall is not on the card. MEASURED diff, INFERRED meaning. No W, TERMS or card change.

---

# Cross-cutting: patch day 13/14 Oct

`PlayCards.lua` lines 371-374 hide W lines when the client interface is greater than `why.interface` (MEASURED, read in the repo 11 Oct). If these DK lines ship with `interface = 120100`, they hide themselves on 12.1.5 day (client 120105).

For all three DK specs, F (thread fetched 11 Oct, 6 posts up to 29 Sep) and the 12.1.5.70077 DB2 extract show **no change** to any mechanic used above (MEASURED). So they could be marked as checked for 120105. That is the build chat's call. INFERRED caveat: the live 12.1.5 build may differ from PTR build 70077.

## Scratch files (evidence)
`C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\b858ebb6-31f0-46dc-b5df-bd5769253a2b\scratchpad\why\dk_work\` contains:
- `deathknight.txt`, `deathknight_ptr.txt`, `ptr_diff.txt`, `card_ids_live.txt`, `named_live.txt`, `more_live.txt`, `extra_live.txt`
- the three `.simc` APLs
- `iv_*_rot.txt`, `m_*.txt`
- `forum627464.json`, `forum_hits.txt`
- `c_c6da5e6.json` (Blood APL 12.1 diff), `c_3f6f8c4.json` (Epidemic 6 Sep diff), `sc_death_knight.cpp`
