--[[
	MidnightHelper — Platynator (internal Addons sub-module).
	Wago + custom profile rows, instruction note, centered gallery (main + 3 thumbnails).
]]

local addonName, ns = ...

local WAGO_URL = "https://wago.io/q1ijhrt1U"

local PATH_PLATY1 = "Interface\\AddOns\\MidnightHelper\\Media\\Platy1.tga"
local PATH_PLATY2 = "Interface\\AddOns\\MidnightHelper\\Media\\Platy2.tga"
local PATH_PLATY3 = "Interface\\AddOns\\MidnightHelper\\Media\\Platy3.tga"

local PATHS = { PATH_PLATY1, PATH_PLATY2, PATH_PLATY3 }

local MAIN_W, MAIN_H = 520, 250
local THUMB_W, THUMB_H = 140, 80
local THUMB_GAP = 10
local THUMB_TEX_INSET = 3
local IMPORT_EDIT_H = 18
local LABEL_LEFT = 20
local EDIT_BOX_X_OFFSET = 180
local EDIT_WIDTH = 420
local PROFILE_COPY_BTN_W = 140
local ROW2_BTN_TO_EDIT_GAP = EDIT_BOX_X_OFFSET - LABEL_LEFT - PROFILE_COPY_BTN_W
local NOTE_WRAP_WIDTH = 550
local GAP_WAGO_TO_PROFILE_ROW = 8
local GAP_PROFILE_ROW_TO_NOTE = 4
local GAP_NOTE_TO_MAIN = 10
local GAP_MAIN_TO_THUMBS = 6
local FOOTER_BOTTOM_INSET = 6
local HEADER_LEFT = 8

local function polishTexture(tex)
	if not tex then
		return
	end
	tex:SetAlpha(1)
	if tex.SetDesaturated then
		tex:SetDesaturated(false)
	end
end

local function createEditBoxBackdrop(parent, editBox)
	local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	if not bg.SetBackdrop then
		return nil
	end
	bg:SetFrameLevel(math.max(0, editBox:GetFrameLevel() - 1))
	bg:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		tile = true,
		tileSize = 8,
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	bg:SetBackdropColor(0.12, 0.12, 0.14, 0.5)
	bg:SetBackdropBorderColor(0.28, 0.28, 0.32, 0.65)
	return bg
end

local function syncEditBackdrop(bg, editBox)
	if not bg or not editBox then
		return
	end
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", editBox, "TOPLEFT", -2, 2)
	bg:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 2, -2)
end

ns.RegisterAddonSubTab({
	id = "platynator",
	label = "Platynator",
	Build = function(parent)
		ns.UI = ns.UI or {}
		ns.UI.AddonPanel = ns.UI.AddonPanel or {}
		ns.UI.AddonPanel.platynator = ns.UI.AddonPanel.platynator or {}

		local f = CreateFrame("Frame", "MidnightHelperPlatynatorPanel", parent)
		f:SetAllPoints()
		if f.SetClipsChildren then
			f:SetClipsChildren(true)
		end

		local header = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		header:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -3)
		header:SetJustifyH("LEFT")
		header:SetText("MF Platynator — Visual Guide")
		header:SetTextColor(0.92, 0.84, 0.52)

		local wagoLbl = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		wagoLbl:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
		wagoLbl:SetJustifyH("LEFT")
		wagoLbl:SetText("Wago Link:")

		local linkEdit = CreateFrame("EditBox", "MidnightHelperPlatynatorWagoLink", f)
		linkEdit:SetMultiLine(false)
		linkEdit:SetAutoFocus(false)
		linkEdit:SetMaxLetters(0)
		if linkEdit.SetMaxBytes then
			linkEdit:SetMaxBytes(0)
		end
		linkEdit:SetFontObject(GameFontHighlightSmall)
		linkEdit:SetTextColor(0.93, 0.91, 0.86)
		linkEdit:SetText(WAGO_URL)
		linkEdit:EnableMouse(true)
		linkEdit:SetFrameLevel(f:GetFrameLevel() + 5)

		local linkEditBg = createEditBoxBackdrop(f, linkEdit)
		if linkEditBg then
			syncEditBackdrop(linkEditBg, linkEdit)
		end

		linkEdit:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)
		linkEdit:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				self:SetFocus()
				self:SetText(WAGO_URL)
				self:HighlightText()
			end
		end)
		linkEdit:SetScript("OnEditFocusGained", function(self)
			self:SetText(WAGO_URL)
			self:HighlightText()
		end)
		linkEdit:SetScript("OnTextChanged", function(self, userInput)
			if not userInput then
				return
			end
			self:SetText(WAGO_URL)
			self:HighlightText()
		end)

		local profileEdit = CreateFrame("EditBox", "MidnightHelperPlatynatorProfileEditBox", f)
		profileEdit:SetMultiLine(false)
		profileEdit:SetAutoFocus(false)
		profileEdit:SetMaxLetters(0)
		if profileEdit.SetMaxBytes then
			profileEdit:SetMaxBytes(0)
		end
		profileEdit:SetFontObject(GameFontHighlightSmall)
		profileEdit:SetTextColor(1, 1, 1)
		profileEdit:SetText("")
		profileEdit:EnableMouse(true)
		profileEdit:SetFrameLevel(f:GetFrameLevel() + 5)

		local profileEditBg = createEditBoxBackdrop(f, profileEdit)
		if profileEditBg then
			syncEditBackdrop(profileEditBg, profileEdit)
		end

		profileEdit:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)

		local profileBtn = CreateFrame("Button", "MidnightHelperPlatynatorProfileBtn", f, "UIPanelButtonTemplate")
		profileBtn:SetSize(PROFILE_COPY_BTN_W, IMPORT_EDIT_H)
		profileBtn:SetText("Copy Inchy's Profile")
		if profileBtn.SetNormalFontObject then
			profileBtn:SetNormalFontObject(GameFontHighlightSmall)
		end
		if profileBtn.SetHighlightFontObject then
			profileBtn:SetHighlightFontObject(GameFontHighlightSmall)
		end
		profileBtn:SetScript("OnClick", function()
			local s = ns.CustomPlatyString
			if type(s) ~= "string" or s == "" then
				return
			end
			profileEdit:SetText("")
			profileEdit:SetText(s)
			profileEdit:SetFocus()
			profileEdit:HighlightText()
		end)

		local FOOTER_DEFAULT = "|cffffff78Note:|r Set Platynator to 'Alpha' in CurseForge for animations."

		local pasteHintFs = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		pasteHintFs:SetJustifyH("LEFT")
		pasteHintFs:SetTextColor(0.88, 0.86, 0.78)
		pasteHintFs:SetText(
			"Note: When importing this profile into Platynator, you can give it any name you like. After importing, ensure you select your new profile in the dropdown menu to activate it."
		)

		local footer = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		footer:SetJustifyH("RIGHT")
		footer:SetText(FOOTER_DEFAULT)

		local mainImage = f:CreateTexture(nil, "ARTWORK")
		mainImage:SetSize(MAIN_W, MAIN_H)
		mainImage:SetTexture(PATH_PLATY1)
		polishTexture(mainImage)

		local thumbRow = CreateFrame("Frame", "MidnightHelperPlatynatorThumbRow", f)
		thumbRow:SetHeight(THUMB_H)

		local thumbnailButtons = {}

		local function setMainByIndex(idx)
			local path = PATHS[idx]
			if path then
				mainImage:SetTexture(path)
				polishTexture(mainImage)
			end
		end

		for idx = 1, 3 do
			local path = PATHS[idx]
			local btn = CreateFrame("Button", "MidnightHelperPlatynatorThumb" .. idx, thumbRow, "BackdropTemplate")
			btn:SetSize(THUMB_W, THUMB_H)
			btn:SetBackdrop({
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				edgeSize = 10,
				insets = { left = 2, right = 2, top = 2, bottom = 2 },
			})
			btn:SetBackdropBorderColor(0.75, 0.62, 0.28, 1)
			btn:SetBackdropColor(0.06, 0.06, 0.08, 0.35)

			local t = btn:CreateTexture(nil, "ARTWORK")
			t:SetPoint("TOPLEFT", btn, "TOPLEFT", THUMB_TEX_INSET, -THUMB_TEX_INSET)
			t:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -THUMB_TEX_INSET, THUMB_TEX_INSET)
			t:SetTexture(path)
			polishTexture(t)
			btn._platyThumbTex = t

			btn:SetScript("OnClick", function()
				setMainByIndex(idx)
			end)
			btn:SetScript("OnEnter", function(self)
				self:SetBackdropBorderColor(1, 0.9, 0.45, 1)
				if self._platyThumbTex then
					self._platyThumbTex:SetAlpha(0.88)
				end
			end)
			btn:SetScript("OnLeave", function(self)
				self:SetBackdropBorderColor(0.75, 0.62, 0.28, 1)
				if self._platyThumbTex then
					self._platyThumbTex:SetAlpha(1)
				end
			end)

			thumbnailButtons[idx] = btn
		end

		local function layoutPlatynator()
			local pw = math.max(100, f:GetWidth())
			local rowW = THUMB_W * 3 + THUMB_GAP * 2
			local labelInset = LABEL_LEFT - HEADER_LEFT
			local editLeftOffset = EDIT_BOX_X_OFFSET - LABEL_LEFT
			local noteW = math.min(NOTE_WRAP_WIDTH, math.max(120, pw - LABEL_LEFT * 2))

			wagoLbl:ClearAllPoints()
			wagoLbl:SetPoint("TOPLEFT", header, "BOTTOMLEFT", labelInset, -2)

			linkEdit:ClearAllPoints()
			linkEdit:SetSize(EDIT_WIDTH, IMPORT_EDIT_H)
			linkEdit:SetPoint("TOP", wagoLbl, "TOP", 0, 0)
			linkEdit:SetPoint("LEFT", f, "LEFT", EDIT_BOX_X_OFFSET, 0)

			profileBtn:ClearAllPoints()
			profileBtn:SetPoint("TOPLEFT", linkEdit, "BOTTOMLEFT", -editLeftOffset, -GAP_WAGO_TO_PROFILE_ROW)

			profileEdit:ClearAllPoints()
			profileEdit:SetSize(EDIT_WIDTH, IMPORT_EDIT_H)
			profileEdit:SetPoint("TOP", profileBtn, "TOP", 0, 0)
			profileEdit:SetPoint("LEFT", profileBtn, "RIGHT", ROW2_BTN_TO_EDIT_GAP, 0)

			pasteHintFs:ClearAllPoints()
			pasteHintFs:SetPoint("TOPLEFT", profileEdit, "BOTTOMLEFT", -editLeftOffset, -GAP_PROFILE_ROW_TO_NOTE)
			pasteHintFs:SetWidth(noteW)

			mainImage:ClearAllPoints()
			mainImage:SetSize(MAIN_W, MAIN_H)
			mainImage:SetPoint("TOP", pasteHintFs, "BOTTOM", 0, -GAP_NOTE_TO_MAIN)
			mainImage:SetPoint("LEFT", f, "LEFT", math.max(LABEL_LEFT, (pw - MAIN_W) / 2))

			thumbRow:ClearAllPoints()
			thumbRow:SetHeight(THUMB_H)
			thumbRow:SetPoint("TOP", mainImage, "BOTTOM", 0, -GAP_MAIN_TO_THUMBS)
			thumbRow:SetPoint("LEFT", f, "LEFT", 8)
			thumbRow:SetPoint("RIGHT", f, "RIGHT", -8)

			footer:ClearAllPoints()
			footer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, FOOTER_BOTTOM_INSET)

			local innerPad = math.max(0, (thumbRow:GetWidth() - rowW) / 2)
			for idx, btn in ipairs(thumbnailButtons) do
				btn:ClearAllPoints()
				local x = innerPad + (idx - 1) * (THUMB_W + THUMB_GAP)
				btn:SetPoint("BOTTOMLEFT", thumbRow, "BOTTOMLEFT", x, 0)
			end

			syncEditBackdrop(linkEditBg, linkEdit)
			syncEditBackdrop(profileEditBg, profileEdit)
		end

		f:SetScript("OnShow", layoutPlatynator)
		f:SetScript("OnSizeChanged", layoutPlatynator)
		layoutPlatynator()

		ns.UI.AddonPanel.platynator.panel = f
		ns.UI.AddonPanel.platynator.header = header
		ns.UI.AddonPanel.platynator.wagoLinkLabel = wagoLbl
		ns.UI.AddonPanel.platynator.wagoEditBox = linkEdit
		ns.UI.AddonPanel.platynator.profileEditBox = profileEdit
		ns.UI.AddonPanel.platynator.profileCopyButton = profileBtn
		ns.UI.AddonPanel.platynator.importLabel = wagoLbl
		ns.UI.AddonPanel.platynator.importEditBox = linkEdit
		ns.UI.AddonPanel.platynator.pasteHintLabel = pasteHintFs
		ns.UI.AddonPanel.platynator.mainImage = mainImage
		ns.UI.AddonPanel.platynator.thumbRow = thumbRow
		ns.UI.AddonPanel.platynator.thumbnailButtons = thumbnailButtons
		ns.UI.AddonPanel.platynator.footer = footer
		ns.UI.AddonPanel.platynator.wagoEditBackdrop = linkEditBg
		ns.UI.AddonPanel.platynator.profileEditBackdrop = profileEditBg

		return f
	end,
})
