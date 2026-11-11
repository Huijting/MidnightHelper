local _, ns = ...

--[[
	ForeverPartyProbe.lua — WoW Forever: MEASURE what the party panel (PartyTargets.lua, retail only) would need, before
	anyone builds it. Rob, 11 Nov 2026: "maak die meting maar" (the "midden" step: party panel with dispel on the member
	and your stop spell on its target).

	It changes nothing in the game and draws nothing. It writes answers to ns.db.partyProbe (SavedVariables, after a
	/reload) and prints a short summary:
	  - which events PartyTargets registers exist here (an unknown event throws on RegisterEvent);
	  - whether Blizzard's AuraContainer (the red "you can remove this" glow) can be built here;
	  - APIs: UnitGroupRolesAssigned, C_UnitAuras, AuraUtil, issecretvalue, focus;
	  - per unit (you, party1-4, their targets, focus, target): exists, and whether name/class/role/cast/aura are
	    readable or secret. Never the names themselves (no other players' names in our file).
	Snapshots: when you type /mh partytest, and automatically 2 seconds into each of the next 5 fights (in a group that
	is exactly the moment that matters: "secret in combat" was the retail lesson).
	/mh partytest = take a snapshot now and print the summary. /mh partytest clear = start over.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MAX_FIGHTS = 5
local ev = CreateFrame("Frame") -- our one event frame (fights), also the RegisterUnitEvent check

-- The events PartyTargets.lua registers (lines ~1918-1959, 632-634), plus the focus event a stop macro would use.
local EVENTS = {
	"PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE", "PLAYER_ROLES_ASSIGNED", "PLAYER_REGEN_ENABLED",
	"PLAYER_SPECIALIZATION_CHANGED", "TRAIT_CONFIG_UPDATED", "RAID_TARGET_UPDATE", "UNIT_TARGET", "UNIT_AURA",
	"UNIT_SPELLCAST_SUCCEEDED", "UNIT_SPELLCAST_FAILED", "UI_ERROR_MESSAGE", "PLAYER_FOCUS_CHANGED",
	"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_INTERRUPTED",
}
local UNITS = { "player", "party1", "party2", "party3", "party4", "party1target", "party2target", "party3target",
	"party4target", "target", "focus" }

local function DB()
	if not ns.db then
		return nil
	end
	ns.db.partyProbe = ns.db.partyProbe or { fights = {} }
	return ns.db.partyProbe
end

--- "nil", "secret", "readable" (or "error: …") — never the value itself.
local function Kind(fn, ...)
	if type(fn) ~= "function" then
		return "no function"
	end
	local ok, v = pcall(fn, ...)
	if not ok then
		return "error: " .. tostring(v)
	end
	if v == nil then
		return "nil"
	end
	if issecretvalue and issecretvalue(v) then
		return "secret"
	end
	return "readable"
end

local function EventCheck()
	local out = {}
	local probe = CreateFrame("Frame")
	for _, e in ipairs(EVENTS) do
		if C_EventUtils and C_EventUtils.IsEventValid then
			local ok, v = pcall(C_EventUtils.IsEventValid, e)
			out[e] = ok and (v and "valid" or "NOT valid") or ("error: " .. tostring(v))
		else
			local ok, err = pcall(probe.RegisterEvent, probe, e)
			out[e] = ok and "registers" or ("throws: " .. tostring(err))
			pcall(probe.UnregisterEvent, probe, e)
		end
	end
	return out
end

local glowResult -- one container per session is enough to know
local secureResult
local GlowCheckOnce

local function GlowCheck()
	if not glowResult then
		glowResult = GlowCheckOnce()
	end
	return glowResult
end

function GlowCheckOnce()
	if not (C_AddOns and C_AddOns.LoadAddOn) then
		return "C_AddOns.LoadAddOn missing"
	end
	local okL, loaded, why = pcall(C_AddOns.LoadAddOn, "Blizzard_AuraContainer")
	if not okL then
		return "LoadAddOn error: " .. tostring(loaded)
	end
	if not loaded then
		return "Blizzard_AuraContainer did not load: " .. tostring(why)
	end
	if not (AuraUtil and AuraUtil.IsValidFilterString) then
		return "AuraUtil.IsValidFilterString missing"
	end
	local okF, valid = pcall(AuraUtil.IsValidFilterString, "HARMFUL|RAID")
	if not okF or valid ~= true then
		return "filter HARMFUL|RAID rejected (" .. tostring(valid) .. ")"
	end
	local okC, c = pcall(CreateFrame, "AuraContainer", nil, UIParent, "CustomAuraContainerTemplate")
	if not okC or not c then
		return "CustomAuraContainerTemplate: " .. tostring(c)
	end
	pcall(c.Hide, c)
	if not (c.SetUnit and c.AddAuraSlot and c.SetEnabled) then
		return "container built, but SetUnit/AddAuraSlot/SetEnabled missing"
	end
	return "OK: container built with SetUnit/AddAuraSlot/SetEnabled"
end

local function FocusCheck()
	local out = {}
	out.FocusFrame = FocusFrame and "exists" or "missing"
	out.focusExists = Kind(UnitExists, "focus")
	if SecureCmdOptionParse then
		local ok, v = pcall(SecureCmdOptionParse, "[@focus,exists] yes; no")
		out.optionParse = ok and tostring(v) or ("error: " .. tostring(v))
	else
		out.optionParse = "SecureCmdOptionParse missing"
	end
	return out
end

local function UnitSnap(u)
	local s = { exists = Kind(UnitExists, u) }
	local okE, ex = pcall(UnitExists, u)
	if not (okE and ex == true) then
		return s
	end
	s.name = Kind(UnitName, u)
	s.class = Kind(UnitClass, u)
	s.role = Kind(UnitGroupRolesAssigned, u)
	if UnitGroupRolesAssigned then
		local okR, r = pcall(UnitGroupRolesAssigned, u)
		if okR and type(r) == "string" and not (issecretvalue and issecretvalue(r)) then
			s.roleValue = r -- NONE/TANK/HEALER/DAMAGER, not personal
		end
	end
	s.canAttack = Kind(UnitCanAttack, "player", u)
	s.canAssist = Kind(UnitCanAssist, "player", u)
	s.casting = Kind(UnitCastingInfo, u)
	s.channel = Kind(UnitChannelInfo, u)
	if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
		local okA, a = pcall(C_UnitAuras.GetAuraDataByIndex, u, 1, "HARMFUL")
		if not okA then
			s.debuff1 = "error: " .. tostring(a)
		elseif a == nil then
			s.debuff1 = "nil"
		elseif issecretvalue and issecretvalue(a) then
			s.debuff1 = "secret (whole table)"
		else
			s.debuff1 = "table; spellId " .. ((issecretvalue and issecretvalue(a.spellId)) and "secret" or "readable")
		end
	else
		s.debuff1 = "C_UnitAuras.GetAuraDataByIndex missing"
	end
	return s
end

local function Snapshot(why)
	local snap = { why = why, at = date and date("%Y-%m-%d %H:%M:%S") or "?",
		inCombat = InCombatLockdown and InCombatLockdown() or false,
		inGroup = IsInGroup and IsInGroup() or false, inRaid = IsInRaid and IsInRaid() or false,
		units = {} }
	if IsInInstance then
		local _, kind = IsInInstance()
		snap.instance = kind
	end
	for _, u in ipairs(UNITS) do
		snap.units[u] = UnitSnap(u)
	end
	return snap
end

local function Measure(why)
	local db = DB()
	if not db then
		return nil
	end
	local _, build = GetBuildInfo()
	db.build = build
	db.measuredAt = date and date("%Y-%m-%d %H:%M:%S") or "?"
	db.events = EventCheck()
	db.glow = GlowCheck()
	db.focus = FocusCheck()
	db.api = {
		issecretvalue = issecretvalue and "exists" or "missing",
		UnitGroupRolesAssigned = UnitGroupRolesAssigned and "exists" or "missing",
		C_UnitAuras = (C_UnitAuras and C_UnitAuras.GetAuraDataByIndex) and "exists" or "missing",
		RegisterUnitEvent = ev and ev.RegisterUnitEvent and "exists" or "missing",
	}
	-- a secure button is never created in combat (that is blocked); once out of combat is enough
	if not secureResult and not (InCombatLockdown and InCombatLockdown()) then
		local okB, b = pcall(CreateFrame, "Button", nil, UIParent, "SecureActionButtonTemplate")
		secureResult = (okB and b) and "builds" or ("fails: " .. tostring(b))
		if okB and b then
			b:Hide()
		end
	end
	db.api.SecureActionButtonTemplate = secureResult or "not tried yet (in combat)"
	db.last = Snapshot(why)
	return db
end

local function Summary(db)
	local bad = {}
	for e, v in pairs(db.events or {}) do
		if not (v == "valid" or v == "registers") then
			bad[#bad + 1] = e
		end
	end
	table.sort(bad)
	print(PREFIX .. ("party measurement saved (Forever %s). /reload writes it to the file."):format(tostring(db.build)))
	print("  events missing here: " .. (#bad > 0 and table.concat(bad, ", ") or "none"))
	print("  red dispel glow (AuraContainer): " .. tostring(db.glow))
	print(("  focus: FocusFrame %s, [@focus,exists] -> %s"):format(db.focus.FocusFrame, tostring(db.focus.optionParse)))
	local s = db.last
	print(("  group: %s, raid: %s, in combat: %s. party1 exists: %s"):format(tostring(s.inGroup), tostring(s.inRaid),
		tostring(s.inCombat), s.units.party1.exists))
	print(("  fights measured so far: %d of %d (2 s into each fight, automatically)"):format(#(db.fights or {}), MAX_FIGHTS))
end

--- /mh partytest [clear]
function ns.ForeverPartyProbeSlash(arg)
	arg = (arg or ""):lower()
	if arg == "clear" then
		if ns.db then
			ns.db.partyProbe = nil
		end
		print(PREFIX .. "party measurement cleared.")
		return
	end
	local db = Measure("by hand")
	if db then
		Summary(db)
	end
end

ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:SetScript("OnEvent", function()
	local db = DB()
	if not db or #(db.fights or {}) >= MAX_FIGHTS or not (IsInGroup and IsInGroup()) then
		return
	end
	C_Timer.After(2, function()
		if InCombatLockdown and InCombatLockdown() then
			db.fights = db.fights or {}
			if #db.fights < MAX_FIGHTS then
				db.fights[#db.fights + 1] = Snapshot("fight")
			end
		end
	end)
end)
