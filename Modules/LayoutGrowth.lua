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

	⚠️ The event is `LEARNED_SPELL_IN_SKILL_LINE`. It does not fire on login, which
	matters: the point is the moment of learning, not a lecture every time you sign in.
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

--- A chat line is easy to miss, and Rob reads chat rarely at the best of times. So the
--- tip also offers a button — one click and the ability is placed, no command to type.
---
--- Off by default is wrong here and on by default would be rude, so it follows the tips
--- setting: if you want to be told, you probably want the button that acts on it.
--- `/mh tips button` turns just the popup off and keeps the chat line.
---
--- ⚠️ NOT AUTOMATIC. The click is the explicit action `/mh apply go` would have been.
--- MH still never places anything the player did not ask for, and that rule does not
--- bend because the asking got easier.
local prompt
local ShowPrompt

local function BuildPrompt()
	if prompt then
		return prompt
	end
	local f = CreateFrame("Frame", "MidnightHelperGrowthPrompt", UIParent, "BackdropTemplate")
	f:SetSize(320, 96)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 180)
	f:SetFrameStrata("DIALOG")
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end
	f.text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.text:SetPoint("TOPLEFT", 14, -14)
	f.text:SetPoint("TOPRIGHT", -14, -14)
	f.text:SetJustifyH("LEFT")
	f.text:SetSpacing(2)

	local place = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	place:SetSize(120, 22)
	place:SetPoint("BOTTOMRIGHT", -14, 12)
	place:SetText(PLACE_THIS_ITEM or "Place it")
	place:SetScript("OnClick", function()
		f:Hide()
		if ns.MH_ApplyLayout then
			ns.MH_ApplyLayout("go")
		end
	end)

	local later = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	later:SetSize(90, 22)
	later:SetPoint("RIGHT", place, "LEFT", -8, 0)
	later:SetText(LATER or "Not now")
	later:SetScript("OnClick", function()
		f:Hide()
	end)

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	prompt = f
	return f
end

function ShowPrompt(lines)
	if ns.db and ns.db.growthButton == false then
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	local f = BuildPrompt()
	local first = lines[1]
	local more = #lines > 1 and ("\n|cff9d9d9dand %d more.|r"):format(#lines - 1) or ""
	f.text:SetText(("You learned |cffffffff%s|r.\nThe layout puts it on |cffffd100%s|r.%s"):format(
		first.name, first.key, more))
	f:Show()
end

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
	ShowPrompt(lines)
end

local f = CreateFrame("Frame")
--- ⚠️ REGISTER DEFENSIVELY. `LEARNED_SPELL_IN_TAB` was added here on the strength of
--- finding it four times across the installed addons — which proves only that somebody
--- once wrote it down, not that this client still knows it. 12.x threw
--- "Attempt to register unknown event" on Rob's very next reload. Grepping other addons
--- is not a way to verify an API against the game.
---
--- The modern name is `LEARNED_SPELL_IN_SKILL_LINE`. Anything else is tried inside a
--- pcall so a name that vanishes in a future patch costs a silent miss rather than an
--- error on every login.
f:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
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

--- `/mh tips` — the whole thing off or on. `/mh tips button` — keep the chat line,
--- drop the popup. Two switches because they annoy different people: the line is easy
--- to miss, the popup is easy to resent.
function ns.MH_ToggleGrowthTips(which)
	ns.db = ns.db or {}
	if which == "button" then
		if ns.db.growthButton == false then
			ns.db.growthButton = true
			print(Prefix() .. " learned-ability popup on.")
		else
			ns.db.growthButton = false
			print(Prefix() .. " learned-ability popup off — the chat line stays.")
		end
		return
	end
	if ns.db.growthTips == false then
		ns.db.growthTips = true
		print(Prefix() .. " layout tips on: we mention where a newly learned ability goes.")
	else
		ns.db.growthTips = false
		print(Prefix() .. " layout tips off.")
	end
end
