local _, ns = ...

--[[
	ForeverMacros.lua — WoW Forever: "Handy macros", a window with ready macros for every character.
	Rob, 9 Nov 2026: asked for the best macros in Forever per class and race → research (docs/forever/
	FOREVER_MACROS_2026-11-09_A/B/C.md) → "Plan maken voor MH" → plan step 3 → "Gaan we door zolang je kan".

	Each row: a short title, one line on what it does, and a Make button. MH puts the macro in this character's macro
	list ("MH+ <name>"); you drag it to a bar yourself. Nothing is placed or bound for you (players choose).
	Language-safe: spells by id (the client's own name), items as "item:<id>" — never an English name in a /cast or /use.
	The heal, mana and bandage macros use the best item you CARRY; MH rewrites a made one when your bags change, out of
	combat, so it never points at a potion you no longer have. Without any such item it keeps the old text.
	Not measured in Forever: "/use item:<id>" in a macro (modern-client syntax, AFGELEID) — docs/TESTLIJST.md.
	/mh macros opens it; /mh macros check prints what each row would write (a module that can stay quiet needs that).
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local MACRO_PREFIX = "MH+ "
local ICON = "INV_MISC_QUESTIONMARK"
local MAX_LEN = 255 -- GEMETEN: client string MACROFRAME_CHAR_LIMIT "%d/255", Forever 1.60.1.70862

-- Best first. Item ids GEMETEN in wago ItemSparse, Forever 1.60.1.70862 (docs/forever/FOREVER_MACROS_2026-11-09_A.md §4).
-- The three perishable potions (268881-268883) are new in Forever; their order Minor/Lesser/plain is AFGELEID from the ids.
local STONES = { 9421, 5510, 5509, 5511, 5512 }
local POTIONS = { 13446, 3928, 1710, 268883, 929, 268882, 858, 268881, 118 }
local BANDAGES = { 14530, 14529, 8545, 8544, 6451, 6450, 3531, 3530, 2581, 1251 }

-- Active racials: spell id GEMETEN in wago SpellName 70862 (same doc §3); `pre` = lines before the /cast (AFGELEID:
-- stop a cast or swing that would delay or cancel it).
local RACIALS = {
	{ id = 1259718 }, -- Will to Survive (Human)
	{ id = 20600 }, -- Perception (Human)
	{ id = 20594, pre = "/stopcasting" }, -- Stoneform (Dwarf)
	{ id = 20580, pre = "/stopattack\n/stopcasting" }, -- Shadowmeld (Night Elf)
	{ id = 1259799 }, -- Elune's Light (Night Elf)
	{ id = 20589, pre = "/stopcasting" }, -- Escape Artist (Gnome)
	{ id = 1259823 }, -- Eureka! (Gnome)
	{ id = 20572 }, -- Blood Fury (Orc)
	{ id = 1299026, pre = "/stopcasting" }, -- Shatter Curse (Orc)
	{ id = 7744 }, -- Will of the Forsaken (Undead)
	{ id = 20577, pre = "/stopattack" }, -- Cannibalize (Undead)
	{ id = 20549, pre = "/stopcasting" }, -- War Stomp (Tauren)
	{ id = 20554 }, -- Berserking (Troll)
	{ id = 1260270, pre = "/stopattack" }, -- Rapid Regeneration (Troll)
	{ id = 1259416 }, -- Walk on Air (Skyborne)
	{ id = 1259705 }, -- Read Leyline (Skyborne, High Order)
	{ id = 1259686 }, -- Skysight (Skyborne, Windshaper)
}

local function Count(id)
	local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not fn then
		return 0
	end
	local ok, n = pcall(fn, id)
	return (ok and type(n) == "number") and n or 0
end

local function BestCarried(list)
	for _, id in ipairs(list) do
		if Count(id) > 0 then
			return id
		end
	end
	return nil
end

local function KnownSpell(id)
	for _, fn in ipairs({ IsPlayerSpell, IsSpellKnown }) do
		if fn then
			local ok, v = pcall(fn, id)
			if ok and v == true then
				return true
			end
		end
	end
	return false
end

local function SpellName(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" and not (issecretvalue and issecretvalue(n)) then
			return n
		end
	end
	return nil
end

--------------------------------------------------------------------------------
-- The rows. build() returns the macro text, or nil plus a reason key. `auto` = rewritten when the bags change.
--------------------------------------------------------------------------------
local DEFS = {
	{
		key = "heal", name = "Heal", title = "FMAC_HEAL_TITLE", desc = "FMAC_HEAL_DESC", auto = true,
		build = function()
			local stone, potion = BestCarried(STONES), BestCarried(POTIONS)
			if stone and potion then
				return ("#showtooltip\n/use [mod:shift] item:%d; item:%d"):format(potion, stone)
			elseif stone or potion then
				return ("#showtooltip\n/use item:%d"):format(stone or potion)
			end
			return nil, "FMAC_WHY_NO_HEAL"
		end,
	},
	{
		key = "bandage", name = "Bandage", title = "FMAC_BANDAGE_TITLE", desc = "FMAC_BANDAGE_DESC", auto = true,
		build = function()
			local b = BestCarried(BANDAGES)
			if not b then
				return nil, "FMAC_WHY_NO_BANDAGE"
			end
			return ("#showtooltip\n/use [@mouseover,help,nodead][@player] item:%d"):format(b)
		end,
	},
	{
		key = "attack", name = "Attack", title = "FMAC_ATTACK_TITLE", desc = "FMAC_ATTACK_DESC",
		build = function()
			return "/targetenemy [noharm][dead]\n/startattack"
		end,
	},
	{
		key = "focus", name = "Focus", title = "FMAC_FOCUS_TITLE", desc = "FMAC_FOCUS_DESC",
		build = function()
			return "/clearfocus [mod:shift]\n/stopmacro [mod:shift]\n/focus [@mouseover,exists,nodead][]"
		end,
	},
	{
		key = "skull", name = "Skull", title = "FMAC_SKULL_TITLE", desc = "FMAC_SKULL_DESC",
		build = function()
			-- Plain "8", not "!8": the "!" (never toggle off) is documented for modern clients; not measured in Forever.
			return "/tm [@mouseover,exists,nodead][] 8"
		end,
	},
	{
		key = "trinkets", name = "Trinkets", title = "FMAC_TRINKETS_TITLE", desc = "FMAC_TRINKETS_DESC",
		build = function()
			return "/use 13\n/use 14"
		end,
	},
}

--- The rows for this character: the fixed ones plus one per active racial it knows.
local function Rows()
	local rows = {}
	for _, d in ipairs(DEFS) do
		rows[#rows + 1] = d
	end
	for _, r in ipairs(RACIALS) do
		if KnownSpell(r.id) then
			local nm = SpellName(r.id)
			if nm then
				rows[#rows + 1] = {
					key = "racial" .. r.id, name = nm, plainTitle = nm, desc = "FMAC_RACIAL_DESC",
					build = function()
						return "#showtooltip\n" .. (r.pre and (r.pre .. "\n") or "") .. "/cast " .. nm
					end,
				}
			end
		end
	end
	return rows
end

--- Macro names may hold 16 characters (mmonster.co 3 Nov 2026, a claim; the client cuts longer ones, AFGELEID).
local function MacroName(d)
	return (MACRO_PREFIX .. d.name):sub(1, 16)
end

local function Exists(d)
	local idx = GetMacroIndexByName and GetMacroIndexByName(MacroName(d)) or 0
	return (idx and idx > 0) and idx or nil
end

--- Make or rewrite one macro. @return true, or nil plus a reason key.
local function Make(d)
	if InCombatLockdown and InCombatLockdown() then
		return nil, "FMAC_WHY_COMBAT"
	end
	local body, why = d.build()
	if not body then
		return nil, why
	end
	if #body > MAX_LEN then
		return nil, "FMAC_WHY_LONG"
	end
	local name = MacroName(d)
	local idx = Exists(d)
	if idx then
		local _, icon, old = GetMacroInfo(idx)
		if old ~= body then
			pcall(EditMacro, idx, name, icon or ICON, body)
		end
		return true
	end
	local _, perChar = GetNumMacros()
	if (perChar or 0) >= (MAX_CHARACTER_MACROS or 18) then
		return nil, "FMAC_WHY_FULL"
	end
	local ok = pcall(CreateMacro, name, ICON, body, true)
	if not ok then
		return nil, "FMAC_WHY_FAILED"
	end
	return true
end

--- Rewrite the made "auto" macros (bags changed). Never creates one, never erases one when nothing is carried.
local function RefreshAuto()
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	for _, d in ipairs(DEFS) do
		if d.auto and Exists(d) and d.build() then
			Make(d)
		end
	end
end

--------------------------------------------------------------------------------
-- Window (same look as the profession-trainer window; Shift+scroll and Escape via RegisterMidnightDialogPopup)
--------------------------------------------------------------------------------
local W, H, ROW_H = 560, 470, 46
local win, Fill

local function Build()
	if win then
		return win
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverMacros", UIParent, "BackdropTemplate")
	f:SetSize(W, H)
	f:SetPoint("CENTER", 0, 40)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
		tile = true, tileSize = 32, edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
	f:SetBackdropColor(0.05, 0.05, 0.08, 0.97)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 22, -18)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", 22, -44)
	f.sub:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.sub:SetJustifyH("LEFT")
	local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	scroll:SetPoint("TOPLEFT", 20, -78)
	scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 44)
	local child = CreateFrame("Frame", nil, scroll)
	child:SetSize(W - 64, 10)
	scroll:SetScrollChild(child)
	f.scroll, f.child, f.rows = scroll, child, {}
	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOMLEFT", 22, 18)
	f.hint:SetPoint("RIGHT", f, "RIGHT", -24, 0)
	f.hint:SetJustifyH("LEFT")
	f:SetScript("OnShow", function()
		Fill()
	end)
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	win = f
	return f
end

local function Row(f, i)
	local r = f.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, f.child)
	r:SetSize(f.child:GetWidth(), ROW_H)
	r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	r.name:SetPoint("TOPLEFT", 4, -2)
	r.name:SetPoint("RIGHT", r, "RIGHT", -96, 0)
	r.name:SetJustifyH("LEFT")
	r.info = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.info:SetPoint("TOPLEFT", r.name, "BOTTOMLEFT", 0, -2)
	r.info:SetPoint("RIGHT", r, "RIGHT", -96, 0)
	r.info:SetJustifyH("LEFT")
	r.go = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.go:SetSize(88, 22)
	r.go:SetPoint("RIGHT", r, "RIGHT", -2, 0)
	r.go:SetScript("OnClick", function(self)
		local d = self.def
		if not d then
			return
		end
		local ok, why = Make(d)
		if ok then
			print(PREFIX .. ns:L("FMAC_MADE_FMT"):format(MacroName(d)))
			if ShowMacroFrame then
				pcall(ShowMacroFrame) -- open the macro window so you can drag it (AFGELEID that Forever has it)
			end
		else
			print(PREFIX .. ns:L(why or "FMAC_WHY_FAILED"))
		end
		Fill()
	end)
	f.rows[i] = r
	return r
end

Fill = function()
	local f = Build()
	f.title:SetText(ns:L("FMAC_TITLE"))
	f.sub:SetText(ns:L("FMAC_SUB"))
	f.hint:SetText(ns:L("FMAC_HINT"))
	local y = 0
	local rows = Rows()
	for i, d in ipairs(rows) do
		local r = Row(f, i)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", f.child, "TOPLEFT", 0, y)
		r.name:SetText(d.plainTitle or ns:L(d.title))
		local body, why = d.build()
		local info = ns:L(d.desc)
		if not body then
			info = info .. "  |cffff7f7f" .. ns:L(why) .. "|r"
		end
		r.info:SetText(info)
		r.go.def = d
		r.go:SetText(ns:L(Exists(d) and "FMAC_BTN_UPDATE" or "FMAC_BTN_MAKE"))
		if body then
			r.go:Enable()
		else
			r.go:Disable()
		end
		r:Show()
		y = y - ROW_H - 4
	end
	for i = #rows + 1, #f.rows do
		f.rows[i]:Hide()
	end
	f.child:SetHeight(math.max(10, -y))
	return f
end

function ns.ShowForeverMacros()
	local f = Build()
	if f:IsShown() then
		f:Hide()
	else
		f:Show()
	end
end

--- /mh macros [check]
function ns.ForeverMacrosSlash(arg)
	arg = (arg or ""):lower()
	if arg ~= "check" then
		ns.ShowForeverMacros()
		return
	end
	print(PREFIX .. "handy macros: what each row would write now")
	for _, d in ipairs(Rows()) do
		local body, why = d.build()
		print(("  %s [%s]: %s"):format(MacroName(d), Exists(d) and "made" or "not made",
			body and ("%d chars | %s"):format(#body, (body:gsub("\n", " | "))) or ("nothing: " .. tostring(why))))
	end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function()
	RefreshAuto()
	if win and win:IsShown() then
		Fill()
	end
end)
