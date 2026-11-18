# "Beter dan wat je draagt" in MH (WoW Forever) — onderzoek 18 nov 2026

Onderzoek: mh-research. Niets gebouwd, repo niet aangeraakt. Build: Forever 1.60.1.70959.
GEMETEN = zelf in de genoemde bron gelezen (met datum/build). AFGELEID = redenering of samenvatting.
Werkwijze: gamedata is MET argumenten gedraaid, zoals de opdracht vroeg (mijn eigen agentregel zegt `probe_job.txt`;
de opdracht won omdat andere helpers dezelfde map delen). De Blizzard-bronbestanden zijn gelezen via WebFetch op
`Gethe/wow-ui-source`, tak `forever`. WebFetch vat samen met een klein model: namen kloppen waarschijnlijk, maar de
bouwer leest exacte handtekeningen zelf na. In het spel zelf is NIETS gedraaid.

---

## 0. Kort antwoord

- MH zegt het al op drie plekken (tooltip, questbeloning, "upgrade in je tassen"), met één gedeelde rekensom.
- Die som telt alleen Strength, Agility, Intellect, Spirit, Stamina en armor. GEMETEN in de code.
- Forever-items hebben veel meer: spell power, healing, attack power, hit, crit, defense, wapenschade. GEMETEN in DB2.
  Minstens 2720 van de 4633 uitrustbare items met stats hebben een stat die MH nu niet meetelt (zie 3.1).
- Er zit een echte fout in de wapenvergelijking (eenhandig tegen een lege off-hand). AFGELEID uit de code, niet gedraaid.
- Advies: eerst optie A (repareren + wapenschade), dan optie B (alle stats lezen, eerlijk "beter / gemengd / niet beter",
  en meer plekken). Geen eigen gewichten-getal (optie C): er is geen vrije bron voor en het klinkt zekerder dan het is.

---

## 1. Wat MH nu al heeft

| Onderdeel | Bestand | Spel | Wat het doet | Schakelaar |
|---|---|---|---|---|
| Groene tooltipregel "MH: +3 Strength over what you wear (main stats for a Paladin)." | `Modules/ForeverQuestHint.lua` r. 422-531 (`ns.ForeverGearTipText`) | alleen Forever (`if not ns.IS_FOREVER then return end`, r. 24) | Bij hoveren van uitrusting. Alleen als het item BETER is. Zwijgt anders. | `foreverGearTip`, aan; `/mh geartip on|off`; Overview "Better than what you wear" (`ForeverOverview.lua` r. 1171) |
| Questbeloning-tip | zelfde bestand r. 243-398 | alleen Forever | Bij inleveren (QUEST_COMPLETE) met 2 of meer keuzes: groen kader + regel "Take X: +5 Agility … over what you wear". Niets beter: de duurst verkopende. Klikt nooit zelf. | `foreverQuestHint`, aan; `/mh questhint on|off|check` |
| "Upgrade in your bags" | `Modules/PickupUpgrade.lua` | Forever en Midnight | Telt de tassen bij BAG_UPDATE_DELAYED. Nieuw item + beter = melding op scherm (7 s) + chatregel. In een gevecht wacht hij. | `pickupUpgrade`, aan; `/mh pickup on|off`; instelling `SET_PICKUP_TITLE` |
| Stat-tabel per class en richting | `Modules/ForeverMainStats.lua` | alleen Forever | 9 classes; per richting (boom 1-3) 2 hoofdstats; aparte tank-rij voor Warrior/Paladin/Druid. | richting: `/mh direction` |
| "Your class can never wear/use this" | `Modules/ForeverItemTips.lua` | alleen Forever | Rode tooltipregel als je class dit soort armor/wapen NOOIT kan gebruiken. | `usedForTip` |
| Wapensoorten per class + wapenmeesters | `Modules/ForeverWeapons.lua` | alleen Forever | Welke wapens je class kan leren, welke je kent, waar je ze leert. | `/mh weapons` |
| Richting: zwaarste armor, wapenstijl uit gidsen | `Modules/ForeverDirection.lua` r. 144-186 | alleen Forever | Blok bovenaan "How you play". De kop zegt zelf: "NOT step 3 (tooltip/upgrade notice)". | — |
| Tas-pijltjes en tooltipregel op ilvl + spec | `BagUpgrade.lua`, `LootUpgrade.lua`, `VaultAdvisor.lua` r. 860 | alleen Midnight | Staan NIET in `MidnightHelper_Camelot.toc`. | `/mh bagarrows`, `/mh loot` |

Alles in deze tabel: GEMETEN in de code op 18 nov 2026. De Camelot-toc is helemaal gelezen: `ForeverMainStats.lua` en
`ForeverQuestHint.lua` staan op r. 162-163, `PickupUpgrade.lua` op r. 197; `BagUpgrade`, `LootUpgrade` en `VaultAdvisor`
komen er niet in voor.

### 1.1 De rekensom (GEMETEN, `ForeverQuestHint.lua`)

- Leest stats met `C_Item.GetItemStats(link)`, maar gebruikt alleen vijf sleutels (r. 29-32): `ITEM_MOD_STRENGTH_SHORT`,
  `…AGILITY…`, `…INTELLECT…`, `…SPIRIT…`, `…STAMINA…`.
- Armor: uit `RESISTANCE0_NAME` van die tabel, anders uit de tooltipregel via Blizzards eigen `ARMOR_TEMPLATE` (r. 98-122).
- Score = eerste hoofdstat × 1 + tweede × 0,5 (r. 148; in de kop "MH's own choice, AFGELEID"). Bij `equal` tellen beide 1.
- "Beter" (r. 238-240) = meer hoofdstat-score; gelijk → meer Stamina (waar `stamTie`); nog gelijk → meer armor.
- Twee ringen/trinkets/wapens (r. 37-44, 188-204): hij vergelijkt met de ZWAKSTE van de twee plekken.
- Niet te dragen = een rode regel in de tooltip (r. 439-447). Dan zwijgt hij.
- De rol komt uit de eigen keuze van de speler (`ns.GetForeverDirection()`); zonder keuze de class-standaard
  (`ForeverMainStats.lua` r. 99-109).

### 1.2 Waar het ophoudt (GEMETEN in de code, tenzij anders gezegd)

1. Alleen vijf hoofdstats + armor. Spell power, healing, attack power, hit, crit, haste, defense, mana per 5 sec tellen
   niet. Een caster-item met alleen "Increases damage and healing … by up to 12" is voor MH "niet beter".
2. Wapenschade telt niet. Voor melee, Hunter (ranged) en een toverstaf-wand bij een lage caster is dat juist het
   belangrijkste van een wapen. AFGELEID dat dit het belangrijkste is (gidsen; Pawn weegt wapenschade zwaar).
3. 🔴 Wapenhanden gaan fout. AFGELEID uit r. 41 + 188-204, niet in het spel gedraaid:
   - `INVTYPE_WEAPON = { 16, 17 }`: een eenhandig wapen wordt vergeleken met de zwakste van hoofdhand en off-hand.
     Een LEGE plek telt als score 0. Draag je een tweehander (off-hand leeg), dan lijkt elk eenhandig wapen met één
     hoofdstat "beter", en de questtip zegt er dan bij "That slot is empty now."
   - Dat gebeurt ook bij classes die niet met twee wapens kunnen vechten. GEMETEN (DB2 `SkillRaceClassInfo`, skill 118
     "Dual Wield", build 70959): alleen Rogue (vanaf 10), Warrior en Hunter (vanaf 20) en Shaman (MinLevel 0; in de
     praktijk een talent, AFGELEID). Paladin, Priest, Mage, Warlock en Druid dus nooit.
   - `INVTYPE_SHIELD` / `INVTYPE_HOLDABLE = { 17 }`: met een tweehander aan is plek 17 leeg, dus elk schild of
     off-hand-ding met een hoofdstat lijkt "beter", terwijl je er je tweehander voor moet afdoen.
   - `INVTYPE_2HWEAPON = { 16 }`: vergelijkt alleen met de hoofdhand; wat je in de off-hand kwijtraakt telt niet.
4. Alleen "beter" wordt getoond. "Niet beter" en "gemengd" (meer van het een, minder van het ander) zijn stil.
   `/mh geartip` laat wel de laatste beslissing zien.
5. De hoofdstat beslist alleen. +1 Strength en −10 Stamina is "beter". De min staat wel in de regel (r. 219-227).
6. Armorsoort telt niet mee. Een cloth-borststuk met +2 Strength wint van mail met +1 Strength.
7. Questtip: alleen bij inleveren en alleen bij een KEUZE. Niet in het questlog of bij aannemen, niet voor vaste
   beloningen (events r. 534: alleen QUEST_COMPLETE en QUEST_FINISHED).
8. Pickup-melding: slaat over met verkoper of bank open, bij de eerste telling na inloggen, en voor wat je net droeg
   (r. 201-208). Kopen bij een verkoper geeft dus nooit een melding. Dat is zo bedoeld (kop van het bestand).
9. Geen pijltjes in tassen, niets bij de dobbelronde (Need/Greed), niets bij de verkoper of het veilinghuis, behalve
   de tooltipregel als je er met de muis op staat. Reden in de code (r. 425-427): Rob draait Pawn + Baganator.
10. Midnight-kant (`ns.GetLootUpgradeInfo`): item level + mastery/crit/haste/vers met spec-gewichten, of Pawns waarde
    als Pawn geladen is (schakelaar "Use Pawn", `VaultAdvisor.lua` r. 52-100). Geen oordeel bij een lege plek.

---

## 2. Waar de speler het wil zien, en wat Forever kan

### 2.1 API's en events

| Wat | Bestaat in Forever? | Bron |
|---|---|---|
| `C_Item.GetItemStats`, `C_Item.GetItemStatDelta`, `GetItemInfo`, `GetItemInfoInstant`, `IsEquippableItem`, `IsUsableItem`, `GetDetailedItemLevelInfo` | Gedocumenteerd. | GEMETEN: `ItemDocumentation.lua`, wow-ui-source tak `forever`, kop-commit "1.60.1 (70959)" van 17 nov 2026 (WebFetch 18 nov) |
| `C_TooltipInfo.GetHyperlink / GetBagItem / GetInventoryItem / GetMerchantItem / GetLootItem / GetLootRollItem / GetQuestItem / GetQuestLogItem / GetItemKey` | Gedocumenteerd. | GEMETEN: `TooltipInfoDocumentation.lua`, zelfde tak |
| `C_TooltipComparison.GetItemComparisonInfo / GetItemComparisonDelta / CompareItem` (Blizzards eigen "waarmee vergelijk je": Single, WithBothHands, WithBagMainHandItem, WithBagOffHandItem) | Gedocumenteerd. | GEMETEN: `TooltipComparisonDocumentation.lua`, zelfde tak |
| `C_MerchantFrame.GetItemInfo` (met `isUsable`, `isPurchasable`, `price`) | Gedocumenteerd. | GEMETEN: `MerchantFrameDocumentation.lua`, zelfde tak |
| Events: BAG_UPDATE(_DELAYED), PLAYER_EQUIPMENT_CHANGED, UNIT_INVENTORY_CHANGED, MERCHANT_SHOW/UPDATE, LOOT_OPENED, LOOT_READY, START_LOOT_ROLL, CONFIRM_LOOT_ROLL, LOOT_ROLLS_COMPLETE, QUEST_COMPLETE, QUEST_DETAIL, GET_ITEM_INFO_RECEIVED, ITEM_DATA_LOAD_RESULT, ITEM_PUSH, CHAT_MSG_LOOT, TOOLTIP_DATA_UPDATE, AUCTION_HOUSE_SHOW, AUCTION_HOUSE_BROWSE_RESULTS_UPDATED, PLAYER_TALENT_UPDATE, SKILL_LINES_CHANGED | Alle 22 staan in de Forever-lijst. | GEMETEN: `tools/blizzard_events_snapshot.json`, tak forever, build 1.60.1 (70938), opgehaald 13 nov 2026. Die lijst is volgens de tool zelf een kandidatenlijst. |
| `GetInventoryItemLink`, `GetQuestItemLink`, `GetQuestItemInfo`, `GetNumQuestChoices`, `GetLootRollItemLink` | Niet in de documentatie gezocht (oude globale functies). MH gebruikt de eerste vier al in Forever-modules; Pawn roept `GetLootRollItemLink` aan. | Kandidaat, geen bewijs |
| Frames: verkoper, questvenster, QuestInfo, buitvenster, dobbelvenster (`GroupLootFrame_OnShow`, `self.rollID`, `GetLootRollItemInfo`), ruilvenster = de Mainline-bestanden. Tassen = Mainline `ContainerFrame` + een Camelot-bestand van ongeveer 11 regels. | GEMETEN: `Blizzard_UIPanels_Game.toc` en `Camelot/ContainerFrame.lua`, tak forever. Dat "camelot" binnen de familie "mainline" valt is AFGELEID uit de `[ExcludeLoadGameType camelot]`-regels. |
| Veilinghuis = het moderne `Blizzard_AuctionHouseUI` | Map bestaat in de tak; of Forever hem laadt is AFGELEID uit het event hierboven. | GEMETEN (map), AFGELEID (gebruik) |

🔴 Niet gemeten, en beslissend voor het ontwerp: WAT `C_Item.GetItemStats` in Forever teruggeeft voor de extra stats.
Aanwijzingen (kandidaten, geen bewijs):
- DB2 slaat ze op als echte stat-modifiers, niet als losse spreuken (zie 3.1). Dat pleit voor "ja, met ITEM_MOD-sleutels".
- ForeverDungeonJournal 2.0.12 zegt in een commentaar dat de schrijver het in de Forever-client nakeek: sleutel
  `ITEM_MOD_SPELL_HEALING_DONE_SHORT`, item "Deep Ritual Girdle: healing 16, spell damage 6" (`Systems/LootFilter.lua`
  r. 463-470). Dat item vond ik NIET op naam in DB2 `ItemSparse` 70959 (controle "Ritual" gaf wel 10 rijen), dus dit kon
  ik niet nameten.
- Forever Leveling Guide 4.94 zegt het omgekeerde: "GetItemStats no siempre las trae" (brengt de Equip-regels niet
  altijd mee) en leest daarom óók de tooltip (`wowF_Comparar.lua` r. 85).
- Pawn 2.14.4 en Zygor lezen de stats uit de tooltiptekst.
Meting die dit beslist (2 minuten voor Rob, zie hoofdstuk 6).

### 2.2 Per plek

| Plek | Nu in MH (Forever) | Wat kan (AFGELEID uit 2.1, niet gebouwd of gedraaid) |
|---|---|---|
| Tooltip (overal waar je hovert: tassen, buit, verkoper, veilinghuis, chatlink) | Groene regel, alleen bij "beter" | Zelfde haak; ook "gemengd" en "niet beter" tonen |
| In je tassen gekomen | Melding + chatregel | Blijft; krijgt het betere oordeel vanzelf (zelfde functie) |
| Questbeloning | Kader + regel bij een keuze | Ook in questlog/aannemen (QUEST_DETAIL), ook vaste beloning |
| Dobbelronde in een groep (Need/Greed) | Niets | Regel onder het dobbelvenster: "Beter voor jou: +4 Agility". Hier moet je snel kiezen; grootste winst. Pawn zet hier al een pijl. |
| Buitvenster | Alleen de tooltip | Weinig waarde: meestal auto-loot; de tas-melding vangt het |
| Verkoper | Alleen de tooltip | Merkje op knoppen die beter zijn (en betaalbaar). Koopt nooit zelf. |
| Tassen | Niets (wel het disenchant-icoontje: `ForeverDisenchant.lua` haakt al aan `UpdateItems` en aan Baganators `RegisterCornerWidget`) | Zelfde twee haken voor een MH-pijl. Let op: Baganator heeft al een ingebouwde Pawn-pijl (linksboven, prioriteit 1) en MH's disenchant-icoon zit ook linksboven. |
| Veilinghuis | Alleen de tooltip | Lijst markeren is veel werk (Auctionator vervangt de lijst); tooltip is genoeg |

---

## 3. Hoe beslis je "beter"

### 3.1 Wat er op Forever-items zit (GEMETEN, wago DB2 `ItemSparse` + `GlobalStrings`, build 1.60.1.70959)

- Forever gebruikt het moderne opslagmodel: kolommen `StatModifier_bonusStat_0..9` + `StatPercentEditor_0..9` + `ItemLevel`.
  De hoeveelheid volgt uit item level × procent (AFGELEID uit die kolommen; de rekenregel zelf niet gemeten).
- 4633 uitrustbare items hebben minstens één stat-modifier. Bij 1913 daarvan zijn de eerste zes stat-kolommen alleen
  de vijf hoofdstats. Dus minstens 2720 (59%) dragen een stat die MH nu niet telt. Kanttekeningen: kolom 6-9 niet
  bekeken (dus "minstens"); testitems tellen mee; wit spul zonder stats en "of the Monkey"-items zitten er niet in.
- Voorbeelden, stat-nummer per item: Heavy Linen Gloves 45; Eye of Paleth 41 + 42; Callous Axe 38; Frost Tiger Blade 32;
  Moonsight Rifle 31; Defender Axe 50.
- Wat die nummers betekenen, GEMETEN via de Wowhead-Forever-tooltip van dezelfde items (18 nov): 45 = "Increases damage
  and healing done by magical spells and effects"; 41/42 = healing / spell damage apart; 50 = "+10 Armor" op een wapen.
  38 = attack power, 32 = crit, 31 = hit: AFGELEID (retail-nummering + de tabel in Forever Leveling Guide).
  ⚠️ De Wowhead-tooltip liet bij die laatste drie items GEEN statregel zien. Wowhead-Forever-tooltips zijn dus geen
  betrouwbare bron voor itemstats.
- Er bestaan ook soorten die alleen Classic/Forever kent: schade per school (85, 87, 88 gezien), wapenskill, attack power
  tegen een soort vijand, resistances, beroep-skill (112 op Herbalist's Gloves, 117 op vishengels). Betekenis per nummer
  AFGELEID uit de itemnamen.
- De client heeft voor al die soorten een eigen naam: 140 `ITEM_MOD_…_SHORT`-strings (o.a. Spell Power, Spell Healing,
  Spell Damage, Attack Power, Ranged Attack Power, Hit, Critical Strike, Haste, Defense, Block Value, Bonus Armor,
  Fire Damage, Swords Skill, Fishing Skill, Attack Power Vs Undead, "damage per second").
- En een eigen tooltipzin: 160 `TOOLTIP_ITEM_STAT_…`-strings, bv. "Equip: +%1$d Attack Power.", "Equip: Improves your
  chance to hit by %1$.1f%%.", "Equip: Restores %1$d Mana per 5 sec.", "+%1$d Armor". Hit en crit staan in de tooltip
  als procent. Er is geen aparte "met spells"-variant voor hit/crit in die lijst (Pawns readme zegt hetzelfde:
  spell hit/crit/haste zijn in Forever van items gehaald).
  → Met die strings kan MH tooltipregels in ELKE taal herkennen, net zoals nu al met `ARMOR_TEMPLATE`. AFGELEID.
- Daarnaast 1361 "bij aandoen"-spreuken op items (`ItemEffect`, TriggerType 1; voorbeelden: Haste, Drain Life,
  Flamestrike, Bone Armor). Dat zijn speciale effecten die geen stat zijn. Niet te wegen; wel eerlijk te melden.
  (TriggerType 1 = bij aandoen: AFGELEID uit de retail-betekenis.)

### 3.2 Gewichten: welke bronnen, en voor elke class?

| Bron | Wat | Elke class? | Mag MH het overnemen? |
|---|---|---|---|
| Het spel zelf: `ChrClasses` | Attack power per Strength: Warrior 2, Paladin 2, Hunter 1, Rogue 1, Priest 1, Shaman 2, Mage 1, Warlock 1, Druid 2. Per Agility: Hunter 1, Rogue 1, rest 0. Ranged AP per Agility: Warrior 2, Hunter 2, Rogue 2. | 9 van 9 | Ja, Blizzard-data. GEMETEN build 70959. Hiermee kun je attack power en Strength/Agility EXACT bij elkaar optellen. |
| MH's eigen tabel (`ForeverMainStats.lua`, onderzoek 7 en 16 nov) | Volgorde van hoofdstats per class × richting, plus tank-rij | 9 van 9, 27 richtingen | Is al van MH. Alleen volgorde, geen getallen, alleen hoofdstats. |
| Gidsen (Icy Veins, Mobalytics, Warcraft Tavern, SixtySim) | Volgorde, geen getallen | Niet elke rol (staat in `STATS_PER_ROL_2026-11-16.md`: bv. geen Icy Veins-lijst voor Resto Shaman) | Volgorde citeren met bron: ja |
| Pawn 2.14.4, `ClassicHawsJon.lua`, Forever-blok | Getallen voor ongeveer 50 stats per schaal, 29 schalen: Druid 4, Rogue 4, de andere zeven elk 3 | 9 van 9 | NEE. CC BY-NC-ND 3.0 (GEMETEN in elke bestandskop + Readme r. 131): gebruiken en delen mag, afgeleide versies niet. |
| GearQuest Forever (Henrik8210) | Gewichten per spec | onbekend | NEE volgens MH's eigen codecommentaar ("All Rights Reserved", `ForeverQuestHint.lua` r. 19). Niet geïnstalleerd; licentie niet zelf gezien. |
| "Pawn Forever" (turlockmike, GitHub) | Gewichten voor Pawn, alle 9 classes | 9 van 9 volgens de README | MIT-label (GEMETEN via WebFetch 18 nov), maar de README zegt dat de tabellen uit GearQuest komen. Een MIT-label wast die herkomst niet schoon. Niet overnemen. |
| Zygor Forever (`Item-ItemScore.lua`) | Eigen itemscore | onbekend | TOC zegt `X-License: GPL` (GEMETEN). GPL-code kan niet in MIT-MH. Alleen ideeën. |
| Forever Leveling Guide 4.94 (Andy) | Gewichten per boom + vergelijker | onbekend | Geen licentie gevonden in toc/md/txt (alleen lettertype-licenties) → behandelen als alle rechten voorbehouden. |

Eén zoekronde op het web naar vrije Forever-gewichten of Pawn-strings gaf niets (18 nov). Een lege zoekronde bewijst niets.
Conclusie (AFGELEID): voor "één getal per item" is er geen bron die MH mag overnemen. Zelf getallen maken kan alleen
voor wat het spel zelf vastlegt (attack power per stat). De rest is een oordeel.

### 3.3 Item level

Zegt hoeveel stat-budget een item heeft, niet of het de goede stats zijn (AFGELEID uit 3.1). Een blauw item met lager
item level kan beter zijn dan een groen met hoger. Hooguit bruikbaar als allerlaatste gelijkmaker, nooit als oordeel.

### 3.4 Valkuilen

1. Wapenhanden: tweehander tegen eenhander + off-hand; classes zonder Dual Wield (zie 1.2 punt 3). Blizzard heeft hier
   zelf logica voor (`C_TooltipComparison.GetItemComparisonInfo`); of die in Forever bruikbare data geeft: niet gemeten.
2. Twee ringen / twee trinkets: vergelijk met de zwakste; een lege plek = altijd winst. Trinkets hebben meestal een
   effect in plaats van stats: Pawn slaat ze over voor het score-oordeel (GEMETEN `Pawn.lua` r. 3601).
3. Uniek: van een "Unique"-ring kun je er geen twee dragen. Zygor houdt hiervoor een eigen lijst bij omdat de client
   het niet altijd meldt (GEMETEN als commentaar in `Code-Forever/Item-DataTables.lua` r. 116; kandidaat).
4. Wapen dat je nog moet leren: nu een rode regel → MH zwijgt. Kans: MH kan zeggen "eerst Maces leren bij een
   wapenmeester" (data staat in `ForeverWeapons.lua`).
5. Nog te laag level: ook een rode regel → stil. "Over 2 levels beter" zou kunnen, maar is extra.
6. Armorsoort: mail op 40 voor Hunter/Shaman, plate op 40 voor Warrior/Paladin (GEMETEN in `ForeverDirection.lua`
   r. 145-150, bron DB2). Voor melee en tanks is cloth met een beetje meer stat vaak NIET beter.
7. Schade van één school ("Fire spells"): alleen iets waard als jouw richting die school gebruikt. Forever Leveling
   Guide kreeg hier een foutmelding over (Frost Mage kreeg een vuur-wand als verbetering; commentaar r. 40-43).
8. "Of the Monkey"-items: de stats zitten in de link, niet in het basis-item. Vergelijk altijd op de LINK. Kandidaat
   (Forever Leveling Guide r. 149-150), niet gemeten.
9. Speciale effecten (proc, "Use:", set-bonus): niet te wegen. Zeg dat erbij in plaats van te zwijgen.
10. Gereedschap dat een wapen is (Mining Pick, Skinning Knife, vishengel): zodra wapenschade meetelt mag MH die nooit
    als wapen-upgrade aanprijzen, en een vishengel niet "slechter" noemen. De hengels hebben stat 117 (Fishing Skill).
11. Hit en crit staan in de tooltip als procent, in de data als rating. Wie tooltip en `GetItemStats` mengt, telt dubbel
    of in twee maten (Pawn rekent hiervoor om; GEMETEN `ClassicHawsJon.lua` r. 21-40).
12. Item nog niet geladen: `GetItemInfo` geeft nil. MH wacht daar al op (pickup: 5 pogingen; questtip: 10).
13. Rol onbekend: Forever heeft per class één spec; MH gebruikt de eigen richting van de speler. Geen keuze = de
    class-standaard, en die is voor healers en tanks fout. Zeg er dan bij "voor een <rol>; kies je richting".
14. Twee addons, twee oordelen: Rob draait Pawn + MH (GEMETEN in elke `AddOns.txt` van zijn Forever-characters). Pawn
    kan in Forever niet automatisch één schaal kiezen (`VgerCore.SpecsExist` is false; "Automatic mode can't be enabled
    in this version", `Pawn.lua` r. 5466-5468). Wat Pawn dan toont is AFGELEID: alle schalen van je class, dus een pijl
    zodra het voor ÉÉN boom beter is. MH en Pawn gaan elkaar dus geregeld tegenspreken.
15. Factie: geen aparte regel nodig; een item dat je ras/factie niet mag dragen krijgt een rode regel (AFGELEID).

---

## 4. Andere addons in `_forever_\Interface\AddOns\` (alleen ideeën, geen code)

| Addon | Wat het doet | Licentie | Wat MH ervan mag |
|---|---|---|---|
| Pawn 2.14.4 (Vger; map van 17 nov) | Leest stats uit de tooltiptekst per taal. Gewichten per class/boom (HawsJon). Tooltipregels, pijl bij de dobbelronde (`GroupLootFrame1-4`), bij "loot won", in de loot-historie (alleen als het oude venster `LootHistoryFrame` bestaat), questbeloning (ook in het questlog), tas-pijltjes (optie). Bij verkoper en veilinghuis alleen de tooltip, geen merk op de knoppen (grep op Merchant/Auction in `Pawn*.lua/xml`: alleen tooltip-haken). Wat daarvan in Forever echt verschijnt: niet in het spel gezien. Slaat trinkets over; toont geen 1H-upgrade als je een 2H draagt en omgekeerd (r. 3605-3630); upgrade pas vanaf 0,5% beter (r. 3764). | CC BY-NC-ND 3.0 | Niets kopiëren, ook de getallen niet. Publieke functies AANROEPEN mag: `PawnBags.lua` r. 8-14 nodigt bag-addons daar zelf toe uit (`PawnShouldItemLinkHaveUpgradeArrow`). MH doet dat op retail al ("Use Pawn"). |
| Baganator 864 (plusmouse) | Tassen. Publieke API: `RegisterCornerWidget` (hoek-icoon), `RegisterUpgradePlugin(label, id, callback)` (wie bepaalt "upgrade"), ingebouwde Pawn-koppeling. | All Rights Reserved (`LICENSE`) | Alleen de API aanroepen (doet MH al voor disenchant). |
| Auctionator 348, Syndicator 291 | Veilinghuis, item-index | All Rights Reserved | Niets overnemen. |
| ZygorGuidesViewerForever 1.6 | Eigen itemscore met tooltip-patronen | TOC: GPL | Alleen ideeën (lijst uniek-items; spreuken die stats geven). |
| Forever Leveling Guide 4.94 (Andy) | Vergelijkt buit met wat je draagt, met "waarom". Kiest "onzeker" als iets niet te lezen is, en zegt dan NIET dat het beter is. | geen gevonden | Alleen ideeën. Dat "onzeker = niets beweren" past precies bij MH. |
| ForeverDungeonJournal 2.0.12 (Exehn) | Buitfilter op stats; gebruikt `GetItemStats` voor niet-Engelse clients | niet vermeld in de toc | Alleen als aanwijzing (zie 2.1). |
| TFTB | Alleen diagnose-code met GetItemStats | MIT | Niet relevant. |
| Niet geïnstalleerd: GearQuest Forever, "Pawn Forever" | Zie 3.2 | ARR (volgens MH-commentaar) / MIT-label | Niet overnemen. |

Alles GEMETEN in de bestanden op 18 nov 2026, behalve de laatste rij (WebFetch + MH's eigen commentaar).

---

## 5. Voorstel

Vooraf, voor elke optie: de meting uit hoofdstuk 6. Die bepaalt of MH de stats uit `GetItemStats` haalt of uit de
tooltipregels (of allebei).

### Optie A — Repareren en wapens eerlijk maken (klein)

- Wat de speler ziet: dezelfde groene regel, de questtip en de tas-melding, maar zonder de foute wapen-adviezen.
  Bij wapens ook "meer schade per seconde".
- Inhoud:
  1. Wapenhanden goed: niet vergelijken met een lege off-hand als je een tweehander draagt of niet met twee wapens
     kunt vechten; tweehander tegen hoofdhand + off-hand samen; schild/off-hand-ding terwijl je een tweehander draagt:
     zwijgen of zeggen "dan moet je je tweehander afdoen".
  2. Wapenschade meetellen op wapenplekken (melee: hoofdhand; Hunter: ranged; caster: wand). Gereedschap uitsluiten.
  3. `/mh geartip` drukt ook af met welke plek hij vergeleek.
- Werk: 1 bestand (`ForeverQuestHint.lua`) + een paar regels in `enUS.lua`. Ongeveer 1 dagdeel bouwen + Robs test.
- Risico: laag. Het blijft bij vijf hoofdstats: een caster-item met alleen spell power blijft stil.

### Optie B — Alle stats lezen, drie uitkomsten, meer plekken (middel)

- Wat de speler ziet, bv.:
  - "MH: beter — +6 Spell Power, +2 Intellect (voor een Frost Mage)."
  - "MH: gemengd — +5 Attack Power, −4 Stamina. Jij kiest."
  - (schakelaar, standaard uit) "MH: niet beter — −3 Strength." Dan kun je met een gerust hart verkopen.
  - "Heeft ook een speciaal effect; dat kan MH niet wegen."
  - "Je kunt nog geen Maces gebruiken: leer het bij een wapenmeester." (alleen als het item anders beter was)
- Hoe: per rol een korte lijst "stats die tellen" (volgorde uit de gidsen, met bron). "Beter" alleen als niets wat telt
  omlaag gaat en minstens één ding omhoog. Anders "gemengd", met beide kanten erbij. Attack power wordt met de
  Blizzard-getallen uit `ChrClasses` bij Strength/Agility opgeteld. Geen verzonnen wisselkoers tussen andere stats.
- Plekken, elk met een eigen schakelaar:
  B1. Tooltip, questtip, tas-melding (delen de functie al; komt vanzelf mee).
  B2. Dobbelronde in een groep: één regel onder het venster. Standaard aan.
  B3. Verkoper: merkje op wat beter is. Standaard aan.
  B4. Tassen: MH-pijl in Blizzard-tassen en Baganator. Standaard UIT als Pawn geladen is (anders twee pijlen).
- Werk: nieuw bestand voor het lezen van stats (`ForeverGearStats.lua` o.i.d.), een rol-tabel naast
  `ForeverMainStats.lua`, aanpassing van `ForeverQuestHint.lua`, schakelaars in `ForeverOverview.lua`, teksten in
  `enUS.lua`. B1: 2 dagdelen. B2: 1. B3: 1. B4: 1. Samen 4-5 dagdelen, in stappen te testen.
- Risico: middel. De rol-lijsten zijn een oordeel uit gidsen die het soms oneens zijn (dat staat al in de 16-nov-doc);
  "gemengd" vangt dat eerlijk op. Tooltipregels herkennen per taal moet op een niet-Engelse client getest worden.

### Optie C — Eén getal per item met gewichten (groot) — afgeraden

- Wat de speler ziet: "12% beter", zoals Pawn.
- Probleem: geen bron die MH mag overnemen (3.2). Zelf 27 rijen × tientallen stats afleiden is veel werk (5+ dagdelen),
  moet na elke Blizzard-hotfix opnieuw (de Shaman-regel veranderde al op 6 en 10 nov, staat in `ForeverMainStats.lua`),
  en "12%" klinkt zekerder dan de bron is. Pawn bestaat al en doet dit beter.

### Optie C2 — Pawn-brug voor wie Pawn heeft (klein, los te kiezen)

- Wat de speler ziet: één schakelaar "Gebruik Pawns oordeel als Pawn aan staat". Dan zegt MH niets wat Pawn tegenspreekt
  en voegt alleen het "waarom" toe. Plus een knop "Laat Pawn alleen mijn richting tonen" (Pawn kan dat in Forever niet
  zelf).
- Werk: 1-2 dagdelen. Precedent: op retail heeft MH al "Use Pawn" en een Pawn-export.
- Risico: hangt aan Pawns functienamen (kunnen wijzigen); alleen nuttig voor spelers met Pawn.

### Advies (AFGELEID)

1. Nu: de meting + optie A. Die haalt fout advies weg dat er vandaag in zit.
2. Daarna optie B in stappen: B1 → B2 (dobbelronde) → B3 (verkoper) → B4 (tassen, als laatste).
3. Optie C niet. C2 alleen als Rob merkt dat Pawn en MH elkaar op zijn scherm tegenspreken.
MH's kracht blijft de uitleg: niet "pijl omhoog" maar "wat krijg je erbij, wat lever je in, en waarom telt dat voor jou".

Schakelaars voor de speler (Rob kiest liever een schakelaar dan één keuze voor iedereen):
per plek aan/uit; "ook zeggen als iets NIET beter is"; "ook gemengd tonen" of "alleen duidelijk beter";
"MH-pijl in de tassen"; "Pawns oordeel volgen".

---

## 6. Open metingen (niet gedaan; de client beslist)

1. `/dump C_Item.GetItemStats(link)` op vier items: (a) iets met alleen hoofdstats, (b) een caster-item met een
   "Equip: Increases damage and healing…"-regel, (c) een wapen (staat er een damage-per-second-sleutel in, en armor?),
   (d) een groen "of the …"-item. Uitkomst bepaalt: stats-tabel of tooltipregels.
2. Geeft `C_TooltipComparison.GetItemComparisonInfo` in Forever iets bruikbaars (welke plek, beide handen)?
3. Bestaat `GetLootRollItemLink`, of moet het via `C_TooltipInfo.GetLootRollItem`?
4. Heeft Rob de groene tooltipregel en de questtip na 16 nov (rol per richting) in het spel gezien? Niet door mij
   gemeten; `docs/` buiten het ene bestand heb ik niet gelezen.
5. "Itemstats verborgen tot de eerste drop" staat in een geheugennotitie van september (bèta). Niet opnieuw gemeten;
   als het nog zo is, kan een tooltip van een nooit-gezien item leeg zijn.

## 7. Foutsoorten-checklist

- Factie: geen factie-afhankelijke bewering gedaan; zie valkuil 15.
- Class/wapen: Dual Wield en armor per class GEMETEN in DB2 70959; wapenbits staan al gemeten in `ForeverWeapons.lua`.
- Aantallen: 4633 / 1913 / 2720 (met de kanttekeningen), 140 en 160 strings, 1361 effecten, 29 Pawn-schalen, 22 events:
  elk uit één run geteld.
- Afwezig ≠ bestaat niet: "Deep Ritual Girdle" niet gevonden mét positieve controle; lege webzoekronde zo benoemd;
  geen ITEM_MOD-dump in de Forever-SavedVariables gevonden (controle op hetzelfde pad gaf wel treffers) → betekent alleen
  dat niemand het daar wegschreef.
- Forever ≠ Classic: alle DB2-cijfers komen uit `--game forever`; Pawn heeft een apart Forever-blok; waar ik
  retail-/Classic-kennis gebruikte staat AFGELEID.
- Zekerder dan de bron: de wapenfout is uit de code gelezen, niet in het spel gezien; `GetItemStats`-gedrag is open.

## 8. Bronnen

- MH-code, gelezen 18 nov 2026: `Modules/ForeverQuestHint.lua`, `PickupUpgrade.lua`, `ForeverMainStats.lua`,
  `ForeverItemTips.lua`, `ForeverWeapons.lua`, `ForeverDirection.lua`, `ForeverDisenchant.lua`, `ForeverOverview.lua`
  (r. 1120-1199), `BagUpgrade.lua`, `LootUpgrade.lua`, `VaultAdvisor.lua` (r. 800-930), `MidnightHelper_Camelot.toc`,
  `Locales/enUS.lua`, `docs/forever/STATS_PER_ROL_2026-11-16.md`, `tools/blizzard_events_snapshot.json`.
- wago.tools DB2, Forever 1.60.1.70959, via `tools/gamedata.py`: `ItemSparse`, `ItemEffect`, `SpellName`,
  `GlobalStrings`, `SkillRaceClassInfo`, `SkillLine`, `ChrClasses`.
- Wowhead Forever tooltip-JSON (nether.wowhead.com/forever), 18 nov 2026: items 4307, 2943, 4825, 3854, 5459, 4383.
- github.com/Gethe/wow-ui-source, tak `forever`, commit 3d8abb1 "1.60.1 (70959)", 17 nov 2026: `ItemDocumentation.lua`,
  `TooltipInfoDocumentation.lua`, `TooltipComparisonDocumentation.lua`, `MerchantFrameDocumentation.lua`,
  `Blizzard_UIPanels_Game.toc`, `Camelot/ContainerFrame.lua`, `Mainline/GroupLootFrame.lua`.
- Addons in `E:\World of Warcraft\_forever_\Interface\AddOns\`: Pawn 2.14.4, Baganator 864, Auctionator 348,
  Syndicator 291, ZygorGuidesViewerForever 1.6, ForeverLevelingGuide 4.94, ForeverDungeonJournal 2.0.12.
- github.com/turlockmike/pawn-forever (README, WebFetch 18 nov 2026).
- Robs Forever-`AddOns.txt` per character (Pawn, Baganator, Auctionator, Zygor, MidnightHelper: enabled).
