local _, ns = ...

--[[
	GameNews.lua — "In the game now": short notes about things Blizzard changed or broke this week,
	shown at the top of This Week (HomeDashboard). Rob, 20 Oct 2026: "Begin met C: het spelnieuws-blokje
	in het spel, met einddatum per melding" — the in-game twin of the site's #now block.

	Every note carries its own end time (server epoch, UTC) and disappears by itself after it. That is
	the point: until now a temporary sentence (Fabled, the Voidcore bug) had to be removed by hand, and a
	forgotten one keeps telling players something that stopped being true.

	⚠️ An end time is either a measured deadline (Fabled: Blizzard's blue post) or a RE-CHECK date for
	"until Blizzard fixes it" notes. A re-check date is not knowledge: when it passes the note goes quiet,
	and the handoff says to look again. Better silent than stale.

	/mh news prints every note with its decision and the reason (CLAUDE.md: a module that can stay silent
	gets a way to see that it did).

	Public:
	  ns.GetGameNewsSteps() -> array of { text, color } (empty when off or nothing is current)
	  ns.PrintGameNews()
	  ns.IsGameNewsEnabled() / ns.SetGameNewsEnabled(on)
]]

-- UTC epochs. 2026-01-01 00:00 UTC = 1767225600.
local US_TUE_27_OCT = 1793109600 -- Tue 27 Oct 2026 14:00 UTC (US weekly maintenance, 07:00 PDT)
local EU_WED_28_OCT = 1793156400 -- Wed 28 Oct 2026 03:00 UTC (EU weekly maintenance, 04:00 CET)
local RECHECK_4_NOV = 1793750400 -- Wed 4 Nov 2026 00:00 UTC: re-check date, not a known fix date

--- @class GameNewsItem
--- id: short name for /mh news
--- key: locale key; a %d in it is filled with the days left
--- ends: { default = epoch, [regionID] = epoch } (GetCurrentRegion: 1 US, 2 KR, 3 EU, 4 TW, 5 CN)
--- minLevel: hide below this level (nil = everyone)
ns.GAME_NEWS = {
	--- Fabled Kindo'jan (64039), extended to the maintenance of the week of 27 Oct (blue post, data watcher
	--- 20 Oct 2026). EU end without an hour from Blizzard -> the Wednesday maintenance (Icy Veins: "28th for EU").
	--- id "fabled2" since 20 Oct 2026: the note now also names the mount (63715, Season 2 only; 2 mh-research rounds),
	--- a real news change, so the button lights up again for anyone who clicked "fabled" away.
	{ id = "fabled2", key = "NEWS_FABLED_KINDOJAN_FMT", minLevel = 90,
		ends = { default = US_TUE_27_OCT, [3] = EU_WED_28_OCT } },
	--- Nebulous Voidcore "Current Season Maximum" jumps (Drahtz, 15 Oct 2026: fix in the works).
	{ id = "voidcore", key = "NEWS_VOIDCORE_BUG", minLevel = 90, ends = { default = RECHECK_4_NOV } },
	--- Valeera takes more damage than intended (12.1.5 Known Issues, topic 2381312, 16 Oct 2026).
	{ id = "valeera", key = "NEWS_VALEERA_DAMAGE", ends = { default = RECHECK_4_NOV } },
}

local function DB()
	ns.db = ns.db or {}
	ns.db.gameNews = ns.db.gameNews or {}
	return ns.db.gameNews
end

function ns.IsGameNewsEnabled()
	return DB().off ~= true
end

function ns.SetGameNewsEnabled(on)
	DB().off = (not on) and true or nil
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
	if ns._mhRefreshNewsBtn then
		pcall(ns._mhRefreshNewsBtn)
	end
end

local function Now()
	return (GetServerTime and GetServerTime()) or time()
end

local function Region()
	return GetCurrentRegion and GetCurrentRegion() or 0
end

local function EndFor(item)
	local e = item.ends or {}
	return e[Region()] or e.default
end

--- @return boolean show, string reason, number|nil daysLeft
local function Decide(item)
	local now, ends = Now(), EndFor(item)
	if not ends then
		return false, "no end time", nil
	end
	if now >= ends then
		return false, "ended " .. date("!%Y-%m-%d %H:%M UTC", ends), nil
	end
	local level = UnitLevel and UnitLevel("player") or 0
	if item.minLevel and level < item.minLevel then
		return false, ("level %d < %d"):format(level, item.minLevel), nil
	end
	return true, "until " .. date("!%Y-%m-%d %H:%M UTC", ends), math.ceil((ends - now) / 86400)
end

local function TextFor(item, days)
	local text = ns:L(item.key)
	if text:find("%%d") then
		text = text:format(days or 1)
	end
	return text
end

function ns.GetGameNewsSteps()
	local steps = {}
	if not ns.IsGameNewsEnabled() then
		return steps
	end
	for _, item in ipairs(ns.GAME_NEWS) do
		local ok, show, _, days = pcall(Decide, item)
		if ok and show then
			steps[#steps + 1] = { id = item.id, text = TextFor(item, days), color = "warn" }
		end
	end
	return steps
end

--- "Seen" (Rob, 20 Oct 2026: "op het moment dat ik hem aangeklikt heb, dat hij dan vervaagt … tot de volgende echte
--- nieuwsupdate"). Per account: a click on the News button marks every note shown right now as seen; the button goes
--- quiet until a note with an id it has not seen appears. 📌 So a note whose MEANING changes needs a new id (e.g.
--- "voidcore2"); fixing a typo can keep the old one.
local function Seen()
	local d = DB()
	d.seen = d.seen or {}
	return d.seen
end

--- @return number unseen  current notes the player has not clicked away yet
function ns.GetGameNewsUnseenCount()
	local seen, n = Seen(), 0
	for _, st in ipairs(ns.GetGameNewsSteps()) do
		if st.id and not seen[st.id] then
			n = n + 1
		end
	end
	return n
end

function ns.MarkGameNewsSeen()
	local seen = Seen()
	for _, st in ipairs(ns.GetGameNewsSteps()) do
		if st.id then
			seen[st.id] = true
		end
	end
	if ns._mhRefreshNewsBtn then
		pcall(ns._mhRefreshNewsBtn)
	end
end

function ns.ResetGameNewsSeen()
	DB().seen = nil
	if ns._mhRefreshNewsBtn then
		pcall(ns._mhRefreshNewsBtn)
	end
	print("|cff8fd3ffMidnight Helper|r — news: every note is unseen again.")
end

function ns.PrintGameNews()
	print(("|cff8fd3ffMidnight Helper — In the game now|r (%s, region %s, now %s)"):format(
		ns.IsGameNewsEnabled() and "on" or "|cffff5040off in settings|r", tostring(Region()),
		date("!%Y-%m-%d %H:%M UTC", Now())))
	for _, item in ipairs(ns.GAME_NEWS) do
		local ok, show, reason = pcall(Decide, item)
		local state = not ok and "|cffff5040error|r" or (show and "|cff40c040shown|r" or "|cff9d9d9dhidden|r")
		local seenTxt = Seen()[item.id] and " |cff9d9d9d(seen)|r" or ""
		print(("   %-9s %s%s — %s"):format(item.id, state, seenTxt, ok and reason or tostring(show)))
	end
	print("   |cff9d9d9d/mh news reset = mark every note unseen again (the button turns orange)|r")
end
