--[[
	Tier Set guide (Rob-wens 16 jun, 1.8.1). Twee niveaus:
	  1) algemene uitleg: wat tier sets zijn, hoe je ze krijgt, beginner-pad;
	  2) live: jouw class-set + 2/4-set-bonus als klikbare spell-links, plus een
	     teller "tier x/5 (2-set ✓ / 4-set ✗)" uit je uitgeruste slots.

	never-lie: de bonus-tekst komt uit de live spell-tooltip (hover), niet hard-
	gecodeerd; IDs zijn PTR-bevestigd → "bevestig in-game"-voet. De teller leest
	de set-piece-count uit de item-tooltip ("(n/5)") — taint-veilig, read-only.
]]

local _, ns = ...

local ui

--------------------------------------------------------------------------------
-- Spec-resolutie + live teller
--------------------------------------------------------------------------------

-- 📌 `PlayerClassFile` and `PlayerSpecID` lived here to key the two lookup tables. Both
-- tables are gone (see TierSetData.lua), so both helpers went with them rather than being
-- left behind as untested code that reads like a safety net.

-- Aantal uitgeruste tier-stukken (0..5) uit de item-tooltip-setregel "(n/5)",
-- of nil als de API niet beschikbaar is / geen tier-stuk gedragen.
local function TierPiecesEquipped()
	if not (C_TooltipInfo and C_TooltipInfo.GetInventoryItem) then
		return nil
	end
	local sawAnyItem = false
	for _, slot in ipairs(ns.TIER_SLOTS or {}) do
		local data = C_TooltipInfo.GetInventoryItem("player", slot)
		if data and data.lines then
			sawAnyItem = true
			for _, line in ipairs(data.lines) do
				local t = line and line.leftText
				if t then
					local n = t:match("%((%d+)/5%)")
					if n then
						return tonumber(n)
					end
				end
			end
		end
	end
	-- Items gezien maar geen set-regel → 0 tier-stukken; anders onbekend.
	if sawAnyItem then
		return 0
	end
	return nil
end

--- `/mh tierread` — what can we actually read off the gear the player is WEARING?
---
--- 🔴 MEASURE BEFORE BUILDING, because the plan rests on one thing being true. Rob decided
--- on 29 aug 2026 that `TierSetData.lua` must go: both `TIER_SET_BY_CLASS` (13 names) and
--- `TIER_SPEC_BONUS` (~38 spec entries) are a 12.0.7 datamine from 16 June, they are Season
--- 1, and a table that rots every season has now gone quietly wrong three times.
---
--- The replacement is meant to read the set out of the player's own tooltip instead. We know
--- that works in the CATALYST PREVIEW -- Rob's screenshot of 28 aug shows item 271563 with
--- "Primal Leywarden's Attire (1/5)", all five piece names, and both set bonuses. We do NOT
--- know it looks the same on a piece you are wearing, and building on that would be assuming
--- the thing under test.
---
--- ⚠️ So this prints the raw lines rather than a verdict. If the set name and the "(2) Set:"
--- and "(4) Set:" lines are there, both tables can go and the page becomes self-updating. If
--- they are not, the plan changes and we find out now instead of after the rewrite.
---
--- ⚠️ AND ZERO TIER PIECES IS A REAL ANSWER, not a failure. A player wearing none has nothing
--- for us to read, and the honest page then says "wear one and this fills in" rather than
--- printing last season's name. `TierPiecesEquipped` already separates "no set line" from
--- "could not read any item"; this keeps that distinction visible.
function ns.PrintTierReadProbe()
	local prefix = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH")
	print(prefix .. " tier read probe:")
	if not (C_TooltipInfo and C_TooltipInfo.GetInventoryItem) then
		print("   |cffff5555C_TooltipInfo.GetInventoryItem is missing|r — the whole plan "
			.. "depends on it, so this is the answer.")
		return
	end
	local SLOT_NAME = { [1] = "Head", [3] = "Shoulder", [5] = "Chest", [10] = "Hands", [7] = "Legs" }
	local sawItem, sawSet = false, false
	for _, slot in ipairs(ns.TIER_SLOTS or {}) do
		local ok, data = pcall(C_TooltipInfo.GetInventoryItem, "player", slot)
		if not ok or not (data and data.lines) then
			print(("   %-9s |cff8a8f98nothing equipped (or unreadable)|r")
				:format(SLOT_NAME[slot] or tostring(slot)))
		else
			sawItem = true
			local name, setLine, two, four = nil, nil, nil, nil
			for i, line in ipairs(data.lines) do
				local t = line and line.leftText
				if type(t) == "string" and t ~= "" then
					if i == 1 then
						name = t
					end
					if t:match("%(%d+/%d+%)") then
						setLine = t
						sawSet = true
					end
					-- Blizzard writes these as "(2) Set: ..." / "(4) Set: ...".
					if t:match("^%(2%)") then two = t end
					if t:match("^%(4%)") then four = t end
				end
			end
			print(("   %-9s %s"):format(SLOT_NAME[slot] or tostring(slot), name or "?"))
			print("      set line: " .. (setLine and ("|cff40ff40" .. setLine .. "|r") or "|cff8a8f98none|r"))
			if two then print("      " .. two) end
			if four then print("      " .. four) end
		end
	end
	-- 🔴 EVERY LINE OF THE FIRST SET PIECE, because the summary above already lied by
	-- omission once. Rob's 29 aug run showed a "(4) Set:" line and no "(2) Set:" line while
	-- wearing three pieces -- so the 2-set is ACTIVE and missing from what we read. Either
	-- Blizzard words the earned bonus differently, or it is not in leftText at all. Guessing
	-- which would be exactly the mistake this probe exists to avoid, so dump the lot.
	for _, slot in ipairs(ns.TIER_SLOTS or {}) do
		local ok, data = pcall(C_TooltipInfo.GetInventoryItem, "player", slot)
		if ok and data and data.lines then
			local hasSet = false
			for _, line in ipairs(data.lines) do
				local t = line and line.leftText
				if type(t) == "string" and t:match("%(%d+/%d+%)") then
					hasSet = true
					break
				end
			end
			if hasSet then
				print(("   --- every line of %s, verbatim ---"):format(SLOT_NAME[slot] or "?"))
				for i, line in ipairs(data.lines) do
					local t = line and line.leftText
					local r = line and line.rightText
					print(("   %2d| %s%s"):format(i, tostring(t or "(no leftText)"),
						r and ("   |cff8a8f98[right: " .. tostring(r) .. "]|r") or ""))
				end
				break
			end
		end
	end

	print("   ---")
	if not sawItem then
		print("   |cffff5555Could not read a single item.|r That is not the same as wearing "
			.. "none — it means the tooltip API gave us nothing, and the plan is blocked.")
	elseif not sawSet then
		print("   |cff8a8f98Items read fine, no set line on any of them.|r You are wearing no "
			.. "tier pieces, which is a real answer: there is nothing for the page to read, "
			.. "and it should say so rather than name a set.")
	else
		print("   |cff40ff40A set line is readable off worn gear.|r If the (2)/(4) lines are "
			.. "above too, both tables in TierSetData.lua can go.")
	end
end

--- The set the player is WEARING, read from their own gear. Replaces both tables.
---
--- 🔴 WHY THE TABLES ARE GONE (Rob's decision, 29 aug 2026). `TIER_SET_BY_CLASS` and
--- `TIER_SPEC_BONUS` were a 12.0.7 datamine from 16 June — Season 1 — and shipped as this
--- season's truth for months. A table keyed to a season rots every season, and this one had
--- gone quietly wrong three times. Everything they held is in the tooltip of a piece the
--- player is wearing: already translated, always current, and impossible to have stale.
---
--- 🔴 WHAT THIS DELIBERATELY NO LONGER ANSWERS, because it was answering it wrongly. The old
--- page claimed "this is your class's set". Worn gear cannot say that: Rob's Shaman wears
--- LAST season's tier, so reading his gear gives "Mantle of the Primal Core" — true about
--- what he wears, and not the answer to "what should I chase this season". We have no client
--- source for that question, so the page now answers the one it can. Rob chose this over
--- keeping a table (option A, 29 aug). ⚠️ Do not reintroduce a set table to fill the gap.
---
--- ⚠️ AND THE EARNED BONUS HAS NO NUMBER. Measured on his Head piece at 3/5:
---     21|   Set: Casting Stormkeeper grants 15% haste for 10 sec.
---     22| (4) Set: Stormkeeper grants 1 additional stack ...
--- The 2-set is active and its "(2)" prefix is simply absent; the unearned 4-set keeps its
--- own. A first pass matched `^%(2%)` and silently found nothing, which would have hidden
--- the active bonus forever. So bonuses are matched on "Set:" and ordered by appearance, and
--- which one is live is decided by the COUNT, not by the prefix.
--- ⚠️ One item, one measurement. At 5/5 the 4-set should lose its prefix too; unverified.
---
--- @return table|nil { name, have, total, pieces = {names}, bonuses = {text} }
local function ReadWornTierSet()
	if not (C_TooltipInfo and C_TooltipInfo.GetInventoryItem) then
		return nil
	end
	for _, slot in ipairs(ns.TIER_SLOTS or {}) do
		local ok, data = pcall(C_TooltipInfo.GetInventoryItem, "player", slot)
		if ok and data and type(data.lines) == "table" then
			local set, seenSet = nil, false
			for _, line in ipairs(data.lines) do
				local t = line and line.leftText
				-- ⚠️ TRIM BEFORE TESTING FOR EMPTY. A tooltip separator line is not "" but a
				-- single space, so `t ~= ""` let it through and it became a sixth piece --
				-- which is why the list rendered with a trailing comma on Rob's first look.
				if type(t) == "string" then
					t = t:match("^%s*(.-)%s*$")
				end
				if type(t) == "string" and t ~= "" then
					if not seenSet then
						local nm, have, total = t:match("^(.-)%s*%((%d+)/(%d+)%)%s*$")
						if nm and nm ~= "" then
							seenSet = true
							set = {
								name = nm,
								have = tonumber(have),
								total = tonumber(total),
								pieces = {},
								bonuses = {},
							}
						end
					elseif t:match("Set:") then
						-- Strip the leading "(n)" where the game supplies one -- the earned
						-- bonus has none -- and then the word "Set:" itself, because our own
						-- label already says "2-set bonus:" and "Set: Set:" reads as a bug.
						local body = t:gsub("^%s*%(%d+%)%s*", ""):gsub("^%s*[Ss]et:%s*", "")
						set.bonuses[#set.bonuses + 1] = body
					elseif #set.bonuses == 0 then
						-- Between the set line and the first bonus sit the piece names.
						set.pieces[#set.pieces + 1] = t
					end
				end
			end
			if set and set.name then
				return set
			end
		end
	end
	return nil
end

-- 📌 `SpellLink` went with the tables too: it existed to turn a stored bonus spell ID into
-- a hoverable link. The bonus text now arrives as text, already translated, so there is no
-- ID left to link and nothing for the player to hover for a truer answer.

-- Gekleurd label (groen = actief, grijs = nog niet) — geen glyphs, dus geen
-- font-box-risico.
local function StatusLabel(label, active)
	return (active and "|cff73d873" or "|cff9aa0a8") .. label .. "|r"
end

--------------------------------------------------------------------------------
-- Body
--------------------------------------------------------------------------------

-- Creation Catalyst-locatie (zelfde als de SMC City Guide: Bazaar, Silvermoon 2393).
local CATALYST = { map = 2393, x = 40.31, y = 64.85 }

local function SetCatalystWaypoint()
	local name = ns:L("TIER_CATALYST_NAME")
	if C_AddOns and C_AddOns.LoadAddOn and C_AddOns.IsAddOnLoaded and not C_AddOns.IsAddOnLoaded("TomTom") then
		pcall(C_AddOns.LoadAddOn, "TomTom")
	end
	-- ⚠️ Own waypoint, so ns.AddSmartTomTomWay's level warning never sees this one. See
	-- the note in CurrencyGuide: six places bypass that door and each needs the call.
	if ns.WarnZoneLevelIfNeeded then
		local okGate, blocked = pcall(ns.WarnZoneLevelIfNeeded, CATALYST.map, CATALYST.x, name)
		if okGate and blocked then
			return
		end
	end
	local slashWay = SlashCmdList and SlashCmdList["TOMTOM_WAY"]
	if type(slashWay) == "function" then
		pcall(slashWay, ("#%d %.2f %.2f %s"):format(CATALYST.map, CATALYST.x, CATALYST.y, name))
		return
	end
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local p = UiMapPoint.CreateFromCoordinates(CATALYST.map, CATALYST.x / 100, CATALYST.y / 100)
		if pcall(C_Map.SetUserWaypoint, p) and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
end

local function BodyText()
	local lines = {}

	-- Level 1: algemene uitleg (gelokaliseerd). {CATALYST} → klikbare waypoint-link.
	local intro = ns:L("TIER_GUIDE_BODY")
	if ns.ExpandDelveTipMarkup then
		intro = ns:ExpandDelveTipMarkup(intro)
	end
	intro = intro:gsub("{CATALYST}", function()
		return "|cff71d5ff|Hmhcatalyst|h[" .. ns:L("TIER_CATALYST_NAME") .. "]|h|r"
	end)
	lines[#lines + 1] = intro

	-- Level 2: the set on your body, read live. Nothing here is stored by us.
	lines[#lines + 1] = " "
	local worn = ReadWornTierSet()
	if worn then
		lines[#lines + 1] = "|cffe8c36a" .. ns:L("TIER_YOUR_SET") .. "|r " .. worn.name
		if #worn.pieces > 0 then
			lines[#lines + 1] = "|cff9aa0a8" .. table.concat(worn.pieces, ", ") .. "|r"
		end
		local n, total = worn.have or 0, worn.total or 5
		lines[#lines + 1] = ns:L("TIER_COUNT_FMT"):format(n)
			.. "    "
			.. StatusLabel("2-set", n >= 2)
			.. "    "
			.. StatusLabel("4-set", n >= 4)
		-- The bonuses in the game's own words, in the order the tooltip lists them: 2-set
		-- first, then 4-set. Which is LIVE comes from the count, because the earned one has
		-- no "(n)" prefix to read (see ReadWornTierSet).
		for i, text in ipairs(worn.bonuses) do
			local need = (i == 1) and 2 or 4
			local head = (need == 2) and ns:L("TIER_2SET") or ns:L("TIER_4SET")
			local colour = (n >= need) and "|cffe8c36a" or "|cff9aa0a8"
			lines[#lines + 1] = colour .. head .. "|r " .. text
		end
		if total ~= 5 then
			-- Never seen; say it rather than silently render "x/5" from a different set size.
			lines[#lines + 1] = ("|cff9aa0a8(%d/%d)|r"):format(n, total)
		end
	else
		-- ⚠️ Not a failure, and not "you have no set". We can only read a set off a piece you
		-- are wearing, so with none on there is nothing to report -- and inventing a name is
		-- exactly what this rewrite removed.
		lines[#lines + 1] = "|cff9aa0a8" .. ns:L("TIER_SET_UNKNOWN") .. "|r"
	end

	--- ⚠️ THE FOOTER ONLY MAKES SENSE WHEN THERE IS A SET ABOVE IT. Rob, 29 aug, on his
	--- Shadow Priest: the page correctly said "put on one tier piece and this fills itself
	--- in" and then, two lines down, "The set above is read from the piece you are wearing"
	--- — about a set that was not there. Worse, the two sentences say the same thing, so the
	--- one case with nothing to show got the explanation twice and the subject once.
	---
	--- TIER_SET_UNKNOWN already carries the mechanism ("we read your set off the gear you are
	--- wearing"), so with no set on there is nothing left for a footnote to add.
	if worn then
		lines[#lines + 1] = " "
		lines[#lines + 1] = "|cff9aa0a8" .. ns:L("TIER_FOOTER") .. "|r"
	end

	return table.concat(lines, "|n")
end

--------------------------------------------------------------------------------
-- Paneel (tab "tier", Character-sectie)
--------------------------------------------------------------------------------

--- Tier pieces worn, and the set size. Returns nil when the count is unreadable —
--- TierPiecesEquipped already distinguishes "0 pieces" from "could not read", and
--- that distinction must survive: reporting 0/5 to someone wearing 4 would be worse
--- than saying nothing.
function ns.GetTierSetSummary()
	local worn = TierPiecesEquipped()
	if worn == nil then
		return nil, nil
	end
	return worn, 5
end

function ns.RefreshTierSetPanel()
	if not (ui and ui.body) then
		return
	end
	ui.body:SetText(BodyText())
end

function ns.BuildTierSetPanel(panel)
	if not panel or panel._mhTierBuilt then
		return
	end
	panel._mhTierBuilt = true
	if panel._body then
		panel._body:Hide()
	end
	if panel._header then
		panel._header:Hide()
	end

	local title = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	title:SetFontObject(ns.MHScalableFont("GameFontHighlightLarge"))
	title:SetPoint("TOPLEFT", panel, "TOPLEFT", 14, -12)
	title:SetText(ns:L("TAB_TIER"))

	local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	subtitle:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetPoint("RIGHT", panel, "RIGHT", -14, 0)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetWordWrap(true)
	subtitle:SetTextColor(0.75, 0.78, 0.82)
	subtitle:SetText(ns:L("TIER_SUBTITLE"))

	local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
	scroll:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -30, 14)

	local body = CreateFrame("EditBox", nil, scroll)
	body:SetMultiLine(true)
	body:SetFontObject(ns.MHScalableFont("GameFontHighlightSmall"))
	body:SetJustifyH("LEFT")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	body:SetSpacing(6)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	body:SetWidth(520)
	body:SetScript("OnEscapePressed", body.ClearFocus)
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end
	-- Klik op de Creation Catalyst-link → waypoint (spell-links blijven op hover
	-- hun tooltip tonen via de attach hierboven).
	body:SetScript("OnHyperlinkClick", function(_, linkData)
		if linkData == "mhcatalyst" then
			SetCatalystWaypoint()
		end
	end)
	scroll:SetScrollChild(body)

	scroll:SetScript("OnSizeChanged", function(self, w)
		if w and w > 40 then
			body:SetWidth(w - 8)
		end
	end)

	ui = { panel = panel, title = title, subtitle = subtitle, body = body }

	panel:SetScript("OnShow", function()
		ns.RefreshTierSetPanel()
	end)

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
	ev:SetScript("OnEvent", function(_, event, unit)
		if event == "UNIT_INVENTORY_CHANGED" and unit and unit ~= "player" then
			return
		end
		if ui and ui.panel and ui.panel:IsShown() then
			if C_Timer and C_Timer.After then
				C_Timer.After(0.1, ns.RefreshTierSetPanel)
			else
				ns.RefreshTierSetPanel()
			end
		end
	end)

	ns.RefreshTierSetPanel()
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if ui and ui.title then
			ui.title:SetText(ns:L("TAB_TIER"))
			ui.subtitle:SetText(ns:L("TIER_SUBTITLE"))
			if ui.panel and ui.panel:IsShown() then
				ns.RefreshTierSetPanel()
			end
		end
	end
end
