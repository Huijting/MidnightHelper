# Toetsenblok 12 x 4 — Mage (Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen: `Modules/ForeverBlock_Mage.lua` (oude blok), `ForeverBlock.lua`
(motor), `KeyBlock.lua` (rooster), `ForeverHowToPlay.lua`, `ForeverTalentNext.lua`, `ForeverSpellIds.lua`,
`ForeverTrainerData.lua`, `ForeverBuffs.lua`, `MissingBuff.lua`, `ForeverReadyBoard.lua`. Niets in `docs/` gelezen
behalve de opdracht zelf (`KEYBLOCK12_BRIEF.md`, gelezen voordat de coördinator de opdracht als tekst stuurde).
Geen ROLES-bestand gelezen.

## Kort

- Het oude blok had **33** plekken met een spell. 12 x 4 heeft er **31**. Er moeten dus twee weg.
- Ik heb de twee **buffs** van het blok gehaald: de armor (Ice Armor / Frost Armor) en Arcane Intellect /
  Arcane Brilliance. Reden: MH heeft al een knop die precies die buffs zet (zie "Twijfels" punt 1).
- Alles wat op een toets stond die in 12 x 4 nog bestaat, met een passende taak, blijft op dezelfde toets.
  Alleen wat op 5, F1-F4 en Shift-F1 stond, en Polymorph (Shift-Q is nu "tweede cooldown"), verhuist.
- Elke naam gecontroleerd met Grep in `ForeverSpellIds.lua`: 38 van 38 namen gevonden (GEMETEN, 24 nov,
  één zoekopdracht met alle namen; elke naam gaf precies één regel).

## De tabel

"Oud blok" = `Modules/ForeverBlock_Mage.lua` regel 21-56 (GEMETEN, gelezen 24 nov). "HtP" = `ForeverHowToPlay.lua`
(tekst van 6-17 nov; volgens de kop van dat bestand nagekeken door mh-research tegen DB2 — dat is een bewering in het
bestand, niet door mij opnieuw gemeten).

| Toets | Spell | Waarom | Herkomst |
|---|---|---|---|
| `1` | Fireball | Hoofdspell, al vanaf level 1. Het oude blok is "boom-neutraal": iedere Mage heeft hem. | oud blok, zelfde toets |
| `2` | Frostbolt | Hoofdspell van Frost, de boom waar de meeste gidsen mee levelen. | oud blok, zelfde toets; Frost = standaard: `ForeverTalentNext.lua` r.39 (`MAGE = 3`), HtP r.610 |
| `3` | Arcane Missiles | Arcane-spell; direct drukken als Missile Barrage oplicht. | oud blok, zelfde toets; HtP r.570 |
| `4` | Pyroblast | Spender: Fire opent ermee en geeft er Heating Up aan uit. | oud blok, zelfde toets; HtP r.590, r.593 |
| `Q` | Arcane Power / Combustion | Grote cooldown (talent, 40). Je kunt er maar één van hebben. | oud blok, zelfde toets; HtP r.580, r.602. "Maar één": AFGELEID (allebei 31-punt-talenten, max 51 punten) |
| `E` | Counterspell | Interrupt. E = kick bij elke klasse. | oud blok, zelfde toets |
| `R` | Blink | Beweging. R = beweging bij elke klasse. | oud blok, zelfde toets |
| `F` | Ice Lance | Frost: op een bevroren vijand. Deelt een cooldown met Fire Blast. | oud blok, zelfde toets; gedeelde cooldown: HtP r.628 |
| `Z` | Mana Shield | Kleine defensive. | oud blok, zelfde toets |
| `X` | Ice Barrier | Tweede defensive: een schild (Frost-talent, 40). | oud blok, zelfde toets; HtP r.623 |
| `C` | Ice Block | Grote defensive en noodknop op balk A. Een Mage heeft geen stun, dus C = defensive. | oud blok, zelfde toets; HtP r.618 |
| `V` | Frost Nova | Crowd control: bevriest vijanden om je heen. | oud blok, zelfde toets; HtP r.156 |
| `SHIFT-1` | Blizzard | AoE. | oud blok, zelfde toets |
| `SHIFT-2` | Arcane Explosion | AoE om je heen. | oud blok, zelfde toets; HtP r.161 |
| `SHIFT-3` | Fire Blast | Instant, cooldown 8 s. Iedere Mage gebruikt hem, ook om af te maken. Krijgt de beste vrije Shift-toets. | was `5`; HtP r.153, r.592, r.617. Plek: AFGELEID |
| `SHIFT-4` | Flamestrike | AoE, naast Pyroblast op 4. | oud blok, zelfde toets |
| `SHIFT-Q` | Presence of Mind | Tweede cooldown, naast Arcane Power op Q (eerst PoM, dan Arcane Power). | was `SHIFT-3`; HtP r.574, r.580. Plek: AFGELEID |
| `SHIFT-E` | race-spell (lijst) | Race-spell. Shift-E bij elke klasse. | oud blok, zelfde toets, zelfde lijst |
| `SHIFT-R` | Slow Fall | Tweede beweging. | oud blok, zelfde toets |
| `SHIFT-F` | Cone of Cold | Crowd control 2 (Frost, dichtbij). | oud blok, zelfde toets; HtP r.616 |
| `SHIFT-Z` | Frost Ward | Tweede kleine defensive. | was `F2`. Plek: AFGELEID |
| `SHIFT-X` | Fire Ward | Defensive. Deelt een cooldown met Frost Ward, dus ze staan onder elkaar. | was `F4`; gedeelde cooldown: HtP r.167. Plek: AFGELEID |
| `SHIFT-C` | Cold Snap | Grote defensive 2: zet je andere Frost-cooldowns terug. Naast Ice Block (C). | oud blok, zelfde toets; HtP r.622 |
| `SHIFT-V` | Polymorph | Crowd control 3. Shift-Q is in 12 x 4 "tweede cooldown", dus Polymorph gaat naar een CC-plek. | was `SHIFT-Q`; HtP r.155. Plek: AFGELEID |
| `CTRL-1` | Scorch | Geen vormen (oud blok: "No forms or stances", DB2 70790), dus Ctrl houdt spells. Fire, dichtbij. | oud blok, zelfde toets; HtP r.594 |
| `CTRL-2` | Arcane Blast | Arcane-talent. | oud blok, zelfde toets |
| `CTRL-3` | Frostfire Bolt / Shoot (`bang`) | Wand tot Frostfire Bolt (40) de plek neemt. | oud blok, zelfde toets, zelfde vorm; HtP r.151, r.580; Frostfire Bolt l=40 in `ForeverTrainerData.lua` r.442 |
| `CTRL-4` | Arcane Wrath | Arcane-talent; na Arcane Blast of Presence of Mind. | was `SHIFT-F1`; HtP r.571, r.574. Plek: AFGELEID |
| `CTRL-Q` | Remove Lesser Curse | Hulpspell: haalt een curse weg bij jou of een vriend. | was `SHIFT-V`. Plek: AFGELEID (geen betere vrije plek) |
| `CTRL-E` | Blast Wave | Cooldown (Fire-talent, 30). | was `F3`; oude taak "CD4" = nieuwe taak van Ctrl-E (`KeyBlock.lua` r.58 en r.90, GEMETEN) |
| `CTRL-R` | Evocation | Herstel: krijgt je mana terug. | was `F1`; HtP r.162. Plek: AFGELEID |
| `CTRL-F` t/m `CTRL-V` | — | Vaste items van MH. Geen spell. | opdracht |

**Niet meer op het blok:** Ice Armor / Frost Armor (was `SHIFT-Z`) en Arcane Brilliance / Arcane Intellect (was `SHIFT-X`).

## Wat er verandert voor de speler (voor How you play)

Verhuisd: Fire Blast 5 → Shift-3 · Presence of Mind Shift-3 → Shift-Q · Polymorph Shift-Q → Shift-V ·
Remove Lesser Curse Shift-V → Ctrl-Q · Evocation F1 → Ctrl-R · Frost Ward F2 → Shift-Z · Fire Ward F4 → Shift-X ·
Blast Wave F3 → Ctrl-E · Arcane Wrath Shift-F1 → Ctrl-4 · armor en Intellect: niet meer op het blok.
Alle andere toetsen blijven gelijk. De tekst in `ForeverHowToPlay.lua` (r.147-168 en r.565-629) noemt de oude toetsen.
Ook de algemene regel r.33 ("T = potion, Shift-T = healthstone, G = trinket") klopt niet voor 12 x 4.

## Twijfels en wat ik niet kon meten

1. **Welke twee eruit.** Ik koos de twee buffs. GEMETEN in de code (24 nov): `ForeverBuffs.lua` r.38-41 zet voor de
   Mage Arcane Intellect (Brilliance telt mee) en de armor (Ice / Frost / Mage Armor) op de buff-knop, en die knop
   "casts your HIGHEST known rank" (r.14). De knop staat aan tenzij de speler hem uitzet (`MissingBuff.lua` r.558: alleen
   `== false` zet hem uit). Voor groepsleden: `ForeverReadyBoard.lua` r.13-15 (klik om de buff te geven; volgens r.28
   NIET in het spel gemeten). De knop werkt alleen buiten gevecht; buffs zet je buiten gevecht. AFGELEID dat dit genoeg is.
   **Andere keuze (ook goed):** buffs houden op Shift-Z en Shift-X (zoals het oude blok) en Frost Ward en Fire Ward eruit.
   Dan hebben de wards geen andere weg, en die gebruik je wel in een gevecht. Daarom koos ik de buffs.
2. **De bouwchat moet iets doen met de vier namen** (Ice Armor, Frost Armor, Arcane Intellect, Arcane Brilliance).
   Ze staan niet in `toBlockD` en niet in `listed`. Gebruikt de motor `keys12`, dan noemt de rode regel "not in MH's list"
   ze. Oplossing: in `listed` zetten, of een eigen blok-D-lijst voor 12 x 4. Ik mocht `toBlockD` niet aanraken.
3. **Toets 1 = Fireball, terwijl de meeste spelers Frost levelen.** Een Frost-speler drukt dus vooral 2. Ik heb het
   oude, boom-neutrale blok gevolgd (Rob keurde het goed op 6 nov; kop van het bestand). Een lijst op toets 1 kan niet
   kiezen per boom zonder een andere spell te verbergen.
4. **Arcane Blast staat op Ctrl-2.** Voor een Arcane-speler is dat zijn hoofdspell, op een Ctrl-toets. Zo stond het ook
   in het oude blok. Geen betere vrije plek.
5. **Gedeelde cooldowns** (Fire Blast + Ice Lance, Frost Ward + Fire Ward) komen uit `ForeverHowToPlay.lua`, niet door
   mij in DB2 gemeten.
6. **Labels die niet passen:** Ctrl-Q heet "buff / cooldown" en heeft Remove Lesser Curse. Ctrl-1 t/m 4 heten
   "vorm/stance"; de Mage heeft geen vormen, dus daar staan spells (zoals in het oude blok).
7. **Downranks (alleen advies, de motor kan het niet):** een lage rank Frostbolt als goedkope vertrager was in de oude
   Classic gewoon. Voor Forever niet nagekeken (AFGELEID). Geen ander advies.
8. **Motor:** `keys12` wordt nog nergens gelezen (Grep 24 nov: alleen een commentaarregel, `KeyBlock.lua` r.68).
   Het nieuwe veld `why` komt in `ForeverBlockUnlisted` (`ForeverBlock.lua` r.560-569) in de lijst "listed" terecht, want
   die lus slaat alleen `open` en `bang` over. Dat kan geen kwaad (het is geen spellnaam), maar sla `why` daar netjes over.
9. **Vorm:** ik gebruik `base` zoals het oude bestand, niet `all` uit het voorbeeld van de coördinator. Zonder states
   doen ze hetzelfde (`ForeverBlock.lua` r.360-384, GEMETEN door lezen). `bang = true` alleen op Ctrl-3, zoals het oude blok.
10. **Niet gemeten in het spel:** niets van deze indeling. Rob test in het spel.

## Lua

```lua
keys12 = {
	["1"] = { base = "Fireball", why = "main fire nuke from level 1; the old block's key 1" },
	["2"] = { base = "Frostbolt", why = "main frost nuke; most guides level as Frost" },
	["3"] = { base = "Arcane Missiles", why = "arcane nuke; press it at once when Missile Barrage lights" },
	["4"] = { base = "Pyroblast", why = "spender: Fire's opener and Heating Up spender" },
	["Q"] = { base = { "Arcane Power", "Combustion" }, why = "your big damage cooldown (talent, 40)" },
	["E"] = { base = "Counterspell", why = "your interrupt: E is the kick key for every class" },
	["R"] = { base = "Blink", why = "your movement: R is the move key for every class" },
	["F"] = { base = "Ice Lance", why = "Frost: hit a Frozen enemy; shares a cooldown with Fire Blast" },
	["Z"] = { base = "Mana Shield", why = "small defensive" },
	["X"] = { base = "Ice Barrier", why = "second defensive: a shield that soaks damage (talent, 40)" },
	["C"] = { base = "Ice Block", why = "big defensive and emergency button; a Mage has no stun" },
	["V"] = { base = "Frost Nova", why = "crowd control: freezes the enemies around you" },
	["SHIFT-1"] = { base = "Blizzard", why = "AoE: hits several enemies" },
	["SHIFT-2"] = { base = "Arcane Explosion", why = "AoE around you" },
	["SHIFT-3"] = { base = "Fire Blast", why = "instant hit on an 8 s cooldown; also a finisher" },
	["SHIFT-4"] = { base = "Flamestrike", why = "fire AoE, under Pyroblast on 4" },
	["SHIFT-Q"] = { base = "Presence of Mind", why = "second cooldown: next cast instant; beside Arcane Power" },
	["SHIFT-E"] = { base = { "Blood Fury", "Berserking", "Eureka!", "Will of the Forsaken", "Will to Survive",
		"Read Leyline" }, why = "your race spell: Shift-E for every class" },
	["SHIFT-R"] = { base = "Slow Fall", why = "second movement: fall slowly" },
	["SHIFT-F"] = { base = "Cone of Cold", why = "crowd control 2: frost cone when the enemy is close" },
	["SHIFT-Z"] = { base = "Frost Ward", why = "second small defensive: a ward against frost" },
	["SHIFT-X"] = { base = "Fire Ward", why = "defensive: a ward against fire; shares a cooldown with Frost Ward" },
	["SHIFT-C"] = { base = "Cold Snap", why = "big defensive 2: resets your other Frost cooldowns" },
	["SHIFT-V"] = { base = "Polymorph", why = "crowd control 3: takes one enemy out of the fight" },
	["CTRL-1"] = { base = "Scorch", why = "no forms, so a spell: Fire's cast when the enemy is close" },
	["CTRL-2"] = { base = "Arcane Blast", why = "Arcane's talent nuke, as in the old block" },
	-- Same as the old block (Rob, 6 Nov 2026, "Doe maar" on 1B): wand until Frostfire Bolt is learned.
	["CTRL-3"] = { base = { "Frostfire Bolt", "Shoot" }, bang = true, why = "your wand until Frostfire Bolt (40) takes it" },
	["CTRL-4"] = { base = "Arcane Wrath", why = "Arcane talent hit; after Arcane Blast or Presence of Mind" },
	["CTRL-Q"] = { base = "Remove Lesser Curse", why = "helper: takes a curse off you or a friend" },
	["CTRL-E"] = { base = "Blast Wave", why = "cooldown: instant fire blast around you (Fire talent)" },
	["CTRL-R"] = { base = "Evocation", why = "recovery: gets your mana back" },
},
```
