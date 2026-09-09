<!--
DRAFT, 9 Sep 2026. Not live. The live page is CURSEFORGE_DESCRIPTION.md in the repo root.

Four reviewers read the live page: a first-time addon user, a returning player, a store-page
specialist and a sceptical 25-addon user. They agreed on one thing without conferring -- the
first 350 words are good and the 3740 words of "Highlights" that follow undo them.

WHAT THIS DRAFT DOES
  - 5244 words -> ~1400. About 400 of that is literal duplication and costs nothing.
  - Regroups by WHO IS READING rather than by our Modules/ folder.
  - Gives "we say when we do not know" its own heading. Two reviewers found that principle
    independently and called it the only thing no competitor does; it was buried at word 1056
    as a subordinate clause about a delve consumable.
  - Drops three absolutes that our own never-lie rule should have caught: "the two cannot
    disagree", "(no wrong or missing spell IDs)", "Own, verified data across every class".
  - Says "guessing convincingly" once instead of twice.
  - Adds what the page never had: what to do after installing, and who this is NOT for.

NOTHING HERE IS INVENTED. Every claim is lifted from the live page.

THE FIVE FLAGGED FACTS -- resolved 9 Sep, mostly in the reviewers' disfavour:

  1. "Champion 4/6"  ROB, IN GAME: correct, the track has 6 ranks. The reviewer's "surely 8"
     was wrong. Unchanged, as it should be -- a hunch is not a reason to touch the best
     sentence on the page.
  2. "top-tier crests are earnable solo"  ROB, IN GAME: correct. RESTORED to this draft, in
     the gear paragraph. It is a strong line for a returning player and it was right all along.
  3. 14 delves / 17 raid bosses / 8 Season 2 bosses  MEASURED in our own data, all three exact.
     DelveTipsData ships exactly 14 rosterNames (Venomfall Deeps included); RaidCoachData holds
     4 raid names and 17 encounterIDs, of which the last 8 sit under The Venomous Abyss. The
     reviewer assumed 3 bosses per Season 1 raid; they are 1, 6 and 2.
  4. "52 bosses across dungeons and raids"  DOES NOT MATCH. Our data has 57 dungeon
     encounterIDs across 16 dungeons plus 17 raid = 74. The searchable count is smaller because
     NavSearch indexes only bosses we wrote steps for, and that is a runtime lookup no static
     count can settle. So the number is not verifiable AND it decays every time tips are added.
     It is simply not carried in this draft. A store page should not hold a number that rots.
  5. "Charges are per character and cap at 8"  UNRESOLVED, AND IT IS NOT ONLY A SENTENCE.
     The cap of 8 is corroborated by several guides. "Per character" is contested: some say
     account-wide. Warcraft Wiki does not cover Midnight, but records that Dragonflight S1 was
     "account-wide" yet "spent on a per-character basis" -- which would explain the conflict
     and would make our wording half wrong. THIS DRAFT DOES NOT CARRY THE CLAIM, but
     Modules code does: the addon "names which alts have stopped gaining", which is meaningless
     if accrual is account-wide. Rob can settle it in thirty seconds by comparing the charge
     count on two characters. Until then, neither the page nor the addon should assert it.

  Also corrected: `/mh lang de` on an English client does nothing (locale packs are
  client-gated, measured 18 Aug). The Languages table was fine; the slash-command row promised
  more than it can deliver.
-->

## Midnight Helper

Your gear says "Champion 4/6" and the game never tells you what that means. Your Great Vault has three empty slots and nothing says how to fill them. Your profession window has six numbers on it and no one has ever explained a single one.

Midnight Helper answers those questions in plain language — in your own language — and then takes you there.

**Current for patch 12.1 and Season 2**, Coiled Isle included — measured on the test realm, not copied from anywhere.

**It is for you if you have just hit 90, or if you are coming back after a few expansions away and half the game has been renamed.** If you already know your week by heart, most of this will be telling you things you know.

Free, open source (MIT), no dependencies, no ads, seven languages built in — no second addon to install.

### Start with these three

- **Professions 101** — a fourteen-chapter beginner course, not a help page. Why the same recipe gives two players different results. What those six numbers on your screen actually do. When Concentration is worth spending. How work orders really work, and why there are two counters rather than one. It reads in a window of its own beside the game, because half the chapters end by telling you to go and press something. A **Guided mode** walks a total newcomer through learning and levelling any of the 11 professions, ticking steps off as your skill grows.
- **"What should I do this week?"** — the This Week page opens with the single most useful thing you can do right now and a **Take me there** button that sets the route. While you are still levelling it never proposes endgame content you cannot do yet.
- **Your class, on a keyboard** — your live spellbook drawn onto a clean keyboard layout, every ability on the key it belongs on, for all 13 classes and 40 specs. A new alt or a fresh spec becomes readable in about five seconds.

### Read it before you install

🌐 A good deal of the content is on the web, generated from the same data the addon ships, so the two do not drift: [new at max level](https://huijting.github.io/MidnightHelper/start.html) · [your week and the Great Vault](https://huijting.github.io/MidnightHelper/weekly.html) · [currencies and crests](https://huijting.github.io/MidnightHelper/currencies.html) · [all fourteen Delves](https://huijting.github.io/MidnightHelper/delves.html) · [where your Knowledge Points go](https://huijting.github.io/MidnightHelper/) · [the Coiled Isle](https://huijting.github.io/MidnightHelper/coiled-isle.html).

### What it will not tell you

This is the part most guide addons skip. Where the game will not tell us something, this one says so instead of guessing convincingly.

- In combat, 12.1 hides some of your own buffs from addons and reports them as simply **absent**. Midnight Helper tells you it **cannot see**, rather than telling you that you are missing a buff you are holding.
- Mounts that are pure RNG — a rare drop, a puzzle, a hidden chain — show **no progress bar at all**, because there is no honest number to show.
- `/mh curios` describes what each of Valeera's curios does, read live from your own game, and deliberately **does not rank them**: which one wins depends on your spec and your delve, and nobody has measured that.
- It will not estimate how many delve runs Valeera still needs. How much a single run gives is not something anyone can honestly pin down.
- Season 2 content stays hidden until the season genuinely **opens**, not merely until the patch lands. Those are a week apart.

### Getting started

Install it, log in, and type `/mh` in the chat box. That opens the main window on **This Week**, which is the only page you need on day one. On a character whose bars have never been set up, the front page offers to do it — **once**. Dismiss it and it stays dismissed.

Nothing is changed in your game unless you press a button, and the bar setup shows you exactly what would move before anything moves.

### What else is in it

**Your first hour, and your keys.** `/mh setup` does the whole bar-and-keybind job in one panel — and tells you which character you are on and whether your keybinds are **account-wide or this character's own** *before* it offers anything that changes them, because getting that wrong quietly rebinds every alt you have. Our recommended layout is a button, not a picture to copy: it touches action bars 1-8 and nothing else, and a second button restores what you had. `/mh binds` prints the keys you actually have — including anything you changed by hand — in a window you can copy and print.

**Your week.** Weekly reset countdown, account-wide Great Vault status, this week's world boss, weekly chores, Ritual Sites and Void Assaults with one-click routes. An **account snapshot** across your characters: keys, shards, item level, vault status, and a badge for anyone not logged in since reset.

**Your gear.** `/mh tracks` names the slots at their upgrade ceiling and the two ways onward — and the part that is easy to miss: **top-tier crests are earnable solo**, through high Bountiful Delves and repeatable Tier 6 Ritual Sites. You do not need a raid group. The **Great Vault Advisor** ranks your loot choices against what you are wearing, on Blizzard's own vault screen. `/mh stats` explains what crit, haste, mastery and versatility do in your spec's order, with your live percentages — and opens by saying that higher item level almost always wins, because a beginner who has just learned about stats will otherwise turn down an upgrade to chase a colour.

**Coaching, in the content.** The **Delve Coach** covers all 14 Midnight delves with routes, bosses and 3D previews, and lists the avoidable damage for the instance you are actually in — 173 named hazards, in your own language, because the names come from your client. The **Raids** page has beginner steps for every boss, and the Raid Coach opens by itself when a pull starts.

**Getting there.** A route arrow that rotates, shows live distance and drives the game's own waypoint. `/mh plan` lays out the whole journey as clickable steps, takes the door when a door beats a flight, and says why. If you run **TomTom**, it stands aside; alongside **WaypointUI** you get both.

**Collecting.** The 19 new Midnight mounts as a checklist with live progress and a 3D preview. Rares with per-character weekly tracking, routes, and an alert when one is up near you that steers you there and then puts you back on your route. Midnight's treasure, telescope and lore hunts with every coordinate measured.

**Reference.** The **Midnight Codex** in-game handbook, a **Role Academy** for tank, heal and DPS, macro templates, per-spec consumables, and a Silvermoon City guide. A global search takes a word you type to the page that answers it.

### New in patch 12.1

The **Coiled Isle**: rares mapped with the hidden kill quests that let the list tick itself off, treasure and lore hunts with measured coordinates, and the seven treasures that need something done first now name the step that unlocks them. A Coiled Isle shelf in the Codex with clickable waypoints on every coordinate. **Altar of Fangs** and the two new delves, **Gnarldor Isle** and **The Ring of Glory**, in the coach. The **Mysterious Mix Master**'s ten offerings with their ingredients.

⚠️ Since 12.1 the **Catalyst keeps** the secondary stats, tertiaries and item level of whatever you feed it — a badly rolled piece comes back badly rolled — which is the opposite of the old habit of converting your leftovers.

### What this does not replace

It is not a boss-mod, a damage meter, a bag addon or a unit-frame replacement, and it does not try to be. If you already run DBM, Details! or HandyNotes, keep them.

### Languages

Full UI, coach tips and guide content in English, Deutsch, Français, Español, Português (BR), Italiano and Nederlands. Your WoW client's language is picked up automatically; Dutch is chosen by hand with `/mh lang nl`, since there is no Dutch client. Other locales fall back to English.

Short labels — stat names, `DPS`, `Flask`, `Bountiful` — stay English on purpose, because your tooltips do too. Something reading wrong in your language is exactly the report worth making.

### Requirements

WoW Retail. No dependencies. TomTom and WaypointUI are optional and supported if you have them.

> 🌙 **One person writes this, in their spare time.** Everything in here is checked against the live client before it ships, and where the game will not tell us something the addon says so. That does mean updates arrive in bursts rather than on a schedule — and it is open source under MIT, so the work does not vanish if I do.
>
> Found a bug, or want to help translate? Come say hi on [Discord](https://discord.gg/kBHaHcsASQ) — beginners very welcome. **`/mh report` in game** writes down what you were doing and where, so "it told me something wrong" is a report worth sending rather than a feeling you cannot pin down.

### Slash commands

`/mh` opens the window · `/mh setup` bars and keybinds · `/mh course` the professions course · `/mh report` send a bug report.

Around forty more are listed and explained inside the addon, under **Tools**, where they cannot drift from what it actually answers to.

### Credits and References

Guide data cross-checked against Wowhead and Icy Veins. Boss, spell and item names come from the game's own data. Thanks to everyone who has reported something that read wrong.

### Disclaimer

World of Warcraft and Blizzard Entertainment are trademarks or registered trademarks of Blizzard Entertainment, Inc. This addon is not affiliated with or endorsed by Blizzard Entertainment.
