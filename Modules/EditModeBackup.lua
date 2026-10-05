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

--- Numbers are equal within 0.01. MEASURED 11 Sep 2026 in Rob's file: two backups whose values
--- were identical on reading back - "offsetX = -0" against "offsetX = 0" was the only difference in
--- the text - still compared unequal in the game, so every login added a copy after all. A live
--- layout carries float remainders that the SavedVariables file does not keep, so a snapshot read
--- back from the file never exactly equals the live layout it came from. A hundredth of a pixel is
--- not a layout change.
local function DeepEqual(a, b, depth)
	if a == b then
		return true
	end
	if type(a) == "number" and type(b) == "number" then
		return math.abs(a - b) < 0.01
	end
	if type(a) ~= "table" or type(b) ~= "table" or depth > MAX_DEPTH + 2 then
		return false
	end
	for k, v in pairs(a) do
		if not DeepEqual(v, b[k], depth + 1) then
			return false
		end
	end
	for k in pairs(b) do
		if a[k] == nil then
			return false
		end
	end
	return true
end

local function SameLayout(x, y)
	return type(x) == "table" and type(y) == "table" and x.active == y.active and DeepEqual(x.data, y.data, 0)
end

--- 🔴 A COPY OF AN UNCHANGED LAYOUT IS NOT A BACKUP, IT IS AN EVICTION. Fixed 11 Sep 2026.
--- The login capture stored a new snapshot every session, changed or not, and only three are kept:
--- measured in Rob's file that day, all three were labelled "login", 513 KB between them, grown
--- by reloads alone. Three reloads after rearranging your bars and the picture from BEFORE the
--- change - the one "what did I change?" needs - was gone. So "login" and "manual" store nothing
--- when the layout equals the newest snapshot, and older "login" copies identical to the one
--- after them are folded away. "before-bars-import" is never skipped or folded: the undo looks
--- for it by that label.
local function FoldLoginDuplicates(list)
	for i = #list, 2, -1 do
		if list[i].label == "login" and SameLayout(list[i], list[i - 1]) then
			table.remove(list, i)
		end
	end
end

--- @param label string  why this capture happened, so a list of three is readable
--- @return boolean ok, string|nil reason  ("unchanged" when nothing new was stored)
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
		at = time(),
	}
	-- Newest first, and only a few: this is layout data, not a diary, and SavedVariables
	-- is read on every login.
	local unchanged = entry.label ~= "before-bars-import" and SameLayout(list[1], entry)
	if not unchanged then
		table.insert(list, 1, entry)
	end
	FoldLoginDuplicates(list)
	-- The newest "before-bars-import" is the undo; trimming must never push it out (red team, 5 Oct 2026:
	-- an apply plus two logins on another layout evicted it). Drop the oldest OTHER entry instead.
	local keep
	for i, b in ipairs(list) do
		if b.label == "before-bars-import" then
			keep = i
			break
		end
	end
	while #list > MAX_KEPT do
		local drop = #list
		if drop == keep then
			drop = drop - 1
		end
		table.remove(list, drop)
		if keep and drop < keep then
			keep = keep - 1
		end
	end

	--- Does this client have an export-to-string function? `ConvertStringToLayoutInfo`
	--- (import) is confirmed present; the other direction is not, and it does not appear
	--- in any installed addon — which after last night proves nothing either way. Ask.
	--- ⚠️ WHICH NUMBER MEANS "ACCOUNT"? A layout is Preset, Account or Character, and
	--- Rob's reads `layoutType = 1`. Account-wide matters a great deal here: importing
	--- bars into an account layout changes them for EVERY character using it, which is
	--- not what someone accepting a shared preset would expect. Guessing the enum from
	--- memory is how three things went wrong this week, so read it.
	ns.db.editModeEnum = {}
	if Enum and Enum.EditModeLayoutType then
		for k, v in pairs(Enum.EditModeLayoutType) do
			if type(k) == "string" then
				ns.db.editModeEnum[k] = v
			end
		end
	end

	ns.db.editModeApi = {}
	for _, name in ipairs({
		"GetLayouts", "SaveLayouts", "SetActiveLayout",
		"ConvertStringToLayoutInfo", "ConvertLayoutInfoToString", "OnLayoutAdded",
	}) do
		ns.db.editModeApi[name] = (C_EditMode and type(C_EditMode[name]) == "function") and "function" or "absent"
	end
	if unchanged then
		return true, "unchanged"
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

--- ⚠️ ONLY THE NUMBERED BARS TRAVEL. System 0 has eleven entries: indexes 1-8 are the
--- action bars the scheme fills, and 11, 12 and 13 are the pet, stance and extra bars.
---
--- Measured on Rob's Hunter, 10 Aug: importing his Mage's bars moved all three of those
--- as well, and his pet bar ended up far right — at coordinates his Mage had never
--- chosen deliberately, because a Mage does not use a pet bar. A Hunter accepting a
--- Mage's preset should not inherit where the Mage happened to leave a bar they never
--- look at.
---
--- So a share carries 1-8. Those are the ones the layout has an opinion about; the
--- class-specific three stay where their owner put them.
local SHARED_BAR_INDEXES = { [1] = true, [2] = true, [3] = true, [4] = true,
	[5] = true, [6] = true, [7] = true, [8] = true }

--- @return table|nil layoutInfo holding only the action-bar systems
local function BarsOnly(layout)
	if not (layout and layout.systems) then
		return nil
	end
	local systems = {}
	for _, s in ipairs(layout.systems) do
		if s.system == BAR_SYSTEM and SHARED_BAR_INDEXES[s.systemIndex] then
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
	--- ⚠️ THE ACTIVE ONE, NOT THE FIRST ONE. This took `info.layouts[1]`, which was right
	--- only while Rob had exactly one saved layout. The moment he made a second on his
	--- Hunter, "export my bars" would have handed him somebody else's layout without
	--- saying so — and a bar string that looks plausible is the worst kind of wrong.
	---
	--- GetLayouts returns only the SAVED layouts while activeLayout counts Blizzard's
	--- presets first, so the index has to be shifted by the preset count. Same arithmetic
	--- the import does; it had it and the export did not.
	local presets = PresetCount()
	if not presets then
		print(Prefix() .. " |cffff9900cannot tell which layout is active|r (preset list unavailable).")
		return
	end
	local activeIndex = (tonumber(info.activeLayout) or 0) - presets
	local layout = info.layouts[activeIndex]
	if not layout then
		--- ⚠️ SAY WHICH LAYOUTS EXIST, not just that this one will not do.
		---
		--- Rob hit this after having exported successfully earlier the same day, so his
		--- own layout was still there — he was simply standing on a preset. "Nothing of
		--- your own to export" reads as "your work is gone", and telling him to make a
		--- New Layout would have had him rebuild bars he already had.
		---
		--- The saved layouts are right here in `info.layouts`. Listing them turns a dead
		--- end into a one-click fix: switch to that one and export again.
		print(Prefix() .. " |cffff9900you are on one of Blizzard's presets|r — those hold nothing of yours to export.")
		local names = {}
		for i = 1, #(info.layouts or {}) do
			local l = info.layouts[i]
			if l and l.layoutName then
				names[#names + 1] = ("|cffffffff%s|r"):format(tostring(l.layoutName))
			end
		end
		if #names > 0 then
			print(("   |cff9d9d9dYour own layout(s): %s \226\128\148 switch to one in Edit Mode's dropdown and export again.|r")
				:format(table.concat(names, ", ")))
		else
			print("   |cff9d9d9dEdit Mode → layout dropdown → New Layout, then arrange your bars.|r")
		end
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
	-- Same filter on the way in, so an older string that still carries the pet and stance
	-- bars cannot move them either.
	local bars = {}
	for _, s in ipairs(incoming.systems) do
		if s.system == BAR_SYSTEM and SHARED_BAR_INDEXES[s.systemIndex] then
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
		--- Measured on Rob's Paladin: activeLayout was 1, which with two presets ahead of
		--- the saved list means he was sitting on Blizzard's "Modern". A preset cannot be
		--- edited at all, so this is a refusal rather than a warning.
		---
		--- ⚠️ IT ALSO GOES ON THE PANEL, and it is a locale key now rather than three
		--- English `print`s. Rob hit this on his level-30 TwelveInchy on 11 Aug 2026 and
		--- fixed it in a minute — because he knew to read chat. Somebody who does not will
		--- press the button, watch nothing happen, and be right to call that broken.
		local msg = ns:L("MH_SAY_PRESET_LAYOUT")
		print(Prefix() .. " |cffff9900" .. msg .. "|r")
		if ns.MH_SetupSay then
			ns.MH_SetupSay("warn", msg)
		end
		return
	end

	--- ⚠️ AN ACCOUNT LAYOUT IS SHARED. Verified from the client, 10 Aug:
	--- `Enum.EditModeLayoutType` is Preset 0, Account 1, Character 2, Override 3, and
	--- Rob's own layout is type 1. So importing bars into it changes the bars on every
	--- character that uses it — not what somebody accepting a shared preset expects.
	---
	--- Said, not refused: it is a legitimate thing to want, and the undo covers it. But
	--- it must be said BEFORE, because "all my alts changed" is not a surprise anyone
	--- should discover afterwards.
	local accountWide = Enum and Enum.EditModeLayoutType
		and target.layoutType == Enum.EditModeLayoutType.Account
	if accountWide then
		local msg = (ns:L("MH_SAY_ACCOUNT_LAYOUT")):format(tostring(target.layoutName))
		print(Prefix() .. " |cffff9900" .. msg .. "|r")
		if ns.MH_SetupSay then
			ns.MH_SetupSay("warn", msg)
		end
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
		-- Everything that is not a shared bar stays exactly as it is: the 39 other
		-- systems, and the player's own pet, stance and extra bars.
		if not (s.system == BAR_SYSTEM and SHARED_BAR_INDEXES[s.systemIndex]) then
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
	print("   |cff9d9d9dNot what you wanted? |cffffffff/mh editmode restore|r puts your layout back.|r")
	--- The reload is the half that matters and the half that was chat-only. Nothing is
	--- settled until it happens, and a player who does not know that sees bars that
	--- half-changed and no reason why.
	local msg = (ns:L("MH_SAY_BARS_DONE")):format(replaced, tostring(target.layoutName))
	print("   |cffff9900" .. msg .. "|r")
	if ns.MH_SetupSay then
		ns.MH_SetupSay("warn", msg)
	end
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
	--- 🔴 BY NAME, NOT BY INDEX (red team, 5 Oct 2026). GetLayouts lists the account layouts plus THIS
	--- character's own, so index N on an alt can be a different layout than index N where the backup was
	--- made. Writing by index could pour one layout's bars into another. Match the name on both sides.
	local function ByName(list, name)
		for i, l in ipairs(list or {}) do
			if l.layoutName == name then
				return l, i
			end
		end
	end
	local was = ByName(snap.data.layouts, undo.layoutName)
	if not (was and was.systems) then
		print(Prefix() .. " the backup does not hold that layout. Nothing changed.")
		return
	end

	local okG, info = pcall(C_EditMode.GetLayouts)
	local target = okG and info and info.layouts and ByName(info.layouts, undo.layoutName)
	if not target then
		print(("%s layout \"%s\" is not available on this character. Nothing changed."):format(Prefix(),
			tostring(undo.layoutName)))
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
	ns.db.keyBlockLayoutOn = nil
	ns.db.keyBlockOldBarsHidden = nil
	ns.db.keyBlockLayoutsOn = ns.db.keyBlockLayoutsOn or {}
	ns.db.keyBlockLayoutsOn[tostring(undo.layoutName)] = false
	local msg = (ns:L("MH_SAY_BARS_RESTORED")):format(tostring(undo.layoutName))
	print(Prefix() .. " " .. msg)
	if ns.MH_SetupSay then
		ns.MH_SetupSay("ok", msg)
	end
	return true, msg
end

--------------------------------------------------------------------------------
-- Key block step 2b (5 Oct 2026, Rob: "1 advies, 2 advies, 3 advies"; picture in
-- docs/KEYBLOCK_PLAN.md). Bars 5, 6 and 7 become three blocks of 3 x 4 side by side, bottom
-- centre; bars 1-4 become columns on the right; stance/possess above A, the extra button above B,
-- the pet bar above C. Bar 8 is never moved, and the block steps aside if bar 8 is in its way.
--
-- Same safety as the bars import above: back-up first under the label the restore looks for, so
-- `/mh editmode restore` undoes it; not in combat, not with Edit Mode open, never on a preset.
--------------------------------------------------------------------------------

local BLOCK_GAP = 10 -- between the three blocks and between a block and the bar above it

-- Frame names per action-bar index, for anchoring and for the live measurements. Bars 1-8 were
-- read from Rob's own layout (5 Oct 2026: MultiBarBottomLeft, MultiBar5, MultiBarRight, MultiBarLeft
-- appear there as relativeTo); MultiBar6/7 follow the same pattern and are checked at run time.
local BAR_FRAME_NAMES = { [1] = "MainActionBar", [2] = "MultiBarBottomLeft", [3] = "MultiBarBottomRight",
	[4] = "MultiBarRight", [5] = "MultiBarLeft", [6] = "MultiBar5", [7] = "MultiBar6", [8] = "MultiBar7",
	[11] = "StanceBar", [12] = "PetActionBar", [13] = "PossessActionBar" }
local EXTRA_SYSTEM = 5 -- Enum.EditModeSystem.ExtraAbilities (warcraft.wiki.gg, read 5 Oct 2026)

local function SetSetting(sys, setting, value)
	sys.settings = sys.settings or {}
	for _, s in ipairs(sys.settings) do
		if s.setting == setting then
			s.value = value
			return
		end
	end
	sys.settings[#sys.settings + 1] = { setting = setting, value = value }
end

local function GetSetting(sys, setting)
	for _, s in ipairs(sys.settings or {}) do
		if s.setting == setting then
			return s.value
		end
	end
end

local function Anchor(sys, point, relTo, relPoint, x, y)
	sys.anchorInfo = { point = point, relativeTo = relTo, relativePoint = relPoint,
		offsetX = x, offsetY = y }
	sys.isInDefaultPosition = false
end

--- The live frame of a system, for "where is it now". Registered frames first, names as fallback.
local function LiveFrame(sys)
	local reg = EditModeManagerFrame and EditModeManagerFrame.registeredSystemFrames
	for _, fr in ipairs(reg or {}) do
		if fr.system == sys.system and (fr.systemIndex == sys.systemIndex or sys.systemIndex == nil) then
			return fr
		end
	end
	if sys.system == BAR_SYSTEM then
		return _G[BAR_FRAME_NAMES[sys.systemIndex] or ""]
	end
end

--- Pin a system to UIParent at the spot it occupies right now (centre on centre).
local function PinWhereItIs(sys)
	local fr = LiveFrame(sys)
	if not (fr and fr.GetCenter) then
		return false
	end
	local cx, cy = fr:GetCenter()
	local ux, uy = UIParent:GetCenter()
	if not (cx and ux) then
		return false
	end
	local k = UIParent:GetEffectiveScale() / fr:GetEffectiveScale()
	Anchor(sys, "CENTER", "UIParent", "CENTER", cx - ux * k, cy - uy * k)
	return true
end

--- Screen rectangle of a frame in UIParent units, or nil.
local function Rect(fr)
	if not (fr and fr:IsShown() and fr:GetLeft()) then
		return nil
	end
	local k = fr:GetEffectiveScale() / UIParent:GetEffectiveScale()
	return fr:GetLeft() * k, fr:GetRight() * k, fr:GetBottom() * k, fr:GetTop() * k
end

--- The name of this character's ACTIVE saved layout, or nil on a preset (Modern/Classic).
local function ActiveLayout()
	if not (C_EditMode and C_EditMode.GetLayouts) then
		return nil
	end
	local okG, info = pcall(C_EditMode.GetLayouts)
	local presets = PresetCount()
	if not (okG and type(info) == "table" and info.layouts and presets) then
		return nil
	end
	local target = info.layouts[(tonumber(info.activeLayout) or 0) - presets]
	return target and tostring(target.layoutName) or nil, target, info
end

--- Is this layout arranged as a block by MH? Also reads the single flag from before 5 Oct evening.
local function KeyBlockLayoutIsOn(name)
	local db = ns.db
	if not (db and name) then
		return false
	end
	local per = db.keyBlockLayoutsOn and db.keyBlockLayoutsOn[name]
	if per ~= nil then
		-- Decided by the per-layout flags: true = arranged, false = put back since.
		return per and true or false
	end
	-- The single old flag only speaks for a player who never used the per-layout flags at all. MEASURED
	-- 5 Oct 2026, twice: "Twelveinchy Holy" stayed "already a block" after going back to Modern because
	-- the old flag still named it, and arranging it again was refused. Once the per-layout table exists,
	-- the old flag is history.
	if db.keyBlockLayoutsOn then
		return false
	end
	local u = db.editModeBarsUndo
	return db.keyBlockLayoutOn and u and u.by == "keyblock" and u.layoutName == name and true or false
end

--- For the key block window: active layout, whether MH arranged it, whether bars 2/3 are hidden in it,
--- and whether this spec sits on one of Blizzard's presets (Modern/Classic), which cannot be edited.
function ns.MH_EditModeKeyBlockState()
	local name = ActiveLayout()
	local on = KeyBlockLayoutIsOn(name)
	local hidden = on and ns.db and ns.db.keyBlockOldBarsHiddenBy and ns.db.keyBlockOldBarsHiddenBy[name]
	if on and hidden == nil then
		hidden = true -- arranged before the per-layout flags: arranging always hid them
	end
	local onPreset = false
	if not name and C_EditMode and C_EditMode.GetLayouts then
		local okG, info = pcall(C_EditMode.GetLayouts)
		local presets = PresetCount()
		onPreset = okG and type(info) == "table" and presets and (tonumber(info.activeLayout) or 0) <= presets
			and true or false
	end
	return name, on, hidden and true or false, onPreset
end

--------------------------------------------------------------------------------
-- A layout of your own, for a spec on a preset (5 Oct 2026, Rob: "wat als mensen nog de standaard
-- indeling hebben … dat elke karakter zijn eigen naam krijgt, 12-inch prot, …"). mh-research read
-- Blizzard's 12.1.0 source: the "Copy layout" button makes a layout the same way — copy the preset,
-- type Character, SaveLayouts, C_EditMode.OnLayoutAdded(index, activate) — with indexes that count the
-- presets first. Rob MEASURED the active layout per spec the same evening (Prot 5, Ret 7, Holy 1), so
-- the copy is named after the character AND the spec, and only this spec switches to it.
-- The way back is the preset this spec came from (stored per character and spec).
--------------------------------------------------------------------------------

local MAX_CHARACTER_LAYOUTS = 5 -- EditModeMaxLayoutsPerType (EditModeManagerConstantsDocumentation.lua)

local function SpecKey()
	local guid = UnitGUID and UnitGUID("player") or "?"
	local specID = "?"
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local ok, id = pcall(ns.GetSpecializationInfo, ns.GetSpecialization())
		if ok and id then
			specID = tostring(id)
		end
	end
	return guid .. ":" .. specID
end

local function SpecName()
	if ns.GetSpecialization and ns.GetSpecializationInfo then
		local ok, _, name = pcall(ns.GetSpecializationInfo, ns.GetSpecialization())
		if ok and type(name) == "string" and (not ns.CanAccessText or ns.CanAccessText(name)) then
			return name
		end
	end
	return "MH"
end

--- Copy the preset this spec is on into "<Name> <Spec>", make it active, then arrange the block in it.
--- @return boolean ok, string message (a /reload is needed either way when ok)
function ns.MH_EditModeMakeOwnLayout()
	local ok, why = Ready()
	if not ok then
		return false, tostring(why)
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, ns:L("KEYBLOCK_LAYOUT_COMBAT")
	end
	if EditModeManagerFrame and EditModeManagerFrame:IsShown() then
		return false, ns:L("KEYBLOCK_LAYOUT_EDITMODE_OPEN")
	end
	local okG, info = pcall(C_EditMode.GetLayouts)
	local okP, presetList = false, nil
	if EditModePresetLayoutManager and EditModePresetLayoutManager.GetCopyOfPresetLayouts then
		okP, presetList = pcall(EditModePresetLayoutManager.GetCopyOfPresetLayouts, EditModePresetLayoutManager)
	end
	if not (okG and type(info) == "table" and info.layouts and okP and type(presetList) == "table") then
		return false, "Edit Mode returned no layouts."
	end
	local active = tonumber(info.activeLayout) or 0
	local preset = presetList[active]
	if not preset then
		return false, ns:L("KEYBLOCK_OWN_NOT_PRESET")
	end
	local charType = Enum and Enum.EditModeLayoutType and Enum.EditModeLayoutType.Character or 2
	local name = ((UnitName and UnitName("player") or "MH") .. " " .. SpecName()):sub(1, 30)

	-- Already made before (this spec switched back to the preset since): just use it again.
	local idx
	local mine = 0
	for i, l in ipairs(info.layouts) do
		if l.layoutType == charType then
			mine = mine + 1
		end
		if l.layoutName == name then
			idx = #presetList + i
		end
	end
	if not idx then
		if mine >= MAX_CHARACTER_LAYOUTS then
			return false, ns:L("KEYBLOCK_OWN_FULL")
		end
		if C_EditMode.IsValidLayoutName then
			local okN, valid = pcall(C_EditMode.IsValidLayoutName, name)
			if okN and valid == false then
				name = ("MH " .. SpecName()):sub(1, 30)
			end
		end
		local new = Sanitize(preset, 0)
		new.layoutName = name
		new.layoutType = charType
		-- Account layouts come first, then this character's own (measured in Rob's list), so a new
		-- character layout goes at the end; its index counts the presets first.
		table.insert(info.layouts, new)
		idx = #presetList + #info.layouts
		if not pcall(C_EditMode.SaveLayouts, info) then
			return false, "Edit Mode refused the new layout. Nothing changed."
		end
		if C_EditMode.OnLayoutAdded then
			pcall(C_EditMode.OnLayoutAdded, idx, true, false)
		end
	end
	if C_EditMode.SetActiveLayout then
		pcall(C_EditMode.SetActiveLayout, idx)
	end

	-- Check before going on: is the new layout really the active one?
	local okC, now = pcall(C_EditMode.GetLayouts)
	local nowName = okC and now and now.layouts and now.layouts[(tonumber(now.activeLayout) or 0) - #presetList]
	if not (nowName and nowName.layoutName == name) then
		return false, ns:L("KEYBLOCK_OWN_NOT_ACTIVE_FMT"):format(name)
	end

	ns.db.keyBlockPresetBack = ns.db.keyBlockPresetBack or {}
	ns.db.keyBlockPresetBack[SpecKey()] = { preset = active, presetName = preset.layoutName, layout = name }
	-- Remember that MH made this one: arranging it later may still lift the Cooldown Manager.
	ns.db.keyBlockMadeLayouts = ns.db.keyBlockMadeLayouts or {}
	ns.db.keyBlockMadeLayouts[name] = true

	-- And arrange the block in it straight away: one /reload for the whole thing.
	local okA, msg = ns.MH_EditModeApplyKeyBlock(true)
	local head = ns:L("KEYBLOCK_OWN_DONE_FMT"):format(name, tostring(preset.layoutName or "Modern"))
	return true, head .. (okA and ("|n" .. msg) or ("|n" .. tostring(msg)))
end

--- Back to the preset this spec came from, if MH moved it off one. @return true when it did.
local function BackToPreset(activeName)
	local back = ns.db and ns.db.keyBlockPresetBack and ns.db.keyBlockPresetBack[SpecKey()]
	if not (back and back.layout == activeName and C_EditMode.SetActiveLayout) then
		return false
	end
	if not pcall(C_EditMode.SetActiveLayout, back.preset) then
		return false
	end
	ns.db.keyBlockPresetBack[SpecKey()] = nil
	return true, back
end

--- "Put <layout> back": the ACTIVE layout returns to its own copy from before arranging.
--- @return boolean ok, string message
function ns.MH_EditModeRestoreKeyBlock()
	local ok, why = Ready()
	if not ok then
		return false, tostring(why)
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, ns:L("KEYBLOCK_LAYOUT_COMBAT")
	end
	local name, target, info = ActiveLayout()
	if not name then
		return false, ns:L("KEYBLOCK_LAYOUT_NO_UNDO")
	end
	-- Made from a preset by MH: going back means the preset this spec was on. The MH layout itself stays
	-- in the list (the player may want it again, or delete it in Edit Mode).
	-- "Put back" is remembered as false (not nil), so the single old flag can never claim this layout again.
	local function MarkBack()
		ns.db.keyBlockLayoutsOn = ns.db.keyBlockLayoutsOn or {}
		ns.db.keyBlockLayoutsOn[name] = false
	end
	local wentBack, back = BackToPreset(name)
	if wentBack then
		MarkBack()
		if ns.db.keyBlockLayoutSaved then
			ns.db.keyBlockLayoutSaved[name] = nil
		end
		return true, ns:L("KEYBLOCK_OWN_BACK_FMT"):format(tostring(back.presetName or "Modern"))
	end
	local saved = ns.db and ns.db.keyBlockLayoutSaved and ns.db.keyBlockLayoutSaved[name]
	if not saved then
		-- Arranged before 5 Oct evening: the old account-wide undo, but only for the layout it names.
		local u = ns.db and ns.db.editModeBarsUndo
		if u and u.layoutName == name and ns.MH_EditModeRestore and ns.MH_EditModeRestore() then
			MarkBack()
			return true, ns:L("KEYBLOCK_LAYOUT_RESTORED")
		end
		return false, ns:L("KEYBLOCK_LAYOUT_NO_UNDO")
	end
	target.systems = Sanitize(saved, 0)
	if EditModeManagerFrame and EditModeManagerFrame.ReconcileWithModern then
		pcall(EditModeManagerFrame.ReconcileWithModern, EditModeManagerFrame, target)
	end
	if not pcall(C_EditMode.SaveLayouts, info) then
		return false, "Edit Mode refused the restore."
	end
	ns.db.keyBlockLayoutSaved[name] = nil
	MarkBack()
	if ns.db.keyBlockOldBarsHiddenBy then
		ns.db.keyBlockOldBarsHiddenBy[name] = nil
	end
	local u = ns.db.editModeBarsUndo
	if u and u.layoutName == name then
		ns.db.keyBlockLayoutOn = nil
	end
	return true, ns:L("KEYBLOCK_LAYOUT_RESTORED")
end

--- @param fromPreset boolean  the layout was just copied from Modern/Classic by MH: nothing in it was
---                            placed by the player, so MH may also lift the Cooldown Manager off the block
--- @return boolean ok, string message (said in the key block window)
function ns.MH_EditModeApplyKeyBlock(fromPreset)
	local ok, why = Ready()
	if not ok then
		return false, tostring(why)
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, ns:L("KEYBLOCK_LAYOUT_COMBAT")
	end
	if EditModeManagerFrame and EditModeManagerFrame:IsShown() then
		return false, ns:L("KEYBLOCK_LAYOUT_EDITMODE_OPEN")
	end
	-- EllesmereUI draws its own bars and ignores Edit Mode rows: explain instead of writing.
	local loaded = C_AddOns and C_AddOns.IsAddOnLoaded
	if loaded and loaded("EllesmereUIActionBars") then
		return false, ns:L("KEYBLOCK_LAYOUT_ELLESMERE")
	end
	for _, n in ipairs({ 5, 6, 7 }) do
		if not _G[BAR_FRAME_NAMES[n]] then
			return false, ("action bar %d (%s) does not exist on this client"):format(n, BAR_FRAME_NAMES[n])
		end
	end

	local okG, info = pcall(C_EditMode.GetLayouts)
	if not (okG and type(info) == "table" and info.layouts) then
		return false, "Edit Mode returned no layouts."
	end
	local presets = PresetCount()
	if not presets then
		return false, "cannot tell which layout is active (preset list unavailable). Nothing was changed."
	end
	local savedIndex = (tonumber(info.activeLayout) or 0) - presets
	local target = info.layouts[savedIndex]
	if not target then
		return false, ns:L("MH_SAY_PRESET_LAYOUT")
	end
	-- 🔴 ONE WAY BACK PER LAYOUT (5 Oct 2026). There was one undo slot for the whole account: Rob arranged
	-- his Hunter's character layout "Oak", went to his Paladin, and could neither arrange there ("Oak is
	-- already a block") nor undo ("Oak" exists only on the Hunter). Each layout now keeps its own copy of
	-- its systems from before; a second press on the same layout is still refused, because it would save
	-- the BLOCK as "before".
	local layoutName = tostring(target.layoutName)
	if KeyBlockLayoutIsOn(layoutName) then
		return false, ns:L("KEYBLOCK_LAYOUT_ALREADY_FMT"):format(layoutName)
	end
	local notes = {}
	if Enum and Enum.EditModeLayoutType and target.layoutType == Enum.EditModeLayoutType.Account then
		notes[#notes + 1] = (ns:L("MH_SAY_ACCOUNT_LAYOUT")):format(tostring(target.layoutName))
	end

	-- Measure before changing anything: button size and padding of bar A as it is now.
	local btn = _G.MultiBarLeftButton1
	local size = 45
	if btn and btn:GetWidth() and btn:GetWidth() > 0 then
		size = btn:GetWidth() * btn:GetEffectiveScale() / UIParent:GetEffectiveScale()
	end
	local sysBy = {}
	for _, s in ipairs(target.systems or {}) do
		if s.system == BAR_SYSTEM and s.systemIndex then
			sysBy[s.systemIndex] = s
		elseif s.system == EXTRA_SYSTEM then
			sysBy.extra = s
		end
	end
	local pad = tonumber(sysBy[5] and GetSetting(sysBy[5], 4)) or 2
	local blockW = 4 * size + 3 * pad
	-- Four blocks since 5 Oct 2026: D (bar 4, own stuff) left of A, then A, B, C. Centred as a group, so
	-- B sits half a block right of the screen centre.
	-- Five since the same evening: bar 1 as a 3 x 4 block left of D (Rob: "bar 1 op hetzelfde formaat …
	-- links ernaast"). Order 1, D, A, B, C, centred on A, so B sits one block right of the centre.
	local totalW = 5 * blockW + 4 * BLOCK_GAP
	local bOffset = blockW + BLOCK_GAP
	local blockH = 3 * size + 2 * pad
	local bottom = 24

	-- Bar 8 used to stay where it was (Rob's mouse keys) and the block stepped aside for it. Since 5 Oct
	-- evening it joins the row (see below), so nothing needs to step aside any more.
	local shift = 0
	local l8, r8, b8, t8
	if l8 then
		local ucx = UIParent:GetWidth() / 2
		local bl, br = ucx - totalW / 2, ucx + totalW / 2
		local overlapsY = b8 < bottom + blockH + 60 and t8 > bottom
		if overlapsY and l8 < br + BLOCK_GAP and r8 > bl - BLOCK_GAP then
			if (l8 + r8) / 2 >= ucx then
				shift = (l8 - BLOCK_GAP) - br
			else
				shift = (r8 + BLOCK_GAP) - bl
			end
			notes[#notes + 1] = ns:L("KEYBLOCK_LAYOUT_SHIFTED")
		end
	end

	-- Which frames move. Anything else that hangs on one of them is pinned where it is now, so it
	-- does not travel along (Rob's cooldown viewer hangs on bar 4, measured 5 Oct 2026).
	local moving = { [1] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true,
		[11] = true, [12] = true, [13] = true }

	-- Bars 1-4 stay where the player put them (Rob, 5 Oct 2026: "We doen C", after the red team: columns on
	-- the right lay over his quest tracker). Only a bar that would lie OVER the block moves, to a row just
	-- above it. Measured against the live frames, before anything changes.
	local extraH = size + 2 * BLOCK_GAP
	local zoneL = UIParent:GetWidth() / 2 + shift - totalW / 2 - BLOCK_GAP
	local zoneR = UIParent:GetWidth() / 2 + shift + totalW / 2 + BLOCK_GAP
	local zoneT = bottom + blockH + extraH
	local inTheWay = {}
	-- Nothing of 1-4 can be in the way any more: 1 and 4 become blocks, 2 and 3 get hidden. The loop stays
	-- (empty) so a future bar that is not arranged still gets the same check.
	for _, idx in ipairs({}) do
		local l, r, b, t = Rect(_G[BAR_FRAME_NAMES[idx]] or (sysBy[idx] and LiveFrame(sysBy[idx])))
		if sysBy[idx] and l and l < zoneR and r > zoneL and b < zoneT and t > bottom then
			inTheWay[#inTheWay + 1] = idx
			moving[idx] = true
		end
	end
	if #inTheWay > 0 then
		local names = {}
		for _, idx in ipairs(inTheWay) do
			names[#names + 1] = tostring(idx)
		end
		notes[#notes + 1] = ns:L("KEYBLOCK_LAYOUT_LIFTED_FMT"):format(table.concat(names, ", "))
	end
	local movingNames = {}
	for idx in pairs(moving) do
		local s = sysBy[idx]
		local fr = s and LiveFrame(s)
		movingNames[BAR_FRAME_NAMES[idx]] = true
		if fr and fr.GetName and fr:GetName() then
			movingNames[fr:GetName()] = true
		end
	end
	local extraFrame = sysBy.extra and LiveFrame(sysBy.extra)
	if extraFrame and extraFrame.GetName and extraFrame:GetName() then
		movingNames[extraFrame:GetName()] = true
	end

	-- Back-up first. This is the undo (`/mh editmode restore`).
	if not ns.MH_EditModeCapture("before-bars-import") then
		return false, "could not back up your layout, so nothing was changed."
	end
	ns.db.editModeBarsUndo = { savedIndex = savedIndex, layoutName = target.layoutName, by = "keyblock" }
	-- This layout's own way back: a copy of its systems as they are now, under its name.
	ns.db.keyBlockLayoutSaved = ns.db.keyBlockLayoutSaved or {}
	ns.db.keyBlockLayoutSaved[layoutName] = Sanitize(target.systems, 0)

	local pinned = 0
	for _, s in ipairs(target.systems or {}) do
		local isMoving = (s.system == BAR_SYSTEM and moving[s.systemIndex]) or s == sysBy.extra
		local rel = s.anchorInfo and s.anchorInfo.relativeTo
		if not isMoving and rel and movingNames[rel] then
			if PinWhereItIs(s) then
				pinned = pinned + 1
			end
		end
	end

	-- 1. The block: B in the middle, A left of it, C right of it. 3 rows of 4, horizontal.
	-- One icon size for all three (MEASURED 5 Oct 2026, Rob's Hunter layout "Oak": bars 5/6/7 had icon
	-- size 3/2/0, so block C was half the size of A). The largest wins, so nothing the player sized up shrinks.
	local iconSize
	for _, idx in ipairs({ 1, 4, 5, 6, 7 }) do
		local v = sysBy[idx] and tonumber(GetSetting(sysBy[idx], 3))
		if v and (not iconSize or v > iconSize) then
			iconSize = v
		end
	end
	for _, idx in ipairs({ 1, 4, 5, 6, 7 }) do
		local s = sysBy[idx]
		if s then
			SetSetting(s, 0, 0)  -- Orientation: horizontal
			SetSetting(s, 1, 3)  -- NumRows
			SetSetting(s, 2, 12) -- NumIcons
			-- AlwaysShowButtons on: an empty place stays visible, so the block keeps its 3 x 4 shape.
			-- Rob, 5 Oct 2026: "ja, lege knoppen tonen in het blok" (his bars had it off: gaps).
			SetSetting(s, 9, 1)
			-- Visible: Always (value 0, as on every bar Rob can see). MEASURED: "Oak" had bar 7 on 3 =
			-- Hidden, which the game shows only while the spellbook is open — Rob: block C appeared only then.
			-- Bar 1 has no Visible setting at all (measured); never add one it does not have.
			if idx ~= 1 then
				SetSetting(s, 5, 0)
			end
			if iconSize then
				SetSetting(s, 3, iconSize)
			end
		end
	end
	if sysBy[6] then Anchor(sysBy[6], "BOTTOM", "UIParent", "BOTTOM", shift + bOffset, bottom) end
	if sysBy[5] then Anchor(sysBy[5], "BOTTOMRIGHT", BAR_FRAME_NAMES[6], "BOTTOMLEFT", -BLOCK_GAP, 0) end
	if sysBy[7] then Anchor(sysBy[7], "BOTTOMLEFT", BAR_FRAME_NAMES[6], "BOTTOMRIGHT", BLOCK_GAP, 0) end
	-- Bar 8 (mouse keys) right of C, as 3 rows of 2 — Rob, 5 Oct 2026: "rechts naast blokje C … drie rijen
	-- van twee, want zo gebruik ik ze altijd … op de goede maat". Six buttons shown; what stands on
	-- buttons 7-12 stays there, just not on screen.
	if sysBy[8] then
		SetSetting(sysBy[8], 0, 0)  -- horizontal
		SetSetting(sysBy[8], 1, 3)  -- 3 rows
		SetSetting(sysBy[8], 2, 6)  -- 6 buttons -> 3 x 2
		SetSetting(sysBy[8], 5, 0)  -- always visible
		SetSetting(sysBy[8], 9, 1)  -- empty places shown, like the blocks
		if iconSize then
			SetSetting(sysBy[8], 3, iconSize)
		end
		Anchor(sysBy[8], "BOTTOMLEFT", BAR_FRAME_NAMES[7], "BOTTOMRIGHT", BLOCK_GAP, 0)
	end
	-- Block D, left of A (Rob, 5 Oct 2026: "links van A").
	if sysBy[4] then Anchor(sysBy[4], "BOTTOMRIGHT", BAR_FRAME_NAMES[5], "BOTTOMLEFT", -BLOCK_GAP, 0) end
	-- Bar 1, left of D. Its frame is "MainActionBar" (MEASURED as a relativeTo in Rob's own layout).
	if sysBy[1] then
		Anchor(sysBy[1], "BOTTOMRIGHT", BAR_FRAME_NAMES[4], "BOTTOMLEFT", -BLOCK_GAP, 0)
		-- Without the bar art (gryphons, page arrows), so bar 1 looks like the other blocks. MEASURED 5 Oct
		-- 2026: a copy of "Modern" has 6=0 8=0 and showed the art on Rob's Paladin; his own layouts have
		-- 6=1 8=1 on bar 1 and no art. 6 = HideBarArt; 8 is copied from his layout, meaning not looked up.
		SetSetting(sysBy[1], 6, 1)
		SetSetting(sysBy[1], 8, 1)
	end

	-- A layout MH just copied from a preset: the Cooldown Manager sits in Blizzard's default spot, bottom
	-- centre — exactly where the block goes (Rob, 5 Oct 2026, Twelveinchy Holy: "cooldown manager staat
	-- waarschijnlijk aan en die staat onder de knoppen"). Lift Essential above the block row, Utility on
	-- top of it. In a layout the player built, it stays where the player put it.
	-- Frame names: "UtilityCooldownViewer" MEASURED as a relativeTo in Rob's layout; "Essential…" by the
	-- same pattern, checked at run time.
	-- "Made by MH" also covers a layout copied before this flag existed: Rob's "Twelveinchy Holy" (the
	-- name pattern "<character> <spec>" of a character layout MH's preset back-up points at).
	local made = ns.db and ns.db.keyBlockMadeLayouts and ns.db.keyBlockMadeLayouts[layoutName]
	if not made and ns.db and ns.db.keyBlockPresetBack then
		for _, b in pairs(ns.db.keyBlockPresetBack) do
			if b.layout == layoutName then
				made = true
			end
		end
	end
	if not made and UnitName and layoutName == ((UnitName("player") or "") .. " " .. SpecName()):sub(1, 30) then
		made = true
	end
	if fromPreset or made then
		for _, s in ipairs(target.systems or {}) do
			if s.system == 20 and s.systemIndex == 1 and _G.EssentialCooldownViewer then
				-- Over block A, which is the centre of the five (1, D, A, B, C).
				Anchor(s, "BOTTOM", BAR_FRAME_NAMES[5], "TOP", 0, extraH + BLOCK_GAP)
			elseif s.system == 20 and s.systemIndex == 2 and _G.UtilityCooldownViewer and _G.EssentialCooldownViewer then
				Anchor(s, "BOTTOM", "EssentialCooldownViewer", "TOP", 0, 4)
			end
		end
	end

	-- Bars 2 and 3 hidden (Rob: "standaard verborgen", advice 2). Visible = Hidden (3) still shows them
	-- while the spellbook is open — measured on Oak's bar 7 — so spells can still be dragged off them.
	-- "Show my old bars" in the window turns them back on.
	for _, idx in ipairs({ 2, 3 }) do
		if sysBy[idx] then
			SetSetting(sysBy[idx], 5, 3)
		end
	end
	notes[#notes + 1] = ns:L("KEYBLOCK_LAYOUT_HIDDEN_HELP")

	-- Bar 1 cannot be hidden (it has no Visible setting, measured in Rob's layouts) and must stay: skyriding,
	-- vehicles and pet battles put their buttons there. First its empty buttons were hidden; then Rob asked
	-- for it "op hetzelfde formaat … drie rijen van vier, links ernaast", so it is a block like the others,
	-- empty places shown (set in the loop above).

	-- 2. Only the bars 1-4 that were in the way: one horizontal row each, stacked above the extra bars.
	local rowH = size + pad + 6
	for k, idx in ipairs(inTheWay) do
		local s = sysBy[idx]
		SetSetting(s, 0, 0) -- Orientation: horizontal
		SetSetting(s, 1, 1) -- one row
		Anchor(s, "BOTTOM", "UIParent", "BOTTOM", shift, zoneT + BLOCK_GAP + (k - 1) * rowH)
	end

	-- 3. The game's extra bars, just above the block.
	if sysBy[11] then Anchor(sysBy[11], "BOTTOMLEFT", BAR_FRAME_NAMES[5], "TOPLEFT", 0, BLOCK_GAP) end
	if sysBy[13] then Anchor(sysBy[13], "BOTTOMLEFT", BAR_FRAME_NAMES[5], "TOPLEFT", 0, BLOCK_GAP) end
	if sysBy[12] then Anchor(sysBy[12], "BOTTOMRIGHT", BAR_FRAME_NAMES[7], "TOPRIGHT", 0, BLOCK_GAP) end
	if sysBy.extra then Anchor(sysBy.extra, "BOTTOM", BAR_FRAME_NAMES[6], "TOP", 0, BLOCK_GAP) end

	if EditModeManagerFrame and EditModeManagerFrame.ReconcileWithModern then
		pcall(EditModeManagerFrame.ReconcileWithModern, EditModeManagerFrame, target)
	end
	if not pcall(C_EditMode.SaveLayouts, info) then
		return false, "Edit Mode refused the change. Your layout is untouched."
	end

	if ns.db then
		ns.db.keyBlockLayoutsOn = ns.db.keyBlockLayoutsOn or {}
		ns.db.keyBlockLayoutsOn[layoutName] = true
		ns.db.keyBlockOldBarsHiddenBy = ns.db.keyBlockOldBarsHiddenBy or {}
		ns.db.keyBlockOldBarsHiddenBy[layoutName] = true
		ns.db.keyBlockLayoutProbe = { size = size, pad = pad, shift = shift, pinned = pinned,
			layout = target.layoutName, at = time() }
	end
	local msg = ns:L("KEYBLOCK_LAYOUT_DONE_FMT"):format(tostring(target.layoutName), pinned)
	if #notes > 0 then
		msg = table.concat(notes, " ") .. "|n" .. msg
	end
	print(Prefix() .. " " .. msg)
	return true, msg
end

--- "Show my old bars" / "Hide my old bars": bars 2 and 3 of the ACTIVE layout, Visible Always (0) or
--- Hidden (3). Rob, 5 Oct 2026: players must be able to get them back, and know how. Needs a /reload.
--- @return boolean ok, string message
function ns.MH_EditModeOldBars(show)
	local ok, why = Ready()
	if not ok then
		return false, tostring(why)
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, ns:L("KEYBLOCK_LAYOUT_COMBAT")
	end
	if EditModeManagerFrame and EditModeManagerFrame:IsShown() then
		return false, ns:L("KEYBLOCK_LAYOUT_EDITMODE_OPEN")
	end
	local okG, info = pcall(C_EditMode.GetLayouts)
	local presets = PresetCount()
	if not (okG and type(info) == "table" and info.layouts and presets) then
		return false, "Edit Mode returned no layouts."
	end
	local target = info.layouts[(tonumber(info.activeLayout) or 0) - presets]
	if not target then
		return false, ns:L("MH_SAY_PRESET_LAYOUT")
	end
	for _, s in ipairs(target.systems or {}) do
		if s.system == BAR_SYSTEM and (s.systemIndex == 2 or s.systemIndex == 3) then
			SetSetting(s, 5, show and 0 or 3)
		end
	end
	if not pcall(C_EditMode.SaveLayouts, info) then
		return false, "Edit Mode refused the change."
	end
	ns.db.keyBlockOldBarsHiddenBy = ns.db.keyBlockOldBarsHiddenBy or {}
	ns.db.keyBlockOldBarsHiddenBy[tostring(target.layoutName)] = not show
	return true, ns:L(show and "KEYBLOCK_OLDBARS_SHOWN" or "KEYBLOCK_OLDBARS_HIDDEN")
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
	-- ClearFocus before Hide: a hidden EditBox that still owns the keyboard eats the
	-- movement keys, and nothing on screen points at us. See PawnExport for the note.
	edit:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
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
	if why == "unchanged" then
		print(("%s Edit Mode unchanged since the newest snapshot, so it was not stored again — keeping |cffffffff%d|r snapshot(s)."):format(
			Prefix(), #list))
	else
		print(("%s Edit Mode captured — |cffffffff%d|r layout(s), keeping the last |cffffffff%d|r snapshot(s)."):format(
			Prefix(), #(list[1] and list[1].summary or {}), #list))
	end
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
