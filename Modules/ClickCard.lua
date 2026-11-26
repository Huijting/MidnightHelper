local _, ns = ...

--[[
	ClickCard.lua — "Which click heals what": a large, good-looking card with a drawn mouse, for Midnight and Forever.

	Rob, 26 Nov 2026 (via Sparring): "Ik wil een schermpje hebben wat mensen kunnen oproepen, waarbij ik in beeld, ik heb
	heel groot beeld namelijk, ergens neer kan zetten, duidelijk visueel, welke knop wat doet als ik het aanklik met
	healen." → mock approved: "Ja, dit is wat ik bedoel … Het moet grafisch tof zijn." → choices a/b: "Ik volg jouw advies."
	And: "Wordt dan het plaatje automatisch dynamisch aangepast?" → yes, always live.

	What it shows:
	  - One big layer: a drawn mouse (left green, right blue, wheel gold) with the three spells of that layer around it, each
	    with a line to its button. Which layer: the one you hold right now (Alt/Ctrl/Shift, MODIFIER_STATE_CHANGED), else
	    the pill you clicked, else the layer with the most spells (where this character's heals are).
	  - Below: "Other layers" — every other click, small, and the clicks of MH's layout you have not learned yet, grey with
	    "level N" / "talent" / "via quest".
	Where the clicks come from, in this order:
	  1. The ACTIVE DandersFrames click-cast profile, read live (DandersFrames.ClickCast:GetClassData().profiles[
	     GetActiveProfileName()].bindings — the fields MH itself writes on import: button, modifiers, actionType, spellId,
	     spellName; read in DandersFrames v6.1.0's own source). So a change you make in /df, or another profile, shows too.
	  2. If that cannot be read: MH's own layout (ForeverClickCast.lua in Forever, ClickCast.lua in Midnight), with the
	     line that it is MH's layout.
	It refreshes on show, on a modifier, on SPELLS_CHANGED, and every 2 s while shown when what it reads changed.
	Drawing: plain textures with a circle mask stretched to an ellipse (the mouse), CreateLine for the lines. Size with
	Shift+scroll (RegisterMidnightDialogPopup), see-through on a chip, optional fade outside a group (Quiet helpers).
	/mh clickcard opens it; /mh clickcard why says where the clicks came from (silence rule).
]]

-- 26 Nov 2026 (Rob's first screenshot, via Sparring): the top spell lay over the pills, "Rejuvenation" ran over the
-- left edge, and the footer over the second strip row. Now: wider, the mouse lower, side labels UNDER their icon, and the
-- card grows with the strip (Fit). Geometry in one place (y = from the top, negative).
local W, H = 760, 640
local G = {
	pillsY = -84,       -- pills 24 high: -84 .. -108
	topSlotY = -185,    -- the wheel's spell: icon -155 .. -215, badge to -224
	mouseY = -365,      -- mouse centre; 150 x 230: top -250, bottom -480
	mw = 150, mh = 230,
	sideY = -330, sideDX = 230, -- left/right spells: centre x = mid -/+ 230 (150 / 610), labels under the icon
	stripY = -515,      -- "Other layers" heading; rows of 4 from stripY - 24, 44 apart
	rowH = 44,
	miniCols = 3, miniW = 228, miniN = 9, -- "Other layers": 3 x 3, each 228 wide (24 + 2 x 238 + 228 = 728 < 760 - 24)
}
local MASK = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local COL = {
	L = { 0.56, 0.94, 0.60 }, R = { 0.56, 0.82, 1.00 }, M = { 1.00, 0.88, 0.54 },
	other = { 0.82, 0.55, 1.00 }, grey = { 0.45, 0.45, 0.45 }, gold = { 1, 0.82, 0.3 },
}
local LAYERS = { "", "alt-", "ctrl-", "shift-" }
local MODKEY = { [""] = "", ["alt-"] = "A", ["ctrl-"] = "C", ["shift-"] = "S" }
local BTNKEY = { LeftButton = "L", RightButton = "R", MiddleButton = "M" }

local card
local pinned -- the layer the player clicked on a pill (nil = automatic)
local source, sourceWhy = "none", "not looked yet"
local lastSig

local function L(k)
	return ns:L(k)
end

local function ModName(mod)
	if mod == "alt-" then
		return ALT_KEY_TEXT or "Alt"
	elseif mod == "ctrl-" then
		return CTRL_KEY_TEXT or "Ctrl"
	elseif mod == "shift-" then
		return SHIFT_KEY_TEXT or "Shift"
	end
	return L("FCARD_PLAIN")
end

local function SlotText(mod, button)
	local b = (button == "LeftButton" and "L") or (button == "RightButton" and "R") or "M"
	if mod == "" then
		return b
	end
	return ModName(mod) .. "+" .. b
end

local function SpellName(id)
	if not id then
		return nil
	end
	local fn = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
	local ok, n = pcall(fn or function() return nil end, id)
	return ok and type(n) == "string" and n or nil
end

local function SpellIcon(id)
	if not id then
		return nil
	end
	local fn = (C_Spell and C_Spell.GetSpellTexture) or GetSpellTexture
	local ok, t = pcall(fn or function() return nil end, id)
	return ok and t or nil
end

local function SpellRank(id)
	if not (id and C_Spell and C_Spell.GetSpellSubtext) then
		return nil
	end
	local ok, s = pcall(C_Spell.GetSpellSubtext, id)
	return ok and type(s) == "string" and s ~= "" and s or nil
end

--- 1. The active DandersFrames profile, live. rows = { mod, button, action, spellId, spellName }.
local function DFRows()
	local df = rawget(_G, "DandersFrames")
	local cc = type(df) == "table" and df.ClickCast
	if type(cc) ~= "table" or type(cc.GetClassData) ~= "function" or type(cc.GetActiveProfileName) ~= "function" then
		return nil, "DandersFrames not loaded"
	end
	local ok, cd = pcall(cc.GetClassData, cc)
	local okN, name = pcall(cc.GetActiveProfileName, cc)
	if not (ok and type(cd) == "table" and okN and type(name) == "string") then
		return nil, "DandersFrames profile not readable"
	end
	local prof = type(cd.profiles) == "table" and cd.profiles[name]
	if type(prof) ~= "table" or type(prof.bindings) ~= "table" then
		return nil, "no bindings in DandersFrames profile " .. name
	end
	local rows = {}
	for _, b in ipairs(prof.bindings) do
		if type(b) == "table" and b.enabled ~= false and (b.bindType == nil or b.bindType == "mouse")
			and BTNKEY[b.button] and MODKEY[b.modifiers or ""] then
			rows[#rows + 1] = { mod = b.modifiers or "", button = b.button, action = b.actionType,
				spellId = tonumber(b.spellId), spellName = b.spellName }
		end
	end
	return rows, name
end

--- 2. MH's own layout for this character (Forever or Midnight).
local function MHRows()
	if ns.IS_FOREVER and ns.ForeverClickRows then
		return ns.ForeverClickRows()
	end
	if ns.ClickLayoutRows then
		local spec
		if C_SpecializationInfo and C_SpecializationInfo.GetSpecialization then
			local okI, idx = pcall(C_SpecializationInfo.GetSpecialization)
			if okI and idx then
				local okS, id = pcall(C_SpecializationInfo.GetSpecializationInfo, idx)
				spec = okS and id or nil
			end
		end
		local rows = spec and ns.ClickLayoutRows(spec)
		if rows then
			local out = {}
			for _, r in ipairs(rows) do
				if r.action then
					out[#out + 1] = { mod = r.mod, button = r.button, action = r.action, spellId = r.spellId,
						known = r.spellId == nil or (IsPlayerSpell and IsPlayerSpell(r.spellId)) }
				end
			end
			return out
		end
	end
	return nil
end

--- Missing clicks (grey): Forever from ForeverClickCast, Midnight from the layout's unknown spells.
local function Missing(rows)
	if ns.IS_FOREVER and ns.ForeverClickMissing then
		return ns.ForeverClickMissing()
	end
	local out = {}
	for _, r in ipairs(rows or {}) do
		if r.known == false then
			out[#out + 1] = { mod = r.mod, button = r.button, spellId = r.spellId, how = "notyet" }
		end
	end
	return out
end

local function Collect()
	local rows, why = DFRows()
	if rows and #rows > 0 then
		source, sourceWhy = "df", why
	else
		rows = MHRows()
		source, sourceWhy = rows and "mh" or "none", tostring(why)
	end
	rows = rows or {}
	local missing = Missing(source == "mh" and rows or MHRows())
	-- Drop "missing" ones whose click is already filled (another spell sits there now).
	local filled = {}
	for _, r in ipairs(rows) do
		filled[r.mod .. r.button] = true
	end
	local miss = {}
	for _, m in ipairs(missing) do
		if not filled[(m.mod or "") .. (m.button or "")] then
			miss[#miss + 1] = m
		end
	end
	return rows, miss
end

local function MainLayer(rows)
	if pinned then
		return pinned
	end
	local count = {}
	for _, r in ipairs(rows) do
		if r.action == "spell" then
			count[r.mod] = (count[r.mod] or 0) + 1
		end
	end
	local best, bestN = "", -1
	for _, m in ipairs(LAYERS) do
		if (count[m] or 0) > bestN then
			best, bestN = m, count[m] or 0
		end
	end
	return best
end

local function HeldLayer()
	if IsAltKeyDown and IsAltKeyDown() then
		return "alt-"
	elseif IsControlKeyDown and IsControlKeyDown() then
		return "ctrl-"
	elseif IsShiftKeyDown and IsShiftKeyDown() then
		return "shift-"
	end
	return nil
end

-- ── Drawing ───────────────────────────────────────────────────────────────────
local function Tex(parent, layer, r, g, b, a)
	local t = parent:CreateTexture(nil, layer or "ARTWORK")
	t:SetColorTexture(r, g, b, a or 1)
	return t
end

local function Masked(parent, mask, layer, r, g, b, a)
	local t = Tex(parent, layer, r, g, b, a)
	if t.AddMaskTexture and mask then
		pcall(t.AddMaskTexture, t, mask)
	end
	return t
end

--- A vertical colour gradient (top colour first). Modern clients: SetGradient with ColorMixin; older: SetGradientAlpha.
local function Grad(t, r1, g1, b1, a1, r2, g2, b2, a2)
	t:SetColorTexture(1, 1, 1, 1)
	if t.SetGradient and CreateColor then
		-- SetGradient("VERTICAL", min = bottom, max = top)
		if pcall(t.SetGradient, t, "VERTICAL", CreateColor(r2, g2, b2, a2), CreateColor(r1, g1, b1, a1)) then
			return t
		end
	end
	if t.SetGradientAlpha then
		if pcall(t.SetGradientAlpha, t, "VERTICAL", r2, g2, b2, a2, r1, g1, b1, a1) then
			return t
		end
	end
	t:SetColorTexture(r1, g1, b1, a1) -- no gradient on this client: the top colour
	return t
end

--- A thick line with a soft glow line under it (the mock's look). Returns the pair; nil without CreateLine.
local function NewLine(parent, r, g, b)
	if not parent.CreateLine then
		return nil
	end
	local okG, glow = pcall(parent.CreateLine, parent, nil, "BORDER")
	local ok, ln = pcall(parent.CreateLine, parent, nil, "ARTWORK")
	if not ok or not ln then
		return nil
	end
	ln:SetThickness(5)
	ln:SetColorTexture(r, g, b, 0.95)
	if okG and glow then
		glow:SetThickness(13)
		glow:SetColorTexture(r, g, b, 0.22)
		ln._glow = glow
	end
	return ln
end

local function LinePoints(ln, a1, f1, x1, y1, a2, f2, x2, y2)
	if not ln then
		return
	end
	ln:SetStartPoint(a1, f1, x1, y1)
	ln:SetEndPoint(a2, f2, x2, y2)
	if ln._glow then
		ln._glow:SetStartPoint(a1, f1, x1, y1)
		ln._glow:SetEndPoint(a2, f2, x2, y2)
	end
end

local Hoverable -- tooltip on a slot / mini (defined with the tooltips below; only called from Build, later)

--- A big spell slot: glow border, icon, key badge, name + rank text on one side.
local function BigSlot(parent, color, textSide)
	local s = CreateFrame("Frame", nil, parent)
	s:SetSize(60, 60)
	-- A soft colour halo behind the icon (two squares, fading out), as on the mock.
	s.halo1 = Tex(s, "BACKGROUND", color[1], color[2], color[3], 0.10)
	s.halo1:SetPoint("TOPLEFT", -14, 14)
	s.halo1:SetPoint("BOTTOMRIGHT", 14, -14)
	s.halo2 = Tex(s, "BACKGROUND", color[1], color[2], color[3], 0.18)
	s.halo2:SetPoint("TOPLEFT", -6, 6)
	s.halo2:SetPoint("BOTTOMRIGHT", 6, -6)
	s.glow = s:CreateTexture(nil, "BACKGROUND")
	s.glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	s.glow:SetBlendMode("ADD")
	s.glow:SetSize(120, 120)
	s.glow:SetPoint("CENTER")
	s.edge = Tex(s, "BORDER", color[1], color[2], color[3], 1)
	s.edge:SetAllPoints()
	s.icon = s:CreateTexture(nil, "ARTWORK")
	s.icon:SetPoint("TOPLEFT", 3, -3)
	s.icon:SetPoint("BOTTOMRIGHT", -3, 3)
	s.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	s.badgeBg = Tex(s, "OVERLAY", color[1], color[2], color[3], 1)
	s.badge = s:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	s.badge:SetTextColor(0.08, 0.06, 0.03)
	s.badge:SetPoint("CENTER", s, "BOTTOM", 0, -2)
	s.badgeBg:SetPoint("TOPLEFT", s.badge, "TOPLEFT", -6, 2)
	s.badgeBg:SetPoint("BOTTOMRIGHT", s.badge, "BOTTOMRIGHT", 6, -2)
	s.name = s:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	s.sub = s:CreateFontString(nil, "OVERLAY", "GameFontHighlight") -- "Rank 3": was the small font (Rob: hard to read)
	s.sub:SetTextColor(0.80, 0.75, 0.64)
	if textSide == "below" then
		-- Under the icon, centred, and kept to 210 px so it never leaves the card (Rob's screenshot).
		s.name:SetPoint("TOP", s, "BOTTOM", 0, -18)
		s.name:SetWidth(210)
		s.name:SetJustifyH("CENTER")
		s.sub:SetPoint("TOP", s.name, "BOTTOM", 0, -3)
		s.sub:SetWidth(210)
		s.sub:SetJustifyH("CENTER")
	elseif textSide == "left" then
		s.name:SetPoint("BOTTOMRIGHT", s, "LEFT", -12, 2)
		s.name:SetJustifyH("RIGHT")
		s.sub:SetPoint("TOPRIGHT", s, "LEFT", -12, -2)
		s.sub:SetJustifyH("RIGHT")
	else
		s.name:SetPoint("BOTTOMLEFT", s, "RIGHT", 12, 2)
		s.name:SetJustifyH("LEFT")
		s.sub:SetPoint("TOPLEFT", s, "RIGHT", 12, -2)
		s.sub:SetJustifyH("LEFT")
	end
	s.color = color
	Hoverable(s)
	return s
end

-- ── Tooltips (26 Nov 2026, Rob: "Kunnen we ook de Healing Touch, de Regrowth, Rejuvenation een tooltip geven?") ──
--- "Alt + left click" for a click.
local function TipKey(mod, button)
	local b = L(button == "LeftButton" and "FCARD_BTN_L" or button == "RightButton" and "FCARD_BTN_R" or "FCARD_BTN_M")
	if (mod or "") == "" then
		return b
	end
	return ModName(mod) .. " + " .. b
end

--- The game's own spell tooltip (the rank you have), then MH's line with the click. tip = { spellId, action, mod, button,
--- miss } on the frame (set in FillBig / the strip).
local function TipEnter(self)
	local tip = self.tip
	if not (tip and GameTooltip) then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local shown = false
	if tip.spellId and GameTooltip.SetSpellByID then
		shown = pcall(GameTooltip.SetSpellByID, GameTooltip, tip.spellId) and (GameTooltip:NumLines() or 0) > 0
	end
	if not shown then
		local title = (tip.action == "target" and L("FCARD_TARGET")) or (tip.action == "menu" and L("FCARD_MENU"))
			or SpellName(tip.spellId) or tip.name or "?"
		GameTooltip:SetText(title, 1, 0.82, 0, 1, true)
		if tip.action == "target" then
			GameTooltip:AddLine(L("FCARD_TIP_TARGET"), 1, 1, 1, true)
		elseif tip.action == "menu" then
			GameTooltip:AddLine(L("FCARD_TIP_MENU"), 1, 1, 1, true)
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L("FCARD_TIP_CLICK_FMT"):format(TipKey(tip.mod, tip.button)), 0.56, 0.94, 0.60, true)
	if tip.miss then
		GameTooltip:AddLine(L("FCARD_TIP_NOTYET_FMT"):format(tip.miss), 0.88, 0.63, 0.31, true)
	end
	GameTooltip:Show()
end

local function TipLeave()
	if GameTooltip then
		GameTooltip:Hide()
	end
end

function Hoverable(fr)
	fr:EnableMouse(true)
	fr:SetScript("OnEnter", TipEnter)
	fr:SetScript("OnLeave", TipLeave)
	-- Dragging the card still works when you start on an icon.
	if fr.RegisterForDrag then
		fr:RegisterForDrag("LeftButton")
		fr:SetScript("OnDragStart", function()
			if card then
				card:StartMoving()
			end
		end)
		fr:SetScript("OnDragStop", function()
			if card and card:GetScript("OnDragStop") then
				card:GetScript("OnDragStop")(card)
			end
		end)
	end
end

local function FillBig(s, r, code, mod, button)
	local c = s.color
	s.tip = r and { spellId = r.action == "spell" and r.spellId or nil, name = r.spellName, action = r.action,
		mod = mod, button = button } or nil
	s.halo1:SetShown(r ~= nil)
	s.halo2:SetShown(r ~= nil)
	if not r then
		s.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		s.icon:SetDesaturated(true)
		s.edge:SetColorTexture(0.3, 0.3, 0.3, 1)
		s.glow:Hide()
		s.name:SetText("|cff8c8677" .. L("FCARD_FREE") .. "|r")
		s.sub:SetText("")
		s.badgeBg:SetColorTexture(0.5, 0.5, 0.5, 1)
		s.badge:SetText(code)
		return
	end
	s.icon:SetDesaturated(false)
	s.edge:SetColorTexture(c[1], c[2], c[3], 1)
	s.glow:SetVertexColor(c[1], c[2], c[3], 0.9)
	s.glow:Show()
	s.badgeBg:SetColorTexture(c[1], c[2], c[3], 1)
	s.badge:SetText(code)
	if r.action == "spell" then
		s.icon:SetTexture(SpellIcon(r.spellId) or "Interface\\Icons\\INV_Misc_QuestionMark")
		s.name:SetText(SpellName(r.spellId) or r.spellName or "?")
		s.sub:SetText(SpellRank(r.spellId) or "")
	elseif r.action == "target" then
		s.icon:SetTexture("Interface\\Icons\\Ability_Hunter_MarkedForDeath")
		s.name:SetText(L("FCARD_TARGET"))
		s.sub:SetText("")
	else
		s.icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
		s.name:SetText(r.action == "menu" and L("FCARD_MENU") or tostring(r.action))
		s.sub:SetText("")
	end
end

local function Build()
	if card then
		return card
	end
	local f = CreateFrame("Frame", "MidnightHelperClickCard", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	-- Bigger the first time (Rob, 26 Nov: "allemaal wat wel lastiger te lezen", a big screen). A size you chose with
	-- Shift+scroll is remembered by RegisterMidnightDialogPopup and wins over this.
	f:SetScale(1.25)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll = size (Rob: a very big screen), Escape closes
	end
	f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2 })
	f:SetBackdropColor(0.06, 0.05, 0.035, 0.96)
	f:SetBackdropBorderColor(0.72, 0.57, 0.23, 1)
	local pos = type(ns.db) == "table" and ns.db.clickCardPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER")
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if type(ns.db) == "table" then
			local p, _, rp, x, y = self:GetPoint(1)
			ns.db.clickCardPos = { p, rp, x, y }
		end
	end)
	-- An inner hairline, as on the mock.
	local inner = CreateFrame("Frame", nil, f, "BackdropTemplate")
	inner:SetPoint("TOPLEFT", 7, -7)
	inner:SetPoint("BOTTOMRIGHT", -7, 7)
	inner:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
	inner:SetBackdropBorderColor(0.72, 0.57, 0.23, 0.35)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	f.title:SetPoint("TOPLEFT", 24, -20)
	f.title:SetTextColor(1, 0.83, 0.42)
	f.title:SetText(L("FCARD_TITLE"):upper())
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.sub:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 2, -6)
	f.sub:SetWidth(W - 60)
	f.sub:SetJustifyH("LEFT")
	f.sub:SetTextColor(0.75, 0.70, 0.60)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)
	-- Pills.
	f.pills = {}
	local px = 24
	for i, m in ipairs(LAYERS) do
		local b = CreateFrame("Button", nil, f, "BackdropTemplate")
		b:SetHeight(24)
		b:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
		b.t = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge") -- was GameFontNormal (Rob: hard to read)
		b.t:SetPoint("CENTER")
		b.t:SetText(ModName(m))
		b:SetWidth(math.max(70, (b.t:GetStringWidth() or 40) + 30))
		b:SetPoint("TOPLEFT", px, -84)
		px = px + b:GetWidth() + 8
		b:SetScript("OnClick", function()
			if pinned == m then
				pinned = nil
			else
				pinned = m
			end
			ns.ClickCardRefresh(true)
		end)
		b.mod = m
		f.pills[i] = b
	end
	f.live = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.live:SetPoint("TOPRIGHT", -24, -88)
	f.live:SetTextColor(0.62, 0.89, 0.6)
	-- The mouse: body ellipse with a gold rim; left/right buttons are the top of the same ellipse.
	local mx, my, mw, mh = W / 2, G.mouseY, G.mw, G.mh
	f.mouse = CreateFrame("Frame", nil, f)
	f.mouse:SetSize(mw + 48, mh + 48)
	f.mouse:SetPoint("CENTER", f, "TOPLEFT", mx, my)
	-- Halo: two larger, faint gold ellipses behind the mouse (the mock's glow).
	local haloMask = f.mouse:CreateMaskTexture()
	haloMask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	haloMask:SetAllPoints(f.mouse)
	local halo = Masked(f.mouse, haloMask, "BACKGROUND", 1, 0.8, 0.4, 0.07)
	halo:SetAllPoints(f.mouse)
	f.rimFrame = CreateFrame("Frame", nil, f.mouse)
	f.rimFrame:SetSize(mw + 8, mh + 8)
	f.rimFrame:SetPoint("CENTER")
	local rimMask = f.rimFrame:CreateMaskTexture()
	rimMask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	rimMask:SetAllPoints(f.rimFrame)
	local rim = Masked(f.rimFrame, rimMask, "BORDER", 0.66, 0.58, 0.42, 1)
	rim:SetAllPoints(f.rimFrame)
	Grad(rim, 0.86, 0.74, 0.50, 1, 0.42, 0.35, 0.22, 1)
	f.body = CreateFrame("Frame", nil, f.rimFrame)
	f.body:SetSize(mw, mh)
	f.body:SetPoint("CENTER")
	local mask = f.body:CreateMaskTexture()
	mask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	mask:SetAllPoints(f.body)
	local body = Masked(f.body, mask, "BORDER", 0.15, 0.15, 0.18, 1)
	body:SetAllPoints(f.body)
	Grad(body, 0.32, 0.32, 0.37, 1, 0.07, 0.07, 0.09, 1)
	-- (26 Nov 2026, Rob's second screenshot: the old "shine" square showed as a light rectangle with straight edges under
	-- the left button. Removed; the body's gradient gives the light already.)
	local split = mh * 0.36
	f.btnL = Masked(f.body, mask, "ARTWORK", COL.L[1], COL.L[2], COL.L[3], 1)
	f.btnL:SetPoint("TOPLEFT", f.body, "TOPLEFT", 0, 0)
	f.btnL:SetPoint("BOTTOMRIGHT", f.body, "TOP", -2, -split)
	Grad(f.btnL, 0.70, 1.00, 0.72, 1, 0.16, 0.55, 0.24, 1)
	f.btnR = Masked(f.body, mask, "ARTWORK", COL.R[1], COL.R[2], COL.R[3], 1)
	f.btnR:SetPoint("TOPLEFT", f.body, "TOP", 2, 0)
	f.btnR:SetPoint("BOTTOMRIGHT", f.body, "TOPRIGHT", 0, -split)
	Grad(f.btnR, 0.70, 0.88, 1.00, 1, 0.16, 0.37, 0.61, 1)
	-- A bright edge on top of each button (the light catching it).
	local gloss = Masked(f.body, mask, "OVERLAY", 1, 1, 1, 0.16)
	gloss:SetPoint("TOPLEFT", f.body, "TOPLEFT", 0, 0)
	gloss:SetPoint("BOTTOMRIGHT", f.body, "TOPRIGHT", 0, -split * 0.35)
	local split2 = Tex(f.body, "OVERLAY", 0.03, 0.03, 0.04, 1)
	split2:SetPoint("TOPLEFT", f.body, "TOPLEFT", 0, -split)
	split2:SetPoint("TOPRIGHT", f.body, "TOPRIGHT", 0, -split)
	split2:SetHeight(4)
	local seam = Tex(f.body, "OVERLAY", 0.03, 0.03, 0.04, 1)
	seam:SetPoint("TOP", f.body, "TOP", 0, 0)
	seam:SetSize(4, split)
	f.wheelFrame = CreateFrame("Frame", nil, f.body)
	f.wheelFrame:SetSize(22, 50)
	f.wheelFrame:SetPoint("TOP", f.body, "TOP", 0, -16)
	f.wheelFrame:SetFrameLevel(f.body:GetFrameLevel() + 2)
	local wmask = f.wheelFrame:CreateMaskTexture()
	wmask:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	wmask:SetAllPoints(f.wheelFrame)
	local wrim = Masked(f.wheelFrame, wmask, "BORDER", 1, 0.95, 0.75, 1)
	wrim:SetAllPoints(f.wheelFrame)
	f.wheelIn = CreateFrame("Frame", nil, f.wheelFrame)
	f.wheelIn:SetPoint("TOPLEFT", 2, -2)
	f.wheelIn:SetPoint("BOTTOMRIGHT", -2, 2)
	local wmask2 = f.wheelIn:CreateMaskTexture()
	wmask2:SetTexture(MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	wmask2:SetAllPoints(f.wheelIn)
	f.wheel = Masked(f.wheelIn, wmask2, "ARTWORK", COL.M[1], COL.M[2], COL.M[3], 1)
	f.wheel:SetAllPoints(f.wheelIn)
	Grad(f.wheel, 1.00, 0.90, 0.55, 1, 0.66, 0.44, 0.08, 1)
	f.layerText = f.body:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	f.layerText:SetPoint("CENTER", f.body, "CENTER", 0, -50)
	f.layerText:SetTextColor(0.91, 0.86, 0.72)
	f.layerSub = f.body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.layerSub:SetPoint("TOP", f.layerText, "BOTTOM", 0, -4)
	f.layerSub:SetTextColor(0.6, 0.56, 0.47)
	f.layerSub:SetText(L("FCARD_PLUS_CLICK"))
	-- The three big slots and their lines (thick, with a glow line under each).
	f.slotL = BigSlot(f, COL.L, "below")
	f.slotL:SetPoint("CENTER", f, "TOPLEFT", mx - G.sideDX, G.sideY)
	f.slotR = BigSlot(f, COL.R, "below")
	f.slotR:SetPoint("CENTER", f, "TOPLEFT", mx + G.sideDX, G.sideY)
	f.slotM = BigSlot(f, COL.M, "right")
	f.slotM:SetPoint("CENTER", f, "TOPLEFT", mx, G.topSlotY)
	f.lineL = NewLine(f, COL.L[1], COL.L[2], COL.L[3])
	LinePoints(f.lineL, "RIGHT", f.slotL, 0, 0, "CENTER", f.body, -mw / 4, mh / 2 - split / 2)
	f.lineR = NewLine(f, COL.R[1], COL.R[2], COL.R[3])
	LinePoints(f.lineR, "LEFT", f.slotR, 0, 0, "CENTER", f.body, mw / 4, mh / 2 - split / 2)
	f.lineM = NewLine(f, COL.M[1], COL.M[2], COL.M[3])
	LinePoints(f.lineM, "BOTTOM", f.slotM, 0, -12, "TOP", f.wheelFrame, 0, 0)
	-- The strip.
	f.stripHead = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.stripHead:SetPoint("TOPLEFT", 24, G.stripY)
	f.stripHead:SetTextColor(0.75, 0.65, 0.42)
	f.stripHead:SetText(L("FCARD_OTHER"):upper())
	local hair = Tex(f, "ARTWORK", 0.72, 0.57, 0.23, 0.35)
	hair:SetPoint("BOTTOMLEFT", f.stripHead, "TOPLEFT", 0, 6)
	hair:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	hair:SetHeight(1)
	-- 3 per row, 228 wide (26 Nov 2026, Rob's third screenshot: with the bigger font "Cure Poison via que…" was cut off).
	f.minis = {}
	for i = 1, G.miniN do
		local m = CreateFrame("Frame", nil, f)
		m:SetSize(G.miniW, 36)
		m:SetPoint("TOPLEFT", f, "TOPLEFT", 24 + ((i - 1) % G.miniCols) * (G.miniW + 10),
			G.stripY - 24 - math.floor((i - 1) / G.miniCols) * G.rowH)
		m.edge = Tex(m, "BORDER", 0.5, 0.5, 0.5, 1)
		m.edge:SetSize(30, 30)
		m.edge:SetPoint("LEFT")
		m.icon = m:CreateTexture(nil, "ARTWORK")
		m.icon:SetSize(26, 26)
		m.icon:SetPoint("CENTER", m.edge, "CENTER")
		m.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		m.name = m:CreateFontString(nil, "OVERLAY", "GameFontHighlight") -- was the small font (Rob: hard to read)
		m.name:SetPoint("TOPLEFT", m.edge, "TOPRIGHT", 6, 1)
		m.name:SetWidth(G.miniW - 38)
		m.name:SetJustifyH("LEFT")
		m.name:SetWordWrap(false) -- one line; the whole text is in the tooltip
		m.key = m:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		m.key:SetPoint("BOTTOMLEFT", m.edge, "BOTTOMRIGHT", 6, 0)
		m.key:SetTextColor(0.75, 0.65, 0.42)
		Hoverable(m)
		f.minis[i] = m
	end
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	f.foot:SetPoint("BOTTOMLEFT", 24, 14)
	f.foot:SetWidth(W - 190)
	f.foot:SetJustifyH("LEFT")
	if f.foot.SetMaxLines then
		f.foot:SetMaxLines(2)
	end
	f.see = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.see:SetSize(130, 20)
	f.see:SetPoint("BOTTOMRIGHT", -20, 12)
	f.see:SetScript("OnClick", function()
		local steps = { 1, 0.85, 0.7, 0.5 }
		local cur = (type(ns.db) == "table" and ns.db.clickCardAlpha) or 1
		local nxt = steps[1]
		for i, v in ipairs(steps) do
			if math.abs(v - cur) < 0.01 then
				nxt = steps[i % #steps + 1]
			end
		end
		if type(ns.db) == "table" then
			ns.db.clickCardAlpha = nxt
		end
		ns.ClickCardRefresh(true)
	end)
	f:Hide()
	card = f
	return f
end

local function Sig(rows, miss, layer)
	local p = { layer, source }
	for _, r in ipairs(rows) do
		p[#p + 1] = (r.mod or "") .. (r.button or "") .. "=" .. tostring(r.action) .. tostring(r.spellId)
	end
	for _, m in ipairs(miss) do
		p[#p + 1] = "-" .. tostring(m.english or m.spellId)
	end
	return table.concat(p, ",")
end

local function MissText(m)
	if m.how == "level" and m.level then
		return L("FCARD_LEVEL_FMT"):format(m.level)
	elseif m.how == "talent" then
		return L("FCARD_TALENT")
	elseif m.how == "quest" then
		return L("FCARD_QUEST")
	end
	return L("FCARD_NOTYET")
end

function ns.ClickCardRefresh(force)
	local f = card
	if not (f and f:IsShown()) then
		return
	end
	local rows, miss = Collect()
	local held = HeldLayer()
	local layer = held or MainLayer(rows)
	local sig = Sig(rows, miss, layer)
	if not force and sig == lastSig then
		return
	end
	lastSig = sig
	local _, cls = UnitClass("player")
	local className = (UnitClass("player")) or tostring(cls)
	f.sub:SetText(L("FCARD_SUB_FMT"):format(className))
	f.live:SetText(held and L("FCARD_LIVE_FMT"):format(ModName(held)) or "")
	for _, b in ipairs(f.pills) do
		local on = b.mod == layer
		if on then
			b:SetBackdropColor(1, 0.8, 0.4, 1)
			b:SetBackdropBorderColor(1, 0.9, 0.63, 1)
			b.t:SetTextColor(0.1, 0.07, 0.01)
		else
			b:SetBackdropColor(0.16, 0.14, 0.10, 1)
			b:SetBackdropBorderColor(0.36, 0.29, 0.16, 1)
			b.t:SetTextColor(0.85, 0.81, 0.71)
		end
	end
	f.layerText:SetText(layer == "" and L("FCARD_PLAIN"):upper() or ModName(layer):upper())
	local byKey = {}
	for _, r in ipairs(rows) do
		byKey[(r.mod or "") .. r.button] = r
	end
	FillBig(f.slotL, byKey[layer .. "LeftButton"], SlotText(layer, "LeftButton"), layer, "LeftButton")
	FillBig(f.slotR, byKey[layer .. "RightButton"], SlotText(layer, "RightButton"), layer, "RightButton")
	FillBig(f.slotM, byKey[layer .. "MiddleButton"], SlotText(layer, "MiddleButton"), layer, "MiddleButton")
	-- Lit buttons on the mouse only for a click that does something on this layer.
	f.btnL:SetAlpha(byKey[layer .. "LeftButton"] and 1 or 0.18)
	f.btnR:SetAlpha(byKey[layer .. "RightButton"] and 1 or 0.18)
	f.wheel:SetAlpha(byKey[layer .. "MiddleButton"] and 1 or 0.25)
	-- Strip: the other layers' clicks, then what is not learned yet.
	local strip = {}
	for _, m in ipairs(LAYERS) do
		if m ~= layer then
			for _, btn in ipairs({ "LeftButton", "RightButton", "MiddleButton" }) do
				local r = byKey[m .. btn]
				if r then
					strip[#strip + 1] = { r = r, key = SlotText(m, btn), mod = m, button = btn }
				end
			end
		end
	end
	for _, mi in ipairs(miss) do
		strip[#strip + 1] = { miss = mi, key = SlotText(mi.mod or "", mi.button or "LeftButton"), mod = mi.mod or "",
			button = mi.button or "LeftButton" }
	end
	for i, mini in ipairs(f.minis) do
		local e = strip[i]
		if e then
			mini:Show()
			mini.key:SetText(e.key)
			mini.tip = { spellId = e.miss and e.miss.spellId or (e.r.action == "spell" and e.r.spellId) or nil,
				name = e.miss and e.miss.english or e.r.spellName, action = e.miss and "spell" or e.r.action,
				mod = e.mod, button = e.button, miss = e.miss and MissText(e.miss) or nil }
			if e.miss then
				local id = e.miss.spellId
				mini.icon:SetTexture(SpellIcon(id) or "Interface\\Icons\\INV_Misc_QuestionMark")
				mini.icon:SetDesaturated(true)
				mini.edge:SetColorTexture(0.35, 0.35, 0.35, 1)
				mini.name:SetText(("|cff8c8677%s|r  |cffe0a050%s|r"):format(SpellName(id) or e.miss.english or "?",
					MissText(e.miss)))
			else
				local r = e.r
				mini.icon:SetDesaturated(false)
				mini.edge:SetColorTexture(COL.other[1], COL.other[2], COL.other[3], 1)
				if r.action == "spell" then
					mini.icon:SetTexture(SpellIcon(r.spellId) or "Interface\\Icons\\INV_Misc_QuestionMark")
					mini.name:SetText(SpellName(r.spellId) or r.spellName or "?")
				elseif r.action == "target" then
					mini.icon:SetTexture("Interface\\Icons\\Ability_Hunter_MarkedForDeath")
					mini.name:SetText(L("FCARD_TARGET"))
				else
					mini.icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
					mini.name:SetText(r.action == "menu" and L("FCARD_MENU") or tostring(r.action))
				end
			end
		else
			mini:Hide()
		end
	end
	f.stripHead:SetShown(#strip > 0)
	-- The card grows with the strip, so the footer (2 lines at most) always sits under the last row (Rob's screenshot).
	local rowsUsed = math.ceil(math.min(#strip, #f.minis) / G.miniCols)
	local bottom
	if rowsUsed > 0 then
		bottom = -(G.stripY - 24 - (rowsUsed - 1) * G.rowH - 36)
	else
		bottom = -(G.mouseY - G.mh / 2)
	end
	f:SetHeight(bottom + 66)
	local srcLine = (source == "df") and L("FCARD_SOURCE_DF_FMT"):format(sourceWhy)
		or (source == "mh") and L("FCARD_SOURCE_MH") or L("FCARD_EMPTY")
	f.foot:SetText(srcLine .. "  ·  " .. L("FCARD_FOOT"))
	local alpha = (type(ns.db) == "table" and ns.db.clickCardAlpha) or 1
	if type(ns.db) == "table" and ns.db.clickCardFadeSolo and not (IsInGroup and IsInGroup()) then
		alpha = math.min(alpha, 0.35)
	end
	f:SetAlpha(alpha)
	f.see:SetText(L("FCARD_SEE_FMT"):format(math.floor(alpha * 100 + 0.5)))
end

function ns.ShowClickCard(toggle)
	local f = Build()
	if toggle and f:IsShown() then
		f:Hide()
		return
	end
	lastSig = nil
	f:Show()
	ns.ClickCardRefresh(true)
end

function ns.IsClickCardFadeSolo()
	return type(ns.db) == "table" and ns.db.clickCardFadeSolo == true
end

function ns.SetClickCardFadeSolo(on)
	if type(ns.db) == "table" then
		ns.db.clickCardFadeSolo = on and true or nil
	end
	ns.ClickCardRefresh(true)
end

--- /mh clickcard [why]
function ns.ClickCardSlash(arg)
	if (arg or ""):lower() == "why" then
		local rows, miss = Collect()
		print(("|cffffcc00Midnight Helper:|r click card: source %s (%s); %d click(s), %d not learned yet; layer %s"):format(
			source, sourceWhy, #rows, #miss, (function()
				local l = HeldLayer() or MainLayer(rows)
				return l == "" and "plain" or l
			end)()))
		return
	end
	ns.ShowClickCard(true)
end

do
	local ev = CreateFrame("Frame")
	for _, e in ipairs({ "MODIFIER_STATE_CHANGED", "SPELLS_CHANGED", "GROUP_ROSTER_UPDATE", "PLAYER_REGEN_ENABLED" }) do
		pcall(ev.RegisterEvent, ev, e)
	end
	ev:SetScript("OnEvent", function(_, event)
		ns.ClickCardRefresh(event ~= "MODIFIER_STATE_CHANGED")
	end)
	if C_Timer and C_Timer.NewTicker then
		C_Timer.NewTicker(2, function()
			pcall(ns.ClickCardRefresh, false) -- a change in /df or another profile: only redrawn when it differs
		end)
	end
end
