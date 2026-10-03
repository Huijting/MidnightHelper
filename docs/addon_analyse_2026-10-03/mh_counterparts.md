# Wat Midnight Helper vandaag al doet — tegenhangers van AggroCaller en RecommendedStats

Peildatum 3 okt 2026. WoW Retail 12.1 "Midnight".
Alles hieronder is **GEMETEN** (gelezen in onze eigen code, met `bestand:regel`) of **AFGELEID**.
Paden zijn relatief aan `E:\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper\`.

---

## 0. Het korte antwoord per concurrent-onderdeel

| Hun onderdeel | Heeft MH dat? | Waar |
|---|---|---|
| Threat/aggro-meting | **NEE, nul code** | GEMETEN: grep `UnitThreatSituation\|UnitDetailedThreatSituation\|GetThreatStatusColor` over de hele addon = **0 treffers**. Positieve controle: grep `issecretvalue` in dezelfde map geeft 107 treffers in 53 bestanden, dus het patroon zoekt wél. |
| Tank-callouts | Deels: **na** de pull, niet live | `Modules/TankPullSummary.lua` (GEMETEN regel 1-16) |
| Tank-knoppenlijst | JA | `Modules/TankToolkit.lua` (GEMETEN regel 1-22) |
| Dungeon guide / bosstips | JA, groot | `Modules/DungeonGuide.lua`, `DungeonTipsData.lua`, `DungeonBossWindow.lua`, `DungeonLiveCoach.lua` |
| Raid-markers | JA | `Modules/FastMark.lua` |
| Marker-toewijzing per baas | **NEE** | AFGELEID: geen enkele tabel koppelt een markericoon aan een boss/mob; `FastMark.lua` is een handmatige balk (GEMETEN, hele bestand gelezen) |
| Stat-prioriteit per spec | JA, al vóór RecommendedStats | `Modules/StatCoach.lua` + `Modules/VaultAdvisorData.lua` |
| Gear-advies / upgrade | JA, 4 modules | `LootUpgrade.lua`, `TrackCeiling.lua`, `GearEnchantCheck.lua`, `CharacterSidePanel.lua` |
| Spec-"hoe speel je dit" | JA, 40 specs | `Modules/PlayCards.lua` (GEMETEN: 40 `[specID] = {`-regels) |

---

## 1. `Modules/StatCoach.lua` — stat-prioriteit uitgelegd (`/mh stats`)

**1. Wat de speler ziet, en wanneer.**
- Commando `/mh stats` (en alias `/mh stat`). GEMETEN: `Core.lua:1201` → `if msg == "stats" or msg == "stat" then`.
- Staat in de zichtbare commandolijst, groep Gear. GEMETEN: `Modules/CommandList.lua:153` → `{ cmd = "/mh stats", descKey = "CMDLIST_STATS" }`.
- Vindbaar via de zoekbalk met een lang trefwoordenblok ("crit critical strike haste mastery versatility … priority order explain plain what do they do"). GEMETEN: `Modules/NavSearch.lua:592-593`.
- Inhoud: kop met spec (spec) klasse, een "je hebt dit waarschijnlijk niet nodig"-regel, primaire stat, dan de vier secundaire stats op de orde van je spec, elk met je eigen percentage. GEMETEN: `StatCoach.lua:310-340` (`ns.BuildStatCoachText`).
- 🔴 Het bestand zégt zelf dat de kop "je hebt dit waarschijnlijk niet nodig" is: ilvl eerst, stats alleen als tie-break. GEMETEN: `StatCoach.lua:29-34`.

**2. API's en guards.**
- `GetSpecialization`, `GetSpecializationInfo` (GEMETEN `StatCoach.lua:101-110`).
- `GetSpecializationMasterySpells` — `C_SpecializationInfo.GetMasterySpells` bleek MISSING op 12.1, de dode kandidaat is verwijderd. GEMETEN: `StatCoach.lua:134-152`.
- `C_Spell.RequestLoadSpellData` / `GetSpellName` / `GetSpellDescription` voor de mastery-tekst (GEMETEN `StatCoach.lua:162-171`).
- `GetCritChance` / `GetSpellCritChance(2)` gesplitst zoals PaperDollFrame, `GetHaste`, `GetMasteryEffect`, `GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)` (GEMETEN `StatCoach.lua:189-227`).
- Blizzards eigen labels via `_G["STAT_HASTE"]` etc., dus geen eigen vertaling van statnamen (GEMETEN `StatCoach.lua:73-90`).
- **Geen** `issecretvalue`-guard. GEMETEN: grep `issecretvalue` noemt `StatCoach.lua` niet. AFGELEID: niet nodig, het leest alleen de eigen speler.
- **Geen** `InCombatLockdown`, geen secure frames. GEMETEN: grep `InCombatLockdown` noemt `StatCoach.lua` niet.
- "Niet kunnen lezen" wordt nooit 0: `Num()` geeft `nil` terug en `nil` toont als onbekend. GEMETEN: `StatCoach.lua:60-71` + `303-308`.

**3. Waar de data vandaan komt.**
- De orde komt uit `ns.GetCurrentSpecWeights()` in `Modules/VaultAdvisor.lua:287`, dezelfde call als de Vault-adviseur en de Pawn-export, "zodat de drie nooit kunnen driften". GEMETEN: `StatCoach.lua:36-39`.
- De gewichten staan in `Modules/VaultAdvisorData.lua:11` (`ns.VAULT_ADVISOR_SPEC_WEIGHTS`), **auto-gegenereerd** uit `data/vault_stat_priorities.json` via `tools/generate_vault_stat_weights.py`, patch 12.1. GEMETEN: `VaultAdvisorData.lua:1-11`.
- Per spec staat de bron er als URL bij (Icy Veins + Wowhead). GEMETEN: `VaultAdvisorData.lua:13-14`.
- Sleutels zijn per hero-tree én per profiel: `DEATHKNIGHT_250`, `..._HERO_31`, en `_MPLUS`-varianten. GEMETEN: `VaultAdvisorData.lua:15,24` + `VaultAdvisor.lua:187,250,270-273`.
- `ns.VAULT_ADVISOR_SPEC_META` levert `priorityText`, `sources` en `patch` aan de pagina. GEMETEN: `StatCoach.lua:259, 296-299`.
- Datum van de meting van de API's: 27 aug 2026 op Robs Elemental Shaman, live 12.1. GEMETEN: `StatCoach.lua:134-137`.

**4. Bekende hiaten / wat het bewust NIET doet.**
- Gelijke gewichten krijgen **hetzelfde rangnummer**; er wordt geen willekeurige orde verzonnen. GEMETEN: `StatCoach.lua:266-283`.
- Zonder gewichten wordt de orde **niet** geclaimd; de vier worden alleen uitgelegd. GEMETEN: `StatCoach.lua:230-248` + `328`.
- Zonder spec (verse of lage char) geen advies, alleen `STATS_NO_SPEC`. GEMETEN: `StatCoach.lua:104-109, 215`.
- Mastery wordt **nooit zelf beschreven** — de client levert de tekst per spec. GEMETEN: `StatCoach.lua:21-27`.
- Eigen diagnose `/mh stats probe` die per API zegt of hij antwoordde. GEMETEN: `StatCoach.lua:40-43`.

---

## 2. `Modules/CharacterSidePanel.lua` — signaalpaneel naast het karakterscherm

**1. Wat de speler ziet.**
- Een smal paneel naast Blizzards karakterscherm, **alleen op het Character-tabblad**, niet bij Reputation. GEMETEN: `CharacterSidePanel.lua:26-34` (via `PaperDollFrame:IsShown()`).
- Ankert aan `CharacterStatsPane` (de echte rechterrand), met `CharacterFrame` als terugval. GEMETEN: `CharacterSidePanel.lua:36-44`.
- Maximaal een paar regels, elk een doorklik naar het paneel dat het echte werk doet. GEMETEN: `CharacterSidePanel.lua:9-11`.
- Regels: ontbrekende enchants, open sockets, tier-set `x/y`, track-plafond, plus altijd twee knoppen **Armory** (`ns.ShowGearExport`) en **Raidbots** (`ns.ShowSimcExport`). GEMETEN: `CharacterSidePanel.lua:49-126`.

**2. API's en guards.**
- Rekent zelf **niets** uit; alles via `ns.GetGearEnchantSummary`, `ns.GetTierSetSummary`, `ns.GetTrackCeilingSteps`, allemaal in `pcall`. GEMETEN: `CharacterSidePanel.lua:13-19, 50, 70, 85`.
- Geen `issecretvalue`, geen `InCombatLockdown`, geen secure frames. GEMETEN: beide greps noemen dit bestand niet.
- `nil` is géén 0: een onleesbare tier-telling blijft van het paneel af in plaats van "0/5" te claimen. GEMETEN: `CharacterSidePanel.lua:16-18, 73`.
- "Alles in orde" verschijnt alleen als er écht iets gelezen is; is er niets gelezen, dan is er geen paneel. GEMETEN: `CharacterSidePanel.lua:97-106`.

**3. Herkomst.**
- Framenaam niet aangenomen maar gecontroleerd tegen andere geïnstalleerde addons: BlizzMove voor `CharacterFrame`, EllesmereUIBlizzardSkin voor de `PaperDollFrame:IsShown()`-truc, MyCharacterPanel voor `CharacterStatsPane`. GEMETEN: `CharacterSidePanel.lua:21-23, 28-31, 40-41`.
- Raidbots-knop is Robs wens van 30 sep 2026. GEMETEN: `CharacterSidePanel.lua:108-112`.

**4. Hiaten.**
- Niets equipt, sockelt of wijzigt. GEMETEN: `CharacterSidePanel.lua:19`.
- Geen stat-prioriteit op dit paneel (die zit in `/mh stats`). AFGELEID uit de regels die het wél bouwt (`BuildLines`, GEMETEN `:46-128`).

---

## 3. `Modules/GearEnchantCheck.lua` — enchant/socket-check met suggestie per slot (`/mh enchant`)

**1. Wat de speler ziet.**
- `/mh enchant` (en `/mh enchants`). GEMETEN: `Core.lua:3138`.
- In de commandolijst, groep Gear. GEMETEN: `CommandList.lua:152`.
- Zoektrefwoorden "gear enchant gems check missing". GEMETEN: `NavSearch.lua:586`.
- Per enchantbaar slot: ontbreekt er een enchant, en wat zou er passen bij de top-secundaire van je spec. Elke suggestie is klikbaar/hoverbaar; klik zet de naam in een kopieerveld voor de Auction House. GEMETEN: `GearEnchantCheck.lua:1-10`.
- Slots: main hand, chest, head, shoulder, 2 ringen, feet, legs. GEMETEN: `GearEnchantCheck.lua:27-36`.

**2. API's en guards.**
- "Taint-veilig: alleen read-only inventory + spec; geen beschermde calls." GEMETEN: `GearEnchantCheck.lua:20`.
- Slotnamen uit Blizzards globals (`HEADSLOT`, `FINGER0SLOT`…), dus al vertaald. GEMETEN: `GearEnchantCheck.lua:25-26`.
- Eén `issecretvalue`-guard in het bestand. GEMETEN: grep-telling `GearEnchantCheck.lua:1`.
- Geen `InCombatLockdown`. GEMETEN: grep noemt het bestand niet.

**3. Herkomst en versheid.**
- Enchant-namen/ID's uit Wowhead 12.0.7 (research 15 jun 2026, `SESSION_NOTES`). GEMETEN: `GearEnchantCheck.lua:13-14`.
- Stat-keuze hergebruikt `ns.VAULT_ADVISOR_SPEC_WEIGHTS` — dezelfde bron als `/mh stats`. GEMETEN: `GearEnchantCheck.lua:5, 293, 311`.
- Spell-ID's zijn **tegen Robs client gemeten**, niet van een gids overgenomen: `/mh spell 1236059` op 19 aug, `/mh item 244640 244642` op 20 aug, `/mh item save` → `ns.db.itemScan`. GEMETEN: `GearEnchantCheck.lua:49, 85-94, 111-127`.
- "Empowered"-rang gevonden en gerepareerd: de oude tabel adviseerde de goedkope rang terwijl Robs eigen helm al de Empowered droeg. GEMETEN: `GearEnchantCheck.lua:80-84`.
- SpellPilot 0.11.38 beweert het omgekeerde over Blood Knight's/Forest Hunter's en is **fout**; de tooltips zijn de bron. GEMETEN: `GearEnchantCheck.lua:117-120`.

**4. Wat het bewust NIET doet.**
- Geen BiS, alleen stat-gematchte suggestie; voor min-maxen een class-guide. GEMETEN: `GearEnchantCheck.lua:17-18`.
- Shoulder krijgt **geen** stat-claim (effect nog onbevestigd). GEMETEN: `GearEnchantCheck.lua:16-18`.
- Blood DK staat er bewust buiten (runes i.p.v. enchants). GEMETEN: `GearEnchantCheck.lua:62-65`.
- Rite of the Hash'ey (12.1) bewust afwezig: geen bron heeft het nog opgepikt. GEMETEN: `GearEnchantCheck.lua:67-69`.

---

## 4. `Modules/DungeonGuide.lua` + `DungeonTipsData.lua` (+ `DungeonBossWindow.lua`, `DungeonLiveCoach.lua`, `DungeonRosterData.lua`, `InstanceMap.lua`)

**1. Wat de speler ziet.**
- Dungeons-tabblad met **drie weergaves**: "This week" (Spark, dungeon van de week, Cracked Keystone, Vault-rij, Follower-hint), "Dungeons 101" (6 beginnershoofdstukken met vinkjes per personage) en "Coach" (hele roster met EJ-namen). GEMETEN: `DungeonGuide.lua:1-16`.
- `/mh coach` opent de coach. GEMETEN: `Core.lua:2828`; in de lijst als `CMDLIST_COACH`, GEMETEN `CommandList.lua:175`.
- `/mh bosswin` = zwevend bossvenster met pager `< i/N >`, klikbare `{SPELL:id}`-links, versleepbaar, resizable, SHIFT+scroll schaal 0.7-1.8, mini-portret dat een zijpaneel met het 3D-model togglet. GEMETEN: `Core.lua:3068` + `DungeonBossWindow.lua:1-24`.
- Auto-opent bij `ENCOUNTER_START`; de X zwijgt **per baas**, niet voor de hele dungeon. GEMETEN: `DungeonBossWindow.lua:21-23, 42-45`.
- `/mh livetips` = bosstappen in je eigen chat bij `ENCOUNTER_START`; `/mh bossshare` stuurt ze als platte tekst naar party/instance. GEMETEN: `Core.lua:3006` + `DungeonLiveCoach.lua:1-11`. Standaard AAN. GEMETEN: `DungeonLiveCoach.lua:83-89`.
- `/mh map` = de plattegrond van de dungeon/raid met de bazen erop, baas aanklikbaar → onze tips. GEMETEN: `Core.lua:3159` + `InstanceMap.lua:14-16`; in de lijst, GEMETEN `CommandList.lua:116`.

**2. API's en guards.**
- `C_WeeklyRewards.GetActivities` (type 1 = Activities) voor de Vault-rij, in `pcall`. GEMETEN: `DungeonGuide.lua:66-96`.
- `ENCOUNTER_START` met `dungeonEncounterID` → tabel met 44 encounter-ID's. GEMETEN: `DungeonLiveCoach.lua:17-78`.
- `InstanceMap.lua` gebruikt `EJ_GetNumTiers/EJ_SelectTier/EJ_GetInstanceByIndex` en loopt **vier tiers terug**, niet alleen de nieuwste. GEMETEN: `InstanceMap.lua:47-55`.
- Eén `issecretvalue` in `DungeonBossWindow.lua`, vijf `InCombatLockdown` daar, één in `DungeonLiveCoach.lua`. GEMETEN: de twee greptellingen.
- Voortgang per personage op `UnitGUID("player")`. GEMETEN: `DungeonGuide.lua:53-64`.

**3. Herkomst en versheid.**
- Tips zijn **eigen MH-tekst in beginnerstaal**, geschreven tegen twee kruisverwijzingen op Robs schijf: BossHelper (MIT) en DungeonHelper, en door Rob geverifieerd in follower-runs. Focus: Normal; Heroic later. GEMETEN: `DungeonTipsData.lua:5-8`.
- Batch 2 (11 jun) kwam uit DBM-Party-Midnight (spell-ID's/voice-cues) + Wowhead-spelltooltips. GEMETEN: `DungeonTipsData.lua:84-86`.
- Encounter-ID's uit DBM-Party-Midnight/-WoD/-WotLK/-Legion/-Dragonflight, gelezen 11 jun 2026. GEMETEN: `DungeonLiveCoach.lua:8-11`.
- Roster: Season 1 journal-ID's uit BossHelper, gekruist met Methods M+-lijst; ingangs-coördinaten uit Zygors LibRover-data (alleen als kruisverwijzing, geen tekst overgenomen). GEMETEN: `DungeonRosterData.lua:4-23`.
- `journalInstanceID` 1300 i.p.v. BossHelpers 249 voor Magisters' Terrace, want 249 is de oude TBC-ingang. GEMETEN: `DungeonRosterData.lua:47-49`.
- **13 dungeons** hebben tips: windrunnerspire, altaroffangs, maisara, murderrow, nalorakk, blindingvale, voidscar, nexuspoint, magisters, skyreach, pitofsaron, triumvirate, algethar. GEMETEN: grep van de top-level sleutels in `DungeonTipsData.lua:18,50,64,87,113,133,159,179,199,228,254,274,300`.
- Verste bijwerking: 3 okt 2026 ochtend, 8 overige dungeons nagelopen door 8 helpers; 29 bazen beoordeeld → **7 fout, 11 ontbreekt, 1 onzeker, 158 klopt** → 17 nieuwe sleutels, in 7 talen. GEMETEN: `docs/NEXT_SESSION.md:3-12`.
- 2 okt: alle 8 M+-dungeons erin, 7 talen. GEMETEN: `docs/NEXT_SESSION.md:60-67`.

**4. Hiaten / TODO's.**
- 🔲 **Lange tips (`_STEPS` + rolregels) zijn NIET herschreven**; de gevonden problemen staan per baas in `dgn2\*.json` in de scratchpad (bv. Saprish tank/DPS, WS Heart-tank "doubles" moet 40%, Algeth'ar mist moeilijkheids-kopjes). GEMETEN: `docs/NEXT_SESSION.md:13-14`.
- ⚠️ Windrunner Spire en Maisara Caverns zijn in S2 vermoedelijk alleen Normal + Followers — **AFGELEID uit bronnen, niet in de client gezien**, staat op de testlijst. GEMETEN dat het zo opgeschreven staat: `docs/NEXT_SESSION.md:15-16`.
- Rolsecties zijn bewust **niet compleet**: Rav'i heeft geen tank-regel omdat DBM geen tank-defensive voor hem vlagt, en in Altar of Fangs heeft geen enkele baas een dps-regel. "Een leeg-maar-aanwezig vak leest als advies." GEMETEN: `DungeonTipsData.lua:46-49`.
- Per-boss stappen kwamen pas in fase 3; tot die tijd zei de Coach dat eerlijk. GEMETEN: `DungeonGuide.lua:10-12`.
- "Dungeons 101"-vinkjes zijn **handmatig**; auto-detectie is een latere fase, "never guessed". GEMETEN: `DungeonGuide.lua:7-9`.
- `InstanceMap` kan **niet** tonen waar je groep staat: posities binnen een instance zijn voor addons verborgen (GEMETEN 27 sep via `/mh groupmap`: nil voor iedereen, ook voor jezelf). GEMETEN: `InstanceMap.lua:11-12`.
- Vier launch-only dungeons hebben nog `nil` EJ-ID's; nooit geraden. GEMETEN: `DungeonRosterData.lua:8-10, 15-16`.
- Maar 2 bazen hebben een korte "QUICK"-variant. GEMETEN: grep `_QUICK` in `DungeonTipsData.lua` = 2.

---

## 5. `Modules/FastMark.lua` — de raid-markerbalk (`/mh mark`)

**1. Wat de speler ziet.**
- `/mh mark` (alias `/mh fastmark`) togglet een eigen balk. GEMETEN: `Core.lua:2561` + `FastMark.lua:496-499`.
- In de commandolijst, groep Group, trefwoorden "raid target markers world marker fast mark skull". GEMETEN: `CommandList.lua:164` + `NavSearch.lua:604`.
- **Standaard UIT**; de balk verschijnt pas als je hem aanzet. GEMETEN: `FastMark.lua:43-52`.
- Twee rijen. **Boven: world-markers** (de vlaggen op de grond), **onder: target-markers** (skull/cross op een vijand). Die volgorde is Robs correctie van 28 jul: je zet eerst de plek, dan het icoon. GEMETEN: `FastMark.lua:372-396`.
- Target-iconen in de orde Skull → Star (8,7,6,5,4,3,2,1). GEMETEN: `FastMark.lua:63`.
- Per world-marker: links = zetten, rechts = wissen, plus een **gouden ring** als die vlag al op de grond ligt. GEMETEN: `FastMark.lua:198-221`.
- Drie groepsknoppen rechts op de onderste rij: ready check, role check, pull timer (links 10 s, rechts annuleren). GEMETEN: `FastMark.lua:400-422` + `COUNTDOWN_SECONDS = 10` op `:82`.
- Balk alleen zichtbaar als de feature aan staat **én** je in een groep zit. GEMETEN: `FastMark.lua:433-434`.
- Sleepgrip links, alleen buiten combat. GEMETEN: `FastMark.lua:347-370`.
- Diagnose `/mh mark check` print exact waar de balk aan hangt. GEMETEN: `FastMark.lua:461-493`.

**2. De secure aanpak, exact.**
- Sinds 12.0 zijn `SetRaidTarget` én `PlaceRaidMarker` **PROTECTED**. GEMETEN: `FastMark.lua:5`.
- Elke knop is een `CreateFrame("Button", …, "SecureActionButtonTemplate")`. GEMETEN: `FastMark.lua:145-153` (`SecureBtn`).
- **Target-marker** = `type1="macro"`, `macrotext1 = <vertaalde slash> .. " " .. idx`. GEMETEN: `FastMark.lua:178-179`.
- **World-marker** = `type1="worldmarker"`, `marker1=tostring(num)`, `action1="set"`; rechts `type2="worldmarker"`, `marker2`, `action2="clear"`. `marker` is een **STRING**, bevestigd tegen `EllesmereUIQoL_RaidTools.lua:573`. GEMETEN: `FastMark.lua:197-203`.
- **Target-marker wissen** = macro met ` 0`. GEMETEN: `FastMark.lua:397-398`.
- **Alle world-markers wissen kan NIET via het attribuut** (klaart één index per keer), dus dat blijft een macro: `<vertaalde /cwm> <globale woord ALL>`. GEMETEN: `FastMark.lua:24-28, 385-387`.
- 🔴 `/tm` en `/cwm` worden **nooit letterlijk** geschreven: ze komen uit de globals `SLASH_TARGET_MARKER1` en `SLASH_CLEAR_WORLD_MARKER1`, en "alle" uit de globale `ALL`. GEMETEN: `FastMark.lua:132-143`. Vóór 20 sep 2026 deden we het wél letterlijk, en dan deed de balk op een Duitse of Franse client waarschijnlijk niets. GEMETEN: `FastMark.lua:13-17`.
- **Één klikfase**: `RegisterForClicks("AnyDown")` + `SetAttribute("useOnKeyDown", true)`. Twee fases = twee acties per klik, en 12.0 heeft een rem ("You can't do this right now"); `useOnKeyDown` wordt vastgepind omdat de CVar `ActionButtonUseKeyDown` de knop anders dood kan maken. GEMETEN: `FastMark.lua:18-23, 149-152`.
- **De balk parent secure knoppen → de balk is zelf protected.** Dus verplaatsen/tonen/verbergen alleen buiten combat; in combat wordt het uitgesteld tot `PLAYER_REGEN_ENABLED` via `pendingApply`. GEMETEN: `FastMark.lua:32-34, 428-451, 524-530`.
- De groepsknoppen zijn **niet** secure (gewone `OnClick`): `DoReadyCheck`, `InitiateRolePoll`, `C_PartyInfo.DoCountdown`. Ze hebben wél lead/assist nodig, en worden gedimd met uitleg in de tooltip in plaats van stil niets te doen. GEMETEN: `FastMark.lua:247-302, 400-422`.
- `IsRaidMarkerActive(index)` is **niet** protected en drijft de "ligt al"-ring; ontbreekt hij, dan claimt geen knop iets. GEMETEN: `FastMark.lua:97-111, 474-486`.
- Events: `PLAYER_LOGIN`, `PLAYER_ENTERING_WORLD`, `GROUP_ROSTER_UPDATE`, `PLAYER_REGEN_ENABLED`, `RAID_TARGET_UPDATE`, `PARTY_LEADER_CHANGED`. GEMETEN: `FastMark.lua:505-514`.
- Geen `issecretvalue` in dit bestand. GEMETEN: de grep noemt `FastMark.lua` niet.

**3. Herkomst.**
- Routes geverifieerd tegen de werkende FastMarks-addon op 12.0.7 + Warcraft-wiki. GEMETEN: `FastMark.lua:6-9`.
- 20 sep 2026: drie dingen geleerd uit `EllesmereUIQoL_RaidTools.lua` en `wMarker.lua` (regelnummers staan in onze comments). GEMETEN: `FastMark.lua:11-30`.
- Bij "alles wissen" volgen we Ellesmere (vertaalde slash + `ALL`) en niet wMarker (`marker="all"`), omdat die twee elkaar tegenspreken en alleen het spel dat kan beslissen. GEMETEN: `FastMark.lua:24-28`.

**4. Wat het bewust NIET doet.**
- 📌 **Alle acht target-iconen in één keer wissen** is NIET overgenomen: wMarker heeft die knop zelf uitgezet met de reden "broken by macro limits" (`wMarker.lua:506`). GEMETEN: `FastMark.lua:29-30`.
- Geen marker-**toewijzing** per baas of per mob, geen automatische markering. AFGELEID uit het hele bestand: er is geen enkele boss-/mob-tabel en geen automatische klik.
- Geen "wie markeert wat"-verdeling over de groep. AFGELEID, zelfde grond.

---

## 6. `Modules/InterruptMacros.lua` + `InterruptMacrosData.lua` — kick-macro's (`/mh macros`)

**1. Wat de speler ziet.**
- `/mh macros` opent het Macros-tabblad. GEMETEN: `Core.lua:2790`; in de lijst, GEMETEN `CommandList.lua:119`.
- Twee soorten: **Interrupt** en **Utility**, als tabjes bovenin. GEMETEN: `InterruptMacros.lua:15-38` (`ns.MacroPanelTypes`).
- Per spec twee varianten van de kick-macro: **Focus** en **Mouseover**. GEMETEN: `InterruptMacrosData.lua:53-64`.
- Macro-teksten: `#showtooltip\n/cast [@focus,harm,nodead][] <spell>` en `[@mouseover,harm,nodead][]`. GEMETEN: `InterruptMacrosData.lua:33-34`.
- Beschrijvingen zijn EN + NL, met een `IsNlLocale()`-schakelaar. GEMETEN: `InterruptMacros.lua:65-83`.

**2. API's en guards.**
- Sleutel = klasse-token (`UnitClass` select 2) + `GetSpecialization()`-index. GEMETEN: `InterruptMacrosData.lua:3-4`.
- Geen `issecretvalue`, geen `InCombatLockdown`, geen secure frames: dit zijn alleen macro-**teksten** om te kopiëren. GEMETEN: beide greps noemen deze twee bestanden niet.

**3. Herkomst.**
- Handgeschreven spell-tabel, één interrupt per spec, `false` waar een spec er geen heeft (Discipline en Holy Priest). GEMETEN: `InterruptMacrosData.lua:14-29`.
- Spec-indices volgen de client-orde van `GetSpecializationInfo`. GEMETEN: `InterruptMacrosData.lua:3-4`.
- ⚠️ Spell-**namen**, geen ID's. AFGELEID risico: namen zijn clientafhankelijk; de macro's zijn Engelse namen (`"Mind Freeze"`, GEMETEN `:15`). Dat is voor een `/cast`-macro correct op een Engelse client; voor andere talen niet nagemeten in onze code.
- Utility-macro's komen uit `Modules/TeamMacrosData.lua`, **auto-gegenereerd** door `tools/generate_team_macros_lua.py` uit `data/team_macros_gemini.json`. GEMETEN: `TeamMacrosData.lua:1-4`.

**4. Hiaten.**
- De macro's worden **niet** voor je aangemaakt of gebind; je kopieert ze. AFGELEID uit `ns.MH_GetInterruptMacroVariants` dat alleen tekst teruggeeft (GEMETEN `InterruptMacrosData.lua:46-65`).
- Spec 33 noteerde dat `/mh macros` bestond maar niet in `ns.MH_COMMANDS` stond; dat is gerepareerd. GEMETEN: `docs/NEXT_SESSION.md:2776` + `CommandList.lua:117-119`.

---

## 7. Breder gezocht: wat er nog meer in deze hoek ligt

### 7a. Threat / aggro — **MH heeft hier NIETS**
- GEMETEN: `UnitThreatSituation`, `UnitDetailedThreatSituation`, `GetThreatStatusColor`, `threatpct` → **0 treffers** in de hele addon.
- GEMETEN: de 35 bestanden die "threat/aggro" bevatten zijn allemaal iets anders — keybind-rol-data (`KeybindRoles_*`), locale-teksten, docs van de wachters, `TeamMacrosData`. Geen meting van bedreiging.
- AFGELEID: dit is het duidelijkste gat tegenover AggroCaller.

### 7b. Tank-hulp die er wél is
- `Modules/TankToolkit.lua`: per tank-spec je **active mitigation** + **defensive cooldowns**, met gekleurd label en één regel uitleg, spec-aware bovenaan de Role Academy TANK-track, met hover-tooltips. GEMETEN: `TankToolkit.lua:1-7`.
  - Zes tank-specs: Prot Pal 66, Prot War 73, Guardian 104, Blood DK 250, Brewmaster 268, Veng DH 581. GEMETEN: `TankToolkit.lua:20-21, 135`.
  - Herkomst: **Robs geïnstalleerde JustAC-data** (`SpellCooldowns.lua`, `SpellCategories.lua`, `SpellArchetypes.lua`), niet geraden; namen via `C_Spell.GetSpellName` live. GEMETEN: `TankToolkit.lua:8-15`.
  - Bijgewerkt 17 sep 2026 (`docs/audit_2026-09-17`): Last Stand/Dampen Harm/Zen Meditation eruit, Sentinel/Spellwarding/Demoralizing Shout/Darkness erin, Metamorphosis 2 min, Barkskin 45 s. GEMETEN: `TankToolkit.lua:97-99`.
- `Modules/TankPullSummary.lua`: **na** elke pull één rustige chatregel — hoeveel keer je je mitigation drukte, welke defensives je gebruikte, en een zachte tip. GEMETEN: `TankPullSummary.lua:1-7`.
  - `/mh pullsummary` togglet; **standaard uit**, alleen tank-specs, alleen in instances, alleen pulls ≥ 12 s. GEMETEN: `Core.lua:2473` + `TankPullSummary.lua:14-15, 20, 28-38`.
  - Telt **je eigen** casts via `UNIT_SPELLCAST_SUCCEEDED` tegen de geverifieerde TankToolkit-lijsten; **geen verzonnen "ideale uptime %"**. GEMETEN: `TankPullSummary.lua:8-12`.
  - Brewmaster krijgt een tijdgewogen Stagger-gemiddelde. GEMETEN: `TankPullSummary.lua:26`.
  - Mitigation-buff-ID's komen uit de geïnstalleerde TankTraining-addon, die precies dit meet. GEMETEN: `TankPullSummary.lua:67-70`.
  - 2 `issecretvalue`-guards. GEMETEN: de greptelling.
- `Modules/PetTauntProbe.lua` (`/mh pet`): waarschuwt als je pet-taunt (Growl/Suffering) nog op autocast staat terwijl jij niet de tank bent.
  - 🔴 De **obvious versie kan niet gebouwd worden**: "zit er een tank in de groep" vraagt `UnitGroupRolesAssigned` op ándere units, en 12.1 geeft daar een **secret** terug. GEMETEN: `PetTauntProbe.lua:12-15`.
  - ✅ Daarom omgedraaid naar "ben ík niet de tank", via `GetSpecializationRole`, dat nooit naar een unit vraagt. GEMETEN: `PetTauntProbe.lua:17-19`.
  - Growl 2649 en Suffering 17735 zijn **gemeten met de waarde in beweging** (aan → `autoEnabled=true`, uit → `false`), 7 sep 2026. GEMETEN: `PetTauntProbe.lua:50-53`.
  - 🔴 Sacrifice 7812 is uit de tabel gehaald: het stond er met het label "geen taunt maar wordt verward" en zou dus valse alarmen geven. GEMETEN: `PetTauntProbe.lua:55-59`.
  - `/mh pet` staat bewust **niet** in de zichtbare lijst. GEMETEN: `CommandList.lua:78` (in `MH_UNLISTED_ON_PURPOSE`).
- `Modules/RoleAcademy.lua`: tank/heal/dps-tracks met preflight-vinkjes (tank: interrupt, defensive, consumables, **taunt**) en 8 secties tekst per track. GEMETEN: `RoleAcademy.lua:1-48`.

### 7c. Live gevechtshulp (dichtst bij "callouts")
- `Modules/CombatSafety.lua`: versleepbaar waarschuwingsicoon + optionele castbalken zodra een vijand een belangrijke spell op **jou** cast, met optionele TTS. GEMETEN: `CombatSafety.lua:1-31`.
  - De 12.x secret-value-aanpak staat er exact: nooit zelf rekenen met tijden (`UnitCastingDuration` → duration-object → `SetCooldownFromDurationObject`), nooit `if important/targetsPlayer` maar `frame:SetAlphaFromBoolean()` en `C_CurveUtil.EvaluateColorValueFromBoolean()`. GEMETEN: `CombatSafety.lua:7-15`.
  - API's 1-op-1 uit de geïnstalleerde TargetedSpells (12.0.7); alles in `pcall`. GEMETEN: `CombatSafety.lua:16-19`.
  - **Bewust geen eigen spell-database** ("de valkuil van GTFO"). GEMETEN: `CombatSafety.lua:21`.
  - Bewuste beperking: **geen MOVE!/INTERRUPT!-onderscheid** en geen exacte geluid-gating op "op mij" — dat vergt vertakken op secret waarden. GEMETEN: `CombatSafety.lua:29-31`.
- `Modules/ActionPrompt.lua` (`/mh prompt`): één plek op het scherm met "jouw interrupt" en "jouw dispel".
  - `notInterruptible` is secret en wordt **nooit gelezen**, alleen doorgegeven aan `SetAlphaFromBoolean`. GEMETEN: `ActionPrompt.lua:18-21, 260-293`.
  - `castBarID` is **niet** secret, dus "cast er iets" mag je wél vertakken; dat verbergt het icoon tussen casts. GEMETEN: `ActionPrompt.lua:22-23, 277`.
  - `GetAuraSlots("target","HELPFUL|DISPELLABLE",1)` gemeten op 3 aug: 27 hits in 200 calls, nul errors. GEMETEN: `ActionPrompt.lua:24-26`.
  - 🔴 **NIET secure, NIET klikbaar**: scripts op een `SecureActionButtonTemplate` tainten het, en dat brak op 3 aug de click-to-target van het party-target-paneel. "De prompt zegt wat je moet drukken; je eigen keybind drukt het." GEMETEN: `ActionPrompt.lua:28-31`.
  - Het moet een **Button** zijn, geen Frame: `SetAlphaFromBoolean` bestaat daar niet, en toen faalde de feature stil. GEMETEN: `ActionPrompt.lua:59-66`.
- `Modules/InterruptScore.lua` (`/mh kicks`): jouw eigen kick — geland of verspild.
  - 100% lokaal, **geen comms, geen HUD, en geen kick-toewijzing** ("Midnight forbids that in instances"). GEMETEN: `InterruptScore.lua:6-9`.
  - Alleen oude events: `UNIT_SPELLCAST_SUCCEEDED` (player) + `UNIT_SPELLCAST_INTERRUPTED`, geen zware combat-log-handler. GEMETEN: `InterruptScore.lua:11-13`.
  - Secret-casts worden `issecretvalue`-guarded en vallen terug op een match op tijd alleen (venster 0,5 s). GEMETEN: `InterruptScore.lua:13-14, 21, 24-26`.
  - De eigen "whiff"-waarschuwing is **build-gated UIT op 12.1**, omdat Blizzard daar zelf een native "missed" toont; de telling loopt altijd. GEMETEN: `InterruptScore.lua:16-18, 28-33`.
  - De spell volgt `ns.MH_GetInterruptSpell`, dus een Paladin krijgt Rebuke en niet "Kick" (fout van 28 jul 2026, gerepareerd). GEMETEN: `InterruptScore.lua:40-57`.
- `Modules/PartyTargets.lua` (`/mh partytargets`): vier groepsleden + jijzelf, en waar ze op staan.
  - 🔴 Het paneel **toont namen die het niet mag LEZEN**: elke route (`UnitName`, `UnitFullName`, `GetUnitName`, `UnitGUID`) geeft secret, en `UnitIsUnit` geeft een secret **boolean**. GEMETEN: `PartyTargets.lua:9-13`.
  - Dus **geen** sorteren op doel, **geen** "drie van vier staan op jouw doel", **geen** highlight van de rij die bij jou hoort. "Als een toekomstig idee hier een naam moet inspecteren, kan het niet gebouwd worden — dat is het ontwerp, geen omissie." GEMETEN: `PartyTargets.lua:15-20`.
  - Veiligheidsregel voor dit bestand: nooit een expressie laten vragen wát een waarde is; `x = ok and v or nil` crasht op een secret boolean. GEMETEN: `PartyTargets.lua:28-30`. 9 `issecretvalue`-guards en 12 `InCombatLockdown` in dit ene bestand. GEMETEN: de greptellingen.
  - Dispel-rij kan **niet** alleen-bij-nood verschijnen: de rij draagt een secure button en die mag in combat niet getoond/verborgen worden. Oplossing = de rij staat er altijd en **gloeit rood** met DISPEL erin. GEMETEN: `PartyTargets.lua:49-57`.
  - Markericonen via `SetRaidTargetIconTexture(texture, index)` — dat neemt de index en zet de textuur zelf, dus het werkt op een secret. GEMETEN: `PartyTargets.lua:1430-1434` + `PartyTargetProbe.lua:231-248`.

### 7d. Spec "play cards" — *Zo speel je*-kaarten
- Module `Modules/PlayCards.lua` (data) + `Modules/PlayCardWindow.lua` (venster). GEMETEN: `PlayCardWindow.lua:1-14`.
- `/mh play` (aliassen `/mh howtoplay`, `/mh playcards`). GEMETEN: `Core.lua:3108`; in de lijst als `CMDLIST_PLAY`, "ook de gouden knop in de zoekbalk". GEMETEN: `CommandList.lua:113-114`.
- **40 specs**. GEMETEN: 40 `[specID] = { --`-regels in `PlayCards.lua`.
- Vaste vorm: IDEA, S1..S5, AOE, MISTAKE, HERO1/2. GEMETEN: `PlayCards.lua:12-17`.
- Tekst in de locale-packs als `PLAYCARD_<specID>_<PART>`; spellnamen als `{SPELL:id}` zodat de client de naam in elke taal levert. **Een spell zonder bevestigd 12.1-id wordt platte Engelse tekst, geen geraden id.** GEMETEN: `PlayCards.lua:19-21`.
- **Elke kaart noemt zijn bronnen mét datum** (bv. Prot Pal: "Method 3 Sep · Wowhead 12 Aug · Icy Veins 21 Sep 2026", hergecontroleerd 25 sep). GEMETEN: `PlayCards.lua:29-46`.
- Eigen venster omdat Rob 25 sep zei dat ze in de Academy "veelste verstopt" waren; blijft open naast een target dummy, icoon per stap, hoogte volgt de inhoud, niets scrollt. GEMETEN: `PlayCardWindow.lua:4-13`.
- ⚠️ Header zegt: pilot 4 specs (Ret 70, Arcane 62, Prot Pal 66, Elemental 262) goedgekeurd 24 sep, de andere 36 op 25 sep, "**Not seen in the game yet**". GEMETEN: `PlayCards.lua:6-10`.

### 7e. Gear- en upgrade-advies
- `Modules/LootUpgrade.lua` (`/mh loot`, **standaard aan**): één regel in de item-tooltip — is dit beter dan wat je in dat slot draagt, voor jouw spec. GEMETEN: `Core.lua:2276` + `LootUpgrade.lua:1-14, 24-26`.
  - Hergebruikt de Vault-scorer + dezelfde stat-weights (`ns.GetLootUpgradeInfo` in `VaultAdvisor.lua`) — **geen tweede statmodel**. GEMETEN: `LootUpgrade.lua:5-6`.
  - never-lie: ilvl is exact, het spec-oordeel is gidsgebaseerd, dus hoger-ilvl-maar-slechtere-stats wordt eerlijk **"Sidegrade"**; zonder vergelijking niets. GEMETEN: `LootUpgrade.lua:8-11, 37-45`.
- `Modules/TrackCeiling.lua` (`/mh tracks`): "ik zit op Hero 6/6, nu wat?" GEMETEN: `Core.lua:2359` + `TrackCeiling.lua:3-8`.
  - Bron: `C_Item.GetItemUpgradeInfo(itemLink)`, **niet** tooltip-tekst, geverifieerd tegen drie geïnstalleerde addons (EllesmereUI:1935, Baganator:424, Plumber:237). GEMETEN: `TrackCeiling.lua:10-13`.
  - ⚠️ `trackString` is **gelokaliseerd**, dus nooit vergeleken met "Hero": plafond numeriek (`currentLevel >= maxLevel`), orde op `trackStringID`, de naam wordt alleen **getoond**. Dat is precies de bug die de Omnium Folio-knop op elke niet-Engelse client brak. GEMETEN: `TrackCeiling.lua:15-21`.
  - **Geen** item levels en **geen** key-drempels: die schuiven per seizoen en de bronnen spreken elkaar tegen (+7 vs +9 vs +10 voor Myth-crests). We noemen het soort content en laten het spel de getallen tonen. GEMETEN: `TrackCeiling.lua:23-26`.
  - Onleesbaar slot wordt overgeslagen, nooit uit ilvl geraden; is er niets gelezen, dan melden we niets i.p.v. "0 maxed". GEMETEN: `TrackCeiling.lua:27-28`.
- `Modules/VaultAdvisor.lua`: scoort de Great Vault-keuzes via `C_WeeklyRewards` + item-links, **zonder internet**. GEMETEN: `VaultAdvisor.lua:1-4`. Gebruikt **Pawn** als die er is (`PawnGetItemData`/`PawnGetSingleValueFromItem`), met een eigen schakelaar. GEMETEN: `VaultAdvisor.lua:52-67`.
- `Modules/PawnExport.lua` (`/mh pawn`) exporteert onze gewichten naar een Pawn-scale. GEMETEN: `PawnExport.lua:34` (leest `ns.VAULT_ADVISOR_SPEC_META`) + `CommandList.lua:154`.
- `/mh export` → Armory-tekst voor midnighthelper.com (`GearExport.lua`), `/mh raidbots` → SimulationCraft-invoer (`SimcExport.lua`). GEMETEN: `CommandList.lua:155-159`.
- `Modules/DawncrestGuide.lua`: crest-sectie in het Guide-tabblad, met Blizzards eigen woord voor de seizoenscap.
  - 🔴 Het label komt uit `_G.CURRENCY_SEASON_TOTAL_MAXIMUM`; onze eigen tekst "of 100, the cap" liet Rob denken dat het een definitieve muur was. GEMETEN: `DawncrestGuide.lua:29-42`.
  - ⚠️ Die global is een **format string**, niet een label: 14 aug stond er op het scherm "(Current Season Maximum: %s%s/%s 100 / 100)". Nu wordt alles vanaf de eerste `%` afgeknipt. GEMETEN: `DawncrestGuide.lua:43-55, 56-70`.
  - Wat er gevonden is, wordt vastgelegd in `ns.db.seasonMaxLabelSource`, zodat een verdwenen global zichtbaar is. GEMETEN: `DawncrestGuide.lua:62-68`.

### 7f. Vindbaarheid, als systeem
- `Modules/CommandList.lua` is de **enige** commandolijst (`ns.MH_COMMANDS`, regel 97), gegroepeerd per kamer, niet alfabetisch. GEMETEN: `CommandList.lua:20-21, 95-97`.
- `tools/lint_addon.py` controleert dat **elk** `cmd` ergens gerouteerd is; een verdwenen commando laat de build falen. GEMETEN: `CommandList.lua:23-27`.
- De **spiegelcheck** bestaat ook: `ns.MH_UNLISTED_ON_PURPOSE` (regel 75) houdt dev-probes en aliassen apart, zodat iets dat gerouteerd is maar nergens staat, opvalt als "nieuw commando dat niemand geclassificeerd heeft". GEMETEN: `CommandList.lua:41-93`.
- Metingen die in dat bestand staan: 18 aug 2026 **149 gerouteerde namen tegen 44 vermelde**; later 171 gerouteerd. GEMETEN: `CommandList.lua:46-47, 106-108`.
- 🔴 Twee keer bleek een feature **onvindbaar** terwijl hij bestond: `/mh poisons` (Valeera-giftips) en de "geen ranking dit seizoen"-regel die naar `/mh curios` wees terwijl `/mh curios` juist de adviseur opende. GEMETEN: `CommandList.lua:59-71`.
- `Modules/NavSearch.lua` indexeert **alleen** `ns.MH_COMMANDS` (regel 611) en voegt een eigen trefwoordtabel toe (`CMD_KEYWORDS`, regel 572) omdat beschrijvingen woorden als "kick" niet bevatten. GEMETEN: `NavSearch.lua:556-571, 611-627`.
- De zoekrij toont de **actie** eerst en het commando gedimd erachter, omdat een rij die als documentatie leest niet wordt aangeklikt. GEMETEN: `NavSearch.lua:564-568`.

---

## 8. Open punten uit de bovenkant van `docs/NEXT_SESSION.md` (het levende deel)

Alle regels hieronder GEMETEN in `docs/NEXT_SESSION.md`, regelnummer erbij.

- 🔲 **Lange dungeontips (`_STEPS` + rolregels) niet herschreven**; per baas `steps_problems` in de scratchpad-JSON's. Regel 13-14.
- ⚠️ Windrunner Spire + Maisara Caverns in S2 alleen Normal + Followers = **AFGELEID**, op de testlijst. Regel 15-16.
- 🔲 Lange **raid**tips idem niet herschreven (Lura Heroic 1 soak sinds 16 jun, Chimaerus Caustic Phlegm 12 vs 20 s). Regel 120-121.
- 🔲 Solo-uitleg in de geüploade 4.5.0 zegt nog "Home" i.p.v. "This Week"; al gerepareerd in `main` (commit b2cf393), gaat mee in de volgende versie. Regel 56-58.
- 🔲 Onzeker en op de testlijst: Gilded Stash alleen Bountiful?, Special Assignments 3/week?, Valeera-XP van doden?, shards per rare buiten Coiled Isle. Regel 31-32.
- ⚠️ `GROUP_FINDER_GENERAL_PLAYSTYLE1` = Learning is **AFGELEID** → testlijst. Regel 79.
- 🔲 `docs/NALOOP_LIJST.md` heeft 13 onderdelen, belangrijkste eerst; Rob kiest de volgorde. Regel 68-69.
- Geen release: 4.5.1 wordt nog niet uitgebracht (Rob). Regel 18.
- Status van de vier delve-codepunten: Vault-getallen uit de tooltip, "End" alleen op Bountiful, Delver's Call is géén weekly, Coffer Keys per personage — **alle vier gedaan en gemeten**. Regel 20-30.

---

## 9. Samenvattend: waar MH sterk staat en waar het gat zit

| | |
|---|---|
| **MH is sterker in** | uitleggen (13 dungeons × bosstappen in 7 talen, 40 play cards met bronvermelding + datum, stats in jip-en-janneke-taal), vindbaarheid als systeem (lint + spiegelcheck + zoekindex), en eerlijkheid bij onleesbare data (`nil ≠ 0`, 107 `issecretvalue`-guards in 53 bestanden). Alles GEMETEN hierboven. |
| **MH heeft al een tegenhanger voor** | RecommendedStats volledig: `/mh stats` + `VaultAdvisorData` per spec én per hero-tree, met bron-URL en patch. AggroCaller deels: dungeon guide, markers, tank-knoppen, spec-uitleg. |
| **Het echte gat** | **threat/aggro-meting: nul regels code** (GEMETEN, 0 treffers). En **marker-toewijzing per baas** bestaat niet (AFGELEID). |
| **Wat we bewust NIET doen** | kick-toewijzing in instances (`InterruptScore.lua:6-9`), alle 8 target-iconen in één keer wissen (`FastMark.lua:29-30`), MOVE!/INTERRUPT!-onderscheid (`CombatSafety.lua:29-31`), eigen spell-database (`CombatSafety.lua:21`), sorteren/highlighten op party-doel (`PartyTargets.lua:15-20`), item levels en key-drempels noemen (`TrackCeiling.lua:23-26`), lege rolsecties vullen (`DungeonTipsData.lua:46-49`). Alle zeven GEMETEN. |
