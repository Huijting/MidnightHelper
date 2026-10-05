local _, ns = ...

--[[
	Midnight Helper — the Midnight achievements you still miss (`/mh achlist`, 5 Oct 2026).

	Survey #16 (fr): "les hauts faits non accomplis". Rob: only the Midnight ones, and "ja, alle vier
	meenemen" for Prey, Void Assaults, Ritual Sites and Housing.

	WHICH GROUPS. Measured on Rob's client with `/mh ach cats` (SV achCatProbe, 5 Oct 2026, enUS, server
	expansion level 11 = "Midnight"): six categories are titled after the expansion, and four
	Expansion Features / top-level groups exist only in Midnight. Category ids are numbers, so this
	works the same on every client language; the titles and names are read live.

	NOT IN HERE, on purpose: Midnight achievements that sit in MIXED groups next to older expansions'
	(each profession, Pet Battles, Skyriding, Fishing, PvP, holidays, "Level 90"). Their ids do not
	separate cleanly by number, so picking them out needs its own measurement. The window says so.

	Everything shown is read from the client: name, points, completed, criteria progress. Nothing is
	stored but the list of category ids below.
]]

-- Order = how a player meets them. Child categories of these (if any) are picked up live.
local GROUPS = {
	15571, -- Delves > Midnight
	15547, -- Quests > Midnight
	15553, -- Exploration > Midnight
	15600, -- Reputation > Midnight
	15541, -- Dungeons & Raids > Midnight Dungeon
	15566, -- Dungeons & Raids > Midnight Raid
	15605, -- Expansion Features > Prey
	15610, -- Expansion Features > Void Assaults
	15608, -- Expansion Features > Ritual Sites
	15606, -- Housing (top level)
}

local function Title(id)
	if not GetCategoryInfo then
		return tostring(id)
	end
	local ok, title, parentID = pcall(GetCategoryInfo, id)
	if not ok or type(title) ~= "string" then
		return "#" .. tostring(id)
	end
	if parentID and parentID ~= -1 then
		local okP, pTitle = pcall(GetCategoryInfo, parentID)
		if okP and type(pTitle) == "string" then
			return pTitle .. " > " .. title
		end
	end
	return title
end

--- The groups plus any category whose parent is one of them.
local function AllCategories()
	local out, set = {}, {}
	for _, id in ipairs(GROUPS) do
		out[#out + 1] = { id = id, children = {} }
		set[id] = out[#out]
	end
	if GetCategoryList and GetCategoryInfo then
		local ok, list = pcall(GetCategoryList)
		if ok and type(list) == "table" then
			for _, cid in ipairs(list) do
				local okI, _, parentID = pcall(GetCategoryInfo, cid)
				if okI and parentID and set[parentID] then
					table.insert(set[parentID].children, cid)
				end
			end
		end
	end
	return out
end

--- Criteria progress as "x/y", or nil when there is nothing useful to show.
local function Progress(achID)
	if not (GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return nil
	end
	local okN, n = pcall(GetAchievementNumCriteria, achID)
	n = okN and tonumber(n) or 0
	if n == 1 then
		local ok, _, _, _, quantity, reqQuantity = pcall(GetAchievementCriteriaInfo, achID, 1)
		if ok and tonumber(reqQuantity) and reqQuantity > 1 then
			return ("%d/%d"):format(tonumber(quantity) or 0, reqQuantity)
		end
		return nil
	end
	if n > 1 then
		local done = 0
		for i = 1, n do
			local ok, _, _, completed = pcall(GetAchievementCriteriaInfo, achID, i)
			if ok and completed then
				done = done + 1
			end
		end
		return ("%d/%d"):format(done, n)
	end
	return nil
end

--- @return table groups { { title, done, total, open = { {id,name,points,desc,progress} } } }, number open, number total
function ns.MidnightAchievementsMissing()
	local groups, allOpen, allTotal = {}, 0, 0
	if not (GetCategoryNumAchievements and GetAchievementInfo) then
		return groups, 0, 0
	end
	local function scan(cid, g)
		local okN, n = pcall(GetCategoryNumAchievements, cid)
		n = okN and tonumber(n) or 0
		for i = 1, n do
			local ok, id, name, points, completed, _, _, _, desc = pcall(GetAchievementInfo, cid, i)
			if ok and id and type(name) == "string" then
				g.total = g.total + 1
				if completed then
					g.done = g.done + 1
				else
					g.open[#g.open + 1] = { id = id, name = name, points = points, desc = desc, progress = Progress(id) }
				end
			end
		end
	end
	for _, c in ipairs(AllCategories()) do
		local g = { id = c.id, title = Title(c.id), done = 0, total = 0, open = {} }
		scan(c.id, g)
		for _, child in ipairs(c.children) do
			scan(child, g)
		end
		table.sort(g.open, function(a, b)
			return a.name < b.name
		end)
		groups[#groups + 1] = g
		allOpen = allOpen + #g.open
		allTotal = allTotal + g.total
	end
	return groups, allOpen, allTotal
end

--------------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------------

local ROW_H = 18
local win
local expanded = {}

local function RowTooltip(row)
	local d = row.data
	if not (d and d.ach) then
		return
	end
	GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
	GameTooltip:AddLine(d.ach.name, 1, 0.82, 0)
	if type(d.ach.desc) == "string" and d.ach.desc ~= "" then
		GameTooltip:AddLine(d.ach.desc, 1, 1, 1, true)
	end
	GameTooltip:AddLine(ns:L("MIDACH_CLICK_HINT"), 0.6, 0.6, 0.6, true)
	GameTooltip:Show()
end

local function Ensure()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperMidnightAchList", UIParent, "BackdropTemplate")
	-- A new frame is SHOWN by default. The first version only anchored it "if not shown", so it never
	-- got a point and drew nowhere, silently (Rob, 5 Oct 2026: "ik zie nog steeds niks"). Anchor here, hide.
	f:Hide()
	f:SetPoint("CENTER")
	f:SetSize(560, 600)
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
	close:SetPoint("TOPRIGHT", -4, -4)
	f.summary = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.summary:SetPoint("TOPLEFT", 22, -42)
	f.summary:SetPoint("RIGHT", -22, 0)
	f.summary:SetJustifyH("LEFT")
	f.note = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.note:SetPoint("BOTTOMLEFT", 22, 18)
	f.note:SetPoint("RIGHT", -22, 0)
	f.note:SetJustifyH("LEFT")

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 18, -82)
	scroll:SetPoint("BOTTOMRIGHT", -36, 48)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(500, 1)
	scroll:SetScrollChild(child)
	f.child, f.rows = child, {}

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	win = f
	return f
end

local Refresh

local function Row(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Button", nil, f.child)
	r:SetHeight(ROW_H)
	r:SetPoint("LEFT", 0, 0)
	r:SetPoint("RIGHT", 0, 0)
	local hl = r:CreateTexture(nil, "HIGHLIGHT")
	hl:SetAllPoints()
	hl:SetColorTexture(1, 0.82, 0.2, 0.12)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.text:SetPoint("LEFT", 4, 0)
	r.text:SetPoint("RIGHT", -60, 0)
	r.text:SetJustifyH("LEFT")
	r.text:SetWordWrap(false)
	r.right = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.right:SetPoint("RIGHT", -4, 0)
	r:SetScript("OnEnter", RowTooltip)
	r:SetScript("OnLeave", GameTooltip_Hide)
	r:SetScript("OnClick", function(self)
		local d = self.data
		if not d then
			return
		end
		if d.group then
			expanded[d.group] = not expanded[d.group]
			Refresh(f)
		elseif d.ach and ns.OpenAchievementWindow then
			ns.OpenAchievementWindow(d.ach.id)
		end
	end)
	f.rows[i] = r
	return r
end

Refresh = function(f)
	local groups, open, total = ns.MidnightAchievementsMissing()
	f.title:SetText(ns:L("MIDACH_TITLE"))
	f.summary:SetText(ns:L("MIDACH_SUMMARY_FMT"):format(open, total))
	f.note:SetText(ns:L("MIDACH_NOTE_MIXED"))
	local i = 0
	for _, g in ipairs(groups) do
		i = i + 1
		local r = Row(f, i)
		r.data = { group = g.id }
		local sign = expanded[g.id] and "|cffffd200-|r " or "|cffffd200+|r "
		r.text:SetText(sign .. "|cffffd200" .. g.title .. "|r")
		r.right:SetText(("%d / %d"):format(g.done, g.total))
		r.right:SetTextColor(g.done >= g.total and 0.4 or 1, g.done >= g.total and 0.87 or 1, g.done >= g.total and 0.4 or 1)
		if expanded[g.id] then
			if #g.open == 0 then
				i = i + 1
				local e = Row(f, i)
				e.data = nil
				e.text:SetText("      |cff9d9d9d" .. ns:L("MIDACH_GROUP_DONE") .. "|r")
				e.right:SetText("")
			end
			for _, a in ipairs(g.open) do
				i = i + 1
				local e = Row(f, i)
				e.data = { ach = a }
				e.text:SetText("      " .. a.name .. (a.progress and ("  |cff9d9d9d" .. a.progress .. "|r") or ""))
				e.right:SetText(a.points and a.points > 0 and ("|cffb0b0b0" .. a.points .. "|r") or "")
				e.right:SetTextColor(1, 1, 1)
			end
		end
	end
	for n, r in ipairs(f.rows) do
		if n <= i then
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, -(n - 1) * ROW_H)
			r:SetPoint("RIGHT", f.child, "RIGHT", 0, 0)
			r:Show()
		else
			r:Hide()
			r.data = nil
		end
	end
	f.child:SetHeight(math.max(1, i * ROW_H))
end

function ns.ShowMidnightAchList()
	local f = Ensure()
	if not f:IsShown() or not f:GetPoint() then
		f:ClearAllPoints()
		f:SetPoint("CENTER")
	end
	Refresh(f)
	f:Show()
end

--- `/mh achlist why` — per group: which category, what the client returned (Spec 30: an empty
--- group must be able to say whether it is done or unreadable).
function ns.PrintMidnightAchList()
	local p = "|cffffcc00Midnight Helper:|r "
	local groups, open, total = ns.MidnightAchievementsMissing()
	print(p .. ("Midnight achievements: %d open of %d, in %d groups."):format(open, total, #groups))
	for _, g in ipairs(groups) do
		print(("  %s |cff9d9d9d(category %d)|r  %d / %d done, %d open"):format(g.title, g.id, g.done, g.total, #g.open))
	end
end
