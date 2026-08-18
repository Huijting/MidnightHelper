local _, ns = ...

--[[
	Midnight Helper — "do not stand in this", for wherever you are standing.

	The data is in HazardData.lua; this decides whether it applies. The whole design
	rests on one fact: the number GTFO keys its hazards on is the same number the
	player's own client reports on entry, so nobody has to translate an instance id
	into a zone name. `GetInstanceInfo()` returns both the id and the name, which
	means walking in IS the measurement.

	That also closes the four gaps by itself. Instances 3079, 2963, 2858 and 1592
	have hazards but no name anyone can verify — 3079 is Ula'tek-themed and could be
	Venomfall Deeps, but "could be" is not a name. The first player to stand in one
	writes the real name to `ns.db.hazardZones`, and then we know.
]]

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function Prefix()
	return "|cff8fd3ffMidnight Helper|r"
end

--- The instance id the client reports, or nil out in the world.
--- @return number|nil instanceID, string|nil name
function ns.GetCurrentInstanceID()
	if not GetInstanceInfo then
		return nil
	end
	local ok, name, _, _, _, _, _, _, instanceID = pcall(GetInstanceInfo)
	if not ok then
		return nil
	end
	if type(instanceID) ~= "number" or instanceID == 0 then
		return nil, (type(name) == "string" and name) or nil
	end
	return instanceID, (type(name) == "string" and name) or nil
end

--- Record what this instance is actually called. The table below is the only place
--- a zone name for these ids can come from that is not a guess.
local function LearnZone(instanceID, name)
	if not instanceID or type(name) ~= "string" or not name:find("%w") then
		return
	end
	ns.db = ns.db or {}
	ns.db.hazardZones = ns.db.hazardZones or {}
	local prev = ns.db.hazardZones[instanceID]
	if prev ~= name then
		ns.db.hazardZones[instanceID] = name
		if not prev and ns.INSTANCE_HAZARDS and ns.INSTANCE_HAZARDS[instanceID] then
			-- Worth saying out loud: this is one of the ids nothing could name.
			print(("%s |cff40d060learned|r instance %d is %q."):format(
				Prefix(), instanceID, name))
		end
	end
end

--- The hazard list for where the player is, or nil.
--- @return table|nil spellIDs, number|nil instanceID, string|nil zoneName
function ns.GetHazardsHere()
	local instanceID, name = ns.GetCurrentInstanceID()
	if not instanceID then
		return nil
	end
	LearnZone(instanceID, name)
	local list = ns.INSTANCE_HAZARDS and ns.INSTANCE_HAZARDS[instanceID]
	if not list or #list == 0 then
		return nil, instanceID, name
	end
	return list, instanceID, name
end

--- Render a hazard list as one line per hazard. `{SPELL:id}` puts the client's own
--- name in, so this is already right in every language and cannot go stale.
--- @return string|nil
function ns.FormatHazardLines(list)
	if type(list) ~= "table" or #list == 0 then
		return nil
	end
	local out = {}
	for _, id in ipairs(list) do
		local markup
		if ns.GetSpellLinkMarkup then
			markup = ns:GetSpellLinkMarkup(id)
		end
		-- No fallback to a typed name: if the client cannot name it, it does not
		-- go on screen. A hazard called "Spell 1298887" helps nobody.
		if markup and not markup:find("^Spell ") then
			out[#out + 1] = "• " .. markup
		end
	end
	if #out == 0 then
		return nil
	end
	return table.concat(out, "|n")
end

function ns.ShowHazards()
	local list, instanceID, name = ns.GetHazardsHere()

	if not instanceID then
		local n = #(ns.WORLD_HAZARDS or {})
		print(("%s %s"):format(Prefix(), L("HAZARD_OUTSIDE")))
		print(("   |cff8a8f98%d %s|r"):format(n, L("HAZARD_WORLD_COUNT")))
		return
	end

	local label = name or ("instance " .. tostring(instanceID))
	if not list then
		print(("%s |cffffd100%s|r — %s"):format(Prefix(), label, L("HAZARD_NONE_KNOWN")))
		print(("   |cff8a8f98instance %d|r"):format(instanceID))
		return
	end

	print(("%s |cff8fd3ff%s|r — %d %s"):format(
		Prefix(), label, #list, L("HAZARD_COUNT")))
	for _, id in ipairs(list) do
		local markup = ns.GetSpellLinkMarkup and ns:GetSpellLinkMarkup(id) or tostring(id)
		print("   • " .. markup)
	end
	print(("   |cff8a8f98%s|r"):format(L("HAZARD_SOURCE_NOTE")))
end

-- ---------------------------------------------------------------------------
-- `/mh hazards check` — put every id in the file to the client
-- ---------------------------------------------------------------------------

--[[
	The 173 ids that opened this file were checked once, by a throwaway script that no
	longer exists. So when GTFO 6.8 added sixteen more on 18 aug there was nothing to
	re-run, and "verify it the way we did last time" meant writing it again from memory.
	This is that check, kept.

	⚠️ IT NEEDS TWO CONTROLS, AND THEY BOTH HAVE TO BE ABLE TO FAIL. An id that comes
	back nameless proves nothing on its own — the spell cache may simply not be loaded,
	in which case EVERY id looks wrong and the run would condemn 189 good ones. So:

	  • a POSITIVE control (an id measured on Rob's own client on 17 aug) must resolve.
	    If it does not, the cache is cold and the whole run is thrown away, not reported.
	  • a NEGATIVE control (an id that cannot exist) must NOT resolve. If it does, then
	    "resolves" means nothing here and a pass proves nothing either.

	This is the rule that cost us three separate mistakes before 16 aug: an empty answer
	is not an absence unless something in the same run could have answered.

	⚠️ AND IT MUST WAIT. C_Spell.GetSpellName reads a cache that fills asynchronously;
	a straight loop reports "no name" for ids that are perfectly real. That bug already
	cost a day on /mh curios in 2.17.0. RequestLoadSpellData first, then read a second
	later.
]]

local POSITIVE_CONTROL = 1287680 -- Snake Eater, named by Rob's client 17 aug
local NEGATIVE_CONTROL = 99999991 -- must stay nameless, or "named" means nothing

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and n and n ~= "" then
			return n
		end
	end
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, id)
		if ok and info and info.name and info.name ~= "" then
			return info.name
		end
	end
	return nil
end

--- Every id in the file, with the instance it sits under. Duplicates are kept: the
--- same spell legitimately appears in two instances, and collapsing them would hide
--- which instance a bad id belongs to.
local function EveryID()
	local out = {}
	for instanceID, list in pairs(ns.INSTANCE_HAZARDS or {}) do
		for _, id in ipairs(list) do
			out[#out + 1] = { id = id, where = instanceID }
		end
	end
	for _, id in ipairs(ns.WORLD_HAZARDS or {}) do
		out[#out + 1] = { id = id, where = "world" }
	end
	return out
end

function ns.CheckHazardIDs()
	local rows = EveryID()
	print(("%s |cff8fd3ffchecking %d hazard ids against your client…|r"):format(
		Prefix(), #rows))

	if C_Spell and C_Spell.RequestLoadSpellData then
		pcall(C_Spell.RequestLoadSpellData, POSITIVE_CONTROL)
		for _, row in ipairs(rows) do
			pcall(C_Spell.RequestLoadSpellData, row.id)
		end
	end

	C_Timer.After(1.5, function()
		local posOK = SpellName(POSITIVE_CONTROL) ~= nil
		local negName = SpellName(NEGATIVE_CONTROL)

		if not posOK then
			print(("   |cffff5040The control failed: %d has no name either, so the spell cache is not loaded. Nothing is proven — run it again in a moment.|r")
				:format(POSITIVE_CONTROL))
			return
		end
		if negName then
			print(("   |cffff5040The impossible id %d came back as %q, so 'has a name' means nothing here. Report this.|r")
				:format(NEGATIVE_CONTROL, negName))
			return
		end

		local named, nameless = 0, {}
		for _, row in ipairs(rows) do
			local n = SpellName(row.id)
			if n then
				named = named + 1
			else
				nameless[#nameless + 1] = row
			end
		end

		print(("   |cff40c040%d named|r · |cffffd100%d without a name|r  (controls held)")
			:format(named, #nameless))
		for _, row in ipairs(nameless) do
			print(("      |cffff5040%d|r  instance %s"):format(row.id, tostring(row.where)))
		end
		if #nameless == 0 then
			print("      |cff8a8f98Every id in the file resolves.|r")
		end

		--- To SavedVariables as well, so a long list does not have to be read off a
		--- screenshot -- the standing rule since 27 jul.
		ns.db = ns.db or {}
		ns.db.hazardCheck = { named = named, nameless = nameless, checked = #rows }
		print("      |cff8a8f98Also written to ns.db.hazardCheck — /reload to save it.|r")
	end)
end

-- ---------------------------------------------------------------------------
-- Learn the name of every instance the player enters, hazards or not.
-- ---------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", function()
	-- Deferred: GetInstanceInfo is not settled at the moment the event fires, and a
	-- name read too early comes back as the previous zone. Half a second is what the
	-- delve coach already uses for the same reason.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			local id, name = ns.GetCurrentInstanceID()
			LearnZone(id, name)
		end)
	end
end)
