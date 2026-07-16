# Testronde 2.8.0 — in-game checklist

64 commits sinds `v2.7.0`. Deze lijst is voor Rob's (+ Cisca's) in-game test vóór
de release. Afvinken door `[ ]` → `[x]`. Prioriteit:

- 🔴 **Moet** — nieuw/gedrag-veranderend en nog niet (zeker) getest.
- 🟡 **Zou** — nieuwe feature, even zien of 't klopt.
- 🟢 **Snel** — smoke-test / verifiëren dat iets juist NIET zichtbaar is.

Rob = **Prot Paladin** (tank). Waar een andere rol/spec nodig is, staat het erbij.

---

## 🟢 0. Smoke-test (altijd eerst)

- [x] `/reload` → **geen Lua-fouten** (rood in chat). Hoofdvenster opent.
- [x] Alle tabbladen openen zonder error (Home, Delves, Dungeon Coach, Codex, Academy, Settings).

---

## 🔴 1. Death-recap popup  *(belangrijkste — was nog ongetest)*

- [ ] **Dungeon/raid:** ga dood → popup met **oorzaak + tip** (niet alleen een chatregel).
- [x] **Ritual site / delve:** ga dood → popup met **"open Blizzard's Death Recap" + tip**
      (12.x sluit daar het combat log af — daarom de doorverwijzing).
- [x] **Geen spam:** in ritual sites/delves **geen** `ADDON_ACTION_FORBIDDEN`-foutregels.
- [x] Diagnose zonder te sterven: `/mh death` → print de death-recap status.

## 🔴 2. Tank pull-summary  *(als tank)*

- [x] `/mh pullsummary` → aan. Doe een pull → na afloop een **samenvatting**
      (active-mitigation uptime %). Op Paladin: Shield of the Righteous-uptime. *(Druid-tank = Ironfur, werkt.)*
- [x] `/mh pullsummary boss` → alleen bij **bosses** een samenvatting, niet elke trash-pull. *(status via `/mh pullsummary status`)*
- [x] `/mh pullsummary popup` → toont 'm als **popup** i.p.v. chatregel.
- [ ] (Brewmaster Monk indien beschikbaar: Stagger-metric i.p.v. mitigation-uptime.)

## 🔴 3. Interrupt-scorecard  *(Spec 14)*

- [x] `/mh scorecard test` → toont een **voorbeeld-scorecard** (zonder delve nodig).
- [ ] `/mh scorecard` → aan. Na een run een **post-run samenvatting** (na een echte delve/ritual).
- [x] `/mh scorecard detail` → extra regel met exacte seconden. *(zichtbaar in de test: "vs avg −22s · fastest 3m 54s")*
- [x] Whiff-nudge (`/mh kicks alert`, opt-in, **lokaal**): eerlijk herwoord, **party-chat-shout verwijderd**.

---

## 🟡 4. Healer-toolkit + Academy  *(healer-spec nodig — Cisca?)*

- [x] `/mh healcds` → **cheat-sheet van healing-cooldowns** voor je spec, met soort-labels.
- [ ] Academy → **Healer-toolkit**: spec-aware, **tooltips bij hover** over de spells.
- [ ] Academy → **heal-course** (beginner) is uitgebreid/leest goed.
- [ ] "Wat kun jij dispellen"-referentie klopt voor je spec.
- [x] `/mh dispelprobe` (+ `watch`) → meldt of party/raid-debuffs **leesbaar** of **secret** zijn. *(secret bevestigd: live dispel niet mogelijk)*

## 🟡 5. Tank- & DPS-toolkit  *(per rol)*

- [x] Academy → **Tank-toolkit**: active mitigation + "personal defensives" (hernoemd).
- [x] Academy → **DPS-toolkit**: nieuw; personal defensives + secundaire damage-cooldown. *(Feral: Tiger's Fury + Feral Frenzy toegevoegd)*
- [x] Klopt de spec-info met wat je op je balk hebt? (never-lie-check). *(nu gefilterd op bekende spells: Berserk óf Incarnation)*

## 🟡 6. Mythic+ advisor  *(al deels getest)*

- [x] `/mh mplus` → advisor toont per keystone-level de **gear-hint** (verwijst naar
      keystone-tooltip / Great Vault — **geen** rare ilvl-tabel meer).
- [x] Per-dungeon **season-best** verschijnt ook zonder runs deze week (geen lege lijst).

## 🟡 7. Openables

- [ ] Items met **"Use: Collect N …"** (reward/currency-packs) worden herkend als openable.
- [ ] Cosmetische **appearances via Use** verschijnen (alleen ongecollecte, geen gear).
- [ ] Items met een **onvervulde requirement** (rode tooltip-regel) worden verborgen.

## 🟡 8. Keybind-coach  *(als Prot Paladin)*

- [ ] Interrupt-kaart toont de **off-interrupt cluster** (Spec 08 cross-listing) —
      Blinding Light hoort er NIET bij.
- [x] De keyboard-layout klopt met de nieuwe `alsoStop`/agent-audit-fixes. *(Feral geverifieerd)*
- [x] (Druid, indien beschikbaar: vormen op **Shift+R/T/X** in élke spec, Travel op R.)

## 🟡 9. Omnium Folio

- [ ] Char **mét** Folio (Midnight): de "open rune window"-knop opent het **Folio**-venster.
- [x] Levelling-char / char zonder Folio: knop opent **niet** het verkeerde landing-page. *(level-gate + toast, "het werkt")*

---

## 🟢 10. Season 2 / 12.1-content — moet DORMANT zijn op live

*(alles season-gated; op live 12.0.7 hoort het VERBORGEN te zijn.)*

- [x] Dungeon Coach: **geen** Altar of Fangs, King's Rest, Sethraliss, Ruby Life Pools zichtbaar.
- [x] Boss-lijst / zoek: **geen** The Venomous Abyss / Tidebound Grotto.
- [x] M+-pool = nog de **Season 1**-pool (8 dungeons), geen `[S2]`-badges.
- [x] (Optioneel op **PTR** (12.1) via `copy_to_ptr.bat`: dán verschijnen ze wél,
      met gelokaliseerde bossnamen = bewijs dat de IDs kloppen.)
      **GEDAAN 16 jul:** PTR toont Venomous Abyss, Tidebound Grotto, Altar of Fangs,
      Kings' Rest, Sethraliss, Ruby Life Pools. De EJ-naam "Kings' Rest" won van onze
      fallback "King's Rest" → **journalInstanceID 1041 resolvet bewezen** (idem 1030/1202).

---

## Na groen licht → release-spullen (ik doe dit in één keer op jouw "go")

- [ ] `.toc` `## Version` → 2.8.0
- [ ] `Modules/Changelog.lua` + `CHANGELOG_2_8_0_*` keys in `enUS.lua`
- [ ] `RELEASE_NOTES.md` (+ identieke `docs/CURSEFORGE_2.8.0.md`)
- [ ] `CHANGELOG.md`
- [ ] `CURSEFORGE_DESCRIPTION.md` bijwerken waar features wijzigen
- [ ] Tag `v2.8.0` → BigWigs-packager upload naar CF (Beta of Release — jouw keuze)
