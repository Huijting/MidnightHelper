local addonName, ns = ...

--[[
	Midnight Helper — Details! damage meter profile (internal Addons sub-module).

	Same shape as the Platynator page: a string you can copy, an explanation, and
	nothing that reaches into somebody else's addon.

	⚠️ IT COPIES, IT DOES NOT IMPORT. Details can almost certainly be handed a profile
	by an addon, and doing so would save a paste — but it would also raise three
	questions nobody has answered: whether their API sanctions it, whether the string is
	tied to a Details version, and whether importing REPLACES a player's existing
	profiles instead of adding one. Overwriting somebody's damage meter uninvited is not
	a trade we get to make. Letting them paste it makes all three their choice.

	⚠️ AN OFFER, NOT A REQUIREMENT — Rob's words, and the same line the bar preset takes.
	Nothing here changes anything on its own. The page says outright that Details is
	optional and that the profile is one way of setting it up, not the way.

	REPLACING THE STRING: only `PROFILE` below. Rob exports a fresh one whenever he
	changes his layout, and the rest of this file does not care what it holds.
]]

--- Exported from Rob's live client, 11 Aug 2026. Superseded whenever he re-exports.
local PROFILE =
	"D!ProfileV2-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"

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

local function DetailsLoaded()
	if not (C_AddOns and C_AddOns.IsAddOnLoaded) then
		return false
	end
	local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "Details")
	return ok and loaded or false
end

ns.RegisterAddonSubTab({
	id = "detailsprofile",
	label = "Details!",
	Build = function(parent)
		ns.UI = ns.UI or {}
		ns.UI.AddonPanel = ns.UI.AddonPanel or {}

		local f = CreateFrame("Frame", "MidnightHelperDetailsPanel", parent)
		f:SetAllPoints()
		if f.SetClipsChildren then
			f:SetClipsChildren(true)
		end

		local header = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		header:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -3)
		header:SetJustifyH("LEFT")
		header:SetText(ns:L("DETAILS_TITLE"))
		header:SetTextColor(0.92, 0.84, 0.52)

		--- Whether Details is even installed. A page offering a profile for an addon the
		--- player does not have should say so rather than hand out a string that cannot
		--- go anywhere.
		local status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		status:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -6)
		status:SetJustifyH("LEFT")

		local intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		intro:SetPoint("TOPLEFT", status, "BOTTOMLEFT", 0, -8)
		intro:SetPoint("RIGHT", f, "RIGHT", -16, 0)
		intro:SetJustifyH("LEFT")
		intro:SetSpacing(2)
		intro:SetText(ns:L("DETAILS_INTRO"))

		local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		lbl:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", 0, -12)
		lbl:SetJustifyH("LEFT")
		lbl:SetText(ns:L("DETAILS_STRING_LABEL"))
		lbl:SetTextColor(1, 0.9, 0.6)

		--- The string, in a box you can select and copy.
		---
		--- ⚠️ `SetMaxLetters(0)` and `SetMaxBytes(0)`: this is roughly 6 000 characters and
		--- an EditBox silently truncates past its default limit. A profile string cut in
		--- half still looks like a profile string.
		local box = CreateFrame("EditBox", "MidnightHelperDetailsProfileBox", f)
		box:SetMultiLine(false)
		box:SetAutoFocus(false)
		box:SetMaxLetters(0)
		if box.SetMaxBytes then
			box:SetMaxBytes(0)
		end
		box:SetFontObject(GameFontHighlightSmall)
		box:SetTextColor(0.8, 0.85, 0.95)
		box:SetText(PROFILE)
		box:SetCursorPosition(0)
		box:EnableMouse(true)
		box:SetPoint("TOPLEFT", lbl, "BOTTOMLEFT", 0, -4)
		box:SetPoint("RIGHT", f, "RIGHT", -16, 0)
		box:SetHeight(20)
		box:SetScript("OnEscapePressed", box.ClearFocus)
		box:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
		end)
		-- Never let it be edited into something broken and then copied.
		box:SetScript("OnTextChanged", function(self, user)
			if user then
				self:SetText(PROFILE)
				self:HighlightText()
			end
		end)

		local bg = CreateFrame("Frame", nil, f, "BackdropTemplate")
		bg:SetPoint("TOPLEFT", box, "TOPLEFT", -4, 3)
		bg:SetPoint("BOTTOMRIGHT", box, "BOTTOMRIGHT", 4, -3)
		bg:SetFrameLevel(math.max(0, f:GetFrameLevel()))
		if bg.SetBackdrop then
			bg:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
				insets = { left = 1, right = 1, top = 1, bottom = 1 },
			})
			bg:SetBackdropColor(0.04, 0.04, 0.06, 0.9)
			bg:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)
		end

		local copyBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		copyBtn:SetSize(150, 22)
		copyBtn:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 0, -8)
		copyBtn:SetText(ns:L("DETAILS_SELECT"))
		copyBtn:SetScript("OnClick", function()
			box:SetFocus()
			box:HighlightText()
			print(Prefix() .. " " .. ns:L("DETAILS_SELECTED"))
		end)

		local how = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		how:SetPoint("TOPLEFT", copyBtn, "BOTTOMLEFT", 0, -10)
		how:SetPoint("RIGHT", f, "RIGHT", -16, 0)
		how:SetJustifyH("LEFT")
		how:SetSpacing(2)
		how:SetText(ns:L("DETAILS_HOWTO"))

		f:SetScript("OnShow", function()
			if DetailsLoaded() then
				status:SetText(ns:L("DETAILS_INSTALLED"))
				status:SetTextColor(0.45, 0.92, 0.55)
			else
				status:SetText(ns:L("DETAILS_MISSING"))
				status:SetTextColor(0.95, 0.72, 0.35)
			end
		end)

		ns.UI.AddonPanel.detailsprofile = f
		return f
	end,
})
