# 4.7.6 — concept (gestart 10 okt 2026)

✅ **TOEGEPAST 10 okt (Rob: "go beta").** Toc 4.7.6, CHANGELOG_476_0..7, Changelog.lua, RELEASE_NOTES.md =
docs/CURSEFORGE_4.7.6.md, CHANGELOG.md. Tag `v4.7.6-beta1` na akkoord site-chat. Dit concept is vanaf nu historie.

Volgende versie = **BETA** (Rob, 9 okt: "presses komt later wel in een beta"). Op Robs go:
1. `MidnightHelper.toc` `## Version: 4.7.6-beta1`.
2. Blok A → `Locales/enUS.lua` (boven `CHANGELOG_475_0`), blok B → bovenaan `CHANGELOG_ENTRIES` in `Modules/Changelog.lua`.
3. Release-notes → `docs/CURSEFORGE_4.7.6.md` = `RELEASE_NOTES.md` (byte-gelijk), met onder de kop *"This is a beta."*
4. `CHANGELOG.md` bovenaan.

Inhoud tot nu toe (10 okt): `/mh presses`-venster, SimC race 95/96, Bartender4/ElvUI in LiveKeys
(`docs/BAR_ADDONS_LIVEKEYS_2026-10-09.md`; niet in een client gezien — beta-spelers met die addons testen).

## ➕ NA beta1 (voor beta2 of de release) — nog NIET in de changelog/notes van de addon

1. **Vrienden markeren** (FriendMarks.lua). 🔴 Pas opnemen NA Robs test met Carola en Cisca (Battle.net-route niet
   gemeten). Rob koos 10 okt: klein extraatje onder "Small things", geen kop.
   - enUS: `CHANGELOG_476_8 = "Marker bar: playing with the same friends? Everyone can pick their own marker (/mh mark me star), and one button marks them all, whatever character they play. Friends without MH: /mh mark friend Name#1234 circle."`
   - Notes (Small things): *"**Playing with the same friends?** Everyone can pick their own marker once (`/mh mark me
     star`), and a new button on the marker bar marks them all, whatever character they are on. Friends without MH can
     be linked by BattleTag (`/mh mark friend Name#1234 circle`)."*
2. **nlNL "character" i.p.v. "personage"** (e2776cc + e17b0af): geen changelog-regel nodig (Nederlands is handmatig);
   wél site-chat seinen bij deze build, dan zet de site "Alle characters".

## A — `Locales/enUS.lua`

```lua
	CHANGELOG_476_1 = "/mh presses opens a window now instead of filling your chat: your most-pressed spells with their key and how easy it is, the swap tip, and buttons to turn counting on or off and to clear a spec. It updates after each fight while it is open. Each swap tip has a Swap button: MH moves the two spells for you (out of combat, one at a time), says which key each one is on now. Undo takes your swaps back one at a time, newest first, or all at once. Heals, interrupts and defensives are never part of a swap: you reach for those by habit.",
	CHANGELOG_476_3 = "Bartender4 and ElvUI: /mh presses and the How you play card now find the key a spell sits on in those bar addons too, not only on Blizzard's bars. /mh playkeys says which bar addon each key came from.",
	CHANGELOG_476_4 = "Key block cheat sheet: All characters puts the codes of every character that has the key block placed in one copy box, each with the date it was last updated. Paste them all at once on midnighthelper.com.",
	CHANGELOG_476_5 = "Marker bar (/mh mark): a new button marks the tank with a blue square and the healer with a green triangle in one click, using the roles of your group. Only one of them in the group? Only that one is marked.",
	CHANGELOG_476_6 = "Settings: five switches that had no button now do - short pop-up notes (toasts), the Trovehunter's Bounty toast, the sound for new things to open, the Delve items window opening by itself, and how many extra mouse buttons the key layout may use.",
	CHANGELOG_476_7 = "Codex, Starting the Midnight campaign: lost the quest? Stormwind, Orgrimmar or the Adventure Guide offer it again. And the skip line only appears once a character on your account has the Midnight achievement.",
	CHANGELOG_476_2 = "Raidbots export (/mh raidbots): race ids 95 and 96 (SimulationCraft calls them skyborne_alliance and skyborne_horde) get the race name SimulationCraft expects.",
```

## B — `Modules/Changelog.lua`

```lua
	{
		version = "4.7.6",
		lines = {
			"CHANGELOG_476_1",
			"CHANGELOG_476_3",
			"CHANGELOG_476_4",
			"CHANGELOG_476_5",
			"CHANGELOG_476_6",
			"CHANGELOG_476_7",
			"CHANGELOG_476_2",
		},
	},
```
