local addonName, ns = ...
ns.KeybindRoleClassifierGlobal = ns.KeybindRoleClassifierGlobal or {}

--[[
	Midnight Helper — racials, for the anchor the standard promised and the code never had.

	`KEYBIND_STANDARD_v6.md` §3 reserves **Shift+E** for your racial. It has said so since
	the standard was written, and nothing in `KeybindSchema.lua` ever implemented it — one
	of four places where the document and the code disagreed, found on 6 Aug 2026. Rob's
	own auto-map listed Ancestral Call under "unclassified" for exactly this reason.

	WHY A CATEGORY WITH ONE SLOT AND NOT A ROLE. A role resolves to a single base key, and
	`Shift+E` is not a base key. A category whose slot list is `{ "E" }` gets the same
	result honestly: `E` belongs to the interrupt role, roles are allocated first, so the
	racial overflows to `Shift+E` — which is precisely what the document describes. A
	second active racial lands on `Ctrl+E`.

	⚠️ IDS ARE COPIED, NOT REMEMBERED. Every id below comes from LibOpenRaid's Midnight
	table (ExwindCore/libs/LibOpenRaid/ThingsToMantain_Midnight.lua), which lists each
	racial with its spell id, its race and its cooldown. Nothing here was typed from
	memory. Entries LibOpenRaid keeps commented out — Make Camp, Two Forms, Glide,
	Cannibalize and the other out-of-combat ones — are deliberately absent: a keyboard
	layout is for things you press in a fight.

	NOTE ON PRIORITY. All the same, because a character has one or two of these and they
	never compete with each other. The allocator's tiebreak decides, deterministically.
]]

local RACIALS = {
	-- Damage / stat cooldowns
	{ "Blood Fury", 20572 },                        -- Orc
	{ "Berserking", 26297 },                        -- Troll
	{ "Ancestral Call", 274738 },                   -- Mag'har Orc
	{ "Fireblood", 265221 },                        -- Dark Iron Dwarf
	{ "Arcane Torrent", 232633 },                   -- Blood Elf
	{ "Arcane Pulse", 260364 },                     -- Nightborne
	{ "Light's Judgment", 255647 },                 -- Lightforged Draenei
	{ "Bag of Tricks", 312411 },                    -- Vulpera
	{ "Hyper Organic Light Originator", 312924 },   -- Mechagnome
	{ "Rocket Barrage", 69041 },                    -- Goblin
	{ "Haymaker", 287712 },                         -- Kul Tiran
	{ "Bull Rush", 255654 },                        -- Highmountain Tauren
	{ "War Stomp", 20549 },                         -- Tauren
	{ "Quaking Palm", 107079 },                     -- Pandaren
	{ "Tail Swipe", 368970 },                       -- Dracthyr
	{ "Wing Buffet", 357214 },                      -- Dracthyr
	-- Defensive / escape
	{ "Stoneform", 20594 },                         -- Dwarf
	{ "Gift of the Naaru", 59542 },                 -- Draenei
	{ "Shadowmeld", 58984 },                        -- Night Elf
	{ "Darkflight", 68992 },                        -- Worgen
	{ "Rocket Jump", 69070 },                       -- Goblin
	{ "Spatial Rift", 256948 },                     -- Void Elf
	{ "Escape Artist", 20589 },                     -- Gnome
	{ "Will to Survive", 59752 },                   -- Human
	{ "Will of the Forsaken", 7744 },               -- Undead
	{ "Regeneratin'", 291944 },                     -- Zandalari Troll
}

for i = 1, #RACIALS do
	local name, id = RACIALS[i][1], RACIALS[i][2]
	-- Never overwrite a class table's own entry: a class that has deliberately given one
	-- of these a different home keeps it.
	if not ns.KeybindRoleClassifierGlobal[name] then
		ns.KeybindRoleClassifierGlobal[name] = { id = id, category = "racial", priority = 5 }
	end
end
