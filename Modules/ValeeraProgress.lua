local _, ns = ...

--[[
	Midnight Helper — Valeera's delve progress, in a delve and nowhere else.

	WHY. Rob had a standalone bar showing "Valeera | Level 63 | 105964 / 187500 XP | 57%",
	liked it, and said the two things wrong with it for him: it is on screen all the time,
	and it lives in its own addon. On screen all the time is how a number becomes wallpaper.

	So this shows up when you enter a delve and goes away when you leave.

	⚠️ AND IT SAYS THE HALF A BAR CANNOT. A percentage tells you where you are, not what to
	do about it. Only BOUNTIFUL delves feed this — measured 2026-08-20, and it is the thing
	no progress bar knows — so the number that actually helps is "how many bountiful runs
	is that". We do not hardcode a figure for it: the addon watches your own runs and
	learns the gain from them. Until it has seen one, it says so rather than guessing.

	⚠️ THE FACTION ID IS CHECKED, NOT TRUSTED. 2744 comes from another addon, which makes
	it a candidate. GetFriendshipReputation returns the faction's name, so we compare it
	before showing anything: a wrong id then produces silence instead of somebody else's
	reputation dressed up as Valeera's.
]]

local FACTION_ID = 2744
local NAME_MUST_CONTAIN = "valeera"
local TICK_SEC = 2

local frame, ticker, wasInDelve, enterSnapshot

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
	if type(ns.db.valeera) ~= "table" then
		ns.db.valeera = {}
	end
	return ns.db.valeera
end

--- Current standing, or nil when unreadable or when the id turns out to be someone else.
local function GetValeera()
	if not (C_GossipInfo and C_GossipInfo.GetFriendshipReputation) then
		return nil
	end
	local ok, d = pcall(C_GossipInfo.GetFriendshipReputation, FACTION_ID)
	if not ok or type(d) ~= "table" then
		return nil
	end
	-- The id is a candidate until the game agrees it is hers.
	local who = tostring(d.name or "")
	if who ~= "" and not who:lower():find(NAME_MUST_CONTAIN, 1, true) then
		return nil
	end
	local cur = tonumber(d.standing)
	local lo = tonumber(d.reactionThreshold) or 0
	local hi = tonumber(d.nextThreshold)
	if not cur then
		return nil
	end
	local level
	if type(d.reaction) == "number" then
		level = d.reaction
	elseif type(d.reaction) == "string" then
		level = tonumber(d.reaction:match("(%d+)"))
	end
	return {
		name = who ~= "" and who or "Valeera",
		level = level,
		cur = cur,
		lo = lo,
		hi = hi,
		maxed = (hi == nil) or (hi <= lo),
	}
end

--- Average XP a bountiful run has actually given THIS character, or nil.
--- Kept as a list rather than a running average so one odd run can be seen and,
--- if it ever matters, thrown out — an average hides the run that disagrees.
local function BountifulAverage()
	local s = Settings()
	local runs = s.bountifulGains
	if type(runs) ~= "table" or #runs == 0 then
		return nil
	end
	local total = 0
	for _, v in ipairs(runs) do
		total = total + v
	end
	return math.floor(total / #runs + 0.5), #runs
end

local function BuildText()
	local v = GetValeera()
	if not v then
		return nil
	end
	if v.maxed then
		return ("%s — %s"):format(v.name, L("VALEERA_MAXED")), 1
	end
	local into = v.cur - v.lo
	local span = (v.hi or 0) - v.lo
	local left = math.max(span - into, 0)
	local pct = (span > 0) and math.floor(into / span * 100 + 0.5) or 0

	local head = ("|cffffd966%s|r  %s %s   %s / %s  (%d%%)"):format(
		v.name,
		L("VALEERA_LEVEL"), tostring(v.level or "?"),
		BreakUpLargeNumbers and BreakUpLargeNumbers(into) or into,
		BreakUpLargeNumbers and BreakUpLargeNumbers(span) or span,
		pct)

	-- The half a bar cannot say.
	local avg, runs = BountifulAverage()
	local tail
	if avg and avg > 0 then
		tail = L("VALEERA_LEFT_RUNS_FMT"):format(
			BreakUpLargeNumbers and BreakUpLargeNumbers(left) or left,
			math.max(math.ceil(left / avg), 1),
			BreakUpLargeNumbers and BreakUpLargeNumbers(avg) or avg,
			runs)
	else
		tail = L("VALEERA_LEFT_UNMEASURED_FMT"):format(
			BreakUpLargeNumbers and BreakUpLargeNumbers(left) or left)
	end
	return head .. "\n" .. tail, (span > 0) and (into / span) or 0
end

local function Refresh()
	if not (frame and frame:IsShown()) then
		return
	end
	local text, frac = BuildText()
	if not text then
		frame.text:SetText(L("VALEERA_UNREADABLE"))
		frame.fill:SetWidth(1)
		return
	end
	frame.text:SetText(text)
	-- Grow to fit. A fixed height was wrong the moment the sentence ran to three
	-- lines: the text drew straight over the bar and past the bottom edge. The bar
	-- is anchored to the bottom, so the frame has to make room for the words above it.
	local textH = frame.text:GetStringHeight() or 0
	frame:SetHeight(math.max(textH + 44, 60))
	local w = math.max((frame:GetWidth() - 24) * (frac or 0), 1)
	frame.fill:SetWidth(w)
end

local function Build()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperValeeraPopup", UIParent, "BackdropTemplate")
	local s = Settings()
	f:SetSize(tonumber(s.w) or 320, 74)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true, tileSize = 32, edgeSize = 20,
			insets = { left = 6, right = 6, top = 6, bottom = 6 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.94)
	end
	f:ClearAllPoints()
	local scale = f:GetScale() or 1
	if tonumber(s.x) and tonumber(s.y) then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / scale, s.y / scale)
	else
		f:SetPoint("TOP", UIParent, "TOP", 0, -140)
	end
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) self:StartMoving() end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local st = Settings()
		local sc = self:GetScale() or 1
		local cx, cy = self:GetCenter()
		local px, py = UIParent:GetCenter()
		if cx and py then
			st.x, st.y = (cx - px) * sc, (cy - py) * sc
		end
	end)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
	close:SetScript("OnClick", function()
		-- Dismissed for THIS delve only; entering the next one shows it again.
		f._userDismissed = true
		f:Hide()
	end)

	local text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetFontObject(SF("GameFontHighlightSmall"))
	text:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	-- Clear of the close button, which sits in the top right corner.
	text:SetPoint("RIGHT", f, "RIGHT", -28, 0)
	text:SetJustifyH("LEFT")
	text:SetWordWrap(true)
	text:SetSpacing(2)
	f.text = text

	local track = f:CreateTexture(nil, "ARTWORK")
	track:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 10)
	track:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 10)
	track:SetHeight(6)
	track:SetColorTexture(0.12, 0.12, 0.16, 0.9)

	local fill = f:CreateTexture(nil, "OVERLAY")
	fill:SetPoint("TOPLEFT", track, "TOPLEFT", 0, 0)
	fill:SetPoint("BOTTOM", track, "BOTTOM", 0, 0)
	fill:SetColorTexture(0.35, 0.62, 0.95, 1)
	fill:SetWidth(1)
	f.fill = fill

	f:Hide()
	frame = f
	return f
end

--- Public: toggle by hand (/mh valeera and the Pop-out windows card).
function ns.ToggleValeeraPopup()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f._userDismissed = false
		f:Show()
		Refresh()
	end
end

--------------------------------------------------------------------------------
-- Show in a delve, hide outside it, and learn what a run is worth
--------------------------------------------------------------------------------

local function InDelve()
	if ns.IsDelveInstanceInProgress then
		local ok, res = pcall(ns.IsDelveInstanceInProgress, ns)
		if ok then
			return res and true or false
		end
	end
	return false
end

--- On leaving, compare against the snapshot taken on entry. A gain only counts as a
--- bountiful gain when we could actually tell the delve WAS bountiful — an unknown
--- delve is not filed as one, because a wrong number here would quietly turn into
--- "about six runs" advice that is off by a factor.
local function OnLeftDelve()
	local before = enterSnapshot
	enterSnapshot = nil
	if not before then
		return
	end
	local v = GetValeera()
	if not (v and before.cur) then
		return
	end
	local gain = v.cur - before.cur
	if gain <= 0 then
		return
	end
	if not before.bountiful then
		return
	end
	local s = Settings()
	if type(s.bountifulGains) ~= "table" then
		s.bountifulGains = {}
	end
	s.bountifulGains[#s.bountifulGains + 1] = gain
	-- Keep the last handful: the reward has changed with patches before, and an
	-- average over a year of runs would hide that it moved.
	while #s.bountifulGains > 8 do
		table.remove(s.bountifulGains, 1)
	end
end

local function Tick()
	local inDelve = InDelve()
	if inDelve and not wasInDelve then
		local v = GetValeera()
		-- The name comes from DelveHistory, which already resolves it from the
		-- scenario text and the POI list. Guessing it a second time here would be a
		-- second thing to get wrong.
		local name
		if ns.GetCurrentDelveRun then
			local okN, n = pcall(ns.GetCurrentDelveRun)
			name = okN and n or nil
		end
		local bountiful = false
		if name and ns.IsDelveBountiful then
			local okB, res = pcall(ns.IsDelveBountiful, name)
			bountiful = (okB and res) and true or false
		end
		enterSnapshot = v and { cur = v.cur, bountiful = bountiful } or nil
		local f = Build()
		if not f._userDismissed then
			f:Show()
			Refresh()
		end
	elseif not inDelve and wasInDelve then
		OnLeftDelve()
		if frame then
			frame._userDismissed = false
			frame:Hide()
		end
	elseif inDelve and frame and frame:IsShown() then
		Refresh()
	end
	wasInDelve = inDelve
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if not ticker and C_Timer and C_Timer.NewTicker then
		ticker = C_Timer.NewTicker(TICK_SEC, Tick)
	end
end)
