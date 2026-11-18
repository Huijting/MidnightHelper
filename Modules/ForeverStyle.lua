local _, ns = ...

--[[
	ForeverStyle.lua — WoW Forever: the style kit of the new overview (docs/forever/HUISSTIJL_PLAN_2026-11-17.md, step 1).
	Rob, 17 Nov 2026 (via Sparring 17-11), verbatim: "bij alle andere tabbladen, komt het uiteindelijk ook zo op deze
	manier eruit te zien? Want dat zou ik wel heel graag willen." → every page of the overview uses the same building
	blocks, so they live here and not in ForeverOverview.lua (where round 1-5 of style A grew them).

	ns.ForeverStyle (S):
	  S.T()                      the theme table (one look: A, "sfeervol boek")
	  S.Accent()                 class colour r, g, b
	  S.Font(fs, file, size, fallback, flags)   SetFont with the game's own font when the file cannot be used
	  S.Text(parent, role, size, color)         a font string; role = "head" | "head2" | "text" | "textB"
	  S.Tip(frame, title, body)  tooltip; frame.tipTitle/tipBody/tipSpell may change later
	  S.HoverOver(parent, region, title, body)  invisible hover area (dragging keeps working elsewhere)
	  S.Card(parent)             a card (flat, thin edge)
	  S.Label(card, text, tipKey)               small capital label at the top of a card
	  S.Chip(parent, text, color, w)            a small framed word (NOW / LATER)
	  S.Button(parent, w)        a button with :SetLabel(t) and :SetActive(bool)
	  S.SpellButton(parent, size)               a spell icon with the spell's own tooltip (set .tipSpell)
	  S.Circle(parent, layerSub)                a round texture (mask)
	  S.Scroll(card, top, bottom, step)          scrolling area with a slim thumb (Shift+wheel stays the window's)
	  S.Format(body)             **bold** → gold, "- " lines → bullets
	  S.SpellName(id), S.SpellIcon(id), S.Place(zone, x, y)
	Fonts: OFL, github.com/google/fonts (Media/Fonts, OFL-*.txt beside them). Nothing from the Forever Leveling Guide
	(All Rights Reserved): no code, text, data or textures of it.
]]

if not ns.IS_FOREVER then
	return
end

local S = {}
ns.ForeverStyle = S

local FONT_DIR = "Interface\\AddOns\\MidnightHelper\\Media\\Fonts\\"
local WHITE = "Interface\\Buttons\\WHITE8X8"
local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"

-- Theme A ("sfeervol boek"): own values, after the mockup C:\Users\RobHu\Desktop\mh_ontwerp.png.
S.THEMES = {
	A = {
		fonts = {
			head = FONT_DIR .. "CormorantSC-Bold.ttf",
			head2 = FONT_DIR .. "CormorantSC-SemiBold.ttf",
			text = FONT_DIR .. "AlegreyaSans-Regular.ttf",
			textB = FONT_DIR .. "AlegreyaSans-Medium.ttf",
		},
		fallback = { head = "Fonts\\MORPHEUS.TTF", head2 = "Fonts\\FRIZQT__.TTF", text = "Fonts\\FRIZQT__.TTF", textB = "Fonts\\FRIZQT__.TTF" },
		-- Fully opaque since 17 Nov 2026: at 0.97 a mob's nameplate ("Vile Fin Puddlejumper 100%") shone through behind
		-- the title - the "vague text" of Rob's How you play screenshot (sparring found it on his first Forever test).
		bgTop = { 0.16, 0.11, 0.07, 1 }, bgBottom = { 0.07, 0.05, 0.04, 1 },
		card = { 0.11, 0.08, 0.06, 0.88 }, edge = { 0.55, 0.42, 0.22, 0.55 },
		gold = { 0.86, 0.71, 0.42 }, label = { 0.93, 0.55, 0.22 }, text = { 0.92, 0.88, 0.80 }, dim = { 0.66, 0.60, 0.52 },
		seal = { 0.55, 0.10, 0.08 }, later = { 0.55, 0.52, 0.48 }, done = { 0.45, 0.85, 0.40 },
		buttonText = { 0.95, 0.92, 0.85 },
	},
	-- Theme B ("strak en modern") was built on 17 Nov 2026 and removed the same evening. Rob (via Sparring 17-11),
	-- verbatim: "ik denk dat wij gewoon gaan voor onze eerste stijl die we gemaakt hebben" and "Ja, B mag eruit." /
	-- "Je moet gewoon één mooi product maken." One look; the table stays so the kit reads its values from one place.
}

function S.T()
	return S.THEMES.A
end

-- Load the four font files at login (cure 1 above): a hidden string per file, so the client has them before the
-- overview is first opened.
do
	local pre = CreateFrame("Frame", nil, UIParent)
	pre:SetSize(1, 1)
	-- Off screen, not alpha 0: a string that is never drawn may never make the client load its font (AFGELEID).
	pre:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -200, 200)
	for _, file in pairs(S.THEMES.A.fonts) do
		local fs = pre:CreateFontString(nil, "OVERLAY")
		if fs:SetFont(file, 12, "") then
			fs:SetPoint("TOPLEFT")
			fs:SetText("Aa")
		end
	end
end

function S.Accent()
	local _, token = UnitClass("player")
	local c = token and (C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(token))
		or (RAID_CLASS_COLORS and token and RAID_CLASS_COLORS[token])
	if c then
		return c.r, c.g, c.b
	end
	return 0.4, 0.7, 1
end

-- Every font string the kit gave a font, with that font (weak keys: a string that is gone is forgotten).
-- Rob's first Forever test, 17 Nov 2026 (via sparring, screenshot): the FIRST time the overview opened after a full
-- restart, every tab button, "All tools" and the path names were EMPTY; after /reload all was fine. AFGELEID: a font
-- file from our own folder is not loaded yet at the first SetFont, so the string draws nothing until it is set again.
-- Two cures: (1) load the four files at login with a hidden string (below), (2) S.RefreshFonts() sets every font and
-- text again; the overview calls it shortly after it opens. S.FontProbe() counts strings with text but no width.
local fontOf = setmetatable({}, { __mode = "k" })

--- Set a font, falling back to the game's own when the file cannot be used.
function S.Font(fs, file, size, fallback, flags)
	local ok = fs:SetFont(file, size, flags or "")
	if not ok then
		fs:SetFont(fallback, size, flags or "")
	end
	fontOf[fs] = { file, size, fallback, flags }
end

--- Count the font strings that hold text but draw nothing (width 0): the empty-tab fault. { strings, empty }.
function S.FontProbe()
	local n, empty = 0, 0
	for fs in pairs(fontOf) do
		local t = fs.GetText and fs:GetText()
		if type(t) == "string" and t ~= "" and fs:IsVisible() then
			n = n + 1
			if (fs:GetStringWidth() or 0) <= 0 then
				empty = empty + 1
			end
		end
	end
	return n, empty
end

--- Set every font and every text again (see fontOf above). Cheap: a few hundred strings.
function S.RefreshFonts()
	for fs, f in pairs(fontOf) do
		local ok = fs:SetFont(f[1], f[2], f[4] or "")
		if not ok then
			fs:SetFont(f[3], f[2], f[4] or "")
		end
		local t = fs:GetText()
		if type(t) == "string" and t ~= "" then
			fs:SetText("")
			fs:SetText(t)
		end
	end
end

--- A font string in the theme's font for `role` ("head", "head2", "text", "textB").
function S.Text(parent, role, size, color)
	local t = S.T()
	local fs = parent:CreateFontString(nil, "OVERLAY")
	S.Font(fs, t.fonts[role] or t.fonts.text, size, t.fallback[role] or t.fallback.text)
	color = color or t.text
	fs:SetTextColor(color[1], color[2], color[3])
	fs:SetJustifyH("LEFT")
	fs:SetWordWrap(true)
	return fs
end

--- Tooltip on any frame. The text lives on the frame (tipTitle/tipBody/tipSpell), so a fill can change it later.
function S.Tip(frame, title, body)
	frame.tipTitle, frame.tipBody = title, body
	frame:EnableMouse(true)
	frame:HookScript("OnEnter", function(self)
		if not (self.tipTitle or self.tipSpell) then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self.tipSpell then
			GameTooltip:SetSpellByID(self.tipSpell)
		else
			GameTooltip:SetText(self.tipTitle, 1, 0.82, 0, 1, true)
			if self.tipBody and self.tipBody ~= "" then
				GameTooltip:AddLine(self.tipBody, 1, 1, 1, true)
			end
		end
		GameTooltip:Show()
	end)
	frame:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	return frame
end

--- An invisible hover area over a region (so the window can still be dragged everywhere else).
function S.HoverOver(parent, region, title, body)
	local h = CreateFrame("Frame", nil, parent)
	h:SetAllPoints(region)
	return S.Tip(h, title, body)
end

function S.Card(parent)
	local t = S.T()
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	f:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
	f:SetBackdropColor(t.card[1], t.card[2], t.card[3], t.card[4])
	f:SetBackdropBorderColor(t.edge[1], t.edge[2], t.edge[3], t.edge[4])
	return f
end

--- Small capital label at the top of a card ("DO THIS NOW"), with a tooltip that says what the card is for.
function S.Label(card, text, tipKey)
	local fs = S.Text(card, "head2", 12, S.T().label)
	fs:SetPoint("TOPLEFT", 14, -12)
	fs:SetText(text)
	if tipKey then
		S.HoverOver(card, fs, text, ns:L(tipKey))
	end
	return fs
end

--- A small framed word (NOW / LATER). :SetColor(r, g, b) recolours edge and text.
function S.Chip(parent, text, color, w)
	local c = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	c:SetSize(w or 64, 18)
	c:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
	c:SetBackdropColor(0, 0, 0, 0.3)
	c.t = S.Text(c, "head2", 11)
	c.t:SetPoint("CENTER")
	c.t:SetJustifyH("CENTER")
	c.t:SetText(text or "")
	function c:SetColor(r, g, b)
		self:SetBackdropBorderColor(r, g, b, 0.9)
		self.t:SetTextColor(r, g, b)
	end
	if color then
		c:SetColor(color[1], color[2], color[3])
	end
	return c
end

--- A button: dark, accent border, serif text. :SetActive(true) marks the open tab.
function S.Button(parent, w)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(w or 120, 24)
	b:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
	local r, g, bl = S.Accent()
	b:SetBackdropColor(r * 0.25, g * 0.25, bl * 0.25, 0.95)
	b:SetBackdropBorderColor(r, g, bl, 0.9)
	b.label = S.Text(b, "head2", 13, S.T().buttonText)
	b.label:SetPoint("CENTER")
	b.label:SetJustifyH("CENTER")
	b:SetScript("OnEnter", function(self)
		if not self.active then
			self:SetBackdropColor(r * 0.45, g * 0.45, bl * 0.45, 0.95)
		end
	end)
	b:SetScript("OnLeave", function(self)
		if not self.active then
			self:SetBackdropColor(r * 0.25, g * 0.25, bl * 0.25, 0.95)
		end
	end)
	-- The text shrinks until it fits inside the button (Rob's screenshot, 17 Nov 2026: "YOUR DIRECTION: PROTECTION" ran
	-- over both edges, and a label of a button below spilled out of its card). Never wider than the button.
	function b:SetLabel(t)
		local th = S.T()
		local size = 13
		S.Font(self.label, th.fonts.head2, size, th.fallback.head2)
		self.label:SetText(t)
		local room = (self:GetWidth() or 0) - 10
		while room > 0 and size > 8 and (self.label:GetStringWidth() or 0) > room do
			size = size - 1
			S.Font(self.label, th.fonts.head2, size, th.fallback.head2)
			self.label:SetText(t)
		end
		self.label:SetWidth(room > 0 and room or 0)
		self.label:SetWordWrap(false)
	end
	function b:SetActive(on)
		self.active = on and true or nil
		local k = on and 0.5 or 0.25
		self:SetBackdropColor(r * k, g * k, bl * k, 0.95)
	end
	return b
end

--- A spell icon that shows the spell's own tooltip (set .tipSpell).
function S.SpellButton(parent, size)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(size, size)
	f.tex = f:CreateTexture(nil, "ARTWORK")
	f.tex:SetAllPoints()
	f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	S.Tip(f)
	return f
end

function S.Circle(parent, layerSub)
	local t = parent:CreateTexture(nil, "ARTWORK", nil, layerSub)
	pcall(function()
		local m = parent:CreateMaskTexture()
		m:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		m:SetAllPoints(t)
		t:AddMaskTexture(m)
	end)
	return t
end

--- A scrolling area inside a card, from `top` px below the card's top to `bottom` px above its bottom. Wheel scrolls by
--- `step`; a slim thumb on the right shows where you are (only when it scrolls). Make it when the window is built, not
--- later: DialogPopup wraps scroll frames on show, so Shift+wheel keeps resizing the window over it.
--- Returns sf, child; call sf.UpdateThumb() after changing the child's height, sf.Reset() to go to the top.
function S.Scroll(card, top, bottom, step)
	local t = S.T()
	local sf = CreateFrame("ScrollFrame", nil, card)
	sf:SetPoint("TOPLEFT", 8, -top)
	sf:SetPoint("BOTTOMRIGHT", -14, bottom)
	local child = CreateFrame("Frame", nil, sf)
	child:SetSize(10, 10)
	sf:SetScrollChild(child)
	local track = card:CreateTexture(nil, "ARTWORK")
	track:SetColorTexture(t.later[1], t.later[2], t.later[3], 0.25)
	track:SetWidth(3)
	track:SetPoint("TOPRIGHT", -6, -top)
	track:SetPoint("BOTTOMRIGHT", -6, bottom)
	local thumb = card:CreateTexture(nil, "ARTWORK", nil, 1)
	thumb:SetWidth(3)
	-- A soft fade over the last 16 px when there is more below (Rob's first test, 17 Nov 2026: "This week" ended on a
	-- half line, the bottoms of the letters showing). Gone when you are at the end.
	-- On a frame of its own above the list: a texture of the card itself would draw UNDER the list's rows.
	local fadeHost = CreateFrame("Frame", nil, card)
	fadeHost:SetAllPoints(sf)
	fadeHost:SetFrameLevel(sf:GetFrameLevel() + 10)
	local fade = fadeHost:CreateTexture(nil, "OVERLAY", nil, 7)
	fade:SetTexture("Interface\\Buttons\\WHITE8X8")
	fade:SetPoint("BOTTOMLEFT", sf, "BOTTOMLEFT", 0, 0)
	fade:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", 0, 0)
	-- 18 Nov 2026 (Rob's screenshots: "Best stats for you now", This week, a dungeon row and the Set focus macro all
	-- showed half a line at the bottom - the fade and the 3 px bar were not enough to see that the list goes on): a
	-- taller fade and the words "scroll for more" on it while there is more below.
	fade:SetHeight(24)
	if fade.SetGradient and CreateColor then
		fade:SetGradient("VERTICAL", CreateColor(t.card[1], t.card[2], t.card[3], 1),
			CreateColor(t.card[1], t.card[2], t.card[3], 0))
	else
		fade:SetVertexColor(t.card[1], t.card[2], t.card[3], 0.7)
	end
	fade:Hide()
	local more = S.Text(fadeHost, "textB", 11, t.label)
	more:SetPoint("BOTTOMRIGHT", sf, "BOTTOMRIGHT", -2, 2)
	more:SetJustifyH("RIGHT")
	more:SetText(ns:L("FOV_SCROLL_MORE"))
	more:Hide()
	function sf.UpdateThumb()
		local max = sf:GetVerticalScrollRange() or 0
		local h = sf:GetHeight() or 0
		if max <= 1 or h <= 0 then
			track:Hide()
			thumb:Hide()
			fade:Hide()
			more:Hide()
			return
		end
		local below = (sf:GetVerticalScroll() or 0) < max - 1
		fade:SetShown(below)
		more:SetShown(below)
		local r, g, b = S.Accent()
		thumb:SetColorTexture(r, g, b, 0.9)
		local th = math.max(20, h * h / (h + max))
		thumb:SetHeight(th)
		thumb:ClearAllPoints()
		thumb:SetPoint("TOPRIGHT", track, "TOPRIGHT", 0, -((h - th) * (sf:GetVerticalScroll() / max)))
		track:Show()
		thumb:Show()
	end
	function sf.Reset()
		sf:SetVerticalScroll(0)
		sf.UpdateThumb()
		-- The scroll range is only known after the next layout pass: look again a moment later.
		if C_Timer and C_Timer.After then
			C_Timer.After(0, sf.UpdateThumb)
		end
	end
	sf:EnableMouseWheel(true)
	sf:SetScript("OnMouseWheel", function(self, delta)
		local max = self:GetVerticalScrollRange() or 0
		self:SetVerticalScroll(math.min(max, math.max(0, self:GetVerticalScroll() - delta * (step or 40))))
		self.UpdateThumb()
	end)
	sf:SetScript("OnSizeChanged", function(self, w)
		child:SetWidth(w)
		self.UpdateThumb()
	end)
	return sf, child
end

--------------------------------------------------------------------------------
-- Skin an existing window in style A (17 Nov 2026; Rob via sparring, verbatim: "alle andere vensters die we hebben,
-- kunnen in dezelfde stijl van dit komen"). For the small Forever windows that were built with Blizzard's dialog look
-- (Do this now, Your direction, New in this version, the popups): the window keeps its layout, size, Shift+scroll and
-- every script; only the look changes — flat warm background with a gold edge, our fonts at the same sizes, Blizzard's
-- yellow/white/grey text colours mapped to the theme's gold/text/dim, and Blizzard's red panel buttons drawn as our
-- buttons. Idempotent: rows a window makes later are skinned on the next call (windows call it after a fill).
--------------------------------------------------------------------------------
local function MapColor(fs)
	local t = S.T()
	local r, g, b = fs:GetTextColor()
	if not r then
		return
	end
	if r > 0.9 and g > 0.7 and b < 0.3 then -- GameFontNormal yellow
		fs:SetTextColor(t.gold[1], t.gold[2], t.gold[3])
	elseif r > 0.9 and g > 0.9 and b > 0.9 then -- highlight white
		fs:SetTextColor(t.text[1], t.text[2], t.text[3])
	elseif r < 0.6 and g < 0.6 and b < 0.6 and math.abs(r - g) < 0.05 then -- disabled grey
		fs:SetTextColor(t.dim[1], t.dim[2], t.dim[3])
	end
end

local function SkinFont(fs, isTitle)
	if fs._mhSkinned then
		return
	end
	fs._mhSkinned = true
	local t = S.T()
	local _, size, flags = fs:GetFont()
	size = (type(size) == "number" and size > 0) and size or 12
	local role = (isTitle or size >= 16) and "head2" or "text"
	if isTitle then
		size = math.max(size, 18)
	end
	local text = fs:GetText()
	S.Font(fs, t.fonts[role], size, t.fallback[role], flags)
	if isTitle then
		fs:SetTextColor(t.gold[1], t.gold[2], t.gold[3])
	else
		MapColor(fs)
	end
	if text then
		fs:SetText(text)
	end
end

local function SkinButton(b)
	if b._mhSkinned then
		return
	end
	b._mhSkinned = true
	for _, k in ipairs({ "Left", "Middle", "Right" }) do
		if b[k] then
			b[k]:SetAlpha(0)
		end
	end
	for _, getter in ipairs({ "GetNormalTexture", "GetPushedTexture", "GetDisabledTexture", "GetHighlightTexture" }) do
		local tex = b[getter] and b[getter](b)
		if tex then
			tex:SetAlpha(0)
		end
	end
	local r, g, bl = S.Accent()
	local bg = b:CreateTexture(nil, "BACKGROUND", nil, -1)
	bg:SetAllPoints()
	bg:SetColorTexture(r * 0.25, g * 0.25, bl * 0.25, 0.95)
	local edge = {}
	for i, pts in ipairs({ { "TOPLEFT", "TOPRIGHT", true }, { "BOTTOMLEFT", "BOTTOMRIGHT", true },
		{ "TOPLEFT", "BOTTOMLEFT", false }, { "TOPRIGHT", "BOTTOMRIGHT", false } }) do
		local e = b:CreateTexture(nil, "BORDER")
		e:SetColorTexture(r, g, bl, 0.9)
		e:SetPoint(pts[1])
		e:SetPoint(pts[2])
		if pts[3] then
			e:SetHeight(1)
		else
			e:SetWidth(1)
		end
		edge[i] = e
	end
	b:HookScript("OnEnter", function()
		bg:SetColorTexture(r * 0.45, g * 0.45, bl * 0.45, 0.95)
	end)
	b:HookScript("OnLeave", function()
		bg:SetColorTexture(r * 0.25, g * 0.25, bl * 0.25, 0.95)
	end)
	local fs = b.GetFontString and b:GetFontString()
	if fs then
		fs._mhSkinned = true -- the walk below must not give it the plain text font again
		local th = S.T()
		local _, size = fs:GetFont()
		local text = fs:GetText()
		S.Font(fs, th.fonts.head2, (type(size) == "number" and size > 0) and size + 1 or 13, th.fallback.head2)
		fs:SetTextColor(th.buttonText[1], th.buttonText[2], th.buttonText[3])
		if text then
			fs:SetText(text)
		end
	end
end

local function Walk(obj, title, depth)
	if depth > 8 then
		return
	end
	if obj.GetRegions then
		for _, reg in ipairs({ obj:GetRegions() }) do
			if reg.GetObjectType and reg:GetObjectType() == "FontString" then
				SkinFont(reg, reg == title)
			end
		end
	end
	if obj.GetChildren then
		for _, child in ipairs({ obj:GetChildren() }) do
			-- Blizzard's red panel button (UIPanelButtonTemplate: Left/Middle/Right pieces).
			if child.Left and child.Middle and child.Right and child.GetFontString then
				SkinButton(child)
			end
			Walk(child, title, depth + 1)
		end
	end
end

--- Skin `f` (a window) in style A; `title` = its title font string (gold, larger). Safe to call again.
function S.SkinWindow(f, title)
	if not f then
		return
	end
	local t = S.T()
	if not f._mhSkinBg then
		if f.SetBackdrop then
			f:SetBackdrop({ bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 })
			f:SetBackdropColor(t.bgBottom[1], t.bgBottom[2], t.bgBottom[3], 1)
			f:SetBackdropBorderColor(t.gold[1], t.gold[2], t.gold[3], 1)
		end
		local bg = f:CreateTexture(nil, "BACKGROUND", nil, 1)
		bg:SetPoint("TOPLEFT", 1, -1)
		bg:SetPoint("BOTTOMRIGHT", -1, 1)
		bg:SetTexture(WHITE)
		if bg.SetGradient and CreateColor then
			bg:SetGradient("VERTICAL", CreateColor(unpack(t.bgBottom)), CreateColor(unpack(t.bgTop)))
		else
			bg:SetVertexColor(t.bgTop[1], t.bgTop[2], t.bgTop[3], 1)
		end
		f._mhSkinBg = bg
	end
	Walk(f, title, 0)
end

--- Skin a window every time it is shown (after its own OnShow fill, so rows made by the fill are included). Call it
--- AFTER the window's own SetScript("OnShow"): a later SetScript would drop this hook.
function S.SkinOnShow(f)
	if not f or f._mhSkinHooked then
		return
	end
	f._mhSkinHooked = true
	f:HookScript("OnShow", function(self)
		S.SkinWindow(self, self.title or self.titleText or self.header)
		if C_Timer and C_Timer.After then
			C_Timer.After(0.1, function()
				if self:IsShown() then
					S.SkinWindow(self, self.title or self.titleText or self.header)
					S.RefreshFonts()
				end
			end)
		end
	end)
	if f:IsShown() then
		S.SkinWindow(f, f.title or f.titleText or f.header)
	end
end

--- Text with **bold** marks and "- " lines as the game shows it: bold in the theme's gold, lines with a bullet.
function S.Format(body)
	local g = S.T().gold
	local hex = ("|cff%02x%02x%02x"):format(g[1] * 255, g[2] * 255, g[3] * 255)
	body = body:gsub("%*%*(.-)%*%*", hex .. "%1|r")
	body = body:gsub("^%- ", "• "):gsub("\n%- ", "\n• ")
	return body
end

function S.SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

function S.SpellIcon(id)
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, t = pcall(C_Spell.GetSpellTexture, id)
		if ok and t then
			return t
		end
	end
	return 134400 -- question mark
end

function S.Place(zone, x, y)
	if not zone then
		return nil
	end
	if x and y then
		return ("%s · %.1f, %.1f"):format(zone, x, y)
	end
	return zone
end
