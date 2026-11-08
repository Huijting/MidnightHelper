# Midnight Helper — waar we staan

## 🆕 8 nov — Forever: tassen, mana/leven, buff-knop (Rob: "Ja, bouw alle drie")

- `Modules/ForeverWarnings.lua` (alleen Camelot-TOC): (1) vrije plekken in gewone tassen (bag family 0) ≤ grens
  (standaard 2) → `ns.FireAccessibleAlert` + chatregel met grijze spullen + waarde (`select(11, C_Item.GetItemInfo)`;
  0 als niet gecachet). Eén keer per keer onder de grens, nog één keer bij 0; in een gevecht wacht hij op
  PLAYER_REGEN_ENABLED. (2) PLAYER_TARGET_CHANGED op een aanvalbare vijand buiten gevecht: mana < 40% (alleen als
  UnitPowerMax(mana) > 0) of leven < 50%. Eén keer per GUID, max 1×/30 s. `/mh bags [on|off|n]`, `/mh rest
  [on|off|mana n|health n]`; kaal = diagnose met laatste besluit. `ns.db.foreverWarn`.
- `Modules/ForeverBuffs.lua` + `MissingBuff.lua` nu ook in de Camelot-TOC. `ns.GetMissingBuffs` vraagt op Forever
  `ns.GetForeverMissingBuffs`: buffs per class op naam uit `ns.FOREVER_SPELL_IDS` (alle ranks), aanwezig = elke rank
  of een "covers" (Prayer of Fortitude, Arcane Brilliance, Gift of the Wild), cast = hoogste bekende rank; keuzes
  (blessing, aura, armor, shield, imbue, aspect, demon) = laatst zelf gecaste (`ns.db.foreverBuffLast`). Pets:
  hunter Call/Revive Pet, warlock laatst opgeroepen demon. Bewust niet: Battle Shout (rage), rogue poisons (items).
  `/mh buffs [on|off]`. MissingBuff.lua: 4 events nu via pcall (Forever kent ze misschien niet; niet gemeten).
  ✅ Rob GEMETEN 8 nov: de buff-knop werkt. 🔴 Mana/leven GEMETEN kapot: `/mh rest` op een priest buiten gevecht gaf
  "mana none/unreadable, health unreadable" → de rest-melding kan nooit vuren. Vermoeden (AFGELEID): player health/
  power zijn secret in Forever, zoals health in Midnights open wereld. `/mh rest` print nu de ruwe client-waarden
  (UnitHealth/Max, UnitPower/Max, UnitHealthPercent, UnitPowerPercent: getal/secret/nil). ✅ Rob GEMETEN: UnitHealth,
  UnitPower(mana), UnitHealthPercent, UnitPowerPercent = **secret**; maxima leesbaar (162 / 232), power type 0. Rob
  ("Ja, probeer maar") → secret-pad gebouwd: `UnitPowerPercent/UnitHealthPercent(..., colorCurve)` → alpha 1 onder de
  grens, 0 erboven → `FontString:SetAlpha(secret)` (patroon uit DandersFrames HealthFade, alleen als kandidaat). Tekst
  zonder getal (`FWARN_REST_LOW_MANA/HEALTH`), geen chat/geluid (MH weet niet of het zichtbaar werd). Leesbare waarden
  → het oude pad. `/mh rest test` (jouw grenzen) en `/mh rest test show` (grens 101 = altijd zichtbaar: positieve
  controle). ✅ Rob GEMETEN 8 nov: `test show` toont beide regels, en "Low mana: drink first" verschijnt boven een
  vijand. Maar "de ene keer wel, de andere keer niet". Oorzaak AFGELEID uit de code: de 30-s-pauze startte ook als de
  regel onzichtbaar bleef (genoeg mana), en kort na een gevecht ben je nog "in combat". Gerepareerd: secret-pad zonder
  30-s-pauze (alleen nog één keer per vijand), en PLAYER_REGEN_ENABLED kijkt nog eens naar je doelwit. ✅ Rob hertest:
  mana-regel "elke keer". Leven-regel nog niet gezien (niet laag genoeg geweest). Tasmelding GEZIEN, "heel snel weg" →
  `ns.FireAccessibleAlert(msg, sound, hold)` kreeg een optionele `hold` (standaard 2 s, ongewijzigd voor debuffs);
  de tasmelding gebruikt 6 s. Niet hertest.
  Ook: "|h" in chat at "mana|health" op → nu "||". Tassen: nog niet getest. Onzeker (AFGELEID): `C_UnitAuras.GetPlayerAuraBySpellID` en
  `C_Secrets` in Forever; paladin-auras als buff leesbaar; hunter zonder getemd pet krijgt toch "SUMMON PET".
- Bijvangst gezien, niet aangeraakt: in `MissingBuff.lua` staat `ns.PrintMissingBuffDebug` BINNEN
  `EuiReminderLoaded()` (de functie mist zijn `end` vóór de debug-functie; die wordt pas gedefinieerd als
  EuiReminderLoaded een keer draait). Werkt toevallig; netjes maken = aparte klus.

## 🆕 8 nov — kleurenkaart MF Nameplates + pijl tot bij de trainer (Rob: "Ja, bouw allebei")

- Later (Rob: "verberg het die optie daar ook maar voor mensen zonder die MF nameplates"): `/mh colors` heeft
  `needsMF = true` in `ns.MH_COMMANDS`; `ns.CommandItemShown(item)` (CommandList.lua) laat hem in de commandolijst én
  in de zoekbalk (NavSearch) alleen zien als MF geladen is. Het commando zelf werkt nog voor iedereen.
  Daarna (Rob: "Kleine tip-kaart"): spelers ZONDER MF krijgen in de Tools-kamer een kaart "Nameplate colours (MF
  Nameplates)" (`needsNoMF`); die opent hetzelfde venster in tip-modus: wat MH zou uitleggen, "TwelveInchy, de maker
  van MH, gebruikt het zelf en vindt het erg handig; jij kiest", en een kopieer-vak met de link. Link GEMETEN:
  curseforge.com/projects/1763027 (uit MF's TOC) → https://www.curseforge.com/wow/addons/mf-nameplates. Teksten 8 talen
  (ru/de/fr/es/pt/it zelf geschreven, niet native nagekeken). Niet in de client getest.

- Nieuw `Modules/NameplateColors.lua` (beide TOCs, na VersionNotice). Leest LIVE `_G.MFNameplates.db.profile`
  (AceDB, MF-defaults erachter); MF heeft geen licentie → niets gekopieerd. Betekenis per kleur GEMETEN in MF
  `Core/Colors.lua` (BaseHealthColor: tapped > aggro > quest > caster > world > unitType > reaction; GetThreatColor).
  Toont alleen regels die aan staan (quest, caster, idle, world.*, unitType, threat per rol, cast incl. important/kick).
  Rol: groepsrol, anders spec-rol; onbekend = beide aggro-blokken. `/mh colors` (alias `colours`), `/mh colors check`
  = profiel + elke kleur met zijn instellingspad. Knop: ToolsLaunchpad (`needsMF`) en Forever-startpagina; alleen als
  MF geladen is. GEMETEN in Robs SV: Forever-profiel "Default" heeft `cast.useImportantColor = false`, Midnight niet.
  Teksten: en/nl zelf, ru/de/fr/es/pt/it via mh-writer (niet native nagekeken); esMX-regels (calabozos) toegevoegd.
  locale_probe OK in 8 talen, syntax OK, lint 0 HARD. **Niet in de client getest.**
  Spelwoorden NIET tegen de client gemeten (mh-writer twijfelde): deDE Rare ("Seltener Gegner" vs pack's "Elite-Rar"),
  itIT World boss, Battle pet in alle talen (geen pack had het), itIT "barre dei nomi", Rare in fr/es/pt/it/ru. Na te
  meten in wago GlobalStrings.
- Trainer-pijl wees verkeerd (Rob GEMETEN, screenshot: naast Dark Cleric Duesten "12 m" de muur in). Oorzaak
  AFGELEID uit de afstand: nearest-wins koos het HandyNotes-punt 31.34, 65.85 i.p.v. MH's 31.11, 66.07 (Rob gemeten).
  Nu `OnePerTrainer`: zelfde NPC-id = één plek, op bron-volgorde (zelf opgeslagen > `measured = true` in
  ForeverTrainerSpots > HandyNotes > MH-lijst), daarna pas dichtstbij. Niet opnieuw in de client getest.
- Pijl: `ns.lastTarget.arriveYards` (nieuw, NativeArrow): de trainer-route laat los op 5 yd i.p.v. 20 yd
  (`NEAR.arrived`). Het opnieuw-zetten van de Blizzard-pin blijft op 20 yd (geen churn met Blizzards eigen
  aankomst-wis). `TRAINER_SHOW` beëindigt de trainer-route (`_mhRouteOwner = nil`). Andere routes ongewijzigd.
- OPEN (Rob, later): **Platynator**. MH heeft `Addons/Platynator.lua` + `PlatynatorData.lua` (MH-profiel voor
  Platynator); Rob gebruikt het zelf niet meer ("moet eigenlijk wel een beetje weg"). GEMETEN: Platynator staat nog
  aan op 18 Midnight-characters, naast MF. Eerst met Rob bespreken wat ermee moet.

## 🆕 8 nov — kruis boven de trainer (Forever; Rob: "een kruis bovenop de trainer" → "Ja, bouw maar")

- `ForeverTrainer.lua` stap 3: `ForeverTrainerGo` (chat, venster-knop, startpagina) roept `ns.ForeverTrainerMark(best)`
  aan. Op `NAME_PLATE_UNIT_ADDED` krijgt het naamplaatje van die NPC (op NPC-id uit de GUID, anders op naam) een
  texture `UI-RaidTargetingIcon_7` erboven, zoals de rare-schedel in `Rares.lua`. Geen echt merkteken (protected).
  Weg bij `TRAINER_SHOW`, als een andere route `ns.lastTarget` overneemt, of na 20 min. Niet in instances.
- Schakelaar `ns.db.foreverTrainer.mark` (standaard aan): `/mh trainer mark on|off`; `/mh trainer mark plates` zet de
  CVar `nameplateShowFriendlyNpcs` aan; kaal `/mh trainer mark` = diagnose (CVar, instance, per plaatje naam/npc/kruis).
  Staat die CVar uit bij "go", dan één chatregel (`FTRAIN_MARK_NEED_PLATES`). Teksten en/nl/ru/de/fr/es/pt (geen itIT:
  geen Italiaanse Forever-client); locale_probe OK, syntax OK, lint 0 HARD. ✅ **Rob GEMETEN 8 nov: het kruis verschijnt** (*"ja het werkt"*), met MF
  Nameplates aan. Nog niet getest: verdwijnen bij het trainer-venster, de schakelaar uit/aan.
- Niet vastgesteld: of het via het NPC-id of via de naam herkende (`/mh trainer mark` zou het tonen). Een vergeten kruis blijft staan tot dat plaatje opnieuw verschijnt (geen timer).
- Bijvangst gerepareerd: `FTRAIN_WHY_FMT` zei in de/fr/es/pt/ru "/mh trainer hier/ici/aquí/aqui/здесь" — het commando
  `here` was meevertaald en werkte dus niet. Nu overal `/mh trainer here`.
- CharacterScape: bugmelding is door Rob verstuurd (8 nov); lokaal gerepareerd in `_forever_` (TOGGLECHARACTER0 uit
  `ShortcutRouting.lua`, origineel in de scratchpad). Rob GEMETEN: ~ geeft geen fout meer; `/cf` nog wel. Een
  CF-update van die addon zet het origineel terug.

## 🆕 8 nov — toetsenblok zegt welke spel-toetsen het overneemt (Rob: "Ja, bouw maar")

- Aanleiding: Rob: *"moeten we mensen vertellen dat wij de C toets hebben ingepikt"*. GEMETEN: "Place it" bindt élke
  bloktoets (`SetBinding`, ook over een spel-functie als C = Character Info heen); de oude binding stond alleen in de
  snapshot voor Undo, de speler hoorde niets. Rob had zelf Character aan ~ gekoppeld.
- `KeyBlock.lua`: `GameKeysTaken(rows)` = bloktoetsen waarvan `GetBindingAction` iets anders is dan een balkknop
  (ACTIONBUTTON/MULTIACTIONBAR/BONUSACTION/SHAPESHIFT/`CLICK `); naam via `_G["BINDING_NAME_"..cmd]` (clienttaal).
  Getoond: (1) oranje regel in de voorvertoning vóór Place (`KEYBLOCK_GAMEKEYS_FMT`, ook in de dry-run-chat);
  (2) na Place één keer in chat + blijvend in het venster (`snap.gameKeys`, `KEYBLOCK_GAMEKEYS_PLACED_FMT`); (3) bij
  Bijwerken per nieuw overgenomen toets een chatregel. Menupad = clientwoorden `GAMEMENU_OPTIONS` /
  `SETTINGS_KEYBINDINGS_LABEL` (GEMETEN 12.1.0 in docs/ROLE_SWITCH_FACTS_2026-10-07.md; Forever AFGELEID gelijk).
- Teksten 8 talen (knopwoord = KEYBLOCK_BTN_UNDO van elk pack); locale_probe OK, syntax OK, lint 0 HARD. Niet in de
  client getest. Een blok dat vóór vandaag geplaatst is, heeft geen `gameKeys` → eerst Undo om het te zien.
- Niet gedaan (Rob kiest later): knop "geef ze een vrije toets". Niet aangeraakt: `/mh apply` (ApplyLayout.lua) bindt
  ook toetsen en zegt het evenmin.
- Bijvangst: CharacterScape (Forever) geeft de secret-fout omdat het de Character-toets overneemt
  (`ShortcutRouting.lua:22`, eigen OnClick → taint); Rob GEMETEN: via het poppetje-icoon geen fout. Bugmelding:
  verstuurd, zie de sectie hierboven.

## 🆕 8 nov — melding "er is een nieuwere MH" (Rob: "Versie-melding" → "Ja bouw maar")

- Idee uit **DungeonJournal 1.7.2** (Forever, Exehn; in `_forever_`). GEMETEN: geen licentiebestand → alle rechten
  voorbehouden; niets gekopieerd, eigen code. Rest van die analyse (wat het brengt, lessen, idee "knop naar Dungeon
  Journal" via `ForeverDungeonJournal_NS`, mogelijk twee pijlen tegelijk) staat alleen in de chat van 8 nov; Rob koos
  alleen de versie-melding.
- Nieuw `Modules/VersionNotice.lua` (beide TOCs, na Changelog.lua). Prefix `MHVer`, bericht `1|<versie>`, via
  `ns.MH_SendAddon` (lockdown-queue). Stuurt: GUILD 15 s na login; groepskanaal als de groep groeit (max 1×/30 s);
  antwoordt één keer (2-8 s willekeurig, max 1×/60 s per kanaal) als hij een OUDERE versie hoort, tenzij een ander al
  antwoordde. Hoort hij een HOGERE: één chatregel per sessie (`VERNOTE_NEWER_FMT`), en bij de volgende login nog eens
  zolang die versie <3 dagen geleden gehoord is. Opslag `ns.db.versionNotice` (`on`, `seen`).
- `/mh version [on|off]` (Core.lua); kaal = diagnose (eigen versie, guild/groep, verstuurd/gehoord, hoogste gehoord).
- Tekst: enUS, nlNL, ruRU, de/fr/es/pt/it (Translations2026, eigen vertaling). locale_probe GEMETEN OK in 8 talen;
  syntax OK; lint 0 HARD. ⚠️ Niet in de client getest. AFGELEID: CHAT_MSG_ADDON-args zijn geen secret values (guard
  staat er toch). Test kan alleen met een tweede speler met een oudere MH (TESTLIJST 8 nov).
- ✅ Addon-meldingen (Rob 8 nov "Ja, bouw maar"): `tools/addon_updates.py` kijkt nu in `_retail_` én `_forever_`
  (eigen seen-bestand `addon_versions_seen_forever.json`, gitignored; eerste Forever-run 8 nov = basis van 47 addons).
  Wachtlijst = addons die op ELK character uit staan (AddOns.txt), RaiderIO_DB_* uitgezonderd; krijgt er één een nieuwe
  versie → 🔔 bovenaan. GEMETEN 8 nov: Forever-wachtlijst = CharacterForever 0.13.10 (CharacterScape, uit op 11/11);
  Midnight-wachtlijst = ClickCastingTooltip, HexBreak, TankTraining. Bel GEMETEN met een nep-kopie (0.13.9 → 0.13.10:
  🔔 verschijnt). CharacterScape heeft geen changelog in de map → bij een bel zelf op CurseForge opzoeken. CLAUDE.md 4b
  bijgewerkt.

## 🆕 7 nov (avond) — Forever: waarschuwing voor je laatste gereedschap (Rob: "ja doe maar")

- Aanleiding: Rob verkocht per ongeluk zijn Skinning Knife. Nieuw `Modules/ForeverToolGuard.lua` (beide TOCs,
  `IS_FOREVER`), `/mh toolguard [on|off]` (Core.lua; kaal = diagnose). Alleen bij je LAATSTE van een soort:
  1. bij een verkoper een rode tooltip-regel (`TooltipDataProcessor.AddTooltipPostCall`, Item);
  2. bij vernietigen een eigen MH-notitie onder de game-dialoog (`DELETE_ITEM_CONFIRM` → GUID → itemID;
     `StaticPopup_FindVisible`; niets in de Blizzard-dialoog geschreven);
  3. toch verkocht: venster met knop Terugkopen (`GetBuybackItemLink`/`BuybackItem`), via MERCHANT_UPDATE/BAG_UPDATE_DELAYED.
- Data GEMETEN door mh-research (wago 1.60.1.70862 ItemSparse.TotemCategoryID: 22 items; + 5060 Thieves' Tools en 4471
  Flint and Tinder per item-id; totems 5175-5178 niet te verkopen/vernietigen → weggelaten; hengels geen categorie).
  Interface-feiten uit Gethe wow-ui-source branch `forever` (commit 9dc84f0d3b): Forever-UI = Mainline + Camelot-overrides.
- ✅ Rob 7 nov laat (screenshots, Mining Pick): tooltip-regel bij de verkoper, venster na verkopen, en Buy back
  ("de buyback werkte") — alle drie GEMETEN in de game. "Dock to window" viel over de tekst → tekst naar -32 (`1dae53e`,
  nog niet opnieuw gezien). Nog open: de vernietig-notitie, "geen regel zonder verkoper", "twee = geen waarschuwing".
- AFGELEID: of vervangers (hogere staaf, Gnomish Army Knife) tellen — we tellen alleen dezelfde soort.

## 📋 Open voor de volgende bouwchat (7 nov laat)

- Site-chat seinen over de drie nieuwe Forever-dingen van vanavond (Train all, totem-regel, gereedschap-waarschuwing);
  regel "site volgt elke functie". Live zetten alleen na Robs ja.
- TESTLIJST bovenaan: totem-regel (bank-truc of rond level 10), Train all-details, vernietig-notitie, key block-popup.
- ✅ CF GEMETEN 8 nov (files-API): 9495701 "v5.0.1" = 12.0.7/12.1.0/12.1.5/12.1.7, 9495775 "v5.0.1-forever" =
  alleen 1.60.1, beide status 4 (zoals 5.0.0). De splitsing werkt.
- Site-chat (nu «Site chat 08-11», local_c8d2e9f7) wil het sein over Train all/totem/gereedschap pas als die UIT zijn.
- Optioneel Rob: `CURSEFORGE_DESCRIPTION.md` opnieuw plakken (zin over tooltips + 3D-trainer).
- Volgende release (5.0.2?) bundelt Train all + totem-regel + gereedschap-waarschuwing; alleen op Robs go.

## 🆕 7 nov (avond) — Forever: trainervenster zegt welk totem-voorwerp een Shaman mist (Rob: "ja")

- Aanleiding: Robs Tauren leerde Earthbind Totem op 6, tooltip "Tools: Earth Totem" rood; ons venster zei niets.
- `ForeverTrainer.lua`: `TotemFor(id)` leest de "Tools:"-regel uit de tooltip van de game (verborgen GameTooltip,
  prefix uit `SPELL_TOTEMS` als die bestaat) en vergelijkt met de clientnamen van items 5175/5176/5177/5178 (GEMETEN
  wago ItemSparse 70862, TotemCategory 2/4/5/3). Geen eigen spell-lijst. Zit het item niet in je tassen: oranje regel
  onder de spell ("needs the Earth Totem, from a class quest at level 4"), en bovenaan een kopje voor totems die je al
  kent maar niet kunt neerzetten. Alleen SHAMAN.
- Startplek alleen op een Engelse client (Engelse NPC-namen), alleen wat twee mh-research-rapporten samen hadden:
  Earth Tauren Seer Ravenfeather / Orc+Troll Canaga Earthcaller / Dwarf Teo Hammerstorm; Fire Tauren Narm Skychaser;
  Water/Air Horde Searn Firewarder. Levels 4/10/20/30.
- Teksten `FTRAIN_TOTEM_*`: enUS, nlNL, ruRU, de/fr/es/pt. ⚠️ AFGELEID, niet getest: of `SetSpellByID` op een verborgen
  tooltip in Forever de Tools-regel geeft.

## 🆕 7 nov (avond) — Forever: knop "Train all" onder het trainer-venster (Rob: "ja")

- Aanleiding: Rob zag bij zijn zusje (undead warlock) de knop niet. GEMETEN: die komt van **Talents Forever**
  (`TalentsForeverBook/UI.lua`, knop `TalentsForeverBookTrainAll`), niet van MH; zij heeft die addon vermoedelijk niet.
  Talents Forever heeft geen licentiebestand (GEMETEN) → niets gekopieerd, eigen code.
- Nieuw `Modules/ForeverTrainAll.lua` (beide TOCs, na ForeverTrainer.lua; `IS_FOREVER`-guard): knop onder
  `ClassTrainerTrainButton`, tekst "Train all (n, prijs)", tooltip per spell + "X more than your money covers". Klik koopt
  één rij, wacht op TRAINER_UPDATE, leest de lijst opnieuw; geen update na 1,5 s en de rij is nog te koop → stop + melding
  (geweigerd kopen geeft geen Lua-fout). Geen knop bij profession trainer (`IsTradeskillTrainer`), Beast Training
  (`npc`=pet of trainingspunten), of als Talents Forever geladen is in stand `auto`.
  `/mh trainer button [on|off|auto]`; kaal = diagnose. Teksten `FTRAIN_ALL*`: enUS, nlNL, ruRU, de/fr/es/pt
  (Translations2026, eigen vertaling, geen itIT).
- ✅ Rob 7 nov: werkt in de game (Talents Forever uit, onze knop leerde de spells) → rijen lezen en kopen door een addon
  mag bij de class trainer. Nog AFGELEID: of `IsTradeskillTrainer` bestaat (profession trainer zonder knop). We veranderen het filter van het venster niet: staat "Available" uit, dan ziet de knop niets.
  Testpunten in TESTLIJST.

## ✅ 7 nov (avond) — v5.0.1-forever: Forever-helft alsnog geüpload (Rob: "Ja, push maar")

- Tag `v5.0.1-forever` op `0daad62`, run 42395063118 GEMETEN: alleen Forever-stap; "Game version: 1.60.1",
  `MidnightHelper-v5.0.1-forever.zip` → CurseForge, Wago, GitHub "Success!"; verify: release bestaat, zip aanwezig.
  De reparatie (`## Interface-Camelot: 16001`) werkt dus.
- Om 17:13 UTC stonden 5.0.1 en 5.0.1-forever nog NIET in de publieke CF files-API (wachten op goedkeuring, 5.0.0 duurde
  ~11 min). Nog nameten: twee bestanden, retail-bestand zonder 1.60.1, forever-bestand alleen 1.60.1.
- Les: de packager toetst bij `-g` ELKE toc; een volgende normale tag doet beide stappen in één run.

## 🚀⚠️ 7 nov (avond) — v5.0.1 getagd (Rob: "Ja, tag maar"): Retail UIT, Forever-helft MISLUKT

- Run 42394547282 GEMETEN: stap Retail OK — `MidnightHelper-v5.0.1.zip`, game versions 12.1.7/12.1.5/12.1.0/12.0.7 (geen
  1.60.1), CurseForge/Wago/GitHub "Success!". Stap Forever faalde meteen: *"MidnightHelper.toc does not have an interface
  version that is compatible with the game version forever"* — de packager toetst élke toc aan `-g`. Verify-stap
  overgeslagen. Forever-spelers zitten dus nog op 5.0.0 (dat bestand heeft 1.60.1).
- Reparatie (gecommit, NIET getagd): `## Interface-Camelot: 16001` in MidnightHelper.toc (packager-regel; AFGELEID: de
  client negeert hem) + `release.yml`: tag die op `-forever` eindigt draait alleen de Forever-stap (herstel-tag
  `v5.0.1-forever`), verify verwacht dan geen Retail-zip. AFGELEID uit release.sh (fallback-tak leest
  `## Interface-<type>`); niet lokaal gedraaid. Wacht op Robs go voor de herstel-tag.

## 📦 7 nov (avond) — 5.0.1 klaargezet (Rob: "Ja, 5.0.1")

- Beide TOCs 5.0.1; Changelog.lua blok 5.0.1 (CHANGELOG_501_1-3, enUS); CHANGELOG.md; RELEASE_NOTES.md =
  docs/CURSEFORGE_5.0.1.md (GEMETEN byte-gelijk, 27 regels, met beta-alinea bovenaan); CURSEFORGE_DESCRIPTION.md: één zin
  over tooltips + 3D-trainer (Rob moet de beschrijving opnieuw plakken als hij die zin wil). Syntax OK, lint 0 HARD.
- Na de tag nameten (eerste gesplitste upload): CF files-API twee bestanden met juiste `gameVersions`, GitHub-release twee
  zips, Wago in de log. Zie RELEASE_CHECKLIST stap 1.

## 🧍 7 nov (avond) — trainervenster: draaiend 3D-model van de dichtstbijzijnde trainer (Rob: "Ja, bouw maar")

- `ForeverTrainer.lua`: `Candidates` geeft nu `npc` mee (MH-lijst, HandyNotes `node.npc`, eigen `/mh trainer here`);
  `ns.ForeverTrainerNearestNpc()`. Venster: `PlayerModel` rechts (170 breed), `SetCreature(npc)`, `SetPortraitZoom(0)`,
  draait via OnUpdate; naam eronder. Venster wordt 740 breed met model, 560 zonder; scroll heeft nu een vaste breedte.
  Nalaad-tik 0,2 s; na 1,5 s `GetModelFileID` leeg → paneel weg (geen zwart vak). Drusilla La Salle = npc 459 in
  MH-lijst én HandyNotes (GEMETEN). ⚠️ AFGELEID, niet getest: `PlayerModel`/`SetCreature` in de Forever-client.

## 💬 7 nov (avond) — trainervenster: tooltip op elke spell (Rob: "ik wil tooltips bij de spells")

- `ForeverTrainer.lua`: het venster is nu één font string per regel (pool `f.rows`) i.p.v. één tekstblok; spellregels
  (nu leren, eerst nodig, volgend level) krijgen een onzichtbare knop (`f.hot`) met `GameTooltip:SetSpellByID` (pcall).
  Bewust geen `|Hspell`-links: die werken niet in een ScrollFrame (notitie PlayCardWindow.lua). `Text()` geeft nu ook
  `lines, ids` terug; `ns.ForeverTrainerText` blijft één string. Syntax OK, lint 0 HARD. Niet in de client getest;
  ⚠️ AFGELEID: `SetSpellByID` bestaat in de Forever-client (pcall vangt het als dat niet zo is → geen tooltip).

## 🔑 7 nov (avond) — toetsenblok-melding noemt de spell, niet "macro" (Rob: "Ja, doe maar")

- Bug (Rob, screenshot): Forever-popup "New for your key block: macro -> 2 / macro -> F". Oorzaak GEMETEN: de want is
  `{kind="macro", id=<macronaam>}` en `OccupantName` zoekt `GetMacroInfo(naam)` — die macro bestaat pas na "Place it",
  dus terugval "macro". Fix `KeyBlock.lua`: want krijgt `label = hit.spell.name` (clientnaam uit ForeverBlock),
  `MissingName` gebruikt die. Ook de chatregel na Bijwerken en `/mh block` profiteren.
- Nieuwe grijze regel onder de lijst als er een macro tussen zit: `KEYBLOCK_NEW_MACRO_NOTE` ("…always uses your highest
  rank"). Rank-woord = clientwoord (CLIENT_NAMES_FOREVER: Rang/Rang/Rango/Grau/Уровень). itIT bewust niet (geen
  Forever-client). locale_probe GEMETEN OK in 6 talen; lint 0 HARD; syntax OK. Niet in de client getest.

## 📦 7 nov (avond) — vanaf de volgende release: apart Forever-bestand (Rob: "Ja, bij volgende")

- Waarom: CF telt per bestand. 5.0.0 = één zip voor Retail + Forever → GEMETEN (CF files-API) 90 downloads, niet te
  splitsen. Nu draait `release.yml` de packager twee keer: `-g retail` en `-g forever` (→ `…-forever.zip`, label
  `v…-forever`, alleen 1.60.1). GEMETEN in packager@v2 `release.sh`: forever/camelot bekend, CF-type 88568,
  `set_build_version` houdt alleen de gekozen versies, GitHub-release wordt bijgewerkt (niet dubbel). Verify-stap eist nu
  beide zips op de GitHub-release.
- ⚠️ AFGELEID, niet getest: dat de Retail-run de 1.60.1 echt weglaat, en dat Wago beide bestanden goed labelt. Na de
  eerste gesplitste tag nameten (CF files-API: `gameVersions` per bestand). Tellen: CF-teller van het `-forever`-bestand.
- Wago: bij een ontbrekende Wago-versie pakt de packager de dichtstbijzijnde (log-WARNING lezen).

## 🚀 7 nov (middag) — 5.0.0 IS UIT (tag v5.0.0, Robs go)

- Tag `v5.0.0` (annotated) op `817daf0`, gepusht na "SITE KLAAR" van de site-chat. Release-run 42373267211 GEMETEN:
  multi-version 12.1.7 / 12.1.5 / 12.1.0 / 12.0.7 / **1.60.1**, `MidnightHelper_Camelot.toc` + alle Forever-bestanden in
  de zip, CurseForge "Success!", Wago "Success!", GitHub-release bestaat.
- ✅ GEMETEN (CF-API, 7 nov): file 9492132 "v5.0.0", releaseType 1, gameVersions 12.0.7/12.1.0/12.1.5/12.1.7 + **1.60.1
  (type 88568 = Forever)**, goedgekeurd 12:48:55 UTC. Rob: *"CF is live en gecheked 🙂 description geplakt"*. Site-chat
  gemeld (strip bijwerken, live na Robs ja).
- Open: (1) Rob test na de release (TESTLIJST 7 nov nacht + nacht laat). (2) Iemand met een niet-Engelse Forever-client
  zoeken voor het toetsenblok. (3) Site live (site-chat, na Robs ja).
- Rob installeert MH op zijn eigen pc NIET via de CurseForge-app in `_forever_`: daar staat de koppeling naar de repo.

## 🌍 7 nov (nacht, laat) — 5.0.0: vertaalronde af + toetsenblok op spellnummers (Rob: "ja op spell nummers")

- **Robs go voor de tag** (letterlijk): *"Als alles klaar is, ook voor de site chat, dan krijg je bij deze een go."* en
  *"Nee, tag maar"* (geen eigen test vooraf). Voorwaarden: vertaalronde af + checks schoon + site-chat meldt "klaar".
- **Gemeten (mh-research, wago wowf 1.60.1.70862 = Robs build):** `docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md`,
  448 namen in de/fr/es/esMX/pt/ru. **Forever heeft GEEN itIT-client** (launcher-config: enUS deDE esES esMX frFR ruRU
  koKR ptBR zhTW zhCN). Spells kunnen per rank anders heten (deDE Smite r1 "Heilige Pein", r2+ "Göttliche Pein").
  ⚠️ Correctie op die tabel (mh-research zelf): Druid-rij "Growl" noemt 1853 (Hunter-pet); de Druid-Growl is 6795; de
  "Claw"-telling T13 telde pet-ranks mee. De namen in die rijen kloppen wel.
- 🐛→✅ **Toetsenblok was leeg op elke niet-Engelse Forever-client** (zocht en castte op ENGELSE naam). Nu: `Known()` zoekt
  ook op id (`Modules/ForeverSpellIds.lua`, 487 namen / 1704 ids, mh-research, in RANK-volgorde — niet sorteren! Slam
  r1 = 1240193) + trainer-ids; de macro krijgt `C_Spell.GetSpellName(id)` (clientnaam van de hoogste bekende rank);
  "niet in MH's lijst" vergelijkt ook op id. Offline GEMETEN (scratch `forever_locale_block_test.lua`): 9/9 classes
  evenveel macro's als Engels, 0 Engelse namen in `/cast`, 0 namen zonder id; controle (oude code) = 0 macro's.
  ⚠️ Niet in een echte niet-Engelse client getest. ⚠️ AFGELEID risico: frFR Smite en Chastise (Dwarf) heten beide
  "Châtiment" → `/cast Châtiment` kan bij een Franse Dwarf Priest de verkeerde pakken.
- **Vertalingen (mh-writer, eigen werk, niet native-gecheckt):** How you play per taal in
  `Locales/ForeverHowToPlay_<deDE|frFR|esES|esMX|ptBR|ruRU|nlNL>.lua` (alle 52 secties; esMX ~120 namen anders), 60 korte
  sleutels per taal (Translations2026 + ruRU; 3 oude HOME_FOREVER_* in place vervangen want `fill()` overschrijft geen
  vertaling), itIT alleen de 4 retail-reclamesleutels. "block D" = woord van elk pakket (`FTRAIN_BLOCK_D`).
  locale_probe GEMETEN: OK in alle 7 (itIT Forever-sleutels → Engels, bewust). check_drift: alleen `GEARLADDER_FOOT`
  (niet van vandaag).
- Open, niet gemeten: welk woord het Forever-menu voor "AddOns" toont per taal (vertalers lieten "AddOns" staan).

## 🚀 7 nov (nacht) — 5.0.0 in voorbereiding: Forever in de release (Rob: "Ja, begin"; NOG GEEN TAG)

- Robs keuzes: **5.0.0**, **meteen Release** (geen beta), retail-melding **alle drie** (changelog + Home-kaart + eenmalige
  chatregel), How you play **"Alles in 5.0.0"** (alle talen vóór de release). Tag `v5.0.0` pas op Robs go.
- ✅ Gedaan: `MidnightHelper_Camelot.toc` in git (uit `.gitignore`, `.pkgmeta`, `package.ps1`), `## Version 5.0.0` in
  beide TOC's (+ `X-Curse-Project-ID`/`X-Wago-ID` in Camelot), RELEASE_CHECKLIST zegt "beide TOC's".
  Vertaalbaar gemaakt: questhint (`FQH_*`), balken-vraag (`FBAR_*`; `/mh mylayout`-chat blijft Engels = handcommando),
  How you play (per taal `Locales/ForeverHowToPlay_<code>.lua`, zelfde vorm; esMX valt terug op esES; nlNL ✅ klaar,
  door mh-writer, in beide TOC's, alleen op Forever). Retail: Home-kaart `HOME_FOREVER_AD_*` (wegklikbaar,
  `db.foreverAnnounceSeen`) + chatregel `FOREVER_AD_CHAT` (`db.foreverChatSeen`, 8 s na eerste laadscherm).
  Changelog `CHANGELOG_500_0..9`, `RELEASE_NOTES.md` = `docs/CURSEFORGE_5.0.0.md` (byte-gelijk GEMETEN),
  `CHANGELOG.md`, `CURSEFORGE_DESCRIPTION.md` (Forever-blok bovenaan; Rob plakt).
- 🔴 OPEN vóór de tag:
  1. mh-research meet de Forever-spellnamen per taal → `docs/forever/CLIENT_NAMES_FOREVER_2026-11-07.md` (loopt).
  2. Daarna How you play + alle `FTRAIN_/FQH_/FBAR_/HOME_FOREVER_/TOOLLP_HOWTO/TRAINER/FHOWTO_/FOREVER_AD_`-sleutels naar
     de/fr/es/pt/it/ru (Translations2026 + ruRU), `HOME_FOREVER_BODY` is gewijzigd (drift).
  3. Site-chat inlichten (Forever op de site; live pas na de release).
  4. Rob test (TESTLIJST), dan zijn go → tag.
- ✅ GEMETEN (Robs screenshot): de CurseForge-app heeft een keuzelijst Retail / Forever / Retail PTR; alle teksten zeggen
  nu "switch from Retail to Forever".
- `docs/forever/MidnightHelper_Camelot.toc.txt` is nu overbodig (het echte bestand zit in git); bijgewerkt, niet gewist.

## 🛠️ 7 nov (avond, laatst) — trainervenster: je geld + vertaalbaar (Rob: "Ja, dat klopt")

- ✅ GEMETEN Rob (screenshots): het Forever-startscherm, het trainervenster en de knoppen werken. Tools-tab niet gezien.
- Rob: *"dat we ook kunnen zien hoeveel geld we hebben … nu moet ik ook eerst op B drukken"*. `ForeverTrainer.lua`
  `Text()`: bovenaan *Your money* (`GetMoney`), rood met het tekort als het niet genoeg is voor wat je nu kunt leren;
  het venster vult zich opnieuw bij `PLAYER_MONEY`. Startscherm: ook een geld-regel (ververst pas bij opnieuw openen).
- Trainervenster vertaalbaar: `FTRAIN_*`-sleutels (enUS + nlNL); ook de trainer-regel, afstand en bron. De chatregels
  van `/mh trainer check` blijven Engels (diagnose). ⚠️ De offline scratch-test van de trainer kent `ns:L` niet; draai
  hem niet zonder stub.
- Kruimelpad op Forever: "Ik > Forever" (UI.lua, tab `home`). "(2)" → "2 spells". Titel goud (1, 0.82, 0).
- Rob over retail: niet nodig — daar leer je spells vanzelf, zonder trainer of geld (AFGELEID, niet nagemeten).
- Syntax OK, lint 0 HARD. Niet in het spel gezien.

## 🛠️ 7 nov (avond, laat) — Forever-startscherm + Tools-kaarten (Rob: "Ja, graag gedaan")

- Rob: het startscherm moet duidelijk "speciaal voor Forever" zijn, en `/mh play` was nergens in MH te vinden.
- `HomeDashboard.lua`, alleen `ns.IS_FOREVER`: titel `HOME_FOREVER_TITLE`, ondertitel "Level N <class>" i.p.v. de
  weekreset; blokken *Je trainer* (`ForeverTrainerCompute`: nu te leren + prijs, of volgende level; knoppen
  `ShowForeverTrainer` / `ForeverTrainerGo` + `ForeverTrainerNearestText`), *Je class spelen* (How you play, toetsenblok,
  toetsen), daarna de vroege-test-tekst (bijgewerkt: wat nu werkt). Retail ongewijzigd.
- `ToolsLaunchpad.lua`: twee kaarten met `foreverOnly = true` (How you play `/mh play`, trainer `/mh trainer`); op retail
  verborgen.
- Dubbele "Info"-knop: `ABOUT_BUTTON` nl "Over MH", de "Über MH", it "Su MH" (linter wil commentaar op een eigen regel).
- Teksten alleen enUS + nlNL. 🔴 **OPEN — stap 2 van Robs plan: de vertaalronde** — ALLE nieuwe Forever-teksten (trainer,
  questhint, mylayout, startscherm, Tools-kaarten, `HOME_FOREVER_BODY` is gewijzigd → drift) naar de/fr/es/pt/it/ru, met
  per taal GEMETEN clientnamen voor spells. Vóór de release.
- Syntax OK, lint 0 HARD. Niet in het spel gezien (TESTLIJST 7 nov avond).

## 🛠️ 7 nov (avond) — Forever: bij een nieuw character de MH-balkenindeling aanbieden (Rob: "Bouw het maar")

- Rob: standaard vragen bij een nieuw character, IN PLAATS VAN de automatische "Use your layout Inchy Hunter?"-vraag, met
  een knop om de vraag niet meer te krijgen en een instelling om hem weer aan te zetten; *"Doe voorlopig alleen maar
  forever"*. Die oude automatische vraag vervalt (Robs keuze); `/mh mylayout` blijft als commando.
- `ForeverLayoutCarry.lua`: na het inloggen (wacht op Edit Mode, filmpje, combat) op een character op Modern/Classic de
  vraag *"Set up the Midnight Helper bar layout?"* — **Yes** = `MH_EditModeMakeOwnLayout` (= toetsenblok stap 2) + popup
  "Reload now" → `KeyBlockReloadAndReopen` (toetsenblok gaat open voor stap 1); **Not now** = per character
  (`foreverBarLayoutAsked`); **Never ask again** = `foreverAskBarLayout = false`. Niet bij EllesmereUI-bars of een eigen
  layout. `/mh mylayout check` zegt ook waarom de vraag wel/niet komt.
- Instelling `mh_foreverAskBarLayout` in SettingsDefs (alleen `ns.IS_FOREVER`, standaard aan), teksten
  `SET_FOREVER_BARLAYOUT_TITLE/_DESC` in 8 talen (locale_probe 8/8 OK; bewust zonder preset-namen).
- GEMETEN offline (scratch `mylayout_test.py`): beslissing klopt voor Modern / uit / EllesmereUI / eigen layout / "Not
  now". Syntax OK, lint 0 HARD. Niet in het spel gezien.

## 🐛 7 nov (middag) — stap 2 in Forever: menu/tassen over het blok, griffioenen zichtbaar (Robs screenshot)

- ✅ GEMETEN Rob (nieuwe Priest "Ima Priestman"): de layoutnaam met achternaam klopt ("Ima Priestman Priest", in de SV),
  alle balken aan. ❌ Menu + tassen midden onder over blok C; de twee griffioenen zichtbaar.
- GEMETEN: Hunter-layout vs Modern-kopie in de SV (scratch `layoutdiff.py`) + Blizzards Forever-bron (Gethe/wow-ui-source
  branch forever, `EditModeManagerConstantsDocumentation.lua`): `EditModeSystem` MicroMenu 13, Bags 14,
  MainActionBarEndCap 26 (index 1 links, 2 rechts; setting 0 = Hidden). Hunter: menu/tassen rechtsonder, endcaps 0=1.
- Reparatie `MH_EditModeApplyKeyBlock`, alleen `ns.IS_FOREVER`: Bags BOTTOMRIGHT UIParent (-4,4), MicroMenu links ernaast
  (BOTTOMRIGHT → BagsBar BOTTOMLEFT -7), endcaps setting 0 = 1. Frame-namen MicroMenuContainer/BagsBar GEMETEN als
  relativeTo. Retail ongemoeid. Syntax OK, lint 0 HARD. Niet offline te testen (live frames); posities AFGELEID.
- ⚠️ Een character dat stap 2 al deed (Ima Priestman): eerst "zet terug", dan stap 2 opnieuw (anders "already a block").
- ✅ Rob: *"Ja, dit werkte beter"*. Daarna: XP-balk *"ietsjes uit het lood"*. StatusTrackingBar = systeem 15 index 1;
  Hunter GEMETEN: BOTTOM → MultiBarLeft TOP (48, 4). Stap 2 (Forever) zet hem nu precies zo; stance/possess (11/13)
  16 hoger zodat ze er niet over vallen (16 = AFGELEID). Niet in het spel gezien.

## 🛠️ 7 nov (middag) — layoutnaam met Forever-achternaam (Rob: "doe jouw voorstel maar")

- Rob vroeg of RP-characters met voor- en achternaam goed gaan. GEMETEN (SimC-commit 5 nov, API_WATCH 6 nov): op Forever
  geeft `UnitName("player")` de achternaam als 2e waarde; MH las alleen de 1e → "Ima Shaman".
- `EditModeBackup.lua` `OwnLayoutName()`: Forever met achternaam → "<voor><scheiding><achter> <spec>" (Blizzards
  `CHARACTERNAME_SURNAME_SEPARATOR`, anders spatie) als het in 30 past, anders "<voor> <spec>", anders op hele letters
  ingekort (`CutUtf8`; de oude `sub(1,30)` kon midden in een letter knippen). Retail ongewijzigd (2e waarde = realm).
  Een layout van vóór vandaag onder de oude naam wordt teruggevonden (geen dubbele); ook de "made"-herkenning kent beide.
- GEMETEN offline (scratch `layoutname_test.py`, echte EditModeBackup.lua): 6/6 ("Ima Shamandwarf Shaman", te lang →
  zonder achternaam, accenten → geldige UTF-8, retail negeert realm). Syntax OK, lint 0 HARD. Niet in het spel gezien.

## 🐛 7 nov (middag) — /mh mylayout: herladen geblokkeerd, vraag kwam niet vanzelf (Rob, BugSack)

- GEMETEN Rob: `ADDON_ACTION_BLOCKED … protected function 'Reload()'` uit `ForeverLayoutCarry.lua:194` (ReloadUI in
  dezelfde klik als SaveLayouts/SetActiveLayout). En op een gloednieuw character kwam de vraag niet vanzelf (Rob dacht:
  intro-filmpje); `/mh mylayout` toonde hem wel.
- Reparatie: Yes wisselt alleen de layout; daarna een Blizzard-StaticPopup "Reload now" = tweede klik → `C_UI.Reload`
  (zelfde patroon als KeyBlock NeedReload, werkt sinds 5 okt). Inloggen: alle "nog niet klaar"-redenen ~1 min opnieuw
  proberen (eerst stopte "no layouts" het voorgoed), en wachten op `InCinematic`/CINEMATIC_STOP. Oorzaak van de gemiste
  vraag AFGELEID. Offline: test 4b (popup, pas na klik herladen) + 5 oude gevallen goed. Syntax OK.
- ✅ Uitgezocht met `/mh bars` (BarInventory) op beide characters, GEMETEN in de Forever-SV: Shaman actieve layout
  "Inchy Hunter" (de layout kwam dus over), AlwaysShowButtons=1 voor balk 1-8, maar `GetActionBarToggles` 7× false;
  Hunter dezelfde layout en 7× true. De aan/uit-knopjes van balk 2-8 zijn dus PER CHARACTER, niet in de layout.
  Reparatie: `remember` leest ze (`ReadBarToggles`), Yes zet ze met `SetActionBarToggles` (zelfde volgorde als Get:
  AFGELEID; bij Robs 7× true maakt de volgorde niet uit). Offline: SetActionBarToggles krijgt 7× true. ✅ GEMETEN Rob
  (screenshot Shaman): balk 2-8 staan er nu. Spells op hun plek = toetsenblok per character (`/mh block`).
- 💡 Rob daarna: *"Deze layout wil ik eigenlijk aan iedereen aanbieden … als mensen kiezen om die layout te gebruiken"*.
  GEMETEN: "Inchy Hunter" staat in `keyBlockMadeLayouts` = MH's eigen toetsenblok stap 2 maakte hem al; alleen de
  balk-knopjes ontbraken (SetActionBarToggles kwam alleen in BarInventory/ForeverLayoutCarry voor).
  ✅ A gebouwd (Rob: *"ja begin met a"*): `EditModeBackup.lua` — stap 2 (`MH_EditModeApplyKeyBlock`) zet na
  SaveLayouts alle 7 knopjes aan (`BarTogglesOn`, zoals op Robs werkende Hunter) en bewaart de oude stand per character;
  "zet terug" (`MH_EditModeRestoreKeyBlock`, beide paden) zet ze terug (`BarTogglesBack`). Geldt retail + Forever.
  Chatregel `KEYBLOCK_BARS_ON_FMT` in 8 talen (enUS/nlNL/ruRU + de/fr/es/pt/it in Translations2026), GEMETEN met
  locale_probe: 8/8 OK. Syntax OK, lint 0 HARD. NIET offline getest (de stap hangt aan live frames); AFGELEID dat het
  werkt — SetActionBarToggles zelf werkte op Forever via /mh mylayout. 🔜 B (Robs volledige layout meeleveren) op verzoek.

## 🛠️ 7 nov (middag) — Forever: je layout naar elk nieuw character (Rob: "kan dat beter ?" → "2")

- Aanleiding (Robs screenshot): zijn layout "Inchy Hunter" is een CHARACTER-layout, dus elk nieuw character begint op
  Modern en hij zet alles opnieuw. Eerst geadviseerd: zelf een account-layout maken (spel zelf). Rob koos optie 2.
- Nieuw `Modules/ForeverLayoutCarry.lua` (beide TOC's + docs-kopie, alleen Forever): `/mh mylayout remember` bewaart de
  ACTIEVE layout als Blizzards exportstring accountbreed (`ns.db.foreverMyLayout`). Een character op Modern/Classic krijgt
  na het inloggen één vraag (*"Use your layout … here?"*); Ja = toevoegen als character-layout (of een account-layout
  met die naam kiezen) + actief maken + controleren + ReloadUI (na de klik); Nee = per character niet meer.
  `/mh mylayout` vraagt opnieuw, `check` zegt waarom wel/niet, `forget` wist. Zelfde stappen als
  `MH_EditModeMakeOwnLayout` (presets eerst tellen, SaveLayouts, OnLayoutAdded, SetActiveLayout). Nooit vanzelf.
- GEMETEN offline (scratch `mylayout_test.py`, nep-Edit Mode): onthouden, nieuw char → vraag + Ja → actief, account-layout
  met die naam → gekozen, 5 eigen layouts → nette weigering, "Nee" → geen vraag meer. Syntax OK, lint 0 HARD.
  AFGELEID: dat C_EditMode-export/import en de bar-zichtbaarheid zo op Forever werken (retail 12.0.7 wel GEMETEN).

## 🐛 7 nov (middag) — quest-hint telde armor niet (Rob: "denk dat het niet goed gaat ?!?")

- GEMETEN Rob (screenshot, Dwarf Hunter): Snow Boots (7 armor, geen stats) vs gedragen laarzen (2 armor); GearQuest zag
  de upgrade, MH zei "None of these is better … Bear Shawl sells for the most (9)". Twee fouten: armor telde niet mee, en
  de globale `GetCoinTextureString` gaf geen munt op Forever (AFGELEID uit die "(9)").
- Reparatie `ForeverQuestHint.lua`: volgorde main stats → Stamina (waar het telt) → armor. Armor uit de stats
  (`RESISTANCE0_NAME`) of anders de tooltipregel via `C_TooltipInfo.GetHyperlink` + `ARMOR_TEMPLATE` (aanpak van Zygor;
  Baganator/Syndicator/Auctionator gebruiken die API op Forever — kandidaat). `Stats()` geeft nu ook armor voor items
  zonder stats. Prijs via `C_CurrencyInfo.GetCoinTextureString`. `/mh questhint check` toont armor per beloning.
- Offline 9/9 (scratch `questhint_test.py`), o.a. Robs geval → "Take Snow Boots: +5 Armor over what you wear". Syntax OK,
  lint 0 HARD. ✅ GEMETEN Rob in het spel (screenshot): groen kader om Snow Boots + precies die zin; GearQuest wijst
  dezelfde aan. Dus op Forever werken GetNumQuestChoices/GetQuestItemLink/de knopnaam en het armor-lezen.

## 🛠️ 7 nov (middag) — trainer-venster alleen bij iets nieuws (Rob: "Ja, alleen nieuw")

- `ForeverTrainer.lua` OnLevel: het venster gaat vanzelf open alleen als er een spell van PRECIES dit level te leren is.
  Oude, nog niet geleerde spells: één chatregel *"nothing new, still N to learn (…)"*. Aanleiding: Robs screenshot, venster
  opnieuw op level 3 voor Track Beasts (level 1). Offline (scratch `trainer_level_test.py`, Dwarf Hunter): 2 en 3 alleen
  chat, 4 opent (2 nieuw, 3 in totaal).

## 🛠️ 7 nov (middag) — Forever: quest-beloning-hint (Rob: "doe de quest beloning tip maar ook")

- Nieuw: `Modules/ForeverQuestHint.lua` + `Modules/ForeverMainStats.lua` (beide TOC's + docs-kopie, alleen Forever).
  Bij QUEST_COMPLETE met ≥2 keuzes: per bruikbare (GetQuestItemInfo isUsable) draagbare beloning de main-stats vergeleken
  met wat je in dat slot draagt (bij ring/trinket/1H het zwakste slot), Stamina als tiebreak. Groen kader op de knop +
  één zin onder het questvenster; geen winst → wat het meest oplevert (geel kader). Klikt nooit iets. `/mh questhint
  on|off|check`. Ideeën uit GearQuest/Zygor, geen code.
- ✅ `ForeverMainStats.lua` gevuld uit `docs/forever/FOREVER_MAIN_STATS_2026-11-07.md` (mh-research): standaard
  solo-leveling per class; Ret Paladin / Enh Shaman / Hunter wisselen van volgorde zodra hun talent bekend is (`later`,
  via ForeverKnownSpell op naam; AFGELEID dat talents zo te vinden zijn). Weging 1 / 0,5 voor de 1e/2e stat is MH's eigen
  keuze (AFGELEID). GEMETEN: de client heeft geen primary stat (ChrSpecialization 70862). Offline 7/7 goed met de echte
  tabel (Hunter: +3 Agi wint van +4 Spirit; Warlock: Stamina één keer).
- GEMETEN offline (scratch `questhint_test.py`, echte Decide(), test-only statslijst): 5 gevallen goed (upgrade +3 Agility,
  niets beter → duurste, lege ringplek, data niet geladen → opnieuw proberen, geen lijst → duurste). Syntax OK, lint 0 HARD.
  AFGELEID: GetNumQuestChoices/GetQuestItemLink/GetQuestItemInfo/C_Item.GetItemStats en de knopnaam
  `QuestInfoRewardsFrameQuestInfoItem<n>` op Forever (Zygor gebruikt ze, dat is een kandidaat, geen bewijs).

## 🛠️ 7 nov (middag) — dock-knop + Serpent's Bite (Rob: "schoonheidsfoutje" / "Zet de serpent's bite tip maar naar 2")

- `DialogPopup.lua`: de "Dock to window"-knop was vast 88 px, smaller dan zijn tekst, en liep onder het kruisje (Robs
  screenshot, Forever How you play). Nu zo breed als de tekst (`FitDockButton`, ook na Undock) en rechts op -38. Geldt voor
  alle vensters via `RegisterMidnightDialogPopup` (retail + Forever). Niet in het spel gezien.
- Ula'tek `RAID_BOSS_ULATEK_STEPS`: Serpent's Bite markeert nu **twee** spelers in alle 8 packs (RaidTips 7× + ruRU),
  GEMETEN met grep (8/8). `check_drift --mark` gedaan. Bron: Wowhead-datamining (hotfix 6 nov), Blizzard noemt geen getal.

## 🧭 7 nov — Forever: pijl naar je trainer, stap 2 (Rob: "alle drie, en eigenlijk vind ik dat we gewoon die van handy notes moeten kunnen gebruiken !!")

- In `ForeverTrainer.lua`: knop **Take me to my trainer** in het venster, `/mh trainer go`, `/mh trainer here` (je eigen
  plek, per class, accountbreed in `ns.db.foreverTrainerSpots`), `/mh trainer forget`. Dichtstbijzijnde op je continent wint.
- Drie bronnen: (1) jouw plekken; (2) **HandyNotes_ClassTrainers tijdens het spelen**: MH leest
  `AceAddon:GetAddon("HandyNotes_ClassTrainers").points` en filtert zelf op class/kant (los van hun "Only my class").
  Niets gekopieerd: hun data is All Rights Reserved, MH vraagt alleen wat de speler al heeft; (3) `ns.FOREVER_TRAINER_SPOTS`
  (eigen Wowhead-lijst, mh-research loopt nog; bestand nog niet gemaakt).
- GEMETEN offline (scratch `trainer_arrow_test.py`, echte ForeverTrainer.lua + Robs echte HandyNotes Data.lua): Paladin
  Stormwind → Arthur the Faithful, Warlock Orgrimmar → Mirket, Shaman Ironforge → Eldrun Stormbreaker; eigen plek wint;
  zonder bron een uitleg. Gevonden en gerepareerd: `%d` met een kommagetal (afstand). Syntax OK, lint 0 HARD.
  AFGELEID: `GetWorldPosFromMapPos` + `GetPlayerMapPosition` op Forever, en dat de pijl daar tekent.
- 💡 Netste route naar "gewoon gebruiken": de maker (Frostaphim, CF) om toestemming vragen. Alleen Rob kan dat sturen.
- ✅ Bron 3 erbij: `Modules/ForeverTrainerSpots.lua` (beide TOC's + docs-kopie), GEGENEREERD (scratch
  `gen_trainer_spots.py`) uit `docs/forever/FOREVER_TRAINERS_2026-11-07.md` (mh-research: Wowhead Forever NPC-pagina's,
  Zygor-check, wago UiMap 70790): 218 class-trainers, pet/demon/portal eruit, Zephras Isle `both` → `N`. Controle tegen
  Robs HandyNotes (alleen ter vergelijking, niets overgenomen): 211 binnen 1 eenheid, 6 op 1-1,5 (lopende NPC's, AFGELEID),
  1 niet in HandyNotes. Offline: zonder HandyNotes kiest de eigen lijst dezelfde trainer (Paladin/Warlock/Shaman).
- ✅ GEMETEN Rob (screenshot, Dwarf Hunter level 2): venster opent vanzelf bij level-up, knop + HandyNotes-trainer
  (Thorgas Grimson, 237 yards), *"en de pijl komt :)"*. ✅ Daarna (Rob: *"Ja, pas aan"*): spells uit de `listed`-lijst
  van de class-tabel (Track Beasts) zeggen nu *"not on the block (on purpose)"*; "put it on your own bar" alleen nog bij
  spells die in geen enkele lijst staan. Offline nagebootst met Robs geval (Dwarf Hunter level 2).
- ✅ GEMETEN Rob: met HandyNotes UIT komt de pijl ook (MH list, "Thorgas Grimson (trainer) 141 yd"). Rob: *"wil je hem op
  meters zetten"* → de instelling bestond al (`mh_arrowMeters`, "Route-afstand in meters", standaard uit); de teksten van
  ForeverTrainer.lua volgen hem nu ook (`Distance()`, ×0,9144 zoals NativeArrow). Offline: 367 yd → 336 meters.

## 🔎 7 nov — Leatrix Maps, OpenMap, GearQuest bekeken (mh-research, alleen lezen)

- Verslagen: `docs/forever/REVIEW_LEATRIX_MAPS_2026-11-07.md`, `REVIEW_OPENMAP_2026-11-07.md`, `REVIEW_GEARQUEST_2026-11-07.md`.
- Licenties (GEMETEN): Leatrix Maps All Rights Reserved (+ MapUtils GPLv3), GearQuest Forever All Rights Reserved,
  OpenMap MIT (code + eigen data; Blizzard-art uitgesloten). Questie's eigen LICENSE: "bij twijfel all rights reserved".
- ✅ Echte MH-fout, GEREPAREERD (Rob: *"Ja, repareer"*): `NativeArrow.lua` wiste aan het einde van een route de user
  waypoint zonder te kijken of hij nog van MH was. Nu: `RememberOurWaypoint` leest de speld terug direct na het zetten,
  `ClearOurWaypoint` wist alleen als hij er nog ligt (0,0005 marge); onleesbaar = oud gedrag (wissen), zodat de stale-pin
  van 7 sep niet terugkomt. `/mh arrow` toont de laatste beslissing. GEMETEN offline (scratch `arrow_pin_test.py`, echte
  NativeArrow.lua): A eigen route → gewist, B speler-speld → blijft; tegenproef op HEAD (`arrow_pin_old.py`): B gewist.
  Syntax OK, lint 0 HARD. Niet aangeraakt: de Silvermoon-pins (`_mhSmcPinsSet`, UI.lua) wissen nog onvoorwaardelijk.
  Test: TESTLIJST "7 nov — De route-pijl".
- Ideeën (niets gebouwd): quest-beloning-hint (GearQuest), `/mh trainer here` om trainer-plekken zelf te meten, pijl naar
  dungeon-ingangen/flight masters uit DB2 (OpenMap), `## LoadSavedVariablesFirst` voor `/mh lang` (Leatrix), `/mh map`
  zegt op Forever niets. Testen met één /run: `C_Map.GetMapLevels` op Forever.
- GEMETEN: OpenMap en GearQuestForever (+9 class-mappen) staan sinds 7 nov ~07:00 in `_forever_\Interface\AddOns`
  (niet door ons). Leatrix Maps niet.

## 🛠️ 7 nov — Forever: nieuw bij de trainer, stap A (Rob: "Ja, A + pijl")

- Nieuw: `Modules/ForeverTrainer.lua` + `Modules/ForeverTrainerData.lua` (beide TOC's + docs-kopie, alleen `ns.IS_FOREVER`).
  `/mh trainer` (venster), `/mh trainer check`, `/mh trainer auto on|off`; bij elke level-up een chatregel en, als er iets
  te leren is, het venster (pas na combat). Per spell: prijs + toets uit de `ForeverBlock_<Class>`-tabel, "block D",
  "passive" of "not on the block". Alleen Engels.
- Data GEGENEREERD (scratch `gen_trainer_data.py`) uit What's Training? (MIT, commit 0654674ef735, licentietekst in de
  kop): 1356 trainer-spells, Hunter-petskills eruit (45). Rang komt uit de client (rang 1 is vaak een start-spell).
- GEMETEN offline (scratch `trainer_test.py`, echte data + echte class-tabellen + ForeverBlock.lua, client nagebootst):
  7 gevallen kloppen (oneven level niets, Horde-mage geen Alliance-teleports, Druid "eerst Bear Form", alles bekend =
  leeg). Gevonden en gerepareerd: een vervangen rang (Seal of Righteousness 20154→21084) gaf vals "needs first".
  Syntax OK (322), lint 0 HARD. AFGELEID: `IsPlayerSpell`, `C_Spell.IsSpellPassive`, `GetSpellSubtext` op Forever.
- 🔜 Stap 2, de pijl: wacht op de trainer-plekken (mh-research, alleen Wowhead Forever; HandyNotes_ClassTrainers is
  All Rights Reserved, Questie GPLv3 → niet overnemen). Test: TESTLIJST "7 nov".

## 🔎 7 nov — What's Training? bekeken voor Forever (Rob: "bekijk het goed")

- Alleen onderzoek, niets geïnstalleerd of gebouwd: `docs/forever/WHATS_TRAINING_2026-11-07.md`. MIT (GEMETEN).
- GEMETEN: 1358/1359 spell-levels gelijk aan onze `FOREVER_<CLASS>`-onderzoeksbestanden (1 verschil = ras, geen fout).
- Ideeën voor Rob: A "nieuw bij de trainer" per level mét toets, B samenwerken via `WT_API`, D gewoon installeren.
  TOC: ons `_Camelot.toc`-plan houden. Rob kiest.

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
