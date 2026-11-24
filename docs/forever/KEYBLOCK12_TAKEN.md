# 12 × 4 — de vaste taak per toets, gemeten in de code (24 nov 2026)

Voor het uitlegblad (Rob via Sparring 24-11: *"Dat gewoon voor iedereen weet dat een heal altijd op die knop staat. Of
een belangrijke attack altijd op die staat. … dat is altijd hetzelfde op welke class je ook speelt."*).
GEMETEN: `keys12` van de 9 bestanden `Modules/ForeverBlock_<Class>.lua` (commit 4d15ce3), per toets de eerste spell en
de `why`. "Klopt" = bij alle 9 dezelfde soort; "meestal" = 1-3 uitzonderingen; "wisselt" = per class iets anders.

| toets | taak | klopt? | uitzonderingen |
|---|---|---|---|
| 1 | hoofdaanval | klopt | — |
| 2 | rotatie (vaak je DoT) | klopt | — |
| 3 | rotatie | klopt | Paladin: zijn seal |
| 4 | afmaker / spender | meestal | Hunter Aimed Shot, Shaman Searing Totem, Druid Insect Swarm (caster) |
| Q | grote cooldown | klopt | Paladin: Lay on Hands (cooldown én noodknop) |
| E | interrupt | meestal | Warlock leeg (geen interrupt); Paladin stun; Hunter Scatter Shot; Druid alleen in vorm |
| R | beweging | meestal | Warlock: vijand vertragen; Paladin: Blessing of Freedom |
| F | taunt of hulpspell | **wisselt** | tanks taunt; de rest een eigen hulpspell (Fade, Life Tap, Mend Pet, Ice Lance …) |
| Z | kleine defensive | klopt | — |
| X | tweede defensive | klopt | Priest: Desperate Prayer (een heal) |
| C | grote defensive, of je grote heal | klopt (2 soorten) | healers (Priest, Druid, Paladin, Shaman) en Warlock: hun grote heal; Rogue: Preparation |
| V | crowd control | klopt | Warrior Hamstring (vertragen) |
| Shift-1 | AoE | klopt | — |
| Shift-2 | tweede AoE | meestal | Rogue Throw, Warlock Immolate, Paladin tweede Judgement |
| Shift-3 | cooldown / tweede van 3 | **wisselt** | |
| Shift-4 | tweede afmaker / AoE-spender | meestal | |
| Shift-Q | tweede cooldown | meestal | Hunter Concussive Shot, Druid Abolish Poison |
| Shift-E | race-spell | klopt | — |
| Shift-R | tweede beweging | **wisselt** | de meeste classes hebben er geen: een vrije spell |
| Shift-F | crowd control 2 | meestal | Druid Faerie Fire, Shaman Tremor Totem |
| Shift-Z | tweede kleine defensive | **wisselt** | Warrior Rend, Rogue Riposte, Hunter Hunter's Mark |
| Shift-X | tweede defensive | **wisselt** | Hunter Raptor Strike, Druid Gift of the Wild, Shaman Riptide |
| Shift-C | **snelle heal** (healers) | klopt voor de 4 healers | niet-healers: iets anders (Sunder Armor, Cold Snap …) |
| Shift-V | crowd control 3 | meestal | Paladin Cleanse |
| Ctrl-1/2/3 | vorm, stance, aura, pet of totemset (in en uit) | meestal | Mage: spells; Rogue: leeg |
| Ctrl-4 | vorm 4 of een losse spell | **wisselt** | |
| Ctrl-Q | buff of cooldown | **wisselt** | |
| Ctrl-E | cooldown of dispel | **wisselt** | |
| Ctrl-R | herstel buiten gevecht / iemand terughalen | klopt | — |
| Ctrl-F/Z/X/C/V | bandage, health potion, mana potion, healthstone, trinket | klopt | vaste items |
| Alt-… | je eigen balk (block D); Alt-G i.p.v. Alt-Z | klopt | — |

Heal (stap 2 van de opdracht): in 12 × 4 is er GEEN aparte heal-taak in het rooster, maar de vier healers hebben hem
in de praktijk wel op dezelfde plek: **C = grote heal, Shift-C = snelle heal** (GEMETEN, alle vier). Voorstel aan Rob via
Sparring; niets veranderd.
