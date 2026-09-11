# Midnight Helper 3.11.0

Most of this release is about what sits behind a number. A total means little if you read it as
your own. A green tick means little if it could never have been anything else. And a popup that
waits for an item nobody gets any more looks exactly like one with nothing to say.

## What your characters hold — and what to do with it

The Currencies page opens with a new block, **Your characters**: one row per useful currency —
Restored Coffer Keys, Coffer Key Shards, Venomblight Manaflux, Undercoins, Untainted Mana-Crystals,
Corrosive Coin, Voidlight Marl, Field Accolades and the five crests.

- Every row shows two numbers: **You** — the character you are on — and **Total**, every character
  added up. The first version showed only the total, and the first person to test it read 914
  shards as his own.
- One line per row says what the currency is for. It turns **orange only when something is lost
  unless you act** — a character sitting at a cap. Those caps come from the game itself, not from a
  number we typed in.
- Hover a row for every character's amount. A character not logged in since the reset carries a
  clock; one not seen since this update says so, instead of showing a zero that would read as
  "none".
- Currencies you can move between your characters say so, and where.
- `/mh curscan` prints the raw fields the block acts on.

## The Account snapshot, readable

At the end of every row the numbers ran into each other. The table has been rebuilt:

- Real columns: **level and item level**, **Vault** (choices unlocked out of the total, like 1/9),
  **Keys**, **Shards** in your wallet, this **Week**'s shards with a tick at the cap, and
  **Undercoins** and **Mana-Crystals** under the game's own icons. The old "Under / Mana" header was
  translated as a preposition in four languages.
- Characters not logged in since the reset are dimmed with a clock, and hovering says why and what
  to do.
- **Characters below the max level fold under one line.** The one you are playing never does.
- Hover a character and the tooltip opens with **what is still open for it this week**: a vault
  reward to pick, full Catalyst charges, shards left before the weekly cap, the vault row closest to
  its next choice, keys to use.
- Every column title says what it is, why it matters and when it resets. The delete button only
  appears when you hover a row.

## Trovehunter's Bounty: the Season 2 map

The delve popup, the toast, the delve buttons and the weekly tracker were all looking for the
Season 1 map — the one nobody gets any more. They now look for the Season 2 map, confirmed in the
game.

## Macros you can find

- **Hunter:** Kill Command with pet attack (Hunter's Mark on the opener), mouseover Barbed Shot,
  cursor traps, mouseover Hunter's Mark, and Marksmanship shots that do not break Rapid Fire.
- **Guardian Druid:** mouseover Growl. **Shadow Priest:** casts that do not break Void Torrent.
- Macros whose spells Midnight removed or renamed are replaced: Final Reckoning became a mouseover
  Execution Sentence, Shadow Crash became Tentacle Slam, Spear of Bastion is Champion's Spear.
- `/mh macros` opens them, search finds every macro by name, and `/mh macrocheck` asks your game
  which spells in your spec's macros you actually know.

## Curse Surges

- The five surge bosses have left the Rares list — they are the finale of a Curse Surge event, not
  rares — and now sit on an achievement card, **Turn the Surge**.
- Achievement cards say what they are: Event, Pet battle, Mixing.
- **Mix Master** shows its unlock conditions when you hover, with your live Renown, and the
  cauldron waypoint now points at the cauldron.
- The **Find Dundun** macro also puts a moon raid marker on him. A ping fades on the game's clock; a
  marker stays.

## The weekly screens

- *"You're all caught up this week"* no longer appears above *"8 of 13"*. When nothing is left to
  pick up but the week is not done, it says that instead.
- Vereesa Windrunner's weekly that hands out a Spark, *Trailing Xal'atath*, is on the list.
- Each weekly screen ends with a line naming what the other one covers. Each was quietly half of
  your week.
- If you stood at a quest giver since the reset and the game offered you quests, that now outranks
  a quest flag that says "done".
- A rare's toast says what to do on the card itself — *open the chest* for Farthik — not only in
  chat.
- Valeera's tip to keep healing her appears only when the talent behind it is actually taken.

## Smaller

- **Eight screens have their own key binding** — This Week, Rares, Delves, Codex, Professions,
  Achievements, Mounts and the Account snapshot — for a Stream Deck or a spare key. Find them under
  Midnight Helper in the game's Key Bindings. Nothing is bound by default.
- **`/mh cleanup`** shows the measurement data our diagnostic commands leave in your saved
  variables, and clears it after you confirm. Your settings stay. On the machine it was built for,
  that file went from 4 MB to under 1 MB, and it is loaded at every login.
- **Edit Mode backups** no longer store a copy of an unchanged layout at every login, so the one
  from before you changed something is kept.

## What we are working on next

No dates, and nothing here is a promise:

- **Weekly ticks for quest givers whose quests rotate**, like Lady Liadrin. The game keeps some of
  those quests marked as done long after the reset, so a tick can be wrong in a way you cannot see.
  The addon now records what you hand in, next to the game's own flags, and the first reset will
  show which to trust.
- **Item level and enchant per slot** on the character sheet.

If something in the addon is wrong on your screen, saying so is the fastest way it gets fixed —
several items above started as exactly that.
