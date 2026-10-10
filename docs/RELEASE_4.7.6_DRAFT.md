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

🔴 **RSS (site-chat 10 okt, 02a6137):** midnighthelper.com/feed.xml leest bij elke tag de eerste regel (H1) en de
`## `-koppen van RELEASE_NOTES.md. Houd de H1 dus een spelerstitel en de koppen netjes.

## 🧪 BETA2-CONCEPT (10 okt) — klaar om toe te passen op Robs go; eerst site-chat afstemmen

Wat sinds beta1 binnen is (git v4.7.6-beta1..HEAD). Changelog-regels enUS, voorstel:

```lua
	CHANGELOG_476_8 = "Marker bar: playing with the same friends? Everyone can pick their own marker (/mh mark me star), and one button marks them all, whatever character they play - in delves, dungeons and raids (in a raid you need lead or assist). Friends without MH: /mh mark friend Name#1234 circle.", -- ✅ Rob 10 okt: mee in beta2, test samen met Carola/Cisca in de beta
	CHANGELOG_476_17 = "This Week: Orin Straylight's extra Nebulous Voidcore and Warleader Abdumati's 'Purging the Vaults' are on the list now; Vereesa says honestly that she skips some weeks; the Ritual Sites weekly points to Lady Liadrin instead of the Bazaar; three Coiled Isle Special Assignments added.",
	CHANGELOG_476_16 = "Death card: after you die, MH now reads Blizzard's own Death Recap and says what did most of the damage, how many hits, and what the last hit was, with a tip. Where the game keeps those details hidden, the card still opens the Death Recap for you.",
	CHANGELOG_476_9 = "Class advice checked against the 12.1 game data for all 40 specs: about 25 fixes. A few examples: Demonology gets the Felguard, Arms and Fury their own stance, Assassination Deadly Poison, the non-lethal poison you talented, the Warlock demon you summoned last; spells with a new id in 12.1 (Breath of Sindragosa, Flame Shock, Multi-Shot, Renewing Mist, Roll the Bones) no longer show grey; macros for spells that are gone were removed.",
	CHANGELOG_476_10 = "Frost Mage play card (try-out): a 'Why' line under every step, and a 'Test yourself' quiz built from the card. More specs follow.",
	CHANGELOG_476_11 = "Trading Post: 'already own' now also for transmog, toys and ensembles, not only mounts and pets.",
	CHANGELOG_476_12 = "Professions: every unfinished node says which tab it is in and whether it is open yet, and the advice line says in plain words when the next choice opens.",
	CHANGELOG_476_13 = "Healers: Celestial Conduit (Mistweaver) and Tip the Scales (Preservation) on the cooldown list; the raid cooldown named in boss tips is now one you actually picked.",
	CHANGELOG_476_14 = "Death card: clicking it opens Blizzard's Death Recap again (the old way stopped working in 12.1).",
	-- (476_16 hierboven bij 476_8: de Death Recap-les, 10 okt avond)
	CHANGELOG_476_15 = "/mh export for midnighthelper.com: realm and region (for your character picture), tier set, gems and enchants, effects on every slot, one-handers you can dual-wield; bag items you cannot use (wrong class, too high level, a shield on a caster) are left out.",
```

Stil (geen regel): Healer CD's die niet bestaan weg, VaultAdvisor set-id, `/mh kp weekly` + `/mh death`-metingen,
`/mh tp why`, nlNL "character". ✅ Rob 10 okt avond: "bouw de Death Recap-les ... en de snelle markings in een delve, raid of dungeon samen met
Cisca en Carola. Wanneer we deze twee erin gebouwd hebben, dan doen we een nieuwe beta en dan kan die gereleased
worden." Beide gebouwd (3cb5b0b + volgende commit). Vriendenmarkering gaat dus MEE in beta2.
Bij de go: dezelfde 4 stappen als beta1 (toc blijft 4.7.6, notes kop "beta 2", tag `v4.7.6-beta2`) + site-chat seinen.

## ➕ NA beta1 (voor beta2 of de release) — nog NIET in de changelog/notes van de addon

1. **Vrienden markeren** (FriendMarks.lua). 🔴 Pas opnemen NA Robs test met Carola en Cisca (Battle.net-route niet
   gemeten). Rob koos 10 okt: klein extraatje onder "Small things", geen kop.
   - enUS: `CHANGELOG_476_8 = "Marker bar: playing with the same friends? Everyone can pick their own marker (/mh mark me star), and one button marks them all, whatever character they play. Friends without MH: /mh mark friend Name#1234 circle."`
   - Notes (Small things): *"**Playing with the same friends?** Everyone can pick their own marker once (`/mh mark me
     star`), and a new button on the marker bar marks them all, whatever character they are on. Friends without MH can
     be linked by BattleTag (`/mh mark friend Name#1234 circle`)."*
3. **`/mh export` realm + regio** (site-chat 10 okt): kopregel eindigt op `;realm=…;region=eu`. Voor spelers onzichtbaar,
   dus geen changelog-regel nodig; wel site-chat de build noemen (de site toont dan de characterfoto).
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
