local _, ns = ...

--[[
	Midnight Helper — Dundun, the Shrine of Abundance.

	One sentence nobody else gives the player: this delve is Bountiful, so Dundun is
	hiding in it, and taking his offer can cost a SECOND Restored Coffer Key.

	🔴 WHAT DUNDUN IS, AND WHAT WE GOT WRONG FIRST (3-4 Sep 2026). Rob met him in The Gulf
	of Memory and the entrance screen said "Dundun will hide within this Delve." The
	handoff then recorded him as a delve MODIFIER, which is wrong: the wiki's
	`Category:Delve affixes` lists seventeen and he is not among them. He is an NPC
	(wiki NPC id 266751) disguised as a prop -- a fake tree -- and he appears in
	**Bountiful** delves of any tier once the player has reached Delver's Journey rank 3.

	That correction is what makes this small. We do not need to read delve affixes at all
	(we never could): Bountiful already comes from the client, the Journey rank already
	has a reader, and Restored Coffer Keys are already counted.

	⚠️ WHAT IS STILL UNSETTLED, and why the wording below is careful. Sources disagree on
	what the FIRST find of a week gives. Rob measured a second Bountiful Coffer that
	needed a second key (his own tooltip read `Restored Coffer Key 2 / 1`), and
	masterofwarcraft.net says the same; the Warcraft Wiki instead describes an "Abundantly
	Bountiful Heavy Trunk" with a choice of Undercoin / Voidlight Marl / Valeera XP /
	housing decor. Whether the axis is "first ever" or "first this week" is not
	established. So we say the extra chest CAN cost a second key -- never that it will.

	⚠️ And rank 3 itself is from those same web sources, not measured in the client. If
	the rank cannot be read we still speak, but say the condition out loud instead of
	pretending we checked it.

	📌 `/mh dundun` prints the whole decision including why it stayed quiet, because
	staying quiet is the normal outcome here (most delves are not Bountiful) and correct
	silence must be distinguishable from broken.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- The rank at which Dundun starts appearing. Web-sourced ("Rank 3: Treasure Hunter"),
--- NOT measured in the client -- see the header.
local DUNDUN_MIN_JOURNEY_RANK = 3
local CURRENCY_COFFER_KEY = 3028
local CURRENCY_COFFER_SHARDS = 3310

--- 🔴 SHARDS CHANGE THE ADVICE, and leaving them out made the first version misleading.
--- Rob's own entrance tooltip (4 Sep, The Darkway tier 11) spells out the rule Blizzard
--- never puts in the currency pane: "100 Coffer Key Shards are automatically combined
--- into a Restored Coffer Key ON ENTRY." So "you have 0 keys" was true and useless — he
--- had 84 shards, sixteen short of a key that would have appeared by itself. Telling
--- someone they cannot afford something when they are one outdoor activity away from
--- affording it is the same kind of confidently-wrong this addon exists not to be.
local SHARDS_PER_KEY = 100

--- @param currencyID number
--- @return number|nil quantity, nil when it cannot be read
local function CurrencyCount(currencyID)
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, currencyID)
	if not ok or type(info) ~= "table" then
		return nil
	end
	local q = info.quantity
	if q == nil or (issecretvalue and issecretvalue(q)) then
		return nil
	end
	return tonumber(q)
end

--- Name of the delve the player is standing in, as far as the addon can tell.
--- @return string|nil
local function ActiveDelveName()
	-- Declared with a dot and taking no arguments (DelveTipsData.lua:432) -- call it that
	-- way rather than passing ns, which only happened to work because it is ignored.
	local entry
	if ns.GetActiveDelveTipEntryForPlayer then
		local ok, e = pcall(ns.GetActiveDelveTipEntryForPlayer)
		if ok then
			entry = e
		end
	end
	-- 🔴 `return entry.name or entry.title` WAS A BUG: when the entry exists but carries
	-- neither field it returns nil and SKIPS the fallback below, so the fallback added to
	-- fix the nil never ran. Measured 4 Sep: activeDelveName stayed nil even though
	-- IsKnownDelveName said true for the same zone in the same run. Only return a name
	-- when there is one.
	if type(entry) == "table" then
		local n = entry.name or entry.title
		if type(n) == "string" and n ~= "" then
			return n
		end
	end

	-- 🔴 FALLBACK, and it is the one that actually fires inside a delve. Measured 4 Sep in
	-- The Darkway: `GetActiveDelveTipEntryForPlayer()` returned nil while
	-- `IsKnownDelveName(GetZoneText())` returned TRUE for the same zone, and
	-- `the_darkway` was sitting in the roster all along. So the entry matcher fails in
	-- here for its own reasons; the zone name does not.
	--
	-- 📌 The theory this replaces was wrong twice over: I guessed The Darkway was a Legion
	-- delve (it is in our Midnight roster) and I guessed the roster lacked it (it does
	-- not). Both were reasoning about a list I had not printed. The scan printed it.
	if GetZoneText and ns.IsKnownDelveName then
		local zone = GetZoneText()
		if zone and zone ~= "" then
			local ok, known = pcall(ns.IsKnownDelveName, zone)
			if ok and known then
				return zone
			end
		end
	end
	return nil
end

--- Everything the advice rests on, gathered once so the chat line and the diagnostic
--- cannot drift apart. Every field is three-state: a value, or nil for "could not read".
--- @return table
function ns.GetDundunStatus()
	local s = {}

	s.delveName = ActiveDelveName()

	-- 🔴 `or nil` HERE WAS A BUG, and it is the exact mistake this file lectures about.
	-- The first version wrote `... and ns:IsDelveInstanceInProgress() or nil`, which
	-- collapses a perfectly good `false` into `nil` — so standing in Silvermoon printed
	-- "in a delve: could not read" instead of "no". Rob's first run showed three of those
	-- in a row (4 Sep). A diagnostic that cries "unreadable" when the answer is simply
	-- "no" trains you to ignore it, and then hides the one real read failure it exists to
	-- catch. Keep false false.
	if ns.IsDelveInstanceInProgress then
		local ok, v = pcall(ns.IsDelveInstanceInProgress, ns)
		if ok then
			s.inDelve = v and true or false
		end
	end

	-- Bountiful. ⚠️ This reads the map POI, and inside the delve that POI may be gone --
	-- measured behaviour unknown, which is exactly why nil is kept distinct from false.
	-- Only asked when we are actually in a delve: outside one there is nothing to be
	-- Bountiful, so asking would manufacture an "unreadable" out of thin air.
	if s.inDelve ~= false and ns.IsDelveBountiful and s.delveName then
		local ok, b = pcall(ns.IsDelveBountiful, s.delveName, nil)
		if ok then
			s.bountiful = b and true or false
		end
	end

	-- Delver's Journey rank. nil means unreadable, never rank 0 -- GetDelverJourneyStatus
	-- is already written that way, so do not undo it here.
	if ns.GetDelverJourneyStatus then
		local ok, j = pcall(ns.GetDelverJourneyStatus)
		if ok and type(j) == "table" then
			s.rank = tonumber(j.rank)
		end
	end
	if s.rank ~= nil then
		s.rankOk = s.rank >= DUNDUN_MIN_JOURNEY_RANK
	end

	s.keys = CurrencyCount(CURRENCY_COFFER_KEY)
	s.shards = CurrencyCount(CURRENCY_COFFER_SHARDS)
	-- How many keys the player can actually field, shards included. Kept separate from
	-- `keys` so the diagnostic can show both and nobody has to trust this arithmetic.
	if s.keys ~= nil then
		s.effectiveKeys = s.keys + math.floor((s.shards or 0) / SHARDS_PER_KEY)
		if s.shards ~= nil and s.effectiveKeys < 2 then
			s.shardsToNextKey = SHARDS_PER_KEY - (s.shards % SHARDS_PER_KEY)
		end
	end

	-- The verdict, with the reason attached. A caller must never re-derive this.
	-- Order matters: "you are not in a delve" must be reported as itself, never as a
	-- failure to read the Bountiful flag. Those two look identical downstream and only
	-- one of them is a problem.
	if s.inDelve == false then
		s.verdict, s.reason = "quiet", "you are not in a delve"
	elseif s.delveName == nil and s.bountiful == nil then
		s.verdict, s.reason = "quiet", "no active delve could be identified"
	elseif s.bountiful == nil then
		s.verdict, s.reason = "quiet", "could not read whether this delve is Bountiful"
	elseif s.bountiful == false then
		s.verdict, s.reason = "quiet", "this delve is not Bountiful, so Dundun is not in it"
	elseif s.rankOk == false then
		s.verdict, s.reason = "quiet", ("Delver's Journey rank %d is below %d, so Dundun"
			.. " does not appear yet"):format(s.rank, DUNDUN_MIN_JOURNEY_RANK)
	elseif s.rank == nil then
		s.verdict, s.reason = "speak-with-caveat", "Bountiful, but the Journey rank could"
			.. " not be read -- name the rank condition instead of assuming it"
	else
		s.verdict, s.reason = "speak", "Bountiful and rank is high enough"
	end

	return s
end

--- The chat line. This is an EVENT the player can miss (you just walked into a delve),
--- which is the case chat is right for -- as opposed to "why did nothing happen when I
--- pressed this", which belongs where the button is. See CLAUDE.md.
function ns.AnnounceDundunIfRelevant()
	local s = ns.GetDundunStatus()
	if s.verdict ~= "speak" and s.verdict ~= "speak-with-caveat" then
		ns._mhLastDundun = s
		return false
	end

	--- 🔴 ON SCREEN, NOT ONLY IN CHAT — Rob, 4 Sep, standing in The Shadow Enclave:
	--- "ik zag de 2 regels bij het inlopen dus die werkt, maar die valt niet op, niemand
	--- kijkt daar." Third time in two days he has said it, and he is right each time.
	---
	--- 📌 The rule this addon wrote down on 3 Sep splits the cases: chat is fine for an
	--- EVENT you might miss and can scroll back to, but the answer to "what should I do
	--- here" belongs where you are looking. Walking into a Bountiful delve is both — so it
	--- gets both, and the toast carries the part that changes what you do.
	---
	--- ⚠️ The toast is deliberately short. The key arithmetic stays in chat: a toast that
	--- has to be read carefully is a toast nobody finishes. Clicking it opens the macro,
	--- which is the one action this whole feature exists to enable.
	if ns.QueueMidnightToast then
		local sub
		if s.keys ~= nil and (s.effectiveKeys or s.keys) < 2 then
			sub = ns:L("DUNDUN_CHAT_COST_SHORT_FMT"):format(s.effectiveKeys or s.keys)
		else
			sub = ns:L("DUNDUN_CHAT_WHAT")
		end
		pcall(ns.QueueMidnightToast, {
			id = "dundun_shrine",
			title = ns:L("DUNDUN_PANEL_TITLE"),
			body = sub,
			icon = 136071, -- Polymorph's icon stands in: a prop that is not what it seems.
			clickHintKey = "DUNDUN_PANEL_MACRO_BTN",
			onClick = function()
				if ns.SelectTab then
					ns.SelectTab("macros")
				end
				if ns.MH_OpenMacroType then
					ns.MH_OpenMacroType("world")
				end
			end,
		})
	end

	print(PREFIX .. " " .. ns:L("DUNDUN_CHAT_HEADER"))
	print("  " .. ns:L("DUNDUN_CHAT_WHAT"))
	if s.verdict == "speak-with-caveat" then
		print("  " .. ns:L("DUNDUN_CHAT_RANK_UNKNOWN"):format(DUNDUN_MIN_JOURNEY_RANK))
	end

	-- The key line. Judged on effectiveKeys, not keys, because shards turn into a key on
	-- entry all by themselves -- see SHARDS_PER_KEY above.
	if s.keys == nil then
		print("  " .. ns:L("DUNDUN_CHAT_COST_UNKNOWN"))
	elseif (s.effectiveKeys or s.keys) >= 2 then
		print("  " .. ns:L("DUNDUN_CHAT_COST_FMT"):format(s.effectiveKeys or s.keys))
	else
		print("  |cffff8844"
			.. ns:L("DUNDUN_CHAT_COST_SHORT_FMT"):format(s.effectiveKeys or s.keys) .. "|r")
		if s.shardsToNextKey then
			print("  " .. ns:L("DUNDUN_CHAT_SHARDS_FMT"):format(
				s.shards or 0, s.shardsToNextKey))
		end
	end

	print("  " .. ns:L("DUNDUN_CHAT_MACRO"))
	ns._mhLastDundun = s
	return true
end

--------------------------------------------------------------------------------
-- A macro that belongs to the world, not to a class
--------------------------------------------------------------------------------
--
-- The Macros tab had two kinds, `interrupt` and `utility`, and both are keyed by class
-- and spec (ns.TeamMacrosByClassSpec). Dundun's targeting macro is neither: every class
-- needs the same two lines, because the problem is that he is scenery and not that your
-- spec lacks a button. So a third kind is registered here.
--
-- 📌 This is also the first tenant of the banked "handy quick actions" idea (15 Jul).
-- Anything else that is one line, useful, and class-independent goes in this list.
--
-- ⚠️ Registered by appending rather than by editing InterruptMacros.lua's own table, so
-- the panel keeps working unchanged if this module is ever removed. DundunShrine loads
-- after InterruptMacros in the .toc, which is what makes the append safe.
ns.WORLD_MACROS = {
	{
		id = "dundun_target",
		name = "Find Dundun",
		-- ⚠️ The ping line is the half that makes it usable, and the first version dropped
		-- it. Targeting alone tells you he exists somewhere; the ping puts a marker in the
		-- world so you can walk to him. Rob found this macro himself and specifically
		-- asked for the line back: "ik mis in de macro de ping lijn die ik erg makkelijk
		-- vond." Keep all three lines together.
		descEn = "Target the Shrine of Abundance in a Bountiful delve and ping where he is."
			.. " He is disguised as scenery, so the eye will not find him — the targeting"
			.. " will, and the ping shows you where to walk.",
		descNl = "Target de Shrine of Abundance in een Bountiful delve en pingt waar hij"
			.. " staat. Hij is vermomd als decor, dus met het oog vind je hem niet — met"
			.. " targeten wel, en de ping laat zien waar je heen moet.",
		macro = [=[/cleartarget
/target Dundun
/ping [@target] assist]=],
	},
}

if type(ns.MacroPanelTypes) == "table" then
	table.insert(ns.MacroPanelTypes, {
		id = "world",
		labelKey = "MACROS_TYPE_WORLD",
		subtitleKey = "MACROS_WORLD_SUBTITLE",
		-- These macros are the same for every class, so the panel must not head them with
		-- the player's class and spec. See the specLine branch in InterruptMacros.
		classless = true,
		getList = function()
			local list = ns.WORLD_MACROS
			if type(list) ~= "table" or #list < 1 then
				return nil
			end
			-- The other two kinds return (list, classToken, specIndex); these macros have
			-- no class, so the panel is handed nils it already knows how to render.
			return list, nil, nil
		end,
		getContext = function(panel)
			local list = ns.WORLD_MACROS
			if type(list) ~= "table" or #list < 1 then
				return nil, "empty", nil, 0, nil, nil, nil
			end
			local idx = 1
			if panel and panel._mhMacrosPickIndex and panel._mhMacrosPickIndex.world then
				idx = panel._mhMacrosPickIndex.world
			end
			if idx < 1 or idx > #list then
				idx = 1
			end
			local e = list[idx]
			local desc = e.descEn
			if GetLocale and GetLocale() == "nlNL" and e.descNl then
				desc = e.descNl
			end
			return e.macro, nil, nil, 0, nil, e.name, desc
		end,
	})
end

--- `/mh dundun scan` — where can "is this delve Bountiful" come from while INSIDE it?
---
--- 🔴 THE PROBLEM THIS EXISTS FOR, measured 4 Sep in The Darkway (tier 11, Bountiful).
--- `in a delve` read true, but the delve NAME could not be resolved, so the Bountiful
--- check — which needs a name to look up a map POI — was never even asked. The whole
--- feature is therefore inert inside exactly the delves it is meant for.
---
--- The entrance tooltip Rob screenshotted says the state is knowable: "This delve has an
--- abundance of treasures and WILL REMAIN BOUNTIFUL WHILE INSIDE", with spell 430253 on
--- it. So the information exists in the client; we are asking the wrong thing for it.
---
--- ⚠️ This enumerates rather than guesses. Calling a plausible-sounding
--- `C_DelvesUI.GetDelveModifiers()` would produce "nothing found" for two different
--- reasons — no such function, or no such data — and those are not the same answer. The
--- same mistake registered a non-existent event on 8 Aug because four other addons
--- mentioned its name.
--- ⚠️ WRITES TO `ns.db.dundunScan`, it does not just print. This project settled on
--- SavedVariables for long diagnostics on 27 Jul 2026 precisely so nobody has to
--- screenshot a thirty-line list — and the first version of this function ignored that
--- and printed only, which cost Rob a wasted run inside a delve on 4 Sep.
function ns.ScanDundunSources()
	ns.db = ns.db or {}
	local out = { at = (_G.date and _G.date("%Y-%m-%d %H:%M:%S")) or "?" }

	-- 1. Everything C_DelvesUI exposes. Enumerated, never guessed by name.
	if type(C_DelvesUI) ~= "table" then
		out.delvesUI = "absent"
	else
		local names = {}
		pcall(function()
			for k, v in pairs(C_DelvesUI) do
				names[#names + 1] = tostring(k) .. " (" .. type(v) .. ")"
			end
		end)
		table.sort(names)
		out.delvesUI = names
	end

	-- 2. The scenario side. A delve runs as a scenario, and the entrance screen's
	-- "Map Properties" row has to be rendered from something.
	if C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo then
		local ok, info = pcall(C_ScenarioInfo.GetScenarioInfo)
		if ok and type(info) == "table" then
			local scen = {}
			for k, v in pairs(info) do
				scen[tostring(k)] = tostring(v)
			end
			out.scenario = scen
		else
			out.scenario = "no scenario info"
		end
	end

	-- 3. Our own two readers, side by side, so the failure is located rather than felt.
	local name = ActiveDelveName()
	out.activeDelveName = tostring(name)
	if ns.IsDelveBountiful then
		-- Ask it three ways, because last run it was asked with a nil name and answered
		-- "false" -- an answer that looked like a measurement and was not one.
		local ok, b = pcall(ns.IsDelveBountiful, name, nil)
		out.isDelveBountiful = ("name=%s → ok=%s value=%s"):format(
			tostring(name), tostring(ok), tostring(b))
		local zone = GetZoneText and GetZoneText() or nil
		local okZ, bz = pcall(ns.IsDelveBountiful, zone, nil)
		out.isDelveBountifulByZone = ("zone=%s → ok=%s value=%s"):format(
			tostring(zone), tostring(okZ), tostring(bz))
		local okM, bm = pcall(ns.IsDelveBountiful, zone,
			C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or nil)
		out.isDelveBountifulByZoneMap = ("zone+map → ok=%s value=%s"):format(
			tostring(okM), tostring(bm))
	end

	-- 4. The zone the client thinks we are in. If the delve has its own map, the outdoor
	-- POI is gone and that alone explains the failure.
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, mid = pcall(C_Map.GetBestMapForUnit, "player")
		out.playerMapID = tostring(ok and mid)
		if ok and mid and C_Map.GetMapInfo then
			local okI, mi = pcall(C_Map.GetMapInfo, mid)
			if okI and type(mi) == "table" then
				out.playerMapName = tostring(mi.name)
				out.playerMapParent = tostring(mi.parentMapID)
				out.playerMapType = tostring(mi.mapType)
			end
		end
	end
	out.zoneText = tostring(GetZoneText and GetZoneText())
	out.subZoneText = tostring(GetSubZoneText and GetSubZoneText())
	out.instanceName = tostring(GetInstanceInfo and GetInstanceInfo())

	-- 5. 🔴 THE LIKELY WHOLE ANSWER, and it is not a missing API.
	-- `ns.GetActiveDelveTipEntryForPlayer` matches the player's zone strings against
	-- `ns.DELVE_TIP_ENTRIES` — our own hand-written roster of MIDNIGHT delves. Rob's run
	-- was "The Darkway", under Suramar: a Legion delve. If it is simply not in the list,
	-- nothing in the client is hiding anything and the fix is a different source, not a
	-- better call. Listing the roster settles that in one look instead of a theory.
	if type(ns.DELVE_TIP_ENTRIES) == "table" then
		local rn = {}
		for _, e in ipairs(ns.DELVE_TIP_ENTRIES) do
			if type(e) == "table" then
				rn[#rn + 1] = tostring(e.name or e.title or e.id or "?")
			end
		end
		table.sort(rn)
		out.rosterCount = #rn
		out.rosterNames = rn
		-- ⚠️ The roster keys are ids ("the_darkway"), the zone is a display name
		-- ("The Darkway"). Comparing them raw answered "no" while the entry was sitting
		-- right there -- normalise both sides before deciding anything.
		local function Norm(s)
			return tostring(s or ""):lower():gsub("[^%a%d]", "")
		end
		local zone = Norm(out.zoneText)
		out.rosterHasThisZone = "no"
		for _, n in ipairs(rn) do
			if zone ~= "" and Norm(n) == zone then
				out.rosterHasThisZone = "yes: " .. n
				break
			end
		end
	else
		out.rosterNames = "ns.DELVE_TIP_ENTRIES is not a table"
	end
	if ns.IsKnownDelveName then
		local ok, known = pcall(ns.IsKnownDelveName, out.zoneText)
		out.knownDelveName = ("ok=%s value=%s"):format(tostring(ok), tostring(known))
	end

	-- 6. 🔑 THE FUNCTIONS THAT MIGHT ACTUALLY ANSWER IT, called rather than admired.
	-- The first scan listed 40 C_DelvesUI members; several of them read like exactly what
	-- we need — GetDelvesAffixSpellsForSeason, GetActiveDelveTier, HasActiveDelve,
	-- GetTieredEntranceOptionalAffixTraitTreeID. Reading a name is not knowing what it
	-- returns, so each is invoked and its result described.
	--
	-- ⚠️ Only calls that are safe to make blind: no arguments, or an argument we already
	-- hold (the season number, the player's map id). Anything needing an id we would have
	-- to invent is left alone -- a made-up argument produces a made-up answer.
	local season
	if C_DelvesUI and C_DelvesUI.GetCurrentDelvesSeasonNumber then
		local okS, sn = pcall(C_DelvesUI.GetCurrentDelvesSeasonNumber)
		season = okS and tonumber(sn) or nil
	end
	out.season = tostring(season)

	local calls = {}
	local function TryCall(label, fn, ...)
		if type(fn) ~= "function" then
			calls[label] = "no such function"
			return
		end
		local packed = { pcall(fn, ...) }
		if not packed[1] then
			calls[label] = "errored: " .. tostring(packed[2])
			return
		end
		local parts = {}
		for i = 2, #packed do
			local v = packed[i]
			if issecretvalue and issecretvalue(v) then
				parts[#parts + 1] = "SECRET"
			elseif type(v) == "table" then
				-- ⚠️ `ipairs` alone printed "table(9) []" for GetActiveDelveTier: nine
				-- entries, none of them array-indexed, so the interesting half was
				-- invisible. Walk pairs and show key=value.
				local flat = {}
				pcall(function()
					for k, e in pairs(v) do
						local ev = e
						if issecretvalue and issecretvalue(ev) then
							ev = "SECRET"
						elseif type(ev) == "table" then
							ev = "{table}"
						end
						flat[#flat + 1] = tostring(k) .. "=" .. tostring(ev)
					end
				end)
				table.sort(flat)
				parts[#parts + 1] = ("table(%d) [%s]"):format(
					#flat, table.concat(flat, ", "))
			else
				parts[#parts + 1] = tostring(v)
			end
		end
		calls[label] = #parts > 0 and table.concat(parts, " · ") or "(no return)"
	end

	if type(C_DelvesUI) == "table" then
		TryCall("HasActiveDelve", C_DelvesUI.HasActiveDelve)
		TryCall("GetActiveDelveTier", C_DelvesUI.GetActiveDelveTier)
		TryCall("IsEligibleForActiveDelveRewards", C_DelvesUI.IsEligibleForActiveDelveRewards)
		TryCall("GetWorldTierDifficultyForActivePlayer",
			C_DelvesUI.GetWorldTierDifficultyForActivePlayer)
		TryCall("IsInLair", C_DelvesUI.IsInLair)
		TryCall("HasActiveLair", C_DelvesUI.HasActiveLair)
		-- The season affix list: the closest thing to "which modifiers exist right now".
		TryCall("GetDelvesAffixSpellsForSeason(season)",
			C_DelvesUI.GetDelvesAffixSpellsForSeason, season)
		TryCall("GetDelvesMinRequiredLevel", C_DelvesUI.GetDelvesMinRequiredLevel)
		-- Entrance strings, asked about the map we are standing on.
		local mid = tonumber(out.playerMapID)
		TryCall("GetDelveEntranceTitleString(map)", C_DelvesUI.GetDelveEntranceTitleString, mid)
		TryCall("GetDelveEntranceDescriptionString(map)",
			C_DelvesUI.GetDelveEntranceDescriptionString, mid)
		TryCall("GetDelveEntranceMapID(map)", C_DelvesUI.GetDelveEntranceMapID, mid)
		TryCall("GetTieredEntrancePDEID(map)", C_DelvesUI.GetTieredEntrancePDEID, mid)
		TryCall("GetTieredEntranceType(map)", C_DelvesUI.GetTieredEntranceType, mid)
		TryCall("GetTieredEntranceOptionalAffixTraitTreeID(map)",
			C_DelvesUI.GetTieredEntranceOptionalAffixTraitTreeID, mid)
		TryCall("GetDelveEntranceBackgroundWidgetSetID(map)",
			C_DelvesUI.GetDelveEntranceBackgroundWidgetSetID, mid)
	end
	out.calls = calls

	-- 7. Does the player currently carry the Bountiful aura? Rob's entrance tooltip named
	-- spell 430253 for it, and the same tooltip says the delve "will remain bountiful
	-- while inside" -- which would make an aura the obvious carrier. Asking by spell id
	-- is also the one aura route that survives combat (see aura-facade notes).
	if C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID then
		local okA, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, 430253)
		if not okA then
			out.bountifulAura = "errored: " .. tostring(aura)
		elseif aura == nil then
			out.bountifulAura = "absent"
		elseif type(aura) == "table" then
			out.bountifulAura = "PRESENT: " .. tostring(aura.name)
		else
			out.bountifulAura = tostring(aura)
		end
	end

	ns.db.dundunScan = out

	local n = type(out.delvesUI) == "table" and #out.delvesUI or 0
	print(("%s Dundun scan saved to ns.db.dundunScan — C_DelvesUI members: %d,"
		.. " zone '%s', delve name %s."):format(
		PREFIX, n, tostring(out.zoneText), tostring(out.activeDelveName)))
	print("  |cffffff00/reload|r now, then it can be read from the file.")
end

--------------------------------------------------------------------------------
-- The Delves tab block
--------------------------------------------------------------------------------
--
-- 🔴 WHY THIS EXISTS ALONGSIDE THE CHAT LINE. Rob, 4 Sep: "dit is best groot voor solo
-- players" — and asked whether MH mentions it anywhere. It did not, beyond a chat line
-- fired on entry and a dev command. That is the gap he named the day before: chat is
-- fine for an event you might miss, but this is also a DECISION taken before the delve
-- ("do I have the keys, is it worth going for"), and the answer to a decision belongs
-- where the decision is made. The Delves tab is that room.
--
-- Built the way the curio advisor is (ns.EnsureDelveCurioPanel), so the Delves panel
-- anchors it like any other block rather than growing a special case.

--- @param parent Frame
--- @return Frame|nil
function ns.EnsureDundunPanel(parent)
	if not parent then
		return nil
	end
	local f = parent._mhDundunPanel
	if f then
		return f
	end

	f = CreateFrame("Frame", nil, parent)
	f:SetHeight(1)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if ns.MHScalableFont then
		f.title:SetFontObject(ns.MHScalableFont("GameFontNormal"))
	end
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	f.title:SetJustifyH("LEFT")

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	if ns.MHScalableFont then
		f.body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	end
	f.body:SetPoint("TOPLEFT", f.title, "BOTTOMLEFT", 0, -4)
	f.body:SetPoint("RIGHT", f, "RIGHT", 0, 0)
	f.body:SetJustifyH("LEFT")
	f.body:SetWordWrap(true)

	f.stand = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	if ns.MHScalableFont then
		f.stand:SetFontObject(ns.MHScalableFont("GameFontNormalSmall"))
	end
	f.stand:SetPoint("TOPLEFT", f.body, "BOTTOMLEFT", 0, -6)
	f.stand:SetPoint("RIGHT", f, "RIGHT", 0, 0)
	f.stand:SetJustifyH("LEFT")
	f.stand:SetWordWrap(true)

	f.macroBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.macroBtn:SetSize(190, 22)
	f.macroBtn:SetPoint("TOPLEFT", f.stand, "BOTTOMLEFT", 0, -8)
	f.macroBtn:SetText(ns:L("DUNDUN_PANEL_MACRO_BTN"))
	f.macroBtn:SetScript("OnClick", function()
		if ns.SelectTab then
			ns.SelectTab("macros")
		end
		-- Land on the World kind, not on whatever the panel last showed. Opening the tab
		-- and asking the player to find the right sub-tab is the thing this button exists
		-- to avoid.
		if ns.MH_OpenMacroType then
			ns.MH_OpenMacroType("world")
		end
	end)
	f.macroBtn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:AddLine(ns:L("DUNDUN_PANEL_MACRO_TT"), 1, 1, 1, true)
		GameTooltip:Show()
	end)
	f.macroBtn:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	parent._mhDundunPanel = f
	return f
end

--- Fill the block with the player's current standing. Safe to call whenever the Delves
--- panel repaints.
function ns.RefreshDundunPanel(parent)
	local f = parent and parent._mhDundunPanel
	if not f then
		return
	end
	local s = ns.GetDundunStatus()

	f.title:SetText("|cff00ffff" .. ns:L("DUNDUN_PANEL_TITLE") .. "|r")
	f.body:SetText(ns:L("DUNDUN_PANEL_BODY"))

	-- The player's own numbers, which is the half no guide can give them.
	local line
	if s.keys == nil then
		line = "|cffff8844" .. ns:L("DUNDUN_PANEL_KEYS_UNKNOWN") .. "|r"
	elseif (s.effectiveKeys or s.keys) >= 2 then
		line = "|cff44ff44" .. ns:L("DUNDUN_PANEL_KEYS_OK_FMT"):format(
			s.keys, s.shards or 0) .. "|r"
	else
		line = "|cffffcc00" .. ns:L("DUNDUN_PANEL_KEYS_SHORT_FMT"):format(
			s.keys, s.shards or 0, s.shardsToNextKey or SHARDS_PER_KEY) .. "|r"
	end
	f.stand:SetText(line)

	local h = f.title:GetStringHeight() + f.body:GetStringHeight()
		+ f.stand:GetStringHeight() + 22 + 22
	f:SetHeight(math.max(h, 1))
end

--- `/mh dundun` — the whole decision, including why it said nothing.
function ns.PrintDundunStatus()
	local s = ns.GetDundunStatus()
	--- `notAsked` distinguishes the third state the first version lacked: a question that
	--- was never put, because an earlier answer made it meaningless. Printing that as
	--- "could not read" is what made Rob's first run misleading.
	local function Show(v, notAsked)
		if v == nil then
			return notAsked and "|cff888888not asked|r" or "|cffff8844could not read|r"
		end
		return tostring(v)
	end
	local outside = (s.inDelve == false)
	print(PREFIX .. " Dundun (Shrine of Abundance)")
	print("  in a delve      : " .. Show(s.inDelve))
	print("  delve name      : " .. Show(s.delveName, outside))
	print("  Bountiful       : " .. Show(s.bountiful, outside))
	print(("  Journey rank    : %s (need %d)"):format(Show(s.rank), DUNDUN_MIN_JOURNEY_RANK))
	print(("  Restored Coffer Keys: %s · shards %s (%d = 1 key on entry)"):format(
		Show(s.keys), Show(s.shards), SHARDS_PER_KEY))
	if s.effectiveKeys then
		print("  keys you can actually field: " .. tostring(s.effectiveKeys))
	end
	print(("  verdict         : |cff88ccff%s|r — %s"):format(
		tostring(s.verdict), tostring(s.reason)))
	print("  What he is: an NPC disguised as a prop (a fake tree), not a delve affix.")
	print("  Unsettled: whether the first find gives a second Coffer or a choice trunk.")
end
