# Midnight Helper — Roadmap / backlog

Samengetrokken uit SESSION_NOTES "Open / volgende stappen", TOMORROW §3 en de
plan-docs (stand: 10 juni 2026, na de 1.6.0-batch). Volgorde binnen een blok ≈
prioriteit. Details/bronnen staan in de genoemde docs; dit is de overzichtslijst.

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

## Delve & Ritual Log (Rob-wens, 10 juni — ná de 1.6.0-release)

- [ ] **Delve Log uitbreiden naar "Delve & Ritual Log"**: ritual-runs net zo
      loggen als delves (site, tier, tijd, doden, voltooid). Detectie via het
      scenario/instance-pad zoals DelveHistory; eerst in-game verifiëren wat
      betrouwbaar leesbaar is (tier uit scenario-info? Spoils waarschijnlijk
      niet). Bewust ná de release: heeft een echte ritual-run nodig om te
      testen. UI: zelfde paneel, sectie of filter per type.

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

- [ ] **Currency-overzicht** of **gear-roadmap** (volgende grote brok).
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
