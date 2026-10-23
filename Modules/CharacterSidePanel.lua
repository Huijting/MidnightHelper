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

--- Per slot, at max level (Rob, 22 Oct 2026, option C): one line per enchantable slot, coloured by whether the enchant
--- is ours (green), another one (orange), missing (red) or something we cannot judge (yellow), then each empty socket
--- in red, then the colour key — the explanation in the same room as the colours. Below max level the old two count
--- lines stay: the enchants are Midnight max-level gear, and nine red lines on a level 30 would be noise.
--- @return true when it added the lines (the caller then skips the count lines)
local STATE_COLOR = {
	ours = "good", other = "other", missing = "bad", unknown = "unknown", optional = "dim", noadvice = "soft",
}
local function AddSlotLines(out)
	if not ns.GetGearEnchantSlots then
		return false
	end
	local max = (ns.PlayCardMaxLevel and ns.PlayCardMaxLevel()) or 90
	if (UnitLevel and UnitLevel("player") or 0) < max then
		return false
	end
	local ok, rows = pcall(ns.GetGearEnchantSlots)
	if not (ok and rows) then
		return false
	end
	-- Rob, 22 Oct 2026 (screenshot of the chat report): "misschien is dat handiger als dat … in een mooie venster" —
	-- a click opens MH's own Enchants tab (the same report, links you can click and copy for the auction house)
	-- instead of printing it in chat. Chat stays the fallback.
	local function open()
		if ns.ShowMainUI and ns.SelectTab then
			ns:ShowMainUI()
			ns.SelectTab("enchants")
		else
			pcall(ns.PrintGearEnchantCheck)
		end
	end
	local missingSomething = false
	for _, r in ipairs(rows) do
		local name = r.name or "?"
		local text
		if r.state == "missing" then
			text = (ns:SafeL("CHARPANEL_SLOT_MISSING_FMT") or "%s"):format(r.label)
		elseif r.state == "optional" then
			text = (ns:SafeL("CHARPANEL_SLOT_OPTIONAL_FMT") or "%s"):format(r.label)
		elseif r.state == "other" then
			text = (ns:SafeL("CHARPANEL_SLOT_OTHER_FMT") or "%s: %s"):format(r.label, name)
		elseif r.state == "unknown" then
			text = (ns:SafeL("CHARPANEL_SLOT_UNKNOWN_FMT") or "%s: %s"):format(r.label, name)
		else
			text = (ns:SafeL("CHARPANEL_SLOT_OURS_FMT") or "%s: %s"):format(r.label, name)
		end
		if r.state == "missing" then
			missingSomething = true
		end
		if r.state == "ours" and r.rank == 1 then
			text = text .. " " .. (ns:SafeL("CHARPANEL_SLOT_RANK1") or "")
		end
		out[#out + 1] = { text = text, color = STATE_COLOR[r.state] or "soft", onClick = open }
	end
	local okS, sockets = pcall(ns.GetGearEmptySocketSlots)
	for _, s in ipairs(okS and sockets or {}) do
		local text = s.count > 1 and (ns:SafeL("CHARPANEL_SLOT_SOCKETS_FMT") or "%s %d"):format(s.label, s.count)
			or (ns:SafeL("CHARPANEL_SLOT_SOCKET_FMT") or "%s"):format(s.label)
		out[#out + 1] = { text = text, color = "bad", onClick = open }
		missingSomething = true
	end
	-- Something to buy? Then a way straight to the shopping window (/mh ready, RaidShoppingList.lua): its "Your gear"
	-- block lists the same missing enchants and gems, and a click there searches the auction house.
	if missingSomething and ns.ShowRaidShoppingList then
		out[#out + 1] = { text = ns:SafeL("CHARPANEL_SHOP") or "Buy what's missing", color = "prog",
			onClick = function() pcall(ns.ShowRaidShoppingList) end }
	end
	out[#out + 1] = { text = ns:SafeL("CHARPANEL_SLOT_LEGEND") or "", color = "dim" }
	return true
end

local function BuildLines()
	local out = {}

	if AddSlotLines(out) then
		-- the per-slot lines replace the two counts below
	elseif ns.GetGearEnchantSummary then
		local ok, missing, sockets = pcall(ns.GetGearEnchantSummary)
		if ok and missing ~= nil then
			if missing > 0 then
				out[#out + 1] = {
					text = (ns:SafeL(missing == 1 and "CHARPANEL_ENCH_ONE" or "CHARPANEL_ENCH_FMT") or "%d"):format(missing),
					color = "warn",
					onClick = function() pcall(ns.PrintGearEnchantCheck) end,
				}
			end
			if sockets and sockets > 0 then
				out[#out + 1] = {
					text = (ns:SafeL(sockets == 1 and "CHARPANEL_SOCKET_ONE" or "CHARPANEL_SOCKET_FMT") or "%d"):format(sockets),
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

	-- Track ceiling (Spec 21): the "I'm on Hero 6/6, now what?" moment. Last, because
	-- it is the least urgent of the three — an enchant you can fix today, a ceiling
	-- takes a drop or a craft.
	if ns.GetTrackCeilingSteps then
		local ok, steps = pcall(ns.GetTrackCeilingSteps)
		if ok and type(steps) == "table" then
			for _, st in ipairs(steps) do
				out[#out + 1] = {
					text = st.text,
					color = st.color or "warn",
					onClick = function() pcall(ns.PrintTrackCeiling) end,
				}
			end
		end
	end

	-- Ascendant Venomstones (Rob, 23 Oct 2026, option A): how many you carry and which maxed weapon, trinket or
	-- neck could take them — right under the ceiling line, because they are the way past that ceiling.
	if ns.GetVenomstoneSteps then
		local ok, steps = pcall(ns.GetVenomstoneSteps)
		if ok and type(steps) == "table" then
			for _, st in ipairs(steps) do
				out[#out + 1] = {
					text = st.text,
					color = st.color or "prog",
					onClick = function() pcall(ns.PrintTrackCeiling) end,
				}
			end
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

	-- Rob, 30 Sep 2026: "we moeten dan ook een knop inbouwen om de mh raidbots te genereren".
	-- Always last and always there: it is a way in, not an attention point, so it never
	-- decides whether the "all good" line above shows.
	-- Two ways in, quick before exact (Rob, 30 Sep 2026: "ja, bouw dat maar"): the Armory
	-- export was reachable only by typing /mh export, while Raidbots had a button.
	-- Rob, 19 Oct 2026, for Carola: the "what now?" window, where a player who wonders why her gear stays put already is.
	if ns.ShowGearLadder then
		out[#out + 1] = {
			text = ns:SafeL("CHARPANEL_GEARLADDER") or "My gear: what now?",
			color = "prog",
			onClick = function() pcall(ns.ShowGearLadder) end,
		}
	end
	if ns.ShowGearExport then
		out[#out + 1] = {
			text = ns:SafeL("CHARPANEL_ARMORY") or "Armory",
			color = "prog",
			onClick = function() pcall(ns.ShowGearExport) end,
		}
	end
	if ns.ShowSimcExport then
		out[#out + 1] = {
			text = ns:SafeL("CHARPANEL_RAIDBOTS") or "Raidbots",
			color = "prog",
			onClick = function() pcall(ns.ShowSimcExport) end,
		}
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
