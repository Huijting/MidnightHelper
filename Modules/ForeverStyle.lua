local _, ns = ...

--[[
	ForeverStyle.lua — WoW Forever: the style kit of the new overview (docs/forever/HUISSTIJL_PLAN_2026-11-17.md, step 1).
	Rob, 17 Nov 2026 (via Sparring 17-11), verbatim: "bij alle andere tabbladen, komt het uiteindelijk ook zo op deze
	manier eruit te zien? Want dat zou ik wel heel graag willen." → every page of the overview uses the same building
	blocks, so they live here and not in ForeverOverview.lua (where round 1-5 of style A grew them).

	ns.ForeverStyle (S):
	  S.T(), S.Style()           the active theme table / its letter (ns.db.foreverStyle "A" | "B"; A by default)
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
		bgTop = { 0.16, 0.11, 0.07, 0.97 }, bgBottom = { 0.07, 0.05, 0.04, 0.97 },
		card = { 0.11, 0.08, 0.06, 0.88 }, edge = { 0.55, 0.42, 0.22, 0.55 },
		gold = { 0.86, 0.71, 0.42 }, label = { 0.93, 0.55, 0.22 }, text = { 0.92, 0.88, 0.80 }, dim = { 0.66, 0.60, 0.52 },
		seal = { 0.55, 0.10, 0.08 }, later = { 0.55, 0.52, 0.48 }, done = { 0.45, 0.85, 0.40 },
		buttonText = { 0.95, 0.92, 0.85 },
	},
	-- Theme B ("strak en modern", plan step 1): slate WHITE8X8, one sans-serif game font (Fonts\ARIALN.TTF, the client's
	-- own, Cyrillic included), a 3 px accent bar on top of every card, white headings, no gold.
	B = {
		fonts = {
			head = "Fonts\\ARIALN.TTF", head2 = "Fonts\\ARIALN.TTF", text = "Fonts\\ARIALN.TTF", textB = "Fonts\\ARIALN.TTF",
		},
		fallback = { head = "Fonts\\FRIZQT__.TTF", head2 = "Fonts\\FRIZQT__.TTF", text = "Fonts\\FRIZQT__.TTF", textB = "Fonts\\FRIZQT__.TTF" },
		bgTop = { 0.11, 0.12, 0.14, 0.97 }, bgBottom = { 0.07, 0.08, 0.09, 0.97 },
		card = { 0.14, 0.15, 0.17, 0.95 }, edge = { 0.26, 0.28, 0.31, 0.9 },
		gold = { 0.94, 0.95, 0.97 }, label = { 0.62, 0.67, 0.74 }, text = { 0.90, 0.91, 0.93 }, dim = { 0.58, 0.61, 0.66 },
		seal = { 0.20, 0.22, 0.26 }, later = { 0.45, 0.48, 0.52 }, done = { 0.45, 0.85, 0.40 },
		buttonText = { 0.96, 0.97, 0.98 },
		accentBar = 3,
	},
}

--- The theme the player chose: ns.db.foreverStyle = "A" (default) or "B".
function S.Style()
	local v = ns.db and ns.db.foreverStyle
	return (v == "B") and "B" or "A"
end

function S.T()
	return S.THEMES[S.Style()]
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

--- Set a font, falling back to the game's own when the file cannot be used.
function S.Font(fs, file, size, fallback, flags)
	local ok = fs:SetFont(file, size, flags or "")
	if not ok then
		fs:SetFont(fallback, size, flags or "")
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
	if t.accentBar then
		local r, g, b = S.Accent()
		local bar = f:CreateTexture(nil, "ARTWORK")
		bar:SetColorTexture(r, g, b, 0.95)
		bar:SetPoint("TOPLEFT", 1, -1)
		bar:SetPoint("TOPRIGHT", -1, -1)
		bar:SetHeight(t.accentBar)
		f.accentBar = bar
	end
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
	function sf.UpdateThumb()
		local max = sf:GetVerticalScrollRange() or 0
		local h = sf:GetHeight() or 0
		if max <= 1 or h <= 0 then
			track:Hide()
			thumb:Hide()
			return
		end
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
