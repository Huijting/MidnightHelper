--[[
	Dungeon Boss Window (Rob, 12 jun — 1.8-hoofdfeature, v3 na twee
	feedbackrondes): compact zwevend venster met de boss-stappen van de
	huidige dungeon. Pager (< i/N >), klikbare {SPELL:id}-links met
	hover-tooltip (read-only EditBox, Delve Coach-patroon), versleepbaar,
	resizable (breedte via grip) én schaalbaar via SHIFT+scroll (Robs idee:
	resolutie-onafhankelijk groter — tekst, model en venster in één keer).

	Feedbackronde 2 verwerkt:
	- Kop toont nu de BOSSNAAM (sub = dungeonnaam) — niet 4× "Windrunner
	  Spire".
	- Het model-laadprobleem (beeld pas na heen-en-weer bladeren): modellen
	  laden async; na elke SetCreature volgt een nalaad-tik op +0.2s die de
	  creature opnieuw zet zolang dezelfde boss nog voorstaat.
	- Mini-portret in de kop is een KNOP die het vastgeklikte zijpaneel
	  toggles: boss in vol ornaat, eigen X (keuze bewaard), beweegt mee met
	  het hoofdvenster en groeit mee met de hoogte.
	- SHIFT+scroll = schaal 0.7-1.8 (bewaard in ui.bossWin.scale);
	  positie-opslag is schaal-onafhankelijk (toast-recept).

	Gedrag: auto-open + meebladeren bij ENCOUNTER_START (hook vanuit
	DungeonLiveCoach); X = stil voor de rest van deze dungeon; /mh bosswin
	togglet overal (buiten een dungeon: dungeon-van-de-week).
]]

local _, ns = ...

local DEFAULT_W = 400
local MIN_W, MAX_W = 340, 720
local MIN_SCALE, MAX_SCALE = 0.7, 1.8
local HEADER_H = 78
local THUMB_SIZE = 58
local PANEL_W = 190
local PAD = 12

local win -- frame, lazy
local curDungeon -- roster-dungeon-table
local curIdx = 1
local suppressedFor = nil -- "dungeonKey<sep>bossKey" die Rob met de X sloot
local modelGen = 0 -- nalaad-generatie (paging tijdens de 0.2s-tik)

-- Suppress is PER BOSS (Rob 16 jun): de X laat alléén die ene boss met rust;
-- een volgende boss (dungeon-pull, ritual-stage of die boss targeten) geeft
-- een vers venster. Permanent uit = de Settings-toggle (auto-open).
local SUPPRESS_SEP = "\031"
local function SuppressKey(dungeonKey, bossKey)
	if not dungeonKey then
		return nil
	end
	return dungeonKey .. SUPPRESS_SEP .. (bossKey or "")
end
local function CurBossKey()
	return curDungeon
		and curDungeon.bosses
		and curDungeon.bosses[curIdx]
		and curDungeon.bosses[curIdx].key or nil
end

local COLOR_TANK = "aecbfa"
local COLOR_HEAL = "a9e8b8"
local COLOR_DPS = "f2c4a0"
local COLOR_DIMTXT = "8a8f98"

-- Creature-IDs per boss voor het 3D-model (bron: DBM-Party-* SetCreatureID,
-- 12 jun 2026). Ontbreekt een ID (Nalorakk: "too many IDs to guess" in DBM),
-- dan blijft het model verborgen — never-lie, niet gokken.
local CREATURES = {
	["windrunnerspire:derelictduo"] = 231626, -- Kalis (Latch = 231629)
	["windrunnerspire:emberdawn"] = 231606,
	["windrunnerspire:kroluk"] = 231631,
	["windrunnerspire:restlessheart"] = 231636,
	["maisara:murojin"] = 247570, -- Muro'jin (Nekraxx = 247572)
	["maisara:vordaza"] = 248595,
	["maisara:raktul"] = 248605,
	["murderrow:kystia"] = 252458,
	["murderrow:zaen"] = 234649,
	["murderrow:xathuux"] = 234647,
	["murderrow:lithiel"] = 237415,
	["nalorakk:hoardmonger"] = 248710,
	["nalorakk:sentinel"] = 244100,
	-- nalorakk:nalorakk — geen ID in DBM
	["blindingvale:trinity"] = 243028,
	["blindingvale:ikuzz"] = 244887,
	["blindingvale:ruia"] = 245912,
	["blindingvale:ziekket"] = 247676,
	["voidscar:tazrah"] = 238887,
	["voidscar:atroxus"] = 239008,
	["voidscar:charonus"] = 248015,
	["nexuspoint:kasreth"] = 241539,
	["nexuspoint:nysarra"] = 254227,
	["nexuspoint:lothraxion"] = 241546,
	["magisters:arcanotron"] = 231861,
	["magisters:seranel"] = 231863,
	["magisters:gemellus"] = 239636,
	["magisters:degentrius"] = 231865,
	["skyreach:ranjit"] = 75964,
	["skyreach:araknath"] = 76141,
	["skyreach:rukhran"] = 76143,
	["skyreach:viryx"] = 76266,
	["pitofsaron:garfrost"] = 36494,
	["pitofsaron:krickick"] = 36476, -- Ick (Krick rijdt mee)
	["pitofsaron:tyrannus"] = 36658, -- (Rimefang = 36661)
	["triumvirate:zuraal"] = 124871,
	["triumvirate:saprish"] = 124872,
	["triumvirate:nezhar"] = 124874,
	["triumvirate:lura"] = 124870,
	["algethar:vexamus"] = 194181,
	["algethar:ancient"] = 186951,
	["algethar:crawth"] = 191736,
	["algethar:doragosa"] = 190609,
}

-- Export voor de Settings-eyecatcher (rouleren langs bekende modellen).
ns.DUNGEON_BOSS_CREATURES = CREATURES

local function GetWinSettings()
	local uiDb = ns.db and ns.db.ui
	if type(uiDb) ~= "table" then
		return {}
	end
	if type(uiDb.bossWin) ~= "table" then
		uiDb.bossWin = {}
	end
	return uiDb.bossWin
end

local function FindDungeonByKey(key)
	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		if d.key == key then
			return d
		end
	end
	return nil
end

local function FindBossIndex(d, bossKey)
	for i, b in ipairs(d and d.bosses or {}) do
		if b.key == bossKey then
			return i
		end
	end
	return 1
end

-- Buiten een dungeon: dungeon-van-de-week, anders Windrunner Spire.
local function DefaultDungeon()
	if ns.GetDungeonOfTheWeek then
		local ok, dow = pcall(ns.GetDungeonOfTheWeek)
		if ok and dow then
			if type(dow) == "table" and dow.key then
				return dow
			end
			if type(dow) == "string" then
				local d = FindDungeonByKey(dow)
				if d then
					return d
				end
			end
		end
	end
	return FindDungeonByKey("windrunnerspire")
end

local function CurScale()
	local s = GetWinSettings()
	local sc = tonumber(s.scale) or 1
	if sc < MIN_SCALE then
		sc = MIN_SCALE
	elseif sc > MAX_SCALE then
		sc = MAX_SCALE
	end
	return sc
end

-- Positie schaal-onafhankelijk bewaren/toepassen (toast-recept: offset
-- t.o.v. UIParent-center in UI-coördinaten; SetPoint-offsets zijn in
-- frame-lokale (geschaalde) coördinaten → delen door de schaal).
local function ApplySavedPosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	f:ClearAllPoints()
	if tonumber(s.x) and tonumber(s.y) and UIParent then
		f:SetPoint("CENTER", UIParent, "CENTER", s.x / scale, s.y / scale)
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 320 / scale, 60 / scale)
	end
end

local function SavePosition(f)
	local s = GetWinSettings()
	local scale = f:GetScale() or 1
	local cx, cy = f:GetCenter()
	if cx and cy and UIParent then
		s.x = cx * scale - (UIParent:GetWidth() / 2)
		s.y = cy * scale - (UIParent:GetHeight() / 2)
	end
end

-- Paneel-verbergen is DUNGEON-gebonden, niet permanent (Rob, ronde 5):
-- een nieuwe dungeon opent altijd mét model; alleen binnen de dungeon
-- waar je 'm wegklikte blijft hij weg. Bewust geen SavedVariable.
local panelHiddenFor = nil -- dungeonKey

local function ModelPanelEnabled()
	return not (curDungeon and panelHiddenFor == curDungeon.key)
end

-- Per-creature start-zoom (camera-afstand). Grote/gevleugelde modellen openen
-- anders veel te dichtbij (Rob 15 jun: Belo'ren). Alleen modellen die dat nodig
-- hebben staan hier; de rest start op 0 (ongewijzigd). De speler kan altijd
-- bijscrollen; dit is enkel de start-stand per boss.
-- Per-creature start-zoom via CAMERA-AFSTAND (SetCamDistanceScale): groter =
-- verder weg = past beter voor grote modellen, en blijft GECENTREERD (SetPosition
-- liet het model naar een hoek driften — Rob 15 jun). 1.0 = standaard.
local MODEL_CAMSCALE = {
	[240387] = 4.0, -- Belo'ren, Child of Al'ar (grote feniks; Robs fijne stand 15 jun)
}

-- Async model-laden: SetCreature direct na frame-creatie rendert vaak leeg
-- (Robs "plaatje kwam pas na heen-en-weer bladeren"). Daarom na elke set
-- een nalaad-tik op +0.2s die dezelfde creature opnieuw zet zolang de boss
-- niet gewisseld is (modelGen-guard).
local function SetModelCreature(model, creatureID)
	if not model then
		return false
	end
	-- (De Settings-toggle "3D-model verbergen" gateert vanaf nu alléén het GROTE
	-- zijpaneel — via `settingOn`/`panelOn` in RefreshDungeonBossWindow. Het kleine
	-- boss-spotlight-model blijft altijd staan; Rob 24 jun.)
	if not creatureID then
		model:Hide()
		return false
	end
	-- Nieuwe boss (ander creatureID) → reset de zoom naar de per-boss start-stand.
	-- Bij eenzelfde boss (refresh) blijft de door de speler gescrolde zoom staan.
	if creatureID ~= model._mhLastCreatureID then
		model._mhLastCreatureID = creatureID
		model._mhCamScale = MODEL_CAMSCALE[creatureID] or 1.0
	end
	local function apply()
		model:ClearModel()
		model:SetCreature(creatureID)
		if model.SetPortraitZoom then
			model:SetPortraitZoom(model._mhUserZoom or (model._mhFullBody and 0 or 0.85))
		end
		-- Zoom via camera-afstand (blijft gecentreerd). Groter = verder weg = past
		-- beter voor grote/gevleugelde modellen (Belo'ren). De scroll past dit aan.
		if model.SetCamDistanceScale then
			model:SetCamDistanceScale(model._mhCamScale or 1.0)
		end
		if model.SetPosition then
			model:SetPosition(0, 0, 0)
		end
		if model.SetFacing then
			-- Respecteer een door de speler ingestelde hoek (in-venster draaien).
			model:SetFacing(model._mhUserFacing or 0.45)
		end
	end
	local ok = pcall(apply)
	model:SetShown(ok == true)
	if ok and C_Timer and C_Timer.After then
		local gen = modelGen
		C_Timer.After(0.2, function()
			if gen == modelGen and model:IsShown() then
				pcall(apply)
			end
		end)
	end
	return ok == true
end

-- Dropdown-picker: alle roster-dungeons + custom entries (Broken Throne).
-- Vóór EnsureWindow gedefinieerd (scoping-les: erná zou de OnClick-closure
-- een nil-global pakken i.p.v. deze local).
-- Gesplitst: custom-entries (rituals + raids) apart van de dungeons, zodat we
-- ze met een kopje bovenaan kunnen tonen (Robs wens: beter vindbaar).
local function PickerEntries()
	local customs, dungeons = {}, {}
	for _, d in ipairs(ns.GetDungeonRoster and ns.GetDungeonRoster() or {}) do
		dungeons[#dungeons + 1] = {
			key = d.key,
			name = ns.GetDungeonDisplayName and ns.GetDungeonDisplayName(d) or d.key,
		}
	end
	for key, e in pairs(ns.CUSTOM_BOSS_ENTRIES or {}) do
		customs[#customs + 1] = { key = key, name = e.name or key, entry = e }
	end
	table.sort(customs, function(a, b)
		return (a.name or "") < (b.name or "")
	end)
	return customs, dungeons
end

local function InitDungeonPickerMenu(_, level)
	if level ~= 1 or not (UIDropDownMenu_CreateInfo and UIDropDownMenu_AddButton) then
		return
	end
	local customs, dungeons = PickerEntries()

	local function addTitle(textKey)
		local t = UIDropDownMenu_CreateInfo()
		t.text = ns:L(textKey)
		t.isTitle = true
		t.notCheckable = true
		UIDropDownMenu_AddButton(t, level)
	end
	local function addEntry(e)
		local info = UIDropDownMenu_CreateInfo()
		info.text = e.name
		info.checked = (curDungeon and curDungeon.key == e.key) or false
		info.func = function()
			if CloseDropDownMenus then
				CloseDropDownMenus()
			end
			if e.entry then
				if ns.ShowBossWindowForEntry then
					ns.ShowBossWindowForEntry(e.entry, nil)
				end
			elseif ns.ShowDungeonBossWindow then
				ns.ShowDungeonBossWindow(e.key, nil)
			end
		end
		UIDropDownMenu_AddButton(info, level)
	end

	-- Onze eigen entries bovenaan, nu gesplitst in Rituals en Raids (Rob 15 jun),
	-- daarna de dungeons. Ritual-entries hebben een "ritual_"-key; de rest = raids.
	local rituals, raids = {}, {}
	for _, e in ipairs(customs) do
		if type(e.key) == "string" and e.key:find("^ritual_") then
			rituals[#rituals + 1] = e
		else
			raids[#raids + 1] = e
		end
	end
	if #rituals > 0 then
		addTitle("DGN_WIN_PICK_RITUALS")
		for _, e in ipairs(rituals) do
			addEntry(e)
		end
	end
	if #raids > 0 then
		addTitle("DGN_WIN_PICK_RAIDS")
		for _, e in ipairs(raids) do
			addEntry(e)
		end
	end
	if #dungeons > 0 then
		addTitle("DGN_WIN_PICK_DUNGEONS")
		for _, e in ipairs(dungeons) do
			addEntry(e)
		end
	end
end

local function EnsureWindow()
	if win then
		return win
	end

	local s = GetWinSettings()
	local f = CreateFrame("Frame", "MidnightHelperBossWindow", UIParent, "BackdropTemplate")
	local w = tonumber(s.w)
	if not w or w < MIN_W or w > MAX_W then
		w = DEFAULT_W
	end
	f:SetSize(w, 220)
	f:SetFrameStrata("MEDIUM")
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	if f.SetResizable then
		f:SetResizable(true)
	end
	if f.SetResizeBounds then
		f:SetResizeBounds(MIN_W, 140, MAX_W, 900)
	end
	f:SetScale(CurScale())
	f:Hide()
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	ApplySavedPosition(f)

	-- SHIFT+scroll = schalen (Robs idee). Gewone scroll laten we met rust.
	local function OnWheel(_, delta)
		if not IsShiftKeyDown() then
			return
		end
		local st = GetWinSettings()
		local sc = CurScale() + (delta > 0 and 0.1 or -0.1)
		if sc < MIN_SCALE then
			sc = MIN_SCALE
		elseif sc > MAX_SCALE then
			sc = MAX_SCALE
		end
		st.scale = sc
		SavePosition(f) -- huidige plek vastleggen in UI-coördinaten
		f:SetScale(sc)
		ApplySavedPosition(f) -- en terugzetten op dezelfde schermplek
	end
	f:EnableMouseWheel(true)
	f:SetScript("OnMouseWheel", OnWheel)

	-- Mini-portret in de kop = knop die het zijpaneel togglet. AnyUp +
	-- OnMouseUp als dubbele zekering (pager/Coach-klik-lessen) en een
	-- highlight zodat zichtbaar is dát het een knop is.
	local thumb = CreateFrame("Button", nil, f)
	thumb:SetSize(THUMB_SIZE, THUMB_SIZE)
	thumb:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -12)
	thumb:SetFrameLevel(f:GetFrameLevel() + 10)
	thumb:EnableMouse(true)
	thumb:RegisterForClicks("AnyUp")
	thumb:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	local function ToggleModelPanel()
		if ModelPanelEnabled() then
			panelHiddenFor = curDungeon and curDungeon.key or nil
		else
			panelHiddenFor = nil
		end
		ns.RefreshDungeonBossWindow()
	end
	thumb:SetScript("OnMouseUp", function()
		-- Shift-klik op het mini-model → grote roteerbare preview (hook C);
		-- normale klik blijft het zijpaneel togglen.
		if IsShiftKeyDown() and ns.PreviewCreature and f._previewCreatureID then
			ns.PreviewCreature(f._previewCreatureID, f._previewName)
			return
		end
		ToggleModelPanel()
	end)
	local thumbModel = CreateFrame("PlayerModel", nil, thumb)
	thumbModel:SetAllPoints(thumb)
	thumbModel:EnableMouse(false)
	f._thumbModel = thumbModel

	-- Overal slepen (Robs ronde 3): drag op het frame zelf, de titelstrip,
	-- de body-EditBox én het zijpaneel — knoppen blijven knoppen (drag
	-- start pas na de sleep-drempel, klikken blijft werken).
	local function HookDrag(region)
		region:RegisterForDrag("LeftButton")
		region:SetScript("OnDragStart", function()
			f:StartMoving()
		end)
		region:SetScript("OnDragStop", function()
			f:StopMovingOrSizing()
			SavePosition(f)
		end)
	end
	HookDrag(f)

	local drag = CreateFrame("Frame", nil, f)
	drag:SetPoint("TOPLEFT", f, "TOPLEFT", PAD + THUMB_SIZE + 4, -8)
	drag:SetPoint("TOPRIGHT", f, "TOPRIGHT", -176, -8)
	drag:SetHeight(HEADER_H - 14)
	drag:EnableMouse(true)
	HookDrag(drag)

	-- Kop: BOSSNAAM groot, dungeonnaam eronder (Robs ronde 2).
	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", thumb, "TOPRIGHT", 10, -6)
	title:SetPoint("RIGHT", f, "RIGHT", -176, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.82, 0.2)
	f._title = title

	-- Dungeonnaam = knop met dropdown-picker (Robs wens, 12 jun): buiten
	-- een dungeon vrij bladeren door alle dungeons + de Broken Throne-
	-- ritual. Bewust een echte UIPanelButton (Coach-les: kale Buttons en
	-- FontString-overlays zijn onbetrouwbaar klikbaar).
	local sub = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	sub:SetHeight(16)
	sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -3)
	sub:SetFrameLevel(f:GetFrameLevel() + 6)
	sub:RegisterForClicks("AnyUp")
	sub:SetScript("OnEnter", function(self)
		if GameTooltip then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
			GameTooltip:SetText(ns:L("DGN_WIN_PICK_HINT"), 1, 0.82, 0.2, 1, true)
			GameTooltip:Show()
		end
	end)
	sub:SetScript("OnLeave", function()
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)
	sub:SetScript("OnClick", function(self)
		if not (UIDropDownMenu_Initialize and ToggleDropDownMenu) then
			return
		end
		if not f._pickerMenu then
			f._pickerMenu = CreateFrame("Frame",
				"MidnightHelperBossWinPickerMenu", UIParent,
				"UIDropDownMenuTemplate")
		end
		UIDropDownMenu_Initialize(f._pickerMenu, InitDungeonPickerMenu, "MENU")
		ToggleDropDownMenu(1, nil, f._pickerMenu, self, 0, 0)
	end)
	f._sub = sub

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	close:SetFrameLevel(f:GetFrameLevel() + 5)
	close:SetScript("OnClick", function()
		suppressedFor = SuppressKey(curDungeon and curDungeon.key, CurBossKey())
		f:Hide()
	end)

	local prev = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	prev:SetSize(26, 20)
	prev:SetText("<")
	prev:SetPoint("TOPRIGHT", f, "TOPRIGHT", -104, -16)
	prev:SetFrameLevel(f:GetFrameLevel() + 5)
	prev:SetScript("OnClick", function()
		if curDungeon and #(curDungeon.bosses or {}) > 0 then
			curIdx = curIdx - 1
			if curIdx < 1 then
				curIdx = #curDungeon.bosses
			end
			ns.RefreshDungeonBossWindow()
		end
	end)

	local pager = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	pager:SetPoint("TOP", prev, "TOP", 37, -4)
	f._pager = pager

	local nxt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	nxt:SetSize(26, 20)
	nxt:SetText(">")
	nxt:SetPoint("TOPRIGHT", f, "TOPRIGHT", -32, -16)
	nxt:SetFrameLevel(f:GetFrameLevel() + 5)
	nxt:SetScript("OnClick", function()
		if curDungeon and #(curDungeon.bosses or {}) > 0 then
			curIdx = curIdx + 1
			if curIdx > #curDungeon.bosses then
				curIdx = 1
			end
			ns.RefreshDungeonBossWindow()
		end
	end)

	-- Body: read-only EditBox → klikbare spell-links met tooltips. Breedte
	-- volgt het venster (LEFT+RIGHT-ankers) zodat resizen meteen herwrapt.
	local body = CreateFrame("EditBox", nil, f)
	body:SetPoint("TOPLEFT", f, "TOPLEFT", PAD + 2, -(HEADER_H + 2))
	body:SetPoint("RIGHT", f, "RIGHT", -(PAD + 2), 0)
	body:SetMultiLine(true)
	body:SetFontObject("GameFontHighlightSmall")
	body:SetJustifyH("LEFT")
	body:SetAutoFocus(false)
	body:EnableMouse(true)
	if body.SetMaxLetters then
		body:SetMaxLetters(0)
	end
	if ns.AttachDelveTipHyperlinksToEditBox then
		ns:AttachDelveTipHyperlinksToEditBox(body)
	end
	body:EnableMouseWheel(true)
	body:SetScript("OnMouseWheel", OnWheel)
	HookDrag(body) -- tekstvak meeslepen; spell-link-kliks blijven werken
	f._body = body

	-- Chat- en Share-knop (Robs idee + maatje): Chat = stappen nogmaals in
	-- je eigen chat (altijd toegestaan); Share = gétoonde boss naar de
	-- groep via de bestaande combat-wachtrij.
	local chatBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	chatBtn:SetSize(58, 18)
	chatBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -26, 8)
	chatBtn:SetFrameLevel(f:GetFrameLevel() + 5)
	chatBtn:SetText(ns:L("DGN_WIN_CHAT"))
	chatBtn:SetScript("OnClick", function()
		local b = curDungeon and curDungeon.bosses and curDungeon.bosses[curIdx]
		if b and ns.PrintDungeonBossTips then
			ns.PrintDungeonBossTips(curDungeon.key, b.key)
		end
	end)

	local shareBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	shareBtn:SetSize(72, 18)
	shareBtn:SetPoint("RIGHT", chatBtn, "LEFT", -4, 0)
	shareBtn:SetFrameLevel(f:GetFrameLevel() + 5)
	shareBtn:SetText(ns:L("DGN_WIN_SHARE"))
	shareBtn:SetScript("OnClick", function()
		local b = curDungeon and curDungeon.bosses and curDungeon.bosses[curIdx]
		if b and ns.ShareDungeonBossTips then
			ns.ShareDungeonBossTips(curDungeon.key, b.key)
		end
	end)
	f._chatBtn = chatBtn
	f._shareBtn = shareBtn

	-- Resize-grip rechtsonder: breedte vrij; hoogte snapt na afloop terug
	-- naar de tekstinhoud.
	local grip = CreateFrame("Button", nil, f)
	grip:SetSize(16, 16)
	grip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -6, 6)
	grip:SetFrameLevel(f:GetFrameLevel() + 5)
	grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	grip:SetScript("OnMouseDown", function()
		f:StartSizing("BOTTOMRIGHT")
	end)
	grip:SetScript("OnMouseUp", function()
		f:StopMovingOrSizing()
		local sw = f:GetWidth()
		if sw then
			GetWinSettings().w = math.max(MIN_W, math.min(MAX_W, sw))
		end
		SavePosition(f)
		ns.RefreshDungeonBossWindow()
	end)

	-- Zijpaneel: boss in vol ornaat, vastgeklikt links naast het venster,
	-- beweegt en schaalt mee; eigen X (keuze bewaard; mini-portret heropent).
	local panel = CreateFrame("Frame", nil, f, "BackdropTemplate")
	panel:SetWidth(PANEL_W)
	panel:SetPoint("TOPRIGHT", f, "TOPLEFT", -4, 0)
	panel:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", -4, 0)
	if panel.SetBackdrop then
		panel:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		panel:SetBackdropColor(0.05, 0.05, 0.09, 0.95)
	end
	panel:EnableMouse(true)
	HookDrag(panel) -- zijpaneel slepen = hoofdvenster meeslepen
	local panelClose = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
	panelClose:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -2, -2)
	panelClose:SetScript("OnClick", function()
		panelHiddenFor = curDungeon and curDungeon.key or nil
		ns.RefreshDungeonBossWindow()
		print("|cffffcc00MH:|r " .. ns:L("DGN_WIN_PANEL_HINT"))
	end)
	local panelModel = CreateFrame("PlayerModel", nil, panel)
	panelModel:SetPoint("TOPLEFT", panel, "TOPLEFT", 10, -12)
	panelModel:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 12)
	panelModel._mhFullBody = true
	-- In-venster draaibaar (Rob 14 jun): sleep = draaien, scroll = zoom. De
	-- hoek/zoom blijft bewaard over refreshes via _mhUserFacing/_mhUserZoom
	-- (SetModelCreature respecteert die). Shift-klik op het mini-model opent
	-- nog steeds de grote roteerbare popup.
	panelModel:EnableMouse(true)
	panelModel:EnableMouseWheel(true)
	panelModel:SetScript("OnMouseDown", function(self)
		self._mhDrag = true
		self._mhLastX = GetCursorPosition()
	end)
	panelModel:SetScript("OnMouseUp", function(self)
		self._mhDrag = false
	end)
	panelModel:SetScript("OnUpdate", function(self)
		if self._mhDrag then
			local x = GetCursorPosition()
			local dx = x - (self._mhLastX or x)
			self._mhLastX = x
			self._mhUserFacing = (self._mhUserFacing or 0.45) + dx * 0.012
			if self.SetFacing then
				pcall(self.SetFacing, self, self._mhUserFacing)
			end
		end
	end)
	panelModel:SetScript("OnMouseWheel", function(self, delta)
		-- Zoom via camera-afstand (gecentreerd). Scroll omhoog = dichterbij,
		-- omlaag = verder weg. Bewaard over refreshes via _mhCamScale.
		local prev = self._mhCamScale or 1.0
		self._mhCamScale = math.max(0.5, math.min(5.0, prev - (delta or 0) * 0.2))
		if self.SetCamDistanceScale then
			pcall(self.SetCamDistanceScale, self, self._mhCamScale)
		end
		-- Print alleen bij een echte wijziging (geen spam aan de eindstand) zodat
		-- Rob de fijne waarde kan doorgeven → vast in MODEL_CAMSCALE.
		if print and self._mhCamScale ~= prev then
			print(("|cffffcc00MH model-zoom:|r %.1f"):format(self._mhCamScale))
		end
	end)
	f._panel = panel
	f._panelModel = panelModel

	-- ESC sluit het venster (zonder de rest-van-de-dungeon-suppress; die
	-- is bewust alleen aan de X gekoppeld).
	if type(UISpecialFrames) == "table" then
		tinsert(UISpecialFrames, "MidnightHelperBossWindow")
	end

	win = f
	return f
end

local function BuildBossText(d, idx)
	local b = d and d.bosses and d.bosses[idx]
	if not b then
		return ""
	end
	local lines = {}
	local tips = ns.GetDungeonBossTips and ns.GetDungeonBossTips(d.key, b.key)
	if tips then
		if tips.steps then
			lines[#lines + 1] = ns:L(tips.steps)
		end
		if tips.tank then
			lines[#lines + 1] = "|cff" .. COLOR_TANK .. ns:L(tips.tank) .. "|r"
		end
		if tips.healer then
			lines[#lines + 1] = "|cff" .. COLOR_HEAL .. ns:L(tips.healer) .. "|r"
		end
		if tips.dps then
			lines[#lines + 1] = "|cff" .. COLOR_DPS .. ns:L(tips.dps) .. "|r"
		end
	else
		lines[#lines + 1] = "|cff" .. COLOR_DIMTXT .. ns:L("DGN_TIPS_SOON") .. "|r"
	end
	local text = table.concat(lines, "|n")
	if ns.ExpandDelveTipMarkup then
		text = ns:ExpandDelveTipMarkup(text)
	end
	return text
end

local function ApplyHeight(f)
	local body = f._body
	local lineH = (body.GetLineHeight and body:GetLineHeight()) or 14
	local numLines = (body.GetNumLines and body:GetNumLines()) or 1
	local bodyH = math.max(numLines * lineH + 6, 20)
	-- +22 voor de Chat/Share-knoppenrij onderin.
	f:SetHeight(HEADER_H + bodyH + PAD + 10 + 22)
end

function ns.RefreshDungeonBossWindow()
	if not win or not win:IsShown() or not curDungeon then
		return
	end
	local total = #(curDungeon.bosses or {})
	if curIdx > total then
		curIdx = 1
	end
	local b = curDungeon.bosses and curDungeon.bosses[curIdx]
	local bossName = b and ns.GetDungeonBossName
		and ns.GetDungeonBossName(b, curDungeon, curIdx) or "?"
	win._title:SetText(bossName)
	win._sub:SetText(ns.GetDungeonDisplayName
		and ns.GetDungeonDisplayName(curDungeon) or curDungeon.key)
	-- Knopbreedte volgt de naam (picker-knop, geen FontString meer).
	local subFs = win._sub.GetFontString and win._sub:GetFontString()
	win._sub:SetWidth(((subFs and subFs:GetStringWidth()) or 90) + 20)
	win._pager:SetText(total > 0 and (curIdx .. "/" .. total) or "-")
	win._body:SetText(BuildBossText(curDungeon, curIdx))

	modelGen = modelGen + 1
	-- Custom entries (Ritual Boss Coach) leveren hun (zelflerende)
	-- creatureId op de boss zelf, met seedCreatureId als web-geverifieerde
	-- fallback; roster-bosses via de CREATURES-map.
	local creatureID = (b and b.creatureId)
		or (b and b.seedCreatureId)
		or (b and CREATURES[curDungeon.key .. ":" .. b.key])
	win._previewCreatureID = creatureID -- voor de shift-klik-preview (hook C)
	win._previewName = bossName
	SetModelCreature(win._thumbModel, creatureID)
	-- Settings-toggle gateert nu alleen het grote zijpaneel; de thumb blijft.
	local settingOn = (not ns.IsBossWindowModelEnabled) or ns.IsBossWindowModelEnabled()
	local panelOn = ModelPanelEnabled() and creatureID ~= nil and settingOn
	win._panel:SetShown(panelOn)
	if panelOn then
		SetModelCreature(win._panelModel, creatureID)
	end

	ApplyHeight(win)
	-- Eerste meting na tonen/zetten kan stale zijn: nameting volgend frame.
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if win and win:IsShown() then
				ApplyHeight(win)
			end
		end)
	end
end

function ns.ShowDungeonBossWindow(dungeonKey, bossKey)
	local d = dungeonKey and FindDungeonByKey(dungeonKey) or DefaultDungeon()
	if not d then
		return
	end
	curDungeon = d
	curIdx = bossKey and FindBossIndex(d, bossKey) or 1
	local f = EnsureWindow()
	f:Show()
	ns.RefreshDungeonBossWindow()
end

-- Auto-open aan/uit (Rob 16 jun): de echte opt-out. Uit = het venster opent
-- nooit vanzelf (geen pull-open en geen target-open); /mh bosswin blijft werken.
-- Default aan. Vervangt het idee "wie hem niet wil klikt de X" door een
-- persistente keuze.
function ns.IsBossWindowAutoOpenEnabled()
	return GetWinSettings().autoOpen ~= false
end

function ns.SetBossWindowAutoOpenEnabled(v)
	GetWinSettings().autoOpen = v and true or false
end

-- 3D-bossmodel tonen in het boss-venster (standaard aan). Community-verzoek
-- 21 jun (gadrinonturalyon): checkbox om het model te verbergen.
function ns.IsBossWindowModelEnabled()
	return GetWinSettings().showModel ~= false
end

function ns.SetBossWindowModelEnabled(v)
	GetWinSettings().showModel = v and true or false
	if ns.RefreshDungeonBossWindow then
		ns.RefreshDungeonBossWindow() -- direct effect als het venster open is
	end
end

-- Settings-pagina: schaal live zetten (slider) en layout resetten.
function ns.SetBossWindowScale(sc)
	sc = tonumber(sc)
	if not sc then
		return
	end
	if sc < MIN_SCALE then
		sc = MIN_SCALE
	elseif sc > MAX_SCALE then
		sc = MAX_SCALE
	end
	GetWinSettings().scale = sc
	if win then
		SavePosition(win)
		win:SetScale(sc)
		ApplySavedPosition(win)
	end
end

function ns.GetBossWindowScale()
	return CurScale()
end

function ns.ResetBossWindowLayout()
	local s = GetWinSettings()
	s.x, s.y, s.w, s.scale = nil, nil, nil, nil
	if win then
		win:SetScale(1)
		win:SetWidth(DEFAULT_W)
		ApplySavedPosition(win)
		if win:IsShown() then
			ns.RefreshDungeonBossWindow()
		end
	end
end

-- Custom entries (Ritual Boss Coach, 12 jun): toon een synthetische
-- "dungeon"-tabel zonder roster-lookup. Tips lopen via dezelfde
-- ns.DUNGEON_TIPS-sleutel (de aanroeper registreert die zelf), namen via
-- b.name/d.name (eigennamen blijven EN), model via b.creatureId.
function ns.ShowBossWindowForEntry(d, bossKey)
	if type(d) ~= "table" or type(d.bosses) ~= "table" or not d.key then
		return
	end
	curDungeon = d
	curIdx = bossKey and FindBossIndex(d, bossKey) or 1
	local f = EnsureWindow()
	f:Show()
	ns.RefreshDungeonBossWindow()
end

-- X-suppress per boss raadpleegbaar, zodat een auto-open elders Robs
-- "laat deze boss met rust"-klik respecteert. (dungeonKey + bossKey.)
function ns.IsBossWindowSuppressedFor(dungeonKey, bossKey)
	return suppressedFor ~= nil and suppressedFor == SuppressKey(dungeonKey, bossKey)
end

function ns.IsBossWindowShowing(key)
	return (win and win:IsShown() and curDungeon and curDungeon.key == key) == true
end

-- Scenario verlaten/afgerond: venster sluiten als het nog deze entry toont.
function ns.HideBossWindowForEntry(key)
	if win and win:IsShown() and curDungeon and curDungeon.key == key then
		win:Hide()
	end
end

function ns.ToggleDungeonBossWindow()
	if win and win:IsShown() then
		win:Hide()
		return
	end
	suppressedFor = nil -- handmatig openen heft de suppress op
	ns.ShowDungeonBossWindow(curDungeon and curDungeon.key or nil,
		curDungeon and curDungeon.bosses and curDungeon.bosses[curIdx]
			and curDungeon.bosses[curIdx].key or nil)
end

-- Boss dood (ENCOUNTER_END success, via DungeonLiveCoach): automatisch
-- doorbladeren naar de volgende boss — geen wrap; bij de eindboss blijft
-- hij gewoon staan.
function ns.BossWindowOnEncounterEnd(dungeonKey, bossKey)
	if not win or not win:IsShown() or not curDungeon then
		return
	end
	if curDungeon.key ~= dungeonKey then
		return
	end
	local killedIdx = FindBossIndex(curDungeon, bossKey)
	local total = #(curDungeon.bosses or {})
	if killedIdx == curIdx and curIdx < total then
		curIdx = curIdx + 1
		ns.RefreshDungeonBossWindow()
	end
end

-- Hook vanuit DungeonLiveCoach bij ENCOUNTER_START: auto-open + meebladeren.
function ns.BossWindowOnEncounter(dungeonKey, bossKey)
	if not ns.IsBossWindowAutoOpenEnabled() then
		return -- in Settings uitgezet: nooit vanzelf openen
	end
	if suppressedFor and suppressedFor == SuppressKey(dungeonKey, bossKey) then
		return -- exact deze boss is weggeklikt: respecteren
	end
	suppressedFor = nil -- andere boss / nieuwe pull: suppress vervalt
	ns.ShowDungeonBossWindow(dungeonKey, bossKey)
end

-- Taalwissel ververst het open venster direct (Rob 12 jun: tekst bleef in
-- de oude taal tot je bladerde) — zelfde wrap-patroon als MidnightToast.
do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if win then
			if win._chatBtn then
				win._chatBtn:SetText(ns:L("DGN_WIN_CHAT"))
			end
			if win._shareBtn then
				win._shareBtn:SetText(ns:L("DGN_WIN_SHARE"))
			end
			if win:IsShown() then
				ns.RefreshDungeonBossWindow()
			end
		end
	end
end

-- Target-reopen (Rob 16 jun): een dungeon-boss targeten haalt het venster
-- terug en springt naar die boss — ook na een X (de X onderdrukt alleen de
-- pull-auto-open). De echte "uit" is de Settings-toggle hierboven.
-- npcID -> { dungeonKey, bossKey } afgeleid uit CREATURES (model-creature-IDs),
-- dus locale-onafhankelijk. Bossen zonder ID (bv. Nalorakk) of de tweede unit
-- van een duo missen we bewust — never-lie, niet gokken.
local NPC_TO_BOSS
local function EnsureNpcIndex()
	if NPC_TO_BOSS then
		return
	end
	NPC_TO_BOSS = {}
	for key, npcID in pairs(CREATURES) do
		local dk, bk = key:match("^(.-):(.+)$")
		if dk and bk then
			NPC_TO_BOSS[npcID] = { dk, bk }
		end
	end
end

-- 12.x: GUID's van boss-units kunnen 'secret' zijn — type() zegt "string"
-- maar strsplit erop tainted/crasht. Nooit string-ops op een secret value.
local function IsSecretValue(value)
	return issecretvalue ~= nil and value ~= nil and issecretvalue(value) == true
end

local function TargetNpcID()
	local guid = UnitGUID("target")
	if not guid or IsSecretValue(guid) then
		return nil
	end
	local kind, _, _, _, _, npcID = strsplit("-", guid)
	if kind ~= "Creature" and kind ~= "Vehicle" then
		return nil -- spelers/pets/objects negeren
	end
	return tonumber(npcID)
end

local targetFrame = CreateFrame("Frame")
targetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetFrame:SetScript("OnEvent", function()
	if not ns.IsBossWindowAutoOpenEnabled() then
		return
	end
	local inInst, instType = IsInInstance()
	if not inInst or instType ~= "party" then
		return -- alleen 5-mans (dungeons)
	end
	if not UnitExists("target") then
		return
	end

	local dungeonKey, bossKey
	local npcID = TargetNpcID()
	if npcID then
		EnsureNpcIndex()
		local hit = NPC_TO_BOSS[npcID]
		if hit then
			dungeonKey, bossKey = hit[1], hit[2] -- exacte boss via npcID
		end
	end

	-- Fallback: in instances kan de target-GUID 'secret' zijn (12.x), dan
	-- geeft TargetNpcID niets. Val terug op classificatie: alleen een echte
	-- boss heropent het venster, op de boss die nu vooraan staat.
	if not dungeonKey then
		if UnitClassification("target") ~= "worldboss" or not curDungeon then
			return
		end
		dungeonKey = curDungeon.key
		bossKey = curDungeon.bosses
			and curDungeon.bosses[curIdx]
			and curDungeon.bosses[curIdx].key
	end

	-- Staat het venster al op precies deze boss? Niet opnieuw tonen: voorkomt
	-- geflikker en het stelen van focus bij elke her-target.
	if
		ns.IsBossWindowShowing
		and ns.IsBossWindowShowing(dungeonKey)
		and curDungeon
		and curDungeon.bosses
		and curDungeon.bosses[curIdx]
		and curDungeon.bosses[curIdx].key == bossKey
	then
		return
	end
	suppressedFor = nil -- targeten heft de X-suppress op
	ns.ShowDungeonBossWindow(dungeonKey, bossKey)
end)
