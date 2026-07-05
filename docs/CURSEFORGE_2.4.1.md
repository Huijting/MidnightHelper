# CurseForge release 2.4.1 — copy/paste (BETA)

**Upload:** `dist/MidnightHelper-2.4.1.zip` (build with `tools\package.ps1`).
**Release type:** **Beta** (settings-overhaul — Cisca + Carola testen eerst).
**Game version:** Retail 12.0.7 (interface 120007).
**Description:** no change needed (`CURSEFORGE_DESCRIPTION.md` stays as-is).

> ⚠️ **Vóór upload:** `/reload` met Lua-errors aan → changelog-popup toont **2.4.1** bovenaan.
> Check: **Esc → Opties → AddOns → Midnight Helper** opent het native paneel (taal-dropdown
> bovenaan, zoekbalk, tooltips, "Achievements"-subcategorie). De in-addon **Settings-tab** is nu
> een launcher met "Open instellingen" + de Test/Voorbeeld-knoppen. In de **open wereld** (bv.
> Harandar, buiten combat, buff eraf) verschijnt het **Missing Buff-icoon** weer. In de
> **Achievements-tab** klappen de vier zone-meta's (Forever Song enz.) uit met `+`.

---

## Short summary (one line)

Midnight Helper 2.4.1 moves every setting into the game's native Settings window (searchable, with tooltips and the language selector on top), makes the four achievement zone-metas expandable with live progress, and fixes two patch 12.x regressions — Missing Buff being wrongly hidden in the open world, and the delve boss-coach prompt over-firing.

---

## Changelog — paste below (since 2.4.0)

### 2.4.1 — 2026-07-05 (Beta)

Moves all settings into the native Blizzard Settings window, expands the achievement metas, and fixes two 12.x "secret value" regressions.

**Changed**

- **Settings now live in the native Blizzard Settings window** (Game Menu → Options → AddOns →
  Midnight Helper): searchable, a tooltip on every option, sub-categories, and your **language
  selector right at the top**. The in-addon Settings tab becomes a **launcher** (eyecatcher +
  "Open settings" + the Test/Preview/Reset quick actions). Blizzard's own **Defaults** button
  doubles as "recommended". Per-achievement visibility gets its own subsection. `/mh settings`
  opens the native panel.

**Added**

- **Achievement zone-meta drill-down.** The four zone metas that feed *Light Up the Night*
  (Forever Song, Making an Amani Out of You, That's All Folks!, Yelling into the Voidstorm) are
  now expandable (+/−) to show their component sub-achievements with live progress — read straight
  from the game's criteria API.

**Fixed**

- **Missing Buff is back in the open world.** It was wrongly hidden across *all* Midnight zones
  (it used "is player health secret?" as a fallback for "are auras unreliable", but health reads
  as secret in open-world Midnight zones while auras work fine). It now trusts Blizzard's own
  `C_Secrets.ShouldAurasBeSecret()` and only falls back to the health check if that API is absent —
  so it shows in open content again and still stays quiet in delves/rituals. (Regression from 2.4.0.)
- **Delve boss-coach prompt no longer over-fires.** It popped on neutral quest givers and re-popped
  on every random enemy; it now only offers on a genuinely hostile target, and at most once per delve.

---

## Test-checklist voor Cisca + Carola

- **Instellingen:** Esc → Opties → AddOns → Midnight Helper — taal bovenaan (zet 'm op je taal +
  `/reload`), zoekbalk werkt, tooltips per optie. In-addon Settings-tab = launcher.
- **Missing Buff:** in de **open wereld** (buiten combat, een class-buff eraf) verschijnt het gele
  icoon weer; in delves/rituals blijft 'ie stil (geen valse "shield!"-spam).
- **Achievements:** klik de `+` bij een zone-meta (Forever Song enz.) → sub-achievements klappen uit.
- **Delve:** een quest aannemen of een willekeurige vijand targeten spamt de "open coach?"-knop niet
  meer; hij komt hooguit één keer per delve bij een echte vijand.
