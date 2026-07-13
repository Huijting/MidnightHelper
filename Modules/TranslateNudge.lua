local _, ns = ...

--[[
	Midnight Helper — "help translate" nudge (Spec 15/16), first consumer of the
	nudge framework. Invites players whose official WoW client locale has no MH
	pack yet to help translate on CurseForge. Never fabricates translations; it
	only opens the channel. Falls back to English until a pack exists.
]]

-- Official WoW client locales that MH has no pack for yet.
local NUDGE_LOCALES = { koKR = true, zhCN = true, zhTW = true, ruRU = true }
-- Autonyms (proper nouns, safe to hardcode — not "translated" strings).
local ENDONYM = { koKR = "한국어", zhCN = "简体中文", zhTW = "繁體中文", ruRU = "Русский" }

-- CurseForge localization page. Verify/adjust once localization is enabled on the project (Spec 16).
local CF_LOCALIZATION_URL = "https://www.curseforge.com/wow/addons/midnight-helper/localization"

local function currentEndonym()
	local loc = GetLocale()
	return ENDONYM[loc] or loc
end

-- Show only when: official client locale in the set AND no NON-EMPTY pack exists yet.
-- An empty pack (a CF shim before any community translation lands, Spec 16) is not a
-- real pack — keep inviting until it actually has keys.
local function shouldNudge()
	local loc = GetLocale()
	if not NUDGE_LOCALES[loc] then return false end
	local pack = ns._mhLocales and ns._mhLocales[loc]
	if type(pack) == "table" and next(pack) ~= nil then return false end
	return true
end

-- Action: print a short how-to (also reachable via /mh translate).
function ns.OpenTranslateHelp()
	local loc = GetLocale()
	print("|cffe8c36aMidnight Helper|r — " .. ns:L("TRANSLATE_HELP_HEADER"))
	print("  " .. ns:L("TRANSLATE_HELP_CF") .. ": " .. CF_LOCALIZATION_URL)
	print("  " .. string.format(ns:L("TRANSLATE_HELP_LANG"), loc))
	print("  " .. ns:L("TRANSLATE_HELP_MEANWHILE"))
end

ns.RegisterNudge({
	id = "translate",
	when = shouldNudge,
	title = "TRANSLATE_NUDGE_TITLE",
	body = "TRANSLATE_NUDGE_BODY",
	bodyArg = currentEndonym,
	actionLabel = "TRANSLATE_NUDGE_BTN",
	action = function() ns.OpenTranslateHelp() end,
	settings = true,
})
