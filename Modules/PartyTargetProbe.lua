local _, ns = ...

--[[
	Midnight Helper — party-target readability probe (`/mh partytarget`).

	MEASUREMENT ONLY. Draws nothing, changes nothing, is not wired into any panel.
	It answers one question before anyone builds on it: in the content where you
	would actually want to see who your group is attacking, can the addon still
	read it?

	WHY IT EXISTS. Rob wants each party member's target on screen. He has
	SimplePartyTargets installed and it never appears, which is not a bug in either
	addon: EllesmereUI hides Blizzard's compact party frames outright --
	UnregisterAllEvents, Hide, reparent to a hidden frame, plus a hooksecurefunc on
	SetParent that puts them back if anything moves them (EllesmereUIRaidFrames.lua
	handleFrame). SimplePartyTargets anchors to those frames and so has nothing to
	attach to. EllesmereUI offers no equivalent option of its own.

	That leaves a standalone panel of our own, anchored to nobody. Cheap to build --
	party1target is an ordinary unit token -- but 12.1 restricts unit reads: several
	Unit APIs return secret values when the unit's identity is secret, and the API
	notes single out UnitName as no longer returning secrets *in an active PvP match*,
	which says nothing reassuring about dungeons. A party-target display that goes
	blank in group content is worse than none, so this measures first.

	The 12.1 wording is about the unit's identity, so the interesting case is not
	your party member -- it is their TARGET, which is usually an NPC and sometimes
	another player. Both are reported separately.

	Never-lie: nothing here compares a possibly-secret value, and nothing is used as
	a table key. Every field is classified with issecretvalue and printed as one of
	read / nil / SECRET.
]]

local function Secret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

--- read / nil / SECRET — the same three states the aura facade uses, for the same
--- reason: "could not read" is not "not there".
local function State(v)
	if v == nil then
		return "|cff9d9d9dnil|r"
	elseif Secret(v) then
		return "|cffff8080SECRET|r"
	end
	return "|cff40c040read|r"
end

local function Shown(v)
	if v == nil or Secret(v) then
		return ""
	end
	return "  |cffffffff" .. tostring(v) .. "|r"
end

--- Party units only. Raid is deliberately out of scope: the display this measures
--- for is a five-person frame, and asking about forty units would bury the answer.
local function PartyUnits()
	local t = {}
	local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
	for i = 1, math.max(0, n - 1) do
		t[#t + 1] = "party" .. i
	end
	return t
end

function ns.PrintPartyTargetProbe()
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	print(("%s Party targets — what this client will let us read:"):format(p))

	local inInst, kind = false, "none"
	if IsInInstance then
		local ok, a, b = pcall(IsInInstance)
		if ok then
			inInst, kind = a, b or "none"
		end
	end
	print(("  instance: %s (%s)   in combat: %s"):format(
		tostring(inInst), tostring(kind),
		tostring((InCombatLockdown and InCombatLockdown()) or false)))

	local units = PartyUnits()
	if #units == 0 then
		print("  |cffff8080you are not in a party|r — this needs a real group to say anything.")
		return
	end

	for _, unit in ipairs(units) do
		local name, exists, targetName, targetIsPlayer
		if UnitName then
			local ok, v = pcall(UnitName, unit)
			name = ok and v or nil
		end
		if UnitExists then
			local ok, v = pcall(UnitExists, unit .. "target")
			exists = ok and v or nil
		end
		if UnitName then
			local ok, v = pcall(UnitName, unit .. "target")
			targetName = ok and v or nil
		end
		if UnitIsPlayer then
			local ok, v = pcall(UnitIsPlayer, unit .. "target")
			targetIsPlayer = ok and v or nil
		end

		print(("  |cff8fd3ff%s|r  name=%s%s"):format(unit, State(name), Shown(name)))
		-- UnitExists is the one that decides whether a panel can even show a row.
		-- If that comes back secret the feature cannot say "nobody targeted" either,
		-- which is a different and worse failure than a missing name.
		print(("     target: exists=%s  name=%s%s  isPlayer=%s"):format(
			State(exists), State(targetName), Shown(targetName), State(targetIsPlayer)))

		-- Measured 31 jul in a follower dungeon: target NAMES come back SECRET for
		-- enemies and readable for a party member. That kills a panel listing who is
		-- attacking what -- the enemy name is the whole point of it.
		--
		-- So ask the question a tank actually has instead: is this person on the SAME
		-- thing as me? UnitIsUnit answers yes or no and never reveals which unit, so
		-- it is not the kind of read 12.x is restricting -- but that is reasoning, and
		-- reasoning is what this file exists to replace. If these read, a panel can say
		-- "three of four are on your target" without naming anything.
		local sameAsMine, onMe
		if UnitIsUnit then
			local ok, v = pcall(UnitIsUnit, unit .. "target", "target")
			sameAsMine = ok and v or nil
			local ok2, v2 = pcall(UnitIsUnit, unit .. "target", "player")
			onMe = ok2 and v2 or nil
		end
		print(("     same as my target=%s%s   targeting me=%s%s"):format(
			State(sameAsMine), Shown(sameAsMine), State(onMe), Shown(onMe)))
	end

	print("  |cff9d9d9dEnemy target names are SECRET here; a party member's name is not.|r")
	print("  |cff9d9d9dSo the question is whether the two comparison lines above read.|r")
end
