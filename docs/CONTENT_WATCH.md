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

---

- [2026-09-12] 🔁 **Geen nieuwe hotfix-sectie sinds gisteren — niets nieuws om tegen de repo
  te toetsen.** `Exa web_fetch_exa` met `?nocache=20260912` op news.blizzard.com's doorlopende
  hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie is nog steeds
  "September 10, 2026" — dezelfde sectie die [2026-09-11] al volledig behandelde (Delves:
  Domanaar Enforcer, Twilight Crypts "Loosed Loa"; Dungeons and Raids: Nalorakk's Echoing
  Maul, Mor'zahi/Final Ascension), byte-voor-byte gelijk aan wat toen gelogd is. **Positieve
  controle tegen de cache-val van 3 sep:** `web_search_exa` op "World of Warcraft hotfixes
  September 11/12 2026" vindt geen enkel retail-artikel nieuwer dan 10 sep — wel vindt
  dezelfde zoekmethode zonder moeite de losse 9- en 10-sep-artikelen van Wowhead/Icy
  Veins/MMOHuts (gepubliceerd 11 sep), dus de query kan wél recente content vinden; het
  ontbreken van 11/12 sep is een gemeten afwezigheid, geen kapotte zoekopdracht of een
  week-oude cache. Dit convergeert met de API- en data-wachter van vandaag, die onafhankelijk
  dezelfde "10 sep blijft nieuwste"-stand vonden (`docs/API_WATCH.md` [2026-09-12],
  `docs/PTR_12.0.7_DATA.md` [2026-09-12]) — niet overgenomen, zelf opnieuw gemeten.

  Delves/Professions/Quests: geen nieuwe regels sinds gisteren, dus niets om te vergelijken.
  Geen enkele bevinding vandaag. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260912 (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft hotfixes September 11/12 2026" (nieuwste
  retail-treffer blijft 10 sep).

---

- [2026-09-13] 🔁 **Dag 3 op rij zonder nieuwe hotfix-sectie (BlizzCon-dag 2) — niets nieuws om
  tegen de repo te toetsen.** `Exa web_fetch_exa` met `?nocache=20260913e` op news.blizzard.com's
  doorlopende hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie is nog
  steeds "September 10, 2026", byte-voor-byte gelijk aan wat op [2026-09-11] volledig behandeld
  en op [2026-09-12] al bevestigd is (Delves: Domanaar Enforcer, Twilight Crypts "Loosed Loa";
  Dungeons and Raids: Nalorakk's Echoing Maul, Mor'zahi/Final Ascension) — geen elfde/twaalfde/
  dertiende sectie. Delves/Professions/Quests: geen nieuwe regels, dus niets om te vergelijken.
  **Positieve controle tegen de cache-val van 3 sep:** een losse `web_search_exa` op "World of
  Warcraft hotfixes September 12 2026 OR September 13 2026 Midnight retail" vindt correct
  gedateerde artikelen tot en met 11 sep (Wowhead, gepubliceerd 11 sep, citeert zelf de volledige
  "September 10, 2026"-sectie) maar niets nieuwer dan 10 sep als retail-hotfix — dus de query kan
  wél recente content vinden, het ontbreken van een 11/12/13-sep-hotfixartikel is een gemeten
  afwezigheid, geen kapotte zoekopdracht of een cache-val. Dit convergeert met de data-wachter van
  vandaag (`docs/PTR_12.0.7_DATA.md`, entry [2026-09-13]: zelfde "10 sep blijft nieuwste"-stand,
  ook via Wowhead/Icy Veins tegengelezen) en de API-wachter (`docs/API_WATCH.md`, vandaag: zelfde
  sectie, geen UI/API/addon-inhoud) — beide onafhankelijk zelf gemeten, niet hier overgenomen als
  bewijs, alleen als bevestiging genoemd.

  📌 **BlizzCon 2026 dag 1/2 bracht content-aankondigingen (12.2 "Eclipse": raid The Worldcore,
  legendary Midnight's Edge, zone The Mantle Vault; Season 3 M+-rotatie; WoW Forever), maar dat is
  roadmap/PTR-materiaal, niet een live hotfix op geshipte content** — bewust niet meegenomen hier,
  dat is `docs/PTR_12.1_WATCH.md`'s lane (zie ook diens entry van vandaag). Ik toets alleen live
  hotfixes tegen wat we al claimen; een aankondiging van iets dat nog niet bestaat, is niets om
  tegen te spreken.

  Geen enkele bevinding vandaag. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260913e (volledig gelezen via Exa)
  · `web_search_exa` "World of Warcraft hotfixes September 12 2026 OR September 13 2026 Midnight
  retail" (nieuwste retail-hotfixtreffer blijft 10 sep).

---

- [2026-09-14] 🔁 **Vierde dag op rij zonder nieuwe hotfix-sectie (BlizzCon-dag 3) — niets nieuws
  om tegen de repo te toetsen.** `Exa web_fetch_exa` met `?nocache=20260914z` op news.blizzard.com's
  doorlopende hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie blijft
  "September 10, 2026", byte-voor-byte gelijk aan wat op [2026-09-11] (de "September 10"-sectie:
  Delves — Domanaar Enforcer, Twilight Crypts "Loosed Loa"; Dungeons and Raids — Nalorakk's Echoing
  Maul, Mor'zahi/Final Ascension) en op [2026-09-10] (de "September 9"-sectie: Achievements — Soft
  Underbelly account-wide; Delves — Bountiful Coffers/Zul'jarra's Forces; Prey — Ral'kala Corrosive
  Coin per account) al volledig behandeld en tegen de repo getoetst is — geen elfde sectie.
  Delves/Professions/Quests: geen nieuwe regels sinds gisteren, dus niets om te vergelijken.

  📌 **Positieve controle tegen de cache-val van 3 sep:** `web_search_exa` op "World of Warcraft
  Midnight hotfixes September 13 2026 OR September 14 2026 retail" vindt geen enkel
  retail-hotfixartikel nieuwer dan 10 sep — maar de zoekopdracht zelf werkt prima: hij vindt zonder
  moeite stukken die wél vandaag/gisteren gedateerd zijn (Wowhead's "What's Next"-liveblog, 12 sep
  21:42 UTC; Blizzards eigen "Midnight: What's Next Panel Recap", 12 sep 22:24 UTC) — het ontbreken
  van een 11-14 sep hotfixartikel is dus gemeten afwezigheid, geen kapotte zoekopdracht of een
  week-oude cache. Convergeert met de data-wachter van vandaag (`docs/PTR_12.0.7_DATA.md`,
  entry [2026-09-14]: "dag 5" sinds dezelfde stand) — onafhankelijk zelf opnieuw gemeten, niet
  overgenomen als bewijs.

  Gerichte tweede zoekslag specifiek op Delves/Professions/Quests (`web_search_exa` "Wowhead World
  of Warcraft Midnight Delves Professions Quests update September 14 2026") leverde uitsluitend
  bestaand referentiemateriaal op (het Season 2-delvegidsartikel, laatst bijgewerkt 4 sep; de
  Profession Knowledge Points-gids, laatst bijgewerkt 18 aug) plus het al op [2026-09-13] als
  PTR/roadmap beoordeelde 12.1.5/12.2-materiaal (nieuwe Delve-modus Labyrinths, nieuwe Delve
  Nemesis Astalor Bloodsworn in Season 3, Aqir Invasions) — niets nieuws over al geshipte content,
  dus niets om aan de repo te toetsen. Bewust buiten scope gelaten, zelfde reden als [2026-09-13]:
  dit is aankondiging/roadmap-materiaal (`docs/PTR_12.1_WATCH.md`'s lane), geen live hotfix op
  bestaande content.

  Geen enkele bevinding vandaag. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260914z (volledig gelezen via Exa)
  · `web_search_exa` "World of Warcraft Midnight hotfixes September 13 2026 OR September 14 2026
  retail" en "Wowhead World of Warcraft Midnight Delves Professions Quests update September 14
  2026" (geen retail-hotfix nieuwer dan 10 sep gevonden).

---

- [2026-09-15] 🔁 **Vijfde dag op rij zonder nieuwe hotfix-sectie — wel één vooraankondiging
  gecheckt, geen tegenspraak.** `Exa web_fetch_exa` met `?nocache=20260915` op news.blizzard.com's
  doorlopende hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie blijft
  "September 10, 2026", byte-voor-byte gelijk aan wat op [2026-09-11] volledig behandeld en op
  [2026-09-12]/[2026-09-13]/[2026-09-14] al bevestigd is (Delves — Domanaar Enforcer, Twilight
  Crypts "Loosed Loa"; Dungeons and Raids — Nalorakk's Echoing Maul, Mor'zahi/Final Ascension) —
  geen elfde sectie. Delves/Professions/Quests: geen nieuwe regels sinds gisteren, dus niets om te
  vergelijken.

  **Eén nieuwe bron dit run: een blue post van vandaag, "Midnight Season 2 Trinket Tuning –
  September 22"** (us.forums.blizzard.com, Linxy, 15 sep 00:31 UTC — gevonden via `web_search_exa`,
  daarna de forumpagina niet apart opgehaald omdat de zoekresultaat-highlights de volledige lijst al
  citeerden). Dit is **geen live hotfix maar een vooraankondiging**, van kracht pas bij het
  weekly-onderhoud van 22 sep — dus strikt genomen dichter bij `docs/PTR_12.1_WATCH.md`'s "wat komt
  eraan"-lane dan bij mijn "is wat al leeft in tegenspraak"-lane. Ik neem hem toch hier op omdat het
  om al-live Season 2-trinkets gaat, geen PTR-build. Lijst: Preternatural Antivenom (+75% healing),
  Seed of Radiant Hope, Mycolic Medicine, Unstable Felheart Crystal, Ruby Whelp Shell (allemaal
  buff), Gaze of the Alnseer, Vaelgor's Final Stare, Algeth'ar Puzzle Box (allemaal nerf). Puur
  percentage-tuning op bestaande trinkets, geen naam- of mechaniekwijziging.

  📌 **Positieve controle, repo-brede scope, zelfde run:** `grep -i "Trader's Tender"` in
  `Modules/TradingPost.lua` geeft nog steeds een treffer (currency 2032, zoals eerder gemeten) — het
  patroon vindt dus iets op deze schaal. Tegen diezelfde scope: `grep -i` op alle acht trinketnamen
  hierboven geeft **0 treffers** in `Locales/`/`Modules/` — de enige treffer repo-breed is deze
  watch-historie zelf (`docs/CONTENT_WATCH.md`, Preternatural Antivenom eerder al gemeten op
  [2026-09-05] en [2026-09-10]). MEASURED. Gevestigd patroon bevestigd: MH volgt geen balans-/
  tuningcijfers op trinkets, dus een %-wijziging op zeven van de acht is sowieso buiten scope; de
  achtste (Preternatural Antivenom) staat al vast als niet-getrackt. **[RAAKT ONS NIET]**

  Geen andere bevindingen vandaag. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260915 (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight hotfixes September 14 2026 OR September 15 2026
  retail" (nieuwste retail-hotfixtreffer blijft 10 sep; leverde wel de trinket-tuning-vooraankondiging
  op, hierboven behandeld).

---

- [2026-09-16] 🎯 **Eerste elfde hotfixsectie sinds 10 sep ("September 15") bevat één punt dat
  onze eigen ontwerpnotitie inhaalt — geen tegenspraak, wel een aanname die niet meer klopt.**
  Zelf gelezen: `news.blizzard.com/en-us/article/24296142?nocache=20260916c` (Exa, volledige
  artikeltekst) — nieuwste sectie is **"September 15, 2026"**: Classes (Hunter/Paladin/Priest
  bugfixes), Dungeons and Raids (pure schade-/timing-tuning in The Venomous Abyss/Twin Fangs/
  Coiled Altar/Ula'tek, geen nieuwe mechanieknamen), Items, Quests, The Coiled Isle. Geen
  Delves- of Professions-sectie die dag. Dit dekt zich byte-voor-byte met wat de data-wachter
  vanmorgen al citeerde (`docs/PTR_12.0.7_DATA.md`, regel 772-775) — onafhankelijk zelf
  opnieuw opgehaald, niet van die log overgenomen.

  **The Coiled Isle — Curse Surge-cyclus nu MEASURED: 30 minuten (was 45).** Letterlijk citaat:
  *"Curse Surges now rotate every 30 minutes (was 45 minutes)."* → `Locales/enUS.lua:1816`
  (`ACH_NOTE_CURSE_SURGE`) zegt tegen de speler *"a scenario at this spot that only runs part
  of the time"* — geen getal, met opzet: `Modules/AchievementsData.lua:338` motiveert dat
  expliciet met *"NO CYCLE, ON PURPOSE… Nobody has measured it, so the note says 'part of the
  time' and carries no number."* Die tekst **spreekt niets tegen** — "part of the time" blijft
  waar — maar de reden om het getal weg te laten (onzekerheid tussen HandyNotes' 45 minuten en
  een forumschatting van ~20) bestaat niet meer: Blizzard bevestigt nu zelf dat het 45 minuten
  wás en sinds 15 sep 30 minuten is. MEASURED. Dit is een kandidaat voor een mens om de
  ontwerpbeslissing te herzien (het getal toevoegen aan `ACH_NOTE_CURSE_SURGE`), niet iets wat
  ik zelf aanpas — ik raak alleen dit bestand aan. **[RAAKT ONS]**

  **Quests — "Delves should once again count for progress towards the objective of 'Hope in
  the Darkest Corners'."** QuestID **95468** staat al met naam in `Modules/ResetRoutine.lua:134`
  (Halduron's leveling-variant, sub-90), maar die regel gebruikt de quest alleen als
  opgehaald/ingeleverd-vlag voor de reset-routine — nergens in de repo staat een bewering over
  wélk objectief telt of hoe. GEMETEN: 0 treffers op "Darkest Corners" gecombineerd met "delve"
  buiten dit ene questID-gebruik. Geen tegenspraak, want geen claim om tegen te spreken.
  **[RAAKT ONS NIET]**

  **Items — Spark-of-Tides-restauratiemechanisme** (vult de status van [2026-09-04] verder aan
  met het letterlijke "meer Spark Dust dan Sparks"-mechanisme). MH tracked geen Spark-of-Tides-
  of Spark-Dust-currency-ID's (bevestigd door de data-wachter vandaag, zelf nagelopen: alleen
  een questnaam-vermelding in `Modules/AtalUtekProbe.lua:269`, geen saldo-claim). **[RAAKT ONS NIET]**

  **Positieve controle op repo-brede grepschaal, zelfde run:** een grep op de zes nieuwe
  bosnamen/mechanieken uit de Dungeons-and-Raids-tuning ("Putrid Membrane", "Serpent's Call",
  "Wail of Terror", "Dreadmarch", "Manifestations of Dread", "Spiteful Soulcoiler") en op de
  quest "Still Behind Enemy Portals"/"Hijacked Portal" geeft **0 treffers** in heel `Locales/`
  en `Modules/` — bewust NIET als bewijs van afwezigheid geteld zonder controle: dezelfde
  grepschaal (`Locales/`+`Modules/`) vindt in deze zelfde run wél "Curse Surge" in 6 bestanden
  (zie boven) en "Hope in the Darkest Corners"/95468 in `ResetRoutine.lua` — het patroon werkt
  dus op deze schaal, de nul is een gemeten afwezigheid.

  Verder bewust overgeslagen als tuning zonder nieuwe mechaniek voor een tracker (de overige
  Sszorak-/Twin-Fangs-/Coiled-Altar-/Ula'tek-percentages van 15 sep) of als PTR/roadmap
  (`docs/PTR_12.1_WATCH.md`'s lane). **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260916c (volledig gelezen via Exa)
  · `docs/PTR_12.0.7_DATA.md` (regel 772-775, ter kruisverwijzing, niet als bewijs overgenomen).

---

- [2026-09-17] 🔁 **Geen nieuwe hotfix-sectie sinds gisteren — niets nieuws om tegen de repo te
  toetsen.** `Exa web_fetch_exa` met `?nocache=20260917f` op news.blizzard.com's doorlopende
  hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie is nog steeds
  "September 15, 2026" — byte-voor-byte dezelfde vier categorieën (Classes, Dungeons and Raids,
  Items, Quests) plus The Coiled Isle die [2026-09-16] al volledig behandeld heeft (Sszorak/Twin
  Fangs/Coiled Altar/Ula'tek-tuning, Spark-of-Tides-restauratie, "Hijacked Portal"/"Hope in the
  Darkest Corners"-questfixes, Curse Surge 30 min). Geen twaalfde sectie. Delves/Professions:
  geen nieuwe regels sinds gisteren, dus niets om te vergelijken.

  **Positieve controle tegen de cache-val van 3 sep:** `web_search_exa` op "World of Warcraft
  Midnight hotfixes September 16 2026 OR September 17 2026 retail" vindt geen enkel
  retail-hotfixartikel nieuwer dan 15 sep — maar dezelfde zoekmethode vindt in diezelfde
  resultatenlijst zonder moeite de correct gedateerde artikelen voor 15, 10, 9 en 4 sep en zelfs
  17/19 aug, dus de query kan wél recente en oude content vinden; het ontbreken van een 16/17-sep-
  hotfixartikel is een gemeten afwezigheid, geen kapotte zoekopdracht of een week-oude cache. Dit
  convergeert met de API-, PTR/roadmap- en data-wachter van vandaag, die elk onafhankelijk
  dezelfde "15 sep blijft nieuwste"-stand vonden (`docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md`,
  `docs/PTR_12.0.7_DATA.md`, alle entries [2026-09-17]) — niet overgenomen als bewijs, zelf
  opnieuw gemeten via een eigen fetch met een eigen cache-buster.

  De data-wachter noemt vandaag ook dat `Modules/ResetRoutine.lua` in de net binnengehaalde
  4.0.0-releasecommit de Timewalking-weekly is gaan trackeren ("Ship the Timewalking weekly
  instead of relying on one player's learn store") — dat is een codewijziging uit deze sessie
  zelf, geen hotfix-bevinding, en dus niets voor deze wachter om tegen een hotfix te toetsen.
  Verder geen nieuwe blue posts of live-events gevonden die in mijn lane vallen (Delves/
  Professions/Quests/Dungeons and Raids/Items) — de vandaag lopende maar nog niet gehouden
  BlizzCon-Q&A en het Kith'ix-testverslag zijn beide PTR/roadmap-materiaal, al door de PTR-wachter
  vandaag als "nog niet plaatsgevonden" genoteerd.

  Geen enkele bevinding vandaag. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260917f (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight hotfixes September 16 2026 OR September 17 2026
  retail" (nieuwste retail-hotfixtreffer blijft 15 sep).

---

- [2026-09-18] 🔴 **Twaalfde hotfixsectie ("17 september") gemeten — en één regel erin raakt een
  baas die we deze maand net herschreven hebben, met precies de mechaniek-namen die in onze tekst
  ontbreken.** Zelf gelezen: `news.blizzard.com/en-us/article/24296142?nocache=20260918z` (Exa,
  volledige artikeltekst) — nieuwste sectie is nu **"September 17, 2026"**, met alleen Dungeons
  and Raids en Player versus Player (geen Delves/Professions/Quests/Items die dag). Kruisverwijzing:
  dezelfde sectie is vandaag ook al gelezen door de API-, PTR- en data-wachter
  ([2026-09-18]-entries in hun eigen bestanden) — hier onafhankelijk opnieuw opgehaald met een
  eigen cache-buster, niet van die logs overgenomen. **Positieve controle tegen de cache-val van
  3 sep:** `web_search_exa` op "...September 18 2026..." vindt geen enkel hotfixartikel na 17 sep,
  terwijl dezelfde zoekvorm moeiteloos correct gedateerde stukken tot en met 17, 15, 10, 9, 4 sep
  en augustus teruggeeft — een gemeten afwezigheid, geen kapotte cache.

  **Ruby Life Pools — enemy-forces-telfix voor Blazebound Destroyers/Primalist Flamedancers, met
  als bijwerking dat hun bijdrage niet meer op de tooltip staat.** GEMETEN: 0 treffers op "enemy
  forces", "Blazebound Destroyer" en "Primalist Flamedancer" in heel `Locales/` en `Modules/`
  (`grep -rniE` op alle `.lua`-bestanden). Onze drie Ruby Life Pools-tips
  (`Locales/DungeonTips.lua:516-539`, Kokia/Kyrakka/Melidrussa) gaan alleen over boss-mechanics,
  niet over trash-tellingen — niets om tegen te spreken. **[RAAKT ONS NIET]**

  **The Coiled Altar — Unnerving Fixation targette tanks vaker dan bedoeld, nu gefixt.** Deze baas
  is bij ons `coiledaltar` (`Modules/RaidCoachData.lua:105`, encounterID 2883, Zul'jan/Malacrass —
  `Modules/RaidCoachData.lua:210`), en de tips (`Locales/RaidTips.lua:85-92`,
  `RAID_BOSS_COILEDALTAR_STEPS/_TANK/_HEALER/_DPS`) zijn **op 15 sep herschreven** — dezelfde dag
  als Blizzards eerste afstembeurt voor deze baas. GEMETEN, `grep -rniE` op alle `.lua`-bestanden
  in de hele repo: geen van de zes mechaniek-namen die Blizzard voor déze baas gebruikt in de
  hotfixes van 15 én 17 sep — "Unnerving Fixation", "Wail of Terror", "Manifestations of Dread",
  "Dreadmarch", "Spiteful Soulcoiler", "Venom Rupture", "Mutagenic Venom" — komt ook maar één keer
  voor, nergens. **Positieve controle op dezelfde repo-brede schaal, zelfde run:** "Malacrass"
  (4 bestanden) en "Guillotine" (2 bestanden) vinden wél treffers met exact dezelfde zoekvorm — de
  nul hierboven is dus een gemeten afwezigheid, geen kapot patroon. Onze tekst beschrijft in plaats
  daarvan groene orbs, geesten en Guillotine-soak over drie fases; geen van die zes officiële namen
  valt daar ook maar zijdelings onder te vangen.
  Dit is geen weerlegging van een claim — we noemen nergens een tank-target-frequentie — maar wel
  een gemeten hiaat: zes officiële mechaniek-namen voor precies déze baas, verspreid over twee
  hotfix-rondes, ontbreken volledig uit een tekst die dezelfde week "compleet herschreven" heet.
  Een derde, zwakkere bron (consolepcgaming.com, via `web_search_exa`, dus MEASURED (via search,
  niet zelf gelezen)) citeert een "Manifestations"-fix voor deze baas al op 31 augustus — dus dit
  is vermoedelijk geen gloednieuwe mechaniek uit de 15-sep-tuning, maar iets dat al bestond vóór de
  herschrijving. `RAID_PRERELEASE_NOTE` (`Locales/RaidTips.lua:36`) zegt er zelf al bij dat niet
  alles zelf gelopen is, dus dit is geen verzwegen fout — maar wel iets concreets voor een mens om
  te beoordelen: mist de tekst een hele fase/mechaniek, of heet iets hier anders dan bij DBM? Dat
  kan ik niet vaststellen, alleen een speler in-game. INFERRED dat dit de moeite waard is om na te
  lopen; MEASURED dat de namen ontbreken. **[RAAKT ONS]**

  **Player versus Player — rating-inflatie fors omhoog, Font of Venomous Rage-trinketschade -50%
  in PvP.** GEMETEN: 0 treffers op "Font of Venomous Rage" of "PvP rating" in `Locales/`/`Modules/`
  die iets anders beweren — MH heeft geen PvP-rating- of PvP-trinketadvies. Buiten onze lane.
  **[RAAKT ONS NIET]**

  Verder niets nieuws: de 17-sep-batch had geen Delves-, Professions-, Quests- of Items-secties.
  — bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260918z (volledig gelezen
  via Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes September 18 2026 retail Delves
  Professions Quests" (nieuwste retail-hotfixtreffer blijft 17 sep) · consolepcgaming.com (31-aug-
  Manifestations-vermelding, secundair, niet zelf gelezen, niet als bewijs voor de hotfix-datum
  gebruikt).

---

- [2026-09-19] 🔁 **Dag 2 zonder nieuwe hotfix-sectie sinds 17 sep — zelf gemeten, drie andere
  wachters vandaag onafhankelijk hetzelfde.** `Exa web_fetch_exa` met `?nocache=20260919x` op
  news.blizzard.com's doorlopende hotfix-artikel, **volledige artikeltekst zelf gelezen**:
  nieuwste sectie is nog steeds **"September 17, 2026"** (Dungeons and Raids: Ruby Life Pools,
  The Coiled Altar; Player versus PvP), byte-voor-byte gelijk aan wat al op [2026-09-18] gelogd
  staat — geen Delves-, Professions-, Quests- of Items-sectie die dag, zoals toen al vastgesteld.
  Dit convergeert met de API-, PTR/roadmap- en data-wachter van vandaag (elk apart,
  `docs/API_WATCH.md`/`docs/PTR_12.1_WATCH.md`/`docs/PTR_12.0.7_DATA.md`, entries [2026-09-19]) —
  niet overgenomen, zelf opnieuw opgehaald met een eigen cache-buster.

  **Positieve controle tegen de cache-val van 3 sep:** `web_search_exa` op retail-hotfixes van
  18/19 sep vindt geen enkel artikel nieuwer dan 17 sep, maar dezelfde zoekopdracht geeft in
  dezelfde resultatenlijst moeiteloos correct gedateerde stukken terug tot en met 17, 15, 9, 4 sep
  en augustus — een gemeten afwezigheid, geen kapotte of verouderde cache. Eén ruisresultaat
  expliciet herkend en genegeerd: een "War Within Hotfixes: September 18th"-artikel van Icy Veins
  bleek bij lezing over **The War Within** te gaan (Kobold Delves, Hallowfall, Khaz Algar,
  Necrotic Wake — een ouder addon-seizoen/andere expansion), niet over Midnight/12.1 — niet
  meegeteld.

  Geen enkele bevinding vandaag om tegen de repo te toetsen. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260919x (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight hotfixes September 18 2026 OR September 19 2026
  retail Delves Professions Quests Items patch notes" (nieuwste retail-hotfixtreffer blijft
  17 sep).

---

- [2026-09-20] 🔁 **Dag 3 zonder nieuwe hotfix-sectie sinds 17 sep — zelf gemeten, geen delta om te
  toetsen.** `Exa web_fetch_exa` met `?nocache=20260920a` op news.blizzard.com's doorlopende
  hotfix-artikel, **volledige artikeltekst zelf gelezen**: nieuwste sectie is nog steeds
  **"September 17, 2026"** (Dungeons and Raids: Ruby Life Pools, The Coiled Altar; Player versus
  PvP), byte-voor-byte gelijk aan wat al op [2026-09-18] en [2026-09-19] gelogd staat — geen
  Delves-, Professions-, Quests- of Items-sectie die dag, zoals toen al vastgesteld. De oudere
  secties in hetzelfde artikel (10/9/4/3/2/1 sep, incl. de Delves-regels "Domanaar Enforcer" en
  Twilight Crypts "Loosed Loa") zijn al in eerdere entries getoetst (zie de kruisverwijzingen op
  [2026-09-12] t/m [2026-09-14]) — niet opnieuw behandeld.

  **Onafhankelijke bevestiging, vijf bronnen via `web_search_exa`:** news.blizzard.com (en-us én
  en-gb), Arctium blue-post-spiegel, een pubt.io-spiegel en Wowhead's Blue Tracker geven allemaal
  "Hotfixes: September 17, 2026" als nieuwste retail-artikel — geen 18-, 19- of 20-sep-titel
  gevonden bij geen van de vijf. **Positieve controle op dezelfde zoekopdracht:** diezelfde
  resultatenlijst geeft moeiteloos correct gedateerde stukken voor 17, 15, 4 sep en zelfs 19/18 aug
  (Arctium's eigen archiefpagina's) — de query kan dus wél oudere en recentere datums vinden; het
  ontbreken van een 18-20-sep-hotfixartikel is een gemeten afwezigheid, geen kapotte of
  verouderde cache. Dit convergeert met de API-wachter van vandaag (`docs/API_WATCH.md`,
  entry [2026-09-20]: "0 x MOET GEFIKST", zelfde 17-sep-baseline) — niet overgenomen, zelf
  opnieuw opgehaald met een eigen cache-buster en een eigen zoekopdracht.

  Geen enkele bevinding vandaag om tegen de repo te toetsen. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260920a (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight retail hotfixes September 18 2026 OR September 19
  2026 OR September 20 2026 Delves Professions Quests Items patch notes" (nieuwste retail-
  hotfixtreffer blijft 17 sep, vijf onafhankelijke bronnen eens).

---

- [2026-09-21] 🔁 **Dag 4 zonder nieuwe hotfix-sectie sinds 17 sep — zelf gemeten; één zijspoor uit
  de data-wachter gecheckt op tegenspraak, geen gevonden.** `Exa web_fetch_exa` met
  `?nocache=20260921e` op news.blizzard.com's doorlopende hotfix-artikel, **volledige artikeltekst
  zelf gelezen**: nieuwste sectie is nog steeds **"September 17, 2026"** (Dungeons and Raids: Ruby
  Life Pools, The Coiled Altar/Unnerving Fixation; Player versus PvP) — byte-voor-byte dezelfde
  inhoud als op [2026-09-18] al volledig gelezen en getoetst, geen Delves-, Professions-, Quests-
  of Items-sectie die dag. **Onafhankelijke bevestiging:** `web_search_exa` op retail-hotfixes van
  18 t/m 21 sep vindt geen enkel artikel nieuwer dan 17 sep (o.a. news.blizzard.com, pubt.io- en
  bluetracker.gg-spiegels doorzocht), terwijl dezelfde zoekvorm in dezelfde resultatenlijst zonder
  moeite correct gedateerde stukken voor 17, 15, 10, 9 sep en 21 augustus teruggeeft — een gemeten
  afwezigheid, geen kapotte of verouderde cache. Dit convergeert met de API-, PTR/roadmap- en
  data-wachter van vandaag (elk apart, eigen entries [2026-09-21]) — niet overgenomen, zelf
  opnieuw opgehaald met een eigen cache-buster.

  **Zijspoor gecheckt: de data-wachter logde vandaag een Wowhead-community-theorie (artikel
  382966, GEEN Blizzard-bevestiging) dat een "Mythic (Flexible Raiding)"-Great-Vault-slot
  gegarandeerd Mythic-Nymrissa-Wavecaller-loot geeft, en merkte zelf al op dat dit voor mijn lane
  relevant is.** Dat is zijn feit, niet het mijne — mijn vraag is of het een geshipte claim
  tegenspreekt. GEMETEN: `Modules/VaultAdvisor.lua` en `Modules/VaultAdvisorData.lua` (beide
  vandaag gelezen, gegrept op `Mythic`/`slot`/`Flex`) bevatten geen enkele regel over
  loot-*herkomst* per Vault-slot — alleen generieke tier-set-telling, same-slot-swap-logica en
  item-level-vergelijking. `grep -i "Flexible Raiding"` repo-breed: 0 treffers buiten de
  data-wachter's eigen logregel van vandaag. `grep -i Nymrissa` repo-breed geeft wél 18 bestanden
  terug (o.a. `Modules/TideboundGrottoCoach.lua`, `Locales/RitualTips.lua`) — maar dat zijn allemaal
  boss-fight-tips voor de Nymrissa-Wavecaller-encounter zelf, niet iets over Vault-slotherkomst; dus
  geen naamcollision met de claim. **Positieve controle, zelfde repo-brede scope:** dezelfde
  grep-vorm die 0 treffers gaf op "Flexible Raiding" vond wél 18 bestanden op "Nymrissa" in
  hetzelfde commando — het patroon werkt, de 0 is gemeten afwezigheid. Niets om tegen te spreken:
  VaultAdvisor claimt nergens welke boss een slot vult. **[RAAKT ONS NIET]**

  Geen enkele hotfix-bevinding vandaag om tegen de repo te toetsen. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260921e (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight retail hotfixes September 21 2026 Delves Professions
  Quests Items patch notes" (nieuwste retail-hotfixtreffer blijft 17 sep) ·
  `docs/PTR_12.0.7_DATA.md` entry [2026-09-21] als aanleiding voor de Nymrissa/Vault-check (feit
  niet herhaald, alleen zelf getoetst op tegenspraak met geshipte MH-tekst). Codebase-kant: `grep`
  case-insensitive repo-breed, plus gerichte reads van `Modules/VaultAdvisor.lua` en
  `Modules/VaultAdvisorData.lua` — allemaal vandaag gelezen. Geen actiepunt dat ík kan oppakken —
  ik rapporteer, een mens beslist.

---

- [2026-09-22] 🔴 **Eerste nieuwe hotfix-sectie sinds 17 sep gemeten ("21 september") — en de
  Ula'tek-baastips missen twee genoemde mechanieken volledig, los van wat er al bekend stond over
  Coiled Altar.** Zelf gelezen, eigen cache-buster: `news.blizzard.com/en-us/article/24296142
  ?nocache=20260922c` (via Exa, volledige artikeltekst tot en met de 15-sep-sectie). Nieuwste
  sectie is **"September 21, 2026"** (Classes/Evoker, Dungeons and Raids, Player versus Player) —
  geen Delves-, Professions-, Quests- of Items-sectie die dag, en ook niet op 17 sep. Kruisverwijzing:
  dezelfde sectie is vandaag ook al gelezen door de API-, PTR/roadmap- en data-wachter (elk hun
  eigen [2026-09-22]-entry) — hier onafhankelijk opnieuw opgehaald met een eigen cache-buster, niet
  overgenomen. **Positieve controle tegen de cache-val van 3 sep:** de "21 sep"-sectie is nieuwer
  dan wat mijn eigen log van [2026-09-21] al kende ("17 sep" toen nieuwste), dus een verse cache,
  geen oude — bevestigd door een los `web_search_exa` die dezelfde 21-sep-titel onafhankelijk
  teruggeeft (Arctium-spiegel, `arctium.io/blue-posts/780`, gedateerd 2026-09-17, plus een
  pubt.io-spiegel van de 21-sep-titel). Diezelfde zoekslag vond ook oudere Delve-hotfixregels
  (Domanaar Enforcer, Bountiful Coffers/Zul'jarra's Forces, trinket-droprate) terug — dat zijn
  **geen nieuwe feiten**: ze matchen woordelijk de al-gelogde 1/9/10-sep-secties uit eerdere runs
  van dit logboek, gewoon lager op dezelfde doorlopende Blizzard-pagina.

  **1. Lindormi's Guidance / enemy-forces-fix in Den of Nalorakk en Altar of Fangs.** Al gezien en
  gelogd door de API- en data-wachter vanmorgen; ik toets vanuit mijn eigen hoek (de dungeon-tip-
  tekst, niet de affix-tekst). GEMETEN: `Locales/DungeonTips.lua:151-157,407` (`DGN_TIP_DN_NALORAKK_*`)
  en de Altar of Fangs/Zul'jan-tips (`Modules/DungeonTipsData.lua:59-61`) noemen nergens "enemy
  forces", een percentage of een routing-garantie — alleen boss-mechanics (marks, charges, schild).
  Niets om tegen te spreken. **[RAAKT ONS NIET]**

  **2. Vier nieuwe Coiled Altar-mechanieknamen (21 sep) komen bovenop de zes die al op
  [2026-09-18] ontbraken.** De 21-sep-fix noemt *"Toxic Deluge"*, *"Coalesced Venoms"*,
  *"Virulent Mutations"*, *"Fangs of the Crucible"* en *"Defilement of the Crucible"* (vijf namen,
  in Blizzards tekst als "vier fixes" geteld) plus een pets-tijdens-roleplay-bug bij Zul'jan.
  GEMETEN, `grep -rniE` repo-breed op alle vijf de namen: **0 treffers**, in geen enkel bestand.
  **Positieve controle, zelfde repo-brede grep-vorm, zelfde run:** "Zul'jan" (7+ bestanden) en
  "Guillotine" (2 bestanden) geven wél treffers — de nul hierboven is een gemeten afwezigheid.
  Onze Coiled Altar-tips (`Locales/RaidTips.lua:85-92`, `RAID_BOSS_COILEDALTAR_*`) beschrijven nog
  steeds alleen groene orbs, geesten en Guillotine-soak. Dit is geen weerlegging van een claim —
  net als op 18 sep noemen we nergens een mechaniek-naam die tegengesproken wordt — maar het gat
  dat toen zes officiële namen telde, is vandaag met vijf uitgebreid: elf mechaniek-namen voor
  precies déze baas, over drie hotfix-rondes (15, 17, 21 sep), ontbreken nu volledig uit een tekst
  die medio september "herschreven" heet. **[RAAKT ONS]** — zelfde open punt als [2026-09-18], nu
  breder.

  **3. NIEUW vandaag: Ula'tek's "Mother's Wrath"/"Stone Venom" en "Boiling Venom" komen in onze
  eigen baastips helemaal niet voor — twee losse mechanieken, niet één met een andere naam.**
  De hotfixes van 15 én 21 sep tunen *"Stone Venom"* expliciet als straf voor het niet in
  *"Mother's Wrath"* staan (15 sep: *"Failing to stand within Mother's Wrath now only inflicts 1
  stack of Stone Venom"*; 21 sep: schade -40% op alle moeilijkheden plus een bugfix, en los
  daarvan wordt *"Boiling Venom"* op Mythic nu een "Important Aura"). GEMETEN: onze volledige
  Ula'tek-tips (`Locales/RaidTips.lua:93` STEPS, `:98` TANK, `:99` HEALER, `:100` DPS — zelf
  gelezen, alle vier de regels) noemen alleen een generieke gif-DoT bij het uitkomen van een Viper
  ({SPELL:1301268}) en "dispel poison" ({SPELL:1301800}); nergens een positioneringsopdracht rond
  een naam als "Mother's Wrath", en nul keer de woorden "Stone Venom" of "Boiling Venom", in de
  hele repo (`grep -rniE`, .lua-breed). **Positieve controle, zelfde repo-brede scope, zelfde
  grepvorm:** "Ula'tek"/"Nymrissa"/"Wavecaller" (26 bestanden), en binnen dezelfde vier tip-regels
  vinden "Doomscale Warden", "Malice" en "Anguished Cry" wél treffers — het patroon werkt, de nul
  op de drie gezochte namen is een gemeten afwezigheid. **Wat ik niet kan vaststellen:** of
  {SPELL:1301268}/{SPELL:1301800} in werkelijkheid dezelfde aura's zijn als "Stone Venom" (alleen
  door ons anders omschreven) of dat dit een volledig los, nergens genoemd deel van het gevecht is
  — dat vraagt een spellId-check in de client, niet een gok van hier. MEASURED dat de namen
  ontbreken; INFERRED dat dit het navragen waard is, want de mechaniek is inmiddels twee keer
  getuned (15 + 21 sep) op een baas die momenteel live en Mythic-relevant is. **[RAAKT ONS]**

  **4. Trinket-tuningronde (Preternatural Antivenom e.a.) en PvP-rating-inflatie/Font of Venomous
  Rage: geen nieuwe check nodig.** Al eerder vastgesteld — trinketnamen 0 treffers repo-breed
  (bevestigd door de data-wachter vandaag, hier zelf herhaald met dezelfde uitkomst), PvP-rating
  buiten onze lane (geen PvP-advies in MH). **[RAAKT ONS NIET]**

  Evoker-classfixes (Unravel/Fire Breath) zijn class-balans, geen addon-content — buiten scope.
  — bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260922c (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft Midnight retail Delves hotfix OR blue post September
  2026 Season 2 changes" (bevestigt 21-sep-titel onafhankelijk, geen nieuwe Delve-content t.o.v.
  eerdere runs) · codebase: `grep -rniE` repo-breed plus gerichte reads van
  `Locales/DungeonTips.lua`, `Modules/DungeonTipsData.lua`, `Locales/RaidTips.lua` — allemaal
  vandaag gelezen. Geen actiepunt dat ík kan oppakken — ik rapporteer, punt 2 en 3 zijn voor een
  mens (of Cisca in-game) om te beoordelen.

---

- [2026-09-23] 🔴 **Correctie op de eigen fout van 22 sep: de "ontbrekende" Coiled Altar- en
  Ula'tek-mechanieken staan er wél — als spell-ID, niet als naam.** Voordat ik verder ging met de
  hotfixes van vandaag, eerst de eigen methode toegepast die deze wachter zichzelf al drie keer
  eerder had moeten aanleren: een spell-ID in onze tips opzoeken vóórdat "ontbreekt" wordt gemeld.
  GEMETEN via Wowhead (Exa `web_fetch_exa`, elke URL met een eigen `?nocache=20260923`-variant):
  - `{SPELL:1298367}` = **Mother's Wrath** (Ula'tek): "knocks back her current target... Each bite
    injects [target] with Stone Venom and leaves them Hobbled." Dat is precies wat
    `RAID_BOSS_ULATEK_TANK` (`Locales/RaidTips.lua:98`, zeven taalvarianten) al zegt: "{SPELL:1298367}
    knocks you back and slows you ({SPELL:1300938})" — en `{SPELL:1300938}` bleek zelf **Hobbled**
    te zijn, precies de slow die Mother's Wrath toedient. Geen los ontbrekend stuk: hetzelfde
    mechaniek, alleen via ID beschreven i.p.v. via naam.
  - `{SPELL:1299960}` = **Toxic Deluge** (Coiled Altar): "The crucible spews venom into the
    chamber... creating Coalesced Venom." Dat is het `{SPELL:1299960}` uit
    `RAID_BOSS_COILEDALTAR_STEPS` (`Locales/RaidTips.lua:85`): "Green orbs ({SPELL:1299960})".
  - `{SPELL:1282487}` = **Fangs of the Coiled Altar** en `{SPELL:1298381}` = **Defilement of the
    Coiled Altar** op Wowhead (Blizzards eigen 21-sep-hotfixtekst noemt dezelfde twee ID's "Fangs
    of the Crucible" en "Defilement of the Crucible" — een kortere patchnotes-naam voor dezelfde
    spell, geen aparte mechaniek). Beide staan in `RAID_BOSS_COILEDALTAR_TANK` en `_HEALER`
    (`Locales/RaidTips.lua:91-92`, zeven taalvarianten): "After {SPELL:1282487}, and {SPELL:1298381}
    in phase 3, his next swings hit hard."

  Dat weerlegt punt 2 en 3 van mijn eigen entry van [2026-09-22]: die zei dat deze vier namen
  "volledig ontbreken" uit onze Coiled Altar- en Ula'tek-tips. Ze ontbreken als tekst, niet als
  mechaniek — precies het onderscheid dat deze watch al op [2026-09-01] met Ring of Glory/Gnarldor
  had moeten leren en blijkbaar nog niet had beet. **Wat nog steeds niet vastgesteld is:**
  "Coalesced Venom" en "Virulent Mutation" (twee namen uit dezelfde 21-sep-hotfix) hebben in de
  repo geen eigen ID om op te zoeken; Wowheads tekst bij Toxic Deluge noemt "creating Coalesced
  Venom" als rechtstreeks gevolg van diezelfde cast, wat sterk suggereert dat het hetzelfde
  orb-object is dat wij al als "Green orbs" beschrijven, maar ik heb geen los ID om dat te
  bevestigen. INFERRED, niet MEASURED — blijft een open vraag, geen bevestigde afwezigheid.
  **[RAAKT ONS NIET]** op de kern-correctie (geen geshipte tekst wordt tegengesproken, het
  mechaniek is wél gedekt); geen actiepunt op deze vier namen. Rob/Cisca: als iemand ooit deze
  fight opnieuw naloopt, is dit gecontroleerd en gesloten, geen openstaand punt meer.

  **Vandaag verder: sectie "September 22, 2026" (nieuw sinds [2026-09-22]'s "21 sep") volledig
  zelf gelezen**, `news.blizzard.com/en-us/article/24296142?nocache=20260923` (via Exa). Categorieën
  die dag: Classes, Dungeons and Raids, Housing, Items, Player versus PvP — geen Delves-,
  Professions-, Quests- of Achievements-sectie (leeg, zoals gebruikelijk als Blizzard niets heeft).
  Positieve controle op cache-vers: deze sectie is nieuwer dan wat [2026-09-22] al kende ("21 sep"),
  en de PTR/roadmap- en data-wachter van vandaag zagen onafhankelijk dezelfde "22 sep"-sectie.

  **Bevindingen:**
  - **Dungeons and Raids — Altar of Fangs (Blade of the Altar's Laced Edge) en Temple of
    Sethraliss (Shrouded Fang's Slither Strike): beide konden casten tijdens crowd control, nu
    gefixed.** GEMETEN: "Blade of the Altar" en "Shrouded Fang" komen in geen enkel bestand voor
    (0 treffers repo-breed). Onze Altar-of-Fangs-tips dekken drie named encounters — Rav'i, Coil,
    Zul'jan (`Locales/DungeonTips.lua:460,468,476`) — en onze Temple-of-Sethraliss-tips dekken
    Adderis, Avatar, Galvazzt, Merektha (`Locales/DungeonTips.lua:540,548,556,564`); geen van
    beide bugfix-namen matcht een van deze acht bossen, dus dit raakt vermoedelijk trash/een
    tussenmob die wij niet tracken, niet een van onze geschreven fights. Positieve controle,
    zelfde repo-brede scope: "Zul'jan" en "Guillotine" geven wél treffers (7× in `RaidTips.lua`) —
    de nul hierboven is gemeten afwezigheid. **[RAAKT ONS NIET]**
  - **Housing — Rustbolt Jetpack krijgt een "firmware update"** ("Ocular Non-Obstruction Mode").
    Pure flavourtekst op een decor-item, geen mechaniek of ID. GEMETEN: 0 treffers op "Rustbolt
    Jetpack" repo-breed; MH heeft geen housing-decor-module. **[RAAKT ONS NIET]**
  - **Items — trinket-tuningronde (Preternatural Antivenom, Seed of Radiant Hope, Mycolic
    Medicine, Unstable Felheart Crystal, Ruby Whelp Shell omhoog; Gaze of the Alnseer, Vaelgor's
    Final Stare, Algeth'ar Puzzle Box omlaag).** GEMETEN: 0 treffers op alle acht itemnamen
    repo-breed (los gecontroleerd: "Vaelgor" zelf geeft wél treffers, maar dat is de boss
    Vaelgor & Ezzorak in `Locales/RaidTips.lua`/`Modules/RaidCoachData.lua` — een andere
    "Vaelgor" dan het trinket "Vaelgor's Final Stare"; geen naamcollision met een claim over dit
    item). Pure percentages op trinkets die wij niet bij naam noemen. **[RAAKT ONS NIET]**
  - **Classes en Player versus PvP:** uitsluitend spec-balanspercentages (San'layn, Aldrachi
    Reaver, Augmentation, Mistweaver, Windwalker e.v.a.) — gevestigd patroon, MH volgt geen
    rotatie- of balansgetallen. **[RAAKT ONS NIET]**

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260923 (volledig gelezen via
  Exa) · https://www.wowhead.com/spell=1298367, /spell=1299960, /spell=1282487, /spell=1298381,
  /spell=1300938 (elk met eigen cache-buster, via Exa `web_fetch_exa`) voor de correctie hierboven.
  Codebase-kant: `grep` case-insensitive/regex repo-breed op alle hierboven genoemde namen, plus
  gerichte reads van `Locales/RaidTips.lua`, `Locales/DungeonTips.lua` — allemaal vandaag gelezen.
  **[RAAKT ONS NIET]** op alle punten van vandaag; de correctie hierboven is het enige met een
  [RAAKT ONS]-geschiedenis, en die is nu gesloten. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.


- [2026-09-24] 🟢 **Eén nieuwe hotfix-sectie sinds gisteren (23 sep), en die raakt onze content niet.**
  GEMETEN: `news.blizzard.com/en-us/article/24296142` opnieuw gelezen (via Exa `web_fetch_exa`,
  elke aanroep met een eigen `?nocache=20260924`-variant, tweemaal met verschillende suffix om
  cache-versheid te bevestigen). De bovenste sectie is nu "September 23, 2026" — nieuwer dan wat
  [2026-09-23] al kende ("22 sep"), dus geen cache-treffer. Onafhankelijk bevestigd via
  `web_search_exa`: dezelfde 23-sep-tekst staat ook op bluetracker.gg, consolepcgaming.com en een
  pubt.io-spiegel, woordelijk gelijk.

  **Sectie "September 23, 2026" bevat precies twee categorieën: Classes en Delves.** Geen
  Professions-, Quests-, Dungeons and Raids-, Items- of Achievements-sectie die dag (leeg, zoals
  gebruikelijk als Blizzard daar niets heeft). Classes is uitsluitend Death Knight/Monk
  classbalans (Blightfall-tuning, Windwalker PvP/PvE-scheiding) — buiten scope, MH volgt geen
  rotatie- of balansgetallen.

  **Delves — de enige game-content wijziging van vandaag:** "Fixed issue where Valeera becomes
  unable to change talents and gain abilities after a faction change. Players experiencing this
  will need to enter a delve on the affected character, then leave the delve, and then log out to
  correct the issue." GEMETEN tegen `Modules/ValeeraProgress.lua` (volledig gelezen): die module
  leest alleen `GetFriendshipReputation` (chunks/XP-delta binnen een delve) en zegt nergens iets
  over talentkeuzes, abilities of faction change — repo-breed `grep -i "faction"` geeft buiten
  `docs/API_WATCH.md` (een ander, al gesloten punt) nul treffers, en `docs/PTR_VALEERA_TREE.md`
  noemt "faction" evenmin. Geen geshipte bewering wordt hierdoor tegengesproken of bevestigd — dit
  is een bug in Blizzards eigen talent-/abilities-toekenning, niet in een getal of naam die wij
  zelf claimen. **[RAAKT ONS NIET]**

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260924 en
  ?nocache=20260924b (beide volledig gelezen via Exa) · `web_search_exa` "World of Warcraft
  Midnight blue post Delves Professions Quests hotfix September 23 24 2026" (kruiscontrole tegen
  bluetracker.gg/arctium.io/pubt.io, geen extra content-secties gevonden). Codebase: volledige
  read van `Modules/ValeeraProgress.lua`, repo-brede `grep -i "faction"`. Geen actiepunt dat ík
  kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-09-25] 🟡 **Eén nieuwe hotfix-sectie sinds gisteren (24 sep) — een Delve-bugfix raakt exact
  de stap die onze eigen tip beschrijft, zonder hem tegen te spreken; bijvangst: een openstaand
  testpunt uit 17 sep lijkt intussen achterhaald.** GEMETEN: `news.blizzard.com`'s doorlopende
  hotfix-artikel opnieuw gelezen via Exa `web_fetch_exa` met `?nocache=20260925` — **volledige
  artikeltekst zelf gelezen**. Bovenste sectie is nu "September 24, 2026", nieuwer dan de
  "September 23"-sectie die gisteren al gelogd stond, dus geen cache-treffer. Onafhankelijk
  bevestigd via `web_search_exa`: Wowheads nieuwsartikel "More PvP Tuning - Patch 12.1 Hotfixes
  for September 24th" citeert dezelfde tekst woordelijk. Convergeert met de API-wachter van
  vandaag, die onafhankelijk dezelfde twee koppen zag (revisie `6886643`, Postlink "1-23" →
  "1-24"). Sectie 24 sep bevat precies twee categorieën: **Delves** en **Player versus Player** —
  geen Professions-, Quests-, Dungeons and Raids-, Items- of Achievements-sectie die dag (leeg,
  zoals gebruikelijk als Blizzard daar niets heeft).

  **Delves — de enige game-content wijziging:** *"In the Shadow Enclave delve variant 'Infiltrate
  and Ameliorate', Oddball 'Ingredient' now teleport to one of several points in the play space
  if dropped into the pit."* Achtergrond opgezocht (via `web_search_exa`): Wowheads NPC-pagina
  npc=271018 (Oddball "Ingredient") heeft spelerscommentaar dat de onderliggende bug beschrijft —
  *"if you die at the bottom of the pit while holding one, it will stay down there and the delve
  will be unable to be completed, forcing a reset"* — en een consolepcgaming.com-artikel (24 aug)
  bevestigt dezelfde klacht via een Reddit-report. Dit repareert dus een langer bekende
  reset-dwingende bug op **exact** de stap die onze eigen tip beschrijft.
  GEMETEN tegen `Locales/DelveTips.lua:36` (`DELVE_TIP_SHADOW_ENCLAVE_ROUTE`, enUS; zelfde patroon
  in alle zeven taalvarianten): *"Infiltrate and Ameliorate: sabotage 4 cauldrons by adding odd
  ingredients. Some ingredients sit up high: use the jumping mushrooms."* Onze tekst noemt geen
  "pit", geen valgevaar en geen waarschuwing om niet met een ingrediënt in handen te sterven —
  `grep -wi pit` op `Locales/DelveTips.lua` geeft alleen `DELVE_NAME_GRUDGE_PIT` terug (een andere,
  ongerelateerde delve-naam), 0 treffers op deze mechaniek. Positieve controle, zelfde bestand/
  scope: "Blessing of Freedom" geeft 14 treffers elders in de repo — het patroon werkt op deze
  schaal. Onze tip claimt dus niets over wat er gebeurt als je het ingrediënt laat vallen, dus
  geen tegenspraak — de hotfix maakt alleen een bug onschadelijk die al bestond terwijl onze tip
  al klopte. **[RAAKT ONS NIET]** — geen actiepunt, de tip blijft correct.

  **Player versus Player:** Hunter Wing Clip (40% snelheidsreductie in PvP), Improved Snaring
  (+10% op Wing Clip), Mage Arcane Chrono Shift (30%, was 50%), Paladin Consecrated Ground (20%,
  was 50%) — allemaal movement-speed-percentages. GEMETEN: 0 treffers op alle vier namen in
  `.lua`-bestanden buiten `docs/`/`tools/`/`dist/` (losse vermeldingen bestaan alleen in dev-docs
  als `docs/NEXT_SESSION.md` en `docs/API_WATCH.md`, geen geshipte speler-tekst). Gevestigd
  patroon: MH volgt geen rotatie- of PvP-balansgetallen. **[RAAKT ONS NIET]**

  **Terzijde, geen hotfix-bevinding maar tijdens deze sweep opgevallen:** `docs/TESTLIJST_ARCHIEF.md:77-80`
  heeft een nog open (`- [ ]`) testpunt van Rob, 17 sep, dat zegt dat de Shadow-Enclave-tips
  "niets" claimen over de Summoner-kick- en cauldron-ingrediëntstappen ("GEMETEN: summoner,
  cauldron en ingredient komen in geen enkele delvetip voor"). Dat klopt niet meer met wat er nu
  staat: `DELVE_TIP_SHADOW_ENCLAVE_ROUTE` (hierboven geciteerd) noemt expliciet "5 Ula'tek
  Summoners", "4 cauldrons" en "odd ingredients". Wanneer dat precies is toegevoegd kan ik niet
  vaststellen — deze checkout heeft maar 50 commits diepte, geen bruikbare geschiedenis voor dit
  bestand — dus ik claim niet wannéér het testpunt achterhaald raakte, alleen dat de huidige
  inhoud het weerlegt. MEASURED. Geen hotfix-gerelateerde tegenspraak, dus geen [RAAKT ONS]-vlag;
  ik verander niets aan `TESTLIJST_ARCHIEF.md` (niet mijn bestand) — Rob/wie dat bestand beheert
  kan het punt afvinken of opnieuw testen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260925 (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft hotfixes September 24 2026 Shadow Enclave Infiltrate
  and Ameliorate Oddball Ingredient" (Wowhead-nieuwsartikel + Wowhead NPC-pagina npc=271018 +
  consolepcgaming.com als achtergrond op de bug, niet als hotfix-bron zelf) ·
  `docs/API_WATCH.md`'s entry van vandaag als aanleiding voor de doorverwijzing (feit niet
  herhaald, wel zelf getoetst tegen `Locales/DelveTips.lua`). Codebase: `grep` case-insensitive/
  woordgrens repo-breed op alle hierboven genoemde namen, plus gerichte reads van
  `Locales/DelveTips.lua:34-38` en `docs/TESTLIJST_ARCHIEF.md:75-81` — allemaal vandaag gelezen.
  **[RAAKT ONS NIET]** op de hotfix-vergelijking; het testlijst-zijspoor is geen contradictie maar
  een gemeten inconsistentie voor een mens om te sluiten. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

---

- [2026-09-26] 🔁 **Geen nieuwe hotfix-sectie sinds gisteren (24 sep) — tweede dag op rij, zelf
  gemeten.** GEMETEN: `news.blizzard.com`'s doorlopende hotfix-artikel opnieuw gelezen via Exa
  `web_fetch_exa` met `?nocache=20260926z` — volledige artikeltekst t/m de "September 22, 2026"-
  sectie zelf gelezen. Bovenste sectie blijft **"September 24, 2026"** (Delves: Shadow Enclave/
  Oddball Ingredient-teleport; Player versus Player: movement-speed-tuning) — byte-voor-byte gelijk
  aan wat al volledig gelogd staat op [2026-09-25]. Geen Professions-, Quests-, Dungeons and Raids-,
  Items- of Achievements-sectie op 22/23/24 sep (leeg, zoals gebruikelijk). **Positieve controle
  tegen de cache-val:** `web_search_exa` op "hotfixes September 25/26 2026" vindt geen artikel
  nieuwer dan Wowheads "More PvP Tuning"-stuk (gepubliceerd 25 sep 01:03 UTC, over dezelfde 24-sep-
  sectie); drie onafhankelijke spiegels (pubt.io, consolepcgaming.com, Wowhead Blue Tracker) citeren
  woordelijk dezelfde tekst zonder nieuwere datum — dus geen week-oude cache, gewoon geen nieuwe
  sectie. Convergeert met de data-wachter van vandaag (`docs/PTR_12.0.7_DATA.md`, entry
  [2026-09-26]: zelfde conclusie), hier onafhankelijk zelf herlezen, niet overgenomen. Niets nieuws
  om tegen de repo te toetsen — geen codebase-vergelijking nodig. **[RAAKT ONS NIET]** — bron:
  https://news.blizzard.com/en-us/article/24296142?nocache=20260926z (volledig gelezen via Exa) ·
  `web_search_exa` "World of Warcraft Midnight hotfixes September 25 OR September 26 2026 Delves
  Professions Quests" (nieuwste treffer blijft 24 sep). Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

---

- [2026-09-27] 🔁 **Derde dag op rij zonder nieuwe hotfix-sectie sinds 24 sep — zelf gemeten, geen
  codebase-vergelijking nodig.** GEMETEN: `news.blizzard.com`'s doorlopende hotfix-artikel
  rechtstreeks gelezen via Exa `web_fetch_exa` met `?nocache=20260927x` — **volledige artikeltekst
  zelf gelezen** (niet alleen een samenvatting). Bovenste sectie is nog steeds **"September 24,
  2026"** (Delves: Shadow Enclave/Oddball "Ingredient"-teleport; Player versus Player: Wing
  Clip/Improved Snaring/Chrono Shift/Consecrated Ground-bewegingssnelheid), byte-voor-byte gelijk
  aan wat al volledig gelogd staat op [2026-09-25] en herbevestigd op [2026-09-26]. Geen
  Professions-, Quests-, Dungeons and Raids-, Items- of Achievements-sectie sinds 24 sep (leeg,
  zoals gebruikelijk als Blizzard daar niets heeft).

  **Positieve controle tegen de cache-val, in dezelfde run:** een gerichte `web_search_exa`-
  zoekslag op dezelfde vraag geeft resultaten met eigen, latere publicatiedata terug (o.a.
  consolepcgaming.com, gepubliceerd 24 sep 01:36 UTC, en Wowheads "More PvP Tuning"-artikel,
  gepubliceerd 25 sep 01:03 UTC) die woordelijk dezelfde 22/23/24-sep-inhoud citeren als hierboven
  — het zoeksysteem levert dus vers materiaal, en het ontbreken van een sectie ná 24 sep is een
  echte afwezigheid, geen week-oude cache. Een tweede, breder gerichte zoekslag op Delves/
  Professions/Quests-nieuws van 26/27 sep leverde uitsluitend al bekend materiaal op: dezelfde
  24-sep-hotfixtekst, Icy Veins' Delves-/professiongidsen (ongewijzigd sinds hun eigen laatste
  changelog-datums, 3 en 9 aug) en het BlizzCon-12.2-roadmapnieuws van 13 sep — niets met een
  publicatiedatum ná 24 sep dat Delves/Professions/Quests/Dungeons and Raids/Items raakt. Dit
  convergeert met de PTR- en data-wachter van vandaag (beiden onafhankelijk ook nog op de 24-sep-
  sectie/build 69952), hier zelf opnieuw gemeten, niet overgenomen.

  Geen nieuwe hotfix-inhoud in mijn lane, dus geen codebase-vergelijking te doen vandaag. **[RAAKT
  ONS NIET]** — bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260927x
  (volledig gelezen via Exa) · `web_search_exa` "World of Warcraft Midnight patch 12.1 hotfixes
  September 26 OR September 27 2026 Delves Professions Quests Dungeons Raids Items" en "World of
  Warcraft Midnight news Delves Professions Quests update September 26 27 2026" (nieuwste treffer
  blijft 24 sep). Vandaag is zondag, dus de wekelijkse play-card- en consumables-checks (alleen
  maandag) zijn overgeslagen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-09-28] 🔁 **Vierde dag op rij zonder nieuwe hotfix-sectie sinds 24 sep — geen
  codebase-vergelijking nodig. Wél de allereerste weekly play-card- en consumables-check (vandaag
  maandag), grotendeels geen afwijking.** GEMETEN: `news.blizzard.com`'s doorlopende hotfix-artikel
  rechtstreeks gelezen via Exa `web_fetch_exa` met `?nocache=20260928a` — **volledige artikeltekst
  zelf gelezen**. Bovenste sectie is nog steeds **"September 24, 2026"** (Delves: Shadow
  Enclave/Oddball "Ingredient"-teleport; Player versus Player: Wing Clip/Improved Snaring/Chrono
  Shift/Consecrated Ground), byte-voor-byte gelijk aan wat al volledig gelogd staat op
  [2026-09-25]. **Positieve controle tegen de cache-val:** `web_search_exa` op dezelfde vraag
  geeft mirrors met eigen, latere publicatiedata (pubt.io, consolepcgaming.com, playnews.gg,
  us.forums.blizzard.com) die woordelijk dezelfde 22/23/24-sep-inhoud citeren — het zoeksysteem
  levert dus vers materiaal, en het ontbreken van een sectie ná 24 sep is een echte afwezigheid,
  geen week-oude cache. Geen Professions-, Quests-, Dungeons and Raids-, Items- of
  Achievements-sectie sinds 24 sep (leeg, zoals gebruikelijk). Geen nieuwe hotfix-inhoud in mijn
  lane, dus geen codebase-vergelijking vandaag. **[RAAKT ONS NIET]**

  🃏 **Kaarten:** Vandaag is de allereerste maandag sinds deze wekelijkse check op 25 sep is
  ingevoerd — dus de eerste keer dat hij daadwerkelijk draait. `Modules/PlayCards.lua` heeft 40
  specs; elke `source`-regel noemt Icy Veins en/of Method en/of Wowhead met een datum.
  **Methode:** voor elke spec de bron die het kaartje zelf noemt herlezen (niet zomaar Icy Veins
  gepakt omdat de URL toevallig bestaat) en de datum die de pagina nu zelf toont vergelijken met
  onze geciteerde datum — nieuwer dan onze datum = mogelijk gedrift, ouder of gelijk = niets
  gebeurd sinds we keken.
  - **33 van de 40 specs gecontroleerd** (alle waar Icy Veins of, bij afwezigheid daarvan, Method
    in de bron staat, plus Restoration Druid/Holy Paladin/Balance Druid/Brewmaster Monk op hun
    Method-pagina): Blood/Frost/Unholy Death Knight, Havoc/Vengeance/Devourer Demon Hunter,
    Preservation Evoker, Arcane/Fire/Frost Mage, Beast Mastery/Marksmanship/Survival Hunter,
    Windwalker/Mistweaver/Brewmaster Monk, Protection/Retribution/Holy Paladin,
    Discipline/Holy/Shadow Priest, Elemental/Enhancement/Restoration Shaman,
    Affliction/Demonology/Destruction Warlock, Arms/Fury/Protection Warrior, Restoration/Balance
    Druid. In alle 33 gevallen toont de pagina zelf een "Last Updated" op of vóór onze geciteerde
    datum — dus **niets gedrift**: "guide ongewijzigd sinds we keken". GEMETEN (elke datum
    rechtstreeks van de pagina gelezen via Exa, geen samenvatting).
  - **Eén kaart met een echte, kleine afwijking: Devourer Demon Hunter (1480).** Onze bron zegt
    "Icy Veins 17 Aug"; Icy Veins' eigen rotatiepagina (`devourer-demon-hunter-pve-dps-guide`)
    noemt in zijn eigen wijzigingenlijst "18 Aug. 2026 (rotation page): Updated for August 18th
    tuning" — één dag ná onze controledatum. Vergeleken: de huidige prioriteitstekst noemt
    Consume/Reap/Soul Immolation/Voidblade/Vengeful Retreat/The Hunt/Void Metamorphosis/Void Ray in
    dezelfde volgorde en rollen als `PLAYCARD_1480_S1`-`_S5` in `Locales/enUS.lua:1220-1225` — geen
    knoppen toegevoegd, verwijderd of van plaats gewisseld. MEASURED: datum verschilt één dag, tekst
    komt overeen. Geen actiepunt.
  - **Eén onzekerheid, geen kaartfout: Survival Hunter (255).** Onze bron zegt "Icy Veins 30 Aug",
    maar Icy Veins' eigen rotatiepagina (`survival-hunter-pve-dps-rotation-cooldowns-abilities`)
    toont nu zelf "Last Updated: Jul 16, 2026" en patchlabel **12.0.7** — dus ouder dan onze eigen
    controledatum, en op een ouder patchlabel. Dit kán betekenen dat Icy Veins die specifieke
    pagina nooit heeft doorontwikkeld voor 12.1 (en op 30 aug dus al net zo gedateerd was, dus geen
    nieuw gat), of dat de meting van 30 aug een andere/gecachte versie zag. Ik kan het verschil niet
    verklaren zonder de check van 30 aug zelf te kunnen inzien. Geen bewijs dat `PLAYCARD_255_*`
    fout is, wel een vlag voor een mens: de pagina die als bron dient is op dit moment zélf niet
    12.1. **Niet als kaartfout gemeld — als open vraag.**
  - **7 specs NIET gecontroleerd deze run** (budget): Feral Druid (103), Guardian Druid (104),
    Assassination Rogue (259), Outlaw Rogue (260), Subtlety Rogue (261), Devastation Evoker (1467),
    Augmentation Evoker (1473) — allemaal specs waarvan de bron alleen Method+Wowhead noemt, geen
    Icy Veins, en waar ik geen tijd meer had om de exacte Method/Wowhead-pagina op te zoeken. Dit
    zijn kaarten die dus **niet als fris gemeld worden** — ze zijn gewoon niet bekeken.
  - **Class-hotfixes van de afgelopen week die HOE je speelt raken (niet alleen schadegetallen):**
    gecontroleerd tegen de 22-24 sep classes-sectie (hierboven en op [2026-09-24]/[2026-09-25]
    gelogd) — Death Knight (Blood/Frost/Unholy/San'layn), Demon Hunter (Devourer/Havoc
    Vengeance Aldrachi Reaver), Druid (Wildstalker/Feral/Restoration), Monk (Windwalker, bugfix).
    Op alle punten: percentages op schade/genezing, een procKans (Broken Spirit 15%→20%) of een
    bugfix — geen enkele voegt een knop toe, haalt er een weg, of verandert een volgorde. MEASURED.
    **Geen kaart hoeft hierdoor aangepast.**

  🧪 **Consumables:** Ook de eerste keer dat deze check draait. `tools/check_consumables.py` gaf
  op alle 39 specs `Tunnel connection failed: 403 Forbidden` (egress-proxy blokkeert Python's
  eigen urllib, zoals de opdracht al waarschuwde) — dus uitgeweken naar Icy Veins' eigen
  `*-gems-enchants-consumables`-pagina's via Exa, met dezelfde datum-eerst-methode. Referentiepunt:
  `data/consumables_wowhead.json`'s `meta.patchedSince` noemt al een volledige check tegen Icy
  Veins 12.1 op **14 sep 2026** ("flask and combat potion agree for all specs") — dus alleen een
  "Last Updated" ná 14 sep betekent dat er iets kán zijn veranderd sinds die laatste volledige
  vergelijking.
  - **Alle 39 specs uit `data/vault_stat_catalog.json` plus Devourer Demon Hunter (niet in die
    catalog, apart opgezocht) gecontroleerd op datum.** 38 van de 40 tonen "Last Updated" vóór
    14 sep 2026 — niets gebeurd sinds de laatste volledige vergelijking. GEMETEN (elke datum
    rechtstreeks van de pagina).
  - **Eén pagina ná 14 sep bijgewerkt: Beast Mastery Hunter (253),** `Last Updated: Sep 15, 2026`.
    Diepgelezen: flask-sectie noemt "Flask of the Magisters" als beste keuze (onze `best`:
    Flask of the Magisters, id 241322 — komt overeen); potion-sectie noemt "Potion of Recklessness"
    als default (onze `best`: Potion of Recklessness, id 241288 — komt overeen). MEASURED: pagina
    bijgewerkt, maar flask en combat-potion ongewijzigd. **Geen verschil te melden.**
  - Food niet apart nagekeken deze run (de instructie zelf noemt food "noisy"); geen enkele
    flask/potion-pagina die ik las noemde een item dat wij niet al voeren.
  - **Hotfix/patch van de afgelopen week die een consumable toevoegt of van werking verandert:**
    de Items-secties van 17-24 sep (hierboven gelogd) noemen alleen genezingstrinket-tuning
    (Preternatural Antivenom, Seed of Radiant Hope, Mycolic Medicine, Unstable Felheart Crystal,
    Ruby Whelp Shell, Gaze of the Alnseer, Vaelgor's Final Stare, Algeth'ar Puzzle Box) — trinkets,
    geen flask/potion/food. **Niets gevonden.**

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260928a (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes September 27 OR September 28 2026
  Delves Professions Quests Dungeons Raids Items" (nieuwste treffer blijft 24 sep) ·
  `Modules/PlayCards.lua` (volledig gelezen) · `Locales/enUS.lua:1220-1229` ·
  `data/vault_stat_catalog.json` · `data/consumables_wowhead.json` · circa 45 Icy Veins-pagina's
  (rotation-cooldowns-abilities en gems-enchants-consumables, per spec) gelezen via Exa
  `web_fetch_exa`, plus drie Method.gg-pagina's (Holy Paladin, Balance Druid, Brewmaster Monk) via
  `web_search_exa` · `tools/check_consumables.py` (gedraaid, gaf `403 Forbidden` op alle specs).
  Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist over de open vraag bij
  Survival Hunter en over de 7 niet-gecontroleerde kaarten.

---

- [2026-09-29] 🔁 **Vijfde dag op rij zonder nieuwe hotfix-sectie sinds 24 sep — geen
  codebase-vergelijking nodig. Vandaag is dinsdag, dus geen wekelijkse kaarten-/consumables-check.**
  GEMETEN: `news.blizzard.com`'s doorlopende hotfix-artikel rechtstreeks gelezen via Exa
  `web_fetch_exa` met `?nocache=20260929a` — **volledige artikeltekst zelf gelezen**. Bovenste
  sectie is nog steeds **"September 24, 2026"** (Delves: Shadow Enclave/Oddball "Ingredient"-
  teleport; Player versus Player: Wing Clip/Improved Snaring/Chrono Shift/Consecrated Ground),
  byte-voor-byte gelijk aan wat al volledig gelogd staat op [2026-09-25] en herbevestigd op
  [2026-09-26] t/m [2026-09-28]. Geen Professions-, Quests-, Dungeons and Raids-, Items- of
  Achievements-sectie sinds 24 sep (leeg, zoals gebruikelijk als Blizzard daar niets heeft).

  **Positieve controle tegen de cache-val, in dezelfde run:** een gerichte `web_search_exa`-
  zoekslag op dezelfde vraag geeft resultaten met eigen, latere publicatiedata terug (o.a.
  consolepcgaming.com, gepubliceerd 24 sep 01:36 UTC, en playnews.gg, gepubliceerd 25 sep) die
  woordelijk dezelfde 22/23/24-sep-inhoud citeren als hierboven — het zoeksysteem levert dus vers
  materiaal, en het ontbreken van een sectie ná 24 sep is een echte afwezigheid, geen week-oude
  cache. Een tweede, apart gerichte zoekslag naar blue posts over Delves/Professions/Quests van de
  afgelopen dagen leverde uitsluitend al bekend materiaal op (dezelfde 22-24-sep-hotfixtekst en een
  oud "Unleash Your Skills in Midnight's New Delves"-blue-post van rond de release, geen datum na
  24 sep) — niets nieuws in mijn lane. Dit convergeert met de API-, PTR- en data-wachter van
  vandaag (commits `0921d45`, `845354f`, `645eb98`: alle drie onafhankelijk ook nog op de 24-sep-
  sectie/build 69952), hier zelf opnieuw gemeten, niet overgenomen.

  Geen nieuwe hotfix-inhoud in mijn lane, dus geen codebase-vergelijking te doen vandaag. **[RAAKT
  ONS NIET]** — bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260929a
  (volledig gelezen via Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes September 28
  OR September 29 2026 Delves Professions Quests Dungeons Raids Items" en "WoW Midnight blue post
  Delves OR Professions OR Quests update news September 29 2026" (nieuwste treffer blijft 24 sep).
  Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-09-30] 🟢 **Eerste nieuwe hotfix-sectie sinds 24 sep — "September 29, 2026" — één relevante
  wijziging, geen tegenspraak gevonden.** GEMETEN: `news.blizzard.com`'s doorlopende hotfix-artikel
  rechtstreeks gelezen via Exa `web_fetch_exa` met `?nocache=20260930a` — **volledige artikeltekst
  zelf gelezen**, niet via een samenvatting. De nieuwe sectie "September 29, 2026" bevat: Dungeons
  and Raids (Ula'tek), Events (Brewfest) en The Burning Crusade Classic (ander spel, niet retail —
  genegeerd). Geen Delves-, Professions-, Quests- of Items-sectie op 29 sep (leeg, zoals gebruikelijk
  wanneer Blizzard daar niets heeft). De onderliggende secties 24/23/22 sep in hetzelfde artikel zijn
  byte-voor-byte gelijk aan wat al volledig gelogd staat op [2026-09-24]/[2026-09-25] (inclusief de
  Valeera-faction-change-Delve-fix van 23 sep) — niet opnieuw doorgenomen.

  📌 **Positieve controle, repo-brede scope, zelfde run:** `grep -i "Mother's Wrath\|1298367"` vindt
  de spell-ID meteen terug in `Locales/RaidTips.lua:98` (zeven taalvarianten) — het patroon werkt op
  deze schaal, dus de 0-treffers hieronder op Brewfest zijn gemeten afwezigheid.

  **Bevindingen:**
  - **Dungeons and Raids — Ula'tek's Mother's Wrath: targeting-bugfix.** *"Fixed an issue with
    Ula'tek's Mother's Wrath where it can be cast at a target that isn't the current target if a
    non-target has higher threat but hasn't passed the threat threshold to force a target change."*
    Al gelogd als feit door de data-wachter van vandaag (`docs/PTR_12.0.7_DATA.md`, spell 1298367 —
    "al getrackt, levert geen nieuwe ID/drempel") — dat is zijn lane. Voor mijn lane: onze
    `RAID_BOSS_ULATEK_TANK` (`Locales/RaidTips.lua:98`, zeven taalvarianten) zegt "{SPELL:1298367}
    knocks you back and slows you ({SPELL:1300938}): get back into melee at once, or the raid takes
    the bites" — een generieke instructie voor wie geraakt wordt, geen claim over wélke eenheid
    Mother's Wrath onder threat-omstandigheden target. De bugfix verandert wie geraakt wordt, niet
    wat het effect doet, dus spreekt onze tekst niet tegen. MEASURED (spell-ID rechtstreeks in
    `RaidTips.lua:98` teruggevonden, zie positieve controle hierboven). **[RAAKT ONS NIET]**
  - **Events — Brewfest: loot van Coren Direbrew krijgt nu het vereiste level van de ontvanger.**
    0 treffers op "Brewfest"/"Direbrew"/"Grim Batol" repo-breed (case-insensitive) — we noemen
    Brewfest nergens, dus niets om tegen te spreken. MEASURED. **[RAAKT ONS NIET]**

  ⚠️ **Terzijde, niet mijn lane maar ter waarschuwing:** dezelfde dag verscheen ook een aparte
  nieuwsanalyse (archynewsy.com, gepubliceerd 29 sep) met concrete 12.1.5-launchdetails (Kith'ix-
  raid, Kindo'jan-labyrinth, Aqir-invasions, Ascendant-Venomstones-questlijn, crestcap-verval week
  van 21 okt). Dat is nog niet geshipte content — er valt op dit moment niets tegen te spreken — en
  de releasedatum zelf is vandaag al door de PTR-wachter gelogd (`docs/PTR_12.1_WATCH.md`, "12.1.5
  releasedatum aangekondigd (13/14 okt)"), dus niet hier herhaald als feit. Puur ter herinnering:
  zodra 12.1.5 live gaat is dit precies het soort content-tegenspraak dat deze watch moet vangen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20260930a (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes September 30 2026 Delves Professions
  Quests Dungeons Raids Items" (nieuwste inhoudelijke sectie blijft 29 sep; enige nieuwere treffer is
  de losse 12.1.5-aankondiging, hierboven als terzijde genoemd). Codebase-kant: `grep`
  case-insensitive repo-breed op "Mother's Wrath", "1298367", "Brewfest", "Direbrew", "Grim Batol",
  plus gerichte read van `Locales/RaidTips.lua:98` — allemaal vandaag gelezen. **[RAAKT ONS NIET]**
  op beide bevindingen. Vandaag is woensdag, dus de wekelijkse kaarten- en consumables-check
  (alleen maandag) is overgeslagen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens
  beslist.

---

- [2026-10-01] 🟡 **Geen nieuwe hotfix-sectie sinds 29 sep; wél één eigen tegenspraak gevonden,
  aangereikt door de data-wachter van vandaag.** `news.blizzard.com`'s doorlopende hotfix-artikel
  **volledig zelf gelezen** via Exa `web_fetch_exa` met `?nocache=20261001a`: bovenste sectie is nog
  steeds "September 29, 2026" (Ula'tek Mother's Wrath-targetingfix, Brewfest-Direbrew-loot), byte-
  voor-byte gelijk aan wat al volledig gelogd staat op [2026-09-30]. **Positieve controle tegen de
  cache-val, zelfde run:** een gerichte `web_search_exa` op "hotfixes September 30 OR October 1
  2026 Delves Professions Quests Dungeons Raids Items" geeft een publicnow.com-spiegel van dezelfde
  29-sep-lijst (eigen publicatiedatum 30 sep) en verder alleen al bekend materiaal (de 12.1.5-
  aankondiging van 29 sep, al als terzijde gelogd) — geen nieuwere sectie bestaat, geen kapotte
  zoekvorm. Een losse `web_search_exa` specifiek op "October 1 2026 blue post Delves Professions
  Quests" vond niets nieuws, alleen de (al bekende) Midnight Deep Dive/Q&A-livestream van vandaag,
  die PTR/roadmap-terrein is, niet het mijne. Vandaag is donderdag, dus geen wekelijkse kaarten- of
  consumables-check (alleen maandag).

  **Eigen vondst, niet uit de data-wachter overgenomen als feit maar zelf getoetst op tegenspraak:**
  de data-wachter van vandaag (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-01]) meldt, zelf gelezen op
  Wowhead/Icy Veins/Blizzardwatch, dat de wekelijkse Housing-quest (93769, "Midnight: Housing") wordt
  uitgedeeld door **Vaeli**, buiten de Silvermoon-bank, en noemt dat dichter bij API-terrein (NPC/
  gossip-matching) te liggen dan bij de zijne. Voor mijn lane is dat precies de vraag: spreekt dit
  een geshipte claim tegen? **Ja.** `Modules/ResetRoutine.lua:114-128` zet quest 93769 onder
  `GIVER_WEEKLIES["liadrin"]` (`name = "Lady Liadrin"`), in dezelfde pool als de andere twaalf
  Liadrin-weeklies, zonder uitzondering voor 93769. Die naam komt rechtstreeks in de speler-UI
  terecht: `HOME_ROUTINE_GIVER_PICKUP_FMT`/`_DONE_FMT`/`_TURNIN_FMT`/`_INLOG_FMT`/`_LOCKED_FMT`
  (`Locales/enUS.lua:1327-1330`) formatteren allemaal met `def.name`, dus de weekreset-routine toont
  letterlijk "Weekly (Lady Liadrin): pick it up next to the vault." voor de Housing-quest — terwijl
  geen van de drie bronnen Liadrin ergens noemt voor deze quest. Dezelfde naam staat ook in
  `Modules/SMCChecklistData.lua:23-26`/`UI.lua:1306` als label "Weekly Quest Givers" voor de
  gecombineerde kaartpin (map 2393, 48.95/64.92) die alle dertien Liadrin-quests samen bedient.
  MEASURED (code zelf gelezen, regelnummers hierboven). ⚠️ Wat ik NIET controleer: of 48.95/64.92
  ook Vaeli's eigen plek is — ik gok geen coördinaat, en de drie bronnen geven alleen "buiten de
  Silvermoon-bank/mailbox", geen in-game-coördinaat. **[RAAKT ONS]** — dit is een naam die de speler
  letterlijk op het scherm ziet en die drie onafhankelijke bronnen tegenspreken; geen actie van mij,
  een mens beslist of 93769 uit de Liadrin-pool moet of een eigen giver-naam/pin verdient.

  📌 **Positieve controle, zelfde repo-brede scope:** `grep -i liadrin` (hele repo) geeft 36
  bestanden met treffers terug — het patroon vindt dus ruimschoots iets op deze schaal; de claim
  hierboven komt uit die treffers zelf, niet uit een leeg resultaat.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261001a (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes September 30 OR October 1 2026
  Delves Professions Quests Dungeons Raids Items" en "WoW Midnight hotfixes October 1 2026 blue
  post Delves Professions Quests" (nieuwste inhoudelijke sectie blijft 29 sep) · `docs/
  PTR_12.0.7_DATA.md` entry [2026-10-01] als aanleiding (feit niet herhaald, alleen zelf getoetst op
  tegenspraak met geshipte MH-tekst) · codebase: gerichte reads van `Modules/ResetRoutine.lua:59-128`,
  `Locales/enUS.lua:1327-1330`, `Modules/SMCChecklistData.lua:23-26`, `UI.lua:1306`,
  `Modules/WeeklyHubProbe.lua` — allemaal vandaag gelezen, plus `grep -i liadrin` repo-breed. Geen
  actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-02] 💬 **CurseForge: geen open reacties (2 draadjes gelezen).** `curseforge.com/api/v1/
  mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261002z` via Exa (JSON, `pagination.
  totalCount` = 6 berichten = alle berichten in deze ene pagina). Draadje van **MrsBoojiePanda**
  (debug-regel in de chat bij elke login) kreeg een reply van `twelveinchy` als laatste bericht —
  beantwoord. Draadje van **gadrinonturalyon** (coffer-key-shards-popup, 3D-bossmodel) heeft
  `twelveinchy` tweemaal in de keten, met zijn eigen bericht als laatste (na een bedankje) —
  ook beantwoord. Geen enkel draadje heeft als laatste bericht iemand anders dan de maintainer, dus
  🔴 WAITING FOR AN ANSWER is niet van toepassing vandaag.

- [2026-10-02] 🟢 **Niets nieuws in mijn lane sinds [2026-10-01]; de ene echte wijziging (1 okt-
  hotfixsectie) is al getoetst door de API- en data-wachter van vandaag, en zelf herbevestigd.**
  Officiële hotfixpagina volledig gelezen via Exa (`news.blizzard.com/en-us/article/24296142
  ?nocache=20261002z`): de nieuwe sectie **"October 1, 2026"** telt drie regels — Druid/Feral en
  Hunter/Survival (class tuning, buiten mijn lane: Delves/Professions/Quests/Dungeons en Raids/
  Items, geen van die vijf) en, onder *Dungeons and Raids → The Venomous Abyss → Ula'tek*: *"Fixed
  an issue where the Venomous Heart would sometimes melee a player."* **Zelf getoetst, niet enkel
  overgenomen:** spell-ID **1286860** (Venomous Heart) staat in `Locales/RaidTips.lua:93,99,100`
  (en de zes andere taalvarianten) als *"Each {SPELL:1286860} exposes her Heart for 20 seconds:
  burn it and dodge the falling rocks"* (DPS/healer-regels erbij) — een generieke "venster om te
  burnen"-instructie, geen claim over wélke speler de Heart tijdens dat venster in melee raakt. De
  bugfix verandert gedrag van de cast, niet wat onze tip zegt te doen. MEASURED (zelf de hotfix-
  pagina gelezen, zelf `Locales/RaidTips.lua` gegrept op de spell-ID). **[RAAKT ONS NIET]**

  De **"September 24, 2026"**-sectie (Delves: Shadow Enclave/Oddball "Ingredient"-teleport) is de
  oudste nog getoonde sectie op de pagina en staat al uitgebreid gelogd op [2026-09-24] t/m
  [2026-09-30] hierboven (regels 1251-1328) — geen nieuwe informatie, 0 treffers op een tweede
  doorzoeking van die regels vandaag.

  📌 **Niet mijn terrein, alleen ter kennisgeving:** de **"12.1.5 Content Update Notes"**
  (`news.blizzard.com/en-us/article/24304162`), door de data-wachter van vandaag zelf gelezen voor
  de ACHIEVEMENTS-sectie, is 12.1.5-materiaal (releasedatum 13 okt, nog niet live) — er is dus nog
  niets geshipt om tegen te spreken. Zodra 12.1.5 live gaat, is dit precies de content die deze
  watch moet controleren tegen `Achievements.lua` en de delve/profession/quest-bestanden.

  ✅ **Positieve controle, zelfde scope als de nul-bevinding hierboven:** `grep -rn "1286860"
  Locales/` geeft treffers in alle zeven taalvarianten (niet nul) — het patroon en de scope werken
  dus, en de afwezigheid van een tegensprekende claim is gemeten, niet een kapotte grep.

  Vandaag is donderdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261002z (volledig gelezen via
  Exa) · `docs/PTR_12.0.7_DATA.md` entry [2026-10-02] en `docs/API_WATCH.md` entry [2026-10-02] als
  kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte MH-tekst) ·
  codebase: gerichte read van `Locales/RaidTips.lua:93-100` plus repo-brede grep op "1286860". Geen
  actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-03] 💬 **CurseForge: geen open reacties (2 draadjes gelezen, ongewijzigd t.o.v.
  gisteren).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261003` via Exa (JSON, `pagination.totalCount` = 6 berichten — zelfde aantal als
  [2026-10-02]). Draadje van **MrsBoojiePanda** (debug-regel bij login) eindigt met een reply van
  `twelveinchy` — beantwoord. Draadje van **gadrinonturalyon** (coffer-key-shards-popup, 3D-
  bossmodel) eindigt chronologisch ook met `twelveinchy`'s laatste bericht (ná gadrinonturalyon's
  bedankje) — beantwoord. Geen enkel draadje heeft als laatste bericht iemand anders dan de
  maintainer, dus 🔴 WAITING FOR AN ANSWER is niet van toepassing vandaag. Geen nieuwe berichten
  sinds [2026-10-02].

- [2026-10-03] 🔁 **Nog steeds niets nieuws sinds [2026-10-02] — zelf opnieuw gemeten, convergeert
  met de API- en data-wachter van vandaag.** `news.blizzard.com`'s doorlopende hotfix-artikel
  **volledig zelf gelezen** via Exa `web_fetch_exa` met `?nocache=20261003z`: bovenste sectie is nog
  steeds **"October 1, 2026"** (Druid/Feral *Rampant Ferocity*-bugfix, Hunter/Survival *Wildfire
  Bomb*-periodieke-schadecorrectie — beide class-balans, buiten mijn lane — en, onder *Dungeons and
  Raids → The Venomous Abyss → Ula'tek*: *"Fixed an issue where the Venomous Heart would sometimes
  melee a player"*, al getoetst en [RAAKT ONS NIET] bevonden op [2026-10-02]), byte-voor-byte gelijk
  aan wat toen gelogd staat. **Positieve controle tegen de cache-val, zelfde run:** een gerichte
  `web_search_exa` op "hotfixes October 2 OR October 3 2026 Delves Professions Quests Dungeons Raids
  Items" vindt uitsluitend al-bekend materiaal over de Oct-1-sectie (o.a. patchbot.io, gepubliceerd
  2 okt, toont nog steeds "Hotfixes: October 1, 2026" als nieuwste titel; een forumthread-spiegel
  waarvan de laatste post van vandaag (Linxy, 2 okt 00:02) nog steeds de Oct-1-inhoud citeert zonder
  vervolg) — dus geen kapotte zoekvorm, een echte afwezigheid van een nieuwere sectie. Delves,
  Professions en Quests zijn (en blijven) leeg in de Oct-1-sectie — niets om tegen de repo te
  toetsen. Dit convergeert met `docs/API_WATCH.md` ([2026-10-03]) en `docs/PTR_12.0.7_DATA.md`
  ([2026-10-03]), beiden vandaag onafhankelijk ook nog op "October 1" — niet overgenomen, zelf
  gelezen.

  📌 **Kruiscontrole, niet mijn feit:** de PTR-wachter bevestigt vandaag
  (`docs/PTR_12.1_WATCH.md:489-490`) dat 12.1.5 nog niet live is (releasedatum 13/14 okt) — dus geen
  trigger voor "elke kaart moet gecontroleerd worden" vandaag.

  Vandaag is zaterdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261003z (volledig gelezen via
  Exa) · `web_search_exa` "World of Warcraft Midnight hotfixes October 2 OR October 3 2026 Delves
  Professions Quests Dungeons Raids Items" (nieuwste sectie blijft 1 okt) · `docs/API_WATCH.md`
  entry [2026-10-03] en `docs/PTR_12.0.7_DATA.md` entry [2026-10-03] als kruiscontrole (feiten niet
  herhaald) · `docs/PTR_12.1_WATCH.md` entries [2026-10-03] voor de 12.1.5-livestatus. Geen
  actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-04] 💬 **CurseForge: geen open reacties (2 draadjes, 6 berichten — ongewijzigd t.o.v.
  gisteren).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261004d` via Exa (JSON, `pagination.totalCount` = 6 — zelfde aantal als [2026-10-03]).
  Draadje van **MrsBoojiePanda** (debug-regel bij login) eindigt met een reply van `twelveinchy` —
  beantwoord. Draadje van **gadrinonturalyon** (coffer-key-shards-popup, 3D-bossmodel) eindigt
  chronologisch ook met `twelveinchy`'s laatste bericht — beantwoord. Geen enkel draadje heeft als
  laatste bericht iemand anders dan de maintainer, dus 🔴 WAITING FOR AN ANSWER is niet van
  toepassing vandaag. Geen nieuwe berichten sinds [2026-10-03].

- [2026-10-04] 🟢 **Niets nieuws in mijn lane sinds [2026-10-03] — zelf opnieuw gemeten, vijfde dag
  op rij op "October 1".** Officiële hotfix-pagina volledig gelezen via Exa
  (`news.blizzard.com/en-us/article/24296142?nocache=20261004d`): nieuwste sectie blijft
  **"October 1, 2026"**, byte-voor-byte dezelfde drie regels als al verwerkt op [2026-10-02]/
  [2026-10-03] — Druid/Feral *Rampant Ferocity* en Hunter/Survival *Wildfire Bomb* (class-tuning,
  buiten mijn lane: Delves/Professions/Quests/Dungeons en Raids/Items) en, onder *Dungeons and
  Raids → The Venomous Abyss → Ula'tek*: de **Venomous Heart**-meleefix, al eerder zelf getoetst
  tegen spell-ID **1286860** in `Locales/RaidTips.lua:93,99,100` (zeven taalvarianten) op
  [2026-10-02] en [RAAKT ONS NIET] bevonden — geen nieuwe toetsing nodig, de tekst is ongewijzigd.
  De oudere secties (29 sep: Mother's Wrath-fix; 24 sep: Shadow Enclave Oddball-teleport) staan al
  uitgebreid gelogd in dit bestand op [2026-09-24] t/m [2026-09-30] en [2026-10-02] — geen nieuwe
  informatie bij herhaalde doorzoeking vandaag. Delves, Professions en Quests zijn leeg in alle vier
  getoonde secties — niets nieuws om tegen de repo te toetsen.

  📌 **Kruiscontrole, niet mijn feit, niet overgenomen als eigen vondst:** `docs/API_WATCH.md`
  ([2026-10-04]) en `docs/PTR_12.0.7_DATA.md` ([2026-10-04]) bevestigen onafhankelijk hetzelfde beeld
  (hotfixpagina op 1 okt, PTR-build 70077 nu 5 dagen oud, officiële 12.1.5 content-notes nog niet
  live — releasedatum 13/14 okt) — convergentie van vier onafhankelijke lezingen, geen reden om
  "elke kaart moet gecontroleerd worden" vandaag te triggeren.

  Vandaag is zondag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261004d (volledig gelezen via
  Exa) · https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261004d (volledig gelezen via Exa) · `docs/API_WATCH.md` entry [2026-10-04] en
  `docs/PTR_12.0.7_DATA.md` entry [2026-10-04] als kruiscontrole (feiten niet herhaald, alleen zelf
  getoetst op tegenspraak met geshipte MH-tekst). Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

---

- [2026-10-05] 💬 **CurseForge: geen open reacties (2 draadjes, 6 berichten — ongewijzigd t.o.v.
  gisteren).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261005a` via Exa (JSON, `pagination.totalCount` = 6 — zelfde aantal als [2026-10-04]).
  Draadje van **MrsBoojiePanda** (debug-regel bij login) eindigt met een reply van `twelveinchy` —
  beantwoord. Draadje van **gadrinonturalyon** (coffer-key-shards-popup, 3D-bossmodel) eindigt
  chronologisch ook met `twelveinchy`'s laatste bericht — beantwoord. Geen enkel draadje heeft als
  laatste bericht iemand anders dan de maintainer, dus 🔴 WAITING FOR AN ANSWER is niet van
  toepassing vandaag. Geen nieuwe berichten sinds [2026-10-04].

- [2026-10-05] 🟡 **Geen nieuwe hotfix-sectie sinds [2026-10-04] (zesde dag op "October 1, 2026") —
  wél de wekelijkse kaarten- en consumables-check (vandaag is maandag), met een flink aantal
  consumable-afwijkingen om aan Rob te melden.** `news.blizzard.com`'s doorlopende hotfix-artikel
  **volledig zelf gelezen** via Exa `web_fetch_exa` met `?nocache=20261005a`: bovenste sectie blijft
  **"October 1, 2026"** — Druid/Feral *Rampant Ferocity*-bugfix, Hunter/Survival *Wildfire Bomb*-
  periodieke-schadecorrectie (beide class-tuning, buiten mijn lane) en, onder *Dungeons and Raids →
  The Venomous Abyss → Ula'tek*: de **Venomous Heart**-meleefix, al eerder getoetst tegen spell-ID
  **1286860** in `Locales/RaidTips.lua:93,99,100` (zeven taalvarianten) op [2026-10-02] en [RAAKT ONS
  NIET] bevonden — tekst ongewijzigd, geen nieuwe toetsing nodig. Oudere secties (29/24/23/22 sep)
  staan al uitgebreid gelogd in dit bestand. Delves, Professions en Quests zijn en blijven leeg in
  alle getoonde secties — niets nieuws om tegen de repo te toetsen.

  📌 **Positieve controle tegen de cache-val, zelfde run:** `web_search_exa` op "World of Warcraft
  Midnight hotfixes October 4 OR October 5 2026 Delves Professions Quests Dungeons Raids Items"
  vindt geen hotfix-sectie nieuwer dan 1 okt — wel een pcgamesn.com-artikel (gepubliceerd 4 okt) dat
  zelf bevestigt: *"The next World of Warcraft Midnight class tuning patch goes live with weekly
  maintenance on Tuesday October 6."* De afwezigheid van een nieuwe sectie vandaag is dus verwacht,
  geen gok — en geen cache-val, want dezelfde zoekvorm vindt moeiteloos de 1-okt- en 29-sep-artikelen
  los van elkaar, dus hij kán nieuwere datums vinden als ze bestonden. ⚠️ **Niet mijn terrein, alleen
  ter kennisgeving:** datzelfde artikel en Blizzard's eigen "12.1.5 Content Update Notes" (24304162)
  beschrijven uitsluitend nog niet live content (Kith'ix-raid, Labyrinth of Kindo'jan, mid-season
  refresh vanaf week van 6 okt, Prey-catch-up-mechanics, drie achievements die niet meer vereist zijn
  voor "Glory of the Wartorn Hero") — releasedatum 13/14 okt, dus nog niets om tegen te spreken.
  PTR-wachter-terrein, hier niet als eigen feit herhaald.

  🃏 **Kaarten:** wekelijkse frisheidscheck van 2 okt t/m 5 okt 2026, specs uit `Modules/PlayCards.lua`
  (40 totaal). GEMETEN: voor Fury Warrior (72), Guardian Druid (104) en Demonology Warlock (266) zijn
  alle drie genoemde gidsen (Icy Veins/Method/Wowhead) rechtstreeks bij de bron opgehaald en hun
  "last updated"-datum komt exact overeen met wat in `source` staat — niets gewijzigd, kaart klopt
  nog. Voor Frost Mage (64), Feral Druid (103), Survival Hunter (255), Assassination/Outlaw/Subtlety
  Rogue (259/260/261), Restoration Shaman (264), Devastation Evoker (1467) en Augmentation Evoker
  (1473) is minstens één tot twee van de drie gidsen gemeten en kwam geen datum ná onze aantekening
  boven water (Augmentation Evokers Wowhead-rotatiepagina toonde zelfs "2026/04/25", ouder dan onze
  "17 Aug" — vermoedelijk een andere/stillere pagina, geen aanwijzing voor iets nieuwers). Conclusie
  voor deze 12 van de 40 specs: GEMETEN, geen update ná de datum die al in `source` staat, dus geen
  regel in `enUS.lua` hoeft aangepast. Bijzonderheid (GEMETEN, nocache-herhaald op Icy Veins Frost
  Mage): de "(Xd ago)"-labels kloppen structureel niet met vandaag (5 okt), maar de absolute datum
  zelf bleef identiek na `?nocache=20261005`, dus dat is een kalenderbugje op de bronsite zelf, geen
  Exa-cacheprobleem dat de inhoud vervalst. Hotfixes (GEMETEN via Wowhead/Icy Veins/1vX.gg): sinds
  28 sep 2026 is er geen LIVE 12.1-hotfix die een knop toevoegt/verwijdert of een drempelwaarde in de
  rotatie verandert — de enige wijzigingen van deze week staan in de 12.1.5-PTR-notes (29 sep, nog
  niet live; o.a. Protection Warrior Colossus Execute/Revenge -10 rage, Evoker/Hunter/Mage/Monk/
  Rogue/Shaman bugfixes) en tellen dus niet mee zolang ze op PTR staan. **Niet gecontroleerd** (28 van
  de 40 specs; vertrouwt op de interne aantekening "rechecked 3 Oct 2026 (mh-research)" in de code,
  niet vandaag zelf opnieuw bij de bron gemeten): Retribution Paladin (70), Protection Paladin (66),
  Arcane Mage (62), Elemental Shaman (262), Fire Mage (63), Holy Paladin (65), Arms Warrior (71),
  Protection Warrior (73), Balance Druid (102), Restoration Druid (105), Blood DK (250), Frost DK
  (251), Unholy DK (252), Beast Mastery Hunter (253), Marksmanship Hunter (254), Discipline Priest
  (256), Holy Priest (257), Shadow Priest (258), Enhancement Shaman (263), Affliction Warlock (265),
  Destruction Warlock (267), Brewmaster Monk (268), Windwalker Monk (269), Mistweaver Monk (270),
  Havoc DH (577), Vengeance DH (581), Preservation Evoker (1468), Devourer DH (1480).

  🧪 **Consumables:** `tools/check_consumables.py` kon niet bellen (EGRESS_BLOCKED/403 Forbidden op
  alle 39 Icy Veins-URL's, GEMETEN) — uitgeweken naar Exa met `?nocache=20261005` op elke URL; de
  "Last Updated"-datums op de pagina's liepen netjes door tot en met 15 sep 2026, geen aanwijzing voor
  een stale cache. Alle 39 specs uit `vault_stat_catalog.json` zijn bekeken, met twee uitzonderingen
  (zie onder). GEMETEN verschillen tussen pagina (eerste vermelding) en onze `best`-pick:
  - Death Knight Frost flask: pagina zegt "Flask of the Shattered Sun" ("you generally want to use …
    in all content"), wij zeggen Flask of the Magisters.
  - Death Knight Unholy flask: pagina zegt "Use Flask of the Shattered Sun as your go-to choice",
    wij zeggen Flask of the Magisters.
  - Druid Balance potion: pagina zegt "The best DPS potion is Potion of Recklessness", wij zeggen
    Light's Potential.
  - Evoker Devastation potion: pagina noemt alleen Potion of Recklessness of Draught of Rampant
    Abandon; Light's Potential (onze pick) komt op die pagina niet eens voor.
  - Evoker Preservation flask: pagina zegt "Flask of the Magisters will be your go-to choice", wij
    zeggen Flask of the Blood Knights (Magisters staat bij ons alleen als alternate).
  - Evoker Augmentation potion: pagina zegt "we recommend using … Potion of Recklessness in all
    content if Mastery is your highest stat" (het normale geval), wij zeggen Light's Potential.
  - Monk Brewmaster potion: pagina's algemene aanbeveling is "Liquid Luster is your general
    recommended potion" — dat item bestaat helemaal niet in onze data (0 treffers, nieuw/ongeshipt
    item); wij zeggen Draught of Rampant Abandon, dat de pagina zelf alleen als beperkte
    single-target uitzondering noemt.
  - Monk Windwalker flask: pagina zegt "Flask of the Blood Knights is the recommended choice for all
    content", wij zeggen Flask of the Shattered Sun.
  - Priest Shadow potion: pagina zegt "Our theoretical best combat potion in all content is Potion
    of Recklessness … If you are not using this potion, Light's Potential is a solid alternative",
    wij zeggen Light's Potential (de pagina's fallback, niet de hoofdkeuze).
  - Paladin Holy flask: pagina zegt "Flask of the Magisters will be your go-to choice for maximizing
    your healing output", wij zeggen Flask of the Blood Knights.
  - Rogue Subtlety potion: pagina zegt "The best general stat potion is Light's Potential", wij
    zeggen Potion of Recklessness (dat de pagina alleen als AoE-uitzondering noemt).
  - Warlock Affliction potion: pagina zegt "Potion of Recklessness should be the first choice if your
    gearset has little to no Versatility" (de normale situatie), wij zeggen Light's Potential.
  - Warlock Demonology potion: zelfde patroon/zelfde zin op de pagina, wij zeggen Light's Potential.
  - Warlock Destruction flask: pagina zegt "Flask of the Shattered Sun is the default choice", wij
    zeggen Flask of the Magisters. Potion bij Destruction: zelfde Recklessness-eerst-zin als bij de
    andere twee Warlock-specs (tekst afgebroken in de fetch, AFGELEID uit het identieke patroon op
    Affliction/Demonology), wij zeggen Light's Potential.
  - Warrior Protection potion: pagina zegt "Light's Potential is your best potion in every scenario"
    en noemt Draught of Rampant Abandon expliciet als de risicovolle, niet-aangeraden optie
    (voidzones die silencen), wij zeggen Draught of Rampant Abandon.

  Food/feast-namen (Hearty Harandar Celebration vs Hearty Silvermoon Parade, "Hearty" vs niet) kwamen
  overal voor maar zijn per opdracht dezelfde buff — geen van die gevallen gerapporteerd. Geen enkele
  spec miste zijn augment rune (Void-Touched Augment Rune overal consistent) of personal food (Hearty
  Royal Roast overal consistent). **Niet te checken:** Demon Hunter Devourer (derde DH-spec,
  bevestigd bestaand via de hotfix van 1 okt 2026 "Devourer … Annihilator hero talent", maar staat
  niet in `vault_stat_catalog.json`'s 39 URL's en heeft `sourcePages: []` — geen Icy Veins-pagina om
  tegen te toetsen); Shaman Enhancement combat-potion (pagina brak af net vóór de potion-sectie, flask
  kon wel gecheckt worden en komt overeen met onze dubbele Blood Knights/Magisters-pick). Hotfixes
  afgelopen week (sinds 28 sep): GEMETEN via news.blizzard.com (met nocache) — hotfixes 29 sep en
  1 okt 2026 bevatten alleen class-tuning en dungeon-fixes, geen enkele wijziging aan een flask,
  potion, food of augment rune.

  ⚠️ **Zijspoor, het melden waard:** `data/consumables_wowhead.json`'s `patchedSince`-notitie claimt
  dat op 14 sep 2026 "flask and combat potion agree for all specs" — dat klopt niet meer met wat
  vandaag GEMETEN is op minstens dertien specs hierboven, waarvan meerdere pagina's hun huidige tekst
  al vóór 14 sep droegen. Of de controle destijds te losjes was, of de pagina's zijn sindsdien
  herschreven zonder hun datum te veranderen — dit is niet uitgezocht, puur de tegenspraak met onze
  eigen aantekening gemeld. Niets in de repo aangepast; dit is alleen een rapport, een mens beslist.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261005a (volledig gelezen via
  Exa) · https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261005a (volledig gelezen via Exa) · `web_search_exa` "World of Warcraft Midnight
  hotfixes October 4 OR October 5 2026 Delves Professions Quests Dungeons Raids Items" (nieuwste
  sectie blijft 1 okt) · pcgamesn.com-artikel 4 okt 2026 (bevestigt volgende tuning-patch op 6 okt) ·
  Blizzard's "12.1.5 Content Update Notes" (24304162, ter kennisgeving, nog niet live) · wekelijkse
  kaartencheck: Icy Veins/Method/Wowhead rotatiepagina's voor 12 van 40 specs, via Exa met
  `?nocache=20261005` · wekelijkse consumables-check: `tools/check_consumables.py` (EGRESS_BLOCKED,
  uitgeweken naar Exa) op 39 Icy Veins gems-enchants-consumables-pagina's, `?nocache=20261005` op elke
  URL. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-06] 💬 **CurseForge: geen open reacties (2 draadjes, 6 berichten — ongewijzigd t.o.v.
  gisteren).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261006a` via Exa (JSON, `pagination.totalCount` = 6 — zelfde aantal als [2026-10-05]).
  Draadje van **MrsBoojiePanda** (debug-regel bij login) eindigt met een reply van `twelveinchy` —
  beantwoord. Draadje van **gadrinonturalyon** (coffer-key-shards-popup, 3D-bossmodel) eindigt
  chronologisch ook met `twelveinchy`'s laatste bericht — beantwoord. Geen enkel draadje heeft als
  laatste bericht iemand anders dan de maintainer, dus 🔴 WAITING FOR AN ANSWER is niet van
  toepassing vandaag. Geen nieuwe berichten sinds [2026-10-05].

- [2026-10-06] 🔴 **Geen nieuwe rolling-hotfixsectie (zevende dag op "October 1, 2026"), MAAR een
  aparte, vandaag geplaatste blue post — "Incoming Ula'tek Raid Encounter Tuning - October 6" — raakt
  rechtstreeks meerdere spell-ID's uit onze geshipte `RAID_BOSS_ULATEK_*`-tips. Geen tegenspraak
  gevonden, wel een stevige bevestiging én twee afgesloten open vragen uit deze watch's eigen
  geschiedenis.** `news.blizzard.com`'s doorlopende hotfix-artikel **volledig zelf gelezen** via Exa
  `web_fetch_exa` met `?nocache=20261006a`: bovenste sectie blijft **"October 1, 2026"**, byte-voor-
  byte dezelfde drie regels (Druid/Feral, Hunter/Survival, Venomous-Heart-meleefix) als al verwerkt
  — dat dekt zich met de data-wachter en PTR-wachter van vandaag, die hetzelfde zagen. **Positieve
  controle tegen de cache-val:** `web_search_exa` op "World of Warcraft hotfixes October 5/6 2026"
  vindt geen hotfixartikel nieuwer dan 1 okt, maar vindt wél correct gedateerde artikelen van
  vandaag zelf — de zoekmethode kan dus wél nieuwere datums vinden, het ontbreken is dus een echte
  afwezigheid.

  ⚠️ **Twee aparte live tuningrondes gingen vandaag met de wekelijkse maintenance in, buiten de
  rolling-hotfixpagina om (bevestigd: de PTR-wachter zag beide vanochtend als vers forumverkeer op
  `arctium.io/blue-posts/875`):**
  1. **"Incoming Class Tuning - October 6"** (Linxy, forumpost 2 okt, vandaag live) — pure class-/
     PvP-balanspercentages (Unholy DK Blightfall 200%→100% plague damage, Devourer DH +8%/+10% op
     een reeks abilities, Brewmaster Monk Quick Sip/Pretense of Instability, Mistweaver Monk
     Invigorating Mists/Enveloping Mist +15%, Subtlety Rogue Trickster-knooppunt, Enhancement Shaman
     +4%/+35%). Gevestigd patroon: Midnight Helper volgt geen rotatie-/balansgetallen
     (`HealerCooldowns.lua`, `TankToolkit.lua`, `KeybindRoles_*.lua` registreren alleen spell-ID's
     voor keybind-layout, geen percentages). Ook al bewust overgeslagen door de data-wachter vandaag
     (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-06]) — niet opnieuw als eigen vondst geteld.
     **[RAAKT ONS NIET]**
  2. **"Incoming Ula'tek Raid Encounter Tuning - October 6"** (Linxy, `us.forums.blizzard.com/en/wow/
     t/incoming-ulatek-raid-encounter-tuning-october-6/2373623`, geplaatst vandaag 02:44 UTC) —
     **volledig zelf gelezen, rechtstreeks op de officiële forumpagina, inclusief de reacties
     eronder (geen samenvatting).** Dit is wél mijn lane: een encounter-tuningpas op precies de boss
     waar `RAID_BOSS_ULATEK_*` (`Locales/RaidTips.lua:93-100`, zeven taalvarianten) tips over geeft.
     Letterlijke inhoud: Spectral Coils-schade -20% (Heroic/Mythic); Warden's Protection-schade -80%,
     minder grondmarkers bij Virulent Spit, Grasping Fangs periodieke schade -30% (Heroic/Mythic),
     Blight Vein-duur 6→4s (Heroic/Mythic) (allemaal Stage 02); Blightscale Shrieker/Clutch- en
     Slithering Clutch-HP -20%, Circling Prey raid-schade -30% (Heroic/Mythic), Serpent's Bite
     Drain Rate aangepast zodat nooit meer dan 3 spelers hoeven te soaken ongeacht raidgrootte,
     Toxic Burn-schade -30% (Mythic), Caustic Waves-golven van 7 naar 3 op Mythic (allemaal Stage 03).

  📌 **Om dit te toetsen moest ik, zoals de opdracht vraagt, van onze eigen {SPELL:id}'s naar namen
  — niet andersom.** `RAID_BOSS_ULATEK_STEPS/TANK/HEALER/DPS` noemen negen spell-ID's
  (1300530, 1298559, 1292188, 1286860, 1301118, 1295905, 1312967, 1301510, 1300685); elk
  opgezocht op Wowhead (`wowhead.com/spell=<id>`, via Exa, `?nocache=20261006d`, **rechtstreeks
  gelezen, geen samenvatting**). Resultaat, MEASURED:
  - **1300530 = Spectral Coils.** Staat in onze tip vier keer (STEPS: "a {SPELL:1300530} soak",
    "the {SPELL:1300530} circles", "soak every {SPELL:1300530}"; HEALER: "cooldowns for
    {SPELL:1300530}"). Vandaag -20% schade (Heroic/Mythic). Onze tekst noemt geen percentage, dus
    niets om tegen te spreken — maar dit is wel de mechaniek waar onze tip het vaakst over gaat, nu
    met een bevestigd cijfer erbij. **[RAAKT ONS]**
  - **1301118 = Grasping Fangs.** STEPS: "Snap a {SPELL:1301118} chain by running away from its
    anchor" (fase 2) en "Snap {SPELL:1301118} chains in a called order" (Heroic/Mythic fase 3).
    Vandaag periodieke schade -30% (Heroic/Mythic). Bevestigt meteen dat `Modules/RaidCoachData.lua
    :125-128`'s eigen herkomst-commentaar klopt: die noemt 1301118 expliciet als "Grasping Fangs"
    via DBM, en Wowhead geeft dezelfde naam — twee onafhankelijke bronnen voor dezelfde ID, geen
    gok. **[RAAKT ONS]**
  - **1292188 = Caustic Waves** (niet "Phase 1 alleen" zoals de Wowhead-tekst zou doen vermoeden —
    onze TANK-tip gebruikt hem ook los: "Swap during {SPELL:1292188}"). STEPS: "Dodge
    {SPELL:1292188}: ... watch the tail's waves too." Vandaag: golvenaantal van 7 naar 3 op Mythic.
    Onze tekst noemt geen aantal golven, dus geen tegenspraak — wel dezelfde mechaniek die vandaag
    merkbaar milder wordt voor wie hem op Mythic al kent. **[RAAKT ONS]**
  - **1286860 = Rage of the Shackled, NIET "Venomous Heart".** Wowhead: "Ula'tek rages ... Flying
    into this rage exposes Ula'tek's Venomous Heart" — Venomous Heart is dus wat de spell blootlegt,
    niet de naam van de spell zelf. 🔴 **Correctie op deze watch's eigen geschiedenis:** de entries
    van [2026-09-02], [2026-09-03], [2026-10-02] en [2026-10-05] noemen 1286860 zelf steeds
    "Venomous Heart". Onze geshipte tekst zelf beweert dit nooit (DPS-tip zegt alleen "hit {the}
    exposed Heart", nooit de spell-ID's eigen naam) — dus geen addon-fout, puur een onnauwkeurigheid
    in mijn eigen eerdere logboek, nu rechtgezet. Geen tuning vandaag op deze ID.
  - **1295905 = Serpent's Bite, 1312967 = Volatile Purge — en dit sluit de "onbeslisbare" vraag van
    [2026-09-05] af.** Die entry kon toen niet vaststellen of "Ingested Venom"/"Serpent's Bite" een
    van de toen-geshipte soak-ID's (1300530, 1299757, 1300685) was — de tip-tekst is sindsdien
    herschreven en gebruikt nu andere ID's. STEPS zegt nu: "{SPELL:1295905} marks three players:
    split up and stand in their circles until it fades, then spread for {SPELL:1312967}." Wowhead
    1295905: "shoots fangs into several players ... players within 7 yards may leech the venom to
    remove it but become infected with Volatile Purge" — dat is "stand in hun circles" (samen
    staan om te leechen) gevolgd door "spread" (Volatile Purge raakt spelers "near the purge").
    Vandaags tuningregel noemt Serpent's Bite expliciet als een soak-mechaniek ("no longer need
    more than 3 people to soak regardless of raid size"), wat bij deze lezing past. Niet 100%
    woordelijk hetzelfde als Wowheads generieke tooltip, dus ⚠️ niet keihard bevestigd — maar wel
    een aannemelijke match, en in elk geval geen tegenspraak. **[RAAKT ONS]**, geen actie.
  - **1298559 = Gore Rattle, 1300685 = Soul Constrictor, 1301510 = Circling Prey.** Alle drie
    kloppen met hun eigen tip-zinnen (staart/tank-swap, "stops a soaker from helping with the next
    soak", "destroys the platform") — geen van deze drie kreeg vandaag een tuningregel. Ter
    kennisgeving, geen bevinding.

  **Wat vandaag WEL genoemd wordt maar NIET in onze geshipte tekst staat** (repo-breed gegrept,
  case-insensitive, Locales/ én Modules/ én docs/): Warden's Protection (0 treffers buiten een oude
  `docs/NEXT_SESSION_ARCHIVE.md`-regel), Virulent Spit (0 treffers, hele repo), Blight Vein (0
  treffers in Locales/Modules, alleen in deze watch's eigen geschiedenis en `PTR_12.1_WATCH.md`),
  Blightscale Clutch en Slithering Clutch (alleen in het dev-document `docs/PTR_S2_ENCOUNTERS.md`,
  niet geshipt), Toxic Burn (alleen in deze watch's eigen geschiedenis). 📌 **Positieve controle,
  zelfde repo-brede scope:** dezelfde zoekvorm vond zonder moeite "Spectral Coils", "Grasping
  Fangs", "Caustic Waves" én "Blightscale Shrieker" (zie hierboven) — het patroon werkt dus op deze
  schaal, de nul-treffers hierboven zijn gemeten afwezigheid. **[RAAKT ONS NIET]** voor deze zes.

  ✅ **Eén naam troffen we wél aan, met NAAM in plaats van ID:** `RAID_BOSS_ULATEK_DPS`
  (`Locales/RaidTips.lua:100`, zeven taalvarianten): "Interrupt Malice (Warden), Anguished Cry
  (Weakened Doomscale) and, in phase 3, Vicious Echoes (Blightscale Shrieker); kill the Shriekers
  fast." Vandaag: Blightscale Shrieker-HP -20% (Heroic/Mythic). Onze tip claimt geen HP-getal, dus
  geen tegenspraak — een lagere HP-pool maakt "kill the Shriekers fast" eenvoudiger, niet fout.
  MEASURED. **[RAAKT ONS]**

  ⚠️ **Niet mijn terrein, alleen ter kennisgeving:** de "week van 6 okt"-start van Orin Straylights
  extra Nebulous Voidcore (quest "Prismatic Potential" → "Umbral Blessings of the Catalyst") gaat
  volgens Blizzards eigen 12.1.5-notes vandaag in. Dit staat al als open vraag #7 in
  `docs/PATCH_12_1_5_CHECKLIST.md:66` ("telt de extra Voidcore van Orin mee in de bestaande
  bonus-roll-regel van `VaultAdvisor`, of krijgt hij een eigen regel?") en als geplande rij
  "week 6 okt" op regel 74 — niet opnieuw als eigen vondst gemeld, wel de vinger erbij dat vandaag
  de dag is waarop dat venster opengaat. `VaultAdvisor.lua:1091`'s `VOIDCORE_SLOTS_REQUIRED = 3`
  (het Great-Vault-knop-mechaniek) is een ander, apart systeem dan Orin's questketen en wordt door
  vandaags nieuws niet tegengesproken. Geen actie van mij; een mens beslist.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261006a (volledig gelezen via
  Exa) · https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261006a (volledig gelezen via Exa) ·
  https://us.forums.blizzard.com/en/wow/t/incoming-ulatek-raid-encounter-tuning-october-6/2373623
  (volledig gelezen via Exa, inclusief reacties) · negen Wowhead `spell=`-pagina's
  (1300530, 1298559, 1292188, 1286860, 1301118, 1295905, 1312967, 1301510, 1300685), elk met
  `?nocache=20261006d`, via Exa · codebase: `grep` case-insensitive over Locales/, Modules/ én
  docs/ op alle hierboven genoemde namen, plus gerichte reads van `Locales/RaidTips.lua`,
  `Modules/RaidCoachData.lua`, `Modules/VaultAdvisor.lua`, `docs/PATCH_12_1_5_CHECKLIST.md` —
  allemaal vandaag gelezen · `docs/PTR_12.0.7_DATA.md` entry [2026-10-06] en `docs/PTR_12.1_WATCH.md`
  entries [2026-10-06] als kruiscontrole (feiten niet herhaald, alleen zelf getoetst). Geen
  actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-07] 💬 **CurseForge: 🔴 één nieuw, nog onbeantwoord draadje (esMX kiest geen Spaans) —
  de twee bekende draadjes blijven beantwoord (3 draadjes, 7 berichten — was 2/6 op
  [2026-10-05]/[2026-10-06]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0
  &pageSize=20&nocache=20261007e` via Exa, volledig gelezen (JSON), `pagination.totalCount` = 7.

  - 🔴 **Nieuw — 2026-10-06 21:34 UTC, `user_uvqy5939hswhgduu`:** meldt dat de addon in het Spaans
    (Mexico) niet overschakelt naar Spaans en in Engels blijft staan. Zegt dat `GetLocale()` daar
    `"esMX"` teruggeeft, niet `"esES"`, en heeft zelf `Locales/esES.lua` lokaal gepatcht met een
    extra `or GetLocale() == "esMX"` om het werkend te krijgen — verliest die patch bij elke
    update. Geen reply van `twelveinchy`. Nog open.
  - **MrsBoojiePanda** (debug-regel bij login) en **gadrinonturalyon** (coffer-key-shards-popup /
    3D-bossmodel): beide draadjes eindigen nog steeds met een reply van `twelveinchy` —
    onveranderd beantwoord t.o.v. gisteren.

  📌 **Zelf getoetst in de code, niet alleen de speler geloofd.** `Locales/Locale.lua:33` heeft al
  een alias `esMX = "esES"`, bedoeld om `/mh lang auto` op een esMX-client naar het Spaanse pack
  te sturen, en `CHANGELOG.md:1768` (versie **1.3.2**, 2026-05-23, released) claimt die
  esMX-mapping al sinds die versie. Maar `Locales/esES.lua:17` gebruikt zijn eigen, kale
  `if GetLocale() ~= "esES" then return end` als laad-gate op het bestand zelf — op een
  esMX-client is dat waar, dus de hele pack-tabel `ns._mhLocales.esES` wordt nooit gevuld, en
  `ns:HasLocalePack("esES")` (`Locale.lua:98-99`, vereist een niet-lege tabel) valt terug op
  enUS. De alias in de taalkeuzelogica en de laad-gate in het packbestand spreken elkaar dus
  tegen — de speler heeft precies de kant gepatcht die het probleem veroorzaakt. MEASURED.
  **[RAAKT ONS]** — geen fix door mij, een mens beslist; de fix is vermoedelijk één regel
  (dezelfde alias toepassen vóór de gate-check in `esES.lua:17`, zoals `Locale.lua:110` al doet).

  Concept-antwoord: Thanks for the detailed report and the workaround, user_uvqy5939hswhgduu!
  You found a real inconsistency: the addon does have logic meant to map the esMX client locale
  to the Spanish pack, but the pack file's own loading check only recognizes esES, so on an esMX
  client it never builds the Spanish text and silently falls back to English. We'll look into
  fixing that properly so you won't need to reapply your patch after every update.
  Basis: MEASURED — `Locales/esES.lua:17` (kale `GetLocale() ~= "esES"`-gate) negeert de
  esMX→esES-alias die al in `Locales/Locale.lua:33` staat, waardoor `ns._mhLocales.esES` nooit
  gevuld wordt op een esMX-client; niet gefixed in een released versie (`CHANGELOG.md:1768`,
  v1.3.2, claimt alleen de taalkeuze-mapping, niet de pack-laad-gate).

- [2026-10-07] 🔁 **Geen nieuwe hotfix-sectie sinds [2026-10-06] (nog steeds "October 6, 2026" als
  bovenste sectie) — geen nieuwe Delves/Professions/Quests/Items-inhoud, niets nieuws om tegen de
  repo te toetsen.** `news.blizzard.com`'s doorlopende hotfix-artikel **volledig zelf gelezen** via
  Exa `web_fetch_exa` met `?nocache=20261007e`: bovenste sectie is nog steeds **"October 6, 2026"**
  met dezelfde drie categorieën als gisteren al verwerkt — Classes (pure klassentuning, buiten mijn
  lane), Dungeons and Raids (de Ula'tek-encountertuning die ik op [2026-10-06] al regel-voor-regel
  tegen `RAID_BOSS_ULATEK_*` getoetst heb, byte-voor-byte dezelfde cijfers, geen nieuwe toetsing
  nodig) en Player versus PvP (een brede PvP-talent-pass, buiten mijn lane). **Delves, Professions
  en Quests: leeg** in deze sectie (Blizzard laat lege categorieën gewoon weg, zelfde patroon als
  eerdere dagen) — niets om te vergelijken.

  Dit convergeert met de API-, PTR- en data-wachter van vandaag, die onafhankelijk dezelfde
  "October 6"-sectie als nieuwste zagen (niet overgenomen als feit, zelf opnieuw gelezen en
  hierboven uit de eigen fetch geciteerd). De data-wachter ving vandaag ook terecht een eigen
  cache/zoek-valkuil (twee "nieuwe" zoekresultaten die uit oudere secties van dezelfde rollende
  pagina kwamen, 23 sep en 1 sep) — dat is zijn fact-check op zijn eigen methode, niet hier als
  eigen vondst herhaald.

  Vandaag is woensdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261007e (volledig gelezen via
  Exa) · https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261007e (volledig gelezen via Exa) · codebase: gerichte reads van
  `Locales/esES.lua`, `Locales/Locale.lua`, `CHANGELOG.md`, plus `grep` case-insensitive op
  "esMX"/"esES" over de hele repo — allemaal vandaag gelezen · `docs/API_WATCH.md` entry
  [2026-10-07], `docs/PTR_12.1_WATCH.md` entries [2026-10-07] en `docs/PTR_12.0.7_DATA.md` entry
  [2026-10-07] als kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met
  geshipte MH-tekst). Geen actiepunt dat ík kan oppakken buiten het melden van de esMX-bug — ik
  rapporteer, een mens beslist.

---

- [2026-10-08] 💬 **CurseForge: geen open reacties (3 draadjes gelezen) — het esMX-draadje van
  gisteren is beantwoord.** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261008f` (en `&nocache=20261008g` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8** (was 7 op [2026-10-07]); die ene
  nieuwe regel is geen nieuw draadje maar Robs eigen reply.

  - Het esMX-draadje (`user_uvqy5939hswhgduu`, gemeld als 🔴 open op [2026-10-07]) heeft nu een
    reply van `twelveinchy` (datePosted 1791351710373, ≈ 6/7 okt 2026): *"your fix was exactly
    right! The Spanish translation only loaded for 'esES', so Latin American clients ('esMX')
    stayed in English. It is fixed for the next update..."* — bevestigt de eigen diagnose van
    [2026-10-07] woordelijk. Niet meer open.
  - **MrsBoojiePanda** (debug-regel bij login) en **gadrinonturalyon** (coffer-key-shards-popup /
    3D-bossmodel): nog steeds onveranderd beantwoord, nieuwste bericht in beide draadjes blijft
    van `twelveinchy`.

  Geen nieuwe draadjes sinds gisteren. MEASURED. **[RAAKT ONS NIET]** als actiepunt vandaag — de
  esMX-fix zelf staat nog open in de code (`Locales/esES.lua:17`), maar dat is al gemeld op
  [2026-10-07] en een mens beslist wanneer dat wordt opgepakt.

- [2026-10-08] 🔁 **Geen nieuwe hotfix-sectie sinds [2026-10-06] — Delves/Professions/Quests/
  Items blijven leeg in de nieuwste sectie, niets om tegen de repo te toetsen.**
  `news.blizzard.com`'s doorlopende hotfix-artikel **volledig zelf gelezen** via Exa
  `web_fetch_exa` met `?nocache=20261008f` en, voor de hele pagina in één keer (groter
  uittreksel dan de eerste fetch), `?nocache=20261008h`: de bovenste sectie is nog steeds
  **"October 6, 2026"**, met uitsluitend **Classes** (klassen-/PvP-tuning, buiten mijn lane),
  **Dungeons and Raids** (de Ula'tek-encountertuning die ik op [2026-10-06] al regel-voor-regel
  tegen `RAID_BOSS_ULATEK_*`/`Locales/RaidTips.lua` getoetst heb, inclusief negen losse
  Wowhead-spell-ID-opzoekingen — vandaag byte-voor-byte dezelfde cijfers, geen nieuwe toetsing
  nodig) en een brede **Player versus PvP**-talentpas (buiten mijn lane). **Delves, Professions,
  Quests en Items: leeg** in de "October 6"-sectie (Blizzard laat lege categorieën gewoon weg,
  zelfde patroon als eerdere dagen) — niets om te vergelijken. De oudere secties die bij deze
  volledige-pagina-fetch zichtbaar werden (1 okt: Feral Druid/Survival Hunter-classtuning +
  Ula'tek Venomous-Heart-melee-fix; 29 sep: Mother's Wrath-fix; 24 sep: Shadow Enclave
  Oddball-"Ingredient"-teleport) staan al eerder in deze log verwerkt (de Shadow-Enclave-fix
  sinds [2026-09-25], regels 1251-1291) en zijn vandaag alleen herbevestigd als nog steeds
  onveranderd, niet opnieuw als vondst geteld.

  Dit convergeert met de API-, PTR- en data-wachter van vandaag (`docs/API_WATCH.md`
  entry [2026-10-08], `docs/PTR_12.1_WATCH.md` entries [2026-10-08], `docs/PTR_12.0.7_DATA.md`
  entry [2026-10-08]), die onafhankelijk dezelfde "October 6"-sectie als nieuwste zagen — niet
  overgenomen als feit, zelf opnieuw gelezen en hierboven uit de eigen fetch geciteerd. De
  data-wachter noemt vandaag ook een nieuwe NPC "Wah'du" bij de Labyrinths (Myth 1/6-gear via
  3× Mythical Soul Fragment) — dat is 12.1.5-PTR-materiaal dat pas op 13/14 okt live gaat, dus
  `docs/PTR_12.1_WATCH.md`'s terrein, niet het mijne; niet als eigen vondst herhaald.

  Vandaag is donderdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261008f en
  ?nocache=20261008h (beide volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261008f/g (volledig gelezen via Exa) · `docs/API_WATCH.md` entry [2026-10-08],
  `docs/PTR_12.1_WATCH.md` entries [2026-10-08] en `docs/PTR_12.0.7_DATA.md` entry [2026-10-08]
  als kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte
  MH-tekst). **[RAAKT ONS NIET]** — geen van de gevonden hotfixes (of het ontbreken van nieuwe)
  spreekt een geshipte claim tegen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens
  beslist.

---

- [2026-10-09] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-08]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261009a` (en `&nocache=20261009b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8**, zelfde als gisteren. Alle drie de
  draadjes (esMX-locale, MrsBoojiePanda's debug-regel, gadrinonturalyon's coffer-key/3D-model-
  verzoek) hebben als nieuwste bericht nog steeds een reply van `twelveinchy`; geen nieuwe
  reacties sinds [2026-10-08]. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt vandaag.

- [2026-10-09] 🔁 **Vierde dag op "October 6, 2026" als nieuwste hotfix-sectie — zelf opnieuw
  gelezen, niets nieuws in mijn lane.** `news.blizzard.com/en-us/article/24296142` **volledig
  gelezen** via Exa `web_fetch_exa`, twee onafhankelijke fetches (`?nocache=20261009a` en
  `?nocache=20261009c`, de laatste met een groter uittreksel dat ook de oudere secties
  "October 1", "September 29", "September 24", "September 23" en het begin van "September 22"
  teruggaf). Een `web_search_exa` naar "World of Warcraft hotfixes October 2026" bevestigt
  hetzelfde via drie onafhankelijke bronnen (de gewone en de en-gb `news.blizzard.com`-pagina,
  Wowhead's Blue Tracker, `worldofwarcraft.blizzard.com/en-us/news`): overal is **"October 6,
  2026"** nog de nieuwste sectie, geen nieuw artikel erna. De Oct 6-sectie bevat alleen
  **Classes** (klassen-/PvP-tuning, buiten mijn lane) en **Dungeons and Raids** (dezelfde
  Ula'tek-encountertuning als op [2026-10-06] al regel-voor-regel tegen `RAID_BOSS_ULATEK_*`/
  `Locales/RaidTips.lua` getoetst — vandaag niet opnieuw getoetst, want geen nieuwe regel erin
  t.o.v. die datum). **Delves, Professions, Quests en Items: leeg** in de "October 6"-sectie —
  niets om tegen de repo te vergelijken. De oudere secties die bij de grote fetch zichtbaar
  werden, staan al eerder in deze log verwerkt (Oct 1: Venomous Heart-melee-fix, Sep 29:
  Mother's Wrath, Sep 24: Shadow Enclave Oddball-"Ingredient"-teleport, Sep 23: de Valeera-
  faction-change-delvebug) en zijn vandaag alleen herbevestigd als nog steeds onveranderd, niet
  opnieuw als vondst geteld. Positieve controle: de tekst van de Oct 6-sectie komt letterlijk
  overeen tussen de twee onafhankelijke Exa-fetches en de drie losse bronnen uit de zoekopdracht
  — geen cache-mismatch zoals op 3 sep.

  Dit convergeert met de API-, PTR- en data-wachter van vandaag (`docs/API_WATCH.md` entry
  [2026-10-09], `docs/PTR_12.1_WATCH.md` entry [2026-10-09] en `docs/PTR_12.0.7_DATA.md` entry
  [2026-10-09]), die onafhankelijk dezelfde "October 6"-sectie als nieuwste zagen — niet
  overgenomen als feit, zelf opnieuw gelezen en hierboven uit de eigen fetches geciteerd.

  Vandaag is vrijdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261009a en ?nocache=20261009c
  (beide volledig gelezen via Exa) · web-zoekopdracht naar "World of Warcraft hotfixes October
  2026" (vier onafhankelijke treffers, allemaal "October 6" als nieuwste) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261009a/b (volledig gelezen via Exa) · `docs/API_WATCH.md` entry [2026-10-09],
  `docs/PTR_12.1_WATCH.md` entry [2026-10-09] en `docs/PTR_12.0.7_DATA.md` entry [2026-10-09]
  als kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte
  MH-tekst). **[RAAKT ONS NIET]** — geen van de gevonden hotfixes (of het ontbreken van nieuwe)
  spreekt een geshipte claim tegen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens
  beslist.

---

- [2026-10-10] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-09]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261010a` (en `&nocache=20261010b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8**, zelfde als op [2026-10-08] en
  [2026-10-09]. Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`, MrsBoojiePanda's
  debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog
  steeds een reply van `twelveinchy`; geen nieuwe reacties sinds [2026-10-09]. MEASURED.
  **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf (`Locales/esES.lua:17`)
  staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat wordt opgepakt.

- [2026-10-10] 🔁 **Vijfde dag op "October 6, 2026" als nieuwste hotfix-sectie — zelf opnieuw
  gelezen, niets nieuws in mijn lane.** `news.blizzard.com/en-us/article/24296142` **volledig
  gelezen** via Exa `web_fetch_exa`, twee onafhankelijke fetches (`?nocache=20261010a` en
  `?nocache=20261010c`, de laatste met een groot uittreksel dat ook de oudere secties "October 1",
  "September 29", "September 24", "September 23" en het begin van "September 22" teruggaf). Beide
  fetches geven **"Hotfixes: October 6, 2026"** als titel/bovenste sectie, met `published:
  2026-10-06` — geen nieuwer artikel, byte-voor-byte dezelfde tekst als de twee onafhankelijke
  fetches van [2026-10-09]. Geen cache-val: de titel zelf draagt de datum, en die is niet ouder
  dan wat gisteren al gelogd stond.

  De "October 6"-sectie bevat uitsluitend **Classes** (klassen-/PvP-tuning — Death Knight Unholy,
  Demon Hunter Devourer, Monk Brewmaster/Mistweaver, Rogue Subtlety, Shaman Enhancement — buiten
  mijn lane), **Dungeons and Raids** (Venomous Abyss → Ula'tek: Spectral Coils -20%, Toxic Burn
  -30% Mythic, Caustic Waves-golven 7→3 Mythic, Warden's Protection -80%, Grasping Fangs -30%,
  Blight Vein-duur 6→4s, Blightscale Shrieker/Clutch/Slithering Clutch -20% HP, Circling Prey
  -30%, Serpent's Bite-drain-rate "max 3 man soak, ongeacht raidgrootte") en een brede **Player
  versus PvP**-talentpas (tank Focused Assault, DK/DH/Druid/Evoker/Hunter/Mage/Monk/Paladin/
  Priest/Rogue/Shaman/Warlock/Warrior PvP-talenten — buiten mijn lane). Dit zijn precies dezelfde
  Ula'tek-cijfers die ik op [2026-10-06] al regel-voor-regel tegen `RAID_BOSS_ULATEK_STEPS`/
  `Locales/RaidTips.lua` getoetst heb (inclusief de losse Wowhead-spell-ID-opzoekingen) — vandaag
  niet opnieuw getoetst, want geen nieuwe regel erin t.o.v. die datum en geen van de huidige
  nummers is sindsdien veranderd. **Delves, Professions, Quests en Items: leeg** in de
  "October 6"-sectie (Blizzard laat lege categorieën gewoon weg) — niets om tegen de repo te
  vergelijken. De oudere secties die bij de grote fetch zichtbaar werden (1 okt: Venomous Heart-
  melee-fix; 29 sep: Mother's Wrath; 24 sep: Shadow Enclave Oddball-"Ingredient"-teleport; 23 sep:
  Valeera-faction-change-delvebug) staan al eerder in deze log verwerkt en zijn vandaag alleen
  herbevestigd als nog steeds onveranderd, niet opnieuw als vondst geteld.

  Dit convergeert met de API-, PTR- en data-wachter van vandaag (`docs/API_WATCH.md` entry
  [2026-10-10], `docs/PTR_12.1_WATCH.md` entry [2026-10-10] en `docs/PTR_12.0.7_DATA.md` entry
  [2026-10-10]), die onafhankelijk dezelfde "October 6"-sectie als nieuwste zagen — niet
  overgenomen als feit, zelf opnieuw gelezen en hierboven uit de eigen fetches geciteerd.

  Vandaag is zaterdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261010a en ?nocache=20261010c
  (beide volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261010a/b (volledig gelezen via Exa) · `docs/API_WATCH.md` entry [2026-10-10],
  `docs/PTR_12.1_WATCH.md` entry [2026-10-10] en `docs/PTR_12.0.7_DATA.md` entry [2026-10-10]
  als kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte
  MH-tekst). **[RAAKT ONS NIET]** — geen van de gevonden hotfixes (of het ontbreken van nieuwe)
  spreekt een geshipte claim tegen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens
  beslist.

---

- [2026-10-11] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-10]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261011a` (en `&nocache=20261011b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8**, zelfde als op [2026-10-08] t/m
  [2026-10-10]. Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`, MrsBoojiePanda's
  debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog
  steeds een reply van `twelveinchy`; geen nieuwe reacties sinds [2026-10-10]. MEASURED.
  **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf (`Locales/esES.lua:17`)
  staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat wordt opgepakt.

- [2026-10-11] 🔁 **Zesde dag op "October 6, 2026" als nieuwste hotfix-sectie — zelf opnieuw
  gelezen, niets nieuws in mijn lane.** `news.blizzard.com/en-us/article/24296142` **volledig
  gelezen** via Exa `web_fetch_exa` (`?nocache=20261011a`), met `published: 2026-10-06` — niet
  ouder dan wat gisteren al gelogd stond, dus geen cache-val. Onafhankelijk bevestigd met
  `web_search_exa` naar "World of Warcraft hotfixes October 2026 Blizzard": zes treffers
  (news.blizzard.com, de en-gb-spiegel, Wowhead Blue Tracker, patchbot.io, nerfradar.com),
  stuk voor stuk "October 6, 2026" als nieuwste, niets ouder en niets nieuwer. De sectie bevat
  uitsluitend **Classes** (Death Knight Unholy, Demon Hunter Devourer, Monk Brewmaster/
  Mistweaver, Rogue Subtlety, Shaman Enhancement — buiten mijn lane) en **Dungeons and Raids**
  (Venomous Abyss → Ula'tek: Spectral Coils -20%, Toxic Burn -30% Mythic, Caustic Waves-golven
  7→3 Mythic, Warden's Protection -80%, Grasping Fangs -30%, Blight Vein-duur 6→4s, Blightscale
  Shrieker/Clutch/Slithering Clutch -20% HP, Circling Prey -30%, Serpent's Bite-soak "max 3 man
  ongeacht raidgrootte") en een brede **Player versus PvP**-talentpas (tank Focused Assault,
  diverse klassen — buiten mijn lane) — byte-voor-byte dezelfde cijfers als op [2026-10-06] al
  regel-voor-regel tegen `RAID_BOSS_ULATEK_STEPS`/`Locales/RaidTips.lua` getoetst, vandaag niet
  opnieuw getoetst want geen nieuwe regel erin. **Delves, Professions, Quests en Items: leeg**
  in de "October 6"-sectie (Blizzard laat lege categorieën gewoon weg) — niets om tegen de repo
  te vergelijken.

  Dit convergeert met de API-, PTR- en data-wachter van vandaag (`docs/API_WATCH.md` entry
  [2026-10-11], `docs/PTR_12.1_WATCH.md` entries [2026-10-11] en `docs/PTR_12.0.7_DATA.md` entry
  [2026-10-11]), die onafhankelijk dezelfde "October 6"-sectie als nieuwste zagen en het nieuwe
  dat zij vonden — PTR-build 70077 nog steeds ongewijzigd, en 12.1.5-materiaal (Orin Straylight/
  Ascendant Venomstones, Labyrinth of Kindo'jan, Renown Catch-Up Vendor) dat pas op 13 okt live
  gaat — als hún lane beoordelen, niet de mijne; niet overgenomen als eigen vondst.

  Vandaag is zondag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261011a (volledig gelezen via
  Exa) · web-zoekopdracht naar "World of Warcraft hotfixes October 2026 Blizzard" (zes
  onafhankelijke treffers, allemaal "October 6" als nieuwste) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261011a/b (volledig gelezen via Exa) · `docs/API_WATCH.md` entry [2026-10-11],
  `docs/PTR_12.1_WATCH.md` entries [2026-10-11] en `docs/PTR_12.0.7_DATA.md` entry [2026-10-11]
  als kruiscontrole (feiten niet herhaald, alleen zelf getoetst op tegenspraak met geshipte
  MH-tekst). **[RAAKT ONS NIET]** — geen van de gevonden hotfixes (of het ontbreken van nieuwe)
  spreekt een geshipte claim tegen. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens
  beslist.

- [2026-10-12] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-11]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261012a` (en `&nocache=20261012b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8**, zelfde als op [2026-10-08] t/m
  [2026-10-11]. Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`, MrsBoojiePanda's
  debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog
  steeds een reply van `twelveinchy`; geen nieuwe reacties sinds [2026-10-11]. MEASURED.
  **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf (`Locales/esES.lua:17`)
  staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat wordt opgepakt.

- [2026-10-12] 🟡 **Zevende dag op "October 6, 2026" als nieuwste hotfix-sectie, niets nieuws in
  Delves/Professions/Quests/Items — maar de wekelijkse consumables-check (vandaag maandag) vond
  een paar afwijkingen om aan Rob te melden; de kaarten-check niet.**

  `news.blizzard.com/en-us/article/24296142?nocache=20261012c` **volledig zelf gelezen** via Exa
  `web_fetch_exa`: nieuwste sectie blijft **"October 6, 2026"** (de pagina's eigen `Published:
  2026-10-06` — niet ouder dan wat gisteren al gelogd stond, dus geen cache-val). Inhoud
  byte-voor-byte dezelfde **Classes**-tuning (DK Unholy, DH Devourer, Monk Brewmaster/Mistweaver,
  Rogue Subtlety, Shaman Enhancement — buiten mijn lane) en **Dungeons and Raids** (Venomous Abyss
  → Ula'tek: Spectral Coils -20%, Toxic Burn -30% Mythic, Caustic Waves-golven 7→3 Mythic,
  Warden's Protection -80%, Grasping Fangs -30%, Blight Vein 6→4s, Blightscale Shrieker/Clutch/
  Slithering Clutch -20% HP, Circling Prey -30%, Serpent's Bite max 3-man soak) als al
  regel-voor-regel getoetst tegen `Locales/RaidTips.lua` op [2026-10-06] t/m [2026-10-11] —
  vandaag niet opnieuw getoetst, er staat geen nieuwe regel in. Een brede **Player versus
  PvP**-talentpas (buiten mijn lane). **Delves, Professions, Quests en Items: leeg** in de
  "October 6"-sectie — niets om tegen de repo te vergelijken. Dit convergeert met
  `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md` en `docs/PTR_12.0.7_DATA.md` van vandaag, die
  dezelfde sectie als nieuwste zagen; 12.1.5 gaat morgen (13 okt NA/14 okt EU) live en is tot dan
  PTR-terrein, niet het mijne.

  🃏 **Kaarten:** wekelijkse frisheidscheck (gedelegeerd aan een onderzoeksagent met Exa-toegang,
  zelfde methode als eerdere weken). GEMETEN: van de 40 specs zijn de 12 zónder
  `-- rechecked 3 Oct 2026`-code-comment gecontroleerd (oudste eigen datum, dus logische
  prioriteit) — Frost Mage (64), Fury Warrior (72), Feral Druid (103), Guardian Druid (104),
  Survival Hunter (255), Assassination/Outlaw/Subtlety Rogue (259/260/261), Restoration Shaman
  (264), Demonology Warlock (266), Devastation Evoker (1467), Augmentation Evoker (1473): bij
  alle 12 staat de "last updated" van elke genoemde gids (Icy Veins/Method/Wowhead) nog exact op
  de datum die al in `source` staat, geen gids is nu nieuwer — geen kaart hoeft aangepast.
  **Niet gecontroleerd** (28 van de 40, vertrouwt op de interne `-- rechecked 3 Oct 2026
  (mh-research)`-code-comment, niet vandaag zelf opnieuw bij de bron gemeten — dat is AFGELEID,
  geen eigen meting van vandaag): Retribution Paladin (70), Protection Paladin (66), Arcane Mage
  (62), Elemental Shaman (262), Fire Mage (63), Holy Paladin (65), Arms Warrior (71), Protection
  Warrior (73), Balance Druid (102), Restoration Druid (105), Blood/Frost/Unholy DK
  (250/251/252), Beast Mastery/Marksmanship Hunter (253/254), Discipline/Holy/Shadow Priest
  (256/257/258), Enhancement Shaman (263), Affliction/Destruction Warlock (265/267), Brewmaster/
  Windwalker/Mistweaver Monk (268/269/270), Havoc/Vengeance DH (577/581), Preservation Evoker
  (1468), Devourer DH (1480). Hotfixes: de "October 6"-sectie is pure tuning/PvP, geen
  knoppenvolgorde-wijziging. 12.1.5's officiële classnotes (Wowhead, al bekend van 1 okt)
  bevatten wél twee echte rotatie-wijzigingen — Devourer's Collapsing Star (geen cooldown-reset
  meer bij cancel) en MM Hunter's Unload-verwijdering (nieuw talent Blood Fletching) — maar beide
  staan al vooraf aangekondigd in de kaart-comments zelf (kaart 1480: "Violent Transformation
  reset The Hunt niet meer"; kaart 254: "12.1.5 removes Unload"), dus geen nieuwe vondst, wel een
  bevestiging dat de bestaande anticipatie klopt met de officiële notes.

  🧪 **Consumables:** `tools/check_consumables.py` draaide, maar liep voor alle 39 specs tegen
  `Tunnel connection failed: 403 Forbidden` op de egress-proxy richting icy-veins.com (geen
  script-resultaat dus) — uitgeweken naar Exa (dezelfde `icyVeinsUrl`'s uit
  `data/vault_stat_catalog.json`, `-stat-priority` → `-gems-enchants-consumables`,
  `?nocache=20261012`). GEMETEN, alle 39 specs uit de catalogus gelezen; **niet te checken**:
  Devourer DH heeft geen `sourcePages` in `data/consumables_wowhead.json` om tegen te vergelijken
  — dat is "niet gecontroleerd", niet "klopt nog". Drie duidelijke afwijkingen (pagina's eerste
  vermelding vs onze `best`-pick, GEMETEN in `data/consumables_wowhead.json`):
  - Death Knight Unholy flask: pagina "Use Flask of the Shattered Sun as your go-to choice", wij
    zeggen **Flask of the Magisters** (Shattered Sun staat bij ons als eerste alternate). ⚠️
    **Dit is geen nieuwe vondst** — exact dezelfde afwijking stond al op [2026-10-05], en
    `ns.ConsumablesWowheadMeta.patchedSince` (`Modules/ConsumablesWowheadData.lua:14`) heeft wel
    een `2026-10-05`-regel over 15 omgewisselde flask/potion-picks, maar DK Unholy's flask is
    kennelijk niet een van de 15 — zeven dagen later nog onveranderd.
  - Paladin Protection flask: pagina "Use Flask of the Shattered Sun as a general-use flask in
    all content types", wij zeggen **Flask of the Blood Knights** (Shattered Sun staat bij ons
    als eerste alternate). Nieuw t.o.v. [2026-10-05] (daar stond Paladin Holy met dezelfde
    afwijking, niet Protection).
  - Rogue Outlaw combat potion: pagina "Potion of Recklessness is your best option", wij zeggen
    **Light's Potential** (Recklessness staat bij Outlaw niet eens als alternate). Nieuw t.o.v.
    [2026-10-05] (daar stond Subtlety met een vergelijkbare afwijking, niet Outlaw).
  Lagere zekerheid, niet als afwijking geteld (de pagina's zelf behandelen deze als sim-
  afhankelijk/gelijkwaardig, geen harde top-pick): Evoker Devastation flask, Rogue Subtlety
  flask, Warlock Affliction/Destruction potion, Warrior Fury flask — INFERRED, geen harde
  tegenspraak. **Nieuw gesignaleerd:** Preservation Evoker, Holy Paladin, Discipline Priest en
  Mistweaver Monk noemen bij Icy Veins nu een losse mana-potion-categorie ("Potion of Devoured
  Dreams", "Lightfused Mana Potion") — **0 treffers** voor beide namen in
  `data/consumables_wowhead.json` (GEMETEN via grep), dus een categorie die we helemaal niet
  dekken, geen vervanging van een bestaande pick. Food niet gerapporteerd (Hearty-ruis genegeerd,
  zoals de regel voorschrijft). Hotfixes 5-12 okt gecheckt (news.blizzard.com 1 + 6 okt,
  Wowhead/Icy Veins/Nerf Radar): alleen class-tuning en wat trinket-healingfixes, niets aan
  flask/potion/food/wapenolie/augment-rune. **[RAAKT ONS]** voor de drie flask/potion-afwijkingen
  en de ontbrekende mana-potion-categorie — geen van deze vier is door mij vast te stellen als
  "fout", alleen als afwijking tussen twee bronnen; een mens (Rob/Cisca) beslist of
  `data/consumables_wowhead.json` wordt aangepast. Niet aangepast: dit is rapportage, geen fix.

---

- [2026-10-13] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-12]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261013y` (en `&nocache=20261013z` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). `pagination.totalCount` = **8**, zelfde als op [2026-10-08] t/m
  [2026-10-12]. Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`, MrsBoojiePanda's
  debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog
  steeds een reply van `twelveinchy`; geen nieuwe reacties sinds [2026-10-12]. MEASURED.
  **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf (`Locales/esES.lua:17`)
  staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat wordt opgepakt.

- [2026-10-13] 🔒 **Launchdag 12.1.5 (NA) — geen nieuwe hotfix-sectie, en de enige kanttekening die
  vandaag mijn lane raakt (de data-wachters Cinderweaver/Living-Bomb-dispelregel) blijkt geen
  tegenspraak: Ruby Life Pools heeft überhaupt geen geshipte tip-tekst.**

  `news.blizzard.com/en-us/article/24296142?nocache=20261013z` (via Exa `web_fetch_exa`)
  **volledig gelezen**: nieuwste sectie blijft **"October 6, 2026"** (`Published: 2026-10-06` —
  niet ouder dan wat gisteren al gelogd stond, dus geen cache-val), byte-voor-byte dezelfde
  **Classes**- (DK Unholy, Devourer DH, Monk Brewmaster/Mistweaver, Rogue Subtlety, Shaman
  Enhancement) en **Dungeons and Raids**-inhoud (Venomous Abyss → Ula'tek: Spectral Coils -20%,
  Toxic Burn -30% Mythic, Caustic Waves-golven 7→3 Mythic, Warden's Protection -80%, Grasping
  Fangs -30%, Blight Vein 6→4s, Blightscale Shrieker/Clutch -20% HP, Circling Prey -30%,
  Serpent's Bite max 3-man soak) en PvP-talentpas als al regel-voor-regel getoetst op [2026-10-06]
  t/m [2026-10-12] — vandaag niet opnieuw getoetst, geen nieuwe regel erin. **Delves, Professions,
  Quests en Items: nog steeds leeg** in deze sectie — niets om tegen de repo te vergelijken. Dit
  convergeert met `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md` en `docs/PTR_12.0.7_DATA.md` van
  vandaag, die onafhankelijk dezelfde sectie als nieuwste zagen.

  🔍 **Eigen lane-check op de kanttekening van de data-wachter** (`docs/PTR_12.0.7_DATA.md`, entry
  [2026-10-13]): die noemde een losse forumpost ("Dungeon and Raid Tuning – October 13/14 ",
  Linxy 12 okt) met één dispel-mechaniekregel die geen percentage is — letterlijk *"Primalist
  Cinderweaver's Living Bomb debuff can now be dispelled and the explosion damage will not occur
  when dispelled"* (Ruby Life Pools) — en meldde terecht dat een dispel-wijziging eerder mijn
  terrein is dan het zijne, met als eerste check een grep op twee bestanden
  (`Modules/DungeonTipsData.lua`, `Modules/DpsToolkit.lua`: 0 treffers).

  Zelf breder gecontroleerd, zoals de opdracht van deze watch voorschrijft (hele boom, niet een
  bestandenlijst): "Cinderweaver" komt **nergens** in de addon-code voor (0 treffers repo-breed
  buiten de drie watch-logs zelf die het vandaag citeren). "Living Bomb" komt wél voor, maar
  uitsluitend als de Fire Mage-spreuk (44457/44461, `Modules/KeybindRoles_Mage.lua`,
  `Modules/DpsToolkit.lua`, al sinds 5/10 okt gemarkeerd als niet-castbaar in 12.1) — geen enkele
  treffer is de Ruby-Life-Pools-mechaniek. En de sterkste controle: `Modules/DungeonTipsData.lua:
  343-345` registreert Ruby Life Pools' drie bosses (melidrussa/kokia/kyrakka) pas als hun
  `DGN_TIP_RL_<NAAM>_STEPS`-tekst in `enUS.lua` bestaat (commentaar erboven, regel 328-331: "Block
  4 van de tip-audit... GEMETEN op 14 sep: geen enkele entry voor Kings' Rest, Temple of
  Sethraliss of Ruby Life Pools"). `grep "DGN_TIP_RL_" Locales/enUS.lua` geeft **0 treffers** —
  dus geen van de drie Ruby-Life-Pools-bosses heeft ooit geshipte tip-tekst gekregen. Een
  dispel-mechaniekwijziging op een boss zonder enige geshipte tip kan niets tegenspreken.
  MEASURED. **[RAAKT ONS NIET]** — bevestigt de conclusie van de data-wachter, nu op de volledige
  boom getoetst in plaats van twee bestanden.

  Vandaag is dinsdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261013z (volledig gelezen via
  Exa) · `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md` entries [2026-10-13] en
  `docs/PTR_12.0.7_DATA.md` entry [2026-10-13] als kruiscontrole/aanleiding (feiten niet herhaald,
  de Cinderweaver-kanttekening zelf getoetst) · codebase: `grep` case-insensitive repo-breed op
  "Cinderweaver"/"Living Bomb"/"Ruby Life Pools"/"DGN_TIP_RL_", plus gerichte reads van
  `Modules/DungeonTipsData.lua`, `Modules/DungeonRosterData.lua`, `Locales/enUS.lua` — allemaal
  vandaag gelezen. **[RAAKT ONS NIET]** — geen van de gevonden hotfixes (of het ontbreken van
  nieuwe) spreekt een geshipte claim tegen. Geen actiepunt dat ík kan oppakken — ik rapporteer,
  een mens beslist.

---

- [2026-10-14] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-13]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261014a` (en `&nocache=20261014b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`,
  MrsBoojiePanda's debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als
  nieuwste bericht nog steeds een reply van `twelveinchy`; geen nieuwe reacties sinds
  [2026-10-13]. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf
  (`Locales/esES.lua:17`) staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat
  wordt opgepakt.

- [2026-10-14] ⚠️ **Nieuwe sectie "October 13, 2026" (eerste sinds 6 okt) — pure numerieke
  boss-tuning op bijna elke dungeon/raid die we tippen, geen enkele tegenspraak; één vondst die
  een al openstaande testvraag direct raakt.** `news.blizzard.com/en-us/article/24296142
  ?nocache=20261014a` (via Exa `web_fetch_exa`) **volledig gelezen**: sectie "October 13, 2026"
  staat nu bovenaan (`Published` niet expliciet in de kop, maar nieuwer dan de "October 6"-sectie
  die sinds [2026-10-06] de nieuwste was — geen cache-val, nieuwe content). Dit convergeert met
  wat `docs/API_WATCH.md`, `docs/PTR_12.1_WATCH.md` en `docs/PTR_12.0.7_DATA.md` van vandaag
  onafhankelijk als nieuwste sectie zagen. **Classes: leeg** in de 13-okt-sectie — niets te
  vergelijken (buiten mijn lane toch). **Dungeons and Raids: volledig gelezen**, uitsluitend
  gezondheid%/schade%/straal/aantal-tuning op Altar of Fangs, Murder Row, Ruby Life Pools, Temple
  of Sethraliss, The Blinding Vale, The Venomous Abyss (Sszorak, The Coiled Altar) en Voidscar
  Arena — geen enkele nieuwe mechaniek-naam. **Delves, Professions, Quests, Items: leeg.**

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -rn
  "Guillotine is 1283485"` vindt de eigen ID-mapping in `Modules/RaidCoachData.lua:180`;
  `grep -rn "1289900"` vindt Dreadmarch terug in `Locales/RaidTips.lua:85` (zeven talen) — de
  methode (tip-tekst via spell-ID terugleiden naar de hotfix-naam) werkt dus op deze schaal.

  **Altar of Fangs** (Rav'i, The Writhing Coil, Zul'jan — eigen roster
  `Modules/DungeonRosterData.lua:220-236`, dus hierdoor gaat deze dungeon vandaag voor het eerst
  live sinds 12.1.5 gisteren; getagd `season = 2`): de genoemde namen Primal Serpent, Ravenous
  Descendant, Twinfang Harrower, Ritual Chieftain, Rattling Writhe, High Evolutionist, Bloodletter,
  Ascendant Serpent en Living Venom zijn (INFERRED, niet met een ID bevestigd) de vijf/meer
  slangen waarin The Writhing Coil opsplitst — `DGN_TIP_AF_COIL_QUICK`/`_DPS`
  (`Locales/DungeonTips.lua:469-475`) noemt zelf al "5 snakes" generiek, zonder een van deze namen
  of een schade-/gezondheidspercentage. Zul'jan's "Axegrinder periodic damage reduced by 15%" kan
  ik niet aan één `{SPELL:id}` in `DGN_TIP_AF_ZULJAN_STEPS` (`Locales/DungeonTips.lua:476`) hangen
  — die tekst noemt vier andere ID's (1300876, 1301413, 1301111, 1301231) zonder zelf een naam of
  percentage. Rav'i's eigen fix ("Carrion Burst periodic damage reduced by 10%" — let op,
  Carrion Burst is hier géén apart item, Rav'i is de boss zelf) raakt generiek beschreven mechanics
  in `DGN_TIP_AF_RAVI_STEPS` zonder percentage. MEASURED op alle vier: geen percentage/aantal in
  onze tekst om tegen te spreken. **[RAAKT ONS NIET]**

  **Murder Row — Zaen Bladesorrow, Fire Bomb -33%:** `DGN_TIP_MR_ZAEN_QUICK`
  (`Locales/DungeonTips.lua:114`) noemt de bom alleen als "Bomb: Got the bomb? Carry it away..."
  zonder schadewaarde. MEASURED. **[RAAKT ONS NIET]**

  **Ruby Life Pools — Primalist Cinderweaver, Living Bomb nu dispelbaar:** zelfde mechaniek als
  gisteren al getoetst (toen nog een forumpost, nu de officiële hotfix-tekst, woordelijk gelijk).
  Conclusie ongewijzigd: geen van de drie Ruby-Life-Pools-bosses heeft ooit geshipte tip-tekst
  gekregen (`grep "DGN_TIP_RL_" Locales/enUS.lua` → 0 treffers, al op [2026-10-13] gemeten).
  **[RAAKT ONS NIET]** — overige Ruby Life Pools-tuning (Earthbound Guardian, Defier Draghar,
  Storm Warrior, High Channeler Ryvati, Melidrussa Chillworn, Kokia Blazehoof) hoeft daarom niet
  los getoetst: zonder tip-tekst is er niets om tegen te spreken. **[RAAKT ONS NIET]**

  **Temple of Sethraliss (Static Anomaly) en The Blinding Vale (Sporeblight Belcher, Radiant
  Spellsower, Lightwarden Ruia, Ziekket):** geen van deze zes naam-treffers repo-breed (`grep -i`
  op elke naam, 0 treffers buiten de hotfix-tekst zelf) — geen geshipte tip om tegen te spreken.
  MEASURED. **[RAAKT ONS NIET]**

  **The Venomous Abyss — Sszorak, "increased the time to reach 100 rage by 5 seconds on
  Mythic":** `RAID_BOSS_SSZORAK_STEPS` (`Locales/RaidTips.lua:69`, zeven talen) noemt deze exacte
  mechaniek al bij naam via ID: "On Mythic: when {SPELL:1305621} marks a player, at least 14
  players must stand within 8 yards of them before his rage reaches 100." Onze tekst noemt geen
  tijdsduur (geen seconden-getal), dus de hotfix spreekt niets tegen — hij geeft Mythic-raids
  alleen meer tijd om de 14 spelers te verzamelen. MEASURED. **[RAAKT ONS NIET]**, geen
  actiepunt — de tekst blijft kloppen, wordt alleen iets ruimer uitvoerbaar.

  **The Venomous Abyss — The Coiled Altar, vier tuningregels op Phase 1/2:** "initial total
  number of orbs during Toxic Deluge reduced to 8 on Mythic (was 10)", "Virulent Mutations
  reduced to 4 on Mythic (was 5)", "Virulent Mutation/Mutagenic Venom radius reduced to 6 yards
  (was 8)", "Dreadmarch targets reduced to 3 on Mythic (was 4)". `{SPELL:1299960}` = Toxic Deluge
  (al vastgesteld op [2026-09-21]) staat in `RAID_BOSS_COILEDALTAR_STEPS`
  (`Locales/RaidTips.lua:85`) als "Green orbs ({SPELL:1299960}): step on one to carry it..." —
  geen aantal genoemd. `{SPELL:1289900}` = Dreadmarch (al vastgesteld 19 sep,
  `docs/NEXT_SESSION.md:2730-2731`) staat in dezelfde STEPS-regel als "makes players walk to the
  edge to jump off" — geen spelersaantal genoemd. Coalesced Venom/Virulent Mutation/Mutagenic
  Venom hebben zelf geen eigen `{SPELL:id}` in onze tekst (al vastgesteld op [2026-09-21], en
  bewust niet geschreven volgens `docs/NEXT_SESSION.md:2737-2740`: "Heroic/Mythic-mechaniek die ik
  alleen uit hotfixzinnen ken… herschrijven zonder bron is raden"). MEASURED op alle vier: geen
  aantal/straal in onze tekst om tegen te spreken. **[RAAKT ONS NIET]**

  🟢 **The Venomous Abyss — The Coiled Altar, Eternal Nightfall cast time +2s (alle
  moeilijkheidsgraden) — raakt een al openstaande testvraag.** `docs/TESTLIJST.md:1988` heeft
  precies deze mechaniek als open vraag staan: "Coiled Altar, Normal, Eternal Nightfall: stopt de
  cast vanzelf als het schild breekt, of moet er nog een kick?" — dat is dezelfde cast als
  `{SPELL:1286918}` in `RAID_BOSS_COILEDALTAR_STEPS` (`Locales/RaidTips.lua:85`: "everyone hits
  the shield around Malacrass, then interrupt the cast once the shield is gone, or the raid takes
  a huge hit"). De hotfix spreekt onze tekst niet tegen (we claimen al dat een interrupt nodig is,
  geen tijdsduur), maar de +2 seconden cast time is relevant voor wie die open testvraag oppakt:
  meer marge om te kicken. MEASURED (citaat `docs/TESTLIJST.md:1988` gelezen). **[RAAKT ONS]** —
  geen actie nodig, maar wie `TESTLIJST.md:1988` test kan dit meenemen.

  **Voidscar Arena (Feral Saberon, Chitigoth, Brutal Overseer, Atroxus, Charonus):** geen van deze
  vijf namen repo-breed (0 treffers) — geen geshipte tip. MEASURED. **[RAAKT ONS NIET]**

  **Manifestations of Dread** (visuele/despawn-aanpassingen, alle moeilijkheidsgraden) blijft een
  bewust niet-geschreven Heroic/Mythic-mechaniek (zie Coiled Altar-regel hierboven) — geen
  tegenspraak mogelijk zonder geschreven tekst. **[RAAKT ONS NIET]**

  Vandaag is woensdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261014a (volledig gelezen via
  Exa) · codebase: `grep` case-insensitive repo-breed op alle hierboven genoemde boss-, mechaniek-
  en spell-ID-namen, plus gerichte reads van `Locales/RaidTips.lua`, `Locales/DungeonTips.lua`,
  `Modules/DungeonTipsData.lua`, `Modules/DungeonRosterData.lua`, `Modules/RaidCoachData.lua`,
  `docs/NEXT_SESSION.md`, `docs/TESTLIJST.md` — allemaal vandaag gelezen. **[RAAKT ONS NIET]** op
  alle tuning-regels, met één **[RAAKT ONS]** (Eternal Nightfall/testvraag) die geen bestaande
  claim tegenspreekt maar wel relevant is voor een open testpunt. Geen actiepunt dat ík kan
  oppakken — ik rapporteer, een mens beslist.

---

- [2026-10-15] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-14]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261015z` (en `&nocache=20261015y` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`,
  MrsBoojiePanda's debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als
  nieuwste bericht nog steeds een reply van `twelveinchy`; geen nieuwe reacties sinds
  [2026-10-14]. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt vandaag. De esMX-codefix zelf
  (`Locales/esES.lua:17`) staat nog open; al gemeld op [2026-10-07], een mens beslist wanneer dat
  wordt opgepakt.

- [2026-10-15] 🔴 **Nieuwe sectie "October 14, 2026" — de Labyrinth-kill-credit-bug die onze
  eigen tip al citeerde met "Blizzard has not said anything about it yet" is DIEZELFDE DAG door
  Blizzard gefixed; die zin in onze tekst klopt sinds vandaag niet meer.** `news.blizzard.com/
  en-us/article/24296142?nocache=20261015z` (via Exa `web_fetch_exa`) **volledig gelezen**:
  sectie "October 14, 2026" staat nu bovenaan, boven de al op [2026-10-14] verwerkte "October 13"-
  sectie (geen cache-val, nieuwe content — convergeert met wat de andere drie wachters vandaag als
  nieuwste zagen, zie hun eigen entries van vandaag). Categorieën in de 14-okt-sectie: Aqir
  Invasions, Classes, Delves, Labyrinth, Quests. **Professions, Dungeons and Raids, Items: leeg**
  in deze sectie — niets te vergelijken.

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -rn
  "Harvest bundle"` vindt onze eigen Labyrinth-roomtekst terug in `Locales/enUS.lua:3048`;
  `grep -rn "Amani'Zar"` vindt twee treffers in `Modules/FlightNetworkData.lua:21` en
  `Modules/FlightPointsData.lua:992` — het patroon werkt dus op deze schaal.

  **🔴 Labyrinth — kill credit voor een roomboss telt soms niet als het de TWEEDE keer is dat die
  boss in dezelfde run verslagen moet worden; gefixed.** Letterlijk: *"Fixed an issue where the
  kill credit for a boss may not register if it was the second time the boss had to be defeated
  in the same Labyrinth run."* Dit is woordelijk de bug die wíj al beschrijven:
  `DELVE_TIP_LABYRINTH_OVERVIEW` (`Locales/enUS.lua:3047`, zeven taalvarianten) zegt: *"Launch-day
  bug (players, 14 Oct): a room boss kill sometimes does not count (Sullied Revenant, The Undead
  Trollbunal, Sha'Kuro, Jun'ala, Grukk, Drill Sergeant), and then the run is stuck. Blizzard has
  not said anything about it yet."* De zes genoemde bosses zijn precies de bosses die in méér dan
  één roomtaak kunnen voorkomen volgens onze eigen `DELVE_TIP_LABYRINTH_ROOMS`
  (`Locales/enUS.lua:3048`): Jun'ala sluit zowel "A Foul Presence" als (als lot) "Taken
  Antiquities" af, Sha'Kuro zowel "Reliquary Ritual" als (als lot) "Taken Antiquities", Sullied
  Revenant zowel "Vile Intruders" als (als lot) "Taken Antiquities" — dus "de tweede keer dat
  deze boss verslagen moet worden" past precies op onze eigen beschrijving. MEASURED (citaat uit
  de hotfix-pagina zelf gelezen; citaat uit `Locales/enUS.lua:3047-3048` gelezen). **[RAAKT ONS]**
  — de laatste zin van `DELVE_TIP_LABYRINTH_OVERVIEW` ("Blizzard has not said anything about it
  yet") is sinds vandaag feitelijk onjuist: Blizzard heeft er wél iets over gezegd, en heeft het
  gefixed. Geen actie van mij — ik raak de tekst niet aan — maar wie deze regel oppakt kan de hele
  bugmelding schrappen of vervangen door "fixed in de 14-okt-hotfix".

  **Labyrinth — Kindo'jan-encounter kon falen bij 1 health; gefixed.** `DELVE_TIP_LABYRINTH_BOSS`
  (`Locales/enUS.lua:3049`, zeven taalvarianten) beschrijft de 70%-fase en de loa-test, maar zegt
  niets over het einde van het gevecht bij 1 health — geen tegenspraak. MEASURED. **[RAAKT ONS
  NIET]**

  **Labyrinth — "Returning the Bounty"-scenario: bag-interactie kon soms niet afgerond worden, en
  "Hording Looters" stopten soms met spawnen; beide gefixed.** ⚠️ **Geen exacte naam-match, wel
  een plausibele kandidaat die het melden waard is.** `grep -rn "Returning the Bounty"` en
  `grep -rn "Hoarding Looters"` (beide spellingen, incl. Blizzards eigen "Hording"): 0 treffers
  repo-breed. Onze eigen `DELVE_TIP_LABYRINTH_ROOMS` heeft echter een taak zonder bevestigde naam
  ("Harvest bundle: look at the bundle, kill 10 looters and pick up what they drop, beat the Pit
  Boss...") die zowel een bundel/buit-thema als looters-vijanden heeft — qua inhoud een redelijke
  kandidaat voor wat Blizzard "Returning the Bounty" noemt, maar dat is INFERRED op naam-thema,
  niet MEASURED via een ID of in-game bevestiging. Onze tekst zegt zelf al: *"A task without a
  white name is one whose in-game name we have not seen yet."* Geen tegenspraak in beide gevallen
  (wij claimen niets over afrondbaarheid of spawn-gedrag). **[RAAKT ONS NIET]** als contradictie,
  maar wel een aanwijzing voor wie ooit de ontbrekende roomtaak-namen invult.

  **Labyrinth — "Fools and Curses"-scenario: Cursed Energy kon niet langer gecleansed worden;
  gefixed.** Zelfde soort kandidaat-match, zwakker dan hierboven: onze naamloze taak "Cursed
  energy: kill the relic raiders (yellow dots), and take 5 purple curse orbs to the cursed
  sarcophagus" deelt alleen de term "Cursed energy" met de hotfix-naam, niet het woord "cleanse" —
  0 treffers op "Fools and Curses" of "cleanse" in die roomtekst. Te zwak om als dezelfde taak te
  benoemen; hier alleen gemeld als mogelijk aanknopingspunt, niet als vondst. **[RAAKT ONS NIET]**

  **Labyrinth — Ancient Hash'ey Battle Art-enchant: werkte buiten delves/Labyrinth; max. itemlevel
  nu 344 (was 334); gefixed.** `CODEX_LABJOURNEY_BODY` (`Locales/Codex.lua:173`, zeven
  taalvarianten) noemt de vier Hash'ey-enchants bij naam en zegt zelf al "these four glove
  enchants work in every delve, not only here" — dat is precies de bedoelde scope, en de bug zat
  in het WERKEN BUITEN die scope (nu gefixed), niet in onze beschrijving ervan. Geen itemlevel-
  cijfer in onze tekst om tegen een "344 was 334" te toetsen. Ook al gelogd als feit door de
  data-wachter (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-15]); dit is mijn onafhankelijke
  contradictiecheck. MEASURED. **[RAAKT ONS NIET]** — bevestigt zelfs dat onze scope-omschrijving
  al klopte.

  **Labyrinth — overige pure bugfixes zonder addon-claim:** Halazzi's Lair (vijanden spawnden in
  de muren), Nalorakk's Rest (door de grond vallen bij respawn). `grep -i "Halazzi"` en
  `grep -i "Nalorakk"` vinden onze eigen loa-testbeschrijving (`DELVE_TIP_LABYRINTH_BOSS`) en
  Journey-tekst (`CODEX_LABJOURNEY_BODY`) terug, geen van beide claimt iets over spawn-locaties of
  terrein bij respawn. MEASURED. **[RAAKT ONS NIET]**

  **Delves — "Dundun has returned and hides within Bountiful delves once again. May you revel in
  his radiant prosperity!"** ⚠️ **Geen bug-regel maar flavourtekst in de categorie-kop zelf — en
  de formulering ("has returned... once again") suggereert dat hij een periode NIET aanwezig was.**
  Dundun is uitgebreid geshipte content (`Modules/DundunShrine.lua`, `DUNDUN_CHAT_*`/
  `DUNDUN_PANEL_*`-keys in `Locales/enUS.lua:4162-4190`): de module-commentaar zegt zelf "he
  appears in **Bountiful** delves of any [tier]" als onvoorwaardelijke bewering, en leest
  `ns.IsDelveBountiful` live van de client (`Modules/DundunShrine.lua:160-161`) — geen hardcoded
  aanname. `grep -rn "radiant prosperity\|Dundun has\|Dundun removed\|Dundun disabled"` op alle
  vier de watch-logs: 0 treffers — dit is de EERSTE keer dat deze zin in onze logs opduikt, dus ik
  kan niet vaststellen of dit een terugkerende Blizzard-grap is of een echte tijdelijke afwezigheid
  die onze "altijd aanwezig"-aanname (in het modulecommentaar, niet in de geshipte playertekst)
  ooit onjuist maakte. Ook al gelogd door de data-wachter (`docs/PTR_12.0.7_DATA.md`, entry
  [2026-10-15]) met hetzelfde citaat en dezelfde onbeantwoorde "sinds wanneer/waarom weg"-vraag —
  dat is zijn feit, dit is mijn onafhankelijke contradictiecheck op de geshipte tekst. MEASURED
  (citaat gelezen); INFERRED dat dit geen acute contradictie is,
  want de geshipte tip leest de Bountiful-status live en claimt niet dat Dundun gegarandeerd is
  los van wat de client meldt. **[RAAKT ONS]** — geen tegenspraak in de geshipte tekst, maar het
  modulecommentaar ("appears in Bountiful delves of any tier", onvoorwaardelijk) is een aanname
  die iemand met toegang tot hotfix-historie zou kunnen verifiëren; ik laat de ambiguïteit expliciet
  staan in plaats van hem op te lossen.

  **Aqir Invasions — eindboss randomiseerde niet goed tussen de drie types; gefixed.**
  `CODEX_AQIR_BODY`/`EVENT_INFO_AQIR_DESC` (`Locales/Codex.lua:175`, `Locales/enUS.lua:2159-2160`)
  noemen de Webweaver/Voidweaver als prioriteitsdoelen maar claimen nergens hoeveel types de
  eindboss heeft of hoe de randomisatie werkt. MEASURED (0 treffers op "randomiz"/"three types" in
  combinatie met Aqir). **[RAAKT ONS NIET]**

  **Quests — Ancient Foes in de Vaults of Atal'Utek gaven geen Primordial Venom Motes in
  raid-groepen; gefixed.** ⚠️ **Naamcollision gecontroleerd.** MH heeft een andere "Ancient Foes":
  `Modules/Achievements.lua:94,2004` en `Modules/AchievementsData.lua:115-169` noemen "Ancient
  Foes" als drie NPC's die spawnen bij de Underbelly Temple Strike/Soft Underbelly-achievement —
  ander event, geen raid-context, geen Primordial-Venom-Mote-claim. 0 treffers op "Primordial
  Venom Mote" repo-breed. Ook al gelogd als nieuwe, ongetrackte currency door de data-wachter
  (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-15]); dit is mijn onafhankelijke contradictiecheck op
  de bestaande Ancient-Foes-tekst. MEASURED. **[RAAKT ONS NIET]**

  **Quests — NPC's in Amani'Zar Village onzichtbaar tijdens "De Legend of de Hash'ey"; gefixed.**
  Onze twee treffers op "Amani'Zar" zijn een vliegroute-naam (`Modules/FlightNetworkData.lua:21`,
  `Modules/FlightPointsData.lua:992`) — geen van beide claimt iets over NPC-zichtbaarheid tijdens
  een quest. MEASURED. **[RAAKT ONS NIET]**

  **Classes — Druid Guardian (Rebirth-manakosten, Bear-Form Heart of the Wild, Persistence-pantser)
  en Restoration (Nature's Bounty/Abundance) fixes.** Pure spec-balans/mechaniek-fixes, gevestigd
  patroon dat MH niet volgt. **[RAAKT ONS NIET]**

  Vandaag is donderdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261015z (volledig gelezen via
  Exa) · codebase: `grep` case-insensitive repo-breed op alle hierboven genoemde namen, plus
  gerichte reads van `Locales/enUS.lua`, `Locales/Codex.lua`, `Modules/DundunShrine.lua`,
  `Modules/Achievements.lua`, `Modules/AchievementsData.lua`, `Modules/FlightNetworkData.lua`,
  `Modules/FlightPointsData.lua` — allemaal vandaag gelezen. Eén bevestigde contradictie
  (Labyrinth-kill-credit, "Blizzard has not said anything about it yet" klopt niet meer),
  twee [RAAKT ONS]-aantekeningen zonder contradictie (Dundun-flavourtekst, naam-kandidaten voor
  openstaande roomtaken), verder **[RAAKT ONS NIET]**. Geen actiepunt dat ík kan oppakken — ik
  rapporteer, een mens beslist.

---

- [2026-10-16] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-15]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20
  &nocache=20261016a` (en `&nocache=20261016b` als tweede, onafhankelijke fetch) via Exa, beide
  volledig gelezen (JSON). Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`,
  MrsBoojiePanda's debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als
  nieuwste bericht nog steeds een reply van `twelveinchy`; geen nieuwe reacties sinds
  [2026-10-15]. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt vandaag.

- [2026-10-16] ⚠️ **Nieuwe sectie "October 15, 2026" — geen harde tegenspraak, wel een
  vervolg-fix op precies de bug die onze eigen tip al als "fixed 14 Oct" citeert.**
  `news.blizzard.com/en-us/article/24296142?nocache=20261016a` (via Exa `web_fetch_exa`)
  **volledig gelezen**: sectie "October 15, 2026" staat nu bovenaan, boven de al op [2026-10-15]
  verwerkte "October 14"-sectie (geen cache-val; convergeert met wat de andere wachters vandaag
  als nieuwste zagen). Categorieën in de 15-okt-sectie: Items, Labyrinth, Quests. **Delves,
  Professions, Classes, Dungeons and Raids: leeg** in deze sectie — niets te vergelijken. (De
  Impressive-Treasure-levelverlaging uit deze sectie is al door de data-wachter gelogd op
  [2026-10-16]; dit hieronder is mijn onafhankelijke contradictiecheck, niet herhaald.)

  📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep -rn
  "Sha'Kuro"` vindt onze eigen Labyrinth-roomtekst terug in `Locales/enUS.lua:3198` (en zeven
  taalvarianten); `grep -rn "renownFactionID"` vindt treffers in `Modules/MountProgress.lua:140-
  148`. Beide patronen werken dus op deze schaal — de 0-treffers verderop zijn gemeten
  afwezigheid.

  **Labyrinth — "Scenario bosses should now properly give credit if defeated a second time on
  the same run" (15 okt) herhaalt bijna letterlijk de bug die onze eigen tip al als "fixed by
  Blizzard on 14 Oct" citeert.** `DELVE_TIP_LABYRINTH_OVERVIEW` (`Locales/enUS.lua:3197`, zeven
  taalvarianten) zegt sinds de vorige run: *"Launch-day bug, fixed by Blizzard on 14 Oct: the
  kill of a room boss you had to beat a second time in the same run sometimes did not count...
  If it still happens, tell us."* De 14-okt-hotfix gebruikte de term "Labyrinth"; de 15-okt-
  hotfix noemt de bredere categorie "Scenario bosses" en beschrijft vrijwel dezelfde bug
  opnieuw — wat erop wijst dat de eerste fix niet volledig was, of een los, breder mechanisme
  raakte dat dezelfde symptomen gaf. MEASURED (citaat uit beide hotfix-secties zelf gelezen;
  citaat uit `Locales/enUS.lua:3197` gelezen). **[RAAKT ONS NIET]** als harde tegenspraak — onze
  tekst hedge't zelf al met "If it still happens, tell us", dus er wordt niets onwaar beweerd —
  maar wel het melden waard: de bug lijkt hardnekkiger dan één hotfix oplost, en "fixed by
  Blizzard on 14 Oct" kan de indruk wekken dat dit toen al klaar was terwijl Blizzard een dag
  later nog een aparte fix nodig had. Een mens beslist of de formulering dit moet nuanceren.

  **Labyrinth — Sullied Revenant en Sha'Kuro's gezondheid resette niet goed bij het falen van de
  encounter; gefixed.** `DELVE_TIP_LABYRINTH_ROOMS` (`Locales/enUS.lua:3198`, zeven
  taalvarianten) beschrijft beide bosses' aanvallen (Necrotic Sweep/Soul Traps voor Sullied
  Revenant, Soul Storm/Rotten Cascade/Vile Bolt voor Sha'Kuro) maar zegt niets over gezondheid bij
  een mislukte poging. MEASURED (0 treffers op "reset"/"fail" in combinatie met deze namen in
  `Locales/enUS.lua`). **[RAAKT ONS NIET]**

  **Quests — questNPC's om "De Legend of de Hash'ey" af te ronden waren niet beschikbaar in
  Zul'Aman; gefixed.** Vervolg op de NPC-zichtbaarheidsfix van 14 okt (al gelogd op
  [2026-10-15]) — nu een apart probleem (turn-in-NPC's, niet zichtbaarheid). Onze twee treffers
  op "Amani'Zar" blijven vliegroute-namen (`Modules/FlightNetworkData.lua:21`,
  `Modules/FlightPointsData.lua:992`); onze vele "Zul'Aman"-treffers in `Locales/enUS.lua` zijn
  allemaal het open-wereld-levelgebied (zone-gids, grondstoffen, de Amani-Tribe-renown-
  quartiermeester) — geen enkele claimt iets over deze quest se turn-in. MEASURED (0 treffers op
  "Legend of de Hash'ey" buiten deze eigen watch-log). **[RAAKT ONS NIET]**

  **Items — factiespecifieke mounts werden verborgen in het Mount Journal voor karakters van de
  andere factie; gefixed.** `Modules/MountProgress.lua` leest "collected?" altijd live van de
  Mount-Journal-API (regel 17: "the Mount Journal knows. Ask it instead of hunting a database")
  en claimt zelf nergens welke mounts op welk scherm zichtbaar zijn voor welke factie — dit is
  een client-side weergavebug in Blizzards eigen UI, niet in data die wij zelf tonen. MEASURED.
  **[RAAKT ONS NIET]**

  Vandaag is vrijdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24296142?nocache=20261016a (volledig gelezen via
  Exa) · codebase: `grep` case-insensitive repo-breed op alle hierboven genoemde namen, plus
  gerichte reads van `Locales/enUS.lua`, `Modules/MountProgress.lua`,
  `Modules/FlightNetworkData.lua`, `Modules/FlightPointsData.lua` — allemaal vandaag gelezen.
  Eén kanttekening zonder harde tegenspraak (kill-credit-fix tweede ronde), verder **[RAAKT ONS
  NIET]**. Geen actiepunt dat ík kan oppakken — ik rapporteer, een mens beslist.

- [2026-10-17] 🧩 **Eén echte content-vondst: Blizzards eigen bugfix-tekst over Sha'Kuro's Soul
  Storm onthult een mechaniek die onze tip niet noemt.** Verder negen bugfixes in mijn terrein,
  geen enkele in tegenspraak met iets dat we shippen.

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. gisteren).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261017b` (via
  Exa, JSON volledig gelezen, `pagination.totalCount: 8`): dezelfde drie draadjes als gisteren
  (esMX-locale-fix, debug-printregel, coffer-key-shards-popup), alle drie eindigend op een
  reactie van `twelveinchy` behalve het coffer-key-shards-draadje, dat al sinds juni eindigt op
  een bedankje van de vraagsteller zelf (geen nieuwe vraag) — zo ook al in elke eerdere run sinds
  2 okt geteld. Geen nieuw draadje, geen nieuw bericht in een bestaand draadje.

  **Bron van de hotfix-pagina geverifieerd — het juiste artikel-ID van vandaag is
  `24307310`, NIET `24296142`.** De data-wachter ving dit vanochtend al (`docs/PTR_12.0.7_DATA.md`,
  regel van 17 okt): `24296142` gaf met twee cache-busters nog steeds "Hotfixes: October 6, 2026"
  terug. Ik heb zelf `24307310?nocache=20261017c` gelezen (via Exa, volledige pagina-tekst, niet
  alleen een samenvatting): nieuwste sectiekop is **"October 16, 2026"**, boven de al verwerkte
  15-okt-sectie — geen "October 17"-sectie vandaag, dus niets om op een nog nieuwere cache-val te
  controleren. 📌 **Positieve controle, zelfde repo-brede scope als de claims hieronder:** `grep
  -rn "Sha.Kuro"`, `"Jan'alai"` en `"stagger"` (case-insensitive) vinden allemaal onze eigen tekst
  terug (`Locales/enUS.lua:3245`, `:1157`/`:3246`, `:1973-1988`) — dezelfde zoekvorm als de
  nul-treffers verderop, dus die nul-treffers zijn gemeten afwezigheid.

  **Dungeons and Raids (Murder Row, The Coiled Altar) — zuiver UI/achievement, niets om tegen te
  spreken.** Murder Row kreeg een zichtbare safe-zone-indicator bij een barrel (puur visueel, al
  API-watch-terrein); The Coiled Altar: achievement *Watch Out Behind You* nu voltooibaar in
  raidgroepen >20 spelers. MEASURED dat noch de naam noch het kandidaat-ID 63669 ergens in een
  geshipte tip voorkomt (`grep -rli` op beide treft alleen `docs/PTR_12.1_WATCH.md` en
  `docs/PTR_12.0.7_DATA.md` — onze eigen dev-notities, geen spelerstekst). **[RAAKT ONS NIET]**

  **Labyrinth of Kindo'jan — vijf losse bugfixes, stuk voor stuk een bestaande naam/entiteit maar
  nergens een claim van ons die erdoor fout wordt.**
  - *Jan'alai's Refuge* (het "Returning the Bounty"-scenario): Pit Boss spawnde soms niet. Onze
    `DELVE_TIP_LABYRINTH_ROOMS` (`Locales/enUS.lua:3245`) noemt deze taak zelf als "Harvest
    bundle" met een "Pit Boss" (Bombardment/Flame Wave) — dezelfde entiteit, andere naam voor de
    kamer/het scenario dan Blizzards eigen tekst. Puur een spawnbug; wij claimen nergens dat hij
    altijd spawnt. **[RAAKT ONS NIET]**
  - Valeera's Stagger werkte niet met een healer in de groep. Elke "stagger"-treffer in onze
    teksten (`Locales/enUS.lua:1973-1988`, `:3797`, `:4815`, `:4843`) is de Brewmaster-monnik-
    mechaniek (PLAYCARD/tank-pull-summary) — een andere entiteit met toevallig dezelfde Engelse
    naam. Niets over Valeera's eigen Stagger in onze tips. **[RAAKT ONS NIET]**
  - Scar of Kathra'natir (DoT) deed te veel schade aan Valeera. 0 treffers op "kathra" in
    `Locales/enUS.lua` — wij noemen deze ability nergens. **[RAAKT ONS NIET]**
  - Spelers konden door de vloer vallen in The Speaker's Chamber. 0 treffers op "Speaker's
    Chamber" (alleen het ongerelateerde zone-punt "Speaker's Rest" in Zul'Aman,
    `Locales/enUS.lua:2376`). **[RAAKT ONS NIET]**
  - Loa-Blessed Wayfarer (mount) en Loa-Blessed Victory (toy) worden nu alsnog door Kinduru
    gegeven als je ze vergat te lootten uit de Ancestral Bounty-kist. Onafhankelijk nagelezen op
    een verse Wowhead-gids (`wowhead.com/guide/midnight/delves/labyrinth-of-kindojan-megadelve-
    nemesis-rewards`, bijgewerkt 16 okt): de mount is exclusief de beloning van de achievement
    *Let Me Solo Him: Kindo'jan* (solo, Tier 11) — **exact wat onze eigen tekst al zegt**
    (`MOUNTPROG_LOAWAYFARER_HOWTO`, `Locales/enUS.lua:888`: "Reward of the achievement Let Me
    Solo Him: Kindo'jan..."); de toy komt uit de Ancestral Bounty-kist zelf (Tier 8+, niet
    solo-specifiek) en wordt door MH nergens getrackt (`Modules/MountProgress.lua` kent geen
    toy-entry voor Loa-Blessed Victory). Onze bestaande tip ("Afterwards Kinduru takes you to the
    treasure room. Pick up your reward on the platform first", `DELVE_TIP_LABYRINTH_BOSS`,
    `Locales/enUS.lua:3246`) klopt nog gewoon — deze hotfix is een extra vangnet, geen
    tegenspraak. **[RAAKT ONS NIET]**, al is het een kandidaat om als geruststelling aan die regel
    toe te voegen (mens beslist).
  - Groepsschaling gaf te hoge gezondheid/schade voor sommige creatures/bosses (geen nieuw getal
    of ID genoemd) — niets concreets om tegen een tip te leggen. **[RAAKT ONS NIET]**
  - L00T RAID-R Mini kon maar één keer gebruikt worden in de Labyrinth; nu onbeperkt. Onze teksten
    (`CHANGELOG_130_2`, `DELVE_MINIMAP_RADAR_TITLE`/`_HINT`, `Locales/enUS.lua:3935,4411-4412`)
    claimen nergens een gebruikslimiet. **[RAAKT ONS NIET]**

  🔴 **En dan de vondst: Sha'kuro's Soul Storm kón onderbroken worden vóórdat alle Unfortunate
  Souls dood waren — "negating the damage window gained from the stun".** Letterlijk uit de
  hotfix (Labyrinth and Delves, 16 okt): *"Fixed an issue where Sha'kuro's Soul Storm could be
  interrupted before all Unfortunate Souls were defeated, negating the damage window gained from
  the stun."* Dat onthult een mechaniek die nergens in onze eigen tekst staat: Soul Storm geeft,
  als hij wél afloopt (niet onderbroken), een stun op Sha'Kuro — en dus een schade-venster. Onze
  `DELVE_TIP_LABYRINTH_ROOMS` (`Locales/enUS.lua:3245`) zegt alleen *"kill the Unfortunate Souls,
  because his Soul Storm (about every 45 seconds) drains them to protect himself and hurts you"*
  — geen woord over een stun erna, en geen waarschuwing om hem NIET te onderbreken (in
  tegenstelling tot zijn Vile Bolt, die onze tip wél expliciet als onderbreekbaar noemt). MEASURED
  (hotfix-citaat zelf gelezen; `Locales/enUS.lua:3245` zelf gelezen; `grep -i "soul storm"` in de
  hele codebase geeft buiten deze ene tiptekst 0 treffers, dus geen los interrupt-advies elders dat
  dit al dekt). Dit is geen bewering van ons die fout is — het is een hiaat: spelers die Soul Storm
  per ongeluk onderbreken (bv. met een AoE-stun of interrupt) missen het schade-venster, en onze
  tip zegt daar niets over. **[RAAKT ONS]** als content-hiaat, geen harde tegenspraak. Mens beslist
  of de tip een regel krijgt als "laat Soul Storm aflopen, onderbreek hem niet".

  Vandaag is zaterdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261017c
  (volledig gelezen via Exa) ·
  https://www.icy-veins.com/wow/news/many-delve-labyrinth-dungeon-and-raid-improvements-midnight-12-1-5-hotfixes-october-16th/
  (onafhankelijke bevestiging, via search) ·
  https://www.wowhead.com/guide/midnight/delves/labyrinth-of-kindojan-megadelve-nemesis-rewards
  (bijgewerkt 16 okt, via search_exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261017b
  (JSON, via Exa) · codebase: repo-brede `grep` op alle bovenstaande namen plus gerichte reads van
  `Locales/enUS.lua`, `Modules/MountProgress.lua` — allemaal vandaag gelezen. Eén content-hiaat
  gevonden (Sha'Kuro Soul Storm), verder uitsluitend **[RAAKT ONS NIET]**. Geen actiepunt dat ík
  oppak — ik rapporteer, een mens beslist.

---

- [2026-10-18] 🔴 **Eén echte content-vondst: Blizzard onderzoekt zelf nog een ongefixte bug die
  precies onze "neem Valeera als healer, dat is veiliger"-tip raakt.** Geen nieuwe hotfix-sectie
  sinds 16 okt; verder niets om tegen te spreken.

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. gisteren).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261018f` (via
  Exa, JSON volledig gelezen, `pagination.totalCount: 8`): dezelfde drie draadjes als op 17 okt
  (esES/esMX-locale-fix, debug-printregel, coffer-key-shards-popup). Alle drie eindigen op een
  reactie van `twelveinchy`, behalve het coffer-key-shards-draadje, dat al sinds juni 2025 eindigt
  op een bedankje van de vraagsteller zelf (geen nieuwe vraag). De nieuwste tijdstempels in het
  esMX-draadje zijn 6/7 okt (MEASURED, omgerekend: `1791322444427`→2026-10-06 21:34 UTC,
  `1791351710373`→2026-10-07 05:41 UTC) — dus geen nieuw bericht sinds de vorige run.

  **Hotfixes: geen nieuwe sectie sinds "October 16, 2026".** `Exa web_fetch_exa` op
  `news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261018b`,
  **volledige artikeltekst zelf gelezen** — "October 16, 2026" staat nog bovenaan, byte-voor-byte
  dezelfde inhoud als al verwerkt op [2026-10-17]. Onafhankelijk bevestigd: `web_search_exa` op
  "Hotfixes October 17/18 2026" geeft uitsluitend de 16-okt- en 15-okt-artikelen terug (geen 17/18
  okt-titel bestaat); Wowhead Blue Tracker, warcraft.wiki.gg en check-wow.com citeren allemaal
  diezelfde 16-okt-lijst als nieuwste. Dit convergeert met de data-wachter van vandaag
  (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-18]: zelfde artikel-ID, zelfde conclusie, vier
  onafhankelijke bronnen) — niet overgenomen, zelf opnieuw gelezen en zelf apart bevestigd.
  Delves/Professions/Quests als losse categorieën: leeg in de 16-okt-sectie (al verwerkt op 17
  okt), niets nieuws te vergelijken.

  🔴 **De vondst, aangedragen door de data-wachter van vandaag die hem expliciet aan mijn lane
  doorgaf:** de officiële "Midnight: 12.1.5 Content Update – Known Issues"-forumpost
  (`us.forums.blizzard.com/.../2381312`, Linxy, **zelf gelezen met `?nocache=20261018d`**, laatst
  bijgewerkt 16 okt 18:44 PDT, geen update sinds) noemt onder "Labyrinth and Delves" nog steeds
  ongefixt (geen `fixed`-label, in tegenstelling tot de vier andere punten in die lijst):
  *"Valeera is taking more damage than intended."* Blizzard zelf, los bevestigd
  (`wowhead.com/news/blizzard-investigating-valeera-survivability-issues-in-patch-12-1-5-383467`,
  16 okt, zelf gelezen): *"We're investigating the issue with Valeera's survivability since the
  update."* Tientallen speler-reacties op die pagina (zelf gelezen, niet alleen samenvatting)
  beschrijven Valeera die in Tier 11-delves en in de Labyrinth binnen seconden doodgaat, op elke
  rol (tank/dps/healer) — met TEGENSTRIJDIGE adviezen welke rol het veiligst is op dit moment
  (sommigen: zet haar op healer om de bug te omzeilen; anderen: ook als healer sterft ze net zo
  hard). Geen enkele speler- of Blizzard-bron geeft een eenduidig "doe dit om haar veilig te
  houden" — ik verzin dat dus ook niet.

  Dit raakt een bestaande, geshipte claim: `DELVE_TIP_LABYRINTH_BOSS` (`Locales/enUS.lua:3249`,
  zeven taalvarianten) zegt letterlijk *"Want to play it safe? Take Valeera as a healer: the
  fight takes longer, but you are less likely to lose a life"* en, bij de Halazzi-loa-test in
  dezelfde tip, *"Miss it and the cat kills Valeera: revive her right away, there is time before
  the bears."* Dat is precies de belofte die deze bug op losse schroeven zet: op dit moment is
  "minder kans om een leven te verliezen" met Valeera als healer niet zeker waar, en spelers
  melden dat ze haar sowieso vaker dan bedoeld moeten opwekken — niet alleen bij die ene
  Halazzi-cat-mechaniek die onze tip noemt. MEASURED (forumpost zelf gelezen met eigen
  cache-buster, `Locales/enUS.lua:3249` zelf gelezen, Wowhead-nieuwsbericht + tientallen
  speler-reacties zelf gelezen). **[RAAKT ONS]** — geen harde tegenspraak (onze tip claimt niet dat
  de bug niet bestaat), wel een advies waarvan de onderliggende belofte tijdelijk onzeker is zolang
  Blizzard dit niet gefixt heeft. Geen tekstwijziging voorgesteld: er is geen betrouwbaar "doe dit
  in plaats daarvan" om te citeren, en de tip klopt weer zodra Blizzard het oplost. Mens beslist of
  er een tijdelijke disclaimer bij moet ("Valeera neemt momenteel meer schade dan bedoeld,
  Blizzard onderzoekt het — 16 okt").

  Verder nog in dezelfde forumpost: alle overige 12.1.5-known-issues staan nu op `fixed` (Housing
  blijft met drie open punten, buiten onze scope — decor-collision/vendor-icons, geen enkele
  addon-claim). Geen aanvullende hotfix-categorieën met content voor Delves/Professions/Quests dit
  run.

  Vandaag is zondag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261018b
  (volledig gelezen via Exa) ·
  https://us.forums.blizzard.com/en/wow/t/midnight-1215-content-update-known-issues-and-information/2381312?nocache=20261018d
  (volledig gelezen via Exa) ·
  https://www.wowhead.com/news/blizzard-investigating-valeera-survivability-issues-in-patch-12-1-5-383467
  (volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261018f
  (JSON, via Exa) · `docs/PTR_12.0.7_DATA.md` entry [2026-10-18] als aanleiding voor de
  Valeera-vraag (feit niet herhaald, zelf getoetst tegen geshipte MH-tekst) · codebase: `grep`
  case-insensitive repo-breed op "Valeera" en gerichte reads van `Locales/enUS.lua:3243-3249`,
  `docs/PTR_VALEERA_TREE.md`, `Modules/ValeeraProgress.lua`, `docs/RESEARCH_VALEERA_DPS_VIDEO.md`
  — allemaal vandaag gelezen. Eén content-vondst (Valeera-healer-advies), verder uitsluitend
  **[RAAKT ONS NIET]**. Geen actiepunt dat ík oppak — ik rapporteer, een mens beslist.

---

- [2026-10-19] 🔁 **Geen nieuwe hotfix-content sinds 16 okt, zelf opnieuw bevestigd; CurseForge
  ongewijzigd. Vandaag is maandag: de wekelijkse kaarten- en consumables-check liepen mee, beide
  zonder nieuwe bevindingen.**

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. gisteren).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261019z` (via Exa,
  JSON volledig gelezen, `pagination.totalCount: 8`): dezelfde drie draadjes als op 17/18 okt
  (esES/esMX-locale-fix, debug-printregel, coffer-key-shards-popup), alle drie eindigend op een
  reactie van `twelveinchy`. Geen nieuw bericht sinds gisteren. MEASURED.

  **Hotfixes: geen nieuwe sectie sinds "October 16, 2026" — zelf opnieuw gelezen, niet overgenomen
  van de API-/data-wachter van vandaag.** `news.blizzard.com/en-us/article/24307310/hotfixes-
  october-16-2026?nocache=20261019content`, volledige artikeltekst zelf gelezen: Dungeons and
  Raids/Labyrinth and Delves/Items/Labyrinth/Quests/Aqir Invasions/Classes/Delves-secties van 13
  t/m 16 okt byte-voor-byte dezelfde inhoud als al verwerkt op [2026-10-17]/[2026-10-18].
  Delves/Professions/Quests als losse categorieën waren en zijn leeg in de nieuwste sectie, niets
  nieuws te vergelijken. Ook de "12.1.5 Known Issues"-forumpost (Linxy,
  `us.forums.blizzard.com/.../2381312?nocache=20261019content`, zelf gelezen, bijgewerkt 16 okt
  18:44 PDT) nogmaals zelf nagelezen: *"Valeera is taking more damage than intended"* staat er nog
  steeds zonder `fixed`-label — dus de op [2026-10-18] gemelde **[RAAKT ONS]**-vondst
  (`DELVE_TIP_LABYRINTH_BOSS`, `Locales/enUS.lua:3249`, "take Valeera as a healer: the fight takes
  longer, but you are less likely to lose a life") blijft actueel en ongewijzigd: geen fix, dus nog
  steeds geen betrouwbaar alternatief advies om te citeren, geen tekstwijziging voorgesteld. Alle
  overige known-issues-punten staan nog op `fixed` zoals op 18 okt. MEASURED. **[RAAKT ONS NIET]**
  op de hotfix-kant vandaag; de enige openstaande **[RAAKT ONS]** is de al bekende
  Valeera-healer-kwestie, ongewijzigd sinds gisteren.

  🃏 **Kaarten:** Gecontroleerd welke van de 40 `Modules/PlayCards.lua`-kaarten een eigen
  `rechecked`-aantekening sinds hun oorspronkelijke bron-datum missen. 12 specs hadden dat: Frost
  Mage (64), Fury Warrior (72), Feral Druid (103), Guardian Druid (104), Survival Hunter (255),
  Assassination Rogue (259), Outlaw Rogue (260), Subtlety Rogue (261), Restoration Shaman (264),
  Demonology Warlock (266), Devastation Evoker (1467), Augmentation Evoker (1473) — vandaag via Exa
  opgehaald (icy-veins.com, `?nocache=20261019d`/`e`). Alle 12 Icy Veins-pagina's staan nu op
  "Last Updated: Oct 12, 2026 - 12.1.5" — nieuwer dan onze genoteerde datums (10-31 aug), dus op het
  eerste gezicht "stale". Van drie **volledig gelezen** (Frost Mage, Demonology Warlock, Restoration
  Shaman — melee/caster/healer-steekproef) staat letterlijk *"no real changes mechanically"* /
  *"Demonology Warlock received no changes for Patch 12.1.5"* / *"There are no changes to
  Restoration Shaman in Patch 12.1.5"*: de datumsprong is een patch-nummer-relabel van de hele site
  voor 12.1.5, geen rotatiewijziging. MEASURED voor die drie. Voor de overige 9 (Fury Warrior/Feral
  Druid/Guardian Druid/Survival Hunter/Assassination Rogue/Outlaw Rogue/Subtlety Rogue/Augmentation
  Evoker/Devastation Evoker) is alleen de datum bevestigd, niet de "Class Changes"-sectie zelf —
  **INFERRED** dat ze hetzelfde patroon volgen, niet als gecontroleerd gerapporteerd. Method.gg/
  Wowhead-datums voor deze 12 zijn dit run niet gecontroleerd (budget). Preservation Evoker (1468,
  al "rechecked 3 okt") apart gecheckt n.a.v. de Oct-8-patch-note-vermelding in
  `docs/PTR_12.0.7_DATA.md`: Icy Veins zegt de enige 12.1.5-wijziging is Consume Flame +20% healing
  "to offset a recent bug fix... will not impact any talent choices or rotational elements" — kaart
  blijft goed. De overige 28 kaarten (al "rechecked 3 okt") zijn deze week niet opnieuw
  gecontroleerd. Geen class-hotfix dit venster die knopvolgorde/drempels verandert (consistent met
  wat de API-/data-wachter deze week vonden: alleen tuning-percentages, geen mechaniek). Geen enkele
  kaart hoeft vandaag gewijzigd te worden.

  🧪 **Consumables:** `python tools/check_consumables.py` liep (report-only), maar **alle 39 specs**
  faalden met `Tunnel connection failed: 403 Forbidden` (egress-proxy blokkeert Python urllib naar
  icy-veins.com) — 0 geslaagde vergelijkingen via het eigen script. MEASURED. Uitgeweken naar Exa
  `web_fetch_exa` met `?nocache=20261019`: **alle 39 gems-enchants-consumables-pagina's zelf
  gelezen** (sourceURL = elke spec's `icyVeinsUrl` uit `data/vault_stat_catalog.json`,
  `-stat-priority` vervangen door `-gems-enchants-consumables`). Resultaat: elke pagina toont nog
  "Last Updated: Oct 12, 2026 - 4:30 PM" — exact de datum van onze eigen laatste
  drie-bronnen-check (`data/consumables_wowhead.json` meta.patchedSince). Geen enkele pagina is
  sindsdien bijgewerkt, dus volgens de eigen regel ("opnieuw melden alleen als Icy Veins nu een
  ánder item noemt, of zijn datum nieuwer is dan 12 okt") levert dit **geen nieuwe bevindingen** op.
  De bekende afwijkingen (DK Unholy flask, Paladin Protection flask, Rogue Outlaw combat potion — 12
  okt met 3 bronnen nagekeken) blijven ongewijzigd: 3, ongewijzigd. Mana-potion-uitzondering
  bevestigd consistent: de Restoration Druid-pagina zegt zelf "mana potions are very weak currently"
  en noemt er geen, zoals verwacht. Geen hotfix/patch van de afgelopen week die een consumable
  toevoegt of wijzigt. Alle 39 specs zijn gecontroleerd; geen enkele overgeslagen.

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261019content
  (volledig gelezen via Exa) ·
  https://us.forums.blizzard.com/en/wow/t/midnight-1215-content-update-known-issues-and-information/2381312?nocache=20261019content
  (volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261019z
  (JSON, via Exa) · 12 Icy Veins class-guide-pagina's (`?nocache=20261019d/e`) voor de kaarten-check
  · `python tools/check_consumables.py` (403 Forbidden) + 39 Icy Veins gems-enchants-consumables-
  pagina's (`?nocache=20261019`) voor de consumables-check · codebase: `Modules/PlayCards.lua`,
  `data/vault_stat_catalog.json`, `data/consumables_wowhead.json`, `Locales/enUS.lua:3249` —
  allemaal vandaag gelezen. Geen actiepunt dat ík oppak — ik rapporteer, een mens beslist.

---

- [2026-10-20] 🔴 **Eén echte content-vondst: onze eigen Codex-tekst over het Voidcore-"maximum"
  beschrijft precies het mechanisme dat een lopende, nog ongefixte Blizzard-bug op dit moment
  breekt.** Geen nieuwe hotfix-sectie sinds 16 okt (vijfde dag op rij), CurseForge ongewijzigd.
  Vandaag is dinsdag, dus de wekelijkse kaarten- (🃏) en consumables-check (🧪, beide alleen op
  maandag) zijn overgeslagen.

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. gisteren).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261020zz` (via
  Exa, JSON volledig gelezen, `pagination.totalCount: 8`): dezelfde drie draadjes als op 17-19 okt
  (esES/esMX-locale-fix, debug-printregel, coffer-key-shards-popup), alle drie eindigend op een
  reactie van `twelveinchy` (het coffer-key-shards-draadje eindigt al sinds juni op een bedankje
  van de vraagsteller zelf — geen nieuwe vraag). Geen nieuw bericht sinds gisteren. MEASURED.

  **Hotfixes: geen nieuwe sectie sinds "October 16, 2026" — zelf opnieuw gelezen, niet overgenomen
  van de API-/PTR-/data-wachter van vandaag.** `news.blizzard.com/en-us/article/24307310/hotfixes-
  october-16-2026?nocache=20261020content`, volledige artikeltekst zelf gelezen: Dungeons and
  Raids/Labyrinth and Delves/Items/Labyrinth/Quests/Aqir Invasions/Classes/Delves-secties van 13
  t/m 16 okt byte-voor-byte dezelfde inhoud als al verwerkt op [2026-10-17]/[2026-10-18]/
  [2026-10-19]. Delves/Professions/Quests als losse categorieën: leeg in de nieuwste sectie, niets
  nieuws te vergelijken. Ook de "12.1.5 Known Issues"-forumpost (Linxy,
  `us.forums.blizzard.com/.../2381312?nocache=20261020content`, zelf gelezen, nog steeds "updated
  October 16 at 6:44pm PDT", geen update sinds): *"Valeera is taking more damage than intended"*
  staat er nog steeds zonder `fixed`-label — de op [2026-10-18] gemelde **[RAAKT ONS]**-vondst
  (`DELVE_TIP_LABYRINTH_BOSS`, `Locales/enUS.lua:3249`) blijft actueel en ongewijzigd: geen fix,
  geen tekstwijziging voorgesteld. Alle overige known-issues-punten staan nog op `fixed`. MEASURED.
  **[RAAKT ONS NIET]** op de hotfix-kant vandaag; de enige openstaande **[RAAKT ONS]** uit de
  hotfix-sectie zelf is de al bekende Valeera-healer-kwestie, ongewijzigd sinds gisteren.

  🔴 **De vondst, aangeleverd door de data-wachter van vandaag die de operationele kant al oppakte
  (`docs/PTR_12.0.7_DATA.md`, entry [2026-10-20], "Nebulous Voidcore Current Season Maximum-bug")
  — dit is mijn onafhankelijke check van de content-kant, niet een herhaling van zijn feit.**
  Blizzard (Drahtz, Community Manager, 15 okt 2026 15:43 PDT, zelf gelezen via de data-wachters
  bronnen) bevestigt dat spelers hun "Current Season Maximum" voor Nebulous Voidcores onterecht
  zagen stijgen/raar staan (bv. "5/2") nadat per ongeluk te veel toegekende Voidcores weer werden
  teruggedraaid, en dat er "working on a fix" is — geen fixdatum, nog niet gefixed.
  `grep -n "VOIDCORE_BODY" Locales/Codex.lua` → `CODEX_VOIDCORE_BODY` (enUS,
  `Locales/Codex.lua:107`) zegt letterlijk, over exact die balk: *"The bar 'Nebulous Voidcores
  transmuted: 1/1' shows how many Voidcores you have earned this season against the current
  maximum. Spending one does not free up room: you can only get another when the maximum goes up,
  **and it goes up by one at every weekly reset.**"* Dat is precies het mechanisme dat nu voor een
  deel van de spelers kapot staat — hun maximum ging niet netjes "+1 per week" maar sprong door de
  bug naar een afwijkende waarde. Onze tekst beschrijft het BEDOELDE mechanisme correct (geen
  harde tegenspraak — we claimen niet dat de bug niet bestaat), maar een speler die een kapotte
  teller ziet kan onze eigen uitleg nu lezen als "dan klopt de addon niet", terwijl het een
  Blizzard-bug is die zelf nog loopt. MEASURED (hotfix-bron van de data-wachter zelf nagelezen,
  `Locales/Codex.lua:107` zelf gelezen; `Modules/VaultAdvisor.lua:1074-1119`
  (`ns.GetVoidcoreBonusRollStatus`) en `Modules/BonusRollCapture.lua` gelezen — beide lezen de
  vault-sloten/roll-popup live van de client, geen eigen hardcoded max-telling, dus die twee
  bestanden zijn zelf niet geraakt). De vertaalde varianten (`Locales/Codex.lua` overige 6 talen,
  `Locales/esMX.lua`, `Locales/ruRU.lua`) dragen dezelfde `CODEX_VOIDCORE_BODY`-key met dezelfde
  strekking — niet woord-voor-woord op deze zin geverifieerd per taal, dat is vertaalkant, niet
  content-kant. **[RAAKT ONS]** — geen tekstfout, wel een momentopname die een mens kan overwegen
  tijdelijk aan te scherpen met een regel als "zie je een rare sprong in dit cijfer, dat is een
  bekende, nog lopende Blizzard-bug" zolang Drahtz' fix er niet is. Geen tekstwijziging zelf
  doorgevoerd.

  **Fabled Let Me Solo Him: Kindo'jan (achievement 64039) — deadline met een week verlengd
  (data-wachter, zelfde entry van vandaag).** Voor mijn lane: `grep -rn "64039"` repo-breed geeft
  alleen `Modules/MidnightAchList.lua:45` (een ID in een lijst, geen datum) en wat aan context in
  `Modules/AtalUtekProbe.lua` en `Modules/SeasonTransitionData.lua` (allemaal dev-comments, geen
  speler-tekst) — geen `grep` op "october 21"/"oct 21"/"21 oktober" in `Locales/enUS.lua` levert
  iets op. Geen geshipte speler-tekst noemt een specifieke einddatum voor deze achievement die nu
  fout zou zijn. MEASURED. **[RAAKT ONS NIET]** — de door de data-wachter gevonden fout zit in
  `docs/NEXT_SESSION.md` (een dev-aantekening, niet speler-tekst), buiten mijn bestand en al door
  hem gemeld.

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261020content
  (volledig gelezen via Exa) ·
  https://us.forums.blizzard.com/en/wow/t/midnight-1215-content-update-known-issues-and-information/2381312?nocache=20261020content
  (volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261020zz
  (JSON, via Exa) · `docs/PTR_12.0.7_DATA.md` entry [2026-10-20] (Voidcore-bug, Fabled-deadline) als
  aanleiding — feiten niet herhaald, zelf getoetst tegen geshipte MH-tekst · codebase:
  `Locales/Codex.lua:106-107`, `Modules/VaultAdvisor.lua:1074-1119`, `Modules/BonusRollCapture.lua`,
  `Modules/MidnightAchList.lua`, `Modules/AtalUtekProbe.lua`, `Modules/SeasonTransitionData.lua` —
  allemaal vandaag gelezen. Eén content-vondst (Voidcore-maximum-tekst), verder uitsluitend
  **[RAAKT ONS NIET]**. Geen actiepunt dat ík oppak — ik rapporteer, een mens beslist.

---

- [2026-10-21] ✅ **Nieuwe hotfix-sectie "October 20, 2026" gelezen — acht items getoetst, geen
  tegenspraak; één oude mist-cap-claim bevestigd correct en al lang gefixed.** Vandaag is woensdag,
  dus de wekelijkse kaarten- (🃏) en consumables-check (🧪) worden overgeslagen.

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. gisteren).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261021zz2` (via
  Exa, JSON volledig gelezen, `pagination.totalCount: 8`): dezelfde drie draadjes als op 17-20 okt
  (esES/esMX-locale-fix, debug-printregel, coffer-key-shards-popup), alle drie eindigend op een
  reactie van `twelveinchy`. Geen nieuw bericht sinds gisteren. MEASURED.

  **Hotfixes: nieuwe sectie "October 20, 2026" — zelf gelezen, niet overgenomen van de API-/data-
  wachter van vandaag (beiden hebben deze sectie als operationeel/feitelijk feit al gelogd;
  dit is mijn onafhankelijke contradictie-check tegen geshipte MH-tekst).**
  `news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261021content`,
  volledige artikeltekst zelf gelezen: sectie "October 20, 2026" staat nu bovenaan (Achievements,
  Labyrinth, Items, Player versus PvP, Quests), vóór "October 16, 2026". Achievements/Labyrinth/
  PvP-caps vallen buiten mijn lane (resp. al gelogd op [2026-10-20], geen content-claim, geen
  MH-currency-tracking) — zie hieronder. Delves en Professions als losse categorieën: leeg in de
  nieuwste sectie, niets te vergelijken.

  📌 **Positieve controle, repo-brede scope, zelfde run:** `grep -ri "RAID_BOSS_KITHIX_STEPS"` geeft
  treffers in `Modules/RaidCoachData.lua` en alle zeven taalvarianten van `Locales/RaidTips.lua`;
  `grep -i "weekly cap"` geeft een treffer in `Locales/enUS.lua:4290` (Coffer Key Shards, andere
  currency). Beide patronen vinden dus iets op deze schaal — de 0-treffers hieronder zijn gemeten
  afwezigheid.

  **Bevindingen:**
  - **Items — "Mistcrests are now uncapped."** Al gelogd als feit door de API-/data-wachter
    (`docs/API_WATCH.md`, `docs/PTR_12.0.7_DATA.md`, beide entry [2026-10-21]). Voor mijn lane: dit
    is GEEN nieuwe tegenspraak, en het is ook geen oude tegenspraak die nu pas zichtbaar wordt — de
    claim "crests hebben een weekly cap van ~100 per kleur" stond ooit in de Codex en in de
    crest-gids, maar is **al op 22 juli 2026 verwijderd** (`CHANGELOG_2111_1`, `Locales/enUS.lua:3870`:
    *"Fixed: the crest pages claimed a weekly cap of roughly 100 per colour. There is no such cap —
    the game reports none on any tier — and the claim was already removed from the English and Dutch
    guide text on 22 July. It was still there in the Codex in all seven languages... Gone everywhere
    now."*). Vandaag opnieuw gegrept op "weekly cap"/"season cap"/"~100" in `Locales/enUS.lua`: de
    enige treffer is `SHARDS_CAP_REACHED`/`ALT_TOOLTIP_SHARDS_WEEKLY` — Coffer Key Shards, een andere
    currency met een écht bestaande wekelijkse cap, geen Mistcrest. MEASURED (0 treffers op een
    Mistcrest-capclaim in geshipte tekst; de enige overgebleven "cap"-tekst over Mistcrest is een
    code-comment in `Modules/CurrencyAccount.lua:506-508` en `Modules/DawncrestGuide.lua:815-819` —
    beide dev-diagnostiek voor `/mh curscan`, niet speler-tekst, en beide lezen de cap live van de
    client dus breken niet). **[RAAKT ONS NIET]** — bevestigt dat deze hotfix een claim raakt die wij
    drie maanden geleden al correct hadden ingetrokken.
  - **Labyrinth — "Fixed an issue that could sometimes prevent the 'Fools and Curses' scenario from
    completing."** Andere bug dan de al op [2026-09-xx]/regel 2609 gelogde "Cursed Energy kon niet
    gecleansed worden"-fix (14 okt), zelfde scenario-naam. Onze naamloze roomtaak-tekst ("Cursed
    energy: kill the relic raiders... take 5 purple curse orbs to the cursed sarcophagus",
    `Locales/DelveTips.lua`/`Locales/enUS.lua` via `DELVE_TIP_LABYRINTH_ROOMS`) claimt nergens iets
    over afrondbaarheid. MEASURED (0 treffers op "Fools and Curses" of "completion" in die roomtekst,
    zelfde conclusie als de eerdere, zwakkere kandidaat-match). **[RAAKT ONS NIET]**
  - **Labyrinth — "Fixed an issue where Spirit Conduit Loa powers could be used during Kindo'jan's
    fight."** Een exploit-fix (Loa-boons tijdens de baasfight gebruiken kon niet de bedoeling zijn).
    `CODEX_LABYRINTH_BODY`/`PATCH_12_1_5_TACTICS_DRAFT_2026-10-08.md:55` beschrijven de Loa-Spirit
    Conduits generiek ("4 per run, elke boon duurt 2 minuten, gebruik hem meteen") zonder claim over
    wél/niet-bruikbaar tijdens Kindo'jan zelf. MEASURED (`grep -i "spirit conduit"` repo-breed: alleen
    de generieke beschrijving, geen uitzondering voor de baasfight die nu zou kloppen of niet
    kloppen). **[RAAKT ONS NIET]**
  - **Items — Ancient Hash'ey Battle Art-enchants kunnen nu toegepast worden op "Warbound Until
    Equipped"-items.** Andere bug dan de al op regel 2616 gelogde itemlevel-fix (334→344, 15 okt).
    `CODEX_LABJOURNEY_BODY` (`Locales/Codex.lua:173`) noemt de vier enchants bij naam en hun scope
    ("work in every delve, not only here"), maar zegt niets over Warbound-items of op welke
    itemtypes ze toe te passen zijn. MEASURED (0 treffers op "Warbound" in de buurt van "Hash'ey" in
    de hele repo). **[RAAKT ONS NIET]**
  - **Items — "The Void Eruption effect on Kith'ix's armor pieces can no longer hit targets you
    aren't in combat with."** ⚠️ Naamcollision gecontroleerd: "Void Eruption" is ook de 12.0.0-naam
    waarvan onze Priest-keybindmodule weet dat hij is hernoemd naar "Voidform"
    (`Modules/KeybindRoles_Priest.lua:186-196`) — andere context, geen overlap met dit item-effect.
    `RAID_BOSS_KITHIX_STEPS`/`_TANK`/`_HEALER`/`_DPS` (`Locales/RaidTips.lua:104-111`, zeven
    taalvarianten) noemen uitsluitend losse `{SPELL:id}`-links voor Kith'ix' eigen aanvallen — geen
    "Void Eruption" en geen claim over een armor-effect. MEASURED (0 treffers op "Void Eruption" in
    de Kith'ix-tips zelf; de enige twee treffers in de repo zijn de Priest-naamsverandering en deze
    hotfix-tekst). **[RAAKT ONS NIET]**
  - **Quests — "The furbolgs required for the quest 'Not Quite Nalorakk' have returned from their
    hibernation."** 0 treffers op "Not Quite Nalorakk" repo-breed. Onze enige furbolg-tekst,
    `DELVE_CHAT_ATAL_AMAN_ROUTE` ("Ritual: rescue furbolgs..."), is een Atal'Aman-**delve**-routestap,
    geen overworld-quest — andere content, geen naam- of ID-overlap gevonden. MEASURED.
    **[RAAKT ONS NIET]**
  - **Quests — "Fixed an issue where spending Nebulous Voidcores on non-raid sources would not
    grant credit towards completing the 'A Nebulous Endeavour' tutorial quest."** Andere bug dan de
    op [2026-10-20] gelogde "Current Season Maximum"-sprong (ook Voidcore-gerelateerd, maar een
    missende questcredit in plaats van een kapotte teller). `Modules/BonusRollCapture.lua`
    (`ns.GetVoidcoreBonusRollStatus`-achtige lezing) en `Modules/VaultAdvisor.lua:1074-1119` lezen de
    bonusroll-status live van de client-popup; geen van beide hardcodet een claim over welke
    bron (raid/non-raid) meetelt voor een tutorial-quest. `grep -i "nebulous endeavour"` repo-breed:
    0 treffers, dus deze quest staat nog nergens in MH's eigen data. MEASURED. **[RAAKT ONS NIET]**
  - **Quests — "Resolved an issue where the Skardyn Behemoth could become unattackable, preventing
    completion of 'Draw Its Ire.'"** Dezelfde questreeks die de PTR/roadmap-wachter vandaag al als
    bekend open bugmeldingsthema noemde (`docs/PTR_12.1_WATCH.md`) — deze hotfix IS de fix. 0
    treffers op "Skardyn" of "Draw Its Ire" repo-breed: geen bestaande MH-tracker voor deze
    questreeks. MEASURED. **[RAAKT ONS NIET]**
  - **Quests — "Fixed an issue that prevented the completion of the Voidstorm quest 'To Be
    Changed'."** Vermoedelijk een (nog) niet-herdoopte placeholder-questnaam van Blizzard zelf, niet
    een naam die wij zouden kunnen dragen. 0 treffers op "To Be Changed" repo-breed; onze Voidstorm-
    teksten (`Modules/DelverCallData.lua`, `Modules/Rares.lua`, `Modules/EventInfoData.lua`) noemen
    delves, rares en events bij hun eigen naam, geen enkele quest met deze placeholder-titel.
    MEASURED. **[RAAKT ONS NIET]**
  - **Player versus PvP — Conquest/Bloody Tokens ongecapt, nieuwe "Spoils of War"-buff, nieuwe
    Venomous Equipment Chest bij Irissa Bloodstar.** Al gelogd door de API-wachter als buiten zijn
    terrein; voor mijn lane: `grep -i "conquest\|bloody token\|irissa\|spoils of war"` in
    `Modules/CurrencyGuide.lua` en `Modules/CurrencyAccount.lua`: 0 treffers in beide — MH tracked
    geen PvP-valuta's. De losse naam "Irissa" in `Modules/DelveTipMarkup.lua:164` is een coördinaat-
    label voor een NPC in een andere context (delve-markup), niet deze quartermaster. MEASURED.
    **[RAAKT ONS NIET]**

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-16-2026?nocache=20261021content
  (volledig gelezen via Exa, sectie "October 20, 2026") ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261021zz2
  (JSON, via Exa) · codebase: `Locales/enUS.lua` (grep + gerichte reads rond 3870, 4290, 3100, 3804),
  `Modules/CurrencyAccount.lua:495-520`, `Modules/DawncrestGuide.lua:780-849`, `Locales/DelveTips.lua`,
  `Locales/Codex.lua:173`, `Modules/RaidCoachData.lua:115-146`, `Locales/RaidTips.lua:104-111`,
  `Modules/KeybindRoles_Priest.lua:186-196`, `Modules/BonusRollCapture.lua`,
  `Modules/VaultAdvisor.lua:1074-1119`, `Modules/DelverCallData.lua`, `Modules/Rares.lua`,
  `Modules/EventInfoData.lua`, `Modules/CurrencyGuide.lua`, `Modules/DelveTipMarkup.lua:164` —
  allemaal vandaag gelezen. Acht content-items getoetst, alle acht **[RAAKT ONS NIET]** (één ervan
  bevestigt een drie maanden oude correctie, geen nieuwe actie). Geen actiepunt dat ík oppak — ik
  rapporteer, een mens beslist.

- [2026-10-22] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-21]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261022b`
  (en `&nocache=20261022c` als tweede, onafhankelijke fetch) via Exa, beide volledig gelezen (JSON,
  `pagination.totalCount: 8`). Alle drie de draadjes (esMX-locale `user_uvqy5939hswhgduu`, MrsBoojiePanda's
  debug-regel, gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog steeds een
  reply van `twelveinchy`; geen nieuwe reacties sinds [2026-10-21]. MEASURED. **[RAAKT ONS NIET]** — geen
  actiepunt vandaag.

- [2026-10-22] 🔴 **Eén echte content-vondst: Blizzards 21-okt-fix "praat met Kinduru in De Empire's
  Rest om het Labyrinth te verlaten tijdens het Kindo'jan-scenario" lijkt precies de bug te zijn die onze
  eigen "0 levens"-tip van gisteravond met een omweg (het touw bij de ingang) oplost — en de data-wachter
  miste de link omdat hij alleen in `Modules/` zocht, niet in `Locales/`.**
  MEASURED, zelf gelezen (`news.blizzard.com/en-us/article/24307310/hotfixes-october-21-2026?nocache=20261022b`,
  via Exa — nog steeds de nieuwste sectie, geen sectie van 22 okt gevonden): sectie **Labyrinth**, citaat:
  *"Players can now speak to Kinduru in De Empire's Rest antechamber to leave the labyrinth while on the
  Kindo'jan scenario."* "De Empire's Rest" is geen Blizzard-naam die wij verzinnen — het is onze EIGEN,
  al langer gemeten naam voor het gebied vóór en tijdens de Kindo'jan-fight
  (`docs/PATCH_12_1_5_TACTICS_DRAFT_2026-10-08.md:95`: *"Heart / Enemy / Soul of the Labyrinth (3444, 3678) |
  De Empire's Rest → Den'Zara → Kindo'jan"*; ook `docs/labyrinth_run_2026-10-19/README.md` rij 10 en
  `report_D.md`/`report_E.md`, alle drie al vóór vandaag geschreven).
  Onze eigen tip, geschreven gisteravond (`Locales/enUS.lua:3367`, `DELVE_TIP_LABYRINTH_BOSS`, commit
  `31c734d`): *"Out of lives before he dies? Normally the run ends and you are sent to the treasure room
  (Rob, 15 Oct). Sometimes it does not: you keep coming back with 0 lives and Kinduru is gone. Kinduru's
  toy that ends a run did nothing either (Carola, 21 Oct). What works: walk back to the start of the
  Labyrinth and click the coiled rope by the closed door."* — hetzelfde symptoom (Kinduru weg, toy doet
  niets, vastzitten met 0 levens), gemeten door Carola op dezelfde dag als deze hotfix. `docs/NEXT_SESSION.md:32-36`
  bevestigt: *"Geen hotfix over 0 levens gevonden (mh-research); spelers melden dezelfde fout al sinds
  18 okt."* — die hotfix was er dus kennelijk al, alleen nog niet gevonden toen dat geschreven werd.
  **INFERRED, niet GEMETEN in het spel:** dat dit dezelfde bug is die de hotfix fixt — de locatienaam en
  het symptoom passen exact, maar niemand heeft nog geprobeerd of Kinduru nu weer in De Empire's Rest
  staat en praten met hem écht werkt. Als dat klopt, is onze "loop terug naar het touw"-omweg sinds 21 okt
  misschien niet meer de snelste (of enige) uitweg — maar het touw blijft werken voor wie de hotfix nog
  niet heeft, of liever niet test. **Ik verander niets; een mens besluit of en hoe de tip wordt aangepast,**
  en of Rob/Carola het bij een volgende 0-levens-situatie wil uitproberen voordat hij terugloopt naar het
  touw.
  📌 **Waarom dit de moeite van het hele-boom-doorzoeken waard was:** de data-wachter noemde "Kinduru" vandaag
  ook (`docs/PTR_12.0.7_DATA.md`), maar zocht alleen in `Modules/` en concludeerde "niets over scenario-exits,
  geen bestaande claim die dit raakt" — waar, voor zover het zoekterrein ging; `Modules/` heeft zo'n claim
  niet. De claim staat in `Locales/enUS.lua`, buiten zijn zoekterrein. Zelfde patroon als de gewaarschuwde
  val: een leeg zoekresultaat op de verkeerde schaal bewijst niets over de juiste schaal.
  Verder in dezelfde sectie (Labyrinth/Items/PvP), alle **[RAAKT ONS NIET]** — geen bestaande MH-tekst die
  deze claims tegenspreekt (full-tree grep op `Locales/` + `Modules/` + `docs/`; positieve controle: dezelfde
  zoekmethode vond moeiteloos de Kinduru-vondst hierboven, mist dus geen content die er wél staat):
  - *"Fixed an issue where L00T RAID-R Minis could not be used in a group inside the labyrinth."* — andere
    bug dan de al op [2026-10-16] gelogde "kon maar één keer gebruikt worden"-fix (regel 2825). Onze teksten
    (`Config.lua:29`, `Modules/DelveItemBrokers.lua`, `Modules/DelveItemsPopup.lua`, alle locale-strings)
    claimen nergens iets over groepsgebruik. MEASURED (0 treffers op "group" bij RAID-R Mini).
  - *"The lever to start 'A Golden Opportunity' can now be used by players level 80 and above."* — onze
    tekst (`Locales/enUS.lua:3366`, `DELVE_TIP_LABYRINTH_ROOMS`: *"A Golden Opportunity: pull the golden
    lever, then loot the room..."*) noemt geen levelvereiste. MEASURED (0 treffers op "level 80" of "level
    75" bij Golden Opportunity in de hele repo).
  - *"Players can now hold up to 4 stacks of the Carrying a Jan'alai Tear buff at a time (was 1)."* —
    al gemeld door de API-/data-wachter vandaag; onze Containment Breach-stap
    (`docs/PATCH_12_1_5_TACTICS_DRAFT_2026-10-08.md:86`; speler-tekst in `Locales/enUS.lua:3366` noemt
    "click a Jan'alai Tear" zonder aantal) claimt geen trip-aantal. MEASURED.
  - *"Fixed an issue ... that could cause the Pit Boss to despawn when it left combat, preventing
    [Returning the Bounty] from completing."* — andere despawn-bug dan de al op [2026-10-16] gelogde
    spawn-bug (regel 2796-2798). Onze tekst (`Locales/enUS.lua:3366`, Returning the Bounty-regel) claimt
    niets over despawnen. MEASURED.
  - *"Fixed an issue where the Seriously Sharp Seashell effect from Gebbo's Bottomless Bag could break
    stealth and invisibility effects."* — 0 treffers op "Seashell" of "Bottomless Bag" in de hele repo; de
    enige "Gebbo" in onze data is Trader Gebbo, een andere entiteit (raid-boss in The Lost Explorers,
    `Modules/RaidCoachData.lua:248`). MEASURED, geen overlap.
  - *"Fixed an issue where Jan'thrazet, the Soul Fang could sometimes fail to trigger reliably... for
    healers."* — 0 treffers op "Jan'thrazet" of "Soul Fang" in de hele repo: deze mob heeft geen MH-tip.
    MEASURED.
  - *"Fixed an issue preventing Nebulous Voidcache bonus roll item list previews from updating... This was
    only a display issue and did not affect which items a character was eligible for."* — 0 treffers op
    "Voidcache" in `Locales/` of `Modules/`; `Modules/BonusRollCapture.lua` en `Modules/VaultAdvisor.lua`
    lezen de bonusroll-status live van de client-popup, claimen niets over previewgedrag. MEASURED.
  - *Priest Holy — "Sanctified Ground applying to allies would interrupt channeled spells such as Divine
    Hymn."* — een PvP-talentinteractie; onze Divine-Hymn-teksten (`Modules/KeybindRoles_Priest.lua:140`,
    `Modules/HealerCooldowns.lua:158`, `Modules/GroupPlan.lua:282`) noemen Sanctified Ground nergens en
    claimen geen PvP-synergie. MEASURED.

  — bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-21-2026?nocache=20261022b
  (volledig gelezen via Exa) · codebase: `Locales/enUS.lua` (grep + gerichte read rond 3355-3370),
  `docs/NEXT_SESSION.md:1-54`, `docs/PATCH_12_1_5_TACTICS_DRAFT_2026-10-08.md:86,91,95`,
  `docs/labyrinth_run_2026-10-19/README.md`, `docs/PTR_12.0.7_DATA.md` (vergeleken, niet overgenomen),
  `Config.lua:29`, `Modules/DelveItemBrokers.lua`, `Modules/DelveItemsPopup.lua`, `Modules/RaidCoachData.lua:248`,
  `Modules/BonusRollCapture.lua`, `Modules/VaultAdvisor.lua`, `Modules/KeybindRoles_Priest.lua:140`,
  `Modules/HealerCooldowns.lua:158`, `Modules/GroupPlan.lua:282` — allemaal vandaag gelezen. Negen
  content-items getoetst, één **[RAAKT ONS]** (de Kinduru/De-Empire's-Rest-vondst), acht **[RAAKT ONS NIET]**.
  Geen actiepunt dat ík oppak — ik rapporteer, een mens beslist.

- [2026-10-24] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-22]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261024c`
  (en `&nocache=20261024d` als tweede, onafhankelijke fetch) via Exa, beide volledig gelezen (JSON,
  `pagination.totalCount: 8`). Alle drie de draadjes (esES/esMX-locale `user_uvqy5939hswhgduu`, nu
  zelf omgerekend MEASURED: `1791322444427`→2026-10-06 21:34 UTC, reply `twelveinchy`
  `1791351710373`→2026-10-07 05:41 UTC; MrsBoojiePanda's debug-regel; gadrinonturalyon's
  coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog steeds een reply van `twelveinchy`; geen
  nieuwe reacties. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt vandaag, geen concept-antwoord nodig.

- [2026-10-24] 🟡 **Eén nieuwe hotfix-sectie sinds [2026-10-22] ("October 23, 2026"), zes regels in
  Dungeons/Classes/Hallow's End/Items/Labyrinth getoetst tegen onze tips — vijf duidelijk
  [RAAKT ONS NIET], één met een onopgeloste vraag die ík niet kan sluiten: welke van TWEE spell-ID's die
  wij aan Nibbles toeschrijven "Fel Spray" is.**
  MEASURED, zelf gelezen (`news.blizzard.com/en-us/article/24307310/hotfixes-october-23-2026?nocache=20261024c`,
  via Exa — dezelfde pagina als de data-/API-wachter vandaag al citeerden, hier zelf opnieuw gelezen voor
  mijn eigen lane): secties **Classes**, **Dungeons**, **Hallow's End**, **Items** en **Labyrinth**. De
  Quests/Professions-secties ontbreken in deze batch — niets te toetsen daar.

  - **Dungeons — Den of Nalorakk:** *"Addressed an issue where Nalorakk's Echoing Maul can sometimes
    happen in the wrong location."* `Modules/HazardData.lua:105` noemt spell **1242887** ("Echoing
    Maul") als generieke GTFO-stijl grond-hazard voor encounter 2825 (Den of Nalorakk), zonder claim over
    wáár hij verschijnt. Onze eigen fight-tekst (`Locales/DungeonTips.lua:151`, `DGN_TIP_DN_NALORAKK_STEPS`)
    noemt Echoing Maul/1242887 niet eens met naam — de vijf stappen gaan over Marks, Echoes, het schild en
    Forceful Slam, geen enkele claimt een locatie voor deze specifieke aanval. MEASURED (0 treffers op
    "Echoing Maul" buiten `HazardData.lua`, positieve controle: dezelfde full-tree grep vindt wél 1242887
    zelf en de 14 andere Nalorakk-spell-ID's in diezelfde tabel). **[RAAKT ONS NIET]** — een bugfix op
    een locatie die wij niet claimen.
  - **Dungeons — Murder Row:** *"Addressed an issue where Nibbles' Fel Spray can hit targets outside of
    the intended area."* 🔴 **Hier loopt onze eigen data uit elkaar, en dat wil ik melden, niet
    gladstrijken.** `Modules/HazardData.lua:91` noemt spell **1253813** met het commentaar "Fel Spray
    (Nibbles)" — GEMETEN via Rob's eigen client (18 aug, tooltip), onderdeel van de generieke
    hazard-lijst voor heel Murder Row (encounter 2813). Onze Kystia-fighttips
    (`Locales/DungeonTips.lua:102` `DGN_TIP_MR_KYSTIA_STEPS` stap 4 en `:107` `DGN_TIP_MR_KYSTIA_TANK`)
    noemen daarentegen spell **1253811** — "Nibbles' {SPELL:1253811} cone" en het vuur dat hij op de
    grond achterlaat — zonder dat wij ooit de clientnaam van 1253811 hebben vastgesteld. `grep -rn
    1253811\|1253813` over de hele boom geeft alleen deze twee plekken, in geen enkel bestand samen.
    **INFERRED, niet GEMETEN:** ik weet niet of 1253811 en 1253813 dezelfde aanval zijn onder twee
    moeilijkheidsgraad-ID's (vaak zo in WoW), of twee losse Nibbles-aanvallen die wij allebei los hebben
    opgepikt. Wat ik wél met zekerheid kan zeggen: onze instructie ("blijf uit de kegel en het vuur op de
    grond") is een gedragsinstructie, geen claim over een specifieke straal of gebied — een hotfix die het
    trefgebied van Fel Spray nauwkeuriger maakt (zodat het NIET meer buiten het bedoelde gebied raakt)
    spreekt die instructie dus niet tegen, welke van de twee ID's het ook is. **[RAAKT ONS NIET]** voor de
    tip zelf, maar de dubbele toeschrijving (1253811 vs 1253813, allebei "Nibbles") is iets voor een mens
    om ooit in-game te ontwarren — ik verander niets.
  - **Hallow's End — Neighborhoods:** *"Players can now exit combat with the Shade of Seabreaker
    Skoloth."* Jaarlijks feestdag-event, geen Midnight-12.1-koppeling. `grep -rni
    "hallow\|seabreaker\|skoloth"` over de hele boom geeft **nul** treffers in `Locales/` en als enige
    hit in `Modules/` de naam "Horseman's Hallowed Bulwark" (`Modules/TradingPost.lua:216`) — een Trading
    Post-cosmeticaset, een andere "Hallowed" dan dit event. MEASURED, positieve controle via de
    "Hallowed Bulwark"-treffer in dezelfde zoekvorm. **[RAAKT ONS NIET]**.
  - **Items:** *"Fixed an issue that caused items upgraded with Ascendant Venomstones to have incorrect
    item levels."* De data-wachter toetste dit vandaag al tegen `Modules/TrackCeiling.lua` en concludeerde
    "vermoedelijk raakt ons niet" — ik heb dat ONAFHANKELIJK vanuit mijn eigen lane nagelopen (niet alleen
    overgenomen) door te lezen wát `ns.GetVenomstoneSteps()` (`Modules/TrackCeiling.lua:179-197`) de
    speler laat zien: track-namen en huidig/max-trackniveau (bv. "Hero 4/8" via
    `TRACKCEIL_VENOM_CAND_FMT`), nooit een los itemlevel-getal. `ns.GetVenomstoneStatus()`
    (`Modules/TrackCeiling.lua:158-173`) leest `C_Item.GetItemCount` en trackID's, geen itemlevel-API.
    MEASURED. **[RAAKT ONS NIET]** — bevestigd vanuit een tweede hoek, geen nieuwe twijfel.
  - **Labyrinth:** *"Shorter character models will no longer fall through floor when respawning in
    Jan'alai's Refuge."* Een clientbug over modelgrootte/respawn, geen gameplay-claim. Onze content over
    Jan'alai's Refuge is uitsluitend coördinaten (`Modules/DelveChestData.lua:115-118,146`, vier
    kistlocaties) en de Hexmask-locatie (`Modules/LabyrinthHexmask.lua:31`) — geen van beide claimt iets
    over vloeren of respawnen. MEASURED (0 treffers op "fall through"/"respawn" in combinatie met "Refuge"
    in de hele boom). **[RAAKT ONS NIET]**.
  - **Classes — Warlock:** *"Fixed issues that caused some warlock summons and Diabolic Occuli to
    sometimes incorrectly target enemies outside of combat"* (Shadows of Nath'reza, Dominion of Argus,
    Diabolist-summons). Dit raakt gedrag buiten combat, geen rotatie-advies. Onze twee Diabolist-kaarten
    (`Locales/enUS.lua:1990` `PLAYCARD_266_HERO1`, `:2008` `PLAYCARD_267_HERO2`) noemen Ruination en
    Pit Lord-timing, geen van beide noemt summon-targeting of de genoemde talenten/pets. MEASURED (0
    treffers op "Nath'reza"/"Dominion of Argus"/"Diabolic Occuli" in `Locales/`; de enige "Diabolist"-
    treffer buiten de twee kaarten is een spec-ID-naamtabel, `Modules/VaultAdvisorData.lua:1018`, niet
    gedrag). **[RAAKT ONS NIET]**. De Enhancement/Cooldown-Manager-regel in dezelfde Classes-sectie is al
    getoetst door de API-wachter (`docs/API_WATCH.md:7091`) op zíjn terrein; ik doe dat niet opnieuw.

  — bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-23-2026?nocache=20261024c
  (volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261024c
  (en `&nocache=20261024d`, via Exa) · codebase: `Modules/HazardData.lua:91,105`,
  `Locales/DungeonTips.lua:102,107,151`, `Modules/MechanicNameProbe.lua:54-55`,
  `Modules/DungeonRosterData.lua:105,113,122`, `Modules/TradingPost.lua:216`,
  `Modules/TrackCeiling.lua:140-243`, `Modules/CharacterSidePanel.lua:170-173`,
  `Modules/MidnightCodexData.lua:505`, `Modules/DelveChestData.lua:115-118,146`,
  `Modules/LabyrinthHexmask.lua:19,31`, `Locales/enUS.lua:1990,2008`, `Modules/VaultAdvisorData.lua:1018`
  — allemaal vandaag gelezen. Zes content-items getoetst, alle zes **[RAAKT ONS NIET]**, met één
  onopgeloste dataknoop (1253811 vs 1253813) die ik meld in plaats van zelf te beslissen. Vandaag is geen
  maandag: de wekelijkse PlayCard- en Consumables-checks zijn bewust overgeslagen. Geen actiepunt dat ík
  oppak — ik rapporteer, een mens beslist.

- [2026-10-25] 💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v.
  [2026-10-24]).** `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261025a`
  (en `&nocache=20261025b` als tweede, onafhankelijke fetch) via Exa, beide volledig gelezen (JSON,
  `pagination.totalCount: 8`). Dezelfde drie draadjes als op [2026-10-24] (esES/esMX-locale
  `user_uvqy5939hswhgduu`, reply-id `8510682`; MrsBoojiePanda's debug-regel, reply-id `8483898`;
  gadrinonturalyon's coffer-key/3D-model-verzoek) hebben als nieuwste bericht nog steeds een reply van
  `twelveinchy`. Voor het geneste gadrinonturalyon-draadje expliciet uitgerekend: reply `8095337`
  (`twelveinchy`, `1782157289840` ms) ligt NA gadrinonturalyon's eigen laatste bericht `8092133`
  (`1782075006067` ms) — dus ook daar is de maintainer het laatste woord, niet alleen qua positie in de
  boom maar qua tijdstip. MEASURED: alle id's en timestamps zijn byte-identiek aan [2026-10-24]; geen
  nieuwe reacties. **[RAAKT ONS NIET]** — geen actiepunt, geen concept-antwoord nodig.

- [2026-10-25] ✅ **Geen nieuwe hotfix-sectie: nieuwste blijft "October 23, 2026", zelfde datum als
  [2026-10-24] al meldde — zelf opnieuw gelezen, niet overgenomen van de API-/PTR-wachter van vandaag
  (die onafhankelijk tot dezelfde datum kwamen).** MEASURED:
  `news.blizzard.com/en-us/article/24307310/hotfixes-october-23-2026?nocache=20261025a` via Exa, volledig
  gelezen. De pagina toont in volgorde October 23 → October 21 → October 20, geen 24e of 25e sectie.
  **Anti-cache-controle:** de getoonde October-23-sectie bevat byte-voor-byte dezelfde zes regels
  (Classes/Shaman/Warlock, Dungeons/Den of Nalorakk/Murder Row, Hallow's End/Neighborhoods,
  Items/Venomstones, Labyrinth) als al op [2026-10-24] getoetst — niet ouder dan wat gisteren al gelogd
  stond, dus geen cache-val; de Professions- en Quests-secties ontbreken nog steeds in deze batch, net als
  gisteren. Geen nieuwe content om tegen onze teksten te toetsen, dus geen nieuwe grep-ronde nodig.
  Vandaag is geen maandag: de wekelijkse PlayCard- en Consumables-checks zijn bewust overgeslagen.
  **[RAAKT ONS NIET]** — geen actiepunt, een mens hoeft niets te beslissen.

- [2026-10-26] ✅ **Geen nieuwe hotfix-content sinds 23 okt (zelf herbevestigd); CurseForge
  ongewijzigd. Vandaag is maandag: de wekelijkse kaarten- en consumables-check liepen mee, geen van
  beide leverde een wijziging op.**

  💬 **CurseForge: geen open reacties (3 draadjes, 8 berichten — ongewijzigd t.o.v. [2026-10-25]).**
  `curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261026e` (en
  `&nocache=20261026f` als tweede, onafhankelijke fetch) via Exa, beide volledig gelezen (JSON,
  `pagination.totalCount: 8`). Dezelfde drie draadjes als gisteren (esES/esMX-locale-fix
  `user_uvqy5939hswhgduu`, reply `8510682`; MrsBoojiePanda's debug-printregel, reply `8483898`;
  gadrinonturalyon's coffer-key-shards/3D-boss-model-verzoek, reply-keten tot `8095337`/`8092133`)
  hebben als nieuwste bericht nog steeds een reactie van `twelveinchy` — ids en timestamps
  byte-identiek aan [2026-10-25]. MEASURED. **[RAAKT ONS NIET]** — geen actiepunt, geen
  concept-antwoord nodig.

  **Hotfixes: nieuwste blijft "October 23, 2026" — zelf opnieuw gelezen, niet overgenomen van de
  API-/PTR-/data-wachter van vandaag (die onafhankelijk tot dezelfde datum kwamen).** MEASURED:
  `news.blizzard.com/en-us/article/24307310/hotfixes-october-23-2026?nocache=20261026e` via Exa,
  volledig gelezen. Dezelfde zes regels (Classes/Shaman/Warlock, Dungeons/Den of Nalorakk/Murder
  Row, Hallow's End/Neighborhoods, Items/Venomstones, Labyrinth) als al tot in detail getoetst op
  [2026-10-25] (zes content-items, alle zes **[RAAKT ONS NIET]**, met de ene onopgeloste dataknoop
  1253811 vs 1253813 nog steeds onopgelost en nog steeds een zaak voor een mens, niet voor mij).
  Niets nieuws te vergelijken, dus geen nieuwe grep-ronde.

  🃏 **Kaarten:** Eerste keer dat deze check weer draait sinds [2026-10-19] (de vorige maandag). Van
  de 40 kaarten in `Modules/PlayCards.lua` missen er nog steeds dezelfde 12 een `rechecked`-aantekening
  sinds hun bron-datum (Frost Mage 64, Fury Warrior 72, Feral Druid 103, Guardian Druid 104, Survival
  Hunter 255, Assassination Rogue 259, Outlaw Rogue 260, Subtlety Rogue 261, Restoration Shaman 264,
  Demonology Warlock 266, Devastation Evoker 1467, Augmentation Evoker 1473) — niemand heeft ze sinds
  vorige week bijgewerkt; dat is ook niet mijn taak, alleen rapporteren. Vier Icy Veins-pagina's
  opnieuw gelezen (`?nocache=20261026`): Frost Mage, Restoration Shaman en Demonology Warlock (alle
  drie uit die groep van 12) staan **nog steeds** op "Last Updated: Oct 12, 2026 - 4:30 PM (13d ago)"
  — exact de datum die vorige week al als "relabel voor 12.1.5, geen echte wijziging" werd vastgesteld,
  nu 14 dagen later nog ongewijzigd. Ook Retribution Paladin (70, wél "rechecked 3 okt") staat nog op
  diezelfde Oct-12-datum, dus de groep van 28 al-"rechecked" kaarten loopt sindsdien evenmin uit de pas.
  MEASURED voor deze 4.
  Twee van de 12 hadden wél een verser gedateerde bron dan Icy Veins: Method.gg voor Feral Druid (103,
  ons: "Method 1 Oct", nu "Last Updated: 16th Oct, 2026") en voor Survival Hunter (255, ons: "Method 3
  Sep", nu "14th Oct, 2026"); Wowhead voor Survival Hunter ook ("Wowhead 23 Sep" → "2026/10/13"). Alle
  drie **volledig gelezen**, niet alleen de datum. Feral Druid: Method's huidige opener (Prowl → Tiger's
  Fury → Rake → Berserk → Feral Frenzy → Rip → Convoke → Ferocious Bite) en prioriteit (Tiger's
  Fury/Berserk/Feral Frenzy/Convoke op cooldown, dan Ferocious Bite op 5 Combo Points, dan Rip in
  pandemic, dan Rake/Shred als builders) komt overeen met onze eigen stappen (`Locales/enUS.lua:1809-
  1825`, `PLAYCARD_103_*`): S1 (Berserk+Tiger's Fury+Convoke samen), S2 (Tiger's Fury op cooldown,
  Feral Frenzy erbinnen), S3 (Rake/Rip onderhouden, Rip op 5 CP), S4 (Ferocious Bite op 5 CP + 50
  Energy), S5 (Shred als builder) — **geen wijziging nodig**. Survival Hunter: Wowheads huidige
  prioriteit (Hunter's Mark → Kill Command op Howl-beast → Wildfire Bomb/Boomstick/Raptor Swipe op
  Tip-of-the-Spear-stack → Raptor Strike → Kill Command) en Method's opener (inclusief spell
  **Boomstick**, spell-ID **1261193** — zelf opgezocht op Wowhead, komt overeen met `PLAYCARD_255_S3`'s
  `{SPELL:1261193}`) kloppen met onze kaart (`Locales/enUS.lua:1939-1943`, `PLAYCARD_255_S1`-`S4`); de
  enige afwijkende naam in Method's tekst, "Flamefang Pitch", is zelf opgezocht en bestaat niet meer
  sinds Season 2 (patch 12.1.0, warcraft.wiki.gg: "Removed" 11 aug 2026) — Method's eigen tekst is daar
  zelf verouderd, wij noemen die spell nergens, dus geen actie. **Geen van deze twee kaarten hoeft
  gewijzigd te worden.**
  Budget-grens: de overige 34 kaarten (de 28 "rechecked 3 okt" minus de hierboven gecontroleerde
  Retribution Paladin, plus de resterende 7 van de 12 zonder recheck: Fury Warrior, Guardian Druid,
  Assassination Rogue, Outlaw Rogue, Subtlety Rogue, Devastation Evoker, Augmentation Evoker) zijn deze
  week **niet gecontroleerd** — niet als "nog vers" gerapporteerd, gewoon niet bekeken. Geen
  class-hotfix deze week die knopvolgorde of drempels raakt buiten de twee al in het hoofdbericht
  getoetste items (Shaman Enhancement Cooldown-Manager-weergave, Warlock summon-targeting buiten
  combat) — beide **[RAAKT ONS NIET]**, geen van beide is een rotatiewijziging.

  🧪 **Consumables:** `python tools/check_consumables.py` liep (report-only), **alle 39 specs** faalden
  met `Tunnel connection failed: 403 Forbidden` (egress-proxy blokkeert Python urllib naar icy-veins.com,
  zelfde bekende beperking als eerdere maandagen). MEASURED. Uitgeweken naar Exa `web_fetch_exa`
  (`?nocache=20261026`), maar dit keer een steekproef van **6 van de 39** gems-enchants-consumables-
  pagina's in plaats van alle 39 (budget, na de uitgebreide kaarten-check hierboven): Blood Death
  Knight, Restoration Druid, Frost Mage, Brewmaster Monk, Protection Paladin, Outlaw Rogue — bewust
  gespreid over tank/healer/dps en melee/caster. Alle zes staan nog op **"Last Updated: Oct 12, 2026 -
  4:30 PM (13d ago)"**, dezelfde datum als `data/consumables_wowhead.json`'s `patchedSince` al noemt —
  geen van de zes is sindsdien bijgewerkt. De twee bekende afwijkingen in deze steekproef kwamen overeen
  met wat al bekend is: Protection Paladin noemt zelf "Flask of the Shattered Sun" (wij: Flask of the
  Blood Knights — 12 okt met 3 bronnen nagekeken, ongewijzigd) en Outlaw Rogue noemt zelf "Potion of
  Recklessness" (wij: Light's Potential als hoofdkeuze, Recklessness als alternatief — ongewijzigd).
  MEASURED voor deze 6. De overige **33 specs zijn deze week niet gecontroleerd** (alle specs uit
  `data/vault_stat_catalog.json` behalve de 6 hierboven) — niet als "actueel" gerapporteerd, simpelweg
  niet bekeken. Geen hotfix/patch van de afgelopen week die een consumable toevoegt of wijzigt (zelfde
  drie hotfix-secties als in het hoofdbericht, geen consumable-vermelding erin).

  Bron: https://news.blizzard.com/en-us/article/24307310/hotfixes-october-23-2026?nocache=20261026e
  (volledig gelezen via Exa) ·
  https://www.curseforge.com/api/v1/mods/1528577/comments?pageIndex=0&pageSize=20&nocache=20261026e
  (en `&nocache=20261026f`, via Exa) · 4 Icy Veins class-guide-pagina's + Method.gg (Feral Druid,
  Survival Hunter) + Wowhead (Survival Hunter rotation- en abilities-talents-gids) + de Wowhead-
  spellpagina 1261193 (Boomstick) en de Flamefang-Pitch-opzoekactie (warcraft.wiki.gg), allemaal via
  Exa met `?nocache=20261026` — voor de kaarten-check · `python tools/check_consumables.py` (403
  Forbidden) + 6 Icy Veins gems-enchants-consumables-pagina's (`?nocache=20261026`) voor de
  consumables-check · codebase: `Modules/PlayCards.lua:62-364`, `Locales/enUS.lua:1809-1825,1938-1952`,
  `data/vault_stat_catalog.json`, `data/consumables_wowhead.json` — allemaal vandaag gelezen. Geen
  actiepunt dat ík oppak — ik rapporteer, een mens beslist.
