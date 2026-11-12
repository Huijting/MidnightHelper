local _, ns = ...

--[[
	ForeverPartyPanel.lua — WoW Forever: a small group panel. One row per group member (you + party1-4): name in class
	colour and role. Left-click = target that member. Right-click = your dispel on them (Shift+right-click = your second
	dispel, for the classes that have two). Blizzard's own red edge shows when a member carries something you can remove.

	Rob, 12 Nov 2026 (via sparring, choice verbatim): "A, eerst klein" — rows, click = target, right-click = dispel, the
	game's red edge; NO stop-spell button (that is option B, maybe step 2); off by default, behind a switch.
	Why a new small file and not PartyTargets.lua: that one leans on DispelHelper.lua and the spec APIs, retail only.
	The lessons are copied, not the code paths:
	  - the click buttons are SecureActionButtons on UIParent with NO scripts (a script taints them: ADDON_ACTION_FORBIDDEN
	    TargetUnit, PartyTargets 24 Aug 2026), placed over the rows by hand, out of combat only;
	  - their visibility follows the unit through RegisterUnitWatch (secure, so it also works in a fight);
	  - the red edge is Blizzard's AuraContainer (CustomAuraContainerTemplate, filter HARMFUL|RAID), order SetUnit ->
	    AddAuraSlot -> Show -> SetEnabled; our artwork sits on a canvas PARENTED to the slot (so the engine shows and
	    hides it with the aura) but ANCHORED to our row and without mouse (so it never covers the click).
	Measured for Forever (ForeverPartyProbe, Rob's group 12 Nov 2026, 5 fights): names/class/role readable in combat,
	aura reading refused in combat, the AuraContainer builds, secure buttons build. NOT measured: whether the red edge
	really lights up in Forever (needs a dispellable debuff in a group) — that is what Rob's dungeon test is for.
	Dispel spells: names and ids from ns.FOREVER_SPELL_IDS (wago DB2 wowf, measured); which class has which is only used
	as an order — IsPlayerSpell decides, so a wrong guess there costs nothing.
	/mh partytargets = on/off; /mh partytargets check = what MH sees and why.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local ROWS = 5
local UNITS = { "player", "party1", "party2", "party3", "party4" }
local W, ROW_H, HEAD_H, PAD = 220, 24, 20, 6
local FILTER = "HARMFUL|RAID"

-- First = right-click, second = Shift+right-click. Order only; known-or-not comes from the client.
local DISPELS = {
	PALADIN = { { "Cleanse", "Purify" } },
	PRIEST = { { "Dispel Magic" }, { "Abolish Disease", "Cure Disease" } },
	DRUID = { { "Remove Curse" }, { "Abolish Poison", "Cure Poison" } },
	SHAMAN = { { "Cure Poison" }, { "Cure Disease" } },
	MAGE = { { "Remove Lesser Curse" } },
}

local panel
local buttons, glows = {}, {}
local glowWhy -- why there is no red edge (nil = containers built)
local pending = false -- a change that had to wait for the end of a fight

local function Enabled()
	return ns.db and ns.db.foreverPartyPanel == true
end

local function Known(id)
	if IsPlayerSpell then
		local ok, k = pcall(IsPlayerSpell, id)
		if ok and k then
			return true
		end
	end
	if IsSpellKnown then
		local ok, k = pcall(IsSpellKnown, id)
		if ok and k then
			return true
		end
	end
	return false
end

--- Highest known rank among the names of one slot, or nil.
local function BestOf(names)
	local IDS = ns.FOREVER_SPELL_IDS or {}
	for _, name in ipairs(names) do
		local ids = IDS[name] or {}
		for i = #ids, 1, -1 do
			if Known(ids[i]) then
				return ids[i], name
			end
		end
	end
	return nil
end

--- @return first id, first name, second id, second name
local function MyDispels()
	local _, cls = UnitClass("player")
	local slots = DISPELS[cls or ""] or {}
	local a, an, b, bn
	if slots[1] then
		a, an = BestOf(slots[1])
	end
	if slots[2] then
		b, bn = BestOf(slots[2])
	end
	return a, an, b, bn
end

local function InCombat()
	return InCombatLockdown and InCombatLockdown()
end

--------------------------------------------------------------------------------
-- Red edge (Blizzard's AuraContainer)
--------------------------------------------------------------------------------
local function RowTop(i)
	return -(HEAD_H + PAD + (i - 1) * ROW_H)
end

local function PaintSlot(slot)
	local f, idx = slot, nil
	for _ = 1, 6 do
		f = f and f.GetParent and f:GetParent()
		if f and f._mhForeverRow then
			idx = f._mhForeverRow
			break
		end
	end
	if slot.EnableMouse then
		pcall(slot.EnableMouse, slot, false)
	end
	local canvas = CreateFrame("Frame", nil, slot)
	if idx and panel then
		canvas:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD - 2, RowTop(idx))
		canvas:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -PAD + 2, RowTop(idx))
		canvas:SetHeight(ROW_H)
		canvas:SetFrameLevel(math.max(canvas:GetFrameLevel(), panel:GetFrameLevel() + 8))
	else
		canvas:SetAllPoints(slot)
	end
	canvas:EnableMouse(false)
	local wash = canvas:CreateTexture(nil, "OVERLAY", nil, 1)
	wash:SetAllPoints()
	wash:SetColorTexture(0.62, 0.010, 0.006, 0.55)
	for _, side in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
		local bar = canvas:CreateTexture(nil, "OVERLAY", nil, 2)
		bar:SetColorTexture(1, 0.12, 0.025, 1)
		if side == "TOP" or side == "BOTTOM" then
			bar:SetHeight(2)
			bar:SetPoint(side .. "LEFT", canvas, side .. "LEFT", 0, 0)
			bar:SetPoint(side .. "RIGHT", canvas, side .. "RIGHT", 0, 0)
		else
			bar:SetWidth(2)
			bar:SetPoint("TOP" .. side, canvas, "TOP" .. side, 0, 0)
			bar:SetPoint("BOTTOM" .. side, canvas, "BOTTOM" .. side, 0, 0)
		end
	end
end

local function BuildGlow(i)
	if glows[i] or glowWhy or not panel then
		return
	end
	if not (C_AddOns and C_AddOns.LoadAddOn) then
		glowWhy = "C_AddOns.LoadAddOn missing"
		return
	end
	pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
	if not (AuraUtil and AuraUtil.IsValidFilterString) then
		glowWhy = "AuraUtil.IsValidFilterString missing"
		return
	end
	local okF, valid = pcall(AuraUtil.IsValidFilterString, FILTER)
	if not okF or valid ~= true then
		glowWhy = "filter rejected"
		return
	end
	local okC, c = pcall(CreateFrame, "AuraContainer", nil, panel, "CustomAuraContainerTemplate")
	if not okC or not c then
		glowWhy = "CustomAuraContainerTemplate: " .. tostring(c)
		return
	end
	c._mhForeverRow = i
	pcall(c.SetPoint, c, "TOPLEFT", panel, "TOPLEFT", PAD - 2, RowTop(i))
	pcall(c.SetPoint, c, "TOPRIGHT", panel, "TOPRIGHT", -PAD + 2, RowTop(i))
	pcall(c.SetHeight, c, ROW_H)
	if not (c.SetUnit and c.AddAuraSlot and c.SetEnabled) then
		glowWhy = "AuraContainer is missing SetUnit/AddAuraSlot/SetEnabled"
		return
	end
	-- One fixed unit per row (you, party1-4): never rebound, so never SetEnabled(false) (that clears the artwork).
	pcall(c.SetUnit, c, UNITS[i])
	local okS = pcall(c.AddAuraSlot, c, "mhForeverDispel", FILTER, { initializeFrame = PaintSlot })
	if not okS then
		glowWhy = "AddAuraSlot failed"
		return
	end
	pcall(c.Show, c)
	pcall(c.SetEnabled, c, true)
	if c.UpdateAllAuras then
		pcall(c.UpdateAllAuras, c)
	end
	glows[i] = c
end

--------------------------------------------------------------------------------
-- Click buttons (secure, NO scripts)
--------------------------------------------------------------------------------
local function ApplyDispels()
	if InCombat() then
		pending = true
		return
	end
	local a, _, b = MyDispels()
	for i = 1, ROWS do
		local btn = buttons[i]
		if btn then
			btn:SetAttribute("type2", a and "spell" or nil)
			btn:SetAttribute("spell2", a)
			btn:SetAttribute("shift-type2", b and "spell" or nil)
			btn:SetAttribute("shift-spell2", b)
		end
	end
end

local function MakeButton(i)
	local b = CreateFrame("Button", "MidnightHelperForeverPartyClick" .. i, UIParent, "SecureActionButtonTemplate")
	b:SetFrameStrata("DIALOG")
	b:RegisterForClicks("AnyUp", "AnyDown")
	b:SetAttribute("*type1", "target")
	b:SetAttribute("unit", UNITS[i])
	b:SetSize(W - PAD * 2, ROW_H)
	local hl = b:CreateTexture(nil, "HIGHLIGHT") -- drawn by the engine on hover; no script
	hl:SetAllPoints()
	hl:SetColorTexture(1, 1, 1, 0.12)
	b:Hide()
	buttons[i] = b
	return b
end

--- Put the buttons over the rows. Out of combat only (secure frames).
local function PlaceButtons()
	if InCombat() or not panel then
		pending = true
		return
	end
	local s = (panel:GetEffectiveScale() or 1) / (UIParent:GetEffectiveScale() or 1)
	local left, top = panel:GetLeft(), panel:GetTop()
	for i = 1, ROWS do
		local b = buttons[i]
		if b and left and top then
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", (left + PAD) * s, (top + RowTop(i)) * s)
			b:SetSize((W - PAD * 2) * s, ROW_H * s)
		end
	end
end

local function SetButtonsLive(on)
	if InCombat() then
		pending = true
		return
	end
	for i = 1, ROWS do
		local b = buttons[i]
		if b then
			if on then
				RegisterUnitWatch(b)
			else
				UnregisterUnitWatch(b)
				b:Hide()
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------
local function RoleText(unit)
	if not UnitGroupRolesAssigned then
		return ""
	end
	local ok, r = pcall(UnitGroupRolesAssigned, unit)
	if not ok or type(r) ~= "string" or (issecretvalue and issecretvalue(r)) or r == "NONE" then
		return ""
	end
	return _G[r] or r -- the client's own TANK / HEALER / DAMAGER text
end

local function RefreshRows()
	if not panel then
		return
	end
	for i = 1, ROWS do
		local u = UNITS[i]
		local row = panel.rows[i]
		local okE, ex = pcall(UnitExists, u)
		if okE and ex == true then
			local okN, name = pcall(UnitName, u)
			local okC, _, cls = pcall(UnitClass, u)
			local nameOk = okN and type(name) == "string" and not (issecretvalue and issecretvalue(name))
			local col = okC and cls and not (issecretvalue and issecretvalue(cls)) and RAID_CLASS_COLORS and RAID_CLASS_COLORS[cls]
			row.name:SetText(nameOk and name or "?")
			if col then
				row.name:SetTextColor(col.r, col.g, col.b)
			else
				row.name:SetTextColor(1, 1, 1)
			end
			row.role:SetText(RoleText(u))
			row:SetAlpha(1)
		else
			row.name:SetText("-")
			row.name:SetTextColor(0.5, 0.5, 0.5)
			row.role:SetText("")
			row:SetAlpha(0.5)
		end
	end
end

local function SavePos()
	if not (panel and ns.db) then
		return
	end
	local p, _, rp, x, y = panel:GetPoint()
	ns.db.foreverPartyPanelPos = { p, rp, x, y, panel:GetScale() }
end

local function Build()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverParty", UIParent, "BackdropTemplate")
	f:SetSize(W, HEAD_H + PAD * 2 + ROWS * ROW_H)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = false, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0.04, 0.04, 0.06, 0.85)
	f:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
	local pos = ns.db and ns.db.foreverPartyPanelPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
		if pos[5] then
			f:SetScale(pos[5])
		end
	else
		f:SetPoint("LEFT", UIParent, "LEFT", 40, 80)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	-- Drag by the title strip (the rows are covered by the click buttons). Not in combat: the buttons cannot follow.
	f:SetScript("OnDragStart", function(self)
		if not InCombat() then
			self:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
		PlaceButtons()
	end)
	-- Shift+scroll = size (the rule for every MH window).
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() or InCombat() then
			return
		end
		local s = math.max(0.6, math.min(2, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		SavePos()
		PlaceButtons()
	end)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	f.title:SetPoint("TOPLEFT", PAD + 2, -PAD)
	f.rows = {}
	for i = 1, ROWS do
		local r = CreateFrame("Frame", nil, f)
		r:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, RowTop(i))
		r:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, RowTop(i))
		r:SetHeight(ROW_H)
		local bg = r:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(1, 1, 1, (i % 2 == 0) and 0.04 or 0.08)
		r.name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		r.name:SetPoint("LEFT", 6, 0)
		r.name:SetPoint("RIGHT", r, "RIGHT", -70, 0)
		r.name:SetJustifyH("LEFT")
		r.name:SetWordWrap(false)
		r.role = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		r.role:SetPoint("RIGHT", -6, 0)
		f.rows[i] = r
	end
	f:Hide()
	panel = f
	for i = 1, ROWS do
		MakeButton(i)
		BuildGlow(i)
	end
	return f
end

local function Wanted()
	if not Enabled() then
		return false, "switched off (/mh partytargets, or the setting)"
	end
	if IsInRaid and IsInRaid() then
		return false, "in a raid (the panel is for a group of 5)"
	end
	if not (IsInGroup and IsInGroup()) then
		return false, "not in a group"
	end
	return true, "in a group"
end

local function Update()
	if InCombat() then
		pending = true
		RefreshRows() -- names are readable in a fight (measured); visibility waits
		return
	end
	pending = false
	local want = Wanted()
	if want then
		local f = Build()
		f.title:SetText(ns:L("FPARTY_TITLE"))
		f:Show()
		RefreshRows()
		ApplyDispels()
		PlaceButtons()
		SetButtonsLive(true)
	elseif panel then
		SetButtonsLive(false)
		panel:Hide()
	end
end
ns.ForeverPartyPanelUpdate = Update

--------------------------------------------------------------------------------
-- Commands and switch (/mh partytargets is the same command as in Midnight)
--------------------------------------------------------------------------------
function ns.IsForeverPartyPanelOn()
	return Enabled()
end

function ns.SetForeverPartyPanel(on)
	if ns.db then
		ns.db.foreverPartyPanel = on and true or false
	end
	Update()
end

function ns.TogglePartyTargets()
	if InCombat() then
		print(PREFIX .. ns:L("FPARTY_NOT_IN_COMBAT"))
		return
	end
	local on = not Enabled()
	ns.SetForeverPartyPanel(on)
	if ns.SyncNativeSetting then
		ns.SyncNativeSetting("mh_foreverPartyPanel", on)
	end
	local a = MyDispels()
	print(PREFIX .. ns:L(on and "FPARTY_ON" or "FPARTY_OFF"))
	if on and not a then
		print(PREFIX .. ns:L("FPARTY_NO_DISPEL"))
	end
end

function ns.ForeverPartyPanelCheck()
	local want, why = Wanted()
	local a, an, b, bn = MyDispels()
	print(PREFIX .. ("party panel: %s - %s"):format(want and "shown" or "not shown", why))
	print(("  right-click: %s; shift+right-click: %s"):format(a and (an .. " (" .. a .. ")") or "none",
		b and (bn .. " (" .. b .. ")") or "none"))
	local n = 0
	for i = 1, ROWS do
		if glows[i] then
			n = n + 1
		end
	end
	print(("  red edge: %s"):format(glowWhy and ("not available: " .. glowWhy) or
		(panel and (n .. " of " .. ROWS .. " containers built, filter HARMFUL||RAID") or "not built yet (panel never shown)")))
	local live = 0
	for i = 1, ROWS do
		if buttons[i] and buttons[i]:IsShown() then
			live = live + 1
		end
	end
	print(("  click buttons shown: %d; waiting for the end of a fight: %s"):format(live, pending and "yes" or "no"))
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("SPELLS_CHANGED")
pcall(ev.RegisterEvent, ev, "PLAYER_ROLES_ASSIGNED")
pcall(ev.RegisterEvent, ev, "UNIT_NAME_UPDATE")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" and not pending then
		return
	end
	if event == "SPELLS_CHANGED" then
		if panel and panel:IsShown() then
			ApplyDispels()
		end
		return
	end
	if C_Timer and C_Timer.After then
		C_Timer.After(0.2, Update)
	else
		Update()
	end
end)
