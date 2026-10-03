--[[
	Event-info-laag (fase A, vervolg op het Broker_MidnightEvents-absorptieplan).
	Korte "wat is dit / wat levert het op" per wereld-event, getoond als
	hover-tooltip op de event-regels in de Void & Rituals-tab.

	Gekoppeld op **areaPoiID** (locale-onafhankelijk; de event-naam die de API
	teruggeeft is al in de clienttaal). De teksten zelf staan in de locale-
	bestanden (enUS + nlNL; rest valt terug op enUS).

	Never-lie: alleen events waarvan we de inhoud web-geverifieerd hebben staan
	hier. Bronnen (13 jun 2026):
	  * Stormarion Assault — Icy Veins / Sportskeeda / Method (mount-cache).
	  * Legends of the Haranir — Icy Veins / Boostmatch / Conquest Capped.
	De geplande "Event in <zone>"-regels (Void Assaults / Abundance / Saltheril's
	Soiree / Runestone Defense) krijgen pas een entry zodra we hun areaPoiID +
	inhoud per stuk bevestigd hebben.
]]

local _, ns = ...

-- areaPoiID → { descKey, rewardKey, weeklyQuest } (locale-keys; zie enUS.lua).
-- weeklyQuest = de weekly-quest van dat event (web-gedataminet, live 12.0.5),
-- gebruikt voor de weekly-status-tag. Alleen invullen waar de koppeling zeker is.
ns.EVENT_INFO = {
	-- Stormarion Assault (Voidstorm) — tower defense, elk half uur.
	-- 3 okt 2026 (mh-research, wago AreaPOI live 12.1.0.69933 = PTR 12.1.5): 8419/8421/8422 zijn
	-- één event in drie fases (cores verzamelen / verdediging bouwen / verdedigen), zelfde plek.
	-- MH kende alleen 8419, dus in twee van de drie fases had de regel geen uitleg. Zie onder.
	-- weeklyQuest: 90962 "Stormarion Assault" = Wowhead-type "Weekly Rare Elite World Quest";
	-- 94581 "Stand Your Ground" is de herhaalbare (type World Quest). Was 94581.
	[8419] = {
		descKey = "EVENT_INFO_STORMARION_DESC",
		rewardKey = "EVENT_INFO_STORMARION_REWARD",
		weeklyQuest = 90962,
		-- Shift-klik → roteerbare preview: mount Contained Stormarion Defender +
		-- pet Kai (web-gedataminede item-IDs, 15 jun).
		rewards = { 257180, 265030 },
	},
	-- Legends of the Haranir (Harandar) — verhaal-/relikwie-weekly.
	[8423] = {
		descKey = "EVENT_INFO_HARANIR_DESC",
		rewardKey = "EVENT_INFO_HARANIR_REWARD",
		weeklyQuest = 89268, -- "Lost Legends"
	},
}
-- Stormarion: de twee andere fases delen dezelfde uitleg.
ns.EVENT_INFO[8421] = ns.EVENT_INFO[8419]
ns.EVENT_INFO[8422] = ns.EVENT_INFO[8419]

-- Info voor een event-POI (of nil als we het event nog niet beschreven hebben).
function ns.GetEventInfo(areaPoiID)
	if not areaPoiID then
		return nil
	end
	return ns.EVENT_INFO[areaPoiID]
end

-- Weekly-status van een quest (Kaliel's-Tracker-techniek): onderscheidt
-- "klaar om in te leveren" (IsComplete) van "gedaan" (flagged completed).
-- Geeft "done" | "turnin" | "active" | "todo" (of nil als de API mist).
-- Alles pcall-guarded — nooit een fout naar buiten.
function ns.GetWeeklyQuestStatus(questID)
	if not (questID and C_QuestLog) then
		return nil
	end
	local okDone, done = pcall(C_QuestLog.IsQuestFlaggedCompleted, questID)
	if okDone and done then
		return "done"
	end
	local okIdx, idx = pcall(C_QuestLog.GetLogIndexForQuestID, questID)
	if okIdx and idx then
		local okC, complete = pcall(C_QuestLog.IsComplete, questID)
		if okC and complete then
			return "turnin"
		end
		return "active"
	end
	return "todo"
end
