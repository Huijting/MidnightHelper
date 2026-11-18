# Controle "What you must HAVE before the trip" — ForeverClassQuests.lua (18 nov 2026)

Alleen gelezen. Bronnen: DB2 Forever build 1.60.1.70959 (wago, via gamedata), Wowhead Forever tooltip-JSON
(nether, 18 nov 2026), Spoken Compendium (Forever-addon), Zygor Forever (alleen vergeleken), warcraft.wiki,
azeroth.wiki, Wowhead Forever-gids "Collecting Library Books" (bijgewerkt 13 nov 2026), Sixty Forever (24 sep, beta),
Warcraft Tavern. Regelnummers = `Modules/ForeverClassQuests.lua` tenzij anders vermeld.

## FOUT

**F1 — 7642 Collection of Goods vraagt óók 150 goud, zonder pre-check** (r. 1331-1336)
- GEMETEN (Wowhead Forever quest 7642): Requirements "Stratholme Holy Water x5; Arthas' Tears x10; Runecloth x40;
  Arcanite Bar x6; Money:150". Mijn scan van alle 445 quest-id's in het bestand vond Money alleen bij 7637 (positieve
  controle) en 7642.
- Code: geen `pre`. Het goud staat alleen in de tekst van doel 4 (`FCQ_OBJ_PA_ARCANITE`, enUS r. 6096). Heeft de speler
  de Arcanite al, dan ziet hij die regel nooit; daarna stuurt de "turn"-stap hem van Stratholme naar Grimand in Stormwind
  zonder goudcheck. Dezelfde soort fout als 7637.
- Voorstel: `pre = { { gold = 1500000, at = PA.grimand } }` op 7642.

**F2 — Het 150-goud-seintje voor 7625 komt pas als de reis al gemaakt is** (r. 381-382)
- GEMETEN: Ur'dan 14522 staat naast Banehollow 9516 (Wowhead Forever: 36.2,44.4 en 36,44.4, Felwood). Zygor Forever
  (vergeleken): 7625 aannemen bij Banehollow, direct daarna Stardust kopen bij Ur'dan (beide "Inside the cave").
- De pre wordt alleen gecontroleerd als 7625 in je log staat. Die quest krijg je onderin Shadow Hold. Je ziet dus "Don't
  make the trip without it" terwijl je er al bent. Zonder 150 g moet je terug, en opnieuw door Jaedenar.
- warcraft.wiki (Dreadsteed questline) en Warcraft Tavern zeggen allebei: neem de 150 g al mee bij Lord Banehollow
  (7623). Dit is precies Robs geval ("halve wereld over gereisd").
- Voorstel: dezelfde goud-pre (met `unlessItem = 18687`) ook op 7623 en 7624.

## RISICO

**R1 — 7631 ritueel: drie gekochte voorwerpen (250 g) staan nergens als voorwaarde** (r. 385-386; enUS r. 5947)
- GEMETEN DB2 ItemSparse: J'eevee's Jar 18663 (BuyPrice 1500000 = 150 g), Black Lodestone 18629 (50 g), Xorothian
  Glyphs 18670 (50 g). Alle drie binden bij oppakken en zijn uniek.
- Zygor Forever (vergeleken, r. 24382-24384): koop alle drie bij Gorzeeki vóór 7631, en daarna DM West met een groep.
  Zygor-tip: de Lodestone kost een soul shard.
- MH-tekst: alleen "use the items from Gorzeeki". Er staat niet "koop ze eerst, 250 g".
- AFGELEID dat Forever ze nog nodig heeft (de quest-tooltip toont geen Requirements). Let op: `PreStep` met `items`
  betekent "één van deze is genoeg". Voor dit ritueel zijn alle drie nodig.

**R2 — Shadowy Potion: "about 6 gold each" klopt waarschijnlijk niet** (enUS r. 6162, plus 7 packs)
- GEMETEN DB2 18802: BuyPrice 60000 en VendorStackCount 3. Ter controle, in dezelfde tabel: Refreshing Spring Water
  25/5 en Rough Arrow 10/200 (de prijs geldt voor de hele stapel). Dus 6 g voor 3 stuks.
- warcraft.wiki: "(6) (Buys 3)". Een Wowhead-reactie zegt "één potion met 3 charges". Warcraft Tavern (TBC) zegt
  "6 gold apiece". De bronnen zijn het oneens.
- Het aantal staat nergens. Een potion werkt 20 minuten (GEMETEN, item-tooltip). Zygor Forever koopt er 6 en drinkt er
  3 (heen, na Ulathek, voor Ur'dan).
- Tekstvoorstel: "koop er minstens 3 (6 goud per 3), elk werkt 20 minuten".

**R3 — Potions alleen gecheckt bij 7623, niet bij 7624/7625** (r. 377-383)
- Warcraft Tavern: voor Ur'dan moet je een actieve potion hebben. Bij Ulathek moet je de buff weghalen en daarna een
  nieuwe drinken (ook Zygor).
- Verlaat de speler Felwood zonder potions (bijvoorbeeld om goud te halen, F2), dan krijgt hij op de terugweg geen
  waarschuwing. AFGELEID.

**R4 — Priester Rank 2: kan vastlopen als Rank 3 Rank 2 verdringt** (r. 1138-1141)
- GEMETEN: 2052 = Lesser Heal "Rank 2", BaseLevel 4. 2053 = Rank 3, level 10 (Spell + SpellLevels). Alle 5
  robe-quests noemen in Forever "Lesser Heal (Rank 2)". De 5 dorpstrainers zijn "Priest Trainer". Dat klopt allemaal.
- AFGELEID risico: haalt Forever lagere ranks uit het spellbook (de eigen priest-kop, r. 1089, gaat daarvan uit), dan
  geeft `Known(2052)` false. Een priester van 10+ krijgt dan "learn Rank 2 at your trainer", en dat kan niet meer. De
  quest staat in zijn log, dus de regel verdwijnt nooit uit "Do this now" (NowSkip, inLog).
- Voorstel: 2053 (en hoger) ook goedkeuren, of bij 2053 een andere tekst tonen.

**R5 — Start-items 282423 / 282400 / 282418 starten geen quest** (r. 999, 1007, 1351)
- GEMETEN DB2: StartQuestID = 0 voor alle drie. Positieve controle in dezelfde run: 6775→1642, 6916→1646, 6776→1649.
- Zygor Forever: "accept … |goto" bij Sarvis, Sten en Rorian, dus bij een NPC. De items zijn "<Right Click to Read>".
  Waarschijnlijk krijg je ze bij het aannemen.
- Gevolg: de `item`-tak komt meestal nooit aan bod en is dan onschuldig. Heeft iemand het item zonder de quest, dan
  zegt MH "use it", en dat helpt niet.
- De opmerking "probably starts from the item" wordt door de DB2 tegengesproken.

**R6 — Wordt 97286 echt na het eerste boek aangeboden?** (r. 2152-2153, BookStep r. 2251-2254)
- GEMETEN in bronnen: warcraft.wiki zegt "first library book". azeroth.wiki noemt als voorwaarde één van de 40 boeken.
  De Wowhead-gids (13 nov) zegt "When Mages hand in their first book…".
- Sixty Forever (24 sep, beta) en wowdee (6 okt) zeggen dat het aantal onbekend is.
- Klopt "één boek" niet, dan blijft de "get"-stap de speler naar de bibliothecaris sturen. Laag risico.

**R7 — Scholomance-sleutel ontbreekt** (7629 r. 383 / enUS 5946; paladin 7647 r. 1343 / enUS 6101)
- Zygor Forever-tip: "This requires the Skeleton Key from the quest 'The Key to Scholomance'". De MH-teksten zeggen
  alleen "you need a group".
- Niet gemeten in Forever. AFGELEID.

**R8 — Teksten**
- `FCQ_CHAIN_MA_STUDY` (enUS r. 6128) zegt "free scrolls … once an hour". Maar Study gebruikt reagent 17056 Light
  Feather x1 (GEMETEN SpellReagents en ItemSparse). Het is dus niet gratis. "Once an hour" klopt wel: RecoveryTime
  3600000 ms (GEMETEN SpellCooldowns). De Wowhead-gids zegt hier ten onrechte "one-day".
- "Research Access" staat in de de/fr/es/pt/ru-packs in het Engels (deDE r. 266-271). De deDE-client noemt de quest
  "Forscherzugang" (GEMETEN, Wowhead Forever deDE). Dat botst met de regel van 20 okt. De andere talen heb ik niet
  gemeten.
- `FCQ_OBJ_MA_BRAMBLE` (r. 6164) zegt "use a Witherbark Totem Stick … middle stone of the Circle of Outer Binding". De
  item-tooltip 7273 zegt (GEMETEN): "Gather 10 totem sticks, and use them at the Stone of Outer Binding". Klein
  verschil.
- Ta'zo is een muurschildering of tablet die je natrekt (Sixty Forever). "Click it where it lies" kan iemand die een
  boek zoekt in de war brengen. Klein.
- Dalaran Digest (Ambermill) en Bewitchments (Moonbrook) zijn boeken van item level 25 (GEMETEN), in gebieden van
  ongeveer level 15-20. De kop zegt "safe for a level-6 mage". Ze worden alleen gekozen als ze het dichtstbij zijn.
  Laag risico.

**R9 — 7645 in 7643: 50 g + 20 Enriched Manna Biscuits alleen als tekst** (r. 1338, enUS r. 6097)
- GEMETEN (quest 7645): "Enriched Manna Biscuit x 20; Money:50". De tekst klopt.
- Er is geen harde pre-check. Laag risico.

**R10 — Study komt bij elke mage van level 6+ bovenaan "Do this now"** (r. 1574, NowPick r. 2430-2444)
- Study is een spell-chain, dus hij krijgt voorrang en ITEM_CHAIN_SPAN geldt niet. Met de nieuwe pijl naar een boek
  dringt dat nu meer op. Ontwerpkeuze. AFGELEID.

## OK

- **BOOK_ITEMS** (r. 2156): precies de 40 rijen in DB2 ItemSparse met "library" in de omschrijving. Allemaal uniek en
  BoP. GEMETEN.
- **BOOK_QUESTS** (r. 2161): 38 van de 40 zijn op Wowhead Forever gemeten, elk met zijn eigen boek. 79953 en 81951 geven
  404 op Wowhead Forever, maar staan wel in Forever QuestV2 (UniqueBitFlag 55507/57317) en op Wowhead Classic met de
  juiste boeknaam. GEMETEN.
- **Bibliothecarissen**:
  - GEMETEN (Wowhead Forever): Garion Wendell 211033 "Librarian", Stormwind 48.8,86.6/49,86.4. Owen Thadd 211022
    "Librarian", Undercity 73.4,33. De code heeft 48.9,86.5 en 73.4,33.0.
  - Beiden geven en nemen 97286 (warcraft.wiki, azeroth.wiki, foreverchanges "both factions").
  - Spoken: de boekquests eindigen bij 211033 (Alliance) of 211022 (Horde).
  - De 37.8,80.2 van warcraft.wiki is de andere Stormwind-kaart. De code gebruikt dezelfde kaart als bij zijn andere
    Stormwind-NPC's.
- **START_BOOKS** (r. 2170-2185):
  - De 7 gemeten plekken komen precies overeen met Wowhead Forever object-spawns. 386759 Elwynn 65.4,70.1; 386691
    IF 75.7,10.5; 408014 Loch Modan 35.6,48.9; 405879 Tirisfal 59.4,52.3; 407566 Barrens 62.7,36.3; 410299 Silverpine
    43.4,41.2; 409501 Silverpine 63.4,63.1. GEMETEN.
  - Map-id's 1429/1455/1432/1436/1420/1454/1413/1421 zijn GEMETEN in UiMap Forever.
  - De 3 gids-plekken staan ook in de Wowhead-gids van 13 nov: Westfall 52.7,53.8 en 45.4,70.5, Orgrimmar 38.7,78.4.
  - Ataeric: in de beta was de plek leeg, maar na de launch zeggen de Wowhead-gids (lijst van varenne, "Solo") en
    Warcraft Tavern dat het boek er ligt.
  - De boeknamen kloppen met ItemSparse.
  - De verdeling per kant past bij Spoken. Inleveren bij de andere kant kan ook (Wowhead-reactie over Ta'zo), dus
    "elk van de 40 in je tassen" is goed.
- **1948 sticks** (r. 1585):
  - GEMETEN (Wowhead Forever): "Witherbark Totem Stick x 10". 7273 = de stick, 7272 = Bolt Charged Bramble.
  - `count` hoort bij het eerste item (7273). Dat klopt.
  - Zit de bramble al in je tassen, dan telt het sticks-doel als klaar. Dat vangt het op als de sticks bij de steen
    opgaan.
- **7637** (r. 1327):
  - GEMETEN: Money:150. Spoken: ender 11406 Rohan.
  - Het seintje komt in Stormwind, vóór de reis.
  - Het goud gaat er pas af bij het inleveren, dus het probleem "goud op na het kopen" speelt hier niet.
- **7625 / 7623, de data**:
  - GEMETEN: 18687 kost 150 g per 1 stuk. Na het kopen slaat `unlessItem` de check over. 18802 heet "Shadowy Potion".
  - `unlessMap = 1448` werkt, want Felwood heeft in Forever geen onderliggende UiMap. GEMETEN: ParentUiMapID=1448 gaf
    0 rijen; positieve controle 1413 gaf 1 rij. Dat je in Shadow Hold dus op 1448 blijft is AFGELEID.
- **Logica**: ik vond geen runtime-fout.
  - Elke gebruikte local staat boven zijn aanroep.
  - BookStep zit in een pcall. PreStep niet, maar doet alleen veilige aanroepen.
  - Het aantal %s is in alle 8 packs gelijk (2/2/3). GEMETEN met grep.
  - NearestBook valt terug op list[1] als je positie of continent onbekend is.
  - Bij UnitFactionGroup wordt alleen de eerste waarde gebruikt.
- **Overige item-id's in de doelen kloppen** (GEMETEN ItemSparse):
  - 15877, 15882, 15883, 15885, 6799, 6805, 263993, 6851, 6894, 7067-7070, 7968, 7970.
  - 4479-4481: 1714 vraagt 8 van elk.
  - De tomes 6775, 6916 en 6776 starten 1642, 1646 en 1649.
- **Aantallen in de teksten tegen Forever-Requirements**: alle gecontroleerde aantallen kloppen (GEMETEN).
  - 7563: 30. 7626: 10. 7627: 6 + 25. 7628: 35. 7630: 3.
  - 7642: 5/10/40/6. 1712: 8/30.
  - 82084: 1/5/8. 8251: 10. 8252: 6. 9364: 50.
  - 1921 en 1961: 6 + 10. 1940: 8. 1945: 12.

## Kort, in gewone taal

- Het nieuwe blok werkt zoals bedoeld. De boeken, de bibliothecarissen en de plekken kloppen met Wowhead Forever.
- Er zijn twee echte gaten:
  1. **7642 (paladin):** ook daar moet je 150 goud betalen, en daar waarschuwt MH niet.
  2. **7625 (warlock):** het goud-seintje komt pas als je al onderin Shadow Hold staat. Dan is de reis al gemaakt. Het
     moet al bij 7623 komen.
- Bijna zeker mist er nog één: bij het laatste warlock-ritueel (7631) moet je eerst drie dingen kopen voor 250 goud.
- Kleinere punten:
  - De potionprijs: het is waarschijnlijk 6 goud voor 3 stuks, niet per stuk.
  - Potions zijn ook nodig bij 7624 en 7625.
  - De priester kan vastlopen als Rank 3 Rank 2 verdringt.
  - De Study-tekst zegt "gratis", maar het kost een Light Feather.
  - In het Duits heet de quest "Forscherzugang".
