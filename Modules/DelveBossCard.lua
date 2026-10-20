local _, ns = ...

--[[
	DelveBossCard.lua — a small window per room boss (Rob, 20 Oct 2026: "maak er sowieso maar een venster per baas van").

	The Labyrinth's tips for its 19 room bosses live in one long coach section (DELVE_TIP_LABYRINTH_ROOMS), and Rob had
	not noticed they were there at all. So when DelveCoach recognises a room boss (MaybeOfferRoomBoss: by unit, by
	encounter id, by encounter name, or by target before the pull) this card opens with ONLY that boss's lines
	(ns.GetDelveBossOwnTipLines); the end boss gets his whole Boss section. A button opens the full coach.

	Not a secure frame, so it may show in combat. It closes on a won ENCOUNTER_END, on its X, or when the next boss
	replaces it. Switch: mh_delveBossCard (on). Off = the old 5-second button.

	/mh bosscard          a list window with every boss; click one for his card
	/mh bosscard why      every boss with how many lines his card shows (0 = a gap to fill)
	/mh bosscard <n|name> that boss's card ("cynthra" is enough), out of a delve too
	The search bar finds them by name too, and every card has an "All bosses" button.
	⚠️ Targeting a boss does NOT open the card in a delve: the unit's name and GUID read secret (measured 16 Aug
	2026). The fight starting (ENCOUNTER_START, by encounter id) is the automatic path; the list is the sure one.
]]

local ENTRY_LABYRINTH = "labyrinth_kindojan"

local card

local function DB()
	ns.db = ns.db or {}
	ns.db.delveBossCard = ns.db.delveBossCard or {}
	return ns.db.delveBossCard
end

function ns.IsDelveBossCardEnabled()
	return DB().off ~= true
end

function ns.SetDelveBossCardEnabled(on)
	DB().off = (not on) and true or nil
	if not on and card then
		card:Hide()
	end
end

local function FindEntry(entryId)
	for _, e in ipairs(ns.DELVE_TIP_ENTRIES or {}) do
		if e.id == entryId then
			return e
		end
	end
	return nil
end

--- The lines for one boss: his own lines, or for the end boss his whole Boss section.
local function BossLines(entryId, idx)
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId]
	local boss = type(bosses) == "table" and bosses[idx]
	if not boss then
		return {}, nil
	end
	if boss.final then
		local entry = FindEntry(entryId)
		for _, sec in ipairs(entry and entry.sections or {}) do
			if sec.titleKey == "DELVE_COACH_SEC_BOSS" and sec.bodyKey then
				local body = ns:L(sec.bodyKey)
				local lines = {}
				for line in (body .. "|n"):gmatch("(.-)|n") do
					if line ~= "" then
						lines[#lines + 1] = line
					end
				end
				return lines, boss
			end
		end
	end
	local lines = ns.GetDelveBossOwnTipLines and ns.GetDelveBossOwnTipLines(entryId, idx) or {}
	-- His own tip ("• Sha'Kuro: kill the …") first, the room tasks that name him after it (Rob's screenshot, 20 Oct
	-- 2026: the boss tip sat second, under "Reliquary Ritual").
	local own, rest = {}, {}
	local needles = type(boss.tipLineMatch) == "table" and boss.tipLineMatch or { boss.label }
	for _, line in ipairs(lines) do
		local head = (line:match("^%s*•?%s*(.-):") or ""):lower()
		local isOwn = false
		for _, nd in ipairs(needles) do
			if type(nd) == "string" and nd ~= "" and head:find(nd:lower(), 1, true) then
				isOwn = true
				break
			end
		end
		if isOwn then
			own[#own + 1] = line
		else
			rest[#rest + 1] = line
		end
	end
	for _, line in ipairs(rest) do
		own[#own + 1] = line
	end
	return own, boss
end

local function Build()
	if card then
		return card
	end
	local f = CreateFrame("Frame", "MidnightHelperDelveBossCard", UIParent, "BackdropTemplate")
	f:SetSize(420, 260)
	f:SetPoint("RIGHT", UIParent, "RIGHT", -60, 40)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f) -- Shift+scroll scales it, like every MH window
	end

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 16, -14)
	f.title:SetPoint("TOPRIGHT", -40, -14)
	f.title:SetJustifyH("LEFT")

	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 14, -42)
	scroll:SetPoint("BOTTOMRIGHT", -32, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(360, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child = scroll, child

	f.body = child:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOPLEFT", 0, 0)
	f.body:SetWidth(360)
	f.body:SetJustifyH("LEFT")
	f.body:SetSpacing(3)

	local open = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	open:SetSize(200, 22)
	open:SetPoint("BOTTOMLEFT", 14, 14)
	open:SetText(ns:L("DELVEBOSSCARD_OPEN_COACH"))
	open:SetScript("OnClick", function()
		if ns.ShowDelveCoach and f._entryId then
			ns:ShowDelveCoach(f._entryId, { preview = false })
		end
		f:Hide()
	end)
	f.openBtn = open

	local all = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	all:SetSize(130, 22)
	all:SetPoint("LEFT", open, "RIGHT", 8, 0)
	all:SetText(ns:L("DELVEBOSSCARD_ALL"))
	all:SetScript("OnClick", function()
		if ns.ShowDelveBossList then
			ns.ShowDelveBossList(f._entryId)
		end
	end)

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	card = f
	return f
end

--- Show the card for boss `idx` of `entryId`. Returns true when it is shown.
function ns.ShowDelveBossCard(entryId, idx)
	if not ns.IsDelveBossCardEnabled() then
		return false
	end
	local lines, boss = BossLines(entryId, idx)
	if not boss then
		return false
	end
	return ns.ShowDelveCardWith(entryId,
		ns:L(boss.final and "DELVEBOSSCARD_END_FMT" or "DELVEBOSSCARD_ROOM_FMT"):format(boss.label), lines)
end

--- The one way text gets onto the card: a title and a list of tip lines (bosses and rooms both).
function ns.ShowDelveCardWith(entryId, titleText, lines)
	local f = Build()
	f._entryId = entryId
	f.title:SetText(titleText)
	local text = #lines > 0 and table.concat(lines, "\n\n") or ns:L("DELVEBOSSCARD_NONE")
	-- {WAY:map:x:y:Name} is a clickable link in the coach; here only its name is shown.
	text = text:gsub("{WAY:[^}]-:([^:}]*)}", "%1")
	f.body:SetText(text)
	local h = (f.body:GetStringHeight() or 100) + 6
	f.child:SetHeight(h)
	-- Grow with the text up to a sensible size; longer (the end boss) scrolls.
	f:SetHeight(math.min(math.max(h + 92, 150), 460))
	f.scroll:SetVerticalScroll(0)
	f:Show()
	return true
end

function ns.HideDelveBossCard()
	if card then
		card:Hide()
	end
end

--------------------------------------------------------------------------------
-- Room cards (Rob, 20 Oct 2026, in "Fools and Curses": "hebben wij daar info over wat we hier moeten doen? En is dat
-- te verwerken in een chamber card?"). The scenario tracker names the room's task; the Rooms tips carry the same
-- name in white ("• |cffffffffFools and Curses|r: …"). Same task name → the card opens with that task line plus the
-- tips of every boss the task line names (Pit Boss here). Tasks without a white name have no in-game name we have
-- seen yet, so they cannot be matched.
-- ⚠️ That the task name is readable from the scenario API is AFGELEID (it is plain tracker text, unlike unit names);
-- every reading lands in ns.db.delveBossCard.lastScenario and /mh roomcard why prints it.
--------------------------------------------------------------------------------

--- task name (lower) -> { name, line } from the Rooms section, in the client's own language.
local function RoomTasks(entryId)
	local tasks = {}
	local entry = FindEntry(entryId)
	for _, sec in ipairs(entry and entry.sections or {}) do
		if sec.titleKey == "DELVE_COACH_SEC_TRASH" and sec.bodyKey then
			for line in (ns:L(sec.bodyKey) .. "|n"):gmatch("(.-)|n") do
				local name = line:match("^%s*•%s*|cffffffff(.-)|r:")
				if name and name ~= "" then
					tasks[name:lower()] = { name = name, line = line }
				end
			end
		end
	end
	return tasks
end

--- The card's lines for one task: the task line, then each named boss's own tip.
local function RoomLines(entryId, task)
	local lines = { task.line }
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId] or {}
	local lowerTask = task.line:lower()
	for i, b in ipairs(bosses) do
		if not b.final and type(b.label) == "string" and lowerTask:find(b.label:lower(), 1, true) then
			local own = BossLines(entryId, i)
			-- BossLines puts the boss's own line first; the room-task lines after it are this task again or others.
			if own[1] and own[1] ~= task.line then
				lines[#lines + 1] = own[1]
			end
		end
	end
	return lines
end

--- Every text the scenario tracker gives us right now (readable ones only).
local function ScenarioTexts()
	local out, seenT = {}, {}
	local function add(s)
		if type(s) == "string" and s ~= "" and not (issecretvalue and issecretvalue(s)) and not seenT[s] then
			seenT[s] = true
			out[#out + 1] = s
		end
	end
	pcall(function()
		local step = C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo and C_ScenarioInfo.GetScenarioStepInfo()
		if step then
			add(step.title)
		end
	end)
	pcall(function()
		if C_Scenario and C_Scenario.GetStepInfo then
			add((C_Scenario.GetStepInfo()))
		end
	end)
	pcall(function()
		local info = C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo and C_ScenarioInfo.GetScenarioInfo()
		if info then
			add(info.name)
		end
	end)
	return out
end

local lastRoomShown -- task name already shown; a new room (or a new run) shows again

--- @return table|nil task, string[] texts read
local function CurrentRoomTask(entryId)
	local texts = ScenarioTexts()
	local tasks = RoomTasks(entryId)
	for _, s in ipairs(texts) do
		local t = tasks[s:lower()]
		if t then
			return t, texts
		end
	end
	return nil, texts
end

local function MaybeShowRoomCard()
	if not ns.IsDelveBossCardEnabled() then
		return
	end
	local inDelve = ns.IsDelveInstanceInProgress and ns:IsDelveInstanceInProgress()
	if not inDelve then
		lastRoomShown = nil
		return
	end
	local task, texts = CurrentRoomTask(ENTRY_LABYRINTH)
	local stamp = date and date("%Y-%m-%d %H:%M:%S") or "?"
	DB().lastScenario = { at = stamp, texts = texts, match = task and task.name or nil }
	-- A history, not only the last reading (Rob, 20 Oct 2026: a room in The Cave Towers gave no card and he had not
	-- looked; only the newest reading survived until his /reload). Every change of tracker text is kept, 30 newest.
	local joined = table.concat(texts, " | ")
	local hist = DB().scenarioHistory
	if type(hist) ~= "table" then
		hist = {}
		DB().scenarioHistory = hist
	end
	if joined ~= "" and (not hist[1] or hist[1].texts ~= joined) then
		table.insert(hist, 1, { at = stamp, texts = joined, match = task and task.name or "-" })
		while #hist > 30 do
			table.remove(hist)
		end
	end
	if not task or lastRoomShown == task.name then
		return
	end
	lastRoomShown = task.name
	ns.ShowDelveCardWith(ENTRY_LABYRINTH, ns:L("DELVEROOMCARD_FMT"):format(task.name), RoomLines(ENTRY_LABYRINTH, task))
end

local roomEv = CreateFrame("Frame")
roomEv:RegisterEvent("SCENARIO_UPDATE")
roomEv:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
roomEv:RegisterEvent("PLAYER_ENTERING_WORLD")
roomEv:SetScript("OnEvent", function()
	-- The tracker fills a moment after the event; read it once it has settled.
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, MaybeShowRoomCard)
	else
		MaybeShowRoomCard()
	end
end)

--- /mh roomcard          the card for the room you are in now
--- /mh roomcard why      what the scenario tracker reads and which task it matched
--- /mh roomcard <name>   a task by (part of) its name, out of a delve too
function ns.MH_DelveRoomCardCommand(arg)
	local tasks = RoomTasks(ENTRY_LABYRINTH)
	if arg == "why" then
		local task, texts = CurrentRoomTask(ENTRY_LABYRINTH)
		print("|cff8fd3ffMidnight Helper — room card|r " .. (ns.IsDelveBossCardEnabled() and "on" or "|cffff5040off in settings|r"))
		print("   scenario texts: " .. (#texts > 0 and table.concat(texts, " | ") or "|cffff5040none readable|r"))
		print("   matched task: " .. (task and ("|cff40c040" .. task.name .. "|r") or "|cff9d9d9dnone|r"))
		local names = {}
		for _, t in pairs(tasks) do
			names[#names + 1] = t.name
		end
		table.sort(names)
		print(("   %d known tasks: %s"):format(#names, table.concat(names, ", ")))
		local hist = DB().scenarioHistory or {}
		for i = 1, math.min(#hist, 8) do
			local h = hist[i]
			print(("   %s  %s  -> %s"):format(tostring(h.at), tostring(h.texts), tostring(h.match)))
		end
		return
	end
	local task
	if arg and arg ~= "" then
		local needle = arg:lower()
		for key, t in pairs(tasks) do
			if key:find(needle, 1, true) then
				task = t
				break
			end
		end
	else
		task = CurrentRoomTask(ENTRY_LABYRINTH)
	end
	if not task then
		print("|cff8fd3ffMidnight Helper|r roomcard: no matching room task. /mh roomcard why shows what MH reads.")
		return
	end
	ns.ShowDelveCardWith(ENTRY_LABYRINTH, ns:L("DELVEROOMCARD_FMT"):format(task.name), RoomLines(ENTRY_LABYRINTH, task))
end

--- A won fight closes it; a wipe leaves it up for the next try.
local ev = CreateFrame("Frame")
ev:RegisterEvent("ENCOUNTER_END")
ev:SetScript("OnEvent", function(_, _, _, _, _, _, success)
	if success == 1 and card and card:IsShown() then
		card:Hide()
	end
end)

--------------------------------------------------------------------------------
-- The list of every boss (Rob, 20 Oct 2026, in front of Cynthra: target detection does not work in a delve — the
-- unit's name and GUID read secret, measured 16 Aug — "een lijstje met een venster wat we kunnen openen. En als we
-- er iets tegenkomen, gewoon kunnen aanklikken"). One button per boss, two columns; a click opens his card.
--------------------------------------------------------------------------------
local list

local function BuildList(entryId)
	if list then
		return list
	end
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId] or {}
	local f = CreateFrame("Frame", "MidnightHelperDelveBossList", UIParent, "BackdropTemplate")
	local rows = math.ceil(#bosses / 2)
	f:SetSize(440, 70 + rows * 26)
	f:SetPoint("RIGHT", UIParent, "RIGHT", -500, 40)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -14)
	title:SetText(ns:L("DELVEBOSSLIST_TITLE"))
	for i, b in ipairs(bosses) do
		local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		local col, row = (i - 1) % 2, math.floor((i - 1) / 2)
		btn:SetSize(200, 22)
		btn:SetPoint("TOPLEFT", 16 + col * 208, -44 - row * 26)
		btn:SetText(b.final and ("|cffff9900" .. b.label .. "|r") or b.label)
		local idx = i
		btn:SetScript("OnClick", function()
			ns.ShowDelveBossCard(entryId, idx)
		end)
	end
	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	list = f
	return f
end

function ns.ShowDelveBossList(entryId)
	local f = BuildList(entryId or ENTRY_LABYRINTH)
	f:Show()
	f:Raise()
end

--- A boss by (part of) his name, accents and case ignored as far as plain lower() goes.
local function FindBossByName(entryId, text)
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId] or {}
	local needle = text:lower()
	for i, b in ipairs(bosses) do
		if type(b.label) == "string" and b.label:lower():find(needle, 1, true) then
			return i
		end
	end
	return nil
end

--- /mh bosscard            the list window
--- /mh bosscard why        every boss with its line count, in chat
--- /mh bosscard <n|name>   that boss's card
function ns.MH_DelveBossCardCommand(arg)
	local entryId = ENTRY_LABYRINTH
	local bosses = ns.DELVE_BOSS_SHOWCASE and ns.DELVE_BOSS_SHOWCASE[entryId] or {}
	if not arg or arg == "" then
		ns.ShowDelveBossList(entryId)
		return
	end
	local n = tonumber(arg)
	if not n and arg ~= "why" then
		n = FindBossByName(entryId, arg)
		if not n then
			print(("|cff8fd3ffMidnight Helper|r bosscard: no boss named '%s'. /mh bosscard opens the list."):format(arg))
			return
		end
	end
	if n then
		if not ns.ShowDelveBossCard(entryId, n) then
			print(("|cff8fd3ffMidnight Helper|r bosscard: no boss %d, or the card is off in settings."):format(n))
		end
		return
	end
	print(("|cff8fd3ffMidnight Helper — boss cards (%s)|r %s"):format(entryId,
		ns.IsDelveBossCardEnabled() and "on" or "|cffff5040off in settings|r"))
	for i, b in ipairs(bosses) do
		local lines = BossLines(entryId, i)
		local col = #lines > 0 and "|cff40c040" or "|cffff5040"
		print(("   %2d  %-28s %s%d line(s)|r%s"):format(i, tostring(b.label), col, #lines, b.final and "  (end boss: whole Boss section)" or ""))
	end
	print("   |cff9d9d9d/mh bosscard <number or name> shows that card; /mh bosscard alone opens the list|r")
end
