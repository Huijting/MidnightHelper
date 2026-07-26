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

	for _, categoryID in ipairs(categories) do
		local okNum, num = pcall(GetCategoryNumAchievements, categoryID)
		if okNum and type(num) == "number" then
			for i = 1, num do
				-- id, name, points, completed, month, day, year, description, ...
				local ok, id, name, _, completed, _, _, _, description =
					pcall(GetAchievementInfo, categoryID, i)
				if ok and id and type(name) == "string" then
					scanned = scanned + 1
					local hay = name:lower()
					local inDesc = false
					if not hay:find(needle, 1, true) and type(description) == "string" then
						inDesc = description:lower():find(needle, 1, true) ~= nil
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

	if hits == 0 then
		print(("   no match in %d achievements. Try a shorter word."):format(scanned))
	elseif capped then
		-- Never a silent cut: a truncated list that looks complete is a lie by omission.
		print(("   showing the first %d matches only -- narrow the search to see the rest."):format(MAX_HITS))
	end
end
