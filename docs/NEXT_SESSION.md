# Midnight Helper — waar we staan

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
Rob: *"beide staan live"*). SITE_SEIN: 15 regels "getagd (v5.4.0)" + release-regel
"staat op CurseForge"; sparring seint de site-chat. Niet blokkerend open: rank-test op lvl 6. ✅ `/mh camera` na aan/uit:
"now 2.6 … back to 2.6" (Rob, screenshot, 5.4.0) → reparatie werkt. ⚠️ Voordeur: helpers zagen twee keer een vreemde beroepen-job in
`probe_job.txt` (zie hoger); herkomst nog niet nagezocht. Test 1 en 3 doet Rob later. Afspraak (sparring, tot Rob
anders zegt): 1-3 SAMEN bouwen na die tests. Ook later van Rob: `/mh pickup` gaf geen melding bij GESMEDE items
(nog niet uitgezocht; AFGELEID: misschien omdat craften als "bag update terwijl een venster open is" telt) en zijn keuze
voor de stats-regel.
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

## ▶ Open voor 14 nov (bouwchat 13-11 sloot af met /nieuwe-chat, ±00:30)

📌 14 nov ochtend (Bouwchat 14-11): ochtendronde gedaan, niets voor Rob (0 CF-reacties, geen 🔔, HandyNotes 171 zonder
zonewijziging, Zygor onveranderd, geen site-mail, BOUW_VRAAG 0 open, Notion-inbak: dezelfde 4 regels van 12 nov).
Handoff gesplitst (1544 → ~1180, knip bij "Open na 9 nov"). SITE_SEIN kreeg een regel "alleen op main" voor het
keuzevenster van 13 nov (de regie zocht "choice" en vond de 12-nov-regel niet; die stond er wel, de 13-nov-wijzigingen niet).
✅ 14 nov ochtend, Rob (via Sparring 13-11, Forever, nieuwe mage, d6c0d31): *"deze drie kreeg ik na een nieuwe char, nu
ga ik werken"* → Welcome (richting + bar layout als kaartjes), Yes → alleen de reload-vraag (geen venster eronder),
reload → toetsenblok. Afgevinkt in TESTLIJST. Nog open vóór de release: A1 (schone /reload, BugSack) en A2 (bestaand
character: schermpjes één keer, zelf sluiten, blijft weg) + Midnight. Twee nieuwe waarnemingen (Dock raakt knop in "Your
key block"; "Getting started" doorzichtig) in IDEEEN, zonder ja.
🚚 14 nov (later in de ochtend): de app-chat "Bouwchat 14-11" verhuist naar de ingang "Master-PC MH" (Rob, letterlijk:
*"Zet de chats van vandaag ook over naar de ingang"*). Er is sinds 3a75535 niets gebouwd. De code staat nog op d6c0d31
+ docs (GEMETEN, git status schoon). Niets uitgebracht, geen bump. De ochtendronde van vandaag is al gedaan; niet overdoen.

🏰 14 nov (ingang-bouwchat): nieuwe wens via Sparring 14-11, Rob letterlijk: *"We gaan voor 2 incl de route er naar
toe"* → Forever: dungeons en raids uitleggen op MH's manier (IDEEEN "Ja"). Onderzoek (mh-research) staat in
`docs/forever/DUNGEONS_2026-11-14.md`: 30 dungeons/vleugels open sinds 4 nov, raids (Barrow Deeps, Hyjal, Onyxia) op
9 dec; levels uit DB2 GroupFinderActivity (wowf 70938); ingangen uit HandyNotes_DungeonRaidLocations-Forever (MIT,
"Copyright (c) 2025-2026 Pirson", ZELF GEMETEN in LICENSE + 2 coördinaten nagekeken); Journal-tabellen ontbreken in
Forever. Plan met opties naar sparring gestuurd; NIETS gebouwd, niet in de volgende release.
✅ Rob koos (via sparring, letterlijk): *"Voor A, beginnen we met stap 1. Meneer Bouwert na de release. … C. Ja, dat
mag."* → NA de release: stap 1 bouwen (Do this now-regel + Route + dungeonlijst), HandyNotes-ingangen mee (MIT).
✅ 14 nov avond: A1 en A2 GEMETEN in de Forever-SV (na Robs filmpje 19:58, nieuwe gnome mage: Welcome → Yes → alleen
reload-vraag → toetsenblok; terugzet-chatregel gezien). A1: !BugGrabber.lua heeft alleen de NewChoices-fout van 13 nov
23:04:56 (vóór d6c0d31), niets daarna. A2: opening 13 nov 23:04:56 (na Fix2), 7 schermpjes-kaartjes, zelf gesloten na
228,8 s, daarna geen update-opening meer. Niet getest: "venster open laten + uitloggen → komt terug" (klein).
✅ Midnight (Rob, nieuw character, screenshot: *"na de layout aanmaken (show me) en de reload kwam er niets meer"*):
GEMETEN in retail-SV: Fix2 20:11:49, opening 20:11:54 mode "update", 6 kaartjes (partytargets#2, keyblock, quickbar,
fastmark, missingbuff, minimap), closedAfter 56,9 s, alle 6 in newChoicesSeen. Alle release-tests klaar.
🚀 14 nov avond: RELEASE 5.3.0 (Rob rechtstreeks: *"go en dan 5.3.0 , denk ook aan de site en evt description"*; geen
beta). Beide toc's 5.3.0, CHANGELOG_530_1..4 (enUS), `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.3.0.md`, CHANGELOG.md,
CURSEFORGE_DESCRIPTION ("Getting started"-zin: Welcome-venster; Rob plakt zelf), SITE_SEIN op "getagd". Na de upload:
CF-API nakijken (2 bestanden) en SITE_SEIN op "staat op CurseForge". Daarna: dungeons stap 1 (IDEEEN).
🔧 14 nov, na de tag (alleen op main): "Do this now" + startpagina noemen welke spell een lagere rank cast
(`ns.ForeverRankSentence`, Rob via sparring: *"Ja, doe allebei maar"*). luac + lint 0 HARD; NIET in het spel gezien
(TESTLIJST 14 nov avond). Bij de volgende release: in-game changelog-regel + SITE_SEIN-regel toevoegen.
Rob zag de zin goed (Healing Wave rank 1), maar vond de knop niet en zag de oranje rand NIET (zijn /mh ranks: slot 27,
"edge … on: 1 button"). Daarom noemt de zin nu ook de plek ("Action Bar 4, button 3 (key X)", Blizzards eigen
bar-naam). Waarom hij de rand niet zag: NIET gemeten. Hij vond de knop daarna (toets C) en zag nog steeds geen rand.
Rob: *"Ja, je moet die rand duidelijker maken"* → elke lagere rank nu de sterke rand; `/mh ranks` toont knop + alpha.
5.3.0 staat op CurseForge (GEMETEN: files 9617031 + 9617039), SITE_SEIN bijgewerkt. Rob plakte de CF-beschrijving
(via sparring; niet nagemeten op de pagina) en houdt de plek-zin (*"laat me staan zo"*).
🏰 Dungeons stap 1 GEBOUWD (alleen op main): `Modules/ForeverDungeons.lua` — "Do this now"-tip + knop, venster
"Dungeons in Forever" met Route per rij, `/mh dungeons [check]`. luac + lint 0 HARD; NIET in het spel gezien (TESTLIJST
14 nov laat). Open: vleugelnamen in de client-taal (niet gemeten), 4 web-ingangen nameten, stap 2 (quests vooraf).
Bij de volgende release: changelog-regels voor ranks-zin, plek, sterke rand, dungeons en het Horde/Alliance-embleem.
🛡️ "Your characters": Horde/Alliance-embleem vóór de naam (Rob: *"daar moet een horde of alliance tekentje voor"*);
kant vanaf de volgende login per character, tot dan "?". NIET in het spel gezien (TESTLIJST 14 nov laat).

Stand 14 nov nacht: laatste commit 33c45ef op main (GEMETEN, gepusht). 5.2.0 staat op CurseForge (13 nov). Alles
hieronder sinds 5.2.0 staat alleen op main, NIET uitgebracht. Eén voordeur t/m 19 nov: vragen voor Rob via de
sparring-chat van de dag.

A. **Vóór de volgende release (Rob wilde releasen zodra dit klopt):**
   1. Eén schone `/reload` zonder rode BugSack-melding over NewChoices.lua (fix d6c0d31; NIET gezien in het spel).
   2. Keuzevenster: "seen" pas als de speler het zelf sluit (fcf82a7) + reparatie 2 → Rob krijgt de schermpjes nog één
      keer. Test: TESTLIJST "13 nov (nacht, 5)". `/mh new check` toont reparaties en de laatste 3 openingen.
   3. Daarna: release-tekst + changelog + versie alleen op Robs letterlijke go (alles sinds v5.2.0, zie de 13-nov-secties).
B. **Gebouwd 13 nov, nog niet (helemaal) door Rob gezien** (TESTLIJST, bovenste secties): één overzicht met richting /
   bar layout / schermpjes als kaartjes; twee titels; schuifbalk; klikwacht 1,5 s rust + 0,7 s dode knoppen; Yes-log;
   terugzet-chatregel; Dock-label vrij in de Forever-vragen. Wél goed gezien: keuzevenster dicht na kiezen (Midnight),
   titel links (5.png), vanzelf op nieuw character (Forever), Welcome-venster met richting + bar layout (nieuwe mage).
C. **Kleine open puntjes:** bij "Do this now" valt de knop "off" op een tweede rij (19.png); andere "Votre"-plekken in
   frFR niet nagelopen; dispel "rij blijft rood" is GESLOTEN (Rob: "Stoppen met meten").

0. ✅ **13 nov: release 5.2.0 (zie de sectie hieronder). Proef Bindings_Camelot.xml geslaagd.**
1. ~~**Proef `Bindings_Camelot.xml` (a176d48): uitslag OPEN.**~~ (13 nov: geslaagd, 4 regels) Rob: WoW helemaal herstarten, Forever → Esc → Options →
   Keybindings → "Midnight Helper". Werkt = 4 regels (Toggle main window, Clear active route, Open: Forever, Your
   characters). Werkt niet (nog 14) → bestand weghalen en optie A bouwen: "(Midnight)" achter de Midnight-toetsen in
   Forever (Rob koos dat al, letterlijk: *"Naam met (Midnight)"*). Ook nakijken: retail-lijst onveranderd.
2. **Nog niet door Rob gezien (TESTLIJST bovenaan):** toets "Your characters" indrukken; toetsen-kaartje per character
   (d14884c); het pijltje op de oranje rand (6118be2; de rand zelf werkt, 27.png); drankjes-toetsnamen in Forever
   (89f55a5); "Show party targets"-kaartje in Midnight; alle ontbrekende buffs; Purify-macro; rechtsklik-dispel en rode
   rand in het Forever-groepspaneel; de 17 verbrede knoppen in Midnight. (dispelTryLog `cd`: 13 nov gesloten, zie 🔎 13 nov.)
3. **Wel gezien en goed (12 nov):** keuzevenster na reload; "Your characters" na de reparatie (28-30.png, 33.png);
   tegel "Your characters" met icoon; "now" alleen voor het eigen character; oranje rand op de knop.
4. Rob vragen (oud, NIET GEMETEN): zijn de upgrade-melding en de groene gear-regel af? Plakte hij de CF-beschrijving
   en de 5.1.0-tekst?
5. Op main sinds 5.1.0 en niet uit: alles van 11-12 nov (plan 1/2/3, Do this now, groepspaneel, beroepenkaart, richting,
   Used for, …). Release alleen op Robs letterlijke go.

## 🌐 13 nov (nacht) — vertaaltwijfels van de site-chat (Rob vroeg ze op te ruimen)

- deDE: 4× "Ironforge" in FWEAP_ROUTE_* → "Eisenschmiede" (GEMETEN wago AreaTable 1537 deDE, build 70783). Nu 0×
  Ironforge, 5× Eisenschmiede in Translations2026.lua.
- frFR: MH_SETUP_BTN_BLOCK "Votre bloc de touches" → "Ton bloc de touches" (rest van frFR zegt "tu").
- esES/esMX: GEMETEN dat de addon overal al "Ciudad de Ventormenta" zegt (wago 1519 esES én esMX); geen kale
  "Ventormenta" gevonden. Niets veranderd. Andere "Votre"-plekken in frFR NIET nagelopen.

## 🐞 13 nov (nacht, 5) — tweede ronde: "seen" pas bij zelf sluiten

- Rob (4fef65f, nieuw Forever-char): weer alleen Welcome met direction + barlayout; schermpjes op "seen".
- GEMETEN in de Forever-SV (bewaard vóór 23:00): `newChoicesFix1 = true` (reparatie liep), en `newChoicesShowLog` heeft
  één opening: 2026-11-13 22:58:02 op Player-6944-0355882C (Ima Littleone, mage), mode "update", 7 kaartjes (donow#2,
  partypanel#2, keyblock, quickbar, fastmark, missingbuff, minimap), marked = true (1,5 s zichtbaar). De code deed dus
  wat hij moest; de 23:00-Welcome met 2 kaartjes is daarna correct (alleen character-kaartjes nog over).
- Probleem = de regel: "1,5 s zichtbaar" ≠ gezien (AFGELEID: Rob logde uit / wisselde van character). Nieuwe regel:
  "seen" alleen als de speler het venster zelf sluit (OnHide, na ≥ 1 s zichtbaar) of op een knop van een kaartje
  klikt; uitloggen/`/reload` met het venster open telt niet. Log krijgt `closedAfter`. `/mh new check` toont de
  reparaties (1/2, met tijd) en de laatste 3 openingen. Eenmalige reparatie 2 (`newChoicesFix2`, met tijd) zet de 7
  schermpjes-keys weer op niet-gezien.
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 5). Rob wil hierna releasen: eerst deze test.
- 🐞 Rob's BugSack na reload: `NewChoices.lua:785: attempt to index upvalue 'win' (a nil value)` — de f:Hide() in
  Build vuurt de OnHide-hook vóór `win = f`. Gerepareerd: de hook en OnWindowClosed stoppen als `win` nog nil is.
  Pad nagelopen (GEMETEN, grep op `win`): CardFrame/Layout/ShownLater/TryAutoShow/NewChoicesSlash lopen allemaal na
  Build(); /mh new en de changelog-knop "Choices" gaan via NewChoicesSlash (Changelog.lua:1460, Core.lua:2671).
  Het venster kwam bij Rob toch (19.png, 7 kaartjes): de fout zat in een script-handler, die WoW apart afvangt.
  Of zijn schermpjes nu als gezien tellen: NIET gemeten (SV nog niet bewaard sinds fcf82a7); zelf gesloten ≥ 1 s =
  gezien, venster open bij reload = komen terug. `/mh new check` zegt het.

## 🐞 13 nov (nacht, 4) — kaartjes op "seen" die Rob nooit zag (Rob: "geen venster, na reload")

- GEMETEN in `_forever_/WTF/.../MidnightHelper.lua` newChoicesSeen: quickbar, fastmark, missingbuff, minimap, donow#2,
  partypanel#2 én keyblock:Player-6944-03538B8D op true; Robs 11.png toonde alleen direction + barlayout. Alleen twee
  schrijvers in de code (MarkSeen in TryAutoShow, NewChoicesMarkSeen bij "Reload now"; GEMETEN met grep). Geen tijden in
  de SV, dus welke opening het deed is NIET gemeten.
- Twee gaten in de code (GEMETEN), die samen precies dit beeld geven (AFGELEID): (1) MarkSeen liep direct bij
  win:Show(), ook als het venster niet zichtbaar was (intro-filmpje verbergt UIParent; Esc sluit het als special frame);
  (2) een tweede automatische poging mocht een OPEN venster opnieuw vullen met alleen de nog-niet-geziene rest.
- Gerepareerd in `NewChoices.lua`: nooit een open venster vervangen; niet tonen tijdens filmpje of verborgen UI;
  "seen" pas na 1,5 s echt zichtbaar (IsVisible) of bij een klik op een knop van dat kaartje (`ShownLater`); elke
  automatische opening in `ns.db.newChoicesShowLog` (max 10); `/mh new check` toont de laatste ("N card(s) really in
  the window … counted as seen"). Eenmalige reparatie `newChoicesFix1`: zet de 7 schermpjes/tweede-ronde-keys en
  keyblock:<GUID> naast elke barlayout:<GUID> terug op niet-gezien (alleen Robs SV heeft ze; niets gereleased).
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 4).

## 🖥️ 13 nov (nacht, 3) — schermpjes in het overzicht (Rob via sparring, letterlijk: "Ja, raad alleen voor nieuwe spelers en één keertje bij een volgende update")

- ✅ Welcome-venster getest (Forever, nieuwe mage): Rob *"…gekozen dat ik vast wilde. Toen dat ik inderdaad de keys
  wilde. Daarna deed ik reload…"* ("vast" = Frost, Willow).
- Gebouwd in `NewChoices.lua`: `ScreenCard()` → 4 account-brede Aan/Uit-kaartjes met de eigen instellingsteksten
  (al in alle talen, Locales/SettingsPage.lua + enUS): quickbar (SETTINGS_QUICKBAR, standaard uit), fastmark
  (SET_MARK_TOGGLE_*, standaard uit), missingbuff (SET_MBUFF_TOGGLE_*, standaard aan), minimap (SETTINGS_MINIMAP_ICON,
  aan). Setter = die van de instelling + SyncNativeSetting. Alle vier in beide tocs (GEMETEN). Of FastMark/QuickBar in
  Forever goed werken: NIET gemeten in deze ronde.
- "Eén keer bij de volgende update": nieuwe ids → elke bestaande speler ziet ze één keer; donow/partypanel/partytargets
  kregen `again = "2"` (SeenKey "id#2"), dus wie ze vanavond al zag, ziet ze nog één keer met de rest. Nieuwe
  characters van bestaande spelers: alleen de character-kaartjes. Nieuwe spelers: alles, titel Welcome.
- Lang venster: volgorde = character-kaartjes eerst, dan schermpjes; breedte-truc + schuifbalk (1cf57d2). Geen kolommen.
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 3). Geen bump/release.

## 🗂️ 13 nov (nacht) — één overzicht: richting en bar layout als kaartjes (Rob: "Als kaartjes erin")

- Rob, letterlijk: *"het laatste scherm … dat dat gewoon de allereerste is … alleen nog maar te zien is voor nieuwe
  spelers of voor nieuwe karakters. En één overzicht"*, daarna op de vraag van sparring: *"Als kaartjes erin"*.
  De volgorde van 2ef8724 (richting → bar layout → keuzevenster) VERVALT.
- `ForeverDirection.lua`: komt niet meer vanzelf (Try zet alleen loginWhy); `ns.ForeverDirectionCardApplies/Body/
  Buttons` voor het kaartje (drie bomen, uitleg bij hover). `ForeverLayoutCarry.lua`: komt niet meer vanzelf; de loop
  wacht alleen tot Edit Mode kan antwoorden (`ns.ForeverBarLayoutNotReady`); Yes is nu `ns.ForeverBarLayoutYes(src,
  from)` voor vraag én kaartje (log krijgt `from`). `NewChoices.lua`: kaartjes "direction" en "barlayout" (perChar,
  bovenaan), `bodyFn` en `tip` op knoppen, wacht op Edit Mode, neemt bij Forever de login over zolang Edit Mode laadt
  en geeft de changelog alsnog als er niets komt. Nieuwe key `NEWC_BAR_HEAD`; SET_FOREVER_BARLAYOUT_DESC en
  SET_FOREVER_DIRECTION_DESC zeggen nu "kaartje in het keuzevenster" (alle talen zelf; check_drift: 0 nieuwe drift).
- Bescherming 2e2e9ca (rust/klikwacht) en Yes-log blijven. Midnight: niets veranderd (beide bestanden returnen op
  retail, kaartjes vragen IS_FOREVER; AFGELEID uit de code).
- luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht).
- ✅ Daarna (Rob via sparring, letterlijk: *"Laat de uitleg zichtbaar bij elke knop"*): knoppen met `line` staan onder
  elkaar, even breed, met de zin zichtbaar rechts ernaast (tooltip blijft). Kaartje wordt hoger: AFGELEID ~200 px i.p.v.
  ~120 (zinnen 45-85 tekens, 1-2 regels). Zodat het venster niet buiten beeld valt: Render probeert breedte 440, 560,
  680 tot de hoogte ≤ 92% van het scherm is (geen schuifbalk en geen weggelaten kaartje: daar heeft Rob nog niet over
  beslist). `/mh new check` toont "window size last shown". NIET gemeten in het spel.
- ✅ Daarna (Rob via sparring, letterlijk: *"Ja, jouw advies"*): (a) twee titels — regel: "New in this version" alleen
  als er een account-breed kaartje (nieuwe functie) in staat EN dit account het venster al eens zag; anders "Welcome:
  set up Midnight Helper" (`NEWC_WELCOME_TITLE/_INTRO`, 7 talen zelf). Bepaald één keer per opening (`OpenMode`),
  vóór MarkSeen. (b) keyblock-kaartje valt weg als barlayout er staat (in Pick; NIET als gezien gemarkeerd → komt de
  volgende keer als de speler niets koos); schuifbalk: kaartjes in `f.scroll`/`f.content`, scrollen alleen als ook 680
  breed niet past. luac schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov nacht, 2).

## 🪟 13 nov (laat) — Forever: tekst vrij van "Dock to window" (Rob: "1 fixen") + plan drie vensters ("2 ja")

- `ForeverLayoutCarry.lua`: bar-layout-vraag en "Use your layout"-vraag: tekst van −22 naar −34 (onder de Dock-knop,
  y −10..−26), vensters 12 px hoger. `ForeverDirection.lua`: titel van TOPLEFT 20 tot 8 px links van de Dock-knop,
  gecentreerd, breekt af. luac schoon, lint 0 HARD. NIET in het spel gezien. Geen bump/release.
- Drie vensters, GEMETEN in de code: bar-layout probeert 3 s na login, en opnieuw elke 2 s (max 30×) zolang Edit Mode
  niet klaar is; richting 6 s na login en wacht als de bar-layout-vraag open is; keuzevenster wacht op beide.
  ⚠️ De bar-layout-vraag wacht NIET op de richtingvraag. AFGELEID: bij Rob was Edit Mode pas na >6 s klaar → richting
  eerst, bar-layout erbovenop. Plan naar sparring: "één voor één" = bar-layout ook laten wachten (klein), of "alles in
  één venster" (groot, drie modules + reload-popup). Mijn advies: één voor één.
- ✅ Gebouwd (Rob via sparring, letterlijk: *"Eén voor één"*): richtingvraag eerst (3 s, wacht niet meer op bar
  layout); `ns.ForeverDirectionPending()`. Bar layout wacht zolang richting nog moet komen of open is (elke 2 s, tot
  ~5 min, telt niet mee voor de Edit Mode-pogingen; daarna bij volgend gevecht-einde/filmpje); `ns.ForeverBarLayoutPending()`.
  NewChoices wacht op beide pending-functies (ook in het gat tussen de twee). `/mh direction check` en `/mh mylayout
  check` tonen "this login: <reden>". luac schoon, lint 0 HARD. NIET in het spel gezien.
  ⚠️ Na "Yes" op de bar layout kwam het keuzevenster tóch onder de reload-popup (Rob, 6.png: *"na de eerste komt dit,
  ik had nog niet gekozen voor een andere keyjayout"*). Gerepareerd (zelfde ja "Eén voor één"): na Yes telt de bar
  layout als bezig tot de reload (`reloadAsked` → ForeverBarLayoutPending true, ook na "Later", rest van de sessie).
  "Reload now" markeert het keyblock-kaartje als gezien (`ns.NewChoicesMarkSeen`), want het toetsenblok opent na de
  reload zelf (KeyBlock.lua:2687, 2 s). NewChoices wacht ook op `MidnightHelperKeyBlock` (kijkt pas na 3 s).
  "Later" = kaartje blijft voor de volgende login. GEMETEN: MH_EditModeMakeOwnLayout wordt alleen aangeroepen door de
  Yes-knop en door een knop in het toetsenblok-venster (KeyBlock.lua:1946): de layout kan niet vanzelf gezet worden
  (lezing b van sparring kan dus niet via de code). luac schoon, lint 0 HARD. NIET in het spel gezien.
- ⚠️ Daarna Rob: *"ik klikte alleen in de keuze voor welke richting ga ik uit"* → doorklik (AFGELEID, sparring's som:
  Yes ligt binnen richtingband 2). Gerepareerd voor de hele rij: `DialogPopup.lua` ns.LoginQuestionClosed /
  LoginQuestionRestLeft (1,5 s rust na sluiten) + ns.GuardFreshClicks (knoppen 0,7 s dood na tonen). Richting, bar
  layout en keuzevenster stempelen hun sluiten en hebben de klikwacht. Bij Yes: chatregel `FBAR_UNDO_CHAT_FMT` (en/nl/
  de/fr/es/pt/ru zelf vertaald, it valt terug op Engels zoals alle FBAR-keys) en een logregel `foreverBarYesLog` (max
  10: tijd, char, seconden in beeld, seconden sinds vorige vraag dicht); `/mh mylayout check` toont de laatste.
  Toetsenblok (na reload) niet bewaakt: komt niet direct na een klik. luac schoon, lint 0 HARD. NIET in het spel gezien.

## 🪟 13 nov (avond) — keuzevenster kwam niet vanzelf op een nieuw character (Rob, via sparring)

- Rob: *"pas kwam toen ik /MH new deed. En niet vanaf het begin. Dat zou wel moeten"* (nieuw Midnight-char, level 10).
- GEMETEN in SV: `newChoicesSeen` = alleen `partytargets`; geen enkele `keyblock:<guid>`. Het toetsen-kaartje is dus op
  geen enkel character ooit bij het inloggen gekozen. GEMETEN in code: één check op PLAYER_ENTERING_WORLD
  (Changelog.lua:1564 → NewChoicesTakeOver); niets = nooit meer die sessie.
- NIET GEMETEN: waarom het kaartje bij het inloggen "niet van toepassing" was (spec of balken nog niet leesbaar?
  AFGELEID). Gebouwd: bij niets bij het inloggen kijkt NewChoices na 6 s en 20 s nog eens; wacht ook op een open
  changelog (één venster). `/mh new check` toont nu "key card now: <reden>" en de uitkomst van de late checks.
- luac schoon, lint 0 HARD. Geen bump/release.
- ✅ Forever getest (nieuwe hunter): Rob *"Ja, kwam vanzelf"*. Midnight nog niet opnieuw getest.
- Twee waarnemingen (geen ja) in IDEEEN Open: Dock-label bij de bar-layout-titel; drie vensters bij eerste login Forever.

## 🔎 13 nov (avond) — dispelTryLog `cd` na Robs tweede run (Voidscar Arena, Prot Paladin): meting kan het niet beslissen

- GEMETEN in SV (13 nov 20:29, regels 140143-140364): 3× cast 213644, alle drie `cd` = "unreadable", `cdWhy` = "secret".
  C_Spell.GetSpellCooldown/GetSpellCharges zijn in een gevecht dus secret: de cooldown-meting van 9f5a96c kan in een
  gevecht NIETS zeggen. Casts 20:25:23/25/27 (2 s uit elkaar), 1× failed, 10× "Spell is not ready yet", 4× "Target
  needs to be in front of you" (fout van een andere spell terwijl de muis op de rij stond; de code waarschuwt daar al
  voor). 0× "Nothing to dispel" in het hele SV (tegencontrole: de andere twee teksten wél, 16 treffers).
- AFGELEID: geslaagde casts zonder "Nothing to dispel" = er was op dat moment iets weg te halen. Casts 2 s uit elkaar
  past niet bij 8 s cooldown die start. Beide passen samen alleen als de cooldown niet start of als het gif direct
  terugkomt; niet te beslissen met wat wij in een gevecht kunnen lezen. Het rood zelf komt van de engine (niet leesbaar).
- 🔒 **GESLOTEN** — Rob via sparring, letterlijk: *"Stoppen met meten"*. Uitkomst: niet te beslissen in een gevecht.
  Niet opnieuw openen zonder nieuwe klacht. `dispelTryLog` + NoteDispelCooldown blijven in de code (mijn oordeel: alleen
  schrijven, max 40 regels, niets zichtbaars; weghalen zou de live map raken voor niets). Niemand leest het meer uit.
- ✅ Rob: keuzevenster gaat dicht na kiezen (*"o en na de keuze was ie inderdaad weg"*); titel goed (5.png).
  Retail-toetsenlijst: 14 regels (Robs screenshot). Open: Forever met meer kaartjes.

## 🪟 13 nov (middag) — keuzevenster dicht na kiezen + titel (Rob via sparring, letterlijk: "Ja, dicht na kiezen")

- `NewChoices.lua`: een keuze sluit het venster als elk getoond kaartje in deze opening een keuze kreeg (één kaartje =
  meteen dicht). Robs ja geldt voor één kaartje; meer kaartjes = advies sparring (AFGELEID). Bijhouden in `f.chosen`,
  leeg bij elke nieuwe opening (automatisch en `/mh new`).
- Titel links, rechterrand vast aan de "Dock to window"-knop (−8), breekt af als hij te lang is; de intro schuift mee.
- `luac -p` schoon, lint 0 HARD. NIET in het spel gezien (TESTLIJST 13 nov). Geen versie-bump, geen release.
- NIET GEVONDEN: waarom het venster bij Rob "later" vanzelf wegging. Geen auto-hide in `NewChoices.lua`. Mogelijk Esc
  (UISpecialFrames) of het venster vastgezet aan het hoofdvenster ("Dock"); NIET GEMETEN.

## 🚀 13 nov — RELEASE 5.2.0 (Rob via sparring, letterlijk: "je krijgt nu een go voor een release voor alles")

- Eerst de CF-beschrijving (f6631bb, Rob plakt hem zelf), dan alles van main sinds v5.1.0. Geen beta.
- Artefacten: beide toc's 5.2.0, `CHANGELOG_520_1..10` (enUS), `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.2.0.md`,
  `CHANGELOG.md`. SITE_SEIN: 12 regels + release-regel op "getagd". Lint 0 HARD ([27] 0: geen eigen gereedschap in de
  spelerstekst), `luac -p` schoon op Changelog.lua + enUS.lua.
- Proef `Bindings_Camelot.xml` GESLAAGD (Robs screenshot, door sparring gezien: 4 regels). Blijft.
- ✅ Staat op CurseForge (GEMETEN in de API): 9587203 (Retail) + 9587210 (-forever), status 4. Run 43380670872 geslaagd;
  Wago + GitHub-release hebben beide zips. SITE_SEIN op "staat op CurseForge". Rob plakt de beschrijving zelf.

## 🛠️ 13 nov (ochtend) — ochtendronde + regie-opdracht aangescherpt (Rob via sparring, letterlijk: "Ja, aanscherpen")

- Ochtendronde: 0 open CF-reacties, geen site-mail, HandyNotes 170 en Zygor 9.6/1.6 onveranderd, BOUW_VRAAG 0 open.
  `event_snapshot --write` gedraaid (ptr 70892, forever 70938); `event_check` daarna schoon (GEMETEN).
- API-wachter 8871810: niets voor MH (nieuwe Forever-API `HasNoReagentCost`, 0 treffers in MH).
- Regie 13 nov had twee punten mis (GEMETEN): het keuzevenster STAAT in SITE_SEIN.md (regel 53, Nederlands; de regie
  zocht "choice"), en `ForeverHowToPlay.lua:273` noemt Confounding Flash al niet meer. `/mh partytest` = meetknop, geen
  SITE_SEIN-regel nodig (lint [27] houdt hem uit spelerstekst).
- Waarom de regie tabel 2 (grens CLAUDE.md, OCHTENDRONDE/CLAUDE_HISTORIE) en tabel 3 rij 10 oversloeg, GEMETEN in zijn
  run-log (cse_01AezjgjdGQo9Pd9h5Prv113, 13 turns, 80 s): hij schreef alleen blok 0 + tabel 5; zag "zie loopt scheef"
  niet als fout getal; zocht alleen bestanden "nieuw sinds vorig verslag" (beide zijn van 11 nov); `git log
  --diff-filter=A` gaf honderden Modules (ondiepe kloon, AFGELEID) en `head -30` kapte af; keek nooit in `tools/`.
- Hoofdstuk 6 van REGIE.md aangescherpt: getal in tabel 2, hele tabel 2 elke ronde, unshallow-check, geen `head` op
  lijsten, `ls tools/` + lintkoppen voor tabel 3, datum alleen na alle rijen, en een verplicht rijenbewijs in het
  slotbericht. De drie regels zelf NIET met de hand gezet (dat is de test). Routine-prompt en recept niet aangeraakt.
  Sparring meet 14 nov.

## 🧪 12 nov (laat) — PROEF: eigen toetsenlijst voor Forever (`Bindings_Camelot.xml`)

- Rob (via sparring, letterlijk): eerst *"Haal ze in Forever uit de lijst"*, daarna *"Ja, eerst de proef"* (optie D).
- Idee AFGELEID uit Baganator (Bindings.xml + Bindings_Mainline.xml + Bindings_Vanilla.xml, in Robs Forever-map
  gelezen): het spel leest `Bindings_<versie>.xml` in plaats van `Bindings.xml`. Forever = "Camelot" (die toc laadt).
- `Bindings_Camelot.xml`: TOGGLEMAIN (ALT-M), CLEARROUTE, TAB_HOME, ALTS — zelfde namen, dus Robs ALT-M blijft.
  `Locale.lua`: TAB_HOME heet in Forever "Open: Forever".
- Retail: geen `Bindings_Mainline.xml` in MH, dus retail leest `Bindings.xml` als altijd (AFGELEID; Rob kijkt in
  Midnight of de lijst gelijk blijft). `Bindings.xml` zelf is NIET veranderd.
- ⚠️ UITSLAG OPEN. Werkt het niet (Forever toont nog 14 regels): `Bindings_Camelot.xml` weg, en optie A bouwen
  (Rob: *"Naam met (Midnight)"*; "Open: This Week" → "Open: Forever").

## 🛠️ 12 nov (laat) — drankjes-toetsen krijgen in Forever een naam

- Rob (via sparring, letterlijk): *"Ja, geef ze een gewone naam"*. Zijn 32.png (Forever, Keybindings → Midnight Helper):
  "CLICK MidnightHelperHea…" / "…Com…". GEMETEN daarmee: Bindings.xml laadt in Forever, "Your characters" staat erin.
- Oorzaak: `PotionButton.lua` zet de namen (POTIONKEY_HEAL/COMBAT, al in 7 talen) maar laadt niet in Forever. Fix in
  `Locale.lua` ApplyBindingLabels: in Forever dezelfde naam + " (Midnight)", omdat de knoppen daar niet bestaan.
- Dubbel in het zoekresultaat (31.webp): in de lijst zelf één keer (Robs plaatje). AFGELEID: het zoekvak van het spel,
  niet van ons; na de nieuwe naam opnieuw kijken.
- Open (vraag van sparring, voorstel gestuurd, niets gebouwd): "Open: TAB_CODEX" = kale sleutel in Forever (Codex.lua niet
  geladen); de Midnight-toetsen (This Week, Rares, Delves, Codex, Achievements, Mounts, Account) openen in Forever de
  startpagina (terugval in SelectTab, UI.lua:4963).

## 🛠️ 12 nov (laat) — tegel "Your characters" (Rob bedoelde "tegel", niet "toets")

- Rob dicteerde "toets" en bedoelde "tegel": *"Het kopje Midnight Helper staat er. Maar ik bedoelde een tegel in onze
  addon"*. Keuzes (via sparring, letterlijk): *"Ja, een tegel (Recommended)"*; de toets: *"Laten staan (Recommended)"*.
- Tegel = een kaart in `ME_FOREVER_CARDS` (RoomLauncher.lua), zoals Rob op 10 nov voor macro's en verkopers vroeg
  (*"dit moet natuurlijk ook een tegel in de addon krijgen"*). Nieuw: `me_fchars` → `ns.ShowForeverChars()`, tekst
  TOOLLP_FCHARS_DESC, icoon `INV_Misc_GroupNeedMore` (pad AFGELEID). Er stond nog geen tegel of startpagina-regel voor
  (GEMETEN, grep met tegencontrole in ForeverChars.lua); er is dus niets weggehaald.
- Instellingen in Forever (vraag van sparring): één lange lijst, Esc → Options → AddOns → Midnight Helper; de
  Forever-schakelaars staan onder het kopje "On-screen buttons" (SettingsDefs.lua:472/523). Robs plaatje met alleen
  "Open Midnight Helper on login" is NIET gezien (niet in de map); AFGELEID: een zoekresultaat op "Midnight Helper".

## 🛠️ 12 nov (laat) — toets "Your characters" + "now" alleen voor jezelf

- Rob (via sparring, letterlijk): *"Ja, zonder toets"* (optie A). Bindings.xml `MIDNIGHTHELPER_ALTS`, geen standaardtoets
  → `MidnightHelper_KeybindAlts()` (Core.lua) = `/mh alts`; in Midnight een chatregel (BINDING_ALTS_FOREVER_ONLY).
  Naam = `FCHARS_TITLE` (Locale.lua ApplyBindingLabels), dus de toets heet zoals het venster.
- "now" alleen nog voor het eigen character; een ander minstens "1 min ago" (29.png). ⚠️ Sparring koppelde dit voorstel
  aan de toets en las Robs ja als ja voor beide; hij noemde de regel niet apart.
- Rob kijkt zelf of er in Forever onder Esc → Options → Keybindings een kopje "Midnight Helper" staat (of Bindings.xml
  daar laadt: AFGELEID, bindings-cache.wtf is niet leesbaar).
- GEMETEN: Bindings.xml parseert (14 toetsen), fchars_test "1 min ago". In het spel: NIET GEZIEN.

## 🛠️ 12 nov (laat) — toetsen-kaartje per character (Rob via sparring, letterlijk: "Ja, per character")

- `NewChoices.lua`: kaartje `keyblock` heeft `perChar = true`; "gezien" staat onder `keyblock:<GUID>` in
  `ns.db.newChoicesSeen`. Elk character zonder toetsenblok krijgt het venster één keer, met alleen dat kaartje.
  "Do this now", groepspaneel en party targets blijven per account. `/mh new check` zegt "(per character)".
- De oude account-sleutel `keyblock` telt niet meer: het character waarop Rob het al zag, krijgt het nog één keer.
- GEMETEN offline: newc_test geval 8 (character B: 1 kaartje, daarna niets). Lint 0 HARD.

## 🐞 12 nov (laat) — Robs test van "Your characters" (24-27.png): 4 fouten gerepareerd

- Rob (via sparring): *"doet hij alleen maar onthouden wat op dat moment ingelogd is … Geen professions … Al mijn
  voornamen zijn Ima"*. Keuzevenster: verscheen na een reload. Oranje rand: werkt (27.png); pijltje NIET GEZIEN.
- 1. Goud 0 / "no professions" bij andere characters. GEMETEN in de SV: alle drie `money = 0`, `profs = {}`. Oorzaak:
  de foto bij PLAYER_LOGOUT overschreef de echte waarden (het spel geeft dan 0 en geen beroepen). Fix: bij logout alleen
  `seen`; een lege beroepenlijst wist een bekende alleen na SKILL_LINES_CHANGED. ⚠️ De bestaande lege foto's worden pas
  goed na één login per character.
- 2. "Last played" overal "now": de drie `seen` lagen binnen 5 min (GEMETEN 1794515534/675/858) en "now" was < 5 min.
  Fix: now < 2 min (of het eigen character), daarna "N min ago" tot een uur.
- 3. Naam "Ima": Forever geeft de achternaam als 2e waarde van UnitName (al bekend sinds 7 nov, archief). Fix: naam +
  achternaam. Wordt goed na één login per character.
- 4. "level 7…" afgekapt: de servernaam (22 tekens) stond in dezelfde kolom. Fix: server alleen bij meer dan één server
  (dan op regel 2), kolom 30 px breder.
- Vraag 5 (sparring): de level-1 Warrior "Protection" is GEEN lek: `foreverDirection` per GUID, Warrior = band 3 =
  Protection (GEMETEN in de SV).
- Vraag 6: keuzevenster-gezien, Do this now-stand en groepspaneel staan account-breed in `MidnightHelperDB`; het
  toetsenblok per character + spec. Gevolg: het toetsenkaartje komt niet terug op een ander character zonder blok.
  Keuze bij Rob, niets veranderd.

## 🛠️ 12 nov (laat) — plan 3: oude rank licht op, op de knop (IDEEEN O24 + O25)

- Rob (via sparring, letterlijk): *"ja bouw oude reank"*; keuzes A1 *"Eigen rustige rand"*, B1 *"Aan"*, C1 *"Elke
  lagere rank"*; zijn meting in Forever *"1 61 table nil"* (ActionButton1.action 1, MultiBarBottomLeftButton1.action 61).
- In `ForeverRanks.lua` (geen nieuw bestand): `UpdateGlows` legt `Scan()` op de Blizzard-knoppen van 8 balken
  (`ActionButton`, `MultiBarBottomLeft/Right`, `MultiBarRight/Left`, `MultiBar5/6/7`, 1-12) via `button.action`.
  Eigen kindframe per knop: 4 oranje lijnen + `Interface\Buttons\Arrow-Up-Up` (pad AFGELEID). Fel (2 px, alpha 1) =
  net geleerd (`fresh`), zacht (1 px, 0,55) = zelf neergezet. Alleen zichtbare knoppen.
- Update 0,3 s na ACTIONBAR_SLOT_CHANGED / PAGE_CHANGED / UPDATE_BONUS_ACTIONBAR / REGEN_ENABLED, 1,5 s na
  SPELLS_CHANGED (na AfterLearn), 3 s na PEW.
- Schakelaar `ns.db.foreverRanks.glow` (nil = aan, false = uit), instelling `mh_foreverRankGlow`, `/mh ranks glow on|off`.
- O25: Glowing Bars NIET bij Rob geïnstalleerd (GEMETEN); detectie op mapnaam of titel "glowingbars" (genormaliseerd).
  Geladen → stil; `/mh ranks` zegt het met de naam; `/mh ranks glow on` zet `glowWithOther` en tekent toch.
- Bug gevangen in de offline test: `(not on) and false or nil` is altijd nil → "glow off" deed niets. Gerepareerd.
- GEMETEN offline (scratch `rglow_test.lua`): 6 gevallen goed. In het spel: NIET GEZIEN.

## 🛠️ 12 nov (laat) — plan 2: "Your characters" in Forever (IDEEEN O21) + Midnight-kaartje plan 1

- Rob (via sparring, letterlijk): *"De vijf van het advies, bouwen (Recommended)"*. Geen release.
- `Modules/ForeverChars.lua` (beide tocs, alleen Forever actief). Foto per character in `ns.db.foreverChars[guid]`:
  name, realm, class/className, level, money, profs {key,name,rank,max}, dir (boomnaam), trainerN/trainerCost, seen.
  Genomen 2 s na PEW / PLAYER_LEVEL_UP / PLAYER_MONEY / SKILL_LINES_CHANGED / SPELLS_CHANGED, en direct bij PLAYER_LOGOUT.
- Venster `MidnightHelperForeverChars`: eigen character bovenaan, dan op laatst gespeeld; tweede regel = beroepen;
  kruisje = vergeten (niet op je eigen rij); totaal goud onderaan. `/mh alts`, `/mh alts check`. In Midnight zegt
  `/mh alts` dat het voor Forever is.
- NIET gebouwd (Rob): tasplekken, rust-XP, raid-locks (later, na een meting), gespeelde tijd.
- Plan 1-gat (sparring): kaartje `partytargets` in NewChoices.lua voor Midnight, aan/uit via `ns.SetPartyTargetsEnabled`
  + `SyncNativeSetting("mh_partyTargets")`. Valt onder Robs bouw-ja voor plan 1 (zijn eerste zin noemde party targets).
- GEMETEN offline: fchars_test (2 characters, totaal, vergeten) en newc_test geval 7. In het spel: NIET GEZIEN.
- Plan 3 (oude rank op de knop): keuzes A1/B1/C1 en meting binnen (`1 61 table nil`), bouw-ja NOG NIET.

## 🛠️ 12 nov (laat) — plan 1: venster "Nieuw in deze versie: jouw keuze" (IDEEEN O29)

- Rob (via sparring, letterlijk): *"Keuzes in plaats van changelog (Recommended)"*, *"Iedereen (Recommended)"*,
  *"Niet tonen (Recommended)"*, bouw-ja *"Ja, bouw het (Recommended)"*. Geen release.
- `Modules/NewChoices.lua` (beide tocs, na ForeverDoNow). Kaartjes in `CARDS`, elk met `id`, `avail()`, `buttons()`:
  - `donow` (Forever): auto / always / off via `ns.SetForeverDoNowMode` + `SyncNativeSetting`;
  - `partypanel` (Forever): aan/uit via `ns.SetForeverPartyPanel`, geweigerd in een gevecht;
  - `keyblock` (beide): alleen als `ns.KeyBlockIsPlaced()` false is én er op geen enkele spec van dit character een
    snapshot staat (ook rust in de eerste seconden, als de spec nog niet leesbaar is). "Show me" = `ns.ShowKeyBlock()`.
- Changelog.lua vraagt bij het inloggen `ns.NewChoicesTakeOver()`: true → alleen het keuzevenster (3 s later; wacht op
  de richtings- en balkvragen en op het eind van een gevecht, max ~10 min). Knop "Choices" in de changelog (alleen als
  er een kaartje geldt). Gezien = `ns.db.newChoicesSeen[id]`, account-breed, één keer automatisch.
- Volgende versie een nieuw kaartje = één regel in `CARDS` met een nieuw id; alleen dat kaartje komt dan.
- `/mh new`, `/mh new check` (diagnose: per kaartje geldt/zag). In de commandolijst (CMDLIST_NEW).
- GEMETEN offline (scratch `newc_test.lua`): 6 gevallen goed. Lint 0 HARD. In het spel: NIET GEZIEN.
- ⚠️ Nieuw bestand in de toc → Rob voor de zekerheid WoW opnieuw laten starten (of `/reload` genoeg is: AFGELEID).
- Vertalingen de/fr/es/pt/it/ru: mh-writer.

## 🛠️ 12 nov (avond) — lint [28]: te smalle knoppen (Rob via sparring, letterlijk: "Ja, bouw dat")

- `tools/button_width_check.py`, in `lint_addon.py` als [28], SOFT.
- Wat hij leest:
  - UIPanelButtonTemplate-knoppen met een vaste breedte (≥ 30 px; ook via een hulpfunctie `local function Btn`);
  - `SetText(ns:L("KEY"))` op die knoppen;
  - per taal de tekst uit de packs (pack-bestanden + fill-blokken).
- Schatting: tekens × 6,5 px + 16 px. Knoppen die zichzelf op hun tekst afstemmen (GetStringWidth binnen 40 regels) slaat hij over.
- Proef: de 90 px-knop met FWEAP_TITLE (21.png) wordt gevangen. Tegenproef: 180 px niet. Allebei OK.
- Eerste run: 37 knoppen bekeken, 18 waarschijnlijk te smal. De ergste:
  - DelveBossCard:146 esES ~50 px;
  - TradingPost:671 frFR ~42;
  - ConsumablesPanel:182/266 esES ~32;
  - ProfessionsGuide:231 frFR ~28;
  - ModelPreview:200 deDE "Zurücksetzen" ~24.
- NIETS gerepareerd: lijst bij sparring, wacht op Robs keuze.
- ✅ Rob (via sparring, keuze letterlijk: *"Alle 18 repareren (Recommended)"*): nieuwe helper `ns.FitButtonToText(btn,
  min, max)` in `Core.lua` (beide spellen); max = de echte ruimte (buren, rand). 17 van 18 verbreed, geen vertaling
  ingekort.
  - DelveBossCard max 250 (de "all"-knop hangt eraan; 402 van 420 px).
  - ModelPreview: Spin/Reset groeien nu vanuit het midden naar buiten, max 110 (de pijlknoppen blijven vrij).
  - VaultReminder: de hint eindigt nu bij de knop.
  - DungeonBossWindow Chat/Share max 90; Route NIET (≈2 px, en in een 340 px venster zou de rij de "all"-knop kunnen raken).
  - Consumables ook bij de taalwissel; UI.lua About ook in de refresh.
- Lint [28] slaat een knop alleen over als `FitButtonToText(<diezelfde knop>` erbij staat. Na de reparatie: 1 SOFT
  (Route). Niet in het spel gezien, en niemand kan het in die talen zien: het blijft een schatting.

## 🛠️ 12 nov (avond) — Forever: uitleg per beroep, versie A (O26; Rob via sparring, letterlijk: "A, eerst klein")

- Nieuw `Modules/ForeverProfGuide.lua` (beide tocs): `ns.ForeverProfCard(key)` en `ns.ForeverPrimaryCount()`.
  Bron: `docs/forever/BEROEPEN_2026-11-12.md`.
- GEMETEN, stellig: wat het doet, hoofd/bij, gereedschap (alleen hammer/mining/skinning/fishing, naam uit de client via
  nieuw `ns.ForeverVendorItemName`), rangen 75/150/225/300 en 50/125/200, jouw skill.
- Gids, met "according to player guides": "pairs with", level per rang (10/20/35), "na 150: boek, dan quest". "Tot 150"
  zelf ook uit MH-data.
- Weggelaten (AFGELEID / niet gemeten / versie B): kosten, Fishing-rangen, gereedschap bij Leatherworking en First Aid,
  gereedschapsnamen Enchanting/Engineering (alleen "sommige recepten vragen gereedschap"), het kampvuur bij Cooking.
- Telling hoofdberoepen: (1) `GetProfessions` slot 1+2, (2) de herkende hoofdberoepen uit `ForeverMyProfessions`.
  Alleen als ze gelijk zijn, anders zwijgt MH. Slot-volgorde in Forever AFGELEID.
- `ForeverProfTrainers.lua`: kaartje + knop "Where to buy" boven de lijst (lijst hangt eronder), venster 560 hoog.
- `ForeverDoNow.lua`: "You can still learn 1/2 main profession(s)" + knop. Een tip, telt NIET mee voor het vanzelf
  openen (anders blijft het venster bij elk nieuw character open).
- Offline (scratch `profcard_test.lua`): 12/12 kaartjes zonder ontbrekende tekst; telling: gelijk → 1, oneens → nil.
- ❌→✅ Rob (screenshot, via sparring): "Tool: (loading...)." bij Fishing. `ForeverProfTrainers.lua` Fill wacht nu op de
  naam: `Item:ContinueOnItemLoad` + 10× herkijken per 0,5 s (de les van de verkopers-tip). Nieuw `ns.ForeverVendorItemId`.
  De half afgesneden onderste trainerrij = de onderrand van het scrollvak (dat hangt al onder het kaartje), geen fout.
  Lint 0 HARD.

## 🛠️ 12 nov (avond) — Forever: venster "Doe dit nu" (Rob via sparring, letterlijk: "Venster 'Doe dit nu'")

- `Modules/ForeverDoNow.lua` (beide tocs; returnt op retail). Elke regel rust op iets bestaands:
  - trainer: `ns.ForeverTrainerCompute(level).now` en de knop `ForeverTrainerGo`;
  - ranks: `ForeverRankCount` en `ForeverRankFixAll`;
  - wapens: `ForeverWeaponsLearnableCount`;
  - buff: `GetForeverMissingBuffs` en `MissingBuffSentence`;
  - gereedschap: nieuw `ns.ForeverMissingTools` in `ForeverVendors.lua`;
  - "Komt eraan": `ForeverTrainerCompute(level+3)`, spells boven je level, per level;
  - met richting: nieuw `ns.ForeverDirectionTalents` (ForeverMacros SPEC_MACROS), de eerstvolgende talent-spell. Levels AFGELEID.
- Stand: `ns.db.foreverDoNowMode` = auto (standaard, Robs keuze "Alleen als er iets is") / always / off.
  - Instelling `mh_foreverDoNowMode` (dropdown).
  - `/mh donow` (tonen/verbergen deze sessie), `/mh donow auto|always|off`, `/mh donow check`.
- In een gevecht weg, daarna terug. Standaardplek rechtsboven.
- In CommandList met `foreverOnly` (nieuw in `CommandItemShown`, dus ook de zoekbalk), in MoveMode, en EXEMPT in window_check (eigen Shift+scroll).
- Offline (scratch `donow_test.lua`): 4 punten "doe nu", 3 regels "komt eraan", de standen wisselen goed. luac schoon, lint 0 HARD. Niet in het spel gezien.
- ✅ Rob: "Het venster staat er, werkt" (21.png). ❌ De knop "Weapon trainers" was te smal (vaste 90 px). Gerepareerd:
  breedte uit de tekst, nieuwe rij als het niet past.
- ✅ Rob (via sparring, letterlijk): *"Ja, alle drie"*. Gebouwd:
  - geen kop "Do this now" onder de titel;
  - "(Rank N)" achter een spell die je al kent (`ForeverKnownSpell` + `C_Spell.GetSpellSubtext`);
  - wapenzin enkel/meervoud (`FDONOW_WEAP_*`) + "(fitting <richting>, according to player guides: n)" via nieuw
    `ns.ForeverWeaponsLearnable` (lijst) en `ForeverDirectionWeaponFit`.
  - Startpagina daarna ook (Rob via sparring: *"Ja, ook netjes"*): `HomeDashboard.lua` gebruikt `FDONOW_WEAP_ONE` /
    `FDONOW_WEAP_MANY_FMT`, zonder het richtingdeel. `FWEAP_HOME_FMT` wordt nergens meer gebruikt (lint [18] SOFT).
  - `FDONOW_HEAD_NOW` wordt niet meer gebruikt (blijft in de packs staan, onschadelijk).
- Rob over mijn twee keuzes, letterlijk: *"Laat zo, in een gevecht weg en rechtsboven"*.
- ✅ Tandwieltje (Rob via sparring, keuze letterlijk: *"Tandwieltje (Recommended)"*): `ForeverDoNow.lua` Build, knop
  naast het kruisje (`Interface\\Buttons\\UI-OptionsButton`; dat die textuur in Forever bestaat is AFGELEID), eigen
  menuutje (geen UIDropDownMenu) dat `SetMode` + `SyncNativeSetting` aanroept. Eén bron met de instelling. "off" →
  chat `FDONOW_OFF_HOW`. Het kruisje blijft "tot de volgende login".

## 🛠️ 12 nov (avond) — "Welke kant?" stap 1 + 2: blok in How you play, + in /mh weapons

- Rob (via sparring, letterlijk): *"1 en 2, de wapens er meteen bij"*. Aanleiding: zijn Protection-paladin met een
  two-handed sword ("Volgens mij moet een protection paradigma ook zo meteen een schild hebben").
- ✅ Gebouwd in `ForeverDirection.lua`:
  - `ns.ForeverDirectionBlock()` + data `ARMOR`/`GUIDE` per class en richting.
  - Pantser: GEMETEN (SkillRaceClassInfo).
  - "werkt alleen met": GEMETEN (SpellEquippedItems): Shield Slam/Block/Bash, Holy Shield, Sniper Shot, Mutilate, Backstab, Ambush.
  - Talentlevels: AFGELEID.
  - Wapenregel: gids, nooit "best/moet".
  - Geen gidsregel waar het onderzoek niets noemt: alle casters, Holy Paladin, Ele/Resto Shaman, elke Druid, Survivals melee-wapen. Dan staat er dat de gidsen niets noemen.
  - Stats bewust weggelaten (gids, level 60; hoort bij stap 3).
  - Namen uit de client: spells via C_Spell.GetSpellName, pantser/wapensoort via GetItemSubClassInfo.
- `ForeverHowToPlay.lua`: blok bovenaan (Body), ververst bij wisselen.
- `ForeverWeapons.lua`: groen + voor passende soorten, regel onderaan (FWEAP_DIR_*), niets verborgen. `ns.ForeverDirectionChanged` ververst beide.
- Offline (scratch `dirblock_test.lua`): 27/27 blokken, geen ontbrekende sleutel, zonder keuze geen blok. Niet in het spel gezien.
- Niet gebouwd: stap 3 (tooltip/upgrade-melding).

## 🔎 12 nov (avond) — Forever-groepsmeting gelezen (partyProbe, Forever-SV 15:11, regels 2053-2526)

- Groep: Rob + 1 character van Cisca's pc, open wereld (instance "none"), 1 snapshot met de hand + 5 gevechten
  (15:08:09-15:11:07), build 70888. party2-4 bestonden niet.
- GEMETEN, ook in een gevecht leesbaar: bestaat, naam, class, rol (UnitGroupRolesAssigned; allebei "DAMAGER"),
  canAttack/canAssist, voor player, party1, target, focus en party1target.
- GEMETEN, in een gevecht GEWEIGERD: debuffs lezen (C_UnitAuras.GetAuraDataByIndex → "Auras cannot be accessed when secret
  while tainted by 'MidnightHelper'"), op elke unit, in alle 5 gevechten. Buiten een gevecht: "nil" (leesbaar, niets op).
  Dat is precies de retail-situatie.
- GEMETEN: alle 15 events van PartyTargets bestaan; SecureActionButtonTemplate bouwt; Blizzards AuraContainer (de rode
  dispel-rand) bouwt met SetUnit/AddAuraSlot/SetEnabled. Focus: `[@focus,exists]` parse werkt ("no" zonder focus).
- NIET GEMETEN: casts (altijd "nil", er werd niets gecast op het moment van de foto); of de rode rand in Forever echt
  oplicht; een dungeon; 3-5 spelers. PartyTargets leunt op DispelHelper.lua (retail) en spec-API's → overzetten = werk.
- Plan met opties naar sparring gestuurd; niets bouwen zonder Robs ja.
- ✅ Rob koos (via sparring, letterlijk): *"A, eerst klein"*. Gebouwd: `Modules/ForeverPartyPanel.lua` (beide tocs; returnt
  op retail). Rijen you+party1-4 (naam/class-kleur/rol), secure knoppen op UIParent ZONDER scripts (`*type1`=target,
  `type2`/`spell2` = eerste dispel, `shift-type2`/`shift-spell2` = tweede), RegisterUnitWatch, handmatig over de rijen
  gezet buiten gevecht. Rode rand: AuraContainer per rij met vaste unit (nooit opnieuw binden), canvas als kind van de
  slot maar vast aan onze rij, zonder muis. Dispels: namen/id's uit `FOREVER_SPELL_IDS` (DB2), welke class welke is
  alleen volgorde; IsPlayerSpell beslist. Standaard UIT: `ns.db.foreverPartyPanel`, instelling `mh_foreverPartyPanel`,
  `/mh partytargets` (zelfde commando als Midnight) + `check`. In `MoveMode.lua` en `tools/window_check.py` (EXEMPT,
  eigen Shift+scroll). Geen stop-spell (optie B). NIET GEMETEN: of de rode rand in Forever oplicht → Robs dungeontest.
- ✅ Rob zag het (18.png): "Het groepspaneel staat er, de rijen kloppen". Daarna (Rob via sparring: *"Ja, doe dat"*): het
  paneel is zo hoog als de groep (`FitToGroup`, alleen buiten een gevecht; anker TOPLEFT via `PinTopLeft`, dus alleen de
  onderkant schuift). Alleen getoonde rijen krijgen een live knop (`panel._mhRowsShown`), dus wie in een gevecht
  erbij komt, krijgt rij én knop pas daarna. Geen schakelaar voor de vaste maat (sparring: "pas bij een klacht").

## 🛠️ 12 nov (avond) — Forever: gereedschap-tip ook bij de foutmelding van het spel

- Rob (via sparring): Cisca had Skinning maar geen mes; de leer-tip kwam nooit (beroep al van vóór MH). *"Ja, laat hem dat
  uitzoeken en bouwen"*.
- GEMETEN in Forever DB2 1.60.1.70888:
  - De fout is GlobalStrings SPELL_FAILED_TOTEM_CATEGORY / SPELL_FAILED_TOTEMS "Requires %s".
  - TotemCategory 162 Blacksmith Hammer, 165 Mining Pick, 166 Skinning Knife, met de namen per client in de/fr/es/esMX/pt/ru.
  - Vissen: SPELL_FAILED_EQUIPPED_ITEM_CLASS(_MAINHAND) "Must have a %s equipped".
- ✅ Gebouwd in `ForeverVendors.lua`:
  - UI_ERROR_MESSAGE → OnToolError: tekst gelijk aan format(global, naam) → dezelfde tip ("For this you need a …", tipNeed).
  - Hooguit 1× per gereedschap per 10 min; stil als er een gereedschap in je tassen zit.
  - Schakelaar `ns.db.foreverToolNeedTip`, instelling `mh_foreverToolNeedTip`, `/mh vendor tip on|off`.
  - `/mh vendor check` toont de laatste gematchte fout + de laatste fout van welke soort ook.
- AFGELEID, niet in het spel gezien: dat het bericht precies zo als 2e argument van UI_ERROR_MESSAGE binnenkomt.
- ⚠️ De oude leer-tip had nooit een uit-schakelaar (sparring dacht van wel); deze nieuwe heeft er wel een.
- ✅ Rob testte het: GOED (17.png, via sparring). Daarna (Rob via sparring, gedicteerd: *"ja, die regelt ronde maar voor het
  skinny knife ook"*, teruggelezen als "ja, die regel erbij"): de chatregel van de tip (leren én foutmelding) eindigt nu
  met `FVEND_TIP_LIST_FMT` "Type /mh vendor <key> for the list of sellers." (`TipChat` in `ForeverVendors.lua`). De
  10-minutenrem blijft (Rob: "Misschien terecht ook").
- `/mh move`: Rob "mh move werkt :)". Niet gemeld: plek na /reload, buff-icoon cast na slepen.

## 🔎 12 nov (avond) — dispelTryLog na Robs run (Voidscar Arena, Prot Paladin): uitslag, niets gebouwd

- Sparring las het (8 regels, rij 5 = player, in gevecht): 5× cast 213644, 1× failed, 2× "Spell is not ready yet".
  Rob: *"Hij bleef continu rood. Eén keer dacht ik dit wel deed, na de zoveelste keer rechtsklikken."*
  `/mh prompt test`: helemaal goed (woorden los, plek blijft na /reload).
- GEMETEN in de code: "cast" = `UNIT_SPELLCAST_SUCCEEDED` (`PartyTargets.lua:749-774`), dus echt geslaagde casts.
- GEMETEN in DB2 12.1.5.70783: Cleanse Toxins 213644 → SpellCategories ChargeCategory 1512 = "Class - Paladin - Cleanse",
  MaxCharges 1, ChargeRecoveryTime 8000; GCD 1500 (StartRecoveryCategory 133). Corrosive Essence 1289258:
  SpellAuraOptions CumulativeAura 10 (stapelt tot 10).
- Casts 2 s na elkaar kan dus niet met een cooldown van 8 s die echt start. AFGELEID: de cooldown startte niet, dus de
  cast haalde niets weg (Blizzards regel dat een dispel die niets weghaalt geen cooldown krijgt; niet in deze build
  gemeten). "Not ready yet" kan dan de GCD zijn. Andere mogelijkheid: het gif werd meteen opnieuw gezet. Voorstel aan
  sparring: een kleine meting (na elke eigen dispel 0,3 s later de charge/cooldown in `dispelTryLog`), pas op Robs ja.
- ✅ Gebouwd (Rob via sparring: *"Ja, bouw dat"*): `PartyTargets.lua` NoteDispelCooldown — 0,3 s na elke geslaagde eigen
  dispel zet hij op die logregel `cd` = "started" (duration > 2 s) / "not started" / "unreadable" (+ `cdDur`,
  `cdCharges`, `cdWhy`). LogDispelTry geeft nu zijn regel terug. luac schoon, lint 0 HARD. NIET GEMETEN: of
  C_Spell.GetSpellCooldown in een gevecht leesbaar is — daarvoor staat "unreadable" erin. Rob: één dungeonrun (niet vandaag).

## 🛠️ 12 nov (avond) — vier Forever-klussen terwijl Rob at (bouw-ja via sparring, Robs keuzes letterlijk)

Rob: *"Kunnen we daar niks van bouwen, dat dat zo meteen nog kan gaan testen"*; hij koos alle vier de opties. Geen release.
1. ✅ Gebouwd: **"Which way do you want to go?"** — `Modules/ForeverDirection.lua` (beide tocs; returnt op retail). Vraagt
   na het inloggen (6 s, wacht op gevecht/film/de balkenvraag/een StaticPopup, max ~2 min), keuze per character in
   `ns.db.foreverDirection[GUID]` (1-3 = boomband), `ns.db.foreverAskDirection == false` = uit. Boomnamen uit
   `ForeverMacros.lua` SPEC_NAMES (nu `ns.ForeverSpecName`/`ns.ForeverSpecBand` geëxporteerd). Zinnen = FDIR_<CLASS>_<n>
   (AFGELEID, uit `docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md`). `/mh direction` / `richting`, `check`, `on|off`;
   knop in het How-you-play-venster; instelling `mh_foreverAskDirection`. Nog niets leest de keuze
   (`ns.GetForeverDirection()` is er voor de volgende stap).
2. ✅ Gebouwd: **alle ontbrekende buffs** — `MissingBuff.lua` (ShowExtras: max 5 kleine icoontjes rechts, alleen tonen;
   AddTooltipExtras: "Why …" + "Also missing"), `ForeverBuffs.lua` (PickChoice geeft "last"/"first", Entry krijgt
   pickWhy/pickOthers). Zelfde filter als het grote icoon (combat, formApi).
3. ✅ Gebouwd: **"Move"** — `Modules/MoveMode.lua` (beide tocs), `/mh move` (+ `why`, `on|off`), instelling `mh_moveMode`
   (niet bewaard). 11 onderdelen op framenaam; het groene vakje roept de EIGEN OnDragStart/OnDragStop van het onderdeel
   aan (FastMark via `bar._mhDragHandle` = de grip). Vakje niet verankerd aan het onderdeel (protected-frames), maar
   2×/s erboven gezet. Verborgen onderdelen worden zolang getoond; gevecht = uit. MissingBuff verbergt het lege icoon
   niet zolang Move aan staat.
4. ✅ Uitgezocht (mh-research): `docs/forever/BEROEPEN_2026-11-12.md` (O26), tabel voor Rob bovenaan. 12 beroepen (9
   primair, kies 2; 3 secundair), ranks 75/150/225/300; nieuw: Camping (kamp-spullen bij elk beroep), healing potions bij
   First Aid. NIET gemeten: level per rank (alleen Warcraft Tavern), kosten bij 9 van de 12 trainers. Twee bijvangsten
   (AFGELEID, niet gecontroleerd): `tools/forever_reagents.py:15` noemt de Herbalism/Skinning/Fishing-recepten "housing" maar
   het zijn kamp-spullen (dus "Used for" mist ze); de open vraag in `ForeverToolGuard.lua` lijkt beantwoord door DB2
   TotemCategory (beter gereedschap dekt het lagere). Niets gebouwd.
- Teksten: en + nl zelf; de/fr/es/pt/ru (+ it voor buff/move) door mh-writer. Checks: luac -p schoon op alle 12 bestanden
  (positieve controle: een kapot bestand werd geweigerd). Testlijst: 12 nov (avond), drie blokken.

## 🔎 12 nov — Rode eigen rij in het groepspaneel: wat `dispelSelfLog` zegt (alleen gelezen, niets gebouwd)

- Rob (via sparring): zijn eigen rij wordt rood en hij kan het niet dispellen; speelt "al langer".
- GEMETEN in Robs retail-SV (bewaard 12 nov 12:15), `dispelSelfLog`, 34 regels, scratch `selflog.py`: sinds de
  drie-filter-versie (vanaf 9 okt, 27 regels) raakte `HARMFUL|RAID` (= het filter van de rode rij) ALLEEN debuffs met
  youCan=true (3 van 3) en NOOIT een met youCan=false (0 van 24; die 24 raakten alleen `HARMFUL|DISPELLABLE`). Na een
  gevecht klopt het rij-filter dus. De 4 valse Magic-regels van 27-30 sep zijn van vóór die versie.
- ⚠️ Gaten: (1) de log heeft GEEN character of spec. "Rabid Bite, disease, youCan=false" kan niet op een Prot Paladin
  (Cleanse Toxins haalt disease weg), dus dat waren AFGELEID andere characters. (2) Hij meet alleen 1 s NA het gevecht.
  Wat de rij IN het gevecht doet, kan MH niet zien (scannen wordt geweigerd). (3) Geen regel van 12 nov.
- Voorstel naar sparring: meten met de ogen + `/mh glow` (recent casts and errors) op het moment zelf. Klein voorstel om
  te bouwen: character + spec bij elke `dispelSelfLog`-regel.
- 💡 Nieuwe wens (O27 in IDEEEN): MH legt de rode rij zelf vast. ✅ Gebouwd (Rob, via sparring: "Ja, bouw het"):
  `PartyTargets.lua` — `RowSignal` (bovenin) via OnShow/OnHide op ons rode canvas (PaintDispelSlot) →
  `ns.db.dispelRowLog = { signals = {show, hide, showInCombat, hideInCombat}, events = {…max 40} }`; per moment row, unit,
  at, seconds, inCombat/endInCombat, zone, char/class/spec, castsAtStart/castsAtEnd (kopie castLog), en na het gevecht
  `afterFight` (samenvatting van de drie-filter-scan; `AfterCombatWithRowLog`). Offline 8/8 (scratch `rowlog_test.lua`),
  stop-spell-proef nog 7/7, lint 0 HARD. NIET GEMETEN: of OnShow in een gevecht vuurt — daarvoor zijn de `signals`.
  Rob: `/reload`, dungeonrun, `/reload`; dan lees ik het.
- ❌ Uitslag run 12 nov (SV 12:46, zelf gelezen, regels 140227-140366): signals show=10, hide=0, in gevecht 0; 10 events
  = 2× alle 5 rijen tegelijk (12:44:16 en 12:44:46), buiten gevecht, nooit een einde, castsAtStart leeg. char/spec
  klopt. Het seintje meet dus NIET "de rij is rood". AFGELEID: Blizzards aura-slot wordt bij de opbouw één keer getoond
  en daarna via alpha aan/uit gezet, niet via Show/Hide. `dispelSelfLog` heeft geen regel van 12 nov (niets bleef
  hangen na een gevecht). Buff-zin in gevecht: ✅ Rob, screenshot 13.png. Gestopt; nieuw voorstel naar sparring.
- ✅ Optie A gebouwd (Rob, via sparring: "Optie A, dispel-pogingen"): seintje + `RowSignal`/`afterFight`-koppeling eruit;
  `dispelRowLog` wordt bij PLAYER_LOGIN gewist. Nieuw: `ns.db.dispelTryLog` (max 40) via de bestaande `castWatch`:
  elke cast/failed van JOUW dispel (`IsMyDispel`: id of naam van `GetPlayerDispelIcon`) en elke UI_ERROR_MESSAGE terwijl
  de muis op de dispel-helft van een rij staat (`DispelRowUnderMouse`, GetMouseFoci = alleen lezen, niets op de secure
  knop). Per regel: kind, spellID, text, row, unit, at, zone, inCombat, char/class/spec. ⚠️ Een fout van een ANDERE
  toets terwijl de muis toevallig op een dispel-helft staat, telt ook mee (AFGELEID, zeldzaam; text maakt het
  herkenbaar). Offline 7/7 (scratch `rowlog_test.lua`), stop-spell 7/7, lint 0 HARD. Niet in het spel gezien.
- 🔎 Rob (via sparring): "Ja, de rij was rood bij Corrosive Essence. En ik heb toen aan de linkerkant met mijn
  rechtermuisknop proberen te dispellen." GEMETEN (DB2 SpellCategories 12.1.5.70783): Corrosive Essence 1289258
  DispelType 4 = Poison, dus het rood was terecht. Code nagelopen: eigen rij = unit "player", gebonden buiten
  gevecht, spell2 = "Cleanse Toxins" (naam) — geen harde fout gevonden. Kandidaten (AFGELEID): (1) de klikknop
  vuurt op neer én op op (`RegisterForClicks("AnyUp","AnyDown")`, FastMark.lua:18 noemt dat) → tweede poging "Spell is
  not ready yet"; (2) Cleanse Toxins heeft 8 s cooldown (ChargeCategory 1512) en de debuff komt terug. `dispelTryLog`
  moet het beslissen; niets nieuws gebouwd.
- ✅ Gebouwd (Rob, via sparring: "Ja, bouw dat"): elke nieuwe `dispelSelfLog`-regel krijgt `char` (UnitName), `class`
  (token) en `spec` (spec-ID), in `AfterCombatDispelCheck`. Alleen meten, niets zichtbaars. Oude regels blijven zonder.

## 🆕 12 nov — Robs Midnight-test deel 2 (follower dungeon, Prot Paladin, via sparring)

- ✅ Groepspaneel: rijen netjes, `/mh glow` "no purge, so your stop-spell: spell 96231", 5 rechterhelften gewapend.
  Rebuke-rechtsklik: "out of range, dat klopt"; een raak-Rebuke nog niet gezien. ✅ `/mh prompt test`: slepen en
  Shift+scroll werken (na de woordfix 3361a0b? onbekend; na-reload niet gehoord). ⏳ Upgrade-melding: niet te testen.
- ❓ Buff-zin in gevecht: de melding verdween helemaal. GEMETEN in code: `ns.UpdateMissingBuff` (MissingBuff.lua:819)
  verbergt alles als `ns.Aura.Trusted()` false is (`C_Secrets.ShouldAurasBeSecret`). Dat is bewust ontworpen (Cisca's
  schild-spam, 5 jul). Maar de Paladin-aura wordt NIET via aura's gelezen maar via de vormen-API (`InAnyForm`, :385-389,
  showCombat=true), dus die zou kunnen blijven staan. AFGELEID dat het die regel was. Voorstel naar sparring: eerst
  `/mh mbuff` in een gevecht laten meten; dan vormen/stances/aura's (vormen-API) uitzonderen op de aura-regel.
  Rob (via sparring): *"Eerst meten"*. `/mh mbuff` print nu ook "→ form: GetShapeshiftForm=… secret=… inCombat=…" (alleen
  diagnose). Bouw daarna gedekt ALS de meting auras-trusted=false én form niet-secret laat zien; anders nieuw voorstel.
- ✅ Meting binnen (screenshot 11.png, zelf gelezen): ShouldAurasBeSecret=true, auras-trusted=false,
  GetShapeshiftForm=0 secret=false inCombat=true. Gebouwd: entries van de Paladin-aura (465) en Warrior-stances krijgen
  `formApi = true`; `ns.UpdateMissingBuff` toont bij onbetrouwbare aura's alleen nog die (gewone buffs blijven zwijgen);
  `/mh mbuff` zegt het. Pets (UnitExists) bewust NIET meegenomen: Rob koos alleen aura's en stances. Lua OK. Niet in
  het spel gezien.

## 🆕 12 nov — Onderzoek: richtingen per class in Forever (Rob: "Ja, alle classes", via sparring; GEEN bouw-go)

- `docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md` (mh-research, 1 onderzoek, vaste vorm per class). GEMETEN: 9 classes
  (ChrClasses 70888), 3 TalentTab-bomen per class, geen spec-knop; eerste talentpunt level 10 (TraitCurrencySource 3820),
  Legacy-perk "Talented" vanaf 5; Dual Spec level 40 (client-strings), respec bij de class trainer. NIET gemeten: respec-
  en dual-spec-prijs (50 g = alleen Wowhead), Legacy-reset, beste wapen voor een deel van de richtingen, stats tijdens
  het levelen.
- ✅ Twee tegenstrijdigheden in ONZE code, gemeten en gelijkgetrokken (Rob, via sparring: "Ja, laat hem die twee
  spell-levels meten en gelijktrekken"). GEMETEN in DB2 wowf 70888 (TraitDefinition → TraitNodeEntry →
  TraitNodeXTraitNodeEntry → TraitNodeGroupXTraitNode → TraitNodeGroupXTraitCond → TraitCond): Stormstrike TraitCond
  42798 = 15 punten → level 25 (`ForeverMacros.lua` van 40 naar 25; HowToPlay zei al 25). Primal Bite TraitCond 42781 =
  30 punten → level 40 (addon klopte al; de beta-"16 punten" is oud). Rekenregel: eerste punt op 10, 1 per level, dus
  rij-drempel N → level 10+N (zonder de Legacy-perk "Talented", die alles 5 levels eerder maakt). Niet in de client gezien. Icy Veins zet Intellect vóór Strength bij Enhancement (ouder dan onze bron).
- ⚠️ mh-research leest niets in `docs/`: de 8 klasbestanden `docs/forever/FOREVER_<CLASS>_2026-11-06.md` zijn NIET
  vergeleken met dit onderzoek.

## 🆕 12 nov — `/mh prompt test` + Robs Midnight-test deel 1 (Rob: "Ja, laat hem dat bouwen", via sparring)

- Aanleiding: `/mh prompt` is een aan/uit-schakelaar, dus Rob kon Shift+scroll niet testen. `ns.PreviewActionPrompt()`
  (ActionPrompt.lua) houdt het ECHTE frame met beide iconen 20 s in beeld (eigen interrupt/purge-icoon, anders vraagteken
  134400), ook als de hint uit staat; `Update()` laat ze zolang met rust; een gevecht stopt het voorbeeld meteen (geen
  apart pad, dezelfde frame/plek/maat). Core.lua: `/mh prompt test`. Nieuwe sleutels PROMPT_TEST_FMT/PROMPT_TEST_COMBAT,
  7 talen (de/fr/es/pt/it/ru eigen vertaling, niet native nagekeken). Lua OK, lint 0 HARD. Niet in het spel gezien.
- 🐛 Rob, 12 nov (screenshot via sparring): onder de icoontjes liepen INTERRUPT en PURGE door elkaar. Oorzaak GEMETEN in
  de code: elk woord stond gecentreerd onder zijn eigen 34 px-icoon, maar is breder dan het icoon. Dat gebeurt ook in
  een echt gevecht als beide tegelijk oplichten. Fix in `MakeIcon`: woord 1 rechts uitgelijnd links van icoon 1, woord 2
  links uitgelijnd rechts van icoon 2. Niet opnieuw in het spel gezien. Slepen/Shift+scroll/na-reload: nog niet gehoord.
- Robs uitslag (via sparring, 12 nov), afgevinkt in TESTLIJST: selftest weg uit de lijst + werkt nog; partytest Midnight
  goed; "Used for" Midnight goed (Azeroot groen, Argentleaf grijs, Mycobloom geen regel, `/mh usedfor` herkent
  INSCRIPTION line 773 als "you have"); buff-zin Midnight goed; Macro's-tab "Top" goed. Open: of oudere ingrediënten óók
  een regel krijgen (vraag bij Rob via sparring; tot dan niets doen); groepspaneel deel 2 volgt.

## 🆕 12 nov — "Eén voordeur" vastgelegd + `/mh partytest` werkt weer in Midnight (Rob: "Ja, doe allebei", hier zelf)

- 🚪 Afspraak "één voordeur", proef t/m do 19 nov (Rob in sparring: "Ja, één voordeur, een week proef"; hier zelf "Ja,
  doe allebei"): blok bovenaan `CLAUDE.md` + regel in `~/.claude/skills/nieuwe-chat/SKILL.md` (ook in elke prompt) en
  `~/.claude/skills/verder/SKILL.md`. De recepten staan buiten de repo (niet in git). Na 19 nov beslist Rob.
- 🐛 `/mh partytest` in Midnight: de Forever-meting (Core.lua ~2564) ving elke "partytest" af en zei "is for WoW:
  Forever"; de solotest verderop werd nooit bereikt (helpers sparring, GEMETEN in de code). Nu: geen Forever-meting →
  kaal `partytest` = `ns.TogglePartyTargetsSoloTest()`; de oude dode tak (~4019) is weg. Lua-syntax OK, lint 0 HARD.
  ⚠️ Lint [16] telt nu 237 i.p.v. 238 gerouteerd: zijn patroon ziet `msg:lower() == "partytest"` niet (blinde vlek,
  [27] ziet hem wel). Niet in het spel gezien.
- Ook: commentaar `ForeverMacros.lua:245` klopte niet ("zelfde volgorde als Kick en Shield Bash"); Hammer is muis →
  focus → doelwit, net als Sap en Blind. Alleen het commentaar veranderd.

## 🆕 12 nov — Midnight-groepspaneel: stop-spell op het doelwit als je geen purge hebt (Rob: "Optie 1, jouw advies", via sparring)

- Beantwoordt punt 6 van "Open voor 12 nov". Optie 1 = "Purge blijft, en wie geen purge heeft krijgt zijn stop-spell".
- `PartyTargets.lua`: `GetPlayerStopSpell()` leest `ns.KeybindRoleClassifier[class]` (role "interrupt", mét id, spec in
  `specs` of geen `specs`, en `IsPlayerSpell`, fails closed; laagste priority). `ns.PartyTargetsTargetHalfSpell()` =
  purge, anders stop-spell, anders nil. `ApplyDispelAttributes` gebruikt dat voor de rechterhelft (zelfde regels:
  buiten gevecht, opnieuw na spec-/talentwissel). `/mh glow` zegt welke van de twee en telt de gewapende rechterhelften.
- Offline test (scratch `stopspell_test.lua`, PartyTargets echt geladen): 7/7 — Prot Paladin → Rebuke 96231, Holy Paladin
  → niets, Ret zonder Rebuke → niets, Shadow Priest → purge 528 wint, Warlock (pet-kick zonder id) → niets, Warrior →
  Pummel, Mistweaver → niets. Lua-syntax OK, lint 0 HARD. NIET in het spel gezien.
- Specs die leeg blijven (AFGELEID uit de KeybindRoles-tabellen): Holy Paladin, Mistweaver, Resto Druid, Preservation
  Evoker, alle Warlocks (Spell Lock/Axe Toss = pet, geen id). Open keuze voor Rob (via sparring): krijgt zo'n spec iets
  anders, bv. een stun? Niet gebouwd.
- Robs keuzes daarna (via sparring, letterlijk): lege specs → *"Leeg laten (Recommended)"* (geen stun); spelerstekst →
  *"Ja, een zin erbij (Recommended)"*. Gedaan: "Right-click a player to dispel them; right-click their target to purge
  it, or to interrupt it if you have no purge." achter `CMDLIST_PARTYTARGETS` en `SET_PARTYTARGETS_DESC`, in 7 talen
  (de/fr/es/pt/it/ru door mh-writer, eigen vertaling, niet native nagekeken; `check_drift --mark` gedaan). deDE: de
  helper koos "entzaubern" (uit PROMPT_WORD_PURGE), maar dat is in dit pack ook disenchanten; ik maakte er "bannen" van.
  📌 Open: PROMPT_WORD_PURGE = "ENTZAUBERN" in deDE zelf nog nakijken tegen de client. ruRU zegt voor dispel én purge
  развеять (het pack heeft geen apart woord).
- Ook van Rob (via sparring, 12 nov), alleen noteren: beroepenadvies bij idee 7 = *"Ja, misschien is het wel een goed
  idee"* (richting, geen bouw-go; ontwerp idee 3 + 7 later die dag: *"Schets klopt"*, eerst Forever, staat in IDEEEN bij
  beide regels, GEEN bouw-go); de "+37% upgrade"-regel van een andere addon stoort NIET (*"Nee, juist niet, want
  niet iedereen heeft dat"*), onze regel blijft; idee 3 + 7 als één ontwerp praat sparring eerst met Rob door. Nieuw in
  IDEEEN: O26 (Forever-beroepenuitleg); O21 kreeg de datum van 12 nov.

## 🆕 12 nov — lint [27]: geen commando's die alleen wij gebruiken in de release-tekst (Rob: "Ja, bouw dat", via sparring)

- Aanleiding: 5.1.0 noemde `/mh selftest` (Rob 11 nov: "dingen … die alleen wij doen, dat is niet handig"); eb3e22a
  haalde het al weg. Opdracht van Sparring 12-11 (plan stap 10: regels worden controles).
- `tools/release_text_check.py`: lijst `DEV_ONLY` (29 namen: selftest, partytest, probes, scans, dumps; GEMETEN: alle 29
  gerouteerd) + `dev_only_check()`. Leest RELEASE_NOTES.md, `docs/CURSEFORGE_<toc-versie>.md` en de
  `CHANGELOG_<ver>_*`-regels in enUS.lua. Niet CHANGELOG.md of de handoff. Uit-schakelaars en `/mh report`/`/mh arrow`
  horen er NIET op. Lint [27], HARD (Rob: "een fout"); blokkeert niets, want 5.1.0 op main is al schoon.
- Proef: de twee weggehaalde 5.1.0-regels → 2/2 gevangen; tegenproef (`pickup off`, `geartip off`, `report`, `trainer`)
  → 0. Nepnaam op de lijst → SOFT "stale". `run release_text_check --selftest` OK. `locale_index`/`routed_words`
  ongewijzigd (de site importeert ze).
- ✅ `/mh selftest` uit de spelerslijst (Rob: "Ja, haal hem weg"): rij weg uit `MH_COMMANDS`, naam in
  `MH_UNLISTED_ON_PURPOSE`. Het commando werkt nog; `CMDLIST_SELFTEST` (8 talen) blijft staan. Lint [16]: 92 listed /
  149 classified (was 93/148). Niet in het spel gezien.

## 🆕 12 nov — regisseur aangescherpt, hoofdstuk 6 van REGIE.md (Rob: "Ja, zet ze erin")

- Opdracht van Sparring 12-11: de ronde zag drie dingen niet (CLAUDE.md-grens 350, tabel 2 mist OCHTENDRONDE.md en
  CLAUDE_HISTORIE.md, tabel 3 rij 10 "niet begonnen"). Oorzaak GEMETEN: stap 4 noemde zelf "geen grens", en geen
  stap legde tabel 2 naast `docs/` of "niet begonnen" naast `tools/`/lint/hooks.
- Eénmalig geschreven in `docs/REGIE.md` (van de regisseur), drie regels: stap 4 grenzen uit de bron
  (`lint_addon.py` [24]), stap 5 tabel 2 naast nieuwe `docs/*.md`, stap 6 tabel 3 naast tools/lint/hooks + datum in
  de kop. De drie foute tabelregels zelf NIET gerepareerd: de proef is of de regisseur ze 13 nov zelf goed zet
  (sparring meet na). Het recept en de cloud-routine zeggen alleen "doe hoofdstuk 6" (routine-prompt NIET GELEZEN).

## 🆕 12 nov — Forever Priest-tip: Confounding Flash werkt wél in Shadowform (Rob: "Ja, doe allebei")

- Aanleiding: content-wachter 12 nov [RAAKT ONS]. Forever-hotfix 11 nov (news.blizzard.com 24315281): *"Confounding
  Flash (Gnome) can now correctly be used while in Shadowform."* Onze "Beginner mistakes"-regel zei het omgekeerde.
- Confounding Flash uit de zin gehaald in alle 8: `Modules/ForeverHowToPlay.lua:273` + `Locales/ForeverHowToPlay_`
  nlNL/deDE/frFR/esES/esMX/ptBR/ruRU. Chastise (Dwarf) en Fear Ward blijven: daar zegt de hotfix niets over
  (NIET GEMETEN of die echt niet werken). Niet in het spel gezien.
- Ook: dit bestand gesplitst (1588 regels, grens 1500), knip bij "🌙 6 nov, einde dag"; 348 regels / 21 secties
  naar `NEXT_SESSION_ARCHIVE.md`.

## 🆕 11 nov — Forever: Paladin-macro's Hammer of Justice + Purify (Rob: "Ja, alleen klein")

- `ForeverMacros.lua` CLASS_MACROS: `hammer` (853, level 8, `[@mouseover,harm,nodead][@focus,harm,nodead][]`) en `purify`
  (1152, level 8, mouseover/help/player). Uitleg zegt "stun, geen echte interrupt". 7 talen (it niet: Forever-blok).
- 👀 Rob zag de stun op mouseover werken (target bleef staan).
- ✅ Meting gebouwd (Rob: "maak die meting maar"): `Modules/ForeverPartyProbe.lua`, `/mh partytest [clear]` →
  `ns.db.partyProbe` (events, AuraContainer-gloed, focus, API's, per unit readable/secret zonder namen, plus 5
  gevechten automatisch 2 s na start, alleen in een groep).
- ✅ **Solo-meting binnen** (Rob, 11 nov 22:59, build 70888, GEMETEN in de SV): alle 15 PartyTargets-events valid
  (ook PLAYER_SPECIALIZATION_CHANGED en TRAIT_CONFIG_UPDATED); AuraContainer + CustomAuraContainerTemplate bouwt met
  SetUnit/AddAuraSlot/SetEnabled; FocusFrame bestaat, `[@focus,exists]` = yes (focus werkt); SecureActionButtonTemplate
  bouwt. Open: groep + gevecht (wat is secret bij party-leden en hun doelwit, rollen, en of de gloed echt verschijnt).
- 📌 **Midden (PartyTargets naar Forever) staat open tot de meting er is.** Eerst meten via SavedVariables: welke events
  Forever kent (PLAYER_SPECIALIZATION_CHANGED, TRAIT_CONFIG_UPDATED), of de AuraContainer-gloed werkt, wat
  UnitGroupRolesAssigned geeft, hoe secret naam/doelwit/class in een groep zijn, of `[@focus]`/`/focus` werkt. Deels
  alleen in een echte groep; solo-deel via een `/mh partytest`. Opdracht staat in de sparring-chat (11 nov).

## 🆕 11 nov — "Used for" ook in Midnight (Rob: "Ja, bouw het")

- `ForeverReagentUse.lua` → `Modules/ReagentUse.lua` (beide spellen; globals nu `ns.REAGENT_*`, eigen
  `MyProfessions` via `ns.REAGENT_LINES`, schakelaar `ns.db.usedForTip`, `ns.UsedForSlash`). Data per spel, elk
  bewaakt: `ForeverReagentData.lua` (524 items) en `MidnightReagentData.lua` (296 items, 6247 bytes).
- Midnight-regel (GEMETEN, 12.1.5.70783): recepten = SkillLineAbility met `SkillupSkillLineID` = "Midnight <beroep>"
  (2906-2918; de kolom `SkillLine` heeft 0 Midnight-rijen). Ingrediënten = SpellReagents (72) + kwaliteitsingrediënten
  via ModifiedCraftingSpellSlot → MCRSlotXMCRCategory → CraftingReagentQuality (228). 876 recepten, 9 beroepen
  (Midnight Mining heeft geen recepten met items). Controles: Practically Pork 242639 = Cooking, Eversong Trout 238383 =
  Alchemy/Cooking/Enchanting.
- itIT kreeg een eigen FUSE-blok (in Midnight is Italiaans echt). Offline test 19/19, lint 0 HARD. Niet in Midnight gezien.

## 🆕 11 nov — Forever: "MH: Used for Cooking" in de tooltip (Rob: "Ja, met probe-fix")

- `Modules/ForeverReagentUse.lua` (tooltip post-call, GameTooltip + ItemRefTooltip, altijd, ook in de tas) +
  gegenereerd `Modules/ForeverReagentData.lua` (524 items, 6955 bytes, één string `id:bits`, lazy geparsed).
  Generator `tools/forever_reagents.py` (`--report` / `--emit`, build 1.60.1.70888) met 4 positieve controles
  (Stringy Wolf Meat 2672 + Meaty Bat Wing 12223 = Cooking, Linen Cloth 2589 ∋ Tailoring, Copper Ore 2770 = Mining).
- Regel (GEMETEN aantallen): 2121 recepten tellen; 233 af (item niet in Forever-ItemSparse), 132 af (spell-id
  400000-1199999 = SoD e.d., AFGELEID uit de id-reeks), Herbalism/Skinning/Fishing (3 elk, housing-dingen) en Poisons
  (26, rogue-skill) bewust weg. 9 beroepen, Mining = omsmelten.
- Namen: eigen beroep = clientnaam (GetProfessionInfo); anders SkillLine.DisplayName_lang per taal (gegenereerd; itIT
  leeg = Engels, Forever itIT is Engels); anders Engels. Groen als je er één hebt, grijs als niet.
- Offline test (scratch `usedfor_test.lua`): 14/14 OK. ✅ AF (Rob: "Ja, af") na zijn screenshots: Linen Cloth,
  Stringy Wolf Meat (groen), Hearthstone (geen regel), `/mh usedfor`. De gewone tooltip zegt "Crafting Reagent" maar
  niet waarvoor. Skill lines 129/185/164/186 nu GEMETEN. Niet gezien: grijze regel, Copper Ore.
- Ook: `_probe.py` kijkt nu in álle scratchpad-mappen van dit sessie-ID, nieuwste job eerst (na een samenvatting
  had één sessie er twee; hits[0] las de oude).

## 🆕 11 nov — Stadsnamen = clientnaam (Rob: "volgen alles zoals het originele Blizzard-spel het geeft")

- Melding site-chat: de "Ironforge" en "Ventormenta" in de packs. GEMETEN met `gamedata db2 AreaTable` (10 plaatsen,
  8 locales, Forever 1.60.1.70888 én retail 12.1.5.70783).
- 🔑 **De Forever-client is anders dan retail.** Forever deDE zegt zelf *Ironforge*, *Undercity*, *Thunder Bluff*
  (retail: Eisenschmiede, Unterstadt, Donnerfels); Forever frFR *Thunder Bluff*; Forever itIT alles Engels; Forever ruRU
  *Дарнасс* (retail *Дарнас*). De Forever-routezinnen (`FWEAP_ROUTE_*`) klopten dus al; niets veranderd.
- Wel gerepareerd: esES/esMX retail-zinnen zeiden "Ventormenta", de client zegt "Ciudad de Ventormenta" (beide spellen).
  11 plekken: `Translations2026.lua` (LVL1080_1, 5× MOUNTRUN_HOW_*), `esMX.lua` (4), `Codex.lua` (1). Lint 0 HARD.

## 🆕 11 nov — CurseForge-plaatjes: `tools/cf_media.py` (Rob: "Ja, bouw het")

- Opdracht van de sparring-chat: hooguit 4-6 echte screenshots op één vaste ComfyUI-achtergrond (Rob koos "Nummer 2").
- `run cf_media --proef` zet `E:\MidnightHelper-media\` klaar (kopie van achtergrond, Cinzel-font, één screenshot,
  voorbeeld `shots.txt`) en tekent. `run cf_media` tekent elke regel van `shots.txt` (`bestand | titel | x,y,w,h`) naar
  `output\`. Alles buiten repo en WoW-map; het origineel in `E:\ComfyMCP\output` blijft staan.
- Vorm: 1920x1080, screenshot in vak (230,165)-(1690,935) zodat bureaurand en lantaarntop vrij blijven, rand #FFCC00
  3 px, zachte schaduw, titel Cinzel Bold 62 px goud bovenaan. GEMETEN in de proef: randpixel (255,204,0), Bold actief.
- ✅ AF (Rob: "Ja, goed zo"): zes plaatjes in `E:\MidnightHelper-media\output\` (01-04 + de nieuwe 05/06 van 200749 en
  200805; de oude 05/06 heeft Rob weggegooid, GEMETEN). Uitsnedes staan in `shots.txt`. Rob uploadde ze zelf
  naar CurseForge op 11 nov. CurseForge weigert plaatjes boven 2 MB (2: 2,08 MB, 3: 2,33 MB, GEMETEN): het script
  bewaart nu PNG als dat ≤ 1.950.000 bytes is, anders JPEG kwaliteit 95 zonder kleurverlies (2 → 0,62 MB, 3 → 0,77 MB;
  kleine tekst ingezoomd scherp). Gereedschap, niet in de release-tekst.

## 🆕 11 nov — stap a: Seal-tip en Claw-fix (Rob: "Seal-tip + Claw-fix")

- mh-research (`docs/forever/FOREVER_QUEST_LOCKED_SPELLS_2026-11-11.md`): Judgement = trainer, level 4 (MH klopt); hij
  vraagt een actieve seal (DB2 aura-state 5, GEMETEN; dat het "seal aan" betekent is AFGELEID), anders "You can't do that
  yet". "Continue Your Training" = quest 91209 (Undead Paladin), geen spell.
- How you play (Paladin, regel Judgement): zin "werkt alleen als er een seal aan staat, zet eerst je seal aan (3)" in 7
  talen; het foutbericht alleen in enUS/nlNL (Engelse client), de andere talen zonder (niet gemeten hoe hun client het zegt).
- `ForeverTrainerData.lua:86` Claw 3029 `req` 16942 (talent Sharpened Claws) → 1082 (SkillLineAbility 2077, GEMETEN).
  ⚠️ Dit bestand heet "GENERATED"; bij opnieuw genereren moet deze fix mee (commentaar staat op de regel).
- ✅ Daarna (Rob: "Ja, bouw dat"): `ns.FOREVER_QUEST_FIRST` in `ForeverTrainer.lua` (handmatig, ~45 spell-ids uit het
  onderzoek); is de ontbrekende eerste rank zo'n spell, dan `FTRAIN_NEEDS_QUEST_FMT` "(from a class quest, not from the
  trainer)". How you play: "(from a quest)" bij Redemption en Aquatic Form, Priest-rasspells "you get both from a quest".
  7 talen. Niet in het spel gezien. Stap a is hiermee af tot Robs test; volgende = stap b.

## 🆕 11 nov — Release 5.1.0 (Rob: "je krijgt een go om het live te zetten … Zowel voor forever als voor midnight")

- Rob koos release zonder testronde en zonder beta: *"Beta mensen reageren nooit. Zeker niet in de forever versie."*
  De sparring-chat adviseerde eerst een korte testronde (4 punten); Rob besliste anders. Die 4 (upgrade-melding,
  groene tooltipregel, buff-zin in Midnight/gevecht, "(loading...)") zijn NIET in het spel gezien en hebben elk een
  schakelaar. Eerste meldingen van spelers daarover = eerst kijken.
- Artefacten: beide toc's 5.1.0, `CHANGELOG_510_1..12` (enUS), `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.1.0.md`,
  `CHANGELOG.md`. Tag `v5.1.0` → twee bestanden (Retail + `-forever`). Status CurseForge: zie SITE_SEIN.

## 🆕 11 nov — Stap e: Zygor-wachter (Rob: "Ja, door met stap e")

- `tools/zygor_watch.py` (`run zygor_watch`): kopie van alle gidsbestanden gzip in
  `%LOCALAPPDATA%\MidnightHelper\zygor_snapshot` (buiten repo en WoW-map), per bestand de diff. Detail met npc/quest/
  ach/goto alleen voor Midnight-bestanden met "MID" in de naam en alle Forever-bestanden; de rest alleen tellingen.
  Nieuw/weg altijd genoemd. Nulmeting 11 nov: Midnight 9.6 (717), Forever 1.6 (104); tweede run "no guide file changed".
  `--selftest`: kopie + nep-regel → gezien, precies één bestand: OK. In OCHTENDRONDE stap 16.
- Daarmee is de volgorde van 11 nov (a t/m e) gebouwd. Open: Robs tests (TESTLIJST bovenaan), selftest in Midnight.

## 🆕 11 nov — Stap d: melding bij een opgepakte upgrade (Rob: "Ja, allebei" = beide spellen)

- Nieuw `Modules/PickupUpgrade.lua` (beide toc's). BAG_UPDATE_DELAYED → links in de tassen tellen; een link die erbij
  kwam = nieuw. Niet bij: eerste telling na inloggen, verkoper/bank open, een link die je net droeg. Rode regel in
  `C_TooltipInfo.GetHyperlink` = overslaan. Oordeel Forever: `ns.ForeverGearTipText` (geeft nu ook `gains, why` terug);
  Midnight: `ns.GetLootUpgradeInfo`, alleen ilvl>0 én score>0. Melding via `ns.ShowBriefNotice` (7 s) + chatregel; in
  combat wachten tot PLAYER_REGEN_ENABLED. Item-data nog niet binnen → tot 5× elke seconde opnieuw.
  `/mh pickup [on|off]` (in de lijst). Offline getest (beter/slechter/rood/verkoper/uittrekken/gevecht, beide spellen).
- GEMETEN bij het voorstel: de Midnight-rekenaar = ilvl×8 + bijstats met spec-gewichten; zonder spec geen oordeel; hij
  kijkt zelf niet of je het kunt dragen (daarom de rode-regel-check). Niet in het spel gezien.
- Robs hamer-in-de-tas-test (verkoopwaarschuwing): ✅.
- ▶ Volgende: stap e (Zygor-wachter).

## 🆕 11 nov — Forever-verkoper: twee reparaties (Rob: "Ja, allebei")

- Selftest Forever, tweede run (GEMETEN in SV): item-controle nu OK (GetItemInfoInstant), alle drie OK, 0 ontbrekend.
  Midnight nog niet gedraaid.
- `ForeverToolGuard.lua`: "Right-click sells this…" stond ook bij de hamer in de KOOP-lijst van de verkoper (Robs
  screenshot), en bij 0 hamers (`n <= 1`). Nu alleen bij precies 1 en niet als de tooltip-eigenaar een
  `MerchantItem…`/`MerchantBuyBack…`-knop is (namen AFGELEID uit de Blizzard-verkoper; een andere verkoper-addon zou
  andere namen hebben).
- `ForeverVendors.lua`: de beroepstip bleef "(loading...)" zeggen (ook na de fix van 10 nov). Oorzaak niet gemeten.
  Nu drie wegen: tweede naamvraag (GetItemInfo), ItemMixin `ContinueOnItemLoad`, en 10× elke 0,5 s opnieuw kijken.
  Niet in het spel gezien.

## 🆕 11 nov — Stap c: `/mh selftest` + vensterregel C5 (Rob: "Ja, bouw het")

- **Eén bron:** `data_check.py` heeft nu `scan()` (C2 én de zelftest) en `--emit` → `Modules/SelftestData.lua`
  (gegenereerd; per soort komma-strings R/F/B, pas geparsed bij `/mh selftest`). Lint [26] SOFT als hij verouderd is:
  dan `run data_check --emit` en mee-committen. Stand: spell 1071, achievement 39, quest 341, item 25, map 72.
- **`Modules/Selftest.lua`** (beide toc's): spell `C_Spell.DoesSpellExist`, item `C_Item.DoesItemExistByID`, map
  `C_Map.GetMapInfo`; quest en achievement alleen geteld (geen betrouwbare "bestaat niet"-call). Controle in dezelfde run
  (6603/947/6948 moeten bestaan, 99999999 niet). Andere-spel-nummers overgeslagen; gedeelde-bestand-nummers die hier
  ontbreken apart. Stukjes van 400 per frame; niet in combat. Rapport → `ns.db.selftest` (laatste run). Offline getest
  (2 ontbrekend gevonden, "alles bestaat"-spel faalt de controle, combat geweigerd). In `/mh`-lijst + zoekbalk. 7 talen.
- **C5 = `tools/window_check.py`, lint [25] HARD:** elk benoemd frame op UIParent zit in `SCALABLE_WINDOWS`, wordt binnen
  120 regels aangemeld (`RegisterMidnightDialogPopup`/`MakeMidnightWindowScalable`), of staat in `EXEMPT` mét reden.
  Telling 11 nov: 81 frames, 54 schaalbaar, 27 uitzondering, 0 fout. Eén echt gat gevonden en gedicht:
  `MidnightHelperActionPrompt` (`/mh prompt`) → `SCALABLE_WINDOWS`. Blinde vlek: frames zonder naam.
- Lint [10] kent nu ook `msg:lower() == "x"` als route.
- **Robs eerste run, Forever (GEMETEN in zijn SV):** 1164 nagelopen, 0 spells/kaarten ontbreken; maar
  `C_Item.DoesItemExistByID(99999999)` = **true** in Forever → controle faalde (terecht). Reparatie ("Ja, repareer"):
  items via `GetItemInfoInstant` (AFGELEID, de controle beslist), en de controle per soort: een soort die faalt wordt
  overgeslagen en genoemd (`SELFTEST_UNTRUSTED_FMT`), de rest telt. Offline getest. Ook gezien: 21 kaarten + ~80 spells
  uit gedeelde bestanden ontbreken in Forever (DK-spells, nieuwe kaarten) = verwacht, staan apart.
- Niet in het spel gezien. ▶ Volgende: Robs eerste `/mh selftest` in Forever + Midnight lezen; daarna stap d (melding
  bij het oppakken van een upgrade), e (Zygor-wachter).

## 🆕 11 nov — Stap b: alleen een tooltipregel (Rob: "Alleen tooltipregel")

- GEMETEN (Robs Forever AddOns.txt, Ima-Pallie): Pawn + Baganator aan. Pawn doet al pijltjes + tooltip; Baganator
  vervangt de Blizzard-tassen waar `BagUpgrade.lua` aan hangt → retail-pijltjes overzetten heeft geen zin.
- Gebouwd in `ForeverQuestHint.lua` (zelfde rekenwerk als de questbeloning-tip; `Explain`/`IsBetter` nu gedeeld):
  `TooltipDataProcessor.AddTooltipPostCall(Item)` op GameTooltip/ItemRefTooltip → groene regel `FGEAR_TIP_FMT` alleen
  als het item beter is. Stil bij: rode regel in de tooltip (kan niet dragen; AFGELEID dat Forever rood kleurt), al
  gedragen, niet beter. `/mh geartip [on|off]` print de laatste beslissing. 6 talen (geen itIT: Forever).
- Offline getest (scratch `geartip_test.lua`). Niet in het spel gezien. NIET gemeten: of TooltipDataProcessor in
  Forever bestaat (Pawn/Auctionator/PaladinPlan gebruiken het daar = kandidaat, geen bewijs); zo niet, dan zegt
  `/mh geartip` dat.
- ▶ Volgende: stap c (`/mh selftest` + vensterlijst, opdracht 7 fase 0.3).

## 🆕 11 nov — Buff-melding wordt een zin (sparring-opdracht na PaladinPlan; Rob: "Ja, met jouw advies")

- Keuzes van Rob: beide spellen; icoon blijft op zijn plek (CENTER 0,+160 of waar de speler het sleepte).
- `MissingBuff.lua`: label GameFontNormal, goud (1, 0.82, 0.1), tekst uit `ns.MissingBuffSentence(entry, inCombat)` =
  `MBUFF_TXT_<kind>_SAY` (%s = spellnaam uit de client) + `MBUFF_SAY_CLICK` / `MBUFF_SAY_IN_COMBAT`. Onbekende soort →
  `MBUFF_TXT_MISSING_SAY`. `/mh buffs` en `/mh mbuff` printen dezelfde zin.
- Fout a (GEMETEN in de code): Forever-paladin-blessings zonder `covers` → Greater Blessings toegevoegd.
- Fout b (GEMETEN): `MBUFF_EUI_OVERLAP_HINT` + commentaar + `/mh mbuff`-regel zeiden "in combat klikbaar"; dat is
  niet zo ("[combat] hide"). Herschreven, 7 talen.
- Fout c (GEMETEN): `ns.PrintMissingBuffDebug` stond ín `EuiReminderLoaded` → losgehaald.
- Offline getest (scratch `buff_test.lua`): zinnen, Greater Blessing telt, controle gewone blessing, debug zonder C_AddOns.
  Niet in het spel gezien. Vier ideeën in IDEEEN.md (Ja, later). PaladinPlan = GPL-3.0: niets overgenomen behalve het idee.

## 🆕 11 nov — Forever: trainerplekken (Rob: "Alle drie", na zijn melding: pijl 12 m naast Aramis Hammerhand)

- GEMETEN: Wowhead geeft Aramis als "31, 66.2"; bijna alle trainer-/verkoperplekken in MH staan op één decimaal (218/217
  class, 313/313 beroep, 405/405 verkoper), met een heel getal voor x of y bij 60 class-, 98 beroeps- en 158 verkoperrijen.
- 1) `ForeverTrainerSpots.lua` Aramis → 31.11, 66.38 (Robs meting, coördinaat-regel).
- 2) Nieuw `Modules/ForeverSeenPlaces.lua` (alleen Camelot-toc): bij TRAINER_SHOW/MERCHANT_SHOW de spelerpositie onder het
  NPC-id in `ns.db.foreverSeenAt`; `ns.ForeverPlaceFix(npc, map, x, y)` gebruikt in `ForeverTrainer` (Candidates →
  FixPlaces), `ForeverWeapons` en `ForeverVendors` GoTo. Zelfde kaart only. `/mh travel` toont het aantal. Offline getest.
- 3) `FARROW_NEAR_NPC` via `nearKey/nearYards = 20` op de lastTarget (trainer, wapen, verkoper); NativeArrow kopieert ze en
  zet de zin achter het label binnen 20 yd. 7 talen.
- (correctie: het bestand staat in BEIDE toc's met IS_FOREVER-guard; anders zag de linter [2]/[9] HARD.)
- ▶ Later: geleerde plekken uit Robs SavedVariables (`foreverSeenAt`) in de spots-bestanden zetten.
- **Ronde 2 (Rob test, "Ja, repareer allebei"):** GEMETEN in zijn SV: Aramis geleerd op 31.11, 66.35 (nieuwe code draaide),
  maar de eerste pijl stond tóch 12 m ernaast. Oorzaak GEMETEN: `HandyNotes_ClassTrainers` heeft Aramis op 30.97, 66.77, en
  in `OnePerTrainer` (8 nov, Duesten) wint HandyNotes (3) van een MH-rij zonder `measured` (4). → Aramis `measured = true`,
  en `seen` = rang 0. Tweede fout: `/mh travel` bleef in Forever stil — Core.lua's retail-tak (`ns.Travel.PrintStatus`)
  ving het commando en deed `return` zonder iets; nu alleen als `ns.Travel.PrintStatus` bestaat. Offline getest
  (Aramis rang 2 zonder SV, 0 mét; controle Duesten 2). Niet in het spel gezien.

## ▶ VOLGORDE 11 nov (sparring-chat, Rob: "ja, doe het zo"; reden: Robs testtijd is het schaarste)

Eén stap af en door Rob getest, dan de volgende.
a. Judgement en de class-quests afmaken (`docs/forever/FOREVER_QUEST_LOCKED_SPELLS_2026-11-11.md`; Seal-tip, Claw-fix
   `ForeverTrainerData.lua:86`, "komt van een quest" bij de quest-spells).
b. Groene pijltjes + tooltip-regel (BagUpgrade/LootUpgrade) ook in Forever — eerst meten: kan het op de rekenaar van
   `ForeverQuestHint` (`ns.FOREVER_MAIN_STATS`), of is `ns.GetLootUpgradeInfo` daar bruikbaar; werkt de bag-hook in Forever.
   Groot werk → melden en achter c zetten.
c. Opdracht 7: `/mh selftest` + vensterlijst (hieronder).
d. De melding bij het oppakken van een upgrade.
e. Zygor-wachter (Rob: ja), zoals `handynotes_watch`, alle zones, via de voordeur, als stap in `docs/OCHTENDRONDE.md`.

## ▶ OPEN OPDRACHT: `/mh selftest` + vensterlijst (opdracht 7, sparring-chat; Rob: "niks later", dus al op 11 nov)

Volledige tekst: **`docs/OPDRACHT_SELFTEST_2026-11-11.md`**. Begin met fase 0 (meten en voorstellen, niets bouwen): de
nummerbron van `data_check.py` C2, welke client-functies betrouwbaar "bestaat" zeggen in Midnight en Forever, en of
`SCALABLE_WINDOWS` een bruikbare vensterlijst is. Vraag Rob eerst zelf of het mag (zijn ja kwam via de sparring-chat).
De Judgement-uitzoekklus (mh-research, 11 nov) gaat voor.

## 🆕 11 nov — goedemorgen-ronde uit CLAUDE.md naar `docs/OCHTENDRONDE.md` (opdracht B sparring-chat; Rob: "Ja, doe het")

- Het blok "Als Rob goedemorgen zegt" (128 regels, incl. de wachter-tabel) ongewijzigd naar `docs/CLAUDE_HISTORIE.md`
  (bovenaan; script-controle: tekst volledig aanwezig). Nieuw `docs/OCHTENDRONDE.md`: 19 stappen + harde regels, elk met één
  zin waarom; ook leesbaar voor een cloud-chat vanaf Robs telefoon. Reparaties: `run addon_updates` via `probe_job.txt`;
  `git pull --rebase` zonder `origin main` (gaf vanochtend "Cannot rebase onto multiple branches", GEMETEN).
- In CLAUDE.md een blok van 6 regels; de wachter-tabel staat alleen nog in `docs/REGIE.md` tabel 1. De SITE_SEIN-regel
  (elke nieuwe functie/tag/upload) stond alleen in het oude blok: teruggezet als één regel. **CLAUDE.md: 431 → 311 regels**
  (lint [24] nu onder 350).
- ✅ Recept `/nieuwe-chat` (`~/.claude/skills/nieuwe-chat/SKILL.md`) wijst nu naar `docs/OCHTENDRONDE.md` (Rob: "Ja, pas
  aan"). `/verder` zegt alleen "doe het ochtendritueel", zonder bestand: hoeft niet. REGIE.md tabel 2 mist OCHTENDRONDE.md en CLAUDE_HISTORIE.md
  (schrijver bouwchat): doorgegeven aan de sparring-chat/regisseur.

## 🆕 11 nov — CLAUDE.md korter: het shell-deel (opdracht A sparring-chat; Rob: "Ja, doe het")

- GEMETEN: `tools/bash_guard.py` draait als PreToolUse-hook (`AddOns/.claude/settings.json`, matcher Bash|PowerShell) en
  blokkeert `&&`, `||`, `;`, pijp, heredoc, `python -c`, `python -` en de PowerShell-tool. NIET: redirects (`2>&1`, `>`),
  argumenten achter `_probe.py`/`git_stage.py`, git met paden, directe scriptpaden, extra vlaggen.
- Het shell-deel (137 regels, "26 sep `_probe.py`" t/m de 15-aug-meting) ongewijzigd naar nieuw `docs/CLAUDE_HISTORIE.md`
  (script-controle: oude tekst daar volledig aanwezig, weg uit CLAUDE.md). Ervoor in de plaats een blok van 25 regels met de
  12 niet-afgedwongen regels + één regel over wat de guard afdwingt. **CLAUDE.md: 543 → 431 regels.**
- Lint [24]: SOFT als CLAUDE.md > 350 regels (Rob: "350 is goed"); nu 81 erboven. Volgende happen (goedemorgen-ronde naar
  een recept, overige geschiedenis) komen als aparte opdrachten van de sparring-chat.

## 🆕 11 nov — Forever: reisplanner in het spel + "geen Hearthstone" (Rob: "bouw het maar")

- Rob testte de reisplanner met een Horde-Paladin in Tirisfal → Hanashi/Sayoc (Orgrimmar): pijl en venster zeggen "the
  zeppelin to Durotar"; MH-doel 60.70,58.76 vs zeppelin-pin op zijn kaart 60.04,59.46 (GEMETEN, < 1 kaartpunt). Niet
  doorgereisd: geen Hearthstone. Rest (Durotar → Orgrimmar, Alliance, "(loading...)") later, met een character mét Hearthstone.
- Nieuw in `ForeverTravel.lua`: gaat het plan over het water (boot/zeppelin/loop/sky; tram en portaal niet) en is
  `GetItemCount(6948)` = 0 → `FTRAVEL_NO_HEARTH` achter de "way there"-zin, één chatregel `FTRAVEL_NO_HEARTH_CHAT` per
  doel per sessie (in `ns.BuildTravelPlan`, dus alleen als de pijl een plan vraagt), `/mh travel` toont het aantal en het
  oordeel. Onleesbare telling = niets zeggen. Item 6948 + namen per taal GEMETEN in de Forever-DB2. Syntax OK.
- Niet gedaan: de tip "een herbergier geeft je een nieuwe" — niet gemeten, dus niet in de tekst.

## 🆕 11 nov — Forever: Enhancement Shaman altijd Strength (Rob: "Ja, repareer")

- Vondst van de content-wachter (Forever-inhaalronde, `docs/CONTENT_WATCH.md` 11 nov): Blizzard, blue post 6 nov +
  hotfix 10 nov (Mental Dexterity terug naar 33/66/100% van Int) wil Strength als beste stat. MH's `later`-omslag naar
  Intellect bij Mental Dexterity deed het omgekeerde. `ForeverMainStats.lua`: de `later` voor SHAMAN weg, main blijft
  Strength, Intellect. Bron gelezen via zoekmachine op meerdere sites, niet in de client. Syntax OK. TESTLIJST 11 nov.
- Niet nagekeken: of de Paladin-omslag (Champion of the Light) en de Hunter-omslag (Careful Aim) nog kloppen.
- Bijwerken bij gelegenheid: `docs/forever/FOREVER_MAIN_STATS_2026-11-07.md` noemt de oude omslag nog.

## 🆕 11 nov — de regisseur (Rob: "Ja, bouw hem"; opdracht `docs/OPDRACHT_REGISSEUR_2026-11-11.md`)

- Van de brainstorm-tak naar main: `docs/REGIE.md`, de opdracht, plan deel 8. Dit bestand eerst gesplitst (1547 → 1292;
  284 regels naar het archief, kop "☀️ 5 nov — ochtendronde"). `tools/split_handoff.py` weigerde eerst: het archief
  had CRLF-regeleindes, het script zocht exact `---\n`; nu tolerant.
- Recept `C:\Users\RobHu\.claude\skills\regisseur\SKILL.md`. Routine **MH regie** `trig_017LQWJNvptK8hWLuByuEDzg`,
  06:20 Parijs, Sonnet 5.5, omgeving "Midnight Helper", bronnen MidnightHelper + midnighthelper-site (lezen), geen
  connectoren, schrijft alleen `docs/REGIE.md`. Content-wachter duurt 3–10 min (GEMETEN, list_runs), dus 06:20 is ná alle vier.
- ✅ Telefoonmelding (Rob: "Ja, ik wil wel een telefoonmelding … pas om 8 uur 's morgens"): de PushNotification-tool
  heeft geen stille stand (GEMETEN in zijn schema), dus de routine draait nu om **08:15** en meldt alleen bij iets onder
  "Raakt Rob" of een nieuw punt onder "Scheef". `PushNotification` toegevoegd aan allowed_tools (zoals "In the game now",
  geheugen site-now-news-auto). Of de melding echt aankomt: eerste run 12 nov 08:15, nog niet gezien.
  ⚠️ Zondag draait de ideeënbus om 08:00; de regisseur om 08:15 kan die run dan net missen.
- Robs ja voor de 9 wachtende site-commits ("Ja, push dat maar") letterlijk doorgegeven aan «Site chat 11-11»; die pusht zelf.
- ✅ Regisseur starten vanuit Home Assistant (Rob: "draai hem nu maar, want ik ben wakker" → "Ja, bouw het"). GEMETEN 11 nov
  09:55: HA → 200 `routine_fire`, sessie cse_01AezjghcPmsyBweoY6UXhYj.
  - Routine heeft een API-trigger; sleutel (alleen voor deze routine) door Rob gemaakt en in HA `secrets.yaml` als
    `regie_bearer: "Bearer …"`. Eerste test 401 (sleutel fout), na Robs correctie + `rest_command.reload` 200.
  - HA: `packages/regie.yaml` (door Rob geplakt: de HA-koppeling mag geen `rest_command` schrijven) →
    `rest_command.regie_nu`; `script.regisseur_nu_draaien` (bij een fout een stille melding, Android `importance: low`);
    `automation.mh_regisseur_draaien_zodra_rob_wakker_is` (rob_slapen → uit, of 06:20; alleen 06:20–08:15; dus hooguit
    één keer per ochtend); dashboard MH HQ, blok "Snel naar": knoppen "Regisseur nu" (met bevestiging) en "Regie-verslag".
  - De vaste ronde om 08:15 blijft als vangnet; een tweede ronde zonder nieuws stuurt geen melding.

## 🆕 11 nov — C4: spelnamen per taal (Rob: "Ja, alle drie")

- 65 → 3 nakijken (GEMETEN, `run data_check --c4 --all`). mh-writer herschreef 41 waarden in de/fr/es/pt/it/ru, elke naam
  uit de DB2 van die taal (live 12.1.5.70783). Lint 0 HARD, syntax OK. Niet in een client gezien → TESTLIJST 11 nov.
- `tools/data_check.py` kreeg `C4_IGNORE` (per sleutel, met reden, wordt elke run geprint): CRAFTSHOP_MAKING,
  LAYOUT_CARD_BUILDER, SETTINGS_SECTION_GENERAL, SET_BTN_TEST, TOUR_CODEX_NAV, DAWNCREST_TIER_CHAMPION (deDE client =
  "Morgenlichtwappen des Champions", CurrencyTypes 3343 GEMETEN), SMC_SEARCH_PORTALS (zoekwoorden bevatten nu de
  clientnaam), GUIDE_CONS_TYPE_HEALING (Midnight-drankjes ItemSparse 241304: Heiltrank/soins/sanación/Vida/лечебное).
- Bewust open (3): deDE DELVE_NAME_LABYRINTH / DELVE_NAME_RING_OF_GLORY, esES DELVE_NAME_RING_OF_GLORY. De clientnaam heeft
  een lidwoord, maar dezelfde sleutel gaat ook in DELVE_SHARE_CONFIRM_FMT (via ns:GetDelveChatDisplayName,
  DelvePartyShare.lua:403) → "für Das Labyrinth". Oplossing = aparte label-sleutel. ▶ Rob kiest.
- ▶ Rob kiest ook: dezelfde OUDE naam staat nog in andere sleutels van hetzelfde pack (niet aangeraakt). Grootste groepen:
  itIT "Omnium Folio" ~14×, ruRU "Field Accolades" ~17× en "Malevolent Boons" 7×, frFR/esES/ptBR Trading Post-ondertitels
  (3× elk), "L00T RAID-R" in CODEX_CUR_UNDERCOIN_BODY (6 talen), "Gesundheitstrank"/"Poción de salud"/"Зелье здоровья"
  in CONSREADY_HPOT. Volledige lijst: `docs/C4_OUDE_NAMEN_2026-11-11.md`.

## 🆕 11 nov — de vier ochtendwachters dekken ook Forever (Rob: "Yeah", op het voorstel van de brainstorm-chat)

- Nieuw `docs/WATCHER_FOREVER.md`: per wachter een Forever-deel (content toetst Forever-hotfixes aan Modules/Forever* en de
  F*-sleutels; data: "anything Classic" telt niet meer voor Forever; PTR: wat er voor Forever komt, wowf-builds; API: de
  Camelot-toc). Plus een eenmalige inhaalronde, alleen geldig op 2026-11-11 als de gewone regel van die dag er al staat.
- Elke opdracht kreeg alleen een slotalinea die naar dat bestand wijst (byte-controle: zie hieronder). CLAUDE.md: één zin.


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
