local _, ns = ...

--[[
	Midnight Helper — Valeera's delve progress, in a delve and nowhere else.

	WHY. Rob had a standalone bar showing "Valeera | Level 63 | 105964 / 187500 XP | 57%",
	liked it, and said the two things wrong with it for him: it is on screen all the time,
	and it lives in its own addon. On screen all the time is how a number becomes wallpaper.

	So this shows up when you enter a delve and goes away when you leave. That, and an X
	that means it, is the whole difference from the bar Rob already had — which he says is
	more than enough as it is.

	🔴 IT USED TO PREDICT RUNS. IT DOES NOT ANY MORE, AND THE REASON MATTERS.

	It claimed "only BOUNTIFUL delves add to it (measured 2026-08-20)" and turned the
	remainder into a number of bountiful runs. Rob disproved the premise from inside the
	game on 23 aug: he ran a level 3 delve — not bountiful — with Cisca and gained Valeera
	XP for it. Less than a bountiful run, but not nothing.

	The 20 aug "measurement" never measured that. It confirmed bountiful delves DO feed
	her and concluded the others do not — absence inferred from not having looked, with no
	positive control in the same run. That is the one mistake this project has made most
	often, and it shipped in six languages this time.

	Rob's second point retired the feature rather than the sentence: he does not believe the
	gain per delve is reliably measurable at all. Predicting "about six more runs" on top of
	a quantity that cannot be pinned down is not a service, it is false precision wearing a
	measurement's clothes. So the prediction, the per-run bookkeeping and the bountiful
	detection are all gone rather than patched — there is nothing left for them to be right
	about. What remains is what the bar knows and one true sentence: every delve adds to it,
	bountiful ones add more.

	⚠️ Do not rebuild the estimate without a real measurement first: same delve tier, both
	bountiful and not, several runs, gains written down. Until then it is a guess.

	⚠️ THE FACTION ID IS CHECKED, NOT TRUSTED. 2744 comes from another addon, which makes
	it a candidate. GetFriendshipReputation returns the faction's name, so we compare it
	before showing anything: a wrong id then produces silence instead of somebody else's
	reputation dressed up as Valeera's.
]]

local FACTION_ID = 2744
local NAME_MUST_CONTAIN = "valeera"
local TICK_SEC = 2

local frame, ticker, wasInDelve

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

--------------------------------------------------------------------------------
-- Companion Experience Chunks — the thing that actually feeds her
--------------------------------------------------------------------------------

--- ⚠️ CANDIDATES, NOT FACTS — these 14 ids come from Delve Companion XP Tracker v0.3.0,
--- which makes them a place to look and nothing more (CLAUDE.md). On 8 Aug 2026 an event
--- name copied out of four other addons threw "unknown event" on the next reload, and the
--- same night a spell name grep produced a Blackwing Mage's version of it.
---
--- So `/mh chunks` asks the client for each one and parks the answer in SavedVariables.
--- Nothing below this table is used for anything until that has run and the names come back
--- looking like Companion Experience Chunks.
---
--- WHY IT MATTERS. Rob asked on 23 Aug whether Valeera's gain does not depend on what you
--- pick up. It does, and this is the mechanism: chunks are physical loot in three
--- rarities. That is why a non-bountiful delve still pays, why bountiful pays more, and why
--- "XP per run" was never a quantity we could have measured.
local CHUNK_CANDIDATES = {
	-- rarity as the other addon labels it; ours is confirmed from the client instead.
	[228071] = "uncommon", [254756] = "uncommon", [235504] = "uncommon", [232047] = "uncommon",
	[228072] = "rare",     [254757] = "rare",     [235503] = "rare",     [232046] = "rare",
	[254869] = "epic",     [228073] = "epic",     [232045] = "epic",     [235502] = "epic",
	[254748] = "epic",     [235607] = "epic",
}

--- /mh chunks — resolve every candidate id against the client and save the result.
---
--- Items are not always cached, and an uncached id returns nil rather than "does not
--- exist". Those two look identical and only one of them is a finding, so this requests
--- the data first and reports how many actually answered.
function ns.ProbeCompanionChunks()
	local prefix = "|cffffcc00Midnight Helper|r"
	if not (C_Item and C_Item.GetItemInfo) then
		print(prefix .. " C_Item.GetItemInfo unavailable.")
		return
	end
	local ids = {}
	for id in pairs(CHUNK_CANDIDATES) do
		ids[#ids + 1] = id
	end
	table.sort(ids)

	for _, id in ipairs(ids) do
		if C_Item.RequestLoadItemDataByID then
			pcall(C_Item.RequestLoadItemDataByID, id)
		end
	end

	-- Give the client a moment to answer, then read. Reading in the same frame as the
	-- request is how you measure "not cached yet" and call it "does not exist".
	local function report()
		ns.db = ns.db or {}
		local out, answered = {}, 0
		for _, id in ipairs(ids) do
			local ok, name, _, quality = pcall(C_Item.GetItemInfo, id)
			local row = {
				id = id,
				claimed = CHUNK_CANDIDATES[id],
				name = (ok and name) or nil,
				quality = (ok and quality) or nil,
			}
			if row.name then
				answered = answered + 1
			end
			out[#out + 1] = row
			print(("   %d  %-10s %s  q=%s"):format(
				id, row.claimed, tostring(row.name or "|cffff5555no answer|r"),
				tostring(row.quality)))
		end
		ns.db.chunkProbe = out
		print(("%s %d of %d ids answered."):format(prefix, answered, #ids))
		if answered == 0 then
			print("   |cffff5555Zero answers means the probe is broken, not that the ids are wrong.|r")
		end
		print("   |cffffff78Now type /reload|r — SavedVariables only reach disk on reload or logout.")
	end

	print(prefix .. " asking the client about " .. #ids .. " Companion Experience Chunk ids...")
	if C_Timer and C_Timer.After then
		C_Timer.After(1.5, report)
	else
		report()
	end
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

	-- How much is left, and the one thing about it that is actually known.
	local big = BreakUpLargeNumbers or function(n) return n end
	return head .. "\n" .. L("VALEERA_LEFT_FMT"):format(big(left)),
		(span > 0) and (into / span) or 0
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
		-- ⚠️ The X used to mean "this delve only", and it reset on the way out. For anyone
		-- who simply does not want the popup that is not a close button, it is a chore
		-- repeated every single delve -- the same "it is always there" complaint this
		-- feature was built to answer, wearing a different hat (Rob, 23 aug).
		-- So closing it means closing it. And it says how to get it back, in chat, because
		-- a setting nobody can find is the same as no setting.
		Settings().off = true
		f:Hide()
		-- ns:PrintChat, colon-declared in Locales/Locale.lua. ns.Print does not exist --
		-- I wrote it from memory and grep caught it, which is the whole reason for the rule.
		if ns.PrintChat then
			ns:PrintChat(L("VALEERA_OFF_HINT"))
		else
			print(L("VALEERA_OFF_HINT"))
		end
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
		Settings().off = true
		f:Hide()
	else
		-- Asking for it by hand is the way back in after the X.
		Settings().off = false
		f:Show()
		Refresh()
	end
end

--------------------------------------------------------------------------------
-- Show in a delve, hide outside it
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

local function Tick()
	local inDelve = InDelve()
	if inDelve and not wasInDelve then
		if not Settings().off then
			local f = Build()
			f:Show()
			Refresh()
		end
	elseif not inDelve and wasInDelve then
		if frame then
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
