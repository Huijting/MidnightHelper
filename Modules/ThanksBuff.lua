local _, ns = ...

--[[
	ThanksBuff.lua — retail and WoW Forever: a stranger buffs you, MH thanks them with the game's own emote.

	Rob, 19 Nov 2026, via sparring, letterlijk: "3 wil ik wel hebben, maar daar hebben we het dan wel over" → "Ik wil dan
	iets hebben als mijn naam bedankt je voor de buff naam, enjoy the game" → after the explanation (an own sentence only
	as an automatic whisper, or as an emote with a click) his final choice: "Nee dan de manier met de vaste dingen die de
	andere addon ook heeft, niet in de whisper". So: the game's THANK emote ("<you> thanks <them>."), never a whisper,
	never an own text. Off by default.

	The idea comes from the addon Thanks for the Buff (TFTB). It ships no licence file and its README names none
	(GEMETEN 19 Nov 2026 in Rob's Forever AddOns folder), so NOTHING of its code is copied here; this file is our own.
	What we took is the approach, which is the game's API: UNIT_AURA addedAuras on the player, the giver from the aura's
	sourceUnit or C_UnitAuras.GetAuraCasterGUID, and C_ChatInfo.PerformEmote(token, target). Two traps TFTB documents
	and we respect: PerformEmote with a nil target thanks your CURRENT target, so no target = no emote; and Forever
	forbids registering the combat log, so this never does (neither does retail MH: CLEU taint).

	Never: in combat, inside an instance/battleground/arena, while auras read as secret (12.x), for your own buffs or a
	pet's, for a group member or someone on your ignore list, twice for the same player within 5 minutes, or in the first
	10 seconds after a loading screen (the buffs you carry through a portal are "added" again). Thanks for the Buff
	loaded: MH stays silent (it would thank twice) and /mh thanks says so.

	NOT measured yet (the reason /mh thanks prints every decision): whether a stranger's buff carries a readable
	sourceUnit or caster GUID on this client, and whether PerformEmote reaches the player by unit token or by name.
	/mh thanks test performs the emote at your current target, so the second one can be seen.
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "
local COOLDOWN = 300 -- seconds per player (Rob, 20 nov 2026: "zet die uur maar naar 5 minuten")
local PAUSE = 10 -- seconds after a loading screen
local EMOTE = "THANK"

local state = { last = "nothing seen yet this session", sent = 0, seen = 0, pauseUntil = 0 }
local thanked = {} -- [guid] = GetTime() of the last thanks

local function Plain(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

function ns.IsThanksBuffOn()
	return ns.db and ns.db.thanksBuff == true or false
end

function ns.SetThanksBuff(on)
	if not ns.db then
		return
	end
	-- plain branches, not `and true or nil` (lint [29])
	if on then
		ns.db.thanksBuff = true
	else
		ns.db.thanksBuff = nil
	end
end

local function AddOnLoaded(name)
	local fn = (C_AddOns and C_AddOns.IsAddOnLoaded) or _G.IsAddOnLoaded
	if not fn then
		return false
	end
	local ok, v = pcall(fn, name)
	return ok and v and true or false
end

local function TFTBLoaded()
	return AddOnLoaded("TFTB")
end

local function IsPlayerGUID(guid)
	return type(guid) == "string" and guid:find("^Player%-") ~= nil
end

local function InGroupGUID(guid)
	if not (IsInGroup and IsInGroup()) then
		return false
	end
	local prefix, n = "party", 4
	if IsInRaid and IsInRaid() then
		prefix, n = "raid", 40
	end
	for i = 1, n do
		local g = UnitGUID(prefix .. i)
		if Plain(g) and g == guid then
			return true
		end
	end
	return false
end

--- A unit token we hold for this GUID right now (target, mouseover, focus, a nameplate), or nil.
local function UnitFor(guid)
	local list = { "target", "mouseover", "focus" }
	for i = 1, 40 do
		list[#list + 1] = "nameplate" .. i
	end
	for _, u in ipairs(list) do
		local g = UnitGUID(u)
		if Plain(g) and g == guid then
			return u
		end
	end
	return nil
end

--- Who gave this aura: guid, unit (may be nil), short name, or nil plus why.
local function Giver(aura)
	local unit = aura.sourceUnit
	local guid
	if unit ~= nil then
		if not Plain(unit) then
			return nil, nil, nil, "the giver (sourceUnit) is secret"
		end
		guid = UnitGUID(unit)
	elseif aura.auraInstanceID ~= nil and C_UnitAuras and C_UnitAuras.GetAuraCasterGUID then
		if not Plain(aura.auraInstanceID) then
			return nil, nil, nil, "the aura id is secret"
		end
		local ok, g = pcall(C_UnitAuras.GetAuraCasterGUID, "player", aura.auraInstanceID)
		guid = ok and g or nil
	end
	if not Plain(guid) or not guid then
		return nil, nil, nil, "no readable giver (no sourceUnit, no caster GUID)"
	end
	if not IsPlayerGUID(guid) then
		return nil, nil, nil, "the giver is not a player (a pet, an NPC, an object)"
	end
	unit = unit or UnitFor(guid)
	local name
	if unit then
		name = UnitName(unit)
	elseif UnitNameFromGUID then
		local ok, n = pcall(UnitNameFromGUID, guid)
		name = ok and n or nil
	end
	if not Plain(name) or not name or name == "" then
		return nil, nil, nil, "the giver's name cannot be read"
	end
	return guid, unit, name
end

local function Emote(target)
	if C_ChatInfo and C_ChatInfo.PerformEmote then
		return pcall(C_ChatInfo.PerformEmote, EMOTE, target)
	elseif DoEmote then
		return pcall(DoEmote, EMOTE, target)
	end
	return false, "this client has no PerformEmote or DoEmote"
end

--- The decision for one added aura: true plus who, or false plus why.
local function Decide(aura)
	if not ns.IsThanksBuffOn() then
		return false, "switched off"
	end
	if TFTBLoaded() then
		return false, "Thanks for the Buff is loaded and thanks people itself"
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, "in combat"
	end
	local inInst = IsInInstance and IsInInstance()
	if inInst then
		return false, "inside an instance, battleground or arena"
	end
	if GetTime() < state.pauseUntil then
		return false, "just after a loading screen"
	end
	if not Plain(aura.isHelpful) then
		return false, "the aura reads as secret"
	end
	if not aura.isHelpful then
		return false, "not a buff"
	end
	local guid, unit, name, why = Giver(aura)
	if not guid then
		return false, why
	end
	if guid == UnitGUID("player") then
		return false, "your own buff"
	end
	if InGroupGUID(guid) or (unit and ((UnitInParty and UnitInParty(unit)) or (UnitInRaid and UnitInRaid(unit)))) then
		return false, name .. " is in your group"
	end
	if unit and UnitIsFriend and not UnitIsFriend("player", unit) then
		return false, name .. " is not friendly"
	end
	local ignored = C_FriendList and C_FriendList.IsIgnored and C_FriendList.IsIgnored(name)
	if ignored then
		return false, name .. " is on your ignore list"
	end
	local t = thanked[guid]
	if t and GetTime() - t < COOLDOWN then
		return false, ("already thanked %s %d min ago"):format(name, math.floor((GetTime() - t) / 60))
	end
	return true, name, unit, guid
end

local function OnAura(updateInfo)
	if type(updateInfo) ~= "table" then
		return
	end
	-- A full update is a re-read of everything (login, reload), not a new buff. nil = not a full update.
	local full = updateInfo.isFullUpdate
	if full ~= nil and (not Plain(full) or full) then
		return
	end
	local added = updateInfo.addedAuras
	if not Plain(added) or type(added) ~= "table" then
		return
	end
	for _, aura in ipairs(added) do
		local spell = Plain(aura.spellId) and aura.spellId or "?"
		local ok, yes, who, unit, guid = pcall(Decide, aura)
		state.seen = state.seen + 1
		if not ok then
			state.last = "error: " .. tostring(yes)
		elseif yes then
			-- A unit token when we hold one, else the bare name (the client finds the visible player). Never nil: that
			-- would thank your current target instead.
			local okE, err = Emote(unit or who)
			thanked[guid] = GetTime()
			state.sent = state.sent + 1
			state.last = ("buff %s from %s: thanked by %s%s"):format(tostring(spell), who, unit and ("unit " .. unit) or "name",
				okE and "" or (" — FAILED: " .. tostring(err)))
		elseif who ~= "switched off" then
			state.last = ("buff %s: not thanked — %s"):format(tostring(spell), tostring(who))
		end
	end
end

local ev = CreateFrame("Frame")
ev:RegisterUnitEvent("UNIT_AURA", "player")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
pcall(ev.RegisterEvent, ev, "LOADING_SCREEN_DISABLED")
ev:SetScript("OnEvent", function(_, event, unit, updateInfo)
	if event == "UNIT_AURA" then
		if ns.IsThanksBuffOn() then
			OnAura(updateInfo)
		end
	else
		state.pauseUntil = GetTime() + PAUSE
	end
end)

--- /mh thanks [on|off|test]
function ns.ThanksBuffSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		ns.SetThanksBuff(arg == "on")
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_thanksBuff", arg == "on")
		end
		print(PREFIX .. ns:L(arg == "on" and "THANKS_ON" or "THANKS_OFF"))
		return
	end
	if arg == "test" then
		-- The measurement: the same emote, at your current target (a friendly player you pick yourself).
		if not (UnitExists("target") and UnitIsPlayer("target")) then
			print(PREFIX .. ns:L("THANKS_TEST_NOTARGET"))
			return
		end
		local ok, err = Emote("target")
		print(PREFIX .. ("test: emote %s at your target: %s"):format(EMOTE, ok and "sent (look in chat)" or ("FAILED: "
			.. tostring(err))))
		return
	end
	print(PREFIX .. ("thanks for a buff: %s (/mh thanks on|off|test). Thanks for the Buff loaded: %s."):format(
		ns.IsThanksBuffOn() and "on" or "off", TFTBLoaded() and "yes (MH stays silent)" or "no"))
	print(("  API: PerformEmote %s, DoEmote %s, GetAuraCasterGUID %s. Seen %d new aura(s), thanked %d player(s)."):format(
		(C_ChatInfo and C_ChatInfo.PerformEmote) and "yes" or "no", DoEmote and "yes" or "no",
		(C_UnitAuras and C_UnitAuras.GetAuraCasterGUID) and "yes" or "no", state.seen, state.sent))
	print("  last decision: " .. state.last)
end
