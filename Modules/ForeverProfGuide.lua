local _, ns = ...

--[[
	ForeverProfGuide.lua — WoW Forever: a short card per profession, on top of the "Profession trainers" window, and
	"room for a main profession" for "Do this now".

	Rob, 12 Nov 2026 (O26; via sparring, verbatim): "A, eerst klein". Source for every line:
	docs/forever/BEROEPEN_2026-11-12.md (mh-research, Forever 1.60.1.70888). Rules from sparring, kept here:
	  - GEMETEN, said plainly: what the profession does (Wowhead Forever tooltips), main or secondary (DB2 SkillLine),
	    the tool where it was measured, the rank caps 75/150/225/300 and the skill for the next rank (50/125/200).
	  - Player guides (Warcraft Tavern), always said as such: "pairs with", the character level per rank, and for the
	    secondary professions what comes after skill 150 (book, then quest). That trainers teach them to 150 is ALSO in
	    MH's own trainer data (ForeverProfTrainerSpots.lua, max = 150), so that part is said plainly.
	  - Left out because the research marks it AFGELEID or not measured: costs (3 of 12), Fishing's caps (no maximum in its
	    tooltip), a tool line for Leatherworking ("none in the recipes measured") and First Aid, the tool NAMES for
	    Enchanting and Engineering (their localized names were not measured), and Cooking's campfire (that is Camping,
	    version B).
	  - Not in this version: Camping, which profession fits a direction, Comprehension, Poisons, recipes.
	The trainer-title note (a "Journeyman" trainer teaches up to 75) is GEMETEN in ForeverProfTrainerSpots.lua's own
	notes (Wowhead, 8 Nov) and the research (Kylanna Windwhisper).
	Names the player sees: professions through ns.ForeverProfName (the client's own), tools through the vendor list
	(item names from the client).
]]

if not ns.IS_FOREVER then
	return
end

local PRIMARY = { ALCHEMY = true, BLACKSMITHING = true, ENCHANTING = true, ENGINEERING = true, HERBALISM = true,
	LEATHERWORKING = true, MINING = true, SKINNING = true, TAILORING = true }

-- tool = ForeverVendors.lua category key (button "Where to buy" + the client's item name); toolText = a sentence key
-- instead of a named tool; pairs = profession keys the guides pair it with.
local INFO = {
	ALCHEMY = { pairs = { "HERBALISM" }, toolText = "FPROFG_TOOL_NONE_FIXED" },
	BLACKSMITHING = { pairs = { "MINING" }, tool = "hammer" },
	ENCHANTING = { pairs = { "TAILORING" }, toolText = "FPROFG_TOOL_SOME" },
	ENGINEERING = { pairs = { "MINING" }, toolText = "FPROFG_TOOL_SOME" },
	HERBALISM = { pairs = { "ALCHEMY" }, toolText = "FPROFG_TOOL_NONE" },
	LEATHERWORKING = { pairs = { "SKINNING" } },
	MINING = { pairs = { "BLACKSMITHING", "ENGINEERING" }, tool = "mining" },
	SKINNING = { pairs = { "LEATHERWORKING" }, tool = "skinning" },
	TAILORING = { pairs = { "ENCHANTING" }, toolText = "FPROFG_TOOL_NONE" },
	COOKING = { pairs = { "FISHING" }, secondary = true },
	FIRSTAID = { secondary = true },
	FISHING = { pairs = { "COOKING" }, tool = "fishing", secondary = true, noCaps = true },
}

local HEAD, GREY = "|cffffcc66", "|cff9d9d9d"

--- How many main professions this character has, read two ways; nil when they disagree (then we say nothing).
--- (1) GetProfessions' first two slots (the client's own main-profession slots; that Forever keeps that order is
--- AFGELEID), (2) the main professions MH recognises by skill line (ns.ForeverMyProfessions).
function ns.ForeverPrimaryCount()
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local byKey = 0
	for k in pairs(mine) do
		if PRIMARY[k] then
			byKey = byKey + 1
		end
	end
	local bySlot
	if GetProfessions then
		local ok, p1, p2 = pcall(GetProfessions)
		if ok then
			bySlot = (p1 and 1 or 0) + (p2 and 1 or 0)
		end
	end
	if bySlot == nil then
		return nil, ("GetProfessions unreadable; by skill line %d"):format(byKey)
	end
	if bySlot ~= byKey then
		return nil, ("the two readings disagree (slots %d, skill lines %d)"):format(bySlot, byKey)
	end
	return byKey, ("slots %d = skill lines %d"):format(bySlot, byKey)
end

--- The card text for one profession, and the vendor key for its tool (or nil).
function ns.ForeverProfCard(key)
	local info = INFO[key]
	if not info then
		return nil
	end
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local L = {}
	L[#L + 1] = ns:L("FPROFG_DOES_" .. key)
	if PRIMARY[key] then
		local s = ns:L("FPROFG_KIND_MAIN")
		local n = ns.ForeverPrimaryCount()
		if n then
			s = s .. " " .. ns:L("FPROFG_MAIN_HAVE_FMT"):format(n)
		end
		L[#L + 1] = s
	else
		L[#L + 1] = ns:L("FPROFG_KIND_SECONDARY")
	end
	if info.tool then
		local toolName = ns.ForeverVendorItemName and ns.ForeverVendorItemName(info.tool)
		if toolName then
			L[#L + 1] = ns:L("FPROFG_TOOL_FMT"):format(toolName)
		end
	elseif info.toolText then
		L[#L + 1] = ns:L(info.toolText)
	end
	if info.pairs then
		local names = {}
		for _, p in ipairs(info.pairs) do
			names[#names + 1] = ns.ForeverProfName and ns.ForeverProfName(p, mine) or p
		end
		L[#L + 1] = ns:L("FPROFG_PAIRS_FMT"):format(table.concat(names, " / "))
	end
	if not info.noCaps then
		L[#L + 1] = ns:L("FPROFG_CAPS")
	end
	local m = mine[key]
	if m and m.rank and m.maxRank and not info.noCaps then
		if m.maxRank < 300 and m.rank >= m.maxRank - 25 then
			L[#L + 1] = ns:L("FPROFG_YOU_READY_FMT"):format(m.rank, m.maxRank)
		elseif m.maxRank < 300 then
			L[#L + 1] = ns:L("FPROFG_YOU_NEXT_FMT"):format(m.rank, m.maxRank, m.maxRank - 25)
		else
			L[#L + 1] = ns:L("FPROFG_YOU_FMT"):format(m.rank, m.maxRank)
		end
	end
	if info.secondary then
		L[#L + 1] = ns:L("FPROFG_SECONDARY_150")
	elseif not info.noCaps then
		L[#L + 1] = ns:L("FPROFG_LEVELS")
	end
	local out = {}
	for i, s in ipairs(L) do
		out[#out + 1] = (i == 1) and (HEAD .. s .. "|r") or ("- " .. s)
	end
	out[#out + 1] = GREY .. ns:L("FPROFG_TITLE_NOTE") .. "|r"
	return table.concat(out, "\n"), info.tool
end
