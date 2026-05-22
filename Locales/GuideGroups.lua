--[[
	Leveling Guides — "In groups" advisor lines (tank / healer / melee / caster / support).
	Merged into enUS, deDE, and nlNL at load time.
]]

local _, ns = ...

ns._mhLocales = ns._mhLocales or {}

local function merge(into, keys)
	if type(into) ~= "table" or type(keys) ~= "table" then
		return
	end
	for k, v in pairs(keys) do
		into[k] = v
	end
end

local SHARED_EN = {
	GUIDE_LEVEL_ADVISOR_TAB_GROUPS = "In groups",
	SEARCH_CHAT_GUIDE_GROUPS = "Opened Leveling Guides (In groups tab)",
}

local SHARED_NL = {
	GUIDE_LEVEL_ADVISOR_TAB_GROUPS = "Groepen",
	SEARCH_CHAT_GUIDE_GROUPS = "Leveling Guides geopend (tab In groups)",
}

local GROUP_EN = {
	-- tank
	GUIDE_GROUPS_TANK_10_1 = "In dungeons: interrupt enemy heals and party-wiping casts first. Say in chat which cast you kick.",
	GUIDE_GROUPS_TANK_10_2 = "Open scary pulls with one major defensive; save another for overlap or a named boss ability.",
	GUIDE_GROUPS_TANK_10_3 = "Pull at a pace your healer can sustain - two small packs beat one chain wipe.",
	GUIDE_GROUPS_TANK_30_1 = "Face cleaves and breaths away from the group; pick a steady spot for bosses.",
	GUIDE_GROUPS_TANK_30_2 = "Know your taunt backup plan in LFG (swap, grip, or hard taunt on adds).",
	GUIDE_GROUPS_TANK_30_3 = "Call a breather between pulls when mana or cooldowns are low - that is good leadership.",
	GUIDE_GROUPS_TANK_60_1 = "LFR/heroic: learn one boss rule per wipe (stand still, taunt swap, soak) instead of chasing DPS.",
	GUIDE_GROUPS_TANK_60_2 = "Stack your mitigation with healer externals - do not overlap the same window twice for one hit.",
	GUIDE_GROUPS_TANK_60_3 = "Assign interrupt priority: same dangerous cast every time; backup kick only if you cannot reach.",
	GUIDE_GROUPS_TANK_80_1 = "M+ and heroic: pull only what the group agreed on; route knowledge prevents panic chains.",
	GUIDE_GROUPS_TANK_80_2 = "Plan which defensive covers which boss ability - not \"press when low HP\".",
	GUIDE_GROUPS_TANK_80_3 = "Role Academy has copy-friendly party chat lines before you queue.",
	-- healer
	GUIDE_GROUPS_HEALER_10_1 = "Practice mouseover or focus heals before LFG - the tank frame is your anchor.",
	GUIDE_GROUPS_HEALER_10_2 = "While the pack lives, tank is priority; let DPS take a scratch if mana is tight.",
	GUIDE_GROUPS_HEALER_10_3 = "Tell the group you are learning - most players slow down when you ask.",
	GUIDE_GROUPS_HEALER_30_1 = "Drink between dungeon pulls; \"oom, 5 sec\" is valid coordination.",
	GUIDE_GROUPS_HEALER_30_2 = "External or big heal on the tank during spike windows beats reactive panic on everyone.",
	GUIDE_GROUPS_HEALER_30_3 = "Use your interrupt or CC if you have it - preventing damage is cheaper than healing it.",
	GUIDE_GROUPS_HEALER_60_1 = "LFR: learn predictable raid-wide timers; you do not need every bar at 100% all fight.",
	GUIDE_GROUPS_HEALER_60_2 = "Efficient heals by default; save expensive globals for tank + near-death.",
	GUIDE_GROUPS_HEALER_60_3 = "Personal defensive before you cannot cast - dead healer heals nobody.",
	GUIDE_GROUPS_HEALER_80_1 = "Raid: mentally note who covers which raid damage phase (cooldown cadence).",
	GUIDE_GROUPS_HEALER_80_2 = "Triage stays: you -> tank -> dying -> rest.",
	GUIDE_GROUPS_HEALER_80_3 = "Copy party chat lines from Role Academy when queue makes you nervous.",
	-- melee DPS
	GUIDE_GROUPS_MELEE_10_1 = "Interrupt is a group job - kick the dangerous cast even if you are not the \"main kick\".",
	GUIDE_GROUPS_MELEE_10_2 = "Use your defensive before standing in predictable damage, not after you are one-shot.",
	GUIDE_GROUPS_MELEE_10_3 = "Do not pull extra packs for the tank unless the group agreed.",
	GUIDE_GROUPS_MELEE_30_1 = "Dungeon: cleave away from the healer when you can; stack for AoE only when it is safe.",
	GUIDE_GROUPS_MELEE_30_2 = "Burst on packs the tank is holding, not on runners you pulled alone.",
	GUIDE_GROUPS_MELEE_30_3 = "Say if you are learning positioning - communication fixes most pug friction.",
	GUIDE_GROUPS_MELEE_60_1 = "LFR: mechanics beat rotation; one failed mechanic repeats wipes more than low DPS.",
	GUIDE_GROUPS_MELEE_60_2 = "Health pot or defensive gives learning margin; staying alive keeps group morale up.",
	GUIDE_GROUPS_MELEE_60_3 = "Know which casts are not interruptible - stop kicking immune spells.",
	GUIDE_GROUPS_MELEE_80_1 = "Heroic/M+: study one fight at a time; uptime matters less than not failing mechanics.",
	GUIDE_GROUPS_MELEE_80_2 = "Flask, food, and macros from Midnight Helper tabs - prep like tanks and healers do.",
	GUIDE_GROUPS_MELEE_80_3 = "Delves are a softer step before pugging dungeons.",
	-- caster / ranged DPS
	GUIDE_GROUPS_CASTER_10_1 = "Interrupt from range is still your job - call the cast you take in party chat.",
	GUIDE_GROUPS_CASTER_10_2 = "Use defensives before a mechanic hits you; casters die fast when they greedy cast.",
	GUIDE_GROUPS_CASTER_10_3 = "Do not body-pull ahead of the tank; let threat settle before big AoE.",
	GUIDE_GROUPS_CASTER_30_1 = "Dungeon: stand in healer range without stacking in ground effects.",
	GUIDE_GROUPS_CASTER_30_2 = "Save AoE for packs the tank grouped; scattered mobs waste your cooldowns.",
	GUIDE_GROUPS_CASTER_30_3 = "If learning, say so - most groups prefer a slow clear to a wipe chain.",
	GUIDE_GROUPS_CASTER_60_1 = "LFR: move early on mechanics; dead DPS does zero interrupts.",
	GUIDE_GROUPS_CASTER_60_2 = "Keep one defensive for learning margin on new bosses.",
	GUIDE_GROUPS_CASTER_60_3 = "Interrupt priority: healers and big nukes before minor damage casts.",
	GUIDE_GROUPS_CASTER_80_1 = "Heroic: pre-position before cast windows; movement planned beats panic running.",
	GUIDE_GROUPS_CASTER_80_2 = "Consumables and utility macros from Midnight Helper - same prep as other roles.",
	GUIDE_GROUPS_CASTER_80_3 = "Role Academy party chat lines help you ask for slow pulls or mana breaks.",
	-- support (Augmentation, etc.)
	GUIDE_GROUPS_SUPPORT_10_1 = "Keep core buffs on the group before damage spikes - dead support contributes nothing.",
	GUIDE_GROUPS_SUPPORT_10_2 = "Interrupt or CC if your kit has it; control reduces healing load.",
	GUIDE_GROUPS_SUPPORT_10_3 = "Stay in range of the tank pack; do not buff from three rooms away.",
	GUIDE_GROUPS_SUPPORT_30_1 = "Dungeon: refresh buff discipline between pulls - do not drop coverage mid-chain.",
	GUIDE_GROUPS_SUPPORT_30_2 = "Use defensives when melee reaches you; positioning is still your job.",
	GUIDE_GROUPS_SUPPORT_30_3 = "Call when you need a breather to rebuff - that is normal in learning groups.",
	GUIDE_GROUPS_SUPPORT_60_1 = "LFR: learn one mechanic per boss; buff timers matter less than not dying to floor effects.",
	GUIDE_GROUPS_SUPPORT_60_2 = "Help with interrupts on dangerous casts - prevention stabilizes the whole raid.",
	GUIDE_GROUPS_SUPPORT_60_3 = "Keep a personal defensive for overlap phases.",
	GUIDE_GROUPS_SUPPORT_80_1 = "Heroic: plan movement so support spells land on the right players during mechanics.",
	GUIDE_GROUPS_SUPPORT_80_2 = "Do not sacrifice yourself for marginal buff uptime - alive support wins.",
	GUIDE_GROUPS_SUPPORT_80_3 = "Pair with Role Academy for party chat before queue.",
}

local SHARED_DE = {
	GUIDE_LEVEL_ADVISOR_TAB_GROUPS = "In Gruppen",
	SEARCH_CHAT_GUIDE_GROUPS = "Leveling Guides geöffnet (Tab In Gruppen)",
}

local GROUP_DE = {
	GUIDE_GROUPS_TANK_10_1 = "In Dungeons: Unterbrich zuerst Heilungen und gruppengefährdende Casts. Sag im Chat, welchen Cast du kickst.",
	GUIDE_GROUPS_TANK_10_2 = "Starte schwere Pulls mit einer großen Defensive; behalte eine zweite für Overlap oder eine Boss-Ability.",
	GUIDE_GROUPS_TANK_10_3 = "Pull in einem Tempo, das dein Heiler schafft – zwei kleine Packs schlagen eine Wipe-Chain.",
	GUIDE_GROUPS_TANK_30_1 = "Drehe Cleaves und Atem weg von der Gruppe; wähle einen festen Spot für Bosse.",
	GUIDE_GROUPS_TANK_30_2 = "Kenne deinen Taunt-Backup in LFG (Swap, Grip oder Hard-Taunt auf Adds).",
	GUIDE_GROUPS_TANK_30_3 = "Ruf eine Pause zwischen Pulls, wenn Mana oder Cooldowns niedrig sind – gutes Leadership.",
	GUIDE_GROUPS_TANK_60_1 = "LFR/Heroic: Lerne eine Boss-Regel pro Wipe (stehen bleiben, Taunt-Swap, Soak) statt DPS zu jagen.",
	GUIDE_GROUPS_TANK_60_2 = "Stacke Mitigation mit Heiler-Externals – nicht zweimal dasselbe Fenster für einen Hit.",
	GUIDE_GROUPS_TANK_60_3 = "Interrupt-Prio: jedes Mal der gleiche gefährliche Cast; Backup-Kick nur wenn du nicht reinkommst.",
	GUIDE_GROUPS_TANK_80_1 = "M+ und Heroic: Pull nur, was die Gruppe abgesprochen hat; Routenwissen verhindert Panic-Chains.",
	GUIDE_GROUPS_TANK_80_2 = "Plane, welche Defensive welche Boss-Ability deckt – nicht \"drücken bei niedriger HP\".",
	GUIDE_GROUPS_TANK_80_3 = "Role Academy hat kopierbare Party-Chat-Zeilen vor dem Queue.",
	GUIDE_GROUPS_HEALER_10_1 = "Übe Mouseover- oder Focus-Heals vor LFG – das Tank-Frame ist dein Anker.",
	GUIDE_GROUPS_HEALER_10_2 = "Solange der Pack lebt: Tank hat Prio; lass DPS einen Kratzer nehmen, wenn Mana knapp ist.",
	GUIDE_GROUPS_HEALER_10_3 = "Sag der Gruppe, dass du lernst – die meisten werden langsamer, wenn du fragst.",
	GUIDE_GROUPS_HEALER_30_1 = "Trink zwischen Dungeon-Pulls; \"oom, 5 sec\" ist valide Koordination.",
	GUIDE_GROUPS_HEALER_30_2 = "External oder großer Heal auf den Tank in Spike-Fenstern schlägt Panic auf alle.",
	GUIDE_GROUPS_HEALER_30_3 = "Nutze Interrupt oder CC, wenn du sie hast – Schaden verhindern ist günstiger als heilen.",
	GUIDE_GROUPS_HEALER_60_1 = "LFR: Lerne vorhersehbare raidweite Timer; du brauchst nicht jede Bar die ganze Zeit auf 100%.",
	GUIDE_GROUPS_HEALER_60_2 = "Effiziente Heals standardmäßig; teure Globals für Tank + Near-Death sparen.",
	GUIDE_GROUPS_HEALER_60_3 = "Persönliche Defensive, bevor du nicht mehr casten kannst – toter Heiler heilt niemanden.",
	GUIDE_GROUPS_HEALER_80_1 = "Raid: Merk dir, wer welche Raid-Damage-Phase deckt (Cooldown-Kadenz).",
	GUIDE_GROUPS_HEALER_80_2 = "Triage bleibt: du -> Tank -> Sterbende -> Rest.",
	GUIDE_GROUPS_HEALER_80_3 = "Kopiere Party-Chat-Zeilen aus Role Academy, wenn die Queue nervös macht.",
	GUIDE_GROUPS_MELEE_10_1 = "Interrupt ist Gruppenjob – kicke den gefährlichen Cast, auch wenn du nicht der \"Main Kick\" bist.",
	GUIDE_GROUPS_MELEE_10_2 = "Nutze deine Defensive, bevor du vorhersehbarem Schaden ausgesetzt bist – nicht nach dem One-Shot.",
	GUIDE_GROUPS_MELEE_10_3 = "Zieh keine Extra-Packs für den Tank, außer die Gruppe hat zugestimmt.",
	GUIDE_GROUPS_MELEE_30_1 = "Dungeon: Cleave weg vom Heiler, wenn möglich; stack für AoE nur wenn es sicher ist.",
	GUIDE_GROUPS_MELEE_30_2 = "Burst auf Packs, die der Tank hält – nicht auf Runner, die du alleine gezogen hast.",
	GUIDE_GROUPS_MELEE_30_3 = "Sag Bescheid, wenn du Positionierung lernst – Kommunikation löst die meiste Pug-Reibung.",
	GUIDE_GROUPS_MELEE_60_1 = "LFR: Mechanics schlagen Rotation; ein failed Mechanic wiped öfter als niedriger DPS.",
	GUIDE_GROUPS_MELEE_60_2 = "Health Pot oder Defensive gibt Lernpuffer; am Leben bleiben hält die Moral hoch.",
	GUIDE_GROUPS_MELEE_60_3 = "Wisse, welche Casts nicht interruptible sind – hör auf, immune Spells zu kicken.",
	GUIDE_GROUPS_MELEE_80_1 = "Heroic/M+: Studiere einen Fight zur Zeit; Uptime zählt weniger als keine Mechanics zu failen.",
	GUIDE_GROUPS_MELEE_80_2 = "Flask, Food und Macros aus Midnight Helper – gleiche Prep wie Tank und Heiler.",
	GUIDE_GROUPS_MELEE_80_3 = "Delves sind ein sanfterer Schritt vor Dungeon-Pugs.",
	GUIDE_GROUPS_CASTER_10_1 = "Interrupt aus der Distanz ist trotzdem dein Job – nenne den Cast im Party-Chat.",
	GUIDE_GROUPS_CASTER_10_2 = "Nutze Defensives, bevor eine Mechanic trifft; Caster sterben schnell bei gierigem Casten.",
	GUIDE_GROUPS_CASTER_10_3 = "Body-Pull nicht vor dem Tank; lass Threat settle vor großem AoE.",
	GUIDE_GROUPS_CASTER_30_1 = "Dungeon: Steh in Heiler-Range ohne in Bodeneffekten zu stacken.",
	GUIDE_GROUPS_CASTER_30_2 = "Spare AoE für vom Tank gruppierte Packs; verstreute Mobs verschwenden Cooldowns.",
	GUIDE_GROUPS_CASTER_30_3 = "Wenn du lernst, sag es – die meisten Gruppen nehmen langsames Clear lieber als Wipe-Chains.",
	GUIDE_GROUPS_CASTER_60_1 = "LFR: Bewege dich früh bei Mechanics; toter DPS interrupted null.",
	GUIDE_GROUPS_CASTER_60_2 = "Behalte eine Defensive als Lernpuffer für neue Bosse.",
	GUIDE_GROUPS_CASTER_60_3 = "Interrupt-Prio: Heals und große Nukes vor kleinem Damage.",
	GUIDE_GROUPS_CASTER_80_1 = "Heroic: Pre-Position vor Cast-Fenstern; geplante Bewegung schlägt Panik-Laufen.",
	GUIDE_GROUPS_CASTER_80_2 = "Consumables und Utility-Macros aus Midnight Helper – gleiche Prep wie andere Rollen.",
	GUIDE_GROUPS_CASTER_80_3 = "Role Academy Party-Chat hilft bei langsamen Pulls oder Mana-Pausen.",
	GUIDE_GROUPS_SUPPORT_10_1 = "Halte Core-Buffs auf der Gruppe vor Damage-Spikes – tote Support hilft nicht.",
	GUIDE_GROUPS_SUPPORT_10_2 = "Interrupt oder CC, wenn dein Kit es hat; Control reduziert Heal-Last.",
	GUIDE_GROUPS_SUPPORT_10_3 = "Bleib in Range des Tank-Packs; buffe nicht aus drei Räumen Entfernung.",
	GUIDE_GROUPS_SUPPORT_30_1 = "Dungeon: Buff-Disziplin zwischen Pulls – keine Lücke mitten in einer Chain.",
	GUIDE_GROUPS_SUPPORT_30_2 = "Nutze Defensives, wenn Melee dich erreicht; Positionierung bleibt dein Job.",
	GUIDE_GROUPS_SUPPORT_30_3 = "Ruf, wenn du eine Pause zum Rebuff brauchst – normal in Lerngruppen.",
	GUIDE_GROUPS_SUPPORT_60_1 = "LFR: Lerne eine Mechanic pro Boss; Buff-Timer zählen weniger als Bodeneffekte.",
	GUIDE_GROUPS_SUPPORT_60_2 = "Hilf bei Interrupts auf gefährlichen Casts – Prävention stabilisiert den Raid.",
	GUIDE_GROUPS_SUPPORT_60_3 = "Behalte eine persönliche Defensive für Overlap-Phasen.",
	GUIDE_GROUPS_SUPPORT_80_1 = "Heroic: Plane Bewegung, damit Support-Spells bei den richtigen Spielern landen.",
	GUIDE_GROUPS_SUPPORT_80_2 = "Opfere dich nicht für marginale Buff-Uptime – lebende Support gewinnt.",
	GUIDE_GROUPS_SUPPORT_80_3 = "Nutze Role Academy für Party-Chat vor dem Queue.",
}

local GROUP_NL = {
	GUIDE_GROUPS_TANK_10_1 = "In dungeons: interrupt enemy heals en party-wiping casts eerst. Zeg in chat welke cast je kickt.",
	GUIDE_GROUPS_TANK_10_2 = "Open scary pulls met een grote defensive; bewaar een tweede voor overlap of een boss-ability.",
	GUIDE_GROUPS_TANK_10_3 = "Pull in een tempo dat je healer volhoudt - twee kleine packs zijn beter dan een chain wipe.",
	GUIDE_GROUPS_TANK_30_1 = "Draai cleaves en breaths van de group af; kies een vaste plek voor bosses.",
	GUIDE_GROUPS_TANK_30_2 = "Ken je taunt-backup in LFG (swap, grip, of harde taunt op adds).",
	GUIDE_GROUPS_TANK_30_3 = "Roep een pauze tussen pulls bij lage mana of cooldowns - dat is goed leiderschap.",
	GUIDE_GROUPS_TANK_60_1 = "LFR/heroic: leer een boss-regel per wipe (stil staan, taunt swap, soak) i.p.v. DPS jagen.",
	GUIDE_GROUPS_TANK_60_2 = "Stack mitigatie met healer-externals - overlap niet twee keer hetzelfde venster voor een hit.",
	GUIDE_GROUPS_TANK_60_3 = "Interrupt-prio: elke keer dezelfde gevaarlijke cast; backup alleen als jij niet kan raken.",
	GUIDE_GROUPS_TANK_80_1 = "M+ en heroic: pull alleen wat de group afspreekt; route-kennis voorkomt panic chains.",
	GUIDE_GROUPS_TANK_80_2 = "Plan welke defensive welke boss-ability dekt - niet \"drukken bij lage HP\".",
	GUIDE_GROUPS_TANK_80_3 = "Role Academy heeft copy-friendly party chat-regels vóór je queue't.",
	GUIDE_GROUPS_HEALER_10_1 = "Oefen mouseover of focus heals vóór LFG - het tank-frame is je anker.",
	GUIDE_GROUPS_HEALER_10_2 = "Zolang de pack leeft: tank is prio; laat DPS een schrammetje nemen als mana krap is.",
	GUIDE_GROUPS_HEALER_10_3 = "Zeg dat je leert - de meeste groups gaan rustiger als je het vraagt.",
	GUIDE_GROUPS_HEALER_30_1 = "Drink tussen dungeon-pulls; \"oom, 5 sec\" is geldige coordinatie.",
	GUIDE_GROUPS_HEALER_30_2 = "External of grote heal op de tank bij pieken verslaat panic op iedereen.",
	GUIDE_GROUPS_HEALER_30_3 = "Gebruik interrupt of CC als je die hebt - voorkomen is goedkoper dan healen.",
	GUIDE_GROUPS_HEALER_60_1 = "LFR: leer voorspelbare raid-wide timers; je hoeft niet elke bar 100% te houden.",
	GUIDE_GROUPS_HEALER_60_2 = "Efficient heals standaard; bewaar dure globals voor tank + near-death.",
	GUIDE_GROUPS_HEALER_60_3 = "Eigen defensive vóór je niet meer kan casten - dode healer heal niet.",
	GUIDE_GROUPS_HEALER_80_1 = "Raid: noteer wie welke raid-fase dekt (cooldown-cadans).",
	GUIDE_GROUPS_HEALER_80_2 = "Triage blijft: jij -> tank -> dying -> rest.",
	GUIDE_GROUPS_HEALER_80_3 = "Kopieer party chat uit Role Academy als queue eng voelt.",
	GUIDE_GROUPS_MELEE_10_1 = "Interrupt is group-werk - kick de gevaarlijke cast ook als jij niet \"main kick\" bent.",
	GUIDE_GROUPS_MELEE_10_2 = "Gebruik defensive vóór voorspelbare schade, niet na een one-shot.",
	GUIDE_GROUPS_MELEE_10_3 = "Pull geen extra packs voor de tank tenzij de group het afspreekt.",
	GUIDE_GROUPS_MELEE_30_1 = "Dungeon: cleave weg van de healer waar mogelijk; stack voor AoE alleen als het veilig is.",
	GUIDE_GROUPS_MELEE_30_2 = "Burst op packs die de tank vasthoudt, niet op runners die jij alleen trok.",
	GUIDE_GROUPS_MELEE_30_3 = "Zeg als je positioning leert - communicatie fixt de meeste pug-frictie.",
	GUIDE_GROUPS_MELEE_60_1 = "LFR: mechanics > rotation; een failed mechanic wiped vaker dan lage DPS.",
	GUIDE_GROUPS_MELEE_60_2 = "Health pot of defensive geeft leermarge; overleven houdt group-moraal hoog.",
	GUIDE_GROUPS_MELEE_60_3 = "Weet welke casts niet interruptible zijn - stop met kick op immune spells.",
	GUIDE_GROUPS_MELEE_80_1 = "Heroic/M+: leer een fight per keer; uptime telt minder dan geen mechanics falen.",
	GUIDE_GROUPS_MELEE_80_2 = "Flask, food en macro's via Midnight Helper - zelfde prep als tank/heal.",
	GUIDE_GROUPS_MELEE_80_3 = "Delves zijn een zachtere stap vóór dungeon pugs.",
	GUIDE_GROUPS_CASTER_10_1 = "Interrupt op afstand is nog steeds jouw taak - noem de cast die jij pakt.",
	GUIDE_GROUPS_CASTER_10_2 = "Gebruik defensives vóór een mechanic raakt; casters sterven snel bij greedy casts.",
	GUIDE_GROUPS_CASTER_10_3 = "Geen body-pull voor de tank; laat threat settelen vóór grote AoE.",
	GUIDE_GROUPS_CASTER_30_1 = "Dungeon: blijf in healer-range zonder in ground effects te staan.",
	GUIDE_GROUPS_CASTER_30_2 = "Bewaar AoE voor gegroepeerde packs; verspreide mobs verspillen cooldowns.",
	GUIDE_GROUPS_CASTER_30_3 = "Zeg als je leert - de meeste groups kiezen slow clear boven wipe chains.",
	GUIDE_GROUPS_CASTER_60_1 = "LFR: beweeg vroeg op mechanics; dode DPS interrupt niet.",
	GUIDE_GROUPS_CASTER_60_2 = "Houd een defensive vrij als leermarge op nieuwe bosses.",
	GUIDE_GROUPS_CASTER_60_3 = "Interrupt-prio: heals en grote nukes vóór kleine damage-casts.",
	GUIDE_GROUPS_CASTER_80_1 = "Heroic: pre-position vóór cast-vensters; geplande movement > panic run.",
	GUIDE_GROUPS_CASTER_80_2 = "Consumables en utility macro's via Midnight Helper - zelfde prep als andere rollen.",
	GUIDE_GROUPS_CASTER_80_3 = "Role Academy party chat helpt bij slow pulls of mana-pauzes vragen.",
	GUIDE_GROUPS_SUPPORT_10_1 = "Houd core buffs op de group vóór damage spikes - dode support helpt niet.",
	GUIDE_GROUPS_SUPPORT_10_2 = "Interrupt of CC als je kit het heeft; control verlaagt healing-druk.",
	GUIDE_GROUPS_SUPPORT_10_3 = "Blijf in range van de tank-pack; niet buffen van drie kamers verder.",
	GUIDE_GROUPS_SUPPORT_30_1 = "Dungeon: refresh buff-discipline tussen pulls - geen drop midden in een chain.",
	GUIDE_GROUPS_SUPPORT_30_2 = "Gebruik defensives als melee je raakt; positioning is nog steeds jouw taak.",
	GUIDE_GROUPS_SUPPORT_30_3 = "Roep als je een pauze nodig hebt om te rebuffen - normaal in leergroups.",
	GUIDE_GROUPS_SUPPORT_60_1 = "LFR: leer een mechanic per boss; buff-timers tellen minder dan floor-effects dodgen.",
	GUIDE_GROUPS_SUPPORT_60_2 = "Help met interrupts op gevaarlijke casts - voorkomen stabiliseert de raid.",
	GUIDE_GROUPS_SUPPORT_60_3 = "Houd een persoonlijke defensive voor overlap-fases.",
	GUIDE_GROUPS_SUPPORT_80_1 = "Heroic: plan movement zodat support spells op de juiste spelers landen.",
	GUIDE_GROUPS_SUPPORT_80_2 = "Offer jezelf niet op voor marginale buff-uptime - levende support wint.",
	GUIDE_GROUPS_SUPPORT_80_3 = "Combineer met Role Academy voor party chat vóór queue.",
}

merge(ns._mhLocales.enUS or {}, SHARED_EN)
merge(ns._mhLocales.enUS or {}, GROUP_EN)
merge(ns._mhLocales.deDE or {}, SHARED_DE)
merge(ns._mhLocales.deDE or {}, GROUP_DE)
merge(ns._mhLocales.nlNL or {}, SHARED_NL)
merge(ns._mhLocales.nlNL or {}, GROUP_NL)
