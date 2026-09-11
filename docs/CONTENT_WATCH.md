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

---

- [2026-09-07] 🔁 **Nog steeds niets nieuws sinds 4 sep — dag 3 op rij, opnieuw zelf gemeten.**
  `Exa web_fetch_exa` op `news.blizzard.com/en-us/article/24296142?nocache=20260907`, **volledige
  artikeltekst zelf gelezen** — "September 4, 2026" staat nog steeds bovenaan, byte-voor-byte
  dezelfde vier categorieën (Classes, Dungeons and Raid, Housing, Items) als op 5 en 6 sep gelogd;
  Delves/Professions/Quests blijven leeg. Twee losse cache-vallen expliciet getest: de URL's
  `.../hotfixes-september-6-2026?nocache=20260907` en `.../hotfixes-september-7-2026?nocache=20260907`
  geven **beide** gewoon de 4-sep-inhoud terug (Blizzard's server, geen doorverwijzing/404) — dus
  het gissen van een datum in de URL bewijst niets, alleen het doorlopende artikel telt.
  **Positieve controle:** `web_search_exa` op "Hotfixes: September 6/7, 2026" vindt voor
  news.blizzard.com niets nieuwers dan 4 sep, maar vindt wél een bluetracker.gg-artikel
  "Hotfixes: September 7" — bij lezing bleek dat over **WoW: Legion** te gaan (classic-realm,
  Demon Hunter Sigils/Discipline Priest artifact traits/Assault on Violet Hold), niet over
  Midnight/12.1. Ruis, niet een gemiste retail-hotfix; dezelfde zoekmethode vindt dus wél
  content, wat bevestigt dat het ontbreken van een retail 5/6/7-sep-artikel een echte afwezigheid
  is en geen kapotte query. Secundair bevestigd door MMO-Champion (gepubliceerd 5 sep, vat exact
  de 4-sep-lijst samen, niets nieuwers). Dit convergeert met wat de API-, PTR- en data-wachter
  vandaag (7 sep) elk apart al vonden — zie hun eigen commits van vandaag, niet hier geciteerd.
  MEASURED: geen nieuwe hotfix-sectie sinds 4 sep. Geen codebase-vergelijking nodig — er is niets
  nieuws om tegen te toetsen. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260907 (volledig gelezen via Exa) ·
  web_search_exa "Hotfixes: September 6/7, 2026" (nieuwste retail-treffer blijft 4 sep).

---

- [2026-09-08] 🔁 **Dag 4 zonder nieuwe hotfix-sectie — één nieuwe bron gecheckt, geen tegenspraak.**
  `Exa web_fetch_exa` op `news.blizzard.com/en-us/article/24296142?nocache=20260908b`, **volledige
  artikeltekst zelf gelezen**: "September 4, 2026" staat nog steeds bovenaan, secties 1-4 sep
  byte-voor-byte gelijk aan wat al gelogd staat. Dit convergeert met de data-wachter van vandaag
  (`docs/PTR_12.0.7_DATA.md`, entry [2026-09-08]: dezelfde sectie, dubbel geverifieerd tegen twee
  onafhankelijke bronnen) en de API-wachter (geen API-wijzigingen) — niet overgenomen, zelf opnieuw
  gelezen.

  **Nieuwe bron dit run, aangedragen door de PTR-wachter:** diens entry van vandaag noemt een
  Blizzard "WoW Weekly"-verzamelartikel (24298589) met het punt *"The Venomous Abyss Raid Finder
  Wing 3 Now Live"*, en merkt terecht op dat een live-contentstatus in mijn lane hoort, niet de
  zijne. Zelf gelezen: het artikel zegt alleen dat LFR-wing 3 van The Venomous Abyss nu open is —
  geen bossnamen, geen datum, geen mechaniekwijziging, gewoon de reguliere wekelijkse wing-rotatie.
  Getoetst tegen `Modules/RaidCoachData.lua`, `Locales/RaidTips.lua` en `Modules/RaidGuide.lua`
  (alle drie gegrept op `LFR`/`wing`/`Raid Finder`, alle drie vandaag gelezen): geen van de drie
  claimt iets over wélke wing wélke bosses bevat of wanneer een wing opengaat — de vaste bosvolgorde
  daar gaat over encounter-volgorde binnen de raid, niet over LFR-wing-indeling. Niets om tegen te
  spreken. MEASURED. **[RAAKT ONS NIET]**

  📌 **Zijspoor in de eigen methode, het melden waard.** De eerste grep (`\bLFR\b` zonder
  woordgrens) gaf 86 bestanden terug; bijna alle "treffers" bleken `ScrollFrame` te zijn
  (`...rollFrame` bevat toevallig de letters `lFr` op een rij) — een vals-positief door de
  substring, niet door een kapotte zoekvorm. Met `\bLFR\b` (woordgrens) daalde dat naar de échte
  treffers: `Locales/OmniumFolio.lua` (wekelijkse Folio-doel "LFR wing boss", alle zeven talen) en
  meerdere `ACADEMY_*_RAID_*`-teksten in `ptBR.lua`/`nlNL.lua`/`itIT.lua`. Dat is meteen de
  positieve controle op dezelfde repo-brede scope als de claim hierboven: het patroon vindt LFR
  waar het echt staat, dus de 0 treffers in de drie raid-bestanden zijn gemeten afwezigheid.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260908b (volledig gelezen via
  Exa) · https://news.blizzard.com/en-us/article/24298589/blizzcon-2026-midnight-12-1-5-and-more-in-this-weeks-wow-weekly?nocache=20260908c
  (volledig gelezen via Exa).

---

- [2026-09-09] 🔁 **Dag 5 zonder nieuwe hotfix-sectie — dus geen nieuwe hotfix-vergelijking; wel
  twee live-events gecheckt op tegenspraak, geen gevonden.** `Exa web_fetch_exa` met
  `?nocache=20260909d` op news.blizzard.com's doorlopende hotfix-artikel, **volledige artikeltekst
  zelf gelezen**: "September 4, 2026" staat nog steeds bovenaan, Classes/Dungeons and Raid/
  Housing/Items byte-voor-byte gelijk aan wat al in [2026-09-05] gelogd staat. Delves/Professions/
  Quests waren en zijn leeg in die sectie. **Positieve controle:** een losse `web_search_exa` op
  dezelfde pagina geeft zijn eigen gepubliceerde titel/datum ongewijzigd terug — geen cache-val.
  Dit is dag 5 op rij zonder nieuwe hotfix-sectie, convergerend met de API- en PTR-wachter van
  vandaag (beiden ook nog op 4 sep). Niets nieuws om tegen de repo te toetsen op hotfix-vlak.

  **Twee live-events, aangedragen door de data-wachter van vandaag (`docs/PTR_12.0.7_DATA.md`,
  entries [2026-09-09]), zelf getoetst op tegenspraak — dat is mijn vraag, niet de zijne:**
  - **Winds of Mysterious Fortune (wereldevent, 8 t/m 22/23 sep):** +50% reputatie op vrijwel alle
    facties, **expliciet uitgezonderd Zul'jarra's Forces en Captain Tokka's Crew**. Relevant omdat
    een verkeerde MH-tekst hier zou kunnen claimen dat de renowngrind voor Zul'jarra's Forces
    versneld is tijdens het event. `grep -i "Zul'jarra's Forces"` (repo-breed): treffers in
    `Modules/MountProgress.lua:119` en `Modules/CorrosiveCodexHunts.lua:290` — beide noemen alleen
    Renown-drempels/node-zichtbaarheid, geen van beide claimt een reputatie-tempo of een
    eventbonus. Geen enkele treffer op "Winds of Mysterious Fortune"/"Mysterious Fortune" zelf.
    MEASURED. **[RAAKT ONS NIET]**
  - **Midnight Dungeon Event (weekly, "voltooi 4 dungeons op Mythic voor een Heroic Cache of
    Amani Treasures"):** 0 treffers op "Dungeon Event" of "Amani Treasures" repo-breed — dit
    bestaat nog nergens in MH, dus er is niets om tegen te spreken (het is een ontbrekend stuk
    content, geen tegenspraak — Rob beslist of het de moeite waard is om te bouwen). MEASURED.
    **[RAAKT ONS NIET]**
  - 📌 **Positieve controle voor beide greps, zelfde repo-brede scope:** `grep -i "Trader's
    Tender"` geeft treffers in `Modules/TradingPost.lua:2,13,19` (currency 2032) — het patroon
    vindt dus wél iets op deze schaal wanneer het er is; de 0-treffers hierboven zijn gemeten
    afwezigheid.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260909d (volledig gelezen via
  Exa, hotfixkant) · `docs/PTR_12.0.7_DATA.md` entries [2026-09-09] als aanleiding voor de twee
  live-events (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte MH-tekst) ·
  codebase: `grep` case-insensitive repo-breed op alle bovengenoemde termen, plus gerichte reads
  van `Modules/MountProgress.lua`, `Modules/CorrosiveCodexHunts.lua`, `Modules/TradingPost.lua`,
  `Modules/EventScheduler.lua` — allemaal vandaag gelezen. **[RAAKT ONS NIET]** op alle punten.
  Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-09-10] ⚠️ **Nieuwe sectie "September 9, 2026" (eerste sinds 4 sep) — één geldige tekstuele
  tegenspraak-kandidaat op Ula'tek, verder geen tegenspraak.** `Exa web_fetch_exa` met
  `?nocache=20260910` op news.blizzard.com's doorlopende hotfix-artikel, **volledige artikeltekst
  zelf gelezen**: sectie "September 9, 2026" staat nu bovenaan, dus nieuwer dan de "September 4"-
  sectie die vijf dagen op rij ([2026-09-05] t/m [2026-09-09]) de nieuwste was — geen cache-val,
  gewoon nieuwe content. Onafhankelijk bevestigd door `web_search_exa`: een consolepcgaming.com-
  artikel gepubliceerd 10 sep citeert dezelfde 9-sep-hotfixlijst woordelijk. Categorieën in de
  9-sep-sectie: Achievements, Classes, Delves, Dungeons and Raids, Items, Player versus PvP, Prey,
  The Burning Crusade Classic (ander spel, niet retail — genegeerd). **Professions en Quests: leeg**
  in deze sectie (Blizzard laat lege categorieën gewoon weg, zelfde patroon als eerdere dagen) —
  niets om te vergelijken.

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -ri "Entombed
  Sentinels"` geeft treffers in `Modules/RaidCoachData.lua:90` en `docs/PTR_S2_ENCOUNTERS.md:73`;
  `grep -ri "Sentinel of Winter"` geeft een treffer in `Modules/DungeonRosterData.lua:121`. Beide
  patronen vinden dus iets op deze schaal — de 0-treffers verderop zijn gemeten afwezigheid.

  **Bevindingen:**
  - **Achievements — Soft Underbelly is nu account-wide.** Wij tracken achievementID 62601 zelf
    (`Modules/AchievementsData.lua:173`) puur als coördinaten-/checklist-node-lijst, gelezen live
    via `GetAchievementCriteriaInfo` (client-side, dus automatisch account-wide-bewust) — nergens
    claimen we dat voortgang per personage apart telt. MEASURED (`Modules/AchievementsData.lua:93,
    160-179`, `Modules/Achievements.lua:93-99` gelezen). **[RAAKT ONS NIET]**
  - **Delves — Bountiful Coffers gaven geen Zul'jarra's Forces-reputatie; nu gefixed.** Onze
    Bountiful-Coffer-tekst (`Modules/Delves.lua:774-780`) gaat over gear-tier/track-cijfers (Trove-
    hunter's Bounty, Champion/Hero-tracks), niet over welke factie-reputatie de coffer geeft. Onze
    Zul'jarra's-Forces-treffers (`Modules/MountProgress.lua:119`, `Modules/CorrosiveCodexHunts.lua:290`,
    beide eerder gemeten) gaan over Renown-drempels voor mounts/achievements, niet over de coffer als
    rep-bron. MEASURED (0 treffers op "Bountiful Coffer" + "reputation"/"reputatie" in dezelfde zin,
    repo-breed). **[RAAKT ONS NIET]**
  - **Dungeons and Raids — Den of Nalorakk: player pets konden The Winter Squall niet beschadigen;
    nu gefixed.** ⚠️ Naamcollision gecontroleerd: "The Winter Squall" zelf staat 0× in de repo. De
    boss heet bij ons "Sentinel of Winter" (`Modules/DungeonRosterData.lua:121`) met de ability
    "Raging Squalls" ({SPELL:1235623}, `Locales/DungeonTips.lua:95` + 6 taalvarianten) — vermoedelijk
    dezelfde encounter onder een andere naam voor een add/verschijning, maar niet met zekerheid
    dezelfde entiteit. Onze tip zegt alleen "weef eromheen" (ontwijken), claimt niets over pets die
    hem wel/niet kunnen beschadigen — dus geen tekstuele tegenspraak, wel INFERRED dezelfde
    encounter. **[RAAKT ONS NIET]**
  - **Dungeons and Raids — The Venomous Abyss, Entombed Sentinels: Toxic Droplets stonden niet meer
    direct te ontploffen bij landen op een speler; Living Venom doorbreekt geen immuniteiten meer.**
    ⚠️ **Niet met een naam-grep te beslissen, zelfde situatie als de Ula'tek-soak-ID's uit
    [2026-09-05].** `RAID_BOSS_ENTOMBEDSENT_STEPS` (`Locales/RaidTips.lua:36-38`, zeven
    taalvarianten) noemt uitsluitend kale `{SPELL:id}`-links (1284588 stack-puzzel, 1288232
    group-soak, 1284251 grote adds, 1296878 Mythic-kleurwissel, 1284458/1284487 tank-swap, 1284483
    healer-dispel) — geen van die ID's staat ergens anders in de repo met een naam erbij, dus ik kan
    niet vaststellen of "Toxic Droplets" of "Living Venom" een van deze mechanieken IS. MEASURED dat
    de vraag onbeslisbaar is met wat in de repo staat. **[RAAKT ONS NIET]** als actiepunt vandaag,
    geen bevestigde non-match.
  - **Dungeons and Raids — The Venomous Abyss, The Lost Explorers: Hoji teleporteert nu terug naar
    het hoofdplatform als hij van de brug valt.** "Hoji" staat 0× in `Locales/`/`Modules/` (enige
    twee repo-treffers zijn in `docs/PTR_12.1_WATCH.md` en `docs/PTR_12.0.7_DATA.md`, niet in
    geshipte tekst). `RAID_BOSS_LOSTEXPLORERS_STEPS` (`Locales/RaidTips.lua:39`) gaat over interrupt,
    vloer-ontwijken en Tortollan-bezetenheid — geen brug, geen Hoji. Dit is een unstuck-fix, geen
    mechaniek die wij beschrijven. MEASURED. **[RAAKT ONS NIET]**
  - **🔴 Dungeons and Raids — The Venomous Abyss, Ula'tek: health-backstops toegevoegd zodat de boss
    "Rage of the Shackled" verlaat bij specifieke health-drempels.** "Rage of the Shackled" staat 0×
    in de repo — geen bevestigde naam-match. Maar `RAID_BOSS_ULATEK_STEPS` (`Locales/RaidTips.lua:51`,
    zeven taalvarianten) sluit zelf af met: "{SPELL:1286905} in de laatste fase is de soft enrage —
    **die stopt niet**." Als "Rage of the Shackled" dezelfde fase is als die soft enrage (aannemelijk
    qua naam en positie: laatste fase, een rage-mechaniek), dan zegt Blizzards hotfix nu juist dat de
    boss die fase ONDER bepaalde health-drempels wél verlaat — het tegenovergestelde van "stopt niet".
    ⚠️ Ik los deze ambiguïteit niet zelf op: spell-ID 1286905 staat nergens anders in de repo met een
    naam erbij, dus ik kan de identiteit niet bevestigen, en "stopt niet" kan ook alleen op de
    damage-toename slaan (blijft doorschalen) in plaats van op de fase zelf, wat geen tegenspraak zou
    zijn. MEASURED dat de vraag openstaat; INFERRED dat het de moeite waard is om na te trekken.
    **[RAAKT ONS]** — geen bevestigde tegenspraak, wel de sterkste kandidaat van vandaag; Rob/wie
    `RaidTips.lua`'s Ula'tek-tekst ooit natoetst kan dit meenemen.
  - **Items — Preternatural Antivenom trinket: effect werkte alleen op de drager, nu gefixed (los
    van de absorb-cap/genezingspercentage-fix van [2026-09-05]).** 0 treffers op "Preternatural" of
    "Antivenom" in `Locales/`/`Modules/` (de enige twee repo-treffers zijn deze eigen watch-historie).
    MEASURED. **[RAAKT ONS NIET]**
  - **Prey — spelers boven Preyhunter's Journey renown 6 krijgen nu op elk personage 500 Corrosive
    Coin per dag voor het verslaan van Ral'kala (was alleen het eerste personage).** Onze
    Preyhunter's-Journey-treffers (`Modules/Delves.lua:253-260`, `Modules/MountProgress.lua:134`)
    gaan over de renown-drempel als portal-gate, niet over een dagelijkse Corrosive-Coin-beloning
    voor Ral'kala. MEASURED (0 treffers op "Ral'kala" in `Locales/`/`Modules/`). **[RAAKT ONS NIET]**
  - **Achievements/Classes/PvP/Burning Crusade Classic, overig:** klassenbalans (Death Knight,
    Druid, Paladin, Priest, Shaman, Warrior — Cooldown Manager-tracking en kleine fixes), Evoker
    Preservation Stasis-exploit in arena's, en een Burning Crusade Classic-questfix (ander spel).
    Gevestigd patroon: MH volgt geen rotatie-/balanscijfers en geen Classic-content. **[RAAKT ONS
    NIET]**

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260910 (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft hotfixes September 9/10 2026" (consolepcgaming.com,
  gepubliceerd 10 sep, bevestigt dezelfde lijst onafhankelijk). Codebase-kant: `grep`
  case-insensitive repo-breed op alle hierboven genoemde namen en spell-ID's, plus gerichte reads
  van `Modules/AchievementsData.lua`, `Modules/Achievements.lua`, `Modules/Delves.lua`,
  `Modules/DungeonRosterData.lua`, `Locales/DungeonTips.lua`, `Locales/RaidTips.lua`,
  `Modules/RaidCoachData.lua`, `Modules/MountProgress.lua`, `Modules/CorrosiveCodexHunts.lua`,
  `Modules/Delves.lua` — allemaal vandaag gelezen. **[RAAKT ONS NIET]** op zeven van acht punten,
  **[RAAKT ONS]** op de Ula'tek-"Rage of the Shackled"-vraag (hierboven) — geen bevestigde
  tegenspraak, wel de sterkste openstaande kandidaat. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

---

- [2026-09-11] ⚠️ **Sectie "September 10, 2026" volledig gelezen, geen tegenspraak — wel één
  bevestiging die onze eigen tekst een reden kan geven die hij nu mist.** `web_fetch_exa` op
  `news.blizzard.com/en-us/article/24296142?nocache=20260911c` (uniek per vandaag), **volledige
  artikeltekst zelf gelezen** (niet via search-samenvatting) tot en met "September 1, 2026".
  Nieuwste sectie is "September 10, 2026" — nieuwer dan de "September 9"-sectie die
  [2026-09-10] als laatste behandelde, dus geen cache-val. Categorieën met content-relevantie:
  Delves, Dungeons and Raids; Professions en Quests ontbreken opnieuw als kopje (Blizzard laat
  lege categorieën weg) — niets om te vergelijken. Onafhankelijk bevestigd: zowel de data- als de
  API-wachter lazen vanmorgen (03:4x UTC, vóór deze run) dezelfde 10-sep-sectie via hun eigen fetch
  en citeren er letterlijk uit (`docs/PTR_12.0.7_DATA.md:765-766`, `docs/API_WATCH.md`) — drie
  onafhankelijke fetches, zelfde inhoud.

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -rn
  "Twilight Crypts"` geeft tientallen treffers in `Modules/DelveChestData.lua`,
  `Modules/DelveTipsData.lua`, `Locales/DelveTips.lua` (alle zeven talen) — dit patroon vindt dus
  iets op deze schaal. De 0-treffers verderop (Domanaar+corpse, de twee nieuwe loot-namen,
  "Final Ascension"/spell-ID 1286921 met naam erbij) zijn gemeten afwezigheid.

  **Bevindingen:**
  - **Delves — Domanaar Enforcer kon een reeds dode corpse Devouren; nu gefixed.** "Domanaar" komt
    bij ons uitsluitend voor in Sunkiller Sanctum, en daar gaat het over het stelen van Energized
    Orbs (`Locales/DelveTips.lua:84`, alle zeven talen) — niets over corpses of Devour. "Enforcer"
    staat 0× als boss-/mob-naam in de repo (enige treffer is ongerelateerde Codex-Franse tekst).
    MEASURED (0 treffers op "Enforcer" als entiteit, repo-breed). **[RAAKT ONS NIET]**
  - **Delves — Twilight Crypts, variant "Loosed Loa": Explorer's League Supplies en de Abandoned
    Restoration Stone verschijnen er nu.** Onze route-tekst voor deze variant
    (`Locales/DelveTips.lua:66`, alle zeven talen: "Loosed Loa: Evasive Elixir to explore; kill
    Skeleton Charmers and totems — track Mot'amra, do not cross his path") en de chestlijst
    (`Modules/DelveChestData.lua:53-57`, zone 2504, drie quest-gebonden coördinaten) noemen geen
    enkel lootitem — dus geen tekstuele tegenspraak, alleen ontbrekende dekking. MEASURED (0
    treffers op beide itemnamen, repo-breed; ook al door de data-wachter gemeten,
    `docs/PTR_12.0.7_DATA.md:765`, onafhankelijk hier herhaald). **[RAAKT ONS NIET]**
  - **Dungeons and Raids — Den of Nalorakk: Nalorakk's Echoing Maul triggerde soms onbedoeld; nu
    gefixed.** Spell-ID 1242887 staat bij ons als kale hazard-trigger (`Modules/HazardData.lua:105`,
    encounter 2825) en in `Modules/MechanicNameProbe.lua:55` — geen van beide beschrijft wannéér
    hij hoort te vuren, dus geen tekstuele tegenspraak. `Locales/RaidTips.lua`'s
    `DGN_TIP_DN_NALORAKK_STEPS` noemt spell-ID 1242887 zelf niet. INFERRED: als de onbedoelde
    triggers vóór de fix meetelden in ons hazard-alarm, kan de alarmfrequentie voor deze cast na
    10 sep afnemen — geen actie nodig, geen bewering om te corrigeren. **[RAAKT ONS NIET]**
  - **🔴 Dungeons and Raids — The Venomous Abyss, The Lost Explorers: Mor'zahi's damage-escalatie
    tijdens Final Ascension reset nu bij een interrupt.** Onze eigen tip zegt al
    `RAID_BOSS_LOSTEXPLORERS_STEPS = "• Interrupt {SPELL:1286921}. ..."` (`Locales/RaidTips.lua:39`,
    zeven taalvarianten) als eerste en enige interrupt-instructie voor deze boss — Blizzards
    hotfix bevestigt dus dat interrupten hier telt, en geeft er voor het eerst een reden bij
    ("reset de schade-escalatie") die onze tekst nu niet heeft. ⚠️ Ik bevestig de identiteit niet:
    "Final Ascension" staat 0× met naam in de repo, en spell-ID 1286921 staat nergens anders met
    een naam erbij — de brontekst zelf noemt ook geen spell-ID (bevestigd door de data-wachter,
    `docs/PTR_12.0.7_DATA.md:766`). Kan dezelfde cast zijn (enige interrupt-call op deze boss), kan
    ook een andere cast in dezelfde fight zijn — niet met zekerheid vast te stellen vanuit de repo.
    MEASURED dat de vraag openstaat; INFERRED dat 1286921 de waarschijnlijke kandidaat is.
    **[RAAKT ONS]** — geen tegenspraak, wel een kans om "waarom interrupten" toe te voegen zodra
    iemand 1286921 = Final Ascension in Robs client of via DBM bevestigt.
  - **Prey — Afflicted/Tormented Souls-buff valt niet meer weg bij dood/BG/arena/specwissel.**
    Onafhankelijk herhaald wat de API-wachter vanmorgen al mat: 0 echte treffers op "Afflicted" of
    "Tormented Souls" in `Modules/`/`Locales/` — enige hit is de substring-valse-positief
    "Lightbloom Afflicted Hide" (`Modules/Profession.lua:187`, skinning-node, geen buff). MEASURED.
    **[RAAKT ONS NIET]**
  - **Classes/PvP/Burning Crusade Classic, overig (beide dagen):** klassenbalans- en
    cooldownmanager-fixes (Death Knight, Hunter, Mage, Paladin, Rogue, Shaman), Evoker/Chronowarden
    in PvP, en een Burning-Crusade-Classic-vendorkorting (ander spel). Gevestigd patroon: MH volgt
    geen rotatie-/balanscijfers, geen PvP-mechanica en geen Classic-content. **[RAAKT ONS NIET]**

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260911c (volledig gelezen via
  Exa, secties 10 sep t/m 1 sep). Codebase-kant: `grep` case-insensitive repo-breed op alle
  hierboven genoemde namen en spell-ID's, plus gerichte reads van `Locales/DelveTips.lua`,
  `Modules/DelveChestData.lua`, `Modules/HazardData.lua`, `Modules/MechanicNameProbe.lua`,
  `Locales/RaidTips.lua`, `Modules/RaidCoachData.lua`, `Modules/Profession.lua` — allemaal vandaag
  gelezen. **[RAAKT ONS NIET]** op vier van vijf punten, **[RAAKT ONS]** op de Mor'zahi-"Final
  Ascension"-vraag (hierboven) — geen bevestigde tegenspraak, wel de sterkste kandidaat van
  vandaag om aan toe te voegen zodra bevestigd. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.
