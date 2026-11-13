local _, ns = ...

--[[
	ForeverLayoutCarry.lua — WoW Forever: take your Edit Mode layout (bars, positions, which bars are on) to every new
	character with one click.

	Rob, 7 Nov 2026: "ik moet bij elke character alles weer recht zetten en bars aanzetten, kan dat beter ?" → option 2:
	"MH helps on new characters". His layout "Inchy Hunter" was a CHARACTER layout, so every new character started on
	Blizzard's Modern preset again.

	  /mh mylayout remember  — on the character whose layout is right: MH keeps a copy of the ACTIVE layout (Blizzard's own
	                           export string, account-wide in MidnightHelperDB).
	  On a character that sits on a preset (Modern/Classic), MH asks ONCE: "Use your layout '<name>' here?"
	    Yes  → the layout is added to this character (or, when an account layout of that name exists, simply chosen) and
	           made active; then a SECOND click, "Reload now", reloads (one click was blocked, see AskReload below).
	    No   → MH does not ask this character again.
	  /mh mylayout           — ask now (also on a character that said No);  /mh mylayout check — what MH sees and why;
	  /mh mylayout forget    — drop the copy.

	Why only after a click, never by itself: EditModeBackup.lua's own notes — switching layouts by code needs the presets
	counted first, a SaveLayouts, and a reload, or it taints; the same steps as MH_EditModeMakeOwnLayout (Blizzard's
	"Copy layout" path, read by mh-research on 12.1.0) are used here. Not in combat, not with Edit Mode open.
	That the bars' on/off state travels inside the layout string: GEMETEN on retail 12.0.7 (BarPreset.lua, VisibleSetting
	per bar); AFGELEID for Forever. English only, like the other Forever texts.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MAX_CHARACTER_LAYOUTS = 5 -- EditModeMaxLayoutsPerType, as EditModeBackup.lua

local function Ready()
	if not (C_EditMode and C_EditMode.GetLayouts) then
		return false, "this client has no C_EditMode.GetLayouts"
	end
	if not (EditModeManagerFrame and EditModeManagerFrame.accountSettings) then
		return false, "Edit Mode has not finished loading yet"
	end
	return true
end

local function Presets()
	if EditModePresetLayoutManager and EditModePresetLayoutManager.GetCopyOfPresetLayouts then
		local ok, list = pcall(EditModePresetLayoutManager.GetCopyOfPresetLayouts, EditModePresetLayoutManager)
		if ok and type(list) == "table" then
			return #list
		end
	end
	return nil
end

--- Active layout: index, the saved layout table (nil on a preset), the GetLayouts info, the preset count.
local function Active()
	local okG, info = pcall(C_EditMode.GetLayouts)
	local presets = Presets()
	if not (okG and type(info) == "table" and info.layouts and presets) then
		return nil
	end
	local idx = tonumber(info.activeLayout) or 0
	return idx, info.layouts[idx - presets], info, presets
end

local function Store()
	return ns.db -- MidnightHelperDB: account-wide, so every character sees the remembered layout
end

local function CharKey()
	return (UnitGUID and UnitGUID("player")) or (UnitName and UnitName("player")) or "?"
end

--- 🔴 WHICH BARS ARE ON IS NOT IN THE LAYOUT — GEMETEN 7 Nov 2026 with /mh bars (BarInventory) on Rob's two characters,
--- same layout "Inchy Hunter", AlwaysShowButtons on for bars 1-8 in both: GetActionBarToggles gave 7 values, all "false"
--- on the new Shaman and all "true" on the Hunter. So the on/off switches of bars 2-8 belong to the CHARACTER, and the
--- layout alone left the Shaman's bars off. We read them on "remember" and set them on "Yes".
--- That SetActionBarToggles takes the same 7 values in the same order as Get returns them is AFGELEID (symmetry);
--- Rob's case is all-true, where the order cannot matter.
local function ReadBarToggles()
	if type(GetActionBarToggles) ~= "function" then
		return nil
	end
	local packed = { pcall(GetActionBarToggles) }
	if not packed[1] then
		return nil
	end
	local out = {}
	for i = 2, #packed do
		out[#out + 1] = packed[i] and true or false
	end
	return #out > 0 and out or nil
end

--- /mh mylayout remember
local function Remember()
	local ok, why = Ready()
	if not ok then
		print(PREFIX .. "my layout: cannot read Edit Mode - " .. why .. ".")
		return
	end
	local _, layout = Active()
	if not layout then
		print(PREFIX .. "my layout: this character is on one of Blizzard's presets (Modern/Classic). Set up your bars " ..
			"in a layout of your own first, then type /mh mylayout remember there.")
		return
	end
	local okS, str = pcall(C_EditMode.ConvertLayoutInfoToString, layout)
	if not (okS and type(str) == "string" and str ~= "") then
		print(PREFIX .. "my layout: Edit Mode would not export this layout. Nothing saved.")
		return
	end
	local db = Store()
	if not db then
		return
	end
	db.foreverMyLayout = { name = tostring(layout.layoutName), str = str, from = UnitName and UnitName("player"),
		at = time and time() or nil, bars = ReadBarToggles() }
	db.foreverMyLayoutAsked = {} -- a new copy: every character may be asked again
	local bars = db.foreverMyLayout.bars
	local on = 0
	for _, v in ipairs(bars or {}) do
		if v then
			on = on + 1
		end
	end
	print(PREFIX .. ("my layout: remembered \"%s\" (bars on: %s). Every character on Modern or Classic will be offered " ..
		"it once."):format(db.foreverMyLayout.name, bars and (on .. " of " .. #bars) or "could not read"))
end

--- Add (or find) the remembered layout on this character and make it active. @return ok, message
local function UseHere()
	local ok, why = Ready()
	if not ok then
		return false, why
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, "not in combat"
	end
	if EditModeManagerFrame and EditModeManagerFrame:IsShown() then
		return false, "close Edit Mode first"
	end
	local mine = Store() and Store().foreverMyLayout
	if not mine then
		return false, "no layout remembered yet (/mh mylayout remember on the character that has it right)"
	end
	local _, _, info, presets = Active()
	if not info then
		return false, "Edit Mode returned no layouts"
	end
	local charType = Enum and Enum.EditModeLayoutType and Enum.EditModeLayoutType.Character or 2
	-- Already there (an account layout of that name, or this character's own copy from before)? Just choose it.
	local idx, count = nil, 0
	for i, l in ipairs(info.layouts) do
		if l.layoutType == charType then
			count = count + 1
		end
		if l.layoutName == mine.name then
			idx = presets + i
		end
	end
	if not idx then
		if count >= MAX_CHARACTER_LAYOUTS then
			return false, "this character already has 5 layouts of its own (Blizzard's maximum)"
		end
		local okC, new = pcall(C_EditMode.ConvertStringToLayoutInfo, mine.str)
		if not (okC and type(new) == "table") then
			return false, "Edit Mode could not read the remembered layout (a newer game patch?). Remember it again."
		end
		new.layoutName = mine.name
		new.layoutType = charType
		table.insert(info.layouts, new)
		idx = presets + #info.layouts
		if not pcall(C_EditMode.SaveLayouts, info) then
			return false, "Edit Mode refused the layout. Nothing changed."
		end
		if C_EditMode.OnLayoutAdded then
			pcall(C_EditMode.OnLayoutAdded, idx, true, false)
		end
	end
	if C_EditMode.SetActiveLayout then
		pcall(C_EditMode.SetActiveLayout, idx)
	end
	local _, now = Active()
	if not (now and now.layoutName == mine.name) then
		return false, ("\"%s\" was added but did not become active. Pick it in Edit Mode yourself."):format(mine.name)
	end
	-- The bars' on/off switches (per character, see ReadBarToggles), as on the character that remembered the layout.
	local barsNote = ""
	if mine.bars and type(SetActionBarToggles) == "function" then
		local okT = pcall(SetActionBarToggles, (unpack or table.unpack)(mine.bars))
		local on = 0
		for _, v in ipairs(mine.bars) do
			if v then
				on = on + 1
			end
		end
		barsNote = okT and (" Bars switched on: %d of %d."):format(on, #mine.bars)
			or " Could not switch the bars on: do it in Options -> Action Bars."
	elseif not mine.bars then
		barsNote = " (Which bars are on was not remembered: /mh mylayout remember again on " ..
			tostring(mine.from or "that character") .. ".)"
	end
	return true, ("\"%s\" is now this character's layout.%s"):format(mine.name, barsNote)
end
ns.ForeverMyLayoutUse = UseHere

--- 🔴 THE RELOAD IS ITS OWN CLICK — Rob, 7 Nov 2026 (BugSack): "AddOn 'MidnightHelper' tried to call the protected
--- function 'Reload()'", from ReloadUI() in the SAME click that had just run SaveLayouts/SetActiveLayout. The key
--- block never hit this: it changes the layout in one click and offers the reload in a Blizzard StaticPopup, a second
--- click (KeyBlock.lua NeedReload → KeyBlockReloadAndReopen, working for Rob since 5 Oct 2026). Same pattern here.
--- That the block came from doing both in one execution is AFGELEID; the two-click path is the measured one.
function ns.ForeverMyLayoutAskReload()
	if not (StaticPopupDialogs and StaticPopup_Show) then
		print(PREFIX .. "my layout: type /reload to finish.")
		return
	end
	StaticPopupDialogs["MH_FOREVER_MYLAYOUT_RELOAD"] = StaticPopupDialogs["MH_FOREVER_MYLAYOUT_RELOAD"] or {
		text = "Your layout is set. Reload now to finish?",
		button1 = "Reload now",
		button2 = "Later",
		OnAccept = function()
			if C_UI and C_UI.Reload then
				C_UI.Reload()
			elseif ReloadUI then
				ReloadUI()
			end
		end,
		OnCancel = function()
			print(PREFIX .. "my layout: type /reload when you are ready; until then some bars may look half-moved.")
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
	local pop = StaticPopup_Show("MH_FOREVER_MYLAYOUT_RELOAD")
	if pop and pop.SetFrameStrata then
		pop:SetFrameStrata("FULLSCREEN_DIALOG")
	end
end

local dialog

local function Ask(force)
	local db = Store()
	local mine = db and db.foreverMyLayout
	if not mine then
		return
	end
	if not dialog then
		local f = CreateFrame("Frame", "MidnightHelperForeverMyLayout", UIParent, "BackdropTemplate")
		f:SetSize(380, 142)
		f:SetPoint("TOP", 0, -180)
		f:SetFrameStrata("DIALOG")
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
		-- Below the "Dock to window" button, like the bar layout question (13 Nov 2026).
		f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		f.text:SetPoint("TOP", 0, -34)
		f.text:SetWidth(340)
		local yes = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		yes:SetSize(150, 24)
		yes:SetPoint("BOTTOMLEFT", 24, 18)
		yes:SetText("Yes")
		yes:SetScript("OnClick", function()
			local ok, msg = UseHere()
			print(PREFIX .. "my layout: " .. msg)
			f:Hide()
			if ok then
				ns.ForeverMyLayoutAskReload()
			end
		end)
		local no = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		no:SetSize(150, 24)
		no:SetPoint("BOTTOMRIGHT", -24, 18)
		no:SetText("Not on this character")
		no:SetScript("OnClick", function()
			local s = Store()
			if s then
				s.foreverMyLayoutAsked = s.foreverMyLayoutAsked or {}
				s.foreverMyLayoutAsked[CharKey()] = true
			end
			print(PREFIX .. "my layout: not asked again here. /mh mylayout asks again.")
			f:Hide()
		end)
		if ns.RegisterMidnightDialogPopup then
			ns.RegisterMidnightDialogPopup(f)
		else
			tinsert(UISpecialFrames, f:GetName())
		end
		dialog = f
	end
	dialog.text:SetText(("Use your layout |cffffd100%s|r here?\nYour bars, where they stand and which are on, as on %s.")
		:format(mine.name, tostring(mine.from or "your other character")))
	dialog:Show()
end

--- Why MH does or does not ask on this character (printed by /mh mylayout check).
local function Decision()
	local db = Store()
	local mine = db and db.foreverMyLayout
	if not mine then
		return false, "no layout remembered (/mh mylayout remember)"
	end
	local ok, why = Ready()
	if not ok then
		return false, why
	end
	local idx, layout, _, presets = Active()
	if not idx then
		return false, "Edit Mode returned no layouts"
	end
	if layout then
		return false, ("this character already uses its own layout \"%s\""):format(tostring(layout.layoutName))
	end
	if db.foreverMyLayoutAsked and db.foreverMyLayoutAsked[CharKey()] then
		return false, "you said \"Not on this character\" here"
	end
	return true, ("on preset %d of %d: offer \"%s\""):format(idx, presets, mine.name)
end

function ns.ForeverMyLayoutSlash(arg)
	arg = (arg or ""):lower()
	if arg == "remember" then
		Remember()
	elseif arg == "forget" then
		if Store() then
			Store().foreverMyLayout = nil
		end
		print(PREFIX .. "my layout: forgotten. MH will not offer it any more.")
	elseif arg == "check" then
		local mine = Store() and Store().foreverMyLayout
		local yes, why = Decision()
		print(PREFIX .. ("my layout: remembered %s; offered here by hand: %s - %s"):format(
			mine and ("\"" .. mine.name .. "\" from " .. tostring(mine.from)) or "nothing", yes and "yes" or "no", why))
		local yesB, whyB = ns.ForeverBarLayoutDecision() -- defined further down; called at run time
		print(PREFIX .. ("bar layout question at login: %s - %s"):format(yesB and "would ask" or "no question", whyB))
	elseif Store() and Store().foreverMyLayout then
		Ask(true)
	else
		print(PREFIX .. "my layout: nothing remembered yet. On the character whose bars are right: /mh mylayout remember")
	end
end

--------------------------------------------------------------------------------
-- 🔴 THE QUESTION ON A NEW CHARACTER IS THE MH BAR LAYOUT — Rob, 7 Nov 2026: "Is het een idee om dit gewoon eigenlijk
-- standaard te vragen op het moment dat mensen een nieuw karakter maken? En dat we dat hebben in plaats van … die
-- hunter-layout … En daar ook gelijk een knopje bij als deze vraag niet meer willen hebben? En later … settings aan- en
-- uitzetten" → "Doe voorlopig alleen maar forever … Bouw het maar."
-- So on a Forever character that still sits on Modern/Classic, MH offers the key block's step 2 (its own layout: the
-- blocks, bars switched on, menu and bags bottom-right, gryphons hidden, XP bar above block A — all measured today on
-- Rob's characters). Yes → MH_EditModeMakeOwnLayout, then a Blizzard popup "Reload now" (a second click: one click with
-- the reload was blocked) that reopens the key block for step 1 (spells on keys). "Not now" = not on this character.
-- "Never ask again" = the setting off (Settings → Midnight Helper → key block; on by default).
-- The automatic "Use your layout X?" question is gone with this (Rob's choice); /mh mylayout still offers it by hand.
--------------------------------------------------------------------------------

function ns.IsForeverBarLayoutAskOn()
	return not (ns.db and ns.db.foreverAskBarLayout == false)
end

function ns.SetForeverBarLayoutAsk(on)
	if ns.db then
		ns.db.foreverAskBarLayout = on and true or false
	end
end

--- Why MH does or does not offer the MH bar layout on this character (also printed by /mh mylayout check).
local function BarDecision()
	if not ns.IsForeverBarLayoutAskOn() then
		return false, "switched off (Settings, or \"Never ask again\")"
	end
	if not ns.MH_EditModeMakeOwnLayout then
		return false, "the key block's layout step is not loaded"
	end
	local loaded = C_AddOns and C_AddOns.IsAddOnLoaded
	if loaded and loaded("EllesmereUIActionBars") then
		return false, "EllesmereUI draws the bars (the block step cannot arrange them)"
	end
	local ok, why = Ready()
	if not ok then
		return false, why
	end
	local idx, layout = Active()
	if not idx then
		return false, "Edit Mode returned no layouts"
	end
	if layout then
		return false, ("this character already uses its own layout \"%s\""):format(tostring(layout.layoutName))
	end
	local asked = Store() and Store().foreverBarLayoutAsked
	if asked and asked[CharKey()] then
		return false, "you said \"Not now\" on this character"
	end
	return true, "on Modern/Classic: offer the MH bar layout"
end
ns.ForeverBarLayoutDecision = BarDecision -- the offline check calls it

local barDialog

local function AskReloadAndReopen()
	if not (StaticPopupDialogs and StaticPopup_Show) then
		print(PREFIX .. ns:L("FBAR_RELOAD_CHAT"))
		return
	end
	-- Texts set on every show, so a language switch in between is followed (the dialog table is kept).
	StaticPopupDialogs["MH_FOREVER_BARLAYOUT_RELOAD"] = StaticPopupDialogs["MH_FOREVER_BARLAYOUT_RELOAD"] or {}
	local dlg = StaticPopupDialogs["MH_FOREVER_BARLAYOUT_RELOAD"]
	dlg.text = ns:L("FBAR_RELOAD_TEXT")
	dlg.button1 = ns:L("KEYBLOCK_BTN_RELOAD")
	dlg.button2 = ns:L("KEYBLOCK_NEW_LATER")
	for k, v in pairs({
		OnAccept = function()
			if ns.KeyBlockReloadAndReopen then
				ns.KeyBlockReloadAndReopen()
			elseif C_UI and C_UI.Reload then
				C_UI.Reload()
			end
		end,
		OnCancel = function()
			print(PREFIX .. ns:L("FBAR_RELOAD_LATER_CHAT"))
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}) do
		dlg[k] = v
	end
	local pop = StaticPopup_Show("MH_FOREVER_BARLAYOUT_RELOAD")
	if pop and pop.SetFrameStrata then
		pop:SetFrameStrata("FULLSCREEN_DIALOG")
	end
end

local function AskBarLayout()
	if not barDialog then
		local f = CreateFrame("Frame", "MidnightHelperForeverBarLayout", UIParent, "BackdropTemplate")
		f:SetSize(440, 162)
		f:SetPoint("TOP", 0, -180)
		f:SetFrameStrata("DIALOG")
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
		-- Starts below RegisterMidnightDialogPopup's "Dock to window" button (top right, y -10 to -26). Rob's screenshot,
		-- 13 Nov 2026 (new Forever hunter): at -22 the first line ran into it; his "1 fixen". 12 px taller to match.
		f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		f.text:SetPoint("TOP", 0, -34)
		f.text:SetWidth(400)
		local function Btn(label, x, onClick)
			local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
			b:SetSize(130, 24)
			b:SetPoint("BOTTOMLEFT", x, 18)
			b:SetText(label)
			b:SetScript("OnClick", onClick)
			return b
		end
		f.yes = Btn("", 20, function()
			f:Hide()
			local ok, msg = ns.MH_EditModeMakeOwnLayout()
			if not ok then
				print(PREFIX .. ns:L("FBAR_FAILED_FMT"):format(tostring(msg)))
				return
			end
			AskReloadAndReopen()
		end)
		f.notNow = Btn("", 155, function()
			local s = Store()
			if s then
				s.foreverBarLayoutAsked = s.foreverBarLayoutAsked or {}
				s.foreverBarLayoutAsked[CharKey()] = true
			end
			print(PREFIX .. ns:L("FBAR_NOT_NOW_CHAT"))
			f:Hide()
		end)
		f.never = Btn("", 290, function()
			ns.SetForeverBarLayoutAsk(false)
			if ns.SyncNativeSetting then
				ns.SyncNativeSetting("mh_foreverAskBarLayout", false)
			end
			print(PREFIX .. ns:L("FBAR_NEVER_CHAT_FMT"):format(ns:L("SET_FOREVER_BARLAYOUT_TITLE")))
			f:Hide()
		end)
		if ns.RegisterMidnightDialogPopup then
			ns.RegisterMidnightDialogPopup(f)
		else
			tinsert(UISpecialFrames, f:GetName())
		end
		barDialog = f
	end
	-- 7 Nov 2026: translatable; set on every show so the language of the moment is used.
	barDialog.text:SetText(ns:L("FBAR_ASK_TEXT"))
	barDialog.yes:SetText(ns:L("FBAR_YES")) -- not Blizzard's YES: MH's own language can differ from the client's
	barDialog.notNow:SetText(ns:L("FBAR_NOT_NOW"))
	barDialog.never:SetText(ns:L("FBAR_NEVER"))
	barDialog:Show()
end
ns.ForeverBarLayoutAsk = AskBarLayout

-- After login: Edit Mode needs a moment to load its account settings, never in combat, and not during the intro
-- movie. Rob, 7 Nov 2026: the question never came on a brand-new character (stuck on the intro movie, he thought);
-- /mh mylayout did show it. Two holes, both closed here (cause AFGELEID, not measured): only "not finished loading"
-- was retried — "Edit Mode returned no layouts" (presets not there yet) ended it for good — and a movie was not waited
-- for. Now every not-ready reason is retried for about a minute, and a movie is waited out (CINEMATIC_STOP).
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
pcall(ev.RegisterEvent, ev, "CINEMATIC_STOP")
pcall(ev.RegisterEvent, ev, "STOP_MOVIE")
local done, waiting, tries = false, false, 0
local NOT_YET = {
	["Edit Mode has not finished loading yet"] = true,
	["Edit Mode returned no layouts"] = true,
	["this client has no C_EditMode.GetLayouts"] = false, -- a client without Edit Mode: nothing to wait for
}
local function Try()
	if done then
		return
	end
	tries = tries + 1
	if InCombatLockdown and InCombatLockdown() then
		waiting = true
		return
	end
	if InCinematic and InCinematic() then
		waiting = true -- CINEMATIC_STOP / STOP_MOVIE tries again
		return
	end
	local yes, why = BarDecision() -- the MH bar layout (Rob, 7 Nov 2026), no longer "Use your layout X?"
	if yes then
		done = true
		AskBarLayout()
	elseif NOT_YET[why] and tries < 30 and C_Timer and C_Timer.After then
		C_Timer.After(2, Try)
	else
		done = true
	end
end
ev:SetScript("OnEvent", function(_, event)
	if (event == "PLAYER_REGEN_ENABLED" or event == "CINEMATIC_STOP" or event == "STOP_MOVIE") and not waiting then
		return
	end
	waiting = false
	if C_Timer and C_Timer.After then
		C_Timer.After(3, Try)
	else
		Try()
	end
end)
