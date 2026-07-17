local _, ns = ...

--[[
	Midnight Helper — Pawn stat-weight export.

	Turns the weights the Great Vault advisor / loot tips already score with into a
	Pawn scale string you can paste into the Pawn addon.

	NEVER-LIE, and this is the whole point of the labelling: these weights are
	GUIDE-BASED priority (Icy Veins / Wowhead), normalised so the top secondary = 1.00.
	They are NOT a SimulationCraft result. The copy box says so, in the box itself, so
	nobody mistakes an ordinal ordering for simmed precision. Want exact numbers? Sim
	your own character. The primary stat gets a fixed lead (a primary is essentially
	always the strongest stat) — sensible ordering, not a measured ratio.

	The weights come from ns.GetCurrentSpecWeights() rather than a rebuilt key, so the
	export follows the advisor's own hero-talent and content-profile resolution. If that
	ever changes, this follows for free.

	Scale format verified against the INSTALLED Pawn (not assumed):
	  • Pawn.lua PawnCurrentScaleVersion = 1
	  • PawnParseScaleTag expects  ( Pawn: v1: "Name": Stat=value, ... )
	  • Stat identifiers from Pawn's own ScaleTemplates.lua: Strength / Agility /
	    Intellect, CritRating, HasteRating, MasteryRating, Versatility.
]]

-- priorityText starts with the primary stat word; these are Pawn's identifiers.
local PRIMARY_PAWN = { Strength = "Strength", Agility = "Agility", Intellect = "Intellect" }
local PRIMARY_LEAD = 2.0 -- above the top secondary (1.00). Ordinal, not simmed.

-- META carries priorityText ("Strength > Crit > ..."). It has _HERO_/_MPLUS keys too,
-- but fall back to the plain spec key so a missing variant still names a primary.
local function metaFor(key)
	local meta = ns.VAULT_ADVISOR_SPEC_META
	if not (meta and key) then
		return nil
	end
	if meta[key] then
		return meta[key]
	end
	local base = key:gsub("_HERO_%d+$", ""):gsub("_MPLUS$", "")
	return meta[base]
end

--- Build the Pawn scale string for the player's current spec.
--- @return string|nil tag, string|nil reason  ("nospec" | "nodata")
function ns.BuildPawnString()
	if not (GetSpecialization and GetSpecializationInfo) then
		return nil, "nospec"
	end
	local idx = GetSpecialization()
	if not idx then
		return nil, "nospec"
	end
	local _, specName = GetSpecializationInfo(idx)

	local w, key = nil, nil
	if ns.GetCurrentSpecWeights then
		local ok, a, b = pcall(ns.GetCurrentSpecWeights)
		if ok then
			w, key = a, b
		end
	end
	if type(w) ~= "table" then
		return nil, "nodata"
	end

	local meta = metaFor(key)
	local primaryWord = meta and meta.priorityText and meta.priorityText:match("^(%a+)")
	local primaryStat = primaryWord and PRIMARY_PAWN[primaryWord]

	local parts = {}
	if primaryStat then
		parts[#parts + 1] = ("%s=%.2f"):format(primaryStat, PRIMARY_LEAD)
	end
	if w.crit then
		parts[#parts + 1] = ("CritRating=%.2f"):format(w.crit)
	end
	if w.haste then
		parts[#parts + 1] = ("HasteRating=%.2f"):format(w.haste)
	end
	if w.mastery then
		parts[#parts + 1] = ("MasteryRating=%.2f"):format(w.mastery)
	end
	if w.vers then
		parts[#parts + 1] = ("Versatility=%.2f"):format(w.vers)
	end
	if #parts == 0 then
		return nil, "nodata"
	end

	return ("( Pawn: v1: \"MH %s\": %s )"):format(specName or "Scale", table.concat(parts, ", "))
end

--------------------------------------------------------------------------------
-- Copy box
--------------------------------------------------------------------------------

local frame

local function ensureFrame()
	if frame then
		return frame
	end
	local f = CreateFrame("Frame", "MidnightHelperPawnCopyBox", UIParent, "BackdropTemplate")
	f:SetSize(470, 140)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if f.SetBackdrop then
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
	end

	f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.title:SetPoint("TOP", 0, -16)

	-- The honesty line lives IN the box, not in a tooltip: whoever pastes this into
	-- Pawn should read "guide priority, not a sim" without having to look for it.
	f.sub = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.sub:SetPoint("TOPLEFT", 16, -36)
	f.sub:SetPoint("TOPRIGHT", -16, -36)
	f.sub:SetJustifyH("LEFT")
	f.sub:SetSpacing(2)

	local eb = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	eb:SetSize(420, 30)
	eb:SetPoint("BOTTOM", 0, 42)
	eb:SetAutoFocus(false)
	eb:SetScript("OnEscapePressed", function()
		f:Hide()
	end)
	-- Wrap in a closure: WoW hands script handlers extra args, and passing the raw
	-- eb.HighlightText method lets them land in HighlightText's start/stop params
	-- ("bad argument #2 outside of expected range"). The closure passes only self.
	eb:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
	-- Read-only: keep the tag intact no matter what gets typed over it.
	eb:SetScript("OnTextChanged", function(self, user)
		if user then
			self:SetText(self._mhText or "")
			self:HighlightText()
		end
	end)
	f.eb = eb

	f.hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	f.hint:SetPoint("BOTTOM", 0, 18)

	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	tinsert(UISpecialFrames, "MidnightHelperPawnCopyBox") -- Esc closes it
	frame = f
	return f
end

function ns.ShowPawnExport()
	local tag, reason = ns.BuildPawnString()
	if not tag then
		local msg = (reason == "nospec") and ns:L("PAWN_NO_SPEC") or ns:L("PAWN_NO_DATA")
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), msg))
		return
	end
	local f = ensureFrame()
	f.title:SetText(ns:L("PAWN_TITLE"))
	f.sub:SetText(ns:L("PAWN_SUBTITLE"))
	f.hint:SetText(ns:L("PAWN_COPY_HINT"))
	f.eb._mhText = tag
	f.eb:SetText(tag)
	f.eb:SetCursorPosition(0) -- show the start of the tag, not its tail
	f:Show()
	-- Defer focus + highlight off the current call stack: /mh pawn runs this inside
	-- the chat editbox's ParseText, and grabbing focus mid-parse is what surfaced the
	-- HighlightText error. pcall-guarded so a cosmetic highlight can never break copy.
	C_Timer.After(0, function()
		if f:IsShown() then
			pcall(f.eb.SetFocus, f.eb)
			pcall(f.eb.HighlightText, f.eb)
		end
	end)
end
