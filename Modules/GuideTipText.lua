--[[
	Midnight Helper — resolve leveling guide tip text with client spell names.
]]

local _, ns = ...

local function EscapePattern(s)
	if type(s) ~= "string" or s == "" then
		return s
	end
	return (s:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1"))
end

local function ClientSpellName(spellId)
	spellId = tonumber(spellId)
	if not spellId then
		return nil
	end
	if C_Spell and C_Spell.GetSpellName then
		local n = C_Spell.GetSpellName(spellId)
		if n and n ~= "" then
			return n
		end
	end
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, info = pcall(C_Spell.GetSpellInfo, spellId)
		if ok and info and info.name and info.name ~= "" then
			return info.name
		end
	end
	return nil
end

--- Replace the English spell name baked into tips with the WoW client locale name.
function ns:MH_ResolveGuideTipText(tip)
	if type(tip) ~= "table" then
		return ""
	end
	local key = tip.textKey
	local text = (key and self:L(key)) or tip.text or ""
	local sid = tonumber(tip.spell)
	if not key or not sid then
		return text
	end
	local locName = ClientSpellName(sid)
	local enName = ns.MH_GuideTipSpellEnName and ns.MH_GuideTipSpellEnName[sid]
	if locName and enName and enName ~= "" and enName ~= locName then
		local replaced, n = text:gsub(EscapePattern(enName), locName, 1)
		if n > 0 then
			text = replaced
		end
	end
	return text
end
