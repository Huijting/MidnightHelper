local _, ns = ...

--[[
	Midnight Helper — a shopping list for your profession (`/mh craftshop`).

	Cisca via Rob, 6 Oct 2026: "een lijst waarbij ik kan zien wat ik nodig heb voor onder andere alchemie, wat ik
	moet gaan kopen of farmen". Rob chose: its own window, the amount is "times to craft", one list per character.

	How it works:
	  - In the profession window, MH's side panel offers "+ <recipe> on your shopping list". It reads the recipe the
	    player is looking at (ProfessionsFrame.CraftingPage.SchematicForm:GetRecipeInfo(), Blizzard's own Create
	    button reads it the same way) and its reagents (C_TradeSkillUI.GetRecipeSchematic). The reagents are stored
	    WITH the entry, so the list never needs the profession window again.
	  - The window adds up every reagent over all listed recipes and counts what you have the way Blizzard's own
	    crafting UI counts: all quality ranks of a reagent together (the ranks are separate item ids).
	  - Buying reuses the raid shopping list's helpers (ns.MHShop): bank / Warband bank / mail counts, click to search
	    the auction house, shift-click to link, and Auctionator.

	Sources: mh-research 6 Oct 2026, Blizzard UI 12.1.0 (69933): Blizzard_ProfessionsRecipeTracker (have/need over
	all ranks), Blizzard_ProfessionsCrafting (SchematicForm, OnRecipeSelected), ItemUtil.GetCraftingReagentCount.
	v2 (Rob, 6 Oct 2026: "laten we gewoon die punten doen"; research docs/CRAFTSHOP_RESEARCH_2026-10-06.md, measured
	with /mh craftshop probe on Rob's Leatherworking the same day):
	  - Where you get a recipe: C_TradeSkillUI.GetRecipeSourceText, Blizzard's own line. MEASURED: 404 of 417 unlearned
	    recipes have one, and it answers with the profession window closed. Stored with the entry anyway.
	  - Vendor reagents: no API flag exists (research), so a short list of item ids below.
	  - Where to farm: no API either; one sentence per gathered reagent, the same facts ProfessionGuidedData.lua uses.
	  - Reagents you make yourself: while the profession is open we note which item each LEARNED recipe makes
	    (ns.db.craftShop[guid].makes). MEASURED: 530 products readable, window open or closed. "+ Make" puts that recipe
	    on the list, and what it will make counts against the reagent it makes.
	Not yet: which rank to buy (Rob: later; GetCraftingOperationInfo refused our reagent table, see the probe).

	Only Basic, required reagent slots are listed: optional and finishing reagents are a choice, not a need.
]]

local WIDTH = 460
local ROW_H = 30
local ROW_H_NOTE = 36
local CALLER_LIST = "MH craft - "

-- Sold by a profession vendor for gold (research 6 Oct 2026: wago ItemSparse 12.1.0.69933, the item's own description
-- says "vendor"/"purchase"). 244174 Refulgent Copper Rod is the one exception: its description does not say it, Zygor's
-- levelling guide buys it (`buy 30 Refulgent Copper Rod##244174`). Fused Vitality is left out: it costs a currency.
-- The value is the profession whose vendor sells it (from the description / Zygor); "Show the way" prefers the vendor of
-- the recipe's OWN profession and falls back to this one.
local VENDOR = {
	[240991] = 171, [240990] = 171, -- Sunglass Vial (the vendor sells the lower rank)
	[247811] = 171, -- Oil of Heartwood
	[243060] = 164, -- Luminant Flux
	[242641] = 185, [242642] = 185, [242643] = 185, [242644] = 185, -- Cooking Spirits, Thalassian Herbs, Butter, Mana-Wyrm Essence
	[242645] = 185, [242646] = 185, [242647] = 185, -- Vegetable Assortment, Pouch of Spices, Tavern Fixings
	[245881] = 773, [245882] = 773, -- Lexicologist's Vellum, Thalassian Songwater
	[251665] = 197, [251691] = 197, -- Silverleaf Thread, Embroidery Floss
	[253302] = 202, [253303] = 202, -- Malleable Wireframe, Pile of Junk
	[244174] = 333, -- Refulgent Copper Rod (Zygor only, see above)
}

-- Where "Show the way" points: the trainer pins MH already ships (ns.PROF_GUIDES, from the in-game-verified Silvermoon
-- city-guide pins), the profession vendor standing next to each trainer. Cooking has no trainer pin there; the city
-- guide's "Inn & Cooking" pin (UI.lua SMC_CATEGORIES) stands in for it. AFGELEID that the cooking supplies vendor is there.
local CITY_MAP = 2393
local COOKING_PIN = { x = 56.28, y = 70.33 }

local function TrainerPin(skill)
	if skill == 185 then
		return COOKING_PIN.x, COOKING_PIN.y, nil
	end
	local g = ns.PROF_GUIDES and ns.PROF_GUIDES[skill]
	if g and g.trainer and g.trainer.mapID == CITY_MAP then
		return g.trainer.x, g.trainer.y, g.trainerName
	end
	return nil
end

--- Put an arrow on the trainer of `skill` (asVendor: on the vendor next to them). @return boolean
local function RouteToTrainer(skill, asVendor)
	local x, y, who = TrainerPin(skill)
	if not (x and ns.AddSmartTomTomWay) then
		return false
	end
	-- ns:L, not the local L: that one is declared further down this file.
	local label
	if skill == 185 then
		label = ns:L("CRAFTSHOP_ROUTE_COOKING")
	elseif asVendor then
		label = ns:L("CRAFTSHOP_ROUTE_VENDOR_FMT"):format(who or "?")
	else
		label = ns:L("CRAFTSHOP_ROUTE_TRAINER_FMT"):format(who or "?")
	end
	return ns.AddSmartTomTomWay(CITY_MAP, x, y, label) and true or false
end

-- Gathered reagents: item id -> kind. Ids from Zygor's Midnight farming guides (research 6 Oct 2026); the WHERE is the
-- fact ProfessionGuidedData.lua already states and limits ("grows in", never "densest in"; skinning = "start there").
local FARM = {
	[236770] = "herb", [236771] = "herb", -- Sanguithorn
	[236774] = "herb", [236775] = "herb", -- Azeroot
	[236778] = "herb", [236779] = "herb", -- Mana Lily
	[236761] = "herb", [236767] = "herb", -- Tranquility Bloom
	[236776] = "herb", [236777] = "herb", -- Argentleaf
	[236780] = "lotus", -- Nocturnal Lotus ("Found rarely amongst the other herbs of Midnight", its own description)
	[237359] = "ore", [237361] = "ore", -- Refulgent Copper
	[237362] = "ore", [237363] = "ore", -- Umbral Tin
	[237364] = "ore", [237365] = "ore", -- Brilliant Silver
	[238511] = "leather", [238512] = "leather", -- Void-Tempered Leather
	[238513] = "scales", [238514] = "scales", -- Void-Tempered Scales
}
local FARM_SKILL = { herb = 182, lotus = 182, ore = 186, leather = 393, scales = 393 }
local FARM_KEYS = {
	herb = { "CRAFTSHOP_NOTE_HERB", "CRAFTSHOP_TIP_HERB" },
	lotus = { "CRAFTSHOP_NOTE_LOTUS", "CRAFTSHOP_TIP_LOTUS" },
	ore = { "CRAFTSHOP_NOTE_ORE", "CRAFTSHOP_TIP_ORE" },
	leather = { "CRAFTSHOP_NOTE_LEATHER", "CRAFTSHOP_TIP_LEATHER" },
	scales = { "CRAFTSHOP_NOTE_SCALES", "CRAFTSHOP_TIP_SCALES" },
}

local win
local Refresh

local function L(k)
	return ns:L(k)
end

local function Shop()
	return ns.MHShop or {}
end

local function MyGuid()
	local g = UnitGUID and UnitGUID("player")
	return type(g) == "string" and g or nil
end

--- This character's list: { { recipeID, name, icon, times, qmin, qmax, slots = { { ids = {..}, qty = n } } } }
local function MyList()
	local g = MyGuid()
	if not (g and ns.db) then
		return {}
	end
	ns.db.craftShop = ns.db.craftShop or {}
	ns.db.craftShop[g] = ns.db.craftShop[g] or { list = {} }
	return ns.db.craftShop[g].list
end

--- What this character can make: { [productItemID] = { r = recipeID, n = recipe name, q = made per craft } }.
--- Kept apart from the list, so "Clear the list" does not forget it.
local function MyMakes()
	local g = MyGuid()
	if not (g and ns.db) then
		return {}
	end
	ns.db.craftShopMakes = ns.db.craftShopMakes or {}
	ns.db.craftShopMakes[g] = ns.db.craftShopMakes[g] or {}
	return ns.db.craftShopMakes[g]
end

--- Blizzard's source line is several lines with |n; one line reads better in our list.
local function OneLine(s)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	s = s:gsub("|n|n", "  /  "):gsub("|n", ", "):gsub(",%s*$", "")
	return s
end

--- The recipe's profession: base skill line (for the trainer pin) and the name the source line uses
--- ("Profession Trainer: Midnight Leatherworking (40)", MEASURED 6 Oct 2026). @return number|nil, string|nil
local function ProfessionOf(recipeID)
	local T = C_TradeSkillUI
	if not (T and T.GetProfessionInfoByRecipeID and recipeID) then
		return nil
	end
	local ok, pi = pcall(T.GetProfessionInfoByRecipeID, recipeID)
	if not ok or type(pi) ~= "table" then
		return nil
	end
	return pi.parentProfessionID or pi.professionID, pi.professionName
end

--- Which gathering professions this character has (skill line ids), for "you can pick this yourself".
local function MyGatherSkills()
	local have = {}
	if not (GetProfessions and GetProfessionInfo) then
		return have
	end
	local ok, a, b = pcall(GetProfessions)
	if not ok then
		return have
	end
	for _, idx in ipairs({ a, b }) do
		if idx then
			local okI, _, _, _, _, _, _, skillLine = pcall(GetProfessionInfo, idx)
			if okI and skillLine then
				have[skillLine] = true
			end
		end
	end
	return have
end

--------------------------------------------------------------------------------
-- Reading the recipe the player is looking at
--------------------------------------------------------------------------------

local function SchematicForm()
	local pf = _G.ProfessionsFrame
	local page = pf and pf.CraftingPage
	return page and page.SchematicForm or nil
end

--- @return table|nil recipeInfo, number|nil level
function ns.CraftShopCurrentRecipe()
	local pf = _G.ProfessionsFrame
	local sf = SchematicForm()
	if not (pf and pf:IsShown() and sf and sf.GetRecipeInfo) then
		return nil
	end
	local ok, info = pcall(sf.GetRecipeInfo, sf)
	if not ok or type(info) ~= "table" or not info.recipeID then
		return nil
	end
	local level
	if sf.GetCurrentRecipeLevel then
		local okL, lv = pcall(sf.GetCurrentRecipeLevel, sf)
		level = okL and lv or nil
	end
	return info, level
end

--- The reagents of a recipe: Basic, required slots only. @return table|nil entry, string|nil why
local function ReadRecipe(info, level)
	if not (C_TradeSkillUI and C_TradeSkillUI.GetRecipeSchematic) then
		return nil, "GetRecipeSchematic missing"
	end
	local ok, sch = pcall(C_TradeSkillUI.GetRecipeSchematic, info.recipeID, false, level)
	if not ok or type(sch) ~= "table" then
		return nil, "no schematic"
	end
	local basic = Enum and Enum.CraftingReagentType and Enum.CraftingReagentType.Basic
	local slots = {}
	for _, s in ipairs(sch.reagentSlotSchematics or {}) do
		if s.required and (basic == nil or s.reagentType == basic) and (s.quantityRequired or 0) > 0 then
			local ids = {}
			for _, r in ipairs(s.reagents or {}) do
				if type(r.itemID) == "number" then
					ids[#ids + 1] = r.itemID
				end
			end
			if #ids > 0 then -- a currency slot has no item id; it is not bought at the auction house
				slots[#slots + 1] = { ids = ids, qty = s.quantityRequired }
			end
		end
	end
	-- What it makes (all ranks), so a reagent this recipe makes counts as "being made", not "buy".
	local out, seen = {}, {}
	local function put(id)
		if type(id) == "number" and not seen[id] then
			seen[id] = true
			out[#out + 1] = id
		end
	end
	put(sch.outputItemID)
	local okI, ri = pcall(C_TradeSkillUI.GetRecipeInfo, info.recipeID)
	ri = okI and type(ri) == "table" and ri or nil
	for _, q in ipairs(ri and ri.qualityItemIDs or {}) do
		put(q)
	end
	-- Where you get it: Blizzard's own line (MEASURED 6 Oct 2026: also for learned recipes, also with the window shut).
	local source
	if C_TradeSkillUI.GetRecipeSourceText then
		local okS, s = pcall(C_TradeSkillUI.GetRecipeSourceText, info.recipeID)
		source = okS and OneLine(s) or nil
	end
	local learned = info.learned
	if learned == nil and ri then
		learned = ri.learned
	end
	local prof, profName = ProfessionOf(info.recipeID)
	return {
		recipeID = info.recipeID,
		name = info.name or sch.name or ("recipe " .. tostring(info.recipeID)),
		icon = info.icon or sch.icon,
		qmin = sch.quantityMin, qmax = sch.quantityMax,
		slots = slots,
		out = out,
		source = source,
		learned = learned,
		prof = prof,
		profName = profName,
	}
end

local AddEntry

--- Put the recipe on the list `times` times (added to it when it is there already).
function ns.CraftShopAdd(times)
	times = math.floor(tonumber(times) or 0)
	if times < 1 then
		return false
	end
	local info, level = ns.CraftShopCurrentRecipe()
	if not info then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE")))
		return false
	end
	return AddEntry(info, level, times)
end

--- "+ Make" on a reagent row: put the recipe that makes it on the list, without the profession window.
--- GetRecipeSchematic answers with the window shut (MEASURED 6 Oct 2026, /mh craftshop probe).
function ns.CraftShopAddRecipe(recipeID, times, name)
	local info = { recipeID = recipeID, name = name }
	if C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo then
		local ok, ri = pcall(C_TradeSkillUI.GetRecipeInfo, recipeID)
		if ok and type(ri) == "table" then
			info = { recipeID = recipeID, name = ri.name or name, icon = ri.icon, learned = ri.learned }
		end
	end
	return AddEntry(info, nil, times)
end

AddEntry = function(info, level, times)
	times = math.floor(tonumber(times) or 0)
	if times < 1 then
		return false
	end
	local entry, why = ReadRecipe(info, level)
	ns.db = ns.db or {}
	ns.db.craftShopProbe = { recipeID = info.recipeID, level = level, why = why,
		slots = entry and #entry.slots or nil, t = time and time() or 0 }
	if not entry then
		print(("|cffffcc00%s|r %s (%s)"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE"), tostring(why)))
		return false
	end
	-- Measured on Rob's list: a "Knowledge" pseudo-recipe with no reagents at all. Nothing to shop for.
	if #entry.slots == 0 then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NOTHING_TO_BUY"):format(entry.name)))
		return false
	end
	local list = MyList()
	for _, e in ipairs(list) do
		if e.recipeID == entry.recipeID then
			e.times = (e.times or 0) + times
			e.slots = entry.slots -- the recipe may have changed with a patch: the newest read wins
			e.out, e.source, e.learned = entry.out, entry.source, entry.learned
			e.prof, e.profName = entry.prof, entry.profName
			print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_ADDED_FMT"):format(e.times, e.name)))
			if win and win:IsShown() then
				Refresh()
			end
			return true
		end
	end
	entry.times = times
	list[#list + 1] = entry
	print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_ADDED_FMT"):format(times, entry.name)))
	if win and win:IsShown() then
		Refresh()
	end
	return true
end

--- Ask how many times, then add. A StaticPopup with an edit box: nothing protected.
if StaticPopupDialogs then
	StaticPopupDialogs["MH_CRAFTSHOP_ADD"] = {
		text = "%s",
		button1 = OKAY,
		button2 = CANCEL,
		hasEditBox = true,
		OnShow = function(self)
			local eb = self.editBox or self.EditBox
			if eb then
				eb:SetNumeric(true)
				eb:SetText("1")
				eb:HighlightText()
			end
		end,
		OnAccept = function(self)
			local eb = self.editBox or self.EditBox
			ns.CraftShopAdd(eb and eb:GetText())
		end,
		EditBoxOnEnterPressed = function(self)
			ns.CraftShopAdd(self:GetText())
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end

function ns.CraftShopAskAdd()
	local info = ns.CraftShopCurrentRecipe()
	if not info then
		print(("|cffffcc00%s|r %s"):format(L("PRINT_PREFIX"), L("CRAFTSHOP_NO_RECIPE")))
		return
	end
	if StaticPopup_Show then
		StaticPopup_Show("MH_CRAFTSHOP_ADD", L("CRAFTSHOP_ASK_FMT"):format(info.name or "?"))
	end
end

function ns.CraftShopCount()
	return #MyList()
end

--------------------------------------------------------------------------------
-- The window
--------------------------------------------------------------------------------

local function SetStatus(text)
	if win then
		win.statusText = text
		Refresh()
	end
end

local function ShowCopy(name)
	if win then
		win.copyText = name
		Refresh()
		win.copy:SetFocus()
		win.copy:HighlightText()
	end
end

local function OnRowClick(row)
	local S = Shop()
	if not row.itemID then
		return
	end
	if IsModifiedClick and IsModifiedClick("CHATLINK") then
		if S.LinkInChat then
			S.LinkInChat(row.itemID)
		end
		return
	end
	local name = S.ItemName and S.ItemName(row.itemID)
	if not name then
		Refresh()
		return
	end
	if not (S.SearchAuctionHouse and S.SearchAuctionHouse(name)) then
		ShowCopy(name)
	end
end

local function ToAuctionator()
	local S = Shop()
	if not (S.SendTermsToAuctionator and win and win.buyList) then
		return
	end
	local terms = {}
	for _, b in ipairs(win.buyList) do
		local name = S.ItemName and S.ItemName(b.id)
		-- Vendor reagents stay off the auction-house list: the vendor next to the trainer is where they belong.
		if name and not b.vendor and not name:find("[;^\"]") then
			terms[#terms + 1] = { searchString = name, isExact = true, quantity = b.qty }
		end
	end
	local listName = CALLER_LIST .. ((UnitName and UnitName("player")) or "?")
	local result = S.SendTermsToAuctionator(terms, listName)
	if result == "nothing" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_NOTHING"))
	elseif result == "search" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_SEARCH"))
	elseif result == "list" then
		SetStatus(L("RAIDSHOP_AUCTIONATOR_LIST_FMT"):format(listName, #terms))
	else
		SetStatus("|cffff8080" .. L("RAIDSHOP_AUCTIONATOR_FAILED") .. "|r")
	end
end

local function Build()
	local f = CreateFrame("Frame", "MidnightHelperCraftShoppingList", UIParent, "BackdropTemplate")
	f:SetSize(WIDTH, 160)
	f:SetPoint("CENTER", UIParent, "CENTER", 120, 60)
	f:SetFrameStrata("DIALOG")
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if ns.ApplyMidnightDialogBackdrop then
		pcall(ns.ApplyMidnightDialogBackdrop, f)
	end
	tinsert(UISpecialFrames, "MidnightHelperCraftShoppingList")

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.title:SetTextColor(1, 0.82, 0.2)

	f.intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.intro:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -40)
	f.intro:SetWidth(WIDTH - 32)
	f.intro:SetJustifyH("LEFT")
	f.intro:SetWordWrap(true)

	f.recipeLines, f.rows = {}, {}
	f.reagHead = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.reagHead:SetTextColor(1, 0.82, 0.2)
	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetWidth(WIDTH - 32)
	f.foot:SetJustifyH("LEFT")
	f.foot:SetWordWrap(true)

	f.auct = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.auct:SetSize(140, 22)
	f.auct:SetScript("OnClick", ToAuctionator)
	f.clear = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.clear:SetSize(110, 22)
	f.clear:SetScript("OnClick", function()
		local g = MyGuid()
		if g and ns.db and ns.db.craftShop then
			ns.db.craftShop[g] = { list = {} }
		end
		Refresh()
	end)
	f.copyLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.copy = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	f.copy:SetSize(200, 20)
	f.copy:SetAutoFocus(false)
	f.copy:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	f.copy:SetScript("OnTextChanged", function(self, user)
		if user and self.fixed then
			self:SetText(self.fixed)
			self:HighlightText()
		end
	end)
	f.copy:SetScript("OnEditFocusGained", function(self)
		self:HighlightText()
	end)
	f.copyLabel:Hide()
	f.copy:Hide()
	f.status = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.status:SetWidth(WIDTH - 32)
	f.status:SetJustifyH("LEFT")
	f.status:SetWordWrap(true)

	f:SetScript("OnEvent", function()
		if f:IsShown() then
			Refresh()
		end
	end)
	f:RegisterEvent("BAG_UPDATE_DELAYED")
	f:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	f:RegisterEvent("ITEM_DATA_LOAD_RESULT")
	f:Hide()
	return f
end

local function RecipeLine(i)
	local r = win.recipeLines[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, win)
	r:SetSize(WIDTH - 32, 18)
	r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.text:SetPoint("TOPLEFT", r, "TOPLEFT", 0, -2)
	r.text:SetJustifyH("LEFT")
	r.text:SetWordWrap(false)
	-- "You don't know this recipe yet" + Blizzard's own source line, under the recipe.
	r.src = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	r.src:SetPoint("TOPLEFT", r.text, "BOTTOMLEFT", 12, -2)
	r.src:SetWidth(WIDTH - 32 - 36)
	r.src:SetJustifyH("LEFT")
	r.src:SetWordWrap(true)
	r.del = CreateFrame("Button", nil, r, "UIPanelCloseButton")
	r.del:SetSize(20, 20)
	r.del:SetPoint("TOPRIGHT", r, "TOPRIGHT", 0, 0)
	-- "Show the way" for a recipe the trainer sells (the only source MH has a place for).
	r.route = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.route:SetSize(110, 18)
	r.route:SetPoint("RIGHT", r.del, "LEFT", -4, 0)
	r.route:SetScript("OnClick", function(self)
		local skill = self:GetParent().routeSkill
		if skill then
			RouteToTrainer(skill, false)
		end
	end)
	r.route:Hide()
	r.del:SetScript("OnClick", function(self)
		local list = MyList()
		local idx = self:GetParent().index
		if idx and list[idx] then
			table.remove(list, idx)
		end
		Refresh()
	end)
	win.recipeLines[i] = r
	return r
end

local function Row(i)
	local r = win.rows[i]
	if r then
		return r
	end
	r = CreateFrame("Frame", nil, win)
	r:SetSize(WIDTH - 32, ROW_H)
	r.icon = r:CreateTexture(nil, "ARTWORK")
	r.icon:SetSize(24, 24)
	r.icon:SetPoint("LEFT", r, "LEFT", 0, 0)
	r.label = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	r.label:SetWidth(210)
	r.label:SetJustifyH("LEFT")
	r.label:SetWordWrap(false)
	-- One short line under the name: vendor / where to gather / you make this. The long version is in the tooltip.
	r.note = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.note:SetPoint("TOPLEFT", r.label, "BOTTOMLEFT", 0, -1)
	r.note:SetWidth(210)
	r.note:SetJustifyH("LEFT")
	r.note:SetWordWrap(false)
	r.make = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
	r.make:SetSize(96, 20)
	r.make:SetPoint("RIGHT", r, "RIGHT", 0, 0)
	-- One button, two jobs: "+ Make" (a recipe you know makes this) or "Vendor N" (click = arrow to the vendor).
	r.make:SetScript("OnClick", function(self)
		local row = self:GetParent()
		if row.makeRecipe and ns.CraftShopAddRecipe then
			ns.CraftShopAddRecipe(row.makeRecipe, row.makeTimes or 1, row.makeName)
		elseif row.routeSkill then
			RouteToTrainer(row.routeSkill, true)
		end
	end)
	r.make:SetScript("OnEnter", function(self)
		local row = self:GetParent()
		if GameTooltip and row.routeSkill and not row.makeRecipe then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L("CRAFTSHOP_ROUTE_TIP"), 1, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	r.make:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	r.make:Hide()
	r.count = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.count:SetJustifyH("RIGHT")
	r.where = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	r.where:SetPoint("TOPRIGHT", r.count, "BOTTOMRIGHT", 0, -1)
	r.where:SetJustifyH("RIGHT")
	r.status = r:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	r.status:SetPoint("RIGHT", r, "RIGHT", 0, 0)
	r.status:SetWidth(104)
	r.status:SetJustifyH("RIGHT")
	r:EnableMouse(true)
	r:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then
			OnRowClick(self)
		end
	end)
	r:SetScript("OnEnter", function(self)
		if self.itemID and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetItemByID, GameTooltip, self.itemID)
			if self.tip then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(self.tip, 0.4, 0.85, 1, true)
			end
			GameTooltip:Show()
		end
	end)
	r:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	win.rows[i] = r
	return r
end

--- All reagents over all listed recipes, one row per reagent (keyed by its first item id, ranks together).
local function Totals(list)
	local byKey, order = {}, {}
	for _, e in ipairs(list) do
		for _, s in ipairs(e.slots or {}) do
			local key = s.ids[1]
			local t = byKey[key]
			if not t then
				t = { ids = s.ids, need = 0, users = {} }
				byKey[key] = t
				order[#order + 1] = t
			end
			t.need = t.need + (s.qty or 0) * (e.times or 1)
			if t.users[#t.users] ~= e then
				t.users[#t.users + 1] = e -- the recipes that need it (for which profession's vendor to point at)
			end
		end
	end
	return order
end

--- How many of this reagent the recipes on the list will MAKE (their lowest yield, so we never promise too many).
local function Planned(t, list)
	local ids = {}
	for _, x in ipairs(t.ids) do
		ids[x] = true
	end
	local n = 0
	for _, e in ipairs(list) do
		for _, o in ipairs(e.out or {}) do
			if ids[o] then
				n = n + (e.qmin or 1) * (e.times or 1)
				break
			end
		end
	end
	return n
end

local function HaveInBags(ids)
	local n = 0
	for _, id in ipairs(ids) do
		local ok, c = pcall(C_Item.GetItemCount, id)
		if ok and type(c) == "number" then
			n = n + c
		end
	end
	return n
end

Refresh = function()
	if not win then
		return
	end
	local S = Shop()
	local list = MyList()
	win.title:SetText(L("CRAFTSHOP_TITLE"))
	win.intro:SetText(#list == 0 and L("CRAFTSHOP_EMPTY") or L("CRAFTSHOP_INTRO"))
	local y = -40 - win.intro:GetStringHeight() - 8

	for i, e in ipairs(list) do
		local r = RecipeLine(i)
		r.index = i
		local yield = ""
		if e.qmin and e.qmax and e.qmax > 1 then
			local lo, hi = e.qmin * e.times, e.qmax * e.times
			yield = "  |cff9aa0a8" .. L("CRAFTSHOP_YIELD_FMT"):format(lo == hi and tostring(lo) or (lo .. "-" .. hi)) .. "|r"
		end
		r.text:SetText(("%d× %s%s"):format(e.times or 1, e.name or "?", yield))
		-- Learned now? Ask again (a recipe learned since it was added should lose its red line); fall back to the stored
		-- answer when the client does not know this profession right now.
		local learned = e.learned
		if C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo then
			local ok, ri = pcall(C_TradeSkillUI.GetRecipeInfo, e.recipeID)
			if ok and type(ri) == "table" and ri.learned ~= nil then
				learned = ri.learned
				e.learned = learned
			end
		end
		-- Entries added before v2 never stored a source: ask now, once.
		if learned == false and not e.source and C_TradeSkillUI and C_TradeSkillUI.GetRecipeSourceText then
			local okS, s = pcall(C_TradeSkillUI.GetRecipeSourceText, e.recipeID)
			e.source = okS and OneLine(s) or nil
		end
		if not e.prof then
			e.prof, e.profName = ProfessionOf(e.recipeID)
		end
		-- A trainer recipe: Blizzard's line names the profession ("Profession Trainer: Midnight Leatherworking (40)"),
		-- in the player's own language. That name is the test, not the English word "Trainer". AFGELEID for non-English.
		r.routeSkill = nil
		if learned == false and e.source and e.profName and e.profName ~= ""
			and e.source:find(e.profName, 1, true) and TrainerPin(e.prof) then
			r.routeSkill = e.prof
		end
		local h = 20
		if learned == false then
			r.src:SetText("|cffff8080" .. L("CRAFTSHOP_UNLEARNED") .. "|r " .. (e.source or L("CRAFTSHOP_SOURCE_UNKNOWN")))
			r.src:Show()
			h = 20 + r.src:GetStringHeight() + 4
		else
			r.src:Hide()
		end
		if r.routeSkill then
			r.route:SetText(L("CRAFTSHOP_BTN_ROUTE"))
			r.route:Show()
		else
			r.route:Hide()
		end
		r.text:SetWidth(r.routeSkill and (WIDTH - 32 - 24 - 118) or (WIDTH - 32 - 24))
		r:SetHeight(h)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r:Show()
		y = y - h
	end
	for i = #list + 1, #win.recipeLines do
		win.recipeLines[i]:Hide()
	end

	local totals = Totals(list)
	win.buyList = {}
	if #totals > 0 then
		win.reagHead:SetText(L("CRAFTSHOP_REAGENTS"))
		win.reagHead:ClearAllPoints()
		win.reagHead:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
		win.reagHead:Show()
		y = y - 6 - win.reagHead:GetStringHeight() - 4
	else
		win.reagHead:Hide()
	end
	local makes = MyMakes()
	local gather = MyGatherSkills()
	for i, t in ipairs(totals) do
		local have = HaveInBags(t.ids)
		local inMail = S.MailCount and S.MailCount(t.ids) or 0
		local inBank = S.BankCount and S.BankCount(t.ids) or 0
		local planned = Planned(t, list)
		local toBuy = math.max(0, t.need - have - inMail - inBank - planned)
		local id = t.ids[1]
		local vendorSkill, farm, make = nil, nil, nil
		for _, x in ipairs(t.ids) do
			vendorSkill = vendorSkill or VENDOR[x]
			farm = farm or FARM[x]
			make = make or makes[x]
		end
		local vendor = vendorSkill ~= nil
		-- Which vendor: the one of the profession that needs it, when that one has a pin; else the item's own.
		if vendor then
			for _, e in ipairs(t.users or {}) do
				if e.prof and TrainerPin(e.prof) then
					vendorSkill = e.prof
					break
				end
			end
		end
		if toBuy > 0 then
			win.buyList[#win.buyList + 1] = { id = id, qty = toBuy, vendor = vendor }
		end
		local r = Row(i)
		r.itemID = id
		r.icon:SetTexture(S.ItemIcon and S.ItemIcon(id) or 134400)
		r.label:SetText((S.ItemName and S.ItemName(id)) or "…")
		r.count:SetText(("%d / %d"):format(have, t.need))

		-- The short line under the name, and the longer explanation for the tooltip.
		local note, tip
		if make then
			note = L("CRAFTSHOP_NOTE_MAKE_FMT"):format(make.n or "?")
			tip = L("CRAFTSHOP_TIP_MAKE")
		end
		if vendor then
			note = note or L("CRAFTSHOP_NOTE_VENDOR")
			tip = (tip and (tip .. "\n\n") or "") .. L("CRAFTSHOP_TIP_VENDOR")
		end
		if farm and not note then
			local keys = FARM_KEYS[farm]
			note, tip = L(keys[1]), L(keys[2])
			if gather[FARM_SKILL[farm]] then
				note = "|cff80ff80" .. note .. "|r"
				tip = tip .. "\n\n" .. L("CRAFTSHOP_TIP_YOU_GATHER")
			end
		end
		r.tip = tip
		r.note:SetText(note or "")
		r.label:ClearAllPoints()
		if note then
			r.label:SetPoint("BOTTOMLEFT", r.icon, "RIGHT", 8, 1)
			r.note:Show()
		else
			r.label:SetPoint("LEFT", r.icon, "RIGHT", 8, 0)
			r.note:Hide()
		end

		r.make:Hide()
		r.status:Show()
		r.makeRecipe, r.routeSkill = nil, nil
		if have >= t.need then
			r.status:SetText("|cff40ff40" .. L("RAIDSHOP_ENOUGH") .. "|r")
		elseif toBuy == 0 and planned > 0 and have + inMail + inBank < t.need then
			r.status:SetText("|cff66ccff" .. L("CRAFTSHOP_MAKING") .. "|r")
		elseif toBuy == 0 then
			r.status:SetText("|cffffd100" .. L("RAIDSHOP_PICKUP") .. "|r")
		elseif make then
			-- You know the recipe: offer to put it on the list, as many times as covers what is missing.
			r.makeRecipe, r.makeName = make.r, make.n
			r.makeTimes = math.ceil(toBuy / math.max(1, make.q or 1))
			r.make:SetText(L("CRAFTSHOP_BTN_MAKE_FMT"):format(r.makeTimes))
			r.make:Show()
			r.status:Hide()
		elseif vendor and TrainerPin(vendorSkill) then
			-- "Vendor N" as a button: click = an arrow to the vendor next to the trainer.
			r.routeSkill = vendorSkill
			r.make:SetText(L("CRAFTSHOP_VENDOR_FMT"):format(toBuy))
			r.make:Show()
			r.status:Hide()
		elseif vendor then
			r.status:SetText("|cffffd100" .. L("CRAFTSHOP_VENDOR_FMT"):format(toBuy) .. "|r")
		else
			r.status:SetText("|cffff5555" .. L("RAIDSHOP_BUY_FMT"):format(toBuy) .. "|r")
		end
		local where = {}
		if inMail > 0 then
			where[#where + 1] = L("RAIDSHOP_IN_MAIL_FMT"):format(inMail)
		end
		if inBank > 0 then
			where[#where + 1] = L("RAIDSHOP_IN_BANK_FMT"):format(inBank)
		end
		r.where:SetText(table.concat(where, ", "))
		r.count:ClearAllPoints()
		r.count:SetPoint("RIGHT", r, "RIGHT", -110, #where > 0 and 6 or 0)
		local h = note and ROW_H_NOTE or ROW_H
		r:SetHeight(h)
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y)
		r:Show()
		y = y - h
	end
	for i = #totals + 1, #win.rows do
		win.rows[i]:Hide()
	end

	win.foot:SetText(L("CRAFTSHOP_FOOT") .. " " .. L("RAIDSHOP_CLICK_HINT"))
	win.foot:ClearAllPoints()
	win.foot:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 6)
	y = y - 6 - win.foot:GetStringHeight() - 8

	local x = 16
	if S.HasAuctionator and S.HasAuctionator() and #totals > 0 then
		win.auct:SetText(L("RAIDSHOP_BTN_AUCTIONATOR"))
		win.auct:ClearAllPoints()
		win.auct:SetPoint("TOPLEFT", win, "TOPLEFT", x, y)
		win.auct:Show()
		x = x + 150
	else
		win.auct:Hide()
	end
	if #list > 0 then
		win.clear:SetText(L("CRAFTSHOP_CLEAR"))
		win.clear:ClearAllPoints()
		win.clear:SetPoint("TOPRIGHT", win, "TOPRIGHT", -16, y)
		win.clear:Show()
	else
		win.clear:Hide()
	end
	local barH = (win.auct:IsShown() or win.clear:IsShown()) and 26 or 0
	y = y - barH
	if win.copyText then
		win.copyLabel:SetText(L("RAIDSHOP_COPY_LABEL"))
		win.copyLabel:ClearAllPoints()
		win.copyLabel:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 5)
		win.copyLabel:Show()
		win.copy:ClearAllPoints()
		win.copy:SetPoint("LEFT", win.copyLabel, "RIGHT", 10, 0)
		win.copy:SetWidth(math.max(80, WIDTH - 60 - win.copyLabel:GetStringWidth()))
		win.copy.fixed = win.copyText
		win.copy:SetText(win.copyText)
		win.copy:Show()
		y = y - 26
	else
		win.copyLabel:Hide()
		win.copy:Hide()
	end
	if win.statusText then
		win.status:SetText(win.statusText)
		win.status:ClearAllPoints()
		win.status:SetPoint("TOPLEFT", win, "TOPLEFT", 16, y - 4)
		win.status:Show()
		y = y - 4 - win.status:GetStringHeight()
	else
		win.status:Hide()
	end
	win:SetHeight(-y + 14)
end

--- `/mh craftshop`: open (or close) the list.
function ns.ShowCraftShoppingList()
	win = win or Build()
	if win:IsShown() then
		win:Hide()
		return
	end
	win.copyText, win.statusText = nil, nil
	Refresh()
	win:Show()
end

--- `/mh craftshop why`: what MH sees right now (CLAUDE.md: a feature that can stay silent needs a way to see why).
function ns.CraftShopWhy()
	local p = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local pf = _G.ProfessionsFrame
	print(("%s craftshop: profession window %s"):format(p, (pf and pf:IsShown()) and "open" or "closed"))
	local info, level = ns.CraftShopCurrentRecipe()
	if info then
		local entry, why = ReadRecipe(info, level)
		print(("   recipe %s (%s), level %s: %s"):format(tostring(info.recipeID), tostring(info.name), tostring(level),
			entry and (#entry.slots .. " basic reagent slot(s)") or ("NOT read: " .. tostring(why))))
		for _, s in ipairs(entry and entry.slots or {}) do
			print(("     %d× item %s (%d rank id(s))"):format(s.qty, tostring(s.ids[1]), #s.ids))
		end
	else
		print("   no recipe selected (open your profession and click a recipe)")
	end
	print(("   your list: %d recipe(s)"):format(#MyList()))
	local nMakes = 0
	for _ in pairs(MyMakes()) do
		nMakes = nMakes + 1
	end
	print(("   items you can make (noted when a profession opens): %d"):format(nMakes))
end

--- `/mh craftshop probe`: ONE measurement before v2 is built (docs/CRAFTSHOP_RESEARCH_2026-10-06.md, "eerst te meten").
--- Questions: which C_TradeSkillUI names exist on this build; does every recipe say where it comes from
--- (GetRecipeSourceText); can we map "item -> the recipe that makes it" (outputItemID / qualityItemIDs); does any of it
--- answer with the profession window CLOSED; and does GetCraftingOperationInfo accept reagents you do not own.
--- Run it twice, window open and window closed: each run gets its own slot, so one /reload writes both.
function ns.CraftShopMeasure()
	local p = ("|cffffcc00%s|r"):format(L("PRINT_PREFIX"))
	local T = C_TradeSkillUI
	if not T then
		print(p .. " craftshop probe: C_TradeSkillUI is missing.")
		return
	end
	local function call(fn, ...)
		if type(T[fn]) ~= "function" then
			return nil, "absent"
		end
		local ok, a = pcall(T[fn], ...)
		if not ok then
			return nil, "error: " .. tostring(a)
		end
		return a
	end
	local pf = _G.ProfessionsFrame
	local open = (pf and pf:IsShown()) and true or false
	local m = { when = date and date("%Y-%m-%d %H:%M") or nil, windowOpen = open }

	-- 1. Every function name on this build. Positive control: GetRecipeSchematic, which this module already uses.
	local names = {}
	for k, v in pairs(T) do
		if type(v) == "function" then
			names[#names + 1] = tostring(k)
		end
	end
	table.sort(names)
	m.api, m.apiCount = names, #names
	m.control = type(T.GetRecipeSchematic) == "function"
	m.ready = tostring(call("IsTradeSkillReady"))
	local prof = call("GetBaseProfessionInfo")
	if type(prof) == "table" then
		m.profession = tostring(prof.professionName) .. " / " .. tostring(prof.professionID)
	end

	-- 2. All recipes: who makes what (intermediates) and who says where they come from (recipe source).
	local ids, idsWhy = call("GetAllRecipeIDs")
	local products = {}
	local c = { total = 0, withOutput = 0, withQualityItems = 0, learned = 0, unlearned = 0, unlearnedWithSource = 0,
		learnedWithNextRank = 0, nextRankWithSource = 0 }
	local samples, sourceTypes = {}, {}
	if type(ids) == "table" then
		for _, id in ipairs(ids) do
			c.total = c.total + 1
			local info = call("GetRecipeInfo", id)
			local sch = call("GetRecipeSchematic", id, false)
			if type(sch) == "table" and sch.outputItemID then
				c.withOutput = c.withOutput + 1
				products[sch.outputItemID] = products[sch.outputItemID] or id
			end
			if type(info) == "table" then
				if type(info.qualityItemIDs) == "table" and #info.qualityItemIDs > 0 then
					c.withQualityItems = c.withQualityItems + 1
					for _, q in ipairs(info.qualityItemIDs) do
						products[q] = products[q] or id
					end
				end
				if info.learned then
					c.learned = c.learned + 1
					if info.nextRecipeID then
						c.learnedWithNextRank = c.learnedWithNextRank + 1
						local s = call("GetRecipeSourceText", info.nextRecipeID)
						if type(s) == "string" and s ~= "" then
							c.nextRankWithSource = c.nextRankWithSource + 1
						end
					end
				else
					c.unlearned = c.unlearned + 1
					local st = tostring(info.sourceType)
					sourceTypes[st] = (sourceTypes[st] or 0) + 1
					local s = call("GetRecipeSourceText", id)
					if type(s) == "string" and s ~= "" then
						c.unlearnedWithSource = c.unlearnedWithSource + 1
						if #samples < 8 then
							samples[#samples + 1] = { id = id, name = info.name, sourceType = info.sourceType, text = s }
						end
					end
				end
			end
		end
	end
	local nProducts = 0
	for _ in pairs(products) do
		nProducts = nProducts + 1
	end
	m.recipes = c
	m.recipesWhy = idsWhy
	m.productItems = nProducts
	m.sourceTypes = sourceTypes
	m.sourceSamples = samples

	-- 3. The recipes on your list, one by one: does each call answer (also with the window closed)?
	local basic = Enum and Enum.CraftingReagentType and Enum.CraftingReagentType.Basic
	local function reagentsAt(sch, last)
		local flat, nested = {}, {}
		for _, s in ipairs(sch.reagentSlotSchematics or {}) do
			if s.required and (basic == nil or s.reagentType == basic) and s.reagents and #s.reagents > 0 then
				local r = s.reagents[last and #s.reagents or 1]
				if r and r.itemID then
					flat[#flat + 1] = { itemID = r.itemID, dataSlotIndex = s.dataSlotIndex, quantity = s.quantityRequired }
					nested[#nested + 1] = { reagent = { itemID = r.itemID }, dataSlotIndex = s.dataSlotIndex,
						quantity = s.quantityRequired }
				end
			end
		end
		return flat, nested
	end
	local function quality(recipeID, reagents)
		local op, why = call("GetCraftingOperationInfo", recipeID, reagents, nil, false)
		if type(op) ~= "table" then
			return tostring(why or op)
		end
		return ("quality %s, skill %s+%s, difficulty %s+%s, concentration %s"):format(tostring(op.craftingQuality),
			tostring(op.baseSkill), tostring(op.bonusSkill), tostring(op.baseDifficulty), tostring(op.bonusDifficulty),
			tostring(op.concentrationCost))
	end
	m.list = {}
	for i, e in ipairs(MyList()) do
		if i > 8 then
			break
		end
		local r = { recipeID = e.recipeID, name = e.name }
		local info, w1 = call("GetRecipeInfo", e.recipeID)
		r.info = type(info) == "table" and ("learned=%s next=%s sourceType=%s"):format(tostring(info.learned),
			tostring(info.nextRecipeID), tostring(info.sourceType)) or tostring(w1 or info)
		local s, w3 = call("GetRecipeSourceText", e.recipeID)
		r.sourceText = s or w3 or "nil"
		local sch, w2 = call("GetRecipeSchematic", e.recipeID, false)
		if type(sch) == "table" then
			r.schematic = ("ok: output %s, %d slot(s)"):format(tostring(sch.outputItemID), #(sch.reagentSlotSchematics or {}))
			local f1, n1 = reagentsAt(sch, false)
			local f2, n2 = reagentsAt(sch, true)
			r.qualityNone = quality(e.recipeID, {})
			r.qualityLowFlat, r.qualityLowNested = quality(e.recipeID, f1), quality(e.recipeID, n1)
			r.qualityHighFlat, r.qualityHighNested = quality(e.recipeID, f2), quality(e.recipeID, n2)
		else
			r.schematic = tostring(w2 or sch)
		end
		r.reagentsYouCanMake = {}
		for _, slot in ipairs(e.slots or {}) do
			for _, iid in ipairs(slot.ids) do
				if products[iid] then
					r.reagentsYouCanMake[#r.reagentsYouCanMake + 1] = iid .. " <- recipe " .. products[iid]
					break
				end
			end
		end
		m.list[#m.list + 1] = r
	end

	ns.db = ns.db or {}
	ns.db.craftShopMeasure = ns.db.craftShopMeasure or {}
	ns.db.craftShopMeasure[open and "open" or "closed"] = m
	print(("%s craftshop probe (window %s): %d API names, %s recipes, %d products, %d of %d unlearned say a source.")
		:format(p, open and "OPEN" or "CLOSED", #names, tostring(type(ids) == "table" and #ids or idsWhy), nProducts,
		c.unlearnedWithSource, c.unlearned))
	if open then
		print("   Now close the profession window and run |cffffd100/mh craftshop probe|r again, then |cffffd100/reload|r.")
	else
		print("   Done with the window closed. Also once with it OPEN (profession + recipes on your list), then |cffffd100/reload|r.")
	end
end

--- Note which item every LEARNED recipe of the open profession makes, so the list can say "you make this yourself".
--- C_TradeSkillUI answers about the profession you opened (Profession.lua, 30 Aug); a linked or guild profession is
--- someone else's, so those are skipped. MEASURED 6 Oct 2026: 504 recipes, 493 with an output item, 530 products.
local function LearnMakes()
	local T = C_TradeSkillUI
	if not (T and T.GetAllRecipeIDs and T.GetRecipeInfo and T.GetRecipeSchematic) then
		return 0
	end
	if T.IsTradeSkillReady then
		local ok, ready = pcall(T.IsTradeSkillReady)
		if not (ok and ready) then
			return 0
		end
	end
	for _, fn in ipairs({ "IsTradeSkillLinked", "IsTradeSkillGuild", "IsNPCCrafting" }) do
		if T[fn] then
			local ok, v = pcall(T[fn])
			if ok and v then
				return 0
			end
		end
	end
	local ok, ids = pcall(T.GetAllRecipeIDs)
	if not ok or type(ids) ~= "table" then
		return 0
	end
	local makes = MyMakes()
	local n = 0
	for _, id in ipairs(ids) do
		local okI, ri = pcall(T.GetRecipeInfo, id)
		if okI and type(ri) == "table" and ri.learned then
			local okS, sch = pcall(T.GetRecipeSchematic, id, false)
			if okS and type(sch) == "table" then
				local function put(item)
					if type(item) == "number" then
						makes[item] = { r = id, n = ri.name, q = sch.quantityMin }
						n = n + 1
					end
				end
				put(sch.outputItemID)
				for _, q in ipairs(ri.qualityItemIDs or {}) do
					put(q)
				end
			end
		end
	end
	if win and win:IsShown() then
		Refresh()
	end
	return n
end

do
	-- TRADE_SKILL_SHOW / TRADE_SKILL_LIST_UPDATE: both already registered by Profession.lua and ProfessionGuided.lua.
	-- The list update fires in bursts while the window loads, so wait a moment and do it once.
	local pending = false
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("TRADE_SKILL_SHOW")
	ev:RegisterEvent("TRADE_SKILL_LIST_UPDATE")
	ev:SetScript("OnEvent", function()
		if pending or not (C_Timer and C_Timer.After) then
			return
		end
		pending = true
		C_Timer.After(1.5, function()
			pending = false
			pcall(LearnMakes)
		end)
	end)
end

-- Side panel refresh when the player picks another recipe (Blizzard's own event; EventRegistry calls it securely).
if EventRegistry and EventRegistry.RegisterCallback then
	-- A moment LATER: our callback is registered at load, before Blizzard_Professions' own, so it runs first and read
	-- the previous recipe from the form. Rob, 6 Oct 2026 (screenshot): Hood selected, panel said Shoulderguards.
	EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function()
		if C_Timer and C_Timer.After then
			C_Timer.After(0.1, function()
				if ns.RefreshProfessionSidePanel then
					pcall(ns.RefreshProfessionSidePanel)
				end
			end)
		end
	end, "MidnightHelperCraftShop")
end
