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

--- { STRENGTH = n, ... } for a link (only the five primary stats), or nil when the client gives nothing.
local function Stats(link)
	local fn = (C_Item and C_Item.GetItemStats) or GetItemStats
	if not (fn and link) then
		return nil
	end
	local ok, t = pcall(fn, link)
	if not ok or type(t) ~= "table" then
		return nil
	end
	local out = {}
	for k, key in pairs(STAT_KEY) do
		local v = t[key]
		if type(v) == "number" and not (issecretvalue and issecretvalue(v)) then
			out[k] = v
		end
	end
	return out
end

--- Main-stat points and stamina of a stats table for this class.
local function Score(stats, main)
	local s = 0
	for _, k in ipairs(main or {}) do
		if k ~= "STAMINA" then
			s = s + ((stats and stats[k]) or 0)
		end
	end
	return s, (stats and stats.STAMINA) or 0
end

--- What the player wears in the weaker of the slots this equipLoc fits: main score, stamina, stats, link.
local function Worn(equipLoc, main)
	local slots = SLOTS[equipLoc]
	if not slots then
		return nil
	end
	local best
	for _, slot in ipairs(slots) do
		local link = GetInventoryItemLink and GetInventoryItemLink("player", slot)
		local stats = link and Stats(link) or {}
		local s, sta = Score(stats, main)
		if not best or s < best.s or (s == best.s and sta < best.sta) then
			best = { s = s, sta = sta, stats = stats, link = link, slot = slot }
		end
	end
	return best
end

local last = { at = nil, rows = {}, verdict = "none yet" } -- for /mh questhint check

--- The decision for the current quest window: { index, kind = "upgrade"/"money", text } or nil, plus "not ready".
local function Decide()
	local n = GetNumQuestChoices and GetNumQuestChoices() or 0
	if n < 2 then
		return nil, "fewer than 2 rewards to choose from"
	end
	local token = Token()
	local def = ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[token]
	local main = def and def.main
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
			local s, sta = Score(stats, main)
			local worn = Worn(equipLoc, main)
			row.s, row.sta, row.stats = s, sta, stats
			row.ds, row.dsta = s - (worn and worn.s or 0), sta - (worn and worn.sta or 0)
			if row.ds > 0 or (row.ds == 0 and row.dsta > 0 and s > 0) then
				if not best or row.ds > best.ds or (row.ds == best.ds and row.dsta > best.dsta) then
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
		local parts = {}
		for _, k in ipairs(main) do
			local gain = ((best.stats and best.stats[k]) or 0) - ((best.worn and best.worn.stats and best.worn.stats[k]) or 0)
			if gain ~= 0 then
				parts[#parts + 1] = ("%+d %s"):format(gain, StatName(k))
			end
		end
		if not best.worn or not best.worn.link then
			return { index = best.i, kind = "upgrade", text = ("Take %s: %s, your main stats as a %s. That slot is empty now.")
				:format(best.link, table.concat(parts, ", "), ClassName(token)) }
		end
		return { index = best.i, kind = "upgrade", text = ("Take %s: %s over what you wear (main stats for a %s).")
			:format(best.link, table.concat(parts, ", "), ClassName(token)) }
	end
	if not main then
		return { index = bestMoney.i, kind = "money", text = ("No stat list for your class yet. %s sells for the most.")
			:format(bestMoney.link) }
	end
	if bestMoney and bestMoney.sell > 0 then
		return { index = bestMoney.i, kind = "money", text = ("None of these is better for you than what you wear. " ..
			"%s sells for the most (%s)."):format(bestMoney.link, GetCoinTextureString and GetCoinTextureString(bestMoney.sell)
			or tostring(bestMoney.sell)) }
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
	local def = ns.FOREVER_MAIN_STATS and ns.FOREVER_MAIN_STATS[Token()]
	print(PREFIX .. ("quest hint: %s; main stats for %s: %s; last decision: %s"):format(Enabled() and "on" or "off",
		ClassName(Token()), def and table.concat(def.main, ", ") or "none", last.verdict))
	for _, r in ipairs(last.rows or {}) do
		print(("  %d %s usable=%s slot=%s main=%s stam=%s gain=%s/%s sells=%s"):format(r.i, r.link or r.name,
			tostring(r.usable), tostring(r.equipLoc), tostring(r.s), tostring(r.sta), tostring(r.ds), tostring(r.dsta),
			tostring(r.sell)))
	end
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
