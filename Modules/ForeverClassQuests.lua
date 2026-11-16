local _, ns = ...

--[[
	ForeverClassQuests.lua — WoW Forever: class quests that unlock something, step by step, with the arrow.

	Rob, 16 Nov 2026 (via sparring), letterlijk: "Carola is net, of die kan al beervorm krijgen, maar we weten niet hoe.
	Ik weet dat er een questlijn is … Maar begin inderdaad met de Druid, dan kan ze daar zo meteen alvast mee beginnen."
	First chain: Druid Bear Form (level 10), Alliance (Night Elf) and Horde (Tauren).

	Source: the Forever Zygor guide "Leveling Guides\Druid Class Quests" (ZygorLevelingAllianceCLASSIC.lua:21298-21367,
	ZygorLevelingHordeCLASSIC.lua:22584-22663; GEMETEN in the guide files 16 Nov 2026). Coordinates are Zygor's (rule:
	Rob measured > HandyNotes > Zygor > guide), not yet seen in game. Map ids GEMETEN in wago UiMap 1.60.1.70938.
	Quest ids are unproven until the client ticks them off; `/mh classquest` prints what the client says per quest.

	How the current step is found: the LAST quest of the chain that is done or in your log decides where you are, so a
	player who skipped the first pickup (Zygor: only offered while you do not have the second) is not sent back.
	  quest done          → next quest
	  in log, objective   → go to the objective (unless the client says it is complete)
	  in log, no objective/complete → go to the NPC who takes it
	  not in log          → go to the NPC who gives it
	The chain is over once the spell is known (Bear Form 5487) or the last quest is done.
	NPC names stay English (the client has no NPC-name lookup by id here); zone names come from the client.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- Places: m = UiMap id, x/y in %.
local P = {
	denatharion = { npc = "Denatharion", m = 1457, x = 34.77, y = 7.36 },
	mathrengyl = { npc = "Mathrengyl Bearwalker", m = 1457, x = 35.38, y = 8.41 },
	dendrite = { npc = "Dendrite Starblaze", m = 1450, x = 56.21, y = 30.64 },
	bearspirit = { npc = "Great Bear Spirit", m = 1450, x = 39.11, y = 27.51 },
	lunaclawA = { m = 1439, x = 43.48, y = 45.96 },
	gennia = { npc = "Gennia Runetotem", m = 1412, x = 47.47, y = 62.98 },
	turak = { npc = "Turak Runetotem", m = 1456, x = 76.46, y = 27.23 },
	lunaclawH = { m = 1413, x = 42.00, y = 60.86 },
}

-- q = quest id; from/to = places; obj = { place, textKey } when the quest has something to do between.
local CHAINS = {
	DRUID = {
		{
			key = "bear", spell = 5487, level = 10, faction = "Alliance",
			quests = {
				{ q = 5923, from = P.denatharion, to = P.mathrengyl },
				{ q = 5921, from = P.mathrengyl, to = P.dendrite },
				{ q = 5929, from = P.dendrite, obj = { P.bearspirit, "FCQ_OBJ_BEARSPIRIT" }, to = P.dendrite },
				{ q = 5931, from = P.dendrite, to = P.mathrengyl },
				{ q = 6001, from = P.mathrengyl, obj = { P.lunaclawA, "FCQ_OBJ_LUNACLAW" }, to = P.mathrengyl },
			},
		},
		{
			key = "bear", spell = 5487, level = 10, faction = "Horde",
			quests = {
				{ q = 5928, from = P.gennia, to = P.turak },
				{ q = 5922, from = P.turak, to = P.dendrite },
				{ q = 5930, from = P.dendrite, obj = { P.bearspirit, "FCQ_OBJ_BEARSPIRIT" }, to = P.dendrite },
				{ q = 5932, from = P.dendrite, to = P.turak },
				{ q = 6002, from = P.turak, obj = { P.lunaclawH, "FCQ_OBJ_LUNACLAW" }, to = P.turak },
			},
		},
	},
}

local function Done(q)
	local f = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted
	if f then
		local ok, v = pcall(f, q)
		if ok then
			return v and true or false
		end
	end
	return false
end

local function InLog(q)
	local f = C_QuestLog and C_QuestLog.GetLogIndexForQuestID
	if f then
		local ok, v = pcall(f, q)
		return ok and v ~= nil and v ~= 0
	end
	return false
end

local function ObjDone(q)
	local f = C_QuestLog and C_QuestLog.IsComplete
	if f then
		local ok, v = pcall(f, q)
		return ok and v and true or false
	end
	return false
end

local function Known(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, k = pcall(fn, id)
			if ok and k then
				return true
			end
		end
	end
	return false
end

local function ZoneName(m)
	if C_Map and C_Map.GetMapInfo then
		local ok, info = pcall(C_Map.GetMapInfo, m)
		if ok and info and info.name then
			return info.name
		end
	end
	return "#" .. tostring(m)
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and n then
			return n
		end
	end
	return "#" .. tostring(id)
end

--- The chain for this character (class + faction), or nil.
local function MyChains()
	local token = select(2, UnitClass("player"))
	local faction = UnitFactionGroup and UnitFactionGroup("player")
	local out = {}
	for _, c in ipairs(CHAINS[token] or {}) do
		if c.faction == faction then
			out[#out + 1] = c
		end
	end
	return out
end

--- Where you are in a chain: step = { kind = "get"/"do"/"turn", place, textKey, q }, or nil + why.
local function Step(c)
	if Known(c.spell) then
		return nil, "spell known"
	end
	local last = 0
	for i, e in ipairs(c.quests) do
		if Done(e.q) or InLog(e.q) then
			last = i
		end
	end
	local i = math.max(1, last)
	while c.quests[i] and Done(c.quests[i].q) do
		i = i + 1
	end
	local e = c.quests[i]
	if not e then
		return nil, "all quests done"
	end
	if not InLog(e.q) then
		return { kind = "get", place = e.from, q = e.q }
	end
	if e.obj and not ObjDone(e.q) then
		return { kind = "do", place = e.obj[1], textKey = e.obj[2], q = e.q }
	end
	return { kind = "turn", place = e.to, q = e.q }
end

local function StepText(c, s)
	local p = s.place
	local where = ("%s (%.1f, %.1f)"):format(ZoneName(p.m), p.x, p.y)
	local what
	if s.kind == "get" then
		what = ns:L("FCQ_GET_FMT"):format(p.npc or "?", where)
	elseif s.kind == "do" then
		what = ns:L(s.textKey) .. " — " .. where
	else
		what = ns:L("FCQ_TURN_FMT"):format(p.npc or "?", where)
	end
	return ns:L("FCQ_LINE_FMT"):format(SpellName(c.spell), c.level, what)
end

--- For "Do this now": the line for the first chain you can do now, and its step (for the arrow).
function ns.ForeverClassQuestNow()
	local level = UnitLevel and UnitLevel("player") or 1
	for _, c in ipairs(MyChains()) do
		if level >= c.level then
			local s = Step(c)
			if s then
				return StepText(c, s), s
			end
		end
	end
	return nil
end

--- The arrow to the current step.
function ns.ForeverClassQuestGo()
	local _, s = ns.ForeverClassQuestNow()
	if not s then
		print(PREFIX .. ns:L("FCQ_NOTHING"))
		return false
	end
	local p = s.place
	if not (ns.SetBlizzardUserWaypoint and ns.SetBlizzardUserWaypoint(p.m, p.x, p.y)) then
		print(PREFIX .. ns:L("FVEND_NO_WAYPOINT"))
		return false
	end
	ns.lastTarget = { mapID = p.m, x = p.x, y = p.y, name = p.npc or ZoneName(p.m), via = "/mh classquest", arriveYards = 15 }
	ns._mhRouteOwner = "waypoint"
	print(PREFIX .. (ns.ForeverClassQuestNow()))
	return true
end

--- /mh classquest [go]: per chain and quest what the client says, and the step MH picks (silence rule).
function ns.ForeverClassQuestSlash(arg)
	if (arg or ""):lower() == "go" then
		ns.ForeverClassQuestGo()
		return
	end
	local chains = MyChains()
	print(PREFIX .. ("class quests: %d chain(s) for your class and faction; level %s"):format(#chains,
		tostring(UnitLevel and UnitLevel("player"))))
	for _, c in ipairs(chains) do
		local s, why = Step(c)
		print(("  %s (level %d, spell %d known: %s): %s"):format(SpellName(c.spell), c.level, c.spell,
			tostring(Known(c.spell)), s and (s.kind .. " quest " .. s.q) or why))
		for _, e in ipairs(c.quests) do
			print(("    quest %d: done %s, in log %s, objective done %s"):format(e.q, tostring(Done(e.q)),
				tostring(InLog(e.q)), tostring(ObjDone(e.q))))
		end
	end
	local line = ns.ForeverClassQuestNow()
	print("  line in Do this now: " .. (line or "none"))
end
