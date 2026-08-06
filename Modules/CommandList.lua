local _, ns = ...

--[[
	Midnight Helper — every command, in the addon itself.

	Rob, 6 Aug: "hebben wij in de addon een pagina waar al die commando's staan?"
	The Tools room had five cards. An audit that morning found 22 user-facing
	commands documented nowhere — not on the CurseForge page, not in the addon.
	`/mh delves` is your run history, `/mh crests` the crest guide, `/mh codex` the
	whole reference; people were installing this and never learning half of it
	existed.

	WHY HERE AND NOT ON THE STORE PAGE. A markdown table on CurseForge is read once
	and then goes stale, silently. This week alone three promises had to be
	corrected that lived exactly there — Alt+M, the WaypointUI stand-down, and an
	interrupt feature that cannot work. A list inside the addon sits where the
	player already is, and this one is generated from a table rather than typed
	twice, so it cannot drift from the code.

	SINGLE SOURCE. `ns.MH_COMMANDS` below is the only list. The CurseForge page now
	names a handful and points here for the rest, instead of duplicating it.

	⚠️ EVERY ENTRY IS VERIFIED. tools/lint_addon.py checks that each `cmd` here is
	routed somewhere in the addon; a command that stops existing fails the build
	rather than quietly lying to a player. Deliberately absent: developer probes
	(`/mh auradump`, `/mh eventspy`, `/mh raretest`, the `save`/`probe` variants)
	and anything not yet seen working.

	Descriptions are English and Dutch. The other five languages fall back to enUS,
	which is the documented behaviour and beats a machine-translated command list —
	same call as the Prey codex article on 27 July.
]]

local function L(key)
	return (ns.L and ns:L(key)) or key
end
local function SF(name)
	return (ns.MHScalableFont and ns.MHScalableFont(name)) or name
end

--- Grouped so it can be scanned, not alphabetical so it can be searched. Someone
--- looking for "what can this thing do in a dungeon" reads a heading, not a C.
ns.MH_COMMANDS = {
	{ headKey = "CMDLIST_GRP_MAIN", items = {
		{ cmd = "/mh", descKey = "CMDLIST_MAIN" },
		{ cmd = "/mh codex", descKey = "CMDLIST_CODEX" },
		{ cmd = "/mh settings", descKey = "CMDLIST_SETTINGS" },
		{ cmd = "/mh changelog", descKey = "CMDLIST_CHANGELOG" },
		{ cmd = "/mh lang", descKey = "CMDLIST_LANG" },
	} },
	{ headKey = "CMDLIST_GRP_WEEK", items = {
		{ cmd = "/mh weeklies", descKey = "CMDLIST_WEEKLIES" },
		{ cmd = "/mh milestones", descKey = "CMDLIST_MILESTONES" },
		{ cmd = "/mh season", descKey = "CMDLIST_SEASON" },
		{ cmd = "/mh delves", descKey = "CMDLIST_DELVES" },
		{ cmd = "/mh scorecard", descKey = "CMDLIST_SCORECARD" },
	} },
	{ headKey = "CMDLIST_GRP_GEAR", items = {
		{ cmd = "/mh tracks", descKey = "CMDLIST_TRACKS" },
		{ cmd = "/mh crests", descKey = "CMDLIST_CRESTS" },
		{ cmd = "/mh loot", descKey = "CMDLIST_LOOT" },
		{ cmd = "/mh enchant", descKey = "CMDLIST_ENCHANT" },
		{ cmd = "/mh bagarrows", descKey = "CMDLIST_BAGARROWS" },
		{ cmd = "/mh folio", descKey = "CMDLIST_FOLIO" },
	} },
	{ headKey = "CMDLIST_GRP_GROUP", items = {
		{ cmd = "/mh partytargets", descKey = "CMDLIST_PARTYTARGETS" },
		{ cmd = "/mh mark", descKey = "CMDLIST_MARK" },
		{ cmd = "/mh ready", descKey = "CMDLIST_READY" },
		{ cmd = "/mh gbuffs", descKey = "CMDLIST_GBUFFS" },
		{ cmd = "/mh kicks", descKey = "CMDLIST_KICKS" },
		{ cmd = "/mh healcds", descKey = "CMDLIST_HEALCDS" },
		{ cmd = "/mh dispel", descKey = "CMDLIST_DISPEL" },
		{ cmd = "/mh mbuff", descKey = "CMDLIST_MBUFF" },
		{ cmd = "/mh prompt", descKey = "CMDLIST_PROMPT" },
		{ cmd = "/mh prompt sound", descKey = "CMDLIST_PROMPT_SOUND" },
	} },
	{ headKey = "CMDLIST_GRP_CONTENT", items = {
		{ cmd = "/mh coach", descKey = "CMDLIST_COACH" },
		{ cmd = "/mh bosswin", descKey = "CMDLIST_BOSSWIN" },
		{ cmd = "/mh ritualboss", descKey = "CMDLIST_RITUALBOSS" },
		{ cmd = "/mh curio", descKey = "CMDLIST_CURIO" },
		{ cmd = "/mh board", descKey = "CMDLIST_BOARD" },
		{ cmd = "/mh items", descKey = "CMDLIST_ITEMS" },
	} },
	{ headKey = "CMDLIST_GRP_ROUTE", items = {
		{ cmd = "/mh arrow", descKey = "CMDLIST_ARROW" },
		{ cmd = "/mh arrowsize", descKey = "CMDLIST_ARROWSIZE" },
		{ cmd = "/mh goto", descKey = "CMDLIST_GOTO" },
		{ cmd = "/mh clear", descKey = "CMDLIST_CLEAR" },
		{ cmd = "/mh skip", descKey = "CMDLIST_SKIP" },
		{ cmd = "/mh nodes", descKey = "CMDLIST_NODES" },
		{ cmd = "/mh trail", descKey = "CMDLIST_TRAIL" },
		{ cmd = "/mh zone", descKey = "CMDLIST_ZONE" },
	} },
	{ headKey = "CMDLIST_GRP_LOOK", items = {
		{ cmd = "/mh size", descKey = "CMDLIST_SIZE" },
		{ cmd = "/mh framesize", descKey = "CMDLIST_FRAMESIZE" },
		{ cmd = "/mh panelreset", descKey = "CMDLIST_PANELRESET" },
	} },
}

--- Render the list into a scrolling area under whatever came before it.
---
--- Its own ScrollFrame because module panels do not scroll — each page that needs
--- one builds it (Achievements.lua:2050, Changelog.lua:564). Forty rows will not
--- fit otherwise, and a list that silently ends at row twenty is worse than none.
function ns.BuildCommandList(panel, anchorTo)
	if not panel or panel._mhCmdListBuilt then
		return
	end
	panel._mhCmdListBuilt = true

	local head = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	head:SetFontObject(SF("GameFontHighlightLarge"))
	head:SetPoint("TOPLEFT", anchorTo or panel, anchorTo and "BOTTOMLEFT" or "TOPLEFT", 0, -16)
	head:SetText(L("CMDLIST_TITLE"))

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)
	local child = CreateFrame("Frame", nil, scroll)
	-- ⚠️ WIDTH FIRST, BEFORE ANY TEXT IS MEASURED.
	--
	-- Rob, 6 Aug: while scrolling, the /mh mark row printed on top of the row above
	-- it and then corrected itself further down — repeatably. The cause was here:
	-- the child was created 1px wide and only sized at the END, so every
	-- GetStringHeight() below measured a wrapped string against the wrong width.
	-- Rows that wrap to two lines were given one line of space, and the overlap
	-- only resolved when scrolling forced a real layout pass.
	--
	-- Sizing the child first means the wrap width is true at measure time, which is
	-- the only moment the height is asked for.
	local width = math.max(200, (panel:GetWidth() or 400) - 44)
	child:SetSize(width, 1)
	scroll:SetScrollChild(child)

	local y = 0
	child._mhRows = {}
	for _, group in ipairs(ns.MH_COMMANDS) do
		local gh = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		gh:SetFontObject(SF("GameFontNormal"))
		gh:SetPoint("TOPLEFT", child, "TOPLEFT", 2, y)
		gh:SetText(L(group.headKey))
		local c = ns.UI_COLORS and ns.UI_COLORS.header
		if c then
			gh:SetTextColor(c[1], c[2], c[3])
		end
		child._mhRows[#child._mhRows + 1] = { head = gh }
		y = y - 20

		for index, item in ipairs(group.items) do
			local cmd = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			cmd:SetFontObject(SF("GameFontHighlightSmall"))
			cmd:SetPoint("TOPLEFT", child, "TOPLEFT", 10, y)
			cmd:SetWidth(120)
			cmd:SetJustifyH("LEFT")
			-- Commands are not translated: they are typed literally.
			cmd:SetText("|cffffd100" .. item.cmd .. "|r")

			local desc = child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			desc:SetFontObject(SF("GameFontHighlightSmall"))
			desc:SetPoint("TOPLEFT", cmd, "TOPRIGHT", 8, 0)
			desc:SetPoint("RIGHT", child, "RIGHT", -8, 0)
			desc:SetJustifyH("LEFT")
			desc:SetWordWrap(true)
			desc:SetTextColor(0.78, 0.8, 0.85)
			desc:SetText(L(item.descKey))

			child._mhRows[#child._mhRows + 1] = {
				cmd = cmd, desc = desc, last = (index == #group.items),
			}
			y = y - math.max(16, (desc:GetStringHeight() or 14) + 4)
		end
		y = y - 8
	end
	child:SetHeight(math.abs(y) + 10)

	-- Second pass, one frame later. The width above is the panel's width AT BUILD
	-- TIME, and the panel can still be laying itself out — so a row that wraps
	-- differently once everything has settled would overlap again. Re-measuring
	-- costs nothing here and removes the whole class of fault rather than the one
	-- row Rob happened to see.
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if not (child and child.SetHeight) then
				return
			end
			local w = math.max(200, (panel:GetWidth() or 400) - 44)
			child:SetWidth(w)
			local yy = 0
			for _, row in ipairs(child._mhRows or {}) do
				-- ClearAllPoints first: SetPoint ADDS an anchor, so re-anchoring
				-- without clearing leaves the old one in place and the widget ends
				-- up pinned by both.
				if row.head then
					row.head:ClearAllPoints()
					row.head:SetPoint("TOPLEFT", child, "TOPLEFT", 2, yy)
					yy = yy - 20
				else
					row.cmd:ClearAllPoints()
					row.cmd:SetPoint("TOPLEFT", child, "TOPLEFT", 10, yy)
					yy = yy - math.max(16, (row.desc:GetStringHeight() or 14) + 4)
					if row.last then
						yy = yy - 8
					end
				end
			end
			child:SetHeight(math.abs(yy) + 10)
		end)
	end
end
