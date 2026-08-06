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
	here, so it is not something to lean on. `C_QuestLog.IsQuestFlaggedCompleted(id)`
	is the reliable one, so this sweeps a RANGE of ids, remembers which came back
	true, and after each fight sweeps again. Whatever turned true in between is what
	that kill flagged.

	⚠️ It must be the NAMESPACED call. The bare global `IsQuestFlaggedCompleted` still
	appears ~147 times across the installed addons, but on Rob's 12.1 PTR client it is
	nil — every one of those will throw on patch day. Nothing in Midnight Helper is
	affected: all 60-odd of our own checks already go through C_QuestLog.

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

-- Widened 6 Aug from 88000..106000. Rob killed Farthik the Plunderer with recording
-- on and nothing was recorded, and a 12.1 zone's quests may simply sit above where
-- Midnight's launch quests do. The extra 6000 ids cost nothing measurable.
-- ⚠️ THE BARE GLOBAL IS GONE ON 12.1. `IsQuestFlaggedCompleted(id)` raised "attempt
-- to call a nil value" on Rob's PTR client, 6 Aug. Everything else in this addon
-- already went through C_QuestLog, so nothing shipped was affected — but the first
-- version of this module guarded with `if not IsQuestFlaggedCompleted then return`,
-- which turned a missing function into a silent zero and cost an evening of flying.
-- A missing API should be loud.
local IsDone = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted

local SCAN_MIN, SCAN_MAX = 88000, 112000
local MAX_FOUND = 200

local baseline -- [questID] = true, taken when recording starts
local baselineCount = 0
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

--- Returns the set AND how big it is.
---
--- The count is the whole point of the second return. When the first version found
--- nothing after a confirmed kill there was no way to tell an empty sweep (the call
--- unusable, so nothing is ever "completed") from a full sweep that simply missed the
--- quest (wrong range, or the flag not set yet). Those need opposite fixes, and the
--- SavedVariables now carry the number that separates them.
local function Sweep()
	local set, n = {}, 0
	if not IsDone then
		local store = Store()
		if store then
			store.sweepError = "C_QuestLog.IsQuestFlaggedCompleted is missing"
		end
		return set, 0
	end
	-- One pcall around the loop, not 24000 of them. A per-id pcall also hid WHICH
	-- id failed and whether it failed at all — an error on the very first id looked
	-- exactly like nothing being completed.
	local ok, err = pcall(function()
		for id = SCAN_MIN, SCAN_MAX do
			if IsDone(id) then
				set[id] = true
				n = n + 1
			end
		end
	end)
	if not ok then
		local store = Store()
		if store then
			store.sweepError = tostring(err)
		end
	end
	return set, n
end

--- Is this value one the client will not let us look at?
---
--- ⚠️ A secret string IS a string. `type(v) == "string"` returns true for it and
--- tells you nothing, which is exactly how this module threw "attempt to perform
--- string conversion on a secret string value" on Rob's target GUID: the type check
--- passed and strsplit then tried to read it. Core.lua's own capture handler had the
--- right guard all along; it simply was not carried over to here.
local function Secret(v)
	return issecretvalue and issecretvalue(v) or false
end

--- npcID out of a unit GUID, same field the vignette recorder uses.
local function NpcIdFromUnit(unit)
	if not UnitGUID then
		return nil
	end
	local ok, guid = pcall(UnitGUID, unit)
	if not ok or type(guid) ~= "string" or Secret(guid) then
		return nil
	end
	return tonumber((select(6, strsplit("-", guid))))
end

--- Remember what we are fighting.
---
--- Read at the START of the fight, because by the time combat ends the rare is dead
--- and usually deselected — reading it then would name whatever you clicked next.
---
--- But the start is not always enough. Rob killed something on the Coiled Isle and
--- the row came back with the quest ids and the position and no name at all: he was
--- attacked before he had targeted anything, so at PLAYER_REGEN_DISABLED there was
--- nothing to read. So this is also called on every target change during the fight,
--- and it only OVERWRITES what it has when the new reading is better — a real npcID
--- beats a blank, and nothing ever downgrades a name we already got.
local function NoteTarget()
	local name
	if UnitName then
		local ok, n = pcall(UnitName, "target")
		-- A hostile name is a secret in 12.x, and a secret string passes type() just
		-- like the GUID did. Only keep it when it is genuinely readable; the npcID is
		-- the identifier that matters anyway.
		if ok and type(n) == "string" and not Secret(n) then
			name = n
		end
	end
	local npcID = NpcIdFromUnit("target")
	if not pendingTarget then
		pendingTarget = {}
	end
	-- Upgrade only. A later target change must not blank out the rare we read at the
	-- pull just because we are now looking at an add, or at nothing.
	if npcID and not pendingTarget.npcID then
		pendingTarget.npcID = npcID
	end
	if name and not pendingTarget.name then
		pendingTarget.name = name
	end
end

local function AfterCombat()
	local store = Store()
	if not store then
		return
	end
	-- Diagnostics, written every time so the file answers "did this even run?".
	store.combats = (store.combats or 0) + 1
	store.baselineCount = baselineCount
	store.hadBaseline = baseline ~= nil
	if not baseline then
		return
	end
	if #store.found >= MAX_FOUND then
		return
	end

	local now, nowCount = Sweep()
	store.lastSweepCount = nowCount
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
			baselineCount = baselineCount + 1
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
end

--- Sweep now, then again a little later.
---
--- The flag is set by the server, and PLAYER_REGEN_ENABLED fires the instant combat
--- ends locally — the two are not the same moment. Sweeping once, immediately, would
--- read the world as it was just before the kill was credited. Three passes cover a
--- slow response without turning this into a ticker; pendingTarget is only released
--- after the last one so a late flag still gets paired with the right enemy.
local function AfterCombatPasses()
	pcall(AfterCombat)
	if C_Timer and C_Timer.After then
		C_Timer.After(3, function() pcall(AfterCombat) end)
		C_Timer.After(9, function()
			pcall(AfterCombat)
			pendingTarget = nil
		end)
	else
		pendingTarget = nil
	end
end

local ev = CreateFrame("Frame")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_REGEN_DISABLED" then
		pendingTarget = nil -- a fresh fight; NoteTarget only upgrades, never clears
		NoteTarget()
	elseif event == "PLAYER_TARGET_CHANGED" then
		-- Only while fighting, and only to fill gaps. This is what catches the case
		-- where something jumped you before you had targeted it.
		if InCombatLockdown and InCombatLockdown() then
			NoteTarget()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		AfterCombatPasses()
	end
end)

local function SetRunning(on)
	if on then
		ev:RegisterEvent("PLAYER_REGEN_DISABLED")
		ev:RegisterEvent("PLAYER_REGEN_ENABLED")
		ev:RegisterEvent("PLAYER_TARGET_CHANGED")
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

	-- `/mh questdiff check <id>` — is this one quest flagged for the character I am on?
	--
	-- Two questions hang on this and neither is worth guessing at. Is the flag per
	-- character or account-wide? Log onto an alt and ask. Does it reset daily? Ask
	-- again tomorrow. Both answers decide whether a rare that has already been killed
	-- can be measured again at all, and the alternative to asking is copying a
	-- character to the PTR on a hunch.
	local checkID = tonumber(arg and arg:match("^check%s+(%d+)$"))
	if checkID then
		if not IsDone then
			print(("%s check: C_QuestLog.IsQuestFlaggedCompleted is missing."):format(p))
			return
		end
		local ok, done = pcall(IsDone, checkID)
		if not ok then
			print(("%s check %d: the call failed."):format(p, checkID))
			return
		end
		print(("%s quest %d is %s for this character."):format(
			p, checkID, done and "|cff40ff40COMPLETED|r" or "|cffff6060NOT completed|r"))
		return
	end

	-- `/mh questdiff probe` — where do this character's completed quests actually live?
	--
	-- The baseline came back 0 for 88000..112000, and that number alone cannot say
	-- whether IsQuestFlaggedCompleted reads nothing at all or whether Midnight's ids
	-- simply sit outside the window. A character who has played for years has
	-- thousands of completed quests spread over the whole history of the game, so a
	-- sweep from 1 upwards is a positive control: if the low bands come back empty
	-- too, the call is unusable and this approach is finished. If they fill up and
	-- only the top is empty, the window was wrong and nothing else was.
	if arg == "probe" then
		local BAND = 10000
		local TOP = 150000
		local bands, total, highest = {}, 0, 0
		local ok, err = pcall(function()
			for id = 1, TOP do
				if IsDone(id) then
					local b = math.floor(id / BAND)
					bands[b] = (bands[b] or 0) + 1
					total = total + 1
					highest = id
				end
			end
		end)
		if not ok then
			print(("%s probe FAILED at once: %s"):format(p, tostring(err)))
			print("   |cff9d9d9dThe call cannot be used here. That is the answer.|r")
			return
		end
		print(("%s probe: %d completed quests in 1..%d, highest id %d."):format(
			p, total, TOP, highest))
		for b = 0, math.floor(TOP / BAND) do
			if bands[b] then
				print(("   %6d-%6d : %d"):format(b * BAND, (b + 1) * BAND - 1, bands[b]))
			end
		end
		if total == 0 then
			print("   |cff9d9d9dNothing anywhere — the call returns false for everything.|r")
		end
		return
	end

	-- `/mh questdiff now` — force a pass without waiting for combat to end. The way
	-- to test the machinery on demand: kill something, type this, look at the count.
	if arg == "now" then
		local store = Store()
		AfterCombatPasses()
		print(("%s quest diff: baseline %d, %d recorded so far."):format(
			p, baselineCount, store and #store.found or 0))
		return
	end

	ns.db.questDiffOn = not ns.db.questDiffOn
	if ns.db.questDiffOn then
		local n
		baseline, n = Sweep()
		baselineCount = n
		local store = Store()
		if store then
			store.baselineCount = n
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
		local n
		baseline, n = Sweep()
		baselineCount = n
		local store = Store()
		if store then
			store.baselineCount = n
		end
		SetRunning(true)
	end
end)
