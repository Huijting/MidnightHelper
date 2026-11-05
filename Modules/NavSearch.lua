--[[
	Global navigation search (1.9.0 Phase 1b) — the "front door".

	Turns the existing search bar into a live navigator: type a word and a
	dropdown shows matching destinations (tabs, sub-tabs, tools). Click a row to
	jump straight there; press Enter on a strong (prefix) match to jump as well.
	Weak/keyword-only queries still fall through to the existing deep Codex/Guide
	search in UI.lua (runSearchFromBar), so nothing is lost.

	Builds entirely on existing primitives: ns.SelectTab (with its sub-tab
	aliases), ns:ToggleDelveCoach, and the search EditBox ns.mhSearchEdit. Labels
	reuse the TAB_* / NAV_* / DELVE_COACH_TITLE strings.

	Spec 17 adds two EasyFind-style patterns without changing MH's role as a coach:
	an "@category" filter ("@mount venom", "@delve") and a command palette — the
	user-facing /mh commands, reachable via "@command" or a leading "/". Each entry
	carries an optional `cat` for the filter; entries without one behave as before.
]]

local _, ns = ...

local MAX_RESULTS = 8
--- How many matches we keep behind those eight rows. The dropdown used to throw
--- everything past the eighth away, which was invisible while the palette held 15
--- commands and became a real loss at 33: typing "/" showed the first eight
--- alphabetically and there was no way to reach the rest (Rob, 2026-07-22).
local MAX_MATCHES = 60
local ROW_H = 20

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- string.lower only knows A-Z, so a Russian label "Вылазки" never matched a typed "вылазки", and a German
--- "Übersicht" never matched "übersicht" (11 Oct 2026, with the ruRU pack). This also folds the two-byte
--- UTF-8 capitals we ship: Latin-1 À-Þ (not ×) and Cyrillic А-Я plus Ё.
local function ULower(s)
	s = s:lower()
	s = s:gsub("\195([\128-\158])", function(c)
		local b = c:byte()
		if b == 151 then return "\195" .. c end -- × stays
		return "\195" .. string.char(b + 32)
	end)
	s = s:gsub("\208([\144-\159])", function(c) return "\208" .. string.char(c:byte() + 32) end) -- А-П
	s = s:gsub("\208([\160-\175])", function(c) return "\209" .. string.char(c:byte() - 32) end) -- Р-Я
	s = s:gsub("\208\129", "\209\145") -- Ё
	return s
end

local function OpenTab(id)
	if ns.ShowMainUI then
		ns:ShowMainUI()
	end
	if ns.SelectTab then
		ns.SelectTab(id)
	end
end

-- Three tiers, so a destination never loses its slot to a mob with a similar name.
-- Typing "rares" must put the Rares TAB above fifteen rares, and typing "ritual" must
-- put "take me to the active site" above the tab that merely describes it.
local TIER_ACTION = 0 -- does the thing (routes you somewhere) rather than showing it
local TIER_NAV = 1 -- tabs, tools, codex pages
local TIER_CONTENT = 2 -- mounts, rares, treasures, bosses

-- The active ritual site is found by walking every site's area POIs — far too much work
-- to repeat on each keystroke of a rebuilt index. It rotates once a week, so a ten
-- second memo is still absurdly fresh.
local ritualMemo = { at = -100, site = nil }
local function ActiveRitualSite()
	if not ns.GetActiveRitualSite then
		return nil
	end
	local now = (GetTime and GetTime()) or 0
	if (now - ritualMemo.at) > 10 then
		ritualMemo.at = now
		local ok, site = pcall(ns.GetActiveRitualSite)
		ritualMemo.site = (ok and site) or nil
	end
	return ritualMemo.site
end

-- A place's name and its continent, from the client. Asked once per map: the index is rebuilt on every keystroke and
-- the names cannot change during a session. A map the client does not know (yet) is asked again next time.
local placeText = {}
-- Spec + class name per play card ("Retribution Paladin"), asked once like the place names; false = the client said no.
local specText = {}
local function PlaceText(m)
	local t = placeText[m]
	if not t then
		local T = ns.Travel
		local name = T and T.MapName and T.MapName(m)
		if not name or name == "" then
			return nil
		end
		local cont = T.Continent and T.Continent(m)
		local where = cont and cont ~= m and T.MapName(cont) or nil
		t = { name, where }
		placeText[m] = t
	end
	return t[1], t[2]
end

-- Rebuilt per query (a few hundred entries of pure string work) so labels follow the
-- current locale. Nothing here may call an expensive API: this runs on every keystroke.
local function BuildNavIndex()
	local idx = {}
	--- @param context string|nil dim text after the label ("Eversong Woods"), also searchable
	--- @param cat string|nil category for the "@cat" filter (tab/mount/rare/treasure/boss/tool/codex/command/place)
	local function add(label, keys, go, tier, context, cat)
		if type(label) ~= "string" or label == "" then
			return
		end
		idx[#idx + 1] = {
			label = label,
			context = context,
			lower = ULower(label),
			keys = ULower((keys or "") .. " " .. (context or "")),
			go = go,
			tier = tier or TIER_NAV,
			cat = cat,
		}
	end
	local function tab(labelKey, id, keys)
		add(L(labelKey), keys, function()
			OpenTab(id)
		end, nil, nil, "tab")
	end

	-- Top-level tabs.
	tab("TAB_START_HERE", "starthere", "begin new player intro start")
	tab("TAB_HOME", "home", "this week dashboard overview")
	tab("TAB_CODEX", "codex", "handbook wiki guides articles")
	-- "delves" itself is a keyword since 11 Oct 2026: the search tooltip in every pack uses it as its example, and
	-- in de/fr/es/pt/it/ru the tab label now says the client word, so the English word only matched in English.
	tab("TAB_DELVES", "delves", "delves vault great vault delver")
	tab("TAB_DUNGEONS", "dungeons", "mythic plus boss coach")
	tab("TAB_RARES", "rares", "rare spawn")
	tab("TAB_ACHIEVEMENTS", "achievements", "achievement treasure treasures collectible route lore hunter")
	tab("TAB_MOUNTS", "mounts", "mount mounts collectible collection sporeglider hawkstrider renown")
	tab("TAB_RAIDS", "raids", "raid raids boss coach encounter voidspire dreamrift queldanas")
	tab("TAB_WORLD", "world", "void ritual sites assault showdown world boss")
	tab("TAB_EVENTS", "events", "event calendar schedule")
	tab("TAB_ACCOUNT_SNAPSHOT", "account", "alts alt overview snapshot")
	tab("TAB_DELVE_LOG", "delvelog", "history log runs ritual")
	tab("TAB_ENCHANTS", "enchants", "gear enchant")
	tab("TAB_TIER", "tier", "tier set")
	tab("TAB_OMNIUM", "omnium", "folio omnium")
	tab("TAB_SMC", "smcguide", "smc suffused mote city")
	tab("TAB_CURRENCY", "currency", "currencies caps gold")
	tab("TAB_GUIDE", "guide", "leveling layout keybinds")
	-- 3 Nov 2026 (Rob: "alles kunnen vinden"): a top-level tab (UI.lua tab list) that was never in this list.
	tab("TAB_TRADINGPOST", "tradingpost", "trading post tender traders monthly rewards cosmetics")
	--- ⚠️ "command", "commands" and "slash" were NOT in these keywords, and the full
	--- command list lives at the bottom of this tab. Rob, 18 aug, after an hour spent
	--- making commands discoverable: "maar waar vind ik die, vroeg ik met blozende
	--- wangen". The list of commands was the one thing you could not search for.
	tab("TAB_TOOLSLAUNCH", "toolslaunch",
		"tools launchpad pop-out windows launcher command commands slash /mh chat")
	tab("TAB_TOOLBOX", "toolbox", "tools utilities")
	tab("TAB_ADDONS", "addons", "addon panel")
	tab("TAB_SETTINGS", "settings", "options preferences text size font language scale")
	-- 4.0: the show/hide list, found by what a player wants to do with a screen.
	tab("SETTINGS_SCREENS_TITLE", "screens", "screens hide hidden show visible choose cards rooms tabs")
	tab("SET_ALL_TITLE", "allsettings", "settings options preferences all toggles language combat alerts dungeon arrow window vault advanced")

	--- The pages INSIDE the Addons tab, which were not searchable at all.
	---
	--- Rob typed "details" into the search bar and got nothing, then tried "platynator"
	--- with the same result — and he built those pages. If the person who made them
	--- cannot find them, nobody can. They were reachable only by knowing that the Addons
	--- tab exists and then clicking through its sub-tabs.
	---
	--- Read from the registry rather than listed here, so a page added later is
	--- searchable the moment it registers. That is the same rule the command list
	--- follows, for the same reason: a second hand-kept list drifts.
	for _, id in ipairs(ns._mhAddonSubTabOrder or {}) do
		local def = ns._mhAddonSubTabById and ns._mhAddonSubTabById[id]
		if def and def.label then
			add(def.label, "addon profile import string " .. id .. " " .. def.label,
				function()
					OpenTab("addons")
					if ns.SelectAddonSubTab then
						ns.SelectAddonSubTab(id)
					end
				end, nil, L("TAB_ADDONS"), "tab")
		end
	end

	-- Sub-tabs (resolved through SelectTab's legacy aliases).
	tab("TAB_PROFESSIONS", "professions", "profession alchemy herbalism work orders crafting knowledge points")
	-- The profession course is labelled "Course (101)" and sits inside Professions, so
	-- searching "academy" only ever found the Role Academy. Indexed under its own name
	-- plus every profession, since a beginner searches for "enchanting", not "course".
	add(L("PROFHUB_TAB_COURSE"),
		"academy profession course 101 basics learn teach knowledge enchanting alchemy tailoring "
			.. "leatherworking blacksmithing engineering inscription jewelcrafting herbalism mining skinning",
		function()
			OpenTab("profacademy")
		end, nil, L("NAV_WHERE_PROFACADEMY"), "tab")
	-- The hub's other two inner tabs by their own names (search inventory 3 Nov 2026; only Course was findable).
	-- "professions" lands on Treasures, "profoverview" on Overview (UI.lua SelectTab aliases).
	add(L("PROFHUB_TAB_OVERVIEW"), "profession professions overview knowledge points kp spend spec specialization",
		function()
			OpenTab("profoverview")
		end, nil, L("TAB_PROFESSIONS"), "tab")
	add(L("PROFHUB_TAB_TREASURES"), "profession professions treasures treasure books knowledge weekly",
		function()
			OpenTab("professions")
		end, nil, L("TAB_PROFESSIONS"), "tab")

	--- 🔴 THE GUIDED ADVISOR WAS REACHABLE FROM EXACTLY ONE BUTTON, AND FINDABLE FROM NOWHERE.
	--- Rob, 8 sep 2026, minutes after we wrote where Azeroot grows: *"waar? en als ik op azeroot
	--- zoek vind ik niks."* Both halves were true. `MH_OpenProfessionGuide` had a single caller
	--- (a button inside the Academy), no slash command, and no line in this file — so the only
	--- way to the answer was to already know where it lived.
	---
	--- 📌 THIS IS THE SAME BUG AS THE ONE FIXED DIRECTLY BELOW, one feature over. The comment
	--- there says a beginner searches for the word they HAVE, not for the name of the screen —
	--- and then the advisor shipped with neither.
	---
	--- ⚠️ THE KEYWORDS ARE THE STEP TEXT ITSELF, not a hand-kept list. A material named in a
	--- step becomes searchable the moment it is written, which is the only version of this that
	--- cannot drift out of date — and drifting lists are what this file keeps being fixed for.
	--- English only: the search box matches raw text and the words a player types are the ones
	--- Blizzard uses.
	if type(ns.PROF_GUIDES) == "table" then
		for skillLine, g in pairs(ns.PROF_GUIDES) do
			if type(g) == "table" and type(g.profName) == "table" and g.profName.en then
				local words = { "profession guide levelling leveling", g.profName.en }
				if type(g.middleSteps) == "table" then
					for _, m in ipairs(g.middleSteps) do
						if type(m) == "table" then
							if type(m.title) == "table" and m.title.en then
								words[#words + 1] = m.title.en
							end
							if type(m.body) == "table" and m.body.en then
								words[#words + 1] = m.body.en
							end
						end
					end
				end
				--- ⚠️ `PGUIDE_LAUNCH_BTN` ("Guided mode"), NOT `PROFHUB_TAB_COURSE`. The first
				--- version of this label said "Course (101) — Herbalism" for something that is
				--- the ADVISOR and not the course; Rob's screenshot caught it within an hour of
				--- shipping. Two different screens, and the search result named the wrong one —
				--- in the very index that exists to stop people looking in the wrong place.
				--- 📌 It also reads better: the window this opens is titled "Guided mode — %s"
				--- (`PGUIDE_HEADER_TAG_FMT`), so the result now matches what appears.
				local sl = skillLine
				add(("%s — %s"):format(L("PGUIDE_LAUNCH_BTN"), g.profName.en),
					table.concat(words, " "):lower(),
					--- ⚠️ THE QUERY IS PASSED ON, and that is the whole fix of 9 sep. The
					--- guide's own job is to show the step you are ON, which is right for
					--- levelling and wrong for looking something up -- Rob's Herbalism is
					--- past skill 30, so the step naming Azeroot slid out from under him
					--- twice. With a word to go on it lands on the step that matched.
					function(query)
						if ns.MH_OpenProfessionGuide then
							ns.MH_OpenProfessionGuide(sl, query)
						end
					end, nil, L("NAV_WHERE_PROFACADEMY"), "tab")
			end
		end
	end

	--- Every course CHAPTER, not just the course. The whole thing was one entry,
	--- so the only findable word was "course" — a beginner searching the word they
	--- actually have ("concentration", "multicraft", "quality") got nothing, and
	--- the course is exactly where the answer was. Same failure as the Codex
	--- articles above, and the same fix.
	---
	--- Read from the chapter registry rather than a hand-kept list here, so a
	--- chapter added later is searchable the moment it registers. `searchKeys`
	--- carries the words a reader types before they know the chapter's own title.
	if type(ns.PROF_ACADEMY) == "table" and type(ns.PROF_ACADEMY.chapters) == "table" then
		local courseLabel = L("PROFHUB_TAB_COURSE")
		for _, ch in ipairs(ns.PROF_ACADEMY.chapters) do
			if type(ch) == "table" and ch.key and ch.titleKey then
				local chKey = ch.key
				add(courseLabel .. ": " .. L(ch.titleKey),
					"profession course " .. chKey .. " " .. (ch.searchKeys or ""),
					function()
						OpenTab("profacademy")
						if ns.MH_ScrollProfAcademyToChapter then
							ns.MH_ScrollProfAcademyToChapter(chKey)
						end
					end, nil, L("NAV_WHERE_PROFACADEMY"), "tab")
			end
		end
	end

	--- ✅ 10 Sep 2026 (Spec 33 §2a). This line was the ONLY way into the Macros tab, and its
	--- three words are not what anyone with a problem types. Rob could not find his own pet
	--- macro. The tab now answers to the words from the spec, and every macro for YOUR class and
	--- spec - plus the world macros - is a hit of its own that opens on that very macro.
	tab("TAB_MACROS", "macros", "interrupt macro macros kick mouseover focus cursor pet taunt trap"
		.. " cancelaura misdirection dispel heal muisaanwijzer channel")
	do
		local function addMacros(list, typeId)
			for i, m in ipairs(type(list) == "table" and list or {}) do
				local idx = i
				add(m.name, (m.id or "") .. " macro " .. (m.descEn or "") .. " " .. (m.descNl or ""),
					function()
						OpenTab("macros")
						if ns.MH_OpenMacro then
							ns.MH_OpenMacro(typeId, idx)
						end
					end, TIER_CONTENT, L("TAB_MACROS"), "macro")
			end
		end
		addMacros(ns.MH_GetUtilityMacroList and (ns.MH_GetUtilityMacroList()), "utility")
		addMacros(ns.WORLD_MACROS, "world")
	end
	-- "party targets" is what a player calls it; "focus" and "assist" are what they
	-- search for when they do not know the name. Additive, like every keyword here.
	tab("TAB_SETTINGS", "settings", "party target targets focus assist who is attacking")
	tab("TAB_CONSUMABLES", "consumables", "flask rune food buff oil")
	-- 7 Oct 2026 (role-switch review): "tanking", "healing", "how to tank" and "healer" did not find it, and
	-- "healer"/"healing" led to /mh healcds, which tells a DPS player only to switch spec.
	tab("TAB_ACADEMY", "academy", "role tank heal academy tanking healing healer how to tank how to heal "
		.. "learn to tank learn to heal switch role aggro taunt threat leren tanken leren healen healer worden")
	-- Search keywords are ADDITIVE, never renamed. The visible text dropped the season
	-- name so it survives a flip, but "dawncrest" is the word a Season 1 player reads
	-- in their own currency tab, and "mistcrest" is what a Season 2 player will read.
	-- Both must find this page; a rename here would have made it unfindable by the
	-- only name the player actually knows.
	tab("TAB_REFERENCE", "reference", "basics crest crests dawncrest mistcrest upgrade")

	-- Codex categories (open the Codex on that category page).
	if type(ns.CODEX_CATEGORIES) == "table" then
		local codexLabel = L("TAB_CODEX")
		for _, cat in ipairs(ns.CODEX_CATEGORIES) do
			if type(cat) == "table" and cat.id and cat.labelKey then
				local catId = cat.id
				add(codexLabel .. ": " .. L(cat.labelKey), "codex " .. catId, function()
					if ns.SetActiveCodexCategory then
						ns.SetActiveCodexCategory(catId)
					end
					OpenTab("codex")
				end, nil, nil, "codex")
			end
		end
	end

	--- Codex articles.
	---
	--- 🔴 THIS USED TO LAND ON THE CATEGORY PAGE, and the comment above it said so plainly
	--- ("each lands on its category page") without anyone reading it as the bug it was. A
	--- category renders every one of its articles in one scroll and then resets the scroll
	--- to the top, so searching an article near the bottom of a busy shelf opened the right
	--- page and showed you something else. Same shape as the profession guide directly
	--- above; found by asking Rob's question of every entry in this file rather than only
	--- of the one that broke.
	if type(ns.CODEX_ARTICLES) == "table" then
		for _, art in ipairs(ns.CODEX_ARTICLES) do
			if type(art) == "table" and art.titleKey then
				local cat = art.category
				local artId = art.id
				-- searchKeys matters more than it looks. Without it an article is
				-- findable only by words already in its own title, which is exactly
				-- the words someone who has not read it will not type. "When a season
				-- ends" was invisible to a search for "reset" (Rob, 2026-07-27).
				add(L(art.titleKey), "codex article " .. (artId or "") .. " " .. (art.searchKeys or ""), function()
					if cat and ns.SetActiveCodexCategory then
						ns.SetActiveCodexCategory(cat)
					end
					OpenTab("codex")
					-- After OpenTab, so the panel exists and has been laid out once.
					if artId and ns.MH_ScrollCodexToArticle then
						ns.MH_ScrollCodexToArticle(artId)
					end
				end, nil, nil, "codex")
			end
		end
	end

	-- Tools (floating helper windows; existing toggles).
	-- Side panels. These are PASSIVE: they appear beside a Blizzard window and are
	-- never opened from here, so each entry carries a context line saying WHERE it
	-- shows up. Without that the feature is unfindable -- you only meet it by
	-- happening to open the right Blizzard window. Clicking runs the closest related
	-- MH report rather than pretending to summon the panel.
	add(L("NAV_PANEL_CHARACTER"), "side panel character sheet paperdoll gear enchant socket tier upgrade ceiling", function()
		if ns.PrintGearEnchantCheck then
			ns.PrintGearEnchantCheck()
		end
	end, nil, L("NAV_PANEL_WHERE_CHARACTER"), "tool")
	add(L("NAV_PANEL_KEYSTONE"), "side panel keystone mythic plus great vault dungeon row item level", function()
		if ns.PrintMythicGain then
			ns.PrintMythicGain()
		end
	end, nil, L("NAV_PANEL_WHERE_KEYSTONE"), "tool")
	add(L("NAV_PANEL_JOURNAL"), "side panel adventure guide encounter journal boss tips role", function()
		if ns.ShowDungeonBossWindow then
			ns.ShowDungeonBossWindow()
		end
	end, nil, L("NAV_PANEL_WHERE_JOURNAL"), "tool")
	add(L("NAV_PANEL_MOUNTS"), "side panel mount journal collection wishlist starred", function()
		if ns.SelectTab then
			ns.SelectTab("mounts")
		end
	end, nil, L("NAV_PANEL_WHERE_MOUNTS"), "tool")

	add(L("DELVE_COACH_TITLE"), "delve coach tactics boss", function()
		if ns.ToggleDelveCoach then
			ns:ToggleDelveCoach()
		end
	end, nil, nil, "tool")
	add(L("NAV_TOOL_BOARD"), "consumable board flask rune food buffs ready", function()
		if ns.ShowConsumableBoard then
			ns.ShowConsumableBoard()
		end
	end, nil, nil, "tool")
	add(L("GROUPBUFF_HEADER"), "group buffs raid missing intellect stamina fortitude battle shout", function()
		if ns.PrintGroupBuffs then
			ns.PrintGroupBuffs()
		end
	end, nil, nil, "tool")
	add(L("PAWN_TITLE"), "pawn stat weights export scale secondary", function()
		if ns.ShowPawnExport then
			ns.ShowPawnExport()
		end
	end, nil, nil, "tool")
	add(L("MOUNTWISH_HEADER"), "mount wishlist star collect chase favourite", function()
		if ns.PrintMountWishlist then
			ns.PrintMountWishlist()
		end
	end, nil, nil, "mount")
	add(L("NAV_TOOL_BOSSWIN"), "dungeon boss window tactics floating", function()
		if ns.ToggleDungeonBossWindow then
			ns.ToggleDungeonBossWindow()
		end
	end, nil, nil, "tool")
	add(L("NAV_TOOL_CURIOS"), "curios advisor delve companion role", function()
		if ns.ToggleDelveCuriosPopup then
			ns:ToggleDelveCuriosPopup()
		end
	end, nil, nil, "tool")
	-- Each curio by the name the client gives it (search inventory 3 Nov 2026). A name the item cache does not have
	-- yet is skipped this keystroke and asked for, so it is there the next time.
	if ns.DELVE_CURIO_ITEM_IDS and C_Item and C_Item.GetItemNameByID then
		local curiosLabel = L("NAV_TOOL_CURIOS")
		for itemID in pairs(ns.DELVE_CURIO_ITEM_IDS) do
			local ok, name = pcall(C_Item.GetItemNameByID, itemID)
			if ok and name and name ~= "" then
				add(name, "curio curios delve companion valeera combat utility", function()
					if ns.ToggleDelveCuriosPopup then
						ns:ToggleDelveCuriosPopup()
					end
				end, TIER_CONTENT, curiosLabel, "tool")
			elseif C_Item.RequestLoadItemDataByID then
				pcall(C_Item.RequestLoadItemDataByID, itemID)
			end
		end
	end
	add(L("NAV_TOOL_RITUALBOSS"), "ritual boss coach window", function()
		if ns.ToggleRitualBossWindow then
			ns.ToggleRitualBossWindow()
		end
	end, nil, nil, "tool")

	-- Bosses, from the dungeon roster and the custom coach entries (raids, ritual
	-- bosses, Sporefall). Typing a boss name opens the boss window straight on that
	-- boss, where its numbered steps and the tank / healer / dps lines already live.
	-- Only bosses we actually wrote steps for are indexed, so a hit never lands on an
	-- empty page. Names resolve from the Encounter Journal via each boss's encounterID,
	-- so they follow the player's language — the index is rebuilt per query, by which
	-- time the EJ data is warm. Keywords are the instance name only: adding "boss" here
	-- would let the eight result slots crowd out the boss-window tool itself.
	local function addBosses(entry)
		if type(entry) ~= "table" or not entry.key or type(entry.bosses) ~= "table" then
			return
		end
		local entryName = (ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(entry)) or entry.name or ""
		for i, b in ipairs(entry.bosses) do
			if b.key and ns.GetDungeonBossTips and ns.GetDungeonBossTips(entry.key, b.key) then
				local bossName = (ns.GetDungeonBossName and ns.GetDungeonBossName(b, entry, i)) or b.name
				local bossKey = b.key
				add(bossName, "", function()
					if ns.ShowBossWindowForEntry then
						ns.ShowBossWindowForEntry(entry, bossKey)
					end
				end, TIER_CONTENT, entryName, "boss")
			end
		end
	end

	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		addBosses(d)
	end
	for _, e in pairs(ns.CUSTOM_BOSS_ENTRIES or {}) do
		addBosses(e)
	end

	-- Delves, by name and by boss (Rob, 17 Sep 2026: a dungeon found by search opens its boss
	-- window, a delve found nothing). Both open the Delve Coach as a preview, the same call the
	-- coach's own picker makes; a boss hit opens on that boss. Boss labels are the showcase's
	-- English names, which is what the coach itself shows.
	if ns.ShowDelveCoach then
		local coachTitle = L("DELVE_COACH_TITLE")
		for _, entry in ipairs(ns.DELVE_TIP_ENTRIES or {}) do
			local entryId = entry.id
			local delveName = (ns.GetDelveTipDisplayName and ns:GetDelveTipDisplayName(entry)) or entry.rosterName
			if entryId and delveName then
				add(delveName, "delve tips coach", function()
					ns:ShowDelveCoach(entryId, { preview = true })
				end, TIER_CONTENT, coachTitle, "boss")
				local bosses = ns.GetDelveBossShowcase and ns:GetDelveBossShowcase(entryId)
				for i, boss in ipairs(bosses or {}) do
					local bossIndex = i
					-- A delve of rooms (the Labyrinth) opens the small boss card (Rob, 20 Oct 2026, standing in front of
					-- Cynthra: "een venster wat we kunnen openen ... gewoon kunnen aanklikken"); the coach stays one click away.
					local roomDelve = entry.noFinalBossPrompt
					add(boss.label, roomDelve and "room boss labyrinth" or "", function()
						if roomDelve and ns.ShowDelveBossCard and ns.ShowDelveBossCard(entryId, bossIndex) then
							return
						end
						ns:ShowDelveCoach(entryId, { preview = true, bossIndex = bossIndex })
					end, TIER_CONTENT, delveName, "boss")
				end
			end
		end
	end

	-- Actions. Typing "ritual" should start the arrow, not open a page about rituals —
	-- that is the whole promise of this addon. Both entries mirror the buttons the Home
	-- dashboard already shows, so there is one truth about where they send you.
	-- Each label LEADS with the word a player types, because Enter only jumps on a
	-- label-prefix match: "ritual" must hit "Ritual Site: …", not "Route to …".
	local ritualSite = ActiveRitualSite()
	if ritualSite and ns.RouteRitualSite and ritualSite.mapID and ritualSite.x and ritualSite.y then
		local zone = ns.RitualSiteZoneName and ns.RitualSiteZoneName(ritualSite) or nil
		local hint = L("NAV_ACTION_TAKE_ME")
		add(L("NAV_ACTION_RITUAL_FMT"):format(ritualSite.name), "ritual site obelisk active weekly route", function()
			ns.RouteRitualSite(ritualSite)
		end, TIER_ACTION, zone and (zone .. " — " .. hint) or hint)
	end
	-- The Void assault has no single waypoint (its strikes are marked one at a time), so
	-- this routes to the shared staging hub — exactly what the Home button does. The
	-- context line says "hub" out loud, so nobody expects to land on a strike.
	if ns.RouteVoidHub and ns.GetActiveVoidAssaultZoneName then
		local voidZone = ns.GetActiveVoidAssaultZoneName()
		if voidZone then
			add(L("NAV_ACTION_VOID_FMT"):format(voidZone), "void assault hub staging active weekly route", function()
				ns.RouteVoidHub()
			end, TIER_ACTION, L("HOME_VOID_HUB_BTN"))
		end
	end

	-- Places (Rob, 16 Oct 2026: "zoeken in MH naar bv dalaran"): every city or zone a portal from the capital or
	-- Silvermoon leads to, hub after hub (Modules/Travel/TravelPlaces.lua). A hit starts the route there, the way
	-- home first. Names and continents come from the client, so they are in the player's language and two places
	-- with one name tell themselves apart by the continent behind them.
	if ns.Travel and ns.Travel.Places and ns.Travel.GoToPlace then
		local hint = L("NAV_ACTION_TAKE_ME")
		-- One row per name + continent. Rob's screenshot (16 Oct 2026): "Dazar'alor" twice — the hall the portal lands
		-- in (1163) and the city (1165) share a name. Places() lists the shortest chain first, so that one stays.
		local seenPlace = {}
		for _, place in ipairs(ns.Travel.Places()) do
			local name, where = PlaceText(place.map)
			local id = name and (name .. "|" .. tostring(where))
			if id and not seenPlace[id] then
				seenPlace[id] = true
				local p = place
				add(name, "place city zone portal travel go to route", function()
					ns.Travel.GoToPlace(p)
				end, TIER_ACTION, where and (where .. " — " .. hint) or hint, "place")
			end
		end
	end

	-- Doors: every delve, dungeon and raid we know the entrance of (Rob, 17 Oct 2026, typing "laby": "niet even een snelle
	-- knop … naar de labyrinth zelf, maar ook niet naar andere delves dungeons of raids"). A hit starts the same route the
	-- Delves tab / boss window start (AddSmartTomTomWay: way home, portals, the door). The dim text is the entrance's own
	-- zone from the client, so it needs no new string. The English name is a keyword, so it works on every client.
	if ns.AddSmartTomTomWay then
		local hint = L("NAV_ACTION_TAKE_ME")
		local seenDoor = {}
		local function addDoor(name, english, kind, map, x, y, go)
			if not (name and map and x and y) then
				return
			end
			local id = name .. "|" .. tostring(map)
			if seenDoor[id] then
				return
			end
			seenDoor[id] = true
			local zone = PlaceText(map)
			add(name, kind .. " entrance door go to route " .. (english or ""), go, TIER_ACTION,
				zone and (zone .. " — " .. hint) or hint, "place")
		end
		-- Delve names in the player's language where the Delve Coach has one (same lookup as its rows above).
		local delveLocal = {}
		for _, entry in ipairs(ns.DELVE_TIP_ENTRIES or {}) do
			if entry.rosterName and ns.GetDelveTipDisplayName then
				delveLocal[entry.rosterName] = ns:GetDelveTipDisplayName(entry)
			end
		end
		for _, row in ipairs(ns.MIDNIGHT_DELVES or {}) do
			local english, map, x, y = row[5], row[2], row[3], row[4]
			if not row.pinOnly and english then
				local name = delveLocal[english] or english
				addDoor(name, english, "delve", map, x, y, function()
					if ns.MH_TomTomClearAll then
						ns.MH_TomTomClearAll()
					end
					ns.AddSmartTomTomWay(map, x, y, name)
				end)
			end
		end
		local function addInstance(d, kind)
			local e = type(d) == "table" and d.entrance
			if e and e.mapID and ns.RouteDungeonEntrance then
				local name = (ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(d)) or d.name
				addDoor(name, d.name, kind, e.mapID, e.x, e.y, function()
					ns.RouteDungeonEntrance(d)
				end)
			end
		end
		for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
			addInstance(d, "dungeon")
		end
		for _, e in pairs(ns.CUSTOM_BOSS_ENTRIES or {}) do
			addInstance(e, "raid")
		end
	end

	-- The five Labyrinth Hexmask spots (Rob's run, 19 Oct 2026: he typed "hex" at 10:30 and got two mounts and a boss).
	-- The room name is the label; "hexmask", "mask", "locked door" and "keeper" are keywords on every client.
	if ns.LAB_HEXMASK_SPOTS and ns.SetMapWaypoint then
		local hint = "Hexmask — " .. L("NAV_ACTION_TAKE_ME")
		for _, s in ipairs(ns.LAB_HEXMASK_SPOTS) do
			local spot = s
			add(spot.room, "hexmask hexmasks hex mask masks locked door keeper key labyrinth kindo'jan", function()
				ns:SetMapWaypoint(2647, spot.x, spot.y, spot.room)
			end, TIER_ACTION, hint, "place")
		end
	end

	-- The Silvermoon city guide's pins (Rob, 3 Nov 2026: "als ik AH zoek in MH krijg ik niet de Auction House ?!" ->
	-- "in principe moeten we alles kunnen vinden wat wij in onze Midnight Helper hebben staan"). The rows are the
	-- ones UI.lua builds for the old chat-question search (navKeys: category, label, own description, id); a hit does what a
	-- click on the pin does. Dungeon and raid entrances are left out: the doors above already have them. The short
	-- words below are what players type; "ah" only matches as a whole word.
	if ns._mhSMCGuideSearchRows and ns.RouteSMCPin then
		local SMC_WORDS = {
			ah = "ah auction auctioneer", horde_ah = "ah auction auctioneer",
			bmah = "black market auction house", bank = "bank vault warband", horde_bank = "bank vault warband",
			mailbox = "mail post letter", inn_cooking = "inn innkeeper hearth hearthstone rest cooking",
			horde_inn = "inn innkeeper hearth hearthstone rest", transmog = "transmog transmogrify appearance",
			triam_dawnsetter = "transmog cosmetics", creation_catalyst = "catalyst tier set",
			horde_creation_catalyst = "catalyst tier set", item_upgrades = "upgrade item level ilvl",
			crest_exchange = "crest crests", crafting_orders = "crafting orders craft", prof_reset = "profession respec reset",
			portals = "portal portals mage teleport", mplus_teleports = "mplus mythic teleport teleports",
			training_dummies = "dummy dummies target practice", pvp_hub = "pvp honor conquest",
			delves_hq = "delve delves", valeera_delves = "delve delves companion",
		}
		-- 5 Nov 2026 (Rob: "Alles"): the labels are English, so "Auktionshaus" on a German client found nothing.
		-- These are Blizzard's own GlobalStrings for the same thing, which the client already has in the
		-- player's language (keys and Flags=1 measured on wago 12.1.5.70783, all 8 locales). Search words
		-- only; the label on screen does not change. A missing global adds nothing.
		local CLIENT_GLOBALS = {
			ah = { "BUTTON_LAG_AUCTIONHOUSE", "MINIMAP_TRACKING_AUCTIONEER" },
			horde_ah = { "BUTTON_LAG_AUCTIONHOUSE", "MINIMAP_TRACKING_AUCTIONEER" },
			bmah = { "BLACK_MARKET_AUCTION_HOUSE" },
			bank = { "BANK", "MINIMAP_TRACKING_BANKER", "ACCOUNT_BANK_PANEL_TITLE", "DELVES_GREAT_VAULT_LABEL" },
			horde_bank = { "BANK", "MINIMAP_TRACKING_BANKER", "ACCOUNT_BANK_PANEL_TITLE", "DELVES_GREAT_VAULT_LABEL" },
			mailbox = { "MINIMAP_TRACKING_MAILBOX" },
			inn_cooking = { "MINIMAP_TRACKING_INNKEEPER", "PROFESSIONS_COOKING" },
			horde_inn = { "MINIMAP_TRACKING_INNKEEPER" },
			trading_post = { "TRANSMOG_SOURCE_7" },
			transmog = { "MINIMAP_TRACKING_TRANSMOGRIFIER", "PERKS_VENDOR_CATEGORY_TRANSMOG" },
			triam_dawnsetter = { "MINIMAP_TRACKING_TRANSMOGRIFIER", "PERKS_VENDOR_CATEGORY_TRANSMOG" },
			crafting_orders = { "PROFESSIONS_CRAFTING_ORDERS_TAB_NAME" },
			item_upgrades = { "ITEM_UPGRADE", "MINIMAP_TRACKING_ITEM_UPGRADE_MASTER" },
			fishing = { "PROFESSIONS_FISHING" },
		}
		-- Profession pins: the client's own profession name. SkillLine IDs measured on wago 12.1.5.70783;
		-- GetTradeSkillDisplayName is a candidate (HandyNotes uses it), not tested for unlearned professions.
		local PIN_SKILLLINE = {
			alchemy = 171, blacksmithing = 164, enchanting = 333, engineering = 202, inscription = 773,
			jewelcrafting = 755, leatherworking = 165, tailoring = 197, herbalism_trainer = 182,
			mining_trainer = 186, skinning_trainer = 393, fishing = 356,
		}
		local function ClientWords(p)
			local out = {}
			for _, key in ipairs(CLIENT_GLOBALS[p.id] or {}) do
				local s = _G[key]
				if type(s) == "string" and s ~= "" then
					out[#out + 1] = s
				end
			end
			local sl = PIN_SKILLLINE[p.id]
			if sl and C_TradeSkillUI and C_TradeSkillUI.GetTradeSkillDisplayName then
				local ok, n = pcall(C_TradeSkillUI.GetTradeSkillDisplayName, sl)
				if ok and type(n) == "string" and n ~= "" then
					out[#out + 1] = n
				end
			end
			if p.trainer or sl then
				local t = _G.MINIMAP_TRACKING_TRAINER_PROFESSION
				if type(t) == "string" then
					out[#out + 1] = t
				end
			end
			-- Our own words in the player's language for pins Blizzard has no short string for.
			local own = L("SMC_SEARCH_" .. string.upper(p.id))
			if type(own) == "string" and own ~= "SMC_SEARCH_" .. string.upper(p.id) then
				out[#out + 1] = own
			end
			return string.lower(table.concat(out, " "))
		end
		local hint = L("TAB_SMC") .. " — " .. L("NAV_ACTION_TAKE_ME")
		local seenPin = {}
		for _, row in ipairs(ns._mhSMCGuideSearchRows) do
			local p = row.point
			if type(p) == "table" and p.label and not p.instance and not p._mhWorldBossRoute and not p._mhDelvesWorldBoss
				and not seenPin[p] then
				seenPin[p] = true
				local words = (SMC_WORDS[p.id] or "") .. (p.trainer and " trainer profession" or "") .. " " .. ClientWords(p)
				add(p.label, "silvermoon city " .. words .. " " .. (row.navKeys or ""), function()
					ns.RouteSMCPin(p)
				end, TIER_ACTION, hint, "place")
			end
		end
	end

	-- The search inventory of 3 Nov 2026 (Rob: "Ja, top 4"): things MH shows that search could not find.
	-- "How you play" cards, one row per spec. Spec and class name from the client (its language), asked once.
	if ns.GetPlayCardSpecs and ns.ShowPlayCardWindow then
		local cardsLabel = L("PLAYCARD_BTN")
		for _, specID in ipairs(ns.GetPlayCardSpecs()) do
			local t = specText[specID]
			if t == nil and GetSpecializationInfoByID then
				local ok, _, name, _, _, _, classFile, className = pcall(GetSpecializationInfoByID, specID)
				t = (ok and name and name ~= "") and { name .. (className and (" " .. className) or ""), classFile or "" } or false
				specText[specID] = t
			end
			if t then
				local id = specID
				add(t[1], "how to play rotation spec card cards quiz why priority buttons playcard " .. t[2]:lower(),
					function()
						ns.ShowPlayCardWindow(id)
					end, TIER_NAV, cardsLabel, "tool")
			end
		end
	end

	-- The four world bosses. A hit routes there, like the world boss row on the Delves tab.
	if ns.WORLD_BOSSES and ns.RouteToWorldBoss then
		for _, b in ipairs(ns.WORLD_BOSSES) do
			local boss = b
			add(L(boss.labelKey), "world boss worldboss weekly " .. tostring(boss.id), function()
				ns.RouteToWorldBoss(boss)
			end, TIER_CONTENT, L(boss.zoneKey), "boss")
		end
	end

	-- Showdowns (World tab): the block, the two routes it offers, and its two zones with their bosses.
	if ns.SHOWDOWNS then
		local sdWords = "showdown showdowns void world naigtal val heroic world tier riftstalker"
		add(L("SHOWDOWNS_HEADER"), sdWords, function()
			OpenTab("world")
		end, TIER_NAV, L("TAB_WORLD"), "tab")
		if ns.RouteShowdownPortal then
			add(L("SHOWDOWNS_BTN_PORTAL"), sdWords .. " portal", function()
				ns.RouteShowdownPortal()
			end, TIER_ACTION, L("NAV_ACTION_TAKE_ME"), "place")
		end
		if ns.RouteShowdownIntro then
			add(L("SHOWDOWNS_BTN_MAELLA"), sdWords .. " intro start maella", function()
				ns.RouteShowdownIntro()
			end, TIER_ACTION, L("NAV_ACTION_TAKE_ME"), "place")
		end
		for _, z in ipairs(ns.SHOWDOWNS.zones or {}) do
			local zoneName = (z.uiMapID and PlaceText(z.uiMapID)) or z.name
			if z.bossName then
				add(z.bossName, sdWords .. " world boss " .. tostring(z.name), function()
					OpenTab("world")
				end, TIER_CONTENT, zoneName, "boss")
			end
		end
	end

	-- Collectible mounts. The mounts tab is one long checklist, so the hit lands on the
	-- tab rather than on the row: scrolling a search result into view is a promise this
	-- panel cannot keep yet.
	local mountsLabel = L("TAB_MOUNTS")
	for _, m in ipairs(ns.GetMountNameRoster and ns.GetMountNameRoster() or {}) do
		add(m.name, "mount", function()
			OpenTab("mounts")
		end, TIER_CONTENT, mountsLabel, "mount")
	end

	-- The Mount run window under its own title (search inventory 3 Nov 2026): it was only findable through its
	-- command line's sentence, and the mounts in it below.
	if ns.MH_ShowMountRun then
		add(L("MOUNTRUN_TITLE"), "mount run mountrun old raids solo farm transmog legacy weekly lockout", function()
			ns.MH_ShowMountRun()
		end, nil, L("TAB_MOUNTS"), "tool")
	end

	-- Old-raid mounts from the Mount run (Rob, 19 Oct 2026: he typed "Black Drake" and got nothing). A hit opens the
	-- Mount run on that raid's tab AND starts the route to the entrance — what its "Arrow to the entrance" button does.
	local seenRunMount = {}
	for _, r in ipairs(ns.GetMountRunSearchIndex and ns.GetMountRunSearchIndex() or {}) do
		local id = (r.name or "") .. "|" .. tostring(r.raidName)
		if r.name and not seenRunMount[id] then
			seenRunMount[id] = true
			local hit = r
			add(hit.name, "mount drop old raid mount run " .. (hit.english or "") .. " " .. (hit.raidName or ""), function()
				if ns.MH_ShowMountRunAt then
					ns.MH_ShowMountRunAt(hit.groupIndex)
				end
				if ns.MountRunStartRoute then
					ns.MountRunStartRoute(hit.raid)
				end
			end, TIER_CONTENT, hit.raidName, "mount")
		end
	end

	-- Rares. A hit opens the Rares tab on that rare's zone AND routes to it — the same
	-- thing clicking its row does, and the reason someone typed the name at all.
	local rareQuests = {}
	for _, r in ipairs(ns.GetRareSearchIndex and ns.GetRareSearchIndex() or {}) do
		rareQuests[r.questId] = true
		local zoneKey, questId = r.zoneKey, r.questId
		add(r.name, "rare", function()
			if ns.GoToRare then
				ns.GoToRare(zoneKey, questId)
			end
		end, TIER_CONTENT, r.zoneLabel, "rare")
	end

	-- Treasures and lore objects. Several achievements in this table are RARE hunts whose
	-- nodes repeat the rare names above; indexing those would give every rare two rows,
	-- one of which merely opens a checklist. Skip a node whose quest is a known rare.
	if type(ns.ACHIEVEMENT_TREASURES) == "table" then
		for _, entry in ipairs(ns.ACHIEVEMENT_TREASURES) do
			local title = entry.nameKey and L(entry.nameKey)
			if not title and entry.achievementID and GetAchievementInfo then
				local ok, _id, apiName = pcall(GetAchievementInfo, entry.achievementID)
				if ok and type(apiName) == "string" then
					title = apiName
				end
			end
			for _, node in ipairs(entry.nodes or {}) do
				--- ⚠️ THROUGH THE HELPER, AND THE SEVENTH PLACE THIS WAS WRONG.
				---
				--- This read `node.name` and skipped anything without one. Every Coiled
				--- Isle hunt ships WITHOUT names on purpose — the criterion's own text
				--- comes from the client through ns.AchievementNodeName, already
				--- translated — so all of them were silently absent from search: 22
				--- treasures, 11 glyphs, 10 lore objects and the four hunts added today.
				---
				--- Rob asked "kunnen we niet op rare namen en treasures zoeken?" and the
				--- honest answer was that rares worked and treasures mostly did not. The
				--- index was built correctly; it was reading the wrong field.
				---
				--- ✅ Reading it from the client is better than a typed name would have
				--- been: a German player types the German name and finds it, because the
				--- label IS whatever their own Achievements pane says.
				local label = ns.AchievementNodeName and ns.AchievementNodeName(entry, node)
				--- Somewhere to go: a coordinate, or the `wp*` destination a node can
				--- carry without having a location of its own (the ten Mix Master
				--- offerings all point at one cauldron).
				local goMap = node.mapID or node.wpMapID
				local goX, goY = node.x or node.wpX, node.y or node.wpY
				if label and label ~= "" and goMap and goX
					and not (node.quest and rareQuests[node.quest]) then
					local n, lbl = node, label
					add(lbl, "treasure", function()
						OpenTab("achievements")
						if ns.AddSmartTomTomWay then
							ns.AddSmartTomTomWay(n.mapID or n.wpMapID,
								n.x or n.wpX, n.y or n.wpY, lbl)
						end
						--- The same hint the row's own Waypoint button shows. Without it a search
						--- for a Curse Surge boss (10 Sep) sets a waypoint to a spot that is empty
						--- most of the time and says nothing about why — the exact silence that
						--- took those two bosses out of the Rares tab.
						if n.note and ns.ShowTreasureToast then
							ns.ShowTreasureToast(n)
						end
					end, TIER_CONTENT, title, "treasure")
				elseif label and label ~= "" and not (node.quest and rareQuests[node.quest]) then
					-- No place to send an arrow to (search inventory 3 Nov 2026: these were not findable at all).
					-- The hit opens the Achievements tab, where the row and its own text are.
					add(label, "treasure", function()
						OpenTab("achievements")
					end, TIER_CONTENT, title, "treasure")
				end
			end
		end
	end

	--- Every single setting, from the one list that also draws Blizzard's panel and our All settings page
	--- (Modules/SettingsDefs.lua). 3 Nov 2026 (search plan step 1, Rob: "begin met stap 1 tot en met 3"): until
	--- then only the PAGE was findable, so "arrow size" landed you on top of eighty rows. Read from the list, not
	--- copied into this file: a setting added there is searchable without anyone remembering to add it here.
	--- The label and the tooltip are both in the player's language; the choices of a dropdown count too, so
	--- "Deutsch" finds the language switch.
	if ns.GetSettingsDefs then
		local where = L("SET_ALL_TITLE")
		for _, section in ipairs(ns.GetSettingsDefs()) do
			-- Plain ">" on purpose: a "›" would be the only one in the addon, and no font of ours is proven to have it.
			local context = where .. " > " .. L(section.header)
			for _, d in ipairs(section.items or {}) do
				local tip = d.tip and L(d.tip) or ""
				if tip == d.tip then
					tip = "" -- a key with no text anywhere: do not search the key's own name
				end
				local words = { "setting option", tip }
				for _, o in ipairs(d.options or {}) do
					words[#words + 1] = L(o.labelKey)
				end
				local var = d.var
				add(L(d.name), table.concat(words, " "), function()
					if not (ns.FocusSetting and ns.FocusSetting(var)) then
						OpenTab("allsettings")
					end
				end, TIER_CONTENT, context, "setting") -- a tab named like a setting goes first
			end
		end
	end

	--- The /mh commands, as things you can DO rather than syntax to memorise.
	---
	--- ⚠️ Two changes here, and the second is the one that mattered to Rob.
	---
	--- (1) ONE LIST. This file used to carry its own 33-command table next to
	--- `ns.MH_COMMANDS` in CommandList.lua, which has more. Two tables describing the
	--- same commands is the bug shape this project keeps hitting: the other list is
	--- lint-checked (every `cmd` must be routed somewhere) and this one was not, so it
	--- could drift into offering something that no longer exists. Reading from there
	--- also means every command is now searchable, not the subset somebody remembered.
	---
	--- (2) THE LABEL IS THE ACTION. It used to read "/mh bosswin  Command", and Rob
	--- asked whether that could be made clickable — it already was, all along. A row
	--- that shows a slash command reads as documentation, so nobody presses it. Now the
	--- description leads ("The dungeon boss window.") with the command dimmed after it,
	--- which both answers "what does this do" and still teaches the command.
	---
	--- Keywords stay here: they are search vocabulary, not documentation. Without them
	--- "kick" finds nothing, because no description contains that word.
	local CMD_KEYWORDS = {
		season = "season transition checklist wrap up",
		loot = "loot upgrade tips tooltip toggle",
		scorecard = "run scorecard deaths time record",
		mplus = "mythic plus vault rating score keys gain great vault",
		kicks = "interrupt kick scorecard landed wasted missed pummel counterspell",
		translate = "help translate localisation language",
		lang = "language locale switch",
		settings = "options config preferences",
		changelog = "whats new version notes",
		board = "consumables board flask food rune buffs ready",
		bosswin = "dungeon boss window tactics",
		curios = "delve curios advisor companion",
		ritualboss = "ritual boss coach",
		enchant = "gear enchant gems check missing",
		mbuff = "missing buff reminder flask",
		tracks = "gear upgrade track ceiling hero myth maxed slot crest craft",
		panelreset = "side panel reset position move back beside window",
		wishlist = "mount wishlist starred favourite collect chase",
		pawn = "stat weights export scale pawn addon gear",
		stats = "stats stat secondary crit critical strike haste mastery versatility vers "
			.. "primary strength agility intellect priority order explain plain what do they do",
		groupbuffs = "raid buffs missing party intellect stamina group",
		healcds = "healer cooldowns raid healing cheat sheet",
		pullsummary = "tank pull mitigation defensives summary",
		readyboard = "consumable ready board panel flask food group",
		consready = "consumable ready check flask food rune chat",
		death = "death recap killing blow what killed me lesson",
		folio = "omnium folio rune window tree",
		discord = "community help support invite chat server",
		codex = "handbook glossary encyclopedia terms explained",
		coach = "delve coach tips boss tactics",
		mark = "raid target markers world marker fast mark skull",
		clear = "clear route arrow stop waypoint",
		arrowsize = "route arrow size bigger smaller resize",
		bagarrows = "bag upgrade arrows green item better",
		export = "export gear bags armory website best set copy paste items",
		survey = "survey questionnaire opinion feedback what do you use poll website",
		-- 21 Oct 2026: the one door to keybind help (KeysHub.lua). English words reach every client; the label is the
		-- translated CMDLIST_MYKEYS line, which starts with the window's own name, so it is found in the client's words too.
		mykeys = "keys keybind keybinds keybinding bindings bind hotkey hotkeys keyboard layout coach key block swap presses",
	}
	for _, group in ipairs(ns.MH_COMMANDS or {}) do
		for _, item in ipairs(group.items or {}) do
			local cmd = item.cmd
			if type(cmd) == "string" and cmd ~= "" then
				-- "/mh bosswin" -> "bosswin"; bare "/mh" -> "" (the main window).
				local sub = cmd:match("^/mh%s+(.+)$") or ""
				local desc = item.descKey and L(item.descKey) or cmd
				add(desc,
					"command slash " .. cmd .. " " .. (CMD_KEYWORDS[sub] or ""),
					function()
						if SlashCmdList and SlashCmdList["MIDNIGHTHELPER"] then
							SlashCmdList["MIDNIGHTHELPER"](sub)
						end
					end, nil, cmd, "command")
			end
		end
	end

	return idx
end

--------------------------------------------------------------------------------
-- Matching (3 Nov 2026, search plan step 2). Until then the whole query had to appear as one piece of text, so
-- "size arrow" missed "Route arrow size" and a single typo ("arow") found nothing. Now every typed word is looked
-- for on its own, in any order, with room for a small typo, and a hit in the name counts more than one in the
-- keywords or the context. Idea from reading MF Nameplates' search; the code is ours (their code has no open
-- licence, docs/PLAN_ZOEKEN_2026-11-03.md).
--------------------------------------------------------------------------------

-- Lowercase accented letters to their plain letter, so "systeme" finds "Système" and "uberblick" finds
-- "Übersicht" (ULower has already turned the capitals into these).
local FOLD = {
	["à"] = "a", ["á"] = "a", ["â"] = "a", ["ã"] = "a", ["ä"] = "a", ["å"] = "a",
	["è"] = "e", ["é"] = "e", ["ê"] = "e", ["ë"] = "e",
	["ì"] = "i", ["í"] = "i", ["î"] = "i", ["ï"] = "i",
	["ò"] = "o", ["ó"] = "o", ["ô"] = "o", ["õ"] = "o", ["ö"] = "o",
	["ù"] = "u", ["ú"] = "u", ["û"] = "u", ["ü"] = "u",
	["ç"] = "c", ["ñ"] = "n", ["ß"] = "ss", ["ё"] = "е",
}

--- Search form of a text: no colour codes or textures, lower case, no accents, "m+" as one word, and every
--- ASCII sign a space. Bytes from 128 up stay, so Cyrillic and other UTF-8 letters survive.
local function Normalize(s)
	s = tostring(s or "")
	s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):gsub("|n", " ")
	s = ULower(s)
	s = s:gsub("[\195\208\209][\128-\191]", FOLD)
	s = s:gsub("m%+", " mplus ")
	s = s:gsub("[%c%p%s]+", " ")
	return (s:gsub("^ +", ""):gsub(" +$", ""))
end

-- Labels and keywords repeat on every keystroke (the index is rebuilt per query), so their word lists are kept.
-- A language switch only adds new strings; the cap keeps a long session from growing it without end.
local wordCache, wordCacheSize = {}, 0
local function Words(s)
	local w = wordCache[s]
	if w then
		return w
	end
	w = {}
	for word in Normalize(s):gmatch("%S+") do
		w[#w + 1] = word
	end
	if wordCacheSize > 4000 then
		wordCache, wordCacheSize = {}, 0
	end
	wordCache[s] = w
	wordCacheSize = wordCacheSize + 1
	return w
end

--- How many single-letter edits (add, drop, change, or swap two neighbours) turn a into b; stops counting
--- once it is past `limit`, because only "close enough or not" matters here.
-- Three rows of the table, reused: this runs thousands of times per keystroke and a fresh table each row
-- was most of its cost.
local rowA, rowB, rowC = {}, {}, {}
local function Edits(a, b, limit)
	local la, lb = #a, #b
	if math.abs(la - lb) > limit then
		return limit + 1
	end
	local before, prev, cur = nil, rowA, rowB
	local spare = rowC
	for j = 0, lb do
		prev[j] = j
	end
	for i = 1, la do
		cur[0] = i
		local rowBest = i
		local ca = a:byte(i)
		for j = 1, lb do
			local cb = b:byte(j)
			local v = math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + ((ca == cb) and 0 or 1))
			if before and i > 1 and j > 1 and ca == b:byte(j - 1) and a:byte(i - 1) == cb then
				v = math.min(v, before[j - 2] + 1)
			end
			cur[j] = v
			if v < rowBest then
				rowBest = v
			end
		end
		if rowBest > limit then
			return limit + 1
		end
		-- Rotate: the row two back becomes the next row to fill.
		local oldest = before or spare
		before, prev, cur = prev, cur, oldest
	end
	return prev[lb]
end

--- How well one typed word fits one word of an entry, 0 (not at all) to 1 (the same word). The typo check is
--- the expensive part, so it only runs when asked (see FilterIndex).
local function WordFit(q, w, typo)
	if q == w then
		return 1
	end
	local n = #q
	if n >= 2 and w:sub(1, n) == q then
		return 0.85 -- the start of the word: "arr" for "arrow"
	end
	if n >= 3 and w:find(q, 1, true) then
		return 0.6 -- inside the word: "board" in "readyboard"
	end
	if typo and n >= 4 then
		-- A typo. The first letter has to be right (or swapped with the second): people rarely miss the first
		-- letter, "rare" would otherwise also find "care" and "dare", and it skips most words before the
		-- expensive count.
		local q1, w1 = q:byte(1), w:byte(1)
		if q1 ~= w1 and not (q1 == w:byte(2) and q:byte(2) == w1) then
			return 0
		end
		local limit = (n >= 7) and 2 or 1
		local d = Edits(q, w, limit)
		if d <= limit then
			return 0.7 - 0.1 * d
		end
		if #w > n and Edits(q, w:sub(1, n), limit) <= limit then
			return 0.5 -- a typo in the start of a longer word: "arow" for "arrows"
		end
	end
	return 0
end

local function BestFit(q, words, weight, typo)
	local best = 0
	for i = 1, #words do
		local f = WordFit(q, words[i], typo)
		if f > best then
			best = f
			if f == 1 then
				break
			end
		end
	end
	return best * weight
end

-- Search plan step 4 (3 Nov 2026): words that mean the same thing to a player. A typed word from a group also
-- looks for the other words of that group, a little weaker than the word itself. Per MH language, because a group
-- only helps when its words are the ones that pack really uses; the English groups apply in every language too,
-- since many keywords in this file are English. Spelled the normal way: Normalize folds case and accents.
-- Drafted by mh-writer on 3 Nov 2026 from the words our packs really use (setting names, tooltips, dropdown
-- choices, commands, tabs: counted after folding accents). Left out on purpose: a "health" group (almost nothing to
-- find) and "popup = window" (typing "popup" then listed every window, 42 in English). ⚠️ The Bloodlust/Heroism and
-- flask words outside English are typed-in words from memory, not checked against the client's own names: a
-- wrong one finds nothing, it never shows on screen.
local SYNONYMS = {
	enUS = {
		{ "interrupt", "interrupts", "kick", "kicks" }, { "arrow", "waypoint", "route" },
		{ "size", "scale", "resize", "bigger", "smaller", "larger", "zoom" }, { "sound", "audio", "alarm", "chime", "noise" },
		{ "alert", "alerts", "warning", "warnings", "warn", "notification", "notice", "reminder", "reminders" },
		{ "font", "text" }, { "language", "locale", "translation" },
		{ "consumables", "consumable", "flask", "food", "potion", "phial" }, { "mythic", "mplus", "keystone" },
		{ "dispel", "purge", "cleanse", "spellsteal" }, { "boss", "bosses", "encounter" }, { "durability", "repair", "worn" },
		{ "bloodlust", "lust", "heroism", "hero", "battle", "battleres", "brez", "rez", "resurrection" },
		{ "keybind", "keybinds", "binding", "bindings", "hotkey", "hotkeys", "keyboard" }, { "tooltip", "tooltips", "tips" },
		{ "settings", "setting", "options", "config", "preferences" }, { "death", "deaths", "died", "killed", "recap" },
		{ "toast", "toasts", "banner" },
	},
	nlNL = {
		{ "interrupt", "interrupts", "kick", "kicks", "onderbreken" }, { "pijl", "waypoint", "route" },
		{ "grootte", "schaal", "groter", "kleiner", "zoom", "formaat" }, { "geluid", "geluiden", "alarm", "audio" },
		{ "waarschuwing", "waarschuwingen", "waarschuw", "melding", "meldingen", "herinnering", "herinneringen", "alert" },
		{ "lettertype", "tekst", "font" }, { "taal", "talen", "vertaling" },
		{ "consumables", "flask", "food", "potion", "phial", "eten", "drankje" }, { "mythic", "mplus", "keystone" },
		{ "dispel", "purge", "dispellen" }, { "boss", "bosses", "baas", "bazen", "encounter" },
		{ "durability", "repair", "repareren", "versleten" }, { "bloodlust", "lust", "heroism", "hero", "battle", "brez", "rez" },
		{ "keybind", "keybinds", "toetsen", "toets", "sneltoets", "sneltoetsen" }, { "tooltip", "tooltips", "tips" },
		{ "instellingen", "instelling", "opties", "settings" }, { "dood", "death", "sterft", "sterven", "gestorven", "recap" },
		{ "toast", "toasts", "banner", "inschuiven" },
	},
	deDE = {
		{ "unterbrechen", "unterbrechung", "unterbrecher", "kick", "interrupt" }, { "pfeil", "wegpunkt", "route" },
		{ "größe", "skalierung", "skala", "größer", "kleiner", "zoom" }, { "ton", "töne", "sound", "klang", "geräusch", "audio" },
		{ "warnung", "warnungen", "warnen", "hinweis", "meldung", "meldungen", "erinnerung", "erinnerungen", "benachrichtigung" },
		{ "schrift", "schriftart", "text" }, { "sprache", "übersetzung" },
		{ "verbrauchsgüter", "verbrauchsmaterial", "fläschchen", "phiole", "essen", "trank" },
		{ "mythisch", "mythic", "schlüsselstein" }, { "dispel", "entzaubern", "bannen", "reinigen" },
		{ "boss", "bosse", "begegnung" }, { "haltbarkeit", "reparieren", "reparatur", "abgenutzt" },
		{ "kampfrausch", "heldentum", "bloodlust", "lust", "hero", "battle", "brez", "wiederbelebung" },
		{ "tastenbelegung", "belegung", "tasten", "taste", "keybind", "hotkey" }, { "tooltip", "tooltips", "tipps", "tipp" },
		{ "einstellungen", "einstellung", "optionen", "settings" }, { "tod", "tode", "gestorben", "death" },
		{ "toast", "toasts", "einblendung", "einblendungen", "banner" },
	},
	frFR = {
		{ "interruption", "interruptions", "interrompre", "kick" }, { "flèche", "itinéraire", "waypoint", "balise" },
		{ "taille", "échelle", "zoom", "agrandir" }, { "son", "sons", "alarme", "audio", "sonore" },
		{ "alerte", "alertes", "avertissement", "avertir", "rappel", "rappels", "notification" },
		{ "police", "texte", "caractères" }, { "langue", "traduction" },
		{ "consommables", "consommable", "flacon", "fiole", "nourriture", "potion" }, { "mythique", "mythic" },
		{ "dissiper", "dissipation", "purge", "dispel" }, { "boss", "rencontre" },
		{ "durabilité", "réparer", "réparation", "durability" },
		{ "furie", "héroïsme", "bloodlust", "lust", "hero", "battle", "brez", "résurrection" },
		{ "raccourci", "raccourcis", "touche", "touches", "keybind" }, { "infobulle", "infobulles", "tooltip", "conseils", "astuces" },
		{ "paramètres", "réglages", "réglage", "options", "configuration" }, { "mort", "morts", "décès", "mourir", "death" },
		{ "toast", "toasts", "bannière" },
	},
	esES = {
		{ "interrupción", "interrupciones", "interrumpir", "kick", "corte" }, { "flecha", "ruta", "waypoint" },
		{ "tamaño", "escala", "zoom", "agrandar" }, { "sonido", "sonidos", "alarma", "audio" },
		{ "alerta", "alertas", "aviso", "avisos", "avisar", "advertencia", "recordatorio", "recordatorios", "notificación" },
		{ "fuente", "texto", "letra" }, { "idioma", "lengua", "traducción" },
		{ "consumibles", "consumible", "frasco", "comida", "poción" }, { "mítica", "mítico", "mythic" },
		{ "disipar", "disipación", "purga", "purgar", "dispel" }, { "jefe", "jefes", "encuentro", "boss" },
		{ "durabilidad", "reparar", "desgastado" },
		{ "ansia", "heroísmo", "bloodlust", "lust", "hero", "battle", "brez", "resurrección" },
		{ "atajo", "atajos", "tecla", "teclas", "keybind" }, { "tooltip", "consejos", "consejo" },
		{ "ajustes", "ajuste", "opciones", "configuración" }, { "muerte", "muertes", "muerto", "morir" },
		{ "toast", "toasts", "emergente", "emergentes" },
	},
	ptBR = {
		{ "interrupção", "interrupções", "interromper", "kick", "corte" }, { "seta", "rota", "waypoint" },
		{ "tamanho", "escala", "zoom", "aumentar" }, { "som", "sons", "alarme", "áudio" },
		{ "alerta", "alertas", "aviso", "avisos", "avisar", "lembrete", "lembretes", "notificação" },
		{ "fonte", "texto", "letra" }, { "idioma", "língua", "tradução" },
		{ "consumíveis", "frasco", "comida", "poção" }, { "mítica", "mítico", "mythic" },
		{ "dissipar", "dissipação", "purga", "purgar", "dispel" }, { "chefe", "chefes", "encontro", "boss" },
		{ "durabilidade", "reparar", "desgastado", "durability" },
		{ "sede", "heroísmo", "bloodlust", "lust", "hero", "battle", "brez", "ressurreição" },
		{ "atalho", "atalhos", "tecla", "teclas", "keybind" }, { "tooltip", "dicas" },
		{ "configurações", "configuração", "opções", "ajustes" }, { "morte", "mortes", "morreu", "morrer" },
		{ "toast", "toasts", "banner" },
	},
	itIT = {
		{ "interrupt", "interrompere", "interruzione", "kick" }, { "freccia", "percorso", "waypoint" },
		{ "dimensione", "dimensioni", "scala", "zoom", "ingrandire" }, { "suono", "suoni", "allarme", "audio" },
		{ "avviso", "avvisi", "avvisa", "allerta", "notifica", "notifiche", "promemoria" },
		{ "carattere", "testo", "font" }, { "lingua", "traduzione" },
		{ "consumabili", "tonico", "fiala", "cibo", "pozione", "pozioni" }, { "mitica", "mitico", "mythic" },
		{ "dissolvere", "dispel", "purge" }, { "boss", "scontro", "incontro" },
		{ "durabilità", "riparare", "danneggiato", "durability" },
		{ "brama", "eroismo", "bloodlust", "lust", "hero", "battle", "brez", "resurrezione" },
		{ "tasti", "tasto", "keybind", "scorciatoia" }, { "tooltip", "suggerimenti", "consigli" },
		{ "impostazioni", "impostazione", "opzioni", "configurazione" }, { "morte", "morti", "morto", "morire" },
		{ "toast", "banner", "comparsa" },
	},
	ruRU = {
		{ "прерывание", "прерывания", "прервать", "кик", "kick" }, { "стрелка", "стрелки", "маршрут", "waypoint" },
		{ "размер", "масштаб", "больше", "меньше", "зум" }, { "звук", "звуки", "сигнал" },
		{ "оповещение", "оповещения", "предупреждение", "предупреждения", "предупреждать", "уведомление", "напоминание", "напоминания" },
		{ "шрифт", "текст" }, { "язык", "перевод" },
		{ "расходуемые", "расходуемых", "расходники", "настой", "флакон", "еда", "зелье" }, { "эпохальный", "mythic" },
		{ "развеять", "развеивание", "снятие", "dispel" }, { "босс", "боссы", "boss" },
		{ "прочность", "ремонт", "починка", "износ" },
		{ "жажда", "героизм", "bloodlust", "lust", "hero", "battle", "воскрешение", "воскрешения" },
		{ "клавиша", "клавиши", "клавиш", "бинды", "горячие" }, { "подсказка", "подсказки", "советы", "совет" },
		{ "настройки", "настройка", "параметры", "опции" }, { "смерть", "смерти", "погиб", "умер" },
		{ "toast", "тост", "всплывающие", "баннер" },
	},
}

local synMaps = {} -- [lang] = { [word] = { other words } }, built on first use per language
local function SynMap(lang)
	local m = synMaps[lang]
	if m then
		return m
	end
	m = {}
	for _, group in ipairs(SYNONYMS[lang] or {}) do
		local words = {}
		for _, w in ipairs(group) do
			local n = Normalize(w)
			if n ~= "" and not n:find(" ", 1, true) then
				words[#words + 1] = n
			end
		end
		for _, w in ipairs(words) do
			local others = m[w] or {}
			for _, o in ipairs(words) do
				if o ~= w then
					others[#others + 1] = o
				end
			end
			m[w] = others
		end
	end
	synMaps[lang] = m
	return m
end

--- The other words for one typed word: the English groups plus those of the player's MH language.
local function SynonymsOf(term)
	local en = SynMap("enUS")[term]
	local lang = ns.GetEffectiveLocaleCode and ns:GetEffectiveLocaleCode() or "enUS"
	local own = lang ~= "enUS" and SynMap(lang)[term] or nil
	if en and own then
		local all = {}
		for _, w in ipairs(en) do
			all[#all + 1] = w
		end
		for _, w in ipairs(own) do
			all[#all + 1] = w
		end
		return all
	end
	return en or own
end

-- A hit through a synonym is worth a little less than the word itself, so the word you typed still wins a tie.
local WEIGHT_SYNONYM = 0.9

--- Stricter than WordFit, because the player did not type this word: the same word, or (from 4 letters) the start
--- of one. Never inside a word and never a typo — measured by mh-writer: "taal" sits inside "totaal", "ключ" inside
--- "переключатель", "rota" inside "derrota". Three letters or fewer ("son", "ton", "tod") only as a whole word.
local function SynFit(alt, words)
	local n = #alt
	for i = 1, #words do
		local w = words[i]
		if w == alt then
			return 1
		end
		if n >= 4 and w:sub(1, n) == alt then
			return 0.85
		end
	end
	return 0
end

-- What a hit is worth by where it lands. The name is what the player sees and means; keywords and context
-- ("Eversong Woods", the tooltip of a setting) are there to be found by, not to win from a name.
local WEIGHT_LABEL, WEIGHT_REST = 1, 0.6
-- Below this an entry is left out: a couple of loose keyword echoes is not an answer.
local MIN_SCORE = 0.45

--- Score of one entry for the typed words, or nil when it is no match. `typo` allows a typo against the NAME
--- only: the keywords and tooltips are many times longer, and a typo hit in a tooltip is rarely what you meant.
local function ScoreEntry(e, terms, flatQuery, typo)
	local labelWords, restWords = Words(e.label), Words(e.keys)
	local total, missed = 0, 0
	for i = 1, #terms do
		local t = terms[i]
		local s = BestFit(t, labelWords, WEIGHT_LABEL, typo)
		if s < 1 then
			s = math.max(s, BestFit(t, restWords, WEIGHT_REST, false))
		end
		if s < WEIGHT_SYNONYM then
			for _, alt in ipairs(SynonymsOf(t) or {}) do
				local a = math.max(SynFit(alt, labelWords) * WEIGHT_LABEL, SynFit(alt, restWords) * WEIGHT_REST)
				s = math.max(s, a * WEIGHT_SYNONYM)
			end
		end
		if s <= 0 then
			missed = missed + 1
		end
		total = total + s
	end
	if total <= 0 or missed == #terms then
		return nil
	end
	local score = (total / #terms) * (0.5 ^ missed)
	-- The whole query against the whole name, spaces ignored: the strongest signal there is.
	local flat = e._flat
	if not flat then
		flat = table.concat(labelWords)
		e._flat = flat
	end
	if #flatQuery >= 2 then
		if flat == flatQuery then
			score = score + 2
		elseif flat:sub(1, #flatQuery) == flatQuery then
			score = score + 1.2
		elseif #flatQuery >= 3 and flat:find(flatQuery, 1, true) then
			score = score + 0.3
		end
	end
	if score < MIN_SCORE then
		return nil
	end
	-- At an equal fit a destination still beats content: "rares" reaches the Rares tab, not fifteen rares. 0.2 a
	-- tier, measured offline: at 0.05 "rare" put the setting "Rare sound" (exact word) above the Rares tab (start of
	-- the word); the gap between those two is 0.15.
	return score - (e.tier or TIER_NAV) * 0.2
end

local function FilterIndex(query)
	query = ULower(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
	-- "@cat rest" scopes to a category (prefix-matched: "@co" = codex/command); a leading
	-- "/" is shorthand for "@command", so "/" lists commands and "/loot" finds "/mh loot".
	-- An unknown "@xyz" simply matches nothing.
	local catFilter
	local at = query:match("^@(%S+)")
	if at then
		catFilter = at
		query = query:gsub("^@%S+%s*", "")
	elseif query:sub(1, 1) == "/" then
		catFilter = "command"
		query = query:gsub("^/%s*", "")
	end
	if query == "" and not catFilter then
		return {}
	end
	local terms = Words(query)
	if #terms == 0 and not catFilter then
		return {} -- only signs ("@", "?"): nothing to look for, so no list of everything either
	end
	local flatQuery = table.concat(terms)
	local pool = {}
	for _, e in ipairs(BuildNavIndex()) do
		-- "@co" finds codex and command; "@settings" and "@mounts" (the plural people type) find setting and mount.
		if not catFilter or (e.cat and (e.cat:sub(1, #catFilter) == catFilter or catFilter:sub(1, #e.cat) == e.cat)) then
			pool[#pool + 1] = e
		end
	end
	local function run(typo)
		local out = {}
		for _, e in ipairs(pool) do
			local score
			if #terms == 0 then
				score = 1 - (e.tier or TIER_NAV) * 0.2 -- "@cat" with no text: show the whole category
			else
				score = ScoreEntry(e, terms, flatQuery, typo)
			end
			if score then
				out[#out + 1] = { e = e, score = score }
			end
		end
		return out
	end
	-- Two passes. Typo matching costs about ten times more (measured offline, 3 Nov 2026: 1500 entries, up to
	-- 0.4 s a keystroke when every word was tried as a typo), and while you type a correct word the first pass
	-- already finds it. Only when that pass finds nothing does the second one forgive typos.
	local scored = run(false)
	if #scored == 0 and #terms > 0 then
		scored = run(true)
	end
	table.sort(scored, function(a, b)
		if math.abs(a.score - b.score) > 1e-6 then
			return a.score > b.score
		end
		-- Destinations before content at an equal fit (also folded into the score; this settles exact ties).
		if a.e.tier ~= b.e.tier then
			return a.e.tier < b.e.tier
		end
		return a.e.label < b.e.label
	end)
	local out = {}
	for i = 1, math.min(#scored, MAX_MATCHES) do
		out[i] = scored[i].e
	end
	return out
end

--------------------------------------------------------------------------------
-- Dropdown UI (built lazily, once the search bar exists)
--------------------------------------------------------------------------------

local navDrop

local function HideNavDrop()
	if navDrop then
		navDrop:Hide()
	end
end

local function EnsureNavDrop()
	if navDrop then
		return navDrop
	end
	local edit = ns.mhSearchEdit
	if not edit then
		return nil
	end
	local parent = ns.mainUI or edit:GetParent() or UIParent

	navDrop = CreateFrame("Frame", "MidnightHelperNavSearchDrop", parent, "BackdropTemplate")
	navDrop:SetFrameStrata("FULLSCREEN_DIALOG")
	navDrop:SetFrameLevel((parent.GetFrameLevel and parent:GetFrameLevel() or 100) + 30)
	navDrop:SetPoint("TOPLEFT", edit, "BOTTOMLEFT", -4, -2)
	navDrop:SetPoint("TOPRIGHT", edit, "BOTTOMRIGHT", 4, -2)
	navDrop:SetClampedToScreen(true)
	-- Wheel-scroll through matches that do not fit in the eight rows. The offset is
	-- held on the frame so ShowNavResults can reset it whenever the query changes;
	-- keeping your place across a different search would be worse than useless.
	navDrop._mhOffset = 0
	navDrop:EnableMouseWheel(true)
	navDrop:SetScript("OnMouseWheel", function(self, delta)
		local total = self._mhTotal or 0
		if total <= MAX_RESULTS then
			return
		end
		local maxOff = total - MAX_RESULTS
		local off = (self._mhOffset or 0) - delta -- wheel up (+1) moves the list up
		if off < 0 then
			off = 0
		elseif off > maxOff then
			off = maxOff
		end
		if off ~= self._mhOffset then
			self._mhOffset = off
			if self._mhRender then
				self._mhRender()
			end
		end
	end)
	if navDrop.SetBackdrop then
		navDrop:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8",
			edgeFile = "Interface\\Buttons\\WHITE8X8",
			tile = true,
			tileSize = 8,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 },
		})
		navDrop:SetBackdropColor(0.05, 0.05, 0.07, 0.97)
		navDrop:SetBackdropBorderColor(0.55, 0.46, 0.3, 0.9)
	end
	navDrop:Hide()

	navDrop.rows = {}
	for i = 1, MAX_RESULTS do
		local r = CreateFrame("Button", nil, navDrop)
		r:SetHeight(ROW_H)
		if i == 1 then
			r:SetPoint("TOPLEFT", navDrop, "TOPLEFT", 3, -3)
			r:SetPoint("TOPRIGHT", navDrop, "TOPRIGHT", -3, -3)
		else
			r:SetPoint("TOPLEFT", navDrop.rows[i - 1], "BOTTOMLEFT", 0, 0)
			r:SetPoint("TOPRIGHT", navDrop.rows[i - 1], "BOTTOMRIGHT", 0, 0)
		end
		local hl = r:CreateTexture(nil, "HIGHLIGHT")
		hl:SetAllPoints()
		hl:SetColorTexture(1, 0.82, 0.2, 0.18)
		-- The row the arrow keys are on (step 3): the same colour as the mouse highlight, a little stronger.
		local sel = r:CreateTexture(nil, "BACKGROUND")
		sel:SetAllPoints()
		sel:SetColorTexture(1, 0.82, 0.2, 0.28)
		sel:Hide()
		r.sel = sel
		local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if ns.MHScalableFont then
			fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		end
		fs:SetPoint("LEFT", r, "LEFT", 6, 0)
		fs:SetPoint("RIGHT", r, "RIGHT", -6, 0)
		fs:SetJustifyH("LEFT")
		-- One line per row, ending in "…" when too long (Rob's screenshot, 21 Oct 2026: long command lines wrapped onto a
		-- second line and ran through the row below). The full text is in the tooltip.
		fs:SetWordWrap(false)
		if fs.SetMaxLines then
			fs:SetMaxLines(1)
		end
		r.fs = fs
		r:SetScript("OnEnter", function(self)
			if self.fs.IsTruncated and self.fs:IsTruncated() and self._mhFull then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(self._mhFull, 1, 1, 1, 1, true)
				GameTooltip:Show()
			end
		end)
		r:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		-- Activatie op OnMouseDown i.p.v. OnClick: de zoek-EditBox heeft focus terwijl
		-- de dropdown open is, en de eerste klik die die focus wegneemt "eet" de OnClick
		-- op — hover/highlight werkt wél, navigeren niet (Rob 24 jun). OnMouseDown vuurt
		-- op de fysieke druk, vóór de focus-wissel, dus altijd.
		r:SetScript("OnMouseDown", function(self, button)
			if button and button ~= "LeftButton" then
				return
			end
			local go = self._mhGo
			--- 🔴 THE TYPED WORD HAS TO SURVIVE THE CLICK. Until 9 sep 2026 it did not: the
			--- box was cleared, `go()` was called with nothing, and a result could therefore
			--- only ever open a SCREEN -- never the place on that screen that matched. Rob
			--- searched "azeroot", landed on step 6 of 9, and asked the question that names
			--- the whole class: *"kan dat op alles?"*
			--- 📌 Read from the row, not from the edit box: this handler runs after the box
			--- has been cleared, so by then the query is already gone.
			local query = self._mhQuery
			if ns.mhSearchEdit then
				ns.mhSearchEdit:SetText("")
				ns.mhSearchEdit:ClearFocus()
			end
			HideNavDrop()
			if go then
				go(query)
			end
		end)
		navDrop.rows[i] = r
	end

	-- "9 of 33 — scroll for more", under the last row. Hidden when everything fits.
	navDrop.more = navDrop:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	navDrop.more:SetPoint("BOTTOMLEFT", navDrop, "BOTTOMLEFT", 8, 4)
	navDrop.more:SetPoint("BOTTOMRIGHT", navDrop, "BOTTOMRIGHT", -8, 4)
	navDrop.more:SetJustifyH("RIGHT")
	navDrop.more:Hide()

	return navDrop
end

local function ShowNavResults(query)
	local drop = EnsureNavDrop()
	if not drop then
		return
	end
	local res = FilterIndex(query)
	-- A new query always starts at the top, with no row picked. Keeping the old offset would silently
	-- hide the best match for the thing you just typed.
	if drop._mhQuery ~= query then
		drop._mhQuery = query
		drop._mhOffset = 0
		drop._mhSel = nil
	end
	drop._mhRes = res
	drop._mhTotal = #res
	if #res == 0 then
		-- 3 Nov 2026 (step 2): the list used to vanish without a word, which looks the same as broken. One grey
		-- line says so, and that Enter still searches deeper (Codex, guides), which it always did.
		if Normalize((query or ""):gsub("^@%S*", ""):gsub("^/", "")) == "" then
			drop:Hide()
			return
		end
		local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
		for i, r in ipairs(drop.rows) do
			if i == 1 then
				r:SetHeight(ROW_H * s)
				r._mhFull = "|cff9a9a9a" .. L("NAV_NO_MATCH") .. "|r"
				r.fs:SetText(r._mhFull)
				r.sel:Hide()
				r._mhQuery = query
				r._mhGo = function(q)
					if not (ns.TryCodexSearch and ns.TryCodexSearch(q)) and ns.MH_RunSearchQuery then
						ns.MH_RunSearchQuery(q)
					end
				end
				r:Show()
			else
				r:Hide()
				r._mhGo, r._mhQuery = nil, nil
			end
		end
		drop.more:Hide()
		drop:SetHeight(ROW_H * s + 6)
		drop._mhRender = nil
		drop:Show()
		return
	end

	local function render()
		local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
		local rowH = ROW_H * s
		local off = drop._mhOffset or 0
		local shown = 0
		for i, r in ipairs(drop.rows) do
			local e = res[off + i]
			if e then
				shown = shown + 1
				r:SetHeight(rowH)
				-- "Bad Zed  Eversong Woods" — without the zone, forty rare names are forty
				-- riddles. The context is dimmed so the name still reads as the answer.
				r._mhFull = e.context and (e.label .. "  |cff808080" .. e.context .. "|r") or e.label
				r.fs:SetText(r._mhFull)
				r._mhGo = e.go
				-- Carried per row so the click handler can hand the word to the target.
				r._mhQuery = query
				r.sel:SetShown(drop._mhSel == off + i)
				r:Show()
			else
				r:Hide()
				r._mhGo = nil
				r._mhQuery = nil
			end
		end
		-- Say how much is hidden. Without this the list just stops and looks complete,
		-- which is how twenty-five commands can sit one wheel-click away unnoticed.
		if #res > MAX_RESULTS then
			drop.more:SetText((ns:L("NAV_MORE_FMT")):format(off + 1, off + shown, #res))
			drop.more:Show()
			drop:SetHeight(shown * rowH + 6 + (12 * s))
		else
			drop.more:Hide()
			drop:SetHeight(shown * rowH + 6)
		end
	end
	drop._mhRender = render
	render()
	drop:Show()
end

--- Enter-key path from UI.lua's runSearchFromBar: jump only on a strong
--- (label-prefix) match so content keywords still reach the deep search.
--- Screenshot rig (/mh shots): fill the search box and open its result list without a
--- keystroke. The OnTextChanged hook deliberately ignores a programmatic SetText
--- (userInput = false), so we drive the renderer directly.
function ns.DevShowNavResults(query)
	query = query or ""
	if ns.mhSearchEdit then
		ns.mhSearchEdit:SetText(query)
	end
	ShowNavResults(query)
end

--- What the list would hold for a query, as data: for a quick /dump in the game and for an offline test of the
--- matcher (3 Nov 2026). Each entry has .label, .context and .cat.
function ns.DevNavFilter(query)
	return FilterIndex(query)
end

--- And the way back (5 Oct 2026, site chat): scene 08's list stayed open through 10 and 14 of the
--- 16 Sep set, because nothing ever closed it.
function ns.DevHideNavResults()
	if ns.mhSearchEdit then
		ns.mhSearchEdit:SetText("")
		ns.mhSearchEdit:ClearFocus()
	end
	HideNavDrop()
end

--- 3 Nov 2026 (step 3): arrow keys and Tab walk the open list. Down from nothing picks the first row, up from
--- nothing the last; the list scrolls along so the picked row stays in view.
local function MoveSel(dir)
	local drop = navDrop
	local n = drop and drop:IsShown() and drop._mhRender and drop._mhTotal or 0
	if n == 0 then
		return
	end
	local sel = drop._mhSel
	if not sel then
		sel = (dir > 0) and 1 or n
	else
		sel = ((sel - 1 + dir) % n) + 1
	end
	drop._mhSel = sel
	local off = drop._mhOffset or 0
	if sel <= off then
		off = sel - 1
	elseif sel > off + MAX_RESULTS then
		off = sel - MAX_RESULTS
	end
	drop._mhOffset = off
	drop._mhRender()
end

--- The row picked with the keys, if any: Enter then goes THERE, whatever the strong-match rule below says.
local function PickedEntry()
	local drop = navDrop
	if drop and drop:IsShown() and drop._mhSel and drop._mhRes then
		return drop._mhRes[drop._mhSel]
	end
end

function ns.MHNavSearchTryJump(query)
	local picked = PickedEntry()
	if picked then
		HideNavDrop()
		if ns.mhSearchEdit then
			ns.mhSearchEdit:SetText("")
		end
		picked.go(query)
		return true
	end
	query = ULower(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if #query < 2 then
		return false
	end
	local res = FilterIndex(query)
	local top = res[1]
	if top and top.lower:sub(1, #query) == query then
		top.go(query)
		HideNavDrop()
		if ns.mhSearchEdit then
			ns.mhSearchEdit:SetText("")
		end
		return true
	end
	return false
end

--------------------------------------------------------------------------------
-- Attach to the search EditBox once the main UI exists (PLAYER_LOGIN is after
-- the ADDON_LOADED EnsureMainUI call, so ns.mhSearchEdit is ready).
--------------------------------------------------------------------------------
local hookFrame = CreateFrame("Frame")
hookFrame:RegisterEvent("PLAYER_LOGIN")
hookFrame:SetScript("OnEvent", function()
	local edit = ns.mhSearchEdit
	if not edit or edit._mhNavHooked then
		return
	end
	edit._mhNavHooked = true
	edit:HookScript("OnTextChanged", function(self, userInput)
		if not userInput then
			return -- ignore programmatic SetText
		end
		ShowNavResults(self:GetText())
	end)
	-- Escape keeps doing what UI.lua makes it do: let go of the keyboard (or you cannot walk), and close the list.
	edit:HookScript("OnEscapePressed", function()
		HideNavDrop()
	end)
	edit:HookScript("OnArrowPressed", function(_, key)
		if key == "DOWN" then
			MoveSel(1)
		elseif key == "UP" then
			MoveSel(-1)
		end
	end)
	edit:HookScript("OnTabPressed", function()
		MoveSel(IsShiftKeyDown and IsShiftKeyDown() and -1 or 1)
	end)
	edit:HookScript("OnEditFocusLost", function()
		-- Small delay so a click on a result row registers before we hide.
		if C_Timer and C_Timer.After then
			C_Timer.After(0.12, HideNavDrop)
		else
			HideNavDrop()
		end
	end)
end)
