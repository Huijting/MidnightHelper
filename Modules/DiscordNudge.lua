local _, ns = ...

--[[
	Midnight Helper — "join the Discord" nudge (Spec 15), second consumer of the
	nudge framework after TranslateNudge.

	A dismissable card on This Week plus a permanent Settings row, so someone who
	dismisses it can still find the invite later. WoW cannot open a URL, so the
	action prints the link to chat AND opens a copy box — chat alone is easy to
	miss in a busy log.

	The invite is a NEVER-EXPIRING link (verified 2026-07-17 against Discord's
	invite API: expires_at = null, guild "Midnight Helper"). A default Discord
	invite dies after 24h or 7 days; if this link is ever regenerated it MUST be
	set to "Never expire" again, or every shipped copy of the addon points at a
	dead invite.

	never-lie: the card invites, it does not pressure. The body says the addon
	stays free either way, and dismissing costs the user nothing.
]]

local DISCORD_INVITE = "https://discord.gg/kBHaHcsASQ"

--------------------------------------------------------------------------------
-- Copy box
--------------------------------------------------------------------------------

-- A small movable dialog holding a pre-selected, read-only link.
-- NOTE: MH now has several near-identical copy boxes (ConsumablesPanel,
-- PawnExport, Platynator). Worth folding into one ns.ShowCopyBox helper if a
-- fourth shows up; not refactoring released modules for this one.
local copyFrame

local function showCopyBox(text, title)
	if not copyFrame then
		local f = CreateFrame("Frame", "MidnightHelperDiscordCopyBox", UIParent, "BackdropTemplate")
		f:SetSize(440, 120)
		f:SetPoint("CENTER")
		f:SetFrameStrata("DIALOG")
		f:EnableMouse(true)
		f:SetMovable(true)
		f:RegisterForDrag("LeftButton")
		f:SetScript("OnDragStart", f.StartMoving)
		f:SetScript("OnDragStop", f.StopMovingOrSizing)
		if f.SetBackdrop then
			f:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
				tile = true, tileSize = 32, edgeSize = 32,
				insets = { left = 8, right = 8, top = 8, bottom = 8 },
			})
		end

		f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		f.title:SetPoint("TOP", 0, -14)

		local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
		eb:SetSize(390, 32)
		eb:SetPoint("CENTER", 0, -4)
		eb:SetAutoFocus(false)
		eb:SetScript("OnEscapePressed", function() f:Hide() end)
		eb:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
		-- Read-only by restore: typing snaps the link back, so the text stays copyable
		-- and correct. The restoring SetText fires OnTextChanged again with user=false,
		-- which this branch ignores — no loop.
		eb:SetScript("OnTextChanged", function(self, user)
			if user then
				self:SetText(self._t or "")
				self:HighlightText()
			end
		end)
		f.eb = eb

		local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", 2, 2)

		f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		f.hint:SetPoint("BOTTOM", 0, 14)

		-- Esc closes it even when the edit box has lost focus.
		tinsert(UISpecialFrames, "MidnightHelperDiscordCopyBox")

		copyFrame = f
	end

	copyFrame.title:SetText(title or "")
	copyFrame.eb._t = text or ""
	copyFrame.eb:SetText(text or "")
	copyFrame.eb:SetCursorPosition(0)
	copyFrame.hint:SetText(ns:L("DISCORD_COPY_HINT"))
	copyFrame:Show()
	-- Defer off the current stack: the /mh discord path runs this inside the chat
	-- editbox's ParseText, where grabbing focus mid-parse errors. The nudge-card
	-- button doesn't hit that, but this covers both. pcall so it can never break.
	C_Timer.After(0, function()
		if copyFrame:IsShown() then
			pcall(copyFrame.eb.SetFocus, copyFrame.eb)
			pcall(copyFrame.eb.HighlightText, copyFrame.eb)
		end
	end)
end

--------------------------------------------------------------------------------
-- Action (also reachable via /mh discord)
--------------------------------------------------------------------------------

function ns.ShowDiscordInvite()
	print(("|cffe8c36a%s|r — %s %s"):format(ns:L("MAIN_TITLE"), ns:L("DISCORD_CHAT"), DISCORD_INVITE))
	showCopyBox(DISCORD_INVITE, ns:L("DISCORD_TITLE"))
end

ns.RegisterNudge({
	id = "discord",
	-- No condition: everyone is welcome. The framework hides the card once
	-- dismissed, and the Settings row keeps it findable after that.
	when = function() return true end,
	title = "DISCORD_NUDGE_TITLE",
	body = "DISCORD_NUDGE_BODY",
	actionLabel = "DISCORD_NUDGE_BTN",
	action = function() ns.ShowDiscordInvite() end,
	settings = true,
})
