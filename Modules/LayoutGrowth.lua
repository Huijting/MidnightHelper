local _, ns = ...

--[[
	Midnight Helper — you learned something; here is where it goes.

	A beginner does not meet their class all at once. They meet it one ability at a time,
	over weeks, and the moment a new one appears is the moment they are most willing to
	learn where it belongs. Carola's whole difficulty with WoW is the wall of buttons; a
	layout that arrives complete on day one is the same wall with better handwriting.

	So when a new ability turns up and the layout has a key for it, we say so. Once. In
	one line. And then nothing happens until the player asks for it — this file never
	places anything, never binds anything, and never touches a bar.

	⚠️ The event is the modern `LEARNED_SPELL_IN_SKILL_LINE`; `LEARNED_SPELL_IN_TAB` is
	the older name and both are still in use across installed addons, so both are
	registered. Neither fires on login, which matters: the point is the moment of
	learning, not a lecture every time you sign in.
]]

local PENDING = {}
local scheduled = false

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Is this ability already sitting on a bar somewhere? If it is, the player has a place
--- for it and does not need advice.
local function OnABar(spellID)
	if not (spellID and GetActionInfo) then
		return false
	end
	for slot = 1, 180 do
		local ok, kind, id = pcall(GetActionInfo, slot)
		if ok and kind == "spell" and id == spellID then
			return true
		end
	end
	return false
end

local function NameOf(spellID)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, spellID)
		if ok and n then
			return n
		end
	end
	return tostring(spellID)
end

--- One tip per burst. Levelling up can teach several abilities at once, and four
--- separate lines about four keys is the wall of buttons again, in chat.
local MAX_LINES = 3

local function Report()
	scheduled = false
	local ids = PENDING
	PENDING = {}

	if ns.db and ns.db.growthTips == false then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return -- the middle of a fight is the worst possible moment for a layout tip
	end
	if not ns.MH_AutoMapSpecAndSlots then
		return
	end
	local spec = ns.MH_AutoMapSpecAndSlots()
	if not (spec and spec.spellByUiKey and ns.Keybind_FindSpellBindKey) then
		return
	end

	local lines = {}
	for spellID in pairs(ids) do
		local bindKey = ns.Keybind_FindSpellBindKey(spec, spellID)
		if bindKey and not OnABar(spellID) then
			lines[#lines + 1] = { name = NameOf(spellID), key = bindKey }
		end
	end
	if #lines == 0 then
		return
	end
	table.sort(lines, function(a, b)
		return a.name < b.name
	end)

	for i = 1, math.min(#lines, MAX_LINES) do
		local l = lines[i]
		print(("%s you learned |cffffffff%s|r — the layout puts it on |cffffd100%s|r."):format(
			Prefix(), l.name, l.key))
	end
	if #lines > MAX_LINES then
		print(("   |cff9d9d9dand %d more.|r"):format(#lines - MAX_LINES))
	end
	print("   |cff9d9d9d|cffffffff/mh apply|r shows the change, |cffffffff/mh apply go|r makes it. Nothing has moved.|r")
end

local f = CreateFrame("Frame")
f:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
f:RegisterEvent("LEARNED_SPELL_IN_TAB")
f:SetScript("OnEvent", function(_, _, spellID)
	local id = tonumber(spellID)
	if not id then
		return
	end
	PENDING[id] = true
	--- Wait before speaking. A level-up delivers its abilities as a burst, and the
	--- spellbook needs a moment to agree that they exist — asking the layout too early
	--- gets an answer about the old one.
	if not scheduled and C_Timer and C_Timer.After then
		scheduled = true
		C_Timer.After(3, Report)
	end
end)

--- `/mh tips` — turn the learned-ability lines off or on.
function ns.MH_ToggleGrowthTips()
	ns.db = ns.db or {}
	if ns.db.growthTips == false then
		ns.db.growthTips = true
		print(Prefix() .. " layout tips on: we mention where a newly learned ability goes.")
	else
		ns.db.growthTips = false
		print(Prefix() .. " layout tips off.")
	end
end
