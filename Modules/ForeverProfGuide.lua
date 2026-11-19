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
	  - Not in this version: Camping, which profession fits a direction, Poisons, recipes. (Comprehension: since 19 Nov
	    2026, CompCard below, mages only.)
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

--------------------------------------------------------------------------------
-- Comprehension, the mage's own scroll skill (19 Nov 2026; Rob via sparring: "En dat comprehensive kaartje. Ik heb
-- inmiddels inderdaad de knop gevonden. Maar dit verrast mij. En ik heb het ook nergens bij ons in onze add-on gezien.").
-- Only what is MEASURED (GEMETEN Forever DB2 1.60.1.70959 unless said): SkillLine 3012, mage only, from level 6
-- (SkillRaceClassInfo 2551); Comprehend Scroll 1296017 at the mage trainer, level 6 (MH's trainer data); 17 untranslated
-- scrolls with RequiredSkill 3012 at skill 1 / 15 / 50 / 175 (ItemSparse, list below); Study 1302508: a library, a
-- Light Feather, 1 hour (Wowhead tooltip, docs/forever/BEROEPEN_2026-11-12.md). The General tab of the spellbook: where
-- Rob found it (his report, 19 Nov). Left out: what each scroll does, the decipher time (sources disagree; DB2 cast
-- index 1), how fast the skill rises, and which city has a library (one guide only).
--------------------------------------------------------------------------------
ns.FOREVER_COMP_SCROLLS = { 211780, 211785, 211786, 211787, 211784, 211853, 211854, 211855, 213543, 213544, 213545,
	213546, 213547, 281015, 281016, 281017, 281018 }
ns.FOREVER_COMP_SPELLS = { 1296017, 1309965, 1309973, 1310029, 1310030 } -- Comprehend Scroll, every id (ForeverSpellIds)

function ns.ForeverKnowsComprehend()
	for _, id in ipairs(ns.FOREVER_COMP_SPELLS) do
		if IsPlayerSpell and select(2, pcall(IsPlayerSpell, id)) == true then
			return true
		end
		if IsSpellKnown and select(2, pcall(IsSpellKnown, id)) == true then
			return true
		end
	end
	return false
end

--- How many untranslated scrolls are in your bags, and the first one's id.
function ns.ForeverCompScrollsCarried()
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return 0
	end
	local n, first = 0, nil
	for _, id in ipairs(ns.FOREVER_COMP_SCROLLS) do
		local ok, c = pcall(fn, id)
		c = ok and tonumber(c) or 0
		if c > 0 then
			n = n + c
			first = first or id
		end
	end
	return n, first
end

--- The skill's name as this client shows it (C_TradeSkillUI, like ForeverProfName), English when it does not say.
function ns.ForeverCompName()
	if C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillDisplayName then
		local ok, nm = pcall(C_TradeSkillUI.GetTradeSkillDisplayName, 3012)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return "Comprehension"
end

--- The name of the spellbook's first tab as this client shows it (Rob found the spell in "General"), else GENERAL.
function ns.ForeverSpellbookGeneralTab()
	if C_SpellBook and C_SpellBook.GetSpellBookSkillLineInfo then
		local ok, line = pcall(C_SpellBook.GetSpellBookSkillLineInfo, 1)
		local nm = ok and type(line) == "table" and line.name
		if type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return (type(GENERAL) == "string" and GENERAL ~= "" and GENERAL) or "General"
end

local function CompCard()
	local spell = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(1296017)) or "Comprehend Scroll"
	-- The example scroll by its client name (item 211780, GEMETEN ItemSparse: "Scroll: KWYJIBO" in English).
	local example = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(211780)) or "Scroll: KWYJIBO"
	local L = { ns:L("FPROFG_COMP_DOES_FMT"):format(example) }
	if ns.ForeverKnowsComprehend() then
		L[#L + 1] = ns:L("FPROFG_COMP_KNOWN_FMT"):format(spell)
	else
		L[#L + 1] = ns:L("FPROFG_COMP_LEARN_FMT"):format(spell)
	end
	L[#L + 1] = ns:L("FPROFG_COMP_USE_FMT"):format(spell, ns.ForeverSpellbookGeneralTab())
	L[#L + 1] = ns:L("FPROFG_COMP_TIERS")
	local study = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(1302508)) or "Study"
	-- Light Feather = item 17056 (GEMETEN ItemSparse); its name from the client, English until it is cached.
	local feather = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(17056)) or "Light Feather"
	L[#L + 1] = ns:L("FPROFG_COMP_STUDY_FMT"):format(study, feather)
	local n = ns.ForeverCompScrollsCarried()
	if n > 0 then
		L[#L + 1] = "|cff8fd47a" .. ns:L("FPROFG_COMP_CARRY_FMT"):format(n) .. "|r"
	end
	local out = {}
	for i, s in ipairs(L) do
		out[#out + 1] = (i == 1) and (HEAD .. s .. "|r") or ("- " .. s)
	end
	return table.concat(out, "\n")
end

--- The card text for one profession, and the vendor key for its tool (or nil).
function ns.ForeverProfCard(key)
	if key == "COMPREHENSION" then
		return CompCard(), nil
	end
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
