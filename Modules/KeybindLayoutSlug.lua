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
	end
	return nil
end

--- Name kept for `KeyboardLayoutPrototype.lua` — preview guide wins, else logged-in Hunter/Paladin slug.
--- Returns **nil** when previewing a class/spec that has no Midnight key table yet (layout shows no spell map).
function ns.MH_GetHunterKeybindSlugForUi()
	local db = ns.db
	if db and type(db.guide) == "table" and db.guide.preview then
		local slug = KeybindSlugFromGuidePreview()
		if slug then
			return slug
		end
		return nil
	end
	return LevelingKeybindSlugForLayout()
end
