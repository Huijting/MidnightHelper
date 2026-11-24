# Toetsenblok 12 x 4 — Priest (Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen: `Modules/ForeverBlock_Priest.lua` (oude blok), `ForeverBlock.lua`
(motor), `KeyBlock.lua` (rooster), `ForeverHowToPlay.lua`, `ForeverTalentNext.lua`, `ForeverSpellIds.lua`,
`ForeverTrainerData.lua`, `ForeverBuffs.lua`, `MissingBuff.lua`, `ForeverReadyBoard.lua`, `ForeverSmartBuff.lua`.
Niets in `docs/` gelezen behalve de opdracht zelf (`KEYBLOCK12_BRIEF.md`, gelezen voordat de coördinator de opdracht
als tekst stuurde). Geen ROLES-bestand gelezen.

## Kort

- Het oude blok had **33** plekken met een spell. 12 x 4 heeft er **31**. Er moeten twee weg.
- Eruit: de twee **buffs** Inner Fire en Power Word: Fortitude / Prayer of Fortitude. MH heeft al een knop die ze zet.
- **Healer:** Flash Heal staat op **Shift-C**, één toets van je gewone heal op C. Renew staat op **Shift-Z**, onder je
  schild op Z. Zo zitten de heals bij elkaar: Z schild, Shift-Z Renew, C heal, Shift-C snelle heal.
- De **wand** (Shoot) gaat van 5 naar **4**: bijna elke Priest gebruikt hem elk gevecht. Holy Fire gaat naar Ctrl-4.
- Elke naam gecontroleerd met Grep in `ForeverSpellIds.lua`: 50 van 50 namen gevonden (GEMETEN, 24 nov, één
  zoekopdracht met alle namen; elke naam gaf precies één regel).

## De tabel

"Oud blok" = `Modules/ForeverBlock_Priest.lua` regel 22-54 (GEMETEN, gelezen 24 nov). "HtP" = `ForeverHowToPlay.lua`
(tekst van 6-17 nov; volgens de kop nagekeken door mh-research tegen DB2 — een bewering in het bestand, niet door mij
opnieuw gemeten).

| Toets | Spell | Waarom | Herkomst |
|---|---|---|---|
| `1` | Mind Flay / Smite | Hoofdspell: Smite, en Mind Flay neemt het over als je dat talent hebt. | oud blok, zelfde toets; HtP r.313, r.316 |
| `2` | Shadow Word: Pain | Je DoT; eerst opzetten. | oud blok, zelfde toets; HtP r.680 |
| `3` | Mind Blast | Shadow-klap, cooldown 8 s. | oud blok, zelfde toets; HtP r.303 |
| `4` | Shoot (wand) | Spender/afmaker: "Finish with your wand". Shadow (de standaardboom) gebruikt hem veel. | was `5`; HtP r.676, r.683; standaard Shadow: `ForeverTalentNext.lua` r.39 (`PRIEST = 3`). Plek: AFGELEID |
| `Q` | Power Infusion | Grote cooldown (talent, 40). | oud blok, zelfde toets; HtP r.647 |
| `E` | Silence | Interrupt (talent, 30). E = kick bij elke klasse. | oud blok, zelfde toets; HtP r.318, r.688 |
| `R` | Levitate | De enige bewegingsspell. R = beweging bij elke klasse. | oud blok, zelfde toets |
| `F` | Fade | Hulpspell: vijanden willen je minder aanvallen. | oud blok, zelfde toets; HtP r.301 |
| `Z` | Power Word: Shield | Kleine defensive: schild op jou of een vriend. | oud blok, zelfde toets; HtP r.300 |
| `X` | race-spell B (lijst) | Tweede defensive: de eigen Priest-spell van je ras. Elk ras dezelfde toets. | oud blok, zelfde toets, zelfde lijst; HtP r.287-293 |
| `C` | Greater Heal / Heal / Lesser Heal | Je gewone heal = de grote defensive. Een Priest heeft geen stun. | oud blok, zelfde toets; HtP r.296 |
| `V` | Psychic Scream | Crowd control: vijanden om je heen rennen weg. | oud blok, zelfde toets; HtP r.310 |
| `SHIFT-1` | Holy Nova | AoE om je heen: raakt vijanden, healt je groep. | oud blok, zelfde toets; HtP r.666 |
| `SHIFT-2` | Prayer of Healing | AoE-heal voor een groep. | oud blok, zelfde toets; HtP r.640, r.672 |
| `SHIFT-3` | Devouring Plague | Tweede DoT, naast Mind Blast; healt jou ook. | oud blok, zelfde toets; HtP r.687 |
| `SHIFT-4` | Shadow Word: Death | Tweede afmaker, naast de wand: alleen als hij doodt. | oud blok, zelfde toets; HtP r.684, r.693 |
| `SHIFT-Q` | Penance | Tweede cooldown: heal of klap, elke 12 s (talent, 30). Naast Power Infusion (die heeft Penance nodig). | was `SHIFT-F1`; HtP r.637, r.646-647. Plek: AFGELEID |
| `SHIFT-E` | race-spell (lijst, `all`) | Race-spell. Shift-E bij elke klasse. | oud blok, zelfde toets, zelfde lijst en vorm |
| `SHIFT-R` | race-spell A (lijst) | De andere Priest-spell van je ras. Een Priest heeft geen tweede beweging. | oud blok, zelfde toets, zelfde lijst; HtP r.287 |
| `SHIFT-F` | Mind Control | Crowd control 2. | oud blok, zelfde toets |
| `SHIFT-Z` | Renew | Tweede kleine defensive: heal over tijd, onder je schild. | was `F4`; HtP r.302, r.636, r.657. Plek: AFGELEID |
| `SHIFT-X` | Dispel Magic | Defensive: haalt magie van een vriend. | was `SHIFT-V`. Plek: AFGELEID |
| `SHIFT-C` | Flash Heal | **Snelle heal**, één toets van je gewone heal (C). Voor als C te traag is. | was `F2`; HtP r.639, r.660, r.673. Plek: AFGELEID |
| `SHIFT-V` | Shackle Undead | Crowd control 3 (alleen Undead). Shift-Q is in 12 x 4 "tweede cooldown". | was `SHIFT-Q`; HtP r.319. Plek: AFGELEID |
| `CTRL-1` | Shadowform | Je vorm: dezelfde toets erin en eruit (regel 5). | oud blok, zelfde toets; HtP r.315 |
| `CTRL-2` | Prayer of Mending | Holy-talent. | oud blok, zelfde toets; HtP r.668 |
| `CTRL-3` | Vampiric Embrace | Shadow-talent. | oud blok, zelfde toets; HtP r.687 |
| `CTRL-4` | Holy Fire | Opener voor Discipline alleen. Zelfde fysieke toets als de wand (4). | was `4`; HtP r.642. Plek: AFGELEID |
| `CTRL-Q` | Inner Focus | Buff / cooldown: je volgende spell kost geen mana. | was `F1`; HtP r.641, r.645 |
| `CTRL-E` | Abolish Disease / Cure Disease | Hulpspell: haalt een ziekte weg. | was `SHIFT-C`. Plek: AFGELEID (geen betere vrije plek) |
| `CTRL-R` | Resurrection | Buiten gevecht: brengt een dode vriend terug. | was `F3`; HtP r.304 |
| `CTRL-F` t/m `CTRL-V` | — | Vaste items van MH. Geen spell. | opdracht |

**Niet meer op het blok:** Inner Fire (was `SHIFT-Z`) en Prayer of Fortitude / Power Word: Fortitude (was `SHIFT-X`).

## Wat er verandert voor de speler (voor How you play)

Verhuisd: Shoot 5 → 4 · Holy Fire 4 → Ctrl-4 · Inner Focus F1 → Ctrl-Q · Penance Shift-F1 → Shift-Q ·
Shackle Undead Shift-Q → Shift-V · Dispel Magic Shift-V → Shift-X · Cure/Abolish Disease Shift-C → Ctrl-E ·
Flash Heal F2 → Shift-C · Renew F4 → Shift-Z · Resurrection F3 → Ctrl-R · Inner Fire en Fortitude: niet meer op het blok.
Alle andere toetsen blijven gelijk. De tekst in `ForeverHowToPlay.lua` (r.283-319 en r.632-695) noemt de oude toetsen.
Ook de algemene regel r.33 ("T = potion, Shift-T = healthstone, G = trinket") klopt niet voor 12 x 4.

## Twijfels en wat ik niet kon meten

1. **Welke twee eruit.** Ik koos de twee buffs. GEMETEN in de code (24 nov): `ForeverBuffs.lua` r.34-37 zet voor de
   Priest Power Word: Fortitude (Prayer of Fortitude telt mee) en Inner Fire op de buff-knop; die knop cast je hoogste
   rank (r.14) en staat aan tenzij de speler hem uitzet (`MissingBuff.lua` r.558). Voor anderen: `ForeverReadyBoard.lua`
   r.13-15 (klik om de buff te geven; volgens r.28 NIET in het spel gemeten) en de Smart Buff-macro
   (`ForeverSmartBuff.lua`, staat standaard UIT). AFGELEID dat dit genoeg is.
   **Andere keuze:** buffs houden en Shackle Undead (alleen tegen Undead) plus Holy Fire (alleen Discipline alleen)
   eruit. Dan zijn twee in-gevecht-spells weg; daarom koos ik de buffs.
2. **De bouwchat moet iets doen met de drie namen** (Inner Fire, Power Word: Fortitude, Prayer of Fortitude). Ze staan
   niet in `toBlockD`, en het Priest-bestand heeft geen `listed`. Gebruikt de motor `keys12`, dan noemt de rode regel
   "not in MH's list" ze. Oplossing: een `listed` maken, of een eigen blok-D-lijst voor 12 x 4.
3. **Snelle heal op Shift-C, niet op balk A.** Balk A is vol met dingen die elke Priest elk gevecht drukt. Wil Rob
   Flash Heal toch op balk A voor healers: ruil hem met Fade (F). Dan zit Fade op Shift-C. Mijn advies: zo laten, want
   C en Shift-C is dezelfde vinger.
4. **Wand op 4 zonder `bang`.** Het Priest-bestand gebruikt `bang` niet, en de opdracht zegt: alleen vormen die het
   bestand al heeft. Dus: nog eens op 4 drukken zet de wand misschien uit. Zo was het ook met 5 in het oude blok
   (AFGELEID, niet gemeten). De motor kan `bang = true` wel (`ForeverBlock.lua` r.334-340); de Mage heeft het op Ctrl-3.
   Dat is een keuze voor de bouwchat.
5. **Labels die niet passen:** Shift-R heet "tweede beweging" maar heeft de race-spell (zoals het oude blok; een Priest
   heeft maar één bewegingsspell). Ctrl-E heet "cooldown" maar heeft Cure/Abolish Disease. Ctrl-4 heet "vorm/stance 4";
   de Priest heeft alleen Shadowform (Ctrl-1).
6. **Race-spells:** wat Chastise, Confounding Flash en de andere precies doen, heb ik niet gemeten. Ik volg het oude blok.
7. **Downranks (alleen advies, de motor kan het niet):** een lagere rank van Heal of Greater Heal om mana te sparen was
   in de oude Classic gewoon. Voor Forever niet nagekeken (AFGELEID).
8. **Motor:** `keys12` wordt nog nergens gelezen (Grep 24 nov: alleen een commentaarregel, `KeyBlock.lua` r.68).
   Het veld `why` komt in `ForeverBlockUnlisted` (`ForeverBlock.lua` r.560-569) in "listed" terecht, want die lus slaat
   alleen `open` en `bang` over. Kan geen kwaad, maar sla `why` daar netjes over.
9. **Vorm:** `base` zoals het oude bestand; alleen Shift-E gebruikt `all`, precies zoals het oude blok.
10. **Niet gemeten in het spel:** niets van deze indeling. Rob test in het spel.

## Lua

```lua
keys12 = {
	["1"] = { base = { "Mind Flay", "Smite" }, why = "main attack: Smite, then Mind Flay once you have it" },
	["2"] = { base = "Shadow Word: Pain", why = "your damage over time; put it on first" },
	["3"] = { base = "Mind Blast", why = "shadow hit on an 8 s cooldown" },
	["4"] = { base = "Shoot", why = "your wand: finish the enemy with it and save mana" },
	["Q"] = { base = "Power Infusion", why = "big cooldown: more spell damage and healing (talent)" },
	["E"] = { base = "Silence", why = "your interrupt (talent, 30): E is the kick key for every class" },
	["R"] = { base = "Levitate", why = "your movement spell: R is the move key for every class" },
	["F"] = { base = "Fade", why = "helper: enemies want to attack you less for a while" },
	["Z"] = { base = "Power Word: Shield", why = "small defensive: a shield on you or a friend" },
	["X"] = { base = { "Desperate Prayer", "Elune's Grace", "Feedback", "Shadowguard", "Touch of Weakness",
		"Contingency Plan" }, why = "your race's own priest spell; the same key for every race" },
	["C"] = { base = { "Greater Heal", "Heal", "Lesser Heal" }, why = "your main heal; a bigger one takes over when learned" },
	["V"] = { base = "Psychic Scream", why = "crowd control: enemies around you run away" },
	["SHIFT-1"] = { base = "Holy Nova", why = "AoE around you: hurts enemies, heals your group" },
	["SHIFT-2"] = { base = "Prayer of Healing", why = "AoE heal for a group" },
	["SHIFT-3"] = { base = "Devouring Plague", why = "second DoT, beside Mind Blast; it also heals you" },
	["SHIFT-4"] = { base = "Shadow Word: Death", why = "finisher beside the wand: only when it will kill" },
	["SHIFT-Q"] = { base = "Penance", why = "second cooldown: heal or hit every 12 s (talent)" },
	["SHIFT-E"] = { all = { "Will of the Forsaken", "Stoneform", "Shadowmeld", "Escape Artist", "Berserking",
		"Will to Survive" }, why = "your race spell: Shift-E for every class" },
	["SHIFT-R"] = { base = { "Starshards", "Chastise", "Divine Grace", "Hex of Weakness", "Dark Sacrifice",
		"Confounding Flash" }, why = "your race's other priest spell; no second movement spell" },
	["SHIFT-F"] = { base = "Mind Control", why = "crowd control 2" },
	["SHIFT-Z"] = { base = "Renew", why = "second small defensive: a heal over time, under Shield" },
	["SHIFT-X"] = { base = "Dispel Magic", why = "defensive: takes magic off a friend" },
	["SHIFT-C"] = { base = "Flash Heal", why = "quick heal: one key from your main heal on C" },
	["SHIFT-V"] = { base = "Shackle Undead", why = "crowd control 3: holds one Undead enemy" },
	["CTRL-1"] = { base = "Shadowform", why = "your form: press again to leave it, so you can heal" },
	["CTRL-2"] = { base = "Prayer of Mending", why = "Holy talent: a heal that jumps on" },
	["CTRL-3"] = { base = "Vampiric Embrace", why = "Shadow talent: your damage heals your group" },
	["CTRL-4"] = { base = "Holy Fire", why = "opener when Discipline plays alone; Ctrl on the wand key" },
	["CTRL-Q"] = { base = "Inner Focus", why = "cooldown: your next spell costs no mana" },
	["CTRL-E"] = { base = { "Abolish Disease", "Cure Disease" }, why = "helper: takes a disease off you or a friend" },
	["CTRL-R"] = { base = "Resurrection", why = "out of combat: brings a dead friend back" },
},
```
