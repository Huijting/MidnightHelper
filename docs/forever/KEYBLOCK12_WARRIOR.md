# Toetsblok 12 x 4 — Warrior (WoW Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen in `Modules/` (geen `docs/`, geen gamedata: deze opdracht
verbood `_probe.py`). Bronnen:
- `Modules/ForeverBlock_Warrior.lua` = **oud blok** (GEMETEN: de huidige `keys` en `states`).
- `Modules/ForeverHowToPlay.lua` = de uitleg per stance en per rol (GEMETEN, regels 199-237 en 496-562).
- `Modules/ForeverSpellIds.lua` = elke spellnaam hieronder staat daar letterlijk als sleutel (GEMETEN met één Grep,
  42 van 42 namen gevonden; dezelfde Grep vond "Tactical Mastery" en "Vanguard" niet, dat zijn passieven).
- `Modules/KeyBlock.lua` regels 65-97 = het 12 x 4-rooster (GEMETEN: dezelfde 31 spellplekken als de opdracht).
- `Modules/ForeverBlock.lua` = hoe de motor een regel leest (GEMETEN): staat er `all` en kent de speler die spell, dan
  telt alleen `all`. Daarom mengt geen regel `all` met stance-velden.

States (uit het oude blok, ongewijzigd): `battle` = Battle Stance, `defensive` = Defensive Stance, `berserker` =
Berserker Stance.

## Wat er verandert ten opzichte van het oude blok

- De toetsen 5, F1, F2, F3 en Shift-F1 bestaan niet meer. Hun spells kregen een nieuwe plek:
  Sunder Armor (5) naar **Shift-C**, Bloodrage (F1) naar **Shift-Q**, Victory Rush (F2) naar **Shift-X**,
  Reckless Swings (Shift-F1) naar **Ctrl-R**.
- **Spearing Strike (F3) heeft geen plek meer.** Het oude blok vulde 32 toetsen, het nieuwe heeft er 31. Zie twijfel 1.
- Om plaats te maken: Intimidating Shout van Shift-Q naar **Shift-F** (crowd control 2), Challenging Shout van
  Shift-F naar **Ctrl-E**, Battle Shout van Shift-X naar **Ctrl-Q** (buff), Slam van Shift-C naar **Ctrl-4**.
- Berserker Rage van Shift-V naar **Z** (alleen in Berserker Stance). Zo heeft Z in elke stance waar dat kan een kleine
  defensive. Shift-V houdt Concussion Blow in Battle en Defensive Stance.

## Tabel

| Toets | Spell (per stance) | Waarom | Bron |
|---|---|---|---|
| 1 | Heroic Strike (alle) | Hoofdknop, werkt in elke stance. | oud blok |
| 2 | Overpower (Battle), Revenge (Defensive), Whirlwind (Berserker) | De eigen klap van elke stance, op de tweede beste toets. | oud blok |
| 3 | Mortal Strike / Bloodthirst / Shield Slam (alle) | Je talentklap van 40. De eerste die je kent wint. | oud blok |
| 4 | Execute (Battle, Berserker) | Spender: alleen onder 20% leven. In Defensive leeg. | oud blok; stances: bron: ForeverHowToPlay.lua |
| Q | Sweeping Strikes (Battle), Recklessness (Berserker) | Grote cooldown van die stance. | oud blok |
| E | Shield Bash (Battle, Defensive), Pummel (Berserker) | Interrupt. E is bij elke klasse de interrupt. | oud blok |
| R | Charge (Battle, Defensive), Intercept (Berserker) | Beweging. Charge in Defensive alleen met Vanguard. | oud blok; bron: ForeverHowToPlay.lua |
| F | Mocking Blow (Battle), Taunt (Defensive) | Taunt. | oud blok |
| Z | Shield Block (Defensive), Berserker Rage (Berserker) | Kleine defensive van die stance. Berserker Rage was Shift-V. | Shield Block: oud blok. Berserker Rage hier: AFGELEID |
| X | Last Stand (alle) | Noodknop (30% meer max leven, 20 s) op balk A, regel 2. | oud blok; effect: bron: ForeverHowToPlay.lua |
| C | Retaliation (Battle), Shield Wall (Defensive) | Grote defensive. De Warrior heeft alleen een stun als talent (Concussion Blow, vanaf 30), en die staat op Shift-V. Dus C = grote defensive. | oud blok |
| V | Hamstring (Battle, Berserker), Disarm (Defensive) | Crowd control. | oud blok |
| Shift-1 | Thunder Clap (Battle, Defensive) | AoE. | oud blok |
| Shift-2 | Demoralizing Shout (alle) | AoE. | oud blok |
| Shift-3 | Death Wish (alle) | Cooldown. | oud blok |
| Shift-4 | Cleave (alle) | AoE-spender: de Heroic Strike voor twee vijanden. | oud blok |
| Shift-Q | Bloodrage (alle) | Tweede cooldown (1 minuut), aan het begin van elk gevecht. Was F1. | bron: ForeverHowToPlay.lua (cooldown 1 min); plek AFGELEID |
| Shift-E | je race-spell | Race-spell, zelfde lijst als het oude blok. | oud blok |
| Shift-R | Piercing Howl (alle) | Tweede beweging. De Warrior heeft geen tweede; deze slow houdt vijanden af. | oud blok |
| Shift-F | Intimidating Shout (alle) | Crowd control 2, je noodknop als je omsingeld bent. Was Shift-Q. | AFGELEID |
| Shift-Z | Rend (Battle, Defensive) | Bleed bij elke pull (Arms). Geen tweede kleine defensive over. | oud blok |
| Shift-X | Victory Rush (alle) | Defensive: het is je enige zelf-heal (na een kill). Was F2. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Shift-C | Sunder Armor (alle) | De tank drukt hem steeds (tot 5 stacks). Was 5. | bron: ForeverHowToPlay.lua (Protection); plek AFGELEID |
| Shift-V | Concussion Blow (Battle, Defensive) | Crowd control 3: een stun (talent). | oud blok |
| Ctrl-1 | Battle Stance | Stance 1. Zelfde knop: je blijft erin. | oud blok |
| Ctrl-2 | Defensive Stance | Stance 2. | oud blok |
| Ctrl-3 | Berserker Stance | Stance 3. | oud blok |
| Ctrl-4 | Slam (alle) | Er is geen vierde stance. Slam pas nuttig met Improved Slam (35). Was Shift-C. | bron: ForeverHowToPlay.lua; plek AFGELEID |
| Ctrl-Q | Battle Shout (alle) | Buff, vóór het gevecht. Was Shift-X. | AFGELEID |
| Ctrl-E | Challenging Shout (alle) | Zeldzame tankknop. Was Shift-F. | AFGELEID |
| Ctrl-R | Reckless Swings (alle) | Herstel: geeft Rage terug (kost leven). Een Warrior heeft geen herstel buiten gevecht. Was Shift-F1. | bron: ForeverHowToPlay.lua (Fury); plek AFGELEID |

Ctrl-F, Ctrl-Z, Ctrl-X, Ctrl-C en Ctrl-V zijn vaste items: daar staat niets.

## Twijfels en wat ik niet kon meten

1. **Spearing Strike past niet.** 32 gevulde toetsen in het oude blok, 31 plekken nu. Ik koos deze, want: alleen
   Battle Stance, een talent (Arms, 25), en volgens `ForeverHowToPlay.lua` alleen een extra harde klap op Giants en
   Dragonkin. Advies: zelf op een Alt-toets (blok D). Let op: in 12 x 4 komt hij dan in de rode regel "staat niet in
   MH's lijst", want die regel kijkt naar `keys12`. Voeg hem toe aan `listed` als je dat niet wilt.
   Alternatief (niet gekozen): Shift-R = `{ battle = "Spearing Strike", defensive = "Piercing Howl", berserker =
   "Piercing Howl" }`. Dan heeft Arms in Battle Stance geen Piercing Howl meer op het blok.
2. **Berserker Rage op Z (Berserker).** Dat hij "klein defensief" is (immuun voor fear) komt uit Classic, met
   hetzelfde id 18499. AFGELEID, niet gemeten in Forever. Wel GEMETEN: hij werkt alleen in Berserker Stance
   (`ForeverHowToPlay.lua` regel 542).
3. **Stance-grenzen niet opnieuw gemeten.** Ze komen uit het oude blok en `ForeverHowToPlay.lua`. Zo blijft
   Concussion Blow beperkt tot Battle en Defensive, zoals in het oude blok. De bouwchat kan het controleren met
   gamedata, bijvoorbeeld `run gamedata db2 SpellShapeshift SpellID=12809,18499 --game forever`.
4. **Sunder Armor of Slam op de betere plek.** Sunder (tank) staat op Shift-C, Slam op Ctrl-4. Reden: Protection is
   MH's standaard leveltree voor de Warrior (`ForeverTalentNext.lua`, `DEFAULT` WARRIOR = 3). Speelt iemand Arms met
   Improved Slam, dan zijn die twee beter omgewisseld.
5. **Ctrl-4 en Ctrl-R hebben bij de Warrior geen eigen taak** (geen vierde stance, geen herstel buiten gevecht). De
   race-heals (Cannibalize, Rapid Regeneration, Read Leyline) zouden op Ctrl-R passen. Maar ze staan in `toBlockD`, en
   die lijst geldt voor beide indelingen (GEMETEN, `ForeverBlock.lua` regels 40-55). Dan stonden ze er twee keer.
6. **Lege plekken per stance:** 4 en Q in Defensive, F en C in Berserker, Z in Battle, Shift-V in Berserker. Daar is
   geen stance-spell van dezelfde soort voor.
7. **Downranks:** ik vond in `Modules/` geen downrank-advies voor de Warrior. Niets genoemd.
8. **Getallen die ik niet noem:** de cooldown van Challenging Shout en Intimidating Shout staat niet in mijn bronnen.
9. **Voor de bouwer:** `ForeverBlockUnlisted()` zet elke veldwaarde behalve `open`, `bang`, `pair` en `cmd` in de lijst
   met bekende namen (GEMETEN, `ForeverBlock.lua` regels 576-587). Een `why`-tekst komt daar dus ook in. Dat kan geen
   kwaad (geen spell heet zo), maar `why` overslaan is netter.
10. **`ForeverHowToPlay.lua` noemt de oude toetsen** (F1, F2, 5, Shift-F1, F3). Die tekst klopt niet voor 12 x 4.

## keys12

```lua
	keys12 = {
		-- Bar A (no modifier)
		["1"] = { all = "Heroic Strike", why = "main hit in every stance" },
		["2"] = { battle = "Overpower", defensive = "Revenge", berserker = "Whirlwind",
			why = "your stance's own strike: Overpower, Revenge or Whirlwind" },
		["3"] = { all = { "Mortal Strike", "Bloodthirst", "Shield Slam" }, why = "your level-40 talent strike" },
		["4"] = { battle = "Execute", berserker = "Execute", why = "finisher: Execute below 20% health" },
		["Q"] = { battle = "Sweeping Strikes", berserker = "Recklessness", why = "big cooldown of your stance" },
		["E"] = { battle = "Shield Bash", defensive = "Shield Bash", berserker = "Pummel",
			why = "your interrupt: E is the kick key for every class" },
		["R"] = { battle = "Charge", defensive = "Charge", berserker = "Intercept",
			why = "movement: Charge, or Intercept in Berserker Stance" }, -- Defensive: Vanguard talent only
		["F"] = { battle = "Mocking Blow", defensive = "Taunt", why = "taunt: Taunt, or Mocking Blow in Battle Stance" },
		["Z"] = { defensive = "Shield Block", berserker = "Berserker Rage",
			why = "small defensive: Shield Block or Berserker Rage" },
		["X"] = { all = "Last Stand", why = "emergency button: Last Stand" },
		["C"] = { battle = "Retaliation", defensive = "Shield Wall", why = "big defensive: Shield Wall or Retaliation" },
		["V"] = { battle = "Hamstring", defensive = "Disarm", berserker = "Hamstring",
			why = "crowd control: Hamstring, or Disarm in Defensive Stance" },
		-- Bar B (Shift)
		["SHIFT-1"] = { battle = "Thunder Clap", defensive = "Thunder Clap", why = "AoE: Thunder Clap" },
		["SHIFT-2"] = { all = "Demoralizing Shout", why = "AoE: Demoralizing Shout" },
		["SHIFT-3"] = { all = "Death Wish", why = "cooldown: Death Wish" },
		["SHIFT-4"] = { all = "Cleave", why = "AoE rage spender: Cleave" },
		["SHIFT-Q"] = { all = "Bloodrage", why = "second cooldown: Bloodrage, Rage to start a fight" },
		["SHIFT-E"] = { all = { "Blood Fury", "Berserking", "Stoneform", "Will of the Forsaken", "War Stomp",
			"Escape Artist", "Shadowmeld", "Will to Survive", "Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { all = "Piercing Howl", why = "no second movement: Piercing Howl slows enemies" },
		["SHIFT-F"] = { all = "Intimidating Shout", why = "crowd control 2: Intimidating Shout" },
		["SHIFT-Z"] = { battle = "Rend", defensive = "Rend", why = "bleed: Rend, kept where it was" },
		["SHIFT-X"] = { all = "Victory Rush", why = "your self heal after a kill: Victory Rush" },
		["SHIFT-C"] = { all = "Sunder Armor", why = "tank: Sunder Armor, was key 5" },
		["SHIFT-V"] = { battle = "Concussion Blow", defensive = "Concussion Blow", why = "crowd control 3: stun" },
		-- Bar C (Ctrl); CTRL-F/Z/X/C/V are the fixed items
		["CTRL-1"] = { all = "Battle Stance", why = "stance 1" },
		["CTRL-2"] = { all = "Defensive Stance", why = "stance 2" },
		["CTRL-3"] = { all = "Berserker Stance", why = "stance 3" },
		["CTRL-4"] = { all = "Slam", why = "no fourth stance, so Slam lives here" },
		["CTRL-Q"] = { all = "Battle Shout", why = "buff: Battle Shout, before the fight" },
		["CTRL-E"] = { all = "Challenging Shout", why = "rare tank button: Challenging Shout" },
		["CTRL-R"] = { all = "Reckless Swings", why = "Rage back: Reckless Swings (costs health)" },
	},
```
