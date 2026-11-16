local _, ns = ...

--[[
	CameraZoom.lua — one switch "Camera further away", retail and WoW Forever.

	Rob, 16 Nov 2026 (via sparring, letterlijk: "beide ja"): a button for `/console cameraDistanceMaxZoomFactor 4`.
	Agreed with him: ONE on/off switch. On = retail 2.6, Forever 4. Off = the value you had before (remembered when
	the switch was turned on).

	Measured by mh-research that day (not by this file):
	- Retail 12.1.5: 2.6 is the maximum that works (= 39 yd; wiki + forum March 2026). Blizzard has no slider for it in
	  retail (wow-ui-source live 70783). The old cameraDistanceFixedValue trick is gone since 12.0.5.
	- The CVar is not secure (wiki list up to 12.1.5). Scope: account (only in config-cache.wtf).
	- C_CVar.SetCVar out of combat is fine; IN combat NOT measured → this file never sets it in combat, it waits for
	  PLAYER_REGEN_ENABLED.
	- Forever: Blizzard's own slider Controls -> "Max Camera Distance" runs 1.0 to 2.0 (forever branch,
	  Camelot/ControlsOverrides.lua). That slider or "Defaults" sets the value back. Rob measured that 4 works; whether
	  the client keeps 4 or caps it: NOT measured — `/mh camera` prints what the game reads back, so that shows it.
	- Details! sets 2.6 at its first start (Details/startup.lua:486).

	While the switch is on, MH sets the value again at every login if something (Blizzard's slider, Defaults, another
	addon) changed it. The camera does NOT zoom out by itself after the change: scroll out with the mouse wheel. The
	tooltip says so.

	🔴 Silence rule (CLAUDE.md): `/mh camera` prints the switch, the value the game reads now, MH's target and the
	remembered old value. `/mh camera on|off` sets it and prints what the game reads back.

	State: ns.db.cameraFar = true/nil, ns.db.cameraFarOld = "<value before>" (string, as the client returns it).
]]

local CVAR = "cameraDistanceMaxZoomFactor"

local function Target()
	return ns.IS_FOREVER and "4" or "2.6"
end

local function Read()
	if C_CVar and C_CVar.GetCVar then
		local ok, v = pcall(C_CVar.GetCVar, CVAR)
		if ok then
			return v
		end
	end
	return nil
end

local function Default()
	if C_CVar and C_CVar.GetCVarDefault then
		local ok, v = pcall(C_CVar.GetCVarDefault, CVAR)
		if ok and v ~= nil then
			return v
		end
	end
	return nil
end

local function Write(v)
	if v == nil or not (C_CVar and C_CVar.SetCVar) then
		return false
	end
	return pcall(C_CVar.SetCVar, CVAR, tostring(v))
end

local function Say(key, ...)
	local msg = select("#", ...) > 0 and ns:L(key):format(...) or ns:L(key)
	print(("|cffe8c36a%s|r %s"):format(ns:L("MAIN_TITLE"), msg))
end

-- What to apply once combat ends ("on" or "off"), or nil.
local pending

local waiter = CreateFrame("Frame")

local function Apply(want, loud)
	if InCombatLockdown and InCombatLockdown() then
		pending = want
		waiter:RegisterEvent("PLAYER_REGEN_ENABLED")
		if loud then
			Say("CAMERA_COMBAT")
		end
		return
	end
	pending = nil
	local value
	if want == "on" then
		value = Target()
	else
		value = (ns.db and ns.db.cameraFarOld) or Default()
		if ns.db then
			ns.db.cameraFarOld = nil
		end
	end
	Write(value)
	if loud then
		Say("CAMERA_SET_FMT", tostring(value), tostring(Read()))
	end
end

waiter:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		if pending then
			Apply(pending, true)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		-- On at login, but the value was changed elsewhere: set it again (quietly).
		if ns.db and ns.db.cameraFar and tonumber(Read() or "") ~= tonumber(Target()) then
			Apply("on", false)
		end
	end
end)
waiter:RegisterEvent("PLAYER_ENTERING_WORLD")

function ns.IsCameraFarOn()
	return ns.db and ns.db.cameraFar and true or false
end

function ns.SetCameraFar(on, loud)
	if type(ns.db) ~= "table" then
		return
	end
	on = on and true or false
	if on == ns.IsCameraFarOn() then
		if loud then
			ns.PrintCameraStatus()
		end
		return
	end
	if on then
		-- Remember what the player had, unless that already IS our value (then the default is the honest "before").
		local cur = Read()
		if cur ~= nil and tonumber(cur) ~= tonumber(Target()) then
			ns.db.cameraFarOld = cur
		end
		ns.db.cameraFar = true
		Apply("on", loud)
	else
		ns.db.cameraFar = nil
		Apply("off", loud)
	end
end

function ns.PrintCameraStatus()
	Say("CAMERA_STATUS_FMT",
		ns:L(ns.IsCameraFarOn() and "CAMERA_WORD_ON" or "CAMERA_WORD_OFF"),
		tostring(Read()), Target(),
		tostring((ns.db and ns.db.cameraFarOld) or Default()))
end

--- `/mh camera` (Core.lua): "" = status, "on" / "off" = switch and print what the game reads back.
function ns.HandleCameraCommand(arg)
	arg = (arg or ""):lower()
	if arg == "on" then
		ns.SetCameraFar(true, true)
	elseif arg == "off" then
		ns.SetCameraFar(false, true)
	else
		ns.PrintCameraStatus()
	end
end
