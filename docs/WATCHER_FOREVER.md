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

## Weapon advice — every run (added 25 Nov 2026)

Rob, 25 Nov 2026 (via the sparring chat, his words): *"Zorg er ook voor dat in onze controlerondes elke dag gecontroleerd
wordt of er wijzigingen zijn die hier invloed op hebben."* and *"En dat bedoel ik natuurlijk bij patch notes en dat soort
dingen allemaal."* "Hier" = the "Which weapon?" advice for all nine classes and the stats sentences. Every claim, its source,
its measuring point and where it lives in the code is in **`docs/forever/WAPENADVIES_FEITEN.md`** — read it.

- **Content watch** and **blue post / data watch**: read ALL Blizzard sources with changes since your newest entry — the
  official Forever patch notes (news.blizzard.com, worldofwarcraft.blizzard.com), the "WoW: Forever Hotfixes" articles
  and hotfix posts (thread 2403040), the dev/beta notes (Kaivax, thread 2360696), class deep dives, and "known issues" /
  blue posts on the Forever forums — for the keywords at the bottom of that file. The content watch asks "does this
  contradict a claim in the register", the data watch "is this a new fact for a row in it".
- **API watch** (it already notes new `wowf` builds): when there is a NEW Forever client build, compare the DB2 rows the
  register calls GEMETEN with the previous build (wago.tools DB2 on the `wowf` branch: SkillRaceClassInfo, SpellLevels,
  SpellEquippedItems, ChrClasses, SpellShapeshiftForm, ItemDamageTwoHand/OneHand, the talent trees named there) and name
  any row that moved.
- Watch the rows marked 🟠 (BETWIST / NIET GEMETEN) extra: a Blizzard word on one of those is always worth a line.
- **Output**: one line per hit, in your own file under your **Forever:** sub-bullet, starting with `⚔️ Wapenadvies:` —
  the claim (as the register words it), the source with its date and URL, and the place in the code (key or file).
  Nothing found = one line `⚔️ Wapenadvies: niets dat het register raakt (gelezen: …)`, naming what you read. **Change
  nothing yourself**: the sparring chat puts it to Rob.

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
