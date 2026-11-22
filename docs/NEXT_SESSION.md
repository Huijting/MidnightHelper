# Midnight Helper — waar we staan

## ▶▶ VOLGENDE BOUWCHAT (21 nov, avond): nieuwe Forever-reeks "leren van Polestar/FlowUp" — punt 2 en 4 GEBOUWD, 1 = B (meting staat klaar), 3 onderzocht (niet te meten)

🗳️ **Robs keuzes 22 nov (via Sparring 22-11, letterlijk: *"1 b"* en *"reparatie A, briefjes laten"*):**
- **Punt 1 = B:** onbekende recepten "Waar haal je dit" (beroepenvenster + tooltip; trainer = pijl, verkoop na onderzoek
  per recept) + reagentia in de tooltip (Trade Supplies met pijl / verzamelberoep / monsters zonder plek). Weet MH het
  niet: zwijgen. Meting klaar: `/mh skillup source` → `ns.db.recipeSourceProbe` (offline getest, wacht op Rob).
  Reagentia hangt niet van die meting af: mag gebouwd worden.
- **/mh rest-reparatie = A:** mee met de volgende gewone release (geen 5.7.1, geen go voor een release).
- **Notion-briefjes 12 nov:** blijven staan, niet opnieuw vragen. Boot/zeppelin A/B en de ideeën: nog open.

⛴️ **Punt 3 boot/zeppelin ONDERZOCHT (22 nov): nu niet eerlijk te meten, niets gebouwd.**
`docs/forever/BOOT_ZEPPELIN_2026-11-22.md`. Rondetijd is af te leiden; waar het schip NU is niet (geen API gevonden).
Misschien aftellen na één waargenomen aankomst: hangt aan een meting van 12 minuten in het spel (macro in dat bestand).
Keuze ligt bij Rob via sparring: A) laten rusten (advies) of B) die meting doen. Niet bouwen vóór zijn keuze.

⏱️ **Punt 4 XP per uur GEBOUWD (Bouwchat 21-11 (2)), nagekeken en gerepareerd (Bouwchat 22-11, 22 nov ochtend)** — wacht
op Robs test (TESTLIJST "21 nov (nacht)"). De pc ging 21 nov 23:22 uit vóór lint en commit; 22 nov nagelopen.
- `Modules/ForeverXPRate.lua`: regel onder de XP-balk + tooltip, schakelaar FXPRATE_SW, `/mh rest xp`.
- Bij het nakijken gevonden met een offline test (nep-client; 6 van 15 gevallen faalden, nu 15 van 15 goed):
  (a) het venster werd langer dan een uur na stilstand (3 uur stil + 30 min XP gaf 2857 i.p.v. 9999 per uur),
  (b) level-up: liep UnitLevel of UnitXPMax een update achter, dan telde hij een balk te weinig of te veel,
  (c) max 0 bij inloggen telde de hele balk als winst. NIET gemeten: de echte volgorde van die waarden in Forever.
- Vertalingen GEMETEN: 9 van 9 keys laden en formatteren in de/fr/es/pt/ru. ⚠️ `locale_probe.lua` zegt "still English"
  voor deze keys: hij laadt de Forever-packs niet.

🐞 **`/mh rest off|on|test|mana|health` was kapot sinds edb0f37 (20 nov), zit in v5.7.0 (GEMETEN: tag --contains)** —
ForeverRestXP.lua definieerde `ns.ForeverRestSlash` opnieuw en laadt na ForeverWarnings.lua. Nu `ns.ForeverRestXPSlash`;
kale `/mh rest` print beide diagnoses. GEREPAREERD op main, NIET in het spel gezien; of er een release komt beslist Rob.
In de Camelot-toc is dit de enige dubbele `function ns.X` (GEMETEN 22 nov, nu 0).

☀️ **Ochtendronde 22 nov gedaan (Bouwchat 22-11).** GEMETEN: CurseForge 0 wachtend, GitHub 0 open, site-mail 0 (3 dagen),
BOUW_VRAAG 0 open, wachters 0 MOET GEFIKST, HandyNotes 173 zonder zone-wijziging, Zygor: ingangen Drowned City/Krol'dok
kloppen al in MH, dungeon-quests blijft 519. Notion-inbak: 4 regels "Nieuw" van 12 nov. SITE_SEIN 5.7.0: 14 blokken op
"ja" (staan in de releasetekst), Waylaid Crates blijft "nee". Event-snapshot ververst (live 70961 / ptr 71087 / forever
71037). Open uit de ronde:
- [ ] Verlopen tekst "Fabled, only until the week of 27 October" (site-chat 22 nov): DELVE_TIP_LABYRINTH_BOSS +
      CODEX_LABYRINTH_BODY, met alle taalpacks en esMX; dan check_drift.
- [ ] Nachtcontrole C2 blinde vlek 24 -> 290 -> 774: uitzoeken. Draaiboek 12.1.7 zegt nog "testdata" (release 1/2 dec).
- [ ] Ideeënbus: 2 voorstellen van 15 nov + wat vandaag 08:06 komt, maandag 23 nov aan Rob voorleggen.
- [ ] Commentaar ForeverCharKey.lua zegt "Forever toc only", staat in beide tocs (gedrag goed).

✂️ **Dit bestand is over de 1500 regels, op 22 nov nog NIET gesplitst**: de oudste sectie is van 18 nov (4 dagen, de regel
zegt "ongeveer een week") en "Bouwchat 18-11" heeft open punten die niet in de kop staan, dus uit de index zouden vallen.
Voorgelegd aan Sparring 22-11; anders knippen op 25 nov bij "## ▶ 18 nov — Bouwchat 18-11", eerst die punten nalopen.

🗺️ **Punt 2 dungeon-quests GEBOUWD (Bouwchat 21-11 (2), 21 nov avond)** — wacht op Robs test (TESTLIJST "21 nov (avond)").
- Data: `tools/build_dungeon_quests.py` (`run build_dungeon_quests [--write]`) → `Modules/ForeverDungeonQuestsData.lua`
  (gegenereerd, niet met de hand bewerken). Bron: Zygors eigen "Dungeon Guides\Dungeon Quests\..."-gidsen in
  `_forever_\...\ZygorGuidesViewerForever\Guides-Forever\Dungeons\ZygorDungeon{Alliance,Horde}CLASSIC.lua` (GEMETEN:
  32 van onze 35 dungeons, 519 quests; geen gids voor Alcaz, Blackmaw, Shaper's Terrace). `prev` uit Spoken
  Compendium.lua (CC BY 4.0-deel van Efficient Games, vermeld in de kop). Zone → UiMap GEMETEN (wago UiMap
  1.60.1.71037, 42 zones).
  🔁 Ombouw dezelfde avond (sparring: *"neem alleen feiten mee ... geen Zygor-zinnen of -notities in MH's bestanden"*):
  uit Zygor alleen id's, coördinaten en volgorde. Questnaam = client (GetTitleForQuestID); Engelse terugval `en` uit
  Spoken (486) of de Wowhead Forever-tooltip (33), 0 zonder. NPC-namen = Blizzard-namen uit de Wowhead Forever-tooltips
  per taal (enUS 240 van 242; eigen naam de 100, fr 119, es 169, pt 199, ru 240). Objecten zonder naam
  (FDQ_FROM_OBJECT, 7 talen, zelf vertaald). Spoken corrigeert zelfs een titel: 886 "The Barrens Oases".
- `Modules/ForeverDungeonQuests.lua`: per quest done / in log / inside / later (prev niet af) / now; "|or"-varianten met
  dezelfde titel tellen als één. Overzicht → Dungeons: knop "Quests N" (N = nu op te halen) onder Way/Bosses; venster met
  "Way ›" per op te halen quest. `/mh dungeons quests [key]`, `/mh dungeons quests check [key]`.
- Offline test GESLAAGD (nep-questlog: prev-keten, |or-variant, kant-filter, geen-lijst = nil). NIET gemeten: Zygors
  coördinaten in het spel, of elke Spoken-`prev` klopt, of GetTitleForQuestID in Forever de clientnaam geeft.
  Questlevels zitten niet in de data (staat in de voetregel van het venster).
- Klasse-filter (`classes`) zit in het script, maar geen enkele dungeon-quest in Zygor heeft er een (alleen de raid-gidsen).

Bouwchat 21-11 stopt hier (context vol). Alles hieronder is gepusht t/m 738de2c; `git status` was schoon. 5.7.0 staat op
CurseForge (9734057 / 9734079) en op de site.
Rob via sparring, letterlijk: *"ik blijf bij Zygor, Polestar probeer ik later. maar kunnen wij er iets van leren /
verbeteren"* → op sparrings 5 voorstellen: *"2 en 1, doe maar, daarna 3 en 4 :)"*. ⚠️ Polestar = GPLv3: alleen het IDEE,
geen code/tekst/data. FlowUp-routes = ARR: niets overnemen. Per punt: eerst kort uitzoeken → echte keuze = opties naar
sparring; anders bouwen. Lint, 7 talen, IDEEEN (Robs zin staat er), TESTLIJST, push mag, geen tag. Meld per punt kort.
1. **(punt 2) Dungeon-quests** — per dungeon in de dungeon-gids/Dungeons-lijst "haal eerst deze quests op": quest,
   level, questgever + plek met Show the way, en of je hem al hebt/gedaan hebt. GEMETEN 21 nov: ForeverDungeons.lua en
   ForeverDungeonGuide.lua hebben GEEN dungeon-quests (grep "quest": alleen UI-texturen); ForeverDungeonGuideData.lua noemt
   quests alleen in baas-opmerkingen (`-- src:`-regels, bv. regel 960 Sergeant Bly). Dus nieuwe data: DB2 QuestV2 /
   Wowhead Forever-tooltips (`run gamedata`) / Zygor lokaal / HandyNotes; coördinatenregel uit het geheugen.
2. **(punt 1) ✅ Rob 22 nov: *"1 b"*, zie boven. "Waar haal ik dit vandaan?"** bij item/recept/mount/pet (zoekbalk + tooltip): verkoper, drop, quest, beroep,
   trainer, met Show the way. Midnight heeft het voor recepten (`CraftShoppingList.lua`, CRAFTSHOP_UNLEARNED,
   CHANGELOG_474_3) — hergebruik waar het kan. Klein beginnen (recepten + reagents + mounts?) en zeggen wat de data toelaat.
3. **(punt 3) Boot/zeppelin-wachttijd** "komt over ~N s": eerst uitzoeken of het meetbaar is (transport-objecten, vaste
   cyclustijd per route); anders eerlijk "niet te meten". ✅ ONDERZOCHT 22 nov: niet te meten zonder meting in het spel,
   zie boven.
4. **(punt 4) XP per uur + tijd tot volgend level** (overzicht, met een schakelaar): ✅ GEBOUWD, zie boven.

## ▶▶ VOLGENDE BOUWCHAT: Forever-overzicht "D" — stap 1 en 3 gebouwd; stap 2 wacht op Robs screenshots (20 nov, avond)

🛡️ **Level als X, tank als Y + respec/Dual Spec + Wolfsbane + tankstats (21 nov)** — Rob via sparring, GO letterlijk:
*"Ja, voeg dat maar toe en laat het maar uitvoeren ook. Ik vind dat wel iets belangrijks eigenlijk."* Bronnen + G/A per
regel: `docs/forever/TANK_LEVELEN_2026-11-21.md`. Gebouwd: `PLANS` in ForeverHowToPlay.lua (Paladin/Warrior/Druid, altijd
open bovenaan How you play, ook op de overzichtspagina als kind "role"); COMMON-sectie 4 "Talents: reset and Dual Spec"
(COMMON valt nu PER SECTIE terug op Engels, zodat een nieuwe sectie ook zonder vertaling verschijnt). Do this now:
`FDONOW_WOLFSBANE_FMT` (Paladin, Wolfsbane-keten niet klaar, spell 202 niet bekend; tip 18-19, to-do vanaf 20; knop =
Find op Two-Handed Swords + pijl naar de dichtste wapenmeester) en `FDONOW_DUALSPEC` (tip vanaf 40 zolang 63644 niet
bekend; knop naar de class-trainer). `/mh donow check` print 202 en 63644. Tankstats Paladin: Stamina > Intellect (was
> Strength). GEMETEN: wissel 63644/63645 = 5 s (SpellCastTimes 6). NIET gemeten: of IsPlayerSpell(63644) na het kopen
true geeft; of de druid-klassequest Growl ook geeft. Vertalingen KLAAR (mh-writer, 7 talen + esMX, niet door een
moedertaalspreker nagekeken): ForeverHowToPlay_<code> (PLANS + COMMON[4]) en ForeverClassQuests_<code> (2 FDONOW-keys).
Daarbij gerepareerd: esES Wolfsbane = "Aterralobos" (Wowhead Forever); Archibald heet in ptBR "Arquibaldo", ruRU
"Арчибальд" (in de Wolfsbane-regel; de Find-rij van de wapenmeester toont nog overal "Archibald"). ⚠️ esES SpellName
202 zegt "Mazas de dos manos" (Blizzard-fout?); de teksten gebruiken "Espadas de dos manos" (SkillLine 55, esMX).

🐞 **`/mh arrow` "Zygor geladen" in Forever (21 nov)** — bijvangst mh-research via sparring: NativeArrow.lua vroeg alleen
"ZygorGuidesViewer"; in Forever heet hij "ZygorGuidesViewerForever" (GEMETEN: de .toc in `_forever_\Interface\AddOns`).
Nu beide namen. Alleen de diagnoseregel; MH wijkt niet voor Zygor. NIET in het spel gezien.

🎯 **Volgend talentpunt: ALLE classes, per class (21 nov, bezig)** — Rob via sparring, letterlijk: *"het puntensysteem,
waar ga ik welk punt in stoppen, moet natuurlijk wel uitgebreid worden. Ik zit nu bijvoorbeeld op mijn shamaan, die is
level 11. Ik mag 2 punten indelen ... Ga ermee aan de slag"*. Fable pas aan het eind, één controleronde over alle
volgordes (Rob: *"misschien dat we die gewoon aan het einde even overheen gooien"*); eerst melden bij sparring.
- ✅ **Shaman** (tree 1082): Enhancement = Mobalytics/Tiqqle 13 nov (22 stappen, 6 van 7 gidsen Enhancement);
  Restoration = stillsixty 2 nov (18 stappen, Riptide stap 13). Ids GEMETEN (mh-research), 3 nagemeten.
  ⚠️ Stormstrike: gidsen op 25, client-SpellLevels zegt 40 (niet verlaagd, i.t.t. Mana Tide 40→1). Nu: een stap die de
  client weigert (`canPurchaseRank == false`, AFGELEID dat Forever dat veld vult) wordt overgeslagen, de volgende komt;
  `/mh talent` zegt het. NIET gemeten wat het spel doet.
- Standaardrichting zonder keuze = de levelboom uit How you play voor elke class (`DEFAULT`).
- ✅ **Warrior** (tree 1117): Protection = timesaver.gg/Maxroll 4 nov (20 stappen; meeste gidsen: Prot levelt het
  snelst, SixtySim: Arms); Arms = Mobalytics/Ahlaundoh 19 nov (24 stappen, Mortal Strike op 40).
- ✅ **Druid** (tree 1089): Feral (kat) = Mobalytics/yumytv 14 nov (21 stappen, Shifting Power op 40); Restoration =
  timesaver.gg/Maxroll 3 nov (19 stappen, Wild Growth stap 12). Geen talent vóór zijn SpellLevels (GEMETEN door
  mh-research). ⚠️ Open: wat Talented (Legacy) met SpellLevels doet (rij 7 op 35 i.p.v. 40?) — niet gemeten.
- ✅ **Hunter** (tree 1091): Beast Mastery = Mobalytics/Feor 18 nov (21 stappen, Bestial Wrath op 40). Geen tweede
  volgorde (geen duidelijk groepsadvies). ⚠️ How you play zegt "Every guide we read picks Beast Mastery": mh-research
  vindt dat te sterk (Wowhead: alle drie doen goed mee). GEREPAREERD (sparring: feitencorrectie): "Most guides pick
  Beast Mastery … Wowhead adds that all three trees work.", in het Engels + 7 talen (8/8 GEMETEN met grep, oude zin 0×).
- ✅ **Rogue** (tree 1111): Combat = Mobalytics/Djexde 12 nov (25 stappen, Adrenaline Rush op 42). Geen tweede volgorde.
- ✅ **Priest** (tree 1114): Shadow = MMOJUGG 13 nov (21 stappen, Shadowform op 42); Holy = warcraftmaps 17 nov
  (21 stappen, Prayer of Mending stap 14; 4:2 Holy boven Disc voor dungeons). ⚠️ Vampiric Embrace op 27, SpellLevels 30
  (overslaan-logica vangt het op als het spel weigert).
- ✅ **Mage** (tree 1112): Frost = GrindClassic 20 nov (24 stappen, Ice Barrier op 40). Geen tweede (geen eensgezind
  groepsadvies).
- ✅ **Warlock** (tree 1116): Affliction = Mobalytics/Crix 21 nov (20 stappen, Wrack op 40); Destruction (alleen bij die
  richting) = wofwforever 9 nov (19 stappen, Incinerate stap 13).
- ✅ **Fable-controle (21 nov, sparring: "Ja, de Fable-ronde mag nu")**: alle 15 volgordes, 314 stappen, 765 punten —
  ids, rangen, banden, volgorde t.o.v. de bronpagina (gelezen), rijgrenzen en voorgangers: allemaal OK (GEMETEN, twee
  checkers + negatieve controles). Niets aan ORDERS veranderd. Open blijft (data beslist het niet): Stormstrike
  SpellLevels 40 (onveranderd uit Classic Era; meerdere gidsen na launch: 25) en Vampiric Embrace 30 (in Forever
  verhoogd van 1; gidsen 25-27). AFGELEID: beide waarschijnlijk kiesbaar. Risico zit in de terugval: die werkt alleen als
  de client `canPurchaseRank = false` meldt. Daarom toont `/mh talent` nu per stap "can buy: …" — Robs test beslist het.

🚀 **RELEASE 5.7.0 (21 nov)** — Rob via sparring, letterlijk: *"reload gedaan, tekst staat goed, go voor 5.7.0"*. Geen
beta. Beide .toc 5.7.0, CHANGELOG_570_1-13, RELEASE_NOTES = CURSEFORGE_5.7.0 (diff leeg), CHANGELOG.md, SITE_SEIN (alle
regels sinds 5.6.0 → getagd). Waylaid Crates + mage Study-tip zitten in de zip, NIET in de tekst. Run + CF-bestanden:
zie SITE_SEIN zodra gemeten.

🐞 **Dungeons-lijst: routetekst liep onder Way/Bosses (21 nov)** — Rob, screenshot: *"Er loopt tekst door elkaar heen."*
GEMETEN in de code: `DungeonRow` route begint 70 px in (chip 2+58, gat 10) maar had breedte rowW-80 → eindigde 70 px te ver
rechts, onder de knoppenkolom (70 breed, 2 van rechts). Nu rowW-150 (vaste breedte, want de rijhoogte wordt direct na
SetText gemeten). Nagelopen, zelfde opbouw: FindRow (route onder de knop, die één rij hoog is: geen overlap), macro-rijen
(rowW-112 bij knoppen 96: vrij). NIET in het spel gezien.

✨ **Smart Buff-macro voor Mage, Priest, Druid (21 nov)** — Rob via sparring: *"Kunnen wij ook een soort mouse-over macro
maken voor de andere buffs, voor alle andere classes."* GO letterlijk: *"Ja, wou het maar."* `Modules/ForeverSmartBuff.lua`:
macro "MH Smart Buff" = `#showtooltip` + `/cast [@mouseover,help,nodead][@target,help,nodead] <clientnaam>` + een
/run-hintregel als niemand vriendelijk onder de muis/doelwit is (valt weg als de macro > 255 tekens wordt). EditMacro
buiten combat (PLAYER_ENTERING_WORLD, PLAYER_REGEN_ENABLED, SPELLS_CHANGED). Buffs GEMETEN in ns.FOREVER_SPELL_IDS:
Arcane Intellect, Power Word: Fortitude, Mark of the Wild. Warlock/Shaman (alleen water-spells), Warrior/Rogue/Hunter:
geen macro, de schakelaar zegt het. Paladin = Smart Bless. Overlap: ForeverBlock MO_HELP (mouseover-stand van het
toetsenblok) heeft deze buffs al op zijn eigen toetsen. Schakelaar FSBUFF_SW (standaard uit), `/mh smartbuff [on|off]`.
Offline test GESLAAGD. NIET gemeten: één spell na twee voorwaarden in Forever (AFGELEID, zelfde syntax).
🔧 Daarbij: Wolfsbane/Dual Spec-check gebruikt nu C_SpellBook.IsSpellKnown eerst (IsPlayerSpell is in Forever alleen
een deprecation-fallback, ForeverBlock.lua KnownId); `/mh donow check` toont alle drie.

🎯 **Volgend talentpunt in Do this now (21 nov, GEBOUWD voor Paladin)** — Rob via sparring, letterlijk: *"Ja, doe dat maar"* op
"'Do this now' zegt bij elk nieuw level welk talent je nu moet kiezen". `Modules/ForeverTalentNext.lua`: alleen bij een
vrij punt (GetTreeCurrencyInfo tree 1100, valuta 3820), richting → volgorde, eerste stap die nog niet af is
(GetNodeInfo.ranksPurchased). Schakelaar FTALENT_SW, `/mh talent`, knop opent het talentvenster (AFGELEID). Offline test
GESLAAGD (nepvolgorde + controle op de echte data). ORDERS Paladin: Ret (band 3) = guided.news 21 nov, 19 stappen tot 60;
Prot (band 2) = stillsixty.com 17 nov, 20 stappen (Shieldsworn = stap 14, op 40). Node/spell-ids GEMETEN door
mh-research in DB2 71037, 3 entries→nodes door de bouwchat nagemeten. Geen richting = Ret + zin "(You chose no
direction …)". Holy = geen volgorde → stil. Dual Spec-tip zegt bij Paladin: tweede set Protection + richting
Protection kiezen. 🔜 Andere classes: zelfde vorm, per class mh-research (nog NIET gedaan). NIET gemeten in het spel:
of GetTreeCurrencyInfo(cfg, 1100) de vrije punten geeft (anders stil; `/mh talent` zegt waarom).

🔎 **Zoeken springt naar de schakelaar + "for WoW Forever" (21 nov)** — Rob via sparring, letterlijk: *"Wat ik dan krijg
is het lange overzicht. Dan moet ik eerst gaan scrollen naar beneden en kijken waar staat hij ook weer. ... Dat moet
volgens mij beter kunnen."* en *"waarom staat er niet onder Forever versie ... Iets dat duidelijk maakt dat het echt voor
Forever is."* Gebouwd in `ForeverOverview.lua`: een zoektreffer op een Quiet helpers-schakelaar → `FocusQuietRow(i)`:
opent de pagina, scrollt de regel naar een derde van boven en laat hem 2 s goud oplichten (vlak + streep links,
`FlashQuietRow`). Elke rij onthoudt `_y/_h` in FillQuietPage. Extra zoekwoorden `QUIET_WORDS` (spar/ore/herb/glow/node/
mining/herbalism) voor FLS_SW, FNODE_ICON_SW, FNODE_GLOW_SW. Ondertitel `FOV_SUBTITLE` onder "MIDNIGHT HELPER" (beide
layouts, zelfde titelregel), 7 talen. Andere zoektreffers (tabs, Find, Tools) springen nog alleen naar de pagina.
NIET gemeten in het spel: of de ondertitel in de oude layout vrij van de tabs blijft (11 px tussen -37 en -50), en of het
scrollen meteen raak is (tweede poging na 0,05 s als het scrollbereik nog 0 is).

✅ **Charkey GESLAAGD op twee Ima's (Rob in het spel, 21 nov)** — Ima 2 = Player-6944-0120ED18 (Ima 1 = …0118CB4F), eigen
kopieën, "copies so far 9". Joey en KeyBlock nog niet getest.

⛏️ **Gloed alleen bij wat je kunt verzamelen (21 nov)** — Rob (Paladin, Mining + Blacksmithing, geen Herbalism), letterlijk:
*"eigenlijk zouden we die dingen alleen maar moeten kunnen zien op het moment dat we het ook echt hebben."* GEMETEN in zijn
screenshot: rode ster bij geen Herbalism (optie C werkte). Nu: geen beroep → HideGlow, `/mh sparkle` "skipped: no
Herbalism/Mining"; beroep maar skill te laag → rood blijft (Rob bevestigde, letterlijk: *"Van heb je beroep wel mijn skill
te laag, dan blijft hij rood. En zo hoort het ook."*).
FNODE_GLOW_SW_DESC 7 talen + esMX. ⚠️ Het game-icoon (schakelaar A, CVar SoftTargetIconGameObject) is één aan/uit voor
ALLE objecten; per soort beperken kan met die CVar niet (AFGELEID uit de CVar-lijst; geen per-type CVar gezien in de
meting van 20 nov). 🔧 Even (0c6aea4) liet B het icoon op 0 als A uit stond. Rob MAT het dezelfde dag in het spel
(Paladin, Mining, ertsader, 2 screenshots): A uit + B aan = GEEN game-icoon én GEEN MH-ster; A aan + B aan = beide.
GEMETEN dus: de gloed heeft SoftTargetIconGameObject nodig. Teruggedraaid: B zet het icoon weer zelf aan, uitleg weer
"so the icon comes along" (7 talen + esMX). Een CVar die alleen het icoon verbergt: niet gevonden. Kandidaat (AFGELEID, uit
MFNameplates SoftIcon.lua, geen bewijs): `SoftTargetNameplateSize` = grootte van het soft-target-icoon; 0 zou het icoon
kunnen verbergen, maar misschien ook het naamplaatje waar de gloed op zit. Alleen bouwen na een meting door Rob. Offline
GEMETEN (nodeswitch_test.lua). Overzicht D afgevinkt (Rob: *"dat zag er goed uit"*).

📚 **Study: waar de bibliotheek is GEBOUWD (21 nov)** — Rob: *"Ja, graag"*. mh-research (GEMETEN): Study 1302508 vraagt spell
focus 2309 "Library" (geen gebied, geen factie), 1 Light Feather 17056, 1 uur (SpellCooldowns 3600000). De focus-objecten staan
op de server, niet in DB2. Plekken met spelersmeldingen: Stormwind Mage Tower bij Garion Wendell 211033 (1453 48.9,86.5) en
Undercity Magic Quarter bij Owen Thadd 211022 (1458 73.6,33.0); spawns Wowhead Forever, namen per taal GEMETEN (pt Adélio
Tadeu, ru …). Weggelaten (één bron): Royal Library, Dalaran. Light Feather: GEEN verkoper gevonden (2 gidsen; Wowhead
"Sold by" niet leesbaar) → tekst "drops from birds and harpies". Gebouwd: ForeverProfGuide `FOREVER_LIBRARY_SPOTS`,
`ForeverStudyLibraryLine/FeatherLine`, Comprehension-kaartje +2 regels, Study-spelltooltip (TooltipDataProcessor Spell),
Find-categorie `library` (alleen mages; FindCats filtert op `mage`), Do this now-tip "Study is ready …" als Study gekend is
en geen cooldown heeft. Spellnaam per taal GEMETEN (SpellName DB2: de Studieren, fr Étudier, es/esMX Estudiar, pt Estudar, it
Study, ru Изучение; controle Fireball 133). NIET in het spel gezien; of Study echt werkt bij die bibliothecaris = Robs test.
✅ Ook vandaag: Renown-regel door Rob goedgekeurd (*"Zo is het goed."*); niet-vrijgespeelde tracks nu uit de tooltip.

🏅 **O14 Renown-regel GEREPAREERD (21 nov)** — GEMETEN in Robs Midnight-SV (`renownProbe`, 13:58): GetMajorFactionIDs() zonder
argument = 30 facties van alle uitbreidingen; met LE_EXPANSION_LEVEL_CURRENT (11 = LE_EXPANSION_MIDNIGHT) precies 11:
2696,2699,2704,2710,2742,2764,2772,2792,2796,2808,2836. Na /reload alle velden echt (Amani/Singularity/Hara'ti/Silvermoon 20 max,
Labyrinth 9 max, Preyhunter's Journey 1, Prey 5, Zul'jarra 15 …; 2742 "Delves: Season 1" isUnlocked false). Eerste keer = data
nog niet geladen (AFGELEID uit eerste screenshot vs. meting). Rob: *"Ik vind het geen gezicht."* Nu: alleen de huidige
uitbreiding, dubbele naam eruit, één regel "N of M at max · lowest: X n — point here for all", tooltip gesorteerd (niet-max met
voortgang, dan max, dan locked, dan onleesbaar). Alles "locked" en niets leesbaar = "the game is still loading this" (niet
"not unlocked"); MAJOR_FACTION_RENOWN_LEVEL_CHANGED / MAJOR_FACTION_UNLOCKED / UPDATE_FACTION / PLAYER_ENTERING_WORLD tekenen
de regel 2 s later opnieuw als hij zichtbaar is. 3 nieuwe teksten, 7 talen. NIET in het spel gezien.

🐞 **Tas vol: "Repair & sell"-regel liep door rij 3 GEREPAREERD (21 nov)** — Robs screenshot (Undercity). Oorzaak GEMETEN in de
code: `repInfo` had als tweede anker `LEFT` van het venster = verticaal midden (y −180, rij 3). Nu `LEFT` aan `BOTTOMLEFT` +51
(hoogte van de knop). Hoogte nagerekend (AFGELEID): rijen tot −198, loot + knop tot ~−266, Repair −298..−320, past in 360. ⚠️ Lint [25]: de
registratie (RegisterMidnightDialogPopup) staat nu precies 120 regels na CreateFrame (window_check LOOKAHEAD = 120); één
regel meer in Build() = HARD. Volgende keer: registratie hoger zetten.
Ook GEMETEN goed door Rob vandaag: Comprehend-melding weg, Tas vol Destroy, Midnight login/reload. Renown O14 ❌ → meting
`/mh renown` (renownProbe, ruwe velden per factie + uitbreiding) staat klaar, wacht op Rob.

🐞 **Ranks: "Comprehend Scroll Rank 1; you know Rank 5" GEREPAREERD (21 nov)** — Rob (Troll Frost Mage lvl 10): *"Ik klik hem
aan … Maar hij blijft wel staan. Hoort dat zo?"* GEMETEN (Forever DB2 Spell.NameSubtext_lang): de 5 Comprehend Scroll-ids zijn
geen rangen (1296017 "Comprehension", instant; 4 andere zonder ondertitel, 5 s cast). Zelfde check: 19 van 279 spells met
meerdere ids hebben ids die geen "Rank N" zijn (Polymorph Turtle/Pig, Swipe Cat, talent-kopieën van Execute/Flash of Light/
Holy Light, Cure Poison, Tame Beast …), 52 ids in totaal. `tools/forever_rank_filter.py` → `Modules/ForeverRanksData.lua`
(`ns.FOREVER_NOT_A_RANK`, controle 133 blijft / 1310030 eruit); ForeverRanks.lua Info() telt alleen echte rangen (spell met
< 2 rangen valt weg). ForeverSpellIds zelf ongewijzigd (KeyBlock gebruikt hem om de castbare rang te vinden). Do this now
ververst al bij ACTIONBAR_SLOT_CHANGED (GEMETEN in de code); de melding bleef staan omdat de "nieuwe rang" geen rang was
(AFGELEID: de game laat op de knop de basis-spell zien). NIET in het spel gezien.

🚦 **Afspraak 21 nov: Rob is ziek en test weinig. Bouwen mag gewoon op zijn vragen** (Rob, letterlijk via sparring: *"Nou,
bouwen mogen we natuurlijk altijd wel doen."* — dat vervangt een eerdere "bouwstop" van de sparring).
Minimale test vóór 5.7.0 staat bovenaan TESTLIJST (4 punten). Release-concept bijgewerkt met zeppelin-platforms en Skill
up-tooltips/make-first (CHANGELOG_570_10). Release/tag blijft Robs letterlijke go.

🧭 **Zuid/noord (21 nov, later)** — GEMETEN door Rob: hij nam het ZUIDELIJKE platform van de Orgrimmar-toren en kwam in Tirisfal
aan. MASTERS H1a dir SOUTH, H2a dir NORTH (de andere van twee; de kaart klopt: Frezza y 13,5 > Snurk 12,8) →
FTRAVEL_PLATFORM_SOUTH/NORTH_FMT "(the south platform, with Frezza)", 7 talen. Andere torens: geen richting (niet gemeten).
Skill up: Rob zag kleur + "make first" (afgevinkt); "needs …" nu op een eigen, ingesprongen regel (FSKILL_MAKE_NEEDS_FMT).

🛩️ **Zeppelin-platform ondubbelzinnig GEBOUWD (21 nov)** — Rob bij de toren buiten Orgrimmar: *"Maar er zijn er twee hier. Hoe
weet ik nu precies welke ik moet hebben? Kunnen we het nauwkeuriger maken?"* ForeverTravel.lua `MASTERS` (Wowhead Forever
NPC-tooltips, GEMETEN; HandyNotes en Zygor hebben ze niet, grep met controle): H1a Frezza 9564 (50.8,13.5 → Tirisfal), H2a
Snurk Bucksquick 12136 (50.6,12.8 → STV), H1b Zapetta 9566 (Tirisfal 60.8,58.8 → Orgrimmar), X1b Hin Denburg 3150 (61.8,59.0
→ Grom'gol), H2b Nez'raz 3149 (STV 31.4,29.8 → Orgrimmar), X1a Squibby Overspeck 12137 (31.5,29.4 → Undercity); elk staat naast
de DB2-stop van zijn eigen lijn. Namen per client GEMETEN (es Esnur Ciervoveloz / Petardo Porsiacaso, esMX Snurk Oroveloz, pt
Odete Cobrafrete / Squibby Talotado, ru …). Routestap: punt = de meester, zin + FTRAVEL_PLATFORM_FMT "(the platform with X)"
(7 talen); Find → Travel idem, pijl stopt op 8 yd. "You are at": straal per stop = de helft van de afstand tot de
dichtstbijzijnde andere stop op die kaart, max 2 (was overal 2): Orgrimmar 0,36, Grom'gol 0,21, Auberdine 1,49, Menethil 2
(offline GEMETEN, travel_test.lua). Boten (Auberdine 3 steigers, Menethil 2) hebben geen meester: geen naam, wel de kleinere
straal. Routeplanner zelf NIET offline getest (alleen de straal en Find); NIET in het spel gezien.

🔗 **Tooltips in Skill up + "maak eerst" GEBOUWD (21 nov)** — Rob: *"Wat ik wel mis zie, zijn onze tooltips die we overal zouden
inbouwen."* en op "maak eerst 9 Bolt of Linen Cloth (18 Linen Cloth nodig)": *"Ja, doe dat ook maar"*. Gedeelde helpers in
ForeverItemTips.lua: `ns.ForeverItemLinkText(id)` (echte item-link, kwaliteitskleur), `ns.ForeverSpellLinkText`,
`ns.ForeverHookLinks(frame)` (hover = spel-tooltip, shift-klik = chat). Skill up: recepten = link van het gemaakte item (anders
de spell), ingrediënten = item-links, "enough" groen erachter; tekst niet meer in een ScrollFrame (links werken daar niet,
PlayCardWindow-notitie, NIET hermeten) maar in een clip-frame met muiswiel-scroll, Shift+wiel = schalen. `MakeFirst`: tekort +
recept van HETZELFDE beroep dat je KENT (Knows) → "make N X first (needs …, you have …)", 1 niveau diep, aantal = ceil(tekort /
opbrengst). Offline GEMETEN (skillup_test.lua: Bolt of Linen Cloth 9 → 18 Linen Cloth, onbekend recept / ander beroep = niets;
vond een echte fout: Parse() ontbrak). Ook links/hover in: duurzaamheid-venster, krat-venster, Tas vol loot-regel (rijen hadden
al een tooltip). NIET gedaan: Repair-NPC's en "Deliver crates" — NPC-namen hebben geen spel-link/tooltip. NIET in het spel gezien.

✅ **Smart Bless WERKT (Rob in het spel, 21 nov, na 71521af)** — *"Ja, hij kreeg werkelijk wat ik gaf. Zowel iemand die niet
getarget was, als iemand die wel getarget was."* + *"Oh, dat is dynamisch. Dat is tof zeg."* Macrovenster: "#showtooltip /
/cast [@mouseover,help,nodead] Blessing of Wisdom" (62/255). Afgevinkt; open: chatregel zonder doelwit, `/mh blesstip`-regel.
Release-concept 5.7.0 bijgewerkt (RELEASE_NOTES = CURSEFORGE_5.7.0, CHANGELOG_570_8 + Changelog.lua). Daarna (sparring: charkey
en optie C zijn door Rob gezien) ook erin: erts/kruiden in de Loot Sparkles-regel (zonder "rood": niet getest) en een
bugfix-regel "every character keeps its own settings" (CHANGELOG_570_9). ⚠️ Waylaid Crates staat er NIET in (pas na Robs
test) maar zit bij een tag wél in de zip (alles op main gaat mee). Release blijft Robs go.

📋 **Testlijst in het spel: eerste echte ronde (21 nov)** — Rob gebruikte `/mhtest` in Forever (*"het fancy dat werkt"*), 3× Goed
+ 1 opmerking ("dit is een test"), Reload. `run testlist_ingame read` (proefrun) las ze GEMETEN. Met de hand weggeschreven
(de tool kan geen punt overslaan): optie C groen + `/mh sparkle` last node. NIET weggeschreven: "slimme zegen ook op je
doelwit" — Goed aangeklikt, maar Smart Bless werkte aantoonbaar niet (sparring vraagt Rob; waarschijnlijk misklik). De
testopmerking is weggelaten. Bij de volgende `read --write` komt dat Goed-vinkje opnieuw voorbij: dan eerst Robs antwoord.

🐞 **Smart Bless reparatie 2: MH schrijft de macro zelf (21 nov)** — GEMETEN door Rob na 5213ee8: "presses that reached the
button: 1 · last: 13:05:37, LeftButton up, line: /cast [@mouseover,help,nodead] Blessing of Wisdom; [@target,help,nodead]
Blessing of Wisdom · ActionButtonUseKeyDown = 1" en *"Nee, er gebeurt helemaal niks … Purify kwam wel aan met mijn
muisknop"*, geen foutmelding. Dus: klik bereikt de verborgen knop, regel klopt, maar de route /click → secure macro-knop
cast niets in Forever (WAAROM is NIET gemeten; AFGELEID mogelijk: /click kwam als "up" terwijl de knop met de CVar op 1 op
"down" handelt). Op voorstel van de sparring: `WriteMacro()` zet de regel met EditMacro (buiten combat, alleen bij een
andere regel) als body van "MH Smart Bless": `#showtooltip` + de /cast-regel; geen speler = `/run print("<FBLESS_NONE>")`
(7 talen). Rob drukt nu een gewone macro, zoals zijn Purify. In combat blijft de laatste tekst. `/mh blesstip` toont de
macro-body en "last write". De verborgen knop blijft alleen voor de diagnose. Offline GEMETEN (bless_test.lua, 22 controles).
NIET in het spel gezien.

🐞 **Smart Bless werkte niet met F5 GEREPAREERD (21 nov)** — Rob: *"Ik heb niks gedaan, maar het werkt niet."* De knop
luisterde alleen naar LeftButtonUp (useOnKeyDown false, overgenomen van de Disenchant-knop, die met de muis geklikt wordt).
Een `/click` vanaf een TOETS komt binnen als key-down als ActionButtonUseKeyDown aan staat; die CVar staat niet in Robs
Forever Config.wtf/config-cache.wtf (GEMETEN: afwezig = standaard; standaard 1 in Forever = AFGELEID van retail). Dus een
toets bereikte de knop nooit, een muisklik op het macro-icoon wel → "eerst niet, toen wel" (AFGELEID). Nu
RegisterForClicks("AnyUp","AnyDown") zonder useOnKeyDown-pin (zoals ForeverPartyPanel). Klikteller (HookScript OnClick):
`/mh blesstip` toont "presses that reached the button: N · last: tijd, knop down/up, line: … · ActionButtonUseKeyDown = …".
Offline GEMETEN (bless_test.lua, 16 controles). NIET in het spel gezien.

🔴 **Erts/kruiden optie C GEBOUWD (21 nov)** — GEMETEN door Rob (2 screenshots): ver = grijze ster + grijs bloem-icoon,
dichtbij = groene ster + gekleurd icoon; de grijze kleur kwam dus van afstand. Rob: *"c dus haha"* op "MH kijkt ook naar je
eigen skill … alleen als je het echt niet kunt … wordt hij rood". `tools/forever_nodes.py` → `Modules/ForeverNodeSkillData.lua`
(beide toc's): 74 nodes (41 kruid, 33 erts) met vereiste skill uit Wowhead Forever object-tooltips ("Requires Herbalism
(N)"), GEMETEN; controle 1618 Peacebloom = 1, 1620 Mageroyal = 50. DB2 GameObjects heeft ze niet (GEMETEN). Object-id =
GUID-veld 6 (los patroon). Kleur: cursor "Unable" + geen beroep, of skill < nodig → ROOD; "Unable" maar je kunt het →
normale kleur ("too far away … you can"); onbekende node → beroep geleerd = normale kleur. `/mh sparkle`: "last node: <naam>
(object id), kind, colour, reason, cursor". Uitleg FNODE_GLOW_SW_DESC in 7 talen; beroepsnamen per client GEMETEN (SkillLine
DB2: de Kräuterkunde/Bergbau, fr Herboristerie/Minage, es Botánica/Minería, esMX Herboristería (eigen regel in
Locales/esMX.lua), pt Herborismo/Mineração, it Herbalism/Mining, ru Травничество/Горное дело). Offline GEMETEN
(nodeswitch_test.lua: ver+kan → goud, Tin 65 met Mining 5 → rood, geen Mining → rood, onbekend → goud, dichterbij zonder event).
NIET in het spel gezien.

⛏️ **Witte ster GEREPAREERD (21 nov, later)** — Rob: *"Deze IMA heeft wel herbalism."* Oorzaak (GEMETEN in de code,
AFGELEID dat het Robs geval is): de kleur werd alleen gekozen bij PLAYER_SOFT_INTERACT_CHANGED / NAME_PLATE_UNIT_ADDED, dus
op het moment dat de plant tot 15 m ver werd opgepikt. Daar zegt de cursor "Unable" (te ver; GEMETEN op erts 20 nov) →
grijs, en dat bleef zo terwijl je dichterbij liep. Nu kijkt de gloed 5× per seconde opnieuw zolang hij zichtbaar is
(OnUpdate op het eigen, niet-secure gloed-frame). `/mh sparkle` heeft "last node: <naam>, kind …, colour …, reason …, cursor
…" (reden: "game says Unable: too far away, or skill too low (yours x/y)" / "you have no Herbalism" / "you can pick it")
en schrijft `MidnightHelperDB.foreverNodeLast`. Offline GEMETEN (nodeswitch_test.lua + nieuwe stap: grijs → dichterbij zonder
event → goud). NIET in het spel gezien.

⛏️ **Erts/kruiden-gloed: Rob zag een WITTE ster op Peacebloom (21 nov)** — werkt (bloem-icoon + MH-ster); Lueur is weg
(sparring GEMETEN: map bestaat niet meer). Code (GEMETEN): kleur komt alléén uit de cursor-naam van de game: "unable" erin
→ grijs (0.6, met ADD-blend AFGELEID wit-ogend), anders herb → groen, mine → goud. Of die ster grijs of groen was en waarom,
is NIET gemeten. `/mh sparkle` toont nu ook "colour: …", de cursor-naam van de game, en je Herbalism/Mining (rang of "not
learned"). Volgende stap: Rob staat bij een kruid en typt `/mh sparkle`. Voorstel aan sparring: "kan niet" rood maken i.p.v.
grijs (grijs leest als wit).

✨ **Slimme zegen ook op je doelwit GEBOUWD (21 nov)** — Rob via sparring: *"Als ik iemand geselecteerd heb en die hard
doorloopt, dat ik daarna op F5 druk"* → op "Eerst de muis, anders je doelwit": *"Ja, doe maar."* `ForeverBlessTip.lua`: de
knop is nu type macro met één regel `/cast [@mouseover,help,nodead] <zegen>; [@target,help,nodead] <zegen>` (de game kiest
bij het indrukken; MH schrijft de regel buiten combat bij UPDATE_MOUSEOVER_UNIT en PLAYER_TARGET_CHANGED; deel alleen als
Pick() een vriendelijke SPELER vond). Geen van beide = geen regel, de toets doet niets (keuze: GEEN zelf-cast, niet
gevraagd; gemeld aan sparring). Spellnaam uit de client (C_Spell.GetSpellName), /cast zonder rang = hoogste (AFGELEID, net
als ForeverBlock). `/mh blesstip` toont nu "target now", "target on the button" en "the key runs: …"; probe slaat target +
regel op. Pick splitst nu de reden: "no mouseover" / "UnitIsPlayer secret|nil|error" / "not a player" (zelfde voor
UnitCanAssist) — Robs probe van vandaag zei alleen "not a player (or unreadable)", dus of UnitIsPlayer na de hotfix secret
is, is NIET gemeten; de volgende `/mh blesstip` meet het. AFGELEID uit de oude code waarom het "eerst niet, later wel"
werkte: de spell werd pas gezet bij de eerste muis-over op een speler. Typ je `/mh blesstip` in chat, dan staat je muis op
de chat → "mouseover" leest niets; dat zegt de diagnose nu ook. Uitleg FBLESS_BTN_SW_DESC in 7 talen bijgewerkt. Offline
GEMETEN (bless_test.lua, 12 controles). NIET in het spel gezien.

🔑 **Charkey: eerste test van Rob (21 nov, middag)** — Ima 1 `/mh charkey`: poleGear/toolTip/ranks.top "already there",
"copies made so far: 4". GEMETEN in de Forever-SV: `charKeyMigrated` heeft 4 kopieën voor Player-6944-0118CB4F (pole,
ranks.top, toolTip: uit "Ima-CAMWOW EU4 Realm 10 RP" + "Ima-"; recepten: uit "Ima-"), en `foreverToolTipSeen[GUID]` =
dezelfde 4 vakken als de oude sleutel. Dus wél gekopieerd, bij een eerdere login/reload; "already there" was verwarrend →
zegt nu "copied earlier (datum) from …" of "already there (made by this character…)". Ranks-stap kon niet (dat character
heeft geen spells met meerdere ranks, AFGELEID) — niet nodig, de SV-vergelijking bewijst de kopie.

🔑 **API-wachter #2: één sleutel per character in Forever GEBOUWD (21 nov)** — Rob via sparring, letterlijk: *"A"* (speler-GUID
via één gedeelde functie; unieke voornamen nemen oude data mee; elke Ima krijgt een kopie; /mh toont per module de
sleutel). GEMETEN in Robs Forever-SV (20 nov 22:23, na de hotfix): `realm = ""`, `normRealm = ""`, `UnitFullName` 2e waarde
= achternaam ("Pallie"); oude sleutels "Naam-CAMWOW EU4 Realm 10 RP" (één realm), en al vóór de hotfix deelden álle "Ima"'s
één sleutel. Nieuw `Modules/ForeverCharKey.lua` (beide toc's, stopt buiten Forever): `ns.ForeverCharKey(label, legacy, tbl,
opts)` → UnitGUID("player"); kopieert eenmalig per tabel+character "Naam-<realm>" + "Naam-" (tabellen recursief, getallen
max, anders de nieuwe; `whole` = de nieuwe in één stuk; twee realms voor één naam = oude niet, log zegt het). Oude sleutels
blijven staan (vangnet; 🗓️ op z'n vroegst na 28 nov opruimen). Omgezet: ForeverSkillup (foreverKnownRecipes), ForeverRanks
(top + except), ForeverVendors (foreverToolTipSeen), ForeverWarnings (foreverPoleGear, whole), ForeverTravel (bind, whole),
KeyPresses (chars). ⚠️ Afwijking van het plan, met reden: KeyBlock (keyBlockCodes) en SlotOwnership (managedSlotsByChar)
krijgen de nieuwe sleutel maar GEEN kopie — KeyBlock bouwt zijn codes bij elke login opnieuw uit je balken (een oude
Ima-code beschrijft de balken van een andere Ima), en SlotOwnership zegt in zijn eigen commentaar dat een record bij het
verkeerde character de fout zelf is. Retail ongewijzigd (functie bestaat daar niet → oude sleutel). `/mh charkey` toont per
module sleutel, oude sleutel en wat er gekopieerd is; `MidnightHelperDB.charKeyMigrated` houdt de kopieën bij. Offline
GEMETEN (charkey_test.lua, 17 controles: kopie, diep, oud blijft, max-merge, whole, al aanwezig, dubbelzinnig, geen kopie,
tweede Ima eigen kopie, Joey eigen data, "Imani" niet als "Ima", geen GUID). AFGELEID: speler-GUID blijft gelijk. NIET in
het spel gezien. Correctie: "achternaam pas vanaf level 10" was een web-API-spelerspost (API_WATCH ~9920), NIET gemeten —
daar nu rechtgezet (Rob: je kiest voor- en achternaam bij het maken).

🔧 **API-wachter [MOET GEFIKST] #1 GEREPAREERD (21 nov)** — sparring: bugfix, geen keuze nodig. `ForeverVendors.lua` (het
leren van reparateurs bij MERCHANT_SHOW) gebruikte als enige plek nog `^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)`; sinds de
Forever-hotfix van 20 nov zijn veld 3-4 geobfusceerd. Nu velden 2-5 los (`[^%-]+`, zoals regel ~1170 en 5 andere
bestanden). GEMETEN: grep over alle .lua op het strikte patroon = 1 treffer (deze), losse variant = 6 treffers in 5
bestanden (controle). Offline GEMETEN (guid_test.lua): oud formaat, letters in veld 3/5, nullen, Player-GUID → juiste npc
of nil. Mislukt het toch, dan zegt `/mh vendor check` nu "learning: … did not give an npc id" (zweeg eerst). #2 (lege
realm) = onderzoek naar de sparring, Rob kiest.

📦 **Waylaid Crates GEBOUWD (21 nov, Forever, optie Middel)** — Rob via sparring: *"Waylaid crates zijn het ... wat zijn
dat? En ik denk dat wij er ook iets mee moeten."* → *"Ja doe maar"*. `tools/forever_crates.py` → `Modules/ForeverCratesData.lua`
(GEMETEN, DB2 wowf 1.60.1.71037 ItemSparse + Item, en de Wowhead Forever-tooltips van elke krat): 30 getypeerde kratten
(248682–248699 ruw q1, 248702–248713 gemaakt q2), elk met hun bundels als {aantal, item-id} (namen → id via ItemSparse,
bij dubbele naam de trade good; 1 geval: Dark Iron Ore 11099), 15 verzegelde (248765–248779, q1/q2/q3). Positieve controle:
248682 = 10 Earthroot (2449). Inleveren (Wowhead Forever NPC-tooltips, GEMETEN): Marcy Baker 256390 Redridge 1433 9.6,71 /
Dokimi 256386 Barrens 1413 50,29.2; HandyNotes en Zygor hebben ze NIET (grep, Zygor-controle 214101 vond wel). Namen per
taal GEMETEN (fr Marcy Fournier, pt Márcia Barreto, ru Марси Бейкер/Докими; ondertitel per taal). `Modules/ForeverCrates.lua`
(beide toc's): tooltip (bundels + GetItemCount met bank, vinkje/kruisje; groen = gemaakt "double Favor"; lege krat:
"right-click to read the label" + level 20/35; verzegeld/label: bij wie, zone, afstand, "Find -> Deliver crates";
eerste-label-tip zolang quest 98247/98248 niet gedaan), venster bij aankomst van een verzegelde krat/label in je tas
(BAG_UPDATE_DELAYED, eerste meting = basis; in combat wachten), Find-categorie `crates` in ForeverVendors (In town) met
Favor (3402, via ns.ForeverCurrencyViews) + rang (2586/2587, via ns.ForeverRepViews) bovenaan. Schakelaar `FCRATE_SW`
(standaard aan), `/mh crates [test|on|off]` schrijft de tooltipregels van elke krat in je tas naar
`MidnightHelperDB.crateProbe` (om de vul-voortgang te meten). 7 talen + esMX (Cajón arrebatado / Etiqueta de envío, GEMETEN).
AFGELEID/niet door MH gemeten: "groen = dubbel Favor" en "eerste label = 50 Favor + 2000 rep + XP" (uit het mh-research-
rapport van de sparring, Wowhead + conquestcapped); of GetItemCount(id, true) in Forever de bank meetelt. Offline GEMETEN
(crates_test.lua, 24 controles: tooltips, schakelaar, venster, combat, knop, Find-regel, probe, frFR-naam). NIET in het spel
gezien. ForeverLevelingGuide (krat-module, ARR) niet gebruikt.

🚢 **Pijl-zin bij een zeppelin/boot/tram GEREPAREERD (20 nov, laat)** — Rob: *"je loopt niet door de Zeppelin heen. Je
neemt de Zeppelin."* (Carola, class-training-route). Enige bron (GEMETEN, grep op "other side"/"go through"/"andere kant"
in de locales): `ARROW_AT_STEP` in NativeArrow (je staat óp een reisstap). Nu `ns.ArrowAtStepText(step, name)`: Forever-
stappen dragen `linkKind` (boat/zeppelin/tram/sky/loop → ARROW_AT_RIDE "wait here and get on…"; portal → ARROW_AT_STEP
zoals vroeger). Midnight-zoekstappen (source `MOUNTRUN_HUBS.<key>`) hebben al een hele zin als label ("Take the zeppelin
to X.") → ARROW_AT_RIDE_SENTENCE (zeppelin/tram) of ARROW_AT_SENTENCE (portaal, boot = kapitein aanspreken, deur). Dat
repareert meteen "You are at Take the portal to X. — go through" (AFGELEID uit de code; niet in het spel gezien). 7 talen.

⛏️ **Erts en kruiden: twee schakelaars GEBOUWD (20 nov, laat)** — Rob na zijn meting: *"reload gedaan, en ik wil beide met
idd de schakelaars"*. Uitslag (GEMETEN, Forever-SV `nodeProbe`, "Ima", Lueur uit, 22:07): vóór geen softinteract; na de
waarden "Copper Vein", UnitIsGameObject true, nameplate ja (getoond, niet forbidden), cursor "Cursor Crosshair_Mine_64"
(in bereik) / "Cursor Crosshair_UnableMine_64" (buiten bereik); UnitExists("softinteract") = FALSE. Terugzetten exact
(1/0/10/0/1/1). SoftTargetInteract en -Range zijn "secure" (GetCVarInfo). Console: 1879 commando's, o.a.
SoftTargetNameplateInteract "Always show nameplates for soft interact target". Rob zag een houweel boven de ader, en een
gele gloed links (onbekend wat; AFGELEID misschien de loot-glinstering: outlineModeShowLootEffectWhenDisabled stond op 1).
Gebouwd in `ForeverLootSparkle.lua`: `FNODE_ICON_SW` (A: NODE_SET aan) en `FNODE_GLOW_SW` (B: star4-gloed, ADD, op de
nameplate van softinteract, offset −40 = AFGELEID; goud erts, groen kruid ("herb" in de cursornaam = AFGELEID), grijs bij
"Unable"). B heeft dezelfde CVars nodig, dus het icoon komt mee. Beide standaard UIT, nooit in combat, eerst alle oude
waarden lezen, terugzetten als beide uit staan; CVAR_UPDATE en laadscherm zetten ze 1 s later opnieuw. Lueur geladen →
MH doet niets (FNODE_LUEUR). `/mh sparkle` toont alles; `/mh sparkle icon|glow on|off`. 7 talen. Offline GEMETEN
(nodeswitch_test.lua: aan/uit, grijs, kruid, verbergen, preset, geen lus op "15.000000", uitzetten in combat → na combat
terug, Lueur). NIET in het spel gezien.

⛏️ **Kruiden en erts laten glinsteren: MEETFASE (20 nov)** — Rob: *"ja graag"* op "eerst uitzoeken, dan meet jij, dan
bouwen". Onderzoek (mh-research, GEMETEN in de Forever-UI-bron): GEEN glinster-CVar voor nodes. Node-addons (Lueur: idee,
MIT volgens zijn CF-pagina, geen code genomen) zetten soft-targeting aan (SoftTargetInteract 3, Arc 2, Range 15,
IconGameObject 1, NameplateInteract 1) en hangen zelf een gloed aan de nameplate van "softinteract"; één node tegelijk,
~15 m. Robs cvp2/cvp3 waren Lueurs waarden (GEMETEN: gelijk aan Lueur's gate; echte waarden in LueurDB.savedCVars).
Lueur staat aan op 5 karakters (AddOns.txt), uit op o.a. Midnight-Helper en Ima-Pallie. Meting gebouwd in
`ForeverLootSparkle.lua`: `/mh sparkle nodes` → CVar-info (19 namen), ConsoleGetAllCommands-treffers, softinteract
vóór/na (naam, GUID, gameobject, plate, cursor-icoon), wijzigingen 30 s lang, dan exact terugzetten (ook bij reload/logout/
laadscherm) → `MidnightHelperDB.nodeProbe`. Weigert als Lueur geladen is (`force` om toch). Offline GEMETEN
(nodeprobe_test.lua): zetten, terugzetten, vangnet, weigering. NIET in het spel gezien. VOLGENDE: Robs uitslag lezen → stap A
(alleen CVars, icoon van de game) of stap B (MH tekent een gloed op die nameplate). Bijvangst: Loot Sparkles bewaarde
OutlineEngineMode "0" terwijl cvp1 "2" mat (AFGELEID: graphicsOutlineMode trok hem mee) → nu eerst álle oude waarden
lezen, dan zetten. Robs huidige `lootSparkle.saved` heeft nog de 0 (bij uitzetten: rand terug via graphicsOutlineMode 2).

🛡️ **Duurzaamheidswaarschuwing in Forever GEBOUWD (20 nov)** — Rob: *"ja doe maar"* op "zijn je spullen onder de 25%, dan
zegt MH het en toont hij de knop 'Repair & sell' erbij". `Modules/ForeverDurability.lua` (beide toc's, stopt buiten
Forever): UPDATE_INVENTORY_DURABILITY + na laadscherm (3 s) → laagste item < 25% → venster
`MidnightHelperForeverDurability` (RegisterMidnightDialogPopup) met DURABILITY_WARN_FMT + DURABILITY_WORST_FMT (bestaande
vertalingen, 7 talen) + "Repair & sell: naam, zone, afstand" + knop (ns.ForeverRepairGoNearest) + chatregel + raid-warning-
geluid. Eén keer per daling (`armed`), opnieuw na reparatie boven de grens; in combat wacht hij op PLAYER_REGEN_ENABLED.
Schakelaar `FDUR_SW` (Quiet helpers), standaard AAN (advies: hij komt zelden). `/mh durability [test]` in Forever = deze
module (ns.DurabilityCommand; DurabilityWarn.lua laadt alleen in Midnight). Drempel `ns.db.foreverDurability.at` (25).
✅ Rob zag het venster (screenshot via sparring, na /reload): "Your gear is at 98%…", "Lowest: [Copper Shortsword].",
"Repair & sell: Nadia Vernon, Silverpine Forest, 634 meters" + knop. Rob: *"kan de tekst ed gecentreerd worden ?"* →
tekst en knop nu gecentreerd. 98% boven de 25%: in de code GEMETEN dat alleen `/mh durability test` het venster boven de
grens toont (Check stopt bij `low >= at`; niets anders roept Warn aan). Rob bevestigde: *"ik had het getikt"*. Daarom
zegt de test nu "(test)" achter de zin en schrijft hij geen chatregel.

🔧 **Repair & sell GEBOUWD (20 nov, Forever)** — Rob: *"Hebben we al iets in onze helper staan waarbij ik aan kan klikken
om zo snel mogelijk naar iemand of iets te gaan waarbij ik mijn spullen kan repareren en zeker verkopen?"* → *"ja doe
maar"*. Data: `tools/forever_repair.py` → `Modules/ForeverRepairData.lua` (beide toc's): Zygor Forever NPCData ["Repair"]
(waarde) + per NPC de Wowhead Forever-tooltip (naam, ondertitel, spawns): 359 rijen, 358 binnen 1,0 van Wowhead (GEMETEN);
1 verschil = Craftsman Wilhelm EPL (Wowhead heeft daar alleen Classic-frame-punten). Redridge-rijen x −5,15 (oude frame),
alleen NPC-id < 200000 (Forever-eigen NPC's staan al goed, GEMETEN op 256730). Alterac Valley (1459) weggelaten.
ForeverVendors: categorie `repair` (In town + Which city?), `RepairSpots()` = data − `db.foreverNotRepair` + `db.foreverRepairSeen`
(geleerd bij MERCHANT_SHOW via CanMerchantRepair + UnitGUID("npc"); clientnaam + plek), `ns.ForeverRepairNearest/GoNearest`,
`/mh vendor check` telt repair. Tas vol-venster: regel "Repair & sell: naam, zone, afstand" + knop. Ondertitel alleen op een
Engelse client (zoals de winkels); namen Engels tot MH de NPC zag (dan de clientnaam). Offline GEMETEN (repair_test.lua):
Goldshire → Andrew Krighton / Corina Steele, leren werkt. Geen Forever-duurzaamheidswaarschuwing in MH (DurabilityWarn.lua
alleen in de Midnight-toc, GEMETEN) → daar dus geen knop; voorstel aan de sparring. NIET in het spel gezien.

🗑️ **Tas vol STAP 2 GEBOUWD (20 nov)** — Rob via sparring: *"Nu geeft het me 3 opties die ik eruit kan gooien, maar toch
wil ik graag die knop erbij per stuk. Dat we dat kunnen destroyen."* Zijn `/mh bagfull test` (Forever, niet bij een
verkoper, GEMETEN): vanuit een klik Delete/Use niet geblokkeerd; vanuit een timer UseContainerItem ADDON_ACTION_BLOCKED;
Sell All Junk enabled = false. Dus alles ALLEEN vanuit een klik. Gebouwd in ForeverBagFull.lua:
Destroy per regel → StaticPopup "MH_BAGFULL_DESTROY" (Ja = klik) → `DoDestroy`: zelfde itemID op die plek, geen tool, geen
quality ≥ 3, ClearCursor + PickupContainerItem + check GetCursorInfo + DeleteCursorItem; ligt het nog op de cursor →
ClearCursor + "not allowed". "Pick up the loot"-knop (LootSlot, eigen klik; in dezelfde klik kan niet, de server moet het
vak eerst vrijgeven, AFGELEID). "MH: sell junk (N)" onder het MerchantFrame: alleen grijs uit dezelfde lijst, max 12 per
klik (BUYBACK_ITEMS_PER_PAGE 12). ADDON_ACTION_BLOCKED/FORBIDDEN binnen 2 s na onze klik → melden; verkopen daarna nooit
meer (`ns.db.foreverBagFull.sellBlocked`). Test zonder timer-fase (geen rode fout meer), noteert "bij een verkoper".
`StaticPopupDialogs` alleen een eigen sleutel (nooit de global zelf toewijzen). FBAG_HINT + release-tekst/CHANGELOG_570_5
bijgewerkt (MH gooit niet meer "niets" weg, wel alleen op je klik). Offline GEMETEN (bagfull_test2.lua): vernietigt het
juiste item, weigert bij ander item en bij de hengel, verkoopt alleen grijs. NIET in het spel gezien; of vernietigen met
een ECHT item mag, weet alleen Robs test.

🐞 **Tas vol: Fishing Pole in de lijst GEREPAREERD (20 nov)** — Rob testte zelf (screenshot): *"Hij wil mijn fishing pole
weggooien. Maar mijn fishing pole die wil ik niet weggooien, want die heb ik nodig om te vissen."* Oorzaak (GEMETEN in de
code): ForeverToolGuard's TOOLS heeft geen hengels, dus de hengel viel door naar "gear". Nu `IsTool` in ForeverBagFull:
ToolGuard-lijst + elke hengel op soort (wapen-subklasse Fishing Pole, `Enum.ItemWeaponSubclass.Fishingpole`, terugval 20,
AFGELEID dat Forever die enum heeft) + hengel-id's uit ForeverVendors (6256 6365 6366 6367 12225 19022 19970) + itemklasse 19.
Ongeacht of je het beroep hebt. Offline GEMETEN: Fishing Pole (id) en een onbekende hengel (soort) eruit, gewoon zwaard
blijft. Verder werkte Robs test: venster + loot-vergelijking (Tough Jerky 1c, Slimy Bone 13c, Cracked Bill 28c).

📋 **De testlijst in het spel GEBOUWD (20 nov, alleen voor Rob)** — Rob via sparring: *"Kunnen wij niet een soort
zijstapje maken in onze add-on die alleen voor mij is? …"* (zin in IDEEEN). Aparte addon `MidnightHelper_Testlist`
(bron `tools/testlist_addon/MidnightHelper_Testlist/`: 2 toc's zoals MH, `Testlist.lua`; `.pkgmeta` negeert tools/ →
nooit in de zip, GEMETEN). `run testlist_ingame` = Data.lua uit TESTLIJST.md (parser + id's van testlist_page.py, nu
ook `cmds` uit `/backticks`, emoji eruit) + kopie naar `_retail_\Interface\AddOns\` én `_forever_\Interface\AddOns\`
(GEMETEN geïnstalleerd, 705 punten). In het spel `/mhtest`: secties links (Nieuwste/Alles), kaartjes rechts met Goed/
Fout/Overslaan, opmerking, commando-knop → chatregel, Reload-knop, Shift+wiel schaal. Opslag `MHTestlistDB.results[id]`
= {s, n, t, sec, text}. Terug: `run testlist_ingame read` (proefrun) / `read --write`: leest beide WTF-mappen
(`*\WTF\Account\*\SavedVariables\MidnightHelper_Testlist.lua`), nieuwste per id; Goed → `[x] ✅ (Rob in het spel, datum)`,
Fout → blijft open + `❌ … : opmerking`, opmerking → `📝`. Offline GEMETEN: luac OK (4 bestanden), venster/klikken/
opmerking/commando met stubs, teruglezen op een nep-SV in de kladmap (Robs WTF niet aangeraakt). NIET in het spel gezien.
Na elke wijziging aan TESTLIJST.md: `run testlist_ingame` opnieuw (en /reload). Data.lua staat alleen in de installaties.

📝 **Release-tekst 5.7.0 GESCHREVEN, NIET uitgebracht (20 nov)** — Rob via sparring: *"Ja dat mag erna"*. Voorgesteld
nummer 5.7.0 (nieuwe functies). `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.7.0.md` (identiek), `CHANGELOG_570_1..7` (enUS) +
entry in `Changelog.lua`. GEEN .toc-bump (nog 5.6.0), geen tag, geen package. Het changelog-venster springt alleen open
als de .toc-versie verandert (GEMETEN, `ShowChangelogWindow`), dus Rob ziet nu niets. Inhoud sinds v5.6.0: Forever nieuw
overzicht, Which city? + alle herbergen, Hearthstone/teleports in de route, Skill up, Tas vol, Rested XP, Loot Sparkles,
geen Dock to window; beide spellen ThanksBuff (door Rob getest); Midnight Renown-regel. Alles behalve ThanksBuff is
NIET door Rob getest → schrappen als zijn test faalt. Bij Robs go: .toc's naar 5.7.0, dan pas tag.

🏅 **O14 Renown in het alt-overzicht GEBOUWD (20 nov, Midnight)** — Rob via sparring: *"1"* (één regel "Renown (hele
account)" bovenaan). `AltOverview.lua`: `RenownSummary()` uit `C_MajorFactions.GetMajorFactionIDs()` + `GetMajorFactionData`
(+ HasMaximumRenown), namen van de client; regel `ui.renown` tussen titel en hint, tooltip (`ui.renownHit`) met elke factie
en de reden als hij ontbreekt ("not unlocked yet" / "the game gave no data"). Woord "Renown" = client-global
LANDING_PAGE_RENOWN_LABEL; GEMETEN per taal (GlobalStrings 12.1.5.70961): de Ruhm, fr Renom, es Renombre, esMX
Reconocimiento (wissel in esMX.lua), pt Renome, it Fama, ru Известность. Geen kolom per character (renown = account-breed,
bit 4 GEMETEN 19 nov voor 2590/2600/2710; voor de rest AFGELEID). Welke facties GetMajorFactionIDs zonder argument geeft
(alleen deze uitbreiding, ook Journeys?) is NIET gemeten → Robs screenshot. NIET in het spel gezien.

🎒 **Tas vol, MIDDEL stap 1 GEBOUWD (20 nov)** — Rob: *"Beide ja"* (Middel in twee stappen). `Modules/ForeverBagFull.lua`
(beide toc's, stopt buiten Forever; WoW herstarten). Trigger: UI_ERROR_MESSAGE met ERR_INV_FULL (wat Blizzards LootFrame
gebruikt, GEMETEN in de Forever-UI-bron), max 1×/20 s. Venster `MidnightHelperForeverBagFull` (RegisterMidnightDialogPopup):
3 goedkoopste (verkoopprijs × stapel, normale tassen) + waarom (grijs / gear niet beter / goedkoopst) + loot-vergelijking
als het lootvenster open is. Nooit: questitems (GetContainerItemQuestInfo), gereedschap (nieuw `ns.ForeverIsTool` in
ToolGuard), ingrediënt voor je beroep (ReagentUseText groen), upgrade (ForeverGearTipText), quality ≥ 3, geen waarde.
MH doet NIETS met items. `/mh bagfull [show|test|on|off]`; `test` roept DeleteCursorItem (lege cursor) en
UseContainerItem (leeg vak) aan vanuit een klik en een timer en vangt ADDON_ACTION_BLOCKED/FORBIDDEN → beslist stap 2.
Offline getest (scratch bagfull_test.lua): selectie en uitsluitingen kloppen. NIET in het spel gezien. Kwaliteitsnamen
nagezet naar de client (GEMETEN Forever GlobalStrings ITEM_QUALITY0/3_DESC): de Schlecht/Rar, fr Mauvais/Rare, es
Pobre/Raro, pt Inferior/Raro, ru Низкое/Редкое; en/nl Poor/Rare. Stap 2 (Destroy-knop + loot,
"Sell MH junk") pas na Robs test.

⏹️ **TESTLIJST opgeruimd (20 nov)** — Rob: *"Beide ja"* (oude punten naar archief "vervallen, niet getest"). Script
(scratch testlist_split.py, per `## `-kop, eerste datum in de kop): 316 secties met kopdatum vóór 10 nov → bovenaan
`TESTLIJST_ARCHIEF.md` onder "Derde verhuizing", open punten als `[vervallen, niet getest]`. GEMETEN: vóór 1765 open /
599 [x]; na 697 open / 140 [x] in TESTLIJST, 1068 vervallen in het archief. Blijven staan: "9 nov — Deze week in
Forever" en de kop zonder datum (19 nov). De telefoonpagina (testlist_page) is NIET opnieuw gebouwd.

🔨 **Skill up voor beroepen (idee 6, MIDDEL) GEBOUWD (20 nov, Bouwchat 20-11 (2))** — Rob via sparring: *"Ja, begin
daar dan mee. Het geld kunnen we inderdaad later bekijken."* Nieuw: `tools/forever_skillup.py` → `Modules/
ForeverSkillupData.lua` (2119 recepten, 1605 receptitems, 120 KB; controles 2660 = Blacksmithing 15/55 Rough Stone en
item 2881 → 2667 OK, GEMETEN DB2 1.60.1.70959) en `Modules/ForeverSkillup.lua` (in beide toc's, zoals ForeverReagentData; buiten Forever stoppen ze meteen. De 120 KB
wordt in Midnight wel ingelezen (Lua compileert het hele bestand), net als ForeverReagentData. → WoW herstarten).
Geel/grijs GEMETEN; groen = midden en kans (grijs−skill)/(grijs−geel) AFGELEID, overal "estimate". Bekende recepten:
uit het beroepsvenster (C_TradeSkillUI of oude GetTradeSkillInfo, wat Forever heeft is NIET gemeten) per character in
`ns.db.foreverKnownRecipes` + IsPlayerSpell. Volgende stap = zekerste bekende recept, max 10 punten per stap
(`STEP_MAX`), aantal = som 1/kans. Tooltip: product/receptitem (grenzen + jouw kleur, of "ken je nog niet") en
ingrediënt (beste recept nu). Venster `MidnightHelperForeverSkillup` (RegisterMidnightDialogPopup), `/mh skillup
[probe|on|off]`, knop op Overzicht → Professions + blauwe regel bovenaan de kaart. Offline getest (scratch
skillup_test.lua, stubs): stap/lijst/tooltips kloppen. NIET in het spel gezien. **Eerst Robs `/mh skillup probe`**:
geeft de client zelf de receptkleur, dan kan MH die tonen i.p.v. uitrekenen. Teksten 7 talen (de/fr/es/pt/ru zelf
vertaald, niet nagekeken). GROOT (geld, Auctionator, route tot 300) = later (IDEEEN).
✏️ **Vertaalfixes Skill up (zelfde dag)** — nagekeken door een mh-research-helper van de sparring (Forever GlobalStrings
1.60.1.70959). ptBR: "habilidade" → "perícia" (client SKILL = Perícia, zelf nagemeten) in FSKILL_* + 4 oudere
beroeps-regels (FOV_TIP_CARD_FIND, FOV_TIP_TAB_PROFS, FOV_TIP_CARD_PROFS, FOV_PROF_SKILL_UNKNOWN), "profissão de
criação", "dicas de tela". frFR "ne donne plus", "infobulles", %d%%. ruRU «namen», "с %d до %d", TIP_YOU/REAGENT
herschreven. deDE "Handwerksberuf", "das Fenster für %s", kleuren met hoofdletter. es/nl kleine stijlpunten.

🛏️ **Alle herbergen in de data (20 nov, Bouwchat 20-11 (2))** — Rob via sparring: *"Zoek online uit waar dan overal
herbergen zijn, onder andere ook voor Richard."* (= Ratchet). `ForeverCitySpots.lua`: 40 nieuwe `kind = "inn"`-regels
(nu 52 herbergiers, 51 plaatsen; Dalaran heeft er 2. ⚠️ Er stonden er 12, niet 14 zoals hieronder staat: GEMETEN met
grep op `kind = "inn"`). Bron per regel: Zygor Forever `LibRover-1.0/data_inns.lua`
(waarde) + Wowhead Forever npc-tooltip (naam, "Innkeeper", spawns), allebei GEMETEN 20 nov, alle binnen 0,4 (Aerie
Peak 0,35). HandyNotes_WoWForever heeft GEEN herbergen (0 treffers, positieve controle 417 andere NPC-regels).
Zygor-fout: Hammerfall had npcid 7731 → 9501 Innkeeper Adegwa (Wowhead bevestigt). Nieuwe velden `area` (AreaTable,
GEMETEN DB2 1.60.1.70959) en `town` (Engelse terugval); UiMap-ID's GEMETEN (Riverglades 2548). Rog'Mar: geen
AreaTable-rij onder die naam → Engelse naam. Minst zeker: Rog'Mar 58,45 en Powderfuse Port 78,8,54 (Zygor: "GET MORE
ACCURATE COORDS LATER", Wowhead dezelfde ronde waarden). Code: `ForeverFindCities` één regel per plaats (sleutel
"a<area>" of map), naam uit area; `ForeverCityServiceRows` kiest per soort de plek het dichtst bij DEZE herberg, straal
700 yd hoofdstad / 300 yd dorp (AFGELEID); `ForeverTravel` BindDest vindt de herberg nu ook op dorpsnaam
(Hearthstone-route naar een dorp). `FCITY_SUB_INN` in 7 talen: "in steden en dorpen". NIET in het spel gezien.
**Ronde 2 (zelfde dag, na mh-research):** +5 herbergiers die Zygor's data_inns mist (Sebelia/Summit of Eternity,
Caitir Flinthew en Ortak Lomgok in West-Hyjal, Adarien in Shen'dralas, Berdun Cliffbrew/Talrendis Point), elk zelf
nagemeten in de Wowhead Forever-tooltip → nu 57 herbergiers. 2 coördinaten GEREPAREERD: Zygor + Wowhead staan in
Redridge en Eastern Plaguelands in het oude Classic-kaartformaat (GEMETEN via onze flight-master-regels met DB2-
wereldcoördinaten): Brianna/Lakeshire 27,0 → 21,8 (Wowhead heeft ook die Forever-spawn), Jessica Chambers/Light's Hope
81,6,58,1 → 71,8,48,5 (omgerekend, = wowfdb). Mulgore (Kauth) klopt WEL (vendors 9 nov). Andere zones: flight masters
binnen 0,4 → zelfde formaat. NIET opgenomen: Markus Hearthfire (New Avalon) — of je daar kunt binden is onbekend.
Sleutel zonder area = "n<npc>" (West-Hyjal en Shen'dralas tonen de zonenaam).

🏙️ **Stap 3 GEBOUWD (Bouwchat 20-11 (2))** — Find kreeg "What am I looking for? | Which city?" + zoekveld. NIET in het spel
gezien; TESTLIJST "Find, stap 3".
- `ForeverVendors.lua`: `ns.ForeverFindCities()` = elke plaats met een herberg in ForeverCitySpots aan jouw kant (één
  per map; hoofdsteden eerst, dan andere plaatsen op afstand), `ns.ForeverCityServiceRows(map)` = per soort (inn, bank,
  auction, mail, flight) de dichtstbijzijnde binnen `CITY_RADIUS` = 700 yd van de herberg (AFGELEID getal) + elke
  transportstop + je class trainer (`ForeverProfTrainerList(nil)`), `ns.ForeverCityGo(map)` = pijl naar de herberg.
  Stadsnaam: hoofdsteden = `C_Map.GetMapInfo`; andere plaatsen = `C_Map.GetAreaInfo(area)` met area-ID's GEMETEN in
  Forever-DB2 AreaTable 1.60.1.70959 (Booty Bay 35, Dalaran 279, Gadgetzan 976, Everlook 2255, Valanaar 16638), Engels
  als terugval. Of `C_Map.GetAreaInfo` in Forever bestaat: NIET gemeten (pcall + terugval). Hearthstone-label =
  `GetBindLocation() == stadsnaam` (AFGELEID dat die gelijk zijn) met de itemnaam 6948 uit de client.
- `ForeverOverview.lua`: knoppen `cat.modeWhat`/`cat.modeCity` + zoekveld `cat.search` in `BuildFindPage` (lijst begint
  nu op 86 i.p.v. 34); `FillCityPage`; keuze in `ns.db.foreverFindMode` ("city"/nil) en `ns.db.foreverFindCity` (map);
  `ShowForeverFind(kind)` zet terug naar "what". Zoekveld filtert in beide standen (naam bevat tekst).
- Teksten `FOV_FIND_MODE_*`, `FOV_FIND_CITY_*`, `FOV_FIND_SEARCH`: enUS, nlNL, de/fr/es/pt/ru (ForeverClassQuests_*).
- ✅ Ratchet zit er nu in (zie "Alle herbergen" hierboven). Werkt ook in de oude lay-out (schakelaar).

**Robs woorden (via sparring, 20 nov):** idee: *"…ik wil naar Ogrimai. Als ik hoorde ben uiteraard. Terwijl ik helemaal
op het andere werelddeel zit."* · Find: *"Want het is nu één lange lijst geworden, wat niet echt meer overzichtelijk
wordt."* · na opties A/B/C de vierde: CharacterScape (*"Well, character forever"*) · keuze: *"Ik ga toch voor d"* ·
*"Vooral de eerste paar die we nu standaard hebben, vind ik super gaaf. Dat moet ik zeker houden."* · op het plan
met schakelaar: *"Ja"*.
**Wat D is:** het HELE Forever-overzicht in CharacterScape-stijl (alleen het idee; CharacterScape = map
`_forever_\Interface\AddOns\CharacterForever`, v0.16.25, Amir Ahmadi, GEMETEN geen licentie → geen code). Tabbladen als
hoge knoppen RECHTS, paginanaam gecentreerd bovenaan, portret links blijft, inhoud van Now/Class ongewijzigd.
Midnight NIET aanraken. Schetsen: `C:\Users\RobHu\AppData\Local\Temp\claude\find_mockups\` (A/B/C/D, D_now, D_class,
D_find; Rob zag D_* in zijn Drive). Lay-out: geen Fable.
**Maten (GEMETEN in code):** oud 920×520, inhoud 700. Nieuw 1100×600 (niet CharacterScape's 1040: dan zou het
middenstuk smaller worden), `RIGHT_PAD` 188, inhoud 708, tab 160×40 stap 46, subtab 142×26 stap 30 ingesprongen 18.
**Plan (4 stappen, commit + push per stap, lint als laatste, TESTLIJST/NEXT_SESSION/SITE_SEIN mee):**
1. ✅ GEBOUWD 0ff9d9d — venster + tabkolom + subtabs + gear-groep onderaan + paginanaam + schaal-past-bij-openen +
   schakelaar. NIET in het spel gezien; Rob test thuis (TESTLIJST "nieuw overzicht, stap 1").
2. Pagina's nalopen op afgekapte tekst / overlap (12 pagina's; de 7 met een oude subrij kregen 30 px). PAS met Robs
   screenshots van stap 1.
3. ✅ GEBOUWD (zie hierboven). Was: Find "What am I looking for? | Which city?" (zie D_find.png / C.png): links eigen hoofdsteden +
   neutrale steden (Booty Bay, Gadgetzan, Everlook, Valanaar, Dalaran alleen A; Ratchet ontbreekt in onze data →
   eerst meten), doel = de herberg uit `ForeverCitySpots` (14 herbergen, GEMETEN), rechts de diensten van die stad
   (filter `ns.FOREVER_CITY_SPOTS` op map: inn/bank/auction/mail/flight + transport + je class-trainer), knop
   "Route to X" + routezin (`ns.ForeverTravelSentence`, kent nu Hearthstone/teleports + "(about N min)"), plus een
   zoekveld. MH onthoudt de laatst gekozen knop (geen schakelaar nodig). Find-code: `ForeverOverview.lua`
   `FindCatalog`/`FillFindPage`/`FindPlaces`, data via `ns.ForeverVendorFindRows`.
4. Afwerken: TESTLIJST, SITE_SEIN, en ~1 week na Robs ja het oude pad weghalen.
**Schakelaar:** `FOV_LAYOUT_SW` in Quiet helpers, db `ns.db.foreverOldLayout` (nil = nieuw, standaard), werkt na
/reload (`ns.IsForeverNewLayout`, `ns.SetForeverNewLayout`). Code: `NEW_LAYOUT`/`RIGHT_PAD`/`VTAB_*` bovenaan
`ForeverOverview.lua`, `RelayoutTabs` vóór `ns.ForeverOverviewFill`.
**Risico's om na te lopen:** Shift+scroll-schaal (DialogPopup AttachScaling vs. onze OnShow-verlaging: volgorde niet
gemeten), opgeslagen positie, kleine schermen (UI-hoogte 768), Characters met 4 subtabs (~442 px in ~490), knoppen
elders die `ns.ShowForeverFind` e.d. aanroepen.

## ▶ 20 nov — drie testpunten goedgekeurd (Rob grieperig: één stap tegelijk)

🎨 **Find + Steden: ONTWERP gestuurd, niet gebouwd** (IDEEEN, ✅ JA ontwerp). Opties A tegels / B zoekveld + kop Steden /
C "Wat zoek ik? | Welke stad?". Advies C + zoekveld; geen schakelaar (MH onthoudt de laatste keuze).
→ Rob koos **D: het hele Forever-overzicht in CharacterScape-stijl** (*"Ik ga toch voor d"*; Now/Class houden). Schetsen
D_now/D_class/D_find + plan in 4 stappen naar sparring (IDEEEN). Rob: *"Ja"* (met schakelaar oud/nieuw).
- 🖼️ **D stap 1 GEBOUWD** (`ForeverOverview.lua`): `NEW_LAYOUT` uit `ns.IsForeverNewLayout()` (db `foreverOldLayout`,
  standaard nieuw; schakelaar `FOV_LAYOUT_SW` in Quiet helpers, werkt na /reload). Nieuw: W,H = 1100,600;
  `RIGHT_PAD` = 188 (16 + tabkolom 160 + 12) — alle 13 pagina-ankers "BOTTOMRIGHT -16" gebruiken nu `RIGHT_PAD`, en
  `rightW = W - x0 - RIGHT_PAD` = 708 (oud 700); `SUB_TOP = TOP_Y` (geen subrij). `RelayoutTabs`: tabs 160×40 rechts
  (stap 46), subtabs van de open groep ingesprongen (18 px, 26 hoog), gear-groep onderaan de kolom; `f.pageName`
  gecentreerd op de oude tabrij. OnShow: schaal omlaag tot het venster past (Shift+scroll-schaal van het oude venster).
  Oud = ongewijzigde code-pad. Midnight niet geraakt. NIET in het spel gezien. Volgende: stap 2 (pagina's nalopen),
  stap 3 (Find "Which city?"), stap 4 (afwerken; oud weg na Robs ja, ~1 week).

▶ **Rob onderweg: *"Laten we doorgaan met REST XP, shortest path. En dan kijken we wel weer verder."***
- 😴 **Rest XP GEBOUWD** (`Modules/ForeverRestXP.lua`, NIEUW, beide toc's, alleen Forever → WoW herstarten). Feiten uit
  twee onafhankelijke mh-research-runs (Fable uit), het eens over de kern:
  rustplekken = herbergen + hoofdsteden (Blizzard GlobalStrings NEWBIE_TOOLTIP_XPBAR "logging out at an inn or city",
  GEMETEN); AreaTable Flags_0 0x20 op de zes hoofdsteden (+ Gallows' End Tavern, Hall of Legends, Champions' Hall,
  Stormwind Harbor), GEMETEN DB2 1.60.1.70959; herbergen zitten NIET in clientdata (server-areatriggers) → `IsResting()`
  is de waarheid. 5%/8 u, max 150% (gidsen); buiten een rustplek langzamer (alleen kleinere gidsen: "een kwart") →
  tekst zegt "more slowly". In een rustplek log je direct uit, daarbuiten 20 s (gidsen) → `PLAYER_CAMPING` = "uitloggen
  buiten een rustplek". Events PLAYER_CAMPING/PLAYER_UPDATE_RESTING/UPDATE_EXHAUSTION/LOGOUT_CANCEL in de
  Forever-snapshot (GEMETEN); IsResting/GetXPExhaustion/GetRestState in Blizzards Forever-UI (GEMETEN), werking AFGELEID.
  Gebouwd: venster "Rested XP" bij PLAYER_CAMPING als je niet rust en niet max bent (nee-rust-zin, Hearthstone-zin als
  hij klaar is + `GetBindLocation`, dichtstbijzijnde plek + Show the way); weg bij LOGOUT_CANCEL of als je gaat rusten.
  Plekken = de 14 stadsherbergen (`ns.ForeverVendorFindRows("inn")`) + elke plek waar `IsResting()` ja zei
  (`ns.db.foreverRestSpots`, per map+subzone, met factie). Regel in de XP-tooltip van het overzicht. `/mh rest [go]`.
  Schakelaar `FREST_SW` (Quiet helpers), standaard AAN. Woorden per taal GEMETEN uit dezelfde GlobalStrings (de
  Gasthaus/Stadt/erholt, fr auberge/ville/reposé, es posada/ciudad/descansado, pt estalagem/cidade, ru таверна/город/
  бодр; it locanda/capitale uit retail — Forever geeft voor itIT Engels). Hearthstone-naam komt uit de client;
  ItemSparse 6948 GEMETEN: Ruhestein / Pierre de foyer / Piedra de hogar / Pedra de Regresso / Камень возвращения.
  Licenties: Fennick Rest PolyForm (geen open source), RestedAlts MIT → alleen het idee. NIET in het spel gezien.
  Niet gedaan: dorpsherbergen als vaste data (MH leert ze), sleeping bag/tent (bronnen oneens).
- 🗺️ **Shortest Path uitgezocht** (advies naar sparring): in Forever laadt alleen `ForeverTravel.lua` (GEMETEN in de
  toc's) — geen vluchten, Hearthstone of class-teleports in de route. Advies: 1 Hearthstone + class-teleports (middel),
  2 tijd per stap, 3 gevaar-straf, 4 vluchten (groot), 5 boottijden; geen collision maps. Wacht op Robs keuze.
- 🧙 **Shortest Path 1 + 2 GEBOUWD** (Rob: *"Ik volg voorlopig eerst je advies. Dus doe inderdaad dan maar je advies,
  als those teleports."*). `ForeverTravel.lua`: TELEPORTS = Hearthstone (item 6948/spell 8690, 60 min), Astral Recall
  556 (15 min, shaman 30), mage 3561/3562/3565/1297659 (A) en 3567/3566/3563 (H) met Rune 17031, Moonglade 18960
  (druid 10). Feiten GEMETEN in Forever-DB2 1.60.1.70959 door twee onafhankelijke mh-research-runs (eens). Landing:
  server-side (SpellEffect target 17 / 9 = bind), niet in clientdata. Zygor (ARR) en emulator-db's (fan, Darnassus
  oneens) NIET gebruikt: bestemming = de herberg van die stad uit ForeverCitySpots (AFGELEID "ergens in de stad"),
  en MH leert de echte landing (`ns.db.foreverLandings`, UNIT_SPELLCAST_SUCCEEDED + volgend laadscherm). Hearthstone /
  Astral Recall: eigen landing per character, anders herberg/rustplek met de naam van `GetBindLocation()`. Moonglade
  pas na een eerste landing. Alleen bekende spells (IsPlayerSpell/IsSpellKnown), rune in de tas, cooldown = wachttijd.
  Kosten: 0,5 cast + 1,5 drempel + wachttijd (AFGELEID). Plan: teleport-lijn van je eigen plek naar de landing.
  Tijd: elke stap `min`, `steps.totalMin`; zin in Find/Dungeons/Weapons krijgt "(about N min)"; pijl-label bij een
  cast-stap = de zin + tijd (NativeArrow `standingCast`); chatmelding over een ander continent noemt de cast.
  `/mh travel`: per teleport waarom wel/niet, per stap de tijd, totaal + "rough". Spell/item-namen uit de client.
  NIET in het spel gezien. Eigen Hearthstone-check (WaitMin) i.p.v. die van Rest XP: die keek alleen "klaar ja/nee".
  ⏸️ 3, 4, 5 en loopkaarten niet nu (IDEEEN).
  🔧 **Reparatie (sparring zag het, zelfde dag):** het teleport-advies stond alleen op ons pijl-label, en Rob draait
  TomTom in Forever (GEMETEN door sparring) → nooit gezien (de 19-aug-fout). Nu ook een chatregel, één keer per doel,
  op ELK continent: `FTRAVEL_CHAT_FIRST_FMT` "Way to X: first use your Hearthstone (about N min)." in
  NativeArrow `AnnounceUnreachable`, dat vóór het opzij gaan voor TomTom draait (GEMETEN in de tick). En de
  routezin in Find/Dungeons/Weapons (naast de knop) noemt de cast + tijd al.

⏸️ **(eerder) GEPARKEERD** (Rob via sparring: *"oke, ik moet werken dus dit parkeren we, zo onderweg gaan we kijken wat we verder
gaan doen"*). Niets nieuws beginnen. Open: (a) MH-sparkle-test met Lueur UIT; (b) Robs keuze Lueur of MH-sparkle;
(c) ideeën 1, 2, 3, 5 en 6 van 20 nov in IDEEEN (bij 6 moet Rob zeggen welke addon hij bedoelt). Keuzes komen via de
sparring.

Rob via sparring, letterlijk: *"deze 3 zijn goed gekeurd : * het venstertje met je class-quest-stap * het lijstje "You
just learned" na de toetsenblok-vraag * in Midnight: het kaartje "MH werkt ook in WoW Forever""*. Afgevinkt in TESTLIJST
met "(Rob, 20 nov)". Open gelaten: de hulpregels (`/mh ranks`, `/mh new`, `/mh classquest`) en "Had je hem al
weggeklikt" (het andere pad, niet getest). Geen nieuw werk zonder ja.
- **ThanksBuff, meting 1 GOED** (Rob via sparring: *"thaanks test werkt ook"*): `/mh thanks test` + "zet het aan"
  afgevinkt. Open: meting 2 (echte buff van een vreemde — de onbewezen kern: is de gever leesbaar), geen tweede
  bedankje binnen 5 minuten, TFTB-regel.
- **ThanksBuff-pauze 1 uur → 5 minuten** (Rob via sparring: *"zet die uur maar naar 5 minuten"*): `COOLDOWN = 300`
  in `ThanksBuff.lua`; `SET_THANKS_DESC` in 7 talen + ruRU ("once every 5 minutes"); TESTLIJST-regel mee. De extra
  TFTB-functies (wave e.d.) legt de sparring Rob eerst voor: NIET aan begonnen.
- **ThanksBuff meting 2 GOED** (Rob: *"dit was een echte speler 🙂"*, *"en ja ik kreeg de buff van een echte speler
  zelf"*): de gever van een vreemde buff is leesbaar en de emote komt aan. Pauze blijft 5 minuten (*"nee 5 minuten"*).
  Extra TFTB-functies NEE (*"nah, vergeet die thanks verder maar, we houden het zo, sorry"*; in IDEEEN). Open: geen
  tweede bedankje binnen de pauze, TFTB-regel, "kwam er niets?".
- ✨ **Forever: Loot Sparkles GEBOUWD** (Rob via sparring: *"en begin met 4, loot sparkles :)"*). Nieuw bestand
  `Modules/ForeverLootSparkle.lua` (beide toc's, alleen Forever → WoW herstarten). GEMETEN in Robs Forever-client
  (/run-probe → `MidnightHelperDB.cvp1/cvp2`, controle graphicsOutlineMode "2" = Config.wtf): outlineModeShowLootEffect-
  WhenDisabled 0, graphicsOutlineMode 2, raidGraphicsOutlineMode 2, OutlineEngineMode 2, RAIDOutlineEngineMode 2;
  SoftTargetInteract 3, -Arc 2, -Range 15, SoftTargetIconGameObject 1, SoftTargetIconInteract 0. (C_Console bestaat
  NIET in Forever — eerste probe faalde.) Aan = loot-effect 1, de vier outline-CVars 0; oude waarden in
  `ns.db.lootSparkle.saved`, uit = terugzetten (patroon KeyBlock). Nooit in combat (wacht op REGEN_ENABLED);
  CVAR_UPDATE (pcall) zet het na een preset 1 s later opnieuw. Schakelaar `FLS_SW` in Quiet helpers, standaard UIT.
  `/mh sparkle` print per CVar nu/MH/bewaard + laatste beslissing. FpsPanel leest alleen → geen botsing (GEMETEN).
  GPLv3-addon: geen code overgenomen. Teksten 7 talen + ru; de woorden "outline"/"glinstering" NIET tegen de
  client-strings gemeten (game-term-regel: nalopen). NIET gemeten: dat het in beeld glinstert; dat uitzetten een
  herstart vraagt (tekst zegt "anders herstarten"). Kruiden/erts NIET gebouwd. SITE_SEIN-regel "alleen op main".
- 🐞 **Class-quest-venster: titel liep onder "Dock to window" GEREPAREERD** (Rob, screenshot: *"de tekst loopt over de
  dock to window"*). `ForeverClassQuests.lua` CQWBuild: titel nu rechts vast aan de linkerkant van `f._mhDockBtn`
  (-8), met woordafbreking; zelfde aanpak als ForeverDirection.lua:422 en NewChoices.lua:517. Body hangt onder de
  titel en `Fit()` rekent de titelhoogte mee → schuift omlaag, overlapt niet (AFGELEID uit de code, niet in het spel
  gezien). Testregel in TESTLIJST. ⚠️ Rob zei 17 nov dat de dock-knop in Forever "nergens meer nodig" is; die is hier
  bewust NIET weggehaald (de sparring vroeg om de titel te begrenzen) — kan later.
- ⚠️ **Loot Sparkles: nog NIET bewezen.** Rob eerst *"we hebben sparkles"* (screenshot boek), daarna *"o wacht sparkle
  stond nog uit ?!?"* → de glinstering kwam niet van MH. TESTLIJST-regel weer open. Waarschijnlijke bron: de addon
  **Lueur** v2.0.0 in Robs Forever-AddOns (gevonden door sparring). GEMETEN in zijn code: `Lueur/CVars.lua` beheert
  SoftTargetInteract, SoftTargetNameplateInteract, -Range, -Arc, -OnlyInRange, -RangeIsHard, SoftTargetIconInteract,
  SoftTargetIconGameObject, nameplateGameObjectMaxDistance (bewaart en zet terug); hij raakt GEEN outline-CVar (grep,
  positieve controle 37 treffers) → geen CVar-botsing met MH. De cvp2-waarden zijn dus waarschijnlijk die van Lueur
  (AFGELEID). Lueur hangt een gloed + naam + icoon aan de nameplate van het soft-target-object (`Glow.lua` ShowLabel);
  Robs `LueurDB.showName = true` (GEMETEN in zijn SV). → Robs vraag "naam van het object erboven" doet Lueur al; MH
  hoeft dat niet te bouwen (advies, wacht op Rob). Licentie Lueur niet gezien: alleen lezen.
  cvp3 (Rob *"ik kreeg ok3 :)"*, gelezen door sparring): SoftTargetNameplateInteract "0", SoftTargetTooltipInteract "0",
  SoftTargetNameplateSize "19" — bestaan alle drie; UnitName("softinteract") = nil (misschien keek hij er niet naar).
  ⚠️ Lueur zet SoftTargetNameplateInteract zelf aan/uit (`SetGate`, exclusieve stand) → een handmatige 1 kan door
  Lueur worden overschreven (AFGELEID uit zijn code).
- 🧹 **"Dock to window" weg uit ALLE Forever-vensters** (Rob via sparring: *"ja haal ze maar uit alle forerver
  vensters"*). Centraal: `DialogPopup.lua` `RegisterMidnightDialogPopup` roept `AttachDockButton` alleen aan als
  `not ns.IS_FOREVER` (GEMETEN: de enige plek die de knop maakt). Midnight ongewijzigd. Titels die aan `_mhDockBtn`
  vastzaten krijgen in Forever een eigen rechtergrens van -36 (vóór het kruisje): `NewChoices.lua` (was -140) en
  `ForeverDirection.lua` (was gecentreerd zonder breedte). `ForeverClassQuests.lua` valt terug op zijn eigen -28.
  Geraakte bestanden in de Forever-toc (GEMETEN, 25): DelvePartyShare, KeyPresses, NameplateColors, ForeverMacros,
  ForeverVendors, ForeverWeapons, EditModeBackup, KeyBlock, ForeverHowToPlay, ForeverDirection, ForeverTrainer,
  ForeverProfTrainers, ForeverRanks, ForeverToolGuard, ForeverOverview (had hem al verborgen), ForeverDungeons,
  ForeverDungeonGuide, NewChoices, ForeverChars, ForeverLayoutCarry, LayoutGrowth, BarPlanCard, FpsPanel,
  ForeverClassQuests, KeysHub. Een eerder gedockt venster wordt in Forever niet meer vastgezet. NIET in het spel gezien.

## 🔴 Fable-afspraak — vanaf za 21 nov (na de reset) één week proef

Rob via sparring, letterlijk: *"Laten we dat vanaf zaterdag wanneer de reset is geweest eens een week proberen."*
- **Tot za 21 nov: Fable UIT** (blijft zo).
- **Vanaf za 21 nov, één week:** Fable ALLEEN voor feitenteksten die spelers lezen (bazentips, class-uitleg,
  wapenadvies), plus **één Fable-ronde vóór een release** (alle nieuwe teksten in één keer).
- **Geen Fable** voor knoppen, vensters, tooltips en lay-out: daar Opus + Robs test in het spel.
- Nalopen met goedkope helpers (mh-sweep); minder helpers tegelijk.
- Rond 28 nov evalueren. Een regel in CLAUDE.md alleen op Robs eigen woorden in de bouwchat.

## ▶ 19 nov — Robs lijst van vier (*"Ja, die mogen door. En dat comprehensive kaartje."*): stap 1 + 4 GEBOUWD

- **1. FutureSpell** (`ForeverBlock.lua` `ForeverBlockUnlisted`): een spellbook-item van type
  `Enum.SpellBookItemType.FutureSpell` (een spell voor later) telt niet meer als "jouw spell". Het enige Forever-bestand
  dat het spellbook zo leest (GEMETEN met grep). Of Forever zulke items toont: NIET gemeten; zonder enum doet het niets.
- **4a. Windshaper-shaman**: Skyborne in de rassen van de Horde-keten The Tempest's Weapons (`ForeverClassQuests.lua`).
  `MyChains` vergelijkt `c.races[race]` en `RaceToken()` geeft "Skyborne" (GEMETEN) → geen MyChains-wijziging nodig.
- **4b.** Geen aparte level-up-melding voor wapenquests: in IDEEEN als NEE, met de reden.
- **2. Comprehension GEBOUWD**: overzicht → Professions krijgt voor een mage een laatste regel "Comprehension"
  (naam via `C_TradeSkillUI.GetTradeSkillDisplayName(3012)`, anders Engels) met een kaartje (`ForeverProfGuide.lua`
  `CompCard`): wat het is, of je Comprehend Scroll kent / leer hem bij je mage-trainer vanaf 6, gebruik hem op de
  scroll (tab = naam van de eerste spellbook-tab uit de client, anders `GENERAL`), drempels 1/15/50/175 en 17 scrolls,
  Study (bibliotheek, Light Feather, 1 uur) en hoeveel scrolls je bij je hebt. Geen skillbalk: `GetProfessions` geeft
  geen klasse-skills (GEMETEN ForeverTrainer.lua:942). De knop "trainers" opent de class-trainer-regel van Find.
  "Do this now": een onvertaalde scroll in je tas → "use Comprehend Scroll on it (General tab …)" of, zonder de spell
  en level ≥6, "learn … at your mage trainer" (eigen soort `comp`, anders vouwt de Now-kaart hem weg).
  GEMETEN (Forever DB2 1.60.1.70959): de 17 scrolls (ItemSparse RequiredSkill 3012: 211780, 211784-211787, 211853-211855,
  213543-213547, 281015-281018), Comprehend Scroll-id's (ForeverSpellIds), Light Feather 17056, voorbeeld 211780.
  NIET gezegd (niet gemeten/oneens): wat een scroll doet, de ontcijfertijd (DB2 cast-index 1), hoe snel de skill stijgt,
  welke stad een bibliotheek heeft. Item- en spellnamen komen uit de client. Teksten 7 talen. NIET in het spel gezien.
- **3. Slimme zegen-knop GEBOUWD** (`ForeverBlessTip.lua`, deel 2 van het plan in IDEEEN): verborgen
  SecureActionButton `MidnightHelperSmartBless` (type spell, unit mouseover; klikfase vast zoals ForeverDisenchant:
  `useOnKeyDown` false, LeftButtonUp). Een APART event-frame (UPDATE_MOUSEOVER_UNIT, PLAYER_REGEN_ENABLED,
  PLAYER_ENTERING_WORLD) zet buiten een gevecht `spell` = de keuze van `Pick()` (dezelfde als de tooltip-tip, je eigen
  tabel telt); in een gevecht blijft de laatste keuze; geen script op de secure knop. Aanzetten (Quiet helpers
  "Button: smart blessing …" of `/mh blesstip button on|off`) maakt de macro "MH Smart Bless" (`/click
  MidnightHelperSmartBless`, per character) en opent het macrovenster om hem op een balk te slepen. Standaard UIT.
  `/mh blesstip` print aan/uit, gebouwd, de spell erop, de laatste beslissing en of de macro bestaat. Teksten 7 talen.
  NIET gemeten: of `/click` in Forever een secure knop bereikt, en UPDATE_MOUSEOVER_UNIT boven unit frames.
  Greater Blessings: niet (plan: alleen op echte groepsleden, eerst de [group]-meting).
- Alle vier klaar.
- **Receptnaam in "Used for" GEBOUWD** (Rob: *"ja graag"*; Forever + Midnight). `tools/forever_reagents.py` zet per
  item nu `item:bits:spellA/spellB/aantal` in `REAGENT_PACKED` (zelfde builds als eerst: Forever 1.60.1.70888,
  Midnight 12.1.5.70783; alle controles OK). Forever sorteert op `SkillLineAbility.TrivialSkillLineRankLow` (beginners
  eerst), Midnight op spell-id. `ReagentUse.lua`: tweede grijze regel "Recipes: X, Y (+N more)" via
  `C_Spell.GetSpellName` (taal van de client); `/mh usedfor` toont ook die regel of waarom niet. Offline GEMETEN:
  524/524 Forever-items hebben recept-id's; Linen Cloth → "Bolt of Linen Cloth, SAF-T Dynamite (+10 more)"; 3013 →
  "Tenets of the Silver Hand". Teksten 7 talen. NIET in het spel gezien.
- ✅ Rob, Midnight-check na alle wijzigingen: *"Ik krijg geen fouten in WoW Midnight. Dus dat gaat goed."* (geen go).
- 📣 **Forever-melding in Midnight** (Rob: *"alleen 5.0 dat klopt natuurlijk niet meer. Die melding kunnen we wel houden.
  En misschien dat we het een soort splash moeten maken als mensen opnieuw inloggen. … Eén keer wegklikken en daarna
  nooit meer geven."*): kop `HOME_FOREVER_AD_HEADER` zonder "5.0" in 7 talen (esMX heeft geen eigen regel, GEMETEN);
  nieuw kaartje `foreverad` in `NewChoices.lua` (het enige login-venster; account-breed, één keer; niet als
  `foreverAnnounceSeen` al waar is; "Got it" zet die vlag en ververst This Week). De body-tekst (start page, key block)
  is ongewijzigd — oud maar niet onwaar. In de 5.6.0-tekst. NIET in het spel gezien.
- 🪟 **Klein class-quest-venster GEBOUWD** (Rob via sparring: *"Kunnen we misschien de optie maken dat we een extra
  venstertje krijgen wat we los kunnen plaatsen. Al dan niet met een aan- en uitknop in onze settings."* → *"Doe het nu
  maar."*). In `ForeverClassQuests.lua` (onderaan; bestaand bestand, /reload genoeg): `MidnightHelperForeverClassQuestWindow`
  met de zin van `ns.ForeverClassQuestNow()` (= de regel in Do this now), titel = ketennaam, letter 15, knop Show the way
  (`ns.ForeverClassQuestGo`). Ververst 0,5 s na QUEST_LOG_UPDATE/ACCEPTED/TURNED_IN, level-up, SPELLS_CHANGED,
  BAG_UPDATE_DELAYED, PLAYER_ENTERING_WORLD. Plek in `ns.db.foreverCQWindowPos`; RegisterMidnightDialogPopup (Shift+scroll,
  Escape). Kruisje = weg tot de stap verandert; Escape = weg tot de volgende update (bewust: Escape sluit álle MH-vensters).
  Schakelaar Quiet helpers `FCQWIN_SW`, standaard AAN (`ns.db.foreverCQWindow ~= false`). `/mh classquest` print de
  beslissing. Teksten 7 talen. Staat in de 5.6.0-tekst. NIET in het spel gezien.
- 🙏 **Vreemden bedanken voor een buff GEBOUWD** (Rob: *"Nee dan de manier met de vaste dingen die de andere addon ook
  heeft, niet in de whisper"*). `Modules/ThanksBuff.lua` (NIEUW, in beide toc's → Rob moet WoW herstarten). UNIT_AURA
  (player) addedAuras → gever via `sourceUnit` of `C_UnitAuras.GetAuraCasterGUID`; alleen spelers, niet jezelf, geen
  groep/ignore/onvriendelijk, niet in combat/instance, 10 s pauze na een laadscherm, 1 u per speler. Emote THANK via
  `C_ChatInfo.PerformEmote(unit of naam)` (DoEmote als terugval); nooit zonder doel (dan zou je je target bedanken).
  TFTB geladen → zwijgt. Schakelaar standaard UIT: `mh_thanksBuff` (SettingsDefs, Screen) + Quiet helpers (Forever).
  `/mh thanks [on|off|test]`: aan/uit, TFTB, API's, tellers, laatste beslissing; `test` = emote naar je target.
  TFTB-code NIET gekopieerd (geen licentie gevonden). NIET gemeten: gever leesbaar bij een vreemde; PerformEmote met
  unit of naam; retail chat-lockdown. Teksten 7 talen; het woord "buff" in de/fr/es/pt/it is niet tegen de client
  gemeten (game-term-regel) — nalopen. Niet in 5.6.0 (die is al uit).
- 🚀 **5.6.0 STAAT OP CURSEFORGE** (Rob via sparring, letterlijk: *"Go voor release."*). Tag v5.6.0 = cf06c1e; run
  44520447351 geslaagd (CF, Wago, GitHub "Success!" voor beide zips). CF-API GEMETEN: 9699302 (retail) en 9699316
  (forever), status 4. CURSEFORGE_DESCRIPTION.md bijgewerkt (ceced4f); Rob plakt hem zelf. SITE_SEIN bijgewerkt.
- 📦 (eerder) **RELEASE 5.6.0 KLAARGEZET, GEEN TAG** (Rob via sparring: *"Ja, de bouwchat mag alles klaarzetten."*). Beide toc's
  5.6.0; `Changelog.lua` + `CHANGELOG_560_1..7` (enUS); `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.6.0.md` (byte-gelijk
  GEMETEN); `CHANGELOG.md`; SITE_SEIN-regel "alleen op main". Het concept `CURSEFORGE_DRAFT_volgende.md` is verwerkt.
  Wacht op: Robs Midnight-/reload-check, dan zijn letterlijke go → `git tag -a v5.6.0` + push van de tag.
  Gelezen tegen de 11-nov-regel: geen /mh-diagnose in de spelerstekst. Eén regel nagemeten: het 3D-portret staat
  standaard UIT (het concept zei dat al goed).
- ✏️ Site-chat zag op Robs screenshots: `FDIRB_W_NONE` (How you play) las stroef → enUS nu "Weapon: the guides we read
  don't name one for this direction. …". De vertalingen zeiden het al vlot: ongewijzigd. check_drift: geen nieuwe drift.
  Hun tweede punt (Excavation Site te breed) waren foto's van vóór 2b17133; vervalt.
- 🔀 **Toetsenblok-vraag en "You just learned" na elkaar GEBOUWD** (Rob: *"Ja, ik volg jullie advies, dus het is een
  kleine wijziging, ja."*). Ze kwamen tegelijk (Conjure Water in allebei; GEMETEN: ze doen iets anders — het blok zet een
  macro op zijn eigen toets, het lijstje zet je rank-1-knop omhoog). `ForeverRanks.lua`: `ShowLearnList` wacht zolang
  `StaticPopup_Visible("MH_KEYBLOCK_NEW")`, met een ticker van 1 s; komt de vraag terwijl het lijstje open is
  (hooksecurefunc StaticPopup_Show), dan stapt het lijstje opzij en komt daarna terug. `listWhy` zegt het. NIET in het
  spel gezien. Rob: de slimme zegen-knop blijft in de release (*"De slimme zegenknop laten we erin zitten."*).
- **Bug "breng me naar de trainer" GEREPAREERD** (Rob, Troll mage 10: *"Hij brengt me naar de dichtstbijzijnde trainer,
  maar ik kan helemaal niks leren. Help"*). GEMETEN (mh-research, 5 bronnen + Robs screenshots; verslag
  `docs/forever/STARTER_TRAINERS_2026-11-19.md`): de 43 trainers in de startgebieden leren tot level 6, voor elke class.
  Dorpstrainers (Razor Hill, Sen'jin, Bloodhoof …) en steden: volle lijst (gids + Classic-data; een paar GEMETEN in
  Forever). Gebouwd in `ForeverTrainer.lua`: (1) `cap = 6` op die 43 rijen in `ForeverTrainerSpots.lua`; (2) bij elke
  eigen klassetrainer leest MH de lijst (filters even aan, daarna terug) en bewaart het hoogste level in
  `MidnightHelperDB.foreverTrainerCap[npc]` (wint van de vaste 6); (3) `Nearest` slaat een trainer over als zijn cap lager is
  dan de hoogste spell die je NU kunt leren; (4) sta je bij zo'n trainer, dan zegt MH in de chat tot welk level hij leert
  en noemt hij de dichtstbijzijnde goede trainer (FTRAIN_CAP_GO_FMT). `/mh trainer check` heeft een regel "short lists".
  NIET gemeten: of `SetTrainerServiceTypeFilter`/`GetTrainerServiceLevelReq` in Forever bestaan en direct werken; zo niet,
  dan zegt de check-regel dat en blijft alleen de vaste 6.
- **Bug Professions-pagina GEREPAREERD** (Rob, mage 10: *"ik zie geen compehension"*): er waren maar 12 rijen, Comprehension
  was de 13e. Nu `#FOREVER_PROFS + 1` rijen (minstens 13); `FillProfsPage` schuift de rijen dichter op (min. 18 px) als
  het kaartje te laag is. AFGELEID, niet in het spel gezien.

## ▶ 19 nov — "Buff bijna afgelopen" GEBOUWD (buiten een gevecht) + voordeur VAST

- **Voordeur**: Rob, rechtstreeks in de bouwchat: *"De voordeur blijft, pas je regel aan."* → CLAUDE.md-kop nu "VAST
  sinds do 19 nov 2026", de proef-regel ("na 19 nov beslist Rob") is weg. Geheugen `one-front-door-trial.md` bijgewerkt.
- **Meting** (Rob, Forever mage, `/mh buffs time`, 2 screenshots, via sparring) GEMETEN: buiten een gevecht geeft elke
  buff `duration` + `expirationTime` (GetTime-schaal; bv. Arcane Intellect 3600, nog 647 s; ook buffs van anderen,
  bron nil); IN een gevecht weigert de scan (0 buffs, auras not trusted). Wapen: main hand `hasEnchant=false` (regel
  stond 2× — de client gaf voor slot 0 twee items; AFGELEID, niet erg), off hand leeg.
- **Gebouwd** (`ForeverBuffs.lua` `ExpiringLeft`): een buff van je eigen lijst die OP je staat maar bijna afloopt komt
  na de ontbrekende in de buff-melding: "RUNS OUT" / "<naam> (4 min left) runs out soon. Click the icon …". Bijna = <5
  min bij buffs van ≥20 min, <1 min bij 5-20 min; korter nooit. Alleen buiten een gevecht én als `ns.Aura` betrouwbaar
  is — bewust GEEN momentopname van vóór het gevecht (een buff die je in het gevecht ververst zou een verkeerde tijd
  geven; onleesbaar ≠ bijna op). Bij een keuze (armor) de buff die echt op je staat; bij een grotere versie van iemand
  anders (covers) je eigen kleine. Ververst elke 15 s buiten een gevecht (er komt geen event als de tijd wegtikt).
  "Do this now" neemt ze NIET op (`e.expiring`): anders sprong dat venster elk uur open. `/mh buffs` zegt per buff de
  resterende tijd. Teksten 7 talen. NIET in het spel gezien.
- (2) "je mist iets vóór een gevecht": wacht op de paladin-meting (seal).

## ▶ 19 nov — Tooltips Midnight (punt 7): achievements, rares, reisplanner nagelopen

Rob (via sparring): de volgorde met "7. De tooltips in Midnight" kreeg *"volg het maar en doe het maar"*.
- **Achievements: NIET veranderd, bewust.** GEMETEN `Achievements.lua:1400-1402`: de tooltip is expres zelf gebouwd,
  omdat `GameTooltip:SetAchievementByID` bij een meta-achievement alle onderdelen groen toont, ook als ze niet af zijn.
  Onze tooltip toont naam, beschrijving en criteria met de juiste kleur — dezelfde inhoud, maar eerlijk.
- **Rares: niets toe te voegen.** GEMETEN `Rares.lua:2403-2432`: eigen tooltip (status, hint) + 3D-voorbeeld; de
  questtitels (r. 598/1137) zijn alleen een reservenaam (verborgen tracking-quest); een npc heeft geen spel-tooltip.
- **Reisplanner: GEBOUWD.** De knop van een stap die je gebruikt (mage-teleport, toy of Hearthstone;
  `Travel/TravelRoute.lua` HearthFrame) toont nu de tooltip van het spel (spell / toy / item). `HookScript`, raakt de
  secure attributen niet. NIET in het spel gezien.
- Volgende uit de inventaris (de "staart"): Openables, RaidShoppingList, MountRun, TradingPost, ApplyLayout, LiveKeys,
  HealerCooldowns, PartyTargets … — in groepjes, na een ja.

## ▶ 19 nov — Meting voor "buff bijna afgelopen" + "je mist iets vóór een gevecht" (nog NIET gebouwd)

Volgorde van Rob (via sparring): beide eerst meten. Nieuw: `/mh buffs time` (`ForeverBuffs.lua`) print elke buff op
jou zoals de client hem geeft: naam, id, duration, expirationTime, seconden over, bron, en "SECRET" als iets onleesbaar
is; plus de tijdelijke wapen-enchants (C_Item.GetWeaponEnchantInfo, alle velden). Op TESTLIJST: paladin met seal
buiten en in een gevecht, en een wapen met poison/olie/steen. GEMETEN vooraf in de code: `ForeverBuffs.lua` DEFS
bewaakt al armors, Inner Fire, aspects, schilden, imbues, blessing + aura en wapen-items; wat voor (2) ontbreekt is
vooral de paladin-seal (kort, vlak voor een gevecht). Bouwen na Robs screenshots.

## ▶ 19 nov — Macro-rest (punt 5): chips, Copy, melding "nieuwe macro" GEBOUWD + uitslag Arcane Missiles

- **Macro's** (`ForeverMacros.lua` + `ForeverOverview.lua` Keys & macros): per macro een chip **Made / Ready /
  Level N / Trainer** (uit de bestaande "waarom niet"-reden van `View`, nu 5e/6e waarde); een knop **Copy** opent de
  macrotekst in het bestaande kopieervenster (`ns.ShowShareCopyDialog`, DelvePartyShare.lua, staat in de Forever-toc,
  GEMETEN); een chatregel als een macro maakbaar WORDT (na de trainer) en nog niet gemaakt is — basislijn 3 s na
  inloggen, één keer per macro per sessie, `/mh macros check` zegt de laatste beslissing. De tabnaam in die zin komt
  uit `FOV_TAB_KEYS` (fr/nl wijken af van een vaste tekst, GEMETEN). Teksten 7 talen. NIET in het spel gezien.
  Nog open uit de oude lijst: "bron per rij" en "uitlegkaart modifier" (niet gebouwd; de spec-kop noemt de bron al).
- **Arcane Missiles** (mh-research, Opus, 5 Forever-gidsen + Zygor Forever, GEMETEN in die bronnen): geen gids
  gebruikt AM op level 8-14; vanaf ~15-16 alleen als een talent hem gratis maakt (Missile Barrage, later
  Clearcasting), dus vooral bij Arcane-talenten. De huidige mage-zin (zonder AM) klopt daarmee voor een lage mage.
  Voorstel van de helper (NIET gebouwd, Rob kiest): "Arcane Missiles (3) only when a talent makes it free (Missile
  Barrage or Clearcasting)." — vraagt uitleg van twee speltermen. Bronnen in het helper-rapport (Icy Veins, Method,
  Mobalytics, Warcraft Tavern, Zygor Skill_Training.lua:609/630).
  ✅ Rob koos via sparring, letterlijk: *"a"* → de mage-zin blijft zoals hij is (zonder Arcane Missiles). Afgesloten.

## ▶ 19 nov — Bug "Simple order" noemt spells die je nog niet hebt — GEREPAREERD

Rob (via sparring, mage Frost level 9): *"Terwijl ik inmiddels ook ... Arcane Missiles heb gekregen ... als hij er
dichtbij komt, doe Nova. Frost Nova. Maar dat krijg ik pas als ik level 54 ben."*
- GEMETEN (Forever DB2 SpellLevels, 1.60.1.70959): Fireball 133 = 1, Frostbolt 116 = 4, Fire Blast 2136 = 6, Arcane
  Missiles 5143 = 8, Frost Nova 122 = 10, Frost Ward 6143 = 22. MH's trainerdata zegt hetzelfde (Frost Nova rank 1 =
  10, rank 4 = 54; ForeverTrainerData.lua:358/495). De "54" kwam uit AbsoluteSpells (ARR, niet MH); AFGELEID dat dat
  de hoogste rank toont. Rob op 9 heeft Frost Nova dus nog niet; op 10 wel.
- Fix (`ForeverHowToPlay.lua` `NotYetLine`): onder elk "Simple order"-blok van ELKE class een grijze regel "Not
  learned yet: Frost Nova (level 10)." voor de spells die de Engelse tekst noemt (gezocht in `ns.FOREVER_SPELL_IDS`) en
  die je character nog niet kent (`IsPlayerSpell`/`IsSpellKnown`, elke rank); naam in de taal van de client, level =
  eerste trainer-level. Ook op de How you play-pagina van het overzicht (`ForeverHowToSections`). De rol-teksten
  kregen het NIET: die zetten al "(from N)" achter elke latere spell. Teksten 7 talen. NIET in het spel gezien.
- Arcane Missiles (level 8) staat NIET in de mage-zin. Of hij erin hoort is een speladvies (gidsen), geen meting —
  gevraagd aan de sparring (mh-research zou het moeten uitzoeken; Fable is uit).

## ▶ 19 nov — "Welke kant ga ik op?" stap 3 GEBOUWD (wapentype tegen je richting)

Volgorde van Rob (via sparring): *"we gaan akkoord met het voorstel van het bouwadvies"* → dit is punt (4).
- GEMETEN vooraf: de stats in de tooltip en de beloningsmelding volgden je richting al (`ns.ForeverStatDef` leest
  `GetForeverDirection`, ForeverMainStats.lua:99-108). Wat ontbrak: het wapentype.
- `ForeverQuestHint.lua` `ns.ForeverDirectionFitText(link)`: wapen-subclass → sleutel (`WEAPON_KEY`, GEMETEN in Forever
  DB2 ItemSubClass ClassID=2: 0/1 Axe, 2 Bow, 3 Gun, 4/5 Mace, 6 Polearm, 7/8 Sword, 10 Staff, 13 Fist, 15 Dagger, 16
  Thrown, 18 Crossbow) tegen `fit` van je richting (`ForeverDirectionWeaponFit`, uit spelersgidsen); schild (4/6) alleen
  "past" als de richting een schild noemt. Tooltip: "MH: Fits your direction (tree)." lichtgroen of "MH: Your direction
  (tree) does not use this kind of weapon (player guides)." oranje — los van de "beter dan"-regel. Questbeloning-melding:
  dezelfde zin achter de "neem deze"-tekst. Geen richting, wand/vishengel/onbekend, of de gids noemt geen wapens = stil.
  `/mh geartip` zegt ook de richting-beslissing. NIET veranderd: welke beloning MH aanraadt (stats beslissen nog).
  Teksten 7 talen (richtingwoord zoals FDIRB_HEAD_FMT). NIET in het spel gezien.

## ▶ 19 nov — Ranks A (lijstje na de trainer) GEBOUWD; B (met de hand neergezet) = eerst meten

Rob via sparring, letterlijk: *"Ik denk dat hij bedoelde allebei. Dat wanneer hij eenmaal met de hand iets ergens
neerzet, dat hij dat voorlopig niet zomaar geüpgrade wordt, denk ik. Dat is een aanname van mij. En inderdaad, jouw
overzicht ziet er goed uit, volg het maar en doe het maar."* Bron: de vragenlijst-speler (18 nov): *"I would like to
choose which action bar spells I want to upgrade."*
- **A GEBOUWD** (`ForeverRanks.lua`, blok "The just learned list"): na `AfterLearn` (1 s na de SPELLS_CHANGED-golf) een
  klein venster `MidnightHelperForeverLearnList` met per spell: nieuwe rank (gegroepeerd per spell, alle "just
  trained" knoppen) → Upgrade / Not now / Never (Never = `Except().buttons`, dezelfde lijst als /mh ranks choose);
  nieuwe spell zonder balk (`ns.ForeverNoBarList`, nieuw in `ForeverDoNow.lua`, alleen wat je DEZE sessie leerde via
  LEARNED_SPELL_IN_SKILL_LINE) → On my bar (eerste vrije zichtbare Blizzard-knop, `FreeSlot`) / Not now / Never
  (`ns.ForeverNoBarForget(id, true)`: naam per character in `ns.db.foreverNewSpellsNever`, ook "Do this now" vraagt
  er dan niet meer naar). Eén keer per spell+rank per sessie; vervangt dan de chatregel; weg in een gevecht, terug
  erna; stijl A, Shift+scroll, Escape; knoppen zo breed als hun tekst. Schakelaar Quiet helpers (standaard aan;
  `Settings().listOff`). `/mh ranks list` opent het opnieuw; `/mh ranks` zegt de laatste beslissing. Teksten 12 × 7
  talen (rank-woord = client, GEMETEN eerder vandaag). NIET in het spel gezien.
- **B NIET als regel gebouwd** — hoe je in Forever "met de hand neergezet" betrouwbaar ziet is NIET gemeten. Er is nu
  een meting: `/mh ranks watch` (2 min) print per veranderd slot: wat erop staat (+ rank / jouw hoogste), of MH het
  zette (`ours`, gevuld in `Replace` en "On my bar"), en hoe lang geleden de cursor een spell kreeg (CURSOR_CHANGED,
  GEMETEN dat Forever dat event kent in `tools/blizzard_events_snapshot.json`). AFGELEID idee: een addon pakt op en
  zet neer in hetzelfde beeld, een mens sleept langer. Op Robs screenshot beslist: bouwen of niet.

## ▶ 19 nov — Robs test (3 screenshots) + reparatie class quests + blauwe namen + goud GEBOUWD

Rob via sparring: *"dat ging helemaal goed"* — afgevinkt: Do this now spell-tooltip (Frost Armor), Class quests
naam → spell-tooltip (Study), rank-keuzevenster opent (inhoud niet getest: niets oud).
Bouwvolgorde, Rob letterlijk: *"we gaan akkoord met het voorstel van het bouwadvies, waar je ook mee eens bent"* →
na deze drie: (4) "Welke kant ga ik op?" stap 3, (5) macro-rest, dan buff bijna afgelopen + "je mist iets" (eerst
meten), dan Midnight-tooltips. Een rank-vraag van de sparring heeft nog GEEN ja.
- 🔧 **Class quests-rijen** (`ForeverOverview.lua` FillClassQuestPage): waren vast 74 px op een vaste plek (GEMETEN
  regels 233/266/267), dus een stap van 2 regels + plaatsregel liep over de volgende rij (Rob: *"dat daar tekst
  doorheen staat"*). Nu: elke rij onder de vorige, hoogte uit de getekende tekst; één extra vulling een beeld later
  (de regels hangen links én rechts vast, breedte pas na de layout bekend — AFGELEID).
- 🎨 **Blauwe namen** (Rob: *"een ander kleurtje krijgt als het een tooltip bevat"*): `S.LINK` = 71d5ff, de kleur
  van een spell-link in het spel. In `SpellLink` (Do this now), Coming up, trainer-pagina (later = grijs, zoals
  eerst) en class quests met een spell. Bazengids-loot houdt de item-kwaliteitskleur.
- 💰 **Goud in Do this now** (Rob: *"rechts onderin mijn goudvoorraadje"*): `f.money` rechtsonder op een eigen regel,
  `ForeverStyle.Money` (g/s/c met muntjes), ververst bij `PLAYER_MONEY`; knoppen 16 px hoger.
- IDEEEN achterstand gemeld: "Forever-overzicht 7 tabs" en "draaiboek 12.1.7" zijn al gebouwd/geschreven
  (`ForeverOverview.lua`, `docs/PATCH_12_1_7_DRAAIBOEK.md`, GEMETEN dat ze bestaan); de regels daar zijn bijgewerkt.
- Gecontroleerd: syntax OK, lint 0 HARD (GEMETEN, vlak voor de commit). NIET in het spel gezien.

## ▶ 19 nov — Find → Rares: het gebied waar je bent bovenaan GEBOUWD

Rob (via sparring), letterlijk: *"Kunnen we het zo instellen dat we gewoon waar ik nu ben altijd bovenaan staat?"*
(Durotar, hij moest de hele lijst door) → op het voorstel: *"Ja, doe maar."*
- `ForeverRares.lua` `ns.ForeverRareFindCats`: eerst het gebied waar je nu bent, met "(you are here)" (`FRARE_HERE`, 7
  talen), dan "Worth the trip", dan de rest zoals eerst. `HereZone()` loopt van je kaart omhoog via `parentMapID` (stad,
  grot) tot een gebied uit de lijst; onleesbaar = oude volgorde. Binnen het gebied blijft dichtstbijzijnde eerst
  (`ForeverRareFindRows`, ongewijzigd). Het overzicht vult opnieuw bij `ZONE_CHANGED_NEW_AREA` (GEMETEN
  ForeverOverview.lua:1965), dus het wisselt mee. De zoekbalk volgt dezelfde lijst (FindCatalog). NIET in het spel.
- Robs test: "Excavation Site: Wetlands" past nu (*"Ja, het past er nu netjes in. Dat ziet er goed uit."*). Afgevinkt.

## ▶ 19 nov — Robs test van de bazengids + reparaties

Rob (via sparring, 3 screenshots): *"Het lijkt allemaal goed te staan. Alleen de wetlands, Sky ding staat nog steeds
buiten zijn grenzen."*
- ✅ 3D-model bij muis op een baasnaam werkt (Sneed, Captain Greenskin). Afgevinkt.
- ❌→🔧 **Lange namen**: de fix van 2cc98f6 deed niets. Oorzaak GEMETEN in de code: hij mat bij Build, en de
  Forever-stijl (`ForeverStyle.lua` SkinButton, :515-525) zet DAARNA bij het tonen een eigen, grotere letter op elke
  knop; een uitgeschakelde knop wisselt ook van letter. Nu: `FitLabel`/`FitLabels` in `ForeverDungeonGuide.lua` meten
  bij elke `Fill` (na `SetEnabled`) en nog eens 0,25 s na openen (na de late stijlronde van 0,1 s); kleiner via
  `S.Font` (dan houdt `RefreshFonts` de kleine maat), tot 8 pt, daarna 2 regels. `/mh bosses check` print per lange
  naam de gemeten breedte, de ruimte (154 px), de gekozen letter en de getekende breedte. NIET in het spel gezien.
- 🔧 **Tekst die na het openen nieuw wordt gemaakt** (blokken, loot-rijen bij een andere dungeon) kreeg de stijl-letter
  pas bij de volgende keer openen (GEMETEN: `SkinFont` slaat al opgemaakte strings over en loopt alleen bij tonen).
  Nu doet `Fill` dan meteen `S.SkinWindow` en meet opnieuw (één keer, met een vlag). De rijhoogte groeide al mee met
  de tekst (`GetStringHeight`); nu ook in de juiste letter.
- 🔧 **Trainer-pagina, blauwe regel**: alleen de NAAM had `tipBody`; het icoontje niet. AFGELEID dat Rob het icoontje
  aanwees. Nu heeft het icoontje dezelfde regel. Niet uitgesloten (AFGELEID, niet gemeten): dat de Forever-client
  een spell-tooltip opnieuw opbouwt als de spell-gegevens later binnenkomen, waarbij onze regel wegvalt.
  De tooltip over de kop "At your class trainer": zo gelaten (anker van de tooltip; mag volgens de sparring).

## ▶ 19 nov — Bazengids: 3 wensen (Rob: *"Ja, dat klopt uiteindelijk wel."* op alle 3) — stap 1 GEBOUWD

Robs test (screenshot, Forever, Deadmines): de loot-tooltip werkt (Cruel Barb, met de Equipped-vergelijking). Afgevinkt.
Volgorde (sparring-voorstel, Rob ja): 1 lange namen in de lijst passend, 2 klein baaskaartje bij targeten in een
dungeon (schakelaar), 3 luxe: 3D-model bij muis op een baasnaam.
- **Stap 1** (`ForeverDungeonGuide.lua`, Build): een dungeonnaam breder dan zijn knop (Rob: "Excavation Site:
  Wetlands") krijgt de kleine letter en zo nodig 2 regels. Gemeten per knop met `GetStringWidth`, dus elke taal en
  elke naam vanzelf. Voor alle drie de knopstanden (de gekozen dungeon is een uitgeschakelde knop). NIET in het spel.
- **Stap 2 GEBOUWD** (`ForeverDungeonGuide.lua`, blok "Small boss card"): in een dungeon (`IsInInstance`) een baas
  van de gids targeten → klein kaartje `MidnightHelperForeverBossCard` (300 px): naam (+ rare), wat hij doet, de tip
  (`BossLines`, dezelfde regels als in de gids), en een knop met de naam van de gids die de grote gids op die dungeon
  opent. Ander target → weg. Niet als de grote gids open is. Verschuifbaar (plek in `ns.db.foreverBossCardPos`),
  Shift+scroll + Escape via `RegisterMidnightDialogPopup`, Forever-stijl via `S.SkinOnShow`. Schakelaar in Quiet
  helpers ("Small boss card when you target a boss", standaard aan; `ns.db.foreverBossCard == false` = uit).
  `/mh bosses check` zegt of het kaartje aan staat en waarom het (niet) kwam (stilte-regel). Teksten `FDG_CARD_SW/_DESC`
  in 7 talen + esMX ("calabozo"); eigen vertaling. NIET in het spel gezien.
- **Stap 3 GEBOUWD** (zelfde bestand): muis op een baasnaam in de grote gids → naast de gids een klein kader (200×240,
  strata TOOLTIP, zonder naam: geen venster) met de baas draaiend (`PlayerModel:SetCreature(b.npc)`, zoals het
  trainer-model in `ForeverTrainer.lua`). Muis weg of gids dicht → weg. Daarvoor tekent `Fill` de tekst nu in blokken
  (`ForeverDungeonGuideText(map, true)` geeft als 4e waarde `blocks`; een baasnaam = eigen blok met muisvlak).
  ⚠️ NIET gemeten: of `SetCreature` in Forever een npc tekent die de client nog niet zag; laadt er na 1,5 s geen model,
  dan verdwijnt het kader (geen zwart vlak). Niet in het kaartje van stap 2 gezet (dat blijft klein). NIET in het spel.
- ⚠️ Correctie op mijn eerdere regel "bazenregels hebben geen spell- of npc-id": de bazen hebben WEL `b.npc`
  (`ForeverDungeonGuideData.lua`, GEMETEN door de sparring); alleen spell-id's ontbreken.

## ▶ 19 nov — Robs /dump-meting voor optie B (deels)

Rob via sparring (Forever, screenshot). GEMETEN:
- `C_Item.GetItemStats` vult DPS in Forever: vak 16 = `{ ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 2.58… }` → het open punt van
  optie A ("of GetItemStats DPS vult") is beantwoord: ja. `Dps()` in `ForeverQuestHint.lua` leest die sleutel al.
- Armor komt als `RESISTANCE0_NAME` (handschoenen, vak 10: `{ RESISTANCE0_NAME = 4 }`); `Armor()` leest die al.
  Beide opmerkingen in de code zeggen nu GEMETEN (alleen commentaar veranderd).
- De shift-klik-vorm in `/dump` werkt niet in de chat (zie TESTLIJST); werkende vorm:
  `/dump C_Item.GetItemStats(GetInventoryItemLink("player",<vak>))`.
- Open: (a) gewone stats, (b) groene Equip-regel, (d) "of the …"-item. Optie B: nog NIET bouwen.

## ▶ 19 nov — Bouwchat 19-11: rank-keuzevenster vindbaar GEBOUWD

Rob via sparring, letterlijk: *"Op beide vragen ja"* (vraag 2: het rank-keuzevenster `ns.ShowForeverRanks` beter
vindbaar; het venster zelf, Shift-klik bij de trainer en `/mh ranks choose` blijven hetzelfde).
- `ForeverOverview.lua`: tandwiel → **Quiet helpers**: onder de schakelaar "Edge on buttons with an old rank" een
  nieuwe regel "Choose which spells get a new rank" met een knop **Open** (nieuw soort regel `action` in `QUIET`;
  `BuildQuietPage`/`FillQuietPage` kennen hem). Ook een vierde knop op de pagina **Keys & macros** (`KEY_DOORS`).
- Zoekbalk: de `action`-regel komt erin en opent het venster zelf; zoekwoorden `FRANK_CHOOSE_KEYS` met "rank" en het
  rank-woord van de client per taal — GEMETEN in Spell 1459 NameSubtext (Forever 1.60.1.70959): deDE/frFR "Rang",
  esES "Rango", ptBR "Grau", ruRU "Уровень", itIT "Rank" (Forever vertaalt het daar niet).
- Teksten `FRANK_CHOOSE_TITLE/_DESC/_KEYS`: enUS, nlNL, en de/fr/es/pt/ru in `Locales/ForeverClassQuests_<taal>.lua`
  (zoals de andere FRANK_WIN_*-regels; itIT valt terug op Engels, net als die). Eigen vertaling, niet nagekeken door
  een moedertaalspreker. `tools/locale_probe.lua` NIET gedraaid (`lua5.1` niet in het pad van deze chat).
- Gecontroleerd: syntax OK en lint 0 HARD (GEMETEN, vlak voor de commit). NIET in het spel gezien.

## ▶ 19 nov — Bouwchat 19-11: tooltips stap 3 — Now-kaart, class quests, verkopers, wapens GEBOUWD

Rob via sparring, letterlijk: *"Op beide vragen ja en ook de do now in het overzicht"* (= tooltips 3/4/5, het
rank-venster vindbaar maken, en de Now-kaart). Het rank-venster komt in een eigen commit.
- **Now-kaart** (`ForeverOverview.lua` `SpellStrip`): een regel die spells noemt ("new spells on no bar") krijgt onder
  de tekst een icoontje per spell (max 8, 20 px) met de spell-tooltip van het spel — ook de hoofdregel bovenaan. Links
  in de tekst werken daar niet (scrollende lijst). `ForeverDoNow.lua` geeft de id's mee (`item(..., spells)`).
- **`S.Tip` (`ForeverStyle.lua`)**: nieuw `tipLink` (bv. "item:123", "quest:456") → tooltip van het spel, onze
  `tipBody` eronder; kan de client hem niet tonen (0 regels) → onze eigen titel/tekst. Zonder titel: geen tooltip.
- **Class quests-pagina**: naam = spell-tooltip van de beloning (+ de stap eronder); de stap-regel = quest-tooltip
  (`quest:<id>`; ⚠️ of Forever quest-links toont is NIET gemeten — anders valt hij terug op onze tekst); een keten
  zonder spell met een "use"-stap (paladin-boeken) krijgt het item-icoontje met item-tooltip.
  `ns.ForeverClassQuestList` geeft nu `quest` en `item` mee.
- **Verkopers**: de knoppen links in het losse venster (`ForeverVendors.lua`) en in de Find-tab van het overzicht tonen
  bij een gereedschap de item-tooltip (`ForeverVendorFindCats` geeft `item` mee). Rijen zijn npc's: geen tooltip mogelijk.
- **Wapentrainers**: de wapenknoppen in `ForeverWeapons.lua` en de wapenregels in de Find-tab tonen de spell-tooltip
  van de wapenvaardigheid (in Find met de "past bij je richting"-regel eronder).
- Gecontroleerd: syntax OK en lint 0 HARD (GEMETEN, vlak voor de commit). NIET in het spel gezien.

## ▶ 19 nov — Bouwchat 19-11: tooltips stap 2 — Forever "Do this now" + trainer GEBOUWD

Rob via sparring, letterlijk: *"Doe maar"* op Forever 1 (Do this now) en 2 (Trainer). Na 1+2 melden; de sparring vraagt
verder (3 class quests, 4 verkopers, 5 wapentrainers, dan Midnight).
- `ForeverDoNow.lua`: spellnamen in de regels "new spells on no bar", "coming up" en de talentregel zijn nu
  `|Hspell:id|h…|h` (`SpellLink`); het venster heeft `SetHyperlinksEnabled` + `OnHyperlinkEnter` (body staat op het
  venster zelf, niet in een ScrollFrame) en shift-klik = spell-link in de chat. Dedup in "coming up" vergelijkt nu op
  de platte naam (anders twee id's met één naam dubbel). `/mh donow check` print nog de platte namen.
- `ForeverOverview.lua`: Now-pagina "Coming up": ook de NAAM heeft nu de spell-tooltip (was alleen het icoon).
  Trainer-pagina: de naam toont de spell-tooltip van het spel met onze sleutel-regel eronder; kop/notitie-rijen wissen
  een oude `tipSpell`.
- `ForeverStyle.lua` `S.Tip`: met `tipSpell` én `tipBody` komt onze regel onder de spell-tooltip (tot nu toe werd
  `tipBody` dan genegeerd; `tipSpell` werd alleen op icoontjes gezet, zonder body — GEMETEN: alleen ForeverOverview).
- Het losse trainer-venster (`ForeverTrainer.lua:712-739`) had al een spell-tooltip per regel sinds 7 nov (GEMETEN);
  de inventaris (mh-sweep) zei "UNKNOWN".
- ⚠️ In de Now-kaart van het overzicht staan de spellnamen als link-tekst zonder hover (die kaart heeft geen
  hyperlinks). Ziet er hetzelfde uit; tooltip daar = later, als Rob het mist.
- Gecontroleerd: syntax OK en lint 0 HARD (GEMETEN, vlak voor de commit). NIET in het spel gezien.

## ▶ 19 nov — Bouwchat 19-11: tooltips van het spel, stap 1 (loot in de bazengids) GEBOUWD

Rob via sparring, letterlijk: *"overal waar wen tooltip bestaat in de game wil ik ook in de addon zien :)"* en *"Tooltip
over beide"* (Midnight + Forever). In `docs/IDEEEN.md` onder "Ja".
- `ForeverDungeonGuide.lua`: `ns.ForeverDungeonGuideText(map, split)` geeft met `split` de loot apart terug; `Fill` zet
  elke loot-regel als eigen Button-rij onder de tekst (`LootRow`, hergebruikt) met `GameTooltip:SetHyperlink("item:<id>")`
  en een klik met modifier via `HandleModifiedItemClick` (zoals `RaidShoppingList.lua:520`). Reden voor rijen i.p.v.
  `|Hitem|h`-links: links in een FontString in een ScrollFrame reageren niet op de muis (`PlayCardWindow.lua:99`,
  `DelveTipMarkup.lua:483`). Zonder `split` geeft de functie de oude volle tekst (slash/tests).
- Gecontroleerd: Lua-syntax hele repo OK (GEMETEN). NIET in het spel gezien; niet offline in een stub gedraaid.
- Open: inventaris van alle andere plekken zonder tooltip (helper mh-sweep loopt) → lijst + volgorde naar de sparring.
  Bazenregels hebben geen spell-id in de data → geen spell-tooltip zonder nieuwe data. (npc-id wél: `b.npc`; zie
  de correctie bovenaan, 19 nov.)
- NIET meegenomen (geen ja): een vindbare plek voor `/mh ranks choose`.

## ▶ 18 nov (avond) — `/mh disenchant` gemeten door Rob

Rob (via sparring, screenshot, Ima Magieman na herstart): Enchanting learned true, spell 13262 known true, Baganator
registered (GEMETEN). Tassen leeg, dus tooltip/icoontjes/next-knop nog niet gezien; /dump voor optie B blijft open.
"last tooltip: skipped: FDE_WHY_KIND" was geen ontbrekende sleutel (alle 7 talen hebben hem, GEMETEN) maar de ruwe code
in de diagnose. `ForeverDisenchant.lua`: toont nu "skipped: <tekst> (<code>)".

## ▶ 18 nov (nacht, later) — Bouwchat addons-12: optie A (wapens) + Cozy Sleeping Bag GEBOUWD

Rob via sparring, letterlijk: *"Oh en 1 t/m 3 mag ook"*, *"Ik ben onderweg dus kan niks in game doen"* en *"Ja"* op de
volgorde (1 optie A, 2 wapenquests, 3 slaapzak, 4 optie B nog NIET; zijn /dump-meting staat bovenaan TESTLIJST).
- ⚔️ **Optie A** (`ForeverQuestHint.lua`, één rekensom voor tooltipregel, questbeloning en "Upgrade in your bags"):
  `Worn()` per wapensoort — 1H tegen je hoofdhand (met Dual Wield 674 en een wapen in de off-hand: tegen de zwakste;
  lege off-hand + Dual Wield: vult die hand); 2H tegen beide handen samen (ook DPS opgeteld); schild/off-hand-ding
  bij een tweehander of off-hand-wapen zonder Dual Wield = geen oordeel (nooit "beter", en dan ook geen
  "verkoop"-advies). DPS (`Dps()`: stats-tabel of de tooltipregel DPS_TEMPLATE, GEMETEN GlobalStrings 12672/19881)
  telt alleen voor Strength/Agility; minder DPS = nooit "beter"; meer DPS met minder Stamina = stil (gemengd = optie B).
  Nieuwe reden `FQH_WHY_DPS` (7 talen, clientwoord per taal GEMETEN). Questbeloning kiest de beste van meerdere betere.
  Tweede controle (Fable, `docs/forever/CONTROLE_OPTIE_A_WAPENS_2026-11-18.md`): 5 FOUT + 10 RISICO, de geteste patch
  is overgenomen. Offline: mijn 18 + zijn 36 gevallen; 2 bewust open: Franse spatie als duizendtal (> 1000 DPS) en een
  hunter met een melee-wapen als stat stick (melee-DPS telt dan mee). Niet meetbaar zonder client: of de wapentooltip
  de DPS-regel heeft. ✅ Dat `GetItemStats` DPS vult: GEMETEN door Rob op 19 nov (zie boven).
- 🔧 Ook gerepareerd (zelfde controle): `ForeverBlock.lua` KnownId — `ipairs({ IsPlayerSpell, IsSpellKnown })` stopte
  bij de eerste nil (IsPlayerSpell is in Forever alleen een deprecation-fallback, GEMETEN Blizzard-bron); nu vaste
  plekken met `C_SpellBook.IsSpellKnown` voorop. Raakte de talentcheck voor de hoofdstats op niet-Engelse clients.
- 🛏️ **Cozy Sleeping Bag** (`ForeverCamp.lua`): hotfix 17 nov GEMETEN (Blizzard News: "Resting aura … within its area",
  "Mounted Players will no longer be permitted to sleep"). Aura 1331671 "Resting" (tas-icoon): GEMETEN Wowhead Forever +
  Icy Veins DB ("added in 1.60.1.70959"), NIET in de basis-DB2 (hotfix-rij; positieve controle 1286090 wel gevonden);
  dat het DE slaapzak-aura is = AFGELEID. Well-Rested 429959 (+1% XP per stapel, max 3), Unroll Bag 429961 (ItemEffect
  van 211527): GEMETEN. Do this now: in het gebied + niet op een mount + minder dan 3 stapels → "lie down in it … %d of
  3"; op een mount → "get off first"; onleesbaar = stil. `/mh camp` toont beide aura's + stapels + mount. Teksten 7 talen
  (+ esMX "bolsa de dormir", GEMETEN). Offline 8 gevallen OK.
- 🗡️ **Wapenquests per class GEBOUWD** (`ForeverClassQuests.lua`, blok "Weapon class quests" vóór `local MOONGLADE`):
  warrior "first weapon" lvl 10 (5 routes per startgebied), warlock Soran'ruk 20 / Orahil 35 / An Imp's Request 50,
  shaman The Tempest's Weapons 30 (A + H). Onderzoek (Fable): `docs/forever/WAPENQUESTS_ONDERZOEK_2026-11-18.md`;
  tweede controle (Fable): `docs/forever/WAPENQUESTS_CONTROLE_2026-11-18.md` — 3 FOUT (ritueel-pijl 31.0,45.8 →
  36.8,39.2 GEMETEN WHT 216474; Orahil "gebruik de steen als hij bijna dood is" GEMETEN WHT 4962/4963; Windshaper-
  commentaar) + Orahil-risico (steen-stappen nu `pre` met `unlessDone`, nieuw in `PreStep`) verwerkt. Offline: 5
  Orahil-gevallen OK, 109.424 runs 0 fouten. Teksten: 30 sleutels × 7 talen + esMX 18 (namen GEMETEN), deDE
  Charlga = Klingenflanke (regel B-bijstelling). Open: Horde-Tempest gevers/inleveraars (TESTLIJST), ~~Windshaper-shaman~~
  (✅ 19 nov: Skyborne in de rassen), Agamand-rek-id's bijl/zwaard, ~~aparte level-up-melding~~ (❌ 19 nov: Rob = nee),
  "eerst Felcloth" pas zichtbaar na de Inferno-keten, een lichter ogre-kamp voor Twisted Fire (1 gids).

## ▶ 18 nov (nacht) — Bouwchat addons-12: Fable-nakijkronde (punt 1 van Robs ja) GEDAAN

Rob via sparring, letterlijk: *"Fable mag en ik volg je advies"*. Vier Fable-helpers (G1-G4) kregen alleen code + teksten
(geen rapporten). Rapporten: `docs/forever/FABLE_NAKIJK_G1..G4_*_2026-11-18.md`. Samen ±20 FOUT + ±50 RISICO; verwerkt:
- **Bazengids, code** (`ForeverDungeonGuide.lua`): itemnamen bleven "#id" (alleen GET_ITEM_INFO_RECEIVED) → tweede
  naamopvraag + `Item:ContinueOnItemLoad` (één per item) + ticker 0,5 s × 10 (zoals ForeverVendors); lijst sprong terug
  bij elk event → alleen scrollen als de keuze verandert (`f.scrolledFor`); tekst opent bovenaan bij een andere dungeon.
- **Bazengids, data**: looproute Deadmines (Smite vóór Greenskin) en Ruins of Lordaeron (Witherfang, Baron, Viktor,
  Abandoned…), sleutels in 8 taalbestanden omgenummerd (scratch `dg1_reorder.py`, 15 per bestand, steekproef GEMETEN);
  Lordaeron Captain npc 255699 (GEMETEN WHT); Baron Aquanis = alleen Horde met de quest (Fathom Stone); 23 Engelse
  regels 2a herschreven (Azshir fear = één speler, Katerina-bloeding, Noxxion vaste tijd…); Kelris frFR kleine c;
  bronregel Anacondra. Stap-1-bron staat nu in deze scratchpad (`dg1_data.lua`; de generator wijst ernaar).
- **Vertalingen**: o.a. deDE "Schwere Rüstung", ptBR "cajado"/"Défias"/"Draconiano", esES "mallas", Engelse
  plaatsnamen BRD/ST/Strat in de/fr → clientnamen (WMOAreaTable), "Black Anvil", Angry Tomes, ruRU "Реликварий",
  skycutter-woord in alle talen (ook `Translations2026.lua`), Watchman Doomgrip esMX. "Crusaders' Square" is juist
  (Forever WMOAreaTable; mijn eerdere "Crusader's" kwam uit een retail-kaarttabel en was fout).
- **Class quests** (`ForeverClassQuests.lua`): strikte keten toont nu een "koop het hier"-waarschuwing van ELKE quest in
  je log (warlock potions kwamen anders niet); Ur'dan npc 14522 (GEMETEN) → "you pay it to Ur'dan".
- **Travel**: veerboot terug vanaf Feathermoon → "the Forgotten Coast" (nieuwe sleutel FTRAVEL_FORGOTTEN_COAST, 7 talen).
- **Disenchant**: knop `useOnKeyDown = false` (anders dood bij "cast on key down", Forever SecureTemplates).
- **Open, voor Rob (via sparring)**: G1 adviseert "Wowhead wint altijd, ook als de naam Engels is" — tegen Robs net
  goedgekeurde bijstelling; niets veranderd. G2: 6 fr/ru-namen verschillen alleen in accent/hoofdletter — zo gelaten.
  Niet meetbaar zonder client: welke naam het naamplaatje echt toont, of `GetItemStats`/`CastSpellByID(13262)` werken.
- Bekende rest-risico's (in de rapporten): `optional` wordt nergens getoond; enkele `src`-velden beschrijven de oude
  tekst (Loksey, Anomaly, Wrex, Noxxion); "Fly to Orgrimmar with Tal" vraagt dat je dat vliegpunt kent (tekst nu zo).

## ▶ 18 nov (laat) — Bouwchat addons-12: bazengids STAP 2b GEBOUWD + namen van het naamplaatje

- ✅ **Bijstelling van keuze B GEBOUWD** (Rob via sparring, letterlijk: *"Ja, volg jouw advies, dus dat mag."*): is de
  naamplaatje-naam in een niet-Engelse taal gelijk aan de Engelse naam terwijl DB2 DungeonEncounter wél vertaalt → de
  DB2-naam (Wowhead valt dan terug op Engels, GEMETEN door sparring met npc 647 vs 639); esMX zonder eigen naam → esES.
  Alle 267 bazen nagelopen met scratch `dg2_namesC.py` → `dg2_names_fix.lua` (generator past hem toe na de plates):
  **30 namen** (deDE 13, frFR 14, esES 2, esMX 1; bv. deDE "Kapitän Grünhaut", "Hauptmann Krombruch", frFR "Baron
  Vaillefendre"). Overgeslagen: alleen een andere apostrof, groepsgevechten, DB2-encounter met een andere Engelse naam.
  Zinnen: `dg2_namesC_text.py` vond 5 regels met de hele oude naam (de/fr/es) → vervangen; 4 treffers met alleen een
  voornaam of een andere naam bleven. ⚠️ `dg2_namesC.py` leest het GEGENEREERDE bestand: niet opnieuw draaien nadat de
  fix erin zit (dan maakt hij een lege lijst); bij een nieuwe baas eerst `dg2_gen.py all2b` zonder `dg2_names_fix.lua`.
  Ook vastgelegd in `docs/CLIENT_NAMES_2026-10-20.md`. Het esMX-punt hieronder ("Engels of esES") is hiermee beslist
  voor de bazennamen én de zinnen: 13 esMX-overlayregels (11 uit 2b + ZF_6_D1/ZF_8_D1 uit 2a) verschilden van esES
  alleen in een Engelse placeholder-npcnaam (scratch `dg2_mx11.py`) → verwijderd, esMX toont nu de esES-zin.

- 🗺️ **Stap 2b GEBOUWD** (zelfde bouw-ja): Sunken Temple, Blackrock Depths, Dire Maul (East/North/West), Blackrock Spire
  (Lower/Upper; Upper = 10 spelers, GEMETEN GroupFinderActivity 837), Scholomance, Stratholme (Main Gate/Service Gate) +
  nieuw in Forever (recheck): Blackmaw Hold, The Shaper's Terrace. Nu **28 dungeons, 267 bazen, 106 items** (GEMETEN in
  generator + offline test). Geen nieuw bestand → `/reload`. Geen codewijziging nodig (alleen de kop van de module).
  - 4 mh-research (D/E/F/G) + 2 Opus-controles (`docs/forever/DUNGEONGIDS_CONTROLE2B_{DE,FG}_2026-11-18.md`): 2 FOUT
    (Dire Maul North binnendeur bij een tribute run; Tor'Rel-zin bijna letterlijk) + 24 RISICO, allemaal verwerkt door
    een mh-writer (30 Engelse regels, opnieuw vertaald). Malor the Zealous bewust NIET optional (bronnen tegenstrijdig).
    Bronnen: `docs/forever/DUNGEONGIDS_DATA2B_2026-11-18.md`.
  - ✅ **Robs keuze "B" GEBOUWD**: scratch `dg2_gen.lua` leest `dg2_names_B.lua` (147 bazen × 6 talen, GEMETEN Wowhead
    Forever) en vervangt 52 namen in stap 1 + 2a; verschillen in alleen apostrof/accent/spatie/hoofdletter niet
    (AFGELEID: Wowhead-spelling); groepsgevechten (Lost Dwarves, Atal'ai Defenders, The Seven) houden de groepsnaam.
    Lijst: scratch `dg2_plate_changes.tsv`. In de zinnen 9 regels aangepast (de/fr/es/ru); esMX houdt "Faucepeste"
    (esMX-naamplaatje). 2b-bazen kregen meteen de naamplaatje-naam. Gevolg (GEMETEN Wowhead Classic = Forever): deDE/
    frFR tonen vaak de Engelse Classic-naam ("Captain Greenskin", "Mr. Smite"). In het spel: NIET gezien.
  - Vertaald (2 mh-writers + 1 voor de 30 reparaties). Vertaalcontrole (2 Opus,
    `docs/forever/DUNGEONGIDS_VERTAALCONTROLE2B_{NDF,EPR}_2026-11-18.md`): 12 FOUT (o.a. deDE "Zauberdurchdringung",
    esMX "calabozo" i.p.v. "mazmorra", esES "coger" → "tomar", ptBR "Praça dos Cruzados") + risico's; 39 regels
    verbeterd. (enUS/nlNL "Crusader's Square" was een fout van de bouwchat — gemeten in een retail-kaarttabel; de
    Forever-zonetekst, WMOAreaTable 1.60.1.70959, zegt "Crusaders' Square". Teruggezet in de Fable-ronde.) (Het esMX-placeholderpunt is beslist en gebouwd: zie "Bijstelling van keuze B" hierboven.) Sleutels per taal GEMETEN: 999
    (enUS = 986 gids + 13 UI), geen dubbele/verouderde/ontbrekende; esMX-overlay 69, geen verouderde regel (scratch
    `dg2_mxcheck.py`).
  - Open: Sunken Temple heeft in Forever een NIEUWE encounterset (3582-3589) naast de oude (`encounterAlt`), welke vuurt
    = meten; Scarlet Bastion-deur (Scarlet Key?); King Gordok/Cho'Rush id; Titan Panel en "Archival Panel" zonder
    clientnaam; esES Roughshod Pike zonder naam in ItemSparse ("Pica despiadada" uit een itemtekst, niet gebruikt);
    BRD-plekken in es/pt/ru deels uit LibBabble-SubZone (Zygor), niet uit de client.
  - Scripts: `dg2_gen.py all2b` (ORDER/SHORT 2b via DG_2B; DG_PLATES), `dg2b_diff.py`, `dg2b_newkeys.py`, `dg2b_docs.py`.
- ⏭️ Volgende voor de bazengids: Robs test. Stap 3 (raids, open 9 dec) staat in IDEEEN H14, nog niet bouwen.

## ▶ 18 nov (avond) — Bouwchat addons-12: bazengids STAP 2a GEBOUWD

- 🗺️ **Stap 2a GEBOUWD** (Robs bouw-ja via sparring: *"Ga maar verder met 2"*). 11 dungeons erbij: Gnomeregan, Razorfen
  Kraul, Scarlet Monastery (4 vleugels, één pagina), Razorfen Downs, Uldaman, Zul'Farrak, Maraudon (4 delen) + nieuw in
  Forever (alles `recheck`): City of Dalaran, The Drowned City, Krol'dok Stronghold, Alcaz Prison. Nu 20 dungeons,
  148 bazen, 70 items (GEMETEN in de generator én de offline test). Geen nieuw bestand → `/reload`.
  - Code `ForeverDungeonGuide.lua`: dungeonlijst links scrolt (venster 640→660 breed); `part` = vleugelkopje (FDGP_*-
    sleutel, vertaald; SM-vleugels hebben in de client geen eigen naam, GEMETEN door de vertalers); level-bereik over
    alle rijen van één kaart (SM 30-46); `extraNpc` mag een lijst zijn (`IsBoss`; The Lost Dwarves = 3 npc's, Olaf 6908
    GEMETEN); lijst scrolt naar de gekozen dungeon (+ één Fill een frame later, AFGELEID nodig voor de eerste opening).
  - Data: 3 mh-research-helpers (A/B/C), 2 onafhankelijke Opus-controles: **0 FOUT, 23 RISICO**; 33 Engelse regels
    gerepareerd (o.a. Doan "op halve health", Fairbanks optioneel + fakkel, Fel Ancient eerst treants, Questioner als
    laatste in de lijst, 11+3 zinnen te dicht bij een gids herschreven) en opnieuw vertaald. Bronnen + controles:
    `docs/forever/DUNGEONGIDS_DATA2A_2026-11-18.md`, `DUNGEONGIDS_CONTROLE2A_A_…`, `…_BC_2026-11-18.md`.
  - Vertaald nl/de/fr/es/pt/ru + esMX-overlay (2 mh-writers + 1 voor de 33 reparaties). Sleutels per taal GEMETEN
    (scratch `dg2_keycheck.py`: geen dubbele, geen verouderde, geen ontbrekende).
  - Vertaalcontrole (2 Opus, `docs/forever/DUNGEONGIDS_VERTAALCONTROLE2A_{NDF,EPR}_2026-11-18.md`): 11 FOUT (deDE/frFR
    Shadowforge Geologist = clientnaam, deDE naamvallen, esES "turn away" ≠ "wegzetten" 4×, ptBR quilboar = javatusco)
    + risico's; 26 regels verbeterd. ruRU en esMX: geen fout. Open (zelfde soort, stap 1): esES `FDG_SFK_5_T` heeft
    ook "wegzetten"; esES mengt "a dos manos"/"de dos manos" (client: "de dos manos").
  - Offline (scratch `search_check.lua`, blok "Step 2a"): 20 dungeons, 0 ruwe sleutels, SM-kopjes in volgorde, lijst
    scrolt naar Alcaz (532 px), SM-kop 30-46, 23 dungeonrijen met Bosses-knop; 109.372 runs, 0 fouten. NIET in het spel.
  - ✅ **Rob koos B** (via sparring, letterlijk: *"B"*): bazennaam per taal = de naam van het **naamplaatje** (Wowhead
    Forever npc-naam per locale), niet de DB2 DungeonEncounter-naam. Geldt voor ALLE dungeons, ook stap 1. ✅ Gebouwd
    in stap 2b (zie daar). Oorspronkelijk plan: `names` per baas uit WHT `--locale` (esMX ook, bestaat bij Wowhead, GEMETEN door deel B); ook de
    bazennamen IN de vertaalde zinnen (tips) nalopen. Het gaat om ~25 bazen in fr/de/es/ru (bv. frFR Vislar→Vishas,
    deDE Schönufer→Fairbanks, deDE Nar'gurk→Nar'guk, ruRU Келебрас→Селебрас). Het idee "naam onthouden bij het
    targeten" koos hij NIET: niet bouwen. Staat ook in `docs/CLIENT_NAMES_2026-10-20.md`.
  - Let op voor stap 1 (controle C): method.gg en Wowhead-gids Ruins of Lordaeron zijn misschien dezelfde auteur
    (Jurdi) → daar telden ze als twee bronnen. Niet nagekeken.
  - ⚠️ `tools/lua_syntax_check.py` negeert een bestandsargument en checkt altijd de hele repo (GEMETEN door 3 helpers).
  - Scripts (scratchpad van deze chat, `…\0ff9d808-51da-56d7-a418-3ca97753cc37\scratchpad\`): `dg2_gen.lua/.py`
    (`old` = stap 1 opnieuw + diff met de repo, gaf 0 verschil; `all` = stap 1 + `dg2a_A/B/C.lua` → repo; ORDER/SHORT
    uitbreiden voor 2b), `dg2_apply.py` (`enus` = alleen nieuwe sleutels; `<prefix>` = vervang of voeg toe per taal),
    `dg2_diff.py` (gewijzigde Engelse regels na een controle; Alcaz-omnummering), `dg2_keycheck.py`, `search_check.py`,
    briefs `dg2a_brief.md`, `dg2a_vertaalbrief.md`, `dg2a_controlebrief.md` (herbruikbaar voor 2b).
- ✅ (gedaan, zie hierboven) **STAP 2b**, zelfde recept en dezelfde scripts. ⚠️ SHORT "DM" is al The Deadmines: Dire Maul krijgt een
  andere sleutel (bv. DIRE). Dire Maul (429), Blackrock Spire (229) en Stratholme (329) hebben vleugels → `part`.

## ▶ 18 nov — Bouwchat 18-11

- ✅ (stap 2a is gebouwd, zie hierboven; het recept hieronder geldt ook voor 2b) **bazengids STAP 2 (dungeons ~32-60) — bouw-ja is er** (Rob via sparring, letterlijk: *"Ga maar verder met
  2"*; eerder: *"foutloos"*, *"Die nieuwe dungeons erbij. En dan later nog een keer controleren"*). NIET begonnen in
  Bouwchat 18-11: de context was vol (sparring vroeg dan eerst de handoff). Recept, zelfde als stap 1:
  1. Splits: **2a** = Gnomeregan, Razorfen Kraul, SM (Graveyard/Library/Armory/Cathedral), Razorfen Downs, Uldaman,
     Zul'Farrak, Maraudon + nieuw: City of Dalaran (28-35, valt in de rand), The Drowned City, Krol'dok, Alcaz Prison;
     **2b** = Sunken Temple, BRD, Dire Maul (E/N/W), LBRS, UBRS, Scholomance, Stratholme (2 delen) + nieuw: Blackmaw
     Hold, The Shaper's Terrace. Map-id's: `Modules/ForeverDungeons.lua` DUNGEONS. Meld de splitsing aan sparring.
  2. mh-research maakt per deel de data in hetzelfde formaat als `dungeon_guide_data.lua` van stap 1 (velden: encounter,
     npc, name, names per taal uit DB2 DungeonEncounter, does 1-3, tip, src met 2 bronnen, one, rare, recheck voor
     nieuwe dungeons, measure; loot 2-3 items met "Dropped by" + stats uit Wowhead Forever, rol). Bronregels: zie de kop
     van `Modules/ForeverDungeonGuideData.lua` en `docs/forever/DUNGEONGIDS_DATA_2026-11-18.md`. Let op:
     `tools/gamedata.py` print maar 8 tooltipregels ("Dropped by" valt weg): volledige JSON via een scratch-script.
  3. Scripts van stap 1 (oude scratchpad, map
     `C:\Users\RobHu\AppData\Local\Temp\claude\E--World-of-Warcraft--retail--Interface-AddOns\bcc6113e-4d5e-5fd0-87be-27c8b4e4d9ef\scratchpad\`):
     `dg_gen.lua`/`dg_gen.py` (data → `ForeverDungeonGuideData.lua` + enUS-regels + TSV voor vertalers; ORDER/SHORT
     uitbreiden en de bestaande 9 behouden: de nieuwe data AAN de oude toevoegen, niet vervangen), `dg_insert.py`
     (regels na `\tFDG_HINT =` invoegen), `dg_fix_apply.py` (correcties per sleutel; esMX = overlay), `stat_words.txt`
     (gemeten stat/slotwoorden), `search_check.lua`/`.py` (offline test, blok "Boss guide"). Kopieer ze naar je eigen
     scratchpad en draai ze via de voordeur.
  4. mh-writer vertaalt (7 talen, regels zoals stap 1: clientwoorden, geen verzonnen monsternamen, geen recht ").
  5. Tweede, onafhankelijke Opus-controle op code + tekst (geeft fix-bestanden per taal) → toepassen → offline test →
     lint als laatste → TESTLIJST/NEXT_SESSION → push. Geen tag/release. Geen nieuw bestand → /reload.
- 🗺️ **Forever bazengids STAP 1 GEBOUWD** (Rob via sparring: *"Ja bouw maar"*; daarna *"Die nieuwe dungeons erbij. En dan
  later nog een keer controleren. … Uiteindelijk wil ik gewoon alle dungeons erin hebben … En ook de nieuwe raids"*).
  ⚠️ **2 nieuwe bestanden → WoW herstarten.**
  - `Modules/ForeverDungeonGuide.lua` (venster stijl A, `/mh bosses [check]`, knop "Bosses" op de dungeonregels in het
    overzicht, opent op je huidige dungeon, target = baas gemarkeerd incl. extraNpc) + `ForeverDungeonGuideData.lua`
    (GEGENEREERD door scratchpad `dg_gen.lua` uit `dungeon_guide_data.lua`; bronnen per regel als commentaar).
  - 9 dungeons tot ~32 (RFC, Hall of Thanes, Ruins of Lordaeron, WC, DM, SFK, Stockade, BFD, Excavation Site), 59 bazen,
    27 items. De 3 nieuwe: `recheck` + regel bovenaan voor de speler. `one` = "(one of these lines comes from one guide only)".
    Geen drop-kansen. Bazennamen per taal: DB2 DungeonEncounter, behalve Magmatus/The Baron/Plunder (npc-naam van Wowhead;
    DB2 zegt Infurnus/The Butcher/Plünderung…) en 3 rares zonder DB2-rij (Wowhead per taal).
  - Teksten: 192 FDG_*-sleutels + 13 UI-sleutels, 7 talen (mh-writer), stat/slotwoorden GEMETEN (GlobalStrings ITEM_MOD_*,
    INVTYPE_*). esMX-overlay: 7 regels (Mano derecha/izquierda, Abalorio, Poder con hechizos, calabozo).
  - Tweede Opus-controle (`docs/forever/DUNGEONGIDS_CONTROLE3_2026-11-18.md`): 9 FOUT, alle gerepareerd (o.a. 6× "one-hand"
    = Main Hand, LORD_6_D2 geen vuur, WC_7_T te dicht bij Icy Veins, DM_5_T, 3× ontbrekende namen, Shredder-markering,
    Disciple of Naralex-naam terug in 5 talen); 3 van de 11 RISICO's ook (Plunder-naam, one-source-tekst, EXCAV_4 stomp).
  - Open: Silverlaine-spell, Magmatus/The Baron/Plunder-naam in de client, BFD encounter-set (TESTLIJST); ~20 klassieke
    bazen hebben in DB2 een andere taalnaam dan Wowhead (DB2 gevolgd; alleen een niet-Engelse client beslist).
  - ⚠️ Bij opnieuw genereren: de Engelse teksten in `dungeon_guide_data.lua` zijn NIET bijgewerkt met de 11 correcties
    (die staan direct in enUS.lua); dg_insert weigert dubbele sleutels, dus enUS blijft goed.
  - Plan (IDEEEN H14): stap 2 = dungeons 32-60, stap 3 = raids (open 9 dec).
- 🗺️ **Forever dungeon-gids: ALLEEN ONDERZOCHT, niets gebouwd** (Rob: *"… daarna door naar 1"*; sparring: eerst onderzoek
  + voorstel). `docs/forever/DUNGEONGIDS_2026-11-18.md` (mh-research) + `DUNGEONGIDS_CONTROLE2_2026-11-18.md` (tweede
  Opus) + voorbeelddata DM/WC/SFK (`dungeongids_voorbeeld_2026-11-18.lua.txt`, geen addon-bestand).
  - GEMETEN: Journal-tabellen ontbreken in Forever DB2 (HTTP 400, positieve controle retail); `DungeonEncounter` wel
    (376 rijen, namen per taal; dubbele sets + testrijen); `Blizzard_EncounterJournal.toc` r.7 `AllowLoadGameType:
    standard, classic` → laadt niet in Forever. 9 nieuwe Forever-dungeons (alleen in Forever). DungeonBossWindow.lua is
    Midnight-only (patroon herbruikbaar).
  - Let op: drop-% uit gidsen = Classic-cijfers (Wowhead Forever wijkt af, bv. Meteor Shard 29,4% i.p.v. 18%); 5 itemstats
    verschillen. Silverlaine-spell niet zeker (7068 vs 460755). ForeverDungeonJournal: geen licentie → niets overnemen;
    Spoken_Bosses: "Addon code MIT" (data onduidelijk).
  - Voorstel bij sparring: A / B / C, advies A+ (1-3 regels per baas + 2-3 items per dungeon, eerst 9 dungeons tot lvl 32,
    zonder drop-%). ⏳ Rob kiest.
- 📦 **Forever Openables GEBOUWD** (Rob via sparring: *"Ik denk dat 3 het makkelijkste is dus die kunnen we nu doen en
  daarna door naar 1"*). Midnight's `Modules/Openables.lua` hergebruikt (zelfde secure knop `type=item`, één klik = één
  item, opbouw alleen buiten combat, verborgen in combat): nu ook in `MidnightHelper_Camelot.toc` → herstart.
  - Herkenning = client-vlag `hasLoot` (GEMETEN in gebruik door Baganator/Syndicator in Forever) + tooltipregel
    `ITEM_OPENABLE` (in alle Forever-talen, GEMETEN DB2 70959). NIET met een eigen itemlijst uit DB2 (een lijst veroudert;
    de client weet het).
  - Nieuw, alleen Forever: tooltipregel `LOCKED` ("Locked", GEMETEN) → niet aangeboden, geteld voor `/mh open`.
  - Standaard AAN (advies: hij verschijnt alleen als er iets te openen is en is in combat weg); schakelaar bij de stille
    helpers (`FOV_Q_OPENABLES`), `/mh open [on|off]`. `SetOpenablesEnabled` maakt `ns.db.ui` als Forever die nog niet heeft.
  - Pick Lock per taal GEMETEN (SpellName 1804; esES Ganzúa, esMX Forzar cerradura → esMX-regel).
  - Offline: schelp → knop `item:5523`, lockbox op slot overgeslagen, drankje niet; aan/uit. 0 fouten.
  - Tweede Opus-controle (Rob: *"Zuinig is goed maar het moet wel foutloos 💪"*; `docs/forever/OPENABLES_CONTROLE2_
    2026-11-18.md`): geen FOUT, 4 RISICO. Gerepareerd: R1 "Locked" wordt nu eerst over de hele tooltip gezocht (ook
    na een rode regel) en zonder leesbare tooltip biedt Forever niets aan (niet terugvallen op hasLoot); Frans
    "Verrouillé(e)" ↔ "Verrouillé" beide; R2 uitzetten in combat roept geen Hide() aan (na combat wel; dit geldt ook in
    Midnight: daar kon dat een blokkade geven); R3 zit van hetzelfde item ook een doos op slot in je tas, dan richt de
    knop op het tasvak ("bag slot") i.p.v. het item-id. R4 (Engelse "Use:"-patronen in andere talen) = alleen minder
    aanbieden, zo gelaten. Offline alle gevallen nagespeeld, 0 fouten.
  - In het spel te meten (TESTLIJST): `hasLoot` en de "Locked"-regel van een doos op slot (`/dump`-regels in het verslag).
- 🎚️ **Ranks zelf kiezen + Study lager GEBOUWD** (Rob via sparring: *"Een studie, laten we inderdaad jouw advies volgen,
  lager zetten. En wat de Finse speler betreft, werk dat maar vast uit."*). Speler (vragenlijst 18 nov, Druid 20-39, FI):
  *"I would like to choose which action bar spells I want to upgrade."*
  - `ForeverRanks.lua`: `Except()` per character (`foreverRanks.except[char].bars[n]`, `.buttons["slot:spell"]`),
    `BarOf` (Blizzard-knop wint, anders slot-reeksen: AFGELEID), `Scan(withSkipped)` laat uitgezonderde weg → rand,
    telling, zin, trainerknop, fix en auto respecteren het. Keuzevenster `MidnightHelperForeverRanks` (stijl A via
    SkinOnShow, RegisterMidnightDialogPopup): per balk "never touch this bar", per knop vinkje + "never", knop "Upgrade
    checked". `/mh ranks choose`, Shift-klik op de trainerknop; `/mh ranks` toont de uitzonderingen.
  - Study: chain `low = true` → laatste in NowPick (pass 3), en in Do this now een TIP (opent het venster niet zelf).
  - Offline: Aimed Shot op 3 balken, bar 3 uitgezonderd, auto aan → alleen de net getrainde (slot 61) omhoog; knop slot 1
    uitgezonderd → fix verandert niets; venster 4 regels; na vrijgeven + "Upgrade checked" alleen slot 1. 0 fouten.
  - ⚠️ Gezien: `CharKey()` neemt de realm van `GetRealmName` (de `UnitFullName`-tak verliest de 2e waarde door `and`);
    werkt in het spel, alleen opgemerkt.
- ✨ **Forever disenchant + inklapbare Find-kopjes GEBOUWD** (Rob via sparring: *"Hoe kan ik zien of ik iets kan
  disenchanten? …"* → *"Ja, dat mag zo. … Baconator [Baganator] …"* → *"ja"*; en *"Kunnen we daar inklapbare dingen van
  maken? …"* → *"ja"*). ⚠️ **2 nieuwe bestanden → WoW herstarten.**
  - Kopjes: `FindCatalog` geeft elk kopje een `sec`-id (class/prof/weapon/shop/city/travel/rare); `FillFindPage` toont
    alleen open kopjes (plus/min-textuur, aantal verborgen). `ns.db.foreverFindOpen[sec]`; ongeklikt = alleen het kopje
    van wat je open hebt; een selectie van buitenaf (zoekbalk, ShowForeverFind) opent zijn kopje.
  - `Modules/ForeverDisenchant.lua` (+ gegenereerd `ForeverDisenchantData.lua`, 54 rijen, 1615 vlag-items): verdict
    yes/unsure/no; tooltipregel met de client-woorden; icoon in Blizzard-tassen + Baganator corner widget; secure knop
    "Disenchant next" (standaard UIT); `/mh disenchant`; twee schakelaars bij de stille helpers (FOV_Q_DISENCHANT*).
  - Onderzoek: `docs/forever/DISENCHANT_2026-11-18.md` + tweede controle `DISENCHANT_CONTROLE2_2026-11-18.md`.
  - Offline: verdicts (8 gevallen), bag-hook, Baganator onUpdate true/false/nil, knop-attributen, overslaan, combat
    (pending) → na combat bijgewerkt, kopjes open/dicht/zoek-opent. 0 fouten. NIET in het spel gezien.
  - Open (in het spel meten): skill-drempel (AFGELEID geen), of de server vlag/geen-verkoopprijs weigert, of de secure
    knop met Disenchant + tasvak werkt, `C_SpellBook.IsSpellKnown(13262)`.
- 📚 **Forever class quests: eerst wat je nodig hebt, dán de reis — GEBOUWD** (Rob via sparring, letterlijk: *"Ik ben de
  halve wereld over gereisd om bij dit quest te doen … dan had ik een boek moeten hebben …"* → *"ja"*). Onderzoek één
  mh-research → `docs/forever/CLASSQUEST_VOORWAARDEN_2026-11-18.md` (tabel per class + wat NIET gemeten is).
  - `ForeverClassQuests.lua`: BookStep (97286 `book = true`: boek-quest gedaan → bibliothecaris; boek in tassen →
    inleveren; anders → dichtstbijzijnde START_BOOKS van je kant, gidsplekken ×1,5 + "uit een spelersgids"); PreStep
    (`pre` gold/items/spell, terwijl de quest in je log staat): paladin 7637 + warlock 7625 150 goud, warlock 7623
    Shadowy Potion (niet in Felwood), priest-robe Lesser Heal R2 (2052, AFGELEID dat de client een rank zo meldt).
    1948 sticks 10. Teksten `s.text` naast `s.textKey`.
  - Vertaald de/fr/es/esMX/pt/ru; item/spell-namen GEMETEN (ItemSparse 18802/7272/7273, SpellName 2052, esMX "Sanación").
  - Offline: mage zonder boek → boek (Elwynn / Brill), boek in tassen → bibliothecaris, ingeleverd → 97286 halen; paladin
    arm → "first get 150 gold" (geen pijl), rijk → Rohan; warlock zonder potion → Gorzeeki, in Felwood → Banehollow;
    priest zonder rank 2 → trainer. 0 fouten.
  - Tweede Opus-controle (`docs/forever/CLASSQUEST_CONTROLE2_2026-11-18.md`): 2 FOUT + 10 RISICO. Gerepareerd: 7642
    150 goud (`turn = true`, na de doelen), Stardust-goud al bij 7623/7624, 7631 drie ritueel-items (`allItems`,
    `onlyMap 1428`), potion "6 gold for 3" + `onlyMap`, rank 3 telt, start-items weg, 2 level-25-boeken weg, "free" weg,
    de Forscherzugang / anders "de volgende quest". Offline opnieuw: 0 fouten, alle gevallen nagespeeld.
    Open: Scholomance-sleutel 7629/7647; Study staat bij elke mage 6+ bovenaan Do this now (keuze voor Rob).
  - Zelfde ronde: LINKS boot/zeppelin/skycutter = eigen DB2-stops (was gelijk aan Zygor LibRover, ARR), pijl "aangekomen"
    bij een halte binnen 25 yd; Thunder Bluff-zin onder de Mulgore-skycutter (FTRAVEL_NOTE_TB, 7 talen, namen gemeten).
  - TESTLIJST: Robs "1 is goed gekeurd" = sparring-punt 1 → Forever-punten van vandaag afgevinkt; plus Characters-totaal
    en Your path op Robs screenshots (sparring). Open: druid-vorm, leeg vakje, achternaam, Step aside, Set focus, Midnight.
  - Open: 94502 inleverplek (Norric vs Forgotten Shrine), aantal Shadowy Potions, Pick Lock 2478, of 1 boek genoeg is.
- 🧭 **Forever Find → Travel GEBOUWD** (Rob via sparring, letterlijk: *"Maar ik ben nu op zoek naar de zeppelins in
  ogrimar en heb geen idee hoe ik daar kom … net zoals flight masters.... kortom ... HELP !!!"* → *"ja"*). Onderzoek: één
  mh-research → `docs/forever/REIZEN_2026-11-18.md`.
  - `ForeverCitySpots.lua`: 65 vluchtmeesters als `kind = "flight"` (31 A / 30 H / 4 beide; kant GEMETEN in DB2 TaxiNodes,
    x,y Wowhead-spawns bij het DB2-punt). Light's Hope (2×) = DB2-punt, AFGELEID → TESTLIJST.
  - `ForeverTravel.lua`: `ns.ForeverTravelTransportSpots()` (elke halte van LINKS + `TRAVEL_EXTRA`, genoemd naar de
    bestemming); `TRAVEL_EXTRA` = X1 zeppelin Grom'gol↔Undercity, X2 Feathermoon-veerboot (planner ongewijzigd);
    `STOP_NOTE` = uitleg onder de Orgrimmar-torens (H1a/H2a) en de Undercity-toren (H1b/X1b). Varen ze echt: NIET gemeten.
  - `ForeverVendors.lua`: CATS transport + flight (`travel = true`); `ForeverOverview.lua`: derde kop "Travel" in Find,
    notitie als tweede regel, zoekwoorden zep/boat/ship/tram/portal/flight/fp/taxi/gryphon/wind rider…
  - `ForeverStyle.lua`: "scroll for more" in een eigen strook van 14 px onder de lijst (lijst stopt erboven zolang hij
    kan scrollen). Rob zag de woorden over de laatste regel/knop liggen.
  - Vertaald de/fr/es/pt/ru (ForeverClassQuests_*), namen GEMETEN (GlobalStrings MINIMAP_TRACKING_FLIGHTMASTER, AreaTable);
    zinnen eigen vertaling. Knopnaam in de uitleg = de echte knop (FOV_GO) per taal; nlNL "Wijs de weg".
  - Offline (search_check): 109.123 runs, 0 fouten; Horde 12 haltes / 34 FM's, Alliance 21 / 35; 4 haltes met uitleg;
    strook-test 24/10/24 px. Geen nieuw bestand → `/reload`. NIET in het spel gezien.
  - ⚠️ Open: de bestaande LINKS-coördinaten zijn gelijk aan Zygor LibRover (ARR) — eigen DB2-waarden staan klaar in de
    scratchpad-data; kadercheck voor andere Wowhead-punten in Stormwind/Redridge/EPL; Thunder Bluff-zin ("geen zeppelin,
    vlieg naar Org") nog niet in MH. Rob: *"1 is goed gekeurd"* — welke punten precies, gevraagd aan sparring.
- 🗂️ Briefje gesplitst (regie: 1743 regels, grens 1500): alles vanaf "▶ Open voor 14 nov" (776 regels, 39 secties) staat
  nu bovenaan `NEXT_SESSION_ARCHIVE.md`; hier blijven 966 regels + index. Proefrun eerst, daarna `--resplit … --write`.
- ✅ API-wachter `[MOET GEFIKST]` GEREPAREERD (Rob via sparring, letterlijk: *"ja dat mag ie"*): `ForeverChars.lua`
  plakt naam + achternaam nu met `Constants.CharacterNameSeparatorConsts.CHARACTERNAME_SURNAME_SEPARATOR` (spatie als
  terugval), zoals `EditModeBackup.lua:848`. `rec.name` wordt alleen getoond (r. 444/517), nergens vergeleken (GEMETEN).
  luac OK; niet offline gesimuleerd, niet in het spel gezien (TESTLIJST). Welk teken de client geeft: NIET gemeten.
- ⏳ Midnight in stijl A: gemeten + plan (3 opties, advies optie 1 met schakelaar standaard uit) bij sparring; nog GEEN
  bouw-ja. Gemeten: ForeverStyle.lua stopt in Midnight op r. 29 (`if not ns.IS_FOREVER`); UI.lua 5315 regels, 4 kamers,
  24 tabbladen, perkament-backdrop (r. 2946); 115 bestanden met Blizzard-sjablonen. Er is al een schil-kleurtabel
  `LOOK_PALETTE` (UI.lua r. 220) + schakelaar Classic/nieuw → stijl A kan een derde keuze worden.
- 🖼️ Proefplaatje (Rob via sparring, letterlijk: *"doe maar, ik zit nog zeker 4 uur achter mijn pc dus daar kan ik het
  goed zien"*): `docs/ontwerp/midnight_stijl_A_2026-11-18.html` + `.png`. Links Robs echte screenshot (mh-shots/
  02-this-week.png, 6 okt, v4.7.3), rechts dezelfde inhoud in stijl A (kleuren/fonts/knoppen GEMETEN uit ForeverStyle;
  icoontjes, schildje en maten nagetekend/geschat — staat op de pagina). Niets in de addon veranderd. PNG gemaakt met
  headless Edge (Python-playwright staat niet op de pc).
- ⏸️ **Midnight in stijl A GEPAUZEERD tot na za 21 nov 10:00** (Rob via sparring, letterlijk: *"… we pauzeren dit tot na
  de Claude Code reset 🙂 , wat ik juist mooi vond van onze forever versie is de eerste blik die je ziet als je MH
  opent :)"*). Kern = de eerste blik bij openen (overzicht als voordeur), niet per se de jas. Staat in IDEEEN.md (Open,
  bovenaan). Niets gebouwd.
- 🔎 Forever-zoekbalk + valuta/reputaties: ONDERZOCHT, niets gebouwd (Rob via sparring: *"laat hem nog niets bouwen maar
  met een voorstel komen"*). Rapport `docs/forever/ZOEKBALK_EN_VALUTA_2026-11-18.md` (deel A eigen meting, deel B één
  mh-research Opus). Voorstel naar sparring; IDEEEN.md bovenaan. ⚠️ Een helper schrijft zijn probe-job in DEZELFDE
  scratchpad als deze chat (zelfde sessie-id) → tijdens een helperrun zelf geen `_probe.py` draaien.
- 🔍 **Forever-zoekbalk STAP 1 GEBOUWD** (Rob via sparring, letterlijk: *"we beginnen nu en ik volg jullie advies"*):
  zoekvak in de titelrij van het overzicht (`ForeverOverview.lua` Build, `f.search`), lijst `ns.ForeverSearchIndex`
  (tabs/pagina's, alle Find-items, class quests, dungeons, macro's, stille helpers, tools, /mh-commando's; 220-232
  regels per character, cache 15 s). `NavSearch.lua`: Forever-tak vooraan in BuildNavIndex (fout → één chatregel +
  `ns._foreverSearchErr`), één lijst per zoekvak (`ns.NavSearchAttach`, `_mhNavParent/_mhNavName/_mhNoMatchKey/
  _mhNavOnCreate`), `ns.NavSearchEnter`. Vertaald de/fr/es/esMX/pt/ru (woorden van de packs zelf). Offline
  (scratch search_check: 9 classes × 2 kanten × 2 levels, elke regel aangeklikt + 40 zoekwoorden + Enter): 19.235 runs,
  0 fouten (eerste run vond een crash op `goods = true`, gerepareerd). Dungeon- en wapennamen komen van de client:
  in de test nep → "deadmines"/"sword" offline niet te testen. NIET in het spel gezien; Midnight-balk ook nakijken.
- 🧭 **Zoekbalk STAP 2 GEBOUWD**: elke plek van elk Find-item (FindPlaces) als eigen regel (cat `place`, laag
  content), klik = Find op dat item + `go()` (pijl); rang uit FindPlaces gaat mee als `order` (nieuw 7e veld van
  NavSearch `add`, tie-break vóór het alfabet; Midnight-regels hebben geen order) → dichtstbijzijnde eerst. Plus een
  "Show the way"-regel per class quest (zelfde regel als FillClassQuestPage) en per dungeon (niet bij `sideLocked`, zoals
  FillDungeonsPage). Nu 857-964 regels per character. Offline: 68.343 runs, 0 fouten, 32.712 kliks; lijst bouwen max
  0,032 s, toetsaanslag (typfout-ronde, warme cache) max 0,036 s.
- ✅ **Robs test 18 nov** (via sparring, letterlijk: *"1 tot en met 4 gaat goed, 5 gedaan. Wat ik wel niet kon is zoeken
  op AH … 6 komt later"*): zoekbalk stap 1+2 OK in Forever; Midnight-check open. 🔤 **AH-fix**: `CITY_WORDS` in
  ForeverOverview.lua (auction "ah auction auctioneer auctionhouse", bank, mail, inn/hearth) — zelfde woorden als
  Midnight's `SMC_WORDS` (NavSearch.lua r. 670: Midnight kent "ah" al, GEMETEN in de code, niet offline getest). Geen
  "fp": Forever heeft geen vluchtmeesters in de lijst. Offline: "ah"/"AH" → Auction House + veilingmeesters
  (controle "bank" ok), 68.343 runs, 0 fouten. Niet in het spel gezien.
- 📏 **Uitslag `/mh repprobe`** (Rob, Forever, Horde-character; SV 18 nov, GEMETEN): werkt: `C_CurrencyInfo.
  GetCurrencyInfo` (alle 7 id's met naam), `C_Reputation.GetFactionDataByID` (26 van 35 leesbaar), `GetNumFactions`/
  `GetFactionDataByIndex` (5 rijen = wat dit character kent), `C_Item.GetItemCount`, `C_MajorFactions` (2800 = 0),
  alle 5 events geldig. Ontbreekt: de oude `GetFactionInfoByID`, `GetNumFactions`, `GetFactionInfo`, `GetItemCount`.
  Munten allemaal 0; max Honor 25000, Real 165 (de client zegt 165, niet de 250 van de tooltip), Rank Points max 0,
  "Renown - PvP Rank" max 7 (niet 14). Onleesbaar (nil): 270/749/910 (raids niet in Forever), 890/2586/2740/2826
  (Alliance-facties op een Horde-character), 2800/2802 (verborgen). Alliance-facties die wél lezen staan op Hated
  (-42000). Rep-tokens in de tas: alle 0. Kaart: Rob kiest.
- 🪙 **Kaart "Reputation & currency" GEBOUWD** (Rob via sparring, letterlijk: *"1 eerst a daarna b / 2 Nu , voor de
  rares"* → eerst deze kaart, dan rares A, dan B). `ForeverLegacy.lua`: `REP_GROUPS` (24 groepen, bron per regel in
  commentaar; alleen de Seed Pod GEMETEN, de rest "(from guides)"), `ns.ForeverCurrencyViews`, `ns.ForeverRepViews`
  (eigen kant; onleesbaar = geteld en gezegd), `ns.ForeverRepWeekLines` (alleen "Honor bijna vol" ≥ 90%; Reals per
  dag NIET meetbaar → weggelaten), events UPDATE_FACTION/CURRENCY_DISPLAY_UPDATE → pagina ververst. Rangnamen uit de
  client (`FACTION_STANDING_LABELn`, Engels als terugval; NIET gemeten of Forever ze heeft). Overzicht: pagina `rep`
  in groep chars (4e knop), zoekbalk cat `rep`/`currency`. Offline 70.220 runs, 0 fouten (Horde + Alliance, alles
  onleesbaar, Honor 24000/25000). ⚠️ Teksten alleen en + nl: de/fr/es/pt/ru vallen terug op Engels → één vertaalronde
  (mh-writer) na rares A. NIET in het spel gezien.
- 🧹 **Lint [29] `and false or` TOEGEVOEGD** (Rob via sparring, letterlijk: *"ja"* op "een automatische controle die
  het voortaan zelf vindt vóór elke commit"): `check_and_false_or()` in tools/lint_addon.py, HARD. Doorzoekt *.lua in
  de root, `module_files()` (dus ook Modules/Travel/) en Addons/; strings en commentaar eruit. Ingebouwde controle
  (1 regel moet raken, commentaar en string niet; faalt die → 1 HARD). Positieve proef (scratch afo_check): tijdelijke
  map met Modules/Travel/Bad.lua → 1 treffer op de foute regel, 0 op commentaar/string/goede if; echte repo 0.
- 🧩 **Now-kaart + portret standaard uit** (Rob via sparring, letterlijk: *"Ja, zet hem standaard op uit. … En zoals je
  ziet staat hier tekst om elkaar heen. … Net onder de class quest."*): (1) `foreverPortrait3D` standaard UIT
  (DbFlag default false; SetPortrait leest `== true`). (2) De Now-lijst begon op een vaste 140 px (GEMETEN) → nieuw
  `sf.SetTop()` in S.Scroll; FillNow meet titel/uitleg/plek en zet de lijst eronder (`f.now.listTop`, min 110).
  (3) Titel en uitleg tot 3 regels, plek tot 2, vaste breedte, volle tekst in een tooltip (`f.now.mainHover`).
  (4) Portret: zoom/camera opnieuw in OnModelLoaded (scheef model; oorzaak AFGELEID). Offline: 360 Now-vullingen
  (9 classes × 2 kanten × levels 1-60, teksthoogte ~lengte), lijst 0× over de tekst, diepste start 193/252 px.
- 🔧 **Schakelaar-bug GEREPAREERD** (Rob via sparring, letterlijk: *"Het bewegende werkt keurig, maar de knop, Moving
  Portrait, werkt niet"*): `DbFlag` in ForeverOverview.lua zette bij standaard-aan `(not on) and false or nil` = altijd
  nil (GEMETEN in de code; ForeverRanks.lua:628 vond dezelfde valkuil 12 nov) → uitzetten werd nooit opgeslagen. Raakte
  ook Quest reward hint (`foreverQuestHint`) en Gear tip (`foreverGearTip`). Nu een gewone if. Offline: alle drie aan →
  uit → aan, portretvakje volgt. Standaardstand NIET veranderd (sparring vraagt Rob). ✅ Ronde 1 (Rob via sparring:
  *"ja"*): SettingsDefs.lua `arrowYieldForeverGuide` en `ahPresetQuantity` nu een gewone if; offline (echte
  GetSettingsDefs, Midnight + Forever) uit → aan → uit → aan klopt (109942e). ✅ Ronde 2 GEREPAREERD: Auras.lua
  HasUnitBuff einde-lijst = `break` (niet `false`: dan sloeg hij de Trusted()-controle over → in een gevecht zeker
  "afwezig"); nu beslist de bestaande eindcontrole (geheim id → nil, niet te vertrouwen → nil, anders false).
  ConsumableReadyCheck UnitHasBuffFromSet: gewone if. Gemeten effect (callers): MissingBuff:172 BUFF ALLY kwam nooit
  (nil = "heeft hem al") → kan nu verschijnen; GroupBuffs:151 telde nooit → nu "x van y"; ConsumableReadyCheck:745 en
  :190 "?" → nu rood kruis bij echt afwezig. Offline aura_check: 7 gevallen OK (gevonden / afwezig / leeg / geheim id
  / gevonden na geheim id / in gevecht / API weigert). Midnight-test in TESTLIJST. Oude tekst hieronder: Auras.lua:194 `(not sawSecret) and false or nil` (aura-facade geeft aan het eind van de
  lijst altijd nil = "onleesbaar" i.p.v. false = "afwezig"), ConsumableReadyCheck.lua:190 `anyReadable and false or nil`.
- 🎭 **Bewegend portret GEBOUWD, optie b** (Rob via sparring, letterlijk: *"is dit te animeren, ?"* → *"ja doe maar"*):
  PlayerModel "player" (portretzoom 1, idle-animatie -1) in een vierkant vakje 76 px met gouden rand en clip
  (`f.portraitBox/portraitModel`). Niet rond (optie a): een model negeert ronde maskers, alleen een rechthoekige clip
  houdt het binnen (MidnightToast.lua; AFGELEID, niet in Forever nagemeten). Terugval op het platte ronde plaatje:
  schakelaar uit (`foreverPortrait3D`, stille helpers "Moving portrait", standaard aan), geen SetUnit, of na 0,6 s
  GetModelFileID leeg. Reden in `ns.db.foreverPortraitProbe`. Opnieuw zetten bij UNIT_MODEL_CHANGED (player),
  PLAYER_EQUIPMENT_CHANGED, UPDATE_SHAPESHIFT_FORM en bij elke opening. Vertaald (6 packs, zelf). Offline 103.687 runs,
  0 fouten (aan / leeg / geladen / uit). /reload genoeg. NIET in het spel gezien.
- 🪙 **Altijd g/s/c + Now-regels vrij** (Rob via sparring, letterlijk: *"ja laat alle 3 zien"* en *"tekst gaat hier niet
  helemaal goed, de bovenste"*): `S.Money(c, plain)` in ForeverStyle.lua bouwt altijd goud, zilver en koper met de
  muntplaatjes `Interface\MoneyFrame\UI-*Icon` (bestaan in Forever: AFGELEID); gebruikt door ForeverOverview,
  ForeverChars, ForeverTrainer, ForeverDoNow en ForeverWeapons (hun oude terugval blijft eronder). Now-rijen: geen
  regellimiet meer (tekst én subregel wrappen, rij groeit mee). Offline 103.610 runs, 0 fouten. /reload genoeg.
- 🌍 **Vertaalronde GEDAAN** (één mh-writer, geen Fable): 78 sleutels (rep-kaart, rares, scroll-hint, "(N characters)")
  in de/fr/es/pt/ru (`ForeverClassQuests_<taal>.lua`, na FOV_SEARCH_CTX_TAB) + 30 esMX-regels; telling per pack GEMETEN
  (78 = enUS), luac OK. Spelnamen GEMETEN in Forever 70959 (ItemSparse, Wowhead item-tooltips, ItemSet 2132, AreaTable,
  CurrencyTypes, SkillLine, GlobalStrings incl. FACTION_STANDING_LABEL/MAP_LEGEND_RARE, npc 5828/5831/5842). Engels
  gebleven (geen id): Nightclaw Mantle, Artisan's Tier, questtitels "Hail the Dragonslayer"/"Brawl at the Maul",
  "Outrunners". ⚠️ Nalopen (Rob/sparring): (1) esES SpellName 17039 = "Maestro invocador" (Blizzard-data, esMX zegt
  "Maestro forjador de espadas") — gemeten waarde gebruikt; (2) esES "rare" = "Poco común" (MAP_LEGEND_RARE) terwijl
  esES.lua elders "raro(s)" zegt — clientwoord gebruikt; deDE "Seltene Gegner" vs RARES_TITLE "Rares"; (3) esES Dire
  Maul en The Maul heten allebei "La Masacre" → zin klinkt dubbel; (4) ptBR Friendly = "Respeitado" (gemeten); (5) ruRU
  "(персонажей: %d)". Door geen moedertaalspreker gezien.
- 🗺️ **Rares STAP B GEBOUWD**: nieuw gegenereerd bestand `Modules/ForeverRaresAll.lua` (beide toc's, vóór
  ForeverRares.lua → WoW herstarten). Generator = scratch `rares_build.py` (in de scratchpad van deze sessie, niet in de
  repo): welke rares uit HandyNotes (alleen gelezen), alle waarden uit Wowhead-tooltips, alleen als Wowhead-punt en
  HandyNotes-punt ≤ 3,0 overeenkomen → 399 regels, 14 weggelaten (lijst in docs/forever/RARES_2026-11-18.md). Find:
  per zone een item "Zone (lo-hi)" (42), `ForeverRareFindRows("z<map>")`; level nil → "level ??". Kant onbekend
  behalve voor de 24 van A. Zoekbalk ~1350-1450 regels per character, toetsaanslag max 0,06 s. Offline 103.610 runs,
  0 fouten. NIET in het spel gezien. ⏭️ Daarna: één vertaalronde (rep-kaart, rares, zoekbalk-extra's, scroll-hint).
- 🧽 **Goud + 6 schermfouten GEREPAREERD** (Rob via sparring, letterlijk: *"1 ja , 2 voor en 3 ja"* = goud nu, de
  schermfouten vóór rares B, namen op de site). (1) Goud: ForeverOverview.lua gebruikte de globale
  GetCoinTextureString (bestaat niet in Forever) → nieuw lokaal `Money()` (C_CurrencyInfo eerst, terugval "3g 14s
  14c"); "Gold: 314" en "Costs 10" waren koper. (2) Totaal 96s82c was JUIST: 14 bewaarde characters (GEMETEN in Robs
  SV, samen 9682 koper), 5 in beeld; het totaal zegt nu "(N characters)" (`FCHARS_TOTAL_COUNT_FMT`). (3) Now-knoppen
  86/58 px + label stopt vóór Details; Now-lijstknop 70→92 px; Your path-naam 2 regels; S.Scroll: fade 24 px +
  "scroll for more" (`FOV_SCROLL_MORE`) zolang er meer is, + UpdateThumb een frame later; na RefreshFonts één
  ForeverOverviewFill(true) zodat rijhoogtes met de echte letters gemeten worden (Set focus-rij; oorzaak AFGELEID).
  Offline 71.922 runs, 0 fouten. NIET in het spel gezien.
- 🐉 **Rares STAP A GEBOUWD**: nieuw bestand `Modules/ForeverRares.lua` (beide toc's, na ForeverCitySpots → Rob moet
  WoW herstarten): `FOREVER_RARES_WORTH` = 24 rares (coords = HandyNotes WoW Forever hoofdpunt, alleen gelezen; levels
  uit het rapport, 4 nagemeten in Wowhead-tooltips: 12/13/24/22 klopt), `kill` = wie hem kan aanvallen (Horde 23,
  Alliance 22). Find: kopje Rares → "Worth the trip"; FindPlaces kind `rare`, de waarom-zin staat op de plek van de
  route-regel (`e.why`). Zoekbalk cat `rare` (@rare), waarom-zin = zoekwoorden. Pijl: nieuwe eigenaar `rarespot` in
  NativeArrow.lua (rode rare-stijl, weg bij aankomst zoals `waypoint`; Midnight's `rare` ongemoeid). Geen kill-vinkje
  (Forever heeft er geen). Pexmit weggelaten (verkoopt of laat vallen: niet gemeten). NPC-namen Engels (andere talen
  NIET gemeten). Offline 71.919 runs, 0 fouten. NIET in het spel gezien. ⏭️ Stap B: alle 406 per zone.
- 🐉 **Forever-rares ONDERZOCHT, niets gebouwd** (Rob via sparring: *"en hebben we ook rares in forever ?"* → *"ja"* op
  uitzoeken). Rapport `docs/forever/RARES_2026-11-18.md`; IDEEEN.md bovenaan. 406 rares / 41 zones (HandyNotes WoW
  Forever v4 = ARR: lezen, niet kopiëren); DB2 heeft geen rares en maar 2 vignettes. Voorstel A (top ~20 in Find +
  zoeken + rode pijl) / B (alle 406, eigen lijst uit Wowhead) / C (HandyNotes tijdens het spelen lezen). Rob kiest.
- 📏 **B: meting valuta/reputaties GEBOUWD** (alleen meten, nog geen kaart): `/mh repprobe` (`ForeverLegacy.lua`
  `ns.ForeverRepProbeSlash`, route in Core.lua, unlisted in CommandList.lua) → `ns.db.foreverRepProbe`: welke
  functies bestaan, GetCurrencyInfo voor 1792/3468/3402/3469/515 (+3473/3485), GetFactionDataByID + oude
  GetFactionInfoByID voor 35 facties, de reputatielijst (max 120), C_Item.GetItemCount voor 14 rep-tokens, 5 events
  via C_EventUtils.IsEventValid. "missing"/"error"/"secret"/"nil" worden zo opgeslagen (nooit als 0). Offline: met
  en zonder functies, 0 fouten. Steamwheedle-id's 21/369/470/577 = classic, NIET in Forever gemeten (de meting doet dat).
  Wacht op Robs `/mh repprobe` + `/reload`; daarna kiest hij over de kaart.


## 📌 Ouder, maar nog niet af — staat in `docs/NEXT_SESSION_ARCHIVE.md`

De historie is afgesplitst (2 sep en 6 nov). Deze secties lezen daar nog als OPEN, dus ze
staan hier bij naam — een openstaand punt mag niet verdwijnen door oud te zijn.

⚠️ Bewust te ruim: de lijst kijkt alleen naar de kop. Is een punt af, zet een stukje van de
kop met de reden in `KNOWN_DONE` in `tools/split_handoff.py` en draai
`python "<repo>/tools/_probe.py" run split_handoff --reindex --write`. Niet met de hand
bewerken: dan loopt de lijst binnen een week uit de pas met het archief.

- ⏭️ VOLGENDE BOUWCHAT (Bouwchat 17-11 (3) draagt over; laatste commit 542715e, alles gepusht, geen release)
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
