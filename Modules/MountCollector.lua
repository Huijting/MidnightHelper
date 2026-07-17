local _, ns = ...

--[[
	Midnight Helper — Mount wishlist (Spec 13).

	Star any mount in the Mounts tab; Home then reminds you which of YOUR picks you
	still don't have. Builds on the existing mount stack (MountProgress for the
	verified data, MountsPanel for the tab and its hover preview).

	Scope, deliberately (never-lie):
	  • The showcase reports YOUR WISHLIST — "3 of 5 collected" — never "X of all
	    Midnight mounts". A claimed-complete catalogue means hand-maintaining a list
	    that silently rots every patch; a wishlist is true by construction.
	  • Identity and collected-state come from C_MountJournal (pcall-guarded), read
	    the same way MountProgress proves works: isCollected is the 11th return, so
	    v[12] of a { pcall(...) } table. Do not "simplify" that away.
	  • The wishlist is keyed by mountID and lives account-wide, because that is what
	    collecting a mount actually is.

	Attempt/luck tracking (kills-per-drop) is deliberately NOT here: it needs verified
	drop rates and a real kill hook, and shipping the empty scaffolding would only add
	code that does nothing. It's a small addition once that data exists.
]]

-- GetMountInfoByID: name, spellID, icon, isActive, isUsable, sourceType, isFavorite,
-- isFactionSpecific, faction, shouldHideOnChar, isCollected, mountID.
--- @return string|nil name, boolean|nil isCollected
local function mountInfo(mountID)
	if not (mountID and C_MountJournal and C_MountJournal.GetMountInfoByID) then
		return nil
	end
	local v = { pcall(C_MountJournal.GetMountInfoByID, mountID) }
	if not v[1] then
		return nil
	end
	return v[2], v[12] == true
end

local function openMountJournal()
	if ToggleCollectionsJournal then
		pcall(ToggleCollectionsJournal, 1) -- 1 = Mounts
	end
end

--------------------------------------------------------------------------------
-- Wishlist (account-wide, keyed by mountID)
--------------------------------------------------------------------------------

local function wl()
	ns.db = ns.db or {}
	ns.db.mountWishlist = ns.db.mountWishlist or {}
	return ns.db.mountWishlist
end

function ns.IsMountWished(mountID)
	return mountID ~= nil and wl()[mountID] == true
end

function ns.ToggleMountWish(mountID)
	if not mountID then
		return
	end
	local t = wl()
	t[mountID] = (not t[mountID]) or nil
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
	return t[mountID] == true
end

function ns.GetWishedMountIDs()
	local out = {}
	for id, on in pairs(wl()) do
		if on then
			out[#out + 1] = id
		end
	end
	table.sort(out)
	return out
end

--- Honest summary: YOUR wishlist, not "all Midnight mounts".
--- @return integer have, integer total
function ns.GetWishlistSummary()
	local have, total = 0, 0
	for _, id in ipairs(ns.GetWishedMountIDs()) do
		total = total + 1
		local _, collected = mountInfo(id)
		if collected then
			have = have + 1
		end
	end
	return have, total
end

--------------------------------------------------------------------------------
-- Home steps: what you're still chasing
--------------------------------------------------------------------------------

local MAX_SHOWN = 3 -- Home is a dashboard, not a list; the tab has the full picture.

--- @return table steps  { { text, color, onClick }, ... }
function ns.GetMountWishlistSteps()
	local steps = {}
	local ids = ns.GetWishedMountIDs()
	if #ids == 0 then
		return steps
	end
	for _, id in ipairs(ids) do
		local name, collected = mountInfo(id)
		-- A mount we can't read yet (journal still warming up) is skipped, not
		-- reported as "not collected" — that would be a guess.
		if name and collected == false and #steps < MAX_SHOWN then
			steps[#steps + 1] = {
				text = (ns:L("MOUNTWISH_CHASE_FMT")):format(name),
				color = "soft",
				onClick = openMountJournal,
			}
		end
	end
	if #steps == 0 then
		local have, total = ns.GetWishlistSummary()
		if total > 0 and have == total then
			steps[#steps + 1] = {
				text = (ns:L("MOUNTWISH_ALL_FMT")):format(have, total),
				color = "good",
			}
		end
	end
	return steps
end

-- /mh wishlist
function ns.PrintMountWishlist()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local have, total = ns.GetWishlistSummary()
	if total == 0 then
		print(("%s %s"):format(prefix, ns:L("MOUNTWISH_EMPTY")))
	else
		print(("%s %s"):format(prefix, (ns:L("MOUNTWISH_SUMMARY_FMT")):format(have, total)))
	end
	if ns.SelectTab then
		ns.SelectTab("mounts")
	end
end
