--[[
	Keys that must stay ENGLISH in every language pack, and the machinery to enforce it.

	🔴 WHY THIS FILE EXISTS. CLAUDE.md has forbidden translating proper nouns Blizzard owns
	since 14 aug 2026 -- achievement names above all, because the player's own Achievements
	pane then disagrees with us. On 29 aug 2026 Rob found the rule broken in five of six
	packs anyway, and the reason was not carelessness:

	`fill()` in Translations2026/TranslationsS2 replaces a value that is IDENTICAL to enUS,
	because the packs copy every English string at load time and a "is it nil" test could
	never fire (see the long note above `fill`). That test rescued ~400 real translations per
	language. It also means a key deliberately left in English is indistinguishable from a
	placeholder, so the fill overwrites it -- `itIT.lua:1012` correctly kept
	"Veteran of the Dawn" and `Translations2026.lua:7376` turned it into "Veterano dell'Alba".

	So the rule could not be enforced by following it. Intent has to be WRITTEN DOWN, which
	is what this table is: `fill()` skips these keys, and `lint_addon.py` check [15] fails
	when a pack carries a different value for one.

	📌 THE TEST FOR ADDING A KEY: does Blizzard's own UI show this exact string, in that
	language, to that player? An achievement name does. Then we may not invent our own.

	⚠️ WHAT DOES NOT BELONG HERE: anything whose answer differs per language. Crest ranks are
	the live example -- there is no Dutch client, so a Dutch player always reads "Champion
	Crest" and translating it names nothing; German and French are real client languages
	where translating may well be right. A global list cannot express that, so it must not
	pretend to. Those go to #translations per language.
]]

local _, ns = ...

--- key -> why, so the next person does not have to guess whether it still applies.
ns.KEEP_ENGLISH = {
	-- Achievement names. Measured in Rob's own SavedVariables, 28 aug 2026:
	-- achievementName = "Veteran of the Dawn". Translating one invents a title Blizzard
	-- never used, and the player cannot find it in their own Achievements pane.
	DAWNCREST_ACH_VETERAN = "achievement name (Blizzard's own title)",
	DAWNCREST_ACH_CHAMPION = "achievement name (Blizzard's own title)",
	DAWNCREST_ACH_HERO = "achievement name (Blizzard's own title)",
}

--- Shared by both fill files, so the rule cannot hold in one and lapse in the other.
--- @return boolean true when this key must not be written by a fill
function ns.IsKeepEnglishKey(key)
	return ns.KEEP_ENGLISH ~= nil and ns.KEEP_ENGLISH[key] ~= nil
end
