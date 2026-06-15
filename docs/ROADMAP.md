# Midnight Helper — Roadmap / backlog

Samengetrokken uit SESSION_NOTES "Open / volgende stappen", TOMORROW §3 en de
plan-docs (stand: 10 juni 2026, na de 1.6.0-batch). Volgorde binnen een blok ≈
prioriteit. Details/bronnen staan in de genoemde docs; dit is de overzichtslijst.

## 💡 Feature-backlog (15 juni — "onthouden", uit de top-lijst)

In aanbouw nu: **Turbulent Timeways-tracker** + **Omnium Folio-companion** (#1+#2).
De rest, bewaard voor later (≈ prioriteit):

- [~] **Weekly-checklist-pariteit** — Abundant Offerings (89507), A Nightmarish
      Task (94446), Gnawing Curiosity (93784), Arcantina (93767) ✅ + **Voidforge
      94623 toegevoegd (15 jun, batch #6)**. RESTEREND (geen bevestigde quest-ID →
      in-game capturen): Beacon of Hope, Prey Hunts, Saltheril's Soiree, Bonus Event.
- [ ] **Live event-voortgangsbalken** (Void Incursion % e.d.) in de Events-tab —
      taint-veilige `C_UIWidgetManager`-reads via de ticker (zie taint-ontwerpregel).
- [x] **Meer raid-coaches** (15 jun, batch #4) — alle 3 raids gebouwd in
      `RaidCoachData.lua` + `RaidTips.lua` (6 talen): The Dreamrift (Chimaerus),
      The Voidspire (6 bosses), March on Quel'Danas (Belo'ren + Midnight Falls).
      Encounter-IDs uit DBM, auto-open op ENCOUNTER_START. **Crown/L'ura/Chimaerus
      per-stage "key casts" toegevoegd uit EXBossData (15 jun, batch #6)** — spell-
      links + actie (dodge/interrupt/move/defensive). Open: Voidspire-bossen nog
      rijker maken uit EXBoss; boss-volgorde (Salhadaar vs Vaelgor) in-game bevestigen.
- [x] **Mythic+-tab** (15 jun, batch #4) — `MythicPlusData.lua` + `MythicPlus.lua`
      (6 talen) + subtab in DungeonGuide: affix-ladder, Xal'atath's Bargain-
      varianten, 8-dungeon-pool, must-kicks. **Must-kicks compleet voor alle 8**
      (15 jun, batch #6): Magisters'/Nexus-Point met bevestigde spell-links,
      Windrunner Spire met namen (IDs nog "not found"), Maisara namen. Klaar.
- [ ] **Reward-galleries** voor meer events/raids (Sporefall 269240/268292…,
      Showdowns 275664/275663…); Haranir-decor zodra item-IDs bekend.
- [ ] **Rares.lua-uitbreiding** met HandyNotes live-zone-coords + kill-quest-IDs
      (eversong/harandar/voidstorm/zulaman; Val/Naigtal later).
- [ ] **Emote-listener afmaken** (emote-dump + match) bovenop de cast-alerts.
- [ ] **Collectibles-checklist per ritual site** (candle/meat/egg/kelp/bone).
- [ ] **Void Rifts**-feature; **minLevel-vulling** weekly-givers.

## 🔥 12.0.7-voorbereiding (release ~16 of 30 juni — deadline!)

- [ ] **Val-data** (volgende PTR-rotatie): uiMapID, weekly "Showdown on Val"-ID,
      Pertinax-killquest, evt. Heroic-variant-ID, Voidstorm-portaal-mapID
      (→ portaal-knop verschijnt dan vanzelf). Zie PTR_12.0.7_DATA.md.
- [ ] **Rares.lua Naigtal**: 8 npc-IDs verzameld; per rare nog coords +
      kill-quest-ID (PTR-instructies §3b).
- [ ] **Folio**: Mote of Omnial Inquiry-ID → checklist-regel.
- [ ] **Vervolg-weekly-keuze** "Unity against the Void": quest-IDs van
      Disruptions Continue / Dangerous Enemies dumpen.
- [ ] **Sporefall**: telt Rotmire-kill in de Raids-vaultrij? (`GetActivities(3)`)
- [ ] **Silvermoon-portaal-knop** naar Naigtal/Val in WorldContent
      (RouteShowdownPortal dekt nu alleen Voidstorm).
- [ ] Bij release: `120005` uit de TOC.

## Ritual Coach (plan: RITUAL_COACH_PLAN.md)

- [ ] **Fase 4 — echte unlock-tracking** per challenge via quest-flags
      (IsPlayerSpell bleek selectie); IDs dumpen bij de volgende unlock.
- [ ] "A Corrupted Path" vs in-site-banner **"Void Reversal"** verduidelijken;
      Ger'lok-eindboss-kill bevestigen; bestaat een tweede scenario-layout?
- [ ] **Share-infra generaliseren** (MHShareSync, proto 2) — ná de CF-release.
- [ ] Copy-knop voor ritual-share (`GetRitualShareCopyText` ligt klaar).
- [ ] Ritual-weekly-hint ook op Start Here stap 5.
- [ ] Voidlight Marl currency-ID (alleen nodig als we 'm tonen).
- [ ] Cross-locale share-test met 2 spelers (Delve én Ritual; solo ✅).

## 🆕 Dungeon Coach (Rob-wens, 10 juni avond — plan klaar, wacht op review)

- [x] Plan + besluiten ✅; **fase 1+2 GEBOUWD (10 jun avond)**: Dungeons-tab
      (Deze week | Dungeons 101 | Coach), roster-data, 40 keys EN/NL.
      Wacht op Robs in-game review + Cursor-luacheck.
- [ ] **Fase 3**: boss-stappen Normal per dungeon (research-batch, eigen
      tekst; Rob verifieert in follower-runs). Launch-only EJ-IDs dumpen.
- [ ] **Fase 4**: Heroic-secties + entree-waypoints + rol-filter.
- [ ] **Fase 5**: share-generalisatie (MHShareSync proto 2) + dungeon-share.
- [ ] **Fase 6**: lokalisatie ×4. **Later**: Mythic/M+-fase.

## Delve & Ritual Log (Rob-wens, 10 juni — ná de 1.6.0-release)

- [x] **Delve & Ritual Log** (15 jun, batch #6) — `RitualLog.lua` logt ritual-
      runs in't DelveHistory-model; paneel toont "Rituals"-sectie; tab hernoemd;
      uitklap-bug (`row._mhKey`) meteen gefixt. Open: tier-leesbaarheid in-game
      bevestigen (Rob test vanavond); Spoils bewust niet (waarschijnlijk niet leesbaar).

## Professions (plan: PROFESSION_ACADEMY_PLAN.md)

- [x] ~~**Trainer-weekly-IDs van de overige 10 profs**~~ ✅ compleet (10 jun,
      via Robs MidnightRoutine-addon, 3× gekruisvalideerd — zie SESSION_NOTES
      vervolg 13). Restje: in-game spot-check per prof bij het afronden.
- [ ] Weekly treasure-drop-flags 935xx in-game verifiëren (Wowhead-lijst) →
      concept B-checklist verder vullen.
- [ ] Tree Advisor: doel "goedkoop levelen" (bronnen nodig — never invent);
      advies filtert nu niet de prof die je al hebt (1-prof-nicety).
- [ ] skillLine-mapping centraliseren (Profession.lua vs ProfessionAcademyData);
      essence-data idem (Profession.lua heeft eigen kopie).
- [ ] Treasure-pijl: doorschuiven naar de volgende pin bij aankomst (nicety);
      pijl automatisch op de portal i.p.v. één klik; ooit AddSmartTomTomWay
      DRY via ShowTravelAssistFor.
- [ ] (Later) Concept D: Profession Coach — pas na validatie A+B+C.

## Reset-routine & weekly quest givers (nieuw 10 juni)

- [ ] **Halduron**: per week het nieuwe dungeon-weekly-ID toevoegen (93761 =
      Windrunner Spire-week) tot de reeks rond is; **Aethas**: IDs per event.
- [ ] **minLevel/eligibility** vullen: lukt oppakken op een low-level alt?
- [ ] Vault-coördinaat centraliseren (VaultReminder + ResetRoutine → één
      ns-constante).
- [ ] Vault-tooltip: raid-slot "level"-semantiek verifiëren (difficulty-
      encoding?) → dan ook daar level tonen.

## Nieuw-spelers / brainstorm (8 juni)

- [x] **Currency-overzicht** ✅ (15 jun, batch #8/#9) — "Valuta"-tab (`CurrencyGuide.lua`)
      met per-currency verdien/uitgeef-map, live saldo's, QM-waypoints + `{CURRENCY:}`-markup.
      (gear-roadmap nog open als aparte brok.)
- [ ] Start Here: per-stap vinkjes voor stap 1/2/6 (geen schoon signaal
      gevonden); optie "verberg na eerste week".

## Vertalingen / kwaliteit

- [ ] **MT-review-pass** oude machinevertalingen deDE/esES/ptBR: letterlijke
      `\n`-restanten + kwaliteit (CONS_SPEC_HINT-klasse fouten; frFR
      NBSP-normalisatie mag ook een keer).
- [ ] →/− render-check in-game (laag — sanitizers + sweep van 10 juni dekken
      vrijwel alles).

## Oude review-backlog (laag)

- [ ] SetVaultReminderOption popup-backfill voor upgraders; SMC-grid reflow;
      info-drawer inline; search-UX; compact-mode double-shrink.
- [ ] Reviewpunt: ts vs aparte vaultTs bij login-restore (Cursor akkoord met
      huidige aanpak — alleen heroverwegen bij klachten).

## Proces

- [ ] CF-release 1.6.0 (vandaag — zie 🎯-blok in SESSION_NOTES).
- [ ] Na release: share-infra-refactor pas oppakken als 1.6.0 stabiel draait.
