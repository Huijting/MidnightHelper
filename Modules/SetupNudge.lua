local _, ns = ...

--[[
	Midnight Helper — "your bars are not set up yet" nudge.

	Rob asked the question this exists to answer: if he tells Carola tomorrow that the
	addon can lay out her spells for her, where does she go? `/mh setup` is a command she
	will never encounter. A changelog is read by nobody, and the CurseForge description
	is read once, before installing, and never again.

	He had already noticed the same thing about himself an hour earlier: the addon has
	grown past the point where he can find his own features. Searching for "details" and
	"platynator" returned nothing, on pages he built.

	So the addon points at itself, once, where somebody is already standing. Carola opens
	Midnight Helper — she will, it has a window — and the first page says what it can do
	for her. No command to remember, and Rob's instruction becomes "open Midnight
	Helper".

	⚠️ ONLY WHEN IT IS TRUE. The card appears if this character has no MH layout on its
	bars. Somebody who has already run `/mh apply`, or who arranges their own bars, gets
	nothing — an addon that keeps offering to fix what is not broken is the kind this
	project complains about. The condition is measured, not assumed: it asks the layout
	module how many of its keys currently point at a filled slot.

	⚠️ Dismissable, and it stays dismissed. The framework handles that; the Settings row
	keeps it reachable afterwards, so a card someone clicked away is not a feature lost.
]]

--- Does this character look like it has never had the layout applied?
---
--- ⚠️ "No layout" and "cannot tell" are different answers and only one deserves a card.
--- If the schema cannot be read at all — no spec, no key map — this returns false and
--- says nothing, rather than offering to set up bars we know nothing about.
local function NeedsSetup()
	if not (ns.MH_AutoMapSpecAndSlots and GetBindingAction) then
		return false
	end
	local okSpec, spec = pcall(ns.MH_AutoMapSpecAndSlots)
	if not okSpec or type(spec) ~= "table" or type(spec.spellByUiKey) ~= "table" then
		return false
	end

	local wanted, bound = 0, 0
	for bindKey in pairs(spec.spellByUiKey) do
		wanted = wanted + 1
		local wowKey = ns.Keybind_ToWowKey and ns.Keybind_ToWowKey(bindKey) or bindKey
		local okB, command = pcall(GetBindingAction, wowKey)
		if okB and type(command) == "string" and command ~= "" then
			bound = bound + 1
		end
	end
	if wanted == 0 then
		return false
	end

	--- A quarter is the line. Not zero: somebody may have bound a few keys by hand and
	--- still want the rest done. Not most: a player who has arranged their own bars
	--- deliberately should never see this.
	return (bound / wanted) < 0.25
end

ns.RegisterNudge({
	id = "setuplayout",
	when = NeedsSetup,
	title = "SETUPNUDGE_TITLE",
	body = "SETUPNUDGE_BODY",
	actionLabel = "SETUPNUDGE_BTN",
	action = function()
		if ns.MH_ShowLayoutWizard then
			ns.MH_ShowLayoutWizard()
		end
	end,
	settings = true,
})
