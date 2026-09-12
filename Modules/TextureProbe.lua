local _, ns = ...

--[[
	Midnight Helper — /mh texturetest (Spec 37 §5, before any 4.0.0 layout code).

	Three questions the 4.0.0 look depends on, answered by eye in one window:
	  1. Does a PNG from our own Media folder load on 12.1?  (the 128 px test icon)
	  2. Does the power-of-two rule still hold?              (the same icon at 144 px)
	  3. Do the Platynator screenshots show, or are they green blocks? (Platy1.tga, 629x342)
	A Blizzard icon sits beside them as the positive control: if THAT is missing, the window
	is broken, not the textures.

	⚠️ A NEW texture file needs a FULL game restart, not /reload. A green or empty square
	after only a /reload proves nothing; the window says so.
	⚠️ There is no reliable Lua read-back for "this texture failed to load" that we have
	measured, so this probe does not pretend to judge. It shows, and Rob looks.
]]

local BASE = "Interface\\AddOns\\MidnightHelper\\Media\\"
local TESTS = {
	{ path = BASE .. "Icons\\mh_texturetest_128.png", label = "PNG 128x128", note = "power of two" },
	{ path = BASE .. "Icons\\mh_texturetest_144.png", label = "PNG 144x144", note = "not a power of two" },
	{ path = BASE .. "Platy1.tga", label = "TGA 629x342", note = "Platynator screenshot", w = 128, h = 70 },
	{ path = "Interface\\Icons\\INV_Misc_QuestionMark", label = "Blizzard icon", note = "control" },
}

local SLOT_W, GAP = 150, 12
local frame

local function Build()
	local f = CreateFrame("Frame", "MidnightHelperTextureProbe", UIParent, "BackdropTemplate")
	f:SetSize(#TESTS * SLOT_W + (#TESTS + 1) * GAP, 250)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 8, right = 8, top = 8, bottom = 8 },
	})
	f:SetBackdropColor(0.05, 0.04, 0.12, 0.95)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -16)
	title:SetText("Midnight Helper - texture test")

	for i, t in ipairs(TESTS) do
		local x = GAP + (i - 1) * (SLOT_W + GAP) + 8
		local tex = f:CreateTexture(nil, "ARTWORK")
		tex:SetSize(t.w or 128, t.h or 128)
		tex:SetPoint("TOP", f, "TOPLEFT", x + SLOT_W / 2, -48)
		tex:SetTexture(t.path)

		local lbl = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		lbl:SetPoint("TOP", f, "TOPLEFT", x + SLOT_W / 2, -184)
		lbl:SetWidth(SLOT_W)
		lbl:SetText(t.label)

		local note = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		note:SetPoint("TOP", lbl, "BOTTOM", 0, -2)
		note:SetWidth(SLOT_W)
		note:SetText(t.note)
	end

	local foot = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	foot:SetPoint("BOTTOM", 0, 14)
	foot:SetText("Green or empty square = not loaded. New files need a FULL restart, not /reload.")

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	tinsert(UISpecialFrames, f:GetName())
	return f
end

function ns.ShowTextureProbe()
	frame = frame or Build()
	frame:Show()
	print("|cffffcc00Midnight Helper:|r texture test open. Four squares: PNG 128, PNG 144, "
		.. "Platy1.tga and a Blizzard control icon. Tell Rob's Claude which ones show.")
end
