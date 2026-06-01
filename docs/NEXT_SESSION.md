# Next session — Midnight Helper

**Laatste update:** 2026-06-01  
**Branch:** `main` (na pull: Codex + changelog-fixes)

---

## Op de PC boven (start hier)

1. **Repo ophalen** (de WoW-addonmap heeft **geen** `.git` — alleen bestanden):

   ```powershell
   cd $HOME\MidnightHelper-repo
   git pull
   ```

   Of clone opnieuw en kopieer naar WoW:

   ```powershell
   git clone https://github.com/Huijting/MidnightHelper.git $HOME\MidnightHelper-repo
   robocopy $HOME\MidnightHelper-repo "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\MidnightHelper" /E /XD .git
   ```

2. **In-game test** (`/reload`):

   - **Midnight Codex** — categorieknoppen (geen overlap), tekst zonder □ (`Home -> This Week`).
   - **Changelog-popup** — bovenaan **Versie 1.5.0** met Home/Rares/alert-bullets (niet meer alleen 1.4.0).
   - `/mh codex` of zoek `wiki` / `start here`.

3. **CurseForge** — 1.5.0 staat live; volgende upload kan **1.5.1** zijn met:
   - in-game changelog 1.5.0-tekst (nu in code),
   - Midnight Codex (nog niet in CF-release notes tenzij je meeneemt).

---

## Deze sessie (2026-06-01) — gedaan

| Onderdeel | Status |
|-----------|--------|
| **Midnight Codex** | Nieuw tabblad: Start Here, weekly, currencies, delves, dungeons, raid, world, professions; EN+NL; zoekkeywords |
| **Codex UI** | Dynamische categorieknoppen + wrap; `SafeL` / `->` i.p.v. □ |
| **In-game changelog** | `CHANGELOG_150_*` + `Changelog.lua` 1.5.0-blok (CF-website had al goede tekst; popup niet) |
| **Git** | Gecommit + gepusht naar `main` |

---

## Release 1.5.0 op CF — al live

- Home, Rares, live alerts, sidebar — zie `CHANGELOG.md` [1.5.0].
- CF-upload changelog-veld = website; **in-game popup** was achter tot bovenstaande fix.

---

## Backlog (optioneel)

1. Codex: DE/FR/ES/PT body (nu EN fallback) of korte CF-note bij 1.5.1.
2. Professions-gids fase 1+2 in-game testen (EN/NL).
3. Zip bouwen: `tools\package.ps1` → `dist\MidnightHelper-1.5.1.zip` vóór CF-upload.

---

## Snelle commands

```text
/reload
/mh codex
/mh changelog
```

```powershell
cd $HOME\MidnightHelper-repo
git pull
.\tools\package.ps1
```
