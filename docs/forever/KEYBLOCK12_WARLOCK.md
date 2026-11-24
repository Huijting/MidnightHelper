# Toetsenblok 12 x 4 — Warlock (Forever)

Gemaakt 24 nov 2026 door mh-research. Alleen gelezen: `Modules/ForeverBlock_Warlock.lua` (oude blok), `ForeverBlock.lua`
(motor), `KeyBlock.lua` (rooster), `ForeverHowToPlay.lua`, `ForeverTalentNext.lua`, `ForeverSpellIds.lua`,
`ForeverTrainerData.lua`, `ForeverBuffs.lua`, `MissingBuff.lua`. Niets in `docs/` gelezen behalve de opdracht zelf
(`KEYBLOCK12_BRIEF.md`, gelezen voordat de coördinator de opdracht als tekst stuurde). Geen ROLES-bestand gelezen.

## Kort

- Het oude blok had **32** gevulde plekken (29 spells + 3 pet-commando's); E was leeg. 12 x 4 heeft **31** plekken.
  **E blijft leeg** (geen eigen interrupt), dus er zijn er 30 te vullen. Er moeten twee weg.
- Eruit: **Demon Armor / Demon Skin** (MH's buff-knop zet hem al) en **Unending Breath** (zelden nodig, buiten gevecht;
  net als Curse of Tongues, dat Rob op 6 nov al van het blok haalde).
- De **pet-commando's** blijven precies zo: Ctrl-1 aanvallen, Ctrl-2 volgen, Ctrl-3 blijven, in de `cmd`-vorm met `PET`.
- **Bane of Agony** (was 5) krijgt Shift-2, naast Corruption op 2: de DoTs zitten bij elkaar (2, Shift-2, 3, Shift-3).
- Elke naam gecontroleerd met Grep in `ForeverSpellIds.lua`: 37 van 37 namen gevonden (GEMETEN, 24 nov, één
  zoekopdracht met alle namen, ook de vijf Summon-namen van `PET`; elke naam gaf precies één regel).

## De tabel

"Oud blok" = `Modules/ForeverBlock_Warlock.lua` regel 26-60 (GEMETEN, gelezen 24 nov). "HtP" = `ForeverHowToPlay.lua`
(tekst van 6-17 nov; volgens de kop nagekeken door mh-research tegen DB2 — een bewering in het bestand, niet door mij
opnieuw gemeten).

| Toets | Spell | Waarom | Herkomst |
|---|---|---|---|
| `1` | Shadow Bolt | Hoofdspell; instant als Shadow Trance oplicht. | oud blok, zelfde toets; HtP r.375, r.919 |
| `2` | Corruption | Je eerste DoT. | oud blok, zelfde toets; HtP r.378 |
| `3` | Immolate | Vuur, daarna schade over tijd. | oud blok, zelfde toets; HtP r.376 |
| `4` | Drain Soul | Afmaker: dood ermee en je krijgt een Soul Shard. | oud blok, zelfde toets; HtP r.383 |
| `Q` | Soul Fire | Grote cooldown: je grootste klap (48, kost een shard, cooldown 1 min). | oud blok, zelfde toets; HtP r.395 |
| `E` | — (leeg) | Geen eigen interrupt; alleen de Felhunter heeft er een (Spell Lock, op Blizzards pet-balk). | oud blok (bewust leeg); HtP r.373, r.399 |
| `R` | Curse of Exhaustion | Vertraagt de vijand, zodat je afstand houdt (talent, 25). Er is geen echte bewegingsspell. | oud blok, zelfde toets; HtP r.396, r.926 |
| `F` | Life Tap | Hulpspell: leven wordt mana. | oud blok, zelfde toets; HtP r.380 |
| `Z` | Shadow Ward | Kleine defensive: vangt shadow-schade op. | oud blok, zelfde toets; HtP r.393 |
| `X` | Death Coil | Tweede defensive: horror op de vijand en een heal. Noodknop op balk A. | oud blok, zelfde toets; HtP r.394 |
| `C` | Drain Life | Grote defensive: je eigen heal. Een Warlock heeft geen stun. | oud blok, zelfde toets; HtP r.389 |
| `V` | Fear | Crowd control. | oud blok, zelfde toets; HtP r.382 |
| `SHIFT-1` | Rain of Fire | AoE. | oud blok, zelfde toets; HtP r.392 |
| `SHIFT-2` | Bane of Agony | Tweede DoT, naast Corruption op 2. Elke Warlock zet hem elk gevecht. | was `5`; HtP r.387, r.913. Plek: AFGELEID |
| `SHIFT-3` | Curse of the Elements / Curse of Weakness | Je curse, naast Immolate op 3. | was `SHIFT-V`; HtP r.379, r.392. Plek: AFGELEID |
| `SHIFT-4` | Shadowburn | Tweede afmaker, naast Drain Soul: shard terug als hij doodt (talent). | oud blok, zelfde toets; HtP r.971 |
| `SHIFT-Q` | Amplify Curse | Tweede cooldown: je volgende curse of bane 50% sterker (3 min). | was `SHIFT-3`; HtP r.926. Plek: AFGELEID |
| `SHIFT-E` | race-spell (lijst) | Race-spell. Shift-E bij elke klasse. | oud blok, zelfde toets, zelfde lijst |
| `SHIFT-R` | Hellfire | Geen tweede beweging. Hellfire (AoE, 30) is het vaakst gebruikte van wat over is. | was `SHIFT-2`; HtP r.393, r.968. Plek: AFGELEID |
| `SHIFT-F` | Howl of Terror | Crowd control 2: fear op meer vijanden. | oud blok, zelfde toets; HtP r.394 |
| `SHIFT-Z` | Siphon Life | Tweede kleine defensive: een DoT die jou healt (talent, 30). | was `F4`; HtP r.396, r.927. Plek: AFGELEID |
| `SHIFT-X` | Soul Link | Defensive: 30% van de schade op jou gaat naar je demon (talent). | oud blok, zelfde toets; HtP r.950 |
| `SHIFT-C` | Demonic Sacrifice | Je demon opofferen voor een buff van 2 uur (talent). | oud blok, zelfde toets; HtP r.949 |
| `SHIFT-V` | Banish | Crowd control 3: alleen demonen en elementals. Shift-Q is in 12 x 4 "tweede cooldown". | was `SHIFT-Q`; HtP r.401. Plek: AFGELEID |
| `CTRL-1` | `/petattack` (cmd) | Pet: val mijn doel aan. | oud blok, zelfde toets, zelfde vorm; HtP r.372 |
| `CTRL-2` | `/petfollow` (cmd) | Pet: volg mij. | oud blok, zelfde toets, zelfde vorm |
| `CTRL-3` | `/petstay` (cmd) | Pet: blijf staan. | oud blok, zelfde toets, zelfde vorm |
| `CTRL-4` | Bane of Doom | Geen vorm 4. Grote klap na 60 s; pas op 60, voor lange gevechten. | was `F1`; HtP r.930. Plek: AFGELEID |
| `CTRL-Q` | Fel Domination | Cooldown: je volgende summon gaat snel (talent). | was `SHIFT-F1`; oude taak "CD2B" = nieuwe taak van Ctrl-Q (`KeyBlock.lua` r.59 en r.90, GEMETEN); HtP r.949 |
| `CTRL-E` | Inferno | Cooldown: roept een Infernal op (Infernal Stone, 1 uur). | was `F3`; oude taak "CD4" = nieuwe taak van Ctrl-E (`KeyBlock.lua` r.58 en r.90, GEMETEN); HtP r.370 |
| `CTRL-R` | Health Funnel | Herstel: healt je demon met je eigen leven. | was `F2`; HtP r.400, r.943. Plek: AFGELEID |
| `CTRL-F` t/m `CTRL-V` | — | Vaste items van MH. Geen spell. | opdracht |

**Niet meer op het blok:** Demon Armor / Demon Skin (was `SHIFT-Z`) en Unending Breath (was `SHIFT-R`).

## Wat er verandert voor de speler (voor How you play)

Verhuisd: Bane of Agony 5 → Shift-2 · Hellfire Shift-2 → Shift-R · curse Shift-V → Shift-3 · Amplify Curse Shift-3 →
Shift-Q · Banish Shift-Q → Shift-V · Siphon Life F4 → Shift-Z · Bane of Doom F1 → Ctrl-4 · Fel Domination Shift-F1 →
Ctrl-Q · Inferno F3 → Ctrl-E · Health Funnel F2 → Ctrl-R · Demon Armor/Skin en Unending Breath: niet meer op het blok.
Alle andere toetsen blijven gelijk; E blijft leeg. De tekst in `ForeverHowToPlay.lua` (r.363-403 en r.909-979) noemt de
oude toetsen. Ook de algemene regel r.33 ("T = potion, Shift-T = healthstone, G = trinket") klopt niet voor 12 x 4.

## Twijfels en wat ik niet kon meten

1. **Welke twee eruit.** Demon Armor / Demon Skin: GEMETEN in de code (24 nov), `ForeverBuffs.lua` r.46-48 zet die
   keuze op de buff-knop; die cast je hoogste rank (r.14) en staat aan tenzij de speler hem uitzet (`MissingBuff.lua`
   r.558). Unending Breath: geen andere weg in MH; je cast hem buiten gevecht, dus uit het spellboek kan ook. Dat Rob
   zelden gebruikte spells al eerder naar `listed` zette: `ForeverBlock_Warlock.lua` r.62-63 (GEMETEN).
   **Andere keuze:** Unending Breath houden op Shift-R (past beter bij "tweede beweging") en Bane of Doom eruit. Bane of
   Doom komt pas op 60 en is alleen voor lange gevechten. Ik koos ervoor de gevecht-spell te houden.
2. **De bouwchat moet iets doen met de drie namen** (Demon Armor, Demon Skin, Unending Breath). Ze staan niet in
   `toBlockD` en niet in `listed`. Gebruikt de motor `keys12`, dan noemt de rode regel "not in MH's list" ze. Oplossing:
   in `listed` zetten (daar staan al Shoot, Curse of Tongues en Ritual of Summoning), of een blok-D-lijst voor 12 x 4.
3. **E blijft leeg.** Spell Lock via een `cmd`-regel kan niet goed: "Spell Lock" staat niet in `ForeverSpellIds.lua`
   of `ForeverTrainerData.lua` (GEMETEN 24 nov met Grep: 0 treffers; dezelfde zoekopdracht vond "Shadow Bolt" 1 en 8
   keer als positieve controle), en een vaste Engelse tekst werkt niet op een
   Duitse of Franse client (de motor vertaalt alleen namen, niet `cmd`-tekst; `ForeverBlock.lua` r.326-333). Death Coil
   of Fear op E zou een speler laten denken dat E een interrupt is. Daarom leeg, zoals het oude blok. Een lege toets heeft
   geen regel, dus ook geen `why`; de uitleg staat als commentaar in het blok.
4. **Labels die niet passen:** Shift-R ("tweede beweging") heeft Hellfire; Ctrl-4 ("vorm/stance 4") heeft Bane of Doom.
   Een Warlock heeft geen tweede bewegingsspell en geen vormen. Ook R (Curse of Exhaustion) is geen echte beweging; zo
   stond het in het oude blok.
5. **Destruction blijft zwak bediend.** Conflagrate, Incinerate, Bane of Havoc, Wrack en Searing Pain staan in
   `toBlockD` (oud blok, 6 nov), en die lijst mocht ik niet veranderen. Idee voor later (AFGELEID, niet gemeten):
   Wrack en Incinerate zijn allebei 31-punt-talenten in verschillende bomen, dus nooit samen; die kunnen één toets delen
   als `toBlockD` ooit voor 12 x 4 wordt herschreven.
6. **Pet-commando's:** precies de oude `cmd`-regels, met dezelfde `needs = PET` (de lokale lijst bovenaan het bestand,
   r.21; `keys12` staat in hetzelfde bestand, dus `PET` is daar bekend). Dat `/petattack` enz. in Forever werken: zegt
   het oude bestand zelf AFGELEID (`ForeverBlock.lua` r.323-325); niet door mij gemeten.
7. **Downranks:** geen advies; niets gemeten.
8. **Motor:** `keys12` wordt nog nergens gelezen (Grep 24 nov: alleen een commentaarregel, `KeyBlock.lua` r.68).
   Het veld `why` komt in `ForeverBlockUnlisted` (`ForeverBlock.lua` r.560-569) in "listed" terecht, want die lus slaat
   alleen `open` en `bang` over. Kan geen kwaad, maar sla `why` daar netjes over. Bij `cmd` gaat dat al goed (r.565).
9. **Vorm:** `base` zoals het oude bestand, niet `all` uit het voorbeeld van de coördinator. Zonder states doen ze
   hetzelfde (`ForeverBlock.lua` r.360-384, GEMETEN door lezen).
10. **Niet gemeten in het spel:** niets van deze indeling. Rob test in het spel.

## Lua

```lua
keys12 = {
	["1"] = { base = "Shadow Bolt", why = "main attack spell; instant when Shadow Trance lights up" },
	["2"] = { base = "Corruption", why = "your first damage over time" },
	["3"] = { base = "Immolate", why = "fire damage, then more damage over time" },
	["4"] = { base = "Drain Soul", why = "finisher: kill with it and you get a Soul Shard" },
	["Q"] = { base = "Soul Fire", why = "big cooldown: your biggest hit (48, costs a Soul Shard)" },
	-- E stays empty on purpose: no interrupt of its own (Spell Lock belongs to the Felhunter, on Blizzard's pet bar).
	["R"] = { base = "Curse of Exhaustion", why = "slows the enemy so you can stay away from it (talent)" },
	["F"] = { base = "Life Tap", why = "helper: turns health into mana" },
	["Z"] = { base = "Shadow Ward", why = "small defensive: soaks up shadow damage" },
	["X"] = { base = "Death Coil", why = "second defensive: a horror on the enemy and a heal" },
	["C"] = { base = "Drain Life", why = "big defensive: your own heal; a Warlock has no stun" },
	["V"] = { base = "Fear", why = "crowd control: takes one enemy out for a while" },
	["SHIFT-1"] = { base = "Rain of Fire", why = "AoE: hits several enemies" },
	["SHIFT-2"] = { base = "Bane of Agony", why = "second DoT, under Corruption on 2" },
	["SHIFT-3"] = { base = { "Curse of the Elements", "Curse of Weakness" }, why = "your curse, under Immolate on 3" },
	["SHIFT-4"] = { base = "Shadowburn", why = "second finisher: the shard comes back if it kills (talent)" },
	["SHIFT-Q"] = { base = "Amplify Curse", why = "second cooldown: next curse or bane 50% stronger (talent)" },
	["SHIFT-E"] = { base = { "Will to Survive", "Blood Fury", "Will of the Forsaken", "Escape Artist", "Berserking" },
		why = "your race spell: Shift-E for every class" },
	["SHIFT-R"] = { base = "Hellfire", why = "no second movement spell: AoE that also costs you health" },
	["SHIFT-F"] = { base = "Howl of Terror", why = "crowd control 2: fears several enemies" },
	["SHIFT-Z"] = { base = "Siphon Life", why = "second small defensive: a DoT that heals you (talent)" },
	["SHIFT-X"] = { base = "Soul Link", why = "defensive: part of the damage on you goes to your demon" },
	["SHIFT-C"] = { base = "Demonic Sacrifice", why = "trade your demon for a 2-hour buff (talent)" },
	["SHIFT-V"] = { base = "Banish", why = "crowd control 3: demons and elementals only" },
	-- Same as the old block (Rob, 6 Nov 2026, "Doe maar"): Ctrl-1/2/3 are the demon's keys, in Blizzard's pet-bar order.
	["CTRL-1"] = { cmd = { text = "/petattack", needs = PET, label = "Pet: Attack", icon = "Ability_GhoulFrenzy" },
		why = "pet: attack your target" },
	["CTRL-2"] = { cmd = { text = "/petfollow", needs = PET, label = "Pet: Follow", icon = "Ability_Tracking" },
		why = "pet: follow you" },
	["CTRL-3"] = { cmd = { text = "/petstay", needs = PET, label = "Pet: Stay", icon = "Spell_Nature_TimeStop" },
		why = "pet: stay where it is" },
	["CTRL-4"] = { base = "Bane of Doom", why = "no form 4: a big hit after 60 s (level 60, long fights)" },
	["CTRL-Q"] = { base = "Fel Domination", why = "cooldown: your next summon is fast and cheap (talent)" },
	["CTRL-E"] = { base = "Inferno", why = "cooldown: calls an Infernal (needs an Infernal Stone)" },
	["CTRL-R"] = { base = "Health Funnel", why = "recovery: heals your demon with your own health" },
},
```
