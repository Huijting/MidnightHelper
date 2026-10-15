local _, ns = ...

--[[
	Midnight Helper — a small lamp while the game writes the combat log.

	Rob, 15 Oct 2026, after building tools/combatlog_guide.py with him: "hoe check ik of ik de combat log aan heb
	staan of niet?!?" — `/combatlog` is a toggle, its chat line scrolls away, and a fight logged with the log
	accidentally off is a fight we cannot read afterwards. He picked the lamp ("ja doe dat lampje maar").

	It only READS LoggingCombat(); it never turns logging on or off. Shown only while logging is on, so a player
	who never logs never sees it. Setting: Settings -> "Show a lamp while the combat log is on" (on by default).
	Drag to move (out of combat), Shift+scroll to resize (DialogPopup.lua SCALABLE_WINDOWS).
	`/mh combatlog` prints what the lamp decided and why — this module's normal state is "show nothing".
]]

local FRAME_NAME = "MidnightHelperCombatLogLamp"
local lamp

local function DB()
	if not ns.db then
		return nil
	end
	ns.db.combatLogLamp = ns.db.combatLogLamp or {}
	return ns.db.combatLogLamp
end

function ns.IsCombatLogLampEnabled()
	local d = DB()
	return not (d and d.off == true)
end

function ns.SetCombatLogLampEnabled(on)
	local d = DB()
	if d then
		d.off = not on
	end
	if ns.UpdateCombatLogLamp then
		ns.UpdateCombatLogLamp()
	end
end

--- true / false, or nil with a reason when the game would not say.
local function ReadLogging()
	if type(LoggingCombat) ~= "function" then
		return nil, "LoggingCombat() does not exist in this client"
	end
	local ok, on = pcall(LoggingCombat)
	if not ok then
		return nil, "LoggingCombat() raised an error"
	end
	if issecretvalue and issecretvalue(on) then
		return nil, "LoggingCombat() returned a secret value"
	end
	return on and true or false
end

local function Build()
	local f = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
	f:SetSize(118, 22)
	f:SetFrameStrata("HIGH") -- above the action-bar row Rob keeps at the top of his screen
	f:SetClampedToScreen(true)
	if f.SetBackdrop then
		f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1 })
		f:SetBackdropColor(0, 0, 0, 0.6)
		f:SetBackdropBorderColor(0.8, 0.15, 0.15, 0.9)
	end
	local dot = f:CreateTexture(nil, "ARTWORK")
	dot:SetSize(10, 10)
	dot:SetPoint("LEFT", 7, 0)
	-- A plain colour cut round by the portrait mask: no texture path that a patch can take away.
	dot:SetColorTexture(0.95, 0.1, 0.1, 1)
	if f.CreateMaskTexture then
		local mask = f:CreateMaskTexture()
		mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		mask:SetAllPoints(dot)
		dot:AddMaskTexture(mask)
	end
	local text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	text:SetPoint("LEFT", dot, "RIGHT", 5, 0)
	text:SetText(ns:L("COMBATLOG_LAMP_LABEL"))
	f:SetWidth(math.max(90, (text:GetStringWidth() or 70) + 30))

	-- Pulse, so it reads as "recording" and not as decoration.
	local ag = dot:CreateAnimationGroup()
	ag:SetLooping("BOUNCE")
	local a = ag:CreateAnimation("Alpha")
	a:SetFromAlpha(1)
	a:SetToAlpha(0.25)
	a:SetDuration(0.8)
	ag:Play()

	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		if not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local point, _, relPoint, x, y = self:GetPoint(1)
		local d = DB()
		if d and point then
			d.pos = { point, relPoint, x, y }
		end
	end)
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine(ns:L("COMBATLOG_LAMP_LABEL"), 1, 0.3, 0.3)
		GameTooltip:AddLine(ns:L("COMBATLOG_LAMP_TIP"), 1, 1, 1, true)
		GameTooltip:Show()
	end)
	f:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	local d = DB()
	f:ClearAllPoints()
	if d and type(d.pos) == "table" and d.pos[1] then
		f:SetPoint(d.pos[1], UIParent, d.pos[2] or d.pos[1], d.pos[3] or 0, d.pos[4] or 0)
	else
		f:SetPoint("TOP", UIParent, "TOP", 0, -6)
	end
	f:Hide()
	return f
end

local lastReason = "not checked yet"

function ns.UpdateCombatLogLamp()
	local on, why = ReadLogging()
	local want
	if not ns.IsCombatLogLampEnabled() then
		want, lastReason = false, "the lamp is switched off in Settings"
	elseif on == nil then
		want, lastReason = false, why
	elseif on then
		want, lastReason = true, "the game says the combat log is ON"
	else
		want, lastReason = false, "the game says the combat log is OFF"
	end
	if want and not lamp then
		lamp = Build()
	end
	if lamp then
		lamp:SetShown(want)
	end
	return on, lastReason
end

--- /mh combatlog — the decision and its reason, plus where the file goes.
function ns.MH_CombatLogLampReport()
	local on, reason = ns.UpdateCombatLogLamp()
	local state = (on == true and "|cff44ff44ON|r") or (on == false and "|cffff4444OFF|r") or "|cffffcc00?|r"
	print(("%s %s %s"):format(ns:L("PRINT_PREFIX"), ns:L("COMBATLOG_LAMP_LABEL"), state))
	print(("   %s"):format(reason))
	print(("   %s"):format(ns:L("COMBATLOG_LAMP_WHERE")))
end

if C_Timer and C_Timer.NewTicker then
	-- `/combatlog` fires no event we know of, so look every 2 s; one cheap call.
	C_Timer.NewTicker(2, function()
		if ns.db then
			ns.UpdateCombatLogLamp()
		end
	end)
end
