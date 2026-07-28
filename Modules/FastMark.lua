--[[
	FastMark — snelle raid-target- + world-marker balk (Rob-wens 4 jul 2026).
	Eigen module; bedoeld als vervanging van de losse FastMarks-addon.

	Sinds patch 12.0 zijn SetRaidTarget én PlaceRaidMarker PROTECTED. Daarom kan dit
	alleen via SecureActionButtons met de door Blizzard aangeleverde routes (geverifieerd
	tegen de werkende FastMarks-addon op 12.0.7 + Warcraft-wiki):
	  target-marker : type="macro", macrotext="/tm N"   (N = 1..8, 0 = wissen)   [Blizzard /tm]
	  world-marker  : type="worldmarker", marker=N, action="set" / "clear"        [wiki-bevestigd]

	De balk is STATISCH (hoeft niet in combat te verplaatsen), dus de secure knoppen
	werken gewoon tijdens gevecht. De balk parent wel secure knoppen → hij wordt
	"protected", dus we mogen 'm alleen BUITEN combat verplaatsen/tonen/verbergen.

	Raid-target index → symbool: 1 Star · 2 Circle · 3 Diamond · 4 Triangle ·
	5 Moon · 6 Square · 7 Cross · 8 Skull.
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Enable-state (SavedVars). Standaard UIT: de balk verschijnt pas als je 'm aanzet.
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return false
	end
	return uiDb.fastMark == true
end

function ns.IsFastMarkEnabled()
	return Enabled()
end

--------------------------------------------------------------------------------
-- Data
--------------------------------------------------------------------------------

-- Volgorde waarin we de target-icoontjes tonen (zoals FastMarks): Skull eerst.
local TARGET_ORDER = { 8, 7, 6, 5, 4, 3, 2, 1 }

-- World-marker knoppen: { naam, raidIconNum, worldMarkerIndex }.
--   worldMarkerIndex = /wm-index (1..8), zoals in de werkende FastMarks-addon.
--   raidIconNum      = het losse UI-RaidTargetingIcon_N-bestand van dàt symbool
--                      (1 Star · 2 Circle · 3 Diamond · 4 Triangle · 5 Moon · 6 Square
--                      · 7 Cross · 8 Skull). We gebruiken de losse iconen i.p.v. één
--                      atlas met texcoords, want die atlas rendert niet betrouwbaar.
local WORLD_MARKERS = {
	{ "Square",   6, 1 },
	{ "Triangle", 4, 2 },
	{ "Diamond",  3, 3 },
	{ "Cross",    7, 4 },
	{ "Star",     1, 5 },
	{ "Circle",   2, 6 },
	{ "Moon",     5, 7 },
	{ "Skull",    8, 8 },
}

local ICON = 22
local PAD = 6
local GAP = 2
local ROWGAP = 4
local GRIP = 12

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------

local bar -- main draggable frame (protected zodra hij secure knoppen parent)

local function SavePos()
	if not bar then
		return
	end
	local p, _, rp, x, y = bar:GetPoint()
	if ns.db and ns.db.ui then
		ns.db.ui.fastMarkPos = { p, rp, x, y }
	end
end

local function L(key, fallback)
	local s = ns.L and ns:L(key)
	if not s or s == key then
		return fallback
	end
	return s
end

local function SecureBtn(name, parent)
	local b = CreateFrame("Button", "MidnightHelperMark" .. name, parent, "SecureActionButtonTemplate")
	b:SetSize(ICON, ICON)
	b:RegisterForClicks("AnyUp", "AnyDown")
	return b
end

local function Tip(self, text)
	if not (GameTooltip and text) then
		return
	end
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddLine(text, 1, 0.82, 0.2)
	GameTooltip:Show()
end
local function TipHide()
	if GameTooltip then
		GameTooltip:Hide()
	end
end

-- Eén target-marker knop (links = markeer doel via /tm N).
local function AddTargetButton(row, idx, prev)
	local b = SecureBtn("Target" .. idx, row)
	b:SetNormalTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(idx))
	if prev then
		b:SetPoint("LEFT", prev, "RIGHT", GAP, 0)
	else
		b:SetPoint("LEFT", row, "LEFT", 0, 0)
	end
	b:SetAttribute("type1", "macro")
	b:SetAttribute("macrotext1", "/tm " .. idx)
	b:SetScript("OnEnter", function(self)
		Tip(self, _G["BINDING_NAME_RAIDTARGET" .. idx] or ("Marker " .. idx))
	end)
	b:SetScript("OnLeave", TipHide)
	return b
end

-- Eén world-marker knop (links = zetten, rechts = wissen).
local function AddWorldButton(row, def, prev)
	local name, raidIcon, num = def[1], def[2], def[3]
	local b = SecureBtn("World" .. name, row)
	b:SetNormalTexture(("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d"):format(raidIcon))
	if prev then
		b:SetPoint("LEFT", prev, "RIGHT", GAP, 0)
	else
		b:SetPoint("LEFT", row, "LEFT", 0, 0)
	end
	b:SetAttribute("type1", "worldmarker")
	b:SetAttribute("marker1", num)
	b:SetAttribute("action1", "set")
	b:SetAttribute("type2", "worldmarker")
	b:SetAttribute("marker2", num)
	b:SetAttribute("action2", "clear")
	b:SetScript("OnEnter", function(self)
		Tip(self, _G["WORLD_MARKER" .. num] or (name .. " world marker"))
	end)
	b:SetScript("OnLeave", TipHide)
	return b
end

-- Wis-knop met macro (rode X-textuur).
local function AddClearButton(row, key, macrotext, tipText, prev)
	local b = SecureBtn(key, row)
	b:SetNormalTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
	if prev then
		b:SetPoint("LEFT", prev, "RIGHT", GAP + 3, 0)
	else
		b:SetPoint("LEFT", row, "LEFT", 0, 0)
	end
	b:SetAttribute("type1", "macro")
	b:SetAttribute("macrotext1", macrotext)
	b:SetScript("OnEnter", function(self)
		Tip(self, tipText)
	end)
	b:SetScript("OnLeave", TipHide)
	return b
end

-- Ready-check knop (GEWONE knop; DoReadyCheck is niet protected). Werkt alleen als je
-- leider/assist bent — anders doet 'ie stil niks.
local function AddReadyCheck(row, prev)
	local b = CreateFrame("Button", "MidnightHelperMarkReadyCheck", row)
	b:SetSize(ICON, ICON)
	b:SetNormalTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
	if prev then
		b:SetPoint("LEFT", prev, "RIGHT", GAP, 0)
	else
		b:SetPoint("LEFT", row, "LEFT", 0, 0)
	end
	b:RegisterForClicks("LeftButtonUp")
	b:SetScript("OnClick", function()
		if DoReadyCheck then
			DoReadyCheck()
		end
	end)
	b:SetScript("OnEnter", function(self)
		Tip(self, L("MARK_READYCHECK", "Ready check"))
	end)
	b:SetScript("OnLeave", TipHide)
	return b
end

local function BuildBar()
	if bar then
		return bar
	end

	-- Rij 1 is het breedst: 8 target-markers + wis + ready-check = 10 knoppen.
	local rowContent = 10 * ICON + 9 * GAP + 3 -- +3 voor de extra ruimte vóór de wis-knop
	local rowW = PAD + rowContent + PAD
	local barW = GRIP + rowW
	local barH = PAD + 2 * ICON + ROWGAP + PAD

	bar = CreateFrame("Frame", "MidnightHelperMarkBar", UIParent, "BackdropTemplate")
	bar:SetSize(barW, barH)
	bar:SetFrameStrata("MEDIUM")
	bar:SetClampedToScreen(true)
	local pos = ns.db and ns.db.ui and ns.db.ui.fastMarkPos
	if type(pos) == "table" and pos[1] then
		bar:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		bar:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
	end
	if bar.SetBackdrop then
		bar:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 },
		})
		bar:SetBackdropColor(0.06, 0.05, 0.04, 0.92)
		bar:SetBackdropBorderColor(1, 0.84, 0.30, 1) -- helder goud, MH-huisstijl
	end
	-- Extra gouden binnenrand voor de kenmerkende MH-look (zoals Missing Buff / Openables).
	local goldEdge = CreateFrame("Frame", nil, bar, "BackdropTemplate")
	goldEdge:SetPoint("TOPLEFT", bar, "TOPLEFT", 2, -2)
	goldEdge:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -2, 2)
	if goldEdge.SetBackdrop then
		goldEdge:SetBackdrop({
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 13,
		})
		goldEdge:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	end

	-- Sleep-grip links (alleen buiten combat verplaatsen; balk is protected).
	local grip = CreateFrame("Frame", nil, bar)
	grip:SetSize(GRIP, barH - 2 * 4)
	grip:SetPoint("LEFT", bar, "LEFT", 3, 0)
	grip:EnableMouse(true)
	grip:RegisterForDrag("LeftButton")
	local gtex = grip:CreateTexture(nil, "OVERLAY")
	gtex:SetPoint("CENTER")
	gtex:SetSize(4, barH - 12)
	gtex:SetColorTexture(1, 0.82, 0.2, 0.5)
	grip:SetScript("OnDragStart", function()
		if not (InCombatLockdown and InCombatLockdown()) then
			bar:StartMoving()
		end
	end)
	grip:SetScript("OnDragStop", function()
		bar:StopMovingOrSizing()
		SavePos()
	end)
	grip:SetScript("OnEnter", function(self)
		Tip(self, L("MARK_DRAG", "Drag to move (out of combat)"))
	end)
	grip:SetScript("OnLeave", TipHide)
	bar:SetMovable(true)

	-- Bovenste rij: world-markers (de vlaggen op de grond). Rob 28 jul: die stonden
	-- eronder en dat las verkeerd om — je zet eerst de plek waar de groep heen moet
	-- en pas daarna een icoon op wat daar staat.
	local worldRow = CreateFrame("Frame", nil, bar)
	worldRow:SetSize(rowW, ICON)
	worldRow:SetPoint("TOPLEFT", bar, "TOPLEFT", GRIP + PAD, -PAD)
	local prev
	for _, def in ipairs(WORLD_MARKERS) do
		prev = AddWorldButton(worldRow, def, prev)
	end
	-- /cwm 9 = alle world-markers wissen (overgenomen van FastMarks; rechtsklik op een
	-- losse knop wist die ene marker).
	AddClearButton(worldRow, "WorldClear", "/cwm 9", L("MARK_CLEAR_WORLD", "Clear all world markers"), prev)

	-- Onderste rij: target-markers (skull/cross op een vijand).
	local targetRow = CreateFrame("Frame", nil, bar)
	targetRow:SetSize(rowW, ICON)
	targetRow:SetPoint("TOPLEFT", worldRow, "BOTTOMLEFT", 0, -ROWGAP)
	prev = nil
	for _, idx in ipairs(TARGET_ORDER) do
		prev = AddTargetButton(targetRow, idx, prev)
	end
	prev = AddClearButton(targetRow, "TargetClear", "/tm 0", L("MARK_CLEAR_TARGET", "Clear target marker"), prev)
	AddReadyCheck(targetRow, prev)

	bar:Hide()
	return bar
end

-- Zichtbaarheid toepassen. Show/Hide van een protected frame mag niet in combat →
-- dan uitstellen tot PLAYER_REGEN_ENABLED.
local pendingApply = false
local function ApplyVisibility()
	-- Alleen tonen als de feature AAN staat én je in een groep/raid zit (markers werken
	-- toch alleen daar). Show/Hide van een protected frame mag niet in combat → uitstellen.
	local want = Enabled() and (IsInGroup and IsInGroup())
	if InCombatLockdown and InCombatLockdown() then
		if bar or want then
			pendingApply = true
		end
		return
	end
	if not want then
		if bar then
			bar:Hide()
		end
		return
	end
	BuildBar()
	bar:Show()
end

function ns.SetFastMarkEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.fastMark = v and true or false
	end
	ApplyVisibility()
end

-- /mh mark → toggelt de balk aan/uit.
function ns.ToggleFastMark()
	ns.SetFastMarkEnabled(not Enabled())
	return Enabled()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GROUP_ROSTER_UPDATE") -- joinen/verlaten van party/raid
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_ENABLED" then
		if pendingApply then
			pendingApply = false
			ApplyVisibility()
		end
		return
	end
	-- Login / zone-in / groep-wijziging: (her)bepaal of de balk zichtbaar moet zijn.
	ApplyVisibility()
end)
