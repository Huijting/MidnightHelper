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

-- 21 Nov 2026 (Rob: "A"): the player GUID through ForeverCharKey.lua (the realm is "" since Blizzard's 20 Nov hotfix).
local function CharKey(label, tbl)
	local name, realm = UnitFullName and UnitFullName("player")
	local legacy = (name or "?") .. "-" .. (realm or (GetRealmName and GetRealmName()) or "?")
	return ns.ForeverCharKey and ns.ForeverCharKey(label, legacy, tbl) or legacy
end

local function CharTops()
	local s = Settings()
	local k = CharKey("ranks (foreverRanks.top)", s.top)
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

--------------------------------------------------------------------------------
-- Player's choice per bar and per button (18 Nov 2026). A player in the in-game survey (Druid 20-39, FI, 18 Nov),
-- verbatim: "at Shaman we got rank 1 earth shock in different action bar and many ranks healing spells as all healers
-- got, I would like to choose which action bar spells I want to upgrade." Rob via sparring: "werk dat maar vast uit".
-- Per character: except.bars[n] = true ("never touch bar n"), except.buttons["slot:spell name"] = true ("never touch
-- this button"; the name, not the rank id, so the choice survives the next rank). Every path respects it: the edge,
-- the count and sentence, the trainer button, /mh ranks fix and auto.
--------------------------------------------------------------------------------
local function Except()
	local s = Settings()
	s.except = s.except or {}
	local k = CharKey("ranks choices (foreverRanks.except)", s.except)
	s.except[k] = s.except[k] or {}
	local e = s.except[k]
	e.bars = e.bars or {}
	e.buttons = e.buttons or {}
	return e
end

-- Blizzard's slot ranges per Edit Mode bar (bar 1 also holds its pages and the stance/bonus bars). AFGELEID from the
-- standard action slot layout; a visible Blizzard button that holds the slot wins (BarOf below).
local SLOT_BAR = { { 1, 24, 1 }, { 73, 144, 1 }, { 61, 72, 2 }, { 49, 60, 3 }, { 25, 36, 4 }, { 37, 48, 5 },
	{ 145, 156, 6 }, { 157, 168, 7 }, { 169, 180, 8 } }

local WhereHit -- forward (the Blizzard button that holds a slot), defined further down, beside the place sentence

local function BarOf(slot)
	local hit = WhereHit and WhereHit(slot)
	if hit then
		return hit.bar, hit.btn
	end
	for _, r in ipairs(SLOT_BAR) do
		if slot >= r[1] and slot <= r[2] then
			return r[3], nil
		end
	end
	return nil
end

local function ButtonKey(slot, name)
	return tostring(slot) .. ":" .. tostring(name)
end

--- Why a button is left alone: "bar", "button" or nil.
local function Skipped(slot, name)
	local e = Except()
	local bar = BarOf(slot)
	if bar and e.bars[bar] then
		return "bar"
	end
	if e.buttons[ButtonKey(slot, name)] then
		return "button"
	end
	return nil
end

--- Every spell button holding a lower rank than you know: { slot, from, to, name, fromIdx, toIdx, fresh, bar, skip }.
--- The ones the player excluded are left out unless `withSkipped` (the choice window and /mh ranks show them).
local function Scan(withSkipped)
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
					local skip = Skipped(slot, i.name)
					if withSkipped or not skip then
						out[#out + 1] = { slot = slot, from = id, to = topId, name = i.name, fromIdx = i.idx, toIdx = topIdx,
							fresh = fresh[i.name] == i.idx, bar = BarOf(slot), skip = skip }
					end
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

-- Slots MH itself just changed (slot -> GetTime()), so the measurement for "placed by hand" (/mh ranks watch, 19 Nov
-- 2026) can tell our own PlaceAction from the player's.
local ours = {}
local function MarkOurs(slot)
	ours[slot] = GetTime and GetTime() or 0
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
		MarkOurs(r.slot)
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
		-- 18 Nov 2026: Shift-click opens the choice window (which buttons, which bars); a plain click upgrades the
		-- just-trained buttons, without the ones you excluded (Scan leaves those out).
		btn:SetScript("OnClick", function()
			if IsShiftKeyDown and IsShiftKeyDown() then
				ns.ShowForeverRanks()
			else
				Fix(false)
			end
		end)
		btn:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(ns:L("FRANK_BTN_TIP_TITLE"), 1, 0.82, 0)
			for _, r in ipairs(FreshOnly(Scan())) do
				GameTooltip:AddLine(ns:L("FRANK_TIP_ROW_FMT"):format(r.name, r.fromIdx, r.toIdx), 1, 1, 1)
			end
			GameTooltip:AddLine(ns:L("FRANK_BTN_TIP_BODY"), 0.75, 0.75, 0.75, true)
			GameTooltip:AddLine(ns:L("FRANK_BTN_TIP_CHOOSE"), 0.6, 0.85, 1, true)
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

--- The Blizzard button that holds a slot: { bar, btn, vis } (a visible one wins), or nil.
WhereHit = function(slot)
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
	return hit
end

--- Where a slot sits on Blizzard's bars: "Action Bar 4, button 3 (key X)". A visible button wins over a hidden one.
--- nil when no Blizzard button holds that slot (another bar addon, or a page that is not shown).
local function Where(slot)
	local hit = WhereHit(slot)
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
local ShowLearnList -- forward: the small "just learned" list (19 Nov 2026), defined after the choice window
local function AfterLearn()
	pending = false
	if InCombatLockdown and InCombatLockdown() then
		pending = true -- PLAYER_REGEN_ENABLED picks it up
		return
	end
	UpdateTops()
	local list = FreshOnly(Scan())
	if #list > 0 and Settings().auto then
		Report(Replace(list))
		for _, r in ipairs(list) do
			fresh[r.name] = nil
		end
	end
	-- The learn list asks per spell (it replaces the chat line below while it shows).
	local listed = ShowLearnList and ShowLearnList()
	if #list > 0 and not listed then
		if Settings().auto then
			-- done above
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

--------------------------------------------------------------------------------
-- The choice window (18 Nov 2026, the survey player's wish, see Except() above): every button with a lower rank,
-- per bar; a tick "upgrade" per button, "never touch this bar", "never touch this button", one "Upgrade checked".
-- Style A (ForeverStyle SkinOnShow), Escape + Shift+scroll via RegisterMidnightDialogPopup.
--------------------------------------------------------------------------------
local RW, RH, ROW_H = 560, 440, 26
local rwin
local unchecked = {} -- slot → true: the player took the tick off this session

local function BarLabel(n)
	local label = (type(HUD_EDIT_MODE_ACTION_BAR_LABEL) == "string" and HUD_EDIT_MODE_ACTION_BAR_LABEL) or "Action Bar %d"
	return n and label:format(n) or ns:L("FRANK_WIN_NOBAR")
end

local FillRanks -- forward

local function Check(parent)
	local c = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	c:SetSize(22, 22)
	return c
end

local function RankRow(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f.child)
	r:SetSize(RW - 70, ROW_H)
	r.check = Check(r)
	r.check:SetPoint("LEFT", 0, 0)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.text:SetPoint("LEFT", r.check, "RIGHT", 4, 0)
	r.text:SetPoint("RIGHT", r, "RIGHT", -150, 0)
	r.text:SetJustifyH("LEFT")
	r.text:SetWordWrap(false)
	r.never = Check(r)
	r.never:SetPoint("RIGHT", r, "RIGHT", -120, 0)
	r.neverText = r:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	r.neverText:SetPoint("LEFT", r.never, "RIGHT", 2, 0)
	f.rows[i] = r
	return r
end

FillRanks = function()
	local f = rwin
	if not (f and f:IsShown()) then
		return
	end
	local list = Scan(true)
	table.sort(list, function(a, b)
		if (a.bar or 99) ~= (b.bar or 99) then
			return (a.bar or 99) < (b.bar or 99)
		end
		return a.slot < b.slot
	end)
	local e = Except()
	-- The bars that have a row, plus the bars you excluded (so you can let them go again).
	local bars, seenBar = {}, {}
	for _, r in ipairs(list) do
		if r.bar and not seenBar[r.bar] then
			seenBar[r.bar] = true
			bars[#bars + 1] = r.bar
		end
	end
	for n in pairs(e.bars) do
		if not seenBar[n] then
			seenBar[n] = true
			bars[#bars + 1] = n
		end
	end
	table.sort(bars)
	local lines = {}
	for _, n in ipairs(bars) do
		lines[#lines + 1] = { bar = n }
		for _, r in ipairs(list) do
			if r.bar == n then
				lines[#lines + 1] = { row = r }
			end
		end
	end
	for _, r in ipairs(list) do
		if not r.bar then
			lines[#lines + 1] = { row = r }
		end
	end
	local y = 0
	for i, ln in ipairs(lines) do
		local row = RankRow(f, i)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -y)
		if ln.bar then
			local n = ln.bar
			row.check:Hide()
			row.text:SetFontObject("GameFontNormal")
			row.text:SetText(BarLabel(n))
			row.never:Show()
			row.never:SetChecked(e.bars[n] == true)
			row.neverText:SetText(ns:L("FRANK_WIN_NEVER_BAR"))
			row.never:SetScript("OnClick", function(self)
				e.bars[n] = self:GetChecked() and true or nil
				FillRanks()
				if Refresh then Refresh() end
				UpdateGlowsSoon()
			end)
		else
			local r = ln.row
			local key = ButtonKey(r.slot, r.name)
			row.check:Show()
			row.check:SetEnabled(r.skip == nil)
			row.check:SetChecked(r.skip == nil and not unchecked[r.slot])
			row.check:SetScript("OnClick", function(self)
				unchecked[r.slot] = (not self:GetChecked()) or nil
				FillRanks()
			end)
			row.text:SetFontObject(r.skip and "GameFontDisable" or "GameFontHighlight")
			local w = r.bar and select(2, BarOf(r.slot))
			row.text:SetText(ns:L("FRANK_WIN_ROW_FMT"):format(w and ns:L("FRANK_WIN_BTN_FMT"):format(w) or ("#" .. r.slot),
				r.name, r.fromIdx, r.toIdx) .. (r.fresh and ("  |cff66ff66" .. ns:L("FRANK_WIN_FRESH") .. "|r") or ""))
			row.never:SetShown(r.skip ~= "bar")
			row.never:SetChecked(e.buttons[key] == true)
			row.neverText:SetText(r.skip == "bar" and ns:L("FRANK_WIN_BAR_SKIPPED") or ns:L("FRANK_WIN_NEVER_BTN"))
			row.never:SetScript("OnClick", function(self)
				e.buttons[key] = self:GetChecked() and true or nil
				FillRanks()
				if Refresh then Refresh() end
				UpdateGlowsSoon()
			end)
		end
		row:Show()
		y = y + ROW_H
	end
	for i = #lines + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, y))
	local n = 0
	for _, r in ipairs(list) do
		if not r.skip and not unchecked[r.slot] then
			n = n + 1
		end
	end
	f.empty:SetShown(#list == 0)
	f.go:SetText(ns:L("FRANK_WIN_GO_FMT"):format(n))
	f.go:SetEnabled(n > 0)
end

local function UpgradeChecked()
	local todo = {}
	for _, r in ipairs(Scan()) do
		if not unchecked[r.slot] then
			todo[#todo + 1] = r
		end
	end
	if #todo == 0 then
		print(PREFIX .. ns:L("FRANK_NONE"))
		return
	end
	local done, failed, reason = Replace(todo)
	Report(done, failed, reason)
	if done > 0 then
		for _, r in ipairs(todo) do
			fresh[r.name] = nil
		end
	end
	FillRanks()
	Refresh()
	UpdateGlowsSoon()
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
end

local function BuildRanks()
	if rwin then
		return rwin
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverRanks", UIParent, "BackdropTemplate")
	f:SetSize(RW, RH)
	f:SetPoint("CENTER", 0, 40)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 20, -16)
	f.title:SetText(ns:L("FRANK_WIN_TITLE"))
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -6)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.sub:SetJustifyH("LEFT")
	f.sub:SetText(ns:L("FRANK_WIN_SUB"))
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 18, -70)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 50)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(RW - 60, 10)
	scroll:SetScrollChild(child)
	f.child, f.rows = child, {}
	f.empty = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	f.empty:SetPoint("TOPLEFT", 22, -80)
	f.empty:SetText(ns:L("FRANK_NONE"))
	f.go = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.go:SetSize(200, 24)
	f.go:SetPoint("BOTTOMRIGHT", -20, 16)
	f.go:SetScript("OnClick", UpgradeChecked)
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 20, 22)
	f.hint:SetPoint("RIGHT", f.go, "LEFT", -10, 0)
	f.hint:SetJustifyH("LEFT")
	f.hint:SetText(ns:L("FRANK_WIN_HINT"))
	f:SetScript("OnShow", function()
		FillRanks()
	end)
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	rwin = f
	return f
end

--- Open (or close) the choice window.
function ns.ShowForeverRanks()
	local f = BuildRanks()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
		FillRanks()
	end
end

--------------------------------------------------------------------------------
-- The "just learned" list (19 Nov 2026). Rob via sparring, letterlijk: "Ik denk dat hij bedoelde allebei ... En
-- inderdaad, jouw overzicht ziet er goed uit, volg het maar en doe het maar." The survey player's wish (18 Nov): "I
-- would like to choose which action bar spells I want to upgrade." After the trainer a small list asks, per spell:
--   a new RANK of a spell on your bars  → "Upgrade" (those buttons) / "Not now" / "Never" (never touch those buttons)
--   a NEW spell on no bar              → "On my bar" (a free visible Blizzard button) / "Not now" / "Never"
-- Only what was trained this session, only out of combat (hidden in a fight, back after it), once per spell and rank.
-- A switch in Quiet helpers (players choose; on by default): Settings().listOff == true = off. Style A, Escape and
-- Shift+scroll via RegisterMidnightDialogPopup. With "auto" on, ranks are already done: the list has only new spells.
--------------------------------------------------------------------------------
local LW, LROW = 380, 26
local lwin
local asked = {} -- "r:<name>:<toIdx>" / "n:<id>" -> true: shown once this session
local later = {} -- the same keys: "Not now" this session
local sessionNew = {} -- spell id -> true: learned at a trainer this session (LEARNED_SPELL_IN_SKILL_LINE)
local listWhy = "nothing learned yet this session"

function ns.IsForeverLearnListOn()
	return Settings().listOff ~= true
end

function ns.SetForeverLearnList(on)
	-- Not `(not on) and true or nil`-style tricks: plain branches (lint [29]).
	if on then
		Settings().listOff = nil
	else
		Settings().listOff = true
		if lwin then
			lwin:Hide()
		end
	end
end

--- A free, visible button on Blizzard's bars: its action slot, or nil.
local function FreeSlot()
	if not HasAction then
		return nil
	end
	for _, prefix in ipairs(BAR_PREFIXES_W) do
		for i = 1, 12 do
			local b = _G[prefix .. i]
			if b and b.IsVisible and b:IsVisible() then
				local s = b.action
				if type(s) ~= "number" and ActionButton_GetPagedID then
					local ok, v = pcall(ActionButton_GetPagedID, b)
					s = ok and v or nil
				end
				if type(s) == "number" and s > 0 then
					local ok, has = pcall(HasAction, s)
					if ok and not has then
						return s
					end
				end
			end
		end
	end
	return nil
end

--- The rows: rank rows grouped per spell (all its "just trained" buttons), then new spells on no bar.
local function LearnRows()
	local rows = {}
	local by = {}
	for _, r in ipairs(FreshOnly(Scan())) do
		local k = "r:" .. r.name .. ":" .. r.toIdx
		if not later[k] then
			local g = by[k]
			if not g then
				g = { kind = "rank", key = k, name = r.name, fromIdx = r.fromIdx, toIdx = r.toIdx, list = {} }
				by[k] = g
				rows[#rows + 1] = g
			end
			g.list[#g.list + 1] = r
		end
	end
	for _, s in ipairs(ns.ForeverNoBarList and ns.ForeverNoBarList() or {}) do
		local k = "n:" .. s.id
		if sessionNew[s.id] and not later[k] then
			rows[#rows + 1] = { kind = "new", key = k, id = s.id, name = s.name }
		end
	end
	return rows
end

local FillLearn -- forward

local function LearnButton(parent, w)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(w, 20)
	return b
end

local function LearnRow(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f)
	r:SetSize(LW - 24, LROW)
	r.never = LearnButton(r, 58)
	r.never:SetPoint("RIGHT", 0, 0)
	r.later = LearnButton(r, 66)
	r.later:SetPoint("RIGHT", r.never, "LEFT", -3, 0)
	r.yes = LearnButton(r, 78)
	r.yes:SetPoint("RIGHT", r.later, "LEFT", -3, 0)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.text:SetPoint("LEFT", 0, 0)
	r.text:SetPoint("RIGHT", r.yes, "LEFT", -6, 0)
	r.text:SetJustifyH("LEFT")
	r.text:SetWordWrap(true)
	-- The spell's own tooltip on the name (19 Nov 2026 tooltips wish).
	r.hot = CreateFrame("Frame", nil, r)
	r.hot:SetAllPoints(r.text)
	r.hot:EnableMouse(true)
	r.hot:SetScript("OnEnter", function(self)
		if self.spell and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if pcall(GameTooltip.SetSpellByID, GameTooltip, self.spell) then
				GameTooltip:Show()
			end
		end
	end)
	r.hot:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	f.rows[i] = r
	return r
end

local function BuildLearn()
	if lwin then
		return lwin
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverLearnList", UIParent, "BackdropTemplate")
	f:SetSize(LW, 100)
	f:SetPoint("CENTER", 260, 120)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", 12, -10)
	f.title:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	f.rows = {}
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 12, 8)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	f.hint:SetJustifyH("LEFT")
	if ns.ForeverStyle and ns.ForeverStyle.SkinOnShow then
		ns.ForeverStyle.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	f:Hide()
	lwin = f
	return f
end

local function AfterChange()
	if Refresh then
		Refresh()
	end
	UpdateGlowsSoon()
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
	if ns.ForeverDoNowUpdate then
		pcall(ns.ForeverDoNowUpdate)
	end
end

FillLearn = function()
	local f = lwin
	if not (f and f:IsShown()) then
		return 0
	end
	local rows = LearnRows()
	f.title:SetText(ns:L("FRANK_LIST_TITLE"))
	f.hint:SetText(ns:L("FRANK_LIST_HINT"))
	local y = 32
	for i, row in ipairs(rows) do
		local r = LearnRow(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -y)
		r.hot.spell = (row.kind == "rank" and row.list[1] and row.list[1].to) or row.id
		r.later:SetText(ns:L("FRANK_LIST_LATER"))
		r.never:SetText(ns:L("FRANK_LIST_NEVER"))
		if row.kind == "rank" then
			r.text:SetText(ns:L("FRANK_LIST_RANK_FMT"):format(row.name, row.fromIdx, row.toIdx, #row.list))
			r.yes:SetText(ns:L("FRANK_LIST_UPGRADE"))
			r.yes:SetScript("OnClick", function()
				local done, failed, reason = Replace(row.list)
				Report(done, failed, reason)
				if done > 0 then
					fresh[row.name] = nil
				end
				FillLearn()
				AfterChange()
			end)
			r.never:SetScript("OnClick", function()
				local e = Except()
				for _, x in ipairs(row.list) do
					e.buttons[ButtonKey(x.slot, x.name)] = true
				end
				FillLearn()
				AfterChange()
			end)
		else
			r.text:SetText(ns:L("FRANK_LIST_NEW_FMT"):format(row.name))
			r.yes:SetText(ns:L("FRANK_LIST_ONBAR"))
			r.yes:SetScript("OnClick", function()
				if (InCombatLockdown and InCombatLockdown()) then
					print(PREFIX .. ns:L("FRANK_COMBAT"))
					return
				end
				if not CursorEmpty() then
					print(PREFIX .. ns:L("FRANK_CURSOR"))
					return
				end
				local slot = FreeSlot()
				if not slot then
					print(PREFIX .. ns:L("FRANK_LIST_NOSLOT"))
					return
				end
				MarkOurs(slot)
				pcall(function()
					ClearCursor()
					if C_Spell and C_Spell.PickupSpell then
						C_Spell.PickupSpell(row.id)
					else
						PickupSpell(row.id)
					end
					PlaceAction(slot)
					ClearCursor()
				end)
				pcall(ClearCursor)
				if ns.ForeverNoBarForget then
					ns.ForeverNoBarForget(row.id)
				end
				FillLearn()
				AfterChange()
			end)
			r.never:SetScript("OnClick", function()
				if ns.ForeverNoBarForget then
					ns.ForeverNoBarForget(row.id, true)
				end
				FillLearn()
				AfterChange()
			end)
		end
		r.later:SetScript("OnClick", function()
			later[row.key] = true
			FillLearn()
		end)
		-- Each button as wide as its own text in this language (lint [28]'s lesson: no text wider than its box).
		for _, b in ipairs({ r.yes, r.later, r.never }) do
			local fs = b:GetFontString()
			b:SetWidth(math.max(50, math.ceil(((fs and fs:GetStringWidth()) or 40) + 18)))
		end
		local h = math.max(LROW, (r.text:GetStringHeight() or 12) + 8)
		r:SetHeight(h)
		r:Show()
		y = y + h + 2
	end
	for i = #rows + 1, #f.rows do
		f.rows[i]:Hide()
	end
	if #rows == 0 then
		f:Hide()
		return 0
	end
	f:SetHeight(y + 8 + (f.hint:GetStringHeight() or 12) + 10)
	return #rows
end

-- One window after the other (Rob, 19 Nov 2026, via sparring: "Ja, ik volg jullie advies"): while the key block's
-- "New for your key block" question (StaticPopup MH_KEYBLOCK_NEW, KeyBlock.lua) is on screen, this list waits, and it
-- comes once that question is closed. If the question appears while the list is open, the list steps aside and returns.
local function BlockAsking()
	return StaticPopup_Visible and StaticPopup_Visible("MH_KEYBLOCK_NEW") and true or false
end
local waitTicker -- C_Timer ticker while we wait for the key block question
local reshow = false -- the list was open and stepped aside: show it again as it was

local function WaitForBlock()
	if waitTicker or not (C_Timer and C_Timer.NewTicker) then
		return
	end
	waitTicker = C_Timer.NewTicker(1, function()
		if BlockAsking() then
			return
		end
		waitTicker:Cancel()
		waitTicker = nil
		if reshow then
			reshow = false
			if lwin and not (InCombatLockdown and InCombatLockdown()) then
				lwin:Show()
				FillLearn()
				listWhy = "back after the key block question"
			end
		else
			ShowLearnList()
		end
	end)
end

if hooksecurefunc and StaticPopup_Show then
	hooksecurefunc("StaticPopup_Show", function(which)
		if which == "MH_KEYBLOCK_NEW" and lwin and lwin:IsShown() then
			lwin:Hide()
			reshow = true
			listWhy = "stepped aside for the key block question"
			WaitForBlock()
		end
	end)
end

--- Show the list when there is something new to ask about. Returns true when it shows.
ShowLearnList = function()
	if not ns.IsForeverLearnListOn() then
		listWhy = "switched off (Quiet helpers)"
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		listWhy = "in combat (comes after the fight)"
		return false
	end
	if BlockAsking() then
		listWhy = "waits for the key block question (comes after it)"
		WaitForBlock()
		return false
	end
	local rows = LearnRows()
	local new = false
	for _, row in ipairs(rows) do
		if not asked[row.key] then
			new = true
		end
	end
	if #rows == 0 then
		listWhy = "nothing new to ask about"
		if lwin then
			lwin:Hide()
		end
		return false
	end
	if not new and not (lwin and lwin:IsShown()) then
		listWhy = "already asked this session (Not now / closed)"
		return false
	end
	for _, row in ipairs(rows) do
		asked[row.key] = true
	end
	local f = BuildLearn()
	f:Show()
	local n = FillLearn()
	listWhy = ("shown with %d row(s)"):format(n or 0)
	return (n or 0) > 0
end

-- Learned at a trainer this session; hidden in a fight, back after it.
local lev = CreateFrame("Frame")
pcall(lev.RegisterEvent, lev, "LEARNED_SPELL_IN_SKILL_LINE")
pcall(lev.RegisterEvent, lev, "PLAYER_REGEN_DISABLED")
pcall(lev.RegisterEvent, lev, "PLAYER_REGEN_ENABLED")
local hiddenForFight = false
lev:SetScript("OnEvent", function(_, event, spellID)
	if event == "LEARNED_SPELL_IN_SKILL_LINE" then
		if type(spellID) == "number" and not (issecretvalue and issecretvalue(spellID)) then
			sessionNew[spellID] = true
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		if lwin and lwin:IsShown() then
			hiddenForFight = true
			lwin:Hide()
		end
	elseif event == "PLAYER_REGEN_ENABLED" and hiddenForFight then
		hiddenForFight = false
		if lwin then
			lwin:Show()
			FillLearn()
		end
	end
end)

--------------------------------------------------------------------------------
-- Measurement for "placed by hand" (Rob's assumption B, 19 Nov 2026: a button the player sets to a lower rank himself
-- should not be upgraded again by itself). NOT built as a rule yet: how to tell the player's own drag from an addon's
-- PlaceAction in Forever is not measured. /mh ranks watch logs, for 2 minutes, every changed slot with what it holds,
-- whether MH placed it, and how long ago the cursor got a spell (an addon picks up and places in the same frame; a hand
-- drag takes longer — AFGELEID, this log is meant to measure exactly that).
--------------------------------------------------------------------------------
local watchUntil = 0
local lastCursor -- { t, kind, a, b, c }
local wev = CreateFrame("Frame")
pcall(wev.RegisterEvent, wev, "CURSOR_CHANGED")
pcall(wev.RegisterEvent, wev, "ACTIONBAR_SLOT_CHANGED")
wev:SetScript("OnEvent", function(_, event, slot)
	local now = GetTime and GetTime() or 0
	if now > watchUntil then
		return
	end
	if event == "CURSOR_CHANGED" then
		local kind, a, b, c = GetCursorInfo()
		if kind then
			lastCursor = { t = now, kind = kind, a = a, b = b, c = c }
		end
		return
	end
	if type(slot) ~= "number" or slot <= 0 then
		return
	end
	local ok, kind, id = pcall(GetActionInfo, slot)
	local i = ok and type(id) == "number" and Info()[id]
	local top = i and select(1, Top(i.list))
	local mine = ours[slot] and (now - ours[slot]) < 1
	print(("|cffffcc00MH ranks watch|r slot %d: %s %s%s; MH placed it: %s; cursor: %s"):format(slot, tostring(kind),
		tostring(id), i and (" (" .. i.name .. " rank " .. i.idx .. ", you know " .. tostring(top) .. ")") or "",
		mine and "yes" or "no",
		lastCursor and ("%s %s/%s/%s, %.2f s before"):format(lastCursor.kind, tostring(lastCursor.a), tostring(lastCursor.b),
			tostring(lastCursor.c), now - lastCursor.t) or "nothing seen"))
end)

--- /mh ranks [fix | auto on | auto off | glow on | glow off | choose | list | watch]
function ns.ForeverRanksSlash(arg)
	arg = (arg or ""):lower()
	if arg == "choose" or arg == "window" then
		ns.ShowForeverRanks()
		return
	end
	if arg == "list" then
		-- The "just learned" list again (also after "Not now" or closing it).
		for k in pairs(later) do
			later[k] = nil
		end
		local f = BuildLearn()
		f:Show()
		if (FillLearn() or 0) == 0 then
			print(PREFIX .. ns:L("FRANK_LIST_EMPTY"))
		end
		return
	end
	if arg == "watch" then
		watchUntil = (GetTime and GetTime() or 0) + 120
		lastCursor = nil
		print(PREFIX .. "ranks watch: 2 minutes. Drag a spell (also a LOWER rank from the spellbook) onto a button, let MH"
			.. " upgrade one, and screenshot the lines. They say per slot what it holds, whether MH placed it, and how long"
			.. " before the cursor held a spell.")
		return
	end
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
	local list, spells, ranked = Scan(true)
	print(PREFIX .. ("ranks: %d spell buttons, %d with a spell MH knows the ranks of, %d with a lower rank than you know. Auto: %s."):format(
		spells, ranked, #list, Settings().auto and "on" or "off (/mh ranks auto on)"))
	-- The player's own exceptions (per character), and where to change them.
	local e = Except()
	local bars, btns = {}, {}
	for n in pairs(e.bars) do
		bars[#bars + 1] = BarLabel(n)
	end
	for k in pairs(e.buttons) do
		btns[#btns + 1] = k
	end
	table.sort(bars)
	table.sort(btns)
	print(("   never touched: bars %s; buttons (slot:spell) %s. Change them in /mh ranks choose."):format(
		#bars > 0 and table.concat(bars, ", ") or "none", #btns > 0 and table.concat(btns, ", ") or "none"))
	print(("   just-learned list: %s; last decision: %s (/mh ranks list opens it)"):format(
		ns.IsForeverLearnListOn() and "on" or "off", listWhy))
	for _, r in ipairs(list) do
		local hi = ""
		if C_ActionBar and C_ActionBar.IsHighestSpellRank then
			local ok, v = pcall(C_ActionBar.IsHighestSpellRank, r.from)
			hi = ok and (" | game says highest: " .. tostring(v)) or ""
		end
		print(("   slot %d: %s rank %d (%d) -> rank %d (%d)%s%s%s"):format(r.slot, r.name, r.fromIdx, r.from, r.toIdx, r.to,
			r.fresh and " | just trained" or "", hi, r.skip and (" | never touched (" .. r.skip .. ")") or "")
			.. " | " .. (Where(r.slot) or "no Blizzard button holds this slot"))
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
