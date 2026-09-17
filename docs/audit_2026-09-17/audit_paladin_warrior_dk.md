# Audit klasse-advies — Paladin, Warrior, Death Knight (12.1, 17 sep 2026)

Alleen gelezen, niets in de addon aangepast.

## Bronnen en hoe ze gebruikt zijn

| code | bron | wat het bewijst |
|---|---|---|
| **W-CD** | wago.tools DB2 `SpellCooldowns` + `SpellCategories`/`SpellCategory` (lading-cd), build **12.1.0.69814** (live volgens `wago.tools/api/builds/latest`, 12 sep 2026) | basis-cooldown zonder talenten |
| **W-TREE** | wago.tools `TraitDefinition → TraitNodeEntry → TraitNodeXTraitNodeEntry → TraitNode`, dezelfde build | zit de spell in een talentboom? Bomen: **790** Paladin, **750** DK, **850** Warrior (huidig), **880** Warrior (oud, TWW) |
| **W-SPEC** | wago.tools `SpecializationSpells`, dezelfde build | welke spec krijgt de spell standaard |
| **W-DESC** | wago.tools `Spell.Description_lang`, dezelfde build | wat de spell doet |
| **IV-*** | Icy Veins spell-lijsten "12.1": [Ret](https://www.icy-veins.com/wow/retribution-paladin-pve-dps-spell-summary) (11 aug 2026), [Prot Pal](https://www.icy-veins.com/wow/protection-paladin-pve-tank-spell-summary) (10 aug), [Holy](https://www.icy-veins.com/wow/holy-paladin-pve-healing-spell-summary) (10 aug), [Arms](https://www.icy-veins.com/wow/arms-warrior-pve-dps-spell-summary) (10 aug), [Fury](https://www.icy-veins.com/wow/fury-warrior-pve-dps-spell-summary) (10 aug), [Prot War](https://www.icy-veins.com/wow/protection-warrior-pve-tank-spell-summary) (10 aug), [Blood](https://www.icy-veins.com/wow/blood-death-knight-pve-tank-spell-summary) (10 aug), [Frost DK](https://www.icy-veins.com/wow/frost-death-knight-pve-dps-spell-summary) (10 aug), [Unholy](https://www.icy-veins.com/wow/unholy-death-knight-pve-dps-spell-summary) (8 sep) | de huidige werking volgens een gids |
| **IV-UHnews** | [Icy Veins: Unholy makeover in Midnight](https://www.icy-veins.com/wow/news/your-unholy-death-knight-rotation-is-getting-a-makeover-in-midnight/) + [Maxroll Unholy 12.0](https://maxroll.gg/wow/class-guides/unholy-death-knight-raid-guide) | Apocalypse en Unholy Assault zijn verwijderd |

⚠️ **Hoe ik boom 850 en 880 uit elkaar hield (AFGELEID):** Challenging Shout en Berserker Rage zijn volgens IV-ProtWar standaard (geen talent). Ze staan wél in 880 en níét in 850. Thunderous Roar en Bitter Immunity staan alleen in 880 en komen op geen enkele 12.1-pagina van Icy Veins voor. Dus: 850 is de huidige boom, 880 is een overblijfsel.
⚠️ **W-CD geeft de basiswaarde.** Talenten zoals Unbreakable Spirit en Defender's Aegis maken cooldowns korter. Een addon-waarde die gelijk is aan W-CD noem ik OK.
⚠️ **Tegenstrijdige bronnen:** voor Ardent Defender zegt W-CD 90 s, IV-ProtPal zegt "2-minute cooldown". Voor Spell Reflection zegt W-CD 25 s, IV-ProtWar zegt 20 s. Ik volg W-CD, want dat is Blizzards eigen data. Wil je het zeker weten, bekijk dan de tooltip in het spel.

## Wat de speler te zien krijgt (gemeten in de code)

- De **"Stay alive"-kaart** staat **alleen op het DPS-tabblad** (`RoleAcademy.lua:722-727`). Hij wordt gebouwd voor de spec die **nu actief is** (`SurvivalPlan.lua:305-308`). Een Prot-paladin die het DPS-tabblad opent, ziet dus zijn Prot-kaart.
- Welke rijen verschijnen, bepaalt `LiveName`: alleen spells waarvoor `IsPlayerSpell` true geeft, zoals gecontroleerd in `SurvivalPlan.lua:165-180`.
- De **DPS-cooldownlijst** laat op je eigen spec alleen spells zien die je kent (`RoleAcademy.lua:636-654`). Bekijk je een andere spec, dan staat **alles** erin.
- `ns.DPS_DEFENSIVES` wordt **nergens meer getoond** (`RoleAcademy.lua:667-679`). Fouten daarin zijn dus onzichtbaar, al blijft de data verkeerd.
- De **tank-toolkit** (`RoleAcademy.lua:556-582`) en de **healer-toolkit** (`:480-505`) filteren **niet** op bekende spells. Een verwijderde spell verschijnt daar dus gewoon, met naam en al.

Stappen (`enUS.lua:810-814`): KEEPUP = "keep this up, put it on BEFORE you pull" · HURTS = "when your health drops fast" · HEAL = "to heal yourself" · ESCAPE = "to get away" · INTERRUPT = "when it is casting something".

Volgorde binnen een stap: eerst `priority`, bij gelijke waarde op **alfabet van de sleutel** (`SurvivalPlan.lua:351-356`).

---

## PALADIN

### Retribution (70) — kaart en lijsten

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Divine Shield | 642 | kaart: KEEPUP (defensive_1, `Paladin.lua:53`) | **FOUT** (BRON) | Immuniteit van 8 s met Forbearance en 5 min cooldown. Hoort als **laatste** noodknop onder HURTS. | IV-Ret ("immune to all damage… 8 seconds"); W-CD 300 s |
| Shield of Vengeance | 184662 | kaart: HURTS (defensive_3, pri 1, `:180`); DPS_DEFENSIVES[70] | **FOUT** (BRON) | In 12.1 geen eigen knop meer. Het talent 1261562 laat **Divine Protection** Shield of Vengeance casten. De rij valt waarschijnlijk weg door de bekend-filter, maar dat is AFGELEID en niet gemeten. | W-DESC 1261562 "Divine Protection … casts Shield of Vengeance"; W-TREE: 184662 zit in geen enkele knoop; IV-Ret "Shield of Vengeance: Divine Protection also applies an absorb" |
| Divine Protection | 403876 | kaart: HURTS pri 2 | **OK** (BRON) | Voor Ret de juiste id (W-SPEC 403876 → spec 70). −20% schade, 8 s, 60 s cooldown. Dit hoort de **eerste** rij onder HURTS te zijn. | W-SPEC; W-CD 60 s; IV-Ret |
| Blessing of Protection | 1022 | kaart: HURTS pri 3 | **TWIJFEL** (BRON) | Werkt op jezelf, maar beschermt **alleen tegen fysieke schade** en geeft Forbearance, waardoor Divine Shield en Lay on Hands daarna geblokkeerd zijn. De tekst "health drops fast" zegt dat niet. | W-DESC 1022; IV-Ret; W-CD 300 s (lading-categorie) |
| Blessing of Sacrifice | 6940 | kaart: HURTS pri 4 | **FOUT** (BRON) | Werkt alleen op een **bondgenoot** en zet schade op **jou** over. Hoort niet op een kaart om zelf te overleven. | W-DESC 6940 "Blesses a party or raid member… you suffer…"; IV-Ret |
| Guardian of Ancient Kings | 86659 | kaart: HURTS (defensive_3, zonder `specs`) | OK (gefilterd) | Alleen Prot heeft hem. `IsPlayerSpell` verbergt hem bij Ret. De entry heeft wel **geen `specs = {66}`**. | W-TREE 790; IV-ProtPal |
| Blessing of Spellwarding | 204018 | kaart: HURTS pri 5 | OK (gefilterd) | Talent voor Prot. | IV-ProtPal |
| Lay on Hands | 633 | kaart: HEAL (heal_ooc, pri 1) | **FOUT in de volgorde** (AFGELEID) | Heeft dezelfde pri 1 als Word of Glory, dus beslist het alfabet: **LoH staat vóór WoG**. LoH is een volledige heal met 10 min cooldown en Forbearance, dus de allerlaatste knop. Het label "ooc" (buiten gevecht) klopt ook niet. | W-CD 600 s; IV-Ret "Heals a friendly target for 100%"; `SurvivalPlan.lua:351-356` |
| Word of Glory | 85673 | kaart: HEAL pri 1 | OK (BRON) | De gewone zelfheal, kost 3 Holy Power. Hoort **eerst**. | IV-Ret |
| Rebuke | 96231 | kaart: INTERRUPT | OK (BRON) | Talent in de classboom, 15 s. | IV-Ret; W-CD cat. 15 s |
| Avenging Wrath | 31884 | DPS 120 s | OK (BRON) | Met Radiant Glory verdwijnt hij als knop. Het filter vangt dat op. | W-CD 120 s; IV-Ret |
| Divine Toll | 375576 | DPS 60 s | OK (BRON) | | W-CD 60 s; W-TREE 790 |
| Execution Sentence | 343527 | DPS 60 s | OK (BRON) | | W-CD 60 s; IV-Ret |
| Final Reckoning | 343721 | DPS 60 s (`DpsToolkit.lua:43`) | **FOUT** (BRON) | **Verwijderd.** Zit in geen enkele 12.1-knoop en staat niet op IV-Ret. Bij het bekijken van een andere spec staat hij er toch. | W-TREE (NONODE); IV-Ret rij 8-10 |

**Ontbreekt (Ret)**
- **Divine Steed** onder ESCAPE. Staat nu als `utility_primary` (`Paladin.lua:50`), dus de kaart heeft geen ontsnappingsrij. (IV-Ret "Divine Steed… 100% movement speed")
- **Wake of Ashes** in de DPS-lijst: 1 lading, 30 s, maakt 3 Holy Power. (W-CD categorie 2285; IV-Ret)
- **Blessing of Freedom** als losmaker bij roots en vertraging. Staat onder dispel_cc, dus niet op de kaart. Lage prioriteit. (IV-Ret)
- De juiste volgorde voor een beginner: Divine Protection → Word of Glory → Blessing of Protection (fysiek) → Divine Shield → Lay on Hands.

### Protection (66) — kaart en tank-toolkit

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Divine Shield | 642 | kaart: KEEPUP; tank-cd 300 s "immunity" | kaart **FOUT**, toolkit OK (BRON) | Noodknop. Bij een tank laat hij de mobs ook op iemand anders overstappen. | IV-ProtPal ("any targets hitting you… hit another player"); W-CD 300 |
| Shield of the Righteous | 53600 | kaart: HURTS (category defensive, pri 1, `:130`) | **FOUT** (BRON) | Actieve mitigatie die je **op peil houdt** met Holy Power. Hoort onder KEEPUP, niet onder "als je leven hard zakt". De tank-toolkit zegt het wel goed ("block"). | IV-ProtPal ("primary Holy Power spender… increases your armor"); TankToolkit:74 |
| Guardian of Ancient Kings | 86659 | kaart: HURTS pri 1; toolkit 180 s | cd OK, **volgorde FOUT** (AFGELEID) | Met pri 1 staat hij **vóór** Ardent Defender (pri 2). GoAK is de grote knop (−50%, 3 min), AD de kleinere (90 s). Voor een beginner moet het andersom. | W-CD 180 s (lading 2424); IV-ProtPal |
| Ardent Defender | 31850 | kaart: HURTS pri 2; toolkit 90 s | OK (BRON, met afwijking) | W-CD 90 s. IV-ProtPal schrijft "2-minute", zie de noot bovenaan. | W-CD; IV-ProtPal |
| Holy Bulwark | 432459 | kaart: HURTS pri 3 | TWIJFEL (BRON) | Is nu de wisselknop **Holy Armaments** (2 ladingen, 60 s) die afwisselt met Sacred Weapon. Staat Sacred Weapon klaar, dan is het geen defensieve knop. | IV-ProtPal; W-CD cat. 2220 (2×60 s) |
| Blessing of Spellwarding | 204018 | kaart: HURTS pri 5 | OK (BRON) | Immuun voor magie, werkt op jezelf, geeft Forbearance en deelt de cooldown met Blessing of Protection. Tekst zou "tegen magie" moeten zeggen. | W-DESC 204018; IV-ProtPal |
| Blessing of Protection / Sacrifice | 1022 / 6940 | kaart: HURTS | zie Ret; BoSac **FOUT** | Een tank met BoP op zichzelf verliest ook zijn fysieke aggro. | IV-ProtPal |
| Divine Protection | 403876 | kaart: HURTS | OK (gefilterd) | Prot heeft geen Divine Protection (niet in W-SPEC 66, niet op IV-ProtPal). | W-SPEC |
| Lay on Hands / Word of Glory | 633 / 85673 | kaart: HEAL, LoH eerst | **volgorde FOUT** | Zie Ret. Voor Prot is WoG juist de hoofd-heal: hij heelt meer naarmate je minder leven hebt. | IV-ProtPal |
| Bastion of Light | 378974 | classifier cooldown | **FOUT/dood** (BRON) | Verwijderd: geen knoop in 12.1 en niet op IV-ProtPal. | W-TREE; IV-ProtPal |
| Rite of Sanctification | 433568 | utility | OK (BRON) | Wapenbetovering, geen gevechtsknop. | IV-ProtPal |

**Ontbreekt (Prot Pal)**
- **Sentinel** (389539, talent voor Prot, 2 min): vervangt Avenging Wrath en geeft tot 30% minder schade. Staat niet op de kaart en niet in de tank-toolkit. (IV-ProtPal "Sentinel… reduces your damage taken by 2% [per stack]"; W-CD cat. 120 s)
- **Divine Steed** onder ESCAPE.
- In de tank-toolkit ontbreken **Blessing of Spellwarding** (magie) en **Lay on Hands**.
- `Sentinel` heeft in de classifier `specs = {66, 70}`, maar Ret heeft hem niet (W-TREE 790; niet op IV-Ret). Onschuldig door de filter.

### Holy (65) — kaart en healer-lijsten

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Divine Shield | 642 | kaart: KEEPUP | **FOUT** | zie Ret | |
| Divine Protection | **403876** | kaart: HURTS; HEALER_DEFENSIVES[65] (`HealerCooldowns.lua:227`) | **FOUT, verkeerde id** (BRON) | Holy krijgt **498**; 403876 is de Ret-versie. `IsPlayerSpell(403876)` geeft bij Holy vrijwel zeker false, dus **de meest gebruikte verdediging van Holy verdwijnt van de kaart** (AFGELEID, niet in het spel gemeten). | W-SPEC: 498 → 65, 403876 → 70; W-CD 498 = 60 s |
| Blessing of Sacrifice | 6940 | kaart: HURTS; healer-cd 120 s "ext" | kaart **FOUT**; lijst OK | Als hulp voor een ander is hij goed ingedeeld. | W-CD 120 |
| Lay on Hands | 633 | healer-cd 600 s "emerg"; kaart HEAL (vóór WoG) | lijst OK; kaart-volgorde **FOUT** | | W-CD 600 |
| Avenging Wrath | 31884 | healer-cd 120 s | OK (BRON) | | W-CD |
| Divine Toll | 375576 | healer-cd 60 s | OK (BRON) | Lightsmith vervangt hem door Holy Armaments. | IV-Holy |
| **Tyr's Deliverance** | 200652 | healer-cd 90 s "raid" (`HealerCooldowns.lua:99`); classifier cooldown | **FOUT** (BRON) | In 12.1 is dit een **passief talent** (1241275): het gaat vanzelf af als je Avenging Wrath gebruikt. Geen eigen knop meer, en de toolkit filtert niet, dus hij staat er toch. | W-DESC 1241275 "Activating Avenging Wrath releases the Light…"; W-TREE: 200652 zit in geen knoop |
| Aura Mastery | 31821 | healer-cd 180 s | OK (BRON) | | W-CD 180; IV-Holy |
| Avenging Crusader | 216331 | classifier cooldown_bar | **dood** (BRON) | Nu een talent (394088) dat Avenging Wrath **aanpast**, geen losse knop. | W-DESC 394088; IV-Holy "Modifies your Avenging Wrath" |
| Bestow Faith / Light's Hammer / Barrier of Faith | 223306 / 114158 / 148039 | classifier | **dood** (BRON) | Geen van drieën zit in een 12.1-knoop. | W-TREE |

**Ontbreekt (Holy)**
- **Holy Prism** (114165, talent) en **Beacon of Virtue** in de healer-cooldowns. (IV-Holy "Cooldowns")
- **Blessing of Protection** in de healer-cooldowns, om een ander te redden. (IV-Holy)
- **Divine Steed** onder ESCAPE.

---

## WARRIOR

⚠️ Geen enkele entry in `KeybindRoles_Warrior.lua` heeft een `id`. Alles wordt op naam opgezocht, en `SurvivalPlan.lua:137-152` beschrijft zelf dat een naam direct naar de vervangende spell springt, waarvoor `IsPlayerSpell` false geeft. Rijen kunnen dus stil wegvallen (AFGELEID, niet gemeten).

### Arms (71)

| spell | id (W) | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Ignore Pain | 190456 / Arms-versie **1277297** | kaart: KEEPUP (defensive_1, `Warrior.lua:68`) | **FOUT** (BRON) | Bij Arms een **kleine knop met 20 s cooldown** die je stapelt met andere, op tijd (niet opbouwend). Hij kost rage, die je vóór de pull niet hebt. Hoort onder HURTS, als eerste. | IV-Arms "A minor defensive cooldown that can be layered"; W-CD 1277297 = 20 s; W-DESC 1277297 |
| Die by the Sword | 118038 | kaart: HURTS pri 1; DPS_DEF 120 s | OK (BRON) | +parry, minder schade, 2 min. | W-CD 120; IV-Arms |
| Spell Reflection | 23920 | kaart: HURTS pri 4 (category defensive, `:119`) | **FOUT, verkeerde stap** (BRON) | Werkt tegen **magie** en kaatst de **eerstvolgende spell** terug. Druk hem als een vijand iets **op jou** cast, niet als je leven al zakt. | W-DESC 23920; IV-ProtWar; W-CD 25 s |
| Rallying Cry | 97462 | kaart: HURTS pri 4 | OK (BRON) | Groeps-CD, +10% (buiten een raid meer) leven, 3 min. Werkt ook voor jezelf. | W-CD 180; IV-ProtWar |
| **Intervene** | 3411 | kaart: HURTS pri 5 (`:50`) | **FOUT** (BRON) | Je **rent naar een bondgenoot** en vangt aanvallen op hem op. Kan niet op jezelf. | W-DESC 3411 "Run at high speed toward an ally…"; IV-Arms |
| Victory Rush / Impending Victory | 34428 / 202168 | kaart: HEAL | OK (BRON) | VR alleen binnen 20 s na een kill. IV: 30% leven, 25 s, kost rage. | W-DESC; W-CD 202168 = 25 s; IV-ProtWar |
| Pummel | 6552 | kaart: INTERRUPT | OK (BRON) | 15 s | W-CD cat. 15 s |
| Colossus Smash | 167105 | DPS 45 s | OK (BRON) | | W-CD 45 |
| Avatar | 107574 | DPS 90 s | OK (BRON) | | W-CD 90 |
| **Thunderous Roar** | 384318 | DPS 90 s (`DpsToolkit.lua:56`) | **FOUT** (BRON) | **Verwijderd.** Zit alleen in de oude boom 880 en staat niet op IV-Arms. | W-TREE; IV-Arms |
| Bladestorm / Ravager | 227847 / 228920 | DPS 90 s | OK (BRON) | Ravager heeft 1 lading van 90 s. | W-CD; W-CD cat. 2073 |

**Ontbreekt (Arms)**
- **Heroic Leap** onder ESCAPE (`utility_primary`, `:36`); 45 s. (IV-ProtWar; W-CD cat. 1211)
- **Champion's Spear** (nu id **376079**, 90 s) in de DPS-lijst. De classifier heeft hem alleen voor Prot (`:124`), maar het is een class-talent. (W-TREE 850; W-CD; IV-Arms)
- **Defensive Stance**: een class-talent dat je aanzet om minder schade te krijgen. Voor een beginner die steeds doodgaat is dit de echte "keep this up". (IV-Arms "Reduces damage taken at the cost of dealing less")
- **Berserker Rage** (verbreekt fear) staat alleen onder dispel_cc. Lage prioriteit.
- **Bitter Immunity** hoeft er niet bij: die is verwijderd (alleen boom 880).

### Fury (72)

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Enraged Regeneration | 184364 | kaart: HURTS pri 1; DPS_DEF 120 s | OK (BRON) | Minder schade en Bloodthirst heelt extra; werkt ook als je gestund bent. | W-DESC; W-CD 120; IV-Fury |
| Spell Reflection | 23920 | kaart: HURTS | **FOUT, verkeerde stap** | zie Arms | |
| Intervene | 3411 | kaart: HURTS | **FOUT** | zie Arms | |
| Rallying Cry | 97462 | kaart: HURTS | OK | | |
| Victory Rush / Impending Victory | | kaart: HEAL | OK | | IV-Fury |
| Pummel | | kaart: INTERRUPT | OK | | |
| Recklessness | 1719 | DPS 90 s | OK (BRON) | | W-CD 90 |
| Odyn's Fury | 385059 | DPS 45 s | OK (BRON) | | W-CD 45 |
| Avatar | 107574 | DPS 90 s | OK (BRON) | | W-CD 90; IV-Fury |
| **Thunderous Roar** | 384318 | DPS 90 s (`DpsToolkit.lua:57`) | **FOUT** (BRON) | Verwijderd; IV-Fury noemt hem niet. | W-TREE; IV-Fury |

**Ontbreekt (Fury)**
- **Bladestorm** (90 s) in de DPS-lijst. IV-Fury: "aligns perfectly with Recklessness and Avatar". W-CD 90.
- **Champion's Spear** (376079, 90 s).
- **Heroic Leap** onder ESCAPE en **Defensive Stance**, zoals bij Arms.
- De stap KEEPUP is leeg. Dat klopt, maar dan zou Defensive Stance daar passen.

### Protection (73) — kaart en tank-toolkit

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Ignore Pain | 190456 | kaart: KEEPUP; toolkit "absorb" | OK (BRON) | Bij Prot opbouwend tot 30% van je leven, kost 35 rage. | IV-ProtWar; W-DESC |
| Shield Block | 2565 | kaart: KEEPUP; toolkit "block" | OK (BRON) | Blokkeert alleen **melee**. Basis: 1 lading van 16 s. | W-DESC; W-CD cat. 1385 (1×16 s) |
| Shield Wall | 871 | kaart: HURTS; toolkit 180 s | OK (BRON) | −40%. Met Defender's Aegis 2 ladingen en 60 s korter. | W-CD cat. 1929 (180 s); IV-ProtWar |
| **Last Stand** | 12975 | toolkit 180 s "dr" (`TankToolkit.lua:105`) | **FOUT** (BRON) | In 12.1 **passief**: Shield Wall geeft +30% max-leven (talent 1243659). Geen eigen knop, maar de toolkit toont hem wel, want er is geen filter. De classifier-comment (`Warrior.lua:116`) zegt het zelf al. | W-DESC 1243659; W-TREE (12975 alleen in 880); IV-ProtWar |
| Spell Reflection | 23920 | kaart: HURTS; toolkit 25 s "magic" | cd OK (W-CD 25), **kaart-stap FOUT** | Toolkit-tekst "Use it against heavy magic damage or a big incoming spell" is goed. | W-CD; IV-ProtWar (zegt 20 s) |
| Rallying Cry | 97462 | kaart HURTS; toolkit 180 s "raid" | OK (BRON) | | W-CD |
| Intervene | 3411 | kaart: HURTS | **FOUT** | zie Arms | |
| Impending Victory | 202168 | kaart: HEAL | OK (BRON) | | IV-ProtWar |
| Pummel | 6552 | kaart: INTERRUPT | OK | | |

**Ontbreekt (Prot War)**
- **Demoralizing Shout** (1160, 45 s): vijanden doen 20% minder schade op jou. Staat nu als AoE-rotatie (`:111`) en zit niet op de kaart of in de toolkit. (IV-ProtWar; W-CD 45)
- **Heroic Leap** onder ESCAPE.
- **Disrupting Shout** (AoE-onderbreking, 90 s) mist onder INTERRUPT. Lage prioriteit. (IV-ProtWar)
- In de classifier staan Storm Bolt `{71,72}`, Shockwave `{73}`, Shattering Throw `{73}` en Champion's Spear `{73}`. Het zijn allemaal **class-talenten** voor alle drie de specs (W-TREE 850; IV-Arms/IV-ProtWar). Ze horen niet op de kaart, maar de tabel klopt hier niet.

---

## DEATH KNIGHT

⚠️ Ook hier heeft geen enkele entry een `id`; zie de noot bij Warrior.

### Gemeenschappelijk (Blood 250, Frost 251, Unholy 252)

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| **Lichborne** | 49039 | kaart: KEEPUP (defensive_1, `DeathKnight.lua:55`) | **FOUT** (BRON) | 10 s undead: immuun voor charm, fear en sleep, 10% leech, 2 min. Een **knop om uit CC te breken**, niet iets om aan te houden. | IV-Blood/IV-Unholy; W-DESC; W-CD 120 |
| **Anti-Magic Shell** | 48707 | category **utility** (`:57`), dus **niet op de kaart** | **FOUT, ontbreekt** (BRON) | De kleine knop die je het vaakst gebruikt: absorbeert magie, 60 s (40 s met talent). Hoort als **eerste** onder HURTS ("bij magische schade"). | IV-Unholy "should be used to mitigate Magic damage"; IV-Frost; W-CD 60 |
| Icebound Fortitude | 48792 | kaart: HURTS pri 1; DPS_DEF 120 s; Blood-toolkit 120 s | OK (BRON) | −30%, immuun voor stuns, 8 s. | W-CD 120; IV-Blood |
| Anti-Magic Zone | 51052 | kaart: HURTS pri 5 | TWIJFEL (BRON) | Een zone op de grond die **de groep** 15% minder magische schade geeft. Hij helpt niet als je leven zakt door fysieke schade. W-CD 240 s. | IV-Blood; W-DESC; W-CD |
| **Death Strike** | 49998 | category **spender** (`:53`), dus **niet op de kaart** | **FOUT, ontbreekt** (BRON) | "our primary means of healing ourselves" (IV-Unholy, IV-Frost), en bij Blood het hele spel. Moet **eerste** onder HEAL. | IV-Unholy; IV-Frost; IV-Blood |
| Death Pact | 48743 | kaart: HEAL (heal_quick) | OK, met kanttekening (BRON) | 50% heal plus een heal-absorb van 30%, 2 min, talent. Een noodknop, dus **na** Death Strike. | W-DESC; W-CD 120; IV-Unholy |
| Mind Freeze | 47528 | kaart: INTERRUPT | OK (BRON) | 15 s | W-CD |

**Ontbreekt (alle DK)**
- **Death's Advance** / **Wraith Walk** onder ESCAPE. Beide staan als `utility_primary` (`:43-44`). Death's Advance heeft 1 lading van 45 s (W-CD cat. 1941); Wraith Walk 60 s en verbreekt roots (IV-Blood).
- De juiste volgorde voor een beginner: Anti-Magic Shell (magie) → Death Strike → Icebound Fortitude → Death Pact → Lichborne (alleen tegen fear/charm).

### Blood (250) — tank-toolkit en classifier

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Vampiric Blood | 55233 | kaart: HURTS (def_4); toolkit 90 s "selfheal" | OK (BRON) | | W-CD 90; IV-Blood |
| Dancing Rune Weapon | 49028 | toolkit 120 s "dr" | OK (BRON) | +20% parry. | W-CD 120; IV-Blood |
| Anti-Magic Shell | 48707 | toolkit 60 s "magic" | OK (BRON) | Wél in de toolkit, níét op de kaart. | W-CD |
| Death Strike / Marrowrend | 49998 / 195182 | toolkit mitigatie | OK (BRON) | | IV-Blood |
| Consumption | naam → nu **1263824** | classifier cooldown | TWIJFEL (BRON) | Nieuwe versie, 45 s, geeft **ook minder inkomende schade**. Staat niet in de tank-toolkit. | W-DESC 1263824 "reducing the damage you take"; W-CD 45; IV-Blood |
| Bonestorm / Tombstone / Blooddrinker | 194844 / 219809 / 206931 | classifier cooldown | **dood** (BRON) | In geen enkele 12.1-knoop en niet op IV-Blood. | W-TREE; IV-Blood |
| Empower Rune Weapon | 47568 | classifier `specs {251, 250}` | FOUT voor Blood (BRON) | Staat niet op IV-Blood. | IV-Blood |

### Frost (251)

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Pillar of Frost | 51271 | DPS 45 s | OK (BRON) | | W-CD 45 |
| Frostwyrm's Fury | 279302 | DPS 90 s | OK (BRON) | | W-CD 90 |
| Empower Rune Weapon | 47568 | DPS 30 s ("2 charges") | OK (BRON) | | W-CD cat. 1614: 2×30 s |
| Remorseless Winter | 196770 | DPS 20 s | TWIJFEL (BRON) | Een rotatieknop, geen burst. Met Frozen Dominion wordt hij **passief** en verdwijnt de knop (filter vangt dat op). | IV-Frost; W-CD 20 |

**Ontbreekt (Frost)**: **Breath of Sindragosa** (152279, 2 min; IV-Frost; W-CD 120) en **Reaper's Mark** (439843, 45 s, Deathbringer; IV-Frost; W-CD 45) in de DPS-lijst. Classifier: Blinding Sleet staat alleen op `{251}` en Asphyxiate op `{250, 252}`, maar beide zijn class-talenten (IV-Blood, IV-Unholy en IV-Frost noemen ze alle drie).

### Unholy (252)

| spell | id | wat de addon zegt | oordeel | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Army of the Dead | 42650 | DPS 90 s | OK (BRON) | | W-CD 90; IV-Unholy |
| **Apocalypse** | 220143 (en 275699) | DPS 90 s (`DpsToolkit.lua:30`); classifier cooldown | **FOUT** (BRON) | **Verwijderd in Midnight.** De cd klopte ook niet: W-CD 275699 = 45 s. | IV-UHnews "Both Apocalypse and Unholy Assault have been removed"; Maxroll |
| **Unholy Assault** | 207289 | DPS 90 s; classifier cooldown | **FOUT** (BRON) | Verwijderd. | IV-UHnews; W-TREE NONODE |
| Summon Gargoyle | 49206 | classifier cooldown | **dood** (BRON) | Nu een talent (1242147) dat **Army of the Dead** een Gargoyle laat meebrengen. | W-DESC 1242147; IV-Unholy |

**Ontbreekt (Unholy)**: **Dark Transformation** (talent-id 1233448, 45 s, buiten de GCD). De comment op `DpsToolkit.lua:27` noemt de id "ambiguous", maar W-TREE geeft 1233448 als talentknoop met 45 s (W-CD cat. 45 s), en IV-Unholy noemt "45 seconds cooldown". Ook **Putrefy** (1247378, 1 lading van 30 s) is nu kern. Bij het bekijken van een andere spec toont de lijst Apocalypse en Unholy Assault nog.

---

## Structurele oorzaken

1. **`defensive_1` wordt KEEPUP, maar in de classifier betekent `defensive_1` "de Z-toets".** `SurvivalPlan.lua:15` en `:76` gaan uit van "the small one you keep up". De classifiers vullen de Z-toets echter met wat maar past: Divine Shield (`KeybindRoles_Paladin.lua:52-53`, "Kleine defensive (Z)"), Lichborne (`KeybindRoles_DeathKnight.lua:55`) en Arms' Ignore Pain (`KeybindRoles_Warrior.lua:68`). De toetsindeling en het advies delen één veld.
2. **`category = "defensive"` wordt blind HURTS** (`SurvivalPlan.lua:77-78`). Zo belanden daar spells voor een bondgenoot (Blessing of Sacrifice `Paladin.lua:61`, Intervene `Warrior.lua:50`), actieve mitigatie die je aanhoudt (Shield of the Righteous `Paladin.lua:130`), spells met een timing tegen casts (Spell Reflection `Warrior.lua:119`), groepszones (Anti-Magic Zone `DeathKnight.lua:58`) en knoppen alleen tegen fysiek of alleen tegen magie (BoP, Spellwarding). Het veld zegt niet *voor wie*, *tegen welke schade* of *wanneer*.
3. **ESCAPE is voor deze drie classes altijd leeg.** Alleen `role = "mobility"` telt (`SurvivalPlan.lua:81`), terwijl Divine Steed (`Paladin.lua:50`), Heroic Leap (`Warrior.lua:36`) en Death's Advance (`DeathKnight.lua:43`) `utility_primary` zijn. Het `survival =`-veld dat hiervoor bestaat, komt in deze drie bestanden **nergens** voor (gegrept: alleen de lezer in SurvivalPlan.lua).
4. **Alleen de categorieën `defensive`, `selfheal` en `interrupt` tellen.** Daardoor vallen de twee belangrijkste DK-knoppen weg: Death Strike (`spender`, `DeathKnight.lua:53`) en Anti-Magic Shell (`utility`, `:57`). Hetzelfde geldt voor Demoralizing Shout (`main_rotation`, `Warrior.lua:111`) en Sentinel (`cooldown`, `Paladin.lua:192`).
5. **`priority` geldt per toets, niet per kaart.** Bij gelijke waarde beslist het alfabet (`SurvivalPlan.lua:351-356`). Gevolgen: Lay on Hands (`Paladin.lua:77`, pri 1) staat vóór Word of Glory (`:75`, pri 1), en Guardian of Ancient Kings (`:56`, pri 1) vóór Ardent Defender (`:145`, pri 2). De kaart zet de grote noodknoppen bovenaan, precies omgekeerd aan "klein en vaak eerst".
6. **Een baseline-entry zonder `specs` krijgt de id van één spec.** Divine Protection `id = 403876` (`Paladin.lua:59`) is de Ret-versie; Holy heeft 498 (W-SPEC). De bekend-filter verbergt hem daardoor bij Holy. Dezelfde id staat in `HealerCooldowns.lua:227`. Guardian of Ancient Kings (`:56`) heeft geen `specs`, maar is alleen voor Prot.
7. **De bron-addons zijn TWW-data.** De classifiers en toolkits komen uit JustAC/ClassCodex. Daardoor staan er verwijderde of passief geworden spells in: Final Reckoning (`DpsToolkit.lua:43`), Thunderous Roar (`:56-57`), Apocalypse en Unholy Assault (`:30`), Last Stand (`TankToolkit.lua:105`), Tyr's Deliverance (`HealerCooldowns.lua:99`, `Paladin.lua:106`), Shield of Vengeance (`Paladin.lua:180`, `DpsToolkit.lua:87`), Bastion of Light (`:146`), Avenging Crusader (`:108`), Bestow Faith, Light's Hammer en Barrier of Faith (`:94`, `:101-102`), Bonestorm, Tombstone en Blooddrinker (`DeathKnight.lua:78-80`) en Summon Gargoyle (`:120`).
8. **De tank- en healer-toolkits filteren niet op bekende spells** (`RoleAcademy.lua:559-581`, `:480-505`), anders dan de DPS-toolkit (`:636-654`). Daardoor staan verwijderde spells (Last Stand, Tyr's Deliverance) daar gewoon, met naam. De DPS-lijst toont ze ook zodra je een andere spec bekijkt (`:637`).
9. **Warrior en DK hebben geen `id`s.** Zij vallen terug op opzoeken op naam, en dat is precies het pad waarvan `SurvivalPlan.lua:137-152` zelf zegt dat `IsPlayerSpell` dan false geeft voor de vervanger. Arms' Ignore Pain (1277297 naast 190456) en Champion's Spear (376079, niet 376080) zijn kandidaten om zo stil te verdwijnen. AFGELEID; in het spel te controleren met `/mh survival`.
10. **De kaart staat alleen op het DPS-tabblad** (`RoleAcademy.lua:722-727`), maar wordt gebouwd voor de actieve spec. Tanks en healers zien hem alleen als ze het DPS-tabblad openen, en krijgen dan wel hun eigen, tank- of healerkaart.
