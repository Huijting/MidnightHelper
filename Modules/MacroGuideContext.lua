local addonName, ns = ...

local function ClassFileToClassID(classToken)
	local up = string.upper(tostring(classToken or ""))
	local n = GetNumClasses and GetNumClasses() or 0
	for i = 1, n do
		local ok, _, file, id = pcall(GetClassInfo, i)
		if ok and file and id and string.upper(tostring(file)) == up then
			return id
		end
	end
	return nil
end

local function LocalizedClassName(classToken)
	local cid = ClassFileToClassID(classToken)
	if cid and GetClassInfo then
		local ok, name = pcall(GetClassInfo, cid)
		if ok and name and name ~= "" then
			return name
		end
	end
	return classToken
end

local function SpecNameForClassSpec(classToken, specIdx)
	local cid = ClassFileToClassID(classToken)
	if not cid or not specIdx or specIdx < 1 or not GetSpecializationInfoForClassID then
		return nil
	end
	local ok, _, name = pcall(GetSpecializationInfoForClassID, cid, specIdx)
	if ok and name and name ~= "" then
		return name
	end
	return nil
end

--- Class/spec for Macros tab: guide search preview when active, else logged-in character.
--- @return string|nil token, number specIdx, boolean isPreview, string|nil classLocalized, string|nil specName
function ns.MH_GetMacroClassSpecContext()
	local db = ns.db
	if db and type(db.guide) == "table" and db.guide.preview then
		local g = db.guide
		local token = type(g.classToken) == "string" and string.upper(g.classToken) or ""
		local specIdx = tonumber(g.specIndex) or 0
		if token ~= "" and specIdx >= 1 then
			return token, specIdx, true, LocalizedClassName(token), SpecNameForClassSpec(token, specIdx)
		end
	end

	local classLocalized, classFile = UnitClass("player")
	if not classFile then
		return nil, 0, false, nil, nil
	end
	local token = string.upper(classFile)
	local specIdx = (GetSpecialization and GetSpecialization()) or 0
	local specName
	if specIdx > 0 and GetSpecializationInfo then
		local ok, _, name = pcall(GetSpecializationInfo, specIdx)
		if ok and name and name ~= "" then
			specName = name
		end
	end
	return token, specIdx, false, classLocalized, specName
end

function ns.MH_RefreshMacrosPanel()
	local panel = ns._mhMacrosActivePanel
	if panel and panel._mhRefreshMacros then
		panel._mhRefreshMacros()
	end
end
