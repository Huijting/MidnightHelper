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
	Blizzard's own launch announcement gates Eversong/Silvermoon at 80 -- that one is
	measured and already drives MIDNIGHT_FLOOR_LEVEL in ResetRoutine.

	🔴 NOBODY HAS MEASURED WHETHER THE GAME PHYSICALLY REFUSES YOU. `docs/TESTLIJST.md` has
	said so since 3 Sep. So the wording is "this area is tuned for level X and you are Y" --
	never "you cannot go there", which would be a claim we cannot support and which the
	player might immediately disprove by walking in.

	📌 The threshold is per REGION, not per zone, and deliberately the LOWEST of the region.
	`ns.GetTargetRegionGroupID` already resolves which region a target sits in, including
	the x-slice on the shared 2576 canvas -- so the answer comes from the same function the
	travel advice uses, rather than a second map table that would drift from it.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

--- Lowest level at which a region's content starts, by the region ids GetRegionGroupID
--- returns. Deliberately the floor of the region rather than per-zone: Zul'Aman (82) sits
--- in the same region as Eversong (80), and claiming 82 for Eversong would be wrong in the
--- direction that silences a warning we should give.
---
--- ⚠️ SOURCE-QUALITY DIFFERS PER ROW and that is recorded here rather than flattened:
---   [1] 80 — Blizzard's own announcement (Eversong/Silvermoon), the strongest of the three
---   [2] 82 — Icy Veins' zone table, one source read in full
---   [3] 88 — same source, same confidence
local REGION_MIN_LEVEL = {
	[1] = 80, -- Quel'Thalas: Silvermoon, Eversong, Zul'Aman, Quel'Danas, Coiled Isle
	[2] = 82, -- Harandar
	[3] = 88, -- Voidstorm
}

--- Zone bands as the guides give them, for the sentence only. Not used for the decision --
--- the decision uses the region floor above, because a per-zone table would need map ids
--- we have NOT settled (`GetBaseZoneName(2395)` still answers "Zul'Aman" for what looks
--- like Eversong, an open item since August).
local REGION_BAND = {
	[1] = "80-88",
	[2] = "82-88",
	[3] = "88-90",
}

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

--- Should we warn about routing to this target, and with what numbers?
---
--- ⚠️ Returns nil for every "we do not know" case -- unreadable level, unknown region,
--- region 0. An unknown region is common (our table covers eight maps out of the whole
--- game) and must never produce a warning, or every route outside Midnight would carry one.
--- @param mapID number|nil
--- @param xPct number|nil target x, so the 2576 canvas can be sliced
--- @return table|nil { level, need, region, band }
function ns.GetZoneLevelWarning(mapID, xPct)
	if not mapID or not ns.GetTargetRegionGroupID then
		return nil
	end
	local okR, region = pcall(ns.GetTargetRegionGroupID, mapID, xPct)
	if not okR or not region or region == 0 then
		return nil
	end
	local need = REGION_MIN_LEVEL[region]
	if not need then
		return nil
	end
	local lvl = PlayerLevel()
	if not lvl or lvl >= need then
		return nil
	end
	return { level = lvl, need = need, region = region, band = REGION_BAND[region] }
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

	local zone = (ns.GetBaseZoneName and ns.GetBaseZoneName(mapID)) or ""
	if zone == "" then
		zone = targetName and tostring(targetName) or "?"
	end

	local body = ns:L("ZONEGATE_BODY_FMT"):format(zone, w.band or tostring(w.need), w.level)
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

--- `/mh zonegate` — what would this character be warned about, and why?
---
--- The normal outcome of this module is silence (at max level it never fires), so per
--- CLAUDE.md it needs a way to show that the silence is on purpose. Prints the decision
--- for the player's CURRENT position and for each region, rather than waiting for a route.
function ns.PrintZoneLevelGate()
	local lvl = PlayerLevel()
	print(("%s zone level gate — your level: %s"):format(
		PREFIX, lvl and tostring(lvl) or "|cffff8844could not read|r"))
	local names = { [1] = "Quel'Thalas (Silvermoon, Eversong, Zul'Aman)", [2] = "Harandar",
		[3] = "Voidstorm" }
	for region = 1, 3 do
		local need = REGION_MIN_LEVEL[region]
		local verdict
		if not lvl then
			verdict = "|cffff8844unknown — level unreadable|r"
		elseif lvl >= need then
			verdict = "|cff44ff44no warning|r"
		else
			verdict = ("|cffffcc00warns: needs %d, you are %d|r"):format(need, lvl)
		end
		print(("   region %d  %-42s %s"):format(region, names[region] or "?", verdict))
	end
	if ns.IsZoneGateBlockEnabled() then
		print("  route below level: |cffff4444REFUSED|r (Settings -> Route arrow)")
	else
		print("  route below level: |cff44ff44still set|r — warn only (Settings -> Route arrow)")
	end
	print("  Bands come from guides (Icy Veins, read in full); the level-80 floor is")
	print("  Blizzard's own announcement. Whether the game physically stops you is NOT")
	print("  measured — so we say 'tuned for' and never 'you cannot go there'.")
end
