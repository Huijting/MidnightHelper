# Prikbord voor de site-chat (`docs/SITE_SEIN.md`)

**De bouwchat schrijft hier, de site-chat leest het bij elke start.** Nieuwste regel bovenaan. Eén schrijver: de site-chat
verandert dit bestand niet; vragen van de site-chat staan in hún repo (`drafts/BOUW_VRAAG.md`). Afspraak uit
`docs/PLAN_WERKWIJZE_2026-11-10.md` deel 5 (Rob 10 nov 2026: "het klopt allemaal, volgorde is goed").

Per regel deze velden (de site-chat vroeg om precies deze):

```
## <datum> — <korte naam>
- Tag + commit:   v… / <hash>   (of: geen tag)
- Status:         alleen op main / getagd / staat op CurseForge
- Mag op de site: ja / nee      (+ Robs go, letterlijk, als die er is)
- Speler ziet:    één of twee zinnen
- Knoplabels:     als Locales-sleutel, niet overgetypt
- Commando's:     /mh …
- Spel:           Midnight / Forever / allebei
```

**Status kent precies drie woorden, overal hetzelfde:**

1. **alleen op main** — gebouwd, niet uit. Spelers hebben het nog niet.
2. **getagd** — de release loopt (tag gezet, upload bezig).
3. **staat op CurseForge** — spelers hebben het. **Alleen dan** mag de site het als "nieuw" melden.

Een regel gaat van stand naar stand doordat de bouwchat hem bijwerkt (bij de tag, en als de CurseForge-API het bestand
toont). "Getest" is geen stand: wat Rob in het spel testte, staat in "Speler ziet" als *(getest door Rob)*.

---

## 22 nov 2026 — Forever: waar haal ik dit ingrediënt?
- Tag + commit:   geen tag (commit: zie git log, "where you get a reagent")
- Status:         alleen op main
- Mag op de site: nee (nog niet door Rob getest, geen release)
- Speler ziet:    bij 172 ingrediënten in de tooltip en in Skill up: dat het van monsters valt (geen plek), met welk beroep je het verzamelt (Herbalism, Mining, Skinning)
                  of wie het verkoopt. Skill up heeft een knop met de pijl naar die verkoper. Bron: AllTheThings (MIT) +
                  Wowhead + Zygor (alleen nummers) + de client.
- Knoplabels:     FSRC_GO_FMT
- Commando's:     /mh usedfor [on|off], /mh skillup
- Spel:           Forever

## 22 nov 2026 — Forever: talentpunt valt op in Do this now, zonder knop
- Tag + commit:   geen tag (commit: zie git log, "talent window")
- Status:         alleen op main
- Mag op de site: nee (geen release). Regel getest door Rob; de versie zonder knop nog niet.
- Speler ziet:    met een vrij talentpunt staat die regel bovenaan in Do this now, in goud met een ster, en noemt de toets
                  waarmee je zelf Talents opent. MH opent dat venster niet meer (dat kon "action blocked" geven).
- Knoplabels:     geen
- Commando's:     geen nieuwe
- Spel:           Forever

## 22 nov 2026 — Forever: /mh rest off|on|test gerepareerd
- Tag + commit:   geen tag (commit: zie git log, "Forever XP per hour")
- Status:         alleen op main
- Mag op de site: nee (reparatie, niet in het spel gezien, geen release; in 5.7.0 is het nog kapot)
- Speler ziet:    /mh rest off zet de waarschuwing voor weinig mana of health weer uit; /mh rest on zet hem terug.
- Knoplabels:     geen nieuwe
- Commando's:     /mh rest on|off|test|mana <n>|health <n>
- Spel:           Forever

## 21 nov 2026 — Forever: XP per uur en tijd tot je volgende level
- Tag + commit:   geen tag (commit: zie git log, "Forever XP per hour")
- Status:         alleen op main
- Mag op de site: nee (nog niet door Rob getest, geen release)
- Speler ziet:    Onder de XP-balk van het Forever-overzicht: "level N in X h Y min", in het tempo van je laatste uur
                  spelen; de tooltip geeft je XP per uur. Alleen ingelogde tijd telt. Schakelaar in Quiet helpers.
- Knoplabels:     FXPRATE_SW
- Commando's:     /mh rest xp
- Spel:           Forever

## 21 nov 2026 — Forever: dungeon-quests per dungeon (22 nov terug op main)
- Tag + commit:   geen tag (commit: zie git log, "dungeon quests back")
- Status:         alleen op main
- Mag op de site: nee (nog niet door Rob getest, geen release)
- Speler ziet:    In het overzicht, tab Dungeons, heeft een dungeon met quests een knop "Quests N": een venster met de
                  quests die je eerst ophaalt (questgever + zone, knop "Way ›" zet de pijl), wat al in je log staat, wat je
                  in de dungeon krijgt, wat later in een reeks komt, en hoeveel je al gedaan hebt. 32 dungeons; nummers en
                  plekken uit Zygor.
- Knoplabels:     FDQ_BTN_FMT, FDQ_TITLE_FMT, FOV_GO_SHORT
- Commando's:     /mh dungeons quests [key], /mh dungeons quests check [key]
- Spel:           Forever

## 21 nov 2026 — release 5.7.0 (staat op CurseForge)
- Tag + commit:   v5.7.0 / e215cc8. Release-run GitHub 44915363010: geslaagd (3m34s); log: CurseForge, Wago en GitHub
                  "Success!" voor beide zips. CurseForge-API (GEMETEN, na Robs "Beide zijn approved"): 9734057
                  `MidnightHelper-v5.7.0.zip` (12.0.7-12.1.7) en 9734079 `MidnightHelper-v5.7.0-forever.zip` (1.60.1),
                  beide releaseType 1, status 4.
- Status:         staat op CurseForge
- Mag op de site: ja. Rob, letterlijk: *"reload gedaan, tekst staat goed, go voor 5.7.0"* en in de bouwchat: *"Beide zijn
                  approved en ik zal in de sidechat de go geven."* (de go voor de site geeft Rob zelf in de site-chat). Wat de site als "nieuw" noemt = de releasetekst: Waylaid Crates en de mage Study-tip zitten
                  wel in de zip, maar staan NIET in de tekst (nog niet door Rob getest) → nog niet op de site.
- Speler ziet:    zie `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.7.0.md`): nieuw Forever-overzicht (tabs rechts), Which
                  city?, volgend talentpunt in Do this now (Paladin), level-en-tank-plan + Dual Spec, Smart Buff (Mage,
                  Priest, Druid), Skill up, Bags full (Destroy), Repair & sell, worn gear, Rested XP, quest-glinster,
                  erts en kruiden, slimme zegen op muis/doelwit, eigen instellingen per character, zeppelinplatform;
                  beide spellen: buff-bedankje; Midnight: renown-regel.
                  *(getest door Rob: Which city?, Skill up, Bags full + Destroy, charkey, erts/kruiden rood bij te lage
                  skill, Comprehend-melding weg, zoek-sprong, ondertitel)*
- Knoplabels:     FTALENT_SW, FSBUFF_SW, FOV_LAYOUT_SW, FOV_FIND_MODE_CITY, FBAG_DESTROY, FDUR_SW, FREST_SW, FNODE_GLOW_SW
- Commando's:     /mh, /mh skillup
- Spel:           vooral Forever; beide: buff-bedankje; Midnight: renown-regel

## 21 nov 2026 — Forever: volgend talentpunt in Do this now
- Tag + commit:   v5.7.0 (commit: zie git log, "next talent")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    met een vrij talentpunt zegt Do this now in welk talent het moet, met de tooltip; MH leest je talenten
                  en slaat over wat je al hebt. Nu voor Paladins (Retribution en Protection), andere classes volgen.
- Knoplabels:     `FTALENT_SW`, `FTALENT_BTN`
- Commando's:     `/mh talent`
- Spel:           Forever

## 21 nov 2026 — Forever: Smart Buff (Mage, Priest, Druid)
- Tag + commit:   v5.7.0 (commit: zie git log, "Smart Buff")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    macro "MH Smart Buff" zet Arcane Intellect / Power Word: Fortitude / Mark of the Wild op de speler onder
                  je muis, anders op je doelwit. Standaard uit. *(getest door Rob: mage)*
- Knoplabels:     `FSBUFF_SW`
- Commando's:     `/mh smartbuff [on|off]`
- Spel:           Forever

## 21 nov 2026 — Forever: level en tank, respec en Dual Spec, Wolfsbane
- Tag + commit:   v5.7.0 (commit: zie git log, "level and tank plans")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    How you play begint met een plan om te levelen en tanken (Paladin, Warrior, Druid) en legt voor elke
                  class talenten resetten en Dual Spec uit; Undead Paladins horen eerst Two-Handed Swords te leren voor
                  Wolfsbane. Tankstats Paladin: Stamina, dan Intellect.
- Knoplabels:     `FDONOW_WOLFSBANE_FMT`, `FDONOW_DUALSPEC`
- Commando's:     —
- Spel:           Forever

## 21 nov 2026 — Forever: zoeken springt naar de schakelaar + "for WoW Forever"
- Tag + commit:   v5.7.0 (commit edb8bc3)
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok) *(getest door Rob)*
- Speler ziet:    klik op een schakelaar in de zoekresultaten: Quiet helpers gaat open en die schakelaar licht op.
                  Onder de naam van het overzicht staat "for WoW Forever".
- Knoplabels:     `FOV_SUBTITLE`
- Commando's:     —
- Spel:           Forever

## 21 nov 2026 — Forever: Waylaid Crates
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Waylaid Crates")
- Status:         staat op CurseForge
- Mag op de site: nee (in bouw, niet getest)
- Speler ziet:    in de tooltip van een krat elke bundel die erin mag en hoeveel je hebt (tassen + bank); een verzegelde
                  krat of Shipping Label zegt bij wie je inlevert (Marcy Baker / Dokimi); komt er een in je tas, dan een
                  klein venster met Show the way. In Find -> In town: "Deliver crates", met je Merchant's Favor en rang.
- Knoplabels:     `FCITY_CAT_CRATES`, `FCRATE_SW`, `FVEND_TIP_WAY`
- Commando's:     `/mh crates [test|on|off]`
- Spel:           Forever

## 20 nov 2026 — Forever: Repair & sell
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Repair & sell")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    in Find (In town en Which city?) de verkopers die repareren, dichtstbijzijnde eerst, met Show the way;
                  in het Tas vol-venster de dichtstbijzijnde met een knop. MH leert bij elk verkoopvenster wie repareert.
                  Plus: zakt je meest versleten item onder 25%, dan een klein venster met dezelfde knop (schakelaar
                  `FDUR_SW`, standaard aan; `/mh durability [test]`).
- Knoplabels:     `FCITY_CAT_REPAIR`
- Commando's:     geen nieuwe (`/mh vendor check` telt ze)
- Spel:           Forever

## 20 nov 2026 — Midnight: Renown in het alt-overzicht
- Tag + commit:   v5.7.0 (commit: zie git log, "Midnight: Renown in het alt-overzicht")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    bovenaan het alt-overzicht één regel met je renown voor de hele account (elke Midnight-factie en je
                  rang), met een tooltip per factie.
- Knoplabels:     geen (regel `ALT_RENOWN_LINE_FMT`)
- Commando's:     geen nieuwe
- Spel:           Midnight

## 20 nov 2026 — Forever: Tas vol (stap 1)
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Tas vol stap 1")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    als je tas vol is (iets past niet), een venstertje met de drie goedkoopste dingen in je tas en waarom
                  ze weg kunnen, plus of de loot meer waard is. MH gooit zelf niets weg.
- Knoplabels:     `FBAG_TITLE`
- Commando's:     /mh bagfull [show | test | on | off]
- Spel:           Forever

## 20 nov 2026 — Forever: Skill up voor je beroepen
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Skill up")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    per maakberoep wat je nu maakt voor een skillpunt ("make about 10x …"), de drie zekerste recepten met
                  kleur en geschatte kans, wat je ervoor nodig hebt (tas + bank) en de weg naar je trainer. In tooltips
                  de kleurgrenzen van een recept en je kans. Geen geldbedragen.
- Knoplabels:     `FSKILL_BTN`, `FSKILL_GO_TRAINER`
- Commando's:     /mh skillup [probe | on | off]
- Spel:           Forever

## 20 nov 2026 — Forever: Find "Which city?", stap 3 van 4
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Find stap 3")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    in Find twee knoppen: "What am I looking for?" (de oude lijst) en "Which city?": kies een stad en zie
                  daar de herberg, bank, veilinghuis, brievenbus, flight master, boten/zeppelins en je class trainer,
                  plus hoe je er komt en "Route to <stad>". Met een zoekveld.
- Knoplabels:     `FOV_FIND_MODE_WHAT`, `FOV_FIND_MODE_CITY`, `FOV_FIND_CITY_ROUTE_FMT`, `FOV_FIND_SEARCH`
- Commando's:     geen nieuwe
- Spel:           Forever

## 20 nov 2026 — Forever: nieuw overzicht (tabbladen rechts), stap 1 van 4
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: nieuw overzicht stap 1")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    een groter Forever-overzicht met de tabbladen als hoge knoppen rechts; de oude indeling blijft te
                  kiezen in Quiet helpers.
- Knoplabels:     `FOV_LAYOUT_SW`
- Commando's:     geen nieuwe
- Spel:           Forever

## 20 nov 2026 — Forever: Hearthstone en teleports in de route
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: teleports in de route")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    de route-pijl stelt je Hearthstone of je class-teleport voor als dat sneller is, en zegt ongeveer
                  hoe lang de reis duurt.
- Knoplabels:     geen nieuwe
- Commando's:     /mh travel
- Spel:           Forever

## 20 nov 2026 — Forever: rested XP, uitloggen op de goede plek
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Rest XP")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    log je uit buiten een herberg of stad, dan toont MH de dichtstbijzijnde plek om uit te rusten
                  (met een pijl) en zegt of je Hearthstone klaar is. Ook een regel in de XP-tooltip van het overzicht.
- Knoplabels:     `FREST_SW`, `FCQ_BTN`
- Commando's:     /mh rest [go]
- Spel:           Forever

## 20 nov 2026 — Forever: erts en kruiden (icoon van de game + gloed van MH)
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: erts en kruiden")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    twee schakelaars in Quiet helpers. 1: de game toont een houweel of kruidje boven de dichtstbijzijnde
                  ertsader of het kruid (tot ~15 m, één tegelijk). 2: MH tekent er een gloed op (goud = erts, groen =
                  kruid, grijs = nog niet te verzamelen). Standaard uit; uitzetten zet je oude instellingen terug.
- Knoplabels:     `FNODE_ICON_SW`, `FNODE_GLOW_SW`
- Commando's:     /mh sparkle icon on|off, /mh sparkle glow on|off
- Spel:           Forever

## 20 nov 2026 — Forever: questitems glinsteren in plaats van een rand
- Tag + commit:   v5.7.0 (commit: zie git log, "Forever: Loot Sparkles")
- Status:         staat op CurseForge
- Mag op de site: ja (staat in de releasetekst van 5.7.0; Robs go staat in dat blok)
- Speler ziet:    een schakelaar in Quiet helpers: questitems die je kunt looten glinsteren weer, in plaats van een
                  rand. Standaard uit; uitzetten zet je oude grafische instellingen terug.
- Knoplabels:     `FLS_SW`
- Commando's:     /mh sparkle [on|off]
- Spel:           Forever

## 19 nov 2026 — release 5.6.0 (staat op CurseForge)
- Tag + commit:   v5.6.0 / cf06c1e. Release-run GitHub 44520447351: geslaagd; log: CurseForge, Wago en GitHub
                  "Success!" voor beide zips. CurseForge-API (GEMETEN): 9699302 `MidnightHelper-v5.6.0.zip`
                  (12.0.7-12.1.7) en 9699316 `MidnightHelper-v5.6.0-forever.zip` (1.60.1), beide releaseType 1, status 4.
- Status:         staat op CurseForge
- Mag op de site: ja. Rob via sparring, letterlijk: *"Go voor release."* Zijn
                  Midnight-check: *"Ik krijg geen fouten in WoW Midnight."* CURSEFORGE_DESCRIPTION.md bijgewerkt
                  (Rob plakt die zelf).
- Afspraak:       🔴 bij DEZE release zet de site-chat de **screenshots-draft v2** live (afspraak van 18 nov, hieronder).
- Speler ziet:    zie `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.6.0.md`): bazengids 28 dungeons (met 3D-model en klein
                  baaskaartje), zoekbalk, Travel, rares (je eigen gebied eerst), de juiste class trainer, tooltips overal
                  (lichtblauwe namen), "You just learned", wapenquests, buff "runs out soon", je goud in Do this now,
                  Comprehension (mage), slimme zegen-knop (paladin), "Used for" noemt het recept (ook Midnight).
                  *(getest door Rob: trainer-pijl, Comprehension-rij, Recipes-regel, rares, blauwe namen + goud,
                  "You just learned", loot-tooltips, baasmodel, lange namen)*
- Knoplabels:     FDG_BTN, FDG_CARD_SW, FRANK_LIST_SW, FBLESS_BTN_SW, FOV_SUB_QUIET, FOV_TAB_KEYS
- Commando's:     /mh, /mh bosses, /mh trainer go
- Spel:           vooral Forever; Midnight: "Used for"-recepten, tooltip op de reisknop, twee reparaties

## 18 nov 2026 — concept voor de volgende release klaargezet (nog GEEN release)
- Tag + commit:   geen tag; concept in `docs/CURSEFORGE_DRAFT_volgende.md` (geen versienummer, geen RELEASE_NOTES.md)
- Status:         alleen op main
- Mag op de site: nee, nog niet. Rob beslist zelf of en wanneer de release komt (via sparring: "Fable mag en ik volg je
                  advies"; advies: concept klaarzetten).
- Afspraak:       🔴 bij DIE release zet de site-chat de **screenshots-draft v2** live (samen met de nieuwe tekst).
- Speler ziet:    zie het concept: bazengids 28 dungeons, zoekbalk, Travel, rares, class-quest-voorwaarden,
                  disenchant, Open-box button, ranks kiezen, Reputation & currency.
- Spel:           vooral Forever; twee Midnight-reparaties

## 18 nov 2026 — Forever: bazengids (stap 1 + 2a + 2b, alle 28 dungeons)
- Tag + commit:   geen tag (2a = 87f3488; 2b = de commit die deze regel bijwerkt)
- Status:         alleen op main
- Mag op de site: nee (nog niet uit; Rob heeft het nog niet in het spel gezien)
- Speler ziet:    WoW Forever heeft geen Dungeon Journal. MH toont per dungeon wie de bazen zijn, wat ze doen, één tip
                  en 2-3 items die het weten waard zijn — nu alle 28 dungeons tot level 60, in 7 talen; bazennamen zoals
                  boven hun hoofd. Nieuwe
                  Forever-dungeons zeggen zelf dat de regels later nog eens nagekeken worden.
- Knoplabels:     FDG_BTN (knop "Bosses" op een dungeonregel in het overzicht), FDG_TITLE (venstertitel)
- Commando's:     /mh bosses, /mh bosses check
- Spel:           Forever

## 17 nov 2026 — release 5.5.0 (staat op CurseForge)
- Tag + commit:   v5.5.0 / 41f8ec3. Release-run GitHub 44137237357: geslaagd; log: CurseForge, Wago en GitHub
                  "Success!" voor beide zips. CurseForge-API (GEMETEN): 9669670 `MidnightHelper-v5.5.0.zip`
                  (12.0.7-12.1.7) en 9669685 `MidnightHelper-v5.5.0-forever.zip` (1.60.1), beide releaseType 1, status 4.
- Status:         staat op CurseForge (Rob via sparring, letterlijk: "Go voor 5.5.0 (en dit is binnen een uur 🙂 )")
- Mag op de site: ja. CURSEFORGE_DESCRIPTION.md bijgewerkt (Forever-overzicht, Find, class quests); Rob plakt die zelf
                  op CurseForge.
- Bundelt:        de regels hieronder van na v5.4.0 → ook die staan nu op CurseForge (v5.5.0).
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.5.0.md`). Bundelt de regels hieronder van na v5.4.0:
                  16 nov druid class-quests + rollen; 17 nov Warlock, Warrior, Hunter en Rogue, Shaman, Priest, Paladin
                  en Mage class-quests; How to play per rol; opzij voor de Forever Leveling Guide; kamperen stap 1;
                  Legacy Points stap 1. Plus wat hier nog GEEN eigen regel had: het overzicht `/mh overview` als
                  voordeur (7 tabs Now · Your class · Find · Professions · Dungeons & group · Keys & macros ·
                  Characters; tandwiel Quiet helpers · Tools · All commands; oude venster + Dock-knop weg in Forever;
                  losse vensters in dezelfde stijl), Find "In town" (bank, veilinghuis, brievenbus, herberg, neutrale
                  AH's gemarkeerd), tien handige macro's met je hoogste rang, Free key, zegen-tip voor paladins, Hall of
                  Thanes voor Horde. Grotendeels *(niet in het spel getest)*.
- Knoplabels:     FOV_TAB_NOW, FOV_TAB_CLASS, FOV_TAB_FIND, FOV_TAB_PROFS, FOV_TAB_DUNG, FOV_TAB_KEYS, FOV_TAB_CHARS,
                  FOV_SUB_QUIET, FOV_SUB_TOOLS, CMDLIST_TITLE, FOV_FIND_SEC_CITY, FCITY_NEUTRAL_TAG, FMAC_EAT_TITLE,
                  FMAC_BTN_FREE, FMAC_BTN_UNDO_KEYS, SET_BLESSTIP_TITLE
- Commando's:     /mh overview (ook /mh, Alt+M, minimapknop), /mh blesstip on|off
- Spel:           Forever (Midnight onveranderd)

## 17 nov 2026 — Forever: Legacy Points, stap 1 ("je hebt N ongebruikte punten")
- Tag + commit:   geen tag / (deze commit, zie git log "Legacy step 1")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Heb je ongebruikte Legacy Points, dan zegt "Do this now" hoeveel en waar je ze uitgeeft (namen in
                  jouw taal, uit het spel). /mh legacy laat zien wat MH kan lezen. *(niet in het spel getest)*
- Knoplabels:     FLEGACY_UNUSED_FMT (regel, geen knop)
- Commando's:     /mh legacy
- Spel:           Forever

## 17 nov 2026 — Forever: kamperen, stap 1 ("ga bij het vuur zitten")
- Tag + commit:   geen tag / (deze commit, zie git log "camping step 1")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Sta je bij een kampvuur zonder kampbuff, dan zegt "Do this now": ga zitten, na 1 minuut krijg je
                  1 uur Camp Benefits (namen in jouw taal, uit het spel). /mh camp laat zien wat MH kan lezen.
                  *(niet in het spel getest)*
- Knoplabels:     FCAMP_SIT_FMT (regel, geen knop)
- Commando's:     /mh camp
- Spel:           Forever

## 17 nov 2026 — Forever: MH gaat opzij voor de Forever Leveling Guide (schakelaar)
- Tag + commit:   geen tag / (deze commit, zie git log "Forever Leveling Guide")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Heeft de Forever Leveling Guide een reisroute, dan zet MH geen eigen speld en tekent geen pijl, en zegt
                  in de chat waarom. Start de gids een route terwijl die van MH loopt, dan stopt MH de zijne en zegt dat.
                  Wie wil dat MH toch stuurt, zet de schakelaar om. *(niet in het spel getest)*
- Knoplabels:     SET_ARROWGUIDE_TITLE ("Step aside for the Forever Leveling Guide")
- Commando's:     /mh arrow guide, /mh arrow
- Spel:           Forever

## 17 nov 2026 — Forever: "How to play" per rol, per 10 levels, voor alle 9 classes
- Tag + commit:   geen tag / 2b2fd6a … b0fbbec (en+nl), 81f4c2b (de/fr/es/esMX/pt/ru)
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    In "How to play" per rol (bv. Protection: tank, Frost: damage from a distance) een simpele volgorde,
                  wat je per 10 levels krijgt (10-60) en 3 beginnersfouten. Alle 9 classes, 7 talen.
                  *(niet in het spel getest)*
- Knoplabels:     FHOWTO_ROLES_SHOW, FHOWTO_ROLES_HIDE
- Commando's:     /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Mage class-quests stap voor stap (alle 9 classes nu)
- Tag + commit:   geen tag / (deze commit, zie git log "Mage class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Mage: "Do this now" leidt je naar je eerste staf of orb (10), Study (6), robe (15) en garment (26),
                  Mage's Wand (30), Celestial Power (35), het Personal Spellbook (42), Magecraft (50), Conjure Water en
                  Polymorph: Pig (60). Daarmee hebben alle negen Forever-classes hun class-quests. *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Paladin class-quests stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Paladin class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Paladin: "Do this now" leidt je door Redemption (12), Verigan's Fist (20), het paard (40, 60) en
                  Valorfist (50); de nieuwe Undead-paladin krijgt eigen quests (Holy Light, Bandarion Keep, Redemption,
                  Wolfsbane, paard). Begint een quest met een boek in je tas, dan zegt MH dat. *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Priest class-quests stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Priest class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Priest: "Do this now" stuurt je op level 10 en 20 naar de hogepriester van je ras voor je ras-spell
                  (ook de nieuwe Gnome-priest), plus je eerste gewaad (5) en Ogtinc's quests (50). *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Shaman class-quests (totems) stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Shaman class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Shaman: "Do this now" leidt je met de pijl naar je Earth- (4), Fire- (10), Water- (20) en Air-totem
                  (30), per ras de goede startplek (ook Dwarf en Skyborne), en bij de Horde Elemental Mastery (52).
                  *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Hunter en Rogue class-quests stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Hunter and Rogue class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Hunter: "Do this now" leidt je door het temmen van je eerste beesten (10, per ras, ook Human en
                  Skyborne) en The Hunter's Charm (50). Rogue: Blade of Cunning (10), Thieves' Tools (16), Poisons (20),
                  twee nieuwe Forever-opdrachten bij de Dead Drop (23, 30, met "wacht op de brief") en The Azure Key (50).
                  *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Warrior class-quests stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Warrior class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Warrior: "Do this now" leidt je met de pijl naar Defensive Stance (10, per ras de goede startplek, ook
                  Skyborne), Berserker Stance (30), daarna het Whirlwind-wapen (30) en de Fallen Hero (50). *(niet in het
                  spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 17 nov 2026 — Forever: Warlock class-quests stap voor stap
- Tag + commit:   geen tag / (deze commit, zie git log "Warlock class quests")
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Warlock: "Do this now" leidt je met de pijl door de quests voor je demonen (Imp, Voidwalker, Succubus en
                  Incubus, Felhunter) en je paarden (Felsteed, Dreadsteed), per ras de goede startplek, NPC-namen in je eigen
                  taal. *(niet in het spel getest)*
- Knoplabels:     FCQ_BTN ("Show the way"), FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever

## 16 nov 2026 (avond/nacht) — Forever: druid class-quests stap voor stap + druid per rol
- Tag + commit:   geen tag / 4faaaee, 0059fae, 86984a6, bb1635e, dad9c38, 956ed87, f707878 (na de tag v5.4.0)
- Status:         staat op CurseForge (v5.5.0)
- Mag op de site: ja (uit in 5.5.0)
- Speler ziet:    Druid: "Do this now" leidt je stap voor stap door de class-quests (Bear Form, Cure Poison, Aquatic Form,
                  Cat Form, Torwa Pathfinder; Skyborne-druids hun eigen Bear/Cat-ketens), met de pijl en NPC-namen in je
                  eigen taal. How you play heeft bovenaan "Your class quests" en de rol(len) van je richting (beer, kat,
                  Balance, Restoration); de rest achter de knop "All roles". *(niet in het spel getest)*
- Knoplabels:     FHOWTO_ROLES_SHOW / FHOWTO_ROLES_HIDE / FHOWTO_ROLES_FOLD (de knop), FCQ_BTN ("Show the way"),
                  FCQ_HOWTO_HEAD ("Your class quests")
- Commando's:     /mh classquest, /mh play
- Spel:           Forever
- 📌 Ter info: `/mh partytest` (Forever, 53341fa) is een meetknop voor ons, geen spelersfunctie; komt niet op de site.

## 16 nov 2026 — RELEASE 5.4.0 (Midnight + Forever)
- Tag + commit:   v5.4.0 / b23e0ec. Release-run GitHub 43943568777: geslaagd; in het log "Success!" voor CurseForge,
                  Wago en GitHub, beide zips (Retail 19:52:01, Forever 19:53:13 UTC). CurseForge-API (GEMETEN):
                  9653805 `MidnightHelper-v5.4.0.zip` en 9653822 `MidnightHelper-v5.4.0-forever.zip` (1.60.1), beide
                  releaseType 1, status 4 (de Retail-zip verscheen pas later in de openbare files-API).
- Status:         staat op CurseForge (Rob: "beide staan live")
- Mag op de site: Rob via Sparring 16-11, letterlijk: "go"; op de spelerstekst: "laat de bouwchat hem maar aanpassen"
                  (= aanpassen en online zetten). Live zetten op de site: volgens jullie eigen afspraak met Rob.
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.4.0.md`); de regels hieronder met "getagd (v5.4.0)".
                  Geen beta.
- Spel:           allebei (twee bestanden: Retail + `-forever`)

## 16 nov 2026 — Forever: "Best stats for you now"
- Tag + commit:   geen tag / (deze commit, zie git log "best stats")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    "Do this now" zegt welke stats nu het beste zijn voor jouw gekozen richting (en voor Warrior/Paladin/
                  Druid ook als je tankt). De groene tooltipregel volgt dezelfde stats. Niet in het spel gezien.
- Knoplabels:     FDONOW_STATS_FMT, FDONOW_STATS_TANK_FMT
- Commando's:     /mh donow check (bestond al)
- Spel:           Forever

## 16 nov 2026 — Vuurwerk bij een level-up
- Tag + commit:   geen tag / (deze commit, zie git log "fireworks")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Bij elk nieuw level een korte bos sterretjes midden in beeld (zonder geluid: het spel geeft zelf al
                  een "ding"). Uit te zetten. Rob zag het werken.
- Knoplabels:     SET_FIREWORKS_TITLE
- Commando's:     /mh fireworks test
- Spel:           allebei

## 16 nov 2026 — Forever: nieuwe spell op geen balk + tooltipregels "nooit voor jouw class" en "nodig voor je quest"
- Tag + commit:   geen tag / (deze commit, zie git log "new spell on no bar")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    "Do this now" noemt een nieuw geleerde spell die nog op geen balk staat. Op een item zegt de tooltip of
                  jouw class het nooit kan gebruiken, en of het nodig is voor een quest in je log (met de teller).
                  Niet in het spel gezien.
- Knoplabels:     FDONOW_NOBAR_FMT, FITEM_NEVER_FMT, FITEM_QUEST_FMT
- Commando's:     /mh donow check, /mh usedfor (bestonden al)
- Spel:           Forever

## 16 nov 2026 — Midnight: "Je bent 90. Wat nu?"
- Tag + commit:   geen tag / (deze commit, zie git log "max-level")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Eén keer, als je character het hoogste level haalt: een klein venster dat wijst naar "My gear: what
                  now?" en Start Here. Niet in het spel gezien.
- Knoplabels:     MAXLVL_POPUP_FMT, MAXLVL_BTN_GEAR, MAXLVL_LATER
- Commando's:     geen voor spelers (/mh maxlevel is een meetknop)
- Spel:           Midnight

## 16 nov 2026 — Forever: buffknop voor steen, olie of poison
- Tag + commit:   geen tag / (deze commit, zie git log "Forever: weapon stones")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Heb je een sharpening stone, weightstone, olie of (rogue) poison bij je, past die op je wapen en zit er
                  nog niets op, dan toont de buffknop hem; één klik zet hem erop. Main hand en off hand. Niet in het spel gezien.
- Knoplabels:     MBUFF_TXT_WEAPONITEM_SAY, MBUFF_TXT_WEAPONITEM_OH_SAY, MBUFF_SAY_CLICK_ITEM
- Commando's:     /mh buffs (bestond al)
- Spel:           Forever

## 16 nov 2026 — Forever: opties opgeruimd, upgrade-melding als schakelaar, Self Cast Key-waarschuwing
- Tag + commit:   geen tag / (deze commit, zie git log "Forever: hide the 63 settings")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    In Forever toont de optiepagina alleen nog wat daar iets doet (63 Midnight-schakelaars weg, o.a. de
                  koppen Dungeon help en Vault). Nieuw onder Gear: een schakelaar voor de melding "upgrade in je tassen".
                  In het macrovenster (Forever én Midnight) een gele regel bij mouseover-macro's met een toets als je
                  Self Cast Key aan staat. Niet in het spel gezien.
- Knoplabels:     SET_PICKUP_TITLE, MACROS_WARN_SELFCAST_FMT
- Commando's:     /mh pickup on|off (bestond al)
- Spel:           Forever (de waarschuwing: allebei)

## 16 nov 2026 — Forever: kaartje "Dungeons in Forever" in de kamer Me
- Tag + commit:   geen tag / 2005da7
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Een kaartje in de kamer Me dat de dungeonlijst opent. Niet in het spel gezien.
- Knoplabels:     FDUNG_TITLE, TOOLLP_FDUNG_DESC
- Commando's:     /mh dungeons (bestond al)
- Spel:           Forever

## 16 nov 2026 — Schakelaar "Camera verder weg"
- Tag + commit:   geen tag / (deze commit, zie git log "Camera further away")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Eén vinkje in de opties: de camera mag verder uitzoomen dan het spel normaal toestaat (Midnight 2.6,
                  Forever 4). Uit = je oude afstand terug. Daarna zelf uitscrollen met het muiswiel. Niet in het spel gezien.
- Knoplabels:     SET_CAMERAFAR_TITLE, SET_CAMERAFAR_DESC
- Commando's:     /mh camera, /mh camera on, /mh camera off
- Spel:           allebei

## 16 nov 2026 — Forever: lijst "Screens" zonder Midnight-schermen
- Tag + commit:   geen tag / (deze commit)
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit; een reparatie, geen nieuwe functie)
- Speler ziet:    In Forever toont Options → Midnight Helper → Screens alleen de schermen die Forever heeft (eerst ook
                  Midnight-schermen en twee rauwe sleutels). Niet in het spel gezien.
- Knoplabels:     SETTINGS_SCREENS_TITLE
- Commando's:     —
- Spel:           Forever

## 15 nov 2026 — Forever: waarschuwing "geen XP" bij meer dan 12 levels verschil
- Tag + commit:   geen tag / (deze commit, zie git log "Forever: warn when nobody gets XP")
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    Zit iemand in je groep meer dan 12 levels boven een vijand, dan zegt een rode regel onder het
                  groepspaneel dat niemand XP krijgt voor die vijand (Blizzards regel sinds 14 nov 2026). In de
                  dungeonlijst krijgen dungeons waar dat waarschijnlijk geldt een rood `*`. Niet in het spel gezien.
- Knoplabels:     FXP_TARGET_FMT, FXP_DUNGEON_FMT, FXP_LIST_NOTE_FMT
- Commando's:     /mh partytargets, /mh dungeons, /mh dungeons check
- Spel:           Forever

## 15 nov 2026 — Forever: uitnodiging voor de Forever-vragenlijst
- Tag + commit:   geen tag / 1f521e5
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit). De pagina /<taal>/survey/forever/ staat al live (site-chat, f476ce77; GEMETEN 200
                  in en/nl/de/fr/es/pt/ru).
- Speler ziet:    In Forever, op de tweede dag dat MH draait, één keer een vraag om een korte anonieme vragenlijst in te
                  vullen ("Show the link" / "Later" / "No thanks"). `/mh survey` geeft altijd de link. Niet in het spel
                  gezien.
- Knoplabels:     FSURVEY_POPUP_TEXT, FSURVEY_COPY_TITLE, SURVEY_SHOW_LINK, SURVEY_LATER, SURVEY_NEVER
- Commando's:     /mh survey
- Spel:           Forever

## 15 nov 2026 — Forever: dungeonlijst per zone, vinkje "alleen voor mijn level", coördinaten
- Tag + commit:   geen tag / b7d9360 + efe3b9d (regel nagetekend door Bouwchat 15-11)
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit)
- Speler ziet:    "Dungeons in Forever" (`/mh dungeons`) toont kopjes per zone; een vinkje toont alleen wat bij je level
                  past (tot 2 levels hoger, oranje "+N"); de kolom Entrance toont de plek als getallen. Niet in het spel gezien.
- Knoplabels:     FDUNG_ONLY_MINE_FMT, FDUNG_ZONE_FMT, FDUNG_NONE_MINE
- Commando's:     /mh dungeons
- Spel:           Forever

## 15 nov 2026 — Talen: spelwoorden zoals het spel ze noemt
- Tag + commit:   geen tag / efe3b9d, 041316d, 3d20a27, 9f2964c, 460c984, dfac3b5
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit). Let op voor de site-teksten: dezelfde regel geldt (Rob, 15 nov: "de plus en alle
                  andere vaste spelnamen, krijg je in elke taal de naam uit het spel").
- Speler ziet:    In de/fr/es/pt/it/ru (en esMX) heten Mythic+, Raid, Great Vault, Dungeon, Renown, Heroic/Mythic, Season,
                  Keystone, item level, delve-tier, crests, Coffer Keys, LFR, Timewalking, PvP en het toetsenmenu zoals de
                  client van die taal ze toont (gemeten in Blizzards data). Voorbeelden: de "Mythisch+", "Schlachtzug",
                  "Große Schatzkammer"; pt "Série" voor seizoen. Niet in het spel gezien.
- Knoplabels:     (veel; o.a. MPLUS_VIEW, TAB_DELVES, CODEX_CUR_DAWN_TITLE)
- Commando's:     geen
- Spel:           allebei

## 14 nov 2026 — Forever: Horde/Alliance-embleem in "Your characters"
- Tag + commit:   geen tag / 43d4e76 (regel 15 nov nagetekend; de regie zag hem ontbreken)
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit; Rob test eerst)
- Speler ziet:    In "Your characters" (`/mh alts`) staat vóór elk character het Horde- of Alliance-embleem. Een character
                  waar je sinds deze versie nog niet op inlogde krijgt een grijs "?" tot je er één keer op inlogt.
                  Niet in het spel gezien.
- Knoplabels:     FCHARS_SIDE_UNKNOWN
- Commando's:     /mh alts
- Spel:           Forever

## 14 nov 2026 — Forever: dungeons voor jouw level + pijl naar de ingang
- Tag + commit:   geen tag / (deze commit, na c728fc6)
- Status:         staat op CurseForge (v5.4.0)
- Mag op de site: nee (nog niet uit; Rob test eerst)
- Speler ziet:    In "Do this now" een regel welke dungeons nu bij je level passen, met een knop "Dungeons". Dat venster
                  toont alle Forever-dungeons met level en ingang (groen = past nu) en een knop Route per dungeon: de pijl
                  wijst de ingang aan, met boot/zeppelin als dat moet. Ingangen van HandyNotes Dungeon & Raid Locations
                  (MIT). 15 nov: sinds HandyNotes-versie 1.02 komen álle ingangen daarvandaan (het sterretje voor
                  "van internet" is weg). 15 nov ook: de lijst staat per zone (kopjes die je open en dicht klikt), met
                  bovenaan een vinkje "alleen voor mijn level" (ook tot 2 levels hoger, oranje met +N); haal je het
                  weg, dan zie je alles. Niet in het spel gezien.
- Knoplabels:     FDUNG_TITLE, FDUNG_BTN, FDUNG_ROUTE, FDUNG_ONLY_MINE_FMT
- Commando's:     /mh dungeons
- Spel:           Forever

## 14 nov 2026 — RELEASE 5.3.0 (Midnight + Forever)
- Tag + commit:   v5.3.0 / c728fc6. GEMETEN in de CurseForge-API (14 nov): file 9617031 `MidnightHelper-v5.3.0.zip`
                  (12.0.7–12.1.7) en 9617039 `MidnightHelper-v5.3.0-forever.zip` (1.60.1), beide releaseType 1, status 4.
                  Release-run GitHub 43631449366: geslaagd.
- Status:         staat op CurseForge
- Mag op de site: Rob gaf de go voor de release, rechtstreeks in de bouwchat, letterlijk: "go en dan 5.3.0 , denk ook
                  aan de site en evt description". Live zetten op de site: volgens jullie eigen afspraak met Rob.
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.3.0.md`): één venster bij het inloggen (regel
                  hieronder), plus kleine fixes (deDE Eisenschmiede, frFR "Ton", titels vrij van "Dock to window").
                  Nieuwe zin in `CURSEFORGE_DESCRIPTION.md` ("Getting started": Welcome-venster); Rob plakt hem zelf.
                  Geen beta.
- Spel:           allebei (twee bestanden: Retail + `-forever`)

## 13 nov 2026 — Allebei: het keuzevenster wordt één overzicht bij het inloggen
- Tag + commit:   v5.3.0 (c728fc6) / gebouwd in 2ef8724 … d6c0d31 (o.a. 168181b, 1cf57d2, 4fef65f, fcf82a7)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.3.0 hierboven. Getest door Rob: nieuw Forever-character, bestaand Forever-character en
                  nieuw Midnight-character (14 nov).
- Speler ziet:    Eén venster bij het inloggen in plaats van losse vragen. Nieuwe speler of nieuw character: titel
                  "Welcome", met kaartjes voor wat bij dit character hoort (in Forever: welke richting, de bar layout of
                  het toetsenblok). Na een update: "New in this version" met Aan/Uit-kaartjes voor de schermpjes (quick
                  bar, Fast Mark-balk, buff-icoon, minimapknop; in Forever ook het groepspaneel en "Do this now"). Je ziet
                  elk kaartje één keer; het telt pas als gezien als je het venster zelf sluit. Te hoog: schuifbalk.
                  Niet (helemaal) in het spel gezien.
- Knoplabels:     NEWC_WELCOME_TITLE, NEWC_TITLE, NEWC_BAR_HEAD, NEWC_ON, NEWC_OFF
- Commando's:     /mh new
- Spel:           allebei (richting en bar layout alleen in Forever)

## 13 nov 2026 — RELEASE 5.2.0 (Midnight + Forever)
- Tag + commit:   v5.2.0 / 65ca28a. GEMETEN in de CurseForge-API (13 nov): file 9587203 `MidnightHelper-v5.2.0.zip`
                  (12.0.7–12.1.7) en 9587210 `MidnightHelper-v5.2.0-forever.zip` (1.60.1), beide releaseType 1, status 4.
                  Release-run GitHub 43380670872: geslaagd; Wago en GitHub-release hebben allebei de zips.
- Status:         staat op CurseForge
- Mag op de site: Rob gaf de go voor de ADDON-release (via sparring, letterlijk: "je krijgt nu een go voor een release
                  voor alles"). De go voor de SITE kreeg de site-chat zelf van Rob (gemeld door chat addons-dc, 13 nov).
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.2.0.md`); per functie de 12 regels hieronder (allemaal
                  "getagd"). Ook: nieuwe `CURSEFORGE_DESCRIPTION.md` (f6631bb), Rob plakt hem zelf. Geen beta.
                  Rob: "ik heb tot nutoe alles bekeken". Eigen toetsenlijst in Forever: 4 regels (getest door Rob).
- Spel:           allebei (twee bestanden: Retail + `-forever`)

## 12 nov 2026 — Forever: oude rank licht op, op je knop
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Een knop op Blizzards balken die nog een lagere rank cast, krijgt een rustige oranje rand met een
                  pijltje omhoog: fel als je de nieuwe rank net leerde, zacht als je de lage rank er zelf neerzette.
                  Standaard aan. Zwijgt als Glowing Bars geladen is. Niet in het spel gezien.
- Knoplabels:     SET_FOREVER_RANKGLOW_TITLE
- Commando's:     /mh ranks, /mh ranks glow on|off
- Spel:           Forever

## 12 nov 2026 — Forever: "Your characters"
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Een venster met al je characters op een rij: level en class, goud (met het totaal), beroepen met skill,
                  je gekozen richting, wanneer je ze het laatst speelde, en hoeveel spells klaarliggen bij de trainer. Een
                  character staat erin na één login. Niet in het spel gezien.
- Knoplabels:     FCHARS_TITLE, FCHARS_COL_TRAINER, FCHARS_TOTAL_FMT
- Commando's:     /mh alts
- Spel:           Forever

## 12 nov 2026 — Allebei: venster "Nieuw in deze versie: jouw keuze"
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Na een update één venster met kaartjes om zelf te kiezen, in plaats van de changelog: "Do this now"
                  (Forever, drie standen), het groepspaneel aan/uit (Forever), en vaste toetsen voor wie het toetsenblok
                  nog niet heeft ("Show me" opent eerst het plan, zet zelf niets). Wegklikken verandert niets. Niet in het
                  spel gezien.
- Knoplabels:     NEWC_TITLE, NEWC_KEYS_BTN, NEWC_MORE, NEWC_ON, NEWC_OFF, NEWC_CHANGELOG_BTN
- Commando's:     /mh new
- Spel:           allebei ("Do this now" en het groepspaneel in Forever, "Party targets" in Midnight, toetsen in allebei)

## 12 nov 2026 — Forever: uitleg per beroep
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    In "Profession trainers" staat boven de trainers een kaartje per beroep: wat het doet, hoofd- of bijberoep,
                  gereedschap met "Where to buy", waar spelersgidsen het bij zetten, en de rangen. "Do this now" zegt of
                  je nog een hoofdberoep kunt leren. Niet in het spel gezien.
- Knoplabels:     FPROFG_BUY, FPROF_TITLE
- Commando's:     /mh trainers
- Spel:           Forever

## 12 nov 2026 — Forever: venster "Do this now"
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Een klein venster met wat je nu kunt doen (spells bij je trainer, oude ranks, wapens, een ontbrekende
                  buff, ontbrekend gereedschap) en de trainer-spells van de komende 3 levels. Standaard alleen als er iets
                  te doen is. Niet in het spel gezien.
- Knoplabels:     FDONOW_TITLE, SET_FOREVER_DONOW_TITLE
- Commando's:     /mh donow, /mh donow check, /mh donow auto|always|off
- Spel:           Forever

## 12 nov 2026 — Forever: wat jouw richting nodig heeft
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Heb je een richting gekozen, dan staat bovenaan "How you play" wat die nodig heeft: zwaarste pantser,
                  welk wapen spelersgidsen noemen, en welke spells alleen met een schild, dolk of afstandswapen werken.
                  /mh weapons zet een groen + bij de wapensoorten die passen. Niet in het spel gezien.
- Knoplabels:     FDIRB_HEAD_FMT, FWEAP_DIR_FIT_FMT
- Commando's:     /mh play, /mh weapons, /mh direction
- Spel:           Forever

## 12 nov 2026 — Forever: klein groepspaneel
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Een klein paneel met je groep (standaard uit): klik = doelwit, rechtsklik = je dispel op die speler,
                  en Blizzards rode rand als iemand iets heeft wat jij kunt weghalen. Niet in het spel gezien.
- Knoplabels:     SET_FOREVER_PARTY_TITLE, FPARTY_TITLE
- Commando's:     /mh partytargets, /mh partytargets check
- Spel:           Forever

## 12 nov 2026 — Forever: gereedschap vergeten → waar je het koopt
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Zegt het spel "Requires Skinning Knife" (of Mining Pick, Blacksmith Hammer, een hengel), dan noemt MH meteen
                  de dichtstbijzijnde verkoper met "Show the way". Ook als je het beroep al lang had. Niet in het spel gezien.
- Knoplabels:     FVEND_TIP_WAY, SET_FOREVER_TOOLNEED_TITLE
- Commando's:     /mh vendor, /mh vendor check, /mh vendor tip on|off
- Spel:           Forever

## 12 nov 2026 — Forever: "Which way do you want to go?" (je richting kiezen)
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    In WoW Forever vraagt MH na het inloggen welke van de drie talentbomen van je class je wilt, elk met één
                  gewone zin. Overslaan mag ("Later", "Never ask again"), wisselen kan altijd. Nog niets anders gebruikt die
                  keuze. Niet in het spel gezien.
- Knoplabels:     FDIR_ASK_TITLE, FDIR_LATER, FDIR_NEVER, FDIR_CLEAR, FDIR_HOWTO_BTN_FMT, SET_FOREVER_DIRECTION_TITLE
- Commando's:     /mh direction, /mh direction check
- Spel:           Forever

## 12 nov 2026 — Alle ontbrekende buffs, en waarom MH deze kiest
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Het buff-icoon toont naast zich kleine icoontjes voor de andere buffs die missen. De tooltip zegt waarom MH
                  deze kiest (die je het laatst castte, of de eerste die je kent). Niet in het spel gezien.
- Knoplabels:     MBUFF_TIP_ALSO, MBUFF_TIP_EXTRA
- Commando's:     /mh buffs (Forever), /mh mbuff (Midnight)
- Spel:           allebei

## 12 nov 2026 — Eén schakelaar "Move" voor alle MH-onderdelen
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Eén schakelaar laat alle MH-onderdelen op je scherm zien met een groen vakje "Drag me". Sleep ze waar je
                  wilt; in een gevecht gaat het vanzelf uit. Niet in het spel gezien.
- Knoplabels:     SET_MOVE_TITLE, MOVE_DRAG_FMT
- Commando's:     /mh move, /mh move why
- Spel:           allebei

## 12 nov 2026 — Groepspaneel: rechtsklik op het doelwit is een stop-spell als je geen purge hebt (Midnight)
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    In het Party targets-paneel: rechtsklik op het doelwit van een groepslid. Heb je een purge (Priest,
                  Mage, Shaman, Hunter), dan blijft dat de purge. Zo niet, dan is het nu je interrupt (bv. Rebuke op
                  een Prot Paladin). Specs zonder allebei: nog steeds niets. Niet in het spel gezien.
- Knoplabels:     geen nieuwe
- Commando's:     /mh partytargets, /mh glow (diagnose)
- Spel:           Midnight

## 11 nov 2026 — De tooltip zegt voor welk beroep een item een ingrediënt is (Forever én Midnight)
- Tag + commit:   v5.2.0 (65ca28a) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: zie RELEASE 5.2.0 bovenaan
- Speler ziet:    Op een ingrediënt staat onderaan de tooltip bv. "MH: Used for Cooking (you have it)". Groen als je een
                  van die beroepen hebt, grijs als je er geen hebt. Ook in je tas, niet alleen bij de verkoper. In
                  Midnight alleen voor Midnight-ingrediënten. *(Forever getest door Rob, 11 nov; Midnight nog niet)*
- Knoplabels:     FUSE_TIP_FMT, FUSE_HAVE_IT, FUSE_HAVE_FMT
- Commando's:     /mh usedfor [on|off]
- Spel:           allebei

## 11 nov 2026 — RELEASE 5.1.0 (Midnight + Forever)
- Tag + commit:   v5.1.0 / ef2b38e (tag gepusht 11 nov ~13:20 NL-tijd). GEMETEN in de CurseForge-API: file 9556823
                  `MidnightHelper-v5.1.0.zip` (12.0.7–12.1.7) en 9556853 `MidnightHelper-v5.1.0-forever.zip` (1.60.1),
                  beide releaseType 1 (Release), status 4. Release-run GitHub: geslaagd.
- Status:         staat op CurseForge
- Mag op de site: Rob gaf de go voor de ADDON-release ("je krijgt een go om het live te zetten … Zowel voor forever als
                  voor midnight"). Een aparte go voor de SITE heeft de bouwchat niet gekregen: vraag Rob.
- Speler ziet:    alles in `RELEASE_NOTES.md` (= `docs/CURSEFORGE_5.1.0.md`); per functie de regels hieronder (allemaal
                  "getagd"). Geen beta, Robs reden: *"Beta mensen reageren nooit. Zeker niet in de forever versie."*
- Spel:           allebei (twee bestanden: Retail + `-forever`)

## 11 nov 2026 — ANTWOORD op BOUW_VRAAG (11 nov): `release_text_check.py` hergebruiken op een tag
- **Importeerbaar: ja.** GEMETEN: op moduleniveau staan alleen regexen en functies; `main()` draait alleen onder
  `if __name__ == "__main__"` (regel 171). Importeren doet geen werk.
- **Op een tag: ja, zonder dat wij iets veranderen.** `routed_words(root)` en `locale_index(root)` lezen gewone
  bestanden onder de map die je als `root` meegeeft (`Core.lua`, `Modules/**`, `Locales/*.lua`). Zet de tag dus eerst in
  een tijdelijke map en geef die map mee, bv. `git -C "<addon-repo>" archive <tag> Core.lua Modules Locales` uitpakken
  in een temp-map (of `git worktree add <temp> <tag>`). Dan zijn de regels precies die van onze check [22], op die tag.
- **Let op het verschil dat jullie zelf noemden:** `locale_index` leest álle `Locales/*.lua` (ook vertalingen), niet
  alleen `enUS.lua`; `routed_words` kijkt alleen naar routing-patronen (strenger dan "elk gequote Lua-woord"). Wie die
  twee gebruikt, krijgt dus onze, strengere regels.
- **Liever `git show <tag>:<pad>` binnen de functies?** Dat kan als optionele lezer-parameter; dat is een wijziging in
  ons script en vraagt Robs ja. Met de temp-map is het niet nodig.
- Status: beantwoord door de bouwchat, 11 nov.

## 11 nov 2026 — MH zegt het als je net een upgrade oppakt
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Komt er gear in je tas die duidelijk beter is dan wat je draagt, dan zegt een kort bericht op je scherm
                  waarom: "Upgrade in your bags: [Snow Boots] — +3 Strength over what you wear (main stats for a
                  Paladin)." Je hoeft je tas niet meer open te houden. *(niet in het spel getest)*
- Knoplabels:     PICKUP_FMT
- Commando's:     /mh pickup (aan/uit en de laatste beslissing)
- Spel:           Midnight + Forever

## 11 nov 2026 — `/mh selftest`: MH kijkt of zijn eigen spelnummers in jouw spel bestaan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee (vooral een hulpmiddel voor ons; misschien later als "ondersteuning")
- Speler ziet:    `/mh selftest` → "all 1164 numbers exist in this game" of welke niet. Zegt óf iets bestaat, niet of
                  het werkt. Ook: het kick/dispel-icoon (`/mh prompt`) kan nu met Shift+scroll groter/kleiner.
                  *(niet in het spel getest)*
- Knoplabels:     CMDLIST_SELFTEST
- Commando's:     /mh selftest
- Spel:           Midnight + Forever

## 11 nov 2026 — Forever: een groene regel in de tooltip zegt waarom gear beter is
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Muis op gear die beter is dan wat je draagt: "MH: +3 Strength, +2 Stamina over what you wear (main
                  stats for a Paladin)." Geen regel bij slechtere gear of gear die je niet kunt dragen. *(niet in het
                  spel getest)*
- Knoplabels:     FGEAR_TIP_FMT
- Commando's:     /mh geartip (aan/uit en de laatste beslissing)
- Spel:           Forever

## 11 nov 2026 — De buff-melding noemt de buff en zegt wat je moet doen
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Onder het buff-icoon staat geen rood "MISSING" meer maar een zin in goud, bijvoorbeeld "Blessing of
                  Might is not on you. Click the icon to cast it." In een gevecht: "… Cast it from your bars." Forever:
                  een Greater Blessing telt nu ook als aanwezig. *(niet in het spel getest)*
- Knoplabels:     MBUFF_TXT_MISSING_SAY, MBUFF_TXT_AURA_SAY, MBUFF_SAY_CLICK, MBUFF_SAY_IN_COMBAT
- Commando's:     /mh buffs (Forever, toont de zin), /mh mbuff
- Spel:           Midnight + Forever

## 11 nov 2026 — Forever: de pijl leert waar trainers en verkopers echt staan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Praat je met een trainer of verkoper, dan onthoudt MH waar die staat, en de pijl wijst er voortaan
                  precies heen (op al je characters). Vlakbij zegt de pijl "You're there: look around, they stand right
                  here." *(niet in het spel getest)*
- Knoplabels:     FARROW_NEAR_NPC
- Commando's:     /mh travel (toont hoeveel plekken geleerd zijn)
- Spel:           Forever

## 11 nov 2026 — Forever: MH zegt welke spells van een class-quest komen
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Het trainervenster zegt bij een spell die eerst een quest-rank nodig heeft "(from a class quest, not from
                  the trainer)". De How you play-kaart zegt het bij Redemption, Aquatic Form en de Priest-rasspells, en dat
                  Judgement alleen werkt als er een seal aan staat. *(niet in het spel getest)*
- Knoplabels:     FTRAIN_NEEDS_QUEST_FMT
- Commando's:     /mh trainer
- Spel:           Forever

## 11 nov 2026 — Forever: waarschuwing als je zonder Hearthstone over het water reist
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Gaat je route over het water (boot, zeppelin) en heb je geen Hearthstone in je tassen, dan zegt MH één keer
                  in de chat, en in het wapentrainer-venster, dat de weg terug dezelfde lange reis is. *(niet in het spel getest)*
- Knoplabels:     FTRAVEL_NO_HEARTH, FTRAVEL_NO_HEARTH_CHAT
- Commando's:     /mh travel (toont ook je aantal Hearthstones)
- Spel:           Forever

## 11 nov 2026 — Forever: de reisplanner, eerste stap gezien
- Status-update van de regel hieronder: Rob zag op 11 nov met een Horde-Paladin in Tirisfal de pijl en het venster naar
  de zeppelin naar Durotar wijzen *(getest door Rob, alleen de eerste stap)*. Nog steeds **alleen op main**.

## 10 nov 2026 — Forever: de pijl wijst de boot, zeppelin, tram of het portaal aan
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in (deze commit)
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Staat je doel op een ander continent, op Teldrassil, of in Ironforge terwijl jij in Stormwind bent, dan
                  wijst de pijl eerst naar de boot, de zeppelin, de Deeprun Tram of het roze portaal. Het wapentrainer-venster
                  beschrijft de weg vanaf waar jij staat. *(niet in het spel getest)*
- Knoplabels:     FTRAVEL_BOAT_FMT, FTRAVEL_TRAM_FMT, FTRAVEL_PORTAL_FMT, FTRAVEL_ZEPPELIN_FMT
- Commando's:     /mh travel
- Spel:           Forever

## 10 nov 2026 — Midnight: macro's tonen spellnamen in jouw taal
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in ce48fb7
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    De oude Interrupt- en Utility-macro's in het Macro's-tabblad gebruiken de spellnamen van je eigen client
                  (Duits, Frans …). Op een Engelse client verandert niets. *(niet in het spel getest)*
- Knoplabels:     geen nieuwe
- Commando's:     /mh macros, /mh macrocheck
- Spel:           Midnight

## 10 nov 2026 — Midnight: "Top 5" macro's per spec + knop Maken
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in d264e54
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Het Macro's-tabblad opent op "Top 5": de vijf macro's die spelers het meest gebruiken voor jouw spec, in
                  jouw taal. Met Maken staat de macro meteen in je macroboek. *(niet in het spel getest)*
- Knoplabels:     MACROS_TYPE_TOP, MACROS_MAKE_BUTTON (uitleg: MACROS_TOP_SUBTITLE)
- Commando's:     /mh macros
- Spel:           Midnight

## 10 nov 2026 — Forever: handige macro's (algemeen, top 5 per klasse, top 3 per spec)
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in a581be7, 163ccc7, ad39568, 36d6d00
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een venster met kant-en-klare macro's: algemene, de vijf populairste voor je klasse en de drie
                  populairste voor je spec, met uitleg waarom. De Attack-macro schiet nu ook voor hunters en wand-gebruikers.
                  *(Attack-macro melee getest door Rob; de rest niet)*
- Knoplabels:     FMAC_TITLE, FMAC_CLASS_HEADER_FMT, FMAC_SPEC_HEADER_FMT
- Commando's:     /mh macros, /mh mouseover
- Spel:           Forever

## 10 nov 2026 — Forever: wapentrainers
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 1d95a6c
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Welke wapens je klasse kan leren, bij wie, wat het kost en vanaf welk level, met een pijl naar de trainer.
                  *(niet in het spel getest)*
- Knoplabels:     FWEAP_TITLE
- Commando's:     /mh weapons
- Spel:           Forever

## 10 nov 2026 — Forever: "Waar koop ik dit?" + tegels in de Ik-kamer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 0e16b14, 51c4c03
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Waar je beroepsgereedschap (hengel, mijnhouweel, mes, hamer …) en General Goods / Trade Supplies koopt,
                  dichtstbijzijnde eerst, met een pijl erheen. Leer je een beroep zonder gereedschap, dan noemt een klein
                  venster de dichtstbijzijnde verkoper. Tegels voor Handige macro's en Waar koop ik dit? in de Ik-kamer.
                  *(niet in het spel getest)*
- Knoplabels:     FVEND_TITLE
- Commando's:     /mh vendor, /mh vendor fishing|mining|skinning|hammer|tinder|thief|general|trade
- Spel:           Forever

## 9–10 nov 2026 — Forever: waarschuwing voor je hengel
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 85f7f5a, c6206e0
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een melding als je een vijand kiest terwijl je hengel nog in je handen is, met wat je terug moet zetten.
                  Geen WEAPON BUFF-melding meer met een hengel. *(niet in het spel getest)*
- Knoplabels:     FWARN_POLE_MSG
- Commando's:     /mh pole on, /mh pole off
- Spel:           Forever

## 9 nov 2026 — Forever: beroepentrainers + pijl naar een trainer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in e810976, 950a70d, 6a5bcc7
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Een venster met elke beroepentrainer voor jouw kant, met een pijl erheen. De pijl stopt pas bij de trainer
                  waar hij naar wijst. *(niet in het spel getest)*
- Knoplabels:     FPROF_TITLE
- Commando's:     /mh trainers, /mh trainers <beroep>
- Spel:           Forever

## 9 nov 2026 — Forever: oude spell-ranks op je balken
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 8bee56e
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    MH vindt knoppen op je actiebalken die nog een oude rank casten en zet ze met één klik op de nieuwste.
                  *(getest door Rob: werkt, er was nog niets te vervangen)*
- Knoplabels:     FRANK_BTN_FMT, FRANK_BTN_TIP_TITLE
- Commando's:     /mh ranks, /mh ranks fix, /mh ranks auto on|off
- Spel:           Forever

## 9 nov 2026 — Forever: "Deze week in Forever" + Ik-kamer
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 5c745d3, 1ced625
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    Op de startpagina: wanneer de week- en dagreset is, welke feestdagen er vandaag zijn, je raid-lockouts.
                  De Ik-kamer toont zijn kaarten als raster. *(/mh week getest door Rob)*
- Knoplabels:     FWEEK_HEADER, TAB_HOME_FOREVER
- Commando's:     /mh week
- Spel:           Forever

## 9 nov 2026 — Midnight: 20 "Zo speel je"-kaarten bijgewerkt, niet laden in Talebound
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 65bc89c, 5173498
- Status:         staat op CurseForge
- Mag op de site: nee
- Speler ziet:    De speelkaarten van 20 specs volgen de gidsen van eind oktober. MH laadt niet in Talebound (12.1.7).
                  *(laden getest door Rob)*
- Knoplabels:     geen nieuwe
- Commando's:     geen nieuwe
- Spel:           Midnight

## 9 nov 2026 — Midnight: 12.1.7 klaargezet (VERBORGEN tot de patch)
- Tag + commit:   v5.1.0 (ef2b38e) / gebouwd in 65bc89c, 5c745d3
- Status:         staat op CurseForge
- Mag op de site: nee — ook na de release niet vóór patch 12.1.7 live is: de spelers zien het pas dan.
- Speler ziet:    Codex-artikelen Turbulent Timeways VI en Lorewalking, en de mount-teller Timeways VI. Verborgen tot de
                  client 12.1.7 (interface 120107 / achievement 64207) is.
- Knoplabels:     MOUNTPROG_TIMEWAYS6_HOWTO
- Commando's:     geen
- Spel:           Midnight

## 8 nov 2026 — release 5.0.2
- Tag + commit:   v5.0.2 / 18e5787 (tag-object d279d3e)
- Status:         staat op CurseForge — GEMETEN 10 nov via de CurseForge-API: `MidnightHelper-v5.0.2.zip` (12.0.7–12.1.7)
                  en `MidnightHelper-v5.0.2-forever.zip` (1.60.1), allebei Release, 8 nov 12:36/12:37 UTC.
- Mag op de site: ja — staat op CurseForge. (Robs letterlijke go voor de site staat niet in dit bestand; die liep
                  toen via SendMessage.)
- Speler ziet:    zie `RELEASE_NOTES.md` / `docs/CURSEFORGE_5.0.2.md`.
- Knoplabels:     —
- Commando's:     —
- Spel:           allebei
