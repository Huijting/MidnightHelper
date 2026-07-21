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

--- WHEN to show: the equipment tab, not merely the window. PaperDollFrame is only
--- visible while the character sheet is open AND the Character tab is selected, so
--- one check covers both — gear advice beside the Reputation list is noise (Rob,
--- 2026-07-21). EllesmereUIBlizzardSkin calls PaperDollFrame:IsShown() "the
--- truth-source for whether user is sitting on Rep" (CharacterSheet.lua:4536), so
--- this is their verified approach rather than a guess of mine.
local function GetPaperDoll()
	return PaperDollFrame
end

--- WHERE to sit: to the right of Blizzard's own stats pane. CharacterFrame's right
--- edge is the model window, and the stats column ("Item Level 271.1", Attributes,
--- Enhancements) extends past it — so anchoring to the frame dropped the panel on
--- top of Blizzard's own numbers. CharacterStatsPane is the real right-hand edge
--- (confirmed in MyCharacterPanel/Onglets/PaperDollFrame.lua:247), with the frame
--- as a fallback if a future patch drops the name.
local function GetCharacterAnchor()
	return CharacterStatsPane or CharacterFrame
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
	getFrame = GetPaperDoll,
	getAnchor = GetCharacterAnchor,
	buildLines = BuildLines,
	-- Re-read after a gear change or a socket, so the panel is right the moment you
	-- swap a piece while the sheet is open.
	events = { "PLAYER_EQUIPMENT_CHANGED", "SOCKET_INFO_UPDATE" },
})
