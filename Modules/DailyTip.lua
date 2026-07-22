local _, ns = ...

--[[
	Midnight Helper — one Codex nugget per day.

	MH has an eighteen-chapter profession Academy and a large Codex that most players
	never open. This surfaces exactly one entry a day on "This Week", dismissible, so
	the material reaches people who were never going to go looking for it.

	The pick is DETERMINISTIC per day: the same entry all day, a different one
	tomorrow. It must not reroll on /reload -- that would feel broken, and it would
	let someone reroll until they got a short one.

	THE DAY IS THE PLAYER'S LOCAL DAY. Dividing time() by 86400 gives a UTC day, so
	the tip would turn over at 01:00 or 02:00 for a European player, mid-evening
	elsewhere. date("%Y%m%d") is local, which is what "today" has to mean to the
	person reading it -- and it makes the dismissal ("not today") end when their day
	does, not when UTC says so.

	Never-lie: the tip is a real Codex entry, shown under its own title, never a
	paraphrase written here. Clicking opens the Codex on that entry's own category,
	so the full text is one step away rather than somewhere in a list.
]]

--- Today, as a comparable number in the player's own timezone (e.g. 20260722).
local function DayIndex()
	if not date then
		return 0
	end
	return tonumber(date("%Y%m%d")) or 0
end

local function Store()
	if not ns.db then
		return nil
	end
	ns.db.dailyTip = ns.db.dailyTip or {}
	return ns.db.dailyTip
end

--- The Codex article for today, or nil when there are none.
function ns.GetDailyTipArticle()
	local arts = ns.CODEX_ARTICLES
	if type(arts) ~= "table" or #arts == 0 then
		return nil
	end
	local idx = (DayIndex() % #arts) + 1
	return arts[idx]
end

--- Has the player dismissed today's tip?
function ns.IsDailyTipDismissed()
	local s = Store()
	return (s and s.dismissedDay == DayIndex()) and true or false
end

function ns.DismissDailyTip()
	local s = Store()
	if s then
		s.dismissedDay = DayIndex()
	end
	if ns.RefreshHomePanel then
		pcall(ns.RefreshHomePanel)
	end
end

--- Steps provider, same shape as the others. Empty when dismissed or unavailable.
function ns.GetDailyTipSteps()
	local out = {}
	if ns.db and ns.db.dailyTip and ns.db.dailyTip.enabled == false then
		return out
	end
	if ns.IsDailyTipDismissed() then
		return out
	end
	local art = ns.GetDailyTipArticle()
	if not art or not art.titleKey then
		return out
	end

	local category = art.category
	out[#out + 1] = {
		text = ns:L("DAILYTIP_PREFIX") .. " " .. ns:L(art.titleKey),
		color = "prog",
		onClick = function()
			-- Same route NavSearch uses for a Codex hit: put the Codex on this
			-- article's category first, then show the tab. Selecting the tab alone
			-- would drop the reader on whatever category was open last.
			if category and ns.SetActiveCodexCategory then
				pcall(ns.SetActiveCodexCategory, category)
			end
			if ns.SelectTab then
				pcall(ns.SelectTab, "codex")
			end
		end,
	}
	out[#out + 1] = {
		text = ns:L("DAILYTIP_DISMISS"),
		color = "dim",
		onClick = function()
			ns.DismissDailyTip()
		end,
	}
	return out
end
