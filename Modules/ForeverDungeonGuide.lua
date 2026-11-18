local _, ns = ...

--[[
	ForeverDungeonGuide.lua — WoW Forever: who the bosses are, what they do, one tip, and a few items worth knowing.
	Step 1 (18 Nov 2026), Rob via sparring, letterlijk: "Ja bouw maar" (on the advice "A+ in small steps"), and the same
	day: "Zuinig is goed maar het moet wel foutloos 💪".

	Why: Forever has no Dungeon Journal. GEMETEN: the Journal* DB2 tables are absent in 1.60.1.70959 and
	Blizzard_EncounterJournal.toc line 7 allows only "standard, classic" (docs/forever/DUNGEONGIDS_*.md).
	Rob, 14 Nov: MH explains in its own way, it does NOT rebuild the DungeonJournal addon — so: a few lines per boss,
	2-3 items per dungeon, no drop chances (the guides quote Classic chances; Wowhead Forever differs).

	Data: ForeverDungeonGuideData.lua (generated from the mh-research data, every line with its sources; a line with one
	source says so in the text). Boss names per language from DB2 DungeonEncounter; item names from the client.
	Step 1 = the nine dungeons up to level ~32: six classic ones and three new in Forever (Hall of Thanes, Ruins of
	Lordaeron, Excavation Site; Rob: "Die nieuwe dungeons erbij. En dan later nog een keer controleren." — they carry
	`recheck` and say so on top). A second, independent check (docs/forever/DUNGEONGIDS_CONTROLE3_2026-11-18.md) found 9
	errors; all fixed. Plan: step 2 = dungeons 32-60, step 3 = the raids (open 9 Dec), with fresh sources.

	Open it: the "Bosses" button on a dungeon row (overview → Dungeons & group), or /mh bosses. Inside a dungeon it opens
	on that dungeon; targeting a boss marks him (as Midnight's boss window does).
]]

if not ns.IS_FOREVER then
	return
end

local S = ns.ForeverStyle
local W, H, LEFT_W = 640, 470, 170
local win
local selected -- instance map id
local targetNpc -- npc id of your target, when it is a boss of this guide

local function Data()
	return ns.FOREVER_DGUIDE or {}
end

local function Order()
	-- The guide's dungeons in the order of ns.FOREVER_DUNGEONS (level order), each once.
	local out, seen = {}, {}
	for _, d in ipairs(ns.FOREVER_DUNGEONS or {}) do
		if Data()[d.map] and not seen[d.map] then
			seen[d.map] = true
			out[#out + 1] = d
		end
	end
	return out
end

local function DungeonName(d)
	if GetRealZoneText then
		local ok, v = pcall(GetRealZoneText, d.map)
		if ok and type(v) == "string" and v ~= "" then
			return v
		end
	end
	return d.name
end

local function BossName(b)
	local loc = GetLocale and GetLocale()
	return (loc and b.names and b.names[loc]) or b.name
end

local function ItemName(id)
	if C_Item and C_Item.GetItemNameByID then
		local ok, n = pcall(C_Item.GetItemNameByID, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if C_Item and C_Item.RequestLoadItemDataByID then
		pcall(C_Item.RequestLoadItemDataByID, id)
	end
	return nil
end

local function ItemColor(id)
	if C_Item and C_Item.GetItemQualityByID then
		local ok, q = pcall(C_Item.GetItemQualityByID, id)
		if ok and type(q) == "number" and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[q] then
			return ITEM_QUALITY_COLORS[q].hex or "|cffffffff"
		end
	end
	return "|cffffffff"
end

--- The whole text for one dungeon (one font string: simple, and it wraps).
function ns.ForeverDungeonGuideText(map)
	local g = Data()[map]
	if not g then
		return ns:L("FDG_NONE")
	end
	local parts = {}
	local byNpc = {}
	local recheck = g.recheck
	for _, b in ipairs(g.bosses or {}) do
		-- A boss without a known npc id (Ruins of Lordaeron's captain) has no entry here; the offline test found that
		-- `byNpc[nil] = b` broke the whole page (18 Nov 2026).
		if b.npc then
			byNpc[b.npc] = b
		end
		recheck = recheck or b.recheck
	end
	-- A dungeon that is new in Forever: sources are thin, Rob wants it checked again later ("En dan later nog een keer
	-- controleren", 18 Nov 2026) — say so on top instead of sounding surer than we are.
	if recheck then
		parts[#parts + 1] = "|cffeeb055" .. ns:L("FDG_RECHECK") .. "|r"
		parts[#parts + 1] = " "
	end
	for i, b in ipairs(g.bosses or {}) do
		-- extraNpc: Sneed's Shredder marks Sneed too (second check, 18 Nov 2026).
		local here = targetNpc and (targetNpc == b.npc or (b.extraNpc ~= nil and targetNpc == b.extraNpc))
		local head = ("%d. %s"):format(i, BossName(b))
		if b.rare then
			head = head .. "  |cff9d9d9d" .. ns:L("FDG_RARE") .. "|r"
		end
		if here then
			head = "|cff66ff66> " .. head .. "  " .. ns:L("FDG_TARGET") .. "|r"
		else
			head = "|cffdbb56b" .. head .. "|r"
		end
		parts[#parts + 1] = head
		for _, k in ipairs(b.does or {}) do
			parts[#parts + 1] = "   " .. ns:L(k)
		end
		if b.tip then
			parts[#parts + 1] = "   |cffeeb055" .. ns:L("FDG_TIP") .. "|r " .. ns:L(b.tip)
		end
		if b.one then
			parts[#parts + 1] = "   |cff9d9d9d" .. ns:L("FDG_ONE_SOURCE") .. "|r"
		end
		parts[#parts + 1] = " "
	end
	if g.loot and #g.loot > 0 then
		parts[#parts + 1] = "|cffdbb56b" .. ns:L("FDG_LOOT_HEAD") .. "|r"
		for _, l in ipairs(g.loot) do
			local name = ItemName(l.item)
			local boss = byNpc[l.boss]
			parts[#parts + 1] = ("   %s%s|r  %s"):format(ItemColor(l.item), name or ("#" .. l.item), ns:L(l.role))
				.. (boss and ("  |cff9d9d9d" .. ns:L("FDG_FROM_FMT"):format(BossName(boss)) .. "|r") or "")
		end
		parts[#parts + 1] = "|cff9d9d9d" .. ns:L("FDG_LOOT_NOTE") .. "|r"
	end
	return table.concat(parts, "\n")
end

local Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDungeonGuide", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
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
	f.title:SetText(ns:L("FDG_TITLE"))
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	f.btns = {}
	for i, d in ipairs(Order()) do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(LEFT_W, 24)
		b:SetPoint("TOPLEFT", 18, -50 - (i - 1) * 28)
		b.map = d.map
		b:SetText(DungeonName(d))
		b:SetScript("OnClick", function(self)
			selected = self.map
			Fill()
		end)
		f.btns[i] = b
	end
	local rx = 18 + LEFT_W + 14
	f.head = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.head:SetPoint("TOPLEFT", rx, -52)
	f.head:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.head:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", rx, -76)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -36, 40)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - rx - 44, 10)
	scroll:SetScrollChild(child)
	f.body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOPLEFT", 0, 0)
	f.body:SetWidth(W - rx - 50)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	if f.body.SetSpacing then
		f.body:SetSpacing(3)
	end
	f.scroll, f.child = scroll, child
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 20, 16)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")
	f.hint:SetText(ns:L("FDG_HINT"))
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
	if not (f and f:IsShown()) then
		return
	end
	local order = Order()
	if not selected or not Data()[selected] then
		local here = ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()
		selected = (here and Data()[here] and here) or (order[1] and order[1].map)
	end
	for _, b in ipairs(f.btns) do
		b:SetEnabled(b.map ~= selected)
	end
	local d
	for _, x in ipairs(order) do
		if x.map == selected then
			d = x
		end
	end
	f.head:SetText(d and ("%s  |cff9d9d9d%d-%d|r"):format(DungeonName(d), d.min or 0, d.max or 0) or "")
	f.body:SetText(selected and ns.ForeverDungeonGuideText(selected) or ns:L("FDG_NONE"))
	f.child:SetHeight(math.max(10, (f.body:GetStringHeight() or 0) + 10))
end

--- Open the guide, on `map` when given (a dungeon row's button), else on where you are.
function ns.ShowForeverDungeonGuide(map)
	local f = Build()
	if map and Data()[map] then
		selected = map
	end
	if f:IsShown() and not map then
		f:Hide()
		return
	end
	f:Show()
	Fill()
end

--- Is there a guide for this instance map? (the overview shows the button only then)
function ns.ForeverDungeonHasGuide(map)
	return map ~= nil and Data()[map] ~= nil
end

-- Targeting a boss of this guide marks him; entering a dungeon selects it. Both only refill an open window.
local function NpcOf(unit)
	if not (UnitGUID and UnitExists and UnitExists(unit)) then
		return nil
	end
	local ok, guid = pcall(UnitGUID, unit)
	if not ok or type(guid) ~= "string" or (issecretvalue and issecretvalue(guid)) then
		return nil
	end
	local kind, _, _, _, _, id = strsplit("-", guid)
	if kind == "Creature" or kind == "Vehicle" then
		return tonumber(id)
	end
	return nil
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_TARGET_CHANGED" then
		local id = NpcOf("target")
		local found
		for map, g in pairs(Data()) do
			for _, b in ipairs(g.bosses or {}) do
				if id and (b.npc == id or b.extraNpc == id) then
					found = map
				end
			end
		end
		targetNpc = found and id or nil
		if found then
			selected = found
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		local here = ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()
		if here and Data()[here] then
			selected = here
		end
	end
	if win and win:IsShown() then
		Fill()
	end
end)

--- /mh bosses: open the guide; /mh bosses check: what MH has (a quiet module needs a way to see why).
function ns.ForeverDungeonGuideSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		local P = "|cffffcc00Midnight Helper:|r "
		local nB, nL = 0, 0
		for _, g in pairs(Data()) do
			nB = nB + #(g.bosses or {})
			nL = nL + #(g.loot or {})
		end
		print(P .. ("boss guide: %d dungeons, %d bosses, %d items; you are in map %s; target npc %s"):format(#Order(), nB,
			nL, tostring(ns.ForeverCurrentDungeonMap and ns.ForeverCurrentDungeonMap()), tostring(NpcOf("target"))))
		return
	end
	ns.ShowForeverDungeonGuide()
end
