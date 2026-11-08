local addonName, ns = ...

--[[
	Version notice (8 Nov 2026; Rob: "Versie-melding" → "Ja bouw maar").

	Addons cannot look on the internet, so the only way to learn that a newer Midnight Helper is out is from other
	players. Every copy quietly sends its version over the hidden addon-message channel:
	  - to the guild, once, shortly after login;
	  - to the group, when the group gets bigger;
	  - back to a channel once (at most every 60 s, after a random wait) when it hears an OLDER version there, so
	    someone who just joined learns about the newer one. If another copy already answered with our version or
	    higher during that wait, we stay quiet.
	When it hears a HIGHER version: one chat line per session, and again at the next login while that version was
	heard less than 3 days ago and we still run an older one (a test build heard once must not nag for ever).

	Idea from DungeonJournal (Forever, by Exehn; no licence file, so nothing copied: own code).
	Works in both games; a player only ever hears players of the same game.
	Sending goes through ns.MH_SendAddon (Comms.lua): queued during the chat lockdown of boss fights.

	/mh version [on|off]; bare prints what it knows (a module whose normal result is silence needs that, CLAUDE.md).
]]

local PREFIX = "MHVer"
local PROTO = "1"
local CHAT = "|cffffcc00Midnight Helper:|r "
local REMEMBER_FOR = 3 * 24 * 60 * 60 -- seconds
local REPLY_GAP = 60 -- seconds between answers on one channel
local SEND_GAP = 30 -- seconds between group announcements

local notifiedThisSession = false
local lastSent = {} -- channel -> GetTime()
local pendingReply = {} -- channel -> true while a reply waits
local heardMineOrHigher = {} -- channel -> GetTime() of the last such message
local lastGroupSize = 0
local stats = { sent = 0, heard = 0 }

local function Plain(v)
	if type(issecretvalue) == "function" and issecretvalue(v) then
		return nil
	end
	return v
end

local function Now()
	return (GetTime and GetTime()) or 0
end

local function Settings()
	if not ns.db then
		return { on = true }
	end
	ns.db.versionNotice = ns.db.versionNotice or { on = true }
	return ns.db.versionNotice
end

local function On()
	return Settings().on ~= false
end

--- "5.0.1" -> { 5, 0, 1 }, or nil for anything that is not plain numbers with dots.
local function Parse(v)
	if type(v) ~= "string" or not v:match("^%d+%.%d+[%.%d]*$") then
		return nil
	end
	local t = {}
	for n in v:gmatch("%d+") do
		t[#t + 1] = tonumber(n)
	end
	if #t > 4 or t[1] > 99 then
		return nil
	end
	return t
end

--- 1 when a is newer than b, -1 when older, 0 when the same; nil when either cannot be read.
local function Compare(a, b)
	local x, y = Parse(a), Parse(b)
	if not (x and y) then
		return nil
	end
	for i = 1, math.max(#x, #y) do
		local p, q = x[i] or 0, y[i] or 0
		if p ~= q then
			return p > q and 1 or -1
		end
	end
	return 0
end

local function Mine()
	return ns.GetAddonVersion and ns.GetAddonVersion() or "?"
end

local function Send(channel)
	if not On() or not ns.MH_SendAddon then
		return
	end
	if not Parse(Mine()) then
		return
	end
	lastSent[channel] = Now()
	stats.sent = stats.sent + 1
	ns.MH_SendAddon(PREFIX, PROTO .. "|" .. Mine(), channel)
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

local function Tell(v)
	print(CHAT .. ns:L("VERNOTE_NEWER_FMT"):format(v, Mine()))
end

local function OnHeard(channel, sender, v)
	stats.heard = stats.heard + 1
	local cmp = Compare(v, Mine())
	if cmp == nil then
		return
	end
	if cmp >= 0 then
		heardMineOrHigher[channel] = Now()
	end
	if cmp > 0 then
		local s = Settings()
		local seen = s.seen
		if not seen or Compare(v, seen.v) == 1 or Compare(v, seen.v) == 0 then
			s.seen = { v = v, from = sender, when = time and time() or 0, ch = channel }
		end
		if On() and not notifiedThisSession then
			notifiedThisSession = true
			Tell(v)
		end
	elseif cmp < 0 and On() and not pendingReply[channel] then
		if lastSent[channel] and Now() - lastSent[channel] < REPLY_GAP then
			return
		end
		pendingReply[channel] = true
		local asked = Now()
		C_Timer.After(2 + math.random() * 6, function()
			pendingReply[channel] = nil
			if heardMineOrHigher[channel] and heardMineOrHigher[channel] > asked then
				return -- another copy already answered
			end
			Send(channel)
		end)
	end
end

local function LoginReminder()
	local s = Settings()
	local seen = s.seen
	if not seen then
		return
	end
	if Compare(seen.v, Mine()) ~= 1 then
		s.seen = nil -- updated (or same): nothing to remind
		return
	end
	local age = (time and time() or 0) - (seen.when or 0)
	if age > REMEMBER_FOR then
		return
	end
	if On() and not notifiedThisSession then
		notifiedThisSession = true
		Tell(seen.v)
	end
end

if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
	pcall(C_ChatInfo.RegisterAddonMessagePrefix, PREFIX)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:SetScript("OnEvent", function(_, event, prefix, msg, channel, sender)
	if event == "PLAYER_LOGIN" then
		C_Timer.After(15, function()
			LoginReminder()
			if IsInGuild and IsInGuild() then
				Send("GUILD")
			end
			lastGroupSize = (GetNumGroupMembers and GetNumGroupMembers()) or 0
			local ch = GroupChannel()
			if ch then
				Send(ch)
			end
		end)
		return
	end
	if event == "GROUP_ROSTER_UPDATE" then
		local n = (GetNumGroupMembers and GetNumGroupMembers()) or 0
		local grew = n > lastGroupSize
		lastGroupSize = n
		local ch = GroupChannel()
		if grew and ch and not (lastSent[ch] and Now() - lastSent[ch] < SEND_GAP) then
			C_Timer.After(1 + math.random() * 3, function()
				Send(ch)
			end)
		end
		return
	end
	-- CHAT_MSG_ADDON
	prefix, msg, channel, sender = Plain(prefix), Plain(msg), Plain(channel), Plain(sender)
	if prefix ~= PREFIX or type(msg) ~= "string" or type(sender) ~= "string" then
		return
	end
	if not (channel == "GUILD" or channel == "PARTY" or channel == "RAID" or channel == "INSTANCE_CHAT") then
		return
	end
	local name = sender:match("^([^%-]+)")
	local me = UnitName and Plain(UnitName("player"))
	if name and me and name == me then
		return
	end
	local v = msg:match("^" .. PROTO .. "|([%d%.]+)$")
	if v then
		OnHeard(channel, sender, v)
	end
end)

--- /mh version [on|off]
function ns.VersionNoticeSlash(arg)
	arg = (arg or ""):lower()
	if arg == "on" or arg == "off" then
		Settings().on = (arg == "on")
		print(CHAT .. "version notice " .. (arg == "on" and "on." or "off. /mh version on brings it back."))
		return
	end
	local s = Settings()
	print(CHAT .. "version notice: " .. (On() and "on" or "off") .. " (/mh version on|off).")
	print(("   this copy: %s%s"):format(Mine(), Parse(Mine()) and "" or " (not a release number: nothing is sent)"))
	print(("   guild: %s · group channel: %s"):format(
		(IsInGuild and IsInGuild()) and "yes" or "no", tostring(GroupChannel() or "none")))
	print(("   this session: sent %d, heard %d"):format(stats.sent, stats.heard))
	local seen = s.seen
	if seen then
		local ago = math.floor(((time and time() or 0) - (seen.when or 0)) / 3600)
		print(("   highest heard: %s from %s on %s, %d h ago%s"):format(tostring(seen.v), tostring(seen.from),
			tostring(seen.ch), ago, Compare(seen.v, Mine()) == 1 and " (newer than yours)" or ""))
	else
		print("   nobody with a newer version heard (it only knows what guild or group members send).")
	end
end
