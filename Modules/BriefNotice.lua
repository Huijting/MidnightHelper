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
	to do; this shows up, holds, and leaves. It also takes no mouse input, so it can
	never swallow a click meant for the game underneath it.
]]

local frame

local function Ensure()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperBriefNotice", UIParent, "BackdropTemplate")
	f:SetFrameStrata("HIGH")
	f:SetSize(420, 44)
	-- Below the middle of the screen: the top is crowded with Blizzard's own error and
	-- zone text, and covering those to announce a waypoint would be a poor trade.
	f:SetPoint("TOP", UIParent, "TOP", 0, -180)
	f:EnableMouse(false)
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

	if f._timer then
		f._timer:Cancel()
		f._timer = nil
	end
	if f.SetAlpha then
		f:SetAlpha(1)
	end
	f:Show()

	if C_Timer and C_Timer.NewTimer then
		f._timer = C_Timer.NewTimer(tonumber(seconds) or 5, function()
			f._timer = nil
			if f.FadeOut then
				f:FadeOut()
			elseif _G.UIFrameFadeOut then
				_G.UIFrameFadeOut(f, 0.6, 1, 0)
				-- FadeOut leaves the frame shown at alpha 0, which would keep an
				-- invisible frame in the strata forever. Hide it once the fade is done.
				C_Timer.After(0.7, function()
					f:Hide()
					f:SetAlpha(1)
				end)
			else
				f:Hide()
			end
		end)
	end
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
