local _, ns = ...

--[[
	ForeverDungeonQuests.lua — WoW Forever: per dungeon "pick these quests up first": who gives them, where (Show the
	way), and what you already did or have in your log.

	Rob, 21 Nov 2026 (via sparring, verbatim): "ik blijf bij Zygor, Polestar probeer ik later. maar kunnen wij er iets van
	leren / verbeteren" → "2 en 1, doe maar, daarna 3 en 4 :)". This is point 2. Only the IDEA came from looking at other
	addons; the data is our own extraction (tools/build_dungeon_quests.py → ForeverDungeonQuestsData.lua): Zygor's local
	"Dungeon Quests" guides (quest, giver, |goto) + Spoken's `prev`. Nothing from Polestar (GPLv3) or FlowUp (ARR).

	Per quest, for this character (side and class filter first):
	  done    C_QuestLog.IsQuestFlaggedCompleted
	  log     C_QuestLog.GetLogIndexForQuestID
	  inside  picked up inside the dungeon (Zygor's "_Inside the ... Dungeon:_" step)
	  later   Spoken's `prev` is not done yet ("After: …")
	  now     everything else: go and pick it up
	Two rows with the same English title (Zygor's "|or" variants, e.g. The Glowing Shard 3366/6981) count as one: once
	one is done or in the log, the other is not offered again.
	NOT measured: quest levels (not in the data), Zygor's coordinates in game, and whether every `prev` is the real one.
	`/mh dungeons quests check` prints, per quest of the chosen dungeon, the state and why (a quiet list needs a way to
	see why).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local S = ns.ForeverStyle
local W, H = 560, 500

local function Data()
	return ns.FOREVER_DUNGEON_QUESTS or {}
end

local function Done(q)
	local f = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted
	if f then
		local ok, v = pcall(f, q)
		return ok and v and true or false
	end
	return false
end

local function InLog(q)
	local f = C_QuestLog and C_QuestLog.GetLogIndexForQuestID
	if f then
		local ok, v = pcall(f, q)
		return ok and v ~= nil and v ~= 0
	end
	return false
end

local requested = {}
--- The client's title (its own language), else the English one from the data.
local function Title(q, fallback)
	local f = C_QuestLog and C_QuestLog.GetTitleForQuestID
	if f then
		local ok, v = pcall(f, q)
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	if not requested[q] and C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		requested[q] = true
		pcall(C_QuestLog.RequestLoadQuestByID, q)
	end
	return fallback or ("#" .. tostring(q))
end

local function NpcName(e)
	local loc = GetLocale and GetLocale() or "enUS"
	if loc == "esMX" then
		loc = "esES"
	end
	-- npc = the creature id; names are Blizzard's (Wowhead Forever tooltips), English when this language has no own one.
	local all = ns.FOREVER_DUNGEON_QUEST_NPCS or {}
	local t, en = all[loc], all.enUS
	return e.npc and ((t and t[e.npc]) or (en and en[e.npc])) or nil
end

local function ZoneName(id)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, id)
		if ok and info and info.name then
			return info.name
		end
	end
	return "#" .. tostring(id)
end

local function ItemName(id)
	local f = (C_Item and C_Item.GetItemNameByID) or GetItemInfo
	if f then
		local ok, v = pcall(f, id)
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	return "#" .. tostring(id)
end

--- The dungeon's name as the overview shows it (client name + wing), from ForeverDungeons.lua.
local function DungeonName(key)
	if ns.ForeverDungeonList then
		local ok, l = pcall(ns.ForeverDungeonList)
		for _, d in ipairs(ok and l or {}) do
			if d.key == key then
				return d.name
			end
		end
	end
	return key
end

local function ForMe(e, side, class)
	if e.side and side and e.side ~= side then
		return false
	end
	if e.classes then
		for _, c in ipairs(e.classes) do
			if c == class then
				return true
			end
		end
		return false
	end
	return true
end

--- Every quest of this dungeon for this character, with its state. Returns the list and the counts.
local function Collect(key)
	local list = Data()[key]
	local side = UnitFactionGroup and UnitFactionGroup("player")
	local class = UnitClass and select(2, UnitClass("player"))
	local out, n = {}, { now = 0, log = 0, inside = 0, later = 0, done = 0, total = 0 }
	if not list then
		return out, n, false
	end
	local taken = {} -- English title → done or in the log (one of the "|or" variants)
	for _, e in ipairs(list) do
		if ForMe(e, side, class) and (Done(e.q) or InLog(e.q)) then
			taken[e.en or e.q] = true
		end
	end
	for _, e in ipairs(list) do
		if ForMe(e, side, class) then
			local st, why
			if Done(e.q) then
				st, why = "done", "IsQuestFlaggedCompleted"
			elseif InLog(e.q) then
				st, why = "log", "in the quest log"
			elseif taken[e.en or e.q] then
				st, why = nil, "a variant with the same title is done or in the log"
			elseif e.inside then
				st, why = "inside", "picked up inside the dungeon"
			elseif e.prev and not Done(e.prev) then
				st, why = "later", ("prev %d not done"):format(e.prev)
			else
				st, why = "now", e.prev and ("prev %d done"):format(e.prev) or "no quest before it"
			end
			if st then
				n[st] = n[st] + 1
				n.total = n.total + 1
			end
			out[#out + 1] = { e = e, st = st, why = why }
		end
	end
	return out, n, true
end

--- For the overview's dungeon row: how many to pick up now (nil when there is no quest list for this dungeon).
function ns.ForeverDungeonQuestCounts(key)
	local _, n, has = Collect(key)
	if not has or n.total == 0 then
		return nil
	end
	return n
end

local function GoTo(e)
	if not e.m then
		return false
	end
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(e.m, e.x, e.y)) then
		if not ns._mhWaypointYielded then -- the Forever Leveling Guide steers: Core already said why
			print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		end
		return false
	end
	local who = NpcName(e) or ZoneName(e.m)
	ns.lastTarget = { mapID = e.m, x = e.x, y = e.y, name = who, via = "/mh dungeons quests", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. ns:L("FDQ_ARROW_FMT"):format(who, ZoneName(e.m), Title(e.q, e.en)))
	return true
end

--- The second line of a row: who and where, or why there is no place.
local function Where(it)
	local e = it.e
	if it.st == "later" then
		local p
		for _, x in ipairs(Data()[it.key] or {}) do
			if x.q == e.prev then
				p = x.en
			end
		end
		return ns:L("FDQ_AFTER_FMT"):format(Title(e.prev, p))
	end
	local who = NpcName(e)
	if e.inside then
		return who and ns:L("FDQ_INSIDE_FMT"):format(who) or ns:L("FDQ_SEC_INSIDE")
	end
	local first
	if e.item then
		first = ns:L("FDQ_FROM_ITEM_FMT"):format(ItemName(e.item))
	elseif e.object then
		first = ns:L("FDQ_FROM_OBJECT")
	else
		first = who
	end
	if e.m then
		return first and ("%s · %s"):format(first, ZoneName(e.m)) or ZoneName(e.m)
	end
	return first and (first .. " · " .. ns:L("FDQ_NO_PLACE")) or ns:L("FDQ_NO_PLACE")
end

--------------------------------------------------------------------------------
-- Window (Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local win, shownKey, Fill = nil, nil, nil
local ROW_GAP = 4
local COLORS = { now = "|cff7fff7f", log = "|cffffd100", inside = "|cff9fc5ff", later = "|cff9d9d9d" }
local SECTIONS = { { "now", "FDQ_SEC_NOW" }, { "log", "FDQ_SEC_LOG" }, { "inside", "FDQ_SEC_INSIDE" },
	{ "later", "FDQ_SEC_LATER" } }

local function Row(f, i)
	f.rows = f.rows or {}
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f.child)
	f._mhNewFs = true
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.text:SetPoint("TOPLEFT", 0, 0)
	r.text:SetJustifyH("LEFT")
	r.text:SetJustifyV("TOP")
	r.sub = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.sub:SetPoint("TOPLEFT", r.text, "BOTTOMLEFT", 0, -2)
	r.sub:SetJustifyH("LEFT")
	r.sub:SetJustifyV("TOP")
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(70, 20)
	r.go:SetPoint("TOPRIGHT", 0, 0)
	r.go:SetScript("OnClick", function(self)
		if self.e then
			GoTo(self.e)
		end
	end)
	r.go:SetScript("OnEnter", function(self)
		local e = self.e
		if not (e and e.m and GameTooltip) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(Title(e.q, e.en))
		GameTooltip:AddLine(("%s, %.1f, %.1f"):format(ZoneName(e.m), e.x, e.y), 1, 1, 1)
		if ns.ForeverTravelSentence then
			local ok, s = pcall(ns.ForeverTravelSentence, e.m, e.x, e.y)
			if ok and type(s) == "string" and s ~= "" then
				GameTooltip:AddLine(s, 0.8, 0.8, 0.8, true)
			end
		end
		GameTooltip:Show()
	end)
	r.go:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	f.rows[i] = r
	return r
end

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDungeonQuests", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 40, 20)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	f:EnableMouse(true)
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 20, -16)
	f.title:SetPoint("RIGHT", f, "RIGHT", -36, 0)
	f.title:SetJustifyH("LEFT")
	f.title:SetWordWrap(false)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	f.head = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.head:SetPoint("TOPLEFT", 20, -42)
	f.head:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.head:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 20, -64)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - 60, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child = scroll, child
	f.note = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.note:SetPoint("BOTTOMLEFT", 20, 12)
	f.note:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.note:SetJustifyH("LEFT")
	f:SetScript("OnShow", function()
		Fill()
	end)
	if S and S.SkinOnShow then
		S.SkinOnShow(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

Fill = function()
	local f = win
	if not (f and f:IsShown() and shownKey) then
		return
	end
	local key = shownKey
	f.title:SetText(ns:L("FDQ_TITLE_FMT"):format(DungeonName(key)))
	local list, n, has = Collect(key)
	f.note:SetText(ns:L("FDQ_NOTE"))
	local width = W - 60
	local textW = width - 80
	local y, i = 0, 0
	f.secs = f.secs or {}
	local nsec = 0
	if not has or n.total == 0 then
		f.head:SetText(ns:L("FDQ_NONE"))
	else
		f.head:SetText(ns:L("FDQ_DONE_FMT"):format(n.done, n.total))
		for _, sec in ipairs(SECTIONS) do
			local st = sec[1]
			if n[st] > 0 then
				nsec = nsec + 1
				local h = f.secs[nsec]
				if not h then
					h = f.child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
					h:SetJustifyH("LEFT")
					f.secs[nsec] = h
					f._mhNewFs = true
				end
				h:ClearAllPoints()
				h:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -y)
				h:SetWidth(width)
				h:SetText(("%s (%d)"):format(ns:L(sec[2]), n[st]))
				h:Show()
				y = y + math.max(14, h:GetStringHeight() or 14) + 6
				for _, it in ipairs(list) do
					if it.st == st then
						it.key = key
						i = i + 1
						local r = Row(f, i)
						local e = it.e
						r.text:SetWidth(textW)
						r.sub:SetWidth(textW)
						local tag = e.classes and (" |cff9d9d9d(" .. ns:L("FDQ_CLASS") .. ")|r") or ""
						r.text:SetText((COLORS[st] or "") .. Title(e.q, e.en) .. "|r" .. tag)
						r.sub:SetText(Where(it))
						if st == "now" and e.m then
							r.go.e = e
							r.go:SetText(ns:L("FOV_GO_SHORT"))
							r.go:Show()
						else
							r.go.e = nil
							r.go:Hide()
						end
						local rh = (r.text:GetStringHeight() or 14) + 2 + (r.sub:GetStringHeight() or 12)
						rh = math.max(rh, r.go:IsShown() and 22 or 0)
						r:ClearAllPoints()
						r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 8, -y)
						r:SetSize(width - 8, rh)
						r:Show()
						y = y + rh + ROW_GAP
					end
				end
				y = y + 6
			end
		end
	end
	for k = nsec + 1, #f.secs do
		f.secs[k]:Hide()
	end
	for k = i + 1, #(f.rows or {}) do
		f.rows[k]:Hide()
	end
	f.child:SetHeight(math.max(10, y))
	-- New strings this fill: give them the Forever skin font now and lay out once more (same as the boss guide).
	if f._mhNewFs and not f._mhRefill and S and S.SkinWindow then
		f._mhNewFs = nil
		f._mhRefill = true
		S.SkinWindow(f, f.title)
		Fill()
		f._mhRefill = nil
		return
	end
	f._mhNewFs = nil
end

--- Open the quest list of one dungeon (key from ForeverDungeons.lua).
function ns.ShowForeverDungeonQuests(key)
	local f = Build()
	if f:IsShown() and shownKey == key then
		f:Hide()
		return
	end
	if shownKey ~= key then
		f.scroll:SetVerticalScroll(0)
	end
	shownKey = key
	f:Show()
	Fill()
	if C_Timer and C_Timer.After then
		-- The skin's late pass (ForeverStyle.lua SkinOnShow: 0.1 s) sets fonts again; measure once more after it.
		C_Timer.After(0.25, function()
			if win and win:IsShown() then
				Fill()
			end
		end)
	end
end

-- Quest titles arrive late, the log changes, a quest is handed in: refill an open window (at most every 0.5 s).
local ev = CreateFrame("Frame")
local pending = false
local function Later()
	if pending or not (win and win:IsShown()) then
		return
	end
	pending = true
	C_Timer.After(0.5, function()
		pending = false
		Fill()
	end)
end
for _, e in ipairs({ "QUEST_DATA_LOAD_RESULT", "QUEST_LOG_UPDATE", "QUEST_TURNED_IN", "QUEST_ACCEPTED" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", Later)

--- /mh dungeons quests [key|check [key]]: open, or print what MH decides per quest and why.
function ns.ForeverDungeonQuestsSlash(arg)
	arg = (arg or ""):lower()
	local check = arg:match("^check") ~= nil
	local key = (arg:gsub("^check%s*", "")):upper()
	if key == "" then
		-- The dungeon you stand in, else the first that fits your level and has quests.
		local here = ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()
		local ok, l = false, nil
		if ns.ForeverDungeonList then
			ok, l = pcall(ns.ForeverDungeonList)
		end
		for _, d in ipairs(ok and l or {}) do
			if Data()[d.key] and ((here and d.instance == here) or (not here and (d.state == "fit" or d.state == "near"))) then
				key = d.key
				break
			end
		end
	end
	if key == "" or not Data()[key] then
		local keys = {}
		for k in pairs(Data()) do
			keys[#keys + 1] = k
		end
		table.sort(keys)
		print(PREFIX .. ("dungeon quests: no dungeon chosen or no list for %q. Keys: %s"):format(key, table.concat(keys, " ")))
		return
	end
	if not check then
		ns.ShowForeverDungeonQuests(key)
		return
	end
	local list, n = Collect(key)
	local side = UnitFactionGroup and UnitFactionGroup("player")
	local class = UnitClass and select(2, UnitClass("player"))
	print(PREFIX .. ("dungeon quests %s (%s): %d in the data, %d for you (%s, %s): now %d, log %d, inside %d, later %d, done %d")
		:format(key, DungeonName(key), #Data()[key], n.total, tostring(side), tostring(class), n.now, n.log, n.inside, n.later,
			n.done))
	for _, it in ipairs(list) do
		local e = it.e
		print(("  %s %d %s: %s%s"):format(it.st or "skip", e.q, Title(e.q, e.en), it.why,
			e.m and (" · map %d %.1f,%.1f"):format(e.m, e.x, e.y) or ""))
	end
end
