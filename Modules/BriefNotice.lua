local _, ns = ...

--[[
	Midnight Helper — a short on-screen notice that fades by itself.

	⚠️ WHY. The delve chest route announced itself in chat, and Rob's verdict is the
	whole argument (16 aug): "het is dat ik weet dat ie dat doet" — he only notices it
	because he wrote the feature request. A new player clicks a button, chat scrolls a
	line among twenty others, and nothing appears to have happened.

	Chat is right for a record you may want to scroll back to. It is wrong for feedback
	that answers "did my click do anything", which has to be where the eyes already are
	and must not need dismissing.

	Deliberately NOT a popup with a button. Anything you have to close is a second thing
	to do; this shows up, holds, and leaves.

	🔴 25 Oct 2026, Rob in the Labyrinth: "heel erg lastig te lezen … Er staat namelijk eerst heel groot de tekst, de
	kamernaam … deze moet op een andere plek en hij is niet versleepbaar." It sat at TOP -180, right where Blizzard writes
	the big room name when you walk in, so the Hexmask hint was half hidden for its first seconds. Now: below the middle
	of the screen by default, draggable (the spot is remembered), and holding the mouse on it keeps it from fading. It
	takes the mouse now; it is small and leaves by itself, so the cost is one dead click on a 420-pixel strip.
]]

local frame

local function DB()
	ns.db = ns.db or {}
	ns.db.ui = ns.db.ui or {}
	return ns.db.ui
end

local function Place(f)
	f:ClearAllPoints()
	local p = DB().briefNoticePos
	if type(p) == "table" and p.x and p.y then
		f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", p.x, p.y)
	else
		-- Below the middle: the top of the screen is Blizzard's error and zone text.
		f:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
	end
end

local function StartFade(f, seconds)
	if f._timer then
		f._timer:Cancel()
		f._timer = nil
	end
	if not (C_Timer and C_Timer.NewTimer) then
		return
	end
	f._timer = C_Timer.NewTimer(seconds, function()
		f._timer = nil
		if f:IsMouseOver() then
			StartFade(f, 2) -- still being read: wait
			return
		end
		if f.FadeOut then
			f:FadeOut()
		elseif _G.UIFrameFadeOut then
			_G.UIFrameFadeOut(f, 0.6, 1, 0)
			-- FadeOut leaves the frame shown at alpha 0, which would keep an
			-- invisible frame in the strata forever. Hide it once the fade is done.
			C_Timer.After(0.7, function()
				if f:GetAlpha() < 0.05 then
					f:Hide()
					f:SetAlpha(1)
				end
			end)
		else
			f:Hide()
		end
	end)
end

local function Ensure()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperBriefNotice", UIParent, "BackdropTemplate")
	f:SetFrameStrata("HIGH")
	f:SetSize(420, 44)
	f:SetClampedToScreen(true)
	Place(f)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		if self._timer then
			self._timer:Cancel()
			self._timer = nil
		end
		self:SetAlpha(1)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- GetCenter and SetPoint offsets are both in this frame's own scale (Shift+scroll), so store them as they are.
		local x, y = self:GetCenter()
		if x and y then
			DB().briefNoticePos = { x = x, y = y }
		end
		Place(self)
		StartFade(self, 4)
	end)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 14,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	f:SetBackdropColor(0, 0, 0, 0.85)
	f:SetBackdropBorderColor(1, 0.82, 0.3, 0.9)

	local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	fs:SetPoint("CENTER", f, "CENTER", 0, 0)
	fs:SetWidth(396)
	fs:SetJustifyH("CENTER")
	fs:SetWordWrap(true)
	f._text = fs

	f:Hide()
	frame = f
	return f
end

--- Show `text` for `seconds` (default 5), then fade out.
--- Calling it again replaces what is on screen and restarts the clock, so a route that
--- advances three times shows three messages rather than stacking three frames.
--- @param text string
--- @param seconds number|nil
function ns.ShowBriefNotice(text, seconds)
	if type(text) ~= "string" or text == "" then
		return
	end
	local f = Ensure()
	f._text:SetText(text)

	-- Height follows the text: a two-line message in a one-line box is how a notice
	-- ends up with its second half cut off, and this one exists to be read at a glance.
	local h = (f._text:GetStringHeight() or 20) + 24
	f:SetHeight(math.max(44, h))

	if _G.UIFrameFadeRemoveFrame then
		_G.UIFrameFadeRemoveFrame(f) -- a new notice during a fade-out must not keep fading
	end
	if f.SetAlpha then
		f:SetAlpha(1)
	end
	f:Show()
	StartFade(f, tonumber(seconds) or 5)
end

--- Hide it now (used when something replaces the whole context, e.g. a route stopping).
function ns.HideBriefNotice()
	if not frame then
		return
	end
	if frame._timer then
		frame._timer:Cancel()
		frame._timer = nil
	end
	frame:Hide()
	frame:SetAlpha(1)
end
