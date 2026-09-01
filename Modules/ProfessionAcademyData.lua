--[[
	Profession Academy (data) — beginner chapters for the Midnight profession
	system. Pilot covers the generic system (chapters 1-5) plus Enchanting and
	Alchemy starter guides (6-7). Chapter text lives in the locale packs
	(PROFACAD_*); this module only defines structure and metadata.

	Sources: Wowhead/Method/wow-professions (March-June 2026), see
	docs/PROFESSION_ACADEMY_PLAN.md. Facts verified there; anything we cannot
	detect in-game is a manual checkbox, never a fake claim ("never lie").

	detect values:
	  "profui" — auto-completes when TRADE_SKILL_SHOW fires (player opened a
	  profession window). Anything else is manual.
]]

local _, ns = ...

ns.PROF_ACADEMY = {
	-- Work Order-station in de Bazaar (Captain Flaresworn / Mar'nah) — zelfde
	-- coördinaten als SMC City Guide "crafting_orders".
	-- Chapter waypoints, looked up by name from a chapter's taskWaypoint field.
	-- btnKey = button label, wpKey = the name the arrow/waypoint carries.
	workOrderStation = { mapID = 2393, x = 45.0, y = 55.6,
		btnKey = "PROFACAD_BTN_WORKORDER", wpKey = "PROFACAD_WAYPOINT_WORKORDER" },
	-- Jennara Sunglow (npc 254051), the Gleeful Glamours teacher worth +24 Knowledge.
	-- Coordinates from Rob's own Zygor install (ZygorProfessionsCommonMID.lua:817),
	-- which also notes she is on the TOP FLOOR of the building. Our own chapter text
	-- used to say "tower behind the trainer" -- wrong, the Enchanting trainer stands
	-- at 47.97/53.63, the other side of the city (Rob asked, 2026-07-22).
	glamourTeacher = { mapID = 2393, x = 39.54, y = 51.0,
		btnKey = "PROFACAD_BTN_GLAMOUR", wpKey = "PROFACAD_WAYPOINT_GLAMOUR" },

	-- English fallback names per profession skillLineID; the localized name from
	-- C_TradeSkillUI.GetProfessionInfoBySkillLineID wins when available.
	profNames = {
		[164] = "Blacksmithing",
		[165] = "Leatherworking",
		[171] = "Alchemy",
		[182] = "Herbalism",
		[186] = "Mining",
		[197] = "Tailoring",
		[202] = "Engineering",
		[333] = "Enchanting",
		[393] = "Skinning",
		[755] = "Jewelcrafting",
		[773] = "Inscription",
	},

	-- Midnight spec-tree skillLineID per base profession, used for reading
	-- tree state via C_ProfSpecs. 2909 in-game verified (Rob, live 7 jun:
	-- config 52497993, tabs 1152-1155, root ranks readable); the rest from
	-- Wowhead skill pages (12.0.5, wowhead.com/skill=2906..2918; 2908 Cooking
	-- and 2911 Fishing are secondary skills without spec trees). A wrong ID
	-- fails safe: GetSpecSummary returns nil and no line is shown.
	specSkillLines = {
		[164] = 2907, -- Midnight Blacksmithing
		[165] = 2915, -- Midnight Leatherworking
		[171] = 2906, -- Midnight Alchemy
		[182] = 2912, -- Midnight Herbalism
		[186] = 2916, -- Midnight Mining
		[197] = 2918, -- Midnight Tailoring
		[202] = 2910, -- Midnight Engineering
		[333] = 2909, -- Midnight Enchanting (in-game verified)
		[393] = 2917, -- Midnight Skinning
		[755] = 2914, -- Midnight Jewelcrafting
		[773] = 2913, -- Midnight Inscription
	},

	-- Weekly KP routine (concept B). trainerQuests: weekly trainer/service
	-- quest IDs per BASE skillLine; value is a LIST — some professions rotate
	-- between multiple weekly variants ("any" semantics: one flagged = done
	-- this week; weekly flags reset at the weekly reset, verified 10 jun).
	--
	-- Source: complete table mirrored from Rob's local MidnightRoutine addon
	-- (Modules/ProfessionKnowledge.lua), cross-validated three ways on 10 jun:
	-- (1) our in-game verified 93698 "Splintered Radiance" sits in its
	-- Enchanting set, (2) its trainer coordinates match our city-guide pins,
	-- (3) its weekly-drop flags 93528-93543 match our own Wowhead research
	-- (PROFESSION_ACADEMY_PLAN.md). Crafting profs (except Ench) have one
	-- "service quest" at the Work Order station; Ench + gatherers have
	-- rotating trainer-quest variants at their trainer.
	weekly = {
		trainerQuests = {
			[171] = { 93690 }, -- Alchemy (service quest)
			[164] = { 93691 }, -- Blacksmithing (service quest)
			[333] = { 93697, 93698, 93699 }, -- Enchanting (93698 in-game verified 7+10 jun)
			[202] = { 93692 }, -- Engineering (service quest)
			[182] = { 93700, 93701, 93702, 93703, 93704 }, -- Herbalism
			[773] = { 93693 }, -- Inscription (service quest)
			[755] = { 93694 }, -- Jewelcrafting (service quest)
			[165] = { 93695 }, -- Leatherworking (service quest)
			[186] = { 93705, 93706, 93707, 93708, 93709 }, -- Mining
			[393] = { 93710, 93711, 93712, 93713, 93714 }, -- Skinning
			[197] = { 93696 }, -- Tailoring (service quest)
		},
		-- Crafting profs (except Enchanting) pick their weekly up at the WORK
		-- ORDER STATION (Flaresworn/Mar'nah), not at their trainer — Rob walked
		-- to the Alchemy trainer and found nothing (10 jun). Ench + gatherers
		-- use their trainer. Consumers route/word the pickup per this set.
		serviceProfs = {
			[171] = true, -- Alchemy
			[164] = true, -- Blacksmithing
			[202] = true, -- Engineering
			[773] = true, -- Inscription
			[755] = true, -- Jewelcrafting
			[165] = true, -- Leatherworking
			[197] = true, -- Tailoring
		},
		-- Enchanting weekly disenchant mats (zie PROFESSION_ACADEMY_PLAN.md).
		enchantingEssences = {
			{ itemID = 267654, need = 5, fallbackName = "Swirling Arcane Essence" },
			{ itemID = 267655, need = 1, fallbackName = "Brimming Mana Shard" },
		},
	},

	-- Tree Advisor v1: curated default route per profession (consensus from
	-- the guides behind the starter chapters; see docs/PROFESSION_ACADEMY_PLAN.md).
	-- Each step is a tree ROOT to finish; anyOf = either counts (player's
	-- choice). Names MUST match C_ProfSpecs.GetTabInfo().name exactly — on a
	-- mismatch (locale, renamed tree) the advice line simply does not show
	-- (never lie). Verified live so far: Enchanting (all 4), Tailoring
	-- (Nimble Needlework, Fiber Arts), LW (Learned Leatherworker), Skinning
	-- (Thorough Tanning, Talented Tracker). skipIfClass: step skipped for
	-- that class token (Druids gather while shapeshifted, no Botany needed).
	-- NODE-level advice, used once the tree route above is complete. Only added
	-- where a source names the node; a profession without an entry simply keeps
	-- the tree-level advice. Names are matched against what the GAME reports, so a
	-- rename or a non-English client yields no advice instead of a wrong one.
	--
	-- Enchanting: our own chapter says "then the Weapon/Ring/Chest branch (the most
	-- wanted enchants)". Rob hovered it in game on 2026-07-22: the node called
	-- "Silvermoon's Spellpower" reads "Learn the secrets of Thalassian Weapon, Ring,
	-- and Chest Armor enchantments" -- an exact match, confirmed by /mh nodes
	-- reporting it as 0/20. That is the only node route verified so far.
	-- 🔴 30 Aug 2026: THAT MATCH PICKED A FAMILY WITHOUT DECIDING ANYTHING. Midnight has
	-- three parallel enchant families -- Amani, Thalassian and Haranir -- and each has its
	-- own Weapon/Ring/Chest node. `Azerothian Arms` reads "granting your HARANIR Weapon,
	-- Chest, and Ring enchantments", word for word the same shape as the Thalassian one
	-- above. Our chapter's phrase "the Weapon/Ring/Chest branch" therefore matches at least
	-- two nodes, and in July the first match won.
	--
	-- Rob hit this live: with the tree route finished the advice read "put your next points
	-- into Silvermoon's Spellpower" while the panel underneath listed four Haranir nodes.
	-- He had just said he does not know which family he makes -- and we answered by naming
	-- one silently. Third time today the same fault: one option shown as the answer.
	--
	-- ✅ MEASURED 30 Aug 2026, and now all three are listed. Two agents read Blizzard's
	-- DB2 independently and agreed to the last decimal: every gear enchant in all three
	-- families is ItemLevelMin 120, and SpellItemEnchantment.EffectScalingPoints is
	-- bit-for-bit equal wherever the stat matches (lesser rings 0.65414899588, chest
	-- primary 0.95148998499, tools 10.5784). No family is stronger and none is legacy.
	--
	-- What differs is which stats you may sell -- the tertiaries form a Latin square, so
	-- Leech on shoulders exists only for Thalassian -- which makes this a real choice
	-- and not an order. That is exactly what anyOfNodes is for, and listing one of three
	-- was only ever defensible while nobody had checked whether they were equivalent.
	--
	-- 🔴 TWO STEPS, BECAUSE THE TREE HAS TWO LEVELS. Rob, 30 Aug, reading the one-step
	-- version: "ik snap het advies niet, waar vind ik dit dan?" -- and he was right to
	-- ask. Zul'Aman Zeal and its siblings sit INSIDE the family branches, which sit
	-- inside Elevating Equipment. With all three branches still at 0/20 he could not
	-- click any of the three names we gave him. Naming a node two layers below where
	-- the player stands is the same fault as naming one of three options: technically
	-- about the right thing, useless at the moment it is read.
	--
	-- Step 1 is what he can act on now: which family branch to open. Step 2 is the
	-- Weapon/Chest/Ring node inside it, which only becomes reachable afterwards.
	-- 📌 The Helm/Shoulder/Boot and Tool siblings are deliberately not routed: which
	-- slot line pays is a market question and we have no market source -- see
	-- PROFACAD_CH_ENCHANTING_FAMILIES, which lays out the whole grid instead.
	advisorNodeRoutes = {
		[333] = { -- Enchanting
			{ anyOfNodes = {
				"Amani Augments",          -- Mastery rings, Strength chest
				"Thalassian Talents",      -- Haste + Versatility rings
				"Haranir Heightening",     -- Crit rings, Mark of the Worldsoul
			} },
			{ anyOfNodes = {
				"Zul'Aman Zeal",           -- Amani: Weapon/Chest/Ring
				"Silvermoon's Spellpower", -- Thalassian: Weapon/Chest/Ring
				"Azerothian Arms",         -- Haranir: Weapon/Chest/Ring
			} },
		},
	},

	advisorRoutes = {
		--- ⚠️ ALL TEN ROUTES BELOW WERE REWRITTEN 20 Aug 2026 from Spec 28, which is
		--- built on Spec 24 (audit) and Spec 25 (Blizzard's own gamedata, build
		--- 12.1.0.69382). Before that, every one of the eleven was wrong in some way;
		--- only [202] Engineering had been repaired, earlier the same day.
		---
		--- 🔴 MEASURED 31 Aug 2026 against Rob's own client (`/mh profids` on four
		--- characters, 8 of 11 professions, 202 id-bearing entries). TWELVE steps named a
		--- node as if it were a tab, across SIX of the eight: five in Alchemy, two each in
		--- Leatherworking, Tailoring and Skinning, and Herbalism's Mulching. Written as
		--- `tree` they were looked up among the tab names, matched nothing, and were
		--- skipped — the advice for those steps silently did not exist.
		---
		--- ⚠️ And `Lasting Leather` is worse than the warning below says. It is a TAB in
		--- Leatherworking and a NODE in Skinning: not two things sharing a name, two
		--- different LAYERS sharing a name. Per-skill-line scoping cannot save you from
		--- that, because the collision is not in which profession you look at — it is in
		--- which of two lookup tables you were supposed to use.
		---
		--- ✅ ALL ELEVEN ARE NOW CLIENT-VERIFIED, 31 Aug 2026 — a first. Rob logged through
		--- four characters for the eight he had, then cycled his level-82 Warlock through
		--- Engineering, Jewelcrafting and Inscription, which nobody on the account owned.
		--- Two things that made that cheap and are worth knowing: level 82 is enough for
		--- the Midnight spec trees (measured, not assumed), and a profession can be dropped
		--- the moment it is captured, because the ids end up here rather than on the
		--- character.
		---
		--- Five professions carried layer errors: Alchemy 5, Leatherworking 2, Tailoring 2,
		--- Skinning 2, Herbalism 1. Six were already right — Blacksmithing, Mining,
		--- Engineering, Enchanting, Jewelcrafting, Inscription. There was no pattern to
		--- predict which, which is the argument for checking rather than reading.
		---
		--- ⚠️ Re-run `tools/_probe.py`'s route check after ANY edit here, and after a patch:
		--- it compares every step against ns.db.profIdDump and is the only thing standing
		--- between this table and the twelve silent failures it had this morning.
		---
		--- 🔴 MATCHED BY NAME, AND THAT IS A LOADED GUN. `Lasting Leather` exists TWICE
		--- inside Midnight: Leatherworking trait 107889 and Skinning trait 106088. It
		--- works today only because Profession.lua resolves names per skill line via
		--- C_ProfSpecs.GetSpecTabIDsForSkillLine, so the two can never meet. That is a
		--- property of the lookup, not of this table — do not "simplify" the lookup to a
		--- global name map.
		---
		--- `points` is a HINT, never the truth. Sources disagreed at every single
		--- profession, sometimes by a factor of two, so the UI names the in-game tooltip
		--- as the authority. `points = 0` means "open this branch, invest nothing".

		-- Blacksmithing. The Old Ways moves to the FRONT: two independent sources lead
		-- with it and it touches every Blacksmithing craft, so our order had people
		-- burning materials for weeks without the branch that gives them back.
		--
		-- 🔴 `Craftsmithing` REMOVED. The comment that used to sit here credited the step
		-- to wow-professions' beginner build; that page does not name it there. It was
		-- added in July with a citation that did not cover it. Craftsmithing makes tools
		-- for OTHER crafters and does nothing for your own gear.
		[164] = {
			{ tree = "The Old Ways" },
			{ anyOf = { "Armorsmithing", "Weaponsmithing" } },
		},
		-- Leatherworking. The route was never corrected when the prose was, on 24 July.
		-- It is not wrong for a gear player, but it is incomplete: gold and gear diverge
		-- further here than in any other profession.
		--
		-- ⚠️ `Mastering Multicraft` works on commodities only, NOT on armour. Someone
		-- making leather armour gains nothing from it — the exact opposite of
		-- Blacksmithing's Prolific Worker, which is why one route cannot serve both.
		[165] = {
			goals = {
				self = {
					{ anyOf = { "Lasting Leather", "Safeguarding Scales" } },
					{ tree = "Learned Leatherworker" },
				},
				gold = {
					{ tree = "Flawless Fortes" },
					{ node = "Commanding Commodities" },
					{ tree = "Learned Leatherworker" },
					{ node = "Mastering Multicraft" },
				},
			},
		},
		-- Alchemy. Transmutation was second and belongs LAST; Potion Prowess leads.
		-- Filling Potion Prowess gives the Voidlight Potion Cauldron, which serves gold
		-- and guild at once. Prolific Potioneer - Light is the Multicraft node, Light
		-- because that is the potion that sells this season. Reuse returns herbs, which
		-- is strong next to Herbalism.
		--
		-- 📌 `Haranir Secrets` is not an afterthought. Its own tooltip ends "and Cauldron
		-- of Sin'dorei Flasks" — without points there you cannot make the flask cauldron
		-- at top rank. Every guide paraphrases the node as "phials only" and drops that
		-- half-sentence.
		-- 🔴 FIVE OF THESE NINE ARE NODES, NOT TREES. Measured on Rob's shaman with
		-- `/mh profadvice`, 31 Aug 2026: Path of Light, Prolific Potioneer - Light,
		-- Reuse, Sin'dorei Specialist and Haranir Secrets all report "is a NODE, not a
		-- tree". Written as `tree =` they were looked up among the four tab names,
		-- matched nothing, and were skipped — so five ninths of this route silently did
		-- not exist. Before 30 Aug it was worse: an unresolved step aborted the whole
		-- route, leaving Alchemy with no advice at all past Potion Prowess.
		--
		-- 📌 The chapter text knew: it says "Alchemical Mastery and INSIDE IT Reuse",
		-- and calls Prolific Potioneer - Light "the Multicraft node". The prose had the
		-- layer right and the data did not, for as long as both have existed.
		[171] = {
			{ tree = "Potion Prowess" },
			{ node = "Path of Light" },
			{ node = "Prolific Potioneer - Light" },
			{ tree = "Alchemical Mastery" },
			{ node = "Reuse" },
			{ tree = "Fluent in Flasks", points = 15 },
			{ node = "Sin'dorei Specialist" },
			{ node = "Haranir Secrets" },
			{ tree = "Transmutation Authority" },
		},
		-- Herbalism. `Mulching` was missing and `Midnight Overload` had to go.
		-- Botany at 40 is picking from your mount, the single biggest time saving in the
		-- profession. Mulching at 20 gives Imbued Mulch, a guaranteed rare find — which
		-- is Nocturnal Lotus, the herb in all four flasks and both cauldrons.
		--
		-- `Midnight Overload` dropped: it only works on the elemental nodes, costs a lot
		-- of points, and you meet too few of them. Worth it only for targeted mote farming.
		-- 🔴 `Mulching` IS A NODE. Measured on Rob's shaman, 31 Aug 2026 — and this one
		-- cost something, because I told him that morning Herbalism was in order after
		-- MEASURING Alchemy and merely READING this. Three tidy names, three lines of
		-- data, "those look fine". He had already spent his one-time Knowledge reset by
		-- the time the probe said otherwise: Botany 40/40 and Bountiful Harvests 29/40,
		-- with Mulching still at 0 — the route's own step two, skipped because we told
		-- the advisor to look for it in the wrong list.
		--
		-- Nothing was destroyed (both filled trees are on the route, and Mulching still
		-- takes points), but the payoff the comment below describes was delayed for
		-- weeks by a one-word mistake in a table nobody re-read.
		[182] = {
			{ tree = "Botany", skipIfClass = "DRUID", points = 40 },
			{ node = "Mulching", points = 20 },
			{ tree = "Bountiful Harvests" },
		},
		-- Mining. Was not wrong, but incomplete.
		--
		-- 📌 `Over-LODED` at ZERO points is not a typo. Unlocking that branch already
		-- grants the Overload ability and its cooldown reduction; points beyond the
		-- unlock are a bet on mote prices. The advisor treats such a step as done the
		-- moment the branch is open, so it never parks there.
		[186] = {
			{ tree = "Over-LODED", points = 0 },
			{ tree = "Meticulous Mining", points = 40 },
			{ tree = "Plentiful Ores" },
		},
		-- Tailoring. The old anyOf hid the very choice this profession turns on, and
		-- `Fabric Specialist` was described in our text as "spare points" while it holds
		-- a Multicraft node that works on EVERY recipe.
		--
		-- 📌 20 in `Nimble Needlework` is not arbitrary: the weaving branches are what
		-- make enemies drop the expensive cloth at all. Without them you never see it.
		[197] = {
			{ tree = "Nimble Needlework", points = 20 },
			goals = {
				gold = {
					{ node = "Sunfire Silk Weaving" },
					{ tree = "Fiber Arts" },
					{ node = "Creative Efficiency" },
					{ tree = "Fabric Specialist" },
				},
				self = {
					{ tree = "Sin'dorei Finery" },
					{ tree = "Fiber Arts" },
				},
			},
		},
		-- Engineering: was ONLY "Recycling" (an efficiency tree) with no recipe tree
		-- at all — the one clearly broken route. Corrected 2026-07-24 against
		-- wow-professions: a beginner builds a recipe tree they enjoy (gadgets, goggles
		-- or tools), then Recycling for the big skill/yield bonus. anyOf so the advice
		-- follows whichever recipe tree the player already started.
		--- ⚠️ RECYCLING FIRST, AND IT USED TO BE LAST. Spec 24 calls this the worst of the
		--- nine route errors, and the reason is that it does not merely give slow advice —
		--- it sends the player somewhere nothing happens.
		---
	--- In Midnight you discover most Engineering recipes by recycling. We had this as the
		--- last step because we read it as an efficiency branch, and that was wrong: it is
		--- how the profession feeds itself.
		---
		--- 🔴 CORRECTED 1 Sep 2026 — the sentence here used to say recycling "stays OFF until
		--- points go into the tree", and that is false. Recycling works from zero points:
		--- Zygor's own guide has the player craft it 35 times and consume the result BEFORE
		--- the step that learns the specialization, and Method writes that Recycle gives
		--- skill-ups "all the way from 1 to 30". What the ten points buy is **recipe
		--- discovery**, not the ability. Our own docs/SPEC_25 said this correctly
		--- ("ontdekt pas recepten"); the drift was here, in the comment.
		--- ⚠️ The advice is unchanged and still right. Only the reason we gave was wrong --
		--- and a wrong reason is what a future session reasons FROM.
		--- 📎 The 10-point threshold comes from Zygor's Midnight guide, which is an
		--- independent source rather than an echo of Spec 24: "Put 10 points into the
		--- Recycling specialization and pick the Resourcefulness sub-spec". The sub-spec
		--- half is a NODE, so it belongs in advisorNodeRoutes and is deliberately not
		--- guessed at here — we have no verified node name for it.
		[202] = {
			{ tree = "Recycling", points = 10 },
			{ anyOf = { "Market Mobility", "Combat Analytics", "Bits and Bots" } },
		},
		-- Enchanting. Our order was backwards, and expensively so: disenchanting ignores
		-- EVERY craft stat and reads raw Skill only, so the first ~50 points we sent
		-- people to spend did nothing for it.
		--
		-- Disenchanting Delegate pays out linearly from the very first point, has no
		-- auction-house competition, and produces the materials the rest of the
		-- profession runs on. Shard Supplier if you break down blues, Crystal Collector
		-- for epics — choosing wrong here is the costliest mistake in this tree.
		--
		-- ⚠️ Where our error came from, so nobody restores it: Wowhead's guide carries a
		-- boilerplate table saying disenchanting uses Multicraft/Resourcefulness/
		-- Ingenuity, while its own prose below says the opposite. All 28 perk lines in
		-- the gamedata name Skill and nothing else.
		--
		-- 🔴 `anyOfNodes`, not `anyOf`. Shard Supplier and Crystal Collector are NODES
		-- inside Disenchanting Delegate, not specialization trees — the four trees are
		-- the tabs at the top of the window. Written as `anyOf` they were looked up
		-- among the tab names, matched nothing, and the advisor returned nil for the
		-- WHOLE profession: Rob finished the 30-point root on 30 Aug 2026, had 235
		-- Knowledge in hand and got no advice line at all, for this step or the two
		-- tree steps after it. Steps 3 and 4 were never reached.
		--
		-- 🔴 THREE options, not two. Read off Rob's own tooltips 30 Aug 2026, in
		-- Blizzard's words: Dust Deliverer is Uncommon, Shard Supplier is Rare,
		-- Crystal Collector is Epic — each "+1 Skill per point when disenchanting"
		-- that quality and +5 on learning. We listed only two and had described them
		-- as "blues" and "epics", which happens to map correctly onto Rare and Epic
		-- but left the green tier out of a choice we call the costliest in the tree.
		-- They are Rank 0/30 each, not 0/20.
		--
		-- Deliberately NOT ranked. Which one pays depends on what the player actually
		-- breaks down, and we have never asked. The advisor names all three.
		[333] = {
			{ tree = "Disenchanting Delegate" },
			{ anyOfNodes = { "Dust Deliverer", "Shard Supplier", "Crystal Collector" } },
			{ tree = "Elevating Equipment" },
			{ tree = "Spellbound Shatterer" },
		},
		-- Skinning. The whole sub-specialisation layer was missing, and Talented Tracker
		-- sat at position three, which is wrong for anyone playing for gold.
		--
		-- Order between the first two does not matter: both grant their core ability on
		-- being learned.
		-- ⚠️ `Lasting Leather` here is the SKINNING trait 106088, not the Leatherworking
		-- namesake in [165]. See the warning at the top of this table.
		[393] = {
			{ tree = "Thorough Tanning" },
			{ tree = "Gainful Gathering" },
			goals = {
				self = { { anyOfNodes = { "Lasting Leather", "Superb Scales" } } },
				gold = { { tree = "Talented Tracker" }, { node = "Majestic Materials" } },
			},
		},
		-- Jewelcrafting. `Alluring Accessories` was missing entirely — precisely the tree
		-- for yourself and your guild.
		--
		-- 📌 Gems are no longer the automatic gold mine. Midnight has no item that adds
		-- sockets any more (only the Great Vault), so demand for cut gems is structurally
		-- lower than last expansion. Step two is a real choice, not a default.
		[755] = {
			{ tree = "Thoughtful Throughput" },
			{ anyOf = { "Glamorous Gems", "Alluring Accessories" } },
			{ tree = "Proficient Processor" },
		},
	-- Inscription. Steps 2 and 3 were swapped, and this order is the better one.
		--
		-- 🔴 CORRECTED 1 Sep 2026. This used to claim the old order was "not merely
		-- suboptimal but IMPOSSIBLE to follow: Blueprints opens at skill 50 and Perfected
		-- Products only at 60." That is false, and our OWN measurement had already said so
		-- before the sentence was written. docs/SPEC_25 §8.1: `TraitCurrencySource` carries
		-- four GENERIC unlock tokens (skill 25/50/60/75) and "the game does not prescribe
		-- which tree belongs to which level -- the player chooses". The spec even dictates
		-- the wording: "at skill 25/50/60/75 you may pick one each time", NEVER "at skill 50
		-- you get X". Method and Icy Veins independently describe it as free choice.
		--
		-- So the gate is on the ORDINAL SLOT, not on the tree. Swapping 2 and 3 would be
		-- perfectly legal. ⚠️ Keep the order as a recommendation; do not restore the
		-- impossibility claim, and do not reason from it -- on 1 Sep it was quoted to a
		-- research agent as this repo's model of good reasoning, which is what a false
		-- comment costs.
		--
		-- ✅ The double spelling is gone. Gamedata settles it: trait 109660 is
		-- `Perfected Products`. The confusion came from its SUB-branches, which really
		-- are called "Perfect ..." (Perfect Vantus Runes, 109656) — one guide dropped
		-- the -ed from the stem. wow-professions was right. Listing both spellings was
		-- a reasonable hedge while nobody had an Inscription character; it is now just
		-- a dead name that would silently never resolve.
		--
		-- 📌 `Calm Hands` caps at rank 10, not the 30 the guides print. The first point
		-- already grants the Treatise recipe; at 10 your Treatise yields an extra
		-- Knowledge Point per week. That makes it the most important threshold in the
		-- profession, because it accelerates every later point you earn.
		[773] = {
			{ tree = "Calm Hands", points = 10 },
			{ tree = "Blueprints" },
			{ tree = "Perfected Products" },
		},
	},

	-- Curated "fits your class" advice (armor-type logic; consensus from the
	-- guides in docs/PROFESSION_ACADEMY_PLAN.md). Shown only when the character
	-- has an open profession slot. Alchemy+Herbalism is the universal alt.
	advice = {
		WARRIOR = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		PALADIN = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		DEATHKNIGHT = { profs = { 164, 186 }, whyKey = "PROFACAD_WHY_PLATE" },
		HUNTER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		SHAMAN = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		EVOKER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_MAIL" },
		ROGUE = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		MONK = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		DEMONHUNTER = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		DRUID = { profs = { 165, 393 }, whyKey = "PROFACAD_WHY_LEATHER" },
		MAGE = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
		PRIEST = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
		WARLOCK = { profs = { 197, 333 }, whyKey = "PROFACAD_WHY_CLOTH" },
	},
	adviceAlt = { 171, 182 },

	chapters = {
		{
			key = "knowledge",
			titleKey = "PROFACAD_CH_KNOWLEDGE_TITLE",
			bodyKey = "PROFACAD_CH_KNOWLEDGE_BODY",
			introKey = "PROFACAD_CH_KNOWLEDGE_INTRO",
			taskKey = "PROFACAD_CH_KNOWLEDGE_TASK",
			detect = "profui",
			-- searchKeys: the words a reader types BEFORE they know the chapter's
			-- own title. Same reason the Codex articles carry them.
			searchKeys = "knowledge points kp what are they where do i get them",
		},
		{
			key = "gearup",
			titleKey = "PROFACAD_CH_GEARUP_TITLE",
			bodyKey = "PROFACAD_CH_GEARUP_BODY",
			introKey = "PROFACAD_CH_GEARUP_INTRO",
			taskKey = "PROFACAD_CH_GEARUP_TASK",
			detect = "proftool",
			searchKeys = "profession gear tool accessory equipment slots empty skill",
		},
		{
			key = "trees",
			titleKey = "PROFACAD_CH_TREES_TITLE",
			bodyKey = "PROFACAD_CH_TREES_BODY",
			introKey = "PROFACAD_CH_TREES_INTRO",
			advancedKey = "PROFACAD_CH_TREES_ADVANCED",
			taskKey = "PROFACAD_CH_TREES_TASK",
			detect = "kpspent",
			-- "respec", "reset" and "refund" matter most here: that is what someone
			-- types the moment they fear they spent a point wrong, and until 3.3.0
			-- this chapter told them the wrong answer.
			searchKeys = "specialization specialisation tree respec reset refund undo theremis knowledge points",
		},
		--- Lessons 3, 4 and 5 from the beginner copy, round A of Spec 27. Built from
		--- docs/COPY_QUALITY_BEGINNER.md, COPY_STATS_BEGINNER.md and
		--- COPY_CONCENTRATION_BEGINNER.md, all at commit 8a5ca58 (20 Aug 2026).
		--- ⚠️ If those files move on, diff them against these bodies — a source revision
		--- landing after the build diverges silently, which is exactly how the
		--- Leatherworking route and its own paragraph contradicted each other for a month.
		---
		--- Placed after "trees" on purpose: quality is what makes the tree choice matter,
		--- the six stats are the mechanics underneath it, and Concentration is the safety
		--- net both of them point at. No `detect` — only profui/proftool/kpspent exist,
		--- and none of them describes "has read this", so these stay manual checkboxes.
		{
			key = "quality",
			titleKey = "PROFACAD_CH_QUALITY_TITLE",
			bodyKey = "PROFACAD_CH_QUALITY_BODY",
			introKey = "PROFACAD_CH_QUALITY_INTRO",
			advancedKey = "PROFACAD_CH_QUALITY_ADVANCED",
			taskKey = "PROFACAD_CH_QUALITY_TASK",
			searchKeys = "quality rank tier skill recipe difficulty reagent reagents crafting details "
				.. "why is my item worse minimum quality order cannot complete",
		},
		{
			key = "profstats",
			titleKey = "PROFACAD_CH_STATS_TITLE",
			bodyKey = "PROFACAD_CH_STATS_BODY",
			introKey = "PROFACAD_CH_STATS_INTRO",
			advancedKey = "PROFACAD_CH_STATS_ADVANCED",
			taskKey = "PROFACAD_CH_STATS_TASK",
			-- All six by name: this chapter exists because the single most repeated
			-- complaint on the official forums is having to look them up every time.
			searchKeys = "stats multicraft resourcefulness ingenuity finesse perception deftness "
				.. "crafting details percentages what do they mean",
		},
		{
			key = "concentration",
			titleKey = "PROFACAD_CH_CONC_TITLE",
			bodyKey = "PROFACAD_CH_CONC_BODY",
			introKey = "PROFACAD_CH_CONC_INTRO",
			advancedKey = "PROFACAD_CH_CONC_ADVANCED",
			taskKey = "PROFACAD_CH_CONC_TASK",
			searchKeys = "concentration guarantee next quality flame button refill regenerate "
				.. "ingenuity refund per profession",
		},
		--- Lesson 6, round C. Built from docs/COPY_GOLD_BEGINNER.md at commit 8f4c9d1.
		---
		--- The only chapter with a `datedKey`, and that is the point of it. Half of this
		--- subject is durable (how the two markets differ, what a supply lock is) and half
		--- expires within weeks (what sells right now). Every guide we read mixes them, so
		--- the whole thing reads as stale the moment the specific half goes off.
		---
		--- ⚠️ When it is re-measured, write a NEW key with the new date and point this at
		--- it — do not edit the old one in place. The date in the key is what makes it
		--- possible to see, from the data alone, how old the perishable advice is.
		{
			key = "gold",
			titleKey = "PROFACAD_CH_GOLD_TITLE",
			bodyKey = "PROFACAD_CH_GOLD_BODY",
			introKey = "PROFACAD_CH_GOLD_INTRO",
			datedKey = "PROFACAD_CH_GOLD_DATED_202608",
			taskKey = "PROFACAD_CH_GOLD_TASK",
			searchKeys = "gold money profit auction house sell market margin craftsim "
				.. "auctionator soulbound warband cooldown is it worth crafting",
		},
		{
			key = "recipes",
			titleKey = "PROFACAD_CH_RECIPES_TITLE",
			bodyKey = "PROFACAD_CH_RECIPES_BODY",
			introKey = "PROFACAD_CH_RECIPES_INTRO",
			taskKey = "PROFACAD_CH_RECIPES_TASK",
			searchKeys = "recipes where do they come from trainer learn unlock first craft",
		},
		{
			key = "moxie",
			titleKey = "PROFACAD_CH_MOXIE_TITLE",
			bodyKey = "PROFACAD_CH_MOXIE_BODY",
			introKey = "PROFACAD_CH_MOXIE_INTRO",
			taskKey = "PROFACAD_CH_MOXIE_TASK",
			searchKeys = "moxie artisan currency vendor shopping money buy recipes books",
		},
		{
			key = "weekly",
			titleKey = "PROFACAD_CH_WEEKLY_TITLE",
			bodyKey = "PROFACAD_CH_WEEKLY_BODY",
			introKey = "PROFACAD_CH_WEEKLY_INTRO",
			taskKey = "PROFACAD_CH_WEEKLY_TASK",
			taskWaypoint = "workOrderStation",
			searchKeys = "weekly quest profession knowledge every week reset",
		},
		{
			key = "workorders",
			titleKey = "PROFACAD_CH_WORKORDERS_TITLE",
			bodyKey = "PROFACAD_CH_WORKORDERS_BODY",
			introKey = "PROFACAD_CH_WORKORDERS_INTRO",
			advancedKey = "PROFACAD_CH_WORKORDERS_ADVANCED",
			taskKey = "PROFACAD_CH_WORKORDERS_TASK",
			taskWaypoint = "workOrderStation",
			searchKeys = "work orders crafting orders public guild personal commission customer "
				.. "mar'nah marnah order table two counters workbench",
		},
		--- Patron orders were a paragraph inside the work-orders chapter, and they are the
		--- half that actually matters: they are the largest weekly Knowledge source, they
		--- live at a different place from the rest, and they carry a timing trap that costs
		--- points silently. Buried in a list of four they read as "the fourth kind".
		---
		--- Built from docs/COPY_WORKORDERS_BEGINNER.md at commit c693ae2 (20 Aug 2026).
		{
			key = "patron",
			titleKey = "PROFACAD_CH_PATRON_TITLE",
			bodyKey = "PROFACAD_CH_PATRON_BODY",
			introKey = "PROFACAD_CH_PATRON_INTRO",
			taskKey = "PROFACAD_CH_PATRON_TASK",
			searchKeys = "patron orders npc orders knowledge points weekly source "
				.. "daily small order catch up behind goal",
		},
		{
			key = "enchanting",
			titleKey = "PROFACAD_CH_ENCHANTING_TITLE",
			bodyKey = "PROFACAD_CH_ENCHANTING_BODY",
			introKey = "PROFACAD_CH_ENCHANTING_INTRO",
			advancedKey = "PROFACAD_CH_ENCHANTING_ADVANCED",
			familiesKey = "PROFACAD_CH_ENCHANTING_FAMILIES",
			taskWaypoint = "glamourTeacher",
			taskKey = "PROFACAD_CH_ENCHANTING_TASK",
			levelingKey = "PROFGUIDE_LVL_ENCHANTING",
			skillLineID = 333,
		},
		{
			key = "alchemy",
			titleKey = "PROFACAD_CH_ALCHEMY_TITLE",
			bodyKey = "PROFACAD_CH_ALCHEMY_BODY",
			introKey = "PROFACAD_CH_ALCHEMY_INTRO",
			taskKey = "PROFACAD_CH_ALCHEMY_TASK",
			levelingKey = "PROFGUIDE_LVL_ALCHEMY",
			skillLineID = 171,
		},
		{
			key = "tailoring",
			titleKey = "PROFACAD_CH_TAILORING_TITLE",
			bodyKey = "PROFACAD_CH_TAILORING_BODY",
			introKey = "PROFACAD_CH_TAILORING_INTRO",
			taskKey = "PROFACAD_CH_TAILORING_TASK",
			levelingKey = "PROFGUIDE_LVL_TAILORING",
			skillLineID = 197,
		},
		{
			key = "leatherworking",
			titleKey = "PROFACAD_CH_LEATHERWORKING_TITLE",
			bodyKey = "PROFACAD_CH_LEATHERWORKING_BODY",
			introKey = "PROFACAD_CH_LEATHERWORKING_INTRO",
			taskKey = "PROFACAD_CH_LEATHERWORKING_TASK",
			levelingKey = "PROFGUIDE_LVL_LEATHERWORKING",
			skillLineID = 165,
		},
		{
			key = "blacksmithing",
			titleKey = "PROFACAD_CH_BLACKSMITHING_TITLE",
			bodyKey = "PROFACAD_CH_BLACKSMITHING_BODY",
			introKey = "PROFACAD_CH_BLACKSMITHING_INTRO",
			taskKey = "PROFACAD_CH_BLACKSMITHING_TASK",
			levelingKey = "PROFGUIDE_LVL_BLACKSMITHING",
			skillLineID = 164,
		},
		{
			key = "engineering",
			titleKey = "PROFACAD_CH_ENGINEERING_TITLE",
			bodyKey = "PROFACAD_CH_ENGINEERING_BODY",
			introKey = "PROFACAD_CH_ENGINEERING_INTRO",
			taskKey = "PROFACAD_CH_ENGINEERING_TASK",
			levelingKey = "PROFGUIDE_LVL_ENGINEERING",
			skillLineID = 202,
		},
		{
			key = "inscription",
			titleKey = "PROFACAD_CH_INSCRIPTION_TITLE",
			bodyKey = "PROFACAD_CH_INSCRIPTION_BODY",
			introKey = "PROFACAD_CH_INSCRIPTION_INTRO",
			taskKey = "PROFACAD_CH_INSCRIPTION_TASK",
			levelingKey = "PROFGUIDE_LVL_INSCRIPTION",
			skillLineID = 773,
		},
		{
			key = "jewelcrafting",
			titleKey = "PROFACAD_CH_JEWELCRAFTING_TITLE",
			bodyKey = "PROFACAD_CH_JEWELCRAFTING_BODY",
			introKey = "PROFACAD_CH_JEWELCRAFTING_INTRO",
			taskKey = "PROFACAD_CH_JEWELCRAFTING_TASK",
			levelingKey = "PROFGUIDE_LVL_JEWELCRAFTING",
			skillLineID = 755,
		},
		{
			key = "herbalism",
			titleKey = "PROFACAD_CH_HERBALISM_TITLE",
			bodyKey = "PROFACAD_CH_HERBALISM_BODY",
			introKey = "PROFACAD_CH_HERBALISM_INTRO",
			taskKey = "PROFACAD_CH_HERBALISM_TASK",
			levelingKey = "PROFGUIDE_LVL_HERBALISM",
			skillLineID = 182,
		},
		{
			key = "mining",
			titleKey = "PROFACAD_CH_MINING_TITLE",
			bodyKey = "PROFACAD_CH_MINING_BODY",
			introKey = "PROFACAD_CH_MINING_INTRO",
			taskKey = "PROFACAD_CH_MINING_TASK",
			levelingKey = "PROFGUIDE_LVL_MINING",
			skillLineID = 186,
		},
		{
			key = "skinning",
			titleKey = "PROFACAD_CH_SKINNING_TITLE",
			bodyKey = "PROFACAD_CH_SKINNING_BODY",
			introKey = "PROFACAD_CH_SKINNING_INTRO",
			taskKey = "PROFACAD_CH_SKINNING_TASK",
			levelingKey = "PROFGUIDE_LVL_SKINNING",
			skillLineID = 393,
		},
	},
}
