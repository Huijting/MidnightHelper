# 4.7.5 — concept (9 okt 2026), NIETS hiervan staat al in de addon

Klaargezet zonder bump en zonder tag. Op Robs go (beta of release) gaat dit zo:
1. `MidnightHelper.toc` `## Version: 4.7.5` (beta: `4.7.5-beta1`).
2. Blok A hieronder → `Locales/enUS.lua` (boven `CHANGELOG_474_0`), blok B → `Modules/Changelog.lua` (bovenaan
   `CHANGELOG_ENTRIES`).
3. Blok C → `docs/CURSEFORGE_4.7.5.md` én `RELEASE_NOTES.md` (byte-gelijk; `diff` ze). Beta: zet onder de kop
   *"This is a beta."*
4. Blok D → bovenaan `CHANGELOG.md`, datum en Robs testresultaat invullen.

Inhoud = de vier code-commits sinds `v4.7.4`: `4d5e2c9`, `6492ca6`, `628ea2a`, `2dd6d4f` (GEMETEN met
`git log v4.7.4..HEAD`). Getest: nog NIETS — Robs testlijst van 8 okt staat bovenaan `docs/TESTLIJST.md`.
De Keystone Myth-kaart is pas op 12.1.5 te zien en dus vóór de patch niet te testen.

## A — `Locales/enUS.lua` (alleen Engels, zoals elk changelog-item)

```lua
	CHANGELOG_475_0 = "Want updates sooner? Betas come out regularly: in the CurseForge app, set Midnight Helper's release type to Beta. Tell us how it goes, also when everything works: Report a problem in Settings, a comment on CurseForge, or the form on midnighthelper.com.",
	CHANGELOG_475_1 = "Healer toolkit: heals are now labelled Instant, Short cast or Filler instead of one \"fast\" label. Holy Priest gets Holy Word: Serenity as the first button when someone is low; Holy Paladin's Word of Glory sits right under Holy Shock.",
	CHANGELOG_475_2 = "Stay alive: the big defensive step no longer says an immunity is fine when you are nearly dead - for a Paladin, Forbearance makes that clash with Lay on Hands. Blessing of Protection and Spellwarding now mention Forbearance too. Guardian Spirit and Cold Snap get their own line.",
	CHANGELOG_475_3 = "Role Academy: only a real immunity (Divine Shield) gets \"just before a hit you will not survive\"; Barkskin and Astral Shift no longer do. Who-to-heal-first now names the Instant and Short cast labels.",
	CHANGELOG_475_4 = "Ready for 12.1.5: a Codex card for Keystone Myth: Season 2 (shows on patch day). The Aqir Invasion is listed once in upcoming events. The Labyrinth card no longer tells you to kill the Headhunters fast; nothing says they have to die.",
	CHANGELOG_475_5 = "French: the Stay alive card speaks with one voice (tu). Translations in German, French, Spanish, Portuguese and Italian are our own.",
```

## B — `Modules/Changelog.lua`

```lua
		{
			version = "4.7.5",
			lines = {
				"CHANGELOG_475_0",
				"CHANGELOG_475_1",
				"CHANGELOG_475_2",
				"CHANGELOG_475_3",
				"CHANGELOG_475_4",
				"CHANGELOG_475_5",
			},
		},
```

## C — `docs/CURSEFORGE_4.7.5.md` = `RELEASE_NOTES.md`

```markdown
# Midnight Helper 4.7.5: clearer healer labels, and ready for 12.1.5

## Want updates sooner? Try the betas

We put out **betas** regularly, before each bigger release. Want them? In the CurseForge app, open Midnight Helper and
set the **release type to Beta**. You get new things a few days earlier, and you help us find what we missed.

**Tell us how it goes, also when everything works:** `/mh report` in game (or *Report a problem* in Settings), a
comment here on CurseForge, or the feedback form on midnighthelper.com.

## Healers: which heal is which

- **Instant, Short cast or Filler.** The heal toolkit used one "fast" label for both instant heals and 1.5 second
  casts. Now Holy Shock, Word of Glory, Swiftmend and Verdant Embrace say **Instant**; Flash of Light, Regrowth, Vivify
  and Flash Heal say **Short cast**; Living Flame says **Filler**.
- **Holy Priest:** Holy Word: Serenity is in the list, as the first button when someone is low.
- **Holy Paladin:** Word of Glory sits right under Holy Shock.

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

Translated into German, French, Spanish, Portuguese and Italian. These are our own translations: native speakers,
corrections are very welcome. The French Stay alive card now uses "tu" everywhere.

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
```
