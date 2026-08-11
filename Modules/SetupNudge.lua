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

	⚠️ ONLY WHEN IT IS TRUE. The card appears when the layout has never been applied on
	this character and spec — measured against our own record of slots we placed, not
	guessed. Somebody who has already run `/mh apply` gets nothing; an addon that keeps
	offering to fix what is not broken is the kind this project complains about.

	⚠️ Dismissable, and it stays dismissed. The framework handles that; the Settings row
	keeps it reachable afterwards, so a card someone clicked away is not a feature lost.
]]

--- Has the layout never been applied on this character and spec?
---
--- ⚠️ COUNTING BOUND KEYS WAS THE WRONG QUESTION, and wrong on exactly the person this
--- card exists for. The first version asked `GetBindingAction` for each of the layout's
--- keys and showed the card when few came back bound. But WoW binds 1 through = to the
--- first action bar on a brand-new character, so Carola — who has never touched a
--- setting — already scores as "mostly bound" and would have seen nothing. The measure
--- said "this player has configured their keys" when it actually meant "Blizzard ships
--- defaults".
---
--- So ask the thing we genuinely know: our own per-character record of slots we placed.
--- Empty means we have never set these bars up. That is also true of somebody who
--- arranged their bars by hand, which is why the card OFFERS rather than warns, and why
--- dismissing it is permanent.
---
--- ⚠️ "Never applied" and "cannot tell" are different answers and only one deserves a
--- card. With no readable spec or an empty spellbook scan — which happens for a moment
--- right after a reload — this says nothing rather than offering to set up a layout it
--- cannot compute.
local function NeedsSetup()
	if not (ns.MH_AutoMapSpecAndSlots and ns.MH_ManagedSlotCount) then
		return false
	end

	local okCount, placed = pcall(ns.MH_ManagedSlotCount)
	if not okCount or (tonumber(placed) or 0) > 0 then
		return false
	end

	local okSpec, spec = pcall(ns.MH_AutoMapSpecAndSlots)
	if not okSpec or type(spec) ~= "table" or type(spec.spellByUiKey) ~= "table" then
		return false
	end
	for _ in pairs(spec.spellByUiKey) do
		return true
	end
	return false
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
