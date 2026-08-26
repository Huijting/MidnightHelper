--[[
	Load the locale files in .toc order with a real Lua interpreter, ONCE PER CLIENT
	LANGUAGE, and print what ns:L would actually resolve for a given key.

	⚠️ THE PACKS ARE LOCALE-GATED. Locales/deDE.lua and friends return immediately
	unless GetLocale() matches, so a single run can only ever see enUS + nlNL. Every
	pack therefore gets its own fresh load with GetLocale() stubbed to that language —
	which is exactly what a player's client does.

	This is not a static check, and that is the point. The repo has been burned by
	reasoning about the fill files instead of running them: on 30 jul, 346 of 438 fills
	per language turned out to have been doing nothing for months while every audit
	counted them as done.

	Usage:  lua5.1 scratchpad/locale_probe.lua KEY [KEY ...]
]]

--- ⚠️ READ FROM THE .toc, not from a list kept here by hand.
---
--- This used to be a hardcoded table while the comment above it claimed ".toc order".
--- On 25 aug 2026 Locales/DelveStories.lua was added to the .toc and the probe
--- reported all 48 of its keys as MISSING FROM enUS -- a file it had simply never
--- been told to load. The verdict looked exactly like a real breakage, and the only
--- reason it was not believed is that nlNL resolved fine in the same run.
---
--- A checking tool that silently checks less than it claims is worse than no tool,
--- so it now derives the list from the same file the game reads.
local ORDER = {}
do
	local toc = io.open("MidnightHelper.toc", "r")
	if not toc then
		io.write("  PROBLEM cannot open MidnightHelper.toc -- run this from the addon root\n")
		os.exit(2)
	end
	for line in toc:lines() do
		local path = line:match("^%s*(Locales[\\/][%w_]+%.lua)%s*$")
		if path then
			ORDER[#ORDER + 1] = path:gsub("\\", "/")
		end
	end
	toc:close()
	if #ORDER == 0 then
		io.write("  PROBLEM the .toc lists no Locales files -- refusing to report on nothing\n")
		os.exit(2)
	end
end

local PACKS = { "enUS", "deDE", "frFR", "esES", "ptBR", "itIT", "nlNL" }

local currentLocale = "enUS"
function GetLocale()
	return currentLocale
end

--- Build the world as it exists on a client running `locale`.
local function BuildFor(locale)
	currentLocale = locale
	local ns = {}
	local problems = {}
	for _, path in ipairs(ORDER) do
		local chunk, err = loadfile(path)
		if not chunk then
			problems[#problems + 1] = path .. " parse: " .. tostring(err)
		else
			local ok, rerr = pcall(chunk, "MidnightHelper", ns)
			if not ok then
				problems[#problems + 1] = path .. " run: " .. tostring(rerr)
			end
		end
	end
	return ns, problems
end

local KEYS = { ... }

--- `--dump` prints every key in every language as TSV, for tools/check_drift.py.
---
--- The drift checker used to parse the locale files itself. On 26 aug 2026 that
--- parser was wrong three times in one hour -- it missed keys sharing a line
--- ("A = ..., B = ..."), it missed the per-language merge() blocks inside
--- DelveTips/Codex/..., and it "proved" that 1170 fills were dead. This loader
--- disagreed every time, and this loader was right. So the checker no longer
--- reads Lua; it reads this.
if KEYS[1] == "--dump" then
	local function esc(s)
		return (tostring(s):gsub("\\", "\\\\"):gsub("\n", "\\n"):gsub("\t", "\\t"):gsub("\r", ""))
	end
	for _, code in ipairs(PACKS) do
		local ns, problems = BuildFor(code)
		for _, p in ipairs(problems) do
			io.stderr:write("PROBLEM (" .. code .. ") " .. p .. "\n")
		end
		local pack = (ns._mhLocales and ns._mhLocales[code]) or nil
		if not pack then
			io.stderr:write(("PROBLEM (%s) pack never registered\n"):format(code))
		else
			local keys = {}
			for k in pairs(pack) do
				if type(k) == "string" then keys[#keys + 1] = k end
			end
			table.sort(keys)
			for _, k in ipairs(keys) do
				if type(pack[k]) == "string" then
					io.write(code, "\t", k, "\t", esc(pack[k]), "\n")
				end
			end
		end
	end
	return
end

if #KEYS == 0 then
	print("usage: lua tools/locale_probe.lua KEY [KEY ...]")
	print("       lua tools/locale_probe.lua --dump      (TSV for check_drift.py)")
	return
end

-- English is the fallback every other language lands on, so grab it once.
local enNs = BuildFor("enUS")
local en = (enNs._mhLocales and enNs._mhLocales.enUS) or {}

local results = {}
for _, code in ipairs(PACKS) do
	local ns, problems = BuildFor(code)
	for _, p in ipairs(problems) do
		print("  PROBLEM (" .. code .. ") " .. p)
	end
	local pack = ns._mhLocales and ns._mhLocales[code]
	results[code] = pack
	if not pack then
		print(("  PROBLEM (%s) pack never registered — check the locale gate"):format(code))
	end
end
print("")

local bad = 0
for _, key in ipairs(KEYS) do
	print("== " .. key)
	local englishValue = en[key]
	if englishValue == nil then
		bad = bad + 1
		print("   enUS: MISSING — this would render as its own key name on screen")
	end
	for _, code in ipairs(PACKS) do
		local pack = results[code] or {}
		local v = pack[key]
		local state
		if v == nil then
			state = (code == "enUS") and "MISSING" or "nil -> shows English"
		elseif code ~= "enUS" and v == englishValue then
			state = "still English (a copy, not a translation)"
		else
			state = "OK"
		end
		local shown = tostring(v)
		if #shown > 66 then
			shown = shown:sub(1, 63) .. "..."
		end
		print(("   %-5s %-44s %s"):format(code, state, shown))
	end
	print("")
end

if bad > 0 then
	print(("%d key(s) missing from enUS — those are the only truly broken ones."):format(bad))
end
