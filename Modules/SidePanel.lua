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
	f:SetFrameStrata("HIGH")
	f:SetClampedToScreen(true)
	f:Hide()
	if ns.ApplyMidnightDialogBackdrop then
		pcall(ns.ApplyMidnightDialogBackdrop, f)
	end

	f._padX, f._padTop, f._padBottom = 14, 12, 14
	f._lines = {}

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
	function f:AnchorTo(blizzFrame, xOff, yOff)
		if not blizzFrame then
			return
		end
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", blizzFrame, "TOPRIGHT", xOff or 4, yOff or 0)
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

	local function stopWatch()
		if ticker then
			pcall(function() ticker:Cancel() end)
			ticker = nil
		end
		lastToken = nil
	end

	local function refresh()
		local okF, frame = pcall(cfg.getFrame)
		if not okF or not frame or not frame:IsShown() then
			stopWatch()
			cfg.panel:Hide()
			return
		end
		local okL, lines = pcall(cfg.buildLines)
		if not okL or type(lines) ~= "table" or #lines == 0 then
			cfg.panel:Hide() -- no data → no panel, never an empty box
			return
		end
		cfg.panel:SetLines(lines)
		cfg.panel:AnchorTo(frame, cfg.xOff, cfg.yOff)
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
			if not okF or not frame or not frame:IsShown() then
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
		if frame:IsShown() then
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
	return cfg
end
