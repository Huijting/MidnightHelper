--[[
	Midnight Helper — Knowledge fixture runner (RFC-002, implementation phase 2).

	Runs the ten definitive fixtures against the pure evaluator, outside the game, with
	plain `lua`. No WoW API is touched, so a failure here is a real defect in the rules or
	the evaluator, never an environment problem.

	    lua tools/run_knowledge_fixtures.lua           # all ten
	    lua tools/run_knowledge_fixtures.lua 05        # one, by id prefix
	    lua tools/run_knowledge_fixtures.lua -v        # print every response

	Exit code is non-zero when any fixture fails, so CI can gate on it.

	Comparison is "expected is a subset of actual": a fixture states what MUST hold, and a
	response may carry extra keys. Two guards stop that from becoming a blind spot — a
	non-empty missing_inputs or stale_object_ids that the fixture does not mention is a
	failure, because those are exactly the fields where silence would be a lie.
]]

local ROOT = (arg and arg[0] or ""):gsub("[^/\\]*$", "")
if ROOT == "" then ROOT = "./" end
ROOT = ROOT .. "../"

local function loadModule(relative)
	local path = ROOT .. relative
	local chunk, err = loadfile(path)
	if not chunk then
		io.stderr:write("cannot load " .. path .. ": " .. tostring(err) .. "\n")
		os.exit(2)
	end
	return chunk("MidnightHelper", {})
end

local KB = loadModule("Modules/KnowledgeData_S1.lua")
-- The evaluator lives beside the request builder in one file, so the code the fixtures
-- prove is the same code that will ship — there is no second copy to drift. It sits in
-- tools/ until phase 3 is finished and it can be registered in the .toc deliberately.
-- BuildRequest is never called here, so no WoW API is touched.
local Evaluator = loadModule("tools/knowledge_runtime.lua")
local Corpus = loadModule("tools/knowledge_fixtures_generated.lua")(KB.NULL)

--------------------------------------------------------------------------------
-- Rendering + comparison
--------------------------------------------------------------------------------

local function render(value, indent)
	indent = indent or ""
	if value == KB.NULL then
		return "null"
	end
	if type(value) ~= "table" then
		if type(value) == "string" then
			return '"' .. value .. '"'
		end
		return tostring(value)
	end
	if #value > 0 then
		local parts = {}
		for i = 1, #value do
			parts[i] = render(value[i], indent)
		end
		return "[" .. table.concat(parts, ", ") .. "]"
	end
	local keys = {}
	for k in pairs(value) do
		keys[#keys + 1] = tostring(k)
	end
	table.sort(keys)
	if #keys == 0 then
		return "{}"
	end
	local parts = {}
	for i = 1, #keys do
		parts[#parts + 1] = indent .. "  " .. keys[i] .. " = " .. render(value[keys[i]], indent .. "  ")
	end
	return "{\n" .. table.concat(parts, "\n") .. "\n" .. indent .. "}"
end

--- Deep compare. Returns true, or false plus a path describing the first difference.
local function deepEqual(expected, actual, path)
	path = path or ""
	if type(expected) ~= type(actual) then
		return false, path
	end
	if type(expected) ~= "table" then
		if expected ~= actual then
			return false, path
		end
		return true
	end
	if #expected > 0 or #actual > 0 then
		if #expected ~= #actual then
			return false, path .. " (length " .. #expected .. " vs " .. #actual .. ")"
		end
		for i = 1, #expected do
			local ok, where = deepEqual(expected[i], actual[i], path .. "[" .. i .. "]")
			if not ok then
				return false, where
			end
		end
		return true
	end
	for k, v in pairs(expected) do
		local ok, where = deepEqual(v, actual[k], path .. "." .. tostring(k))
		if not ok then
			return false, where
		end
	end
	return true
end

local function compareResponse(expected, actual)
	local failures = {}
	local keys = {}
	for k in pairs(expected) do
		keys[#keys + 1] = k
	end
	table.sort(keys)

	for i = 1, #keys do
		local key = keys[i]
		local ok, where = deepEqual(expected[key], actual[key], key)
		if not ok then
			failures[#failures + 1] = {
				field = where,
				expected = expected[key],
				actual = actual[key],
			}
		end
	end

	-- Guard against silent extras in the two fields where silence would be dishonest.
	for _, guarded in ipairs({ "missing_inputs", "stale_object_ids" }) do
		if expected[guarded] == nil and type(actual[guarded]) == "table" and #actual[guarded] > 0 then
			failures[#failures + 1] = {
				field = guarded .. " (unexpected, fixture is silent about it)",
				expected = {},
				actual = actual[guarded],
			}
		end
	end

	return failures
end

--------------------------------------------------------------------------------
-- Run
--------------------------------------------------------------------------------

local filter, verbose
for i = 1, #(arg or {}) do
	if arg[i] == "-v" or arg[i] == "--verbose" then
		verbose = true
	else
		filter = arg[i]
	end
end

print("Midnight Helper — knowledge fixture runner")
print(string.format("  catalog %s  ·  %d objects  ·  corpus %s  ·  %d fixtures",
	KB.catalogVersion, #KB.objects, Corpus.schemaVersion, #Corpus.fixtures))
print("")

local passed, failed, skipped = 0, 0, 0

for i = 1, #Corpus.fixtures do
	local fixture = Corpus.fixtures[i]
	if filter and not string.find(fixture.id, filter, 1, true) then
		skipped = skipped + 1
	else
		local ok, actual = pcall(Evaluator.Evaluate, fixture.request, KB)
		if not ok then
			failed = failed + 1
			print(string.format("  FAIL  %s", fixture.id))
			print("        evaluator error: " .. tostring(actual))
		else
			local failures = compareResponse(fixture.expected_response, actual)
			if #failures == 0 then
				passed = passed + 1
				print(string.format("  ok    %s  ->  %s / %s", fixture.id, actual.status, actual.confidence))
				if verbose then
					print(render(actual, "        "))
				end
			else
				failed = failed + 1
				print(string.format("  FAIL  %s", fixture.id))
				for f = 1, #failures do
					print("        field    : " .. failures[f].field)
					print("        expected : " .. render(failures[f].expected, "                   "))
					print("        actual   : " .. render(failures[f].actual, "                   "))
					if f < #failures then
						print("")
					end
				end
				if verbose then
					print("        full response:")
					print(render(actual, "        "))
				end
			end
		end
	end
end

print("")
local total = passed + failed
print(string.format("  %d/%d fixtures passed%s", passed, total, skipped > 0 and (", " .. skipped .. " skipped") or ""))

if failed > 0 then
	os.exit(1)
end
os.exit(0)
