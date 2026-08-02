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
-- Widened from 260 on 2 Aug: with the role icon in front of it, an 84px name
-- column cut "Captain Garrick" down to "Captain Gar...". Both columns gain here
-- rather than one being robbed for the other — the target column was made
-- deliberately roomy in July after "Daggerspine Myrmidon" ran past the edge, and
-- narrowing it again to pay for the names would walk straight back into that.
local PANEL_W, ROW_H, PAD = 320, 16, 8
local MAX_ROWS = 4
local ROLE_W = 14
local MEMBER_W = 112

local panel, rows
local clicks = {}
-- Forward-declared: the panel's own drag handler is written before this exists,
-- and dragging the panel has to drag the buttons with it.
local PositionClicks

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
		if PositionClicks then
			PositionClicks()
		end
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

		-- Role marker. Rob asked for it while levelling in Timewalking dungeons,
		-- where the group changes every few minutes and "who is the tank" is the
		-- thing you want at a glance.
		--
		-- Two renderings, because only one of them is verified. The atlases
		-- `roleicon-tiny-tank/healer/dps` appear in four addons installed here, so
		-- they exist -- but SetAtlas is asked under pcall and a plain coloured
		-- letter takes over if it ever fails. No texcoords are invented: guessing
		-- numbers into UI-LFG-ICON-ROLES would show the wrong corner of a texture
		-- and look deliberate.
		row.role = panel:CreateTexture(nil, "OVERLAY")
		row.role:SetSize(ROLE_W, ROLE_W)
		row.role:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD, -PAD - (i - 1) * ROW_H - 1)
		row.roleLetter = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if ns.MHScalableFont then
			row.roleLetter:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		end
		row.roleLetter:SetPoint("CENTER", row.role, "CENTER", 0, 0)
		row.roleLetter:Hide()

		row.member = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		if ns.MHScalableFont then
			row.member:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
		end
		row.member:SetPoint("TOPLEFT", panel, "TOPLEFT", PAD + ROLE_W + 4, -PAD - (i - 1) * ROW_H)
		row.member:SetWidth(MEMBER_W)
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

local ROLE_ATLAS = {
	TANK = "roleicon-tiny-tank",
	HEALER = "roleicon-tiny-healer",
	DAMAGER = "roleicon-tiny-dps",
}
local ROLE_LETTER = {
	TANK = { "T", 0.42, 0.62, 1.00 },
	HEALER = { "H", 0.40, 0.95, 0.45 },
	DAMAGER = { "D", 1.00, 0.50, 0.40 },
}

--- Draw a role, preferring the atlas and falling back to a letter.
---
--- SetAtlas can succeed on a name that does not exist and leave the texture blank,
--- so the result is checked rather than trusted — the same guard `Modules/Delves.lua`
--- already uses for its bountiful icon.
local function SetRole(row, role)
	local atlas = ROLE_ATLAS[role]
	local ok = false
	if atlas and row.role.SetAtlas then
		ok = select(1, pcall(row.role.SetAtlas, row.role, atlas))
		if ok then
			local tid = row.role.GetTexture and row.role:GetTexture()
			ok = tid ~= nil and tid ~= 0 and tid ~= ""
		end
	end
	if ok then
		row.role:Show()
		row.roleLetter:Hide()
		return
	end
	row.role:Hide()
	local letter = ROLE_LETTER[role]
	if letter then
		row.roleLetter:SetText(letter[1])
		row.roleLetter:SetTextColor(letter[2], letter[3], letter[4])
		row.roleLetter:Show()
	else
		row.roleLetter:Hide()
	end
end

--- Move the click buttons over the rows. Out of combat only.
---
--- They are parented to UIParent rather than to the panel, and never anchored to
--- it, because a frame that parents or is anchored-to by a secure button becomes
--- protected itself. Keeping the panel unprotected is what lets it still be
--- dragged and hidden mid-fight — which matters to Rob, who asked for this while
--- running Timewalking dungeons where combat barely stops.
---
--- The cost of that choice is here: absolute placement has to be recomputed, and
--- in combat it cannot be. So a drag during a fight leaves the buttons behind
--- until PLAYER_REGEN_ENABLED catches up.
function PositionClicks()
	if not panel or (InCombatLockdown and InCombatLockdown()) then
		return
	end
	local left, top = panel:GetLeft(), panel:GetTop()
	if not (left and top) then
		return
	end
	local w = math.max(1, panel:GetWidth() - PAD * 2)
	for i = 1, MAX_ROWS do
		local b = clicks[i]
		if b then
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left + PAD, top - PAD - (i - 1) * ROW_H)
			b:SetSize(w, ROW_H)
		end
	end
end

--- One secure button per row, permanently bound to that row's unit.
---
--- `unit` is set once to "party<i>target" and never changes, because row i always
--- shows party i. That is the whole trick: SimplePartyTargets has to reassign the
--- attribute as its slots move and therefore guards it with InCombatLockdown
--- (`SimplePartyTargets.lua:3503`), which means a click can go stale mid-fight.
--- A fixed binding cannot.
---
--- Drag is forwarded to the panel so the rows stay draggable even though the
--- buttons now cover them. Clicking still works: a button registered for both
--- fires the click only when no drag happened, exactly like Blizzard's own.
local function EnsureClickButtons()
	for i = 1, MAX_ROWS do
		if not clicks[i] then
			local b = CreateFrame("Button", "MidnightHelperPartyTargetClick" .. i, UIParent,
				"SecureActionButtonTemplate")
			b:SetFrameStrata("DIALOG")
			b:RegisterForClicks("AnyUp")
			b:SetAttribute("*type1", "target")
			b:SetAttribute("unit", "party" .. i .. "target")
			b:RegisterForDrag("LeftButton")
			b:SetScript("OnDragStart", function()
				if panel and panel.StartMoving then
					panel:StartMoving()
				end
			end)
			b:SetScript("OnDragStop", function()
				if panel then
					panel:StopMovingOrSizing()
					SavePos()
				end
				PositionClicks()
			end)
			b:Hide()
			clicks[i] = b
		end
	end
end

local function Refresh()
	if not (ns.db and ns.db.partyTargets) then
		if panel then
			panel:Hide()
		end
		-- The buttons live on UIParent, so hiding the panel does not take them
		-- with it. Left behind they would be an invisible click-catcher over the
		-- middle of the screen.
		if not (InCombatLockdown and InCombatLockdown()) then
			for i = 1, MAX_ROWS do
				if clicks[i] then
					clicks[i]:Hide()
				end
			end
		end
		return
	end
	EnsurePanel()
	EnsureClickButtons()

	local shown = 0
	local visible = {}
	for i = 1, MAX_ROWS do
		local unit = "party" .. i
		local row = rows[i]
		if ReadsTrue(Ask(UnitExists, unit)) then
			shown = shown + 1
			visible[i] = true
			-- UnitGroupRolesAssigned reads for a party member — they are friendly,
			-- and only a hostile target is secret. Ask() guards it anyway; an
			-- unreadable role simply draws nothing rather than guessing "DAMAGER".
			SetRole(row, Ask(UnitGroupRolesAssigned, unit))
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
			row.role:Hide()
			row.roleLetter:Hide()
		end
	end

	-- Showing or hiding a secure button is blocked in combat. Party size does not
	-- change mid-fight in practice, so deferring to PLAYER_REGEN_ENABLED loses
	-- nothing — and attempting it anyway would throw an action-blocked error at
	-- the worst moment.
	if not (InCombatLockdown and InCombatLockdown()) then
		for i = 1, MAX_ROWS do
			if clicks[i] then
				clicks[i]:SetShown(visible[i] and shown > 0 or false)
			end
		end
	end

	if shown == 0 then
		panel:Hide()
		return
	end
	panel:SetHeight(PAD * 2 + ROW_H * shown)
	panel:Show()
	PositionClicks()
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
-- Roles change without a roster change: someone re-queues as tank, or the group
-- finder assigns them on entering a dungeon.
f:RegisterEvent("PLAYER_ROLES_ASSIGNED")
-- Leaving combat is when the secure buttons can finally be shown and repositioned.
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_TARGET", "party1", "party2")
f:SetScript("OnEvent", ScheduleRefresh)
-- UNIT_TARGET only takes two units per registration, so party3/4 need their own.
local f2 = CreateFrame("Frame")
f2:RegisterUnitEvent("UNIT_TARGET", "party3", "party4")
f2:SetScript("OnEvent", ScheduleRefresh)

--- Read/write pair for the settings panel. A slash command alone is not a feature
--- anyone finds: MH's own July review called that out as its heaviest UX fault, and
--- shipping this behind `/mh partytargets` only would have repeated it.
function ns.IsPartyTargetsEnabled()
	return (ns.db and ns.db.partyTargets) and true or false
end

function ns.SetPartyTargetsEnabled(v)
	ns.db = ns.db or {}
	ns.db.partyTargets = v and true or false
	Refresh()
end

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
