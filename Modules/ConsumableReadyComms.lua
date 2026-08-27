--[[
	Consumable Ready Check — Fase 2: addon-comms (Rob, 20 jun 2026).

	De standaard-API kan NIET in de tassen van andere spelers kijken. Daarom delen
	MidnightHelper-gebruikers hun EIGEN tas-tellingen via een verborgen addon-
	kanaal (C_ChatInfo.SendAddonMessage, prefix "MHCons"). Elk groepslid met MH
	broadcast bij dungeon-entry / roster-wijziging zijn counts per categorie; de
	ontvanger vult daarmee de "(bag unknown)" van dat lid in met echte tas-iconen.
	Buff-status blijft uit aura-inspectie komen (werkt ook zonder dat de ander MH
	draait); alleen tas-data vergt deze comms.

	Gekloond van DelveShareSync.lua: zelfde prefix-registratie, self-whisper-
	testmodus (solo te verifiëren met /mh readytest), kanaalkeuze en pcall-posture.

	Self-reported: een speler zou in theorie kunnen liegen over zijn tas. Voor een
	vriendschappelijke helper is dat prima; buff-status (aura) is wél hard.
]]

local _, ns = ...

local PREFIX = "MHCons"
local PROTO = "1"
local STALE = 600 -- ontvangen status na 10 min als verouderd beschouwen

local received = {} -- [shortName] = { flask, rune, cpot, hpot, food, hs, when }
local testExpect = false
local lastSend = 0

--------------------------------------------------------------------------------
-- Encode / decode (compacte payload, ruim < 255 bytes)
--------------------------------------------------------------------------------

local function Encode(c)
	c = c or {}
	return ("%s|fl:%d,ru:%d,cp:%d,hp:%d,fo:%d,hs:%d"):format(
		PROTO,
		c.flask or 0,
		c.rune or 0,
		c.cpot or 0,
		c.hpot or 0,
		c.food or 0,
		c.hs or 0
	)
end

local function Decode(msg)
	local proto, body = tostring(msg or ""):match("^([^|]+)|(.+)$")
	if proto ~= PROTO or not body then
		return nil
	end
	local t = {}
	for k, v in body:gmatch("(%a+):(%d+)") do
		t[k] = tonumber(v)
	end
	return {
		flask = t.fl or 0,
		rune = t.ru or 0,
		cpot = t.cp or 0,
		hpot = t.hp or 0,
		food = t.fo or 0,
		hs = t.hs or 0,
	}
end

--------------------------------------------------------------------------------
-- Kanaalkeuze + ontvangen-status ophalen
--------------------------------------------------------------------------------

local function GroupChannel()
	if IsInGroup and LE_PARTY_CATEGORY_INSTANCE and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		return "INSTANCE_CHAT"
	end
	if IsInRaid and IsInRaid() then
		return "RAID"
	end
	if IsInGroup and IsInGroup() then
		return "PARTY"
	end
	return nil
end

-- @return tabel { flask, rune, cpot, hpot, food, hs } voor `name`, of nil als er
-- geen (verse) comms-data is. Gebruikt door OtherLine in ConsumableReadyCheck.
function ns.GetConsumableCommsStatus(name)
	local e = name and received[name]
	if not e then
		return nil
	end
	local now = (GetTime and GetTime()) or 0
	if now - (e.when or 0) > STALE then
		return nil
	end
	return e
end

--------------------------------------------------------------------------------
-- Broadcast eigen status (getthrottled)
--------------------------------------------------------------------------------

function ns.BroadcastConsumableStatus()
	if not (C_ChatInfo and C_ChatInfo.SendAddonMessage and ns.GetOwnConsumableBagCounts) then
		return
	end
	local ch = GroupChannel()
	if not ch then
		return
	end
	local now = (GetTime and GetTime()) or 0
	if now - lastSend < 3 then
		return -- simpele throttle tegen spam bij snelle roster-events
	end
	lastSend = now
	ns.MH_SendAddon(PREFIX, Encode(ns.GetOwnConsumableBagCounts()), ch)
end

-- Solo-test: whisper je eigen status naar jezelf en laat de ontvang-kant 'm
-- verwerken (bewijst de hele send -> receive -> decode -> store-pijplijn).
function ns.ConsumableReadyTest()
	if not (C_ChatInfo and C_ChatInfo.SendAddonMessage and ns.GetOwnConsumableBagCounts) then
		print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CONSREADY_API_MISSING")))
		return
	end
	local me = UnitName and UnitName("player")
	local realm = GetNormalizedRealmName and GetNormalizedRealmName()
	if not (me and realm) then
		return
	end
	testExpect = true
	ns.MH_SendAddon(PREFIX, Encode(ns.GetOwnConsumableBagCounts()), "WHISPER", me .. "-" .. realm)
	print(("|cffffcc00%s|r %s"):format(ns:L("PRINT_PREFIX"), ns:L("CONSREADY_TEST_SENT")))
end

-- Leader-commando: vraag groepsleden met MH om hun consumable-bord opnieuw te
-- tonen (Rob 21 jun). Alleen de leader/assist mag broadcasten; werkt alleen voor
-- groepsleden die óók MH draaien, en hun bord auto-hide't na 25s zoals altijd.
function ns.BroadcastReopenBoard()
	if not (IsInGroup and IsInGroup()) then
		if ns.PrintChat then
			ns:PrintChat(ns:L("CONSREADY_BOARDALL_NOGROUP"))
		end
		return false
	end
	local isLead = (UnitIsGroupLeader and UnitIsGroupLeader("player"))
		or (UnitIsGroupAssistant and UnitIsGroupAssistant("player"))
	if not isLead then
		if ns.PrintChat then
			ns:PrintChat(ns:L("CONSREADY_BOARDALL_NOTLEAD"))
		end
		return false
	end
	local ch = GroupChannel()
	if ch then
		ns.MH_SendAddon(PREFIX, PROTO .. "|cmd:show", ch)
	end
	if ns.ShowConsumableBoard then
		ns.ShowConsumableBoard() -- bij jezelf ook tonen
	end
	if ns.PrintChat then
		ns:PrintChat(ns:L("CONSREADY_BOARDALL_SENT"))
	end
	return true
end

--------------------------------------------------------------------------------
-- Prefix-registratie + ontvangst
--------------------------------------------------------------------------------

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
	pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, prefix, msg, channel, sender)
	if event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
		if C_Timer and C_Timer.After then
			C_Timer.After(1.0, ns.BroadcastConsumableStatus)
		else
			ns.BroadcastConsumableStatus()
		end
		return
	end

	-- CHAT_MSG_ADDON
	if prefix ~= PREFIX or type(msg) ~= "string" then
		return
	end
	local short = sender
	if Ambiguate then
		short = Ambiguate(sender, "short")
	end
	local isSelf = short == (UnitName and UnitName("player"))

	local isTest = false
	if channel == "WHISPER" then
		-- Alleen onze eigen test-self-whisper accepteren.
		if not (isSelf and testExpect) then
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

	-- Leader-commando "toon je bord" (apart van de bag-counts-payload). Onschadelijk
	-- (het bord auto-hide't na 25s); de leader-gating zit aan de zendkant,
	-- de ontvanger kan hem weigeren.
	if msg == PROTO .. "|cmd:show" then
		if ns.ShowConsumableBoard and ns.IsAutoPopupEnabled
			and ns.IsAutoPopupEnabled("consumables") then
			ns.ShowConsumableBoard()
		end
		return
	end

	local data = Decode(msg)
	if not data then
		return
	end
	data.when = (GetTime and GetTime()) or 0
	received[short] = data

	if isTest then
		testExpect = false
		print(("|cffffcc00%s|r %s"):format(
			ns:L("PRINT_PREFIX"),
			ns:L("CONSREADY_TEST_RECV"):format(data.flask, data.rune, data.cpot, data.hpot, data.food, data.hs)
		))
	end
end)
