local _, ns = ...

--[[
	Midnight Helper — profession side panel.

	The same answer ns.GetProfessionNextSteps() gives on This Week, shown beside
	Blizzard's own profession window: at the moment the player has their trade skill
	open and is deciding what to do with it.

	Deliberately a SIGNAL, not a second interface. It computes nothing of its own —
	every line comes from the provider, which in turn only reports what the game
	actually exposes (unspent Knowledge and the trainer weekly). Nothing here
	suggests weekly progress that cannot be read; see the header of
	ProfessionNextStep.lua for what was left out and why.

	Frame and addon names confirmed against BlizzMove (Frames.lua:1549/1555), which
	lists ProfessionsFrame under Blizzard_Professions — not assumed from the pattern
	of the other panels. Blizzard_Professions is load-on-demand, hence `addon`.
]]

local function GetProfessionsFrame()
	return _G.ProfessionsFrame
end

local function BuildLines()
	local out = {}
	if type(ns.GetProfessionNextSteps) ~= "function" then
		return out
	end
	local ok, steps = pcall(ns.GetProfessionNextSteps)
	if not ok or type(steps) ~= "table" then
		return out
	end
	for _, st in ipairs(steps) do
		if st and st.text and st.text ~= "" then
			out[#out + 1] = { text = st.text, color = st.color or "soft", onClick = st.onClick }
		end
	end
	-- Nothing waiting is worth saying here: the panel is beside the window you just
	-- opened, so silence would read as "MH has nothing to offer" rather than "you
	-- are done". One calm line, only when we genuinely looked and found nothing.
	if #out == 0 then
		out[#out + 1] = { text = ns:L("PROFNEXT_NONE"), color = "good" }
	end
	-- The craft shopping list (CraftShoppingList.lua, 6 Oct 2026, Cisca's wish): add the recipe you are looking at,
	-- and open the list. Here, because this panel already stands beside the profession window.
	if ns.CraftShopCurrentRecipe then
		local okR, info = pcall(ns.CraftShopCurrentRecipe)
		if okR and info and info.name then
			out[#out + 1] = { text = ns:L("CRAFTSHOP_PANEL_ADD_FMT"):format(info.name), color = "soft",
				onClick = function() if ns.CraftShopAskAdd then ns.CraftShopAskAdd() end end }
		end
		local n = ns.CraftShopCount and ns.CraftShopCount() or 0
		out[#out + 1] = { text = ns:L("CRAFTSHOP_PANEL_OPEN_FMT"):format(n), color = "soft",
			onClick = function() if ns.ShowCraftShoppingList then ns.ShowCraftShoppingList() end end }
	end
	return out
end

local panel = ns.CreateSidePanel({
	name = "MidnightHelperProfessionPanel",
	titleKey = "PROFNEXT_PANEL_TITLE",
	width = 280,
})

local cfg = {
	panel = panel,
	getFrame = GetProfessionsFrame,
	addon = "Blizzard_Professions",
	buildLines = BuildLines,
	-- Spending Knowledge and turning in the weekly both change what belongs here,
	-- and both happen while this window is open.
	events = { "TRAIT_CONFIG_UPDATED", "QUEST_TURNED_IN", "QUEST_ACCEPTED", "SKILL_LINES_CHANGED" },
}
ns.AttachSidePanel(cfg)

--- Redraw on demand: picking another recipe changes the "+ on your shopping list" line (CraftShoppingList.lua).
function ns.RefreshProfessionSidePanel()
	if type(cfg.refresh) == "function" then
		cfg.refresh()
	end
end
