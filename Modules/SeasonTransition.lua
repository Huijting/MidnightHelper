--[[
	Midnight Helper — Season transition logic (Design Spec 05).
	Two-phase, signal-driven S1→S2 checklist:
	  Phase A "closing"  — while 12.0.7 / M+ Season 1 is live (finish-before-reset).
	  Phase B "prep"     — once the client is on 12.1 (lead-in, unlock, alts).
	  Phase C "season"   — once C_MythicPlus confirms the S2 season id is live.

	The interface build flips exactly on patch day; the M+ season id flips exactly
	when S2 opens (~1 week later). Until an id is known/verified, we never claim it.

	Public API (Home-compatible, like ns.GetResetRoutineSteps):
	  ns.GetSeasonPhase()               -> "closing" | "prep" | "season"
	  ns.GetSeasonTransitionSteps()     -> { { text, color, status, onClick }, ... }
	  ns.ToggleSeasonManual(id)         -> flip a manual-tick item
	  ns.PrintSeasonTransitionDiagnostics()  -> /mh season (verifies ids in-game)
]]

local _, ns = ...

-- ---------------------------------------------------------------- phase detection
local function ClientBuild()
	return select(4, GetBuildInfo()) or 0 -- interface number, e.g. 120007
end

local function IsPatchLive()
	local b = ns.SEASON2 and ns.SEASON2.patchInterface
	return b ~= nil and ClientBuild() >= b
end

local function IsSeasonLive()
	local id = ns.SEASON2 and ns.SEASON2.mplusSeasonId
	if not id then
		return false -- never claim the season without a verified id
	end
	if C_MythicPlus and C_MythicPlus.GetCurrentSeason then
		return C_MythicPlus.GetCurrentSeason() == id
	end
	return false
end

function ns.GetSeasonPhase()
	if IsSeasonLive() then
		return "season"
	end
	if IsPatchLive() then
		return "prep"
	end
	return "closing"
end

-- Newcomer = a character that provably did NOT engage Season 1. never-lie: we only
-- ever conclude "not a newcomer" from a real signal (an M+ score). A zero score does
-- NOT prove they skipped S1 (they may have raided), so we return nil (uncertain) and
-- the UI keeps showing the checklist WITH a dismiss — never a silent hide on a guess.
-- Returns (isNewcomer, mplusScore): false = engaged S1; nil = uncertain.
function ns.IsSeasonNewcomer()
	local score = 0
	if C_MythicPlus and C_MythicPlus.GetOverallDungeonScore then
		score = C_MythicPlus.GetOverallDungeonScore() or 0
	end
	if score and score > 0 then
		return false, score
	end
	return nil, score
end

-- ---------------------------------------------------------------- status resolvers
-- Each returns status ("done"/"todo"/"unknown") and, where it can, a resolved name
-- so /mh season can prove the id maps to the intended achievement/quest.
local function achievStatus(id)
	if not id then
		return "unknown"
	end
	local _, name, _, completed = GetAchievementInfo(id)
	if not name then
		return "unknown"
	end
	return completed and "done" or "todo", name
end

local function questStatus(id)
	if not id or not C_QuestLog then
		return "unknown"
	end
	local name
	if C_QuestLog.GetTitleForQuestID then
		name = C_QuestLog.GetTitleForQuestID(id)
	end
	local done = C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(id)
	return (done and "done" or "todo"), name
end

local function mountStatus(id)
	if not id or not C_MountJournal or not C_MountJournal.GetMountInfoByID then
		return "unknown"
	end
	local info = { C_MountJournal.GetMountInfoByID(id) }
	local name, collected = info[1], info[11]
	if name == nil and collected == nil then
		return "unknown"
	end
	return (collected and "done" or "todo"), name
end

-- ---------------------------------------------------------------- manual ticks (SV)
local function sdb()
	MidnightHelperDB = MidnightHelperDB or {}
	local t = MidnightHelperDB.seasonTransition
	if type(t) ~= "table" then
		t = { manualDone = {}, dismissedCard = false, lastPhase = "closing" }
		MidnightHelperDB.seasonTransition = t
	end
	t.manualDone = t.manualDone or {}
	return t
end

-- status ("done"/"todo"/"unknown") + optional resolved name for one item.
local function itemStatus(item)
	if item.achiev then
		return achievStatus(item.achiev)
	elseif item.quest then
		return questStatus(item.quest)
	elseif item.mount then
		return mountStatus(item.mount)
	end
	-- manual: only ever "done" (hand-ticked) or "unknown" (awaiting a tick) — never
	-- an auto "todo" we can't back up.
	return sdb().manualDone[item.id] and "done" or "unknown"
end

function ns.ToggleSeasonManual(id)
	local t = sdb()
	if t.manualDone[id] then
		t.manualDone[id] = nil
	else
		t.manualDone[id] = true
	end
	if ns.RefreshHomePanel then
		ns.RefreshHomePanel()
	end
	return t.manualDone[id] == true
end

-- Dismiss: the Home card can be hidden, but it comes back on a phase change (a new
-- phase is new, relevant information the player should see once).
local function phaseGate()
	local t = sdb()
	local phase = ns.GetSeasonPhase()
	if t.lastPhase ~= phase then
		t.lastPhase = phase
		t.dismissedCard = false
	end
	return phase, t
end

function ns.IsSeasonCardDismissed()
	local _, t = phaseGate()
	return t.dismissedCard == true
end

function ns.DismissSeasonCard()
	local t = sdb()
	t.dismissedCard = true
	if ns.RefreshHomePanel then
		ns.RefreshHomePanel()
	end
end

-- ---------------------------------------------------------------- Home-compatible steps
local function L(key)
	return (ns.L and ns:L(key)) or key
end

-- color: good (done) | warn (closing todo, door closing) | soft (prep todo) | dim (manual/unknown)
function ns.GetSeasonTransitionSteps()
	local phase = ns.GetSeasonPhase()
	local steps = {}

	local function push(item, todoColor)
		local status = itemStatus(item)
		local color = (status == "done") and "good" or (status == "todo" and todoColor or "dim")
		local onClick
		if item.manual then
			onClick = function()
				ns.ToggleSeasonManual(item.id)
			end
		end
		steps[#steps + 1] = { text = L(item.textKey), color = color, status = status, onClick = onClick }
	end

	if phase == "closing" then
		for _, item in ipairs(ns.SEASON_TRANSITION.closing) do
			push(item, "warn") -- the door is closing → higher urgency
		end
	else
		for _, item in ipairs(ns.SEASON_TRANSITION.prep) do
			push(item, "soft")
		end
		if phase == "prep" then
			steps[#steps + 1] = { text = L("ST_SEASON_SOON"), color = "soft" }
		end
	end

	return steps
end

-- ---------------------------------------------------------------- /mh season diagnostic
function ns.PrintSeasonTransitionDiagnostics()
	local prefix = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local phase = ns.GetSeasonPhase()
	print(("%s Season transition — phase |cffffffff%s|r"):format(prefix, phase))
	print(("   client build %d · 12.1 gate %s · S2 M+ season id %s"):format(
		ClientBuild(),
		tostring(ns.SEASON2 and ns.SEASON2.patchInterface),
		tostring(ns.SEASON2 and ns.SEASON2.mplusSeasonId)
	))
	local newcomer, score = ns.IsSeasonNewcomer()
	print(("   season newcomer: %s (M+ score %s) · card dismissed: %s"):format(
		newcomer == false and "no" or (newcomer == nil and "unknown" or "yes"),
		tostring(score),
		tostring(ns.IsSeasonCardDismissed and ns.IsSeasonCardDismissed())
	))

	local function report(label, list)
		print(("   |cffe8c36a%s|r"):format(label))
		for _, item in ipairs(list) do
			local status, name = itemStatus(item)
			local src = item.achiev and ("ach " .. item.achiev)
				or item.quest and ("quest " .. item.quest)
				or item.mount and ("mount " .. item.mount)
				or "manual"
			local mark = (status == "done") and "|cff44ff44done|r"
				or (status == "todo") and "|cffffcc00todo|r"
				or "|cff888888unknown|r"
			print(("     • %-8s %-12s %s  → %s%s"):format(
				item.id, src, mark, L(item.textKey),
				name and ("  |cff888888[" .. name .. "]|r") or ""
			))
		end
	end

	report("closing (Season 1)", ns.SEASON_TRANSITION.closing)
	report("prep (Season 2)", ns.SEASON_TRANSITION.prep)
	print("   Verify each resolved [name] matches the intended reward before it is trusted.")
end
