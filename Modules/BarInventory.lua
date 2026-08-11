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

--- ⚠️ A NAMELESS SLOT LOOKS LIKE AN EMPTY SLOT, AND ONE IS NOT THE OTHER.
---
--- This returned nil for macros, battle pets, mounts, flyouts and equipment sets — every
--- action type except a plain spell or item. On 8 Aug 2026 that cost a diagnosis: slots
--- 157, 160 and 161 read as blank in the report, I concluded three abilities had been
--- destroyed by the rebuild, and told Rob his interrupt was gone. Nothing was gone. The
--- report simply could not name what was there.
---
--- Two specific faults behind it. For a macro, `GetActionInfo` hands back the SPELL the
--- macro casts, not a macro index, so `GetMacroInfo(id)` was being asked a question about
--- the wrong number entirely — the same confusion that once broke undo. And `summonpet`,
--- `summonmount`, `flyout` and `equipmentset` had no branch at all.
---
--- The button's own label is tried first because it is what the player actually sees, and
--- it is the only thing that knows a macro's name. Everything is pcalled: a function this
--- client does not have should cost a blank name, never an error. And the caller now
--- falls back to the action's TYPE, so the worst case reads "macro" instead of nothing.
local function NameForAction(slot, kind, id)
	-- What the button shows. Macros and equipment sets live here and nowhere else.
	if slot and GetActionText then
		local ok, t = pcall(GetActionText, slot)
		if ok and type(t) == "string" and t ~= "" then
			return t
		end
	end
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
	elseif kind == "macro" then
		-- No label: name the spell it casts, which is what `id` really is here.
		if C_Spell and C_Spell.GetSpellName then
			local ok, n = pcall(C_Spell.GetSpellName, id)
			if ok and n then
				return "macro: " .. n
			end
		end
	elseif kind == "summonpet" and C_PetJournal and C_PetJournal.GetPetInfoByPetID then
		--- ⚠️ THE NAME IS RETURN 8, NOT 7. First attempt counted one short and read
		--- `isFavorite`, a boolean, which is why Rob's battle pet reported as
		--- `<summonpet>`. The order is speciesID, customName, level, xp, maxXp, displayID,
		--- isFavorite, speciesName, icon — Plumber and ZygorGuidesViewer destructure it
		--- identically, and Rob's own bar is the proof.
		local ok, _, custom, _, _, _, _, _, speciesName = pcall(C_PetJournal.GetPetInfoByPetID, id)
		if ok then
			-- A renamed pet keeps its own name; otherwise the species.
			local n = (type(custom) == "string" and custom ~= "" and custom) or speciesName
			if type(n) == "string" and n ~= "" then
				return n
			end
		end
	elseif kind == "summonmount" and C_MountJournal and C_MountJournal.GetMountInfoByID then
		local ok, n = pcall(C_MountJournal.GetMountInfoByID, id)
		if ok and n then
			return n
		end
	elseif kind == "flyout" and GetFlyoutInfo then
		local ok, n = pcall(GetFlyoutInfo, id)
		if ok and n then
			return n
		end
	elseif kind == "equipmentset" and C_EquipmentSet and C_EquipmentSet.GetEquipmentSetInfo then
		local ok, n = pcall(C_EquipmentSet.GetEquipmentSetInfo, id)
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
				--- ⚠️ THE ASSISTANT LOOKS LIKE WHATEVER IT IS SUGGESTING.
				---
				--- Rob's idea, 10 Aug, and it explains everything: the Single-Button
				--- Assistant shows the spell it currently recommends, so `GetActionInfo`
				--- on that slot answers "Frozen Orb" and our search for id 1229376 found
				--- nothing. I concluded the assistant was on no bar at all. That is
				--- almost certainly wrong — it was hiding behind its own suggestion.
				---
				--- `C_ActionBar.IsAssistedCombatAction` exists for exactly this: you
				--- cannot tell from the action itself. We had verified the function
				--- existed and then never called it.
				local assisted = false
				if C_ActionBar and C_ActionBar.IsAssistedCombatAction then
					local okA, v = pcall(C_ActionBar.IsAssistedCombatAction, slot)
					assisted = (okA and v) and true or false
				end
				local name = NameForAction(slot, kind, id)
				out.slots[#out.slots + 1] = {
					slot = slot,
					kind = kind,
					id = id,
					subType = subType,
					-- Never nil. An action we cannot name still reports its TYPE, so a
					-- filled slot can never read as an empty one again.
					name = name or ("<" .. tostring(kind) .. ">"),
					named = name ~= nil,
					assistedCombat = assisted or nil,
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
	--- ⚠️ `MainMenuBar` IS THE OLD NAME. The main bar's frame is `MainActionBar`; across
	--- Rob's installed addons that name appears 29 times against 8 for the old one. We
	--- asked for the old one, found nothing, and reported "Bar 1 does not exist" — on
	--- every client, not just his. It read as an EllesmereUI quirk and it was our own bug.
	--- Both names are tried, newest first, because the buttons themselves (ActionButton1..)
	--- were always there and the plan that fills slots 1-12 worked the whole time.
	local BAR_FRAMES = {
		{ label = "Bar 1", frame = "MainActionBar", altFrame = "MainMenuBar" },
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
		local usedName = b.frame
		if not f and b.altFrame then
			f = _G and _G[b.altFrame]
			if f then
				usedName = b.altFrame
			end
		end
		local row = { label = b.label, frame = usedName, exists = f and true or false }
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

	--- ⚠️ "PRESENT" IS NOT ENOUGH TO ACT ON. Rob asked (11 Aug) for two things Edit Mode
	--- can do by hand: switch bars 7 and 8 on for a fresh character, and stop showing the
	--- empty buttons. Both are settings in this enum — but knowing the table exists tells
	--- us nothing about which field is which, and a wrong index here silently rewrites
	--- somebody's bar instead of erroring.
	---
	--- So write the whole enum down, names and values. Same for the toggle count: the
	--- earlier note said SetActionBarToggles historically reaches bars 2-5 only, so how
	--- many values GetActionBarToggles hands back decides whether it can reach 7 and 8 at
	--- all.
	if Enum and Enum.EditModeActionBarSetting then
		local fields = {}
		for k, v in pairs(Enum.EditModeActionBarSetting) do
			fields[tostring(k)] = tostring(v)
		end
		out.api.actionBarSettings = fields
	end
	if type(GetActionBarToggles) == "function" then
		local packed = { pcall(GetActionBarToggles) }
		if packed[1] then
			-- Count what actually came back rather than assuming five.
			out.api.toggleCount = #packed - 1
			local all = {}
			for i = 2, #packed do
				all[#all + 1] = tostring(packed[i])
			end
			out.api.togglesAll = all
		end
	end
	--- ⚠️ READ THE WORKING ANSWER INSTEAD OF GUESSING THE VALUES.
	---
	--- The enum gives the setting NUMBERS — VisibleSetting is 5, AlwaysShowButtons is 9 —
	--- and says nothing about which VALUE means "shown" or "hide the empty ones". Picking
	--- a plausible 0 or 1 is exactly the guess that has been wrong repeatedly this week,
	--- and here a wrong value rewrites somebody's bar without erroring.
	---
	--- Rob's Hunter already stands the way he wants it. So dump every setting of every
	--- bar system in the ACTIVE layout: that is the correct answer, in his own client,
	--- for bars that are visible and bars that are not.
	if C_EditMode and C_EditMode.GetLayouts then
		local okL, info = pcall(C_EditMode.GetLayouts)
		local presets = 0
		if EditModePresetLayoutManager and EditModePresetLayoutManager.GetCopyOfPresetLayouts then
			local okP, list = pcall(EditModePresetLayoutManager.GetCopyOfPresetLayouts,
				EditModePresetLayoutManager)
			presets = (okP and type(list) == "table") and #list or 0
		end
		local layout = okL and info and info.layouts
			and info.layouts[(tonumber(info.activeLayout) or 0) - presets]
		if layout then
			out.api.activeLayoutName = layout.layoutName
			out.api.barSystemSettings = {}
			for _, s in ipairs(layout.systems or {}) do
				if s.system == 0 then -- action bars
					local row = { index = s.systemIndex, settings = {} }
					for _, st in ipairs(s.settings or {}) do
						row.settings[tostring(st.setting)] = tostring(st.value)
					end
					out.api.barSystemSettings[#out.api.barSystemSettings + 1] = row
				end
			end
		else
			out.api.activeLayoutName = "(a Blizzard preset — nothing of Rob's to read)"
		end
	end

	--- And what the account-wide Edit Mode settings hold, since that is where the
	--- "always show buttons" style options live for some systems.
	if EditModeManagerFrame and type(EditModeManagerFrame.accountSettings) == "table" then
		local keys = {}
		for k in pairs(EditModeManagerFrame.accountSettings) do
			keys[#keys + 1] = tostring(k)
		end
		table.sort(keys)
		out.api.accountSettingKeys = keys
	end

	--- 2e. WHAT ARE ALL THOSE EDIT MODE SYSTEMS CALLED, and can a stance bar and a pet bar
	--- ever be on screen together?
	---
	--- Rob asked the second question and said, rightly, not to guess. It cannot be
	--- answered from our own data — the `pet_care` category exists in the schema and no
	--- class uses it — and reasoning about which class has both forms and a controllable
	--- pet is exactly the kind of plausible answer that has been wrong three times this
	--- week. The two bars have independent conditions: forms come from
	--- `GetNumShapeshiftForms`, the pet bar from having a pet with an action bar. So ask
	--- both, per character, and let a Shaman or Druid settle it.
	out.ui = {}
	if Enum and Enum.EditModeSystem then
		out.ui.systemNames = {}
		for k, v in pairs(Enum.EditModeSystem) do
			if type(k) == "string" then
				out.ui.systemNames[tostring(v)] = k
			end
		end
	end
	if GetNumShapeshiftForms then
		local ok, n = pcall(GetNumShapeshiftForms)
		out.ui.shapeshiftForms = ok and n or "error"
	end
	for _, name in ipairs({ "StanceBar", "PetActionBar", "MainMenuBarVehicleLeaveButton",
		"PossessActionBar", "ExtraActionBarFrame", "EncounterBar" }) do
		local f = _G and _G[name]
		if f then
			local okS, shown = pcall(f.IsShown, f)
			local okV, vis = pcall(f.IsVisible, f)
			out.ui[name] = ("exists shown=%s visible=%s"):format(
				tostring(okS and shown), tostring(okV and vis))
		else
			out.ui[name] = "absent"
		end
	end
	--- Account-wide or character-specific? It decides whether a key belongs to this
	--- character alone. Rob's Hunter carried six of his Mage's keys, which is only
	--- possible with the account set — so record it rather than infer it next time.
	if ns.Keybind_BindingSet then
		local set, raw = ns.Keybind_BindingSet()
		out.ui.bindingSet = set or ("unreadable:" .. tostring(raw))
		out.ui.bindingSetRaw = raw
	end
	if UnitExists then
		local okP, hasPet = pcall(UnitExists, "pet")
		out.ui.hasPet = okP and hasPet and true or false
	end
	--- ⚠️ `local _, class = UnitClass and UnitClass("player")` reads fine and always
	--- returned nil: `and` keeps only the first of UnitClass's return values, so the
	--- token never arrived and every bar dump has recorded `class = nil`. Same slip as
	--- `select(2, GetBuildInfo and GetBuildInfo() or nil)`.
	if UnitClass then
		local okC, localised, token = pcall(UnitClass, "player")
		out.ui.class = okC and token or nil
		out.ui.className = okC and localised or nil
	end

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
