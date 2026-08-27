--[[
	SMC Dynamic Checklist — quest completion + pin tint + refresh on quest events.
]]

local _, ns = ...

local C_QuestLog = C_QuestLog

local function FilterQuestIds(ids)
	local out = {}
	if type(ids) ~= "table" then
		return out
	end
	for i = 1, #ids do
		local q = tonumber(ids[i])
		if q and q > 0 then
			out[#out + 1] = q
		end
	end
	return out
end

function ns.SMC_IsChecklistEntryTracked(entry)
	return #FilterQuestIds(entry and entry.questIds) > 0
end

--- @return boolean|nil done if trackable, nil if no valid quest IDs
function ns.SMC_IsChecklistEntryDone(entry)
	if type(entry) ~= "table" then
		return nil
	end
	local ids = FilterQuestIds(entry.questIds)
	if #ids == 0 then
		return nil
	end
	if not C_QuestLog or type(C_QuestLog.IsQuestFlaggedCompleted) ~= "function" then
		return nil
	end
	local allMode = entry.mode == "all"
	if allMode then
		for i = 1, #ids do
			if not C_QuestLog.IsQuestFlaggedCompleted(ids[i]) then
				return false
			end
		end
		return true
	end
	for i = 1, #ids do
		if C_QuestLog.IsQuestFlaggedCompleted(ids[i]) then
			return true
		end
	end
	return false
end

--- Resolve checklist entry that owns an SMC pin id (first match).
function ns.SMC_GetChecklistEntryForPinId(pinId)
	if type(pinId) ~= "string" or pinId == "" then
		return nil
	end
	local defs = ns.SMC_CHECKLIST_DEF
	if type(defs) ~= "table" then
		return nil
	end
	for i = 1, #defs do
		local e = defs[i]
		local pins = e and e.pinIds
		if type(pins) == "table" then
			for p = 1, #pins do
				if pins[p] == pinId then
					return e
				end
			end
		end
	end
	return nil
end

local function TintWaypointButton(btn, done)
	if not btn then
		return
	end
	local icon = btn._mhSMCIcon
	local label = btn._mhSMCLabel
	if done == true then
		if icon and icon.SetVertexColor then
			icon:SetVertexColor(0.45, 0.95, 0.55)
		end
		if label and label.SetTextColor then
			label:SetTextColor(0.55, 1.0, 0.65)
		end
	elseif done == false then
		if icon and icon.SetVertexColor then
			icon:SetVertexColor(1, 1, 1)
		end
		if label and label.SetTextColor then
			label:SetTextColor(1, 0.94, 0.75)
		end
	end
end

function ns.SMC_ApplyQuestTintToWaypointButton(btn, point)
	if not btn or type(point) ~= "table" then
		return
	end
	local pid = point.id
	local entry = ns.SMC_GetChecklistEntryForPinId(pid)
	if not entry then
		TintWaypointButton(btn, false)
		return
	end
	local state = ns.SMC_IsChecklistEntryDone(entry)
	if state == nil then
		TintWaypointButton(btn, false)
		return
	end
	TintWaypointButton(btn, state)
end

local function RefreshChecklistRows(panel)
	local rows = panel and panel._mhSMCChecklistRows
	if type(rows) ~= "table" then
		return
	end
	for i = 1, #rows do
		local row = rows[i]
		if row and row.entry and row.statusFs then
			local done = ns.SMC_IsChecklistEntryDone(row.entry)
			if done == nil then
				row.statusFs:SetText("")
				row.statusFs:SetTextColor(0.5, 0.5, 0.5)
			elseif done then
				row.statusFs:SetText(ns:L("SMC_CHK_STATUS_DONE"))
				row.statusFs:SetTextColor(0.45, 0.95, 0.55)
			else
				row.statusFs:SetText(ns:L("SMC_CHK_STATUS_OPEN"))
				row.statusFs:SetTextColor(0.95, 0.72, 0.45)
			end
		end
	end
end

local function RefreshWaypointButtons(panel)
	local list = panel and panel._mhSMCWaypointButtons
	if type(list) ~= "table" then
		return
	end
	for i = 1, #list do
		local pair = list[i]
		if pair then
			ns.SMC_ApplyQuestTintToWaypointButton(pair[1], pair[2])
		end
	end
end

function ns.SMC_RefreshDynamicChecklist()
	local panel = ns.panels and ns.panels.smcguide
	if panel and panel._mhSmlBuilt then
		RefreshChecklistRows(panel)
		RefreshWaypointButtons(panel)
	end
	if ns.RefreshAccountWeeklyChecklist then
		ns.RefreshAccountWeeklyChecklist()
	end
end

do
	local ev = CreateFrame("Frame")
	local pendingTimer
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	ev:RegisterEvent("QUEST_LOG_UPDATE")
	ev:RegisterEvent("QUEST_TURNED_IN")
	-- QUEST_LOG_UPDATE arrives in bursts
	ev:SetScript("OnEvent", function()
		local panel = ns.panels and ns.panels.smcguide
		if pendingTimer or not (panel and panel:IsVisible()) then
			return
		end
		pendingTimer = C_Timer.NewTimer(0.3, function()
			pendingTimer = nil
			ns.SMC_RefreshDynamicChecklist()
		end)
	end)
end
