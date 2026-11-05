local _, ns = ...

--[[
	SpellbookDump.lua — /mh spellbook: write this character's spellbook, action bars and what the key block would
	pick up to ns.db.spellbookDump, so it can be read from SavedVariables after a /reload.

	Why (5 Nov 2026, Rob: "Ja, toetsenblok" for his Night Elf Druid in WoW Forever): the key block's spell lists are
	Midnight's. Forever has vanilla spells with ranks and one spec per class (docs/PLAN_FOREVER_2026-11-05.md). The
	lists for Forever must come from the client, not from a guess or a website (CLAUDE.md "ask the client instead").

	Reads only. Every call is guarded: a missing API or a secret value leaves a field empty, it never breaks the dump.
	Works on retail too (same APIs), which gives a comparison.
]]

local function Plain(v)
	if v == nil then
		return nil
	end
	if issecretvalue and issecretvalue(v) then
		return nil
	end
	return v
end

local function Call(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, a, b, c, d = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b, c, d
end

local function ReadSpellbook()
	local lines = {}
	local SB = C_SpellBook
	if not (SB and SB.GetNumSpellBookSkillLines and SB.GetSpellBookSkillLineInfo and SB.GetSpellBookItemInfo) then
		return lines, "no C_SpellBook"
	end
	local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player
	local n = Call(SB.GetNumSpellBookSkillLines) or 0
	for i = 1, n do
		local info = Call(SB.GetSpellBookSkillLineInfo, i)
		if type(info) == "table" then
			local line = {
				name = Plain(info.name),
				offSpecID = Plain(info.offSpecID),
				shouldHide = Plain(info.shouldHide) and true or nil,
				spells = {},
			}
			local first = (tonumber(Plain(info.itemIndexOffset)) or 0) + 1
			local count = tonumber(Plain(info.numSpellBookItems)) or 0
			for slot = first, first + count - 1 do
				local it = Call(SB.GetSpellBookItemInfo, slot, bank)
				if type(it) == "table" then
					local low = SB.IsSpellBookItemLowRank and Call(SB.IsSpellBookItemLowRank, slot, bank)
					line.spells[#line.spells + 1] = {
						name = Plain(it.name),
						id = Plain(it.spellID) or Plain(it.actionID),
						rank = Plain(it.subName),
						passive = Plain(it.isPassive) and true or nil,
						lowRank = Plain(low) and true or nil,
						type = Plain(it.itemType),
					}
				end
			end
			lines[#lines + 1] = line
		end
	end
	return lines
end

local function ReadActions()
	local out = {}
	if not GetActionInfo then
		return out
	end
	for slot = 1, 180 do
		local kind, id, sub = Call(GetActionInfo, slot)
		kind, id = Plain(kind), Plain(id)
		if kind then
			local name
			if kind == "spell" and id and C_Spell and C_Spell.GetSpellName then
				name = Plain(Call(C_Spell.GetSpellName, id))
			end
			out[#out + 1] = { slot = slot, kind = kind, id = id, sub = Plain(sub), name = name }
		end
	end
	return out
end

--- What the key block would build from MH's own lists right now (KeybindAutoMap.lua). Tells whether the Midnight
--- lists recognise anything on this character.
local function ReadAutoMap()
	if not ns.MH_AutoMapBuild then
		return { note = "no MH_AutoMapBuild" }
	end
	local ok, _map, _m, _u, class, _cc, _up, _ids, spells, specID = pcall(ns.MH_AutoMapBuild)
	if not ok then
		return { note = "MH_AutoMapBuild failed: " .. tostring(_map) }
	end
	-- Entries are { id, role, category, priority, … } (KeybindAutoMap.lua ~372).
	local names = {}
	for _, s in ipairs(type(spells) == "table" and spells or {}) do
		if type(s) == "table" then
			local nm = s.id and C_Spell and C_Spell.GetSpellName and Plain(Call(C_Spell.GetSpellName, s.id))
			names[#names + 1] = { id = s.id, name = nm, role = s.role, category = s.category }
		end
	end
	return { class = class, specID = specID, count = #names, spells = names }
end

function ns.DumpSpellbook()
	ns.db = ns.db or {}
	local _, classFile, classID = UnitClass("player")
	local specIndex = ns.GetSpecialization and ns.GetSpecialization()
	local specID, specName
	if specIndex and ns.GetSpecializationInfo then
		specID, specName = Call(ns.GetSpecializationInfo, specIndex)
	end
	local lines, note = ReadSpellbook()
	local actions = ReadActions()
	local dump = {
		at = time and time() or 0,
		forever = ns.IS_FOREVER and true or false,
		build = select(4, GetBuildInfo()),
		class = classFile,
		classID = classID,
		level = UnitLevel and UnitLevel("player"),
		specIndex = specIndex,
		specID = Plain(specID),
		specName = Plain(specName),
		note = note,
		lines = lines,
		actions = actions,
		automap = ReadAutoMap(),
	}
	ns.db.spellbookDump = dump
	local spellCount = 0
	for _, l in ipairs(lines) do
		spellCount = spellCount + #l.spells
	end
	print(("|cffe8c36aMidnight Helper|r — %s"):format(ns:L("SPELLBOOK_DUMP_DONE_FMT"):format(spellCount, #lines,
		#actions, dump.automap.count or 0)))
end
