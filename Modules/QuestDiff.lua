local _, ns = ...

--[[
	Midnight Helper — hidden kill-quest finder (`/mh questdiff`).

	A rare in `ns.RARE_ZONES` is `{ questId, mapID, x, y, name, npcId }`, and the
	questId is what makes the list tick itself off: kill the rare and the game flags
	a hidden quest complete, so MH can say "you already had this one". Without it a
	zone list shows every rare as outstanding forever.

	We captured the Coiled Isle's rares off the PTR on 6 Aug — names, npcIDs and
	coordinates — but not one questId. There was no machinery for it: `/mh capture`
	prints the line with `questId 0` and a note saying it will be filled in by hand,
	and `/mh questscan` reads the ACTIVE quest log, which a hidden kill-quest never
	appears in.

	HOW IT WORKS. There is no call that lists your completed quests --
	`C_QuestLog.GetQuestsCompleted` appears nowhere in the 90-odd addons installed
	here, so it is not something to lean on. `IsQuestFlaggedCompleted(id)` is used
	532 times and is the reliable one, so this sweeps a RANGE of ids, remembers which
	came back true, and after each fight sweeps again. Whatever turned true in
	between is what that kill flagged.

	The pairing is the point. A bare list of new quest ids is nearly useless a day
	later, so each one is stored with the enemy that was targeted when the fight
	started, its npcID, and where you were standing.

	RANGE. Midnight's own rare quests in `Modules/Rares.lua` run 89569..97014 and MH
	references ids up to 98008; Rob's PTR log showed 97256. 88000..106000 covers that
	with headroom for 12.1 without sweeping the whole game.

	COST. One sweep is 18k calls of a cheap boolean. That is fine once per fight and
	would not be fine on a ticker, which is why it hangs on PLAYER_REGEN_ENABLED
	rather than a timer.

	⚠️ It records what turned true, not what the rare "is". Anything else you finish
	during that fight — a world quest, an objective — lands in the same list. The
	pairing with the target is a strong hint, not proof, and the note stays attached
	to the data.
]]

local SCAN_MIN, SCAN_MAX = 88000, 106000
local MAX_FOUND = 200

local baseline -- [questID] = true, taken when recording starts
local pendingTarget -- what we were fighting when combat began

local function Store()
	if not ns.db then
		return nil
	end
	if type(ns.db.questDiff) ~= "table" then
		ns.db.questDiff = { found = {} }
	end
	ns.db.questDiff.found = ns.db.questDiff.found or {}
	return ns.db.questDiff
end

local function Sweep()
	local set = {}
	if not IsQuestFlaggedCompleted then
		return set
	end
	for id = SCAN_MIN, SCAN_MAX do
		local ok, done = pcall(IsQuestFlaggedCompleted, id)
		if ok and done then
			set[id] = true
		end
	end
	return set
end

--- npcID out of a unit GUID, same field the vignette recorder uses.
local function NpcIdFromUnit(unit)
	if not UnitGUID then
		return nil
	end
	local ok, guid = pcall(UnitGUID, unit)
	if not ok or type(guid) ~= "string" then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

--- Remember what we are fighting, at the START of the fight.
---
--- By the time combat ends the rare is dead and usually deselected, so reading the
--- target then would name whatever you clicked next — or nothing.
local function NoteTarget()
	local name
	if UnitName then
		local ok, n = pcall(UnitName, "target")
		-- A hostile name is a secret in 12.x. Storing it would either error or save
		-- something that is not the name, so it is only kept when readable; the
		-- npcID is the identifier that matters anyway.
		if ok and type(n) == "string" then
			name = n
		end
	end
	pendingTarget = {
		name = name,
		npcID = NpcIdFromUnit("target"),
	}
end

local function AfterCombat()
	local store = Store()
	if not (store and baseline) then
		return
	end
	if #store.found >= MAX_FOUND then
		return
	end

	local now = Sweep()
	local mapID, x, y
	if C_Map and C_Map.GetBestMapForUnit then
		local ok, m = pcall(C_Map.GetBestMapForUnit, "player")
		mapID = ok and m or nil
		if mapID and C_Map.GetPlayerMapPosition then
			local okP, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
			if okP and pos and pos.GetXY then
				local okXY, px, py = pcall(pos.GetXY, pos)
				if okXY then
					x, y = px, py
				end
			end
		end
	end

	for id in pairs(now) do
		if not baseline[id] then
			baseline[id] = true -- so it is reported once, not after every fight
			store.found[#store.found + 1] = {
				questID = id,
				targetName = pendingTarget and pendingTarget.name or nil,
				npcID = pendingTarget and pendingTarget.npcID or nil,
				mapID = mapID,
				x = x and math.floor(x * 1000 + 0.5) / 10 or nil,
				y = y and math.floor(y * 1000 + 0.5) / 10 or nil,
			}
		end
	end
	pendingTarget = nil
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		NoteTarget()
	elseif event == "PLAYER_REGEN_ENABLED" then
		pcall(AfterCombat)
	end
end)

local function SetRunning(on)
	if on then
		ev:RegisterEvent("PLAYER_REGEN_DISABLED")
		ev:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		ev:UnregisterAllEvents()
	end
end

--- `/mh questdiff` — start or stop. `/mh questdiff clear` — throw the list away.
function ns.HandleQuestDiff(arg)
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	ns.db = ns.db or {}

	if arg == "clear" then
		ns.db.questDiff = { found = {} }
		baseline = nil
		print(("%s quest diff cleared."):format(p))
		return
	end

	ns.db.questDiffOn = not ns.db.questDiffOn
	if ns.db.questDiffOn then
		baseline = Sweep()
		local n = 0
		for _ in pairs(baseline) do
			n = n + 1
		end
		SetRunning(true)
		print(("%s quest diff ON — baseline %d completed quests in %d..%d."):format(
			p, n, SCAN_MIN, SCAN_MAX))
		print("   |cff9d9d9dGo kill rares. After each fight the new quest is recorded with|r")
		print("   |cff9d9d9dwhat you were fighting. |cffffffff/reload|r when you are done.|r")
	else
		SetRunning(false)
		local store = Store()
		print(("%s quest diff OFF — %d quest(s) recorded."):format(p, store and #store.found or 0))
	end
end

-- A baseline does not survive a reload, and comparing against a stale one would
-- report every quest completed since as belonging to the next rare you kill. So a
-- reload re-takes it rather than resuming blind.
local boot = CreateFrame("Frame")
boot:RegisterEvent("PLAYER_ENTERING_WORLD")
boot:SetScript("OnEvent", function()
	if ns.db and ns.db.questDiffOn and not baseline then
		baseline = Sweep()
		SetRunning(true)
	end
end)
