local _, ns = ...

--[[
	Midnight Helper — /mh here: write down where you are standing.

	Rob, 18 aug: "welke commando kan ik het beste gebruiken voor de windcaller
	coordinaten?" There was no good answer, which is why he has spent two days
	reading numbers off screenshots and typing them into chat.

	This is the same lesson as the achievement criteria yesterday: the data should
	arrive in the SavedVariables, not through a photograph of a chat frame. He stands
	somewhere, types six characters, and moves on. One /reload at the end hands over
	everything at once.

	⚠️ It APPENDS. A list, never a single slot — the whole point is walking a circuit
	and collecting several places before reloading. Overwriting would mean one
	measurement per reload, which is the shape that made this tedious to begin with.

	Captures the target's name too, because "the Windcaller at 49.99/61.93" is a
	different fact from "49.99/61.93", and the second one is nearly useless a week
	later. Nothing is invented: no target means no name recorded.
]]

local function Prefix()
	return "|cff8fd3ffMidnight Helper|r"
end

--- `/mh npc <id> [id …]` — ask the client what an npc id is actually called.
---
--- Rob, after Azta'rec's GUID came back secret: "anders nemen we toch een id nr wat we
--- wel weten via andere opties?? en dan zie ik wel na een reload of het klopt." Right
--- instinct, and the second half is the part that matters — an id nobody can check is
--- what 96466 has been for three days.
---
--- So this is the check. `C_TooltipInfo.GetHyperlink` on a synthetic creature link
--- returns a tooltip whose first line is the npc's name; HandyNotes_Midnight resolves
--- its own npc references exactly this way (core/util.lua:98). Ask the client, compare
--- to what the guide claimed, and the id is settled either way.
---
--- ⚠️ THE NAME CAN BE SECRET. HandyNotes' own comment says so for 11.x+, and this addon
--- has been bitten twice by `type(x) == "string"` passing on a secret string. Guarded,
--- and a secret is reported as unreadable rather than as absent — those are different
--- answers and only one of them means "wrong id".
---
--- ⚠️ AND IT IS ASYNCHRONOUS. The first call primes a cache and often returns nothing;
--- the answer arrives a moment later. That is the same trap that made /mh curios print
--- "(no description)" for eight options in 2.17.0. Prime, wait, then read.
function ns.LookupNpcIDs(rest)
	local ids = {}
	for word in tostring(rest or ""):gmatch("%d+") do
		local n = tonumber(word)
		if n and n > 0 then
			ids[#ids + 1] = n
		end
	end
	if #ids == 0 then
		print(("%s |cffff5040give me an npc id — /mh npc 265500|r"):format(Prefix()))
		return
	end
	if not (C_TooltipInfo and C_TooltipInfo.GetHyperlink) then
		print(("%s |cffff5040C_TooltipInfo.GetHyperlink is missing on this client.|r"):format(Prefix()))
		return
	end

	local function Link(id)
		return ("unit:Creature-0-0-0-0-%d-0000000000"):format(id)
	end

	for _, id in ipairs(ids) do
		pcall(C_TooltipInfo.GetHyperlink, Link(id))
	end

	C_Timer.After(1.0, function()
		ns.db = ns.db or {}
		ns.db.npcNames = ns.db.npcNames or {}
		print(("%s |cff8fd3ffnpc ids, as your client names them|r"):format(Prefix()))
		for _, id in ipairs(ids) do
			local name, why
			local ok, data = pcall(C_TooltipInfo.GetHyperlink, Link(id))
			if not ok then
				why = "the lookup threw"
			elseif type(data) ~= "table" or type(data.lines) ~= "table" then
				why = "no tooltip"
			else
				local first = data.lines[1]
				local text = first and first.leftText
				if ns.IsSecretValue and ns.IsSecretValue(text) then
					why = "name is secret"
				elseif ns.CanAccessText and ns.CanAccessText(text) and text:find("%w") then
					name = text
				else
					why = "no name"
				end
			end
			ns.db.npcNames[id] = name or ("? " .. (why or "unknown"))
			print(("   %-9d %s"):format(id,
				name and ("|cff40c040" .. name .. "|r") or ("|cffff5040" .. (why or "?") .. "|r")))
		end
		print("   |cff8a8f98A name means the id is real. \"no name\" means it is not — but \"secret\" means neither.|r")
	end)
end

--- `/mh quest` — the id and title of the quest window currently open.
---
--- Rob, 19 aug, with "Seasonal Refresher: Midnight" on screen from Valeera: "kenden we
--- de Delves season 2 quest al?" We did not, and there was no way to find out but to
--- search a guide for a name and hope the id matched — which is the shape that produced
--- the wrong 96466 and cost two days.
---
--- The quest is right there in front of him. `GetQuestID()` answers while the offer or
--- detail frame is up, so the client names its own quest and nobody guesses.
---
--- ⚠️ Appends to the same log as `/mh here`, deliberately. A quest and a coordinate are
--- both "something I found while playing", and splitting them into two lists would mean
--- two reloads to collect one afternoon.
function ns.LogQuestHere()
	local id
	if GetQuestID then
		local ok, v = pcall(GetQuestID)
		id = ok and tonumber(v) or nil
	end
	if not id or id == 0 then
		print(("%s |cffff5040No quest window open — open the quest first, then type this.|r")
			:format(Prefix()))
		return
	end

	--- The title from the frame if the client will give it, never typed in from the
	--- screenshot. A secret or missing title is recorded as absent rather than invented.
	local title
	if GetTitleText then
		local ok, v = pcall(GetTitleText)
		if ok and ns.CanAccessText and ns.CanAccessText(v) and v ~= "" then
			title = v
		end
	end
	if not title and C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, v = pcall(C_QuestLog.GetTitleForQuestID, id)
		if ok and ns.CanAccessText and ns.CanAccessText(v) then
			title = v
		end
	end

	ns.db = ns.db or {}
	ns.db.spots = ns.db.spots or {}
	ns.db.spots[#ns.db.spots + 1] = {
		kind = "quest",
		questID = id,
		title = title,
	}
	print(("%s |cff40c040quest %d|r  %s"):format(
		Prefix(), id, title or "|cff8a8f98(no readable title)|r"))
	print(("   |cff8a8f98Written down — /reload saves it. %d entr%s in the log.|r"):format(
		#ns.db.spots, #ns.db.spots == 1 and "y" or "ies"))
end

--- Where the player is, as map id and 0-100 coordinates.
--- @return number|nil mapID, number|nil x, number|nil y, string|nil zoneName
local function Here()
	if not (C_Map and C_Map.GetBestMapForUnit) then
		return nil
	end
	local ok, mapID = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or not mapID then
		return nil
	end
	local x, y
	if C_Map.GetPlayerMapPosition then
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
		if okP and pos and pos.GetXY then
			local okXY, a, b = pcall(pos.GetXY, pos)
			if okXY and type(a) == "number" then
				x, y = a * 100, b * 100
			end
		end
	end
	local zone
	if C_Map.GetMapInfo then
		local okI, info = pcall(C_Map.GetMapInfo, mapID)
		if okI and type(info) == "table" and type(info.name) == "string" then
			zone = info.name
		end
	end
	return mapID, x, y, zone
end

--- The name of whatever is targeted, or nil. Used as the label for the spot.
---
--- ⚠️ `type(x) == "string"` IS TRUE FOR A SECRET STRING. Rob targeted the Timeworn
--- Golem on 18 aug and this threw: "attempt to index local 'name' (a secret string
--- value)". The type check passed, and `name:find` then indexed a value the client
--- will not let us read.
---
--- I made this exact mistake on 16 aug, wrote it down, and made it again two days
--- later — the note said the flag must GATE the read, and here it was not consulted
--- at all. `issecretvalue` first, always, before anything touches the value.
---
--- Returning nil is right: a secret name is unreadable, not absent, and a spot with
--- no label is still a useful measurement.
local function TargetName()
	if not (UnitExists and UnitExists("target") and UnitName) then
		return nil
	end
	local ok, name = pcall(UnitName, "target")
	if not ok or not (ns.CanAccessText and ns.CanAccessText(name)) then
		return nil
	end
	if name:find("%w") then
		return name
	end
	return nil
end

--- The npc id of whatever is targeted, and WHY it is missing when it is.
---
--- Rob, standing in front of Azta'rec on 19 aug: "kunnen we die id niet uitlezen?" The
--- honest answer was "probably not" — a delve boss's GUID came back secret on Gnarldor
--- Isle on 16 aug, and the probe of the day crashed on it. But that was one boss in one
--- delve, and a measured no on THIS boss is worth as much as a yes.
---
--- ⚠️ EVERY STEP GUARDED, and the order matters. `issecretvalue` before any read, then
--- the type check — never the other way round, because `type()` on a secret string
--- happily answers "string" and the next line indexes something the client refuses.
--- That mistake was made on 16 aug, written down, and made again on the 18th.
---
--- @return number|nil npcID, string reason
local function TargetNpcID()
	if not (UnitExists and UnitExists("target")) then
		return nil, "no target"
	end
	if not UnitGUID then
		return nil, "UnitGUID missing"
	end
	local ok, guid = pcall(UnitGUID, "target")
	if not ok then
		return nil, "UnitGUID threw"
	end
	if ns.IsSecretValue and ns.IsSecretValue(guid) then
		return nil, "the GUID is secret"
	end
	if type(guid) ~= "string" then
		return nil, "no GUID"
	end
	-- Field 6 of a Creature/Vehicle GUID is the npc id — the same extraction Rares.lua
	-- uses. Deliberately not a name lookup.
	local id = guid:match("^%a+%-%d+%-%d+%-%d+%-%d+%-(%d+)")
	return tonumber(id), id and "read from the GUID" or "GUID has no npc field"
end

--- Instances where the client refuses to give a position at all — not a hiccup, a rule.
---
--- ✅ MEASURED 19 aug: Rob ran `/mh here` inside Venomfall Deeps and got nothing. A guide
--- video for that delve says why — Blizzard blocked coordinate tracking in here, which is
--- what broke the third-party "which quadrant is safe" addons that were reading them.
---
--- ⚠️ THE POINT IS THE WORDING, NOT THE LIST. The old message said "try again in a
--- moment", which is true of a loading screen and false here: it never comes back. A
--- player who follows that advice stands there retrying a command that cannot work, and
--- concludes the addon is broken. The same silence hits the route arrow and every
--- waypoint in this delve, and a silent arrow is indistinguishable from a broken one —
--- which is the exact confusion `/mh arrow` exists to clear up.
---
--- Keyed on the instance id the client itself reports, like HazardData: no zone names.
--- Other delves are fine — the golem in The Ring of Glory was logged this way on 18 aug.
ns.POSITION_BLOCKED = {
	[3079] = true, -- Venomfall Deeps (Azta'rec)
}

--- ⚠️ USES ns.GetCurrentInstanceID RATHER THAN ASKING GetInstanceInfo AGAIN, and the
--- first version of this function is why that sentence is here. It unpacked the call
--- itself with six underscores where eight returns deep is needed, so it read `isDynamic`
--- as the instance id, never matched, and Rob saw the old "try again in a moment" message
--- while standing in the one delve this was written for.
---
--- Hazards.lua:28 already had the call, already correct. Re-implementing a multi-return
--- unpack two files away from a working one is how you get an off-by-one that lints
--- clean, throws nothing, and simply never fires.
---
--- @return boolean blocked, string|nil instanceName
function ns.PositionBlockedHere()
	if not ns.GetCurrentInstanceID then
		return false
	end
	local instanceID, name = ns.GetCurrentInstanceID()
	if not instanceID or not ns.POSITION_BLOCKED[instanceID] then
		return false
	end
	return true, (ns.CanAccessText and ns.CanAccessText(name)) and name or nil
end

--- `/mh here [note]` — append this spot to ns.db.spots.
function ns.LogSpotHere(note)
	local mapID, x, y, zone = Here()
	if not (mapID and x and y) then
		-- Position is unavailable in a few places (some instances, mid-loading). Say
		-- so rather than writing a row with holes in it that reads like a measurement.
		local blocked, where = ns.PositionBlockedHere()
		if blocked then
			print(("%s |cffffd100%s does not give out coordinates.|r"):format(
				Prefix(), where or "This delve"))
			print("   |cff8a8f98Blizzard blocked it here, so retrying will not help — and the route arrow is silent in here for the same reason, not because it is broken.|r")

			--- ⚠️ BUT DO NOT LEAVE EMPTY-HANDED. Rob asked, standing in front of Azta'rec,
			--- whether we could read the boss's id — and this function was bailing on the
			--- position before it ever looked at his target. A place that hides one thing
			--- has not necessarily hidden the rest, and finding out costs nothing.
			local npcID, why = TargetNpcID()
			local tname = TargetName()
			if npcID or tname then
				ns.db = ns.db or {}
				ns.db.spots = ns.db.spots or {}
				ns.db.spots[#ns.db.spots + 1] = {
					kind = "target",
					npcID = npcID,
					target = tname,
					note = note,
					where = where,
				}
				print(("   |cff40c040target:|r %s  |cff8a8f98npc %s|r"):format(
					tname or "(name unreadable)", npcID and tostring(npcID) or ("— " .. why)))
				print("      |cff8a8f98Written down without coordinates — /reload saves it.|r")
			elseif UnitExists and UnitExists("target") then
				print(("   |cff8a8f98target gives nothing either: %s|r"):format(why))
			end
			return
		end
		print(("%s |cffff5040no position right now|r — try again in a moment, or step outside."):format(Prefix()))
		return
	end

	ns.db = ns.db or {}
	ns.db.spots = ns.db.spots or {}

	--- The npc id rides along on every spot from 19 aug. "The Windcaller at 49.99/61.93"
	--- was already better than a bare coordinate; an npc id is better still, because a
	--- name can be secret, localised or duplicated and an id is none of those.
	local npcID = TargetNpcID()

	local row = {
		mapID = mapID,
		x = tonumber(("%.2f"):format(x)),
		y = tonumber(("%.2f"):format(y)),
		zone = zone,
		target = TargetName(),
		npcID = npcID,
		note = (type(note) == "string" and note:find("%w")) and note or nil,
		when = date and date("%Y-%m-%d %H:%M:%S") or nil,
	}
	ns.db.spots[#ns.db.spots + 1] = row

	print(("%s |cff40d060%d.|r %s  |cffffd100%.2f / %.2f|r  %s%s%s"):format(
		Prefix(), #ns.db.spots, zone or ("map " .. mapID), row.x, row.y,
		row.target and ("|cff8fd3ff" .. row.target .. "|r") or "",
		row.npcID and ("  |cff8a8f98npc " .. row.npcID .. "|r") or "",
		row.note and ("  " .. row.note) or ""))
	print("   |cff8a8f98/reload writes the list to the DB.|r")
end

-- ---------------------------------------------------------------------------
-- /mh crest — what a delve actually pays, measured instead of argued about
-- ---------------------------------------------------------------------------

--[[
	Rob, 19 aug: "ik geloof nooit dat je niet meer crests of andere crests krijgt als
	je hogere delves doet."

	He is right to push back, and the claim he is pushing back on is ours. We measured
	tiers 8-11 through the entrance window and found one reward context (37/121/107),
	end chest 295 — but that window describes GEAR. Crests are currency, they arrive
	from a different pot (completion + the Gilded Stash), and we never once looked at
	them. "The gear is identical" quietly grew into "the rewards are identical", which
	is the same mistake as reading an empty result as an absence.

	So this measures instead. Deliberately dumb: it snapshots EVERY currency and diffs
	them afterwards. It does not know what a crest is called, how many kinds there are,
	or whether 12.1 renamed them — whatever moved, moved. A filter here would only be
	able to find the crests I already believed in.

	⚠️ A currency this character has never earned is not in the list at all, so a first
	crest of its kind is absent-then-present. That counts as a gain, not as a skip.

		/mh crest        → snapshot now (before you go in)
		/mh crest 8      → diff against the snapshot, filed under tier 8

	Loot the end chest before the second call. If you also open the Gilded Stash, say
	so with `/mh crest 8 stash` — it pays crests too, and a run that includes it is not
	comparable to one that does not.
]]

local function ReadAllCurrencies()
	local out, n = {}, 0
	if not (C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListSize and C_CurrencyInfo.GetCurrencyListInfo) then
		return nil, 0
	end
	local okSize, size = pcall(C_CurrencyInfo.GetCurrencyListSize)
	size = (okSize and tonumber(size)) or 0
	for i = 1, size do
		local okI, info = pcall(C_CurrencyInfo.GetCurrencyListInfo, i)
		if okI and type(info) == "table" and not info.isHeader then
			local id = tonumber(info.currencyID)
			local qty = tonumber(info.quantity)
			-- Names can be secret in 12.x; the id carries the fact, the name is decoration.
			local name = info.name
			if issecretvalue and issecretvalue(name) then
				name = nil
			end
			if id and qty then
				out[id] = { qty = qty, name = (type(name) == "string") and name or nil }
				n = n + 1
			end
		end
	end
	return out, n
end

--- `/mh crest` / `/mh crest <tier> [stash]`
function ns.CrestProbe(rest)
	ns.db = ns.db or {}

	local tier = tonumber((rest or ""):match("%d+"))
	local withStash = (rest or ""):lower():find("stash") ~= nil

	local now, n = ReadAllCurrencies()
	if not now then
		print(("%s |cffff5040currency API unavailable|r."):format(Prefix()))
		return
	end
	if n == 0 then
		print(("%s |cffe8c36ayour currency list is empty|r — open the Currencies tab once, then retry."):format(Prefix()))
		return
	end

	if not tier then
		ns.db.crestSnap = { at = date and date("%Y-%m-%d %H:%M:%S") or nil, cur = now }
		print(("%s snapshot taken — |cffffd100%d currencies|r."):format(Prefix(), n))
		print("   |cff8a8f98Run the delve, loot the end chest, then /mh crest <tier>.|r")
		return
	end

	local snap = ns.db.crestSnap and ns.db.crestSnap.cur
	if not snap then
		print(("%s no snapshot yet — run |cffffd100/mh crest|r first, then the delve."):format(Prefix()))
		return
	end

	local gains = {}
	for id, cur in pairs(now) do
		local before = snap[id] and snap[id].qty or 0
		local delta = cur.qty - before
		if delta ~= 0 then
			gains[#gains + 1] = { id = id, name = cur.name, delta = delta, total = cur.qty, isNew = snap[id] == nil }
		end
	end
	table.sort(gains, function(a, b) return a.delta > b.delta end)

	ns.db.crestRuns = ns.db.crestRuns or {}
	ns.db.crestRuns[#ns.db.crestRuns + 1] = {
		tier = tier, stash = withStash or nil, gains = gains,
		when = date and date("%Y-%m-%d %H:%M:%S") or nil,
	}

	print(("%s |cffffd100tier %d|r%s — %d currenc%s moved:"):format(
		Prefix(), tier, withStash and " |cff8a8f98(incl. Gilded Stash)|r" or "",
		#gains, #gains == 1 and "y" or "ies"))
	if #gains == 0 then
		print("   |cff8a8f98nothing changed — did the snapshot happen before the run?|r")
	end
	for _, g in ipairs(gains) do
		print(("   |cff40c040%+d|r  %-30s |cff8a8f98id %s · now %d%s|r"):format(
			g.delta, g.name or "(name unreadable)", tostring(g.id), g.total,
			g.isNew and " · first ever" or ""))
	end
	print("   |cff8a8f98/reload files it. Snapshot again before the next run.|r")
end

--- `/mh here clear` — start a fresh circuit.
function ns.ClearSpotLog()
	ns.db = ns.db or {}
	local n = ns.db.spots and #ns.db.spots or 0
	ns.db.spots = nil
	print(("%s cleared %d spot%s."):format(Prefix(), n, n == 1 and "" or "s"))
end
