--[[
	Midnight Helper — share Ritual Coach challenge tips to party / instance chat.
	Works for players without the addon (plain chat). A hidden cross-locale
	descriptor is broadcast alongside via RitualShareSync.lua (prefix MHRitual),
	kept fully separate from the Delve share (MHDelve) so the CF-ready Delve-share
	v2 stays untouched. Self-contained on purpose (plan: Optie 2).

	Shareable content is locale-stable and player-state-independent so a receiver
	can rebuild it from their own locale pack: entryId "challenges" = the full
	challenge list (name + Spoils % + mechanic), sorted by Spoils. Unlock status is
	personal, so it is deliberately NOT shared.
]]

local _, ns = ...

local CHAT_PREFIX = "[MH Ritual]"
local MAX_CHAT_LEN = 255
local SEND_GAP_SEC = 0.35
local SHARE_COOLDOWN_SEC = 18
local CONFIRM_FROM = 3

local pendingSend

local function L(key)
	if ns.LChat then
		return ns:LChat(key)
	end
	return ns.L and ns:L(key) or key
end

local function PlainLen(s)
	if not s then
		return 0
	end
	return #(s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H[^|]+|h", ""):gsub("|h", ""))
end

-- First bullet of a mechanic body, as plain chat text (drop |n tail + bullets).
local function MechanicText(body)
	if not body or body == "" then
		return ""
	end
	local first = body:match("^(.-)|n") or body
	first = first:gsub("•%s*", ""):gsub("^%s+", ""):gsub("%s+$", "")
	return first
end

local PARTY_CATEGORY_HOME = Enum and Enum.PartyCategory and Enum.PartyCategory.Home or 1
local PARTY_CATEGORY_INSTANCE = Enum and Enum.PartyCategory and Enum.PartyCategory.Instance or 2

local function GetGroupShareChannel()
	if IsInRaid and IsInRaid() then
		return "RAID"
	end
	local subgroup = GetNumSubgroupMembers and GetNumSubgroupMembers() or 0
	if subgroup >= 1 and IsInGroup and IsInGroup(PARTY_CATEGORY_HOME) then
		return "PARTY"
	end
	if IsInGroup and IsInGroup(PARTY_CATEGORY_INSTANCE) then
		local instSize = GetNumGroupMembers and GetNumGroupMembers(PARTY_CATEGORY_INSTANCE) or 0
		if instSize > 1 then
			return "INSTANCE_CHAT"
		end
	end
	return nil
end

-- Reuse the existing Delve "share test mode" toggle so solo testing covers both.
local function IsTestMode()
	return ns.GetDelvePartyShareTestMode and ns.GetDelvePartyShareTestMode() and true or false
end

local function GetShareChannel()
	local group = GetGroupShareChannel()
	if group then
		return group, false
	end
	if IsTestMode() then
		return "SAY", true
	end
	return nil, false
end

local function ChatPrint(key, ...)
	if ns.PrintChatKey then
		ns:PrintChatKey(key, ...)
		return
	end
	local msg = L(key)
	if select("#", ...) > 0 then
		msg = msg:format(...)
	end
	if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
		DEFAULT_CHAT_FRAME:AddMessage(("|cff71d5ff%s|r %s"):format(L("PRINT_PREFIX"), msg))
	end
end

--------------------------------------------------------------------------------
-- Build (locale-only, so cross-locale receivers rebuild the same thing)
--------------------------------------------------------------------------------

function ns.BuildRitualShareLines(entryId, mode)
	if entryId ~= "challenges" then
		return nil, "bad_entry"
	end
	local list = ns.GetRitualChallengesForDisplay and ns.GetRitualChallengesForDisplay()
	if type(list) ~= "table" or #list == 0 then
		return nil, "no_data"
	end

	local lines = { ("%s %s"):format(CHAT_PREFIX, L("RITUAL_SHARE_CHALLENGES_HEADER")) }
	for _, c in ipairs(list) do
		local name = c.nameKey and L(c.nameKey) or c.id or "?"
		local pct = c.spoilsPct and (("+%d%%"):format(c.spoilsPct)) or ""
		local mech = ""
		local mechKey = c.sections and c.sections[1] and c.sections[1].bodyKey
		if mechKey then
			mech = MechanicText(L(mechKey))
		end
		local line = ("- %s %s: %s"):format(name, pct, mech)
		if PlainLen(line) > MAX_CHAT_LEN then
			line = line:sub(1, MAX_CHAT_LEN)
		end
		lines[#lines + 1] = line
	end
	return lines, nil, #lines
end

--------------------------------------------------------------------------------
-- Send
--------------------------------------------------------------------------------

local function ClearPendingSend()
	pendingSend = nil
end

local function DoSendLines(lines, entryId, mode)
	if not lines or #lines == 0 then
		ChatPrint("RITUAL_SHARE_FAILED")
		return false
	end
	local channel, isTest = GetShareChannel()
	if not channel then
		ChatPrint("RITUAL_SHARE_NO_GROUP")
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		ChatPrint("RITUAL_SHARE_COMBAT")
		return false
	end

	-- Hidden cross-locale descriptor (RitualShareSync.lua), same moment as text.
	if ns.MH_BroadcastRitualShareSync and entryId then
		ns.MH_BroadcastRitualShareSync(entryId, mode, channel, isTest)
	end

	for idx = 1, #lines do
		local delay = (idx - 1) * SEND_GAP_SEC
		local function fire()
			local msg = lines[idx]
			ns.MH_SendChat(msg, channel) -- lockdown-gate + queue (Comms.lua, review F2.2)
			if idx >= #lines then
				ClearPendingSend()
				if isTest then
					ChatPrint("RITUAL_SHARE_SENT_TEST_FMT", #lines)
				else
					ChatPrint("RITUAL_SHARE_SENT_FMT", #lines, channel)
				end
			end
		end
		if delay > 0 and C_Timer and C_Timer.After then
			C_Timer.After(delay, fire)
		else
			fire()
		end
	end
	return true
end

function ns.SendRitualShare(entryId, mode)
	entryId = entryId or "challenges"
	mode = mode or "all"
	if pendingSend then
		ChatPrint("RITUAL_SHARE_BUSY")
		return false
	end

	local now = GetTime and GetTime() or 0
	ns._mhRitualShareLastAt = ns._mhRitualShareLastAt or 0
	if now - ns._mhRitualShareLastAt < SHARE_COOLDOWN_SEC then
		if now - (ns._mhRitualShareCooldownWarnAt or 0) >= 1.5 then
			ns._mhRitualShareCooldownWarnAt = now
			ChatPrint("RITUAL_SHARE_COOLDOWN")
		end
		return false
	end

	local lines, err, count = ns.BuildRitualShareLines(entryId, mode)
	if not lines then
		ChatPrint("RITUAL_SHARE_FAILED")
		return false
	end

	local function runSend()
		ns._mhRitualShareLastAt = GetTime and GetTime() or 0
		pendingSend = true
		if C_Timer and C_Timer.After then
			C_Timer.After(12, function()
				if pendingSend then
					ClearPendingSend()
				end
			end)
		end
		if not DoSendLines(lines, entryId, mode) then
			ClearPendingSend()
		end
	end

	-- Confirm before posting several lines to group chat.
	if count and count >= CONFIRM_FROM then
		if not StaticPopupDialogs.MH_RITUAL_SHARE_CONFIRM then
			StaticPopupDialogs.MH_RITUAL_SHARE_CONFIRM = {
				text = "%s",
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					if ns._mhRitualSharePending then
						ns._mhRitualSharePending()
						ns._mhRitualSharePending = nil
					end
				end,
				OnCancel = function()
					ns._mhRitualSharePending = nil
				end,
				timeout = 0,
				exclusive = true,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
		end
		ns._mhRitualSharePending = runSend
		StaticPopup_Show("MH_RITUAL_SHARE_CONFIRM", L("RITUAL_SHARE_CONFIRM_FMT"):format(count))
		return true
	end

	runSend()
	return true
end

-- Plain copyable text (for sharing outside a group).
function ns.GetRitualShareCopyText(entryId, mode)
	local lines = ns.BuildRitualShareLines(entryId or "challenges", mode or "all")
	if not lines then
		return ""
	end
	local plain = {}
	for i = 1, #lines do
		plain[#plain + 1] = lines[i]:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
	end
	return table.concat(plain, "\n")
end
