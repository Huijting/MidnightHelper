<!--
  MAINTAINER NOTE — kept inside an HTML comment so it never renders on the release page.
  This file holds the notes for the CURRENT release only. The BigWigs packager uploads it
  verbatim as the CurseForge release notes (.pkgmeta -> manual-changelog), so overwrite it on
  every version bump. The full history lives in CHANGELOG.md, the per-version archive copies
  in docs/CURSEFORGE_<version>.md.
-->

# Midnight Helper 2.6.0

## Two new pages, and a window a beginner can actually navigate

Midnight Helper should answer **"what should I do right now?"** before it answers anything else.
This release makes it do that — and adds two pages that were long overdue.

### 🐎 New tab: Collectible mounts

A checklist of the **17 new Midnight mounts**. A green tick for the ones you own, a red cross for
the rest.

- Live progress for each: renown level, meta-achievement steps, or how many items you have banked.
- **How to get it**, in one line, under every mount.
- A floating **3D preview** beside the window when you hover a mount's name — drag to spin.
- Hover a *Voidlight Marl* line and Blizzard's own currency tooltip shows your balance on every
  character.
- Mounts that are pure RNG — a rare drop, a puzzle, a hidden quest chain — show **no progress bar
  at all**, because there is no honest number to show. A red cross and a how-to instead.

### 🐉 New page: Raids (Codex → Raids)

Boss steps for all three Season 1 raids and their nine bosses: **The Dreamrift**, **The Voidspire**
and **March on Quel'Danas**.

- Numbered steps, tank/healer/dps lines, and **clickable spell links**.
- Boss names come from the Encounter Journal, so they are in *your* game language.
- The Raid Coach still opens by itself when a boss pull starts. This page is for the preparation
  beforehand.

### 🎯 Home leads with "Next up"

One concrete action — the most useful thing you can do right now — with a **Take me there** button
that sets the route, and a tally of how far you are through the week.

While you are levelling it never proposes endgame content you cannot do yet.

### 🔎 Search finds bosses

Type a boss name and jump straight to its coach steps. **52 bosses**, dungeons and raids.

It also finds the *Collectible mounts*, *Raids* and *Pop-out windows* tabs — which were missing
from the search index entirely. Typing "mount" used to find nothing.

### 🧭 A calmer window

- The welcome popup opens the **Start Here** roadmap instead of a tour of the buttons.
- Start Here leads with its six-step plan; the window walkthrough sits below it, folded away.
- Home opens with fewer sections unfolded and packs the folded ones into a tidy grid. Everything is
  one click away, and your choice is remembered.
- The Character sidebar is grouped into **Collections**, **Gear**, **Resources** and
  **Alts & history**.
- Plainer names: Home → **This Week**, SMC City Guide → **Silvermoon City**, Launchpad →
  **Pop-out windows**.
- One shared colour palette: "done" is the same green and "do this" the same amber, everywhere.

### 🌍 Translated

Everything above is available in German, French, Spanish, Portuguese and Italian.

---

## Note for existing users

Home's folded/unfolded choices are **reset once** so the new, calmer defaults apply. Fold or unfold
whatever you like afterwards — it will be remembered again.

## Fixed

- Ritual Sites and Void Assaults offered a "pick it up" step at *any* level, so a levelling
  character could have been handed endgame content as the headline action. Those steps are now gated
  behind max level for that purpose. They still appear in the checklist underneath.
