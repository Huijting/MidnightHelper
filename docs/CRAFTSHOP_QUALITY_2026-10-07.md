# Craftshop: welke kwaliteit koop je? (7 okt 2026)

Onderzoek door mh-research. Geen code veranderd.

**Labels**
- **GEMETEN** = gezien in een genoemde bron met datum, of in Robs client.
- **AFGELEID** = beredeneerd uit wat wel gemeten is.
- **KANDIDAAT** = één bron zegt het, nog niet in Robs client gezien.

⚠️ `docs/CRAFTSHOP_RESEARCH_2026-10-06.md` heb ik **niet** gelezen: mijn opdracht verbood lezen in `docs/`.
Ik werkte vanuit de taaktekst, Robs SavedVariables, `CraftShoppingList.lua` en de bronnen hieronder.

---

## Kort

1. Goud doet maar één ding: het geeft **extra skill**. Zilver geeft niets.
2. Alles in goud geeft (waarschijnlijk) **40% van de moeilijkheid** erbij. Het zware reagent telt het meest.
3. Of dat een betere kwaliteit oplevert, hangt af van **jouw skill**. Dat verschilt per recept en per speler.
4. De juiste tabel voor de API is gevonden. Onze nil van 6 okt komt doordat we **reagents zonder kwaliteit** meestuurden.
5. Vanavond: 4 regels `/run` laten zien of het werkt zonder dat je het goud bezit.

---

## 1. Hoe het werkt

### Hoeveel rangen?

| wat | rangen | label |
|---|---|---|
| reagents (erts, kruid, leer) | 2: zilver, goud | GEMETEN |
| drankjes, spullen | 2 | KANDIDAAT |
| uitrusting | 5 | KANDIDAAT |

- Reagents: **GEMETEN** in wago `CraftingReagentQuality`, build 12.1.0.69933. Elk Midnight-reagent dat ik opzocht heeft alleen `OrderIndex` 0 en 1. Negen paren bekeken, o.a. Void-Tempered Leather (238511/238512) en Sunglass Vial (240991/240990).
- Volgorde: rang 1 staat **eerst** in de lijst van het recept (`reagents[1]` = zilver, `reagents[2]` = goud). **GEMETEN** voor alle 9 paren: MH bewaart de ID's in de volgorde van het recept (`CraftShoppingList.lua` 403-413), en die volgorde in Robs SV = `OrderIndex` in wago. Let op: bij Sunglass Vial en Wondrous Synergist is rang 1 het **hogere** item-ID (240991, 241283).
- Producten: Wowhead (19 okt 2025, met update van Blizzard) zegt 2 voor spullen en 5 voor uitrusting. Overgear (feb 2026) en Conquestcapped (jun 2026) zeggen hetzelfde. Twee sites zeggen 3 voor uitrusting (dving.net zonder datum; onlyfarms feb 2026, "nog niet actief in alpha"). Daarom KANDIDAAT.
- Robs meting van 6 okt past bij 5 rangen: Smuggler's Reinforced Shoulderguards gaf kwaliteit 2 bij skill 109 op moeilijkheid 250. **AFGELEID.** De meetregel hieronder print `maxQuality` en beslist het.

### Wat doet goud?

- Alleen **skill**. Zilver = 0 extra, goud = extra. KANDIDAAT: forum (Draggoth, 16 mrt 2026, geen Blizzard-medewerker).
- **Maximaal 40% van de moeilijkheid** als alles goud is.
  - **GEMETEN:** wago `CraftingDifficulty` (12.1.0.69933): kolom `CraftSkillBonusPercent` = **40** in alle rijen 13 t/m 36. In rij 1, 2 en 7 staat 25. Die drie hebben ook een Inspiration-waarde, dus dat zijn waarschijnlijk de Dragonflight-rijen (AFGELEID).
  - Welke rij bij welk Midnight-recept hoort, heb ik niet opgezocht. Maar alle 24 rijen na Dragonflight zeggen 40.
  - **AFGELEID:** dat die kolom "max skill uit reagents" betekent. Het past bij het forum: 196 skill bij moeilijkheid 490 = 40%.
- **Per slot telt gewicht × aantal.**
  - **GEMETEN:** wago `ModifiedCraftingCategory.MatQualityWeight`, live build.
  - **AFGELEID:** de formule. Het aandeel van een slot = (gewicht × aantal) / totaal van alle kwaliteit-slots.

Voorbeeld 1: **Smuggler's Reinforced Shoulderguards** (1237504, moeilijkheid 250)

| reagent | aantal | gewicht | aandeel |
|---|---|---|---|
| Void-Tempered Leather | 40 | 2 | 67% |
| Void-Tempered Scales | 20 | 2 | 33% |

Voorbeeld 2: **Potion of Recklessness** (1230859)

| reagent | aantal | gewicht | aandeel |
|---|---|---|---|
| Sunglass Vial | 5 | 30 | 77% |
| Peacebloom | 8 | 3 | 12% |
| Earthroot | 4 | 5 | 10% |

Gewichten GEMETEN, aandelen AFGELEID.
Les uit voorbeeld 2: gouden kruiden doen bijna niets. Het gouden flesje doet het werk.

### Van skill naar kwaliteit

- Elke kwaliteit heeft een drempel. De API geeft ze: `lowerSkillThreshold` en `upperSkillTreshold` (sic, met de typfout). **GEMETEN** in Blizzards API-documentatie 12.1.0.
- Bij 5 rangen liggen de drempels mogelijk op 20, 50, 80 en 100% van de moeilijkheid. KANDIDAAT: forum "R4-lijn 392 bij 490" = 80%. Robs twee metingen passen erbij (109/250 → 2; 79/500 → 1). Niet gemeten.
- Voorspelling voor de schouderstukken (**AFGELEID**, alles hierboven samen):

| wat je erin stopt | skill | kwaliteit |
|---|---|---|
| alles zilver | 109 | 2 |
| alleen schubben goud | ~142 | 3 |
| alleen leer goud | ~176 | 3 |
| alles goud | ~209 | 4 |

### Concentration en Ingenuity

- **Concentration** = een batterij per beroep: 1000 punten, 1 punt per 6 minuten. Gebruik je het, dan krijg je **gegarandeerd één kwaliteit hoger**. GEMETEN: Wowhead-gids (Paryah, bijgewerkt 22 feb 2026).
- De prijs hangt af van hoe ver je onder de volgende drempel zit. GEMETEN bij Rob op 6 okt: 133 voor de schouderstukken, 416 voor de Blessed Pango Charm.
- **AFGELEID:** goud maakt Concentration goedkoper, want het gat wordt kleiner. De meetregel laat dat zien.
- **Ingenuity** = kans dat je een deel van die Concentration terugkrijgt. Specialisaties kunnen de kosten ook verlagen. GEMETEN: dezelfde Wowhead-gids. De API heeft een veld `ingenuityRefund` (GEMETEN, documentatie); wat het getal precies is, heb ik niet gemeten.

### Wanneer helpt goud nooit?

- Als het product geen kwaliteit heeft (`supportsQualities` = false).
- Als het recept `alwaysUsesLowestQuality` heeft. Blizzard verbergt dan zelf het vinkje "Use Best Quality Reagents".
- Beide velden: GEMETEN (API-docs en Blizzard-code 12.1.0). Dat je dan altijd zilver koopt: AFGELEID.
- Optionele reagents (missives, embellishments) werken anders: daar verandert de rang de **moeilijkheid**. KANDIDAAT (forum). Valt buiten de craftshop, want die toont alleen verplichte reagents.

### Heeft 12.1 dit veranderd?

Geen bron die ik vond zegt dat. Method (9 aug 2026) en wow-professions (zonder datum) noemen alleen recepten, materialen en de Knowledge-reset. KANDIDAAT, want niets vinden bewijst niets.

---

## 2. De juiste tabel voor GetCraftingOperationInfo

**Wat Blizzard zelf doet** (GEMETEN: Blizzard-UI 12.1.0 build 69933, wow-ui-source `live`, 22 sep 2026):

- `Professions.CreateCraftingReagentInfo(reagent, dataSlotIndex, quantity)` maakt
  `{ reagent = {itemID=…}, dataSlotIndex = …, quantity = … }`. Onze "geneste" vorm van 6 okt was dus **goed**.
- `Transaction:CreateCraftingReagentInfoTbl()` stuurt **alleen** slots met `dataSlotType == ModifiedReagent` (= 2) mee. Gewone reagents zonder kwaliteit gaan er **niet** in.
- `Professions.DoesSchematicIncludeReagentQualities`: een kwaliteit-slot is `dataSlotType == 2`, `reagentType == Basic` (= 1) en meer dan 1 reagent.

**Waarom wij nil kregen** (6 okt):

- Onze probe stopte **alle** verplichte slots erin, ook die zonder kwaliteit (zoals 238522, 1 item).
- CraftSim (code van 5 okt 2026) slaat die slots expres over, met als commentaar: *"if we would add such reagents to an operationInfo call, it will return nil"*.
- Dat verklaart onze nil precies. **AFGELEID**, sterk.

**Moet je het goud bezitten?**

- Blizzards eigen scherm vult alleen uit je tassen. Het venster "kwaliteit kiezen" laat je niet meer kiezen dan je hebt. GEMETEN (code 69933).
- Of de **API** dat ook eist: **niet gemeten.**
- CraftSim heeft een "Simulation Mode" en rekent met het beste goud tegen het volle aantal. Dat wijst op: niet nodig. KANDIDAAT.
- Ook niet gemeten: werkt het **direct na inloggen**, zonder dat je het beroepsvenster opent? Op 6 okt kwam de "venster dicht"-meting één minuut na de "venster open"-meting.

### De meetregels voor vanavond

Plak ze **in deze volgorde** in de chat. Elke regel is korter dan 255 tekens (GEMETEN: 145, 232, 228, 215).
Doe het eerst **na een /reload, zonder het beroepsvenster te openen**. Dan weten we meteen of het "koud" werkt.

Regel A (kies het recept, toont het aantal rangen):
```
/run MHR=1237504 MHS=C_TradeSkillUI.GetRecipeSchematic(MHR,false).reagentSlotSchematics print("max",C_TradeSkillUI.GetRecipeInfo(MHR).maxQuality)
```

Regel B (maakt de tabel zoals Blizzard: alleen kwaliteit-slots):
```
/run function MHT(k)local t={}for _,x in ipairs(MHS)do if x.dataSlotType==2 and x.reagentType==1 and #x.reagents>1 then tinsert(t,{reagent=x.reagents[k],dataSlotIndex=x.dataSlotIndex,quantity=x.quantityRequired})end end return t end
```

Regel C (geen / alles zilver / alles goud):
```
/run for k=0,2 do local t=k>0 and MHT(k)or{} local o=C_TradeSkillUI.GetCraftingOperationInfo(MHR,t,nil,false)or{}print(k,#t,o.craftingQuality,o.baseSkill,o.bonusSkill,o.upperSkillTreshold,o.baseDifficulty,o.concentrationCost)end
```

Regel D (goud in één slot, de rest zilver):
```
/run local g=MHT(2)for i=1,#g do local t=MHT(1)t[i]=g[i]local o=C_TradeSkillUI.GetCraftingOperationInfo(MHR,t,nil,false)or{}print("goud in slot",i,g[i].reagent.itemID,g[i].quantity,o.craftingQuality,o.bonusSkill)end
```

**Wat regel C print**, per regel:
`0/1/2` (geen/zilver/goud) · aantal slots · **kwaliteit** · basisskill · bonusskill · volgende drempel · moeilijkheid · **concentration-kosten**

- Regel 0 is de positieve controle: die moet weer "2, 61, 48, …, 250, 133" geven.
- Verwachting (**AFGELEID**): regel 1 = gelijk aan regel 0. Regel 2 = bonus ~148 en kwaliteit 4.
- Regel D: leer-goud ~+67, schubben-goud ~+33 (AFGELEID).

**Wat het betekent**

| uitkomst | betekenis |
|---|---|
| regel 2 hoger dan regel 0, en je hebt het goud **niet** | werkt zonder bezit → variant b kan |
| regel 0 werkt, 1 en 2 geven nil | test een recept waarvan je het goud wél hebt; werkt dat wel, dan moet je het bezitten |
| regel 0 geeft ook nil | koude start werkt niet: open het beroep één keer, probeer opnieuw |
| een rode fout | kopieer de tekst |

Zeg er even bij of je het gouden leer/de schubben in je tassen of bank hebt.
De regels maken drie tijdelijke namen aan (`MHR`, `MHS`, `MHT`). Na een /reload zijn ze weg.
De regels zijn niet in de client getest; alleen de lengte is gemeten.

Bonus op je alchemie-alt: zet in regel A `MHR=1230859` (Potion of Recklessness). Dan zien we `max` voor een drankje (2?) en de drempel voor goud.

---

## 3. Wat er al bestaat

**Blizzard** (GEMETEN, code 12.1.0 build 69933):
- Een kwaliteitsbalk en het blok Crafting Details: Skill (basis + bonus), Difficulty, Concentration-kosten.
- Vinkje **"Use Best Quality Reagents"**: vult uit je tassen, aan = eerst goud, uit = eerst zilver. Te weinig? Dan blijft het slot leeg.
- Klik op een reagent: kies zelf de mix. Maximaal wat je hebt.
- Het gat (**AFGELEID**): Blizzard laat nooit zien wat goud zou doen **als je het nog moet kopen**. Precies Robs vraag.

**CraftSim**
- MIT-licentie (GEMETEN, GitHub). Versie 27.0.7 van 28 sep 2026, voor 12.1.0 (GEMETEN, CurseForge).
- Doet: goedkoopste reagent-mix, simulatie, prijs per kwaliteit, Concentration-winst per punt. Prijzen uit TSM, Auctionator, RECrystallize of Oribos.
- Aanpak (beschreven, geen code overgenomen): vraagt de API met en zonder reagents en kijkt naar het verschil in skill.
- Staat **niet** op Robs pc (GEMETEN: geen map in AddOns).

**Auctionator** (staat wél op Robs pc)
- Vraagt `GetCraftingOperationInfo` met Blizzards eigen tabel om de verkoopprijs van het product te tonen. GEMETEN: `Auctionator/Source_Mainline/CraftingInfo/Professions.lua` regel 134 en 168.

**MH zelf**
- De Academy heeft al een hoofdstuk Kwaliteit en een hoofdstuk Concentration (`Locales/enUS.lua` 1877-1891). GEMETEN.
- Daar staat al: skill beslist, reagents hebben ook rangen, en het vinkje "Use Best Quality Reagents".
- Daar staat nog niet: hoeveel goud oplevert, dat het zware reagent telt, en "koop zilver, tenzij …".

---

## 4. Voorstel: drie varianten

### a) Alleen uitleg

- **Wat de speler ziet:** één alinea in het Academy-hoofdstuk Kwaliteit, plus één voetregel in het craftshop-venster.
  Bijvoorbeeld: *"Goud geeft alleen extra skill. Koop zilver, tenzij je net onder de volgende kwaliteit zit. Het zwaarste reagent telt het meest."*
- **Kost:** een uur. Teksten in 7 talen.
- **Nadeel:** algemeen. Zegt niet welk recept.
- Het getal "40%" pas noemen na de meting van vanavond.

### b) Per recept op de lijst

- **Wat de speler ziet**, onder elk recept:
  *"Zilver: ◆◆ · Goud: ◆◆◆◆ · Alleen gouden leer: ◆◆◆"*
  en eventueel *"Met zilver + 133 Concentration: ◆◆◆"*.
- **Kost:** een halve dag plus Robs test. Eén functie in `CraftShoppingList.lua`, een paar API-vragen per recept, teksten, en een `/mh craftshop`-diagnose die zegt wáárom er niets staat (regel "bouw je iets dat kan zwijgen").
- **Alleen als** regel C vanavond werkt **zonder** dat je het goud hebt. Moet je het bezitten, dan zie je niets wat Blizzard niet al laat zien.
- Let op: het hangt af van **dit** karakter (skill, Knowledge, gereedschap). Dus elke keer opnieuw rekenen. Geeft de API nil, dan "onbekend" tonen, nooit "zilver".
- Bijvangst: de probe van 6 okt kan dezelfde filter krijgen (`dataSlotType==2` en meer dan 1 reagent). Dat is werk voor de bouwchat.

### c) Met prijzen erbij

- **Wat de speler ziet:** iets als "goud kost X goud meer, het product is Y goud meer waard".
- **Kost:** dagen. Prijzen per rang van elk reagent, per kwaliteit van het product, oude prijzen, mixen doorrekenen. Auctionator heeft een prijs-API (GEMETEN: Auctionator gebruikt hem zelf).
- **Maar:** dit is precies CraftSim. Gratis, MIT, bijgewerkt voor 12.1.

### Advies

1. **a nu.** Goedkoop, en het klopt altijd.
2. **b na vanavond**, als regel C werkt zonder bezit. Dat is wat Blizzard níét toont en wat bij MH past: uitleggen, per recept.
3. **c niet bouwen.** Hooguit een zin: *"Wil je het tot op de koper uitrekenen? Gebruik CraftSim."*

Rob kiest.

---

## Bronnen

| bron | datum | gebruikt voor |
|---|---|---|
| Blizzard-UI, wow-ui-source `live`, "12.1.0 (69933)" | 22 sep 2026 | tabelvorm, filter, vinkje, kwaliteitsbalk |
| Blizzard API-docs (zelfde build) | 22 sep 2026 | velden, enums |
| wago.tools DB2, build 12.1.0.69933 | gelezen 7 okt 2026 | rangen, gewichten, 40% |
| CraftSim GitHub (main) | push 5 okt 2026 | nil-verklaring, aanpak |
| CraftSim CurseForge | 28 sep 2026 | functies, MIT, versie |
| Wowhead, Concentration-gids (Paryah) | 22 feb 2026 | Concentration, Ingenuity |
| Wowhead-nieuws (Archimtiros) | 19 okt 2025 | 2 / 5 rangen |
| Blizzard-forum (Draggoth) | 16 mrt 2026 | zilver 0, goud 40% |
| Robs SV `craftShopMeasure` | 6 okt 2026 | 109/250, 133, de nil |
| warcraft.wiki.gg | – | `reagent` sinds 12.0.0 i.p.v. `itemID` |

Wago `CraftingReagentQuality` en `ModifiedCraftingCategory` gaven op build 12.1.5.70077 (nieuwer, vermoedelijk PTR) dezelfde rijen.
In de gidsen die ik vond (Wowhead, Icy Veins, en andere) noemt niemand het percentage voor goud. Geen van die gidsen is van na 18 aug 2026. De "+40 skill" in Icy Veins gaat over profession-uitrusting, niet over reagents.
