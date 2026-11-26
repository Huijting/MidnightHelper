local _, ns = ...

--[[
	ForeverLootSparkle.lua — WoW Forever: quest items you can loot sparkle again instead of getting an outline.
	Rob, 20 Nov 2026 (via sparring): "en begin met 4, loot sparkles :)". Idea: docs/IDEEEN.md "Forever: Loot Sparkles".

	The idea comes from the addon "Forever Loot Sparkles" (conoar, GPLv3). We are MIT: NO code taken, only the idea
	and the CVar names from its page, and those were MEASURED in Rob's Forever client before use (20 Nov 2026,
	/run probe -> MidnightHelperDB.cvp1, with graphicsOutlineMode as the control: "2", the same as Config.wtf):
	  outlineModeShowLootEffectWhenDisabled "0", graphicsOutlineMode "2", OutlineEngineMode "2",
	  RAIDOutlineEngineMode "2"; raidGraphicsOutlineMode "2" (Config.wtf).
	All five exist. What MH sets: the loot effect 1, the four outline CVars 0 (as the addon page describes).
	NOT measured: that this really makes quest items sparkle on screen (Rob tests), and the page's claim that the
	outline only comes back after a full restart (so the off-text says "if it does not return, restart").
	NOT built yet: herbs and ore. 20 Nov 2026: first a measurement, /mh sparkle nodes (see NodeProbe below).

	Same keep-and-put-back as KeyBlock.lua: the value before MH touched it is kept in ns.db.lootSparkle.saved and
	switching off puts exactly that back. Off by default. Never in combat (waits for PLAYER_REGEN_ENABLED). A graphics
	preset sets the outline back; CVAR_UPDATE (pcall: not measured in Forever) makes MH set it again a second later.
	Silence rule (CLAUDE.md): /mh sparkle prints every CVar, the value now, ours, the kept one, and the last decision.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- name, the value MH sets
local SET = {
	{ "outlineModeShowLootEffectWhenDisabled", "1" },
	{ "graphicsOutlineMode", "0" },
	{ "raidGraphicsOutlineMode", "0" },
	{ "OutlineEngineMode", "0" },
	{ "RAIDOutlineEngineMode", "0" },
}
local OURS = {}
for _, r in ipairs(SET) do
	OURS[r[1]] = r[2]
end

local state = { last = "nothing yet", pending = false, applied = 0, reapplied = 0, watch = false }

local function Db()
	if not ns.db then
		return nil
	end
	ns.db.lootSparkle = ns.db.lootSparkle or {}
	return ns.db.lootSparkle
end

local function Get(name)
	if not (C_CVar and C_CVar.GetCVar) then
		return nil
	end
	local ok, v = pcall(C_CVar.GetCVar, name)
	if ok then
		return v
	end
	return nil
end

local function Set(name, value)
	if not (C_CVar and C_CVar.SetCVar) then
		return false
	end
	local ok, res = pcall(C_CVar.SetCVar, name, value)
	return ok and res ~= false
end

local function Note(s)
	state.last = s
	local d = Db()
	if d then
		d.last = s
	end
end

function ns.IsLootSparkleOn()
	local d = ns.db and ns.db.lootSparkle
	return d and d.on == true or false
end

--- Set our values; keep the old ones the first time. Returns changed, missing.
local function Apply(why)
	if not ns.IsLootSparkleOn() then
		return 0, 0
	end
	if InCombatLockdown() then
		state.pending = true
		Note(why .. ": waiting for the end of combat")
		return 0, 0
	end
	state.pending = false
	local d = Db()
	d.saved = d.saved or {}
	local changed, right, missing, failed = 0, 0, 0, 0
	-- 20 Nov 2026: keep EVERY old value first, then set. Rob's SV kept OutlineEngineMode "0" although cvp1 measured "2":
	-- setting graphicsOutlineMode to 0 first moved the engine CVars along (AFGELEID), so they were read after the change.
	local before = {}
	for _, r in ipairs(SET) do
		before[r[1]] = Get(r[1])
		if before[r[1]] ~= nil and d.saved[r[1]] == nil then
			d.saved[r[1]] = before[r[1]]
		end
	end
	for _, r in ipairs(SET) do
		local name, want = r[1], r[2]
		local cur = before[name]
		if cur == nil then
			missing = missing + 1
		else
			if cur == want then
				right = right + 1
			elseif Set(name, want) then
				changed = changed + 1
			else
				failed = failed + 1
			end
		end
	end
	state.applied = state.applied + 1
	Note(("%s: %d set, %d already right, %d missing, %d failed"):format(why, changed, right, missing, failed))
	return changed, missing
end

--- Put back what was there before MH.
local function Restore()
	local d = Db()
	local n = 0
	if d and d.saved then
		for name, old in pairs(d.saved) do
			if Set(name, old) then
				n = n + 1
			end
		end
		d.saved = nil
	end
	state.pending = false
	Note(("switched off: %d setting(s) put back"):format(n))
	return n
end

function ns.SetLootSparkle(on)
	local d = Db()
	if not d then
		return
	end
	if on then
		d.on = true
		local changed = Apply("switched on")
		print(PREFIX .. ns:L("FLS_ON"):format(changed))
	else
		d.on = nil
		Restore()
		print(PREFIX .. ns:L("FLS_OFF"))
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
state.watch = pcall(ev.RegisterEvent, ev, "CVAR_UPDATE") and true or false
ev:SetScript("OnEvent", function(_, event, name, value)
	if not ns.IsLootSparkleOn() then
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		Apply("login/loading screen")
	elseif event == "PLAYER_REGEN_ENABLED" then
		if state.pending then
			Apply("after combat")
		end
	elseif event == "CVAR_UPDATE" then
		-- A graphics preset (or the player) moved one of ours: set it again a second later, as the idea describes.
		if type(name) == "string" and OURS[name] and tostring(value) ~= OURS[name] then
			state.reapplied = state.reapplied + 1
			C_Timer.After(1, function()
				Apply(name .. " changed by the game")
			end)
		end
	end
end)

--[[ /mh sparkle nodes — MEASUREMENT for herbs and ore (Rob, 20 Nov 2026 via sparring: "ja graag" on "wil je dat erts en
	kruiden ook gaan glinsteren? Dan zoekt de bouwchat eerst uit hoe dat moet. Daarna doe jij een kleine meting").
	Research (mh-research, 20 Nov): the UI source has NO sparkle CVar for nodes. Node addons (idea: Lueur, MIT on its CF
	page; NO code taken) switch soft-targeting on so the game picks ONE object near you ("softinteract") and shows its
	icon/nameplate, then draw on that. This probe measures, on Rob's client, before and after MH sets those values:
	which CVars exist (C_CVar.GetCVarInfo), which console commands match (ConsoleGetAllCommands), and what the game says
	about "softinteract". The values stay on for 30 seconds so Rob can look at the vein, then MH puts back exactly what
	was there. Result: MidnightHelperDB.nodeProbe (after /reload or logout). ]]
local NODE_SET = {
	{ "SoftTargetInteract", "3" },
	{ "SoftTargetInteractArc", "2" },
	{ "SoftTargetInteractRange", "15" },
	{ "SoftTargetIconGameObject", "1" },
	{ "SoftTargetIconInteract", "1" },
	{ "SoftTargetNameplateInteract", "1" },
}
local NODE_INFO = {
	"SoftTargetInteract", "SoftTargetInteractArc", "SoftTargetInteractRange", "SoftTargetInteractOnlyInRange",
	"SoftTargetInteractRangeIsHard", "SoftTargetIconGameObject", "SoftTargetIconInteract", "SoftTargetIconEnemy",
	"SoftTargetLowPriorityIcons", "SoftTargetNameplateInteract", "SoftTargetNameplateSize", "SoftTargetTooltipInteract",
	"SoftTargetWorldtextSize", "nameplateGameObjectMaxDistance", "nameplateMaxDistance", "Outline", "graphicsOutlineMode",
	"OutlineEngineMode", "outlineModeShowLootEffectWhenDisabled",
}
local NODE_WORDS = { "softtarget", "outline", "loot", "gather", "highlight", "sparkle", "glow", "worldtext",
	"gameobject", "interact" }
-- The three that are installed in Rob's Forever AddOns folder and touch soft-targeting (folder names GEMETEN 20 Nov).
local NODE_ADDONS = { "Lueur", "BetterFishing", "MFNameplates" }
local NODE_HOLD = 30

local probe = { running = false }

local function Str(v)
	if v ~= nil and issecretvalue and issecretvalue(v) then
		return "SECRET"
	end
	return tostring(v)
end

local cursorTex
local function SoftInteract(label)
	local r = { label = label, t = GetTime and math.floor(GetTime()) or 0 }
	local function Call(key, fn, ...)
		if type(fn) ~= "function" then
			r[key] = "no API"
			return nil
		end
		local ok, v = pcall(fn, ...)
		r[key] = ok and Str(v) or ("error: " .. tostring(v))
		return ok and v or nil
	end
	Call("exists", UnitExists, "softinteract")
	Call("isGameObject", UnitIsGameObject, "softinteract")
	Call("name", UnitName, "softinteract")
	Call("guid", UnitGUID, "softinteract")
	Call("inRange", UnitIsInInteractRange, "softinteract")
	if C_NamePlate and C_NamePlate.GetNamePlateForUnit then
		local ok, plate = pcall(C_NamePlate.GetNamePlateForUnit, "softinteract")
		if ok and plate then
			r.plate = "yes"
			local okF, forb = pcall(plate.IsForbidden, plate)
			r.plateForbidden = okF and Str(forb) or "?"
			if not (okF and forb) then
				local okS, shown = pcall(plate.IsShown, plate)
				r.plateShown = okS and Str(shown) or "?"
			end
		else
			r.plate = ok and "no" or ("error: " .. tostring(plate))
		end
	else
		r.plate = "no API"
	end
	if SetUnitCursorTexture then
		if not cursorTex then
			local holder = CreateFrame("Frame")
			holder:Hide()
			cursorTex = holder:CreateTexture()
		end
		cursorTex:SetTexture(nil)
		local ok, res = pcall(SetUnitCursorTexture, cursorTex, "softinteract")
		r.cursorSet = ok and Str(res) or ("error: " .. tostring(res))
		local okT, tex = pcall(cursorTex.GetTexture, cursorTex)
		r.cursorTexture = okT and Str(tex) or "?"
		local okA, atlas = pcall(cursorTex.GetAtlas, cursorTex)
		r.cursorAtlas = okA and Str(atlas) or "?"
	else
		r.cursorSet = "no API"
	end
	return r
end

local function NodeRestore(why)
	local p = ns.db and ns.db.nodeProbe
	if not (p and p.saved) then
		return 0
	end
	if InCombatLockdown() then
		probe.restoreAfterCombat = true
		p.restoreNote = why .. ": in combat, waits for the fight to end"
		return 0
	end
	local n = 0
	for name, old in pairs(p.saved) do
		if Set(name, old) then
			n = n + 1
		end
	end
	p.restored = {}
	for name in pairs(p.saved) do
		p.restored[name] = Get(name)
	end
	p.saved = nil
	p.restoreNote = ("%s: %d setting(s) put back"):format(why, n)
	probe.running = false
	print(PREFIX .. "node probe: " .. p.restoreNote .. ". /reload, then the result is in MidnightHelperDB.nodeProbe.")
	return n
end

local probeEv = CreateFrame("Frame")
probeEv:RegisterEvent("PLAYER_LOGOUT")
probeEv:RegisterEvent("PLAYER_ENTERING_WORLD")
probeEv:RegisterEvent("PLAYER_REGEN_ENABLED")
pcall(probeEv.RegisterEvent, probeEv, "PLAYER_SOFT_INTERACT_CHANGED")
probeEv:SetScript("OnEvent", function(_, event)
	local p = ns.db and ns.db.nodeProbe
	if not p then
		return
	end
	if event == "PLAYER_SOFT_INTERACT_CHANGED" then
		if probe.running then
			p.changes = p.changes or {}
			if #p.changes < 12 then
				p.changes[#p.changes + 1] = SoftInteract("soft interact changed")
			end
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if probe.restoreAfterCombat then
			probe.restoreAfterCombat = false
			NodeRestore("after the fight")
		end
	elseif p.saved then
		-- Safety net: a /reload or logout during the 30 seconds must never leave our values behind.
		NodeRestore(event == "PLAYER_LOGOUT" and "logout during the probe" or "loading screen during the probe")
	end
end)

local function NodeProbe(force)
	if probe.running then
		print(PREFIX .. "node probe is already running; MH puts everything back by itself.")
		return
	end
	if InCombatLockdown() then
		print(PREFIX .. "node probe: not in combat. Try again after the fight.")
		return
	end
	if not ns.db then
		return
	end
	local p = { at = date and date("%Y-%m-%d %H:%M:%S") or "?", char = Str(UnitName("player")), addons = {}, cvars = {},
		console = {}, saved = {}, set = {} }
	local blocker
	for _, a in ipairs(NODE_ADDONS) do
		local loaded = false
		if C_AddOns and C_AddOns.IsAddOnLoaded then
			local ok, v = pcall(C_AddOns.IsAddOnLoaded, a)
			loaded = ok and v and true or false
		end
		p.addons[a] = loaded
		if loaded and a == "Lueur" then
			blocker = a
		end
	end
	if blocker and not force then
		print(PREFIX .. ("node probe: %s is on for this character, so the probe would measure %s, not the game. Switch it off "
			.. "(AddOns list) and /reload, or type /mh sparkle nodes force."):format(blocker, blocker))
		return
	end
	for _, name in ipairs(NODE_INFO) do
		local row
		if C_CVar and C_CVar.GetCVarInfo then
			local ok, v, def, acc, chr, locked, secure, ro = pcall(C_CVar.GetCVarInfo, name)
			if ok and v ~= nil then
				row = { value = Str(v), default = Str(def), account = Str(acc), character = Str(chr), locked = Str(locked),
					secure = Str(secure), readOnly = Str(ro) }
			end
		end
		p.cvars[name] = row or "MISSING"
	end
	if ConsoleGetAllCommands then
		local ok, list = pcall(ConsoleGetAllCommands)
		if ok and type(list) == "table" then
			p.consoleTotal = #list
			for _, c in ipairs(list) do
				local cmd = type(c) == "table" and type(c.command) == "string" and c.command or nil
				if cmd then
					local low = cmd:lower()
					for _, w in ipairs(NODE_WORDS) do
						if low:find(w, 1, true) then
							p.console[#p.console + 1] = { command = cmd, help = Str(c.help), commandType = Str(c.commandType),
								category = Str(c.category) }
							break
						end
					end
				end
			end
		else
			p.consoleTotal = "error: " .. tostring(list)
		end
	else
		p.consoleTotal = "no API"
	end
	p.before = SoftInteract("before")
	ns.db.nodeProbe = p
	for _, r in ipairs(NODE_SET) do
		local cur = Get(r[1])
		if cur ~= nil then
			p.saved[r[1]] = cur
		end
	end
	for _, r in ipairs(NODE_SET) do
		if p.saved[r[1]] ~= nil then
			p.set[r[1]] = Set(r[1], r[2]) and r[2] or "FAILED"
		else
			p.set[r[1]] = "MISSING"
		end
	end
	probe.running = true
	print(PREFIX .. ("node probe: soft-target values set. Stand at an ore vein or herb and look: an icon above it? "
		.. "In %d seconds MH puts your old values back by itself."):format(NODE_HOLD))
	C_Timer.After(1.5, function()
		if ns.db.nodeProbe == p then
			p.after = SoftInteract("after 1.5 s")
			p.afterValues = {}
			for _, r in ipairs(NODE_SET) do
				p.afterValues[r[1]] = Str(Get(r[1]))
			end
		end
	end)
	C_Timer.After(NODE_HOLD - 2, function()
		if ns.db.nodeProbe == p and p.saved then
			p.late = SoftInteract("after 28 s")
		end
	end)
	C_Timer.After(NODE_HOLD, function()
		if ns.db.nodeProbe == p then
			NodeRestore("30 seconds over")
		end
	end)
end

--[[ Ore and herbs, two switches. Rob, 20 Nov 2026 (via sparring), verbatim: "reload gedaan, en ik wil beide met idd de
	schakelaars" = A (the game's own icon) and B (MH draws a glow), each its own switch, off by default.
	GEMETEN in Rob's /mh sparkle nodes (Forever, "Anna", Lueur off, a Copper Vein in a cave, 20 Nov 22:07):
	  before: no soft-interact object. After setting NODE_SET: softinteract = "Copper Vein", UnitIsGameObject true,
	  GUID GameObject-…-1731-…, a nameplate (shown, not forbidden), cursor texture "Cursor Crosshair_Mine_64" in range and
	  "Cursor Crosshair_UnableMine_64" out of range; UnitExists("softinteract") = FALSE for it (so never test that).
	  Rob's screenshot: a pickaxe icon above the vein. Restore put back exactly the old values (1/0/10/0/1/1).
	  SoftTargetInteract and -Range are "secure" CVars (GetCVarInfo): only ever set out of combat.
	A = NODE_SET on. B = MH puts a glow on the nameplate of "softinteract" when its cursor says Mine or (AFGELEID, the
	herb cursor is GatherHerbs in the client art) Herb. B needs the same CVars (no nameplate without them), so the icon
	comes along with B. Both stand down when Lueur is loaded: it flips these CVars itself every 0.12 s. ]]
local nodeState = { last = "nothing yet", pending = false, kind = nil, name = nil, unable = false, shown = false,
	lueur = nil, reapplied = 0 }

local function NodeDb()
	if not ns.db then
		return nil
	end
	ns.db.nodeSparkle = type(ns.db.nodeSparkle) == "table" and ns.db.nodeSparkle or {}
	return ns.db.nodeSparkle
end

local function LueurOn()
	if nodeState.lueur == nil and C_AddOns and C_AddOns.IsAddOnLoaded then
		local ok, v = pcall(C_AddOns.IsAddOnLoaded, "Lueur")
		nodeState.lueur = ok and v and true or false
	end
	return nodeState.lueur == true
end

function ns.IsNodeIconOn()
	local d = ns.db and ns.db.nodeSparkle
	return d and d.icon == true or false
end

function ns.IsNodeGlowOn()
	local d = ns.db and ns.db.nodeSparkle
	return d and d.glow == true or false
end

local function NodeNeedsCVars()
	return (ns.IsNodeIconOn() or ns.IsNodeGlowOn()) and not LueurOn()
end

local function NodeNote(s)
	nodeState.last = s
	local d = NodeDb()
	if d then
		d.last = s
	end
end

local NODE_OURS = {}
for _, r in ipairs(NODE_SET) do
	NODE_OURS[r[1]] = r[2]
end

--- What MH sets each CVar to while A or B is on. 21 Nov 2026: for a moment B left SoftTargetIconGameObject at 0 when A
--- was off. Rob MEASURED it in the game the same day (Paladin, Mining, a vein, with screenshots): A off + B on = no
--- game icon AND no MH glow; A on + B on = both. The glow needs the game's icon setting, so B sets it again, and the
--- switch text says the icon comes with it.
local function Wanted(name)
	return NODE_OURS[name]
end

--- Set the soft-target values; keep the old ones first (all read before any is set).
local function NodeApply(why)
	if not NodeNeedsCVars() then
		return 0
	end
	if InCombatLockdown() then
		nodeState.pending = true
		NodeNote(why .. ": waiting for the end of combat")
		return 0
	end
	nodeState.pending = false
	local d = NodeDb()
	d.saved = d.saved or {}
	local before = {}
	for _, r in ipairs(NODE_SET) do
		before[r[1]] = Get(r[1])
		if before[r[1]] ~= nil and d.saved[r[1]] == nil then
			d.saved[r[1]] = before[r[1]]
		end
	end
	local changed, failed = 0, 0
	for _, r in ipairs(NODE_SET) do
		local cur = before[r[1]]
		local want = Wanted(r[1])
		-- Range comes back as "15.000000": compare as numbers.
		if cur ~= nil and tonumber(cur) ~= tonumber(want) then
			if Set(r[1], want) then
				changed = changed + 1
			else
				failed = failed + 1
			end
		end
	end
	NodeNote(("%s: %d set, %d failed"):format(why, changed, failed))
	return changed
end

local function NodeRestoreSaved(why)
	local d = NodeDb()
	local n = 0
	if InCombatLockdown() then
		nodeState.pending = true
		NodeNote(why .. ": putting back waits for the end of combat")
		return 0
	end
	if d and d.saved then
		for name, old in pairs(d.saved) do
			if Set(name, old) then
				n = n + 1
			end
		end
		d.saved = nil
	end
	nodeState.pending = false
	NodeNote(("%s: %d setting(s) put back"):format(why, n))
	return n
end

-- The glow (B). One frame, moved onto the soft-interact nameplate; star4 is the game's own sparkle texture
-- (Blizzard_HeirloomCollection.xml uses interface\cooldown\star4 with ADD in the Forever UI source).
local GLOW_TEX = "Interface\\Cooldown\\star4"
local GLOW_OFFSET_Y = -40 -- AFGELEID: the plate sits above the object; Rob's screenshot settles the spot.
local glow
local function BuildGlow()
	if glow then
		return glow
	end
	glow = CreateFrame("Frame", nil, UIParent)
	glow:SetSize(90, 90)
	glow:Hide()
	local function Layer(size, secs, dir)
		local t = glow:CreateTexture(nil, "OVERLAY")
		t:SetTexture(GLOW_TEX)
		t:SetBlendMode("ADD")
		t:SetSize(size, size)
		t:SetPoint("CENTER")
		local ag = t:CreateAnimationGroup()
		local rot = ag:CreateAnimation("Rotation")
		rot:SetDegrees(360 * dir)
		rot:SetDuration(secs)
		ag:SetLooping("REPEAT")
		ag:Play()
		return t
	end
	glow.a = Layer(90, 6, 1)
	glow.b = Layer(60, 4, -1)
	local pulse = glow:CreateAnimationGroup()
	local fade = pulse:CreateAnimation("Alpha")
	fade:SetFromAlpha(1)
	fade:SetToAlpha(0.45)
	fade:SetDuration(0.8)
	pulse:SetLooping("BOUNCE")
	pulse:Play()
	return glow
end

local function HideGlow()
	if glow and glow:IsShown() then
		glow:Hide()
		glow:ClearAllPoints()
		glow:SetParent(UIParent)
	end
	nodeState.shown = false
end

local nodeTex
local function SoftKind()
	local okG, isGO = pcall(UnitIsGameObject, "softinteract")
	if not okG or not isGO or (issecretvalue and issecretvalue(isGO)) then
		return nil
	end
	if not SetUnitCursorTexture then
		return nil
	end
	if not nodeTex then
		local holder = CreateFrame("Frame")
		holder:Hide()
		nodeTex = holder:CreateTexture()
	end
	nodeTex:SetTexture(nil)
	if not pcall(SetUnitCursorTexture, nodeTex, "softinteract") then
		return nil
	end
	local okT, tex = pcall(nodeTex.GetTexture, nodeTex)
	if not okT or tex == nil or (issecretvalue and issecretvalue(tex)) then
		return nil
	end
	local low = tostring(tex):lower()
	nodeState.cursor = tostring(tex) -- 21 Nov 2026: shown in /mh sparkle, the source of the colour
	local unable = low:find("unable", 1, true) ~= nil
	if low:find("mine", 1, true) then
		return "ore", unable
	elseif low:find("herb", 1, true) then
		return "herb", unable
	end
	return nil
end

local function UpdateGlow()
	if not ns.IsNodeGlowOn() or LueurOn() then
		HideGlow()
		return
	end
	local kind, unable = SoftKind()
	nodeState.kind, nodeState.unable = kind, unable and true or false
	local okN, name = pcall(UnitName, "softinteract")
	nodeState.name = okN and not (issecretvalue and issecretvalue(name)) and name or nil
	if not kind then
		HideGlow()
		return
	end
	if not (C_NamePlate and C_NamePlate.GetNamePlateForUnit) then
		HideGlow()
		return
	end
	local okP, np = pcall(C_NamePlate.GetNamePlateForUnit, "softinteract")
	if not okP or not np or (np.IsForbidden and np:IsForbidden()) then
		HideGlow()
		return
	end
	local g = BuildGlow()
	-- 21 Nov 2026 (Rob: a WHITE star on Peacebloom, "Deze IMA heeft wel herbalism"): the colour was chosen only when the
	-- node was picked up, up to 15 yd away (SoftTargetInteractRange). Out of gathering range the game's cursor says
	-- "Unable" (GEMETEN on ore 20 Nov: Crosshair_UnableMine_64 out of range), so the star went grey and stayed grey while
	-- you walked up. Now it is looked at again 5 times a second while it shows (AFGELEID that this was the cause).
	if not g.ticking then
		g.ticking = true
		local acc = 0
		g:SetScript("OnUpdate", function(_, elapsed)
			acc = acc + (elapsed or 0)
			if acc >= 0.2 then
				acc = 0
				pcall(UpdateGlow)
			end
		end)
	end
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local profName = kind == "herb" and "Herbalism" or "Mining"
	local prof = mine[kind == "herb" and "HERBALISM" or "MINING"]
	local skill = prof and ((prof.rank and prof.maxRank) and ("%d/%d"):format(prof.rank, prof.maxRank) or "learned")
		or "not learned"
	-- 21 Nov 2026, option C (Rob: "c dus haha"): MH also looks at your own skill. The game's "Unable" means too far away
	-- OR not able (GEMETEN by Rob that day: far = grey, close = green on the same herb). So: can you gather it (the
	-- profession, and the skill this node needs from ForeverNodeSkillData.lua, entry id = GUID field 6) → its normal
	-- colour even from far away; really cannot (no profession, or skill below what it needs) → RED.
	local need
	local okG, guid = pcall(UnitGUID, "softinteract")
	if okG and type(guid) == "string" and not (issecretvalue and issecretvalue(guid)) then
		local entry = tonumber(guid:match("^GameObject%-[^%-]+%-[^%-]+%-[^%-]+%-[^%-]+%-(%d+)"))
		need = entry and ns.FOREVER_NODE_SKILL and ns.FOREVER_NODE_SKILL[entry] or nil
		nodeState.entry = entry
	end
	local rank = prof and tonumber(prof.rank)
	-- 21 Nov 2026 (Rob, letterlijk: "eigenlijk zouden we die dingen alleen maar moeten kunnen zien op het moment dat we het
	-- ook echt hebben"): no profession → no glow at all (not even red). Skill too low stays red ("not yet").
	if not prof then
		HideGlow()
		nodeState.colour = "none"
		nodeState.reason = ("skipped: no %s"):format(profName)
		nodeState.lastNode = ("%s (object %s), kind %s, colour none, reason: %s, cursor %s"):format(
			tostring(nodeState.name or "?"), tostring(nodeState.entry or "?"), tostring(kind), nodeState.reason,
			tostring(nodeState.cursor or "?"))
		return
	end
	local cannot = unable and need and rank and rank < need
	nodeState.need = need
	if cannot then
		g.a:SetVertexColor(1, 0.2, 0.15)
		g.b:SetVertexColor(1, 0.4, 0.3)
		nodeState.colour = "red"
		nodeState.reason = not prof and ("you have no %s"):format(profName)
			or ("%s too low: yours %s, this one needs %d"):format(profName, skill, need)
	elseif unable then
		-- Unable but you CAN gather it: too far away (or a reason the game knows and MH does not). Normal colour.
		if kind == "herb" then
			g.a:SetVertexColor(0.55, 1, 0.45)
			g.b:SetVertexColor(0.8, 1, 0.6)
			nodeState.colour = "green"
		else
			g.a:SetVertexColor(1, 0.8, 0.3)
			g.b:SetVertexColor(1, 0.95, 0.6)
			nodeState.colour = "gold"
		end
		nodeState.reason = ("too far away to gather yet; you can (%s %s%s)"):format(profName, skill,
			need and (", needs " .. need) or ", what this one needs is not in MH's list")
	elseif kind == "herb" then
		g.a:SetVertexColor(0.55, 1, 0.45)
		g.b:SetVertexColor(0.8, 1, 0.6)
		nodeState.colour, nodeState.reason = "green", "you can pick it (Herbalism " .. skill .. ")"
	else
		g.a:SetVertexColor(1, 0.8, 0.3)
		g.b:SetVertexColor(1, 0.95, 0.6)
		nodeState.colour, nodeState.reason = "gold", "you can mine it (Mining " .. skill .. ")"
	end
	nodeState.lastNode = ("%s (object %s), kind %s, colour %s, reason: %s, cursor %s"):format(
		tostring(nodeState.name or "?"), tostring(nodeState.entry or "?"), tostring(kind), nodeState.colour,
		nodeState.reason, tostring(nodeState.cursor or "?"))
	g:SetParent(np)
	g:ClearAllPoints()
	g:SetPoint("CENTER", np, "CENTER", 0, GLOW_OFFSET_Y)
	g:Show()
	nodeState.shown = true
end

local function NodeSwitch(key, on)
	local d = NodeDb()
	if not d then
		return
	end
	d[key] = on and true or nil
	if LueurOn() then
		HideGlow()
		print(PREFIX .. ns:L("FNODE_LUEUR"))
		return
	end
	if NodeNeedsCVars() then
		local changed = NodeApply(on and "switched on" or "one switch off, the other still on")
		if on then
			print(PREFIX .. ns:L("FNODE_ON"):format(changed))
		else
			print(PREFIX .. ns:L("FNODE_PART_OFF"))
		end
	else
		NodeRestoreSaved("switched off")
		print(PREFIX .. ns:L("FNODE_OFF"))
	end
	UpdateGlow()
end

function ns.SetNodeIcon(on)
	NodeSwitch("icon", on)
end

function ns.SetNodeGlow(on)
	NodeSwitch("glow", on)
end

local nodeEv = CreateFrame("Frame")
nodeEv:RegisterEvent("PLAYER_ENTERING_WORLD")
nodeEv:RegisterEvent("PLAYER_REGEN_ENABLED")
pcall(nodeEv.RegisterEvent, nodeEv, "PLAYER_SOFT_INTERACT_CHANGED")
pcall(nodeEv.RegisterEvent, nodeEv, "NAME_PLATE_UNIT_ADDED")
pcall(nodeEv.RegisterEvent, nodeEv, "NAME_PLATE_UNIT_REMOVED")
pcall(nodeEv.RegisterEvent, nodeEv, "CVAR_UPDATE")
nodeEv:SetScript("OnEvent", function(_, event, name, value)
	-- Switched off during a fight: the putting back still has to happen after it, with both switches off.
	if not (ns.IsNodeIconOn() or ns.IsNodeGlowOn()) and not (event == "PLAYER_REGEN_ENABLED" and nodeState.pending) then
		return
	end
	if event == "PLAYER_ENTERING_WORLD" then
		-- Lueur's notes say the client sets SoftTargetIconGameObject back to 0 after this event: set ours a second later.
		C_Timer.After(1, function()
			NodeApply("login/loading screen")
		end)
	elseif event == "PLAYER_REGEN_ENABLED" then
		if nodeState.pending then
			if NodeNeedsCVars() then
				NodeApply("after combat")
			else
				NodeRestoreSaved("after combat")
			end
		end
	elseif event == "CVAR_UPDATE" then
		if type(name) == "string" and NODE_OURS[name] and tonumber(value) ~= tonumber(Wanted(name))
			and NodeNeedsCVars() then
			nodeState.reapplied = nodeState.reapplied + 1
			C_Timer.After(1, function()
				NodeApply(name .. " changed by the game")
			end)
		end
	else
		UpdateGlow()
		if event == "PLAYER_SOFT_INTERACT_CHANGED" then
			-- GEMETEN: the nameplate came a moment after the change event; look once more.
			C_Timer.After(0.15, UpdateGlow)
		end
	end
end)

local function NodeStatus()
	local d = NodeDb() or {}
	print(PREFIX .. ("ore and herbs: game icon %s, MH glow %s, Lueur loaded: %s (then MH stands down)."):format(
		ns.IsNodeIconOn() and "on" or "off", ns.IsNodeGlowOn() and "on" or "off", LueurOn() and "yes" or "no"))
	for _, r in ipairs(NODE_SET) do
		local cur = Get(r[1])
		print(("  %s: now %s, MH sets %s, kept from before %s"):format(r[1], cur == nil and "MISSING" or tostring(cur),
			tostring(Wanted(r[1])), d.saved and d.saved[r[1]] ~= nil and tostring(d.saved[r[1]]) or "-"))
	end
	local fid = GetFileIDFromPath and select(2, pcall(GetFileIDFromPath, GLOW_TEX)) or "?"
	print(("  soft target now: %s, kind %s%s, glow shown: %s, glow texture file id: %s"):format(
		tostring(nodeState.name or "-"), tostring(nodeState.kind or "-"), nodeState.unable and " (game cursor says Unable)" or "",
		nodeState.shown and "yes" or "no", tostring(fid)))
	-- 21 Nov 2026 (Rob: the star on a Peacebloom was WHITE): the colour and where it comes from. Grey = the game's own
	-- cursor for that node says "Unable" (no Herbalism / Mining, or the skill is too low, or out of range); green = herb
	-- you can gather; gold = ore you can mine. MH reads only the cursor; your profession below is a second look.
	print(("  colour now: %s · game cursor: %s"):format(nodeState.shown and tostring(nodeState.colour) or "-",
		tostring(nodeState.cursor or "-")))
	print("  last node: " .. tostring(nodeState.lastNode or "none seen yet this session"))
	if ns.db then
		ns.db.foreverNodeLast = { at = time and time() or 0, line = nodeState.lastNode, cursor = nodeState.cursor }
	end
	local mine = ns.ForeverMyProfessions and ns.ForeverMyProfessions() or {}
	local function P(key)
		local p = mine[key]
		if not p then
			return "not learned"
		end
		return (p.rank and p.maxRank) and ("%d/%d"):format(p.rank, p.maxRank) or "learned"
	end
	print(("  your Herbalism: %s · your Mining: %s"):format(P("HERBALISM"), P("MINING")))
	print(("  preset changes seen %d, waiting for combat end: %s, last: %s"):format(nodeState.reapplied,
		nodeState.pending and "yes" or "no", tostring(nodeState.last)))
end

--- /mh sparkle [on|off|nodes|icon on|off|glow on|off]
function ns.ForeverLootSparkleSlash(arg)
	arg = (arg or ""):lower()
	if arg == "nodes" or arg == "nodes force" then
		NodeProbe(arg == "nodes force")
		return
	end
	local which, onoff = arg:match("^(%a+)%s+(%a+)$")
	if (which == "icon" or which == "glow") and (onoff == "on" or onoff == "off") then
		if which == "icon" then
			ns.SetNodeIcon(onoff == "on")
		else
			ns.SetNodeGlow(onoff == "on")
		end
		return
	end
	if arg == "on" or arg == "off" then
		ns.SetLootSparkle(arg == "on")
		return
	end
	local d = Db() or {}
	print(PREFIX .. ("loot sparkles: %s (/mh sparkle on|off). Watching for a graphics preset (CVAR_UPDATE): %s."):format(
		ns.IsLootSparkleOn() and "on" or "off", state.watch and "yes" or "no"))
	for _, r in ipairs(SET) do
		local name, want = r[1], r[2]
		local cur = Get(name)
		print(("  %s: now %s, MH sets %s, kept from before %s"):format(name, cur == nil and "MISSING" or tostring(cur),
			want, d.saved and d.saved[name] ~= nil and tostring(d.saved[name]) or "-"))
	end
	print(("  applied %d time(s), preset changes seen %d, waiting for combat end: %s"):format(state.applied,
		state.reapplied, state.pending and "yes" or "no"))
	print("  last decision: " .. tostring(state.last))
	NodeStatus()
	print("  /mh sparkle icon on|off, /mh sparkle glow on|off; /mh sparkle nodes = the 30-second measurement.")
end
