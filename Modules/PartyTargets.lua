local _, ns = ...

--[[
	Midnight Helper — party targets panel (`/mh partytargets`).

	Four lines: each party member and what they are on. Nothing else, and that is
	not modesty — it is the ceiling.

	WHAT 12.x ALLOWS, measured 31 jul (docs/RESEARCH_12_1.md). An enemy target's
	name comes back SECRET through every route: UnitName, UnitFullName, GetUnitName,
	even UnitGUID. UnitIsUnit returns a secret BOOLEAN, so we cannot ask "is this the
	same thing I am on" either. But a secret may be handed to a display widget and
	rendered — proven not by probing but by Rob watching Danders Frames with
	SimplePartyTargets print the very names this addon measures as secret.

	So this panel SHOWS names it cannot READ. There is no sorting by target, no
	"three of four are on yours", no highlighting the row that matches you. Every one
	of those needs to look at the value, and looking is what is refused. If a future
	idea here needs to inspect a name, it cannot be built — that is the design, not
	an omission.

	WHY IT EXISTS AT ALL when SimplePartyTargets does this. That addon anchors to
	Blizzard's compact party frames, and EllesmereUI does not skin those — it
	unregisters, hides and reparents them, with a hooksecurefunc that puts them back
	if anything moves them. So it has nothing to attach to and never draws. This
	panel anchors to nobody, which also means it survives Rob changing UI suite.

	SAFETY RULE FOR THIS FILE. Never let an expression ask what a value is. `x = ok
	and v or nil` throws on a secret boolean because and/or evaluate truthiness, and
	that crashed the probe on 31 jul. Everything goes through Ask() and Secret().
]]

-- Wider than it first was: "Daggerspine Myrmidon" is an ordinary trash mob and it
-- did not fit. Since the text cannot be measured — it is a secret — the only lever
-- is giving it room.
local PANEL_W, ROW_H, PAD = 260, 16, 8
local MAX_ROWS = 4

local panel, rows

local function Secret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

--- Call an API and hand back what it returned, without testing the value.
local function Ask(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, v = pcall(fn, ...)
	if ok then
		return v
	end
	return nil
end

--- true only when the value is readable AND true. A secret answers "unknown", which
--- here has to mean "do not claim it" — the same three-state rule the aura facade
--- uses, for the same reason.
local function ReadsTrue(v)
	if v == nil or Secret(v) then
		return false
	end
	return v == true
end

local function L(key, fallback)
	local s = ns.L and ns:L(key)
	if not s or s == key then
		return fallback
	end
	return s
end

local function SavePos()
	if not panel then
		return
	end
	local p, _, rp, x, y = panel:GetPoint()
	if ns.db and ns.db.ui then
		ns.db.ui.partyTargetsPos = { p, rp, x, y }
	end
end

local function EnsurePanel()
	if panel then
		return panel
	end
	panel = CreateFrame("Frame", "MidnightHelperPartyTargets", UIParent, "BackdropTemplate")
	panel:SetSize(PANEL_W, PAD * 2 + ROW_H * MAX_ROWS)
	panel:SetFrameStrata("MEDIUM")
	panel:SetClampedToScreen(true)
	panel:SetMovable(true)
	panel:EnableMouse(true)
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	panel:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
	end)

	local pos = ns.db and ns.db.ui and ns.db.ui.partyTargetsPos
	if type(pos) == "table" and pos[1] then
		panel:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		panel:SetPoint("CENTER", UIParent, "CENTER", -320, 60)
	end

	if panel.SetBackdrop then
		panel:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		panel:SetBackdropColor(0.06, 0.05, 0.04, 0.92)
		panel:SetBackdropBorderColor(1, 0.84, 0.30, 1)
	end

	rows = {}
	for i = 1, MAX_ROWS do
		local row = {}
		row.member = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if ns.MHScalableFont then
			row.member:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		end
		row.member:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD - (i - 1) * ROW_H)
		row.member:SetWidth(84)
		row.member:SetJustifyH("LEFT")
		row.member:SetTextColor(1, 0.82, 0.2)

		row.target = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if ns.MHScalableFont then
			row.target:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		end
		row.target:SetPoint("TOPLEFT", row.member, "TOPRIGHT", 6, 0)
		row.target:SetPoint("RIGHT", panel, "RIGHT", -PAD, 0)
		row.target:SetJustifyH("LEFT")
		-- One line per member, always. "Daggerspine Myrmidon" wrapped onto a second
		-- line and spilled past the panel, because the rows are a fixed height (Rob,
		-- 31 jul). Growing the row instead would make the panel jump about as targets
		-- change mid-fight, which is worse in a thing you glance at.
		--
		-- It clips rather than truncating with an ellipsis, and that is on purpose:
		-- adding "..." means measuring the string, and the string is a secret we are
		-- not allowed to look at.
		row.target:SetWordWrap(false)
		if row.target.SetMaxLines then
			row.target:SetMaxLines(1)
		end
		row.member:SetWordWrap(false)
		if row.member.SetMaxLines then
			row.member:SetMaxLines(1)
		end
		rows[i] = row
	end
	panel:Hide()
	return panel
end

local function Refresh()
	if not (ns.db and ns.db.partyTargets) then
		if panel then
			panel:Hide()
		end
		return
	end
	EnsurePanel()

	local shown = 0
	for i = 1, MAX_ROWS do
		local unit = "party" .. i
		local row = rows[i]
		if ReadsTrue(Ask(UnitExists, unit)) then
			shown = shown + 1
			-- A party member's own name reads normally; only their enemy target is
			-- protected. Both are passed straight to SetText regardless — the widget
			-- accepts a secret, we simply never look at one.
			row.member:SetText(Ask(UnitName, unit))
			local tUnit = unit .. "target"
			if ReadsTrue(Ask(UnitExists, tUnit)) then
				-- UnitExists is the gate BECAUSE it reads where the name does not.
				-- Branching on the name itself would mean inspecting a secret.
				row.target:SetText(Ask(UnitName, tUnit))
			else
				row.target:SetText(L("PARTYTARGETS_NONE", "|cff9d9d9d— no target —|r"))
			end
			row.member:Show()
			row.target:Show()
		else
			row.member:Hide()
			row.target:Hide()
		end
	end

	if shown == 0 then
		panel:Hide()
		return
	end
	panel:SetHeight(PAD * 2 + ROW_H * shown)
	panel:Show()
end

--- Refresh is cheap but UNIT_TARGET fires a lot in combat, so coalesce into the
--- next frame rather than redrawing per event.
local pending = false
local function ScheduleRefresh()
	if pending or not (C_Timer and C_Timer.After) then
		return
	end
	pending = true
	C_Timer.After(0.1, function()
		pending = false
		pcall(Refresh)
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterUnitEvent("UNIT_TARGET", "party1", "party2")
f:SetScript("OnEvent", ScheduleRefresh)
-- UNIT_TARGET only takes two units per registration, so party3/4 need their own.
local f2 = CreateFrame("Frame")
f2:RegisterUnitEvent("UNIT_TARGET", "party3", "party4")
f2:SetScript("OnEvent", ScheduleRefresh)

--- `/mh partytargets` — toggle. Off by default: MH does not put frames on someone's
--- screen uninvited.
function ns.TogglePartyTargets()
	ns.db = ns.db or {}
	ns.db.partyTargets = not ns.db.partyTargets
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	if ns.db.partyTargets then
		print(("%s %s"):format(p, L("PARTYTARGETS_ON",
			"Party targets ON — drag the panel where you want it. Shows in a party only.")))
	else
		print(("%s %s"):format(p, L("PARTYTARGETS_OFF", "Party targets OFF.")))
	end
	Refresh()
end

ns.RefreshPartyTargets = Refresh
