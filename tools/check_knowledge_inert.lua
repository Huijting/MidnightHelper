--[[
	Midnight Helper — load-safety check for the Knowledge runtime (RFC-002 phase 3).

	    lua tools/check_knowledge_inert.lua

	These files ARE in the .toc now, so this is no longer a pre-flight question but a
	standing guard: the client runs their whole chunk at every login, in Rob's live
	session. "It only does something when you call it" is a claim that has to be proved on
	every change, not asserted once. A file that starts creating a frame or registering an
	event at load would alter his session silently — this is what notices.

	How: _G gets a metatable that records every global READ and every global WRITE while
	each file loads. Afterwards the recorded sets are compared against what each file is
	allowed to touch. Anything unexpected fails the check with a non-zero exit.

	This does not replace Rob's /reload — nothing does. It replaces the sentence "I am
	fairly sure this is inert".
]]

local ROOT = (arg and arg[0] or ""):gsub("[^/\\]*$", "")
if ROOT == "" then ROOT = "./" end
ROOT = ROOT .. "../"

--------------------------------------------------------------------------------
-- Global access recorder
--------------------------------------------------------------------------------

local reads, writes = {}, {}
local recording = false

setmetatable(_G, {
	__index = function(_, key)
		if recording then
			reads[key] = (reads[key] or 0) + 1
		end
		return nil
	end,
	__newindex = function(t, key, value)
		if recording then
			writes[key] = true
		end
		rawset(t, key, value)
	end,
})

local function record(fn)
	reads, writes = {}, {}
	recording = true
	local ok, err = pcall(fn)
	recording = false
	return ok, err
end

local function sorted(set)
	local out = {}
	for k in pairs(set) do
		out[#out + 1] = tostring(k)
	end
	table.sort(out)
	return out
end

--------------------------------------------------------------------------------
-- What each file may touch while loading
--------------------------------------------------------------------------------

-- Reading a global at load is harmless in itself (`type`, `setmetatable`, a nil check
-- on an API table). Writing one is not: that is how a file changes the session. So the
-- write set is exact, and the read set only has to stay clear of the calls that DO
-- something — frames, events, hooks, timers.
local FORBIDDEN_AT_LOAD = {
	"CreateFrame", "RegisterEvent", "RegisterUnitEvent", "hooksecurefunc",
	"C_Timer", "SetCVar", "RegisterStateDriver", "PlaySound", "UIParent",
	"RegisterAddonMessagePrefix", "C_ChatInfo",
}

local FILES = {
	{
		path = "Modules/KnowledgeData_S1.lua",
		writes = {},
		note = "generated data table",
	},
	{
		path = "Modules/KnowledgeRuntime.lua",
		writes = {},
		note = "pure evaluator + request builder",
	},
	{
		path = "Modules/Knowledge.lua",
		-- The only deliberate load-time side effect in the whole feature, and it matches
		-- what CombatSafety, FirstRun and KeybindAutoMap already do.
		writes = { SLASH_MHKNOW1 = true },
		note = "registry, approval gate, /mhknow",
	},
}

--------------------------------------------------------------------------------
-- Run
--------------------------------------------------------------------------------

print("Midnight Helper — Knowledge load-safety check")
print("")

local ns = {}
local failures = 0

-- A SlashCmdList must exist for the registry to register into, exactly as in-game.
rawset(_G, "SlashCmdList", {})

for _, spec in ipairs(FILES) do
	local chunk, loadErr = loadfile(ROOT .. spec.path)
	if not chunk then
		print(("  FAIL  %s  cannot load: %s"):format(spec.path, tostring(loadErr)))
		failures = failures + 1
	else
		local ok, err = record(function() chunk("MidnightHelper", ns) end)
		if not ok then
			print(("  FAIL  %s  errored while loading: %s"):format(spec.path, tostring(err)))
			failures = failures + 1
		else
			local problems = {}

			for _, name in ipairs(FORBIDDEN_AT_LOAD) do
				if reads[name] then
					problems[#problems + 1] = "touches " .. name .. " at load"
				end
			end

			for key in pairs(writes) do
				if not spec.writes[key] then
					problems[#problems + 1] = "writes global " .. tostring(key)
				end
			end
			for key in pairs(spec.writes) do
				if not writes[key] then
					problems[#problems + 1] = "expected to write " .. tostring(key) .. " but did not"
				end
			end

			if #problems == 0 then
				local w = sorted(writes)
				print(("  ok    %-34s %s"):format(spec.path,
					#w == 0 and "no globals written" or ("writes: " .. table.concat(w, ", "))))
				print(("        %s"):format(spec.note))
			else
				failures = failures + 1
				print(("  FAIL  %s"):format(spec.path))
				for i = 1, #problems do
					print("        " .. problems[i])
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- The slash command must survive being called, too
--------------------------------------------------------------------------------

print("")
local handler = rawget(_G, "SlashCmdList") and rawget(_G, "SlashCmdList")["MHKNOW"]
if type(handler) ~= "function" then
	print("  FAIL  /mhknow did not register")
	failures = failures + 1
else
	-- Call every sub-command against a bare ns: no db, no ritual helpers, no client. That
	-- is the worst case an early login can produce, and each one must print rather than
	-- error. Every branch gets exercised, because a guard that only covers the default
	-- argument is blind to exactly the code most likely to be new.
	for _, sub in ipairs({ "", "save", "probe", "probe save" }) do
		local printed = 0
		local realPrint = print
		_G.print = function() printed = printed + 1 end
		local ok, err = pcall(handler, sub)
		_G.print = realPrint
		local label = sub == "" and "/mhknow" or ("/mhknow " .. sub)
		if ok then
			print(("  ok    %-18s survives a bare namespace (%d lines, no error)"):format(label, printed))
		else
			print(("  FAIL  %s errored on a bare namespace: %s"):format(label, tostring(err)))
			failures = failures + 1
		end
	end
end

print("")
if failures > 0 then
	print(("  %d problem(s) — these files load at login; fix before /reload"):format(failures))
	os.exit(1)
end
print("  inert at load — registering these in the .toc stays safe")
os.exit(0)
