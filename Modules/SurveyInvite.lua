local _, ns = ...

--[[
	Midnight Helper — survey invitation (1 Oct 2026), third consumer of the nudge framework
	after TranslateNudge and DiscordNudge.

	Rob: "hoe we kunnen gaan vragen wat mensen juist nu leuk vinden aan deze Midnight Helper
	add-on of wat ze vaak gebruiken of wat ze absoluut nooit gebruiken of irriteren". An addon
	cannot send anything anywhere, so the answers come from a short anonymous survey on
	midnighthelper.com/survey/; this module only INVITES. Rob chose "vragenlijst + uitnodiging".

	Two surfaces, both from the framework plus one popup:
	  - a dismissable card on This Week and a permanent Settings row (Nudges.lua), so a player
	    who says "later" can always find the link again;
	  - ONE popup, once per installation, at login, so players who never open the main window
	    are asked too. "Show the link" / "Later" (the card stays) / "No thanks" (card gone).
	    Escape counts as "Later", never as "No thanks". Never in combat or an instance.

	🔴 WHEN: only after the addon has done something for this player -- the milestone gate
	from DiscordNudge.lua, for the reasons written there (an install date is an age heuristic,
	and "old is not the same as helped"). A first version of this file used "installed two days
	ago" and was rewritten before it shipped, after reading that note.

	State: ns.db.surveyInvite = { popupShown = true, done = true }.
	`/mh survey` = the link, always. `/mh survey why` = would the popup show, and why not.
	`/mh survey popup` = the popup as players see it.
]]

local POPUP_KEY = "MIDNIGHTHELPER_SURVEY"

local function State()
	if type(ns.db) ~= "table" then
		return nil
	end
	ns.db.surveyInvite = ns.db.surveyInvite or {}
	return ns.db.surveyInvite
end

--- Same gate as DiscordNudge.lua (see the long note there): a milestone exists only when MH
--- actually celebrated something for this player. O(1), because the card's `when` runs on
--- every Home render.
local function HelpedSomething()
	local m = ns.db and ns.db.milestones
	if not m then
		return false
	end
	local k = next(m)
	if k and tostring(k):sub(1, 1) == "_" then
		k = next(m, k)
	end
	return k ~= nil
end

--- The link in the shared copy dialog. Always works; used by the popup, the card and /mh survey.
function ns.ShowSurveyLink()
	local s = State()
	if s then
		s.done = true
	end
	local url = "https://" .. ns:L("SURVEY_URL")
	print(("|cffe8c36a%s|r — %s %s"):format(ns:L("MAIN_TITLE"), ns:L("SURVEY_COPY_TITLE"), url))
	if ns.ShowShareCopyDialog then
		ns.ShowShareCopyDialog({
			id = "survey",
			text = url,
			titleKey = "SURVEY_COPY_TITLE",
			hintKey = "SURVEY_COPY_HINT",
			closeKey = "DELVE_SHARE_COPY_CLOSE",
			width = 520,
			height = 200,
		})
	end
end

local NUDGE = {
	id = "survey",
	when = function()
		local s = State()
		return HelpedSomething() and not (s and s.done)
	end,
	title = "SURVEY_NUDGE_TITLE",
	body = "SURVEY_NUDGE_BODY",
	actionLabel = "SURVEY_NUDGE_BTN",
	action = function()
		ns.ShowSurveyLink()
		if ns.DismissNudge then
			ns.DismissNudge("survey")
		end
	end,
	settings = true,
}
ns.RegisterNudge(NUDGE)

local function ShowPopup()
	if type(StaticPopupDialogs) ~= "table" or not StaticPopup_Show then
		return
	end
	StaticPopupDialogs[POPUP_KEY] = StaticPopupDialogs[POPUP_KEY] or {}
	local d = StaticPopupDialogs[POPUP_KEY]
	-- Texts refreshed every time so they follow the current language.
	d.text = ns:L("SURVEY_POPUP_TEXT")
	d.button1 = ns:L("SURVEY_SHOW_LINK")
	d.button2 = ns:L("SURVEY_LATER")
	d.button3 = ns:L("SURVEY_NEVER")
	d.OnAccept = function()
		NUDGE.action()
	end
	-- "Later" and Escape: the card on This Week stays, so the link is one click away.
	d.OnCancel = function()
		if ns.PrintChat then
			ns:PrintChat(ns:L("SURVEY_CHAT_LATER"))
		end
	end
	-- "No thanks": the card goes; the Settings row and /mh survey remain.
	d.OnAlt = function()
		if ns.DismissNudge then
			ns.DismissNudge("survey")
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
	if not ns.NudgeActive(NUDGE) then
		if s.done then
			return false, "already opened the link"
		end
		if not HelpedSomething() then
			return false, "no milestone yet (the addon has not helped this player with anything)"
		end
		return false, "card dismissed (No thanks)"
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
	-- Well after the loading screen, the first-run popup and the changelog window.
	if C_Timer and C_Timer.After then
		C_Timer.After(45, function()
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

--- `/mh survey`        the link, always
--- `/mh survey why`    whether the popup would show, and why not
--- `/mh survey popup`  the popup itself, as players see it (does not use up the one time)
function ns.HandleSurveyCommand(arg)
	arg = (arg or ""):lower()
	if arg == "why" then
		local ok, why = Decide()
		local s = State() or {}
		print(("|cffffcc00Midnight Helper|r survey popup: %s (%s). card=%s popupShown=%s done=%s"):format(
			ok and "would show" or "would not show", why, ns.NudgeActive(NUDGE) and "visible" or "hidden",
			tostring(s.popupShown), tostring(s.done)))
	elseif arg == "popup" then
		ShowPopup()
	else
		ns.ShowSurveyLink()
	end
end
