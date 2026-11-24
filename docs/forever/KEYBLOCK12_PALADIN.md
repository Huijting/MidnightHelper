# KEYBLOCK12 — PALADIN (voorstel, 24 nov 2026, mh-research)

De opdracht kwam als tekst van de coördinator. Niets in `docs/` gelezen. Bronnen: alleen `Modules/` (geen `_probe.py`,
geen web). GEMETEN = staat letterlijk in het genoemde bestand en de genoemde regel. AFGELEID = mijn redenering.

## Wat is anders dan het oude blok (`Modules/ForeverBlock_Paladin.lua`)

- De Paladin heeft geen states (kopregel 9 van het oude bestand). Elke toets doet dus één ding. Het oude blok had 33
  spell-toetsen, het rooster heeft er 31. Twee gaan er dus uit:
  - **Hammer of the Righteous**: dat die spell in Forever te krijgen is, is niet aangetoond (zie twijfel 1).
  - **Oath of Light**: maar één keer per 5 minuten nodig (zie twijfel 2).
- De drie blessing-paren (Might, Kings, Wisdom) gaan van Shift-Z, Shift-X en Shift-V naar Ctrl-Q, Ctrl-E en Ctrl-4. Een
  blessing duurt 60 minuten, dus je drukt hem zelden.
- Divine Intervention/Redemption gaat van F3 naar Ctrl-R. Verder verhuizen:
  - Flash of Light (F2) naar Shift-C.
  - Holy Shock (F4) naar Shift-R.
  - Light's Vigil (Shift-F1) naar Shift-Q.
  - Swift Judgement (F1) naar Shift-2.
  - Exorcism (5) naar Shift-4.
  - Holy Shield (Shift-4) naar Shift-Z.
  - Blessing of Protection (Shift-F) naar Shift-X.
  - Turn Undead (Shift-Q) naar Shift-F.
  - Cleanse/Purify (Shift-C) naar Shift-V.
- Wat gelijk blijft: 1 t/m 4, Q, E, R, F, Z, X, C, V, Shift-1, Shift-3, Shift-E en Ctrl-1 t/m 3.

## Tabel

| Toets | Spell(s) | Waarom | Bron |
|---|---|---|---|
| 1 | Holy Strike | Hoofdknop: "every time it is ready". | GEMETEN: oud blok regel 22, ForeverHowToPlay.lua:1038 |
| 2 | Judgement | Rotatie. Hij laat je seal staan. | GEMETEN: oud blok regel 23, HowToPlay:122, 1037 |
| 3 | Seal of Command / Seal of Righteousness | Rotatie: je seal. Command wint zodra je hem kent. | GEMETEN: oud blok regel 24, HowToPlay:115 |
| 4 | Hammer of Wrath | Execute: alleen bij 20% of minder. | GEMETEN: oud blok regel 25, HowToPlay:137 |
| Q | Lay on Hands | Grote cooldown en noodknop op balk A (regel 2). | GEMETEN: oud blok regel 30, HowToPlay:128 |
| E | Hammer of Justice | De Paladin heeft geen interrupt. Deze stun is zijn "stop that spell"-knop. | GEMETEN: oud blok regel 35, HowToPlay:126 |
| R | Blessing of Freedom | Beweging: "nothing can slow you for a while". | GEMETEN: oud blok regel 36, HowToPlay:135 |
| F | Seal of Fury | Taunt: "Its Judgement taunts". | GEMETEN: oud blok regel 38, HowToPlay:130 |
| Z | Divine Shield / Divine Protection | Eén toets, want ze delen een cooldown. Divine Protection (6) is de eerste, kleine defensive. Divine Shield (34) neemt hem over. Zo staat er ook een noodknop op A. | GEMETEN: oud blok regel 39, HowToPlay:142 |
| X | Templar's Bulwark | Tweede defensive (absorb voor 8 s). | GEMETEN: oud blok regel 40, HowToPlay:1022 |
| C | Holy Light | C = grote defensive. Voor een hybride is dat de grote heal (zie twijfel 3). Druid en Shaman krijgen hetzelfde patroon: C = grote heal, Shift-C = snelle heal. | GEMETEN: oud blok regel 41. Keuze = AFGELEID |
| V | Repentance | Crowd control: één Humanoid uitschakelen. | GEMETEN: oud blok regel 44, HowToPlay:1048 |
| Shift-1 | Consecration | AoE: "Two or more enemies". | GEMETEN: oud blok regel 28, HowToPlay:1040 |
| Shift-2 | **Swift Judgement** | De tweede van 2: "a second Judgement with its own 1-minute cooldown". | GEMETEN: oud F1 (regel 31), HowToPlay:1015 |
| Shift-3 | Divine Favor | Cooldown: de volgende heal is een zekere crit. | GEMETEN: oud blok regel 32, HowToPlay:998 |
| Shift-4 | **Exorcism** | Tweede "speciale" aanval naast Hammer of Wrath: alleen tegen Undead en Demons. | GEMETEN: oud 5 (regel 26), HowToPlay:140. Plek = AFGELEID |
| Shift-Q | **Light's Vigil** | Tweede cooldown. Daarna Holy Shock op dezelfde speler. | GEMETEN: oud Shift-F1 (regel 33), HowToPlay:991, 1005 |
| Shift-E | `all` Stoneform / Will to Survive / Will of the Forsaken | Race-spell. | GEMETEN: oud blok regel 51 |
| Shift-R | **Holy Shock** | Tweede beweging: de heal of hit die je doet "while you move". Een Paladin heeft geen tweede beweging. | GEMETEN: oud F4 (regel 43), HowToPlay:990. Plek = AFGELEID |
| Shift-F | **Turn Undead** | Tweede crowd control (alleen Undead). | GEMETEN: oud Shift-Q (regel 45), HowToPlay:140 |
| Shift-Z | **Holy Shield** | Tweede kleine defensive. De tank drukt hem "every time it is ready". | GEMETEN: oud Shift-4 (regel 27), HowToPlay:1011 |
| Shift-X | **Blessing of Protection** | Defensive voor een vriend in nood. | GEMETEN: oud Shift-F (regel 46), HowToPlay:129 |
| Shift-C | **Flash of Light** | De snelle heal, "your normal heal" voor Holy, als tweede van C. Beter bereikbaar dan de oude F2. | GEMETEN: oud F2 (regel 42), HowToPlay:988. Keuze = AFGELEID |
| Shift-V | **Cleanse / Purify** | Een Paladin heeft geen derde crowd control. Een bad effect weghalen past hier het best, onder de andere hulpknoppen. | GEMETEN: oud Shift-C (regel 50), HowToPlay:993. Plek = AFGELEID |
| Ctrl-1 | Devotion Aura | Aura 1 (stance-achtig: aanzetten en aan laten). | GEMETEN: oud blok regel 52, HowToPlay:117 |
| Ctrl-2 | Retribution Aura | Aura 2. | GEMETEN: oud blok regel 53 |
| Ctrl-3 | Concentration Aura | Aura 3. | GEMETEN: oud blok regel 54 |
| Ctrl-4 | `pair` [group] Greater Blessing of Wisdom, anders Blessing of Wisdom | Er is geen vierde aura (de resistance-aura's staan in toBlockD). Een blessing duurt 60 minuten, dus de Ctrl-balk is genoeg. | GEMETEN: oud Shift-V (regel 49), HowToPlay:110. Plek = AFGELEID |
| Ctrl-Q | `pair` [group] Greater Blessing of Might, anders Blessing of Might | Buff. | GEMETEN: oud Shift-Z (regel 47) |
| Ctrl-E | `pair` [group] Greater Blessing of Kings, anders Blessing of Kings | Buff. Er is geen cooldown meer over voor deze plek. | GEMETEN: oud Shift-X (regel 48) |
| Ctrl-R | `pair` [combat] Divine Intervention, anders Redemption | Herstel buiten gevecht: Redemption. | GEMETEN: oud F3 (regel 34), HowToPlay:136 |

Alle 40 namen staan letterlijk als sleutel in `Modules/ForeverSpellIds.lua`. GEMETEN: één Grep met alle 40 namen,
exact geankerd, gaf 40 treffers.

## Twijfels

1. **Hammer of the Righteous is weggelaten.** GEMETEN, met positieve controle in dezelfde zoekactie:
   - De naam staat in ForeverSpellIds.lua:221 (id 407632), in het oude blok en in ForeverMacros.lua:668. Daar is het
     een forummacro ("cwf") met level 40 en `talent = false`.
   - De naam staat niet in ForeverTrainerData.lua, niet in de Protection-talentvolgorde (ForeverTalentNext.lua:82-103)
     en in geen enkele tekst in ForeverHowToPlay.lua.

   Dat hij niet te krijgen is, bewijst dat niet. Advies: meten (DB2 TraitDefinition/SkillLineAbility, of Rob in het
   spel). Blijkt hij echt te bestaan, dan past hij op Shift-2 als AoE. Swift Judgement gaat dan naar Ctrl-4 of blok D.
2. **Oath of Light is weggelaten.** Het is stap 1 van de Holy-volgorde, maar hij duurt 5 minuten en maar één speler
   kan hem hebben (HowToPlay:987). Je drukt hem dus net zo zelden als een blessing. Ik schrijf `toBlockD` niet
   opnieuw. De bouwer moet hem daar of in `listed` zetten, anders noemt de rode regel hem "not in MH's list".
   Alternatief: Oath of Light op Shift-F en Turn Undead naar blok D.
3. **C = Holy Light, niet Divine Shield.** De regel zegt: C = grote defensive of stun. Ik koos hetzelfde patroon als
   bij de Druid en de Shaman (C = grote heal, Shift-C = snelle heal). Wie meerdere healers speelt, vindt zo de heals op
   dezelfde plek. Divine Shield staat als noodknop op Z, op balk A.
   - Alternatief (healer-vriendelijker): Z = Flash of Light, C = Divine Shield, Shift-C = Holy Light. Dan staat de
     snelle heal op balk A. Dat is Robs keuze.
4. **Z heet "kleine defensive"**, maar Divine Shield is de grootste. Hij staat daar omdat Divine Protection (level 6)
   en Divine Shield (34) samen één toets zijn.
5. **Ctrl-R in een gevecht = Divine Intervention, en dan ga je zelf dood** (HowToPlay:136, 1006). Op F3 bestond
   hetzelfde risico. Ctrl-R is wat lastiger per ongeluk te raken. Dat is AFGELEID.
6. **De blessings op Ctrl-4, Ctrl-Q en Ctrl-E** passen niet bij "vorm 4" en "cooldown". De reden is de lange duur
   (60 minuten, HowToPlay:110). In een groep verander je ze wel vaker. Dat is AFGELEID.
7. **Downranks** (regel 4, alleen advies; de motor kan het nu niet): een lage rank van Holy Light als goedkope heal was
   vroeger gebruikelijk. Daar is nu geen plek voor.
8. **ForeverHowToPlay.lua noemt de oude toetsen** (5, F1, F2, F3, F4, Shift-F1, Shift-Z/X/V voor blessings,
   Shift-4 = Holy Shield, Shift-Q = Turn Undead, Shift-R = Oath of Light; regels 108-142 en 983-1055). Die teksten
   moeten mee als keys12 live gaat.
9. **Motor en `why`**: zie Druid, twijfel 9. `ForeverBlockUnlisted` telt het `why`-veld als naam. Onschuldig, wel
   netter om over te slaan.

## keys12

```lua
	keys12 = {
		["1"] = { base = "Holy Strike", why = "main hit: press it whenever it is ready" },
		["2"] = { base = "Judgement", why = "rotation: Judgement whenever ready; it keeps your seal" },
		["3"] = { base = { "Seal of Command", "Seal of Righteousness" }, why = "your seal: Command once you have it, else Righteousness" },
		["4"] = { base = "Hammer of Wrath", why = "execute: only at 20% health or less" },
		["Q"] = { base = "Lay on Hands", why = "big cooldown and emergency: full heal, all your mana" },
		["E"] = { base = "Hammer of Justice", why = "no interrupt: this stun stops a cast" },
		["R"] = { base = "Blessing of Freedom", why = "movement: nothing can slow you for a while" },
		["F"] = { base = "Seal of Fury", why = "tank seal: with it on, Judgement taunts" },
		["Z"] = { base = { "Divine Shield", "Divine Protection" }, why = "your shield: one key, they share a cooldown" },
		["X"] = { base = "Templar's Bulwark", why = "second defensive: absorbs damage for 8 seconds" },
		["C"] = { base = "Holy Light", why = "big heal: your big defensive when you are alone" },
		["V"] = { base = "Repentance", why = "crowd control: takes one Humanoid out" },
		["SHIFT-1"] = { base = "Consecration", why = "AoE: two or more enemies" },
		["SHIFT-2"] = { base = "Swift Judgement", why = "a second Judgement with its own cooldown" },
		["SHIFT-3"] = { base = "Divine Favor", why = "cooldown: your next heal is a sure crit" },
		["SHIFT-4"] = { base = "Exorcism", why = "second special hit: Undead and Demons only" },
		["SHIFT-Q"] = { base = "Light's Vigil", why = "second cooldown: then Holy Shock on that same friend" },
		["SHIFT-E"] = { all = { "Stoneform", "Will to Survive", "Will of the Forsaken" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Holy Shock", why = "instant heal or hit, also while you move" },
		["SHIFT-F"] = { base = "Turn Undead", why = "second crowd control: Undead only" },
		["SHIFT-Z"] = { base = "Holy Shield", why = "second small defensive: tank block, press when ready" },
		["SHIFT-X"] = { base = "Blessing of Protection", why = "defensive: saves a friend in trouble" },
		["SHIFT-C"] = { base = "Flash of Light", why = "quick heal, next to Holy Light on C" },
		["SHIFT-V"] = { base = { "Cleanse", "Purify" }, why = "remove a bad effect from a friend" },
		["CTRL-1"] = { base = "Devotion Aura", why = "aura 1: more armor; switch on and leave on" },
		["CTRL-2"] = { base = "Retribution Aura", why = "aura 2: holy damage to what hits your group" },
		["CTRL-3"] = { base = "Concentration Aura", why = "aura 3: casters get interrupted less" },
		["CTRL-4"] = { pair = { cond = "[group]", first = "Greater Blessing of Wisdom", second = "Blessing of Wisdom" }, why = "Blessing of Wisdom (60 min), the Greater one in a group" },
		["CTRL-Q"] = { pair = { cond = "[group]", first = "Greater Blessing of Might", second = "Blessing of Might" }, why = "Blessing of Might (60 min), the Greater one in a group" },
		["CTRL-E"] = { pair = { cond = "[group]", first = "Greater Blessing of Kings", second = "Blessing of Kings" }, why = "Blessing of Kings (60 min), the Greater one in a group" },
		["CTRL-R"] = { pair = { cond = "[combat]", first = "Divine Intervention", second = "Redemption" }, why = "Redemption brings a friend back; in a fight Divine Intervention" },
	},
```
