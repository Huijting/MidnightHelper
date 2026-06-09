# Morgen — test & uitzoek (Midnight Helper)

## ⭐ EERSTE TAAK (Rob, 9 juni): lokalisatie naar de overige talen

Alles wat we de laatste tijd gebouwd hebben staat nu alleen in **enUS + nlNL**
(rest valt terug op EN). Zet die strings ook in **deDE, frFR, esES, ptBR**.
Het gaat om de keys uit deze nieuwe/gewijzigde locale-bestanden + losse keys:
- `Locales/RitualTips.lua` — alle `RITUAL_*` (coach-secties, namen, tips,
  challenges, share, weekly-hint).
- `Locales/StartHere.lua` — alle `START_*` + `TAB_START_HERE`.
- `Locales/enUS.lua`/`nlNL.lua` — `PROF_GENERATE_TREASURES_BTN` /
  `PROF_GENERATE_BOOKS_BTN`.
Aanpak: per locale-bestand de EN-waarden vertalen (mens-kwaliteit, niet machine —
zie de oude `\n`-machinevertaal-problemen in de backlog). WoW-eigennamen
(challenge-namen, "Ritual Sites", "Bountiful Delves", spell-namen) onvertaald
laten. Daarna luacheck + key-audit (alle keys aanwezig in alle 6 talen).

---

Stand: 9 juni, avond. Begin met `/reload`, dan onderstaande. Details staan in
`SESSION_NOTES.md` (0b-blok + de losse secties).

## 1. Testen in-game (na /reload)

- [ ] **Start Here-tab** (gecorrigeerde content): subtitel "max level"; stap 1
      zonder "Bountiful Delves"; stap 4 met Tier-8/Restored-Coffer-Key-uitleg;
      stap 5 met de "Ritual Interest"-unlock. Bovenaan de **"Deze week: X/N"**-
      teller; stap 3 vault-nudge.
- [ ] **Void & Rituals — ritual-weekly-hint**: onder "Weekly quest … not
      completed" hoort nu **"Nog niet opgepakt — haal bij de Bazaar-hub"** te
      staan (jouw geval: renown unlocked, weekly niet in log).
- [ ] **Ritual Coach** (Void & Rituals): challenge-lijst toont nu **mechanic +
      Spoils% + hoe-ontgrendelen**, GEEN valse "unlocked/locked"-status meer;
      icoontjes renderen; gesorteerd op Spoils.
- [ ] **Ritual-share**: "Share challenge tips"-knop → in party de 9 regels
      (confirm-popup); solo met share-testmodus aan → self-whisper.
- [ ] **Generate Treasures** (Professions): pak een treasure, loop/vlieg een
      zonegrens over → **pijl blijft staan** en wijst naar de dichtstbijzijnde
      (re-assert is teruggedraaid; enkele crazy-arrow overleeft zones zelf).
- [ ] **Taal wisselen**: Start Here, Coach, hint en share vertalen mee.

## 2. Uitzoeken / bevestigen

- [ ] **Ritual-weekly afronden**: pak "Midnight: Ritual Sites" op (Bazaar-hub,
      Lilatha/Darkglen) + doe 'm → springen de World-tab én de Start Here-teller
      op groen? (Bevestigt de hele weekly-detectie end-to-end.)
- [ ] **Max level = 90?** Sanity-check — alle guides + de Lilatha-tooltip zeggen
      90; Start Here gebruikt nu "max level". Klopt dat met jouw realm?
- [ ] **Start Here-volgorde**: matcht de roadmap-volgorde/gating nu met je
      live-ervaring? Nog andere onnauwkeurigheden gespot?

## 3. Grotere open punten (geen haast)

- Ritual Coach **fase 4**: échte unlock-tracking via de unlock-quest-flags
  (NPC-turn-ins). Vereist een `/dump` van die quest-IDs zodra je ze unlockt —
  IsPlayerSpell bleek selectie, niet unlock.
- Dezelfde **weekly-hint op Start Here stap 5** (nu alleen op de World-tab).
- **Cross-locale share-test** met 2 spelers (Delve én Ritual) — laatste 0a-punt.
- **Woensdag-reset (10 juni)**: weekly-semantiek + vault-reset meemaken.
- **CF-release**: nog NIET — eerst de reset + paar dagen daily-driven (jouw call).
- Nieuwe brokken uit de beginner-brainstorm: **currency-overzicht** of
  **gear-roadmap**.

## 4. Cursor — commit + push (nu doen, om alles veilig te stellen)

Branch `main` staat **5 commits ahead** van origin + onderstaande uncommitted.
Draai eerst luacheck/loadfile (de Cowork-mount gaf truncatie-false-positives;
host-bestanden zijn compleet geverifieerd), commit dan en **push**.

Uncommitted, gegroepeerd:

1. **Ritual Coach fase 3 (share):** `Modules/RitualShare.lua`,
   `Modules/RitualShareSync.lua` (nieuw), `Modules/WorldContent.lua`
   (share-knop), `Locales/RitualTips.lua` (RITUAL_SHARE_*-keys), TOC.
2. **Start Here-tab:** `Modules/StartHere.lua`, `Locales/StartHere.lua` (nieuw),
   `UI.lua` (tab-registratie), TOC. Incl. weekly-teller + vault-nudge en de
   content-accuratesse-pass (max level / regular-vs-Bountiful Delves /
   Ritual-Interest-unlock).
3. **Ritual-weekly-hint + Coach-correctie:** `Modules/RitualSites.lua`
   (`GetRitualWeeklyHint`), `Modules/RitualCoach.lua` (unlock-status verwijderd —
   was selectie, niet unlock), `Modules/WorldContent.lua` (hint-regel + altijd
   how-to-unlock), `Locales/RitualTips.lua` (RITUAL_WEEKLY_HINT_*-keys).
4. **Generate Treasures-fix:** `Modules/Profession.lua` (alleen pin 1 krijgt de
   crazy-arrow; re-assert-experiment teruggedraaid).
5. **Docs:** `docs/RITUAL_COACH_PLAN.md`, `docs/SESSION_NOTES.md`, `docs/TOMORROW.md`.

Changelog-regels: "Nieuw: Start Here-tab (new-player roadmap)", "Nieuw: Ritual
Coach (scenario + challenge-referentie + share)", "Fix: Generate Treasures-pijl",
"Ritual-weekly-hint (unlock/oppakken)".
