local addonName, ns = ...

--- Midnight key-map slug for **Guide search preview** (`ns.db.guide`), not the logged-in character.
local function KeybindSlugFromGuidePreview()
	local db = ns.db
	if not db or type(db.guide) ~= "table" then
		return nil
	end
	local g = db.guide
	if not g.preview or type(g.classToken) ~= "string" or g.classToken == "" then
		return nil
	end
	local specIdx = tonumber(g.specIndex) or 0
	if specIdx < 1 then
		return nil
	end
	local ct = string.upper(g.classToken)
	local ref = ns.KeybindingReference
	if not ref or not ref.specsById then
		return nil
	end
	-- Indices match `GuideData.lua` / `GetSpecializationInfoForClassID` order.
	if ct == "HUNTER" then
		if specIdx == 1 and ref.specsById.hunter_beast_mastery then
			return "hunter_beast_mastery"
		end
		if specIdx ~= 1 then
			return nil
		end
		if ref.specsById.hunter_early then
			return "hunter_early"
		end
		return nil
	end
	if ct == "PALADIN" then
		if specIdx == 3 and ref.specsById.paladin_retribution then
			return "paladin_retribution"
		end
		if ref.specsById.paladin_early then
			return "paladin_early"
		end
		return nil
	end
	return nil
end

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
	elseif class == "MAGE" and ref.specsById.frost_mage then
		--- Match on the stable specID, not the index (no ordering doubt): 64 = Frost Mage.
		local specId = (s and s > 0 and GetSpecializationInfo) and GetSpecializationInfo(s) or nil
		if specId == 64 then
			return "frost_mage"
		end
	elseif class == "SHAMAN" and (ref.specsById.enh_shaman or ref.specsById.ele_shaman) then
		--- 263 = Enhancement, 262 = Elemental (264 = Restoration).
		local specId = (s and s > 0 and GetSpecializationInfo) and GetSpecializationInfo(s) or nil
		if specId == 263 and ref.specsById.enh_shaman then
			return "enh_shaman"
		elseif specId == 262 and ref.specsById.ele_shaman then
			return "ele_shaman"
		end
	end
	return nil
end

--- Name kept for `KeyboardLayoutPrototype.lua` — preview guide wins, else logged-in Hunter/Paladin slug.
--- Returns **nil** when previewing a class/spec that has no Midnight key table yet (layout shows no spell map).
function ns.MH_GetHunterKeybindSlugForUi()
	-- Guide preview is gone (leveling tab replaced), and a stale db.guide.preview=true in
	-- SavedVars would wrongly short-circuit to nil. Always use the logged-in char's spec.
	return LevelingKeybindSlugForLayout()
end
