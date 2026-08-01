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

--[[
	WIDGET SWEEP — the lead that the obelisk measurement missed entirely.

	Rob's seven obelisk snapshots proved one thing: the tier LIST offered at the
	entrance is byte-identical whichever tier you highlight, so nothing there marks
	the choice. I turned that into "a ritual's tier cannot be recorded", which was a
	leap — I had measured one API family, in one place, before entering.

	DBM does not use that API family at all. `DBM-Core/modules/objects/Difficulties.lua`
	line 565 reads a delve's tier off a UI WIDGET:

	    C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183).tierText

	That is the "Tier 8" caption drawn above the objective tracker — the client sends
	the number down as display text even though no API returns it. If a ritual site
	sends its own header widget, the tier is readable after all, at completion, with
	no entrance capture needed.

	So this sweeps rather than testing DBM's three hardcoded IDs. Those IDs are for
	delves; a ritual's would be different numbers, and a probe aimed at a wrong
	constant reports "nothing there" in exactly the same words as a probe aimed at a
	feature that does not exist.
]]

--- Every `C_UIWidgetManager` reader that turns a widget ID into a table.
---
--- Discovered at load where the namespace allows it, because the field carrying a
--- ritual's tier is by definition one nobody has named. The fallback list is not
--- invented: each name below was taken from a `C_UIWidgetManager.` call that exists
--- in an addon installed in this folder.
local function VisualizationReaders()
	local out = {}
	if type(C_UIWidgetManager) == "table" then
		local ok = pcall(function()
			for k, v in pairs(C_UIWidgetManager) do
				if type(k) == "string" and type(v) == "function" and k:find("VisualizationInfo", 1, true) then
					out[#out + 1] = k
				end
			end
		end)
		if ok and #out > 0 then
			table.sort(out)
			return out
		end
	end
	return {
		"GetBulletTextListWidgetVisualizationInfo",
		"GetCaptureBarWidgetVisualizationInfo",
		"GetDoubleIconAndTextWidgetVisualizationInfo",
		"GetDoubleStateIconRowVisualizationInfo",
		"GetDoubleStatusBarWidgetVisualizationInfo",
		"GetHorizontalCurrenciesWidgetVisualizationInfo",
		"GetIconAndTextWidgetVisualizationInfo",
		"GetIconTextAndBackgroundWidgetVisualizationInfo",
		"GetIconTextAndCurrenciesWidgetVisualizationInfo",
		"GetItemDisplayVisualizationInfo",
		"GetScenarioHeaderDelvesWidgetVisualizationInfo",
		"GetScenarioHeaderTimerWidgetVisualizationInfo",
		"GetSpacerVisualizationInfo",
		"GetSpellDisplayVisualizationInfo",
		"GetStackedResourceTrackerWidgetVisualizationInfo",
		"GetStatusBarWidgetVisualizationInfo",
		"GetTextColumnRowVisualizationInfo",
		"GetTextWithStateWidgetVisualizationInfo",
		"GetTextWithSubtextWidgetVisualizationInfo",
		"GetTextureWithAnimationVisualizationInfo",
	}
end

--- Which widget sets are live right now.
---
--- Two routes, because neither is complete on its own: the four named getters cover
--- the fixed screen regions, and the container frames answer `GetRegisteredWidgetSetID`
--- for whatever the current content registered on them.
local function ActiveWidgetSets()
	local sets, order = {}, {}
	local function note(id, source)
		id = tonumber(id)
		if not id or sets[id] then
			return
		end
		sets[id] = source
		order[#order + 1] = id
	end

	if type(C_UIWidgetManager) == "table" then
		for _, name in ipairs({
			"GetTopCenterWidgetSetID",
			"GetObjectiveTrackerWidgetSetID",
			"GetBelowMinimapWidgetSetID",
			"GetPowerBarWidgetSetID",
		}) do
			note(Ask(C_UIWidgetManager[name]), name)
		end
	end

	for _, name in ipairs({
		"UIWidgetTopCenterContainerFrame",
		"UIWidgetBelowMinimapContainerFrame",
		"UIWidgetPowerBarContainerFrame",
		"UIWidgetTopRightCornerContainer",
		"UIWidgetBottomLeftContainerFrame",
		"ScenarioObjectiveTracker",
	}) do
		local f = _G[name]
		if type(f) == "table" then
			local id = rawget(f, "widgetSetID")
			if not id and type(f.GetRegisteredWidgetSetID) == "function" then
				id = Ask(f.GetRegisteredWidgetSetID, f)
			end
			note(id, name)
		end
	end

	return sets, order
end

--- Does this value look like it names a tier? Field name OR content.
---
--- Both halves are needed. DBM's field is `tierText` (the name gives it away) but a
--- ritual might label the same number `difficultyText`, and a lone "3" in a field
--- called `text` is still the answer. Flagging is only a reading aid — the full
--- snapshot goes into the file regardless, so a miss here costs nothing.
local function LooksLikeTier(key, value)
	if type(key) == "string" and key:lower():find("tier", 1, true) then
		return true
	end
	if type(value) == "string" then
		if value:lower():find("tier", 1, true) then
			return true
		end
		if value:match("^%s*%d+%s*$") then
			return true
		end
	end
	return false
end

--- Read every widget of every live set, through every reader that answers.
---
--- Calling all ~20 readers on each widget is deliberate brute force: the type field
--- tells you which reader is "correct", but a wrong reader simply returns nil, and
--- trusting the type means trusting that the ritual header is the widget type I
--- expect. Cheap, and it cannot miss.
local function WidgetSweep()
	local out = { sets = {}, flagged = {} }
	if type(C_UIWidgetManager) ~= "table" or type(C_UIWidgetManager.GetAllWidgetsBySetID) ~= "function" then
		out.unavailable = true
		return out
	end

	local readers = VisualizationReaders()
	local sources, order = ActiveWidgetSets()

	for _, setID in ipairs(order) do
		local widgets = Ask(C_UIWidgetManager.GetAllWidgetsBySetID, setID)
		local block = { setID = setID, source = sources[setID], widgets = {} }
		if type(widgets) == "table" then
			for _, w in ipairs(widgets) do
				local id = type(w) == "table" and w.widgetID or nil
				local entry = { widgetID = id, widgetType = type(w) == "table" and w.widgetType or nil, info = {} }
				if id then
					for _, reader in ipairs(readers) do
						local fn = C_UIWidgetManager[reader]
						local info = type(fn) == "function" and Ask(fn, id) or nil
						if type(info) == "table" then
							entry.info[reader] = Snapshot(info)
							for k, v in pairs(info) do
								if LooksLikeTier(k, v) and not Secret(v) then
									out.flagged[#out.flagged + 1] = {
										setID = setID, widgetID = id, reader = reader,
										field = tostring(k), value = tostring(v),
									}
								end
							end
						end
					end
				end
				block.widgets[#block.widgets + 1] = entry
			end
		end
		out.sets[#out.sets + 1] = block
	end

	-- DBM's three constants, read directly. They are delve IDs, so inside a ritual
	-- they are expected to be empty — which is the point. If they answer in a delve
	-- and the sweep above finds nothing in a ritual, that is a real difference
	-- between the two, not a broken probe.
	out.dbmDelveIds = {}
	local reader = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo
	if type(reader) == "function" then
		for _, id in ipairs({ 6183, 6184, 6185 }) do
			out.dbmDelveIds[id] = Snapshot(Ask(reader, id))
		end
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
		widgets = WidgetSweep(),
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

	print("  |cff8fd3ffUI widgets|r |cff9d9d9d(how DBM reads a delve's tier)|r")
	local sweep = WidgetSweep()
	if sweep.unavailable then
		print("    |cffff8080C_UIWidgetManager.GetAllWidgetsBySetID is missing on this client|r")
	else
		local total = 0
		for _, block in ipairs(sweep.sets) do
			total = total + #block.widgets
			print(("    set %d (%s): %d widget(s)"):format(block.setID, tostring(block.source), #block.widgets))
		end
		if #sweep.sets == 0 then
			print("    |cff9d9d9dno widget set is live here|r")
		end
		print(("    %d widget(s) total, %d field(s) look like a tier:"):format(total, #sweep.flagged))
		for i, f in ipairs(sweep.flagged) do
			if i > 10 then
				print("      |cff9d9d9d... more, see the saved snapshot|r")
				break
			end
			print(("      set %d widget %d  %s.%s = |cff40c040%s|r"):format(
				f.setID, f.widgetID, f.reader:gsub("^Get", ""):gsub("VisualizationInfo$", ""), f.field, f.value))
		end
		local dbmHit = false
		for id, v in pairs(sweep.dbmDelveIds) do
			if type(v) == "table" then
				dbmHit = true
				print(("    DBM's delve widget %d answers: tierText=%s"):format(id, Show(v.tierText)))
			end
		end
		if not dbmHit then
			print("    |cff9d9d9dDBM's delve widget IDs (6183/6184/6185) are empty here|r")
		end
	end

	print("  |cff9d9d9dRun this INSIDE a ritual site, then INSIDE a delve as a control.|r")
	print("  |cff9d9d9dA delve must show a tier here; if it does not, the probe is wrong,|r")
	print("  |cff9d9d9dnot the ritual. Use |cffffffff/mh tier save <label>|r|cff9d9d9d for both.|r")
end
