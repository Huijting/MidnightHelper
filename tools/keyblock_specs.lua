-- keyblock_specs.lua — the STANDARD key block per spec, for the website (route 3, Rob 5 Oct 2026: "doe 3
-- erbij voor mensen die er nog niet hebben").
--
-- Runs the addon's own allocator (ns.KeyBlockAllocate in Modules/KeyBlock.lua) over every classifier
-- entry of a spec, as if the player knew every spell of it — so it is "what it usually looks like", not
-- one player's talents. Racials are left out (they depend on race); Recuperate is in (every class has it,
-- KeybindAutoMap.lua:67). Run through the front door: probe_job.txt = `run keyblock_specs`.
--
-- Output: data/keyblock_specs.json
--   { "version": 1, "layout": [ {block, key, task, fixed?} ... 48 ],
--     "specs": [ { "specID", "name", "class", "places": [ {key, id, name, why} ], "unplaced": [ {id, name} ] } ] }

local ROOT = arg and arg[1] or "."
local MOD = ROOT .. "/Modules/"

-- WoW API stubs: KeyBlock.lua creates frames and dialogs at load. Nothing here is ever called for real.
local dummy
dummy = setmetatable({}, { __index = function() return function() return dummy end end })
CreateFrame = function() return dummy end
UIParent = dummy
StaticPopupDialogs = {}

local ns = {}
for _, f in ipairs({ "Warrior", "Racials", "Paladin", "Hunter", "Rogue", "Priest", "DeathKnight", "Shaman",
	"Mage", "Warlock", "Monk", "Druid", "DemonHunter", "Evoker" }) do
	assert(loadfile(MOD .. "KeybindRoles_" .. f .. ".lua"))("MidnightHelper", ns)
end
assert(loadfile(MOD .. "KeyBlock.lua"))("MidnightHelper", ns)

local SPECS = {
	{ 71, "Arms", "WARRIOR" }, { 72, "Fury", "WARRIOR" }, { 73, "Protection", "WARRIOR" },
	{ 65, "Holy", "PALADIN" }, { 66, "Protection", "PALADIN" }, { 70, "Retribution", "PALADIN" },
	{ 253, "Beast Mastery", "HUNTER" }, { 254, "Marksmanship", "HUNTER" }, { 255, "Survival", "HUNTER" },
	{ 259, "Assassination", "ROGUE" }, { 260, "Outlaw", "ROGUE" }, { 261, "Subtlety", "ROGUE" },
	{ 256, "Discipline", "PRIEST" }, { 257, "Holy", "PRIEST" }, { 258, "Shadow", "PRIEST" },
	{ 250, "Blood", "DEATHKNIGHT" }, { 251, "Frost", "DEATHKNIGHT" }, { 252, "Unholy", "DEATHKNIGHT" },
	{ 262, "Elemental", "SHAMAN" }, { 263, "Enhancement", "SHAMAN" }, { 264, "Restoration", "SHAMAN" },
	{ 62, "Arcane", "MAGE" }, { 63, "Fire", "MAGE" }, { 64, "Frost", "MAGE" },
	{ 265, "Affliction", "WARLOCK" }, { 266, "Demonology", "WARLOCK" }, { 267, "Destruction", "WARLOCK" },
	{ 268, "Brewmaster", "MONK" }, { 269, "Windwalker", "MONK" }, { 270, "Mistweaver", "MONK" },
	{ 102, "Balance", "DRUID" }, { 103, "Feral", "DRUID" }, { 104, "Guardian", "DRUID" }, { 105, "Restoration", "DRUID" },
	{ 577, "Havoc", "DEMONHUNTER" }, { 581, "Vengeance", "DEMONHUNTER" }, { 1480, "Devourer", "DEMONHUNTER" },
	{ 1467, "Devastation", "EVOKER" }, { 1468, "Preservation", "EVOKER" }, { 1473, "Augmentation", "EVOKER" },
}

local function SpecMatches(specs, specID)
	if not specs then
		return true
	end
	for _, s in ipairs(specs) do
		if s == specID then
			return true
		end
	end
	return false
end

-- Minimal JSON writer: strings, numbers, booleans, arrays, objects with sorted keys (stable diffs).
local function J(v)
	local t = type(v)
	if t == "string" then
		return '"' .. v:gsub('[%c"\\]', function(c)
			return ({ ['"'] = '\\"', ["\\"] = "\\\\", ["\n"] = "\\n", ["\t"] = "\\t" })[c] or ""
		end) .. '"'
	elseif t == "number" or t == "boolean" then
		return tostring(v)
	elseif t == "nil" then
		return "null"
	end
	if v[1] ~= nil or next(v) == nil then
		local out = {}
		for _, x in ipairs(v) do
			out[#out + 1] = J(x)
		end
		return "[" .. table.concat(out, ",") .. "]"
	end
	local keys = {}
	for k in pairs(v) do
		keys[#keys + 1] = k
	end
	table.sort(keys)
	local out = {}
	for _, k in ipairs(keys) do
		out[#out + 1] = J(k) .. ":" .. J(v[k])
	end
	return "{" .. table.concat(out, ",") .. "}"
end

local layout = {}
for _, bar in ipairs(ns.KEYBLOCK_LAYOUT) do
	for _, slot in ipairs(bar.slots) do
		layout[#layout + 1] = { block = bar.id, key = slot.key, task = slot.task, fixed = slot.fixed }
	end
end

local specsOut = {}
local recup = ns.KeybindRoleClassifierGlobal and ns.KeybindRoleClassifierGlobal["Recuperate"]
for _, sp in ipairs(SPECS) do
	local specID, specName, class = sp[1], sp[2], sp[3]
	local roles = ns.KeybindRoleClassifier[class] or {}
	local spells, nameOf = {}, {}
	local names = {}
	for name in pairs(roles) do
		names[#names + 1] = name
	end
	table.sort(names) -- stable order for ties without an id
	for _, name in ipairs(names) do
		local r = roles[name]
		-- Healthstone is an item (5512), not a spell: the block puts it on its fixed SHIFT-T place itself
		-- (KeyBlock.lua HEALTHSTONE_ITEM). The Warlock entry stays for /mh apply. (6 Oct 2026, site-chat id round, Rob ok)
		if type(r) == "table" and SpecMatches(r.specs, specID) and r.role ~= "click_cast" and r.category ~= "click_cast"
			and (r.role or r.category) and name ~= "Healthstone" then
			-- No `id` but a per-spec `survivalId` (Blink, Roll, Dash, Bear Form...): that is this spec's
			-- own spell id, checked in the Stay alive round, so the site can show it too.
			local sid = r.id
			if not sid and type(r.survivalId) == "table" then
				sid = r.survivalId[specID]
			elseif not sid and type(r.survivalId) == "number" then
				sid = r.survivalId
			end
			spells[#spells + 1] = { id = sid, name = name, role = r.role, category = r.category, priority = r.priority,
				bindKey = r.bindKey, blockForm = r.blockForm, blockQ = r.blockQ, blockAs = r.blockAs }
		end
	end
	if recup then
		spells[#spells + 1] = { id = recup.id, name = "Recuperate", role = recup.role, priority = recup.priority }
	end
	local occ, unplaced = ns.KeyBlockAllocate(spells, specID)
	local places = {}
	for _, l in ipairs(layout) do
		local hit = occ[l.key]
		if hit then
			places[#places + 1] = { key = l.key, id = hit.spell.id, name = hit.spell.name, why = hit.why }
		end
	end
	local left = {}
	for _, s in ipairs(unplaced) do
		left[#left + 1] = { id = s.id, name = s.name }
	end
	specsOut[#specsOut + 1] = { specID = specID, name = specName, class = class, places = places, unplaced = left }
	io.write(("%-5d %-14s %-12s %2d places, %d without a place\n"):format(specID, specName, class, #places, #left))
end

local path = ROOT .. "/data/keyblock_specs.json"
local f = assert(io.open(path .. ".tmp", "w"))
f:write(J({ version = 1, layout = layout, specs = specsOut }), "\n")
f:close()
os.remove(path)
assert(os.rename(path .. ".tmp", path))
print("wrote " .. path)
