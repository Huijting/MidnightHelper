local _, ns = ...

--[[
	Midnight Helper — shared side-panel helper.

	Generalises a pattern this addon already proved: the Great Vault banner
	(VaultAdvisor) hooks WeeklyRewardsFrame and positions its own frame against it.
	A side panel is our own frame that appears beside a Blizzard window while that
	window is open, so advice arrives where the player already is.

	TAINT RULE (the whole reason this is safe):
	  • the panel is parented to UIParent, never to the Blizzard frame;
	  • we only POSITION against the Blizzard frame (SetPoint);
	  • we never SetParent, never touch Blizzard's own children, and never take part
	    in secure actions (slotting a keystone, summoning a mount, placing an order).

	Usage:
	    local panel = ns.CreateSidePanel({ name = "MidnightHelperFooPanel", titleKey = "FOO_TITLE" })
	    ns.AttachSidePanel({
	        panel      = panel,
	        getFrame   = function() return SomeBlizzardFrame end,
	        getAnchor  = function() return SomeOuterWindow end,
	                     -- optional. Blizzard windows are often a tab INSIDE a bigger
	                     -- frame: the M+ tab lives in PVEFrame, the mount tab lives in
	                     -- CollectionsJournal. Anchoring to the inner frame's TOPRIGHT
	                     -- puts the panel inside the window instead of beside it. So
	                     -- getFrame decides WHEN to show (the tab), getAnchor decides
	                     -- WHERE (the window). Defaults to getFrame when omitted.
	        addon      = "Blizzard_SomeUI",        -- optional, for load-on-demand UIs
	        buildLines = function() return { { text = "...", color = "warn" } } end,
	        events     = { "PLAYER_EQUIPMENT_CHANGED" },  -- optional refresh triggers
	        watch      = function() return SomeBlizzardFrame.selectedThing end,
	                     -- optional: rebuild when this value changes while the panel is
	                     -- open. Polled on a light ticker that only runs while the panel
	                     -- is visible, so it costs nothing the rest of the time.
	    })

	No data → no panel. An empty or unreadable result hides the panel rather than
	showing an empty box or a guessed zero.
]]

local DEFAULT_WIDTH = 300

--- Every attached panel, so a reset can reposition them where they stand instead of
--- waiting for the player to close and reopen the window (Rob, 2026-07-22).
local attached = {}

--- Side panels are pushier than a tab: they appear beside Blizzard's own windows
--- without being asked. Some players will not want that, and "off" has to mean off
--- rather than "less often". Default on; stored in ns.db.ui so it survives a reload.
function ns.AreSidePanelsEnabled()
	if ns.db and ns.db.ui and ns.db.ui.sidePanels == false then
		return false
	end
	return true
end

function ns.SetSidePanelsEnabled(on)
	ns.db = ns.db or {}
	ns.db.ui = ns.db.ui or {}
	ns.db.ui.sidePanels = on and true or false
	-- Apply immediately. Waiting for the window to be reopened would make the switch
	-- feel broken -- the same complaint /mh panelreset already earned.
	for _, cfg in ipairs(attached) do
		if type(cfg.refresh) == "function" then
			pcall(cfg.refresh)
		end
	end
end

local COLORS = {
	good = { 0.35, 1.00, 0.45 },
	warn = { 1.00, 0.82, 0.35 },
	prog = { 0.60, 0.80, 1.00 },
	soft = { 0.85, 0.83, 0.78 },
	dim  = { 0.62, 0.60, 0.56 },
}

--------------------------------------------------------------------------------
-- Panel construction
--------------------------------------------------------------------------------
function ns.CreateSidePanel(opts)
	opts = opts or {}
	local width = opts.width or DEFAULT_WIDTH

	-- Parent is UIParent on purpose. See TAINT RULE above.
	local f = CreateFrame("Frame", opts.name, UIParent, "BackdropTemplate")
	f:SetWidth(width)
	f:SetHeight(60)
	-- FULLSCREEN_DIALOG, matching the vault banner (VaultAdvisor.lua:1210). HIGH is not
	-- enough: Rob's Raider.IO panel drew straight through ours where they overlapped.
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetClampedToScreen(true)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		pcall(ns.ApplyMidnightDialogBackdrop, f)
	end

	f._padX, f._padTop, f._padBottom = 14, 12, 14
	f._lines = {}
	f._panelKey = opts.name or opts.titleKey or "panel"

	-- Draggable. The right-hand side of a Blizzard window is contested space: on the
	-- character sheet it holds Blizzard's own stats column, and Rob also runs Class
	-- Codex there, while the Group Finder has Raider.IO. No default can be right for
	-- everyone, so let the player move it and remember where they put it.
	--
	-- Drag with the panel body itself: it has no title bar of its own, and rows only
	-- take clicks where they have an onClick, so dragging cannot swallow a click.
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	f:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- Convert where it ended up back into an offset from its anchor, so the panel
		-- keeps following the window. Saving raw screen coordinates would strand it
		-- the moment the player moved the Blizzard frame.
		local args = self._anchorArgs
		if not (args and args[1] and ns.db) then
			return
		end
		local blizzFrame, xOff, yOff, point, relPoint = args[1], args[2], args[3], args[4], args[5]
		local okNow, nowX, nowY = pcall(function() return self:GetLeft(), self:GetBottom() end)
		if not okNow or not nowX then
			return
		end
		-- Re-anchor to the reference position, measure, then apply the difference.
		self:ClearAllPoints()
		self:SetPoint(point, blizzFrame, relPoint, xOff, yOff)
		local okRef, refX, refY = pcall(function() return self:GetLeft(), self:GetBottom() end)
		if not okRef or not refX then
			return
		end
		ns.db.sidePanelOffsets = ns.db.sidePanelOffsets or {}
		ns.db.sidePanelOffsets[self._panelKey] = { x = nowX - refX, y = nowY - refY }
		self:AnchorTo(blizzFrame, xOff, yOff, point, relPoint)
	end)

	f._title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	if ns.MHScalableFont then
		pcall(function() f._title:SetFontObject(ns.MHScalableFont("GameFontNormalLarge")) end)
	end
	f._title:SetPoint("TOPLEFT", f, "TOPLEFT", f._padX, -f._padTop)
	f._title:SetWidth(width - f._padX * 2)
	f._title:SetJustifyH("LEFT")
	f._title:SetTextColor(1, 0.9, 0.55)
	f._titleKey = opts.titleKey

	--- Replace the panel's content. lines = { { text=, color=, onClick= }, ... }
	function f:SetLines(lines)
		lines = lines or {}
		local scale = (ns.GetContentFontScale and ns.GetContentFontScale()) or 1
		local innerW = width - self._padX * 2

		if self._titleKey then
			self._title:SetText(ns:SafeL(self._titleKey) or "")
		end

		local y = -(self._padTop + self._title:GetStringHeight() + 8)
		for i = 1, math.max(#lines, #self._lines) do
			local row = self._lines[i]
			if not row and lines[i] then
				row = CreateFrame("Button", nil, self)
				row:SetWidth(innerW)
				row.fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				if ns.MHScalableFont then
					pcall(function() row.fs:SetFontObject(ns.MHScalableFont("GameFontHighlight")) end)
				end
				row.fs:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
				row.fs:SetWidth(innerW)
				row.fs:SetJustifyH("LEFT")
				row.fs:SetWordWrap(true)
				self._lines[i] = row
			end
			if row then
				local def = lines[i]
				if def then
					row.fs:SetText(def.text or "")
					local c = COLORS[def.color or "soft"] or COLORS.soft
					row.fs:SetTextColor(c[1], c[2], c[3])
					row:SetHeight(math.max(row.fs:GetStringHeight(), 12 * scale))
					row:ClearAllPoints()
					row:SetPoint("TOPLEFT", self, "TOPLEFT", self._padX, y)
					row:SetScript("OnClick", def.onClick)
					row:EnableMouse(def.onClick ~= nil)
					-- A clickable row used to look exactly like a dead one. Rob had the
					-- profession panel open on 2026-07-22 and asked where he was
					-- supposed to click -- the action was there, with nothing saying so.
					-- Brighten on hover and show the pointing cursor, so "this does
					-- something" is visible before the click instead of after it.
					if def.onClick then
						local base = c
						row:SetScript("OnEnter", function(self)
							self.fs:SetTextColor(
								base[1] + (1 - base[1]) * 0.5,
								base[2] + (1 - base[2]) * 0.5,
								base[3] + (1 - base[3]) * 0.5
							)
							if SetCursor then
								SetCursor("Interface\\CURSOR\\Point")
							end
						end)
						row:SetScript("OnLeave", function(self)
							self.fs:SetTextColor(base[1], base[2], base[3])
							if ResetCursor then
								ResetCursor()
							end
						end)
					else
						row:SetScript("OnEnter", nil)
						row:SetScript("OnLeave", nil)
					end
					row:Show()
					y = y - row:GetHeight() - 6
				else
					row:Hide()
				end
			end
		end
		self:SetHeight(math.max(-y + self._padBottom, 48))
	end

	--- Position beside a Blizzard frame. We never reparent it.
	--- point/relPoint default to TOPLEFT→TOPRIGHT (level with the window's top).
	--- Pass BOTTOMLEFT→BOTTOMRIGHT to sit at the bottom instead, which is how you
	--- stay out of the top-right corner that score addons like Raider.IO claim.
	function f:AnchorTo(blizzFrame, xOff, yOff, point, relPoint)
		if not blizzFrame then
			return
		end
		-- A nudge the player dragged in, kept per panel. It is stored as an OFFSET on
		-- top of the anchor, not an absolute screen position, so a moved panel still
		-- travels with its Blizzard window instead of being left behind.
		local dx, dy = 0, 0
		local saved = ns.db and ns.db.sidePanelOffsets and ns.db.sidePanelOffsets[self._panelKey or ""]
		if type(saved) == "table" then
			dx, dy = tonumber(saved.x) or 0, tonumber(saved.y) or 0
		end
		self:ClearAllPoints()
		self:SetPoint(point or "TOPLEFT", blizzFrame, relPoint or "TOPRIGHT",
			(xOff or 4) + dx, (yOff or 0) + dy)
		self._anchorArgs = { blizzFrame, xOff or 4, yOff or 0, point or "TOPLEFT", relPoint or "TOPRIGHT" }
		local ok, lvl = pcall(blizzFrame.GetFrameLevel, blizzFrame)
		if ok and lvl then
			self:SetFrameLevel(lvl + 20)
		end
	end

	return f
end

--------------------------------------------------------------------------------
-- Attaching to a Blizzard window
--------------------------------------------------------------------------------
--- Hooks a Blizzard frame so the panel follows its OnShow/OnHide. Safe to call
--- repeatedly; hooks once. Handles load-on-demand UIs via ADDON_LOADED.
function ns.AttachSidePanel(cfg)
	if type(cfg) ~= "table" or not cfg.panel or type(cfg.getFrame) ~= "function" then
		return
	end
	local hooked = false
	local ticker, lastToken

	--- IsVisible(), NOT IsShown(). IsShown() reports only the frame's own flag: when Rob
	--- closed the Group Finder, PVEFrame hid but ChallengesFrame kept its flag set, so the
	--- next refresh event saw "window open", anchored to a hidden frame, and left the panel
	--- floating in the middle of the screen with no way to dismiss it. IsVisible() walks the
	--- parent chain, which is the actual question. The panel is parented to UIParent (that
	--- is what keeps it taint-safe), so nothing else would ever have hidden it for us.
	local function Live(frame)
		if not frame or type(frame.IsVisible) ~= "function" then
			return false
		end
		local ok, vis = pcall(frame.IsVisible, frame)
		return ok and vis and true or false
	end

	local function stopWatch()
		if ticker then
			pcall(function() ticker:Cancel() end)
			ticker = nil
		end
		lastToken = nil
	end

	local function refresh()
		if not ns.AreSidePanelsEnabled() then
			stopWatch()
			cfg.panel:Hide()
			return
		end
		local okF, frame = pcall(cfg.getFrame)
		if not okF or not Live(frame) then
			stopWatch()
			cfg.panel:Hide()
			return
		end
		local okL, lines = pcall(cfg.buildLines)
		if not okL or type(lines) ~= "table" or #lines == 0 then
			cfg.panel:Hide() -- no data → no panel, never an empty box
			return
		end
		local anchor = frame
		if type(cfg.getAnchor) == "function" then
			local okA, outer = pcall(cfg.getAnchor)
			if okA and outer then
				anchor = outer
			end
		end
		cfg.panel:SetLines(lines)
		cfg.panel:AnchorTo(anchor, cfg.xOff, cfg.yOff, cfg.point, cfg.relPoint)
		cfg.panel:Show()
	end
	cfg.refresh = refresh

	-- Selection watching: only ticks while the Blizzard window is open, so it is
	-- idle the rest of the time (no permanent OnUpdate).
	local function startWatch()
		if ticker or type(cfg.watch) ~= "function" then
			return
		end
		if not (C_Timer and C_Timer.NewTicker) then
			return
		end
		local okT, tok = pcall(cfg.watch)
		lastToken = okT and tok or nil
		ticker = C_Timer.NewTicker(cfg.watchInterval or 0.3, function()
			local okF, frame = pcall(cfg.getFrame)
			if not okF or not Live(frame) then
				stopWatch()
				cfg.panel:Hide()
				return
			end
			local ok2, t = pcall(cfg.watch)
			if ok2 and t ~= lastToken then
				lastToken = t
				refresh()
			end
		end)
	end

	local function onShow()
		if C_Timer and C_Timer.After then
			C_Timer.After(0.05, function()
				refresh()
				startWatch()
			end)
		else
			refresh()
			startWatch()
		end
	end

	local function hook()
		if hooked then
			return
		end
		local okF, frame = pcall(cfg.getFrame)
		if not okF or not frame or not frame.HookScript then
			return
		end
		hooked = true
		frame:HookScript("OnShow", onShow)
		frame:HookScript("OnHide", function()
			stopWatch()
			cfg.panel:Hide()
		end)
		if Live(frame) then
			onShow()
		end
	end

	local ev = CreateFrame("Frame")
	ev:RegisterEvent("PLAYER_ENTERING_WORLD")
	if cfg.addon then
		ev:RegisterEvent("ADDON_LOADED")
	end
	if type(cfg.events) == "table" then
		for _, e in ipairs(cfg.events) do
			pcall(ev.RegisterEvent, ev, e)
		end
	end
	ev:SetScript("OnEvent", function(_, event, arg1)
		if event == "ADDON_LOADED" then
			if arg1 == cfg.addon then
				hook()
				if hooked then
					ev:UnregisterEvent("ADDON_LOADED") -- our window exists; stop listening to every addon
				end
			end
			return
		end
		if event == "PLAYER_ENTERING_WORLD" then
			hook()
			return
		end
		-- any registered refresh event
		if C_Timer and C_Timer.After then
			C_Timer.After(0.1, refresh)
		else
			refresh()
		end
	end)

	hook() -- in case the frame already exists at load
	attached[#attached + 1] = cfg
	return cfg
end

--- Clear every saved nudge and reposition the panels immediately.
--- Used by /mh panelreset. Repositioning on the spot matters: a panel dragged off
--- screen is exactly the case you need this for, and telling someone to close and
--- reopen the window first is a poor answer when the panel is right there.
function ns.ResetSidePanels()
	if ns.db then
		ns.db.sidePanelOffsets = nil
	end
	for _, cfg in ipairs(attached) do
		if type(cfg.refresh) == "function" then
			pcall(cfg.refresh)
		end
	end
end
