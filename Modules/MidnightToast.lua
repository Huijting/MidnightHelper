--[[
	Midnight Helper - Event-style toast notifications (achievement / loot toast look).
	Queue-based; click optional. Phase 1: Trovehunter's Bounty in delves.
]]

local _, ns = ...

local Config = ns.Config or {}
local ITEM_TREASURE = Config.DELVE_ITEM_TROVEHUNTER_BOUNTY or 252415

local TOAST_W = 320
local TOAST_H = 64
local ICON_SIZE = 40
local ICON_PAD_L = 14
local DISPLAY_SEC = 4.25
local FADE_IN_SEC = 0.35
local FADE_OUT_SEC = 0.45
local GAP_SEC = 0.2

local toastFrame
local queue = {}
local activeSpec
local hideTimer
local fadeGen = 0

local function GetToastSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, delveBounty = true }
	end
	if type(ui.toast) ~= "table" then
		ui.toast = { enabled = true, delveBounty = true }
	end
	return ui.toast
end

local function ResolveText(spec, field)
	if not spec then
		return ""
	end
	local key = spec[field .. "Key"]
	if key and ns.L then
		local s = ns:L(key)
		if s and s ~= key then
			return s
		end
	end
	return spec[field] or ""
end

local function ResolveItemIcon(spec)
	if spec.icon then
		return spec.icon
	end
	local itemID = spec.itemID or ITEM_TREASURE
	if ns.GetDelveItemIcon then
		return ns:GetDelveItemIcon(itemID)
	end
	if C_Item and C_Item.GetItemIconByID then
		local ok, tex = pcall(C_Item.GetItemIconByID, itemID)
		if ok and tex then
			return tex
		end
	end
	return 134414
end

local function ApplyItemQualityBorder(iconRing, itemID)
	if not iconRing or not itemID then
		return
	end
	local r, g, b = 1, 0.75, 0.15
	if C_Item and C_Item.GetItemQualityByID and ITEM_QUALITY_COLORS then
		local ok, quality = pcall(C_Item.GetItemQualityByID, itemID)
		if ok and quality and ITEM_QUALITY_COLORS[quality] then
			local c = ITEM_QUALITY_COLORS[quality].color
			if c then
				r, g, b = c:GetRGB()
			end
		end
	end
	if iconRing.SetVertexColor then
		iconRing:SetVertexColor(r, g, b, 0.95)
	end
end

local function ApplyToastContent(spec)
	local root = toastFrame and toastFrame.content
	if not root or not spec then
		return
	end
	local itemID = spec.itemID or ITEM_TREASURE
	local iconTex = ResolveItemIcon(spec)
	-- spec.npcId → toon het 3D-model van de NPC i.p.v. het icoon. Als het
	-- model (nog) niet beschikbaar is rendert het slot leeg; bij een
	-- rare-alert staat de NPC vlakbij, dus het model is dan vrijwel altijd
	-- al door de client geladen.
	local showModel = false
	local npcId = tonumber(spec.npcId)
	if npcId and root.model then
		showModel = pcall(function()
			root.model:ClearModel()
			root.model:SetCreature(npcId)
			-- Hogere zoom = model vult het frame i.p.v. klein in een hoek;
			-- lichte draai voor een 3/4-aanzicht.
			if root.model.SetPortraitZoom then
				root.model:SetPortraitZoom(0.85)
			end
			if root.model.SetPosition then
				root.model:SetPosition(0, 0, 0)
			end
			if root.model.SetFacing then
				root.model:SetFacing(0.45)
			end
		end) == true
	end
	if root.model then
		root.model:SetShown(showModel)
	end
	if root.icon then
		root.icon:SetTexture(iconTex)
		root.icon:SetShown(not showModel)
	end
	if root.iconSlot then
		-- Slot (incl. kwaliteitsring) weg zodra het model toont — het model
		-- staat los van het slot en een lege ring oogt kapot.
		root.iconSlot:SetShown(not showModel)
	end
	if root.iconRing then
		ApplyItemQualityBorder(root.iconRing, itemID)
	end
	local title = ResolveText(spec, "title")
	local body = ResolveText(spec, "body")
	-- GEEN hardcoded fallback-tekst meer. Hier stond "Trovehunter Bounty detected!"
	-- / "Use it for Hidden Treasure." als default — een restant van toen dit systeem
	-- alleen voor die ene toast bestond. Gevolg: ELKE toast zonder titel toonde de
	-- bountytekst, ook in een follower dungeon waar geen bounty bestaat. Dat is de
	-- "spook-bounty" waar Rob 19 jul twee dagen achteraan heeft gezeten. Leeg = leeg.
	if root.title then
		root.title:SetText(title)
		root.title:SetShown(title ~= "")
	end
	if root.body then
		root.body:SetText(body)
		root.body:SetShown(body ~= "")
	end
end

local function EnsureToastFrame()
	if toastFrame then
		return toastFrame
	end

	local f = CreateFrame("Button", "MidnightHelperToast", UIParent, "BackdropTemplate")
	f:SetSize(TOAST_W, TOAST_H)
	f:SetPoint("TOP", UIParent, "TOP", 0, -118)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetFrameLevel(120)
	f:Hide()
	f:EnableMouse(true)
	f:RegisterForClicks("LeftButtonUp")

	-- Versleepbaar (Rob 11 jun); positie wordt bewaard in ui.toast.pos als
	-- offset t.o.v. het midden van UIParent (schaal-onafhankelijk, zodat een
	-- 2×-rare-toast en een 1×-shard-toast op dezelfde plek verschijnen).
	-- Klik = waypoint blijft werken: drag start pas na de drag-drempel.
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local s = GetToastSettings()
		local scale = self:GetScale() or 1
		local cx, cy = self:GetCenter()
		if cx and cy and UIParent then
			s.pos = {
				x = cx * scale - (UIParent:GetWidth() / 2),
				y = cy * scale - (UIParent:GetHeight() / 2),
			}
		end
	end)

	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.07, 0.06, 0.1, 0.94)
		f:SetBackdropBorderColor(1, 0.82, 0.2, 1)
	end

	-- Child frame above backdrop paint (BackdropTemplate can cover direct children).
	local content = CreateFrame("Frame", nil, f)
	content:SetAllPoints()
	content:SetFrameLevel(f:GetFrameLevel() + 10)
	-- SetPropagateMouseClicks/-Motion are combat-protected. The eager
	-- creation at the bottom of this file makes in-combat creation
	-- impossible; the lockdown guard is belt-and-braces (worst case the
	-- toast misses click-propagation instead of tripping ADDON_ACTION_BLOCKED).
	local canSetPropagate = not InCombatLockdown()
	if canSetPropagate and content.SetPropagateMouseClicks then
		content:SetPropagateMouseClicks(true)
	end
	if canSetPropagate and content.SetPropagateMouseMotion then
		content:SetPropagateMouseMotion(true)
	end
	f.content = content

	local iconSlot = CreateFrame("Frame", nil, content)
	iconSlot:SetSize(ICON_SIZE + 4, ICON_SIZE + 4)
	iconSlot:SetPoint("LEFT", content, "LEFT", ICON_PAD_L, 0)
	if canSetPropagate and iconSlot.SetPropagateMouseClicks then
		iconSlot:SetPropagateMouseClicks(true)
	end
	content.iconSlot = iconSlot

	local icon = iconSlot:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("TOPLEFT", iconSlot, "TOPLEFT", 2, -2)
	icon:SetPoint("BOTTOMRIGHT", iconSlot, "BOTTOMRIGHT", -2, 2)
	content.icon = icon

	-- 3D-model van de NPC (eigen implementatie met Blizzards PlayerModel-API;
	-- idee afgekeken van RareScanner, code/data niet — die is All Rights
	-- Reserved). SetCreature(npcID) laat de client zelf het model resolven
	-- (zelfde aanpak als DBM-GUI en MDT), dus geen displayID-database nodig.
	-- Model in een clip-container (Rob 12 jun: het model stak onder de
	-- gouden rand uit — PlayerModels renderen buiten hun frame-rect en
	-- 56px paste sowieso niet in de ~42px binnenruimte). De container
	-- blijft binnen de backdrop-insets en SetClipsChildren kapt de rest af.
	local modelClip = CreateFrame("Frame", nil, content)
	modelClip:SetPoint("TOPLEFT", content, "TOPLEFT", 11, -11)
	modelClip:SetPoint("BOTTOMLEFT", content, "BOTTOMLEFT", 11, 11)
	modelClip:SetWidth(52)
	if modelClip.SetClipsChildren then
		modelClip:SetClipsChildren(true)
	end
	local model = CreateFrame("PlayerModel", nil, modelClip)
	model:SetAllPoints(modelClip)
	model:EnableMouse(false)
	model:Hide()
	content.model = model

	local iconRing = iconSlot:CreateTexture(nil, "OVERLAY")
	iconRing:SetPoint("TOPLEFT", iconSlot, "TOPLEFT", -3, 3)
	iconRing:SetPoint("BOTTOMRIGHT", iconSlot, "BOTTOMRIGHT", 3, -3)
	content.iconRing = iconRing
	if iconRing.SetAtlas then
		local ok = pcall(function()
			iconRing:SetAtlas("loottoast-itemborder", true)
		end)
		if not ok then
			iconRing:SetTexture("Interface\\COMMON\\WhiteIconFrame")
		end
	else
		iconRing:SetTexture("Interface\\COMMON\\WhiteIconFrame")
	end
	ApplyItemQualityBorder(iconRing, ITEM_TREASURE)

	local textLeft = ICON_PAD_L + ICON_SIZE + 16
	local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", content, "TOPLEFT", textLeft, -10)
	title:SetPoint("TOPRIGHT", content, "TOPRIGHT", -12, -10)
	title:SetHeight(16)
	title:SetJustifyH("LEFT")
	title:SetJustifyV("TOP")
	title:SetTextColor(1, 0.84, 0.2)
	content.title = title

	local body = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
	body:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -12, 10)
	body:SetJustifyH("LEFT")
	body:SetJustifyV("TOP")
	body:SetWordWrap(true)
	body:SetTextColor(0.95, 0.95, 0.95)
	content.body = body

	f:SetScript("OnClick", function()
		-- Shift-klik op een rare-toast → grote roteerbare preview (hook C);
		-- normale klik blijft de bestaande actie (waypoint/route) doen.
		if IsShiftKeyDown() and activeSpec and activeSpec.npcId and ns.PreviewCreature then
			local nm = ResolveText(activeSpec, "title")
			ns.PreviewCreature(activeSpec.npcId, nm ~= "" and nm or nil)
			return
		end
		if activeSpec and activeSpec.onClick then
			activeSpec.onClick(activeSpec)
		end
	end)

	f:SetScript("OnEnter", function(self)
		if activeSpec and activeSpec.onClick then
			if self.EnableMouse then
				self:EnableMouse(true)
			end
			if SetCursor then
				SetCursor("Interface\\CURSOR\\Point")
			end
			if GameTooltip then
				-- Per-toast hint (spec.clickHintKey); de generieke fallback is
				-- de oude delve-tekst — alleen nog voor de delve-bounty-toast.
				local hintKey = activeSpec.clickHintKey or "TOAST_CLICK_HINT"
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(ns:L(hintKey), 1, 1, 1)
				GameTooltip:Show()
			end
		end
	end)
	f:SetScript("OnLeave", function()
		if ResetCursor then
			ResetCursor()
		end
		if GameTooltip then
			GameTooltip:Hide()
		end
	end)

	toastFrame = f
	return f
end

local function CancelHideTimer()
	-- hideTimer is a C_Timer.NewTimer handle; Cancel() lives on the handle
	-- itself (C_Timer.Cancel does not exist, and C_Timer.After returns nothing).
	if hideTimer and hideTimer.Cancel then
		pcall(hideTimer.Cancel, hideTimer)
	end
	hideTimer = nil
end

local function FinishToast()
	CancelHideTimer()
	activeSpec = nil
	if toastFrame then
		toastFrame:Hide()
		toastFrame:SetAlpha(1)
	end
	if #queue > 0 and C_Timer and C_Timer.After then
		C_Timer.After(GAP_SEC, function()
			if ns.ShowNextMidnightToast then
				ns:ShowNextMidnightToast()
			end
		end)
	end
end

local function StartHideTimer()
	CancelHideTimer()
	if not (C_Timer and C_Timer.After) then
		return
	end
	local dur = (activeSpec and tonumber(activeSpec.displaySec)) or DISPLAY_SEC
	if not C_Timer.NewTimer then
		return
	end
	-- NewTimer (not After): returns a cancellable handle so CancelHideTimer can
	-- stop an orphaned timer from fading out the *next* toast in the queue.
	hideTimer = C_Timer.NewTimer(dur, function()
		hideTimer = nil
		if not toastFrame or not toastFrame:IsShown() then
			FinishToast()
			return
		end
		fadeGen = fadeGen + 1
		local gen = fadeGen
		if UIFrameFadeOut then
			UIFrameFadeOut(toastFrame, FADE_OUT_SEC, toastFrame:GetAlpha(), 0)
		end
		C_Timer.After(FADE_OUT_SEC + 0.05, function()
			if gen ~= fadeGen then
				return
			end
			FinishToast()
		end)
	end)
end

function ns.ShowNextMidnightToast()
	if activeSpec or #queue == 0 then
		return
	end
	local s = GetToastSettings()
	if not s.enabled then
		wipe(queue)
		return
	end

	local spec = table.remove(queue, 1)

	-- Een toast zonder titel én zonder tekst heeft niets te melden: laten vallen in
	-- plaats van een leeg venster tonen. (Zolang ApplyToastContent hier hardcoded
	-- bountytekst invulde, wérd zo'n lege toast een valse "Trovehunter Bounty
	-- detected!" — Rob 19 jul. De fallback is weg; dit houdt het venster ook leeg-vrij.)
	while spec and ResolveText(spec, "title") == "" and ResolveText(spec, "body") == "" do
		spec = table.remove(queue, 1)
	end
	if not spec then
		return
	end

	activeSpec = spec
	-- Log elke getoonde toast (id + tijd). Op queue-niveau loggen bleek te weinig:
	-- de bounty-toast verscheen in een follower dungeon terwijl geen enkele bekende
	-- afzender 'm had gequeued. Hier zie je WAT er in beeld kwam, wie het ook stuurde.
	-- Opgeruimd (2026-07-19): hier stond een SavedVariables-logboek van elke getoonde
	-- toast. Dat was diagnostiek voor de "spook-bounty" — die is opgelost (de
	-- hardcoded fallback-tekst in ApplyToastContent), dus het logboek kan weg.
	-- onShow: pas hier weet de afzender zeker dat de toast écht in beeld komt.
	-- Nodig voor "1× per week"-meldingen (ShardCapAlert): een gequeued-maar-
	-- nooit-getoonde toast (reload terwijl een rare-toast voorstond — Rob,
	-- 11 jun) mag de week-dedupe niet verbruiken.
	if spec.onShow then
		pcall(spec.onShow, spec)
	end
	-- Optioneel geluid bij tonen (spec.soundKit). Master-kanaal zodat het ook
	-- bij lage SFX-volumes hoorbaar is — zelfde keuze als de rare-alert.
	if spec.soundKit and PlaySound then
		pcall(PlaySound, spec.soundKit, "Master")
	end
	local f = EnsureToastFrame()
	-- Schaal per toast (spec.scale, default 1) + bewaarde/standaard positie.
	-- SetPoint-offsets zijn in frame-lokale (geschaalde) coördinaten → delen
	-- door de schaal houdt de schermpositie gelijk voor elke toast-grootte.
	local scale = tonumber(spec.scale) or 1
	f:SetScale(scale)
	f:ClearAllPoints()
	local pos = GetToastSettings().pos
	if type(pos) == "table" and tonumber(pos.x) and tonumber(pos.y) then
		f:SetPoint("CENTER", UIParent, "CENTER", pos.x / scale, pos.y / scale)
	else
		f:SetPoint("TOP", UIParent, "TOP", 0, -118 / scale)
	end
	ApplyToastContent(spec)
	f:SetAlpha(1)
	f:Show()
	if f.content then
		f.content:Show()
	end
	if f.Raise then
		f:Raise()
	end
	fadeGen = fadeGen + 1
	if UIFrameFadeIn then
		f:SetAlpha(0)
		UIFrameFadeIn(f, FADE_IN_SEC, 0, 1)
	else
		f:SetAlpha(1)
	end
	StartHideTimer()
end

function ns.QueueMidnightToast(spec)
	if type(spec) ~= "table" then
		return
	end
	local s = GetToastSettings()
	if not s.enabled then
		return
	end
	if spec.id then
		for i = 1, #queue do
			if queue[i].id == spec.id then
				return
			end
		end
		if activeSpec and activeSpec.id == spec.id then
			return
		end
	end
	queue[#queue + 1] = spec
	if not activeSpec then
		ns.ShowNextMidnightToast()
	end
end

function ns.ClearMidnightToastQueue()
	wipe(queue)
	activeSpec = nil
	CancelHideTimer()
	fadeGen = fadeGen + 1
	if toastFrame then
		toastFrame:Hide()
	end
end

do
	local orig = ns.RefreshLocaleUI
	function ns:RefreshLocaleUI()
		if orig then
			orig(self)
		end
		if activeSpec and toastFrame and toastFrame:IsShown() then
			ApplyToastContent(activeSpec)
		end
	end
end

-- Create the toast frame eagerly at load time. SetPropagateMouseClicks/-Motion
-- are combat-protected; with lazy creation the first toast could fire mid-
-- combat (Rob, 10 Jun: logged into a rare fight -> ADDON_ACTION_BLOCKED at
-- line ~148). Addon files load during the loading screen, where combat
-- lockdown is impossible, so the protected setters run safely exactly once.
EnsureToastFrame()
