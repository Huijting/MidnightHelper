--[[
	Reset Routine — "what do I do after the weekly reset, in which order?"
	Pure logic for the Home dashboard block: an ordered, per-character list of
	claim/pick-up steps with live status, plus a TomTom route along the stops
	that are still open (vault -> Bazaar hub -> Work Order station).

	never-lie rules:
	  - Every step states only what a real signal confirms (live vault API,
	    quest flags/log, GetRitualWeeklyHint states). Steps whose state cannot
	    be read are omitted entirely instead of guessed.
	  - Trainer weeklies only appear for owned professions whose weekly quest
	    ID is in-game verified (ns.PROF_ACADEMY.weekly.trainerQuests).
	  - The Great Vault chest coordinate (Silvermoon bank, neutral wing) is
	    the same one the VaultReminder popup waypoint already uses in-game.

	Public API:
	  ns.GetResetRoutineSteps() -> array of { text, color, onClick } where
	    color is "good" | "warn" | "soft" | "dim" (Home maps these to its own
	    palette). Steps are pre-ordered; Home prefixes "1." etc.
	  ns.StartResetRoute() -> clears TomTom and queues pins for the OPEN stops
	    in order; only pin 1 gets the crazy arrow + travel UI (Rares pattern),
	    and ns.lastTarget is pointed back at pin 1 so the shared zone-change
	    re-assert restores the right arrow (see the 9 Jun treasure-arrow saga).
]]

local _, ns = ...

-- Shared Void Assaults / Ritual Sites hub, 2nd floor of The Bazaar (Lilatha).
local HUB_MAP, HUB_X, HUB_Y = 2393, 48.2, 49.6
-- Great Vault chest: Silvermoon bank, neutral wing. Same coordinate as the
-- VaultReminder popup waypoint (GREAT_VAULT_* in VaultReminder.lua) — keep in
-- sync; backlog: centralize into one ns-level constant.
local VAULT_MAP, VAULT_X, VAULT_Y = 2393, 50.36, 65.19
-- Work Order station fallback (ns.PROF_ACADEMY.workOrderStation wins).
local STATION_MAP, STATION_X, STATION_Y = 2393, 45.0, 55.6
-- Weekly quest givers next to the vault — same spot as the city-guide
-- "weekly_hub" pin (UI.lua SMC_CATEGORIES).
local GIVERS_MAP, GIVERS_X, GIVERS_Y = 2393, 48.95, 64.92

-- Per-giver weekly definitions. Fill ONLY in-game-verified data (dump
-- instructions in TOMORROW.md). Semantics once filled:
--   done   — any listed quest flagged completed (weekly flag = "this week")
--   inlog  — any listed quest in the quest log ("picked up")
--   locked — verified minLevel known and the character is below it
--   pickup — none of the above (eligible, go grab it)
-- quests = {} (no verified IDs) -> NO status claim is made for that giver;
-- minLevel = nil -> no eligibility claim is made (never lie).
-- Liadrin's choice-of-four (one Spark weekly per week, "any" semantics) —
-- Wowhead-verified 10 Jun 2026, in-game confirmation via Rob's dump pending:
--   93766 Midnight: World Quests · 93909 Midnight: Delves ·
--   93910 Midnight: Prey · 93911 Midnight: Dungeons
-- (all "level 90 meta quest" on Wowhead = quest level, NOT the requirement —
-- minLevel stays nil until the real requirement is confirmed in-game).
-- Halduron: rep-dungeon weekly — a DIFFERENT dungeon (= different quest ID)
-- each week. Old weekly flags reset at the weekly reset, so "any" semantics
-- stays correct; add each newly-dumped week's ID to the list.
--   93761 "Windrunner Spire" (Rob in-game, week of 10 Jun 2026)
-- Aethas: weekend/event weeklies (can offer more than one at once; "any"
-- = done as soon as one is turned in — good enough for the routine):
--   93600 "The Arena Calls" + 94836 "Late Night Training: Week 1 of 3"
--   (Rob in-game, 10 Jun 2026; future events will add IDs here).
-- minLevel: Robs level-80-test (11 jun, verse warlock) — Liadrin en Aethas
-- bieden op 80 NIETS aan; hun Spark-/event-weeklies zijn endgame-content,
-- dus aanname max level 90 (gedocumenteerde aanname: 81-89 niet apart
-- getest). Halduron biedt op 80 wél een quest aan — een LEVELING-variant
-- ("Hope in the Darkest Corners", XP + Quel'Thalas Adventurer's Cache) —
-- dus géén minLevel daar; dat quest-ID toevoegen zodra gedumpt, dan krijgen
-- levelaars ook echte done/opgepakt-status bij hem.
local GIVER_WEEKLIES = {
	{ key = "liadrin", name = "Lady Liadrin", quests = { 93766, 93909, 93910, 93911 }, minLevel = 90 },
	-- 93761 = dungeon-of-the-week (max level); 95468 = "Hope in the Darkest
	-- Corners", de leveling-variant die Halduron sub-90 aanbiedt (Robs
	-- level-80-warlock, 11 jun) — "any" dekt beide doelgroepen.
	{ key = "halduron", name = "Halduron Brightwing", quests = { 93761, 95468 }, minLevel = nil },
	{ key = "aethas", name = "Aethas Sunreaver", quests = { 93600, 94836 }, minLevel = 90 },
}

local VOID_META_QUEST = 95842 -- "Midnight: Void Assaults"
local VOID_ZONE_WEEKLIES = { 94385, 94386 } -- Eversong / Zul'Aman zone weeklies

-- Profession trainer locations (map 2393), keyed by base skillLine — the
-- trainer weekly is picked up at the TRAINER, not the Work Order station.
-- Coordinates mirror the in-game-verified SMC city-guide pins (UI.lua
-- SMC_CATEGORIES); skillLine IDs match ProfessionAcademyData chapters.
local TRAINER_PINS = {
	[171] = { 47.02, 51.88 }, -- Alchemy
	[164] = { 43.74, 51.33 }, -- Blacksmithing
	[333] = { 47.97, 53.63 }, -- Enchanting (Dolothos)
	[202] = { 43.53, 54.01 }, -- Engineering
	[773] = { 46.78, 51.48 }, -- Inscription
	[755] = { 47.93, 55.15 }, -- Jewelcrafting
	[165] = { 43.15, 55.70 }, -- Leatherworking
	[197] = { 48.25, 54.15 }, -- Tailoring
	[182] = { 48.20, 51.52 }, -- Herbalism
	[186] = { 42.68, 52.84 }, -- Mining
	[393] = { 43.27, 55.59 }, -- Skinning
}

--------------------------------------------------------------------------------
-- Signal helpers (all pcall-guarded)
--------------------------------------------------------------------------------

local function Flagged(qid)
	if not (C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and qid) then
		return false
	end
	local ok, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, qid)
	return ok and done or false
end

local function OnQuest(qid)
	if not (C_QuestLog and C_QuestLog.IsOnQuest and qid) then
		return false
	end
	local ok, has = pcall(C_QuestLog.IsOnQuest, qid)
	return ok and has or false
end

-- true / false / nil (API unavailable -> step omitted, never guessed).
local function VaultReady()
	if C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards then
		local ok, ready = pcall(C_WeeklyRewards.HasAvailableRewards)
		if ok then
			return ready and true or false
		end
	end
	return nil
end

-- "done" | "inlog" | "pickup" | "intro" | nil (unknowable)
local function RitualState()
	if ns.IsRitualWeeklyDone and ns.IsRitualWeeklyDone() then
		return "done"
	end
	if ns.GetRitualWeeklyHint then
		local _, kind = ns.GetRitualWeeklyHint()
		if kind == "inprogress" then
			return "inlog"
		elseif kind == "pickup" then
			return "pickup"
		elseif kind == "intro" or kind == "locked" then
			return "intro"
		end
	end
	return nil
end

-- "done" | "inlog" | "pickup"
local function VoidState()
	if ns.IsVoidAssaultWeeklyDone and ns.IsVoidAssaultWeeklyDone() then
		return "done"
	end
	if OnQuest(VOID_META_QUEST) then
		return "inlog"
	end
	for _, qid in ipairs(VOID_ZONE_WEEKLIES) do
		if OnQuest(qid) then
			return "inlog"
		end
	end
	return "pickup"
end

-- Owned primary professions, split into trainer weeklies with a verified
-- quest ID (tracked) and owned profs without one (untracked names — shown as
-- an honest "not tracked yet" line instead of silently disappearing).
local function OwnedProfTrainerWeeklies()
	local tracked, untracked = {}, {}
	if not GetProfessions or not GetProfessionInfo then
		return tracked, untracked
	end
	local quests = ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly and ns.PROF_ACADEMY.weekly.trainerQuests
	if type(quests) ~= "table" then
		quests = {}
	end
	local okP, p1, p2 = pcall(GetProfessions)
	if not okP then
		return tracked, untracked
	end
	local slots = {}
	if p1 then
		slots[#slots + 1] = p1
	end
	if p2 then
		slots[#slots + 1] = p2
	end
	for _, slot in ipairs(slots) do
		local ok, name, _, skillLevel, _, _, _, skillLine = pcall(GetProfessionInfo, slot)
		if ok and skillLine then
			local q = quests[skillLine]
			if type(q) == "number" then
				q = { q } -- backward compat with the old single-ID form
			end
			if type(q) == "table" and #q > 0 then
				tracked[#tracked + 1] = {
					name = name or "?",
					quests = q,
					skillLine = skillLine,
					skill = math.floor(tonumber(skillLevel) or 0),
				}
			else
				untracked[#untracked + 1] = name or "?"
			end
		end
	end
	return tracked, untracked
end

-- "done" | "inlog" | "locked" | "pickup" | nil (no verified IDs -> no claim)
local function GiverState(def)
	if type(def.quests) ~= "table" or #def.quests == 0 then
		return nil
	end
	for _, qid in ipairs(def.quests) do
		if Flagged(qid) then
			return "done"
		end
	end
	for _, qid in ipairs(def.quests) do
		if OnQuest(qid) then
			return "inlog"
		end
	end
	if def.minLevel and UnitLevel then
		local ok, lvl = pcall(UnitLevel, "player")
		if ok and tonumber(lvl) and lvl < def.minLevel then
			return "locked"
		end
	end
	return "pickup"
end

local function StationCoords()
	local st = ns.PROF_ACADEMY and ns.PROF_ACADEMY.workOrderStation
	if type(st) == "table" and st.mapID and st.x and st.y then
		return st.mapID, st.x, st.y
	end
	return STATION_MAP, STATION_X, STATION_Y
end

--------------------------------------------------------------------------------
-- Routing
--------------------------------------------------------------------------------

local function ClearTomTom()
	if ns.IsTomTomReady and ns.IsTomTomReady() then
		pcall(function()
			_G.TomTom:ClearAllWaypoints()
		end)
	end
end

local function PinLabel(labelKey, labelArg)
	local label = ns:L(labelKey)
	if labelArg then
		label = label:format(labelArg)
	end
	return label
end

local function RouteSingle(mapID, x, y, labelKey, labelArg)
	if not ns.AddSmartTomTomWay then
		return
	end
	ClearTomTom()
	ns.AddSmartTomTomWay(mapID, x, y, PinLabel(labelKey, labelArg))
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

function ns.GetResetRoutineSteps()
	local steps = {}

	-- 1. Great Vault (claim before anything else).
	local ready = VaultReady()
	if ready == true then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VAULT_READY"),
			color = "warn",
			open = true,
			pin = { VAULT_MAP, VAULT_X, VAULT_Y, "HOME_ROUTINE_PIN_VAULT" },
			onClick = function()
				RouteSingle(VAULT_MAP, VAULT_X, VAULT_Y, "HOME_ROUTINE_PIN_VAULT")
			end,
		}
	elseif ready == false then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_VAULT_NONE"), color = "good" }
	end

	-- 2. Weekly quest givers next to the vault. Givers with verified quest IDs
	-- get a real done / picked-up / locked / pickup status; givers without
	-- collapse into one honest "not tracked yet" reminder line + waypoint.
	local giversRoute = function()
		RouteSingle(GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS")
	end
	local untrackedGivers, anyGiverOpen = false, false
	for _, def in ipairs(GIVER_WEEKLIES) do
		local gs = GiverState(def)
		if gs == "done" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_DONE_FMT"):format(def.name), color = "good" }
		elseif gs == "inlog" then
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(def.name),
				color = "prog",
			}
		elseif gs == "locked" then
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_LOCKED_FMT"):format(def.name, def.minLevel),
				color = "dim",
			}
		elseif gs == "pickup" then
			anyGiverOpen = true
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_GIVER_PICKUP_FMT"):format(def.name),
				color = "warn",
				open = true,
				pin = { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" },
				onClick = giversRoute,
			}
		else
			untrackedGivers = true
		end
	end
	if untrackedGivers then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_GIVERS"),
			color = "soft",
			-- Only carry the route pin here when no tracked giver already does.
			open = not anyGiverOpen or nil,
			pin = { GIVERS_MAP, GIVERS_X, GIVERS_Y, "HOME_ROUTINE_PIN_GIVERS" },
			onClick = giversRoute,
		}
	end

	-- 3. Ritual Sites weekly.
	local rs = RitualState()
	if rs == "done" then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_RITUAL_DONE"), color = "good" }
	elseif rs == "inlog" then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_RITUAL_INLOG"),
			color = "prog",
			onClick = function()
				local site = ns.GetActiveRitualSite and ns.GetActiveRitualSite()
				if site and ns.RouteRitualSite then
					ns.RouteRitualSite(site)
				elseif ns.SelectTab then
					ns.SelectTab("world")
				end
			end,
		}
	elseif rs == "pickup" or rs == "intro" then
		steps[#steps + 1] = {
			text = ns:L(rs == "intro" and "HOME_ROUTINE_RITUAL_INTRO" or "HOME_ROUTINE_RITUAL_PICKUP"),
			color = rs == "intro" and "soft" or "warn",
			open = true,
			pin = { HUB_MAP, HUB_X, HUB_Y, "HOME_ROUTINE_PIN_HUB" },
			onClick = function()
				if ns.RouteRitualHub then
					ns.RouteRitualHub()
				end
			end,
		}
	end

	-- 4. Void Assaults weekly (same hub).
	local vs = VoidState()
	if vs == "done" then
		steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_VOID_DONE"), color = "good" }
	elseif vs == "inlog" then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VOID_INLOG"),
			color = "prog",
			onClick = function()
				-- Hybride routing (QoL): volg het live void-weekly-objectief via de
				-- actieve zone-quest; lukt dat niet, val terug op het wereld-tabblad.
				local zone = ns.GetActiveVoidAssaultZone and ns.GetActiveVoidAssaultZone()
				local lbl = (zone and ns.VoidZoneName and ns.VoidZoneName(zone)) or "Void Assault"
				if zone and zone.weekly and ns.AddSmartQuestRoute
					and ns.AddSmartQuestRoute(zone.weekly, zone.mapID, nil, nil, lbl) then
					return
				end
				if ns.SelectTab then
					ns.SelectTab("world")
				end
			end,
		}
	else
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_VOID_PICKUP"),
			color = "warn",
			open = true,
			pin = { HUB_MAP, HUB_X, HUB_Y, "HOME_ROUTINE_PIN_HUB" },
			onClick = function()
				if ns.RouteRitualHub then
					ns.RouteRitualHub()
				end
			end,
		}
	end

	-- 4b. Extra event-weeklies (datamined quest-IDs). Alleen tonen als relevant:
	-- in je log of gedaan — we asserten geen beschikbaarheid voor event-gated
	-- weeklies (never-lie). Hergebruikt de generieke GIVER-fmt-keys (alle 6 talen).
	local EXTRA_WEEKLIES = {
		{ q = 89507, name = "Abundant Offerings" },
		{ q = 94446, name = "A Nightmarish Task" },
		{ q = 93784, name = "Gnawing Curiosity" },
		{ q = 93767, name = "Arcantina" },
		{ q = 94623, name = "Building the Voidforge" }, -- Decimus @ Voidstorm (PTR_12.0.7_DATA)
		-- Nog te bevestigen (geen quest-ID; in-game capturen): Beacon of Hope,
		-- Prey Hunts, Saltheril's Soiree, Bonus Event. Voeg toe zodra ID bekend.
	}
	for _, w in ipairs(EXTRA_WEEKLIES) do
		local st = ns.GetWeeklyQuestStatus and ns.GetWeeklyQuestStatus(w.q)
		if st == "done" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_DONE_FMT"):format(w.name), color = "good" }
		elseif st == "turnin" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(w.name), color = "warn" }
		elseif st == "active" then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_GIVER_INLOG_FMT"):format(w.name), color = "prog" }
		end
	end

	-- 5. Profession trainer weeklies. Tracked = verified quest ID; pickup
	-- routes to that profession's trainer (city-guide pin), not the station.
	local stMap, stX, stY = StationCoords()
	local tracked, untracked = OwnedProfTrainerWeeklies()
	for _, prof in ipairs(tracked) do
		-- Rotating weekly variants: any flagged = done, any in log = picked up.
		local done, inlog = false, false
		for _, qid in ipairs(prof.quests) do
			if Flagged(qid) then
				done = true
				break
			end
		end
		if not done then
			for _, qid in ipairs(prof.quests) do
				if OnQuest(qid) then
					inlog = true
					break
				end
			end
		end
		if done then
			steps[#steps + 1] = { text = ns:L("HOME_ROUTINE_TRAINER_DONE_FMT"):format(prof.name), color = "good" }
		elseif inlog then
			steps[#steps + 1] = {
				text = ns:L("HOME_ROUTINE_TRAINER_INLOG_FMT"):format(prof.name),
				color = "prog",
			}
		else
			-- Crafting profs (service quest) pick up at the Work Order
			-- station; Enchanting + gatherers at their profession trainer.
			local serviceProfs = ns.PROF_ACADEMY and ns.PROF_ACADEMY.weekly and ns.PROF_ACADEMY.weekly.serviceProfs
			local isService = serviceProfs and serviceProfs[prof.skillLine] or false
			-- Trainer-type weeklies are skill-gated: Enchanting verifiably
			-- needs skill 25, and Rob's fresh skill-1 Herbalism got nothing at
			-- the trainer (11 jun) while his leveled alt did. Below 25 we say
			-- so honestly instead of sending you to an empty trainer. Service
			-- quests are NOT skill-gated (fresh skill-1 Alchemy worked).
			if not isService and (prof.skill or 0) < 25 then
				steps[#steps + 1] = {
					text = ns:L("HOME_ROUTINE_TRAINER_LOWSKILL_FMT"):format(prof.name),
					color = "dim",
				}
			else
			local px, py, textKey, pinKey, pinArg
			if isService then
				px, py = stX, stY
				textKey = "HOME_ROUTINE_SERVICE_PICKUP_FMT"
				pinKey, pinArg = "HOME_ROUTINE_PIN_STATION", nil
			else
				local pin = TRAINER_PINS[prof.skillLine]
				px, py = pin and pin[1] or stX, pin and pin[2] or stY
				textKey = "HOME_ROUTINE_TRAINER_PICKUP_FMT"
				pinKey, pinArg = "HOME_ROUTINE_PIN_TRAINER_FMT", prof.name
			end
			steps[#steps + 1] = {
				text = ns:L(textKey):format(prof.name),
				color = "warn",
				open = true,
				pin = { stMap, px, py, pinKey, pinArg },
				onClick = function()
					RouteSingle(stMap, px, py, pinKey, pinArg)
				end,
			}
			end
		end
	end
	if #untracked > 0 then
		steps[#steps + 1] = {
			text = ns:L("HOME_ROUTINE_TRAINER_UNTRACKED_FMT"):format(table.concat(untracked, ", ")),
			color = "dim",
			onClick = function()
				if ns.SelectTab then
					ns.SelectTab("professions")
				end
			end,
		}
	end

	return steps
end

-- Open stops, routine order, duplicate coordinates (ritual + void share the
-- hub; the giver pins sit next to the vault) collapsed into one pin each.
local function ComputeOpenPins()
	local pins, seen = {}, {}
	local okSteps, steps = pcall(ns.GetResetRoutineSteps)
	if not okSteps or type(steps) ~= "table" then
		return pins
	end
	for _, step in ipairs(steps) do
		if step.open and step.pin then
			local key = table.concat({ step.pin[1], step.pin[2], step.pin[3] }, ":")
			if not seen[key] then
				seen[key] = true
				pins[#pins + 1] = step.pin
			end
		end
	end
	return pins
end

local function PinsSignature(pins)
	local parts = {}
	for i, p in ipairs(pins) do
		parts[i] = table.concat({ p[1], p[2], p[3] }, ":")
	end
	return table.concat(parts, "|")
end

-- Active-route state. The reset route, the treasure route and the delve route
-- all share the single crazy arrow + ns.lastTarget, so a tiny owner token
-- (ns._mhRouteOwner) arbitrates: whoever issued the live arrow last owns it,
-- and the others stand down instead of fighting it on every event.
local routeActive = false
local routeSig
local advancePending = false
local advanceFrame

local function IssueRoute(pins)
	ClearTomTom()
	for i, pin in ipairs(pins) do
		-- Only pin 1 gets the crazy arrow + travel UI (Rares pattern); the rest
		-- are silent waypoints. AddSmartTomTomWay sets ns.lastTarget to the last
		-- pin, so we re-point it at pin 1 afterwards (treasure-arrow saga).
		ns.AddSmartTomTomWay(pin[1], pin[2], pin[3], PinLabel(pin[4], pin[5]), i > 1, i > 1)
	end
	local first = pins[1]
	ns.lastTarget = { mapID = first[1], x = first[2], y = first[3], name = PinLabel(first[4], first[5]) }
	routeSig = PinsSignature(pins)
end

-- Let another navigation feature take the arrow (treasure / delve call this).
function ns.CancelResetRoute()
	routeActive = false
	routeSig = nil
end

-- Re-evaluate the open stops; if the still-open set changed (a stop got claimed
-- or picked up), move the arrow to the next open stop. Stand down when another
-- feature owns the arrow, or when every stop is done.
local function AdvanceResetRoute()
	if not routeActive then
		return
	end
	if ns._mhRouteOwner and ns._mhRouteOwner ~= "reset" then
		ns.CancelResetRoute()
		return
	end
	local pins = ComputeOpenPins()
	if #pins == 0 then
		ClearTomTom()
		ns.lastTarget = nil
		routeActive = false
		routeSig = nil
		if ns._mhRouteOwner == "reset" then
			ns._mhRouteOwner = nil
		end
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_DONE")
		end
		return
	end
	if PinsSignature(pins) ~= routeSig then
		IssueRoute(pins) -- arrow now points at the next still-open stop
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_NEXT_FMT", PinLabel(pins[1][4], pins[1][5]))
		end
	end
end

local function ScheduleAdvance()
	if not routeActive or advancePending then
		return
	end
	advancePending = true
	if C_Timer and C_Timer.After then
		C_Timer.After(1.0, function() -- debounce QUEST_LOG_UPDATE bursts
			advancePending = false
			AdvanceResetRoute()
		end)
	else
		advancePending = false
		AdvanceResetRoute()
	end
end

local function EnsureAdvanceFrame()
	if advanceFrame then
		return
	end
	advanceFrame = CreateFrame("Frame")
	advanceFrame:RegisterEvent("WEEKLY_REWARDS_UPDATE") -- vault claimed
	advanceFrame:RegisterEvent("QUEST_ACCEPTED") -- weekly picked up
	advanceFrame:RegisterEvent("QUEST_REMOVED")
	advanceFrame:RegisterEvent("QUEST_TURNED_IN")
	advanceFrame:RegisterEvent("QUEST_LOG_UPDATE")
	advanceFrame:SetScript("OnEvent", function()
		ScheduleAdvance()
	end)
end

-- Set the TomTom route along the still-open stops and keep the arrow advancing
-- to the next stop as each one gets done.
function ns.StartResetRoute()
	if not ns.AddSmartTomTomWay then
		return
	end
	local pins = ComputeOpenPins()
	if #pins == 0 then
		if ns.PrintChatKey then
			ns:PrintChatKey("HOME_ROUTINE_ROUTE_EMPTY")
		end
		ns.CancelResetRoute()
		return
	end
	ns._mhRouteOwner = "reset" -- claim the shared arrow (treasure/delve yield)
	IssueRoute(pins)
	routeActive = true
	EnsureAdvanceFrame()
	if ns.PrintChatKey then
		ns:PrintChatKey("HOME_ROUTINE_ROUTE_SET_FMT", #pins)
	end
end
