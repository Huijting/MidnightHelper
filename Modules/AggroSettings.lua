--[[
	AggroSettings.lua — `/mh aggro`: how the game's OWN aggro warnings are set for you.

	3 Oct 2026, option 1 of the threat proposal (Rob: "Doe optie 1 maar"). Blizzard already
	shows aggro — nameplate Aggro Display, the raid-frame aggro highlight, Audio Assist's
	"Say If Targeted" voice and the threat glow on your own frames — and it does so with its
	own code, which may read secret values that an addon may not. Many players simply have
	them off. So MH explains them (Codex chapter `aggro_display`) and this command shows the
	current state. MH changes none of these settings.

	CVar names measured in Blizzard's live 12.1.0.69933 source (mh-research, 3 Oct):
	nameplateThreatDisplay (a mask; 0 = all off), raidFramesDisplayAggroHighlight, CAAEnabled,
	IsThreatWarningEnabled(). A CVar the client does not know prints as "unknown", never as off.
]]

local _, ns = ...

local function CVar(name)
	local get = C_CVar and C_CVar.GetCVar or GetCVar
	if type(get) ~= "function" then
		return nil
	end
	local ok, v = pcall(get, name)
	if ok and v ~= nil and v ~= "" then
		return v
	end
	return nil
end

local function State(on)
	if on == nil then
		return "|cff999999" .. ns:L("AGGRO_STATE_UNKNOWN") .. "|r"
	end
	return on and ("|cff40ff40" .. ns:L("AGGRO_STATE_ON") .. "|r") or ("|cffff6060" .. ns:L("AGGRO_STATE_OFF") .. "|r")
end

local function Flag(name)
	local v = CVar(name)
	if v == nil then
		return nil
	end
	return v ~= "0"
end

local function Label(text)
	return ns.ExpandClientUIText and ns.ExpandClientUIText(text) or text
end

function ns.PrintAggroSettings()
	local prefix = ("|cffffcc00%s|r "):format(ns:L("PRINT_PREFIX"))
	print(prefix .. ns:L("AGGRO_CHECK_HEADER"))
	local warn = nil
	if type(IsThreatWarningEnabled) == "function" then
		local ok, v = pcall(IsThreatWarningEnabled)
		if ok and type(v) == "boolean" then
			warn = v
		end
	end
	local rows = {
		{ Label("{UI:NAMEPLATE_OPTIONS_LABEL} > {UI:UNIT_NAMEPLATES_THREAT_DISPLAY}"), Flag("nameplateThreatDisplay") },
		{ Label("{UI:COMPACT_UNIT_FRAME_PROFILE_DISPLAYAGGROHIGHLIGHT}"), Flag("raidFramesDisplayAggroHighlight") },
		{ Label("{UI:ACCESSIBILITY_AUDIO_LABEL} > {UI:CAA_COMBAT_AUDIO_ALERTS_LABEL}"), Flag("CAAEnabled") },
		{ ns:L("AGGRO_CHECK_FRAME_GLOW"), warn },
	}
	for _, r in ipairs(rows) do
		print(("  %s: %s"):format(r[1], State(r[2])))
	end
	print("  " .. ns:L("AGGRO_CHECK_FOOTER"))
end
