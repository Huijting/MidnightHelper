local _, ns = ...

--[[
	ForeverBlock_Druid.lua — the APPROVED key-block table for the Druid in WoW Forever (ForeverBlock.lua is the engine).

	Rob, 5 Nov 2026: "ja goedzo" on docs/PLAN_FOREVER_DRUID_BLOK_2026-11-05.md; placed and seen working on his level 8
	Night Elf Druid the same evening ("whoohoo het werkt"). Spells and levels: docs/FOREVER_DRUID_SPELLS_2026-11-05.md.

	Forms by bar paging, not by form index (which depends on the order forms were learned):
	  bonusbar 1 = Cat, 2 = Cat while prowling, 3 = Bear and Dire Bear. MEASURED 6 Nov 2026 in Blizzard's data
	  (SpellShapeshiftForm.BonusActionBar, wago wowf 1.60.1.70790: Cat 1, Bear 3, Dire Bear 3, Moonkin 0). Moonkin Form
	  does NOT page the bar, so in Moonkin the caster spells fire (the base guard excludes 1-3 only). Prowl on 2 is
	  AFGELEID from Rob's /mh spellbook dump (Attack on slots 73/85/97/109 = pages 7-10). To be tested at 10 and 20.
	Two additions to the approved table: War Stomp on Shift-E for a Tauren (no Shadowmeld), and `open` on R so Bear keeps
	Travel/Aquatic Form ("idem" in the table; the offline test caught the first version guarding it).
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_BLOCK_CLASSES = ns.FOREVER_BLOCK_CLASSES or {}

ns.FOREVER_BLOCK_CLASSES.DRUID = {
	states = {
		{ name = "bear", cond = "[bonusbar:3]", guards = true },
		{ name = "cat", cond = "[bonusbar:1/2]", guards = true },
		{ name = "swim", cond = "[swimming]" },
	},
	baseGuard = "[nobonusbar:1/2/3]",
	-- 27 Nov 2026 (Rob: in Bear Form "veel te snel geneigd om op 2 te drukken ... en dan ga ik uit beervorm" → "akkoord"):
	-- every caster spell gets the guard, also before the key's bear or cat spell is known (ForeverBlock.lua BodyRaw), so
	-- in a form it does nothing. Not guarded (open): the form keys, Travel/Aquatic Form, Nature's Grasp; `all` keys
	-- (Barkskin, Faerie Fire, the race spell) never were. Only the Druid has it; the Rogue's table is unchanged.
	formGuard = true,
	keys = {
		["1"] = { bear = "Maul", cat = "Claw", base = "Wrath" },
		["2"] = { bear = "Lacerate", cat = "Rake", base = "Moonfire" },
		["3"] = { bear = "Primal Bite", cat = "Shred", base = "Starfire" },
		-- 27 Nov 2026 (Rob via Sparring 27-11: "Ja, ik gebruik 12 keer 4 en swipe mag inderdaad op 4."; as a tank Shift-1
		-- needed two fingers): Swipe moved from Shift-1 to 4, where the bear had nothing. Here too, so the texts (How you
		-- play) say one key for every layout.
		["4"] = { bear = "Swipe", cat = "Rip", base = "Insect Swarm" },
		-- 27 Nov 2026 (Rob via Sparring 27-11: "ja ja" on "Ferocious Bite als kat van Shift-4 naar C?"): see C below.
		["5"] = { all = "Faerie Fire" },
		["SHIFT-1"] = { base = "Hurricane" },
		["SHIFT-2"] = { bear = "Demoralizing Roar", base = "Wild Growth" },
		["Q"] = { bear = "Enrage", cat = "Shifting Power", base = "Tranquility" },
		["F1"] = { base = "Innervate" },
		["SHIFT-3"] = { base = "Nature's Swiftness" },
		["SHIFT-F1"] = { base = "Swiftmend" },
		["F3"] = { pair = { cond = "[combat]", first = "Rebirth", second = "Revive" } },
		["E"] = { bear = "Feral Charge", cat = "Feral Charge" },
		["V"] = { bear = "Bash", cat = "Pounce", base = "Entangling Roots" },
		["SHIFT-Q"] = { base = "Hibernate" },
		["SHIFT-F"] = { bear = "Challenging Roar", base = "Soothe Animal" },
		["SHIFT-V"] = { base = "Remove Curse" },
		["SHIFT-C"] = { base = { "Abolish Poison", "Cure Poison" } },
		["R"] = { cat = "Dash", swim = "Aquatic Form", base = "Travel Form", open = true },
		["SHIFT-R"] = { cat = "Prowl" },
		["F"] = { bear = "Growl", cat = "Cower" },
		["Z"] = { all = "Barkskin" },
		["X"] = { bear = "Frenzied Regeneration", base = "Nature's Grasp", open = true },
		["C"] = { cat = "Ferocious Bite", base = "Healing Touch" },
		["F2"] = { base = "Regrowth" },
		["F4"] = { base = "Rejuvenation" },
		["SHIFT-Z"] = { base = "Thorns" },
		["SHIFT-X"] = { base = { "Gift of the Wild", "Mark of the Wild" } },
		-- 26 Nov 2026 (Fable check): + Walk on Air, so a Skyborne Druid gets a race spell here too.
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Walk on Air" } },
		["CTRL-1"] = { open = true, base = { "Dire Bear Form", "Bear Form" } },
		["CTRL-2"] = { open = true, base = "Cat Form" },
		["CTRL-3"] = { open = true, base = "Moonkin Form" },
	},
	toBlockD = { "Teleport: Moonglade", "Track Humanoids", "Ravage", "Elune's Light" },
	-- 12 x 4 (Forever, 24 Nov 2026; /mh block style 12x4). From docs/forever/KEYBLOCK12_DRUID.md (mh-research,
	-- checked by a second helper). Rob via Sparring 24-11: "laat een agent uitzoeken welke spells logisch zijn per class".
	keys12 = {
		["1"] = { bear = "Maul", cat = "Claw", base = "Wrath", why = "main attack in every shape: Wrath, Maul as bear, Claw as cat" },
		["2"] = { bear = "Lacerate", cat = "Rake", base = "Moonfire", why = "rotation: Moonfire, Lacerate as bear, Rake as cat" },
		["3"] = { bear = "Primal Bite", cat = "Shred", base = "Starfire", why = "rotation: Starfire, Primal Bite as bear, Shred from behind" },
		["4"] = { bear = "Swipe", cat = "Rip", base = "Insect Swarm", why = "Swipe hits all enemies in front of the bear; Rip finishes as cat; Insect Swarm as caster" },
		["Q"] = { bear = "Enrage", cat = "Shifting Power", base = "Tranquility", why = "big cooldown: Tranquility, Enrage as bear, Shifting Power as cat" },
		["E"] = { bear = "Feral Charge", cat = "Feral Charge", why = "kick key: Feral Charge stops a cast; a caster druid has none" },
		["R"] = { cat = "Dash", swim = "Aquatic Form", base = "Travel Form", open = true, why = "move: Travel Form, Aquatic Form in water, Dash as cat" },
		["F"] = { bear = "Growl", cat = "Cower", base = "Rejuvenation", why = "Growl taunts as bear; as caster your instant heal Rejuvenation" },
		["Z"] = { all = "Barkskin", why = "small defensive, works in every form" },
		["X"] = { base = "Nature's Grasp", open = true, why = "second defensive: roots what hits you, also in a form" },
		-- 27 Nov 2026 (Rob: "ja ja" on "Ferocious Bite als kat van Shift-4 naar C?"): the cat's finisher without Shift.
		["C"] = { bear = "Frenzied Regeneration", cat = "Ferocious Bite", base = "Healing Touch", why = "Frenzied Regeneration as bear, Ferocious Bite finishes as cat, else Healing Touch" },
		["V"] = { bear = "Bash", cat = "Pounce", base = "Entangling Roots", why = "crowd control: Roots, Bash as bear, Pounce from Prowl" },
		["SHIFT-1"] = { base = "Hurricane", why = "AoE as caster: Hurricane (the bear's Swipe is on 4)" },
		["SHIFT-2"] = { bear = "Demoralizing Roar", base = "Wild Growth", why = "group key: Demoralizing Roar as bear, Wild Growth heals a group" },
		["SHIFT-3"] = { base = "Nature's Swiftness", why = "cooldown: next nature spell is instant, then Healing Touch (C)" },
		["SHIFT-4"] = { base = "Swiftmend", why = "Swiftmend eats your HoT for an instant heal (the cat's Ferocious Bite is on C)" },
		["SHIFT-Q"] = { bear = "Challenging Roar", base = { "Abolish Poison", "Cure Poison" }, why = "bear: group taunt cooldown; caster: remove poison" },
		["SHIFT-E"] = { all = { "Shadowmeld", "War Stomp", "Walk on Air" }, why = "your race spell" },
		["SHIFT-R"] = { cat = "Prowl", base = "Soothe Animal", why = "get past enemies: Prowl as cat, Soothe Animal on a beast" },
		["SHIFT-F"] = { all = "Faerie Fire", why = "pull and weaken, next to Growl; works in almost every form" },
		["SHIFT-Z"] = { base = "Thorns", why = "buff that hurts what hits you: second small defensive" },
		["SHIFT-X"] = { base = { "Gift of the Wild", "Mark of the Wild" }, why = "armor and stats buff, before a fight" },
		["SHIFT-C"] = { base = "Regrowth", why = "quick heal, next to Healing Touch on C" },
		["SHIFT-V"] = { base = "Hibernate", why = "second crowd control: puts a beast or dragonkin to sleep" },
		["CTRL-1"] = { open = true, base = { "Dire Bear Form", "Bear Form" }, why = "Bear Form: the same key in and out" },
		["CTRL-2"] = { open = true, base = "Cat Form", why = "Cat Form: the same key in and out" },
		["CTRL-3"] = { open = true, base = "Moonkin Form", why = "Moonkin Form: the same key in and out" },
		["CTRL-Q"] = { base = "Innervate", why = "mana cooldown, for you or another healer" },
		["CTRL-E"] = { base = "Remove Curse", why = "remove a curse from a friend" },
		["CTRL-R"] = { pair = { cond = "[combat]", first = "Rebirth", second = "Revive" }, why = "bring a friend back: Revive, in a fight Rebirth" },
	},
}
