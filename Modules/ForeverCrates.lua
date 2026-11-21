local _, ns = ...

--[[
	ForeverCrates.lua — WoW Forever: Waylaid Crates.
	Rob, 21 Nov 2026 (via sparring): "Waylaid crates zijn het ... wat zijn dat? En ik denk dat wij er ook iets mee moeten."
	On the options (advice: the middle one), verbatim: "Ja doe maar".

	What a Waylaid Crate is (GEMETEN in Forever DB2 1.60.1.71037 + the Wowhead Forever item tooltips, tools/forever_crates.py):
	an empty crate (248549, "Read the label") becomes a typed crate (248682-248699 raw goods, 248702-248713 crafted goods)
	that you fill with ONE bundle from its list. Filled, it becomes a Sealed crate (248765-248779) that you deliver to your
	side's trade representative: Marcy Baker (Alliance, Redridge Mountains) or Dokimi (Horde, The Barrens) — NPC tooltips
	GEMETEN, names per client language GEMETEN on Wowhead (fr Marcy Fournier, pt Márcia Barreto, ru Марси Бейкер).
	Neither HandyNotes_WoWForever nor Zygor Forever has them (grep, with a positive control on Zygor's 214101).
	From the sparring's mh-research report (Wowhead quest pages + conquestcapped, NOT measured by MH): a crafted-goods crate
	seals green (DB2: the crafted crates and 248770-248774 are quality 2, GEMETEN) and gives double Merchant's Favor; the
	first Shipping Label (quest 98247 A / 98248 H) gives 50 Favor, 2000 reputation and XP once.

	1. Tooltip on a typed crate: every bundle it takes and how many you have (bags + bank, GetItemCount).
	2. A sealed crate or a Shipping Label in your bags: where to deliver it, in its tooltip; and when one arrives, a small
	   window with a "Show the way" button (never in combat; the same door for /mh crates test).
	3. The first-label tip while the quest is not done.
	4. Find -> In town -> "Deliver crates" (ForeverVendors.lua category "crates"), with your Favor and rank on top.
	Switch in Quiet helpers (FCRATE_SW), on by default. /mh crates prints what MH sees and saves every crate's tooltip lines
	to MidnightHelperDB.crateProbe (to measure the fill progress the game shows).
	ForeverLevelingGuide has a crate module (no licence = all rights reserved): nothing taken from it, not opened.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local EMPTY = 248549
local LABELS = { [280179] = "A", [280180] = "H" }
local FIRST_QUEST = { A = 98247, H = 98248 }
local FAVOR = 3402
local FACTION = { A = 2586, H = 2587 }
local OK_ICON = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t"
local NO_ICON = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t"
local last = "nothing hovered yet"

-- The two trade representatives (Wowhead Forever NPC tooltips, 21 Nov 2026). Redridge 9.6,71: a Forever NPC, so the
-- Forever map frame (AFGELEID: the old-frame shift of ForeverRepairData only hits old Classic NPCs).
local NAMES = {
	[256390] = { frFR = "Marcy Fournier", ptBR = "Márcia Barreto", ruRU = "Марси Бейкер" },
	[256386] = { ruRU = "Докими" },
}
local TAGS = { enUS = "Inventory Intake", enGB = "Inventory Intake", deDE = "Warenaufnahme",
	frFR = "Récupération d'inventaire", esES = "Recepción de inventarios", esMX = "Admisión de suministros",
	ptBR = "Entrada de Inventário", itIT = "Inventory Intake", ruRU = "Прием предметов" }
do
	local loc = GetLocale and GetLocale() or "enUS"
	local function N(npc, en)
		return (NAMES[npc] and NAMES[npc][loc]) or en
	end
	ns.FOREVER_CRATE_SPOTS = {
		{ kind = "crates", npc = 256390, name = N(256390, "Marcy Baker"), tag = TAGS[loc], side = "A", map = 1433, x = 9.6, y = 71.0 },
		{ kind = "crates", npc = 256386, name = N(256386, "Dokimi"), tag = TAGS[loc], side = "H", map = 1413, x = 50.0, y = 29.2 },
	}
end

local function Settings()
	ns.db = ns.db or {}
	ns.db.foreverCrates = type(ns.db.foreverCrates) == "table" and ns.db.foreverCrates or {}
	local s = ns.db.foreverCrates
	if s.on == nil then
		s.on = true
	end
	return s
end

function ns.IsForeverCratesOn()
	return Settings().on ~= false
end

function ns.SetForeverCrates(on)
	Settings().on = on and true or false
end

local function Secret(v)
	return issecretvalue and issecretvalue(v)
end

local function Side()
	local f = UnitFactionGroup and UnitFactionGroup("player")
	return (f == "Alliance" and "A") or (f == "Horde" and "H") or nil
end

local function Count(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return nil
	end
	local ok, n = pcall(fn, id, true) -- true = with the bank (the bank is known once you opened it)
	if ok and type(n) == "number" and not Secret(n) then
		return n
	end
	return nil
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

--- The client's name of Merchant's Favor and how much you have (nil, nil when the client does not answer).
local function Favor()
	if ns.ForeverCurrencyViews then
		local ok, list = pcall(ns.ForeverCurrencyViews)
		for _, c in ipairs(ok and list or {}) do
			if c.id == FAVOR and not c.unreadable then
				return c.name, c.qty
			end
		end
	end
	return nil, nil
end

--- Your side's trade group: name, rank word (both from the client) or nil.
local function Rep()
	local side = Side()
	if not (side and ns.ForeverRepViews) then
		return nil
	end
	local ok, list = pcall(ns.ForeverRepViews)
	for _, e in ipairs(ok and list or {}) do
		if e.id == FACTION[side] then
			return e.name, e.rank, e.have, e.need
		end
	end
	return nil
end

local function FirstDone()
	local side = Side()
	local f = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted
	if not (side and f) then
		return nil
	end
	local ok, done = pcall(f, FIRST_QUEST[side])
	if ok and type(done) == "boolean" then
		return done
	end
	return nil
end

local function Distance(yards)
	if not yards then
		return ns:L("FVEND_OTHER_CONT")
	end
	yards = math.floor(yards + 0.5)
	return ns.ForeverTrainerDistance and ns.ForeverTrainerDistance(yards) or ("%d yd"):format(yards)
end

--- Your side's representative from the Find list: row { name, zone, dist, go } or nil.
local function Nearest()
	if not ns.ForeverVendorFindRows then
		return nil
	end
	local ok, rows = pcall(ns.ForeverVendorFindRows, "crates")
	return ok and type(rows) == "table" and rows[1] or nil
end

function ns.ForeverCratesGo()
	local r = Nearest()
	if r and r.go then
		return r.go()
	end
	print(PREFIX .. ns:L("FCRATE_NONE"))
	return false
end

local function DeliverLine()
	local r = Nearest()
	if not r then
		return ns:L("FCRATE_NONE")
	end
	return ns:L("FCRATE_DELIVER_FMT"):format(tostring(r.name), tostring(r.zone), Distance(r.dist), ns:L("FOV_TAB_FIND"),
		ns:L("FCITY_CAT_CRATES"))
end

local function FirstLine()
	if FirstDone() ~= false then
		return nil
	end
	local fname = Favor()
	return ns:L("FCRATE_FIRST_FMT"):format(fname or "Merchant's Favor")
end

--- The extra tooltip lines for an item id: list of { text, r, g, b } and the reason (for /mh crates).
local function Lines(id)
	local out = {}
	local crate = ns.FOREVER_CRATES and ns.FOREVER_CRATES[id]
	if crate then
		out[#out + 1] = { ns:L("FCRATE_TIP_HEAD"), 1, 0.82, 0 }
		local any = false
		for _, b in ipairs(crate.b or {}) do
			local need, item = b[1], b[2]
			local have = Count(item)
			local name = ItemName(item) or ("item " .. item)
			local enough = have and have >= need
			any = any or enough
			local mark = (have == nil and "") or (enough and (" " .. OK_ICON)) or (" " .. NO_ICON)
			out[#out + 1] = { ns:L("FCRATE_ROW_FMT"):format(need, name, have or 0) .. mark,
				enough and 0.4 or 0.85, enough and 1 or 0.85, enough and 0.4 or 0.85 }
		end
		local fname = Favor() or "Merchant's Favor"
		if crate.quality == 2 then
			out[#out + 1] = { ns:L("FCRATE_CRAFTED_FMT"):format(fname), 0.3, 1, 0.3 }
		else
			out[#out + 1] = { ns:L("FCRATE_RAW_FMT"):format(fname), 0.7, 0.7, 0.7 }
		end
		return out, ("typed crate %d: %d bundles, %s"):format(id, #(crate.b or {}), any and "one is complete" or "none complete")
	end
	if id == EMPTY then
		out[#out + 1] = { ns:L("FCRATE_EMPTY"), 1, 0.82, 0 }
		return out, "empty crate"
	end
	local sealed = ns.FOREVER_CRATES_SEALED and ns.FOREVER_CRATES_SEALED[id]
	if sealed or LABELS[id] then
		out[#out + 1] = { DeliverLine(), 1, 0.82, 0 }
		if LABELS[id] then
			local first = FirstLine()
			if first then
				out[#out + 1] = { first, 0.4, 0.8, 1 }
			end
		end
		return out, (sealed and "sealed crate %d" or "shipping label %d"):format(id)
	end
	return nil, "not a crate"
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType
	and Enum.TooltipDataType.Item then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		if not (tooltip == GameTooltip or tooltip == ItemRefTooltip) then
			return
		end
		local ok, err = pcall(function()
			local id = type(data) == "table" and data.id
			if type(id) ~= "number" or Secret(id) then
				return
			end
			local lines, why = Lines(id)
			if not lines then
				return
			end
			if not ns.IsForeverCratesOn() then
				last = ("item %d: %s, but switched off (Quiet helpers)"):format(id, why)
				return
			end
			last = ("item %d: %s"):format(id, why)
			for _, l in ipairs(lines) do
				tooltip:AddLine(l[1], l[2], l[3], l[4], true)
			end
			tooltip:Show()
		end)
		if not ok then
			last = "error: " .. tostring(err)
		end
	end)
else
	last = "this client has no TooltipDataProcessor: the lines cannot be added"
end

--------------------------------------------------------------------------------
-- The window when a sealed crate or a Shipping Label arrives in your bags.
--------------------------------------------------------------------------------
local win
local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverCrates", UIParent, "BackdropTemplate")
	f:SetSize(460, 150)
	f:SetPoint("CENTER", 0, 180)
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
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.big = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.big:SetPoint("TOPLEFT", 36, -20)
	f.big:SetPoint("TOPRIGHT", -36, -20)
	f.big:SetJustifyH("CENTER")
	f.where = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.where:SetPoint("TOPLEFT", f.big, "BOTTOMLEFT", 0, -8)
	f.where:SetPoint("TOPRIGHT", f.big, "BOTTOMRIGHT", 0, -8)
	f.where:SetJustifyH("CENTER")
	f.first = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.first:SetPoint("TOPLEFT", f.where, "BOTTOMLEFT", 0, -6)
	f.first:SetPoint("TOPRIGHT", f.where, "BOTTOMRIGHT", 0, -6)
	f.first:SetJustifyH("CENTER")
	f.first:SetTextColor(0.4, 0.8, 1)
	f.btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.btn:SetSize(170, 24)
	f.btn:SetPoint("BOTTOM", f, "BOTTOM", 0, 18)
	f.btn:SetText(ns:L("FVEND_TIP_WAY"))
	f.btn:SetScript("OnClick", function()
		ns.ForeverCratesGo()
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Show(id, isTest)
	local f = Build()
	local name = ItemName(id) or ("item " .. id)
	local big = ns:L("FCRATE_WIN_FMT"):format(name)
	f.big:SetText(isTest and (big .. " (test)") or big)
	local r = Nearest()
	if r then
		f.where:SetText(ns:L("FCRATE_WIN_WHERE_FMT"):format(tostring(r.name), tostring(r.zone), Distance(r.dist)))
		f.btn:Enable()
	else
		f.where:SetText(ns:L("FCRATE_NONE"))
		f.btn:Disable()
	end
	f.first:SetText(LABELS[id] and FirstLine() or "")
	f:Show()
end

--- Every sealed crate and label in your bags: { [id] = count } and the total.
local function Deliverables()
	local out, total = {}, 0
	local ids = {}
	for id in pairs(ns.FOREVER_CRATES_SEALED or {}) do
		ids[#ids + 1] = id
	end
	for id in pairs(LABELS) do
		ids[#ids + 1] = id
	end
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	for _, id in ipairs(ids) do
		local ok, n = false, nil
		if fn then
			ok, n = pcall(fn, id) -- bags only: a crate that arrives arrives in your bags
		end
		if ok and type(n) == "number" and not Secret(n) and n > 0 then
			out[id] = n
			total = total + n
		end
	end
	return out, total
end

local seen -- counts at the last check; nil until the first check after login (that one only sets the baseline)
local pending -- an id that arrived in combat
local arrivalWhy = "no check yet"

local function Check(event)
	local now = Deliverables()
	if not seen then
		seen = now
		arrivalWhy = event .. ": baseline set"
		return
	end
	local new
	for id, n in pairs(now) do
		if n > (seen[id] or 0) then
			new = id
		end
	end
	seen = now
	if not new then
		arrivalWhy = event .. ": nothing new to deliver"
		return
	end
	if not ns.IsForeverCratesOn() then
		arrivalWhy = ("%s: item %d arrived, but switched off (Quiet helpers)"):format(event, new)
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		pending = new
		arrivalWhy = ("%s: item %d arrived in combat: waits for the fight to end"):format(event, new)
		return
	end
	Show(new)
	arrivalWhy = ("%s: item %d arrived: window shown"):format(event, new)
end

local ev = CreateFrame("Frame")
pcall(ev.RegisterEvent, ev, "BAG_UPDATE_DELAYED")
pcall(ev.RegisterEvent, ev, "PLAYER_ENTERING_WORLD")
pcall(ev.RegisterEvent, ev, "PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" then
		if pending then
			local id = pending
			pending = nil
			if ns.IsForeverCratesOn() then
				pcall(Show, id)
				arrivalWhy = ("after the fight: item %d: window shown"):format(id)
			end
		end
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(3, function()
			pcall(Check, "login / loading screen")
		end)
		return
	end
	pcall(Check, "bags changed")
end)

--------------------------------------------------------------------------------
-- Find (ForeverOverview.lua): the line on top of "Deliver crates".
--------------------------------------------------------------------------------
function ns.ForeverCrateFindSub()
	local parts = {}
	local fname, fqty = Favor()
	if fname and fqty then
		parts[#parts + 1] = ("%s: %d"):format(fname, fqty)
	end
	local rname, rank, have, need = Rep()
	if rname and rank then
		parts[#parts + 1] = ("%s: %s%s"):format(rname, rank, (have and need) and (" %d/%d"):format(have, need) or "")
	end
	local first = FirstLine()
	if first then
		parts[#parts + 1] = first
	end
	return table.concat(parts, " · ")
end

--------------------------------------------------------------------------------
-- /mh crates [test|on|off]
--------------------------------------------------------------------------------
local function TipLines(bag, slot)
	if not (C_TooltipInfo and C_TooltipInfo.GetBagItem) then
		return { "C_TooltipInfo.GetBagItem missing" }
	end
	local ok, d = pcall(C_TooltipInfo.GetBagItem, bag, slot)
	if not ok or type(d) ~= "table" or type(d.lines) ~= "table" then
		return { "no tooltip data" }
	end
	local out = {}
	for _, l in ipairs(d.lines) do
		local t = l.leftText
		if type(t) == "string" and not Secret(t) then
			out[#out + 1] = t .. ((type(l.rightText) == "string" and not Secret(l.rightText) and l.rightText ~= "")
				and (" | " .. l.rightText) or "")
		end
	end
	return out
end

function ns.ForeverCratesSlash(arg)
	local s = Settings()
	if arg == "on" or arg == "off" then
		s.on = arg == "on"
		print(PREFIX .. ns:L(s.on and "FCRATE_ON" or "FCRATE_OFF"))
		return
	end
	if arg == "test" then
		local now = Deliverables()
		local id = next(now) or (Side() == "H" and 280180 or 280179)
		Show(id, true)
		return
	end
	print(PREFIX .. ("Waylaid Crates: help %s. Tooltip: %s. Arrival: %s"):format(s.on and "on" or "off", last, arrivalWhy))
	local fname, fqty = Favor()
	print(("   currency %d: %s"):format(FAVOR, fname and ("%s = %s"):format(fname, tostring(fqty)) or "the client gave nothing"))
	local rname, rank, have, need = Rep()
	print(("   trade group: %s"):format(rname and ("%s, %s %s/%s"):format(rname, tostring(rank), tostring(have),
		tostring(need)) or "the client gave nothing (or no side)"))
	local fd = FirstDone()
	print(("   first Shipping Label quest %s: %s"):format(tostring(FIRST_QUEST[Side() or "A"]),
		fd == nil and "cannot be read" or (fd and "done" or "not done yet")))
	local r = Nearest()
	print("   deliver: " .. (r and ("%s, %s, %s"):format(tostring(r.name), tostring(r.zone), Distance(r.dist)) or "none known"))
	-- Every crate in your bags, with its own tooltip lines (to measure what the game shows about filling).
	local probe = { at = date and date("%Y-%m-%d %H:%M") or "?", items = {} }
	local n = 0
	local numSlots = C_Container and C_Container.GetContainerNumSlots
	local getId = C_Container and C_Container.GetContainerItemID
	if numSlots and getId then
		for bag = 0, 4 do
			for slot = 1, numSlots(bag) or 0 do
				local id = getId(bag, slot)
				if id and (id == EMPTY or LABELS[id] or (ns.FOREVER_CRATES and ns.FOREVER_CRATES[id])
					or (ns.FOREVER_CRATES_SEALED and ns.FOREVER_CRATES_SEALED[id])) then
					n = n + 1
					local lines = TipLines(bag, slot)
					probe.items[#probe.items + 1] = { id = id, bag = bag, slot = slot, lines = lines }
					print(("   bag %d slot %d: %s (%d)"):format(bag, slot, ItemName(id) or "?", id))
					local mine = Lines(id)
					for _, l in ipairs(mine or {}) do
						print("      " .. l[1])
					end
				end
			end
		end
	end
	ns.db.crateProbe = probe
	print(("   %d crate(s) or label(s) in your bags; their tooltip lines are saved (crateProbe) — /reload writes them."):format(n))
	print("   /mh crates test shows the delivery window now; /mh crates on|off.")
end
