# Why lines, quiz and "Good to know": Enhancement (263), Restoration (264), Arcane (62), Fire (63)

Researched 11 Oct 2026 (mh-research). Nothing in the repo was edited. I did not read anything in `docs/`.

## Sources used (all read on 11 Oct 2026)

| Source | Date on page | Notes |
|---|---|---|
| wago.tools DB2, live **12.1.0.69933** | build | Spell, SpellName, SpellEffect, SpellAuraOptions, SpellCooldowns, SpellCategories/SpellCategory, SpellPower, SpellMisc/SpellDuration. Read through the in-app browser (Inertia JSON). |
| wago.tools DB2, PTR **12.1.5.70077** | build | Same tables, compared field by field with 69933 for 71 spell IDs (see section 6). |
| SimC APL `midnight` branch, `shaman_enhancement.simc` | last commit 15 Sep 2026 | via raw.githubusercontent + GitHub commits API |
| SimC APL `mage_arcane.simc` | last commit 6 Sep 2026 | |
| SimC APL `mage_fire.simc` | last commit 12 Aug 2026 | |
| SimC APL `shaman_restoration.simc` | **does not exist** (HTTP 404) | healers have no APL; guides only |
| Icy Veins Enhancement rotation | 23 Aug 2026 | |
| Icy Veins Arcane rotation | 15 Aug 2026 ("season start tier nerfs") | before 18 Aug, but written for 12.1 S2 |
| Icy Veins Arcane talents | 12 Aug 2026 | |
| Icy Veins Fire rotation | 10 Aug 2026 | written for 12.1 S2 |
| Icy Veins Resto Shaman rotation | 10 Aug 2026 ("Updated for Midnight Season 2 launch") | |
| Method Enhancement | 24 Aug 2026 | |
| Method Arcane | 13 Sep 2026 | |
| Method Fire | 17 Aug 2026 | |
| Method Resto Shaman | 11 Aug 2026 | |
| Wowhead Enhancement rotation | 22 Aug 2026 | |
| Wowhead Arcane rotation | 4 Sep 2026 | |
| Wowhead Fire rotation | 16 Aug 2026 | |
| Wowhead Resto Shaman rotation | **17 Aug 2026** | the card's source line says "Wowhead 5 Sep"; the rotation page shows 17 Aug. Maybe another Wowhead page; not settled. |
| Wowhead tooltip API, spell 188196 | live | "0.2% of base mana" |
| EU forum thread 627464 "Midnight: 12.1.5 PTR Development Notes" | posts 3, 15, 22, 29 Sep 2026 | read as JSON. The thread has 6 posts; the last is 29 Sep. Nothing newer. |

None of the card's guide pages has been updated since the dates in the card's `source` line, except the one Resto/Wowhead date question above.

Labels: **MEASURED** = seen in a named, dated source (DB2 build, APL commit, guide page). **INFERRED** = reasoned by me.

---

# Enhancement Shaman (263)

## 1+2. Why lines (enUS + nl)

**W1** (S1: Ascendance / Doom Winds, then Crash Lightning + Stormstrike)
- enUS: `During {SPELL:114051} or {SPELL:384352} you get Maelstrom Weapon by itself, and every {SPELL:17364} and {SPELL:187874} also spends it on a lightning spell without an extra press. So those two buttons hit and spend at once (in {SPELL:114051}, {SPELL:17364} becomes Windstrike).`
- nl: `Tijdens {SPELL:114051} of {SPELL:384352} krijg je vanzelf Maelstrom Weapon, en elke {SPELL:17364} en {SPELL:187874} geeft die ook meteen uit aan een bliksemspell, zonder extra klik. Die twee knoppen slaan en geven dus tegelijk uit (in {SPELL:114051} wordt {SPELL:17364} Windstrike).`
- Mechanic:
  - Thorim's Invocation (384444): "During Doom Winds or Ascendance, Stormstrike and Crash Lightning consume up to $s1 Maelstrom Weapon to discharge a Lightning Bolt or Chain Lightning at $s2% effectiveness, whichever you most recently used". s1 = 10, s2 = 100. **MEASURED** (DB2 12.1.0.69933).
  - Static Accumulation (384411): "During Doom Winds or Ascendance, you generate $s1 Maelstrom Weapon every … sec". **MEASURED** (DB2). It is in the builds: Icy Veins 23 Aug ("flood of resources during Static Accumulation"), Method 24 Aug, Wowhead 22 Aug ("if taken"). **INFERRED** that both hero builds take it.
  - Ascendance (114051) "transforming your auto attack and Stormstrike into Wind attacks". **MEASURED** (DB2). The name "Windstrike" is from Icy Veins/Wowhead ("Cast Windstrike during Ascendance"). **MEASURED**.

**W2** (S2: Voltaic Blaze and Crash Lightning whenever ready)
- enUS: `{SPELL:470057} always crits, sets Flame Shock on your target and a few enemies nearby, and gives you Maelstrom Weapon; with this season's tier set it also sets off Fire Novas. {SPELL:187874} hits everything in front of you, and for a short time after, {SPELL:17364} and {SPELL:60103} zap those enemies too.`
- nl: `{SPELL:470057} crit altijd, zet Flame Shock op je doelwit en een paar vijanden eromheen, en geeft je Maelstrom Weapon; met de tier set van dit seizoen laat hij ook Fire Novas ontploffen. {SPELL:187874} raakt alles vóór je, en daarna zappen {SPELL:17364} en {SPELL:60103} die vijanden even mee.`
- Mechanic:
  - 470057: "Instantly shocks the target and $s4 enemies … applying Flame Shock … Always critically strikes … Generates $s2 stacks of Maelstrom Weapon". **MEASURED** (DB2).
  - S2 tier 2-piece: Voltaic Blaze makes the target erupt in Fire Nova. This puts it at the top of the priority. **MEASURED** (Icy Veins 23 Aug; APL 15 Sep `voltaic_blaze,if=set_bonus.midnight_season_2_2pc` high in both single-target lists).
  - 187874: "Electrocutes all enemies in front of you … Enhances your weapons for $187878d, causing Stormstrike and Lava Lash to discharge … Nature damage split between up to … enemies in front of you". **MEASURED** (DB2).
  - Flame Shock is not on the Enhancement card, so it stays plain text.

**W3** (S3: 10 Maelstrom Weapon, then Lightning Bolt; never below 5)
- enUS: `Every Maelstrom Weapon stack makes {SPELL:188196} faster and stronger, and at 5 it is instant. You can hold 10, so wait for 10 for one big hit, but do not go over: stacks above 10 are lost.`
- nl: `Elke Maelstrom Weapon-stack maakt {SPELL:188196} sneller en sterker, en bij 5 is hij instant. Je kunt er 10 vasthouden: wacht dus op 10 voor één grote klap, maar ga er niet overheen, want stacks boven de 10 ben je kwijt.`
- Mechanic:
  - Each stack: 20% less cast time and 20% more damage; instant at 5. **MEASURED** in Icy Veins 23 Aug. DB2 344179 has bp −20/+20 and the aura text caps the cast-time cut at 100%. **MEASURED**.
  - Base cap is 5 (344179 CumulativeAura = 5). Overflowing Maelstrom (384143) adds +5, so the cap is 10. Raging Maelstrom (384149) lets you spend up to 10 at once (s1 = 10). **MEASURED** (DB2).
  - Stacks above the cap are lost: Icy Veins FAQ says "avoid going above 10 stacks". **MEASURED**.

**W4** (S4: nothing else, so Stormstrike, then Lava Lash)
- enUS: `{SPELL:17364} hits with both weapons, and weapon hits are what give you Maelstrom Weapon. Every stack you spend makes {SPELL:17364} and {SPELL:60103} ready sooner, so keep them rolling.`
- nl: `{SPELL:17364} slaat met allebei je wapens, en juist wapenklappen geven je Maelstrom Weapon. Elke stack die je uitgeeft zet {SPELL:17364} en {SPELL:60103} sneller weer klaar, dus houd ze aan het rollen.`
- Mechanic:
  - 17364: "Energizes both your weapons … massive blow". 187880: "When you deal damage with a melee weapon, you have a chance to generate Maelstrom Weapon". **MEASURED** (DB2).
  - Elemental Tempo (1250364): each stack spent cuts the cooldown of Stormstrike and Lava Lash (300 ms each per stack). **MEASURED** (DB2; Icy Veins says 0.3 s).
  - Stormbringer's main strike is Stormstrike: Wowhead 22 Aug, Icy Veins 23 Aug. **MEASURED**.

**WAOE** (AOE: Chain Lightning from 2 enemies; keep Crash Lightning going)
- enUS: `{SPELL:188443} jumps from enemy to enemy, so from 2 enemies the same stacks do more damage than with {SPELL:188196}. {SPELL:187874} makes your strikes zap the enemies in front of you too, so keep it going.`
- nl: `{SPELL:188443} springt van vijand naar vijand, dus vanaf 2 vijanden doen dezelfde stacks meer schade dan met {SPELL:188196}. {SPELL:187874} laat je klappen ook de vijanden vóór je raken, dus houd hem bij.`
- Mechanic:
  - 188443 "jumping to additional nearby enemies". **MEASURED** (DB2).
  - The switch at 2 targets: Method 24 Aug ("At two targets replace Lightning Bolt with Chain Lightning") and APL (the aoe list runs from `active_enemies>1`). **MEASURED**.
  - "More damage from 2 targets" is **INFERRED** from that switch.
  - Crash Lightning as in W2. **MEASURED**.

## 3. TERMS: one word carries this card, Maelstrom Weapon
- enUS: `Maelstrom Weapon is a stack you build by hitting with your weapons. Each stack makes your next {SPELL:188196} or {SPELL:188443} faster and stronger: at 5 it is instant, and with your talents you can hold and spend 10. Spending it also makes your strikes come back sooner.`
- nl: `Maelstrom Weapon is een stack die je opbouwt door met je wapens te slaan. Elke stack maakt je volgende {SPELL:188196} of {SPELL:188443} sneller en sterker: bij 5 is hij instant, en met je talenten kun je er 10 vasthouden en uitgeven. Uitgeven zet je klappen ook sneller weer klaar.`
- Numbers: 5 and 10 are **MEASURED** (DB2 344179/384143/384149 and Icy Veins). "Come back sooner" is Elemental Tempo, **MEASURED** (DB2 1250364).

## 4. Quiz
| Step | Last {SPELL} (default answer) | Fair? | Proposal |
|---|---|---|---|
| S1 | 17364 Stormstrike | No. The point is the big cooldown, and Crash Lightning in the same sentence is just as right. | `quizAnswer[1] = 114051` (Ascendance) |
| S2 | 187874 Crash Lightning | Yes | keep |
| S3 | 188196 Lightning Bolt | Yes | keep |
| S4 | 60103 Lava Lash | Yes ("Stormstrike, then ____") | keep |
| AOE | 187874 Crash Lightning | No. The point is Chain Lightning replacing Lightning Bolt. | `quizAnswer.AOE = 188443` |

So: `quizAnswer = { [1] = 114051, AOE = 188443 }`. Every step has a spell.

## 5. Card errors / outdated (12.1 S2)
- **Spell IDs:** all 11 IDs resolve to the right names in DB2 12.1.0.69933. **MEASURED**.
- **HERO1** ("Ascendance is your 2-minute burst") is correct. Ascendance base cooldown is 180 s, and Thorim's Invocation takes off 60 s (384444 effect 3, bp −60000), so 120 s. **MEASURED** (DB2).
- **HERO2 (Totemic) leaves out Primordial Storm.**
  - Method 24 Aug Totemic priority: "Primordial Storm at 10 Maelstrom Weapon" (3rd). The APL `single_totemic` also has `primordial_storm` at ≥10 Maelstrom Weapon.
  - DB2 1218047: "Sundering transforms into a single use Primordial Storm … after it is cast."
  - It is not in the Stormbringer build: Wowhead 22 Aug says Stormbringer "only plays one loadout", and its priority has no Primordial Storm. **MEASURED**.
  - Optional addition to HERO2: "After {SPELL:197214} it turns into Primordial Storm: press it at 10 stacks." (plain text, no ID checked)
- **HERO2 "every minute Surging Totem":**
  - Method 24 Aug ("changed from a maintenance totem to a 1 minute cooldown") and Icy Veins ("as close to every minute as possible") agree. **MEASURED**.
  - DB2 444995 SpellCooldowns says **25 s** (one row, shared with the Resto version). I could not find what makes it 60 s for Enhancement. Not an error in the card, but **the number is not confirmed in DB2**.
- **HERO2 order** (Surging Totem, Sundering, Lava Lash with Hot Hand, Doom Winds) matches Icy Veins 23 Aug and the APL `single_totemic`. Method 24 Aug puts Doom Winds 2nd. The card matches the APL; no change.
- **S2:** Voltaic Blaze goes first only because of the S2 2-piece. Method's text still calls it "mainly a filler", but Method's own list puts it first. Correct for S2-geared players.
- **IDEA, minor wording:** "free, instant lightning spell". Maelstrom Weapon only removes cast time. Lightning Bolt still costs 0.2% of base mana (DB2 SpellPower 188196; Wowhead tooltip). **MEASURED**. Suggest "an instant lightning spell". Low priority.
- MISTAKE is correct: Icy Veins FAQ says never hard-cast, and also that it resets your swing timer. **MEASURED**.

---

# Restoration Shaman (264)

## 1+2. Why lines

**W1** (S1: Healing Stream Totem; never both charges full; Stormstream Totem)
- enUS: `{SPELL:5394} is a totem that keeps healing hurt allies while you do other things. A charge that sits full is healing you never get back, and the Stormstream version heals much more, so press that one soon as well.`
- nl: `{SPELL:5394} is een totem die gewonde bondgenoten blijft healen terwijl jij iets anders doet. Een charge die vol blijft staan is healing die je nooit meer terugkrijgt, en de Stormstream-versie healt veel meer, dus druk die ook snel.`
- Mechanic:
  - 5394: "Summons a totem … that heals an injured party or raid member … every … sec". A second rank gives extra charges. **MEASURED** (DB2).
  - "Full charges are lost healing" is **INFERRED** (normal charge behaviour; the charge category is 1569 with a 30 s recharge, **MEASURED**).
  - 1267016: Stormstream "heals $s2% more, heals $s3 additional allies … and heals $s5 injured allies … when used". **MEASURED** (DB2).
  - "Press it soon": Wowhead 17 Aug says the proc lasts 60 s and you "don't need to use them immediately", but are "heavily incentivized to do so as soon as possible". **MEASURED**.

**W2** (S2: Riptide on cooldown, on someone without it)
- enUS: `{SPELL:61295} heals at once and then keeps healing for a while; many of your talents work better the more allies have it, so give it to someone new. Each cast also speeds up your next {SPELL:77472} or {SPELL:1064} and can light up Stormstream Totem.`
- nl: `{SPELL:61295} healt meteen en blijft daarna nog een tijdje healen; veel van je talenten werken beter naarmate meer bondgenoten hem hebben, dus geef hem aan iemand die hem nog niet heeft. Elke cast maakt ook je volgende {SPELL:77472} of {SPELL:1064} sneller en kan Stormstream Totem laten oplichten.`
- Mechanic:
  - 61295: "healing them for $s1 and an additional $o2 over $d". **MEASURED** (DB2).
  - Wowhead 17 Aug: "Undercurrent, Deluge, Flow of the Tides, and Tidewaters greatly benefit from having as many Riptides active as possible". **MEASURED**.
  - Tidal Waves (51564): "Casting Riptide grants $s1 stacks of Tidal Waves … reduces the cast time of your next Healing Wave or Chain Heal". **MEASURED** (DB2). Wowhead plays around it. **MEASURED**.
  - Stormstream chance from Riptide (1267016). **MEASURED** (DB2).

**W3** (S3: Unleash Life, then Healing Wave on one or Chain Heal on several)
- enUS: `{SPELL:73685} heals a little and makes your next {SPELL:77472} or {SPELL:1064} heal more and cast faster. {SPELL:77472} is cheap and strong on one person; {SPELL:1064} costs more mana but jumps to the most hurt allies nearby.`
- nl: `{SPELL:73685} healt een beetje en laat je volgende {SPELL:77472} of {SPELL:1064} meer healen en sneller casten. {SPELL:77472} is goedkoop en sterk op één persoon; {SPELL:1064} kost meer mana maar springt naar de meest gewonde bondgenoten in de buurt.`
- Mechanic:
  - 73685: "Increases the healing of your next Riptide, Chain Heal, or Healing Wave by $s2% and reduces its cast time by $s3%". **MEASURED** (DB2).
  - Costs: Healing Wave 2.38% and Chain Heal 4.28% of base mana (the Resto row). **MEASURED** (DB2 SpellPower). Wowhead 17 Aug agrees: Healing Wave "very cheap", Chain Heal "much more expensive". **MEASURED**.
  - 1064: "jumps … to heal the most injured nearby allies". **MEASURED** (DB2).

**W4** (S4: nobody needs healing, so Flame Shock, Lava Burst, Lightning Bolt)
- enUS: `{SPELL:51505} always crits on an enemy with {SPELL:470411} on it, so put that on first. These three cost almost no mana, so in quiet moments you help kill things while your mana fills up.`
- nl: `{SPELL:51505} crit altijd op een vijand met {SPELL:470411} erop, dus zet die er eerst op. Deze drie kosten bijna geen mana, dus in rustige momenten help je mee met schade terwijl je mana weer volloopt.`
- Mechanic:
  - 51505: "will always critically strike if the target is affected by Flame Shock". **MEASURED** (DB2).
  - Costs: Flame Shock 0.3%, Lava Burst 0.5%, Lightning Bolt 0.2% of base mana. **MEASURED** (DB2 SpellPower; Wowhead tooltip shows the same 0.2% for Lightning Bolt).
  - Icy Veins 10 Aug says "Lightning Bolt is cost-free … while your Mana bar fills up". **MEASURED**, but it disagrees with DB2. "Almost no mana" is true either way.

**WAOE** (Healing Rain, then Chain Heal; Ascendance/Healing Tide; Spirit Link)
- enUS: `{SPELL:73920} heals everyone standing in it for a while, so drop it where the group stands, then {SPELL:1064} whoever is still low. {SPELL:98008} spreads health evenly over everyone near it and cuts the damage they take, so one almost-dead player is safe at once.`
- nl: `{SPELL:73920} healt iedereen die erin staat een tijdje lang, dus leg hem waar de groep staat, en daarna {SPELL:1064} op wie nog laag staat. {SPELL:98008} verdeelt de health eerlijk over iedereen in de buurt en verlaagt de schade die ze krijgen, dus iemand die bijna dood is, is meteen veilig.`
- Mechanic:
  - 73920: "restoring … health to up to $s4 allies over $d … only one Healing Rain active at a time". **MEASURED** (DB2).
  - 98008: "reduces damage taken by all party and raid members within … yards by $s1% … the health of all affected players is redistributed evenly". **MEASURED** (DB2).
  - For Totemic, Surging Totem replaces Healing Rain (444995 "Replaces Healing Rain"). HERO1 already says so. **MEASURED**.

## 3. TERMS: one word carries the card, Stormstream Totem (S1, HERO1, HERO2)
- enUS: `Stormstream Totem is a stronger {SPELL:5394}. {SPELL:61295} sometimes turns your next one into it, and {SPELL:378081} (Farseer: {SPELL:443454}) always gives you one. It heals more allies, heals some of them right away, and does not cost you a {SPELL:5394} charge.`
- nl: `Stormstream Totem is een sterkere {SPELL:5394}. {SPELL:61295} maakt je volgende soms zo'n totem, en {SPELL:378081} (Farseer: {SPELL:443454}) geeft je er altijd een. Hij healt meer bondgenoten, healt er een paar meteen, en kost je geen charge van {SPELL:5394}.`
- Sources:
  - DB2 1267016, 1267068, and 1267120 ("Casting Nature's/Ancestral Swiftness grants a use of Stormstream Totem and Stormstream Totem no longer consumes a charge of Healing Stream Totem"). **MEASURED**.
  - Wowhead 17 Aug says the same in other words. **MEASURED**.
  - No numbers on purpose. The 6% Riptide chance and the 60 s proc duration are from Wowhead only.

## 4. Quiz
| Step | Default answer | Fair? | Proposal |
|---|---|---|---|
| S1 | 5394 Healing Stream Totem | Yes (only spell) | keep |
| S2 | 61295 Riptide | Yes | keep |
| S3 | 1064 Chain Heal | Yes ("or ____ when several are hurt") | keep |
| S4 | 188196 Lightning Bolt | Yes | keep |
| AOE | 98008 Spirit Link Totem | Yes: one clear rule ("someone about to die") | keep. Optional: 73920, but for Totemic that button has become Surging Totem, so I would keep 98008. |

No overrides needed.

## 5. Card errors / outdated
- **Spell IDs:** all 15 resolve correctly in DB2 69933. **MEASURED**.
- **S4 "it costs no mana"** is in doubt.
  - DB2 SpellPower 188196: 0.2% of base mana, one row, no spec condition. **MEASURED**. Wowhead tooltip: "0.2% of base mana". **MEASURED**.
  - Icy Veins 10 Aug: "cost-free". **MEASURED**.
  - Also "it" is unclear after three spells. Suggest: `…then {SPELL:188196}: they cost almost no mana.`
- **AOE "Ascendance (or Healing Tide Totem, if you picked that)":**
  - The sources disagree on which one Totemic takes. Icy Veins 10 Aug: Healing Tide Totem is "meant to be used by Totemic players", Ascendance by Farseer. Wowhead 17 Aug, with Totemic selected, describes an Ascendance sequence that starts with Surging Totem.
  - The card stays neutral; **no change**. Just know it is not settled.
- S1, S2, S3, HERO1 and HERO2 are correct:
  - DB2 444995 (Surging Totem replaces Healing Rain) and 1267120 (Swiftness gives Stormstream). **MEASURED**.
  - 443454: "If you know Nature's Swiftness, it is replaced by Ancestral Swiftness and causes Ancestral Swiftness to call an Ancestor". **MEASURED**.
  - Totemic is "best choice" for raid and M+: Icy Veins 10 Aug. **MEASURED**.

---

# Arcane Mage (62)

## 1+2. Why lines

**W1** (S1: Arcane Surge + Touch of the Magi together; Touch every 45 s)
- enUS: `{SPELL:321507} saves up part of all your damage on the target and lets it explode at the end. {SPELL:365350} makes your spells hit harder for a while, so together the explosion gets huge; and {SPELL:321507} is ready exactly twice per {SPELL:365350}, so a late one makes your next big moment late too.`
- nl: `{SPELL:321507} spaart een deel van al je schade op het doelwit op en laat het aan het eind ontploffen. {SPELL:365350} laat je spells een tijdje harder raken, dus samen wordt die ontploffing enorm; en {SPELL:321507} is precies twee keer klaar per {SPELL:365350}, dus één te laat maakt je volgende grote moment ook te laat.`
- Mechanic:
  - 321507: "accumulating $s1% of the damage you deal to the target for $210824d, and then exploding". **MEASURED** (DB2). Icy Veins 15 Aug gives 20% and 12 s. **MEASURED**.
  - 365350: "For the next $365362d … spell damage is increased by $365362s1%". **MEASURED** (DB2). Icy Veins gives 35% and 15 s.
  - Cooldowns: Touch has a 45 s charge recovery (SpellCategory 2449). Surge is 90 s. **MEASURED** (DB2).
  - "A late one makes your next big moment late": Icy Veins 15 Aug ("exactly half the cooldown … delaying it will force you to delay your next Arcane Surge") and Method 13 Sep ("never delay the Miniburn"). **MEASURED**.

**W2** (S2: Clearcasting, so Arcane Missiles, free)
- enUS: `{SPELL:5143} only works when Clearcasting lights up, and then it costs no mana. Every wave of missiles adds an Arcane Salvo stack, and those make your next {SPELL:44425} hit harder.`
- nl: `{SPELL:5143} werkt alleen als Clearcasting oplicht, en dan kost hij geen mana. Elke golf missiles geeft een Arcane Salvo-stack, en die laten je volgende {SPELL:44425} harder raken.`
- Mechanic:
  - 5143: "Requires Clearcasting". **MEASURED** (DB2).
  - Clearcasting 263725 effect: −100% cost on Arcane Missiles. Without it, Arcane Missiles costs 15% mana. **MEASURED** (DB2).
  - 384452: "Each wave of Arcane Missiles increases the damage of Arcane Barrage by …". **MEASURED** (DB2). Method 13 Sep: "Each wave … grants 1 stack of Arcane Salvo". **MEASURED**.

**W3** (S3: Prismatic Bolt lit up in place of Arcane Blast)
- enUS: `{SPELL:1295924} comes from spending Arcane Salvo with {SPELL:44425}. It is one of your hardest hits, also hurts enemies around the target and gives you 4 Arcane Charges at once; a second one cannot stack on top, so do not let it wait.`
- nl: `{SPELL:1295924} krijg je door Arcane Salvo uit te geven met {SPELL:44425}. Het is een van je hardste klappen, raakt ook vijanden rond het doelwit en geeft je in één keer 4 Arcane Charges; een tweede kan er niet bovenop, dus laat hem niet wachten.`
- Mechanic:
  - 1295924: damage to the target and to nearby enemies. "Generates $s3 Arcane Charges", with effect 2 = 4 (power type 16). **MEASURED** (DB2). 4 is also the cap (36032 CumulativeAura = 4), so the number is the point.
  - It procs from Barrage, by chance per Salvo stack spent. Icy Veins 15 Aug, 12 Aug. **MEASURED**.
  - It does not stack: Wowhead 4 Sep ("it does not stack so you really want to spend it quickly"). **MEASURED**.

**W4** (S4: 4 charges + full Arcane Salvo, then Arcane Barrage)
- enUS: `{SPELL:44425} hits harder for each Arcane Charge and each Arcane Salvo stack, and then uses them all up. That is why you fill both first and spend them in one big hit.`
- nl: `{SPELL:44425} raakt harder voor elke Arcane Charge en elke Arcane Salvo-stack, en gebruikt ze daarna allemaal op. Daarom vul je eerst allebei en geef je ze uit in één grote klap.`
- Mechanic:
  - 44425: "For each Arcane Charge, deals …% additional damage … Consumes all Arcane Charges". **MEASURED** (DB2).
  - Salvo buff 1242974 raises Barrage damage per stack, and Barrage removes it (effect A408, trigger 44425). Arcane Soul is the exception: "casting Arcane Barrage does not consume Arcane Salvo". **MEASURED** (DB2).
  - I left out the extra bonus at full Salvo (Icy Veins: Intuition). It depends on one talent I could not confirm in every build.

**W5** (S5: Arcane Orb at 0 charges, otherwise Arcane Blast)
- enUS: `{SPELL:153626} gives an Arcane Charge when you cast it and one more for each enemy it flies through, so it refills you fast after {SPELL:44425}. {SPELL:30451} also gives charges and hits harder with every charge you hold.`
- nl: `{SPELL:153626} geeft een Arcane Charge als je hem cast en nog een voor elke vijand waar hij doorheen vliegt, dus hij vult je snel weer aan na {SPELL:44425}. {SPELL:30451} geeft ook charges en raakt harder met elke charge die je hebt.`
- Mechanic:
  - 153626: "Grants 1 Arcane Charge when cast and every time it deals damage". **MEASURED** (DB2).
  - 30451: "Each Arcane Charge increases damage by …% and mana cost by …% … Generates … Arcane Charge". **MEASURED** (DB2).

**WAOE** (Arcane Orb whenever ready; Arcane Pulse instead of Arcane Blast below 4 charges)
- enUS: `{SPELL:153626} flies through the whole pack and gives a charge for every enemy it hits. Arcane Pulse hits everything around your target and gives charges per enemy too, so in a group it refills you much faster than {SPELL:30451}.`
- nl: `{SPELL:153626} vliegt door de hele groep en geeft een charge voor elke vijand die hij raakt. Arcane Pulse raakt alles rond je doelwit en geeft ook charges per vijand, dus in een groep vult hij je veel sneller aan dan {SPELL:30451}.`
- Mechanic:
  - 1241462 (Arcane Pulse): "dealing … Arcane damage to all enemies within … yds … Generates … Arcane Charges for each enemy struck". **MEASURED** (DB2).
  - "Much faster than Arcane Blast in a group" is **INFERRED**.
  - See card error 1: Arcane Pulse may not be in the default build.

## 3. TERMS: two words carry the card, Arcane Charges and Arcane Salvo (one line for both)
- enUS: `Arcane Charges (you hold at most 4) make {SPELL:30451} and {SPELL:44425} hit harder, and make {SPELL:30451} cost more mana. Arcane Salvo stacks come mostly from each wave of {SPELL:5143} and make your next {SPELL:44425} stronger. {SPELL:44425} spends both, and you start over.`
- nl: `Arcane Charges (je houdt er hoogstens 4) laten {SPELL:30451} en {SPELL:44425} harder raken, en maken {SPELL:30451} duurder in mana. Arcane Salvo-stacks krijg je vooral van elke golf {SPELL:5143}, en ze maken je volgende {SPELL:44425} sterker. {SPELL:44425} geeft allebei uit, en je begint opnieuw.`
- Sources:
  - DB2 36032: cap 4. Its aura text: "Increases the damage of Arcane Blast, Arcane Missiles, Arcane Explosion, and Arcane Barrage … Increases the mana cost of Arcane Blast". **MEASURED**.
  - Salvo from each Missiles wave: DB2 384452, Method 13 Sep. **MEASURED**.
  - "Mostly", because Arcane Blast, Prismatic Bolt and Orb also give Salvo with Expanded Mind (Icy Veins 15 Aug). **MEASURED**.
  - I left the Salvo cap out: DB2 base is 20 (1242974), and the guides say 25 for Sunfury (no DB2 source found for the +5).

## 4. Quiz
| Step | Default answer | Fair? | Proposal |
|---|---|---|---|
| S1 | 321507 Touch of the Magi | **No, and broken**: S1 has `{SPELL:321507}` twice. `GetPlayCardQuiz` blanks only the first (`gsub(..., 1)`), so **the answer stays visible** in "one more Touch of the Magi every 45 seconds". | `quizAnswer[1] = 365350` (Arcane Surge, appears once) |
| S2 | 5143 Arcane Missiles | Yes | keep |
| S3 | 30451 Arcane Blast | No. The point is Prismatic Bolt. | `quizAnswer[3] = 1295924` |
| S4 | 44425 Arcane Barrage | Yes | keep |
| S5 | 30451 Arcane Blast | Yes ("Otherwise fill with ____") | keep (153626 also fine) |
| AOE | 30451 Arcane Blast | No. The point is Arcane Orb whenever ready (Arcane Pulse is plain text and cannot be asked). | `quizAnswer.AOE = 153626` |

So: `quizAnswer = { [1] = 365350, [3] = 1295924, AOE = 153626 }`.

## 5. Card errors / outdated
1. **AOE names Arcane Pulse.**
   - Wowhead 4 Sep: "Arcane Pulse is only mentioned for info, it is not part of any default talent builds this season." **MEASURED**.
   - Icy Veins 15 Aug lists it as an optional talent toggle. The APL uses it only `if talented`.
   - Suggest: `…Arcane Pulse (if you have it) instead of {SPELL:30451}`, or drop that half.
2. **S5 "At 0 Arcane Charges":** Icy Veins 15 Aug and Wowhead 4 Sep both say "no Arcane Charges". The APL (6 Sep) Sunfury uses `arcane_orb,if=buff.arcane_charge.stack<3`. Method 13 Sep gives no condition. **MEASURED**. Two guides match the card; keep.
3. **S2 refinement (optional):** all four sources say that for Sunfury, Missiles only below 12 Salvo. From 12 Salvo with Clearcasting you Barrage instead:
   - Method 13 Sep, Wowhead 4 Sep, Icy Veins 15 Aug.
   - APL: `arcane_missiles,if=buff.clearcasting.react&buff.arcane_salvo.stack<12`.
   - The card says "always". Fine for beginners; mentioned in case Rob wants it.
4. S1 (45 s, together), S4 (25), HERO1 (Arcane Soul after Surge; DB2 451038) and HERO2 (20 for Spellslinger) are correct. **MEASURED**.
5. Spell IDs: all 7 correct; 1295924 = Prismatic Bolt. **MEASURED**.

---

# Fire Mage (63)

## 1+2. Why lines

**W1** (S1: Combustion with Meteor every minute; chain Fire Blast + Pyroblast)
- enUS: `{SPELL:190319} makes every spell crit for a short time, so every hit builds Hot Streak and you can throw {SPELL:11366} after {SPELL:11366}. {SPELL:153561} lands a moment after you cast it, so make sure it lands while {SPELL:190319} is still on.`
- nl: `{SPELL:190319} laat elke spell een korte tijd critten, dus elke klap bouwt Hot Streak op en je kunt {SPELL:11366} na {SPELL:11366} gooien. {SPELL:153561} landt pas even na je cast, dus zorg dat hij landt terwijl {SPELL:190319} nog aan staat.`
- Mechanic:
  - 190319: +100% crit chance (effect 0, bp 100) for 10 s, "Castable while casting other spells". **MEASURED** (DB2). Sunfury's window is longer (Wowhead 16 Aug).
  - 153561: "lands at the target location after $177345d". **MEASURED** (DB2).
  - "Ensure it lands before Combustion ends": Icy Veins 10 Aug. **MEASURED**.
  - Every minute: Kindling (1254194) cuts the cooldown by 60 s, from 120 s base. **MEASURED** (DB2). Method 17 Aug: "static 1 minute cooldown". **MEASURED**.

**W2** (S2: Heating Up, so Fire Blast)
- enUS: `Heating Up means one crit; a second crit in a row turns it into Hot Streak. {SPELL:108853} always crits and you can cast it while casting something else, so it makes the second crit without costing you time.`
- nl: `Heating Up betekent één crit; een tweede crit op rij maakt er Hot Streak van. {SPELL:108853} crit altijd en je kunt hem casten terwijl je iets anders cast, dus hij levert die tweede crit zonder dat het je tijd kost.`
- Mechanic:
  - 48107: "Scored a spell critical. A second spell critical in a row will make your next Pyroblast or Flamestrike spell instant cast". **MEASURED** (DB2).
  - 108853: "Blasts the enemy, critically striking for … Castable while casting other spells." **MEASURED** (DB2).

**W3** (S3: Hot Streak, so Pyroblast, right as Fireball finishes)
- enUS: `Hot Streak makes your next {SPELL:11366} instant. Throw it just as {SPELL:133} finishes so both land together: if both crit you get a new Hot Streak, and if only one crits you still keep Heating Up.`
- nl: `Hot Streak maakt je volgende {SPELL:11366} instant. Gooi hem net als {SPELL:133} klaar is, zodat ze samen landen: critten ze allebei, dan krijg je een nieuwe Hot Streak, en crit er maar één, dan houd je toch Heating Up.`
- Mechanic:
  - 48108: −100% cast time on Pyroblast/Flamestrike. **MEASURED** (DB2).
  - "Pyroblast chaining": Icy Veins 10 Aug says both land at once; both crit gives an immediate new Hot Streak. A 0.2 s grace window means "if only one of them crits, you keep your Heating Up". **MEASURED**. Method 17 Aug and Wowhead 16 Aug teach the same pairing. **MEASURED**.

**W4** (S4: Pyroclasm, so a hard-cast Pyroblast)
- enUS: `Spending Hot Streak sometimes gives Pyroclasm: your next {SPELL:11366} with a cast time does a lot more damage. With this season's tier set it also always crits, so it is worth the slow cast.`
- nl: `Hot Streak uitgeven geeft soms Pyroclasm: je volgende {SPELL:11366} met cast-tijd doet dan veel meer schade. Met de tier set van dit seizoen crit hij ook altijd, dus die trage cast is het waard.`
- Mechanic:
  - 269650/269651: "Consuming Hot Streak has a $s1% chance to make your next non-instant Pyroblast or Flamestrike … deal …% additional damage". Up to 2 stacks. **MEASURED** (DB2; s1 = 15, bonus 230%, numbers left out on purpose).
  - S2 2-piece: "Pyroclasm causes Pyroblast and Flamestrike to always critically strike". **MEASURED** (Icy Veins 10 Aug, Wowhead 16 Aug).

**W5** (S5: Fireball; Scorch on the move)
- enUS: `{SPELL:133} is your filler: every crit it lands builds toward Hot Streak. {SPELL:2948} can be cast while you move, and on an enemy with low health it always crits.`
- nl: `{SPELL:133} is je opvuller: elke crit ervan bouwt Hot Streak op. {SPELL:2948} kun je casten terwijl je loopt, en op een vijand met weinig health crit hij altijd.`
- Mechanic:
  - 2948: "When cast on a target below $s2% health, Scorch is a guaranteed critical strike. Castable while moving." **MEASURED** (DB2). The 30% is from Icy Veins/Wowhead.
  - Hot Streak passive 195283: "two direct-damage critical strikes in a row with Fire spells". **MEASURED** (DB2).

**WAOE** (4+ enemies: Flamestrike instead of Pyroblast with Hot Streak)
- enUS: `Hot Streak makes {SPELL:2120} instant too, and it burns every enemy in the circle. With Fuel the Fire it hits harder for every enemy it hits, so in a group it beats {SPELL:11366}.`
- nl: `Hot Streak maakt {SPELL:2120} ook instant, en hij verbrandt elke vijand in de cirkel. Met Fuel the Fire raakt hij harder voor elke vijand die hij raakt, dus in een groep wint hij van {SPELL:11366}.`
- Mechanic:
  - 48108 covers Flamestrike. 2120: "burning all enemies within the area". **MEASURED** (DB2).
  - 416094 Fuel the Fire: "Flamestrike deals $s2% increased damage for each enemy it damages". **MEASURED** (DB2).
  - "Always be specced into Fuel the Fire": Icy Veins 10 Aug. The APL turns Flamestrike off without it. **MEASURED**.
  - I kept the target count out of the why line on purpose (see the disagreement below).

## 3. TERMS: the words that carry the card are Heating Up / Hot Streak
- enUS: `Heating Up means you just scored one crit. Score a second crit in a row and it turns into Hot Streak: your next {SPELL:11366} or {SPELL:2120} is instant. A hit that does not crit in between, and Heating Up is gone again.`
- nl: `Heating Up betekent: je hebt net één crit gescoord. Crit je meteen nog een keer, dan wordt het Hot Streak: je volgende {SPELL:11366} of {SPELL:2120} is instant. Zit er een klap zonder crit tussen, dan ben je Heating Up weer kwijt.`
- Sources:
  - DB2 48107, 48108, 195283. **MEASURED**.
  - Heating Up is lost on a non-crit: Icy Veins 10 Aug ("normally, if only one of them crits … you will lose the Heating Up"). **MEASURED**.

## 4. Quiz
| Step | Default answer | Fair? | Proposal |
|---|---|---|---|
| S1 | 11366 Pyroblast | No. The point is Combustion. | `quizAnswer[1] = 190319` |
| S2 | 108853 Fire Blast | Yes | keep |
| S3 | 133 Fireball | No. The point is Pyroblast on Hot Streak. | `quizAnswer[3] = 11366` |
| S4 | 11366 Pyroblast | Yes | keep |
| S5 | 2948 Scorch | Yes ("On the move: ____") | keep |
| AOE | 11366 Pyroblast | No. The point is Flamestrike. | `quizAnswer.AOE = 2120` |

So: `quizAnswer = { [1] = 190319, [3] = 11366, AOE = 2120 }`. Each override spell appears once in its step.

## 5. Card errors / outdated
1. **IDEA "a free, instant Pyroblast":** Hot Streak (48108) only has a −100% cast-time modifier, and Pyroblast costs 1.5% of base mana. **MEASURED** (DB2). Suggest "an instant Pyroblast".
2. **HERO1 "free and instant":** Hyperthermia (383874) is −100% cast time and +100% crit, 5 s. There is no cost modifier in DB2. **MEASURED**. Wowhead 16 Aug calls these casts "free". Suggest: `…{SPELL:11366} is instant and always crits for a short while`. That is true in both sources.
3. **AOE "4 or more enemies" is disputed. Keep 4, but know the sources disagree:**
   - APL (12 Aug): 3+ (`ff_filler_flamestrike = 3` with Fuel the Fire).
   - Wowhead 16 Aug: Sunfury 3+ "if you just want the max damage", 4+ "as a compromise" with priority damage. Frostfire 4+.
   - Icy Veins 10 Aug: 4+ for both.
   - Method 17 Aug: "5 or more" twice, and "4 Targets or more" in its own combo text.
   - Both guides also say no Flamestrike above 90% HP with Firestarter.
4. S1 (every minute, with Kindling) and MISTAKE are correct. Method 17 Aug: "Ideally … 3, but 2 is also okay" Fire Blast charges into Combustion, "NEVER overcap". **MEASURED**.
5. Spell IDs: all 8 correct. **MEASURED**.

---

# 6. Patch 12.1.5 (PTR build 12.1.5.70077 + EU thread 627464)

**DB2 comparison, MEASURED.** I compared 71 spell IDs between 12.1.0.69933 and 12.1.5.70077:
- Fields compared: description, aura text, all SpellEffect rows, cooldown, charges, stack cap, mana cost.
- The IDs: every card spell for the four specs, plus Hot Streak, Heating Up, Pyroclasm, Kindling, Firestarter, Fuel the Fire, Arcane Charge, Clearcasting, Arcane Salvo, Arcane Soul, Arcane Pulse, Maelstrom Weapon (all IDs), Overflowing/Raging Maelstrom, Thorim's Invocation, Elemental Tempo, Hot Hand, Primordial Storm, Stormstream Totem, Tidal Waves.
- **69 are identical.** Only Nature's Swiftness (378081) and Ancestral Swiftness (443454) changed: the class masks of their instant/no-cost effects.
- This doubles as the positive check that the comparison can see a change at all. It matches this PTR note from 29 Sep: "Fixed an issue where Nature's Swiftness and Ancestral Swiftness did not properly make Healing Rain instant cast."

**PTR notes (posts 3, 15, 22, 29 Sep; no later posts):**
- Enhancement (29 Sep): fixed Static Accumulation sometimes stopping Maelstrom Weapon generation during Ascendance/Doom Winds. A bug fix; no text changes.
- Restoration (29 Sep):
  - Riptide extended by Swelling Tides now extends instead of resetting.
  - The Swiftness / Healing Rain fix above.
  - Neither touches a W, TERMS or card line. None of my lines claims Swiftness makes Healing Rain instant.
- Arcane (15 Sep): "Several Arcane spells have been added to the Spell Density system". Visual only.
- Fire: nothing.

**Conclusion:** nothing in 12.1.5 changes a W line, a TERMS line or a card line for these four specs. With `why = { checked, interface = 120100 }` the lines hide on a 120105 client. On this data they could be re-stamped for 120105 after one live check. Rob's call; not done here.

---

# Disagreements between the two routes, in one place
| Topic | Guides | Ground truth | Card |
|---|---|---|---|
| Fire: Flamestrike from how many targets | Icy Veins 4+, Wowhead 3+ (max) / 4+ (compromise), Method 5+ and 4+ | APL 12 Aug: 3+ | 4, keep |
| Arcane: Orb condition | Icy Veins, Wowhead: 0 charges; Method: none | APL 6 Sep: <3 charges | 0, keep |
| Arcane: Arcane Pulse in the build | Wowhead 4 Sep: not in default builds; Icy Veins: optional | APL: only if talented | mentioned, add "if you have it" |
| Resto: Lightning Bolt mana | Icy Veins: cost-free | DB2 + Wowhead tooltip: 0.2% base mana | "no mana", change to "almost no mana" |
| Resto: Totemic cooldown | Icy Veins: Healing Tide; Wowhead: Ascendance (Totemic section) | (no APL) | neutral, keep |
| Enh: Totemic order | Method: Doom Winds 2nd; Icy Veins: Doom Winds last | APL = Icy Veins | Icy Veins/APL, keep |
| Enh: Surging Totem cooldown | Method, Icy Veins: 1 min | DB2 444995: 25 s (60 s not found) | "every minute", keep, unconfirmed in DB2 |
| Fire: Hyperthermia / Hot Streak "free" | Wowhead: free | DB2: cast time + crit only, no cost effect | "free", change to "instant" |

Scratch files used: `C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\b858ebb6-31f0-46dc-b5df-bd5769253a2b\scratchpad\why\sm\` (APLs, APL history, thread JSON/text).
