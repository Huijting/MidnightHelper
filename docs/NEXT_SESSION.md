# Next session — Midnight Helper

**Laatste update:** 2026-05-23  
**Versie op schijf:** `1.3.1` (TOC)  
**Branch:** `main` — **veel i18n-werk nog niet gecommit** (zie `git status`)

**CurseForge:** upload alleen als de gebruiker het expliciet vraagt.

---

## Klaar in working tree (niet op remote tot commit)

| Onderdeel | Status |
|-----------|--------|
| **frFR Phase B** | `Locales/frFR.lua`, TOC, Broker-knop, `GROUP_FR` |
| **esES Phase B** | `Locales/esES.lua`, TOC, Broker-knop Español, `GROUP_ES`, tips/delve merges |
| **deDE polish** | Academy du, tab **Tiefen & Kammer** |
| **Consumables** | `CONS_NOTE_*` via `Locales/ConsumablesNotes.lua` (EN/NL/DE/FR) |
| **Leveling tips** | `GuideTips.lua` merges **deDE** + **frFR**; spellnamen via `GuideTipText.lua` + `GuideTipSpellNames.lua` |
| **Delve Coach bodies** | `DelveTips.lua` merges **deDE** + **frFR**; share-knoppen dynamische breedte |
| **UI fix** | `FitSidebarTabButton` vóór `RefreshLocaleUI` (reload-crash opgelost) |

**Nog Engels (Phase C):** `GUIDE_ADVISOR_*`, per-spec `GUIDE_GEAR_*` voor alle packs.

---

## Volgende stap (aanbevolen)

1. **/reload**-test: `/mh lang es`, `/mh lang fr`, `/mh lang de`, Delve Coach Atal'Aman
2. Optioneel: **commit + push** van i18n working tree
3. **ptBR Phase B** of **esES polish** (advisor/gear blijven EN)

---

## Test checklist

- [ ] `/reload` — geen Lua-errors
- [ ] `/mh lang es` — tab **Profundidades & Bóveda**, guide + delve tips niet EN
- [ ] `/mh lang fr` — tab **Gouffres & Chambre**, guide + delve tips niet EN
- [ ] `/mh lang de` — consumable-notes + delve coach DE
- [ ] Delve Coach — knoppen **Brief teilen** / **Brief partager** passen
- [ ] Leveling guide — spellnamen uit client (niet hardcoded EN in tip)

---

## Git (twee PC’s)

```text
git pull
/reload in WoW
```

**WoW-pad:** `_retail_\Interface\AddOns\MidnightHelper`

**Tools (niet committen):** `tools/_guide_groups_*.txt`, `tools/polish_deDE_du.py` — optioneel `.gitignore`

---

## Backlog (niet i18n)

| Item | Status |
|------|--------|
| CurseForge 1.3.1 upload | op aanvraag |
| SMC checklist quest IDs | paused |
