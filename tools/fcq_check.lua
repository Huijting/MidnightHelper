-- tools/fcq_check.lua — offline check of Modules/ForeverClassQuests.lua (17 Nov 2026, Bouwchat 17-11).
-- Run through `run fcq_check` (tools/fcq_check.py). Stubs the game, then walks every class x race x faction, levels
-- 1-60, and every quest state (nothing / each quest in the log, earlier ones done, complete or not / everything done).
-- Any Lua error is printed with its case. Prints KEY: lines for the locale keys used, which the .py checks against
-- enUS + nlNL. It proves the code paths run, NOT that quest ids, places or names are right: only the game proves those.
local path = arg[1]
local used = {}
local S = { done = {}, log = {}, complete = false }
local CUR = {}

local ns = { IS_FOREVER = true }
function ns:L(k)
	used[k] = true
	return k
end
ns.SetBlizzardUserWaypoint = function() return true end

C_QuestLog = {
	IsQuestFlaggedCompleted = function(q) return S.done[q] or false end,
	GetLogIndexForQuestID = function(q) return S.log[q] and 1 or nil end,
	IsComplete = function(q) return S.complete end,
	GetQuestObjectives = function(q) return {} end,
}
C_Item = {
	-- S.items: every item counts as in your bags (reaches the "use" step of a quest that starts from an item).
	GetItemCount = function() return S.items and 1 or 0 end,
	GetItemNameByID = function(id) return "Item" .. id end,
}
C_Map = { GetMapInfo = function(m) return { name = "Map" .. m } end }
C_Spell = { GetSpellName = function(id) return "Spell" .. id end }
IsPlayerSpell = function() return false end
UnitClass = function() return "x", CUR.class end
UnitFactionGroup = function() return CUR.faction end
UnitRace = function() return "x", CUR.race, CUR.raceId end
UnitLevel = function() return CUR.level end
GetLocale = function() return CUR.locale or "enUS" end
local out = {}
print = function(...) out[#out + 1] = table.concat({ ... }, " ") end

local chunk = assert(loadfile(path))
chunk("MidnightHelper", ns)

-- Quest ids from the file text (every "q = <id>" and every alt list).
local f = io.open(path, "r")
local text = f:read("*a")
f:close()
local ids = {}
for q in text:gmatch("q = (%d+)") do ids[#ids + 1] = tonumber(q) end
for q in text:gmatch("alt = { ([%d, ]+) }") do
	for n in q:gmatch("%d+") do ids[#ids + 1] = tonumber(n) end
end

-- Every class x every race of each faction (a combination the game does not allow just yields 0 or race-free chains).
local cases = {}
local RACES = {
	Alliance = { { "Human", 1 }, { "Dwarf", 3 }, { "NightElf", 4 }, { "Gnome", 7 }, { "Skyborne", 95 } },
	Horde = { { "Orc", 2 }, { "Scourge", 5 }, { "Tauren", 6 }, { "Troll", 8 }, { "Skyborne", 96 } },
}
for _, cls in ipairs({ "DRUID", "WARLOCK", "WARRIOR", "SHAMAN", "ROGUE", "HUNTER", "PALADIN", "PRIEST", "MAGE" }) do
	for _, faction in ipairs({ "Alliance", "Horde" }) do
		for _, r in ipairs(RACES[faction]) do
			cases[#cases + 1] = { cls, faction, r[1], r[2] }
		end
	end
end
local errors, runs = 0, 0
local function run(label, fn)
	runs = runs + 1
	local ok, err = pcall(fn)
	if not ok then
		errors = errors + 1
		io.write("ERROR ", label, ": ", tostring(err), "\n")
	end
end
-- 17 Nov 2026: the Class quests page of the overview reads ns.ForeverClassQuestList and presses every row's button.
local function ListAll()
	for _, e in ipairs(ns.ForeverClassQuestList()) do
		assert(type(e.chain) == "string" and type(e.level) == "number", "list entry without chain/level")
		if e.go then
			e.go()
		end
	end
end

for _, c in ipairs(cases) do
	CUR.class, CUR.faction, CUR.race, CUR.raceId = c[1], c[2], c[3], c[4]
	for _, level in ipairs({ 1, 10, 20, 30, 40, 50, 60 }) do
		CUR.level = level
		local label = table.concat({ c[1], c[2], c[3], level }, "/")
		S.done, S.log, S.complete = {}, {}, false
		run(label .. " none", function() ns.ForeverClassQuestSlash(""); ns.ForeverClassQuestOverview(); ns.ForeverClassQuestGo(); ListAll() end)
		for i, q in ipairs(ids) do
			S.done, S.log = {}, { [q] = true }
			for j = 1, i - 1 do S.done[ids[j]] = true end
			for _, comp in ipairs({ false, true }) do
				S.complete = comp
				run(label .. " q" .. q, function() ns.ForeverClassQuestNow(); ns.ForeverClassQuestOverview(); ListAll() end)
			end
			-- Same, but nothing in the log: reaches "get" and "wait" steps after a done quest (17 Nov: e.wait).
			S.log, S.complete = {}, false
			run(label .. " after" .. q, function() ns.ForeverClassQuestNow(); ns.ForeverClassQuestGo(); ListAll() end)
			S.items = true
			run(label .. " items" .. q, function() ns.ForeverClassQuestNow(); ns.ForeverClassQuestOverview() end)
			S.items = false
		end
		S.done, S.log = {}, {}
		for _, q in ipairs(ids) do S.done[q] = true end
		run(label .. " all", function() ns.ForeverClassQuestSlash(""); ns.ForeverClassQuestOverview() end)
	end
	out = {}
	CUR.level = 60
	S.done, S.log = {}, {}
	ns.ForeverClassQuestSlash("")
	local n = (out[1] or ""):match("(%d+) chain")
	if n and n ~= "0" then
		io.write(c[1], " ", c[2], " ", c[3], ": ", n, " chain(s)\n")
	end
end
-- Locale names: one deDE run so NpcName takes the table path.
CUR.class, CUR.faction, CUR.race, CUR.raceId, CUR.level, CUR.locale = "WARLOCK", "Horde", "Scourge", 5, 30, "deDE"
S.done, S.log = {}, {}
run("deDE", function() ns.ForeverClassQuestNow() end)
io.write(("runs %d, errors %d, quest ids %d\n"):format(runs, errors, #ids))
for k in pairs(used) do io.write("KEY:", k, "\n") end
