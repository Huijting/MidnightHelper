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

--- 🔴 EVERY ROUTED COMMAND THAT IS NOT IN THE LIST BELOW, AND WHY THAT IS FINE.
---
--- The comment inside `MH_COMMANDS` diagnosed this exactly on 18 Aug: check [10] asks
--- whether every listed command is routed, "nobody asked the mirror question". Nine
--- features were added by hand that day and the mirror check was never built — so it
--- decayed again within two weeks. 149 routed names then, 171 now, five more players
--- could not find. A manual fix to a recurring drift buys you one fortnight.
---
--- This set is what makes the mirror check possible (lint [16]): anything routed and
--- neither listed nor named here is a NEW command nobody classified. Adding a command
--- now forces the question "is a player meant to find this?", which is the forcing
--- function that was missing.
---
--- ⚠️ It holds TWO kinds of thing, and the name says so rather than pretending they are
--- one. Most are developer probes (`auradump`, `eventspy`, `tierscan`) that would only
--- clutter a player's search. The rest are ALIASES of commands already listed under
--- their primary name — `consready` is `/mh ready`, `groupbuffs` is `/mh gbuffs`.
---
--- 🔴 AND THAT SECOND KIND CAN HIDE A REAL FEATURE, MEASURED 2 SEP 2026. This sentence used
--- to end with "`poisons` is `/mh poison`" — but `poison` was in this set too, so it called a
--- command an alias of something that was itself listed nowhere. Circular, and the effect was
--- that Valeera's poison advice could not be found by anybody. Rob asked "is there any Valeera
--- advice for poisons and curios, anywhere?" — the honest answer was that it existed and was
--- invisible.
--- 📌 So when you park a name here as "just an alias", check that its primary is actually in
--- MH_COMMANDS.
---
--- ⚠️ THAT EVENING THE SAME LOOP TURNED UP A SECOND TIME, in the text rather than the list:
--- the advisor's "no ranking this season" line told the player to run `/mh curios`, and
--- `/mh curios` opened the advisor. Rob had it on screen. Both are fixed the same way — a
--- name must lead somewhere that knows something — and it is worth expecting a third.
---
--- `/mh poisons` is an alias of `/mh curios` since 2 sep (Rob's call): the poison slot is
--- simply one of the companion's choice slots, and one screen reads all of them from the tree.
ns.MH_UNLISTED_ON_PURPOSE = {
	"anchor", "api12", "atal", "auradump", "aurainst", "auras", "bars", "boardall",
	"bonusroll", "bossshare", "campaign", "capture", "chunklog", "chunks", "clearroute",
	"dundun",
	"codexkeys", "companion", "consready", "coord", "crest", "crestfind", "crestscan",
	"curio", "curiodebug", "death", "debug", "delve", "delveexit", "delvescan", "dispellog",
	"dispelprobe", "dispeltest", "editmode", "ej", "enchants", "encounters", "events",
	"eventspy", "fastmark", "finditem", "flightpins", "glow", "groupbuffs", "guide",
	"handbook", "hazard", "here", "instance", "item", "keybinds", "kickprobe", "kp",
	"livetips", "lock", "mech", "mechanics", "model", "moxie", "mplus", "padkeys",
	"partytarget", "poison", "poisons", "portal", "portals", "potionkeys", "prey",
	"profadvice", "profids", "profweekly", "ptr", "questdiff", "questgate", "questscan", "range",
	"zonegate", "travelwhy",
	"rarecapture", "rarehint", "rarequests", "rarescan", "raretest", "readyall",
	"readyboard", "readycheck", "readytest", "readytoggle", "resetdebug", "ritualspy",
	"roleset", "route", "sba", "setline", "shards", "shardtest", "shots", "showdown",
	"socket", "spell", "stat", "stop", "survival", "tier", "tierread", "tierscan", "tips",
	"toast", "twins", "unlearned", "vignettes", "wb", "wiki", "worldboss",
}

--- Grouped so it can be scanned, not alphabetical so it can be searched. Someone
--- looking for "what can this thing do in a dungeon" reads a heading, not a C.
ns.MH_COMMANDS = {
	--- ⚠️ NINE SHIPPED FEATURES WERE MISSING FROM THIS LIST, 18 aug 2026.
	---
	--- Lint check [10] asks whether every command in this file is routed, and the
	--- answer has always been yes. Nobody asked the mirror question. `/mh setup` —
	--- the onboarding command the CurseForge page leads with — has never appeared
	--- here, and neither have `/mh bar` or `/mh fps`, which that page also lists.
	--- Five more arrived in the last two days and went straight past it.
	---
	--- The measurement: 149 routed names against 44 listed. Most of the gap is dev
	--- probes (`auradump`, `eventspy`, `rarescan`) which correctly stay out. These
	--- nine are the ones a player is meant to find, and could not.
	{ headKey = "CMDLIST_GRP_MAIN", items = {
		{ cmd = "/mh", descKey = "CMDLIST_MAIN" },
		{ cmd = "/mh setup", descKey = "CMDLIST_SETUP" },
		{ cmd = "/mh codex", descKey = "CMDLIST_CODEX" },
		{ cmd = "/mh settings", descKey = "CMDLIST_SETTINGS" },
		{ cmd = "/mh mouse", descKey = "CMDLIST_MOUSE" },
		{ cmd = "/mh apply", descKey = "CMDLIST_APPLY" },
		{ cmd = "/mh changelog", descKey = "CMDLIST_CHANGELOG" },
		{ cmd = "/mh lang", descKey = "CMDLIST_LANG" },
		-- Both carry NavSearch keyword blocks ("community help support invite chat
		-- server", "help translate localisation language") that could never match,
		-- because NavSearch indexes this table and nothing else. Typing "discord" into
		-- our own search box found nothing while the invite sat one command away.
		{ cmd = "/mh discord", descKey = "CMDLIST_DISCORD" },
		{ cmd = "/mh translate", descKey = "CMDLIST_TRANSLATE" },
		-- Sits with the other two on purpose: this is the third door out of the addon,
		-- and the only one a player uses when something is WRONG rather than missing.
		{ cmd = "/mh report", descKey = "CMDLIST_REPORT" },
	} },
	{ headKey = "CMDLIST_GRP_WEEK", items = {
		{ cmd = "/mh milestones", descKey = "CMDLIST_MILESTONES" },
		-- 🔴 `/mh season stats`, NOT `/mh season`. This row promised "Season stats for
		-- this character" and pointed at the developer diagnostic, which prints the
		-- season-transition checklist with its raw ids and ends by telling the reader to
		-- verify each resolved name. Rob searched for "stats", took what the list
		-- offered, and got that (27 aug). The bare command still works; it is simply not
		-- advertised, the same as /mh glow and /mh dispeltest.
		{ cmd = "/mh season stats", descKey = "CMDLIST_SEASON" },
		{ cmd = "/mh delves", descKey = "CMDLIST_DELVES" },
		{ cmd = "/mh scorecard", descKey = "CMDLIST_SCORECARD" },
	} },
	{ headKey = "CMDLIST_GRP_GEAR", items = {
		{ cmd = "/mh tracks", descKey = "CMDLIST_TRACKS" },
		{ cmd = "/mh loot", descKey = "CMDLIST_LOOT" },
		{ cmd = "/mh enchant", descKey = "CMDLIST_ENCHANT" },
		{ cmd = "/mh stats", descKey = "CMDLIST_STATS" },
		{ cmd = "/mh pawn", descKey = "CMDLIST_PAWN" },
		{ cmd = "/mh bagarrows", descKey = "CMDLIST_BAGARROWS" },
	} },
	{ headKey = "CMDLIST_GRP_GROUP", items = {
		{ cmd = "/mh partytargets", descKey = "CMDLIST_PARTYTARGETS" },
		{ cmd = "/mh mark", descKey = "CMDLIST_MARK" },
		{ cmd = "/mh ready", descKey = "CMDLIST_READY" },
		{ cmd = "/mh gbuffs", descKey = "CMDLIST_GBUFFS" },
		{ cmd = "/mh pullsummary", descKey = "CMDLIST_PULLSUMMARY" },
		{ cmd = "/mh kicks", descKey = "CMDLIST_KICKS" },
		{ cmd = "/mh healcds", descKey = "CMDLIST_HEALCDS" },
		{ cmd = "/mh dispel", descKey = "CMDLIST_DISPEL" },
		{ cmd = "/mh prompt", descKey = "CMDLIST_PROMPT" },
		{ cmd = "/mh prompt sound", descKey = "CMDLIST_PROMPT_SOUND" },
	} },
	{ headKey = "CMDLIST_GRP_CONTENT", items = {
		{ cmd = "/mh coach", descKey = "CMDLIST_COACH" },
		{ cmd = "/mh bosswin", descKey = "CMDLIST_BOSSWIN" },
		{ cmd = "/mh ritualboss", descKey = "CMDLIST_RITUALBOSS" },
		-- 2 sep: `/mh curio` en `/mh curios` doen nu hetzelfde (de adviseur). Alleen de
		-- meervoudsvorm staat hier; `curio` is de alias en staat in de set hierboven.
		{ cmd = "/mh curios", descKey = "CMDLIST_CURIOS" },
		{ cmd = "/mh curioinfo", descKey = "CMDLIST_CURIOINFO" },
		{ cmd = "/mh hazards", descKey = "CMDLIST_HAZARDS" },
		{ cmd = "/mh keys", descKey = "CMDLIST_KEYS" },
		{ cmd = "/mh board", descKey = "CMDLIST_BOARD" },
		{ cmd = "/mh items", descKey = "CMDLIST_ITEMS" },
	} },
	{ headKey = "CMDLIST_GRP_ROUTE", items = {
		{ cmd = "/mh arrow", descKey = "CMDLIST_ARROW" },
		{ cmd = "/mh arrowsize", descKey = "CMDLIST_ARROWSIZE" },
		{ cmd = "/mh fp", descKey = "CMDLIST_FP" },
		{ cmd = "/mh course", descKey = "CMDLIST_COURSE" },
		{ cmd = "/mh valeera", descKey = "CMDLIST_VALEERA" },
		-- 2 sep: `/mh poisons` is een alias van `/mh curios` geworden en staat daarom
		-- niet meer los in de lijst. Het stond hier bij de ROUTE-groep, wat het sowieso
		-- niet was. Beide namen staan nu in MH_UNLISTED_ON_PURPOSE.
		{ cmd = "/mh goto", descKey = "CMDLIST_GOTO" },
		{ cmd = "/mh clear", descKey = "CMDLIST_CLEAR" },
		{ cmd = "/mh skip", descKey = "CMDLIST_SKIP" },
		{ cmd = "/mh plan", descKey = "CMDLIST_PLAN" },
		{ cmd = "/mh zone", descKey = "CMDLIST_ZONE" },
	} },
	{ headKey = "CMDLIST_GRP_LOOK", items = {
		{ cmd = "/mh size", descKey = "CMDLIST_SIZE" },
		{ cmd = "/mh framesize", descKey = "CMDLIST_FRAMESIZE" },
		{ cmd = "/mh panelreset", descKey = "CMDLIST_PANELRESET" },
		{ cmd = "/mh bar", descKey = "CMDLIST_BAR" },
		{ cmd = "/mh fps", descKey = "CMDLIST_FPS" },
	} },
	--- Lookup tools rather than features: they answer a question about your own
	--- character and change nothing. Grouped apart so the list above stays "what
	--- this addon does" and this stays "what you can ask it".
	{ headKey = "CMDLIST_GRP_LOOKUP", items = {
		{ cmd = "/mh binds", descKey = "CMDLIST_BINDS" },
		{ cmd = "/mh ach", descKey = "CMDLIST_ACH" },
		{ cmd = "/mh mount", descKey = "CMDLIST_MOUNTLOOKUP" },
		{ cmd = "/mh wishlist", descKey = "CMDLIST_WISHLIST" },
	} },
	--- ⚠️ MEASUREMENT, NOT FEATURES — and they were listed as features until 18 aug.
	---
	--- Proposal item 3.2 named five: `/mh mbuff` was described as "toggle the missing
	--- buff reminder" and toggles nothing; `/mh trail` as "plan a way to get somewhere"
	--- while its own code says MEASUREMENT ONLY, not wired into the travel assistant.
	--- `/mh nodes`, `/mh weeklies` and `/mh folio` the same. `/mh crests` is a sixth
	--- nobody had counted.
	---
	--- Moved rather than deleted, on Rob's call and for a reason I had not weighed:
	--- this list is also how a later session discovers what exists. Deleting them
	--- means re-inventing them in three weeks. A labelled section keeps them findable
	--- and stops the false promise, which was the actual complaint.
	---
	--- ⚠️ The features these describe are NOT gone. `/mh mbuff`'s reminder is a
	--- Settings toggle (mh_missingBuff); only its debug print lives here. And `/mh
	--- trail` no longer sits beside `/mh plan` looking like two versions of one
	--- thing — plan is what trail promised.
	{ headKey = "CMDLIST_GRP_PROBE", items = {
		{ cmd = "/mh weeklies", descKey = "CMDLIST_WEEKLIES" },
		{ cmd = "/mh crests", descKey = "CMDLIST_CRESTS" },
		{ cmd = "/mh folio", descKey = "CMDLIST_FOLIO" },
		{ cmd = "/mh nodes", descKey = "CMDLIST_NODES" },
		{ cmd = "/mh trail", descKey = "CMDLIST_TRAIL" },
		{ cmd = "/mh mbuff", descKey = "CMDLIST_MBUFF" },
		{ cmd = "/mh quest", descKey = "CMDLIST_QUEST" },
		{ cmd = "/mh npc", descKey = "CMDLIST_NPC" },
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
