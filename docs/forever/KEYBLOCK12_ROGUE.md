# Toetsblok 12 x 4 — Rogue (WoW Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen in `Modules/` (geen `docs/`, geen gamedata: deze opdracht
verbood `_probe.py`). Bronnen:
- `Modules/ForeverBlock_Rogue.lua` = **oud blok** (GEMETEN: de huidige `keys`, `states` en `baseGuard`).
- `Modules/ForeverHowToPlay.lua` = de uitleg en de drie rollen (GEMETEN, regels 239-280 en 697-762).
- `Modules/ForeverSpellIds.lua` = elke spellnaam hieronder staat daar letterlijk als sleutel (GEMETEN met één Grep, alle
  namen gevonden; dezelfde Grep vond "Safe Fall" en "Detect Traps" niet, die gebruik ik ook niet).
- `Modules/KeyBlock.lua` regels 65-97 = het 12 x 4-rooster (GEMETEN).
- `Modules/ForeverBlock.lua` = hoe de motor een regel leest (GEMETEN): `stealth` krijgt `[bonusbar:1]`, `base` krijgt
  dan `[nobonusbar:1]` ervoor (`baseGuard`); `gun`/`bow`/`xbow` volgen het wapen.

States (uit het oude blok, ongewijzigd): `stealth`, `gun`, `bow`, `xbow`, plus `base`.

## Wat er verandert ten opzichte van het oude blok

- De toetsen 5, F1, F3, F4 en Shift-F1 bestaan niet meer. Rupture (5) naar **Ctrl-4**, Cold Blood (F1) naar
  **Shift-Q**, Preparation (F3) naar **C**, de race-heals (F4) naar **Ctrl-R**, Riposte (Shift-F1) naar **Shift-Z**.
- Sap/Gouge van Shift-Q naar **Shift-F** (crowd control 2). Distract van Shift-F naar **Ctrl-Q**. Expose Armor van
  Shift-Z naar **Ctrl-E**.
- C was leeg en heeft nu Preparation. Ctrl-1, Ctrl-2 en Ctrl-3 blijven leeg (de Rogue heeft geen vormen; zie twijfel 1).

## Tabel

| Toets | Spell | Waarom | Bron |
|---|---|---|---|
| 1 | Sinister Strike; in Stealth Garrote | Hoofdknop. | oud blok |
| 2 | Backstab; in Stealth Ambush | Rotatie (dolk, van achteren). | oud blok |
| 3 | Mutilate / Hemorrhage | Talentbouwer (40 / 30). De eerste die je kent wint. | oud blok |
| 4 | Eviscerate | Spender: je hoofdfinisher. | oud blok |
| Q | Adrenaline Rush / Death Mark | Grote cooldown (talent van 40). | oud blok |
| E | Kick | Interrupt. E is bij elke klasse de interrupt. | oud blok |
| R | Sprint | Beweging. | oud blok |
| F | Feint; in Stealth Pick Pocket | Hulpspell. | oud blok |
| Z | Evasion | Kleine defensive. | oud blok |
| X | Vanish | Tweede defensive: je ontsnapping. | oud blok |
| C | Preparation | Grote defensive: maakt Vanish, Evasion en Sprint meteen weer klaar. Noodknop op balk A (regel 2). De stuns staan al op V. Was F3. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| V | Kidney Shot; in Stealth Cheap Shot | Crowd control (stun). | oud blok |
| Shift-1 | Blade Flurry | AoE: het enige wat de Rogue tegen twee vijanden heeft. | oud blok; bron: ForeverHowToPlay.lua |
| Shift-2 | Shoot Gun / Shoot Bow / Shoot Crossbow (bij je wapen), anders Throw | Pullen van afstand. Geen tweede AoE. | oud blok |
| Shift-3 | Shank | Tweede van 3: cooldown 10 s, geeft Energy terug. | oud blok; bron: ForeverHowToPlay.lua |
| Shift-4 | Slice and Dice | Tweede finisher. | oud blok |
| Shift-Q | Cold Blood | Tweede cooldown (3 minuten), vóór een grote finisher. Was F1. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Shift-E | je race-spell | Zelfde lijst als het oude blok. | oud blok |
| Shift-R | Stealth | Zelfde knop erin en eruit. Zelfde toets als Prowl bij de Druid. | oud blok; Druid: ForeverBlock_Druid.lua |
| Shift-F | Gouge; in Stealth Sap | Crowd control 2. Was Shift-Q. | AFGELEID (regel: Shift-F = crowd control 2) |
| Shift-Z | Riposte | Tweede kleine defensive: na een parry, ontwapent de vijand 6 s. Was Shift-F1. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Shift-X | Ghostly Strike | Defensive: 15% meer dodge voor 7 s. | oud blok; bron: ForeverHowToPlay.lua |
| Shift-C | Premeditation | 2 combo points vóór je opener. Geen tweede grote defensive over. | oud blok |
| Shift-V | Blind | Crowd control 3 (kost een Blinding Powder). | oud blok |
| Ctrl-1 | (leeg) | De Rogue heeft geen vorm of stance hier. | AFGELEID |
| Ctrl-2 | (leeg) | Idem. | AFGELEID |
| Ctrl-3 | (leeg) | Idem. | AFGELEID |
| Ctrl-4 | Rupture | Derde finisher, op dezelfde toets 4 als Eviscerate en Slice and Dice. Was 5. | plek AFGELEID |
| Ctrl-Q | Distract | Hulpspell, zelden nodig. Was Shift-F. | plek AFGELEID |
| Ctrl-E | Expose Armor | Finisher voor groepen, zelden solo. Was Shift-Z. | plek AFGELEID |
| Ctrl-R | Cannibalize / Rapid Regeneration / Read Leyline | Herstel buiten gevecht: de heal van je race. Was F4. | oud blok; bron: ForeverHowToPlay.lua |

Ctrl-F, Ctrl-Z, Ctrl-X, Ctrl-C en Ctrl-V zijn vaste items: daar staat niets.

## Twijfels en wat ik niet kon meten

1. **Stealth op Shift-R, niet op Ctrl-1.** Regel 5 zegt: vormen op Ctrl-1 tot 4. Stealth is in de data een vorm
   (het oude blok noemt form 30 met BonusActionBar 1). Maar de Druid heeft Prowl op Shift-R (GEMETEN,
   `ForeverBlock_Druid.lua` regel 52), en regel 3 zegt: dezelfde taak op dezelfde toets. Ik koos Shift-R. Wil Rob
   Stealth op Ctrl-1, dan krijgt Shift-R niets (de Rogue heeft geen tweede beweging).
2. **Toets 3 is leeg voor Combat, het hele spel.** Combat is MH's standaard leveltree voor de Rogue
   (`ForeverTalentNext.lua`, `DEFAULT` ROGUE = 2), en Combat krijgt nooit Mutilate of Hemorrhage. Optie (niet gekozen):
   `["3"] = { all = { "Mutilate", "Hemorrhage", "Riposte" } }`. Dan staat Riposte bij Combat op 3. Risico: wie
   Hemorrhage én Riposte heeft, verliest Riposte van het blok. Dat die twee elkaar uitsluiten is AFGELEID, niet gemeten.
3. **Death Mark is geen grote cooldown.** Volgens `ForeverHowToPlay.lua` is het een finisher (25 Energy, cooldown 10 s).
   Hij blijft op Q met Adrenaline Rush, zoals in het oude blok. Ze zijn elkaars alternatief (talent van 40 in twee
   verschillende trees). Dat niemand beide heeft is AFGELEID.
4. **Rupture op Ctrl-4** is minder handig voor Assassination en Subtlety, die hem vaak drukken. Alternatief: Rupture op
   Shift-Z en Riposte naar een Ctrl-toets. Ik koos Riposte op Shift-Z, omdat Combat de standaard is.
5. **Preparation op C** is een Subtlety-talent (30). Voor Combat en Assassination blijft C leeg.
6. **Ctrl-1, Ctrl-2 en Ctrl-3 blijven leeg.** Pick Lock en Disarm Trap zouden kunnen, maar ze staan in `toBlockD`, en
   die lijst geldt voor beide indelingen (GEMETEN, `ForeverBlock.lua` regels 40-55). Dan stonden ze er twee keer.
7. **Poisons** blijven items op blok D, zoals nu.
8. **Downranks:** ik vond in `Modules/` geen downrank-advies voor de Rogue. Niets genoemd.
9. **Niet gemeten in Forever:** wat Distract precies doet en zijn cooldown. Ik noem daarom geen getal.
10. **Voor de bouwer:** `ForeverBlockUnlisted()` zet elke veldwaarde behalve `open`, `bang`, `pair` en `cmd` in de
    lijst met bekende namen (GEMETEN, `ForeverBlock.lua` regels 576-587), dus ook de `why`-tekst. Onschuldig, maar
    `why` overslaan is netter.
11. **`ForeverHowToPlay.lua` noemt de oude toetsen** (5, F1, F3, F4, Shift-F1, Shift-Q voor Gouge/Sap). Die tekst klopt
    niet voor 12 x 4.

## keys12

```lua
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { stealth = "Garrote", base = "Sinister Strike", why = "main hit; Garrote from Stealth" },
		["2"] = { stealth = "Ambush", base = "Backstab", why = "Backstab from behind; Ambush from Stealth" },
		["3"] = { all = { "Mutilate", "Hemorrhage" }, why = "talent builder: Mutilate or Hemorrhage" },
		["4"] = { all = "Eviscerate", why = "main finisher: Eviscerate" },
		["Q"] = { all = { "Adrenaline Rush", "Death Mark" }, why = "your level-40 talent: Adrenaline Rush or Death Mark" },
		["E"] = { all = "Kick", why = "your interrupt: E is the kick key for every class" },
		["R"] = { all = "Sprint", why = "movement: Sprint" },
		["F"] = { stealth = "Pick Pocket", base = "Feint", why = "Feint lowers threat; Pick Pocket from Stealth" },
		["Z"] = { all = "Evasion", why = "small defensive: Evasion" },
		["X"] = { all = "Vanish", why = "escape: Vanish (needs a Flash Powder)" },
		["C"] = { all = "Preparation", why = "emergency: Preparation readies Vanish, Evasion, Sprint" },
		["V"] = { stealth = "Cheap Shot", base = "Kidney Shot", why = "stun: Kidney Shot; Cheap Shot from Stealth" },
		-- Bar B (Shift)
		["SHIFT-1"] = { all = "Blade Flurry", why = "AoE: Blade Flurry, your only two-target tool" },
		["SHIFT-2"] = { gun = "Shoot Gun", bow = "Shoot Bow", xbow = "Shoot Crossbow", base = "Throw",
			why = "ranged pull: the shot for your weapon, else Throw" },
		["SHIFT-3"] = { all = "Shank", why = "Shank: short cooldown, gives Energy back" },
		["SHIFT-4"] = { all = "Slice and Dice", why = "second finisher: Slice and Dice" },
		["SHIFT-Q"] = { all = "Cold Blood", why = "second cooldown: Cold Blood before a big finisher" },
		["SHIFT-E"] = { all = { "Shadowmeld", "Perception", "Blood Fury", "Stoneform", "Will of the Forsaken",
			"Escape Artist", "Berserking", "Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { all = "Stealth", why = "Stealth in and out; same key as the Druid's Prowl" },
		["SHIFT-F"] = { stealth = "Sap", base = "Gouge", why = "crowd control 2: Gouge; Sap from Stealth" },
		["SHIFT-Z"] = { all = "Riposte", why = "after a parry: Riposte disarms the enemy" },
		["SHIFT-X"] = { all = "Ghostly Strike", why = "defensive hit: Ghostly Strike gives more dodge" },
		["SHIFT-C"] = { all = "Premeditation", why = "Premeditation: 2 combo points before your opener" },
		["SHIFT-V"] = { all = "Blind", why = "crowd control 3: Blind (needs a Blinding Powder)" },
		-- Bar C (Ctrl); CTRL-1/2/3 stay empty (no forms); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-4"] = { all = "Rupture", why = "third finisher: Rupture, on key 4 like Eviscerate" },
		["CTRL-Q"] = { all = "Distract", why = "utility: Distract" },
		["CTRL-E"] = { all = "Expose Armor", why = "group finisher: Expose Armor" },
		["CTRL-R"] = { all = { "Cannibalize", "Rapid Regeneration", "Read Leyline" },
			why = "your race's heal, outside a fight" },
	},
```
