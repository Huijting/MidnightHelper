local _, ns = ...

--[[
	Midnight Helper — what each curio actually does (/mh curios).

	EXPLAIN FIRST, THEN STAR. Rob, 16 aug, looking at Valeera's window: "ik mis hier ons
	advies nog." This used to refuse to answer that, and said so here in capitals.

	⚠️ THE REFUSAL'S REASONING WAS SOUND AND IS KEPT, because it is what makes the star
	safe. `Everything Delves` already ships curio recommendations and is current
	(v1.25.0, 12.1); copying their ranking would make MH a relay that goes quietly wrong
	the day they change their mind. Worse were the guides: the "best Season 2 curios"
	articles name Sanctum's Edict and Time Lost Edict, which are Brann curios from The
	War Within and appear nowhere in Valeera's window.

	🔴 So the fix was never "do not recommend" — it was "do not recommend without the
	check those articles skipped". Rob asked a third time on 2 sep 2026 and the answer
	is a star on the guides' picks, ALWAYS verified against the tree in front of the
	player, with anything unverifiable named at the foot instead of quietly dropped.
	The effect text still comes from the client, so the player can still overrule us.

	The explaining is still the point — that is the line mh-market-position calls MH's
	edge — and the footer keeps saying, in those words, that we have not tested these.

	⚠️ THE OPTIONS ARE NEVER HARDCODED, and that is the whole design. (The star list in
	DelveCuriosData is the one hardcoded thing, and it is the one thing that cannot come
	from the client — the client knows what the curios do, not what strangers think of
	them. That is exactly why it is verified against the tree on every render.)

	  * the choice nodes come from the companion's own trait tree, so a curio Blizzard
	    adds next season appears without anyone editing a file;
	  * the effect text comes from GetSpellDescription, so it is already in the player's
	    language and cannot drift from the game;
	  * which option is active comes from the node, not from a guess about the icons.

	A hardcoded list would have been faster to write and wrong by Tuesday.
]]

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- Every choice node on the companion's tree, with all its options resolved.
--- @return table|nil nodes, string|nil why  (why is a reason key when nothing came back)
function ns.GetCompanionChoices()
	if not (C_DelvesUI and C_Traits and C_Traits.GetConfigIDByTreeID) then
		return nil, "CURIO_NO_API"
	end
	local companionID
	if DelvesCompanionConfigurationFrame then
		companionID = DelvesCompanionConfigurationFrame.playerCompanionID
	end
	local okTree, treeID = pcall(C_DelvesUI.GetTraitTreeForCompanion, companionID)
	if not okTree or not treeID then
		-- ⚠️ Usually means her window has never been opened this session: the
		-- configuration frame is what carries the companion id. Say that, rather than
		-- letting an empty panel imply she has no curios.
		return nil, "CURIO_NO_TREE"
	end
	local okCfg, configID = pcall(C_Traits.GetConfigIDByTreeID, treeID)
	if not okCfg or not configID then
		return nil, "CURIO_NO_TREE"
	end
	local okNodes, nodeIDs = pcall(C_Traits.GetTreeNodes, treeID)
	if not okNodes or type(nodeIDs) ~= "table" then
		return nil, "CURIO_NO_TREE"
	end

	local out = {}
	for _, nodeID in ipairs(nodeIDs) do
		local okI, info = pcall(C_Traits.GetNodeInfo, configID, nodeID)
		if okI and type(info) == "table" and type(info.entryIDs) == "table"
			and #info.entryIDs > 1 then
			-- More than one entry is what a choice node IS. Ranks and tracks have one.
			local activeID = info.activeEntry and info.activeEntry.entryID or nil
			local options = {}
			for _, entryID in ipairs(info.entryIDs) do
				local okE, e = pcall(C_Traits.GetEntryInfo, configID, entryID)
				if okE and type(e) == "table" and e.definitionID then
					local okD, d = pcall(C_Traits.GetDefinitionInfo, e.definitionID)
					if okD and type(d) == "table" and d.spellID then
						local sid = d.spellID
						-- Ask the server before reading: the description cache is cold
						-- for anything the player has not hovered, and an empty text
						-- would read as "this does nothing".
						if C_Spell and C_Spell.RequestLoadSpellData then
							pcall(C_Spell.RequestLoadSpellData, sid)
						end
						local name, desc
						if C_Spell and C_Spell.GetSpellName then
							local okN, v = pcall(C_Spell.GetSpellName, sid)
							name = okN and v or nil
						end
						if C_Spell and C_Spell.GetSpellDescription then
							local okDe, v = pcall(C_Spell.GetSpellDescription, sid)
							-- Positive test: some spells return a bare "\r\n", which is
							-- empty to a reader but not to `~= ""`.
							if okDe and type(v) == "string" and v:find("%w") then
								desc = v
							end
						end
						options[#options + 1] = {
							spellID = sid, name = name, desc = desc,
							active = (entryID == activeID),
						}
					end
				end
			end
			if #options > 1 then
				out[#out + 1] = { nodeID = nodeID, options = options }
			end
		end
	end
	if #out == 0 then
		return nil, "CURIO_NO_CHOICES"
	end
	return out
end

--- Build the readable text. Marks the active pick; never says which is better.
function ns.BuildCurioExplainText()
	local nodes, why = ns.GetCompanionChoices()
	if not nodes then
		return L(why or "CURIO_NO_CHOICES")
	end

	-- The starred picks, and a positive control on them. `seen` proves the id is in the
	-- tree we are looking at; anything left unseen is named at the foot rather than
	-- silently missing, because an absent star is indistinguishable from a node that
	-- simply has no recommendation. See DelveCuriosData for why this check exists.
	local picks = ns.GetDelveCurioGuidePicks and ns.GetDelveCurioGuidePicks() or nil
	local seen = {}
	-- Set when at least one of our own notes was printed, so the explanation of what
	-- the mark means only appears when the mark does.
	local noted = false

	local lines = { L("CURIO_HEADER"), "" }
	if picks then
		lines[#lines + 1] = L("CURIO_GUIDE_INTRO")
		lines[#lines + 1] = ""
	end
	for _, node in ipairs(nodes) do
		-- ✅ THE SLOTS DO HAVE NAMES, and this used to say they did not. The old
		-- comment read "the game does not name these slots in a way we can read", and
		-- numbering them was right while that was believed — but Valeera's own window
		-- lists them as Poisons, Combat Curio and Utility Curio, beside the pick that
		-- is slotted in each. Nobody had looked. Measured 2 sep 2026, see
		-- DelveCuriosData for the mapping and why it is keyed by nodeID.
		--
		-- An unknown node still falls back to the numbered label, so a slot we have
		-- no name for is unnamed rather than mislabelled.
		local labelKey = ns.GetDelveCurioSlotLabelKey
			and ns.GetDelveCurioSlotLabelKey(node.nodeID) or nil
		local heading = labelKey and L(labelKey)
			or (L("CURIO_CHOICE_FMT")):format(#node.options)
		lines[#lines + 1] = ("== %s =="):format(heading)
		for _, o in ipairs(node.options) do
			local mark = o.active and L("CURIO_ACTIVE") or "  "
			local star = ""
			if picks and o.spellID and picks[o.spellID] then
				seen[o.spellID] = true
				star = L("CURIO_GUIDE_MARK")
			end
			lines[#lines + 1] = ("%s %s%s"):format(mark, star, o.name or ("spell " .. o.spellID))
			if o.desc then
				-- ⚠️ EXACTLY EIGHT hex digits. `|c%x+` is greedy and A-F are hex
				-- digits, so it swallows the first letter of the coloured word —
				-- "|cffffffffBlood Shield|r" came out as "lood Shield" in the stat
				-- coach's smoke test, 26 aug, with this very pattern. Every curio
				-- whose highlighted word starts with a, b, c, d, e or f has been
				-- printing one letter short since this shipped.
				local clean = o.desc:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
					:gsub("|T[^|]*|t", ""):gsub("%s+", " "):gsub("^%s+", "")
				lines[#lines + 1] = ("      %s"):format(clean)
				-- Our own reading, directly under the text it was read from, so the
				-- player can check it rather than take it. Marked differently from the
				-- star because it is a different claim: see DelveCuriosData.
				local noteKey = ns.GetDelveCurioOurNote
					and ns.GetDelveCurioOurNote(o.spellID) or nil
				if noteKey then
					noted = true
					lines[#lines + 1] = ("      %s%s"):format(L("CURIO_NOTE_MARK"), L(noteKey))
				end
			else
				-- Unreadable, not absent. A blank line here would look like a curio
				-- that does nothing.
				lines[#lines + 1] = ("      %s"):format(L("CURIO_NO_TEXT"))
			end
			lines[#lines + 1] = ""
		end
	end
	if picks then
		-- 🔴 The positive control, and the whole reason the star is safe to show.
		-- A recommendation that names something the player cannot find is exactly the
		-- failure the guides make; if ours ever does it, it says so out loud.
		local lost = {}
		for spellID in pairs(picks) do
			if not seen[spellID] then
				local nm
				if C_Spell and C_Spell.GetSpellName then
					local ok, v = pcall(C_Spell.GetSpellName, spellID)
					nm = ok and v or nil
				end
				lost[#lost + 1] = nm or ("spell " .. spellID)
			end
		end
		if #lost > 0 then
			table.sort(lost)
			lines[#lines + 1] = (L("CURIO_GUIDE_MISSING_FMT")):format(table.concat(lost, ", "))
			lines[#lines + 1] = ""
		end
		lines[#lines + 1] = L("CURIO_GUIDE_NOTE")
		lines[#lines + 1] = ""
	end
	if noted then
		lines[#lines + 1] = L("CURIO_NOTE_DISCLAIMER")
		lines[#lines + 1] = ""
	end
	lines[#lines + 1] = L("CURIO_FOOTER")
	return table.concat(lines, "\n")
end

--- ⚠️ ASK FIRST, READ AFTER. RequestLoadSpellData is asynchronous, and the first run
--- proved it the hard way: every one of eight curios printed "(the game gave no
--- description for this one)" because the request and the read happened in the same
--- frame. The trait sweep learned this a few hours earlier and grew a second pass; this
--- file requested the data and then read it immediately anyway.
---
--- So the request goes out, and the text is built a beat later.
---
--- 🔴 AND ONE SECOND IS NOT ENOUGH — measured 25 aug 2026, which killed the sentence
--- that used to end this comment. It read: "A description that is still missing then is
--- genuinely missing, which is worth saying." Rob ran /mh curios and two of six poisons
--- came back blank; he then hovered those exact two in the game's own picker and both
--- had full text (Frostheart Venom 1305912, Phantasmal Spore Toxin 1305924). So a blank
--- after one second means the cache was still cold, not that the spell has no text.
---
--- That is the same mistake this repo keeps making in a new place: treating silence as
--- absence. The wait now retries instead of concluding, and the line shown for a text
--- that never arrives says it could not be read — not that the game has nothing.
local function RequestAll(nodes)
	if not (C_Spell and C_Spell.RequestLoadSpellData) then
		return
	end
	for _, node in ipairs(nodes or {}) do
		for _, o in ipairs(node.options or {}) do
			if o.spellID then
				pcall(C_Spell.RequestLoadSpellData, o.spellID)
			end
		end
	end
end

--- /mh curios
function ns.ShowCurioExplain()
	local nodes = ns.GetCompanionChoices()
	if nodes and C_Timer and C_Timer.After then
		RequestAll(nodes)
		--- Keep asking until every option has text, or until we run out of patience.
		--- One second used to be the whole plan and it was not enough (see RequestAll).
		--- Re-requesting matters as much as re-reading: a cold spell needs the ask, and
		--- the previous ask may have gone out before its node was even known.
		local tries = 0
		local function attempt()
			tries = tries + 1
			local fresh = ns.GetCompanionChoices()
			local missing = 0
			for _, node in ipairs(fresh or {}) do
				for _, o in ipairs(node.options or {}) do
					if o.spellID and not o.desc then
						missing = missing + 1
					end
				end
			end
			-- Show as soon as everything is in, or after the last try. Four attempts
			-- over ~4s: long enough for a slow round-trip, short enough that it still
			-- reads as an answer to the command.
			if missing == 0 or tries >= 4 then
				ns.ShowCurioExplainNow()
				return
			end
			RequestAll(fresh)
			C_Timer.After(1, attempt)
		end
		C_Timer.After(1, attempt)
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CURIO_LOADING")))
		return
	end
	ns.ShowCurioExplainNow()
end

function ns.ShowCurioExplainNow()
	local text = ns.BuildCurioExplainText()
	if ns.ShowShareCopyDialog then
		ns.ShowShareCopyDialog({
			id = "curios",
			text = text,
			titleKey = "CURIO_TITLE",
			hintKey = "CURIO_HINT",
			closeKey = "DELVE_SHARE_COPY_CLOSE",
			-- Eight effect descriptions do not fit a party-message box. Drag it larger
			-- from the corner if your screen allows.
			width = 620, height = 480,
		})
	else
		print(text)
	end
end
