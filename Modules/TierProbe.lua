local _, ns = ...

--[[
	Midnight Helper — tier probe (`/mh tier`).

	MEASUREMENT ONLY. Dumps every tier-related call the client has, wherever you are
	standing, and says which content it thinks you are in.

	WHY. RitualLog has recorded 27 ritual runs across four characters with tier 0 on
	every one, while delves manage 10 of 30. The cause is measured: both files read
	the tier by pulling digits out of a string — `difficultyName:match("(%d+)")` —
	and a delve's difficulty is named "Tier 8" while a ritual's is "Normal Scenario".
	No digits, no tier. Every fallback in DelveHistory does the same trick on a
	different string (scenario name, step name, the objective tracker), and in a
	ritual none of those carry a number either.

	The proposed fix was to capture the tier at the entrance via
	`C_DelvesUI.GetDelveEntranceTiers()`. That call returns the tiers on OFFER,
	though — six of them, all unlocked — not the one the player picked, so it would
	record "there were six choices" and still leave the run at tier 0.

	What nobody has tried is `C_DelvesUI.GetActiveDelveTier()`. MH already calls it
	in DelveBossShowcase, gated behind IsDelveInstanceInProgress, and it returns a
	TABLE describing the tier you are actually in. If it answers inside a ritual, the
	whole entrance-capture design is unnecessary — the tier can be read at completion
	like everything else.

	So this enumerates rather than testing one guess. A probe aimed at a single name
	"finds nothing" for two different reasons and cannot tell them apart.
]]

local function Secret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

local function Ask(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, v = pcall(fn, ...)
	if ok then
		return v
	end
	return nil
end

local function Show(v)
	if v == nil then
		return "|cff9d9d9dnil|r"
	elseif Secret(v) then
		return "|cffff8080SECRET|r"
	elseif type(v) == "table" then
		return "|cff40c040table|r"
	end
	return "|cff40c040" .. tostring(v) .. "|r"
end

--- Print a table one level deep. The interesting answer is usually a field inside
--- the tier table, not the table itself, and "table" on its own says nothing.
local function Dump(indent, t)
	if type(t) ~= "table" then
		return
	end
	local n = 0
	for k, v in pairs(t) do
		n = n + 1
		if n > 12 then
			print(indent .. "|cff9d9d9d... more|r")
			return
		end
		if type(v) == "table" then
			print(("%s%s = table"):format(indent, tostring(k)))
		else
			print(("%s%s = %s"):format(indent, tostring(k), Show(v)))
		end
	end
	if n == 0 then
		print(indent .. "|cff9d9d9d(empty table)|r")
	end
end

--- Copy a table one level deep, keeping every key. Guessed field names are the
--- enemy here: the value that marks the SELECTED tier is by definition one nobody
--- has named yet, so nothing may be filtered on the way into the file.
local function Snapshot(t, depth)
	if type(t) ~= "table" then
		if Secret(t) then
			return "<secret>"
		end
		return t
	end
	if (depth or 0) > 2 then
		return "<deeper>"
	end
	local out = {}
	for k, v in pairs(t) do
		local key = (type(k) == "number" or type(k) == "string") and k or tostring(k)
		out[key] = Snapshot(v, (depth or 0) + 1)
	end
	return out
end

--- `/mh tier save [label]` — append a full snapshot instead of printing.
---
--- Rob's idea, and a better measurement than one reading: stand at the obelisk,
--- select each of the six tiers in turn and save one snapshot per selection. Six
--- labelled records make the field that moves obvious, where a single record can
--- only show what a tier looks like — not which part of it means "this one".
---
--- Appends rather than overwrites, so a run does not destroy the previous one.
function ns.SaveTierProbe(label)
	if not ns.db then
		print("|cffff8080Midnight Helper:|r saved variables are not ready.")
		return
	end
	if type(ns.db.tierProbe) ~= "table" then
		ns.db.tierProbe = {}
	end
	local iOk, iName, iKind, iDiffID, iDiffName = pcall(GetInstanceInfo)
	local rec = {
		label = (label and label ~= "") and label or ("snapshot " .. (#ns.db.tierProbe + 1)),
		zone = GetRealZoneText and GetRealZoneText() or nil,
		instanceName = iOk and iName or nil,
		instanceType = iOk and iKind or nil,
		difficultyID = iOk and iDiffID or nil,
		difficultyName = iOk and iDiffName or nil,
		activeTier = Snapshot(Ask(C_DelvesUI and C_DelvesUI.GetActiveDelveTier)),
		entranceType = Snapshot(Ask(C_DelvesUI and C_DelvesUI.GetTieredEntranceType)),
		entranceTiers = Snapshot(Ask(C_DelvesUI and C_DelvesUI.GetDelveEntranceTiers)),
		isTieredEntrance = Snapshot(C_ScenarioInfo and Ask(C_ScenarioInfo.IsTieredEntranceScenario)),
		scenarioName = Snapshot(C_Scenario and Ask(C_Scenario.GetInfo)),
		scenarioStep = Snapshot(C_Scenario and Ask(C_Scenario.GetStepInfo)),
	}
	ns.db.tierProbe[#ns.db.tierProbe + 1] = rec
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	print(("%s tier snapshot %d saved as \"%s\". |cffffffff/reload|r when you have them all."):format(
		p, #ns.db.tierProbe, rec.label))
end

--- `/mh tier clear` — start a fresh set.
function ns.ClearTierProbe()
	if ns.db then
		ns.db.tierProbe = {}
	end
	print(("|cffffcc00%s|r tier snapshots cleared."):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:"))
end

function ns.PrintTierProbe()
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	print(("%s Tier probe — every tier call this client has, where you are now:"):format(p))

	local inInst, kind = false, "none"
	if IsInInstance then
		local ok, a, b = pcall(IsInInstance)
		if ok then
			inInst, kind = a, b or "none"
		end
	end
	local iOk, iName, iKind, iDiffID, iDiffName = pcall(GetInstanceInfo)
	print(("  instance=%s (%s)   zone=%s"):format(tostring(inInst), tostring(kind),
		tostring(GetRealZoneText and GetRealZoneText() or "?")))
	if iOk then
		-- This is the string both RitualLog and DelveHistory mine for digits. Seeing
		-- it printed next to the answer is the point: "Normal Scenario" explains the
		-- 27 zeroes better than any amount of reasoning about the API.
		print(("  GetInstanceInfo: name=%s  type=%s  difficultyID=%s  difficultyName=%s"):format(
			tostring(iName), tostring(iKind), tostring(iDiffID), tostring(iDiffName)))
	end

	print("  |cff8fd3ffC_DelvesUI|r")
	if type(C_DelvesUI) ~= "table" then
		print("    |cffff8080C_DelvesUI is not present on this client|r")
	else
		local active = Ask(C_DelvesUI.GetActiveDelveTier)
		print(("    GetActiveDelveTier() = %s"):format(Show(active)))
		Dump("      ", active)

		print(("    GetTieredEntranceType() = %s"):format(Show(Ask(C_DelvesUI.GetTieredEntranceType))))

		local tiers = Ask(C_DelvesUI.GetDelveEntranceTiers)
		print(("    GetDelveEntranceTiers() = %s"):format(Show(tiers)))
		if type(tiers) == "table" then
			for i, t in ipairs(tiers) do
				if i > 8 then
					break
				end
				if type(t) == "table" then
					print(("      [%d] tier=%s suggestedILvl=%s unlocked=%s"):format(
						i, Show(t.delveTier or t.tier), Show(t.suggestedItemLevel or t.suggestedILvl),
						Show(t.isUnlocked)))
				end
			end
		end
	end

	print("  |cff8fd3ffC_ScenarioInfo / C_Scenario|r")
	print(("    IsTieredEntranceScenario() = %s"):format(
		Show(C_ScenarioInfo and Ask(C_ScenarioInfo.IsTieredEntranceScenario))))
	print(("    C_Scenario.GetInfo() = %s"):format(Show(C_Scenario and Ask(C_Scenario.GetInfo))))
	print(("    C_Scenario.GetStepInfo() = %s"):format(Show(C_Scenario and Ask(C_Scenario.GetStepInfo))))

	print("  |cff9d9d9dRun this INSIDE a ritual site. If GetActiveDelveTier answers there,|r")
	print("  |cff9d9d9dthe tier can be read at completion and no entrance capture is needed.|r")
end
