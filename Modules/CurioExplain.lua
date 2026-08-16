local _, ns = ...

--[[
	Midnight Helper — what each curio actually does (/mh curios).

	⚠️ EXPLAIN, DO NOT RANK. Rob, 16 aug, looking at Valeera's window: "ik mis hier ons
	advies nog." The obvious reading is "tell me which is best", and that is the one
	thing this deliberately does not do.

	`Everything Delves` already ships curio recommendations and is current (v1.25.0,
	12.1). Copying their ranking would make MH a relay that goes quietly wrong the day
	they change their mind, and we could never check it. Worse were the guides: the
	"best Season 2 curios" articles name Sanctum's Edict and Time Lost Edict, which are
	Brann curios from The War Within and appear nowhere in Valeera's window.

	So this answers the question underneath the question — what do these things do? —
	and lets the player rank them. That is the line mh-market-position calls MH's edge.

	⚠️ NOTHING IS HARDCODED, and that is the whole design.

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

	local lines = { L("CURIO_HEADER"), "" }
	for _, node in ipairs(nodes) do
		-- The game does not name these slots in a way we can read, so they are
		-- numbered rather than guessed at. Calling one "Poisons" because it has three
		-- options would be inventing a label the window may not agree with.
		lines[#lines + 1] = ("== %s =="):format((L("CURIO_CHOICE_FMT")):format(#node.options))
		for _, o in ipairs(node.options) do
			local mark = o.active and L("CURIO_ACTIVE") or "  "
			lines[#lines + 1] = ("%s %s"):format(mark, o.name or ("spell " .. o.spellID))
			if o.desc then
				local clean = o.desc:gsub("|c%x+", ""):gsub("|r", "")
					:gsub("|T[^|]*|t", ""):gsub("%s+", " "):gsub("^%s+", "")
				lines[#lines + 1] = ("      %s"):format(clean)
			else
				-- Unreadable, not absent. A blank line here would look like a curio
				-- that does nothing.
				lines[#lines + 1] = ("      %s"):format(L("CURIO_NO_TEXT"))
			end
			lines[#lines + 1] = ""
		end
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
--- So the request goes out, and the text is built a beat later. A description that is
--- still missing then is genuinely missing, which is worth saying — the point of asking
--- is that silence afterwards means something.
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
		-- One second, once. Long enough for the server round-trip, short enough that it
		-- still feels like a response to the command rather than a delayed surprise.
		C_Timer.After(1, function()
			ns.ShowCurioExplainNow()
		end)
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
