# Patch 12.1 research — curated summary

> This file is a curated summary. The automatically generated PTR watch files and
> measured research documents are the underlying source material.

**Sources, in order of authority:**

| File | What it is | Maintained by |
|---|---|---|
| `docs/PTR_S2_ENCOUNTERS.md` | Season 2 dungeon/raid/lair ids, read from the Encounter Journal | measured, 2026-07-27 |
| `docs/PTR_DELVE_SCAN.md` | Delves the client offers, with poi ids and coordinates | measured, 2026-07-27 |
| `docs/PTR_VALEERA_TREE.md` | Valeera's full companion trait tree | measured, 2026-07-27 |
| `docs/CREST_SOURCES_MEASURED.md` | Crest sources and ilvl ranges per tier | measured, 2026-07-22 |
| `docs/PTR_12.1_WATCH.md` | Daily 12.1 news scan | written automatically |
| `docs/PTR_12.0.7_DATA.md` | Daily live-patch data scan | written automatically |

Do not copy datasets in here. Update this file only when a **conclusion**, a
**confidence level**, a **conflict** or an **implementation decision** changes.

Per-value evidence status lives in `docs/EVIDENCE_REGISTER.md`.

---

## Officially confirmed

Nothing about dates. **Blizzard has announced no release date for patch 12.1 or for
Season 2.** Blizzard has announced that Season 1 ends "soon", without a date.

## Live verified (12.0.7)

The Season 1 achievements that expire are all real and all readable: 61797, 61798,
61799 and 62351, plus 61808 which nobody announced. All are hidden Feats of Strength —
invisible to a walk of the achievement categories, findable only by sweeping ids. The
nemesis is spelled **Nullaeus**, per the client's own text.

The weekly crest cap that several guides describe **does not exist**; every tier reports
a maximum of 0.

## PTR / provisional (build 120100, release candidate 68914)

Season 2's eight dungeons, its raid and the Tidebound Grotto lair are measured and
implemented, all season-gated. Three counts cross-check against the patch notes, which
is the main reason to trust the rest.

Valeera gains a Poisons choice node. The three spell ids are measured; **what they do is
not known to us**, because the effect descriptions in circulation were attached to ids
the client does not have.

~~Auras have not gone secret on the release candidate.~~ **RETRACTED 2026-07-28.**
`ShouldAurasBeSecret` did read false in the open world and inside a delve, but both
readings were taken standing still, OUT OF COMBAT -- and that is the one state where
the answer is always false. JustAC 4.55.0 models the flag as flipping at combat
edges, and falls back to `IS_MIDNIGHT_OR_LATER and InCombatLockdown()` when the API
is missing, i.e. secret IN combat, validated in-game on 12.0.7 per its own comment.
Moved to Unresolved below.

The one real 12.1 bug in the addon — combat warnings erroring during delve fights — is
fixed and confirmed silent across multiple fights.

## Datamined only

Three new delves (The Ring of Glory, Gnarldor Isle, Venomfall Deeps) and a new nemesis
(Azta'rec). None appeared in a scan of what the client currently offers, which is
expected: Season 2 opens after the patch, so a pre-season scan cannot see them either
way. Re-scan once the season is live before concluding anything.

Season 2 item levels are reported as +46 over Season 1. Used only to answer a question;
implemented nowhere.

## Unresolved

**Roleset — measured 2026-07-27, and it is not a blocker.** The system is already live on
build 120100. Every frame belongs to a roleset named `roleless` by default, and every
frame carries `IsRolesetFiltered()`, so this is checkable rather than a matter of hope.
Right now `GetActiveAllowedRolesets()` and `GetActiveBlockedRolesets()` both return empty
lists and nothing of ours is filtered.

The residual risk is one specific shape: an **active allowlist that does not include
`roleless`**. That is what "frames in an inactive roleset will never be shown" would mean
in practice, and it would take out every default frame at once -- ours and most other
addons'. Unknown: which content activates a list, and which roleset names exist. Both are
measurable with `/mh roleset` inside whatever content does it.

**Auras in combat.** The 27 July measurement was taken out of combat and therefore
says nothing about the state that matters. If auras are secret during a fight, three
things are affected and none of them have been checked: MissingBuff reading party
auras, the new dispel alert reading your own debuffs mid-fight, and CombatSafety.
`/mh auras` now prints the combat state so a reading can no longer be filed without
its condition.

**Party and raid auras.** Separately from the above, only the player's own auras have
been read at all. `/mh dispelprobe` exists for the ally side and has not been run.

**Dates.** The community projects 11/12 August for the patch and 18 August for Season 2,
derived from the release-candidate build. These are projections. They must not appear as
confirmed in the addon, the release notes, the CurseForge page, Notion, the book or
Discord.

## Conflicts retained

The Season 1 ending announcement named four rewards. Three of those names could not be
found in the client at first, which looked like the announcement being wrong. It was not:
the achievements exist as hidden Feats of Strength. **Both observations are kept** — the
names were right, and a category walk cannot see them.

Wowhead's Valeera poison spell ids and the client's disagree completely. Implementation
follows the client. The published effect descriptions are treated as unproven rather than
discarded, since only the ids were shown to be wrong.

## Aura reads in 12.1 — the index/lookup split (2026-07-28)

Measured on live 12.0.7, own debuffs, The Gulf of Memory, Prot Paladin:

| | spellId | name | dispelName |
|---|---|---|---|
| out of combat | read | read | read |
| in combat (331x) | secret | secret | secret |
| in combat (109x) | secret | secret | nil |

1091 in-combat scans all reported **OK** while every field was secret. A successful
scan says nothing about whether it told you anything; this is why `DispelHelper`
counts hidden auras separately from absent ones.

The published 12.1 API notes then split the picture in a way the measurement above
could not see. Reads by **index, slot or instance id Lua error** for addons while
auras are secret; APIs reached by **spell id or name keep working**, with non-secret
spells returning non-secrets. `UNIT_AURA` delivers a fully secret payload, and
AuraData structs are documented as fully secret. New `DISPELLABLE` filter;
`SecureAuraHeaderTemplate` removed; new AuraContainer / AuraButton /
ManagedAuraContainer display types that render auras without exposing them.

Consequences for MH:

- `Aura.Scan` already behaves correctly under the change. Every index call is in
  `pcall`; an error returns false, which the facade already defines as "could not
  read" rather than "absent". No code change needed for the error path.
- Enumeration dying does **not** by itself kill the dispel helper. It can ask about
  the ids `dispelCapture` has collected from real play instead of discovering them.
- Unverified: whether id lookup answers on **today's** 12.0.7, and whether a hit
  returns readable fields or a table of secrets. `dispelLookupLog` records exactly
  this. Three outcomes are possible and only measurement separates them: full data,
  presence-only ("something dispellable is on you", no school), or nothing.
- Untouched: party and raid auras. Everything above is the player's own.

Sources: warcraft.wiki.gg Patch 12.1.0/API changes; Icy Veins aura-API summary. Both
describe the PTR — verify in game.

## Party targets — you may DISPLAY a secret you may not READ (31 jul 2026)

Measured with `/mh partytarget` in a follower dungeon, in combat, four members.

| read on the target | enemy target | party-member target |
|---|---|---|
| `UnitExists` | read | read |
| `UnitName` | **SECRET** | read |
| `UnitFullName` | **SECRET** | read |
| `GetUnitName` | **SECRET** | read |
| `UnitGUID` | **SECRET** | read |
| `UnitIsUnit(x,"target")` | **SECRET** | read |
| `UnitIsPlayer` | read | read |

The line is not "targets are hidden". It is **who you are attacking is hidden**:
everything about a friendly target reads, everything about a hostile one does not.

Three consequences, all measured rather than reasoned:

- **No alternative name API helps.** SimplePartyTargets tries UnitFullName, then
  GetUnitName, then UnitName. All three are secret here.
- **A GUID cache cannot work.** SimplePartyTargets remembers a name per GUID and
  replays it once the live read goes secret. The GUID is secret too.
- **Comparisons are shut as well.** `UnitIsUnit(party1target, "target")` returns a
  secret BOOLEAN, so an addon cannot even ask "is this the same thing I am on" and
  branch on the answer. Testing that value throws — see below.

### But the display path is open, and that is proven

Rob runs Danders Frames with SimplePartyTargets and **sees the real enemy names on
screen** — the same names this probe reports as SECRET. So a secret can be handed
to a display widget and rendered; what an addon may not do is look at it.

That makes a party-target panel possible, with a precise limit: it can SHOW the
name and can do nothing WITH it. No sorting by target, no "three of four are on
your target", no colouring a row by whether it matches yours. Every one of those
needs a read, and every read is refused.

### A trap worth knowing

`x = ok and v or nil` throws on a secret boolean: `and`/`or` evaluate truthiness,
and for a boolean the truthiness *is* the protected answer. A secret STRING passes
through the same expression without complaint. Move suspect values with a plain
assignment; never let an expression ask what they are.

### WRONG — I read "combat is the gate" off a case with no data (31 jul)

The table above came from a follower dungeon, which left two ways to explain it:
the content, or the fact that everything there is an NPC follower. A ritual
scenario with a real player settles it, because the same character was measured
twice minutes apart.

    in combat: false     target name=nil  same-as-my-target=read false  GUID=nil
    in combat: true      target name=SECRET  same-as-my-target=SECRET   GUID=SECRET

Out of combat every route reads. In combat every route closes — the three name
APIs, the GUID, and the UnitIsUnit comparison alike. `UnitExists` and `UnitIsPlayer`
keep reading in both.

So it is the same combat edge the aura work found in July, where
`ShouldAurasBeSecret` flips on entering and leaving combat. One rule, two features.

Which is the worst possible shape for a helper: out of combat you may ask anything
and have no reason to, and the moment you need it the door shuts. It is also why
the party-targets panel can only DISPLAY — every question worth asking about a
target is a combat question.

### RETRACTED — the gate is the TARGET being hostile, not combat (31 jul, later)

The section above is wrong and is kept only so nobody re-derives it. A third
measurement, same scenario, same character:

    in combat: FALSE     target exists=read  name=SECRET
                         same-as-my-target=SECRET   GUID=SECRET

Out of combat, and secret anyway. What actually differed in the "everything reads"
run was not combat — it was that the party member **had no target at all**
(`name=nil`). The comparisons returned a plain `false` because there was nothing to
compare against, and I read that as permission. It was an absence of data, not an
answer.

So the rule is simpler and stricter than either earlier version: **anything about a
HOSTILE target is secret, in or out of combat.** A friendly target reads normally,
and `UnitExists` and `UnitIsPlayer` read in every case measured so far.

Nothing changes for the party-targets panel — it never depended on reading, only on
displaying, and that still works. What changes is the story we tell about why, and
a wrong story is what the next person builds on.

The lesson is not about auras or targets. Two of tonight's three conclusions came
from a sample where the interesting value was missing, and "readable" and "nothing
there" look identical from the outside. Check that the case you are measuring
actually contains the thing you are measuring.

## Ritual tier: the client does not know it once you are inside (1 aug 2026)

`/mh tier` in a live Ritual Site, Daggerspine Point:

    GetInstanceInfo   name=Daggerspine Point  type=scenario
                      difficultyID=12  difficultyName="Normal Scenario"

    C_DelvesUI.GetActiveDelveTier()   = table, but every field empty:
                                        tier=0  suggestedILvl=0  unlocked=false
                                        tierDescription=""  modifierUIWidgetSetID=0
    C_DelvesUI.GetTieredEntranceType()= 0
    C_DelvesUI.GetDelveEntranceTiers()= empty table

    C_ScenarioInfo.IsTieredEntranceScenario() = TRUE
    C_Scenario.GetInfo()     = "Daggerspine Point"
    C_Scenario.GetStepInfo() = "Ritual Roles"

This kills the hypothesis that `GetActiveDelveTier` — untried by anyone, and the
one call MH already uses for delves — would answer here. It answers, and it answers
zero.

Note the shape of that: the game says `IsTieredEntranceScenario() = true`, so it
knows the entrance was tiered, while every call that would name the tier reads
empty. And `difficultyID` is a constant 12 regardless, so the tier is not part of
the instance's identity the way a delve's is.

**Why the 27 zeroes happen:** RitualLog and DelveHistory both derive the tier with
`difficultyName:match("(%d+)")`. A delve is "Tier 8"; a ritual is "Normal Scenario".
Every fallback repeats the trick on another string — scenario name, step name, the
objective tracker — and in a ritual none of them carry a digit either. It is
mechanism, not a run of bad luck.

**What is still unmeasured, and it is the only route left.** The tier list reads at
the OBELISK, before entry. But `GetDelveEntranceTiers()` returns the tiers on offer
— six, all unlocked — not the one selected. Capturing that at the entrance would
record "six were available" and leave the run at zero.

So the open question is not "can we read the tier inside" (answered: no) but
**"does anything report the SELECTED tier at the entrance"**. That needs someone at
the obelisk picking a tier and re-running `/mh tier` to see which value changes.
Until then, tier 0 on a ritual run means unknown, and it should keep saying so
rather than inheriting a guess from the offered list.

### And not at the entrance either — the selection is invisible (1 aug 2026)

Rob's experiment, and a better one than mine: stand at the obelisk, select each of
the six tiers in turn, save a labelled snapshot per selection, without entering.
Seven records including a baseline taken before arriving.

| snapshot | activeTier.tier | entranceType | #tiers | tier list |
|---|---|---|---|---|
| geen (away from obelisk) | 0 | 0 | 0 | empty |
| tier1 … tier6 | **0** | 2 | 6 | **byte-identical** |

`GetActiveDelveTier().tier` stays 0 through every selection, and the six-entry list
from `GetDelveEntranceTiers()` serialises to exactly the same 876 characters
whichever tier is highlighted. Nothing in it moves: no `isSelected`, no changed
`unlocked`, nothing. The snapshot kept every key two levels deep precisely so a
field nobody had named could not slip past, and there was none.

`entranceType` does flip 0 → 2 on arriving, so the client will tell you a tiered
entrance is present. It will not tell you which tier you chose.

**Conclusion, narrow version: the entrance does not mark your choice.** The offered
list must never be mined for a plausible number, and "highest available" would be
exactly that. Tier 0 in RitualLog still means unknown today.

### RETRACTED: "a ritual run's tier cannot be recorded" (1 Aug 2026)

This section previously ended with that sentence, and it was a leap. What was
measured is one API family (`C_DelvesUI` / `C_ScenarioInfo`), at one place (the
obelisk), before entering. "Cannot be recorded" is a claim about every route, and
the measurement covered one.

Rob's reaction is what caught it — he did not believe Blizzard had said nothing
anywhere, so the installed addons were searched instead of reasoned about. Of ~90
addons in the folder, exactly one reads a tier, and it does not use the delve API
at all. `DBM-Core/modules/objects/Difficulties.lua:565`:

```lua
local delveInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183)
...
delveTier = tonumber(usedDelveInfo.tierText)
```

The tier travels as **display text on a UI widget** — the "Tier 8" caption above
the objective tracker — not as an API value. The client sends the number down; it
just never offers it as a number. Nothing in the obelisk experiment could have
found this, because widgets were never read.

Two supporting facts, both verified in this folder rather than assumed:
`C_UIWidgetManager.GetAllWidgetsBySetID` is used 39 times across installed addons,
and `Broker_MidnightEvents/Core.lua:2153` records that empty set IDs return nil
cheaply, so sweeping is a normal technique and not a hack.

**Still open, and now measurable.** DBM's 6183/6184/6185 are *delve* widget IDs; a
ritual's would be different numbers, so probing those three constants inside a
ritual would report "nothing" whether or not the feature exists. `/mh tier` was
therefore extended to sweep every live widget set (named getters plus container
frames' `GetRegisteredWidgetSetID`) and run every `Get*VisualizationInfo` reader
over every widget, flagging any field named like a tier or holding a bare number.

**The control run matters more than the ritual run.** Measure a delve too. A delve
*must* show a tier through this probe; if it does not, the probe is broken and the
ritual's silence says nothing. This is the same trap as the party-target retraction
above — a null reading from a sample where the value was absent anyway.

**Worth salvaging regardless of how that lands.** The list carries `suggestedILvl`
per tier (215 / 231 / 244 / 257 / 264 / 274) and a `tierDescription` ("Tier 3 -
1 Challenges"). That is real, live, per-tier data available exactly when a player
is standing there deciding which tier to take — a better use of it than backfilling
a log, and useful whether or not the widget route pans out. See
`docs/PROPOSAL_TIER_ADVISOR.md`.

### MEASURED, with a control that passed (1 Aug 2026)

Two runs, highest tier selected in both, swept over set IDs 1–4200 and widget IDs
1–9000.

| | delve (The Darkway, 208/Delves) | ritual (Daggerspine Point, 12/Normal Scenario) |
|---|---|---|
| non-empty sets | 265 | 268 |
| widgets | 831 | 856 |
| `ScenarioHeaderDelves` widgets | **1** — id 6183, set 842 | **0** |
| `tierText` | **11** | — |
| header widget present | 6731 Timer, `headerText = "The Darkway"` | 6731 Timer, `headerText = "Ritual Roles"` |

**The control passed.** The earlier sweep found nothing in a delve that was showing
Tier 11 on screen; this one finds 6183 by itself, in set 842, without DBM's
constant. So the method demonstrably finds a tier when a tier is there.

**And the ritual has none.** Not a differently-named field, not a different widget
type, not somewhere else in the widget space — nothing. The flagged noise is
identical in both runs (`"Next Tier Reward:"`, `"Earthcrawl Mines (Tier 0)"`,
`"Tier lowered from 5 to 4"`): delve UI that is registered everywhere and says
nothing about the current run. The entire difference between a delve and a ritual
is the single widget 842/6183.

**So the original conclusion stands, now earned rather than assumed:** a ritual
run's tier is not recordable. Tier 0 in RitualLog means unknown and must keep
meaning that. The difference from the retracted version is that this was measured
inside the content, across the whole widget space, with a positive control.

**Remaining hole, stated honestly.** Sets above 4200 and widget IDs above 9000 were
not examined. 6183/set 842 sits low in both ranges, which is weak evidence that
scenario widgets live low, not proof. If a ritual tier ever turns up, that is where
it will be.

### The prize was on the other side: delve tiers are now readable

`Modules/DelveHistory.lua` records a tier for roughly 10 of 30 delve runs, because
it mines digits out of `difficultyName`. This measurement shows why that fails:
inside a delve, `GetInstanceInfo` returns difficultyID **208** with difficultyName
**"Delves"** — no digits at all. The number is only ever on the widget.

`C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183).tierText`
returned `"11"` for a Tier 11 run, in Rob's own client, twice. That is a reliable
replacement for the string-mining, and it is how DBM has always done it.

Note `tierTooltipSpellID = 1260975` alongside it, and `shownState = 1`.

### The Coiled Isle mapID: **2512** (measured 6 Aug 2026, PTR)

The number the zone scaffold has been blocked on for weeks. It is not datamined
anywhere; Rob read it off his own PTR client.

    /dump WorldMapFrame:GetMapID()      ->  [1]=2512

**How, without standing there.** The isle only opens after the first two campaign
chapters ("Hagar's Invitation" from Orweyna, Sanctum of Light, Silvermoon), and
Rob's is still at 0/1 — so flying there was not possible. `WorldMapFrame:GetMapID()`
returns the map you are LOOKING at rather than the one you stand on, which
sidesteps the requirement entirely. It is a Blizzard call, used 237 times across
the addons installed here.

Map hierarchy from the same screen: Azeroth → Eastern Kingdoms → Quel'Thalas →
**The Coiled Isle** → Vaults of Atal'Utek → Altar of Fangs. Zygor already carries
routing coordinates for the isle (`LibRover-1.0/data_borders.lua:351`), including
the tunnel between the isle and Vaults of Atal'Utek.

⚠️ **NOT wired into `MAP_TO_ZONE_KEY` (`Modules/Rares.lua:10`), on purpose.** That
table means "this zone is covered", and coverage is read as a promise: rares,
treasures, routes. We have none of that for the Coiled Isle. Adding the id today
would make `IsZoneCovered(2512)` answer true and hand a player an empty zone panel,
which is worse than the honest false it returns now. Wire it up in the same change
that brings the content, not before.

**Also captured while there**, new to us: the reputation **Zul'jarra's Forces**
(Zul'jarra is in our data only as an NPC in the Den of Nalorakk tips), and the Lair
quest *"Defeat Nymrissa Wavecaller in the Tidebound Grotto lair"*, rewarding 200
Zul'jarra's Forces plus a one-time warband reputation bonus. That confirms the
watcher entry of 30 July naming that lair boss.

### What other addons fixed for 12.1 on 6 Aug — and why none of it touches us

Rob asked, on the day a wave of addons updated, whether their patch notes named
anything that would hit MH. Two things did, and we are already clear of both. This
is written down so nobody spends an evening re-establishing it when 12.1 lands.

**The removed glow helper.** BliZzi_Interrupts 4.1.12: *"On 12.1 clients the
default glow spammed errors every frame: the game removed a helper the glow
libraries relied on, both now ship their own replacement."* Checked: MH contains
**zero** references to `ShowOverlayGlow`, `HideOverlayGlow`, `SpellAlert`,
`LibCustomGlow` or `ActionButton_*`. We ship no glow library and call no glow
helper, so there is nothing to break. CombatSafety's "glow" is four plain coloured
textures placed by anchors — deliberately, since the July secret-geometry fix.

**Secret errors from tooltips.** Three HandyNotes addons shipped the same class of
fix today: *"Don't try to show a comparison tooltip if GameTooltip has become
secret"*, *"Override reward item tooltip display to not use a MoneyFrame to avoid
many, many Blizzard secret issues"*, *"avoid a secret-values error when viewing the
tooltip on delve entrances"*. MH hooks item tooltips in `Modules/LootUpgrade.lua`,
and already avoids exactly this:

```lua
if tooltip ~= GameTooltip and tooltip ~= ItemRefTooltip then
    return -- keep shopping/compare tooltips clean
end
...
local ok = pcall(addLine, tooltip, link)
-- one bad tooltip must never break the game's tooltip; stay silent.
```

The comparison tooltips are skipped outright — which is where their errors come
from — and the rest is wrapped. It fails closed: no tip rather than an error.

**Three independent corroborations of this week's measurements**, worth keeping
because they came from other people's clients rather than ours:

- BliZzi: an offensive-CD check *"called an aura API that does not exist in the
  game and failed silently"*. Same class as the four wrong turns behind Ice Block —
  an absent thing and an unreadable thing look identical.
- BliZzi: shield detection *"no longer depends on reading the shield amount, which
  is unreadable for group members inside instances"*. Independent confirmation of
  what the dispel probes found about group members in instanced content.
- BliZzi's 12.1 path identifies buffs **by spell ID**, dormant until the client
  updates. That is the design `ns.Aura` was built around in July.

### Entrance tiers at a DELVE, and what the rewards list really holds (2 Aug 2026)

`C_DelvesUI.GetDelveEntranceTiers()` answers at a **delve** entrance too, which
nothing had established — every earlier reading came from the ritual obelisk.

| | delve entrance | ritual obelisk |
|---|---|---|
| `entranceType` | **1** | 2 |
| tiers | **11**, `suggestedILvl` 170 → 264 | 6, `suggestedILvl` 215 → 274 |

Note that a ritual asks for more gear than a delve at the same tier number: ritual
Tier 1 suggests 215, delve Tier 1 suggests 170.

**The rewards list holds item ids, not item levels.** Resolved live:

| tier | normal delve | bountiful delve |
|---|---|---|
| 1–3 | Heavy Trunk | Bountiful Coffer + Bountiful Heavy Trunk |
| 4–11 | Heavy Trunk | **+ Trovehunter's Bounty** |

Every one of them reports item level 1 through both `GetItemInfo` and
`GetDetailedItemLevelInfo` — they are containers (quality 2/3/4), not gear. So the
claim in `NEXT_SESSION.md` that the live recommended item level is not readable
**stands**, and `DELVE_LOOT_TABLE` (`Modules/Delves.lua:233`) stays hardcoded.

**But the argument I first reached it with was wrong, and Rob caught it.** The
first delve reading showed one item id on all eleven tiers, and I concluded that a
constant cannot encode a per-tier value. Rob pointed out that bountiful was an
uncontrolled variable. It was: a bountiful entrance offers three items instead of
one, and the list changes at Tier 4. The conclusion survives for a different
reason than the one I gave — containers have no item level — which is not the same
as having been right.

Two probe bugs surfaced on the way, both of the same family as the rest of this
document. `Ask()` returns only pcall's first value, so destructuring four returns
out of `GetItemInfo` yielded nil quality and nil item level that read exactly like
"this item has no level" (fixed, `e42b955`). And `ResolveRewardItems` dedupes by
item id while iterating `pairs()`, so the tier it records is the first one hash
order happened to visit — never read a threshold off that field; the per-tier
table above comes from `entranceTiers`, which stores every tier in full.

**Usable finding, live and unhardcoded:** in a bountiful delve, **Tier 4 is where
Trovehunter's Bounty starts**. That is exactly the kind of thing a player is trying
to work out while standing at the entrance, and it can be read rather than
maintained. See `docs/PROPOSAL_TIER_ADVISOR.md`.

⚠️ **Confound, raised by Rob: the two delves were different delves.** They had to
be — a delve either is bountiful this week or it is not, so the comparison cannot
be run on one entrance. That means "bountiful" and "which delve" moved together,
and only part of the result is safely attributed:

- **Safe.** Heavy Trunk becomes *Bountiful* Heavy Trunk and a *Bountiful* Coffer
  appears. The names track the state, not the location.
- **Not established.** That Tier 4 is where Trovehunter's Bounty starts may be a
  bountiful rule or may be that delve's rule. It was measured in one bountiful
  delve. A second bountiful delve settles it; until then do not ship the threshold
  as a general statement.

### The obelisk closes it: ritual rewards are containers too (2 Aug 2026)

Saved twice so the item cache was warm, and the two readings show why that
mattered:

```
1st save:  id=271785  ilvl=nil  q=nil  name=nil            <- cold
2nd save:  id=271785  ilvl=1    q=4    name=Ritual Spoils  <- warm
```

A single cold reading would have reported no name, no quality and no item level —
indistinguishable from an item that has none.

Warm, all six per-tier ids (271785, 271973, 271974, 271975, 271976, 271977) resolve
to **"Ritual Spoils"**: six distinct items sharing one name, quality 4, item level
1. Alongside them, constant across every tier, **Field Accolades** (quality 4) and
**Ritual Site Reports** (quality 2).

So both entrance types are now measured and both give containers. **There is no
live recommended item level anywhere in this API**, and the field in the Knowledge
Object stays `null` on measured grounds rather than on absence of evidence.

**Online, for completeness.** No API documentation for a ritual's selected tier was
found. Public guide sites describe ritual tiers as 1–5; Rob's own measurement shows
six, with `suggestedILvl` up to 274, so those pages are wrong or pre-12.0.7 — the
measurement wins. Several delve addons (Just Delve, Delve Companion) automate tier
selection, which means the *delve* side is solved in the wild; none of them is
installed here and none documents the ritual case.
