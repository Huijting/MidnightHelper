# CONTENT_WATCH.md — dagelijkse content-wachter

Dit is het logboek van de **content-wachter**: game-content (Delves, beroepen, quests,
dungeons/raids, items) — niet de addon-/API-kant, die dekt `docs/API_WATCH.md`. Zelfde vorm:
nieuwe regels **onderaan**, nooit iets overschrijven. Elke regel: `- [JJJJ-MM-DD]` + emoji + vette
kop, per bevinding MEASURED/INFERRED en [RAAKT ONS]/[RAAKT ONS NIET], met bestand:regel.

---

- [2026-09-01] 🧭 **Eerste run — sweep van patch-launch (11 aug) t/m vandaag, geen tegenspraak
  gevonden.** ⚠️ **Toegangsbeperking, eerlijk vermeld:** `news.blizzard.com`, `wowhead.com`,
  `bluetracker.gg`, `us.forums.blizzard.com` en `warcraft.wiki.gg` zijn in deze sessie allemaal
  door de egress-proxy geblokkeerd (WebFetch gaf `EGRESS_BLOCKED` op elk van de vijf). Ik heb dus
  **geen enkele hotfix-pagina zelf integraal gelezen**; alles hieronder komt uit WebSearch'
  eigen samenvattingen van die pagina's (met bronvermelding), wat zwakker is dan het "ik heb het
  zelf gelezen, hier het citaat" dat MEASURED normaal betekent. Ik noem dat hieronder expliciet
  **MEASURED (via search, niet zelf gelezen)**. Wat wél rechtstreeks gemeten is, is de kant van
  onze eigen code — die greps zijn echte MEASURED.

  📌 **Positieve controle voor alle greps hieronder:** `Lor'themar's Judgement` (een quest die
  zeker in `docs/ATAL_UTEK_QUESTS.md:22` staat) en `VENOMFALL` (4 treffers in
  `Locales/DelveTips.lua`) kwamen beide gewoon terug met dezelfde zoekvorm als de nul-treffers
  verderop — een leeg resultaat hieronder is dus gemeten afwezigheid, niet een kapot patroon.

  **Bevindingen, per hotfix-datum:**

  - **13 aug** — Delve *Shadowguard Point: Shadowguard Survivor* gaf geen Great Vault-credit; nu
    gefixed. Shadowguard Point is één van onze elf (`Locales/DelveTips.lua`), maar geen van onze
    tips claimt iets over vault-credit per delve — dat is een generiek Blizzard-mechaniek dat we
    nergens beschrijven. MEASURED (via search) voor de hotfix; MEASURED in onze code dat er niets
    over te toetsen valt (`grep -i "shadowguard.*vault"` → 0 treffers, `DELVE_TIP_SHADOWGUARD`
    bestaat wel voor route/boss, niet voor vault). **[RAAKT ONS NIET]**
  - **13 aug** — Ritual Sites gaven Great Vault-tiers die niet klopten met de bedoelde tiers;
    vanaf "volgende week" (dus inmiddels weken terug) tiers 1-6 voor week-1-activiteit. Overtaken
    by events: dit was een launch-week-bug die allang voorbij is. `RITUAL_TIP_INTRO_WEEKLY`
    (`Locales/RitualTips.lua:94`) claimt alleen "telt mee voor de World-rij van de Great Vault" —
    geen specifieke tier-cijfers, dus niets om tegen te spreken. **[RAAKT ONS NIET]**
  - **13 aug** — Spelers die *Legends of the Haranir* over meerdere personages hadden verdeeld
    konden *The Empty Cradle* niet vervolgen; nu gefixed. Wij tracken quest 93891 "Legends of the
    Haranir" wél (`Modules/ResetRoutine.lua:119`, `Modules/WeeklyHubProbe.lua:29`), maar alleen
    als weekly-quest-ID, niet de cross-character-bug of de "Empty Cradle"-vervolgketen — die naam
    staat nergens in de repo (0 treffers, tegen de positieve controle hierboven). **[RAAKT ONS
    NIET]**
  - **20 aug** — "Seasonal Refresher: Midnight" (quest 97454) kon niet afgerond worden; nu
    gefixed. Quest-ID 97454 staat alleen in dev-notes/probe-bestanden
    (`Modules/AtalUtekProbe.lua:266`, `Modules/SeasonTransitionData.lua:223`), niet in een
    geshipte speler-tip. **[RAAKT ONS NIET]**
  - **20 aug** — "Delve into the Earth" kon geblokkeerd raken als een combat-roll-keuze voor
    Brann buiten een delve niet doorkwam; nu gefixed. Deze questnaam komt in de hele repo niet
    voor (0 treffers). **[RAAKT ONS NIET]**
  - **20 aug** — "Trailing Xal'atath" en "Midnight: World Tour" gaven geen Tidal Spark Dust; nu
    gefixed. Onze "World Tour"-tracker (`Modules/DelverCallData.lua`, 10 quest-ID's) leest titel
    en status live via `C_QuestLog` en claimt nergens een beloningsbedrag — er is dus niets in
    onze data dat deze bug tegensprak. **[RAAKT ONS NIET]**
  - **20 aug** — "Purging the Vaults" (95520) en "Vaults of Atal'Utek: A Toxic Tour" (98515) waren
    niet af te ronden als je al een Codex of the Soulcoilers in je tas had; nu gefixed. Beide
    quest-ID's staan bij ons (`docs/ATAL_UTEK_QUESTS.md:36,79`, `Modules/CampaignLeadIn.lua:178`)
    puur als ID/naam, zonder claim over afrondingsvoorwaarden. **[RAAKT ONS NIET]**
  - **20 aug** — Jewelcrafting- en Tailoring-Knowledge-boeken van "Zul'jarra's Forces" gaven geen
    Knowledge; met terugwerkende kracht rechtgezet. `Modules/ProfessionAcademyData.lua` noemt geen
    enkel Zul'jarra-boek (0 treffers) — het bestand dekt alleen de generieke hoofdstukken 1-5 plus
    Enchanting/Alchemy-starterhoofdstukken (`ProfessionAcademyData.lua:2-4`), niets
    beroepsspecifieks voor Jewelcrafting/Tailoring. **[RAAKT ONS NIET]**
  - **(datum niet teruggevonden, wel binnen het venster)** — `Contract: Zul'jarra's Forces` paste
    soms per ongeluk het Amani Tribe-contract toe. Wij noemen beide facties (2696 Amani Tribe,
    2772 Zul'jarra's Forces) alleen als Renown-drempel voor achievements/mounts
    (`Modules/AchievementsData.lua:379,479,576`, `Modules/MountProgress.lua:119`), nooit als
    contract-item-gedrag. **[RAAKT ONS NIET]**
  - **31 aug** — Venomous Abyss-raid: wereld-indicators voor Caustic Globule/Barbed Bulwark
    konden te vroeg verdwijnen; Zul'jan bij 1 HP aan het eind van de intermission was soms
    onbreekbaar; 4-piece setbonus aangepast. Onze hazard-glow-lijst voor instance 3004
    (`Modules/HazardData.lua:253-270`) bevat acht spell-ID's (Soulcoil Well, Corpse Blight,
    Anguished Echoes, Blood Venom, Cultivated Burst, Latent Cultist, Slithering Flame, Swirling
    Spirit) — geen van deze namen staat erin, en wij volgen sowieso geen boss-tuning-percentages
    of kill-order voor raids. **[RAAKT ONS NIET]**
  - **(datum onzeker — search vermengde dit met resultaten die mogelijk van vóór 11 aug/PTR
    stammen, dus NIET met zekerheid binnen het venster)** — "Illusory Deceit" bij Infiltrator
    Gulkat (The Darkway) zou het aantal Twilight Illusions verkeerd schalen op spelersaantal;
    "Ravenous Descendant" se "Ravenous"-stack aangepast (10% i.p.v. 20% attack speed, +20%
    movement slow); een Ancient Golem in de Game Night-variant van The Ring of Glory viel aan
    voor activatie; Lightbloom's Essence periodic damage -25%. ⚠️ Een gekoppelde claim over
    "Ekhart"/"Stormslam" kon in een aparte zoekopdracht niet bevestigd worden — die laat ik hier
    dus expliciet weg in plaats van hem door te geven als hotfix. Onze boss-tip voor The Darkway
    noemt `{SPELL:@illusory_deceit}` wél (`Locales/DelveTips.lua:50`: "exploding illusions — keep
    distance while handling Gulkat") maar zegt niets over spelersaantal-schaling, dus de bugfix
    spreekt de tip niet tegen. "Ravenous Descendant" en "Lightbloom's Essence" als specifieke
    ability-namen staan niet in onze hazard-lijst of tips (wel andere "Ravenous *"-namen op
    andere instances, `Modules/HazardData.lua:184,221,244` — geen overlap). **[RAAKT ONS NIET]**

  **Terzijde, geen hotfix-bevinding maar tijdens deze sweep gemeten:** The Ring of Glory en
  Gnarldor Isle (beide Season 2-delves, in onze roster sinds 17-18 aug,
  `Modules/Delves.lua:86-87`) hebben **geen** `DELVE_TIP_*`/`DELVE_CHAT_*`-entries in
  `Locales/DelveTips.lua` — alleen Venomfall Deeps (de derde S2-delve) heeft tips. MEASURED
  (0 treffers op `GNARLDOR`/`RING_OF_GLORY` in dat bestand, tegen de VENOMFALL-positieve-controle
  hierboven). Geen hotfix veroorzaakte dit, dus geen [RAAKT ONS]-vlag — puur een ontbrekend stuk
  content dat tijdens het lezen opviel; Rob beslist of dat de moeite waard is.

  Bron: WebSearch-samenvattingen van news.blizzard.com hotfix-artikelen 13/17/19/20/21/25/26/27/31
  aug 2026 (rechtstreekse toegang tot alle vijf bovengenoemde domeinen geblokkeerd door de
  egress-proxy — zie boven). Codebase-kant: `grep` over `Locales/DelveTips.lua`,
  `Modules/DelveSpellIds.lua`, `Modules/Delves.lua`, `Modules/ProfessionAcademyData.lua`,
  `Modules/CampaignLeadIn.lua`, `docs/ATAL_UTEK_QUESTS.md`, `Locales/RitualTips.lua`,
  `Modules/HazardData.lua`, `Modules/AchievementsData.lua`, `Modules/MountProgress.lua`,
  `Modules/DelverCallData.lua`, `Modules/AtalUtekProbe.lua`, `Modules/ResetRoutine.lua`,
  `Modules/WeeklyHubProbe.lua`, `Modules/CurioExplain.lua` — allemaal vandaag gelezen.
  **[RAAKT ONS NIET]** — geen van de gevonden hotfixes spreekt een geshipte claim tegen. Geen open
  actiepunt.

  🔴 **CORRECTIE op de "terzijde" hierboven, dezelfde avond nagetrokken.** The Ring of Glory en
  Gnarldor Isle hebben **wél** tips, en niet zuinig: `DELVE_TIP_RINGOFGLORY_OVERVIEW`,
  `_DANGER`, `_ROUTE` en `DELVE_TIP_GNARLDOR_OVERVIEW`, `_ROUTE` staan in
  `Locales/enUS.lua:1521-1546`, plus `Modules/DelveTipsData.lua` en `Modules/DelveChestData.lua`.
  Ring of Glory bevat een heel Tier 11-verslag met zeven encounters.

  ⚠️ **De meting klopte, de conclusie niet** — er is gegrept in `Locales/DelveTips.lua` en daar
  staan ze inderdaad niet. En de positieve controle redde het niet, want die stond **in hetzelfde
  bestand**: dat bewijst dat het patroon werkt wáár je kijkt, niet dat je op de juiste plek kijkt.
  📌 Bij een bewering over afwezigheid moet de controle dus **dezelfde reikwijdte** hebben als de
  bewering. De opdracht van de wachter is diezelfde avond aangepast: grep over de hele
  `Locales/`- en `Modules/`-boom, en de bestandenlijst is een startpunt en geen grens.
