local _, ns = ...

--[[
	Midnight Helper — how your bars stood (`/mh editmode`).

	On 8 Aug 2026 Rob rearranged his bars in Edit Mode and EllesmereUI, did not like the
	result, and had nothing to compare against. Our snapshots cover what is IN the action
	slots and what the keys are bound to; they say nothing about where a bar is drawn,
	how many rows it has, or whether it is visible. Those live in Blizzard's Edit Mode
	and we were not looking at them at all.

	So we look now. Once per session, and on demand.

	⚠️ READ-ONLY, AND DELIBERATELY SO. `C_EditMode.SaveLayouts` + `SetActiveLayout` can
	write a layout back — EllesmereUI does it — but its own code documents what that
	costs: the imported layout has to be reconciled with the current client's schema,
	the active index has to be computed against Blizzard's built-in presets sitting ahead
	of the saved ones, and a ReloadUI must follow immediately or the taint stays. Getting
	any of that wrong wrecks the exact thing this module exists to protect. Restoring is
	a separate decision, taken awake.

	What this gives you meanwhile is the answer to "what did I change?", which is the
	question Rob actually could not answer.
]]

local MAX_KEPT = 3
local MAX_DEPTH = 8

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Copy only what SavedVariables can hold. Layout data is plain tables of numbers,
--- strings and booleans, but a depth cap and a type filter mean a future Blizzard change
--- that puts a frame reference in there costs a missing field, not a broken file.
local function Sanitize(value, depth)
	local t = type(value)
	if t == "number" or t == "string" or t == "boolean" then
		return value
	end
	if t ~= "table" or depth > MAX_DEPTH then
		return nil
	end
	local out = {}
	for k, v in pairs(value) do
		local kt = type(k)
		if kt == "number" or kt == "string" then
			local sv = Sanitize(v, depth + 1)
			if sv ~= nil then
				out[k] = sv
			end
		end
	end
	return out
end

--- Is Edit Mode ready to be read? EllesmereUI's own code notes that the account settings
--- populate on login and that GetLayouts is usable once they exist.
local function Ready()
	if not (C_EditMode and C_EditMode.GetLayouts) then
		return false, "this client has no C_EditMode.GetLayouts"
	end
	if not (EditModeManagerFrame and EditModeManagerFrame.accountSettings) then
		return false, "Edit Mode has not finished loading yet"
	end
	return true
end

--- A short description of each layout, so a report can be read without unpacking data.
local function Describe(info)
	local out = {}
	for i, l in ipairs((info and info.layouts) or {}) do
		out[#out + 1] = {
			index = i,
			name = l.layoutName,
			layoutType = l.layoutType,
			systems = l.systems and #l.systems or 0,
		}
	end
	return out
end

--- @param label string  why this capture happened, so a list of three is readable
--- @return boolean ok, string|nil reason
function ns.MH_EditModeCapture(label)
	local ok, why = Ready()
	if not ok then
		return false, why
	end
	local okG, info = pcall(C_EditMode.GetLayouts)
	if not okG or type(info) ~= "table" then
		return false, "GetLayouts returned nothing"
	end

	ns.db = ns.db or {}
	ns.db.editModeBackups = ns.db.editModeBackups or {}
	local list = ns.db.editModeBackups

	local entry = {
		label = label or "manual",
		active = info.activeLayout,
		summary = Describe(info),
		data = Sanitize(info, 0),
	}
	-- Newest first, and only a few: this is layout data, not a diary, and SavedVariables
	-- is read on every login.
	table.insert(list, 1, entry)
	while #list > MAX_KEPT do
		table.remove(list)
	end

	--- Does this client have an export-to-string function? `ConvertStringToLayoutInfo`
	--- (import) is confirmed present; the other direction is not, and it does not appear
	--- in any installed addon — which after last night proves nothing either way. Ask.
	ns.db.editModeApi = {}
	for _, name in ipairs({
		"GetLayouts", "SaveLayouts", "SetActiveLayout",
		"ConvertStringToLayoutInfo", "ConvertLayoutInfoToString", "OnLayoutAdded",
	}) do
		ns.db.editModeApi[name] = (C_EditMode and type(C_EditMode[name]) == "function") and "function" or "absent"
	end
	return true
end

--- `/mh editmode` — capture now and say what is stored.
function ns.MH_EditModeReport()
	local ok, why = ns.MH_EditModeCapture("manual")
	if not ok then
		print(("%s cannot read Edit Mode — %s."):format(Prefix(), tostring(why)))
		return
	end
	local list = (ns.db and ns.db.editModeBackups) or {}
	print(("%s Edit Mode captured — |cffffffff%d|r layout(s), keeping the last |cffffffff%d|r snapshot(s)."):format(
		Prefix(), #(list[1] and list[1].summary or {}), #list))
	for _, l in ipairs(list[1] and list[1].summary or {}) do
		print(("   |cffffd100%d|r %s |cff9d9d9d(%d system%s)|r"):format(
			l.index, tostring(l.name), l.systems, l.systems == 1 and "" or "s"))
	end
	print("   |cff9d9d9dRead-only — nothing was changed. |cffffffff/reload|r and the file holds the detail.|r")
end

--- One capture per session, after Edit Mode has settled. Deliberately not on every
--- change: the point is a picture of how things stood, and a snapshot taken halfway
--- through rearranging is worth less than one taken at login.
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
local done = false
f:SetScript("OnEvent", function()
	if done then
		return
	end
	done = true
	if C_Timer and C_Timer.After then
		C_Timer.After(10, function()
			pcall(ns.MH_EditModeCapture, "login")
		end)
	end
end)
