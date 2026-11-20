# Midnight Helper — waar we staan

## ▶ 20 nov — drie testpunten goedgekeurd (Rob grieperig: één stap tegelijk)

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

## ✅ 18 nov (laat) — FABLE MAG WEER (ook op helpers)

Rob (via Sparring 18-11), letterlijk: *"Oke, ik heb de fable reset ingezet dus geen angst meer voor geen tokens 😇"* en
*"Fable mag en ik volg je advies"*. De regel hieronder (geen Fable t/m 21 nov) VERVALT. De werkwijze erachter (tweede,
onafhankelijke controle die de code krijgt en niet de conclusie; foutsoorten-checklist; lint als laatste) blijft.

## (vervallen 18 nov laat) 18 nov — GEEN FABLE deze week (t/m reset za 21 nov 10:00)

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
