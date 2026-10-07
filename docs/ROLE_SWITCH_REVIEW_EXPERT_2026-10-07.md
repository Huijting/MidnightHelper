# Van DPS naar tank of healer: wat heeft Midnight Helper?

Expert-review, 7 okt 2026. Ik heb alleen gelezen. Er is niets veranderd aan code of vertalingen.
Ik keek als speler die al jaren tankt, healt en DPS't, en die 12.1 Season 2 kent.

**Legenda**
- **G** = GEMETEN: gezien in een bestand (`bestand:regel`) of in een bron met datum.
- **A** = AFGELEID: mijn eigen redenering of spelkennis. Niet gemeten.
- Alles wat het scherm laat zien heb ik **niet** in de client bekeken. Ik las de code. Robs `/reload` blijft de echte test.

---

## Kort antwoord

**Hebben we makkelijke uitleg? Ja, veel.** Maar het zit verspreid over zes plekken. (G, zie deel 1)

**Is het ook voor iemand die het écht niet snapt? Nog niet.** (A) Drie redenen:

1. **De basis ontbreekt.** Nergens staat in gewone woorden wat aggro is, wat een taunt doet, of wat "active mitigation" betekent. De lessen gebruiken die woorden gewoon. (G, deel 3)
2. **Stap 0 ontbreekt.** Hoe wissel je van spec? Welke gear heb je nodig? Heb je een schild nodig? Niets daarover. (G, deel 3)
3. **Je vindt het slecht.** De Role Academy zit in de kamer Tools, als derde subtab van de Toolbox. Er is geen `/mh academy`. (G, deel 1)

De healer-kant is beter dan de tank-kant. Heal heeft 13 lessen, tank heeft er 8. Tanken mist juist de lessen die een DPS-speler het hardst nodig heeft. (G: `RoleAcademy.lua:38-63`)

---

## 1. Wat er is, waar het staat en hoe je er komt

| # | Onderdeel | Wat het doet | Hoe kom je er | Bewijs |
|---|---|---|---|---|
| 1 | **Role Academy** | Drie tracks: Tank, Heal, DPS. Bovenaan staan 4 vinkjes ("pre-flight"). Dan volgt een knop "How you play <spec>" en een lijst met je spells. Daarna komen de lessen: tank 8, heal 13, DPS 8. | Kamer **Tools**, kaart "Role Academy". Of **Toolbox**, derde subtab. In de zoekbalk werken "tank", "heal", "role" en "academy". Na Enter werken ook "tanken" en "healen". **Er is geen slash-commando.** | G: `RoleAcademy.lua:11-74, 776-798`; `UI.lua:3932-3939`; `RoomLauncher.lua:59`; `NavSearch.lua:268`; `Guide.lua:314-336`. Geen `academy`-tak in de slash-handler (`Core.lua:1007` e.v.; grep vond wel `aggro` op :1120, dus het patroon werkt) |
| 2 | **Tank-toolkit** (in de Academy) | Per tankspec: "active mitigation (keep these up)" en "personal defensives (save these)". Speel je DPS, dan zie je een **preview** van de tankspec van je klasse. | Academy, Tank-track | G: `TankToolkit.lua:72-133`; `RoleAcademy.lua:562-603`; koppen `enUS.lua:4057-4058` |
| 3 | **Healer-toolkit** + `/mh healcds` | Per healspec: je gewone heals, je cooldowns, je eigen defensives en je dispel. | Academy, Heal-track; of `/mh healcds` (werkt alleen als je in een healspec zit) | G: `HealerCooldowns.lua:99-251, 552-565`; `Core.lua:2460` |
| 4 | **"How you play"-kaart** (`/mh play`) | Tabs: Your buttons / Stay alive / Consumables / Dispel / Group. Healers krijgen ook de regels "How to heal" en "How you fight alone". Je kunt de andere specs van je klasse bekijken. | `/mh play`, of de knop bovenaan de Academy | G: `PlayCardWindow.lua:900-912, 977-1008`; `enUS.lua:698-700`; `HealerSolo.lua:24-69` |
| 4b | Tab **Group** ("Voor je groep") | Knoppen voor een ander: redden, healen, bevrijden, groep, rez. Uitgelegd in heel eenvoudige taal. Alle 7 healspecs en 5 van de 6 tankspecs hebben deze tab. Vengeance heeft hem niet. | Tab op de kaart; `/mh group` legt uit waarom | G: `GroupPlan.lua:42-410`, `:112-114`; `enUS.lua:1575-1582` |
| 5 | **Tank pull summary** | Laat na elke pull zien wat je hebt ingedrukt. **Staat standaard UIT.** | `/mh pullsummary` | G: `TankPullSummary.lua:14, 28-30`; `Core.lua:2604` |
| 6 | **Boss-venster** | Per baas een regel voor tank, healer en DPS. Met drie rol-knopjes bekijk je de regel van een andere rol. | `/mh bosswin`, Dungeons-tab, of de baasnaam in de zoekbalk | G: `DungeonBossWindow.lua:863-898`. In `DungeonTipsData.lua` staan 46 `tank =`-regels en 44 `healer =`-regels (geteld) |
| 7 | **Codex: "Aggro: who is the enemy hitting?"** | Zet de waarschuwingen van het spel zelf aan: nameplate-flits, rode rand op raid frames, stem bij "targeted". | Codex → Dungeons; `/mh aggro` | G: `MidnightCodexData.lua:410-418`; `Codex.lua:129`; `Core.lua:1120` |
| 8 | **Codex: "Mythic+, from your first key"** | Hoe je aan een key komt, hoe je je aanmeldt, wat er gebeurt in de run. | Codex → Dungeons | G: `MidnightCodexData.lua:386-396`; `Codex.lua:127` |
| 9 | **Dungeons 101** | 6 hoofdstukken, van "wat is een dungeon" tot Heroic. Hoofdstuk 3 verwijst naar de Role Academy. | Dungeons-tab | G: `DungeonGuide.lua:51-67`, `:58` |
| 10 | Macros-tab | Mouseover-heals en interrupt-macro's. | Toolbox → Macros; `/mh macros` | G: `enUS.lua:272, 2709` |

**Zo vind je het (G, tenzij anders vermeld):**
- De Academy is een **leerpagina**, maar staat in de kamer **Tools**. De kamer **Codex** heeft geen kaart voor de Academy, terwijl Dungeons en Raids daar wel staan. (`UI.lua:474-475`; `RoomLauncher.lua:55-63, 116-148`) Ik denk dat een leerling eerst in de Codex zoekt. (A)
- De Tools-startpagina noemt de Academy, de kaarten, healcds en pullsummary niet. (`ToolsLaunchpad.lua`; grep leeg. Ter controle vond `macro|bosswin|TOOLLP_` wel 17 treffers in hetzelfde bestand.)
- De lessen noemen maar één commando: `/mh healcds` (`enUS.lua:2244`). `/mh play`, `/mh mark`, `/mh ready`, `/mh dispel`, `/mh pullsummary` en `/mh aggro` noemen ze niet. Die commando's bestaan wel (`CommandList.lua:114, 166-176`).
- Zoekwoorden: de Academy reageert op "role tank heal academy" (`NavSearch.lua:268`). Volgens de code vinden de Engelse woorden "tanking", "healing", "how to tank" en "healer" de Academy niet. "healer" en "healing" leiden naar `/mh healcds` (`NavSearch.lua:595`). Dat commando zegt tegen een DPS-speler alleen "switch to your healing spec" (`enUS.lua:4018`). (A: afgeleid uit de code, niet in het spel getypt.)

---

## 2. Klopt het voor 12.1 / Season 2?

### Wat goed is
- **De Heal-track** is juist en tijdloos: triage, mana, plek, fouten, "het is oké als iemand doodgaat" (`enUS.lua:2220-2248`). (G voor de tekst, A voor het oordeel)
- **De kaarten en de Group-tab** zijn in heel eenvoudige taal geschreven. De bronnen staan erbij, met datums uit aug-sep 2026 (`GroupPlan.lua`, de `source =`-regels). (G)
- **De toolkits laten alleen spells zien die jij hebt** als het je eigen spec is. Zo staan er geen verdwenen spells in. (G: `RoleAcademy.lua:456-468`)
- **De regel "How to heal"** legt eindelijk uit hoe je een doel kiest (`enUS.lua:698`). (G) Voor een echte beginner is dat precies de goede eerste zin. (A)

### Fouten en verouderde dingen

| # | Wat | Bewijs | Ernst |
|---|---|---|---|
| F1 | **Dode verwijzingen.** De vinkjes sturen je naar "Guides -> Defensives or In groups tab". De infotekst zegt: "Leveling Guides adds an In groups advisor tab per role". **Die tabs bestaan niet.** De Guides-tab heeft alleen de subtabs *Guide* en *Layout*. Daarbij staat de Guides-tab vanaf level 90 standaard **verborgen**. Dezelfde fout staat in alle 7 talen. | G: `enUS.lua:2188, 2192, 2266`; `nlNL.lua:2113, 2117, 2191`; `UI.lua:4018-4032`; `Core.lua:580-592`. Een grep op "In groups" vond alleen deze tekstregels. Het patroon werkt dus, alleen bestaat de tab nergens in de code. | Hoog: een beginner zoekt iets wat er niet is |
| F2 | De regel bovenaan zegt "open Macros / Consumables / **Guides** from the sidebar". Op level 90 is Guides weg. | G: `enUS.lua:2182` | Middel |
| F3 | De korte omschrijving noemt alleen "tank or healer". De DPS-track bestaat ook. | G: `enUS.lua:273` tegenover `RoleAcademy.lua:64-73` | Klein |
| F4 | **Tegenstrijdig advies over defensives.** De Academy zegt: bewaar de tweede "for oh no" (`enUS.lua:2203`). De toolkit zegt: "Save it for the scary moments" (`enUS.lua:4075`). De Vengeance-kaart zegt: druk ze bijna op cooldown in, om de beurt (`enUS.lua:1516`). | G (de tegenspraak). A: in 12.1-dungeons druk je een defensive **vóór** de grote klap, of aan het begin van een grote pull, en je wisselt ze af. Pas drukken als het misgaat is dé beginnersfout van tanks. | Hoog voor tanks |
| F5 | **Brewmaster.** De toolkit kent alleen Celestial Brew 322507. De kaart noemt een alternatief, 1241059. Volgens warcraft.wiki.gg zijn Celestial Brew en Celestial Infusion een keuze-talent (sinds 11.2, nog zo in 12.0). Kies je Infusion, dan mist hij in de toolkit en telt de pull summary hem niet. | G: `TankToolkit.lua:88-91`, `enUS.lua:1478`. De wiki-bron is **zonder datum** (zoekresultaat). Dat 1241059 echt Infusion is, heb ik niet gecontroleerd. | Middel |
| F6 | **Follower dungeons.** Dungeons 101 zegt "available while leveling 80-90". Hetzelfde bestand zegt "Normal & Follower (**always available**)". warcraft.wiki.gg, Midnight Season 2 (bewerkt 24 sep 2026): alle negen Midnight-dungeons zijn er in Normal en Follower. | G: `DungeonGuide.lua:55` tegenover `:72`; de wikipagina. **In de client op level 90 niet gecontroleerd.** | Middel. Het bepaalt of "oefen in een follower dungeon" (`enUS.lua:2236`) wel kan |
| F7 | Divine Shield "drops your threat". Volgens warcraft.wiki.gg slaan vijanden iemand anders zolang hij aan staat. Je threat blijft, maar ze komen niet altijd terug. Het effect in de praktijk klopt, het woord niet precies. | G: `enUS.lua:4076`; de wiki is **zonder datum** | Laag |
| F8 | Plek van de healer: "a back corner" (`enUS.lua:2242`). Dat past niet bij Mistweaver. Die vecht volgens zijn eigen kaart mee in melee ("Your kicks heal too", `enUS.lua:1494-1499`). | G (beide teksten), A (de botsing) | Klein |
| F9 | Dungeons 101 hoofdstuk 6 belooft dat er "later" een Mythic-hoofdstuk komt. Het M+-artikel staat er sinds 2 okt al. | G: `DungeonGuide.lua:67`; `MidnightCodexData.lua:382-396` | Klein |
| F10 | **De vertalingen lopen achter.** De enUS-tekst `ACADEMY_TANK_BOTH_BODY` is herschreven. Alle 6 andere talen hebben nog de oude tekst. esES zegt "cambiar de tanque y curar**te**" ("en jezelf healen"). ptBR noemt Delves "mergulhos" ("duiken"). | G: `enUS.lua:2217`; `nlNL.lua:2142`; `deDE.lua:458`; `frFR.lua:443`; `esES.lua:446`; `itIT.lua:529`; `ptBR.lua:443` | Middel |
| F11 | De Prot Paladin-kaart zegt "Pull with Hand of Reckoning". Een taunt pakt maar één vijand. Een pack pull je met Avenger's Shield. De tweede helft van de zin is precies goed: taunt als een vijand iemand anders slaat. | G: `enUS.lua:1199`; A (oordeel) | Klein |

---

## 3. Wat mist er voor een DPS-speler die wil leren tanken of healen?

| Onderwerp | Is het er? | Bewijs |
|---|---|---|
| **Wat is aggro of threat?** Hoe krijg je het, en waarom pakt een DPS het af? | **Nee.** Er staat alleen "Grab the pack (taunt / threat)". Het aggro-artikel gaat over instellingen, niet over hoe het werkt. | G: `enUS.lua:2203`; `Codex.lua:129` |
| **Taunt:** wat het doet, en wanneer je het **niet** gebruikt | **Half.** "Forces an enemy to attack you" staat alleen in de Guides-tab, en die is op level 90 verborgen. Van de 6 tank-kaarten noemt alleen Prot Paladin de taunt. | G: `enUS.lua:2426`; `enUS.lua:1199`. Ik zocht op de 6 taunt-ID's in de kaarten: alleen 62124 gaf een treffer |
| Wanneer pullen, tempo, mana van de healer | Ja, kort | G: `enUS.lua:2207` |
| **Waar de tank staat:** baas stil laten staan, uit de troep slepen, packs bij elkaar, frontals wegdraaien | **Eén zin**: "Face enemies away" | G: `enUS.lua:2203`; A (wat erin hoort) |
| **Active mitigation of cooldown:** wat is het verschil? | Alleen als kopjes in de toolkit, niet uitgelegd. En tegenstrijdig, zie F4. | G: `enUS.lua:4057-4058` |
| **Wat een healer anders ziet:** frames klaarzetten | Verspreid over twee plekken: de Dispel-tab (debuff-kleur, raid-style party frames) en het aggro-artikel (rode rand). Er is geen stap "zet eerst je frames goed". | G: `enUS.lua:1161`; `Codex.lua:129` |
| **Hoe je een heal op iemand zet** (klikken, mouseover, Click Casting) | De kaart zegt: klik het frame, druk dan de toets. Het vinkje vraagt al om "hover-heal" zonder te zeggen wat dat is. **Blizzards eigen Click Casting staat nergens.** | G: `enUS.lua:698, 2191, 2194`. Grep op "click cast" was leeg. Ter controle vond "mouseover" wel treffers |
| Mana, triage | Ja | G: `enUS.lua:2222, 2240` |
| Praten met de groep | Ja, chatregels om te kopiëren. Markers (`/mh mark`) en ready check (`/mh ready`) bestaan, maar de Academy noemt ze niet. | G: `enUS.lua:2213, 2230`; `CommandList.lua:168-169` |
| Eerste dungeon als tank of healer | Ja, kort. **De follower dungeon ontbreekt in beide ladders**, terwijl dat de veiligste oefenplek is. De NPC's volgen jou, en als healer heb je echte mensen om te healen. | G: `enUS.lua:2207, 2215, 2226, 2232`; A (waarom follower) |
| **Spec kiezen en wisselen, loot spec** | **Nergens** | G: grep op "loot spec\|dual spec\|switch spec" vond alleen code (`SimcExport.lua:462`), geen tekst voor spelers |
| **Gear per rol** | **Nergens.** Hybride klassen hebben in een andere spec een andere hoofdstat: Holy Paladin Int, Ret Str; Resto Druid Int, Feral/Guardian Agi; Mistweaver Int, Windwalker/Brewmaster Agi; Resto Shaman Int, Enhancement Agi. Prot Paladin en Prot Warrior hebben een **schild** nodig. `/mh stats` werkt alleen voor je actieve spec. | A (algemene spelkennis, niet gemeten). G: het stats-artikel gaat per spec (`enUS.lua:2611`) |
| **Woordenlijst** | **Nee.** "pack", "pull", "chain", "CC", "oom", "trash", "kick" en "brez" staan zonder uitleg in de lessen. De Codex-woordenlijst gaat alleen over gear en currencies. | G: `enUS.lua:2207, 2226`; `nlNL.lua:2132`; `Codex.lua:79` |

**De echte valkuilen voor wie overstapt** (A, uit ervaring; niets hiervan staat in MH):
- Als DPS loop je achter de tank aan. Als tank ben jij degene die loopt. Je moet de route kennen.
- Naar de damage meter blijven kijken. Een tank of healer telt niet op de meter.
- Active mitigation vergeten. De pull summary helpt daarbij, maar staat standaard uit (`TankPullSummary.lua:14`, G).
- Taunt gebruiken om een gevecht te beginnen, of om een vijand van de andere tank af te pakken.
- Als healer te veel meeschieten, of juist niets doen terwijl niemand schade heeft.
- De knoppen van de nieuwe spec nooit binden. MH heeft `/mh block` en `/mh apply`, maar de Academy noemt ze niet (G: ACADEMY-teksten).
- Als Prot je oude tweehandige wapen houden. Zonder schild werkt een deel van je verdediging niet.

---

## 4. Is er een logische route van nul naar de eerste dungeon?

**Nee, niet als één route.** De stukken zijn er wel. Een speler moet ze zelf vinden, in deze volgorde (G, plekken zoals in deel 1):

1. Tools → Toolbox → Role Academy, Tank- of Heal-track
2. Daar de knop "How you play <spec>". Dat werkt pas goed als je die spec al aan hebt staan.
3. Dungeons-tab → Dungeons 101
4. Codex → Aggro, en Codex → Mythic+
5. In de dungeon: het boss-venster

**Binnen de Academy staat het in de omgekeerde volgorde** (G: `RoleAcademy.lua:38-63, 776-798`):
- Eerst komen de vinkjes en een spell-lijst met gekleurde labels. Pas daarna lees je wat je taak eigenlijk is.
- De ladder, de route zelf, staat op **plek 7 van 8** (tank) en **plek 12 van 13** (heal).
- De Tank-track opent altijd eerst, ook als je wilt leren healen (`RoleAcademy.lua:90-99`). Dat is klein.

**Hoe de route er volgens mij uit moet zien** (A):
0. Wat is je taak? (aggro en taunt, of triage en frames, in 5 zinnen)
1. Spec wisselen, loot spec instellen, gear (hoofdstat, schild)
2. Knoppen binden (`/mh block`)
3. De kaart lezen (`/mh play`), met de tab Stay alive
4. Bij de dummy: taunt, mitigation, healen op een vriend
5. Een delve of follower dungeon
6. Een normal dungeon met de chatregels
7. Heroic
8. De eerste key

---

## 5. Top-5 verbeteringen, van klein naar groot

| # | Wat | Wat het kost |
|---|---|---|
| 1 | **Dode verwijzingen weghalen** (F1, F2, F3, F9) en de achterlopende vertaling bijwerken (F10). Laat de vinkjes wijzen naar plekken die bestaan, bijvoorbeeld de tab "Stay alive" op de kaart (`/mh play`). | Ongeveer 6 sleutels in 7 talen, plus `check_drift`. **Ongeveer 1 uur.** Geen onderzoek nodig. |
| 2 | **Vindbaar maken.** Een commando `/mh academy [tank\|heal]` plus een regel in `CommandList`. Zoekwoorden toevoegen: "tanking", "healing", "how to tank", "leren tanken", "healer worden", "switch role". Een kaart in de Codex-kamer. Een knop in Dungeons 101 hoofdstuk 3 en op de kaart. | Een kleine Lua-wijziging en 2 of 3 sleutels. **Ongeveer 2 uur.** |
| 3 | **Drie nieuwe lessen in eenvoudige taal:** (a) "Aggro en taunt in 5 zinnen", met erbij wanneer je níét taunt. (b) "Je scherm als healer": frames klaarzetten, en hoe je iemand kiest (klikken, mouseover, Click Casting). (c) Een kleine woordenlijst van ongeveer 12 woorden. | Eerst `mh-research` voor de menupaden in 12.1 en de plek van Click Casting. Dan `mh-writer` en 7 talen. **Ongeveer een halve dag.** |
| 4 | **Eén lijn over defensives** in de Academy, de toolkit en de kaarten: vooraf drukken, om de beurt (F4). **De follower dungeon in beide ladders**, maar eerst op level 90 in de client controleren (F6). **Het alternatief voor Brewmaster** in de toolkit en de pull summary, maar het ID eerst meten (F5). | Onderzoek, 4 tot 6 sleutels en 1 dataregel. **2 tot 3 uur.** |
| 5 | **Een stappenplan "Rol wisselen"** bovenaan de Academy, af te vinken per personage, net als Dungeons 101 (`DungeonGuide.lua:48`). De stappen staan in deel 4. Waar de client het zelf ziet, vinkt het vanzelf af (actieve spec is tank of heal, taunt staat op een toets). De lessen gaan omgekeerd: eerst het begrip, dan de knoppen. | Een nieuw blok of een verbouwde `RoleAcademy.lua`, plus onderzoek, 7 talen en een test door Rob en Cisca. **1 tot 2 dagen.** |

**Keuze voor Rob:** 1 en 2 zijn klein en maken bestaande dingen bruikbaar. 3 en 5 zijn wat nodig is voor "iemand die het écht niet snapt". 5 is groot. Een tussenweg is 3 nu doen en 5 later.

---

## Bronnen buiten de repo

- warcraft.wiki.gg, *Midnight Season 2*, bewerkt 24 sep 2026. Alle negen Midnight-dungeons zijn er in Normal en Follower. https://warcraft.wiki.gg/wiki/Midnight_Season_2
- warcraft.wiki.gg, *Celestial Brew*, zonder datum, via een zoekresultaat. Keuze-talent met Celestial Infusion. https://warcraft.wiki.gg/wiki/Celestial_Brew
- warcraft.wiki.gg, *Divine Shield*, zonder datum, via een zoekresultaat. Vijanden wisselen van doelwit. https://warcraft.wiki.gg/wiki/Divine_Shield

Niets onder `docs/` gelezen.
