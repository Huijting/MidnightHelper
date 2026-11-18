# Midnight Helper — waar we staan

## ▶ 18 nov — Bouwchat 18-11

- 🗂️ Briefje gesplitst (regie: 1743 regels, grens 1500): alles vanaf "▶ Open voor 14 nov" (776 regels, 39 secties) staat
  nu bovenaan `NEXT_SESSION_ARCHIVE.md`; hier blijven 966 regels + index. Proefrun eerst, daarna `--resplit … --write`.
- ⏳ Open, wacht op Robs ja via sparring: `ForeverChars.lua:94` vaste spatie tussen naam en achternaam (API-wachter
  `[MOET GEFIKST]`; EditModeBackup gebruikt `CHARACTERNAME_SURNAME_SEPARATOR`). Midnight in stijl A: eerst meten + plan
  naar sparring, nog GEEN bouw-ja.

## 🔴 18 nov — GEEN FABLE deze week (t/m reset za 21 nov 10:00)

Rob (via Sparring 17-11), letterlijk: *"goedemorgen, we stoppen even met fabble voor deze week 🙂 we hebben al aardig wat
uitgezocht en moeten een manier vinden om net zo een goed resultaat te halen zonder fable :)"*.
- Geen `model: "fable"` op helpers tot na de reset. Uitzoeken = `mh-research` (Opus, extra high).
- Kwaliteit zonder Fable: (1) mh-research zoekt het uit; (2) een TWEEDE, onafhankelijke Opus-helper legt de code tegen
  de bronnen (krijgt de code, NIET de conclusie van de eerste); (3) offline simulaties; (4) lint als laatste vóór elke commit.
- Foutsoorten-checklist, in ELKE brief: aantallen bij item-doelen · parallelle quests / meerdere voorgangers · route van
  een ander ras · factie-filters · "afwezig in ItemSparse ≠ bestaat niet" · clientnamen per taal · "wat moet je precies
  klikken/doen".

## ⏭️⏭️⏭️ OVERDRACHT Bouwchat 17-11 (4) → volgende bouwchat (context vol; alles gepusht, GEEN release/tag)

Opdracht van Rob (via Sparring 17-11, letterlijk): *"We doen alles in één keer. … Dus doe alles maar in één keer, dat we
wat moois kunnen leveren."* Release/tag pas op zijn letterlijke go via sparring. Stand per punt van die opdracht:
1. Dock-knop weg — AF (0358b9c). 2. Oude venster weg in Forever, tandwiel = Quiet helpers · Tools · All commands — AF
(0358b9c). 3. Losse vensters in stijl A — GEBOUWD (deze commit): `S.SkinWindow`/`S.SkinOnShow` in ForeverStyle, aan
Do this now, Your direction, New in this version (alleen Forever), toetsenblok (alleen Forever), laatste-gereedschap-
verkocht, beide layout-vragen, gereedschap-tip. NIET geskind: de rode "Delete?"-notitie (waarschuwing, blijft rood),
groepspaneel (HUD), de oude terugval-vensters (onbereikbaar). ⚠️ Niet in het spel gezien; risico: Blizzard-knoppen die
`Disable()` krijgen pakken hun eigen grijze font weer; teksten kunnen in het andere font iets breder zijn → Robs test.
4. Robs testpunten: fonts (be5ee47 + foreverFontProbe nalezen na zijn herstart), overlap, fade, achtergrond dicht —
gedaan, NIET in het spel gezien.
▶ **Bouwchat 17-11 (5): A AF** (bank/AH/brievenbus/herberg). Kopje "In town" in Find (4 nieuwe CATS met `svc` in
ForeverVendors.lua; data `Modules/ForeverCitySpots.lua` = 116 plekken uit `docs/forever/FOREVER_CITY_SERVICES_2026-11-17.md`,
mh-research Fable: Zygor + Wowhead per NPC, brievenbussen alleen met 2+ bronnen; 21 één-bron-bussen staan er
uitgecommentarieerd in het rapport). Steden: SW, IF, Darn, Dalaran (A), Org, TB, UC, + neutraal Gadgetzan, Everlook,
Booty Bay (geen bus: 1 bron), Valanaar. AH-cut GEMETEN in DB2 AuctionHouse (neutraal 15%/borg 25 tegen 5/5; betekenis
kolommen AFGELEID). Valanaar-AH: neutraal of niet NIET gemeten → geen tag. Offline (find_check + 4 soorten × 2 kanten,
elke Show the way): 29.694 runs, 0 fouten; aantallen = rapport. Niet in het spel gezien. Daarna: B en C hieronder.
▶ **B AF**: 25 sleutels in de/fr/es/pt/ru (`ForeverClassQuests_<taal>.lua`; esMX geen eigen regel nodig): tandwiel/Tools
(11) + Find "In town" (14) + FOV_TIP_GEAR/FOV_TIP_TAB_FIND herschreven. Spelwoorden GEMETEN (Forever 1.60.1.70938):
GlobalStrings BANK/BUTTON_LAG_AUCTIONHOUSE/MINIMAP_TRACKING_MAILBOX/_INNKEEPER/_BANKER, NPE_BINDPROMPT (herberg),
item 6948 (Hearthstone), AreaTable 976/35/2255 (Gadgetzan/Booty Bay/Everlook: de houdt Engels; fr Baie-du-Butin/Long-Guet;
es Bahía del Botín/Vista Eterna; pt Geringontzan/Angra do Butim/Visteterna; ru Прибамбасск/Пиратская бухта/Круговзор).
Eigen woordkeus (niet gemeten): "Stille Helfer"/"Aides discrètes"/…, "In der Stadt"/"En ville"/…, borg/deposit-woord.
Controle: alle 23 nieuwe sleutels aanwezig in 5 packs; eigen Forever-resolve-run (IS_FOREVER aan) toont per taal de
vertaling. ⚠️ `tools/locale_probe.lua` is blind voor `ForeverClassQuests_*` (die draaien alleen met IS_FOREVER).
Door geen moedertaalspreker gezien.
✅ **5.5.0 GETAGD** (Rob via sparring, letterlijk: *"Go voor 5.5.0 (en dit is binnen een uur 🙂 )"*): tag v5.5.0 =
41f8ec3, run 44137237357 geslaagd (CF/Wago/GitHub "Success!" voor beide zips). CF-API (GEMETEN, publieke
www.curseforge.com/api/v1/mods/1528577/files): Retail 9669670, Forever 9669685, beide status 4. SITE_SEIN → "staat op CF".
CURSEFORGE_DESCRIPTION.md bijgewerkt in een losse commit na de tag (Rob plakt). Robs testronde van vandaag staat open.
▶ (was:) **C KLAARGEZET, NIET GETAGD — wacht op Robs letterlijke go via sparring.** 5.5.0: beide toc's `## Version: 5.5.0`,
CHANGELOG_550_1-6 (enUS) + Changelog.lua, `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.5.0.md` (byte-gelijk GEMETEN, 4255
bytes, alleen Forever-spelersdingen; lint [27] 0), CHANGELOG.md-blok, SITE_SEIN-regel (Mag op de site: nee). Tekst door
mh-writer, door mij nagelopen: `/mh`/Alt+M → overzicht (UI.lua ToggleMainEntry), rechtsklik minimap → instellingen,
macro-lijst, Hall of Thanes (FDUNG_IN_ENEMY_FMT). "Elke knop heeft een tooltip" afgezwakt (niet gemeten).
🐞 Bij het nalopen gevonden + gerepareerd: `/mh settings` in Forever vroeg scherm "allsettings", de Forever-omleiding
(UI.lua) ving alleen "settings" → opende niet de spelinstellingen. Nu beide. Niet in het spel gezien (TESTLIJST).
Open bij de release (Robs keus, niet blokkerend): `CURSEFORGE_DESCRIPTION.md` noemt het Forever-overzicht nog niet
(niet nagelopen); `CMDLIST_OVERVIEW` beschrijft het overzicht nog met de oude inhoud; `FOV_OLDWIN_BTN`/`FOV_TIP_OLDWIN`
zijn waarschijnlijk dode sleutels; bijna alles van 5.5.0 is nog niet in het spel gezien → beta is een optie.
Tag (na go): `git tag v5.5.0` + `git push origin v5.5.0` (zie docs/RELEASE_CHECKLIST.md).
OPEN, in deze volgorde:
- ~~**A. Bank & Auction House in Find**~~ (AF, zie regel hierboven) (Rob, letterlijk: *"Straks zocht ik de bank en de AH in grootsteden. … Kunnen we
  dat nog erin krijgen?"*; sparring: bouwen voor deze release). GEMETEN door sparring: MH heeft er nu niets voor
  (grep 0; controle "Trade Supplies" 47). Voorstel sparring: Find-categorie "Bank & Auction House", dichtstbij eerst,
  Show the way, reisstap; alle hoofdsteden van je factie + neutrale AH's (Gadgetzan, Booty Bay, Everlook) met de zin
  "neutraal: 15% i.p.v. 5% en 5× borg". Bronnen: Zygor Forever `Data-Forever\NPCData.lua` r.624-698 + `LibRover-1.0\
  data_inns.lua`; coördinatenregel Rob > HandyNotes > Zygor > gids. Sparring-voorbeelden (nameten met mh-research):
  SW AH 60.8,71.5 / bank 64.3,80.8; Org bank 49.6,69.1 / AH 55.9,62.7; TB bank 47,59 / AH ~39-40,50-52; IF AH ~24,72 /
  bank ~35,59; Valanaar (Skyborne) bank 57.6,77 + AH 57.8,77 (factie of neutraal: NIET gemeten). Namen per client
  meten. **Ook Mailbox en Inn** (Rob, letterlijk, op "zullen we er ook de brievenbus en de herberg bij doen?": *"ja doe
  maar"*): per hoofdstad, dichtstbij eerst, Show the way; Inn met "bind je hearthstone hier". Bronnen: Zygor
  `data_inns.lua` (herbergen), brievenbussen uit het bankalt-onderzoek (wowforever.gg 3 nov; voorbeelden SW 61.6,76.1,
  Org 50.7,70.4; herbergen SW 60.4,75.3, Org 54.1,68.4). Sparring: *wat niet gemeten is, liever weglaten dan gokken.* Bouw: nieuwe data-tabel (zoals ForeverVendorSpots), FindCatalog
  sectie, FindPlaces-tak; mh-research (Fable) voor de feiten.
- **B. Vertalingen** de/fr/es/esMX/pt/ru van: FOV_TIP_GEAR (gewijzigd), FOV_SUB_QUIET/TOOLS, FOV_TIP_SUB_TOOLS/CMDS,
  FOV_TOOL_OPEN/MOVE/BAR/NEW/CHANGELOG, FOV_CMDS_SEARCH (+ wat A toevoegt). mh-writer per taal in
  `ForeverClassQuests_<taal>.lua`; ⚠️ niet twee helpers tegelijk probe-jobs laten draaien (zie "Vertaling stap 6-9").
- **C. Release KLAARZETTEN, niet taggen**: versie-voorstel (laatste release 5.4.0 → voorstel 5.5.0: grote Forever-
  functie), CHANGELOG_<ver>_* (enUS), RELEASE_NOTES.md = docs/CURSEFORGE_<ver>.md (alleen spelersdingen), CHANGELOG.md,
  SITE_SEIN.md (nieuw overzicht = grote spelersfunctie), toc-versie. Dan "klaar voor Robs go" naar sparring.
- Daarna/na Robs test: `foreverFontProbe` nalezen; stap 10 (oude Forever-vensters opruimen) pas na zijn test.

## ▶ 17 nov (nacht) — Bouwchat 17-11 (4): plan-stap 4 t/m 9 (Rob via sparring: *"ja ga maar door met 4 tot en met 9"*)

- 🔎 **Stap 4 Vinden GEBOUWD (en + nl)**: tab "Find" in het overzicht (`f.pages.find`, `ns.ShowForeverFind(kind, key)`,
  kind = class/prof/weapon/shop). Links een scrollende lijst (Trainer · Professions, jouw beroepen eerst in goud met skill
  · Weapon skills met (known)/(level N)/groene + · Shops), rechts de plekken dichtstbijzijnde eerst met zone · afstand,
  "The way there: …" (ForeverTravelSentence, alleen de 8 dichtstbijzijnde; wapens: hun eigen Route) en "Show the way ›".
  Knop rechtsboven: class → "What it teaches" (trainer-pagina), beroep met gereedschap → "Where to buy". Data = de lijsten
  van de oude vensters: nieuw `ns.ForeverVendorFindCats/FindRows`, `ns.ForeverWeaponFindList/FindRows`; class- en
  beroepstrainers via `ns.ForeverProfTrainerList(nil|prof)`. Oude ingangen landen op Find: `ShowForeverProfTrainers`,
  `ShowForeverVendors`, `ShowForeverWeapons` (dus `/mh trainers`, `/mh vendor …`, `/mh weapons`, Do this now, tegels);
  zelfde nog eens = dicht. `/mh trainer` en `ShowForeverTrainer()` openen nu de trainer-pagina (knop "All trainers" →
  Find); het oude trainervenster tekent alleen nog met een level-argument (geen aanroeper meer). De oude vensters zelf
  staan er nog (terugval als het overzicht ontbreekt; opruimen = stap 10, na Robs test).
  Tab "Your class" = How you play · Class quests · Camping met een schakelrij bovenaan (`GROUPS`/`PAGE_GROUP`,
  `f.lastInGroup`), zodat de 7 tabs van het plan passen; Camping blijft ook via de Now-regel bereikbaar. Tabrij nu: Now ·
  Your class · Find · Legacy (Legacy gaat in stap 8 naar Karakters). TOC-regels How you play 21→19 px (pagina 30 px lager).
  Offline (scratch find_check: 9 classes × 2 kanten × 2 levels, elke lijstregel aangeklikt, elke Show the way, elke
  pagina/tab/schakelknop en de oude ingangen = 17.844 runs, 0 fouten; 13.692 plekregels, 2.382 met reisstap).
  Vertalingen de/fr/es/esMX/pt/ru: nog niet (komt in een vertaalronde). NIET in het spel gezien. Commit 62439ad.
- ⌨️ **Stap 5 Toetsen & macros GEBOUWD (en + nl)**: tab "Keys & macros" (`f.pages.keys`). Links de drie deuren van
  KeysHub (toetsenblok, KeyPresses, toetsenbord; "tellen staat uit" in oranje zoals KeysHub) + drie schakelaars met een
  AAN/UIT-chip: mouseover (nieuw `ns.IsForeverMouseoverOn`, zet via `ForeverMouseoverSlash`), oude-rang-rand
  (`Is/SetForeverRankGlow`), MH-balklayout aanbieden (`Is/SetForeverBarLayoutAsk`). Rechts de handige macro's: nieuw
  `ns.ForeverMacroViews()` (zelfde `View(d)` als het oude venster, dat er nu ook gebruik van maakt) met Make/Update, Free
  key en Undo freed keys (`ns.ForeverMacroUndoFreedKeys`); ververst bij tas/spell-wijziging via
  `ns.ForeverOverviewRefreshPage("keys")`. `ShowForeverMacros` → deze tab (toggle); in Forever ook `ShowKeysHub`/
  `ToggleKeysHub` (`/mh mykeys`). Het toetsenblok blijft een eigen venster. Offline: find_check uitgebreid (elke chip
  2×, elke deur, elke Make/Free, undo, oude ingangen): 19.032 runs, 0 fouten, 540 macrorijen. "Free key" kwam in de
  proef niet voor (geen toetsbindingen nagebootst) = NIET getest. NIET in het spel gezien. Commit 0bc6db3.
- 🌍 **Vertaling stap 4+5 GEDAAN**: 34 sleutels in de/fr/es/pt/ru (`ForeverClassQuests_<taal>.lua`), esMX 1 eigen regel
  (FOV_TIP_TAB_CLASS "Campamento"). Knopnamen in tooltips = de knoptekst van dat pack. NIET gemeten als clientwoord:
  wapenmeester/"Weapon skills" (de "Waffenfertigkeiten", es "Habilidades con armas" — lang voor een kop), roots/crowd
  control (de/pt), "atalho"/"raccourci" (key binding), "Mouseover" bleef Engels (zoals die packs al doen). Chips: fr
  "ACTIVÉ/DÉSACTIVÉ", pt "LIGADO/DESLIGADO" (breed, chip 52 px — in het spel nakijken), es "SÍ/NO". ru gebruikt "вы"
  (zoals dat pack), niet "ты". Door geen moedertaalspreker gezien.
- 🧪 **Stap 6 Beroepen GEBOUWD (en + nl)**: tab "Professions" (`f.pages.profs`, `f.prof`). Links 12 beroepen (jouw eerst,
  goud, skill), rechts de kaart van `ns.ForeverProfCard` (S.Format), skill-balk, gereedschap-regel (ja/nee via
  `ns.ForeverMissingTools`), knoppen Trainers → Find prof en Where to buy → Find shop; onderaan 3 schakelaars (gedeelde
  `MakeSwitch`/`FillSwitch`, ook op Keys): `ns.db.usedForTip` (Used for + ItemTips), nieuw `ns.Is/SetForeverToolGuard`,
  `Is/SetForeverToolNeedTipOn`. Do this now "ruimte voor een hoofdberoep" (ACTS.profs + knop) → deze tab. Ververst bij
  SKILL_LINES_CHANGED/BAG_UPDATE_DELAYED. Offline 21.372 runs, 0 fouten, 432 beroep-kliks. NIET in het spel gezien.
  Commit 4124a26.
- 🏰 **Stap 7 Dungeons & groep GEBOUWD (en + nl)**: tab "Dungeons & group" (`f.pages.dungeons`). Links de dungeons
  (nieuw `ns.ForeverDungeonList()`: zelfde `State` als het venster; schakelaar "Only for my level" =
  `ns.Is/SetForeverDungeonsAll` omgekeerd), levelchip, zone, "andere kant"/"stad van de …", reisstap voor de eerste 8
  passende, "Way ›" (GoTo van het venster; niet bij alleen-andere-kant). Rechts RAIDS (nieuw `ns.ForeverRaidRows()` in
  ForeverWeek: dezelfde regels als This week) en GROUP: hoogste level (`ForeverGroupTop`), `ForeverNoXpLine` in rood of
  de regel zelf, schakelaars groepspaneel (`Is/SetForeverPartyPanel`) en markeerbalk (`Is/SetFastMarkEnabled`; in
  combat niet, zegt dat). `ShowForeverDungeons` → deze tab (toggle). Ververst bij groep/target/raid-info. Tabrij is nu vol
  (7). Offline 24.702 runs, 0 fouten, 2.682 dungeonrijen. Groepspaneel/markeerbalk in de proef niet geladen = hun
  aan/uit NIET offline getest. NIET in het spel gezien. Commit 9173426.
- 👥 **Stap 8 Karakters + Legacy GEBOUWD (en + nl)**: tab "Characters" (groep `chars` met schakelrij: `chars`, `legacy`,
  `week`; de tab Legacy is weg, de pagina staat nu 30 px lager). Your characters: nieuw `ns.ForeverCharsViews()` (zelfde
  snapshot/teksten als het venster; "x" = vergeten, niet bij jezelf), totaal goud bovenaan. This week: hele
  `ForeverWeekRows`. `ShowForeverChars` → deze tab (toggle; `/mh alts`). Offline 25.386 runs, 0 fouten, 72
  karakterrijen. NIET in het spel gezien. Tabrij nu definitief: Now · Your class · Find · Professions · Dungeons & group
  · Keys & macros · Characters. Commit 8b85b65.
- ⚙️ **Stap 9 Tandwiel GEBOUWD (en + nl)**: knop met tandwiel-icoon (INV_Misc_Gear_01) links van "All tools" →
  pagina `quiet` ("What Midnight Helper does quietly for you"; nog eens = terug naar Now). `QUIET`-lijst in 4 groepjes,
  19 schakelaars met één zin: Train all-knop (`foreverTrainer.trainAll` "off"/nil), trainer-pagina bij level-up
  (`foreverTrainer.auto`), questbeloning (`foreverQuestHint`), richting-vraag, MH-balklayout, Used for, geartip
  (`foreverGearTip`), zegen-tip, tassen/rust/hengel (`foreverWarn.bags/rest/pole`), laatste gereedschap,
  gereedschap-tip, oude-rang-rand, mouseover, groepspaneel, markeerbalk, vuurwerk, camera. Zelfde opgeslagen waarden als
  de slash-commando's (AFGELEID dat elke module ze bij het volgende moment leest — Train all bij de volgende trainer).
  Knop "All settings ›" = `ns.OpenNativeSettings`. Niet als schakelaar: drempels (mana/health/tasplekken) en de Do this
  now-modus (keuzelijst) — die staan in de instellingen. Offline 26.898 runs, 0 fouten, 684 schakelaar-kliks.
  NIET in het spel gezien. "Instellingen in dezelfde stijl per tab" (plan) = de schakelaars op Keys/Professions/
  Dungeons + deze pagina; geen apart instellingenscherm per tab. Commit 561f753.
- 🔍 **Fable-controle 10 macro's BINNEN + fix (sparring: *"Ja, bouwen na stap 9"*)**: mh-research (Fable), alleen gelezen,
  bronnen DB2 wowf 70938 + Blizzards Forever-UI (Gethe bebcb6b) + Wowhead-tooltips. GEMETEN: alle spell-/item-id's,
  levels, classes, reagents kloppen; macro's < 255 tekens in alle talen; `/use item:` gaat via UseItemByName (UI-code).
  Fouten: ptBR Arcane Intellect rang 1 en esMX Create Healthstone rang 1/3 hebben een andere naam → te lage rang; R1
  (AFGELEID): Stealth/Vanish/Eviscerate/Prowl rang 1 telt mogelijk niet meer als bekend na rang 2. FIX: nieuw
  `TopKnown(id)` in ForeverMacros (hoogste bekende rang uit `ns.FOREVER_SPELL_IDS`) in ClassRow (need + titel), Rows()
  (talentrijen), FillTpl `{id}` en eatdrink (Conjure Water). Fortitude-tekst + Sacred Candle (en + nl; de/fr/es/pt/ru in
  de vertaalronde). Offline: rogue met alleen rang 2 → rij te maken (positieve controle rang 1 ook). Niet gemeten (in
  het spel): `/use item:`, `!`, `[noform]`, `[nostealth]`, twee no-GCD-casts op één druk, eten+drinken op één druk.
  Optioneel uit het rapport, NIET gedaan: Healthstone/Soulstone-tekst "Ctrl maakt alleen een nieuwe als je die steen niet
  al draagt"; `/focus` → `/focus target`. Commit af92c43.
- 🌍 **Vertaling stap 6-9 GEDAAN**: 73 sleutels in de/fr/es/pt/ru (`ForeverClassQuests_<taal>.lua`), esMX 11 eigen regels
  ("calabozo", "Accesorios"). Fortitude + Sacred Candle in de/fr/es/pt (Translations2026) en ru (ruRU.lua); naam GEMETEN
  in ItemSparse 70938 per taal (de Hochheilige Kerze, fr Bougie sacrée, es Vela sacra, pt Vela Sacra, ru Священная свеча),
  positieve controle 17028 = de naam die er al stond; "Rang/Grau" GEMETEN (NameSubtext 21564). Gereedschap-zinnen in
  de/fr/es/pt/ru als "…: %s." (geen lidwoord bij een onbekend geslacht). fr "entrée dans une ville ennemie (%s)". NIET
  gemeten als clientwoord: dungeon/raid-woorden in pt/ru, reagents, quest log, hoofd-/bijberoep, "Options → AddOns"
  (oudere strings schrijven "->"). In het spel nakijken: ru-tab "Подземелья и группа" (lang), fr/pt AAN/UIT-breedte.
  FOV_Q_REST_DESC (en) daarna verduidelijkt ("your own mana or health"); de vertalingen zeiden het al goed of dubbelzinnig
  — check_drift zal hem tonen. ⚠️ Proces: de Duitse schrijver zette eerst een probe-job in een scratchpad van een andere
  sessie (edd6953f) en draaide zo een klaarliggende job van die sessie (alleen lezen); teruggezet op "run gh_inbox".
  Les: helpers delen de scratchpad van deze sessie — niet twee helpers tegelijk probe-jobs laten schrijven.
  Commit 974404a.
- ✅ **Rob (via sparring, letterlijk): *"Midnight zelf werkt helemaal goed."*** Retail na alle gedeelde-bestand-wijzigingen
  van vandaag: `/mh`, Alt+M, minimap, snelbalk, instellingen, geen fouten. Forever-test loopt; uitslagen via sparring.
- 🩹 **Robs eerste Forever-test van het overzicht** (Undead Paladin 14, 3 screenshots via sparring; Rob, letterlijk: *"de
  eerste keer kreeg ik 1e screen shot , na een reload de tweede"*). GEREPAREERD (sparring: "ik wil geen fouten"):
  (1) eerste opening na herstart: alle tabs/"All tools"/padnamen LEEG, na /reload goed. AFGELEID: eigen font-bestand
  nog niet geladen bij de eerste SetFont. Kit: `S.Font` onthoudt elke string; `S.RefreshFonts()` zet font + tekst
  opnieuw; het overzicht doet dat 0,1 s en 0,6 s na openen; bij het laden van ForeverStyle laden 4 verborgen strings
  (buiten beeld) de fonts vooraf. Meting `ns.db.foreverFontProbe` (strings, emptyBefore, emptyAfter; laatste 10) — na
  Robs volgende herstart nalezen: zegt of de oorzaak klopte. (2) Do this now: rijen hebben nu de hoogte van hun tekst
  (vaste breedte `f.now.textW`, niet meer 46 px vast); lange hoofdregel zonder tweede regel wordt gesplitst na de eerste
  zin of vóór "(", titel ≥ 31 tekens in 17 px. (3) `S.Scroll` heeft een zachte fade onderaan zolang er meer is (op een
  eigen frame boven de lijst). (4) Het "vage tekstje" (open sinds 17 nov middag) = naamplaatje van een mob door de 0,97
  doorzichtige achtergrond → achtergrond nu 1,0. (5) "All tools" = oude venster, zoals bedoeld tot stap 10. Offline
  26.899 runs, 0 fouten. NIET in het spel gezien. Commit be5ee47.
- 🧹 **"Alles in één keer vóór de release" (Rob via sparring, letterlijk: *"We doen alles in één keer. … Dus doe alles
  maar in één keer, dat we wat moois kunnen leveren."*)** — deel 1+2 GEBOUWD (en + nl):
  (1) Dock-knop weg uit het overzicht (Rob: *"waar gaan we het in godsnaam aan vastplakken?"*); een eerder gedockt
  overzicht wordt één keer losgemaakt. (4) Achtergrond: ook de backdrop eronder dicht (Rob zag *"behalve bovenin een
  beetje"*), rand vol. (2) GEMETEN (scratch forever_inv.py, positieve controle BuildRaresPanel gevonden): het oude venster
  had in Forever alleen start (HomeDashboard), Tools (ToolsLaunchpad), Settings, zoekbalk, commandolijst; 16 andere
  schermen bestaan daar niet. Nu: tandwiel = groep `gear` met schakelrij Stille hulpjes · Tools · All commands. Tools =
  `ns.ToolsLaunchpadVisible(skip)` (nieuw; kaarten die Forever toont, zonder wat al op een tab staat: stat coach, Pawn/
  toetsen-export, naamplaatkleuren, FPS …) + move, quick bar, "New in this version", changelog, instellingen. Commands =
  `ns.MH_COMMANDS` met `CommandItemShown` + zoekvak (offline: 109 regels, "trainer" 2, "zzzz" 0). Knop "All tools"
  weg. Oude venster in Forever onbereikbaar: `ns:ToggleMainWindow`/`ns:ShowMainUI` → overzicht; `ns.SelectTab("settings")`
  → Blizzard-instellingenpaneel (minimap-rechts, /mh settings, snelbalk). Retail onveranderd. Code-opruimen (stap 10):
  NIET gedaan — HomeDashboard/RoomLauncher/ToolsLaunchpad blijven in de Forever-toc (gedeeld, en ToolsLaunchpad levert
  nu de Tools-kaarten); niets zeker dood genoeg om te schrappen.

## ⏭️⏭️ NIEUWSTE OVERDRACHT (Bouwchat 17-11 (3), laatste commit 27e536b, alles gepusht, geen release)

Nieuw werk met Robs ja (*"ja doe maar"*): het overzicht wordt hét MH voor Forever — plan
`docs/forever/OVERZICHT_PRODUCT_PLAN_2026-11-17.md`. Stap 1-3 AF in 8 talen (voordeur, één Now-lijst, trainer-pagina;
zie "▶ 17 nov (laat)" hieronder). VOLGENDE: stap 4 **Vinden** (groot: class trainer, beroepstrainers, wapenmeesters,
gereedschap — vervangt ForeverProfTrainers/ForeverVendors/ForeverWeapons/trainer-zoeker; dan kan `/mh trainer` ook naar
het overzicht), daarna 5 Toetsen & macros, 6 Beroepen, 7 Dungeons & groep, 8 Karakters + Legacy, 9 Tandwiel; 10 pas na
Robs test. Regels: elke oude ingang blijft werken en landt op de juiste pagina; 8 talen; lint als ALLERLAATSTE stap vóór
elke commit. De lijst hieronder (blok 542715e) geldt nog voor de open meetpunten.

## ⏭️ VOLGENDE BOUWCHAT (Bouwchat 17-11 (3) draagt over; laatste commit 542715e, alles gepusht, geen release)

Huisstijl-lijst AF: stijlkit, alle 5 tabs als pagina in `/mh overview` (Now, How you play, Class quests, Camping,
Legacy), vertalingen de/fr/es/esMX/pt/ru, zegen-tip. Ontwerp B: gebouwd en op Robs woord weer weggehaald (één look).
Niets ervan in het spel gezien behalve de naam ("IMA PALLIE") en de How you play-pagina (Robs screenshot). WoW moet één
keer helemaal herstarten (nieuwe bestanden ForeverStyle.lua en ForeverBlessTip.lua).
Open, in volgorde:
1. Robs tests (TESTLIJST, bovenste blokken 17 nov avond). Zijn screenshot: vaag tekstje links naast "CONTENTS" op How you
   play — oorzaak NIET gevonden; knoptekst krimpt nu, nieuwe screenshot vragen.
2. Metingen nalezen na Robs `/reload`: `foreverNameProbe` (welke API geeft de achternaam), `foreverBlessTipProbe`
   (werkt de tooltip-hook in Forever, leest UnitClass een vreemde).
3. Zegen-KNOP (7.2): pas na Robs meting van de tip (sparring akkoord). Plan in IDEEEN "slimme zegen".
4. Sparring maakt een inventaris van alle MH-Forever-functies en hoe ze in het overzicht passen (Robs vraag); plan komt
   via sparring. Nog geen werk.
5. Klein: FHOWTO_ROLES_FOLDED_FMT zegt "at the top" (in het oude venster waar; op de pagina staat de knop onderaan) — in
   7 talen aanpassen samen met een volgende vertaalronde. "Moonkin Stone"-clientnaam nog niet gemeten.
6. Fable-controle van de 10 macro's: kwam niet binnen bij 17-11 (2) tot de overdracht. Niet doorgestuurd gekregen → start
   een nieuwe mh-research (Fable) zoals het blok hieronder (17-11 (2)) zegt.

## ▶ 17 nov (laat) — Bouwchat 17-11 (3): het overzicht wordt hét MH voor Forever (Robs ja: *"ja doe maar"*)

Plan: `docs/forever/OVERZICHT_PRODUCT_PLAN_2026-11-17.md` (7 tabs + tandwiel; deze opdracht = stap 1-3).
- 🚪 **Stap 1 Voordeur GEBOUWD (en + nl)**: nieuw `ns:ToggleMainEntry()` (UI.lua): in Forever het overzicht, anders het
  hoofdvenster. Gebruikt door `/mh` + Alt+M (Core.lua, via MidnightHelper_KeybindToggleMain), compartiment en
  minimap-links (Broker.lua), snelbalk-MH (QuickBar.lua). Minimap-middenklik in Forever = "Do this now" (de
  consumable-borden zitten niet in de Forever-toc); tooltip zegt dat (BROKER_TOOLTIP_*_FOREVER). `/mh overview` staat nu
  in de commandolijst (CMDLIST_OVERVIEW, foreverOnly). Overzicht: tabs op een eigen rij onder de titel (7 gelijke
  plekken), venster 520 hoog; knop "All tools" rechtsboven opent het oude venster (alles zonder tab blijft bereikbaar;
  Rob mag hem weghalen als alle tabs er zijn). Rechtsklik minimap = instellingen (ongewijzigd). Lint 0 HARD, luac OK.
  NIET in het spel gezien.
- 📋 **Stap 2 Eén Now-lijst GEBOUWD (en + nl)**: ForeverDoNow `Collect()` geeft nu ook `items` (elke now- en tip-regel met
  `kind`, tool met `key`) en `ns.FOREVER_DONOW_ACTS` (één actie per soort: trainer/ranks/classquest/weapons/profs/
  dungeons; legacy/camp = pagina). `ns.ForeverDoNowCollect()` voor het overzicht. Overzicht `NowItems()` leest DIE lijst
  (trainer en class quest houden hun rijke delen); de Now-kaart toont de hoofdregel met knop(pen) op de labelrij en
  daaronder ALLE andere regels, scrollend, elk met de knop van het mini-venster. Kaart "THIS WEEK" (ForeverWeekRows:
  resets, evenementen, raids) vervangt de class-quest-kaart (eigen tab nu; Rob mag omdraaien). Goud links onder XP.
  Mini-venster: knop "Open overview" (`ns.ShowForeverOverviewPage`); blijft optioneel (auto/altijd/uit ongewijzigd).
  Lint 0 HARD, luac OK. NIET in het spel gezien. ⚠️ Mijn fout: dbb8ba4 werd gepusht met 1 lint-HARD (bij het weghalen van
  een ongebruikte tekst plakten twee regels aan elkaar; Lua las het goed, de lint niet). Na het weghalen niet opnieuw
  gelint. Gerepareerd in de commit van stap 3.
- 🧑‍🏫 **Stap 3 Trainer-pagina GEBOUWD (en + nl)**: pagina "trainer" in het overzicht (geen tab: via de knop "Details"
  op de Now-kaart en bij een level-up). Bovenaan je geld en wat alles kost (rood wat je tekortkomt), de dichtstbijzijnde
  trainer + knop Show the way; daaronder per spell: icoon (spell-tooltip), naam + rang, prijs, en een label met de toets op
  het MH-toetsenblok (of grijs: passive / bewust niet / eigen balk); dan totem-waarschuwingen, "eerst nodig" en het
  volgende level. Data: nieuw `ns.ForeverTrainerPageData(level)` in ForeverTrainer.lua (zelfde regels als het
  trainervenster). Level-up met nieuwe spells + schakelaar "auto" aan → deze pagina (anders het oude venster als het
  overzicht er niet is). `/mh trainer` opent nog het oude venster (beroepsknoppen + model; dat gaat mee in stap 4
  Vinden). Ververst elke 2 s (geld bij de trainer) zonder je scrollplek te verliezen. Offline gedraaid (scratch
  tr_check: 9 classes × level 1-60 = 540 runs, 0 fouten; 22.782 van 25.745 spell-regels met een toets). Lint 0 HARD.
  NIET in het spel gezien.
- 🌍 **Vertaling stap 1-3 GEDAAN**: 16 nieuwe sleutels in de/fr/es/esMX/pt/ru (`ForeverClassQuests_<taal>.lua`); controle
  130/130 per taal, %s/kleurcodes 0 problemen. Niet gemeten als clientwoord (writers): "raid lockouts" in fr/pt/ru/de,
  "Gold/Or/Ouro/Золото" (uit bestaande packs, niet uit GlobalStrings). Knop "All tools" is kort gemaakt (de "Werkzeuge",
  es "Todo", pt "Tudo", ru "Инструменты"). esES: FOV_TIP_TAB_CAMP/FOV_LABEL_CAMP_HOW zeggen nog "acampar" naast de tab
  "Acampando" (klein, open).
- 📌 Proces (sparring): lint als ALLERLAATSTE stap vóór elke commit, ook na vertalingen; echte uitkomst melden.
- ⏭️ Volgende (plan, zelfde volgorde): stap 4 Vinden (groot), 5 Toetsen & macros, 6 Beroepen, 7 Dungeons & groep,
  8 Karakters + Legacy, 9 Tandwiel; 10 opruimen pas na Robs test.

## ▶ 17 nov (avond) — Bouwchat 17-11 (3) (verse chat, nam het over na 679fed7)

- Start: git status schoon, pull "Already up to date". Gemeld bij Sparring 17-11. Fable-rapport 10 macro's: nog niet
  binnen bij 17-11 (2), die stuurt het door.
- 🎨 **Stap 1 stijlkit GEDAAN**: nieuw `Modules/ForeverStyle.lua` (`ns.ForeverStyle`: T() thema A, Accent, Font, Text met
  rol head/head2/text/textB, Tip, HoverOver, Card, Label, Chip, Button met SetActive, SpellButton, Circle, SpellName,
  SpellIcon, Place). In beide toc's vóór ForeverOverview. ForeverOverview gebruikt de kit; geen zichtbare verandering
  bedoeld. Zonder kit (nieuw bestand na /reload) geeft het overzicht een chatregel i.p.v. een fout: Rob kreeg
  "ForeverOverview.lua:30: attempt to index local 'S'" na een /reload halverwege → **WoW één keer helemaal herstarten**.
  Lint 0 HARD, luac OK. NIET in het spel gezien.
- 📜 **Stap 2 Class quests-pagina GEBOUWD (en + nl)**: tab "Class quests" wisselt nu IN het overzicht van pagina
  (`f.pages.now/cq`, `f.page`; linkerkolom blijft). Eén kaart met scrollende lijst (wiel; Shift+wiel = venster groter,
  via DialogPopup WrapChildren; dunne duim rechts): per keten level-bolletje, spell-icoon, naam, chip KLAAR/NU/LATER,
  de stap zonder plek, de plek als subregel en een eigen "Show the way"-knop. `ns.ForeverClassQuestList` geeft nu ook
  spell/kind/npc/what/zone/x/y/go (later = gever van de eerste quest); route via nieuwe `GoPlace` (ook gebruikt door
  ForeverClassQuestGo, zelfde gedrag). fcq_check loopt nu ook de lijst + elke knop: 908.461 runs, 0 fouten. Nieuwe
  sleutels FOV_CQP_*, FOV_CHIP_DONE, FOV_TIP_CHIP_DONE, FOV_TIP_CQP_* (en + nl; de/fr/es/pt/ru in de vertaalronde).
  Lint 0 HARD, luac OK. NIET in het spel gezien.
- 🏕️ **Stap 3 Kamperen + Legacy als pagina's GEBOUWD (en + nl)**: tabs wisselen in het overzicht. Links kaart "JE KAMP
  NU" / "JOUW LEGACY POINTS" met één rij per meting (kamp: client-spellnamen van Campfire Nearby, Welcoming Campfire,
  Camp Benefits, Boosted Rest, Camping; chip ja/nee/? — ? = onleesbaar, nooit "nee"; Legacy: verdiend/ongebruikt/
  uitgegeven/max/Talented-rang) + wat het betekent (zelfde beslissing als Doe dit nu); rechts de uitlegkaart uit How you
  play in de taal van de client (nieuw `ns.ForeverHowToCommon(englishTitle)`), scrollend. Ververst elke 2 s zolang de
  pagina open is. Nieuw in de kit: `S.Scroll` (ook in Class quests) en `S.Format`. `ns.FOREVER_CAMP_AURAS` uit ForeverCamp.
- 👤 **Volledige naam** (Robs wens via sparring, IDEEEN): GEMETEN in Robs WTF: Forever-characters hebben voor- + achternaam
  (mappen Ima-Pallie, Ima-Lockie, Joey-Whatever). NIET gemeten welke functie de achternaam geeft → `FullName()` schrijft
  alle kandidaten naar `ns.db.foreverNameProbe` (UnitName, GetUnitName(…, true), UnitPVPName, UnitFullName + realm,
  GetRealmName, GetNormalizedRealmName) en toont een achternaam alleen als de client hem geeft (AFGELEID: tweede waarde
  van UnitFullName als die niet de realm is). Eén regel (krimpt 22→16), anders voor- en achternaam onder elkaar.
  Lint 0 HARD, luac OK. NIET in het spel gezien.
- 📖 **Stap 4 How you play als pagina GEBOUWD (en + nl)**: tab wisselt in het overzicht. Links kaart "INHOUD" (klik =
  spring naar dat kopje; jouw richting/rol in klassekleur) + knoppen "Direction: …" (ShowForeverDirection) en "Other
  roles" (alleen als er andere rollen zijn). Rechts de hele tekst met echte koppen, scrollend. Nieuw
  `ns.ForeverHowToSections(token, allRoles)` (zelfde inhoud als het oude venster, zonder class quests/kamperen/Legacy:
  eigen tabs) en `ns.ForeverClassName`; richting kiezen ververst het overzicht (`ns.ForeverOverviewRefresh`). `/mh play`
  opent nog het oude venster. Offline gedraaid (scratch htp_check: 10 classes × 4 richtingen × rollen open/dicht × en/nl/ru
  = 240 runs, 0 fouten; nl-tekst echt Nederlands, ru = Engels omdat dat pack alleen op een Russische client laadt).
  Lint 0 HARD, luac OK. NIET in het spel gezien.
- ✅ **Naam GEMETEN door Rob** (sparring, screenshot Undead Paladin 14): kop toont "IMA PALLIE". Welke API: probe
  `foreverNameProbe` nog nalezen na zijn volgende /reload.
- 🎨 **Stap 5 ontwerp B + schakelaar GEBOUWD (en + nl)**: thema B in ForeverStyle (leisteen, Fonts\ARIALN.TTF voor alles,
  3 px klassekleur-balk bovenop elke kaart, witte koppen). `S.Style()`/`S.T()` lezen `ns.db.foreverStyle` (nil = A).
  Wisselen: knop "Style A/B" naast de dock-knop, instelling (Venster & weergave, alleen Forever: SET_FOVSTYLE_*), en
  `/mh overview style a|b` (Core.lua). Het open venster wordt opnieuw gebouwd op dezelfde pagina
  (`ns.ForeverOverviewSetStyle`). Ook (Robs screenshot via sparring): knoptekst krimpt in `S.Button:SetLabel` tot hij
  past ("YOUR DIRECTION: PROTECTION" liep over de randen). OPEN: een vaag tekstje links tussen de linkerkolom en
  "CONTENTS" op de How you play-pagina: oorzaak NIET gevonden (AFGELEID: misschien een te brede knoptekst, nu gekrompen) →
  nieuwe screenshot vragen. OPEN klein: FHOWTO_ROLES_FOLDED_FMT zegt "at the top", op de pagina staat de knop onderaan
  (in de vertaalronde aanpassen). Lint 0 HARD, luac OK. NIET in het spel gezien.
- 🌍 **Stap 6 vertaalronde GEDAAN**: 5 mh-writers (de, fr, es+esMX, pt, ru), elk alleen in
  `Locales/ForeverClassQuests_<taal>.lua` (fill-regel, al in beide toc's): alle 108 FOV_*, FDUNG_IN_ENEMY_FMT,
  SET_FOVSTYLE_*, FBLESS_*, SET_BLESSTIP_* = 122 per taal; esMX 6 eigen regels. Spelnamen uit CAMPING_/LEGACY_VERIFIED
  hfst 10 en de bestaande How you play-teksten. Controle (scratch fov_check): elke %s/%d en kleurcode gelijk aan enUS,
  0 problemen. Door geen moedertaalspreker gezien. Open punten van de schrijvers (Rob mag kiezen, niets veranderd):
  frFR tab "Camping" (zoals How you play) terwijl spell 1308027 in frFR "Campement" heet; frFR "bonus d'Héritage" vs
  "avantage" door elkaar; de/ru Legacy-knop heet in die client echt "Klassisch"/"Классические" (GEMETEN, LEGACY_BUTTON);
  "Rested": de "Ruhebonus" en ru "отдых" niet als clientwoord gemeten (`-- not measured`); es "camino" = richting én
  knop; `/mh blesstip set` kent alleen Engelse class-woorden (hunter, mage …).
  → Daarna (sparring: de vaste regel "clientnaam wint altijd" beslist het): tabs = clientnaam, GEMETEN in
  CAMPING_VERIFIED r.345 / LEGACY_VERIFIED r.341: frFR Kamperen "Campement", esES "Acampando" + Legacy "Banda antigua"
  (esMX "Legado"), deDE Legacy "Klassisch". frFR overal "avantage d'Héritage" (was ook "bonus"; Rob mag omdraaien).
  "Moonkin Stone"-clientnaam: GameObjects-zoekactie op "Moonkin" gaf 0 rijen (ZONDER positieve controle → bewijst
  niets); nog open.
- 🛑 **Ontwerp B: Rob (via sparring, letterlijk): *"ik denk dat wij gewoon gaan voor onze eerste stijl die we gemaakt
  hebben. We gaan niet eens moeite doen voor de tweede stijl."*** en daarna *"Ja, B mag eruit."* / *"Je moet gewoon één
  mooi product maken."* → **B VERWIJDERD**: thema B + kleurbalk uit ForeverStyle (S.Style weg, S.T() = A), knop "Style
  A/B", `ns.ForeverOverviewSetStyle`, `/mh overview style a|b` (Core + CommandList), de instelling, en alle FOV_STYLE_* /
  SET_FOVSTYLE_* in 9 taalbestanden. `ns.db.foreverStyle` wordt nergens meer gelezen (blijft onschuldig in oude SV's).
  Zijn eerdere "laat de user kiezen" vervalt. Ook: mijn commentaar achter de tab-regels (df8c5ad) gaf lint [7] 5 HARD —
  lint na die commit vergeten; commentaar nu op een eigen regel.
- 🛡️ **Stap 7.1 zegen-tip GEBOUWD (en + nl)**: nieuw `Modules/ForeverBlessTip.lua` (beide toc's → WoW herstarten). Paladin,
  vriendelijke SPELER onder de muis → regel in de tooltip "Midnight Helper: give Blessing of Might (Shift+Z)". Standaard
  UIT: `/mh blesstip on|off`, instelling SET_BLESSTIP_*. Tabel AFGELEID (Classic; Might = alleen melee AP, sparring
  GEMETEN): warrior/rogue Might; mage/warlock/priest Wisdom; hunter/druid/shaman/paladin Kings (20+), anders terugval
  naar wat je kent. Eigen keuze: `/mh blesstip set <class> might|wisdom|kings`, `reset`. Toets alleen als blok-macro
  "MH SHIFT-Z/X/V" bestaat. NIET gemeten: TooltipDataProcessor/OnTooltipSetUnit in Forever, UnitClass op een vreemde →
  `/mh blesstip` print hook + aantal keer gevuurd + keuze en reden, schrijft `foreverBlessTipProbe`. Lint 0 HARD, luac OK.
- ⏭️ Daarna: stap 7.2 slimme zegen-knop (SecureActionButton, apart event-frame; eerst Robs meting van 7.1 afwachten?).
- Rob is ±1 uur weg (sparring, letterlijk: *"Ga samen door met de bouwchat zover mogelijk, dat we een kant-en-klaar
  product hebben."*): lijst afwerken, geen tag/release, geen /nieuwe-chat; context vol → "KLAAR VOOR OVERDRACHT".

## (oud) Overdracht van Bouwchat 17-11 (2) — lijst 1-6 afgewerkt door 17-11 (3); open daaruit: de meetpunten en de Fable-controle

Laatste commit van deze chat: 74c9d13 (overzicht A ronde 5). Plan: `docs/forever/HUISSTIJL_PLAN_2026-11-17.md`.
Huisstijl = prio 1 (Rob). Volgorde (stap 5 van het plan, Rob vroeg ALLE tabbladen in deze stijl):
1. Stijlkit `Modules/ForeverStyle.lua`: haal Card/Label/Chip/Button/SpellButton/Tip/HoverOver/Circle/Font uit
   `ForeverOverview.lua` naar één bestand + thema-tabel A (B volgt). Fonts staan al in `Media/Fonts/` (OFL).
2. Tab Class quests als pagina in het overzicht (data: `ns.ForeverClassQuestList` / `ns.ForeverClassQuestNowParts`).
3. Tabs Kamperen + Legacy als pagina (`ns.ForeverCampState`, `ns.ForeverLegacyState` + de uitlegkaarten uit
   ForeverHowToPlay COMMON).
4. Tab How you play als pagina (het grootst: rollen per 10 levels, Talented-regel, class quests-blok).
5. Ontwerp B + schakelaar A/B (`ns.db.foreverStyle`, instelling + `/mh overview style a|b`).
6. Vertalingen in één ronde (mh-writer): alle FOV_*, FDUNG_IN_ENEMY_FMT naar de/fr/es/pt/ru.
Daarna: slimme zegen (IDEEEN onder Ja): eerst de tooltip-tip, dan de slimme knop.
Elke ronde: lint 0 HARD, luac OK, commit + push, TESTLIJST + NEXT_SESSION, één regel naar de sparring-chat.

Open meetpunten (staan ook in TESTLIJST):
- `/mh macros keys` + "Free key" (knop B) en de rijhoogte in het macrovenster: wacht op Robs test.
- Zegen-paren `[group]` → Greater op een vreemde (paladin 52+): meetklus, niets veranderd.
- Kookvuur in de wereld: geen "ga zitten"; kamp-test BIJ een speler-vuur met Camp Benefits nog open.
- Fable-controle van de 10 macro's: gestart in Bouwchat 17-11 (2), nog niet terug bij de overdracht. Komt het rapport
  niet bij jou aan, start dan een nieuwe mh-research (Fable) met dezelfde vraag (rijen onderaan CLASS_MACROS + DEFS
  `eatdrink`, feiten in `docs/forever/MACRO_IDEAS_2026-11-17.md`).

## ▶ 17 nov (middag/avond) — Bouwchat 17-11 (2) (verse chat, nam het over na 5aa4feb)

- Start: git status schoon, pull "Already up to date". NEXT_SESSION was 1616 regels → gesplitst bij "11 nov — Forever:
  Paladin-macro's" (334 regels, 24 secties naar het archief; proefrun eerst).
- 🔎 **Macro-toetsen met Shift/Ctrl/Alt: GEMETEN in Robs Forever-bindingsbestand** (`_forever_\WTF\Account\JOEYWHATEVER\
  bindings-cache.wtf`, account-breed; Forever heeft geen per-character bestand): het MH-toetsenblok bindt zelf SHIFT-1..4,
  CTRL-1..3, ALT-1..4, SHIFT-Q/F/R/T/E/Z/X/C/V/F1 en ALT-Q/E/R/F/X/C/V/G. Zonder modifier-binding: G, 5-0, -, F2-F4.
  Een `MH+`-macro met `[mod:shift]` op toets 1-4/Q/E/R/F/Z/X/C/V/T krijgt dus vanaf het toetsenbord nooit zijn Shift-deel
  (AFGELEID: WoW vuurt de eigen binding van Shift+toets en valt alleen terug op de kale toets als die vrij is). De
  blok-macro's zelf (`MH <key>`, ForeverBlock.lua) gebruiken geen modifiers (grep 0, positieve controle MACRO_PREFIX).
  GEBOUWD: **`/mh macros keys`** (ForeverMacros.lua, alleen lezen): per `MH+`-macro op een Blizzard-balk de toets, de
  modifiers in de tekst, en per combinatie "free" of "taken by <binding>"; schrijft `ns.db.foreverMacroKeysProbe`.
  Lint 0 HARD, luac OK. NIET in het spel gezien (TESTLIJST 17 nov). Na Robs meting: melding in het macrovenster +
  eventueel schakelaar welke modifier (nooit blok- of andere-addon-toetsen losmaken).
- 🔎 **MEETKLUS (sparring, zegen-onderzoek 17 nov), NIET blind wijzigen**: ForeverBlock_Paladin.lua:47-49 zet de
  zegen-paren als `[group] Greater X; X`, en ForeverBlock.lua:269-270 maakt daar `[@mouseover,help,nodead,group][group]
  Greater X; [@mouseover,help,nodead][] X` van. `[group]` kijkt naar JOU (warcraft.wiki, AFGELEID), dus in een groep +
  mouseover op een voorbijganger gaat de Greater-versie (kost Symbol of Kings 21177) naar een vreemde. Speelt pas vanaf
  52 (Greater Might 25782). Meten: is `[@mouseover,raid]`/party-check op het DOEL waar voor partyleden, en blijft de
  macro onder 255 tekens? GEMETEN: geen Forever-tekst noemt Salvation/Sanctuary/Light (grep, controle Might 29 treffers).
- 🎨 **Rondes 3-4 van A** (sparring-screenshots): class-quest-kaart met tooltip per regel, tips 3 regels, rank op de
  tweede regel in Binnenkort. Rob: *"alle tooltips komen netjes, wauw"*; Redemption-pijl volgt de keten (Rob bevestigd).
  🏰 **Hall of Thanes voor Horde** (Rob koos c via sparring: *"Ik volg jouw advies."*): ForeverDungeons `cityOf =
  "Alliance"` + FDUNG_IN_ENEMY_FMT ("entrance in Ironforge: you travel through Alliance territory"). GEMETEN
  LFGDungeons wowf 70938: Thanes Faction -1, Ragefire 0; sparring: GroupFinderActivity condition 0 / 923 / 924, Blizzard-
  nieuws 20 okt "Horde groups will need to brave the journey into Alliance territory". Alleen en + nl; de/fr/es/pt/ru
  samen met de overzicht-teksten (FOV_*) in de vertaalronde.
- 🎨 **Ronde 2 van A** na Robs oordeel ("Ja, ik ben onder de indruk … dit is de weg waar ik graag heen wil. Absoluut."):
  dock-knop (DialogPopup `_mhDockBtn`) naast de titel; tooltips op tabs/knoppen/spell-iconen (SetSpellByID)/kaartkopjes/
  bolletjes/chips/zegel/portret/XP (hover-frames, zodat slepen blijft werken); pad in 4 gelijke kolommen binnen het
  kader; class-quest-kaart toont de lijst (nieuw `ns.ForeverClassQuestList`) als Doe dit nu de class quest al heeft;
  XP + rested links; beroep/dungeon-tip als extra regels; chips NU/LATER. en + nl. Lint 0 HARD, luac OK. Niet in het spel gezien.
- 🎨 **Huisstijl: RUWE VERSIE A GEBOUWD** (Rob via sparring op het plan, letterlijk: *"ja, met de mooie letters meteen
  erin, en eerst een ruwe versie van A om te bekijken"*). Nieuw: `Modules/ForeverOverview.lua` (beide toc's), `/mh
  overview` (CommandList: unlisted-on-purpose), fonts in `Media/Fonts/`: Cormorant SC Bold/SemiBold + Alegreya Sans
  Regular/Medium uit github google/fonts (METADATA.pb license "OFL", Cyrillisch erin, geen Reserved Font Name in de
  copyrightregel: GEMETEN), OFL-*.txt ernaast; package.ps1 en .pkgmeta laten .ttf/.txt door (GEMETEN). Terugval op
  Morpheus/Friz als SetFont faalt. Data zonder nieuwe metingen: kaartjes Doe dit nu (trainer + class quest + kamp/
  Legacy, eigen "Show the way"-knop per plek), Binnenkort (trainer-spells 6 levels vooruit), Class quest (nieuw
  `ns.ForeverClassQuestNowParts`: titel/wat/plek los), Jouw pad (nu + 3 trainer-levels). Tabs: How you play/Class
  quests openen /mh play, Kamperen/Legacy printen /mh camp / /mh legacy (ruw). en + nl. Lint 0 HARD, luac OK.
  NIET in het spel gezien; nieuwe bestanden → WoW helemaal herstarten. Volgende: Robs reactie → stijlkit netjes
  (`ForeverStyle.lua`), stap 2 (DoNow-items), B, schakelaar, vertalingen.
- 🧪 **Robs test 17 nov (paladin 14, Undercity)**: "Eat and drink" eet en drinkt tegelijk, geen foutmelding (GEMETEN).
  `/mh macros keys`: "MH+ Holy Light … key 5: SHIFT-5 is taken by Action Page 5"; Shift+5 gaf geen Flash of Light
  (GEMETEN; SV `foreverMacroKeysProbe` "SHIFT-5=ACTIONPAGE5"). Dus ook Blizzards STANDAARD Shift+1..6 = Action Page
  botst (het bindings-cache-bestand bewaart alleen wijzigingen, daarom zag ik die eerst niet).
  → Rob koos **"B"**: GEBOUWD in ForeverMacros.lua: per gemaakte macro in het venster een rode regel "Shift+5 is taken by
  Action Page 5 …" + knop **Free key**, alleen voor Blizzard-paginatoetsen (ACTIONPAGE1-6, NEXT/PREVIOUSACTIONPAGE;
  nooit MULTIACTIONBAR = MH-blok, nooit andere addons); onthouden in `ns.db.foreverFreedKeys`, knop **Undo freed keys**
  onderaan + `/mh macros keys undo`. Ook: rijen groeien mee met hun tekst (Robs screenshot: Self Cast-waarschuwing liep
  over de volgende rij). en + nl; de/fr/es/pt/ru volgen. Lint 0 HARD, luac OK. NIET in het spel gezien.
- 🆕 **Tien macro-ideeën GEBOUWD (en + nl)** (Robs ja via sparring, letterlijk in IDEEEN onder Ja). Feiten:
  `docs/forever/MACRO_IDEAS_2026-11-17.md` (mh-research Fable; bronnen DB2 70938 + Blizzards Forever-UI-code
  Gethe/wow-ui-source branch forever + gidsen; Forever Leveling Guide niet geopend). In ForeverMacros.lua: DEFS-rij
  `eatdrink` (WATER/FOOD-lijsten met itemlevel, BestEdible), class-rijen met `tplFn` (ClassRow nieuw; RefreshAuto
  herbouwt ze bij tassen) voor Healthstone/Soulstone/Mana Gem/Aspects/Prowl (vormnummer via GetShapeshiftFormInfo),
  gewone rijen Intellect/Fortitude/Spirit/Shadow Bolt/Res ×3/Shackle/Hibernate/Stealth/VanishSprint/Finisher/Fire Totem.
  Overal Ctrl. FMAC_CLASS_SUB: "five" weg. Lint 0 HARD, luac OK. Loopt: mh-writer vertaalt de/fr/es/pt/ru, Fable-helper
  kijkt de rijen na. Open uit het onderzoek: `/use item:`, `!`, `[form:n]` niet in de client gedraaid; rank-1-id als
  `need` bij rogue-spells (test in TESTLIJST).

## ▶ 17 nov — Bouwchat 17-11 (sessie "addons-fd"; nam het over van 16-11 (2), die op een toestemmingsvraag hing)

- Ochtendronde (GEMETEN): pull 558afb5 → 273dc5a (alleen wachters + regie); 5 wachters met regel van vandaag, 0 nieuwe
  [MOET GEFIKST]. CF 0 open (8), GitHub 0. addon_updates geen 🔔 (RaiderIO: Menu.ModifyMenu-taint in Forever-gamepad-UI;
  MH gebruikt geen ModifyMenu, GEMETEN, tegenproef MenuUtil 8 treffers). HandyNotes 171 onveranderd. Zygor Forever: nieuwe
  gids Drowned City; MH had hem al (ForeverDungeons.lua:73, 35-42). Mail: alleen een sitechattest-formulier. BOUW_VRAAG
  geen open. Notion: dezelfde 4 regels "Nieuw".
- SITE_SEIN: regel voor de druid class-quests + rollen (alleen op main) en de notitie dat `/mh partytest` een meetknop is
  (regisseur, "Loopt scheef" rij 1 en 2).
- Open: de 2 ideeënbus-voorstellen van 15 nov (IDEEEN r. 872) → Rob kiest Open/Nee (niet door mij beslist).
- Nu: stap 3 (8 classes), volgorde warlock, warrior, shaman, rogue, hunter, paladin, priest, mage.
- 🔮 **Warlock class-quests GEBOUWD (en + nl)**, `Modules/ForeverClassQuests.lua` CHAINS.WARLOCK + WL_P + NPC_NAMES (36
  NPC's × 6 talen, GEMETEN door mh-research; esMX ontbreekt bij Banehollow/Dreadsteed Spirit → Engels). 24 ketens: imp 1
  (4 rassen), voidwalker 10 (4), succubus + incubus 20 (A, H-Org voor Orc/Troll, H-UC voor Undead), felhunter 30 (3),
  felsteed 40 (4), dreadsteed 60 (4). Feiten: `docs/forever/WARLOCK_CLASSQUESTS_2026-11-17.md`. Drie Zygor-fouten NIET
  overgenomen (1795 i.p.v. 1471, 1801 i.p.v. 1758, Demisette 4488). AFGELEID: incubus = 713, Orc/Troll lopen Orgrimmar,
  dreadsteed-volgorde, 7631 objective 1 = de Xorothian Dreadsteed. Elke `W.<plek>` nagelopen tegen WL_P (59 namen, alle
  aanwezig). Lint 0 HARD, luac OK. NIET in het spel gezien (TESTLIJST 17 nov).
  Open warlock: FCQ_OBJ_WL_* vertalen (de/fr/es/pt/ru, item-namen per client meten), rollen per 10 levels (ROLES.WARLOCK),
  item-ketens Green Flame + Imp's Request.
- ⚔️ **Warrior class-quests GEBOUWD (en + nl)**: WR_P + CHAINS.WARRIOR + 18 NPC's × 6 talen (Klannoc esMX niet gemeten).
  Defensive Stance 10 (Human 1638-1665, Dwarf/Gnome 1679-1678, NE 1684-1683, Orc/Troll + Tauren 1505-1498, Undead
  1818-1819, Skyborne 94003), Berserker 30 (1718-1719), Whirlwind-wapen 30 (1791-1792, `needs = 1719`), Fallen Hero 50
  (8417-8425). Feiten `docs/forever/WARRIOR_CLASSQUESTS_2026-11-17.md`. AFGELEID: Taunt/Sunder/Intercept uit die quests;
  ras→route = Zygor; 1719 bewust zonder objective-index. Zygor-fouten niet overgenomen.
  Nieuw in de module: `needs` (keten wacht op een quest; `Ready()`), en bij gelijk level blijft de tabelvolgorde
  (table.sort was niet stabiel).
- 🔍 **Druid nagekeken door Fable** (Sparring 17-11, alleen lezen; Rob, letterlijk: *"ja dat klopt en loop de andere classes
  die hij met opus gemaakt heeft ook maar na, ik wil geen fouten"*). Quests/volgorde/levels/NPC's/coördinaten/rassen
  kloppen; 3 tekstfouten GEREPAREERD in 7 talen: Horde 6002 eigen sleutel `FCQ_OBJ_LUNACLAW_H` (geen grot, Moonkin Stone
  buiten achter het eerste hutje); Balance "Moonfire op 4"; "terug IN Moonkin Form kost mana". Bijvangst: ruRU dubbel
  "в облике Облик" (2×) weg. "Moonkin Stone" in de/fr/es/pt/ru Engels gelaten: clientnaam NIET gemeten (game-object;
  meten met gamedata). Zes twijfels voor het spel in TESTLIJST 17 nov. Sparring laat ook warlock, warrior en shaman
  door Fable nakijken; rogue/hunter en verder worden met Fable uitgezocht (2-3 tegelijk, één op de voordeur).
- 🏹 **Hunter + Rogue class-quests GEBOUWD (en + nl)**, uitgezocht door mh-research op **Fable** (Robs ja via sparring),
  zonder voordeur. Hunter: HU_P + CHAINS.HUNTER (tame 1515 + training 5149 met `needs`, per ras; Human 94792-94793 en
  Skyborne 94978-94050 nieuw in Forever; Charm 8151-8232 op 50). Rogue: RO_P + CHAINS.ROGUE (Blade 10 per ras, Tools 16,
  Poisons 20 = 2359/2480 GEMETEN, Xelthos 78261-78307 en Bhossca 78676-78699 nieuw in Forever, Azure Key 50). Feiten:
  `docs/forever/HUNTER_…` en `ROGUE_CLASSQUESTS_2026-11-17.md`. Nieuw in de module: `wait` op een quest (alleen later
  aangeboden, hier na een brief van C) → stap "wacht op …" i.p.v. "haal de quest". Keuzes bouwchat (Rob mag omdraaien):
  Zanzil-kuur NIET gebouwd (wie anders geneest houdt de regel), hunter 60 Ancient Leaf NIET (begint met een item),
  Skyborne-Alliance-rogue op de Human-route (AFGELEID). NIET in het spel gezien (TESTLIJST 17 nov).
- 🌩️ **Shaman class-quests GEBOUWD (en + nl)**, mh-research op Opus (gestart vóór Robs Fable-ja; sparring kijkt hem na
  met Fable). SH_P + CHAINS.SHAMAN: Earth 4 / Fire 10 / Water 20 / Air 30 per route (Orc/Troll, Tauren, Dwarf nieuw,
  Windshaper nieuw), Elemental Mastery 52 Horde. Nieuw in de module: `obj` op een plek (vuurpot/altaar als gever) +
  `OBJ_NAMES` per taal. ptBR 251374 bewust weggelaten (Wowhead "Moldavento" kapot). Feiten
  `docs/forever/SHAMAN_CLASSQUESTS_2026-11-17.md`. fcq_check 405.721 runs 0 fouten, 171 sleutels.
- 🔍 **Warlock nagekeken door Fable** (sparring, alleen lezen; id's/gevers/levels/plekken/indexen/namen kloppen) →
  GEREPAREERD: (1) Inferno 1122 = beloning 7603 → keten WlInferno (7601-7603, Niby/Impsy) gebouwd, 1122 + 18540 in
  FOREVER_QUEST_FIRST; Ritual of Doom 7581-7583 (Daio) NIET gebouwd, gevers/plekken niet gemeten (open). (2) Figurine-
  tekst met de kar-stap. (3) Dreadsteed: nieuwe `strict`-ketens + `needs` per quest (`Current()`): eerst wat in je log
  staat, anders de eerste quest waarvan alle voorgangers af zijn (needs AFGELEID uit Questie/warcraft.wiki). (4) Troll
  niet meer naar Orgrimmar op 20/30/40 (`WL_ORC`; keuze, Rob mag omdraaien). Ook: Ulathek-coördinaat uit de tekst, nlNL
  "uilbeesten" → Owlbeasts. Twijfels in TESTLIJST.
- 🔍 **Uit sparrings wapenquest-onderzoek**: Bhossca = een ZWAARD (Ruby-Adorned Blade 277246), tekst en/nl gerepareerd.
  En: een overgeslagen item-keten bleef bovenaan "Do this now" → `ForeverClassQuestNow` doet nu eerst spell-ketens, dan
  item-ketens, en een item-keten alleen t/m 10 levels na zijn start (`ITEM_CHAIN_SPAN`, AFGELEID); `/mh classquest` print
  de reden ("not in Do this now: …"). fcq_check 411.391 runs, 0 fouten, 175 sleutels.
- ✨ **Priest class-quests GEBOUWD (en + nl)**, mh-research op Fable. PR_P + CHAINS.PRIEST: per ras één stap met `alt`
  (alle "ga naar je hogepriester"-id's delen één UniqueBitFlag, GEMETEN in QuestV2; dat inleveren van één id alle id's
  "done" maakt = AFGELEID, test in TESTLIJST), 12 ras-spells (10/20), gewaad 5 (item-keten), Cenarion Aid 50. Zygor-
  fouten niet overgenomen (Dwarf naar Rohan, Human = Divine Grace 94773, id's Tai'jin/Miles/Ur'kyo). fcq_check 418.951
  runs, 0 fouten, 185 sleutels. Feiten `docs/forever/PRIEST_CLASSQUESTS_2026-11-17.md`.
- 🛡️ **Paladin class-quests GEBOUWD (en + nl)**, mh-research op Fable. PA_P + CHAINS.PALADIN (12 ketens, 41 NPC's × 6 talen).
  Nieuw in de module: `item` op een quest (start uit een boek in je tas) → stap "use %s in your bags" (FCQ_USE_ITEM_FMT,
  itemnaam van de client). Keuzes (Rob mag omdraaien): Undead Forsaken Charger 97174-97185 NIET gebouwd (gevers AFGELEID,
  speler meldt vastlopen na 97177); Cloak of the Divine Storm / Aeonas / Reliquary of Tyr / Errant Knight niet uitgezocht.
  Open: 5502 Sense Undead (uit 1652) en de mount-spells niet in FOREVER_QUEST_FIRST gezet (trainer-gedrag niet gemeten).
  fcq_check (nu ook met "item in je tas"): 767.341 runs, 0 fouten, 234 sleutels.
- 🔮 **Mage class-quests GEBOUWD (en + nl)**, Fable. MA_P + CHAINS.MAGE (14 ketennamen). GEMETEN: geen rank-quests,
  geen teleport/portal-quests. Daarmee **stap 3: alle 9 classes gebouwd** (en + nl). fcq_check 908.461 runs, 0 fouten,
  284 sleutels. ⚠️ Ook gedaan en weer TERUGGEDRAAID (sparring, terecht): de 7 level-50 Sunken Temple-ketens beloofden
  even geen voorwerp meer omdat de beloningen niet in de lokale ItemSparse 70938 staan. GEMETEN daarna: die tabel heeft
  1885 andere items van 20000-22999 maar mist juist deze; Wowhead Forever toont ze wel (twee helpers) → items via
  hotfix/server, de tabel bewijst niets. Beloningen staan weer in de namen (ook Torwa in 5 talen). Les: [[silence-is-not-absence]].
- 📋 **Nieuw werk (Robs ja via sparring)**: Legacy (onderzoek in `docs/forever/LEGACY_RESEARCH_2026-11-17.md`) + de
  **Talented-fout** (eerst!), Kamperen (`docs/forever/CAMPING_RESEARCH_2026-11-17.md`). Wapenquest-idee: Open, geen ja.
- 🔍 **Warrior nagekeken door Fable** (sparring): F1-F5 GEREPAREERD: `O(…, count)` (charms pas klaar bij 8, of de
  Essence); Burning-charm-tekst zonder "haal de quest"; Ulag = de schedelsteen (Mausoleum Trigger 59.2, 48.6); Cyclonian
  "volg Bath'rah"; generiek in `MyChains`: toont je eigen ras-route nog niets maar de route van een ander ras van je
  factie wel (done of in log), dan volgt MH die. Ook: een item-keten verdwijnt niet als er een quest van in je log staat.
  Skyborne Taunt/Sunder: testregel in TESTLIJST.
- 🐞 **Talented-fout GEREPAREERD** (Rob: *"het gat met talented als fout laten repareren"*): ForeverMacros.lua
  `ns.ForeverTalentedRank()` (C_Traits: config via systeem 45 of boom 1188, node 110298 currentRank; pcall + issecretvalue;
  schrijft `ns.db.foreverTalentedProbe` om te meten) en `ns.ForeverTalentLevel(base)` = base − rang (min 5). Gebruikt in
  ForeverDirectionTalents ("Do this now" Coming up, + hint FDONOW_TALENTED_HINT als de rang niet leesbaar is), de
  macro-regel "(from level X)" en een grijze regel onder de class-tekst in How you play (FHOWTO_TALENTED_NOTE /
  _RANK_FMT). `/mh donow check` print rang + bron. AFGELEID tot Robs meting (TESTLIJST 17 nov). Alleen en + nl.
- 🔎 **MOGELIJKE FOUT, eerst METEN (Sparring 17 nov, macro-onderzoek Opus)**: ForeverMacros.lua gebruikt vooral
  `[mod:shift]` (61× vs 20× ctrl/alt, helper GEMETEN). Heeft Shift+toets een eigen binding (Blizzard ACTIONPAGE, of MH's
  eigen blok: Shift+1..4 / Ctrl+1..3 / Alt+1..4 volgens Robs bindings-cache 16 nov), dan ziet de macro op de kale toets
  de modifier nooit → werkt alleen met muis+Shift (AFGELEID). Meten: probe met `GetBindingAction(key, true)` voor
  SHIFT-1..6, CTRL-1..0, ALT-1..0 in Robs client. Klopt het: melding in het macrovenster ("Shift+1 is al bezet door X"),
  `/mh macros keys`-diagnose, eventueel schakelaar welke modifier. NOOIT blok- of andere-addon-toetsen losmaken; alleen
  Blizzard-standaarden, met ongedaan maken (patroon row.was in ApplyLayout.lua). Ter info: "Free the keys" van de
  Forever Leveling Guide wist zulke bindings zonder ongedaan maken (AFGELEID uit hun code) — Sparring waarschuwt Rob.
- 🗂️ **Uitlegkaarten Kamperen + Legacy Points GEBOUWD (17 nov)**: in ForeverHowToPlay `COMMON` na "Before you start",
  en + nl + de/fr/es/esMX/pt/ru (mh-writer, alleen uit de VERIFIED-hoofdstukken "mag gebruiken"; namen uit hun
  hoofdstuk 10 + SpellName per taal). Niet gemeten in alle talen: questtitel "The Great Outdoors", "Innkeeper Wiley",
  het woord "Scarce" (Bountiful Harvest) — Engels gelaten met `-- not measured`. Twijfels: deDE "Alchimie" vs
  "Alchemie", frFR First Aid "Premiers soins" vs "Secourisme", ptBR Talented = "Talento é para quem tem".
  ⏭️ VOLGENDE (verse bouwchat, Robs ja): Robs test bij een vuur met Camp Benefits aan (positieve controle voor
  `/mh camp`), dan de huisstijl A+B (IDEEEN).
- 🔴 **Talented-fout 2 (17 nov, GEMETEN in Robs SV, account zonder Legacy)**: activeEntry = 136852 (rang 1) terwijl
  ranksPurchased/currentRank/activeEntry.rank 0 → MH zei rang 1 → talent-levels 1 te vroeg voor iedereen zonder
  Talented. Fix in ns.ForeverTalentedRank: entry telt alleen als er iets gekocht is; alles 0 = rang 0. `/mh legacy`
  zegt nu "Legacy not unlocked yet" bij earned 0. Rang 1-5 met een ECHTE aankoop: nog niet gemeten.
- ⏭️ **STAND 17 nov middag**: (1) pijl-schakelaar GEBOUWD (537c850). (2) Kamperen: onderzoek nagelopen door Fable
  (`CAMPING_VERIFIED`), stap 1 GEBOUWD (`ForeverCamp.lua`: `/mh camp` + "Do this now ga zitten"); kaart wacht op Robs
  test. (3) Legacy: nagelopen door Fable (`LEGACY_VERIFIED`, API GEMETEN in Blizzards UI-code: GetConfigIDByTreeID(1187)
  + GetTreeCurrencyInfo; renown 2802) → stap 1 GEBOUWD (`ForeverLegacy.lua`: `/mh legacy` + "Do this now"
  ongebruikte punten; Talented leest nu eerst boom 1188). VOLGENDE na Robs tests van `/mh camp` en `/mh legacy`:
  de twee uitlegkaarten (Kamperen = ForeverProfGuide versie B; Legacy) met mh-writer, uit de VERIFIED-bestanden. (4) Daarna: nieuwe
  huisstijl A+B met schakelaar (IDEEEN, Robs ja), liefst in een verse bouwchat.
- 🧪 **Rob-test 17 nov (troll mage 6, via sparring)**: LEARNED_SPELL_IN_SKILL_LINE vuurt ook voor een nieuwe RANK
  (143 Fireball). ForeverDoNow kijkt "op een balk" per spellnaam, dus Rank 2 met Rank 1 op de balk geeft geen
  "New, but on no bar"-regel (code GEMETEN r.82-118; in het spel niet gezien: toetsenblok stond). OPEN observatie:
  **Forever Leveling Guide en MH botsen op de pijl** → Rob: "C met als standaard A" → GEBOUWD 17 nov (schakelaar
  `/mh arrow guide` / SET_ARROWGUIDE_*, standaard opzij bij `WowF.viajeEstado()`; details IDEEEN). Wacht op Robs test.
- 🌍 **Vertaalronde class-quests GEDAAN** (5 mh-writers tegelijk, elk een eigen bestand): `Locales/ForeverClassQuests_
  deDE/frFR/esES/esMX/ptBR/ruRU.lua` (in beide toc's, vóór Locale.lua; stoppen zelf buiten Forever/andere client; fill-
  regel zoals Translations2026). 254 sleutels per taal (alle FCQ_ van warlock t/m mage + 3 Talented), esMX 118 overlay-
  regels. Spelnamen GEMETEN in DB2 per locale (ItemSparse/SpellName/AreaTable/GlobalStrings, lokale cache) + Wowhead-
  Forever-tooltips; niet-meetbare namen Engels met `-- not measured:`. ⚠️ Wowhead-locale-codes (GEMETEN met npc 233):
  2 fr, 3 de, 6 es, 7 RU, 8 pt, 11 esMX — mijn opdracht zei 7=esMX (fout; de es-schrijver gebruikte `?locale=esMX`).
  10 sleutels die ik tijdens de ronde wijzigde zijn daarna in alle talen bijgewerkt. Open: "Eternal Flame" nog Engels in
  es/esMX/ru naast de gemeten fakkelnaam; waterzak-itemnamen niet gemeten; esMX HU_CHARM/PR_CENARION nu = esES.
- 🔍 **Shaman nagekeken door Fable** → gerepareerd: Mastery 50, Air `always`, Skyborne Earth 3, ritueel/Kuramaa/waterzak-
  teksten, alle Sunken Temple-ketens neutraal "(item rewards)". **Talented gecorrigeerd**: rang uit `activeEntry.entryID`
  (DB2 GEMETEN: node 110298 Type 1, 5 entries 136852/137374/137373/137372/137371 = rang 1-5), probe met alle velden.
- 🧭 **Rollen stap 2 (8 classes) begonnen**: warrior/mage/priest AF in ForeverHowToPlay `ROLES` (en + nlNL, vorm = druid;
  gids-onenigheid eerlijk benoemd of weggelaten). Warlock AF (band 1 Affliction, 2 Demonology, 3 Destruction; Wrack = nieuwe werking,
  toetsloze kernknoppen = blok D). Paladin AF (band 1 Holy, 2 Protection, 3 Retribution; HotR/Voice of Truth
  weggelaten). ✅ **ROLLEN STAP 2 KLAAR: alle 9 classes in ROLES (en + nl).** ✅ Vertaald in de/fr/es/esMX/pt/ru
  (6 mh-writers, 28 entries per taal, spelnamen via ID uit SpellName.<lang>.csv). Niet gemeten: esES "Giants,
  Dragonkin" (Engels gelaten); deDE afgeleid: Höllenbestie/Teufelsross/Schlachtross/Streitross. Client-eigenaardigheden
  bewust gevolgd: esMX Spirit Weapons = "Parar" (GEMETEN, oude Parry-naam), ru tikfouten Blizzard, fr/pt/de dubbele
  namen (Siphon d'âme, Ruína, Entfesselter Zorn). Volgende: pijl-schakelaar (IDEEEN), dan Legacy en Kamperen. Paladin-klassetekst
  in 7 talen: Divine Intervention (F3 in gevecht) doodt jezelf (GEMETEN Spell 19752 "sacrifices himself") + Templar's
  Bulwark geeft ook Forbearance (GEMETEN Spell 25771). OPEN uit onderzoek (bouwchat): toets 3 = {Seal of Command, Seal
  of Righteousness} verbergt SoR voor Ret (Unsealed Wrath wil wisselen); Righteous Fury ontbreekt in de klassetekst;
  Hammer of the Righteous (40) / Voice of Truth (20) niet in ForeverTrainerData (trainer?) en HotR vraagt eenhandig
  wapen; Torment (warlock) zegt "taunt", onderzoek zegt alleen threat (niet zelf gemeten).
  Shaman AF (band 1 Elemental, 2 Enhancement, 3 Restoration; variant A: één tank-zin
  bij Enhancement, Rob kan B nog kiezen; geen getallen voor Stormstrike/Mental Dexterity/Maelstrom wegens hotfix 10 nov).
  Hunter AF (band 1 BM, 2 MM, 3 Survival; Counterattack "25 or 30", Strider Kick/
  Aspect of the Beast "op je eigen balk"). Rogue AF (band 1 Assassination, 2 Combat, 3 Subtlety;
  rogue-bomen omgebouwd 2 nov, oude talenten niet genoemd). Hunter- en shaman-onderzoek klaar (`HUNTER_/SHAMAN_ROLES_
  2026-11-17.md`), teksten volgen; warlock/paladin in onderzoek. Shaman: keuze Enhancement-als-noodtank (A één zin /
  B eigen rol) ligt bij Rob via sparring, zonder antwoord A. Hunter-klassetekst gerepareerd in 7 talen: tem-quests geven
  Tame Beast/Call Pet/Dismiss Pet, de quest erna Revive Pet + Feed Pet (GEMETEN: SpellEffect 1579 → 1515/883/2641,
  5300 → 6991/982; namen per taal uit SpellName). Open uit hunter-onderzoek: Strider Kick/Aspect of the Beast zonder
  vaste toets; Immolation Trap verliest Shift-2 op 34; Counterattack 25 of 30; Lacerate niet in ForeverTrainerData. Vertalingen van de ROLES-teksten naar de/fr/es/pt/ru: nog niet. Inner Focus:
  `talentLevel = 20` in SPEC_MACROS (macro 40, talent 20). Open uit priest-onderzoek: Lightwell (40/50/60), Prayer of
  Fortitude (48, uit een Codex?), Prayer of Shadow Protection (56) mogelijk niet in ForeverTrainerData; Vampiric Embrace
  25 of 30 (test). Warrior: Shield Wall ook schild-eis (CLASSES.WARRIOR r.193).
- ⏭️ **Volgorde nu**: (1) ✅ Talented-fix; (2) vertaalronde de/fr/es/esMX/pt/ru voor alle FCQ_ +
  NPC-namen per taal al klaar; (3) rollen per 10 levels (ROLES.<CLASS>); (4) Legacy en Kamperen bouwen.
- 🧪 **Nieuw hulpmiddel `run fcq_check`** (`tools/fcq_check.py` + `.lua`): laadt ForeverClassQuests.lua met nep-spelfuncties,
  loopt 9 classes × 10 rassen × levels 1-60 × alle queststanden, en checkt dat elke FCQ_-sleutel in enUS + nlNL staat.
  GEMETEN 17 nov: 149.941 runs, 0 fouten, 86 sleutels, controle OK. Bewijst dat de code draait, niet dat id's kloppen.
  Draai hem na elke class.

## 🌙 NACHTOPDRACHT 16→17 nov (Bouwchat 16-11 (2) sloot af met /nieuwe-chat bouw; sparring: akkoord)

Rob, letterlijk (via Sparring 16-11): *"kan je ook samen met bouw door gaan tot je mij nodig hebt, ik bedoel kunnen jullie
samen zo ver mogelijk komen evt ook met andere specs en classes, ook wat uitzoeken enzo betreft en als jullie dan samen
vast lopen dan pas afsluiten ?"* en op het plan: *"ja voor jullie om door te gaan"*. WoW is dicht.
- Druid is AF (stap 1 + 2 + puntjes), zie hieronder. Volgende: **stap 3 = de andere 8 classes, één voor één**:
  eerst hun class-quests in ForeverClassQuests.lua (warlock-demonen, warrior-stances, shaman-totems/elementen,
  rogue-poisons, hunter-pet, paladin, priest-racespells, mage), daarna per class de rollen per 10 levels in
  ForeverHowToPlay.lua `ROLES.<CLASS>` (zelfde vorm als DRUID; band = talentboom 1-3). Werkwijze per class zoals bij de
  druid: mh-research (gamedata/Spoken/Zygor/HandyNotes + Forever-gidsen; let op: Forever-talentboom ≠ classic, DB2
  TraitTree) → feitenbestand docs/forever/<CLASS>_…md → mh-writer en+nl → mh-writer de/fr/es/esMX/pt/ru → NPC_NAMES
  per taal meten. Startpunt quest-spells: `ns.FOREVER_QUEST_FIRST` in ForeverTrainer.lua.
- Regels vannacht: alleen main; NOOIT tag/release/CF/beta, niets verwijderen of archiveren. Na elk afgerond stuk: lint
  0 HARD, luac OK, commit + push, TESTLIJST/IDEEEN/NEXT_SESSION bij, en één korte regel naar «Sparring 16-11» (wat,
  commit). Keuze die echt van Rob is → lijst "Wacht op Rob" hieronder, en door met ander werk; kleine keuze met duidelijk
  advies zelf maken met "Rob mag dit omdraaien". Nooit twee helpers tegelijk op de voordeur (probe_job.txt), en niet
  parallel met de site-chat. Vastgelopen op alles wat over is → handoff bij, commit + push, en «Sparring 16-11» melden:
  "KLAAR VOOR DE NACHT" met de stand. Chat te lang → eerst sparring melden, dan /nieuwe-chat bouw.
- **Wacht op Rob:** (nog leeg)

## ▶ EERST voor de volgende bouwchat (Bouwchat 16-11 sloot af met /nieuwe-chat bouw; Rob via sparring: *"ja doe maar"*)

1. **Druid stap 1 afmaken** (`Modules/ForeverClassQuests.lua`). ✅ 16 nov, Bouwchat 16-11 (2): Cure Poison (14), Aquatic
   Form (16) en Torwa Pathfinder (50) GEBOUWD, plus blok "Your class quests" bovenaan How you play
   (ns.ForeverClassQuestOverview). ✅ Ook **Cat Form (20)** GEBOUWD: een NIEUWE Forever-keten die Zygor niet heeft
   (A 98393→98394→98396→98731→98397, H 98340→98405→98342→98739→98362; serie GEMETEN op Wowhead; gevers/inleveraars uit
   de addon Spoken = derde partij; plekken uit Wowhead-tooltips; volgorde relikwieën in de Barrow Dens = gids, AFGELEID).
   Skyborne-druids NIET (98341/98404/98738: twee schakels ongemeten). ✅ Vertalingen FCQ_* de/fr/es/pt/ru (mh-writer,
   item-/plaatsnamen GEMETEN in wago 70938; itIT bewust niet: Forever-itIT-client is Engels, zelfde als FDONOW_).
   NIET GEMETEN, Engels gebleven: "Great Cat Spirit Statue". 📌 Rob, 16 nov: *"spoken mag je als betrouwbaar aanzien"*.
   ✅ (nacht) NPC-namen per taal: `NPC_NAMES` in ForeverClassQuests.lua (14 NPC's × de/fr/es/esMX/pt/ru, GEMETEN in
   Wowhead-Forever-tooltips per locale + Spoken-naambestanden; controle npc 233; Gennia esES twijfel, Tajarri esMX
   onbekend → Engels). ✅ Skyborne-druid: eigen Bear Form (94006 → 94638, Zephras Isle 2521, Ur'endra-grot; Zygor) en Cat
   Form via de Avatar of Saeyleenan (98341 → 98404 → 98738; twee schakels AFGELEID-sterk). Ketens hebben nu `races`
   (NightElf/Tauren/Skyborne; Skyborne = race-id 95/96 GEMETEN in ChrRaces, token "Skyborne" AFGELEID). Cure Poison en
   Aquatic zonder ras-filter (racemaskers niet gemeten). FCQ_OBJ_URENDRA alleen en/nl (Ur'endra-naam per taal niet gemeten).
2. **Stap 2** (Rob via sparring: *"ja"*): ✅ druid GEBOUWD (en + nl), 16 nov. Feiten: `docs/forever/DRUID_ROLES_2026-11-16.md`
   (mh-research; grootste vondst: Forever-talentboom ≠ classic, staat in DB2 TraitTree 1089). Teksten: mh-writer, in
   ForeverHowToPlay.lua `ROLES.DRUID` (beer/kat band 2, Balance 1, Resto 3) + nlNL; rol(len) van je richting bovenaan
   How you play, de rest ingeklapt achter de knop "All roles" (FHOWTO_ROLES_*). Tegelijk 2 correcties in de oude
   druidtekst (Faerie Fire niet in Travel/Aquatic; Shred + Feral Charge op 20), alle 7 talen. Balance-volgorde: Starfire
   als opener vooraan gezet (bouwchat). ✅ ROLES + FHOWTO_ROLES_* vertaald de/fr/es/esMX/pt/ru (mh-writer; 55 spellnamen
   GEMETEN per locale; "perk", rolwoorden, "dungeon" eigen woordkeus; ptBR Swipe "Revés" (1 id zegt "Patada", niet
   nagezocht); pt-knop "Ver funções", es-knop "Todos los roles" 15 tekens — breedte NIET gezien). Ook: Cure Poison 8946
   in ns.FOREVER_QUEST_FIRST (trainerlijst zegt nu "van een class-quest").
3. **Stap 3:** de andere 8 classes op dezelfde manier (class-quests eerst).
4. ⚠️ Carola speelt mogelijk via CurseForge: dan ziet ze main pas na een release (Rob kiest wanneer). 5.4.0 is uit
   (16 nov); Bear Form (4faaaee) zit er NIET in.

## ▶ EERST op 16 nov (Rob via Sparring 15-11, letterlijk: *"Zet dit als eerste voor de lijst voor morgen en sluit de pc af
## en doe hem uit"*)

1. **Gat in de PTR/roadmap-wachter.** Wowhead (wowhead.com/ptr, /news) geeft al 22 dagen `CRAWL_EMPTY_CONTENT`; laatste
   eigen lezing 23 okt (`docs/PTR_12.1_WATCH.md`, regel 645, volgens sparring; NIET nagemeten door de bouwchat). Opdracht:
   zoek een andere manier om Wowhead te lezen, of meet dat de andere bronnen genoeg zijn. (Ter info: de speur-agenten van
   15 nov lazen Wowhead-nieuws wel via het web, zie `docs/patch_12_1_7/5_community.md`.)
2. Daarna: de rest van de 12.1.7-lijst (`docs/PATCH_12_1_7_DRAAIBOEK.md`, "2b-stand"); wo 18 nov = Midnight-dag (oude
   Midnight-testvinkjes in één lijst voor Rob + wekelijkse PTR-hermeting met `tools/patch_watch/`).

🔍 **16 nov, Bouwchat 16-11 (sessie heet "addons-4e"), punt 1 GEMETEN:** Wowhead's nieuws-RSS
`https://www.wowhead.com/news/rss/all` is gewoon leesbaar, óók met het wachter-gereedschap (Exa `web_fetch_exa`, met
`?nocache=`): nieuwste item 15 nov 13:00 (-0600), `lastBuildDate` 16 nov 00:52, 30 items, mét PTR/12.1.7-stukken (13 en
12 nov). Zelfde run: `/ptr/news` gaf `CRAWL_EMPTY_CONTENT`; `/news/rss/ptr` en `/news/rss/live` bestaan niet
(`CRAWL_NOT_FOUND`). De wachter vond vannacht zelf al een tweede weg voor de versieschakelaar (Exa-zoekindex, zonder
datum; `PTR_12.1_WATCH.md` regel 647). AFGELEID: een 12.2-PTR zou eerst als branch op wago.tools en als Wowhead-
nieuwsbericht verschijnen; de schakelaar zelf is dus niet nodig. Voorstel naar Sparring 16-11: RSS-regel in de
routine-prompt van de PTR-wachter (`trig_018jpghYW8vRpDsj9qkWWD8f`); routine NIET aangepast (wacht op Robs ja).
Ochtendronde 16 nov (GEMETEN): pull a478c3c → a9723ee (alleen wachters + regie). CF 0 open (8), GitHub 0. addon_updates:
geen 🔔; o.a. HandyNotes_WoWForever v4 (alle oude rares; MH heeft geen Forever-rares), HandyNotes_ClassTrainers 1.1.0,
TalentsForeverBook 0.38.27 (gelezen, niet getest). HandyNotes_Midnight 171, geen wijziging. Zygor Midnight geen
wijziging; Forever 6 bestanden (nieuwe quests/trainer-questid's, nog niet naast MH gelegd). Site-mail 0, BOUW_VRAAG
Open (geen), Notion: dezelfde 4 regels van 12 nov. Wachters: alleen de bekende [MOET GEFIKST] (Self Cast Key, nu ook
`RetailTopMacros.lua`).
🧹 12.1.7 2b: lint [18] kent nu de `_1217`-keys (`tools/lint_addon.py`, `_patch_variant_live`). GEMETEN met tegenproef
(git stash): 1440 → 1436 ongebruikt, 0 HARD. Wat van 2b over is, kan pas op patchdag (4-data, 5, 7, 8, 9).
⚠️ PTR-wachter + RSS: NIET gelukt. `update_trigger` weigerde ("created via http_api … Agents can only update routines
they created"). Rob ja'de via sparring (*"Doe maar A"*); de regel om te plakken staat bij Sparring 16-11, Rob plakt hem
zelf op claude.ai/code/routines/trig_018jpghYW8vRpDsj9qkWWD8f. Morgen in PTR_12.1_WATCH.md kijken of hij de feed leest.
🧩 Forever "Screens" opgeschoond (Rob via sparring: *"beide ja"*): `ns.GetHideableScreens` (UI.lua) volgt in Forever de
zijbalkregel (SidebarTabAvailable); Toolbox-subschermen alleen als hun bouwer geladen is. Retail ongewijzigd.
📷 Schakelaar "Camera verder weg" (zelfde ja): `Modules/CameraZoom.lua` (beide toc's), vinkje `mh_cameraFar` in
SettingsDefs (niet in Aanbevolen), `/mh camera [on|off]` (status + leeswaarde na zetten). Aan = retail 2.6 / Forever 4,
uit = oude waarde (`ns.db.cameraFarOld`, anders de CVar-default). Nooit in combat (wacht op PLAYER_REGEN_ENABLED); bij
login opnieuw gezet als iets anders hem veranderde. Teksten en/nl zelf, de/fr/es/pt/it/ru door mh-writer. Of Forever 4
echt houdt: NIET gemeten (Robs /run-test in TESTLIJST 16 nov). Beide NIET in het spel gezien. Commit ca38d1a.
🧪 Robs Forever-test 16 nov (via sparring, GEMETEN op zijn scherm): Focus Cast Key = None, Self Cast = "Auto and Key
Press", Self Cast Key = ALT → Shift botst bij Rob nergens mee (API-wachter [MOET GEFIKST]: voor zijn pc dicht; Midnight
niet gezien; andere spelers kunnen anders staan). Screens: Midnight-schermen weg (goed); over waren "TAB_CODEX: Basics"
en "Pop-out windows" (dat laatste hoort erbij: ToolsLaunchpad laadt in Forever). Dungeonlijst werkt zoals TESTLIJST
15 nov zegt; Rob vinkt zelf af.
🧩 Daarop (Rob via sparring: *"ja doe maar"*): a) Basics-schakelaar niet in Forever (NativeSettings.lua +
SettingsPage.lua). d) Kaartje "Dungeons in Forever" in de kamer Me (RoomLauncher ME_FOREVER_CARDS; icoon
Achievement_Dungeon_ClassicDungeonMaster, GEMETEN in Forever-ManifestInterfaceData 70938; tekst TOOLLP_FDUNG_DESC).
c) [mod:alt] tegen Self Cast Key = ALT: AFGELEID geen last, NIET gemeten (test in TESTLIJST). b) Instellingenlijst voor
Forever (mh-research): 22 werkt / 63 doen niets / 11 weet niet; naar sparring met advies "verberg de 63", ⏳ wacht op
Robs keuze. Ook gezien: PickupUpgrade.lua heeft geen schakelaar op de instellingenpagina. (a+d: commit 2005da7.)
🧹 Rob koos (via sparring, letterlijk *"a en ja"*): in Forever 63 instellingen weg (SettingsDefs.lua FOREVER_HIDDEN +
DropForForever in ns.GetSettingsDefs; lege koppen gaan mee: Dungeon help, Vault). Alle 63 namen GEMETEN in het bestand
(58 via Toggle/Slider/Dropdown-grep, de 5 Vault-regels 717-721 apart). De 11 "weet niet" blijven tot Robs test
(TESTLIJST 16 nov avond). Forever-schakelaar `mh_pickupUpgrade` (SET_PICKUP_*) onder Gear, op de plek van de tooltip-regel.
Self Cast Key-waarschuwing: `ns.SelfCastMacroWarning` (Core.lua), in ForeverMacros.lua én RetailTopMacros.lua (keuze
bouwchat: ook retail, want de bug is van 9.2.5; de regel toont alleen bij [mod…] + @mouseover/@focus/@cursor ÉN een Self
Cast Key ≠ NONE via GetModifiedClick("SELFCAST"); dat die API in beide clients bestaat = AFGELEID, pcall-bewaakt).
Retail ongewijzigd behalve die waarschuwing. NIET in het spel gezien.
⚠️ Tekst-correctie (mh-writer, GEMETEN in wow-ui-source live: SELFCAST heeft `mustChooseKey = true`): de lijst "Self Cast
Key" heeft GEEN "None". De waarschuwing zegt nu "zet Self Cast op Auto of None" (SELF_CAST / SELF_CAST_AUTO / NONE,
GlobalStrings 50436/50437/15442, ook Forever 70938; enUS "Auto and Key Press" = wat Rob zag, positieve controle). Of
"Auto" de toets echt wist: NIET gemeten; de gele regel zelf is de test (TESTLIJST 16 nov avond).
🗡️ Forever: stenen/oils/poisons op de buffknop (Rob via sparring: *"kunnen we daar ook een waarschuwing voor krijgen …"*,
*"alles :)"*). ForeverBuffs.lua: WEAPON_ITEMS (ids/levels/wapenmaskers GEMETEN, mh-research, wago wowf 70938),
PickWeaponItem per hand (16/17), TempEnchant(slot) = C_Item.GetWeaponEnchantInfo eerst, oude globale als terugval,
nil = stil (ook de Shaman-imbue gebruikt die nu; de globale is in Forever alleen een deprecation-shim achter een CVar).
MissingBuff.lua: item-tak in ApplySecureCast (type=item, item=item:<id>, target-slot), ns.MissingBuffKey (spell of
item+slot) voor verversen/vergelijken, tooltip SetItemByID, MBUFF_SAY_CLICK_ITEM; in Forever ook BAG_UPDATE_DELAYED en
WEAPON_ENCHANT_CHANGED (pcall). `/mh buffs` print per hand type, enchant en beslissing. NIET gemeten: of target-slot in
het spel werkt, welke enchant-API Forever heeft (Robs /run in TESTLIJST 16 nov laat), of steen + poison samen op één
wapen kunnen. Keuzes: Shaman-spell eerst; beste rang eerst; rogue: poisons vóór stenen.
✅ Robs test (via sparring, GEMETEN op zijn screenshots): in Forever bestaan GetWeaponEnchantInfo (CVar
loadDeprecationFallbacks = 1) én C_Item.GetWeaponEnchantInfo; mace → geen steen; zwaard → Rough Sharpening Stone met de
juiste zin, en *"de knop werkt"* = target-slot werkt in het spel. Rest (knop weg na klik, /mh buffs, rogue, shaman,
weightstone) nog niet gezien.
✅ Later (Rob via sparring: *"ja gevonden en werkt :)"*, *"1 t/5 werken goed"*): in Forever werken camera (houdt 4),
Screens + opgeruimde opties, kaartje Dungeons, de Self Cast-regel (weg met "Auto": AFGELEID uit "goed") en de
wapensteen (knop weg na klik; terug na 30 min: AFGELEID uit "goed"). Daarmee is "Auto wist de Self Cast Key" waarschijnlijk
beantwoord. Midnight-kant niet gezien.
✅ GEEN open punt meer: de 11 "weet niet"-schakelaars in Forever blijven staan, niets verbergen. Rob (via sparring,
letterlijk): *"laat deze tests maar achterwege, mocht iemand het melden dan is het vroeg genoeg"*. Alleen bij een
spelersmelding opnieuw bekijken. (Handoff gesplitst op 16 nov: knip bij "10 nov (avond)", 201 regels naar het archief.)
🧺 Zes kleine ideeën (Rob via sparring: *"allemaal"*): 4 Dock-botsing toetsenblok (modeBtn -120 → -150, KeyBlock.lua) en
5 doorschijnend gids-paneel (dichte BACKGROUND-laag) en 6 "Je bent 90" (`Modules/MaxLevelWelcome.lua`, alleen retail-toc,
StaticPopup zoals FirstRun, één keer per character-GUID bij PLAYER_LEVEL_UP naar GetMaxLevelForPlayerExpansion, wacht op
einde gevecht; `/mh maxlevel [popup]`) GEBOUWD, NIET in het spel gezien. 1-3 (Forever: spell op geen balk; tooltip "niet
meer nodig"; tooltip "quest-item") GEMETEN door mh-research (details in IDEEEN "Zes kleine ideeën"): 2a en 2c vallen af,
2b bouwbaar; 1 en 3 wachten op Robs drie /run-tests (TESTLIJST 16 nov nacht). Bouwadvies + aanhaakpunten in het
rapport: 1 → ForeverDoNow.lua Collect() + ns.ForeverSpellOnAnyBar in ForeverRanks (alle ranks, ook macro's); 2b/3 →
de item-tooltiphook ReagentUse.lua:117-142 (achter ns.IS_FOREVER), class-mask uit SkillRaceClassInfo, ForeverWeapons
WEAPONS exporteren; diagnose /mh usedfor en /mh questscan uitbreiden.
🧪 Test 2 GEMETEN (Rob, Engelse client): GetQuestObjectives geeft type "item" + tekst "0/N <itemnaam>" (naam schoon
achter de teller) → idee 3 kan op naam matchen (in andere talen kan de volgorde anders zijn: niet gezien, match daarom
"naam staat in de tekst", niet "tekst begint met teller").
🧪 Test 3 GEMETEN (Rob): Blizzards tooltip zegt alleen "Quest Item", niet welke quest. Een leverquest (Johaan's
Findings) heeft geen item-doel; de naam staat in het "log"-doel, met andere hoofdletters. KEUZE bouwchat voor idee 3:
de itemnaam HOOFDLETTERONGEVOELIG zoeken in ÁLLE doelteksten van je log (item, log, …); teller "n/m" alleen bij type
"item"; geen treffer = geen regel. Bijvangst: in Forever is kale GetItemInfoInstant nil (AFGELEID uit Robs fout);
GEMETEN dat MH hem in Forever-bestanden nooit kaal aanroept (overal C_Item eerst; grep, tegencontrole 20 treffers).
🧪 Test 1 GEMETEN (Rob, mage): "LEARNED_SPELL_IN_SKILL_LINE 1459 Arcane Intellect false" bij de trainer; zijn
toetsenblok zette hem zelf op Shift X. Nieuwe RANK niet getest. Bijvangst: de addon MagePlan zegt al "New spell that
isn't on any button" (licentie niet gemeten) → keuze voor Rob of MH dan zwijgt.
✅ 1-3 GEBOUWD (alleen op main, NIET in het spel gezien): ForeverDoNow.lua (NewSpells per GUID, OnAnyBar = zelfde naam
in slot 1-180 als spell of macro, zwijgt bij KeyBlockActive, regel in /mh donow check) + `Modules/ForeverItemTips.lua`
(Camelot-toc; eigen TooltipDataProcessor-hook; class-masks uit SkillRaceClassInfo 70938 + ForeverWeapons; quest-match;
uitleg in /mh usedfor). Teksten en/nl zelf, de/fr/es/pt/ru door mh-writer. Commit 2c76b8f.
🖱️ Rob: *"mouse over werk, en zet de andere ook maar op de lijst"*: MO_HELP + Blessing of Might/Kings/Wisdom/Sacrifice,
de drie Greater-versies (GEMETEN in FOREVER_SPELL_IDS; Salvation/Light/Sanctuary staan daar niet in) en Arcane
Brilliance. De pair-tak in BodyRaw riep WithMouseover nooit aan → nu wel (pair-toetsen = paladin-blessings, [group]).
255-grens via Body() blijft. MagePlan: MH blijft melden (Rob). NIET in het spel gezien. Commit 154c478.
🎆 Vuurwerk bij level-up (Rob via sparring: *"ja dat wil ik, dat vuurwerk, evt met geluid 🙂"*): `Modules/LevelUpFireworks.lua`
(beide toc's), 3 bursts × 12 sterren (Interface\Cooldown\star4, GEMETEN Forever FileDataID 131010), geen muis; geluid
SOUNDKIT.UI_EPICLOOT_TOAST 31578 (GEMETEN in SoundKitConstants forever-branch; SoundKitName-DB2 geeft HTTP 400 bij wago,
dus geen naamzoektocht). Gevecht = wachten max 60 s; `/mh fireworks [test|on|off]`. Midnight 90: popup komt 3 s later,
dus na het vuurwerk. Commit 2cf86a4. ✅ Rob: *"firework werkt maar het geluid is een tik … geluid is niet nodig en mag
weg"* → geluid, schakelaar mh_levelUpFireworksSound, `sound on|off` en SET_FIREWORKS_SOUND_* (7 talen) verwijderd.
Commit a114fa6.
📊 Stats-regel "Do this now" (Rob: *"b , maar hou ook dps en heling in je achterhoofd"*): onderzocht →
`docs/forever/STATS_PER_ROL_2026-11-16.md` (tabel per class/rol, bronnen, botsingen met ForeverMainStats, rol-detectie).
4 keuzes naar sparring → Rob: *"alle 4 ja"* → GEBOUWD: ns.ForeverStatDef/ForeverTankStatDef (ForeverMainStats.lua; rol =
class × richting, BY_TREE; boomvolgorde AFGELEID), ForeverQuestHint leest hem (MainFor zet main.equal → Score weegt 2e stat
1), ForeverDoNow StatLines als tips + regel in /mh donow check. Commit 867d325. ✅ Rob (3 chars, screenshots): Paladin
2 = Protection, Mage 2 = Fire, Shaman 1 = Elemental → boomvolgorde klopt daar (GEMETEN); andere classes nog niet gezien.
🐞 Pickup-melding bij gecrafte items (Rob: "geen melding … maar ook niets in de chat bij die check"; /mh pickup toonde
alleen "[Skinning Knife]: not better"). Oorzaak NIET gemeten: `last` = één beslissing, kan overschreven zijn. Gebouwd:
PickupUpgrade.lua `history` (laatste 10, met tijd; elke toename in de tas, ook "not gear", "vendor open", "you wore it")
in `/mh pickup`. Test voor Rob in TESTLIJST. Kandidaten (AFGELEID): BAG_UPDATE_DELAYED vuurt niet bij craften; of
ForeverGearTipText zegt "not better"/"red line"; uitslag bepaalt de echte reparatie. Commit c25686b.
✅ Uitslag Rob: gecrafte Handstitched Leather Pants → melding + pop-up ("shown"). Craften wordt gezien (GEMETEN); geen
reparatie nodig. Lijst "last 10" print pas bij ≥ 2 regels (`#history > 1`), daarom zag Rob alleen "last item".
📷 Camera-fout (Robs Midnight-test): SetCameraFar onthield de oude waarde niet als die al gelijk was aan het doel (2.6,
Details) → "uit" zou Blizzards 1.9 zetten. Nu altijd onthouden; status toont bij "uit" de huidige waarde; `Num()` → "1.9".
"You are 90" ✅ (Rob). "New in this version" test Rob met /mh new. Commit 56ab593.
🚀 RELEASE 5.4.0 KLAARGEZET (Rob via Sparring 16-11, letterlijk: *"go"*; afspraak: tag pas na zijn ok op de
spelerstekst). toc's 5.4.0, Changelog.lua + CHANGELOG_540_1..6 (enUS), RELEASE_NOTES.md = docs/CURSEFORGE_5.4.0.md
(cmp: gelijk), CHANGELOG.md. Lint 0 HARD ([27] schoon), luac OK.
✅ 5.4.0 UITGEBRACHT. Rob op de tekst: *"laat de bouwchat hem maar aanpassen"* → camera-zin "further than the game's
default" (b23e0ec), tag v5.4.0 gepusht. Run 43943568777 geslaagd; log: CF/Wago/GitHub "Success!" voor beide zips.
CF-API (GEMETEN): Retail 9653805 en Forever 9653822, beide status 4 (Retail verscheen pas later in de openbare lijst;
Rob: *"beide staan live"*). SITE_SEIN: alle 15 regels → "staat op CurseForge (v5.4.0)". Site-chat: site live op 5.4.0
(commit 2640445f, 8 talen, check_addon_words 0 fouten). Ter info van de site-chat: CODEX_TT6/LOREWALK hebben nog geen
dag in hun PATCH_DAYS (12.1.7-datum onbekend) → blijven daar verborgen. SITE_SEIN: 15 regels "getagd (v5.4.0)" + release-regel
"staat op CurseForge"; sparring seint de site-chat. Niet blokkerend open: rank-test op lvl 6. ✅ `/mh camera` na aan/uit:
"now 2.6 … back to 2.6" (Rob, screenshot, 5.4.0) → reparatie werkt.
🐻 Class-quests per class (Rob via sparring: *"… Maar begin inderdaad met de Druid …"*, zie IDEEEN). STAP 1 deels GEBOUWD:
`Modules/ForeverClassQuests.lua` (beide toc's, stopt in retail) met de Bear Form-keten A (5923→5921→5929→5931→6001) en
H (5928→5922→5930→5932→6002) uit de Forever-Zygor (GEMETEN in het gidsbestand; coördinaten Zygor; UiMap-id's GEMETEN in
wago 70938). Regel + knop "Show the way" in "Do this now" (QUEST_LOG_UPDATE erbij), `/mh classquest [go]`. NPC-namen
Engels. NIET in het spel gezien. Bear Form-tekst ging eerst als platte tekst via sparring naar Carola (met correctie:
Denatharion staat in Darnassus 34.8, 7.4, niet in Dolanaar). Open stap 1: Cure Poison (14, quests 6121-6125), Aquatic Form
(16, vanaf quest 26 "A Lesson to Learn"), Cat Form/verder (meten), "How you play"-weergave, vertalingen FCQ_*. Stap 2 en 3:
nog niets. ⚠️ Voordeur: helpers zagen twee keer een vreemde beroepen-job in
`probe_job.txt` (zie hoger); herkomst nog niet nagezocht. Test 1 en 3 doet Rob later. Afspraak (sparring, tot Rob
anders zegt): 1-3 SAMEN bouwen na die tests. Ook later van Rob: `/mh pickup` gaf geen melding bij GESMEDE items
(nog niet uitgezocht; AFGELEID: misschien omdat craften als "bag update terwijl een venster open is" telt) en zijn keuze
voor de stats-regel.
🐻 16 nov, Bouwchat 16-11 (2): druid-ketens uitgebreid (ForeverClassQuests.lua). GEMETEN door mh-research (Wowhead
Forever + wago 70938): 6125/6130 leren Cure Poison 8946 (quest, AFGELEID niet bij de trainer); 5061/31 leren Aquatic Form
1066 (+ Aquarius Belt, Idol of Shifting Tides); 9053 = keuze Forest's Embrace / Grizzled Pelt / Moonshadow Stave (min.
level 50 volgens fan-databases); Travel Form 783 = trainer 30; Teleport: Moonglade 18960 = level 10; alle 9 UiMap-id's
GEMETEN. Nieuw in de code: `alt` (andere startquests 5924/5925, 5926/5927 — Wowhead-serie), `objs` per quest (doel-index
uit GetQuestObjectives of "item in je tassen"; index-volgorde = Wowhead + Zygor, gelijk aan de client = AFGELEID), ketens
gesorteerd op level, Moonglade-tip als je de teleport kent, Earthroot-stap zonder plek (knop print alleen de regel).
Coördinaten = Zygor. Teksten en/nl zelf; de/fr/es/pt/it/ru nog niet. NIET in het spel gezien. Lint 0 HARD, luac OK.
📦 Release: sparring adviseert Rob een release NA woensdag (Midnight-dag), als camera (2,6), de gele Self Cast-regel en
"New in this version" in Midnight goed zijn. Rob gaf nog GEEN go.
⚠️ Voordeur: een helper zag `probe_job.txt` overschreven met de beroepen-job van een andere sessie en draaide die (alleen
lezen). Herkomst NIET nagezocht; mogelijk weer [[probe-job-crosses-sessions]]. Morgen naar kijken.

Stand bij het afsluiten (15 nov): alles op main en gepusht, niets uitgebracht (5.3.0 staat op CurseForge). Alle
toestemmingen liepen zonder weigering.

## ▶ 15 nov (Bouwchat 15-11, ingang; neemt het over van Bouwchat 14-11)

📌 Ochtendronde (GEMETEN tenzij anders): git schoon, pull 2f4d78e → 87ed12b (wachters + regie + ideeënbus). CF-reacties
0 open (8 draadjes), GitHub 0 issues/PR's. addon_updates: geen 🔔; 23 retail- en 8 Forever-addons bijgewerkt, niets
dat MH raakt (gelezen, niet getest). HandyNotes_Midnight 171, geen zonewijziging. Zygor: "baseline recorded" voor
Midnight (9.6, 717) én Forever (1.6, 104) = vandaag GEEN vergelijking mogelijk; morgen wel (waarom de oude snapshot
niet gebruikt werd: NIET gemeten). BOUW_VRAAG: Open (geen). Site-mail en Notion: door de cloud-chat gedaan (0 mail;
inbak dezelfde 4 regels van 12 nov), niet overgedaan.
🏰 HandyNotes_DungeonRaidLocations-Forever 1.01 → 1.02 (gezien via addon_updates): heeft nu Krol'dok, Alcaz, Blackmaw
en Shaper's Terrace, en de Stockade-ingang staat op 50.3, 66.1 (was 39.6, 53.9). Overgenomen in
`Modules/ForeverDungeons.lua` (coördinaat-regel: HandyNotes > web); `web = true` op geen rij meer, dus geen `*`. Levels
van 1.02 wijken soms af (bv. Alcaz 48-53 vs onze 48-55): de onze komen uit DB2 en blijven. Licentie nagekeken (MIT,
Pirson). Lint 0 HARD; NIET in het spel gezien (TESTLIJST 14 nov laat, Stockade-regel). 1.02 heeft ook namen per taal
voor Krol'dok/Shaper's/Drowned City: géén Blizzard-meting, dus niet overgenomen.
📝 SITE_SEIN: regel voor het Horde/Alliance-embleem (43d4e76) nagetekend, de regie zag hem ontbreken. `/mh partytest`
heeft nog steeds geen regel (regie; niet nagekeken of het een spelersfunctie is).
🔴 API-wachter [MOET GEFIKST]: Forever Focus/Self Cast Key-modifier kan onze `[mod:shift]`-macro's stil laten falen
(61× in ForeverMacros.lua, GEMETEN; bron = spelers, geen blue). Voorstel naar Sparring 15-11: Rob kijkt eerst 10 s in
Forever → Options → Keybindings wat er op Focus Cast Key / Self Cast Key staat; daarna een waarschuwingsregel of een
check met `GetModifiedClick("FOCUSCAST")`. Niets gebouwd.
🔎 Nachtcontrole C2 "28 nakijken": allemaal `map =` in ForeverDungeons.lua = instantie-id's (DB2 Map), geen UiMap-id's
(GEMETEN: het commentaar bovenaan de module zegt dat, en HandyNotes noemt ze `instanceID`). Dus loos alarm van de
checker. ✅ Bouwchat 15-11 (na de herstart): `tools/data_check.py` kent nu soort "instance" (DB2 Map) via
`MAP_IS_INSTANCE`; `map =` in ForeverDungeons.lua gaat daarheen, en de run drukt die regel af. GEMETEN: `run data_check
--c2` → map 72 / instance 28, 0 nakijken, controle Map 1 OK in live/ptr/forever. SelftestData.lua opnieuw geschreven
(--emit); `/mh selftest` telt instance alleen (GetMapInfo = UiMap, verkeerde tabel). Lint 0 HARD.
🌐 Vertaalpunt 2 + Mythic+ es/pt/it AF (alleen op main; Rob via Sparring 15-11, doorgestuurd door addons-67,
letterlijk: *"Ja, dit open vragen toetsenmenu. Over de naam uit het spel gebruiken. Met de plus in het Spaans, Portugees,
Italiaans ook het woord uit hun spel opzoeken en gebruiken."*). Toetsenmenu naar de clientnaam (de Tastaturbelegung, it
Assegnazione tasti, es Atajos de teclado, pt Atalhos do teclado; esMX-client zegt kaal "Atajos", GEMETEN → eigen
regels in esMX.lua). Mythic+ GEMETEN (GlobalStrings 50146, 12.1.5.70783): esES Mítica+, esMX/ptBR Mítico+, itIT
Mitica+; ±300 plekken. Details in IDEEEN ("Waarnemingen 14 nov", onderaan). Proef met de packs per client geladen:
alleen CHANGELOG_* zegt nog "Mythic+". luac 366 OK, lint 0 HARD (2 dode itIT-fills opgeruimd), check_drift: alleen de
2 oude keys. NIET in het spel gezien (TESTLIJST 15 nov later). ✅ CLAUDE.md aangepast (Rob rechtstreeks in de bouwchat: *"Ja, pas
Claude.md aan met de plus en alle andere vaste spelnamen, krijg je in elke taal de naam uit het spel."*): de regel
"Game terms … stay WoW UI spelling" is nu "het woord van die client". Open, wacht op een opdracht: de nog Engelse
speltermen in de packs (telling naar Sparring 15-11: Tier, Dungeon, Raid, Vault, Normal/Heroic/Mythic, KP, ilvl,
Key(s), Season, Renown in fr/es/pt; client-woorden per term NOG NIET gemeten).
Bij de volgende release: changelog-regel "vertalingen".
🌐 Speltermen groep 1 (Renown, Raid, Vault, Dungeon) AF, alleen op main. Rob via Sparring 15-11, letterlijk: *"Ik heb die
opdracht al doorgegeven en doe inderdaad optie A maar. Dan werk zoveel mogelijk door."* GEMETEN (GlobalStrings
12.1.5.70783): Renown = Ruhm/Renom/Renombre/Reconocimiento (esMX)/Renome/Fama/Известность; Raid = Schlachtzug/Raid (fr =
Engels)/Banda/Raide/Incursione/Рейд; Great Vault = Große Schatzkammer/grande chambre forte/Gran cámara/Gran bóveda
(esMX)/Grande Cofre/Gran Banca/Великое хранилище; Dungeon = Dungeon (de = Engels)/donjon/mazmorra/calabozo
(esMX)/masmorra/spedizione/подземелье. mh-writer herschreef 355 stukjes (267 keys, 8 nieuwe esMX-regels); script zette ze
alleen in het eigen taalblok. Over (73 rijen) = eigennamen: "Dungeon Coach" (MH-naam), HandyNotes-addonnaam, "Follower
Dungeon", quest "Midnight: Dungeons", "Dungeon Waystones", Codex-categorieën in CODEX_START_BODY, de FPS_HEADER-kolom
"Raid". Open: die Blizzard-namen meten. it-tab heet nu "Scorribande & Gran Banca" (breedte niet gezien). luac OK, lint 0
HARD, drift ongewijzigd. Werkbestanden in de scratchpad van deze sessie (g1*.tsv, apply.py). Volgende: groep 2
(Normal/Heroic/Mythic, Season, Key/Keystone, ilvl), dan KP, Tier, Shards, Crests, LFR, PvP, Timewalking.
🌐 Speltermen groep 2 (Heroic/Mythic/Normal, Season, Keystone/Key, ilvl) AF, alleen op main. GEMETEN (GlobalStrings
12.1.5.70783): Heroic = Heroisch/Héroïque/Heroica/Heroico (esMX, pt)/Eroica/Героический; Mythic = Mythisch/Mythique/
Mítica/Mítico/Mitica/Эпохальный; Normal = alleen it Normale, ru Обычный; Season = Saison/saison/temporada/**Série**
(ptBR!)/stagione/сезон; Keystone = Schlüsselstein/Clé/piedra angular/pedra-chave/Chiave del Potere/Ключ; ilvl =
Gegenstandsstufe/niveau d'objet/nivel de objeto/nível de item/livello oggetto/уровень предмета (afkorting St./NivO/Niv/
Nvl/LivOg). 508 stukjes in 316 keys, 25 nieuwe esMX-regels. apply.py kent nu ook `["KEY"] =`, één-regel-fills en
`local DE = ns._mhLocales.deDE and {`. Over (138 rijen, twijfel): "Keys" = Coffer Keys (de/it; Restaurierter
Kastenschlüssel enz. zijn al gemeten, 11 okt), "Heroic World Tier", "Mythic Keystones", "Current Season Maximum",
"Keystone Myth", "Resilient Keystones" (niet gemeten). Ook gezien: ptBR zegt nog vaak "temporada" (moet "Série"), en
fr/it "vault" in CODEX_MPLUS_BODY + VAULT_ADVISOR_HINT_*. luac OK, lint 0 HARD, drift ongewijzigd.
📅 Werkafspraak (Rob via sparring: *"Ja, pak de woensdag maar voor de midnight."*): elke woensdag = Midnight-dag, eerste
wo 18 nov. Nieuw voor de bouwchat (Rob: *"Doe ze allemaal maar."*), na de speltermen: Forever-vragenlijst (addon-kant),
12.1.7/Season 3-plan, Midnight-controle. Downloadcijfers al gemeten (sinds 5.0.1: Midnight 1875, Forever 94). Zie IDEEEN.
📝 Forever-vragenlijst, addon-kant GEBOUWD (alleen op main): `Modules/ForeverSurvey.lua` (in beide toc's, stopt in
retail). Pop-up één keer per installatie, pas op de 2e dag dat MH in Forever draait (Forever heeft geen milestones),
60 s na login, niet in combat/instance; "No thanks" = nooit meer; `/mh survey` (+ `why`, `popup`) geeft altijd de link.
Link per taal (site-chat bevestigde): midnighthelper.com/<taal>/survey/forever/?from=game (en zonder taal; nl/de/fr/es/
pt/ru; geen it). Keys FSURVEY_URL/_POPUP_TEXT/_COPY_TITLE in en/nl/de/fr/es/pt/ru (onze vertaling). luac OK, lint 0
HARD. NIET in het spel gezien (TESTLIJST 15 nov middag). SITE_SEIN/changelog bij de volgende release.
🌐 Speltermen groep 3 AF (alleen op main): delve-Tier, KP, Crests, Coffer Keys/Shards, LFR, Timewalking, PvP, vault,
ptBR temporada → Série. GEMETEN: delve-tier = Stufe/niveau/nivel/grau/grado/уровень (DELVES_* GlobalStrings); KP = Wissen/
points de savoir/conocimiento/conhecimento/conoscenza/знания (PROFESSIONS_SPECIALIZATION_*); Coffer Key/Shards =
CurrencyTypes 3028/3310; LFR = PLAYER_DIFFICULTY3; PvP = JcJ/JxJ (fr/es/pt). Crests: de S2-munt heet Mistcrest
(CurrencyTypes 3437-3446: Nebelwappen / écu de brume / blasón de bruma / esMX niebloemblema / brasão brumoso / emblema
della Nebbia), S1 = Dawncrest; de schrijvers gebruikten alleen het basiswoord (Wappen/écus/blasones/brasões/emblemi),
GEMETEN in de edits: geen S1-namen. 989 stukjes in 682 keys (de/fr 433, es/esMX/pt/it 956), 35 nieuwe esMX-regels.
Twijfel, NIET aangeraakt: Tier van Ritual Sites, tier set, crest-rang, Heroic World Tier, fr LFR (client toont "Raids"),
esMX-crests (client: "emblemas"; nu erft esMX "blasones" van esES op een paar plekken), MH-tabnamen "Crests", "keys" in
CODEX_START_BODY, ongemeten eigennamen. es/esMX "nivel" = nu zowel delve-tier als level (clientwoord, kan verwarren).
luac OK, lint 0 HARD, drift ongewijzigd. NIET in het spel gezien.
🔭 12.1.7-onderzoek (mh-research): `docs/PATCH_12_1_7_PTR_2026-11-15.md`. Kort: PTR 70892; geen datum van Blizzard, maar
de PTR-tabel Holidays zet Turbulent Timeways VI op di 1 / wo 2 dec 2026 → 12.1.7 waarschijnlijk dan (AFGELEID). GEEN Season
3 in 12.1.7 (S3 komt kort na 12.2 Eclipse). Timeways vraagt nu 4 weken (GEMETEN, CriteriaTree 235236). Aqir Invasions weg
op de PTR. Klein en zeker GEDAAN: CODEX_TT6_BODY in 9 talen naar "4 weken" (check_drift --mark), commentaar
MountProgress.lua en EditModeBackup.lua (systeem 26 = MainActionBarEndCap ook in retail 12.1.7). Voorstel, NIET gedaan:
build bij Edit Mode-kopieën opslaan (risico: 12.1.5-kopie op 12.1.7 → LossOfControl op de griffioenen, AFGELEID),
maxInterface in het Codex-filter (Aqir-artikel), en het grote werk op launch-dag (Aqir, Talebound-bron, Folio 6-7,
Timeways-dungeons, S3-dungeons later).
🌐 Speltermen groep 4 (twijfelgevallen) AF, alleen op main (sparring: "meet ze en vervang wat zeker is", binnen Robs
"doe inderdaad optie A maar"). GEMETEN: Ritual Site-tier = zelfde woord als delve (GREAT_VAULT_WORLD_TIER "Stufe %s" /
"Niveau %s" / "Nivel %s" / "Grau %s" / "Grado %s"); Heroic World Tier = Heroische Weltstufe / niveau du monde Héroïque /
nivel de mundo Heroica / Grau Mundial Heroico / Livello del Mondo Eroica / Героический уровень мира (WORLD_TIER_HEROIC +
PARTY_PLAYER_DIFFERENT_WORLD_TIER); esMX crests = emblema(s); MH-tab "Crests" (CODEX_CUR_DAWN_TITLE,
PROFGUIDE_SUB_DAWNCREST) toont nu Wappen/Écus/Blasones/Emblemas/Brasões/Emblemi/Гербы (GEMETEN met de packs geladen
per client). 194 stukjes in 114 keys, 15 nieuwe esMX-regels; esMX SMC_SEARCH_CREST_EXCHANGE bewust NIET (zoekwoorden).
Fr "palier" → "niveau" (één woord, zoals het spel). Over: tier set, crest-rang, "Normal oder Heroic am Portal",
"Ritual-Site" (de: Ritualstätte, GEMETEN RITUAL_SITE_LABEL, nog niet vervangen), fr LFR (vraag bij Rob via sparring:
advies laten staan). luac OK, lint 0 HARD.
🛠️ 12.1.7 A + B GEBOUWD (alleen op main; sparring: "eerst A en B van 12.1.7", binnen Robs "Doe ze allemaal maar"):
A. EditModeBackup.lua: elke back-up (`iface`) en elke toetsenblok-kopie (`ns.db.keyBlockLayoutSavedIface`) bewaart het
interfacenummer; terugzetten op een ander nummer weigert met EDITMODE_OTHER_BUILD_FMT (reden in chat + Setup-zin). Oude
kopieën zonder nummer: geweigerd op retail ≥ 120107, toegestaan in Forever. Teksten in en/nl/de/fr/es/esMX/pt/it/ru;
"Edit Mode" per taal GEMETEN (HUD_EDIT_MODE_MENU: Bearbeitungsmodus / Mode Édition / Modo edición / esMX Modo de edición /
Modo de edição / Modalità modifica; ru "Настройка интерфейса" = HUD_EDIT_MODE_TITLE). B. MidnightCodexData.lua:
`maxInterface` in het filter; het Aqir-artikel heeft maxInterface = 120105 → weg op een 12.1.7-client. luac OK, lint 0 HARD.
NIET in het spel gezien. 🇫🇷 Rob koos (via sparring, letterlijk *"Haha a"*): frFR "LFR" blijft, uitzondering vastgelegd
bovenaan docs/CLIENT_NAMES_2026-10-20.md. Volgende in de rij: Forever XP-waarschuwing 12 levels (Rob: *"Ja, op 12
levels, waarschuwing achterin."*), zie IDEEEN.
🎯 Forever XP-waarschuwing (12 levels) GEBOUWD, alleen op main (Rob via sparring: *"Ja, op 12 levels, waarschuwing
achterin."*). Regel GEMETEN (mh-research, Kaivax us 2416343, 15 nov 01:18 UTC, post nooit bewerkt): in een dungeon
krijgt niemand XP voor een vijand als een groepslid MEER DAN 12 levels hoger is (12 = nog XP); per vijand; daarvóór (13
nov) "grijs voor iemand". Spel heeft er geen tekst voor (GEMETEN, GlobalStrings wowf 70938). UnitLevel niet secret in
Forever (Blizzard UI-bron); <= 0 (schedel) overgeslagen. ForeverDungeons.lua: ns.ForeverGroupTop, ns.ForeverNoXpLine
(doelwit-vijand exact; anders huidige dungeon via instance-id tegen d.max = AFGELEID "waarschijnlijk"), rode `*` in de
lijst + uitleg onderaan, `/mh dungeons check` regel. ForeverPartyPanel.lua: rode regel onder het paneel (PLAYER_TARGET_
CHANGED, UNIT_LEVEL). XP/level per taal GEMETEN (EP/PX/PE/EXP/опыт; Stufe/niveau/nivel/nível/уровень). Open: geldt het ook
in de open wereld (één spelersrapport, Blizzard zweeg) — nu alleen bij doelwit (overal) en dungeon. luac OK, lint 0 HARD.
NIET in het spel gezien (TESTLIJST 15 nov avond).
📘 Patch 12.1.7: DRAAIBOEK `docs/PATCH_12_1_7_DRAAIBOEK.md` (Rob rechtstreeks: *"Klopt en stuur een aantal speur
agenten het net op …"*). 5 speur-verslagen in `docs/patch_12_1_7/`. Kern: waarschijnlijk 1/2 dec; geen S3; 0 klassen-
spells anders; niets wat MH gebruikt verdwijnt. Vóór 2 dec klaarzetten (tabel 2b, 10 punten), 🔴 vooral 2b-1:
toetsenblok-"terug" bewaart een vast preset-nummer (`EditModeBackup.lua:947/:1022`), en 12.1.7 krijgt een 3e preset
"Gamepad". Wekelijkse hermeting op woensdag. Meetscripts gekopieerd naar `tools/patch_watch/` (+ README; ongepoetst).
🧰 12.1.7-klaarzetpunten (Rob: *"Ja, je mag de klaarzetpunten mee beginnen en wij gaan dat zeker benoemen als midnight
helper zijnde"*): 1, 2, 3, 4-tekst, 6, 10 klaar; 4-data, 5, 7, 8, 9 op patchdag. Nieuw mechanisme: `<KEY>_1217` in de
packs, Locale.lua ns:L kiest die op interface ≥ 120107 (ns.IS_1217). Stand per punt: DRAAIBOEK "2b-stand".
🔐 Herstart-check: geen enkele call werd geweigerd (git status/pull/log, echo, _probe ×3, Write). Of Rob een vraag kreeg
die hij goedkeurde, zie ik niet: AFGELEID "geen vragen", Rob bevestigt.
💡 Ideeënbus zo 15 nov: 2 voorstellen (XP-drempel +12 levels in groepen; "nieuwe spell op geen balk"). Ze staan
onderaan IDEEEN.md; Rob beslist (maandag-stap), niet verplaatst.
🗂️ Dungeonlijst per zone GEBOUWD (alleen op main; Rob via Sparring 15-11, letterlijk: *"Ja, we beginnen met deel 1 en
inderdaad net iets te hoog mag er ook bij."*): kopjes per zone (klik = open/dicht), zones op laagste level, vanzelf open
waar iets voor je level is; vinkje "alleen voor mijn level" (tot 2 levels hoger telt mee, oranje "+N"), standaard aan,
per account (`ns.db.foreverDungeonsAll`). Nieuwe keys FDUNG_ONLY_MINE_FMT / FDUNG_ZONE_FMT / FDUNG_NONE_MINE, FDUNG_NOTE
herschreven (de `*`-zin eruit), in en/nl/ru/de/fr/es/pt; check_drift: geen nieuwe drift. luac 366 bestanden OK, lint 0
HARD. NIET in het spel gezien (TESTLIJST 15 nov). Keuze die ik maakte: de kolom "Entrance" toont de zone nog steeds
(nu dubbel met het kopje); kan coördinaten worden als Rob dat wil. Bij de volgende release: changelog-regel.
📍 Dungeonlijst: kolom "Entrance" toont nu de coördinaten (Rob via sparring: *"in de kolom entrance inderdaad de
coördinaten, want 2 keer dezelfde zonnenaam staat nergens op"*). Route-tooltip noemt de zone nog.
🌐 Vertaalpunten (Rob via sparring: *"De bouwchat mag punten 1 en 3 oplossen en punt 2 nakijken."*): 1 en 3 af, 2 gemeten;
details en getallen in IDEEEN.md ("Waarnemingen 14 nov"). Mythic+ → Mythisch+ (de 85×) / Mythique + (fr 84×), GEMETEN in
GlobalStrings 50146. Rondleiding: echte knopnamen in 6 talen + esMX. Punt 2 (Tastaturbelegung enz.) wacht op Robs keuze.
Open: Mythic+ in es/pt/it (niet gemeten); CLAUDE.md-regel "Mythic+ blijft Engels" is verouderd (alleen Rob mag wijzigen).
Shift/Focus Cast: Rob is onderweg, blijft open.
🔐 Toestemmingen: Rob vroeg waarom hij nog zo vaak ja moest geven. Oorzaak (AFGELEID): de sparring-chat zette
`defaultMode: "auto"` in `C:\Users\RobHu\.claude\settings.json` (GEMETEN: staat erin), maar deze chat startte daarvoor;
instellingen worden alleen bij de start gelezen. Ook buiten de allowlist van deze chat: `printenv`, en
ListAgents/SendMessage. Daarom deze herstart (Rob: *"Doe maar"*). NIET gemeten: of "auto" echt werkt; de nieuwe chat
ziet het aan het aantal vragen. Werkt het niet, dan kiest Rob in de app één keer "Auto" bij die chat (bekend #105267).
⚠️ Voordeur: mijn eerste `_probe.py` vond geen job en draaide de oude job van een andere sessie (een beroepenlijst,
alleen lezen). Oorzaak: ik schreef in `Temp\claude\<sid>\scratchpad`; de juiste map is
`Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\<sid>\scratchpad`.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

- ▶ OPEN OPDRACHT: `/mh selftest` + vensterlijst (opdracht 7, sparring-chat; Rob: "niks later", dus al op 11 nov)
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
