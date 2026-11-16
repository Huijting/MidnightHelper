# Forever: beste stats per class en rol (leveling) — onderzoek 16 nov 2026

Rob (16 nov, letterlijk): *"wat zijn de beste stats voor de spec die ik heb? … moet ik nu strength nemen of moet ik nou
de stamina nemen"*; op A/B (via sparring): *"b , maar hou ook dps en heling in je achterhoofd"*.
Onderzoek: mh-research (bouwchat 16-11). Niets gebouwd. GEMETEN = in de bron gelezen; AFGELEID = samenvatting/redenering.

## Wat het spel zelf zegt (GEMETEN, wago DB2 Forever 1.60.1.70938)

- `ChrClasses` AP per stat: Warrior Str 2 / Agi 0 (ranged Agi 2); Paladin Str 2; Hunter Str 1, Agi 1 (ranged Agi 2);
  Rogue Str 1, Agi 1; Priest/Mage/Warlock Str 1; Shaman Str 2, Agi 0; Druid Str 2 (Agi alleen in Cat).
- `ChrClasses.RolesMask`: tanken kunnen alleen Warrior, Paladin, Druid; healen Paladin, Priest, Shaman, Druid
  (bit-betekenis AFGELEID uit retail-rijen).
- Talenten die een stat iets laten doen: Life Tap 1454 (Spirit), Mental Dexterity 415140 (AP uit Int), Careful Aim
  1223984 (AP uit Int), Champion of the Light 1311084 (spell damage uit Int).
- Blizzard over Enhancement Shaman (6 nov 2026, bluetracker topic 2404092): "Strength is always their strongest stat".

## Volgorde per class/rol (alleen hoofdstats; AFGELEID uit de genoemde gidsen, citaten GEMETEN)

| Class | Rol | Volgorde | Oneens? |
|---|---|---|---|
| Warrior | solo/melee | Str > Agi > Sta | Mobalytics zet Spirit eerst (tot lvl 30) |
| Warrior | tank | Sta + Armor > Str > Agi | ja: Icy Veins leveling = Str eerst; lvl-30 tanklijst = Armor > Sta |
| Paladin | melee (Ret) | Str > Int (Int vanaf 40) | ja: Icy Veins Int > Str; SixtySim Str eerst; Mobalytics Sta & Spi eerst |
| Paladin | tank (Prot) | Sta > Str > Int > Agi | — |
| Paladin | heal (Holy) | Int > Spi | — |
| Hunter | ranged | Agi > Int (met Careful Aim) > Spi > Sta | — |
| Rogue | melee | Agi > Str > Sta | nee, alle bronnen eens |
| Priest | caster (Shadow) | Int > Spi > Sta | — |
| Priest | heal | Int ≈ Spi > Sta | Icy Veins Spi > Int |
| Shaman | melee (Enh) | Str > Int > Spi | Blizzard Str; Icy Veins (13 nov) Int > Str (mana) |
| Shaman | caster (Ele) | Int > Spi > Sta | — |
| Shaman | heal (Resto) | Int ≈ Spi | geen Icy Veins-lijst; bronnen oneens |
| Mage | caster | Int ↔ Spi | Icy Veins Frost Spi > Int; Mobalytics Int > Spi |
| Warlock | Affliction | Spi > Int ≈ Sta (Life Tap) | — |
| Warlock | Destro/Demo | Int ≈ Sta > Spi | — |
| Druid | melee (Cat) | Agi ↔ Str | Icy Veins Agi; Mobalytics/ForeverDB/DB2 eerder Str ≥ Agi |
| Druid | tank (Bear) | Sta > Agi > Str (+ Armor/Defense) | — |
| Druid | caster (Balance) | Int > Spi | — |
| Druid | heal (Resto) | Int > Spi | — |

Bronnen: icy-veins.com/wow-forever (meeste pagina's 4 nov 2026), mobalytics.gg/wow-forever, sixtysim.com, wowfdb.com,
bluetracker.gg — allemaal okt–nov 2026.

## Waar MH nu iets anders zegt (GEMETEN in de code: ForeverMainStats.lua → ForeverGearTipText/questhint)

- **Groot:** Elemental/Resto Shaman krijgen Str-advies (Int hoort eerst); Balance/Resto Druid krijgen Agi-advies; Holy en
  Prot Paladin krijgen Str-advies; Bear krijgt geen Stamina.
- Warlock: Spirit ontbreekt (Affliction).
- Klein / gidsen oneens: Mage Int↔Spi, Priest-heal Int↔Spi, Paladin-Ret Str↔Int, Druid-Cat Agi↔Str.

## Hoe MH de rol kan weten

- **Richting** (`ns.GetForeverDirection()`, per character, eigen keuze van de speler): GEMETEN bruikbaar, staat bij Rob al
  op 7+ characters. Nil als niet gekozen.
- Spec-rol: onbruikbaar (Forever heeft één spec per class, altijd dps; GEMETEN in ChrSpecialization).
- Groepsrol (`UnitGroupRolesAssigned`) en groepszoeker-rollen (`C_LFGListRoles.GetRoles()`): bestaan (GEMETEN in de
  bron), niet in het spel gedraaid.
- Talenten via C_Traits (zoals Blizzards eigen Forever-scherm): kan, maar een boom is geen rol.

**Advies (AFGELEID):** rol = class × richting (Paladin: heal/tank/melee; Priest: heal/heal/caster; Shaman:
caster/melee/heal; Druid: caster/melee/heal; Warrior altijd melee; Hunter/Rogue/Mage/Warlock vast). Zonder richting: de
huidige tabel. Tank-regel als tweede regel alleen voor Warrior/Paladin/Druid. Groepsrol pas later, na een meting.
Dezelfde tabel voedt dan ook de groene tooltipregel, zodat ze elkaar niet tegenspreken.
