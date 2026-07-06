--[[
	Ritual-share cross-locale reception — the same proven pattern as Delve-share
	v2 (DelveShareSync.lua), but on its own prefix MHRitual so the two never
	interfere. The plain-text party share (RitualShare.lua) stays the universal
	fallback; alongside it the sender broadcasts a compact hidden addon message
	"1|<senderChatLocale>|<mode>|<entryId>". Receivers with MH whose chat locale
	DIFFERS rebuild the same lines locally from their own locale pack
	(BuildRitualShareLines) and print them. Same-locale receivers do nothing.

	Test path (solo): with the shared share test mode on, the sender also whispers
	the descriptor to itself; the receiver accepts that self-whisper and renders
	regardless of locale, so the whole pipeline is verifiable alone.
]]

local _, ns = ...

local PREFIX = "MHRitual"
local PROTO = "1"
local DEDUPE_SEC = 20

local lastSeen = {}

local function ChatLocale()
	if ns.GetChatLocaleCode then
		return ns:GetChatLocaleCode()
	end
	return "enUS"
end

local function PlayerShortName()
	local name = UnitName and UnitName("player")
	return name or ""
end

function ns.MH_BroadcastRitualShareSync(entryId, mode, channel, isTest)
	if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then
		return
	end
	if type(entryId) ~= "string" or entryId == "" or entryId:find("|", 1, true) then
		return
	end
	local payload = table.concat({ PROTO, ChatLocale(), mode or "all", entryId }, "|")
	if isTest then
		local me = UnitName and select(1, UnitName("player"))
		local realm = GetNormalizedRealmName and GetNormalizedRealmName()
		if me and realm then
			ns.MH_SendAddon(PREFIX, payload, "WHISPER", me .. "-" .. realm)
		end
		return
	end
	if channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT" then
		ns.MH_SendAddon(PREFIX, payload, channel)
	end
end

local function RenderLocal(senderName, entryId, mode, isTest)
	local lines = ns.BuildRitualShareLines and ns.BuildRitualShareLines(entryId, mode)
	if not lines then
		return
	end
	local frame = DEFAULT_CHAT_FRAME
	if not (frame and frame.AddMessage) then
		return
	end
	local headerFmt = (ns.LChat and ns:LChat("RITUAL_SHARE_XLOC_HEADER_FMT"))
		or (ns.L and ns:L("RITUAL_SHARE_XLOC_HEADER_FMT"))
		or "%s"
	local header = headerFmt:format(senderName)
	if isTest then
		header = header .. " (test)"
	end
	frame:AddMessage("|cff9a86ff" .. header .. "|r")
	for i = 1, #lines do
		frame:AddMessage("|cffb8c7d9" .. lines[i] .. "|r")
	end
end

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
	pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", function(_, _, prefix, msg, channel, sender)
	if prefix ~= PREFIX or type(msg) ~= "string" then
		return
	end

	local senderName = sender
	if Ambiguate then
		senderName = Ambiguate(sender, "short")
	end
	local isSelf = senderName == PlayerShortName()

	local isTest = false
	if channel == "WHISPER" then
		if not (isSelf and ns.GetDelvePartyShareTestMode and ns.GetDelvePartyShareTestMode()) then
			return
		end
		isTest = true
	elseif channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT" then
		if isSelf then
			return
		end
	else
		return
	end

	local proto, loc, mode, entryId = strsplit("|", msg)
	if proto ~= PROTO or not entryId or entryId == "" then
		return
	end

	if not isTest and loc == ChatLocale() then
		return
	end

	local key = sender .. "#" .. entryId .. "#" .. (mode or "")
	local now = GetTime and GetTime() or 0
	if lastSeen[key] and now - lastSeen[key] < DEDUPE_SEC then
		return
	end
	lastSeen[key] = now

	RenderLocal(senderName, entryId, mode, isTest)
end)
