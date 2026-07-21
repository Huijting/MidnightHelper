local _, ns = ...

--[[
	Midnight Helper — keystone side panel.

	Shows the Mythic+ vault advice (ns.GetMythicGainSteps) beside Blizzard's keystone
	window — the moment the player is actually deciding which key to run.

	Never-lie: every line comes from MythicGain, which reads C_MythicPlus /
	C_WeeklyRewards. This panel computes nothing of its own — one source of truth per
	fact. It never takes part in slotting the keystone (that path is secure); it is
	display-only.

	WHICH WINDOW (corrected after Rob tested it, 2026-07-21): the first version
	attached to ChallengesKeystoneFrame. That is the small dialog that only appears
	while you are physically slotting a key — a moment most players barely see. The
	window people actually read is the "Mythic+ Dungeons" tab, ChallengesFrame, which
	is where Rob was looking when nothing showed up.

	ChallengesFrame is a tab INSIDE PVEFrame, so it decides WHEN to show and PVEFrame
	decides WHERE: anchoring to the inner tab would place the panel inside the window.

	Frame names are NOT guessed — all three were confirmed against other installed
	addons rather than assumed:
	  • ChallengesFrame — BossHelper/UI/MythicTeleport.lua:197,221 (it hooks
	    ChallengesFrame.Update).
	  • PVEFrame — BlizzMove/Frames.lua:379, listed as a top-level movable window.
	  • Blizzard_ChallengesUI — BlizzMove/Frames.lua:780, BossHelper:220.
	If a future patch renames any of them, the panel simply never appears; it never
	calls into a guessed name.
]]

local function GetChallengesTab()
	return ChallengesFrame
end

local function GetOuterWindow()
	return PVEFrame
end

local function BuildLines()
	if not ns.GetMythicGainSteps then
		return {}
	end
	local ok, steps = pcall(ns.GetMythicGainSteps)
	if not ok or type(steps) ~= "table" then
		return {}
	end
	local out = {}

	-- The three dungeon-row slots, straight from the shared formatter. Rob asked for
	-- these in the panel so the answer is on screen without a click into chat.
	if ns.GetMythicVaultSlotLines then
		local okS, slotLines = pcall(ns.GetMythicVaultSlotLines)
		if okS and type(slotLines) == "table" then
			for _, l in ipairs(slotLines) do
				out[#out + 1] = { text = l.text, color = l.color }
			end
		end
	end

	-- Rob, reading this panel on the Mythic+ tab: "ik kijk nu naar Mythic en denk dat ik
	-- nu mythic gear ga krijgen". That is the trap — the tab says Mythic+, but this vault
	-- row is fed by heroic and timewalking runs too, and his reward reads Heroic. The
	-- wording is Blizzard's own from the vault card ("Complete 8 Heroic, Mythic, or
	-- Timewalking Dungeons"), so it states no more than the game already does.
	if #out > 0 then
		out[#out + 1] = { text = ns:SafeL("MPLUS_VAULT_COUNTS_NOTE") or "", color = "dim" }
	end

	for _, st in ipairs(steps) do
		if st and st.text then
			out[#out + 1] = { text = st.text, color = st.color or "soft" }
		end
	end
	-- GetMythicGainSteps returns nothing when no key has been run this week, which
	-- is exactly the player standing in this window wondering where to start (Rob
	-- has never run one). Saying "no runs counted yet" is a fact we can read, not a
	-- guess, and /mh keys still has per-dungeon and gear guidance for them. An empty
	-- panel here would hide help from the person who needs it most.
	if #out == 0 then
		out[#out + 1] = { text = ns:SafeL("MPLUS_CMD_NONE") or "", color = "dim" }
	end
	if ns.PrintMythicGain then
		out[#out + 1] = {
			text = ns:SafeL("KEYPANEL_MORE") or "",
			color = "dim",
			onClick = function() pcall(ns.PrintMythicGain) end,
		}
	end
	return out
end

local panel = ns.CreateSidePanel({
	name = "MidnightHelperKeystonePanel",
	titleKey = "KEYPANEL_TITLE",
	width = 300,
})

ns.AttachSidePanel({
	panel = panel,
	getFrame = GetChallengesTab,   -- when: the M+ tab is open
	getAnchor = GetOuterWindow,    -- where: beside the whole Group Finder window
	-- Bottom-right, not top-right. Raider.IO puts its score panel in the top-right
	-- corner and ours covered it (Rob, 2026-07-21) -- unacceptable for anyone who
	-- actually reads those scores. Anchoring to the bottom is deterministic: it
	-- avoids that corner without guessing another addon's height, which changes with
	-- the number of dungeons it lists.
	point = "BOTTOMLEFT",
	relPoint = "BOTTOMRIGHT",
	addon = "Blizzard_ChallengesUI",
	buildLines = BuildLines,
	events = { "CHALLENGE_MODE_MAPS_UPDATE", "WEEKLY_REWARDS_UPDATE" },
})
