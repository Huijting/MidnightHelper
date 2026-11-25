local _, ns = ...

--[[
	ForeverEnchantCheck.lua — WoW Forever: a Gear check next to the character window: per slot that can carry an
	enchant, the enchant's name or "no enchant" (25 Nov 2026).

	Rob via Sparring 25-11, letterlijk: "ik heb ook enchanting, maar ik zie helemaal niet of ik al iets enchant heb, ja of
	nee, in mijn overzichtje. Kunnen wij dat maken? Kijk even wat ik gebruik en hoe ik het gebruik, zodat het wel goed
	gaat." -> on the proposal (1 the panel, 2 a line under Now / Do this now, 3 "you can make this yourself" for an
	enchanter): "Ja, het gaat om forever. En het is goed zo met 1, 2 en 3." NOT here: which enchant is best.

	MEASURED (wago DB2 Forever 1.60.1.71091, see ForeverEnchantData.lua): Enchanting puts enchants on neck, chest/robe,
	feet, wrist, hands, back, shield, held-in-off-hand items and weapons (no head, shoulder, legs, rings, trinkets, ranged).
	Other permanent enchants (armor kits on legs, arcanums ...) also count since 26 Nov: see SLOTS.
	The enchant on an item is the 2nd field of its link (item:ID:ENCHANT:...). Its name: the client's own name of the
	Enchanting spell that puts it on ("Enchant Bracer - Greater Spirit" -> the part after the last " - "), so every
	language gets its client's word. Since the same evening also armor kits and the like (every ENCHANT_ITEM spell; Rob's
	Druid showed "enchanted" on hands and feet: enchant 15 = spell 2831 "Armor +8, Stamina +1", a Light Armor Kit, MEASURED
	in his SV + DB2). Only an id no spell in this build puts on shows "enchanted".
	Rob plays with CharacterScape (CharacterForever): it keeps CharacterFrame and only post-hooks. This panel is its own
	frame on UIParent, placed to the right of CharacterFrame each time it opens; it never touches CharacterFrame's
	children, scripts or size, and it is not refreshed in combat. Shift+scroll scales it (RegisterMidnightDialogPopup).
	/mh enchant prints every slot and why. Switch: foreverEnchantCheck (Quiet helpers), on.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "

-- slot id -> its letter in FOREVER_ENCH_RECIPES and the client's own word for the slot (GlobalStrings).
-- 26 Nov 2026 (Rob: "Ik mis hier volgens mij mijn [legs], die ik net wel geenchant heb"): the list came from Enchanting
-- only. MEASURED in DB2 Forever 1.60.1.71091 (every ENCHANT_ITEM spell x SpellEquippedItems): legs take 78 permanent
-- enchants (armor kits like 2831 Light Armor Kit, also chest/robe/hands/feet; arcanums), head 52 (arcanums), shoulder
-- 22 (ZG/Naxx/Dawn), waist 3 (tinkers), ranged weapons (scopes). Legs = a normal slot ("no enchant" when empty: a kit
-- is cheap and early). `onlyOn` = shown only when something IS on it: head, shoulder, waist and ranged enchants come late,
-- so "no enchant" there would only be noise for most players (bouwchat's choice, AFGELEID).
local SLOTS = {
	{ id = 1, code = "HD", word = "INVTYPE_HEAD", onlyOn = true },
	{ id = 2, code = "N", word = "INVTYPE_NECK" },
	{ id = 3, code = "SH", word = "INVTYPE_SHOULDER", onlyOn = true },
	{ id = 15, code = "B", word = "INVTYPE_CLOAK" },
	{ id = 5, code = "C", word = "INVTYPE_CHEST" },
	{ id = 9, code = "W", word = "INVTYPE_WRIST" },
	{ id = 10, code = "H", word = "INVTYPE_HAND" },
	{ id = 6, code = "WA", word = "INVTYPE_WAIST", onlyOn = true },
	{ id = 7, code = "L", word = "INVTYPE_LEGS" },
	{ id = 8, code = "F", word = "INVTYPE_FEET" },
	{ id = 16, code = "MH", word = "INVTYPE_WEAPONMAINHAND" },
	{ id = 17, code = "OH", word = "INVTYPE_WEAPONOFFHAND" },
	{ id = 18, code = "R", word = "INVTYPE_RANGED", onlyOn = true },
}

local function On()
	return not (ns.db and ns.db.foreverEnchantCheck == false)
end

local function InFight()
	return InCombatLockdown and InCombatLockdown()
end

local function Readable(v)
	return v ~= nil and not (issecretvalue and issecretvalue(v))
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return nil
end

--- "Enchant Bracer - Greater Spirit" -> "Greater Spirit" (the part after the last " - "); the whole name otherwise.
local function ShortName(spell)
	local n = SpellName(spell)
	if not n then
		return nil
	end
	local tail = n:match(".* %- (.+)$")
	return tail or n
end

--- The enchant's name for an enchant id (the gear tooltip uses it for "you lose the enchant"), or nil.
function ns.ForeverEnchantName(enchantID)
	local spell = ns.FOREVER_ENCH_BY_ID and ns.FOREVER_ENCH_BY_ID[enchantID]
	return spell and ShortName(spell) or nil
end

local function Enchanter()
	local ok, mine = pcall(function()
		return ns.ForeverMyProfessions and ns.ForeverMyProfessions()
	end)
	return ok and type(mine) == "table" and mine.ENCHANTING ~= nil
end

local function KnowsSpell(spell)
	local guid = UnitGUID and UnitGUID("player")
	local t = ns.db and ns.db.foreverKnownRecipes and guid and ns.db.foreverKnownRecipes[guid]
	if type(t) == "table" and t[spell] then
		return true
	end
	for _, fn in ipairs({ IsPlayerSpell or false, IsSpellKnown or false }) do
		if fn then
			local ok, v = pcall(fn, spell)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

--- What sits in the off-hand: "S" shield, "O" held item, "A" a weapon, or nil.
local function OffHandKind(itemID)
	local inst = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not (inst and itemID) then
		return nil
	end
	local ok, _, _, _, loc, _, classID, subID = pcall(inst, itemID)
	if not ok then
		return nil
	end
	if loc == "INVTYPE_SHIELD" then
		return "S", classID, subID
	elseif loc == "INVTYPE_HOLDABLE" then
		return "O", classID, subID
	elseif classID == 2 then
		return "A", classID, subID
	end
	return nil
end

--- Which Enchanting recipes YOU know that fit this slot (for an enchanter only). Names, shortest first.
local function CanMake(slot, itemID)
	if not Enchanter() then
		return nil
	end
	local code, subID = slot.code, nil
	if code == "MH" or code == "OH" then
		local inst = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
		if inst and itemID then
			local ok, _, _, _, loc, _, classID, s = pcall(inst, itemID)
			if ok then
				subID = s
				if code == "OH" then
					code = OffHandKind(itemID)
				elseif classID == 2 then
					code = "A"
				end
				if code == "A" and loc == "INVTYPE_2HWEAPON" then
					code = "AT" -- a two-handed weapon takes both "Enchant Weapon" and "Enchant 2H Weapon"
				end
			end
		end
	end
	local names, seen = {}, {}
	for _, r in ipairs(ns.FOREVER_ENCH_RECIPES or {}) do
		local spell, rc, mask = r[1], r[2], r[3]
		local fits = (rc == code) or (code == "AT" and (rc == "A" or rc == "T"))
		if fits and mask and subID then
			fits = math.floor(mask / 2 ^ subID) % 2 == 1
		end
		if fits and KnowsSpell(spell) then
			local n = ShortName(spell)
			if n and not seen[n] then
				seen[n] = true
				names[#names + 1] = n
			end
		end
	end
	return #names > 0 and names or nil
end

--- Every slot: { slot, word, itemID, enchantID, name, state = "on" | "none" | "empty" | "other", make = {names} }.
local function Read()
	local out = {}
	for _, slot in ipairs(SLOTS) do
		local row = { slot = slot.id, word = _G[slot.word] or slot.word }
		local link = GetInventoryItemLink and GetInventoryItemLink("player", slot.id)
		if not (Readable(link) and type(link) == "string") then
			row.state = "empty"
		else
			row.itemID = tonumber(link:match("item:(%d+)"))
			if slot.code == "OH" and not OffHandKind(row.itemID) then
				row.state = "other" -- an off-hand that takes no enchant
			else
				local e = tonumber(link:match("item:%d+:(%d*)") or "")
				row.enchantID = e
				if e and e > 0 then
					row.state = "on"
					local spell = ns.FOREVER_ENCH_BY_ID and ns.FOREVER_ENCH_BY_ID[e]
					row.name = spell and ShortName(spell) or nil
				elseif slot.onlyOn then
					row.state = "other" -- nothing on a late-enchant slot: not listed, not counted
				else
					row.state = "none"
					row.make = CanMake(slot, row.itemID)
				end
			end
		end
		out[#out + 1] = row
	end
	return out
end

--- How many enchantable slots hold an item without an enchant (for Do this now). 0 when off or unreadable.
function ns.ForeverEnchantMissingCount()
	if not On() then
		return 0
	end
	local n = 0
	local ok, rows = pcall(Read)
	for _, r in ipairs(ok and rows or {}) do
		if r.state == "none" then
			n = n + 1
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- The panel next to the character window
--------------------------------------------------------------------------------
local panel
local ROW_H = 18
local W = 250

local function Build()
	if panel then
		return panel
	end
	panel = CreateFrame("Frame", "MidnightHelperForeverEnchantPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	panel:SetSize(W, 60)
	panel:SetFrameStrata("HIGH")
	if panel.SetBackdrop then
		panel:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		panel:SetBackdropColor(0.05, 0.04, 0.08, 0.92)
		panel:SetBackdropBorderColor(1, 0.8, 0, 0.8)
	end
	panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	panel.title:SetPoint("TOPLEFT", 10, -9)
	panel.title:SetText(ns:L("FENCH_TITLE"))
	panel.lines = {}
	panel:RegisterForDrag("LeftButton")
	panel:SetScript("OnDragStart", function(self)
		if not InFight() then
			self:StartMoving()
		end
	end)
	panel:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(panel)
	end
	panel:Hide()
	return panel
end

local function Line(i)
	local fs = panel.lines[i]
	if not fs then
		fs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		fs:SetJustifyH("LEFT")
		fs:SetWidth(W - 20)
		panel.lines[i] = fs
	end
	return fs
end

local last = "not shown yet"

local function Fill()
	Build()
	local rows = Read()
	local i, y = 0, -28
	for _, r in ipairs(rows) do
		if r.state ~= "empty" and r.state ~= "other" then
			i = i + 1
			local fs = Line(i)
			fs:ClearAllPoints()
			fs:SetPoint("TOPLEFT", 10, y)
			if r.state == "on" then
				fs:SetText(("%s: |cff33ff33%s|r"):format(r.word, r.name or ns:L("FENCH_SOME")))
			else
				fs:SetText(("%s: |cffff5555%s|r"):format(r.word, ns:L("FENCH_NONE")))
			end
			fs:Show()
			y = y - ROW_H
			if r.make then
				i = i + 1
				local m = Line(i)
				m:ClearAllPoints()
				m:SetPoint("TOPLEFT", 18, y)
				local list = table.concat(r.make, ", ", 1, math.min(2, #r.make))
				if #r.make > 2 then
					list = list .. ns:L("FALT_MORE_FMT"):format(#r.make - 2)
				end
				m:SetText("|cff9d9d9d" .. ns:L("FENCH_CAN_FMT"):format(list) .. "|r")
				m:Show()
				y = y - m:GetStringHeight() - 4
			end
		end
	end
	for j = i + 1, #panel.lines do
		panel.lines[j]:Hide()
	end
	if i == 0 then
		local fs = Line(1)
		fs:ClearAllPoints()
		fs:SetPoint("TOPLEFT", 10, y)
		fs:SetText("|cff9d9d9d" .. ns:L("FENCH_NOTHING") .. "|r")
		fs:Show()
		y = y - ROW_H
	end
	panel:SetHeight(-y + 10)
	last = ("%d line(s) at %s"):format(i, date and date("%H:%M:%S") or "?")
end

local function Place()
	Build()
	panel:ClearAllPoints()
	panel:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 4, -20)
end

local function ShowPanel()
	if not On() or InFight() or not CharacterFrame then
		return
	end
	local ok, err = pcall(function()
		Place()
		Fill()
		panel:Show()
	end)
	if not ok then
		last = "error: " .. tostring(err)
	end
end

local function HidePanel()
	if panel then
		panel:Hide()
	end
end

local hooked = false
local function Hook()
	if hooked or not (CharacterFrame and CharacterFrame.HookScript) then
		return
	end
	hooked = true
	CharacterFrame:HookScript("OnShow", ShowPanel)
	CharacterFrame:HookScript("OnHide", HidePanel)
end

-- 26 Nov 2026 (Rob: "kan de [gear] check enchants ook dynamisch updaten? Want nu moest ik hem eerst weer mijn karakter
-- uitdoen en toen weer aandoen"): an enchant or armor kit on a WORN item changes no equipment, so
-- PLAYER_EQUIPMENT_CHANGED alone missed it. UNIT_INVENTORY_CHANGED ("player") fires when a worn item changes, the
-- enchant included (AFGELEID from the classic API: not measured in Forever yet; /mh enchant names the last event that
-- refreshed). The new link can come a moment after the event, so the panel fills now and once more 0.5 s later. In a
-- fight nothing is redrawn; it waits for PLAYER_REGEN_ENABLED.
local pending = false
local lastEvent = "none"
local function Refresh(event)
	if not (panel and panel:IsShown()) then
		return
	end
	if InFight() then
		pending = true
		return
	end
	pending = false
	lastEvent = event
	pcall(Fill)
	if C_Timer and C_Timer.After then
		C_Timer.After(0.5, function()
			if panel and panel:IsShown() and not InFight() then
				pcall(Fill)
			end
		end)
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ev:RegisterEvent("UNIT_INVENTORY_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, unit)
	if event == "PLAYER_LOGIN" then
		Hook()
	elseif event == "UNIT_INVENTORY_CHANGED" then
		if unit == "player" then
			Refresh(event)
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if pending then
			Refresh(event)
		end
	else
		Refresh(event)
	end
end)

--- For the Quiet helpers switch.
function ns.IsForeverEnchantCheckOn()
	return On()
end

function ns.SetForeverEnchantCheck(on)
	ns.db = ns.db or {}
	if on then
		ns.db.foreverEnchantCheck = nil
		if CharacterFrame and CharacterFrame:IsShown() then
			ShowPanel()
		end
	else
		ns.db.foreverEnchantCheck = false
		HidePanel()
	end
end

--- The key that opens the character window, as the game shows it ("C"), or nil when it is unbound.
--- 25 Nov 2026: there used to be a button that called ToggleCharacter("PaperDollFrame"); Rob's BugSack the same day:
--- "TextStatusBar.lua:110: attempt to compare a secret number value (execution tainted by 'MidnightHelper')" — the
--- character window opened from addon code taints the PlayerFrame bars (secret values), even inside a pcall. MH never
--- opens it; the player presses his own key.
function ns.ForeverCharacterKeyText()
	if not GetBindingKey then
		return nil
	end
	local ok, key = pcall(GetBindingKey, "TOGGLECHARACTER0")
	if not (ok and type(key) == "string" and key ~= "") then
		return nil
	end
	if GetBindingText then
		local okT, t = pcall(GetBindingText, key)
		if okT and type(t) == "string" and t ~= "" then
			return t
		end
	end
	return key
end

--- /mh enchant in WoW Forever (Midnight has its own in GearEnchantCheck.lua, which does not load here).
function ns.PrintGearEnchantCheck()
	print(PREFIX .. ("enchant check: %s (Quiet helpers). Enchanting learned: %s. Panel: %s (last live refresh: %s)."):format(
		On() and "on" or "off", tostring(Enchanter()), last, lastEvent))
	local ok, rows = pcall(Read)
	if not ok then
		print("  error: " .. tostring(rows))
		return
	end
	for _, r in ipairs(rows) do
		print(("  slot %d %s: %s%s%s%s"):format(r.slot, tostring(r.word), r.state,
			r.enchantID and r.enchantID > 0 and (" (enchant " .. r.enchantID .. ")") or "",
			r.name and (" " .. r.name) or (r.state == "on" and " (no Enchanting spell for this id: \"enchanted\")" or ""),
			r.make and (" -> you can make: " .. table.concat(r.make, ", ")) or ""))
	end
end
