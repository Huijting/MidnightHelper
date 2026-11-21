local _, ns = ...

--[[
	ForeverItemTips.lua — WoW Forever: two extra tooltip lines on items.

	Rob, 16 Nov 2026 (via sparring, on the small ideas, letterlijk: "allemaal"): IDEEEN O22 and O23.
	  1. "Your class can never wear/use this" (O22, reason b). The other two reasons of O22 dropped out, measured by
	     mh-research that day: "recipe already known" is said by Blizzard's own tooltip ("Already known"), and "food too
	     weak" is not a game rule (Forever food only has a MINIMUM level).
	     Class masks GEMETEN in SkillRaceClassInfo (wago DB2 wowf 1.60.1.70938): Leather 1103, Mail 3 (+ Hunter/Shaman
	     from 40 = 71 "ever"), Plate 3 (from 40), Shield 67, Wands 400. Weapons: the class bits of ForeverWeapons.lua
	     (same table, same measurement); the weapon subclass → skill pairing is by name (AFGELEID). Only "never": a
	     "not yet" (mail before 40) is Blizzard's red line already.
	  2. "Needed for a quest in your log" (O23). GEMETEN by Rob on 16 Nov: C_QuestLog.GetQuestObjectives gives no item id,
	     only text, e.g. type "item" "0/1 Riptear's Heart"; and a delivery quest names its item in a "log" objective
	     ("Take Apothecary Johaan's findings to …", other capitals). Blizzard's tooltip only says "Quest Item" (Rob's test
	     the same day). So: the item name, case-insensitive and as a whole word, in ANY unfinished objective text of a
	     quest in your log; "n/m" only for an item objective. Only your own log, no Questie.
	Same switch as the "Used for" line (/mh usedfor on|off, ns.db.usedForTip). `/mh usedfor` prints the last decision.
]]

if not ns.IS_FOREVER then
	return
end

local function Enabled()
	return not (ns.db and ns.db.usedForTip == false)
end

local last = "nothing hovered yet"

-- Class bit of the player: Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16, Shaman 64, Mage 128, Warlock 256, Druid 1024.
local function ClassBit()
	local _, _, classID = UnitClass("player")
	if type(classID) ~= "number" or classID < 1 then
		return nil
	end
	return 2 ^ (classID - 1)
end

local function Has(mask, bit)
	return math.floor(mask / bit) % 2 == 1
end

-- [classID][subclassID] = class mask of everyone who can EVER use it.
local EVER = {
	[4] = { [2] = 1103, [3] = 71, [4] = 3, [6] = 67 }, -- armor: leather, mail, plate, shield (cloth: everyone)
	[2] = { [0] = 79, [1] = 71, [2] = 13, [3] = 13, [4] = 1115, [5] = 1091, [6] = 1031, [7] = 399, [8] = 7,
		[10] = 1493, [13] = 1101, [15] = 1501, [16] = 13, [18] = 13, [19] = 400 },
}

local function ItemClass(id)
	local info = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not info then
		return nil
	end
	local ok, _, _, _, _, _, classID, subclassID = pcall(info, id)
	if ok then
		return classID, subclassID
	end
	return nil
end

local function NeverLine(id)
	local cls, sub = ItemClass(id)
	local mask = cls and EVER[cls] and EVER[cls][sub]
	if not mask then
		return nil, "not armor/weapon with a class limit"
	end
	local bit = ClassBit()
	if not bit then
		return nil, "cannot read your class"
	end
	if Has(mask, bit) then
		return nil, "your class can use this kind"
	end
	return ns:L("FITEM_NEVER_FMT"):format((UnitClass("player"))), "class can never use it"
end

-- Quest objectives of your log, rebuilt on QUEST_LOG_UPDATE: { title, low (lowercased text), item (bool), have, need }.
local objectives = {}
local function Rebuild()
	objectives = {}
	if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo and C_QuestLog.GetQuestObjectives) then
		return
	end
	for i = 1, C_QuestLog.GetNumQuestLogEntries() or 0 do
		local q = C_QuestLog.GetInfo(i)
		if q and not q.isHeader and q.questID then
			for _, o in ipairs(C_QuestLog.GetQuestObjectives(q.questID) or {}) do
				if type(o.text) == "string" and o.text ~= "" and not o.finished then
					objectives[#objectives + 1] = { title = q.title or "?", low = o.text:lower(),
						item = (o.type == "item"), have = o.numFulfilled, need = o.numRequired }
				end
			end
		end
	end
end

--- The name as a whole word inside the text (so "Wolf Meat" does not match "Tough Wolf Meat").
local function HasWord(text, word)
	local s, e = 1, nil
	while true do
		s, e = text:find(word, s, true)
		if not s then
			return false
		end
		local before = s > 1 and text:sub(s - 1, s - 1) or " "
		local after = text:sub(e + 1, e + 1)
		if not before:match("[%w]") and (after == "" or not after:match("[%w]")) then
			return true
		end
		s = e + 1
	end
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

local function QuestLine(id)
	local name = ItemName(id)
	if not name then
		return nil, "item name not loaded yet"
	end
	local low = name:lower()
	for _, o in ipairs(objectives) do
		if HasWord(o.low, low) then
			if o.item and o.have and o.need then
				return ns:L("FITEM_QUEST_COUNT_FMT"):format(o.title, o.have, o.need), "in quest " .. o.title
			end
			return ns:L("FITEM_QUEST_FMT"):format(o.title), "in quest " .. o.title
		end
	end
	return nil, ("not in your %d open quest objective(s)"):format(#objectives)
end

local ev = CreateFrame("Frame")
pcall(ev.RegisterEvent, ev, "QUEST_LOG_UPDATE")
pcall(ev.RegisterEvent, ev, "PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	pcall(Rebuild)
end)

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		if not Enabled() or not (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
			return
		end
		local ok, err = pcall(function()
			local id = type(data) == "table" and data.id
			if type(id) ~= "number" or (issecretvalue and issecretvalue(id)) then
				last = "no readable item id"
				return
			end
			local never, whyN = NeverLine(id)
			local quest, whyQ = QuestLine(id)
			last = ("item %d: class line: %s; quest line: %s"):format(id, whyN, whyQ)
			if never then
				tooltip:AddLine(never, 1, 0.45, 0.45, true)
			end
			if quest then
				tooltip:AddLine(quest, 1, 0.82, 0, true)
			end
			if never or quest then
				tooltip:Show()
			end
		end)
		if not ok then
			last = "error: " .. tostring(err)
		end
	end)
else
	last = "this client has no TooltipDataProcessor: the lines cannot be added"
end

--------------------------------------------------------------------------------
-- 21 Nov 2026 (Rob on the Skill up window: "Wat ik wel mis zie, zijn onze tooltips die we overal zouden inbouwen."):
-- shared helpers for text windows. An item name becomes the game's own link (quality colour, the game's tooltip on
-- hover); a spell name the game's spell link. A frame gets the hover through ns.ForeverHookLinks. Font strings in a
-- ScrollFrame do not fire hyperlink events (DelveTipMarkup.lua / PlayCardWindow.lua, AFGELEID there, not re-measured),
-- so the windows that use this keep their text on a plain frame.
--------------------------------------------------------------------------------

--- The game's item link for an id (with its quality colour), or the plain name while the client loads it.
function ns.ForeverItemLinkText(id)
	if type(id) ~= "number" then
		return tostring(id)
	end
	local info = (C_Item and C_Item.GetItemInfo) or GetItemInfo
	if info then
		local ok, name, link = pcall(info, id)
		if ok and type(link) == "string" and link ~= "" and not (issecretvalue and issecretvalue(link)) then
			return link
		end
		if ok and type(name) == "string" and name ~= "" then
			return name
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return ItemName(id) or ns:L("FVEND_ITEM_LOADING")
end

--- The game's spell link for an id (link blue, the spell tooltip on hover).
function ns.ForeverSpellLinkText(id, name)
	if C_Spell and C_Spell.GetSpellLink then
		local ok, link = pcall(C_Spell.GetSpellLink, id)
		if ok and type(link) == "string" and link ~= "" and not (issecretvalue and issecretvalue(link)) then
			return link
		end
	end
	return ("|cff71d5ff|Hspell:%d|h[%s]|h|r"):format(id, tostring(name or id))
end

--- Hover a link in any font string of `frame` = the game's own tooltip; shift-click puts it in chat.
function ns.ForeverHookLinks(frame)
	if not frame or frame._mhLinks or not frame.SetHyperlinksEnabled then
		return
	end
	frame._mhLinks = true
	frame:SetHyperlinksEnabled(true)
	frame:SetScript("OnHyperlinkEnter", function(self, link)
		if not (GameTooltip and link) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		pcall(GameTooltip.SetHyperlink, GameTooltip, link)
		GameTooltip:Show()
	end)
	frame:SetScript("OnHyperlinkLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	frame:SetScript("OnHyperlinkClick", function(_, link, text)
		if IsModifiedClick and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then
			pcall(ChatEdit_InsertLink, text)
		end
	end)
end

--- For `/mh usedfor` (ReagentUse.lua): the last decision of these two lines.
function ns.ForeverItemTipsLast()
	return last
end
