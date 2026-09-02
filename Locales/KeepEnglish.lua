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

--- 🔴 AND THE PER-LANGUAGE HALF, which the global table above deliberately cannot express.
---
--- Crest ranks are the case. There is no Dutch WoW client, so a Dutch player always reads
--- "Champion Crest" and translating it names something that exists on no screen — Carola
--- went looking for "Kampioen crest" on 28 aug and found nothing. German and French are real
--- client languages where translating may be exactly right, and both already keep "Champion"
--- anyway. One global list cannot hold both answers, so this one is keyed by language.
---
--- ⚠️ Only languages whose answer is SETTLED belong here.
---
--- ✅ AND es/pt/it ARE SETTLED NOW — MEASURED 2 sep 2026, and the answer is "leave them alone".
--- Their clients DO translate the rank, so translating is correct there and they must stay out
--- of this table. From Wowhead's own localised currency pages, which mirror the client strings:
---     esES  "Blasón del alba de héroe"       (héroe)
---     ptBR  "Brasão Auroral do Herói"        (Herói)
---     itIT  "Emblema dell'Alba del Campione" (Campione, currency 3343)
--- Exactly what this comment predicted for real client languages, and the mirror image of nlNL.
---
--- 📌 itIT.lua says "Champion" for DAWNCREST_TIER_CHAMPION, which looks like a decision and is
--- not one: the packs copy the English text for every key they have no override for, so that is
--- a copy. The fill in Translations2026.lua replaces it with "Campione" precisely because it
--- equals enUS — which lands on the client-correct word. Nothing to change.
---
--- 🔴 The old note here said this question "goes to #translations". That channel was retired on
--- 30 aug ("er is nog helemaal niemand op Discord"), so the question sat pointing at a route
--- that no longer existed. It never needed people with those clients either: es/pt/it are real
--- client languages, so Blizzard's own data answers it — the same way Valira was settled for
--- Portuguese. A question parked with the wrong owner stays parked.
ns.KEEP_ENGLISH_FOR = {
	nlNL = {
		-- 📌 ADVENTURER CAN BE GUARDED NOW, and it could not this morning. It used to read
		-- "Adventurer (green)" — a name plus a clarifier of ours — and check [15] compares
		-- whole strings, so listing it fired on the correct Dutch "Adventurer (groen)".
		-- Rob chose to split it (29 aug): the name lives here, the "(groen)" moved to
		-- DAWNCREST_TIER_ADVENTURER_HINT, which is NOT guarded and follows the language.
		-- Weakening the check to a substring test was the alternative, and it would have
		-- let "Avonturier (groen)" through everywhere.
		DAWNCREST_TIER_ADVENTURER = "no Dutch client: the game says Adventurer",
		DAWNCREST_TIER_VETERAN = "no Dutch client: the game says Veteran",
		DAWNCREST_TIER_CHAMPION = "no Dutch client: the game says Champion",
		DAWNCREST_TIER_HERO = "no Dutch client: the game says Hero",
		DAWNCREST_TIER_MYTH = "no Dutch client: the game says Myth",
	},
}

--- Shared by both fill files, so the rule cannot hold in one and lapse in the other.
--- @return boolean true when this key must not be written by a fill
function ns.IsKeepEnglishKey(key)
	return ns.KEEP_ENGLISH ~= nil and ns.KEEP_ENGLISH[key] ~= nil
end

--- @return boolean true when this key must stay English in THIS language specifically
function ns.IsKeepEnglishFor(code, key)
	if ns.IsKeepEnglishKey(key) then
		return true
	end
	local per = ns.KEEP_ENGLISH_FOR and ns.KEEP_ENGLISH_FOR[code]
	return per ~= nil and per[key] ~= nil
end
