# Toetsenblok "12 × 4" voor Forever — opdracht voor de helpers (24 nov 2026)

Rob (via Sparring 24-11), letterlijk: *"ik vind namelijk zijn uitleg goed en wil onze versie ook zo hebben van keybinds
qua knoppen"* (Bellular-video over Forever-keybinds) en op het voorstel: *"uiteraard volg ik je advies e laat een agent
uitzoeken welke spells logisch zijn per class zodat dat automatisch kan worden toegepast ipv dat ik ga gokken met
dingen die ik nooit gespeeld heb"*. Gekozen: alleen Forever, een schakelaar (oud blok blijft standaard), en het
onderzoek bepaalt de indeling (Rob keurt niet per klasse goed; hij test in het spel).

## Het rooster (vast, voor elke klasse hetzelfde)

Dezelfde 12 toetsen op 4 balken: **1 2 3 4 / Q E R F / Z X C V**. Balk A = geen modifier, B = Shift, C = Ctrl,
D = Alt (de eigen balk van de speler; MH zet daar niets neer, met Alt-G in plaats van Alt-Z omdat Alt-Z Blizzards
toets is om de interface te verbergen).

| plek | taak (label op het plaatje) | plek | taak | plek | taak |
|---|---|---|---|---|---|
| `1` | hoofdknop | `SHIFT-1` | AoE / tweede van 1 | `CTRL-1` | vorm/stance/pet 1 |
| `2` | rotatie | `SHIFT-2` | AoE / tweede van 2 | `CTRL-2` | vorm/stance/pet 2 |
| `3` | rotatie | `SHIFT-3` | cooldown / tweede van 3 | `CTRL-3` | vorm/stance/pet 3 |
| `4` | spender / execute | `SHIFT-4` | AoE-spender / tweede van 4 | `CTRL-4` | vorm/stance 4 |
| `Q` | grote cooldown | `SHIFT-Q` | tweede cooldown | `CTRL-Q` | buff / cooldown |
| `E` | **interrupt (kick)** | `SHIFT-E` | race-spell | `CTRL-E` | cooldown |
| `R` | **beweging** (charge, sprint, blink) | `SHIFT-R` | tweede beweging | `CTRL-R` | herstel buiten gevecht |
| `F` | taunt / hulpspell | `SHIFT-F` | crowd control 2 | `CTRL-F` | 🔒 bandage (vast item) |
| `Z` | kleine defensive | `SHIFT-Z` | tweede kleine defensive | `CTRL-Z` | 🔒 health potion (vast) |
| `X` | tweede defensive | `SHIFT-X` | defensive | `CTRL-X` | 🔒 mana potion (vast) |
| `C` | grote defensive / stun | `SHIFT-C` | grote defensive 2 | `CTRL-C` | 🔒 healthstone (vast) |
| `V` | **crowd control** | `SHIFT-V` | crowd control 3 | `CTRL-V` | 🔒 trinket (vast) |

🔒 = MH vult die plek zelf met een item. **Zet daar geen spell neer.** Je hebt dus 12 + 12 + 7 = **31 spell-plekken**.
De labels zijn een richtlijn; de regels hieronder wegen zwaarder.

## De regels (uit de video, plus de vaste MH-taken)

1. De spell die je het vaakst drukt op de beste toets (1, dan 2, 3). Spells die je na elkaar drukt naast elkaar.
2. Zeldzaam maar levensbelangrijk (je grote noodknop) ook op balk A, niet weggestopt.
3. **Dezelfde taak op dezelfde toets bij elke klasse:** E = interrupt, Z/X/C = defensives, V = crowd control,
   R = beweging. Heeft een klasse er geen: laat de plek leeg of zet er iets logisch neer en zeg waarom.
   De video zegt C = stun; kies per klasse wat past (stun of grote defensive) en zeg het.
4. Shift = "tweede van dezelfde soort", AoE, en downranks (een lagere rank van de spell op dezelfde toets zonder
   Shift, als dat in Forever zin heeft; de motor kan dat nu NIET per rank — zie "Formaat" — dus noem het alleen in
   je uitleg als advies).
5. Vormen/stances: dezelfde knop om erin én eruit (Ctrl-1/2/3/4, zoals het oude blok).
6. Geen muis met extra knoppen aannemen.

## Formaat (precies dit; het oude blok staat in `Modules/ForeverBlock_<Class>.lua`, lees het eerst)

Per klasse één Lua-tabel `keys12 = { ... }` in **dezelfde vorm** als de bestaande `keys` in dat bestand:
- `["1"] = { all = "Spell" }` of `{ all = { "Spell A", "Spell B" } }` (eerste die de speler kent wint),
- per stance/vorm: `{ battle = "…", defensive = "…" }` met dezelfde state-namen als `states` in dat bestand,
- `base = …` (Druid/Priest/Rogue enz. als het bestand dat al gebruikt), `pair = …`, `cmd = …`, `bang = true`,
  `open = true` — alleen als het bestaande bestand die vorm al gebruikt, en dan precies zo.
- Alleen de 31 spell-plekken uit de tabel hierboven. Toetsen als `5`, `T`, `G`, `F1`-`F4`, `SHIFT-T` bestaan in
  12×4 NIET meer.
- **Elke spellnaam moet letterlijk bestaan** als sleutel in `Modules/ForeverSpellIds.lua` (`ns.FOREVER_SPELL_IDS`) of
  als `n = "…"` in `Modules/ForeverTrainerData.lua`. Controleer elke naam met Grep. Een naam die je niet vindt: niet
  gebruiken, en noemen.
- Neem de spells van het oude blok over (die zijn al nagekeken), plus wat logisch is. Geen spell twee keer.
- `toBlockD` blijft zoals het is (niet opnieuw schrijven).

## Wat je levert

Schrijf **`docs/forever/KEYBLOCK12_<CLASS>.md`** (bv. `KEYBLOCK12_WARRIOR.md`), in eenvoudig Nederlands:
1. Een tabel: toets → spell → waarom (één korte zin). Zeg per keuze of hij uit het oude blok komt, uit een bron
   (welke: ForeverHowToPlay.lua, ForeverTalentNext.lua, docs/forever/*_ROLES_*.md, …) of AFGELEID is.
2. Wat je niet kon meten of waar je twijfelt.
3. Onderaan het Lua-blok tussen ```lua en ```, beginnend met `keys12 = {` en eindigend met `},` — zodat het zo in
   het bestand kan.

**Wijzig geen enkel ander bestand. Commit niets.** Geen shell-commando's met `&&`, `;`, pijpen of `python -c`, en niet
de PowerShell-tool. **Draai `tools/_probe.py` NIET** (een andere helper gebruikt het tegelijk); lezen met Read/Grep/Glob
is genoeg. Heb je spelgegevens nodig die niet in de repo staan: zeg het in je rapport.
