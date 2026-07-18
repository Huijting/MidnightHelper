--[[
	Midnight Helper — Share Delve Coach tips to party / instance chat.
	Works for players without the addon (plain chat + spell item links).
]]

local _, ns = ...

local CHAT_PREFIX = "[MH Delve]"
local MAX_CHAT_LEN = 255
local SEND_GAP_SEC = 0.35
local SHARE_COOLDOWN_SEC = 18

local SECTION_MODES = {
	overview = { labelKey = "DELVE_COACH_SEC_OVERVIEW", suffix = "OVERVIEW" },
	route = { labelKey = "DELVE_COACH_SEC_ROUTE", suffix = "ROUTE" },
	trash = { labelKey = "DELVE_COACH_SEC_TRASH", suffix = "TRASH" },
	boss = { labelKey = "DELVE_COACH_SEC_BOSS", suffix = "BOSS" },
}

local BRIEF_MODES = { "overview", "trash", "boss" }

local pendingSend

local function GetShareSettings()
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return { confirmMulti = true, footer = false }
	end
	if type(ui.delveCoach) ~= "table" then
		ui.delveCoach = {}
	end
	local s = ui.delveCoach
	if s.shareConfirmMulti == nil then
		s.shareConfirmMulti = true
	end
	if s.shareFooter == nil then
		s.shareFooter = false
	end
	if s.shareTestMode == nil then
		s.shareTestMode = false
	end
	return s
end

function ns.GetDelvePartyShareTestMode()
	return GetShareSettings().shareTestMode and true or false
end

function ns.SetDelvePartyShareTestMode(enabled)
	local ui = ns.db and ns.db.ui
	if type(ui) ~= "table" then
		return
	end
	if type(ui.delveCoach) ~= "table" then
		ui.delveCoach = {}
	end
	ui.delveCoach.shareTestMode = (enabled == true) or (enabled == 1)
	if ns.UpdateDelveShareBarUI then
		ns:UpdateDelveShareBarUI()
	end
end

local function EntryIdToKeyPrefix(entryId)
	if not entryId or entryId == "" then
		return nil
	end
	return "DELVE_CHAT_" .. string.upper(entryId):gsub("[^%w]", "_"):gsub("_+", "_")
end

function ns.GetDelvePartyShareBodyKey(entryId, mode)
	local prefix = EntryIdToKeyPrefix(entryId)
	if not prefix then
		return nil
	end
	if mode == "brief" then
		return nil
	end
	local spec = SECTION_MODES[mode]
	if not spec then
		return nil
	end
	return prefix .. "_" .. spec.suffix
end

local function PlainLen(s)
	if not s then
		return 0
	end
	local plain = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H[^|]+|h", ""):gsub("|h", "")
	return #plain
end

local function PrepareShareBody(body)
	if not body or body == "" then
		return ""
	end
	body = body:gsub("|n", " ")
	body = body:gsub("•%s*", "- ")
	if ns.ExpandDelveTipMarkup then
		body = ns:ExpandDelveTipMarkup(body)
	end
	return body
end

local function SplitForChat(text, maxLen)
	maxLen = maxLen or MAX_CHAT_LEN
	text = (text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" then
		return {}
	end
	local chunks = {}
	local rest = text
	while PlainLen(rest) > maxLen do
		local cut = maxLen
		if cut > #rest then
			cut = #rest
		end
		local piece = rest:sub(1, cut)
		local sp = piece:match(".*()%s")
		if sp and sp > 40 then
			piece = rest:sub(1, sp - 1)
			rest = rest:sub(sp + 1)
		else
			rest = rest:sub(cut + 1)
		end
		piece = piece:gsub("%s+$", "")
		if piece ~= "" then
			chunks[#chunks + 1] = piece
		end
		rest = rest:gsub("^%s+", "")
		if piece == "" and rest == text then
			chunks[#chunks + 1] = rest:sub(1, maxLen)
			rest = rest:sub(maxLen + 1)
		end
	end
	if rest ~= "" then
		chunks[#chunks + 1] = rest
	end
	return chunks
end

local PARTY_CATEGORY_HOME = Enum and Enum.PartyCategory and Enum.PartyCategory.Home or 1
local PARTY_CATEGORY_INSTANCE = Enum and Enum.PartyCategory and Enum.PartyCategory.Instance or 2

local function GetGroupShareChannel()
	if IsInRaid and IsInRaid() then
		return "RAID"
	end
	-- UnitInParty alone is not enough (solo / delve can still report "party" incorrectly).
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

local function GetShareChannel()
	local group = GetGroupShareChannel()
	if group then
		return group, false
	end
	if GetShareSettings().shareTestMode then
		return "SAY", true
	end
	return nil, false
end

local function ChatPrint(key, ...)
	if ns.PrintChatKey then
		ns:PrintChatKey(key, ...)
		return
	end
	local msg = ns.LChat and ns:LChat(key) or (ns.L and ns:L(key) or key)
	if select("#", ...) > 0 then
		msg = msg:format(...)
	end
	if DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.AddMessage then
		DEFAULT_CHAT_FRAME:AddMessage(
			("|cff71d5ff%s|r %s"):format(ns.LChat and ns:LChat("PRINT_PREFIX") or "Midnight Helper:", msg)
		)
	end
end

function ns.BuildDelvePartyShareLines(entryId, mode)
	local entry = ns.GetDelveTipEntryById and ns.GetDelveTipEntryById(entryId)
	if not entry then
		return nil, "no_entry"
	end

	local delveName
	if ns.GetDelveChatDisplayName then
		delveName = ns:GetDelveChatDisplayName(entry)
	else
		delveName = (ns.GetDelveTipDisplayName and ns:GetDelveTipDisplayName(entry)) or entry.rosterName or entryId
	end
	local modes = {}
	if mode == "brief" then
		modes = BRIEF_MODES
	elseif mode == "all" then
		for k in pairs(SECTION_MODES) do
			modes[#modes + 1] = k
		end
		table.sort(modes, function(a, b)
			local order = { overview = 1, route = 2, trash = 3, boss = 4 }
			return (order[a] or 9) < (order[b] or 9)
		end)
	elseif SECTION_MODES[mode] then
		modes = { mode }
	else
		return nil, "bad_mode"
	end

	local blocks = {}
	for _, m in ipairs(modes) do
		local bodyKey = ns.GetDelvePartyShareBodyKey(entryId, m)
		local body = bodyKey and ns.LChat and ns:LChat(bodyKey) or (bodyKey and ns.L and ns:L(bodyKey) or "")
		if body == "" or body == bodyKey then
			return nil, "missing_locale"
		end
		local label = (ns.LChat and ns:LChat(SECTION_MODES[m].labelKey)) or ns:L(SECTION_MODES[m].labelKey)
		blocks[#blocks + 1] = { mode = m, label = label, body = PrepareShareBody(body) }
	end

	local totalParts = 0
	for i = 1, #blocks do
		totalParts = totalParts + #SplitForChat(blocks[i].body)
	end

	local lines = {}
	local partIdx = 0
	for i = 1, #blocks do
		local block = blocks[i]
		local chunks = SplitForChat(block.body)
		for j = 1, #chunks do
			partIdx = partIdx + 1
			local head
			if mode == "brief" or mode == "all" then
				head = ("%s %s (%d/%d) %s"):format(CHAT_PREFIX, delveName, partIdx, totalParts, block.label)
			else
				head = ("%s %s - %s"):format(CHAT_PREFIX, delveName, block.label)
			end
			if #chunks > 1 then
				head = head .. (" [%d/%d]"):format(j, #chunks)
			end
			local line = head .. ": " .. chunks[j]
			if PlainLen(line) > MAX_CHAT_LEN then
				line = chunks[j]
			end
			lines[#lines + 1] = line
		end
	end

	local s = GetShareSettings()
	if s.footer and #lines > 0 then
		lines[#lines + 1] = (ns.LChat and ns:LChat("DELVE_SHARE_FOOTER")) or ns:L("DELVE_SHARE_FOOTER")
	end

	return lines, nil, delveName, #lines
end

local function ClearPendingSend()
	pendingSend = nil
end

local function DoSendLines(lines, entryId, mode)
	if not lines or #lines == 0 then
		ChatPrint("DELVE_SHARE_FAILED")
		return false
	end

	local channel, isTest = GetShareChannel()
	if not channel then
		ChatPrint("DELVE_SHARE_NO_GROUP")
		return false
	end
	if InCombatLockdown and InCombatLockdown() then
		ChatPrint("DELVE_SHARE_COMBAT")
		return false
	end

	-- v2: hidden descriptor alongside the plain text — receivers with MH and
	-- a different locale re-render the tips locally (DelveShareSync.lua).
	if ns.MH_BroadcastDelveShareSync and entryId then
		ns.MH_BroadcastDelveShareSync(entryId, mode, channel, isTest)
	end

	for idx = 1, #lines do
		local delay = (idx - 1) * SEND_GAP_SEC
		local function fire()
			local msg = lines[idx]
			ns.MH_SendChat(msg, channel) -- lockdown-gate + queue (Comms.lua, review F2.2)
			if idx >= #lines then
				ClearPendingSend()
				if isTest then
					ChatPrint("DELVE_SHARE_SENT_TEST_FMT", #lines)
				else
					ChatPrint("DELVE_SHARE_SENT_FMT", #lines, channel)
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

function ns.SendDelvePartyShare(entryId, mode)
	if type(entryId) ~= "string" or entryId == "" then
		ChatPrint("DELVE_SHARE_FAILED")
		return false
	end
	if pendingSend then
		ChatPrint("DELVE_SHARE_BUSY")
		return false
	end

	local now = GetTime and GetTime() or 0
	ns._mhDelveShareLastAt = ns._mhDelveShareLastAt or 0
	if now - ns._mhDelveShareLastAt < SHARE_COOLDOWN_SEC then
		if now - (ns._mhDelveShareCooldownWarnAt or 0) >= 1.5 then
			ns._mhDelveShareCooldownWarnAt = now
			ChatPrint("DELVE_SHARE_COOLDOWN")
		end
		return false
	end

	local lines, err, delveName, count = ns.BuildDelvePartyShareLines(entryId, mode)
	if not lines then
		if err == "missing_locale" then
			ChatPrint("DELVE_SHARE_MISSING")
		else
			ChatPrint("DELVE_SHARE_FAILED")
		end
		return false
	end

	local function runSend()
		ns._mhDelveShareLastAt = GetTime and GetTime() or 0
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

	local s = GetShareSettings()
	if s.shareConfirmMulti and count and count >= 2 then
		if not StaticPopupDialogs.MH_DELVE_SHARE_CONFIRM then
			StaticPopupDialogs.MH_DELVE_SHARE_CONFIRM = {
				text = "%s",
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					if ns._mhDelveSharePending then
						ns._mhDelveSharePending()
						ns._mhDelveSharePending = nil
					end
				end,
				OnCancel = function()
					ns._mhDelveSharePending = nil
					ClearPendingSend()
				end,
				timeout = 0,
				exclusive = true,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
		end
		ns._mhDelveSharePending = runSend
		local text = ns:L("DELVE_SHARE_CONFIRM_FMT"):format(delveName or "?", count)
		StaticPopup_Show("MH_DELVE_SHARE_CONFIRM", text)
		return true
	end

	runSend()
	return true
end

function ns.GetDelvePartyShareCopyText(entryId, mode)
	local lines = ns.BuildDelvePartyShareLines(entryId, mode or "brief")
	if not lines then
		return ""
	end
	local plain = {}
	for i = 1, #lines do
		plain[#plain + 1] = lines[i]:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H([^|]+)|h%[(.-)%]|h", "%2")
	end
	return table.concat(plain, "\n")
end

local copyDialog

--- Shared multi-line copy dialog for the share features.
--- It was born here for delve tips; the ritual share now reuses it instead of
--- cloning ~90 lines of identical frame code (Rob, 19 jul). Toggling with the
--- same `id` closes it again.
--- @param opts table { id=string, text=string, titleKey, hintKey, closeKey }
function ns.ShowShareCopyDialog(opts)
	if type(opts) ~= "table" or not opts.text or opts.text == "" then
		return
	end

	if copyDialog and copyDialog:IsShown() and copyDialog._mhEntryId == opts.id then
		copyDialog:Hide()
		return
	end

	if not copyDialog then
		local f = CreateFrame("Frame", "MidnightHelperDelveShareCopy", UIParent, "BackdropTemplate")
		f:SetSize(420, 220)
		f:SetPoint("CENTER")
		f:SetFrameStrata("DIALOG")
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
		f:SetBackdropColor(0.05, 0.05, 0.08, 0.95)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:RegisterForDrag("LeftButton")
		f:SetScript("OnDragStart", f.StartMoving)
		f:SetScript("OnDragStop", f.StopMovingOrSizing)
		tinsert(UISpecialFrames, f:GetName())

		local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		title:SetPoint("TOP", f, "TOP", 0, -14)
		f._title = title

		local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		hint:SetPoint("TOP", title, "BOTTOM", 0, -4)
		hint:SetWidth(380)
		hint:SetWordWrap(true)
		f._hint = hint

		local scroll = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		scroll:SetPoint("TOPLEFT", hint, "BOTTOMLEFT", -4, -8)
		scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 42)
		f._scroll = scroll

		local eb = CreateFrame("EditBox", nil, scroll)
		eb:SetMultiLine(true)
		eb:SetFontObject("GameFontHighlightSmall")
		eb:SetWidth(360)
		eb:SetAutoFocus(false)
		eb:EnableMouse(true)
		eb:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
			f:Hide()
		end)
		if eb.SetTextInsets then
			eb:SetTextInsets(4, 4, 4, 4)
		end
		scroll:SetScrollChild(eb)
		f._eb = eb

		local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		close:SetSize(80, 22)
		close:SetPoint("BOTTOM", f, "BOTTOM", 0, 14)
		close:SetScript("OnClick", function()
			f:Hide()
		end)
		f._close = close
		copyDialog = f
	end

	copyDialog._mhEntryId = opts.id
	copyDialog._title:SetText(ns:L(opts.titleKey or "DELVE_SHARE_COPY_TITLE"))
	copyDialog._hint:SetText(ns:L(opts.hintKey or "DELVE_SHARE_COPY_HINT"))
	copyDialog._close:SetText(ns:L(opts.closeKey or "DELVE_SHARE_COPY_CLOSE"))
	copyDialog._eb:SetText(opts.text)
	copyDialog._eb:SetCursorPosition(0)
	copyDialog:Show()
	-- Focus + highlight deferred and pcall-guarded: doing this inline is what made
	-- /mh pawn throw "bad argument #2 to HighlightText" when opened from chat
	-- (Rob, 17 jul). Cosmetic, so it must never break the dialog.
	if C_Timer and C_Timer.After then
		C_Timer.After(0, function()
			if copyDialog and copyDialog:IsShown() then
				pcall(copyDialog._eb.SetFocus, copyDialog._eb)
				pcall(copyDialog._eb.HighlightText, copyDialog._eb)
			end
		end)
	end
end

--- Delve tips → the shared copy dialog.
function ns.ToggleDelvePartyShareCopy(entryId, mode)
	mode = mode or "brief"
	local text = ns.GetDelvePartyShareCopyText(entryId, mode)
	if text == "" then
		ChatPrint("DELVE_SHARE_MISSING")
		return
	end
	ns.ShowShareCopyDialog({
		id = "delve:" .. tostring(entryId),
		text = text,
		titleKey = "DELVE_SHARE_COPY_TITLE",
		hintKey = "DELVE_SHARE_COPY_HINT",
		closeKey = "DELVE_SHARE_COPY_CLOSE",
	})
end

function ns:UpdateDelveShareBarUI()
	local f = _G.MidnightHelperDelveCoach
	if not f then
		return
	end
	local testOn = ns.GetDelvePartyShareTestMode and ns.GetDelvePartyShareTestMode()
	if f._shareTestChk then
		f._shareTestChk:SetChecked(testOn and true or false)
	end
	if f._shareTestLabel and f._shareTestLabel.SetText then
		f._shareTestLabel:SetText(ns:L("DELVE_SHARE_TEST_MODE"))
	end
	if f._shareHint then
		if testOn and not GetGroupShareChannel() then
			f._shareHint:SetText(ns:L("DELVE_SHARE_BAR_HINT_TEST"))
		else
			f._shareHint:SetText(ns:L("DELVE_SHARE_BAR_HINT"))
		end
	end
end

function ns.RefreshDelvePartyShareLocale()
	if copyDialog and copyDialog._title then
		copyDialog._title:SetText(ns:L("DELVE_SHARE_COPY_TITLE"))
		copyDialog._hint:SetText(ns:L("DELVE_SHARE_COPY_HINT"))
		if copyDialog._close then
			copyDialog._close:SetText(ns:L("DELVE_SHARE_COPY_CLOSE"))
		end
	end
	if ns.UpdateDelveShareBarUI then
		ns:UpdateDelveShareBarUI()
	end
end
