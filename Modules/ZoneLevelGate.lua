local _, ns = ...

--[[
	Midnight Helper — "you are not high enough for there yet".

	🔴 WHY. Rob, 4 Sep 2026, testing on a level-68 Paladin: "ik kan met lagere levels in mh
	toch routes krijgen voor dingen die ik nog helemaal niet kan doen." Measured that day:
	29 modules can set a route, 2 knew about the level gate. This Week and the Silvermoon
	tab were covered; rares, delves, treasures, achievements, events and professions were
	not.

	He picked option A on 5 Sep -- warn, but still set the route -- and asked for it to be
	IMPOSSIBLE TO MISS. Both halves matter:
	  * still route, because looking up where a rare stands is useful at any level, and a
	    player who knows what they are doing should not be told no;
	  * warn loudly, because a route into a zone twelve levels above you is bad advice, and
	    the addon has been giving it silently.

	⚠️ WHAT WE CLAIM, AND WHAT WE DO NOT. Two independent sources (Icy Veins' leveling
	guide, read in full, and a second search that agrees) put the Midnight intro at level
	78 and the zones at Eversong 80-82, Zul'Aman 82-88, Harandar 82-88, Voidstorm 88-90.
	🔴 13 Sep 2026: the client itself says 80-90 for all four zones (C_Map.GetMapLevels); the
	guide's bands are the levelling order, not where a zone starts. See REGION_MIN_LEVEL.
	Blizzard's own launch announcement gates Eversong/Silvermoon at 80 -- that one is
	measured and already drives MIDNIGHT_FLOOR_LEVEL in ResetRoutine.

	✅ SETTLED 5 SEP 2026, AND THE CAUTIOUS WORDING TURNS OUT TO BE THE CORRECT ONE. Open since
	3 Sep: does the game physically refuse you? Rob measured it on a level-70 Paladin -- he
	took the Orgrimmar portal to Silvermoon and walked in. THE GAME DOES NOT STOP YOU. So
	"this area is tuned for level X and you are Y" is not merely the careful phrasing, it is
	the true one, and "you cannot go there" would have been a claim the player disproves by
	walking through a portal. Never change it back.

	📌 What IS gated is the CAMPAIGN, not the ground. The same character found the Image of
	Lady Liadrin in Orgrimmar (53.37, 77.35, npc 241677) offering only a cutscene and no
	quest. So the intro opens somewhere above 70 -- 78 per the guides, not measured to the
	level -- while the zones themselves are open to anyone who can reach them.

	⚠️ Two different gates, and this module only speaks about the second one. Do not let a
	future "the intro needs 78" fact leak into a sentence about walking into a zone.

	📌 The threshold is per REGION, not per zone, and deliberately the LOWEST of the region.
	`ns.GetTargetRegionGroupID` already resolves which region a target sits in, including
	the x-slice on the shared 2576 canvas -- so the answer comes from the same function the
	travel advice uses, rather than a second map table that would drift from it.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- Fallback floor per region, by the region ids GetRegionGroupID returns: used only where
--- the game gives a map no level band (ClientMinLevel below returns nil for cities and
--- sub-maps, such as Silvermoon City and Slayer's Rise).
---
--- 🔴 [2] WAS 82 AND [3] WAS 88 UNTIL 13 SEP 2026, BOTH FROM ICY VEINS. THE CLIENT SAYS 80.
--- Rob, level 81 in Harandar, got "the enemies there are well above you" while "de meeste mobs
--- hier scalen mee". C_Map.GetMapLevels on his client gives 80-90 for Eversong, Zul'Aman,
--- Harandar and Voidstorm alike. The guide's numbers are the levelling ORDER (where a guide sends
--- you next), not a zone's floor. Same lesson as MidnightEntryLevel below: agreement between
--- guides is not measurement.
local REGION_MIN_LEVEL = {
	[1] = 80, -- Quel'Thalas: Silvermoon, Eversong, Zul'Aman, Quel'Danas (Blizzard's announcement)
	[2] = 80, -- Harandar: MEASURED 13 Sep 2026, client 80-90
	[3] = 80, -- Voidstorm: MEASURED 13 Sep 2026, client 80-90
}

--- 🔴 ONE ZONE SITS TEN LEVELS ABOVE ITS OWN REGION'S FLOOR, AND THE REGION MODEL CANNOT SAY
--- SO — Rob, 8 Sep 2026, the day he took a fresh 80 through the portal: *"alles is daar lvl 90
--- 😛 dus niet verstandig."*
---
--- 📌 The floor-of-the-region rule above is right for the case it was written for: claiming
--- Zul'Aman's 82 for Eversong would silence a warning we owe. But it only ever errs toward
--- warning MORE, and the Coiled Isle is the mirror case — region 1's floor is 80, the isle is
--- tuned for 90, so a level-80 routed to a rare there got **no warning at all**. That is
--- exactly the silence this module was built to end: *"a route into a zone twelve levels above
--- you is bad advice, and the addon has been giving it silently."*
---
--- ⚠️ SO THE OVERRIDE IS PER MAP AND IS CHECKED FIRST, and it may only ever raise the number.
--- A per-map entry that LOWERED one would re-introduce the bug the region rule prevents, so if
--- a future row is below its region's floor, that row is the mistake.
---
--- 📌 Source quality, kept visible like the table above: this row is the strongest one here —
--- **Rob's own eyes in the client**, not a guide. The isle's rares are ours to route to every
--- week, so this is the row most likely to be acted on.
local MAP_MIN_LEVEL = {
	[2512] = 90, -- The Coiled Isle — MEASURED 8 Sep 2026 on Rob's level-80 Ret Paladin
}

--- 🔴 THE UPPER BOUND IS GONE, AND IT SHOULD NEVER HAVE BEEN IN THE SENTENCE. Rob, 5 Sep,
--- reading his own toast: *"waarom tot lvl 88, terwijl je die ook kunt doen als je lvl 90
--- bent?"* Exactly right. "80-88" is the LEVELLING band -- the range over which the zone
--- scales while you are on the way up -- and a player at 90 is still there every week. A
--- sentence that ends at 88 reads as an expiry date on content that has none.
---
--- 📌 Only the floor was ever load-bearing. The decision has always used REGION_MIN_LEVEL
--- alone; the band was decoration on the message, and it was the half that could be
--- misread. So `REGION_BAND` is deleted rather than corrected -- there is no second number
--- that belongs in this sentence.
---
--- ⚠️ And the same conversation settled the other half. "82 is advies denk ik en geen harde
--- eis toch?" -- yes, and as of today that is MEASURED, not assumed: he walked a level-70
--- into Silvermoon through the Orgrimmar portal. The wording says so outright now instead of
--- hinting at it with "you can still go and look".

--- Where Midnight itself starts, as opposed to where a region is tuned.
---
--- 🔴 WAS 78 UNTIL 8 SEP 2026, AND 78 IS NOW MEASURED WRONG.
---
--- The old note said 78 was "where the intro questline opens, from two guide sources read in
--- full plus Rob's own reading". Rob took a Ret Paladin up that morning and watched it:
---   • 78 — travel to Silvermoon works, **nothing to accept**
---   • 79 — still nothing; the game's own refusal on a gathering node reads "requires level 80"
---   • 80 — the quest **Midnight** lands in the log by itself, the moment he dinged
---
--- 📌 Two guides agreed with each other and were both wrong. That is the failure mode this
--- repo keeps meeting: agreement between sources is not measurement, and a number that has
--- been repeated is not a number that has been checked.
---
--- ⚠️ THE JUSTIFICATION DIED BEFORE THE NUMBER DID, and that is the part worth keeping. A
--- value may outlive its stated reason and still be right, but it may not keep citing a reason
--- known to be false — see the same correction made to MIDNIGHT_FLOOR_LEVEL the same morning.
---
--- 📌 Raising it to 80 makes the banner MORE accurate rather than merely consistent: at 79
--- there is genuinely nothing to do, and the old 78 stayed silent about that. It now agrees
--- with REGION_MIN_LEVEL[1] — not by flattening two different facts into one, but because both
--- were measured at 80 by two independent routes.
ns.MidnightEntryLevel = 80

--- @return number|nil level, nil when it cannot be read
local function PlayerLevel()
	if not UnitLevel then
		return nil
	end
	local ok, lvl = pcall(UnitLevel, "player")
	if not ok then
		return nil
	end
	lvl = tonumber(lvl)
	return (lvl and lvl > 0) and lvl or nil
end

--- The game's own answer: C_Map.GetMapLevels returns a zone's level band, lowest first.
--- MEASURED 13 Sep 2026 on Rob's client: Eversong Woods, Zul'Aman, Harandar and Voidstorm 80 90;
--- the Coiled Isle 90 90 (the positive control: Rob had measured 90 there on 8 Sep); Silvermoon
--- City and Slayer's Rise 0 0. A 0 means "no band", never "level 0", so it returns nil.
--- @return number|nil
local function ClientMinLevel(mapID)
	if not (mapID and C_Map and C_Map.GetMapLevels) then
		return nil
	end
	local ok, minLevel = pcall(C_Map.GetMapLevels, mapID)
	minLevel = ok and tonumber(minLevel) or nil
	return (minLevel and minLevel > 0) and minLevel or nil
end

--- Should we warn about routing to this target, and with what numbers?
---
--- ⚠️ Returns nil for every "we do not know" case -- unreadable level, unknown region,
--- region 0. An unknown region is common (our table covers eight maps out of the whole
--- game) and must never produce a warning, or every route outside Midnight would carry one.
--- @param mapID number|nil
--- @param xPct number|nil target x, so the 2576 canvas can be sliced
--- @return table|nil { level, need, region }
function ns.GetZoneLevelWarning(mapID, xPct)
	if not mapID or not ns.GetTargetRegionGroupID then
		return nil
	end
	local okR, region = pcall(ns.GetTargetRegionGroupID, mapID, xPct)
	if not okR or not region or region == 0 then
		return nil
	end
	--- The game's own band wins (ClientMinLevel). Where it has none: a zone tuned above its
	--- region's floor (MAP_MIN_LEVEL, the Coiled Isle), and last the region's floor.
	local need = ClientMinLevel(mapID) or MAP_MIN_LEVEL[mapID] or REGION_MIN_LEVEL[region]
	if not need then
		return nil
	end
	local lvl = PlayerLevel()
	if not lvl or lvl >= need then
		return nil
	end
	return { level = lvl, need = need, region = region }
end

--- Should the warning also REFUSE to set the route?
---
--- 🔴 Rob, 5 Sep, after seeing the warning fire and the arrow appear anyway: "Maak die
--- schakelaar maar en zet hem standaard op uit zodat mensen bewust kiezen om hem wel te
--- krijgen." So OFF is what everyone already has -- warn, still route -- and no one's addon
--- changes behaviour under them on update. ON is the stricter reading for players who want
--- the addon to hold them back.
---
--- ⚠️ Deliberately NOT a per-character setting. The character it matters for is the low one,
--- and that is exactly the character on which nobody opens the settings panel.
--- @return boolean
function ns.IsZoneGateBlockEnabled()
	return not not (ns.db and ns.db.zoneGate and ns.db.zoneGate.blockRoute)
end

--- @param v boolean
function ns.SetZoneGateBlockEnabled(v)
	ns.db = ns.db or {}
	ns.db.zoneGate = ns.db.zoneGate or {}
	ns.db.zoneGate.blockRoute = v and true or false
end

--- 🔴 SAID LOUDLY, ON REQUEST. Rob: "maar opvallend waarschuwen !!"
---
--- Chat alone is what he has objected to three times, and he is right: a route arrow
--- appears, the player follows it, and the one sentence explaining that the destination is
--- twelve levels above them scrolls past unread. So this goes on screen as a toast AND into
--- chat -- the toast to be seen, the chat line to be found again afterwards.
---
--- ⚠️ Throttled per target zone, not per call. A bulk route can publish a dozen waypoints
--- in one go (`skipCrazyArrow` exists for exactly that), and a dozen identical toasts would
--- teach the player to dismiss them without reading, which is worse than not warning.
local warnedFor = {}

--- @param mapID number
--- @param xPct number|nil
--- @param targetName string|nil
--- @return boolean blocked -- true when the caller must NOT set the route after all
function ns.WarnZoneLevelIfNeeded(mapID, xPct, targetName)
	local w = ns.GetZoneLevelWarning(mapID, xPct)
	if not w then
		return false
	end
	local blocking = ns.IsZoneGateBlockEnabled()
	local key = tostring(mapID) .. ":" .. tostring(w.need)
	local now = (GetTime and GetTime()) or 0
	-- ⚠️ The throttle must NOT apply while blocking. It exists so a bulk route cannot fire
	-- a dozen toasts for the same zone; but a click that sets no route AND says nothing is,
	-- from outside, indistinguishable from broken -- the exact failure CLAUDE.md records
	-- from 3 Sep ("een klik die stil niets doet"). Refusing is the case that must always
	-- speak.
	if not blocking then
		if warnedFor[key] and (now - warnedFor[key]) < 120 then
			return false
		end
		warnedFor[key] = now
	end

	-- xPct matters on canvas 2576: without it the name is "" rather than a guessed slice,
	-- and the targetName fallback below takes over. Never name the wrong zone in a warning
	-- whose whole job is telling the player where they are going.
	local zone = (ns.GetBaseZoneName and ns.GetBaseZoneName(mapID, xPct)) or ""
	if zone == "" then
		zone = targetName and tostring(targetName) or "?"
	end

	local body = ns:L("ZONEGATE_BODY_FMT"):format(zone, w.need, w.level)
	local tail = ns:L(blocking and "ZONEGATE_BLOCKED" or "ZONEGATE_STILL_ROUTED")
	if ns.QueueMidnightToast then
		pcall(ns.QueueMidnightToast, {
			id = "zonegate_" .. key,
			title = ns:L("ZONEGATE_TITLE_FMT"):format(w.need),
			-- "did the route get set or not" belongs ON SCREEN, not only in chat: whether
			-- an arrow you were expecting is missing on purpose is the one thing the
			-- player needs at that moment, and chat is a record rather than an answer.
			body = body .. "|n|n" .. tail,
			icon = 134400, -- the padlock; this is a "not yet", not an error
			displaySec = 20,
			-- Rob, 5 Sep, after seeing it fire: "kan de toast ook een duidelijk geluid
			-- spelen??" READY_CHECK rather than a new pick -- ShardCapAlert already uses
			-- it, so it is measured to be audible on the Master channel even at low SFX
			-- volume, and reusing it keeps "Midnight Helper wants you" one sound instead
			-- of a zoo. The 120s throttle above is what keeps it from becoming noise.
			soundKit = SOUNDKIT and SOUNDKIT.READY_CHECK or nil,
		})
	end
	print(("%s |cffff8844%s|r"):format(PREFIX, body))
	print("  " .. ns:L(blocking and "ZONEGATE_BLOCKED" or "ZONEGATE_STILL_ROUTED"))
	return blocking
end

--- `/mh zonegate test` — fire the real warning on demand, and MEASURE the sound.
---
--- 🔴 Rob, 5 Sep: *"ik hoor geen geluid als er de toast komt."* The toast asks for
--- SOUNDKIT.READY_CHECK, and at least three different faults produce that same silence: the
--- constant not existing on this client, PlaySound refusing to queue it, or it playing and
--- being inaudible. Each guess costs a reload, so this prints what every step actually
--- returned instead of what it was supposed to.
---
--- ⚠️ Goes through ns.WarnZoneLevelIfNeeded like the game does -- no test-only branch, or
--- the test would pass on exactly the build where the real path is broken.
function ns.TestZoneLevelToast()
	local id = SOUNDKIT and SOUNDKIT.READY_CHECK
	print(("%s sound test — SOUNDKIT.READY_CHECK = %s"):format(
		PREFIX, id and tostring(id) or "|cffff4444missing|r"))
	if PlaySound and id then
		local ok, willPlay, handle = pcall(PlaySound, id, "Master")
		print(("   PlaySound → %s  willPlay=%s  handle=%s"):format(
			ok and "ran" or "|cffff4444errored|r", tostring(willPlay), tostring(handle)))
	else
		print("   |cffff4444PlaySound or the sound id is missing — nothing was even asked for|r")
	end

	local map = 2393 -- Silvermoon City: region 1, so it warns below level 80
	if not ns.GetZoneLevelWarning(map, 50) then
		print("   no toast: this character is at or above level for that region, so there is")
		print("   nothing to hear. Try it on the low one.")
		return
	end
	-- Clearing the throttle first: a test that silently lands inside the 120-second window
	-- would look exactly like the bug it is checking for.
	wipe(warnedFor)
	ns.WarnZoneLevelIfNeeded(map, 50, "sound test")
end

--------------------------------------------------------------------------------
-- The red strip across the top of the window
--------------------------------------------------------------------------------

--- 🔴 Rob, 5 Sep: *"wanneer iemand onder lvl 78 is een soort rode balk boven aan de addon,
--- deze addon werkt vooral voor lvl 78 en hoger."* The per-route warning answers "this ONE
--- destination is above you"; nothing answered "most of this addon is about content you
--- have not reached". That is a whole-window fact and it belongs in the window.
---
--- 📌 What the bar claims is about US, not about the game: "Midnight Helper is built for 78
--- and up." Whether the game lets a level-70 walk into Silvermoon is still unmeasured (see
--- the header), and this sentence does not depend on the answer.
---
--- ⚠️ Nothing is hidden or disabled. Every tab still opens, every pin still shows. The bar
--- is a label on the room, not a lock on the door -- the same line the 3 Sep Silvermoon
--- banner settled on.
function ns.RefreshMidnightLevelBar()
	local bar = ns.mhLevelBar
	if not bar then
		return
	end
	local lvl = PlayerLevel()
	local need = ns.MidnightEntryLevel or 78
	-- An unreadable level shows NOTHING. A red bar is a claim about this character, and
	-- "we could not read your level" is not grounds for one.
	if not lvl or lvl >= need then
		bar:Hide()
		bar:SetHeight(0.01)
		return
	end
	if ns.mhLevelBarText then
		ns.mhLevelBarText:SetText(ns:L("LEVELBAR_BELOW_ENTRY_FMT"):format(need, lvl))
	end
	bar:SetHeight(26)
	bar:Show()
end

do
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("PLAYER_LEVEL_UP")
	f:SetScript("OnEvent", function()
		-- The bar only exists once the window has been built at least once; before that
		-- there is nothing to refresh and EnsureMainUI calls this itself.
		if ns.RefreshMidnightLevelBar then
			pcall(ns.RefreshMidnightLevelBar)
		end
	end)
end

--- `/mh zonegate` — what would this character be warned about, and why?
---
--- The normal outcome of this module is silence (at max level it never fires), so per
--- CLAUDE.md it needs a way to show that the silence is on purpose. Prints the decision
--- for the player's CURRENT position and for each region, rather than waiting for a route.
function ns.PrintZoneLevelGate()
	local lvl = PlayerLevel()
	print(("%s zone level gate — your level: %s"):format(
		PREFIX, lvl and tostring(lvl) or "|cffff8844could not read|r"))
	-- The zones a route can lead into, each with the game's own level band.
	local zones = { { 2395, "Eversong Woods" }, { 2437, "Zul'Aman" }, { 2413, "Harandar" },
		{ 2405, "Voidstorm" }, { 2512, "The Coiled Isle" } }
	for _, z in ipairs(zones) do
		local mapID = z[1]
		local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
		local lo, hi = "?", "?"
		if C_Map and C_Map.GetMapLevels then
			local ok, a, b = pcall(C_Map.GetMapLevels, mapID)
			if ok then
				lo, hi = tostring(a), tostring(b)
			end
		end
		local need = ClientMinLevel(mapID) or MAP_MIN_LEVEL[mapID] or REGION_MIN_LEVEL[1]
		local verdict
		if not lvl then
			verdict = "|cffff8844unknown — level unreadable|r"
		elseif lvl >= need then
			verdict = "|cff44ff44no warning|r"
		else
			verdict = ("|cffffcc00warns: needs %d, you are %d|r"):format(need, lvl)
		end
		print(("   %-18s game says %s-%s   %s"):format((info and info.name) or z[2], lo, hi, verdict))
	end
	if ns.IsZoneGateBlockEnabled() then
		print("  route below level: |cffff4444REFUSED|r (Settings -> Route arrow)")
	else
		print("  route below level: |cff44ff44still set|r — warn only (Settings -> Route arrow)")
	end
	print("  Levels come from the game itself (C_Map.GetMapLevels). Where it has none (cities,")
	print("  sub-maps) the floor is 80, from Blizzard's announcement. |cff44ff44MEASURED 5 Sep: the")
	print("  game does NOT stop you|r — a level 70 walked into Silvermoon — so we say 'tuned for'.")
end
