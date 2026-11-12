local _, ns = ...

--[[
	ForeverDoNow.lua — WoW Forever: the small window "Do this now / All caught up / Coming up".

	Rob, 11 Nov 2026 (after PaladinPlan; GPL-3.0, so only the idea): "Doe dit nu / Alles bij / Komt eraan". Design talked
	through on 12 Nov (his choices, IDEEEN.md): only Forever; shown "only when there is something to do" by default, a
	setting puts it on "always", and one turns it off; works without a chosen direction. Build-yes 12 Nov via sparring,
	verbatim: "Venster 'Doe dit nu'".

	Every line rests on something MH already has (no new measurement):
	  Do this now
	    - spells ready at your class trainer ............ ns.ForeverTrainerCompute(level).now (ForeverTrainer.lua) + arrow
	    - buttons that still cast an old rank ........... ns.ForeverRankCount / ns.ForeverRankFixAll (ForeverRanks.lua)
	    - weapon skills you can learn now ............... ns.ForeverWeaponsLearnableCount (ForeverWeapons.lua)
	    - a missing buff ................................ ns.GetForeverMissingBuffs + ns.MissingBuffSentence (ForeverBuffs/MissingBuff)
	    - a profession without its tool ................. ns.ForeverMissingTools (ForeverVendors.lua)
	  All caught up — when none of the above.
	  Coming up
	    - trainer spells of the next 3 levels, by name . ns.ForeverTrainerCompute(level + 3), spells above your level
	    - with a chosen direction: the next talent spell of that tree and its earliest level
	      (ns.ForeverDirectionTalents, ForeverMacros.lua SPEC_MACROS; levels AFGELEID from "first point at 10, one per level")
	Not here on purpose (sparring's limits): stats, "best weapon", "switch weapons now", professions advice, the tooltip /
	upgrade notice (step 3).
	Hidden in a fight (a text panel has nothing to do there), back afterwards.
	/mh donow = show/hide now · /mh donow auto|always|off · /mh donow check = what it would say and why it is (not) shown.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local HEAD, GREY, GOOD = "|cffffcc66", "|cff9d9d9d", "|cff7fff7f"
local W = 300

local win
local forced = nil -- /mh donow shows (true) or hides (false) it for this session, whatever the mode says

local function Mode()
	local m = ns.db and ns.db.foreverDoNowMode
	return (m == "always" or m == "off") and m or "auto"
end

local function SetMode(m)
	if ns.db then
		ns.db.foreverDoNowMode = (m == "always" or m == "off") and m or nil
	end
	forced = nil
	if ns.ForeverDoNowUpdate then
		ns.ForeverDoNowUpdate()
	end
end
ns.ForeverDoNowMode = Mode
ns.SetForeverDoNowMode = SetMode

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "#" .. tostring(id)
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	return tostring(c)
end

--- What the window would say. @return { now = {lines}, actions = {kind = true}, soon = {lines} }
local function Collect()
	local level = UnitLevel and UnitLevel("player") or 1
	local out = { now = {}, actions = {}, soon = {} }
	-- Do this now
	local r = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level)
	if r and #r.now > 0 then
		out.now[#out.now + 1] = ns:L("HOME_FOREVER_TRAINER_NOW_FMT"):format(#r.now, Money(r.total))
		out.actions.trainer = true
	end
	local nRank = ns.ForeverRankCount and ns.ForeverRankCount() or 0
	if nRank > 0 then
		out.now[#out.now + 1] = ns:L("FRANK_HOME_FMT"):format(nRank)
		out.actions.ranks = true
	end
	local nWeap = ns.ForeverWeaponsLearnableCount and ns.ForeverWeaponsLearnableCount() or 0
	if nWeap > 0 then
		out.now[#out.now + 1] = ns:L("FWEAP_HOME_FMT"):format(nWeap)
		out.actions.weapons = true
	end
	if ns.GetForeverMissingBuffs and ns.MissingBuffSentence then
		local ok, list = pcall(ns.GetForeverMissingBuffs)
		if ok and type(list) == "table" then
			for _, e in ipairs(list) do
				out.now[#out.now + 1] = ns.MissingBuffSentence(e, false)
			end
		end
	end
	if ns.ForeverMissingTools then
		local ok, tools = pcall(ns.ForeverMissingTools)
		if ok and type(tools) == "table" then
			for _, t in ipairs(tools) do
				out.now[#out.now + 1] = ns:L("FDONOW_TOOL_FMT"):format(t.prof, t.tool, "/mh vendor " .. t.key)
				out.actions.tool = out.actions.tool or t.key
			end
		end
	end
	-- Coming up: trainer spells above your level, up to 3 levels on
	local r3 = ns.ForeverTrainerCompute and ns.ForeverTrainerCompute(level + 3)
	local byLevel, levels = {}, {}
	for _, e in ipairs(r3 and r3.now or {}) do
		if e.l > level then
			if not byLevel[e.l] then
				byLevel[e.l] = {}
				levels[#levels + 1] = e.l
			end
			local nm = SpellName(e.id)
			local dup = false
			for _, x in ipairs(byLevel[e.l]) do
				if x == nm then
					dup = true -- two ranks/variants with one name: once is enough
				end
			end
			if not dup then
				byLevel[e.l][#byLevel[e.l] + 1] = nm
			end
		end
	end
	table.sort(levels)
	for _, l in ipairs(levels) do
		out.soon[#out.soon + 1] = ns:L("FDONOW_SOON_LEVEL_FMT"):format(l, table.concat(byLevel[l], ", "))
	end
	if #out.soon == 0 then
		out.soon[#out.soon + 1] = GREY .. ns:L("FDONOW_SOON_NONE") .. "|r"
	end
	-- With a direction: its next talent spell (only facts the research holds: which spell belongs to which tree).
	local band, tree = nil, nil
	if ns.GetForeverDirection then
		band, tree = ns.GetForeverDirection()
	end
	if band and ns.ForeverDirectionTalents then
		local _, cls = UnitClass("player")
		for _, t in ipairs(ns.ForeverDirectionTalents(cls, band)) do
			if t.level > level then
				out.soon[#out.soon + 1] = ns:L("FDONOW_TALENT_FMT"):format(tree, SpellName(t.id), t.level)
				break
			end
		end
	end
	return out
end

--- Shown or not, and why (for /mh donow check and Update).
local function Decision(info)
	if InCombatLockdown and InCombatLockdown() then
		return false, "in combat (back after the fight)"
	end
	if forced ~= nil then
		return forced, forced and "shown by /mh donow" or "hidden by /mh donow (this session)"
	end
	local m = Mode()
	if m == "off" then
		return false, "switched off (Settings, or /mh donow auto|always)"
	end
	if m == "always" then
		return true, "mode: always"
	end
	if #info.now > 0 then
		return true, ("mode: only when there is something to do; %d thing(s) to do"):format(#info.now)
	end
	return false, "mode: only when there is something to do; nothing to do now"
end

local function Btn(f, x, onClick)
	local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	b:SetSize(90, 20)
	b:SetPoint("BOTTOMLEFT", x, 10)
	b:SetScript("OnClick", onClick)
	b:Hide()
	return b
end

local function SavePos()
	if not (win and ns.db) then
		return
	end
	local p, _, rp, x, y = win:GetPoint()
	ns.db.foreverDoNowPos = { p, rp, x, y, win:GetScale() }
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDoNow", UIParent, "BackdropTemplate")
	f:SetSize(W, 120)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0.04, 0.04, 0.06, 0.85)
	f:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
	local pos = ns.db and ns.db.foreverDoNowPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
		if pos[5] then
			f:SetScale(pos[5])
		end
	else
		f:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -40, -240)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
	end)
	-- Shift+scroll = size (the rule for every MH window).
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.6, math.min(2, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		SavePos()
	end)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOPLEFT", 10, -8)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 2)
	close:SetScale(0.8)
	close:SetScript("OnClick", function()
		forced = false
		f:Hide()
		print(PREFIX .. ns:L("FDONOW_CLOSED"))
	end)
	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.body:SetPoint("TOPLEFT", 10, -26)
	f.body:SetWidth(W - 20)
	f.body:SetJustifyH("LEFT")
	f.body:SetSpacing(2)
	f.btnTrainer = Btn(f, 10, function()
		if ns.ForeverTrainerGo then
			ns.ForeverTrainerGo()
		end
	end)
	f.btnRanks = Btn(f, 104, function()
		if ns.ForeverRankFixAll then
			ns.ForeverRankFixAll()
		end
	end)
	f.btnWeapons = Btn(f, 198, function()
		if ns.ShowForeverWeapons then
			ns.ShowForeverWeapons()
		end
	end)
	f:Hide()
	win = f
	return f
end

local function Render(info)
	local f = Build()
	f.title:SetText(ns:L("FDONOW_TITLE"))
	local lines = {}
	if #info.now > 0 then
		lines[#lines + 1] = HEAD .. ns:L("FDONOW_HEAD_NOW") .. "|r"
		for _, s in ipairs(info.now) do
			lines[#lines + 1] = "- " .. s
		end
	else
		lines[#lines + 1] = GOOD .. ns:L("FDONOW_HEAD_DONE") .. "|r"
	end
	lines[#lines + 1] = " "
	lines[#lines + 1] = HEAD .. ns:L("FDONOW_HEAD_SOON") .. "|r"
	for _, s in ipairs(info.soon) do
		lines[#lines + 1] = "- " .. s
	end
	f.body:SetText(table.concat(lines, "\n"))
	f.btnTrainer:SetText(ns:L("HOME_FOREVER_BTN_GO"))
	f.btnRanks:SetText(ns:L("FRANK_HOME_BTN"))
	f.btnWeapons:SetText(ns:L("FWEAP_TITLE"))
	-- Buttons only for what is on the list; they close up from the left. Each as wide as its own text (Rob's 21.png,
	-- 12 Nov 2026: "Weapon trainers" stuck out of a fixed 90 px button), and a new row when the next one does not fit.
	local shown = {}
	for _, pair in ipairs({ { f.btnTrainer, info.actions.trainer }, { f.btnRanks, info.actions.ranks },
		{ f.btnWeapons, info.actions.weapons } }) do
		local b, on = pair[1], pair[2]
		if on then
			local fs = b:GetFontString()
			b:SetWidth(math.min(W - 20, math.max(80, math.ceil(((fs and fs:GetStringWidth()) or 70) + 24))))
			shown[#shown + 1] = b
		else
			b:Hide()
		end
	end
	local rows, x = {}, 10
	for _, b in ipairs(shown) do
		if #rows == 0 or x + b:GetWidth() > W - 10 then
			rows[#rows + 1] = {}
			x = 10
		end
		local r = rows[#rows]
		r[#r + 1] = { b = b, x = x }
		x = x + b:GetWidth() + 4
	end
	for i, r in ipairs(rows) do
		local y = 10 + (#rows - i) * 24
		for _, e in ipairs(r) do
			e.b:ClearAllPoints()
			e.b:SetPoint("BOTTOMLEFT", e.x, y)
			e.b:Show()
		end
	end
	local btnH = (#rows > 0) and (#rows * 24 + 6) or 0
	f:SetHeight(26 + f.body:GetStringHeight() + 12 + btnH)
end

local lastWhy = "not checked yet"

local function Update()
	local okC, info = pcall(Collect)
	if not okC then
		lastWhy = "error while collecting: " .. tostring(info)
		if win then
			win:Hide()
		end
		return
	end
	local show, why = Decision(info)
	lastWhy = why
	if show then
		Render(info)
		win:Show()
	elseif win then
		win:Hide()
	end
end
ns.ForeverDoNowUpdate = Update

function ns.ForeverDoNowSlash(arg)
	arg = (arg or ""):lower()
	if arg == "auto" or arg == "always" or arg == "off" then
		SetMode(arg)
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverDoNowMode", Mode())
		end
		print(PREFIX .. ns:L("FDONOW_MODE_CHAT_FMT"):format(ns:L("FDONOW_MODE_" .. arg:upper())))
	elseif arg == "check" or arg == "why" then
		local ok, info = pcall(Collect)
		if not ok then
			print(PREFIX .. "do this now: error - " .. tostring(info))
			return
		end
		local show, why = Decision(info)
		print(PREFIX .. ("do this now: mode %s; %s - %s"):format(Mode(), show and "shown" or "not shown", why))
		print(("  to do now: %d; coming up: %d line(s); last update: %s"):format(#info.now, #info.soon, lastWhy))
		for _, s in ipairs(info.now) do
			print("  - " .. s)
		end
	else
		forced = not (win and win:IsShown())
		Update()
	end
end

-- Events: anything that can change a line. Throttled to one update per half second.
local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_LEVEL_UP", "SPELLS_CHANGED", "PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED", "BAG_UPDATE_DELAYED", "ACTIONBAR_SLOT_CHANGED", "SKILL_LINES_CHANGED", "PLAYER_MONEY",
	"UNIT_PET" }) do
	pcall(ev.RegisterEvent, ev, e)
end
pcall(ev.RegisterUnitEvent, ev, "UNIT_AURA", "player")
local queued = false
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		if win then
			win:Hide()
		end
		return
	end
	if queued then
		return
	end
	queued = true
	C_Timer.After(event == "PLAYER_ENTERING_WORLD" and 4 or 0.5, function()
		queued = false
		Update()
	end)
end)
