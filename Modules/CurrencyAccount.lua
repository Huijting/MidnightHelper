--[[
	Currencies across your characters (Spec 39, 11 Sep 2026).

	Rob: "Currency's, hebben wij die ook allemaal in een overzicht zodat we weten wat onze
	characters hebben, en dan gaat het wel om nuttige currency's, maar belangrijker, kunnen we van
	daar uit ook zien wat we er mee kunnen of misschien wel moeten doen?"

	A block at the top of the Currencies tab: one row per useful currency, the account total, and
	one line saying what to do with it. Hover a row for every character's amount. The guide below
	it stays the map of where each currency is spent.

	🔴 "SHOULD" ONLY WHERE THE GAME GIVES A REASON. A line only tells you to spend when something
	is otherwise lost: a character sitting at a cap. The caps come from C_CurrencyInfo at runtime,
	never from a number written down here - the one exception is Manaflux's 8, which AltOverview and
	the This Week block already act on. Everything else is a "can" line: what it is for.

	⚠️ nil IS NOT ZERO. A character saved before this module existed has no `cur` table; it is
	listed as "not seen yet", not as holding nothing - the same rule as manaflux in AltOverview.

	`/mh curscan` prints the raw fields this block acts on, per currency, and saves them to
	ns.db.curScan. A row that gives no advice looks the same whether it is right to or broken;
	that command is how to tell.
]]

local _, ns = ...

local MANAFLUX_KNOWN_CAP = 8

--- `field` = the snapshot field AltOverview kept before this module existed, read for records
--- saved before `cur` did. `name` is only a fallback for when the client has not sent the
--- currency yet; the row shows the client's own name, which is right in every language.
local TRACKED = {
	{ key = "keys", id = 3028, field = "keys", name = "Restored Coffer Key" },
	{ key = "shards", id = 3310, field = "shards", name = "Coffer Key Shards" },
	{ key = "manaflux", id = 3465, field = "manaflux", name = "Venomblight Manaflux", knownCap = MANAFLUX_KNOWN_CAP },
	{ key = "undercoin", id = 2803, field = "undercoin", name = "Undercoin" },
	{ key = "mana", id = 3356, field = "manaCrystals", name = "Untainted Mana-Crystals" },
	{ key = "corrcoin", id = 3448, name = "Corrosive Coin" },
	{ key = "marl", id = 3316, name = "Voidlight Marl" },
	{ key = "accolade", id = 3405, name = "Field Accolade" },
}

local ROW_H = 18
local TITLE_H = 18

local ui

--------------------------------------------------------------------------------
-- Reading the client

local function Num(v)
	if v == nil then
		return nil
	end
	if issecretvalue and issecretvalue(v) then
		return nil
	end
	return tonumber(v)
end

local function ReadInfo(id)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
	if not ok or type(info) ~= "table" then
		return nil
	end
	if type(info.name) ~= "string" or info.name == "" then
		return nil
	end
	return info
end

--- The five crest tiers of the season this character is earning, in tier order. Same choice as
--- the Crests tab (ns.MH_TierUsesSeason2), so the two cannot disagree about which id is live.
local function CrestCurrencies()
	local out = {}
	local tiers = ns.DAWNCREST_TIERS
	if type(tiers) ~= "table" then
		return out
	end
	for i = 1, #tiers do
		local t = tiers[i]
		local s2 = ns.MH_TierUsesSeason2 and ns.MH_TierUsesSeason2(t)
		local id = t and ((s2 and t.season2CurrencyId) or t.currencyId)
		if id then
			out[#out + 1] = { key = "crest" .. i, id = id, labelKey = t.labelKey, name = t.labelKey }
		end
	end
	return out
end

local function AllIds()
	local ids = {}
	for _, c in ipairs(TRACKED) do
		ids[#ids + 1] = c.id
	end
	for _, c in ipairs(CrestCurrencies()) do
		ids[#ids + 1] = c.id
	end
	return ids
end

local function RequestAll()
	if not (C_CurrencyInfo and C_CurrencyInfo.RequestCurrencyDataFromServer) then
		return
	end
	for _, id in ipairs(AllIds()) do
		pcall(C_CurrencyInfo.RequestCurrencyDataFromServer, id)
	end
end

--- What AltOverview's SaveCurrentSnapshot stores as `cur`: per currency id the balance, the
--- amount earned this week and the amount earned in total (a season cap counts the last one).
--- Only ever added to the snapshot record; nothing that reads the old fields changes.
function ns.MH_CurrencySnapshotExtra()
	local cur = {}
	for _, id in ipairs(AllIds()) do
		local info = ReadInfo(id)
		local q = info and Num(info.quantity)
		if q then
			cur[id] = {
				q = math.floor(q),
				w = math.floor(Num(info.quantityEarnedThisWeek) or 0),
				t = math.floor(Num(info.totalEarned) or 0),
			}
		end
	end
	return cur
end

--------------------------------------------------------------------------------
-- Per character

local function Label(rec)
	local nm = tostring(rec.name or "?")
	local realm = rec.realm
	if type(realm) == "string" and realm ~= "" then
		return nm .. "-" .. realm
	end
	return nm
end

--- @return q, w, t, known  - known=false means this record was saved before we tracked it
local function RecordAmount(rec, c)
	local cur = type(rec.cur) == "table" and rec.cur[c.id]
	if type(cur) == "table" then
		return tonumber(cur.q) or 0, tonumber(cur.w) or 0, tonumber(cur.t) or 0, true
	end
	if c.field and rec[c.field] ~= nil then
		local q = tonumber(rec[c.field])
		if q then
			local w = (c.key == "shards") and (tonumber(rec.shardsWeekly) or 0) or 0
			return q, w, 0, true
		end
	end
	return nil, nil, nil, false
end

--- Every saved character's amount of one currency, the current character read live.
--- @return list, total, unknownCount
local function Collect(c, info)
	local recs = (ns.db and type(ns.db.charCurrencies) == "table") and ns.db.charCurrencies or {}
	local curGuid = UnitGUID and UnitGUID("player")
	local list, total, unknown = {}, 0, 0
	local sawYou = false
	local function add(rec, isYou)
		local q, w, t, known
		if isYou and info then
			q = math.floor(Num(info.quantity) or 0)
			w = math.floor(Num(info.quantityEarnedThisWeek) or 0)
			t = math.floor(Num(info.totalEarned) or 0)
			known = true
		else
			q, w, t, known = RecordAmount(rec, c)
		end
		local stale = false
		if not isYou and ns.MhAccountEntryIsStale then
			stale = ns:MhAccountEntryIsStale(rec) and true or false
		end
		list[#list + 1] = { label = Label(rec), q = q, w = w, t = t, known = known, stale = stale, isYou = isYou }
		if known then
			total = total + q
		else
			unknown = unknown + 1
		end
	end
	for guid, rec in pairs(recs) do
		if type(rec) == "table" and type(rec.name) == "string" then
			local isYou = guid == curGuid
			sawYou = sawYou or isYou
			add(rec, isYou)
		end
	end
	-- The very first login, before AltOverview has saved this character: still count it.
	if not sawYou and info then
		local nm, realm = UnitFullName and UnitFullName("player")
		add({ name = nm or (UnitName and UnitName("player")) or "?", realm = realm or "" }, true)
	end
	table.sort(list, function(a, b)
		if a.known ~= b.known then
			return a.known
		end
		if a.known and a.q ~= b.q then
			return a.q > b.q
		end
		return a.label < b.label
	end)
	return list, total, unknown
end

local function NamePreview(labels)
	local n = #labels
	if n == 0 then
		return ""
	end
	local shown = {}
	for i = 1, math.min(2, n) do
		shown[#shown + 1] = labels[i]
	end
	local s = table.concat(shown, ", ")
	if n > 2 then
		s = s .. (" (+%d)"):format(n - 2)
	end
	return s
end

--------------------------------------------------------------------------------
-- Advice

--- One line per currency, and a kind: "warn" (something is lost unless you act), "info" (what it
--- is for), "none" (nobody holds any).
local function Advice(c, info, list, total)
	local maxQ = (info and Num(info.maxQuantity)) or 0
	local seasonal = info and info.useTotalEarnedForMaxQty and true or false
	if info and info.isAccountWide then
		if maxQ > 0 and not seasonal and total >= maxQ then
			return ns:L("CURACC_ADV_FULL_ACCOUNT"), "warn"
		end
	else
		local cap = (maxQ > 0 and not seasonal) and maxQ or c.knownCap
		local capped, seasonCapped = {}, {}
		for _, e in ipairs(list) do
			if e.known then
				if cap and cap > 0 and e.q >= cap then
					capped[#capped + 1] = e.label
				end
				if seasonal and maxQ > 0 and e.t >= maxQ then
					seasonCapped[#seasonCapped + 1] = e.label
				end
			end
		end
		if #capped > 0 then
			return ns:L("CURACC_ADV_FULL_FMT"):format(NamePreview(capped)), "warn"
		end
		if #seasonCapped > 0 then
			return ns:L("CURACC_ADV_SEASONCAP_FMT"):format(NamePreview(seasonCapped)), "warn"
		end
	end
	if total <= 0 then
		return ns:L("CURACC_ADV_NONE"), "none"
	end
	return ns:L("CURACC_USE_" .. string.upper(c.key)), "info"
end

--- The crest row: five tiers in one line. Only the season cap is advice here; what crests are
--- for is the same for every tier.
local function CrestAdvice(tiers)
	local parts = {}
	for _, tr in ipairs(tiers) do
		if tr.seasonCapped and #tr.seasonCapped > 0 then
			parts[#parts + 1] = ns:L("CURACC_CREST_CAPPED_PART_FMT"):format(tr.label, NamePreview(tr.seasonCapped))
		end
	end
	if #parts > 0 then
		return ns:L("CURACC_ADV_CREST_SEASONCAP_FMT"):format(table.concat(parts, "; ")), "warn"
	end
	for _, tr in ipairs(tiers) do
		if tr.total > 0 then
			return ns:L("CURACC_USE_CRESTS"), "info"
		end
	end
	return ns:L("CURACC_ADV_NONE"), "none"
end

local KIND_COLOR = {
	warn = { 1, 0.72, 0.3 },
	info = { 0.82, 0.84, 0.88 },
	none = { 0.5, 0.5, 0.5 },
}

--------------------------------------------------------------------------------
-- Rows

local function Scale()
	return (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
end

local function ShowRowTooltip(row)
	local d = row._mhData
	if not (d and GameTooltip) then
		return
	end
	GameTooltip:SetOwner(row, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	local title = d.name or "?"
	if d.icon then
		title = ("|T%s:0|t %s"):format(tostring(d.icon), title)
	end
	GameTooltip:AddLine(title, 1, 0.9, 0.5)
	if d.crestTiers then
		for _, tr in ipairs(d.crestTiers) do
			local most = tr.list[1]
			if tr.total > 0 and most and most.known then
				GameTooltip:AddDoubleLine(tr.label, ns:L("CURACC_TT_MOST_FMT"):format(tr.total, most.label, most.q),
					0.9, 0.9, 0.9, 0.75, 0.88, 1)
			else
				GameTooltip:AddDoubleLine(tr.label, "0", 0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
			end
		end
	elseif d.accountWide then
		GameTooltip:AddLine(ns:L("CURACC_TT_ACCOUNTWIDE"), 0.75, 0.88, 1, true)
	else
		for _, e in ipairs(d.list or {}) do
			local left = e.label
			if e.isYou then
				left = left .. " " .. ns:L("ALT_OVERVIEW_YOU")
			end
			if not e.known then
				GameTooltip:AddDoubleLine(left, ns:L("CURACC_TT_NOT_SEEN"), 0.55, 0.55, 0.55, 0.55, 0.55, 0.55)
			elseif e.stale then
				GameTooltip:AddDoubleLine(left .. " |TInterface\\Icons\\INV_Misc_PocketWatch_01:0|t", tostring(e.q),
					0.6, 0.6, 0.6, 0.6, 0.6, 0.6)
			else
				local r, g, b = 0.92, 0.92, 0.92
				if e.isYou then
					r, g, b = 1, 0.92, 0.45
				end
				GameTooltip:AddDoubleLine(left, tostring(e.q), r, g, b, 1, 1, 1)
			end
		end
	end
	if d.capLine then
		GameTooltip:AddLine(d.capLine, 0.7, 0.7, 0.7, true)
	end
	-- Asked of the client, not claimed: the sources disagree about which of these move.
	if d.transferable then
		GameTooltip:AddLine(ns:L("CURACC_TT_TRANSFERABLE"), 0.7, 0.7, 0.7, true)
	end
	GameTooltip:AddLine(" ")
	local col = KIND_COLOR[d.kind] or KIND_COLOR.info
	GameTooltip:AddLine(d.advice or "", col[1], col[2], col[3], true)
	-- A warning replaces the "what it is for" line in the row; the tooltip keeps both.
	if d.kind ~= "info" and d.useLine then
		GameTooltip:AddLine(d.useLine, KIND_COLOR.info[1], KIND_COLOR.info[2], KIND_COLOR.info[3], true)
	end
	if d.hasStale then
		GameTooltip:AddLine(ns:L("CURACC_TT_STALE_NOTE"), 0.6, 0.6, 0.6, true)
	end
	GameTooltip:Show()
end

local function MakeRow(parent, i)
	local row = CreateFrame("Frame", nil, parent)
	row:EnableMouse(true)
	row.bg = row:CreateTexture(nil, "BACKGROUND")
	row.bg:SetAllPoints()
	row.bg:SetColorTexture(1, 1, 1, (i % 2 == 1) and 0.03 or 0.07)
	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:SetSize(14, 14)
	row.icon:SetPoint("LEFT", row, "LEFT", 4, 0)
	local function Fs(template)
		local fs = row:CreateFontString(nil, "OVERLAY", template)
		fs:SetFontObject(ns.MHScalableFont(template))
		fs:SetWordWrap(false)
		if fs.SetMaxLines then
			fs:SetMaxLines(1)
		end
		return fs
	end
	row.nameFs = Fs("GameFontHighlightSmall")
	row.nameFs:SetPoint("LEFT", row.icon, "RIGHT", 4, 0)
	row.nameFs:SetWidth(170)
	row.nameFs:SetJustifyH("LEFT")
	row.totalFs = Fs("GameFontHighlightSmall")
	row.totalFs:SetPoint("LEFT", row.nameFs, "RIGHT", 4, 0)
	row.totalFs:SetWidth(56)
	row.totalFs:SetJustifyH("RIGHT")
	row.adviceFs = Fs("GameFontHighlightSmall")
	row.adviceFs:SetPoint("LEFT", row.totalFs, "RIGHT", 12, 0)
	row.adviceFs:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	row.adviceFs:SetJustifyH("LEFT")
	row:SetScript("OnEnter", ShowRowTooltip)
	row:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	return row
end

local function CapLine(info)
	if not info then
		return nil
	end
	local maxQ = Num(info.maxQuantity) or 0
	local maxW = Num(info.maxWeeklyQuantity) or 0
	if maxQ > 0 and info.useTotalEarnedForMaxQty then
		return ns:L("CURACC_TT_SEASONCAP_FMT"):format(maxQ)
	elseif maxQ > 0 then
		return ns:L("CURACC_TT_CAP_FMT"):format(maxQ)
	elseif maxW > 0 then
		return ns:L("CURACC_TT_WEEKLY_FMT"):format(maxW)
	end
	return nil
end

local function BuildRowData(c)
	local info = ReadInfo(c.id)
	local list, total, unknown = Collect(c, info)
	local d = {
		name = (info and info.name) or c.name,
		icon = info and info.iconFileID,
		list = list,
		total = total,
		unknown = unknown,
		accountWide = info and info.isAccountWide and true or false,
		transferable = info and info.isAccountTransferable and true or false,
		capLine = CapLine(info),
		useLine = ns:L("CURACC_USE_" .. string.upper(c.key)),
	}
	if d.accountWide and info then
		d.total = math.floor(Num(info.quantity) or 0)
	end
	for _, e in ipairs(list) do
		if e.stale and e.known then
			d.hasStale = true
		end
	end
	d.advice, d.kind = Advice(c, info, list, d.total)
	return d
end

local function BuildCrestRowData()
	local tiers = {}
	local icon
	for _, c in ipairs(CrestCurrencies()) do
		local info = ReadInfo(c.id)
		local list, total = Collect(c, info)
		local maxQ = (info and Num(info.maxQuantity)) or 0
		local seasonCapped = {}
		if info and info.useTotalEarnedForMaxQty and maxQ > 0 then
			for _, e in ipairs(list) do
				if e.known and e.t >= maxQ then
					seasonCapped[#seasonCapped + 1] = e.label
				end
			end
		end
		icon = icon or (info and info.iconFileID)
		tiers[#tiers + 1] = {
			label = (info and info.name) or ns:L(c.labelKey),
			list = list,
			total = total,
			seasonCapped = seasonCapped,
		}
	end
	local d = {
		name = ns:L("CODEX_CUR_DAWN_TITLE"),
		icon = icon,
		crestTiers = tiers,
		useLine = ns:L("CURACC_USE_CRESTS"),
	}
	d.advice, d.kind = CrestAdvice(tiers)
	return d
end

local function ApplyRow(row, d)
	row._mhData = d
	if d.icon then
		row.icon:SetTexture(d.icon)
		row.icon:Show()
	else
		row.icon:Hide()
	end
	row.nameFs:SetText(d.name or "?")
	if d.crestTiers then
		row.totalFs:SetText("")
	else
		row.totalFs:SetText(tostring(d.total or 0))
	end
	local col = KIND_COLOR[d.kind] or KIND_COLOR.info
	row.adviceFs:SetText(d.advice or "")
	row.adviceFs:SetTextColor(col[1], col[2], col[3])
	if d.kind == "none" then
		row.nameFs:SetTextColor(0.6, 0.6, 0.6)
		row.totalFs:SetTextColor(0.6, 0.6, 0.6)
	else
		row.nameFs:SetTextColor(0.95, 0.95, 0.95)
		row.totalFs:SetTextColor(1, 1, 1)
	end
end

--------------------------------------------------------------------------------
-- The block

local function GetCollapsed()
	local u = ns.db and ns.db.ui
	return type(u) == "table" and u.currencyAccountCollapsed == true
end

local function SetCollapsed(v)
	if not ns.db then
		return
	end
	if type(ns.db.ui) ~= "table" then
		ns.db.ui = {}
	end
	ns.db.ui.currencyAccountCollapsed = v and true or false
end

local function Layout()
	if not (ui and ui.block) then
		return
	end
	local s = Scale()
	local rowH = ROW_H * s
	local titleH = TITLE_H * s
	ui.titleRow:SetHeight(titleH)
	local collapsed = GetCollapsed()
	local y = titleH + 2
	for _, row in ipairs(ui.rows) do
		row:SetHeight(rowH)
		row:ClearAllPoints()
		row:SetPoint("TOPLEFT", ui.block, "TOPLEFT", 0, -y)
		row:SetPoint("TOPRIGHT", ui.block, "TOPRIGHT", 0, -y)
		if collapsed then
			row:Hide()
		else
			row:Show()
			y = y + rowH
		end
	end
	ui.block:SetHeight(y + 4)
	ui.collapseBtn:SetText(collapsed and "+" or "−")
end

function ns.RefreshCurrencyAccountBlock()
	if not (ui and ui.block) then
		return
	end
	ui.titleFs:SetText(ns:L("CURACC_TITLE"))
	ui.hintFs:SetText(ns:L("CURACC_HINT"))
	for i, c in ipairs(TRACKED) do
		ApplyRow(ui.rows[i], BuildRowData(c))
	end
	ApplyRow(ui.rows[#TRACKED + 1], BuildCrestRowData())
	Layout()
end

--- Called by CurrencyGuide when it builds its panel. Returns the block so the guide's scroll can
--- anchor below it.
function ns.BuildCurrencyAccountBlock(panel, anchorBelow)
	if ui and ui.block then
		return ui.block
	end
	ui = { rows = {} }
	local block = CreateFrame("Frame", nil, panel)
	block:SetPoint("TOPLEFT", anchorBelow, "BOTTOMLEFT", 0, -10)
	block:SetPoint("RIGHT", panel, "RIGHT", -30, 0)
	block:SetHeight(TITLE_H)
	ui.block = block

	local titleRow = CreateFrame("Frame", nil, block)
	titleRow:SetPoint("TOPLEFT", block, "TOPLEFT", 0, 0)
	titleRow:SetPoint("TOPRIGHT", block, "TOPRIGHT", 0, 0)
	titleRow:SetHeight(TITLE_H)
	ui.titleRow = titleRow

	local collapseBtn = CreateFrame("Button", nil, titleRow)
	collapseBtn:SetSize(18, 18)
	collapseBtn:SetPoint("LEFT", titleRow, "LEFT", 0, 0)
	collapseBtn:SetNormalFontObject(GameFontNormal)
	collapseBtn:SetText("−")
	collapseBtn:SetScript("OnClick", function()
		SetCollapsed(not GetCollapsed())
		Layout()
	end)
	ui.collapseBtn = collapseBtn

	local titleFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	titleFs:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	titleFs:SetPoint("LEFT", collapseBtn, "RIGHT", 2, 0)
	titleFs:SetJustifyH("LEFT")
	ui.titleFs = titleFs

	local hintFs = titleRow:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hintFs:SetFontObject(ns.MHScalableFont("GameFontDisableSmall"))
	hintFs:SetPoint("LEFT", titleFs, "RIGHT", 10, 0)
	hintFs:SetPoint("RIGHT", titleRow, "RIGHT", -4, 0)
	hintFs:SetJustifyH("LEFT")
	hintFs:SetWordWrap(false)
	ui.hintFs = hintFs

	for i = 1, #TRACKED + 1 do
		ui.rows[i] = MakeRow(block, i)
	end

	RequestAll()
	ns.RefreshCurrencyAccountBlock()
	return block
end

--------------------------------------------------------------------------------
-- /mh curscan

--- The raw fields behind every row, printed and saved to ns.db.curScan. English on purpose: the
--- diagnostics ship, and a bug report should read the same in every language.
function ns.PrintCurrencyAccountScan()
	local prefix = "|cffffcc00" .. ns:L("PRINT_PREFIX") .. "|r"
	RequestAll()
	local rows = {}
	local all = {}
	for _, c in ipairs(TRACKED) do
		all[#all + 1] = c
	end
	for _, c in ipairs(CrestCurrencies()) do
		all[#all + 1] = c
	end
	print(prefix .. " Currencies block - raw fields per currency (C_CurrencyInfo.GetCurrencyInfo):")
	for _, c in ipairs(all) do
		local info = ReadInfo(c.id)
		if not info then
			print(("   %d  |cffff6666unknown to the client (no name)|r"):format(c.id))
			rows[#rows + 1] = { id = c.id, known = false }
		else
			local r = {
				id = c.id,
				name = info.name,
				quantity = Num(info.quantity),
				maxQuantity = Num(info.maxQuantity),
				maxWeeklyQuantity = Num(info.maxWeeklyQuantity),
				quantityEarnedThisWeek = Num(info.quantityEarnedThisWeek),
				totalEarned = Num(info.totalEarned),
				useTotalEarnedForMaxQty = info.useTotalEarnedForMaxQty and true or false,
				isAccountWide = info.isAccountWide and true or false,
				isAccountTransferable = info.isAccountTransferable and true or false,
				transferPercentage = Num(info.transferPercentage),
			}
			rows[#rows + 1] = r
			print(("   %d %s: qty=%s max=%s weeklyMax=%s thisWeek=%s totalEarned=%s seasonCap=%s accountWide=%s transferable=%s"):format(
				c.id, tostring(r.name), tostring(r.quantity), tostring(r.maxQuantity), tostring(r.maxWeeklyQuantity),
				tostring(r.quantityEarnedThisWeek), tostring(r.totalEarned), tostring(r.useTotalEarnedForMaxQty),
				tostring(r.isAccountWide), tostring(r.isAccountTransferable)))
		end
	end
	local recs = (ns.db and type(ns.db.charCurrencies) == "table") and ns.db.charCurrencies or {}
	local saved, withCur = 0, 0
	for _, rec in pairs(recs) do
		if type(rec) == "table" and type(rec.name) == "string" then
			saved = saved + 1
			if type(rec.cur) == "table" then
				withCur = withCur + 1
			end
		end
	end
	print(("   %d characters saved, %d with per-currency data. The rest were last seen before 11 Sep 2026: log in on them once."):format(saved, withCur))
	if ns.db then
		ns.db.curScan = { at = time(), rows = rows, saved = saved, withCur = withCur }
	end
end

--------------------------------------------------------------------------------
-- Events

-- Refreshing is CurrencyGuide's job (its panel's OnShow, CURRENCY_DISPLAY_UPDATE and language
-- change all go through ns.RefreshCurrencyGuidePanel). This only asks the server for the ids,
-- because a currency it has not pushed reads as zero - indistinguishable from holding none.
do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	ev:SetScript("OnEvent", function()
		RequestAll()
	end)
end
