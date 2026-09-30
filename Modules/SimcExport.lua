local _, ns = ...

--[[
	Midnight Helper — `/mh raidbots`: your character, talents, gear and bag gear as SimulationCraft
	input, to paste on Raidbots Top Gear (raidbots.com/simbot/topgear).

	Rob, 30 Sep 2026: "Doe optie b dan maar". Our Armory scores stats with example weights and cannot
	value a trinket's effect (it swapped his Lost Idol of the Hash'ey for a weaker trinket with
	Strength). Raidbots simulates, so effects, sets and embellishments count. Plan and sources:
	docs/RAIDBOTS_ROUTE.md. Raidbots' terms ban automated access only; the player pastes by hand.

	📌 THE FORMAT IS SIMULATIONCRAFT'S, AND IT MOVES EVERY PATCH. This file follows the
	SimulationCraft addon (github.com/simulationcraft/simc-addon, core.lua + extras.lua, read
	30 Sep 2026 at release 12.1.0-04). That addon is public domain (The Unlicense), so the tables
	below are taken from it as they are. When it ships a new release, compare its
	GetItemStringFromItemLink and GetSimcProfile with the two functions here of the same name:
	a field we miss produces no error, only a sim that is quietly a little wrong.

	Left out on purpose (v1): the upgrade/catalyst currency lines (season data that would need its
	own upkeep), the merchant and linked-gear dumps (debug features), and the 11.1.7 belt.

	VERIFY in the game: everything. Nothing here is measured yet; the first real paste on Raidbots
	is the test (docs/TESTLIJST.md).
]]

-- Item string field positions (simc-addon core.lua).
local OFFSET_ITEM_ID = 1
local OFFSET_ENCHANT_ID = 2
local OFFSET_GEM_ID_1 = 3
local OFFSET_GEM_ID_4 = 6
local OFFSET_BONUS_ID = 13
local OFFSET_GEM_BONUS_FROM_MODS = 2

-- Item modifier types (warcraft.wiki.gg ItemLink#Item_Modifiers, as simc-addon reads them).
local ITEM_MOD_TYPE_DROP_LEVEL = 9
local ITEM_MOD_TYPE_CONTENT_TUNING = 28
local ITEM_MOD_TYPE_CRAFT_STATS_1 = 29
local ITEM_MOD_TYPE_CRAFT_STATS_2 = 30
local ITEM_MOD_TYPE_REDIRECTED_BASE_STATS = 64

-- The talent export string version simc-addon supports. Another number means Blizzard changed
-- the format; we then say so instead of writing talents Raidbots would misread.
local SUPPORTED_LOADOUT_SERIALIZATION_VERSION = 2

-- Extra trait systems simc-addon exports next to class talents (12.0.7 player power).
local TRAIT_SYSTEMS = {
	{ name = "omnium_talents", systemID = 48 },
}

local ROLE_BY_SPEC = {
	[250] = "tank", [251] = "attack", [252] = "attack",
	[577] = "attack", [581] = "tank", [1480] = "spell",
	[102] = "spell", [103] = "attack", [104] = "tank",
	[1467] = "spell", [1468] = "attack",
	[253] = "attack", [254] = "attack", [255] = "attack",
	[62] = "spell", [63] = "spell", [64] = "spell",
	[268] = "tank", [269] = "attack", [270] = "attack",
	[65] = "attack", [66] = "tank", [70] = "attack",
	[256] = "spell", [257] = "attack", [258] = "spell",
	[259] = "attack", [260] = "attack", [261] = "attack",
	[262] = "spell", [263] = "attack", [264] = "attack",
	[265] = "spell", [266] = "spell", [267] = "spell",
	[71] = "attack", [72] = "attack", [73] = "tank",
}

-- Non-localised spec names, because the client's own are translated.
local SPEC_NAMES = {
	[250] = "Blood", [251] = "Frost", [252] = "Unholy",
	[577] = "Havoc", [581] = "Vengeance", [1480] = "Devourer",
	[102] = "Balance", [103] = "Feral", [104] = "Guardian", [105] = "Restoration",
	[1473] = "Augmentation", [1467] = "Devastation", [1468] = "Preservation",
	[253] = "Beast Mastery", [254] = "Marksmanship", [255] = "Survival",
	[62] = "Arcane", [63] = "Fire", [64] = "Frost",
	[268] = "Brewmaster", [269] = "Windwalker", [270] = "Mistweaver",
	[65] = "Holy", [66] = "Protection", [70] = "Retribution",
	[256] = "Discipline", [257] = "Holy", [258] = "Shadow",
	[259] = "Assassination", [260] = "Outlaw", [261] = "Subtlety",
	[262] = "Elemental", [263] = "Enhancement", [264] = "Restoration",
	[265] = "Affliction", [266] = "Demonology", [267] = "Destruction",
	[71] = "Arms", [72] = "Fury", [73] = "Protection",
}

local PROF_NAMES = {
	[129] = "First Aid", [164] = "Blacksmithing", [165] = "Leatherworking", [171] = "Alchemy",
	[182] = "Herbalism", [184] = "Cooking", [186] = "Mining", [197] = "Tailoring",
	[202] = "Engineering", [333] = "Enchanting", [356] = "Fishing", [393] = "Skinning",
	[755] = "Jewelcrafting", [773] = "Inscription", [794] = "Archaeology",
}

local REGION_BY_ID = { [1] = "us", [2] = "kr", [3] = "eu", [4] = "tw", [5] = "cn", [72] = "tr" }

-- simc-addon's slot numbers (not inventory slot ids), their inventory slot names and SimC names.
local SLOT_NAMES = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot",
	"Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot",
}
local SIMC_SLOT_NAMES = {
	"head", "neck", "shoulder", "back", "chest", "shirt", "tabard", "wrist", "hands", "waist",
	"legs", "feet", "finger1", "finger2", "trinket1", "trinket2", "main_hand", "off_hand",
}
local INVTYPE_TO_SLOT = {
	INVTYPE_HEAD = 1, INVTYPE_NECK = 2, INVTYPE_SHOULDER = 3, INVTYPE_CLOAK = 4,
	INVTYPE_CHEST = 5, INVTYPE_ROBE = 5, INVTYPE_BODY = 6, INVTYPE_TABARD = 7,
	INVTYPE_WRIST = 8, INVTYPE_HAND = 9, INVTYPE_WAIST = 10, INVTYPE_LEGS = 11, INVTYPE_FEET = 12,
	INVTYPE_FINGER = 13, INVTYPE_TRINKET = 15,
	INVTYPE_WEAPON = 17, INVTYPE_2HWEAPON = 17, INVTYPE_RANGED = 17, INVTYPE_RANGEDRIGHT = 17,
	INVTYPE_SHIELD = 18, INVTYPE_HOLDABLE = 18,
	INVTYPE_WEAPONMAINHAND = 17, INVTYPE_WEAPONOFFHAND = 18, INVTYPE_THROWN = 17,
}

local ZANDALARI_LOA = {
	[292359] = "akunda", [292360] = "bwonsamdi", [292362] = "gonk",
	[292363] = "kimbul", [292364] = "kragwa", [292361] = "paku",
}

--------------------------------------------------------------------------------
-- Helpers (simc-addon's, same behaviour)
--------------------------------------------------------------------------------

local function Call(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, a, b, c, d, e, f, g, h, i, j, k = pcall(fn, ...)
	if ok then
		return a, b, c, d, e, f, g, h, i, j, k
	end
	return nil
end

local function ItemSplit(itemLink)
	local itemString = itemLink:match("item:([%-?%d:]+)")
	local out = {}
	if not itemString then
		return out
	end
	for _, v in ipairs({ strsplit(":", itemString) }) do
		out[#out + 1] = (v == "" and 0) or tonumber(v) or 0
	end
	return out
end

local function Trim(s)
	return (s:match("^%s*(.-)%s*$"))
end

local function ItemName(itemLink)
	local name = itemLink:match("|h%[(.*)%]|")
	if not name then
		return nil
	end
	local trimmed = Trim((name:gsub("|%a.+|%a", "")))
	if trimmed:match("^%s*$") then
		return nil
	end
	return trimmed
end

local function ChrSize(b)
	if not b then
		return 0
	elseif b > 240 then
		return 4
	elseif b > 225 then
		return 3
	elseif b > 192 then
		return 2
	end
	return 1
end

--- SimC's tokenizer: lower case, spaces to "_", keep 0-9 a-z % + . _ and multibyte characters.
local function Tokenize(str)
	str = tostring(str or ""):lower():gsub(" ", "_")
	local out, i = {}, 1
	while i <= #str do
		local b = str:byte(i)
		if (b >= 48 and b <= 57) or (b >= 97 and b <= 122) or b == 37 or b == 43 or b == 46 or b == 95 then
			out[#out + 1] = str:sub(i, i)
			i = i + 1
		elseif ChrSize(b) > 1 then
			local n = ChrSize(b)
			out[#out + 1] = str:sub(i, i + n - 1)
			i = i + n
		else
			i = i + 1
		end
	end
	local s = table.concat(out)
	if s:sub(-1) == "_" then
		s = s:sub(1, -2)
	end
	return s
end

--- "BloodElf" -> "Blood Elf", so the tokenizer makes "blood_elf".
local function FormatRace(str)
	local parts = {}
	for word in tostring(str or ""):gmatch("(%u%l*)") do
		parts[#parts + 1] = word
	end
	return table.concat(parts, " ")
end

--- Adler-32 over the text, exactly as simc-addon computes it (including its bit.lshift), so the
--- "# Checksum:" line matches what Raidbots expects from that addon.
local function Adler32(s)
	local prime = 65521
	local s1, s2 = 1, 0
	for i = 1, #s do
		s1 = s1 + s:byte(i)
		s2 = s2 + s1
	end
	s1 = s1 % prime
	s2 = s2 % prime
	if bit and bit.lshift then
		return bit.lshift(s2, 16) + s1
	end
	return s2 * 65536 + s1
end

--------------------------------------------------------------------------------
-- Items
--------------------------------------------------------------------------------

--- simc-addon's GetItemStringFromItemLink, without the 11.1.7 belt and the debug lines.
local function ItemString(slotNum, itemLink)
	local split = ItemSplit(itemLink)
	local opts = {}
	local itemId = split[OFFSET_ITEM_ID] or 0
	opts[#opts + 1] = ",id=" .. itemId

	if (split[OFFSET_ENCHANT_ID] or 0) > 0 then
		opts[#opts + 1] = "enchant_id=" .. split[OFFSET_ENCHANT_ID]
	end

	local gems = {}
	for off = OFFSET_GEM_ID_1, OFFSET_GEM_ID_4 do
		gems[#gems + 1] = (split[off] or 0) > 0 and split[off] or 0
	end
	while #gems > 0 and gems[#gems] == 0 do
		table.remove(gems)
	end
	if #gems > 0 then
		opts[#opts + 1] = "gem_id=" .. table.concat(gems, "/")
	end

	local bonuses = {}
	for i = 1, (split[OFFSET_BONUS_ID] or 0) do
		bonuses[#bonuses + 1] = split[OFFSET_BONUS_ID + i]
	end
	if #bonuses > 0 then
		opts[#opts + 1] = "bonus_id=" .. table.concat(bonuses, "/")
	end

	-- After the bonus ids: a count, then (type, value) pairs.
	local linkOffset = OFFSET_BONUS_ID + #bonuses + 1
	local crafted = {}
	local numPairs = split[linkOffset] or 0
	for i = 1, numPairs do
		local p = 1 + linkOffset + 2 * (i - 1)
		local kind, value = split[p], split[p + 1]
		if kind == ITEM_MOD_TYPE_DROP_LEVEL then
			opts[#opts + 1] = "drop_level=" .. value
		elseif kind == ITEM_MOD_TYPE_CONTENT_TUNING then
			opts[#opts + 1] = "content_tuning=" .. value
		elseif kind == ITEM_MOD_TYPE_CRAFT_STATS_1 or kind == ITEM_MOD_TYPE_CRAFT_STATS_2 then
			crafted[#crafted + 1] = value
		elseif kind == ITEM_MOD_TYPE_REDIRECTED_BASE_STATS then
			opts[#opts + 1] = "redirected_base_stats=" .. value
		end
	end
	if #crafted > 0 then
		opts[#opts + 1] = "crafted_stats=" .. table.concat(crafted, "/")
	end

	local gemBonusOffset = linkOffset + 2 * numPairs + OFFSET_GEM_BONUS_FROM_MODS
	local gemBonuses = {}
	for i = 1, (split[gemBonusOffset] or 0) do
		gemBonuses[i] = split[gemBonusOffset + i]
	end
	if #gemBonuses > 0 then
		opts[#opts + 1] = "gem_bonus_id=" .. table.concat(gemBonuses, "/")
	end

	local quality = C_TradeSkillUI and Call(C_TradeSkillUI.GetItemCraftedQualityByItemInfo, itemLink)
	if quality then
		opts[#opts + 1] = "crafting_quality=" .. quality
	end

	return (SIMC_SLOT_NAMES[slotNum] or "unknown") .. "=" .. table.concat(opts, ",")
end

local function ItemLevel(link)
	return Call(C_Item and C_Item.GetDetailedItemLevelInfo, link)
end

local function Comment(link)
	local name, level = ItemName(link), ItemLevel(link)
	if name and level then
		return name .. " (" .. level .. ")"
	end
	return nil
end

local function Equipped()
	local out = {}
	for slotNum, slotName in ipairs(SLOT_NAMES) do
		local slotId = Call(GetInventorySlotInfo, slotName)
		local link = slotId and Call(GetInventoryItemLink, "player", slotId)
		if type(link) == "string" and ns.CanAccessText(link) then
			out[slotNum] = { str = ItemString(slotNum, link), name = Comment(link) }
		end
	end
	return out
end

--- Bags, and the bank and warband bank as far as the client has them (simc-addon's range).
local function BagItems()
	local out = {}
	local CC = C_Container
	if not (CC and CC.GetContainerNumSlots and CC.GetContainerItemID and CC.GetContainerItemLink) then
		return out
	end
	local inv = Constants and Constants.InventoryConstants
	local last = 4
	if inv and inv.NumCharacterBankSlots then
		last = 1 + (inv.NumBagSlots or 4) + (inv.NumReagentBagSlots or 1)
			+ inv.NumCharacterBankSlots + (inv.NumAccountBankSlots or 0)
	end
	for bag = 0, last do
		for slot = 1, (Call(CC.GetContainerNumSlots, bag) or 0) do
			local itemId = Call(CC.GetContainerItemID, bag, slot)
			if itemId then
				local _, _, _, loc = Call(C_Item and C_Item.GetItemInfoInstant, itemId)
				local slotNum = loc and INVTYPE_TO_SLOT[loc]
				local link = slotNum and Call(CC.GetContainerItemLink, bag, slot)
				if type(link) == "string" and ns.CanAccessText(link) then
					out[#out + 1] = { str = ItemString(slotNum, link), name = Comment(link), slotNum = slotNum }
				end
			end
		end
	end
	table.sort(out, function(a, b)
		return a.slotNum < b.slotNum
	end)
	return out
end

--- Great Vault choices, when there are any to pick from.
local function VaultItems()
	local out = {}
	local WR = C_WeeklyRewards
	if not (WR and WR.HasAvailableRewards and Call(WR.HasAvailableRewards)) then
		return out
	end
	for _, activity in ipairs(Call(WR.GetActivities) or {}) do
		for _, reward in ipairs(activity.rewards or {}) do
			if reward.itemDBID then
				local _, _, _, loc = Call(C_Item and C_Item.GetItemInfoInstant, reward.id)
				local link = Call(WR.GetItemHyperlink, reward.itemDBID)
				local slotNum = loc and INVTYPE_TO_SLOT[loc]
				if type(link) == "string" and slotNum then
					out[#out + 1] = { str = ItemString(slotNum, link), name = Comment(link) }
				end
			end
		end
	end
	return out
end

--------------------------------------------------------------------------------
-- Talents
--------------------------------------------------------------------------------

local function LoadoutLine(configID)
	local CT, TR = C_ClassTalents, C_Traits
	local s = TR and Call(TR.GenerateImportString, configID)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	local line = "talents=" .. s
	if configID ~= (CT and Call(CT.GetActiveConfigID)) then
		local info = Call(TR.GetConfigInfo, configID)
		local name = info and info.name and tostring(info.name):gsub("||", "|") or "?"
		line = "# Saved Loadout: " .. name .. "\n# " .. line
	end
	return line
end

local function TraitLine(optionName, configID)
	local TR = C_Traits
	local info = configID and TR and Call(TR.GetConfigInfo, configID)
	if not (info and info.treeIDs) then
		return nil
	end
	local entries = {}
	for _, treeID in ipairs(info.treeIDs) do
		for _, nodeID in ipairs(Call(TR.GetTreeNodes, treeID) or {}) do
			local node = Call(TR.GetNodeInfo, configID, nodeID)
			if node and node.ranksPurchased and node.ranksPurchased > 0 and node.activeEntry then
				entries[#entries + 1] = node.activeEntry.entryID .. ":" .. node.activeEntry.rank
			end
		end
	end
	if #entries == 0 then
		return nil
	end
	return optionName .. "=" .. table.concat(entries, "/")
end

--------------------------------------------------------------------------------
-- The profile
--------------------------------------------------------------------------------

--- @return string|nil text, string|nil problem (a sentence for the player when the export is unusable)
function ns.BuildSimcProfile()
	local lines = {}
	local function add(s)
		lines[#lines + 1] = s
	end

	local version = (C_AddOns and Call(C_AddOns.GetAddOnMetadata, "MidnightHelper", "Version")) or "?"
	local wowVersion, wowBuild, _, wowToc = GetBuildInfo()
	local name = UnitName("player") or "?"
	local _, classFile = UnitClass("player")
	local level = UnitLevel("player")
	local realm = GetRealmName and GetRealmName() or "?"
	local region = (GetCurrentRegionName and Call(GetCurrentRegionName))
		or REGION_BY_ID[GetCurrentRegion and Call(GetCurrentRegion) or 0] or "us"

	local _, raceFile = UnitRace("player")
	local race = raceFile == "Scourge" and "Undead" or FormatRace(raceFile)

	local SI = C_SpecializationInfo
	local specIndex = SI and Call(SI.GetSpecialization) or (GetSpecialization and GetSpecialization())
	local specID, roleName
	if specIndex then
		local getInfo = SI and SI.GetSpecializationInfo or GetSpecializationInfo
		local a, _, _, _, _, f = Call(getInfo, specIndex)
		specID, roleName = a, f
	end
	if not specID then
		return nil, "nospec"
	end
	local specName = SPEC_NAMES[specID] or "unknown"
	local lootSpec = GetLootSpecialization and Call(GetLootSpecialization) or 0
	if lootSpec == 0 then
		lootSpec = specID
	end
	local role = ROLE_BY_SPEC[specID]
		or (roleName == "TANK" and "tank") or ((roleName == "DAMAGER" or roleName == "HEALER") and "attack") or ""

	local profs = {}
	local p1, p2 = Call(GetProfessions)
	for _, pid in ipairs({ p1 or false, p2 or false }) do
		if pid then
			local _, _, rank, _, _, _, skillLine = Call(GetProfessionInfo, pid)
			if PROF_NAMES[skillLine] then
				profs[#profs + 1] = Tokenize(PROF_NAMES[skillLine]) .. "=" .. tostring(rank)
			end
		end
	end

	add("# " .. name .. " - " .. specName .. " - " .. date("%Y-%m-%d %H:%M") .. " - " .. region .. "/" .. realm)
	add("# Midnight Helper " .. version .. " (SimulationCraft addon format, 12.1.0-04)")
	add("# WoW " .. wowVersion .. "." .. wowBuild .. ", TOC " .. wowToc)
	add("# Requires SimulationCraft 1000-01 or newer")
	add("")
	add(Tokenize(classFile) .. '="' .. name .. '"')
	add("level=" .. level)
	add("race=" .. Tokenize(race))
	if Tokenize(race) == "zandalari_troll" and C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
		for spellId, loa in pairs(ZANDALARI_LOA) do
			if Call(C_UnitAuras.GetPlayerAuraBySpellID, spellId) then
				add("zandalari_loa=" .. loa)
				break
			end
		end
	end
	add("region=" .. Tokenize(region))
	add("server=" .. Tokenize(realm))
	add("role=" .. role)
	add(#profs > 0 and ("professions=" .. table.concat(profs, "/")) or "")
	add("spec=" .. Tokenize(specName))
	add("# loot_spec=" .. Tokenize(SPEC_NAMES[lootSpec] or specName))
	add("")

	-- Talents: the client's own export string, as simc-addon does since 12.1.0-04.
	local CT, TR = C_ClassTalents, C_Traits
	local problem
	if CT and TR then
		local ver = Call(TR.GetLoadoutSerializationVersion)
		if ver and ver ~= SUPPORTED_LOADOUT_SERIALIZATION_VERSION then
			problem = "talentversion"
		end
		local active = Call(CT.GetActiveConfigID)
		local line = active and LoadoutLine(active)
		add(line or "# Unable to export talents - no talent data from the client yet, try again")
		add("")
		for _, configID in pairs(Call(CT.GetConfigIDsBySpecID, specID) or {}) do
			local saved = LoadoutLine(configID)
			if saved then
				add(saved)
			end
		end
	end
	if TR and TR.GetConfigIDBySystemID then
		local first = true
		for _, system in ipairs(TRAIT_SYSTEMS) do
			local line = TraitLine(system.name, Call(TR.GetConfigIDBySystemID, system.systemID))
			if line then
				if first then
					add("")
					first = false
				end
				add(line)
			end
		end
	end
	add("")

	local equipped = Equipped()
	for slotNum = 1, #SLOT_NAMES do
		local item = equipped[slotNum]
		if item then
			if item.name then
				add("# " .. item.name)
			end
			add(item.str)
		end
	end

	local bags = BagItems()
	if #bags > 0 then
		add("")
		add("### Gear from Bags")
		for _, item in ipairs(bags) do
			add("#")
			if item.name and item.name ~= "" then
				add("# " .. item.name)
			end
			add("# " .. item.str)
		end
	end

	local vault = VaultItems()
	if #vault > 0 then
		add("")
		add("### Weekly Reward Choices")
		for _, item in ipairs(vault) do
			add("#")
			if item.name then
				add("# " .. item.name)
			end
			add("# " .. item.str)
		end
		add("#")
		add("### End of Weekly Reward Choices")
	end

	add("")
	local text = table.concat(lines, "\n") .. "\n"
	text = text .. ("# Checksum: %x"):format(Adler32(text))
	return text, problem, #bags
end

--------------------------------------------------------------------------------
-- `/mh raidbots`
--------------------------------------------------------------------------------

-- For the offline test (tools: a plain Lua run against known SimulationCraft output).
ns._simcTest = { ItemString = ItemString, Tokenize = Tokenize, Adler32 = Adler32, FormatRace = FormatRace }

local shown = 0

function ns.ShowSimcExport()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local text, problem, bagCount = ns.BuildSimcProfile()
	if not text then
		print(prefix .. " " .. ns:L("RAIDBOTS_NOSPEC"))
		return
	end
	if problem == "talentversion" then
		print(prefix .. " " .. ns:L("RAIDBOTS_TALENTVERSION"))
	end
	if not ns.ShowShareCopyDialog then
		print(text)
		return
	end
	shown = shown + 1
	-- "|" is WoW's escape character in an edit box; doubled it shows and copies as one.
	ns.ShowShareCopyDialog({
		id = "raidbots:" .. shown,
		text = (text:gsub("|", "||")),
		titleKey = "RAIDBOTS_TITLE",
		hintKey = "RAIDBOTS_HINT",
		closeKey = "DELVE_SHARE_COPY_CLOSE",
		width = 620,
		height = 420,
	})
	print(prefix .. " " .. ns:L("RAIDBOTS_DONE_FMT"):format(bagCount or 0))
end
