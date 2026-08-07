local _, ns = ...

--[[
	Midnight Helper — what does that button actually send? (`/mh mouse detect`)

	The keybind scheme started handing out thumb buttons on 6 Aug, and the honest
	comment on that change said we could not tell whether a Razer Naga's pad sends
	mouse buttons or keyboard keys, "so the count is a setting rather than an
	assumption". That was true but lazy: it asks Rob a question the game can answer.

	KeyUI answers it by listening. An invisible frame with EnableKeyboard(true) and
	`SetPropagateKeyboardInput(true)` sees every key and hands it straight on to the
	game, so it observes without stealing. Mouse buttons do not arrive through
	OnKeyDown at all — they need OnMouseDown on a frame the cursor is over — which is
	itself worth knowing, because it means a thumb button that produces NOTHING here
	is sending something the game never sees under any name.

	WHY IT MATTERS AND IS NOT COSMETIC. Our own scheme uses F1-F4 for cooldowns and
	heals. If a pad sends F1-F12, every "thumb button" we hand out lands on top of
	them and the player loses four anchors without being told. Guessing is not
	available here.

	⚠️ It never writes a binding. This only reports what a press produces.
]]

local frame
local captured = {}

local function Prefix()
	return ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
end

--- Record one press and say what it was.
local function Note(kind, key)
	if not key or key == "" then
		return
	end
	-- ESCAPE closes rather than being recorded, or there is no way out.
	if key == "ESCAPE" then
		if ns.StopMouseDetect then
			ns.StopMouseDetect()
		end
		return
	end
	for i = 1, #captured do
		if captured[i].key == key then
			return -- already seen this press
		end
	end
	captured[#captured + 1] = { kind = kind, key = key }

	--- Say straight away whether this collides with something the scheme uses. A
	--- player pressing their thumb button wants to know NOW, not after a reload.
	local warn = ""
	if key:match("^F%d+$") then
		local n = tonumber(key:match("^F(%d+)$"))
		if n and n <= 4 then
			warn = " |cffff6060— careful: the scheme already uses " .. key
				.. " for a cooldown or heal.|r"
		end
	end
	print(("%s that button sends |cffffffff%s|r (%s).%s"):format(Prefix(), key, kind, warn))
end

function ns.StopMouseDetect()
	if not frame then
		return
	end
	frame:EnableKeyboard(false)
	frame:EnableMouse(false)
	frame:EnableMouseWheel(false)
	frame:Hide()

	ns.db = ns.db or {}
	ns.db.mouseDetect = captured
	local names = {}
	for i = 1, #captured do
		names[#names + 1] = captured[i].key
	end
	if #names == 0 then
		print(Prefix() .. " detection stopped — nothing was captured.")
		print("   |cff9d9d9dIf you pressed a thumb button and nothing appeared, the game never|r")
		print("   |cff9d9d9dsaw it: your mouse driver is sending something WoW cannot bind.|r")
	else
		print(("%s detection stopped — %d button(s): |cffffffff%s|r"):format(
			Prefix(), #names, table.concat(names, ", ")))
	end
end

--- `/mh mouse detect` — press your thumb buttons; we write down what they send.
function ns.StartMouseDetect()
	if InCombatLockdown and InCombatLockdown() then
		print(Prefix() .. " not in combat.")
		return
	end
	captured = {}

	if not frame then
		frame = CreateFrame("Frame", "MidnightHelperMouseDetect", UIParent, "BackdropTemplate")
		frame:SetSize(340, 96)
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
		frame:SetFrameStrata("FULLSCREEN_DIALOG")
		if frame.SetBackdrop then
			frame:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8",
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
			})
			frame:SetBackdropColor(0, 0, 0, 0.85)
			frame:SetBackdropBorderColor(0.42, 0.29, 0.11, 1)
		end

		local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		title:SetPoint("TOP", frame, "TOP", 0, -10)
		title:SetText((ns.L and ns:L("MOUSEDETECT_TITLE")) or "Press a thumb button")

		local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		hint:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -38)
		hint:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -38)
		hint:SetJustifyH("LEFT")
		hint:SetWordWrap(true)
		hint:SetText((ns.L and ns:L("MOUSEDETECT_HINT"))
			or "Hover this box and press each button in turn. Escape closes it. Nothing is bound - this only reports what each button sends.")

		--- Keyboard: propagate, so a press still reaches the game. Observing must never
		--- cost the player an action, and a capture that swallowed input would be a trap
		--- if anything went wrong while it was open.
		frame:SetScript("OnKeyDown", function(_, key)
			Note("keyboard", key)
		end)
		--- Mouse buttons never arrive via OnKeyDown; they need the cursor over a
		--- mouse-enabled frame. Hence "hover this box".
		frame:SetScript("OnMouseDown", function(_, button)
			Note("mouse", string.upper(tostring(button)))
		end)
		frame:SetScript("OnMouseWheel", function(_, delta)
			Note("wheel", delta > 0 and "MOUSEWHEELUP" or "MOUSEWHEELDOWN")
		end)
	end

	frame:EnableKeyboard(true)
	frame:SetPropagateKeyboardInput(true)
	frame:EnableMouse(true)
	frame:EnableMouseWheel(true)
	frame:Show()

	print(Prefix() .. " detection ON — hover the box and press each thumb button.")
	print("   |cff9d9d9dEscape closes it. Nothing gets bound; this only reports.|r")
end
