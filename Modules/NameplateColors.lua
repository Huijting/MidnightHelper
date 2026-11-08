local _, ns = ...

--[[
	NameplateColors.lua — "what do the colours on my nameplates mean?" (both games).

	Rob, 8 Nov 2026: "Ik gebruik nu MF nameplates. Die hebben bepaalde kleurcodes ... Kan jij uit het spel halen wat
	wat is? Zodat we dat kunnen gaan gebruiken in onze add-on" → the colour card ("Ik wil de kleurkaart" → "Ja, bouw
	allebei").

	MF Nameplates has no licence file, so nothing of it is copied here. MH asks the addon the player already has, while
	they play (the HandyNotes rule): _G.MFNameplates is MF's AceAddon object (MF Core/Init.lua) and .db.profile is the
	player's active profile with MF's defaults behind it (AceDB). So the card shows THIS player's colours, and only the
	rules that are switched on. The meaning of each colour was read from MF's Core/Colors.lua (BaseHealthColor and
	GetThreatColor, 8 Nov 2026), including the order in which colours win.

	  - /mh colors          opens or closes the card (also /mh colours)
	  - /mh colors check    prints which profile is read and every colour with its setting path (the card shows
	                        nothing when MF is missing; this says why)
	Buttons: the Tools room (ToolsLaunchpad.lua) and the Forever start page (HomeDashboard.lua), only when MF is loaded.
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "

local function MF()
	local mf = _G.MFNameplates
	if type(mf) == "table" and type(mf.db) == "table" and type(mf.db.profile) == "table" then
		return mf
	end
	return nil
end

function ns.NameplateColorsAvailable()
	return MF() ~= nil
end

--- "TANK", "DPS" or nil (unknown: the card then shows both aggro blocks).
local function PlayerRole()
	if UnitGroupRolesAssigned then
		local ok, r = pcall(UnitGroupRolesAssigned, "player")
		if ok and type(r) == "string" and not (issecretvalue and issecretvalue(r)) and r ~= "NONE" then
			return r == "TANK" and "TANK" or "DPS"
		end
	end
	local S = C_SpecializationInfo
	if S and S.GetSpecialization and S.GetSpecializationInfo then
		local ok, spec = pcall(S.GetSpecialization)
		if ok and type(spec) == "number" and spec > 0 then
			local ok2, _, _, _, _, role = pcall(S.GetSpecializationInfo, spec)
			if ok2 and type(role) == "string" and not (issecretvalue and issecretvalue(role)) then
				return role == "TANK" and "TANK" or "DPS"
			end
		end
	end
	return nil
end

local function RGB(c)
	if type(c) ~= "table" then
		return 1, 1, 1
	end
	return tonumber(c[1]) or 1, tonumber(c[2]) or 1, tonumber(c[3]) or 1
end

--- The card as a list: { head = key } or { color = {r,g,b}, key = locale key, fmtArg = n } or { note = key }.
--- Each colour row also carries `path`, for /mh colors check.
local function Rows(p)
	local out = {}
	local function head(key)
		out[#out + 1] = { head = key }
	end
	local function row(color, key, path, fmtArg)
		out[#out + 1] = { color = color, key = key, path = path, fmtArg = fmtArg }
	end
	local c = p.colors or {}

	head("NPCOL_HEAD_BAR")
	local re = c.reaction or {}
	row(re.hostile, "NPCOL_HOSTILE", "colors.reaction.hostile")
	row(re.neutral, "NPCOL_NEUTRAL", "colors.reaction.neutral")
	row(re.friendly, "NPCOL_FRIENDLY", "colors.reaction.friendly")
	row(c.tapped, "NPCOL_TAPPED", "colors.tapped")
	if c.quest and c.quest.enabled then
		row(c.quest.hostile, "NPCOL_QUEST", "colors.quest.hostile")
	end
	if c.caster and c.caster.enabled then
		row(c.caster.color, c.caster.instancesOnly and "NPCOL_CASTER_INST" or "NPCOL_CASTER", "colors.caster.color")
	end
	if c.idle and c.idle.enabled then
		if c.idle.mode == "color" then
			row(c.idle.color, "NPCOL_IDLE", "colors.idle.color")
		else -- "dim": MF darkens the normal colour; show the hostile red darkened by the same strength
			local s = 1 - (tonumber(c.idle.strength) or 0.5)
			local r, g, b = RGB(re.hostile)
			row({ r * s, g * s, b * s }, "NPCOL_IDLE", "colors.idle (dim)")
		end
	end
	local w = c.world
	if w and w.enabled then
		local WORLD = {
			{ "rare", "NPCOL_RARE" }, { "rareElite", "NPCOL_RAREELITE" }, { "worldBoss", "NPCOL_WORLDBOSS" },
			{ "prey", "NPCOL_PREY" }, { "elite", "NPCOL_ELITE_WORLD" }, { "highLevel", "NPCOL_HIGHLEVEL_FMT" },
			{ "battlePet", "NPCOL_BATTLEPET" },
		}
		for _, e in ipairs(WORLD) do
			local t = w[e[1]]
			if type(t) == "table" and t.enabled then
				row(t.color, e[2], "colors.world." .. e[1] .. ".color", e[1] == "highLevel" and (tonumber(t.levels) or 3) or nil)
			end
		end
	end

	local ut = c.unitType
	if ut and ut.enabled then
		head(ut.instancesOnly and "NPCOL_HEAD_TYPE_INST" or "NPCOL_HEAD_TYPE")
		row(ut.boss, "NPCOL_BOSS", "colors.unitType.boss")
		row(ut.miniboss, "NPCOL_MINIBOSS", "colors.unitType.miniboss")
		if ut.enableElite then
			row(ut.elite, "NPCOL_ELITE", "colors.unitType.elite")
		end
		if ut.enableTrivial then
			row(ut.trivial, "NPCOL_TRIVIAL", "colors.unitType.trivial")
		end
	end

	local th = c.threat
	if th and th.enabled then
		local role = PlayerRole()
		local dps, tank = th.dps or {}, th.tank or {}
		if role ~= "TANK" then
			head("NPCOL_HEAD_AGGRO_DPS")
			row(dps.aggro, "NPCOL_DPS_AGGRO", "colors.threat.dps.aggro")
			row(dps.pulling, "NPCOL_DPS_PULLING", "colors.threat.dps.pulling")
			if dps.useTankColor then
				row(dps.tank, "NPCOL_DPS_TANK", "colors.threat.dps.tank")
			end
		end
		if role ~= "DPS" then
			head("NPCOL_HEAD_AGGRO_TANK")
			row(tank.noaggro, "NPCOL_TANK_NOAGGRO", "colors.threat.tank.noaggro")
			row(tank.pulling, "NPCOL_TANK_PULLING", "colors.threat.tank.pulling")
			row(tank.anothertank, "NPCOL_TANK_OTHER", "colors.threat.tank.anothertank")
			if tank.useAggroColor then
				row(tank.aggro, "NPCOL_TANK_AGGRO", "colors.threat.tank.aggro")
			end
		end
		out[#out + 1] = { note = "NPCOL_AGGRO_OK" }
	end

	local cast = p.cast
	if cast and cast.enabled then
		local cc = cast.colors or {}
		head("NPCOL_HEAD_CAST")
		row(cc.cast, "NPCOL_CAST", "cast.colors.cast")
		row(cc.channel, "NPCOL_CHANNEL", "cast.colors.channel")
		if cast.useImportantColor then
			row(cc.important, "NPCOL_IMPORTANT", "cast.colors.important")
		end
		row(cc.nointerrupt, "NPCOL_NOINTERRUPT", "cast.colors.nointerrupt")
		row(cc.interrupted, "NPCOL_INTERRUPTED", "cast.colors.interrupted")
		row(cc.finished, "NPCOL_FINISHED", "cast.colors.finished")
		local k = cast.kick
		if k and k.enabled then
			row(k.readyColor, "NPCOL_KICK_READY", "cast.kick.readyColor")
			if k.tick and k.tick.enabled then
				row(k.tick.color, "NPCOL_KICK_TICK", "cast.kick.tick.color")
			end
		end
	end

	out[#out + 1] = { note = (w and w.enabled) and "NPCOL_WINS_WORLD" or "NPCOL_WINS" }
	return out
end

local function ProfileName(mf)
	local ok, name = pcall(function()
		return mf.db:GetCurrentProfile()
	end)
	return ok and name or "?"
end

--------------------------------------------------------------------------------
-- The card
--------------------------------------------------------------------------------

local W = 470
local TEXT_W = W - 80
local win

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperNameplateColors", UIParent, "BackdropTemplate")
	f:SetSize(W, 300)
	f:SetPoint("CENTER", 0, 40)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	f.title:SetPoint("RIGHT", f, "RIGHT", -36, 0)
	f.title:SetJustifyH("LEFT")
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.lines = {} -- reused font strings and swatches
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Escape, docking and Shift+scroll (every MH window scales)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Line(f, i)
	local l = f.lines[i]
	if not l then
		l = {}
		l.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		l.text:SetJustifyH("LEFT")
		l.text:SetWordWrap(true)
		l.swatch = f:CreateTexture(nil, "ARTWORK")
		l.swatch:SetSize(28, 14)
		l.edge = f:CreateTexture(nil, "BORDER")
		l.edge:SetColorTexture(0, 0, 0, 1)
		l.edge:SetPoint("TOPLEFT", l.swatch, "TOPLEFT", -1, 1)
		l.edge:SetPoint("BOTTOMRIGHT", l.swatch, "BOTTOMRIGHT", 1, -1)
		f.lines[i] = l
	end
	return l
end

local function Fill(f)
	for _, l in ipairs(f.lines) do
		l.text:Hide()
		l.swatch:Hide()
		l.edge:Hide()
	end
	f.title:SetText(ns:L("NPCOL_TITLE"))
	local mf = MF()
	local y = -50
	local n = 0
	local function put(text, font, indent, gap)
		n = n + 1
		local l = Line(f, n)
		l.text:SetFontObject(font)
		l.text:ClearAllPoints()
		l.text:SetPoint("TOPLEFT", f, "TOPLEFT", 22 + indent, y - (gap or 0))
		l.text:SetWidth(TEXT_W + 36 - indent)
		l.text:SetText(text)
		l.text:Show()
		local h = math.max(l.text:GetStringHeight(), 14)
		local top = y - (gap or 0)
		y = top - h - 5
		return l, top
	end
	if not mf then
		put(ns:L("NPCOL_NO_MF"), "GameFontHighlight", 0)
	else
		put(ns:L("NPCOL_SUB_FMT"):format(ProfileName(mf)), "GameFontDisableSmall", 0)
		for _, r in ipairs(Rows(mf.db.profile)) do
			if r.head then
				put(ns:L(r.head), "GameFontNormal", 0, 6)
			elseif r.note then
				put(ns:L(r.note), "GameFontDisableSmall", 0, 4)
			else
				local text = r.fmtArg and ns:L(r.key):format(r.fmtArg) or ns:L(r.key)
				local l, top = put(text, "GameFontHighlight", 40)
				l.swatch:ClearAllPoints()
				l.swatch:SetPoint("TOPLEFT", f, "TOPLEFT", 24, top)
				l.swatch:SetColorTexture(RGB(r.color))
				l.swatch:Show()
				l.edge:Show()
			end
		end
	end
	f:SetHeight(-y + 24)
end

function ns.ShowNameplateColors()
	local f = Build()
	Fill(f)
	f:Show()
end

local function Check()
	local mf = MF()
	if not mf then
		print(PREFIX .. "colors: MF Nameplates is not loaded (_G.MFNameplates has no db), so the card has nothing to "
			.. "read. The Tools card and the start-page button stay away on purpose.")
		return
	end
	print(PREFIX .. ("colors: MF %s, profile \"%s\", your role %s"):format(tostring(mf.version), ProfileName(mf),
		tostring(PlayerRole() or "unknown (both aggro blocks shown)")))
	for _, r in ipairs(Rows(mf.db.profile)) do
		if r.color then
			local cr, cg, cb = RGB(r.color)
			print(("  |cff%02x%02x%02x####|r %s = %.2f %.2f %.2f"):format(cr * 255, cg * 255, cb * 255, r.path, cr, cg, cb))
		elseif r.head then
			print("  -- " .. r.head)
		end
	end
end

function ns.NameplateColorsSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" then
		Check()
	elseif win and win:IsShown() then
		win:Hide()
	else
		ns.ShowNameplateColors()
	end
end
