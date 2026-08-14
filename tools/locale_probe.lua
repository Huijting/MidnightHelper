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

local ORDER = {
	"Locales/enUS.lua",
	"Locales/deDE.lua",
	"Locales/frFR.lua",
	"Locales/esES.lua",
	"Locales/ptBR.lua",
	"Locales/itIT.lua",
	"Locales/nlNL.lua",
	"Locales/ConsumablesNotes.lua",
	"Locales/DelveTips.lua",
	"Locales/RitualTips.lua",
	"Locales/RaidTips.lua",
	"Locales/MythicPlus.lua",
	"Locales/StartHere.lua",
	"Locales/DungeonGuide.lua",
	"Locales/SettingsPage.lua",
	"Locales/DungeonTips.lua",
	"Locales/Codex.lua",
	"Locales/OmniumFolio.lua",
	"Locales/Translations2026.lua",
	"Locales/TranslationsS2.lua",
}

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
if #KEYS == 0 then
	print("usage: lua5.1 scratchpad/locale_probe.lua KEY [KEY ...]")
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
