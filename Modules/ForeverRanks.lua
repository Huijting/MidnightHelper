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

--- /mh ranks [fix | auto on | auto off]
function ns.ForeverRanksSlash(arg)
	arg = (arg or ""):lower()
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
			r.fresh and " | just trained" or "", hi))
	end
	if spells > 0 and ranked == 0 then
		print("   none of your spell buttons is in MH's rank list: on a non-English client the list still matches by id.")
	end
	if #list > 0 then
		print("   /mh ranks fix upgrades all of them (also a lower rank you use on purpose).")
	end
end
