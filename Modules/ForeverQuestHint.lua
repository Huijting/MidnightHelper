local _, ns = ...

--[[
	ForeverQuestHint.lua — WoW Forever: which quest reward to take, and WHY, in one line.

	Rob, 7 Nov 2026: "En de doe de quest beloning tip maar ook" (idea 1 of docs/forever/REVIEW_GEARQUEST_2026-11-07.md).
	MH's angle is the explanation: GearQuest and Zygor put an arrow or a glow on a reward; MH says why.

	When a quest offers a choice (QUEST_COMPLETE, GetNumQuestChoices() > 1):
	  - every reward the game marks usable for you (GetQuestItemInfo's isUsable) and that you can wear is compared with
	    what you wear in that slot, on YOUR class's main stats (ns.FOREVER_MAIN_STATS, sourced in
	    docs/forever/FOREVER_MAIN_STATS_2026-11-07.md); Stamina breaks a tie;
	  - the biggest gain gets a green frame on its button and a line under the quest window:
	    "Take <item>: +5 Agility (your main stat as a Rogue) over what you wear";
	  - no gain for you: the one that sells for the most, said so plainly.
	Nothing is ever picked or clicked for you. Players choose: /mh questhint off turns it off; /mh questhint check prints
	the last decision per reward (a module whose normal result is silence needs that, CLAUDE.md).

	Ideas only from GearQuest (All Rights Reserved) and Zygor: no code or data taken. Item data can arrive a moment after
	the window opens, so it retries a few times (Zygor does the same; AFGELEID that Forever needs it).
	English only, like the other Forever texts.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local STAT_KEY = {
	STRENGTH = "ITEM_MOD_STRENGTH_SHORT", AGILITY = "ITEM_MOD_AGILITY_SHORT", INTELLECT = "ITEM_MOD_INTELLECT_SHORT",
	SPIRIT = "ITEM_MOD_SPIRIT_SHORT", STAMINA = "ITEM_MOD_STAMINA_SHORT",
}
local STAT_NAME = { STRENGTH = "Strength", AGILITY = "Agility", INTELLECT = "Intellect", SPIRIT = "Spirit",
	STAMINA = "Stamina" }

-- equipLoc → the inventory slot(s) it would replace (two for rings, trinkets and one-hand weapons).
local SLOTS = {
	INVTYPE_HEAD = { 1 }, INVTYPE_NECK = { 2 }, INVTYPE_SHOULDER = { 3 }, INVTYPE_BODY = { 4 }, INVTYPE_CHEST = { 5 },
	INVTYPE_ROBE = { 5 }, INVTYPE_WAIST = { 6 }, INVTYPE_LEGS = { 7 }, INVTYPE_FEET = { 8 }, INVTYPE_WRIST = { 9 },
	INVTYPE_HAND = { 10 }, INVTYPE_FINGER = { 11, 12 }, INVTYPE_TRINKET = { 13, 14 }, INVTYPE_CLOAK = { 15 },
	INVTYPE_WEAPON = { 16, 17 }, INVTYPE_2HWEAPON = { 16 }, INVTYPE_WEAPONMAINHAND = { 16 },
	INVTYPE_WEAPONOFFHAND = { 17 }, INVTYPE_SHIELD = { 17 }, INVTYPE_HOLDABLE = { 17 }, INVTYPE_RANGED = { 18 },
	INVTYPE_RANGEDRIGHT = { 18 }, INVTYPE_THROWN = { 18 }, INVTYPE_RELIC = { 18 },
}

local function Enabled()
	return not (ns.db and ns.db.foreverQuestHint == false)
end

local function Token()
	local _, token = UnitClass("player")
	return token
end

local function ClassName(token)
	local names = LOCALIZED_CLASS_NAMES_MALE
	return (names and names[token]) or (token and (token:sub(1, 1) .. token:sub(2):lower())) or "?"
end

--- Coins with their icons. Rob's screenshot showed "(9)": the global GetCoinTextureString is not there on Forever
--- (AFGELEID from that "(9)"); C_CurrencyInfo's is what the trainer window already uses and Rob saw it work there.
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

local function StatName(k)
	local g = _G[STAT_KEY[k]]
	return (type(g) == "string" and g ~= "") and g or STAT_NAME[k]
end

--- name, quality, equipLoc, sellPrice for a link; nil while the client has not loaded it.
local function ItemInfo(link)
	local fn = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if not (fn and link) then
		return nil
	end
	local ok, name, _, quality, _, _, _, _, _, equipLoc, _, sellPrice = pcall(fn, link)
	if not ok or not name then
		return nil
	end
	return name, quality, equipLoc, sellPrice or 0
end

--- 🔴 ARMOR — Rob, 7 Nov 2026 (screenshot, "denk dat het niet goed gaat ?!?"): Snow Boots (7 armor) against worn boots
--- (2 armor), no stats on either reward, and MH said "none is better". At low level armor is often the ONLY
--- difference. Read it from the stats table (RESISTANCE0_NAME, the classic key; AFGELEID for Forever) or else from the
--- item's tooltip line ("%s Armor", Blizzard's ARMOR_TEMPLATE; the approach Zygor uses, and C_TooltipInfo.GetHyperlink
--- is what Baganator/Syndicator/Auctionator use on Forever — candidates, not proof).
local function Armor(link, t)
	local v = t and t.RESISTANCE0_NAME
	if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
		return v
	end
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink and link) then
		return 0
	end
	local ok, data = pcall(C_TooltipInfo.GetHyperlink, link)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return 0
	end
	local tpl = type(ARMOR_TEMPLATE) == "string" and ARMOR_TEMPLATE or "%s Armor"
	local pat = "^" .. tpl:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1"):gsub("%%s", "([%%d,%%.]+)") .. "$"
	for _, line in ipairs(data.lines) do
		local txt = line.leftText
		if type(txt) == "string" and not (issecretvalue and issecretvalue(txt)) then
			local n = txt:match(pat)
			if n then
				return tonumber((n:gsub("[,%.]", ""))) or 0
			end
		end
	end
	return 0
end

--- { STRENGTH = n, ..., ARMOR = n } for a link (the five primary stats + armor). An item without stats (plain cloth
--- boots) still gets its armor: the stats call may return nil for it.
local function Stats(link)
	if not link then
		return nil
	end
	local fn = (C_Item and C_Item.GetItemStats) or GetItemStats
	local t
	if fn then
		local ok, res = pcall(fn, link)
		t = (ok and type(res) == "table") and res or nil
	end
	t = t or {}
	local out = {}
	for k, key in pairs(STAT_KEY) do
		local v = t[key]
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			out[k] = v
		end
	end
	out.ARMOR = Armor(link, t)
	return out
end

local WEIGHT = { 1, 0.5 } -- first main stat counts fully, the second half (ForeverMainStats.lua header; AFGELEID)

--- This character's main stats: the `later` order once its talent is known (Mental Dexterity, Careful Aim, ...).
local function MainFor(def)
	if not def then
		return nil
	end
	if def.later and ns.ForeverKnownSpell and ns.ForeverKnownSpell(def.later.talent) then
		return def.later.main
	end
	return def.main
end

--- Weighted main-stat score and the Stamina tie-breaker of a stats table.
local function Score(stats, main, stamTie)
	local s, staInMain = 0, false
	for i, k in ipairs(main or {}) do
		s = s + ((stats and stats[k]) or 0) * (WEIGHT[i] or 0)
		if k == "STAMINA" then
			staInMain = true
		end
	end
	local tie = (stamTie and not staInMain) and ((stats and stats.STAMINA) or 0) or 0
	return s, tie
end

--- What the player wears in the weaker of the slots this equipLoc fits: main score, stamina, stats, link.
local function Worn(equipLoc, main, stamTie)
	local slots = SLOTS[equipLoc]
	if not slots then
		return nil
	end
	local best
	for _, slot in ipairs(slots) do
		local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
		local stats = link and Stats(link) or {}
		local s, sta = Score(stats, main, stamTie)
		local arm = stats.ARMOR or 0
		if not best or s < best.s or (s == best.s and (sta < best.sta or (sta == best.sta and arm < best.arm))) then
			best = { s = s, sta = sta, arm = arm, stats = stats, link = link, slot = slot }
		end
	end
	return best
end

local last = { at = nil, rows = {}, verdict = "none yet" } -- for /mh questhint check

--- "+3 Strength, +12 Armor" and the reason, for a row { stats, worn, ds, dsta, darm }. Shared by the quest hint and
--- the gear tooltip line, so both say the same thing about the same item.
--- Names the main stats, then Stamina when it breaks ties; each stat once (Warlock has Stamina as a main stat).
local function Explain(row, main, stamTie, token)
	local parts, done, shown = {}, {}, {}
	for _, k in ipairs(main) do
		shown[#shown + 1] = k
	end
	if stamTie then
		shown[#shown + 1] = "STAMINA"
	end
	for _, k in ipairs(shown) do
		if not done[k] then
			done[k] = true
			local gain = ((row.stats and row.stats[k]) or 0)
				- ((row.worn and row.worn.stats and row.worn.stats[k]) or 0)
			if gain ~= 0 then
				parts[#parts + 1] = ("%+d %s"):format(gain, StatName(k))
			end
		end
	end
	if row.darm and row.darm ~= 0 then
		parts[#parts + 1] = ("%+d %s"):format(row.darm, (type(ARMOR) == "string" and ARMOR) or "Armor")
	end
	local why = (row.ds == 0 and row.dsta == 0) and ns:L("FQH_WHY_ARMOR")
		or ns:L("FQH_WHY_MAIN_FMT"):format(ClassName(token))
	return parts, why
end

--- Better = more main stats; equal → more Stamina (where it counts); still equal → more armor.
local function IsBetter(row)
	return row.ds > 0 or (row.ds == 0 and (row.dsta > 0 or (row.dsta == 0 and row.darm > 0)))
end

--- The decision for the current quest window: { index, kind = "upgrade"/"money", text } or nil, plus "not ready".
local function Decide()
	local n = GetNumQuestChoices and GetNumQuestChoices() or 0
	if n < 2 then
		return nil, "fewer than 2 rewards to choose from"
	end
	local token = Token()
	local def = ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[token]
	local main = MainFor(def)
	local stamTie = def and def.stamTie
	local rows, best, bestMoney = {}, nil, nil
	for i = 1, n do
		local link = GetQuestItemLink and GetQuestItemLink("choice", i)
		local name, quality, equipLoc, sell = ItemInfo(link)
		if not name then
			return nil, "not ready"
		end
		local count, isUsable = 1, true
		if GetQuestItemInfo then
			local okQ, _, _, c, _, u = pcall(GetQuestItemInfo, "choice", i)
			if okQ then
				count, isUsable = c, u
			end
		end
		count = tonumber(count) or 1
		local row = { i = i, link = link, name = name, usable = isUsable and true or false, equipLoc = equipLoc,
			sell = (sell or 0) * count }
		if row.usable and SLOTS[equipLoc] and main then
			local stats = Stats(link) or {}
			local s, sta = Score(stats, main, stamTie)
			local worn = Worn(equipLoc, main, stamTie)
			row.s, row.sta, row.stats = s, sta, stats
			row.ds, row.dsta = s - (worn and worn.s or 0), sta - (worn and worn.sta or 0)
			row.darm = (stats.ARMOR or 0) - (worn and worn.arm or 0)
			row.worn = worn
			if IsBetter(row) then
				if not best or row.ds > best.ds or (row.ds == best.ds and (row.dsta > best.dsta
					or (row.dsta == best.dsta and row.darm > best.darm))) then
					best = row
				end
			end
			row.worn = worn
		end
		if not bestMoney or row.sell > bestMoney.sell then
			bestMoney = row
		end
		rows[#rows + 1] = row
	end
	last.rows = rows
	if best then
		local parts, why = Explain(best, main, stamTie, token)
		if not best.worn or not best.worn.link then
			return { index = best.i, kind = "upgrade", text = ns:L("FQH_TAKE_EMPTY_FMT")
				:format(best.link, table.concat(parts, ", "), why) }
		end
		return { index = best.i, kind = "upgrade", text = ns:L("FQH_TAKE_FMT")
			:format(best.link, table.concat(parts, ", "), why) }
	end
	if not main then
		return { index = bestMoney.i, kind = "money", text = ns:L("FQH_NO_LIST_FMT"):format(bestMoney.link) }
	end
	if bestMoney and bestMoney.sell > 0 then
		return { index = bestMoney.i, kind = "money", text = ns:L("FQH_SELL_FMT")
			:format(bestMoney.link, Money(bestMoney.sell)) }
	end
	return nil, "nothing better and nothing that sells"
end
ns.ForeverQuestHintDecide = Decide -- the offline check calls it

-- The marker: our own frames (parented to UIParent, never a child of Blizzard's buttons), placed on the reward button,
-- and the reason line under the quest window.
local glow, caption

local function RewardButton(i)
	local b = _G["QuestInfoRewardsFrameQuestInfoItem" .. i]
	if b then
		return b
	end
	local rf = QuestInfoFrame and QuestInfoFrame.rewardsFrame
	for _, btn in ipairs((rf and rf.RewardButtons) or {}) do
		if btn.GetID and btn:GetID() == i then
			return btn
		end
	end
	return nil
end

local function HideHint()
	if glow then
		glow:Hide()
	end
	if caption then
		caption:Hide()
	end
end

local function ShowHint(d)
	local b = RewardButton(d.index)
	if b and b:IsVisible() then
		if not glow then
			glow = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
			glow:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
			glow:SetFrameStrata("HIGH")
		end
		glow:SetBackdropBorderColor(d.kind == "upgrade" and 0.37 or 1, d.kind == "upgrade" and 1 or 0.82,
			d.kind == "upgrade" and 0.33 or 0, 1)
		glow:ClearAllPoints()
		glow:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
		glow:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
		glow:Show()
	end
	local anchor = QuestFrame and QuestFrame:IsVisible() and QuestFrame
	if anchor then
		if not caption then
			caption = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
			caption:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			caption:SetBackdropColor(0, 0, 0, 0.85)
			caption:SetFrameStrata("HIGH")
			caption.text = caption:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			caption.text:SetPoint("TOPLEFT", 8, -7)
			caption.text:SetJustifyH("LEFT")
		end
		caption:ClearAllPoints()
		caption:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2)
		caption:SetWidth(math.max(260, anchor:GetWidth()))
		caption.text:SetWidth(caption:GetWidth() - 16)
		caption.text:SetText("|cffffcc00MH:|r " .. d.text)
		caption:SetHeight(caption.text:GetStringHeight() + 14)
		caption:Show()
	else
		print(PREFIX .. d.text) -- no quest window to sit under: say it where it can be read
	end
end

local tries = 0
local function Run()
	if not Enabled() then
		last.verdict = "off (/mh questhint on)"
		return
	end
	local d, why = Decide()
	if not d and why == "not ready" and tries < 10 and C_Timer and C_Timer.After then
		tries = tries + 1
		C_Timer.After(0.2, Run)
		return
	end
	last.at = time and time() or nil
	if d then
		last.verdict = d.kind .. ": reward " .. d.index
		ShowHint(d)
	else
		last.verdict = why or "nothing"
		HideHint()
	end
end

function ns.ForeverQuestHintSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.foreverQuestHint = (arg == "on")
		end
		print(PREFIX .. "quest reward hint " .. (arg == "on" and "on." or "off. /mh questhint on brings it back."))
		if arg == "off" then
			HideHint()
		end
		return
	end
	local main = MainFor(ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[Token()])
	print(PREFIX .. ("quest hint: %s; main stats for %s: %s; last decision: %s"):format(Enabled() and "on" or "off",
		ClassName(Token()), main and table.concat(main, ", ") or "none", last.verdict))
	for _, r in ipairs(last.rows or {}) do
		print(("  %d %s usable=%s slot=%s main=%s stam=%s armor=%s gain=%s/%s/%s sells=%s"):format(r.i, r.link or r.name,
			tostring(r.usable), tostring(r.equipLoc), tostring(r.s), tostring(r.sta),
			tostring(r.stats and r.stats.ARMOR), tostring(r.ds), tostring(r.dsta), tostring(r.darm), tostring(r.sell)))
	end
end

--[[ Gear tooltip line (Rob, 11 Nov 2026: "Alleen tooltipregel").
	Hover a piece of gear you could wear: when it beats what you wear on YOUR main stats, the tooltip gets one green line
	"MH: +3 Strength over what you wear (main stats for a Paladin)." Same math and words as the quest hint above.
	Why only a line and no bag arrows: Rob's Forever runs Pawn (arrows + tooltip already) and Baganator (replaces the
	Blizzard bags our retail arrows hook into) — measured in his AddOns.txt that day. MH adds the WHY, not another arrow.
	Silent for: items you cannot use (any red line in the tooltip: armor type, level, class — AFGELEID that Forever
	colours them like every client does), what you already wear, items that are not better. /mh geartip on|off. ]]

local function GearTipEnabled()
	return not (ns.db and ns.db.foreverGearTip == false)
end

local function IsRed(c)
	return type(c) == "table" and type(c.r) == "number" and not (issecretvalue and issecretvalue(c.r))
		and c.r > 0.95 and (c.g or 1) < 0.35 and (c.b or 1) < 0.35
end

--- Any red text in the tooltip = the game says you cannot use or wear this (yet).
local function CannotUse(data)
	for _, line in ipairs((data and data.lines) or {}) do
		if IsRed(line.leftColor) or IsRed(line.rightColor) then
			return true
		end
	end
	return false
end

local tipLast = "none yet" -- for /mh geartip

--- The line for this item link, or nil plus why not.
function ns.ForeverGearTipText(link)
	local name, _, equipLoc = ItemInfo(link)
	if not name then
		return nil, "item not loaded"
	end
	local slots = SLOTS[equipLoc]
	if not slots then
		return nil, "not gear (" .. tostring(equipLoc) .. ")"
	end
	for _, slot in ipairs(slots) do
		if GetInventoryItemLink and GetInventoryItemLink("player", slot) == link then
			return nil, "you wear it"
		end
	end
	local token = Token()
	local def = ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[token]
	local main = MainFor(def)
	if not main then
		return nil, "no main stats known for " .. tostring(token)
	end
	local stamTie = def and def.stamTie
	local stats = Stats(link) or {}
	local s, sta = Score(stats, main, stamTie)
	local worn = Worn(equipLoc, main, stamTie)
	local row = { stats = stats, worn = worn, ds = s - (worn and worn.s or 0), dsta = sta - (worn and worn.sta or 0),
		darm = (stats.ARMOR or 0) - (worn and worn.arm or 0) }
	if not IsBetter(row) then
		return nil, ("not better (main %+g, stamina %+g, armor %+d)"):format(row.ds, row.dsta, row.darm)
	end
	local parts, why = Explain(row, main, stamTie, token)
	local gains = table.concat(parts, ", ")
	-- 3rd/4th return: the pieces, for the pickup notice (PickupUpgrade.lua) that words it its own way.
	return ns:L("FGEAR_TIP_FMT"):format(gains, why), nil, gains, why
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		-- Only the tooltips you hover or click; not the "Currently equipped" comparison tooltips beside them.
		if not GearTipEnabled() or not (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
			return
		end
		local ok, err = pcall(function()
			local _, link = tooltip:GetItem()
			if type(link) ~= "string" or (issecretvalue and issecretvalue(link)) then
				tipLast = "no readable item link"
				return
			end
			if CannotUse(data) then
				tipLast = "red line in the tooltip: you cannot use or wear it (yet)"
				return
			end
			local text, why = ns.ForeverGearTipText(link)
			tipLast = text and ("shown: " .. text) or why
			if text then
				tooltip:AddLine(text, 0.37, 1, 0.33, true)
				tooltip:Show()
			end
		end)
		if not ok then
			tipLast = "error: " .. tostring(err)
		end
	end)
else
	tipLast = "this client has no TooltipDataProcessor: the line cannot be added"
end

--- /mh geartip [on|off]: the switch, and the last decision (its normal result is silence, CLAUDE.md).
function ns.ForeverGearTipSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		if ns.db then
			ns.db.foreverGearTip = (arg == "on")
		end
		print(PREFIX .. ns:L(arg == "on" and "FGEAR_TIP_ON" or "FGEAR_TIP_OFF"))
		return
	end
	print(PREFIX .. ("gear tooltip line: %s; last item you hovered: %s"):format(GearTipEnabled() and "on" or "off",
		tipLast))
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "QUEST_COMPLETE", "QUEST_FINISHED" }) do
	pcall(ev.RegisterEvent, ev, e) -- an event Forever dropped would throw (GearQuest review); a pcall keeps the rest alive
end
ev:SetScript("OnEvent", function(_, event)
	if event == "QUEST_FINISHED" then
		HideHint()
		return
	end
	tries = 0
	Run()
end)
