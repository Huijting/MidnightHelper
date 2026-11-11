local _, ns = ...

--[[
	Selftest.lua — /mh selftest: does every game number in MH exist in THIS game? (opdracht 7; Rob, 11 Nov 2026:
	"Ja, bouw het".)

	The numbers come from Modules/SelftestData.lua, written by `run data_check --emit` with the same scanner as the C2
	check (one list, not two). Per kind the client is asked with the call that answers "exists" without waiting for
	data to load:
	  spell        C_Spell.DoesSpellExist(id)
	  item         C_Item.DoesItemExistByID(id)
	  map          C_Map.GetMapInfo(id) ~= nil
	  quest        NOT asked: no call says "this quest does not exist" (a title can be nil while it loads). Counted only.
	  achievement  NOT asked: GetAchievementInfo is not in Blizzard's API documentation. Counted only.
	A call that is missing or errors = "could not ask", never "does not exist" (nil = unreadable, not absent).
	Numbers from files for the OTHER game are skipped. A number from a shared file that this game lacks is listed apart
	("shared, not in this game"): fine when the other game has it.

	🔴 PROOF THAT IT CAN FAIL, in the same run: Auto Attack (6603), Azeroth (947) and the Hearthstone (6948) must exist,
	99999999 must not, for every kind asked. If that control fails, the report says the test proved nothing.
	It says a number EXISTS, not that it does the right thing. Not in a fight. Result: ns.db.selftest (last run only).
]]

local PREFIX = "|cffffcc00Midnight Helper:|r "
local KNOWN = { spell = 6603, map = 947, item = 6948 }
local IMPOSSIBLE = 99999999
local CHUNK = 400 -- numbers per frame, so a long list never stalls the screen

local function Ask(kind, id)
	local ok, res
	if kind == "spell" then
		if not (C_Spell and C_Spell.DoesSpellExist) then
			return nil
		end
		ok, res = pcall(C_Spell.DoesSpellExist, id)
	elseif kind == "item" then
		if not (C_Item and C_Item.DoesItemExistByID) then
			return nil
		end
		ok, res = pcall(C_Item.DoesItemExistByID, id)
	elseif kind == "map" then
		if not (C_Map and C_Map.GetMapInfo) then
			return nil
		end
		ok, res = pcall(C_Map.GetMapInfo, id)
		if ok then
			res = res ~= nil
		end
	else
		return nil
	end
	if not ok or type(res) ~= "boolean" or (issecretvalue and issecretvalue(res)) then
		return nil
	end
	return res
end
ns.SelftestAsk = Ask -- the offline check calls it

local ASKED = { spell = true, item = true, map = true }

--- The work list for this game: { kind, id, shared } for every number of the kinds we can ask.
local function WorkList()
	local data = ns.SELFTEST_IDS or {}
	local mine = ns.IS_FOREVER and "F" or "R"
	local out, counted = {}, {}
	for kind, scopes in pairs(data) do
		counted[kind] = 0
		for scope, list in pairs(scopes) do
			if scope == mine or scope == "B" then
				for id in tostring(list):gmatch("%d+") do
					counted[kind] = counted[kind] + 1
					if ASKED[kind] then
						out[#out + 1] = { kind = kind, id = tonumber(id), shared = (scope == "B") }
					end
				end
			end
		end
	end
	table.sort(out, function(a, b)
		return a.kind == b.kind and a.id < b.id or a.kind < b.kind
	end)
	return out, counted
end

local function Control()
	local res = { ok = true, lines = {} }
	for kind, id in pairs(KNOWN) do
		local yes, no = Ask(kind, id), Ask(kind, IMPOSSIBLE)
		local good = (yes == true) and (no == false)
		res.lines[#res.lines + 1] = ("%s: %d exists=%s, %d exists=%s %s"):format(kind, id, tostring(yes), IMPOSSIBLE,
			tostring(no), good and "OK" or "FAILED")
		res.ok = res.ok and good
	end
	return res
end

local running = false

local function Finish(report)
	running = false
	local now = type(debugprofilestop) == "function" and debugprofilestop() or nil
	report.seconds = (type(now) == "number" and type(report.t0) == "number")
		and math.floor((now - report.t0) / 100) / 10 or nil
	report.t0 = nil
	if ns.db then
		ns.db.selftest = report
	end
	local n = 0
	for _, list in pairs(report.missing) do
		n = n + #list
	end
	local line
	if not report.control.ok then
		line = ns:L("SELFTEST_CONTROL_FAILED")
	elseif n == 0 then
		line = ns:L("SELFTEST_ALL_FMT"):format(report.checked)
	else
		local parts = {}
		for kind, list in pairs(report.missing) do
			if #list > 0 then
				parts[#parts + 1] = kind .. " " .. table.concat(list, ", ", 1, math.min(#list, 5))
					.. (#list > 5 and " …" or "")
			end
		end
		table.sort(parts)
		line = ns:L("SELFTEST_MISSING_FMT"):format(n, report.checked, table.concat(parts, "; "))
	end
	print(PREFIX .. line)
	local shared = 0
	for _, list in pairs(report.sharedMissing) do
		shared = shared + #list
	end
	if shared > 0 or report.unreadable > 0 then
		print("  " .. ns:L("SELFTEST_EXTRA_FMT"):format(shared, report.unreadable))
	end
	print("  |cff9d9d9d" .. ns:L("SELFTEST_LIMIT") .. "|r")
end

--- /mh selftest
function ns.RunSelftest()
	if running then
		print(PREFIX .. ns:L("SELFTEST_BUSY"))
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		print(PREFIX .. ns:L("SELFTEST_COMBAT"))
		return
	end
	if not ns.SELFTEST_IDS then
		print(PREFIX .. "selftest: Modules/SelftestData.lua is not loaded (run data_check --emit).")
		return
	end
	running = true
	local work, counted = WorkList()
	local build = GetBuildInfo and select(2, GetBuildInfo()) or "?"
	local report = {
		at = time and time() or nil, game = ns.IS_FOREVER and "forever" or "retail", build = build,
		listed = counted, checked = 0, unreadable = 0, missing = {}, sharedMissing = {}, unreadableIds = {},
		notAsked = "quest and achievement: no call says 'does not exist' (counted in listed only)",
		control = Control(), t0 = type(debugprofilestop) == "function" and debugprofilestop() or nil,
	}
	for kind in pairs(ASKED) do
		report.missing[kind], report.sharedMissing[kind] = {}, {}
	end
	print(PREFIX .. ns:L("SELFTEST_START_FMT"):format(#work))
	local i = 1
	local Step
	-- An error halfway must not leave `running` stuck on true (then /mh selftest would say "busy" until a /reload).
	local function SafeStep()
		local ok, err = pcall(Step)
		if not ok then
			running = false
			print(PREFIX .. "selftest stopped with an error: " .. tostring(err))
		end
	end
	function Step()
		local stop = math.min(i + CHUNK - 1, #work)
		for j = i, stop do
			local w = work[j]
			local exists = Ask(w.kind, w.id)
			report.checked = report.checked + 1
			if exists == nil then
				report.unreadable = report.unreadable + 1
				if #report.unreadableIds < 50 then
					report.unreadableIds[#report.unreadableIds + 1] = w.kind .. " " .. w.id
				end
			elseif not exists then
				local t = w.shared and report.sharedMissing[w.kind] or report.missing[w.kind]
				t[#t + 1] = w.id
			end
		end
		i = stop + 1
		if i <= #work and C_Timer and C_Timer.After then
			C_Timer.After(0, SafeStep)
		elseif i <= #work then
			Step()
		else
			Finish(report)
		end
	end
	SafeStep()
end
