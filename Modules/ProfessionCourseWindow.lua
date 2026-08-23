local _, ns = ...

--[[
	Midnight Helper — the professions course as a window of its own.

	WHY. The course grew to 14 chapters and ~355 rendered lines on 20 Aug 2026. A
	contents rail was added the next day and fixed the navigation, but inside the main
	window the rail only gets the height left over under the status block — Rob's
	verdict: "hij staat in de MH layout zelf en ik wil hem graag ernaast hebben, zodat
	ie over de hele hoogte kan zodat ie beter leesbaar is".

	He is right, and it is the second half of a request he made the day before: when a
	chapter tells you to go and press something in the game, you want that text beside
	the game rather than under a window covering it.

	⚠️ IT RENDERS, IT DOES NOT OWN. The chapter list, the tick state, the selection and
	the text all come from ProfessionAcademy through MH_GetCourseChapters /
	MH_GetChapterText, which use the same composer the panel uses. A second copy of the
	text assembly would drift, and drifting text beside its own data is exactly what
	this course spent two days repairing.

	Ticking a chapter off stays in the panel on purpose. This is a reader you keep open
	while you play; the checkbox belongs where the task and its waypoint button are.
]]

local MIN_W, MIN_H = 380, 260
local DEFAULT_W, DEFAULT_H = 700, 620
local RAIL_MIN_W, RAIL_MAX_W = 172, 320
local RAIL_ROW_H = 18
local PAD = 12

--- 🔴 The rail used to be a FIXED 172px, and that made resizing useless for the one
--- problem it looked like it would solve. Rob, 23 aug: "het is te vaak afgebroken in de
--- linker kolom en hoe ik ook probeer ik krijg de rest niet te zien". He was dragging the
--- window wider and every extra pixel went to the body, so "3. Choosing trees - wi..." was
--- still "3. Choosing trees - wi...". A control that visibly does nothing for the thing you
--- are trying to fix is worse than no control.
---
--- So the rail takes a share of the width and grows with it. Capped, because past ~320px a
--- chapter title has run out of words and the reading column starts paying for nothing.
local function RailWidth(f)
	local w = (f and f:GetWidth()) or DEFAULT_W
	return math.max(RAIL_MIN_W, math.min(RAIL_MAX_W, w * 0.36))
end

local frame

local function L(key)
	return (ns.L and ns:L(key)) or key
end
local function SF(name)
	return (ns.MHScalableFont and ns.MHScalableFont(name)) or name
end

local function Settings()
	if not ns.db then
		return {}
	end
	if type(ns.db.courseWindow) ~= "table" then
		ns.db.courseWindow = {}
	end
	return ns.db.courseWindow
end

--- Position saved relative to UIParent's centre, in UI coordinates rather than the
--- frame's own — the same recipe the boss window uses, so a rescaled frame does not
--- walk across the screen between sessions.
local function ApplySavedPosition(f)
	local s = Settings()
	local scale = f:GetScale() or 1
	f:ClearAllPoints()
	if tonumber(s.x) and tonumber(s.y) and UIParent then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / scale, s.y / scale)
	else
		-- Beside the main window rather than on top of it: the whole point is to
		-- read the chapter and the game at the same time.
		f:SetPoint("CENTER", UIParent, "CENTER", 420 / scale, 0)
	end
end

local function SavePosition(f)
	local s = Settings()
	local scale = f:GetScale() or 1
	local cx, cy = f:GetCenter()
	local px, py = UIParent:GetCenter()
	if cx and py then
		s.x = (cx - px) * scale
		s.y = (cy - py) * scale
	end
end

local function SelectedKey(chapters)
	local want = ns.db and ns.db.profAcadChapter
	for _, c in ipairs(chapters) do
		if c.key == want then
			return want
		end
	end
	-- Unknown or vanished (a dropped profession takes its chapter with it): the
	-- first chapter not yet ticked is where someone returning to the course wants
	-- to be, not chapter one all over again.
	for _, c in ipairs(chapters) do
		if not c.done then
			return c.key
		end
	end
	return chapters[1] and chapters[1].key
end

local function Refresh()
	if not (frame and frame:IsShown()) then
		return
	end
	local chapters = (ns.MH_GetCourseChapters and ns.MH_GetCourseChapters()) or {}
	local selKey = SelectedKey(chapters)
	frame.rail:SetWidth(RailWidth(frame))

	for i, b in ipairs(frame.railBtns) do
		local c = chapters[i]
		if c then
			local mark = c.done
				and "|TInterface\\RaidFrame\\ReadyCheck-Ready:10:10:0:0|t "
				or "|TInterface\\Buttons\\UI-Quickslot2:10:10:0:0:64:64:64:64:64:64|t "
			-- Kept for the tooltip: even at the widest rail some chapter titles are
			-- longer than any sensible column, and a truncated title is a chapter you
			-- cannot identify. Hovering has to be able to answer it.
			b.fullTitle = ("%d. %s"):format(i, c.title or c.key)
			b.fs:SetText(("%s%d. %s"):format(mark, i, c.title or c.key))
			local sel = (c.key == selKey)
			b.isSel = sel
			b.hl:SetShown(sel)
			if sel then
				b.fs:SetTextColor(1, 0.82, 0.25)
			elseif c.done then
				b.fs:SetTextColor(0.55, 0.75, 0.55)
			else
				b.fs:SetTextColor(0.78, 0.76, 0.72)
			end
			local key = c.key
			b:SetScript("OnClick", function()
				ns.db = ns.db or {}
				ns.db.profAcadChapter = key
				frame.scroll:SetVerticalScroll(0)
				Refresh()
				-- Keep the panel in step, so the two surfaces never show different
				-- chapters at the same time.
				if ns.MH_RefreshProfessionAcademyPanel and ns._mhProfAcadPanelRef then
					ns.MH_RefreshProfessionAcademyPanel(ns._mhProfAcadPanelRef)
				end
			end)
			b:Show()
		else
			b:Hide()
		end
	end

	local title, body, task = nil, nil, nil
	if ns.MH_GetChapterText and selKey then
		title, body, task = ns.MH_GetChapterText(selKey)
	end
	frame.title:SetText(title or L("TAB_PROF_ACADEMY"))
	local text = body or ""
	if task and task ~= "" then
		text = text .. "\n\n|cffffd966" .. task .. "|r"
	end
	frame.body:SetText(text)
	frame.child:SetHeight(math.max((frame.body:GetStringHeight() or 0) + 20, 1))
end

local function Build()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperCourseWindow", UIParent, "BackdropTemplate")
	local s = Settings()
	f:SetSize(tonumber(s.w) or DEFAULT_W, tonumber(s.h) or DEFAULT_H)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	if f.SetResizable then
		f:SetResizable(true)
	end
	if f.SetResizeBounds then
		f:SetResizeBounds(MIN_W, MIN_H, 1000, 1200)
	end
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	f:Hide()
	ApplySavedPosition(f)

	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePosition(self)
	end)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)

	local head = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	head:SetFontObject(SF("GameFontNormalLarge"))
	head:SetPoint("TOPLEFT", f, "TOPLEFT", PAD + 4, -PAD - 2)
	head:SetPoint("RIGHT", close, "LEFT", -4, 0)
	head:SetJustifyH("LEFT")
	head:SetWordWrap(false)
	f.title = head

	-- Rail: full height of the window, which is the entire reason this exists.
	local rail = CreateFrame("Frame", nil, f)
	rail:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -8)
	rail:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD + 4, PAD + 4)
	rail:SetWidth(RailWidth(f))
	f.rail = rail

	-- Live while dragging the grip, not only on mouse-up: the whole complaint was that
	-- widening the window did nothing visible for the titles.
	f:SetScript("OnSizeChanged", function(self)
		if self.rail then
			self.rail:SetWidth(RailWidth(self))
		end
	end)

	f.railBtns = {}
	local maxRows = (ns.PROF_ACADEMY and ns.PROF_ACADEMY.chapters and #ns.PROF_ACADEMY.chapters) or 24
	for i = 1, maxRows do
		local b = CreateFrame("Button", nil, rail)
		b:SetHeight(RAIL_ROW_H)
		b:SetPoint("TOPLEFT", rail, "TOPLEFT", 0, -((i - 1) * RAIL_ROW_H))
		b:SetPoint("RIGHT", rail, "RIGHT", -6, 0)
		local hl = b:CreateTexture(nil, "BACKGROUND")
		hl:SetAllPoints(b)
		hl:SetColorTexture(1, 1, 1, 0.08)
		hl:Hide()
		b.hl = hl
		local fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetFontObject(SF("GameFontHighlightSmall"))
		fs:SetPoint("LEFT", b, "LEFT", 4, 0)
		fs:SetPoint("RIGHT", b, "RIGHT", -2, 0)
		fs:SetJustifyH("LEFT")
		fs:SetWordWrap(false)
		b.fs = fs
		b:SetScript("OnEnter", function(self)
			if not self.isSel then
				self.hl:Show()
			end
			-- Only when it is actually cut off. A tooltip that repeats a title you can
			-- already read is noise on all fourteen rows.
			local shown, avail = self.fs:GetStringWidth() or 0, self.fs:GetWidth() or 0
			if self.fullTitle and avail > 0 and shown > avail then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(self.fullTitle, 1, 0.82, 0.25, 1, true)
				GameTooltip:Show()
			end
		end)
		b:SetScript("OnLeave", function(self)
			if not self.isSel then
				self.hl:Hide()
			end
			GameTooltip:Hide()
		end)
		b:Hide()
		f.railBtns[i] = b
	end

	local scroll = CreateFrame("ScrollFrame", "MidnightHelperCourseWindowScroll", f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", rail, "TOPRIGHT", 10, 0)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, PAD + 4)
	f.scroll = scroll

	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(1, 1)
	scroll:SetScrollChild(child)
	f.child = child

	local body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	body:SetFontObject(SF("GameFontHighlightSmall"))
	body:SetPoint("TOPLEFT", child, "TOPLEFT", 0, 0)
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	body:SetTextColor(0.86, 0.84, 0.80)
	f.body = body

	scroll:SetScript("OnSizeChanged", function(_, w)
		if w and w > 0 then
			child:SetWidth(w)
			body:SetWidth(w)
			Refresh()
		end
	end)

	-- Resize grip, bottom right.
	local grip = CreateFrame("Button", nil, f)
	grip:SetSize(16, 16)
	grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -6, 6)
	grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	grip:SetScript("OnMouseDown", function()
		if f.StartSizing then
			f:StartSizing("BOTTOMRIGHT")
		end
	end)
	grip:SetScript("OnMouseUp", function()
		f:StopMovingOrSizing()
		local st = Settings()
		st.w, st.h = f:GetWidth(), f:GetHeight()
		SavePosition(f)
		Refresh()
	end)

	f:SetScript("OnShow", Refresh)
	frame = f
	return f
end

--- Public: open or close the course window. Also the launchpad's Open button.
function ns.ToggleProfessionCourseWindow()
	local f = Build()
	if not f then
		return
	end
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
		Refresh()
	end
end

--- Public: let the panel push a refresh here when the selection changes there.
function ns.RefreshProfessionCourseWindow()
	Refresh()
end
