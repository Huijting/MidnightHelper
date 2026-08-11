local _, ns = ...

--[[
	Midnight Helper — the recommended bar layout, as a string you can apply.

	The keybind scheme has always described where things go; it could not put the bars
	there. `/mh apply` fills the slots and binds the keys, but the bars themselves —
	which one, how wide, where on screen — were left as a drawing for the player to copy
	by hand in Edit Mode.

	This is Rob's Hunter, exported on 11 Aug 2026 once the bars matched the plan. Six
	rows of the scheme plus the two macro bars, positioned along the bottom.

	⚠️ PATCH-BOUND. Blizzard's layout string carries a version and internal system
	numbers; a string made on one patch is not guaranteed to read back on the next. This
	one was made on 12.0.7, and 12.1 arrives tomorrow. `MH_EditModeApplyBars` already
	refuses a string it cannot parse and says so, so the failure is loud — but the string
	needs re-exporting after a big patch rather than being assumed to survive.

	⚠️ BARS 1-8 ONLY. The exporter strips everything else, so applying this cannot move
	somebody's minimap, unit frames or chat. Their own macro bars stay where they were.

	⚠️ NOT FOR EllesmereUI (or any bar addon that arranges Blizzard's bars for you).
	Those move the SAME bars 1-8 this string describes, so importing it fights them. Such
	a player wants the scheme — which keys sit in which group — and should lay it out
	with their own tool. The command says so before it does anything.
]]

--- Exported from Rob's Hunter (Redisch) on 12.0.7, 11 Aug 2026.
local PRESET_1207 =
	"2 8 0 0 0 8 6 MultiBarBottomRight -4.0 0.0 -1 ##$$%)&''%)$+$,# 0 1 0 8 6 MultiBar5"
	.. " -4.0 0.0 -1 ##$$%,&''%(#,$ 0 2 0 4 4 UIParent 149.1 -560.0 -1 ##$$%*&''%(#,$"
	.. " 0 3 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%+&''%(#,$ 0 4 0 8 2 MultiBar5 0.0"
	.. " 4.0 -1 ##$$%)&''%(#,$ 0 5 0 8 2 MultiBarBottomRight 0.0 4.0 -1 ##$$%)&''%(#,$"
	.. " 0 6 0 7 7 UIParent -614.9 2.0 -1 ##$$%/&''%(#,$ 0 7 0 4 4 UIParent 400.0 -520.0"
	.. " -1 ##$&%/&''%(#,$"

--- Which patch each string was made on, so the mismatch can be named rather than
--- discovered by a player whose bars did not move.
local PRESETS = {
	{ interface = 120007, label = "12.0.7", str = PRESET_1207 },
}

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "MH:")
end

local function CurrentInterface()
	if not GetBuildInfo then
		return nil
	end
	local ok, _, _, _, iface = pcall(GetBuildInfo)
	return ok and tonumber(iface) or nil
end

--- A bar addon that rearranges Blizzard's own bars makes this preset the wrong tool.
local function CompetingBarAddon()
	if not (C_AddOns and C_AddOns.IsAddOnLoaded) then
		return nil
	end
	for _, name in ipairs({
		"EllesmereUIActionBars", "EllesmereUI", "Bartender4", "Dominos", "ElvUI",
	}) do
		local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, name)
		if ok and loaded then
			return name
		end
	end
	return nil
end

--- `/mh editmode preset` — apply the recommended bar layout.
function ns.MH_ApplyBarPreset(confirmed)
	local iface = CurrentInterface()
	local best = PRESETS[1]

	local rival = CompetingBarAddon()
	if rival then
		print(Prefix() .. " " .. (ns:L("BARPRESET_RIVAL")):format(rival))
		if not confirmed then
			print("   |cff9d9d9d" .. ns:L("BARPRESET_RIVAL_GO") .. "|r")
			return
		end
	end

	--- Say it up front. A string from another patch may apply and look subtly wrong,
	--- which is worse than refusing, so the mismatch is named before anything happens.
	if iface and best.interface and iface ~= best.interface then
		print(Prefix() .. " " .. (ns:L("BARPRESET_PATCH")):format(
			best.label, tostring(iface)))
		if not confirmed then
			print("   |cff9d9d9d" .. ns:L("BARPRESET_PATCH_GO") .. "|r")
			return
		end
	end

	if not ns.MH_EditModeApplyBars then
		return
	end
	print(Prefix() .. " " .. ns:L("BARPRESET_APPLYING"))
	ns.MH_EditModeApplyBars(best.str)
end

--- The raw string, for anyone who wants to paste it elsewhere.
function ns.MH_BarPresetString()
	return PRESETS[1].str, PRESETS[1].label
end
