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

-- Rebuilt per query (a few hundred entries of pure string work) so labels follow the
-- current locale. Nothing here may call an expensive API: this runs on every keystroke.
local function BuildNavIndex()
	local idx = {}
	--- @param context string|nil dim text after the label ("Eversong Woods"), also searchable
	--- @param cat string|nil category for the "@cat" filter (tab/mount/rare/treasure/boss/tool/codex/command)
	local function add(label, keys, go, tier, context, cat)
		if type(label) ~= "string" or label == "" then
			return
		end
		idx[#idx + 1] = {
			label = label,
			context = context,
			lower = label:lower(),
			keys = ((keys or "") .. " " .. (context or "")):lower(),
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
	tab("TAB_DELVES", "delves", "vault great vault delver")
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
	tab("TAB_TOOLSLAUNCH", "toolslaunch", "tools launchpad pop-out windows launcher")
	tab("TAB_TOOLBOX", "toolbox", "tools utilities")
	tab("TAB_ADDONS", "addons", "addon panel")
	tab("TAB_SETTINGS", "settings", "options preferences text size font language scale")

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
	tab("TAB_MACROS", "macros", "interrupt macro kick")
	-- "party targets" is what a player calls it; "focus" and "assist" are what they
	-- search for when they do not know the name. Additive, like every keyword here.
	tab("TAB_SETTINGS", "settings", "party target targets focus assist who is attacking")
	tab("TAB_CONSUMABLES", "consumables", "flask rune food buff oil")
	tab("TAB_ACADEMY", "academy", "role tank heal academy")
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

	-- Codex articles (deep content; each lands on its category page).
	if type(ns.CODEX_ARTICLES) == "table" then
		for _, art in ipairs(ns.CODEX_ARTICLES) do
			if type(art) == "table" and art.titleKey then
				local cat = art.category
				-- searchKeys matters more than it looks. Without it an article is
				-- findable only by words already in its own title, which is exactly
				-- the words someone who has not read it will not type. "When a season
				-- ends" was invisible to a search for "reset" (Rob, 2026-07-27).
				add(L(art.titleKey), "codex article " .. (art.id or "") .. " " .. (art.searchKeys or ""), function()
					if cat and ns.SetActiveCodexCategory then
						ns.SetActiveCodexCategory(cat)
					end
					OpenTab("codex")
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

	-- Collectible mounts. The mounts tab is one long checklist, so the hit lands on the
	-- tab rather than on the row: scrolling a search result into view is a promise this
	-- panel cannot keep yet.
	local mountsLabel = L("TAB_MOUNTS")
	for _, m in ipairs(ns.GetMountNameRoster and ns.GetMountNameRoster() or {}) do
		add(m.name, "mount", function()
			OpenTab("mounts")
		end, TIER_CONTENT, mountsLabel, "mount")
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
				if node.name and node.mapID and not (node.quest and rareQuests[node.quest]) then
					local n = node
					add(n.name, "treasure", function()
						OpenTab("achievements")
						if ns.AddSmartTomTomWay then
							ns.AddSmartTomTomWay(n.mapID, n.x, n.y, n.name)
						end
					end, TIER_CONTENT, title, "treasure")
				end
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

local function FilterIndex(query)
	query = (query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
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
	local scored = {}
	for _, e in ipairs(BuildNavIndex()) do
		if not catFilter or (e.cat and e.cat:sub(1, #catFilter) == catFilter) then
			local rank
			if query == "" then
				rank = 2 -- "@cat" with no text: show the whole category
			elseif e.lower:sub(1, #query) == query then
				rank = 1 -- label starts with the query
			elseif e.lower:find(query, 1, true) then
				rank = 2 -- label contains the query
			elseif e.keys ~= "" and e.keys:find(query, 1, true) then
				rank = 3 -- keyword hit only
			end
			if rank then
				scored[#scored + 1] = { e = e, rank = rank }
			end
		end
	end
	table.sort(scored, function(a, b)
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		-- Destinations before content at equal rank: "rares" must reach the Rares tab,
		-- not fifteen rares that happen to share the word.
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
		local fs = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		if ns.MHScalableFont then
			fs:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
		end
		fs:SetPoint("LEFT", r, "LEFT", 6, 0)
		fs:SetPoint("RIGHT", r, "RIGHT", -6, 0)
		fs:SetJustifyH("LEFT")
		r.fs = fs
		-- Activatie op OnMouseDown i.p.v. OnClick: de zoek-EditBox heeft focus terwijl
		-- de dropdown open is, en de eerste klik die die focus wegneemt "eet" de OnClick
		-- op — hover/highlight werkt wél, navigeren niet (Rob 24 jun). OnMouseDown vuurt
		-- op de fysieke druk, vóór de focus-wissel, dus altijd.
		r:SetScript("OnMouseDown", function(self, button)
			if button and button ~= "LeftButton" then
				return
			end
			local go = self._mhGo
			if ns.mhSearchEdit then
				ns.mhSearchEdit:SetText("")
				ns.mhSearchEdit:ClearFocus()
			end
			HideNavDrop()
			if go then
				go()
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
	if #res == 0 then
		drop:Hide()
		return
	end
	-- A new query always starts at the top. Keeping the old offset would silently
	-- hide the best match for the thing you just typed.
	if drop._mhQuery ~= query then
		drop._mhQuery = query
		drop._mhOffset = 0
	end
	drop._mhTotal = #res

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
				r.fs:SetText(e.context and (e.label .. "  |cff808080" .. e.context .. "|r") or e.label)
				r._mhGo = e.go
				r:Show()
			else
				r:Hide()
				r._mhGo = nil
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

function ns.MHNavSearchTryJump(query)
	query = (query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if #query < 2 then
		return false
	end
	local res = FilterIndex(query)
	local top = res[1]
	if top and top.lower:sub(1, #query) == query then
		top.go()
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
	edit:HookScript("OnEscapePressed", function()
		HideNavDrop()
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
