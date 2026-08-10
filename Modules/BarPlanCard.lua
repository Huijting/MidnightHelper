local _, ns = ...

--[[
	Midnight Helper — where to put your bars (`/mh bars plan`).

	The Layout page answers "which key does what". It has never answered "where do my bars
	go", and that is the half Rob was missing: he had the keys right and a screen that
	still looked, in his word, like gatenkaas.

	This is the other half. Bar by bar, in the order to place them, with the width to set
	and how much of it this spec actually fills.

	⚠️ The widths are MEASURED across all 39 specs, not chosen: numbers peak at 5, letters
	at 8, shift-numbers at 7 (Affliction Warlock), shift-letters at 8 (Guardian and
	Restoration Druid), the F-row at 4, Ctrl at 6. Six is Edit Mode's minimum so anything
	under it is rounded up. Set these and one arrangement works on every character.
]]

local ORDER_HINT = {
	[1] = "onderaan, gecentreerd onder je personage",
	[2] = "direct erboven",
	[4] = "daarboven",
	[3] = "daarboven",
	[5] = "apart, rechts van de stapel",
	[6] = "onder balk 5, ook apart",
}

--- The order to place them in, not the order of their numbers. Most-pressed nearest the
--- character; the two sparse bars last and off to the side, because between the others
--- they read as the gap the whole exercise was about removing.
local PLACE_ORDER = { 1, 2, 4, 3, 5, 6 }

local card

local function Build()
	if card then
		return card
	end
	local f = CreateFrame("Frame", "MidnightHelperBarPlanCard", UIParent, "BackdropTemplate")
	f:SetSize(430, 300)
	f:SetPoint("CENTER", UIParent, "CENTER", 260, 0)
	f:SetFrameStrata("DIALOG")
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		ns.ApplyMidnightDialogBackdrop(f)
	end
	if ns.RegisterMidnightDialogPopup then
		ns.RegisterMidnightDialogPopup(f)
	end

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.title:SetPoint("TOPLEFT", 16, -14)
	f.title:SetText("Waar je balken komen")

	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.sub:SetPoint("TOPLEFT", 16, -38)
	f.sub:SetPoint("TOPRIGHT", -16, -38)
	f.sub:SetJustifyH("LEFT")
	f.sub:SetText("Edit Mode -> de balk -> aantal knoppen. Plaats ze in deze volgorde.")

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.body:SetPoint("TOPLEFT", 16, -62)
	f.body:SetPoint("TOPRIGHT", -16, -62)
	f.body:SetJustifyH("LEFT")
	f.body:SetSpacing(3)

	f.foot = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.foot:SetPoint("BOTTOMLEFT", 16, 14)
	f.foot:SetPoint("BOTTOMRIGHT", -16, 14)
	f.foot:SetJustifyH("LEFT")

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	card = f
	return f
end

--- `/mh bars plan`
function ns.MH_ShowBarPlan()
	if not ns.MH_BarPlanSummary then
		return
	end
	local rows = ns.MH_BarPlanSummary()
	local byIndex = {}
	for _, r in ipairs(rows) do
		byIndex[r.barIndex] = r
	end

	local lines, step = {}, 0
	for _, idx in ipairs(PLACE_ORDER) do
		local r = byIndex[idx]
		if r then
			step = step + 1
			--- Say what is on it AND how full it is. A bar showing 1 of 6 is not broken —
			--- it is a spec that does not use that layer — and seeing the number stops
			--- that looking like a mistake.
			local fill = ("|cff9d9d9d%d van de %d in gebruik|r"):format(r.used, r.size)
			if r.used == r.size then
				fill = "|cff40c040vol|r"
			end
			lines[#lines + 1] = ("|cffffd100%d.|r  balk |cffffffff%d|r  ·  |cffffffff%d|r knoppen  ·  %s\n     |cff9d9d9d%s — %s|r")
				:format(step, r.barIndex, r.size, fill,
					tostring(r.label), tostring(ORDER_HINT[idx] or ""))
		end
	end

	local f = Build()
	f.body:SetText(table.concat(lines, "\n"))
	f.foot:SetText("Balk 7 en 8 blijven van jou. Waar je een balk neerzet maakt niets uit "
		.. "voor je toetsen — die hangen aan het vakje, niet aan de plek op je scherm.")
	f:SetHeight(96 + step * 34)
	f:Show()
end
