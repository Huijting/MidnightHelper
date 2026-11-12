# Midnight Helper — waar we staan

## ▶ Open voor 12 nov (bouwchat 11-11 sloot af met /nieuwe-chat)

1. **Groepsmeting Forever:** Rob doet `/mh partytest` in een groep (2 is genoeg), vecht een paar keer, `/reload`. Lees
   `ns.db.partyProbe` in `E:\World of Warcraft\_forever_\WTF\Account\JOEYWHATEVER\SavedVariables\MidnightHelper.lua`
   (blok `fights`). Daarna: plan voor PartyTargets in Forever ("midden") aan Rob voorleggen, pas bouwen op zijn ja.
2. ✅ **Midnight testen:** "Used for" gezien door Rob (12 nov, via sparring). De gewone tooltip noemt het niet; een
   andere addon van Rob wel.
3. **Forever testen:** Purify-macro, Hammer of Justice zonder muis-vijand → target, grijze "Used for", Copper Ore.
4. **Rob vragen:** zijn de upgrade-melding en de groene gear-regel (door hem gezien in Forever) af?
5. Nog open sinds 5.1.0: buff-zin in Midnight en in gevecht, "(loading...)" in de beroepstip.
6. ✅ Beslist en gebouwd 12 nov (Rob: "Optie 1, jouw advies"): purge blijft, anders stop-spell. Zie de 12 nov-sectie.
7. Sinds 5.1.0 op main en niet uit: "Used for" (beide spellen), Paladin-macro's, `/mh partytest`, de stadsnaam-fix es.
   Een release alleen op Robs go. CF-plaatjes staan erop (Rob, 11 nov); of hij de nieuwe CF-beschrijving en de
   5.1.0-tekst al plakte: NIET GEMETEN, vragen.

## 🆕 12 nov — `/mh prompt test` + Robs Midnight-test deel 1 (Rob: "Ja, laat hem dat bouwen", via sparring)

- Aanleiding: `/mh prompt` is een aan/uit-schakelaar, dus Rob kon Shift+scroll niet testen. `ns.PreviewActionPrompt()`
  (ActionPrompt.lua) houdt het ECHTE frame met beide iconen 20 s in beeld (eigen interrupt/purge-icoon, anders vraagteken
  134400), ook als de hint uit staat; `Update()` laat ze zolang met rust; een gevecht stopt het voorbeeld meteen (geen
  apart pad, dezelfde frame/plek/maat). Core.lua: `/mh prompt test`. Nieuwe sleutels PROMPT_TEST_FMT/PROMPT_TEST_COMBAT,
  7 talen (de/fr/es/pt/it/ru eigen vertaling, niet native nagekeken). Lua OK, lint 0 HARD. Niet in het spel gezien.
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

## 🆕 10 nov (avond) — Forever: reisplanner voor de pijl (Rob: "uitzoeken en bouwen graag")

- Aanleiding: Rob in Darkshore, pijl naar Buliwyf (Ironforge) zei alleen "travel back first". `Modules/Travel/` laadt niet
  in Forever. Nieuw `Modules/ForeverTravel.lua` (beide TOC's, IS_FOREVER-guard): ns.BuildTravelPlan (zelfde vorm als
  Midnight) met 14 links uit `docs/forever/FOREVER_TRAVEL_LINKS_2026-11-10.md` (mh-research: DB2 TaxiPathNode 70888
  GEMETEN, x,y-omrekening AFGELEID, Wowhead-NPC's binnen 1 eenheid). Dijkstra over speler + link-uiteinden + doel; lopen
  = afstand/250 + 2 per zonewissel + 8 tussen Stormwind- en Ironforge-kant (dan wint de tram). Rut'theran = Teldrassil
  y ≥ 86 (AFGELEID). Weggelaten: directe boot Auberdine↔Menethil (vermoedelijk weg), Grom'gol↔Undercity, Feathermoon.
- NativeArrow: `ns.ForeverTravelNeedsLink` maakt Teldrassil/tram "unreachable" → plan; `step.forever` laat de pijl naar
  een haven in een andere zone op je eigen continent wijzen. Retail-pad onveranderd (beide hooks bestaan daar niet).
- ForeverWeapons "The way there": nu vanaf waar je staat (`ns.ForeverTravelSentence`), oude vaste teksten als terugval.
- `/mh travel` = diagnose (MH_UNLISTED_ON_PURPOSE). Teksten FTRAVEL_* enUS + nlNL; de/fr/es/pt/it/ru door mh-writer.
- Offline test (nep-wereld, scratchpad `ftravel_test.lua`): 13/13 routes goed. ⚠️ NIET in het spel getest; TESTLIJST 10 nov avond.
- Vertalingen (mh-writer, namen GEMETEN in Forever-DB2: Tiefenbahn/Tram des profondeurs/…; Rut'theran per taal; geen itIT —
  Forever heeft geen Italiaanse client). ruRU bewust zonder naamvallen ("корабль (куда: %s)").
- Bug Rob 10 nov: hengel-tip bleef op "(loading...)" — `ForeverVendors.lua` tekende de tip één keer; nu `RenderTip` ook op
  GET_ITEM_INFO_RECEIVED, en de chatregel wacht op de naam. Niet in het spel getest.
- ✅ Rob bevestigde in de bouwchat ("Ja, zo"): A) één ideeënlijst — elk verzoek, ook direct in de bouwchat, komt in
  IDEEEN.md in de vaste vorm (Ja → gebouwd met commit → Af na Robs test). Gedaan: de reisplanner staat onder Ja.
  ✅ Stap 4 (Rob: "Ja, stap 4"): `tools/data_check.py` (`run data_check [--c2|--c4] [--all] [--loose]`), lokaal/wachter,
  NIET in de GitHub-lint (heeft wago nodig; cache in %LOCALAPPDATA%). GEMETEN 10 nov:
  - C2: 1541 nummers (1070 spell, 341 quest, 71 kaart, 39 achievement, 25 item) tegen SpellName/QuestV2/UiMap/
    Achievement/Item van live 12.1.5.70783 + ptr 12.1.7.70740 + forever 1.60.1.70888 → **0 nakijken**. 4 bewuste
    nep-id's (DispelTest) op de IGNORE-lijst. Blinde vlek: 23 regels. Proef: 6603 + 947 gevonden, 99999999 niet.
    Eigen fouten onderweg: proef-kaart 1415 bestaat alleen in Forever; `--[[ ]]`-commentaar werd meegelezen.
  - C4: 121 enUS-waarden zijn precies een spelnaam (Area/Map/Achievement, spells alleen met 2+ woorden); per taal
    vergeleken met wat die client toont, fill()-overschrijving gevolgd zoals in het spel. **65 nakijken**, gemengd:
    echt (bv. "Titel: Light's Faithful" in alle 6; ruRU RITUAL_CHAL_* en CODEX_CUR_ACCOLADES nog Engels; itIT TAB_OMNIUM
    Engels; de "Das Labyrinth"/"Der Ring" en pt-lidwoorden in MOUNTRUN_R_*) en toeval (General = NPC-rang, Test,
    Builder, zoekwoorden SMC_SEARCH_PORTALS, GUIDE_CONS_TYPE_HEALING). ▶ Rob kiest of we de echte laten herschrijven.
  ✅ Stap 5 (Rob: "Eerst stap 5"): twee cloud-routines, ID's ook in CLAUDE.md:
  - **MH nachtcontrole** `trig_01EKor6SCGxyPJPurc4MML3P`, dagelijks 04:15 Parijs, omgeving "Midnight Helper"
    (env_012F4L7VcAGercf6hQDYoFai, wago toegelaten), Sonnet 5.5, géén connectoren. C1 tegen een verse lijst in /tmp
    (event_snapshot `--out`, event_check `MH_EVENT_SNAPSHOT`) + C2; schrijft alleen `docs/NACHTCONTROLE.md`.
  - **MH ideeënbus** `trig_0168w6QPWBbUob5hYf5HXFWz`, zondag 08:00, Opus 5.5, alleen Exa; schrijft alleen het blok
    "Voorstellen van de wachter" onderaan IDEEEN.md (één-schrijver-regel); drie harde regels in de opdracht.
  - Proefrun nachtcontrole 10 nov 21:15 (cse_01AezjghAscP8AAd8atJJFGh), GEMETEN: **wago.tools werkt** in die omgeving
    (200), C2 schoon (zelfde 1541 als lokaal). **api.github.com geeft 403** → C1 "NIET GEDRAAID" (correct gemeld).
    ❌ Mijn eerste advies (domeinen toevoegen) was FOUT. GEMETEN in code.claude.com/docs/en/cloud-environments: beide
    domeinen staan al in "Trusted"; al het GitHub-verkeer gaat via de GitHub-poort, die API-aanvragen alleen doorlaat
    voor repo's die AAN DE SESSIE GEKOPPELD zijn ("GitHub access to … is not enabled for this session", 403).
    ✅ Opgelost (Rob: "Ja, koppel hem"): `Gethe/wow-ui-source` als tweede bron aan de routine, sparse checkout alleen
    `Interface/AddOns/Blizzard_APIDocumentationGenerated`. Tweede proefrun: cse_01AezjgmBywxYEbFVTpsUgQr.
    📌 Les: elke cloud-routine die een andere GitHub-repo leest, moet die repo als bron koppelen.
    ✅ GEMETEN in `docs/NACHTCONTROLE.md`: de tweede proefrun (10 nov) én de geplande run van 11 nov draaien C1 en C2
    allebei, controles OK, 0 nakijken; snapshot in de repo actueel.

### ▶ Open na 10 nov (volgorde voor de volgende bouwchat)
1. Robs test van de **Forever-reisplanner** + "(loading...)"-fix (TESTLIJST 10 nov avond); daarna IDEEEN.md-regel → Af.
2. ✅ 11 nov: **C4** 65 → 3 (zie boven). Nieuw open: de 3 delve-namen in een zin, en de oude namen in andere zinnen.
3. **Zygor-vergelijking**: Zygor werkte 10 nov 20:23 de MID-mounts en -achievements bij (geen oude kopie → diff onbekend).
   Voorstel stond open: een Zygor-wachter zoals handynotes_watch + onze schatten/mounts naast Zygor leggen. Rob koos nog niet.
4. Maandag: eerste **ideeënbus**-voorstellen (zondag 15 nov) verplaatsen naar Open/Nee.
5. Later: C5 (vensterregister) samen met `/mh selftest`; plan deel 4/6.
  - C5 later met /mh selftest. De 65 C4-namen wachten op Robs keuze.

## 💡 10 nov — brainstorm werkwijze (cloud-sessie, tak `claude/midnight-helpen-brainstorm-d18bs9`)

- PLAN (Rob: "werk het hele plan maar uit"), ✅ Rob 10 nov avond: "het klopt allemaal, volgorde is goed", zesde toetsvraag ja: `docs/PLAN_WERKWIJZE_2026-11-10.md`, 7 delen +
  bouwvolgorde (prikbord → controles → wachters → recepten → selftest → nep-spel). Alleen deel 1 is af. Eerste versie: Doel als toets (5 vragen), vaste vorm van
  een idee, één ideeënlijst, prikbord voor de site-chat. Volgorde (Rob: "Ja, die volgorde aanhouden"): 1) toets +
  ideeënvorm, 2) controles "bestaat het" / "klopt de data", 3) ideeën-wachter, 4) nep-spel + `/mh selftest`.
  Niets gebouwd. ⚠️ Dit bestand zit op 1434+ regels: splitsen vóór de volgende grote toevoeging.
- ▶ **Opdracht voor de bouwchat: `docs/OPDRACHT_BOUWCHAT_2026-11-10.md`** (Rob: ja). Stap 0 tak naar main, stap 1 prikbord
  `docs/SITE_SEIN.md`, stap 2 controles C3/C5/C1. Eén stap tegelijk, na elke stap Robs ja.
  - ✅ Stap 0 (Rob: "Ja, stap 0"): 45ea9ce, main = tak byte voor byte.
  - ✅ Stap 1 (Rob: "Ja, stap 1"): `docs/SITE_SEIN.md` gemaakt: 5.0.2 = *staat op CurseForge* (GEMETEN 10 nov, CF-API: beide
    zips Release 8 nov), 11 regels *alleen op main* voor alles sinds v5.0.2 (GEMETEN `git log v5.0.2..HEAD`; knoplabels en
    commando's opgezocht in enUS.lua en Core.lua). `RELEASE_CHECKLIST.md`: seintje = regel in SITE_SEIN. CLAUDE.md
    ochtendronde 4d: lees `midnighthelper-site\drafts\BOUW_VRAAG.md` (bestaat, GEMETEN: nog geen vragen).
  - ✅ Stap 2 (Rob: "Ja, stap 2"; brainstorm-chat las mee en vulde aan): lint [22] = C3, [23] = C1, GitHub draait ze
    (addon-lint.yml triggert nu ook op RELEASE_NOTES.md, SITE_SEIN.md en de snapshot). GEMETEN 10 nov: lint 0 HARD.
    - C3 `tools/release_text_check.py`: `/mh`-woorden in RELEASE_NOTES + SITE_SEIN tegen wat de code routeert (279
      woorden: Core + modules + CommandList), SITE_SEIN-sleutels tegen Locales = HARD; *cursief* label zonder Locales-tekst
      = SOFT; elk gevonden label wordt getoond mét sleutel en bestand. Positieve controle in elke run (nep-commando,
      -sleutel, -label). 🔴 De proef van 3 nov slaagt NIET als fout: "Skip" bestaat (TOUR_CM_SKIP, de rondleiding);
      `--selftest` toont "*Skip* -> TOUR_CM_SKIP (StartHere.lua)" — zichtbaar fout voor een lezer, niet voor de check.
    - C1 `tools/event_check.py` + `tools/event_snapshot.py` → `tools/blizzard_events_snapshot.json` (Gethe/wow-ui-source,
      GEMETEN: live 12.1.5.70783 1784 events, ptr 12.1.7.70740 1818, **forever 1.60.1.70888 1816** — Forever heeft een
      eigen tak). Retail-toc tegen live+ptr, Camelot-toc tegen forever; andere-spel-bestanden overgeslagen; pcall apart.
      Uitkomst: 100 + 45 events, 0 nakijken. Proef: LEARNED_SPELL_IN_TAB staat niet in de lijst, de scanner leest hem.
      Zegt hardop STALE bij >28 dagen of als de .toc een nieuwere Interface heeft. Verversen: `run event_snapshot --write`
      (met de hand; later de vijfde wachter).
    - C5 NIET gebouwd, alleen gemeten: [10] lijst→gerouteerd, [16] gerouteerd→lijst, [4] tab→zoekbalk, NavSearch indexeert
      MH_COMMANDS. Wat ontbreekt is een lijst van VENSTERS; een heuristiek (ns.Show*/Open*/Toggle*) gaf 51 treffers, vooral
      loos (toasts, hulpfuncties, commando's die in de module zelf routeren). ▶ Rob kiest: vensterregister bouwen of niet.
- Rob daarna: toets klopt; ideeënlijst ja; prikbord ja. Nieuw: `docs/IDEEEN.md` = de ENE ideeënlijst (20 open + 2 uit de
  vragenlijst + 6 half; 3 van de 5 vragenlijst-wensen bleken al gebouwd; wat sinds 8 okt gebouwd is staat onder "Af", vandaag GEMETEN in de code, niet in het spel).
  Nieuwe ideeën alleen nog daar. Rob moet per regel nog ja/nee/later zeggen. Site-kant staat in de privé site-repo.

## 🆕 10 nov (middag) — Midnight: Macro's-tabblad "Top" + knop Maken (Rob: "maak het maar, net zoals … Forever … minimaal net zo goed")

- Drie mh-research-runs (A: DK/DH/Druid/Evoker, B: Hunter/Mage/Monk/Paladin, C: Priest/Rogue/Shaman/Warlock/Warrior)
  telden per spec de macro's in Midnight-bronnen (Wowhead UI & Macros, Icy Veins, Method; okt 2026) → top 5 per spec,
  40 specs (DH Devourer meegeteld). Notities: `docs/MIDNIGHT_TOP_MACROS_2026-11-10_A/B/C.md`. Reddit niet bereikt.
- Nieuw `Modules/RetailTopMacros.lua` (alleen retail-TOC, na InterruptMacros): `TOP_MACROS` 183 rijen (spec 0 = elke
  spec van de klasse; `dkey` = gedeelde tekst voor tweelingen), spells als `{id}` → clientnaam; talent-rij verborgen tot
  gekend; niet gekend → "train"-melding. Nieuw soort "top" vooraan in `ns.MacroPanelTypes`; standaard geselecteerd.
  `InterruptMacros.lua`: knop **Maken** naast Alles selecteren (voor elk soort; CreateMacro per karakter, "MH+ <naam>",
  uit in gevecht en in de guide-preview). `/mh macrocheck` print ook de Top-rijen. Id's GEMETEN in wago retail
  12.1.5.70783. Offline-test: 40 specs × 5, geen rest-`{`, ≤255 bytes. Niets in de client getest → TESTLIJST.
- Gevonden macro-regels 12.0 (Blizzard, 1 mrt 2026): max 3 markeringen kort na elkaar; in een encounter geen macro-chat
  buiten de groep. Spelers (niet Blizzard): `[nochanneling]` kan casten even blokkeren → waarschuwing bij die rij.
- ✅ Daarna (Rob: "Ja zet om"): de oude Utility/Interrupt-lijsten krijgen nu de clientnamen. `ns.MH_LocalizeMacroBody`
  (RetailTopMacros.lua) ruilt elke bekende Engelse naam via `NAME_IDS` (84 namen → speler-spell-id, GEMETEN retail
  12.1.5.70783, deDE e.a. gelijk voor alle speler-ids per naam) op de plek van de naam (na de laatste `]`, castsequence-
  lijst, `channeling:`). Aangeroepen in `MH_GetMacroContextForType` (niet voor "top") en in `/mh macrocheck`. Offline:
  145/145 lichamen vertaald met nep-Duitse namen, 0 Engels over, Engels = ongewijzigd. Niet getest op een echte
  niet-Engelse client. Open: "/target Dundun" (World-soort) is een NPC-naam, nog Engels.

## 🆕 10 nov (middag) — Forever: top 3 macro's per spec (Rob: "Ja, laten we maar uitzoeken" → "Ja bouw maar")

- Onderzoek (mh-research): `docs/forever/FOREVER_MACROS_SPECS_2026-11-10.md` — 27 specs × top 3, 13 bronfamilies,
  plus spec-herkenning. Gebouwd in `Modules/ForeverMacros.lua`: `SPEC_MACROS` (81 rijen, geen dubbel met de klasse-5;
  vervangingen staan in de scratchpad-notes van 10 nov), `SPEC_NAMES` (boomnamen per client uit DB2 TalentTab; deDE
  "Verstärk"/"Wiederherst" voluit geschreven, AFGELEID), `SpecBand()`: C_ClassTalents.GetActiveConfigID → C_Traits,
  punten per PosX-band (<4000 / <8000 / rest), hoogste = spec, 0 of gelijk = geen. AFGELEID (Wow.exe heeft C_Traits en
  niet GetTalentTabInfo — GEMETEN; in het spel niet gedraaid). Tonen: talent-rij zodra het talent gekend is, gewone rij
  alleen bij jouw spec; jouw spec eerst. `/mh macros check` print de spec + punten. Events SPELLS_CHANGED +
  TRAIT_CONFIG_UPDATED (pcall). 76 teksten van classicwowforever.com (CC BY 4.0) → creditregel `FMAC_SPEC_CREDIT` in het
  venster; rankedboost (All Rights Reserved) alleen als keuze, nooit als tekst. Talent-`level` = max(spell-level, 10 +
  rijpunten): +10 AFGELEID. Offline-test met stubs: spec-band goed, geen rest-`{`. Niets in de client getest → TESTLIJST
  (eerst de /run-regel).

## 🆕 10 nov — Forever: top 5 klasse-macro's in "Handige macro's" (Rob: "Top 5" → "Ja. Mooi.")

- Rob wilde "de meest gebruikte macro's per klasse" (specs later). mh-research telde het onderzoek van 9 nov na in 12
  Forever-bronfamilies + forumposts van spelers (Reddit gaf 403): `docs/forever/FOREVER_MACROS_POPULAR_2026-11-10.md`.
  Score = bronnen + shortlists + spelers (formule AFGELEID, tellingen GEMETEN). Mount-macro: maar 2/12, niemand vroeg erom.
- Gebouwd in `Modules/ForeverMacros.lua`: `CLASS_MACROS` (45 rijen, 5 per klasse), blok "Voor jouw klasse" onder de
  algemene rijen. Spells alleen als `{id}` / `{id:rank}` → `FillTpl` zet de clientnaam erin (alle talen). `need` niet
  gekend → grijs (level of "leer eerst"); `talent` (Holy Shock 1311606, Penance 402174) verborgen tot gekend; `tplShort`
  voor Taunt/Healing Touch (ruRU 258 bytes). Waarschuwingen `twopress` (warrior stance) en `formbar` (druid D2), beide
  uit forumposts. Id's GEMETEN in wago Forever 1.60.1.70862 (mh-research, bewijs in de scratchpad-notes van 10 nov).
  Bewust anders dan de bron: warlock demon-knop zonder `[pet:…]` (familienaam is vertaald), priest dispel ingekort.
  Offline-test (lua-stubs): 45/45 vullen zonder rest-`{`. Teksten enUS/nlNL zelf, de/fr/es/pt/ru mh-writer met
  spellnamen per taal uit de Forever-DB2. Niets in de client getest → TESTLIJST.
- Punt 2 van de lijst hieronder is hiermee gedaan (behalve de mount-macro: bewust niet, te weinig vraag).

## 🆕 10 nov — `tools/gamedata.py` (Rob: "Ja, bouw het") + onderzoek wapentrainers Forever

- Nieuw werktuig, via de voordeur: `run gamedata db2 <Tabel> [filters] --game forever`, `run gamedata npc <id> --game
  forever`, `run gamedata builds`, `run gamedata help`. wago.tools DB2-CSV + Wowhead-tooltip-JSON, ~0,2 s, cache in
  `%LOCALAPPDATA%\MidnightHelper\gamedata_cache`. GETEST 10 nov: npc 11865/11866 (zone + coördinaten), een onbekend id
  (404 netjes gemeld), `SkillRaceClassInfo SkillID=54,160` (13 rijen). CLAUDE.md-sectie + mh-research-agent bijgewerkt.
- Rob vroeg (Forever, Night Elf Druid lvl 10): waar leer ik maces? Antwoord: niet in Darnassus (Ilyenia Moonfire:
  staves/bows/daggers/thrown/fist), wel Buliwyf Stonehand, Ironforge ~61,89, 10 zilver. GEMETEN in de Forever-DB2:
  SkillRaceClassInfo rij 643 (Maces, druid, Night Elf) Availability 0 = niet vanaf het begin; rij 644 (Tauren) = 1.
- Rob: *"dit is trouwens ook weer zoiets voor onze guide … werk dat … uit"*. Onderzoek klaar (mh-research):
  `docs/forever/FOREVER_WEAPON_MASTERS_2026-11-10.md` — 8 wapentrainers, 14 wapen-skills met spell-id's, kosten/levels,
  klasse×wapen, Forever-wijzigingen, routes. 7 open gaten staan onderaan dat bestand (o.a. Sayoc + Staves).
  ✅ Gebouwd (plan → Rob: "Ja, bouw maar"): `Modules/ForeverWeapons.lua` (beide TOC's, na ForeverVendors). `/mh weapons
  [check]` (Core.lua). Venster "Wapentrainers": links de 14 wapens gefilterd op je klasse (bitmasks uit Forever
  SkillRaceClassInfo), "(ken je)" via IsPlayerSpell(spell-id) — AFGELEID, eerste test; rechts de 8 weapon masters aan
  jouw kant + afstand + Pijl (lastTarget via "/mh weapons", weg bij TRAINER_SHOW van díe npc, kruis via
  ForeverTrainerMark) + route-zin per stad (FWEAP_ROUTE_<stad>_FAR/_NEAR, uit de Zygor-transitdata in het onderzoek).
  Sayoc zonder Staves (betwist). Meten: TRAINER_SHOW bij een van de 8 → `MidnightHelperDB.foreverWeaponSeen[npc]`
  (rijen + filterstand). Ingangen: Ik-kamer `me_fweapons`, Tools → Losse vensters, startpagina-regel
  `FWEAP_HOME_FMT` (alleen als er iets te leren is). Plaatsen GEMETEN 10 nov met `run gamedata npc`; Sayoc en Hanashi
  staan echt samen (81,4-81,6 / 19,4-19,6). Teksten enUS/nlNL zelf, de/fr/es/pt/ru mh-writer met plaatsnamen uit
  AreaTable per taal. Lint/syntax OK; niet in de client getest → TESTLIJST.

## 🆕 10 nov — Forever: tegels voor "Handige macro's" en "Waar koop ik dit?" (Rob: "Ja, bouw maar")

- Punt 1 van de lijst hieronder is gebouwd. Twee tegels in de **Ik-kamer** (`RoomLauncher.lua` ME_FOREVER_CARDS,
  `me_fmacros` + `me_fvendors`, alleen als `ns.ShowForeverMacros`/`ns.ShowForeverVendors` geladen zijn) en twee
  kaarten in **Tools → Losse vensters** (`ToolsLaunchpad.lua`, `foreverOnly`). Retail verandert niet. Nieuwe keys
  `TOOLLP_FMAC_DESC` / `TOOLLP_FVEND_DESC`: enUS + nlNL zelf, de/fr/es/pt/ru door mh-writer (niet native nagekeken).
  Iconen `INV_Misc_Note_01` / `INV_Misc_Coin_01` (AFGELEID dat Forever ze heeft: vanilla-iconen). Niet in de client getest.
- Ochtendronde 10 nov: niets voor Rob. Wachters alle vier gedraaid, 0 [MOET GEFIKST]; CF/GitHub 0 open; geen site-mail;
  HandyNotes 170 ongewijzigd. Site-chat heet «Site chat 10-11», wacht op een sein bij de volgende release.

## ▶ Open na 9 nov (voor de bouwchat van 10 nov)

Alles van 9 nov is gepusht (laatste commit 0e16b14). Niets is gereleased. GEMETEN in het spel door Rob: retail laadt
MH (TOC-regel Talebound), Forever `/mh week` (reset wo ~05:00 servertijd) en `/mh ranks`, en de Attack-macro (melee).
Rest = alleen offline/linter getest → bovenaan `docs/TESTLIJST.md`.
1. ✅ 10 nov gebouwd (zie boven): TEGEL voor "Handige macro's" (`/mh macros`) én "Waar koop ik dit?" (`/mh vendor`).
   Wacht op Robs test.
2. ✅ 10 nov gebouwd (zie boven): top 5 macro's per klasse. Mount-macro niet (2/12 bronnen). Later: per spec.
3. Robs tests na `/reload` in Forever: Heal-macro (`/use item:<id>` werkt?), hengel-waarschuwing, trainerpijl, weapon
   buff + hengel, mouseover, winkels + tip na beroep leren.
4. Winkels: Redridge-frame (~5 verschil Wowhead/Zygor) en 3 EPL-rijen (`unsure`) nameten in het spel.
5. Later: Forever supplies-waarschuwing, writ-helper, Omnium Folio 6/7; site-chat seinen na de volgende release.

## 🆕 9 nov (laat) — Forever: trainerpijl stopt alleen nog bij de goede trainer (Rob: "Ja, ga je gang")

- Rob: op weg naar de leatherworking-trainer leerde hij vissen bij een andere trainer → pijl weg. Oorzaak (GEMETEN):
  `ForeverTrainer.lua` beëindigde de route bij élke `TRAINER_SHOW`. Nu `IsRouteTrainer(lt)`: npc-id van unit "npc" ==
  `lt.trainerNpc`, anders naam == `lt.trainerName`, anders binnen 15 yd van het doel; niets te meten → oude gedrag.
  `ForeverTrainerGoTo` zet die twee velden in `ns.lastTarget`. Kruisje (mark) blijft ook staan bij een andere trainer.
  Lint 0 HARD, syntax OK; niet getest in de client.
- Shaman weapon buff (Rob, screenshot "WEAPON BUFF" met de Fishing Pole in de hand): `ForeverBuffs.lua` Evaluate kijkt
  nu eerst naar slot 16 — hengel (item class 2, subclass 20 = `Enum.ItemWeaponSubclass.Fishingpole`, AFGELEID dat
  Forever die nummers houdt) of geen wapen → geen melding. MissingBuff ververst al op PLAYER_EQUIPMENT_CHANGED.
- Macro-plan stap 3 + 4 (Rob: "Gaan we door zolang je kan en dan beoordelen we samen straks wel"):
  - Stap 4 `ForeverBlock.lua`: `ns.db.foreverMouseover` (standaard uit), `/mh mouseover [on|off]`. Spells uit
    `MO_HELP`/`MO_HARM` (Engelse tabelnamen) krijgen `[@mouseover,help|harm,nodead(,guard)][guard]` vóór hun clause.
    Body() bouwt een key zonder mouseover als hij > 255 tekens wordt. Offline getest (scratch `test_mouseover.lua`).
    `[]` (lege voorwaarde) = AFGELEID geldig in Forever.
  - Stap 3 nieuw `Modules/ForeverMacros.lua` (beide TOC's): venster "Handige macro's", `/mh macros [check]` op Forever
    (retail valt door naar het Macros-tabblad). Rijen: Heal (beste stone/potion die je draagt, Shift = potion), Verband
    (beste, mouseover/self), Attack, Focus, Skull (`/tm … 8`, zonder "!"), Trinkets, + elke actieve racial die je kent
    (spell-id → clientnaam). Items als `item:<id>` (AFGELEID dat Forever dat slikt — eerste test!). Heal/Verband worden
    herschreven op BAG_UPDATE_DELAYED/PLAYER_REGEN_ENABLED. Karaktermacro's "MH+ …" (max 16 tekens). Offline getest.
  - Attack per klasse (Rob testte: target ok, `/startattack` sloeg met het wapen, hij verwachtte afstand → "ja doe
    maar"): Hunter `/cast !<75>` (Auto Shot), Mage/Priest/Warlock met wand in slot 18 (subclass 19) `/cast !<5019>`
    (Shoot), anders `/startattack`; `auto` (herschreven bij tassen/uitrusting). esMX-regel voor "Disparo automático".
    Offline getest (scratch `test_attack.lua`, 4 gevallen).
  - 🔜 MORGEN (Rob: "dan gaan we er morgen mee verder"): 1) een TEGEL voor Handige macro's in de addon (nu alleen
    `/mh macros`); 2) betere macro's per klasse kiezen uit `docs/forever/FOREVER_MACROS_2026-11-09_B/C.md` (8 per klasse),
    samen met Rob. Ook nog: mount-macro.
- Hengel-waarschuwing (Rob: "Ja, dit klopt zo" + "een mace en een shield, dat hij dat ook onthoudt"):
  `ForeverWarnings.lua` deel 3. Hengel in slot 16 + vijand targeten (PLAYER_TARGET_CHANGED) of gevecht begint
  (PLAYER_REGEN_DISABLED) → FireAccessibleAlert + chatregel "Zet terug: <links>". 1× per vijand, 30 s ertussen.
  Slot 16 + 17 onthouden per character in `ns.db.foreverPoleGear[naam-realm]`, 0,5 s na PLAYER_EQUIPMENT_CHANGED,
  nooit terwijl de hengel in de hand is. MH wisselt zelf niets. `/mh pole [on|off]` (Core.lua). 5 FWARN_POLE_*-keys,
  de/fr/es/pt/ru door mh-writer (hengelwoord GEMETEN: wago ItemSubClass 2/20, wowf 70862; geen it), drift gemarkeerd.
- Macro-onderzoek Forever klaar (3× mh-research, zonder onze oude macro's) → `docs/forever/FOREVER_MACROS_2026-11-09_A/B/C.md`.
  Rob: "Plan maken voor MH" → plan (1 bewaren, 2 per klasse naast de bloktabellen leggen "zit al / nieuw", Druid eerst,
  3 lijst "Handige macro's" met knop "Maak deze macro", 4 mouseover-schakelaar in het toetsenblok, standaard uit).
  Rob: "Ja, je mag met stap 1 en stap 2 beginnen." Stap 2 (Druid): het blok heeft bijna alles al; nieuw = mouseover +
  losse handige macro's. Stap 3 en 4 daarna gebouwd op "Gaan we door zolang je kan" (zie hierboven).
- ✅ Winkeliers vindbaar (Rob: "Yeah, je mag zo beginnen" + "Gaan we door zolang je kan"): onderzoek
  `docs/forever/FOREVER_VENDORS_2026-11-09.md` (mh-research, Wowhead Forever; 303 gereedschap- + 118 goods-rijen).
  Data `Modules/ForeverVendorSpots.lua`, venster `Modules/ForeverVendors.lua` (beide TOC's): `/mh vendor [soort|check]`,
  9 soorten, verkopers aan jouw kant op afstand, knop Pijl (Blizzard-waypoint + NativeArrow, via "/mh vendor"; weg op
  5 yd of bij MERCHANT_SHOW van DIE npc). Tip-venster na SKILL_LINES_CHANGED als Fishing/Mining/Skinning/Blacksmithing
  nieuw is en je geen gereedschap draagt (beroepen bij inloggen worden alleen genoteerd, `ns.db.foreverToolTipSeen`).
  `unsure` (3× EPL) en rijen zonder plek worden overgeslagen. Engelse bijtitels alleen op een Engelse client. FVEND_*
  in 7 talen (bijtitels GEMETEN op retail-Wowhead per taal; Forever-DB2 heeft ze niet). Offline getest. Open: Redridge-
  frame (~5 verschil Wowhead/Zygor), EPL-rijen, en een ingang buiten `/mh vendor` (tegel/knop — samen met de macro-tegel).

## 🆕 9 nov (avond) — Midnight: 20 Zo speel je-kaarten bijgewerkt, MH laadt niet in Talebound, 2 Codex-artikelen voor 12.1.7 (Rob: "begin maar met 1 en als die klaar is, dan ga dan maar door")

- **Kaarten-audit** (4× mh-research, 40 specs tegen Icy Veins + Method + Wowhead, gidsen 12-30 okt; rapporten in de
  scratchpad van sessie 1e43412f: `cards_A..D.md`, en `cards_apply.json`). mh-writer legde elk voorstel naast de audit van
  21 okt (`side-session-notes/local_8d0c4609…/playcard_audit/`). Bijgewerkt: 26 keys in 20 specs (70, 66, 62, 102 AOE, 103,
  104, 252, 253, 254, 256, 257, 259, 260, 263, 266, 268, 270, 581, 1467, 1468), alle talen + esMX; `source` + `why.checked`
  2026-11-09; quizAnswer bijgezet (104, 254, 256, 257, 260, 266) zodat de quizantwoorden gelijk blijven.
  - Bewust NIET: 261 HERO1 (6 vs 5 punten: 21 okt bewust 5, Darkest Night werkt vanaf 5); 102 HERO1 (Fury of Elune vóór of
    ín Eclipse: gidsen oneens, 21 okt "niet fout"); OPTIONAL-punten.
  - ✅ BESLIST 9 nov (Rob: "A"): Balance 102 houdt {SPELL:1233346} = "Solar Eclipse" (wago 12.1.5.70783) in IDEA/S3/
    W2/W3/TERMS, zodat de live-toets blijft. Bekend nadeel: Elune's Chosen ziet alleen Lunar Eclipse. Niet terugdraaien
    naar 1239669 ("Eclipse", passief) zonder Robs ja.
  - Plain-text namen zonder vastgesteld id (Divine Arbiter, Vanguard, Apex Predator's Craving, Forbidden Knowledge,
    Necrotic Coil, Cobra Fang, Benediction, Primordial Storm) staan in alle talen Engels. Nieuwe ids: gemeten door de
    auditors in wago/Wowhead, niet in de client.
- **Talebound (12.1.7)**: `MidnightHelper.toc` kreeg `## AllowLoadGameType: standard`, net als DBM-Midnight (GEMETEN in
  zijn TOC). MH laadt dan niet in Talebound (spelsoort "wowhack"); Forever leest `MidnightHelper_Camelot.toc` en merkt
  er niets van. ✅ GETEST 9 nov (Rob): retail laadt MH gewoon, geen foutmelding; Forever ook.
- **Codex 12.1.7** (verborgen tot interface 120107, `MidnightCodexData.lua`): `timeways6` (weekly) en `lorewalking`
  (world), uit Blizzards overzicht/dev notes van 15 okt. Op patchdag hercontroleren; dungeon-pool nog onbekend.

## 🆕 9 nov (middag) — Forever "Deze week in Forever" + Midnight Turbulent Timeways VI (Rob: "Ja, ik volg jouw adviezen … ga voorlopig door zolang je kan")

- Rob vroeg: wat is er elke week in Forever, en wat missen Forever-spelers? Ook: Midnight niet vergeten. Onderzoek
  mh-research 9 nov (bronnen + datums in de chat van 9 nov): Forever-raids resetten wekelijks vanaf 9 dec (Blizzard 20 okt;
  dag/uur niet gepubliceerd), PvP-rank heeft een weekcap + Call to Arms (Blizzard 7 okt), Darkmoon Faire 1 week/maand,
  vistoernooi zondag (fan), writs 1×/dag per writ. Resettijd Forever: NIET gepubliceerd → in de client meten (`/mh week`).
  ✅ GEMETEN 9 nov 17:47 servertijd (Rob, `/mh week`): weekreset over 126825 s, dagreset over 40425 s → allebei rond
  05:00 servertijd; week = woensdag 11 nov. Kalender gaf 2 events: Darkmoon Faire (HOLIDAY id 263, START) en
  "Call to Arms: Arathi Basin" (HOLIDAY id 1841, ONGOING). Raid lockouts 0. `/mh ranks`: 6 spell-knoppen, 2 met
  bekende ranks, 0 te laag (auto uit) — werkt, nog niets om te vervangen. Nog open: woensdag tellen na de reset.
- Nieuw `Modules/ForeverWeek.lua` (beide TOC's, `IS_FOREVER`-guard): blok "This week in Forever" op de Forever-startpagina
  (HomeDashboard, sectie `fweek`): week-/dagreset (C_DateAndTime), feestdagen van vandaag uit de spelkalender (titel +
  eerste zin van Blizzards eigen beschrijving, dus in de taal van de client), raid-lockouts (GetSavedInstanceInfo; vóór
  9 dec één regel "raids open 9 Dec"), twee vaste regels (PvP-rankcap, writs). `/mh week` print de ruwe antwoorden en
  bewaart ze in `MidnightHelperDB.foreverWeekDump`. AFGELEID: dat deze API's in Forever antwoorden (kandidaat: Zygor
  Forever gebruikt ze allemaal). Kaart "home" in de Ik-kamer toont nu "Reset over …".
- Naamfix: in Forever heet de tab/kaart "home" nu `TAB_HOME_FOREVER` = "Forever" (UI.lua; was "Deze week").
- Midnight: `MountProgress.lua` entry `timeways6` (achievement 64207, item 287513 Markeet of the Infinite, PTR-data 16 okt).
  Verborgen tot de client 64207 kent; `need` uit het criterium (blog 4 weken, PTR 5). `MOUNTPROG_TIMEWAYS6_HOWTO` in 8 talen.
- Omnium Folio 6/7 NIET gedaan: rijen/runekeuze onbekend (Rune of Critical Mass 13× in SpellName). Wacht op meting op de PTR/live.
- Vertalingen de/fr/es/pt/ru (mh-writer, niet native): rangwoorden (Rang/rang/rango/patente/звание) en lockout-woorden
  niet tegen de client gemeten; fr/ru zetten Honor tussen haakjes ("bonus (%s)").
- ✅ Idee 2 gebouwd (zelfde dag): `Modules/ForeverRanks.lua` (beide TOC's, na ForeverTrainAll). Knoppen met een lagere
  rank dan je kent, via onze eigen rank-lijst `ns.FOREVER_SPELL_IDS` (niet GetSpellSubtext: die geeft in Forever vaak "",
  volgens een MagePlan-commentaar). "Net getraind" = de rank op de knop was tot net je hoogste (hoogste rank per spell per
  character in `ns.db.foreverRanks.top`). Standaard: knop "Update bars (N)" onder het trainervenster + één chatregel;
  `/mh ranks auto on` doet het zelf; `/mh ranks fix` alles (ook bewust lagere); `/mh ranks` = diagnose (+
  `C_ActionBar.IsHighestSpellRank`, nieuw in de launch-build volgens een API-dump). Startpagina: regel + knop als er knoppen
  met een lagere rank zijn, met de uitleg dat downranken expres kan zijn. Vervangen = PickupSpell + PlaceAction, buiten
  combat, lege cursor, teruggelezen.
  - Onderzoek mh-research 9 nov: Blizzard-notitie 2 nov (Kaivax, forum 2360696/9) "no longer … automatically added to your
    action bars"; beta: oude rank bleef staan (Wowhead 22 sep, WoWForeverBuilds 23 sep). ⚠️ OPEN na launch: misschien
    werkt het spel sommige knoppen zelf bij (rage/energy op de beta wel). Dan vindt de module niets; `/mh ranks` zegt het.
  - Licenties: Uprank Forever / Auto Spell Ranks / HighestRankCheck = All Rights Reserved; niets gekopieerd.

## 🆕 9 nov — Zo speel je-kaart Devourer DH: HERO1 (Void-Scarred) bijgewerkt voor 12.1.5 (Rob: "los ook de foute demon hunter zo speel je kaarten op")

- GEMETEN door mh-research (wago DB2 12.1.5.70783, positieve controle met 12.1.0.69933): Violent Transformation 452409
  reset nu Voidblade + Soul Immolation (niet meer The Hunt); Demonic Intensity 452415: Collapsing Star reset The Hunt.
  Override-aura's: 1245496 maakt Voidblade→Pierce the Veil en The Hunt→Predator's Wake (1259431); 1245523 Pierce→Reaper's Toll.
- GEMETEN in de gidsen (Icy Veins 12 okt, Method 18 okt, Wowhead 22 okt): The Hunt blijft vlak vóór Meta (nu om
  "smuggling", niet de reset); Pierce the Veil + Predator's Wake vóór elke Collapsing Star; alle drie kiezen Annihilator.
- Nieuwe HERO1 in enUS/nlNL (zelf) en de/fr/es/pt/it/ru (mh-writer, niet native nagekeken). "light up" is weg: niet
  gemeten. Het 12-okt-voorstel (`docs/PATCH_12_1_5_CARDS_2026-10-12.md` 4c) was half fout: liet The Hunt vóór Meta weg.
- `PlayCards.lua` [1480]: `why.interface` 120100 → 120105 (W-regels en TERMS nu weer zichtbaar op 12.1.5; AFGELEID dat
  ze kloppen, zie dat document 4d), `checked` 2026-11-09, `source` = nieuwe gidsdatums. Niet in de client getest.
- Site: de Devourer-pagina op midnighthelper.com draagt nog de oude HERO1 → meenemen bij het volgende seinen van de site-chat.

## 🆕 9 nov — Forever: GUID-lezen in ForeverTrainer.lua robuust gemaakt (Rob: "Ja, repareer")

- Aanleiding: API-wachter 9 nov ([MOET GEFIKST]). `ForeverTrainer.lua` (`/mh trainer here` en `NpcOfUnit` voor het kruis)
  las de creature-GUID met `%d+` op de velden 2-5. Forever 1.60.1 (build ≥70425) vervangt server-/spawn-id door
  waarden van onbeschreven vorm. Zijn dat geen cijfers, dan gaf het patroon stil `nil`.
- Nu `[^%-]+` op de velden 2-5, het laatste `(%d+)` blijft; hetzelfde patroon als `SpotLog.lua:246`. GEMETEN: dit waren
  de laatste twee `%d+%-%d+%-%d+%-%d+`-lezers in `Modules/`. Syntax OK, lint 0 HARD. Niet in de client getest.
- AFGELEID, niet gemeten: of Forever de obfuscatie nu al heeft. `/dump UnitGUID("target")` in Forever laat het zien.
- Ochtendronde 9 nov, ter info: Serpent's Bite-hotfix (Ula'tek-tip "two players" mogelijk achterhaald, in de raid
  tellen) en PLAYCARD_1480_HERO1 (Devourer DH, sinds 12.1.5 verouderd) staan in `docs/CONTENT_WATCH.md`; niets aangeraakt.

## 🆕 8 nov (laat) — Forever: Me-kamer kaarten (Rob: "net zo een mooi layout voor tab me ... als ... tools" → "Ja, zo bouwen") + BugSack-fix

- 🐛 GEMETEN (Robs BugSack): `ForeverTrainer.lua:939 attempt to concatenate local 'prof' (a table value)`. De
  startpagina-knop gaf `ns.ForeverTrainerGo` direct als OnClick, dus `prof` = de Button (sinds de beroeps-parameter).
  Fix: Go negeert alles wat geen string is; HomeDashboard wikkelt de call in. Niet Moonglade (Rob vroeg het).
- `Modules/RoomLauncher.lua`: `ME_FOREVER_CARDS` (alleen IS_FOREVER, alleen als de open-functie geladen is): trainer,
  beroepstrainers, How you play, toetsenblok, Keys, Nameplate colours (met MF). Kaarten kunnen nu een game-`icon` hebben.
  Status `S.me_ftrainer`. Gevolg: Me heeft ≥2 kaarten, dus Forever opent nu op het kaartenrooster (net als retail) i.p.v.
  direct op Home. Iconen Trade_Alchemy/INV_Misc_Key_03/INV_Misc_Spyglass_02 komen voor in Forever-addons (kandidaat,
  niet in de client gezien). 3 nieuwe keys in en/nl/ru/de/fr/es/pt. Niet in de client getest.

## 🆕 8 nov (avond) — Forever: venster "Profession trainers" (Rob: "maak een pagina in de MH om ze te vinden" → "Ja, zo bouwen")

- Rob GEMETEN in het spel: `/mh trainer alchemy` vond een alchemietrainer. `/mh trainer check` heeft hij NIET gedraaid,
  dus de skill-line-nummers zijn nog AFGELEID.
- `Modules/ForeverProfTrainers.lua` (beide TOC's, na ForeverTrainer.lua): links 12 beroepen (eigen eerst, goud, skill),
  rechts alle trainers van jouw kant met afstand, zone (`C_Map.GetMapInfo`), "up to skill", Arrow-knop per trainer.
  Te lage trainers blijven grijs staan. Open via `/mh trainers [beroep]` (Core.lua), knop op de Forever-startpagina,
  Tools-kaart. Shift+scroll/Escape via RegisterMidnightDialogPopup.
- ForeverTrainer.lua: `Candidates(token, prof, all)`, nieuw `ns.ForeverProfTrainerList(prof)` en
  `ns.ForeverTrainerGoTo(c, dist, n, prof)` (Go roept die nu aan). 13 FPROF_*-keys + TOOLLP_FPROF_DESC in
  en/nl/ru/de/fr/es/pt (it niet: Forever-regel).
- GEMETEN offline: de datafile laadt in Lua, 314 rijen, 290 bruikbaar voor de pijl. Het venster zelf is niet in de
  client getest.

## 🆕 8 nov — Forever: pijl naar een beroepstrainer (Rob: "Ja, zo bouwen")

- `/mh trainer <beroep>` (key, Engelse naam of clientnaam), `here <beroep>`, `forget <beroep>`; 12 knoppen onderaan het
  trainervenster (eigen beroepen eerst, goud) met tooltip. Code in `Modules/ForeverTrainer.lua` (PROFS-blok,
  Candidates-tak `prof`, NeedRank: 25 onder je cap → trainer met max ≥ cap+75; AFGELEID uit Classic).
- Data: `Modules/ForeverProfTrainerSpots.lua`, 314 rijen van Wowhead Forever (mh-research, 8 nov, 375 fetches).
  Methode + Zygor-vergelijking + open rijen: `docs/forever/FOREVER_PROF_TRAINERS_2026-11-08.md`. `max` komt uit de
  Teaches-tab, nooit uit de tag (de tag loopt één rang vóór). De pijl slaat 23 rijen zonder max en Annora (geen plek)
  over. Steekproef GEMETEN door mij: Rogvar en Kylanna Windwhisper ≈ Zygor.
- AFGELEID / open: skill-line-nummers (uit Zygor; `/mh trainer check` print ze uit de client), het level-vereiste
  10/20/35 (alleen gidsen), neutrale NPC's als bruikbaar geteld, Redridge-frame (4 rijen), Cooking/First Aid/Fishing
  boven 150 (geen trainer op Wowhead). Niets hiervan in de client getest; zie TESTLIJST.
- `locale_probe` niet gedraaid (geen .py-voordeur); lint [1] 0 ontbrekende keys, syntax OK.

## 🆕 8 nov — RELEASE 5.0.2 (Rob: "Ja, breng versie 5.0.2 maar uit ... Jullie krijgen overal akkoord voor tot het er
## compleet op staat. Inclusief het plaatsen van de site.")

- Tag `v5.0.2` op `18e5787`. GEMETEN: run 42480965275 = success, alle stappen (Retail, Forever, GitHub-verify met beide
  zips). ✅ CurseForge GEMETEN (Robs screenshot 13:54): v5.0.2 (Retail, 12.1.7 +3) en v5.0.2-forever (1.60.1), beide R.
- Notitie: `docs/CURSEFORGE_5.0.2.md` = `RELEASE_NOTES.md`. In-game CHANGELOG_502_1..10. Forever-startpagina-lijstje
  bijgewerkt (7 talen). `CURSEFORGE_DESCRIPTION.md` bijgewerkt: **Rob plakt hem opnieuw op CF** (Description-tab).
- Site-chat geseind (via het bridge-adres waarvan hun bericht kwam; de naam "Site chat 08-11" gaf een identiteitswaarschuwing
  en is NIET gebruikt). Zij doen nightly, /forever/, strip en banner.
- GEMETEN 8 nov: v5.0.1-forever had 9 downloads (= Robs "9 mensen").

## 🆕 8 nov — Forever beter laten zien op CurseForge (Rob: "Ja, ik volg jouw voorstel" = optie A)

- `CURSEFORGE_DESCRIPTION.md`: opening noemt nu beide spellen; Forever-blok "Playing WoW Forever? This is for you too"
  staat bovenaan; alleen uitgebrachte functies (5.0.0/5.0.1). ✅ Rob plakte summary + beschrijving (8 nov); GEMETEN
  op de live CF-pagina (browser). Galerij (18 plaatjes) heeft nog geen Forever-screenshot: idee voor Rob.
- CF-naam NIET aanpassen (CF's eigen regel: geen spelnaam in de titel, GEMETEN op Robs screenshot); alleen de
  Summary (Engels, max 256). "Quests & Leveling" stond er al. Voorstel summary + meetplan (rond 22 nov Forever-gebruikers vergelijken met de 9 van 8 nov; geen
  groei → optie B, tweede CF-pagina met dezelfde code): `docs/forever/CF_PAGE_FOREVER_2026-11-08.md`.
- Site-chat gevraagd (Forever-blok/-pagina + banner met "WoW Forever"); bericht in de wachtrij, die sessie was offline.
- Bij 5.0.2: Forever-blok aanvullen met wat dan uitkomt (lijst in die notitie).
- In Midnight zelf (Rob: "zien we in midnight helper ook duidelijk dat we een andere versie ook hebben?" → "Ja, bouw
  maar"): GEMETEN dat Forever na het wegklikken van de 5.0-banner nergens meer te zien was. Nu onderaan de
  Midnight-startpagina een vaste grijze regel `HOME_FOREVER_ALSO` (alleen als de banner weg is); klik = banner met
  installatie-uitleg terug. 8 talen. Niet in de client getest.
- Gezien, niet aangeraakt: de Forever-startpagina zegt nog "an early test version" (`HOME_FOREVER_BODY`) met een
  verouderd lijstje. Bijwerken bij 5.0.2.

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
