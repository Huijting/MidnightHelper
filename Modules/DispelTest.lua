--[[
	`/mh dispeltest` — Spec 30. Zie the dispel helper work without hunting for a mob.

	Rob, 21 aug: *"kan je niet een test optie inbouwen om te zien hoe die moet werken ipv
	elke keer een mob zoeken?"* — and on 26 aug that question cost four `/reload`s on a
	different feature, because the only way to see the party glow was to wait for a boss to
	do something.

	🔴 WHY A TEST IS WORTH MORE HERE THAN IN A NORMAL ADDON. Hunting a mob tests two
	things at once — the DECISION (does MH recognise this debuff as yours to remove?) and
	the DISPLAY (does the frame appear, does the sound play?) — and when nothing happens it
	does not say which one was silent. For this module silence is very often the CORRECT
	answer, so silence proves nothing either way. That is `silence-is-not-absence` turned
	into a testing problem.

	⚠️ NO TEST BRANCHES IN THE REAL PATH. This file calls the same two entry points the
	game calls: `ns.GetDispelAlertFor` for the decision and `ns.FireAccessibleAlert` for
	the display, cooldown included. If a future build makes the alert wrong, this test goes
	wrong with it — which is the only kind of test worth having.
]]

local _, ns = ...

local SCHOOL_TO_DISPELNAME = {
	magic = "Magic",
	curse = "Curse",
	poison = "Poison",
	disease = "Disease",
}

local function prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
end

local function green(s) return "|cff40c040" .. s .. "|r" end
local function red(s) return "|cffff5555" .. s .. "|r" end
local function grey(s) return "|cff8a8f98" .. s .. "|r" end

--- A school this character CAN remove, and one it cannot.
---
--- ⚠️ Picked from the live spec, never hardcoded. "Curse is the one you cannot dispel"
--- is true for a priest and false for a mage; a fixed pair would report a failure on
--- half of Rob's characters and it would be the test that was wrong.
local function pickSchools()
	local can, cannot
	local schools = ns.GetDispellableSchools and ns.GetDispellableSchools() or {}
	for key in pairs(SCHOOL_TO_DISPELNAME) do
		if schools[key] then
			can = can or key
		else
			cannot = cannot or key
		end
	end
	return can, cannot
end

--------------------------------------------------------------------------------
-- decide — the pure decision, no UI touched
--------------------------------------------------------------------------------

local function RunDecide()
	print(prefix() .. " dispeltest decide:")

	local can, cannot = pickSchools()
	if not can then
		print("   " .. grey("This character has no friendly dispel at all, so every case below "
			.. "should say nothing. That is a pass, not a failure."))
	end

	local cases = {}

	if can then
		cases[#cases + 1] = {
			label = ("%s debuff, you CAN remove %s"):format(can, can),
			aura = { spellId = 999001, name = "Testitis", dispelName = SCHOOL_TO_DISPELNAME[can] },
			wantMessage = true,
		}
	end
	if cannot then
		cases[#cases + 1] = {
			label = ("%s debuff, you canNOT remove %s"):format(cannot, cannot),
			aura = { spellId = 999002, name = "Testitis", dispelName = SCHOOL_TO_DISPELNAME[cannot] },
			wantMessage = false,
		}
	end
	if can then
		-- The name is what the alert prefers to show; without it the school still is.
		cases[#cases + 1] = {
			label = "name missing, school still yours",
			aura = { spellId = 999003, name = nil, dispelName = SCHOOL_TO_DISPELNAME[can] },
			wantMessage = true,
		}
	end
	cases[#cases + 1] = {
		label = "no dispelName at all (nothing can remove it)",
		aura = { spellId = 999004, name = "Testitis", dispelName = nil },
		wantMessage = false,
	}
	cases[#cases + 1] = {
		label = "not an aura table",
		aura = "nonsense",
		wantMessage = false,
	}

	local pass, fail = 0, 0
	for _, c in ipairs(cases) do
		local msg, reason = ns.GetDispelAlertFor(c.aura)
		local got = msg ~= nil
		local ok = (got == c.wantMessage)
		if ok then pass = pass + 1 else fail = fail + 1 end
		print(("   %s %s"):format(ok and green("PASS") or red("FAIL"), c.label))
		print(("       -> %s"):format(msg and ('"' .. msg .. '"') or "nothing"))
		print(("       because: %s"):format(reason or "(no reason given)"))
	end

	-- The one case that cannot be staged, said out loud rather than faked.
	print("   " .. grey("--"))
	if not ns.DispelAlertEnabled or not ns.DispelAlertEnabled() then
		print("   " .. red("NOTE: the dispel alert is switched OFF")
			.. grey(" — every case above short-circuits on that, so this run proves little. "
				.. "Switch it on and run again."))
	end
	print("   " .. grey("SECRET dispelName: not staged. A secret value comes from the engine and "
		.. "cannot be built in Lua, so faking one would test a fake."))
	print(("   %s issecretvalue present: %s   %s"):format(
		grey("   guard check:"),
		issecretvalue and green("yes") or red("NO — the guard cannot work"),
		grey("live check: /mh dispel")))

	print(("   %d passed, %d failed"):format(pass, fail))
	return fail == 0
end

--------------------------------------------------------------------------------
-- show — the real display path, real cooldown
--------------------------------------------------------------------------------

local function BuildRealMessage()
	local can = pickSchools()
	if not can then
		return nil, "this character has no friendly dispel, so the alert would correctly stay silent"
	end
	local aura = { spellId = 999001, name = "Testitis", dispelName = SCHOOL_TO_DISPELNAME[can] }
	local msg, reason = ns.GetDispelAlertFor(aura)
	return msg, reason
end

local function RunShow()
	print(prefix() .. " dispeltest show:")
	local msg, reason = BuildRealMessage()
	if not msg then
		print("   " .. grey("no alert: " .. tostring(reason)))
		print("   " .. grey("To see the frame itself regardless, the beginner-mode test button "
			.. "calls ns.ShowAccessibleAlertTest()."))
		return false
	end
	if not ns.FireAccessibleAlert then
		print("   " .. red("ns.FireAccessibleAlert missing — AccessibleAlerts did not load."))
		return false
	end
	local a = ns.db and ns.db.alerts
	local fired, wait = ns.FireAccessibleAlert(msg, a and a.sound)
	if fired then
		print(("   %s %s"):format(green("shown:"), msg))
	else
		-- Not a failure. This IS the cooldown doing its job, and seeing it is the point.
		print(("   %s %.1fs left on the shared %s"):format(
			grey("held back by the cooldown —"), wait or 0, grey("gap between alerts")))
	end
	return true
end

--------------------------------------------------------------------------------
-- combat — the case that actually differs
--------------------------------------------------------------------------------

--- 🔴 OUT OF COMBAT IS THE CASE THAT DOES NOT BREAK. A frame that parents a secure
--- button becomes protected and cannot be shown or moved in combat (CLAUDE.md, Secure
--- frames). Testing while standing still therefore tests the easy half. This fires the
--- alert on a delay so you can be hitting a dummy when it lands.
local function RunCombat(delay)
	delay = tonumber(delay) or 5
	if not (C_Timer and C_Timer.After) then
		print(prefix() .. " " .. red("C_Timer missing — cannot schedule."))
		return false
	end
	print(prefix() .. (" dispeltest combat: firing in %ds — go hit something."):format(delay))
	C_Timer.After(delay, function()
		local inCombat = InCombatLockdown and InCombatLockdown() or false
		local msg = BuildRealMessage()
		if not msg then
			print(prefix() .. " " .. grey("delayed alert: nothing to say (no dispel on this character)"))
			return
		end
		local fired, wait = ns.FireAccessibleAlert(msg, ns.db and ns.db.alerts and ns.db.alerts.sound)
		-- Report even when nothing appeared: an alert you did not see and an alert that
		-- never fired look identical, which is the whole reason this command exists.
		print(("%s delayed alert — in combat = %s, fired = %s%s"):format(
			prefix(), tostring(inCombat), tostring(fired),
			(not fired) and (" (%.1fs of cooldown left)"):format(wait or 0) or ""))
	end)
	return true
end

--------------------------------------------------------------------------------

function ns.RunDispelTest(arg)
	arg = arg and arg:match("^%s*(%S*)") or ""
	if arg == "decide" then
		return RunDecide()
	elseif arg == "show" then
		return RunShow()
	elseif arg == "combat" then
		return RunCombat()
	elseif arg == "" then
		local ok = RunDecide()
		RunShow()
		print(("%s dispeltest: decisions %s. `/mh dispeltest combat` covers the in-combat case."):format(
			prefix(), ok and green("all passed") or red("SOMETHING FAILED")))
		return ok
	end
	print(prefix() .. " usage: /mh dispeltest [decide|show|combat]")
	return false
end
