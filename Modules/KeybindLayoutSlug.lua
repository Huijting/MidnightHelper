local addonName, ns = ...

--- Resolves `KeybindingData` slug for the Layout keyboard preview (standalone — no Abilities tab / Guide.lua hooks).
local function LevelingKeybindSlugForLayout()
	local ref = ns.KeybindingReference
	if not ref or not ref.specsById then
		return nil
	end
	local _, class = UnitClass("player")
	local lv = UnitLevel("player") or 0
	local s = GetSpecialization and GetSpecialization() or 0
	if class == "HUNTER" and ref.specsById.hunter_early then
		if lv < 10 then
			return "hunter_early"
		end
		if lv == 10 and (not s or s < 1) then
			return "hunter_early"
		end
		if s == 1 and ref.specsById.hunter_beast_mastery then
			return "hunter_beast_mastery"
		end
		if lv >= 10 then
			return "hunter_early"
		end
	elseif class == "PALADIN" and ref.specsById.paladin_early then
		if lv < 10 then
			return "paladin_early"
		end
		if lv == 10 and (not s or s < 1) then
			return "paladin_early"
		end
		if s == 3 and ref.specsById.paladin_retribution then
			return "paladin_retribution"
		end
		if lv >= 10 then
			return "paladin_early"
		end
	end
	return nil
end

--- Name kept for `KeyboardLayoutPrototype.lua` — returns Hunter or Paladin slug when applicable.
function ns.MH_GetHunterKeybindSlugForUi()
	return LevelingKeybindSlugForLayout()
end
