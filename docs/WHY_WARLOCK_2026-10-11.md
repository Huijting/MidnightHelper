# Warlock (265 Affliction, 266 Demonology, 267 Destruction): why lines, quiz, terms, card check

Research run: 11 Oct 2026, mh-research. Read only: no repo file was edited.
Tags: **MEASURED** = seen in the named, dated source. **INFERRED** = reasoned from measured facts.

## Sources (all fetched 11 Oct 2026)

| Code | Source | Date / build | Note |
|---|---|---|---|
| DB2 | wago.tools CSV export (`/db2/<table>/csv?build=`): Spell, SpellName, SpellEffect, SpellMisc, SpellDuration, SpellCooldowns, SpellCategories, SpellCategory, SpellPower, SpellAuraOptions, PowerType | live **12.1.0.69933** and PTR **12.1.5.70077** | curl works on the `/csv` endpoint. File sizes differ per build, so the `build=` parameter is applied (MEASURED). |
| APL | SimC `midnight` branch, `ActionPriorityLists/default/warlock_*.simc` + GitHub commit history | aff last commit 19 Sep (`91eb5c1ea2`); demo 30 Aug (`50aa1e2eff`, trinket lines only, rotation unchanged since 16 Mar); destro 10 Sep (`d44d740473`) | |
| IV-A / IV-Dm / IV-Ds | Icy Veins rotation pages | Aff **31 Aug**; Demo **10 Aug (before S2)**; Destro **31 Aug** ("Updated AoE rotation section") | Read the hidden talent/hero-tree variants from the DOM. |
| M-A / M-Dm / M-Ds | Method playstyle + talents | Aff **12 Aug (before S2)**; Demo **27 Sep**; Destro **15 Aug (before S2)** | |
| WH-A / WH-Dm / WH-Ds | Wowhead rotation guides | Aff **7 Sep** (Kalamazi); Demo **12 Aug (before S2)**; Destro **12 Aug (before S2)** | |
| PTRN | EU forum thread 627464, JSON of all 6 posts (3 Sep ×3, 15 Sep, 22 Sep, 29 Sep) | fetched 11 Oct | No posts after 29 Sep. |

Units (MEASURED, DB2 PowerType): `SOUL_SHARDS` MaxBasePower 50, DisplayModifier 10, Center/DefaultPower 30. So the cap is **5 Soul Shards**, a cost of `10` in SpellPower is **1 Soul Shard**, and you start with/drift to 3. Matches IV-Ds ("start every fight with 3 Soul Shards/30 Soul Shard Fragments", "maximum of 5 Soul Shards/50 Fragments") and WH-A ("limited to a max of 5").

All 26 `{SPELL:id}` on the three cards resolve in DB2 (live and PTR) to the expected names (MEASURED): 1259790 = Unstable Affliction (the 12.x id), 1257052 = Dark Harvest, 1276672 = Summon Doomguard, 445468 = Wither, 442726 = Malevolence, etc.

---

# 265 Affliction

## 1. Why lines (enUS), with sources

**W1** (S1: Darkglare, then Unstable Affliction)
> While {SPELL:205180} is out, every spell of yours that keeps hurting the enemy hits harder, {SPELL:1259790} too. So call it first, then put on as many {SPELL:1259790} as you can while it lasts.

- Darkglare raises the damage of Agony, Corruption/Wither and Unstable Affliction while active: DB2 205180 description + 1280663 "Darkglare Presence" (+20%), both builds. **MEASURED**. WH-A 7 Sep also says 20%. **MEASURED**
- Darkglare first, then chain Unstable Affliction: WH-A 7 Sep ("cast Darkglare BEFORE you begin to chain cast Unstable Affliction"), IV-A 31 Aug opener, M-A 12 Aug. **MEASURED**
- Several Unstable Afflictions can stack: DB2 1259790 "Multiple uses of this ability may overlap". **MEASURED**
- Darkglare no longer extends DoTs: M-A 12 Aug. **MEASURED**

**W2** (S2: Agony and Corruption)
> {SPELL:980} sometimes gives you a Soul Shard while it hurts: that is where your Soul Shards come from. {SPELL:172} keeps hurting too, and sometimes lights up {SPELL:108558}: your next filler spell is then quicker and hits harder.

- Agony "sometimes generates 1 Soul Shard": DB2 980. Also DB2 246985 (Soul Shards): for Affliction, Soul Shards come from Agony's damage. **MEASURED**. IV-A 31 Aug calls Agony "the sole source of Soul Shard generation in the regular rotation". **MEASURED**
- Nightfall 108558: Corruption/Wither damage has a chance to buff your next Shadow Bolt/Drain Soul/Malefic Grasp. The buff (264571) gives +25% damage. Shadow Bolt becomes instant; Drain Soul and Malefic Grasp channel 50% faster. Lasts 12 s, up to 2 stacks. All in DB2. **MEASURED**. The summary "quicker and hits harder" is **INFERRED**.

**W3** (S3: Haunt and Dark Harvest)
> {SPELL:48181} makes the enemy take more damage from you for a while. {SPELL:1257052} hurts every enemy that has your spells on it, and as Soul Harvester it also hands you Soul Shards.

- Haunt raises your damage on the target for 18 s, has a 15 s cooldown, and its cooldown resets if the target dies: DB2 48181. **MEASURED**
- Dark Harvest hits each target that has your damaging DoTs on it, over a 3 s channel, and heals you: DB2 1257052. **MEASURED**
- Soul Harvester (Shadow of Death, 449638) grants 1 Soul Shard per second while you channel: DB2 (s2 = 1). **MEASURED**. Over a 3 s channel that makes 3 Soul Shards (**INFERRED** arithmetic). M-A 12 Aug and WH-A 7 Sep both say 3. **MEASURED**
- As Hellcaller, Dark Harvest gives no Soul Shards: WH-A 7 Sep. **MEASURED**

**W4** (S4: Unstable Affliction near 5 Soul Shards)
> You can hold at most 5 Soul Shards: any you make after that are lost. Each {SPELL:1259790} costs 1 and is its own spell on the enemy, so several can hurt it at the same time.

- Cap of 5 (PowerType). **MEASURED**. Unstable Affliction costs 1 Soul Shard (SpellPower cost 10, type 7). **MEASURED**. The overlap is in DB2 1259790. **MEASURED**

**W5** (S5: Drain Soul / Shadow Bolt)
> {SPELL:198590} or {SPELL:686} fills the gaps and can light up {SPELL:1260264}: your next {SPELL:1259790} is then free and instant. While {SPELL:205180} is out, the same button becomes {SPELL:1261149}: it makes all your other spells on the enemy deal an extra bit of damage right away.

- Shard Instability 1260264: damage from Drain Soul or Shadow Bolt has a chance (10% or 20%) to make your next Unstable Affliction (or Seed) free and instant. The buff (1260269) lasts 30 s and stacks to 3. DB2. **MEASURED**
- Malefic Grasp 1261149: "While Darkglare is active, your Drain Soul/Shadow Bolt becomes Malefic Grasp". DB2, plus override aura 1279659, which replaces 686 and 198590 with 1261153. **MEASURED**
- 1261153: a 4 s channel. Each tick makes your other Affliction DoTs instantly deal 30% of a normal tick. DB2. **MEASURED**. "An extra bit of damage" is the **INFERRED** simplification.
- Malefic Grasp sits at the centre of the Darkglare window in all three guides: IV-A 31 Aug, M-A 12 Aug, WH-A 7 Sep. **MEASURED**

**WAOE**
> Every {SPELL:980} can give Soul Shards, so more enemies with it means more Soul Shards. {SPELL:27243} bursts on the group and puts {SPELL:172} on every enemy near it.

- Agony makes Soul Shards: DB2. **MEASURED**. "More Agonies means more Soul Shards" is **INFERRED** (each Agony rolls on its own damage). It is supported by M-A 12 Aug ("Reapply … Agonies to keep enough shards"). **MEASURED**
- Seed of Corruption explodes after 12 s, or earlier once the target takes enough damage. It hits all enemies within range and applies Corruption/Wither to them: DB2 27243. **MEASURED**. IV-A 31 Aug: with 3+ stacked targets, use Seed to apply and keep up Corruption. **MEASURED**

## 2. Dutch (nlNL)

- **W1** Zolang {SPELL:205180} er is, doen al je spells die pijn blijven doen meer schade, ook {SPELL:1259790}. Roep hem dus eerst, en leg daarna zo veel mogelijk {SPELL:1259790} zolang hij er is.
- **W2** {SPELL:980} geeft je soms een Soul Shard terwijl hij pijn doet: daar komen je Soul Shards vandaan. {SPELL:172} doet ook pijn en laat soms {SPELL:108558} oplichten: je volgende opvuller is dan sneller en raakt harder.
- **W3** {SPELL:48181} laat de vijand een tijdje meer schade van jou krijgen. {SPELL:1257052} raakt elke vijand waar jouw spells op zitten, en als Soul Harvester geeft hij je ook Soul Shards.
- **W4** Je kunt hoogstens 5 Soul Shards hebben: wat je daarna maakt, ben je kwijt. Elke {SPELL:1259790} kost er 1 en is een eigen spell op de vijand, dus er kunnen er meerdere tegelijk pijn doen.
- **W5** {SPELL:198590} of {SPELL:686} vult de gaten en kan {SPELL:1260264} laten oplichten: je volgende {SPELL:1259790} is dan gratis en instant. Zolang {SPELL:205180} er is, wordt dezelfde knop {SPELL:1261149}: die laat al je andere spells op de vijand meteen een extra beetje schade doen.
- **WAOE** Elke {SPELL:980} kan Soul Shards geven, dus hoe meer vijanden hem hebben, hoe meer Soul Shards. {SPELL:27243} barst open in de groep en zet {SPELL:172} op elke vijand in de buurt.

## 3. TERMS

One word carries the card: **Soul Shards**. A second candidate, "DoT", is already covered by the IDEA wording ("spells that keep hurting").

- **enUS** `PLAYCARD_265_TERMS` = "Soul Shards are your Warlock power: you can hold at most 5. As Affliction, {SPELL:980} makes them while it hurts; {SPELL:1259790} and {SPELL:27243} each spend 1. Out of combat they slowly fill back up to 3."
- **nl** "Soul Shards zijn je Warlock-kracht: je kunt er hoogstens 5 hebben. Als Affliction maakt {SPELL:980} ze terwijl hij pijn doet; {SPELL:1259790} en {SPELL:27243} kosten er elk 1. Buiten gevecht vullen ze langzaam aan tot 3."
- Numbers: cap 5 (PowerType), cost 1 each (SpellPower 10 for both), refill to 3 (DB2 246985 "While out of combat you regenerate up to 3 Soul Shards"). All **MEASURED**.

## 4. Quiz

| Step | Last {SPELL} (current answer) | Fair? | Proposal |
|---|---|---|---|
| S1 | 1259790 Unstable Affliction | Weak. The step's point is the cooldown, and Unstable Affliction is also S4's answer. | `[1] = 205180` (Darkglare) |
| S2 | 980 Agony (both mentions blanked) | Yes: "____ makes your Soul Shards" is the point. | none |
| S3 | 1257052 Dark Harvest | Yes; Haunt and Dark Harvest carry equal weight. | none |
| S4 | 1259790 Unstable Affliction | Yes. Risk: if Seed (27243) is drawn as a wrong choice, it is also a Soul Shard spender. | none |
| S5 | 686 Shadow Bolt (the alternative in brackets) | Weak. The card names Drain Soul as the main one. | `[5] = 198590`. If S5 is swapped to "Shadow Bolt (or Drain Soul)" (see card errors), use `[5] = 686`. |
| AOE | 1259790 Unstable Affliction | No: it is the spell you stop using. | `AOE = 27243` (Seed) |

→ `quizAnswer = { [1] = 205180, [5] = 198590, AOE = 27243 }`. Every step has a spell. Pool: 9 spells.

## 5. Card errors (265)

1. **AOE "{SPELL:980} on 4 to 6 enemies" is outdated.** The 4-6 comes from M-A, dated 12 Aug, before S2. Newer sources:
   - IV-A 31 Aug: Agony on up to 10 targets (Soul Harvester) or up to 14 (Hellcaller).
   - APL from 27 Aug on (`b48def9c26`, still current): Soul Harvester `active_dot.agony<12`, Hellcaller `<14`. Before that it was 10 for Soul Harvester and 8 for Hellcaller (12 Aug, `92f1dc3780`).
   - WH-A 7 Sep: "a handful".
   All **MEASURED**. Proposal: "{SPELL:980} on every enemy you can reach (up to about 10)". Or drop the number: "on as many enemies as you can".
2. **AOE "3 or more close together: {SPELL:27243} instead of {SPELL:1259790}": the sources disagree.**
   - IV-A 31 Aug: with 3+ stacked targets, use Seed to *apply Corruption*. As a spender only at 5 Soul Shards with 6+ targets, or with 3+ if you have Sow the Seeds (196226). Sow the Seeds is off by default in IV.
   - APL since 27 Aug (Soul Harvester and Hellcaller AoE): `seed_of_corruption,if=talent.sow_the_seeds|active_enemies>5`, then `unstable_affliction`. So without Sow the Seeds, 3-5 targets still spend on Unstable Affliction.
   - WH-A 7 Sep and M-A 12 Aug: "Seed as many times as possible" / "dump all shards into Seed".
   All **MEASURED**. A beginner-proof option: "3 or more close together: {SPELL:27243} to put Corruption on all of them; spend Soul Shards on it from 6 enemies (from 3 with Sow the Seeds)." Rob's choice; the card is short by design.
3. **S5 order (minor).** IV-A 31 Aug recommends *Improved Shadow Bolt* (453080) over Drain Soul by default; the switch has Drain Soul off. M-A 12 Aug says "depending on talent choice". **MEASURED**. Optional: "Nothing else? {SPELL:686} (or {SPELL:198590})".
4. **Malefic Grasp is missing (minor).** All three guides make the Darkglare window about Malefic Grasp. It needs no extra button (W5 explains it). No change needed if W5 is used.
5. Checked and correct:
   - S1, S2 (pandemic: Agony 18 s and Corruption 14 s in DB2 match IV's 5.4 s / 4.2 s).
   - S3, S4, MISTAKE ("needs time to grow": DB2 "Damage starts low and increases … Refreshing Agony maintains its current damage level").
   - HERO1: Soul Harvester is best per IV-A (best choice for single target and AoE) and M-A talents 12 Aug. "Gives you 3 back": see W3.
   - HERO2: Wither replaces Corruption (DB2 445468). Malevolence adds Wither stacks when you spend Soul Shards (DB2 442726). M-A says to save Soul Shards for Malevolence.
   All **MEASURED**.

## 6. 12.1.5 (265)

PTRN, all 6 posts: **no Warlock section**. Positive control: the same posts list Demon Hunter, Hunter, Warrior, Druid, Evoker, Mage, Priest, Rogue, Monk and Shaman. **MEASURED**

DB2 live vs PTR for every card spell and every talent named above:
- Unstable Affliction and Agony change only their **PvP multiplier** (Agony 0.4167 → 0.7; Unstable Affliction 1 → 1.1).
- Text-only fixes: the Malevolence aura text ("Malefic Rapture" → "Unstable Affliction"), and the Shard Instability aura text, which now also names Seed.
- No change to costs, durations, cooldowns or charges.
All **MEASURED**. → Nothing changes the W lines, TERMS or card.
New PTR spells 1292885/1292894/1292895 named "Agony" are an area effect on "nearby enemies". They are not the player's Agony (**INFERRED**: new ids, different targeting).

---

# 266 Demonology

## 1. Why lines (enUS), with sources

**W1** (S1: Tyrant, then Hand of Gul'dan)
> {SPELL:265187} hits harder for every Wild Imp and Dreadstalker that is out, counted the whole time he fights. So every {SPELL:105174} right after him adds imps that make him stronger, and with {SPELL:1276163} it also calls extra demons.

- Tyrant damage rises "for each Wild Imp and Dreadstalker active": DB2 265187 + 1276788. **MEASURED**
- The count is dynamic, with no snapshot. The rotation moved "from a pre-Tyrant setup to a post-Tyrant cast sequence". Source: IV-Dm 10 Aug. **MEASURED**, but the page predates S2. The APL Soul Harvester list and the M-Dm 27 Sep opener (Tyrant → Hand of Gul'dan) agree. **MEASURED**
- Dominion of Argus 1276163 (the Apex talent): the Tyrant opens a portal, and every 2 Hand of Gul'dan casts summon a demon. DB2. During the portal, Hand of Gul'dan refunds 1 Soul Shard (DB2 1276222). **MEASURED**. M-Dm 27 Sep confirms both. **MEASURED**

**W2** (S2: Dreadstalkers)
> {SPELL:104316} calls two Dreadstalkers that hit hard. When they leave, they always give you a {SPELL:267102}, and while they are out they make your {SPELL:265187} stronger.

- 2 Dreadstalkers (DB2 s1 = 2); a 100% Demonic Core chance when they fade (DB2 267102 s2 = 100); they count for the Tyrant (DB2 265187). **MEASURED**. "Hit hard" is flavour (**INFERRED**).

**W3** (S3: Hand of Gul'dan at 3+ Soul Shards)
> {SPELL:105174} always costs 3 Soul Shards and drops Wild Imps that fight for you. Each imp that fades can also leave a {SPELL:267102} behind.

- Fixed cost of 3 Soul Shards: SpellPower 105174 cost 30, OptionalCost 0 (**MEASURED**). IV-Dm says "a fixed cost of Hand of Gul'dan" (**MEASURED**).
- Wild Imps that fade or are imploded have a 10% Demonic Core chance: DB2 267102 s1 = 10. **MEASURED**

**W4** (S4: Demonbolt with Demonic Core)
> {SPELL:267102} makes {SPELL:264178} instant, and {SPELL:264178} gives you Soul Shards fast. You can hold 4 Demonic Cores at most, so spend them before new ones are wasted; keeping one back is handy for when you must move.

- The Demonic Core buff 264173 cuts Demonbolt's cast time by 100% (instant), lasts 20 s and stacks to 4. DB2. **MEASURED**. IV-Dm also says "maximum of 4 stacks".
- Demonbolt "Generates 2 Soul Shards": DB2. **MEASURED**
- "Hold on to 1 core proc for movement": M-Dm 27 Sep. **MEASURED**

**W5** (S5: Shadow Bolt)
> {SPELL:686} has no cooldown and gives you a Soul Shard every cast, so it fills every gap.

- DB2 686: no cooldown; "Generates 1 Soul Shard" for Demonology. DB2 246985: "Soul Shards are generated by your Shadow Bolt". **MEASURED**

**WAOE**
> {SPELL:196277} blows up to 6 Wild Imps at once and then has a cooldown, so wait until 6 are out. With {SPELL:460551}, each {SPELL:264178} plants a slow bomb on its enemy, so give every enemy its own.

- Implosion takes up to 6 Wild Imps (DB2 s1 = 6) and has a 15 s cooldown (DB2). WH-Dm 12 Aug: "15s cooldown … always implode with the 6 Wild Imp maximum". **MEASURED**
- Doom 460551 (talent; Wowhead: "Talent", passive): when Demonbolt consumes a Demonic Core, it dooms the target. Damage hits nearby enemies after 20 s or when the debuff is removed. DB2. **MEASURED**
- Spread Doom: M-Dm 27 Sep, IV-Dm, and the APL `demonbolt,target_if=(!debuff.doom.up)`. **MEASURED**. "Slow bomb" is the **INFERRED** wording.

## 2. Dutch (nlNL)

- **W1** {SPELL:265187} raakt harder voor elke Wild Imp en Dreadstalker die rondloopt, en dat telt hij de hele tijd dat hij vecht. Elke {SPELL:105174} direct na hem brengt dus imps die hem sterker maken, en met {SPELL:1276163} roept hij ook extra demonen op.
- **W2** {SPELL:104316} roept twee Dreadstalkers op die hard slaan. Als ze verdwijnen, krijg je altijd een {SPELL:267102}, en zolang ze er zijn maken ze je {SPELL:265187} sterker.
- **W3** {SPELL:105174} kost altijd 3 Soul Shards en laat Wild Imps vallen die voor je vechten. Elke imp die verdwijnt, kan ook een {SPELL:267102} achterlaten.
- **W4** {SPELL:267102} maakt {SPELL:264178} instant, en {SPELL:264178} geeft je snel Soul Shards. Je kunt hoogstens 4 Demonic Cores hebben, dus gebruik ze voordat er nieuwe verloren gaan; er één bewaren is handig voor als je moet lopen.
- **W5** {SPELL:686} heeft geen cooldown en geeft je bij elke cast een Soul Shard, dus hij vult elk gat.
- **WAOE** {SPELL:196277} laat tot 6 Wild Imps tegelijk ontploffen en heeft daarna een cooldown, dus wacht tot er 6 rondlopen. Met {SPELL:460551} legt elke {SPELL:264178} een tijdbom op zijn vijand, dus geef elke vijand zijn eigen.

## 3. TERMS

The card leans on **Soul Shards**. Demonic Core is explained in S4 and W4.

- **enUS** "Soul Shards are your Warlock power: you can hold at most 5. As Demonology, {SPELL:686} and {SPELL:264178} make them, and {SPELL:105174} spends 3 to call Wild Imps. Out of combat they slowly fill back up to 3."
- **nl** "Soul Shards zijn je Warlock-kracht: je kunt er hoogstens 5 hebben. Als Demonology maken {SPELL:686} en {SPELL:264178} ze, en {SPELL:105174} kost er 3 om Wild Imps op te roepen. Buiten gevecht vullen ze langzaam aan tot 3."
- Numbers: cap 5, Hand of Gul'dan costs 3, refill to 3. All **MEASURED** (PowerType, SpellPower, 246985).

## 4. Quiz

| Step | Last {SPELL} | Fair? | Proposal |
|---|---|---|---|
| S1 | 105174 Hand of Gul'dan | Weak. The step's point is the Tyrant, and Hand of Gul'dan is also S3's answer. | `[1] = 265187` |
| S2 | 1276672 Summon Doomguard (an optional talent) | No. | `[2] = 104316` |
| S3 | 105174 Hand of Gul'dan | Yes. Small risk: Call Dreadstalkers is also a Soul Shard spender if drawn as a wrong choice. | none |
| S4 | 264178 Demonbolt | Yes | none |
| S5 | 686 Shadow Bolt | Yes | none |
| AOE | 264178 Demonbolt (already S4's answer) | No. The point is Implosion. | `AOE = 196277` |

→ `quizAnswer = { [1] = 265187, [2] = 104316, AOE = 196277 }`. Pool: 7 spells.

## 5. Card errors (266)

1. **IDEA describes the old Tyrant.** "Spend Soul Shards to summon an army of demons, then call a Tyrant who makes them all stronger." In 12.1:
   - The Tyrant's own damage scales with the demons that are out (DB2 265187).
   - Play is Tyrant **first**, then Hand of Gul'dan (IV-Dm, M-Dm 27 Sep opener, WH-Dm opener). The card's own S1 and MISTAKE already say this.
   - "Makes them all stronger" holds only with Diabolist's Abyssal Dominion (DB2 429581/456323: "Your demons deal X% increased damage while your Demonic Tyrant is active").
   All **MEASURED**. Proposal: EN "Call a Tyrant, then spend Soul Shards on an army of demons: every demon makes the Tyrant hit harder." NL "Roep een Tyrant op en geef dan Soul Shards uit aan een leger demonen: elke demon laat de Tyrant harder slaan."
2. **Implosion on single target (optional).** With To Hell and Back (1281511, on by default in IV-Dm), Implosion at 6 imps is also used on one target. IV-Dm, M-Dm 27 Sep ("even worth to press Implosion in single target") and the APL (`implosion,if=…(active_enemies>2|talent.to_hell_and_back)`) agree. **MEASURED**. The card has Implosion only in AOE.
3. **HERO1 "Diabolist (best this season)".** M-Dm 27 Sep: "In 12.1 Diabolist looks to be the stronger hero talent." IV-Dm (10 Aug, before S2) marks Soul Harvester as best for single target and Diabolist as best for AoE. **MEASURED**. The newer source agrees with the card; keep it.
4. **HERO2 is correct.** Soul Harvester's Shadow of Death makes the Tyrant grant 3 Soul Shards (DB2 449638/449858, cost 30 = 3). M-Dm 27 Sep says to "cast it with 2 out of 5 shards". **MEASURED**
5. Checked and correct:
   - S2: Doomguard is a 2-minute cooldown costing 1 Soul Shard, and consuming a Demonic Core lowers its cooldown (DB2).
   - S3: Hand of Gul'dan at 3+ (M-Dm 27 Sep "Hand of Gul'dan on 3+ Shards"; APL `soul_shard>=3`). IV-Dm says 4-5.
   - S4: 2+ cores (IV-Dm and M-Dm).
   - S5, MISTAKE: M-Dm "save 2-3 Demonic Core and have 4-5 shards before entering a tyrant".
   - HERO1 Ruination: DB2 428522/433885, "Your next Hand of Gul'dan becomes Ruination", a 20 s buff.
   All **MEASURED**.
6. Leftover in a guide, not on the card: M-Dm 27 Sep still says the Tyrant should "extend all your big demons (Dreadstalkers and Vilefiend)". DB2 shows no extension on 265187. Only Reign of Tyranny (1276748) extends Dreadstalkers by 15 s. Do not copy that sentence.

## 6. 12.1.5 (266)

No Warlock section in PTRN (see 265). DB2 live vs PTR shows no differences for 265187, 105174, 104316, 1276672, 264178, 196277, 686, 267102, 264173, 1276163, 1276222, 460551 or 449638. **MEASURED**. Nothing changes.

---

# 267 Destruction

## 1. Why lines (enUS), with sources

**W1** (S1: Summon Infernal)
> {SPELL:1122} drops a big fire demon that stuns the enemies where it lands. While it stays, it burns everything near it and slowly gives you Soul Shards.

- DB2 1122: a stun on impact, and the Infernal serves 30 s (111685). It deals periodic damage to all nearby enemies and generates a Soul Shard Fragment every second (264364/264365). **MEASURED**
- IV-Ds 31 Aug: "passively generating Shards … best used on cooldown". **MEASURED**

**W2** (S2: Immolate)
> {SPELL:348} keeps burning, and every burn tick gives you a piece of a Soul Shard. Renewing it in the last few seconds is safe: the time that was left is added on.

- Immolate DoT lasts 18 s (DB2 157736). Each tick gives 1 Soul Shard Fragment, plus a 50% chance of 1 more on a crit (DB2 s2 = 50; IV-Ds). **MEASURED**
- Pandemic: refresh with under 30% left, i.e. 5.4 s (IV-Ds 31 Aug). **MEASURED**. Wither (Hellcaller) also lasts 18 s (DB2 445474). **MEASURED**

**W3** (S3: Soul Fire and Conflagrate)
> {SPELL:6353} gives you a whole Soul Shard at once and puts {SPELL:348} on too. {SPELL:17962} gives a piece and gives you {SPELL:196406}: your next slow spell casts faster. At 2 charges it stops filling, so do not let it wait.

- Soul Fire: 10 fragments (1 Soul Shard; 281490), applies Immolate/Wither, 45 s cooldown. DB2. **MEASURED**
- Conflagrate: 5 fragments (245330), 2 charges (SpellCategory 672 MaxCharges 2). DB2. **MEASURED**
- Backdraft: the talent 196406 and the buff 117828, −30% cast time on the next Incinerate, Chaos Bolt or Soul Fire. DB2. **MEASURED**
- "Avoid sitting on 2 charges": M-Ds 15 Aug, WH-Ds, and IV-Ds ("Cast Conflagrate if you have 2 charges"). **MEASURED**

**W4** (S4: Chaos Bolt near 5 Soul Shards; Shadowburn)
> {SPELL:116858} costs 2 Soul Shards and always crits, so spend on it before you hit the cap of 5. {SPELL:17877} normally only works on enemies below 20% health, but {SPELL:1245633} sometimes makes it free and usable on any enemy: then you can press it.

- Chaos Bolt: costs 2 (SpellPower 20), "dealing a critical strike … further increased by your critical strike chance". DB2. **MEASURED**
- Shadowburn is usable only below 20% health (DB2 s4 = 20), costs 1, and refunds if the target dies within 5 s (1311913). **MEASURED**. IV-Ds: "returns in Midnight as an execute ability". **MEASURED**
- Fiendish Cruelty 1245633: crits from Chaos Bolt, Conflagrate or Incinerate have a 10% chance to make your next Shadowburn (within 30 s) free and usable on any target. DB2 (+ buff 1245664). IV-Ds links the same id. **MEASURED**
- "That is when it lights up" (the card's S4 wording) is **INFERRED**: the button becomes usable. The glow cannot be measured outside the client.

**W5** (S5: Incinerate)
> {SPELL:29722} has no cooldown and gives you a piece of a Soul Shard every cast, a bit more when it crits.

- DB2 244670: 2 fragments, plus 1 on a crit. IV-Ds says the same. **MEASURED**

**WAOE**
> {SPELL:80240} makes your single-target spells also hit a second enemy, and those extra hits make Soul Shards too. {SPELL:5740} costs 3 Soul Shards but hurts every enemy standing in it.

- Havoc (DB2 80240): for 15 s your single-target spells also strike the Havoc target for a share of the damage; 30 s cooldown. **MEASURED**
- IV-Ds 31 Aug: "you generate double Soul Shards … consuming abilities still cost the same". **MEASURED**
- Rain of Fire costs 3 (SpellPower 30) and lasts 8 s. DB2. **MEASURED**

## 2. Dutch (nlNL)

- **W1** {SPELL:1122} laat een grote vuurdemon neerkomen die de vijanden waar hij landt stunt. Zolang hij blijft, verbrandt hij alles om zich heen en geeft hij je langzaam Soul Shards.
- **W2** {SPELL:348} blijft branden, en elke tik geeft je een stukje Soul Shard. Vernieuwen in de laatste paar seconden kan geen kwaad: de tijd die nog over was, komt erbij.
- **W3** {SPELL:6353} geeft je in één keer een hele Soul Shard en zet ook {SPELL:348} op de vijand. {SPELL:17962} geeft een stukje en geeft je {SPELL:196406}: je volgende trage spell cast sneller. Bij 2 charges laadt hij niet verder, dus laat hem niet wachten.
- **W4** {SPELL:116858} kost 2 Soul Shards en crit altijd, dus geef ze daaraan uit voordat je de 5 bereikt. {SPELL:17877} werkt normaal alleen op vijanden onder 20% health, maar {SPELL:1245633} maakt hem soms gratis en bruikbaar op elke vijand: dan kun je hem drukken.
- **W5** {SPELL:29722} heeft geen cooldown en geeft je bij elke cast een stukje Soul Shard, iets meer als hij crit.
- **WAOE** {SPELL:80240} laat je spells voor één doelwit ook een tweede vijand raken, en die extra klappen maken ook Soul Shards. {SPELL:5740} kost 3 Soul Shards maar raakt elke vijand die erin staat.

## 3. TERMS

The word is **Soul Shards**, built from **Soul Shard Fragments**. That is the word the player's own tooltips show ("Generates 2 Soul Shard Fragments").

- **enUS** "Soul Shards are your Warlock power: you can hold at most 5. As Destruction you build them in pieces called Soul Shard Fragments (10 make one Soul Shard): {SPELL:29722}, {SPELL:17962} and {SPELL:348} add them. {SPELL:116858} spends 2, {SPELL:5740} spends 3."
- **nl** "Soul Shards zijn je Warlock-kracht: je kunt er hoogstens 5 hebben. Als Destruction bouw je ze op uit stukjes, Soul Shard Fragments (10 stukjes zijn één Soul Shard): {SPELL:29722}, {SPELL:17962} en {SPELL:348} geven ze. {SPELL:116858} kost er 2, {SPELL:5740} 3."
- Numbers: 10 per Soul Shard (PowerType DisplayModifier 10; IV-Ds "3 Soul Shards/30 Soul Shard Fragments"), cap 5, costs 2 and 3. All **MEASURED**.

## 4. Quiz

| Step | Last {SPELL} | Fair? | Proposal |
|---|---|---|---|
| S1 | 1122 Summon Infernal | Yes | none |
| S2 | 348 Immolate | Yes | none |
| S3 | 17962 Conflagrate | Yes; both spells carry equal weight. | none |
| S4 | 17877 Shadowburn (the side option) | No. The point is spending near 5. Risk: Rain of Fire as a wrong choice is also a spender. | `[4] = 116858` |
| S5 | 29722 Incinerate | Yes | none |
| AOE | 116858 Chaos Bolt (what you stop using) | No | `AOE = 5740` |

→ `quizAnswer = { [4] = 116858, AOE = 5740 }`. Pool: 9 spells.

## 5. Card errors (267)

1. **HERO2 contradicts the AOE line and the newer sources.**
   - HERO2: "Diabolist: keep casting {SPELL:116858}, even on packs." The AOE line on the same card says "3 or more close together: {SPELL:5740} instead of {SPELL:116858}".
   - Sources for HERO2: M-Ds **15 Aug** ("not consider casting Rain of Fire until 8+ targets") and WH-Ds **12 Aug** ("Diabolist always spends soul shards on Chaos Bolt"). Both predate S2.
   - Newer: IV-Ds **31 Aug** ("Updated AoE rotation"): Diabolist uses Rain of Fire with **3+** targets and Chaos Bolt/Shadowburn to trigger Diabolic Ritual.
   - APL commit **10 Sep** (`d44d740473`) changed Diabolist AoE. Chaos Bolt with Demonic Art (the demon summon) stays at any count. The "ritual about to end" Chaos Bolt went from ≤10 targets to **≤4** (≤3 with Destructive Rapidity). Rain of Fire at **≥3** targets with ~3.5+ Soul Shards was already in the list.
   All **MEASURED**. Proposal for HERO2: "Diabolist (best in dungeons): when a demon is ready to come out, cast {SPELL:116858}, even on packs: it calls the demon. After a Pit Lord it becomes Ruination: press it." Then the AOE line stays true for both trees.
2. **AOE "3 or more close together: Rain of Fire" is right for Diabolist; Hellcaller uses 4 or more.**
   - IV-Ds 31 Aug (Hellcaller): "Cast Rain of Fire if there are 4+ targets".
   - APL `aoe_hc`: `rain_of_fire,if=…active_enemies>=4` and `chaos_bolt,if=active_enemies<=3`, unchanged on 10 Sep.
   - WH-Ds 12 Aug still says 3+ for Hellcaller without Havoc.
   All **MEASURED**. Option: "3 or more close together (4 or more as Hellcaller): {SPELL:5740} instead of {SPELL:116858}."
3. **AOE Havoc may not be talented.** IV-Ds 31 Aug has Havoc off by default. M-Ds 15 Aug: "We do not talent Havoc or Mayhem" in the Hellcaller single-target build. Havoc does appear in cleave builds, WH-Ds and the APL AoE lists. **MEASURED**. Option: add "(if you have it)". Also, Mayhem (387506) applies Havoc by itself. DB2. **MEASURED**
4. **S3 Soul Fire (minor).** All sources add "below 4 Soul Shards", because Soul Fire gives a whole one: IV-Ds, WH-Ds, APL `soul_fire,if=soul_shard<=4`. **MEASURED**
5. **Possible grey button: Rain of Fire 5740 vs 1214467 (client check).** DB2 and Wowhead have two "Rain of Fire" spells. Both are labelled "Talent"; 1214467 ("cast at your target", added 11.1.0) is the one IV-Ds links. **MEASURED**. If a Destruction player only has 1214467, the card shows 5740 in grey (`IsPlayerSpell`). **INFERRED** risk; the name is identical. Measure in game: `/run print(IsPlayerSpell(5740),IsPlayerSpell(1214467))`.
6. Checked and correct:
   - S1, S2 ("about 5 seconds" = the 5.4 s pandemic), S5, MISTAKE (cap 5).
   - HERO1: Hellcaller is best in raids (M-Ds talents 15 Aug; IV-Ds best choice for single target). Wither replaces Immolate (DB2 445468). "Malevolence on cooldown; spend while it lasts" (M-Ds, WH-Ds, IV-Ds, APL).
   - HERO2 Ruination: DB2 428522, "your next Chaos Bolt becomes Ruination".
   All **MEASURED**.

## 6. 12.1.5 (267)

No Warlock section in PTRN. DB2 live vs PTR:
- Text-only fixes in Conflagration of Chaos 387108 ("critical strike" → "critically strike") and the Malevolence aura text.
- No change to costs, durations, cooldowns or charges for any 267 card spell, Backdraft, Fiendish Cruelty or Diabolic Ritual. SpellCategory 672 is still 2 charges at 12960.
All **MEASURED**. Nothing changes.

---

# All three specs

## Proc, buff and talent ids for `{SPELL:id}`

These are the ids the player knows (talent or passive), not the temporary buff. Every id and name below is **MEASURED** in DB2 (both builds; the name is the same in both). Whether `IsPlayerSpell` is true for that id on a real character is **INFERRED** until it is run in game.

| Word on the card / W line | Use (talent/passive) | Do NOT use | Notes |
|---|---|---|---|
| Nightfall | **108558** | 264571, 1260279 (buffs) | Other 2026 "Nightfall" ids are NPC spells. |
| Shard Instability | **1260264** | 1260269 (buff), 216457 (old) | |
| Malefic Grasp | **1261149** | 1261153 (the button), 170619/235155 (old) | |
| Shadow of Death (Soul Harvester) | **449638** | 449858 | |
| Sow the Seeds | **196226** | | |
| Demonic Core | **267102** | 264173 (buff) | IV-Dm links 267102. |
| Dominion of Argus | **1276163** | **1264292** (Felguard damage talent with the same name), 1276166 (buff) | Easy to mix up. |
| Doom (Demonology) | **460551** | 603 (an active Doom with a 30 s cooldown; IV-Dm links it, but its text does not match the 12.1 play), 460553 (debuff) | Wowhead: 460551 = "Talent", passive. |
| Reign of Tyranny | **1276748** | 427684 (old text) | |
| To Hell and Back | **1281511** | | |
| Diabolic Ritual | **428514** | 470479, 431944 | |
| Ruination | **428522** (talent) | 434635 (button), 433885 (buff) | Both HERO "Ruination" mentions could become {SPELL:428522}. |
| Backdraft | **196406** | 117828 (buff) | |
| Fiendish Cruelty | **1245633** | 1245664 (buff), **456943** (older talent with the same name: cooldown reduction) | |
| Conflagration of Chaos | **387108** | 196546, 219195 | |
| Soul Shards | **246985** (resource passive with description) | 138556 (NPC) | Optional, for the de/fr clients. nlNL keeps "Soul Shards" in English anyway. |
| Wild Imps | keep as plain words | 104317 resolves to the singular "Wild Imp" | |
| Pit Lord | keep as plain words | | No player spell measured. |

Client check, one line per spec (each well under 255 characters):
- Affliction: `/run for _,i in ipairs({108558,1260264,1261149,449638,196226,246985})do print(i,C_Spell.GetSpellName(i),IsPlayerSpell(i))end`
- Demonology: `/run for _,i in ipairs({267102,1276163,460551,428514,428522,449638,1276748,1281511})do print(i,C_Spell.GetSpellName(i),IsPlayerSpell(i))end`
- Destruction: `/run for _,i in ipairs({196406,1245633,387108,428514,428522,5740,1214467})do print(i,C_Spell.GetSpellName(i),IsPlayerSpell(i))end`

## The 12.1.5 recheck

- **MEASURED:** the PTR notes and DB2 show no PvE change for any Warlock spell above.
- **Hide-by-version:** the why lines carry `why.interface = 120100`, so they hide by themselves once 12.1.5 (interface 120105) goes live on 13/14 Oct.
- **INFERRED:** because nothing changed, a recheck after the patch could bump the interface to 120105 for these three cards without rewriting them. Rerun the DB2 diff against the final live build first: 70077 is a PTR build, not the shipped one.

## Where guides and APL disagree (summary)

- **Affliction AoE:** both the Agony count and the Seed vs Unstable Affliction spender differ. Older text (M-A 12 Aug, and WH-A 7 Sep for Seed) against IV-A 31 Aug and the APL from 27 Aug. See 265 §5.
- **Destruction Diabolist AoE:** M-Ds and WH-Ds (12-15 Aug) say Chaos Bolt everywhere. IV-Ds 31 Aug and the APL from 10 Sep use Rain of Fire from 3 targets. See 267 §5.
- **Destruction Hellcaller Rain of Fire threshold:** WH-Ds 12 Aug says 3+; IV-Ds 31 Aug and the APL say 4+.
- **Demonology best hero tree:** IV-Dm 10 Aug splits by content; M-Dm 27 Sep says Diabolist. The newer one matches the card.
