--[[
	Global navigation search (1.9.0 Phase 1b) — the "front door".

	Turns the existing search bar into a live navigator: type a word and a
	dropdown shows matching destinations (tabs, sub-tabs, tools). Click a row to
	jump straight there; press Enter on a strong (prefix) match to jump as well.
	Weak/keyword-only queries still fall through to the existing deep Codex/Guide
	search in UI.lua (runSearchFromBar), so nothing is lost.

	Builds entirely on existing primitives: ns.SelectTab (with its sub-tab
	aliases), ns:ToggleDelveCoach, and the search EditBox ns.mhSearchEdit. No new
	locale keys — labels reuse the existing TAB_* / DELVE_COACH_TITLE strings.
]]

local _, ns = ...

local MAX_RESULTS = 8
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

-- Rebuilt per query (cheap, ~25 entries) so labels follow the current locale.
local function BuildNavIndex()
	local idx = {}
	local function add(label, keys, go)
		if type(label) ~= "string" or label == "" then
			return
		end
		idx[#idx + 1] = {
			label = label,
			lower = label:lower(),
			keys = (keys or ""):lower(),
			go = go,
		}
	end
	local function tab(labelKey, id, keys)
		add(L(labelKey), keys, function()
			OpenTab(id)
		end)
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

	-- Sub-tabs (resolved through SelectTab's legacy aliases).
	tab("TAB_PROFESSIONS", "professions", "profession alchemy herbalism work orders crafting knowledge points")
	tab("TAB_MACROS", "macros", "interrupt macro kick")
	tab("TAB_CONSUMABLES", "consumables", "flask rune food buff oil")
	tab("TAB_ACADEMY", "academy", "role tank heal academy")
	tab("TAB_REFERENCE", "reference", "basics dawncrest")

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
				end)
			end
		end
	end

	-- Codex articles (deep content; each lands on its category page).
	if type(ns.CODEX_ARTICLES) == "table" then
		for _, art in ipairs(ns.CODEX_ARTICLES) do
			if type(art) == "table" and art.titleKey then
				local cat = art.category
				add(L(art.titleKey), "codex article " .. (art.id or ""), function()
					if cat and ns.SetActiveCodexCategory then
						ns.SetActiveCodexCategory(cat)
					end
					OpenTab("codex")
				end)
			end
		end
	end

	-- Tools (floating helper windows; existing toggles).
	add(L("DELVE_COACH_TITLE"), "delve coach tactics boss", function()
		if ns.ToggleDelveCoach then
			ns:ToggleDelveCoach()
		end
	end)
	add(L("NAV_TOOL_BOARD"), "consumable board flask rune food buffs ready", function()
		if ns.ShowConsumableBoard then
			ns.ShowConsumableBoard()
		end
	end)
	add(L("NAV_TOOL_BOSSWIN"), "dungeon boss window tactics floating", function()
		if ns.ToggleDungeonBossWindow then
			ns.ToggleDungeonBossWindow()
		end
	end)
	add(L("NAV_TOOL_CURIOS"), "curios advisor delve companion role", function()
		if ns.ToggleDelveCuriosPopup then
			ns:ToggleDelveCuriosPopup()
		end
	end)
	add(L("NAV_TOOL_RITUALBOSS"), "ritual boss coach window", function()
		if ns.ToggleRitualBossWindow then
			ns.ToggleRitualBossWindow()
		end
	end)

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
				add(bossName, entryName, function()
					if ns.ShowBossWindowForEntry then
						ns.ShowBossWindowForEntry(entry, bossKey)
					end
				end)
			end
		end
	end

	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		addBosses(d)
	end
	for _, e in pairs(ns.CUSTOM_BOSS_ENTRIES or {}) do
		addBosses(e)
	end

	return idx
end

local function FilterIndex(query)
	query = (query or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if query == "" then
		return {}
	end
	local scored = {}
	for _, e in ipairs(BuildNavIndex()) do
		local rank
		if e.lower:sub(1, #query) == query then
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
	table.sort(scored, function(a, b)
		if a.rank ~= b.rank then
			return a.rank < b.rank
		end
		return a.e.label < b.e.label
	end)
	local out = {}
	for i = 1, math.min(#scored, MAX_RESULTS) do
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
	local s = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
	local rowH = ROW_H * s
	for i, r in ipairs(drop.rows) do
		local e = res[i]
		if e then
			r:SetHeight(rowH)
			r.fs:SetText(e.label)
			r._mhGo = e.go
			r:Show()
		else
			r:Hide()
			r._mhGo = nil
		end
	end
	drop:SetHeight(#res * rowH + 6)
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
