# CurseForge release 2.4.0 — copy/paste (BETA)

**Upload:** `dist/MidnightHelper-2.4.0.zip` (build with `tools\package.ps1`).
**Release type:** **Beta** (grote wijziging — Cisca + Carola testen eerst).
**Game version:** Retail 12.0.7 (interface 120007).
**Description:** no change needed (`CURSEFORGE_DESCRIPTION.md` stays as-is).

> ⚠️ **Vóór upload:** `/reload` met Lua-errors aan → changelog-popup toont **2.4.0** bovenaan.
> Check: Settings → Notifications toont **Combat Safety** (icoon-toggle, "óók balken", "spreek de
> cast-naam", "alleen belangrijke casts", Voorbeeld). In een gevecht met een caster die je target
> verschijnt het rode icoon (+ balk/stem indien aan). In een delve → vijand targeten (buiten combat)
> geeft de "open Delve Coach?"-knop. Géén Ground Safety/OPZIJ! meer in de settings (geparkeerd).

---

## Short summary (one line)

Midnight Helper 2.4.0 adds a Combat Safety warning that flags enemy casts aimed at you (movable icon, optional cast bars and spoken cast name), a delve boss-coach prompt when you target an enemy, and several patch 12.x "secret value" fixes (reset-route quest givers, Missing Buff aura spam).

---

## Changelog — paste below (since 2.3.1)

### 2.4.0 — 2026-07-05 (Beta)

Adds the Combat Safety cast warning and a delve boss-coach prompt, plus several patch 12.x "secret value" fixes.

**Added**

- **Combat Safety — dangerous cast warning.** When an enemy casts a spell that targets **you**, a
  movable red icon with a countdown appears so you can move or interrupt. Optional **cast bars** show
  several incoming casts at once, and an optional **voice** speaks the cast's name. All 12.x
  "secret value" safe. Enable/tune it in **Settings → Notifications** (icon on by default; bars and
  voice opt-in; an "only important casts" toggle narrows it; Preview positions the icon/bars).
- **Delve Coach boss prompt.** Targeting an enemy in a delve (out of combat) shows a small
  **"open the Delve Coach?"** button — boss tips without opening menus. Hides in combat; ignores
  trivial critters.

**Fixed**

- No more forbidden-action/taint Lua errors on the reset route when a quest giver's GUID or name is
  a 12.x secret value.
- Missing Buff no longer spams "re-apply your buff" (e.g. a Shaman shield) in delves/rituals where
  12.x hides auras; it detects that and stays quiet there, and works normally in open content.

---

## Test-checklist voor Cisca + Carola

- Combat Safety: icoon verschijnt bij een cast op jou; probeer ook **balken** en **stem** (Settings).
- Delve: vijand targeten buiten combat → "open Delve Coach?"-knop; verdwijnt in gevecht.
- Cisca (Shaman): géén constante "zet je shield op" meer in delves/rituals.
- Reset-route: quest aannemen bij een giver geeft geen Lua-error meer.
