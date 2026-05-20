# Next session — Midnight Helper

**CurseForge:** upload only when the user explicitly asks. Do not publish `dist/MidnightHelper-1.2.5.zip` until then.

**Version on disk:** TOC `1.2.5` — much work is **local/uncommitted** after commit `54dcfb8` (Role Academy MVP). Commit + push before switching PC.

---

## Done since 1.2.4 (live on CF when user uploaded)

- Great Vault reminder, TomTom → Blizzard waypoint, prof weekly in Account snapshot
- Account snapshot polish (sort/filter, level/ilvl, stale badge, mana crystals)
- **1.2.4** tested on wife's PC and approved

## Done locally (1.2.5 WIP — commit pending)

### Role Academy tab
- Tank / heal tracks, scroll sections (mindset, pull/triage, wipe, dungeon, raid, ladder, both roles)
- **Pre-flight checklist** (saved per track in `ns.db.ui.roleAcademyPreflight`)
- **Party chat** — copy-friendly EditBox per line + copy icon
- **SafeL** — no Unicode arrows (`→`) in UI (fixes “blokje” in text)
- Class line; **removed** duplicate bottom link bar (use sidebar)
- Search: `tank`, `heal`, `academy`, `mentor`, etc.

### Leveling Guides — In groups (stap 5)
- New advisor tab **In groups** (dungeon/raid tips per role: tank, healer, melee, caster, support)
- Locale: `Locales/GuideGroups.lua` + tab label in enUS/nlNL
- Search opens guide on In groups tab

### Guide UI polish (same session, may need more testing)
- Advisor: **tabs above level slider** (not below)
- Advisor tabs: chained layout, dynamic button width (one row)
- **Consumables block** in guide now uses same list as **Consumables sidebar tab** (`MH_BuildConsumablesIntoHost`) + button “Open Consumables tab”
- Fixed misleading “only after level 61” when already 66+ (legacy path only; wowhead list is primary)

---

## Test on other PC (after pull)

- [ ] `/reload` — Role Academy: preflight overlap gone, party chat Ctrl+C
- [ ] Advisor: tabs on top, slider below, no overlapping tab labels
- [ ] Guide consumables section shows flask/food list (not empty “level 61” at 66+)
- [ ] “Open Consumables tab” matches sidebar list for same spec
- [ ] In groups tab + search `in groups`

---

## Not done / backlog

| Item | Notes |
|------|--------|
| **CurseForge 1.2.5** | Only when user says so |
| **Per-spec “In groups” in GuideData** | Optional; role-based text covers all specs for now |
| **Alt snapshot export/import** | Paused |
| **SMC checklist quest IDs** | Paused (rotating dungeon weekly) |
| **Keyboard layouts** more classes | Later |
| **Consumables in guide** | User said “niet helemaal goed” — tune after playtesting |

---

## Git handoff (two PCs)

```text
PC1 (here):  git add -A && git commit -m "..." && git push
PC2:         git pull   (in same repo path or clone to Interface\AddOns\MidnightHelper)
             Copy/sync addon folder into WoW if repo is elsewhere
             /reload in game
```

**Cursor:** Chat history does **not** sync between machines. On PC2: open repo → new Agent chat → reference `@docs/NEXT_SESSION.md` or paste a short “continue 1.2.5” note.

**WoW:** Addon must live in `_retail_\Interface\AddOns\MidnightHelper` on each PC (git clone or pull into that folder).

---

## Suggested commit message (when ready)

```text
Role Academy polish and Guides In groups tab (1.2.5 WIP).

Pre-flight checkboxes, copy-friendly party chat, advisor layout fixes,
consumables section linked to sidebar Wowhead list, GuideGroups locales.
CF upload still on hold.
```
