local _, ns = ...

--[[
	ForeverTrainAll.lua — WoW Forever: a "Train all" button under the game's own class trainer window.

	Rob, 7 Nov 2026: "Eigenlijk vond ik dat wel een handige optie. Kunnen wij dat ook bouwen?" → "ja". He saw the same
	button from Talents Forever on his own PC and missed it on another PC. Talents Forever ships no licence file, so
	nothing of its code is copied here; this file is our own. What we learned from watching how such a button has to
	behave on this client (not yet measured by us — Rob's test at a trainer settles it):
	  - GetTrainerServiceInfo(i) gives name, then a state ("available" / "unavailable" / "used" / "header"); older
	    clients put the state third, so both places are looked at.
	  - The list re-numbers after a purchase, so we buy ONE row, wait for TRAINER_UPDATE, and read the list again.
	  - A purchase the game refuses raises no Lua error; the row simply stays for sale. We then stop and say so.
	  - A Hunter's Beast Training opens the same window for the pet (paid in training points): no button there.

	  - Only class trainers. A profession trainer gets no button: buying every recipe at once is a choice we do not make
	    for the player.
	  - Talents Forever loaded → our button stays away by default (two buttons for one job). /mh trainer button on|off|auto.
	  - /mh trainer button   prints what the button decided and why (CLAUDE.md: something that can stay silent gets a way
	                         to see that it stayed silent on purpose).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local STATES = { available = true, unavailable = true, used = true }

local function Settings()
	if not ns.db then
		return {}
	end
	ns.db.foreverTrainer = ns.db.foreverTrainer or { auto = true }
	return ns.db.foreverTrainer
end

--- "auto" (default), "on" or "off".
local function Mode()
	local m = Settings().trainAll
	if m == "on" or m == "off" then
		return m
	end
	return "auto"
end

local function AddOnLoaded(name)
	local fn = (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded
	if not fn then
		return false
	end
	local ok, v = pcall(fn, name)
	return ok and v and true or false
end

local function Money(c)
	if C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
		local ok, s = pcall(C_CurrencyInfo.GetCoinTextureString, c)
		if ok and s then
			return s
		end
	end
	if GetCoinTextureString then
		return GetCoinTextureString(c)
	end
	return tostring(c) .. "c"
end

local function Purse()
	return GetMoney and GetMoney() or 0
end

--- Every learnable/learned row in the open trainer window (headers left out).
local function Rows()
	local out = {}
	if not (GetNumTrainerServices and GetTrainerServiceInfo) then
		return out
	end
	local ok, n = pcall(GetNumTrainerServices)
	n = ok and tonumber(n) or 0
	for i = 1, n do
		local ok2, name, s1, s2 = pcall(GetTrainerServiceInfo, i)
		if ok2 and type(name) == "string" and name ~= "" then
			local state = (STATES[s1] and s1) or (STATES[s2] and s2) or nil
			if state then
				local cost, points = 0, 0
				if GetTrainerServiceCost then
					local ok3, c, p = pcall(GetTrainerServiceCost, i)
					if ok3 then
						cost, points = tonumber(c) or 0, tonumber(p) or 0
					end
				end
				out[#out + 1] = { i = i, name = name, state = state, cost = cost, points = points }
			end
		end
	end
	return out
end

--- Why there is no button at this trainer, or nil when there is one.
local function WhyNot(rows)
	if Mode() == "off" then
		return "switched off (/mh trainer button on)"
	end
	if Mode() == "auto" and AddOnLoaded("TalentsForeverBook") then
		return "Talents Forever is loaded and has its own Train all button (/mh trainer button on shows ours too)"
	end
	if not (GetNumTrainerServices and GetTrainerServiceInfo and BuyTrainerService) then
		return "this client has no trainer functions for addons"
	end
	if IsTradeskillTrainer then
		local ok, v = pcall(IsTradeskillTrainer)
		if ok and v then
			return "a profession trainer: no button there on purpose"
		end
	end
	if UnitIsUnit then
		local ok, v = pcall(UnitIsUnit, "npc", "pet")
		if ok and v then
			return "Beast Training (your pet's window): the game does not let an addon buy there"
		end
	end
	for _, r in ipairs(rows) do
		if r.points > 0 then
			return "rows cost training points (Beast Training): the game does not let an addon buy there"
		end
	end
	return nil
end

--- What one click buys now: the available rows the purse covers, in the trainer's order.
local function Plan(rows)
	local p = { rows = {}, cost = 0, short = 0 }
	local left = Purse()
	for _, r in ipairs(rows) do
		if r.state == "available" then
			if r.cost <= left then
				left = left - r.cost
				p.rows[#p.rows + 1] = r
				p.cost = p.cost + r.cost
			else
				p.short = p.short + 1
			end
		end
	end
	return p
end

-- The running purchase (nil when idle).
local run
local btn

local function TrainerFrame()
	local f = _G.ClassTrainerFrame
	if f and f.IsShown and f:IsShown() then
		return f
	end
end

local function Refresh()
	if not btn then
		return
	end
	local rows = Rows()
	if WhyNot(rows) or not TrainerFrame() then
		btn:Hide()
		return
	end
	local p = Plan(rows)
	btn.plan = p
	if run then
		btn:SetText(ns:L("FTRAIN_ALL_BUSY"))
	elseif #p.rows > 0 then
		btn:SetText(ns:L("FTRAIN_ALL_FMT"):format(#p.rows, Money(p.cost)))
	else
		btn:SetText(ns:L("FTRAIN_ALL"))
	end
	local fs = btn:GetFontString()
	btn:SetWidth(math.max(150, math.ceil(((fs and fs:GetStringWidth()) or 100) + 30)))
	btn:SetEnabled(#p.rows > 0 and not run)
	btn:Show()
end

local function Finish(blocked)
	local r = run
	run = nil
	if not r then
		return
	end
	if blocked then
		print(PREFIX .. (r.bought > 0 and ns:L("FTRAIN_ALL_BLOCKED_AFTER_FMT"):format(r.bought) or ns:L("FTRAIN_ALL_BLOCKED")))
	elseif r.bought > 0 then
		local short = Plan(Rows()).short
		local line = ns:L("FTRAIN_ALL_DONE_FMT"):format(r.bought, Money(r.spent))
		if short > 0 then
			line = line .. " " .. ns:L("FTRAIN_ALL_LATER_FMT"):format(short)
		end
		print(PREFIX .. line)
	end
	Refresh()
end

-- Buy the first row the purse covers; the next one waits for TRAINER_UPDATE (the list re-numbers after each).
local function Step()
	if not run then
		return
	end
	if not TrainerFrame() or run.tries >= 80 then
		Finish(false)
		return
	end
	local p = Plan(Rows())
	local r = p.rows[1]
	if not r then
		Finish(false)
		return
	end
	run.tries = run.tries + 1
	run.waiting = { name = r.name, i = r.i, cost = r.cost }
	pcall(BuyTrainerService, r.i)
	local mine = run.waiting
	C_Timer.After(1.5, function()
		if not run or run.waiting ~= mine then
			return -- TRAINER_UPDATE came: this one is done
		end
		run.waiting = nil
		-- No update, and the same row is still for sale: the game refused it. Stop instead of knocking on every row.
		for _, row in ipairs(Rows()) do
			if row.name == mine.name and row.state == "available" then
				Finish(true)
				return
			end
		end
		run.bought, run.spent = run.bought + 1, run.spent + mine.cost
		Step()
	end)
end

local function Start()
	if run then
		return
	end
	if #Plan(Rows()).rows == 0 then
		print(PREFIX .. ns:L("FTRAIN_ALL_NONE"))
		return
	end
	run = { bought = 0, spent = 0, tries = 0 }
	Refresh()
	Step()
end

local function Tip(self)
	local p = self.plan
	if not p then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(ns:L("FTRAIN_ALL"), 1, 0.82, 0)
	if #p.rows == 0 then
		GameTooltip:AddLine(ns:L("FTRAIN_ALL_NONE"), 0.75, 0.75, 0.75, true)
	end
	for _, r in ipairs(p.rows) do
		GameTooltip:AddDoubleLine(r.name, Money(r.cost), 1, 1, 1, 0.8, 0.8, 0.8)
	end
	if #p.rows > 1 then
		GameTooltip:AddDoubleLine(" ", Money(p.cost), 1, 1, 1, 1, 0.82, 0)
	end
	if p.short > 0 then
		GameTooltip:AddLine(ns:L("FTRAIN_ALL_SHORT_FMT"):format(p.short), 1, 0.35, 0.35, true)
	end
	GameTooltip:Show()
end

local function MakeButton()
	local tf = TrainerFrame()
	if not tf then
		return
	end
	if not btn then
		btn = CreateFrame("Button", "MidnightHelperTrainAll", tf, "UIPanelButtonTemplate")
		btn:SetSize(150, 22)
		btn:SetScript("OnClick", Start)
		btn:SetScript("OnEnter", Tip)
		btn:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		if btn.SetMotionScriptsWhileDisabled then
			btn:SetMotionScriptsWhileDisabled(true)
		end
	elseif btn:GetParent() ~= tf then
		btn:SetParent(tf)
	end
	btn:ClearAllPoints()
	-- Under the window, below its own Train button; under Talents Forever's button when both are asked for.
	local other = _G.TalentsForeverBookTrainAll
	local anchor = (other and other.IsShown and other:IsShown() and other) or _G.ClassTrainerTrainButton or tf.TrainButton
	if anchor then
		btn:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -6)
	else
		btn:SetPoint("TOP", tf, "BOTTOM", 0, -4)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("TRAINER_SHOW")
ev:RegisterEvent("TRAINER_UPDATE")
ev:RegisterEvent("TRAINER_CLOSED")
ev:RegisterEvent("PLAYER_MONEY")
ev:SetScript("OnEvent", function(_, event)
	if event == "TRAINER_SHOW" then
		run = nil
		-- the window is filled a moment after the event; build after it is shown
		C_Timer.After(0, function()
			MakeButton()
			Refresh()
		end)
	elseif event == "TRAINER_UPDATE" then
		if run and run.waiting then
			local w = run.waiting
			run.waiting = nil
			run.bought, run.spent = run.bought + 1, run.spent + w.cost
			C_Timer.After(0.2, Step)
		elseif btn then
			Refresh()
		end
	elseif event == "TRAINER_CLOSED" then
		if run then
			Finish(false)
		end
		if btn then
			btn:Hide()
		end
	elseif event == "PLAYER_MONEY" and btn and btn:IsShown() and not run then
		Refresh()
	end
end)

--- /mh trainer button [on|off|auto]
function ns.ForeverTrainAllSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" or arg == "auto" then
		Settings().trainAll = arg
		print(PREFIX .. "Train all button: " .. arg .. (arg == "auto" and " (hidden while Talents Forever is loaded)" or "") .. ".")
		if btn then
			Refresh()
		end
		return
	end
	print(PREFIX .. "Train all button: setting " .. Mode() .. ". /mh trainer button on|off|auto changes it.")
	if not TrainerFrame() then
		print("  no trainer window open now: open one and type this again to see what the button decides there.")
		return
	end
	local rows = Rows()
	local why = WhyNot(rows)
	if why then
		print("  no button here: " .. why .. ".")
		return
	end
	local p = Plan(rows)
	local avail = 0
	for _, r in ipairs(rows) do
		if r.state == "available" then
			avail = avail + 1
		end
	end
	print(("  %d rows read, %d available, %d you can pay now (%s), %d more than your money covers."):format(
		#rows, avail, #p.rows, Money(p.cost), p.short))
	if #rows == 0 then
		print("  zero rows: the window's filter may hide them (the dropdown at the top: Available).")
	end
end
