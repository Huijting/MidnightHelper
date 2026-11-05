# Voorstel — toetsenblok voor de Forever-Druid (5 nov 2026)

Rob: *"Eigen Forever-lijst"* → *"Ja, bouwen"* → *"Macro per toets"*. **Nog niets gebouwd.** Dit is het voorstel per toets
dat Rob eerst goedkeurt.

Bronnen: de vaste taken van het blok (`Modules/KeyBlock.lua` BLOCK, regels 22-59), de spell-lijst
`docs/FOREVER_DRUID_SPELLS_2026-11-05.md` (wago DB2 `wowf` 1.60.1.70790), Robs meting (`/mh spellbook`, level 7).

## Hoe het werkt

- Het blok blijft op balk 5, 6 en 7, met dezelfde toetsen als bij Robs andere characters.
- Een toets die per vorm iets anders doet, wordt **één macro**: *beer → …, kat → …, anders → …*.
- Een macro noemt de spell bij naam. Dan kiest het spel waarschijnlijk zelf de hoogste rank (AFGELEID; test hieronder).
- Een spell die je nog niet hebt, laat MH weg uit de macro. Een toets met nog niets erop blijft leeg, maar houdt zijn plek
  (regel 3). Na een level-up maakt *Update* de macro's opnieuw.
- `(T)` = talent-spell: krijgt zijn plek, ook als je het talent niet kiest (regel 4).

## Per toets (caster / beer / kat, met het level waarop je hem krijgt)

| toets | taak | caster | beer | kat |
|---|---|---|---|---|
| 1 | hoofdknop | Wrath (1) | Maul (10) | Claw (20) |
| 2 | rotatie | Moonfire (4) | Lacerate (T, 25) | Rake (24) |
| 3 | rotatie | Starfire (20) | Primal Bite (T, 40) | Shred (20) |
| 4 | spender | Insect Swarm (T, 25) | — | Rip (20) |
| Shift-4 | 2e spender | — | — | Ferocious Bite (24) |
| 5 | rotatie | Faerie Fire (18) | Faerie Fire | Faerie Fire |
| Shift-1 | AoE | Hurricane (40) | Swipe (16) | — |
| Shift-2 | AoE | Wild Growth (T, 40) | Demoralizing Roar (10) | — |
| Q | grote cooldown | Tranquility (30) | Enrage (12) | Shifting Power (T, 40) |
| F1 | cooldown 2 | Innervate (40) | | |
| Shift-3 | cooldown 3 | Nature's Swiftness (T, 30) | | |
| Shift-F1 | cooldown 2b | Swiftmend (T, 25) | | |
| F3 | cooldown 4 | in gevecht Rebirth (20), anders Revive (12) | | |
| E | onderbreken | — | Feral Charge (T, 20) | Feral Charge |
| V | CC | Entangling Roots (8) | Bash (14) | Pounce (36) |
| Shift-Q | CC 2 | Hibernate (18) | | |
| Shift-F | CC 3 | Soothe Animal (22) | Challenging Roar (28) | |
| Shift-V | dispel | Remove Curse (24) | | |
| Shift-C | dispel 2 | Abolish Poison (26), daarvoor Cure Poison (14) | | |
| R | bewegen | zwemmend Aquatic Form (16), anders Travel Form (30) | idem | Dash (26) |
| Shift-R | bewegen 2 | — | — | Prowl (20) |
| F | taunt | — | Growl (10) | Cower (28) |
| Z | kleine defensive | Barkskin (44) | Barkskin | Barkskin |
| X | defensive 2 | Nature's Grasp (10) | Frenzied Regeneration (36) | — |
| C | grote heal / defensive | Healing Touch (1) | | |
| F2 | snelle heal | Regrowth (12) | | |
| F4 | heal over tijd | Rejuvenation (4) | | |
| Shift-Z | buff | Thorns (6) | | |
| Shift-X | buff | Mark of the Wild (1); Gift of the Wild (50, boek) | | |
| Shift-E | racial | Shadowmeld | | |
| Ctrl-1 | vorm 1 | Bear Form (10) → Dire Bear Form (40) | | |
| Ctrl-2 | vorm 2 | Cat Form (20) | | |
| Ctrl-3 | vorm 3 | Moonkin Form (T, 40) | | |
| T / Shift-T / G | vast | drankje / healthstone / trinket (zoals altijd) | | |

Niet in het blok (naar blok D, Robs eigen plek): Teleport: Moonglade, Track Humanoids, Ravage, Elune's Light.

## Wat nog niet zeker is

- **Hoogste rank via de naam** (AFGELEID). Test nu, op level 7:
  `/run print(C_Spell.GetSpellInfo("Wrath").spellID)` → hoort **5177** te geven (Rank 2), niet 5176.
- **Hoe de macro de vorm herkent** (AFGELEID): het plan is `[bonusbar:3]` = beer en `[bonusbar:1]` = kat, net als de
  balkpagina's in Robs meting (vakjes 97 en 73). Te testen op level 10 (beer) en 20 (kat).
- **Heals in een vorm.** In het oude spel werkt een caster-spell niet zolang je beer of kat bent; je moet eerst uit je
  vorm (AFGELEID, niet gemeten in Forever). Daarom staan de heals alleen in de caster-kolom.
- **Macro-ruimte.** Ongeveer 30 macro's per character als alles er is. Of Forever zoveel plekken heeft: niet gemeten.
- **Shifting Power en Primal Bite**: wat ze precies doen, is niet uitgezocht. Hun plek is een gok op naam (AFGELEID).
