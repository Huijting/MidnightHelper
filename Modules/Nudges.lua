local _, ns = ...

--[[
	Midnight Helper — reusable one-time-nudge framework (Spec 15).

	A "nudge" = a dismissable card shown WHERE THE USER ACTUALLY LOOKS (the This
	Week / Home panel, not the login chat) PLUS a permanent, findable entry in
	Settings. Dismissing hides only the CARD; the Settings entry stays, so a
	"I'll do it later" user can always find it again.

	Generalises the existing onboarding/season dismissable-card pattern.

	Register a nudge:
	  ns.RegisterNudge{
	      id          = "translate",              -- unique, stable (SavedVariables key)
	      when        = function() return ... end, -- REAL condition; card shows only when true
	      title       = "SOME_TITLE_KEY",          -- ns:L key
	      body        = "SOME_BODY_KEY",           -- ns:L key (may contain one %s)
	      bodyArg     = function() return "..." end,-- optional; fills the %s in body
	      actionLabel = "SOME_BTN_KEY",            -- ns:L key for the action button
	      action      = function() ... end,        -- what the button does
	      settings    = true,                       -- also show a permanent Settings row
	  }

	Consumers: HomeDashboard render (cards) + SettingsPage (permanent rows) call
	the ns.* helpers below. DB flag lives in Core.lua DEFAULT_DB.nudgeDismissed.
]]

ns._nudges = ns._nudges or {}       -- [id] = def
ns._nudgeOrder = ns._nudgeOrder or {} -- stable display order (registration order)

function ns.RegisterNudge(def)
	if type(def) ~= "table" or type(def.id) ~= "string" or def.id == "" then return end
	if not ns._nudges[def.id] then
		ns._nudgeOrder[#ns._nudgeOrder + 1] = def.id
	end
	ns._nudges[def.id] = def
end

local function isDismissed(id)
	return ns.db and ns.db.nudgeDismissed and ns.db.nudgeDismissed[id] == true
end

-- Card visible while: condition true AND not dismissed. Never throws.
function ns.NudgeActive(def)
	if not def then return false end
	if isDismissed(def.id) then return false end
	if def.when == nil then return true end
	local ok, res = pcall(def.when)
	return ok and res == true
end

-- Resolved title/body strings (body supports one optional %s via bodyArg).
function ns.NudgeTitle(def)
	return ns:L(def.title)
end

function ns.NudgeBody(def)
	local s = ns:L(def.body)
	if def.bodyArg then
		local ok, a = pcall(def.bodyArg)
		if ok and a ~= nil then
			local ok2, r = pcall(string.format, s, a)
			if ok2 then s = r end
		end
	end
	return s
end

-- Ordered list of nudges whose CARD should show now (for HomeDashboard).
function ns.GetActiveNudges()
	local out = {}
	for _, id in ipairs(ns._nudgeOrder) do
		local def = ns._nudges[id]
		if def and ns.NudgeActive(def) then
			out[#out + 1] = def
		end
	end
	return out
end

-- Ordered list of nudges wanting a PERMANENT Settings row (ignores dismissed).
function ns.GetSettingsNudges()
	local out = {}
	for _, id in ipairs(ns._nudgeOrder) do
		local def = ns._nudges[id]
		if def and def.settings then
			out[#out + 1] = def
		end
	end
	return out
end

-- Dismiss one card. Sets ONLY the per-id flag; the Settings entry stays.
function ns.DismissNudge(id)
	ns.db = ns.db or {}
	ns.db.nudgeDismissed = ns.db.nudgeDismissed or {}
	ns.db.nudgeDismissed[id] = true
	if ns.RefreshHomePanel then ns.RefreshHomePanel() end
end

-- Un-dismiss everything (optional "show dismissed cards again" Settings button).
function ns.ResetNudges()
	ns.db = ns.db or {}
	ns.db.nudgeDismissed = {}
	if ns.RefreshHomePanel then ns.RefreshHomePanel() end
end
