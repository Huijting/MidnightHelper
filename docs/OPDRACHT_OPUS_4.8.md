# Opdracht: Midnight Helper — backlog-uitvoering + kwaliteitssprong

_Voor: Claude Opus 4.8 · Opgesteld: 2026-07-06 (Claude Fable 5, na de panel-review) · Opdrachtgever: Rob._

## Doel
Voer de review-backlog uit en til de addon daarna boven het addon-gemiddelde uit.
Kwaliteit gaat vóór snelheid; de nieuweling-vriendelijkheid ("Carola") is onze USP en
mag bij elke wijziging niet verslechteren.

## Lees eerst, in deze volgorde
1. `CLAUDE.md` — werkafspraken (Nederlands, beknopt, never-lie, Rob test in-game).
2. `docs/REVIEW_2026-07.md` — het volledige reviewrapport. **Sectie 4 is jouw werklijst**
   (21 items, genummerd); sectie 3 heeft per bevinding locatie + fix-richting + waarom.
3. `docs/NEXT_SESSION.md` — lopende context.

## Al gedaan — niet opnieuw doen
- Backlog-item 1 (P0): `CLAUDE.md` uit de release-zip (package.ps1-fix, commit `0924d25`);
  schone 2.4.1-zip staat in `dist/` en is/wordt door Rob op CF vervangen.

## Harde regels
- **Never-lie:** verzin géén spell-IDs, coords, quest-IDs of API-namen. Wat je niet uit
  de repo of een officiële bron (warcraft.wiki.gg, Wowhead 12.0.7) kunt staven, parkeer
  je met een concrete in-game verificatievraag voor Rob.
- **Geen versie-bump, geen release-docs, geen CF-acties** tot Rob "af" of "go" zegt.
- **Working tree kan Rob's WIP bevatten** (bij opstellen: Core.lua `/mh capture`,
  Openables knowledge-detectie, Rares/Achievements/AchievementsData): niet reverten en
  niet meecommitten met jouw werk.
- Na elke wijziging: `python tools/lua_syntax_check.py`. Eén logische wijziging per commit.
- Match de bestaande stijl (tabs, comment-toon, `ns`-namespace, `ns:L`-localisatie:
  nieuwe strings in enUS + nlNL, overige 5 talen via `Locales/Translations2026.lua`).

## Vraag Rob éérst deze in-game antwoorden (rapport §5) — parkeer wat erop wacht
- §5.2 Eruundi-mapID, §5.3 `/dump C_Secrets.ShouldAurasBeSecret`, §5.6 Delver's
  Call-aantal, §5.7 placeholder-IDs Config.lua, §5.11 mapIDs 2536/2646, §5.12
  `WORLDWIDE_SCROLL_STEP`. Alles wat níet op een antwoord wacht, pak je gewoon op.

## Fasering (na elke fase: stop, samenvatting + testinstructies voor Rob)

**Fase 1 — Repareren (backlog 2–6):** CI-workflow fixen (dode audit-step eruit,
Lua-syntaxcheck behouden, README-refs mee); Divine Toll-dupe; comms-lockdown-guard
(één gedeelde helper, alle 6 senders); keybind-matching op spellID (Paladin als pilot,
IDs alléén uit geverifieerde bron — anders parkeren); Eruundi/Ash'an zodra Rob §5.2 levert.

**Fase 2 — Onboarding-excellentie (backlog 7–10 + 16–17):** first-run-ervaring
(firstRunSeen-vlag → Start Here of chathint+popup); tour-ESC-fix; stale settings-tooltip
(7 talen); Home-blok → verwijzing naar Start Here/tour; jargon-pass (glossary: BiS, proc,
uptime, ilvl, vault-slot + kaartkop-tooltips keybind-coach); UX-cluster F4.6
(vensterpositie onthouden, expliciete defaults, AccessibleAlerts-toggle in native
settings, tekstschaal op Start Here/tour). Dit is de fase die ons onderscheidt —
schrijf elke nieuwe tekst alsof Carola meeleest.

**Fase 3 — Fundament (backlog 11–14, 18):** SavedVariables-schemaversie + migratietabel;
NativeArrow-GC-fix; RitualBossCoach-events scenario-gated; MissingBuff secrets-API
(na §5.3); daarna de perf/hygiëne-pass F3.7+F3.8 als één opruimronde.

**Fase 4 — Boven de rest uitstijgen (backlog 15, 19–21):** TOC-metadata compleet
(Author, Category, X-IDs, AddonCompartment via de bestaande LDB-launcher, meertalige
Notes) + README actueel; `.pkgmeta` + BigWigs packager GitHub Action (CF/Wago/WoWI —
secrets vraag je aan Rob); Wago/WoWI-descriptions + CF-description met doelgroep-hook
en een "See it in action"-sectie (lever Rob een lijstje van 4–5 gewenste screenshots/GIF
met exacte scène-omschrijving — schieten doet Rob); data-afronding (LVL8090-vertalingen,
hero/Apex-entries na Rob's §5.4-test, Val/Naigtal treasure/lore-dekking, consumables-
regeneratie); LuaLS-basis (`.luarc.json` + `ns`/`MHDB`-annotaties).

## Definitie van "af" per item
Code gewijzigd + syntaxcheck groen + gecommit + in het rapport (`docs/REVIEW_2026-07.md`)
het item afgevinkt met een one-liner wat er is gedaan + testinstructie voor Rob waar
in-game bevestiging nodig is. Rob's `/reload` is het eindoordeel.
