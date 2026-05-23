--[[
	Midnight Helper — Locale resolver (shell uses ns:L from UI/Core).
	Load after Locales/enUS.lua, deDE.lua, frFR.lua, esES.lua, ptBR.lua, and nlNL.lua.

	Phase A: "auto" follows WoW GetLocale() when a matching pack exists; otherwise enUS.
	nlNL is never auto-selected (addon-only); players choose it manually.
]]

local _, ns = ...

ns.MH_LOCALE_AUTO = "auto"
ns.MH_LOCALE_FALLBACK = "enUS"

--- WoW client locales we may map to addon packs (same codes as GetLocale()).
ns.MH_WOW_CLIENT_LOCALES = {
	"deDE",
	"enUS",
	"esES",
	"esMX",
	"frFR",
	"itIT",
	"koKR",
	"ptBR",
	"ruRU",
	"zhCN",
	"zhTW",
}

--- enGB and other aliases → addon pack code.
local WOW_LOCALE_ALIASES = {
	enGB = "enUS",
	enAU = "enUS",
	esMX = "esES",
}

local LOCALE_NAME_KEYS = {
	auto = "LOCALE_NAME_AUTO",
	enUS = "LOCALE_NAME_EN",
	nlNL = "LOCALE_NAME_NL",
	deDE = "LOCALE_NAME_deDE",
	frFR = "LOCALE_NAME_frFR",
	esES = "LOCALE_NAME_esES",
	esMX = "LOCALE_NAME_esMX",
	itIT = "LOCALE_NAME_itIT",
	ptBR = "LOCALE_NAME_ptBR",
	ruRU = "LOCALE_NAME_ruRU",
	koKR = "LOCALE_NAME_koKR",
	zhCN = "LOCALE_NAME_zhCN",
	zhTW = "LOCALE_NAME_zhTW",
}

local SLASH_ALIASES = {
	auto = "auto",
	automatic = "auto",
	wow = "auto",
	client = "auto",
	en = "enUS",
	enus = "enUS",
	english = "enUS",
	nl = "nlNL",
	nlnl = "nlNL",
	nederlands = "nlNL",
	dutch = "nlNL",
	de = "deDE",
	dede = "deDE",
	german = "deDE",
	deutsch = "deDE",
	fr = "frFR",
	frfr = "frFR",
	french = "frFR",
	es = "esES",
	eses = "esES",
	spanish = "esES",
	mx = "esES",
	esmx = "esES",
	it = "itIT",
	itit = "itIT",
	italian = "itIT",
	pt = "ptBR",
	ptbr = "ptBR",
	ru = "ruRU",
	ruru = "ruRU",
	russian = "ruRU",
	ko = "koKR",
	kokr = "koKR",
	korean = "koKR",
	cn = "zhCN",
	zhcn = "zhCN",
	tw = "zhTW",
	zhtw = "zhTW",
}

function ns:HasLocalePack(code)
	if code == ns.MH_LOCALE_AUTO then
		return true
	end
	return type(code) == "string"
		and ns._mhLocales
		and type(ns._mhLocales[code]) == "table"
end

function ns:GetWoWClientLocaleCode()
	local wow
	if GetLocale then
		wow = GetLocale()
	end
	if type(wow) ~= "string" or wow == "" then
		return ns.MH_LOCALE_FALLBACK
	end
	wow = WOW_LOCALE_ALIASES[wow] or wow
	if wow == "nlNL" then
		return ns.MH_LOCALE_FALLBACK
	end
	return wow
end

--- Locale pack to use when preference is "auto" (never nlNL).
function ns:ResolveAutoLocaleCode()
	local wow = self:GetWoWClientLocaleCode()
	if self:HasLocalePack(wow) then
		return wow
	end
	return ns.MH_LOCALE_FALLBACK
end

function ns:IsKnownLocalePreference(pref)
	if type(pref) ~= "string" or pref == "" then
		return false
	end
	if pref == ns.MH_LOCALE_AUTO or pref == "enUS" or pref == "nlNL" then
		return true
	end
	for _, code in ipairs(ns.MH_WOW_CLIENT_LOCALES) do
		if pref == code then
			return true
		end
	end
	return false
end

function ns:GetLocalePreferenceCode()
	local db = rawget(ns, "db")
	local pref = db and db.locale
	if not self:IsKnownLocalePreference(pref) then
		return ns.MH_LOCALE_AUTO
	end
	return pref
end

function ns:GetEffectiveLocaleCode()
	local pref = self:GetLocalePreferenceCode()
	if pref == ns.MH_LOCALE_AUTO then
		return self:ResolveAutoLocaleCode()
	end
	if pref == "nlNL" and self:HasLocalePack("nlNL") then
		return "nlNL"
	end
	if self:HasLocalePack(pref) then
		return pref
	end
	return ns.MH_LOCALE_FALLBACK
end

function ns:GetLocaleDisplayName(code)
	if not code then
		return "?"
	end
	if code == ns.MH_LOCALE_AUTO then
		return self:L("LOCALE_NAME_AUTO")
	end
	local key = LOCALE_NAME_KEYS[code]
	if key then
		local s = self:L(key)
		if s ~= key then
			return s
		end
	end
	return code
end

--- Player-facing label for settings / minimap (includes auto + WoW client hint).
function ns:GetLanguageStatusLabel()
	local pref = self:GetLocalePreferenceCode()
	if pref == ns.MH_LOCALE_AUTO then
		local wow = self:GetWoWClientLocaleCode()
		local effective = self:GetEffectiveLocaleCode()
		local wowName = self:GetLocaleDisplayName(wow)
		local effName = self:GetLocaleDisplayName(effective)
		if wow == effective then
			return self:L("LOCALE_STATUS_AUTO_FMT"):format(wowName)
		end
		return self:L("LOCALE_STATUS_AUTO_FALLBACK_FMT"):format(wowName, effName)
	end
	return self:GetLocaleDisplayName(pref)
end

function ns:MigrateLocalePreference()
	local db = rawget(ns, "db")
	if not db then
		return
	end
	local pref = db.locale
	if type(pref) ~= "string" or pref == "" then
		db.locale = ns.MH_LOCALE_AUTO
		return
	end
	if self:IsKnownLocalePreference(pref) then
		return
	end
	db.locale = ns.MH_LOCALE_AUTO
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

function ns:NormalizeLocaleInput(arg)
	if type(arg) ~= "string" then
		return nil
	end
	local a = arg:lower():gsub("^%s+", ""):gsub("%s+$", "")
	if a == "" then
		return nil
	end
	local mapped = SLASH_ALIASES[a]
	if mapped then
		return mapped
	end
	local upper = arg:upper():gsub("^%s+", ""):gsub("%s+$", "")
	if upper == ns.MH_LOCALE_AUTO then
		return ns.MH_LOCALE_AUTO
	end
	if upper == "NLNL" then
		return "nlNL"
	end
	if self:IsKnownLocalePreference(upper) then
		return upper
	end
	return nil
end

function ns:IsDutchLocaleActive()
	return self:GetEffectiveLocaleCode() == "nlNL"
end
