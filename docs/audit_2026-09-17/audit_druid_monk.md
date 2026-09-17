# Audit klasse-advies: Druid (4 specs) + Monk (3 specs) — 17 sep 2026, patch 12.1

Alleen gelezen, niets in de addon gewijzigd.

**Gelezen:**
- `Modules/SurvivalPlan.lua`
- `Modules/KeybindRoles_Druid.lua` en `Modules/KeybindRoles_Monk.lua`
- `Modules/DpsToolkit.lua`, `Modules/TankToolkit.lua` en `Modules/HealerCooldowns.lua`
- `Modules/RoleAcademy.lua` (hoe de lijsten getoond worden)
- `Locales/enUS.lua:810-814` (de stap-teksten)

GEMETEN in de code:
- Geen Druid- of Monk-entry heeft een `survival =`-veld. Alleen Mage heeft dat (`KeybindRoles_Mage.lua:69,70,92,106`).
- De kaart wordt dus alleen via `role` en `category` gevuld.

**Stap-teksten:**
- keepup = "keep this up, put it on BEFORE you pull"
- hurts = "when your health drops fast"
- heal = "to heal yourself"
- escape = "to get away"
- interrupt = "when it is casting something"

**Hoe de kaart rijen kiest:**
- De kaart toont alleen spells waarvoor `IsPlayerSpell(base) ~= false`.
- Verwijderde spells vallen daardoor meestal stil weg. Dat is afgeleid; het hangt af van of de naam nog naar een id resolvet.

**Hoe de toolkit-lijsten gefilterd worden (GEMETEN in `RoleAcademy.lua`):**
- **DPS-cooldowns:** gefilterd op IsPlayerSpell (`RoleAcademy.lua:636-654`).
- **Healer-lijsten:** NIET gefilterd (`RoleAcademy.lua:468-505`).
- **Tank-lijsten:** NIET gefilterd (`RoleAcademy.lua:556-582`).
- Verwijderde spells in de healer- en tank-lijsten staan dus wél op het scherm, met hun oude naam of als "spell <id>" (`HealerCooldowns.lua:518-526`).
- **`ns.DPS_DEFENSIVES`:** wordt nergens meer getoond, het is dode data (`RoleAcademy.lua:667-679`). De fouten erin tellen alleen voor later hergebruik.

**Legenda:**
- **BRON** = bevestigd door een genoemde, actuele bron.
- **AFGELEID** = eigen redenering.

**Hoofdbronnen (12.x):**
- warcraft.wiki.gg: patchgeschiedenis per spell.
- Blizzard-patchnotes Druid, forum: https://us.forums.blizzard.com/en/wow/t/full-patch-notes/2176007
- Icy Veins en Method: 12.1-gidsen.
- Wowhead: Midnight-pre-patch-gidsen.

---

## DRUID — Balance (102)

### Wat de kaart toont (gereconstrueerd, AFGELEID uit de code)
1. Barkskin — keepup
2. Renewal — heal. Wordt weggefilterd, want de spell is verwijderd.
3. Travel Form — escape
4. Solar Beam — interrupt

"hurts" is leeg. Geen enkele Balance-spell staat op `defensive_2-4` of in `category="defensive"`.

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Barkskin | 22812 | keepup "zet aan VÓÓR de pull" (`KeybindRoles_Druid.lua:209`, `defensive_1`) | **FOUT** (BRON) | Geen onderhouden buff: 20% minder schade, 8 s, cd 45 s, te gebruiken in elke vorm en ook als je gestund bent. Hoort bij "when your health drops fast", als eerste (kleinste) knop. | https://warcraft.wiki.gg/wiki/Barkskin |
| Renewal | 108238 | heal (`:211`, baseline, alle specs) | **FOUT** (BRON) | In 12.0.0 uit de klassenboom verwijderd. Vervanger is de passieve Aessina's Renewal. De kaart filtert hem waarschijnlijk weg, maar de entry is dood. | Blizzard-patchnotes ("The following talents have been removed: Nature's Vigil, Renewal"); https://www.method.gg/guides/guardian-druid |
| Travel Form | — | escape (`:207`, `mobility`) | TWIJFEL (AFGELEID) | Van vorm wisselen haalt je uit Bear Form, en binnen is Travel Form beperkt. Dash, Tiger Dash en Wild Charge zijn de echte ontsnappingen; die staan op `utility_primary` en komen dus niet op de kaart. | — |
| Solar Beam | 78675 | interrupt (`:113`) | OK (BRON) | Balance-interrupt, genoemd in de 12.1-gids. | https://www.icy-veins.com/wow/balance-druid-pve-dps-guide |
| Tiger Dash | — | `utility_primary`, specs {102} (`:115`) | TWIJFEL (AFGELEID) | Tiger Dash is een klassentalent, niet alleen voor Balance. Staat niet op de kaart. | — |

**DPS-cooldowns** (`DpsToolkit.lua:32`):

| spell | id | cd in addon | verdict | toelichting | bron |
|---|---|---|---|---|---|
| Celestial Alignment | 194223 | 180 | TWIJFEL | Nog steeds de hoofd-cooldown (BRON). De cd is niet bevestigd: Wowhead-tooltip was onbruikbaar en IV noemt geen getal. | IV Balance-gids |
| Incarnation: Chosen of Elune | 102560 | 180 | TWIJFEL | Bestaat nog (BRON); cd niet bevestigd. | IV |
| Fury of Elune | 202770 | 60 | OK/TWIJFEL | Genoemd in de 12.1-gids; cd niet bevestigd. | IV |
| Force of Nature | 205636 | 60 | OK/TWIJFEL | Idem. | IV |

**DPS_DEFENSIVES** (dood, `DpsToolkit.lua:76`): Renewal is **FOUT** (BRON, verwijderd).

### Ontbreekt
- **Bear Form als noodknop.** IV Balance: "always available to increase Health and generally best used to take big hits". Staat als `utility` (`:225`), dus niet op de kaart. (BRON)
- **Heart of the Wild** (klassentalent). In Bear Form: +30% max health, 20 s. Hij is alleen voor {104} gescoped (`:150`), dus Balance ziet hem nergens. (BRON: patchnotes "Heart of the Wild has been redesigned … Bear Form: Maximum health increased by 30%"; Method: "class tree")
- **Regrowth als self-heal.** Staat alleen onder {105} als `click_cast` (`:182`), dus Balance heeft **geen enkele** self-heal op de kaart. (AFGELEID; Forestwalk in de patchnotes verwijst naar het casten van Regrowth door alle specs)
- **Frenzied Regeneration** (klassentalent, in Bear Form) is gescoped op {103,104}. (AFGELEID)
- **Convoke the Spirits** (391528) ontbreekt in de DPS-cooldowns. IV Balance noemt hem als burst naast Force of Nature en Fury of Elune. (BRON)

---

## DRUID — Feral (103)

### Wat de kaart toont (AFGELEID)
1. Barkskin — keepup
2. Survival Instincts — hurts
3. Frenzied Regeneration — heal. Renewal valt weg.
4. Travel Form — escape
5. Skull Bash — interrupt

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Barkskin | 22812 | keepup | **FOUT** (BRON) | Zie Balance; hoort bij "hurts". | wiki Barkskin |
| Survival Instincts | 61336 | hurts (`:164`, `defensive_3`) | OK (BRON) | IV Feral: "Between Barkskin and Survival Instincts there's some strong damage reduction". | https://www.icy-veins.com/wow/feral-druid-pve-dps-guide |
| Frenzied Regeneration | 22842 | heal (`:165`) | TWIJFEL (BRON + AFGELEID) | Werkt alleen in Bear Form. In Cat Form pas met de hero-boom Druid of the Claw (IV). Voor een beginner staat hier "heal yourself" zonder de uitleg "eerst naar Bear Form". | IV Feral |
| Renewal | 108238 | heal | **FOUT** (BRON) | Verwijderd in 12.0.0. | patchnotes |
| Skull Bash | 106839 | interrupt (`:162`) | OK (BRON) | "pulls double duty as a short charge". | IV Feral |
| Thrash | — | `main_rotation` {103,104} (`:160`) | **FOUT voor 103** (BRON) | IV Feral 12.1: "Thrash and Brutal Slash have been removed from the tree". Staat niet op de kaart. | IV Feral |

**DPS-cooldowns** (`DpsToolkit.lua:33`):

| spell | id | cd in addon | verdict | bron |
|---|---|---|---|---|
| Tiger's Fury | 5217 | 30 | OK (BRON: "30-second cooldown") | IV Feral rotation |
| Berserk | 106951 | 180 | OK als basis (BRON: "3 minutes (reduced to 2 minutes with Berserk: Heart of the Lion)") | https://www.icy-veins.com/wow/feral-druid-pve-dps-rotation-cooldowns-abilities |
| Incarnation: Avatar of Ashamane | 102543 | 180 | TWIJFEL (BRON: met Ashamane's Guidance 90 s; de basis-cd noemt de pagina niet) | idem |
| Feral Frenzy | 274837 | 45 | TWIJFEL (BRON: 12.1 heeft een keuze tussen Focused Frenzy met cd 30 s en Frantic Frenzy; het id van de keuzevariant is niet geverifieerd) | IV Feral-gids |

**DPS_DEFENSIVES** (dood, `:77`): Barkskin cd 60. De wiki zegt 45 s: TWIJFEL/FOUT.

### Ontbreekt
- **Convoke the Spirits** (391528, cd 2 min). IV Feral noemt hem als "strong burst tool alongside Berserk". (BRON)
- **Heart of the Wild** als extra defensive. IV Feral: "Heart of the Wild can also be layered on top for even more defense". Alleen gescoped op 104. (BRON)
- **Regrowth** met Predatory Swiftness als self-heal. Niet voor 103 geclassificeerd; IV noemt "Regrowth healing increased by 25%" in 12.1. (BRON dat het gebruikt wordt; de rol is AFGELEID)
- **Dash, Tiger Dash, Stampeding Roar** onder "escape". Ze staan op `utility_primary` en komen dus nooit op de kaart. (AFGELEID)

---

## DRUID — Guardian (104) — tank

### Wat de kaart toont (AFGELEID)
Sortering: eerst priority, daarna alfabetisch.

1. Barkskin — keepup
2. Ironfur — hurts (p1)
3. Survival Instincts — hurts (p1, alfabetisch na Ironfur)
4. Rage of the Sleeper — hurts (p3). Wordt weggefilterd.
5. Bristling Fur — hurts (p4)
6. Frenzied Regeneration — heal
7. Travel Form — escape
8. Skull Bash — interrupt

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Barkskin | 22812 | keepup | **FOUT** (BRON) | Korte DR op cd (IV Guardian: "short cooldown mitigation tool"). Voor een tank vaak op cooldown gebruiken; een "altijd-aan"-buff is het niet. | wiki; https://www.icy-veins.com/wow/guardian-druid-pve-tank-guide |
| Ironfur | 192081 | hurts (`:143`, `category="defensive"`) | **FOUT** (BRON) | Dit is juist de knop die je ALTIJD ophoudt (Wowhead: "keeping one stack of Ironfur active"). Hoort bij "keepup". | https://www.wowhead.com/guide/classes/druid/guardian/midnight-pre-patch ; IV-nieuws Guardian |
| Survival Instincts | 61336 | hurts | OK (BRON) | Grote noodknop. 2 charges zijn in 12.0 baseline geworden ("Improved Survival Instincts" is verwijderd). | patchnotes; wolfofwarcraft |
| Rage of the Sleeper | 200851 | hurts (`:152`) | **FOUT** (BRON) | Verwijderd in 12.0.0. | https://warcraft.wiki.gg/wiki/Rage_of_the_Sleeper |
| Bristling Fur | — | hurts (`:155`) | TWIJFEL (BRON + AFGELEID) | Bestaat nog (keuzenode met Reinforced Fur, cd 40 s). Het is een Rage-generator bij schade, geen DR-knop; "when your health drops fast" is voor een beginner misleidend. | https://warcraft.wiki.gg/wiki/Bristling_Fur |
| Frenzied Regeneration | 22842 | heal | OK (BRON) | Kern-heal van Guardian. | IV / Wowhead |
| Renewal | 108238 | heal | **FOUT** (BRON) | Verwijderd. | Wowhead Guardian pre-patch: "Renewal - Removed entirely" |
| Skull Bash | 106839 | interrupt | OK | — | — |
| Lunar Beam | 204066 | `cooldown` (`:149`) | OK (BRON) | IV 12.1 noemt hem een "survivability tool"; hij verdient een plek onder "hurts". | IV Guardian |

**Tank-cooldowns** (`TankToolkit.lua:109-112`, ongefilterd):

| spell | id | cd | verdict | bron |
|---|---|---|---|---|
| Survival Instincts | 61336 | 180 | OK/TWIJFEL (2 charges baseline; recharge niet bevestigd) | patchnotes |
| Barkskin | 22812 | 60 | **TWIJFEL/FOUT**: de wiki (Midnight) zegt 45 s | wiki Barkskin |

**Tank-mitigatie** (`TankToolkit.lua:80-83`): Ironfur en Frenzied Regeneration zijn OK.

### Ontbreekt
- **Incarnation: Guardian of Ursoc** als grote defensive/offensieve cd in de tanklijst. IV: "Major cooldown ability". (BRON)
- **Heart of the Wild** (Bear: +30% max health). (BRON: patchnotes)
- **Lunar Beam** in de tanklijst. (BRON: IV "survivability tool")
- **Een echte escape of groepssnelheid** (Stampeding Roar, Wild Charge). (AFGELEID)

---

## DRUID — Restoration (105) — healer

### Wat de kaart toont (AFGELEID)
Sortering op priority: Barkskin p1, Ironbark p2.

1. Barkskin — keepup
2. Ironbark — keepup
3. Travel Form — escape

Er staat **geen** heal-rij: Renewal valt weg en Regrowth is `click_cast`. Er is ook **geen** interrupt-rij, en dat klopt (zie hieronder).

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Barkskin | 22812 | keepup | **FOUT** (BRON) | "hurts"; IV Resto noemt hem "Very low cooldown". | wiki |
| Ironbark | 102342 | keepup "zet aan VÓÓR de pull" (`:188`, `defensive_1`) | **FOUT** (BRON) | cd 1,5 min, 12 s. Kan op jezelf, maar is vooral een externe voor de tank of een bondgenoot. Hoort als externe in de healerlijst (staat daar al) of onder "hurts", en nooit als "altijd aan". | https://warcraft.wiki.gg/wiki/Ironbark |
| Renewal | 108238 | heal | **FOUT** (BRON) | Verwijderd. | patchnotes |
| Regrowth | 8936 | `click_cast` (`:182`), dus niet op de kaart | **FOUT** voor de kaart (AFGELEID) | Dit is de self-heal die Resto nog heeft. De kaart laat hem weg omdat `click_cast` geen survival-stap heeft. | — |
| Skull Bash (geen) | — | geen interrupt voor Resto | OK (BRON) | "Skull Bash is no longer available to Restoration Druids." | patchnotes |
| Cenarion Ward | — | `click_cast` (`:184`) | **FOUT** (BRON) | Verwijderd in 12.0. Staat niet op de kaart. | patchnotes (Resto removed list) |
| Flourish | — | `category="cooldown"` (`:191`) | **FOUT** (BRON) | Nu passief, gekoppeld aan Tranquility. | patchnotes; IV Resto |
| Grove Guardians | — | `category="cooldown"` (`:194`) | **FOUT** (BRON) | Nu passief (proct op Swiftmend en Wild Growth). | IV Resto; Wowhead Resto pre-patch |

**Healer-cooldowns** (`HealerCooldowns.lua:105-110`, ongefilterd):

| spell | id | cd | verdict | bron |
|---|---|---|---|---|
| Tranquility | 740 | 180 | OK/TWIJFEL (cd niet bevestigd; nu met schild van 60% max health) | IV Resto |
| Incarnation: Tree of Life | 33891 | 180 | TWIJFEL (bestaat, BRON; cd niet bevestigd) | IV Resto |
| Convoke the Spirits | **323764** | 120 | **FOUT id** (BRON). 323764 is de oude Night Fae-covenantversie; de huidige talent-spell is **391528**, cd 2 min. | https://warcraft.wiki.gg/wiki/Convoke_the_Spirits |
| Ironbark | 102342 | 90 | OK (BRON: 1,5 min) | wiki Ironbark |

**Healer-defensives** (`HealerCooldowns.lua:228`, ongefilterd):
- Barkskin cd 60: TWIJFEL, de wiki zegt 45.
- **Renewal: FOUT** (BRON, verwijderd). Deze wordt WEL getoond.

**Core heals** (`:165-171`): Rejuvenation, Lifebloom, Regrowth, Swiftmend en Wild Growth zijn OK (AFGELEID; geen verwijdering gevonden).

### Ontbreekt
- **Regrowth** als "heal yourself". (AFGELEID)
- **Bear Form** als noodknop. IV Resto: Barkskin en Bear Form als "insurance against massive hits". (BRON)
- **Innervate** (cd 3 min, BRON: IV Resto) en **Nature's Swiftness** in de healer-cooldowns. (IV noemt Nature's Swiftness; cd niet bevestigd)
- **Heart of the Wild** (klassentalent). (BRON)

---

## MONK — Brewmaster (268) — tank

### Wat de kaart toont (AFGELEID)
1. Celestial Brew — keepup
2. Fortifying Brew — hurts
3. Purifying Brew — hurts
4. Expel Harm — heal
5. Vivify — heal
6. Spear Hand Strike — interrupt

"escape" is leeg: Monk gebruikt de rol `mobility` nergens.

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Celestial Brew | 322507 | keepup "VÓÓR de pull" (`KeybindRoles_Monk.lua:83`) | **FOUT** (BRON) | Sinds 12.1: cd 1,5 min, absorb 8 s, geen onderhouden buff. Het is ook een **keuzenode met Celestial Infusion** (sinds 11.2); wie Infusion kiest, ziet op de kaart niets. Hoort bij "hurts" of "vóór een grote klap". | https://warcraft.wiki.gg/wiki/Celestial_Brew ; https://www.icy-veins.com/wow/brewmaster-monk-pve-tank-guide |
| Fortifying Brew | 115203 | hurts (`:168`) | OK (BRON) | Kern-defensive; cd 6 min volgens Wowhead. | https://www.wowhead.com/spell=115203 |
| Purifying Brew | 119582 | hurts (`:78`) | TWIJFEL (BRON) | IV: "Good times to use it are when the button is glowing, or when you are about to reach 2 charges". Dat is ritmisch gebruik, geen paniekknop. | IV BM |
| Expel Harm | 322101 | heal (`:165`) | OK (BRON) | Nog voor BM en WW. | https://warcraft.wiki.gg/wiki/Expel_Harm |
| Vivify | 116670 | heal (`heal_ooc`) | OK (AFGELEID) | — | — |
| Spear Hand Strike | 116705? | interrupt (`:153`) | OK (BRON) | BM en WW; interrupt-duur is 5 s. Het id staat niet in de addon (hij koppelt op naam). | https://warcraft.wiki.gg/wiki/Spear_Hand_Strike |
| Weapons of Order | 387184 | `cooldown` (`:85`) | **FOUT** (BRON) | Verwijderd in 12.0.0. | https://warcraft.wiki.gg/wiki/Weapons_of_Order |
| Exploding Keg | 325153 | `cooldown` (`:86`) | OK (BRON) | cd 1 min; reset nu ook Keg Smash. | https://warcraft.wiki.gg/wiki/Exploding_Keg |
| Invoke Niuzao | — | `cooldown_bar` (`:88`) | OK (BRON) | cd nu 2 min (was 3). | https://warcraft.wiki.gg/wiki/Invoke_Niuzao,_the_Black_Ox |
| Rushing Jade Wind | — | `main_rotation` BM (`:81`) | TWIJFEL | Voor BM is geen 12.x-verwijdering gevonden. | wiki RJW |

**Tank-cooldowns** (`TankToolkit.lua:119-123`, ongefilterd):

| spell | id | cd | verdict | bron |
|---|---|---|---|---|
| Fortifying Brew | 115203 | 360 | OK (BRON: Wowhead "6 minutes") | wowhead |
| **Dampen Harm** | 122278 | 120 | **FOUT** (BRON). Verwijderd in 12.0.0 en wordt toch getoond. | https://warcraft.wiki.gg/wiki/Dampen_Harm ; IV BM ("Removed … Dampen Harm, Diffuse Magic") |
| **Zen Meditation** | 115176 | 300 | **FOUT** (BRON). Verwijderd in 11.2.0 en wordt toch getoond. | https://warcraft.wiki.gg/wiki/Zen_Meditation |

**Tank-mitigatie** (`:88-91`):
- Purifying Brew: OK.
- Celestial Brew 322507: TWIJFEL. Een Infusion-speler ziet hier een knop die hij niet heeft, want de lijst is ongefilterd.

### Ontbreekt
- **Celestial Infusion** (de keuzenode). Het id is niet geverifieerd, dus niet ingevuld. (BRON dat hij bestaat: wiki en IV)
- **Invoke Niuzao / Exploding Keg** horen niet in de tank-defensives; niet nodig.
- **Escape-rij:** Roll, Chi Torpedo, Tiger's Lust en Transcendence ontbreken allemaal op de kaart. (AFGELEID; IV WW noemt Roll en Tiger's Lust als mobiliteit)

---

## MONK — Windwalker (269)

### Wat de kaart toont (AFGELEID)
1. Touch of Karma — keepup
2. Fortifying Brew — hurts
3. Diffuse Magic — hurts, als de passieve naam nog resolvet
4. Expel Harm — heal
5. Vivify — heal
6. Spear Hand Strike — interrupt

"escape" is leeg.

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Touch of Karma | 122470 | keepup "VÓÓR de pull" (`:103`) | **FOUT** (BRON) | cd 1,5 min, 10 s. Method: gebruiken "prior to a large burst of damage" of bij lage health. Hoort bij "hurts". | https://warcraft.wiki.gg/wiki/Touch_of_Karma ; https://www.method.gg/guides/windwalker-monk/playstyle-and-rotation |
| Fortifying Brew | — | hurts | OK (BRON) | Een van de twee defensives van WW. | IV WW |
| Diffuse Magic | 122783 | hurts (`:105`, `category="defensive"`) | **FOUT** (BRON) | Sinds 12.0 een PASSIEF effect van Fortifying Brew, geen knop meer ("Windwalker only has 2 defensive"). Blijft IsPlayerSpell true als het talent gekozen is, dan staat er een knop op de kaart die niet bestaat (AFGELEID). | https://warcraft.wiki.gg/wiki/Diffuse_Magic ; IV WW |
| Expel Harm | 322101 | heal | OK (BRON) | +25% heal in 12.1 voor WW. | wiki Expel Harm |
| Vivify | 116670 | heal | OK (BRON) | +25% in 12.1. | IV WW |
| Spear Hand Strike | — | interrupt | OK (BRON) | — | wiki |
| Storm, Earth, and Fire | 137639 | `cooldown` (`:108`) | **FOUT** (BRON) | Verwijderd in 12.0.0, vervangen door **Zenith** (1249625, cd 1,5 min, 2 charges). | https://warcraft.wiki.gg/wiki/Storm,_Earth,_and_Fire ; https://warcraft.wiki.gg/wiki/Zenith |
| Invoke Xuen | 123904 | `cooldown_bar` (`:107`) | OK met kanttekening (BRON) | Nu alleen in de hero-boom Conduit of the Celestials; Shado-Pan-spelers hebben hem niet. Voor hen is de F1-toets leeg. | https://warcraft.wiki.gg/wiki/Invoke_Xuen,_the_White_Tiger |
| Chi Torpedo | 115008 | `utility_primary` {269} (`:100`) | TWIJFEL (AFGELEID) | Klassentalent, niet WW-only. Niet op de kaart. | — |

**DPS-cooldowns** (`DpsToolkit.lua:42`):

| spell | id | cd | verdict | bron |
|---|---|---|---|---|
| Invoke Xuen | 123904 | 120 | OK (BRON: 2 min) | wiki |
| **Storm, Earth, and Fire** | 137639 | 90 | **FOUT** (BRON): verwijderd. Wordt weggefilterd; de echte cooldown **Zenith 1249625 (90 s, 2 charges)** ontbreekt daardoor. | wiki Zenith |
| Fists of Fury | 113656 | 24 | TWIJFEL (bestaat; cd niet bevestigd) | — |
| Strike of the Windlord | 392983 | 35 | TWIJFEL (bestaat volgens IV; cd niet bevestigd) | IV WW |

**DPS_DEFENSIVES** (dood, `:86`):
- Dampen Harm 122278: **FOUT** (BRON). Niet meer voor WW sinds 11.0, helemaal verwijderd in 12.0.
- Fortifying Brew ontbreekt.

### Ontbreekt
- **Zenith** (1249625) als hoofd-cooldown. (BRON)
- **Touch of Death** staat als `cooldown` in de classifier (`:169`), maar niet in DPS_COOLDOWNS. IV noemt hem bij "Important Cooldowns". (BRON)
- **Celestial Conduit** (hero) en **Tigereye Brew**: IV "Important Cooldowns for Windwalker Monk". Ids niet geverifieerd. (BRON)
- **Escape-rij:** Roll, Chi Torpedo, Tiger's Lust, Flying Serpent Kick. IV: "nearly unparalleled mobility, allowing it to get out of dangerous situations". (BRON)

---

## MONK — Mistweaver (270) — healer

### Wat de kaart toont (AFGELEID)
1. Life Cocoon — keepup
2. Fortifying Brew — hurts
3. Vivify — heal. Expel Harm valt weg.

Er staat geen interrupt-rij (dat klopt) en geen escape-rij.

| spell | id | addon zegt | verdict | wat het moet zijn | bron |
|---|---|---|---|---|---|
| Life Cocoon | 116849 | keepup "VÓÓR de pull" (`:138`) | **FOUT** (BRON) | Externe absorb, cd 2 min, 12 s. IV: "Life Cocoon on someone if they are about to die". Mag op jezelf (Wowhead-commentaar), maar is geen altijd-aan-buff. Hoort in de healerlijst (staat er al) en hooguit onder "hurts". | https://warcraft.wiki.gg/wiki/Life_Cocoon ; https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-rotation-cooldowns-abilities ; https://www.wowhead.com/spell=116849 |
| Fortifying Brew | 243435 (healerlijst) | hurts | OK (BRON); id TWIJFEL | IV: "personal DR cooldown". Het id 243435 is niet onafhankelijk bevestigd. | IV MW |
| Expel Harm | 322101 | heal (baseline, `:165`) | **FOUT voor MW** (BRON) | Verwijderd voor MW in 12.0.0. De kaart filtert hem waarschijnlijk weg. Het commentaar `:62-64` zegt dit al, maar de entry is toch baseline gezet. | wiki Expel Harm; https://www.method.gg/guides/mistweaver-monk/introduction |
| Vivify | 116670 | heal | OK | — | — |
| (geen interrupt) | — | Spear Hand Strike {268,269} | OK (BRON) | "Mistweaver monks get Chi Warding instead." | wiki Spear Hand Strike |
| Essence Font | — (classifier `:130`), 231633 (core heals `HealerCooldowns.lua:186`) | `raid_heal` / core AoE-heal | **FOUT** (BRON) | Verwijderd in 11.0.0. De core-heal-lijst is ongefilterd, dus hij wordt getoond. | https://warcraft.wiki.gg/wiki/Essence_Font |
| Refreshing Jade Wind | — | `raid_heal` (`:131`) | **FOUT** (BRON) | Verwijderd in 12.0.0. | https://warcraft.wiki.gg/wiki/Refreshing_Jade_Wind ; IV MW |
| Zen Meditation | 115176 | `cooldown` (`:145`) + healerlijst | **FOUT** (BRON) | Geen MW-spell sinds 6.0; helemaal verwijderd in 11.2. | wiki Zen Meditation |
| Jadefire Stomp | — | `raid_heal` (`:132`) | TWIJFEL | IV MW noemt hem nog als talent; voor WW is hij verwijderd. | IV MW |
| Transcendence: Transfer | — | `utility_primary` {270} (`:136`) | TWIJFEL (AFGELEID) | Hoort bij alle specs; niet op de kaart. | — |

**Healer-cooldowns** (`HealerCooldowns.lua:120-126`, ongefilterd):

| spell | id | cd | verdict | bron |
|---|---|---|---|---|
| Revival | 115310 | 180 | OK/TWIJFEL. Keuzenode met **Restoral** (zelfde effect zonder dispel); een Restoral-speler ziet "Revival". | IV MW |
| Invoke Chi-Ji | 325197 | 120 | OK/TWIJFEL (bestaat, BRON; cd niet bevestigd) | IV / Method MW |
| Invoke Yu'lon | 322118 | 120 | OK/TWIJFEL (idem) | IV MW |
| Life Cocoon | 116849 | 120 | OK (BRON: 2 min) | wiki |
| **Zen Meditation** | 115176 | 300 | **FOUT** (BRON): geen MW-spell, en verwijderd | wiki |

**Healer-defensives** (`:230`, ongefilterd): **Dampen Harm 122278 is FOUT** (BRON: verwijderd voor MW in 11.0, voor iedereen in 12.0). Wordt getoond.

**Core heals** (`:181-187`):
- **Essence Font 231633 is FOUT** (zie boven).
- Soothing Mist, Vivify, Renewing Mist en Enveloping Mist zijn OK (BRON: IV noemt ze in 12.1).

### Ontbreekt
- **Restoral** als alternatief voor Revival. (BRON: IV; id niet geverifieerd)
- **Een AoE-core-heal** ter vervanging van Essence Font. Welke het beste past is niet vastgesteld (Sheilun's Gift en Jadefire Stomp staan elders); dat is een ontwerpkeuze.
- **Escape-rij:** Roll, Transcendence: Transfer, Tiger's Lust. (AFGELEID)

---

## Niveau- en talentvoorwaarden

- **Barkskin:** level 10 (BRON: wiki).
- **Talentspells:** Survival Instincts, Frenzied Regeneration, Heart of the Wild, Ironbark, Life Cocoon, Celestial Brew/Infusion, Diffuse Magic en Zenith zijn talenten. De kaart toont ze alleen als ze gekozen zijn; dat is correct.
- **Hero-talenten:** Invoke Xuen en Celestial Conduit zijn hero-talenten. Vanaf welk level die in Midnight openen heb ik niet vastgesteld.
- **Keuzenodes** waarbij de kaart of lijst de verkeerde helft kan tonen:
  - Celestial Brew ↔ Celestial Infusion
  - Revival ↔ Restoral
  - Bristling Fur ↔ Reinforced Fur

  De ongefilterde tank- en healerlijsten tonen altijd de helft die in de data staat.

---

## Structurele oorzaken

1. **`defensive_1` betekent overal "zet aan vóór de pull".**
   - Waar: `SurvivalPlan.lua:76`, met de tekst in `enUS.lua:810`.
   - In de classifiers betekent `defensive_1` alleen "de Z-toets, kleine defensive". Het zegt niets over een onderhouden buff.
   - Gevolg: elke spell op Z krijgt fout advies. Barkskin (`KeybindRoles_Druid.lua:209`), Ironbark (`:188`), Celestial Brew (`KeybindRoles_Monk.lua:83`), Touch of Karma (`:103`) en Life Cocoon (`:138`) zijn alle vijf cooldown-knoppen en geen enkele is een altijd-aan-buff.
   - Het enige echte "keep up" in deze twee klassen, **Ironfur**, staat juist onder "hurts" (`KeybindRoles_Druid.lua:143`).
2. **`category="defensive"` wordt als "health drops fast" gelezen.**
   - Waar: `SurvivalPlan.lua:77-78`.
   - Die categorie bevat ook actieve mitigatie (Ironfur `:143`, Purifying Brew `Monk:78`), een Rage-generator (Bristling Fur `:155`) en een inmiddels passief talent (Diffuse Magic `Monk:105`).
3. **Er is geen veld "alleen op een ander" of "vooral extern".**
   - Ironbark en Life Cocoon komen daardoor als self-survival op de kaart.
   - Beide kunnen op jezelf, maar een beginner leert zo de verkeerde bestemming.
   - Een expliciet `survival=`-veld (`SurvivalPlan.lua:60-74`) bestaat, maar is voor Druid en Monk nooit ingevuld.
4. **Escape leest alleen `role="mobility"`.**
   - Waar: `SurvivalPlan.lua:81`.
   - Monk heeft die rol nergens, dus drie Monk-specs krijgen geen escape-rij.
   - Druid krijgt alleen Travel Form (`:207`). Dash, Tiger Dash, Wild Charge, Stampeding Roar, Roll, Chi Torpedo en Tiger's Lust staan op `utility_primary/secondary` en ontbreken.
5. **De heal-stap slaat `click_cast` over.**
   - Waar: `SurvivalPlan.lua:79-80`.
   - Regrowth staat alleen onder {105} als `click_cast` (`KeybindRoles_Druid.lua:182`). Samen met de verwijderde Renewal (`:211`) hebben Resto en Balance **geen enkele** self-heal op de kaart.
6. **`AppliesTo` behandelt "geen specs" als "alle specs"; scoping is met de hand gedaan.**
   - Waar: `SurvivalPlan.lua:96-106`.
   - Te breed: Expel Harm is baseline (`Monk:165`), maar MW heeft hem niet meer.
   - Te smal: Heart of the Wild is alleen {104} (`Druid:150`), maar is een klassentalent. Tiger Dash is alleen {102} (`:115`), Chi Torpedo alleen {269} (`Monk:100`), Transfer alleen {270} (`Monk:136`).
7. **De sortering is een keybind-prioriteit, geen gevechtsvolgorde.**
   - Waar: `SurvivalPlan.lua:351-357`.
   - `priority` komt uit de toets-toewijzing. Bij gelijke waarde beslist het alfabet (Ironfur vóór Survival Instincts).
   - Er is geen regel "klein en vaak eerst, groot en zeldzaam laatst".
8. **De tank- en healerlijsten filteren niet op IsPlayerSpell; de DPS-lijst wel.**
   - Ongefilterd: `RoleAcademy.lua:468-505` en `:556-582`.
   - Gefilterd: `:636-654`.
   - Daardoor worden verwijderde spells getoond: Dampen Harm (`TankToolkit.lua:121`, `HealerCooldowns.lua:230`), Zen Meditation (`TankToolkit.lua:122`, `HealerCooldowns.lua:125`), Essence Font (`HealerCooldowns.lua:186`) en Renewal (`HealerCooldowns.lua:228`).
   - Ook de verkeerde helft van een keuzenode wordt getoond.
9. **De data komt uit JustAC en ClassCodex (TWW-tijdperk), niet uit 12.x-bronnen.**
   - Zie de bronnenblokken: `KeybindRoles_Druid.lua:24-50`, `KeybindRoles_Monk.lua:19-49`, `HealerCooldowns.lua:152-154` en `:222-225`, `DpsToolkit.lua:7-11`.
   - Gevolg: verwijderde spells (Renewal, Rage of the Sleeper, Weapons of Order, SEF, Dampen Harm, Diffuse Magic als knop, Zen Meditation, Essence Font, Refreshing Jade Wind, Cenarion Ward) en een covenant-id (Convoke 323764 in `HealerCooldowns.lua:108`) staan er nog in.
   - Het Monk-bestand noemt twee van deze problemen zelf al in de NEVER-LIE-notities (`:62-67`), maar kiest toch de oude data.
10. **De "wanneer"-tekst hoort per rol, niet per spell.**
    - Waar: `SurvivalPlan.lua:33-35`.
    - Die keuze maakt fouten 1-3 onvermijdelijk zolang de rollen voor keybinds bedoeld zijn en niet voor gevechtsgebruik.
