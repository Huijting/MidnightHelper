local _, ns = ...

--[[
	Midnight Helper — "My gear: what now?" (/mh gear, and a line in the character side panel).

	Rob, 19 Oct 2026, about Carola: "ik doe delves, ik doe dit… maar ik ga niet omhoog met mijn gear". He asked for the
	Codex card (CODEX_GEARSTEPS_BODY) AND a window that reads her own state, "super beginners … in jip en janneke en met
	babystapjes". Facts: docs/GEARING_FACTS_2026-10-19.md (two research rounds).

	What it reads, all from the client:
	  • each equipped item's track and step (C_Item.GetItemUpgradeInfo, as TrackCeiling.lua does);
	  • the crest balance per track (ns.MH_GetTierCrest, the same numbers as the Crests guide);
	  • the crest's own description, which lists where it comes from in the player's language.

	⚠️ TRACK → CREST without comparing to English. trackString is localised ("Champion", "Held", …) and so is the crest's
	name ("Champion Mistcrest"); in one client both come from the same language, so we match the track word inside the
	crest name. A match is remembered by the numeric trackStringID (ns.db.gearLadder.trackKey) so a later read without
	a name still finds it. A track we cannot match shows its steps and no crest advice — never a guessed crest.

	📌 Costs: 20 crests per step (MEASURED, ItemExtendedCost 11457–11481). The slot discount ("cheaper or free if you
	had a higher item there") is real but not readable here, so the window says "about" and lets the NPC show the price.
]]

local STEP_COST = 20
local ORDER = { "adventurer", "veteran", "champion", "hero", "myth" }

local panel
local PAD, WIDTH, GAP = 14, 380, 3

local function L(key)
	return (ns.L and ns:L(key)) or key
end

local function DB()
	ns.db = ns.db or {}
	ns.db.gearLadder = ns.db.gearLadder or {}
	ns.db.gearLadder.trackKey = ns.db.gearLadder.trackKey or {}
	return ns.db.gearLadder
end

local SLOT_KEYS = {
	[1] = "HEADSLOT", [2] = "NECKSLOT", [3] = "SHOULDERSLOT", [5] = "CHESTSLOT", [6] = "WAISTSLOT",
	[7] = "LEGSSLOT", [8] = "FEETSLOT", [9] = "WRISTSLOT", [10] = "HANDSSLOT", [11] = "FINGER0SLOT",
	[12] = "FINGER1SLOT", [13] = "TRINKET0SLOT", [14] = "TRINKET1SLOT", [15] = "BACKSLOT",
	[16] = "MAINHANDSLOT", [17] = "SECONDARYHANDSLOT",
}

local function SlotName(slot)
	local k = SLOT_KEYS[slot]
	return (k and _G[k]) or ("Slot " .. tostring(slot))
end

local function CrestInfo(key)
	local qty, id = 0, nil
	if ns.MH_GetTierCrest then
		qty, id = ns.MH_GetTierCrest(key)
	end
	local name, desc
	if id and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
		local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
		if ok and type(info) == "table" then
			name, desc = info.name, info.description
		end
	end
	return tonumber(qty) or 0, name, desc
end

--- Which tier key ("champion" …) a track belongs to, or nil.
local function TrackKey(trackID, trackName, crestNames)
	local db = DB()
	if trackID and db.trackKey[trackID] then
		return db.trackKey[trackID]
	end
	if type(trackName) == "string" and trackName ~= "" then
		local low = trackName:lower()
		for _, key in ipairs(ORDER) do
			local n = crestNames[key]
			if type(n) == "string" and n:lower():find(low, 1, true) then
				if trackID then
					db.trackKey[trackID] = key
				end
				return key
			end
		end
	end
	return nil
end

--- Read the gear. Returns groups (one per track, low to high), readable count.
local function ReadGear()
	local crestNames, crests = {}, {}
	for _, key in ipairs(ORDER) do
		local qty, name, desc = CrestInfo(key)
		crestNames[key] = name
		crests[key] = { qty = qty, name = name, desc = desc }
	end
	local groups, byKey, unknown = {}, {}, {}
	local readable = 0
	if not (GetInventoryItemLink and C_Item and C_Item.GetItemUpgradeInfo) then
		return groups, 0, crests, unknown
	end
	for slot = (INVSLOT_FIRST_EQUIPPED or 1), (INVSLOT_LAST_EQUIPPED or 17) do
		local link = GetInventoryItemLink("player", slot)
		if link then
			local ok, info = pcall(C_Item.GetItemUpgradeInfo, link)
			if ok and type(info) == "table" then
				local cur, max = tonumber(info.currentLevel), tonumber(info.maxLevel)
				if cur and max and max > 0 then
					readable = readable + 1
					local key = TrackKey(tonumber(info.trackStringID), info.trackString, crestNames)
					local item = { slot = slot, cur = cur, max = max, open = math.max(0, max - cur) }
					if key then
						local g = byKey[key]
						if not g then
							g = { key = key, name = info.trackString, items = {}, open = 0 }
							byKey[key] = g
						end
						g.items[#g.items + 1] = item
						g.open = g.open + item.open
					else
						item.trackName = info.trackString
						unknown[#unknown + 1] = item
					end
				end
			end
		end
	end
	for _, key in ipairs(ORDER) do
		if byKey[key] then
			groups[#groups + 1] = byKey[key]
		end
	end
	return groups, readable, crests, unknown
end

local function EnsurePanel()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperGearLadder", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 200)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true, tileSize = 32, edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.06, 0.06, 0.1, 0.95)
	end
	tinsert(UISpecialFrames, f:GetName())
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
	f._lines = {}
	f:SetScript("OnEvent", function()
		if f:IsShown() then
			ns.RefreshGearLadder()
		end
	end)
	for _, e in ipairs({ "PLAYER_EQUIPMENT_CHANGED", "CURRENCY_DISPLAY_UPDATE" }) do
		pcall(f.RegisterEvent, f, e)
	end
	panel = f
	return f
end

function ns.RefreshGearLadder()
	local f = panel
	if not (f and f:IsShown()) then
		return
	end
	for _, fs in ipairs(f._lines) do
		fs:Hide()
	end
	local y, n = -PAD, 0
	local function Add(text, r, g, b, template, gap)
		n = n + 1
		local fs = f._lines[n]
		if not fs then
			fs = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			fs:SetJustifyH("LEFT")
			fs:SetWordWrap(true)
			f._lines[n] = fs
		end
		local tpl = template or "GameFontHighlight"
		if ns.MHScalableFont then
			fs:SetFontObject(ns.MHScalableFont(tpl))
		end
		fs:ClearAllPoints()
		fs:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, y)
		fs:SetPoint("RIGHT", f, "RIGHT", -PAD - (n == 1 and 18 or 0), 0)
		fs:SetTextColor(r, g, b)
		fs:SetText(text)
		fs:Show()
		y = y - (fs:GetStringHeight() or 14) - GAP - (gap or 0)
	end

	Add(L("GEARLADDER_TITLE"), 1, 0.9, 0.55, "GameFontNormal", 4)
	if GetAverageItemLevel then
		local _, equipped = GetAverageItemLevel()
		if equipped then
			Add((L("GEARLADDER_ILVL_FMT")):format(math.floor(equipped + 0.5)), 0.85, 0.85, 0.85, nil, 6)
		end
	end

	local groups, readable, crests, unknown = ReadGear()
	if readable == 0 then
		Add(L("GEARLADDER_UNREADABLE"), 0.85, 0.7, 0.35)
		f:SetHeight(math.abs(y) + PAD)
		return
	end

	-- Step 1: what you can do right now — crests you hold for items that can still go up.
	Add(L("GEARLADDER_NOW_HEAD"), 1, 0.82, 0.2, nil, 2)
	local anyNow = false
	for _, g in ipairs(groups) do
		local c = crests[g.key]
		local steps = math.floor((c and c.qty or 0) / STEP_COST)
		local trackName = g.name or g.key
		local line = (L("GEARLADDER_TRACK_FMT")):format(trackName, #g.items, g.open, c and c.qty or 0)
		if g.open == 0 then
			Add("• " .. line .. " " .. L("GEARLADDER_TRACK_FULL"), 0.7, 0.7, 0.7)
		elseif steps > 0 then
			anyNow = true
			Add("• " .. line, 0.45, 0.9, 0.45)
			Add("    " .. (L("GEARLADDER_CAN_NOW_FMT")):format(math.min(steps, g.open)), 0.45, 0.9, 0.45)
		else
			Add("• " .. line, 0.9, 0.9, 0.9)
			Add("    " .. (L("GEARLADDER_NEED_FMT")):format(STEP_COST - ((c and c.qty or 0) % STEP_COST), trackName), 0.75, 0.75, 0.75)
		end
		-- The slots that can still go up, lowest step first.
		local open = {}
		for _, it in ipairs(g.items) do
			if it.open > 0 then
				open[#open + 1] = it
			end
		end
		table.sort(open, function(a, b) return a.cur < b.cur end)
		if #open > 0 then
			local parts = {}
			for i = 1, math.min(#open, 6) do
				parts[#parts + 1] = ("%s %d/%d"):format(SlotName(open[i].slot), open[i].cur, open[i].max)
			end
			if #open > 6 then
				parts[#parts + 1] = "…"
			end
			Add("    " .. table.concat(parts, ", "), 0.6, 0.6, 0.6, "GameFontHighlightSmall")
		end
	end
	for _, it in ipairs(unknown) do
		Add(("• %s: %s %d/%d"):format(SlotName(it.slot), tostring(it.trackName or "?"), it.cur, it.max), 0.7, 0.7, 0.7)
	end
	if anyNow then
		Add(L("GEARLADDER_WHERE"), 0.45, 0.9, 0.45, nil, 2)
	end
	y = y - 6

	-- Step 2: the next kind of item up — the track one above most of your items — and where its crests come from,
	-- in the game's own words.
	local most, mostN = nil, 0
	for _, g in ipairs(groups) do
		if #g.items > mostN then
			most, mostN = g.key, #g.items
		end
	end
	local nextKey
	for i, key in ipairs(ORDER) do
		if key == most then
			nextKey = ORDER[i + 1]
		end
	end
	if nextKey then
		local c = crests[nextKey]
		Add((L("GEARLADDER_NEXT_HEAD_FMT")):format((c and c.name) or nextKey), 1, 0.82, 0.2, nil, 2)
		if c and type(c.desc) == "string" and c.desc ~= "" then
			local desc = c.desc:gsub("\r", "") -- one value: gsub's count must not become the colour
			Add(desc, 0.75, 0.75, 0.75, "GameFontHighlightSmall", 2)
		end
	end
	Add(L("GEARLADDER_TIPS"), 0.85, 0.85, 0.85, nil, 4)
	Add(L("GEARLADDER_FOOT"), 0.6, 0.6, 0.6, "GameFontHighlightSmall")
	f:SetHeight(math.abs(y) + PAD)
end

function ns.ShowGearLadder()
	local f = EnsurePanel()
	f:Show()
	ns.RefreshGearLadder()
end

function ns.ToggleGearLadder()
	if panel and panel:IsShown() then
		panel:Hide()
		return
	end
	ns.ShowGearLadder()
end
