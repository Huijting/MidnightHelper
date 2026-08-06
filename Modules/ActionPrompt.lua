local _, ns = ...

--[[
	Midnight Helper — action prompt (`/mh prompt`).

	Two answers to "what do I press right now", in ONE place on screen:

	  • your interrupt, when your target is casting something you may interrupt
	  • your dispel, when your target carries something removable

	Rob asked for this on 3 Aug after seeing SpellPilot do it, and asked for it in
	one spot rather than a third floating icon — MH already draws CombatSafety's
	warning and MissingBuff's bar, and a fourth blinking thing is not a feature.

	WHY THIS IS SAFE TO BUILD NOW. Every piece was measured this week rather than
	assumed:

	  • `notInterruptible` from UnitCastingInfo is SECRET, and is never read here.
	    It goes straight to frame:SetAlphaFromBoolean, which lets the engine decide
	    the alpha — the same route CombatSafety.lua already uses and the same one
	    SpellPilot arrived at independently (ReminderFrame.lua:168).
	  • `castBarID` from the same call is NOT secret, so "is a cast happening at
	    all" can be branched on. That is what hides the icon between casts.
	  • `GetAuraSlots("target", "HELPFUL|DISPELLABLE", 1)` was measured on 3 Aug:
	    27 hits in 200 calls, zero errors, in a delve, in combat, while names and
	    spellIds were coming back secret.

	NOT SECURE, NOT CLICKABLE. These are display frames. Making them castable would
	mean a SecureActionButtonTemplate, and scripts on one of those taint it — which
	is exactly what broke the party-target panel's click-to-target on 3 Aug. The
	prompt tells you what to press; your own keybind presses it.

	⚠️ UNSETTLED, and the wording depends on it: whether `DISPELLABLE` means
	"removable by YOU" or "removable at all". SpellPilot uses the HELPFUL variant to
	catch enrages, which hints at the second. So the dispel icon only appears for a
	character that owns a dispel, and it never claims this particular aura is yours
	to take.
]]

local ICON = 34
local GAP = 6

local frame, iconInterrupt, iconDispel

local function Enabled()
	return (ns.db and ns.db.actionPrompt) and true or false
end

local function SavePos()
	if not frame then
		return
	end
	local p, _, rp, x, y = frame:GetPoint()
	if ns.db and ns.db.ui then
		ns.db.ui.actionPromptPos = { p, rp, x, y }
	end
end

--- One icon: a texture on a plain frame, so alpha can be driven per icon.
--- A BUTTON, not a Frame.
---
--- The first build used CreateFrame("Frame") and neither icon ever appeared.
--- `SetAlphaFromBoolean` is only proven on Buttons here: CombatSafety.lua creates
--- its warning icon and its bars that way (lines 114 and 314) and those work. On a
--- plain Frame the method was missing, so the guarded else-branch set alpha 0 —
--- the feature failed silently and looked like a detection problem.
---
--- Mouse is switched off: a Button takes clicks by default, and this one sits over
--- the middle of the screen with nothing to click.
local function MakeIcon(parent, index)
	local f = CreateFrame("Button", nil, parent)
	f:EnableMouse(false)
	f:SetSize(ICON, ICON)
	f:SetPoint("LEFT", parent, "LEFT", (index - 1) * (ICON + GAP), 0)
	f.tex = f:CreateTexture(nil, "ARTWORK")
	f.tex:SetAllPoints(f)
	f.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	f.border = f:CreateTexture(nil, "OVERLAY")
	f.border:SetPoint("TOPLEFT", f, "TOPLEFT", -2, 2)
	f.border:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 2, -2)
	f.border:SetColorTexture(1, 0.82, 0.2, 0.55)
	f.border:SetDrawLayer("BACKGROUND")

	-- A word, not just an icon. Rob, 5 Aug: an icon lighting up is easy to miss,
	-- and Carola is learning which button to press — "INTERRUPT" tells her what to
	-- do, the icon tells her which key.
	--
	-- ⚠️ THE TEXT IS A CHILD OF THIS BUTTON ON PURPOSE. It inherits the button's
	-- alpha, and that alpha is set by the engine from a secret through
	-- SetAlphaFromBoolean. So the word appears exactly when the cast is
	-- interruptible, and our Lua never asks whether it is.
	--
	-- This is also why there is no SOUND. Playing one means deciding to play it,
	-- and deciding requires reading the secret. Drawing can be delegated to the
	-- engine; a decision cannot. If a sound is ever wanted it needs a different,
	-- readable trigger — not this one.
	f.word = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	if ns.MHScalableFont then
		f.word:SetFontObject(ns.MHScalableFont("GameFontNormalLarge"))
	end
	f.word:SetPoint("TOP", f, "BOTTOM", 0, -2)
	f.word:SetTextColor(1, 0.35, 0.25)
	f.word:SetText("")

	f:SetAlpha(0)
	return f
end

local function EnsureFrame()
	if frame then
		return frame
	end
	frame = CreateFrame("Frame", "MidnightHelperActionPrompt", UIParent)
	frame:SetSize(ICON * 2 + GAP, ICON)
	frame:SetFrameStrata("MEDIUM")
	frame:SetClampedToScreen(true)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		SavePos()
	end)

	local pos = ns.db and ns.db.ui and ns.db.ui.actionPromptPos
	if type(pos) == "table" and pos[1] then
		frame:SetPoint(pos[1], UIParent, pos[2] or pos[1], pos[3] or 0, pos[4] or 0)
	else
		frame:SetPoint("CENTER", UIParent, "CENTER", 0, -140)
	end

	iconInterrupt = MakeIcon(frame, 1)
	iconDispel = MakeIcon(frame, 2)

	-- A faint outline while you are OUT of combat.
	--
	-- Without it the feature is unusable on first switch-on: both icons sit at
	-- alpha 0 until something applies, so what you get is an invisible draggable
	-- rectangle somewhere near the middle of the screen. You cannot put it where
	-- you want it if you cannot find it.
	--
	-- Out of combat only, so it never adds clutter at the moment it is meant to be
	-- read. In a fight the icons speak for themselves.
	frame.idle = frame:CreateTexture(nil, "BACKGROUND")
	frame.idle:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 3)
	frame.idle:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)
	frame.idle:SetColorTexture(1, 0.82, 0.2, 0.10)
	frame.idle:Hide()

	frame:Hide()
	return frame
end

--------------------------------------------------------------------------------
-- What this character can do
--------------------------------------------------------------------------------

local interruptName, interruptTex

--- Resolve on spec change rather than per frame. The name comes from
--- ns.MH_GetInterruptSpell, the same source InterruptScore uses — which exists
--- because the miss hint once told a Paladin to press Kick, a spell he does not
--- have.
local function RefreshInterrupt()
	interruptName, interruptTex = nil, nil
	if not (UnitClass and GetSpecialization and ns.MH_GetInterruptSpell) then
		return
	end
	local token = select(2, UnitClass("player"))
	local idx = GetSpecialization()
	if not (token and idx) then
		return
	end
	local name = ns.MH_GetInterruptSpell(token, idx)
	if type(name) ~= "string" or name == "" then
		return
	end
	interruptName = name
	if C_Spell and C_Spell.GetSpellTexture then
		local ok, tex = pcall(C_Spell.GetSpellTexture, name)
		interruptTex = ok and tex or nil
	end
end

--- Is the spell ready? `isEnabled` and `isActive` are readable — SpellPilot's
--- Interrupts.lua:69 says Midnight exposes them as non-secret precisely so addons
--- can make cooldown decisions without touching protected timing. Treated as
--- optional here: if the call fails we show the prompt anyway, because a prompt
--- shown a second early is a smaller fault than one never shown.
local function SpellReady(nameOrId)
	if not (nameOrId and C_Spell and C_Spell.GetSpellCooldown) then
		return true
	end
	local ok, cd = pcall(C_Spell.GetSpellCooldown, nameOrId)
	if not ok or type(cd) ~= "table" then
		return true
	end
	return cd.isEnabled ~= false and cd.isActive ~= true
end

--------------------------------------------------------------------------------
-- Update
--------------------------------------------------------------------------------

--- Show the interrupt icon.
---
--- Two gates, and the split between them is the whole trick. What we may READ —
--- is anything being cast (castBarID), do we own an interrupt, is it off cooldown
--- — decides whether the icon exists at all. What we may NOT read — whether the
--- cast is interruptible — is handed to the engine, which sets the alpha itself.
local function UpdateInterrupt()
	local f = iconInterrupt
	if not interruptTex or not SpellReady(interruptName) then
		f:SetAlpha(0)
		return
	end

	local notInterruptible, castBarID
	if UnitCastingInfo then
		local ok, _, _, _, _, _, _, _, ni, _, id = pcall(UnitCastingInfo, "target")
		if ok then
			notInterruptible, castBarID = ni, id
		end
	end
	if castBarID == nil and UnitChannelInfo then
		local ok, _, _, _, _, _, _, ni, _, _, _, _, id = pcall(UnitChannelInfo, "target")
		if ok then
			notInterruptible, castBarID = ni, id
		end
	end
	if castBarID == nil then
		f:SetAlpha(0) -- nothing is being cast; readable, so branching is fine
		return
	end

	f.tex:SetTexture(interruptTex)
	if f.word then
		f.word:SetText((ns.L and ns:L("PROMPT_WORD_INTERRUPT")) or "INTERRUPT")
	end
	if f.SetAlphaFromBoolean then
		-- Argument order taken from CombatSafety.lua:462, which is working code:
		-- (value, alphaWhenTrue, alphaWhenFalse). We want the opposite of
		-- notInterruptible, so the alphas are swapped rather than the value
		-- negated — negating would mean reading it.
		f:SetAlphaFromBoolean(notInterruptible, 0, 1)
	else
		f:SetAlpha(0)
	end
end

--- Sound when a purge BECOMES available — once, not while it stays available.
---
--- ⚠️ THIS EXISTS FOR PURGE AND NOT FOR INTERRUPT, and the difference is not a
--- decision, it is the API. Deciding to play a sound means READING a boolean, and
--- `notInterruptible` from UnitCastingInfo is a secret value in 12.x: reading it
--- throws. The interrupt icon works only because SetAlphaFromBoolean lets the ENGINE
--- read it and set the alpha, with the addon never seeing the answer. There is no
--- PlaySoundFromBoolean.
---
--- The purge side is genuinely readable — GetAuraSlots answers with a slot or nothing
--- — so a sound here is honest, and only here.
---
--- Edge-triggered: a target that keeps its buff would otherwise fire on every update,
--- which is several times a second.
local purgeWasUp = false
local function AnnouncePurge(isUp)
	if not isUp then
		purgeWasUp = false
		return
	end
	if purgeWasUp then
		return
	end
	purgeWasUp = true
	local mode = ns.db and ns.db.actionPromptSound
	if not mode then
		return
	end

	-- Speaking the word beats a chime: a chime means "something", the word means what.
	-- Same call CombatSafety already uses for incoming casts, including its note that
	-- SpeakText may voice a secret string even though we may not read one.
	if mode == "speak" and C_VoiceChat and C_VoiceChat.SpeakText then
		local word = (ns.L and ns:L("PROMPT_WORD_PURGE")) or "Purge"
		local voiceId = 0
		if C_TTSSettings and C_TTSSettings.GetVoiceOptionID and Enum and Enum.TtsVoiceType then
			voiceId = C_TTSSettings.GetVoiceOptionID(Enum.TtsVoiceType.Standard) or 0
		end
		local vol = (C_TTSSettings and C_TTSSettings.GetSpeechVolume and C_TTSSettings.GetSpeechVolume()) or 100
		local okSpeak = pcall(C_VoiceChat.SpeakText, voiceId, word, 2, vol, true)
		if okSpeak then
			return
		end
		-- Voice unavailable (it can be switched off in the game's own settings) —
		-- fall through to the chime rather than alerting with nothing at all.
	end

	if PlaySound and SOUNDKIT then
		local kit = SOUNDKIT.RAID_WARNING or SOUNDKIT.READY_CHECK
		if kit then
			pcall(PlaySound, kit, "Master")
		end
	end
end

--- Show the dispel icon when the target carries something removable.
---
--- Entirely readable, so no engine trick is needed: GetAuraSlots answers with a
--- slot or nothing. What it will not tell us is WHAT the aura is, and we do not
--- ask — the icon says "there is something here", your keybind does the rest.
local function UpdateDispel()
	local f = iconDispel
	-- The OFFENSIVE purge, not the friendly dispel. Taking a buff off the enemy you
	-- are looking at is a different spell from curing a party member, and the first
	-- build reached for the wrong one — which is why a Shadow Priest saw nothing.
	local tex, spellID = nil, nil
	if ns.GetPlayerPurgeIcon then
		tex, spellID = ns.GetPlayerPurgeIcon()
	end
	if not tex or not SpellReady(spellID) then
		f:SetAlpha(0)
		return
	end
	if not (C_UnitAuras and C_UnitAuras.GetAuraSlots) then
		f:SetAlpha(0)
		return
	end
	local exists = select(2, pcall(UnitExists, "target"))
	if exists ~= true then
		f:SetAlpha(0)
		return
	end

	-- ⚠️ ONLY ON AN ENEMY. Purge and Spellsteal are offensive: cast on a friend the
	-- game answers "Invalid target". Rob clicked a party member in the Party Targets
	-- panel and got a PURGE prompt that could not do anything — a party member has
	-- HELPFUL|DISPELLABLE auras all day, which is exactly what the filter below finds.
	--
	-- UnitIsEnemy, not UnitCanAttack. DelveCoach.lua:1589 already learned that the
	-- hard way: a neutral quest giver is "attackable" too, and using the broad check
	-- there made a boss prompt fire on quest NPCs.
	local hostile = true
	if UnitIsEnemy then
		local okE, isEnemy = pcall(UnitIsEnemy, "player", "target")
		if okE then
			hostile = isEnemy and true or false
		end
	elseif UnitCanAttack then
		local okA, canAttack = pcall(UnitCanAttack, "player", "target")
		if okA then
			hostile = canAttack and true or false
		end
	end
	if not hostile then
		f:SetAlpha(0)
		return
	end

	local ok, _, firstSlot = pcall(C_UnitAuras.GetAuraSlots, "target", "HELPFUL|DISPELLABLE", 1)
	if ok and firstSlot ~= nil then
		f.tex:SetTexture(tex)
		-- Readable case: GetAuraSlots answered, so this branch is allowed and the
		-- word can simply be set alongside the alpha.
		if f.word then
			f.word:SetText((ns.L and ns:L("PROMPT_WORD_PURGE")) or "PURGE")
		end
		f:SetAlpha(1)
		AnnouncePurge(true)
	else
		f:SetAlpha(0)
		AnnouncePurge(false)
	end
end

local pending = false
local function Update()
	if not Enabled() then
		if frame then
			frame:Hide()
		end
		return
	end
	EnsureFrame()
	frame:Show()
	if frame.idle then
		frame.idle:SetShown(not (InCombatLockdown and InCombatLockdown()))
	end
	pcall(UpdateInterrupt)
	pcall(UpdateDispel)
end

--- Cast events fire in bursts; one update per frame is plenty for something the
--- eye reads.
local function Schedule()
	if pending or not (C_Timer and C_Timer.After) then
		return
	end
	pending = true
	C_Timer.After(0.05, function()
		pending = false
		pcall(Update)
	end)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
ev:RegisterEvent("SPELL_UPDATE_COOLDOWN")
-- The outline appears and disappears with combat, so both edges need an update.
ev:RegisterEvent("PLAYER_REGEN_DISABLED")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		RefreshInterrupt()
	end
	Schedule()
end)

local ev2 = CreateFrame("Frame")
for _, e in ipairs({
	"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_STOP", "UNIT_SPELLCAST_INTERRUPTED",
	"UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_CHANNEL_STOP", "UNIT_AURA",
}) do
	pcall(ev2.RegisterUnitEvent, ev2, e, "target")
end
ev2:SetScript("OnEvent", Schedule)

--------------------------------------------------------------------------------
-- Command
--------------------------------------------------------------------------------

function ns.IsActionPromptEnabled()
	return Enabled()
end

--- `/mh prompt sound` — cycles off → spoken → chime → off.
---
--- Spoken first because it is the one Rob asked for: a chime says "something", the
--- word says what. The chime stays as the second step for anyone who has the game's
--- own text-to-speech switched off.
function ns.ToggleActionPromptSound()
	ns.db = ns.db or {}
	local cur = ns.db.actionPromptSound
	local nextMode
	if not cur then
		nextMode = "speak"
	elseif cur == "speak" then
		nextMode = "chime"
	else
		nextMode = nil
	end
	ns.db.actionPromptSound = nextMode

	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	if nextMode == "speak" then
		print(("%s %s"):format(p, (ns.L and ns:L("PROMPT_SOUND_SPEAK"))
			or "Prompt sound: SPOKEN — it says the word when a purge becomes available."))
		print("   |cff9d9d9dInterrupts stay silent: the game lets an addon SHOW whether a cast|r")
		print("   |cff9d9d9dcan be kicked, but never read it — and alerting means reading.|r")
	elseif nextMode == "chime" then
		print(("%s %s"):format(p, (ns.L and ns:L("PROMPT_SOUND_ON"))
			or "Prompt sound: CHIME when a purge becomes available."))
	else
		print(("%s %s"):format(p, (ns.L and ns:L("PROMPT_SOUND_OFF")) or "Prompt sound OFF."))
	end
end

function ns.ToggleActionPrompt()
	ns.db = ns.db or {}
	ns.db.actionPrompt = not ns.db.actionPrompt
	local p = ("|cffffcc00%s|r"):format((ns.L and ns:L("PRINT_PREFIX")) or "Midnight Helper:")
	if ns.db.actionPrompt then
		RefreshInterrupt()
		print(("%s %s"):format(p, (ns.L and ns:L("PROMPT_ON"))
			or "Action prompt ON — drag it where you want it. Shows your interrupt and your dispel when they apply."))
	else
		print(("%s %s"):format(p, (ns.L and ns:L("PROMPT_OFF")) or "Action prompt OFF."))
	end
	Update()
end
