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

--- ⚠️ A LAYOUT IS NOT JUST THE BARS. Measured in Rob's own capture, 10 Aug: his active
--- layout holds **50 systems across 24 types**, of which only **11 are action bars**
--- (`system == 0`, indexes 1-8 plus 11, 12, 13 — the eight bars plus pet, stance and
--- extra). The other 39 are minimap, unit frames, chat, cast bar, everything.
---
--- Rob asked before this was built: "als Cisca haar minimap ergens heeft verplaatst moet
--- ie daar van afblijven". He is right, and handing someone a whole layout string would
--- have moved every one of those 39. The question arrived one step before the mistake.
---
--- So a share carries the bars only. Whether Blizzard's own string format survives being
--- given a bar-only layout is not documented anywhere we can check, so this asks the
--- client: convert bars-only to a string, convert it straight back, and record whether
--- the bars come out the other side. A yes means the safe route exists — the player
--- pastes it into Blizzard's own import and we never write. A no means sharing needs
--- MH to transplant the systems itself, which is a decision to take with eyes open.
local BAR_SYSTEM = 0

--- @return table|nil layoutInfo holding only the action-bar systems
local function BarsOnly(layout)
	if not (layout and layout.systems) then
		return nil
	end
	local systems = {}
	for _, s in ipairs(layout.systems) do
		if s.system == BAR_SYSTEM then
			systems[#systems + 1] = s
		end
	end
	if #systems == 0 then
		return nil
	end
	return {
		layoutName = (layout.layoutName or "MH") .. " bars",
		layoutType = layout.layoutType,
		systems = systems,
	}
end

--- `/mh editmode export` — the bars, and only the bars.
function ns.MH_EditModeExport()
	local ok, why = Ready()
	if not ok then
		print(("%s cannot read Edit Mode — %s."):format(Prefix(), tostring(why)))
		return
	end
	local okG, info = pcall(C_EditMode.GetLayouts)
	if not (okG and type(info) == "table" and info.layouts) then
		print(Prefix() .. " Edit Mode returned no layouts.")
		return
	end
	--- GetLayouts returns only the SAVED layouts; Blizzard's presets sit ahead of them in
	--- the active index, so activeLayout cannot be used as an index here. EllesmereUI's
	--- code says the same. Take the first saved layout unless there is exactly one.
	local layout = info.layouts[1]
	if not layout then
		print(Prefix() .. " no saved layout to export — make one in Edit Mode first.")
		return
	end

	local bars = BarsOnly(layout)
	if not bars then
		print(Prefix() .. " that layout holds no action-bar systems.")
		return
	end

	ns.db = ns.db or {}
	local result = { layoutName = layout.layoutName, barSystems = #bars.systems,
		totalSystems = #(layout.systems or {}) }

	if C_EditMode.ConvertLayoutInfoToString then
		local okS, str = pcall(C_EditMode.ConvertLayoutInfoToString, bars)
		if okS and type(str) == "string" and str ~= "" then
			result.string = str
			result.length = #str
			-- Straight back again: a string we cannot read is a string nobody can.
			if C_EditMode.ConvertStringToLayoutInfo then
				local okB, back = pcall(C_EditMode.ConvertStringToLayoutInfo, str)
				result.roundTrip = (okB and type(back) == "table") and true or false
				result.roundTripSystems = (okB and type(back) == "table" and back.systems)
					and #back.systems or 0
			end
		else
			result.error = "ConvertLayoutInfoToString refused a bars-only layout"
		end
	else
		result.error = "this client has no ConvertLayoutInfoToString"
	end

	ns.db.editModeBarsExport = result
	print(("%s bars-only export — |cffffffff%d|r of |cffffffff%d|r systems are action bars."):format(
		Prefix(), result.barSystems, result.totalSystems))
	if result.string then
		print(("   |cff40c040string made:|r %d characters, reads back as %s system(s)."):format(
			result.length, tostring(result.roundTripSystems)))
	else
		print("   |cffff9900" .. tostring(result.error) .. "|r")
	end
	print("   |cff9d9d9dNothing was changed; your minimap and frames are not part of this.|r")
	-- Straight into a box: 548 characters is not something anyone digs out of a Lua file.
	if result.string and ns.MH_EditModeShowExport then
		ns.MH_EditModeShowExport(result.string)
	end
end

--- ⚠️ THE ONE PLACE MH WRITES TO EDIT MODE. Everything else in this file reads.
---
--- Rob's requirement decides the design: "als Cisca haar minimap ergens heeft verplaatst
--- moet ie daar van afblijven". Blizzard's own import cannot do that — it creates a NEW
--- layout, so a bars-only string would leave her with bars in the right place and all 39
--- other systems back at their defaults. The only way to change the bars and nothing else
--- is to take her existing layout and swap its 11 bar systems.
---
--- Which means writing. Conditions, taken from EllesmereUI's own code and its comments:
---   * out of combat;
---   * `EditModeManagerFrame.accountSettings` must have populated (login);
---   * Blizzard's built-in presets sit AHEAD of the saved layouts in the active index, so
---     `activeLayout` cannot index `GetLayouts().layouts` directly;
---   * `ReloadUI` immediately after, or the taint we introduce stays.
---
--- And a rule of our own: the layout is captured first, every time, so `/mh editmode
--- restore` can put it back. A write we cannot undo is one we do not make.
local function PresetCount()
	if EditModePresetLayoutManager and EditModePresetLayoutManager.GetCopyOfPresetLayouts then
		local ok, presets = pcall(EditModePresetLayoutManager.GetCopyOfPresetLayouts,
			EditModePresetLayoutManager)
		if ok and type(presets) == "table" then
			return #presets
		end
	end
	return nil
end

--- `/mh editmode bars <string>` — put someone else's bars into YOUR layout.
function ns.MH_EditModeApplyBars(str)
	local ok, why = Ready()
	if not ok then
		print(("%s cannot touch Edit Mode — %s."):format(Prefix(), tostring(why)))
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " not in combat.")
		return
	end
	if type(str) ~= "string" or str == "" then
		print(Prefix() .. " give me the bars string: |cffffffff/mh editmode bars <string>|r")
		return
	end
	if not C_EditMode.ConvertStringToLayoutInfo then
		print(Prefix() .. " this client cannot read layout strings.")
		return
	end

	local okC, incoming = pcall(C_EditMode.ConvertStringToLayoutInfo, str)
	if not (okC and type(incoming) == "table" and incoming.systems) then
		print(Prefix() .. " |cffff9900that string is not a layout|r — wrong text, or made on another patch.")
		return
	end
	local bars = {}
	for _, s in ipairs(incoming.systems) do
		if s.system == BAR_SYSTEM then
			bars[#bars + 1] = s
		end
	end
	if #bars == 0 then
		print(Prefix() .. " |cffff9900that string holds no action bars.|r Nothing to do.")
		return
	end

	local okG, info = pcall(C_EditMode.GetLayouts)
	if not (okG and type(info) == "table" and info.layouts) then
		print(Prefix() .. " Edit Mode returned no layouts.")
		return
	end
	--- Which of the SAVED layouts is active? The presets are counted first, so subtract
	--- them. If we cannot learn how many there are we stop — guessing the index here
	--- would rewrite the wrong layout.
	local presets = PresetCount()
	if not presets then
		print(Prefix() .. " |cffff9900cannot tell which layout is active|r (preset list unavailable).")
		print("   |cff9d9d9dNothing was changed.|r")
		return
	end
	local savedIndex = (tonumber(info.activeLayout) or 0) - presets
	local target = info.layouts[savedIndex]
	if not target then
		print(Prefix() .. " |cffff9900you are on one of Blizzard's preset layouts.|r")
		print("   |cff9d9d9dMake your own layout in Edit Mode first — a preset cannot be edited.|r")
		return
	end

	-- Capture before touching anything. This is the undo.
	local okB = ns.MH_EditModeCapture("before-bars-import")
	if not okB then
		print(Prefix() .. " |cffff9900could not back up your layout, so nothing was changed.|r")
		return
	end
	ns.db.editModeBarsUndo = { savedIndex = savedIndex, layoutName = target.layoutName }

	--- Swap ONLY the bar systems. Everything else in the layout is left exactly as it is,
	--- which is the entire point.
	local kept, replaced = {}, 0
	for _, s in ipairs(target.systems or {}) do
		if s.system ~= BAR_SYSTEM then
			kept[#kept + 1] = s
		end
	end
	for _, s in ipairs(bars) do
		kept[#kept + 1] = s
		replaced = replaced + 1
	end
	target.systems = kept

	if EditModeManagerFrame and EditModeManagerFrame.ReconcileWithModern then
		pcall(EditModeManagerFrame.ReconcileWithModern, EditModeManagerFrame, target)
	end

	local okS = pcall(C_EditMode.SaveLayouts, info)
	if not okS then
		print(Prefix() .. " |cffff9900Edit Mode refused the change.|r Your layout is untouched.")
		return
	end

	print(("%s bars replaced — |cffffffff%d|r bar system(s) into |cffffffff%s|r."):format(
		Prefix(), replaced, tostring(target.layoutName)))
	print("   |cffff9900Reload now|r |cff9d9d9d— the change is not settled until you do.|r")
	print("   |cff9d9d9dNot what you wanted? |cffffffff/mh editmode restore|r puts your layout back.|r")
end

--- `/mh editmode restore` — put the layout back as it was before the import.
function ns.MH_EditModeRestore()
	local ok, why = Ready()
	if not ok then
		print(("%s cannot touch Edit Mode — %s."):format(Prefix(), tostring(why)))
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " not in combat.")
		return
	end
	local undo = ns.db and ns.db.editModeBarsUndo
	local backups = ns.db and ns.db.editModeBackups
	local snap
	for _, b in ipairs(backups or {}) do
		if b.label == "before-bars-import" then
			snap = b
			break
		end
	end
	if not (undo and snap and snap.data and snap.data.layouts) then
		print(Prefix() .. " nothing to restore — no pre-import backup saved.")
		return
	end
	local was = snap.data.layouts[undo.savedIndex]
	if not (was and was.systems) then
		print(Prefix() .. " the backup does not hold that layout. Nothing changed.")
		return
	end

	local okG, info = pcall(C_EditMode.GetLayouts)
	local target = okG and info and info.layouts and info.layouts[undo.savedIndex]
	if not target then
		print(Prefix() .. " that layout is gone. Nothing changed.")
		return
	end
	target.systems = was.systems
	if EditModeManagerFrame and EditModeManagerFrame.ReconcileWithModern then
		pcall(EditModeManagerFrame.ReconcileWithModern, EditModeManagerFrame, target)
	end
	if not pcall(C_EditMode.SaveLayouts, info) then
		print(Prefix() .. " |cffff9900Edit Mode refused the restore.|r")
		return
	end
	print(("%s |cffffffff%s|r restored to how it was before the import."):format(
		Prefix(), tostring(undo.layoutName)))
	print("   |cffff9900Reload now.|r")
end

--- ⚠️ A SLASH COMMAND CANNOT CARRY THIS. WoW's chat box stops at 255 characters and
--- Rob's bars string is 548, so `/mh editmode bars <string>` was unusable the moment it
--- had a real string to carry — I built the command before checking the length of the
--- thing it was meant to take.
---
--- So: a box. Paste in, or copy out. The same pattern every import/export addon uses,
--- for the same reason.
local box

local function BuildBox()
	if box then
		return box
	end
	local f = CreateFrame("Frame", "MidnightHelperEditModeBox", UIParent, "BackdropTemplate")
	f:SetSize(520, 260)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:EnableMouse(true)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 16, -14)

	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.hint:SetPoint("TOPLEFT", 16, -38)
	f.hint:SetPoint("TOPRIGHT", -16, -38)
	f.hint:SetJustifyH("LEFT")

	local scroll = CreateFrame("ScrollFrame", "$parentScroll", f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 16, -64)
	scroll:SetPoint("BOTTOMRIGHT", -34, 48)

	local edit = CreateFrame("EditBox", nil, scroll)
	edit:SetMultiLine(true)
	edit:SetFontObject(ChatFontNormal)
	edit:SetWidth(452)
	edit:SetAutoFocus(false)
	-- 0 = no limit. The default cuts a long layout string in half without saying so.
	edit:SetMaxLetters(0)
	edit:SetScript("OnEscapePressed", function()
		f:Hide()
	end)
	scroll:SetScrollChild(edit)
	f.edit = edit

	f.apply = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.apply:SetSize(150, 24)
	f.apply:SetPoint("BOTTOMRIGHT", -16, 14)
	f.apply:SetScript("OnClick", function()
		local text = edit:GetText()
		f:Hide()
		if ns.MH_EditModeApplyBars then
			ns.MH_EditModeApplyBars(text)
		end
	end)

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	box = f
	return f
end

--- Show the export string, selected and ready to copy.
function ns.MH_EditModeShowExport(str)
	local f = BuildBox()
	f.title:SetText("Midnight Helper — your bars")
	f.hint:SetText("Ctrl+C to copy. This carries the action bars only — the person who "
		.. "pastes it keeps their own minimap, frames and chat exactly where they are.")
	f.edit:SetText(str or "")
	f.apply:Hide()
	f:Show()
	f.edit:SetFocus()
	f.edit:HighlightText()
end

--- `/mh editmode import` — an empty box to paste someone else's bars into.
function ns.MH_EditModeShowImport()
	local f = BuildBox()
	f.title:SetText("Midnight Helper — paste bars")
	f.hint:SetText("Ctrl+V the string, then Apply. Only your action bars change; a backup "
		.. "is taken first and /mh editmode restore puts them back.")
	f.edit:SetText("")
	f.apply:SetText("Apply bars")
	f.apply:Show()
	f:Show()
	f.edit:SetFocus()
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
