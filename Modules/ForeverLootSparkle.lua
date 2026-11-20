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
	NOT built: herbs and ore (the SoftTarget* CVars exist, cvp2, but which values the addon sets is not measured).

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
	for _, r in ipairs(SET) do
		local name, want = r[1], r[2]
		local cur = Get(name)
		if cur == nil then
			missing = missing + 1
		else
			if d.saved[name] == nil then
				d.saved[name] = cur
			end
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

--- /mh sparkle [on|off]
function ns.ForeverLootSparkleSlash(arg)
	arg = (arg or ""):lower()
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
end
