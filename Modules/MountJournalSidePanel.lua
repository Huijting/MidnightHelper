local _, ns = ...

--[[
	Midnight Helper — mount journal side panel.

	Your wishlist progress beside Blizzard's mount collection, where you are already
	browsing mounts.

	WHEN vs WHERE: MountJournal is the mount TAB inside CollectionsJournal, so it
	decides when to show, while the outer window decides where to sit. Anchoring to
	the tab would drop the panel inside the collections window — the same defect the
	keystone panel hit with ChallengesFrame inside PVEFrame.

	Frame names confirmed against installed addons, not assumed:
	  • MountJournal — EllesmereUIBlizzardSkin_WindowPacks.lua:189 (_G.MountJournal)
	  • CollectionsJournal — !KalielsTracker/Modules/Addon_BattlePetCompletionist.lua:123
	    (CollectionsJournal:IsShown()), and BlizzMove lists it as a top-level window.

	Never-lie: counts come from ns.GetWishlistSummary / ns.GetMountWishlistSteps,
	which read C_MountJournal. We claim nothing about "every Midnight mount" — only
	about the mounts YOU starred. Summoning is a secure action; this panel only shows.

	Empty wishlist → no panel at all. The wishlist is opt-in, so someone who has not
	opted in should not be reminded of it every time they open their collection.
]]

local function GetMountTab()
	return MountJournal
end

local function GetCollectionsWindow()
	return CollectionsJournal
end

local function BuildLines()
	local out = {}

	local have, total
	if ns.GetWishlistSummary then
		local ok, h, t = pcall(ns.GetWishlistSummary)
		if ok then
			have, total = h, t
		end
	end
	-- Nothing starred: stay silent rather than nag about an opt-in feature.
	if not total or total <= 0 then
		return out
	end

	out[#out + 1] = {
		text = (ns:SafeL("MOUNTWISH_SUMMARY_FMT") or "%d / %d"):format(have or 0, total),
		color = (have or 0) >= total and "good" or "prog",
	}

	-- The mounts still being chased. GetMountWishlistSteps already caps its own
	-- length, skips mounts the journal cannot read yet rather than calling them
	-- uncollected, and reports the all-collected case itself.
	if ns.GetMountWishlistSteps then
		local ok, steps = pcall(ns.GetMountWishlistSteps)
		if ok and type(steps) == "table" then
			for _, st in ipairs(steps) do
				if st and st.text then
					out[#out + 1] = { text = st.text, color = st.color or "soft" }
				end
			end
		end
	end
	return out
end

local panel = ns.CreateSidePanel({
	name = "MidnightHelperMountJournalPanel",
	titleKey = "MOUNTWISH_HEADER",
	width = 280,
})

ns.AttachSidePanel({
	panel = panel,
	getFrame = GetMountTab,             -- when: the mount tab is open
	getAnchor = GetCollectionsWindow,   -- where: beside the whole collections window
	addon = "Blizzard_Collections",
	buildLines = BuildLines,
	events = { "NEW_MOUNT_ADDED", "COMPANION_LEARNED" },
})
