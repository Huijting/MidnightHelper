# The Coiled Isle — measured on the 12.1 PTR

**6 Aug 2026.** One lap with `/mh vignettes` recording, on Rob's PTR client, five
days before the zone exists on live. Map **2512**.

Every row is what the client reported: npcID from field 6 of the objectGUID, x/y
from `C_VignetteInfo.GetVignettePosition`, and the type from the atlas WoW itself
attached to the vignette. Nothing here is inferred from a name.

⚠️ **A lap is not a census.** A rare that was dead or unspawned while he flew past
is simply absent, and PTR content can change until the 11th. This is a list to
VERIFY after the patch, not the zone's contents. That is still a different job from
starting from an empty page.

**Rares — VignetteKill (6)**

    256631  70.0, 63.4  Big Mon
    257906  57.7, 68.5  Coin-Eye Skully
    264854  54.0, 72.2  Farthik the Plunderer
    265237  31.7, 56.8  Lockjaw the Snapper
    268049  50.0, 69.1  Siltmouth, the Unflappable
    261109  58.0, 40.1  Sss'alik, The Rotten Claw

**Elite rares — VignetteKillElite (2)**

    255087  47.0, 62.2  Malformed Leviathan
    255927  67.2, 77.5  Venom Lancer Ori'kassi

**Treasures — VignetteLoot (10)**

    642021  55.2, 38.0  A Tarnished Amani Glaive
    642316  58.1, 43.5  Cracked Skull
    642322  46.9, 29.6  Damaged Loa Trinket
    644681  53.1, 43.1  Intact Vase
    261867  68.0, 65.9  Lost Spirit
    619906  71.9, 66.7  Privateer's Cache
    644813  29.5, 67.2  Smoldering Incense
    644654  64.7, 36.6  Venomjade Necklace
    644791  49.5, 32.0  Waterlogged Basket
    642786  43.9, 26.5  Zul'jan's Stash

**Elite treasures — VignetteLootElite (2)**

    645208  65.4,  5.6  Sunken Diver's Chest
    648564  58.2, 45.7  Vul'zahn's Smuggled Treasure

**Lore objects — loreobject-32x32 (4)**

    669308  50.7, 68.4  Abandoned Tablet
    653579  57.3, 80.4  Amani Exile's Words
    669318  34.1, 36.5  Survival Journals
    654586  70.0, 66.0  Worn Tablet

**Vendors (2)** — 268228 at 58.8, 46.0 (Zul'jarra's Forces Renown Quartermaster)
and 270399 at 58.6, 45.9 (Zul'jarra's Forces Decor Specialist).

⚠️ **PTR data, not live data.** Content can change until the 11th, and a lap is not
a census — a rare that was dead or unspawned while Rob flew past simply is not
here. Treat this as a list to VERIFY after the patch, not as the zone's contents.
That is still a different job from starting empty, which is where this stood
yesterday.

Two things it tells us beyond the coordinates. The isle carries the full spread —
ordinary and elite rares, ordinary and elite treasures, lore objects — so it is a
normal outdoor zone rather than a raid antechamber. And the npcID ranges separate
cleanly: creatures sit around 255k-270k, objects around 619k-669k.

## Field notes from the hunt, 6 Aug

**Farthik the Plunderer (264854, 54.0/72.2) could not be attacked.** Rob found him
airborne and circling, hostile name plate, level 90 Humanoid — and out of reach.
Nothing is known about why: no installed addon mentions him, and a web search turns
up the zone but not him. So he is recorded as a vignette that exists and a kill that
did not happen, which is different from a rare that is simply on cooldown.

Worth knowing before assuming a spawn is missing: two guide sites describe "Curse
Surges" as rotating events that spawn a rare elite at one of five locations, so a
coordinate here may name a rare that is not always at that spot. That is their claim,
not a measurement — but it fits an airborne, unattackable NPC waiting on an event
better than a broken spawn does.

## Measured on the ground, 6 Aug evening

**The first verified rare row.** `/mh questdiff` finally ran clean and paired a kill
with the quest it flagged:

    Lockjaw the Snapper — npc 265237, questId 97227, map 2512, 31.7/56.8

Two independent measurements agree on the npcID: the vignette recorder read 265237
off the objectGUID while flying past, and the kill read 265237 off the target GUID.
The coordinates agree to a tenth. This row can go into `ns.RARE_ZONES` as it stands.

Machinery health at that moment: baseline 799 completed quests in 88000..112000,
68 fights handled, no sweep errors. So a missing row from here on means the kill did
not flag anything — not that the probe is broken.

**Gnarldor Isle, the zone's delve** — entrance at 64.5/77.7. Its achievement
"Gnarldor Isle Stories" wants each story variant: "Olds and Ends" (done), "Minchi's
Osseous Adventure", "Speaking Their Language". Three variants, 5 points.

**Delve tier 11 exists in Season 2** — no longer an inference off a dropdown. Rob
earned the achievement "Midnight Delves: Tier 11 (Season 2)" completing it. Live
currently tops out at 6, so the tier advisor's range is wrong for 12.1.

**Season 2 crests are called Mistcrest.** The delve paid "Hero Mistcrest" and the
"Cracked Keystone" quest offers 20 Hero Mistcrest + 20 Myth Mistcrest for completing
any dungeon on Mythic 2 or higher. Names only so far — the currency IDs still need
measuring before anything goes into the crest data.

Also seen: a "Delves: Season 2" reputation, Voidlight Marl (3316) dropping in bulk,
and two curio quests off a single delve — "A Gnawing Void of Curiosity" and
"Ancient Curiosity: Combat".

**Farthik the Plunderer does land.** Rob killed him after finding him unattackable
earlier, so the airborne phase is a phase and not a broken spawn. The kill happened
before the probe worked, so his questId is still open.

### First Season 2 curios seen, 6 Aug

Two dropped from Gnarldor Isle and appear in Valeera's Combat Curio slot:

  • **Corrosive Bilespear** — Rank 1/4. "Your companion has a chance during combat to
    impale the highest-health nearby targets with a Corrosive Bilespear, dealing
    tremendous Nature damage."
  • **Essence Trap** — seen in the same slot list, no tooltip read yet.

Names only. `ns.DELVE_CURIOS_BY_SEASON` is keyed by item, so nothing goes in until the
IDs are measured — and guessing them from Season 1 is exactly the failure the advisor
was built to avoid.

THE WAY TO GET THEM: `DelveCuriosAdvisor.lua` already walks the companion's trait tree
(`C_DelvesUI.GetTraitTreeForCompanion` -> `C_Traits.GetConfigIDByTreeID` -> node and
entry info) to read the role node. The curio slots are nodes in that same tree, so a
dump of every node and entry would hand over the Season 2 set in one command instead
of one screenshot at a time.

## Second run, fresh character — 6 Aug late

The flag is PER CHARACTER. `check 97227` read COMPLETED on the paladin that killed
Lockjaw and NOT completed on another character, so a rare already killed can be
measured again on someone else. That settled a question that was otherwise going to
cost a day of waiting for reset.

Rows measured so far:

    Lockjaw the Snapper  npc 265237  map 2512  31.7/56.9  quest 97227
    Nar'zira             npc 258920  map 2642  66.4/62.9  quests 98351 + 94860
    (unidentified)       npc ?       map 2512  44.1/50.4  quests 98348 + 96464

⚠️ **A kill can flag more than one quest, and we cannot yet say which is the rare's.**
Lockjaw produced exactly one; Nar'zira and the unidentified one produced two each.
Until that is understood, none of the two-quest rows can go into `ns.RARE_ZONES` —
picking one of the pair would be a guess wearing a measurement's clothes. The way to
settle it: kill the same rare on a third character and see which id turns true again.

**Map 2642 is a second map on the isle.** Nar'zira sits there, not on 2512, so the
zone has at least one interior with its own map ID. Any route or list keyed only to
2512 will miss whatever lives there.

**Beware the pairing.** Two rows in the same capture read "Tiny Vermin" on map 2437 —
a critter, credited with two quests that merely finished during that fight. The module
records what turned true where, not what the enemy was.

### Treasures of the Coiled Isle — 10 points, rewards the mount Auriferous Venomfang

Twenty-two hidden treasures. Read off the achievement panel, not guessed:

    Amani Privateer's Cache      Fangbound Sack
    Sunken Diver's Chest         Grave of Someone Forgotten
    Profane Ritual Spoils        Brine-Crusted Chest
    Possessed Vase               Malfunctioning Staff
    Tarnished Amani Glaive       Jaktu's Cursed Blade
    Lost Spirit                  Cracked Skull
    Damaged Loa Trinket          Venomjade Necklace
    Ornate Bottle                Stinking Vessel
    Waterlogged Basket           Smoldering Incense
    Crumbling Urn                Forgotten Mask
    Vul'zahn's Smuggled Treasure Zul'jan's Stash

Names only — no coordinates, and a treasure list without coordinates cannot drive a
route. `/mh capture <name>` on each one as they are found is the way to fill it in.

## A pattern in the quest ids — hypothesis, not a finding

Three kills on the fresh character each flagged an id from one tight run:

    44.1/50.4 (unidentified)   98348  + 96464
    Nar'zira                   98351  + 94860
    Sss'alik, The Rotten Claw  98354  + 95447 + 95563

98348, 98351, 98354 — a step of exactly 3, one per rare. If that holds, the 983xx id
is the rare's own kill credit and the others are whatever else finished during the
fight. Lockjaw sits outside it with 97227, but Lockjaw was measured on a DIFFERENT
character with a different history, so that is not yet a counter-example.

⚠️ Do not write any of this into `ns.RARE_ZONES` on the strength of the pattern. Three
points on a line is how a guess starts looking like a measurement.

THE TEST THAT SETTLES IT: `/mh questdiff check 98348` (and 98351, 98354) on the
paladin. That character killed Big Mon, Farthik and Siltmouth but never touched
Sss'alik or Nar'zira. If the 983xx ids are per-rare kill credit, the ones matching his
kills read COMPLETED and the others do not. If they all read the same, the pattern is
coincidence and the whole idea dies there.

### Treasure coordinates, measured

    Stinking Vessel          2512  53.05/43.07
    Tarnished Amani Glaive   2512  55.19/37.94
    Cracked Skull            2512  58.14/43.64

Three of the twenty-two. Captured with `/mh capture <name>` while standing on them.

## Altar of Fangs — first machine-verified data, 6 Aug

A follower run (difficulty 205) confirmed what the roster held, from ENCOUNTER_START
itself rather than from DBM's files:

    3456  Rav'i               journalInstanceID 1322   map 2588
    3457  The Writhing Coil   journalInstanceID 1322   map 2589

Each boss reports its own uiMapID, so the instance is split across maps. Our stored
name was "Ravi"; the game writes **Rav'i**. Zul'jan (3458) is still only from DBM —
the run stopped before him.

**A blocking bug stopped the run**, and it is worth reporting on the PTR: four totems
must be destroyed, which should extinguish four green beams feeding a serpent. All
four totems went down and one beam kept shining, leaving the way shut.

That mechanic is also content we did not have: an approach gate of four totems and
four beams. It belongs in the beginner steps when those get written, whether or not
the bug is fixed.

## The delve bonus roll, measured on LIVE — 7 Aug

Rob has met this twice: a popup with a die at the end of a delve, on live 12.0.7, which
this addon knew nothing about. `/mh bonusroll` caught it. It is Blizzard's own
`BonusRollFrame`, and the frame carries:

    spellID     259072
    state       prompt
    remaining   49.2 seconds        <- it is TIMED
    instance    The Darkway (scenario), map 2525, difficulty 208

So a delve on live hands out a bonus roll with a fifty-second decision window. The
screenshot shows "Cost: 1" against a currency icon with 23 held.

⚠️ **This is not the mechanic we model.** `VaultAdvisor.lua` knows exactly one bonus
roll: the Season 2 "Nebulous Voidcore", a BUTTON IN THE GREAT VAULT gated behind
`IsSeason2Live` and three filled slots. A timed popup after a delve on live is something
else, and we say nothing about it anywhere.

Still unknown, and the capture was improved for the next one: WHICH currency it costs
(the frame reported none — `C_CurrencyInfo` is now read), and the words on the popup
(they live in child frames, so the first version read an empty top level).

Worth knowing before 11 Aug: the watchers logged that Season 2 rebalances Ritual Sites
to delve-tier rewards and removes their Voidcore bonus roll. If delves have their own
roll on live already, our Season 2 model may be describing only half the picture.
