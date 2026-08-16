local _, ns = ...

--[[
	Midnight Helper — export the bindings the player ACTUALLY has (/mh binds).

	⚠️ THIS IS A THIRD SOURCE, and mistaking it for one of the other two is the whole
	reason this file has a header. Rob, 15 aug 2026: "ik wil eigenlijk gewoon de
	mogelijkheid dat ik de indeling die ik nu heb, met eventuele aanpassing die ik voor
	mezelf maak, kunnen exporteren."

	  • the SCHEMA  — what MH recommends, from role data (tools/keybind_sheet/)
	  • the AUTO-MAP — what MH would propose for this character's spellbook (Layout tab)
	  • THIS         — what is on his keys right now, including changes he made by hand
	                   and that MH knows nothing about

	The first two come from our data. This one can only come from the client, so it
	reads and never writes. That also keeps it on the right side of the v7 decision that
	the addon does not set bindings (Rob-approved, 6 aug): reading back what someone
	chose is the opposite of overruling it.

	Why it exists at all: he cannot drag the in-game Layout panel to a second monitor,
	and he wants to LEARN his keys — so the output is plain text, made to be copied into
	a document or printed.
]]

local function L(key)
	return (ns.L and ns:L(key)) or key
end

--- What sits in one action slot, in words.
--- @return string|nil label, string|nil kind
local function SlotContents(slot)
	if not GetActionInfo then
		return nil
	end
	-- ⚠️ THE ASSISTANT SLOT IS A MOVING TARGET, and this export exists to be printed
	-- and learned from. Rob mentioned in passing that his key 1 is "de auto spel knop";
	-- two runs a minute apart reported Frozen Orb and then Flurry for it. Naming
	-- whichever spell it happened to suggest would teach him a binding that does not
	-- exist, and it would look exactly like every other row.
	--
	-- C_ActionBar.IsAssistedCombatAction identifies it. Guarded, because that name comes
	-- from JustAC rather than from the client: if it is absent nothing breaks and the
	-- row falls back to the old behaviour.
	if C_ActionBar and C_ActionBar.IsAssistedCombatAction then
		local okA, isAssist = pcall(C_ActionBar.IsAssistedCombatAction, slot)
		if okA and isAssist then
			return L("KEYBIND_EXPORT_ASSIST"), "assist"
		end
	end
	local ok, kind, id, subType = pcall(GetActionInfo, slot)
	if not ok or not kind then
		return nil
	end
	if kind == "spell" and id then
		local name
		if C_Spell and C_Spell.GetSpellName then
			local okS, v = pcall(C_Spell.GetSpellName, id)
			name = okS and v or nil
		end
		return name or ("spell " .. tostring(id)), "spell"
	end
	if kind == "macro" and id then
		local name
		if GetMacroInfo then
			local okM, v = pcall(GetMacroInfo, id)
			name = okM and v or nil
		end
		-- ⚠️ GetMacroInfo takes a macro INDEX (1-138 global plus per-character), and
		-- Rob's export came back with "macro 475" and "macro 2139" — numbers far outside
		-- that range, so it returned nothing and the row said nothing useful. Something
		-- else put those there (he runs OPie among others).
		--
		-- The button itself knows its own label, whoever wrote it. GetActionText is the
		-- name drawn on the slot, which is exactly what a player recognises — and it is
		-- still a NAME, not an interpretation of what the macro does.
		if not name and GetActionText then
			local okT, v = pcall(GetActionText, slot)
			if okT and type(v) == "string" and v ~= "" then
				name = v
			end
		end
		-- A macro's body can be anything, so the honest label is its name plus the fact
		-- that it is a macro. Reading the body and guessing the spell would be inventing.
		return (name and (name .. " (macro)")) or ("macro " .. tostring(id)), "macro"
	end
	if kind == "item" and id then
		local name
		if C_Item and C_Item.GetItemNameByID then
			local okI, v = pcall(C_Item.GetItemNameByID, id)
			name = okI and v or nil
		end
		return name or ("item " .. tostring(id)), "item"
	end
	if kind == "summonpet" or kind == "summonmount" or kind == "companion" then
		return kind, kind
	end
	if kind == "flyout" then
		return "flyout", "flyout"
	end
	return tostring(kind) .. (subType and (" " .. tostring(subType)) or ""), kind
end

--- Build the export text from the live client.
--- @return string text, number bound, number emptyBound
function ns.BuildKeybindExportText()
	local lines = {}
	local name = (UnitName and UnitName("player")) or "?"
	local _, class = (UnitClass and UnitClass("player")) or nil, nil
	if UnitClass then
		local okC, localized = pcall(UnitClass, "player")
		class = okC and localized or nil
	end
	local specName
	if GetSpecialization and GetSpecializationInfo then
		local okS, idx = pcall(GetSpecialization)
		if okS and idx then
			local okI, _, sname = pcall(GetSpecializationInfo, idx)
			specName = okI and sname or nil
		end
	end

	lines[#lines + 1] = ("%s — %s%s"):format(name, specName and (specName .. " ") or "",
		class or "")
	lines[#lines + 1] = L("KEYBIND_EXPORT_SUB")
	lines[#lines + 1] = ""

	local bound, emptyBound = 0, 0
	local bars, seen = {}, {}
	for _, bar in ipairs(ns.KEYBIND_BAR_COMMANDS or {}) do
		local rows = {}
		for i = 1, 12 do
			local command = bar.prefix .. i
			local slot = bar.first + i - 1
			local keys
			if GetBindingKey then
				-- A command can carry more than one key. Showing only the first would
				-- quietly hide half of a setup that deliberately has two.
				local okB, k1, k2, k3 = pcall(GetBindingKey, command)
				if okB then
					local all = {}
					for _, k in ipairs({ k1, k2, k3 }) do
						if k and k ~= "" then
							all[#all + 1] = (GetBindingText and GetBindingText(k)) or k
						end
					end
					if #all > 0 then
						keys = table.concat(all, " / ")
					end
				end
			end
			if keys then
				local label, kind = SlotContents(slot)
				bound = bound + 1
				if not label then
					-- A key that is bound to an empty slot does nothing when pressed.
					-- Worth printing, not worth hiding: it is usually a leftover.
					emptyBound = emptyBound + 1
				end
				rows[#rows + 1] = {
					keys = keys,
					label = label or L("KEYBIND_EXPORT_EMPTY"),
					-- The assistant slot must never count as a duplicate of the spell it
					-- is currently suggesting; it is not that spell tomorrow.
					countable = (label ~= nil and kind ~= "assist"),
				}
			end
		end
		if #rows > 0 then
			bars[#bars + 1] = { name = bar.prefix:gsub("BUTTON$", ""), rows = rows }
			for _, r in ipairs(rows) do
				if r.countable then
					seen[r.label] = (seen[r.label] or 0) + 1
				end
			end
		end
	end

	-- ⚠️ Marking duplicates, NOT complaining about them. Rob has six: his Naga buttons
	-- repeat what is already on the keyboard, because he also plays on a laptop with no
	-- MMO mouse and wants those spells reachable there. That is a good reason, and a
	-- tool that flagged them as a mistake would be wrong about its own user.
	--
	-- The mark is worth having anyway: when you are learning a layout it tells you which
	-- keys are the same thing, and when you need room for something new it shows you
	-- where the room is.
	local dupes = 0
	for _, bar in ipairs(bars) do
		lines[#lines + 1] = bar.name
		for _, r in ipairs(bar.rows) do
			local mark = ""
			if r.countable and (seen[r.label] or 0) > 1 then
				mark = "  " .. L("KEYBIND_EXPORT_DUP")
				dupes = dupes + 1
			end
			lines[#lines + 1] = ("  %-18s %s%s"):format(r.keys, r.label, mark)
		end
		lines[#lines + 1] = ""
	end
	if dupes > 0 then
		lines[#lines + 1] = (L("KEYBIND_EXPORT_DUP_NOTE")):format(dupes)
		lines[#lines + 1] = ""
	end

	if bound == 0 then
		-- ⚠️ Empty output must never read as "you have no bindings". Far likelier is that
		-- the API was unavailable this frame, and a printed empty list would be a lie
		-- the player has no way to catch.
		lines[#lines + 1] = L("KEYBIND_EXPORT_NONE")
	end
	return table.concat(lines, "\n"), bound, emptyBound
end

--- /mh binds — show the text in the copy dialog the share feature already uses.
function ns.ShowKeybindExport()
	local text, bound, emptyBound = ns.BuildKeybindExportText()
	if ns.ShowShareCopyDialog then
		ns.ShowShareCopyDialog({
			id = "keybinds",
			text = text,
			titleKey = "KEYBIND_EXPORT_TITLE",
			hintKey = "KEYBIND_EXPORT_HINT",
			closeKey = "DELVE_SHARE_COPY_CLOSE",
		})
	else
		print(text)
	end
	if emptyBound > 0 then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"),
			(L("KEYBIND_EXPORT_EMPTY_NOTE")):format(emptyBound)))
	end
	return bound
end
