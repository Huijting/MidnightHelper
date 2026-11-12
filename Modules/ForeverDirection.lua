local _, ns = ...

--[[
	ForeverDirection.lua — WoW Forever: "Which way do you want to go?" (the first piece of the "Do this now" design).

	Rob, 12 Nov 2026 (sparring chat, relayed with his words): he picked "De vraag 'Welke kant?'" — "MH vraagt vanaf level 1
	welke richting je wilt, met de drie zinnen per class." Earlier choices, also his: only Forever; asked straight away,
	from level 1 ("Meteen, vanaf level 1"); skipping and changing later are allowed; no choice = everything works as
	before; a switch turns the question off. From PaladinPlan (GPL-3.0) only the idea: no code, tables or texts.

	What this file does, and no more (the sparring chat's limits for this step):
	  - asks once per character, at login, out of combat, after the bar-layout question (ForeverLayoutCarry.lua);
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
	end)

	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	else
		tinsert(UISpecialFrames, f:GetName())
	end
	f:Hide()
	dialog = f
	return f
end

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

-- At login: never in combat or during a movie, and not on top of another MH question (the bar layout on a new
-- character, ForeverLayoutCarry.lua) or a Blizzard popup — wait until those are gone, for about two minutes.
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
pcall(ev.RegisterEvent, ev, "CINEMATIC_STOP")
pcall(ev.RegisterEvent, ev, "STOP_MOVIE")
local done, waiting, tries = false, false, 0

local function Busy()
	if InCombatLockdown and InCombatLockdown() then
		return true
	end
	if InCinematic and InCinematic() then
		return true
	end
	local other = _G.MidnightHelperForeverBarLayout
	if other and other:IsShown() then
		return true
	end
	if StaticPopup1 and StaticPopup1:IsShown() then
		return true
	end
	return false
end

local function Try()
	if done then
		return
	end
	tries = tries + 1
	if InCombatLockdown and InCombatLockdown() then
		waiting = true -- PLAYER_REGEN_ENABLED tries again
		return
	end
	if Busy() then
		if tries < 40 and C_Timer and C_Timer.After then
			C_Timer.After(3, Try)
		else
			waiting = true
		end
		return
	end
	done = true
	if Decision() then
		ns.ShowForeverDirection()
	end
end

ev:SetScript("OnEvent", function(_, event)
	if (event == "PLAYER_REGEN_ENABLED" or event == "CINEMATIC_STOP" or event == "STOP_MOVIE") and not waiting then
		return
	end
	waiting = false
	if C_Timer and C_Timer.After then
		C_Timer.After(6, Try) -- a little after the bar-layout question (3 s), so that one goes first
	else
		Try()
	end
end)
