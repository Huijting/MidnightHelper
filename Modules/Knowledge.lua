--[[
	Midnight Helper — Knowledge registry and diagnostics (RFC-002, phase 3).

	Owns the three things the runtime should not:
	  • the engine-side inputs the evaluator is not allowed to read for itself
	    (manual disable flags, and later the stale bookkeeping);
	  • the approval gate — what may reach a player and what may not;
	  • /mh know, the debug sink.

	NOTHING HERE IS PLAYER-VISIBLE, and that is enforced rather than promised. Every
	knowledge object still carries status = "review", which the schema defines as "not
	player-visible", and IsPlayerVisible() below refuses anything that is not "approved".
	The diagnostics deliberately print copy KEYS, never resolved text: the copy does not
	exist in Locales yet, so resolving would put raw keys on screen — the exact failure
	from 22 July, arrived at from a different direction.

	Long output goes to SavedVariables, not to chat:
	    /mhknow           one-screen summary
	    /mhknow save      full request + response into ns.db.knowledgeProbe, then /reload

	Registered in MidnightHelper.toc since 2026-08-01, so this file now runs at login.
	tools/check_knowledge_inert.lua guards what that is allowed to mean: it records every
	global read and written while the file loads, and fails on CreateFrame, RegisterEvent,
	hooksecurefunc and friends. One global is written on purpose, SLASH_MHKNOW1.
]]

local _, ns = ...
ns = ns or {}

local M = {}

--------------------------------------------------------------------------------
-- Registry
--------------------------------------------------------------------------------

--- The compiled catalog, or nil when KnowledgeData_S1.lua has not loaded.
function M.GetData()
	return ns.KnowledgeData
end

--- Engine-owned inputs. The evaluator is a pure function and may not read the saved
--- variables itself, so they are collected here and passed in. Absent means unknown,
--- which is why nothing is defaulted to false.
--- @return table engine
function M.GetEngineInputs()
	local engine = {}
	local db = ns.db
	if type(db) == "table" and type(db.knowledge) == "table" and type(db.knowledge.disabled) == "table" then
		engine.disabled = db.knowledge.disabled
	end
	return engine
end

--- Has this object been switched off by hand? (RFC-002 C4.)
function M.IsDisabled(objectId)
	local db = ns.db
	return type(db) == "table"
		and type(db.knowledge) == "table"
		and type(db.knowledge.disabled) == "table"
		and db.knowledge.disabled[objectId] == true
end

--- The approval gate, in code. A knowledge object may only reach a player when every
--- one of these holds; today none of them do, because the whole catalog is "review".
--- @return boolean visible, string reason
function M.IsPlayerVisible(obj)
	if type(obj) ~= "table" then
		return false, "no object"
	end
	if obj.status ~= "approved" then
		return false, ("status is %q, not \"approved\""):format(tostring(obj.status))
	end
	if M.IsDisabled(obj.id) then
		return false, "disabled by hand"
	end
	return true, "approved"
end

--- Count how many objects would be allowed to speak to a player right now.
function M.CountPlayerVisible()
	local data = M.GetData()
	if not data then
		return 0, 0
	end
	local visible = 0
	for i = 1, #data.objects do
		if M.IsPlayerVisible(data.objects[i]) then
			visible = visible + 1
		end
	end
	return visible, #data.objects
end

--------------------------------------------------------------------------------
-- Diagnostics — /mh know
--------------------------------------------------------------------------------

local function prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
end

local function shown(value)
	if value == nil then
		return "|cff8a8f98unknown|r"
	end
	if value == true then
		return "|cff40c040true|r"
	end
	if value == false then
		return "|cffff8080false|r"
	end
	return tostring(value)
end

local function joined(list)
	if type(list) ~= "table" or #list == 0 then
		return "|cff8a8f98none|r"
	end
	return table.concat(list, ", ")
end

--- One screen. Everything longer belongs in SavedVariables.
function ns.PrintKnowledge(arg)
	local out = prefix()
	local data = M.GetData()
	local runtime = ns.KnowledgeRuntime

	if not data then
		print(out .. " Knowledge data is not loaded (Modules/KnowledgeData_S1.lua is not in the .toc yet).")
		return
	end
	if not (runtime and runtime.BuildRequest and runtime.Evaluate) then
		print(out .. " Knowledge runtime is not loaded (Modules/KnowledgeRuntime.lua is not in the .toc yet).")
		return
	end

	local okReq, request, notes = pcall(runtime.BuildRequest)
	if not okReq then
		print(out .. " request builder failed: " .. tostring(request))
		return
	end

	local okEval, response = pcall(runtime.Evaluate, request, data, M.GetEngineInputs())
	if not okEval then
		print(out .. " evaluator failed: " .. tostring(response))
		return
	end

	local visible, total = M.CountPlayerVisible()
	print(("%s Knowledge — catalog %s, %d objects, %d player-visible"):format(
		out, tostring(data.catalogVersion), total, visible))
	print(("   client: interface %s, M+ season %s"):format(
		shown(request.interface), shown(request.mythic_plus_season_id)))
	print(("   vault ready: %s   item level: %s   runs logged: %d"):format(
		shown(request.weekly_reward_state and request.weekly_reward_state.great_vault_reward_ready),
		shown(request.player_state and request.player_state.item_level),
		#(request.recent_activity_history or {})))

	print(("   |cff40c040answer|r: %s / confidence %s"):format(
		tostring(response.status), tostring(response.confidence)))
	-- Copy KEYS, never resolved text: the strings do not exist in Locales yet.
	print(("   title key: %s"):format(tostring(response.title_key)))
	print(("   from: %s"):format(joined(response.knowledge_object_ids)))
	print(("   missing inputs: %s"):format(joined(response.missing_inputs)))
	print(("   assumed inputs: %s"):format(joined(response.assumed_inputs)))
	if response.stale_object_ids and #response.stale_object_ids > 0 then
		print(("   |cffff8080stale|r: %s"):format(joined(response.stale_object_ids)))
	end

	if type(notes) == "table" and #notes > 0 then
		print(("   |cff8a8f98could not read (%d):|r"):format(#notes))
		for i = 1, #notes do
			print("      " .. notes[i])
		end
	end

	if arg == "save" then
		if type(ns.db) ~= "table" then
			print(out .. " |cffff8080cannot save: saved variables are not ready|r")
			return
		end
		ns.db.knowledgeProbe = {
			at = time(),
			catalogVersion = data.catalogVersion,
			request = request,
			response = response,
			notes = notes,
		}
		print(out .. " saved to ns.db.knowledgeProbe — now |cffffffff/reload|r so it reaches the file.")
	else
		print(out .. " |cff8a8f98nothing above is shown to players; every object is status=review.|r")
	end
end

--------------------------------------------------------------------------------
-- /mhknow probe — does a readable ritual tier exist at all? (RFC-002 §5 step 5)
--------------------------------------------------------------------------------

--[[
	The request builder reports one blocker above all others: ritual.available_tiers.
	Nothing in this addon reads which Ritual Site tiers a character has unlocked, so the
	tier selector is never applicable and says nothing. Rob's saved probe then showed a
	second, independent one: across 27 logged ritual runs the tier was 0 every single
	time, so even the reliability signals could never become true.

	Before anyone designs around that, the question has to be asked properly: does the
	client expose a tier at all, under ANY name?

	This probe ENUMERATES rather than guesses, the same discipline as /mh roleset in
	ApiProbe.lua. A probe built on invented names reports "not found" for two different
	reasons — the name is wrong, or the thing does not exist — and you cannot tell them
	apart afterwards. So part one walks what the client actually has, and part two calls
	only functions this repo has already verified in use elsewhere.

	    /mhknow probe        summary to chat
	    /mhknow probe save   everything into ns.db.knowledgeProbeApi, then /reload

	Run it TWICE to be worth anything: once anywhere, and once while standing inside a
	Ritual Site scenario. Part two is empty outside a scenario, and "nothing found" out
	in the world proves nothing at all.
]]

local PROBE_WORDS = { "ritual", "scenario", "difficulty", "recommend", "itemlevel", "tier" }

local function nameLooksRelevant(name)
	local lower = tostring(name):lower()
	for i = 1, #PROBE_WORDS do
		if lower:find(PROBE_WORDS[i], 1, true) then
			return true
		end
	end
	return false
end

--- Every global, and every field of every C_ namespace, whose NAME mentions one of the
--- words above. This says what exists; it does not call anything.
local function SweepApiSurface()
	local hits = { globals = {}, namespaces = {} }

	for key, value in pairs(_G) do
		if type(key) == "string" then
			if nameLooksRelevant(key) then
				hits.globals[#hits.globals + 1] = key .. "  (" .. type(value) .. ")"
			end
			-- Walk C_ tables even when their own name says nothing: C_Scenario holds the
			-- step and criteria calls, and its name does not contain "tier".
			if key:sub(1, 2) == "C_" and type(value) == "table" then
				local fields = {}
				local ok = pcall(function()
					for fieldName in pairs(value) do
						if type(fieldName) == "string" and nameLooksRelevant(fieldName) then
							fields[#fields + 1] = fieldName
						end
					end
				end)
				if ok and #fields > 0 then
					table.sort(fields)
					hits.namespaces[#hits.namespaces + 1] = { name = key, fields = fields }
				end
			end
		end
	end

	table.sort(hits.globals)
	table.sort(hits.namespaces, function(a, b) return a.name < b.name end)
	return hits
end

--- Call only what this repo already uses somewhere, so nothing here is a guessed name.
--- Each source names the file that verified it.
local function ReadLiveScenario()
	local out = {}

	local function capture(label, source, fn, ...)
		if type(fn) ~= "function" then
			out[#out + 1] = { label = label, source = source, value = "API ABSENT" }
			return
		end
		local packed = { pcall(fn, ...) }
		if not packed[1] then
			out[#out + 1] = { label = label, source = source, value = "ERROR: " .. tostring(packed[2]) }
			return
		end
		-- A bare "table: 0000022864..." answers nothing, and a table is exactly what the
		-- interesting calls return. One level deep is enough to see whether a tier number
		-- or an item level is in there.
		local function describe(value)
			if type(value) ~= "table" then
				return tostring(value)
			end
			local fields, count = {}, 0
			for k, v in pairs(value) do
				count = count + 1
				if count > 24 then
					fields[#fields + 1] = "..."
					break
				end
				if type(v) == "table" then
					local inner = {}
					for k2, v2 in pairs(v) do
						inner[#inner + 1] = tostring(k2) .. "=" .. tostring(v2)
						if #inner >= 8 then
							inner[#inner + 1] = "..."
							break
						end
					end
					table.sort(inner)
					fields[#fields + 1] = tostring(k) .. "={" .. table.concat(inner, " ") .. "}"
				else
					fields[#fields + 1] = tostring(k) .. "=" .. tostring(v)
				end
			end
			table.sort(fields)
			if count == 0 then
				return "{} (empty table)"
			end
			return "{ " .. table.concat(fields, ", ") .. " }"
		end

		local parts = {}
		for i = 2, #packed do
			parts[#parts + 1] = ("[%d] %s"):format(i - 1, describe(packed[i]))
		end
		out[#out + 1] = {
			label = label,
			source = source,
			value = #parts > 0 and table.concat(parts, "  ") or "(no returns)",
		}
	end

	capture("IsInInstance", "used across the addon", IsInInstance)
	capture("GetInstanceInfo", "Modules/DelveHistory.lua", GetInstanceInfo)
	capture("C_Scenario.GetInfo", "Modules/DelveHistory.lua",
		C_Scenario and C_Scenario.GetInfo)
	capture("C_Scenario.GetStepInfo", "Modules/DelveHistory.lua",
		C_Scenario and C_Scenario.GetStepInfo)
	capture("C_Scenario.IsInScenario", "discovered by the sweep, 2026-08-01",
		C_Scenario and C_Scenario.IsInScenario)

	-- DISCOVERED BY THE SWEEP on Rob's own client, 2026-08-01 — not guessed names.
	--
	-- The first sweep explains why "no API reads ritual tiers" looked true: Blizzard
	-- does not call this ritual anything. It calls it a TIERED ENTRANCE, and files the
	-- calls under C_DelvesUI even though the function names say TieredEntrance rather
	-- than Delve. If Ritual Sites run on that same system, this is where a tier and a
	-- suggested item level would live.
	--
	-- Several of these may want arguments. Calling them bare is deliberate: an error
	-- saying "needs an argument" is itself an answer, and far better than inventing a
	-- parameter and reporting whatever comes back.
	capture("C_ScenarioInfo.IsTieredEntranceScenario", "sweep",
		C_ScenarioInfo and C_ScenarioInfo.IsTieredEntranceScenario)
	capture("C_ScenarioInfo.GetScenarioInfo", "sweep",
		C_ScenarioInfo and C_ScenarioInfo.GetScenarioInfo)
	capture("C_ScenarioInfo.GetScenarioStepInfo", "sweep",
		C_ScenarioInfo and C_ScenarioInfo.GetScenarioStepInfo)
	capture("C_DelvesUI.GetActiveDelveTier", "Modules/DelveBossShowcase.lua",
		C_DelvesUI and C_DelvesUI.GetActiveDelveTier)
	capture("C_DelvesUI.GetDelveEntranceTiers", "sweep",
		C_DelvesUI and C_DelvesUI.GetDelveEntranceTiers)
	capture("C_DelvesUI.GetTieredEntranceType", "sweep",
		C_DelvesUI and C_DelvesUI.GetTieredEntranceType)
	capture("C_DelvesUI.GetTieredEntrancePDEID", "sweep",
		C_DelvesUI and C_DelvesUI.GetTieredEntrancePDEID)
	capture("C_DelvesUI.GetWorldTierDifficultyForActivePlayer", "sweep",
		C_DelvesUI and C_DelvesUI.GetWorldTierDifficultyForActivePlayer)

	-- A format string, not a value: printing it shows the placeholder shape, which tells
	-- us what the game expects to fill in and therefore what it can already compute.
	out[#out + 1] = {
		label = "TIERED_ENTRANCE_ILVL_SUGGESTION",
		source = "global string, sweep",
		value = tostring(_G.TIERED_ENTRANCE_ILVL_SUGGESTION),
	}

	-- Rob confirmed the shape of the thing: you click the obelisk, pick a tier, and then
	-- pick six challenges that raise both the reward and the difficulty. That is the
	-- tiered-entrance picker. He is standing in a Tier 6 while GetActiveDelveTier reports
	-- tier = 0, so that accessor does not cover rituals -- yet the game plainly knows the
	-- number, because it is on his screen. These three are where it could still be.
	capture("C_ScenarioInfo.GetTieredEntranceActiveSpells", "sweep — the six chosen challenges",
		C_ScenarioInfo and C_ScenarioInfo.GetTieredEntranceActiveSpells)
	capture("C_DelvesUI.GetTieredEntranceOptionalAffixTraitTreeID", "sweep",
		C_DelvesUI and C_DelvesUI.GetTieredEntranceOptionalAffixTraitTreeID)
	capture("C_DelvesUI.IsDelveEntranceTierEnabled", "sweep",
		C_DelvesUI and C_DelvesUI.IsDelveEntranceTierEnabled)

	-- NOT called, deliberately: SelectDelveEntranceTier would change Rob's difficulty,
	-- and RequestPartyEligibilityForDelveTiers sends a server request. A probe reads.

	-- The scenario header widget is the likeliest home for a displayed tier: GetStepInfo
	-- handed back widgetSetID 2102, and there is a GetScenarioHeaderDelvesWidgetVisualizationInfo.
	-- Only called when the client actually has the function — discovered, not assumed.
	local widgetSetID
	if C_Scenario and C_Scenario.GetStepInfo then
		local okStep, _, _, _, _, _, _, _, _, _, _, _, setID = pcall(C_Scenario.GetStepInfo)
		if okStep then
			widgetSetID = tonumber(setID)
		end
	end
	if widgetSetID and C_UIWidgetManager and C_UIWidgetManager.GetAllWidgetsBySetID then
		local okW, widgets = pcall(C_UIWidgetManager.GetAllWidgetsBySetID, widgetSetID)
		if okW and type(widgets) == "table" then
			out[#out + 1] = {
				label = ("widget set %d"):format(widgetSetID),
				source = "C_UIWidgetManager.GetAllWidgetsBySetID",
				value = ("%d widgets"):format(#widgets),
			}
			for i = 1, #widgets do
				local w = widgets[i]
				local id, wtype = w.widgetID, w.widgetType
				local detail = ("widgetID=%s widgetType=%s"):format(tostring(id), tostring(wtype))
				-- The delve header carries the tier; ask it directly when this is that type.
				if C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo then
					local okV, vis = pcall(C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo, id)
					if okV and type(vis) == "table" then
						local bits = {}
						for k, v in pairs(vis) do
							if type(v) ~= "table" then
								bits[#bits + 1] = tostring(k) .. "=" .. tostring(v)
							end
						end
						table.sort(bits)
						if #bits > 0 then
							detail = detail .. "  ->  " .. table.concat(bits, " ")
						end
					end
				end
				out[#out + 1] = { label = ("  widget[%d]"):format(i), source = "widget set", value = detail }
			end
		end
	end

	-- Full surface of the three namespaces that matter, unfiltered by keyword. The first
	-- sweep only showed fields whose NAME matched a word we chose, and the whole lesson of
	-- this probe is that Blizzard does not use our words.
	for _, nsName in ipairs({ "C_DelvesUI", "C_ScenarioInfo", "C_UIWidgetManager" }) do
		local tbl = _G[nsName]
		if type(tbl) == "table" then
			local names = {}
			for k in pairs(tbl) do
				if type(k) == "string" then
					names[#names + 1] = k
				end
			end
			table.sort(names)
			out[#out + 1] = {
				label = ("%s (all %d fields)"):format(nsName, #names),
				source = "full enumeration",
				value = table.concat(names, ", "),
			}
		end
	end

	-- Criteria carry per-objective text and sometimes a number; if a tier is readable
	-- anywhere in a scenario, this is the likeliest place it hides.
	if C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo then
		for i = 1, 12 do
			local ok, info = pcall(C_ScenarioInfo.GetCriteriaInfo, i)
			if ok and type(info) == "table" then
				out[#out + 1] = {
					label = ("criteria[%d]"):format(i),
					source = "C_ScenarioInfo.GetCriteriaInfo",
					value = ("description=%s quantity=%s total=%s completed=%s"):format(
						tostring(info.description), tostring(info.quantity),
						tostring(info.totalQuantity), tostring(info.completed)),
				}
			end
		end
	end

	return out
end

function ns.PrintKnowledgeApiProbe(arg)
	local out = prefix()
	local surface = SweepApiSurface()
	local live = ReadLiveScenario()

	print(("%s Knowledge API probe — what the client actually exposes"):format(out))
	print(("   matching globals: %d   ·   C_ namespaces with matching fields: %d"):format(
		#surface.globals, #surface.namespaces))

	for i = 1, #surface.namespaces do
		local entry = surface.namespaces[i]
		print(("   |cff40c040%s|r: %s"):format(entry.name, table.concat(entry.fields, ", ")))
	end

	print("   |cffffcc00live scenario state:|r")
	for i = 1, #live do
		print(("      %-32s %s"):format(live[i].label, live[i].value))
	end
	print("   |cff8a8f98run this again INSIDE a Ritual Site — outside one, \"nothing found\" proves nothing.|r")

	if arg == "save" then
		if type(ns.db) ~= "table" then
			print(out .. " |cffff8080cannot save: saved variables are not ready|r")
			return
		end
		ns.db.knowledgeProbeApi = {
			at = time(),
			globals = surface.globals,
			namespaces = surface.namespaces,
			live = live,
		}
		print(out .. " saved to ns.db.knowledgeProbeApi — now |cffffffff/reload|r.")
	end
end

--------------------------------------------------------------------------------
-- Slash command
--------------------------------------------------------------------------------

-- Registered here rather than routed from Core.lua's /mh chain, for one practical
-- reason: Core.lua belongs to the addon session, and a dev diagnostic is not worth a
-- cross-owner edit. The addon already does this for its own dev commands —
-- /mhcsdebug (CombatSafety), /mhfirstrun (FirstRun), /mhautomap (KeybindAutoMap) — so
-- this follows the house pattern instead of inventing one.
--
-- When phase 3 is approved and /mh know joins the main router, this block can go; the
-- work it does is one call to ns.PrintKnowledge either way.
--
-- Guarded because the fixture runner and the offline smoke test load this same file
-- outside the game, where SlashCmdList does not exist.
--
-- Plain global assignment, not rawset, and that is deliberate: tools/check_knowledge_inert.lua
-- detects load-time side effects through a __newindex hook on _G, and rawset walks
-- straight past it. Writing the global the ordinary way keeps this file honest to its own
-- inspector — a side effect that cannot be observed is worse than one that can.
if type(SlashCmdList) == "table" then
	SLASH_MHKNOW1 = "/mhknow"
	SlashCmdList["MHKNOW"] = function(msg)
		msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
		if msg == "probe" or msg == "probe save" then
			ns.PrintKnowledgeApiProbe(msg == "probe save" and "save" or nil)
			return
		end
		ns.PrintKnowledge(msg == "save" and "save" or nil)
	end
end

ns.Knowledge = M

return M
