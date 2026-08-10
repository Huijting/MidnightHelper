local _, ns = ...

--[[
	Midnight Helper — does this client know the events we register? (`/mh events`)

	On 8 Aug 2026 MH registered `LEARNED_SPELL_IN_TAB`, an event 12.x no longer has, and
	Rob's next reload threw "Attempt to register unknown event". I had checked the name by
	grepping his other addons and finding it four times, which proves that somebody once
	wrote it down and nothing else.

	I then argued the rest were fine because only one error appeared. That is wrong too:
	BugGrabber records once per addon per session, so a SECOND unknown event in MH would
	have been invisible. Twice in one night, "no complaint" got read as "no problem".

	So ask the client. Every event MH registers is tried on a throwaway frame inside a
	pcall; anything that refuses is written down by name. Nothing else is registered, no
	handler is attached, and the frame is thrown away afterwards.

	⚠️ THE LIST BELOW IS GENERATED AND CAN DRIFT from the code it describes — the same
	shape of bug as the keybind harness that kept handing out Alt keys. Regenerate it with:

	    grep -rhoP 'RegisterEvent\("\K[A-Z_0-9]+' --include=*.lua Modules/ Core.lua UI.lua Config.lua | sort -u

	`/mh events` reports the list's own size so a mismatch with the source is at least
	visible when somebody looks.
]]

local EVENTS = {
	"ACHIEVEMENT_EARNED", "ACTIVE_TALENT_GROUP_CHANGED", "ADDON_ACTION_FORBIDDEN",
	"ADDON_LOADED", "BAG_UPDATE", "BAG_UPDATE_DELAYED", "CHALLENGE_MODE_START",
	"CHAT_MSG_ADDON", "COMBAT_LOG_EVENT_UNFILTERED", "CRITERIA_UPDATE",
	"CURRENCY_DISPLAY_UPDATE", "ENCOUNTER_END", "ENCOUNTER_START",
	"GET_ITEM_INFO_RECEIVED", "GOSSIP_CLOSED", "GOSSIP_SHOW", "GROUP_ROSTER_UPDATE",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT", "ITEM_DATA_LOAD_RESULT", "ITEM_LOCK_CHANGED",
	"LEARNED_SPELL_IN_SKILL_LINE", "MAJOR_FACTION_RENOWN_LEVEL_CHANGED",
	"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "NEW_MOUNT_ADDED",
	"PERKS_PROGRAM_DATA_REFRESH", "PLAYER_ALIVE", "PLAYER_DEAD", "PLAYER_ENTERING_WORLD",
	"PLAYER_EQUIPMENT_CHANGED", "PLAYER_LEVEL_UP", "PLAYER_LOGIN",
	"PLAYER_MOUNT_DISPLAY_CHANGED", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED",
	"PLAYER_ROLES_ASSIGNED", "PLAYER_SPECIALIZATION_CHANGED", "PLAYER_STARTED_MOVING",
	"PLAYER_STOPPED_MOVING", "PLAYER_TARGET_CHANGED", "PLAYER_UNGHOST", "QUEST_ACCEPTED",
	"QUEST_DETAIL", "QUEST_LOG_UPDATE", "QUEST_REMOVED", "QUEST_TURNED_IN",
	"QUEST_WATCH_UPDATE", "RAID_TARGET_UPDATE", "SCENARIO_COMPLETED",
	"SCENARIO_CRITERIA_UPDATE", "SCENARIO_UPDATE", "SKILL_LINES_CHANGED", "SPELLS_CHANGED",
	"SPELL_UPDATE_COOLDOWN", "TRADE_SKILL_LIST_UPDATE", "TRADE_SKILL_SHOW",
	"TRAIT_CONFIG_UPDATED", "TRAIT_TREE_CURRENCY_INFO_UPDATED", "UNIT_AURA",
	"UNIT_INVENTORY_CHANGED", "UNIT_PET", "UNIT_SPELLCAST_CHANNEL_START",
	"UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_START",
	"UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_SUCCEEDED", "UNIT_TARGET", "UPDATE_FACTION",
	"UPDATE_SHAPESHIFT_FORM", "VIGNETTES_UPDATED", "VIGNETTE_MINIMAP_UPDATED",
	"WEEKLY_REWARDS_UPDATE", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA",
}

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- `/mh events` — try every event we register and report the ones this client refuses.
function ns.MH_EventProbe()
	ns.db = ns.db or {}
	local probe = CreateFrame("Frame")
	local unknown = {}
	for i = 1, #EVENTS do
		local name = EVENTS[i]
		local ok = pcall(probe.RegisterEvent, probe, name)
		if ok then
			pcall(probe.UnregisterEvent, probe, name)
		else
			unknown[#unknown + 1] = name
		end
	end
	pcall(probe.UnregisterAllEvents, probe)
	probe:SetScript("OnEvent", nil)

	--- While we are asking the client things: what does C_AssistedCombat offer?
	---
	--- `/mh sba` can keep a key free and `IsAssistedCombatAction` can spot the button on
	--- a bar, but Rob asked whether MH can PLACE it there. That needs something to pick
	--- up, and no spell id for it could be found — EllesmereUI might have had the answer
	--- and he has just uninstalled it. So ask rather than try something that would
	--- silently do nothing.
	if C_AssistedCombat then
		local api = {}
		for k, v in pairs(C_AssistedCombat) do
			if type(k) == "string" then
				api[k] = type(v)
			end
		end
		-- The values too, where they are safe to read out of combat.
		local extra = {}
		if C_AssistedCombat.IsAvailable then
			local okA, v = pcall(C_AssistedCombat.IsAvailable)
			extra.IsAvailable = okA and tostring(v) or "error"
		end
		if C_AssistedCombat.GetRotationSpells then
			local okR, v = pcall(C_AssistedCombat.GetRotationSpells)
			extra.rotationSpellCount = (okR and type(v) == "table") and #v or "n/a"
		end
		--- The 12.1 probe turned up a fourth function nobody had asked about:
		--- `GetActionSpell`. If it hands back the spell that REPRESENTS the assistant on
		--- a bar, then MH can finally place it — C_Spell.PickupSpell + PlaceAction — and
		--- Rob's "just put it on 1 by default" becomes possible. The name is suggestive
		--- and suggestive is not evidence, so record what it actually returns.
		if C_AssistedCombat.GetActionSpell then
			local okS, v = pcall(C_AssistedCombat.GetActionSpell)
			extra.actionSpell = okS and tostring(v) or "error"
			extra.actionSpellType = okS and type(v) or "error"
			if okS and type(v) == "number" and C_Spell and C_Spell.GetSpellName then
				local okN, n = pcall(C_Spell.GetSpellName, v)
				extra.actionSpellName = okN and tostring(n) or "no name"
			end
		end
		ns.db.assistedCombatApi = { functions = api, values = extra }
	else
		ns.db.assistedCombatApi = { functions = {}, values = { note = "C_AssistedCombat absent" } }
	end

	--- ⚠️ 12.1 MOVES AT LEAST ONE NAVIGATION CALL. `C_SuperTrack.GetNextWaypointForMap`
	--- is removed in 12.1.0 and replaced by `C_Navigation.GetNextWaypointForMap`. MH does
	--- not call the removed one — but it calls three OTHER C_SuperTrack functions in
	--- sixteen places, and whether the whole namespace is migrating or only that one
	--- function is exactly the sort of thing a changelog summary does not settle.
	---
	--- The watch note of 19 Jul concluded "NativeArrow safe", with the caveat that the
	--- wiki page had been truncated before the Deprecated section — which is where a
	--- removal like this lives. So: ask a client. Run this on the PTR before 11 Aug.
	local NAMESPACES = {
		C_SuperTrack = {
			"GetSuperTrackedQuestID", "SetSuperTrackedQuestID",
			"SetSuperTrackedUserWaypoint", "GetNextWaypointForMap",
		},
		C_Navigation = { "GetNextWaypointForMap" },
		C_Map = { "SetUserWaypoint", "GetUserWaypoint", "HasUserWaypoint", "ClearUserWaypoint" },
		--- ⚠️ `GetAuraSlots` IS THE ONE THAT MATTERS FOR 12.1. Three modules read auras
		--- through it directly, outside the `ns.Aura` facade built for exactly this
		--- change: ActionPrompt, DispelCapture and DispelHelper. All three are
		--- pcall-guarded, so a hard error is unlikely — but if 12.1 removes it or hands
		--- back secret values, the dispel prompt simply stops appearing. A feature dying
		--- quietly is the failure mode this addon keeps trying not to have.
		C_UnitAuras = { "GetUnitAuras", "GetUnitAuraInstanceIDs", "GetAuraDataByIndex",
			"GetAuraSlots", "GetAuraDataBySlot", "GetPlayerAuraBySpellID" },
		C_AssistedCombat = { "IsAvailable", "GetRotationSpells", "GetNextCastSpell" },
	}
	local api = {}
	for nsName, fns in pairs(NAMESPACES) do
		local tbl = _G and _G[nsName]
		if type(tbl) ~= "table" then
			api[nsName] = "ABSENT"
		else
			local seen = {}
			for _, fn in ipairs(fns) do
				seen[fn] = (type(tbl[fn]) == "function") and "function" or "absent"
			end
			api[nsName] = seen
		end
	end
	ns.db.namespaceProbe = api

	ns.db.eventProbe = { checked = #EVENTS, unknown = unknown }
	if #unknown == 0 then
		print(("%s all |cffffffff%d|r registered event(s) exist on this client."):format(Prefix(), #EVENTS))
	else
		print(("%s |cffff9900%d of %d event(s) do not exist here:|r %s"):format(
			Prefix(), #unknown, #EVENTS, table.concat(unknown, ", ")))
	end
	print("   |cff9d9d9dWritten to SavedVariables — |cffffffff/reload|r and it can be read from the file.|r")
end
