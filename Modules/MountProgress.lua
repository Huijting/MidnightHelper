--[[
	Weekly collectible-mount progress (Midnight 12.0.7).

	Several new mounts are earned by collecting a time-gated item or by
	maintaining a weekly buff over multiple weeks. This module tracks that
	progress and surfaces it on the This Week dashboard, hiding a mount once
	you've actually collected it, and showing a short "how to get it" hint.

	Verified IDs (docs/PTR_12.0.7_DATA.md + Wowhead, July 2026):
	  - Luminous Sporeglider = mount spell 1284973; 4x Delicious Sporesnack
	    (item 269245), ~1 per week from Rotmire in the Sporefall raid.
	  - Spawn of Vyranoth = mount item 258884; achievement 61463 "Master of the
	    Turbulent Timeways V" (Gain Mastery of the Timeways in 4 of the event's
	    5 weeks).

	Never-lie: item counts come from the live bag API, achievement progress from
	the achievement API, and "collected?" from the Mount Journal — no fabricated
	progress. Two source types:
	  - itemID       -> progress = live bag count (GetItemCount).
	  - achievementID -> progress = the achievement's first-criterion quantity.
]]

local _, ns = ...

-- Nearly every Midnight collectible mount is bought with Voidlight Marl, so the how-to
-- line hovers that currency's tooltip by default; the few that aren't a purchase set
-- `noMarl = true` on their entry.
local VOIDLIGHT_MARL = 3316

local TRACKED = {
	{
		key = "sporeglider",
		mountSpellID = 1284973,   -- Luminous Sporeglider (Wowhead-verified)
		itemID = 269245,          -- Delicious Sporesnack (1/week, Rotmire/Sporefall)
		need = 4,
		noMarl = true, -- earned from items, not a Voidlight Marl purchase
		fallbackName = "Luminous Sporeglider",
		howToKey = "MOUNTPROG_SPOREGLIDER_HOWTO",
		-- Sporefall entrance: back of The Grudge Pit, SE Harandar. Web guides say
		-- ~73.7/66.5; corroborated by our own AchievementsData "Sporelord's Fight
		-- Prize" treasure at 2413 73.65/65.35 (same spot). Confirm in-game.
		route = { mapID = 2413, x = 73.7, y = 66.5, nameKey = "MOUNTPROG_SPOREGLIDER_ROUTE_NAME" },
	},
	{
		-- ⚠️ MEASURED 16 aug 2026, all of it from Rob's own client. The achievement's
		-- reward line (`/mh ach id 63359`) named the mount, and `/mh mount venomfang`
		-- gave the ids from his Mount Journal. Nothing here came from a database:
		-- searching the installed addons for "Venomfang" produced a Battle for Azeroth
		-- trash ability, which is why the lookup command exists at all.
		--
		-- ⚠️ metaAchievementID, not achievementID, and the field name is the misleading
		-- part. achievementID reads the FIRST criterion's quantity, which is right for a
		-- counter ("collect 50 of X") and wrong here: 63359 has 22 separate treasure
		-- criteria and its first one is a single chest. metaAchievementID counts
		-- COMPLETED criteria, which is exactly "3 of 22 treasures found".
		key = "venomfang",
		mountSpellID = 1297224,      -- Auriferous Venomfang (mountID 3023)
		metaAchievementID = 63359,   -- Treasures of the Coiled Isle
		need = 22,
		noMarl = true, -- an achievement reward, not a Voidlight Marl purchase
		fallbackName = "Auriferous Venomfang",
		howToKey = "MOUNTPROG_VENOMFANG_HOWTO",
		gotoTab = "achievements",
		gotoTabLabelKey = "TAB_ACHIEVEMENTS",
		-- No route field: the Achievements tab already runs this exact hunt with all 22
		-- nodes and auto-advance. A second, shorter route to the same treasures would be
		-- a worse copy of one we already ship.
	},
	{
		key = "vyranoth",
		mountItemID = 258884,     -- Spawn of Vyranoth (teaches the mount)
		achievementID = 61463,    -- Master of the Turbulent Timeways V (4 of 5 weeks)
		need = 4,
		noMarl = true, -- Timewalking event reward, not a Voidlight Marl purchase
		fallbackName = "Spawn of Vyranoth",
		howToKey = "MOUNTPROG_VYRANOTH_HOWTO",
	},
	{
		key = "torturedgorger",
		mountItemID = 275664,        -- Tortured Gorger (teaches the mount)
		metaAchievementID = 63264,   -- Heroic Showdowns: 6 heroic feats in Naigtal & Val
		need = 6,
		fallbackName = "Tortured Gorger",
		howToKey = "MOUNTPROG_GORGER_HOWTO",
		-- Bought from Kifaan (Naigtal / Val Umbral Base Camp) for 15 Voidlight Marl,
		-- but ONLY after the Heroic Showdowns meta (63264) is done — the ~2-week meta
		-- is the real gate, so we show progress on it (X of 6 feats). No route button:
		-- the vendor coords are not verified, and you cannot buy until the meta is done.
	},
	{
		key = "starcarver",
		mountItemID = 274649,        -- Voidmancer's Starcarver (void-surfboard mount)
		metaAchievementID = 62873,   -- "A Trip Around the Stars": 6 Val Showdown feats
		need = 6,
		fallbackName = "Voidmancer's Starcarver",
		howToKey = "MOUNTPROG_STARCARVER_HOWTO",
	},
	{
		key = "nullframe",
		mountItemID = 274650,        -- Netherforged Nullframe (mount)
		metaAchievementID = 62874,   -- "A Trip Through the Stars": 6 Naigtal Showdown feats
		need = 6,
		fallbackName = "Netherforged Nullframe",
		howToKey = "MOUNTPROG_NULLFRAME_HOWTO",
	},

	-- Faction-renown mounts: bought from the faction quartermaster once you reach the
	-- required Renown level (Amani / Hara'ti / Singularity also charge Voidlight Marl).
	-- Renown levels + Marl costs verified on warcraftmounts.com; faction IDs verified on
	-- Wowhead faction= pages; teaching-item IDs are search-corroborated (medium confidence
	-- — if one never hides after you collect it, that item ID is the thing to re-check).
	-- We only surface a renown mount once you have ANY renown with the faction, so
	-- un-started factions don't clutter the list with 0/NN goals.
	--
	-- ⚠️ OPEN, 19 aug: IS THERE A SIXTH MIDNIGHT FACTION WE HAVE NEVER LISTED?
	--
	-- A 12.1 mount guide describes two mounts sold by Jansari at Tokka's Landing for
	-- Voidlight Marl at renown 17 and 19 — Indigo Coiled Horror and Violet-Backed
	-- Skyfang — from a faction it calls "Zul'jara's Forces". That is precisely the shape
	-- of every row below: one faction, a mount at 17 and another at 19, paid in Marl.
	--
	-- We carry five faction ids: 2696 Amani, 2704 Hara'ti, 2710 Silvermoon, 2699
	-- Singularity, 2792 Ritual. None of them is a Coiled Isle faction by name.
	--
	-- ⚠️ AND THE SOURCE IS AN AUTO-TRANSCRIBED SPOKEN WORD, so the name is worth very
	-- little: the same transcript renders Tokka's Landing as "Tucker's Landing". Either
	-- a whole renown track is missing from this list — two mounts and a progress bar
	-- nobody sees — or it is one of the five above, misheard.
	--
	-- `C_MajorFactions.GetMajorFactionIDs()` settles it, and `/mh atal` now prints it.
	-- Do NOT add a sixth row until that returns a sixth id.
	{ key = "amanibear",  mountItemID = 257219, renownFactionID = 2696, need = 17, fallbackName = "Amani Blessed Bear",             howToKey = "MOUNTPROG_AMANIBEAR_HOWTO" },
	{ key = "amaniwind",  mountItemID = 250889, renownFactionID = 2696, need = 19, fallbackName = "Amani Windcaller",              howToKey = "MOUNTPROG_AMANIWIND_HOWTO" },
	{ key = "grimlynx",   mountItemID = 246734, renownFactionID = 2704, need = 16, fallbackName = "Fierce Grimlynx",              howToKey = "MOUNTPROG_GRIMLYNX_HOWTO" },
	{ key = "ceruleansg", mountItemID = 252014, renownFactionID = 2704, need = 19, fallbackName = "Cerulean Sporeglider",         howToKey = "MOUNTPROG_CERULEANSG_HOWTO" },
	{ key = "crimsonhs",  mountItemID = 257154, renownFactionID = 2710, need = 17, fallbackName = "Crimson Silvermoon Hawkstrider", howToKey = "MOUNTPROG_CRIMSONHS_HOWTO" },
	{ key = "shredclaw",  mountItemID = 257445, renownFactionID = 2699, need = 17, fallbackName = "Ravenous Shredclaw",           howToKey = "MOUNTPROG_SHREDCLAW_HOWTO" },
	{ key = "stormray",   mountItemID = 260696, renownFactionID = 2699, need = 19, fallbackName = "Voidbound Stormray",           howToKey = "MOUNTPROG_STORMRAY_HOWTO" },
	-- Umbral Dragonhawk: not a renown purchase — reward for "Life of the Party" (62190),
	-- max reputation with all four Silvermoon Court sub-factions (item ID plausible-only).
	{ key = "umbraldh",   mountItemID = 257144, metaAchievementID = 62190, need = 4, noMarl = true, fallbackName = "Umbral Dragonhawk",          howToKey = "MOUNTPROG_UMBRALDH_HOWTO" },

	-- Void-Touched Hawkstrider: Ritual Sites renown mount (its own 8-rank track,
	-- faction 2792), bought from Sergeant Vornin for 4,500 Voidlight Marl at Renown 8.
	-- (Verified: NOT gated by any Void Incursion meta-achievement — it's the renown.)
	{ key = "voidhawk",   mountItemID = 268578, renownFactionID = 2792, need = 8, fallbackName = "Void-Touched Hawkstrider",     howToKey = "MOUNTPROG_VOIDHAWK_HOWTO" },
	-- Anu'shalla, Shadow's Guidance (purple Anu'relos recolor): reward for the 600-mount
	-- "Insurmountable Collection". Faction-paired achievement (Horde 62096 / Alliance
	-- 62103) — we read whichever your character has; progress = mounts obtained toward 600.
	{ key = "anushalla",  mountItemID = 265656, achievementID = 62096, achievementIDAlt = 62103, need = 600, noMarl = true, fallbackName = "Anu'shalla, Shadow's Guidance", howToKey = "MOUNTPROG_ANUSHALLA_HOWTO" },

	-- Ritual Sites hunts. These have NO numeric progress the game can give us (RNG drops,
	-- a one-time puzzle, a hidden quest chain), so `noProgress` renders them as a plain
	-- ✓/✗ with a how-to instead of a misleading X-of-N bar. The mount SPELL ids are the
	-- confirmed anchors; the teaching item is only a fallback for the collected-check.
	{ key = "voidlynx",   mountSpellID = 1287359, mountItemID = 270058, noProgress = true, noMarl = true, fallbackName = "Void-Corrupted Lynx",      howToKey = "MOUNTPROG_VOIDLYNX_HOWTO" },
	{ key = "snapdragon", mountSpellID = 1287357, mountItemID = 270041, noProgress = true, noMarl = true, fallbackName = "Void-Touched Snapdragon",  howToKey = "MOUNTPROG_SNAPDRAGON_HOWTO" },
	{ key = "hexeagle",   mountSpellID = 1286606, mountItemID = 269828, noProgress = true, noMarl = true, fallbackName = "Void-Corrupted Hex Eagle", howToKey = "MOUNTPROG_HEXEAGLE_HOWTO" },
	-- Warbear teaching-item 257225 is single-sourced (plausible); the mount spell is confirmed.
	{ key = "warbear",    mountSpellID = 1261362, mountItemID = 257225, noProgress = true, noMarl = true, fallbackName = "Witherbark Warbear Mother", howToKey = "MOUNTPROG_WARBEAR_HOWTO" },
}

--- @return isCollected(bool|nil), localizedName(string|nil)
local function InfoFromMountID(mid)
	if not (mid and C_MountJournal and C_MountJournal.GetMountInfoByID) then
		return nil
	end
	-- GetMountInfoByID: name, spellID, icon, isActive, isUsable, sourceType,
	-- isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID.
	local v = { pcall(C_MountJournal.GetMountInfoByID, mid) }
	if not v[1] then
		return nil
	end
	return v[12] == true, v[2]
end

--- @return isCollected(bool|nil), localizedName(string|nil), mountID(number|nil)
local function MountStatus(m)
	local mid
	if m.mountSpellID and C_MountJournal and C_MountJournal.GetMountFromSpell then
		local ok, x = pcall(C_MountJournal.GetMountFromSpell, m.mountSpellID)
		if ok and x then
			mid = x
		end
	end
	if not mid and m.mountItemID and C_MountJournal and C_MountJournal.GetMountFromItem then
		local ok, x = pcall(C_MountJournal.GetMountFromItem, m.mountItemID)
		if ok and x then
			mid = x
		end
	end
	if mid then
		local collected, name = InfoFromMountID(mid)
		return collected, name, mid
	end
	return nil, nil, nil
end

--- /mh mount <text> — find a mount's id by name, the sibling of /mh ach <text>.
---
--- ⚠️ LOOKUP TOOL, NOT SHIPPED LOGIC. Mount names are localised, so nothing in the addon
--- may resolve one at runtime — the same rule AchievementFind.lua carries. Names go in
--- here, ids go into the data table.
---
--- Why it exists: the Treasures of the Coiled Isle achievement rewards "Auriferous
--- Venomfang" (measured from Rob's client, 16 aug), and our mount tracker keys on a
--- mount spell or item id. Neither is documented anywhere, and no installed addon knows
--- the mount — grepping for it produced a Battle for Azeroth trash ability with a
--- similar name, which is exactly the false positive CLAUDE.md warns about.
---
--- The Mount Journal knows. Ask it instead of hunting a database.
function ns.PrintMountFind(query)
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	if type(query) ~= "string" or query:gsub("%s", "") == "" then
		print(("%s usage: /mh mount <part of the name>"):format(prefix))
		return
	end
	if not (C_MountJournal and C_MountJournal.GetMountIDs and C_MountJournal.GetMountInfoByID) then
		print(("%s the Mount Journal API is not available."):format(prefix))
		return
	end
	local okIDs, ids = pcall(C_MountJournal.GetMountIDs)
	if not okIDs or type(ids) ~= "table" then
		print(("%s GetMountIDs returned nothing usable."):format(prefix))
		return
	end
	local needle, hits = query:lower(), 0
	print(("%s mounts matching \"%s\" (%d known to your journal):"):format(
		prefix, query, #ids))
	for _, mid in ipairs(ids) do
		local v = { pcall(C_MountJournal.GetMountInfoByID, mid) }
		if v[1] and type(v[2]) == "string" and v[2]:lower():find(needle, 1, true) then
			hits = hits + 1
			-- spellID is what MountStatus prefers, so print it first and plainly.
			print(("   %-34s mountID |cffffffff%s|r  spellID |cffffffff%s|r  %s"):format(
				v[2], tostring(mid), tostring(v[3]),
				v[12] and "|cff40c040collected|r" or "|cff9d9d9dnot collected|r"))
		end
	end
	if hits == 0 then
		-- ⚠️ Not the same as "this mount does not exist". The journal lists mounts the
		-- account can know about; one that has never been seen may simply be absent.
		print("   |cffffd100nothing matched — that is not proof the mount does not exist, only that your journal has no entry for it.|r")
	end
end

local function ItemCount(itemID)
	if itemID and C_Item and C_Item.GetItemCount then
		local ok, n = pcall(C_Item.GetItemCount, itemID)
		if ok and type(n) == "number" then
			return n
		end
	end
	return 0
end

--- Progress from an achievement's first criterion (quantity), e.g. weeks done.
local function AchievementQuantity(achID)
	if not (achID and GetAchievementCriteriaInfo) then
		return 0
	end
	-- Returns: criteriaString, criteriaType, completed, quantity, reqQuantity, ...
	local ok, _cs, _ct, _completed, quantity = pcall(GetAchievementCriteriaInfo, achID, 1)
	if ok and type(quantity) == "number" then
		return quantity
	end
	return 0
end

--- Progress as the number of COMPLETED criteria of a meta-achievement (e.g. a zone
--- meta that gates a mount purchase). Counts the sub-achievement criteria that are
--- done, so "have" reads as X of N feats.
local function CompletedCriteriaCount(achID)
	if not (achID and GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return 0
	end
	local okN, n = pcall(GetAchievementNumCriteria, achID)
	if not okN or type(n) ~= "number" or n <= 0 then
		return 0
	end
	local done = 0
	for i = 1, n do
		-- 3rd return of GetAchievementCriteriaInfo is `completed` (boolean).
		local ok, _cs, _ct, completed = pcall(GetAchievementCriteriaInfo, achID, i)
		if ok and completed == true then
			done = done + 1
		end
	end
	return done
end

--- Live total criteria of a meta-achievement, so the "N" in "X of N" tracks the
--- game rather than a hardcoded guess. Returns nil when unavailable (caller keeps
--- its static `need`).
local function MetaCriteriaTotal(achID)
	if not (achID and GetAchievementNumCriteria) then
		return nil
	end
	local ok, n = pcall(GetAchievementNumCriteria, achID)
	if ok and type(n) == "number" and n > 0 then
		return n
	end
	return nil
end

--- Current Renown level with a Major Faction (0 when not unlocked / not started).
local function RenownLevel(factionID)
	if not (factionID and C_MajorFactions) then
		return 0
	end
	if C_MajorFactions.GetCurrentRenownLevel then
		local ok, lvl = pcall(C_MajorFactions.GetCurrentRenownLevel, factionID)
		if ok and type(lvl) == "number" then
			return lvl
		end
	end
	if C_MajorFactions.GetMajorFactionData then
		local ok, data = pcall(C_MajorFactions.GetMajorFactionData, factionID)
		if ok and type(data) == "table" and type(data.renownLevel) == "number" then
			return data.renownLevel
		end
	end
	return 0
end

--- Progress for tracked collectible mounts you have NOT collected yet.
--- @return list of { key, name, have, need, howToKey }
--- Progress for tracked collectible mounts.
--- @param includeCollected boolean|nil When true, also return mounts you already own
---   (each carries `collected=true`) so the panel can show a full ✓/✗ checklist. When
---   false/nil, returns only the in-progress mounts (used for the Home count).
--- @return list of { key, name, have, need, collected, howToKey, route, mountID, ... }
function ns.GetWeeklyMountProgress(includeCollected)
	local out = {}
	for _, m in ipairs(TRACKED) do
		local collected, mountName, mountID = MountStatus(m)
		local isCollected = (collected == true)
		if includeCollected or not isCollected then -- data-not-loaded (nil) still shows
			local have
			local need = m.need
			local show = true
			if m.noProgress then
				-- Pure hunt (RNG drop / puzzle / hidden chain): no honest X-of-N exists,
				-- so we report no numbers and the panel shows just a ✓/✗ with the how-to.
				have, need = nil, nil
			elseif m.itemID then
				have = ItemCount(m.itemID)
			elseif m.renownFactionID then
				have = RenownLevel(m.renownFactionID)
				-- Only surface once you actually have renown with the faction, so
				-- un-started factions don't clutter the in-progress list with 0/NN goals.
				show = have >= 1
			elseif m.metaAchievementID then
				have = CompletedCriteriaCount(m.metaAchievementID)
				need = MetaCriteriaTotal(m.metaAchievementID) or need
			elseif m.achievementID then
				have = AchievementQuantity(m.achievementID)
				if m.achievementIDAlt then
					-- Faction-paired achievement: take whichever your character has.
					have = math.max(have, AchievementQuantity(m.achievementIDAlt))
				end
			else
				have = 0
			end
			-- The `show` filter only trims the in-progress view; the full checklist and
			-- any already-collected mount always appear.
			if includeCollected or isCollected then
				show = true
			end
			if show then
				if have and need then
					have = math.min(have, need)
				end
				out[#out + 1] = {
					key = m.key,
					name = (type(mountName) == "string" and mountName ~= "" and mountName) or m.fallbackName,
					have = have, -- nil for no-progress hunts
					need = need,
					collected = isCollected,
					howToKey = m.howToKey,
					-- Currency the how-to line hovers (nil for non-purchase mounts).
					currencyID = (not m.noMarl) and VOIDLIGHT_MARL or nil,
					route = m.route,
				-- Carried through so the panel can offer "open that tab" as a button
				-- next to a how-to that names one.
				gotoTab = m.gotoTab,
				gotoTabLabelKey = m.gotoTabLabelKey,
					-- Tooltip / 3D-model sources (best-effort): the resolved mount, plus
					-- the teaching item / mount spell as fallbacks.
					mountID = mountID,
					mountItemID = m.mountItemID,
					mountSpellID = m.mountSpellID,
				}
			end
		end
	end
	return out
end

--- Just the names, for the search index — which is rebuilt on every keystroke.
--- GetWeeklyMountProgress walks achievement criteria and bag counts, which is far more
--- work than a search box should do per typed character. A Mount Journal lookup is
--- cheap, and the fallback name means a hit still lands before the journal is warm.
--- @return list of { key, name }
function ns.GetMountNameRoster()
	local out = {}
	for _, m in ipairs(TRACKED) do
		local _collected, mountName = MountStatus(m)
		out[#out + 1] = {
			key = m.key,
			name = (type(mountName) == "string" and mountName ~= "" and mountName) or m.fallbackName,
		}
	end
	return out
end
