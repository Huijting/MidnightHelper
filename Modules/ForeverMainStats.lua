local _, ns = ...

--[[
	ForeverMainStats.lua — per class, the primary stats that matter most while leveling in WoW Forever, for the quest
	reward hint (ForeverQuestHint.lua). PENDING: mh-research is sourcing the list (7 Nov 2026); until it is filled, the
	hint says "No stat list for your class yet" and only points at the reward that sells for the most.
]]

if not ns.IS_FOREVER then
	return
end

ns.FOREVER_MAIN_STATS = ns.FOREVER_MAIN_STATS or {}
