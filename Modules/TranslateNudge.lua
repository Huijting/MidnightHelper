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
	-- 🔴 GITHUB FIRST, AND IT USED TO BE DISCORD. The old comment here said the list of
	-- what still needs translating was pinned in #translations (Rob posted it 29 jul).
	-- Rob, 30 aug 2026: "er is nog helemaal niemand op Discord." That route was written
	-- off in CLAUDE.md that morning while this function went on promising it in seven
	-- languages -- an empty channel and a list nobody maintains, offered to the one kind
	-- of person who volunteered to help.
	--
	-- GitHub is the route that works: it has a translation issue template, and
	-- `tools/check_drift.py --workpackage` generates the paste-ready list on demand
	-- instead of relying on someone remembering to re-pin it.
	-- Discord stays, because Rob really is reachable there. It no longer claims a list.
	print("  " .. ns:L("TRANSLATE_HELP_LINK") .. ": " .. TRANSLATE_URL)
	print("  " .. ns:L("TRANSLATE_HELP_DISCORD") .. ": " .. DISCORD_INVITE)
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

-- Measured shares, from the audit's per-pack counts (29 jul): deDE 78%, itIT 75%,
-- nlNL 95%. The ceiling sits above the first two and below nlNL, which is
-- effectively finished and must never show this card.
local PARTIAL_CEILING = 0.90
-- Below this the pack is a stub rather than an unfinished translation, and the
-- no-pack nudge above already covers that case with better wording.
local PARTIAL_FLOOR = 0.05

local coverageCache

--- Share of the active pack that is actually IN that language, 0-1, or nil.
---
--- Presence cannot be the test. deDE.lua (and its siblings) copy every enUS key
--- into the pack and overwrite only the translated ones, so `pack[k] ~= nil` is
--- true for everything and the first version of this measured a flat 100% -- the
--- card could never appear. What separates translated from untranslated at runtime
--- is that an untranslated key still holds the English STRING.
---
--- Cached: NudgeActive runs on every Home render and this walks ~2800 keys.
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
	local total, translated = 0, 0
	for k, v in pairs(en) do
		if type(v) == "string" then
			total = total + 1
			local mine = pack[k]
			if type(mine) == "string" and mine ~= v then
				translated = translated + 1
			end
		end
	end
	if total == 0 then
		coverageCache = false
		return nil
	end
	coverageCache = translated / total
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

--- The language in its own name, taken from the pack we already ship, so nothing
--- here invents a word in a language I cannot check.
---
--- Deliberately no percentage. The share measured above and the one in the
--- translator work package count different things: this one has no way to know a
--- string is English ON PURPOSE (proper nouns, game terms, the changelog), so it
--- reads about 78% for German where the work package says 85%. Both are honest and
--- they disagree, and a card quoting a number lower than the list people are
--- working from would read as their work not landing. The card says what is
--- certainly true; the exact figure lives in one place.
local function partialArg()
	local code = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode() or "?"
	return (ns.GetLocaleDisplayName and ns:GetLocaleDisplayName(code)) or code
end

ns.RegisterNudge({
	id = "translate_partial",
	when = shouldNudgePartial,
	title = "TRANSLATE_PARTIAL_TITLE",
	body = "TRANSLATE_PARTIAL_BODY",
	bodyArg = partialArg,
	actionLabel = "TRANSLATE_NUDGE_BTN",
	action = function() ns.OpenTranslateHelp() end,
	-- No Settings button. `settings` only decides whether a nudge gets a button in
	-- Notifications & tips, and this one runs the very same OpenTranslateHelp as the
	-- nudge below -- so it produced a second "Help translate" that did nothing
	-- different (Rob spotted the duplicate, 30 jul). The card itself is unaffected:
	-- that is driven by `when`.
	settings = false,
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
