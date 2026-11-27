local _, ns = ...

--[[
	WindowStack.lua — one Midnight Helper window at a time, with Back and Home (both games).
	Rob, 27 Nov 2026, explaining MH to Carola (via Sparring 27-11, dictated): "… al die schermpjes die bouwen op en over
	elkaar heen. Wat ik eigenlijk zou willen is dat we gewoon alleen maar dat schermpje openen. En de andere schermpje
	afsluiten. En eventueel een terugknop … Of een homeknop … Dat we niet 26 schermpjes op een gegeven moment open
	hebben staan." → on the plan: "klopt"; on the choice A/B: "Ik volg uiteraard jouw advies weer." = B.

	B, what this file does:
	  - A PAGE is one of the windows in PAGES below (an allow-list: small helpers — Do this now, the click card, the Move
	    bar, toasts, alerts, login questions, Bags full, the key block — are never in it and never close).
	  - When a page opens, every other open page closes, the main window included (Midnight: MidnightHelperMainUI;
	    Forever: the overview). Exception (Midnight): a page docked to the main window keeps the main window open, and
	    the main window keeps a docked page open — they stand next to each other, not on top of each other.
	  - Each page gets "< Back" (to the page it replaced, when there was one) and "Home" (the main window), on a small
	    strip on top of its upper edge, so they never cover the window's own title or buttons.
	  - Never in combat on a protected frame (a frame with secure children cannot be hidden then); such a window just
	    stays open.
	  - Players choose: Settings "Keep several windows open" (default off) = the old behaviour, nothing closes.
	The windows are picked up when they are registered (ns.RegisterMidnightDialogPopup calls ns.MidnightPageAttach) and by
	a light 2-second sweep for the ones with their own build (boss window, instance map, the main windows).
	/mh windows = what MH knows (pages found, the history, the switch).
]]

local HOME = { retail = "MidnightHelperMainUI", forever = "MidnightHelperForeverOverview" }
local PAGES = {
	-- both games
	"MidnightHelperBossWindow", "MidnightHelperInstanceMap", "MidnightHelperAltBoardWindow", "MidnightHelperChangelogFrame",
	"MidnightHelperCodexAdvicePanel", "MidnightHelperCraftShoppingList", "MidnightHelperCurioAdvicePanel",
	"MidnightHelperDelveItemsPopup", "MidnightHelperDelveCuriosPopup", "MidnightHelperGearLadder",
	"MidnightHelperKeyPressesWindow", "MidnightHelperKeysHub", "MidnightHelperKeysKeyboard", "MidnightHelperMidnightAchList",
	"MidnightHelperMountRun", "MidnightHelperNameplateColors", "MidnightHelperCourseWindow", "MidnightHelperProfGuide",
	"MidnightHelperRaidShoppingList", "MidnightHelperShoppingGuide", "MidnightHelperTimePlan",
	-- Forever
	"MidnightHelperForeverChars", "MidnightHelperForeverClassQuestWindow", "MidnightHelperForeverCrates",
	"MidnightHelperForeverDungeonGuide", "MidnightHelperForeverDungeonQuests", "MidnightHelperForeverDungeons",
	"MidnightHelperForeverEnchantPanel", "MidnightHelperForeverHowToPlay", "MidnightHelperForeverMyLayout",
	"MidnightHelperForeverMacros", "MidnightHelperForeverProfTrainers", "MidnightHelperForeverRanks",
	"MidnightHelperForeverLearnList", "MidnightHelperForeverRestWindow", "MidnightHelperForeverSkillup",
	"MidnightHelperForeverTrainer", "MidnightHelperForeverVendors", "MidnightHelperForeverWeapons",
}
local IS_PAGE = {}
for _, n in ipairs(PAGES) do
	IS_PAGE[n] = true
end

local pages = {}    -- frame -> name, every page (and the main window) MH has hooked
local history = {}  -- the pages a new page replaced, newest last
local current       -- the page shown last
local busy = false  -- MH itself is hiding or showing: the hooks stay out of it
local goingBack = false

local function HomeName()
	return ns.IS_FOREVER and HOME.forever or HOME.retail
end

local function IsHome(f)
	return f and f.GetName and f:GetName() == HomeName()
end

function ns.AreSeveralWindowsKept()
	return ns.db and ns.db.ui and ns.db.ui.keepSeveral == true or false
end

function ns.SetSeveralWindowsKept(on)
	if not ns.db then
		return
	end
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.keepSeveral = on and true or nil
	history = {}
end

local function Docked(f)
	return ns.IsMidnightDialogDocked and ns.IsMidnightDialogDocked(f) or false
end

local function CanHide(f)
	return not (InCombatLockdown and InCombatLockdown() and f.IsProtected and f:IsProtected())
end

local UpdateButtons

local function OnPageShow(self)
	if busy then
		return
	end
	if not ns.AreSeveralWindowsKept() then
		local replaced
		for f in pairs(pages) do
			if f ~= self and f.IsShown and f:IsShown() then
				local keep = (IsHome(f) and Docked(self)) or (IsHome(self) and Docked(f))
				if not keep and CanHide(f) then
					busy = true
					pcall(f.Hide, f)
					busy = false
					if f == current or not replaced then
						replaced = f
					end
				end
			end
		end
		if IsHome(self) then
			history = {}
		elseif replaced and not goingBack then
			history[#history + 1] = replaced
			while #history > 20 do
				table.remove(history, 1)
			end
		end
	end
	goingBack = false
	current = self
	UpdateButtons(self)
end

local function OnPageHide(self)
	if busy then
		return
	end
	-- Closed by the player (cross, Escape): the way back is over.
	if self == current then
		current = nil
		history = {}
	end
end

--- Home: the main window (Midnight: the MH window; Forever: the overview), as /mh opens it.
function ns.MidnightPageHome()
	history = {}
	if ns.IS_FOREVER then
		local o = _G[HOME.forever]
		if not (o and o:IsShown()) and ns.ToggleForeverOverview then
			ns.ToggleForeverOverview()
		end
	elseif ns.ShowMainUI then
		ns:ShowMainUI()
	end
end

--- Back: the page the current one replaced.
function ns.MidnightPageBack()
	local f = table.remove(history)
	while f and not pages[f] do
		f = table.remove(history)
	end
	if not f then
		ns.MidnightPageHome()
		return
	end
	goingBack = true
	if IsHome(f) then
		ns.MidnightPageHome()
	else
		f:Show()
	end
	goingBack = false
end

local function Strip(f)
	if f._mhStackStrip or not f.CreateFontString then
		return f._mhStackStrip
	end
	local s = CreateFrame("Frame", nil, f)
	s:SetSize(160, 22)
	s:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 14, -6)
	s:SetFrameLevel((f:GetFrameLevel() or 1) + 10)
	local function Btn(key, onClick)
		local b = CreateFrame("Button", nil, s, "UIPanelButtonTemplate")
		b:SetHeight(20)
		b:SetScript("OnClick", onClick)
		b._key = key
		return b
	end
	s.back = Btn("WIN_BACK", function()
		ns.MidnightPageBack()
	end)
	s.home = Btn("WIN_HOME", function()
		ns.MidnightPageHome()
	end)
	f._mhStackStrip = s
	return s
end

local function Fit(b)
	b:SetText(ns:L(b._key))
	local fs = b:GetFontString()
	b:SetWidth(math.max(54, math.ceil(((fs and fs:GetStringWidth()) or 40) + 20)))
end

UpdateButtons = function(f)
	if IsHome(f) then
		if f._mhStackStrip then
			f._mhStackStrip:Hide()
		end
		return
	end
	local s = Strip(f)
	if not s then
		return
	end
	Fit(s.back)
	Fit(s.home)
	local hasBack = #history > 0 and not ns.AreSeveralWindowsKept()
	s.back:ClearAllPoints()
	s.home:ClearAllPoints()
	if hasBack then
		s.back:SetPoint("LEFT", s, "LEFT", 0, 0)
		s.home:SetPoint("LEFT", s.back, "RIGHT", 4, 0)
		s.back:Show()
	else
		s.home:SetPoint("LEFT", s, "LEFT", 0, 0)
		s.back:Hide()
	end
	s:Show()
end

--- Hook one window once (a page or the main window). Safe to call for any frame: others are ignored.
function ns.MidnightPageAttach(f)
	local name = f and f.GetName and f:GetName()
	if not name or pages[f] or not (IS_PAGE[name] or name == HomeName()) or not f.HookScript then
		return
	end
	pages[f] = name
	f:HookScript("OnShow", OnPageShow)
	f:HookScript("OnHide", OnPageHide)
	if f:IsShown() then
		OnPageShow(f)
	end
end

local function Sweep()
	for _, n in ipairs(PAGES) do
		local f = _G[n]
		if f and not pages[f] then
			ns.MidnightPageAttach(f)
		end
	end
	local h = _G[HomeName()]
	if h and not pages[h] then
		ns.MidnightPageAttach(h)
	end
end

if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(2, function()
		pcall(Sweep)
	end)
end

--- /mh windows: what MH knows (the module can stay quiet, so it says what it saw).
function ns.WindowStackReport()
	local n, shown = 0, {}
	for f, name in pairs(pages) do
		n = n + 1
		if f:IsShown() then
			shown[#shown + 1] = name
		end
	end
	local back = {}
	for _, f in ipairs(history) do
		back[#back + 1] = pages[f] or "?"
	end
	print(("|cffffcc00Midnight Helper:|r one window at a time: %s; %d window(s) hooked; open: %s; back: %s"):format(
		ns.AreSeveralWindowsKept() and "OFF (several kept)" or "on", n, #shown > 0 and table.concat(shown, ", ") or "none",
		#back > 0 and table.concat(back, " > ") or "none"))
end
ns._WindowStackSweep = Sweep -- for the offline check
