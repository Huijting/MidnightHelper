# KEYBLOCK12 — DRUID (voorstel, 24 nov 2026, mh-research)

De opdracht kwam als tekst van de coördinator. Niets in `docs/` gelezen. Bronnen: alleen `Modules/` (geen `_probe.py`,
geen web). GEMETEN = staat letterlijk in het genoemde bestand en de genoemde regel. AFGELEID = mijn redenering.

## Wat is anders dan het oude blok (`Modules/ForeverBlock_Druid.lua`)

- De toetsen 5, F1, F2, F3, F4 en Shift-F1 bestaan niet meer. Hun spells gaan zo:
  Faerie Fire (5) naar Shift-F, Innervate (F1) naar Ctrl-Q, Regrowth (F2) naar Shift-C, Rebirth/Revive (F3) naar
  Ctrl-R, Rejuvenation (F4) naar F (als caster) en Swiftmend (Shift-F1) naar Shift-4 (als caster).
- Andere verhuizingen:
  - Frenzied Regeneration gaat van X naar C (beer).
  - Hibernate gaat van Shift-Q naar Shift-V.
  - Challenging Roar gaat van Shift-F naar Shift-Q (beer).
  - Soothe Animal gaat van Shift-F naar Shift-R (caster).
  - Abolish/Cure Poison gaat van Shift-C naar Shift-Q (caster).
  - Remove Curse gaat van Shift-V naar Ctrl-E.
- Alle 56 spellnamen van het oude blok staan er weer in, geen enkele dubbel. Ctrl-4 blijft leeg.
- De vormen (states, baseGuard) blijven precies zoals ze zijn: bear `[bonusbar:3]`, cat `[bonusbar:1/2]`, swim
  `[swimming]`. R houdt `open = true`.

## Tabel

| Toets | Spell(s) | Waarom | Bron |
|---|---|---|---|
| 1 | beer Maul · kat Claw · caster Wrath | Hoofdknop in elke vorm. | GEMETEN: oud blok regel 32. Volgorde: ForeverHowToPlay.lua:425, 443, 462 |
| 2 | beer Lacerate · kat Rake · caster Moonfire | Tweede rotatieknop. | GEMETEN: oud blok regel 33. HowToPlay:424, 442, 460 |
| 3 | beer Primal Bite · kat Shred · caster Starfire | Derde rotatieknop. | GEMETEN: oud blok regel 34. HowToPlay:423, 440, 459 |
| 4 | kat Rip · caster Insect Swarm | Spender: Rip is de finisher van de kat. Een beer heeft geen aparte spender (Maul staat op 1). | GEMETEN: oud blok regel 35. HowToPlay:444, 461. Beer leeg = AFGELEID |
| Q | beer Enrage · kat Shifting Power · caster Tranquility | Grote cooldown per vorm. | GEMETEN: oud blok regel 40 |
| E | beer en kat Feral Charge, caster leeg | Interrupt-plek. "it cannot move and cannot cast for 4 seconds". Een caster-druid heeft geen interrupt, dus die plek blijft leeg (regel 3). | GEMETEN: oud blok regel 45, HowToPlay:429. Leeg laten = AFGELEID |
| R | kat Dash · zwemmen Aquatic Form · caster Travel Form, `open` | Beweging. `open` zodat Travel Form ook vanuit de beer werkt. | GEMETEN: oud blok regel 51 en de kopregels 14-15 |
| F | beer Growl · kat Cower · caster **Rejuvenation** | Growl is de taunt. Voor de caster is F de hulpspell: de instant HoT. Een healer drukt die het vaakst ("1. Rejuvenation on the tank"), dus op balk A. | GEMETEN: Growl en Cower uit oud blok regel 53, healer-volgorde HowToPlay:478. Keuze = AFGELEID |
| Z | `all` Barkskin | Kleine defensive, in elke vorm. | GEMETEN: oud blok regel 54, HowToPlay:101 ("in every form") |
| X | caster Nature's Grasp (geen states meer) | Tweede defensive. Zonder beer-spell erop is er geen guard meer, dus hij werkt ook in een vorm. | Spell GEMETEN: oud blok regel 55. "works in a form": HowToPlay:105, niet in DB2 nagemeten |
| C | beer **Frenzied Regeneration** · caster Healing Touch | Ik kies voor C de grote defensive, niet de stun: de stuns zitten al op V. Voor de beer is dat FR ("turns Rage into health"), voor de caster de grote heal. Kat: leeg. | GEMETEN: HowToPlay:431, Healing Touch uit oud blok regel 56. Keuze = AFGELEID |
| V | beer Bash · kat Pounce · caster Entangling Roots | Crowd control (stun of root). | GEMETEN: oud blok regel 46 |
| Shift-1 | beer Swipe · caster Hurricane | AoE. | GEMETEN: oud blok regel 38 |
| Shift-2 | beer Demoralizing Roar · caster Wild Growth | Groepsknop: een debuff op alle vijanden, of een heal voor de hele groep. | GEMETEN: oud blok regel 39, HowToPlay:422, 481 |
| Shift-3 | caster Nature's Swiftness | Cooldown. Daarna Healing Touch, op C, er vlak onder. | GEMETEN: oud blok regel 42, HowToPlay:482 |
| Shift-4 | kat Ferocious Bite · caster **Swiftmend** | Spender of tweede van 4. Swiftmend "eet" een HoT op ("only on someone who has your Rejuvenation or Regrowth"). | GEMETEN: Ferocious Bite uit oud blok regel 36, HowToPlay:480. Keuze = AFGELEID |
| Shift-Q | beer **Challenging Roar** · caster **Abolish Poison / Cure Poison** | Tweede cooldown voor de beer (groeps-taunt). Voor de caster gif weghalen, omdat de beer deze plek alleen in de berenvorm gebruikt. | Spells GEMETEN: oud blok regels 48 en 50. Keuze = AFGELEID |
| Shift-E | `all` Shadowmeld / War Stomp | Race-spell. | GEMETEN: oud blok regel 61 |
| Shift-R | kat Prowl · caster **Soothe Animal** | Tweede beweging: ongezien langs vijanden. Prowl sluipt, Soothe Animal maakt een beest minder oplettend. | Prowl GEMETEN: oud blok regel 52. Wat Soothe Animal in Forever doet: AFGELEID (geen MH-tekst) |
| Shift-F | `all` **Faerie Fire** | Naast Growl (F): de pull van de beer en de debuff voor kat en caster. Werkt in bijna elke vorm, dus `all`. | GEMETEN: HowToPlay:98 ("works in most forms, but not in Travel or Aquatic Form") en :421 (pull) |
| Shift-Z | caster Thorns | Buff die terugslaat: de tweede kleine defensive. | GEMETEN: oud blok regel 59. Rol = AFGELEID |
| Shift-X | caster Gift of the Wild / Mark of the Wild | Buff vóór een gevecht. Een druid heeft geen extra defensive voor deze plek. | GEMETEN: oud blok regel 60 |
| Shift-C | caster **Regrowth** | De snelle heal, als "tweede van C" naast Healing Touch. Beter bereikbaar dan de oude F2. | GEMETEN: HowToPlay:97 ("quick heal"), :479. Keuze = AFGELEID |
| Shift-V | caster **Hibernate** | Tweede crowd control. Shift-F ging naar Faerie Fire. | Spell GEMETEN: oud blok regel 47. Effect (beest of drakenkin slaapt) = AFGELEID |
| Ctrl-1 | Dire Bear Form / Bear Form | Vorm 1. Dezelfde knop erin en eruit (regel 5). | GEMETEN: oud blok regel 62 |
| Ctrl-2 | Cat Form | Vorm 2. | GEMETEN: oud blok regel 63 |
| Ctrl-3 | Moonkin Form | Vorm 3. | GEMETEN: oud blok regel 64 |
| Ctrl-4 | (leeg) | Vorm 4: Travel en Aquatic Form staan al op R. Beweging gaat voor. | AFGELEID |
| Ctrl-Q | **Innervate** | Buff en cooldown, één keer per gevecht. | GEMETEN: oud F1 (regel 41), HowToPlay:483 |
| Ctrl-E | **Remove Curse** | Vloek weghalen. Minder vaak dan gif bij het levelen, dus Ctrl. | Spell GEMETEN: oud blok regel 49. Frequentie = AFGELEID |
| Ctrl-R | `pair` [combat] Rebirth, anders Revive | Herstel buiten gevecht: Revive. In een gevecht wordt het Rebirth. | GEMETEN: oud F3 (regel 44), HowToPlay:99 |

Alle 56 namen staan letterlijk als sleutel in `Modules/ForeverSpellIds.lua`. GEMETEN: één Grep met alle 56 namen,
exact geankerd op `^\t["…"] = `, gaf 56 treffers.

## Twijfels

1. **E als caster leeg.** Regel 3 zegt: E = interrupt, en die heeft een caster-druid niet. Alternatief voor
   healers: Regrowth op E (caster). Dan staat de snelle heal op balk A. Dat is Robs keuze.
2. **Nature's Grasp zonder guard (X).** Dat hij in een vorm werkt, haal ik uit ForeverHowToPlay.lua:105. In DB2 heb ik
   het niet nagemeten (geen `_probe.py`). Werkt hij niet in een vorm, dan geeft X in de beer alleen een foutmelding.
   Het oude blok had daar Frenzied Regeneration.
3. **C = grote defensive.** Ik koos defensive omdat de stuns (Bash, Pounce) al op V staan. In kattenvorm doet C nu
   niets (de beer-state bewaakt de basis).
4. **De dispels staan uit elkaar**: gif op Shift-Q (caster), vloek op Ctrl-E. Dat gif vaker voorkomt, heb ik
   AFGELEID, niet gemeten. Ze kunnen ook omgedraaid.
5. **Faerie Fire op Shift-F in plaats van Hibernate.** Faerie Fire gebruik je veel vaker (elke pull van de beer).
   Hibernate gaat naar Shift-V. Dat is AFGELEID.
6. **Soothe Animal op Shift-R**: de logica "ongezien langs vijanden" is AFGELEID. Wat de spell in Forever precies doet,
   staat in geen MH-tekst.
7. **Downranks** (regel 4, alleen advies; de motor kan het nu niet): een lage rank van Healing Touch op een Shift-toets
   was vroeger gebruikelijk. Daar is nu geen plek voor.
8. **ForeverHowToPlay.lua noemt de oude toetsen.** Bijvoorbeeld F2, F4, Shift-F1, F1, F3, 5, X = Frenzied
   Regeneration en Shift-Q = Hibernate (regels 84-105 en 419-493). De kop van dat bestand (regel 14-15) zegt:
   "change a table, change its line here too". Die teksten moeten mee als keys12 live gaat.
9. **Motor en `why`.** `ns.ForeverBlockUnlisted` (ForeverBlock.lua:560-571) voegt elk stringveld van een toets toe aan
   `listed`. Daar zit `why` ook bij. Dat is onschuldig, maar netter is `field ~= "why"` overslaan. GEMETEN in de code.
10. **Macrolengte**: de langste toets (F, met mouseover aan) blijft ruim onder 255 tekens. Dat heb ik AFGELEID uit de
    opbouw in ForeverBlock.lua:287-300, niet in de client gemeten.

## keys12

```lua
	keys12 = {
		["1"] = { bear = "Maul", cat = "Claw", base = "Wrath", why = "main attack in every shape: Wrath, Maul as bear, Claw as cat" },
		["2"] = { bear = "Lacerate", cat = "Rake", base = "Moonfire", why = "rotation: Moonfire, Lacerate as bear, Rake as cat" },
		["3"] = { bear = "Primal Bite", cat = "Shred", base = "Starfire", why = "rotation: Starfire, Primal Bite as bear, Shred from behind" },
		["4"] = { cat = "Rip", base = "Insect Swarm", why = "spender: Rip finishes as cat; Insect Swarm as caster" },
		["Q"] = { bear = "Enrage", cat = "Shifting Power", base = "Tranquility", why = "big cooldown: Tranquility, Enrage as bear, Shifting Power as cat" },
		["E"] = { bear = "Feral Charge", cat = "Feral Charge", why = "kick key: Feral Charge stops a cast; a caster druid has none" },
		["R"] = { cat = "Dash", swim = "Aquatic Form", base = "Travel Form", open = true, why = "move: Travel Form, Aquatic Form in water, Dash as cat" },
		["F"] = { bear = "Growl", cat = "Cower", base = "Rejuvenation", why = "Growl taunts as bear; as caster your instant heal Rejuvenation" },
		["Z"] = { all = "Barkskin", why = "small defensive, works in every form" },
		["X"] = { base = "Nature's Grasp", why = "second defensive: roots what hits you, also in a form" },
		["C"] = { bear = "Frenzied Regeneration", base = "Healing Touch", why = "big defensive: Frenzied Regeneration as bear, else Healing Touch" },
		["V"] = { bear = "Bash", cat = "Pounce", base = "Entangling Roots", why = "crowd control: Roots, Bash as bear, Pounce from Prowl" },
		["SHIFT-1"] = { bear = "Swipe", base = "Hurricane", why = "AoE: Swipe as bear, Hurricane as caster" },
		["SHIFT-2"] = { bear = "Demoralizing Roar", base = "Wild Growth", why = "group key: Demoralizing Roar as bear, Wild Growth heals a group" },
		["SHIFT-3"] = { base = "Nature's Swiftness", why = "cooldown: next nature spell is instant, then Healing Touch (C)" },
		["SHIFT-4"] = { cat = "Ferocious Bite", base = "Swiftmend", why = "spenders: Ferocious Bite as cat, Swiftmend eats your HoT" },
		["SHIFT-Q"] = { bear = "Challenging Roar", base = { "Abolish Poison", "Cure Poison" }, why = "bear: group taunt cooldown; caster: remove poison" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp" }, why = "your race spell" },
		["SHIFT-R"] = { cat = "Prowl", base = "Soothe Animal", why = "get past enemies: Prowl as cat, Soothe Animal on a beast" },
		["SHIFT-F"] = { all = "Faerie Fire", why = "pull and weaken, next to Growl; works in almost every form" },
		["SHIFT-Z"] = { base = "Thorns", why = "buff that hurts what hits you: second small defensive" },
		["SHIFT-X"] = { base = { "Gift of the Wild", "Mark of the Wild" }, why = "armor and stats buff, before a fight" },
		["SHIFT-C"] = { base = "Regrowth", why = "quick heal, next to Healing Touch on C" },
		["SHIFT-V"] = { base = "Hibernate", why = "second crowd control: puts a beast or dragonkin to sleep" },
		["CTRL-1"] = { base = { "Dire Bear Form", "Bear Form" }, why = "Bear Form: the same key in and out" },
		["CTRL-2"] = { base = "Cat Form", why = "Cat Form: the same key in and out" },
		["CTRL-3"] = { base = "Moonkin Form", why = "Moonkin Form: the same key in and out" },
		["CTRL-Q"] = { base = "Innervate", why = "mana cooldown, for you or another healer" },
		["CTRL-E"] = { base = "Remove Curse", why = "remove a curse from a friend" },
		["CTRL-R"] = { pair = { cond = "[combat]", first = "Rebirth", second = "Revive" }, why = "bring a friend back: Revive, in a fight Rebirth" },
	},
```
