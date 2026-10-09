# 4.7.5 — concept (9 okt 2026), NIETS hiervan staat al in de addon

Klaargezet zonder bump en zonder tag. Op Robs go (beta of release) gaat dit zo:
1. `MidnightHelper.toc` `## Version: 4.7.5` (beta: `4.7.5-beta1`).
2. Blok A hieronder → `Locales/enUS.lua` (boven `CHANGELOG_474_0`), blok B → `Modules/Changelog.lua` (bovenaan
   `CHANGELOG_ENTRIES`).
3. Blok C → `docs/CURSEFORGE_4.7.5.md` én `RELEASE_NOTES.md` (byte-gelijk; `diff` ze). Beta: zet onder de kop
   *"This is a beta."*
4. Blok D → bovenaan `CHANGELOG.md`, datum en Robs testresultaat invullen.

Inhoud = de code-commits sinds `v4.7.4`: `4d5e2c9`, `6492ca6`, `628ea2a`, `2dd6d4f` (8 okt) en `4e30ea1`,
`11bb7e1` (9 okt: /mh presses, schat-stappen, healer-cd's, This Week). GEMETEN met `git log v4.7.4..HEAD`.
9 okt middag erbij: Kith'ix klaargezet (verborgen tot 12.1.5), 2 schakelaars, Barkskin 60 s, Earth Elemental met
Primordial Bond — staan hieronder al in A t/m D.
Getest: nog NIETS — Robs testlijst van 8 + 9 okt staat bovenaan `docs/TESTLIJST.md`.
De Keystone Myth-kaart is pas op 12.1.5 te zien en dus vóór de patch niet te testen.

## A — `Locales/enUS.lua` (alleen Engels, zoals elk changelog-item)

```lua
	CHANGELOG_475_0 = "Want updates sooner? Betas come out regularly: in the CurseForge app, set Midnight Helper's release type to Beta. Tell us how it goes, also when everything works: Report a problem in Settings, a comment on CurseForge, or the form on midnighthelper.com.",
	CHANGELOG_475_1 = "Healer toolkit: heals are now labelled Instant, Short cast or Filler instead of one \"fast\" label. Holy Priest gets Holy Word: Serenity as the first button when someone is low; Holy Paladin's Word of Glory sits right under Holy Shock.",
	CHANGELOG_475_2 = "Stay alive: the big defensive step no longer says an immunity is fine when you are nearly dead - for a Paladin, Forbearance makes that clash with Lay on Hands. Blessing of Protection and Spellwarding now mention Forbearance too. Guardian Spirit and Cold Snap get their own line.",
	CHANGELOG_475_3 = "Role Academy: only a real immunity (Divine Shield) gets \"just before a hit you will not survive\"; Barkskin and Astral Shift no longer do. Who-to-heal-first now names the Instant and Short cast labels.",
	CHANGELOG_475_4 = "Ready for 12.1.5: a Codex card for Keystone Myth: Season 2 (shows on patch day). The Aqir Invasion is listed once in upcoming events. The Labyrinth card no longer tells you to kill the Headhunters fast; nothing says they have to die.",
	CHANGELOG_475_5 = "French: the Stay alive card speaks with one voice (tu). Translations in German, French, Spanish, Portuguese and Italian are our own.",
	CHANGELOG_475_6 = "New: /mh presses (off until you turn it on; also a switch under Combat in Settings). It counts which spells you press in combat, per character and spec, and shows your most-pressed spells with the key each one sits on - easy, okay or hard - plus a tip which two to swap. Nothing moves by itself.",
	CHANGELOG_475_7 = "Healer cooldowns: Avenging Crusader, Innervate, Restoral and Zephyr added; Holy Word: Salvation removed, it no longer exists.",
	CHANGELOG_475_8 = "Treasures: the steps of Gift of the Cycle (Harandar) and the Brine-Crusted Chest (Coiled Isle) now tick off, and the arrow takes them in order.",
	CHANGELOG_475_9 = "German, French, Spanish, Portuguese and Italian: the tour and the weekly note call the This Week tab by its translated name.",
	CHANGELOG_475_10 = "Fixes: Barkskin is 60 seconds for Restoration (45 is Guardian's). Earth Elemental is on a Shaman's Stay alive card only with Primordial Bond: without it, it reduces no damage.",
	CHANGELOG_475_11 = "Settings -> Advanced: switches for Keep key 1 for the Assisted Combat button (/mh sba) and Let the key layout use my mouse buttons (/mh mouse fill).",
	CHANGELOG_475_12 = "Ready for 12.1.5: tips for Kith'ix in the Raids window, hidden until patch day. Written from the game's data and DBM before anyone fought him, and they say so.",
```

## B — `Modules/Changelog.lua`

```lua
		{
			version = "4.7.5",
			lines = {
				"CHANGELOG_475_0",
				"CHANGELOG_475_6",
				"CHANGELOG_475_1",
				"CHANGELOG_475_7",
				"CHANGELOG_475_2",
				"CHANGELOG_475_3",
				"CHANGELOG_475_8",
				"CHANGELOG_475_4",
				"CHANGELOG_475_12",
				"CHANGELOG_475_11",
				"CHANGELOG_475_10",
				"CHANGELOG_475_9",
				"CHANGELOG_475_5",
			},
		},
```

## C — `docs/CURSEFORGE_4.7.5.md` = `RELEASE_NOTES.md`

```markdown
# Midnight Helper 4.7.5: which keys you really press, clearer healer labels, and ready for 12.1.5

## Want updates sooner? Try the betas

We put out **betas** regularly, before each bigger release. Want them? In the CurseForge app, open Midnight Helper and
set the **release type to Beta**. You get new things a few days earlier, and you help us find what we missed.

**Tell us how it goes, also when everything works:** `/mh report` in game (or *Report a problem* in Settings), a
comment here on CurseForge, or the feedback form on midnighthelper.com.

## Which spells do you press most, and are they on easy keys? (`/mh presses`)

Blizzard's highlight tells you *what* to press next, never *where* that button should live. So your busiest spell can
end up on Ctrl+5 while a once-a-fight button sits on 1.

- **Turn it on** with `/mh presses on`, or the switch *Count which spells you press* under Combat in Settings. It is
  off until you do.
- **Play a few fights**, then type `/mh presses`: your most-pressed spells, how often, the key each one really sits on,
  and whether that key is **easy, okay or hard** to reach.
- **A tip which two to swap** when a busy spell sits on a hard key and a quiet one on an easy key. Nothing moves by
  itself: change one or two at a time, your hands need a few days per change.
- One list per character and spec. `/mh presses reset` clears it.

## Healers: which heal is which

- **Instant, Short cast or Filler.** The heal toolkit used one "fast" label for both instant heals and 1.5 second
  casts. Now Holy Shock, Word of Glory, Swiftmend and Verdant Embrace say **Instant**; Flash of Light, Regrowth, Vivify
  and Flash Heal say **Short cast**; Living Flame says **Filler**.
- **Holy Priest:** Holy Word: Serenity is in the list, as the first button when someone is low.
- **Holy Paladin:** Word of Glory sits right under Holy Shock.
- **Healer cooldowns** (`/mh healcds`): Avenging Crusader, Innervate, Restoral and Zephyr are in the list now.
  **Holy Word: Salvation** is gone: it was removed from the game, yet it still stood first for Holy Priests.

## Treasures that tick off step by step

- **Gift of the Cycle** (Harandar): pillow, altar, knife, altar, ball, altar. Each step ticks off, and the arrow takes
  them in that order, so it never sends you to an altar before you carry what it wants.
- **Brine-Crusted Chest** (Coiled Isle): the clam and the pearl tick off the same way.

## Stay alive: no more advice that contradicts itself

- The big defensive step said an immunity is also fine when you are nearly dead. For a Paladin, Forbearance means you
  then cannot use Lay on Hands, which the same card suggests. That sentence is gone for every class.
- **Blessing of Protection** and **Spellwarding** now say they give Forbearance, like Divine Shield already did.
- **Guardian Spirit** (it cannot save someone from one huge hit) and **Cold Snap** (a reset, not a defensive by itself)
  get their own line.
- **Role Academy:** only a real immunity, Divine Shield, gets "just before a hit you will not survive". Barkskin and
  Astral Shift no longer do.

## Ready for patch 12.1.5

- A new Codex card: **Keystone Myth: Season 2** is back. It appears on patch day by itself. The test realm still showed
  a placeholder, so the card asks you to check the rating in your own Achievements window.
- The **Aqir Invasion** was listed twice under upcoming events. It is listed once now.
- The **Labyrinth of Kindo'jan** card no longer says to kill the Headhunters fast. We found no source that says they
  have to die.
- **Kith'ix** gets boss tips in the Raids window: a short version per role and the full steps. They appear on patch
  day by themselves. We wrote them from the game's own data and DBM's encounter mod before anyone could fight him,
  and the window says so. Tell us what is wrong.

## Small things

- **Settings -> Advanced** has two new switches for the key layout: *Keep key 1 for the Assisted Combat button*
  (`/mh sba`) and *Let the key layout use my mouse buttons* (`/mh mouse fill`).
- **Barkskin** is 60 seconds for Restoration Druids. The 45 we showed is Guardian's.
- **Earth Elemental** is on a Shaman's *Stay alive* card only when you have **Primordial Bond**. Without that talent it
  reduces no damage, so it was advice aimed at somebody else.

Translated into German, French, Spanish, Portuguese and Italian. These are our own translations: native speakers,
corrections are very welcome. The French Stay alive card now uses "tu" everywhere, and the tour in all five languages
calls the This Week tab by the name the tab itself shows.

Have fun!
```

## D — `CHANGELOG.md`

```markdown
## 4.7.5

📌 **2026-10-__, als BETA/RELEASE (Rob: "…"), tag `v4.7.5…`.** 4 code-commits na 4.7.4. Rob testte: … NIET getest: …

- **Heal-tags:** `instant` / `fast` (= Short cast) / `filler`; Holy Word: Serenity (2050); WoG onder Holy Shock.
- **Blijf leven:** SURVIVAL_STEP_BIG zonder immuniteitszin; `survivalWhen` (Guardian Spirit, Cold Snap);
  Forbearance-noten op BoP Holy/Ret + Spellwarding.
- **Academy:** HEALTOOLKIT_DEF_DESC_IMMUNE alleen bij `d.immune`; TRIAGE noemt [Instant]/[Short cast]; nlNL "spell".
- **12.1.5:** Codex Keystone Myth (minInterface 120105); Aqir 1× in upcoming (POI + eindtijd); Labyrinth "Headhunters
  appear".
- **frFR:** Blijf leven helemaal "tu".
- **`/mh presses`** (KeyPresses.lua, opt-in, `ns.db.keyPresses`): eigen casts tellen, top 8 met echte toets + bereik +
  ruil-tips; balk 8 = duim alleen met `padKeyHome`.
- **Healer-cd's:** + Avenging Crusader, Innervate, Restoral, Zephyr; − Holy Word: Salvation.
- **Schat-stappen:** Gift of the Cycle 93146/93145/93130 + items, Brine-Crusted 96001 + item 271815, `orderedPrereqs`.
- **This Week** vertaald in TOUR_HOME_* en ACCOUNT_WEEKLY_SCOPE_NOTE (de/fr/es/pt/it).
- **Kith'ix:** `raid_kithix` in RaidCoachData (minInterface 120105, noteKey RAID_KITHIX_NOTE, geen journalInstanceID/
  ingang tot `/mh ej save`); tips 7 talen; 1303257/1304046/1304040 zonder link (DBM kent ze alleen als aura).
- **Schakelaars:** mh_sbaForce, mh_mouseOverflow (Geavanceerd). **Barkskin** Resto 60 s; **Earth Elemental**
  `survivalRequires = 1279819`.
```
