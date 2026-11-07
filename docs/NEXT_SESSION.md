# Midnight Helper — waar we staan

## ☀️ 7 nov — ochtendronde

- Alle vier de wachters gedraaid. Raakt ons: 🔴 Ula'tek Serpent's Bite 3 → 2 spelers (hotfix 6 nov; het getal komt
  alleen uit Wowheads datamining, Blizzard noemt geen getal). Onze tip `{SPELL:1295905}` zegt in 8 packs nog "drie"
  (`Locales/RaidTips.lua:93` e.v. + `ruRU.lua:4790`, GEMETEN door de content-wachter). Niets veranderd; Rob kiest
  (in het spel tellen of overnemen van Wowhead).
- CF/GitHub: 0 wachtend. HandyNotes 168: 3 Midnight-rares Rare → RareElite, zelfde coördinaten. Addons: 47 bijgewerkt,
  niets dat MH raakt (gelezen, niet getest). Vragenlijst #31 bijgeteld (Rob: *"Ja, tel bij"*), gemiddelde 4,1.
- Forever: class-tuning aangekondigd voor 10 nov → dan de `ForeverBlock_<Class>.lua`-tabellen nalopen.

## 🌙 6 nov, einde dag — Rob: "Morgen misschien een release"

- Alles van vandaag staat op main (laatste commit: Hunter + Mage blok D). Werkboom schoon.
- Release alleen op Robs go. Voor Forever: stappen in `docs/PLAN_FOREVER_RELEASE_2026-11-06.md` (de Camelot-TOC zit
  nog niet in git of de zip). Nog niet in het spel gezien: How you play van de 5 nieuwe classes, Hunter/Warlock
  pet-toetsen, de familieknop in Forever, Quick bar ✅ wel. Testlijst: de secties van 6 nov.

## 📖 6 nov (nacht, later) — Forever: How you play voor alle 9 classes (Rob: "Ja, schrijf ze")

- Warrior/Rogue/Priest/Shaman/Warlock in `ForeverHowToPlay.lua`: mh-writer schreef uit `FOREVER_<CLASS>_2026-11-06.md`
  + de tabellen; mh-research controleerde los (18 checks: 14 GEMETEN waar, 2 AFGELEID waar, 2 alleen in het spel; 21
  zinnen verbeterd of aangevuld, o.a. Imp-questnaam per ras, Soul Shard-kosten, Rogue-poeders, Shaman-totemvoorwerpen,
  Charge alleen buiten gevecht); mh-writer verwerkte alles. Rapport: `docs/forever/HOW_TO_PLAY_FACTCHECK_5_CLASSES_2026-11-06.md`.
- GEMETEN (scratch `htp_check.py`): 91/91 toetsregels over 9 classes kloppen met de tabellen, tegenproef gevangen; 0
  `[check` en 0 losse `**` over; syntax OK, lint 0 HARD. ⚠️ Alleen regels van de vorm `**KEY** = Spell` worden
  gecontroleerd; zinnen als "Overpower on 2" niet.
- Mage-tekst: wand "once you have one" (Rob had nog geen wand). Mage level 1 ✅ Rob *"lijkt ook alles te werken"*.
- ✅ Warlock blok D (Rob: *"ja"* op advies B): nageteld uit `FOREVER_WARLOCK_2026-11-06.md` — vóór de pet-macro's precies
  12 op level 60, daarna tot 14-15 voor Destruction (Conflagrate + Havoc + Incinerate; talentregels, AFGELEID). Create
  Soulstone, Curse of Tongues en Ritual of Summoning naar `listed`; max nu 12. How you play-tekst aangepast; check_real 9/9,
  htp_check 91/91.
- ✅ Hunter + Mage blok D (Rob: *"ja"*): Hunter was 12 (onderzoeksbestand), door de pet-toetsen 14-15 → Feed Pet, Dismiss
  Pet, Scare Beast naar `listed` → 12. Mage ~19 (onderzoeksbestand, AFGELEID) → alle teleports/portals + Comprehend
  Scroll/Study naar `listed` → ~10-11. How you play-teksten aangepast. check_real 9/9, htp_check 91/91. Andere classes
  bekeken in de check_real-uitvoer: Paladin 11 + racial = 12, Priest/Rogue/Warrior/Shaman/Druid ruim binnen 12
  (racials per ras, AFGELEID).

## 🛠️ 6 nov (nacht) — Forever: How you play per class, familieknop (Rob: "ja")

- `ForeverHowToPlay.lua`: de class-knoppen zijn weg; het venster toont alleen de class van het character (Rob: *"ik wil
  ze per character zien, dus alleen voor de geldige class"*). Forever heeft geen specs zoals Midnight; de tabellen zijn per
  class.
- `FriendMarks.lua` staat nu in de Camelot-TOC (+ docs-kopie), na FastMark.lua. FastMark zat er al in, maar de
  vriendenknop was leeg en `/mh mark me` deed niets. Alle `ns.`-afhankelijkheden laden op Forever (GEMETEN: Comms.lua,
  FastMark.lua, Core-routing). AFGELEID: dat Forever de `/tm`-macro's en `C_BattleNet` net zo toelaat.
- Robs familie staat alleen in de retail-SV (GEMETEN: myMarkIcon 1, carola#2875 = 2, sizzle#21918 = 3); Forever-SV
  heeft niets. Overzetten = drie `/mh mark`-regels (TESTLIJST "6 nov (nacht)"). Bewust geen namen in de repo-code.
- Lopend: mh-writer schrijft How to play voor Warrior/Rogue/Priest/Shaman/Warlock (scratchpad `HTP_5_CLASSES.md`),
  daarna mh-research-controle en `htp_check.py`.

## ✅ 6 nov (late avond) — Paladin: Devotion Aura na de trainer op Ctrl-1 (Rob: "werkt en werd goed geplaatst")

## 📖 6 nov (late avond) — Forever: How you play in de addon (Rob: "doe b en dan a")

- **B:** `KeyBlock.lua` UpdateGuide laat een stap met `which = "card"` weg als `ns.ShowPlayCardWindow` niet bestaat
  (verborgen rijen, hoogte past zich aan). Op Forever klikte stap 4 *Open* eerst op niets.
- **A:** nieuw `Modules/ForeverHowToPlay.lua` (beide TOC's + docs-kopie, alleen op `ns.IS_FOREVER`). Tekst =
  `docs/forever/HOW_TO_PLAY_CONCEPT_2026-11-06.md` zonder de notities voor Rob; Druid/Paladin/Mage/Hunter + "Before you
  start"; de andere 5 classes: eerlijk "Not written yet". Neemt de retail-namen `ns.ShowPlayCardWindow` /
  `ns.TogglePlayCardWindow`, dus stap 4 en `/mh play` openen het. Venster via `RegisterMidnightDialogPopup` (Shift-scroll).
  ⚠️ Alleen Engels (concept). ⚠️ Toetsen in de tekst zijn vaste tekst: verandert een `ForeverBlock_<Class>.lua`-tabel, dan
  scratch `htp_check.py` draaien. GEMETEN: 38/38 toetsregels kloppen met de tabellen, tegenproef gevangen; retail definieert
  niets; syntax OK (320), lint 0 HARD. Test: TESTLIJST "6 nov (late avond)".

## 🗺️ 6 nov (avond) — HandyNotes voor Forever geïnstalleerd (buiten de repo)

- Rob: *"uitzoeken en installeren wat nuttig is"*, daarna *"doe b maar"* (zelf downloaden, niet via de CF-app, want WoW
  stond ervoor). In `E:\World of Warcraft\_forever_\Interface\AddOns`: HandyNotes v1.6.32 (Xinhuan), HandyNotes_WoWForever
  v3 (Kemayo; zijn git-hulpscript `updateHandler.sh` weggelaten), HandyNotes_DungeonRaidLocations-Forever v1.00 (Pirson),
  HandyNotes_ClassTrainers 1.0.0 (Frostaphim). Alle vier Forever-flavor op CurseForge, toc's Interface 16001 (GEMETEN).
  ⚠️ Niet in de CF-app, dus geen automatische updates. Bewust niet: dubbele rare-plugins, het Anahkas-drietal (sinds
  5 nov, weinig downloads), herbergen/boten/boeken.
- Quick bar in Forever: ✅ Rob *"die werkt"*.

## 🛠️ 6 nov (avond) — Quick bar in Forever (Rob: "ja doe maar")

- `Modules/QuickBar.lua` staat nu in de Camelot-TOC (+ kopie `docs/forever/MidnightHelper_Camelot.toc.txt`), na
  Broker.lua zoals in de retail-TOC. Op `ns.IS_FOREVER` blijven 4 knoppen: MH, reload, leave (zonder shift-delve) en
  setup → `ns.ShowKeyBlock` (de LayoutWizard is niet geladen op Forever; titel `KEYBLOCK_TITLE`, geen nieuwe strings).
  GEMETEN offline (scratch `qb_check.py`, echte QuickBar.lua met stubs): retail 8 knoppen + wizard (ongewijzigd),
  Forever 4 knoppen + key block. Syntax OK, lint 0 HARD. AFGELEID: dat `C_PartyInfo.LeaveParty` in Forever bestaat
  (de knop meldt het als hij ontbreekt). Test: TESTLIJST "6 nov (avond)".
- Devotion Aura: trainer level 1, 10 koper (GEMETEN in `FOREVER_PALADIN_2026-11-06.md`); Ctrl-1 nog te testen.

## ✅ 6 nov (avond) — Rob test de Forever-Paladin: werkt

- GEMETEN Rob (2 screenshots, Human Paladin level 1): blok via stap 1 + stap 2 (eigen layout), 3/C/Shift-E werken,
  Perception op Alt-1. Keuze: Holy Light blijft op C, F2 wacht op Flash of Light (Rob: *"we houden het op a"*; geldt
  ook voor Druid/Priest/Shaman, die hetzelfde patroon hebben). Details in TESTLIJST "6 nov".

## 🛠️ 6 nov (eind middag) — Robs 2 keuzes uit de How to play: "Doe maar"

- **Mage (1B):** Ctrl-3 = `{ "Frostfire Bolt", "Shoot" }` met `bang`, dus de wand vanaf level 1 tot Frostfire Bolt komt.
  "Shoot" uit `listed` gehaald (staat nu in de toets).
- **Hunter (2B) en Warlock:** Ctrl-1/2/3 = pet-macro's `/petattack`, `/petfollow`, `/petstay` (nieuw veld `cmd` in
  `ForeverBlock.lua`: een gewone macroregel, alleen als je een `needs`-spell kent; `label` voor het plaatje, `icon` voor
  de macro, met terugval op het vraagteken). Reden: GEMETEN in `KeyBlock.lua` (PlacePlan + regel ~1181) bindt het blok
  élke toets, ook een lege, dus Ctrl leeg laten zou de petbalk-toetsen toch afpakken. Met macro's werkt het ook als
  Forever de petbalk anders bindt. AFGELEID: Blizzards petbalk = aanvallen/volgen/blijven, en de drie icon-namen.
  Hunter: Aspect of the Hawk → Shift-R; Strider Kick, Monkey en Beast → blok D. Warlock: Conflagrate, Wrack, Incinerate
  en Bane of Havoc → blok D. De voorstellen in `docs/forever/FOREVER_<CLASS>_2026-11-06.md` zijn hierin achterhaald.
- GEMETEN offline: `check_real.py` 9/9 schoon, tegenproef gevangen; syntax OK (319), lint 0 HARD. How to play-document
  bijgewerkt (nog 3 [check], alle in het spel). In het spel: TESTLIJST "6 nov (eind middag)".

## 🛠️ 6 nov (middag) — Rob op zijn werk: "Ja, 1 tot en met 5"

- **Forever, alle 9 classes in de addon.** Nieuw: `Modules/ForeverBlock_Warrior/_Rogue/_Priest/_Shaman/_Warlock.lua`,
  in beide TOC's + de kopie `docs/forever/MidnightHelper_Camelot.toc.txt`. Elk = het concept uit
  `docs/forever/FOREVER_<CLASS>_2026-11-06.md`; bij de open vragen daar telt de eigen keuze van het voorstel (staat in de
  kop van elk bestand). GEMETEN offline (scratch `check_real.py`, echte motor): 9/9 classes 0 foute toetsen, 0 onbekende
  namen, 0 dubbele spells; tegenproef gevangen. Syntax OK (319), lint 0 HARD. In het spel: TESTLIJST "6 nov (middag)".
- **Forever, Tools-lijst** (`ToolsLaunchpad.lua`): op Forever alleen kaarten waarvan de Open-functie geladen is
  (`FOREVER_NEEDS`). GEMETEN (scratch `forever_tools.py` tegen de Camelot-TOC): 3 van 17 blijven (Your keys, Key block,
  FPS). Retail ongewijzigd. 🔜 Open: de commandolijst onder de kaarten noemt op Forever nog alle Midnight-commando's.
- **Midnight, Venomous Abyss**: Iku → Epu, Nama → Nema in `RaidTips.lua` (7 packs) + `ruRU.lua` + een opmerking in
  `RaidCoachData.lua`: 74 vervangen, 0 oude namen over, "Ikuzz" (andere baas) heel. `check_drift --mark` voor de 5
  enUS-keys. Bron: 3 secundaire bronnen (CONTENT_WATCH 6 nov); in het spel nog niet gezien.
- **Open punten:** 18 → 15. Drie bewezen af in `KNOWN_DONE` (`tools/split_handoff.py`); de hele controle staat in
  `docs/OPEN_PUNTEN_NAGELOPEN_2026-11-06.md`. ⚠️ Daarin: tegenstrijdige notities over quest 96466.
- **Forever "How to play", eerste versie** (alleen een document, niet in de addon):
  `docs/forever/HOW_TO_PLAY_CONCEPT_2026-11-06.md`, Druid/Paladin/Mage/Hunter. Geschreven door mh-writer uit onze eigen
  onderzoeksbestanden, daarna los gecontroleerd door mh-research (regel: uitleg = 2 onafhankelijke agenten).
- Robs vraag *"kunnen andere users dit ook gebruiken?"*: nu nog niet. De Camelot-TOC zit niet in git en niet in de zip
  (`docs/PLAN_FOREVER_RELEASE_2026-11-06.md`). Dat verandert pas met een release, en dat is Robs go.

## 🧹 6 nov (ochtend, later) — dit bestand opnieuw gesplitst (Rob: "Ja")

- Aanleiding: Rob vroeg of claude-mem iets was voor MH. Advies: nee (het geeft oude samenvattingen mee als feit, dat
  botst met "meet het in de bron"). Het eigen briefje bestond al: dit bestand. Het probleem was de lengte.
- GEMETEN: 13354 → 478 regels. Alles vanaf "🌆 31 okt — ronde 's avonds" staat nu bovenaan
  `docs/NEXT_SESSION_ARCHIVE.md` (4227 → 17137 regels). Controle: 0 niet-lege regels kwijt over beide bestanden samen;
  een kop van diep uit het oude bestand (16 okt) staat in het archief en niet meer hier. UTF-8 nagekeken.
- 🔴 `tools/split_handoff.py --write` zou het archief hebben overschreven (gemaakt voor één keer, 2 sep). Nieuw:
  `--resplit "<kop>"`, dat het archief aanvult; de oude `--write` weigert nu als het archief bestaat. Grens van
  ~1500 regels staat in `CLAUDE.md`.
- 🔜 Het lijstje onderaan heeft nu 18 punten (10 nieuw uit okt + de 8 oude). Niet nagelopen; een deel is vast al af.

## ☀️ 6 nov (ochtend) — Paladin, Mage en Hunter in de addon (Rob: "Ja, alle drie")

- Rob liet de class-keuzes aan ons over (*"vertrouw ik op jouw expertise mbt de classes"*). Daarom staan de voorstellen
  nu als `Modules/ForeverBlock_Paladin.lua`, `_Mage.lua` en `_Hunter.lua` in de addon, in beide TOC's (+ de kopie
  `docs/forever/MidnightHelper_Camelot.toc.txt`). Ze staan er zoals in het voorstel, met twee wijzigingen: bij de
  Hunter heeft toets 1 `bang = true` (`/cast !Auto Shot`), en bij de Paladin is Sense Undead verhuisd van blok D naar
  `listed`. Dat laatste lost het "13 voor 12"-probleem op.
- GEMETEN offline (scratch `check_real.py`): alle 4 de class-bestanden gaan door de echte motor. Er waren 0 onbekende
  namen, 0 verkeerde toetsen en 0 dubbele spells. De Druid-uitvoer is gelijk aan gisteren. De tegenproef (een foute
  naam en een foute toets) werd allebei gevangen. Lint 0 HARD, syntax OK (314). In het spel is nog niets getest: zie
  `docs/TESTLIJST.md` 6 nov.
- Nog alleen voorstel: Warrior, Rogue, Priest, Shaman, Warlock.
- **OneForAll - Forever** (Smoergi, 378K downloads, GPL-3) bekeken op Robs verzoek: `docs/forever/ONEFORALL_LESSEN_2026-11-06.md`.
  Het doet gear, dungeons, beroepen en talenten, maar geen toetsen en geen uitleg. Onze plek is dus het blok + de How to play.
  🔴 Geen code overnemen (MH is MIT). 🔜 Vóór een Forever-release één keer testen met OneForAll erbij aan.
- 🔜 Robs idee: een **Forever "How to play"** voor nieuwe spelers (zoals de Zo-speel-je-kaarten). Dat maken we pas als de
  tabellen vastliggen, zodat de uitleg en de toetsen hetzelfde zeggen.
- 🔜 Content-wachter 6 nov 🔴: in The Venomous Abyss heten Scrollsage Iku → **Epu** en First Mate Nama → **Nema**
  (hotfix 5 nov). Onze tips gebruiken nog de oude namen, in 8 packs. Dat repareren we pas als Rob ja zegt.
- Robs Midnight-test 6 nov: de enige fout was van **WIM** (`IsUserOAuthed` in Blizzards Guild Control UI), niet van MH.

## 🌙 Nacht 5→6 nov — Rob slaapt, plan goedgekeurd ("ga helemaal los"; geen release, geen tag)

- Rob over EllesmereUI-gebruikers: zet alleen **"EllesmereUI Action Bars"** uit; een `/reload` is genoeg (zijn ervaring).
- ✅ Motor algemeen: `Modules/ForeverBlock.lua` (engine) + `Modules/ForeverBlock_Druid.lua` (goedgekeurde tabel, nu met
  `base`/states/`pair`). `ForeverDruidBlock.lua` weg. Bewijs: offline vergelijking oud ↔ nieuw over 202 spell-sets / 4519
  toets-uitkomsten = 0 verschillen; tegenproef met één foute toets = 154 verschillen (scratch `test_engine_equal.lua`).
  Macronamen ongewijzigd ("MH <toets>"), dus Robs geplaatste blok blijft werken. Alleen goedgekeurde tabellen worden
  geregistreerd; de andere classes blijven voorstel in `docs/`.
- 🔴→✅ **Release-val gedicht:** de packager neemt `_Camelot.toc` mee als het bestand in de repo staat, ook als `.pkgmeta`
  het negeert (GEMETEN `release.sh` v2:1424-1430). Het stond sinds 88e9dae op GitHub → de volgende gewone release was
  ook als Forever gemarkeerd. Nu: uit git (`rm --cached`), in `.gitignore`, op schijf gebleven (Forever laadt het nog),
  kopie in `docs/forever/MidnightHelper_Camelot.toc.txt`. ⚠️ Wijzig je de Camelot-TOC: kopie bijwerken.
  Release-onderzoek: `docs/PLAN_FOREVER_RELEASE_2026-11-06.md`.
- ✅ **8 class-voorstellen** (mh-research, één per class, uit lokale wago-CSV's build 70790 in scratchpad `wago_wowf/`):
  `docs/forever/FOREVER_<CLASS>_2026-11-06.md`. Elk concept door de echte motor gehaald (scratch `check_drafts.py`):
  namen in SpellName, toetsen = blok-plekken, geen dubbele spells. Beginspells per class zelf nagemeten (AcquireMethod 2).
  **NIET goedgekeurd, NIET in de addon.** Rob-overzicht: `docs/forever/OVERZICHT_NACHT_2026-11-06.md`.
- Motor: nieuwe optie `bang` (`/cast !Naam`, voor Hunter Auto Shot); Druid-equality opnieuw 0 verschillen.
  Druid-uitlegregel verbeterd: Moonkin wisselt de balk NIET (GEMETEN SpellShapeshiftForm.BonusActionBar = 0).
- 🔜 Rob: voorstellen goedkeuren per class → tabel als `Modules/ForeverBlock_<Class>.lua` (concept staat onderaan elk
  voorstel; Hunter key 1 krijgt `bang = true`). Open voor de Druid: Skyborne-racial op Shift-E.

## 🔨 5 nov (avond, laat) — Forever stap 2 begonnen: meten (Rob: "Ja, toetsenblok")

- Nieuw `Modules/SpellbookDump.lua` (in beide TOC's), `/mh spellbook` (unlisted-on-purpose): schrijft naar
  `ns.db.spellbookDump` het spellboek per tab (naam, id, rank, passief, lowRank), de action slots 1-180, class/level/spec
  en wat `MH_AutoMapBuild` nu herkent (id, naam, rol). Alles met pcall + issecretvalue.
- ✅ GEMETEN 5 nov (Forever SV, `WTF\Account\JOEYWHATEVER`): Druid level 7, spec 1484 "Druid" (index 1, één spec).
  Spellboek: General (Attack, Elune's Light, Shadowmeld + passieven), Restoration (Healing Touch R1 5185, Mark of the Wild
  R1 1126, Rejuvenation R1 774), Balance (Moonfire R1 8921, Thorns R1 467, Wrath R1 5176 **lowRank**, Wrath R2 5177).
  Ranks bevestigd. MH's lijsten herkennen er 2 (Mark of the Wild, Shadowmeld): Wrath/Moonfire/Rejuvenation staan wél in
  KeybindRoles_Druid.lua, maar met `specs = {102..105}` → spec 1484 valt erbuiten. Healing Touch/Thorns staan er niet in.
  Balk 1 = slots 1-12; Attack op 73/85/97/109 (vorm-pagina's). Bijvangst: KeyPresses telt in Forever (Wrath 94×),
  instellingen blijven na /reload bewaard.
- ✅ Rob koos "Eigen Forever-lijst". mh-research: alle actieve Druid-spells 1-60 met elke rank + level + tab + vorm,
  uit wago DB2 product `wowf` build 1.60.1.70790 (= Robs client, GEMETEN in `.build.info`) + Wowhead Forever →
  `docs/FOREVER_DRUID_SPELLS_2026-11-05.md`. Positieve controle zelf nagekeken: alle 9 gemeten spells kloppen.
  ⚠️ Zygor Forever-data is van build 70707 (oud) voor Ferocious Bite/Lacerate/Primal Bite. Tiger's Fury: waarschijnlijk
  niet meer leerbaar (Wowhead zegt nog wel; trainer-check open).
- ✅ Rob: 4 regels "Ja, bouwen". Gevonden vóór het bouwen (GEMETEN, KeyBlock.lua:62-66): het blok staat op balk 5-7, en
  die wisselen niet mee met vormen → Rob koos **"Macro per toets"** (beer/kat/anders in één macro, op naam = hoogste
  rank, AFGELEID). Voorstel per toets: `docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md` (levels nagelegd tegen de lijst).
- ✅ Rob: "ja goedzo" + GEMETEN `C_Spell.GetSpellInfo("Wrath").spellID` = 5177 (naam → hoogste rank).
- ✅ GEBOUWD (niet in het spel getest): `Modules/ForeverDruidBlock.lua` (beide TOC's, vroege return buiten Forever).
  Tabel `KEYS` = het goedgekeurde voorstel 1:1 (+ War Stomp-terugval op Shift-E voor Tauren, + `open` op R zodat beer
  Travel Form houdt). Macro "MH <toets>", per character (vol → gedeelde lijst). Spells op naam; onbekend = weggelaten;
  herschrijven bij LEARNED_SPELL_IN_SKILL_LINE/PEW buiten gevecht. `KeyBlock.lua`: Build() vraagt eerst
  `ns.ForeverKeyBlockBuild`; nieuwe want-soort `macro` (op naam) in PlacePlan/keep, Place, Update, MissingRows,
  WantedSpells (spells in de macro = doubles van balk 1). Offline Lua-test met stubs (scratch `test_druid.lua`):
  level 7 → 7 macro's + Elune's Light naar D; level 40 → beer/kat-delen kloppen.
  ✅ **WERKT in Forever** (Rob: "whoohoo het werkt", screenshot 5 nov): blok geplaatst, alle 8 macro's + Elune's Light
  op de goede plek, vorm via MH-stap 2 (Edit Mode) — mét **EllesmereUI Action Bars uitgezet** (EUI leest Edit Mode
  alleen bij eerste installatie, `EUI_ActionBars_Bars.lua:463`). 🔜 Nog: toetsen indrukken, bonusbar-vorm op 10 (beer)
  en 20 (kat), macro-limiet. ✅ Rode regel "Not in MH's list yet" gerepareerd (Rob: "Ja, repareren"): op een Forever-Druid
  vraagt het blokvenster `ns.ForeverDruidUnlisted()` (spellboek min de Forever-tabel) i.p.v. `KeybindUnclassified`;
  offline test: Robs level-8-boek → niets, verzonnen spell → wel gemeld. Niet in het spel gezien.
- (oud) Rob: in Forever met zijn Night Elf Druid `/mh spellbook` + `/reload`. Daarna lees ik
  `E:\World of Warcraft\_forever_\WTF\Account\<acc>\SavedVariables\MidnightHelper.lua` en maak de Druid-lijst.

## 🔨 5 nov (avond, later) — Forever: laadt! Alleen tabs met een geladen bouwer (Rob: "Ja, doe maar")

- GEMETEN (Robs screenshot): MH opent in Forever, maar toonde alle Midnight-tegels + `TAB_START_HERE` (StartHere-locale
  weggelaten). BugSack: nog niet gemeld.
- `Core.lua`: `ns.IS_FOREVER` (interface 16000-19999, zelfde test als EllesmereUI_ClientGate.lua).
  `UI.lua`: `FOREVER_TAB_BUILDER` + `ns.ForeverScreenLoaded(id)`; `SidebarTabAvailable` zegt op Forever nee als de
  bouwfunctie niet geladen is (alle 22 namen GEMETEN in de code); een kamer zonder scherm (Codex) wordt niet getekend.
  `RoomLauncher.lua`: Tools-kaarten met `screen` vragen hetzelfde. Retail: ongewijzigd (alles achter `ns.IS_FOREVER`).
- GEMETEN (Robs 2e test): links Me/Tools/Settings, geen BugSack-fouten. Maar Tools toonde This Week: de poort zei nee
  tegen `room_tools` (onbekende id). Gerepareerd: alleen bekende tabs worden beoordeeld (`FOREVER_NO_BUILDER` + kaart).
  ✅ Opgeruimd (Rob: "Ja, opruimen"): op Forever toont `BuildLayout` (HomeDashboard.lua) alleen een blok "Midnight Helper
  Forever (early test)" + knop Your keys; tagline `TAB_TAGLINE_HOME_FOREVER`; Settings verbergt rare/boss/shard/board/
  forget/resetboss en schuift Report + Reset popup op. 3 nieuwe sleutels in 8 talen (locale_probe OK).
- Verwacht (AFGELEID): Me → This Week, Tools → Your keys + tools-lijst, Settings. 🔜 De tools-lijst
  (ToolsLaunchpad) noemt mogelijk nog Midnight-tools: na Robs volgende screenshot bekijken.

## 🔨 5 nov (avond) — Forever stap 1 gebouwd (Rob: "Ja, stap 1"), NIET in het spel getest

- `MidnightHelper_Camelot.toc` (Interface 16001, `AllowLoadGameType: camelot`, titel "Midnight Helper Forever"):
  74 bestanden uit dezelfde map: motor, talen (zonder Midnight-tekstpacks), toetsen/balken (KeybindRoles zonder DK/
  Monk/DH/Evoker), pijl, FastMark, FPS, instellingen, Home, zoekbalk, KeysHub. Plus `DelvePartyShare.lua`: alleen
  functies, maar het kopieervenster (`ns.ShowShareCopyDialog`) zit daar.
- Scratch-check (`forever_deps.py`): 18 namen die alleen weggelaten bestanden definiëren; alle 18 zelf nagekeken, overal
  een `if ns.X` of data-controle ervoor. Eén echte fout gerepareerd: `ns.ShowKeyBlockExportAll` riep het kopieervenster
  zonder controle aan (KeyBlock.lua, nu `if not ns.ShowShareCopyDialog then return end`). AFGELEID: runtime-fouten
  buiten `ns.X` (globale Midnight-API's in de motor) kunnen nog; dat ziet alleen Robs BugSack.
- **Niet in releases**: uitgesloten in `.pkgmeta` en `tools/package.ps1` tot Rob beslist.
- ✅ Rob koos "Koppeling maken": junction `E:\World of Warcraft\_forever_\Interface\AddOns\MidnightHelper` → deze map
  (gemaakt 5 nov via scratch `make_junction.py`; GEMETEN dat de Camelot-TOC erdoor zichtbaar is). Forever heeft een eigen
  WTF, dus eigen SavedVariables. Daarna TESTLIJST "5 nov (avond)". Rob speelt een **Night Elf Druid** → stap 2 (toetsenblok) begint met de Druid.

## 🔎 5 nov (avond) — "Midnight Helper Forever": alleen onderzoek

Rob speelt WoW Forever met EllesmereUI en vroeg of MH daar het toetsenblok kan zetten → nu niet: MH staat niet in
`_forever_` en de TOC mist 16001 (GEMETEN). Daarna: *"afgeslankte versie … we hebben al een hele engine"* → *"Ja,
uitzoeken"*. Uitkomst in `docs/PLAN_FOREVER_2026-11-05.md`: één code, tweede TOC `MidnightHelper_Camelot.toc`
(`AllowLoadGameType: camelot`, voorbeeld EllesmereUI); motor 50 / algemeen 145 / Midnight 69 / data 51 bestanden
(mh-sweep); de motor roept Midnight-onderdelen met `if ns.X` aan (steekproef zelf nagekeken). Forever: 1 spec per class
(1482-1491, uit EllesmereUI), spell-ranks, C_SpecializationInfo/C_Spell/PlaceAction/waypoints bestaan (mh-research,
wiki-dump beta). Toetsenblok heeft eigen lijsten per Forever-class nodig. 🔜 Rob kiest: stap 1 ja/nee, kopieerscript of
junction, welke class, CurseForge.

## 🔨 5 nov (laat) — Rob: "ik volg jouw advies" → stap 1 + idee B gebouwd, NIET in het spel getest

- **Stap 1 (bewaren per run):** `DelveHistory.lua` `ReadRunFlavour()` leest bij SCENARIO_COMPLETED het verhaal
  (`ns.GetActiveDelveStoryName`, clienttekst) en Valeera's rol (`ns.GetCompanionActiveRoleKey`, nu publiek in
  DelveCuriosAdvisor.lua) → velden `story` / `role` in elke `recent`-run; nil = niet gelezen, niet "geen". Labyrinth:
  per kamer bijgewerkt in `activeRun`, gelogd bij vertrek. Seizoenstellers erbij: `delves`, `labyrinth` (DelveHistory),
  `rituals` (RitualLog). `SeasonStats.lua` kreeg `countSince[key]`: die drie tellen pas sinds de eerste login met deze
  code, en `/mh season stats` zegt "(since …)" erachter (geen valse 3-delves-in-3-maanden).
  AFGELEID, niet gemeten: dat GetActiveDelveStoryName op het moment van SCENARIO_COMPLETED nog een naam geeft.
- **Idee B:** nieuw `Modules/TimePlan.lua` (in .toc na KeysHub). Venster 10/20/40 min (onthouden in
  `ns.db.ui.timePlanMinutes`). Lijst 1 = per delve/ritual de Tier met de meeste runs + je gemiddelde daar (alleen dit
  character, Labyrinth eruit, runs >3 u genegeerd), alleen wat in de tijd past, max 5; past niets → je snelste. Lijst 2 =
  open, heroEligible stappen uit `GetResetRoutineSteps` zonder minuten ("quick stops"), klikbaar (route). Reistijd telt
  niet mee (staat in de voettekst). Ingangen: knop op Home onder de TomTom-knop, `/mh time [10|20|40]`, zoekbalk
  (CommandList `CMDLIST_TIME` + NavSearch-woorden). Delvenamen staan zoals in de Delve Log: de opgeslagen naam.
- Teksten in 8 talen + esMX (abismos). Zelf vertaald, niet door een moedertaalspreker nagekeken. Syntax OK (308),
  lint 0 HARD, locale_probe OK voor 6 sleutels in alle talen.
- Testen: TESTLIJST "5 nov (middag)". 🔜 Volgende uit het plan: C (dagboek) gebruikt `story`/`role`; A (Wrapped) vlak voor
  het seizoenseinde.

## 🧩 5 nov (middag) — Rob op zijn werk: "1 tot en met 3" (plan 3 ideeën, kleine taalpunten, Szarith)

- **Plan** `docs/PLAN_IDEEEN_2026-11-05.md`: "Jouw Seizoen 2", knop "Ik heb 20 minuten", Valeera's dagboek. Alleen plan,
  niets gebouwd. Inventaris door mh-sweep, hoofdpunten zelf nagelezen (SeasonStats.lua, DelveHistory.lua:580-615,
  ResetRoutine.lua, RitualLog.lua). Advies: eerst een gedeelde stap 1 (story/rol/tellers per run bewaren), dan B, C, A.
  Rob kiest.
- **Verhaalnaam in de baas-tips** (`DELVE_TIP_TWILIGHT_CRYPTS_BOSS`): de/fr/es/pt/it/ru noemden "Why'd it have to be
  snakes?" in het Engels → nu de naam die dat pack al in de OVERVIEW-regel gebruikt (= `DELVE_STORY_NAMES_LOCAL`,
  GossipUIDisplayInfoCondition, gemeten 26 okt). esMX kreeg een eigen BOSS-regel met de Mexicaanse naam.
  ⚠️ mh-research GEMETEN (wago 12.1.5.70783): het spel heeft voor dit verhaal nog 2 ándere namen: het succes
  (CriteriaTree 230852, achievement 61730) en de kaarttooltip (UiWidgetStringSource 21464). Die verschillen in de/pt/ru
  van de gossip-naam. Bewust NIET overgestapt: de detectie (DelveStoryData) leunt op de gossip-naam, en de rest van de
  tip ook. Welke naam de speler waar ziet: AFGELEID uit de tabellen, niet in de client gezien.
- **Zul'Aman per client** (GEMETEN, UiMap 2437 + AreaTable 15947): frFR "Zul’Aman" (U+2019), itIT "Zul'aman" (kleine a),
  de/es/esMX/pt/ru rechte apostrof. Script verving het in alle fr/it-blokken (Codex, DelveTips, RitualTips,
  Translations2026, frFR.lua, itIT.lua; samen met de verhaalnaam 53 regels; commentaar overgeslagen). `WB_ZONE_ZULAMAN`: dode it-fill weg, fr-fill
  erbij. Syntax OK (307), lint 0 HARD, locale_probe OK.
- **Szarith (alleen onderzoek, mh-research):** het "Eye of Szarith" (object 649651 → item 278534 → quest 97668 "The
  Watchful Gaze of Szarith") maakt één keer per account de Broodmaster-knoop vrij. Er is geen spell die Szarith oproept
  (wago, met positieve controle). De 3 spelers die "het Eye roept hem op" zeiden, twijfelen zelf of het toeval was.
  Conclusie AFGELEID: waarschijnlijk geen oproep. Szarith spawnt vanzelf (meldingen van 5 min tot uren, laatste 14 sep).
  Excising Knife = item 280003, uit een Temple Incursion.
  🔜 **Nieuw open punt:** het Eye is in 12.1.5 waarschijnlijk verplaatst. Drie spelers (14-16 okt) + de Wowhead-kaart
  zeggen ±67.3/30.1 (kamer met de wenteltrap naar de Kithix-raid). Wij hebben 68.60/15.66
  (`CorrosiveCodexHunts.lua:82-83`, 142). Niet aangepast: Rob meet het eerst (coördinaat-regel). Bijvangst: Zygor 9.6 zet
  Szarith op Farthiks coördinaat (kopieerfout, AFGELEID).

## 🔨 5 nov — zoekbalk-tekst, kwartiermeesters, stadspins in elke taal (Rob: "Alles"), NIET in het spel getest

Clientnamen GEMETEN door mh-research (wago 12.1.5.70783 per locale; dummies/NPC-titels via Wowhead live-tooltips). Tabel:
`side-session-notes/local_b7b64975-…/2026-11-05_clientnamen_factions_en_pins.md`.
- `SEARCH_PLACEHOLDER` 8 talen: "setting" als tweede woord (de Einstellung, fr réglage, es ajuste, pt configuração, it
  impostazione, ru настройка — het woord van elk pack bij All settings). Of hij past in een smal venster: niet gemeten.
- `CurrencyGuide.lua`: QMS-rijen kregen `faction` (2710/2696/2704/2699/2772); de knop toont
  `C_Reputation.GetFactionDataByID(id).name` (clientnaam), anders de locale-key. Knoppen lopen door op een extra rij
  (`ui.LayoutQM`, groeit omhoog, leesvenster wordt even veel lager). Tooltip: factienaam + NPC. AFGELEID: dat de API een
  naam geeft voor een factie die je nog niet kent.
- `CURRENCY_QM_COURT` = gemeten naam in alle packs (enUS/nlNL "Silvermoon Court", ru "Двор Луносвета"); de 5 dode
  fill-regels in Translations2026 weg (lint HARD). De 4 andere QM-keys zijn alleen nog terugval (kort Engels).
- `NavSearch.lua` `ClientWords`: per SMC-pin Blizzards eigen GlobalStrings als extra zoekwoord (BUTTON_LAG_AUCTIONHOUSE,
  MINIMAP_TRACKING_*, BANK, ACCOUNT_BANK_PANEL_TITLE, DELVES_GREAT_VAULT_LABEL, TRANSMOG_SOURCE_7, …), beroepsnaam via
  `C_TradeSkillUI.GetTradeSkillDisplayName(skillLine)` (kandidaat, niet getest), en `SMC_SEARCH_<ID>` (5 nieuwe keys,
  7 talen) voor Catalyst ("The Catalyst" = de huidige spelnaam), Crest Exchange, Training Dummy en Portal Room (eigen
  woord). Label op het scherm blijft Engels.
- ruRU `PROFGUIDE_BTN_SMC` "Учитель в Луносвете"; deDE `SEARCH_TOOLTIP_BODY` "Orte in Silbermond (Bank, Auktionshaus, …)".
- Checks: syntax OK (307), lint 0 HARD, locale_probe alle 9 keys OK (nlNL Engels zoals bedoeld), check_drift --mark voor
  de 2 gewijzigde enUS-keys. Offline (echte NavSearch.lua, Duitse globals als stub): auktionshaus, briefkasten,
  gastwirt, schatzkammer, alchemie, wappentausch, trainingsattrappe, katalysator, portalraum → de goede pin; zzzq → 0.
- Testlijst "5 nov". Een de/fr/…-client kan Rob niet testen.

## ☀️ 5 nov — ochtendronde: niets voor Rob; `_probe.py` vond zijn eigen job niet meer

- GEMETEN: alle 4 wachters gedraaid (API: nieuwe PTR-build 12.1.7.70740, 0 MOET GEFIKST, `QueryTimerDuration` en
  `ExcludeLoadGameType` 0× in MH). gh_inbox 0 open, 0 PR's/issues. addon_updates 10 bijgewerkt, geen TomTom, niets dat MH
  raakt (gelezen, niet getest). HandyNotes 167 = 167. Site-mail 3 dagen leeg (positieve controle: 26 zonder datum).
- 🔴 De app zet de scratchpad nu in `Temp\claude\<hash>\<sid>\scratchpad` (hier `e1c44003d48d72c2`). `_probe.py` kende
  alleen `Temp\claude\E--World-of-…\<sid>` → viel terug op "nieuwste job van elke sessie" en draaide één keer een oude
  job van een andere sessie (beroepen-overzicht, alleen lezen). Gerepareerd: `_own_scratchpad()` zoekt nu ook
  `Temp\claude\*\<sid>\scratchpad`, nog steeds alleen op sessie-id. GEMETEN: daarna 3 jobs goed. `git_stage.py` had dezelfde fout
  (zou de stage-lijst van een andere sessie pakken) → zelfde reparatie; deze commit is ermee gestaged.

## 🔧 4 nov — TomTom 4.4.0 stap 1 + 2 GEBOUWD (Rob: "Ja, bouwen"), NOG NIET GETEST

- Code: `Core.lua` na de ClearAllWaypoints-hook. `ns.MH_InstallTomTomCallbacks` registreert `ArrowTargetChanged`
  (alleen als `TomTom.RegisterCallback` bestaat). Een `nil` telt als "speler stopt" alleen als: niet tijdens onze eigen
  wis-actie, speler >60 yd (`NEAR.tomtomArrived`) van de verdwenen pin én van de lead, en 1,5 s later de pijl nog leeg is
  zonder nieuw doel. Onmeetbaar = niets doen. Dan `ClearActiveRoute()` + chatregel `TOMTOM_ROUTE_STOPPED` (8 talen).
- Nieuw `ns.MH_TomTomRemove(uid)` zet dezelfde `_mhSelfWaypointOp`-vlag; de 7 losse `RemoveWaypoint`-aanroepen
  (Achievements, Profession ×2, TravelRoute ×4) gaan er nu door.
- Stap 2: één tikker (1 s) houdt `arrow.setclosest` tegen zolang `_mhRouteOwner` gezet is, en geeft hem daarna vrij.
- `/mh arrow`: regels "TomTom-meldingen", "laatste: …" en "'set closest' tegengehouden". Log in `travelRouteLog`.
- Checks: syntax OK (307), lint 0 HARD, locale_probe 8/8 OK. AFGELEID, niet gemeten: het gedrag in het spel.
- Hook + pollen blijven als terugval. "poi" en HijackCrazyArrow bewust niet.

## 📝 4 nov — plan TomTom 4.4.0 (Rob: "Ja, plan 1 en 2")

- Ochtendronde 4 nov: niets voor Rob. Live-build 12.1.5.70783 (4 API-wijzigingen, alle afgedekt), TomTom 4.4.0 binnen:
  alle 10 TomTom-functies die MH aanroept bestaan nog (GEMETEN op naam), gedrag niet getest.
- Plan: `docs/PLAN_TOMTOM_2026-11-04.md`. Stap 1 = `ArrowTargetChanged`-callback (vangt "één pin weg" dat de
  ClearAllWaypoints-hook mist; aankomst ≠ stoppen). Stap 2 = `SuppressFeature("arrow.setclosest")` zolang een MH-route
  loopt. TomTom is All Rights Reserved: alleen de openbare API, geen code overnemen. De dode-uid-fout zit nog in 4.4.0,
  onze `RemoveWaypoint`-reparatie blijft. ✅ Go gekregen en gebouwd, zie hierboven.

## 🚀 3 nov — release 4.15.0 (Rob: "Ja, go 4.15.0" + "je mag helemaal plaatsen")

- ✅ **UIT.** Tag `v4.15.0` op 7b61c6b. GEMETEN in de run-log (41673088677, exit 0): CurseForge "Success!", Wago
  "Success!", GitHub-release + zip + release.json "Success!". Site-chat geseind (tag-commit, keys, Szarith-zin alleen intern).
  Nog na te kijken door Rob: CF → Files → 4.15.0 → Changelog-opmaak.
- CF-beschrijving GEMETEN (browser, 3 nov): tekst = `CURSEFORGE_DESCRIPTION.md`, banner staat er. Rob "Ja, bijwerken" →
  de zoekbalk-alinea heet nu "Find anything, then it takes you there" (instellingen, ah/bank/mail, tikfouten, Show me).
  ✅ Rob 3 nov: beschrijving én nieuwe korte samenvatting ("Explains WoW Midnight in plain language and takes you
  there: …", 228 tekens) op CF geplakt; 4.15.0 is approved; site-chat door Rob ingelicht.
- TOC 4.15.0; in-game CHANGELOG_4150_0..7 (enUS only); CHANGELOG.md; `RELEASE_NOTES.md` = `docs/CURSEFORGE_4.15.0.md`
  (GEMETEN sha1 1a6f53c1, 58 regels, 3137 tekens). Direct release, geen beta (Rob testte alles).
- Site-chat (Site chat 03-11) GEMETEN in hun repo: site loopt niet achter op 4.14.0; 4.15.0-werk komt na de tag via
  hun release-stappen. Ze vroegen locale-keys, commando's en of de Szarith-zin publiek moet (nee, alleen voor ons).
- Open na de release: zoekbalk-placeholder `SEARCH_PLACEHOLDER` noemt nog geen instellingen; pin-labels Engels
  ("Auktionshaus" vindt niets); `CURRENCY_QM_COURT` "SMC Court"; ruRU "Учитель (SMC)"; Duits "Stifte".
  ✅ 5 nov: alle vijf gebouwd (zie bovenaan), nog niet in het spel getest.

## 🔨 3 nov — zoekbalk vindt de Silvermoon-pins (Rob: "als ik AH zoek … krijg ik niet de Auction House"), NIET getest

- GEMETEN vooraf: NavSearch had 0× "auction" (positieve controle `mykeys` gevonden). De pins zaten alleen in de oude
  chat-vraag-zoeker (`ns._mhSMCGuideSearchRows`, Guide.lua:450).
- UI.lua `BuildSMCSearchRows` geeft elke rij nu ook `navKeys` (categorie + label + eigen beschrijving + id, ZONDER de
  algemene "set a waypoint to …"-zin: die maakte "arrow" via synoniem waypoint tot ~60 pins, offline gemeten).
  `ns.RouteSMCPin(point)` = wat een klik op de pin doet. NavSearch: blok na de Hexmask-spots, TIER_ACTION, cat "place",
  korte woorden per id (ah, bank, mail, inn, catalyst …); instance- en world-boss-rijen overgeslagen.
- Offline (navtest): ah/AH → Auction House + Horde AH; auction → + BMAH; bank/mail/inn/alchemy trainer goed; "ah" vindt
  geen Harandar; arrow → geen pins.
- ⚠️ Pin-labels zijn Engels (al zo in de gids); "Auktionshaus" op een Duitse client vindt hem dus niet. Open.
- **Rob: "in principe moeten we alles kunnen vinden wat wij in MH hebben staan."** mh-sweep-inventaris (Haiku, 3 nov;
  ik heb 2 punten zelf nagemeten: Trading Post-tab UI.lua:2767 en 0× TRADINGPOST/PlayCard/WORLD_BOSSES/SHOWDOWNS in
  NavSearch). Nog NIET vindbaar: (1) Zo-speel-je-kaarten, 40 specs (`/mh play`, unlisted); (2) tab Trading Post;
  (3) 4 world bosses (WorldBoss.lua:13-50, WB_BOSS_*); (4) Showdowns (ShowdownsData.lua:18); (5) Profession hub-tabs
  overview/treasures; (6) losse delve curios; (7) achievement-schatten zonder coördinaat; (8) unlisted commando's met een
  venster (worldboss, showdown, play; rest onbekend); (9) Mount run-venster zelf.
  ✅ Rob "Ja, top 4" → 1-4 gebouwd in NavSearch: tab TAB_TRADINGPOST; per spec een speelkaart-rij ("Frost Mage", naam uit
  GetSpecializationInfoByID, eenmalig gecachet in `specText`) → ShowPlayCardWindow; 4 world bosses → RouteToWorldBoss;
  Showdowns-kop (World-tab) + portaal/Maella-routes + de 2 bazen. Offline navtest goed (frost → beide Frosts, luashal,
  naigtal, trading post). Niet in het spel getest.
  ✅ Rob "Ja, dat klopt" → 5-9 ook: hub-tabs Overview (`profoverview`) + Treasures (`professions`); de curios bij naam
  (C_Item.GetItemNameByID, ontbrekend = RequestLoadItemDataByID en volgende toets); "Mount run: old raids" als eigen rij;
  achievement-nodes zonder plek → rij die de Achievements-tab opent. Punt 8 GEMETEN in Core.lua: portals, travel, crest,
  crestfind en encounters printen alleen in chat (dev/diagnose); keyblock zit al onder My keys, profguide was al
  vindbaar; worldboss/showdown/play zijn nu via hun inhoud te vinden → niets toegevoegd. Offline navtest goed. Niet in
  het spel getest.

## 🔨 3 nov — de 3 site-chat-punten opgelost (Rob: "Alle drie"), NIET in het spel getest

- **RAIDSHOP_GEAR_TIP** (`RaidShoppingList.lua`): de zin "for this slot there is a choice" alleen nog als `g.choice`
  (nieuw rij-veld `gearChoice`); het label deed dat al, de tooltip niet.
  ✅ Rob 3 nov: Head (a choice) toont de zin. Legs (a choice) = echt item (Spellthread) → alleen spel-tooltip, zin ontbrak
  (al vóór vandaag) → nu `AddLine` onder `SetItemByID` als `gearChoice`. ✅ Rob 3 nov: Legs mét zin, Chest zonder.
- **Key block, nieuwe spell (Rob levelt een Evoker, Disintegrate):** bestaat al — knop rechtsboven in het key-block-venster,
  "New spells: ask me / place automatically / never ask". GEMETEN in SV: `keyBlockNewMode = "never"` → daarom niets.
  Rob klikt hem naar "place automatically". 2e keer (level 12, Return): weer `never`; probe toonde F = 361227 in het plan,
  live leeg. Rob: "Ja, dat is wel slim" → `/mh block why` print nu onderaan "new spells: <stand> — waiting: X -> key"
  (ook in `keyBlockProbe.newMode/.waiting`). Niet getest. Rob "Ja, doe maar": de knop staat nu ook als dropdown
  `mh_keyBlockNewMode` in SettingsDefs (sectie On-screen buttons, zelfde `ns.db.keyBlockNewMode`, geen rec), met
  SET_KEYBLOCK_NEW_TITLE/_DESC in 8 talen (door mij geschreven, niet door een moedertaalspreker nagekeken; locale_probe OK).
  Daarvoor GEMETEN: SettingsDefs had 0× keyBlock (positieve controle rareAlert 3×).
  ✅ Rob 3 nov (screenshot): `/mh block why` → "new spells: place automatically — waiting: none". Zoeken + dropdown:
  Rob "het staat allemaal goed" ✅.
- **AH-pin** (`UI.lua` SMC-gids): 51.50/74.68 zonder bron → 51.35/75.81 = Auctioneer Jenath uit Zygor NPCData.lua:6908
  (HandyNotes_Midnight heeft geen AH; bronregel Rob > HandyNotes > Zygor). Oude punt lag ~1,3 noordelijker (ingang?).
  Horde-AH (67.64/70.74, Zygor 67.3-67.9/72.5) niet aangeraakt.
- **"SMC" in de/fr/es/pt/it** (mh-writer, door mij nagekeken): overal de clientnaam uit `TAB_SMC` (Silbermond,
  Lune-d’Argent, Lunargenta/Ciudad de Lunargenta, Luaprata, Lunargenta), ook de zoekwoord-voorbeelden (silbermond, lune,
  lunargenta, luaprata). 8 locale-bestanden, locale_probe OK. Open: `CURRENCY_QM_COURT` = "SMC Court" in alle talen
  (clientnaam onbekend, meten); ruRU `PROFGUIDE_BTN_SMC` = "Учитель (SMC)"; de "Silbermond-Stifte" (Stifte = potloden)
  is een oud slecht woord.

## ✅ 3 nov — piepje bij de C-toets: Discord, niet MH

Rob, 3 nov: *"dat hoor ik nu niet, alleen als discord open staat blijkbaar"*. Punt dicht voor MH; advies gegeven: in
Discord bij Keybinds / Voice (push-to-talk, mute) kijken of C daar gebonden is.

## ✅ 3 nov (later) — voorbeeld stap 3 + de twee losse dingen (Rob: "Gaan we verder met stap 3 en de twee losse dingen")

✅ **Rob testte alle 4 punten van testlijst "3 nov (4)" in het spel: "Dit werkt allemaal."** Daarmee zijn het zoekplan (6
stappen) en het voorbeeldplan (3 stappen + 2 losse dingen) gebouwd en grotendeels getest. Bij de volgende versie:
changelog-regel(s) + site-hoofdpagina (regel "site volgt elke functie"); release blijft Robs go.

- **Stap 3, smal gehouden:** alleen toestanden die van MH zelf zijn, geen nagebootste client-toestand (CLAUDE.md-regel).
  `ns.TestRunScorecard(kind)` = record/slower/first/equal; de preview van de delve-melding klikt die vier rond. Rare-preview
  wisselt tussen "in de buurt" (zone-standaard) en "aangekomen" (Szarith, met `RARE_SZARITH_HINT`). Tooltip-regel
  `SET_PREVIEW_TT_CYCLE`. De cast-waarschuwing kreeg niets extra: zijn preview toont al balken als die aan staan.
- **Voetregel** onder All settings (`SET_ALL_FOOTER`); scroll-onderkant 10 → 30.
- **"Back to recommended"** per blok met minstens één `rec` (`SET_SEC_REC_BTN`), vraagt eerst (`StaticPopup
  MH_SET_SECTION_REC`, `SET_SEC_REC_CONFIRM_FMT`), zet via de setters terug zonder de vanzelf-previews.
- 4 nieuwe keys, 8 packs, locale_probe OK. Syntax OK, lint 0 HARD. Testlijst "3 nov (4)".
- Rob (Labyrinth-kamer *Malicious Masks*): geen vijanden tot hij de maskers activeerde; onze tekst ("kill what attacks
  around each") klopt ongeveer. Rob: *"we hoeven er verder niks mee"*.

## 🔨 3 nov — live voorbeeld bij de instellingen, stap 1+2 gebouwd (Rob: "Stap 1 en 2")

✅ **Rob testte 5 punten in het spel, alle goed:** vergrootglazen staan goed, pijl 3 s, cast-icoon aan/uit, melding na een
delve, Accessible danger alert vanzelf bij aanzetten. Nog open in testlijst "3 nov (3)": rare, rez/lust, de andere 4
vanzelf-schakelaars, en of de chatregels storen.

Plan `docs/PLAN_VOORBEELD_2026-11-03.md` (na Robs screenshot van MF Nameplates 1.2.5): geen nagebouwd canvas, het echte
ding op zijn echte plek.
- `SettingsDefs.lua` `PREVIEW`: 17 instellingen → 9 bestaande tests (pijl, cast-waarschuwing, actie-geluid, grote melding,
  rare-melding, shard-popup, scorecard/delve-melding, durability-test, rez/lust-paneel). Elke test gelezen vóór het
  koppelen (bestand:regel in de opmerking). Weggelaten: ConsumableReadyTest (stuurt echt een whisper), RunDispelTest en
  TestZoneLevelToast (ontwikkelaars-uitvoer).
- `SettingsPage.lua`: goud vergrootglas (`Interface\Common\UI-Searchbox-Icon`, bestaat: MF tekent hem in Robs screenshot)
  op die regels; klik = `d.preview`. Stap 2: `autoPreview` (5 schakelaars) toont het bij AANzetten, in `AllWrite`.
- 3 nieuwe keys `SET_PREVIEW_*`, 8 packs, locale_probe OK. Syntax OK, lint 0 HARD. Testlijst "3 nov (3)".
- Open: stap 3 (toestanden nadoen) en de twee losse dingen (voetregel, "blok terug naar aanbevolen"); sommige tests
  zetten een debugregel in de chat (rare, shard) — Rob vragen of dat stoort.

## 🔨 3 nov (2) — zoekbalk stap 4-6 gebouwd (Rob: "Ja, doe alle drie")

✅ **Rob testte 5 punten in het spel, alle goed:** *audio* → Rare sound, *rare* → Rares-tab bovenaan, *valeera* + Enter →
Delves, Combat warnings uit → 3 regels grijs + ingesprongen + oranje tooltip, Ctrl+klik → aanbevolen stand. Nog open in
testlijst "3 nov (2)": alert/hotkey, aztarec/coiled/brann, Great Vault grijs, instelling zonder `rec`, Nederlands *alarm*.

- **Stap 4** (`NavSearch.lua` `SYNONYMS`): groepen per MH-taal (en altijd ook Engels), opgesteld door mh-writer uit de
  woorden die de packs echt gebruiken. Een getypt woord uit een groep zoekt de andere ×0,9, maar streng (`SynFit`:
  heel woord, of woordbegin vanaf 4 letters; nooit binnen een woord). Weggelaten: health-groep, popup=window. ⚠️
  Bloodlust/Heroism- en flask-woorden buiten het Engels uit het hoofd, niet tegen wago gemeten (alleen zoekwoorden, nooit
  op het scherm). Tier-gewicht 0,05 → 0,2 en instellingen nu `TIER_CONTENT`: anders kwam "Rare sound" boven de Rares-tab
  bij "rare" (offline GEMETEN). Bekend: "taal" vindt ook "Totaal" via de binnen-woord-regel van stap 2.
- **Stap 5** (`Addons/Guide.lua`, mh-research tegen wago 12.1.7.70668 + Warcraft Wiki): weg brann/zekvir/dornogal/
  undertyr/dreadshore/stormstout/m+ teleport; erbij valeera, azta'rec/aztarec, venomfall, nullaeus, coffer, coiled (isle),
  lu'ashal, thorm'belan; dode harandar/voidstorm uit de SMC-lijst. ✅ Daarna (Rob: "los die kleine dingen ook maar even
  op"): "sporefall"/"rotmire" + Enter → Rotmire's baas-venster (vóór de "spore"-regel); "mentor" uit de Academy-lijst
  (Warband Mentor); ruRU `SET_REZLUST_*` (3 teksten) nu "Боевое воскрешение и Героизм", gelijk aan het paneel zelf.
  ✅ Sporefall/Rotmire + Enter door Rob getest (3 nov). Mentor en ruRU niet in het spel getest.
- **Stap 6** (`SettingsDefs.lua` `PARENT` + `SettingsPage.lua`): 16 instellingen onder 9 hoofdschakelaars, elk paar
  GEMETEN in de module (regels in de opmerking). All settings: ingesprongen, grijs (alpha 0,45) als de ouder uit staat,
  tooltip `SET_DEP_OFF_FMT`. Ctrl+klik (rij, waarde, −/+) = terug naar `rec`; tooltip `SET_CTRL_RESET_FMT` alleen als er
  een `rec` is. Muisknop-aantal bewust niet gekoppeld (KeybindSchema.lua:656). 4 nieuwe keys, locale_probe 8/8.
- Syntax OK, lint 0 HARD, offline test (navtest) groen. Testlijst "3 nov (2)".

## 🔨 3 nov — zoekbalk stap 1-3 gebouwd (Rob: "Begin inderdaad maar met stap 1 tot en met 3")

✅ **Rob testte 5 punten in het spel, alle goed** (arrow size + knipperen, *arow*, *zzzq*, pijltjes + Enter, Escape →
lopen). Zijn enige wens: knipperen 2× zo lang → `PulseRow` nu 6 slagen + 1,2 s uitfaden (~6 s, was ~3 s); dát is nog
niet getest. Daarna ook de rest goed (andersom, rares, Deutsch, geen haperen — gevoel, geen meting —, oude zoekwoorden).
Niet te testen door Rob: zoeken in de/fr/es/pt/it/ru (packs alleen op die client).

Plan: `docs/PLAN_ZOEKEN_2026-11-03.md` (na MF Nameplates 1.2.5; 🔴 geen open licentie → alleen ideeën, eigen code).
- **Stap 1:** `NavSearch.lua` leest `ns.GetSettingsDefs()` → elke instelling een regel (`cat = "setting"`, context
  "All settings > <sectie>", tooltip + dropdown-keuzes als zoekwoorden). Klik → nieuw `ns.FocusSetting(var)` in
  `SettingsPage.lua`: opent All settings, scrolt (rij `_mhY`, één frame later), laat de rij 3× pulseren.
- **Stap 2:** `FilterIndex` scoort per woord (Normalize: kleurcodes/accenten/`m+`; naam weegt 1, keywords/context 0,6;
  gemist woord ×0,5; hele-query-bonus; tier −0,05). Tikfouten (1 vanaf 4 letters, 2 vanaf 7; eerste letter goed of
  verwisseld) alleen tegen de NAAM en alleen als pass 1 niets vond. `@settings`/`@mounts` (meervoud) werkt nu ook.
  0 resultaten → grijze regel `NAV_NO_MATCH` (8 packs, locale_probe 8/8), klik = de oude diepe zoektocht.
- **Stap 3:** pijl op/neer + (Shift-)Tab door de lijst, Enter opent de gekozen rij (anders de oude sterke-match-regel).
  Escape blijft focus loslaten (bewust anders dan MF).
- GEMETEN offline (eigen Lua, NavSearch.lua geladen met stubs, 1500 nep-instellingen): 15-50 ms per query; vóór de
  twee passes tot 0,4 s. In het spel niet gemeten; de echte index-grootte ook niet. Syntax OK, lint 0 HARD.
- `ns.DevNavFilter(query)` geeft de lijst als data (voor `/dump` en de offline test).
- Open: stap 4 (synoniemen per taal), 5 (TWW-woorden in `Addons/Guide.lua`), 6 (ctrl+klik/grijs, Robs keuze);
  site-hoofdpagina + changelog-regel bij de volgende versie.

## 🔨 2 nov (nacht) — Szarith als laatste (Rob: "Goed idee, beide … je krijgt toestemming voor alles"), NIET getest

- `Rares.lua`: Szarith-rij krijgt `last = true`; NearestOpenRareRespectingSkips kiest een `last`-rare pas als er geen
  gewone open rare meer is, maar vóór de geskipte (die draaien eindeloos rond, anders kwam hij nooit).
- Gevolg van de reparatie hieronder (hunt houdt zijn rare): skip, auto-advance, de aankomst-hint en
  `ns.GetNearestIncompleteRareLead` vroegen "de dichtstbijzijnde" en namen aan dat dat de pijl-rare was. Nu via
  `CurrentHuntRare(zone)` (= `huntLead` als die nog open is en in deze zone, anders de dichtstbijzijnde). `huntLead`
  staat nu boven die functie gedeclareerd; StopRareRoute zet hem op nil. Syntax OK, lint 0 HARD.
- Hoe zwaar Szarith is (mh-research, 2 nov nacht; Wowhead npc 263456 + reacties, Method, Icy Veins, wago 12.1.7.70668;
  niets in het spel gezien): **zelf GEEN elite** ("Level 90 Humanoid (Rare)"), maar Underbelly Coilguards en Szarith
  Revelators (Elite) staan op zijn plek; spelers zeggen deels "groep", deels solo gedaan. **Geen rare-ster op de
  minimap** (RareScanner/SilverDragon missen hem; onze vignette-auto-skip ziet hem dus ook niet). Spawn: 10-15 min
  volgens Method, maar in aug uren campen; buiten de Underbelly-strike lopen spelers als geest langs een poort (1 bron).
  Coördinaten 39.50/27.40 passen bij de Wowhead-pins. crit 115282 checkt quest 96030 (= ons veld [1]); 98349 wordt
  door geen criterium gebruikt. → Rij krijgt `noteKey = "RARE_SZARITH_HINT"` (nieuw veld, alleen in RareHintText:
  chat/tooltip/alarm, niet op het pijl-label): "zelf geen elite, maar elite-wachters om hem heen — een groep helpt;
  geen rare-ster op de minimap", 8 packs, eigen vertaling. Verouderde opmerking "he now carries 98349" rechtgezet.
- Niet gedaan, open: of de Eye of Szarith (2613 68.60/15.66, Excising Knife) hem oproept — 3 spelers, onbewezen.

## 🔨 2 nov (laat) — rare-route Coiled Isle, 3 reparaties (Rob: "klopt")

✅ Rob, 3 nov (gesproken): *"vandaag al een rare-route gedaan, [Coiled Isle]. Die ging helemaal goed."* Algemeen
oordeel; de losse punten van TESTLIJST "2 nov" niet apart bevestigd.

Robs melding: rares op de Coiled Isle, pijl naar "the way through" zonder te zeggen waarheen, daarna Lockjaw "686 m" en
alle kanten op. Video `Captures\World of Warcraft 2026-11-02 21-27-15.mp4` + `travelRouteLog` (GEMETEN, 21:23-21:32):
Szarith (2613, 4 stappen) → bij de Vaults-deur 2× terug naar stap 1 (ZONE_CHANGED_INDOORS, kaart bleef 2512) → om
21:28:08 met "player on map nil" naar Lockjaw (lijst-volgorde: geen positie = FAR_CROSSMAP_SORT + idx, Lockjaw is rij 1)
→ Siltmouth → Coin-Eye → Garsecg binnen 75 s, niets gedood (Rob: "ik geloof het niet").
1. `Rares.lua` HuntNextLead: de hunt houdt zijn rare tot die klaar is deze week, met de hand geskipt, een nieuwe hunt
   (`ctx.start`), of de plek 8 s leeg buiten gevecht. Vroeger alleen vast tijdens een gevecht.
2. `Travel/TravelRoute.lua`: een stap die de hand-off-watcher "reached" noemt, krijgt `passed`; CurrentStep gaat daar
   nooit meer naar terug (zelfde mechaniek als de flight master van 17 okt).
3. `TravelPlan.lua`: de deurstap heet nu "the way into <kaartnaam van de client>" (`PLAN_STEP_DOOR_INTO_FMT`, 8 packs,
   eigen vertaling; de/ru met dubbele punt i.v.m. naamval). Zonder kaartnaam de oude tekst.
- NIET gedaan (eerst voorgesteld): "geen stap tonen waar je al staat". De stap "Flight master: Amani Foothold" na het
  hervatten betekent "neem hier de vlucht"; overslaan zou die instructie wegnemen. Of je vanaf Amani Foothold echt naar
  het eiland kunt vliegen: niet gemeten. MH kent alleen de weg NAAR BINNEN (Vaults/Underbelly), niet naar buiten.
- Niet gerepareerd: de eerste keuze van een hunt zonder leesbare positie valt nog terug op de lijstvolgorde (zelden).
- Geen in-game changelog-regel toegevoegd (4.14.0 is uit; de regel komt bij de volgende versie, Robs go).
- Syntax OK (307), lint 0 HARD, locale_probe 8/8 OK. Testpunten: TESTLIJST "2 nov".

## 🌆 2 nov — ronde 's avonds (bouwchat «Bouwchat 02-11»; Rob heeft griep)

- GEMETEN over 31 okt t/m 2 nov: git schoon, pull leeg (alleen de wachter-commits van 1 + 2 nov). Alle 4 wachters:
  nul "moet gefikst", geen nieuwe hotfix (laatste 30 okt), live 70688 / PTR 70668 onbewogen. CF/GitHub 0 open.
  addon_updates: 23 bijgewerkt (alleen changelogs gelezen, niet getest), niets raakt MH; DandersFrames 5.6.1 weer zonder
  changelog (tab Clicks blijft een let-op). HandyNotes 167 onveranderd.
- Vragenlijsten #29 (en/GR, 4) en #30 (de/DE, 5) bijgeteld (Rob: "Ja, tel ze bij"); gemiddelde 4,07.
- De site-chat heet nu «Site chat 03-11»; seintjes over releases gaan daarheen.
- Geen code gewijzigd. Open punten onveranderd (zie 31 okt laat en de TESTLIJST "30 okt").

## 🌙 31 okt (laat) — overdracht naar de volgende bouwchat

- ✅ Labyrinth T11, volle run van 9 kamers (Robs screenshot 31 okt): venster A klopt. GEMETEN uit de screenshot: totaal
  99:23 = som van de kamers, "If every room went like your best: 75:20" = som van de teruggerekende bests, 2 records,
  chat = venster. TESTLIJST "Inhoud van venster A" afgevinkt. Kindo'jan-video: nog niet (niet gefilmd/gemeld).
- Great Vault-popup toont andere characters alleen in de eerste 24 uur na de reset (`VaultReminder.lua`, logica
  onveranderd sinds 2026-06-06, GEMETEN). Voorstel "de hele week tonen" → Rob: *"Laat maar zo"*. Niet opnieuw voorstellen.
  AFGELEID uit de SavedVariables: Iceicebaby heeft waarschijnlijk nog een vault-beloning klaarliggen (Rob gezegd).
- Geen MH: Zygor-fout (`Ver.lua:3`, lege `$Revision$` na hun client-update van 29 okt) opgelost door Robs *Repair* in de
  Zygor-client. Systeempiepje bij de C-toets in WoW: alleen hypotheses gegeven (Windows-standaardgeluid, Razer/Discord/
  NVIDIA/Willow), Rob heeft nog niets teruggemeld.
- Geen code gewijzigd sinds 4.14.0; alles gepusht.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

- 🔜 OPEN na 28 okt (overdracht naar de bouwchat van 29 okt)
- 🔜 OPEN na 26 okt (overdracht naar de bouwchat van 27 okt)
- 🔜 OPEN na 23 okt (overdracht naar de bouwchat van 24 okt)
- 🌅 VOLGENDE CHAT EERST (stand eind 16 okt; bouwchat gearchiveerd door Rob)
- 🌅 16 okt — MORGEN EERST (Rob, 15 okt nacht: "onthoud dit dan kunnen we morgen verder")
- (verslag) 🔴 VOOR MORGEN — Venom Lancer Ori'kassi is geen rare maar een SCENARIO
- 🔴 9 sep — de weekly-vinkjes rusten op bewijs dat niets waard is (OPEN)
- 🆕 30 aug — waar komen onaangeleerde recepten vandaan? (OPEN)
- 🔵 OPEN 29 aug — de SMC-pin zet TWEE waypoints, plus één die niemand vroeg
- 💡 ROB-VERZOEK 19 AUG — "dit soort info moeten wij ook gaan bieden!!!"
- 🎯 MORGEN 19 AUG — PRIORITEIT: de EU-seizoensstart
- ⚠️ OPEN, en het raakt alle vertaalwerk
- 🌅 MORGENVROEG — twee dingen, en Rob brengt data mee
- 🔴 De grootste openstaande vraag (Rob, 11 aug)
- ⏳ Wacht op Rob

📌 Al het afgeronde werk staat in het archief; daar wordt niets meer aan
toegevoegd. Nieuwe regels horen bovenaan dit bestand.
