--[[
	/mh cleanup — clear the measurement dumps our diagnostics leave in SavedVariables (11 Sep 2026).

	Every probe here follows the SavedVariables-diagnostics habit: write the long answer to
	ns.db.<something>, /reload, read the file. Nothing ever took those answers out again. On
	11 Sep Rob's MidnightHelper.lua was 4.05 MB, loaded at every login and /reload, and most of it
	was dumps of finished investigations (tierProbe alone 2 MB; the Valeera chunk log still on and
	writing a row per loot). A session looking into slow start-up found it; Rob asked for this.

	🔴 A FIXED LIST, NEVER A PATTERN. "Log" and "capture" in a name say nothing: delveLog is the
	Delve & Ritual Log feature, captures feeds the rare capture, ejCapture is still the source the
	raid data grows from. Every key below was checked on 11 Sep: written by a diagnostic command,
	read by nothing but that diagnostic's own report (or by nothing at all). Each can be made
	again with the command that made it. Kept off the list on purpose, because a feature reads
	them: dispelCapture (DispelHelper), ritualBossSpy (RitualBossCoach), eventSpy (EventScheduler),
	soulLedger, captures, ejCapture, keybindExport and editModeBarsExport (exports read outside the
	game), and every setting.

	⚠️ MEASURED ON ROB'S CLIENT THE SAME DAY: after "yes" and a /reload three came straight back.
	dispelFieldLog and dispelLookupLog belong to DispelCapture, which runs all the time and keeps one
	row per pattern - a live collector's logs, not a finished measurement - so they are off the list
	now, like dispelCapture itself. kicksProbeContext came back because Rob's `/mh kicks probe` had
	been left ON, writing a row per zone change (60 at most). A dump whose switch is still on is
	not cleaned, it is refilled; so the switches below are reported, and "yes" turns them off.

	Two steps, like any delete: /mh cleanup lists what is there and how big, /mh cleanup yes
	clears it. And one line in chat at login when the dumps pass 1 MB, so this cannot quietly
	grow back - the other half of "build a way to see that it went quiet".
]]

local _, ns = ...

--- key = the ns.db field; by = the file that writes it ("" = nothing writes it any more).
local DUMPS = {
	{ key = "tierProbe", by = "TierProbe.lua" },
	{ key = "chunkLog", by = "ValeeraProgress.lua" },
	{ key = "chunkProbe", by = "ValeeraProgress.lua" },
	{ key = "atalProbe", by = "AtalUtekProbe.lua" },
	{ key = "tierScan", by = "EncounterCapture.lua" },
	{ key = "unlearnedDump", by = "Profession.lua" },
	{ key = "profIdDump", by = "Profession.lua" },
	{ key = "probeNodes", by = "Profession.lua" },
	{ key = "sniffLog", by = "EventSniffer.lua" },
	{ key = "lockProbe", by = "ProfessionAcademy.lua" },
	{ key = "kpProbe", by = "ProfessionAcademy.lua" },
	{ key = "knowledgeProbeApi", by = "Knowledge.lua" },
	{ key = "knowledgeProbe", by = "Knowledge.lua" },
	{ key = "worldBossProbe", by = "WorldBossProbe.lua" },
	{ key = "crestProbe", by = "DawncrestGuide.lua" },
	{ key = "crestScanProbe", by = "DawncrestGuide.lua" },
	{ key = "itemScan", by = "SpotLog.lua" },
	{ key = "spellScan", by = "SpotLog.lua" },
	{ key = "crestSnap", by = "SpotLog.lua" },
	{ key = "crestRuns", by = "SpotLog.lua" },
	{ key = "barInventory", by = "BarInventory.lua" },
	{ key = "kicksProbeContext", by = "InterruptScore.lua" },
	{ key = "kicksProbeLog", by = "InterruptScore.lua" },
	{ key = "kickProbe", by = "InterruptEventProbe.lua" },
	{ key = "questSnap", by = "Rares.lua" },
	{ key = "rareQuestProbe", by = "Rares.lua" },
	{ key = "delveExitScan", by = "QuickBar.lua" },
	{ key = "mechProbe", by = "MechanicNameProbe.lua" },
	{ key = "autoMapDump", by = "KeybindAutoMap.lua" },
	{ key = "survivalProbe", by = "SurvivalPlan.lua" },
	{ key = "partyTargetProbe", by = "PartyTargetProbe.lua" },
	{ key = "achDump", by = "AchievementFind.lua" },
	{ key = "achCheck", by = "AchievementFind.lua" },
	{ key = "dundunScan", by = "DundunShrine.lua" },
	{ key = "api12Probe", by = "ApiProbe.lua" },
	{ key = "auraReadProbe", by = "Auras.lua" },
	{ key = "auraInstanceProbe", by = "Auras.lua" },
	{ key = "auraSpellProbe", by = "Auras.lua" },
	{ key = "twinProbe", by = "TwinProbe.lua" },
	{ key = "companionProbe", by = "DelveCuriosAdvisor.lua" },
	{ key = "bindingSetProbe", by = "KeybindSchema.lua" },
	{ key = "eventProbe", by = "EventProbe.lua" },
	{ key = "devShotRects", by = "DevShots.lua" },
	{ key = "curScan", by = "CurrencyAccount.lua" }, -- /mh curscan (Spec 39), read by nothing
	-- Left behind by code that no longer exists: nothing writes or reads them.
	{ key = "interruptedByProbe", by = "" },
	{ key = "braceProbe", by = "" },
	{ key = "toastLog", by = "" },
	{ key = "codexMeasure", by = "" },
}

local NOTICE_KB = 1024

--- Roughly how many bytes a value takes in the SavedVariables file. An estimate - the file's
--- own formatting differs - but the same order of magnitude, which is all a "how big" needs.
local function Weigh(v, seen, depth)
	local t = type(v)
	if t == "string" then
		return #v + 4
	elseif t == "number" then
		return 12
	elseif t == "boolean" then
		return 6
	elseif t ~= "table" then
		return 4
	end
	if seen[v] or depth > 40 then
		return 0
	end
	seen[v] = true
	local n = 4
	for k, x in pairs(v) do
		n = n + Weigh(k, seen, depth + 1) + Weigh(x, seen, depth + 1) + 6
	end
	return n
end

--- @return list of { key, by, kb }, total kb - only the dumps that exist.
local function Present()
	local db = ns.db
	local out, total = {}, 0
	if type(db) ~= "table" then
		return out, 0
	end
	for _, d in ipairs(DUMPS) do
		local v = db[d.key]
		if v ~= nil then
			local kb = Weigh(v, {}, 0) / 1024
			out[#out + 1] = { key = d.key, by = d.by, kb = kb }
			total = total + kb
		end
	end
	table.sort(out, function(a, b)
		return a.kb > b.kb
	end)
	return out, total
end

--- Recorders that refill a dump for as long as they are on. Each: is it on, how to turn it off.
local SWITCHES = {
	{
		label = "Valeera loot log (/mh chunklog)",
		isOn = function()
			local v = ns.db and ns.db.valeera
			return type(v) == "table" and v.log == true
		end,
		off = function()
			ns.db.valeera.log = false
		end,
	},
	{
		label = "kicks probe (/mh kicks probe)",
		isOn = function()
			return ns.db and ns.db.kicksProbe == true
		end,
		off = function()
			ns.db.kicksProbe = false
		end,
	},
}

local function SwitchesOn()
	local on = {}
	for _, s in ipairs(SWITCHES) do
		local ok, v = pcall(s.isOn)
		if ok and v then
			on[#on + 1] = s
		end
	end
	return on
end

--- /mh cleanup [yes]. English on purpose, like the other diagnostics: it ships, and a report
--- pasted into a bug should read the same in every language.
function ns.RunSavedVarCleanup(arg)
	local p = "|cffffcc00" .. ns:L("PRINT_PREFIX") .. "|r"
	local list, total = Present()
	local confirm = type(arg) == "string" and arg:lower() == "yes"
	local on = SwitchesOn()
	if not confirm then
		if #list == 0 and #on == 0 then
			print(p .. " No measurement dumps in your SavedVariables, and no recorder left on. Nothing to clear.")
			return
		end
		print(("%s %d measurement dump(s), about %d KB, loaded at every login and /reload:"):format(
			p, #list, math.floor(total + 0.5)))
		for _, d in ipairs(list) do
			local by = d.by ~= "" and d.by or "nothing writes this any more"
			print(("   %-22s %6.1f KB   |cff8a8f98%s|r"):format(d.key, d.kb, by))
		end
		for _, s in ipairs(on) do
			print(("   |cffffcc00Still recording:|r %s - clearing turns it off, or it refills."):format(s.label))
		end
		print("   Kept on purpose: ejCapture (source for the raid data), feature data and settings.")
		print("   Type |cffffffff/mh cleanup yes|r to clear these, then |cffffffff/reload|r.")
		return
	end
	local n = 0
	for _, d in ipairs(list) do
		ns.db[d.key] = nil
		n = n + 1
	end
	local turnedOff = {}
	for _, s in ipairs(on) do
		if pcall(s.off) then
			turnedOff[#turnedOff + 1] = s.label
		end
	end
	print(("%s Cleared %d dump(s), about %d KB%s. Now |cffffffff/reload|r so the file shrinks."):format(
		p, n, math.floor(total + 0.5),
		#turnedOff > 0 and (", and turned off: " .. table.concat(turnedOff, ", ")) or ""))
end

-- One line at login when the dumps have grown past NOTICE_KB. Delayed, and only once per
-- session: weighing a few MB of tables is not something to do in the loading screen.
do
	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_LOGIN")
	ev:SetScript("OnEvent", function()
		C_Timer.After(15, function()
			local list, total = Present()
			if #list > 0 and total >= NOTICE_KB then
				print(("|cffffcc00%s|r %d KB of old measurement data is loaded at every login. |cffffffff/mh cleanup|r shows it."):format(
					ns:L("PRINT_PREFIX"), math.floor(total + 0.5)))
			end
		end)
	end)
end
