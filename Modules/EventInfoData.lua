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

-- areaPoiID → { descKey, rewardKey } (locale-keys; zie Locales/enUS.lua).
ns.EVENT_INFO = {
	-- Stormarion Assault (Voidstorm) — tower defense, elk half uur.
	[8419] = {
		descKey = "EVENT_INFO_STORMARION_DESC",
		rewardKey = "EVENT_INFO_STORMARION_REWARD",
	},
	-- Legends of the Haranir (Harandar) — verhaal-/relikwie-weekly.
	[8423] = {
		descKey = "EVENT_INFO_HARANIR_DESC",
		rewardKey = "EVENT_INFO_HARANIR_REWARD",
	},
}

-- Info voor een event-POI (of nil als we het event nog niet beschreven hebben).
function ns.GetEventInfo(areaPoiID)
	if not areaPoiID then
		return nil
	end
	return ns.EVENT_INFO[areaPoiID]
end
