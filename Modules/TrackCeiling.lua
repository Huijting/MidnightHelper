local _, ns = ...

--[[
	Midnight Helper — upgrade track ceiling (Spec 21).

	Answers the question Rob, Cisca and Carola all hit at the same time: "I'm on
	Hero 6/6, now what?" MH explained what tracks are, but never where the next
	track comes from, and never noticed that a slot had stopped being upgradeable.

	DATA SOURCE — C_Item.GetItemUpgradeInfo(itemLink), not tooltip text. Verified
	against three installed addons that all read it: EllesmereUI (EllesmereUI.lua:1935),
	Baganator (CategoryGrouping.lua:424) and Plumber (CatalystUI.lua:237). It returns
	trackStringID (number), trackString (name), currentLevel and maxLevel.

	⚠️ trackString IS LOCALISED. EllesmereUI carries a translation map covering
	Hero / Héroe / Held / Héros / Eroe / Heroí plus ruRU, koKR, zhCN and zhTW. So this
	file NEVER compares it against "Hero" or any other literal — that is precisely the
	bug that broke the Omnium Folio button on every non-English client. Instead:
	  • ceiling is decided numerically (currentLevel >= maxLevel);
	  • tracks are grouped and ordered by the numeric trackStringID;
	  • trackString is only ever DISPLAYED, already in the player's own language.

	Never-lie, further:
	  • No item levels and no key thresholds anywhere. Those shift every season and
	    the sources contradict each other (+7 vs +9 vs +10 for Myth crests). We name
	    the KIND of content and let the game show the numbers.
	  • A slot whose track cannot be read is skipped, never guessed from item level.
	  • If nothing at all could be read we report nothing rather than "0 maxed".
]]

--- One entry per equipped item whose upgrade track could be read.
--- @return table entries, boolean sawAnyItem
local function ScanEquippedTracks()
	local out = {}
	local sawAnyItem = false
	if not (GetInventoryItemLink and C_Item and C_Item.GetItemUpgradeInfo) then
		return out, false
	end
	local first = INVSLOT_FIRST_EQUIPPED or 1
	local last = INVSLOT_LAST_EQUIPPED or 17
	for slot = first, last do
		local link = GetInventoryItemLink("player", slot)
		if link then
			sawAnyItem = true
			local ok, info = pcall(C_Item.GetItemUpgradeInfo, link)
			-- Shirts, tabards and anything without an upgrade track return nil here,
			-- which is correct: they are not slots you can push higher.
			if ok and type(info) == "table" then
				local cur, max = tonumber(info.currentLevel), tonumber(info.maxLevel)
				if cur and max and max > 0 then
					out[#out + 1] = {
						slot = slot,
						trackID = tonumber(info.trackStringID) or 0,
						trackName = info.trackString,
						cur = cur,
						max = max,
						maxed = cur >= max,
					}
				end
			end
		end
	end
	return out, sawAnyItem
end

--- The highest upgrade track currently equipped, as a NUMBER.
--- @return number|nil trackID  nil when nothing could be read
---
--- Exists for the personal-milestone check, which celebrates reaching a higher
--- track than ever before. It must compare numerically: trackString is localised
--- (see the header), so remembering a NAME would make the milestone fire again in
--- another language and never fire for a player who switches clients.
---
--- nil and 0 mean different things here. nil is "the scan told us nothing" and the
--- caller must not record it as a new best -- otherwise a login that reads no gear
--- would reset the record and re-congratulate the player later.
function ns.GetHighestEquippedTrackID()
	local entries, sawAnyItem = ScanEquippedTracks()
	if not sawAnyItem or #entries == 0 then
		return nil
	end
	local best
	for _, e in ipairs(entries) do
		if type(e.trackID) == "number" and e.trackID > 0 and (not best or e.trackID > best) then
			best = e.trackID
		end
	end
	return best
end

--- How many equipped slots sit at their track ceiling, and which track that is.
--- @return number|nil maxedCount, string|nil trackName, number|nil readableCount
--- Returns nil when nothing could be read — an unreadable scan must not be reported
--- as "nothing is maxed", which would be a confident falsehood about your gear.
function ns.GetTrackCeilingSummary()
	local entries, sawAnyItem = ScanEquippedTracks()
	if not sawAnyItem or #entries == 0 then
		return nil, nil, nil
	end
	local maxed, byTrack = 0, {}
	for _, e in ipairs(entries) do
		if e.maxed then
			maxed = maxed + 1
			if e.trackID and e.trackID > 0 then
				byTrack[e.trackID] = byTrack[e.trackID] or { n = 0, name = e.trackName }
				byTrack[e.trackID].n = byTrack[e.trackID].n + 1
			end
		end
	end
	-- Report the track most of the ceiling-hitting slots share; ties break toward the
	-- higher trackID, which is the one the player is actually held back by.
	local bestID, best
	for id, rec in pairs(byTrack) do
		if not best or rec.n > best.n or (rec.n == best.n and id > (bestID or 0)) then
			bestID, best = id, rec
		end
	end
	return maxed, best and best.name or nil, #entries
end

--- This Week / side-panel line, in the usual { text=, color= } shape. Empty when
--- nothing is at its ceiling — no ceiling, no nagging.
function ns.GetTrackCeilingSteps()
	local maxed, trackName = ns.GetTrackCeilingSummary()
	if not maxed or maxed == 0 then
		return {}
	end
	local text
	-- Singular keys (Rob's screenshot, 22 Oct 2026: "1 slots are maxed on Hero"), same fix as CHARPANEL_SOCKET_ONE.
	local one = maxed == 1
	if trackName then
		text = (ns:L(one and "TRACKCEIL_MAXED_ONE_FMT" or "TRACKCEIL_MAXED_FMT")):format(maxed, trackName)
	else
		text = (ns:L(one and "TRACKCEIL_MAXED_PLAIN_ONE_FMT" or "TRACKCEIL_MAXED_PLAIN_FMT")):format(maxed)
	end
	return { { text = text, color = "warn" } }
end

--------------------------------------------------------------------------------
-- Ascendant Venomstones (12.1.5; Rob, 23 Oct 2026: "Bouw optie A (regel in het karaktervenster)")
--------------------------------------------------------------------------------
-- MEASURED (mh-research, wago 12.1.5.70529, side-session-notes venomstones_2026-10-23.md): a soulbound bag ITEM,
-- not a currency, 10 per upgrade on every slot and track (spells 1309290 Myth / 1309291 Hero / 1309292 Tidal
-- Crafted). Counted by ID: 279997 "Insidious Venomstone" is a different item. No Warband bank, so bags + own bank.
-- Only a weapon, trinket or neck that is maxed on Hero or Myth qualifies. MEASURED by Rob, 23 Oct 2026 (`/mh tracks`
-- on his Holy Paladin): Champion = trackStringID 973, Hero = 974. Myth was not on him; that it is higher than 974 is
-- INFERRED from every higher track having had the higher id. The line still says "Hero or Myth only", in case not.
-- NOT measured: whether a piece that is already Ascendant still reads as maxed here.
local VENOMSTONE_ITEM = 280562
local VENOMSTONE_COST = 10
local VENOMSTONE_SLOTS = { [2] = true, [13] = true, [14] = true, [16] = true, [17] = true }
local VENOMSTONE_MIN_TRACK = 974 -- Hero

local SlotLabel

--- @return table|nil { count, cost, candidates = { {slot, label, trackName, cur, max}, ... } }
--- nil when the item API is missing — not "0 stones".
function ns.GetVenomstoneStatus()
	if not (C_Item and C_Item.GetItemCount) then
		return nil
	end
	local ok, count = pcall(C_Item.GetItemCount, VENOMSTONE_ITEM, true)
	if not ok then
		return nil
	end
	local candidates = {}
	for _, e in ipairs((ScanEquippedTracks())) do
		if e.maxed and VENOMSTONE_SLOTS[e.slot] and (e.trackID or 0) >= VENOMSTONE_MIN_TRACK then
			candidates[#candidates + 1] = {
				slot = e.slot, label = SlotLabel(e.slot), trackName = e.trackName, cur = e.cur, max = e.max,
			}
		end
	end
	return { count = tonumber(count) or 0, cost = VENOMSTONE_COST, candidates = candidates }
end

--- Side-panel lines, { text=, color= }. Max level only (the stones are Season 2 endgame), and silent when there is
--- neither a stone nor a maxed weapon, trinket or neck: nothing to do, nothing to say.
function ns.GetVenomstoneSteps()
	local maxLevel = (ns.PlayCardMaxLevel and ns.PlayCardMaxLevel()) or 90
	if (UnitLevel and UnitLevel("player") or 0) < maxLevel then
		return {}
	end
	local st = ns.GetVenomstoneStatus()
	if not st or (st.count == 0 and #st.candidates == 0) then
		return {}
	end
	local out = {}
	if st.count >= st.cost then
		out[#out + 1] = { text = ns:L("TRACKCEIL_VENOM_READY_FMT"):format(st.count), color = "good" }
	else
		out[#out + 1] = { text = ns:L("TRACKCEIL_VENOM_COUNT_FMT"):format(st.count, st.cost), color = "prog" }
	end
	if #st.candidates > 0 then
		local parts = {}
		for _, c in ipairs(st.candidates) do
			parts[#parts + 1] = ("%s (%s %d/%d)"):format(c.label, tostring(c.trackName or "?"), c.cur, c.max)
		end
		out[#out + 1] = { text = ns:L("TRACKCEIL_VENOM_CAND_FMT"):format(table.concat(parts, ", ")), color = "soft" }
	end
	return out
end

--------------------------------------------------------------------------------
-- /mh tracks
--------------------------------------------------------------------------------
-- Assigns the local declared above the Venomstone block, which uses it too.
function SlotLabel(slot)
	local names = {
		[1] = "HEADSLOT", [2] = "NECKSLOT", [3] = "SHOULDERSLOT", [5] = "CHESTSLOT",
		[6] = "WAISTSLOT", [7] = "LEGSSLOT", [8] = "FEETSLOT", [9] = "WRISTSLOT",
		[10] = "HANDSSLOT", [11] = "FINGER0SLOT", [12] = "FINGER1SLOT",
		[13] = "TRINKET0SLOT", [14] = "TRINKET1SLOT", [15] = "BACKSLOT",
		[16] = "MAINHANDSLOT", [17] = "SECONDARYHANDSLOT",
	}
	local key = names[slot]
	return (key and _G[key]) or ("Slot " .. tostring(slot))
end

function ns.PrintTrackCeiling()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s |cff8fd3ff%s|r"):format(prefix, ns:L("TRACKCEIL_TITLE")))

	local entries, sawAnyItem = ScanEquippedTracks()
	if not sawAnyItem then
		print("   " .. ns:L("TRACKCEIL_UNREADABLE"))
		return
	end
	if #entries == 0 then
		print("   " .. ns:L("TRACKCEIL_NO_TRACKS"))
		return
	end

	for _, e in ipairs(entries) do
		local mark = e.maxed and ("|cffe6c86b" .. ns:L("TRACKCEIL_AT_MAX") .. "|r")
			or ("|cff8cd98c" .. ns:L("TRACKCEIL_ROOM") .. "|r")
		-- The track id in grey (23 Oct 2026): measures which ids are Hero and Myth, for the Venomstone line.
		print(("   %s — %s %d/%d  %s |cff9d9d9d(track %d)|r"):format(
			SlotLabel(e.slot), tostring(e.trackName or "?"), e.cur, e.max, mark, e.trackID or 0
		))
	end

	local venom = ns.GetVenomstoneStatus()
	if venom then
		print("   " .. ns:L("TRACKCEIL_VENOM_COUNT_FMT"):format(venom.count, venom.cost))
	end

	local maxed = select(1, ns.GetTrackCeilingSummary())
	if maxed and maxed > 0 then
		print(("   |cff8fd3ff%s|r"):format(ns:L("TRACKCEIL_WHATNOW")))
		print("      " .. ns:L("TRACKCEIL_ROUTE_VAULT"))
		print("      " .. ns:L("TRACKCEIL_ROUTE_CRAFT"))
		print("      " .. ns:L("TRACKCEIL_ROUTE_SOLO"))
		print("      " .. ns:L("TRACKCEIL_ROUTE_VENOM"))
		-- The crafting route above tells you to craft; this says where the how-to is.
		-- Without it the advice stops exactly where the questions start.
		print("      |cff9d9d9d" .. (ns:L("TRACKCEIL_SEE_CODEX")):format(ns:L("CODEX_CRAFTGEAR_TITLE")) .. "|r")
		print("      |cff9d9d9d" .. ns:L("TRACKCEIL_NOT_CRESTS") .. "|r")
	end
end
