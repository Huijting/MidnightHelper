local _, ns = ...

--[[
	Midnight Helper — who put this here, us or the player?

	`/mh apply` had no memory. It placed an ability, the player dragged it somewhere they
	liked better, and the next run moved it straight back — silently, and with the same
	confident wording as the first time. That fights the player, and Rob's rule for this
	whole addon is the opposite: MH advises, the player decides.

	So every slot we fill is written down. Before the next plan is built we look at those
	slots again: if the thing we recorded is still there, the slot is still ours; if it is
	not, the player changed it and it stops being ours for good.

	⚠️ DELIBERATELY NOT EVENT-DRIVEN. The obvious implementation listens to
	ACTIONBAR_SLOT_CHANGED, and that event fires during our OWN placements, on login
	before the bars have populated, on talent swaps, and when a spell's override flips.
	Every one of those would mark a slot "the player changed this" when the player did
	nothing, and a false positive here is worse than no feature at all: it makes MH stop
	managing a slot it should manage, quietly. Comparing at plan time answers the only
	question we actually need answered, at the only moment it matters, and cannot be
	confused by timing.
]]

local MANAGED = "managed"
local USER = "user"

--- ⚠️ PER CHARACTER **AND** PER SPEC. `MidnightHelperDB` is account-wide, but action
--- bars are not: every character has their own, and WoW keeps a separate set per
--- specialization on top of that.
---
--- Rob asked on 8 Aug 2026 what happens when he logs on to his Shaman. This: the record
--- would still describe his Mage's bars, every slot would mismatch, and the reconcile
--- would announce that he had changed 24 slots himself. Those slots are then excluded
--- from the layout permanently — and because the table was shared, the exclusion would
--- have followed him back to the Mage. One alt visit would have quietly disabled the
--- feature everywhere.
---
--- The question found it before the bug did.
local function CharKey()
	local name = (UnitName and UnitName("player")) or "?"
	local realm = (GetRealmName and GetRealmName()) or ""
	local spec = 0
	if C_SpecializationInfo and C_SpecializationInfo.GetSpecialization then
		local ok, s = pcall(C_SpecializationInfo.GetSpecialization)
		spec = (ok and tonumber(s)) or 0
	elseif GetSpecialization then
		local ok, s = pcall(GetSpecialization)
		spec = (ok and tonumber(s)) or 0
	end
	return ("%s-%s-%d"):format(name, realm, spec)
end

local function Slots()
	ns.db = ns.db or {}
	--- The old account-wide table is dropped rather than migrated: we cannot know which
	--- character wrote it, and guessing wrong would hand one character's records to
	--- another — the exact fault being fixed. Losing it costs nothing: with no records,
	--- nothing is marked as the player's, which is the safe default.
	if ns.db.managedSlots then
		ns.db.managedSlots = nil
	end
	ns.db.managedSlotsByChar = ns.db.managedSlotsByChar or {}
	local key = CharKey()
	ns.db.managedSlotsByChar[key] = ns.db.managedSlotsByChar[key] or {}
	return ns.db.managedSlotsByChar[key]
end

--- What is in a slot right now, in the same shape we record.
--- @return string|nil kind, number|nil id
local function Contents(slot)
	if not (slot and GetActionInfo) then
		return nil, nil
	end
	local ok, kind, id = pcall(GetActionInfo, slot)
	if not ok then
		return nil, nil
	end
	return kind, id
end

--- Remember that WE put this here. Called right after a successful placement.
function ns.MH_ClaimSlot(slot, kind, id, bindKey)
	if not (slot and kind and id) then
		return
	end
	Slots()[slot] = { kind = kind, id = id, key = bindKey, state = MANAGED }
end

--- Re-check every slot we claimed. A slot whose contents no longer match what we put
--- there belongs to the player from now on.
---
--- One-way on purpose: once a slot is the player's it never returns to being ours by
--- itself, even if they later put our ability back. Reclaiming would mean MH deciding
--- it knows better again, which is the behaviour this module exists to stop. `/mh apply
--- reclaim` is the way back, and it is a thing the player says, not something we infer.
--- @return number changed  how many slots just became the player's
function ns.MH_ReconcileSlots()
	local changed = 0
	for slot, rec in pairs(Slots()) do
		if rec.state == MANAGED then
			local kind, id = Contents(slot)
			if kind ~= rec.kind or id ~= rec.id then
				rec.state = USER
				rec.nowKind = kind
				rec.nowId = id
				changed = changed + 1
			end
		end
	end
	return changed
end

--- How many slots this character-and-spec has on record, in any state.
---
--- Zero means one thing only: the layout has never been applied here. It is the honest
--- answer to "have we ever touched these bars", and the setup nudge asks exactly that.
--- ⚠️ Do NOT read it as "the bars are empty" — a player who arranged their own bars by
--- hand also scores zero, which is why the nudge offers rather than warns.
--- @return number
function ns.MH_ManagedSlotCount()
	local n = 0
	for _ in pairs(Slots()) do
		n = n + 1
	end
	return n
end

--- @return boolean  true when the player has taken this slot over
function ns.MH_SlotIsUserOwned(slot)
	local rec = Slots()[slot]
	return (rec and rec.state == USER) and true or false
end

--- Slots the player has taken over, sorted, for a report.
function ns.MH_UserOwnedSlots()
	local out = {}
	for slot, rec in pairs(Slots()) do
		if rec.state == USER then
			out[#out + 1] = { slot = slot, key = rec.key, wasKind = rec.kind, wasId = rec.id }
		end
	end
	table.sort(out, function(a, b)
		return a.slot < b.slot
	end)
	return out
end

--- `/mh apply reclaim` — hand every slot back to MH. Explicit, because taking a slot
--- back is exactly the decision the player made when they changed it.
function ns.MH_ReclaimSlots()
	local n = 0
	for _, rec in pairs(Slots()) do
		if rec.state == USER then
			rec.state = MANAGED
			rec.nowKind, rec.nowId = nil, nil
			n = n + 1
		end
	end
	return n
end

--- Forget everything. Used by undo: after the bars are back the way they were, a record
--- of what we had placed describes a world that no longer exists.
function ns.MH_ForgetSlots()
	ns.db = ns.db or {}
	ns.db.managedSlots = nil -- legacy account-wide table, see Slots()
	ns.db.managedSlotsByChar = ns.db.managedSlotsByChar or {}
	ns.db.managedSlotsByChar[CharKey()] = {}
end
