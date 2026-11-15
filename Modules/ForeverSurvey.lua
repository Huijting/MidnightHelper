local _, ns = ...

if not ns.IS_FOREVER then return end

--[[
	ForeverSurvey.lua — WoW Forever: invite players to a short survey, once.

	Rob, 15 Nov 2026 (via sparring): "We hebben al een tijdje geen input van onze gebruikers gehad ... we hebben volgens
	mij ook helemaal niets wat de Forever-tab kan aanleveren"; on the six ideas: "Doe ze allemaal maar."
	Measured that day: SurveyInvite.lua and Nudges.lua are NOT in MidnightHelper_Camelot.toc, so Forever players were
	never asked. CurseForge, same day: since 5.0.1 the Forever zips had 94 downloads against 1875 for Midnight.

	Same idea as SurveyInvite.lua (an addon cannot send anything, so this only INVITES to a page on the site), but its
	own link (FSURVEY_URL, a Forever page made by the site chat) and its own state, so a player who answered the
	Midnight survey is still asked about Forever.

	🔴 WHEN: SurveyInvite waits for a milestone ("the addon helped this player"). Forever has no milestones, so the gate
	here is "used MH in Forever on at least 2 different days": not the first evening, when everything is new. Then ONE
	popup per installation, 60 s after login, never in combat or an instance. "Later" and Escape print the command;
	"No thanks" stops the popup for good. `/mh survey` always shows the link.

	State: ns.db.foreverSurvey = { days = { ["2026-11-15"] = true, … }, popupShown = true, done = true }.
	`/mh survey why` = would the popup show, and why not. `/mh survey popup` = the popup as players see it.
]]

local POPUP_KEY = "MIDNIGHTHELPER_FOREVER_SURVEY"
local DAYS_NEEDED = 2

local function State()
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.foreverSurvey = ns.db.foreverSurvey or {}
	local s = ns.db.foreverSurvey
	s.days = s.days or {}
	return s
end

local function DaysSeen(s)
	local n = 0
	for _ in pairs(s.days) do
		n = n + 1
	end
	return n
end

local function NoteToday()
	local s = State()
	if s and date then
		s.days[date("%Y-%m-%d")] = true
		-- Keep the table small: only the count up to the gate matters.
		if DaysSeen(s) > 10 then
			local first = next(s.days)
			s.days[first] = nil
		end
	end
end

--- The link in the shared copy dialog. Always works; used by the popup and /mh survey.
local function ShowLink()
	local s = State()
	if s then
		s.done = true
	end
	local url = "https://" .. ns:L("FSURVEY_URL")
	print(("|cffe8c36a%s|r — %s %s"):format(ns:L("MAIN_TITLE"), ns:L("FSURVEY_COPY_TITLE"), url))
	if ns.ShowShareCopyDialog then
		ns.ShowShareCopyDialog({
			id = "foreversurvey",
			text = url,
			titleKey = "FSURVEY_COPY_TITLE",
			hintKey = "SURVEY_COPY_HINT",
			closeKey = "DELVE_SHARE_COPY_CLOSE",
			width = 520,
			height = 200,
		})
	end
end

local function ShowPopup()
	if type(StaticPopupDialogs) ~= "table" or not StaticPopup_Show then
		return
	end
	StaticPopupDialogs[POPUP_KEY] = StaticPopupDialogs[POPUP_KEY] or {}
	local d = StaticPopupDialogs[POPUP_KEY]
	-- Texts refreshed every time so they follow the current language.
	d.text = ns:L("FSURVEY_POPUP_TEXT")
	d.button1 = ns:L("SURVEY_SHOW_LINK")
	d.button2 = ns:L("SURVEY_LATER")
	d.button3 = ns:L("SURVEY_NEVER")
	d.OnAccept = function()
		ShowLink()
	end
	d.OnCancel = function()
		if ns.PrintChat then
			ns:PrintChat(ns:L("SURVEY_CHAT_LATER"))
		end
	end
	d.OnAlt = function()
		local s = State()
		if s then
			s.declined = true
		end
		if ns.PrintChat then
			ns:PrintChat(ns:L("SURVEY_CHAT_LATER"))
		end
	end
	d.timeout = 0
	d.whileDead = false
	d.hideOnEscape = true
	d.showAlert = false
	d.preferredIndex = 3 -- Blizzard's advice against taint
	StaticPopup_Show(POPUP_KEY)
end

--- Whether the one-time popup would show right now, and why not.
local function Decide()
	local s = State()
	if not s then
		return false, "no saved data yet"
	end
	if s.popupShown then
		return false, "popup already shown once on this installation"
	end
	if s.done then
		return false, "already opened the link"
	end
	if s.declined then
		return false, "said No thanks"
	end
	local n = DaysSeen(s)
	if n < DAYS_NEEDED then
		return false, ("used on %d day(s), the popup waits for %d"):format(n, DAYS_NEEDED)
	end
	if InCombatLockdown and InCombatLockdown() then
		return false, "in combat"
	end
	if IsInInstance and IsInInstance() then
		return false, "inside an instance"
	end
	return true, "all conditions met"
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	if C_Timer and C_Timer.After then
		C_Timer.After(60, function()
			NoteToday()
			if Decide() then
				local s = State()
				if s then
					s.popupShown = true
				end
				ShowPopup()
			end
		end)
	end
end)

--- `/mh survey` (Core.lua routes it here in Forever; SurveyInvite.lua is not loaded there)
---   ""       the link, always
---   "why"    whether the popup would show, and why not
---   "popup"  the popup itself, as players see it (does not use up the one time)
function ns.HandleSurveyCommand(arg)
	arg = (arg or ""):lower()
	if arg == "why" then
		local ok, why = Decide()
		local s = State() or { days = {} }
		print(("|cffffcc00Midnight Helper|r Forever survey popup: %s (%s). days=%d popupShown=%s done=%s declined=%s"):format(
			ok and "would show" or "would not show", why, DaysSeen(s), tostring(s.popupShown), tostring(s.done),
			tostring(s.declined)))
	elseif arg == "popup" then
		ShowPopup()
	else
		ShowLink()
	end
end
