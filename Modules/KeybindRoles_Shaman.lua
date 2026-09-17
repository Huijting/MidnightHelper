local addonName, ns = ...
ns.KeybindRoleClassifier = ns.KeybindRoleClassifier or {}

--[[
	Naam->rol-classifier voor SHAMAN (WoW Midnight, v6-keybind-standaard).
	VERVANGT de oude incomplete Shaman-draft: dekt elke relevante ACTIVE spell per spec.

	Never-lie. Rollen zijn HIERUIT afgeleid:
	  - Modules/KeybindingData.lua -> ele_shaman (262) + enh_shaman (263): in-game bevestigd
	    (Rob, 2026-07-02). LEIDEND: toets/rol voor 262/263 volgt exact die spellByUiKey-blokken.
	  - JustAC/Data/InterruptAbilities.lua (Wind Shear/Capacitor Totem), SpellCategories.lua
	    (Astral Shift/Hex/Purge/Cleanse Spirit/Healing Surge/Bloodlust/Heroism/Thunderstorm),
	    SpellArchetypes.lua (builders/spenders), DefensiveEngine.lua, GapCloserEngine.lua
	    (Spirit Walk/Gust of Wind/Ghost Wolf/Spiritwalker's Grace).
	  - docs/KEYBIND_MAP_DRAFT_hunter_paladin_shaman.md (Restoration 264 - healer, draft-toetsen).

	Gekeyd op de exacte spell-NAAM; de addon matcht dit tegen de live spellbook.
	specs={<id>} = spec-specifiek; geen specs = class-baseline (alle 3 specs).
	specID's: Elemental 262, Enhancement 263, Restoration 264.

	BELANGRIJK (never-lie, Ele-scope): de in-game bevestigde Elemental-kit (KeybindingData) heeft
	GEEN Earth Shock / Flame Shock / Fire Elemental / Hex / Frost Shock / Tremor Totem /
	Spirit Walk / Lightning Lasso. Die worden daarom NIET aan spec 262 gekoppeld (dat waren
	draft-aannames in de oude versie). Ele-movement = Gust of Wind (Q); Ele-CD = Stormkeeper (F1)
	+ Ascendance (Alt+F1); Ele-spenders = Elemental Blast (ST) + Earthquake (AoE).

	Niet opgenomen: Recuperate (globaal F4), heal_sustain/F4, racial, trinket, potion, passieven
	(Tempest 454009 = passieve Lightning Bolt-proc, geen eigen knop).

	STAY ALIVE CARD (17 Sep 2026). `survival`, `survivalOrder` and `survivalNote` feed only
	Modules/SurvivalPlan.lua; the key fields next to them are untouched. Every tag follows
	docs/audit_2026-09-17/audit_shaman_evoker.md (Icy Veins 12.1, Wowhead pre-patch guides + spell pages).
	Card per spec: big = Astral Shift, then Earth Elemental; heal = Healing Surge (Ele/Enh) or
	Riptide + Healing Wave (Resto, click_cast but still your own heal), with Healing Stream Totem
	after the first; escape = Gust of Wind / Spirit Walk / Ghost Wolf, Thunderstorm on Ele;
	interrupt = Wind Shear.
	Left OFF the card on purpose: Spiritwalker's Grace and Nature's Swiftness (moving while casting,
	not survival), Spirit Link Totem / Healing Tide Totem (group cooldowns), Capacitor Totem (CC).
	Earth Elemental and Healing Stream Totem are class talents (262/263/264, audit BRON). Their
	`specs` stay as they were so no key moves; `survivalSpecs` puts them on every spec's card.
	Healing Surge is gone for Restoration (WH-pp-Resto), so 262/263 only (a narrowing moves nothing).
	Removed 17 Sep, no longer a button in 12.1: Feral Spirit (passive, Sundering/Doom Winds summon
	the wolves; IV-Enh, WH-Enh-rot) and Primordial Wave (replaced by Voltaic Blaze; WH-pp-Ele, IV-Enh).
]]

ns.KeybindRoleClassifier.SHAMAN = {
	-- ============================================================
	-- Gedeelde class-baseline (alle 3 specs; 1 entry per naam)
	-- ============================================================
	["Wind Shear"] = { role = "interrupt", priority = 1, survival = "interrupt", survivalOrder = 1 }, -- E (interrupt; JustAC InterruptAbilities/SpellCategories 57994)
	["Ghost Wolf"] = { role = "utility_primary", priority = 2, survival = "escape", survivalOrder = 3 }, -- Shift+Q (travel; 2645)
	-- Card: 40% for 12 s on a 2 min cooldown (WH-spell 108271) — the first big button.
	["Astral Shift"] = { role = "defensive_3", priority = 1, survival = "big", survivalOrder = 1 }, -- C (grote def, 40% DR; JustAC DefensiveEngine 108271)
	["Hex"] = { category = "dispel_cc", priority = 1 }, -- V (CC; JustAC SpellCategories 51514) -- alleen Enh bindt Hex live; baseline utility
	["Purge"] = { category = "dispel_cc", priority = 1 }, -- Ele V / Enh Shift+V (enemy dispel; JustAC SpellCategories 370)
	["Capacitor Totem"] = { category = "dispel_cc", priority = 2, alsoStop = "stun" }, -- T (AoE stun; JustAC InterruptAbilities [192058] cc mech=12) → Spec 08 alsoStop
	-- Removed for Restoration in 12.0 (WH-pp-Resto), so Ele/Enh only.
	["Healing Surge"] = { role = "heal_quick", priority = 1, specs = { 262, 263 }, survival = "heal", survivalOrder = 1 }, -- F2 (snelle combat self-heal-anker; JustAC SpellCategories 8004)
	["Bloodlust"] = { category = "cooldown", priority = 4 }, -- Shift+F2 (raid-haste, Horde; JustAC SpellCategories 2825)
	["Heroism"] = { category = "cooldown", priority = 4 }, -- Shift+F2 (raid-haste, Alliance; JustAC SpellCategories 32182)
	["Gust of Wind"] = { role = "utility_primary", priority = 1, survival = "escape", survivalOrder = 1 }, -- Ele Q (movement; JustAC GapCloserEngine 192063)
	["Nature's Swiftness"] = { category = "utility", priority = 5 }, -- Ele Shift+R (instant next cast; 378081)

	-- ============================================================
	-- Elemental (262) -- KeybindingData live-bevestigd (leidend)
	-- ============================================================
	["Lava Burst"] = { category = "main_rotation", priority = 1, specs = { 262 } }, -- Ele 1 (kern-nuke, Lava Surge; 51505)
	["Voltaic Blaze"] = { category = "main_rotation", priority = 2, specs = { 262, 263 } }, -- Ele 2 + Enh 3 (instant filler, past FS toe; 470057)
	["Lightning Bolt"] = { category = "main_rotation", priority = 3, specs = { 262, 263 } }, -- Ele 3; Enh 4 (Maelstrom-builder; 188196)
	["Elemental Blast"] = { category = "spender", priority = 1, specs = { 262, 263 } }, -- Ele 4; Enh 5 (ST-spender; 117014)
	["Chain Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+1", specs = { 262, 263 } }, -- Ele + Enh (AoE builder; 188443)
	["Earthquake"] = { category = "spender", priority = 7, bindKey = "Shift+4", specs = { 262 } }, -- Ele Shift+4 (AoE-spender; live 462620)
	["Spiritwalker's Grace"] = { role = "utility_secondary", priority = 1, specs = { 262, 264 } }, -- Ele+Resto F (cast-while-moving; JustAC GapCloserEngine 79206)
	["Skyfury"] = { category = "utility", priority = 2, specs = { 262 } }, -- Ele R (raid-buff, pre-combat; 462854)
	-- Card: knocks enemies away and works while stunned (IV-Ele).
	["Thunderstorm"] = { category = "utility", priority = 4, specs = { 262 }, survival = "escape", survivalOrder = 4, survivalNote = "SURVIVAL_NOTE_STUNNED" }, -- Ele X (AoE knockback + slow; JustAC SpellCategories 51490)
	-- Class talent for all three specs (IV-Ele/Enh/Resto); `specs` stays { 262 } for the keys, the card widens.
	-- Card: an emergency tank on a 3 min cooldown (WH-spell 198103), after Astral Shift.
	["Earth Elemental"] = { category = "defensive", priority = 4, specs = { 262 }, survivalSpecs = { 262, 263, 264 }, survival = "big", survivalOrder = 2 }, -- Ele Shift+C (extra def/pet; JustAC DefensiveEngine 198103)
	["Cleanse Spirit"] = { category = "dispel_cc", priority = 3, specs = { 262 } }, -- Ele Shift+V (friendly dispel; JustAC SpellCategories 51886)
	["Stormkeeper"] = { role = "cooldown_bar", priority = 1, specs = { 262, 263 } }, -- Ele F1 (burst-CD, live); Enh R (191634 Ele / 205495 Enh talent)

	-- ============================================================
	-- Enhancement (263) -- KeybindingData live-bevestigd (leidend)
	-- ============================================================
	["Stormstrike"] = { category = "main_rotation", priority = 1, specs = { 263 } }, -- Enh 1 (17364; Windstrike via Ascendance-macro)
	["Lava Lash"] = { category = "main_rotation", priority = 2, specs = { 263 } }, -- Enh 2 (Hot Hand; JustAC SpellArchetypes 60103)
	-- ⚠️ Shift+3, NIET Shift+1 (gewijzigd 7 aug 2026). Botste met Chain Lightning, en
	-- dat zijn twee echte knoppen: Crash Lightning is een melee-cleave die je óók op één
	-- doelwit drukt (Icy Veins zet 'm op stap 9 van de single-target-rotatie, en Storm
	-- Unleashed maakt 'm kernrotatie), Chain Lightning is de Maelstrom-spender vanaf
	-- twee doelen. Chain Lightning houdt Shift+1 omdat die entry ook Elemental bedient;
	-- Crash Lightning is Enhancement-only en kon dus als enige verschuiven zonder een
	-- tweede spec te raken. Shift+2 was al van Sundering.
	["Crash Lightning"] = { category = "main_rotation", priority = 6, bindKey = "Shift+3", specs = { 263 } }, -- Enh melee-cleave (187874)
	["Sundering"] = { category = "main_rotation", priority = 6, bindKey = "Shift+2", specs = { 263 } }, -- Enh Shift+2 (AoE frontal; 197214)
	["Frost Shock"] = { role = "utility_secondary", priority = 1, specs = { 263 } }, -- Enh F (ranged slow; 196840)
	["Tremor Totem"] = { category = "utility", priority = 4 }, -- baseline alle specs (fear/charm break; 8143) — Ele/Resto binden 'm net zo goed
	["Wind Rush Totem"] = { category = "utility", priority = 3, specs = { 263 } }, -- Enh Shift+T (movement-speed utility; JustAC 192077)
	["Spirit Walk"] = { role = "utility_primary", priority = 1, specs = { 263 }, survival = "escape", survivalOrder = 2 }, -- Enh Q (snare-break movement; JustAC GapCloserEngine 58875)
	-- Feral Spirit (passive in 12.1) and Primordial Wave (removed) are gone: see the header.
	["Doom Winds"] = { category = "cooldown", priority = 3, specs = { 263 } }, -- Enh Shift+F1 (burst; 384352)

	-- ============================================================
	-- Gedeeld Enh + Ele: grootste extra CD
	-- ============================================================
	["Ascendance"] = { category = "cooldown", priority = 3, specs = { 262, 263, 264 } }, -- Alt+F1. Per spec een eigen id (WH-spell): Ele 114050, Enh 114051, Resto 114052 (heal-CD)

	-- ============================================================
	-- Restoration (264) -- healer (v6 6-splitsing; Midnight 12.0.7 bevestigd via Method-gids).
	-- ST-heals + ST-HoTs (Riptide/Healing Wave/Healing Surge/Unleash Life) -> role="click_cast"
	--   (mouseover/click-cast, GEEN eigen toets).
	-- Raid/AoE/smart-heals op toets: Chain Heal/Healing Rain/Downpour/Surging Totem/Healing Stream Totem.
	-- Heal-COOLDOWNS: Healing Tide Totem (cooldown_bar), Spirit Link Totem, Ascendance (Resto).
	-- Never-lie: Wellspring / Cloudburst Totem / Ancestral Guidance zijn in Midnight VERWIJDERD -> niet opgenomen.
	-- ============================================================
	-- ST-heals + ST-HoTs -> click_cast (mouseover/click-cast; GEEN toets). v6 6.
	-- Card: click_cast, but on yourself these are the Resto self-heals (IV-Resto).
	["Riptide"] = { role = "click_cast", priority = 1, specs = { 264 }, survival = "heal", survivalOrder = 1 }, -- Resto ST-HoT (instant HoT; mouseover/click-cast; 61295)
	["Healing Wave"] = { role = "click_cast", priority = 1, specs = { 264 }, survival = "heal", survivalOrder = 3 }, -- Resto ST-heal (mana-efficiente filler; mouseover/click-cast; 77472)
	-- Healing Surge bestaat niet meer voor Resto (WH-pp-Resto); de baseline-entry hierboven is nu { 262, 263 }.
	["Unleash Life"] = { role = "click_cast", priority = 1, specs = { 264 } }, -- Resto ST-heal-buff (buft next cast op doel; mouseover/click-cast; 73685)
	-- Raid/AoE/smart-heals -> toets.
	["Chain Heal"] = { category = "raid_heal", priority = 2, specs = { 264 } }, -- Resto (smart multi-target heal, toets; 1064)
	["Healing Rain"] = { category = "raid_heal", priority = 2, specs = { 264 } }, -- Resto (ground-AoE heal, toets; JustAC SpellCategories 73920)
	["Downpour"] = { category = "raid_heal", priority = 3, specs = { 264 } }, -- Resto (AoE-burst-heal, toets; 462486)
	["Surging Totem"] = { category = "raid_heal", priority = 4, specs = { 264 } }, -- Resto (heal/damage-totem, on cooldown, toets; 444995)
	["Purify Spirit"] = { category = "dispel_cc", priority = 1, specs = { 264 } }, -- Resto V (curse/magic dispel; JustAC DefensiveEngine 77130)
	["Healing Tide Totem"] = { role = "cooldown_bar", priority = 1, specs = { 264 } }, -- Resto F1 (raid-heal-burst; JustAC DefensiveEngine 108280)
	["Spirit Link Totem"] = { category = "cooldown", priority = 2, specs = { 264 } }, -- Resto R (HP-verdeling raid-CD; JustAC DefensiveEngine 98008)
	-- Class talent for all three specs (IV-Ele, IV-Enh); `specs` stays { 264 } for the keys, the card widens.
	-- Card: a heal you drop often, after the first heal.
	["Healing Stream Totem"] = { role = "utility_secondary", priority = 1, specs = { 264 }, survivalSpecs = { 262, 263, 264 }, survival = "heal", survivalOrder = 2 }, -- Resto F (passieve group-heal; JustAC SpellCategories 5394)
	["Ancestral Spirit"] = { category = "utility", priority = 3, specs = { 264 } }, -- Resto T (out-of-combat rez; JustAC SpellCategories 2008)
}
