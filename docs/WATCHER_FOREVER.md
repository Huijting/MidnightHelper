# WoW: Forever — extra opdracht voor de vier ochtendwachters

Rob, 11 nov 2026: *"Ja, voeg Forever toe aan de wachters, en laat ze dan nog een keer lopen"* (bevestigd in de bouwchat).
Elke van de vier opdrachten (API, PTR/roadmap, blue post/data, content) eindigt sinds die dag met een korte regel die naar
dit bestand wijst. Dit bestand is dus deel van hun opdracht: wijzig het alleen in de bouwchat, met Robs ja.

## Voor alle vier

Since release 5.0.0 Midnight Helper also runs in **WoW: Forever** (client 1.60.x, Interface 16001, `MidnightHelper_Camelot.toc`,
live since 4 Nov 2026). Skipping Forever was right when your prompt was written and is wrong now. A rule in your prompt that
says to skip "Classic" does **not** cover WoW: Forever any more.

What the addon claims about Forever lives in: `Modules/Forever*.lua` (trainers, weapon masters, vendors, professions, macros
per class and spec, travel planner, warnings, buffs), the Forever keys in `Locales/` (prefixes `FTRAVEL_`, `FWEAP_`, `FMAC_`,
`FVEND_`, `FWARN_`, `FTRAIN_`, `FPROF_`, `FWEEK_`, `FRANK_`, `FBUFF_`, `FQH_` — measured in `Locales/enUS.lua` on 11 Nov
2026; grep for more, do not guess), and the research notes in `docs/forever/`.

Sources for Forever: the "WoW: Forever Hotfixes - <date>" articles on news.blizzard.com, the Forever forums
(us.forums.blizzard.com), the Blizzard blue trackers (bluetracker.gg, Wowhead), and wago.tools builds on the `wowf` branch.

Same standards as for Midnight: MEASURED / INFERRED per claim, a positive control at the same scope in the same run, never
guess an ID, a cache-buster (`?nocache=YYYYMMDD`) on every Exa URL. Write in Dutch. Touch only your own file. Put the Forever
part of your entry under its own sub-bullet starting with **Forever:** so Rob can find it.

The nightly check (`docs/NACHTCONTROLE.md`, events C1 and numbers C2) already covers Forever. Do not redo that.

## Content watch (`docs/CONTENT_WATCH.md`)

Read the Forever hotfix articles and Forever blue posts and test them against what the addon CLAIMS about Forever (files
above). A class change counts when it changes a spell, level, price or rule that a Forever text or macro names; bare damage
percentages do not. Same labels as for Midnight.

## Blue post / data watch (`docs/PTR_12.0.7_DATA.md`)

Your skip rule "anything Classic" now reads "anything Classic EXCEPT WoW: Forever". Collect Forever FACTS: trainer and skill
prices, level requirements, vendor stock, profession rules, weapon skills, XP rules, travel connections (boats, zeppelins,
tram, portals), caps. Per fact: which Forever module it is for.

## PTR / roadmap watch (`docs/PTR_12.1_WATCH.md`)

Also what is still COMING for Forever: the next patch or phase, roadmap statements, new builds on the `wowf` branch, and any
Forever test branch. Same rule as for Midnight: unreleased = may change, every entry ends with "(in-game verifieren)".

## API watch (`docs/API_WATCH.md`)

Also the addon/API side of the Forever client (Interface 16001), tested against everything `MidnightHelper_Camelot.toc`
loads. Use the same three labels. Gethe/wow-ui-source has a Forever branch (tag `1.60.1`), which you already note. Do not
redo the event check; the nightly check does that.

## ⏱️ Eenmalig: inhaalronde 11 nov 2026

Only when today is **2026-11-11** AND your file already has a regular entry dated `[2026-11-11]` (the morning run): this is
the extra catch-up run. Then:
- do NOT write a regular entry again;
- cover WoW: Forever only, everything since launch (4 Nov 2026): all "WoW: Forever Hotfixes" articles (newest known:
  10 Nov) and the Forever blue posts (the data watch named PvP Faction Balance and Dungeon Enemy XP);
- write ONE extra block at the bottom of your own file starting with `- [2026-11-11] 🕰️ **Forever-inhaalronde (extra run):**`;
- four watches push at the same time: `git pull --rebase origin main` and retry the push up to three times;
- the API watch skips the Gmail draft this time.

On any other day, or if today's regular entry is missing, ignore this section completely.
