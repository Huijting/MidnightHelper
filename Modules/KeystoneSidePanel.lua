local _, ns = ...

--[[
	Midnight Helper — keystone side panel.

	Shows the Mythic+ vault advice (ns.GetMythicGainSteps) beside Blizzard's keystone
	window — the moment the player is actually deciding which key to run.

	Never-lie: every line comes from MythicGain, which reads C_MythicPlus /
	C_WeeklyRewards. This panel computes nothing of its own — one source of truth per
	fact. It never takes part in slotting the keystone (that path is secure); it is
	display-only.

	Frame names are NOT guessed. Both were confirmed against other installed addons
	rather than assumed:
	  • ChallengesKeystoneFrame — BlizzMove/Frames.lua:782, and EllesmereUIQoL
	    hooks its OnShow the same way we do (EllesmereUIQoL.lua:914).
	  • Blizzard_ChallengesUI — BlizzMove/Frames.lua:780, BossHelper/UI/MythicTeleport.lua:220.
	If a future patch renames either, the panel simply never appears; it never calls
	into a guessed name.
]]

local function GetKeystoneFrame()
	return ChallengesKeystoneFrame
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
	for _, st in ipairs(steps) do
		if st and st.text then
			out[#out + 1] = { text = st.text, color = st.color or "soft" }
		end
	end
	-- Only offer the full breakdown when there is something to break down.
	if #out > 0 and ns.PrintMythicGain then
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
	getFrame = GetKeystoneFrame,
	addon = "Blizzard_ChallengesUI",
	buildLines = BuildLines,
	events = { "CHALLENGE_MODE_MAPS_UPDATE", "WEEKLY_REWARDS_UPDATE" },
})
