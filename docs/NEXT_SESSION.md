# Midnight Helper — waar we staan

## ▶▶ 24 nov avond (Bouwchat 24-11): knop "Layout" in het toetsenblok (stap A1) — wacht op test

Rob via Sparring (letterlijk in IDEEEN). `KeyBlock.lua`: `f.styleBtn` (TOPRIGHT -150,-40, 300 px, onder New spells; de
bovenste rij zit vol, de intro maakt rechts 470 px vrij), `ns.KeyBlockCanUse12` (nu: Forever + keys12),
`ns.KeyBlockAskSwitchStyle` (StaticPopup MH_KEYBLOCK_SWITCH, teksten bij het tonen, twee teksten: geplaatst / niet
geplaatst) en `ns.KeyBlockSwitchStyle` (undo als het blok stond → KeyBlockSetStyle → Place als het stond; nooit in een
gevecht; weigert SetStyle, dan wordt er niets neergezet). Hooks van ForeverKeyExtras werken mee (Place = de extras-vraag,
naar oud = extras weg). Teksten 7 talen (KEYBLOCK_STYLE_BTN_FMT, KEYBLOCK_SWITCH_*). Offline: scratch `switch_test.lua`
16/16. Midnight: knop verborgen tot stap A2 (12 × 4 voor Midnight). Daarna B (Thorns-knop), dan A2.

📌 Na 5.9.0 (site-chat, bijvangst): nlNL noemde het venster in 4 regels "Do this now" i.p.v. de nl-titel "Doe dit nu"
(SET_FOREVER_WEAR_TITLE/_DESC, FTALENT_SW/_DESC) → nu "Doe dit nu". GEMETEN: daarna 0 keer "Do this now" in nlNL.lua.
Gaat mee in de volgende release.

## ▶▶ 24 nov avond (Bouwchat 24-11): RELEASE 5.9.0 getagd (Rob via Sparring, letterlijk: "release 5.9.0")

Geen beta. Versie 5.9.0 in beide toc's; CHANGELOG_590_1 t/m _8 (enUS) + Changelog.lua; `RELEASE_NOTES.md` byte-gelijk aan
`docs/CURSEFORGE_5.9.0.md` (5476 bytes, LF, GEMETEN met een scratch-vergelijking); CHANGELOG.md; SITE_SEIN: de regels
van 23-24 nov op "getagd" + een release-regel. Alleen Forever in de spelerstekst; de Midnight-voorbereiding op 12.1.7
werkt pas op een 12.1.7-client en staat er dus niet in (Sparring: alleen noemen als spelers er nu iets aan hebben).
✅ Tag v5.9.0 op 1bdc468. Release-run 45451928608 geslaagd (Retail, Forever, verify). GEMETEN in de CF-API (24 nov 17:53
UTC): v5.9.0 (id 9795543, 12.0.7-12.1.7) en v5.9.0-forever (id 9795583, 1.60.1), allebei Release, status 4; de
GitHub-release heeft beide zips. Wago NIET apart nagemeten (de run meldt Retail en Forever geslaagd). SITE_SEIN op
"staat op CurseForge".
✅ `CURSEFORGE_DESCRIPTION.md` bijgewerkt (Forever: 12 × 4 + Why these keys? + 5/Shift-Space, groepscheck, QuestieDB,
Do this now: upgrades, tasplekken, How you play-knop; How you play noemt je toetsen; credit-regel QuestieDB).
🔴 Nog open: Rob plakt de beschrijving op de CF-projectpagina (de packager doet dat niet), en kijkt of de changelog op
CurseForge netjes rendert (Files → het bestand → Changelog).

## ▶▶ 24 nov avond (Bouwchat 24-11): Lua-fout KeyBlock.lua:1527 (Druid, na harde uitval) GEREPAREERD — wacht op test

Rob, Forever Druid, bij inloggen na een onverwachte herstart (de kat zette de pc uit): `KeyBlock.lua:1527: bad argument
#1 to 'tostring' (value expected)`, via 1812 (de nieuwe-spell-vraag) → MissingRows. Oorzaak GEMETEN in de locals: slot
145 (SHIFT-Z, bar B) = ("macro", 0), en `GetActionText` gaf GEEN waarde terug (geen nil: tostring() zonder argument
gooit "value expected"). De knop wil "MH SHIFT-Z" (offline, Druid 12×4); GEMETEN: die macro staat NIET in
`_forever_/WTF/.../93/Ima-Druiddude/macros-cache.txt` (17:18) noch in `.old` (17:00), wel de andere MH-macro's (MH 1, 2, C,
F, SHIFT-E, SHIFT-X). AFGELEID: die macro werd die sessie gemaakt en ging verloren bij de uitval (macro's worden pas bij
uitloggen weggeschreven); de knop wees daarna naar niets. Fix: `pcall(GetActionText)` + alleen een echte naam telt, en
een macro-knop met id 0 zonder naam telt als LEEG, zodat de nieuwe-spell-vraag/Update de goede macro terugzet
(PlaceAction wisselt de kapotte eraf). Een macro met naam maar id 0 (bv. FishFry) blijft "bezet". GEMETEN ook: dit is
de enige plek waar GetActionText in tostring() ging (de andere 8 vergelijken of geven door). Locals ook: macro's melden
in Forever de spell-id van #showtooltip als id ("macro:5185" = Healing Touch). OVERFLOW = de lijst van het oude blok, ook
bij 12×4: sleutels die 12×4 niet heeft (F3, SHIFT-F1) worden overgeslagen (byKey nil), de rest bestaat in beide; maar
MissingRows filtert de CTRL-vormtoetsen niet zoals PlacePlan (hasForms) → kan bij een Druid zonder vorm een nieuwe
spell op Ctrl-1..3 voorstellen. → ✅ DAARNA OOK GEREPAREERD (Sparring: *"neem het mee nu, vóór de release"*):
MissingRows slaat nu dezelfde toetsen over als het neerzetten (hasForms uit res.occ, zoals de tweede trinket) én, in
Forever, elke toets die de class-tabel (ClassTable().keys, huidige indeling) voor iets bedoelt; zo blijft de toets van een
onbekende vorm leeg en niet fout. Gevolg in Forever: staat de eigen toets van een nieuwe spell vol met iets van de
speler, dan wacht de spell (geen plek) in plaats van op een andere vaste toets te landen. Offline: scratch
`orphan_test.lua` 12/12, met tegencontrole (zonder de fix landt hij op CTRL-1).

## ▶▶ 24 nov avond (Bouwchat 24-11): groepsbord — titel onder het sluitkruisje GEREPAREERD — wacht op test

Rob (nl, solo op zijn Druid): *"Het afsluitknopje loopt door de tekst heen."* Oorzaak: de breedte kwam alleen uit de
kolommen (min. 300 px), en de Forever-stijl zet een groter lettertype NA de eerste Render. Fix (`ForeverReadyBoard.lua`):
breedte ≥ titelbreedte + 54 px (gemeten met GetStringWidth); 0,25 s na het tonen nog eens meten en zo nodig opnieuw
Render (het bord hangt aan zijn midden, dus breder = alle cellen schuiven; Render zet de klikknoppen opnieuw).
Langste titel per tekens: de "Gruppencheck: Buffs und Verbrauchsgüter" (39); de meting dekt elke taal. Offline 44
controles (scratch readyboard_test.lua; de stub-HookScript verving het oude script, nu rijgt hij zoals het spel).
Punt 2/3 van Sparring vervielen (Rob zat op de Druid; *"bij die andere had ik inderdaad ook nog geen Hearthstone
geleerd"*). Regel healthstone-kolom: alleen met een Warlock in de groep (jij telt mee). GEMETEN in Syndicator-SV: de
Minor Healing Potion (118, 2 stuks) zat in de tas van een Mage, niet van de Warlocks.

## ▶▶ 24 nov avond (Bouwchat 24-11): 12 × 4 extra toetsen (5 = interact, Shift+Spatie = mount) — wacht op test

📌 Fix daarna (Rob: *"het is nederlands (dat klopt) met engelse set them en no thanks eronder"*): de knoppen van een
StaticPopup die bij het LADEN met `ns:L` gevuld worden, zijn Engels, want het gekozen pack (nlNL is handmatig) is dan nog
niet actief. GEMETEN met grep op `button1 = ns:L(` (alle vensters): de vaste vorm is "teksten bij het tonen zetten"
(FirstRun, Survey, MaxLevelWelcome, KEYBLOCK_NEW). Afwijkend waren MH_KEYEXTRA_ASK en MH_KEYBLOCK_LAYOUT_MISMATCH
(beide vandaag) → nu bij het tonen. Ook MH_FOREVER_MYLAYOUT_RELOAD (7 nov) had vaste Engelse tekst + knoppen → nieuwe key
FMYLAYOUT_RELOAD_TEXT (7 talen) + bestaande KEYBLOCK_BTN_RELOAD/KEYBLOCK_NEW_LATER. Ter info: Shift-Spatie stond bij Rob
op Toggle Score Screen; de vraag liet dat zien. Test: 28 controles (ook: knoppen volgen een taal die na het laden komt).

Rob via Sparring: *"En shift spatie is op zich wel een goed idee voor de mount. En de interact toets, nou, doe maar een
voorstel."* → voorstel → *"Ja, ik volg advies dus A. Je trekt op 5 en dat punt blijft ook werken."*
GEMETEN vooraf: `INTERACTTARGET` bestaat in Forever (GlobalStrings 1.60.1.71091; ook INTERACTMOUSEOVER); Robs
`_forever_/WTF/Account/JOEYWHATEVER/bindings-cache.wtf`: `NUMPADDECIMAL INTERACTTARGET`, `5 NONE`, `` ` TOGGLECHARACTER0``
(niet door MH gezet: 0 treffers, tegencontrole 7); Spatie/Shift+Spatie niet in het bestand = spelstandaard (niet leesbaar
uit dat bestand; de module vraagt het live met GetBindingAction).
Gebouwd: `Modules/ForeverKeyExtras.lua` (nieuw, beide toc's): één vraag (StaticPopup na het neerzetten van 12 × 4 of
bij inloggen, met wat 5 en Shift+Spatie nu doen), `/mh block extras [on|off]` + diagnose. 5 = INTERACTTARGET als extra
toets; Shift+Spatie = `MACRO MH Mount`, een macro PER CHARACTER (`/dismount [mounted]` + `/cast [nomounted] <mount>`),
alleen als het character een mount kent (anders blijft Shift+Spatie staan tot SPELLS_CHANGED er een brengt). Undo zet
per toets terug wat er stond (`ns.db.keyExtras.prev`) en wist de macro; terug naar het oude blok = automatisch undo
(hook op KeyBlockSetStyle); na een blok-undo pakt 5 interact terug (de undo gaf 5 aan de oude blokknop).
Snelste mount: `Modules/ForeverMountData.lua` (GEGENEREERD uit Mount → MountTypeXCapability → MountCapability, 140
mounts; 4 AQ-tanks eruit, alleen in AQ40): snelheid 2/1 + nodige spell (racial riding). NIET gemeten: of Forever die
racial riding als bekende spell toont → valt terug op "negeer de eis" als je wel een mount kent maar er geen door de
check komt; of C_MountJournal bestaat (bewaakt; favoriet telt mee als het er is); of een binding `MACRO <naam>` een
per-character macro vindt (AFGELEID: binding op naam). Uitlegblad: deel EXTRA (KEYGUIDE_HEAD/BAR_EXTRA). Teksten 7 talen.
Offline: 26 controles (scratch `keyextras_test.lua`). Ook afgevinkt deze ronde: Fix it now (Druid), tas-getal + kleuren,
How you play-knop; groepsbord → later testen op hoger level; Warrior toets 3 + Priest-gids geaccepteerd (niet apart getest).

## ▶▶ 24 nov avond (Bouwchat 24-11): "Do this now" — knop How you play + vrije tasplekken — ✅ GETEST (Rob: *"Ja, beide zijn helemaal goed."*)

Rob via Sparring, letterlijk: *"kunnen we hier onder ook een knop how to play toevoegen en in het rijtje van gold aan de
linkerzijde het aantal open tas plaatsen :)"*, op de samenvatting *"ja"*. Gebouwd in `ForeverDoNow.lua`: `f.btnPlay`
(tekst `FOV_TAB_PLAY`, opent `ns.ShowPlayCardWindow`) als laatste knop in de rij; `BagText` links van `f.money`, ververst
op `BAG_UPDATE_DELAYED` (zelfde event-frame als PLAYER_MONEY). Telling = `ns.ForeverFreeBagSlots` (de FreeSlots van
`ForeverWarnings.lua`, bag family 0); oranje bij ≤ max(5, `ns.ForeverBagWarnAt()`), rood bij 0; niet leesbaar = leeg.
Nieuwe key `FDONOW_BAGS_FREE_FMT` (en, nl, de, fr, es, pt, ru). Offline: telling 15 bij 4 gewone tassen + een pijlkoker.

## ▶▶ 24 nov avond (Bouwchat 24-11): How you play volgt de gekozen indeling — ✅ GETEST (Rob: *"en in how to play staat get nu goed"*)

Rob, letterlijk: *"ik zie een fout in how to play , de oude keyblock staan er nog in"* (open punt 1 van vanochtend; trainer:
*"trainer gaat goed"*). Gebouwd (`ForeverHowToPlay.lua` `LiveKeys`/`KeyMap`): bij 12 × 4 worden bij het TONEN alle
blok-toetsen in de teksten (8 talen ongewijzigd) vervangen: oude toets → zijn spells in `keys` → waar die in `keys12`
staan (terugval nu = die toets; geen plek = "blok D" in de taal van de tekst); T/Shift-T/G → Ctrl-Z/Ctrl-C/Ctrl-V.
Vormen die gelezen worden: `**K**` overal, `(K)` en `(K, …)` alleen in "Simple order" (elders is "(4)" een level),
"<op> K" met het voorzetsel per taal (een kaal cijfer alleen voor een leesteken/haakje). Oud blok = tekst onveranderd.
Venster + overzichtspagina (ForeverHowToSections). Andere schermen: GEMETEN 0 vaste blok-toetsen in de schermteksten
(tegencontrole 116 in HowToPlay). Offline: 151 controles (scratch `howto_keys_test.lua`).

## ▶▶ 24 nov avond (Bouwchat 24-11): trainerpijl naar Mirket i.p.v. Dhugru GEREPAREERD — ✅ GETEST (Rob: *"trainer gaat goed"*)

Rob (Horde Warlock, Razor Hill), letterlijk: *"Ik sta op dit moment bij mijn warlock trainer, maar hij stuurt me een heel
andere kant op."* en *"ja die naam staat er"* (Dhugru Gorelust). Oorzaak GEMETEN in zijn SV: `foreverTrainerCap[3172] =
{ cap = 6, seen = 6 }`; ook Kardris 14/14, Narm 12/12, Sian'tsu 16/16, Nartok 4/4: de trainerlijst toonde alleen spells
tot zijn eigen level, dus "hoogste level in de lijst" = zijn level, geen trainer-cap. Reparatie (`ForeverTrainer.lua`
TrainerCap): een gemeten cap telt alleen als hij lager is dan het level waarop hij gemeten is (Mai'ah 6 op 10 = echt),
en nooit lager dan de vaste cap uit ForeverTrainerSpots (Lanka 1 op 2). `/mh trainer check` noemt nu welke trainers
overgeslagen zijn, met cap en bron. Offline 10 gevallen (scratch `trainercap_test.lua`, Robs eigen SV-waarden).
Open: waarom Un'Thuwa wél 60 gaf op level 10 (de lijst toonde toen hogere spells) is niet uitgezocht; de regel is er veilig voor.

## ▶▶ 24 nov avond (Bouwchat 24-11): terugval zonder dubbele + "Later"-geheugen — wacht op test

Rob (via Sparring 24-11), letterlijk: *"Waarom krijg ik deze, terwijl die ook al op 3 gezet wordt? En als ik hem daar
weghaal, even later krijg ik weer terug dat hij weer daarheen moet. Beetje verwarrend."* Gebouwd:
- `ForeverBlock.lua` `FallbackHeld`/`FirstFor`: een spell die een toets als terugval houdt (latere naam in de lijst)
  komt niet ook op zijn eigen toets; is de eerste naam geleerd, dan schuift hij terug. Geldt alleen voor de 4 terugvallen
  (GEMETEN: Warlock 3/Shift-2, Rogue 3/Shift-3, Paladin 4/Shift-4 en V/Shift-F); het oude blok heeft er geen.
- `KeyBlock.lua`: "Later" (OnCancel) onthoudt per character elk paar toets + spell (`ns.db.keyBlockDeclined`, macro's
  met de spellnaam, zodat een nieuwe rang niet opnieuw vraagt maar een nieuwe spell wel). Update wist dat geheugen.
- Offline: 16 gevallen (scratch `fallback_test.lua`), keys12 2252, stale/login 27. NIET in het spel.

## ▶▶ 24 nov avond (Bouwchat 24-11): uitlegblad "Why these keys?" (12 × 4) GEBOUWD — ✅ GETEST (Rob: *"JA ZIET ER GOED UIT"*; Shift+scroll/dichtklikken niet genoemd, open)

Rob via Sparring 24-11, letterlijk: *"kunnen we ook een soort blad even maken, waarbij we de users uitleggen waarom we welke
knop waar gezet hebben"* + *"… Dat gewoon voor iedereen weet dat een heal altijd op die knop staat …"*; heal-keuze *"a"*
(C = grote heal of grote defensive, Shift-C = snelle heal; niets verschoven). Eerlijk bij de toetsen die per class
verschillen ("vaste hulp-plek van je class": F, Shift-3/R/Z/X, Ctrl-4/Q/E). Gemeten per toets over 9 classes:
`docs/forever/KEYBLOCK12_TAKEN.md`. Gebouwd: `ns.ShowKeyBlockWhy` (KeyBlock.lua), venster `MidnightHelperKeyBlockWhy`
(in SCALABLE_WINDOWS), knop `f.whyBtn` bovenin het toetsenblok-venster (x 475; alleen Forever + 12×4), teksten
KEYGUIDE_* (en/nl zelf, de/fr/es/pt/ru mh-writer). Layout meet de hoogtes opnieuw na de Forever-stijl. Offline: venster
bouwt en klapt. Site-pagina: later via de site-chat (SITE_SEIN).

## ▶▶ 24 nov avond (Bouwchat 24-11): één indeling voor alle Forever-characters (Rob: *"advies a"*) — wacht op test

GEMETEN: Forever-toetsen gelden voor het hele account (één `bindings-cache.wtf`; `bindingSet = 1` in Robs SV; `style` ook
account-breed in MidnightHelperDB), de balken per character. Gebouwd (KeyBlock.lua): het neerzetten bewaart
`snap.layout`; bij het inloggen (Forever, 8 s, niet in gevecht, één keer) een chatregel + StaticPopup
`MH_KEYBLOCK_LAYOUT_MISMATCH` als dit character met de andere indeling staat ("Fix it now" = undo + neerzetten;
`/mh block fix` doet hetzelfde). `/mh block style` zegt erbij dat toetsen voor alle characters gelden. `/mh block why`
noemt "placed on this character". Oude snapshots zonder `layout` = het oude blok. Paladin V = Repentance, anders Turn
Undead (24); level 8-23 heeft hij geen andere CC (Hammer of Justice staat bewust op E). Offline getest (login-check:
4 gevallen, keys12 2252), NIET in het spel. Bevestigd uit de code (AFGELEID): na `/reload` zet "Update" of de
nieuwe-spell-vraag Immolate op toets 3 (lege plek met een macro-wens). Teststappen: TESTLIJST "24 nov (avond)".

## ▶▶ 24 nov (Bouwchat 24-11): 12 × 4 GEREPAREERD na Robs Warlock-test — wacht op hertest

Rob testte 12×4 op zijn Warlock (screenshots via Sparring 24-11). Fout 1: op balk 5/6/7 stonden nog de oude toetsen
(5, T, G, F1-F4, Shift-T, Shift-F1). Oorzaak (GEMETEN in de code, AFGELEID voor Robs account): neerzetten bindt alleen
de toetsen van de gekozen indeling; oude toetsen die nog naar een blokknop wijzen (account-bindingen van een eerder
neerzetten, misschien op een ander character, dus niet in de undo van de Warlock) bleven staan, en een knop toont zijn
eerste toets. Reparatie: `StaleBlockKeys()` in KeyBlock.lua; neerzetten maakt ze los en zet ze in de snapshot (undo
zet ze terug); `/mh block why` noemt ze (ook in de SV: `dump.staleKeys`). Offline: de 9 toetsen van de screenshots
gevonden, F2→kaart blijft.
Fout 2: Summon Imp 4× → pet-commando's tonen nu hun label + icoon (`spell.label/iconTex`, ook in de tooltip); de 4e
(Alt, block D) is bewust. Klein: "Summon Demon" (vermoedelijk een flyout, AFGELEID) telt niet meer als onbekend
(flyouts overgeslagen + naam in Warlock `listed`). Vraag 3 (Immolate op Shift-2, toets 3 leeg tot Agony op level 8):
voorgelegd aan Sparring, niets veranderd. Teststappen: TESTLIJST "24 nov (later)".
- 🔧 Vervolg (Sparring: *"ja, doe jouw advies … Kijk ook of hetzelfde gat … bij andere klassen voorkomt"*): terugval op
  rotatietoetsen waar de spell pas later bij de trainer komt: Warlock 3 = Agony, anders Immolate; Rogue 3 = Mutilate/
  Hemorrhage, anders Shank (24); Paladin 4 = Hammer of Wrath (44), anders Exorcism (20). Gemeten met scratch `gap_test.lua`
  (per level 1-60, alleen trainerlevels; begin-spells en talenten tellen daar als "niet geleerd", dus een deel van de
  overige meldingen is nep). Niet aangepast: Warrior 4 (4 levels, per stance), Shaman 4 (Fire Nova vraagt een fire totem,
  pas op 20), Druid 4 (4 levels, cat), en alle vaste-taaktoetsen (E R Z X C V). Te bekijken: Paladin V leeg 8-60 terwijl
  Purify op Shift-V staat (welke CC staat op V?).
- 📏 Bindingen GEMETEN: Forever heeft één `bindings-cache.wtf` op accountniveau, geen per character (25 character-mappen,
  tegencontrole: daar staan wel macros/config). Gevolg en advies: zie bericht aan Sparring; nog niets aan veranderd.

## ▶▶ 24 nov (Bouwchat 24-11): `data/keyblock_specs.json` opnieuw gemaakt — ✅ AF (open punt NEXT_SESSION_ARCHIVE r.7171)

Sparring 24-11, letterlijk: *"Ja: run keyblock_specs, commit en push"*. Het bestand was van 6 okt; 6 specs schoven door
bewuste datawijzigingen uit oktober (GEMETEN, vergeleken met de oude versie): Holy Paladin (Avenging Crusader F1, Divine
Toll Shift-3, Holy Prism Shift-F1; Redemption en Intercession nu zonder plek door de Rites van 22 okt), Prot Paladin,
Assassination, Shadow (Halo → Halo (Shadow)), Vengeance en Devourer (The Hunt niet meer in hun lijst). De indeling zelf
(`layout`) is ongewijzigd. Gebruikt door de site-spiekbrief (branch "keyblock"); Sparring seint de site-chat.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-toetsenblok "12 × 4" GEBOUWD (1a + 2b) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"ik vind namelijk zijn uitleg goed en wil onze versie ook zo hebben van keybinds qua
knoppen"* (Bellular-video) en *"uiteraard volg ik je advies e laat een agent uitzoeken welke spells logisch zijn per class
zodat dat automatisch kan worden toegepast"*. 1a = alleen Forever, 2b = schakelaar, oud blok standaard. VERVALT: Rob keurt
niet meer elke klasse-tabel goed; het onderzoek bepaalt, Rob test.
- 🧪 `KeyBlock.lua`: BLOCK_OLD + BLOCK_12, `BLOCK` wordt in place gevuld door `SyncLayout()` (in Build, Ensure, ArmBar1);
  het plaatje vindt knoppen nu op plek (`f.slotAt`), niet op toetsnaam. `/mh block style old|12x4` (`ns.KeyBlockSetStyle`;
  weigert als het blok geplaatst is, in gevecht, of zonder keys12 voor de class). `ns.db.keyBlock.style` (account-breed).
  `/mh block why` toont "layout: …" en per toets "12x4: <reden>".
- 12×4: A = 1-4 Q E R F Z X C V, B = Shift, C = Ctrl (1-4, Q, E, R + vaste items Ctrl-F bandage, Ctrl-Z health potion,
  Ctrl-X mana potion, Ctrl-C healthstone, Ctrl-V trinket), D = Alt (= block D, Alt-G i.p.v. Alt-Z; Sparring: *"akkoord"*).
  `FixedWant`: in Forever nu de gemeten lijsten (ForeverReadyBoardData hpot/mpot/hs/bandage) — geldt ook voor T/Shift-T
  van het OUDE blok (daar vond hij in Forever niets: retail-data).
- `ForeverBlock.lua`: ClassTable geeft in 12×4 een view met `keys12`; oude spells zonder 12×4-plek gaan VOOR toBlockD naar
  block D (tweede controle: anders vallen de armor-buffs eraf op 60). `why` telt niet als spellnaam.
- 9 tabellen `keys12` (onderzoek 3× mh-research, `docs/forever/KEYBLOCK12_<CLASS>.md`; tweede controle mh-research
  `KEYBLOCK12_REVIEW.md` → 3 wijzigingen doorgevoerd: Mage 4 = Fire Blast / Shift-3 = Pyroblast, Priest wand `bang`,
  Warlock 3 = Agony / Shift-2 = Immolate). Bandage-id's: `docs/forever/BANDAGES_FOREVER_2026-11-24.md` (12 algemeen;
  16 battleground-bandages bewust NIET).
- Offline 2248 controles goed (scratch `keys12_test.lua`: toetsen, namen, dubbelen, 255 tekens, niets kwijt), NIET in het spel.
- Open: How you play noemt nog de oude toetsen (5, F2, T/Shift-T/G; review r.33/153/176/311/381). Stap 2 (Sparring
  *"akkoord"*): mount Shift+Spatie, interact-toets, sit/sheathe/character na een vraag. Geen knop in het venster (geen
  ruimte bovenin): alleen het commando. Battle Shout-duur niet gemeten; Hammer of the Righteous: bron onbekend.

## ▶▶ 24 nov (Bouwchat 24-11): Forever-groepsbord GEBOUWD (optie A) — wacht op Robs test

Rob via Sparring 24-11, letterlijk: *"Ja maak maar"* en op *"Bedoel je doe jouw advies (A)?"*: *"ja"*.
- 🧪 `Modules/ForeverReadyBoard.lua` + `ForeverReadyBoardData.lua` (NIEUW, beide toc's; alleen actief in Forever = herstart).
  Neemt in Forever de namen `ns.ShowConsumableBoard` (`/mh readyboard`, `/mh board`, NavSearch, Launchpad) en
  `ns.PrintConsumableReadyCheck` (`/mh readycheck` = diagnose → `ns.db.foreverReadyProbe`) over; Midnight-bestanden
  staan niet in de Forever-toc, dus geen botsing (GEMETEN met grep). Nieuw: `/mh readyboard auto on|off` (Core.lua).
- Eigen kolommen: elixer/flask (75), eten (Well Fed + 5 andere namen; vissen/kruiden/snelheid tellen NIET), wapen
  (`ns.ForeverTempEnchant` + `ns.FOREVER_WEAPON_ITEMS`, nieuw export in ForeverBuffs.lua), hpot, mpot (mana-classes),
  hs (alleen met Warlock). Buffs: int (alleen mana-classes), fort, motw, bless (elke blessing telt; klik = laatst
  gecaste, anders de eerste die je kent). Een kolom alleen als die class in de groep zit.
- Andermans auras: één scan per speler; te ver weg / offline / geheime id / in gevecht = vraagteken, nooit rood.
  Gaat dicht bij PLAYER_REGEN_DISABLED. Klikknoppen op UIParent, met de hand geplaatst, sluiten mee (lessen
  ConsumableReadyBoard). Eigen Shift+scroll → `tools/window_check.py` EXEMPT (reden: knoppen moeten mee).
- Id's: mh-research, `docs/forever/CONSUMABLES_FOREVER_2026-11-24.md` (wowf 71037). NIET meetbaar: Battle/Guardian-
  elixers (niet in de clientdata → één kolom), welke healthstone de server maakt, of de SoD-potions bestaan.
- Offline 43/43 (scratch `readyboard_test.lua`), NIET in het spel. Vertalingen de/fr/es/pt/ru: mh-writer (niet
  nagekeken door een moedertaalspreker). GEMETEN (SpellName wowf 71037): Well Fed 1248406 = Satt / Bien nourri / Bien
  alimentado / Bem Alimentado / Сытость; flask (17626) = Fläschchen / Flacon / Frasco / Frasco / Склянка (ru was
  "настой", gerepareerd). Uit de packs, niet gemeten: Healthstone, Warlock, potions, ready check, "Paladin-blessing". Teststappen: TESTLIJST "24 nov — FOREVER: groepsbord".
- Niet gebouwd (optie B, later): andermans tassen via addon-berichten. Divine Spirit/Shadow Protection niet op het bord.

## ▶▶ 24 nov (Bouwchat 24-11): twee wachter-fixes na de Forever-hotfix van 23 nov + handoff gesplitst

Opdracht Sparring 24-11, letterlijk: *"ga door met de kleine dingen. (1) Splits NEXT_SESSION.md eerst. (2) Fix Forever
Warrior toets 3 … (3) Zet de Priest-gids recht … GEEN tag of release."* Grondslag Rob 13 nov *"ga voortaan door"*.
- 🔧 **Warrior toets 3** (API-wachter [MOET GEFIKST] 24 nov): `ForeverBlock.lua` `TALENT_GATED` — Mortal Strike telt voor
  een toets alleen als node 105941 (tree 1117) gekocht is; onleesbaar talent = oude spellbook-antwoord. Alleen de toetsen;
  `ns.ForeverKnownSpell` (trainer, Do this now …) ongewijzigd. `/mh block why` toont de beslissing; ververst nu ook op
  TRAIT_CONFIG_UPDATED (pcall). Offline 9/9 (scratch `warrior_gate_test.lua`), NIET in het spel. Rest (AFGELEID): een al
  geplaatste "MH 3" van een Warrior met alleen Mortal Strike blijft staan (nieuwe body = niets → geen herschrijving).
- 🔧 **Priest-gids Chastise** (content-wachter 24 nov): regel "Healing in Shadowform" zonder Chastise, in 8 talen
  (`ForeverHowToPlay.lua:315` + 7 locales). Fear Ward-helft blijft (niet in de hotfix; AFGELEID dat hij klopt).
- Teststappen: TESTLIJST "24 nov — FOREVER: twee kleine fixes". Party-consumablevenster: nog NIET, sparring legt het voor.

## ▶▶ VOLGENDE BOUWCHAT (21 nov, avond): nieuwe Forever-reeks "leren van Polestar/FlowUp" — punt 4 en 2 GEBOUWD, 1 = B, 3 rust

✅ **RONDE 1 GETEST (22 nov via sparring, letterlijk: *"ronde 1 klopt"*):** herstart zonder fout, bekende recepten op één
character, Bags full (niets wat hij wil houden, grijs + Destroy), gevecht zonder "action blocked". Voorwaardelijk, dus niet
zeker: Equip, vrij talentpunt, pet. Niet los getest: per soort, bijna vol + schakelaar, grijs zonder waarde, link, Equip in
gevecht, andere characters. **OPEN: ronde 2** (ingrediënten, recept-pijl, dungeon-quests, XP per uur). Midnight-inlog: GEDAAN.
5.8.0 staat op CurseForge (22 nov). CURSEFORGE_DESCRIPTION.md geplakt door Rob (via sparring: *"aan mijn kant alles
gedaan"*); de live pagina zag niemand van ons.
💡 Midnight, LATER (Rob 22 nov: *"alle 3 maar niet voor nu, straks slapen"*): patchdag-kaartje 12.1.7, "eerste blik",
december-events in de weekplanning. Alleen in IDEEEN; niets gebouwd. PTR-map heeft MH van 16 okt: niet kopiëren zonder Robs ja.
◐ **RONDE 2, 23 nov:** dungeon-quests: Rob via sparring, letterlijk *"een test : een dungeon-quest , werkt"* (welke quest:
nog niet bekend). Recept-pijl en Copper Ore (ingrediënt) blijven open; XP per uur niet gemeld.
▶▶ **MORGEN (24 nov) EERST:** Robs wens, letterlijk via sparring: *"voor morgen, een consumable venster voor de party in forever
zoals in midnight"* + *"en de buffs natuurlijk"* (wie mist welke class-buff, wie kan hem geven; vóór het gevecht).
Rob zegt JA, nog niets gebouwd. Wat bedoeld is, wat anders is in Forever en wat bruikbaar is: IDEEEN,
"Forever: consumable-venster voor de party". Eerst een kort plan via sparring (welke consumables/buffs, alleen vóór het gevecht).
Nog open van 23 nov: layer-meting 1 + 2, de teller in het spel zien, testen van weetjes A en de QuestieDB-inleverregel.
▶ **ROBS DRIE OPDRACHTEN 23 nov** (via Sparring 23-11, letterlijk: *"Ja, 1, 2 en 3, maar juist ook 3. … We moeten ook zelf
kunnen swappen."*):
- 1 Patch 12.1.7-kaartje (Midnight): GEBOUWD in `NewChoices.lua` (kaart `patch1217`, alleen op een 12.1.7-client, één keer;
  knop naar het Timewalking-schema in de Codex; badges = valuta 1166, GEMETEN). Feitencontrole door Fable loopt; vertalingen
  daarna. Test kan pas op de PTR of op patchdag.
- 2 Weetjes A GEBOUWD (rapport `docs/forever/POLESTAR_NAKIJK_2026-11-22.md`): R12 needs 78307, wachtzinnen R11/R14, getallen
  weg R10/M21/W3, commentaar M1/S6; 7 talen. `tools/fcq_check.lua` faalde sinds 5a37dde (CreateFrame bij laden): stub
  erbij, nu 989101 gevallen, 0 fouten. Wacht op test (TESTLIJST).
- 🧪 Teller in het class-questkaartje GEBOUWD (Rob: *"… met hoeveel ik op dat moment heb?"*): `ObjProgress` → kaartje,
  Do this now, overzicht. Offline getest (4/6 → tekst; 6/6 → "lever in"). NIET in het spel gezien (Rob: quest al af,
  *"we gaan er van uit dat het werkt"*): eerstvolgende class-quest met teller.
- Layer-meting 23 nov (SV 16:37, GEMETEN): alleen een /reload + /mh layer in Durotar (2 spelers, 9 NPC's, 0 getagd); geen
  zonewissel, geen verplaatsing, geen uitnodiging (Rob: *"Nee, ik ben niet uitgenodigd of naar andere legen gegaan."*).
  Meting 1 + 2 OPEN → melding "je bent verplaatst" NIET bouwen. Login-regel ontbrak in het log (oorzaak onbekend).
- 3 Layer: Rob koos A + D (*"Ik ga uiteraard weer voor jullie advies."*). Metingen teruggebracht tot 3 (verplaatsing-signaal,
  "uitnodiging van andere layer", drukte tellen); eerst een stille meter + /mh layer, meldingen pas na meting 1.
  🧪 GEBOUWD: `Modules/ForeverLayer.lua` (nieuw, beide toc's) → `ns.db.layerProbe` (log van 40: SHARD_TRANSFER*,
  PARTY_INVITE_REQUEST 6e waarde, UnitPhaseReason per groepslid, zonewissel; geen namen) + `/mh layer [clear]` (drukte:
  speler-naamplaatjes, getagde NPC's). Offline getest. Spelers zien niets. D = nu alleen een zin; knop als Rob een
  wissel-addon installeert.
- 🔧 Folio 12.1.7 KLAARGEZET (Fable-bijvangst, onder Robs ja op "idee patch"): op een 12.1.7-client 7 quests
  (OmniumFolioData `unlockQuests1217` = 99509, 99508; GEMETEN QuestLineXQuest 6307 PTR 71087), "klaar" bij het echte aantal
  (was hard 5), tellers `_1217` "/7 steps", OMNIUM_WK_OBJ_6. 96444 heet live "Off-World Magic" en op 12.1.7 "Otherworldly
  Magic" (Wowhead live/PTR GEMETEN): alleen CODEX_FOLIO_BODY_1217 aangepast (9 regels). Runen-rijen en 99508: patchdag.
- 🔧 Patchkaartje: Fable-controle verwerkt (niets fout; 6 formuleringen eerlijker); patchdag-punten in draaiboek §4.
  Vertalingen loopt (mh-writer). Fable meldde ook: CODEX_FOLIO_BODY_1217 "Off-World Magic" vs Wowhead "Otherworldly
  Magic" (96444), en OmniumFolioData `unlockQuests` kent alleen de 5 oude quests: nog niet bekeken.
- 3 Layer swap: ONDERZOEK GEDAAN → `docs/forever/LAYER_SWAP_ONDERZOEK_2026-11-23.md`; layernummer onleesbaar (GEMETEN ook in
  Robs RFC-SV van 23 nov). Opties A-D bij sparring, advies A + D. Niets gebouwd.
✅ **WEAR B GOEDGEKEURD** (Rob via sparring, letterlijk: *"ORB is goedgekeurd. Alles doet hij wat hij moet doen."*; een
goedkeuring voor het geheel). Wat er gebouwd is (Rob via sparring, letterlijk: *"Ja, doe maar OR-B. Maar dan moet je wel opvallen dat
hij erin staat. En als er meerdere zijn in je tas, dan moet het ook blijven staan."*): `Modules/ForeverWear.lua` (nieuw
bestand = herstart). Per upgrade een groene regel met ↑ bovenaan Do this now (onder de talentregel) met klikbare [Wear it] /
[Not this one] (|H-links in de tekst, geen nieuw venster); knop "Wear it" in het overzicht. Oordeel = ns.ForeverGearTipText
(nu met 5e return: het vak). EquipItemByName(link, vak), alleen buiten gevecht; BoE-vraag van het spel blijft.
Schakelaar "Show upgrades in Do this now" (aan). `/mh wear why|reset`. Alleen Forever (daar zit het oordeel en Do this
now). Offline getest (nep-tas, 8 gevallen goed). Rob koos A (via sparring, letterlijk: *"Opvallen A."*): een upgrade
opent het venster vanzelf (`WEAR_TODO = true`), nooit in gevecht. Mijn keuze bij het kruisje: dicht blijft dicht tot er
een NIEUWE upgrade in je tas komt (`closedWear`). Vertalingen de/fr/es/pt/ru door mh-writer (niet nagekeken door een
moedertaalspreker; let op: "Mejora/Melhoria/Amélioration" staat in FBAG_NONE ook voor iets anders).
◐ **QUEST B getest 1-3** (Rob: *"1 tot en met 3 is goed."*); 4 ❌ op SM_GY (Vorrel's Revenge bleef "no place"). GEMETEN in
de QuestieDB-toc: Vorrel (3981) staat er alleen als (-1,-1) = "in een instance"; van 10 gaten zijn er 6 zo, 3 hebben een
echte plek (allemaal Alliance of level 55+). 🔧 Zo'n quest gaat nu naar "inside the dungeon" met "(QuestieDB)"
(`ns.ForeverQuestieNpcInside`): hertest ✅ (Rob: *"ennuh, een reload was genoeg, zoals zo vaak :)"*). 5 ✅ (*"Stap 5 uit
en aan, die werkte."*), 6 ✅ (*"Stap 6, gevecht gedaan en geen errors gekregen."*) → **QUEST B HELEMAAL GETEST.**
🧪 **"Of"-paren één regel GEBOUWD** (Rob: *"En glowing, ja,"*): paar = zelfde titel + gever + voorganger; GEMETEN 2 paren
(WC The Glowing Shard 3366/6981, BRD A Taste of Flame 4022/4024). Bijvangst gerepareerd: `taken` keek alleen naar de titel
en verborg zo de latere stappen van een keten met één naam (RFC Hidden Enemies, DM Defias; AFGELEID uit de code, offline
getest). Glowing GETEST ✅ (screenshot WC). Keten-fix niet te testen op Robs character (RFC 9 van 10 af).
🔧 "In Nightmares" (Rob: *"En nightmares, ja,"*): een voorganger telt als gedaan als zijn "of"-variant gedaan is
(`PrevDone`, code, niet in de gegenereerde data). Offline getest; in het spel pas te zien na The Glowing Shard. Schakelaar staat onder "On-screen buttons".
💡 Voorgesteld, wacht op ja: "The Glowing Shard" staat 2× in WC (3366 + 6981, twee echte quests; GEMETEN Wowhead
Forever) → altijd één regel tonen.
🧪 **QUEST B GEBOUWD** (Rob via sparring, letterlijk: *"Ik volg jullie advies weer. En het voelde niet
trager bij het inloggen, dus dat scheelt."* → laadtijd afgevinkt). MH's eigen data wint altijd; QuestieDB vult alleen
gaten, nooit omrekenen, pcall, niet in gevecht. (1) "Ready to turn in … (QuestieDB)" + knop Turn in in Do this now en het
overzicht (tip, opent het venster niet zelf); (2) dungeon-quests: ~40 rijen met een gever zonder plek krijgen er een
(QuestieDB); (3) LivePlace class-quests: laatste stap, nu 0 gaten (268/268 plekken hebben x,y; GEMETEN met grep).
Schakelaar "Use QuestieDB if you have it" (`mh_foreverQuestieDb`), standaard aan. `/mh questiedb why`. Vertalingen
de/fr/es/pt/ru door mh-writer (niet nagekeken door een moedertaalspreker), esMX "calabozo"; itIT geen (Forever-client
Engels). THIRD_PARTY: "Uses QuestieDB if you have it installed". Offline getest (nep-LibQuestieDB): 1 fout gevonden en
gerepareerd (schakelaar uit werkte niet: `and false or`). Teststappen: TESTLIJST 23 nov "stap B".
✅ **QUEST A GEMETEN, goed** (Rob: *"klaar"*): 0 fouten, ~1 ms per 150 vragen, 7,7 MB, 218/218 trainerplekken binnen
0,11-0,49 kaartpunt; Robs gemeten plekken 0,04 en 0,17; `here` 0,21. QuestieDB-plekken zijn al Forever: Era→Forever-
omrekening NOOIT gebruiken (maakte Stormwind 14,77). Laadtijd niet gemeten. ▶ B wacht op Robs ja via sparring.
🧪 **QUEST A: METING GEBOUWD** (Rob via Sparring 23-11, letterlijk: *"Ik volg jullie advies."* = eerst A meten,
B pas na zijn meting; is A slecht: melden, niet door naar B). `Modules/ForeverQuestieDB.lua`, `/mh questiedb [here]` →
`ns.db.questieDbProbe` (alleen tellingen, ms, KB en afstanden; geen QuestieDB-data). Offline getest met een nep-
LibQuestieDB (5 gevallen goed), NIET in het spel. Teststappen: TESTLIJST 23 nov. ⏸️ Questie-regels in ForeverClassQuests
(r.243/362/1005/1070): **LATEN tot het GPL-besluit**, niets aanraken.
🔎 **QUEST A ONDERZOCHT** (Rob via Sparring 23-11, letterlijk: *"quest a"*): QuestieDB alleen live lezen,
niets meeleveren; GPLv3 = later mogelijk, eerst toestemming mede-auteur AndyMM22 (Rob: *"gpl is niet defenitief van
tafel :)"*). Voorstel A-D in `docs/forever/QUESTIEDB_LIVE_2026-11-23.md` (advies A dan B),
wacht op Robs keuze. Gevonden: ForeverClassQuests noemt al Questie-plekken (r.243) en Questie-volgorde (r.362).
🧪 **PTR GEDAAN 23 nov** (Rob via Sparring 23-11, letterlijk: *"ja kopieer maar"*, daarna *"Alle 5 tests gaat goed. Ik heb
geen tailbound character, dus daar kan ik niet zoveel mee."*): `copy_to_ptr.bat` → `_ptr_` en `_xptr_` toc 5.8.0 (GEMETEN; was
4.7.7). `_ptr_` = 12.1.7.71087, `_xptr_` = 12.1.5.70340 (ouder dan retail 70961). Draaiboek §3 punt 1-5 ✅ ("Simple Keybinds" stond er NIET, Rob: *"nee, stond er niet simple keybinds"*;
op patchdag opnieuw kijken), punt 6
(Talebound laadt MH niet) OPEN: geen Talebound-character. Vervolg: §4 op patchdag (2 dec).

🔧 **SKILL UP-VENSTER GEREPAREERD (22 nov via sparring, letterlijk: *"venster ja"*), getest: *"Venster is goed"* (klik en scroll open):** stijl A (dicht),
"MH doesn't know which trainer/vendor yet", knop noemt het beroep. Ronde 2 uit zijn screenshots: XP-regel, Linen Cloth,
Light Leather, recepten in Skill up gezien; pijl, persoon en dungeon-quests niet. ▶ Robs *"Doe maar vensters A"*: alle 11
andere GEBOUWD (`S.SkinPanel` in ForeverStyle.lua). BagFull, Crates, Durability, HowToPlay GOEDGEKEURD (Rob 22 nov: *"Dus de
vensters zijn goed. Dat kan je goedkeuren."*; details open in TESTLIJST, prijs in Bags full: grijze regel goed, langere regel = controlepunt, niet repareren). De andere 7
(Chars, Dungeons, Macros, ProfTrainers, Trainer, Vendors, Weapons) openen niet meer: reserve achter het overzicht.
📜 **BRONNENLIJST GEBOUWD** (Rob 22 nov via sparring, letterlijk: *"Bronnenlijst, ja."*): `THIRD_PARTY.txt` (gaat mee in de zips)
+ de MIT-zin in README; LICENSE, code en data ongewijzigd. Licentie van ons werk blijft MIT. ⏸️ Alleen gemeld, wacht op Robs keuzes
via sparring: LibDBIcon (tegenstrijdig), LibDataBroker (geen licentie), plekken gelijk aan HandyNotes: Midnight (All Rights
Reserved). Niets daarvan zelf weghalen of vervangen.
🗑️ **PLATYNATOR-PAGINA WEG, vóór 5.8.0** (Rob 22 nov via sparring, letterlijk: *"En ja, platy die mag weg."*): pagina, profiel,
link, plaatjes, tool en verwijzingen; releasetekst + in-game regel 9 erbij. Details! blijft. fac9074, GETEST: *"midnight goed tekst goed"* (Rob 22 nov).

🔎 **POLESTAR-WEETJES NAGEKEKEN, niets gewijzigd** (Rob 22 nov via sparring: *"Misschien is dat wel slim, ouderwetjes
nakijken."*): 55 feiten = 36 bevestigd, 3 tegengesproken (rogue-keten 2x, Cantation), 1 betwist, 15 zonder andere bron.
`docs/forever/POLESTAR_NAKIJK_2026-11-22.md`. Repareren wacht op Robs keuze via sparring; 5.8.0 blijft zoals het staat.
Licentie: niets wijzigen tot sparring zijn keuze stuurt.

🚦 **5.8.0 STAAT OP CURSEFORGE (gewone release, 899a225).** Rob 22 nov avond via sparring, letterlijk: *"crates zwijgen en go voor 5.8.0"*.
Daarmee vervalt *"We doen nog geen release"* voor 5.8.0. Weetjes, libraries en HandyNotes gingen niet mee.
Run + CurseForge-bestanden: zie SITE_SEIN.
Fable-ronde GEDAAN: 1 echte fout gerepareerd (Scholomance 5803 = alleen Alliance, Horde = 5804; `QUEST_FIX` in de generator)
+ 4 kleine tekstverbeteringen. Waylaid Crates + mage Study-tip: Rob koos zwijgen. NIET door Fable:
vensters, spel, vertalingen, de keuze van de gidsen.
 Midnight + releasetekst GOEDGEKEURD op fac9074 (Rob: *"midnight goed tekst goed"*; ingrediënt-tooltip niet los afgevinkt).
 3 Forever-tests GEDAAN (Rob: *"de drie testjes zie screens"*): Way (alleen de chatregel gezien, aankomen open), rest off/on,
 prijs bij grijs.
▶ **NU: KAART B (Rob 22 nov via sparring, letterlijk: *"b"*):** level 1-briefjes voor alle classes/rassen + elk class-queststapje
als opvallend kaartje (ForeverCQWindow). GEBOUWD, kaartje GOEDGEKEURD op een Tauren hunter (Rob 22 nov: *"kaartje goed,
hebben we dit voor meerdere classes ?"*; andere classes, latere quests en knoppen open in TESTLIJST): 56 combinaties, 0 zonder briefje (Skyborne op level 2);
pas na de quest ervoor, tot en met level 5 (AFGELEID), nooit vóór een spell-keten. `docs/forever/CLASS_NOTES_2026-11-22.md`.
✅ **PLEKKEN B (Rob 22 nov via sparring, letterlijk: *"Plekken b"*), GEBOUWD, wacht op test:** 59 uit HandyNotes: Class Trainers
overgenomen plekken in ForeverClassQuests nu van Zygor (mediaan 0,11, grootste 1,01 kaartpunt: Beram 3032); wie die addon heeft
krijgt zijn plek live (`LivePlace`; Robs meting > gezien > /mh trainer here > HandyNotes > lijst; niets opgeslagen).
✅ **KLADJES A (Rob 22 nov via sparring, letterlijk: *"kladjes ja"*), gedaan:** die cijfers uit 11 docs en 2 commentaarregels
(71 paren, 131 vindplaatsen → 0; code-waarden en git-geschiedenis ongemoeid). Daarna nog 5 regels in 3 van die docs (HUNTER r.240,
PALADIN r.271 + 411, PRIEST r.340 + 502) → 0. ⚠️ Dat die 5 onder "kladjes ja" vallen is **uitleg van sparring, geen tweede ja van
Rob**; sparring meldde het hem en hij kan het intrekken met "die 5 laten" (dan die 5 terug zoals in 79343f6).
Buiten die 11 docs niets aanpassen. Andere HandyNotes-addons zijn niet nagelopen.

▶ **ROBS KEUZES 22 nov, rond het ontbijt (via Sparring 22-11), letterlijk:** *"overnemen, ja"* (1. Zygor kijken of
overnemen; 2. mag het vrije deel van Polestar uitgezocht worden) · *"knop weg, en polestar heeft ook iets om je volle tassen
onderweg leger te maken, check dat ook, tijd voor koffie en ontbijt dus ga door szo lang je kan en ik terug ben"* ·
*"Ik ben nog niet terug maar kan wel via telefoon reageren 😇 tas 1 2 3"*. Werklijst, in deze volgorde:
- [x] 1. Talents-knop weg, regel noemt zijn eigen toets. ◐ Ronde 1: gevecht goed; vrij punt en pet onzeker.
- [x] 2. **ZYGOR = OVERNEMEN: id's, coördinaten, volgorde. Geen teksten, notities of code.** "Zygor b" en de pauze vervallen.
      ✅ Dungeon-quests terug (wacht op test, herstart nodig; nieuw: y=100.38 bij Dark Iron Legacy = geen pijl).
      ✅ Reagentia 87 → 172 (+78 valt van monsters, +7 Skinning, 17 verkopers; één bron blijft stil). Wacht op test.
- [x] 3. Tassen, eigen code (Polestar = GPL, alleen het idee): eerst nameten of eten, drinken, munitie, class-reagentia als
      weggooien kunnen verschijnen; dan reservetas, hulp bij bijna vol, grijs zonder verkoopwaarde. (4) markeren koos hij niet.
      ✅ a GEMETEN + GEBOUWD (wacht op test): ze konden alle vier verschijnen (286 soorten eten/drinken, 14 munitie, class-
      reagentia), nu nooit meer, ook niet via de Yes van Destroy. b reservetas GEBOUWD (wacht op test, klik + gevecht).
      c (bijna vol + schakelaar) en d (grijs zonder waarde) GEBOUWD.
      ▶ Beantwoord: Rob via sparring, letterlijk *"alles advies"* = bewaren B (recepten en leerboeken erbij), GEBOUWD,
      wacht op test: ook gif, drankjes, elixers, flasks, verband, scrolls, sleutels en tassen.
- [x] 4. Recepten (gebouwd = 8): Zygor mag als bron. Craft Ladder alleen nakijken als tweede bron, geen waarden: dat is de uitleg van
      sparring (regel 7 nov), GEEN woord van Rob; hij kan het intrekken. Pijl nooit naar zomaar een trainer.
- [x] 5. Polestar UITGEZOCHT, niets overgenomen: `docs/forever/POLESTAR_DATA_2026-11-22.md`. recorded.json kan los (CC BY
      4.0); geeft 549 recepten een tweede bron. Rob koos A (*"alles advies"*): bouwen = 8 en 9.
- ▶ **Robs *"alles advies"* (22 nov via sparring, letterlijk), in deze volgorde:**
      [x] 7. Tassen bewaren B. + *"dieren ja"* (22 nov via sparring, letterlijk): de 63 leer-dingen ook, wacht op test.
      [x] 8. Recepten GEBOUWD (1102 antwoorden, 206 pijlen: 90 meer dan voorgelegd, gemeld; herstart, wacht op test).
          🔴 Bij de release: Polestar-naam in RELEASE_NOTES, CF-beschrijving en site (tekst in SITE_SEIN). Was: Classic A (553 + 116 pijlen, zonder Zygors losse receptenlijst, geen Zygor-skillgetallen,
          "Classic-data, nog niet in Forever gezien") samen met Polestar A (alleen recorded.json, trusted, tweede bron of
          controle; naam, bron, licentie, bewerking in het databestand + zichtbare plek noteren voor de release).
      [x] 9. Ingrediënten 172 → 194 (GEBOUWD, wacht op test; zelfde naamsvermelding bij de release). Was: aanvullen uit recorded.json, zelfde regels. Komt een getal anders uit dan voorgelegd: melden.
- [x] 6. "Bekende recepten" GEREPAREERD (Rob via sparring, letterlijk: *"Recepten ja"*): kopie, eigen venster vervangt,
      beroepen die hij niet heeft weg, linked overslaan, leeg wist niets. ◐ Getest op één character (lijst 40 → 25, GEMETEN); de andere nog.
      De kopie-regel van 21 nov ("A") staat nog. Geen tag of release.

📜 **Recepten met Zygor onderzocht + gebouwd (22 nov):** `docs/forever/RECEPTEN_2026-11-22.md`. Rob koos A
(*"alles advies"*): gebouwd = punt 8 hierboven, samen met Polestar A.

🐞 **"action blocked" MultiBarBottomRight:SetPointBase (sessie 335): aanleiding weggehaald; gevecht in ronde 1 zonder fout (pet onzeker).** Rob: *"knop
weg"*. `docs/forever/TALENTKNOP_TAINT_2026-11-22.md`. 🔴 MH opent het talentvenster NOOIT meer zelf. In v5.7.0 zit de knop
nog (overzicht). Dat dit de oorzaak bij Rob was blijft AFGELEID: komt de fout terug, dan verder zoeken.

🗳️ **Robs woorden 22 nov, later (via sparring, letterlijk: *"smart buff goed\nBoot Rust\nmeting gedaan"* en, bij een
screenshot van Do this now, *"kunnen we de talent point meer laten opvallen"* → *"talent b"*):**
- **Talent B GEBOUWD, regel getest:** talentregel bovenaan in goud met ster + witregel. Alleen het venster Do this now.
  De knop die erbij kwam is weg, zie bovenaan.
- **Meting:** Cooking 132 recepten, GetRecipeSourceText leeg bij alle 132, 2 runs (GEMETEN in de SV). Niet op die API
  bouwen; per recept eigen data nodig. "window closed" bij een open venster: oorzaak GEMETEN = CharacterForever toont
  een eigen receptenvenster, ProfessionsFrame komt dan nooit in beeld (zijn recipeLog). ⚠️ De regel "in het
  beroepenvenster" moet dus ook zonder dat frame werken. De meting kijkt nu naar TRADE_SKILL_SHOW/CLOSE.
- **Smart Buff goed** (mage; Priest/Druid niet getest). **Boot = laten rusten**, niet opnieuw vragen.
- **Robs antwoorden, letterlijk: *"talent goed / plek ja / Zygor b"*.** Talent B getest (niet: in gevecht).
- **d, reagentia GEBOUWD, wacht op test (herstart nodig):** `ForeverReagentSource(Data).lua`, nu 194 items, regel
  in de tooltip + Skill up (daar de pijlknop). Wat één bron heeft zwijgt.
  Nog van d: recepten. c en e: niet meer nodig, zie bovenaan.
- **Plek:** tooltip = hoofdplek + MH's Skill up-venster; Blizzards beroepenvenster alleen als extra.
- ⏹️ **(VERVALLEN, zie bovenaan: Zygor = overnemen)** **ZYGOR B (vervangt "alleen feiten" van 21 nov): niets meer overnemen uit Zygor, geen id's, plekken, volgorde of
  namen; alleen ermee nakijken.** Volgorde: b) dungeon-quests van main → d) reagentia (87, AllTheThings met MIT-tekst) +
  recepten zonder Zygor → c) ALLEEN een lijst van ouder Zygor-werk, niets wijzigen zonder apart ja → e) dungeon-quests
  herbouwen of met aantallen melden. Optie D (meelezen) niet gekozen: niet bouwen.
  Voor c: ForeverRepairData, ForeverClassQuests, en `docs/forever/DUNGEONS_2026-11-14.md` (Zygor-quest-id's, publiek).

🗳️ **Robs keuzes 22 nov (via Sparring 22-11, letterlijk: *"1 b"* en *"reparatie A, briefjes laten"*):**
- **Punt 1 = B:** onbekende recepten "Waar haal je dit" (beroepenvenster + tooltip; trainer = pijl, verkoop na onderzoek
  per recept) + reagentia in de tooltip (Trade Supplies met pijl / verzamelberoep / monsters zonder plek). Weet MH het
  niet: zwijgen. Meting `/mh skillup source` → `ns.db.recipeSourceProbe`: gedaan, uitslag hierboven.
  Reagentia hangt niet van die meting af, de licentiekeuze is gemaakt (Zygor B, hierboven): Zygors toc zegt `X-License: GPL`
  (GEMETEN 22 nov). Onderzoek + keuze: `docs/forever/REAGENTIA_2026-11-22.md`. Die keuze raakt ook de dungeon-quests
  van 21 nov: vóór de volgende release beslist hebben.
- **/mh rest-reparatie = A:** mee met de volgende gewone release (geen 5.7.1, geen go voor een release).
- **Notion-briefjes 12 nov:** blijven staan, niet opnieuw vragen. De ideeën: maandag via sparring.

⛴️ **Punt 3 boot/zeppelin ONDERZOCHT (22 nov): nu niet eerlijk te meten, niets gebouwd.**
`docs/forever/BOOT_ZEPPELIN_2026-11-22.md`. Rondetijd is af te leiden; waar het schip NU is niet (geen API gevonden).
Misschien aftellen na één waargenomen aankomst: hangt aan een meting van 12 minuten in het spel (macro in dat bestand).
✅ Rob 22 nov via sparring: *"Boot Rust"* = laten rusten. Niets bouwen, niet opnieuw vragen.

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

✂️ **24 nov GESPLITST (Bouwchat 24-11, opdracht Sparring 24-11):** 1776 → 1304 regels + index; de zeven secties van 18 nov
staan nu bovenaan `NEXT_SESSION_ARCHIVE.md`. Hun koppen lezen niet als open, dus de open stukjes staan hier (GEMETEN met grep
vóór het knippen): `/mh disenchant` (/dump voor optie B open); optie A wapens (2 bewust open: Franse duizendtal-spatie,
> 1000 DPS); bazengids 2a/2b (Robs test; bazennamen in vertaalde tips nalopen, ~25 in fr/de/es/ru; stap 3 raids = 9 dec);
Bouwchat 18-11 (zoekbalk Midnight-check open; esES SpellName 17039 "Maestro invocador" nalopen).

🗺️ **Punt 2 dungeon-quests: 22 nov VAN MAIN gehaald** (Rob 22 nov via sparring, letterlijk: *"Zygor b"*). Gebouwd 21 nov uit Zygor;
nooit uitgebracht. Weg: data, module, knop, toc-regels, FDQ_-teksten, `build_dungeon_quests`. Geschiedenis niet herschreven.
Herbouw uit andere bronnen = stap e; het venster zonder data staat in git (`c4223dc:Modules/ForeverDungeonQuests.lua`).
Nooit de data, `inside` of volgorde uit die commit terugzetten.

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
