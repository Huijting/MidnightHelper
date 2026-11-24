# KEYBLOCK12 — SHAMAN (voorstel, 24 nov 2026, mh-research)

De opdracht kwam als tekst van de coördinator. Niets in `docs/` gelezen. Bronnen: alleen `Modules/` (geen `_probe.py`,
geen web). GEMETEN = staat letterlijk in het genoemde bestand en de genoemde regel. AFGELEID = mijn redenering.

## Wat is anders dan het oude blok (`Modules/ForeverBlock_Shaman.lua`)

- Geen states: Ghost Wolf pagineert de balk niet (kopregels 10-11 van het oude bestand). Het oude blok had 33
  spell-toetsen, het rooster heeft er 31. Twee gaan er dus uit:
  - **Healing Stream Totem**: die plaats je vanaf level 20 via de totembalk.
  - **Purge**: alleen af en toe nodig.

  Zie twijfel 1.
- Verhuizingen:
  - Searing Totem (5) naar 4.
  - Frost Shock (4) naar Shift-V.
  - Mana Tide Totem (F1) naar Shift-Q.
  - Riptide (Shift-F1) naar Shift-X.
  - Lesser Healing Wave (F2) naar Shift-C.
  - Ancestral Spirit (F3) naar Ctrl-R.
  - Strength of Earth Totem (Shift-X) naar Ctrl-4.
  - Cure Poison (Shift-C) naar Ctrl-Q.
  - Cure Disease (Shift-V) naar Ctrl-E.
- Wat gelijk blijft: 1, 2, 3, Q, E, R, F, Z, X, C, V, Shift-1 t/m Shift-4, Shift-E, Shift-R, Shift-F, Shift-Z en
  Ctrl-1 t/m 3.

## Tabel

| Toets | Spell(s) | Waarom | Bron |
|---|---|---|---|
| 1 | Lightning Bolt | Hoofdknop. | GEMETEN: oud blok regel 23, ForeverHowToPlay.lua:333 |
| 2 | Flame Shock | Rotatie. | GEMETEN: oud blok regel 24, HowToPlay:844 |
| 3 | Stormstrike | Rotatie van Enhancement: "whenever it is ready". | GEMETEN: oud blok regel 25, HowToPlay:866 |
| 4 | **Searing Totem** | Een Shaman heeft geen spender of execute. De damage-totem zet je bij elke pull ("down before the pull"), dus hij hoort op balk A. | GEMETEN: oud 5 (regel 27), HowToPlay:842. Plek = AFGELEID |
| Q | Lightning Mastery / Rage of the Farseer | De grote cooldown van je talentboom. | GEMETEN: oud blok regel 31, HowToPlay:854, 877 |
| E | Earth Shock | De interrupt. | GEMETEN: oud blok regel 36, HowToPlay:336 |
| R | Ghost Wolf | Beweging. | GEMETEN: oud blok regel 37, HowToPlay:324 |
| F | Stoneclaw Totem | Een Shaman heeft geen taunt. Deze totem laat vijanden de totem aanvallen. | GEMETEN: oud blok regel 39, HowToPlay:339, 883 |
| Z | Stoneskin Totem | Kleine defensive: minder schade van melee-hits. | GEMETEN: oud blok regel 40, HowToPlay:337 |
| X | Grounding Totem | Tweede defensive: vangt één schadelijke spell op. | GEMETEN: oud blok regel 41, HowToPlay:351 |
| C | Healing Wave | C = grote defensive. Een Shaman heeft geen stun (alleen de race-spell War Stomp) en geen defensive-cooldown, dus de grote heal is zijn grote defensive. | GEMETEN: oud blok regel 42, HowToPlay:334. Keuze = AFGELEID |
| V | Earthbind Totem | Crowd control: vertraagt vijanden. | GEMETEN: oud blok regel 46, HowToPlay:338 |
| Shift-1 | Chain Lightning | AoE. | GEMETEN: oud blok regel 28, HowToPlay:846 |
| Shift-2 | Chain Heal | AoE-heal. Cast hem op je Riptide-doel. | GEMETEN: oud blok regel 29, HowToPlay:889, 903 |
| Shift-3 | Nature's Swiftness | Cooldown. Daarna Healing Wave, op C, er vlak onder. | GEMETEN: oud blok regel 33, HowToPlay:892 |
| Shift-4 | Fire Nova | AoE. Werkt alleen met een Fire-totem, en die staat nu op 4. Wat je na elkaar drukt, staat zo naast elkaar. | GEMETEN: oud blok regel 30, HowToPlay:356 |
| Shift-Q | **Mana Tide Totem** | Tweede cooldown: mana terug voor de groep. | GEMETEN: oud F1 (regel 32), HowToPlay:893, 897 |
| Shift-E | `all` Blood Fury / War Stomp / Berserking / Stoneform / Skysight | Race-spell. | GEMETEN: oud blok regel 52 |
| Shift-R | Totemic Call | Tweede beweging: "moves your totems to you". | GEMETEN: oud blok regel 38, HowToPlay:330 |
| Shift-F | Tremor Totem | Tweede controle-knop: haalt fear, charm en sleep weg. Een Shaman heeft geen tweede crowd control. | GEMETEN: oud blok regel 48, HowToPlay:349 |
| Shift-Z | Water Shield / Lightning Shield | Tweede kleine defensive: je shield. | GEMETEN: oud blok regel 43, HowToPlay:340, 360 |
| Shift-X | **Riptide** | Defensive voor de tank: een heal over 15 s. Daarna Chain Heal (Shift-2) op hetzelfde doel. | GEMETEN: oud Shift-F1 (regel 35), HowToPlay:888, 899 |
| Shift-C | **Lesser Healing Wave** | De snelle heal ("when it has to be fast"), als tweede van C naast Healing Wave. Beter bereikbaar dan de oude F2. | GEMETEN: oud F2 (regel 50), HowToPlay:891. Keuze = AFGELEID |
| Shift-V | **Frost Shock** | Derde controle-knop: hij vertraagt. Naast Earthbind (V), net als in "Earthbind Totem (V) or Frost Shock". | GEMETEN: oud 4 (regel 26), HowToPlay:350, 849 |
| Ctrl-1 | Call of the Elements | Totemset 1 (de "stance"-rij). | GEMETEN: oud blok regel 53, HowToPlay:329 |
| Ctrl-2 | Call of the Ancestors | Totemset 2. | GEMETEN: oud blok regel 54 |
| Ctrl-3 | Call of the Spirits | Totemset 3. | GEMETEN: oud blok regel 55 |
| Ctrl-4 | **Strength of Earth Totem** | Een vierde totemknop naast de drie sets. Vóór level 20 heb je hem los nodig, want dan is er nog geen totembalk. | GEMETEN: oud Shift-X (regel 44), HowToPlay:328-329. Plek = AFGELEID |
| Ctrl-Q | **Cure Poison** | Gif weghalen bij een vriend. | GEMETEN: oud Shift-C (regel 45), HowToPlay:905 |
| Ctrl-E | **Cure Disease** | Ziekte weghalen. | GEMETEN: oud Shift-V (regel 49), HowToPlay:905 |
| Ctrl-R | Ancestral Spirit | Herstel buiten gevecht: brengt een dode vriend terug. Shaman gebruikt geen `pair`, dus het is een gewone toets. | GEMETEN: oud F3 (regel 34), HowToPlay:349 |

Alle 37 namen staan letterlijk als sleutel in `Modules/ForeverSpellIds.lua`. GEMETEN: één Grep met alle 37 namen,
exact geankerd, gaf 37 treffers.

## Twijfels

1. **Twee spells van het oude blok passen niet.**
   - **Healing Stream Totem**: die leer je op level 20, uit een quest (HowToPlay:350). Op hetzelfde level krijg je de
     totembalk (HowToPlay:329), dus Call of the Elements kan hem plaatsen. Dat dit genoeg is voor een healer, is
     AFGELEID.
   - **Purge** (12): alleen af en toe nodig.

   Ik schrijf `toBlockD` niet opnieuw. De bouwer moet ze daar of in `listed` zetten, anders noemt de rode regel ze "not
   in MH's list". Alternatief: Purge op Ctrl-4 en Strength of Earth Totem naar blok D. Na level 20 plaats je Strength
   of Earth toch via de totembalk.
2. **4 = Searing Totem** in plaats van Frost Shock. Rotatie en "vaak drukken" gaan voor. Frost Shock deelt de
   shock-cooldown, dus hij is minder vaak vrij (HowToPlay:355). Dat is AFGELEID.
3. **E (Earth Shock), 2 (Flame Shock) en Shift-V (Frost Shock) delen één cooldown van 6 seconden** (HowToPlay:355).
   Na Flame Shock heb je dus even geen interrupt. Dat is geen plaatsingsfout, maar wel een fout die beginners maken.
4. **C = Healing Wave als "grote defensive"**: zelfde patroon als bij de Druid en de Paladin (C = grote heal,
   Shift-C = snelle heal).
5. **De dispels staan op Ctrl-Q en Ctrl-E.** Dat is minder goed bereikbaar dan de oude Shift-C en Shift-V. Die plekken
   gingen naar de snelle heal en Frost Shock. Voor een healer in een dungeon kan dit krap zijn. Dat is Robs keuze.
6. **Vijf aarde-totems op toetsen** (Z, F, V, Shift-F, Ctrl-4). Je kunt er maar één tegelijk hebben (HowToPlay:326).
   Na level 20 doen de Calls het meeste werk.
7. **Riptide (Shift-X) en Stormstrike (3) zijn talenten.** De toets blijft leeg tot je ze hebt. Voor Stormstrike
   zegt de DB2 level 40, de gidsen zeggen 25 (ForeverTalentNext.lua:45).
8. **Downranks** (regel 4, alleen advies; de motor kan het nu niet): een lage rank van Healing Wave als goedkope heal.
   Daar is nu geen plek voor.
9. **ForeverHowToPlay.lua noemt de oude toetsen** (5, 4 = Frost Shock, F1-F4, Shift-F1, Shift-X = Strength of Earth,
   Shift-C/V = dispels, Shift-Q = Purge; regels 321-360 en 838-905). Die teksten moeten mee als keys12 live gaat.
10. **Motor en `why`**: zie Druid, twijfel 9.

## keys12

```lua
	keys12 = {
		["1"] = { base = "Lightning Bolt", why = "main attack spell" },
		["2"] = { base = "Flame Shock", why = "rotation: fire damage, then more over time" },
		["3"] = { base = "Stormstrike", why = "rotation (Enhancement): press it whenever it is ready" },
		["4"] = { base = "Searing Totem", why = "your damage totem: put it down at every pull" },
		["Q"] = { base = { "Lightning Mastery", "Rage of the Farseer" }, why = "big cooldown of your talent tree" },
		["E"] = { base = "Earth Shock", why = "your interrupt: E is the kick key for every class" },
		["R"] = { base = "Ghost Wolf", why = "movement: run as a wolf" },
		["F"] = { base = "Stoneclaw Totem", why = "no taunt: enemies attack this totem instead" },
		["Z"] = { base = "Stoneskin Totem", why = "small defensive: less damage from melee hits" },
		["X"] = { base = "Grounding Totem", why = "second defensive: catches one harmful spell" },
		["C"] = { base = "Healing Wave", why = "big heal: your big defensive, you have no shield wall" },
		["V"] = { base = "Earthbind Totem", why = "crowd control: slows enemies near it" },
		["SHIFT-1"] = { base = "Chain Lightning", why = "AoE: hits several enemies" },
		["SHIFT-2"] = { base = "Chain Heal", why = "AoE heal: cast it on your Riptide target" },
		["SHIFT-3"] = { base = "Nature's Swiftness", why = "cooldown: next nature spell is instant, then Healing Wave (C)" },
		["SHIFT-4"] = { base = "Fire Nova", why = "AoE: needs a Fire totem down, like Searing Totem (4)" },
		["SHIFT-Q"] = { base = "Mana Tide Totem", why = "second cooldown: mana back for your group" },
		["SHIFT-E"] = { all = { "Blood Fury", "War Stomp", "Berserking", "Stoneform", "Skysight" }, why = "your race spell" },
		["SHIFT-R"] = { base = "Totemic Call", why = "second movement: moves your totems to you" },
		["SHIFT-F"] = { base = "Tremor Totem", why = "second control key: removes fear, charm and sleep" },
		["SHIFT-Z"] = { base = { "Water Shield", "Lightning Shield" }, why = "second small defensive: your shield" },
		["SHIFT-X"] = { base = "Riptide", why = "heal over time on the tank, then Chain Heal (Shift-2)" },
		["SHIFT-C"] = { base = "Lesser Healing Wave", why = "quick heal, next to Healing Wave on C" },
		["SHIFT-V"] = { base = "Frost Shock", why = "third control key: slows; shares the shock cooldown" },
		["CTRL-1"] = { base = "Call of the Elements", why = "totem set 1 from your totem bar" },
		["CTRL-2"] = { base = "Call of the Ancestors", why = "totem set 2 from your totem bar" },
		["CTRL-3"] = { base = "Call of the Spirits", why = "totem set 3 from your totem bar" },
		["CTRL-4"] = { base = "Strength of Earth Totem", why = "buff totem; before level 20 there is no totem bar" },
		["CTRL-Q"] = { base = "Cure Poison", why = "remove poison from a friend" },
		["CTRL-E"] = { base = "Cure Disease", why = "remove a disease from a friend" },
		["CTRL-R"] = { base = "Ancestral Spirit", why = "bring a dead friend back, outside a fight" },
	},
```
