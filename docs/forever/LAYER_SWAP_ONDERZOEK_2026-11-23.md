# Layer swap in WoW Forever: onderzoek (23 nov 2026)

Opdracht van Rob: in Forever zien op welke layer je zit, zien dat een gebied druk is, en **zelf** van layer
wisselen ("Er zijn addons die het kunnen"). Dit is alleen onderzoek. Er is niets gebouwd.

Client: WoW Forever 1.60.1.71037, Interface 16001.
Merktekens: **GEMETEN** = gezien in een genoemde, gedateerde bron (of in Robs eigen bestanden).
**AFGELEID** = mijn redenering. **CLAIM** = staat op een addonpagina of in een artikel, niet door mij nagemeten.
Ik heb het spel niet kunnen draaien. Wat in het spel gemeten moet worden staat in hoofdstuk 7.
Uit addons met "All Rights Reserved" (ARR) of GPL heb ik geen code en geen tekst overgenomen; alles hieronder is in
eigen woorden.

---

## 0. In het kort (voor Rob)

1. **Zien op welke layer je zit kan sinds 20 november niet meer in Forever.** Blizzard heeft dat expres dichtgezet.
   Elke NPC geeft nu een eigen willekeurig nummer. Ook in jouw eigen bestanden van vandaag is dat te zien.
2. **Wisselen kan nog wel.** Dat gaat altijd zo: iemand op een andere layer nodigt je uit in zijn groep. Dan zet het
   spel je op zijn layer. Daarna verlaat je de groep.
3. **Kiezen welke layer kan niet meer.** Je wisselt naar "een andere". Soms kom je terug op een oude.
4. Het spel zegt nog wel een paar dingen: "je bent net verplaatst", "dit groepslid zit op een andere layer", en "deze
   uitnodiging gaat je verplaatsen". Dat kan MH laten zien.
5. Zelf wisselen zonder hulp van andere spelers kan niet. Er is altijd iemand nodig die uitnodigt (een "host").
6. Mijn advies: eerst optie A + D (uitleg, meldingen, drukte-meter, en verwijzen naar een wissel-addon). Een eigen
   wisselknop (optie B) pas later, als schakelaar die standaard uit staat. Zie hoofdstuk 8.

---

## 1. Wat ik lokaal heb gevonden

- **Geen enkele layer-addon staat op Robs pc.** GEMETEN 23 nov 2026: mappenlijst van `_forever_`, `_retail_`,
  `_ptr_`, `_xptr_` en `_beta_` `\Interface\AddOns`. Geen map met Layer, GuildLayers, Abatti of Hop in de naam.
  Positieve controle: dezelfde Glob op `*[Ll]ayer*` vond wél andere bestanden (bv. `Polestar\Nav\Layers.lua`, dat over
  kaartlagen gaat). Mappen `_classic_era_` en `_anniversary_` bestaan niet op deze pc (GEMETEN, lijst van
  `E:\World of Warcraft\`). Er waren dus ook geen LICENSE-bestanden te lezen; de licenties komen van CurseForge
  (hoofdstuk 3).
- **Robs eigen Forever-bestanden bewijzen de verandering.** GEMETEN: in de SavedVariables van ForeverDungeonJournal
  (een shaman-alt) staat een Ragefire Chasm-run van **23 nov 2026, ca. 12:36-12:58 Nederlandse tijd** (tijdstempels
  1795433779 en 1795435075; het bestand is vandaag om 16:01 bewaard). Die addon bewaart de ruwe `UnitGUID` van 23 dode
  vijanden. **Alle 23 hebben een ander getal in veld 3 én een ander getal in veld 5**, terwijl ze in één en dezelfde
  dungeon-kopie stonden. Vroeger waren die twee velden voor alle wezens in één kopie gelijk. Het bestand is
  `ForeverDungeonJournal.lua`, regels 751-773; het bijbehorende addon-codepad is
  `ForeverDungeonJournal\Systems\RPGMode.lua:2540-2561` (leest `UnitGUID` op een dode vijand en slaat hem ongewijzigd op).
- MH zelf werkt al met dit verschijnsel: `Modules\ForeverVendors.lua:744-747` en `Modules\ForeverSeenPlaces.lua:35`
  lezen alleen nog veld 6 (het npc-id), omdat de andere velden sinds de hotfix van 20 nov versleuteld zijn (GEMETEN, MH-code).
- MH heeft al de bouwstenen die een layer-functie zou gebruiken (GEMETEN, MH-code): addon-berichten
  (`ns.MH_SendAddon`, o.a. `Modules\DelveShareSync.lua:56`), `UnitPhaseReason` (`Modules\PartyTargets.lua:858`) en het
  tellen van naamplaatjes (`Modules\ForeverTrainer.lua:1572`, `Modules\Rares.lua:940`).

---

## 2. Vraag 1: hoe herkennen addons de layer?

### 2.1 Zo werkte het tot 20 november

- Een wezen in de wereld heeft een GUID van de vorm
  `Creature-0-<server>-<map>-<zone/kopie>-<npcId>-<spawn>` (7 velden, gescheiden door `-`).
  Een layer is een volledige kopie van de wereld; alle wezens in één kopie deelden het getal in veld 5 (en in Forever
  ook veld 3). Lees dat veld en je weet in welke kopie je staat. AFGELEID uit de bronnen hieronder.
- Welk veld: in Classic las men veld 5 ("zone identifier") (CLAIM, README van TitanLayer, GitHub, gelezen 23 nov 2026).
  In Forever las TitanLayer 1.2.0 veld 3 ("server field") (CLAIM, zelfde README en issue #7). Polestar (lokaal
  geïnstalleerd) leest veld 5 om dungeon-kopieën te onderscheiden en schrijft dat Forever dat veld versleutelt
  (GEMETEN, `Polestar\Maps\Instances.lua:10-15` en `:208-216`).
- Welke units: `target` en `mouseover`, soms naamplaatjes; vaak ook dode vijanden en loot-bronnen. Abatti, LayerSwap,
  Bulo en Forever Layer Hop zeggen allemaal "uit de NPC's om je heen; target of mouse-over een NPC" (CLAIM,
  CurseForge-pagina's, gelezen 23 nov 2026).
- Van getal naar "Layer 2": het ruwe getal zegt niets. Addons sorteren de getallen die ze in een zone gezien hebben
  en nummeren ze (TitanLayer, CLAIM). Nova World Buffs (NWB) deelt zijn nummering via de guild, zodat iedereen in chat
  hetzelfde "layer 2" bedoelt (CLAIM: Abatti, GuildLayers en LayerSwap noemen NWB als bron van de nummers op Classic).
  Forever Layer Hop toonde het ruwe getal (bv. "16" of "18853") met een vriendelijk label erbij (CLAIM).
- Bekende valkuilen (allemaal CLAIM uit de genoemde pagina's, AFGELEID dat ze voor MH gelden):
  - Totems, guardians en pets van spelers dragen de layer waarop ze opgeroepen zijn: niet meetellen (TitanLayer).
  - Naamplaatjes over een zonegrens horen bij een andere kaart: daarmee geen nieuwe layer "ontdekken" (TitanLayer).
  - Op een vlucht (taxi) en in dungeons/raids niet meten: daar zijn geen layers (TitanLayer, LayerSwap).
  - In de grote hoofdsteden had NWB moeite met de detectie (GuildLayers-pagina).
  - Na een zonewissel of laadscherm kan je layer veranderd zijn: opnieuw meten. In Forever werkt layering per zone
    en kan een zonewissel je verplaatsen (CLAIM, Destructoid 10 nov 2026, "zone-based layering").
  - Eén NPC is te weinig om zeker te zijn; addons wachten op een tweede die hetzelfde zegt (LayerSwap, Polestar).

### 2.2 Wat Blizzard veranderde

- **16 okt 2026, Forever 1.60.1 Beta 5 (build 70425)**, kopje Addon Security, GEMETEN op Warcraft Wiki
  "Patch 1.60.1/API changes" (gelezen 23 nov 2026): de server-ID en spawn-ID van creature-, vehicle-, pet- en
  game-object-GUIDs zijn vervangen door versleutelde waarden *"to prevent comparison to determine layer"*. Ze blijven
  stabiel en uniek binnen je eigen sessie; de vorm van de GUID is verder gelijk.
- **20 nov 2026**, notities van Blizzard-engineer Daniel Yates ("Meorawr") in de WoWUIDev Discord, overgenomen door
  Wowhead en Warcraft Tavern op 20 nov 2026 (GEMETEN in die artikelen):
  - *"The realm ID in creature, vehicle, pet and game object GUIDs is now obfuscated along with the server ID and
    spawn ID."* (12.1.7 PTR 6) met *"This will also apply to Forever in an upcoming 1.60.1 hotfix."*
  - Voor Forever: API's die een realmnaam of realm-ID geven, geven nu een lege tekst of 0 (`GetRealmName`,
    `GetRealmID`, C_BattleNet). Alleen in Forever.
- **Live sinds de hotfix van 20 nov** (CLAIM van de TitanLayer-auteur, GitHub issue #7, 21 nov 2026): op build
  1.60.1.71037 gaven zeven NPC's, twee naast elkaar, zeven verschillende waarden in veld 3 én in veld 5;
  `GetRealmName()` = `""`, `GetRealmID()` = 0. Robs eigen RFC-data van vandaag (hoofdstuk 1) laat precies hetzelfde
  zien: **GEMETEN** voor veld 3 en 5. Blizzards eigen hotfix-notities van 20 nov noemen het niet (CLAIM,
  wowforeveraddons.com, 22 nov 2026); ik heb geen Blizzard-hotfixpost van 20 nov gevonden (leeg zoekresultaat, bewijst niets).
- Conclusie: **een layer-nummer uit GUID's lezen kan niet meer in Forever.** AFGELEID uit het bovenstaande.
  Eén afwijkende claim: de pagina van Bulo Layer Forever (bijgewerkt 23 nov 2026) belooft nog steeds een layer-naam
  zoals "Layer 7083-17" uit NPC's. Dat botst met de meting van TitanLayer, met LayerSwap en LayerETA (die allebei
  schrijven dat het niet meer kan) en met Robs eigen data. Waarschijnlijk is die tekst verouderd (AFGELEID, niet gemeten).

### 2.3 Is de GUID leesbaar of "secret"?

- Leesbaar: de GUID-string is geen secret value. GEMETEN indirect: ForeverDungeonJournal haalt hem door een
  `issecretvalue`-filter (`Plain`) en bewaart hem toch als gewone tekst (RFC-data van vandaag). TitanLayer schrijft
  "never secret" (CLAIM). Alleen de inhoud van veld 3 en 5 is waardeloos geworden.
- MH blijft `issecretvalue` gebruiken vóór elke `guid:match` (zo staat het al in `ResetRoutine.lua:658`). AFGELEID.

### 2.4 Wat het spel nog wél vertelt (de bruikbare signalen)

| Signaal | Wat het zegt | Status |
|---|---|---|
| Event `SHARD_TRANSFER` (en `SHARD_TRANSFER_IMMINENT`, `SHARD_TRANSFER_CANCELLED`) | "Je wordt nu verplaatst" / "er komt een verplaatsing" / "afgeblazen" | GEMETEN: bestaan in Forever (Ketho/wow-ui-source-forever, `SystemDocumentation.lua`; Warcraft Wiki, alleen game type *forever*, geen payload). Wanneer ze precies vuren: **meten** |
| `PARTY_INVITE_REQUEST`, nieuw 6e veld `isCrossShard` | "Deze uitnodiging komt van iemand op een andere layer" | GEMETEN: in `PartyInfoDocumentation.lua` van de Forever-UI-bron (Ketho, gelezen 23 nov 2026); ook wowlua-changelog 0.13.11 (build 70888) |
| `UnitPhaseReason("partyN")` | Geeft `1` (Sharding) als dat groepslid op een andere shard/layer staat, `nil` als gelijk | Functie en waarden GEMETEN op Warcraft Wiki; dat Forever bij een andere layer `Sharding` geeft: **meten** |
| Blizzard-tekst `INVITATION_XSHARD` (60658) | Uitnodigingsvenster: "Accepting this invitation may cause the world to refresh around you." | GEMETEN, GlobalStrings Forever 1.60.1.71037 (wago, via `run gamedata`) |
| Blizzard-teksten `SHARD_TRANSFER_*` (60077-60500) | Het "World refresh"-aftelvenster met knop "Refresh Now"; niet in combat | GEMETEN, zelfde bron |
| Blizzard-teksten `PARTY_SHARDED_MESSAGE` e.a. (42698, 42706-42708), `PARTY_PLAYER_SHARDED_INCOMPATIBLE_RULESET` (59826) | "Deze speler zit in een andere fase"; "andere ruleset: alleen in instances zichtbaar" | GEMETEN, zelfde bron |

- Het woord "layer" komt in Blizzards eigen Forever-teksten niet voor, behalve bij Torghast en housing. GEMETEN
  (GlobalStrings, filter " layer", 7 treffers, allemaal ongerelateerd). Blizzard noemt het "world refresh",
  "shard" en "phase".
- Wat dit betekent voor MH (AFGELEID): MH kan zeggen **"je bent net verplaatst"**, **"dit groepslid zit op een
  andere layer"** en **"deze uitnodiging gaat je verplaatsen"**. MH kan niet zeggen **welke** layer.
  LayerETA (MIT) beschrijft dezelfde aanpak: na het joinen wachten op het verplaats-signaal, en als dat na 3 seconden
  niet kwam, kijken hoe het spel de host in de groep markeert (CLAIM, CurseForge, versie 3.9.1, 22 nov 2026).
  WorldSync (GPLv3) zegt dat Blizzards eigen groepsframes een groepslid op een andere layer al vervaagd en met een
  fase-icoon tonen (CLAIM, CurseForge, 11 nov 2026).

---

## 3. Vraag 2: hoe verplaatsen de addons een speler?

**Het mechanisme is bij allemaal hetzelfde** (CLAIM van alle pagina's, AFGELEID dat het de enige weg is): een speler
op een andere layer in **dezelfde zone** nodigt je uit in zijn groep. Je accepteert. Het spel zet je ongeveer een
seconde later op zijn layer (LayerETA, CLAIM). Daarna verlaat je de groep. Er is geen API om zelf een layer te kiezen
("no SwitchToLayer()", Forever Layer Hop, CLAIM).

| Addon (auteur) | Licentie (CurseForge, gelezen 23 nov 2026) | Forever? | Hoe het een host vindt | Grenzen die de addon zelf stelt |
|---|---|---|---|---|
| **Layer-Swap** (Adam5288), 4,1 mln downloads, v1.14.47 van 23 nov | **All Rights Reserved** | ja | Op Classic: verzoek in het publieke `layer`-kanaal, ook herkent het verzoeken in General, guild en whisper. Op de live Forever-realms mag een addon niet in chat posten; daar vraagt het de spelers op de kaart van je zone op (eerst iedereen, dan per klasse) en stuurt elk een onzichtbaar addon-bericht. Guild als laatste. Hosts die je vorige week hielpen eerst | Host: max 6 uitnodigingen per 10 min; dezelfde speler niet binnen 1 min; alleen solo of eigen groep; niet in instance; niet tijdens een aangekondigde world refresh; niet in combat (+2 s). Vrager: niet in combat en 6 s erna; wie in 15 min niet antwoordde wordt niet opnieuw gevraagd; telt 10 wissels per uur per character; verlaat de groep 4 s na het joinen; zet loot op Free for All in de host-groep. Sinds 20 nov: geen layerlijst meer in Forever |
| **Abatti's Layer Swap** (abatti414), v1.0.0 van 8 okt | **All Rights Reserved** | ja (pagina van vóór 20 nov) | Guild-addonberichten; leest ook chatregels als "inv for layer 3" in world/guild/say en whispert die speler voor je | Accepteert alleen de uitnodiging van wie op jouw verzoek reageerde; niet in groep, combat of instance |
| **Forever Layer Hop** (PhantomXization), v0.1.9 van 12 nov | **All Rights Reserved** | alleen Forever | Eigen verborgen addon-kanaal per backend-realm, guild/party/raid-addonberichten, directe addon-whispers aan bekende FLH-spelers, "introducties" via andere FLH-spelers, optioneel /who | Blijft bewust in de groep na een wissel: in hun beta-test zette verlaten je terug (botst met LayerSwap, zie 3.1) |
| **GuildLayers** (shimoro), v7.0 van 3 mei | **All Rights Reserved** | **nee** (Classic-varianten) | Guild-addonberichten; NWB vereist voor de layer; publieke `/join layer` als terugval | Accepteert automatisch als je niet in een groep zit |
| Bulo Layer Forever (bulo_), v3.0.39 van 23 nov | Academic Free License v3.0 | ja | Zoekt in je zone en vraagt tot 50 spelers onzichtbaar; werkt samen met hosts van andere layer-addons | Host nodigt alleen uit als het iemand echt kan verplaatsen; "farmplek beschermen"-straal |
| ForeverLayers (_arock), v1.3.2 van 16 nov | **MIT** | alleen Forever | Verborgen kanaal met "aanwezigheid"-berichten elke 60-90 s (helpers) of 180-240 s; optioneel AutoLayer-helpers via hun "NetherNet"-kanaal | Uitnodiging accepteren en groep verlaten doet de speler zelf; max 120 s en 3 pogingen per wissel |
| LayerETA (XtreamCoder), v3.9.1 van 22 nov | **MIT** | alleen Forever | Alleen vrager, nooit host. Stuurt het verzoek in het formaat dat LayerSwap gebruikt, zodat hosts van LayerSwap, Bulo en "Simple Layer" reageren | 10 wissels per uur; niet in combat en 6 s erna; verlaat de groep 4 s na de verplaatsing |
| AutoLayer (raizoppc), v1.9.16 van 16 nov | WTFPL | ja | Host leest chat op trefwoorden en nodigt automatisch uit | Instelbare filters; "guild only" |
| SystematicLayers (MaliethoSolin) | All Rights Reserved | ja | Opgegaan in "Systematic Guild" (guild-addon) | End of life sinds 25 okt |
| WorldSync (ReflectedReverb) | GPLv3 | ja | Geen hosts: toont alleen Blizzards world-refresh-aanbod groter, met knop | Uit in combat, tijdens vliegen of vallen |

Bronnen tabel: de CurseForge-pagina's van elke addon, gelezen 23 nov 2026 (URL's in hoofdstuk 9). Alle inhoud van
deze tabel is CLAIM van de addonauteurs, in eigen woorden samengevat.

Protocol-details (prefixen, exacte berichtvorm) heb ik **niet** gelezen: geen van deze addons staat lokaal, en van de
ARR-addons mogen we de code toch niet overnemen. Voor de vorm van het LayerSwap-verzoek is LayerETA (MIT) de schone
bron als Rob optie B kiest. AFGELEID.

### 3.1 Tegenstrijdigheden die gemeten moeten worden

- **Blijft de nieuwe layer na het verlaten van de groep?** LayerSwap (23 nov): ja. Forever Layer Hop (12 nov, uit
  beta-tests): nee, je gaat terug. wowforeveraddons.com (22 nov): groeperen zet je op hun layer. Onbeslist: meten.
- **Maximaal 10 wissels per uur.** Alleen LayerSwap en LayerETA zeggen dit. Ik vond geen Blizzard-bron. In Classic
  (2019) koos Blizzard voor een **oplopende** wachttijd na elke wissel (GEMETEN, blue post Kaivax, 8 sep 2019). Meten.

---

## 4. Vraag 3: kan MH wisselen zonder eigen netwerk van MH-hosts?

### 4.1 Blizzards eigen middelen in Forever

- Geen layer-knop, geen layer-kanaal, geen layer-tekst in de UI (GEMETEN: GlobalStrings, zie 2.4).
- Wel: het **world refresh**-venster met "Refresh Now". Dat komt alleen als de server het aanbiedt, bijvoorbeeld na
  een uitnodiging van iemand op een andere layer (GEMETEN: teksten `INVITATION_XSHARD`, `SHARD_TRANSFER_*`;
  het bestaan van `C_PlayerInteractionManager.ShardTransferConfirm` staat in de lijst "Consolidated changes" van
  Patch 1.60.1/API changes). Je kunt het niet zelf oproepen (CLAIM, GamerBlurb 5 nov 2026; Destructoid 10 nov 2026).
  Niet in combat (CLAIM: Blizzard-wijziging van 15 okt, geciteerd door timesaver.gg, 20 nov 2026; Blizzards tekst
  `SHARD_TRANSFER_COMBAT` "You can't refresh the world while in combat." is GEMETEN).
- Groepszoeker: bestaat, maar wie je daar ziet lijkt aan je layer gebonden (CLAIM, Warcraft Tavern 20 nov 2026).
- Chatkanalen: spelers kunnen `/join <naam>` doen. Addon-berichten over een zelfgemaakt kanaal werkten op een beta-build
  (CLAIM, GitHub WoWForeverRace issue #40, build 70058, 30 sep 2026), werden begin november geblokkeerd en daarna weer
  opgelost, en lijken alle rulesets te omvatten (CLAIM, Blizzard-bugforum "Add-on messages are blocked in chat channels",
  6 nov 2026). Een **addon** mag in Forever geen gewone chatregel posten:
  `C_ChatInfo.AreOutgoingAddonChatMessagesRestricted()` was `true` (CLAIM, issue #40), en LayerSwap schrijft dat de
  live Forever-realms het niet toestaan (CLAIM). De functie bestaat in Forever en wordt per realm geregeld (GEMETEN,
  Warcraft Wiki).

Conclusie (AFGELEID): **zonder een andere speler die uitnodigt kan niemand wisselen**, ook Blizzard biedt geen knop.
De vraag is dus alleen: wiens hosts gebruikt MH?

### 4.2 Andermans hosts gebruiken (zelfde protocol spreken)

- **Het bestaat al en gebeurt al.** LayerETA (MIT) en Bulo (AFL 3.0) praten met LayerSwap-hosts in het formaat dat
  LayerSwap gebruikt, en LayerSwap praat op Classic zelf het formaat van de oudere layer-addons ("inv layer 1,3")
  (CLAIM, hun CurseForge-pagina's). Het formaat is dus **de facto openbaar**, maar **niet gedocumenteerd** als standaard.
- **Juridisch** (AFGELEID, ik ben geen jurist): een berichtformaat is een functionele afspraak, geen code of tekst.
  Als MH een eigen implementatie schrijft en niets kopieert, is het risico klein. Wie het formaat bepaalt is wel de
  ARR-auteur (Adam5288). Netjes is: het hem vragen.
- **Praktisch het grootste risico** (AFGELEID): LayerSwap verandert vaak (1.14.45 → 1.14.47 binnen enkele dagen) en hosts
  kunnen verzoeken ineens weigeren. Gemeten voorbeeld van een ander: LayerETA 3.8 noemde nog een layer in het verzoek en
  werd daardoor door LayerSwap-hosts overgeslagen; pas 3.9 werkte weer (CLAIM, LayerETA-pagina). Elke wijziging
  daar maakt de MH-knop stil kapot, precies het soort stilte waar MH's eigen regel voor waarschuwt.
- **Sociaal risico**: alleen vragen en nooit hosten ("free riding"). LayerETA doet dat openlijk. AFGELEID.

### 4.3 Een eigen MH-netwerk: hoeveel spelers zijn nodig? (AFGELEID, ruwe schatting)

Een host helpt alleen als hij tegelijk: in **dezelfde zone** staat, van **dezelfde factie** is, in **dezelfde
ruleset** speelt (andere ruleset: alleen in instances zichtbaar, GEMETEN tekst 59826), op een **andere layer** staat,
solo is of zijn eigen groep leidt, niet in combat of een instance is, en geen trial-account heeft
(trials mogen geen addon-berichten sturen, GEMETEN hoofdstuk 5).

- Stel een zone heeft 3 layers (het voorbeeld van Forever Layer Hop) en de hosts zijn eerlijk verdeeld. De kans dat
  minstens één van *n* beschikbare hosts in jouw zone op een andere layer staat is 1 − (1/3)^n: 67% bij 1 host,
  89% bij 2, 96% bij 3.
- Er zijn ongeveer 4 rulesets × 2 facties × zo'n 40 levelzones = ruim 300 "bakjes". Voor 2-3 beschikbare hosts per
  bakje zijn dus zo'n 600-900 MH-spelers **tegelijk online én beschikbaar** nodig. Als 1 op 3 online spelers op elk
  moment beschikbaar is en zo'n 10% van de installaties tegelijk online is, praat je over **ordegrootte 20.000 actieve
  MH-installaties in Forever**. Spelers klonteren in een paar zones samen, dus in drukke zones gaat het iets beter,
  in rustige zones (waar je juist minder concurrentie zoekt) slechter.
- Ik weet niet hoeveel MH-spelers Forever spelen (niet gemeten). LayerSwap heeft 4,1 miljoen downloads en nog steeds
  meldt zijn pagina het geval "geen host antwoordde". Een eigen MH-netwerk zal dus vaak niets vinden.
- Een **guild-variant** is kleiner en eerlijker: je guild staat op alle layers, maar de host moet nog steeds in jouw
  zone staan. Werkt alleen in guilds met meerdere MH-spelers. AFGELEID.

---

## 5. Vraag 4: regels

### 5.1 Blizzard algemeen

- **UI Add-On Development Policy** (GEMETEN, Blizzard-forum, post van Kaivax, 19 nov 2018, tekst uit 2009):
  regel 3: een addon mag de realms of andere spelers niet negatief raken, *"including … excessive use of the chat
  system"*. Regel 8: Blizzard mag elke addon-functie uitzetten wanneer het wil. Regel 7: ToU en EULA gelden.
- **Blizzards bedoeling is duidelijk** (GEMETEN, citaat 2.2): de versleuteling van 16 okt was er *"to prevent
  comparison to determine layer"*, en 20 nov kwam er nog een laag bij. Pers leest het zo: Blizzard wil het
  **kiezen** van een layer stoppen, niet het wisselen zelf (CLAIM, Warcraft Tavern en Wowhead, 20 nov 2026;
  Massively OP, 23 nov 2026).
- Of een layer-wissel-addon tegen de regels is: **geen uitspraak van Blizzard gevonden** (timesaver.gg schrijft
  op 20 nov hetzelfde). Een leeg zoekresultaat bewijst niets. AFGELEID: zolang een addon alleen doet wat Blizzards
  groepssysteem ook doet (uitnodigen, accepteren), is dat geen exploit; Blizzard kan het wel op elk moment beperken.
- Spelersstemming is verdeeld: een Reddit-post "LayerSwap Addon has to go" (15 nov, 3600+ upvotes) en forumtopics
  voor en tegen (CLAIM, timesaver.gg, 20 nov 2026). Blizzard verlaagde op 9 nov de spelersaantallen in drukke zones
  (GEMETEN als citaat van Kaivax in timesaver.gg; Blizzards hotfixpagina zelf niet geopend).

### 5.2 Wat Blizzard in Classic eerder deed

- 8 sep 2019: oplopende wachttijd na elke layer-wissel, tegen "frequent layer-hopping" (GEMETEN, blue post Kaivax).
- Patch 8.2.5 / Classic 1.13.2 (24 sep 2019): `/who` via een addon vereist een toets- of muisklik, *"as a measure against
  gold spam channel invites and other unintended uses for automatically querying player names"* (GEMETEN, Warcraft Wiki
  C_FriendList.SendWho).
- In Classic mogen addon-berichten niet via een eigen chatkanaal (`CHANNEL` uitgeschakeld) (GEMETEN, Warcraft Wiki
  C_ChatInfo.SendAddonMessage). In Forever lijkt dat wél te kunnen (zie 4.1).
- Dat Blizzard layer-addons in Classic Era of TBC Anniversary ooit kapot maakte: niet gevonden. LayerSwap toont daar
  nog steeds layers (CLAIM, 23 nov 2026).

### 5.3 Forever-specifiek (techniek)

| Regel | Bron |
|---|---|
| Trial-accounts (ook Veteran) mogen **geen addon-berichten** sturen | GEMETEN: Patch 1.60.1/API changes, Beta 4, 8 okt 2026 (build 70291); Warcraft Wiki SendAddonMessage |
| `SendChatMessage` met EMOTE (net als SAY en YELL) vereist buiten instances een toets/klik | GEMETEN: zelfde Beta 4-notitie |
| Addons mogen geen gewone chatregels posten (`AreOutgoingAddonChatMessagesRestricted` = true) | CLAIM (issue #40 op beta 70058; LayerSwap voor live). Meten |
| `/who` (`C_FriendList.SendWho`) alleen na een klik; server heeft een cooldown | GEMETEN: Warcraft Wiki (game type forever 1.60.1) |
| Addon-berichten: per prefix 10 tegoed, 1 per seconde terug; **geldt niet voor whispers buiten instances**; server kan het altijd anders zetten | GEMETEN: Warcraft Wiki SendAddonMessage |
| `C_PartyInfo.InviteUnit` en `LeaveParty`: alleen "AllowedWhenUntainted", geen klik nodig | GEMETEN: Forever-UI-bron (Ketho), `PartyInfoDocumentation.lua` |
| `AcceptGroup`: geen beperking op de wiki | GEMETEN: Warcraft Wiki AcceptGroup; of Forever dat ook zo doet: **meten** |
| World refresh niet in combat | GEMETEN (Blizzard-tekst 60500); de wijziging van 15 okt zelf: CLAIM |
| Trial-chat (algemeen WoW): whispers alleen naar vrienden | CLAIM, Blizzard support-artikel 3226 (niet specifiek Forever) |

AFGELEID voor MH: een trial-speler kan met MH niets vragen en niets hosten. Een MH-knop die in chat iets wil zeggen,
moet de chatregel klaarzetten en de speler zelf op Enter laten drukken.

---

## 6. Vraag 5: "dit gebied is druk" herkennen

Wat er op deze client te lezen valt (allemaal: **meten** in Forever, tenzij anders gezegd):

| Meting | Hoe | Sterk / zwak |
|---|---|---|
| Spelers om je heen | Naamplaatjes tellen (`C_NamePlate.GetNamePlates()` + `UnitIsPlayer`). MH gebruikt `GetNamePlates` al in Forever (GEMETEN, `ForeverTrainer.lua:1572`) | Sterk dichtbij, maar alleen als vriend/vijand-naamplaatjes aan staan en binnen het naamplaatjes-bereik (bereik in Forever: meten). Bulo doet het zo ("player radar", CLAIM) |
| Concurrentie op mobs | Mobs met andermans tag tellen (`UnitIsTapDenied` op naamplaatjes) | Het beste signaal voor "ik moet hier wachten op quest-mobs". Of het in Forever leesbaar (niet secret) is: meten |
| Zone-populatie | `/who z-"Zone"` na een klik | Zegt waarschijnlijk iets over de hele zone, niet over jouw layer; lijst is afgekapt (LayerSwap zoekt daarom per klasse, CLAIM). Zwak voor "mijn layer" |
| Groepszoeker | Aantal lijsten | Lijkt aan je layer gebonden (CLAIM); zwak en indirect |
| Verplaatst? | `SHARD_TRANSFER` | Vertelt dat het veranderde, niet of het nu rustiger is |

AFGELEID: een simpele "drukte-meter" = spelers op naamplaatjes + aandeel getagde mobs, met drempels die Rob in het
spel instelt. Na een wissel kan MH zeggen "hier zijn nu X spelers, was Y".

---

## 7. Wat Rob in het spel moet meten (vóór er gebouwd wordt)

Allemaal met `/run`-regels of een kleine probe die naar `ns.db` schrijft (MH-gewoonte). Twee characters of een
helpende guildgenoot nodig voor 3-7.

1. `GetRealmName()`, `GetRealmID()` → verwacht `""` en `0`.
2. `UnitGUID("target")` op twee NPC's naast elkaar → verwacht verschillende velden 3 en 5 (Robs RFC-data zegt al ja).
3. Wanneer vuren `SHARD_TRANSFER`, `SHARD_TRANSFER_IMMINENT`, `SHARD_TRANSFER_CANCELLED`? Bij joinen van een groep op
   een andere layer, bij een zonewissel, bij een world refresh, bij een laadscherm?
4. `PARTY_INVITE_REQUEST`: is het 6e veld `true` bij een uitnodiging van iemand op een andere layer, en `false` bij
   dezelfde layer?
5. `UnitPhaseReason("party1")` als het groepslid op een andere layer staat → verwacht `1` (Sharding).
6. Blijft de nieuwe layer na het verlaten van de groep? (LayerSwap en Forever Layer Hop spreken elkaar tegen.)
7. Werkt `AcceptGroup()` vanuit addon-code zonder klik in Forever?
8. `C_ChatInfo.AreOutgoingAddonChatMessagesRestricted()` op live → verwacht `true`.
9. Bereik en aantal naamplaatjes; is `UnitIsTapDenied` leesbaar (geen secret)?
10. `/who z-"<zone>"`: hoeveel resultaten maximaal, en zie je spelers van andere layers?
11. Hoeveel wissels per uur laat het spel echt toe (de "10 per uur")?

---

## 8. Opties voor Rob

### Optie A: Layer-wijzer zonder wisselen (alleen uitleg en meldingen)

- **Wat de speler ziet:** een kleine melding "Je bent naar een andere layer verplaatst" (`SHARD_TRANSFER`).
  In de groep: "Piet zit op een andere layer". Bij een uitnodiging: "Let op: accepteren zet je op een andere layer".
  Een drukte-meter ("12 spelers om je heen, 7 van de 10 mobs al getagd"). Een korte uitleg hoe wisselen werkt, met
  een knop die een tekst in je guild-chatvak klaarzet (jij drukt zelf op Enter). Plus `/mh layer` dat laat zien wat
  MH ziet en waarom.
- **Kosten:** klein. Eén module, geen netwerk, geen hosts. Wel eerst de metingen 3-5 en 9.
- **Risico's:** laag. Geen verkeer naar andere spelers, niets dat Blizzards bedoeling tegenwerkt. Signalen kunnen
  anders werken dan gedacht: daarom eerst meten.
- **Nadeel:** het is geen "zelf swappen". Robs wens wordt maar half vervuld.

### Optie B: Eigen wisselknop die het bestaande host-netwerk gebruikt (alleen vragen, nooit hosten)

- **Wat de speler ziet:** knop "Wissel layer". MH zoekt na de klik spelers in je zone, stuurt hen onzichtbaar een
  verzoek, accepteert alleen de uitnodiging van wie reageerde én van een andere layer komt (`isCrossShard`), en
  verlaat de groep na de verplaatsing. Telt je wissels. Niet in combat. Je kunt **geen** layer kiezen.
- **Kosten:** middel tot groot. Het verzoekformaat moet uit een schone bron komen (LayerETA, MIT) of door eigen
  observatie; veel randgevallen (geen host, host op jouw layer, geweigerd, al in een groep); tests met twee accounts.
  Daarna doorlopend onderhoud zodra LayerSwap iets verandert.
- **Risico's:** (1) LayerSwap verandert het formaat, de knop doet stil niets (is LayerETA al overkomen). (2) Alleen
  nemen, niet geven: andere addon-gebruikers kunnen dat MH kwalijk nemen. (3) Veel onzichtbare whispers naar
  vreemden: Blizzard-regel 3 en 8, en Blizzard kan dit in een volgende hotfix beperken. (4) Het formaat komt van een
  ARR-addon: juridisch klein risico, wel netjes om Adam5288 eerst te vragen. (5) Trial-accounts kunnen het niet.
- **Variant:** standaard **uit**, als schakelaar die de speler zelf aanzet (MH-regel "spelers kiezen").

### Optie C: Eigen MH-netwerk (MH-prefix, MH-spelers hosten voor elkaar)

- **Wat de speler ziet:** zelfde knop als B, maar alleen MH-spelers (eerst guild, dan zone) helpen elkaar; je host
  zelf ook (je nodigt automatisch vreemden uit als je solo bent).
- **Kosten:** groot. Vrager én host bouwen, loot-instelling, misbruikgrenzen, tests.
- **Risico's:** werkt pas met ordegrootte tienduizenden actieve MH-installaties in Forever (schatting 4.3); daaronder
  vindt de knop meestal niemand. Dat is precies de "knop die niets doet" waar CLAUDE.md voor waarschuwt. Hosten =
  vreemden in je groep, dat willen niet alle spelers.
- **Guild-only variant:** kleiner en eerlijker, maar werkt alleen als er MH-guildgenoten in dezelfde zone staan.

### Optie D: Doorverwijzen naar een bestaande wissel-addon

- **Wat de speler ziet:** in het layer-paneel van MH: "Wisselen doe je met LayerSwap, Bulo of LayerETA". Is er één
  geïnstalleerd, dan toont MH een knop die hun eigen commando opent. Anders: welke er bestaan en dat je kunt kiezen.
- **Kosten:** heel klein.
- **Risico's:** bijna geen; MH kopieert niets en stuurt geen verkeer. Nadeel: de wissel gebeurt niet "in MH".

### Mijn advies

**Nu A + D, B later en alleen als schakelaar, C niet.**

- A + D samen geven de speler vandaag alles wat eerlijk kan: weten dát je verplaatst bent, of je groep bij je staat,
  of het hier druk is, en een weg om te wisselen. Het past bij waar MH goed in is (uitleggen) en botst niet met wat
  Blizzard op 16 okt en 20 nov liet zien dat het wil.
- Wil Rob echt een eigen knop (B), doe dan eerst de metingen uit hoofdstuk 7, vraag Adam5288 of MH zijn hosts mag
  aanspreken, en zet het standaard uit. Reken op onderhoud na elke LayerSwap-update.
- C raad ik af: te weinig MH-spelers in Forever om hosts te vinden, en veel werk voor een knop die meestal niets vindt.

---

## 9. Bronnen (allemaal gelezen op 23 nov 2026, tenzij anders gezegd)

Lokaal (GEMETEN):
- `E:\World of Warcraft\_forever_\WTF\...\SavedVariables\ForeverDungeonJournal.lua` r. 751-773 (RFC-run 23 nov 2026)
- `_forever_\Interface\AddOns\ForeverDungeonJournal\Systems\RPGMode.lua:2540-2561`, `Systems\RunLog.lua:64-73`
- `_forever_\Interface\AddOns\Polestar\Maps\Instances.lua:10-15, 208-216`, `Polestar\Core\Hooks.lua:273-274`
- MH: `Modules\ForeverVendors.lua:744-747`, `Modules\ResetRoutine.lua:658-664`, `Modules\PartyTargets.lua:858`,
  `Modules\ForeverTrainer.lua:1572`
- Blizzard GlobalStrings Forever 1.60.1.71037 via `run gamedata` (wago.tools): 42698, 42706-42708, 59826,
  60077-60080, 60175, 60421, 60500, 60658

Blizzard en documentatie:
- Warcraft Wiki, Patch 1.60.1/API changes (Beta 4 8 okt, Beta 5 16 okt): https://warcraft.wiki.gg/wiki/Patch_1.60.1/API_changes
- Warcraft Wiki: C_ChatInfo.SendAddonMessage, C_FriendList.SendWho, C_PartyInfo.InviteUnit, C_PartyInfo.LeaveParty,
  AcceptGroup, UnitPhaseReason, C_ChatInfo.AreOutgoingAddonChatMessagesRestricted, Event:SHARD_TRANSFER,
  Event:SHARD_TRANSFER_IMMINENT, Event:PARTY_INVITE_REQUEST (https://warcraft.wiki.gg/wiki/...)
- Forever-UI-bron: https://github.com/Ketho/wow-ui-source-forever (`PartyInfoDocumentation.lua`, `SystemDocumentation.lua`)
- wowlua changelog 0.13.11 (11 nov 2026): https://wowlua.dev/changelog
- UI Add-On Development Policy: https://us.forums.blizzard.com/en/wow/t/ui-add-on-development-policy/24534
- Classic, oplopende wachttijd (8 sep 2019): https://us.forums.blizzard.com/en/wow/t/290703/1
- Bugrapport addon-kanalen (6 nov 2026): https://us.forums.blizzard.com/en/wow/t/add-on-messages-are-blocked-in-chat-channels/2403369

Nieuws en artikelen:
- Wowhead, 20 nov 2026: https://www.wowhead.com/forever/news/layer-swap-and-other-targeted-layering-addons-will-be-disabled-soon-in-wow-383943
- Warcraft Tavern, 20 nov 2026: https://www.warcrafttavern.com/forever/news/layer-hopping-functionality-will-be-reduced-for-addons-in-wow-forever/
- wowforeveraddons.com, 20/22 nov 2026: https://wowforeveraddons.com/articles/layer-hopping-addons-wow-forever
- Massively OP, 23 nov 2026: https://massivelyop.com/2026/11/23/world-of-warcraft-forever-moves-to-eliminate-targeted-layer-swapping/
- timesaver.gg, 23 okt / 20 nov 2026: https://timesaver.gg/blog/wow-forever-layering-sharding-explained
- Destructoid, 10/13 nov 2026: https://www.destructoid.com/how-to-change-layers-in-wow-forever-after-the-layer-size-change/
- GamerBlurb, 5 nov 2026: https://gamerblurb.com/articles/wow-forever-world-refresh-explained
- Icy Veins, 16 sep 2026: https://www.icy-veins.com/wow-forever/news/wow-forever-adds-a-useful-warning-for-when-youre-being-phased-into-a-new-layer/
- TitanLayer README en issue #7 (21 nov 2026): https://github.com/Spotnick2/TitanLayer , https://github.com/Spotnick2/TitanLayer/issues/7
- WoWForeverRace issue #40 (30 sep 2026): https://github.com/Offroads/WoWForeverRace/issues/40

Addonpagina's (CurseForge, licentieveld gelezen 23 nov 2026):
- https://www.curseforge.com/wow/addons/layer (Layer-Swap, ARR) en https://www.curseforge.com/wow/addons/layer-swap (zelfde project-ID 1710286)
- https://www.curseforge.com/wow/addons/abattis-layer-swap (ARR)
- https://www.curseforge.com/wow/addons/forever-layer-hop (ARR)
- https://www.curseforge.com/wow/addons/guildlayers (ARR)
- https://www.curseforge.com/wow/addons/bulo-layer-forever (AFL 3.0)
- https://www.curseforge.com/wow/addons/foreverlayers (MIT)
- https://www.curseforge.com/wow/addons/layereta-layer-swap-layer-finder-shard-changer (MIT)
- https://www.curseforge.com/wow/addons/autolayer (WTFPL); broncode https://github.com/iraizo/AutoLayer
- https://www.curseforge.com/wow/addons/systematiclayers (ARR)
- https://www.curseforge.com/wow/addons/worldsync (GPLv3)
