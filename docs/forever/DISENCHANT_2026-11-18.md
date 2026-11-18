# Disenchant in WoW Forever: onderzoek voor Midnight Helper (18 nov 2026)

> **Gebouwd 18 nov 2026** (Rob via sparring: *"Hoe kan ik zien of ik iets kan disenchanten? … kunnen wij dat dan zelf
> maken voor onze tassen?"* → *"Ja, dat mag zo. … Baconator [Baganator] …"* → *"ja"*) in `Modules/ForeverDisenchant.lua`
> + `Modules/ForeverDisenchantData.lua` (gegenereerd: 54 rijen + 1615 vlag-items). Tweede, onafhankelijke Opus-controle:
> `DISENCHANT_CONTROLE2_2026-11-18.md` — alles KLOPT behalve "ZG idols" (dat zijn quest-items class 12, geen gear; de
> vlag-items van ZG zijn de Zandalar-sets) en mantels = armor subclass 1, niet 0 (maakt voor de regel niets uit).
> - Tooltip: de woorden van de client zelf (`ITEM_DISENCHANT_ANY_SKILL` / `ITEM_DISENCHANT_NOT_DISENCHANTABLE`), met een
>   MH-reden bij "nee"; geen verkoopprijs = "waarschijnlijk, niet zeker". Alleen voor wie Enchanting heeft.
> - Icoontje: Blizzard-tassen (post-hook `UpdateItems`) en Baganator (`RegisterCornerWidget`, linksboven).
> - Knop "Disenchant next" (standaard UIT): secure `type=spell`, `spell=13262`, `target-bag/slot`; doel kiezen alleen
>   buiten combat; verborgen in combat; rechtsklik = overslaan; Alt+slepen = verplaatsen.
> - `/mh disenchant [on|off|next on|next off]` print alles. Kennen van Disenchant: `C_SpellBook.IsSpellKnown(13262)`
>   (controle 2: `IsPlayerSpell` alleen achter een deprecation-CVar).

Gemaakt door een `mh-research`-helper. Ik heb alleen gelezen. Ik heb niets in de repo aangeraakt en niets gepost.
Er staat GEMETEN (gezien in een genoemde bron met datum of build) of AFGELEID (beredeneerd) bij elke bewering.
Data: `disenchant_data.lua` hiernaast, gebouwd door `de_make_data.py` uit de DB2-cache. Er is niets met de hand overgetypt,
behalve de materialentabel, en die staat als AFGELEID.

Bronnen in het kort:
- **DB2 Forever** = wago.tools CSV, build `1.60.1.70959` (wowf, 17 nov 2026), via `run gamedata …` en de cache-CSV's.
- **DB2 Classic Era** = `1.15.9.70576`. **DB2 MoP Classic** = `5.5.4.70960`. Die twee dienen alleen ter vergelijking.
- **Forever UI-bron** = GitHub Gethe/wow-ui-source, branch `forever`, commit `3d8abb1`, bericht "1.60.1 (70959)",
  17 nov 2026. Dat is precies de build van de client. Dit is Blizzards eigen Lua, gespiegeld. Het is geen meting in de
  client zelf. Lokaal staat er geen geëxporteerde UI-bron onder `_forever_` (GEMETEN: Glob `**/SecureTemplates.lua` gaf 0;
  de positieve controle `**/Baganator*.toc` vond wel `_forever_\…\Baganator.toc`).
- **TrinityCore master** (de emulator, retail-regels), gelezen op 18 nov 2026: `ItemTemplate.h` en `Item.cpp`.
- **Gidsen**: wow-professions.com/forever/disenchanting-guide (zonder datum, © 2026), warcrafttavern.com/forever/guides/enchanting
  (zonder datum, © 2026), warcraft.wiki.gg/wiki/Disenchant en …/Disenchanting (gelezen op 18 nov 2026).
- **Lokale addons in `_forever_`**: Baganator v862, Syndicator, Auctionator, Pawn en PaladinPlan 1.16.9. Die zijn alleen
  een plek om kandidaten te vinden, ze bewijzen niets.

---

## 1. De Forever-regels

### Wat je wel en niet kunt disenchanten

| Bewering | Status | Bron |
|---|---|---|
| Disenchant = spell **13262**, cast van 3 sec, "good quality (Green) or better weapons or armor" | GEMETEN | DB2 Forever SpellName; Wowhead Forever-tooltip, 18 nov |
| Het spel heeft alleen "uitkomst-rijen" (`ItemDisenchantLoot`) voor **Class 2 (wapen) en 4 (armor)**, **Quality 2/3/4** (groen/blauw/paars). Er zijn 54 rijen. | GEMETEN | DB2 Forever `ItemDisenchantLoot`, alle rijen |
| Grijs (0), wit (1), oranje/legendary (5) en heirloom hebben geen rij, dus die kunnen niet | GEMETEN (geen rij) + AFGELEID (geen rij = kan niet) | DB2; warcraft.wiki.gg: "Legendary and heirloom items … cannot be disenchanted" |
| Alles wat geen wapen of armor is (tassen, drankjes, trade goods, questspullen, ook als ze groen zijn) kan niet | GEMETEN (geen rij voor andere classes) | DB2; Wowhead-tooltip; warcraft.wiki.gg |
| Ringen, kettingen, trinkets, mantels en relics zijn armor (class 4) en kunnen dus gewoon, tenzij de vlag hieronder aan staat | GEMETEN dat ze class 4 zijn en in een rij passen; AFGELEID dat de server ze toelaat | DB2 Forever: zonder vlag en mét passende rij zijn er 109 groene+ trinkets, 179 ringen en 104 kettingen (de vlag staat aan op 76 trinkets, 84 ringen, 69 kettingen) |
| Bovengrens: de laatste rij loopt tot ilvl **99**. Het hoogste groene+ wapen of armor in Forever is ilvl **92**. | GEMETEN | DB2 Forever |
| Forever heeft 4 rijen die Classic Era niet heeft: **blauw ilvl 5-15 en 16-20** (rij 335-338). In Classic Era begint blauw pas bij ilvl 20. Ook rij 9/10 (blauw) begint in Forever bij 21, in Era bij 20. | GEMETEN (verschil tussen de builds) | DB2 Forever vs Era 1.15.9 |
| Wat er precies uit een low-level blauw item in Forever komt | NIET GEMETEN | – |

**De vlag "no disenchant":**
- `ITEM_FLAG_NO_DISENCHANT = 0x00008000` in `ItemFlags` (= ItemSparse `Flags_0`). GEMETEN in TrinityCore master ItemTemplate.h.
- In Forever staat die bit aan op **1615** van de 5138 groene/blauwe/paarse wapens en armor. GEMETEN (DB2-cache, `de_analysis.py`).
  Het gaat vooral om PvP-rang-gear (Knight-Captain's, Marshal's …), Insignia of the Alliance/Horde, Zul'Gurub-klasse-idols
  (Strength of Mugamba …), **wands die een enchanter maakt** (Lesser Magic Wand 11287, Greater Magic Wand 11288),
  verkleedkleren (Bloodsail-set, Twilight Cultist) en de Lucky Fishing Hat.
- Er is een positieve controle op wat de bit betekent: warcraft.wiki.gg noemt "Wands crafted by an Enchanter" en "Tabards" als
  "kan niet", en precies die wands hebben de bit (GEMETEN). Dat de Forever-SERVER de bit ook zo gebruikt: AFGELEID.

**Andere redenen voor "kan niet"** (TrinityCore `Item::GetBaseDisenchantLoot`, GEMETEN in de broncode; voor Forever AFGELEID):
conjured, quest-bound (Bonding 4), gebonden aan een zone of map, stapelbaar (meer dan 1), **geen verkoopprijs**, en geen
passende rij. `SkillRequired` controleert hij niet. In de Forever-data (GEMETEN):
- 2 items zijn quest-bound en 2 zijn stapelbaar.
- 139 items hebben geen rij: verborgen transmog-stukken op ilvl 1, Insignia op ilvl 1, test-items, tabards.
- **411** items hebben geen bit en wel een rij, maar hebben verkoopprijs 0. Voorbeelden: Benediction 18608, de Zul'Gurub-charms
  19951-19959 en veel nieuwe blauwe Forever-questriemen vanaf 252428. Of de Forever-server die weigert, is **NIET bekend**.
  De TrinityCore-regel is een retail-regel. Mijn advies: daar "waarschijnlijk wel / niet zeker" tonen, nooit "nee".
- Wat overblijft (geen enkele reden): **3083** items. Dat zijn de echte "ja"-gevallen volgens de clientdata.
- Geen enkel groen+ wapen of armor in Forever schaalt mee: 0 items hebben ContentTuning of een ilvl-curve (GEMETEN). Het
  vaste ilvl uit `C_Item.GetItemInfo` is dus genoeg.

### Welke enchanting-skill heb je nodig?

- **Forever: waarschijnlijk geen drempel. Met skill 1 kun je alles.** AFGELEID, maar uit drie richtingen tegelijk:
  1. `SkillRequired` = **0** op alle 54 Forever-rijen. GEMETEN. Dat is ook zo op alle rijen van Classic Era 1.15.9 (GEMETEN).
  2. wow-professions.com/forever: *"you can disenchant everything from Enchanting skill 1"*. GEMETEN in de gids, die geen datum heeft.
  3. warcraft.wiki.gg/wiki/Disenchant: de minimale skill kwam pas met **patch 2.0.1**. Daarvoor *"all disenchantable items
     (including high-end raiding epics) could be disenchanted with 1 skill point"*. GEMETEN op de wiki.
- Ter vergelijking: MoP Classic 5.5.4 heeft dezelfde rij-ID's mét skill. GEMETEN: ilvl ≤20 → 1, 21-25 → 25, 26-30 → 50,
  31-35 → 75, 36-40 → 100, 41-45 → 125, 46-50 → 150, 51-55 → 175, 56-60 → 200, 61-65 → 225. Dat is de TBC-regel.
  Hij staat in `DE.SKILL_IF_GATED_TBC_RULE`, alleen als reserve.
- Gevolg voor het plan: de tooltipregel wordt eigenlijk alleen **"ja" of "nee"**. "Ja vanaf skill N (jij hebt M)" is in
  Forever waarschijnlijk nooit nodig. Rob kan dat in één test zeker maken (zie het einde).
- De string `SPELL_FAILED_CANT_BE_DISENCHANTED_SKILL` ("Your Enchanting skill is not high enough …") staat wel in de Forever
  GlobalStrings (GEMETEN, ID 16795). Strings worden gedeeld tussen versies, dus dit bewijst niet dat er een drempel is.

### Wat eruit komt (kort)

- Vuistregel: armor geeft vooral dust, wapens vooral essence, blauw geeft een shard, paars geeft shards of een Nexus Crystal.
  Dat staat zo in wow-professions Forever en in de Classic-tabel van Auctionator. AFGELEID voor Forever, want de
  Forever-droprates zijn nergens gemeten.
- Per ilvl-stap, voor groen: 5-15 Strange Dust en Lesser Magic Essence · 16-25 Strange Dust, Greater Magic of Lesser Astral
  Essence en een Small Glimmering Shard · 26-35 Soul Dust · 36-45 Vision Dust · 46-55 Dream Dust · 56+ Illusion Dust, met
  telkens de bijbehorende essence en shard. Alle 24 item-ID's en namen zijn GEMETEN (Wowhead Forever-tooltips, 18 nov). Welk
  materiaal bij welke stap hoort is AFGELEID (Classic-tabellen). Alles staat in `DE.MATS_GREEN/BLUE/PURPLE`.
- Let op: wow-professions geeft de tabel op **required level** en zegt *"The item level is mostly not shown in the game"*.
  Die tabel ligt precies één stap (5 levels) lager dan de ilvl-tabel. Voor code: gebruik het **ilvl**, want dat staat in de
  DB2-kolommen MinLevel/MaxLevel. Dat het om ilvl gaat is AFGELEID uit TrinityCore.
- Twee nieuwe Forever-spells: 1324981 "Disenchanter" (*"Reduces the cast time of Disenchant by 25%"*) en 1283701 "Boosted
  Disenchanting" (zonder tekst). GEMETEN (DB2 en Wowhead). Waar ze vandaan komen: NIET GEMETEN.

## 2. Client-API's in Forever

Eerst de vorm van de client. Forever draait de **retail-UI (mainline) met "Camelot"-overrides**. GEMETEN in de forever-branch:
`Blizzard_UIPanels_Game.toc` laadt `Mainline\ContainerFrame.lua` plus `Camelot\ContainerFrame.lua`. Baganator en Syndicator
behandelen Forever in hun code net als retail (GEMETEN: `IsForever = build >= 16000 and build < 20000`, en daarna retail-paden).

| API | Bestaat in Forever? | Status |
|---|---|---|
| `C_Item.GetItemInfo(item)` → name, link, **quality**, **itemLevel**, minLevel, …, **sellPrice**, **classID**, subclassID, **bindType** … | ja | GEMETEN (forever `ItemDocumentation.lua`) |
| `C_Item.GetItemInfoInstant`, `GetDetailedItemLevelInfo`, `GetCurrentItemLevel(loc)`, `GetItemQuality(loc)`, `IsBound(loc)`, `DoesItemExist` | ja | GEMETEN (zelfde bestand) |
| Een functie die zegt "kan disenchanten" (bv. `IsItemDisenchantable`) | **nee**, niet in C_Item | GEMETEN (zoektermen Disenchant/Destroy/Scrap: 0 treffers; de positieve controle vond `CanScrapItem`) |
| `TooltipDataProcessor.AddTooltipPostCall(tooltipType, func)` en `AddLinePostCall` | ja | GEMETEN (forever `TooltipDataHandler.lua`). `SetBagItem` loopt via `C_TooltipInfo.GetBagItem`. `OnTooltipSetItem` komt in dat bestand niet voor. Syndicator gebruikt in Forever `TooltipDataProcessor` + `TooltipUtil.GetDisplayedItem`. |
| `C_SpellBook.IsSpellKnown(spellID, spellBank)`, `IsSpellInSpellBook`, `IsSpellKnownOrInSpellBook` | ja | GEMETEN (forever `SpellBookDocumentation.lua`) |
| `C_Spell.GetSpellName(13262)` (naam zoals de client hem toont) | ja | GEMETEN (forever `SpellDocumentation.lua`) |
| `IsPlayerSpell` | staat niet in C_Spell-docs | NIET GEMETEN of het globaal bestaat |
| `GetProfessions` / `GetProfessionInfo` (enchanting-skill) | ja | GEMETEN door Rob op 11 nov voor 4 andere beroepen. Dat staat in de commentaar in MH `ForeverTrainer.lua:916-918`. Skill line **333** = Enchanting is daar AFGELEID (Zygor). MH heeft het al: `ns.ForeverMyProfessions().ENCHANTING` = `{rank, maxRank}`. |
| De eigen tooltip van het spel zegt het al: **"Disenchantable" / "Cannot be disenchanted" / "Disenchanting requires %s (%d)"** | de strings staan in Forever (GlobalStrings 16771-16773) | GEMETEN (strings). Wannéér ze verschijnen: in retail als je eerst Disenchant aanklikt en daarna over een item gaat (Blizzard-forum, 7 dec 2020; Pawn-commentaar *"Appears on item tooltips when the Disenchant ability is specified"*). **In Forever NIET GEMETEN.** |

Antwoord op Robs eerste vraag ("hoe zie ik of ik iets kan disenchanten?"), AFGELEID en nog niet getest in Forever:
Disenchant staat in Forever **niet in je spellbook, maar in het Professions-venster** (wow-professions Forever; staat ook zo in
PaladinPlan). Klik Disenchant aan en ga dan met de muis over je tassen. Is de regel rood ("Cannot be disenchanted"), dan kan
het niet. Zonder dat kijk je zelf: groen, blauw of paars wapen of armor = bijna altijd wel.

## 3. Baganator

- **Licentie: "All Rights Reserved", Copyright (c) 2023-2026 plusmouse.** GEMETEN (`Baganator\LICENSE`). Geen code
  overnemen. Hun publieke API **aanroepen** is wel gewoon bedoeld gebruik.
  `.toc`: `## Interface: 120100, 120105, 16001, …`, Version 862, Author plusmouse. Hij draait dus ook in Forever.
- **De publieke API om iets op een itemknop te zetten** (GEMETEN, `API\Main.lua:211-242`):
  - `Baganator.API.RegisterCornerWidget(label, id, onUpdate, onInit, defaultPosition, isFast)`
    - `label`: tekst voor de speler. `id`: unieke string.
    - `onInit(itemButton)`: wordt één keer per knop aangeroepen. Je maakt het frame of de texture en geeft die terug. Optionele
      velden: `.padding` (getal) en `.sizeFont` (bool).
    - `onUpdate(cornerFrame, details)`: geef `true` terug om te tonen, `false` om te verbergen, `nil` = "data nog niet klaar".
      Baganator probeert het dan later opnieuw.
    - `defaultPosition = {corner = "top_left"|"top_right"|"bottom_left"|"bottom_right", priority = n}`. Dit is optioneel. Er
      wordt maar één keer automatisch iets in een hoek gezet. Anders moet de speler het aanzetten in Baganators Customise-venster.
    - `isFast`: true = er wordt niet gewacht op de tijdslimiet.
  - `Baganator.API.IsCornerWidgetActive(id)` en `Baganator.API.GetCurrentCornerForWidget(id)`.
  - `Baganator.API.RequestItemButtonsRefresh({Baganator.Constants.RefreshReason.ItemWidgets})`: alles opnieuw tekenen, bv. na
    het leren van Enchanting.
  - Andere hooks: `RegisterJunkPlugin(label, id, callback(bagID, slotID, itemID, itemLink))` en
    `RegisterUpgradePlugin(label, id, callback(itemLink))`. Er is **geen** API voor een rand of een kleur op de knop. Alleen
    het hoek-widget is er.
- **Wat er in `details` zit** (GEMETEN, Syndicator `Search\BaseInfo.lua` + Baganator `ItemButton.lua:675-684`):
  `itemLink`, `itemID`, `quality`, `itemCount`, `isBound`, `tooltipGetter()` (in Forever:
  `C_TooltipInfo.GetBagItem(bag, slot)`), `itemLocation = {bagID, slotIndex}`, `hasNoValue` (= geen verkoopprijs!) en `guid`.
  `itemLevel` vult alleen hun eigen ilvl-widget in. Lees het ilvl dus zelf met `C_Item.GetDetailedItemLevelInfo(itemLink)`.
- **Voorbeelden uit hun eigen code** (beschreven, niet gekopieerd), `API\ItemButton.lua`:
  - "equipment_set": `onInit` maakt een texture van 15×15 op de knop. `onUpdate` geeft `details.setInfo ~= nil` terug.
  - "engraved_rune": dezelfde vorm, met `defaultPosition {corner="top_right", priority=1}`.
  - Een icoontje "Disenchant" volgt dus precies dat patroon.
- In Forever gebruikt Baganator de **retail-knop** (`BaganatorRetailLiveContainerItemButtonTemplate`, erft
  `ContainerFrameItemButtonTemplate`). GEMETEN in `Pools.lua:19-20`.
- Syndicator heeft geen zoekwoord voor "disenchant". GEMETEN: 0 treffers. De positieve controle vond 73 keer `AddKeywordLocalised`.

## 4. Blizzard-tassen in Forever

Bron: de Forever UI-bron, `Mainline\ContainerFrame.lua` + `Camelot\ContainerFrame.lua`. De namen zijn GEMETEN, de werking is AFGELEID:
- Frames: `ContainerFrame1` (backpack) t/m `ContainerFrameN` (`_G["ContainerFrame"..i]`), `ContainerFrameCombinedBags`, en
  `ContainerFrameContainer.ContainerFrames` met de lijst.
- Opnieuw tekenen: `ContainerFrameMixin:UpdateItems()`. Knoppen langslopen: `frame:EnumerateValidItems()`.
- Knoppen komen uit een pool (`CreateFramePool("ItemButton", self, "ContainerFrameItemButtonTemplate")`). Er zijn dus geen vaste
  namen als `ContainerFrame1Item1`. Per knop: `button:GetBagID()`, `button:GetID()` (= slot).
- Events: `EventRegistry` triggert "ContainerFrame.OpenBag", "ContainerFrame.CloseBag", "ContainerFrame.OpenAllBags" en
  "ItemButton.UpdateItemContextMatching".
- **Zonder taint**, AFGELEID: per frame `hooksecurefunc(frame, "UpdateItems", fn)`. Dat is een post-hook, het geheime pad
  loopt eerst. Daarna in `fn` een eigen texture op de knop zetten of tonen. Mixin-functies worden bij het maken in elk frame
  gekopieerd, dus hook het frame zelf, niet `ContainerFrameMixin`. Niet doen: `SetScript` of `OnClick` van die knoppen
  vervangen, of een secure knop aan een tasknop parenten. Dan worden de tassen protected en breken ze in combat. Bewaar je
  overlays liever in je eigen (weak) tabel dan als veld op Blizzards knop.
- Een texture aanmaken op een gewone tasknop mag ook in combat. AFGELEID: de knop zelf is geen secure template; zijn OnClick
  roept `ContainerFrameItemButton_OnClick` aan.

## 5. Knop "Disenchant next"

GEMETEN in de Forever `SecureTemplates.lua` (1.60.1.70959):
- `SECURE_ACTIONS.spell`: leest `spell`. Bij een getal volgt `CastSpellByID(spellID, unit)`, anders `CastSpellByName`.
- Ná de actie, in `OnActionButtonClick`: `if SpellCanTargetItem() or SpellCanTargetItemID() then` lees **`target-bag`** en
  **`target-slot`**. Met een bag volgt `C_Container.UseContainerItem(bag, slot)`, zonder bag `UseInventoryItem(slot)`. Is er
  geen slot, dan wordt `target-item` gelezen en volgt `SpellTargetItem(item)`.
- `SECURE_ACTIONS.macro`: `macrotext` → `C_Macro.RunMacroText(text, button)`.
- Gevolg: één `SecureActionButtonTemplate` met `type="spell"`, `spell=13262`, `target-bag=B`, `target-slot=S` start Disenchant
  en wijst het item aan **in één klik**. Dit is de nette weg, want je hebt geen spellnaam nodig. Het alternatief
  `type="macro"` met "/cast <naam>\n/use B S" werkt via `SecureCmdUseItem` (AFGELEID). PaladinPlan (GPL-3.0, staat in
  `_forever_`) doet het zo. Dat is GEMETEN in zijn `Bags.lua:263-265`. Of het werkt is niet getest. Niet overnemen, het is GPL.
- **Grenzen** (AFGELEID uit de bekende regels plus wat MH al doet, zie CLAUDE.md "Secure frames"):
  - Eén klik is één cast. De addon mag het volgende doel **buiten combat** kiezen met `SetAttribute`, bv. na
    `BAG_UPDATE_DELAYED` of `LOOT_CLOSED`. In combat kan dat niet (`InCombatLockdown()`), dus dan wachten tot
    `PLAYER_REGEN_ENABLED`.
  - Nooit zelf klikken, geen lus, geen timer die cast. De speler drukt elke keer.
  - De knop zelf: parent aan `UIParent` en niet aan een tasknop. Gebruik het MissingBuff-patroon (los zichtbaar frame plus
    een secure knop).
  - Verandert het slot tussen het kiezen en de klik (sorteren, loot), dan treft de klik een ander item. Zet de knop daarom
    uit tot de tas weer rustig is. Laat het item en de bestemming op de knop zien. Laat items die de speler "bewaart" altijd
    weg, zoals PaladinPlan doet met rechtsklik "keep".
- Of Forever een bevestiging vraagt bij een BoP of nog-niet-gebonden item: NIET GEMETEN.

## Wat ik NIET kon meten (eerlijk)

1. Of de Forever-**server** de vlag 0x8000 en de regel "geen verkoopprijs" gebruikt. Ik ken alleen de clientdata en de
   regels van TrinityCore (retail).
2. Of Forever echt **geen skill-drempel** heeft. Dat is sterk AFGELEID: DB2 0, de gids zegt skill 1, en vóór 2.0.1 was het
   zo. Er is geen meting in het spel.
3. Of de Forever-tooltip zelf "Cannot be disenchanted" toont als Disenchant klaarstaat.
4. Of `C_SpellBook.IsSpellKnown(13262)` true geeft, nu Disenchant niet in het spellbook staat. Dat kan false zijn!
   `IsPlayerSpell` heb ik niet gevonden in de docs.
5. Of skill line 333 = Enchanting in `GetProfessionInfo` (MH zegt zelf: AFGELEID).
6. Materialen en droprates in Forever, en wat de nieuwe blauwe rijen (ilvl 5-20) geven.
7. Waar "Boosted Disenchanting" (1283701) en "Disenchanter" (1324981) vandaan komen.
8. Of het bestaande retail-systeem "item context" (tassen dimmen bij een doelspell) iets met Disenchant doet. Niet nagekeken.

## Testjes voor Rob (in Forever, kort)

1. `/run print(C_SpellBook.IsSpellKnown(13262), C_Spell.GetSpellName(13262))` → laat zien of we Disenchant kennen en hoe de
   client hem noemt.
2. Klik Disenchant aan in het Professions-venster en ga met de muis over: een groen wapen, een grijs item, en een blauwe
   Forever-questriem met verkoopprijs 0 (als je die hebt). Lees de regels in de tooltip voor.
3. Disenchant met lage skill (onder 25) een groen item van ilvl 26 of hoger, bv. required level rond 21-25. Lukt dat, dan is
   er geen skill-drempel. Dat is 2 bevestigd.
4. Als je een enchanter-wand hebt (Lesser Magic Wand): probeer die. Verwacht is "Item cannot be disenchanted". Dat bevestigt
   wat de vlag betekent.
