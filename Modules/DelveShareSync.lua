--[[
	Delve-share v2 — cross-locale reception.

	The plain-text party share (DelvePartyShare.lua) stays the universal
	fallback. Alongside it, the sender broadcasts a compact hidden addon
	message: "1|<senderChatLocale>|<mode>|<entryId>". Receivers with MH whose
	chat locale DIFFERS from the sender's rebuild the very same share lines
	locally — via BuildDelvePartyShareLines, which reads the receiver's own
	locale pack — and print them in their language. Same-locale receivers do
	nothing (the chat text already matches), so nothing is duplicated.

	Test path (solo): with share test mode on, the sender also whispers the
	addon message to itself; the receiver side accepts that self-whisper and
	renders regardless of locale, so the whole pipeline is verifiable alone.

	Tip IDs stay stable across releases: the payload carries the delve
	entryId + section mode only; the actual text always comes from the
	receiving client's locale pack (never from the wire).
]]

local _, ns = ...

local PREFIX = "MHDelve"
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

--- Sender side: broadcast the share descriptor on the group channel, or —
--- in test mode — whisper it to ourselves so the receive path can be tested
--- solo. Called by DelvePartyShare right when the plain lines go out.
function ns.MH_BroadcastDelveShareSync(entryId, mode, channel, isTest)
	if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then
		return
	end
	if type(entryId) ~= "string" or entryId == "" or entryId:find("|", 1, true) then
		return
	end
	local payload = table.concat({ PROTO, ChatLocale(), mode or "brief", entryId }, "|")
	if isTest then
		local me = UnitName and select(1, UnitName("player"))
		local realm = GetNormalizedRealmName and GetNormalizedRealmName()
		if me and realm then
			pcall(C_ChatInfo.SendAddonMessage, PREFIX, payload, "WHISPER", me .. "-" .. realm)
		end
		return
	end
	if channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT" then
		pcall(C_ChatInfo.SendAddonMessage, PREFIX, payload, channel)
	end
end

local function RenderLocal(senderName, entryId, mode, isTest)
	local lines = ns.BuildDelvePartyShareLines and ns.BuildDelvePartyShareLines(entryId, mode)
	if not lines then
		return
	end
	local frame = DEFAULT_CHAT_FRAME
	if not (frame and frame.AddMessage) then
		return
	end
	local headerFmt = (ns.LChat and ns:LChat("DELVE_SHARE_XLOC_HEADER_FMT"))
		or (ns.L and ns:L("DELVE_SHARE_XLOC_HEADER_FMT"))
		or "%s"
	local header = headerFmt:format(senderName)
	if isTest then
		header = header .. " (test)"
	end
	frame:AddMessage("|cff71d5ff" .. header .. "|r")
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
		-- Only our own test-mode self-whisper is accepted on this channel.
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

	-- Same chat locale as the sender: the plain chat text already reads
	-- fine for us — print nothing extra. (Test path skips this check.)
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
