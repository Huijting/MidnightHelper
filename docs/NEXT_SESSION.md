# Next session — Midnight Helper

**Laatste update:** 2026-05-19  
**Versie op schijf:** `1.3.1` (TOC)  
**Branch:** `main` — i18n Phase A + B gecommit en gepusht

**CurseForge:** upload alleen als de gebruiker het expliciet vraagt.

---

## Waar we gebleven zijn (kort)

- **i18n Phase A:** auto-locale (`/mh lang auto`), status-label, EN/NL/DE in settings.
- **i18n Phase B:** Duitse UI-shell (`Locales/deDE.lua`), DE “In Gruppen”, knopfixes (bountiful **großzügige Tiefe**, vault **Große Schatzkammer**).
- **Nog niet:** DE delve tip bodies, advisor-teksten, frFR, Sie→du polish.

**Volledige draad + Blizzard-termen + testlijst:** → [`docs/I18N_ROADMAP.md`](I18N_ROADMAP.md)

---

## Recent af (1.3.1 context)

- Delve UI: alleen in delve, party share, items popup, coach scaling
- Versienummer in UI + broker tooltip
- Darkway / zone aliases / boss preview
- **DE locale shell** + auto-locale framework

---

## Test na pull (andere PC)

- [ ] `git pull` in `Interface\AddOns\MidnightHelper`
- [ ] `/reload` — `/mh lang de` — UI Duits, geen errors
- [ ] Delves-knop: **Nächste großzügige Tiefe finden**
- [ ] Account snapshot-knoppen niet afgekapt
- [ ] `/mh lang auto` op EN-client → Engels; op DE-client → Deutsch

---

## Volgende stap (aanbevolen)

1. **frFR Phase B** (Frans shell — zie I18N_ROADMAP)  
   of  
2. **deDE polish** — du-vorm, DelveTips `DELVE_NAME_*`, optioneel 1–2 tip-secties vertalen

---

## Git handoff (twee PC’s)

```text
git pull
/reload in WoW
```

**Cursor:** nieuwe chat → `@docs/I18N_ROADMAP.md` + `@docs/NEXT_SESSION.md` + “ga verder met frFR” of “deDE polish”.

**WoW-pad:** `_retail_\Interface\AddOns\MidnightHelper`

---

## Backlog (niet i18n)

| Item | Status |
|------|--------|
| CurseForge 1.3.1 upload | op aanvraag |
| SMC checklist quest IDs | paused |
| Keyboard layouts meer classes | later |
| Alt snapshot export/import | paused |
