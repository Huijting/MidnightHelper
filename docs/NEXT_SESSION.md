# Next session — Midnight Helper

**Laatste update:** 2026-05-23  
**Versie op schijf:** `1.3.1` (TOC)  
**CurseForge:** **niet pushen** tot CF gate in `I18N_ROADMAP.md` volledig ✅

---

## CF-talen (7) — status

| Taal | B | C | Volgende |
|------|---|---|----------|
| enUS / nlNL | ✅ | ✅ | polish NL doorlopend |
| deDE / frFR / esES | ✅ | ✅ | polish + in-game Blizzard |
| **ptBR** | 🔲 | 🔲 | Phase B (patroon esES) |
| **ruRU** | 🔲 | 🔲 | Phase B (patroon esES) |

**Phase C klaar:** `Locales/GuideAdvisor.lua` — advisor + per-spec gear voor deDE, frFR, esES.  
**Generator:** `python tools/build_guide_phase_c.py` (~35 min).

---

## Volgende stap

1. **ptBR Phase B** — shell, TOC, broker, groups, consumables, tips/delve merges  
2. **ptBR Phase C** — `build_guide_phase_c.py` uitbreiden met `ptBR`  
3. **ruRU Phase B → C** — zelfde; Blizzard-termen uit ruRU-client  
4. **Polish** alle packs (DE Sie→du, FR vous, ES profundidad, advisor-tekst)  
5. About/changelog bijwerken → **dan pas CF**

---

## Test checklist (Phase C)

- [ ] `/reload` — `GuideAdvisor.lua` laadt zonder errors
- [ ] `/mh lang de` — Leveling Guide → Advisor-tab per spec **Duits** (niet EN)
- [ ] `/mh lang fr` / `es` — idem
- [ ] Gear-paneel per spec — vertaalde regels, `|cffffcc00` kleuren intact

---

## Git

```text
git pull
/reload in WoW
```

**WoW-pad:** `_retail_\Interface\AddOns\MidnightHelper`
