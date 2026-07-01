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
	-- Russian pack removed; reset old saved prefs to auto (falls back to enUS on ruRU client).
	if pref == "ruRU" or pref == "ru" then
		db.locale = ns.MH_LOCALE_AUTO
		return
	end
	if self:IsKnownLocalePreference(pref) then
		return
	end
	db.locale = ns.MH_LOCALE_AUTO
end

--- Locales that need matching WoW client fonts in chat (Cyrillic/CJK).
local CHAT_SCRIPT_LOCALES = {
	koKR = true,
	zhCN = true,
	zhTW = true,
}

--- Locale pack for party/chat strings (falls back when client cannot render the script).
function ns:GetChatLocaleCode()
	local effective = self:GetEffectiveLocaleCode()
	if not CHAT_SCRIPT_LOCALES[effective] then
		return effective
	end
	local wow = self:GetWoWClientLocaleCode()
	if wow == effective then
		return effective
	end
	if self:HasLocalePack(wow) and not CHAT_SCRIPT_LOCALES[wow] then
		return wow
	end
	return ns.MH_LOCALE_FALLBACK
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

--- Esc → Keybindings → AddOns → Midnight Helper (uses BINDING_* globals).
function ns:ApplyBindingLabels()
	_G.BINDING_HEADER_MIDNIGHTHELPER = self:L("BINDING_HEADER_MIDNIGHTHELPER")
	-- Global must match the (namespaced) Binding name in Bindings.xml; the
	-- locale-table key is unchanged to keep the language packs untouched.
	_G.BINDING_NAME_MIDNIGHTHELPER_TOGGLEMAIN = self:L("BINDING_NAME_TOGGLEMAIN")
	_G.BINDING_NAME_MIDNIGHTHELPER_SKIPNODE = self:L("BINDING_NAME_SKIPNODE")
	_G.BINDING_NAME_MIDNIGHTHELPER_CLEARROUTE = self:L("BINDING_NAME_CLEARROUTE")
end

--- Like L() but uses GetChatLocaleCode (Latin fallback when client cannot render CJK chat).
function ns:LChat(key)
	local loc = self:GetChatLocaleCode()
	local pack = ns._mhLocales and ns._mhLocales[loc]
	local fb = ns._mhLocales and ns._mhLocales.enUS
	local s = pack and pack[key] or fb and fb[key] or key
	return s
end

--- Latin chat label for script locales when the WoW client cannot render Cyrillic/CJK.
local CHAT_LOCALE_ROMAN_NAMES = {
	koKR = "Korean",
	zhCN = "Chinese (Simplified)",
	zhTW = "Chinese (Traditional)",
}

function ns:GetLocaleDisplayNameForChat(code)
	if code == ns.MH_LOCALE_AUTO then
		local wow = self:GetWoWClientLocaleCode()
		local eff = self:GetEffectiveLocaleCode()
		if wow == eff then
			return self:GetLocaleDisplayName(ns.MH_LOCALE_AUTO)
		end
		return ("%s -> %s"):format(
			CHAT_LOCALE_ROMAN_NAMES[wow] or wow,
			CHAT_LOCALE_ROMAN_NAMES[eff] or eff
		)
	end
	if CHAT_LOCALE_ROMAN_NAMES[code] and self:GetChatLocaleCode() ~= code then
		return CHAT_LOCALE_ROMAN_NAMES[code]
	end
	return self:GetLocaleDisplayName(code)
end

function ns:PrintChat(message)
	if type(message) ~= "string" or message == "" then
		return
	end
	if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
		local prefix = self:LChat("PRINT_PREFIX")
		DEFAULT_CHAT_FRAME:AddMessage(("|cffffcc00%s|r %s"):format(prefix, message))
	end
end

function ns:PrintChatKey(key, ...)
	local fmt = self:LChat(key)
	local msg = fmt
	if select("#", ...) > 0 then
		msg = fmt:format(...)
	end
	self:PrintChat(msg)
end

--- Game fonts often miss Unicode arrows/dashes; use for player-visible strings in UI.
function ns.SanitizeUIFontText(s)
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

function ns:SafeL(key)
	local s = self:L(key)
	if type(s) ~= "string" then
		return s
	end
	return ns.SanitizeUIFontText(s)
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

--- WoW buttons treat & as a keyboard accelerator; that breaks many Cyrillic/CJK labels.
local BUTTON_AMPERSAND_ESCAPE_LOCALES = {
	koKR = true,
	zhCN = true,
	zhTW = true,
}

function ns:EscapeButtonAmpersand(text)
	if type(text) ~= "string" then
		return text
	end
	local loc = self.GetEffectiveLocaleCode and self:GetEffectiveLocaleCode()
	if not BUTTON_AMPERSAND_ESCAPE_LOCALES[loc] then
		return text
	end
	return text:gsub("&", "&&")
end
