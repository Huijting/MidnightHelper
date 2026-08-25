--[[
	Openables — toont openbare tas-items (caches, lockboxes, satchels, quest-containers)
	met een klik-om-te-openen knop + uitklaplijst (Rob-wens, 4 jul 2026). Eigen versie,
	geïnspireerd op "New Openables"; geen code-kopie.

	Detectie (never-lie, locale-veilig, 12.x-secret-safe): een tas-item is "openbaar"
	als zijn tooltip de gelokaliseerde regel ITEM_OPENABLE ("<Right Click to Open>")
	bevat. We gebruiken bewust NIET "heeft een use-spell" (dan zouden potions/food ook
	als openbaar tellen → vals-positief). C_TooltipInfo.GetBagItem levert de tooltip-
	regels zonder zichtbaar frame; secret-values guarden we weg.

	Openen = het item gebruiken via een SecureActionButton (type=item, item="item:<id>").
	Secure attributen/positie/zichtbaarheid mogen niet in combat gewijzigd worden — dus
	we (her)opbouwen alleen buiten combat; een state-driver verbergt de knop in combat.
]]

local _, ns = ...

--------------------------------------------------------------------------------
-- Detectie
--------------------------------------------------------------------------------

local function IsSecret(v)
	return v ~= nil and issecretvalue ~= nil and issecretvalue(v) == true
end

-- @return "openable" (loot-container: "<Right Click to Open>" OF een "Use: Open …"-buidel)
-- | "knowledge" (professie-studie-item: "Use: Study to increase your X Knowledge by N")
-- | "learn" ("Use: Teaches you …" — mount/pet/toy/recept, makkelijk te vergeten in je tas)
-- | nil. Alle drie gebruik je met dezelfde klik (SecureActionButton item). De detectie is
-- tooltip-tekst-gebaseerd (Engelse client — Rob/testers spelen Engels); later te
-- lokaliseren indien nodig.
-- An UNMET requirement (wrong level, missing profession, wrong class, too little rep…)
-- renders RED in the tooltip — language-independent, unlike matching "Requires …" text.
-- We can't act on such an item, so it must not clutter the list (a Cooking recipe on a
-- char without Cooking — Rob, 14 jul). Fails OPEN: if the colour can't be read we return
-- false and behave exactly as before, so we never hide something by accident.
local function LineIsRedRequirement(line)
	if not line then
		return false
	end
	local c = line.leftColor
	if not c and TooltipUtil and TooltipUtil.SurfaceArgs then
		pcall(TooltipUtil.SurfaceArgs, line)
		c = line.leftColor
	end
	if type(c) ~= "table" then
		return false
	end
	local r, g, b = c.r, c.g, c.b
	if r == nil and c.GetRGB then
		local okc, rr, gg, bb = pcall(c.GetRGB, c)
		if okc then
			r, g, b = rr, gg, bb
		end
	end
	if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
		return false
	end
	-- Tooltip "error red" ≈ (1.0, 0.125, 0.125); item-quality colours never hit this.
	return r > 0.8 and g < 0.3 and b < 0.3
end

local function SlotKind(bag, slot)
	if not (C_TooltipInfo and C_TooltipInfo.GetBagItem) then
		return nil
	end
	local ok, data = pcall(C_TooltipInfo.GetBagItem, bag, slot)
	if not ok or type(data) ~= "table" or type(data.lines) ~= "table" then
		return nil
	end
	-- Equippable gear with a collect-by-use appearance (a belt, etc.) must NOT go in the list:
	-- clicking it there would try to EQUIP it — bind + "not your armor type" popup, not collect
	-- (Rob's Void-Touched Winter Belt, 14 jul). You collect gear by equipping it yourself; only
	-- use-only appearance items (ensembles/tokens) belong in this click-to-use list.
	local equippable = false
	if C_Container and C_Container.GetContainerItemID and C_Item and C_Item.GetItemInfoInstant then
		local iid = C_Container.GetContainerItemID(bag, slot)
		if iid then
			local equipLoc = select(4, C_Item.GetItemInfoInstant(iid))
			equippable = type(equipLoc) == "string" and equipLoc ~= "" and equipLoc ~= "INVTYPE_NON_EQUIP"
		end
	end

	local openLine = ITEM_OPENABLE -- "<Right Click to Open>" (gelokaliseerd)
	local kind
	-- A cosmetic appearance you collect by USING it ("Use: Add this appearance to your …
	-- collection") isn't a "teaches you" item, so it needs its own signal — spread across two
	-- lines (the Use line + the collected/uncollected line), hence flags resolved after the loop.
	local appearanceUse, alreadyCollected = false, false
	-- Scan ALL lines: the "Use:" line sits above the "Requires …" line, so we can't return
	-- on the first match — we must first see whether a red requirement blocks this item.
	for _, line in ipairs(data.lines) do
		local text = line and line.leftText
		if text and not IsSecret(text) then
			if LineIsRedRequirement(line) then
				return nil -- can't use/learn it (wrong level, missing profession, …)
			end
			local lower = text:lower()
			if not kind then
				if openLine and (text == openLine or (strfind and strfind(text, openLine, 1, true))) then
					kind = "openable"
				-- "Use: Open to gain some Gold" e.d. → een buidel die je gebruikt i.p.v.
				-- rechtsklikt (die mist de "<Right Click to Open>"-regel). Eis "open to"
				-- (open TO gain/receive), niet los "open": anders vangt 'ie een cosmetic
				-- ("Use: Opens your mind to…") of een trinket ("Use: Hold the fissure open…")
				-- als loot-buidel — dat gebeurde met Entropic Extract / Void Fissure (Rob 10 jul).
				elseif lower:find("use:", 1, true) and lower:find("open to", 1, true) then
					kind = "openable"
				-- "Use: Collect 10 Hero Dawncrests" → een reward-/currency-pack die je GEBRUIKT
				-- om de beloning te verzamelen (mist de "<Right Click to Open>"-regel). Eis
				-- "collect" + een getal (pattern "collect%s+%d"), zodat "…to your collection"
				-- (cosmetic appearance, hieronder apart) NIET matcht — "collection" heeft geen
				-- getal na "collect". itemID 246752 (Celebratory Pack of Hero Dawncrests), Rob 14 jul.
				elseif lower:find("use:", 1, true) and lower:find("collect%s+%d") then
					kind = "openable"
				-- "Use: Teaches you …" → een mount/pet/toy/recept dat je nog moet leren.
				elseif lower:find("use:", 1, true) and lower:find("teaches you", 1, true) then
					kind = "learn"
				-- "Use: Study/Read ... Knowledge by N" → professie-studie-item.
				elseif lower:find("knowledge", 1, true)
					and (lower:find("study", 1, true) or lower:find("read", 1, true)) then
					kind = "knowledge"
				end
			end
			-- Cosmetic transmog appearance (collect-by-use). Track it like a learn item so it
			-- isn't forgotten — but only while UNcollected (Rob's Void-Touched Winter Belt, 14
			-- jul). Fail-permissive: show unless the tooltip explicitly says you already have it.
			if not equippable and lower:find("use:", 1, true) and lower:find("this appearance", 1, true)
				and lower:find("collection", 1, true) then
				appearanceUse = true
			end
			if lower:find("have collected this appearance", 1, true) then
				alreadyCollected = true
			end
		end
	end
	if not kind and appearanceUse and not alreadyCollected then
		kind = "learn"
	end
	return kind
end

--------------------------------------------------------------------------------
-- Crest-caps: waarom een bundel weigert open te gaan
--------------------------------------------------------------------------------

--- ⚠️ TOEGEVOEGD 15 aug 2026, uit een echte melding van Rob.
---
--- Hij klikte op "Bundle of Adventurer Mistcrests" en kreeg een rode foutmelding
--- ("You cannot earn 10 Adventurer Mistcrests right now") met een popup die bleef staan.
--- Zijn eigen crest-snapshot gaf het antwoord meteen: **Adventurer Mistcrest (3442) stond
--- op 100 van maxQuantity 100.** Veteran op 20 en Champion op 10, dus daar viel het niet op.
---
--- Het spel weet dit vóór de klik en zegt het pas erna. Dat is precies het gat waar deze
--- addon voor bestaat: niet tracken wat je al ziet, maar uitleggen wat je niet ziet.
---
--- Bewust smal gehouden. Dit raadt niet wat een willekeurige container uitdeelt — dat kan
--- de client ons niet vertellen en gokken zou erger zijn dan zwijgen. Het herkent alleen
--- het geval waarin de itemnaam zélf een crest-currency noemt die wij al bijhouden.
--- `maxWeeklyQuantity` blijft buiten beschouwing: op 3442 stond die op 0 terwijl de
--- seizoenscap wél vol zat, dus een weekcap is hier niet wat blokkeert.
local function CrestCapBlock(itemName)
	if type(itemName) ~= "string" or itemName == "" then
		return nil
	end
	if not (ns.DAWNCREST_TIERS and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo) then
		return nil
	end
	local haystack = itemName:lower()
	for _, tier in ipairs(ns.DAWNCREST_TIERS) do
		for _, id in ipairs({ tier.currencyId, tier.season2CurrencyId }) do
			if id then
				local ok, info = pcall(C_CurrencyInfo.GetCurrencyInfo, id)
				if ok and type(info) == "table" then
					local name = info.name
					if type(name) == "string" and name ~= "" and not IsSecret(name) then
						-- Substring, zodat het meervoud in "…Mistcrests" ook matcht. Dat dekt
						-- meteen de hele familie (Pouch of Veteran, Satchel of Champion, Pack of
						-- Hero, Glorious Cluster of Myth …) zonder een itemID-tabel die veroudert.
						if haystack:find(name:lower(), 1, true) then
							-- ⚠️ HERSCHREVEN 15 aug. Eerst deed dit zijn eigen rekensom met
							-- quantity vs maxQuantity, daarna met totalEarned erbij. Blizzard
							-- heeft hier sinds 11.0 een eigen predicaat voor dat de hele
							-- useTotalEarnedForMaxQty-vertakking al afhandelt. Onze eigen som
							-- was twee keer subtiel anders; die van het spel is per definitie
							-- die van het spel.
							-- ⚠️ DERDE POGING, EN DE VORIGE WAS EEN VERSLECHTERING.
							--
							-- Versie 2 rekende zelf en had het goed. Versie 3 verving dat door
							-- Blizzards PlayerHasMaxQuantity omdat dat "netter" was, en zette de
							-- eigen som als fallback áchter een `capped == nil`. Maar het
							-- predicaat bestáát, en het gaf `false`: Rob houdt er 60 van de 100,
							-- dus zijn bezit zit niet aan de cap. De cap zit op wat hij VERDIEND
							-- heeft — 100 van 100 — en dat is precies wat de eigen som al las.
							-- `false` is niet `nil`, dus de fallback draaide nooit en de regel
							-- verscheen niet.
							--
							-- Nu is het een OF: het spel mag zeggen dat het vol is, en onze eigen
							-- som mag dat ook. Geen van beide overstemt de ander, want ze meten
							-- aantoonbaar verschillende dingen.
							local qty = tonumber(info.useTotalEarnedForMaxQty
								and info.totalEarned or info.quantity) or 0
							local max = tonumber(info.maxQuantity) or 0
							local capped = max > 0 and qty >= max

							if not capped and C_CurrencyInfo.PlayerHasMaxQuantity then
								local ok, v = pcall(C_CurrencyInfo.PlayerHasMaxQuantity, id)
								capped = ok and v == true
							end
							if not capped and C_CurrencyInfo.PlayerHasMaxWeeklyQuantity then
								local ok, v = pcall(C_CurrencyInfo.PlayerHasMaxWeeklyQuantity, id)
								capped = ok and v == true
							end

							if capped then
								return name, qty, max
							end
						end
					end
				end
			end
		end
	end
	return nil
end

-- @return geordende lijst { { bag, slot, itemID, name, icon, count }, ... }
local function ScanOpenables()
	local out = {}
	if not (C_Container and C_Container.GetContainerNumSlots) then
		return out
	end
	-- 0 = backpack, 1-4 = tassen, 5 = reagent-bag. GetContainerNumSlots geeft 0 voor
	-- niet-bestaande tassen, dus de loop is veilig.
	for bag = 0, 5 do
		local slots = C_Container.GetContainerNumSlots(bag) or 0
		for slot = 1, slots do
			local info = C_Container.GetContainerItemInfo(bag, slot)
			local kind = SlotKind(bag, slot)
			-- ⚠️ TOEGEVOEGD 15 aug 2026, na een sweep over 140 geïnstalleerde addons.
			--
			-- Rob vroeg of een andere addon een completere openables-lijst heeft. Het
			-- antwoord: NIEMAND heeft een lijst. OPie, Syndicator en Baganator lezen
			-- allemaal `hasLoot` van C_Container.GetContainerItemInfo — een vlag van de
			-- client zelf, zonder tooltip, zonder taal, zonder onderhoud.
			--
			-- Wij vroegen die info al op en keken er niet naar. De tooltip-herkenning
			-- hieronder blijft staan, want die vangt dingen die `hasLoot` niet dekt
			-- (knowledge-items, "Use: Collect 10 …"-crestpacks, uncollected appearances).
			-- Dit is dus geen vervanging maar een tweede net, voor wat onze patronen
			-- missen — en het is meteen het antwoord op "is onze lijst compleet": nee,
			-- en de client wist het al.
			if not kind and info and info.hasLoot and not IsSecret(info.hasLoot) then
				kind = "openable"
			end
			if kind then
				if info then
					-- Level-vereiste: verberg items die je nog niet kunt openen (bv. een
					-- level-60-cache op level 23). itemMinLevel = 5e return van GetItemInfo.
					local minLvl = info.itemID and C_Item and C_Item.GetItemInfo
						and select(5, C_Item.GetItemInfo(info.itemID))
					local plvl = (UnitLevel and UnitLevel("player")) or 999
					if not minLvl or minLvl <= plvl then
						local itemName = info.itemName
							or (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(info.itemID))
							or "?"
						local capName, capQty, capMax = CrestCapBlock(itemName)
						out[#out + 1] = {
							bag = bag,
							slot = slot,
							itemID = info.itemID,
							name = itemName,
							icon = info.iconFileID or "Interface\\Icons\\INV_Misc_Bag_08",
							count = info.stackCount or 1,
							kind = kind, -- "openable" | "knowledge" | "learn"
							-- Waarom dit item nu niet opengaat, als we dat weten.
							capName = capName, capQty = capQty, capMax = capMax,
						}
					end
				end
			end
		end
	end
	return out
end

ns.GetOpenables = ScanOpenables

--------------------------------------------------------------------------------
-- Aan/uit + settings
--------------------------------------------------------------------------------

local function Enabled()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return true
	end
	return uiDb.openables ~= false
end

function ns.IsOpenablesEnabled()
	return Enabled()
end

function ns.SetOpenablesEnabled(v)
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) == "table" then
		uiDb.openables = v and true or false
	end
	if ns.UpdateOpenables then
		ns.UpdateOpenables()
	end
end

--------------------------------------------------------------------------------
-- UI: hoofdknop (open volgende) + teller-badge + uitklaplijst
--------------------------------------------------------------------------------

local ROWH = 24
local MAXROWS = 12
--- ⚠️ TOEGEVOEGD 15 aug, nadat Rob "waar vind ik dat?????" vroeg.
---
--- De cap stond wel achter de naam in de UITGEKLAPTE lijst en nergens anders. Wat Rob
--- op zijn scherm ziet is de ingeklapte knop met Blizzards eigen item-tooltip erop, dus
--- de uitleg stond precies niet op de plek waar hij keek. Een verklaring die je moet
--- uitklappen om te vinden legt niets uit.
---
--- Nu hangt hij aan de tooltip van beide, en die van het spel zelf zegt het niet:
--- Blizzard toont de cap pas in de foutmelding, achteraf.
local function AddCapLine(owner)
	if not (owner and owner._capName and GameTooltip) then
		return
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(("%s  %d/%d"):format(
		owner._capName, owner._capQty or 0, owner._capMax or 0), 1, 0.5, 0.5)
	GameTooltip:AddLine(ns:L("OPEN_TIP_CAPPED"), 1, 0.5, 0.5, true)
end

local frame -- main secure button (UIParent)

local function ApplyOpenAttr(btn, entry)
	-- Alleen buiten combat: secure "gebruik item"-attribuut.
	-- Target by itemID: a bag/slot attribute breaks as soon as that slot empties.
	if InCombatLockdown and InCombatLockdown() then
		return
	end
	if entry and entry.itemID then
		btn:SetAttribute("type", "item")
		btn:SetAttribute("item", ("item:%d"):format(entry.itemID))
	else
		btn:SetAttribute("type", nil)
		btn:SetAttribute("item", nil)
	end
end

local function StyleAsBox(f)
	if not f.SetBackdrop then
		return
	end
	f:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0.08, 0.07, 0.05, 0.92)
	f:SetBackdropBorderColor(1, 0.82, 0.2, 1) -- goud
end

local function EnsureRow(i)
	local rows = frame._rows
	local r = rows[i]
	if r then
		return r
	end
	-- Secure rij-knop als KIND van de hoofdknop (frame). Kind van een frame anchoren
	-- aan dat frame mag; positie ligt vast, we wijzigen alleen attribuut + show/hide
	-- (buiten combat). Zo geen "cannot anchor protected frame".
	r = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
	r:SetHeight(ROWH)
	r:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -6 - (i - 1) * (ROWH + 2))
	r:SetPoint("RIGHT", frame, "RIGHT", 120, 0)
	r:RegisterForClicks("AnyUp", "AnyDown")
	if r.SetBackdrop then
		r:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
		r:SetBackdropColor(0.14, 0.11, 0.07, 0.9)
	end
	local icon = r:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", r, "LEFT", 3, 0)
	icon:SetSize(ROWH - 6, ROWH - 6)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	r._icon = icon
	local nm = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	nm:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	nm:SetPoint("RIGHT", r, "RIGHT", -6, 0)
	nm:SetJustifyH("LEFT")
	nm:SetWordWrap(false)
	r._name = nm
	r:SetScript("OnEnter", function(self)
		if self._bag and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetBagItem(self._bag, self._slot)
			AddCapLine(self)
			GameTooltip:Show()
		end
		if r.SetBackdropColor then
			r:SetBackdropColor(0.25, 0.2, 0.1, 0.95)
		end
	end)
	r:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
		if r.SetBackdropColor then
			r:SetBackdropColor(0.14, 0.11, 0.07, 0.9)
		end
	end)
	r:Hide()
	rows[i] = r
	return r
end

local function EnsureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Button", "MidnightHelperOpenables", UIParent, "SecureActionButtonTemplate")
	f:SetSize(40, 40)
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:RegisterForClicks("LeftButtonUp", "LeftButtonDown") -- links = openen
	f:RegisterForDrag("RightButton") -- rechts-slepen verplaatst
	f:SetMovable(true)
	f:EnableMouse(true)
	local pos = ns.db and ns.db.ui and ns.db.ui.openablesPos
	if type(pos) == "table" and pos[1] then
		f:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", -220, 120)
	end
	if ns.db and ns.db.ui and ns.db.ui.openablesScale then
		f:SetScale(ns.db.ui.openablesScale)
	end
	-- gouden rand
	local border = CreateFrame("Frame", nil, f, "BackdropTemplate")
	border:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
	border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
	if border.SetBackdrop then
		border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 13 })
		border:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	end
	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	f._icon = icon
	-- teller-badge
	local badge = f:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
	badge:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	badge:SetTextColor(1, 0.9, 0.4)
	f._badge = badge
	-- uitklap-pijltje (niet-secure) rechtsboven
	local toggle = CreateFrame("Button", nil, f)
	toggle:SetSize(16, 16)
	toggle:SetPoint("TOPRIGHT", f, "TOPRIGHT", 6, 6)
	toggle:SetNormalTexture("Interface\\Buttons\\UI-SquareButton-Down")
	toggle:SetScript("OnClick", function()
		frame._expanded = not frame._expanded
		if ns.db and ns.db.ui then
			ns.db.ui.openablesExpanded = frame._expanded
		end
		if ns.UpdateOpenables then
			ns.UpdateOpenables()
		end
	end)
	f._toggle = toggle
	f._rows = {}
	f._expanded = ns.db and ns.db.ui and ns.db.ui.openablesExpanded or false
	-- state-driver: verberg in combat (openen kan toch niet in combat; en secure
	-- attributen/positie mogen daar niet wijzigen). Buiten combat sturen we zelf.
	RegisterStateDriver(f, "visibility", "[combat] hide; nil")
	f:SetScript("OnDragStart", function(self)
		if InCombatLockdown and InCombatLockdown() then
			return
		end
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local p, _, rp, x, y = self:GetPoint()
		if p and ns.db and ns.db.ui then
			ns.db.ui.openablesPos = { p, rp, x, y }
		end
	end)
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", function(self, delta)
		if not IsShiftKeyDown() then
			return
		end
		local s = math.max(0.5, math.min(2.5, (self:GetScale() or 1) + (delta > 0 and 0.1 or -0.1)))
		self:SetScale(s)
		if ns.db and ns.db.ui then
			ns.db.ui.openablesScale = s
		end
	end)
	f:SetScript("OnEnter", function(self)
		if self._topBag and GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetBagItem(self._topBag, self._topSlot)
			AddCapLine(self)
			GameTooltip:AddLine(ns:L("OPEN_TIP_HINT"), 0.7, 0.7, 0.7, true)
			GameTooltip:Show()
		end
	end)
	f:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	f:Hide()
	frame = f
	return f
end

-- geluid bij een NIEUW openbaar item
local lastCount = 0

function ns.UpdateOpenables()
	if not Enabled() then
		if frame then
			frame:Hide()
		end
		lastCount = 0
		return
	end
	if InCombatLockdown and InCombatLockdown() then
		return -- niks aan protected frames in combat; state-driver regelt de zichtbaarheid
	end
	local list = ScanOpenables()

	-- ⚠️ TOEGEVOEGD 15 aug. Rob, over een bundel die niet open kon: "hij blijft in beeld
	-- staan terwijl ik hem niet kan verwerken en hij staat dus in de weg".
	--
	-- Terecht. Dit paneel betekent "dit kun je nu openen". Iets waarvan het spel weigert
	-- hoort daar niet bovenaan te staan, en als het het énige is, hoort de knop er niet
	-- te zijn. Verbergen is hier geen stilte: het item ligt gewoon in je tas en komt
	-- vanzelf terug zodra de cap bij de reset stijgt.
	--
	-- Geblokkeerde items zakken dus naar onderen, en is ALLES geblokkeerd dan verdwijnt
	-- de knop. Wie er meer heeft, ziet de bruikbare bovenaan en de geblokkeerde eronder
	-- mét de reden in de tooltip -- dan is het informatie in plaats van een obstakel.
	-- Twee lijsten en aan elkaar plakken, niet table.sort: die is in Lua niet stabiel,
	-- dus items binnen dezelfde groep zouden per scan van plek kunnen wisselen. Een
	-- knop die onder je muis van item verandert is erger dan een verkeerde volgorde.
	local usable, blocked = {}, {}
	for _, e in ipairs(list) do
		if e.capName then
			blocked[#blocked + 1] = e
		else
			usable[#usable + 1] = e
		end
	end
	if #usable > 0 then
		for _, e in ipairs(blocked) do
			usable[#usable + 1] = e
		end
		list = usable
	end

	local n = (#usable > 0) and #list or 0
	if n == 0 then
		if frame then
			frame:Hide()
		end
		lastCount = 0
		return
	end
	local f = EnsureFrame()
	-- geluid als er iets bijkwam (tenzij uitgezet in settings)
	local soundOn = not (ns.db and ns.db.ui and ns.db.ui.openablesSound == false)
	if n > lastCount and soundOn and PlaySound then
		PlaySound((SOUNDKIT and SOUNDKIT.IG_BACKPACK_OPEN) or 5274, "SFX")
	end
	lastCount = n

	local top = list[1]
	f._icon:SetTexture(top.icon)
	f._topBag, f._topSlot = top.bag, top.slot
	f._capName, f._capQty, f._capMax = top.capName, top.capQty, top.capMax
	f._badge:SetText(n > 1 and tostring(n) or "")
	ApplyOpenAttr(f, top)

	-- rijen (uitklaplijst)
	local showRows = frame._expanded
	for i = 1, MAXROWS do
		local e = list[i]
		local r = f._rows[i]
		if showRows and e then
			r = EnsureRow(i)
			r._icon:SetTexture(e.icon)
			local label = (e.count and e.count > 1 and (e.count .. "x ") or "") .. (e.name or "?")
			-- Een bundel die je niet kwijt kunt hoort te zeggen waarom, in plaats van je
			-- erop te laten klikken voor een rode foutmelding en een popup die blijft
			-- staan. Het item blijft klikbaar: de cap kan tussen twee scans veranderd
			-- zijn, en dan is weigeren erger dan het gewoon proberen.
			if e.capName then
				label = ("%s  |cffff8080(%s %d/%d)|r"):format(
					label, e.capName, e.capQty or 0, e.capMax or 0)
			end
			r._name:SetText(label)
			r._bag, r._slot = e.bag, e.slot
			r._capName, r._capQty, r._capMax = e.capName, e.capQty, e.capMax
			ApplyOpenAttr(r, e)
			r:Show()
		elseif r then
			r:Hide()
		end
	end
	f:Show()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local throttle = 0
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("BAG_UPDATE_DELAYED")
ev:RegisterEvent("ITEM_LOCK_CHANGED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:RegisterEvent("PLAYER_LEVEL_UP") -- level-gated cache wordt openbaar bij het juiste level
ev:RegisterEvent("GET_ITEM_INFO_RECEIVED") -- item-info kwam alsnog binnen (level/naam)
-- ⚠️ VAKVAARDIGHEDEN LADEN LATER DAN JE TAS, en dat kostte Rob 19 aug een item.
--
-- Hij raapte een Finely Woven Lynx Collar op ("Use: Study to increase your Midnight
-- Tailoring Knowledge by 2", met daaronder "Requires Midnight Tailoring (1)"). Er kwam
-- niets in beeld; pas na een /reload verscheen het item. Een enchanting-studieboek even
-- daarvoor werkte wél meteen.
--
-- De oorzaak zit in SlotKind: een RODE vereisten-regel betekent "dit kun je niet
-- gebruiken" en levert `return nil`. Zolang de client jouw skill-lines nog niet heeft
-- geladen, rendert "Requires Midnight Tailoring (1)" rood — ook al héb je het beroep.
-- Dus een tijdelijke toestand werd als een permanent oordeel gelezen. Bij enchanting was
-- die skill al bekend, dus daar viel het niet op.
--
-- PLAYER_LEVEL_UP staat hierboven om exact dezelfde reden: een vereiste die verandert,
-- verandert de uitkomst. Een beroep leren of laden is dezelfde soort gebeurtenis.
ev:RegisterEvent("SKILL_LINES_CHANGED")
ev:RegisterEvent("TRADE_SKILL_LIST_UPDATE")

local function Schedule()
	if throttle > 0 then
		return
	end
	throttle = 1
	if C_Timer and C_Timer.After then
		C_Timer.After(0.3, function()
			throttle = 0
			ns.UpdateOpenables()
		end)
	else
		throttle = 0
		ns.UpdateOpenables()
	end
end

ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
		EnsureFrame()
	end
	Schedule()
end)
