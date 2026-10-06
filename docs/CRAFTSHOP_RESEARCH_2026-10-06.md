# Boodschappenlijst voor beroepen: wat kan er nog bij? (6 okt 2026)

Onderzoek voor `/mh craftshop` (`Modules/CraftShoppingList.lua`). De kop van dat bestand zegt: "Not in v1: which
rank to buy, reagents you craft yourself, vendor reagents, where to farm." Rob wil alle vijf. Hier staat per punt
wat de game zelf kan vertellen, wat wij als data moeten meeleveren, en hoe groot het werk is.

Geen code veranderd. Alleen gelezen.

## Hoe je dit leest

- **GEMETEN** = met eigen ogen gezien in een genoemde bron, met datum of buildnummer.
- **AFGELEID** = beredeneerd. Kan kloppen, is niet gecontroleerd.
- **KANDIDAAT** = staat in een andere addon of op een wiki. Dat is een spoor, geen bewijs.
- **ONBEKEND** = niet kunnen meten. Staat er expres bij, zodat het niet leest als "in orde".

## De bronnen

| Bron | Versie / datum | Wat het is |
|---|---|---|
| Blizzard UI-broncode | Gethe/wow-ui-source, branch `live`, commit `09b9db79`, "12.1.0 (69933)", 22 sep 2026 | Blizzards eigen Lua + gegenereerde API-documentatie |
| wago.tools DB2 | build **12.1.0.69933**, enUS, gelezen 6 okt 2026 | Blizzards eigen speldata (ItemSparse, GlobalStrings) |
| SavedVariables van Rob | `WTF/.../MidnightHelper.lua`, gelezen 6 okt 2026 | wat MH zelf in het spel heeft opgeslagen |
| Zygor (lokaal) | ZygorGuidesViewer 9.6, `ZygorProfessionsCommonMID.lua` | KANDIDAAT. TOC zegt `X-License: GPL`, maar het is een betaald product |
| HandyNotes_Midnight (lokaal) | versie 156 | KANDIDAAT |
| Wowhead | gelezen 6 okt 2026 | KANDIDAAT, toont wel Blizzards eigen itemtekst |
| warcraft.wiki.gg | pagina's zonder datum | KANDIDAAT |
| CurseForge / GitHub | gelezen 6 okt 2026 | voor de vergelijking met andere addons |

⚠️ Exa gaf voor twee CurseForge-pagina's een **oude kopie** (Profession Shopping List: "updated 22 days ago" bij
een update van 24 apr, dus een kopie van half mei; GatherMate2: kopie van rond juli). Daar staat de GitHub-datum
naast. Zie CLAUDE.md over Exa-caches.

---

## Wat MH al heeft (eerst gekeken)

| Wat | Waar | Status |
|---|---|---|
| Per beroep de handelaar naast de trainer en wat hij verkoopt (Melaris: Sunglass Vials, Oil of Heartwood; Lyna: Refulgent Copper Rods; enzovoort) | `Locales/enUS.lua` regels 3677-3685, `PROFGUIDE_LVL_*` | GEMETEN. Alleen **tekst**, geen item-ID's |
| Waar kruiden, erts en leer groeien ("alle vijf kruiden in alle vier de gebieden"; leer Eversong, schubben Zul'Aman) | `Modules/ProfessionGuidedData.lua` regels 118-169 | GEMETEN. Bron: Zygor-**titels**. Rob trok daar de grens: geen route, geen waypoint, geen zin van Zygor overnemen |
| Uitleg over kwaliteit, Concentration, stats | Academy-hoofdstukken `PROFACAD_CH_QUALITY_*`, `_CONC_*`, `_STATS_*` | GEMETEN. Algemene uitleg, niet per recept |
| Uitleg waar recepten vandaan komen (5 bronnen) | `PROFACAD_CH_RECIPES_BODY` | GEMETEN. Algemene uitleg |
| Probe die de bron-tekst van niet-geleerde recepten uitleest | `/mh unlearned` → `ns.PrintUnlearnedProbe` (`Modules/Profession.lua` 2211-2373) | GEMETEN dat de code bestaat. De uitkomst (`ns.db.unlearnedDump`) staat **niet meer** in Robs SavedVariables (grep: 0 treffers; dezelfde grep vond `craftShopProbe` wel) |

Conclusie: MH heeft het **verhaal** al (handelaars, plekken, kwaliteit, bronnen), maar niet als **data per item**.
De boodschappenlijst kan die bestaande tekst hergebruiken.

---

## Punt 1: spul van de handelaar

**Wat de client zegt**

- Er is **geen vlag** "te koop bij een handelaar". GEMETEN in 12.1.0 (69933): de struct `CraftingReagent` heeft
  alleen `itemID` en `currencyID` (`TradeSkillUITypesDocumentation.lua`). `ItemDocumentation.lua` heeft geen
  bron-veld (wel `sellPrice` en `isCraftingReagent`; positieve controle: `Merchant` vond wel een treffer).
  `TooltipDataLineType` heeft 50 regelsoorten; de enige "bron"-regel is `ToySource`, alleen voor speelgoed.
- Blizzards beroepsvenster markeert handelaar-spul **niet**. GEMETEN in `Blizzard_Professions.lua` en
  `Blizzard_ProfessionsRecipeReagentSlot.lua` (12.1.0): de tooltip van een reagent is de gewone item-tooltip plus
  de kwaliteitskeuze.
- ✅ **Wel: Blizzards eigen itembeschrijving zegt het vaak.** GEMETEN in wago ItemSparse 12.1.0.69933,
  kolom `Description_lang`. Voorbeelden:
  - Sunglass Vial 240991: "Purchased from tradeskill vendors. Jewelcrafters can also craft this item…"
  - Luminant Flux 243060: "…Sold by Blacksmithing vendors."
  - Tranquility Bloom 236761: "Gathered by players with the Herbalism skill."
  - Void-Tempered Leather 238511: "Acquired by players with the Skinning skill."
  - Refulgent Copper Ingot 238197: "Smelted by players with the Blacksmithing skill."
- ⚠️ Maar **niet altijd**. GEMETEN: Refulgent Copper Rod 244174 zegt alleen "it serves as a runed enchanting rod",
  terwijl Zygor hem bij een handelaar laat kopen (`buy 30 Refulgent Copper Rod##244174`).
- ⚠️ De tekst is per taal anders (wago toont enUS; de client toont de eigen taal, AFGELEID). Woorden zoeken in
  de tooltip werkt dus niet in 7 talen. Een lijst met ID's wel.
- Welke NPC wat verkoopt staat **niet** in de clientdata. AFGELEID: handelaar-voorraden komen van de server;
  Wowhead verzamelt ze door te kijken.

**Midnight-handelaarspul: de lijst** (item-ID's)

GEMETEN = de beschrijving in wago 12.1.0.69933 zegt "vendor" of "purchase(d)". Filter: `Description_lang`
bevat "vendor" of "purchase", `ExpansionID = 11`.

| ID | Naam | Beroep (AFGELEID uit tekst/Zygor) | Bron |
|---|---|---|---|
| 240991 | Sunglass Vial | Alchemy, ook Enchanting (Zygor) | GEMETEN (wago) + KANDIDAAT Zygor `buy` |
| 240990 | Sunglass Vial (hogere rang) | — | GEMETEN (wago): "Jewelcrafters can craft this item at high qualities. Can be purchased from a vendor at lower quality." |
| 247811 | Oil of Heartwood | Alchemy | GEMETEN (wago): "Can be purchased from Alchemy suppliers" |
| 243060 | Luminant Flux | Blacksmithing | GEMETEN (wago) |
| 242641 | Cooking Spirits | Cooking | GEMETEN (wago) |
| 242642 | Thalassian Herbs | Cooking | GEMETEN (wago) |
| 242643 | A Big Ol' Stick of Butter | Cooking | GEMETEN (wago) |
| 242644 | Mana-Wyrm Essence | Cooking | GEMETEN (wago) |
| 242645 | Ripened Vegetable Assortment | Cooking | GEMETEN (wago) |
| 242646 | Pouch of Spices | Cooking | GEMETEN (wago) |
| 242647 | Tavern Fixings | Cooking | GEMETEN (wago) |
| 245881 | Lexicologist's Vellum | Inscription | GEMETEN (wago) |
| 245882 | Thalassian Songwater | Inscription | GEMETEN (wago) |
| 251665 | Silverleaf Thread | Tailoring, Leatherworking (Zygor) | GEMETEN (wago) |
| 251691 | Embroidery Floss | Tailoring | GEMETEN (wago) |
| 253302 | Malleable Wireframe | Engineering | GEMETEN (wago) |
| 253303 | Pile of Junk | Engineering | GEMETEN (wago) |
| 244174 | Refulgent Copper Rod | Enchanting | KANDIDAAT (alleen Zygor `buy`; beschrijving zegt het niet) |
| 245345 / 274267 | Fused Vitality | — | GEMETEN (wago): te koop bij Chel the Chip of Depthdiver Tu'nakit. ⚠️ voor een **valuta**, niet voor goud |

Niet in de lijst, wel genoemd in MH-tekst: Enchanting Vellum (handelaar Lyna). Item-ID **ONBEKEND**; niet verzonnen.

Let op: Carving Canine 238523 en Fantastic Fur 238525 hebben in Robs lijst maar één item-ID per slot, maar zijn
**geen** handelaarspul (Zygor: `collect`, niet `buy`). Eén ID betekent dus niet "handelaar". AFGELEID uit Blizzard:
één ID = `ReagentInputMode.Fixed` (geen rangen), meer ID's = `Quality` (`Professions.GetReagentInputMode`, GEMETEN).

**Wat we moeten meeleveren:** een klein lijstje `itemID → beroep` (± 20 regels). Bij een patch opnieuw draaien
tegen wago (zelfde filter).

**Grootte:** klein. AFGELEID.

---

## Punt 2: tussenproducten (iets dat je zelf maakt)

**Wat de client zegt**

- Er is **geen gedocumenteerde functie** "welk recept maakt item X". GEMETEN: niet in
  `TradeSkillUIDocumentation.lua` 12.1.0. ⚠️ Een leeg zoekresultaat bewijst niets: die documentatie is niet
  compleet. Blizzard roept zelf functies aan die er niet in staan (`GetFilteredRecipeIDs`, `IsTradeSkillReady`,
  `SetRecipeItemNameFilter`, `IsAnyRecipeFromSource`, …), GEMETEN in `Blizzard_Professions.lua`; en
  `GetRecipeSourceText` in `Blizzard_ProfessionsRecipeSchematicForm.lua`. `GetAllRecipeIDs` staat ook niet in de
  docs; dat hij bestaat weten we alleen uit MH's eigen probe (aantekening in `Profession.lua`, 30 aug: "316").
  Zekerheid krijg je alleen met een meting in het spel: alle namen in `C_TradeSkillUI` opsommen.
- ✅ **De andere kant op kan wel**: per recept het product.
  - `C_TradeSkillUI.GetRecipeSchematic(recipeID, false).outputItemID` (GEMETEN in de docs).
  - `C_TradeSkillUI.GetRecipeInfo(recipeID).qualityItemIDs` en `GetRecipeQualityItemIDs(recipeID)` voor
    producten met rangen (GEMETEN in de docs).
  - `GetRecipeOutputItemData(recipeID).itemID` (GEMETEN in de docs).
  - Dus: lijst van alle recepten → per recept het product → een tabel `productID → recept`. Dan weet je per
    reagent: "dit kun je zelf maken".
- **Werkt het met het venster dicht?**
  - `GetRecipeSchematic`: waarschijnlijk wel. AFGELEID, maar sterk: Blizzards eigen objective tracker roept het aan
    terwijl het beroepsvenster niet eens geladen hoeft te zijn (`Blizzard_ProfessionsRecipeTracker.lua`,
    `LayoutContents` en `AddRecipe`).
  - De lijst van alle recepten (`GetAllRecipeIDs`): alleen met het venster open. Dat zegt de MH-code zelf
    (`Profession.lua` 2205: "C_TradeSkillUI answers about the open trade skill and nothing else", 30 aug).
    Blizzard zelf vraagt in `Blizzard_Professions.lua` (regel 281) eerst `IsTradeSkillReady()` voordat het
    beroepsinfo gebruikt. Een aantekening plus een aanwijzing, geen meting van vandaag.
  - Oplossing (AFGELEID): bij het openen van het venster de tabel `productID → recept` bouwen en per personage
    bewaren. Precies zoals de boodschappenlijst nu al de reagents bewaart.
- Blizzards tracker doet dit **niet**: hij toont alleen de reagents van het recept zelf (GEMETEN, code hierboven).

**Hoeveel lagen in Midnight-alchemie?** KANDIDAAT (warcraft.wiki.gg "Midnight alchemy recipes" + Wowhead-gids,
zonder datum; de receptdata in het spel beslist):

- Een decor-recept (bv. Silvermoon Spire Fountain) vraagt **Composite Flora** + **Wondrous Synergist** (beide
  alchemie).
- Composite Flora (recept 1230855, item 241280) vraagt **Mote of Wild Magic**. Die kun je plukken, maar ook
  transmuteren (Transmute: Mote of Wild Magic, recept 1230887). Wowhead toont Composite Flora: 4 Mote of Wild
  Magic, 4 Mote of Primal Energy, 6 Tranquility Bloom, 4 Argentleaf; maakt er 2 per keer.
- De transmute vraagt **Stabilized Derivate** (242651), en die komt uit Recycle Potions, dus uit drankjes die
  je eerst brouwt.
- Dat is tot **3-4 lagen** diep als je alles zelf maakt. Bij gewone flesjes (Flask of the Blood Knights enz.) is
  het 0-1 laag: kruiden, Nocturnal Lotus, een mote, Sunglass Vial.
- ⚠️ Ook **over beroepen heen**: Sunglass Vial koop je, maar een Jewelcrafter kan hem maken (GEMETEN, wago-tekst).
  Leatherworking-hoeden vragen Composite Flora van de alchemist (KANDIDAAT, Wowhead-gids).
- ⚠️ Rondjes zijn mogelijk (motes transmuteren in elkaar). Wie dit uitklapt moet een rondje kunnen herkennen.
  AFGELEID.
- ⚠️ Opbrengst telt mee: Composite Flora geeft 2 per keer, dus voor 4 stuks maar 2 keer maken. De lijst bewaart
  `quantityMin`/`quantityMax` al.

**Wat we moeten meeleveren:** niets. De client heeft het, mits het venster één keer open is geweest.

**Grootte:** middel. AFGELEID.

---

## Punt 3: welke kwaliteit kopen

**Wat de client zegt** (alles GEMETEN in de 12.1.0-documentatie, tenzij anders gezegd)

- Midnight-reagents hebben **twee** rangen. GEMETEN in Robs SavedVariables: Void-Tempered Leather heeft 2 ID's
  (238511, 238512), Void-Tempered Scales ook (238513, 238514). GEMETEN in wago: Tranquility Bloom bestaat als
  236761 én 236767. Blizzard heeft een aparte tekst voor "2 kwaliteiten gemengd"
  (`PROFESSIONS_ALLOCATIONS_TOOLTIP_2`).
- `C_TradeSkillUI.GetCraftingOperationInfo(recipeID, craftingReagents, allocationItemGUID, applyConcentration)`
  geeft o.a.: `baseSkill`, `bonusSkill`, `baseDifficulty`, `bonusDifficulty`, `craftingQuality`,
  `lowerSkillThreshold`, `upperSkillTreshold` (met die typfout), `concentrationCost`, `ingenuityRefund`.
  Blizzards eigen venster rekent hiermee de kwaliteitsbalk uit (`Blizzard_ProfessionsRecipeSchematicForm.lua`
  regel 283-299, `Blizzard_ProfessionsRecipeCrafterDetails.lua`).
- `GetRecipeInfo(recipeID)` geeft `supportsQualities`, `maxQuality`, `qualityIDs`.
  `GetRecipeItemQualityInfo(recipeID, kwaliteit)` geeft de icoontjes.
- `GetConcentrationCurrencyID(skillLineID)` geeft de valuta waarmee je kunt zien hoeveel Concentration er is.
- Blizzard heeft al een vinkje "Use Best Quality Reagents" (`Professions.ShouldAllocateBestQualityReagents`).

**Kunnen we per recept zeggen "rang 1 geeft X, rang 2 geeft Y" voor dit personage?**

- AFGELEID: ja, door `GetCraftingOperationInfo` twee keer te vragen: één keer met alles rang 1, één keer met alles
  rang 2 (en eventueel nog eens met Concentration aan). Dat is wat Blizzards venster doet bij elke klik.
- **ONBEKEND, eerst meten:**
  1. Werkt het met het venster dicht?
  2. Accepteert de client reagents die je niet in je tas hebt? (Blizzards venster stuurt alleen wat je bezit.)
  3. Werkt het voor een recept dat je nog niet kent?
- Meting: een `/mh craftshop quality`-probe die voor elk recept op de lijst beide uitkomsten naar
  `ns.db.craftShopQuality` schrijft, met venster open én dicht. Dan `/reload` en het bestand lezen.

**Eerlijke uitleg voor een beginner** (voorstel, AFGELEID uit de API hierboven):

> Elk recept heeft een moeilijkheid. Jouw skill moet daarboven komen voor de betere uitkomst.
> Betere materialen (rang 2) tellen mee als extra skill. Goedkope materialen (rang 1) niet.
> Voor dit recept, met jouw skill: met rang 1 krijg je ◆, met rang 2 krijg je ◆◆.
> Kom je net tekort? Dan kan Concentration het laatste stukje overbruggen (kost N).
> Verkoop je het niet en maakt kwaliteit niet uit? Koop dan rang 1.

**Wat we moeten meeleveren:** niets, behalve de uitlegtekst. De Academy heeft het algemene verhaal al.

**Grootte:** middel als de meting meevalt; groot als het alleen met venster open werkt. AFGELEID.

---

## Punt 4: waar farmen

**Wat de client zegt**

- Er is **geen** API voor plekken van kruiden of erts. AFGELEID; geen functie gevonden in de documentatie, en een
  leeg resultaat bewijst niets. Wel zeker: geen tooltipregel voor "bron" bij items (GEMETEN, zie punt 1).
- De itembeschrijving zegt wel **met welk beroep** (GEMETEN, wago 12.1.0.69933): "Gathered by players with the
  Herbalism skill", "…Mining skill", "Acquired by players with the Skinning skill". Geen gebied.
  Uitzondering: Nocturnal Lotus 236780 "Found rarely amongst the other herbs of Midnight".

**Wat de lokale addons hebben**

- **Zygor** (KANDIDAAT, `ZygorProfessionsCommonMID.lua`): farm-gidsen mét item-ID's.
  - Kruiden, alle vijf in alle vier de gebieden: Sanguithorn 236770/236771, Azeroot 236774/236775, Mana Lily
    236778/236779, Tranquility Bloom 236761/236767, Argentleaf 236776/236777.
  - Erts, alle drie in alle vier de gebieden: Refulgent Copper 237359/237361, Umbral Tin 237362/237363,
    Brilliant Silver 237364/237365.
  - Leer: Void-Tempered Leather 238511/238512 (Eversong Woods), Void-Tempered Scales 238513/238514 (Zul'Aman).
  - Vis: 20 farm-gidsen (bv. Sunwell Fish 238384, Eversong Trout 238383, Null Voidfish 238380).
  - De gidsen zelf zijn routes met coördinaten. Die nemen we **niet** over (Robs grens, zie "Wat MH al heeft").
- **HandyNotes_Midnight 156** (GEMETEN): **geen** plukplekken. Alleen kennis-schatten voor Herbalism en Mining
  (bv. "Peculiar Lotus", quest 89156). Positieve controle: zoeken op "Herbalism" vond die wel, zoeken op de
  kruid-ID's vond niets.
- Wowhead "Fishing Locations" bij Void-Tempered Leather is vreemd (leer uit vissen?). Niet gebruiken zonder
  controle.

**Wat we moeten meeleveren:** een klein lijstje `itemID → beroep + gebieden`, gebouwd uit de feiten die MH al
heeft (kruiden/erts: "alle vier de gebieden"; leer: "begin in Eversong", schubben: "begin in Zul'Aman"). Geen
kaart, geen route.

**Grootte:** klein als we bij een zin per reagent blijven. Groot (en een licentievraag) als we kaartpunten willen.
Dat laatste doet GatherMate2 al. AFGELEID.

---

## Punt 5: recepten krijgen

**Wat de client zegt**

- ✅ `C_TradeSkillUI.GetRecipeSourceText(recipeID)` bestaat. GEMETEN: Blizzards eigen venster roept hem aan in
  12.1.0 (`Blizzard_ProfessionsRecipeSchematicForm.lua` regel 629-653): bij een niet-geleerd recept onder de kop
  `TRADESKILL_UNLEARNED_RECIPE_HEADER`, en bij een geleerd recept voor de **volgende rang**
  (`recipeInfo.nextRecipeID`, kop `TRADESKILL_NEXT_RANK_HEADER`).
  ⚠️ Hij staat **niet** in de gegenereerde documentatie. MH-code meldt dat hij op Robs build bestond
  (`Profession.lua` 2302, aantekening 30 aug).
- `GetRecipeInfo(recipeID).sourceType` is een getal (GEMETEN in de docs). Blizzard toont de bijbehorende naam in
  het filtermenu "Sources" via `_G["BATTLE_PET_SOURCE_" .. n]` (GEMETEN, `Blizzard_Professions.lua` regel
  1286-1294). De teksten (GEMETEN, wago GlobalStrings 12.1.0.69933): 1 Drop, 2 Quest, 3 Vendor, 4 Profession,
  5 Pet Battle, 6 Achievement, 7 World Event, 8 Promotion, 9 Trading Card Game, 10 In-Game Shop, 11 Discovery,
  12 Trading Post.
- **Gelokaliseerd?** De bron-tekst: AFGELEID ja. Blizzard toont hem rechtstreeks in elke taal, zonder vertaling
  ernaast. Het type: ja, het zijn GlobalStrings (GEMETEN dat het GlobalStrings zijn).
- **Werkt het voor alle recepten?** ONBEKEND. De probe `/mh unlearned` telt dit al ("X of the Y say where they
  come from"), maar de uitkomst staat niet meer in de SavedVariables. Eén keer opnieuw draaien met het venster open
  geeft het antwoord.
- **Werkt het met het venster dicht?** ONBEKEND. Blizzard roept hem alleen aan met het venster open.
  Oplossing (AFGELEID): op het moment van "+ op je lijst" de bron-tekst ophalen en bij het recept bewaren, net als
  de reagents.

**Wat Midnight-recepten als bron hebben** (KANDIDAAT, Wowhead-gids alchemie en warcraft.wiki.gg): trainer,
specialisatie (Knowledge), Camberon's Cauldron (ontdekken na een craft-opdracht, betalen met Moxie en Stabilized
Derivate), renown, handelaar voor een valuta. MH legt die vijf soorten al uit in `PROFACAD_CH_RECIPES_BODY`.

**Wat we moeten meeleveren:** niets. Alleen de koppeling naar het Academy-hoofdstuk.

**Grootte:** klein. AFGELEID.

---

## Bestaat er al iets? (de vraag van Rob)

### Blizzards eigen beroepsvenster (12.1.0, GEMETEN in de code)

- **Track recipe**: ja. Toont in de objective tracker "heb/nodig" per reagent, alle rangen samen
  (`AccumulateReagentsInPossession`). Maar voor **één** craft, per recept een apart blok, niet opgeteld, geen
  "hoe vaak". Klik opent het recept.
- **Bron-tekst bij niet-geleerde recepten**: ja (zie punt 5). Plus een filter "Sources" op type.
- **Reagent-kwaliteit**: ja. Kiezen per rang, de kwaliteitsbalk, Concentration-knop, "Use Best Quality Reagents".
- **Handelaarspul, tussenproducten, farmplekken**: nee.

### Andere addons (alleen hun pagina gelezen, geen code)

| Addon | Downloads | Laatste versie | Licentie | Bron van de cijfers |
|---|---|---|---|---|
| CraftSim | 10.416.433 | 27.0.7, 28 sep 2026, 12.1.0 | MIT | CurseForge, vers ("updated 8 days ago") |
| Auctionator | 202.620.247 | 340, 2 okt 2026, 12.1.0 | All Rights Reserved | CurseForge, vers. Lokaal ook versie 340 |
| Profession Shopping List (PSL) | 1.918.430 (oude kopie, ~mei) | GitHub v12.1.0-09, 30 sep 2026 | All Rights Reserved | CF-kopie verouderd; GitHub-datum is vers |
| GatherMate2 | 34.707.402 (oude kopie, ~juli) | GitHub tag 1.52.3, commit 17 aug 2026 "Update storage TOCs for WoW 12.1.0" | All Rights Reserved | CF-kopie verouderd; GitHub vers |
| ALL THE THINGS (recept-bronnen) | 60.761.411 | 5.3.15, 4 okt 2026 | All Rights Reserved | CurseForge, vers |

Geen van deze vijf is lokaal geïnstalleerd, behalve Auctionator. Zygor is wel geïnstalleerd (ZygorGuidesViewer 9.6).

### Punt × addon

"Ja/nee" = staat zo in hun eigen beschrijving. "Onbekend" = staat er niet in; dat bewijst niet dat het ontbreekt.

| Punt | Blizzard | CraftSim | Auctionator | PSL | GatherMate2 | ATT | Zygor (lokaal) |
|---|---|---|---|---|---|---|---|
| 1 Handelaarspul | nee | onbekend | onbekend | deels: "track the cost of vendor items" | nee | onbekend ("information on … vendors") | ja, als `buy`-stappen in de levelgidsen |
| 2 Tussenproducten | nee | onbekend | onbekend | ja volgens een oude beschrijving ("Supports subreagents", "Ctrl+click Reagent: Add recipe for the selected subreagent"; addonswow.com, KANDIDAAT); niet in de huidige README | nee | nee | deels (stappen in volgorde) |
| 3 Welke kwaliteit | ja (balk, kiezen, Concentration) | ja: "Price Details for the possible outcome qualities", "Simulation Mode … reagents", "Most Profitable Reagent Combination", "Optimizes Concentration" | nee | onbekend (werkt samen met CraftSim) | nee | nee | nee |
| 4 Farmplekken | nee | nee | nee | nee | ja: kaart en minimap, eigen verzamelde plekken + import via GatherMate2_Data | onbekend | ja: farm-routes per gebied |
| 5 Recept-bron | ja (bron-tekst + filter) | nee | nee | deels: "grab the necessary recipes" voor prestaties | nee | onbekend (verzameladdon, beschrijving noemt recepten niet) | deels (welke trainer, welk ketelrecept) |
| Lijst "hoe vaak" × reagents | nee (één craft) | ja: "Craft Queue" + "Auctionator Shopping List" | ja: boodschappenlijsten | ja (kernfunctie) | nee | nee | nee |

---

## Mijn eerlijke oordeel

**Wat Cisca gewoon kan installeren**

- Wil ze de beste kwaliteit en winst uitrekenen: **CraftSim**. Dat doet punt 3 grondiger dan wij ooit willen
  (simulatie, prijzen per kwaliteit, Concentration-winst). Nabouwen is groot werk en levert minder op.
- Wil ze kaarten met plukplekken: **GatherMate2** (+ GatherMate2_Data). Dat is punt 4 met kaartpunten; daar
  hoeven wij niet aan te komen, ook vanwege de licentie.
- ⚠️ **Profession Shopping List is een directe concurrent** van `/mh craftshop`: recepten volgen, reagents
  optellen, en volgens een oudere beschrijving ook tussenproducten. Actief bijgewerkt (30 sep 2026). Of hij
  Nederlands spreekt: ONBEKEND.

**Wat MH kan toevoegen dat niemand zo doet**

MH's kracht is **uitleggen**. Niemand zet per regel in gewone taal waaróm je iets moet halen en waar:

- "Sunglass Vial: koop je bij Melaris, naast je trainer. Niet op het veilinghuis zoeken."
- "Composite Flora: maak je zelf. Daarvoor heb je nodig: …"
- "Tranquility Bloom: pluk je met Herbalism. Groeit in alle vier de gebieden, dus pluk waar je toch al bent."
- "Dit recept ken je nog niet. Je krijgt het bij: <Blizzards eigen tekst>."
- "Kwaliteit: met goedkope materialen ◆, met dure ◆◆. Verkoop je het niet? Koop dan de goedkope."

Dat is het verschil tussen een rekenmachine (CraftSim, PSL) en een leraar. De data is klein; de waarde zit in de
zinnen en in de koppeling met de Academy-hoofdstukken die er al zijn. En alles in het Nederlands.

**Mijn volgorde** (AFGELEID)

1. **Punt 5, recept-bron**: klein. De client doet het, de probe bestaat al. Eerst `/mh unlearned` één keer
   opnieuw draaien om te zien hoeveel recepten een tekst hebben.
2. **Punt 1, handelaarspul**: klein. ± 20 ID's uit wago, plus de handelaarsnamen die MH al in tekst heeft.
3. **Punt 4, farmen**: klein, als we bij één zin per reagent blijven en de bestaande MH-feiten hergebruiken.
4. **Punt 2, tussenproducten**: middel. De client heeft alles, maar uitklappen met opbrengst en rondjes vraagt
   zorg.
5. **Punt 3, kwaliteit**: eerst meten (zie de drie ONBEKEND-vragen). Valt het tegen, dan één regel uitleg plus
   "wil je het precies? installeer CraftSim". Spelers kiezen.

**Eerst te meten in het spel, vóór er code komt**

- Alle namen in `C_TradeSkillUI` opsommen (`pairs`), naar `ns.db`. Dan weten we zeker of er een
  "recept-voor-item"-functie is.
- `/mh unlearned`: hoeveel recepten een bron-tekst hebben.
- `GetRecipeSchematic`, `GetRecipeSourceText` en `GetCraftingOperationInfo` met het venster **dicht**.
- `GetCraftingOperationInfo` met reagents die niet in je tas zitten.
