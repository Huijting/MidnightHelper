local _, ns = ...

--[[
	Midnight Helper — "help translate" nudge (Spec 15/16), first consumer of the
	nudge framework. Invites players whose official WoW client locale has no MH
	pack yet to help translate on GitHub. Never fabricates translations; it only
	opens the channel. Falls back to English until a pack exists.

	Why GitHub, not CurseForge: CF's localization crowdsourcing isn't reachable for
	this project (deprecated / absent from the new authors console — verified 2026-07-13),
	so translations come in as GitHub issues/PRs and get merged into Locales/<loc>.lua,
	exactly like the existing six packs.
]]

-- Official WoW client locales that MH has no pack for yet.
local NUDGE_LOCALES = { koKR = true, zhCN = true, zhTW = true, ruRU = true }
-- Autonyms (proper nouns, safe to hardcode — not "translated" strings).
local ENDONYM = { koKR = "한국어", zhCN = "简体中文", zhTW = "繁體中文", ruRU = "Русский" }

-- Where translators contribute. CF's localization system isn't available for this project,
-- so we route to the public GitHub repo (open an issue with your language).
local TRANSLATE_URL = "https://github.com/Huijting/MidnightHelper/issues/new?template=translation.yml"
-- Same invite as DiscordNudge.lua and the CurseForge page. Duplicated rather than
-- shared because those two are separate opt-in features and a nudge that silently
-- stops printing a link when another module is disabled would be worse than a
-- second copy of one string.
local DISCORD_INVITE = "https://discord.gg/kBHaHcsASQ"

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
	-- Discord first: the actual list of what still needs translating is pinned in
	-- #translations there (Rob posted it 29 jul). GitHub is where finished work is
	-- merged, which matters later and to fewer people.
	print("  " .. ns:L("TRANSLATE_HELP_DISCORD") .. ": " .. DISCORD_INVITE)
	print("  " .. ns:L("TRANSLATE_HELP_LINK") .. ": " .. TRANSLATE_URL)
	print("  " .. string.format(ns:L("TRANSLATE_HELP_LANG"), loc))
	print("  " .. ns:L("TRANSLATE_HELP_MEANWHILE"))
end

--------------------------------------------------------------------------------
-- Second nudge: the pack EXISTS but is unfinished (Rob, 29 jul 2026).
--
-- The nudge above only reaches players whose language has no pack at all, which
-- misses the people best placed to help. German, French, Spanish, Portuguese and
-- Italian sit in the low eighties, so roughly one string in six comes out English
-- -- and those players watch it happen every session. They were never asked.
--
-- Coverage is COUNTED against the live enUS table, never written down. A hardcoded
-- "85%" would be wrong the day after someone sends work in, and wrong in the
-- direction that makes us look like we ignored it.
--------------------------------------------------------------------------------

-- Above this, stop asking. At 95% a player meets an English string rarely enough
-- that a recurring card is nagging rather than informing, and the tail is usually
-- long strings nobody volunteers for anyway.
local PARTIAL_CEILING = 0.95
-- Below this, the pack is a stub rather than an unfinished translation, and the
-- no-pack nudge above already covers that case with better wording.
local PARTIAL_FLOOR = 0.05

local coverageCache

--- Share of enUS keys the effective pack answers for, 0-1, or nil when unknown.
--- Cached: NudgeActive runs this on every Home render, and it walks ~2800 keys.
local function packCoverage()
	if coverageCache ~= nil then
		return coverageCache or nil
	end
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode()
	local en = ns._mhLocales and ns._mhLocales.enUS
	local pack = code and ns._mhLocales and ns._mhLocales[code]
	if code == "enUS" or type(en) ~= "table" or type(pack) ~= "table" then
		coverageCache = false
		return nil
	end
	local total, have = 0, 0
	for k in pairs(en) do
		total = total + 1
		if pack[k] ~= nil then
			have = have + 1
		end
	end
	if total == 0 then
		coverageCache = false
		return nil
	end
	coverageCache = have / total
	return coverageCache
end

--- Called by ns:SetLocale — the cached figure describes the pack that was active
--- when it was measured, and after a language change that is the wrong pack.
function ns.ResetTranslateCoverage()
	coverageCache = nil
end

local function shouldNudgePartial()
	local c = packCoverage()
	return c ~= nil and c > PARTIAL_FLOOR and c < PARTIAL_CEILING
end

--- "Deutsch is 84% translated" — the language in its own name, from the pack we
--- already ship, so nothing here invents a word in a language I cannot check.
local function partialArg()
	local c = packCoverage() or 0
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode() or "?"
	local name = (ns.GetLocaleDisplayName and ns:GetLocaleDisplayName(code)) or code
	return string.format(ns:L("TRANSLATE_PARTIAL_ARG_FMT"), name, math.floor(c * 100))
end

ns.RegisterNudge({
	id = "translate_partial",
	when = shouldNudgePartial,
	title = "TRANSLATE_PARTIAL_TITLE",
	body = "TRANSLATE_PARTIAL_BODY",
	bodyArg = partialArg,
	actionLabel = "TRANSLATE_NUDGE_BTN",
	action = function() ns.OpenTranslateHelp() end,
	settings = true,
})

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
