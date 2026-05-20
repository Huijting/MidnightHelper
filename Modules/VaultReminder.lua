--[[
	Midnight Helper — Great Vault reset-day reminders (chat, minimap tooltip, icon pulse).
]]

local addonName, ns = ...

local sessionChatDone = false
local pulseFrame
local pulseBtn
local pulsePhase = 0

local function GetVaultReminderSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { enabled = true, chat = true, minimap = true, ping = true }
	end
	if type(ui.vaultReminder) ~= "table" then
		ui.vaultReminder = {
			enabled = true,
			chat = true,
			minimap = true,
			ping = true,
		}
	end
	return ui.vaultReminder
end

local function IsResetDayNow()
	local now = date("*t")
	return now and tonumber(now.wday) == 4
end

local function GetLocalResetAnchorTs()
	local now = time()
	local t = date("*t", now)
	if not t then
		return now
	end
	local daysSinceReset = ((tonumber(t.wday) or 1) - 4) % 7
	local resetDay = {
		year = t.year,
		month = t.month,
		day = t.day - daysSinceReset,
		hour = 8,
		min = 0,
		sec = 0,
	}
	local anchor = time(resetDay)
	if anchor and now < anchor then
		anchor = anchor - 7 * 24 * 60 * 60
	end
	return anchor or now
end

local function VaultHasClaimableRewardsLive()
	if not C_WeeklyRewards or not C_WeeklyRewards.HasAvailableRewards then
		return false
	end
	local ok, avail = pcall(C_WeeklyRewards.HasAvailableRewards)
	return ok and avail == true
end

local function FormatCharLabel(name, realm)
	local nm = name
	if type(nm) ~= "string" or nm == "" or nm == "?" then
		return ns:L("ALT_OVERVIEW_UNKNOWN")
	end
	local r = realm
	if type(r) ~= "string" then
		r = ""
	end
	return nm .. (r ~= "" and ("-" .. r) or "")
end

local function AddEntry(entries, seen, guid, name, realm, kind, isCurrent)
	if type(guid) ~= "string" or guid == "" or seen[guid] then
		return
	end
	seen[guid] = true
	entries[#entries + 1] = {
		guid = guid,
		label = FormatCharLabel(name, realm),
		kind = kind,
		isCurrent = isCurrent and true or false,
	}
end

function ns.GetVaultReminderState()
	local settings = GetVaultReminderSettings()
	local entries = {}
	local seen = {}
	local resetDay = IsResetDayNow()
	local curGuid = UnitGUID("player")
	local liveReady = VaultHasClaimableRewardsLive()

	if settings.enabled and curGuid and liveReady then
		local nm, realm = UnitFullName("player")
		AddEntry(entries, seen, curGuid, nm or UnitName("player"), realm, "ready", true)
	end

	local bag = ns.db and ns.db.charCurrencies
	local resetAnchor = GetLocalResetAnchorTs()
	if settings.enabled and type(bag) == "table" then
		for guid, snap in pairs(bag) do
			if type(snap) == "table" and type(guid) == "string" and string.match(guid, "^Player%-") then
				local nm = snap.name
				if type(nm) == "string" and nm ~= "" and nm ~= "?" then
					local hasReady = (tonumber(snap.vaultHasAvailableRewards) or 0) == 1
					local wu = math.max(0, tonumber(snap.vaultWorldUnlocked) or tonumber(snap.vaultUnlocked) or 0)
					local du = math.max(0, tonumber(snap.vaultDungeonUnlocked) or 0)
					local ru = math.max(0, tonumber(snap.vaultRaidUnlocked) or 0)
					local unlockedAny = (wu + du + ru) > 0
					local staleSinceReset = (tonumber(snap.ts) or 0) > 0 and (tonumber(snap.ts) or 0) < resetAnchor
					local isCurrent = guid == curGuid

					if hasReady and not (isCurrent and liveReady) then
						AddEntry(entries, seen, guid, nm, snap.realm, "ready", isCurrent)
					elseif resetDay and staleSinceReset and unlockedAny and not hasReady then
						AddEntry(entries, seen, guid, nm, snap.realm, "likely", isCurrent)
					end
				end
			end
		end
	end

	table.sort(entries, function(a, b)
		if a.isCurrent ~= b.isCurrent then
			return a.isCurrent
		end
		if a.kind ~= b.kind then
			return a.kind == "ready"
		end
		return tostring(a.label) < tostring(b.label)
	end)

	return {
		active = settings.enabled and #entries > 0,
		entries = entries,
		resetDay = resetDay,
		settings = settings,
	}
end

local function EnsurePulseFrame()
	if pulseFrame then
		return
	end
	pulseFrame = CreateFrame("Frame", nil, UIParent)
	pulseFrame:Hide()
	pulseFrame:SetScript("OnUpdate", function(_, elapsed)
		if not pulseBtn or not pulseBtn.SetAlpha then
			return
		end
		pulsePhase = pulsePhase + (elapsed or 0)
		local a = 0.55 + 0.45 * (0.5 + 0.5 * math.sin(pulsePhase * 3.2))
		pulseBtn:SetAlpha(a)
	end)
end

local function StopMinimapPulse()
	if pulseFrame then
		pulseFrame:Hide()
	end
	if pulseBtn and pulseBtn.SetAlpha then
		pulseBtn:SetAlpha(1.0)
	end
	pulsePhase = 0
end

local function StartMinimapPulse()
	local settings = GetVaultReminderSettings()
	local state = ns.GetVaultReminderState()
	if not settings.enabled or not settings.ping or not state.active then
		StopMinimapPulse()
		return
	end
	local LibStub = _G.LibStub
	local iconLib = LibStub and LibStub:GetLibrary("LibDBIcon-1.0", true)
	if not iconLib or not iconLib.GetMinimapButton then
		return
	end
	local btn = iconLib:GetMinimapButton(addonName)
	if not btn or (btn.IsForbidden and btn:IsForbidden()) then
		return
	end
	pulseBtn = btn
	EnsurePulseFrame()
	pulseFrame:Show()
end

function ns.UpdateVaultReminderPresentation()
	local state = ns.GetVaultReminderState()
	if state.active and state.settings.ping then
		StartMinimapPulse()
	else
		StopMinimapPulse()
	end
end

function ns.AppendVaultReminderTooltip(tt)
	if not tt or not tt.AddLine then
		return
	end
	local state = ns.GetVaultReminderState()
	if not state.settings.enabled or not state.settings.minimap or not state.active then
		return
	end
	tt:AddLine(" ")
	if state.resetDay then
		tt:AddLine(ns:L("VAULT_REMINDER_TOOLTIP_RESET_DAY"), 1, 0.84, 0.18, true)
	end
	tt:AddLine(ns:L("VAULT_REMINDER_TOOLTIP_TITLE"), 1, 0.9, 0.5)
	for i = 1, math.min(#state.entries, 6) do
		local e = state.entries[i]
		local key = e.kind == "ready" and "VAULT_REMINDER_TOOLTIP_READY_FMT" or "VAULT_REMINDER_TOOLTIP_LIKELY_FMT"
		local mark = e.isCurrent and (" " .. ns:L("ALT_OVERVIEW_YOU")) or ""
		tt:AddLine(ns:L(key):format(tostring(e.label) .. mark), 1, 0.82, 0.35)
	end
	if #state.entries > 6 then
		tt:AddLine(ns:L("VAULT_REMINDER_TOOLTIP_MORE_FMT"):format(#state.entries - 6), 0.75, 0.75, 0.75)
	end
	tt:AddLine(ns:L("VAULT_REMINDER_TOOLTIP_OPEN_HINT"), 0.7, 0.9, 0.7, true)
end

local function PrintVaultReminderChat()
	local state = ns.GetVaultReminderState()
	if not state.settings.enabled or not state.settings.chat or not state.active then
		return
	end
	if sessionChatDone then
		return
	end
	sessionChatDone = true

	local prefix = ("|cffffcc00%s|r "):format(ns:L("PRINT_PREFIX"))
	if #state.entries == 1 then
		local e = state.entries[1]
		local key = e.kind == "ready" and "VAULT_REMINDER_CHAT_ONE_READY" or "VAULT_REMINDER_CHAT_ONE_LIKELY"
		print(prefix .. ns:L(key):format(e.label))
	else
		print(prefix .. ns:L("VAULT_REMINDER_CHAT_SUMMARY_FMT"):format(#state.entries))
		for i = 1, #state.entries do
			local e = state.entries[i]
			local key = e.kind == "ready" and "VAULT_REMINDER_CHAT_LINE_READY" or "VAULT_REMINDER_CHAT_LINE_LIKELY"
			print(prefix .. ns:L(key):format(e.label))
		end
	end
	print(prefix .. ns:L("VAULT_REMINDER_CHAT_OPEN_HINT"))
end

local function ScheduleVaultReminderUpdate(delay)
	if C_Timer and C_Timer.After then
		C_Timer.After(delay or 1.5, function()
			ns.UpdateVaultReminderPresentation()
			PrintVaultReminderChat()
		end)
	else
		ns.UpdateVaultReminderPresentation()
		PrintVaultReminderChat()
	end
end

function ns.GetVaultReminderSettings()
	return GetVaultReminderSettings()
end

function ns.SetVaultReminderOption(key, value)
	local s = GetVaultReminderSettings()
	if s[key] ~= nil then
		s[key] = value and true or false
	end
	ns.UpdateVaultReminderPresentation()
end

local ev = CreateFrame("Frame", nil, UIParent)
ev:RegisterEvent("PLAYER_LOGIN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("WEEKLY_REWARDS_UPDATE")
ev:SetScript("OnEvent", function(_, event)
	if not ns.db then
		return
	end
	if event == "PLAYER_LOGIN" then
		sessionChatDone = false
		ScheduleVaultReminderUpdate(2.5)
	elseif event == "WEEKLY_REWARDS_UPDATE" then
		ScheduleVaultReminderUpdate(0.4)
	elseif event == "PLAYER_ENTERING_WORLD" then
		ScheduleVaultReminderUpdate(1.0)
	end
end)
