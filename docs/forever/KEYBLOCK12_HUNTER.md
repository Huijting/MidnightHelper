# Toetsblok 12 x 4 — Hunter (WoW Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen in `Modules/` (geen `docs/`, geen gamedata: deze opdracht
verbood `_probe.py`). Bronnen:
- `Modules/ForeverBlock_Hunter.lua` = **oud blok** (GEMETEN: de huidige `keys`, met `base`, `bang` en `cmd`).
- `Modules/ForeverHowToPlay.lua` = de uitleg en de drie rollen (GEMETEN, regels 170-197 en 764-835).
- `Modules/ForeverSpellIds.lua` = elke spellnaam hieronder staat daar letterlijk als sleutel (GEMETEN met één Grep, alle
  namen gevonden).
- `Modules/KeyBlock.lua` regels 65-97 = het 12 x 4-rooster (GEMETEN).
- `Modules/ForeverBlock.lua` = hoe de motor een regel leest (GEMETEN): een lijst = de eerste spell die de speler kent.

De Hunter heeft geen states (oud blok: `states = {}`), dus elke regel gebruikt `base`, zoals het oude blok.

## Wat er verandert ten opzichte van het oude blok

- De toetsen 5, F1, F2, F3, F4 en Shift-F1 bestaan niet meer. Raptor Strike (5) naar **Shift-X**, Summon Hawk
  (Shift-F1) naar **Shift-3**, Mend Pet (F2) naar **F**, Call Pet (F4) naar **Ctrl-4**, Revive Pet (F3) naar **Ctrl-R**.
- Het oude blok vulde 33 toetsen, het nieuwe heeft 31 plekken. Daarom twee gedeelde toetsen, telkens twee talents uit
  verschillende trees: **E** = Scatter Shot of Intimidation, **Shift-4** = Sniper Shot of Bestial Wrath.
- Trueshot Aura van Shift-X naar **Ctrl-Q** (buff). Distracting Shot van F naar **Ctrl-E**.

## Tabel

| Toets | Spell | Waarom | Bron |
|---|---|---|---|
| 1 | Auto Shot (met `!`) | Hoofdknop. Nog eens drukken stopt het schieten niet. | oud blok |
| 2 | Serpent Sting | Rotatie: als eerste op het doel. | oud blok |
| 3 | Arcane Shot | Rotatie: instant. | oud blok |
| 4 | Aimed Shot | Spender: je grote schot (stilstaan). | oud blok |
| Q | Rapid Fire | Grote cooldown. | oud blok |
| E | Scatter Shot / Intimidation | Interrupt-plek. De Hunter heeft geen echte interrupt. Scatter Shot (Marksmanship) of de stun van je pet (Beast Mastery) stopt een cast. Intimidation was Shift-3. | Scatter Shot: oud blok. Lijst: AFGELEID |
| R | Aspect of the Cheetah | Beweging. | oud blok |
| F | Mend Pet | Hulpspell: heelt je pet. Elke Hunter met pet drukt hem; taunten doe je zelden. Was F2. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Z | Disengage | Kleine defensive: minder threat van dichtbij (geen sprong in Forever). | oud blok; bron: ForeverHowToPlay.lua |
| X | Feign Death | Tweede defensive. | oud blok |
| C | Deterrence | Grote defensive (Survival-talent). De stun van je pet (Intimidation) staat al op E. Dus C = grote defensive. | oud blok |
| V | Freezing Trap | Crowd control. | oud blok |
| Shift-1 | Multi-Shot | AoE. | oud blok |
| Shift-2 | Explosive Trap / Immolation Trap | AoE-trap; vóór 34 Immolation Trap. | oud blok |
| Shift-3 | Summon Hawk | Tweede van 3: deelt een cooldown met Arcane Shot (op 3). Was Shift-F1. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Shift-4 | Sniper Shot / Bestial Wrath | Tweede van 4 (Sniper Shot, lange cast zoals Aimed Shot) of, voor Beast Mastery, Bestial Wrath. Bestial Wrath was F1. | Sniper Shot: oud blok. Lijst: AFGELEID |
| Shift-Q | Concussive Shot | Slow. Plek uit het oude blok. | oud blok |
| Shift-E | je race-spell | Zelfde lijst als het oude blok. | oud blok |
| Shift-R | Aspect of the Hawk | Je hoofd-aspect. Geen tweede beweging bij de Hunter. | oud blok |
| Shift-F | Wing Clip | Crowd control 2: melee-slow. | oud blok |
| Shift-Z | Hunter's Mark | Eén keer per vijand. | oud blok |
| Shift-X | Raptor Strike | Je melee-klap. Was 5. Melee bij elkaar: Shift-F, Shift-X, Shift-C, Shift-V. | plek AFGELEID |
| Shift-C | Mongoose Bite | Melee, na een dodge. | oud blok |
| Shift-V | Counterattack | Crowd control 3: na een parry, houdt de vijand vast. | oud blok |
| Ctrl-1 | /petattack | Pet: aanvallen (vanaf Call Pet). | oud blok |
| Ctrl-2 | /petfollow | Pet: volgen. | oud blok |
| Ctrl-3 | /petstay | Pet: blijven. | oud blok |
| Ctrl-4 | Call Pet | Naast de drie pet-toetsen. Was F4. | plek AFGELEID |
| Ctrl-Q | Trueshot Aura | Buff voor je groep (30 minuten). Was Shift-X. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Ctrl-E | Distracting Shot | Taunt, zelden nodig. Was F. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Ctrl-R | Revive Pet | Herstel: je dode pet terug. Was F3. | plek AFGELEID |

Ctrl-F, Ctrl-Z, Ctrl-X, Ctrl-C en Ctrl-V zijn vaste items: daar staat niets.

## Twijfels en wat ik niet kon meten

1. **Shift-4 = Sniper Shot of Bestial Wrath.** Bestial Wrath vraagt 30 punten in Beast Mastery (GEMETEN,
   `ForeverHowToPlay.lua` regel 782). Sniper Shot is een talent van 40 dat Trueshot Aura vraagt (regel 806). Er zijn
   nooit meer dan 51 punten (regel 63). Dat Sniper Shot ook 30 punten in Marksmanship vraagt, en dat niemand dus beide
   heeft, is AFGELEID (talent van 40 = rij 7), niet gemeten. Nadeel: Bestial Wrath staat niet naast Rapid Fire (Q),
   terwijl Beast Mastery die twee samen drukt.
2. **E = Scatter Shot of Intimidation sluit elkaar NIET zeker uit.** Beide zijn talents van 30, in verschillende trees.
   Een Marksmanship-speler die na 40 punten in Beast Mastery zet (zo zeggen de gidsen in `ForeverHowToPlay.lua` regel
   807), kan beide hebben. Dan wint Scatter Shot en heeft Intimidation geen toets. Dat een stun of verwarring een cast
   stopt is AFGELEID (gewone WoW-regel), niet gemeten in Forever.
3. **Geen echte interrupt.** In `ForeverSpellIds.lua` staan geen Silencing Shot, Wyvern Sting, Readiness of Kill
   Command (GEMETEN, met Intimidation, Spearing Strike en Taunt als positieve controle in dezelfde Grep). Dat bewijst
   alleen dat ze niet in MH's lijst staan.
4. **Mend Pet op F, Distracting Shot naar Ctrl-E.** Afwijking van het oude blok (daar was F de taunt). Reden: regel 1,
   Mend Pet druk je veel vaker. Wil Rob F als taunt houden, wissel die twee dan terug.
5. **Strider Kick en Aspect of the Beast** (Survival, volgens `ForeverHowToPlay.lua` elke keer als hij klaar is) blijven
   op blok D. Ze staan in `toBlockD`, en die lijst geldt voor beide indelingen (GEMETEN, `ForeverBlock.lua` regels
   40-55). Er is ook geen plek meer vrij.
6. **Shift-R is geen beweging.** De Hunter heeft geen tweede beweging (Disengage is in Forever geen sprong). Aspect of
   the Hawk blijft daar, zoals in het oude blok. Ctrl-4 had ook een aspect kunnen zijn (een aspect lijkt op een
   stance), maar Call Pet past beter naast de pet-toetsen.
7. **`bang` op Auto Shot** is nog steeds niet gemeten in Forever (zelfde aantekening als in het oude blok).
8. **Downranks:** ik vond in `Modules/` geen downrank-advies voor de Hunter. Niets genoemd.
9. **Voor de bouwer:** `ForeverBlockUnlisted()` zet elke veldwaarde behalve `open`, `bang`, `pair` en `cmd` in de
   lijst met bekende namen (GEMETEN, `ForeverBlock.lua` regels 576-587), dus ook de `why`-tekst. Onschuldig, maar
   `why` overslaan is netter. Bij de `cmd`-regels staat `why` naast `cmd`.
10. **`ForeverHowToPlay.lua` noemt de oude toetsen** (5, F1, F2, F3, F4, Shift-F1). Die tekst klopt niet voor 12 x 4.

## keys12

```lua
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { base = "Auto Shot", bang = true, why = "main button: Auto Shot; a second press keeps shooting" },
		["2"] = { base = "Serpent Sting", why = "Serpent Sting first, damage over time" },
		["3"] = { base = "Arcane Shot", why = "instant shot: Arcane Shot" },
		["4"] = { base = "Aimed Shot", why = "big shot: Aimed Shot (stand still)" },
		["Q"] = { base = "Rapid Fire", why = "big cooldown: Rapid Fire" },
		["E"] = { base = { "Scatter Shot", "Intimidation" }, why = "stop a cast: Scatter Shot, or your pet's Intimidation" },
		["R"] = { base = "Aspect of the Cheetah", why = "movement: Aspect of the Cheetah" },
		["F"] = { base = "Mend Pet", why = "help spell: Mend Pet heals your pet" },
		["Z"] = { base = "Disengage", why = "small defensive: Disengage lowers threat up close" },
		["X"] = { base = "Feign Death", why = "second defensive: Feign Death" },
		["C"] = { base = "Deterrence", why = "big defensive: Deterrence" },
		["V"] = { base = "Freezing Trap", why = "crowd control: Freezing Trap" },
		-- Bar B (Shift)
		["SHIFT-1"] = { base = "Multi-Shot", why = "AoE: Multi-Shot" },
		["SHIFT-2"] = { base = { "Explosive Trap", "Immolation Trap" }, why = "AoE trap: Explosive, before 34 Immolation" },
		["SHIFT-3"] = { base = "Summon Hawk", why = "Summon Hawk shares a cooldown with Arcane Shot on 3" },
		["SHIFT-4"] = { base = { "Sniper Shot", "Bestial Wrath" }, why = "level-40 talent: Sniper Shot or Bestial Wrath" },
		["SHIFT-Q"] = { base = "Concussive Shot", why = "slow: Concussive Shot" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Stoneform", "Blood Fury", "Berserking", "Perception",
			"Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Aspect of the Hawk", why = "main aspect: Aspect of the Hawk" },
		["SHIFT-F"] = { base = "Wing Clip", why = "crowd control 2: Wing Clip slows up close" },
		["SHIFT-Z"] = { base = "Hunter's Mark", why = "Hunter's Mark, once per enemy" },
		["SHIFT-X"] = { base = "Raptor Strike", why = "melee hit: Raptor Strike, was key 5" },
		["SHIFT-C"] = { base = "Mongoose Bite", why = "melee: Mongoose Bite after a dodge" },
		["SHIFT-V"] = { base = "Counterattack", why = "crowd control 3: Counterattack after a parry" },
		-- Bar C (Ctrl); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-1"] = { cmd = { text = "/petattack", needs = "Call Pet", label = "Pet: Attack", icon = "Ability_GhoulFrenzy" },
			why = "pet: attack your target" },
		["CTRL-2"] = { cmd = { text = "/petfollow", needs = "Call Pet", label = "Pet: Follow", icon = "Ability_Tracking" },
			why = "pet: follow you" },
		["CTRL-3"] = { cmd = { text = "/petstay", needs = "Call Pet", label = "Pet: Stay", icon = "Spell_Nature_TimeStop" },
			why = "pet: stay where it is" },
		["CTRL-4"] = { base = "Call Pet", why = "Call Pet, next to the three pet keys" },
		["CTRL-Q"] = { base = "Trueshot Aura", why = "group buff: Trueshot Aura" },
		["CTRL-E"] = { base = "Distracting Shot", why = "taunt: Distracting Shot, rarely needed" },
		["CTRL-R"] = { base = "Revive Pet", why = "your dead pet back: Revive Pet" },
	},
```
