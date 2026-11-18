# Disenchant-controle 2 (onafhankelijk), WoW Forever 1.60.1.70959

Gemeten op 18 nov 2026. Ik heb het verslag van de vorige helper NIET gelezen; alles hieronder is opnieuw gemeten.
GEMETEN = gezien in de genoemde bron. AFGELEID = geredeneerd.

Bronnen:
- [DB2-F] wago.tools DB2 via `run gamedata`, Forever build 1.60.1.70959 (wowf, 17 nov 2026).
- [DB2-E] wago.tools DB2, Classic Era build 1.15.9.70576 (26 okt 2026).
- [UI-F] Gethe/wow-ui-source, branch `forever`, commit 3d8abb1 "1.60.1 (70959)", 17 nov 2026. Dat is precies onze build.
  De lokale client heeft geen uitgepakte UI-code (`_forever_/Interface` bevat alleen `AddOns`), dus GitHub is de bron.
- [TC] TrinityCore master: `ItemTemplate.h`, `Item.cpp`, `SpellDefines.h`, `SharedDefines.h` (opgehaald 18 nov 2026).
- [MANGOS] vmangos `ItemPrototype.h` en cmangos mangos-classic `ItemPrototype.h` (opgehaald 18 nov 2026).
- [WIKI-DE] warcraft.wiki.gg "Disenchanting", laatst bewerkt 30 sep 2026.
- [WIKI-SEC] warcraft.wiki.gg "Secure Execution and Tainting", laatst bewerkt 15 feb 2026 (ouder dan S2, maar het gaat
  om een vaste regel van de UI-engine).
- [BAG] lokale Baganator, versie 862, `E:\World of Warcraft\_forever_\Interface\AddOns\Baganator`.

Let op bij alle DB2-tellingen: Forever `Item` heeft 32008 rijen, `ItemSparse` maar 19326. Items zonder ItemSparse-rij
tellen niet mee. Dat zijn waarschijnlijk items die alleen via de server/hotfix komen (AFGELEID).

---

## 1. ItemDisenchantLoot (Forever)

**Bewering:** alleen class 2 en 4, kwaliteit 2/3/4; skill-eis 0 in elke rij; Forever heeft rijen voor kwaliteit 3
op itemlevel 5-20 die Classic Era niet heeft.

**Oordeel: KLOPT** (alle drie de delen). GEMETEN in [DB2-F] en [DB2-E].

- Forever: 54 rijen. Elke rij heeft Class 2 of 4, Quality 2, 3 of 4, Subclass -1, SkillRequired 0, ExpansionID -2.
- Classic Era: 50 rijen, ook allemaal SkillRequired 0.
- Alleen in Forever: rij 335 (q3, 5-15, armor), 336 (q3, 16-20, armor), 337 (q3, 16-20, wapen), 338 (q3, 5-15, wapen).
- Extra verschil dat niet in de bewering stond: rij 9 en 10 (q3) beginnen in Era op 20-25, in Forever op 21-25.
- Extra: er is geen enkele rij onder itemlevel 5. Epics (q4) hebben pas rijen vanaf 40.
  Een epic van ilvl 30 of een groen item van ilvl 1 heeft dus geen buitrij. In Forever zijn er 29 groene+
  wapens/armor zonder vlag 0x8000 die toch geen passende rij hebben (vooral ilvl 1, en 8 epics op ilvl 30-35). GEMETEN.
  Of zulke items in het spel echt niet te disenchanten zijn: AFGELEID, niet in het spel gemeten.
- Subclass -1 betekent "elke subclass". In [TC] `Item::GetBaseDisenchantLoot` staat `if (disenchant->Subclass >= 0 && ...) continue;`,
  dus -1 slaat de subclass-check over. GEMETEN in [TC] (retail-servercode, niet de Forever-server).

**Gevolg voor de bouw (AFGELEID):** de skill-eis staat NIET in de clientdata. "Disenchant: yes" kan dus alleen
"mag in principe" betekenen, niet "jij hebt genoeg skill". De client kent wel de teksten
`ITEM_DISENCHANT_MIN_SKILL` = "Disenchanting requires %s (%d)", `ITEM_DISENCHANT_ANY_SKILL` = "Disenchantable" en
`ITEM_DISENCHANT_NOT_DISENCHANTABLE` = "Cannot be disenchanted" (GEMETEN in [DB2-F] GlobalStrings, regels 16771-16773).
Of de Forever-tooltip die regels echt toont: NIET GEMETEN. Dat is in het spel na te kijken; als ja, is dat een betere bron
dan onze eigen tabel.

[WIKI-DE] geeft een skill-tabel (groen: 1 voor ilvl 1-20, 25 voor 21-25, 50 voor 26-30 ... 225 voor 61-99), maar zegt zelf
"pre Battle for Azeroth" en is niet voor Classic of Forever gemaakt. Niet zonder meer overnemen.

---

## 2. Vlag 0x8000 = "no disenchant"

**Bewering:** ItemSparse Flags_0 bit 0x8000 = ITEM_FLAG_NO_DISENCHANT (TrinityCore).

**Oordeel: KLOPT.** GEMETEN in drie emulators:
- [TC] `ItemTemplate.h` regel 205: `ITEM_FLAG_NO_DISENCHANT = 0x00008000,`
- [MANGOS] vmangos: `ITEM_FLAG_NO_DISENCHANT = 0x00008000,`
- [MANGOS] cmangos-classic: `ITEM_FLAG_NO_DISENCHANT = 0x00008000, // a lot of items have this`
- [TC] `Item::GetBaseDisenchantLoot` geeft niets terug bij `ITEM_FLAG_CONJURED`, `ITEM_FLAG_NO_DISENCHANT`,
  `BIND_QUEST`, een item met area/map-binding, een stapel groter dan 1, of geen verkoopprijs.

Kanttekening (AFGELEID): vmangos en cmangos gebruiken op de server een eigen `DisenchantID` per item. De echte
waarheid ligt dus op de server. De vlag plus de DB2-tabel is een goede benadering, geen garantie.

**Hoeveel groene+ wapens/armor hebben de vlag?** GEMETEN in [DB2-F] (Item + ItemSparse samen):
- 5138 wapens/armor van kwaliteit 2-4. Daarvan hebben **1615** de vlag (31 %). 3523 hebben hem niet.
- Per kwaliteit: q2 118, q3 863, q4 634.
- Ik kan dit getal niet vergelijken met dat van de vorige helper, want ik heb zijn verslag niet gelezen.

**Welke soorten?** GEMETEN, indeling door mij (de groepen op naam zijn AFGELEID):
- **PvP-rank-gear: KLOPT.** 441 items met `RequiredPVPRank > 0`. Ze hebben ALLE 441 de vlag.
- **Insignia: KLOPT.** Insignia of the Alliance 18854 en Insignia of the Horde 18834: Flags_0 = 32768 (0x8000).
  Ook Frostwolf/Stormpike Insignia Rank 1-6 hebben hem.
- **Battleground-reputatiegear: hoort erbij** (de bewering noemde dit niet). Ongeveer 264 items (AV, AB, WSG: Frostwolf,
  Stormpike, Legionnaire's, Defiler's, Highlander's, Sentinel's, ...). Dat past bij [WIKI-DE]: "Faction reputation
  vendor-purchased armor and weapons" kun je niet disenchanten.
- **Enchanter-wands: KLOPT.** Lesser Magic Wand 11287 heeft de vlag (Flags_0 = 32768), dus NIET te disenchanten.
  11 van de 55 groene+ wands hebben de vlag. 9 daarvan maak je met Enchanting: 11287, 11288, 11289, 217287, 249144,
  249232, 249234, 249237, 249385. Hun maakspells (14293, 14807, 14809, 14810, 439134, 1248461, 1248505, 1248509,
  1248515, 1248650) staan allemaal onder SkillLine 333 (GEMETEN in SpellEffect + SkillLineAbility). [WIKI-DE] zegt ook:
  "Wands crafted by an Enchanter" niet. De andere twee met vlag (270084 Master Hunter's Wand, 281733 Restored Wand)
  hebben geen maakspell in DB2.
  Let op: Greater Mystic Wand heeft in Forever ID **217287**. ID 11290 staat niet in Forever ItemSparse. Dezelfde query
  gaf voor andere ID's wel 9 rijen. Gebruik dus geen ID's uit Classic Era zonder ze na te meten.
- **"ZG idols": KLOPT NIET zoals gezegd.** De items die echt "Idol" heten met vlag (20866-20882, Azure Idol ... Idol of War)
  zijn class 12 (quest), geen wapen/armor. Primal Hakkari Idol 22637 is class 15 en heeft GEEN vlag. Van Zul'Gurub
  hebben wél de vlag: de Zandalar-setstukken (19822-19849, 20033, 20034; armor, q4), de Zandalarian Shadow Talismans
  19614-19617, en de Hakkari Bijous en Punctured Voodoo Dolls (allebei class 12, dus niet relevant). Druïde-relic-idols
  (armor subclass 8) hebben het deels: 7 van de 22.
- **Overige klassieke ID's:** 193 items, bijvoorbeeld Pendant of Myzrael 4614, Rhok'delar 18713, AQ-ringen, Signet Ring of
  the Bronze Dragonflight en ZG-beloningen.
- **Nieuwe Forever-ID's (>= 200000):** 744 van de 1917 hebben de vlag. Daaronder vallen veel "Premier ..."-PvP-stukken en
  "Restored ..."-items op ilvl 1.

Steekproef Forever ItemSparse (GEMETEN):

| ID | naam | ilvl | q | Flags_0 | vlag? |
|---|---|---|---|---|---|
| 11287 | Lesser Magic Wand | 15 | 2 | 32768 | ja |
| 11288 | Greater Magic Wand | 23 | 2 | 32768 | ja |
| 18854 | Insignia of the Alliance | 1 | 3 | 32768 | ja |
| 18834 | Insignia of the Horde | 1 | 3 | 32768 | ja |
| 16342 | Sergeant's Cape (pvp rank 7) | 63 | 3 | 32768 | ja |
| 20444 | Sentinel's Medallion | 23 | 3 | 32768 | ja |
| 19813 | Punctured Voodoo Doll (class 12) | 1 | 2 | 33792 | ja (geen armor) |
| 6664 | Voodoo Mantle | 26 | 2 | (geen vlag) | nee |
| 1996 | Voodoo Band | 37 | 2 | (geen vlag) | nee |

---

## 3. Ringen, kettingen, trinkets en mantels

**Bewering:** dat kan in Classic; welke subclasses?

**Oordeel: subclass-ID's KLOPT, maar deels anders dan de vraag dacht.** GEMETEN in [DB2-F] Item-tabel. De
enum-namen komen uit [TC] `ItemTemplate.h`.
- Ring (INVTYPE_FINGER 11), ketting (INVTYPE_NECK 2), trinket (INVTYPE_TRINKET 12) en "held in off-hand"
  (INVTYPE_HOLDABLE 23) zijn allemaal **armor subclass 0** (ITEM_SUBCLASS_ARMOR_MISCELLANEOUS).
- Mantels (INVTYPE_CLOAK 16) zijn **armor subclass 1** (ITEM_SUBCLASS_ARMOR_CLOTH): 166 stuks. Plus 4 in subclass 5
  (COSMETIC). Een mantel is dus NIET subclass 0.
- Tabards (INVTYPE_TABARD 19) staan in subclass 0 (3 stuks) en 5 (2 stuks). [WIKI-DE] zegt: tabards kun je niet disenchanten.
- Kunnen ze in principe? AFGELEID: ja. Alle armor-rijen in ItemDisenchantLoot hebben Subclass -1 (= alles). Van de
  groene+ subclass-0-items heeft een deel de vlag: kettingen 69/174, ringen 84/269, trinkets 76/186, off-hands 18/142.
  De rest heeft geen vlag.
- [WIKI-DE] noemt ringen, kettingen, trinkets en mantels niet apart. Een bron die "ja, in Classic" letterlijk zegt, heb ik
  niet gevonden. **NIET TE METEN** zonder test in het spel (bijvoorbeeld een groene ring zoals Voodoo Band 1996).

---

## 4. Tooltip-API en C_Item.GetItemInfo in Forever

**Oordeel: KLOPT.** GEMETEN in [UI-F]:
- `TooltipDataProcessor.AddTooltipPostCall(tooltipType, func)` staat in
  `Interface/AddOns/Blizzard_SharedXMLGame/Tooltip/TooltipDataHandler.lua` regel 199 (de tabel op regel 177). De TOC
  `Blizzard_SharedXMLGame.toc` regel 9 laadt dit bestand zonder `AllowLoadGameType`-filter, dus voor elke speltype. Een
  callback van een addon (onveilige code) loopt via `forceinsecure()` en een AttributeDelegate (regel 186-191).
  Dat het in het spel ook echt vuurt: NIET in de client gemeten.
- `Enum.TooltipDataType.Item` = 0: `Blizzard_APIDocumentationGenerated/TooltipInfoSharedDocumentation.lua` regel 96.
- `C_Item.GetItemInfo(itemInfo)` staat in `ItemDocumentation.lua` regel 626 (Namespace `C_Item`, regel 5). Hij geeft
  terug: itemName, itemLink, **itemQuality** (3e), **itemLevel** (4e), itemMinLevel, itemType, itemSubType,
  itemStackCount, itemEquipLoc, itemTexture, **sellPrice** (11e), **classID** (12e), **subclassID** (13e), bindType,
  expansionID, setID, isCraftingReagent, itemDescription. Let op: `MayReturnNothing = true`. Is het item nog niet
  geladen, dan krijg je niets terug.
- `C_Item.GetItemInfoInstant` (regel 659) geeft direct itemID, itemType, itemSubType, itemEquipLoc, icon, classID en
  subClassID, ook zonder cache. Kwaliteit, ilvl en prijs zitten daar niet in.
- `C_Item.GetDetailedItemLevelInfo` bestaat (regel 354).
- Forever heet in de UI-code "camelot". `Blizzard_UIPanels_Game.toc` regel 119 laadt
  `[Game]\ContainerFrame.lua [AllowLoadGameType camelot]` = `Camelot/ContainerFrame.lua`. Dat is de Blizzard-tassencode
  voor Forever (GEMETEN; voor het tas-icoontje is dat het bestand om te lezen).

---

## 5. Baganator

**Licentie: All Rights Reserved.** GEMETEN in `...\Baganator\LICENSE` regel 1-3: "All Rights Reserved / Copyright (c) 2023-2026 plusmouse".
AFGELEID: hun publieke API aanroepen mag; code overnemen mag niet.
Versie: `Baganator.toc` regel 4 `## Version: 862`. Regel 1 `## Interface: 120100, 120105, 16001, ...` (16001 = Forever).

Signaturen (GEMETEN, `E:\World of Warcraft\_forever_\Interface\AddOns\Baganator\API\Main.lua`):
- regel 21: `function Baganator.API.RequestItemButtonsRefresh(reason)`
  - `reason` is een lijst. Leeg of nil wordt `{ItemWidgets, Searches}` (regel 22). Hij vuurt één frame later
    (`C_Timer.After(0, ...)`, regel 27).
  - Waarden: `Baganator.Constants.RefreshReason = { ItemWidgets = 4, Searches = 16 }` (`Core\Constants.lua` regel 237-240).
- regel 229: `function Baganator.API.RegisterCornerWidget(label, id, onUpdate, onInit, defaultPosition, isFast)`
  - De uitleg in hun eigen commentaar staat op regel 211-228:
    `onUpdate(cornerFrame, itemDetails) -> true` (tonen) / `false` (niet tonen) / `nil` (gegevens nog niet binnen; dan
    probeert hij het later opnieuw). `onInit(itemButton) -> Frame`. `defaultPosition = {corner = "top_left" | "top_right" | "bottom_left" | "bottom_right", priority = number}` (optioneel).
  - `isFast` staat niet in het commentaar. Regel 231 slaat het op en `ItemViewCommon\ItemButton.lua` regel 148 gebruikt het:
    met `isFast` draait onUpdate ook als hun tijdslimiet op is.
  - Regel 230: `assert(id and label and onUpdate and onInit and not ...IconCornerPlugins[id])`. Twee keer hetzelfde id geeft dus een fout.
- `itemDetails` = `itemButton.BGR` = `Syndicator.Search.GetBaseInfo(cacheData)`
  (`...\Syndicator\Search\BaseInfo.lua` regel 4-25). Velden: itemLink, itemID, quality, itemCount, isBound, hasLoot,
  tooltipGetter. Baganator voegt bagType toe (ItemButton.lua regel 199), en soms itemLocation/guid (regel 170-172).

---

## 6. Secure knop (SecureTemplates.lua, Forever)

**Oordeel: attribuutnamen KLOPT; ze werken voor elk type, niet alleen voor "spell".** GEMETEN in [UI-F]
`Interface/AddOns/Blizzard_FrameXML/SecureTemplates.lua`:
- `type = "spell"` roept `CastSpellByID(spellID, unit)` aan, of `CastSpellByName` als het geen getal is (regel 396-405).
- Daarna, in `OnActionButtonClick` (regel 768-784), voor ELK actietype:
  `if SpellCanTargetItem() or SpellCanTargetItemID() then`
  - `"target-bag"` + `"target-slot"` geeft `C_Container.UseContainerItem(bag, slot)` (regel 770-774).
  - alleen `"target-slot"` geeft `UseInventoryItem(slot)` (regel 776).
  - anders `"target-item"` geeft `SpellTargetItem(item)` (regel 779-781).
  De exacte namen zijn dus `target-bag`, `target-slot` en `target-item`.
- Werkt het voor Disenchant 13262? AFGELEID: ja. [DB2-F] `SpellTargetRestrictions` voor 13262 heeft `Targets = 16`, en dat is
  `TARGET_FLAG_ITEM = 0x00000010` ([TC] `SpellDefines.h`). [DB2-F] `SpellEffect` 13262 heeft Effect 99 =
  `SPELL_EFFECT_DISENCHANT` ([TC] `SharedDefines.h` regel 1445). Na het casten wacht de cursor dus op een item, en
  dan is `SpellCanTargetItem()` waar. In het spel NIET GEMETEN.
- Let op: of de knop op key-down of key-up reageert, hangt af van het attribuut `useOnKeyDown` of de CVar
  `ActionButtonUseKeyDown` (regel 792-799).
- **SetAttribute en combat:**
  - [WIKI-SEC]: secure templates stel je in met `frame:SetAttribute()` "but only outside combat". Controleer eerst
    `InCombatLockdown()`. Een beschermde methode "cannot be successfully called on a protected frame from a tainted execution
    state during combat."
  - [UI-F] `RestrictedActionsDocumentation.lua` heeft `InCombatLockdown` (regel 45) en het event `ADDON_ACTION_BLOCKED`
    (regel 77).
  - AFGELEID: in combat wordt SetAttribute op de secure knop geblokkeerd (ADDON_ACTION_BLOCKED, BugSack meldt het). Het
    doelitem blijft dan staan op wat het vóór combat was. Dus: alleen buiten combat bijwerken, op `PLAYER_REGEN_ENABLED`
    opnieuw zetten, en in combat de knop grijs maken of verbergen (verbergen mag ook pas buiten combat).
  - Of Disenchant zelf in combat werkt: NIET GEMETEN.

---

## 7. Kent de speler Disenchant, en hoeveel Enchanting-skill heeft hij?

GEMETEN in [UI-F] en [DB2-F]:
- [DB2-F] SpellName 13262 = "Disenchant"; SkillLine 333 = "Enchanting"; SkillLineAbility 7316: SkillLine 333,
  Spell 13262, MinSkillLineRank 1, AcquireMethod 1. AFGELEID: je krijgt Disenchant meteen bij het leren van Enchanting.
- **`C_SpellBook.IsSpellKnown(spellID, spellBank = Player)`** staat in `SpellBookDocumentation.lua` regel 738 (Namespace
  `C_SpellBook`, regel 5). Dit is de juiste keuze. Er zijn ook `C_SpellBook.IsSpellInSpellBook` (regel 720) en
  `C_SpellBook.IsSpellKnownOrInSpellBook` (regel 755).
- **`IsPlayerSpell`, `IsSpellKnown` en `IsSpellKnownOrOverridesKnown` zijn in Forever alleen Lua-reserves.** Ze staan in
  `Blizzard_DeprecatedSpellBook/Deprecated_SpellBook.lua` regel 11-26, achter
  `if not GetCVarBool("loadDeprecationFallbacks") then return end` (regel 4). `IsPlayerSpell` roept daar gewoon
  `C_SpellBook.IsSpellKnown` aan. AFGELEID: niet op bouwen, want ze bestaan niet als die CVar uit staat. Dat is
  hetzelfde patroon als bij de spec-API in retail.
- **`GetProfessions()` / `GetProfessionInfo(index)`** gebruikt Blizzard zelf in Forever:
  `Blizzard_ProfessionsBook/Camelot/Blizzard_ProfessionsBook.lua` regel 21 en 55.
  - Let op: in Forever is de volgorde `prof1, prof2, faid, fish, cook`. De derde is **First Aid**, niet archeologie
    zoals in retail (`Blizzard_ProfessionsBook.lua` regel 52: `prof1, prof2, arch, fish, cook`).
  - `GetProfessionInfo` geeft `name, texture, rank, maxRank, numSpells, spellOffset, skillLine, ...`. skillLine (7e) = 333
    voor Enchanting, en `rank` is de skill.
  - Alternatief: `C_TradeSkillUI.GetProfessionInfoBySkillLineID(333)` (zelfde bestand, regel 30). Blizzard valt daar terug
    op `rank`/`maxRank` als die functie 0/0 geeft (regel 32-35). AFGELEID: die functie is dus niet altijd gevuld.
  - Ook `C_SkillInfo.GetNumSkillLines()` en `C_SkillInfo.GetSkillLineInfo(i)` bestaan
    (`Blizzard_UIPanels_Game/Camelot/SkillsFrame.lua` regel 153-154).

---

## Kort

| # | bewering | oordeel |
|---|---|---|
| 1 | alleen class 2/4, q2-4; skill 0; q3 ilvl 5-20 alleen in Forever | KLOPT (+ rij 9/10 verschilt: 21 vs 20) |
| 2 | 0x8000 = NO_DISENCHANT | KLOPT (TC, vmangos, cmangos) |
| 2 | aantal groen+ met vlag | 1615 van 5138 (GEMETEN) |
| 2 | PvP-rank / insignia / enchanter-wands | KLOPT (alle 441 PvP-rank-items; 11287 heeft de vlag) |
| 2 | ZG idols | KLOPT NIET: "Idol"-items met vlag zijn class 12 (quest); de ZG-armor met vlag zijn de Zandalar-sets |
| 3 | ring/ketting/trinket subclass 0; mantel | subclass 0 KLOPT; mantel = subclass 1 (cloth). Echt disenchanten in het spel: NIET TE METEN |
| 4 | AddTooltipPostCall / C_Item.GetItemInfo | KLOPT (Forever-UI-bron 70959) |
| 5 | Baganator | All Rights Reserved; signaturen zie boven (Main.lua r. 21 en 229) |
| 6 | target-bag / target-slot / target-item | KLOPT, werkt na elk actietype als SpellCanTargetItem(); SetAttribute alleen buiten combat |
| 7 | IsPlayerSpell enz. | gebruik C_SpellBook.IsSpellKnown(13262); de oude globals zijn reserves achter een CVar |

Nog in het spel te meten: (a) toont de Forever-tooltip "Disenchanting requires Enchanting (X)"? (b) een groene ring,
ketting en trinket echt disenchanten; (c) de secure knop met Disenchant + target-bag/slot; (d) bestaat `IsPlayerSpell`
in Forever met de standaard-CVars?

Hulpbestanden (alleen lezen, in de scratchpad): `de_analyse.py`, `de_analyse2.py`, `de_analyse3.py` (lezen de
gamedata-cache in `%LOCALAPPDATA%\MidnightHelper\gamedata_cache\db2\1.60.1.70959`), uitvoer `de_out_forever.txt` en
`de_out2.txt`, en de gedownloade Blizzard-/TrinityCore-bestanden in `dl_tree\`.
