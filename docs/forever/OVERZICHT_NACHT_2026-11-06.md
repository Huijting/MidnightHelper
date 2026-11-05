# Goedemorgen Rob — wat er vannacht gebeurd is (5→6 nov 2026)

Jij zei: *"ga helemaal los … geen release"*. Dat is gebeurd. **Niets uitgebracht, geen tag, niets op CurseForge.**
Gewoon WoW is niet veranderd. Je Druid in Forever werkt nog precies hetzelfde.

## In het kort

1. **De motor werkt nu voor elke class.** Je Druid is de eerste tabel. Bewijs dat er voor jouw Druid niets veranderde:
   de oude en nieuwe code maken exact dezelfde macro's (getest over 4519 gevallen, 0 verschillen).
2. **Voor alle 8 andere classes ligt er een voorstel klaar**, net als bij jouw Druid: alle spells tot level 60 uit
   Blizzards eigen data, en per toets wat erop komt. **Nog niet in de addon** — jij keurt eerst.
3. **Een gevaarlijke fout van mij gevonden en gerepareerd:** het Forever-bestand stond op GitHub. Bij je volgende gewone
   release had CurseForge MH dan óók als Forever-addon gemarkeerd, terwijl het daar niet werkt. Nu staat het alleen nog
   op je pc (je Forever laadt het gewoon).
4. **Uitgezocht wat een Forever-release nodig heeft**: het kan met onze huidige manier van uitbrengen, met een paar kleine
   stappen. Zie `docs/PLAN_FOREVER_RELEASE_2026-11-06.md`.

## De 8 voorstellen — hoofdlijn per class

Alles hieronder is een **voorstel**. Elk voorstel heb ik door de echte motor gehaald: alle namen bestaan, alle toetsen
kloppen, geen spell staat dubbel. In het spel getest is nog niets.

| class | wisselt de balk? | 1 / 2 / 3 | grootste vraag aan jou |
|---|---|---|---|
| **Warrior** | ja: Battle / Defensive / Berserker | Heroic Strike / stance-aanval (Overpower·Revenge·Whirlwind) / Mortal Strike | is 2 = stance-aanval goed? (bij de Druid is 2 de DoT) |
| **Rogue** | ja: Stealth | Sinister Strike (stealth: Garrote) / Backstab (stealth: Ambush) / Mutilate | Feint op F of op Z? |
| **Paladin** | nee | Holy Strike / Judgement / Seal of Command | blok D is op 60 te vol (15 voor 12 plekken) |
| **Hunter** | nee | Auto Shot / Serpent Sting / Arcane Shot | eerst melee of eerst schieten? |
| **Priest** | nee (Shadowform wisselt niets) | Mind Flay of Smite / Shadow Word: Pain / Mind Blast | Mind Flay op 1 i.p.v. Smite? |
| **Shaman** | nee (Ghost Wolf wisselt niets) | Lightning Bolt / Flame Shock / Stormstrike | Ctrl-1/2/3 = de drie totem-sets? |
| **Mage** | nee | Fireball / Frostbolt / Arcane Missiles | F/F2/F4 vullen met wards, of leeg laten? |
| **Warlock** | nee | Shadow Bolt / Corruption / Immolate | demonen oproepen op Ctrl-1/2/3, of op blok D? |

De volledige voorstellen: `docs/forever/FOREVER_<CLASS>_2026-11-06.md` (bovenaan staat wat ik zelf nakeek).

## Dingen die voor iedereen gelden (gemeten in Blizzards data)

- **Welke vorm de balk wisselt** (gemeten): Cat 1, Bear 3, Rogue-Stealth 1, Battle 1, Defensive 2, Berserker 3.
  **Moonkin, Shadowform en Ghost Wolf wisselen niets.** In je Druid-code stond een verkeerde uitlegregel over Moonkin;
  verbeterd. Je macro's waren al goed.
- **Talentpunten kunnen eerder komen**: een account-voordeel ("Talented") geeft al punten vanaf level 5-9. Talent-spells
  kunnen dus tot 5 levels eerder komen dan in de lijsten staat.
- **Nieuw in de motor**: een optie voor `!` (bij Auto Shot: nog een keer drukken zet hem niet uit).
- **Skyborne** (het nieuwe ras) kan o.a. Druid, Hunter, Rogue, Warrior, Shaman en (één soort) Mage zijn, maar géén Priest,
  Paladin of Warlock. **Vraag voor je Druid:** Shift-E heeft nog geen Skyborne-racial.

## Wat jij kunt doen (als je tijd hebt)

1. Een voorstel van een class doorlezen en "goed" zeggen (of zeggen wat anders moet). Dan zet ik die class in de addon.
2. In Forever met je Druid naar level 10 (beer): doet **1** dan Maul?
3. Liefst een tweede character in Forever, zodat we een tweede class echt testen.

## Wat ik níet gedaan heb

- Geen release, geen tag, niets geüpload. Geen voorstel in de addon gezet. Gewoon WoW niet aangeraakt.
- Aan je andere project (foto's/video's/muziek) niet gekomen.
