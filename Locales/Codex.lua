--[[
	Midnight Helper — Midnight Codex (handbook) strings.

	SEVEN packs are merged here, in this order: enUS, itIT, nlNL, deDE, frFR, esES,
	ptBR. The header used to say "enUS + nlNL; the rest falls back" — that was true
	once and stopped being true without anyone updating it. Anything missing from a
	pack does still fall back to enUS via ns:L(), so a gap shows English, never a
	raw key.

	Article structure and ids live in Modules/MidnightCodexData.lua.
	Read docs/CODEX_ARCHITECTURE.md before writing anything that generates these.
]]

local _, ns = ...

local function merge(target, patch)
	if not target or not patch then
		return
	end
	for k, v in pairs(patch) do
		target[k] = v
	end
end

merge(ns._mhLocales and ns._mhLocales.enUS, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Your Midnight handbook — what each system is, what currency does what, and where to click in this addon. Hover currency icons for Blizzard tooltips.",
	CODEX_OPEN_TAB_FMT = "Open: %s",
	CODEX_NAV_DELVES_VAULT = "Delves & Vault tab (Great Vault block)",
	CODEX_NAV_DELVES_MIDNIGHT = "Delves & Vault tab (delve list)",
	CODEX_NAV_BASICS_DAWN = "Basics tab (Crests)",
	CODEX_NAV_BASICS_PROF = "Basics tab (Professions guide)",
	CODEX_BALANCE_FMT = "You have: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Balance updates when you log in on this character.",
	CODEX_SEARCH_OPENED = "Opened Midnight Codex.",
	CODEX_BETA_DISABLED = "Midnight Codex is disabled in Settings (beta tabs).",

	CODEX_CAT_START = "Start Here",
	CODEX_CAT_WEEKLY = "Weekly loop",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Follow the route",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Start Here — your Midnight week",
	CODEX_START_BODY = "|cffffcc00Think in layers:|r one weekly reset, several reward tracks. You do not need every system every day — pick a goal.|n|n|cffffff781) Account & reset|r|n• Check |cffffffffHome -> This Week|r for vault ready, world boss, keys, and chores.|n• |cffffffffAccount snapshot|r shows all alts (vault, Delver's Call, profession weeklies).|n|n|cffffff782) Combat content|r|n• |cffffffffDelves|r — main gearing track (keys, tiers, Great Vault slots). Use |cffffffffDelve Coach|r for tips per delve.|n• |cffffffffMythic+|r and |cffffffffRaid|r fill other Great Vault slots (see Dungeons & Raid categories).|n|n|cffffff783) Open world (12.0.5)|r|n• |cffffffffVoid & Rituals|r tab — Field Accolades, Ritual Sites, Void Assaults (same renown track).|n• |cffffffffRares|r tab — weekly rare loot and routes.|n|n|cffffff784) Crafting|r|n• |cffffffffProfessions|r tab for KP / weekly mats; |cffffffffBasics|r for crests.|n|n|cffffcc00Tip:|r open the |cffffffffCurrencies|r category here when you forget what a token is for. Scroll the boss preview in Delve Coach to zoom.",
	CODEX_WARBAND_TITLE = "Warband & the Warband Bank",
	CODEX_WARBAND_BODY = "|cffffcc00Your Warband|r is every character on your account, treated as one team. Lots of things are now |cffffffffWarbound|r — shared account-wide — so you mail far less between alts.|n|n|cffffff78Warbound items & currencies|r|n• Most Midnight currencies are account-wide.|n• Gear is often |cffffffffWarbound until equipped|r — send it to an alt, but once equipped it sticks to that character.|n|n|cffffff78The Warband Bank|r — a shared bank all your characters use.|n• Open it at |cffffffffany banker|r (or Jeeves) — it's a tab on your normal bank, next to your character bank.|n• Store any |cffffffffnon-soulbound|r item, and deposit or withdraw |cffffffffgold|r across characters (even cross-faction).|n• Craft straight from it — it counts as a reagent source.|n|n|cffffff78Tabs & cost|r — 5 tabs, 98 slots each (490 total). You start with none; buy them with gold:|n• Tab 1: |cffffffff1,000g|r|n• Tab 2: |cffffffff25,000g|r|n• Tab 3: |cffffffff100,000g|r|n• Tab 4: |cffffffff500,000g|r|n• Tab 5: |cffffffff2,500,000g|r  (all five = 3,126,000g)|n|n|cffffcc00Tip:|r 2-3 tabs is plenty for most players. Don't confuse it with your |cffffffffcharacter bank|r (also tabbed since patch 11.2, far cheaper) — that one is per-character; the Warband Bank is shared.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• Most weekly progress resets on your region's maintenance day (EU Wednesday morning, US Tuesday morning).|n• Great Vault choices, world boss loot, many weekly caps, and Delver's Call deliveries reset.|n• |cffffffffHome -> This Week|r shows time until reset when the API provides it.|n• Plan alts: snapshot tab compares who still owes vault, boss, or Delver's Call.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Three tracks: |cffffffffWorld|r (delves + world content), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Fill activities during the week; after reset you pick one reward per unlocked slot at the vault NPC or via SHIFT-J.|n• |cffffffffVault Advisor|r (on Blizzard's vault UI) ranks options vs your equipped gear.|n• This addon shows all three tracks in the |cffffffffDelves & Vault|r tab — expand |cffffffffWeekly Great Vault (World)|r (not a separate tab yet).|n• Summary also on |cffffffffHome -> This Week|r and |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• One rotating world boss per week (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Warband loot: once any character kills it, alts show completed.|n• Tracked at the top of |cffffffffDelves & Vault|r with TomTom route.|n• Also linked from SMC City Guide when in Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• New mid-expansion power system — a minimap book of |cffffffffrunes|r you swap freely out of combat (no slot cost).|n• Power comes from the weekly |cffffffff'Seeking Knowledge'|r chain (5 weeks): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Each week rewards a |cffffffffMote of Omnial Inquiry|r to choose/empower a rune.|n• Finish all 5 for the meta achievement and the Sunstrider Omnium Simulacrum decor.|n• Missed a week? Do the missed quests back-to-back to catch up — no waiting for resets.|n• (Datamined — exact rune effects/IDs confirmed at launch.)",
	CODEX_S2_TITLE = "A new season — what it means",
	CODEX_S2_BODY = "• Your character, mounts and collections all stay — nothing is lost.|n• Gear looks \"lower\" because the new season starts on a higher scale. That is normal and expected — everyone resets together.|n• Your Mythic+ rating starts fresh too — again, for everyone.|n• It arrives in two steps: first the patch (zone, campaign, dungeon), then about a week later the season (raid, Mythic+, PvP).|n• What to do now: follow the Start Here path, no rush.",
	CODEX_SEASONEND_TITLE = "When a season ends",
	CODEX_SEASONEND_BODY = "• |cffffffffYour gear does not reset.|r Everything you are wearing carries over at the item level it already has. It stops being top-end, but it is a real head start on day one of the next season. The change where everyone's numbers come down at once is a squish, and that belongs to an expansion's pre-patch — not to a season rollover.|n• |cffffffffThe numbers move, not your progress.|r Each season raises item levels, so a piece that is maxed on the top track now sits a track or two lower in the new numbers. That is normal and it happens to everyone.|n• |cffffffffKeep opening the Great Vault to the last week.|r Every weekly is free gear that raises where you start next season.|n• |cffffffffSeasonal currencies usually do not survive a rollover intact|r — they tend to convert or stop being useful. Spending them beats hoarding them. The exact behaviour differs per currency and can change late, so check the currency tab in game rather than trusting a guide.|n• |cffffffffThe real deadline is the season-only things:|r mounts, titles and achievements tied to this season, and progress tracks that reset. Those are the ones worth finishing while you still can.|n• |cffffffffProgress tracks reset, but their rewards are usually not gone|r — they often move to a vendor afterwards without the rank requirement, at a much higher price. Finishing now is cheaper than buying later.|n• |cffffffffPick one lane.|r The last weeks are short. Finishing one track beats half-finishing three.",
	CODEX_PREY_TITLE = "Prey hunts",
	CODEX_PREY_BODY = "• |cffffffffA Prey hunt is a tracked kill, not a dungeon.|r You pick up the hunt from Magister Astalor Bloodsworn in Murder Row, Silvermoon, follow it, and finish with a fight against one named target. No group finder, no lockout to plan around.|n• |cffffffffIt counts for the Great Vault.|r Prey feeds the same world row as delves and ritual sites, so it is a real way to fill that reward slot rather than a side attraction.|n• |cffffffffThere are three difficulty modes.|r Start on the lowest. A harder mode is the same hunt with more to handle, not different content you are missing out on.|n• |cffffffffWar Mode hunts are counted separately.|r If you do not play with War Mode on, you are not missing anything the rest of the system needs.|n• |cffffffffThe whole target list is a long-term goal, not a weekly chore.|r Working through it ends in a title. Doing one hunt when you feel like it is a perfectly good way to play it.|n• |cffffffffTo see where you stand|r, type |cffffffff/mh prey|r, or open the Adventure Guide with Shift-J. Both read your own progress from the game rather than from a list we wrote down.",
	CODEX_S2GLOSS_TITLE = "Season 2 — new terms",
	CODEX_S2GLOSS_BODY = "• |cffffffffCrest|r — a currency to upgrade gear. Each track (Adventurer to Myth) has its own crest; you earn them from delves, dungeons and raids.|n• |cffffffffUpgrade track|r — the ladder a piece of gear climbs (Adventurer, Veteran, Champion, Hero, Myth). Higher track = higher ceiling.|n• |cffffffffTier set|r — matching armor pieces. Wear 2 or 4 and you unlock a bonus for your spec.|n• |cffffffffCatalyst|r — turns a normal piece into a tier piece; in Season 2 it keeps the item stats.|n• |cffffffffBountiful Delve|r — a delve with a guaranteed extra reward; needs a Coffer Key.|n• |cffffffffNemesis Delve|r — a special seasonal delve with its own boss and rewards.|n• |cffffffffLair|r — a world boss you enter at a spot and pick a difficulty for your group, like a mini-raid.|n• |cffffffffNew-season rescale (squish)|r — new gear starts at higher numbers, so old gear looks lower. Normal every season; everyone resets together.",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Returning Timewalking event — this time a |cffffffffDragonflight|r dungeon pool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Weekly: run |cffffffff5 Timewalking dungeons|r for a gear cache; each run stacks |cffffffffKnowledge of Timeways|r (XP buff).|n• Earn |cffffffffMastery of Timeways|r in 4 of 6 weeks for 'Master of the Turbulent Timeways' and the |cffffffffSpawn of Vyranoth|r mount.|n• Spend Timewarped Badges at the event vendor.|n• Runs ~June 30 – Aug 11. (Datamined — confirm at launch.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Weekly delve objectives that grant a large XP burst when turned in.|n• You can |cffffffffbank|r completed calls (done objectives, not yet turned in) for a later character level.|n• |cffffffffAccount snapshot|r rolls up banked and pending calls across alts.|n• Hover the Delver's Call line in snapshot for per-character detail.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Read-only overview of characters you've logged in on with Midnight Helper.|n• Sort/filter by vault ready, keys, Shards of Dundun cap, stale since reset, etc.|n• Use it to answer: \"Which alt still needs vault / boss / Delver's Call?\"|n• Does not replace logging onto an alt for gear or quest checks.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Opens Midnight delves (like previous expansion keys).|n• Earn from world content, weeklies, and vendors; no hard weekly cap on holding keys.|n• Shown on |cffffffffDelves & Vault|r with your current count.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Combine into Restored Coffer Keys (100 shards -> 1 key at the standard rate).|n• Weekly earn cap applies to shards — track \"Weekly: X / Y\" on the Delves tab.|n• Cap fills faster if you run more delves or complete shard sources.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Vendor currency for delve-related goods (curios, upgrades, convenience items).|n• Earn primarily from running delves and delve rewards.|n• Spend before hoarding blindly — check the delve vendor when you have a goal piece.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Used for specific Midnight gear upgrades / vendor purchases (check current patch notes for exact vendors).|n• Earn from delves, world content, and weekly sources.|n• Account snapshot can show per-character totals.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Shared currency for the |cffffffffVoid & Rituals|r systems (Ritual Sites + Void Assaults).|n• Weekly earn cap — after cap you still play for other rewards but stop gaining accolades until reset.|n• Spends on renown rewards at the Bazaar hub (Eversong / Zul'Aman).|n• Live count on |cffffffffVoid & Rituals|r tab.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Raid-tier crafting currency (Great Vault raid slots, catalyst-adjacent progression).|n• Live crest counts are on |cffffffffBasics -> Crests|r (not in this list).|n• Not the same as delve keys — see that guide for spend targets and weekly caps.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• Gear doesn't just have an item level — it sits on a |cfffffffftrack|r. Low to high: |cffffffffAdventurer|r (green), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• A tooltip reading |cffffffffHero 3/6|r means: the Hero track, rank 3 of 6. Each rank you buy adds item level.|n• The track sets your ceiling — the tooltip shows the item level range it can reach. To climb past it you need a drop from a higher track.|n• Each track has its own crest colour. Harder content drops gear on a higher track — that's how you climb.|n• Outgrown a track? Trade lower crests up at |cffffffffVaskarn|r. Upgrade at |cffffffffCuzoth|r in Silvermoon — a rank costs that track's crests plus a little gold.|n• Each track has an «…of the Dawn» achievement: earn it and your whole |cffffffffWarband|r gets a 50% upgrade discount on that track.|n• Live counts and waypoints: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — overview",
	CODEX_DELVES_INTRO_BODY = "• Solo or small-group scenarios across Eversong, Harandar, Voidstorm, etc.|n• |cffffffffTier 1–11+|r — higher tier = harder enemies and better item level in the vault.|n• Costs a |cffffffffRestored Coffer Key|r per run (see Currencies).|n• |cffffffffBountiful|r delves (rotating) give extra loot — use \"Find Nearest Bountiful Delve\" on the Delves tab.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Floating tips panel: route, trash, and boss mechanics per delve.|n• Opens automatically in a delve (optional) or via |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• English or Dutch text follows `/mh lang`.|n• Boss spotlight: scroll on the model to zoom (saved per boss).|n• Blue spell names link to real spell tooltips when IDs are known.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• Curios modify your next delve run (extra loot, easier bosses, etc.).|n• Valeera offers advice at repair/gossip NPCs — popup on Delves tab when relevant.|n• Track consumables and minimap buttons via delve items popup (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Capstone Nemesis delve in Voidstorm — separate instance portal, not a rotating world delve.|n• Unlocks on high delve tiers with limited lives (see in-game requirements).|n• Boss Nullaeus — heavy interrupt/DPS check; see Delve Coach for mechanics.|n• Weekly bounty can pull a weakened Nullaeus into a normal delve (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• History of recent delve runs (tiers, times, party).|n• Useful to remember which variant you finished or which boss was up.|n• Nearest-delve routing can send you to the closest entrance from your position.",

	CODEX_MPLUS_TITLE = "Mythic+ & dungeon vault",
	CODEX_MPLUS_BODY = "• M+ dungeons fill the |cffffffffDungeons|r Great Vault row (separate from delve/world rows).|n• Higher key level = higher item level in vault slot if you time the key.|n• Vault Advisor uses M+ stat weights when you claim dungeon vault loot.|n• Midnight Helper does not replace a route addon — use MDT / notes for affix weeks.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• Raid bosses progress raid vault slots (difficulty affects item level).|n• Normal / Heroic / Mythic each contribute — check vault UI for which bosses you've killed this week.|n• Crests often gate upgrade paths on raid gear.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Side panel on Blizzard's weekly reward UI when you claim Great Vault loot (SHIFT-J) — not inside Midnight Helper tabs.|n• Ranks vault pieces vs equipped gear using guide stat priorities (and optional Pawn).|n• Toggle in minimap quick settings / Esc -> AddOns -> Midnight Helper.|n• Auto vs Raid vs M+ profile for stat weights.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — one system",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 pairs |cffffffffRitual Sites|r (Eversong) and |cffffffffVoid Assaults|r (Zul'Aman) under one currency and renown.|n• Same |cffffffffField Accolades|r and Bazaar hub — do not grind them as unrelated farms.|n• Open the combined tab for live active site, weekly caps, and TomTom buttons.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Weekly rotating ritual in Eversong Woods — complete stages for accolades and loot.|n• Only one site is \"active\" at a time; addon highlights which.|n• SMC City Guide pin can jump you to the Ritual tab with context.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Zul'Aman assault waves — defend objectives, earn accolades.|n• Shares weekly cap with ritual progress on the same currency.|n• Check assault timer / active zone on Void & Rituals tab.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Weekly rare mobs with account/character loot (check each rare's rules in-game).|n• |cffffffffRares|r tab: track kills, build nearest route, TomTom arrow stays on closest pin.|n• Live alert when a tracked rare is nearby (~500 yds) — toggle in settings.",

	CODEX_PROF_TITLE = "Professions — weekly loop",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance, and Shards of Dundun are separate tracks.|n• |cffffffffProfessions|r tab shows unspent KP and weekly currencies per profession.|n• Crafting orders and treasures are not fully automated here — use Basics guide for KP spending.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• |cffffffffBasics -> Professions|r sub-tab: step-by-step KP plan and combo suggestions.|n• Crests guide covers raid crafting currency (different from delve keys).|n• Re-read after patches — currency IDs and caps can change.",
	CODEX_CRAFTGEAR_TITLE = "Getting gear crafted",
	CODEX_CRAFTGEAR_BODY = "• You don't need the profession yourself — another player can craft it for you through a |cffffffffCrafting Order|r.|n• Crafted gear is the |cffffffffreliable|r route: no drop luck involved. It is also the only gear that can carry an |cffffffffEmbellishment|r (a special effect — you can wear two at most).|n• |cffffffffWhat you gather first:|r a |cffffffffSpark|r (2 for armour or a one-hand weapon, 4 for a two-hander) from the weekly quest in Silvermoon; |cffffffffcrests|r if you want the higher version; a |cffffffffMissive|r to pick your secondary stats (Auction House); and the materials.|n• |cffffffffThe crest step matters:|r without crests you get the base version. Adding crests of a higher tier raises the item level it can reach — the top-tier crests give the strongest craft. Your own crest tab shows what you have.|n• |cffffffffThen order it:|r talk to the Crafting Orders NPC in Silvermoon's Bazaar, pick the item, attach your spark, crests and missive, and place it as a public order or send it to a crafter you know. Add a tip so someone picks it up.|n• |cffffffffSparks and crests cannot be supplied by the crafter|r — you must own them. This is where most first orders fail.|n• The crafter's skill decides the quality, so a crafter you know beats a random public order.|n• Worth it when a slot refuses to drop for you, or for an Embellishment. If good drops come easily in that slot, save the crests.",
	CODEX_PROFRESET_TITLE = "Resetting a profession’s specializations (12.1)",
	CODEX_PROFRESET_BODY = "• Patch 12.1 lets you undo your Midnight specialization choices — once per profession.|n• |cffffffffWho:|r Theremis, in Silvermoon’s Bazaar beside the crafting orders. He offers one line per profession, so you can reset Blacksmithing and leave Enchanting exactly as it is.|n• |cffffffffWhat comes back:|r every Knowledge Point you spent in that profession’s Midnight trees, yours to re-allocate as you see fit.|n• |cffffffffWhat it costs:|r the game’s warning reads “You will lose all associated recipes”.|n• |cffffffffAssociated, not all.|r What goes is what those specialization choices unlocked. Recipes you learned from a trainer, a drop or a quest sit outside the trees and stay. Seen on a reset Enchanting: the recipe list was untouched and the spent Knowledge was back on the counter.|n• |cffffffffIt is once.|r The confirmation says ONCE in capitals, and that is per profession — there is no second attempt if the new path disappoints you.|n• So decide where the points are going |cffffffffbefore|r you confirm. The Professions page names the tree to fill and the exact node to spend on.|n• Does re-spending exactly as before return the recipes it took? The game never says so. Plan as though it will not.",
	CODEX_ATALUTEK_TITLE = "The Vaults of Atal'Utek — what is in there, and where",
	CODEX_ATALUTEK_BODY = "• |cffffffffWhat it is:|r a 12.1 area on the Coiled Isle with its own map, and a second map underneath it, the Underbelly. It is open now — there is no season gate on it.|n• |cffffffffHow you get in:|r a chain of three quests — |cffffffffInto the Vaults of Atal'Utek|r, then |cffffffffVaults of Atal'Utek: One Coin Too Many|r, then |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Everything below sits behind them, so do those first.|n• |cffffffffCorrosive Coin|r is the zone's currency. The game's own words: “Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.” Your balance is the number above this article.|n• |cffffffffCorrosive Soul is not that.|r It is not a currency at all but an |cffffffffitem|r in your bags, and it is what the Corrosive Codex asks you to offer. Guides swap the two names constantly; the game never does. If something tells you to spend Corrosive Coins at the Codex, that is the mix-up.|n• |cffffffffWhere the coins go — two places, both at Er’inye|r at {WAY:2509:51.10:62.76:Er'inye}. Talking to him buys |cffffffffCorrode Spirit|r, which is what feeds the Altar tree; beside him the |cffffffffSkull of Er’inye|r is a merchant with three pages of mounts, pets, ensembles and recipes, priced from 500 to 25,000 coin. |cffffffffThe corrode price climbs every time you buy it|r — seen at 1,500 and then 2,000 on one visit — so read the window rather than saving up for a number.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: the four keys",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffThe Altar of Corrosion|r is the node tree the last quest of the chain opens. Most of it unlocks as you spend, but |cfffffffffour nodes sit behind a key you have to go and find|r — and all four work the same way: an item drops, you use it on one object somewhere in the Vaults, that gives a quest item, and Er’inye takes it from there.|n|cffffffffCorroded Key|r → the Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, or Swift Steps) · |cffffffffSpirit Loupe|r → the Feather of Tok’jara at {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, or Spectral Shipping) · |cffffffffExcising Knife|r → the Eye of Szarith, in a venom pool in the Underbelly → |cffffffffBroodmaster|r (+100% damage to eggs, or −75% damage from egg bursts) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary in the Profaned Mausoleum → |cffffffffSpiritual Protection|r (ghostly allies at Curse Surges, or getting straight back up when you die outside the Vaults).|n|cffffffffShowing a key to Er’inye does not unlock anything.|r He is blind, and he tells you what he feels — that is a hint about where the thing belongs. |cffffffffWhere the keys drop is not settled|r: three careful reads of the same database gave three different answers, so we are not going to name one. Run Strikes and Incursions and they turn up.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead & the rares",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff“The Honored Dead” — twelve memorials|r on the Vaults map, one achievement, and the clearest thing here to just go and do. In one walking order, from the top of the map downwards:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (under the bridge) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffThe Underbelly|r is the map below, entered at {WAY:2509:47.30:11.20:The Underbelly} on the Vaults map. One rare lives down there, |cffffffffSzarith the Fanged|r at {WAY:2613:38.40:17.69:Szarith the Fanged}, and the Underbelly carries its own achievement, |cffffffffSoft Underbelly|r.|n• |cffffffffThree rare elites on the main map|r — Congealed Malice, Khu'tulak and Susarikk — make up a third, |cffffffffOppose the Foes|r. |cffffffffThey have no fixed spot, and that is the answer rather than a gap|r: one of the three wakes up the moment a |cffffffffTemple Incursion|r is completed, and you have about ten minutes to kill it. So you do not go hunting for them — you finish Incursions, and one comes to you.",
})

merge(ns._mhLocales and ns._mhLocales.itIT, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Il tuo manuale per Midnight — cos'è ogni sistema, a cosa serve ogni currency e dove cliccare in questo addon. Passa il cursore sulle icone delle currency per i tooltip di Blizzard.",
	CODEX_OPEN_TAB_FMT = "Apri: %s",
	CODEX_NAV_DELVES_VAULT = "Scheda Delves & Vault (blocco Great Vault)",
	CODEX_NAV_DELVES_MIDNIGHT = "Scheda Delves & Vault (elenco delve)",
	CODEX_NAV_BASICS_DAWN = "Scheda Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Scheda Basics (guida Professions)",
	CODEX_BALANCE_FMT = "Hai: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Il saldo si aggiorna quando accedi con questo personaggio.",
	CODEX_SEARCH_OPENED = "Midnight Codex aperto.",
	CODEX_BETA_DISABLED = "Midnight Codex è disattivato nelle Impostazioni (schede beta).",

	CODEX_CAT_START = "Inizia qui",
	CODEX_CAT_WEEKLY = "Ciclo settimanale",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Segui il percorso",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Inizia qui — la tua settimana Midnight",
	CODEX_START_BODY = "|cffffcc00Ragiona a livelli:|r un weekly reset, diverse tracce di ricompensa. Non ti serve ogni sistema ogni giorno — scegli un obiettivo.|n|n|cffffff781) Account & reset|r|n• Controlla |cffffffffHome -> This Week|r per vault pronta, world boss, key e faccende.|n• |cffffffffAccount snapshot|r mostra tutti gli alt (vault, Delver's Call, weekly delle profession).|n|n|cffffff782) Contenuti di combattimento|r|n• |cffffffffDelves|r — traccia principale di gearing (key, tier, slot della Great Vault). Usa |cffffffffDelve Coach|r per i consigli su ogni delve.|n• |cffffffffMythic+|r e |cffffffffRaid|r riempiono gli altri slot della Great Vault (vedi le categorie Dungeons & Raid).|n|n|cffffff783) Mondo aperto (12.0.5)|r|n• Scheda |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (stessa traccia di renown).|n• Scheda |cffffffffRares|r — loot rare settimanale e percorsi.|n|n|cffffff784) Crafting|r|n• Scheda |cffffffffProfessions|r per KP / mat settimanali; |cffffffffBasics|r per i crest.|n|n|cffffcc00Consiglio:|r apri qui la categoria |cffffffffCurrencies|r quando non ricordi a cosa serve un token. Scorri l'anteprima del boss in Delve Coach per zoomare.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• La maggior parte dei progressi settimanali si resetta nel giorno di manutenzione della tua regione (EU mercoledì mattina, US martedì mattina).|n• Si resettano le scelte della Great Vault, il loot del world boss, molti cap settimanali e le consegne della Delver's Call.|n• |cffffffffHome -> This Week|r mostra il tempo al reset quando l'API lo fornisce.|n• Pianifica gli alt: la scheda snapshot confronta chi deve ancora vault, boss o Delver's Call.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Tre tracce: |cffffffffWorld|r (delve + contenuti del mondo), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Riempi le attività durante la settimana; dopo il reset scegli una ricompensa per ogni slot sbloccato dall'NPC della vault o con SHIFT-J.|n• |cffffffffVault Advisor|r (sull'UI vault di Blizzard) classifica le opzioni rispetto al tuo equip.|n• Questo addon mostra tutte e tre le tracce nella scheda |cffffffffDelves & Vault|r — espandi |cffffffffWeekly Great Vault (World)|r (non è ancora una scheda separata).|n• Riepilogo anche in |cffffffffHome -> This Week|r e |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Un world boss a rotazione per settimana (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Loot Warband: una volta che un personaggio lo uccide, gli alt risultano completati.|n• Tracciato in cima a |cffffffffDelves & Vault|r con percorso TomTom.|n• Collegato anche dalla SMC City Guide quando sei a Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nuovo sistema di potere di metà espansione — un libro sulla minimappa di |cffffffffrune|r che scambi liberamente fuori dal combattimento (nessun costo di slot).|n• Il potere arriva dalla catena settimanale |cffffffff'Seeking Knowledge'|r (5 settimane): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Ogni settimana ricompensa un |cffffffffMote of Omnial Inquiry|r per scegliere/potenziare una runa.|n• Completa tutte e 5 per il meta achievement e l'arredo Sunstrider Omnium Simulacrum.|n• Hai saltato una settimana? Fai le quest mancanti una dopo l'altra per recuperare — senza aspettare i reset.|n• (Da datamining — effetti/ID esatti delle rune confermati al lancio.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Evento Timewalking di ritorno — questa volta un pool di dungeon |cffffffffDragonflight|r: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Settimanale: completa |cffffffff5 dungeon Timewalking|r per un cache di gear; ogni run accumula |cffffffffKnowledge of Timeways|r (buff XP).|n• Ottieni |cffffffffMastery of Timeways|r in 4 settimane su 6 per 'Master of the Turbulent Timeways' e la cavalcatura |cffffffffSpawn of Vyranoth|r.|n• Spendi i Timewarped Badges dal venditore dell'evento.|n• Attivo dal ~30 giugno all'11 ago. (Da datamining — confermare al lancio.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Obiettivi settimanali delle delve che concedono un grosso burst di XP alla consegna.|n• Puoi |cffffffffmettere in banca|r le call completate (obiettivi fatti, non ancora consegnati) per un livello successivo del personaggio.|n• |cffffffffAccount snapshot|r riepiloga le call in banca e in sospeso tra gli alt.|n• Passa il cursore sulla riga Delver's Call nello snapshot per il dettaglio per personaggio.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Panoramica in sola lettura dei personaggi con cui hai effettuato l'accesso usando Midnight Helper.|n• Ordina/filtra per vault pronta, key, cap di Shards of Dundun, inattivi dal reset, ecc.|n• Usalo per rispondere: \"Quale alt deve ancora vault / boss / Delver's Call?\"|n• Non sostituisce l'accesso a un alt per controllare gear o quest.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Apre le delve Midnight (come le key delle espansioni precedenti).|n• Si ottiene da contenuti del mondo, weekly e venditori; nessun cap settimanale rigido sul numero di key che puoi tenere.|n• Mostrata in |cffffffffDelves & Vault|r con il tuo conteggio attuale.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Si combinano in Restored Coffer Keys (100 shard -> 1 key al tasso standard).|n• C'è un cap settimanale di guadagno sugli shard — controlla \"Weekly: X / Y\" nella scheda Delves.|n• Il cap si riempie più in fretta se fai più delve o completi le fonti di shard.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Currency da venditore per beni legati alle delve (curio, upgrade, oggetti di comodità).|n• Si ottiene principalmente facendo delve e dalle ricompense delle delve.|n• Spendili prima di accumularli alla cieca — controlla il venditore delle delve quando hai un pezzo obiettivo.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Usati per specifici upgrade di gear Midnight / acquisti da venditore (controlla le patch notes attuali per i venditori esatti).|n• Si ottengono da delve, contenuti del mondo e fonti settimanali.|n• Account snapshot può mostrare i totali per personaggio.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Currency condivisa per i sistemi |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• C'è un cap settimanale di guadagno — dopo il cap continui a giocare per altre ricompense ma smetti di guadagnare accolades fino al reset.|n• Si spendono per le ricompense di renown all'hub Bazaar (Eversong / Zul'Aman).|n• Conteggio in tempo reale nella scheda |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Currency di crafting di raid-tier (slot raid della Great Vault, progressione affine al catalyst).|n• I conteggi dei crest in tempo reale sono in |cffffffffBasics -> Crests|r (non in questo elenco).|n• Non sono come le key delle delve — vedi quella guida per gli obiettivi di spesa e i cap settimanali.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• L'equipaggiamento non ha solo un item level — sta su una |cfffffffftrack|r. Dal basso all'alto: |cffffffffAdventurer|r (verde), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Un tooltip con |cffffffffHero 3/6|r significa: track Hero, grado 3 di 6. Ogni grado che compri aggiunge item level.|n• La track fissa il tuo limite — il tooltip mostra l'intervallo di item level che può raggiungere. Per superarlo ti serve un drop da una track più alta.|n• Ogni track ha il suo colore di crest. I contenuti più difficili fanno cadere equip su una track più alta — è così che sali.|n• Track superata? Scambia i crest inferiori da |cffffffffVaskarn|r. Potenzia da |cffffffffCuzoth|r a Silvermoon — un grado costa i crest di quella track più un po' d'oro.|n• Ogni track ha un achievement «…of the Dawn»: ottienilo e tutta la tua |cffffffffWarband|r riceve il 50% di sconto sui potenziamenti di quella track.|n• Conteggi live e waypoint: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — panoramica",
	CODEX_DELVES_INTRO_BODY = "• Scenari in solitaria o in piccolo gruppo tra Eversong, Harandar, Voidstorm, ecc.|n• |cffffffffTier 1–11+|r — tier più alto = nemici più difficili e item level migliore nella vault.|n• Costa una |cffffffffRestored Coffer Key|r a run (vedi Currencies).|n• Le delve |cffffffffBountiful|r (a rotazione) danno loot extra — usa \"Find Nearest Bountiful Delve\" nella scheda Delves.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Pannello di consigli fluttuante: percorso, trash e meccaniche dei boss per ogni delve.|n• Si apre automaticamente in una delve (opzionale) o tramite |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• Il testo in inglese o olandese segue `/mh lang`.|n• Spotlight sul boss: scorri sul modello per zoomare (salvato per ogni boss).|n• I nomi delle spell in blu rimandano ai tooltip reali delle spell quando gli ID sono noti.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• I curio modificano la tua prossima run di delve (loot extra, boss più facili, ecc.).|n• Valeera offre consigli presso gli NPC di riparazione/gossip — popup nella scheda Delves quando pertinente.|n• Traccia consumabili e pulsanti della minimappa tramite il popup degli oggetti delve (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Delve Nemesis capostipite in Voidstorm — portale per un'istanza separata, non una delve del mondo a rotazione.|n• Si sblocca ai tier alti delle delve con vite limitate (vedi i requisiti in-game).|n• Boss Nullaeus — pesante check di interrupt/DPS; vedi Delve Coach per le meccaniche.|n• La bounty settimanale può attirare un Nullaeus indebolito in una delve normale (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Cronologia delle run di delve recenti (tier, tempi, gruppo).|n• Utile per ricordare quale variante hai finito o quale boss era attivo.|n• Il routing verso la delve più vicina può mandarti all'ingresso più vicino alla tua posizione.",

	CODEX_MPLUS_TITLE = "Mythic+ & vault dei dungeon",
	CODEX_MPLUS_BODY = "• I dungeon M+ riempiono la riga |cffffffffDungeons|r della Great Vault (separata dalle righe delve/world).|n• Key di livello più alto = item level più alto nello slot vault se completi la key nei tempi.|n• Vault Advisor usa i pesi delle stat M+ quando reclami il loot vault dei dungeon.|n• Midnight Helper non sostituisce un addon di route — usa MDT / note per le settimane degli affix.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• I boss di raid fanno progredire gli slot raid della vault (la difficoltà influisce sull'item level).|n• Normal / Heroic / Mythic contribuiscono ciascuno — controlla l'UI della vault per vedere quali boss hai ucciso questa settimana.|n• I crest spesso limitano i percorsi di upgrade del gear di raid.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Pannello laterale sull'UI delle ricompense settimanali di Blizzard quando reclami il loot della Great Vault (SHIFT-J) — non dentro le schede di Midnight Helper.|n• Classifica i pezzi della vault rispetto al gear equipaggiato usando le priorità di stat della guida (e Pawn opzionale).|n• Attiva/disattiva nelle impostazioni rapide della minimappa / Esc -> AddOns -> Midnight Helper.|n• Profilo Auto vs Raid vs M+ per i pesi delle stat.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — un unico sistema",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 abbina |cffffffffRitual Sites|r (Eversong) e |cffffffffVoid Assaults|r (Zul'Aman) sotto un'unica currency e renown.|n• Stesse |cffffffffField Accolades|r e hub Bazaar — non farmarli come attività scollegate.|n• Apri la scheda combinata per il sito attivo, i cap settimanali e i pulsanti TomTom in tempo reale.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Rituale settimanale a rotazione in Eversong Woods — completa le fasi per accolades e loot.|n• Solo un sito è \"attivo\" alla volta; l'addon evidenzia quale.|n• Il pin della SMC City Guide può portarti alla scheda Ritual con il contesto.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Ondate di assalto a Zul'Aman — difendi gli obiettivi, guadagna accolades.|n• Condivide il cap settimanale con il progresso dei ritual sulla stessa currency.|n• Controlla il timer dell'assalto / la zona attiva nella scheda Void & Rituals.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Mob rari settimanali con loot per account/personaggio (controlla in-game le regole di ogni rare).|n• Scheda |cffffffffRares|r: traccia le uccisioni, crea il percorso più vicino, la freccia TomTom resta sul pin più vicino.|n• Avviso in tempo reale quando un rare tracciato è vicino (~500 yd) — attiva/disattiva nelle impostazioni.",

	CODEX_PROF_TITLE = "Professions — ciclo settimanale",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance e Shards of Dundun sono tracce separate.|n• La scheda |cffffffffProfessions|r mostra i KP non spesi e le currency settimanali per profession.|n• Gli ordini di crafting e i tesori non sono completamente automatizzati qui — usa la guida Basics per spendere i KP.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• Sotto-scheda |cffffffffBasics -> Professions|r: piano KP passo passo e suggerimenti di combo.|n• La guida Crests copre la currency di crafting di raid (diversa dalle key delle delve).|n• Rileggi dopo le patch — gli ID delle currency e i cap possono cambiare.",
	CODEX_PROFRESET_TITLE = "Azzerare le specializzazioni di una professione (12.1)",
	CODEX_PROFRESET_BODY = "• La patch 12.1 permette di annullare le scelte di specializzazione Midnight — una volta per professione.|n• |cffffffffDa chi:|r Theremis, nel Bazaar di Lunargenta accanto agli ordini di artigianato. Offre una riga per professione, quindi puoi azzerare Forgiatura e lasciare Incantamento intatto.|n• |cffffffffCosa recuperi:|r ogni punto Conoscenza speso negli alberi Midnight di quella professione, libero di essere ridistribuito.|n• |cffffffffQuanto costa:|r l’avviso del gioco dice “You will lose all associated recipes”.|n• |cffffffffAssociate, non tutte.|r Sparisce ciò che quelle specializzazioni avevano sbloccato. Le ricette imparate da un maestro, da un bottino o da una missione stanno fuori dagli alberi e restano. Osservato su un Incantamento azzerato: la lista delle ricette era intatta e la Conoscenza spesa era tornata sul contatore.|n• |cffffffffÈ una volta sola.|r La conferma scrive ONCE in maiuscolo, e vale per professione — nessun secondo tentativo se la nuova strada delude.|n• Decidi |cffffffffprima|r di confermare. La pagina Professioni indica l’albero da riempire e il nodo esatto.|n• Le ricette tolte tornano se ridistribuisci in modo identico? Il gioco non lo dice mai. Conta che non sia così.",
	CODEX_ATALUTEK_TITLE = "Le Vaults of Atal'Utek — cosa c'è dentro, e dove",
	CODEX_ATALUTEK_BODY = "• |cffffffffCos'è:|r una zona della 12.1 sulla Coiled Isle con una mappa propria, e sotto di essa una seconda mappa, la Underbelly. È già aperta — nessun blocco stagionale.|n• |cffffffffCome si entra:|r una catena di tre missioni — |cffffffffInto the Vaults of Atal'Utek|r, poi |cffffffffVaults of Atal'Utek: One Coin Too Many|r, poi |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Tutto quello che segue sta dietro a queste, quindi falle per prime.|n• |cffffffffCorrosive Coin|r è la currency della zona. Parole del gioco: “Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.” Il tuo saldo è il numero qui sopra.|n• |cffffffffCorrosive Soul non è quella.|r Non è affatto una currency ma un |cffffffffoggetto|r nelle tue borse, ed è ciò che il Corrosive Codex ti chiede di offrire. Le guide scambiano di continuo i due nomi; il gioco mai. Se qualcosa ti dice di spendere Corrosive Coins al Codex, è quello lo scambio.|n• |cffffffffDove finiscono le monete — due posti, entrambi da Er’inye|r a {WAY:2509:51.10:62.76:Er'inye}. Parlargli compra |cffffffffCorrode Spirit|r, che alimenta l’albero dell’altare; accanto a lui lo |cffffffffSkull of Er’inye|r è un mercante con tre pagine di cavalcature, mascotte, completi e ricette, da 500 a 25.000 monete. |cffffffffIl prezzo del corrode sale a ogni acquisto|r — visto a 1.500 e poi 2.000 in una visita — quindi leggi la finestra invece di risparmiare per una cifra.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: le quattro chiavi",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffL'Altar of Corrosion|r è l'albero di nodi che apre l'ultima missione della catena. Gran parte si sblocca spendendo, ma |cffffffffquattro nodi stanno dietro a una chiave che devi trovare|r — e tutti e quattro funzionano allo stesso modo: cade un oggetto, lo usi su un oggetto fisso da qualche parte nelle Vaults, quello dà un oggetto missione, ed Er’inye fa il resto.|n|cffffffffCorroded Key|r → il Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, oppure Swift Steps) · |cffffffffSpirit Loupe|r → la Feather of Tok’jara a {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, oppure Spectral Shipping) · |cffffffffExcising Knife|r → l'Eye of Szarith, in una pozza di veleno nella Underbelly → |cffffffffBroodmaster|r (+100% danni alle uova, oppure −75% danni dalle esplosioni) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary nel Profaned Mausoleum → |cffffffffSpiritual Protection|r (alleati spettrali ai Curse Surge, oppure rialzarti subito se muori fuori dalle Vaults).|n|cffffffffMostrare una chiave a Er’inye non sblocca nulla.|r È cieco, e ti dice cosa sente — è un indizio su dove va quell'oggetto. |cffffffffDa dove cadano le chiavi non è stabilito|r: tre letture attente dello stesso database hanno dato tre risposte diverse, quindi non ne indichiamo una. Fai Strike e Incursion e saltano fuori.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead e i rari",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff“The Honored Dead” — dodici memoriali|r sulla mappa delle Vaults, un obiettivo, ed è la cosa più chiara da andare a fare qui. In un unico percorso, dall'alto della mappa verso il basso:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (sotto il ponte) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffLa Underbelly|r è la mappa sottostante, si entra a {WAY:2509:47.30:11.20:The Underbelly} sulla mappa delle Vaults. Là sotto vive un raro, |cffffffffSzarith the Fanged|r a {WAY:2613:38.40:17.69:Szarith the Fanged}, e la Underbelly ha un obiettivo tutto suo, |cffffffffSoft Underbelly|r.|n• |cffffffffTre rari elite sulla mappa principale|r — Congealed Malice, Khu'tulak e Susarikk — formano un terzo: |cffffffffOppose the Foes|r. |cffffffffNon hanno un punto fisso, e questa è la risposta, non una lacuna|r: uno dei tre si sveglia nel momento in cui viene completata una |cffffffffTemple Incursion|r, e hai circa dieci minuti per ucciderlo. Quindi non si vanno a cercare — si finiscono le Incursion, e uno arriva.",
})

merge(ns._mhLocales and ns._mhLocales.nlNL, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Jouw Midnight-handboek — wat elk systeem is, welke currency waarvoor dient, en waar je in deze addon moet klikken. Hover currency-iconen voor Blizzard-tooltips.",
	CODEX_OPEN_TAB_FMT = "Open: %s",
	CODEX_NAV_DELVES_VAULT = "Tab Delves & Vault (Great Vault-blok)",
	CODEX_NAV_DELVES_MIDNIGHT = "Tab Delves & Vault (delve-lijst)",
	CODEX_NAV_BASICS_DAWN = "Tab Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Tab Basics (Professions-gids)",
	CODEX_BALANCE_FMT = "Je hebt: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Saldo werkt bij na inloggen op dit personage.",
	CODEX_SEARCH_OPENED = "Midnight Codex geopend.",
	CODEX_BETA_DISABLED = "Midnight Codex staat uit in Instellingen (beta-tabs).",

	CODEX_CAT_START = "Start Here",
	CODEX_CAT_WEEKLY = "Weeklijkse loop",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Volg de route",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Start Here — jouw Midnight-week",
	CODEX_START_BODY = "|cffffcc00Denk in lagen:|r één weekly reset, meerdere beloningslijnen. Je hoeft niet alles elke dag te doen — kies een doel.|n|n|cffffff781) Account & reset|r|n• Check |cffffffffHome -> This Week|r voor vault, world boss, keys en weektaken.|n• |cffffffffAccount snapshot|r toont al je alts (vault, Delver's Call, profession-weeklies).|n|n|cffffff782) Combat content|r|n• |cffffffffDelves|r — hoofdgear-track (keys, tiers, Great Vault-slots). Gebruik |cffffffffDelve Coach|r voor tips per delve.|n• |cffffffffMythic+|r en |cffffffffRaid|r vullen andere vault-slots (zie categorieën Dungeons & Raid).|n|n|cffffff783) Open wereld (12.0.5)|r|n• Tab |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (zelfde renown).|n• Tab |cffffffffRares|r — weekly rare loot en routes.|n|n|cffffff784) Crafting|r|n• Tab |cffffffffProfessions|r voor KP / weekly mats; |cffffffffBasics|r voor crests.|n|n|cffffcc00Tip:|r open de categorie |cffffffffCurrencies|r als je een token bent vergeten. Scroll op het baas-beeld in Delve Coach om te zoomen.",
	CODEX_WARBAND_TITLE = "Warband & de Warband Bank",
	CODEX_WARBAND_BODY = "|cffffcc00Je Warband|r is elk personage op je account, als één team. Veel dingen zijn nu |cffffffffWarbound|r — account-breed gedeeld — dus je mailt veel minder tussen alts.|n|n|cffffff78Warbound items & currencies|r|n• De meeste Midnight-currencies zijn account-breed.|n• Gear is vaak |cffffffffWarbound tot uitgerust|r — stuur het naar een alt, maar zodra het uitgerust is hoort het bij dat personage.|n|n|cffffff78De Warband Bank|r — een gedeelde bank die al je personages gebruiken.|n• Open 'm bij |cffffffffelke bankier|r (of Jeeves) — het is een tabblad op je gewone bank, naast je character-bank.|n• Bewaar elk |cffffffffniet-soulbound|r item, en stort of neem |cffffffffgoud|r op tussen personages (ook cross-factie).|n• Craft er direct uit — het telt als reagent-bron.|n|n|cffffff78Tabs & kosten|r — 5 tabs, 98 slots elk (490 totaal). Je begint met geen; koop ze met goud:|n• Tab 1: |cffffffff1.000g|r|n• Tab 2: |cffffffff25.000g|r|n• Tab 3: |cffffffff100.000g|r|n• Tab 4: |cffffffff500.000g|r|n• Tab 5: |cffffffff2.500.000g|r  (alle vijf = 3.126.000g)|n|n|cffffcc00Tip:|r 2-3 tabs is voor de meeste spelers genoeg. Verwar 'm niet met je |cffffffffcharacter-bank|r (sinds patch 11.2 ook met tabs, veel goedkoper) — die is per personage; de Warband Bank is gedeeld.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly reset",
	CODEX_WEEKLY_RESET_BODY = "• Het meeste weekly progress reset op onderhoudsdag (EU woensdag ochtend, US dinsdag ochtend).|n• Great Vault, world boss, veel weekly caps en Delver's Call resetten.|n• |cffffffffHome -> This Week|r toont tijd tot reset als de API dat geeft.|n• Plan alts: snapshot-tab vergelijkt wie nog vault, boss of Delver's Call schuldig is.",

	CODEX_VAULT_TITLE = "Great Vault",
	CODEX_VAULT_BODY = "• Drie sporen: |cffffffffWorld|r (delves + world), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Vul activiteiten in de week; na reset kies je één beloning per slot bij de vault-NPC of SHIFT-J.|n• |cffffffffVault Advisor|r (op Blizzard vault-UI) rangschikt opties vs je gear.|n• De addon toont alle drie sporen op tab |cffffffffDelves & Vault|r — klapt |cffffffffWeekly Great Vault (World)|r open (nog geen aparte tab).|n• Samenvatting ook op |cffffffffHome -> This Week|r en |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "World boss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Eén roterende world boss per week (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Warband-loot: killt één char, alts tonen klaar.|n• Bovenaan |cffffffffDelves & Vault|r met TomTom-route.|n• Ook via SMC City Guide in Silvermoon.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nieuw power-systeem — een minimap-boek met |cffffffffrunen|r die je vrij wisselt buiten combat (geen slot nodig).|n• Power komt uit de wekelijkse |cffffffff'Seeking Knowledge'|r-keten (5 weken): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Elke week levert een |cffffffffMote of Omnial Inquiry|r om een rune te kiezen/versterken.|n• Alle 5 af = meta-achievement + de Sunstrider Omnium Simulacrum-decor.|n• Een week gemist? Doe de gemiste quests achter elkaar om bij te komen — geen reset afwachten.|n• (Gedataminet — exacte rune-effecten/IDs bij launch bevestigen.)",
	CODEX_S2_TITLE = "Een nieuw seizoen — wat het betekent",
	CODEX_S2_BODY = "• Je personage, mounts en collecties blijven allemaal — er gaat niets verloren.|n• Je gear lijkt \"lager\" omdat het nieuwe seizoen op een hogere schaal begint. Dat is normaal en verwacht — iedereen reset samen.|n• Je Mythic+-rating begint ook opnieuw — ook voor iedereen.|n• Het komt in twee stappen: eerst de patch (zone, campaign, dungeon), dan ~een week later het seizoen (raid, Mythic+, PvP).|n• Wat je nu doet: volg het Start Here-pad, geen haast.",
	CODEX_SEASONEND_TITLE = "Als een seizoen afloopt",
	CODEX_SEASONEND_BODY = "• |cffffffffJe gear reset niet.|r Alles wat je draagt gaat mee, op het item level dat het al heeft. Het is niet langer top-end, maar het is een echte voorsprong op dag één van het volgende seizoen. De wijziging waarbij ieders getallen wél omlaag gaan heet een squish, en die hoort bij de pre-patch van een uitbreiding — niet bij een seizoenswissel.|n• |cffffffffDe getallen schuiven, niet je voortgang.|r Elk seizoen gaan de item levels omhoog, dus een stuk dat nu maximaal is op de hoogste track zit in de nieuwe getallen een track of twee lager. Dat is normaal en overkomt iedereen.|n• |cffffffffBlijf je Great Vault openen tot de laatste week.|r Elke weekly is gratis gear die bepaalt waar je volgend seizoen begint.|n• |cffffffffSeizoensvaluta overleeft een wissel meestal niet ongeschonden|r — het wordt omgezet of onbruikbaar. Uitgeven is beter dan oppotten. Het gedrag verschilt per valuta en kan laat nog veranderen, dus kijk in je currency-tab in de game in plaats van op een guide te vertrouwen.|n• |cffffffffDe echte deadline zijn de seizoensgebonden dingen:|r mounts, titels en achievements van dit seizoen, en voortgangstracks die resetten. Dié zijn het waard om af te maken nu het nog kan.|n• |cffffffffVoortgangstracks resetten, maar hun beloningen zijn meestal niet weg|r — ze verhuizen daarna vaak naar een vendor zonder rang-eis, tegen een flink hogere prijs. Nu afmaken is goedkoper dan later kopen.|n• |cffffffffKies één lane.|r De laatste weken zijn kort. Eén track afmaken is beter dan drie half.",
	CODEX_PREY_TITLE = "Prey-hunts",
	CODEX_PREY_BODY = "• |cffffffffEen Prey-hunt is een gevolgde jacht, geen dungeon.|r Je pakt hem op bij Magister Astalor Bloodsworn in Murder Row, Silvermoon, volgt hem, en sluit af met een gevecht tegen één doelwit met een naam. Geen group finder, geen lockout om rekening mee te houden.|n• |cffffffffHet telt mee voor de Great Vault.|r Prey vult dezelfde world-rij als delves en ritual sites, dus het is een echte manier om die beloning te vullen en geen bijzaak.|n• |cffffffffEr zijn drie moeilijkheidsmodi.|r Begin op de laagste. Een zwaardere modus is dezelfde jacht met meer om te hanteren, geen andere content die je zou mislopen.|n• |cffffffffWar Mode-hunts tellen apart.|r Speel je zonder War Mode, dan mis je niets wat de rest van het systeem nodig heeft.|n• |cffffffffDe volledige doelenlijst is een langetermijndoel, geen weektaak.|r Hem afwerken levert een titel op. Eén jacht doen wanneer je er zin in hebt is een prima manier om het te spelen.|n• |cffffffffWil je weten hoe je ervoor staat|r, typ dan |cffffffff/mh prey|r, of open de Adventure Guide met Shift-J. Allebei lezen je voortgang uit de game, niet uit een lijstje van ons.",
	CODEX_S2GLOSS_TITLE = "Season 2 — nieuwe termen",
	CODEX_S2GLOSS_BODY = "• |cffffffffCrest|r — een currency om gear te upgraden. Elke track (Adventurer tot Myth) heeft z'n eigen crest; je verdient ze in delves, dungeons en raids.|n• |cffffffffUpgrade-track|r — de ladder die een stuk gear beklimt (Adventurer, Veteran, Champion, Hero, Myth). Hogere track = hoger plafond.|n• |cffffffffTier set|r — bij elkaar horende armor-stukken. Draag er 2 of 4 en je ontgrendelt een bonus voor je spec.|n• |cffffffffCatalyst|r — verandert een gewoon stuk in een tier-stuk; in Season 2 blijven de stats behouden.|n• |cffffffffBountiful Delve|r — een delve met een gegarandeerde extra beloning; heeft een Coffer Key nodig.|n• |cffffffffNemesis Delve|r — een speciale seizoensdelve met een eigen boss en beloningen.|n• |cffffffffLair|r — een world boss die je op een plek binnengaat en waar je een difficulty voor je groep kiest, als een mini-raid.|n• |cffffffffSeizoens-herschaling (squish)|r — nieuwe gear begint met hogere getallen, dus oude gear lijkt lager. Elk seizoen normaal; iedereen reset samen.",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Terugkerend Timewalking-event — nu een |cffffffffDragonflight|r-dungeonpool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Weekly: doe |cffffffff5 Timewalking-dungeons|r voor een gear-kist; elke run stapelt |cffffffffKnowledge of Timeways|r (XP-buff).|n• Verdien |cffffffffMastery of Timeways|r in 4 van 6 weken voor 'Master of the Turbulent Timeways' + het |cffffffffSpawn of Vyranoth|r-mount.|n• Geef Timewarped Badges uit bij de event-vendor.|n• Loopt ~30 juni – 11 aug. (Gedataminet — bij launch bevestigen.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Weekly delve-doelen met grote XP-beloning bij inleveren.|n• Je kunt calls |cffffffffbanken|r (klaar maar nog niet ingeleverd) voor een later level.|n• |cffffffffAccount snapshot|r telt banked/pending over alts.|n• Hover Delver's Call in snapshot voor detail per char.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Overzicht van chars waar je op hebt ingelogd met Midnight Helper.|n• Sorteer/filter op vault ready, keys, Dundun-cap, stale sinds reset.|n• Beantwoordt: \"Welke alt moet nog vault / boss / Delver's Call?\"|n• Vervangt niet inloggen voor gear of quest-checks.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Opent Midnight-delves (zoals vorige expansion keys).|n• Verdien via world, weeklies en vendors; geen harde cap op voorraad.|n• Zichtbaar op |cffffffffDelves & Vault|r.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Combineer tot Restored Coffer Keys (100 shards -> 1 key).|n• Weekly earn cap op shards — \"Weekly: X / Y\" op Delves-tab.|n• Meer delves = sneller cap vullen.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Vendor-currency voor delve-spullen (curios, upgrades).|n• Vooral uit delves.|n• Check delve-vendor met een concreet upgrade-doel.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Voor specifieke Midnight-upgrades / vendors (zie patch notes).|n• Uit delves, world en weeklies.|n• Snapshot kan totals per char tonen.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Gedeelde currency voor |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• Weekly cap — daarna nog spelen, geen accolades tot reset.|n• Uitgeven aan renown in Bazaar-hub.|n• Live count op tab Void & Rituals.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Raid-tier crafting currency.|n• Live crest-saldi staan op |cffffffffBasics -> Crests|r (niet in deze lijst).|n• Niet hetzelfde als delve keys — zie die gids voor uitgaven en weekly caps.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• Gear heeft niet alleen een item level — het zit op een |cfffffffftrack|r. Laag naar hoog: |cffffffffAdventurer|r (groen), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Staat er |cffffffffHero 3/6|r op een tooltip, dan betekent dat: de Hero-track, rang 3 van 6. Elke rang die je koopt geeft item level erbij.|n• De track bepaalt je plafond — de tooltip toont het ilvl-bereik dat 'ie kan halen. Daarboven kom je alleen met een drop van een hogere track.|n• Elke track heeft z'n eigen crest-kleur. Zwaardere content dropt gear op een hogere track — zo klim je.|n• Track ontgroeid? Ruil lagere crests om bij |cffffffffVaskarn|r. Upgraden doe je bij |cffffffffCuzoth|r in Silvermoon — een rang kost de crests van die track plus een beetje goud.|n• Elke track heeft een «…of the Dawn» achievement: haal 'm en je hele |cffffffffWarband|r krijgt 50% upgradekorting op die track.|n• Live saldi en waypoints: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Midnight delves — overzicht",
	CODEX_DELVES_INTRO_BODY = "• Solo of kleine groep in Eversong, Harandar, Voidstorm, …|n• |cffffffffTier 1–11+|r — hogere tier = moeilijker en betere ilvl in vault.|n• Kost |cffffffffRestored Coffer Key|r per run.|n• |cffffffffBountiful|r delves geven extra loot — knop op Delves-tab.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Zwevend tip-venster: route, trash en boss per delve.|n• Auto in delve of via preview-knop / |cffffffff/mh coach|r.|n• NL/EN via `/mh lang`.|n• Baas-beeld: scroll = zoom (opgeslagen per baas).|n• Blauwe spells = echte tooltips waar IDs bekend zijn.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & delve curios",
	CODEX_DELVE_CURIOS_BODY = "• Curios passen je volgende delve aan.|n• Valeera adviseert bij repair/gossip — popup op Delves-tab.|n• Delve items popup voor RAID-R Mini, Trovehunter's Bounty.",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis delve)",
	CODEX_TORMENTS_BODY = "• Capstone Nemesis-delve in Voidstorm — eigen portal.|n• Hoge tiers + limited lives (zie game).|n• Baas Nullaeus — zware interrupt/DPS-check; zie Delve Coach.|n• Weekly bounty kan verzwakte Nullaeus in normale delve trekken.",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Geschiedenis van recente runs.|n• Onthoud variant/baas.|n• Nearest-delve routing naar dichtstbijzijnde ingang.",

	CODEX_MPLUS_TITLE = "Mythic+ & dungeon vault",
	CODEX_MPLUS_BODY = "• M+ vult |cffffffffDungeons|r vault-rij.|n• Hogere key = hogere ilvl bij timed key.|n• Vault Advisor gebruikt M+-stat weights bij dungeon-loot.|n• Geen route-addon — gebruik MDT voor affix-weken.",

	CODEX_RAID_VAULT_TITLE = "Raid Great Vault",
	CODEX_RAID_VAULT_BODY = "• Raid-bazen vullen raid vault-slots (moeilijkheid = ilvl).|n• Normal/Heroic/Mythic tellen mee.|n• Crests gaten vaak upgrades op raid-gear.",

	CODEX_VAULT_ADVISOR_TITLE = "Great Vault Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Zijpaneel op Blizzard weekly reward UI bij Great Vault claimen (SHIFT-J) — niet in een Midnight Helper-tab.|n• Rangschikt vs equipped gear (optioneel Pawn).|n• Toggle in minimap settings / Esc -> AddOns.|n• Auto / Raid / M+ profiel.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — één systeem",
	CODEX_WORLD_HUB_BODY = "• 12.0.5 koppelt Ritual Sites (Eversong) en Void Assaults (Zul'Aman).|n• Zelfde |cffffffffField Accolades|r en Bazaar-hub.|n• Gecombineerde tab voor actieve site, caps en TomTom.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Weekly ritual in Eversong — accolades en loot.|n• Eén site tegelijk actief; addon markeert welke.|n• SMC-pin opent Ritual-tab.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Zul'Aman assault-golven — accolades.|n• Deelt weekly cap met rituals.|n• Timer/actieve zone op Void & Rituals-tab.",

	CODEX_RARES_TITLE = "Midnight rares",
	CODEX_RARES_BODY = "• Weekly rares met account/char loot.|n• Tab Rares: kills, route, TomTom op dichtstbijzijnde.|n• Alert bij rare in de buurt (~500 yd) — toggle in settings.",

	CODEX_PROF_TITLE = "Professions — weekly loop",
	CODEX_PROF_BODY = "• KP, Artisan's Moxie, Unalloyed Abundance en Dundun-shards zijn apart.|n• Tab Professions toont unspent KP en weeklies.|n• Orders/treasures: zie Basics voor KP-plan.",

	CODEX_PROF_GUIDE_TITLE = "Professions beginner guide",
	CODEX_PROF_GUIDE_BODY = "• |cffffffffBasics -> Professions|r: KP-plan en combos.|n• Crests = raid crafting currency.|n• Herlees na patches — caps/IDs kunnen wijzigen.",
	CODEX_CRAFTGEAR_TITLE = "Gear laten craften",
	CODEX_CRAFTGEAR_BODY = "• Je hoeft het beroep niet zelf te hebben — een andere speler kan het voor je maken via een |cffffffffCrafting Order|r.|n• Crafted gear is de |cffffffffbetrouwbare|r route: geen geluk met drops nodig. Het is ook de enige gear met een |cffffffffEmbellishment|r (een speciaal effect — je draagt er maximaal twee).|n• |cffffffffWat je eerst verzamelt:|r een |cffffffffSpark|r (2 voor een kledingstuk of 1-hander, 4 voor een 2-hander) uit de wekelijkse quest in Silvermoon; |cffffffffcrests|r als je de hogere versie wilt; een |cffffffffMissive|r om je secondary stats te kiezen (Auction House); en de materialen.|n• |cffffffffDe crest-stap is bepalend:|r zonder crests krijg je de basisversie. Crests van een hogere tier verhogen het item level dat het stuk kan halen — de hoogste crests geven de sterkste craft. Je crest-tab laat zien wat je hebt.|n• |cffffffffDan bestellen:|r praat met de Crafting Orders-NPC in de Bazaar van Silvermoon, kies het item, hang je spark, crests en missive eraan, en zet hem als publieke order of stuur hem naar een crafter die je kent. Zet er een fooi bij, anders blijft hij hangen.|n• |cffffffffSparks en crests kan de crafter NIET leveren|r — die moet jij hebben. Hier gaat de eerste bestelling meestal mis.|n• De skill van de crafter bepaalt de kwaliteit, dus een crafter die je kent is beter dan een willekeurige publieke order.|n• De moeite waard als een slot maar niet wil droppen, of voor een Embellishment. Vallen er in dat slot makkelijk goede drops, bewaar je crests dan.",
	CODEX_PROFRESET_TITLE = "Je beroepsspecialisaties resetten (12.1)",
	CODEX_PROFRESET_BODY = "• Patch 12.1 laat je je Midnight-specialisatiekeuzes terugdraaien — één keer per beroep.|n• |cffffffffBij wie:|r Theremis, in de Bazaar van Silvermoon naast de crafting orders. Hij biedt per beroep een aparte regel, dus je kunt Blacksmithing resetten en Enchanting precies laten zoals hij is.|n• |cffffffffWat je terugkrijgt:|r elk Knowledge Point dat je in de Midnight-bomen van dat beroep hebt uitgegeven, vrij om opnieuw te verdelen.|n• |cffffffffWat het kost:|r de waarschuwing van het spel luidt “You will lose all associated recipes”.|n• |cffffffffBijbehorende, niet alle.|r Weg is wat die specialisatiekeuzes hadden ontgrendeld. Recepten van een trainer, een drop of een quest staan buiten de bomen en blijven gewoon staan. Gezien bij een gereset Enchanting: de receptenlijst was onaangeroerd en de uitgegeven Knowledge stond weer op de teller.|n• |cffffffffHet is één keer.|r De bevestiging zegt ONCE in hoofdletters, en dat is per beroep — er is geen tweede poging als het nieuwe pad tegenvalt.|n• Bepaal dus |cffffffffvooraf|r waar de punten heen gaan. De Professions-pagina noemt de boom die je moet vullen en precies welke node.|n• Komen de recepten die hij afnam terug als je identiek herbesteedt? Het spel zegt dat nergens. Reken erop van niet.",
	CODEX_ATALUTEK_TITLE = "De Vaults of Atal'Utek — wat er te doen is, en waar",
	CODEX_ATALUTEK_BODY = "• |cffffffffWat het is:|r een stuk 12.1-content op de Coiled Isle met een eigen kaart, en daaronder nóg een kaart: de Underbelly. Het staat nu al open — er zit geen seizoenspoort op.|n• |cffffffffHoe je binnenkomt:|r een keten van drie quests — |cffffffffInto the Vaults of Atal'Utek|r, dan |cffffffffVaults of Atal'Utek: One Coin Too Many|r, dan |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Alles hieronder zit erachter, dus doe die eerst.|n• |cffffffffCorrosive Coin|r is de currency van de zone. In de woorden van het spel zelf: “Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.” Je eigen saldo is het getal hierboven.|n• |cffffffffCorrosive Soul is dat niet.|r Het is helemaal geen currency maar een |cffffffffitem|r in je tassen, en het is wat de Corrosive Codex als offer van je vraagt. Gidsen halen de twee namen voortdurend door elkaar; het spel nooit. Zegt iets dat je Corrosive Coins bij de Codex moet uitgeven, dan is dat precies die verwisseling.|n• |cffffffffWaar de munten heen gaan — twee plekken, allebei bij Er’inye|r op {WAY:2509:51.10:62.76:Er'inye}. Met hem praten koopt |cffffffffCorrode Spirit|r, en dat is wat de Altar-boom voedt; naast hem is de |cffffffffSkull of Er’inye|r een handelaar met drie pagina’s mounts, pets, ensembles en recepten, van 500 tot 25.000 munt. |cffffffffDe corrode-prijs loopt elke keer op|r — gezien op 1.500 en daarna 2.000 in één bezoek — dus lees het venster in plaats van te sparen voor een bedrag.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: de vier sleutels",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffThe Altar of Corrosion|r is de boom met nodes die de laatste quest van de keten opent. Het meeste gaat vanzelf open naarmate je uitgeeft, maar |cffffffffvier nodes zitten achter een sleutel die je zelf moet vinden|r — en alle vier werken ze hetzelfde: er valt een item, dat gebruik je op één object ergens in de Vaults, dat geeft een questitem, en Er’inye doet de rest.|n|cffffffffCorroded Key|r → de Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, of Swift Steps) · |cffffffffSpirit Loupe|r → de Feather of Tok’jara op {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, of Spectral Shipping) · |cffffffffExcising Knife|r → de Eye of Szarith, in een gifpoel in de Underbelly → |cffffffffBroodmaster|r (+100% schade op eggs, of −75% schade van egg bursts) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary in het Profaned Mausoleum → |cffffffffSpiritual Protection|r (spookbondgenoten bij Curse Surges, of meteen weer opstaan als je buiten de Vaults doodgaat).|n|cffffffffEen sleutel aan Er’inye tonen ontgrendelt niets.|r Hij is blind, en hij vertelt je wat hij vóélt — dat is een hint over waar het ding hoort. |cffffffffWaar de sleutels vandaan komen staat niet vast|r: drie zorgvuldige lezingen van dezelfde database gaven drie verschillende antwoorden, dus we noemen er geen. Doe Strikes en Incursions, dan komen ze vanzelf.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead & de rares",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff“The Honored Dead” — twaalf gedenktekens|r op de Vaults-kaart, één achievement, en verreweg het duidelijkste om hier gewoon te gaan dóen. In één looproute, van boven op de kaart naar beneden:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (onder de brug) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffDe Underbelly|r is de kaart eronder, met de ingang op {WAY:2509:47.30:11.20:The Underbelly} op de Vaults-kaart. Daar woont één rare, |cffffffffSzarith the Fanged|r op {WAY:2613:38.40:17.69:Szarith the Fanged}, en de Underbelly heeft een eigen achievement: |cffffffffSoft Underbelly|r.|n• |cffffffffDrie rare elites op de hoofdkaart|r — Congealed Malice, Khu'tulak en Susarikk — vormen een derde: |cffffffffOppose the Foes|r. |cffffffffZe hebben geen vaste plek, en dat ís het antwoord, geen gat in onze kennis|r: één van de drie wordt wakker op het moment dat er een |cffffffffTemple Incursion|r wordt afgerond, en je hebt ongeveer tien minuten om hem te doden. Je gaat dus niet op ze jagen — je maakt Incursions af, en dan komt er één naar jou toe.",
})

merge(ns._mhLocales and ns._mhLocales.deDE, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Dein Handbuch für Midnight — was jedes System ist, wofür jede Währung dient und wo du in diesem Addon klickst. Bewege den Cursor über Währungssymbole für Blizzard-Tooltips.",
	CODEX_OPEN_TAB_FMT = "Öffnen: %s",
	CODEX_NAV_DELVES_VAULT = "Tab Delves & Vault (Große-Schatzkammer-Block)",
	CODEX_NAV_DELVES_MIDNIGHT = "Tab Delves & Vault (Tiefen-Liste)",
	CODEX_NAV_BASICS_DAWN = "Tab Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Tab Basics (Professions-Guide)",
	CODEX_BALANCE_FMT = "Du hast: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Der Stand aktualisiert sich, wenn du dich mit diesem Charakter anmeldest.",
	CODEX_SEARCH_OPENED = "Midnight Codex geöffnet.",
	CODEX_BETA_DISABLED = "Midnight Codex ist in den Einstellungen deaktiviert (Beta-Tabs).",

	CODEX_CAT_START = "Erste Schritte",
	CODEX_CAT_WEEKLY = "Wöchentlicher Ablauf",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & Crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Der Route folgen",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Erste Schritte — deine Midnight-Woche",
	CODEX_START_BODY = "|cffffcc00Denk in Schichten:|r ein Weekly-Reset, mehrere Belohnungspfade. Du brauchst nicht jedes System jeden Tag — wähle ein Ziel.|n|n|cffffff781) Account & Reset|r|n• Prüfe |cffffffffHome -> This Week|r für Vault, Weltboss, Keys und Aufgaben.|n• |cffffffffAccount snapshot|r zeigt all deine Twinks (Vault, Delver's Call, Berufs-Weeklies).|n|n|cffffff782) Kampfinhalte|r|n• |cffffffffDelves|r — Haupt-Gear-Pfad (Keys, Stufen, Schatzkammer-Slots). Nutze |cffffffffDelve Coach|r für Tipps pro Tiefe.|n• |cffffffffMythic+|r und |cffffffffRaid|r füllen weitere Vault-Slots (siehe Kategorien Dungeons & Raid).|n|n|cffffff783) Offene Welt (12.0.5)|r|n• Tab |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (gleicher Renown-Pfad).|n• Tab |cffffffffRares|r — wöchentliche Rare-Beute und Routen.|n|n|cffffff784) Crafting|r|n• Tab |cffffffffProfessions|r für KP / wöchentliche Mats; |cffffffffBasics|r für Crests.|n|n|cffffcc00Tipp:|r Öffne hier die Kategorie |cffffffffCurrencies|r, wenn du vergisst, wofür ein Token ist. Scrolle im Boss-Vorschaubild im Delve Coach zum Zoomen.",
	CODEX_WARBAND_TITLE = "Kriegsmeute & die Kriegsmeutenbank",
	CODEX_WARBAND_BODY = "|cffffcc00Deine Kriegsmeute|r sind alle Charaktere deines Accounts, als ein Team behandelt. Vieles ist jetzt |cffffffffkriegsmeutengebunden|r — accountweit geteilt — sodass du viel weniger zwischen Twinks verschickst.|n|n|cffffff78Kriegsmeutengebundene Gegenstände & Währungen|r|n• Die meisten Midnight-Währungen sind accountweit.|n• Ausrüstung ist oft |cffffffffkriegsmeutengebunden bis angelegt|r — schick sie an einen Twink, aber einmal angelegt bleibt sie bei diesem Charakter.|n|n|cffffff78Die Kriegsmeutenbank|r — eine geteilte Bank, die all deine Charaktere nutzen.|n• Öffne sie bei |cffffffffjedem Bankier|r (oder Jeeves) — es ist ein Reiter an deiner normalen Bank, neben deiner Charakterbank.|n• Lagere jeden |cffffffffnicht-seelengebundenen|r Gegenstand und zahle |cffffffffGold|r über Charaktere hinweg ein oder aus (auch fraktionsübergreifend).|n• Crafte direkt daraus — sie zählt als Reagenzienquelle.|n|n|cffffff78Reiter & Kosten|r — 5 Reiter, je 98 Plätze (490 gesamt). Du startest mit keinem; kaufe sie mit Gold:|n• Reiter 1: |cffffffff1.000g|r|n• Reiter 2: |cffffffff25.000g|r|n• Reiter 3: |cffffffff100.000g|r|n• Reiter 4: |cffffffff500.000g|r|n• Reiter 5: |cffffffff2.500.000g|r  (alle fünf = 3.126.000g)|n|n|cffffcc00Tipp:|r 2-3 Reiter reichen den meisten Spielern. Verwechsle sie nicht mit deiner |cffffffffCharakterbank|r (seit Patch 11.2 auch mit Reitern, viel günstiger) — die ist pro Charakter; die Kriegsmeutenbank ist geteilt.",

	CODEX_WEEKLY_RESET_TITLE = "Weekly-Reset",
	CODEX_WEEKLY_RESET_BODY = "• Der meiste wöchentliche Fortschritt setzt sich am Wartungstag deiner Region zurück (EU Mittwochmorgen, US Dienstagmorgen).|n• Große-Schatzkammer-Auswahl, Weltboss-Beute, viele Wochen-Caps und Delver's-Call-Lieferungen setzen sich zurück.|n• |cffffffffHome -> This Week|r zeigt die Zeit bis zum Reset, wenn die API sie liefert.|n• Plane Twinks: der Snapshot-Tab vergleicht, wer noch Vault, Boss oder Delver's Call offen hat.",

	CODEX_VAULT_TITLE = "Große Schatzkammer",
	CODEX_VAULT_BODY = "• Drei Pfade: |cffffffffWorld|r (Tiefen + Weltinhalte), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Fülle Aktivitäten während der Woche; nach dem Reset wählst du pro freigeschaltetem Slot eine Belohnung beim Vault-NPC oder per SHIFT-J.|n• |cffffffffVault Advisor|r (auf Blizzards Vault-UI) bewertet Optionen gegen deine angelegte Ausrüstung.|n• Dieses Addon zeigt alle drei Pfade im Tab |cffffffffDelves & Vault|r — klappe |cffffffffWeekly Great Vault (World)|r auf (noch kein eigener Tab).|n• Zusammenfassung auch auf |cffffffffHome -> This Week|r und |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "Weltboss (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Ein rotierender Weltboss pro Woche (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Kriegsmeuten-Beute: tötet ihn ein Charakter, zeigen Twinks ihn als erledigt.|n• Oben im Tab |cffffffffDelves & Vault|r mit TomTom-Route.|n• Auch über den SMC City Guide in Silbermond verlinkt.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Neues Machtsystem zur Erweiterungsmitte — ein Minimap-Buch mit |cffffffffRunen|r, die du außerhalb des Kampfes frei tauschst (kein Slot-Verbrauch).|n• Macht kommt aus der wöchentlichen Kette |cffffffff'Seeking Knowledge'|r (5 Wochen): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Jede Woche belohnt ein |cffffffffMote of Omnial Inquiry|r, um eine Rune zu wählen/verstärken.|n• Schließe alle 5 ab für das Meta-Achievement und die Sunstrider-Omnium-Simulacrum-Dekoration.|n• Eine Woche verpasst? Mache die verpassten Quests direkt hintereinander zum Aufholen — kein Warten auf Resets.|n• (Datamined — genaue Runeneffekte/IDs werden beim Launch bestätigt.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Wiederkehrendes Zeitwanderungs-Event — diesmal ein |cffffffffDragonflight|r-Dungeonpool: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Wöchentlich: laufe |cffffffff5 Zeitwanderungs-Dungeons|r für einen Gear-Cache; jeder Lauf stapelt |cffffffffKnowledge of Timeways|r (XP-Buff).|n• Verdiene |cffffffffMastery of Timeways|r in 4 von 6 Wochen für 'Master of the Turbulent Timeways' und das Reittier |cffffffffSpawn of Vyranoth|r.|n• Gib Zeitverlorene Abzeichen beim Event-Händler aus.|n• Läuft ~30. Juni – 11. Aug. (Datamined — beim Launch bestätigen.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Wöchentliche Tiefen-Ziele, die beim Abgeben einen großen XP-Schub geben.|n• Du kannst abgeschlossene Calls |cffffffffbanken|r (erledigte Ziele, noch nicht abgegeben) für ein späteres Charakter-Level.|n• |cffffffffAccount snapshot|r fasst gebankte und ausstehende Calls über Twinks zusammen.|n• Bewege den Cursor über die Delver's-Call-Zeile im Snapshot für Details pro Charakter.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Schreibgeschützte Übersicht der Charaktere, mit denen du dich mit Midnight Helper angemeldet hast.|n• Sortiere/filtere nach Vault bereit, Keys, Shards-of-Dundun-Cap, inaktiv seit Reset usw.|n• Beantwortet: \"Welcher Twink braucht noch Vault / Boss / Delver's Call?\"|n• Ersetzt nicht das Anmelden auf einem Twink für Gear- oder Quest-Checks.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Öffnet Midnight-Tiefen (wie die Keys vorheriger Erweiterungen).|n• Verdiene sie aus Weltinhalten, Weeklies und bei Händlern; kein hartes Wochen-Cap auf gehaltene Keys.|n• Im Tab |cffffffffDelves & Vault|r mit deinem aktuellen Bestand angezeigt.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Werden zu Restored Coffer Keys kombiniert (100 Shards -> 1 Key zum Standardkurs).|n• Auf Shards gilt ein wöchentliches Verdienst-Cap — verfolge \"Weekly: X / Y\" im Delves-Tab.|n• Das Cap füllt sich schneller, wenn du mehr Tiefen läufst oder Shard-Quellen abschließt.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Händlerwährung für tiefenbezogene Waren (Curios, Upgrades, Komfortgegenstände).|n• Wird vor allem durch das Laufen von Tiefen und Tiefenbelohnungen verdient.|n• Gib sie aus, statt blind zu horten — prüfe den Tiefenhändler, wenn du ein Zielstück hast.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Für bestimmte Midnight-Gear-Upgrades / Händlerkäufe (siehe aktuelle Patchnotes für genaue Händler).|n• Verdiene sie aus Tiefen, Weltinhalten und wöchentlichen Quellen.|n• Account snapshot kann Summen pro Charakter zeigen.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Geteilte Währung für die |cffffffffVoid & Rituals|r-Systeme (Ritual Sites + Void Assaults).|n• Wöchentliches Verdienst-Cap — nach dem Cap spielst du weiter für andere Belohnungen, gewinnst aber bis zum Reset keine Accolades mehr.|n• Wird für Renown-Belohnungen am Bazaar-Hub ausgegeben (Eversong / Zul'Aman).|n• Live-Anzeige im Tab |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Crafting-Währung der Raid-Stufe (Raid-Slots der Großen Schatzkammer, katalysatornahe Progression).|n• Live-Crest-Stände stehen auf |cffffffffBasics -> Crests|r (nicht in dieser Liste).|n• Nicht dasselbe wie Tiefen-Keys — siehe jenen Guide für Ausgabeziele und Wochen-Caps.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• Ausrüstung hat nicht nur eine Gegenstandsstufe — sie liegt auf einer |cfffffffftrack|r. Von niedrig nach hoch: |cffffffffAdventurer|r (grün), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Steht |cffffffffHero 3/6|r im Tooltip, heißt das: Hero-Track, Rang 3 von 6. Jeder gekaufte Rang bringt Gegenstandsstufe.|n• Die Track bestimmt deine Obergrenze — der Tooltip zeigt die erreichbare Gegenstandsstufen-Spanne. Höher kommst du nur mit einem Drop einer höheren Track.|n• Jede Track hat ihre eigene Crest-Farbe. Schwerere Inhalte lassen Ausrüstung auf einer höheren Track fallen — so steigst du auf.|n• Track entwachsen? Tausche niedrigere Crests bei |cffffffffVaskarn|r. Aufwerten bei |cffffffffCuzoth|r in Silbermond — ein Rang kostet die Crests dieser Track plus etwas Gold.|n• Jede Track hat einen «…of the Dawn»-Erfolg: Hol ihn dir und deine ganze |cffffffffWarband|r bekommt 50% Aufwertungsrabatt auf dieser Track.|n• Live-Stände und Wegpunkte: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Midnight-Tiefen — Übersicht",
	CODEX_DELVES_INTRO_BODY = "• Solo- oder Kleingruppen-Szenarien über Eversong, Harandar, Voidstorm usw.|n• |cffffffffTier 1–11+|r — höhere Stufe = schwierigere Gegner und besseres Item-Level in der Vault.|n• Kostet pro Lauf einen |cffffffffRestored Coffer Key|r (siehe Currencies).|n• |cffffffffGroßzügige|r Tiefen (rotierend) geben Extra-Beute — nutze \"Find Nearest Bountiful Delve\" im Delves-Tab.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Schwebendes Tipp-Panel: Route, Trash und Bossmechaniken pro Tiefe.|n• Öffnet sich automatisch in einer Tiefe (optional) oder über |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• Englischer oder niederländischer Text folgt `/mh lang`.|n• Boss-Spotlight: scrolle auf dem Modell zum Zoomen (pro Boss gespeichert).|n• Blaue Zaubernamen verlinken echte Zauber-Tooltips, wenn die IDs bekannt sind.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & Tiefen-Curios",
	CODEX_DELVE_CURIOS_BODY = "• Curios verändern deinen nächsten Tiefenlauf (Extra-Beute, leichtere Bosse usw.).|n• Valeera gibt Rat bei Reparatur-/Gossip-NPCs — Popup im Delves-Tab, wenn relevant.|n• Verfolge Verbrauchsgüter und Minimap-Buttons über das Tiefen-Item-Popup (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (Nemesis-Tiefe)",
	CODEX_TORMENTS_BODY = "• Krönende Nemesis-Tiefe in Voidstorm — eigenes Instanzportal, keine rotierende Welt-Tiefe.|n• Schaltet sich auf hohen Tiefenstufen mit begrenzten Leben frei (siehe In-Game-Anforderungen).|n• Boss Nullaeus — harter Unterbrechungs-/DPS-Check; siehe Delve Coach für Mechaniken.|n• Die wöchentliche Bounty kann einen geschwächten Nullaeus in eine normale Tiefe ziehen (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Verlauf der letzten Tiefenläufe (Stufen, Zeiten, Gruppe).|n• Praktisch, um sich zu merken, welche Variante du beendet hast oder welcher Boss aktiv war.|n• Die Nächste-Tiefe-Routenführung schickt dich zum nächstgelegenen Eingang von deiner Position aus.",

	CODEX_MPLUS_TITLE = "Mythic+ & Dungeon-Vault",
	CODEX_MPLUS_BODY = "• M+-Dungeons füllen die |cffffffffDungeons|r-Reihe der Großen Schatzkammer (getrennt von Tiefen-/Welt-Reihen).|n• Höheres Key-Level = höheres Item-Level im Vault-Slot, wenn du den Key in der Zeit schaffst.|n• Vault Advisor nutzt M+-Stat-Gewichtungen, wenn du Dungeon-Vault-Beute beanspruchst.|n• Midnight Helper ersetzt kein Routen-Addon — nutze MDT / Notizen für Affix-Wochen.",

	CODEX_RAID_VAULT_TITLE = "Raid — Große Schatzkammer",
	CODEX_RAID_VAULT_BODY = "• Raid-Bosse bringen Raid-Vault-Slots voran (Schwierigkeit beeinflusst das Item-Level).|n• Normal / Heroisch / Mythisch tragen jeweils bei — prüfe die Vault-UI, welche Bosse du diese Woche getötet hast.|n• Crests begrenzen oft die Upgrade-Pfade von Raid-Gear.",

	CODEX_VAULT_ADVISOR_TITLE = "Großer-Schatzkammer-Advisor",
	CODEX_VAULT_ADVISOR_BODY = "• Seitenpanel auf Blizzards wöchentlicher Belohnungs-UI, wenn du Große-Schatzkammer-Beute beanspruchst (SHIFT-J) — nicht in den Midnight-Helper-Tabs.|n• Bewertet Vault-Stücke gegen angelegtes Gear anhand der Guide-Stat-Prioritäten (und optional Pawn).|n• Umschaltbar in den Minimap-Schnelleinstellungen / Esc -> AddOns -> Midnight Helper.|n• Profil Auto vs. Raid vs. M+ für Stat-Gewichtungen.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — ein System",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 koppelt |cffffffffRitual Sites|r (Eversong) und |cffffffffVoid Assaults|r (Zul'Aman) unter einer Währung und Renown.|n• Gleiche |cffffffffField Accolades|r und Bazaar-Hub — farme sie nicht als zusammenhanglose Aktivitäten.|n• Öffne den kombinierten Tab für aktive Site, Wochen-Caps und TomTom-Buttons.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Wöchentlich rotierendes Ritual in Eversong Woods — schließe Phasen für Accolades und Beute ab.|n• Nur eine Site ist gleichzeitig \"aktiv\"; das Addon hebt hervor, welche.|n• Der SMC-City-Guide-Pin kann dich mit Kontext zum Ritual-Tab bringen.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Zul'Aman-Angriffswellen — verteidige Ziele, verdiene Accolades.|n• Teilt sich das Wochen-Cap mit dem Ritual-Fortschritt auf derselben Währung.|n• Prüfe Angriffs-Timer / aktive Zone im Tab Void & Rituals.",

	CODEX_RARES_TITLE = "Midnight-Rares",
	CODEX_RARES_BODY = "• Wöchentliche Rare-Mobs mit Account-/Charakter-Beute (prüfe die Regeln jedes Rares im Spiel).|n• Tab |cffffffffRares|r: verfolge Kills, baue die nächste Route, der TomTom-Pfeil bleibt auf dem nächstgelegenen Pin.|n• Live-Warnung, wenn ein verfolgtes Rare in der Nähe ist (~500 yd) — umschaltbar in den Einstellungen.",

	CODEX_PROF_TITLE = "Professions — wöchentlicher Ablauf",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance und Shards of Dundun sind getrennte Pfade.|n• Der Tab |cffffffffProfessions|r zeigt nicht ausgegebene KP und Wochenwährungen pro Beruf.|n• Crafting-Aufträge und Schätze sind hier nicht voll automatisiert — nutze den Basics-Guide zum KP-Ausgeben.",

	CODEX_PROF_GUIDE_TITLE = "Professions — Einsteiger-Guide",
	CODEX_PROF_GUIDE_BODY = "• Unter-Tab |cffffffffBasics -> Professions|r: schrittweiser KP-Plan und Combo-Vorschläge.|n• Der Crests-Guide deckt die Raid-Crafting-Währung ab (anders als Tiefen-Keys).|n• Nach Patches erneut lesen — Währungs-IDs und Caps können sich ändern.",
	CODEX_PROFRESET_TITLE = "Berufsspezialisierungen zurücksetzen (12.1)",
	CODEX_PROFRESET_BODY = "• Patch 12.1 lässt dich deine Midnight-Spezialisierungen zurücksetzen — einmal pro Beruf.|n• |cffffffffBei wem:|r Theremis, im Basar von Silbermond neben den Handwerksaufträgen. Er bietet pro Beruf eine eigene Zeile, du kannst also Schmiedekunst zurücksetzen und Verzauberkunst unangetastet lassen.|n• |cffffffffWas du zurückbekommst:|r jeden Wissenspunkt, den du in den Midnight-Bäumen dieses Berufs ausgegeben hast, frei neu verteilbar.|n• |cffffffffWas es kostet:|r die Warnung des Spiels lautet „You will lose all associated recipes“.|n• |cffffffffZugehörige, nicht alle.|r Weg ist, was diese Spezialisierungen freigeschaltet hatten. Rezepte von einem Lehrer, aus Beute oder aus einer Quest liegen außerhalb der Bäume und bleiben. Bei einer zurückgesetzten Verzauberkunst beobachtet: die Rezeptliste war unberührt und das ausgegebene Wissen stand wieder auf dem Zähler.|n• |cffffffffEs ist einmalig.|r Die Bestätigung sagt ONCE in Großbuchstaben, und zwar pro Beruf — einen zweiten Versuch gibt es nicht, wenn der neue Weg enttäuscht.|n• Entscheide also |cffffffffvorher|r, wohin die Punkte gehen. Die Berufe-Seite nennt den zu füllenden Baum und den genauen Knoten.|n• Kommen die genommenen Rezepte zurück, wenn du identisch neu verteilst? Das Spiel sagt es nirgends. Plane so, als würden sie es nicht.",
	CODEX_ATALUTEK_TITLE = "Die Vaults of Atal'Utek — was es dort gibt, und wo",
	CODEX_ATALUTEK_BODY = "• |cffffffffWas es ist:|r ein 12.1-Gebiet auf der Coiled Isle mit eigener Karte, und darunter eine zweite Karte, die Underbelly. Es ist bereits offen — kein Saisontor davor.|n• |cffffffffWie du hineinkommst:|r eine Kette aus drei Quests — |cffffffffInto the Vaults of Atal'Utek|r, dann |cffffffffVaults of Atal'Utek: One Coin Too Many|r, dann |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Alles Weitere liegt dahinter, also mach die zuerst.|n• |cffffffffCorrosive Coin|r ist die Währung der Zone. Mit den Worten des Spiels: „Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.“ Dein Bestand ist die Zahl über diesem Artikel.|n• |cffffffffCorrosive Soul ist das nicht.|r Es ist überhaupt keine Währung, sondern ein |cffffffffGegenstand|r in deinen Taschen, und genau danach fragt der Corrosive Codex. Guides vertauschen die beiden Namen ständig; das Spiel nie. Wenn dir etwas sagt, du sollst Corrosive Coins am Codex ausgeben, ist das die Verwechslung.|n• |cffffffffWohin die Münzen gehen — zwei Stellen, beide bei Er’inye|r bei {WAY:2509:51.10:62.76:Er'inye}. Mit ihm zu reden kauft |cffffffffCorrode Spirit|r, und das speist den Altar-Baum; neben ihm ist der |cffffffffSkull of Er’inye|r ein Händler mit drei Seiten Reittiere, Haustiere, Ensembles und Rezepte, von 500 bis 25.000 Münzen. |cffffffffDer Corrode-Preis steigt bei jedem Kauf|r — bei einem Besuch 1.500 und dann 2.000 gesehen — lies also das Fenster, statt auf eine Zahl zu sparen.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: die vier Schlüssel",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffDer Altar of Corrosion|r ist der Knotenbaum, den die letzte Quest der Kette öffnet. Das meiste öffnet sich beim Ausgeben, aber |cffffffffvier Knoten liegen hinter einem Schlüssel, den du selbst finden musst|r — und alle vier funktionieren gleich: ein Gegenstand fällt, du benutzt ihn an einem Objekt irgendwo in den Vaults, das gibt einen Questgegenstand, und Er’inye macht den Rest.|n|cffffffffCorroded Key|r → die Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, oder Swift Steps) · |cffffffffSpirit Loupe|r → die Feather of Tok’jara bei {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, oder Spectral Shipping) · |cffffffffExcising Knife|r → das Eye of Szarith, in einem Gifttümpel in der Underbelly → |cffffffffBroodmaster|r (+100% Schaden an Eiern, oder −75% Schaden durch Eierexplosionen) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary im Profaned Mausoleum → |cffffffffSpiritual Protection|r (geisterhafte Verbündete bei Curse Surges, oder sofort wieder aufstehen, wenn du außerhalb der Vaults stirbst).|n|cffffffffEinem Er’inye einen Schlüssel zu zeigen schaltet nichts frei.|r Er ist blind und sagt dir, was er fühlt — das ist ein Hinweis darauf, wohin der Gegenstand gehört. |cffffffffWoher die Schlüssel fallen, ist nicht geklärt|r: drei sorgfältige Lesungen derselben Datenbank ergaben drei verschiedene Antworten, also nennen wir keine. Mach Strikes und Incursions, dann tauchen sie auf.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead & die Rares",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff„The Honored Dead“ — zwölf Gedenkstätten|r auf der Vaults-Karte, ein Erfolg, und das Klarste, was man hier einfach tun kann. In einer Laufreihenfolge, von oben auf der Karte nach unten:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (unter der Brücke) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffDie Underbelly|r ist die Karte darunter, Eingang bei {WAY:2509:47.30:11.20:The Underbelly} auf der Vaults-Karte. Dort unten lebt ein Rarer, |cffffffffSzarith the Fanged|r bei {WAY:2613:38.40:17.69:Szarith the Fanged}, und die Underbelly hat einen eigenen Erfolg: |cffffffffSoft Underbelly|r.|n• |cffffffffDrei seltene Elite-Gegner auf der Hauptkarte|r — Congealed Malice, Khu'tulak und Susarikk — bilden einen dritten: |cffffffffOppose the Foes|r. |cffffffffSie haben keinen festen Ort, und das ist die Antwort, keine Lücke|r: einer der drei erwacht in dem Moment, in dem eine |cffffffffTemple Incursion|r abgeschlossen wird, und du hast etwa zehn Minuten. Du jagst sie also nicht — du beendest Incursions, und einer kommt.",
})

merge(ns._mhLocales and ns._mhLocales.frFR, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Ton manuel pour Midnight — ce qu'est chaque système, à quoi sert chaque monnaie et où cliquer dans cet addon. Survole les icônes de monnaie pour les infobulles de Blizzard.",
	CODEX_OPEN_TAB_FMT = "Ouvrir : %s",
	CODEX_NAV_DELVES_VAULT = "Onglet Delves & Vault (bloc Grande chambre forte)",
	CODEX_NAV_DELVES_MIDNIGHT = "Onglet Delves & Vault (liste des gouffres)",
	CODEX_NAV_BASICS_DAWN = "Onglet Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Onglet Basics (guide Professions)",
	CODEX_BALANCE_FMT = "Tu as : |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "Le solde se met à jour quand tu te connectes sur ce personnage.",
	CODEX_SEARCH_OPENED = "Midnight Codex ouvert.",
	CODEX_BETA_DISABLED = "Midnight Codex est désactivé dans les Réglages (onglets bêta).",

	CODEX_CAT_START = "Pour commencer",
	CODEX_CAT_WEEKLY = "Boucle hebdomadaire",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & Crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Suivre la route",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Pour commencer — ta semaine Midnight",
	CODEX_START_BODY = "|cffffcc00Pense en couches :|r un reset hebdo, plusieurs pistes de récompenses. Tu n'as pas besoin de chaque système chaque jour — choisis un objectif.|n|n|cffffff781) Compte & reset|r|n• Vérifie |cffffffffHome -> This Week|r pour la vault, le boss de monde, les keys et les corvées.|n• |cffffffffAccount snapshot|r montre tous tes rerolls (vault, Delver's Call, hebdos de métier).|n|n|cffffff782) Contenu de combat|r|n• |cffffffffDelves|r — piste d'équipement principale (keys, paliers, slots de Grande chambre forte). Utilise |cffffffffDelve Coach|r pour des conseils par gouffre.|n• |cffffffffMythic+|r et |cffffffffRaid|r remplissent les autres slots de vault (voir catégories Dungeons & Raid).|n|n|cffffff783) Monde ouvert (12.0.5)|r|n• Onglet |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (même piste de renom).|n• Onglet |cffffffffRares|r — butin rare hebdo et itinéraires.|n|n|cffffff784) Artisanat|r|n• Onglet |cffffffffProfessions|r pour les KP / mats hebdo ; |cffffffffBasics|r pour les Crests.|n|n|cffffcc00Astuce :|r ouvre la catégorie |cffffffffCurrencies|r ici quand tu oublies à quoi sert un jeton. Fais défiler l'aperçu du boss dans Delve Coach pour zoomer.",
	CODEX_WARBAND_TITLE = "Bande de guerre & sa banque",
	CODEX_WARBAND_BODY = "|cffffcc00Ta bande de guerre|r, ce sont tous les personnages de ton compte, traités comme une seule équipe. Beaucoup de choses sont désormais |cffffffffliées à la bande de guerre|r — partagées sur tout le compte — donc tu envoies bien moins de courrier entre rerolls.|n|n|cffffff78Objets & monnaies liés à la bande de guerre|r|n• La plupart des monnaies Midnight sont à l'échelle du compte.|n• L'équipement est souvent |cfffffffflié à la bande de guerre jusqu'à équipé|r — envoie-le à un reroll, mais une fois équipé il reste sur ce personnage.|n|n|cffffff78La banque de bande de guerre|r — une banque partagée par tous tes personnages.|n• Ouvre-la chez |cffffffffn'importe quel banquier|r (ou Jeeves) — c'est un onglet de ta banque normale, à côté de ta banque de personnage.|n• Stocke tout objet |cffffffffnon lié à l'âme|r, et dépose ou retire de l'|cffffffffor|r entre personnages (même inter-factions).|n• Fabrique directement depuis elle — elle compte comme source de composants.|n|n|cffffff78Onglets & coût|r — 5 onglets, 98 emplacements chacun (490 au total). Tu commences sans aucun ; achète-les avec de l'or :|n• Onglet 1 : |cffffffff1 000 po|r|n• Onglet 2 : |cffffffff25 000 po|r|n• Onglet 3 : |cffffffff100 000 po|r|n• Onglet 4 : |cffffffff500 000 po|r|n• Onglet 5 : |cffffffff2 500 000 po|r  (les cinq = 3 126 000 po)|n|n|cffffcc00Astuce :|r 2-3 onglets suffisent à la plupart des joueurs. Ne la confonds pas avec ta |cffffffffbanque de personnage|r (à onglets depuis le patch 11.2, bien moins chère) — celle-là est par personnage ; la banque de bande de guerre est partagée.",

	CODEX_WEEKLY_RESET_TITLE = "Reset hebdomadaire",
	CODEX_WEEKLY_RESET_BODY = "• La plupart des progrès hebdomadaires se réinitialisent le jour de maintenance de ta région (EU mercredi matin, US mardi matin).|n• Les choix de Grande chambre forte, le butin du boss de monde, de nombreux plafonds hebdo et les livraisons de Delver's Call se réinitialisent.|n• |cffffffffHome -> This Week|r affiche le temps avant le reset quand l'API le fournit.|n• Planifie les rerolls : l'onglet snapshot compare qui doit encore vault, boss ou Delver's Call.",

	CODEX_VAULT_TITLE = "Grande chambre forte",
	CODEX_VAULT_BODY = "• Trois pistes : |cffffffffWorld|r (gouffres + contenu de monde), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Remplis des activités pendant la semaine ; après le reset tu choisis une récompense par slot débloqué chez le PNJ de la vault ou via SHIFT-J.|n• |cffffffffVault Advisor|r (sur l'UI de vault de Blizzard) classe les options par rapport à ton équipement.|n• Cet addon montre les trois pistes dans l'onglet |cffffffffDelves & Vault|r — déploie |cffffffffWeekly Great Vault (World)|r (pas encore un onglet séparé).|n• Résumé aussi sur |cffffffffHome -> This Week|r et |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "Boss de monde (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Un boss de monde en rotation par semaine (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Butin de bande de guerre : dès qu'un personnage le tue, les rerolls apparaissent comme terminés.|n• Suivi en haut de l'onglet |cffffffffDelves & Vault|r avec itinéraire TomTom.|n• Aussi lié depuis le SMC City Guide quand tu es à Lune-d'argent.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nouveau système de puissance de milieu d'extension — un livre de minimap de |cffffffffrunes|r que tu échanges librement hors combat (aucun coût de slot).|n• La puissance vient de la chaîne hebdomadaire |cffffffff'Seeking Knowledge'|r (5 semaines) : The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Chaque semaine récompense un |cffffffffMote of Omnial Inquiry|r pour choisir/renforcer une rune.|n• Termine les 5 pour le haut fait méta et la décoration Sunstrider Omnium Simulacrum.|n• Une semaine manquée ? Fais les quêtes manquées à la suite pour rattraper — sans attendre les resets.|n• (Datamined — effets/ID exacts des runes confirmés au lancement.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Événement Marche du temps de retour — cette fois un pool de donjons |cffffffffDragonflight|r : Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Hebdo : fais |cffffffff5 donjons Marche du temps|r pour un cache d'équipement ; chaque run empile |cffffffffKnowledge of Timeways|r (buff d'XP).|n• Gagne |cffffffffMastery of Timeways|r sur 4 semaines sur 6 pour 'Master of the Turbulent Timeways' et la monture |cffffffffSpawn of Vyranoth|r.|n• Dépense les Insignes temporels chez le marchand de l'événement.|n• Du ~30 juin au 11 août. (Datamined — à confirmer au lancement.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Objectifs hebdomadaires de gouffre qui donnent un gros bonus d'XP à la remise.|n• Tu peux |cffffffffmettre en banque|r les calls terminés (objectifs faits, pas encore remis) pour un niveau de personnage ultérieur.|n• |cffffffffAccount snapshot|r cumule les calls en banque et en attente sur tous les rerolls.|n• Survole la ligne Delver's Call dans le snapshot pour le détail par personnage.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Vue en lecture seule des personnages avec lesquels tu t'es connecté avec Midnight Helper.|n• Trie/filtre par vault prête, keys, plafond de Shards of Dundun, inactif depuis le reset, etc.|n• Sert à répondre : \"Quel reroll doit encore vault / boss / Delver's Call ?\"|n• Ne remplace pas la connexion sur un reroll pour vérifier l'équipement ou les quêtes.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Ouvre les gouffres Midnight (comme les keys des extensions précédentes).|n• Se gagne via le contenu de monde, les hebdos et les marchands ; pas de plafond hebdo strict sur le nombre de keys en stock.|n• Affichée dans |cffffffffDelves & Vault|r avec ton total actuel.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Se combinent en Restored Coffer Keys (100 shards -> 1 key au taux standard).|n• Un plafond de gain hebdomadaire s'applique aux shards — suis \"Weekly: X / Y\" dans l'onglet Delves.|n• Le plafond se remplit plus vite si tu fais plus de gouffres ou complètes des sources de shards.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Monnaie de marchand pour les biens liés aux gouffres (curios, améliorations, objets de confort).|n• Se gagne surtout en faisant des gouffres et via leurs récompenses.|n• Dépense-les avant d'accumuler à l'aveugle — vérifie le marchand de gouffres quand tu as une pièce visée.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Utilisés pour certaines améliorations d'équipement Midnight / achats chez les marchands (vois les notes de patch actuelles pour les marchands exacts).|n• Se gagnent via les gouffres, le contenu de monde et les sources hebdomadaires.|n• Account snapshot peut montrer les totaux par personnage.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Monnaie partagée des systèmes |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• Plafond de gain hebdomadaire — après le plafond tu joues encore pour d'autres récompenses mais ne gagnes plus d'accolades jusqu'au reset.|n• Se dépense en récompenses de renom au hub du Bazaar (Eversong / Zul'Aman).|n• Compteur en direct dans l'onglet |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Monnaie d'artisanat de palier raid (slots raid de la Grande chambre forte, progression proche du catalyseur).|n• Les totaux de crests en direct sont sur |cffffffffBasics -> Crests|r (pas dans cette liste).|n• Pas la même chose que les keys de gouffre — vois ce guide pour les objectifs de dépense et les plafonds hebdo.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• L'équipement n'a pas qu'un niveau d'objet — il se trouve sur une |cfffffffftrack|r. Du bas vers le haut : |cffffffffAdventurer|r (vert), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Un infobulle indiquant |cffffffffHero 3/6|r signifie : track Hero, rang 3 sur 6. Chaque rang acheté ajoute du niveau d'objet.|n• La track fixe votre plafond — l'infobulle montre la plage de niveau d'objet qu'elle peut atteindre. Pour aller au-delà, il vous faut un butin d'une track supérieure.|n• Chaque track a sa propre couleur de crest. Le contenu plus difficile fait tomber de l'équipement sur une track supérieure — c'est ainsi que vous progressez.|n• Track dépassée ? Échangez les crests inférieurs chez |cffffffffVaskarn|r. Améliorez chez |cffffffffCuzoth|r à Lune-d'Argent — un rang coûte les crests de cette track plus un peu d'or.|n• Chaque track a un haut fait «…of the Dawn» : obtenez-le et toute votre |cffffffffWarband|r reçoit 50% de réduction sur les améliorations de cette track.|n• Comptes en direct et points de passage : |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Gouffres Midnight — aperçu",
	CODEX_DELVES_INTRO_BODY = "• Scénarios en solo ou petit groupe à travers Eversong, Harandar, Voidstorm, etc.|n• |cffffffffTier 1–11+|r — palier plus haut = ennemis plus durs et meilleur niveau d'objet dans la vault.|n• Coûte un |cffffffffRestored Coffer Key|r par run (voir Currencies).|n• Les gouffres |cffffffffgénéreux|r (en rotation) donnent du butin en plus — utilise \"Find Nearest Bountiful Delve\" dans l'onglet Delves.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Panneau de conseils flottant : itinéraire, trash et mécaniques de boss par gouffre.|n• S'ouvre automatiquement dans un gouffre (optionnel) ou via |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• Le texte anglais ou néerlandais suit `/mh lang`.|n• Pleins feux sur le boss : fais défiler sur le modèle pour zoomer (sauvegardé par boss).|n• Les noms de sorts en bleu renvoient aux vraies infobulles de sorts quand les ID sont connus.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & curios de gouffre",
	CODEX_DELVE_CURIOS_BODY = "• Les curios modifient ton prochain run de gouffre (butin en plus, boss plus faciles, etc.).|n• Valeera donne des conseils chez les PNJ de réparation/dialogue — popup dans l'onglet Delves quand c'est pertinent.|n• Suis les consommables et boutons de minimap via le popup d'objets de gouffre (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (gouffre Némésis)",
	CODEX_TORMENTS_BODY = "• Gouffre Némésis ultime à Voidstorm — portail d'instance séparé, pas un gouffre de monde en rotation.|n• Se débloque aux paliers de gouffre élevés avec des vies limitées (voir les prérequis en jeu).|n• Boss Nullaeus — gros check d'interruption/DPS ; vois Delve Coach pour les mécaniques.|n• La prime hebdomadaire peut attirer un Nullaeus affaibli dans un gouffre normal (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Historique des runs de gouffre récents (paliers, temps, groupe).|n• Pratique pour se souvenir de la variante terminée ou du boss actif.|n• Le routage vers le gouffre le plus proche peut t'envoyer à l'entrée la plus proche de ta position.",

	CODEX_MPLUS_TITLE = "Mythic+ & vault des donjons",
	CODEX_MPLUS_BODY = "• Les donjons M+ remplissent la rangée |cffffffffDungeons|r de la Grande chambre forte (séparée des rangées gouffre/monde).|n• Niveau de key plus haut = niveau d'objet plus haut dans le slot de vault si tu termines la key à temps.|n• Vault Advisor utilise les poids de stats M+ quand tu réclames le butin de vault de donjon.|n• Midnight Helper ne remplace pas un addon d'itinéraire — utilise MDT / des notes pour les semaines d'affixe.",

	CODEX_RAID_VAULT_TITLE = "Raid — Grande chambre forte",
	CODEX_RAID_VAULT_BODY = "• Les boss de raid font progresser les slots raid de la vault (la difficulté affecte le niveau d'objet).|n• Normal / Héroïque / Mythique contribuent chacun — vérifie l'UI de vault pour voir quels boss tu as tués cette semaine.|n• Les crests limitent souvent les chemins d'amélioration de l'équipement de raid.",

	CODEX_VAULT_ADVISOR_TITLE = "Conseiller de Grande chambre forte",
	CODEX_VAULT_ADVISOR_BODY = "• Panneau latéral sur l'UI de récompense hebdomadaire de Blizzard quand tu réclames le butin de Grande chambre forte (SHIFT-J) — pas dans les onglets de Midnight Helper.|n• Classe les pièces de vault par rapport à l'équipement porté selon les priorités de stats du guide (et Pawn en option).|n• Activable dans les réglages rapides de minimap / Échap -> AddOns -> Midnight Helper.|n• Profil Auto vs Raid vs M+ pour les poids de stats.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — un seul système",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 associe |cffffffffRitual Sites|r (Eversong) et |cffffffffVoid Assaults|r (Zul'Aman) sous une même monnaie et un même renom.|n• Mêmes |cffffffffField Accolades|r et hub du Bazaar — ne les farme pas comme des activités séparées.|n• Ouvre l'onglet combiné pour le site actif, les plafonds hebdo et les boutons TomTom.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Rituel hebdomadaire en rotation à Eversong Woods — complète les phases pour des accolades et du butin.|n• Un seul site est \"actif\" à la fois ; l'addon met en évidence lequel.|n• Le pin du SMC City Guide peut t'amener à l'onglet Ritual avec le contexte.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Vagues d'assaut à Zul'Aman — défends les objectifs, gagne des accolades.|n• Partage le plafond hebdomadaire avec la progression des rituels sur la même monnaie.|n• Vérifie le minuteur d'assaut / la zone active dans l'onglet Void & Rituals.",

	CODEX_RARES_TITLE = "Rares Midnight",
	CODEX_RARES_BODY = "• Mobs rares hebdomadaires avec butin compte/personnage (vérifie les règles de chaque rare en jeu).|n• Onglet |cffffffffRares|r : suis les kills, construis l'itinéraire le plus proche, la flèche TomTom reste sur le pin le plus proche.|n• Alerte en direct quand un rare suivi est à proximité (~500 yd) — activable dans les réglages.",

	CODEX_PROF_TITLE = "Professions — boucle hebdomadaire",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance et Shards of Dundun sont des pistes distinctes.|n• L'onglet |cffffffffProfessions|r montre les KP non dépensés et les monnaies hebdo par métier.|n• Les ordres d'artisanat et les trésors ne sont pas entièrement automatisés ici — utilise le guide Basics pour dépenser les KP.",

	CODEX_PROF_GUIDE_TITLE = "Professions — guide débutant",
	CODEX_PROF_GUIDE_BODY = "• Sous-onglet |cffffffffBasics -> Professions|r : plan de KP pas à pas et suggestions de combos.|n• Le guide Crests couvre la monnaie d'artisanat de raid (différente des keys de gouffre).|n• Relis après les patchs — les ID de monnaie et les plafonds peuvent changer.",
	CODEX_PROFRESET_TITLE = "Réinitialiser les spécialisations d’un métier (12.1)",
	CODEX_PROFRESET_BODY = "• Le patch 12.1 permet d’annuler tes choix de spécialisation Midnight — une fois par métier.|n• |cffffffffChez qui :|r Theremis, au Bazar de Lune-d’argent, à côté des commandes d’artisanat. Il propose une ligne par métier : tu peux réinitialiser le Forgeage et laisser l’Enchantement intact.|n• |cffffffffCe que tu récupères :|r chaque point de Connaissance dépensé dans les arbres Midnight de ce métier, libre de le replacer.|n• |cffffffffCe que ça coûte :|r l’avertissement du jeu dit « You will lose all associated recipes ».|n• |cffffffffAssociées, pas toutes.|r Ce qui part, c’est ce que ces spécialisations avaient débloqué. Les recettes apprises d’un maître, d’un butin ou d’une quête sont hors des arbres et restent. Observé sur un Enchantement réinitialisé : la liste de recettes était intacte et la Connaissance dépensée était revenue au compteur.|n• |cffffffffC’est une seule fois.|r La confirmation écrit ONCE en majuscules, et c’est par métier — pas de deuxième essai si la nouvelle voie te déçoit.|n• Décide donc |cffffffffavant|r de confirmer. La page Métiers indique l’arbre à remplir et le nœud exact.|n• Les recettes reprises reviennent-elles si tu redépenses à l’identique ? Le jeu ne le dit nulle part. Prévois que non.",
	CODEX_ATALUTEK_TITLE = "Les Vaults of Atal'Utek — ce qu'on y trouve, et où",
	CODEX_ATALUTEK_BODY = "• |cffffffffCe que c'est :|r une zone de la 12.1 sur la Coiled Isle avec sa propre carte, et en dessous une seconde carte, l'Underbelly. C'est déjà ouvert — aucune barrière de saison.|n• |cffffffffComment y entrer :|r une chaîne de trois quêtes — |cffffffffInto the Vaults of Atal'Utek|r, puis |cffffffffVaults of Atal'Utek: One Coin Too Many|r, puis |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Tout le reste se trouve derrière, alors fais-les d'abord.|n• |cffffffffCorrosive Coin|r est la monnaie de la zone. Selon les mots du jeu : « Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token. » Ton solde est le nombre affiché au-dessus.|n• |cffffffffCorrosive Soul, ce n'est pas ça.|r Ce n'est pas du tout une monnaie mais un |cffffffffobjet|r dans tes sacs, et c'est ce que le Corrosive Codex te demande d'offrir. Les guides intervertissent sans cesse les deux noms ; le jeu jamais. Si quelque chose te dit de dépenser des Corrosive Coins au Codex, c'est cette confusion-là.|n• |cffffffffOù vont les pièces — deux endroits, tous deux chez Er’inye|r en {WAY:2509:51.10:62.76:Er'inye}. Lui parler achète |cffffffffCorrode Spirit|r, qui alimente l’arbre de l’autel ; à côté de lui, le |cffffffffSkull of Er’inye|r est un marchand avec trois pages de montures, mascottes, ensembles et recettes, de 500 à 25 000 pièces. |cffffffffLe prix du corrode monte à chaque achat|r — vu à 1 500 puis 2 000 en une visite — lis donc la fenêtre au lieu d’économiser pour un montant.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion : les quatre clés",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffL'Altar of Corrosion|r est l'arbre de nœuds qu'ouvre la dernière quête de la chaîne. L'essentiel s'ouvre en dépensant, mais |cffffffffquatre nœuds sont derrière une clé que tu dois aller chercher|r — et les quatre fonctionnent pareil : un objet tombe, tu l'utilises sur un objet fixe quelque part dans les Vaults, ça donne un objet de quête, et Er’inye fait le reste.|n|cffffffffCorroded Key|r → le Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, ou Swift Steps) · |cffffffffSpirit Loupe|r → la Feather of Tok’jara en {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, ou Spectral Shipping) · |cffffffffExcising Knife|r → l'Eye of Szarith, dans une mare de venin de l'Underbelly → |cffffffffBroodmaster|r (+100% de dégâts aux œufs, ou −75% de dégâts des explosions d'œufs) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary dans le Profaned Mausoleum → |cffffffffSpiritual Protection|r (alliés spectraux aux Curse Surges, ou te relever aussitôt si tu meurs hors des Vaults).|n|cffffffffMontrer une clé à Er’inye ne débloque rien.|r Il est aveugle et te dit ce qu'il ressent — c'est un indice sur l'endroit où va l'objet. |cffffffffD'où tombent les clés n'est pas tranché|r : trois lectures attentives de la même base ont donné trois réponses différentes, donc on n'en désigne aucune. Fais des Strikes et des Incursions, elles finissent par tomber.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead & les rares",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff« The Honored Dead » — douze mémoriaux|r sur la carte des Vaults, un haut fait, et la chose la plus claire à aller faire ici. Dans un seul ordre de marche, du haut de la carte vers le bas :|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (sous le pont) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffL'Underbelly|r est la carte du dessous, entrée à {WAY:2509:47.30:11.20:The Underbelly} sur la carte des Vaults. Un rare y vit, |cffffffffSzarith the Fanged|r à {WAY:2613:38.40:17.69:Szarith the Fanged}, et l'Underbelly a son propre haut fait, |cffffffffSoft Underbelly|r.|n• |cffffffffTrois élites rares sur la carte principale|r — Congealed Malice, Khu'tulak et Susarikk — forment un troisième : |cffffffffOppose the Foes|r. |cffffffffIls n'ont pas de position fixe, et c'est la réponse, pas un manque|r : l'un des trois se réveille dès qu'une |cffffffffTemple Incursion|r est terminée, et tu as environ dix minutes. On ne part donc pas les chasser — on finit des Incursions, et l'un d'eux vient.",
})

merge(ns._mhLocales and ns._mhLocales.esES, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Tu manual para Midnight: qué es cada sistema, para qué sirve cada moneda y dónde hacer clic en este addon. Pasa el cursor sobre los iconos de moneda para ver las descripciones de Blizzard.",
	CODEX_OPEN_TAB_FMT = "Abrir: %s",
	CODEX_NAV_DELVES_VAULT = "Pestaña Delves & Vault (bloque de Gran Bóveda)",
	CODEX_NAV_DELVES_MIDNIGHT = "Pestaña Delves & Vault (lista de profundidades)",
	CODEX_NAV_BASICS_DAWN = "Pestaña Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Pestaña Basics (guía de Professions)",
	CODEX_BALANCE_FMT = "Tienes: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "El saldo se actualiza cuando inicias sesión con este personaje.",
	CODEX_SEARCH_OPENED = "Midnight Codex abierto.",
	CODEX_BETA_DISABLED = "Midnight Codex está desactivado en los Ajustes (pestañas beta).",

	CODEX_CAT_START = "Para empezar",
	CODEX_CAT_WEEKLY = "Ciclo semanal",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & Crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Seguir la ruta",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Para empezar — tu semana Midnight",
	CODEX_START_BODY = "|cffffcc00Piensa por capas:|r un reset semanal, varias vías de recompensa. No necesitas cada sistema cada día: elige un objetivo.|n|n|cffffff781) Cuenta y reset|r|n• Revisa |cffffffffHome -> This Week|r para la bóveda, el jefe de mundo, las keys y las tareas.|n• |cffffffffAccount snapshot|r muestra todos tus alts (bóveda, Delver's Call, semanales de profesión).|n|n|cffffff782) Contenido de combate|r|n• |cffffffffDelves|r — vía principal de equipo (keys, niveles, ranuras de Gran Bóveda). Usa |cffffffffDelve Coach|r para consejos por profundidad.|n• |cffffffffMythic+|r y |cffffffffRaid|r llenan otras ranuras de bóveda (ver categorías Dungeons & Raid).|n|n|cffffff783) Mundo abierto (12.0.5)|r|n• Pestaña |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (misma vía de renombre).|n• Pestaña |cffffffffRares|r — botín raro semanal y rutas.|n|n|cffffff784) Artesanía|r|n• Pestaña |cffffffffProfessions|r para KP / mats semanales; |cffffffffBasics|r para Crests.|n|n|cffffcc00Consejo:|r abre aquí la categoría |cffffffffCurrencies|r cuando olvides para qué sirve un vale. Desplázate por la vista previa del jefe en Delve Coach para hacer zoom.",
	CODEX_WARBAND_TITLE = "Banda de guerra y su banco",
	CODEX_WARBAND_BODY = "|cffffcc00Tu banda de guerra|r son todos los personajes de tu cuenta, tratados como un equipo. Muchas cosas ahora están |cffffffffvinculadas a la banda de guerra|r — compartidas en toda la cuenta — así que envías mucho menos correo entre alts.|n|n|cffffff78Objetos y monedas vinculados a la banda de guerra|r|n• La mayoría de las monedas de Midnight son de cuenta.|n• El equipo suele estar |cffffffffvinculado a la banda de guerra hasta equipar|r — envíalo a un alt, pero una vez equipado queda con ese personaje.|n|n|cffffff78El banco de banda de guerra|r — un banco compartido que usan todos tus personajes.|n• Ábrelo con |cffffffffcualquier banquero|r (o Jeeves) — es una pestaña de tu banco normal, junto a tu banco de personaje.|n• Guarda cualquier objeto |cffffffffno ligado al alma|r, y deposita o retira |cfffffffforo|r entre personajes (incluso entre facciones).|n• Fabrica directamente desde él — cuenta como fuente de componentes.|n|n|cffffff78Pestañas y coste|r — 5 pestañas, 98 espacios cada una (490 en total). Empiezas sin ninguna; cómpralas con oro:|n• Pestaña 1: |cffffffff1.000o|r|n• Pestaña 2: |cffffffff25.000o|r|n• Pestaña 3: |cffffffff100.000o|r|n• Pestaña 4: |cffffffff500.000o|r|n• Pestaña 5: |cffffffff2.500.000o|r  (las cinco = 3.126.000o)|n|n|cffffcc00Consejo:|r 2-3 pestañas bastan para la mayoría. No lo confundas con tu |cffffffffbanco de personaje|r (también con pestañas desde el parche 11.2, mucho más barato) — ese es por personaje; el banco de banda de guerra es compartido.",

	CODEX_WEEKLY_RESET_TITLE = "Reset semanal",
	CODEX_WEEKLY_RESET_BODY = "• La mayoría del progreso semanal se reinicia el día de mantenimiento de tu región (EU miércoles por la mañana, US martes por la mañana).|n• Se reinician las elecciones de Gran Bóveda, el botín del jefe de mundo, muchos límites semanales y las entregas de Delver's Call.|n• |cffffffffHome -> This Week|r muestra el tiempo hasta el reset cuando la API lo da.|n• Planifica los alts: la pestaña snapshot compara quién debe aún bóveda, jefe o Delver's Call.",

	CODEX_VAULT_TITLE = "Gran Bóveda",
	CODEX_VAULT_BODY = "• Tres vías: |cffffffffWorld|r (profundidades + contenido de mundo), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Rellena actividades durante la semana; tras el reset eliges una recompensa por cada ranura desbloqueada en el PNJ de la bóveda o con SHIFT-J.|n• |cffffffffVault Advisor|r (en la UI de bóveda de Blizzard) clasifica las opciones frente a tu equipo.|n• Este addon muestra las tres vías en la pestaña |cffffffffDelves & Vault|r — despliega |cffffffffWeekly Great Vault (World)|r (aún no es una pestaña aparte).|n• Resumen también en |cffffffffHome -> This Week|r y |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "Jefe de mundo (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Un jefe de mundo rotatorio por semana (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Botín de banda de guerra: en cuanto un personaje lo mata, los alts aparecen como completados.|n• Seguido arriba en |cffffffffDelves & Vault|r con ruta TomTom.|n• También enlazado desde el SMC City Guide cuando estás en Lunargenta.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Nuevo sistema de poder de media expansión — un libro de minimapa de |cffffffffrunas|r que cambias libremente fuera de combate (sin coste de ranura).|n• El poder viene de la cadena semanal |cffffffff'Seeking Knowledge'|r (5 semanas): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Cada semana recompensa un |cffffffffMote of Omnial Inquiry|r para elegir/potenciar una runa.|n• Termina las 5 para el logro meta y la decoración Sunstrider Omnium Simulacrum.|n• ¿Te saltaste una semana? Haz las misiones perdidas seguidas para ponerte al día — sin esperar resets.|n• (Datamined — efectos/ID exactos de runas confirmados en el lanzamiento.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Evento Paseo en el tiempo de vuelta — esta vez un grupo de mazmorras de |cffffffffDragonflight|r: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Semanal: haz |cffffffff5 mazmorras de Paseo en el tiempo|r para un alijo de equipo; cada run acumula |cffffffffKnowledge of Timeways|r (buff de XP).|n• Gana |cffffffffMastery of Timeways|r en 4 de 6 semanas para 'Master of the Turbulent Timeways' y la montura |cffffffffSpawn of Vyranoth|r.|n• Gasta las Insignias temporales en el vendedor del evento.|n• Dura ~30 jun – 11 ago. (Datamined — confirmar en el lanzamiento.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Objetivos semanales de profundidad que dan un gran impulso de XP al entregarlos.|n• Puedes |cffffffffguardar|r calls completadas (objetivos hechos, sin entregar aún) para un nivel de personaje posterior.|n• |cffffffffAccount snapshot|r suma las calls guardadas y pendientes de todos los alts.|n• Pasa el cursor por la línea Delver's Call en el snapshot para el detalle por personaje.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Vista de solo lectura de los personajes con los que has iniciado sesión con Midnight Helper.|n• Ordena/filtra por bóveda lista, keys, límite de Shards of Dundun, inactivo desde el reset, etc.|n• Sirve para responder: \"¿Qué alt necesita aún bóveda / jefe / Delver's Call?\"|n• No sustituye iniciar sesión en un alt para comprobar equipo o misiones.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Abre las profundidades Midnight (como las keys de expansiones anteriores).|n• Se gana con contenido de mundo, semanales y vendedores; sin límite semanal estricto de keys en posesión.|n• Se muestra en |cffffffffDelves & Vault|r con tu cantidad actual.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Se combinan en Restored Coffer Keys (100 shards -> 1 key al ritmo estándar).|n• Hay un límite semanal de ganancia de shards — sigue \"Weekly: X / Y\" en la pestaña Delves.|n• El límite se llena más rápido si haces más profundidades o completas fuentes de shards.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Moneda de vendedor para bienes relacionados con profundidades (curios, mejoras, objetos de comodidad).|n• Se gana sobre todo haciendo profundidades y de sus recompensas.|n• Gástala antes de acumular a ciegas — revisa el vendedor de profundidades cuando tengas una pieza objetivo.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Se usan para ciertas mejoras de equipo Midnight / compras a vendedores (revisa las notas del parche actuales para los vendedores exactos).|n• Se ganan en profundidades, contenido de mundo y fuentes semanales.|n• Account snapshot puede mostrar los totales por personaje.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Moneda compartida de los sistemas |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• Límite semanal de ganancia — tras el límite sigues jugando por otras recompensas pero dejas de ganar accolades hasta el reset.|n• Se gasta en recompensas de renombre en el hub del Bazaar (Eversong / Zul'Aman).|n• Recuento en vivo en la pestaña |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Moneda de artesanía de nivel de raid (ranuras de raid de la Gran Bóveda, progresión cercana al catalizador).|n• Los recuentos de crests en vivo están en |cffffffffBasics -> Crests|r (no en esta lista).|n• No es lo mismo que las keys de profundidad — mira esa guía para objetivos de gasto y límites semanales.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• El equipo no solo tiene un nivel de objeto — está en una |cfffffffftrack|r. De menor a mayor: |cffffffffAdventurer|r (verde), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Un tooltip que dice |cffffffffHero 3/6|r significa: track Hero, rango 3 de 6. Cada rango que compras añade nivel de objeto.|n• La track fija tu techo — el tooltip muestra el rango de nivel de objeto que puede alcanzar. Para superarlo necesitas un botín de una track superior.|n• Cada track tiene su propio color de crest. El contenido más difícil suelta equipo en una track superior — así es como subes.|n• ¿Track superada? Cambia los crests inferiores con |cffffffffVaskarn|r. Mejora con |cffffffffCuzoth|r en Ciudad de Lunargenta — un rango cuesta los crests de esa track más un poco de oro.|n• Cada track tiene un logro «…of the Dawn»: consiéguelo y toda tu |cffffffffWarband|r obtiene un 50% de descuento en las mejoras de esa track.|n• Recuentos en vivo y puntos de ruta: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Profundidades Midnight — resumen",
	CODEX_DELVES_INTRO_BODY = "• Escenarios en solitario o en grupo pequeño por Eversong, Harandar, Voidstorm, etc.|n• |cffffffffTier 1–11+|r — nivel más alto = enemigos más duros y mejor nivel de objeto en la bóveda.|n• Cuesta una |cffffffffRestored Coffer Key|r por run (ver Currencies).|n• Las profundidades |cffffffffpródigas|r (rotatorias) dan botín extra — usa \"Find Nearest Bountiful Delve\" en la pestaña Delves.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Panel de consejos flotante: ruta, basura y mecánicas de jefe por profundidad.|n• Se abre automáticamente en una profundidad (opcional) o con |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• El texto en inglés o neerlandés sigue `/mh lang`.|n• Foco del jefe: desplázate sobre el modelo para hacer zoom (guardado por jefe).|n• Los nombres de hechizos en azul enlazan a descripciones reales cuando se conocen los ID.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera y curios de profundidad",
	CODEX_DELVE_CURIOS_BODY = "• Los curios modifican tu próxima run de profundidad (botín extra, jefes más fáciles, etc.).|n• Valeera aconseja en PNJ de reparación/diálogo — popup en la pestaña Delves cuando es relevante.|n• Sigue consumibles y botones de minimapa con el popup de objetos de profundidad (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (profundidad Némesis)",
	CODEX_TORMENTS_BODY = "• Profundidad Némesis cumbre en Voidstorm — portal de instancia aparte, no una profundidad de mundo rotatoria.|n• Se desbloquea en niveles de profundidad altos con vidas limitadas (ver requisitos en el juego).|n• Jefe Nullaeus — fuerte prueba de interrupción/DPS; mira Delve Coach para las mecánicas.|n• La recompensa semanal puede atraer a un Nullaeus debilitado a una profundidad normal (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Historial de runs de profundidad recientes (niveles, tiempos, grupo).|n• Útil para recordar qué variante terminaste o qué jefe estaba activo.|n• El enrutado a la profundidad más cercana puede llevarte a la entrada más próxima a tu posición.",

	CODEX_MPLUS_TITLE = "Mythic+ y bóveda de mazmorras",
	CODEX_MPLUS_BODY = "• Las mazmorras M+ llenan la fila |cffffffffDungeons|r de la Gran Bóveda (separada de las filas de profundidad/mundo).|n• Nivel de key más alto = nivel de objeto más alto en la ranura de bóveda si terminas la key a tiempo.|n• Vault Advisor usa los pesos de estadística M+ cuando reclamas el botín de bóveda de mazmorra.|n• Midnight Helper no sustituye un addon de ruta — usa MDT / notas para las semanas de afijo.",

	CODEX_RAID_VAULT_TITLE = "Raid — Gran Bóveda",
	CODEX_RAID_VAULT_BODY = "• Los jefes de raid avanzan las ranuras de raid de la bóveda (la dificultad afecta el nivel de objeto).|n• Normal / Heroico / Mítico aportan cada uno — revisa la UI de bóveda para ver qué jefes mataste esta semana.|n• Los crests suelen limitar las vías de mejora del equipo de raid.",

	CODEX_VAULT_ADVISOR_TITLE = "Consejero de Gran Bóveda",
	CODEX_VAULT_ADVISOR_BODY = "• Panel lateral en la UI de recompensa semanal de Blizzard cuando reclamas el botín de Gran Bóveda (SHIFT-J) — no dentro de las pestañas de Midnight Helper.|n• Clasifica las piezas de bóveda frente al equipo puesto usando las prioridades de estadística de la guía (y Pawn opcional).|n• Se activa en los ajustes rápidos de minimapa / Esc -> AddOns -> Midnight Helper.|n• Perfil Auto vs Raid vs M+ para los pesos de estadística.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — un solo sistema",
	CODEX_WORLD_HUB_BODY = "• Midnight 12.0.5 une |cffffffffRitual Sites|r (Eversong) y |cffffffffVoid Assaults|r (Zul'Aman) bajo una misma moneda y renombre.|n• Mismas |cffffffffField Accolades|r y hub del Bazaar — no las farmees como actividades separadas.|n• Abre la pestaña combinada para el sitio activo, los límites semanales y los botones TomTom.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Ritual semanal rotatorio en Eversong Woods — completa fases para accolades y botín.|n• Solo un sitio está \"activo\" a la vez; el addon resalta cuál.|n• El pin del SMC City Guide puede llevarte a la pestaña Ritual con contexto.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Oleadas de asalto en Zul'Aman — defiende objetivos, gana accolades.|n• Comparte el límite semanal con el progreso de los rituales en la misma moneda.|n• Revisa el temporizador de asalto / la zona activa en la pestaña Void & Rituals.",

	CODEX_RARES_TITLE = "Rares Midnight",
	CODEX_RARES_BODY = "• Mobs raros semanales con botín de cuenta/personaje (revisa las reglas de cada raro en el juego).|n• Pestaña |cffffffffRares|r: sigue los kills, construye la ruta más cercana, la flecha TomTom se queda en el pin más próximo.|n• Alerta en vivo cuando un raro seguido está cerca (~500 yd) — se activa en los ajustes.",

	CODEX_PROF_TITLE = "Professions — ciclo semanal",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance y Shards of Dundun son vías separadas.|n• La pestaña |cffffffffProfessions|r muestra los KP sin gastar y las monedas semanales por profesión.|n• Las órdenes de artesanía y los tesoros no están del todo automatizados aquí — usa la guía Basics para gastar KP.",

	CODEX_PROF_GUIDE_TITLE = "Professions — guía para principiantes",
	CODEX_PROF_GUIDE_BODY = "• Subpestaña |cffffffffBasics -> Professions|r: plan de KP paso a paso y sugerencias de combos.|n• La guía Crests cubre la moneda de artesanía de raid (distinta de las keys de profundidad).|n• Relee tras los parches — los ID de moneda y los límites pueden cambiar.",
	CODEX_PROFRESET_TITLE = "Reiniciar las especializaciones de una profesión (12.1)",
	CODEX_PROFRESET_BODY = "• El parche 12.1 permite deshacer tus elecciones de especialización Midnight — una vez por profesión.|n• |cffffffffCon quién:|r Theremis, en el Bazar de Ciudad Lunargenta junto a los encargos de artesanía. Ofrece una línea por profesión, así que puedes reiniciar Herrería y dejar Encantamiento intacto.|n• |cffffffffQué recuperas:|r cada punto de Conocimiento gastado en los árboles Midnight de esa profesión, libre para repartir de nuevo.|n• |cffffffffQué cuesta:|r el aviso del juego dice “You will lose all associated recipes”.|n• |cffffffffAsociadas, no todas.|r Lo que se pierde es lo que esas especializaciones habían desbloqueado. Las recetas de un maestro, de un botín o de una misión están fuera de los árboles y se quedan. Visto en un Encantamiento reiniciado: la lista de recetas estaba intacta y el Conocimiento gastado había vuelto al contador.|n• |cffffffffEs una sola vez.|r La confirmación escribe ONCE en mayúsculas, y es por profesión — no hay segundo intento si el nuevo camino decepciona.|n• Decide |cffffffffantes|r de confirmar. La página de Profesiones nombra el árbol a llenar y el nodo exacto.|n• ¿Vuelven las recetas retiradas si repartes igual que antes? El juego no lo dice en ninguna parte. Cuenta con que no.",
	CODEX_ATALUTEK_TITLE = "Las Vaults of Atal'Utek — qué hay dentro y dónde",
	CODEX_ATALUTEK_BODY = "• |cffffffffQué es:|r una zona de la 12.1 en la Coiled Isle con mapa propio, y debajo un segundo mapa, la Underbelly. Ya está abierta — no hay puerta de temporada.|n• |cffffffffCómo entrar:|r una cadena de tres misiones — |cffffffffInto the Vaults of Atal'Utek|r, luego |cffffffffVaults of Atal'Utek: One Coin Too Many|r, luego |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Todo lo demás está detrás de ellas, así que hazlas primero.|n• |cffffffffCorrosive Coin|r es la moneda de la zona. En palabras del propio juego: “Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.” Tu saldo es el número que aparece arriba.|n• |cffffffffCorrosive Soul no es eso.|r No es una moneda en absoluto, sino un |cffffffffobjeto|r en tus bolsas, y es lo que el Corrosive Codex te pide ofrecer. Las guías intercambian los dos nombres continuamente; el juego nunca. Si algo te dice que gastes Corrosive Coins en el Codex, esa es la confusión.|n• |cffffffffAdónde van las monedas — dos sitios, ambos en Er’inye|r en {WAY:2509:51.10:62.76:Er'inye}. Hablar con él compra |cffffffffCorrode Spirit|r, que alimenta el árbol del altar; a su lado, la |cffffffffSkull of Er’inye|r es un mercader con tres páginas de monturas, mascotas, conjuntos y recetas, de 500 a 25.000 monedas. |cffffffffEl precio del corrode sube cada vez que lo compras|r — visto a 1.500 y luego 2.000 en una visita — así que lee la ventana en vez de ahorrar para una cifra.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: las cuatro llaves",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffEl Altar of Corrosion|r es el árbol de nodos que abre la última misión de la cadena. La mayoría se abre al gastar, pero |cffffffffcuatro nodos están detrás de una llave que tienes que ir a buscar|r — y los cuatro funcionan igual: cae un objeto, lo usas sobre un objeto fijo en algún punto de las Vaults, eso da un objeto de misión, y Er’inye hace el resto.|n|cffffffffCorroded Key|r → el Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, o Swift Steps) · |cffffffffSpirit Loupe|r → la Feather of Tok’jara en {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, o Spectral Shipping) · |cffffffffExcising Knife|r → el Eye of Szarith, en una charca de veneno de la Underbelly → |cffffffffBroodmaster|r (+100% de daño a los huevos, o −75% de daño de sus estallidos) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary en el Profaned Mausoleum → |cffffffffSpiritual Protection|r (aliados fantasmales en los Curse Surges, o levantarte al instante si mueres fuera de las Vaults).|n|cffffffffEnseñarle una llave a Er’inye no desbloquea nada.|r Es ciego y te cuenta lo que siente — eso es una pista de dónde va el objeto. |cffffffffDe dónde caen las llaves no está resuelto|r: tres lecturas cuidadosas de la misma base de datos dieron tres respuestas distintas, así que no señalamos ninguna. Haz Strikes e Incursions y acaban apareciendo.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead y los raros",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff“The Honored Dead” — doce memoriales|r en el mapa de las Vaults, un logro, y lo más claro que puedes ir a hacer aquí. En un solo orden de recorrido, de arriba del mapa hacia abajo:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (bajo el puente) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffLa Underbelly|r es el mapa de abajo, se entra en {WAY:2509:47.30:11.20:The Underbelly} del mapa de las Vaults. Allí vive un raro, |cffffffffSzarith the Fanged|r en {WAY:2613:38.40:17.69:Szarith the Fanged}, y la Underbelly tiene un logro propio: |cffffffffSoft Underbelly|r.|n• |cffffffffTres élites raros en el mapa principal|r — Congealed Malice, Khu'tulak y Susarikk — forman un tercero: |cffffffffOppose the Foes|r. |cffffffffNo tienen un sitio fijo, y esa es la respuesta, no un hueco|r: uno de los tres despierta en cuanto se completa una |cffffffffTemple Incursion|r, y tienes unos diez minutos. Así que no sales a cazarlos — terminas Incursions, y uno viene a ti.",
})

merge(ns._mhLocales and ns._mhLocales.ptBR, {
	TAB_CODEX = "Midnight Codex",
	CODEX_PANEL_TITLE = "Midnight Codex",
	CODEX_PANEL_INTRO = "Seu manual para Midnight — o que é cada sistema, para que serve cada moeda e onde clicar neste addon. Passe o cursor sobre os ícones de moeda para ver as dicas da Blizzard.",
	CODEX_OPEN_TAB_FMT = "Abrir: %s",
	CODEX_NAV_DELVES_VAULT = "Aba Delves & Vault (bloco da Grande Câmara)",
	CODEX_NAV_DELVES_MIDNIGHT = "Aba Delves & Vault (lista de profundezas)",
	CODEX_NAV_BASICS_DAWN = "Aba Basics (Crests)",
	CODEX_NAV_BASICS_PROF = "Aba Basics (guia de Professions)",
	CODEX_BALANCE_FMT = "Você tem: |cffffffff%d|r",
	CODEX_BALANCE_UNKNOWN = "O saldo atualiza quando você entra com este personagem.",
	CODEX_SEARCH_OPENED = "Midnight Codex aberto.",
	CODEX_BETA_DISABLED = "O Midnight Codex está desativado nas Configurações (abas beta).",

	CODEX_CAT_START = "Comece aqui",
	CODEX_CAT_WEEKLY = "Ciclo semanal",
	CODEX_CAT_CURRENCIES = "Currencies",
	CODEX_CAT_DELVES = "Delves",
	CODEX_CAT_DUNGEONS = "Dungeons & M+",
	CODEX_CAT_RAID = "Raid & Crests",
	CODEX_CAT_WORLD = "Void & Rituals",
	CODEX_CAT_COILEDISLE = "Coiled Isle",
	CODEX_ROUTE_BTN = "Seguir a rota",
	CODEX_CAT_PROFESSIONS = "Professions",

	CODEX_START_TITLE = "Comece aqui — sua semana Midnight",
	CODEX_START_BODY = "|cffffcc00Pense em camadas:|r um reset semanal, várias trilhas de recompensa. Você não precisa de cada sistema todo dia — escolha um objetivo.|n|n|cffffff781) Conta & reset|r|n• Confira |cffffffffHome -> This Week|r para a câmara, o chefe de mundo, as keys e as tarefas.|n• |cffffffffAccount snapshot|r mostra todos os seus alts (câmara, Delver's Call, semanais de profissão).|n|n|cffffff782) Conteúdo de combate|r|n• |cffffffffDelves|r — trilha principal de equipamento (keys, níveis, espaços da Grande Câmara). Use |cffffffffDelve Coach|r para dicas por profundeza.|n• |cffffffffMythic+|r e |cffffffffRaid|r preenchem outros espaços da câmara (veja categorias Dungeons & Raid).|n|n|cffffff783) Mundo aberto (12.0.5)|r|n• Aba |cffffffffVoid & Rituals|r — Field Accolades, Ritual Sites, Void Assaults (mesma trilha de renome).|n• Aba |cffffffffRares|r — saque raro semanal e rotas.|n|n|cffffff784) Profissões|r|n• Aba |cffffffffProfessions|r para KP / mats semanais; |cffffffffBasics|r para Crests.|n|n|cffffcc00Dica:|r abra a categoria |cffffffffCurrencies|r aqui quando esquecer para que serve uma ficha. Role a prévia do chefe no Delve Coach para dar zoom.",
	CODEX_WARBAND_TITLE = "Bando de guerra & seu banco",
	CODEX_WARBAND_BODY = "|cffffcc00Seu bando de guerra|r são todos os personagens da sua conta, tratados como um time. Muita coisa agora é |cffffffffvinculada ao bando de guerra|r — compartilhada na conta toda — então você envia bem menos correio entre alts.|n|n|cffffff78Itens & moedas vinculados ao bando de guerra|r|n• A maioria das moedas de Midnight é da conta.|n• O equipamento costuma ser |cffffffffvinculado ao bando de guerra até equipar|r — mande para um alt, mas uma vez equipado fica com aquele personagem.|n|n|cffffff78O banco do bando de guerra|r — um banco compartilhado que todos os seus personagens usam.|n• Abra com |cffffffffqualquer banqueiro|r (ou Jeeves) — é uma aba do seu banco normal, ao lado do banco de personagem.|n• Guarde qualquer item |cffffffffnão vinculado à alma|r e deposite ou retire |cffffffffouro|r entre personagens (até entre facções).|n• Fabrique direto dele — conta como fonte de reagentes.|n|n|cffffff78Abas & custo|r — 5 abas, 98 espaços cada (490 no total). Você começa sem nenhuma; compre-as com ouro:|n• Aba 1: |cffffffff1.000o|r|n• Aba 2: |cffffffff25.000o|r|n• Aba 3: |cffffffff100.000o|r|n• Aba 4: |cffffffff500.000o|r|n• Aba 5: |cffffffff2.500.000o|r  (as cinco = 3.126.000o)|n|n|cffffcc00Dica:|r 2-3 abas bastam para a maioria. Não confunda com seu |cffffffffbanco de personagem|r (também com abas desde o patch 11.2, bem mais barato) — esse é por personagem; o banco do bando de guerra é compartilhado.",

	CODEX_WEEKLY_RESET_TITLE = "Reset semanal",
	CODEX_WEEKLY_RESET_BODY = "• A maior parte do progresso semanal reinicia no dia de manutenção da sua região (EU quarta de manhã, US terça de manhã).|n• As escolhas da Grande Câmara, o saque do chefe de mundo, muitos limites semanais e as entregas da Delver's Call reiniciam.|n• |cffffffffHome -> This Week|r mostra o tempo até o reset quando a API fornece.|n• Planeje os alts: a aba snapshot compara quem ainda deve câmara, chefe ou Delver's Call.",

	CODEX_VAULT_TITLE = "Grande Câmara",
	CODEX_VAULT_BODY = "• Três trilhas: |cffffffffWorld|r (profundezas + conteúdo de mundo), |cffffffffDungeons|r (M+), |cffffffffRaid|r.|n• Preencha atividades durante a semana; após o reset você escolhe uma recompensa por espaço desbloqueado no NPC da câmara ou via SHIFT-J.|n• |cffffffffVault Advisor|r (na UI de câmara da Blizzard) classifica as opções contra seu equipamento.|n• Este addon mostra as três trilhas na aba |cffffffffDelves & Vault|r — expanda |cffffffffWeekly Great Vault (World)|r (ainda não é uma aba separada).|n• Resumo também em |cffffffffHome -> This Week|r e |cffffffffAccount snapshot|r.",

	CODEX_WORLDBOSS_TITLE = "Chefe de mundo (Midnight S1)",
	CODEX_WORLDBOSS_BODY = "• Um chefe de mundo rotativo por semana (Lu'ashal, Cragpine, Thorm'belan, Predaxas).|n• Saque de bando de guerra: assim que um personagem o mata, os alts aparecem como concluídos.|n• Acompanhado no topo da aba |cffffffffDelves & Vault|r com rota TomTom.|n• Também vinculado pelo SMC City Guide quando você está em Lunargente.",
	CODEX_FOLIO_TITLE = "Omnium Folio (12.0.7)",
	CODEX_FOLIO_BODY = "• Novo sistema de poder de meio de expansão — um livro de minimapa de |cffffffffrunas|r que você troca livremente fora de combate (sem custo de espaço).|n• O poder vem da cadeia semanal |cffffffff'Seeking Knowledge'|r (5 semanas): The Omnium Folio, Ritualized Arcana, Leyline Assaults, Magical Primessence, Off-World Magic.|n• Cada semana recompensa um |cffffffffMote of Omnial Inquiry|r para escolher/fortalecer uma runa.|n• Conclua as 5 para a conquista meta e a decoração Sunstrider Omnium Simulacrum.|n• Perdeu uma semana? Faça as missões perdidas em sequência para recuperar — sem esperar resets.|n• (Datamined — efeitos/IDs exatos das runas confirmados no lançamento.)",
	CODEX_TT_TITLE = "Turbulent Timeways (12.0.7)",
	CODEX_TT_BODY = "• Evento Caminhada Temporal de volta — desta vez um grupo de masmorras de |cffffffffDragonflight|r: Algeth'ar Academy, Halls of Infusion, Neltharus, Ruby Life Pools, The Azure Vault, Brackenhide Hollow.|n• Semanal: faça |cffffffff5 masmorras de Caminhada Temporal|r por um cache de equipamento; cada run acumula |cffffffffKnowledge of Timeways|r (buff de XP).|n• Ganhe |cffffffffMastery of Timeways|r em 4 de 6 semanas para 'Master of the Turbulent Timeways' e a montaria |cffffffffSpawn of Vyranoth|r.|n• Gaste os Distintivos Temporais no vendedor do evento.|n• Vai de ~30 jun a 11 ago. (Datamined — confirmar no lançamento.)",

	CODEX_DELVER_CALL_TITLE = "Delver's Call",
	CODEX_DELVER_CALL_BODY = "• Objetivos semanais de profundeza que dão um grande impulso de XP ao entregar.|n• Você pode |cffffffffguardar no banco|r calls concluídas (objetivos feitos, ainda não entregues) para um nível de personagem posterior.|n• |cffffffffAccount snapshot|r soma as calls guardadas e pendentes entre os alts.|n• Passe o cursor sobre a linha Delver's Call no snapshot para o detalhe por personagem.",

	CODEX_ACCOUNT_TITLE = "Account snapshot",
	CODEX_ACCOUNT_BODY = "• Visão somente leitura dos personagens com que você entrou usando o Midnight Helper.|n• Ordene/filtre por câmara pronta, keys, limite de Shards of Dundun, inativo desde o reset, etc.|n• Serve para responder: \"Qual alt ainda precisa de câmara / chefe / Delver's Call?\"|n• Não substitui entrar em um alt para conferir equipamento ou missões.",

	CODEX_CUR_COFFER_KEY_TITLE = "Restored Coffer Key",
	CODEX_CUR_COFFER_KEY_BODY = "• Abre as profundezas Midnight (como as keys de expansões anteriores).|n• Ganhe com conteúdo de mundo, semanais e vendedores; sem limite semanal rígido de keys em posse.|n• Mostrada em |cffffffffDelves & Vault|r com sua contagem atual.",

	CODEX_CUR_SHARDS_TITLE = "Coffer Key Shards",
	CODEX_CUR_SHARDS_BODY = "• Combinam-se em Restored Coffer Keys (100 shards -> 1 key na taxa padrão).|n• Há um limite semanal de ganho de shards — acompanhe \"Weekly: X / Y\" na aba Delves.|n• O limite enche mais rápido se você fizer mais profundezas ou completar fontes de shards.",

	CODEX_CUR_UNDERCOIN_TITLE = "Undercoin",
	CODEX_CUR_UNDERCOIN_BODY = "• Moeda de vendedor para itens ligados a profundezas (curios, melhorias, itens de conveniência).|n• Ganha-se principalmente fazendo profundezas e com suas recompensas.|n• Gaste antes de acumular às cegas — confira o vendedor de profundezas quando tiver uma peça-alvo.",

	CODEX_CUR_MANA_TITLE = "Untainted Mana-Crystals",
	CODEX_CUR_MANA_BODY = "• Usados para certas melhorias de equipamento Midnight / compras com vendedores (veja as notas de patch atuais para os vendedores exatos).|n• Ganhos em profundezas, conteúdo de mundo e fontes semanais.|n• O Account snapshot pode mostrar os totais por personagem.",

	CODEX_CUR_ACCOLADES_TITLE = "Field Accolades",
	CODEX_CUR_ACCOLADES_BODY = "• Moeda compartilhada dos sistemas |cffffffffVoid & Rituals|r (Ritual Sites + Void Assaults).|n• Limite semanal de ganho — após o limite você continua jogando por outras recompensas mas para de ganhar accolades até o reset.|n• Gasta-se em recompensas de renome no hub do Bazaar (Eversong / Zul'Aman).|n• Contagem ao vivo na aba |cffffffffVoid & Rituals|r.",

	CODEX_CUR_DAWN_TITLE = "Crests",
	CODEX_CUR_DAWN_BODY = "• Moeda de fabricação de nível de raid (espaços de raid da Grande Câmara, progressão próxima do catalisador).|n• As contagens de crests ao vivo estão em |cffffffffBasics -> Crests|r (não nesta lista).|n• Não é o mesmo que keys de profundeza — veja aquele guia para metas de gasto e limites semanais.",
	CODEX_TRACKS_TITLE = "Gear upgrade tracks",
	CODEX_TRACKS_BODY = "• O equipamento não tem apenas um nível de item — ele está em uma |cfffffffftrack|r. De baixo para cima: |cffffffffAdventurer|r (verde), |cffffffffVeteran|r, |cffffffffChampion|r, |cffffffffHero|r, |cffffffffMyth|r.|n• Um tooltip com |cffffffffHero 3/6|r significa: track Hero, rank 3 de 6. Cada rank que você compra adiciona nível de item.|n• A track define seu teto — o tooltip mostra a faixa de nível de item que ela alcança. Para passar disso você precisa de um drop de uma track superior.|n• Cada track tem sua própria cor de crest. Conteúdo mais difícil solta equipamento em uma track superior — é assim que você sobe.|n• Superou a track? Troque crests inferiores com |cffffffffVaskarn|r. Melhore com |cffffffffCuzoth|r em Luaprata — um rank custa os crests dessa track mais um pouco de ouro.|n• Cada track tem uma conquista «…of the Dawn»: obtenha-a e toda a sua |cffffffffWarband|r ganha 50% de desconto nas melhorias dessa track.|n• Contagens ao vivo e pontos de rota: |cffffffffBasics -> Crests|r.",

	CODEX_DELVES_INTRO_TITLE = "Profundezas Midnight — visão geral",
	CODEX_DELVES_INTRO_BODY = "• Cenários solo ou em grupo pequeno por Eversong, Harandar, Voidstorm, etc.|n• |cffffffffTier 1–11+|r — nível mais alto = inimigos mais difíceis e melhor nível de item na câmara.|n• Custa uma |cffffffffRestored Coffer Key|r por run (veja Currencies).|n• Profundezas |cfffffffffartas|r (rotativas) dão saque extra — use \"Find Nearest Bountiful Delve\" na aba Delves.",

	CODEX_DELVE_COACH_TITLE = "Delve Coach",
	CODEX_DELVE_COACH_BODY = "• Painel de dicas flutuante: rota, trash e mecânicas de chefe por profundeza.|n• Abre automaticamente em uma profundeza (opcional) ou via |cffffffffDelve Coach (preview tips)|r / |cffffffff/mh coach|r.|n• O texto em inglês ou neerlandês segue `/mh lang`.|n• Destaque do chefe: role no modelo para dar zoom (salvo por chefe).|n• Nomes de magias em azul levam às dicas reais de magia quando os IDs são conhecidos.",

	CODEX_DELVE_CURIOS_TITLE = "Valeera & curios de profundeza",
	CODEX_DELVE_CURIOS_BODY = "• Curios modificam sua próxima run de profundeza (saque extra, chefes mais fáceis, etc.).|n• Valeera dá conselhos em NPCs de reparo/diálogo — popup na aba Delves quando relevante.|n• Acompanhe consumíveis e botões de minimapa pelo popup de itens de profundeza (RAID-R Mini, Trovehunter's Bounty).",

	CODEX_TORMENTS_TITLE = "Torment's Rise (profundeza Nêmesis)",
	CODEX_TORMENTS_BODY = "• Profundeza Nêmesis suprema em Voidstorm — portal de instância separado, não uma profundeza de mundo rotativa.|n• Desbloqueia em níveis de profundeza altos com vidas limitadas (veja os requisitos no jogo).|n• Chefe Nullaeus — forte teste de interrupção/DPS; veja Delve Coach para as mecânicas.|n• A recompensa semanal pode atrair um Nullaeus enfraquecido para uma profundeza normal (Beacon of Hope).",

	CODEX_DELVE_LOG_TITLE = "Delve Log",
	CODEX_DELVE_LOG_BODY = "• Histórico de runs de profundeza recentes (níveis, tempos, grupo).|n• Útil para lembrar qual variante você terminou ou qual chefe estava ativo.|n• O roteamento para a profundeza mais próxima pode te enviar à entrada mais próxima da sua posição.",

	CODEX_MPLUS_TITLE = "Mythic+ & câmara de masmorras",
	CODEX_MPLUS_BODY = "• Masmorras M+ preenchem a fileira |cffffffffDungeons|r da Grande Câmara (separada das fileiras de profundeza/mundo).|n• Nível de key mais alto = nível de item mais alto no espaço da câmara se você terminar a key no tempo.|n• O Vault Advisor usa os pesos de atributo M+ quando você reivindica o saque de câmara de masmorra.|n• O Midnight Helper não substitui um addon de rota — use MDT / notas para semanas de afixo.",

	CODEX_RAID_VAULT_TITLE = "Raid — Grande Câmara",
	CODEX_RAID_VAULT_BODY = "• Chefes de raid avançam os espaços de raid da câmara (a dificuldade afeta o nível de item).|n• Normal / Heroico / Mítico contribuem cada um — confira a UI da câmara para ver quais chefes você matou esta semana.|n• Crests costumam limitar os caminhos de melhoria do equipamento de raid.",

	CODEX_VAULT_ADVISOR_TITLE = "Conselheiro da Grande Câmara",
	CODEX_VAULT_ADVISOR_BODY = "• Painel lateral na UI de recompensa semanal da Blizzard quando você reivindica o saque da Grande Câmara (SHIFT-J) — não dentro das abas do Midnight Helper.|n• Classifica as peças da câmara contra o equipamento usado segundo as prioridades de atributo do guia (e Pawn opcional).|n• Ativável nas configurações rápidas do minimapa / Esc -> AddOns -> Midnight Helper.|n• Perfil Auto vs Raid vs M+ para os pesos de atributo.",

	CODEX_WORLD_HUB_TITLE = "Void & Rituals — um só sistema",
	CODEX_WORLD_HUB_BODY = "• O Midnight 12.0.5 une |cffffffffRitual Sites|r (Eversong) e |cffffffffVoid Assaults|r (Zul'Aman) sob uma mesma moeda e renome.|n• Mesmas |cffffffffField Accolades|r e hub do Bazaar — não as farme como atividades separadas.|n• Abra a aba combinada para o site ativo, os limites semanais e os botões TomTom.",

	CODEX_RITUAL_TITLE = "Ritual Sites",
	CODEX_RITUAL_BODY = "• Ritual semanal rotativo em Eversong Woods — complete as fases por accolades e saque.|n• Só um site fica \"ativo\" por vez; o addon destaca qual.|n• O pin do SMC City Guide pode te levar à aba Ritual com contexto.",

	CODEX_VOID_TITLE = "Void Assaults",
	CODEX_VOID_BODY = "• Ondas de assalto em Zul'Aman — defenda objetivos, ganhe accolades.|n• Compartilha o limite semanal com o progresso dos rituais na mesma moeda.|n• Confira o timer de assalto / a zona ativa na aba Void & Rituals.",

	CODEX_RARES_TITLE = "Rares Midnight",
	CODEX_RARES_BODY = "• Mobs raros semanais com saque de conta/personagem (confira as regras de cada raro no jogo).|n• Aba |cffffffffRares|r: acompanhe os kills, monte a rota mais próxima, a seta TomTom fica no pin mais próximo.|n• Alerta ao vivo quando um raro acompanhado está por perto (~500 yd) — ativável nas configurações.",

	CODEX_PROF_TITLE = "Professions — ciclo semanal",
	CODEX_PROF_BODY = "• Knowledge Points (KP), Artisan's Moxie, Unalloyed Abundance e Shards of Dundun são trilhas separadas.|n• A aba |cffffffffProfessions|r mostra os KP não gastos e as moedas semanais por profissão.|n• Ordens de fabricação e tesouros não são totalmente automatizados aqui — use o guia Basics para gastar KP.",

	CODEX_PROF_GUIDE_TITLE = "Professions — guia para iniciantes",
	CODEX_PROF_GUIDE_BODY = "• Subaba |cffffffffBasics -> Professions|r: plano de KP passo a passo e sugestões de combos.|n• O guia Crests cobre a moeda de fabricação de raid (diferente das keys de profundeza).|n• Releia após patches — IDs de moeda e limites podem mudar.",
	CODEX_PROFRESET_TITLE = "Reiniciar as especializações de uma profissão (12.1)",
	CODEX_PROFRESET_BODY = "• O patch 12.1 permite desfazer as tuas escolhas de especialização Midnight — uma vez por profissão.|n• |cffffffffCom quem:|r Theremis, no Bazar de Luaprata junto às encomendas de profissão. Oferece uma linha por profissão, por isso podes reiniciar Ferraria e deixar Encantamento intacto.|n• |cffffffffO que recuperas:|r cada ponto de Conhecimento gasto nas árvores Midnight dessa profissão, livre para redistribuir.|n• |cffffffffO que custa:|r o aviso do jogo diz “You will lose all associated recipes”.|n• |cffffffffAssociadas, não todas.|r O que se perde é o que essas especializações tinham desbloqueado. As receitas de um treinador, de um despojo ou de uma missão estão fora das árvores e ficam. Visto num Encantamento reiniciado: a lista de receitas estava intacta e o Conhecimento gasto tinha voltado ao contador.|n• |cffffffffÉ uma só vez.|r A confirmação escreve ONCE em maiúsculas, e é por profissão — não há segunda tentativa se o novo caminho desiludir.|n• Decide |cffffffffantes|r de confirmar. A página de Profissões indica a árvore a preencher e o nó exato.|n• As receitas retiradas voltam se redistribuíres igual? O jogo nunca o diz. Conta que não.",
	CODEX_ATALUTEK_TITLE = "As Vaults of Atal'Utek — o que há lá dentro e onde",
	CODEX_ATALUTEK_BODY = "• |cffffffffO que é:|r uma área da 12.1 na Coiled Isle com mapa próprio, e por baixo um segundo mapa, a Underbelly. Já está aberta — não há porta de temporada.|n• |cffffffffComo entrar:|r uma cadeia de três missões — |cffffffffInto the Vaults of Atal'Utek|r, depois |cffffffffVaults of Atal'Utek: One Coin Too Many|r, depois |cffffffffVaults of Atal'Utek: The Altar of Corrosion|r. Tudo o resto está atrás delas, por isso faz essas primeiro.|n• |cffffffffCorrosive Coin|r é a moeda da zona. Nas palavras do próprio jogo: “Spirits of the Amani within the Vaults of Atal'Utek deal exclusively in this phantasmal token.” O teu saldo é o número acima deste artigo.|n• |cffffffffCorrosive Soul não é isso.|r Não é moeda nenhuma, mas um |cffffffffitem|r nas tuas bolsas, e é o que o Corrosive Codex te pede para oferecer. Os guias trocam os dois nomes constantemente; o jogo nunca. Se algo te disser para gastar Corrosive Coins no Codex, é essa a troca.|n• |cffffffffPara onde vão as moedas — dois sítios, ambos em Er’inye|r em {WAY:2509:51.10:62.76:Er'inye}. Falar com ele compra |cffffffffCorrode Spirit|r, que alimenta a árvore do altar; ao lado dele, a |cffffffffSkull of Er’inye|r é um mercador com três páginas de montarias, mascotes, conjuntos e receitas, de 500 a 25.000 moedas. |cffffffffO preço do corrode sobe a cada compra|r — visto a 1.500 e depois 2.000 numa visita — por isso lê a janela em vez de poupar para um valor.",
	CODEX_ATALUTEK_DISC_TITLE = "Altar of Corrosion: as quatro chaves",
	CODEX_ATALUTEK_DISC_BODY = "• |cffffffffO Altar of Corrosion|r é a árvore de nós que a última missão da cadeia abre. A maior parte abre-se à medida que gastas, mas |cffffffffquatro nós estão atrás de uma chave que tens de ir procurar|r — e os quatro funcionam da mesma maneira: cai um item, usa-lo num objeto fixo algures nas Vaults, isso dá um item de missão, e Er’inye trata do resto.|n|cffffffffCorroded Key|r → o Venom-Worn Coffer → |cffffffffRun of the Vaults|r (Glideways, ou Swift Steps) · |cffffffffSpirit Loupe|r → a Feather of Tok’jara em {WAY:2509:48.46:25.80:Feather of Tok'jara} → |cffffffffSpectral Winds|r (Spirit Walk, ou Spectral Shipping) · |cffffffffExcising Knife|r → o Eye of Szarith, numa poça de veneno na Underbelly → |cffffffffBroodmaster|r (+100% de dano aos ovos, ou −75% de dano das explosões) · |cffffffffDispelling Charm|r → Jin’tal’s Reliquary no Profaned Mausoleum → |cffffffffSpiritual Protection|r (aliados espectrais nos Curse Surges, ou levantares-te logo se morreres fora das Vaults).|n|cffffffffMostrar uma chave a Er’inye não desbloqueia nada.|r Ele é cego e diz-te o que sente — isso é uma pista de onde o objeto pertence. |cffffffffDe onde caem as chaves não está resolvido|r: três leituras cuidadosas da mesma base de dados deram três respostas diferentes, por isso não apontamos nenhuma. Faz Strikes e Incursions e acabam por aparecer.",
	CODEX_ATALUTEK_DEAD_TITLE = "The Honored Dead e os raros",
	CODEX_ATALUTEK_DEAD_BODY = "• |cffffffff“The Honored Dead” — doze memoriais|r no mapa das Vaults, uma proeza, e a coisa mais clara para ires fazer aqui. Numa só ordem de percurso, do topo do mapa para baixo:|n{WAY:2509:46.79:7.51:To a sister 46.79, 7.51} · {WAY:2509:56.49:22.88:To a shield-bearer 56.49, 22.88} · {WAY:2509:47.22:28.77:To a father 47.22, 28.77} · {WAY:2509:42.57:33.18:To a stranger 42.57, 33.18} (debaixo da ponte) · {WAY:2509:52.91:33.90:To a captain 52.91, 33.90} · {WAY:2509:55.62:40.60:To a dream 55.62, 40.60} · {WAY:2509:42.84:39.93:To sons 42.84, 39.93} · {WAY:2509:52.21:45.12:To a lover 52.21, 45.12} · {WAY:2509:38.50:47.66:To Comrades 38.50, 47.66} · {WAY:2509:55.31:48.45:To parents 55.31, 48.45} · {WAY:2509:49.50:56.59:To a daughter 49.50, 56.59} · {WAY:2509:45.81:61.79:To Failure 45.81, 61.79}|n• |cffffffffA Underbelly|r é o mapa de baixo, com entrada em {WAY:2509:47.30:11.20:The Underbelly} no mapa das Vaults. Lá em baixo vive um raro, |cffffffffSzarith the Fanged|r em {WAY:2613:38.40:17.69:Szarith the Fanged}, e a Underbelly tem uma proeza própria: |cffffffffSoft Underbelly|r.|n• |cffffffffTrês elites raros no mapa principal|r — Congealed Malice, Khu'tulak e Susarikk — formam uma terceira: |cffffffffOppose the Foes|r. |cffffffffNão têm um sítio fixo, e essa é a resposta, não uma falha|r: um dos três acorda no momento em que uma |cffffffffTemple Incursion|r é concluída, e tens cerca de dez minutos. Por isso não sais à caça deles — acabas Incursions, e um aparece.",
})
