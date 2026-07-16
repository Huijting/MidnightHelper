## Know your role — and see how it went

This release is about **doing your job in a group**: what to press, when to press it, and an honest look at how the run actually went. Plus everything for Season 2, quietly waiting until the patch lands.

### 🎓 A toolkit for every role

The Role Academy now has a **spec-aware toolkit** for **healer, tank and DPS** — the buttons *your* spec actually has, not a generic list.

- **Healer** — your healing cooldowns, each labelled with what it is *for* (a raid-wide hit? the tank? sustained damage?), a deepened beginner course, and a **"what can I dispel?"** reference for your spec.
- **Tank** — your active mitigation and your personal defensives.
- **DPS** — your damage cooldowns and, yes, your **personal defensives**: a dead DPS does zero.
- Hover any spell for its tooltip. Cooldowns are read from the game, and the list shows **only what you have** — so you see Berserk *or* Incarnation, never both.

### 💀 "What just killed me?"

Dying used to leave beginners guessing — especially in delves and ritual sites, where the game **hides the cause from addons entirely**.

- In dungeons and raids, Midnight Helper names **the blow that killed you** plus a short lesson, on a card you can actually read.
- In delves, ritual sites and follower dungeons — where we genuinely *cannot* know — it opens **Blizzard's own Death Recap** for you, which does still work there. It asks once whether you want that, and you can change it any time in Settings.

### 🛡️ Tank pull summary

After a real pull, one line on how it went: your **active-mitigation uptime**, which defensive cooldowns you used, and a gentle nudge if you used none. Brewmaster gets a Stagger reading instead.

- `/mh pullsummary` — on/off · `boss` for boss pulls only · `popup` for a card instead of chat · `status` to see what is on.
- Trivial trash pulls are skipped. Where the game hides your buffs, it says so rather than claiming a false 0%.

### 🥊 Interrupt scorecard

See how your kicks actually went — landed versus wasted — with an optional, private nudge when you fire one with nothing to interrupt. `/mh kicks`.

### 📈 Mythic+: which key is worth the most?

`/mh mplus` now shows **your season best per dungeon** and where another key adds the most rating — plus an honest gear pointer to the keystone tooltip and the Great Vault, instead of numbers we cannot verify.

### 🎁 Openables

Reward and currency packs (*"Use: Collect 10 …"*) and cosmetic appearances you have not collected yet are now recognised. Items with a requirement you do not meet are hidden instead of teasing you.

### ⌨️ Keybind coach: your whole stop-toolkit in one place

Your interrupt card now also lists the **other** abilities that stop a cast — a stun, a silence — each tagged with why, while they keep their own key. Blinding Light is not in there: it will not reliably stop a cast, and we would rather tell you that than pad the list.

Druids: your four forms now sit on the **same keys in every spec** — Travel on `R`, and Cat/Bear/Moonkin on `Shift+R/T/X` — so you stop hunting for them.

### 🌑 Season 2, ready and invisible

The Season 2 raid, lair and dungeon, and the whole Mythic+ rotation, are already in — and stay completely hidden until patch 12.1 goes live, then light up on their own. Nothing changes for you today.

---

## Fixed

- The main window now grows tall enough for the full sidebar — the last tab no longer hangs off the bottom edge.
- Codex entries no longer overlap the next entry's title.
- The **Omnium Folio** button explains itself instead of opening another expansion's window, and tells a levelling character that the Folio opens at max level.
- No more error spam in **delves and ritual sites**, and the death card no longer appears on **PvP deaths**.
- A handful of class abilities that were missing from the keybind coach are back — and one that belonged to a different class entirely is gone.
