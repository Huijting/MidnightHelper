local _, ns = ...

--[[
	ForeverProfTrainers.lua — WoW Forever: a window with every profession trainer for your side, nearest first.
	Rob, 8 Nov 2026: "maak een pagina in de MH om ze te vinden ipv alleen bij wat kan ik leren" → "Ja, zo bouwen".

	Left: the 12 professions, yours first (gold, with your skill). Right: every trainer of the chosen profession on your
	side (ns.ForeverProfTrainerList in ForeverTrainer.lua): name, zone, distance, the highest skill it teaches, and an
	Arrow button per trainer (the same arrow and cross as /mh trainer <profession>). A trainer that cannot teach your next
	rank stays in the list, greyed, with that said on its row.
	Data: ForeverProfTrainerSpots.lua (Wowhead Forever, 8 Nov 2026) plus the places you saved with /mh trainer here <prof>.
	Open: /mh trainers, the start page, the Tools room. Shift+scroll and Escape through RegisterMidnightDialogPopup.
]]

if not ns.IS_FOREVER then
	return
end

local W, H = 660, 560 -- 12 Nov 2026: taller, for the profession card (ForeverProfGuide.lua)
local LEFT_W = 170
local ROW_H = 36
local win
local selected

local function MyProfs()
	return ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
end

local function Order(mine)
	local order = {}
	for _, p in ipairs(ns.FOREVER_PROFS or {}) do
		if mine[p[1]] then
			order[#order + 1] = p[1]
		end
	end
	for _, p in ipairs(ns.FOREVER_PROFS or {}) do
		if not mine[p[1]] then
			order[#order + 1] = p[1]
		end
	end
	return order
end

local Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverProfTrainers", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 40)
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

	-- Left: one button per profession.
	f.profBtns = {}
	for i = 1, 12 do
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(LEFT_W, 24)
		b:SetPoint("TOPLEFT", 20, -50 - (i - 1) * 28)
		b:SetScript("OnClick", function(self)
			if self.prof then
				selected = self.prof
				Fill()
			end
		end)
		f.profBtns[i] = b
	end

	-- Right: what you need, then the list.
	local rx = 20 + LEFT_W + 16
	f.head = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.head:SetPoint("TOPLEFT", rx, -52)
	f.head:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.head:SetJustifyH("LEFT")
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", f.head, "BOTTOMLEFT", 0, -4)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.sub:SetJustifyH("LEFT")
	-- 12 Nov 2026 (Rob via sparring: "A, eerst klein"): a card about the chosen profession, above the trainers.
	f.card = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.card:SetPoint("TOPLEFT", f.sub, "BOTTOMLEFT", 0, -8)
	f.card:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.card:SetJustifyH("LEFT")
	f.card:SetSpacing(2)
	f.buy = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.buy:SetHeight(20)
	f.buy:SetPoint("TOPLEFT", f.card, "BOTTOMLEFT", 0, -4)
	f.buy:SetScript("OnClick", function(self)
		if self.key and ns.ShowForeverVendors then
			ns.ShowForeverVendors(self.key)
		end
	end)
	f.buy:Hide()
	f.rx = rx
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", rx, -94)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - rx - 44, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child, f.rows = scroll, child, {}

	-- Bottom: how to add a trainer that is missing (CLAUDE.md: the explanation in the same room as the button).
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 22, 18)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")

	f:SetScript("OnShow", function()
		Fill()
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

local function Row(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f.child)
	r:SetSize(f.child:GetWidth(), ROW_H)
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.name:SetPoint("TOPLEFT", 4, -2)
	r.name:SetPoint("RIGHT", r, "RIGHT", -84, 0)
	r.name:SetJustifyH("LEFT")
	r.name:SetWordWrap(false)
	r.info = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r, "RIGHT", -84, 0)
	r.info:SetJustifyH("LEFT")
	r.info:SetWordWrap(false)
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(76, 22)
	r.go:SetPoint("RIGHT", r, "RIGHT", -2, 0)
	r.go:SetScript("OnClick", function(self)
		local e = self.entry
		if e and ns.ForeverTrainerGoTo then
			ns.ForeverTrainerGoTo(e.c, e.dist, nil, self.prof)
		end
	end)
	f.rows[i] = r
	return r
end

Fill = function()
	local f = Build()
	local mine = MyProfs()
	local order = Order(mine)
	if not selected or not ns.ForeverProfName then
		selected = order[1]
	end
	f.title:SetText(ns:L("FPROF_TITLE"))
	for i, b in ipairs(f.profBtns) do
		local key = order[i]
		b.prof = key
		if key then
			local nm = ns.ForeverProfName and ns.ForeverProfName(key, mine) or key
			local m = mine[key]
			local text = nm
			if m and m.rank and m.maxRank then
				text = ("%s  %d/%d"):format(nm, m.rank, m.maxRank)
			end
			if m then
				text = "|cffffd100" .. text .. "|r"
			end
			b:SetText(text)
			if key == selected then
				b:LockHighlight()
			else
				b:UnlockHighlight()
			end
			b:Show()
		else
			b:Hide()
		end
	end
	if not selected then
		return f
	end
	local profName = ns.ForeverProfName(selected, mine)
	local list, need, posOk = {}, nil, false
	if ns.ForeverProfTrainerList then
		list, need, posOk = ns.ForeverProfTrainerList(selected)
	end
	f.head:SetText(ns:L("FPROF_COUNT_FMT"):format(profName, #list))
	local sub
	if not mine[selected] then
		sub = ns:L("FPROF_NEW")
	elseif need then
		sub = ns:L("FPROF_NEED_FMT"):format(need)
	else
		sub = ns:L("FPROF_ANY")
	end
	if not posOk then
		sub = sub .. "  " .. ns:L("FPROF_NOPOS")
	end
	f.sub:SetText(sub)
	-- The card, then the list below it.
	local card, toolKey = nil, nil
	if ns.ForeverProfCard then
		card, toolKey = ns.ForeverProfCard(selected)
	end
	local above = f.sub -- what the list hangs under
	if card then
		f.card:SetText(card)
		-- Rob's screenshot, 12 Nov 2026: "Tool: (loading...)." for Fishing. The item name was not cached yet when the
		-- card was drawn, and nothing drew it again. Same cure as the vendor tip (ForeverVendors.lua, 10 + 11 Nov):
		-- ask the client to tell us when the item has loaded, and also look again every half second for 5 seconds.
		if toolKey and card:find(ns:L("FVEND_ITEM_LOADING"), 1, true) then
			local id = ns.ForeverVendorItemId and ns.ForeverVendorItemId(toolKey)
			if id and Item and Item.CreateFromItemID and f._waitItem ~= id then
				f._waitItem = id
				pcall(function()
					Item:CreateFromItemID(id):ContinueOnItemLoad(function()
						f._waitItem = nil
						if f:IsShown() then
							Fill()
						end
					end)
				end)
			end
			if C_Timer and C_Timer.After and (f._retries or 0) < 10 then
				f._retries = (f._retries or 0) + 1
				C_Timer.After(0.5, function()
					if f:IsShown() then
						Fill()
					end
				end)
			end
		else
			f._retries = 0
		end
		f.card:Show()
		above = f.card
		if toolKey then
			f.buy:SetText(ns:L("FPROFG_BUY"))
			local fs = f.buy:GetFontString()
			f.buy:SetWidth(math.ceil(((fs and fs:GetStringWidth()) or 100) + 24))
			f.buy.key = toolKey
			f.buy:Show()
			above = f.buy
		else
			f.buy:Hide()
		end
	else
		f.card:SetText("")
		f.card:Hide()
		f.buy:Hide()
	end
	f.scroll:ClearAllPoints()
	f.scroll:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -10)
	f.scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 44)
	local y = 0
	for i, e in ipairs(list) do
		local r = Row(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		local c = e.c
		local name = c.name or "?"
		if c.max then
			name = name .. "  |cff999999" .. ns:L("FPROF_ROW_MAX_FMT"):format(c.max) .. "|r"
		end
		if c.src == "yours" then
			name = name .. "  |cff66ccff" .. ns:L("FTRAIN_SRC_YOURS") .. "|r"
		end
		r.name:SetText(name)
		local where = e.zone .. " · " .. (e.dist and ns.ForeverTrainerDistance(e.dist) or ns:L("FPROF_OTHER_CONT"))
		if c.low then
			where = where .. "  |cffff7f7f" .. ns:L("FPROF_ROW_LOW") .. "|r"
		end
		r.info:SetText(where)
		r:SetAlpha(c.low and 0.55 or 1)
		r.go:SetText(ns:L("FPROF_ARROW"))
		r.go.entry, r.go.prof = e, selected
		r:Show()
		y = y - ROW_H - 4
	end
	for i = #list + 1, #f.rows do
		f.rows[i]:Hide()
	end
	if #list == 0 then
		f.sub:SetText(sub .. "  " .. ns:L("FPROF_EMPTY"))
	end
	f.child:SetHeight(math.max(10, -y))
	f.scroll:SetVerticalScroll(0)
	local word = ""
	for _, p in ipairs(ns.FOREVER_PROFS or {}) do
		if p[1] == selected then
			word = p[3]:lower()
		end
	end
	f.hint:SetText(ns:L("FPROF_HINT_FMT"):format(word))
	return f
end

--- Open (or close) the window. `prof` = a profession key to show first.
function ns.ShowForeverProfTrainers(prof)
	local f = Build()
	if prof then
		selected = prof
	end
	if f:IsShown() and not prof then
		f:Hide()
		return
	end
	if f:IsShown() then
		Fill()
	else
		f:Show() -- OnShow fills it
	end
end
