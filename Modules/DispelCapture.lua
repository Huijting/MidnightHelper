--[[
	Dispel capture (heal-lens data collector, Rob 2026-07-15). The never-lie way
	to grow the per-boss heal-lens data: instead of guessing debuff schools, we
	record the REAL ones from the game. While you're in an instance, this scans
	YOUR OWN debuffs (own auras are readable even in restricted content, unlike
	party/raid auras which 12.x makes secret) and logs any that carry a real
	dispel school (Magic/Curse/Poison/Disease), tagged with the current boss
	(ENCOUNTER_START encounterID) so it maps straight onto ns.BOSS_HEAL_LENS.

	`/mh dispellog` prints what's been captured (share it, or I read it from
	SavedVariables); `/mh dispellog clear` resets it. Deduped per (encounter,
	spell). Only catches dispels that land on the PLAYER — tank-targeted ones stay
	secret — but that's real, verified data with zero guessing.

	All aura reads go through ns.Aura; secret values are skipped (unreadable ≠
	absent), everything is in pcall.
]]

local _, ns = ...

-- dispelName from the API is the English school string; map to our canonical keys.
local SCHOOL = {
	Magic = "magic",
	Curse = "curse",
	Poison = "poison",
	Disease = "disease",
}

local curEncID, curEncName

local function isSecret(v)
	return issecretvalue and v ~= nil and issecretvalue(v) == true
end

local function InInstanceForCapture()
	if not IsInInstance then
		return false
	end
	local inInst, kind = IsInInstance()
	return inInst and (kind == "party" or kind == "raid" or kind == "scenario") or false
end

local function Store()
	if not ns.db then
		return nil
	end
	if type(ns.db.dispelCapture) ~= "table" then
		ns.db.dispelCapture = {}
	end
	return ns.db.dispelCapture
end

local function Capture()
	if not (InInstanceForCapture() and ns.Aura and ns.Aura.ForEachPlayerDebuff) then
		return
	end
	local store = Store()
	if not store then
		return
	end
	ns.Aura.ForEachPlayerDebuff(function(aura)
		local dn = aura.dispelName
		if dn == nil or isSecret(dn) then
			return
		end
		local school = SCHOOL[dn]
		if not school then
			return -- not a Magic/Curse/Poison/Disease debuff
		end
		local id = aura.spellId
		if id == nil or isSecret(id) then
			return
		end
		local key = tostring(curEncID or 0) .. ":" .. tostring(id)
		if store[key] then
			return -- already logged this debuff on this boss
		end
		local nm = (aura.name ~= nil and not isSecret(aura.name)) and tostring(aura.name) or "?"
		local instName, instID = "?", nil
		if GetInstanceInfo then
			local ok, n1, _, _, _, _, _, _, id8 = pcall(GetInstanceInfo)
			if ok then
				instName = n1 or "?"
				instID = id8
			end
		end
		store[key] = {
			spellId = tonumber(id) or 0,
			name = nm,
			school = school,
			encounterID = curEncID,
			encounter = curEncName,
			instance = instName,
			instanceID = instID,
		}
	end)
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterUnitEvent("UNIT_AURA", "player")
f:SetScript("OnEvent", function(_, event, a1, a2)
	if event == "ENCOUNTER_START" then
		curEncID, curEncName = a1, a2
	elseif event == "ENCOUNTER_END" then
		curEncID, curEncName = nil, nil
	elseif event == "UNIT_AURA" then
		pcall(Capture)
	end
end)

--- /mh dispellog — print the captured dispellable debuffs (verified heal-lens
--- data, ready to fold into ns.BOSS_HEAL_LENS via the encounterID).
function ns.PrintDispelCaptureLog()
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	local store = Store()
	print(("%s Captured dispellable debuffs (share these — spell / school / boss):"):format(prefix))
	local n = 0
	for _, e in pairs(store or {}) do
		n = n + 1
		print(("   %s |cff9d9d9d(%d)|r — |cff8fd3ff%s|r — %s |cff9d9d9d[enc %s | %s]|r"):format(
			e.name or "?", e.spellId or 0, e.school or "?",
			e.encounter or "trash/unknown boss", tostring(e.encounterID or "-"), e.instance or "?"
		))
	end
	if n == 0 then
		print("   (nothing captured yet — run an instance; dispellable debuffs that land on you get logged)")
	else
		print(("   %d entries. |cff9d9d9d/mh dispellog clear|r to reset."):format(n))
	end
end

--- /mh dispellog clear — wipe the capture log.
function ns.ClearDispelCaptureLog()
	if ns.db then
		ns.db.dispelCapture = {}
	end
	local prefix = ("|cffffcc00%s|r"):format(ns:L("PRINT_PREFIX"))
	print(("%s Dispel capture log cleared."):format(prefix))
end
