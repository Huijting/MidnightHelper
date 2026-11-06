# OneForAll - Forever: wat we ervan leren (6 nov 2026)

Rob vroeg: *"All for One, speciaal voor Forever … kijken wat we daarvan kunnen leren"*. Het bleek **OneForAll - Forever**
van Smoergi te zijn. Een addon die "All for One" heet en voor Forever werkt, bestaat niet: er is alleen een oude
rotatiehulp uit 2024, en die is niet voor Forever.

Gelezen op 6 nov 2026: de CurseForge-pagina, de GitHub-pagina, `README.txt`, `THIRD_PARTY_LICENSES.txt` en
`DUNGEON_DATA_SOURCES.txt`. **De Lua-code zelf heb ik niet gelezen.**

## Wat het is (GEMETEN)

- **Bronnen:** CurseForge-project 1714201, en GitHub `smoergi/OneForAll_Forever`.
- **Downloads:** 378.551. Het project bestaat ongeveer een maand.
- **Versie en spel:** 6.1.5, van 5 nov 2026. Alleen voor Forever, game version 1.60.1.
- **Licentie: GPL-3.0.** MH zelf is **MIT** (`LICENSE`, `## X-License: MIT`).
- **Modules:**
  - gear planner en armory;
  - dungeons en raids, met loot, quests en attunements;
  - beroepen, met een crafting-lijst en wie welk recept kent;
  - een talentplanner, met import van talentsforever.com en wowforevertalents.com;
  - een trainervenster met wat je tot level 60 nog kunt leren;
  - hunter-pets, library books en kaartpunten;
  - een grote set gemakken, die allemaal standaard uit staan;
  - een welkomst-setup die je pagina voor pagina doorloopt.
- **Testcommando's:** veel, bijvoorbeeld `/ofa trainer`, `/ofa share test`, `/ofa rolltest`, `/ofa errors` en `/ofa where`.
- **Spell ranks:** de optie "Check low spell ranks" vindt knoppen op je balk met een lagere rank dan je kent. Je kunt de
  hoogste rank dan in één klik neerzetten, of de lage rank met "Keep" laten staan.
- **Geen toetsen, geen uitleg:** de README geeft geen keybind-hulp (alleen een binding voor "hide chat") en geen
  algemene uitleg over hoe je je class speelt.

## Lessen voor MH Forever

1. **Onze plek is toetsen en uitleg.** OneForAll doet gear, dungeons, beroepen en talenten al heel uitgebreid. Dat
   moeten we niet nabouwen. Het toetsenblok en een "How to play" voor nieuwe spelers doen zij niet.
2. **Lage ranks: geen werk voor ons.** Onze macro's gebruiken de spellnaam, en dan pakt het spel de hoogste rank
   (GEMETEN: Wrath → 5177). Alleen knoppen die de speler zelf neerzet kunnen een lage rank houden. OneForAll vangt dat
   al af.
3. **De trainer is het moment om uit te leggen.** Zij lezen het trainervenster uit. Wij kunnen daar zeggen: *"Nieuw:
   Maul — die komt op toets 1."* Dat past bij de How to play. AFGELEID: welke API zij daarvoor gebruiken heb ik niet
   gelezen. Meet dat eerst in de client.
4. **Alles standaard uit, met een welkomst-setup.** Dat is hetzelfde als onze regel "spelers kiezen, niet wij".
5. **Een testcommando per functie.** Dat is onze regel ook ("bouw je iets dat kan zwijgen…").
6. **Een eerlijk bronnenbestand.** Daarin staat per soort data de bron, en wat nog onzeker is. Dat lijkt op ons
   GEMETEN/AFGELEID.

## Regels

- 🔴 **Geen code overnemen.** GPL-3 in een MIT-addon zou heel MH onder GPL zetten. Ideeën overnemen mag wel.
- **Hun talentdata** komt van talentsforever.com (`data.json`). Die valt onder **CC BY 4.0** en mag dus ook in MH, met
  bronvermelding. Hun andere bronnen (QuestieDB, Carbonite) zijn GPL: daarvan nemen we niets over.

## Te testen vóór een Forever-release

Veel Forever-spelers zullen OneForAll naast MH draaien. Mogelijke botsingen (AFGELEID, niet getest):
- hun minimap-knoppenverzamelaar met onze minimapknop;
- hun "movable Blizzard windows" met ons Shift+scroll;
- hun tab in het spellboek.

Test daarom één keer met OneForAll erbij aan.
