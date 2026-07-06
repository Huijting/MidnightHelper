local addonName, ns = ...

--[[
	Gedeelde uitgaande-comms-helper (Midnight Helper).

	WoW 12.0 introduceerde een chat-messaging-lockdown: tijdens een actief encounter,
	een lopende Mythic+-run of een PvP-match falen SendAddonMessage én SendChatMessage
	STIL. SendAddonMessage retourneert bovendien een Enum.SendAddonMessageResult en
	kent een prefix-throttle (allowance ~10 berichten). Vóór deze helper stuurden zes
	modules rechtstreeks achter een pcall -> berichten verdwenen onzichtbaar precies
	tijdens boss-pulls (review 2026-07 F2.2, warcraft.wiki.gg-geverifieerd).

	Elke MH-sender loopt nu hierlangs:
	  - In lockdown: bericht in een queue i.p.v. droppen; een ticker leegt de queue
	    zodra de lockdown voorbij is.
	  - SendAddonMessage-result = throttle: bericht terug in de queue voor een retry.
	  - Staleness-cap (MAX_AGE): heel oude berichten worden gedropt i.p.v. als muur
	    tekst na een lange run alsnog verstuurd.

	Publiek:
	  ns.MH_SendAddon(prefix, message, chatType, target)  -- addon-message
	  ns.MH_SendChat(message, chatType, target)           -- gewone chat-message
]]

local C_ChatInfo = C_ChatInfo
local C_Timer = C_Timer

local FLUSH_INTERVAL = 1.5 -- seconden tussen queue-flush-pogingen
local MAX_AGE = 30 -- seconden; ouder = droppen (geen late muur tekst)

local queue = {}
local ticker = nil

local function Now()
	return (GetTime and GetTime()) or 0
end

-- Enum.SendAddonMessageResult-helpers. Guarden op bestaan: is het enum-veld er
-- niet, dan nemen we "geen throttle" aan (nooit oneindig re-queueën).
local function IsThrottled(result)
	local R = Enum and Enum.SendAddonMessageResult
	if R and R.AddonMessageThrottle ~= nil then
		return result == R.AddonMessageThrottle
	end
	return false
end

local function InLockdown()
	if C_ChatInfo and C_ChatInfo.InChatMessagingLockdown then
		local ok, res = pcall(C_ChatInfo.InChatMessagingLockdown)
		if ok then
			return res and true or false
		end
	end
	return false
end

-- Verstuurt één queue-item. Retourneert true als het bericht in de queue moet
-- blijven (throttle) zodat de volgende tick het opnieuw probeert.
local function TrySend(item)
	if item.kind == "addon" then
		if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then
			return false
		end
		local ok, result = pcall(C_ChatInfo.SendAddonMessage, item.prefix, item.message, item.chatType, item.target)
		if ok and IsThrottled(result) then
			return true
		end
		return false
	end
	-- chat
	if C_ChatInfo and C_ChatInfo.SendChatMessage then
		pcall(C_ChatInfo.SendChatMessage, item.message, item.chatType, nil, item.target)
	elseif SendChatMessage then
		pcall(SendChatMessage, item.message, item.chatType, nil, item.target)
	end
	return false
end

local function ProcessQueue()
	local now = Now()
	if InLockdown() then
		return -- ticker blijft lopen; wachten tot de lockdown voorbij is
	end
	local i = 1
	while i <= #queue do
		local item = queue[i]
		if (now - (item.when or now)) > MAX_AGE then
			table.remove(queue, i) -- te oud -> droppen
		elseif TrySend(item) then
			break -- throttle: de rest volgende tick
		else
			table.remove(queue, i)
		end
	end
	if #queue == 0 and ticker then
		ticker:Cancel()
		ticker = nil
	end
end

local function EnsureTicker()
	if not ticker and C_Timer and C_Timer.NewTicker then
		ticker = C_Timer.NewTicker(FLUSH_INTERVAL, ProcessQueue)
	end
end

local function Enqueue(item)
	item.when = Now()
	queue[#queue + 1] = item
	EnsureTicker()
end

--- Verstuur een addon-message (prefix-kanaal). Gate op lockdown + throttle-retry.
function ns.MH_SendAddon(prefix, message, chatType, target)
	if not (C_ChatInfo and C_ChatInfo.SendAddonMessage) then
		return
	end
	if InLockdown() then
		Enqueue({ kind = "addon", prefix = prefix, message = message, chatType = chatType, target = target })
		return
	end
	local ok, result = pcall(C_ChatInfo.SendAddonMessage, prefix, message, chatType, target)
	if ok and IsThrottled(result) then
		Enqueue({ kind = "addon", prefix = prefix, message = message, chatType = chatType, target = target })
	end
end

--- Verstuur een gewone chat-message. Gate op lockdown (SendChatMessage kent geen
--- result-code). target alleen relevant voor WHISPER.
function ns.MH_SendChat(message, chatType, target)
	if InLockdown() then
		Enqueue({ kind = "chat", message = message, chatType = chatType, target = target })
		return
	end
	if C_ChatInfo and C_ChatInfo.SendChatMessage then
		pcall(C_ChatInfo.SendChatMessage, message, chatType, nil, target)
	elseif SendChatMessage then
		pcall(SendChatMessage, message, chatType, nil, target)
	end
end
