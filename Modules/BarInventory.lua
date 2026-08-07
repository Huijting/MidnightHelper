local _, ns = ...

--[[
	Midnight Helper — what is actually on your bars, and what can bind it (`/mh bars`).

	`/mh apply` bound 10 keys on Rob's mage and failed on 9, reporting spells as "not on
	any bar" that were plainly sitting on his bars, plus an "Ice Block (slot 121, no
	command)". The cause was an assumption: that action slots and their binding names are
	the same for everybody. They are not. Rob and Carola run EllesmereUI, which adds bars
	of its own with its own binding names (`EUI_BAR9_BUTTON1`...); Cisca runs neither.
	Hardcoding a slot-to-command table only ever describes one person's setup.

	So this measures instead, and both halves matter:

	  • WHAT IS WHERE — every action slot the game exposes, and what sits in it.
	  • WHAT CAN BIND IT — every binding command this client knows, from the game's own
	    binding list, including the ones an addon added. `GetNumBindings`/`GetBinding`
	    is the authoritative answer; a table we typed is a guess about somebody else's
	    machine.

	Between them we can work out the real mapping on THIS installation instead of
	assuming a default one, and see immediately how a setup without a bar addon differs
	from one with it.

	⚠️ Reads only. It never binds, never moves an action, never touches a bar.
]]

--- ⚠️ 180 WAS NOT ENOUGH, or something else is going on. Rob's scan came back with 43
--- filled slots and not one of his rotation spells in them — no Frostbolt, no Flurry,
--- no Counterspell — while his keys 1-5 pointed at slots holding Frozen Orb, Spellsteal
--- and Arcane Intellect. The slot numbering is not the error: KeyUI/Mappings.lua:85 maps
--- the same commands to the same numbers we do.
---
--- EllesmereUI adds two bars of twelve (EUI_BAR9/EUI_BAR10) and they may well sit past
--- 180. Scanning further costs nothing — GetActionInfo simply returns nothing above the
--- real end — and a wider sweep either finds them or rules the idea out. Guessing which
--- it is would be the third guess in a row on this feature.
local MAX_SLOT = 1000

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Binding command -> the action slot it drives, asked of the buttons themselves.
---
--- Every action button frame carries its own slot in the "action" attribute, so the
--- game answers and we do not have to keep a table that is only ever true for one
--- person's setup. Verified against Rob's client: MULTIACTIONBAR5BUTTON2 came back as
--- slot 146, which is what both our old table and KeyUI's say — so the table was never
--- the problem, but asking removes the question entirely.
local FRAME_SETS = {
	{ command = "ACTIONBUTTON",          frame = "ActionButton" },
	{ command = "MULTIACTIONBAR1BUTTON", frame = "MultiBarBottomLeftButton" },
	{ command = "MULTIACTIONBAR2BUTTON", frame = "MultiBarBottomRightButton" },
	{ command = "MULTIACTIONBAR3BUTTON", frame = "MultiBarRightButton" },
	{ command = "MULTIACTIONBAR4BUTTON", frame = "MultiBarLeftButton" },
	{ command = "MULTIACTIONBAR5BUTTON", frame = "MultiBar5Button" },
	{ command = "MULTIACTIONBAR6BUTTON", frame = "MultiBar6Button" },
	{ command = "MULTIACTIONBAR7BUTTON", frame = "MultiBar7Button" },
}

--- @return table command -> slot
function ns.MH_CommandSlotMap()
	local map = {}
	for _, set in ipairs(FRAME_SETS) do
		for i = 1, 12 do
			local f = _G and _G[set.frame .. i]
			if f then
				local slot
				if f.GetAttribute then
					local ok, a = pcall(f.GetAttribute, f, "action")
					slot = ok and tonumber(a) or nil
				end
				slot = slot or tonumber(f.action)
				if slot then
					map[set.command .. i] = slot
				end
			end
		end
	end
	return map
end

local function NameForAction(kind, id)
	if kind == "spell" and C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and n then
			return n
		end
	elseif kind == "item" and C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and n then
			return n
		end
	elseif kind == "macro" and GetMacroInfo then
		local ok, n = pcall(GetMacroInfo, id)
		if ok and n then
			return n
		end
	end
	return nil
end

--- `/mh bars` — write the whole picture to SavedVariables.
function ns.MH_BarInventory()
	ns.db = ns.db or {}
	local out = { slots = {}, bindings = {}, addons = {} }

	-- 1. What is in every action slot.
	if GetActionInfo then
		for slot = 1, MAX_SLOT do
			local ok, kind, id, subType = pcall(GetActionInfo, slot)
			if ok and kind then
				out.slots[#out.slots + 1] = {
					slot = slot,
					kind = kind,
					id = id,
					subType = subType,
					name = NameForAction(kind, id),
				}
			end
		end
	end

	-- 2. Every binding command this client knows, with the keys on it. This is where
	--    an addon's own bars show up: they register their own commands, and there is
	--    no other way to learn their names from outside.
	if GetNumBindings and GetBinding then
		local n = GetNumBindings() or 0
		for i = 1, n do
			local ok, command, category, key1, key2 = pcall(GetBinding, i)
			if ok and command then
				-- Only the ones that drive an action button; the rest is menus and chat.
				if command:match("ACTIONBUTTON") or command:match("ACTIONBAR")
					or command:match("BUTTON%d+$") then
					out.bindings[#out.bindings + 1] = {
						command = command,
						category = category,
						key1 = key1,
						key2 = key2,
					}
				end
			end
		end
	end

	-- 2b. Where a named action BUTTON actually points. This is the only way to learn a
	--     command's slot without a hardcoded table: the frame carries its own slot in
	--     the "action" attribute, so the game answers instead of us.
	out.buttonSlots = {}
	for command, slot in pairs(ns.MH_CommandSlotMap()) do
		out.buttonSlots[#out.buttonSlots + 1] = { command = command, slot = slot }
	end
	table.sort(out.buttonSlots, function(a, b)
		return a.slot < b.slot
	end)

	-- 2c. Is each bar actually on screen, and where?
	--
	-- Rob, 7 Aug, looking at a screenshot of his own bars: "geen idee of ze allemaal op
	-- visible staan". Neither did we — every reading so far was about which SLOT holds
	-- what, and none about whether the player can see the thing they are being told to
	-- press. A layout that fills a hidden bar is a layout nobody can use.
	--
	-- Read-only: IsShown for the state, GetPoint and the size for where it sits. No
	-- opinion about whether that is a good place, and nothing moved.
	out.bars = {}
	local BAR_FRAMES = {
		{ label = "Bar 1", frame = "MainMenuBar" },
		{ label = "Bar 2", frame = "MultiBarBottomLeft" },
		{ label = "Bar 3", frame = "MultiBarBottomRight" },
		{ label = "Bar 4", frame = "MultiBarRight" },
		{ label = "Bar 5", frame = "MultiBarLeft" },
		{ label = "Bar 6", frame = "MultiBar5" },
		{ label = "Bar 7", frame = "MultiBar6" },
		{ label = "Bar 8", frame = "MultiBar7" },
	}
	for _, b in ipairs(BAR_FRAMES) do
		local f = _G and _G[b.frame]
		local row = { label = b.label, frame = b.frame, exists = f and true or false }
		if f then
			local okS, shown = pcall(f.IsShown, f)
			row.shown = okS and shown or false
			local okV, visible = pcall(f.IsVisible, f)
			row.visible = okV and visible or false
			local okP, point, _, relPoint, x, y = pcall(f.GetPoint, f, 1)
			if okP and point then
				row.point = point
				row.relPoint = relPoint
				row.x = x and math.floor(x + 0.5) or nil
				row.y = y and math.floor(y + 0.5) or nil
			end
			local okZ, w, h = pcall(f.GetSize, f)
			if okZ then
				row.w = w and math.floor(w + 0.5) or nil
				row.h = h and math.floor(h + 0.5) or nil
			end
		end
		out.bars[#out.bars + 1] = row
	end

	-- 2d. CAN WE TURN A BAR ON OURSELVES? Rob asked (7 Aug 2026) after I said an addon can
	--     drive Edit Mode. That claim was about importing a whole layout string, which
	--     EllesmereUI demonstrably does — turning a single bar on is a different call and
	--     was never checked. `SetActionBarToggles` is the only lead, used by
	--     OakUI_Installer behind an `if`, and historically it covers only bars 2-5;
	--     MultiBar5/6/7 arrived with Edit Mode and predate nothing.
	--
	--     So ask this client instead of reasoning about it. Read-only: GetActionBarToggles
	--     reports, SetActionBarToggles is NEVER called here.
	out.api = {}
	local function Note(name, value)
		out.api[name] = value
	end
	Note("SetActionBarToggles", (type(SetActionBarToggles) == "function") and "function" or type(SetActionBarToggles))
	Note("GetActionBarToggles", (type(GetActionBarToggles) == "function") and "function" or type(GetActionBarToggles))
	if type(GetActionBarToggles) == "function" then
		local ok, a, b, c, d, e = pcall(GetActionBarToggles)
		if ok then
			out.api.toggles = { tostring(a), tostring(b), tostring(c), tostring(d), tostring(e) }
		else
			out.api.togglesError = tostring(a)
		end
	end
	for _, fn in ipairs({ "GetLayouts", "SaveLayouts", "SetActiveLayout", "ConvertStringToLayoutInfo" }) do
		Note("C_EditMode." .. fn, (C_EditMode and type(C_EditMode[fn]) == "function") and "function" or "absent")
	end
	Note("EditModeManagerFrame", EditModeManagerFrame and "present" or "absent")
	Note("EditModeManagerFrame.accountSettings",
		(EditModeManagerFrame and EditModeManagerFrame.accountSettings) and "present" or "absent")
	Note("Enum.EditModeActionBarSetting",
		(Enum and Enum.EditModeActionBarSetting) and "present" or "absent")

	-- 3. Which bar addons are loaded, so a report can say whose numbering this is.
	if C_AddOns and C_AddOns.IsAddOnLoaded then
		for _, name in ipairs({
			"EllesmereUIActionBars", "EllesmereUI", "Bartender4", "Dominos", "ElvUI", "KeyUI",
		}) do
			local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, name)
			if ok and loaded then
				out.addons[#out.addons + 1] = name
			end
		end
	end

	ns.db.barInventory = out
	print(("%s bars: |cffffffff%d|r filled slot(s), |cffffffff%d|r action binding(s)%s."):format(
		Prefix(), #out.slots, #out.bindings,
		#out.addons > 0 and (", bar addons: " .. table.concat(out.addons, ", ")) or ""))
	print("   |cff9d9d9dWritten to SavedVariables — |cffffffff/reload|r and it can be read from the file.|r")
end
