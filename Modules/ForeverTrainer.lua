local _, ns = ...

--[[
	ForeverTrainer.lua — WoW Forever: "new at your trainer", with the key each spell lands on.

	Rob, 7 Nov 2026: "ik denk aan a en dan evt zelf de optie geven om een pijl naar de trainer maken, dan hoeven we niet
	de extra addon te installeren" → "Ja, A + pijl". This file is step A; the arrow to the trainer is step 2.
	Idea from What's Training? (docs/forever/WHATS_TRAINING_2026-11-07.md). What MH adds: the KEY. What's Training knows
	what you can learn; only MH knows where it goes on your block.

	Data: ForeverTrainerData.lua (generated from What's Training?'s MIT data, levels cross-checked with our research).
	  - At every level-up: one chat line, and the window opens by itself when there is something to learn (out of combat).
	    /mh trainer auto off stops the window opening by itself (the chat line stays) — players choose, not us.
	  - /mh trainer        opens or closes the window
	  - /mh trainer check  prints what was decided and why (a module whose normal result is "nothing" needs a way to see
	                       that it decided nothing on purpose — CLAUDE.md).
	English only, like Forever's How you play (translation when Rob asks).
]]

if not ns.IS_FOREVER then
	return
end

local DATA = ns.FOREVER_TRAINER_SPELLS

local function Token()
	local _, token = UnitClass("player")
	return token
end

local function Settings()
	if not ns.db then
		return { auto = true }
	end
	ns.db.foreverTrainer = ns.db.foreverTrainer or { auto = true }
	return ns.db.foreverTrainer
end

--- Does this character have this exact spell id?
local function KnownId(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function SpellName(e)
	if C_Spell and C_Spell.GetSpellName then
		local ok, nm = pcall(C_Spell.GetSpellName, e.id)
		if ok and type(nm) == "string" and nm ~= "" and not (issecretvalue and issecretvalue(nm)) then
			return nm
		end
	end
	return e.n
end

local function RankText(id)
	if C_Spell and C_Spell.GetSpellSubtext then
		local ok, sub = pcall(C_Spell.GetSpellSubtext, id)
		if ok and type(sub) == "string" and sub ~= "" and not (issecretvalue and issecretvalue(sub)) then
			return sub
		end
	end
	return nil
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

--- Where a spell goes on the key block: "Q", "block D", or nil (not on the block).
local function KeyFor(token, name)
	local cls = ns.FOREVER_BLOCK_CLASSES and ns.FOREVER_BLOCK_CLASSES[token]
	if not cls then
		return nil
	end
	local function has(v)
		if type(v) == "string" then
			return v == name
		elseif type(v) == "table" then
			for _, n in ipairs(v) do
				if n == name then
					return true
				end
			end
		end
		return false
	end
	local label = ns.KeyBlockKeyLabel or function(k) return k end
	for key, def in pairs(cls.keys or {}) do
		for field, v in pairs(def) do
			if field == "pair" then
				if has(v.first) or has(v.second) then
					return label(key)
				end
			elseif field ~= "cmd" and field ~= "open" and field ~= "bang" and has(v) then
				return label(key)
			end
		end
	end
	if has(cls.toBlockD) then
		return "block D"
	end
	return nil
end

--- Everything the window and the check need, for this character at this level.
local function Compute(level)
	local token = Token()
	local list = DATA and token and DATA[token]
	local out = { token = token, level = level, now = {}, needs = {}, next = {}, nextLevel = nil, known = 0, other = 0,
		total = 0, data = list and #list or 0 }
	if not list then
		return out
	end
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local _, _, raceID = UnitRace("player")
	local levelOf = {}
	for _, e in ipairs(list) do
		levelOf[e.id] = e.l
	end
	-- Highest rank this character has under each name: a lower rank counts as known once a higher one is (Forever
	-- replaces some ranks in the spellbook; What's Training keeps "overriddenGroups" for the same reason).
	local bestByName = {}
	local function Known(e)
		if KnownId(e.id) then
			return true
		end
		if bestByName[e.n] == nil then
			local id = ns.ForeverKnownSpell and ns.ForeverKnownSpell(e.n)
			bestByName[e.n] = id or false
		end
		local best = bestByName[e.n]
		return best and levelOf[best] and levelOf[best] >= e.l or false
	end
	local function Fits(e)
		if e.fac and e.fac ~= faction then
			return false
		end
		if e.race and e.race ~= raceID then
			return false
		end
		if e.races then
			local ok = false
			for _, r in ipairs(e.races) do
				if r == raceID then
					ok = true
				end
			end
			if not ok then
				return false
			end
		end
		if e.tal and not KnownId(e.tal) then
			return false -- a talent spell: only for whoever took the talent
		end
		return true
	end
	local avail = {}
	for _, e in ipairs(list) do
		if not Fits(e) then
			out.other = out.other + 1
		elseif Known(e) then
			out.known = out.known + 1
		elseif e.l <= level then
			local missing
			for _, r in ipairs(e.req or {}) do
				-- The previous rank counts when any rank of that name is known: Forever swaps some out of the spellbook
				-- (Seal of Righteousness 20154 -> 21084 with Judgement; What's Training's "overriddenGroups").
				local byName = false
				if not KnownId(r) and not avail[r] and C_Spell and C_Spell.GetSpellName and ns.ForeverKnownSpell then
					local okN, rn = pcall(C_Spell.GetSpellName, r)
					byName = okN and type(rn) == "string" and ns.ForeverKnownSpell(rn) and true or false
				end
				if not KnownId(r) and not avail[r] and not byName then
					missing = r
				end
			end
			if missing then
				local nm
				if C_Spell and C_Spell.GetSpellName then
					local ok, n = pcall(C_Spell.GetSpellName, missing)
					nm = ok and n or nil
				end
				out.needs[#out.needs + 1] = { e = e, first = nm or ("spell " .. missing) }
			else
				avail[e.id] = true
				out.now[#out.now + 1] = e
				out.total = out.total + e.c
			end
		elseif not out.nextLevel or e.l == out.nextLevel then
			out.nextLevel = e.l
			out.next[#out.next + 1] = e
		end
	end
	return out
end
ns.ForeverTrainerCompute = Compute -- the offline check calls it

local function Line(token, e)
	local name = SpellName(e)
	local rank = RankText(e.id)
	local key = KeyFor(token, e.n)
	local passive = false
	if not key and C_Spell and C_Spell.IsSpellPassive then
		local okP, p = pcall(C_Spell.IsSpellPassive, e.id)
		passive = okP and p == true
	end
	local where = key and ("|cffffd100" .. key .. "|r")
		or passive and "|cff9d9d9dpassive: works by itself, no key|r"
		or "|cff9d9d9dnot on the block (put it on your own bar)|r"
	return ("- %s%s  %s  ->  %s"):format(name, rank and (" |cff9d9d9d(" .. rank .. ")|r") or "", Money(e.c), where)
end

local function Text(r)
	local p = {}
	local HEAD = "|cffffcc66"
	if #r.now > 0 then
		p[#p + 1] = HEAD .. ("You can learn %d now"):format(#r.now) .. "|r  " .. Money(r.total) ..
			((GetMoney and GetMoney() < r.total) and ("  |cffff5555(you have " .. Money(GetMoney()) .. ")|r") or "")
		for _, e in ipairs(r.now) do
			p[#p + 1] = Line(r.token, e)
		end
		p[#p + 1] = "|cff9d9d9dA key gets its spell as soon as you learn it. A key that was empty: press Update in the key " ..
			"block (/mh block).|r"
	else
		p[#p + 1] = HEAD .. "Nothing new to learn right now.|r"
	end
	if #r.needs > 0 then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. "Needs something else first|r"
		for _, n in ipairs(r.needs) do
			p[#p + 1] = ("- %s: first %s"):format(SpellName(n.e), n.first)
		end
	end
	if r.nextLevel then
		p[#p + 1] = ""
		p[#p + 1] = HEAD .. ("Next, at level %d"):format(r.nextLevel) .. "|r"
		for _, e in ipairs(r.next) do
			p[#p + 1] = Line(r.token, e)
		end
	end
	p[#p + 1] = ""
	p[#p + 1] = "|cff9d9d9dYour class trainer is in your capital city and in your start town. Talents, books and quest " ..
		"spells are not in this list.|r"
	return table.concat(p, "\n")
end

ns.ForeverTrainerText = function(level) -- the offline check prints it
	return Text(Compute(level))
end

local win

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverTrainer", UIParent, "BackdropTemplate")
	f:SetSize(560, 460)
	f:SetPoint("CENTER", 0, 60)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 22, -48)
	scroll:SetPoint("BOTTOMRIGHT", -38, 20)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(490, 10)
	scroll:SetScrollChild(child)
	local body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", 4, -4)
	body:SetWidth(480)
	body:SetJustifyH("LEFT")
	body:SetSpacing(3)
	f.scroll, f.child, f.body = scroll, child, body
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Fill(level)
	local f = Build()
	local r = Compute(level or UnitLevel("player"))
	f.title:SetText(("New at your trainer - level %d"):format(r.level))
	f.body:SetText(Text(r))
	f.child:SetHeight(f.body:GetStringHeight() + 20)
	f.scroll:SetVerticalScroll(0)
	return f, r
end

function ns.ShowForeverTrainer(level)
	local f = Fill(level)
	f:Show()
	-- Rank texts load on demand; fill once more when the client has them (AFGELEID: the first call can miss some).
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			if f:IsShown() then
				Fill(level)
			end
		end)
	end
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

local function Check()
	local level = UnitLevel("player")
	local r = Compute(level)
	print(PREFIX .. ("trainer check: class %s, level %d, data rows %d"):format(tostring(r.token), level, r.data))
	print(("  known %d, learn now %d (%s), needs something first %d, next level %s (%d), other race/faction/talent %d")
		:format(r.known, #r.now, Money(r.total), #r.needs, tostring(r.nextLevel), #r.next, r.other))
	print(("  opens by itself at level-up: %s (/mh trainer auto on|off)"):format(Settings().auto and "yes" or "no"))
	if r.data == 0 then
		print("  no trainer data for this class: the window stays empty on purpose")
	end
end

function ns.ForeverTrainerSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		Check()
	elseif arg == "auto off" or arg == "auto on" then
		Settings().auto = (arg == "auto on")
		print(PREFIX .. "the trainer window " .. (Settings().auto and "opens by itself at level-up again." or
			"no longer opens by itself. The chat line stays; /mh trainer opens it."))
	elseif win and win:IsShown() then
		win:Hide()
	else
		ns.ShowForeverTrainer()
	end
end

-- Level-up: wait a moment (the new level settles), never pop up in combat.
local pendingLevel
local function OnLevel(level)
	if InCombatLockdown and InCombatLockdown() then
		pendingLevel = level -- fought straight after the ding: PLAYER_REGEN_ENABLED tries again
		return
	end
	local r = Compute(level)
	if #r.now > 0 then
		print(PREFIX .. ("level %d: %d new at your trainer (%s). /mh trainer shows them with their keys.")
			:format(level, #r.now, Money(r.total)))
		if Settings().auto then
			ns.ShowForeverTrainer(level)
		end
	elseif r.nextLevel then
		print(PREFIX .. ("level %d: nothing new at your trainer. Next: level %d (%d)."):format(level, r.nextLevel, #r.next))
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, level)
	if event == "PLAYER_LEVEL_UP" then
		pendingLevel = tonumber(level) or UnitLevel("player")
		if InCombatLockdown and InCombatLockdown() then
			return
		end
	elseif not pendingLevel then
		return
	end
	local lv = pendingLevel
	pendingLevel = nil
	if C_Timer and C_Timer.After then
		C_Timer.After(2, function()
			OnLevel(lv)
		end)
	else
		OnLevel(lv)
	end
end)
