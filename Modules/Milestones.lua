local _, ns = ...

--[[
	Midnight Helper — personal milestones.

	Everything else in this addon says "here is what you should do next". This one
	says "look what you just did". It marks a handful of genuine firsts with a line,
	once, and then never mentions them again.

	Stored in ns.db.milestones = { [id] = unixTime }. Keys starting with "_" are
	bookkeeping, not awarded milestones, and are skipped by the listing.

	⚠️ THE TRACK MILESTONE — why it never names a track.
	We deliberately do NOT try to recognise "Myth". trackString is localised (the bug
	that broke the Omnium Folio button on every non-English client) and hardcoding
	which numeric trackStringID means Myth would be a guess that breaks whenever
	Blizzard renumbers. Instead we remember the highest trackStringID you have ever
	worn, via ns.GetHighestEquippedTrackID(), and celebrate when a higher one turns
	up. Purely comparative: no table of names, no locale trap, true every season.

	Never-lie, further:
	  • A milestone fires only on a signal we can actually read. Nothing is inferred
	    from item level, and nothing fires "probably".
	  • An unreadable scan is not a zero. If the track scan returns nil we leave the
	    stored best alone -- overwriting it would later re-congratulate the player for
	    something they had already passed.
	  • If an API is missing the milestone simply never fires. We do not guess, and we
	    never claim the player has NOT achieved something.
	  • Fired once, kept forever. We never re-congratulate to pad the feature.
]]

local function Store()
	if not ns.db then
		return nil
	end
	ns.db.milestones = ns.db.milestones or {}
	return ns.db.milestones
end

--- Has this milestone already fired?
function ns.HasMilestone(id)
	local s = Store()
	return (s and id ~= nil and s[id] ~= nil) and true or false
end

--- Fire a milestone once.
--- @return boolean awarded true only when this call is what earned it
--- @param icon number|string|nil texture the caller READ from the game, never a guess
function ns.AwardMilestone(id, titleKey, bodyKey, icon)
	local s = Store()
	if not s or type(id) ~= "string" or s[id] then
		return false
	end
	s[id] = (time and time()) or 0
	local title = titleKey and ns:L(titleKey) or ""
	local body = bodyKey and ns:L(bodyKey) or ""
	-- Show it on the addon's own achievement-style card. MidnightToast is a queue with
	-- exactly that look, already used for the delve bounty, so this is wiring rather
	-- than a new system. Until now a milestone was a grey chat line — the wrong shape
	-- for the one feature in here that celebrates something.
	--
	-- Keys, not resolved strings: QueueMidnightToast resolves them itself (same as
	-- DelveItemsPopup), so translations stay in one place.
	--
	-- The player's toast setting wins. QueueMidnightToast does nothing when toasts are
	-- off, and there is deliberately NO chat fallback for that case — routing around
	-- someone's setting is not a fix. The milestone is still recorded and still shows
	-- in /mh milestones. Chat remains only for the case where MidnightToast is not
	-- loaded at all, so the moment is never silently lost.
	--
	-- No icon is invented here. Callers pass one only when they could read it from the
	-- game (the mount's own icon, an achievement's icon); otherwise the toast uses its
	-- own default rather than a texture id nobody has seen.
	if ns.QueueMidnightToast then
		pcall(ns.QueueMidnightToast, {
			id = "milestone_" .. id, -- the queue de-dupes on id, on top of the store above
			clickHintKey = "MILE_CLICK_HINT",
			-- A celebration you cannot read is not a celebration: the 4.25s default
			-- was gone before Rob could click it (2026-07-25).
			displaySec = 12,
			icon = icon,
			titleKey = titleKey,
			bodyKey = bodyKey,
			onClick = function()
				if ns.PrintMilestones then
					ns.PrintMilestones()
				end
			end,
		})
	else
		pcall(print, ("|cffe8c36aMidnight Helper|r — %s  %s"):format(title, body))
	end
	return true
end

--------------------------------------------------------------------------------
-- 1. a higher upgrade track than ever before
--------------------------------------------------------------------------------

local function CheckTrackProgress()
	if type(ns.GetHighestEquippedTrackID) ~= "function" then
		return
	end
	local s = Store()
	if not s then
		return
	end
	local ok, best = pcall(ns.GetHighestEquippedTrackID)
	-- nil = nothing readable this time. Say nothing and change nothing.
	if not ok or type(best) ~= "number" then
		return
	end

	local prev = s._bestTrackID
	if type(prev) ~= "number" then
		s._bestTrackID = best -- first sighting: record it, do not congratulate
		return
	end
	if best > prev then
		s._bestTrackID = best
		-- One id per step up, so each new track gets its own moment.
		ns.AwardMilestone("track_" .. best, "MILE_TRACK_TITLE", "MILE_TRACK_BODY")
	end
end

--------------------------------------------------------------------------------
-- 2. first timed keystone
--------------------------------------------------------------------------------

--- ⚠️ UNVERIFIED against this client: neither CHALLENGE_MODE_COMPLETED nor
--- C_ChallengeMode.GetChallengeCompletionInfo is used anywhere else in MH, so the
--- payload shape is taken on trust from the API docs. Everything is guarded and the
--- milestone only fires on an explicit onTime == true. If the shape differs, this
--- milestone never fires -- which is the honest failure mode. Do not "fix" it by
--- loosening the check until someone has timed a key and confirmed.
local function CheckTimedKey()
	if not (C_ChallengeMode and C_ChallengeMode.GetChallengeCompletionInfo) then
		return
	end
	local ok, info = pcall(C_ChallengeMode.GetChallengeCompletionInfo)
	if ok and type(info) == "table" and info.onTime == true then
		-- Borrow the Keystone Master achievement's own icon (10th return): real game
		-- art for a keystone moment, and read rather than guessed. Nil if the id ever
		-- stops resolving, which just means the toast uses its default.
		local keyIcon
		if GetAchievementInfo then
			local okA, _, _, _, _, _, _, _, _, _, achIcon = pcall(GetAchievementInfo, 61256)
			keyIcon = okA and achIcon or nil
		end
		ns.AwardMilestone("first_timed_key", "MILE_KEY_TITLE", "MILE_KEY_BODY", keyIcon)
	end
end

--------------------------------------------------------------------------------
-- 3. first wishlist mount actually collected
--------------------------------------------------------------------------------

local function CheckWishlistMount()
	if type(ns.GetWishedMountIDs) ~= "function" then
		return
	end
	if not (C_MountJournal and C_MountJournal.GetMountInfoByID) then
		return
	end
	local okList, wished = pcall(ns.GetWishedMountIDs)
	if not okList or type(wished) ~= "table" then
		return
	end
	for _, mountID in ipairs(wished) do
		-- GetMountInfoByID returns, in order: name, spellID, icon, isActive, isUsable,
		-- sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar,
		-- isCollected, mountID. So icon is the 3rd and isCollected the ELEVENTH —
		-- MountProgress reads it as v[12] of a pcall table, which is the same thing.
		--
		-- ⚠️ This line was off by one from 2026-07-22 until 2026-07-25: it had nine
		-- blanks, so `collected` was reading shouldHideOnChar. Count the blanks against
		-- the list above before touching it; a wrong slot here silently celebrates the
		-- wrong thing, and the failure is invisible.
		local ok, _, _, mountIcon, _, _, _, _, _, _, _, collected =
			pcall(C_MountJournal.GetMountInfoByID, mountID)
		if ok and collected then
			ns.AwardMilestone("first_wishlist_mount", "MILE_MOUNT_TITLE", "MILE_MOUNT_BODY", mountIcon)
			return
		end
	end
end

--------------------------------------------------------------------------------
-- wiring
--------------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("NEW_MOUNT_ADDED")
if not C_EventUtils or not C_EventUtils.IsEventValid or C_EventUtils.IsEventValid("CHALLENGE_MODE_COMPLETED") then
	pcall(f.RegisterEvent, f, "CHALLENGE_MODE_COMPLETED")
end

f:SetScript("OnEvent", function(_, event)
	if event == "CHALLENGE_MODE_COMPLETED" then
		pcall(CheckTimedKey)
		return
	end
	-- A short delay: equipment and journal data are not settled the instant the
	-- event fires, and a milestone read too early would compare against stale gear.
	if C_Timer and C_Timer.After then
		C_Timer.After(1, function()
			pcall(CheckTrackProgress)
			pcall(CheckWishlistMount)
		end)
	end
end)

--- /mh milestones — list what has been earned so far.
function ns.PrintMilestones()
	local s = Store()
	local prefix = "|cffe8c36aMidnight Helper|r"
	if not s then
		return
	end
	local n = 0
	for id, when in pairs(s) do
		if type(id) == "string" and id:sub(1, 1) ~= "_" then
			n = n + 1
			local stamp = (date and type(when) == "number" and when > 0) and date("%d/%m/%Y", when) or "?"
			print(("%s — %s (%s)"):format(prefix, id, stamp))
		end
	end
	if n == 0 then
		print(("%s — %s"):format(prefix, ns:L("MILE_NONE_YET")))
	end
end

--- /mh milestones preview — show what a milestone card looks like, on demand.
---
--- A milestone fires once and never again, which is the point — but it means anyone
--- who already earned theirs can never see the card. Rob hit exactly that: all three
--- of his were awarded before the card existed (2026-07-25).
---
--- Touches nothing real: it does not write to the store, does not award anything, and
--- uses its own toast id so it can never collide with or de-dupe against a genuine
--- milestone. Same texts as the real thing, so what you see is what you would get.
function ns.PreviewMilestoneToast()
	local prefix = ("|cffffcc00%s|r"):format(ns.L and ns:L("PRINT_PREFIX") or "MH")
	if not ns.QueueMidnightToast then
		print(prefix .. " toast system not loaded")
		return
	end
	-- Borrow the mount milestone's wording and, if a wished mount can be read, its
	-- icon — so the preview shows the real arrangement rather than a mock-up.
	local icon
	if ns.GetWishedMountIDs and C_MountJournal and C_MountJournal.GetMountInfoByID then
		local okList, wished = pcall(ns.GetWishedMountIDs)
		if okList and type(wished) == "table" and wished[1] then
			local ok, _, _, mountIcon = pcall(C_MountJournal.GetMountInfoByID, wished[1])
			icon = ok and mountIcon or nil
		end
	end
	pcall(ns.QueueMidnightToast, {
		id = "milestone_preview",
			clickHintKey = "MILE_CLICK_HINT",
			-- A celebration you cannot read is not a celebration: the 4.25s default
			-- was gone before Rob could click it (2026-07-25).
			displaySec = 12,
		icon = icon,
		titleKey = "MILE_MOUNT_TITLE",
		bodyKey = "MILE_MOUNT_BODY",
		onClick = function()
			if ns.PrintMilestones then
				ns.PrintMilestones()
			end
		end,
	})
	print(prefix .. " milestone card preview queued (nothing was awarded or stored).")
end
