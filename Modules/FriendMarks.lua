local _, ns = ...

--[[
	Friend marks: every friend gets their own raid marker, whatever character they play.

	Rob, 10 Oct 2026: "Carola, Cisca en ik spelen heel vaak samen, met verschillende characters ... ik zet altijd
	als we samen zijn icoontjes boven onze hoofd, zo ben ik bv altijd Ster, Carola oranje rondje en Cisca de paarse
	diamond, kan dat ... automatisch gedaan worden door een knop?" He chose both routes:

	A. Through MH (MEASURED as a working path: the same hidden addon channel the consumable board uses, Comms.lua):
	   each player picks THEIR OWN marker once (`/mh mark me star`, or Settings), account-wide because MidnightHelperDB
	   is one table per account. In a group their MH tells the others ("MHMark" prefix). Nothing shows on their screen.
	B. Through the Battle.net friends list, for friends without MH: `/mh mark friend Carola#1234 circle` links a
	   BattleTag to a marker; the friend list says which character that friend is on right now.
	   ⚠️ AFGELEID, not measured: that C_BattleNet.GetFriendGameAccountInfo still gives characterName/realmName to an
	   addon in 12.1. `/mh mark friends` prints what it sees, so a silent "no" is visible.

	The FastMark bar's friend button reads ns.FriendMarkPlan() and puts "/tm [@unit] N" lines in a secure macro (out
	of combat). One marker per person; two people asking for the same marker: the first in the plan keeps it (you,
	then group order).
]]

local PREFIX = "MHMark"
local PROTO = "1"
local STALE = 3600

local received = {} -- [normalized name-realm] = { icon, when }
local lastSend = 0

local ICON_NAMES = { star = 1, circle = 2, diamond = 3, triangle = 4, moon = 5, square = 6, cross = 7, x = 7, skull = 8 }

--- "Carola", "Argent Dawn" -> "carola-argentdawn": comms senders and the friend list spell realms differently.
local function Key(name, realm)
	if type(name) ~= "string" or (issecretvalue and issecretvalue(name)) then
		return nil
	end
	if not realm or realm == "" then
		realm = GetNormalizedRealmName and GetNormalizedRealmName() or ""
	end
	return (name .. "-" .. tostring(realm):gsub("[%s%-']", "")):lower()
end

function ns.ParseMarkIcon(s)
	s = tostring(s or ""):lower()
	if s == "off" or s == "none" or s == "0" then
		return 0
	end
	local n = tonumber(s)
	if n and n >= 1 and n <= 8 then
		return math.floor(n)
	end
	return ICON_NAMES[s]
end

function ns.GetMyMarkIcon()
	local n = tonumber(ns.db and ns.db.myMarkIcon)
	return (n and n >= 1 and n <= 8) and n or 0
end

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

local function Broadcast(force)
	local ch = GroupChannel()
	if not (ch and ns.MH_SendAddon) then
		return
	end
	local now = GetTime and GetTime() or 0
	if not force and now - lastSend < 3 then
		return
	end
	lastSend = now
	ns.MH_SendAddon(PREFIX, ("%s|i:%d"):format(PROTO, ns.GetMyMarkIcon()), ch)
end

function ns.SetMyMarkIcon(n)
	ns.db = ns.db or {}
	ns.db.myMarkIcon = (n and n >= 1 and n <= 8) and n or nil
	Broadcast(true)
	if ns.RefreshFastMarkFriends then
		ns.RefreshFastMarkFriends()
	end
end

local BattleNetCharacters -- defined below; SetFriendMark needs it to resolve a character name

--- Link a friend to a marker. `who` is a BattleTag ("Carola#2875") OR, since 10 Oct 2026, the name of a character
--- that friend is playing right now ("MageDobby" or "MageDobby-Khadgar"): Rob typed two BattleTags that were not the
--- real ones (MEASURED, his /mh mark friends: dobby#8274 vs the friend list's carola#2875), so a name the player
--- can read off the screen is looked up in the Battle.net friend list instead.
--- @return the BattleTag that was stored (lowercased), or nil
function ns.SetFriendMark(who, n)
	if type(who) ~= "string" or who == "" then
		return nil
	end
	local tag
	if who:find("#") then
		tag = who:lower()
	elseif BattleNetCharacters then
		local map = BattleNetCharacters()
		local want = who:lower():gsub("[%s']", "")
		for k, t in pairs(map) do
			local name = k:match("^([^%-]+)")
			if k == want or name == want then
				tag = t
				break
			end
		end
	end
	if not tag then
		return nil
	end
	ns.db = ns.db or {}
	ns.db.friendMarks = ns.db.friendMarks or {}
	ns.db.friendMarks[tag] = (n and n >= 1 and n <= 8) and n or nil
	if ns.RefreshFastMarkFriends then
		ns.RefreshFastMarkFriends()
	end
	return tag
end

--- Ask the group to say their markers again (a message is lost by anyone on a loading screen).
function ns.RequestFriendMarks()
	local ch = GroupChannel()
	if ch and ns.MH_SendAddon then
		ns.MH_SendAddon(PREFIX, PROTO .. "|cmd:req", ch)
	end
end

--- Character key -> lowercased BattleTag, for every friend online in WoW right now. Route B.
BattleNetCharacters = function()
	local map, seen = {}, 0
	if not (BNGetNumFriends and C_BattleNet and C_BattleNet.GetFriendAccountInfo) then
		return map, seen, "C_BattleNet missing"
	end
	local ok, num = pcall(BNGetNumFriends)
	for i = 1, (ok and tonumber(num) or 0) do
		local okA, acc = pcall(C_BattleNet.GetFriendAccountInfo, i)
		local tag = okA and type(acc) == "table" and acc.battleTag
		if type(tag) == "string" and not (issecretvalue and issecretvalue(tag)) then
			local n = 1
			if C_BattleNet.GetFriendNumGameAccounts then
				local okN, c = pcall(C_BattleNet.GetFriendNumGameAccounts, i)
				n = okN and tonumber(c) or 1
			end
			for j = 1, n do
				local g
				if C_BattleNet.GetFriendGameAccountInfo then
					local okG, gi = pcall(C_BattleNet.GetFriendGameAccountInfo, i, j)
					g = okG and gi or nil
				end
				g = g or (j == 1 and acc.gameAccountInfo) or nil
				if type(g) == "table" and g.characterName and (g.clientProgram == (BNET_CLIENT_WOW or "WoW")) then
					local k = Key(g.characterName, g.realmName)
					if k then
						map[k] = tag:lower()
						seen = seen + 1
					end
				end
			end
		end
	end
	return map, seen
end

local function GroupUnits()
	local units = {}
	if IsInRaid and IsInRaid() then
		for i = 1, 40 do
			units[#units + 1] = "raid" .. i
		end
	else
		for i = 1, 4 do
			units[#units + 1] = "party" .. i
		end
	end
	return units
end

--- Who gets which marker right now: { { unit, icon, who, src }, ... }, you first, then group order.
function ns.FriendMarkPlan()
	local out, used = {}, {}
	local function add(unit, icon, who, src)
		if icon and icon >= 1 and icon <= 8 and not used[icon] then
			used[icon] = true
			out[#out + 1] = { unit = unit, icon = icon, who = who, src = src }
		end
	end
	local me = UnitName and UnitName("player")
	add("player", ns.GetMyMarkIcon(), me, "you")
	local friendMarks = (ns.db and ns.db.friendMarks) or {}
	local bnet = next(friendMarks) and BattleNetCharacters() or {}
	local now = GetTime and GetTime() or 0
	for _, u in ipairs(GroupUnits()) do
		if UnitExists and UnitExists(u) and not (UnitIsUnit and UnitIsUnit(u, "player")) then
			local name, realm = UnitFullName(u)
			local k = Key(name, realm)
			local r = k and received[k]
			if r and r.icon > 0 and now - (r.when or 0) < STALE then
				add(u, r.icon, name, "MH")
			elseif k and bnet[k] and friendMarks[bnet[k]] then
				add(u, friendMarks[bnet[k]], name, "Battle.net")
			end
		end
	end
	return out
end

--- `/mh mark friends`: what MH knows and why, so a friend who gets no marker can be explained.
function ns.PrintFriendMarks()
	local p = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s friend marks: you = %d (%s)"):format(p, ns.GetMyMarkIcon(),
		ns.GetMyMarkIcon() > 0 and "/mh mark me <star..skull|off>" or "none set: /mh mark me star"))
	local n = 0
	for k, r in pairs(received) do
		n = n + 1
		print(("   via MH: %s = %d"):format(k, r.icon or 0))
	end
	if n == 0 then
		print("   via MH: nobody yet (they need MH and a marker of their own; /mh mark friends asks again)")
	end
	local map, seen, why = BattleNetCharacters()
	local online = {}
	for _, t in pairs(map) do
		online[t] = true
	end
	for tag, icon in pairs((ns.db and ns.db.friendMarks) or {}) do
		-- A link whose BattleTag is not among the friends in WoW right now: say so, because a mistyped tag
		-- (Rob, 10 Oct 2026) looks exactly like a friend who is simply offline.
		print(("   Battle.net link: %s = %d%s"):format(tag, icon,
			online[tag] and "" or "  |cffff8080(not in WoW right now - or a typo? /mh mark friend <character name> <marker>)|r"))
	end
	print(("   Battle.net friends in WoW right now: %d%s"):format(seen, why and (" (" .. why .. ")") or ""))
	for k, tag in pairs(map) do
		print(("      %s = %s"):format(k, tag))
	end
	for _, e in ipairs(ns.FriendMarkPlan()) do
		print(("   plan: %s (%s) -> marker %d [%s]"):format(tostring(e.who), e.unit, e.icon, e.src))
	end
	ns.RequestFriendMarks()
end

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
	pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, prefix, msg, channel, sender)
	if event ~= "CHAT_MSG_ADDON" then
		if C_Timer and C_Timer.After then
			C_Timer.After(1.5, function()
				Broadcast(false)
			end)
		end
		return
	end
	if prefix ~= PREFIX or type(msg) ~= "string" or type(sender) ~= "string" then
		return
	end
	if not (channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT") then
		return
	end
	local name, realm = sender:match("^([^%-]+)%-?(.*)$")
	local k = Key(name, realm)
	if not k or k == Key(UnitName and UnitName("player"), nil) then
		return
	end
	if msg == PROTO .. "|cmd:req" then
		if C_Timer and C_Timer.After then
			C_Timer.After(0.5 + math.random(), function()
				Broadcast(true)
			end)
		end
		return
	end
	local icon = tonumber(msg:match("^" .. PROTO .. "|i:(%d)$"))
	if icon then
		received[k] = { icon = icon, when = GetTime and GetTime() or 0 }
		if ns.RefreshFastMarkFriends then
			ns.RefreshFastMarkFriends()
		end
	end
end)
