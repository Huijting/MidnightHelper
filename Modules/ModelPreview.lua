--[[
	Model Preview — herbruikbare, roteerbare 3D-model-popup (Robs wens, 14 jun,
	geïnspireerd op Kaliel's Trackers reward-preview).

	ns.ShowModelPreview(spec | { spec, spec, ... }, title, startIndex)
	  spec = { itemID=, creatureID=, displayID=, mountID=, name= }
	  - sleep met de muis op het model = ronddraaien (yaw)
	  - scroll = zoom (best-effort)
	  - auto-spin-knop, reset-knop, en bij een lijst prev/next
	  - ESC of de X sluit

	ns.PreviewItem(itemID, name) — slim: mount-item → het mount-model; anders
	het item-model (decor/wapen/…). Pet-item valt terug op het item-model.

	Never-lie: puur cosmetisch/lezen; geen secret-data, geen taint.
]]

local _, ns = ...

local pv -- de (eenmalig gebouwde) popup

-- Zet het juiste model op basis van de spec (eerst creature/display, dan item).
local function ApplyModelSpec(model, spec)
	if not (model and spec) then
		return
	end
	if model.ClearModel then
		pcall(model.ClearModel, model)
	end
	if spec.creatureID and model.SetCreature then
		pcall(model.SetCreature, model, spec.creatureID)
	elseif spec.displayID and model.SetDisplayInfo then
		pcall(model.SetDisplayInfo, model, spec.displayID)
	elseif spec.tryOn and model.SetUnit and model.TryOn then
		-- Draagbaar item → op je eigen personage passen (transmog-stijl).
		pcall(model.SetUnit, model, "player")
		pcall(model.TryOn, model, spec.tryOn)
	elseif spec.itemID and model.SetItem then
		pcall(model.SetItem, model, spec.itemID)
	end
	-- Framing + startrotatie.
	if model.SetPosition then
		pcall(model.SetPosition, model, 0, 0, 0)
	end
	model._mhFacing = 0.6
	if model.SetFacing then
		pcall(model.SetFacing, model, model._mhFacing)
	end
end

local function ShowIndex()
	if not pv then
		return
	end
	local spec = pv.list and pv.list[pv.index]
	if not spec then
		return
	end
	pv.title:SetText(tostring(spec.name or pv.fallbackTitle or "Preview"))
	ApplyModelSpec(pv.model, spec)
	-- Async nalaad-tik: SetCreature/SetItem rendert de eerste frame soms leeg.
	local gen = (pv._gen or 0) + 1
	pv._gen = gen
	if C_Timer and C_Timer.After then
		C_Timer.After(0.15, function()
			if pv and pv._gen == gen and pv:IsShown() then
				ApplyModelSpec(pv.model, spec)
			end
		end)
	end
	-- Prev/next alleen tonen bij een lijst.
	local multi = pv.list and #pv.list > 1
	pv.prevBtn:SetShown(multi)
	pv.nextBtn:SetShown(multi)
	pv.counter:SetShown(multi)
	if multi then
		pv.counter:SetText(("%d / %d"):format(pv.index, #pv.list))
	end
end

local function BuildPreview()
	if pv then
		return pv
	end
	local f = CreateFrame("Frame", "MidnightHelperModelPreview", UIParent, "BackdropTemplate")
	f:SetSize(320, 400)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 24,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.09, 0.96)
	end
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function()
		f:StartMoving()
	end)
	f:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
	end)

	local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -12)
	title:SetPoint("RIGHT", f, "RIGHT", -34, 0)
	title:SetJustifyH("LEFT")
	title:SetTextColor(1, 0.82, 0.2)
	f.title = title

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)

	-- Het model zelf (sleepbaar = draaien, scroll = zoom). DressUpModel zodat we
	-- naast creature/display/item óók draagbare gear op je personage kunnen tonen.
	local model = CreateFrame("DressUpModel", nil, f)
	model:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -40)
	model:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 44)
	model:EnableMouse(true)
	model:EnableMouseWheel(true)
	f.model = model

	model:SetScript("OnMouseDown", function(self)
		self._mhDragging = true
		self._mhAuto = false
		local x = GetCursorPosition()
		self._mhLastX = x
	end)
	model:SetScript("OnMouseUp", function(self)
		self._mhDragging = false
	end)
	model:SetScript("OnUpdate", function(self, elapsed)
		if self._mhDragging then
			local x = GetCursorPosition()
			local dx = x - (self._mhLastX or x)
			self._mhLastX = x
			self._mhFacing = (self._mhFacing or 0) + dx * 0.012
			if self.SetFacing then
				pcall(self.SetFacing, self, self._mhFacing)
			end
		elseif self._mhAuto then
			self._mhFacing = (self._mhFacing or 0) + (elapsed or 0) * 0.5
			if self.SetFacing then
				pcall(self.SetFacing, self, self._mhFacing)
			end
		end
	end)
	model:SetScript("OnMouseWheel", function(self, delta)
		-- Best-effort zoom: SetPortraitZoom waar ondersteund (0 = volledig,
		-- ~face bij 1). Gefaald = geen probleem, rotatie blijft werken.
		self._mhZoom = math.max(0, math.min(0.9, (self._mhZoom or 0) + (delta or 0) * 0.1))
		if self.SetPortraitZoom then
			pcall(self.SetPortraitZoom, self, self._mhZoom)
		end
	end)

	-- Knoppenrij onderaan: prev · spin · reset · next.
	local prevBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	prevBtn:SetSize(28, 22)
	prevBtn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 12)
	prevBtn:SetText("<")
	prevBtn:SetScript("OnClick", function()
		if pv.list and #pv.list > 1 then
			pv.index = (pv.index - 2) % #pv.list + 1
			ShowIndex()
		end
	end)
	f.prevBtn = prevBtn

	local nextBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	nextBtn:SetSize(28, 22)
	nextBtn:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
	nextBtn:SetText(">")
	nextBtn:SetScript("OnClick", function()
		if pv.list and #pv.list > 1 then
			pv.index = pv.index % #pv.list + 1
			ShowIndex()
		end
	end)
	f.nextBtn = nextBtn

	local spinBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	spinBtn:SetSize(70, 22)
	spinBtn:SetText(ns:L("MODEL_PREVIEW_SPIN"))
	spinBtn:SetPoint("BOTTOM", f, "BOTTOM", -38, 12)
	spinBtn:SetScript("OnClick", function()
		model._mhAuto = not model._mhAuto
	end)

	local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	resetBtn:SetSize(70, 22)
	resetBtn:SetText(ns:L("MODEL_PREVIEW_RESET"))
	resetBtn:SetPoint("BOTTOM", f, "BOTTOM", 38, 12)
	resetBtn:SetScript("OnClick", function()
		model._mhFacing = 0.6
		model._mhZoom = 0
		if model.SetFacing then
			pcall(model.SetFacing, model, model._mhFacing)
		end
		if model.SetPortraitZoom then
			pcall(model.SetPortraitZoom, model, 0)
		end
	end)

	local counter = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	counter:SetPoint("BOTTOM", f, "BOTTOM", 0, 36)
	f.counter = counter

	local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	hint:SetPoint("TOP", f, "TOP", 0, -32)
	hint:SetText(ns:L("MODEL_PREVIEW_HINT"))
	hint:SetTextColor(0.6, 0.62, 0.68)

	if type(UISpecialFrames) == "table" then
		tinsert(UISpecialFrames, "MidnightHelperModelPreview")
	end

	pv = f
	return f
end

-- Publiek: toon een spec of een lijst van specs.
function ns.ShowModelPreview(specOrList, title, startIndex)
	if not specOrList then
		return
	end
	BuildPreview()
	local list = specOrList[1] and specOrList or { specOrList }
	pv.list = list
	pv.index = startIndex or 1
	pv.fallbackTitle = title
	pv:Show()
	ShowIndex()
end

-- Publiek: bouw een model-spec voor een item-ID (mount-item → mount-model;
-- draagbaar → op je personage passen; anders een los wereldmodel). Gebruikt door
-- PreviewItem én door de reward-gallery (lijst van specs).
function ns.ResolveItemSpec(itemID, name)
	itemID = tonumber(itemID)
	if not itemID then
		return nil
	end
	local spec = { name = name }

	-- 1. Mount-item → het mount-model.
	local isMount = false
	if C_MountJournal and C_MountJournal.GetMountFromItem then
		local okM, mountID = pcall(C_MountJournal.GetMountFromItem, itemID)
		if okM and mountID and C_MountJournal.GetMountInfoExtraByID then
			local okX, displayID = pcall(C_MountJournal.GetMountInfoExtraByID, mountID)
			if okX and displayID then
				spec.displayID = displayID
				isMount = true
			end
		end
	end

	-- 2. Draagbaar item (wapen/armor) → op je personage passen; anders een los
	--    wereldmodel (decor/toy/wapen-zonder-slot via SetItem).
	if not isMount then
		local equipLoc
		if C_Item and C_Item.GetItemInfoInstant then
			local ok, _, _, _, loc = pcall(C_Item.GetItemInfoInstant, itemID)
			if ok then
				equipLoc = loc
			end
		end
		if equipLoc and equipLoc ~= "" then
			spec.tryOn = itemID
		else
			spec.itemID = itemID
		end
	end

	if not spec.name and C_Item and C_Item.GetItemNameByID then
		local okN, nm = pcall(C_Item.GetItemNameByID, itemID)
		if okN and nm then
			spec.name = nm
		end
	end
	return spec
end

-- Publiek: preview één item op ID.
function ns.PreviewItem(itemID, name)
	local spec = ns.ResolveItemSpec(itemID, name)
	if spec then
		ns.ShowModelPreview(spec, spec.name)
	end
end

-- Publiek: preview een creature/boss op npcID.
function ns.PreviewCreature(creatureID, name)
	creatureID = tonumber(creatureID)
	if not creatureID then
		return
	end
	ns.ShowModelPreview({ creatureID = creatureID, name = name }, name)
end
