local _, ns = ...

--[[
	Midnight Helper — achievement finder (/mh ach <text>).

	Why this exists: a news post gives us achievement NAMES; MidnightHelper can only
	track achievement IDs. Guessing the id from a name is exactly the kind of
	invention this addon does not do, so this command lets us look the id up in the
	client that will actually be asked about it.

	It walks the real achievement tree -- GetCategoryList() then
	GetAchievementInfo(categoryID, index) per category -- rather than sweeping a
	numeric range. That enumerates only achievements that exist, in one pass, and
	cannot miss one that sits outside a guessed range. (Midnight's own ids are not
	contiguous: Keystone Master is 61256 while the "of the Dawn" set is 42767-42770,
	so any range guess would have been wrong.) API shape cross-checked against
	KalielsTracker/System/Achievements.lua, which uses the same three calls.

	⚠️ THIS IS A LOOKUP TOOL, NOT A LOOKUP FEATURE. Nothing in the shipped addon may
	resolve an achievement by name: names are localised, and matching English text
	would fail on every non-English client -- the same trap that broke the Omnium
	Folio button in seven languages. Names go in here, ids go in the data files.
]]

local PREFIX = "|cffffcc00Midnight Helper|r"

-- Enough to see what you searched for without flooding chat when someone types "a".
local MAX_HITS = 40

--- /mh ach check — hold every shipped hunt against the client in one pass.
---
--- Why this is a command and not a note to run `/mh ach id` four times: a hunt whose
--- criteria ids are wrong does not error. It draws a card that reads 0/11 forever,
--- and a player just concludes they have found nothing yet. That is the quietest
--- kind of wrong this addon can be, and it has shipped twice already -- the Treasures
--- of the Coiled Isle entry has carried a "still to verify" note since it was added.
---
--- Two different faults, reported separately because they need different fixes:
---   * a criterion id the achievement does not own -> the id is wrong
---   * fewer nodes than the achievement has criteria -> the data is incomplete
--- Neither is visible from inside the game without this.
function ns.PrintAchievementDataCheck()
	if not (GetAchievementInfo and GetAchievementNumCriteria and GetAchievementCriteriaInfoByID) then
		print(PREFIX .. " achievement API not available on this client.")
		return
	end
	local hunts = ns.ACHIEVEMENT_TREASURES
	if type(hunts) ~= "table" then
		print(PREFIX .. " no hunt data loaded.")
		return
	end

	print(PREFIX .. " checking every shipped hunt against your client:")
	local badTotal, thinTotal = 0, 0
	for _, entry in ipairs(hunts) do
		local aid = tonumber(entry.achievementID)
		local nodes = entry.nodes
		if aid and type(nodes) == "table" then
			local okA, _, name = pcall(GetAchievementInfo, aid)
			local okN, total = pcall(GetAchievementNumCriteria, aid)
			total = (okN and tonumber(total)) or 0

			local withCrit, resolved, bad = 0, 0, {}
			for _, node in ipairs(nodes) do
				if node.criteria then
					withCrit = withCrit + 1
					local okC, s = pcall(GetAchievementCriteriaInfoByID, aid, node.criteria)
					if okC and type(s) == "string" and s ~= "" then
						resolved = resolved + 1
					else
						bad[#bad + 1] = node.criteria
					end
				end
			end

			local label = (okA and type(name) == "string" and name ~= "") and name
				or ("|cffff5040unknown to this client|r")
			print(("   %d  %s"):format(aid, label))
			if withCrit == 0 then
				-- Peaks hunts detect via quest flags; nothing to check here, and saying
				-- "0 of 0 correct" would read like a pass it never took.
				print(("      |cff8a8f98no criteria in our data (quest-based) — nothing to check|r"))
			elseif #bad == 0 then
				print(("      |cff40c040%d/%d criteria resolve|r"):format(resolved, withCrit))
			else
				badTotal = badTotal + #bad
				print(("      |cffff5040%d of %d criteria do NOT belong to this achievement:|r %s")
					:format(#bad, withCrit, table.concat(bad, ", ")))
			end
			if total > 0 and #nodes < total then
				thinTotal = thinTotal + 1
				print(("      |cffffd100we ship %d nodes, the achievement has %d criteria — incomplete|r")
					:format(#nodes, total))
			end
		end
	end

	if badTotal == 0 and thinTotal == 0 then
		print("   |cff40c040Every criterion resolves and no hunt is short.|r")
	else
		print(("   |cffff5040%d wrong criteria|r, |cffffd100%d incomplete hunts|r."):format(badTotal, thinTotal))
	end
end

--- /mh ach id <n> — everything the client knows about one achievement.
---
--- The finder gets us a candidate; this proves what it actually asks for. Needed
--- because a news article's wording is not the game's: the 2026-07-25 Season 1 post
--- called an achievement "Let Me Solo Him" while the client calls it "Let Me Solo
--- It" (61420), and three other names from that post do not exist here at all. A
--- name that merely looks right is not evidence -- the criteria are.
---
--- Returns nothing; prints name, description, reward, completion and every criterion.
--- @param id number
function ns.PrintAchievementDetail(id)
	id = tonumber(id)
	if not id then
		print(PREFIX .. " usage: /mh ach id 61420")
		return
	end
	if not GetAchievementInfo then
		print(PREFIX .. " achievement API not available on this client.")
		return
	end
	-- id, name, points, completed, month, day, year, description, flags, icon, rewardText
	local ok, aid, name, points, completed, month, day, year, description, _, _, rewardText =
		pcall(GetAchievementInfo, id)
	if not ok or not aid or type(name) ~= "string" then
		print(("%s no achievement with id %d on this client."):format(PREFIX, id))
		return
	end

	print(("%s achievement %d"):format(PREFIX, id))
	print(("   name        = %s"):format(name))
	if type(description) == "string" and description ~= "" then
		print(("   description = %s"):format(description))
	end
	if type(rewardText) == "string" and rewardText ~= "" then
		-- This is where a title or an item is named, which is exactly what we are
		-- trying to confirm against the announcement.
		print(("   reward      = %s"):format(rewardText))
	end
	print(("   points      = %s"):format(tostring(points)))
	if completed and year then
		print(("   completed   = yes, on %s-%s-%s"):format(tostring(day), tostring(month), tostring(year)))
	else
		print(("   completed   = %s"):format(completed and "yes" or "no"))
	end

	if not GetAchievementNumCriteria then
		return
	end
	local okN, num = pcall(GetAchievementNumCriteria, id)
	if not okN or type(num) ~= "number" or num == 0 then
		print("   criteria    = none listed")
		return
	end
	print(("   criteria    = %d"):format(num))
	for i = 1, num do
		-- criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, ...
		local okC, criteriaString, _, cDone, qty, total = pcall(GetAchievementCriteriaInfo, id, i)
		if okC and criteriaString ~= nil then
			local label = (type(criteriaString) == "string" and criteriaString ~= "")
				and criteriaString or ("(criterion %d)"):format(i)
			local prog = ""
			if type(total) == "number" and total > 1 then
				prog = ("  %s/%s"):format(tostring(qty), tostring(total))
			end
			print(("     %s %s%s"):format(cDone and "|cff40c040x|r" or "|cffb0b0b0-|r", label, prog))
		end
	end
end

--- /mh ach <text> — find achievements whose name or description contains <text>.
--- @param query string case-insensitive substring
function ns.PrintAchievementFind(query)
	if type(query) ~= "string" then
		query = ""
	end
	query = query:gsub("^%s+", ""):gsub("%s+$", "")
	if query == "" then
		print(PREFIX .. " usage: /mh ach <part of the name>   e.g. /mh ach nemesis")
		return
	end
	if not (GetCategoryList and GetCategoryNumAchievements and GetAchievementInfo) then
		print(PREFIX .. " achievement API not available on this client.")
		return
	end

	local needle = query:lower()
	local okCats, categories = pcall(GetCategoryList)
	if not okCats or type(categories) ~= "table" then
		print(PREFIX .. " GetCategoryList returned nothing usable.")
		return
	end

	print(("%s achievements matching \"%s\":"):format(PREFIX, query))
	local hits, scanned = 0, 0
	local capped = false
	-- Ids the category walk already covered, so the id sweep below never repeats one.
	local seen = {}

	for _, categoryID in ipairs(categories) do
		local okNum, num = pcall(GetCategoryNumAchievements, categoryID)
		if okNum and type(num) == "number" then
			for i = 1, num do
				-- id, name, points, completed, month, day, year, description, ...
				local ok, id, name, _, completed, _, _, _, description, _, _, rewardText =
					pcall(GetAchievementInfo, categoryID, i)
				if ok and id and type(name) == "string" then
					scanned = scanned + 1
					seen[id] = true
					local hay = name:lower()
					local inDesc = false
					if not hay:find(needle, 1, true) then
						-- Also the reward text: a title is named THERE, not in the name or
						-- the description. Searching only name+description is why
						-- `/mh ach ominous` found nothing on 2026-07-26 even though the
						-- announcement said an achievement grants the title "the Ominous".
						local extra = (type(description) == "string" and description or "")
							.. " " .. (type(rewardText) == "string" and rewardText or "")
						inDesc = extra:lower():find(needle, 1, true) ~= nil
					end
					if hay:find(needle, 1, true) or inDesc then
						if hits >= MAX_HITS then
							capped = true
						else
							hits = hits + 1
							local mark = completed and "|cff40c040done|r" or "|cffb0b0b0todo|r"
							print(("   id %-7s %-44s %s%s"):format(
								tostring(id), name, mark, inDesc and "  (matched description)" or ""))
						end
					end
				end
			end
		end
	end

	-- ---- Fallback: achievements the category tree does not list ----
	-- GetCategoryList() only walks what the Achievements pane shows. An achievement
	-- that is hidden, not yet activated, or datamined-but-unreleased is absent from
	-- it while GetAchievementInfo(<id>) still resolves it. That gap matters: on
	-- 2026-07-26 all four names from Blizzard's Season 1 post were missing from a
	-- 5163-achievement walk, and "not in the visible tree" is a different answer from
	-- "does not exist" -- worth telling apart before concluding anything.
	--
	-- The range covers Midnight's own ids with room to spare (Keystone Master 61256,
	-- Prey 61386-62403, and the "of the Dawn" set down at 42767-42770). It is a few
	-- thousand C calls, so it costs a blink, not a freeze.
	if hits == 0 then
		local SWEEP_FROM, SWEEP_TO = 40000, 70000
		print(("   not in the visible tree (%d achievements). Sweeping ids %d-%d..."):format(
			scanned, SWEEP_FROM, SWEEP_TO))
		local swept = 0
		for id = SWEEP_FROM, SWEEP_TO do
			if not seen[id] then
				local ok, aid, name, _, completed, _, _, _, description, _, _, rewardText =
					pcall(GetAchievementInfo, id)
				if ok and aid and type(name) == "string" and name ~= "" then
					swept = swept + 1
					local blob = (name .. " " .. (type(description) == "string" and description or "")
						.. " " .. (type(rewardText) == "string" and rewardText or "")):lower()
					if blob:find(needle, 1, true) and hits < MAX_HITS then
						hits = hits + 1
						print(("   |cffe8c36ahidden|r id %-7s %-40s %s"):format(
							tostring(aid), name, completed and "|cff40c040done|r" or "|cffb0b0b0todo|r"))
					end
				end
			end
		end
		if hits == 0 then
			print(("   still nothing, across %d further ids outside the tree."):format(swept))
			print("   That is evidence it is not on this client at all -- not that we missed it.")
		end
		return
	end

	if capped then
		-- Never a silent cut: a truncated list that looks complete is a lie by omission.
		print(("   showing the first %d matches only -- narrow the search to see the rest."):format(MAX_HITS))
	end
end

--------------------------------------------------------------------------------
-- /mh prey — where you stand in the Prey hunts.
--
-- Block 9's probe. Every id below was found by sweeping this client on
-- 2026-07-27 (`/mh ach prey`), and 62351 had its criteria and reward read with
-- `/mh ach id`. The NAMES are deliberately not stored: each is resolved live, so
-- a wrong id shows a wrong name in the output instead of quietly reporting the
-- wrong thing. That is the same rule the season checklist follows.
--
-- Counts are read from the achievement's own criteria rather than written down.
-- "30 targets" is something the client can tell us every time it is asked; a
-- hardcoded 30 would be a number that silently rots when Blizzard adds one.
--------------------------------------------------------------------------------

-- The meta and the two that carry real counts. Everything else is reachable
-- through the meta's criteria, so listing more would be duplication.
local PREY_META = 62351        -- "Preying For Midnight" -> Title: Preyseeker
local PREY_ALL_TARGETS = 62383 -- "Gotta Hunt Them All"

-- Mode progression. Two steps per difficulty; the sweep found no third.
local PREY_MODES = {
	{ id = 61387, label = "Normal I" },
	{ id = 61386, label = "Normal II" },
	{ id = 61389, label = "Hard I" },
	{ id = 61388, label = "Hard II" },
	{ id = 61392, label = "Nightmare I" },
	{ id = 61391, label = "Nightmare II" },
}

--- name, completed, rewardText for an achievement, or nil.
local function AchInfo(id)
	if not GetAchievementInfo then
		return nil
	end
	local ok, _, name, _, completed, _, _, _, _, _, _, rewardText = pcall(GetAchievementInfo, id)
	if not ok or type(name) ~= "string" then
		return nil
	end
	return name, completed and true or false, rewardText
end

--- How many criteria are done, out of how many. nil when unreadable.
local function CriteriaProgress(id)
	if not (GetAchievementNumCriteria and GetAchievementCriteriaInfo) then
		return nil
	end
	local okN, num = pcall(GetAchievementNumCriteria, id)
	if not okN or type(num) ~= "number" or num == 0 then
		return nil
	end
	local done = 0
	for i = 1, num do
		local okC, _, _, cDone = pcall(GetAchievementCriteriaInfo, id, i)
		if okC and cDone then
			done = done + 1
		end
	end
	return done, num
end

--- /mh prey — progress across the Prey hunts, read live.
function ns.PrintPreyProgress()
	if not GetAchievementInfo then
		print(PREFIX .. " achievement API not available on this client.")
		return
	end
	print(PREFIX .. " " .. ns:L("PREY_PROBE_HEADER"))

	-- The meta, and each of its parts.
	local metaName, metaDone, metaReward = AchInfo(PREY_META)
	if metaName then
		print(("   |cffffffff%s|r  %s%s"):format(
			metaName, metaDone and "|cff40c040done|r" or "|cffb0b0b0todo|r",
			(type(metaReward) == "string" and metaReward ~= "") and ("  ->  " .. metaReward) or ""))
		local okN, num = pcall(GetAchievementNumCriteria, PREY_META)
		if okN and type(num) == "number" then
			for i = 1, num do
				local okC, label, _, cDone = pcall(GetAchievementCriteriaInfo, PREY_META, i)
				if okC and label ~= nil then
					local text = (type(label) == "string" and label ~= "") and label
						or ("(criterion %d)"):format(i)
					print(("     %s %s"):format(cDone and "|cff40c040x|r" or "|cffb0b0b0-|r", text))
				end
			end
		end
	else
		print(("   achievement %d did not resolve on this client."):format(PREY_META))
	end

	-- The target list, counted by the game.
	local allName = AchInfo(PREY_ALL_TARGETS)
	local done, total = CriteriaProgress(PREY_ALL_TARGETS)
	if allName and total then
		print(("   |cffffffff%s|r  %d/%d targets"):format(allName, done, total))
	elseif allName then
		print(("   |cffffffff%s|r  (criteria unreadable)"):format(allName))
	end

	-- Difficulty progression.
	local line = {}
	for _, m in ipairs(PREY_MODES) do
		local name, ok = AchInfo(m.id)
		if name then
			line[#line + 1] = ("%s%s|r"):format(ok and "|cff40c040" or "|cffb0b0b0", m.label)
		end
	end
	if #line > 0 then
		print("   modes: " .. table.concat(line, "  "))
	end
	print("   " .. ns:L("PREY_PROBE_FOOT"))
end
