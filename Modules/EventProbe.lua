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

	ns.db.eventProbe = { checked = #EVENTS, unknown = unknown }
	if #unknown == 0 then
		print(("%s all |cffffffff%d|r registered event(s) exist on this client."):format(Prefix(), #EVENTS))
	else
		print(("%s |cffff9900%d of %d event(s) do not exist here:|r %s"):format(
			Prefix(), #unknown, #EVENTS, table.concat(unknown, ", ")))
	end
	print("   |cff9d9d9dWritten to SavedVariables — |cffffffff/reload|r and it can be read from the file.|r")
end
