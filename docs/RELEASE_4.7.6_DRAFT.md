# 4.7.6 — concept (gestart 10 okt 2026), NIETS hiervan staat al in de changelog van de addon

Volgende versie = **BETA** (Rob, 9 okt: "presses komt later wel in een beta"). Op Robs go:
1. `MidnightHelper.toc` `## Version: 4.7.6-beta1`.
2. Blok A → `Locales/enUS.lua` (boven `CHANGELOG_475_0`), blok B → bovenaan `CHANGELOG_ENTRIES` in `Modules/Changelog.lua`.
3. Release-notes → `docs/CURSEFORGE_4.7.6.md` = `RELEASE_NOTES.md` (byte-gelijk), met onder de kop *"This is a beta."*
4. `CHANGELOG.md` bovenaan.

Inhoud tot nu toe (10 okt): `/mh presses`-venster, SimC race 95/96, Bartender4/ElvUI in LiveKeys
(`docs/BAR_ADDONS_LIVEKEYS_2026-10-09.md`; niet in een client gezien — beta-spelers met die addons testen).

## A — `Locales/enUS.lua`

```lua
	CHANGELOG_476_1 = "/mh presses opens a window now instead of filling your chat: your most-pressed spells with their key and how easy it is, the swap tip, and buttons to turn counting on or off and to clear a spec. It updates after each fight while it is open. Each swap tip has a Swap button: MH moves the two spells for you (out of combat, one at a time), says which key each one is on now. Undo takes your swaps back one at a time, newest first, or all at once. Heals, interrupts and defensives are never part of a swap: you reach for those by habit.",
	CHANGELOG_476_3 = "Bartender4 and ElvUI: /mh presses and the How you play card now find the key a spell sits on in those bar addons too, not only on Blizzard's bars. /mh playkeys says which bar addon each key came from.",
	CHANGELOG_476_2 = "Raidbots export (/mh raidbots): race ids 95 and 96 (SimulationCraft calls them skyborne_alliance and skyborne_horde) get the race name SimulationCraft expects.",
```

## B — `Modules/Changelog.lua`

```lua
	{
		version = "4.7.6",
		lines = {
			"CHANGELOG_476_1",
			"CHANGELOG_476_3",
			"CHANGELOG_476_2",
		},
	},
```
