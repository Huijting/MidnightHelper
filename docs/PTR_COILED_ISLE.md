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
