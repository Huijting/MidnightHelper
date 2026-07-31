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
	    /mh know          one-screen summary
	    /mh know save     full request + response into ns.db.knowledgeProbe, then /reload

	LIVES IN tools/ ON PURPOSE, WHILE PHASE 3 IS UNFINISHED. Not player-visible, not in the
	.toc, and a Lua file sitting in Modules/ without a .toc entry is a HARD lint failure for
	everyone sharing this checkout. tools/ is excluded from the release zip and needs no
	.toc entry, so this is where unfinished runtime code belongs.

	Destination when phase 3 lands: Modules/Knowledge.lua, registered in the .toc.
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
		ns.PrintKnowledge(msg == "save" and "save" or nil)
	end
end

ns.Knowledge = M

return M
