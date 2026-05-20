--[[
	Midnight Helper — Locale resolver (shell uses ns:L from UI/Core).
	Load after Locales/enUS.lua and Locales/nlNL.lua.
]]

local _, ns = ...

function ns:GetEffectiveLocaleCode()
	local db = rawget(ns, "db")
	local code = (db and db.locale) or "enUS"
	if code == "nlNL" and ns._mhLocales and ns._mhLocales.nlNL then
		return "nlNL"
	end
	return "enUS"
end

---@param key string
---@return string
function ns:L(key)
	local loc = self:GetEffectiveLocaleCode()
	local pack = ns._mhLocales and ns._mhLocales[loc]
	local fb = ns._mhLocales and ns._mhLocales.enUS
	local s = pack and pack[key] or fb and fb[key] or key
	return s
end

--- Game fonts often miss Unicode arrows/dashes; use for player-visible strings in UI.
function ns:SafeL(key)
	local s = self:L(key)
	if type(s) ~= "string" then
		return s
	end
	return s
		:gsub("\226\128\148", "-")
		:gsub("\226\128\147", "-")
		:gsub("\226\134\146", "->")
		:gsub("→", "->")
		:gsub("—", "-")
		:gsub("–", "-")
end

--- Resolve short slash args: en -> enUS, nl -> nlNL
function ns:NormalizeLocaleInput(arg)
	local a = (arg or ""):lower()
	if a == "en" or a == "enus" or a == "english" then
		return "enUS"
	end
	if a == "nl" or a == "nl_nl" or a == "nederlands" then
		return "nlNL"
	end
	return nil
end
