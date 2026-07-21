local _, ns = ...

--[[
	Midnight Helper — character side panel.

	Gear attention points beside Blizzard's character sheet, at the moment the player
	is actually looking at their equipment.

	Deliberately a SIGNAL, not a second interface: at most a few lines, each one
	clicking through to the panel that already does the job properly. The full
	reports stay where they are.

	Never-lie:
	  • Every number comes from ns.GetGearEnchantSummary / ns.GetTierSetSummary,
	    which read the existing modules. This file computes nothing.
	  • Both getters return nil when they could not read, and nil is NOT zero. An
	    unreadable tier count stays off the panel instead of claiming 0/5 to someone
	    wearing four pieces.
	  • Nothing here equips, sockets or changes anything.

	CharacterFrame is always loaded (not load-on-demand), so no addon wait is needed.
	The name is confirmed by other installed addons rather than assumed: BlizzMove
	lists CharacterFrame as a top-level movable window (Frames.lua).
]]

local function GetCharacterFrame()
	return CharacterFrame
end

local function BuildLines()
	local out = {}

	if ns.GetGearEnchantSummary then
		local ok, missing, sockets = pcall(ns.GetGearEnchantSummary)
		if ok and missing ~= nil then
			if missing > 0 then
				out[#out + 1] = {
					text = (ns:SafeL("CHARPANEL_ENCH_FMT") or "%d"):format(missing),
					color = "warn",
					onClick = function() pcall(ns.PrintGearEnchantCheck) end,
				}
			end
			if sockets and sockets > 0 then
				out[#out + 1] = {
					text = (ns:SafeL("CHARPANEL_SOCKET_FMT") or "%d"):format(sockets),
					color = "warn",
					onClick = function() pcall(ns.PrintGearEnchantCheck) end,
				}
			end
		end
	end

	if ns.GetTierSetSummary then
		local ok, worn, total = pcall(ns.GetTierSetSummary)
		-- Only worth a line while the set is incomplete; a finished set is not an
		-- attention point, and this panel is for things that still need doing.
		if ok and worn ~= nil and total and worn < total then
			out[#out + 1] = {
				text = (ns:SafeL("CHARPANEL_TIER_FMT") or "%d/%d"):format(worn, total),
				color = "prog",
			}
		end
	end

	-- Everything readable and nothing outstanding earns one quiet line. Note the
	-- difference from "we could not read anything", which produces no lines at all
	-- and therefore no panel — saying "gear looks complete" when the API went quiet
	-- would be exactly the kind of confident falsehood this addon keeps tripping on.
	if #out == 0 then
		local okE, missing = pcall(ns.GetGearEnchantSummary)
		if okE and missing ~= nil then
			out[#out + 1] = { text = ns:SafeL("CHARPANEL_ALLGOOD") or "", color = "good" }
		end
	end
	return out
end

local panel = ns.CreateSidePanel({
	name = "MidnightHelperCharacterPanel",
	titleKey = "CHARPANEL_TITLE",
	width = 280,
})

ns.AttachSidePanel({
	panel = panel,
	getFrame = GetCharacterFrame,
	buildLines = BuildLines,
	-- Re-read after a gear change or a socket, so the panel is right the moment you
	-- swap a piece while the sheet is open.
	events = { "PLAYER_EQUIPMENT_CHANGED", "SOCKET_INFO_UPDATE" },
})
