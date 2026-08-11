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

--- Everyday CVar paired with its raid/battleground counterpart.
---
--- Names are the client's, kept verbatim so nobody has to trust our labels. The
--- descriptions say what the setting IS, never what turning it down will buy you.
local SETTINGS = {
	{ "graphicsViewDistance",      "raidGraphicsViewDistance",      "FPS_VIEWDIST" },
	{ "graphicsEnvironmentDetail", "raidGraphicsEnvironmentDetail", "FPS_ENVDETAIL" },
	{ "graphicsGroundClutter",     "raidGraphicsGroundClutter",     "FPS_CLUTTER" },
	{ "graphicsShadowQuality",     "raidGraphicsShadowQuality",     "FPS_SHADOW" },
	{ "graphicsLiquidDetail",      "raidGraphicsLiquidDetail",      "FPS_LIQUID" },
	{ "graphicsParticleDensity",   "raidGraphicsParticleDensity",   "FPS_PARTICLE" },
	{ "graphicsSSAO",              "raidGraphicsSSAO",              "FPS_SSAO" },
	{ "graphicsDepthEffects",      "raidGraphicsDepthEffects",      "FPS_DEPTH" },
	{ "graphicsComputeEffects",    "raidGraphicsComputeEffects",    "FPS_COMPUTE" },
	{ "graphicsOutlineMode",       "raidGraphicsOutlineMode",       "FPS_OUTLINE" },
	{ "graphicsTextureResolution", "raidGraphicsTextureResolution", "FPS_TEXTURE" },
	{ "graphicsSpellDensity",      "raidGraphicsSpellDensity",      "FPS_SPELLDENS" },
	{ "graphicsProjectedTextures", "raidGraphicsProjectedTextures", "FPS_PROJTEX" },
}

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

	local higherInRaid = 0
	for _, row in ipairs(SETTINGS) do
		local name, raidName, descKey = row[1], row[2], row[3]
		local cur, raid, def = Read(name), Read(raidName), ReadDefault(name)
		if cur ~= nil then
			local n, r = Num(cur), Num(raid)
			-- Mark where the raid value exceeds the everyday one: that is the shape
			-- Rob's config showed, and it is the opposite of what people expect.
			local mark = ""
			if n and r and r > n then
				mark = " |cffff9900<|r"
				higherInRaid = higherInRaid + 1
			end
			out[#out + 1] = ("|cffffd100%-14s|r %4s %6s %7s%s   |cff9d9d9d%s|r"):format(
				ns:L(descKey), tostring(cur), tostring(raid or "-"),
				tostring(def or "?"), mark, name)
		end
	end

	out[#out + 1] = " "
	if higherInRaid > 0 then
		out[#out + 1] = (ns:L("FPS_HIGHER_IN_RAID")):format(higherInRaid)
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
