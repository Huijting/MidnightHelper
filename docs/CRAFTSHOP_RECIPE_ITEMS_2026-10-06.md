# Recept-items: van item naar recipeID (6 okt 2026)

Onderzoek door mh-research. Niets aan code of locales veranderd.
Bronnen:
- **wago DB2, build 12.1.0.69933** (live retail sinds 22 sep 2026, volgens `wago.tools/api/builds`, gelezen 6 okt).
- **Blizzard UI-code, Gethe wow-ui-source `live`**, commit `09b9db7`, "12.1.0 (69933)", 22 sep 2026. Dus dezelfde build.
- **Robs SavedVariables**, `craftShopMeasure.open.api` (145 namen uit `C_TradeSkillUI`).
- **Wowhead**, 6 okt 2026, alleen als controle.

Bij elke bewering staat **GEMETEN** (gezien in een bron met naam en datum) of **AFGELEID** (beredeneerd).

## Het korte antwoord

1. **Kan de client het zelf?** Dat weten we nog niet. Er is geen functie die het zeker doet. Er zijn twee
   kandidaten. Rob kan ze met twee `/run`-regels testen (zie hieronder).
2. **De tabel** staat in `data/craftshop_recipe_items.tsv`. Er staan **298 recept-items** in met naam en recipeID.
   Er staan nog 6 items zonder naam bij, en 10 regels waarvan het item niet in de data zit. Alle controles kloppen.
3. **Advies:** gebruik de tabel. Gebruik de client alleen als extra, en alleen als de meting laat zien dat het werkt.

## Vraag 1: kan de client het zelf?

### Wat Blizzard zelf doet
- In de Lua-code van Blizzard staat **geen** regel voor recepten. "Already known" en het voorbeeld van wat je
  maakt komen kant-en-klaar uit de client (C++). De Lua zet alleen de regels op het scherm
  (`TooltipDataHandlerMixin:ProcessLines`). **GEMETEN.** Ik heb 1893 Lua-bestanden (Mainline en Shared)
  doorzocht. Controle dat het zoeken werkt: `AddLinePostCall` gaf wel treffers. `ITEM_SPELL_KNOWN` staat alleen
  in `Blizzard_TrainerUI.lua:264`.
- Een tooltip-regel kent wel soorten. `Enum.TooltipDataLineType` heeft `LearnableSpell = 6` en
  `ItemSpellTriggerLearn = 38`. `TooltipDataUsageRequirementType` heeft `NotAlreadyKnown = 14`. **GEMETEN**
  (`TooltipInfoSharedDocumentation.lua`).
- Of zo'n regel ook een **spellID** meedraagt, is niet bekend. Geen enkele Blizzard-regel leest dat. Bij
  `LearnableSpell` leest Blizzard alleen `lineData.spellIcon`. **GEMETEN** (`TooltipDataRules.lua:48`). Dus:
  **KANDIDAAT.**

### Wat er in de data van een recept-item zit
Elk van de 304 Midnight-recept-items die een Item-rij hebben, heeft precies twee effecten. **GEMETEN-DB2**
(`ItemEffect` + `ItemXItemEffect`):
- slot 0: spell **483 "Learning"**, bij gebruik (TriggerType 0);
- slot 1: **het recept zelf**, als "leer"-effect (TriggerType 6).

Spell 483 heeft één effect: "Learn Spell" (36) zonder vast doel. Hij leert dus "de spell van het item".
**GEMETEN-DB2** (`SpellEffect`). Geen enkel Midnight-recept-item gebruikt een tussen-spell. **GEMETEN-DB2.**

### De kandidaten
| route | wat het is | verwachting | status |
|---|---|---|---|
| `C_Item.GetItemSpell(itemID)` | geeft naam + spellID terug | waarschijnlijk 483 "Learning" (de "Use"-spell), dus nutteloos | **AFGELEID**, niet gemeten |
| `C_Item.GetFirstTriggeredSpellForItem(itemID, quality)` | geeft één spellID | onbekend: 483 of het recept | **KANDIDAAT.** Blizzard gebruikt hem alleen voor "equipable spells" (`AlertFrameSystems.lua:439`) |
| `C_TooltipInfo.GetItemByID(itemID)` | de tooltip-regels als tabel | misschien een veld met de spellID in regel-soort 38 of 6 | **KANDIDAAT** |
| `C_TradeSkillUI` | Robs 145 namen | geen functie van item naar recept | **GEMETEN** (lijst in de SV gelezen). `GetRecipeItemLink` en `GetOriginalCraftRecipeID` gaan de andere kant op (**AFGELEID** uit de naam) |
| tekst "Already known" | regel in de tooltip | zegt het alleen voor het personage dat speelt | **AFGELEID** |

### Waar MH de tooltip kan haken
- `TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, fn)`. In `data.id` staat het itemID.
  **GEMETEN** in de bron: `TooltipUtil.GetDisplayedItem` leest `tooltipData.id`.
- Tas, veilinghuis, chat-link en verkoper lopen allemaal via `C_TooltipInfo`: `SetBagItem`, `SetItemKey`,
  `SetHyperlink` en `SetMerchantItem` (`TooltipDataHandler.lua` regel 523-590). **GEMETEN.** Het venster van een
  chat-link (`ItemRefTooltip`) gaat door dezelfde verwerker (`TooltipDataRules.lua`, `AccountForCloseButtonOnItems`).
  **GEMETEN.**
- MH haakt item-tooltips al op die manier in `Modules/LootUpgrade.lua:73`. **GEMETEN.**

### De meting (voor Rob, buiten gevecht)
Item 256636 = *Pattern: Row Walker's Deflectors*. Het recept is **1237486**. Draai elke regel twee keer, want de
eerste keer is het item soms nog niet geladen.

Regel A (130 tekens):
```
/run local i=256636 print(C_Item.GetItemSpell(i)) print(C_Item.GetFirstTriggeredSpellForItem(i,C_Item.GetItemQualityByID(i) or 1))
```
Regel B (178 tekens):
```
/run for n,l in ipairs(C_TooltipInfo.GetItemByID(256636).lines) do local s="" for k,v in pairs(l) do if type(v)~="table" then s=s..k.."="..tostring(v).." " end end print(n,s) end
```
Wat telt:
- Regel A noemt **1237486** → die functie geeft het recept.
- Regel A noemt alleen **483 / Learning** → die functie is nutteloos.
- Regel B toont een regel met `type=38` of `type=6` én een getal **1237486** (bv. `spellID=1237486`) → de tooltip
  geeft het recept.

Is één van de drie raak, laat de bouwchat dan een probe maken. Die loopt alle items uit de tabel langs en telt
hoe vaak de client hetzelfde recipeID geeft als de tabel. Schrijf dat naar `ns.db`. Pas dan is het GEMETEN voor
alle items, en niet voor één.

## Vraag 2: de tabel

**Bestand:** `data/craftshop_recipe_items.tsv`.
Kolommen: `itemID`, `item name`, `recipeID`, `recipe name`, `profession`, en ook `skillLineID`, `itemClass`,
`requiredSkill`, `status`.

### Hoe hij gemaakt is (GEMETEN-DB2, 12.1.0.69933)
1. De recepten van Midnight: `SkillLineAbility` met **`SkillupSkillLineID` 2906-2918**. Dat zijn 1041 spells.
   Let op: de kolom `SkillLine` bevat het basisberoep (bv. 171), niet 2906.
2. Daarna de items: `ItemEffect` met TriggerType 6, waarvan de spell een van die 1041 is. Via `ItemXItemEffect`
   kom je bij het item.
3. De namen komen uit `ItemSparse` en `SpellName`.

### Hoeveel
| status | aantal |
|---|---|
| GEMETEN-DB2 (item, naam en recept compleet) | **298** items, samen **297** recepten |
| GEMETEN-DB2, maar het item heeft geen naam in `ItemSparse` | 6 |
| alleen een koppelregel, geen Item-rij (niet uitgebracht of versleuteld) | 10 |

Per beroep (alleen de 298 complete items):

| beroep | items |
|---|---|
| Alchemy | 14 |
| Blacksmithing | 46 |
| Cooking | 8 |
| Enchanting | 38 |
| Engineering | 27 |
| Fishing | 7 |
| Inscription | 37 |
| Jewelcrafting | 31 |
| Leatherworking | 55 |
| Tailoring | 35 |
| Herbalism, Mining, Skinning | 0 |

Herbalism, Mining en Skinning hebben geen recept-items. **GEMETEN-DB2** (dezelfde zoekvraag vindt de andere tien wel).

Twee recepten hebben twee items. *Sweet-And-Sour Skewers* (275273 en 278331) zijn allebei compleet. Bij de
andere is één van de twee item-ID's naamloos of zonder Item-rij.

### Controles
- **Wowhead, 6 okt 2026.** Elk item gezocht op naam. De "Use"-regel linkt naar dit recept:
  - 256636 *Pattern: Row Walker's Deflectors* → 1237486. Klopt.
  - 275275 *Recipe: Ersatz Venom Splatter* → 1296429. Klopt.
  - 256759 *Formula: Enchant Weapon - Flames of the Sin'dorei* → 1236094. Klopt.
  - Extra: 278331 *Recipe: Sweet-And-Sour Skewers* → 1296419. Klopt.
- **Een tweede kolom zegt hetzelfde.** In `ItemSparse.RequiredSkill` vragen precies 298 recept-items (klasse 9)
  om een Midnight-beroep. Alle 298 staan in de tabel. Bij geen één verschilt het beroep. **GEMETEN-DB2.**
- **Klopt het met de plekken-tabel?** `data/craftshop_recipe_places.tsv` komt uit een andere DB2-tabel
  (`SourceInfo`). Elk recept dat je daar bij een verkoper, als drop, in een delve, dungeon, raid, quest, schat of
  vis-fles haalt, heeft een item in deze tabel. Bij verkopers is dat 215 van 215. De 24 trainer-recepten hebben
  géén item, en dat hoort zo. **GEMETEN.**
- **Is recipeID wel wat MH bewaart?** In Robs SV staat geleerd recipeID 1237504. In DB2 is dat
  `SkillLineAbility.Spell` 1237504, beroep 2915. MH bewaart het als `ns.db.craftShopKnown[guid].recipes[recipeID]`
  (`Modules/CraftShoppingList.lua:234`). **GEMETEN.**
- **Is het overtypen goed gegaan?** De hash, het aantal tekens en de sommen van de ID's van het bestand op schijf zijn
  gelijk aan wat de browser uitrekende. **GEMETEN.**

### Wat er niet in zit
- **15 items** met een recept-klasse kunnen in deze build niet opgelost worden. Ze hebben geen naam, en hun recept
  staat niet in de data (of ze hebben helemaal geen leer-effect): 238406, 238683, 239081, 239087, 239091, 239096,
  245754, 256648, 256651, 258508, 258511, 275277, 275279, 275322, 275330. **GEMETEN-DB2.**
  Hun ID's zitten precies tussen Midnight-recepten in (bv. 256648 en 256651 tussen de Leatherworking-patterns,
  275277 naast *Ersatz Venom Splatter*). Dus waarschijnlijk zijn het verborgen Midnight-recepten. **AFGELEID.**
  Wowhead kent 275277 ook niet. **GEMETEN.**
- Komt er een nieuwe patch, dan moet de tabel opnieuw gemaakt worden. **AFGELEID.**

### Van beroep naar basisberoep (voor "heeft het beroep, maar niet het recept")
MH bewaart `profs[skillLine]` van `GetProfessionInfo`. Dat is waarschijnlijk het basisberoep. **AFGELEID.**
`SkillLine.ParentSkillLineID` (**GEMETEN-DB2**):
2906→171 Alchemy, 2907→164 Blacksmithing, 2908→185 Cooking, 2909→333 Enchanting, 2910→202 Engineering,
2911→356 Fishing, 2912→182 Herbalism, 2913→773 Inscription, 2914→755 Jewelcrafting, 2915→165 Leatherworking,
2916→186 Mining, 2917→393 Skinning, 2918→197 Tailoring.

## Advies

1. **Neem de tabel als basis.** Maak er een Lua-lijst van, `{ [itemID] = recipeID }`, zoals
   `tools/gen_craftshop_places.py` dat voor de plekken doet. Neem de 298 complete items en de 6 naamloze.
   De 10 zonder Item-rij mogen erbij; ze doen geen kwaad. Haak de item-tooltip (`AddTooltipPostCall`, zoals
   `LootUpgrade.lua`). Zoek `data.id` op in de lijst. Zet daaronder welke personages in `ns.db.craftShopKnown` dat
   recipeID hebben.
2. **Laat Rob eerst regel A en B draaien.** Geeft één route 1237486, dan kan de client de gaten vullen: de 15
   verborgen items en nieuwe items na een patch. Geeft geen enkele route het recept, gebruik dan alleen de tabel.
3. **Lees geen tooltip-tekst** zoals "Teaches you how to craft …". Die tekst staat in de taal van de speler, en de
   naam van het item is niet altijd de naam van het recept (bv. 256754 *Formula: Enchant Shoulders - Nature's
   Embrace* leert *Illusory Adornment - Nature's Embrace*). **GEMETEN-DB2.**
