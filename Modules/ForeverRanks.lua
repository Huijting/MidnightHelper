local _, ns = ...

--[[
	ForeverRanks.lua — WoW Forever: buttons that still cast an old rank of a spell.

	Rob, 9 Nov 2026: idea 2 of the Forever round ("Ja, ik volg jouw adviezen"). Blizzard, beta notes of 2 Nov (Kaivax, forum
	post 2360696/9): learning a spell no longer puts it on your bars. Beta players (Wowhead 22 Sep, WoWForeverBuilds 23 Sep)
	saw a button keep the old rank after training the new one. ⚠️ Not measured after launch: maybe the game upgrades some
	buttons itself. Then this module simply finds nothing. /mh ranks shows what it sees.

	How it decides, with our own data (ns.FOREVER_SPELL_IDS, every rank per spell in rank order, wago DB2 7 Nov):
	  - a button holds rank i of a spell, and you know a higher rank → "lower rank".
	  - "just trained": the rank on the button was your highest until a moment ago (we remember the highest rank per
	    spell per character). Those are the ones you almost surely want to upgrade. A lower rank you put there on purpose
	    (downranking to save mana) is never touched by itself.
	Players choose (never us):
	  - default: a button under the trainer window, and one chat line, "N buttons still have the old rank". One click.
	  - /mh ranks auto on: upgrade "just trained" buttons by themselves, out of combat.
	  - /mh ranks fix: upgrade every lower rank, also the ones you placed on purpose.
	  - /mh ranks: what MH sees, per button, and why (a quiet module needs a way to see that it was quiet on purpose).
	Replacing: C_Spell.PickupSpell + PlaceAction, only out of combat and with an empty cursor, read back afterwards
	(the same door as KeyBlock.lua; Zygor Forever does the same, Pointer.lua). Flyouts and macros are left alone.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MAX_SLOT = 180

-- id -> { name, idx, list }
local INFO
local function Info()
	if INFO then
		return INFO
	end
	INFO = {}
	for name, list in pairs(ns.FOREVER_SPELL_IDS or {}) do
		for i, id in ipairs(list) do
			INFO[id] = { name = name, idx = i, list = list }
		end
	end
	return INFO
end

local function Known(id)
	if IsPlayerSpell then
		local ok, v = pcall(IsPlayerSpell, id)
		if ok and v then
			return true
		end
	end
	if IsSpellKnown then
		local ok, v = pcall(IsSpellKnown, id)
		if ok and v then
			return true
		end
	end
	return false
end

--- Highest known rank of a spell: index and id, or nil.
local function Top(list)
	for i = #list, 1, -1 do
		if Known(list[i]) then
			return i, list[i]
		end
	end
	return nil
end

local function Settings()
	if not ns.db then
		return { top = {} }
	end
	ns.db.foreverRanks = ns.db.foreverRanks or {}
	local s = ns.db.foreverRanks
	s.top = s.top or {}
	return s
end

local function CharKey()
	local name, realm = UnitFullName and UnitFullName("player")
	return (name or "?") .. "-" .. (realm or (GetRealmName and GetRealmName()) or "?")
end

local function CharTops()
	local s = Settings()
	local k = CharKey()
	s.top[k] = s.top[k] or {}
	return s.top[k]
end

-- Ranks that were your highest until this session's last learn: name -> old top index.
local fresh = {}

--- Remember the highest rank per spell; a spell whose top rose marks its old top as "just trained".
local function UpdateTops()
	local tops = CharTops()
	local first = next(tops) == nil
	local seen = {}
	for _, info in pairs(Info()) do
		if not seen[info.name] then
			seen[info.name] = true
			local idx = Top(info.list)
			local old = tops[info.name]
			if idx then
				if old and idx > old and not first then
					fresh[info.name] = old
				end
				tops[info.name] = idx
			end
		end
	end
end

--- Every spell button holding a lower rank than you know: { slot, from, to, name, fromIdx, toIdx, fresh }.
local function Scan()
	local out, spells, ranked = {}, 0, 0
	if not GetActionInfo then
		return out, spells, ranked
	end
	local info = Info()
	for slot = 1, MAX_SLOT do
		local ok, kind, id = pcall(GetActionInfo, slot)
		if ok and kind == "spell" and type(id) == "number" then
			spells = spells + 1
			local i = info[id]
			if i then
				ranked = ranked + 1
				local topIdx, topId = Top(i.list)
				if topIdx and topIdx > i.idx then
					out[#out + 1] = { slot = slot, from = id, to = topId, name = i.name, fromIdx = i.idx, toIdx = topIdx,
						fresh = fresh[i.name] == i.idx }
				end
			end
		end
	end
	return out, spells, ranked
end

local function FreshOnly(list)
	local out = {}
	for _, r in ipairs(list) do
		if r.fresh then
			out[#out + 1] = r
		end
	end
	return out
end

local function CursorEmpty()
	return not (GetCursorInfo and GetCursorInfo())
end

--- Put the top rank on each button. Returns done, failed, reason.
local function Replace(list)
	if InCombatLockdown and InCombatLockdown() then
		return 0, #list, "combat"
	end
	if not CursorEmpty() then
		return 0, #list, "cursor"
	end
	local done, failed = 0, 0
	for _, r in ipairs(list) do
		pcall(function()
			ClearCursor()
			if C_Spell and C_Spell.PickupSpell then
				C_Spell.PickupSpell(r.to)
			else
				PickupSpell(r.to)
			end
			PlaceAction(r.slot)
			ClearCursor()
		end)
		pcall(ClearCursor)
		local ok, kind, id = pcall(GetActionInfo, r.slot)
		if ok and kind == "spell" and id == r.to then
			done = done + 1
		else
			failed = failed + 1
		end
	end
	return done, failed
end

local function Report(done, failed, reason)
	if reason == "combat" then
		print(PREFIX .. ns:L("FRANK_COMBAT"))
	elseif reason == "cursor" then
		print(PREFIX .. ns:L("FRANK_CURSOR"))
	else
		print(PREFIX .. ns:L("FRANK_DONE_FMT"):format(done) .. (failed > 0 and (" " .. ns:L("FRANK_FAILED_FMT"):format(failed)) or ""))
	end
end

local btn
local function TrainerFrame()
	local f = _G.ClassTrainerFrame
	if f and f.IsShown and f:IsShown() then
		return f
	end
end

local Refresh -- forward

local function Fix(all)
	local list = Scan()
	if not all then
		list = FreshOnly(list)
	end
	if #list == 0 then
		print(PREFIX .. ns:L("FRANK_NONE"))
		return
	end
	local done, failed, reason = Replace(list)
	Report(done, failed, reason)
	if done > 0 and not all then
		for _, r in ipairs(list) do
			fresh[r.name] = nil
		end
	end
	Refresh()
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
end

Refresh = function()
	local tf = TrainerFrame()
	if not tf then
		if btn then
			btn:Hide()
		end
		return
	end
	local n = #FreshOnly(Scan())
	if n == 0 then
		if btn then
			btn:Hide()
		end
		return
	end
	if not btn then
		btn = CreateFrame("Button", "MidnightHelperRankUp", tf, "UIPanelButtonTemplate")
		btn:SetSize(170, 22)
		btn:SetScript("OnClick", function()
			Fix(false)
		end)
		btn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(ns:L("FRANK_BTN_TIP_TITLE"), 1, 0.82, 0)
			for _, r in ipairs(FreshOnly(Scan())) do
				GameTooltip:AddLine(ns:L("FRANK_TIP_ROW_FMT"):format(r.name, r.fromIdx, r.toIdx), 1, 1, 1)
			end
			GameTooltip:AddLine(ns:L("FRANK_BTN_TIP_BODY"), 0.75, 0.75, 0.75, true)
			GameTooltip:Show()
		end)
		btn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	elseif btn:GetParent() ~= tf then
		btn:SetParent(tf)
	end
	btn:ClearAllPoints()
	-- Under our Train all button (or the game's Train button), on the left so the two never overlap.
	local anchor = (_G.MidnightHelperTrainAll and _G.MidnightHelperTrainAll:IsShown() and _G.MidnightHelperTrainAll)
		or _G.ClassTrainerTrainButton or tf.TrainButton
	if anchor then
		btn:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -4)
	else
		btn:SetPoint("TOPLEFT", tf, "BOTTOMLEFT", 0, -4)
	end
	btn:SetText(ns:L("FRANK_BTN_FMT"):format(n))
	local fs = btn:GetFontString()
	btn:SetWidth(math.max(170, math.ceil(((fs and fs:GetStringWidth()) or 120) + 30)))
	btn:Show()
end

--- For the start page: how many buttons hold a lower rank (all of them), or 0.
function ns.ForeverRankCount()
	return #(Scan())
end

--- 14 Nov 2026 (Rob via sparring, letterlijk: "Ja, doe allebei maar"): the "Do this now" / start-page sentence names
--- WHICH spell casts the lower rank ("Lightning Bolt: rank 1, you know rank 2") instead of only a count, and says
--- "1 button" instead of "1 buttons". Same Scan() as the orange edge and /mh ranks. nil when there is nothing.
local WHICH_MAX = 4

-- 14 Nov 2026: Rob could not find the one button (*"Maar ik weet toch niet zo gauw welke"*, and he did not see the
-- edge): the sentence also says WHERE, as Edit Mode names it. Bar n = n-th entry of BAR_PREFIXES_W (same order as
-- Edit Mode's Action Bar 1..8; BarInventory.lua FRAME_SETS has the same order with the binding commands).
-- "Action Bar %d" is Blizzard's own HUD_EDIT_MODE_ACTION_BAR_LABEL (GEMETEN in Forever GlobalStrings, build 70938).
local BAR_PREFIXES_W = { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton",
	"MultiBarLeftButton", "MultiBar5Button", "MultiBar6Button", "MultiBar7Button" }
local BAR_COMMANDS_W = { "ACTIONBUTTON", "MULTIACTIONBAR1BUTTON", "MULTIACTIONBAR2BUTTON", "MULTIACTIONBAR3BUTTON",
	"MULTIACTIONBAR4BUTTON", "MULTIACTIONBAR5BUTTON", "MULTIACTIONBAR6BUTTON", "MULTIACTIONBAR7BUTTON" }

--- Where a slot sits on Blizzard's bars: "Action Bar 4, button 3 (key X)". A visible button wins over a hidden one.
--- nil when no Blizzard button holds that slot (another bar addon, or a page that is not shown).
local function Where(slot)
	local hit
	for n, prefix in ipairs(BAR_PREFIXES_W) do
		for i = 1, 12 do
			local b = _G[prefix .. i]
			if b then
				local s = b.action
				if type(s) ~= "number" and ActionButton_GetPagedID then
					local ok, v = pcall(ActionButton_GetPagedID, b)
					s = ok and v or nil
				end
				if s == slot then
					local vis = b.IsVisible and b:IsVisible() or false
					if not hit or (vis and not hit.vis) then
						hit = { bar = n, btn = i, vis = vis }
					end
				end
			end
		end
	end
	if not hit then
		return nil
	end
	local label = (type(HUD_EDIT_MODE_ACTION_BAR_LABEL) == "string" and HUD_EDIT_MODE_ACTION_BAR_LABEL) or "Action Bar %d"
	local s = ns:L("FRANK_WHERE_FMT"):format(label:format(hit.bar), hit.btn)
	local key = GetBindingKey and GetBindingKey(BAR_COMMANDS_W[hit.bar] .. hit.btn)
	if key then
		local txt = (GetBindingText and GetBindingText(key, "KEY_")) or key
		s = s .. " " .. ns:L("FRANK_WHERE_KEY_FMT"):format(txt)
	end
	if not hit.vis then
		s = s .. " " .. ns:L("FRANK_WHERE_HIDDEN")
	end
	return s
end

function ns.ForeverRankSentence()
	local list = Scan()
	if #list == 0 then
		return nil
	end
	if #list == 1 then
		local r = list[1]
		local w = Where(r.slot)
		-- The 4th %s is the place sentence (with a leading space) or "", so it sits right after the first sentence.
		return ns:L("FRANK_HOME_ONE_FMT"):format(r.name, r.fromIdx, r.toIdx,
			w and (" " .. ns:L("FRANK_WHERE_SENT_FMT"):format(w)) or "")
	end
	-- One row per spell + rank + place (a button with no Blizzard place is named once per spell + rank).
	local rows, seen = {}, {}
	for _, r in ipairs(list) do
		local w = Where(r.slot)
		local k = r.name .. "#" .. r.fromIdx .. "#" .. (w or "")
		if not seen[k] then
			seen[k] = true
			local row = ns:L("FRANK_HOME_ROW_FMT"):format(r.name, r.fromIdx, r.toIdx)
			rows[#rows + 1] = w and (row .. ": " .. w) or row
		end
	end
	local shown = {}
	for i = 1, math.min(#rows, WHICH_MAX) do
		shown[i] = rows[i]
	end
	-- "; " between rows: a row with a place already holds a comma ("Action Bar 4, button 3").
	local which = table.concat(shown, "; ")
	if #rows > WHICH_MAX then
		which = which .. "; " .. ns:L("FRANK_HOME_MORE_FMT"):format(#rows - WHICH_MAX)
	end
	return ns:L("FRANK_HOME_FMT"):format(#list) .. " " .. ns:L("FRANK_HOME_WHICH_FMT"):format(which)
end

function ns.ForeverRankFixAll()
	Fix(true)
end

-- After a learn: remember the new tops, then offer (or, with auto on, do) the upgrade of "just trained" buttons.
local pending = false
local said = {}
local function AfterLearn()
	pending = false
	if InCombatLockdown and InCombatLockdown() then
		pending = true -- PLAYER_REGEN_ENABLED picks it up
		return
	end
	UpdateTops()
	local list = FreshOnly(Scan())
	if #list > 0 then
		if Settings().auto then
			Report(Replace(list))
			for _, r in ipairs(list) do
				fresh[r.name] = nil
			end
		else
			-- One chat line per spell and rank, not on every SPELLS_CHANGED.
			local key = {}
			for _, r in ipairs(list) do
				key[#key + 1] = r.name .. r.toIdx
			end
			key = table.concat(key, ",")
			if not said[key] then
				said[key] = true
				print(PREFIX .. ns:L("FRANK_OFFER_FMT"):format(#list))
			end
		end
	end
	Refresh()
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED", "PLAYER_ENTERING_WORLD", "TRAINER_SHOW", "TRAINER_CLOSED",
	"ACTIONBAR_SLOT_CHANGED" }) do
	pcall(ev.RegisterEvent, ev, e) -- Forever may not know every event (LEARNED_SPELL_IN_TAB throws there)
end
local timer
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		ev:UnregisterEvent("PLAYER_ENTERING_WORLD")
		C_Timer.After(2, UpdateTops) -- the baseline: nothing counts as "just trained" from before this login
		return
	end
	if event == "PLAYER_REGEN_ENABLED" then
		if pending then
			AfterLearn()
		end
		return
	end
	if event == "TRAINER_SHOW" then
		C_Timer.After(0.1, Refresh)
		return
	end
	if event == "TRAINER_CLOSED" then
		if btn then
			btn:Hide()
		end
		return
	end
	if event == "ACTIONBAR_SLOT_CHANGED" then
		if btn and btn:IsShown() then
			Refresh()
		end
		return
	end
	-- SPELLS_CHANGED comes in bursts while you train: wait for the burst to end.
	if timer then
		timer:Cancel()
	end
	timer = C_Timer.NewTimer(1, AfterLearn)
end)

--------------------------------------------------------------------------------
-- The edge on the button (IDEEEN O24 + O25). Rob, 12 Nov 2026, via sparring, his choices verbatim:
--   "Eigen rustige rand (Recommended)" — our own calm orange edge with a small arrow up, not the game's proc glow
--     (a proc glow means "press me now"; this means "this button is out of date");
--   "Aan (Recommended)" — on by default, a switch turns it off (settings, /mh ranks glow on|off);
--   "Elke lagere rank (Recommended)" — every lower rank; a just-trained one is strong, a lower rank you placed
--     yourself (downranking) is soft.
-- Build-yes, verbatim: "ja bouw oude reank". Measured by Rob in Forever first (/run, 12 Nov): "1 61 table nil" =
-- ActionButton1.action is 1 and MultiBarBottomLeftButton1.action is 61, so Blizzard's buttons know their slot.
-- Only Blizzard's own bars (Rob has no bar addon in Forever, measured in his AddOns folder). Another bar addon's
-- buttons simply get nothing.
-- O25: silent while Glowing Bars is loaded (two addons saying the same thing). Its folder name is NOT measured (it is
-- not installed on Rob's machine, measured 12 Nov), so we match name OR title, without spaces and colours, on
-- "glowingbars": a different folder name with the same title is still found, and a wrong guess finds nothing.
-- /mh ranks says it is silent and why; /mh ranks glow on draws anyway.
--------------------------------------------------------------------------------
local BAR_PREFIXES = { "ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarRightButton",
	"MultiBarLeftButton", "MultiBar5Button", "MultiBar6Button", "MultiBar7Button" }
local ORANGE = { 1, 0.55, 0.1 }

local function GlowSetting()
	-- nil = on (Rob's choice B1); false = off
	return Settings().glow ~= false
end

local function OtherGlowAddon()
	local n = (C_AddOns and C_AddOns.GetNumAddOns and C_AddOns.GetNumAddOns()) or (GetNumAddOns and GetNumAddOns()) or 0
	for i = 1, n do
		local name, title
		if C_AddOns and C_AddOns.GetAddOnInfo then
			name, title = C_AddOns.GetAddOnInfo(i)
		elseif GetAddOnInfo then
			name, title = GetAddOnInfo(i)
		end
		local function norm(s)
			return type(s) == "string" and s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("[%s%-_]", ""):lower() or ""
		end
		if norm(name):find("glowingbars", 1, true) or norm(title):find("glowingbars", 1, true) then
			local loaded = (C_AddOns and C_AddOns.IsAddOnLoaded and C_AddOns.IsAddOnLoaded(i))
				or (IsAddOnLoaded and IsAddOnLoaded(i))
			if loaded then
				return name
			end
		end
	end
	return nil
end

local edges = {} -- button -> overlay frame
local glowWhy, glowCount = "not drawn yet", 0
local edgeSeen = {} -- "ButtonName (alpha 0.xx)" per drawn edge, for /mh ranks

local function Edge(button)
	local e = edges[button]
	if e then
		return e
	end
	e = CreateFrame("Frame", nil, button)
	e:SetAllPoints(button)
	e:SetFrameLevel(button:GetFrameLevel() + 5)
	e.lines = {}
	for i, pts in ipairs({ { "TOPLEFT", "TOPRIGHT" }, { "BOTTOMLEFT", "BOTTOMRIGHT" }, { "TOPLEFT", "BOTTOMLEFT" },
		{ "TOPRIGHT", "BOTTOMRIGHT" } }) do
		local t = e:CreateTexture(nil, "OVERLAY")
		t:SetColorTexture(ORANGE[1], ORANGE[2], ORANGE[3], 1)
		t:SetPoint(pts[1], e, pts[1])
		t:SetPoint(pts[2], e, pts[2])
		t.horizontal = (i <= 2)
		e.lines[i] = t
	end
	e.arrow = e:CreateTexture(nil, "OVERLAY")
	e.arrow:SetTexture("Interface\\Buttons\\Arrow-Up-Up")
	e.arrow:SetSize(14, 14)
	e.arrow:SetPoint("TOPRIGHT", e, "TOPRIGHT", 3, 3)
	e.arrow:SetVertexColor(ORANGE[1], ORANGE[2], ORANGE[3])
	e:Hide()
	edges[button] = e
	return e
end

local function Style(e, strong)
	local w = strong and 2 or 1
	for _, t in ipairs(e.lines) do
		if t.horizontal then
			t:SetHeight(w)
		else
			t:SetWidth(w)
		end
		t:SetAlpha(strong and 1 or 0.55)
	end
	e.arrow:SetAlpha(strong and 1 or 0.55)
end

local function UpdateGlows()
	glowCount = 0
	edgeSeen = {}
	local other = OtherGlowAddon()
	local on = GlowSetting() and (not other or Settings().glowWithOther)
	local bySlot = {}
	if on then
		for _, r in ipairs(Scan()) do
			bySlot[r.slot] = r
		end
	end
	for _, prefix in ipairs(BAR_PREFIXES) do
		for i = 1, 12 do
			local b = _G[prefix .. i]
			if b then
				local slot = b.action
				if type(slot) ~= "number" and ActionButton_GetPagedID then
					local ok, v = pcall(ActionButton_GetPagedID, b)
					slot = ok and v or nil
				end
				local r = type(slot) == "number" and bySlot[slot]
				if r and b.IsVisible and b:IsVisible() then
					local e = Edge(b)
					-- 14 Nov 2026 (Rob via sparring, letterlijk: "Ja, je moet die rand duidelijker maken, dus ik volg
					-- jouw advies"): every lower rank gets the strong edge. The soft one (1 px, alpha 0.55) was not
					-- seen by Rob on his shaman (slot 27, key C) while /mh ranks said it was drawn.
					Style(e, true)
					e:Show()
					glowCount = glowCount + 1
					-- What the player can actually see of it: a bar that fades (alpha) keeps IsVisible() true.
					local okA, a = pcall(b.GetEffectiveAlpha, b)
					edgeSeen[#edgeSeen + 1] = ("%s (alpha %s)"):format(b:GetName() or "?",
						okA and type(a) == "number" and ("%.2f"):format(a) or "?")
				elseif edges[b] then
					edges[b]:Hide()
				end
			end
		end
	end
	if not GlowSetting() then
		glowWhy = "off (/mh ranks glow on, or Options)"
	elseif other and not Settings().glowWithOther then
		glowWhy = ("silent: %s is loaded and shows the same (/mh ranks glow on draws anyway)"):format(other)
	else
		glowWhy = ("on: %d button(s) with an edge out of %d lower rank(s) on your bars"):format(glowCount, #(Scan()))
		if #edgeSeen > 0 then
			glowWhy = glowWhy .. " - drawn on " .. table.concat(edgeSeen, ", ")
		end
	end
end

local glowTimer
local function UpdateGlowsSoon()
	if glowTimer then
		glowTimer:Cancel()
	end
	glowTimer = C_Timer.NewTimer(0.3, function()
		glowTimer = nil
		pcall(UpdateGlows)
	end)
end

local gev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "SPELLS_CHANGED", "ACTIONBAR_SLOT_CHANGED", "ACTIONBAR_PAGE_CHANGED",
	"UPDATE_BONUS_ACTIONBAR", "PLAYER_REGEN_ENABLED" }) do
	pcall(gev.RegisterEvent, gev, e)
end
gev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(3, UpdateGlowsSoon) -- after UpdateTops' baseline (2 s), so "just trained" is known
		return
	end
	if event == "SPELLS_CHANGED" then
		C_Timer.After(1.5, UpdateGlowsSoon) -- after AfterLearn (1 s after the burst) has marked "just trained"
		return
	end
	UpdateGlowsSoon()
end)

function ns.IsForeverRankGlowOn()
	return GlowSetting()
end

function ns.SetForeverRankGlow(on)
	-- (not "(not on) and false or nil": that is always nil in Lua; measured offline 12 Nov, "glow off" stayed on)
	if on then
		Settings().glow = nil
	else
		Settings().glow = false
	end
	UpdateGlowsSoon()
end

--- /mh ranks [fix | auto on | auto off | glow on | glow off]
function ns.ForeverRanksSlash(arg)
	arg = (arg or ""):lower()
	if arg == "glow on" or arg == "glow off" then
		local on = (arg == "glow on")
		ns.SetForeverRankGlow(on)
		-- "on" also means: draw even when Glowing Bars is loaded (the player asked for it).
		Settings().glowWithOther = on and OtherGlowAddon() and true or nil
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverRankGlow", on)
		end
		print(PREFIX .. ns:L(on and "FRANK_GLOW_ON" or "FRANK_GLOW_OFF"))
		return
	end
	if arg == "fix" then
		Fix(true)
		return
	end
	if arg == "auto on" or arg == "auto off" then
		Settings().auto = (arg == "auto on") or nil
		print(PREFIX .. ns:L(arg == "auto on" and "FRANK_AUTO_ON" or "FRANK_AUTO_OFF"))
		return
	end
	local list, spells, ranked = Scan()
	print(PREFIX .. ("ranks: %d spell buttons, %d with a spell MH knows the ranks of, %d with a lower rank than you know. Auto: %s."):format(
		spells, ranked, #list, Settings().auto and "on" or "off (/mh ranks auto on)"))
	for _, r in ipairs(list) do
		local hi = ""
		if C_ActionBar and C_ActionBar.IsHighestSpellRank then
			local ok, v = pcall(C_ActionBar.IsHighestSpellRank, r.from)
			hi = ok and (" | game says highest: " .. tostring(v)) or ""
		end
		print(("   slot %d: %s rank %d (%d) -> rank %d (%d)%s%s"):format(r.slot, r.name, r.fromIdx, r.from, r.toIdx, r.to,
			r.fresh and " | just trained" or "", hi) .. " | " .. (Where(r.slot) or "no Blizzard button holds this slot"))
	end
	pcall(UpdateGlows)
	print("   edge on the button: " .. glowWhy)
	if spells > 0 and ranked == 0 then
		print("   none of your spell buttons is in MH's rank list: on a non-English client the list still matches by id.")
	end
	if #list > 0 then
		print("   /mh ranks fix upgrades all of them (also a lower rank you use on purpose).")
	end
end
