# Proposal — upgrade calculator

Status: **proposal, not built.** Rob raised it on 5 Aug 2026 after seeing
EllesmereUI's Upgrade Calculator. Deliberately scheduled for **after Season 2
starts (18 Aug)** — see the timing section, which is the whole argument.

## What it would answer

One question, in one screen: *what would it cost to finish my gear?* Per slot, how
many upgrade steps remain and on which track; totalled, how many crests that is;
against that, how many you own.

## Half of it already exists here

`Modules/TrackCeiling.lua` reads `C_Item.GetItemUpgradeInfo(itemLink)` for every
equipped slot and already knows the track and the current/maximum step — the same
API and the same per-slot walk a calculator needs. It answers "I am on Hero 6/6,
now what?" and stops there.

What is missing is only the arithmetic: steps remaining × cost per step, against
what you hold.

## ⚠️ The constraint that decides the design

**Upgrade costs cannot be read anywhere.** Verified in EllesmereUI's own
implementation (`EllesmereUIQoL/EUI_UpgradeCalc.lua:446`, `:491`):

    C_ItemUpgrade.GetItemUpgradeItemInfo()   -- no arguments

It returns data for whichever slot is **currently selected in the Upgrader
frame**, and passing a slot argument is silently ignored and returns nil. So the
only way to get true costs is to stand at the Upgrader NPC, select each slot in
turn, and wait roughly 0.3s per slot for the frame to populate asynchronously.

That is why their panel carries an "Update at Upgrader" button rather than simply
knowing.

It leaves exactly two designs:

1. **Scan and cache at the NPC.** Accurate, and honest about being a snapshot.
   Costs a visit, and the cache is stale the moment the season changes.
2. **A maintained cost table.** Works anywhere, and is wrong every time Blizzard
   touches the numbers — with no signal that it has gone wrong.

Design 1 is the only one that fits this addon's rule about never stating a number
it has not measured. Note that their own display still reads
`Total Crests Needed (est): 280 Hero` — they estimate even with the scan.

## Timing: not before 18 August

Season 2 renames the crests to **Mistcrest** and sets its own costs per step. Any
table built on Season 1 numbers is wrong in under two weeks, and wrong in the worst
way for this addon: a calculator does arithmetic, so people believe it. A guide
that reads oddly gets questioned; a total that is confidently 40 crests short does
not.

Build it after S2 is live, and read the costs from the game rather than from an
article. `docs/CREST_SOURCES_MEASURED.md` already holds the measured Mistcrest ids.

## Corroboration worth keeping

Their calculator shows **Earned/Cap** as `1053 / -`. A dash for the cap. That is
independent support for the 2.11.1 correction, which removed a claimed weekly cap
of ~100 per colour from seven languages — and which our own daily watcher has
since repeated as fact twice. If anyone reopens that question, this is a second
implementation that also finds no cap. See `docs/CREST_SOURCES_MEASURED.md:275`.

## What it must not become

No estimates presented as totals. If a cost has not been scanned at the Upgrader,
the honest output is "not measured yet" plus a button that goes and measures — not
a plausible number. The point of this feature is to be trusted with arithmetic,
and one wrong total spends that trust permanently.
