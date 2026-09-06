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

---

- [2026-09-02] ✅ **Geen tegenspraak gevonden — hotfixes 31 aug en 1 sep gelezen, niets geshipts
  geraakt.** `news.blizzard.com` gaf vandaag weer `EGRESS_BLOCKED` op WebFetch (zelfde blokkade als
  1 sep). Ditmaal wel **MEASURED, zelf gelezen**: Exa's `web_fetch_exa` haalde Wowhead's Blue
  Tracker-spiegel van de Blizzard-hotfixartikelen **1 sep 2026** en **31 aug 2026** rechtstreeks op
  (volledige tekst, geen samenvatting) — sterker dan de "via search"-bronvermelding van 1 sep.
  WebSearch bevestigde daarnaast dat er nog geen lijst van 2 sep bestaat. De 31-aug-lijst stond al
  in de bronvermelding van de vorige run, maar geen van de bevindingen hieronder kwam daar terug —
  dus opnieuw gecontroleerd in plaats van als "al gedaan" overgeslagen.

  📌 **Positieve controle, zelfde scope als de claims hieronder:** `grep -i crest`
  in `Locales/enUS.lua` geeft 41 treffers, en `grep -i "Corrosive Coin"` (hele repo, eerdere run)
  geeft tientallen treffers — dus de 0-treffers verderop op "Adventurer Crest" en "Er'iyne" zijn
  gemeten afwezigheid, niet een kapot patroon.

  **Bevindingen:**
  - **31 aug — Gnarldor Isle, "Minchi's Osseous Adventure":** vereist nu 4 bone piles (was 6).
    Onze enige tekst hierover, `DELVE_STORY_MINCHI_S_OSSEOUS_ADVENTURE`
    (`Locales/enUS.lua`, `Modules/DelveStoryData.lua:51`, `Modules/DelveStoryData.lua` beschrijving
    in `DelveStories.lua:49`), is pure flavourtekst ("Piles of gnawed bones might put most people
    off...") zonder aantal — niets om tegen te spreken. MEASURED. **[RAAKT ONS NIET]**
  - **31 aug + 1 sep — The Coiled Altar (Zul'jan-encounter):** meerdere fixes/tuning op Coalesced
    Venom, Venom Rupture, Volatile Venom, Wail of Terror, Spiteful Soulcoiler, Defilement, en het
    minimumaantal spelers voor Guillotine/Grim Guillotine (naar 3). Onze
    `RAID_BOSS_COILEDALTAR_STEPS` (`Locales/RaidTips.lua:44`) noemt Guillotine alleen generiek
    ("geef elkaar ruimte") en drie andere spell-ID's (1286918 schild, 1283832 ontwijk, 1289900
    mind-control) — geen van de hierboven genoemde ability-namen of spelersaantallen staat erin.
    MEASURED (0 treffers op alle vijf namen in de hele repo). **[RAAKT ONS NIET]**
  - **1 sep — The Twin Fangs (Vexhul/Ithraz):** Eternal Venom-stackthreshold naar 10 op Mythic,
    Ravenous Feast-minimumtargets naar 4, immuniteitsbug gefixed. `RAID_BOSS_TWINFANGS_STEPS`
    (`Locales/RaidTips.lua:42`) beschrijft het stack-mechaniek generiek ("blijft stapelen... stun")
    zonder zelf een getal te noemen — geen tegenspraak. MEASURED. **[RAAKT ONS NIET]**
  - **31 aug — Ula'tek:** eieren-dragen-schade nu periodiek i.p.v. direct, Grasping Fangs-bereik
    vergroot, Blight Vein/Toxic Burn-bugs gefixed, ze kon niet meer tijdens de intermission
    re-emergen. **1 sep erbij:** Blightscale Wretch/Toxic Womb/Spectral Head-volgorde gefixed,
    Revenge-nameplate-shift gefixed. `RAID_BOSS_ULATEK_STEPS` (`Locales/RaidTips.lua:46`) noemt
    vier andere spell-ID's (1292403, 1287265, 1286860 Venomous Heart, 1290779) en geen van deze
    zes genoemde ability-namen — en zegt er zelf al bij "ze is nooit op de PTR verschenen... reken
    op verrassingen, deze pagina wordt gecorrigeerd uit echte pulls". Deze stroom aan Ula'tek-
    hotfixes bevestigt dat die disclaimer terecht stond, maar spreekt niets concreets in onze tip
    tegen. MEASURED (0 treffers op alle zes namen). **[RAAKT ONS NIET]**
  - **1 sep — Tidebound Grotto (Nymrissa Wavecaller):** Frost Orb-duur 16→12s, schade/gezondheid
    omlaag voor kleinere groepen. `RAID_BOSS_NYMRISSA_*` (`Locales/RitualTips.lua:114-116`) noemt
    wél twee spell-ID's voor haar lijn-aanval (1282937, Mythic 1268562) en de murloc-add
    (1257717), maar geen Frost Orb en geen duur-cijfer. MEASURED (0 treffers op "Frost Orb" in de
    Nymrissa-tips specifiek — het spell-ID 1313448 in `Modules/HazardData.lua:234` is alleen een
    glow-registratie, geen tekstclaim). **[RAAKT ONS NIET]**
  - **1 sep — Murder Row, Xathuux the Annihilator:** Axe Toss deed soms te weinig schade, nu
    gefixed. `DGN_TIP_MR_XATHUUX_STEPS` (`Locales/DungeonTips.lua:82`) noemt drie andere spell-
    ID's (1214637, 474197, 473898 = Legion Strike) — "Axe Toss" komt nergens voor. MEASURED.
    **[RAAKT ONS NIET]**
  - **1 sep — Item: Satchel of Corrosive Coins (verkocht door Er'iyne) is niet meer uniek.** Geen
    van beide namen staat ergens in de repo (0 treffers, tegen de Corrosive-Coin-positieve-
    controle hierboven). MEASURED. **[RAAKT ONS NIET]**
  - **1 sep — Quests: Midnight World Quests gaven geen Adventurer Crests; gefixed.** "Adventurer
    Crest" staat nergens in de repo (0 treffers, tegen de crest-positieve-controle hierboven) —
    we claimen nergens welke crest een world quest geeft. MEASURED. **[RAAKT ONS NIET]**
  - **1 sep — Delves: "Trinkets no longer drop as abundantly."** Generieke drop-rate-uitspraak,
    geen delve of tier genoemd. Alle "trinket"-treffers in de repo zijn keybind-uitrustingsslots
    (`INVTYPE_TRINKET`) of cooldown-tracker-entries — geen enkele claimt een droprate. MEASURED.
    **[RAAKT ONS NIET]**
  - **Klassen- en PvP-balans (beide lijsten, tientallen % op schade/genezing/kosten, o.a. Frost
    DK, Vengeance DH, Feral Druid, Mistweaver, Protection Paladin, Assassination Rogue, Farseer
    Shaman):** Midnight Helper volgt geen rotatie- of balanscijfers — de klassemodules
    (`HealerCooldowns.lua`, `TankToolkit.lua`, `KeybindRoles_*.lua`) registreren alleen spell-ID's
    voor keybind-layout en cooldown-alerts (bv. Swiftmend 18562, Fel Devastation 212084), zonder
    schade- of genezingspercentage te claimen. Steekproef MEASURED op vijf genoemde spells (Fel
    Devastation, Swiftmend, Blaze of Glory, Preemptive Maneuver, Howling Blast) bevestigt dit;
    voor de rest INFERRED uit de bekende scope van deze addon. **[RAAKT ONS NIET]**
  - **Overig zonder addon-claim:** Den of Nalorakk (Food Offering-mount-bug), PvP Training
    Grounds-interruptquest-credit-bug — geen van beide staat in onze data. **[RAAKT ONS NIET]**

  Bron: Exa `web_fetch_exa` op de Wowhead Blue Tracker-spiegels van news.blizzard.com's
  "Hotfixes: September 1, 2026" en "Hotfixes: August 31, 2026" (volledige artikeltekst gelezen,
  niet alleen samenvatting); WebSearch ter bevestiging dat er nog geen lijst van 2 sep is.
  Codebase-kant: `grep` (case-insensitive, hele repo, niet beperkt tot een bestandenlijst) op alle
  hierboven genoemde ability-, item- en questnamen, plus gerichte reads van `Locales/RaidTips.lua`,
  `Locales/RitualTips.lua`, `Locales/DungeonTips.lua`, `Locales/DelveStoryData.lua`,
  `Modules/RaidCoachData.lua`, `Modules/HazardData.lua`, `Modules/Openables.lua`,
  `Modules/VaultAdvisor.lua`, `Modules/HealerCooldowns.lua`, `Modules/TankToolkit.lua` — allemaal
  vandaag gelezen. **[RAAKT ONS NIET]** — geen van de gevonden hotfixes spreekt een geshipte claim
  tegen. Geen open actiepunt.

---

- [2026-09-03] ✅ **Geen tegenspraak gevonden op de hotfixes van 2 sep; voor 3 sep is er nog
  niets gepubliceerd** — dat laatste is "heeft nog niet gedraaid", niet "niets gevonden".
  `news.blizzard.com` gaf op WebFetch weer `EGRESS_BLOCKED`; via Exa `web_fetch_exa` is
  `https://news.blizzard.com/en-us/article/24296142/hotfixes-september-2-2026` **volledig zelf
  gelezen** (niet alleen een samenvatting) — dit is Blizzard's doorlopende hotfix-artikel, sectie
  "September 2, 2026". Een poging op een expliciete "...-september-3-2026"-URL gaf dezelfde 2-sep-
  inhoud terug (geen 404 gezien, dus geen 100% bewijs dat 3 sep niet bestaat) en een gerichte
  Exa-zoekopdracht op de exacte titel "Hotfixes: September 3, 2026" gaf nul resultaten. Beide
  samen: MEASURED dat er voor 3 sep nog niets gevonden kán worden, niet een garantie dat het nooit
  komt.

  **Sectie "September 2, 2026" (Delves/Professions/Quests: leeg — Blizzard laat lege categorieën
  gewoon weg; Dungeons and Raids en Items volledig gelezen):**
  - **The Venomous Abyss → Ula'tek:** Soul Constrictor-duur naar 5s op Mythic; Blight Vein-schade
    -25% op Mythic (een vervolg-tuning op de Blight Vein-*bug* die al op 31 aug gefixed was — dit
    is een apart, nieuw balans-hotfix, geen duplicaat); een Doomscale Egg kon nog opgeraapt worden
    nadat Ravenous Doomscale spawnt terwijl Doomscale Warden nog leeft, plus extra bescherming
    tegen dubbel oprapen van één ei. Onze `RAID_BOSS_ULATEK_STEPS` (`Locales/RaidTips.lua:46`,
    en de zes vertaalde varianten) noemt vier spell-ID's (1292403, 1287265, 1286860 "Venomous
    Heart", 1290779) generiek zonder namen — "Soul Constrictor", "Blight Vein", "Doomscale Egg",
    "Ravenous Doomscale" en "Doomscale Warden" komen er niet in voor. MEASURED (0 treffers op alle
    vijf namen in `Locales/RaidTips.lua` en repo-breed; positieve controle: dezelfde repo-brede
    zoekvorm vond "Doomscale Warden" wel terug als encounter-NPC-ID-lijst in
    `docs/PTR_S2_ENCOUNTERS.md:79` en "Blight Vein" in deze eigen watch-historie — het patroon
    werkt dus op deze schaal). **[RAAKT ONS NIET]**
  - **Items:** resterende Great-Vault-items die niet met de Catalyst te converteren waren, gefixed;
    een bug waarbij bepaalde non-armor-items ten onrechte als Catalyst-converteerbaar leken,
    gefixed (relog kan nodig zijn). Onze Catalyst-tekst (`Locales/enUS.lua:1086-1095,1725-1726`,
    `Modules/TierSet.lua` — o.a. `TIER_CATALYST_NAME`, `SetCatalystWaypoint`) legt alleen de
    algemene mechaniek uit (stat-behoud, 8 charges per personage, waypoint naar de locatie) en
    claimt nergens *welke* itemtypes of -bronnen wel/niet converteerbaar zijn. MEASURED: 0
    treffers op "convert"/"vault"/"armor" (case-insensitive) in `Modules/TierSet.lua` en
    `Modules/VaultAdvisor.lua`, tegen een in dezelfde bestanden geslaagde positieve controle
    (`function`/`local`/`ns.` matcht daar gewoon). **[RAAKT ONS NIET]**

  Bron: Exa `web_fetch_exa`, volledige artikeltekst van news.blizzard.com's "Hotfixes: September 2,
  2026" (sectie 2 sep zelf gelezen; sectie 1 sep in hetzelfde artikel was al afgedekt in de vorige
  entry en niet opnieuw volledig herlezen). Exa `web_search_exa` om het ontbreken van een 3-sep-
  artikel te bevestigen. Codebase-kant: `grep` case-insensitive over de hele repo op alle hotfix-
  termen hierboven, plus gerichte reads van `Locales/RaidTips.lua`, `Locales/enUS.lua`,
  `Modules/TierSet.lua`, `Modules/VaultAdvisor.lua`, `Modules/HazardData.lua`,
  `docs/PTR_S2_ENCOUNTERS.md` — allemaal vandaag gelezen. **[RAAKT ONS NIET]** — geen van de
  gevonden hotfixes spreekt een geshipte claim tegen. Geen open actiepunt; 3-sep-hotfixes volgen
  in een volgende run zodra ze gepubliceerd zijn.

---

- [2026-09-04] ✅ **Hotfixes van 3 sep gelezen (nieuw sinds gisteren) — één zachte match met een
  al bekende open vraag, verder geen tegenspraak.** `news.blizzard.com` gaf op WebFetch niet
  geprobeerd; direct via Exa `web_fetch_exa` met `?nocache=20260904` op de doorlopende
  hotfix-URL — **volledige artikeltekst zelf gelezen**, sectie "September 3, 2026" bovenaan (dus
  nieuwer dan de "September 2, 2026"-sectie die gisteren als nieuwste gold — geen cache-probleem).
  Delves en Professions: **leeg** in de 3-sep-sectie (Blizzard laat lege categorieën gewoon weg,
  net als eerdere dagen) — niets om te vergelijken. Achievements, Classes, Dungeons and Raids,
  Items, Quests: volledig gelezen.

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -ri "Ruby Life
  Pools"` geeft treffers in `Modules/DungeonRosterData.lua:280`, `Modules/FlightNetworkData.lua:95`,
  `Modules/FlightPointsData.lua:844` en meerdere docs; `grep -ri Guillotine` geeft treffers in
  `Locales/RaidTips.lua` (7×, alle taalvarianten), `Modules/RaidCoachData.lua:139` en
  `Modules/TeamMacrosData.lua:600-605`. Beide patronen werken dus op deze schaal — de 0-treffers
  verderop zijn gemeten afwezigheid.

  **Bevindingen:**
  - **Achievements — Spark in the Night gaf geen credit voor de Sparks-of-War-quest bij afronding
    in Coiled Isle, Val of Naigtal; nu gefixed.** Dit is al gelogd als kandidaat-feit door de
    data-wachter (`docs/PTR_12.0.7_DATA.md`, entry [2026-09-04], achievementID 61465 via Wowhead)
    — dat is zijn lane, niet de mijne, dus ik herhaal het feit niet. Wat wél mijn lane is: raakt dit
    een geshipte claim? **Bijna.** `Modules/Showdowns.lua:24-41` citeert zelf al een oudere hotfix
    (13 aug, verbatim: "The Naigtal and Val Sparks of War quests will no longer be offered when
    Season 2 begins") en zet er zelf een vraagteken bij: "WHICH QUESTS ARE MEANT IS NOT SETTLED" —
    wij shippen Showdown on Naigtal/Val (96717/96718/96713) als vermoedelijke match, expliciet als
    "likely, not measured". De 3-sep-hotfix noemt nu een **derde zone, Coiled Isle**, die in onze
    eigen 13-aug-quote niet voorkwam. Dat spreekt onze tekst niet tegen (we claimen zelf al niet
    meer dan "likely"), maar het is wel een nieuw gegeven dat relevant is voor precies de vraag die
    daar openstaat. MEASURED (citaat hierboven uit `Modules/Showdowns.lua:24-27,39-41` gelezen).
    **[RAAKT ONS]** — geen actie nodig, maar Rob/wie
    `Showdowns.lua`'s open vraag oppakt kan deze derde zone meenemen.
  - **Classes — Priest Holy (Renew/Renewed Vigor 2-set) en Shaman Restoration Totemic (Oversurge)
    fixes.** Pure spec-balans/mechaniek-fixes op class-kant; Midnight Helper volgt geen rotatie- of
    setbonus-gedrag (gevestigd patroon, zie eerdere entries). **[RAAKT ONS NIET]**
  - **Dungeons and Raids — Ruby Life Pools:** de Radiant Drake entrance-return-NPC verscheen niet
    in Mythic+ na de eindbaas; nu gefixed. Onze drie treffers op "Ruby Life Pools" zijn een
    dungeon-roster-naam, een flight-network-node en flightpoint-coördinaten — geen enkele claimt
    iets over NPC-gedrag na de eindbaas. MEASURED (0 treffers op "Radiant Drake" repo-breed).
    **[RAAKT ONS NIET]**
  - **Dungeons and Raids — The Venomous Abyss → Ula'tek:** Caustic Waves kunnen niet meer ontweken
    worden door eronderdoor te zwemmen; een fout in de Blight Vein-spellbeschrijving (verkeerde
    schadewaarde in de tooltip) gecorrigeerd. `RAID_BOSS_ULATEK_STEPS` (`Locales/RaidTips.lua:46`,
    zes taalvarianten) noemt vier andere spell-ID's zonder namen en zegt niets over zwemmen of een
    schadewaarde. MEASURED (0 treffers op "Caustic Waves" repo-breed). **[RAAKT ONS NIET]**
  - **Items — Zul'jin's Guillotine Technique (trinket), effect Perfected Guillotine:** target niet
    langer vijanden buiten combat voor het tweede doelwit. ⚠️ Naamcollision gecontroleerd: onze
    "Guillotine"-treffers zijn allemaal de Coiled-Altar-boss-mechaniek (Zul'jan-encounter,
    `RAID_BOSS_COILEDALTAR_STEPS`) of een macro-template (`Modules/TeamMacrosData.lua:600-605`,
    generieke `/cast [@cursor] Guillotine` voor eigen class-abilities) — geen ervan is deze trinket.
    MEASURED. **[RAAKT ONS NIET]**
  - **Quests — The Darkwell blijft nu staan voor characters die "War of Light and Shadow" niet
    hebben afgerond maar wel de Arator-quests van "Curse of Ula'tek" hebben voltooid.** Ook al
    gelogd als kandidaat-feit door de data-wachter (`docs/PTR_12.0.7_DATA.md`, entry [2026-09-04]).
    Voor mijn lane: ⚠️ naamcollision gecontroleerd en bevestigd geen overlap — de enige "Darkwell"
    in de repo is `RAID_BOSS_LURA_STEPS` (`Locales/RaidTips.lua:91`, zeven taalvarianten): "The
    Darkwell in the center is instant death" tijdens de L'ura-fight in March on Quel'Danas. Andere
    content, andere betekenis van dezelfde naam. `Modules/CampaignLeadIn.lua` kent "War of Light
    and Shadow" en de Arator-keten wel bij naam maar claimt nergens iets over een wereldobject dat
    wel/niet blijft staan — dus geen tegenspraak, wel dezelfde open kandidaat die de data-wachter al
    noemde. MEASURED. **[RAAKT ONS NIET]**

  Bron: Exa `web_fetch_exa` met cache-buster op news.blizzard.com's doorlopende hotfix-artikel,
  sectie "September 3, 2026" volledig gelezen. Codebase-kant: `grep` case-insensitive over de hele
  repo op alle hierboven genoemde namen, plus gerichte reads van `Modules/Showdowns.lua`,
  `Modules/ResetRoutine.lua`, `Locales/RaidTips.lua`, `Modules/RaidCoachData.lua`,
  `Modules/TeamMacrosData.lua`, `Modules/GearEnchantCheck.lua`, `Modules/CampaignLeadIn.lua`,
  `Modules/DungeonRosterData.lua`, `Modules/FlightNetworkData.lua`,
  `Modules/FlightPointsData.lua` — allemaal vandaag gelezen. **[RAAKT ONS NIET]**, op één zachte
  [RAAKT ONS] na (Sparks-of-War/Coiled-Isle, hierboven) die geen bestaande claim tegenspreekt maar
  wel een al openstaande vraag in `Showdowns.lua` raakt. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

- [2026-09-05] ✅ **Hotfixes van 4 sep gelezen (nieuw sinds gisteren) — geen tegenspraak, één
  onbeslisbare op ID-niveau.** `news.blizzard.com` gaf op WebFetch weer `EGRESS_BLOCKED`; via Exa
  `web_fetch_exa` met `?nocache=20260905` op de doorlopende hotfix-URL **volledige artikeltekst
  zelf gelezen** — sectie "September 4, 2026" bovenaan, dus nieuwer dan de "September 3"-sectie
  die gisteren als nieuwste gold (geen cache-probleem; ook de API- en data-wachter zagen vandaag
  dezelfde 4-sep-sectie als nieuwste). Delves, Professions en Quests: **leeg** in de 4-sep-sectie
  — niets om te vergelijken. Classes, Dungeons and Raid, Housing, Items: volledig gelezen.

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -rin "Wondrous
  Synergist"` geeft een treffer in `Locales/enUS.lua:948` (en de vertaalde varianten) — een echte
  item-naam wordt op deze schaal gevonden. De 0-treffers hieronder zijn dus gemeten afwezigheid,
  niet een grep die niets kan vinden.

  **Bevindingen:**
  - **Dungeons and Raids — The Venomous Abyss → Ula'tek: "Fixed an issue where applications of
    Ingested Venom could apply on a target affected by Serpent's Bite."** ⚠️ **Dit is niet met
    een naam-grep te beslissen.** `RAID_BOSS_ULATEK_STEPS` (`Locales/RaidTips.lua:51`, zeven
    taalvarianten) noemt uitsluitend kale `{SPELL:id}`-links ("Soak {SPELL:1300530} en
    {SPELL:1299757} — maar niet terwijl je {SPELL:1300685} draagt") — geen van die ID's staat
    ergens anders in de repo met een naam erbij (`grep` op alle vijf ID's: 0 treffers buiten
    `RaidTips.lua` zelf), dus ik kan niet vaststellen of Ingested Venom/Serpent's Bite een van
    deze soak-mechanieken IS. Geen ID gegokt. MEASURED dat de vraag onbeslisbaar is met wat in de
    repo staat; INFERRED dat het toch waarschijnlijk geen tekst-wijziging vereist, want (a) dit is
    een bugfix op een overlap-edge-case, geen mechaniek-herontwerp, en (b) `Modules/RaidCoachData.lua:117`
    zegt al expliciet "NOBODY HERE HAS DONE THESE FIGHTS" en `RAID_PRERELEASE_NOTE`
    (`Locales/RaidTips.lua:31`, nog steeds ongated aanwezig, `Modules/RaidGuide.lua:67`) toont bij
    Ula'tek al de waarschuwing "written before the raid opened … verify against the fight" — deze
    hotfix valt dus binnen een risico dat we al hardop benoemen, niet een nieuw gat. **[RAAKT ONS
    NIET]** als actiepunt vandaag, maar geen bevestigde non-match — wie deze fight ooit natoetst
    kan deze twee soak-ID's meteen meenemen.
  - **Housing — Endeavors → Vacation Season: Secret Souvenir-verzamelen kon achievement-credit
    missen; retroactief hersteld.** 0 treffers op "Secret Souvenir" of "Vacation Season" repo-breed;
    de enige "housing"-treffers in `Locales/enUS.lua`/`nlNL.lua` gaan over housing-decor als
    beloning (Ritual-renown, profession-goud-gids) — geen enkele over achievement-tracking. Ook al
    los bevestigd door de data-wachter (`docs/PTR_12.0.7_DATA.md`, entry [2026-09-05]) vanuit zijn
    eigen lane; dit is mijn onafhankelijke contradictie-check, geen doublure van zijn feit.
    MEASURED. **[RAAKT ONS NIET]**
  - **Items — vijfde catalyst-fix (spiegelrichting): niet-set class-armor leek ten onrechte wél
    (opnieuw) catalyseerbaar.** Ook al gelogd als feit door de data-wachter. Voor mijn lane:
    `TierSet.lua`/`OmniumFolio.lua`/`AccountWeeklyChecklist.lua` (alle drie gegrept op "catalyst")
    hardcoden geen eigen lijst van welke items catalyseerbaar zijn — ze wijzen naar de
    Catalyst-locatie en laten de client zelf tonen wat in aanmerking komt. Een UI-bug in die
    lijst raakt dus geen bewering die wíj doen. MEASURED. **[RAAKT ONS NIET]**
  - **Items — Preternatural Antivenom trinket: absorb-cap en genezingspercentage voor healers
    waren te laag, nu gecorrigeerd.** 0 treffers op "Preternatural" of "Antivenom" repo-breed.
    MEASURED. **[RAAKT ONS NIET]**
  - **Classes — Druid Balance (Stellar Amplification, Twin Moons-range) en Shaman Enhancement
    (Venomous Abyss 4-set/Crash Lightning) fixes.** Pure spec-balans, gevestigd patroon dat MH
    niet volgt. **[RAAKT ONS NIET]**

  Bron: Exa `web_fetch_exa` met cache-buster op news.blizzard.com's doorlopende hotfix-artikel,
  sectie "September 4, 2026" volledig gelezen. Codebase-kant: `grep` case-insensitive over de hele
  repo op alle hierboven genoemde namen en spell-ID's, plus gerichte reads van
  `Modules/RaidCoachData.lua`, `Locales/RaidTips.lua`, `Modules/RaidGuide.lua`,
  `Modules/TierSet.lua`, `Modules/OmniumFolio.lua`, `Modules/AccountWeeklyChecklist.lua` —
  allemaal vandaag gelezen. **[RAAKT ONS NIET]** op alle vijf bevindingen, met één expliciete
  kanttekening (Ula'tek soak-ID's) die onbeslisbaar blijft zolang niemand de fight loopt. Geen
  actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

- [2026-09-06] 🔁 **Niets nieuws sinds 4 sep — zelf opnieuw gemeten, niet uit een andere log
  overgenomen.** Vorige entry (5 sep) dekte de hotfixes van 4 sep volledig (Classes, Dungeons and
  Raid, Housing, Items gelezen; Delves/Professions/Quests waren toen al leeg). Vandaag: `Exa
  web_fetch_exa` op `news.blizzard.com/en-us/article/24296142?nocache=20260906`, **volledige
  artikeltekst zelf gelezen** — "September 4, 2026" staat nog steeds bovenaan als nieuwste sectie,
  byte-voor-byte dezelfde vier categorieën als op 5 sep gelogd. Onafhankelijk gecontroleerd met
  `web_search_exa` op "hotfixes September 5/6 2026": geen artikel met die datum bestaat, het
  nieuwste gevonden hotfix-artikel is en blijft "Hotfixes: September 4, 2026"
  (news.blizzard.com/.../hotfixes-september-4-2026, secundair bevestigd door een mmos.com-stuk
  gedateerd 5 sep dat dezelfde 4-sep-lijst samenvat). **Positieve controle op de cache-val
  zelf:** dezelfde zoekmethode vindt zonder moeite de aparte artikelen voor 1, 2, 3 én 4 september
  — dus de zoekopdracht kan wél nieuwe datums vinden, en het ontbreken van 5/6 sep is een echte
  afwezigheid, geen kapotte query. Dit dekt zich bovendien met wat de API-, PTR- en data-wachter
  vandaag onafhankelijk van elkaar en van mij vonden (allen: nieuwste hotfixsectie nog steeds 4
  sep) — geconvergeerde metingen, geen citaat van hun log.
  Extra zoekpogingen op blue posts over Delves/beroepen/quests sinds 4 sep leverden alleen ruis op
  (oude forumthreads uit eerdere patches, en het 12.1.5-PTR-overzicht — dat laatste is expliciet
  `docs/PTR_12.1_WATCH.md`'s terrein, niet het mijne, dus niet meegenomen). MEASURED: geen nieuwe
  hotfix-sectie. MEASURED: Delves/Professions/Quests waren en zijn leeg in de nieuwste sectie, dus
  niets om tegen de repo te toetsen. Geen enkele bevinding vandaag. **[RAAKT ONS NIET]** —
  bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260906 (volledig gelezen via
  Exa) · web_search_exa "hotfixes September 5/6 2026" (geen resultaat nieuwer dan 4 sep).
