local _, ns = ...

--[[
	ForeverDirection.lua — WoW Forever: "Which way do you want to go?" (the first piece of the "Do this now" design).

	Rob, 12 Nov 2026 (sparring chat, relayed with his words): he picked "De vraag 'Welke kant?'" — "MH vraagt vanaf level 1
	welke richting je wilt, met de drie zinnen per class." Earlier choices, also his: only Forever; asked straight away,
	from level 1 ("Meteen, vanaf level 1"); skipping and changing later are allowed; no choice = everything works as
	before; a switch turns the question off. From PaladinPlan (GPL-3.0) only the idea: no code, tables or texts.

	What this file does, and no more (the sparring chat's limits for this step):
	  - since 13 Nov 2026 (Rob: "Als kaartjes erin") NOT by itself at login: a card in the choice window (NewChoices.lua)
	    with one button per tree; this window opens with /mh direction and from How you play;
	  - three buttons, one per talent tree, with the tree's client name (ForeverMacros.lua SPEC_NAMES, GEMETEN in DB2
	    TalentTab) and one plain sentence (docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md section 1; the sentences are
	    AFGELEID — our own summary for a beginner);
	  - "Later" (ask again next login), "Never ask again" (= the setting off), and a "No choice" button once one is made;
	  - remembers the choice per character (ns.db.foreverDirection[GUID] = 1-3, the tree's band);
	  - /mh direction opens it again, /mh direction check prints the decision and the reason; the How-to-play window has
	    a button with the current choice.
	NOT here (later steps, not built): the "Do this now / All caught up / Coming up" window, "fits your direction" lines
	in tooltips or the upgrade notice, profession advice, costs, "best weapon". Nothing else reads the choice yet;
	ns.GetForeverDirection() is there for those steps.

	The talent-point guess in the question (ns.ForeverSpecBand, counting points per tree) is AFGELEID in ForeverMacros.lua:
	C_Traits on Forever not run in game for that purpose. It is only a hint; the player picks.
]]

if not ns.IS_FOREVER then
	return
end

local PREFIX = "|cffffcc00Midnight Helper:|r "
local GOLD, GREY = "|cffffd100", "|cff9d9d9d"
local CLASSES = { WARRIOR = true, PALADIN = true, HUNTER = true, ROGUE = true, PRIEST = true, SHAMAN = true,
	MAGE = true, WARLOCK = true, DRUID = true }

local function CharKey()
	return (UnitGUID and UnitGUID("player")) or (UnitName and UnitName("player")) or "?"
end

local function ClassToken()
	local _, cls = UnitClass("player")
	return cls
end

local function ClassName(token)
	local names = LOCALIZED_CLASS_NAMES_MALE -- Rob's characters are all male; the sentence only names the class
	return (names and names[token]) or (token and (token:sub(1, 1) .. token:sub(2):lower())) or "?"
end

local function TreeName(cls, band)
	return (ns.ForeverSpecName and ns.ForeverSpecName(cls, band)) or ("#" .. tostring(band))
end

function ns.IsForeverDirectionAskOn()
	return not (ns.db and ns.db.foreverAskDirection == false)
end

function ns.SetForeverDirectionAsk(on)
	if ns.db then
		ns.db.foreverAskDirection = on and true or false
	end
end

--- @return band 1-3 or nil, and the tree's client name.
function ns.GetForeverDirection()
	local all = ns.db and ns.db.foreverDirection
	local band = all and tonumber(all[CharKey()])
	if band and band >= 1 and band <= 3 then
		return band, TreeName(ClassToken(), band)
	end
	return nil
end

local function SetDirection(band)
	if not ns.db then
		return
	end
	ns.db.foreverDirection = ns.db.foreverDirection or {}
	ns.db.foreverDirection[CharKey()] = band
	if ns.ForeverDirectionChanged then
		pcall(ns.ForeverDirectionChanged, band)
	end
end

--------------------------------------------------------------------------------
-- Step 1 + 2 (Rob, 12 Nov 2026, via sparring: "1 en 2, de wapens er meteen bij"): what your direction needs, as a block
-- on top of "How you play", and which weapon kinds fit it in /mh weapons. NOT step 3 (tooltip/upgrade notice).
-- Source: docs/forever/RICHTINGEN_PER_CLASS_2026-11-12.md, table "Nodig" per class. Rules from sparring, kept here:
--   - GEMETEN (Blizzard data) may be said plainly: armor per class (DB2 SkillRaceClassInfo 70888), and "this spell only
--     works with a shield / dagger / ranged weapon" (DB2 SpellEquippedItems 70888).
--   - Weapon advice per direction comes from player guides (Warcraft Tavern, Icy Veins, written for level 60): shown as
--     such, never "best" or "must". Where the research says the guides name no weapon for a direction (all casters,
--     Holy Paladin, Elemental/Restoration Shaman, every Druid, Survival's melee weapon), we say exactly that.
--   - Not measured, so never claimed: whether to switch weapons while levelling. Stats are left out (guides, level 60;
--     that belongs to step 3).
--   - Talent levels ("at the earliest level N") are AFGELEID from "first point at 10, one per level" (research 3c/3d).
-- Names a player sees come from the client: spells by id (C_Spell.GetSpellName), armor/weapon kinds by item subclass
-- (GetItemSubClassInfo), so every language shows its own game words.
--------------------------------------------------------------------------------
local HEADC = "|cffffcc66"

-- itemClass, subClass, English fallback. Armor = class 4, weapon = class 2 (the client's own item tables).
local SUB = {
	cloth = { 4, 1, "Cloth" }, leather = { 4, 2, "Leather" }, mail = { 4, 3, "Mail" }, plate = { 4, 4, "Plate" },
	shield = { 4, 6, "Shields" }, dagger = { 2, 15, "Daggers" }, bow = { 2, 2, "Bows" }, gun = { 2, 3, "Guns" },
	crossbow = { 2, 18, "Crossbows" },
}

local function SubName(k)
	local s = SUB[k]
	if not s then
		return k
	end
	local fn = (C_Item and C_Item.GetItemSubClassInfo) or GetItemSubClassInfo
	if fn then
		local ok, n = pcall(fn, s[1], s[2])
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return s[3]
end

local function SpellNameOf(id)
	if C_Spell and C_Spell.GetSpellName then
		local ok, n = pcall(C_Spell.GetSpellName, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	if GetSpellInfo then
		local ok, n = pcall(GetSpellInfo, id)
		if ok and type(n) == "string" and n ~= "" then
			return n
		end
	end
	return "#" .. id
end

-- Heaviest armor per class, GEMETEN (research 3h: SkillRaceClassInfo skills 293/413/414/415, MinLevel).
local ARMOR = {
	WARRIOR = { { "mail" }, { "plate", 40 } }, PALADIN = { { "mail" }, { "plate", 40 } },
	HUNTER = { { "leather" }, { "mail", 40 } }, SHAMAN = { { "leather" }, { "mail", 40 } },
	ROGUE = { { "leather" } }, DRUID = { { "leather" } },
	PRIEST = { { "cloth" } }, MAGE = { { "cloth" } }, WARLOCK = { { "cloth" } },
}

-- Per direction (band 1-3, SPEC_NAMES order). w = the guides' weapon sentence (nil = the guides name none);
-- fit = ForeverWeapons.lua keys that match it; shield = the guides pair it with a shield.
-- needs = GEMETEN in DB2 SpellEquippedItems: { spell id, what it needs, talent level (AFGELEID) or nil }.
local GUIDE = {
	WARRIOR = {
		{ w = "FDIRB_W_TWOHAND", fit = { mace2 = true, axe2 = true, sword2 = true, polearm = true } },
		-- %s = Dual Wield by spell id 674 (ForeverTrainerData.lua; Warrior learns it at 20 there), so the client names it.
		{ w = "FDIRB_W_DUAL", wSpell = 674, fit = { mace = true, axe = true, sword = true, fist = true, dagger = true } },
		{ w = "FDIRB_W_SHIELD", fit = { mace = true, axe = true, sword = true, fist = true, dagger = true }, shield = true,
			needs = { { 23922, "shield", 40 }, { 2565, "shield" }, { 72, "shield" } } },
	},
	PALADIN = {
		{},
		{ w = "FDIRB_W_SHIELD", fit = { mace = true, axe = true, sword = true }, shield = true,
			needs = { { 20925, "shield", 30 } } },
		{ w = "FDIRB_W_TWOHAND", fit = { mace2 = true, axe2 = true, sword2 = true, polearm = true } },
	},
	HUNTER = {
		{ w = "FDIRB_W_RANGED", fit = { bow = true, crossbow = true, gun = true } },
		{ w = "FDIRB_W_RANGED", fit = { bow = true, crossbow = true, gun = true }, needs = { { 1310687, "ranged", 40 } } },
		{ w = "FDIRB_W_SURVIVAL", fit = { bow = true, crossbow = true, gun = true } },
	},
	ROGUE = {
		{ w = "FDIRB_W_TWODAGGERS", fit = { dagger = true }, needs = { { 399956, "dagger", 40 } } },
		{ w = "FDIRB_W_TWOONEHAND", fit = { mace = true, axe = true, sword = true, fist = true, dagger = true } },
		-- %s = the client's own "Main Hand" (INVTYPE_WEAPONMAINHAND).
		{ w = "FDIRB_W_DAGGERMAIN", wMainHand = true, fit = { dagger = true }, needs = { { 53, "dagger" }, { 8676, "dagger" } } },
	},
	SHAMAN = {
		{},
		{ w = "FDIRB_W_SLOWTWOHAND", fit = { mace2 = true, axe2 = true } },
		{},
	},
	DRUID = { {}, {}, {} }, PRIEST = { {}, {}, {} }, MAGE = { {}, {}, {} }, WARLOCK = { {}, {}, {} },
}

local function NeedName(kind)
	if kind == "ranged" then
		return SubName("bow") .. " / " .. SubName("gun") .. " / " .. SubName("crossbow")
	end
	return SubName(kind)
end

--- The block on top of "How you play", or nil when no direction is chosen.
function ns.ForeverDirectionBlock()
	local band, tree = ns.GetForeverDirection()
	local cls = ClassToken()
	if not (band and cls and GUIDE[cls]) then
		return nil
	end
	local g = GUIDE[cls][band] or {}
	local lines = { HEADC .. ns:L("FDIRB_HEAD_FMT"):format(tree) .. "|r" }
	local parts = {}
	for _, a in ipairs(ARMOR[cls] or {}) do
		parts[#parts + 1] = a[2] and ns:L("FDIRB_FROM_LEVEL_FMT"):format(SubName(a[1]), a[2]) or SubName(a[1])
	end
	lines[#lines + 1] = "- " .. ns:L("FDIRB_ARMOR_FMT"):format(table.concat(parts, ", "))
	if g.w then
		local w = ns:L(g.w)
		if g.wSpell then
			w = w:format(SpellNameOf(g.wSpell))
		elseif g.wMainHand then
			w = w:format(_G.INVTYPE_WEAPONMAINHAND or "Main Hand")
		end
		lines[#lines + 1] = "- " .. ns:L("FDIRB_WEAPON_FMT"):format(w)
	else
		lines[#lines + 1] = "- " .. ns:L("FDIRB_W_NONE")
	end
	for _, n in ipairs(g.needs or {}) do
		local s = ns:L("FDIRB_NEEDS_FMT"):format(SpellNameOf(n[1]), NeedName(n[2]))
		if n[3] then
			s = s .. " " .. ns:L("FDIRB_TALENT_FMT"):format(n[3])
		end
		lines[#lines + 1] = "- " .. s .. "."
	end
	lines[#lines + 1] = "- " .. ns:L("FDIRB_FREE")
	lines[#lines + 1] = GREY .. ns:L("FDIRB_SOURCE") .. "|r"
	return table.concat(lines, "\n")
end

--- For /mh weapons: band, tree name, the fitting weapon keys (or nil when the guides name none), shield yes/no.
function ns.ForeverDirectionWeaponFit()
	local band, tree = ns.GetForeverDirection()
	local cls = ClassToken()
	if not (band and cls and GUIDE[cls]) then
		return nil
	end
	local g = GUIDE[cls][band] or {}
	return band, tree, g.fit, g.shield and SubName("shield") or nil
end

--- A choice changed: the windows that show it redraw (How you play, /mh weapons).
function ns.ForeverDirectionChanged()
	if ns.ForeverHowToPlayRefreshDirection then
		pcall(ns.ForeverHowToPlayRefreshDirection)
	end
	if ns.ForeverWeaponsRefresh then
		pcall(ns.ForeverWeaponsRefresh)
	end
end

local laterThisSession = false

--- Why MH does or does not ask on this character at login (also printed by /mh direction check).
local function Decision()
	if not ns.IsForeverDirectionAskOn() then
		return false, "switched off (Settings, or \"Never ask again\")"
	end
	if not CLASSES[ClassToken() or ""] then
		return false, "no direction texts for this class (" .. tostring(ClassToken()) .. ")"
	end
	local band, name = ns.GetForeverDirection()
	if band then
		return false, ("already chosen on this character: %s"):format(name)
	end
	if laterThisSession then
		return false, "you said \"Later\" this session"
	end
	return true, "no direction chosen yet on this character"
end
ns.ForeverDirectionDecision = Decision -- the offline check calls it

local dialog

local function Refresh()
	local f = dialog
	local cls = ClassToken()
	f.title:SetText(ns:L("FDIR_ASK_TITLE"))
	f.body:SetText(ns:L("FDIR_ASK_BODY_FMT"):format(ClassName(cls)))
	local chosen = ns.GetForeverDirection()
	for band = 1, 3 do
		local b = f.opt[band]
		local mark = (chosen == band) and "|TInterface\\RaidFrame\\ReadyCheck-Ready:14|t " or ""
		b.name:SetText(mark .. GOLD .. TreeName(cls, band) .. "|r")
		b.line:SetText(ns:L(("FDIR_%s_%d"):format(cls or "WARRIOR", band)))
	end
	local guess = ns.ForeverSpecBand and ns.ForeverSpecBand()
	if chosen then
		f.foot:SetText(GREY .. ns:L("FDIR_CHOSEN_FMT"):format(TreeName(cls, chosen)) .. "|r")
	elseif guess then
		f.foot:SetText(GREY .. ns:L("FDIR_GUESS_FMT"):format(TreeName(cls, guess)) .. "|r")
	else
		f.foot:SetText(GREY .. ns:L("FDIR_NO_POINTS") .. "|r")
	end
	f.later:SetText(ns:L("FDIR_LATER"))
	f.never:SetText(ns:L("FDIR_NEVER"))
	f.clear:SetText(ns:L("FDIR_CLEAR"))
	f.clear:SetShown(chosen ~= nil)
end

local function Build()
	if dialog then
		return dialog
	end
	local f = CreateFrame("Frame", "MidnightHelperForeverDirection", UIParent, "BackdropTemplate")
	f:SetSize(500, 330)
	f:SetPoint("CENTER", 0, 80)
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
	f.title:SetPoint("TOP", 0, -20)
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -6, -6)

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOP", 0, -46)
	f.body:SetWidth(450)
	f.body:SetJustifyH("LEFT")

	f.opt = {}
	for band = 1, 3 do
		local b = CreateFrame("Button", nil, f, "BackdropTemplate")
		b:SetSize(450, 52)
		b:SetPoint("TOP", 0, -84 - (band - 1) * 58)
		b:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8x8",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false, edgeSize = 12,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		})
		b:SetBackdropColor(0.12, 0.12, 0.16, 0.9)
		b:SetBackdropBorderColor(0.6, 0.5, 0.2, 0.9)
		b.name = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		b.name:SetPoint("TOPLEFT", 12, -9)
		b.line = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.line:SetPoint("TOPLEFT", 12, -27)
		b.line:SetWidth(426)
		b.line:SetJustifyH("LEFT")
		b:SetScript("OnEnter", function(self)
			self:SetBackdropColor(0.22, 0.2, 0.12, 0.95)
		end)
		b:SetScript("OnLeave", function(self)
			self:SetBackdropColor(0.12, 0.12, 0.16, 0.9)
		end)
		b:SetScript("OnClick", function()
			SetDirection(band)
			print(PREFIX .. ns:L("FDIR_PICKED_CHAT_FMT"):format(TreeName(ClassToken(), band)))
			f:Hide()
		end)
		f.opt[band] = b
	end

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.foot:SetPoint("TOP", 0, -262)
	f.foot:SetWidth(450)

	local function Btn(x, onClick)
		local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		b:SetSize(140, 24)
		b:SetPoint("BOTTOMLEFT", x, 18)
		b:SetScript("OnClick", onClick)
		return b
	end
	f.later = Btn(32, function()
		laterThisSession = true
		print(PREFIX .. ns:L("FDIR_LATER_CHAT"))
		f:Hide()
	end)
	f.clear = Btn(180, function()
		if ns.db and ns.db.foreverDirection then
			ns.db.foreverDirection[CharKey()] = nil
		end
		if ns.ForeverDirectionChanged then
			pcall(ns.ForeverDirectionChanged, nil)
		end
		print(PREFIX .. ns:L("FDIR_CLEARED_CHAT"))
		Refresh()
	end)
	f.never = Btn(328, function()
		ns.SetForeverDirectionAsk(false)
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverAskDirection", false)
		end
		print(PREFIX .. ns:L("FDIR_NEVER_CHAT_FMT"):format(ns:L("SET_FOREVER_DIRECTION_TITLE")))
		f:Hide()
	end)
	f:SetScript("OnHide", function()
		if ns.ForeverHowToPlayRefreshDirection then
			pcall(ns.ForeverHowToPlayRefreshDirection)
		end
		-- The next login question waits ~1.5 s after this (13 Nov 2026, click-through onto the bar layout's Yes).
		if ns.LoginQuestionClosed then
			ns.LoginQuestionClosed()
		end
	end)
	if ns.GuardFreshClicks then
		ns.GuardFreshClicks(f, function(fr)
			return { fr.opt[1], fr.opt[2], fr.opt[3], fr.later, fr.clear, fr.never }
		end)
	end

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	-- Keep the title clear of the "Dock to window" button (13 Nov 2026, same fault as the bar layout question and the
	-- choice window): centred in the space left of the button, wraps if a language makes it long.
	if f._mhDockBtn then
		f.title:ClearAllPoints()
		f.title:SetPoint("TOPLEFT", 20, -20)
		f.title:SetPoint("RIGHT", f._mhDockBtn, "LEFT", -8, 0)
		f.title:SetJustifyH("CENTER")
		f.title:SetWordWrap(true)
	end
	f:Hide()
	dialog = f
	return f
end

-- What the login check did this session (printed by /mh direction check; set further down).
local loginWhy = "not tried yet"

function ns.ShowForeverDirection()
	if not CLASSES[ClassToken() or ""] then
		print(PREFIX .. "direction: no texts for this class.")
		return
	end
	Build()
	Refresh()
	dialog:Show()
end

function ns.ForeverDirectionSlash(arg)
	arg = (arg or ""):lower()
	if arg == "check" or arg == "why" then
		local yes, why = Decision()
		local band, name = ns.GetForeverDirection()
		local guess, pts, gwhy = nil, nil, nil
		if ns.ForeverSpecBand then
			guess, pts, gwhy = ns.ForeverSpecBand()
		end
		print(PREFIX .. ("direction: chosen %s; question at login: %s - %s"):format(
			band and (name .. " (" .. band .. ")") or "none", yes and "would ask" or "no question", why))
		print(PREFIX .. ("direction: this login: %s"):format(loginWhy))
		print(PREFIX .. ("direction: talent points per tree %s; guess %s%s"):format(
			pts and table.concat(pts, "/") or "?", guess and TreeName(ClassToken(), guess) or "none",
			gwhy and (" (" .. gwhy .. ")") or ""))
	elseif arg == "on" then
		ns.SetForeverDirectionAsk(true)
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverAskDirection", true)
		end
		print(PREFIX .. "direction: the question at login is on again.")
	elseif arg == "off" then
		ns.SetForeverDirectionAsk(false)
		if ns.SyncNativeSetting then
			ns.SyncNativeSetting("mh_foreverAskDirection", false)
		end
		print(PREFIX .. "direction: the question at login is off. /mh direction still opens it.")
	else
		ns.ShowForeverDirection()
	end
end

-- At login: never in combat or during a movie, and not on top of a Blizzard popup — wait until those are gone, for
-- about two minutes.
-- 🔴 ONE AT A TIME, THIS ONE FIRST — Rob, 13 Nov 2026, via sparring, verbatim: "Eén voor één". On his new Forever hunter
-- the direction and bar layout questions came at the same moment, then the choice window. Order now: direction → bar
-- layout (ForeverLayoutCarry.lua waits on ns.ForeverDirectionPending) → choice window (NewChoices.lua waits on both).
-- So this one no longer waits for the bar layout question (that would make the two wait on each other).
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
pcall(ev.RegisterEvent, ev, "CINEMATIC_STOP")
pcall(ev.RegisterEvent, ev, "STOP_MOVIE")
local done, waiting, tries = false, false, 0

local function Busy()
	if InCombatLockdown and InCombatLockdown() then
		return "in combat"
	end
	if InCinematic and InCinematic() then
		return "intro movie"
	end
	if StaticPopup1 and StaticPopup1:IsShown() then
		return "a Blizzard popup is open"
	end
	return nil
end

local function Try()
	if done then
		return
	end
	tries = tries + 1
	if InCombatLockdown and InCombatLockdown() then
		waiting = true -- PLAYER_REGEN_ENABLED tries again
		loginWhy = "waiting: in combat"
		return
	end
	local busy = Busy()
	if busy then
		loginWhy = "waiting: " .. busy
		if tries < 40 and C_Timer and C_Timer.After then
			C_Timer.After(3, Try)
		else
			waiting = true
		end
		return
	end
	done = true
	-- 🔴 NOT BY ITSELF ANY MORE — Rob, 13 Nov 2026, via sparring, verbatim: "Als kaartjes erin" (one overview: the
	-- choice window is the first and only window at login; this question is a card in it, NewChoices.lua "direction").
	-- The window still opens with /mh direction and from How you play.
	local yes, why = Decision()
	if yes then
		loginWhy = "not shown by itself: a card in the choice window (/mh new)"
	else
		loginWhy = "no card: " .. tostring(why)
	end
end

--- True while this question is open: the choice window waits (it no longer comes by itself, 13 Nov 2026).
function ns.ForeverDirectionPending()
	return dialog ~= nil and dialog:IsShown() and true or false
end

--- For the choice window's card (NewChoices.lua): does it apply, the card's body, and one button per tree.
function ns.ForeverDirectionCardApplies()
	local yes = Decision()
	return yes and true or false
end

function ns.ForeverDirectionCardBody()
	return ns:L("FDIR_ASK_BODY_FMT"):format(ClassName(ClassToken()))
end

function ns.ForeverDirectionCardButtons()
	local cls = ClassToken()
	local chosen = ns.GetForeverDirection()
	local list = {}
	for band = 1, 3 do
		list[#list + 1] = {
			text = TreeName(cls, band),
			current = (chosen == band),
			tip = ns:L(("FDIR_%s_%d"):format(cls or "WARRIOR", band)),
			-- Visible beside the button (Rob, 13 Nov 2026: "Laat de uitleg zichtbaar bij elke knop"); the tip stays.
			line = ns:L(("FDIR_%s_%d"):format(cls or "WARRIOR", band)),
			click = function()
				SetDirection(band)
				print(PREFIX .. ns:L("FDIR_PICKED_CHAT_FMT"):format(TreeName(cls, band)))
			end,
		}
	end
	return list
end

ev:SetScript("OnEvent", function(_, event)
	if (event == "PLAYER_REGEN_ENABLED" or event == "CINEMATIC_STOP" or event == "STOP_MOVIE") and not waiting then
		return
	end
	waiting = false
	if C_Timer and C_Timer.After then
		C_Timer.After(3, Try) -- first of the login questions (13 Nov 2026: "Eén voor één")
	else
		Try()
	end
end)
