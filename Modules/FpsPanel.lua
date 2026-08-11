local _, ns = ...

--[[
	Midnight Helper — what your graphics settings actually are (`/mh fps`).

	Rob missed EllesmereUI's "optimise FPS" button. That addon is uninstalled, so its
	implementation cannot be read; instead his live Config.wtf was compared against a
	fresh PTR install, which shows exactly which CVars such a button moves — and that on
	his live machine they are already at the bottom.

	It also turned up something worth a second look: WoW keeps a SEPARATE set of graphics
	settings for raids and battlegrounds, and on his account several of those sit HIGHER
	than the everyday ones. `graphicsViewDistance` is 1 while `raidGraphicsViewDistance`
	is 6.

	⚠️ THIS PANEL CHANGES NOTHING. It reads CVars and prints them next to their defaults.

	The reason is never-lie. "Turn this down and you gain frames" is a claim about your
	hardware, your resolution and the scene you are standing in, and MH cannot see any of
	those. What it CAN state as fact is: here is the value, here is what the game ships
	as default, here is the raid counterpart, and here is your framerate right now. Those
	are readings. Whether a number is too high is a judgement, and it stays the player's.

	A button that sets these is a separate decision, to be taken once we understand which
	of the two sets applies when. That is not established, so it is not implied here.
]]

--- Everyday CVar, its raid/battleground counterpart, our fallback label, and the
--- game's own global string for the same setting.
---
--- ⚠️ THE GAME HAS ALREADY TRANSLATED THESE. Borrowed from `!Pig`, which labels its
--- CVar list with `LOOT_UNDER_MOUSE_TEXT` and friends rather than writing its own text:
--- WoW ships those strings in every language it supports, so you get correct German for
--- free and it stays correct when Blizzard rewords something. Our seven hand-made
--- translations covered seven languages and would drift.
---
--- The global names are candidates, not certainties — hence a list per row and a
--- fallback to our own key. Asking beats assuming, and a missing global would otherwise
--- render as an empty label.
local SETTINGS = {
	{ "graphicsViewDistance",      "raidGraphicsViewDistance",      "FPS_VIEWDIST",  { "VIEW_DISTANCE" } },
	{ "graphicsEnvironmentDetail", "raidGraphicsEnvironmentDetail", "FPS_ENVDETAIL", { "ENVIRONMENT_DETAIL" } },
	{ "graphicsGroundClutter",     "raidGraphicsGroundClutter",     "FPS_CLUTTER",   { "GROUND_CLUTTER" } },
	{ "graphicsShadowQuality",     "raidGraphicsShadowQuality",     "FPS_SHADOW",    { "SHADOW_QUALITY" } },
	{ "graphicsLiquidDetail",      "raidGraphicsLiquidDetail",      "FPS_LIQUID",    { "LIQUID_DETAIL" } },
	{ "graphicsParticleDensity",   "raidGraphicsParticleDensity",   "FPS_PARTICLE",  { "PARTICLE_DENSITY" } },
	{ "graphicsSSAO",              "raidGraphicsSSAO",              "FPS_SSAO",      { "SSAO_LABEL", "SSAO" } },
	{ "graphicsDepthEffects",      "raidGraphicsDepthEffects",      "FPS_DEPTH",     { "DEPTH_EFFECTS" } },
	{ "graphicsComputeEffects",    "raidGraphicsComputeEffects",    "FPS_COMPUTE",   { "COMPUTE_EFFECTS" } },
	{ "graphicsOutlineMode",       "raidGraphicsOutlineMode",       "FPS_OUTLINE",   { "OUTLINE_MODE", "OUTLINE_DETAIL" } },
	{ "graphicsTextureResolution", "raidGraphicsTextureResolution", "FPS_TEXTURE",   { "TEXTURE_DETAIL", "TEXTURE_RESOLUTION" } },
	{ "graphicsSpellDensity",      "raidGraphicsSpellDensity",      "FPS_SPELLDENS", { "SPELL_DENSITY" } },
	{ "graphicsProjectedTextures", "raidGraphicsProjectedTextures", "FPS_PROJTEX",   { "PROJECTED_TEXTURES" } },
}

--- Blizzard's own wording when it exists, ours when it does not.
---
--- Records which globals were found in `ns.db.fpsLabelSource`, so a language where this
--- silently fell back to English can be spotted instead of guessed at.
local function LabelFor(descKey, globals)
	for _, g in ipairs(globals or {}) do
		local v = _G[g]
		if type(v) == "string" and v ~= "" then
			if ns.db then
				ns.db.fpsLabelSource = ns.db.fpsLabelSource or {}
				ns.db.fpsLabelSource[descKey] = g
			end
			return v
		end
	end
	if ns.db then
		ns.db.fpsLabelSource = ns.db.fpsLabelSource or {}
		ns.db.fpsLabelSource[descKey] = "own"
	end
	return ns:L(descKey)
end

--- Blizzard's labels are full sentences where ours were column-width. Clip rather than
--- let one long German noun push the numbers off the panel.
local function Fit(s, n)
	s = tostring(s or "")
	if #s <= n then
		return s
	end
	return s:sub(1, n - 1) .. "\226\128\166"
end

local PANEL_W, PANEL_H = 620, 520
local panel

local function Read(name)
	if not name then
		return nil
	end
	-- C_CVar is the modern namespace; the bare globals still exist. Ask for both
	-- rather than assuming which this build kept.
	local getter = (C_CVar and C_CVar.GetCVar) or _G.GetCVar
	if type(getter) ~= "function" then
		return nil
	end
	local ok, v = pcall(getter, name)
	return ok and v or nil
end

local function ReadDefault(name)
	local getter = (C_CVar and C_CVar.GetCVarDefault) or _G.GetCVarDefault
	if type(getter) ~= "function" then
		return nil
	end
	local ok, v = pcall(getter, name)
	return ok and v or nil
end

local function Num(v)
	return tonumber(v)
end

local function BuildLines()
	local out = {}

	local okF, rate = pcall(GetFramerate)
	out[#out + 1] = (ns:L("FPS_NOW")):format(
		(okF and rate) and ("%.0f"):format(rate) or "?")

	--- Does this client even have a separate raid set enabled? The CVar name is not
	--- guaranteed, so report what is found rather than claiming which set is live.
	local toggle = Read("raidGraphicsSettingsEnabled")
	if toggle ~= nil then
		out[#out + 1] = (ns:L("FPS_RAIDSET")):format(tostring(toggle))
	end

	out[#out + 1] = " "
	out[#out + 1] = ns:L("FPS_HEADER")

	--- ⚠️ "Higher in raids" and "never touched" look identical, and only one is a
	--- finding.
	---
	--- The first version flagged every setting where the raid value beat the everyday
	--- one and announced nine of them, which reads as nine things wrong. On Rob's
	--- machine the raid column matched the DEFAULT column line for line: he had lowered
	--- his ordinary settings and simply never opened the raid tab. That is not a
	--- misconfiguration, it is an untouched panel — and telling him otherwise would be
	--- inventing a problem out of an unchanged default.
	---
	--- So the two cases are separated. Untouched-at-default is stated plainly; a raid
	--- value that is higher AND deliberately set is the only one that gets a mark.
	local higherAndSet, higherAtDefault = 0, 0
	for _, row in ipairs(SETTINGS) do
		local name, raidName, descKey, globals = row[1], row[2], row[3], row[4]
		local cur, raid, def = Read(name), Read(raidName), ReadDefault(name)
		if cur ~= nil then
			local n, r, d = Num(cur), Num(raid), Num(def)
			local mark = ""
			if n and r and r > n then
				if d and r == d then
					-- Raid side still sitting on the shipped value.
					mark = " |cff9d9d9d\194\183|r"
					higherAtDefault = higherAtDefault + 1
				else
					mark = " |cffff9900<|r"
					higherAndSet = higherAndSet + 1
				end
			end
			out[#out + 1] = ("|cffffd100%-22s|r %4s %6s %7s%s   |cff9d9d9d%s|r"):format(
				Fit(LabelFor(descKey, globals), 22), tostring(cur), tostring(raid or "-"),
				tostring(def or "?"), mark, name)
		end
	end

	out[#out + 1] = " "
	if higherAtDefault > 0 then
		out[#out + 1] = (ns:L("FPS_RAID_UNTOUCHED")):format(higherAtDefault)
	end
	if higherAndSet > 0 then
		out[#out + 1] = (ns:L("FPS_HIGHER_IN_RAID")):format(higherAndSet)
	end
	out[#out + 1] = ns:L("FPS_FOOTER")
	return table.concat(out, "\n")
end

local function Build()
	if panel then
		return panel
	end
	local f = CreateFrame("Frame", "MidnightHelperFpsPanel", UIParent, "BackdropTemplate")
	f:SetSize(PANEL_W, PANEL_H)
	f:SetPoint("CENTER")
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
	f.title:SetText(ns:L("FPS_TITLE"))

	f.body = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.body:SetPoint("TOPLEFT", 16, -44)
	f.body:SetPoint("BOTTOMRIGHT", -16, 16)
	f.body:SetJustifyH("LEFT")
	f.body:SetJustifyV("TOP")
	f.body:SetSpacing(2)

	if ns.AttachMidnightDialogCloseButton then
		ns.AttachMidnightDialogCloseButton(f, function()
			f:Hide()
		end)
	end
	panel = f
	return f
end

--- `/mh fps` — read out the graphics settings. Changes nothing.
function ns.MH_ShowFpsPanel()
	local f = Build()
	f.body:SetText(BuildLines())
	f:Show()
end
