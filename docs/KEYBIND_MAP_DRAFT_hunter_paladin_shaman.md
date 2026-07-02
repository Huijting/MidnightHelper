# Keybind-maps (v6 toegepast, CONCEPT) — Hunter (MM/SV), Paladin (Holy/Prot), Shaman (Ele/Resto)

> ⚠️ **Update 2026-07-02 (ná dit draft):** F2/F3/F4 zijn **heal-ankers** geworden
> (F2 = snelle combat-heal — bv. Exhilaration/Healing Surge, F3 = out-of-combat-heal,
> F4 = recuperate/HoT). Utility-slots zijn nu F/R/T/X + overflow. Herzien bij encoderen.

Standaard: `docs/KEYBIND_STANDARD_v6.md`. Template/formaat: zie
`docs/KEYBIND_MAP_frost-mage_enh-shaman.md`. Kit-research: web (Icy Veins 12.0.7-guides +
Wowhead spell-pagina's), juli 2026. Beast Mastery, Retribution en Enhancement bestaan al
elders (`Modules/KeybindingData.lua`, `KEYBIND_MAP_frost-mage_enh-shaman.md`) — **niet
opnieuw gedaan**, wel als anker voor gedeelde class-utility (zelfde toets bij overlap).

**Labels:** 🟡 = ID gevonden via web-bron (Wowhead spell-URL) maar **nog niet in-game
bevestigd** · ⚠️ = ID niet gevonden — **"ID onbekend, in-game dumpen"**. Geen enkel ID in dit
document is verzonnen; alles is ofwel een 🟡 web-hit ofwel expliciet ⚠️.

> **Belangrijke caveat (never-lie):** Icy Veins' 12.0.7-guides geven de actuele kit/rotation-
> tekst maar **bevatten geen spell-ID's** (alleen icon-plaatjes). ID's komen daarom uit losse
> Wowhead spell-zoekopdrachten; sommige Wowhead-URL's tonen een "huidige retail"-ID die
> **niet expliciet gedateerd is op 12.0.7/Midnight**. Dat betekent: de meeste ID's hieronder
> zijn zeer waarschijnlijk correct (het zijn kern-abilities die al lang bestaan), maar géén
> ervan is een in-game tooltip-check. Behandel alles als 🟡 tot Rob/Cisca in-game bevestigen.
> Voor een aantal **Midnight-nieuwe** abilities (Takedown, Boomstick, Beacon of the Savior,
> Glory of the Vanguard, Stormstream Totem e.d.) is wél een Midnight-specifieke Wowhead-pagina
> gevonden — dat verhoogt vertrouwen, maar blijft 🟡.

Ankers (alle 6 specs, verplaatsen nooit): **E**=interrupt · **Q**=movement · **Z**=kleine def ·
**C**=grote def · **V**=dispel/CC · **F1**=grote cooldown · **Shift+E**=racial · **Ctrl+F1**=trinket ·
**Alt+C**=potion (laatste drie niet per spec herhaald). Overflow = zelfde toets, volgende
modifier (**Shift→Ctrl→Alt**). Healers (Holy Paladin, Resto Shaman): ST-heals via
mouseover/Click Cast Bindings, niet op toetsen (§6 standaard) — 1/2/4 etc. zijn hier AoE-heal/
damage/utility, net als bij DPS-specs.

---

## 🏹 Marksmanship Hunter

Hero talent: **Dark Ranger** (Icy Veins-aanbeveling voor single-target; AoE-build voegt Volley/
Explosive Shot toe — zelfde toetsen, want AoE = Shift-tweeling). Kit is in Midnight
gestroomlijnd (minder buttons dan TWW): Aimed Shot/Rapid Fire builders, Arcane Shot/Kill Shot/
Black Arrow spenders, Trueshot = grote cooldown.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Aimed Shot | 19434 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Hunter guide.lua — "Aimed Shot") | Builder (Focus-spender, blijft op cooldown) |
| **2** | Rapid Fire | 257044 🟢 (addon-data: ClassCodex Hunter guide.lua — "Rapid Fire", MM-rotatie) | Builder (channel, bouwt Bulletstorm) |
| **3** | Wailing Arrow *(Dark Ranger Trueshot-vervanger)* | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | Builder (proc't Black Arrow, 1x per Trueshot) |
| **4** | Arcane Shot | 185358 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Hunter guide.lua — "Arcane Shot") | Spender (Precise Shots) |
| **5** | Black Arrow *(Dark Ranger)* | 194599 🟢 (addon-data: JustAC SpellArchetypes.lua — "Black Arrow") ⚠️ let op: JustAC bevat óók Midnight-varianten 466930/466932/468037 als "Black Arrow"; ClassCodex MM-rotatie gebruikt 466932 als primaire Black-Arrow-spender — in-game verifiëren welke variant Dark Ranger cast | Spender (Precise Shots, Dark Ranger) |
| **Shift+1** | Multi-Shot | 2643 🟢 (addon-data: JustAC SpellArchetypes.lua — "Multi-Shot") | AoE (Precise Shots, Trick Shots) |
| **Shift+2** | Volley | 260247 🟢 (addon-data: JustAC SpellArchetypes.lua — "Volley") ⚠️ let op: ClassCodex MM-rotatie gebruikt 260243 voor Volley (MM-variant); 260247 kan BM-variant zijn — in-game verifiëren | AoE cooldown |
| **Shift+3** | Explosive Shot *(Dark Ranger AoE-filler)* | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | AoE (laag-prioriteit filler) |
| **E** | Counter Shot | 147362 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua — "Counter Shot") | Interrupt |
| **Q** | Disengage | 781 🟢 (addon-data: ClassCodex Hunter guide.lua — pre-pull, "{190925} (or {781})") | Movement |
| **Z** | Exhilaration | 109304 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua — "Exhilaration") | Kleine defensive (self + pet heal) |
| **C** | Aspect of the Turtle | 186265 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Aspect of the Turtle") | Grote defensive (immune) |
| **V** | Tranquilizing Shot | 19801 🟢 (addon-data: JustAC SpellCategories.lua — "Tranquilizing Shot") | Dispel (enrage/magic) |
| **F1** | Trueshot | 288613 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua + JustAC SpellDB.lua — "Trueshot") | Grote cooldown (burst) |
| **F** | Kill Shot | 320976 🟢 (addon-data: JustAC SpellArchetypes.lua + SpellDB.lua — "Kill Shot") | Utility (execute, <20%) |
| **R** | Hunter's Mark | ⚠️ ID onbekend — in-game dumpen | Utility (marker, alleen genoemd als pre-pull-vereiste) |

~16 binds. **Let op:** Moonlight Chakram (Sentinel-alternatief voor Trueshot-slot) niet
meegenomen — Cisca/Rob spelen Dark Ranger per Icy Veins-aanbeveling. Geen Scatter Shot/
Intimidation/Freezing Trap/Misdirection/Flare in de 12.0.7-rotation-tekst aangetroffen (mogelijk
nog steeds in spellbook maar niet in de kern-rotatie-gids); die zijn hier bewust weggelaten in
plaats van gegokt — als ze wél gewenst zijn, komen ze op overflow (Shift+F/Shift+R of F2).

---

## 🏕️ Survival Hunter

Hero talent: **Pack Leader** (Icy Veins: exclusief aanbevolen, beter dan Sentinel in alle
schade-categorieën). **Kit fors herzien in Midnight** — Mongoose Bite, Coordinated Assault,
Butchery, Flanking Strike, Explosive Shot, Lunge, Carve, Spearhead **bestaan niet meer** in de
12.0.7-rotatiegids; **Takedown** is de nieuwe hoofd-cooldown, **Boomstick** een nieuwe ranged
filler.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Kill Command | 34026 🟢 (addon-data: ClassCodex Hunter guide.lua — "Kill Command", SV-rotatie) | Builder (Focus-spender, "always tip") |
| **2** | Raptor Strike *(elke 2e cast → Raptor Swipe, AoE)* | 186270 🟢 (addon-data: JustAC SpellArchetypes.lua + RangeReferences.lua — "Raptor Strike") | Builder (melee spender) |
| **3** | Wildfire Bomb | 259495 🟢 (addon-data: ClassCodex Hunter guide.lua — "Wildfire Bomb", SV-rotatie) | Builder (directe schade + DoT, Tip of the Spear) |
| **4** | Boomstick *(nieuw, Midnight)* | 1261193 🟢 (addon-data: ClassCodex Hunter guide.lua — SV-rotatie-filler) | Spender (ranged filler, on cooldown) |
| **5** | Flamefang Pitch *(talent)* | 1251592 🟢 (addon-data: ClassCodex Hunter guide.lua — hero-talent-conditie "Flamefang Pitch") | Spender (los van Tip of the Spear) |
| **Shift+2** | Raptor Swipe *(auto-upgrade, geen losse knop nodig — zie R als alternatief)* | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | AoE (cleave-variant van Raptor Strike) |
| **Shift+3** | Wildfire Bomb (AoE-gebruik) | 259495 🟢 (zelfde ability als **3**; addon-data: ClassCodex Hunter guide.lua) | AoE |
| **E** | Muzzle | 187707 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua — "Muzzle") | Interrupt |
| **Q** | Harpoon | 190925 🟢 (addon-data: JustAC SpellDB.lua "Harpoon" + ClassCodex Hunter guide.lua) | Movement (engage/pull naar target) |
| **Shift+Q** | Disengage | 781 🟢 (addon-data: ClassCodex Hunter guide.lua — "{190925} (or {781})") | Movement (retreat; gedeeld met MM) |
| **Z** | Exhilaration | 109304 🟢 (addon-data: JustAC SpellCategories.lua — "Exhilaration") | Kleine defensive (gedeeld met MM) |
| **C** | Aspect of the Turtle | 186265 🟢 (addon-data: JustAC SpellCategories.lua — "Aspect of the Turtle") | Grote defensive (gedeeld met MM) |
| **Shift+C** | Survival of the Fittest | 264735 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Survival of the Fittest") | Defensive (extra, 30% DR) |
| **V** | Wing Clip | 195645 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | CC (snare; SV heeft geen trap-achtige stun in de 12.0.7-tekst gevonden) |
| **F1** | Takedown *(nieuw, Midnight — hoofd-cooldown)* | 1250646 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — "Takedown", spec=HUNT_SV) | Grote cooldown (burst, ~90s) |
| **F** | Howl of the Pack Leader *(proc, geen losse activatie — placeholder)* | ⚠️ ID onbekend — in-game dumpen | Utility (Pack Leader hero-talent, buff-proc) |

~15 binds. **Opvallend:** dit is het kortste kit van de 6 specs — Midnight's "button bloat"-
reductie is hier het duidelijkst zichtbaar (Icy Veins-rotatiepagina noemt zelf nog maar 7 kern-
knoppen). Interrupt/defensives/movement/CC zijn **niet** in de Icy Veins-rotatietekst genoemd
(behalve Harpoon/Disengage/Misdirection in de opener) — hierboven ingevuld met de bekende
class-brede Hunter-utility (zelfde ID's als MM) zodat de v6-ankers gevuld zijn; **in-game
bevestigen of deze abilities nog steeds bestaan voor Survival specifiek is noodzakelijk.**

---

## ✝️ Holy Paladin

Kit fors vereenvoudigd in Midnight: **Crusader Strike is verwijderd**, meer nadruk op Holy
Shock + Infusion of Light (10% kans op instant/versterkte Flash of Light). Apex-talent: **Beacon
of the Savior** (nieuwe Beacon, auto op laagste HP-ally). Healer-overlay (§6): ST-heals via
mouseover/Click Cast, **niet** op onderstaande toetsen — dit zijn AoE-heal/utility/damage-knoppen.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Holy Shock | 20473 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Paladin guide.lua — "Holy Shock") | Builder (Holy Power + directe heal/damage, spam) |
| **2** | Flash of Light | 19750 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Paladin guide.lua — "Flash of Light") | Builder (filler heal, instant bij Infusion of Light) |
| **3** | Holy Light | 82326 🟢 (addon-data: JustAC SpellCategories.lua — "Holy Light") | Builder (grote maar dure heal) |
| **4** | Word of Glory | 85673 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua — "Word of Glory") | Spender (Holy Power, single-target) |
| **5** | Light of Dawn | 85222 🟢 (addon-data: JustAC SpellCategories.lua + SpellArchetypes.lua — "Light of Dawn") | Spender (Holy Power, AoE-heal) |
| **Shift+5** | Light of Dawn *(zelfde knop, al AoE — geen aparte Shift-tweeling nodig)* | — | — |
| **E** | Rebuke | 96231 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua — "Rebuke") | Interrupt |
| **Q** | *(geen dedicated movement-spell in Holy-kit gevonden)* | ⚠️ ID onbekend — in-game dumpen (mogelijk Divine Steed/talent; geen addon-data) | Movement |
| **Z** | Divine Shield | 642 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Divine Shield") | Kleine defensive (immune, persoonlijk) |
| **C** | Guardian of Ancient Kings | 86659 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Guardian of Ancient Kings") | Grote defensive (50% DR, 8s) |
| **V** | Cleanse | 4987 🟢 (addon-data: JustAC SpellCategories.lua — "Cleanse") | Dispel (poison/disease/magic) |
| **F1** | Avenging Wrath | 31884 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua + OffensiveCDAlert.lua — "Avenging Wrath") | Grote cooldown (burst-heal/damage) |
| **Shift+F1** | Aura Mastery | 31821 🟢 (addon-data: JustAC SpellCategories.lua — "Aura Mastery") | Grote cooldown (raid-defensive) |
| **F** | Blessing of Protection | 1022 🟢 (addon-data: JustAC SpellCategories.lua — "Blessing of Protection") | Utility (physical immunity, ally) |
| **R** | Divine Toll | 304971 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | Utility (instant Holy Power burst, AoE-heal) |

~13 binds — kort, want Holy verliest Crusader Strike en de rotatie is sterk Holy-Shock-
gecentreerd. **Beacon of the Savior** (Apex-talent, automatische Beacon-plaatsing) is passief —
geen eigen toets nodig. Movement-anker **Q** kon niet met een bevestigde spell-ID gevuld worden;
Paladin heeft van oudsher geen dash tenzij via Speed of Light/Long Arm of the Law (talenten) of
het generieke Divine Steed (racial-achtig, automatisch bij low-HP) — **in-game controleren welke
(indien enige) losse movement-knop Holy in Midnight nog heeft.**

---

## 🛡️ Protection Paladin

Rotatie: Holy Power genereren (Hammer of Wrath / Judgment / Avenger's Shield bij Vanguard-proc /
Hammer of the Righteous) → spenderen op Shield of the Righteous, Consecration on-cooldown.
Apex-talent: **Glory of the Vanguard** (uitbreidt Avenger's Shield via Judgment-proc). Midnight:
Hammer of Wrath nu passief (vervangt Judgment tijdens Avenging Wrath), Eye of Tyr verwijderd,
Guardian of Ancient Kings nu 3-min cooldown.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Judgment | 20271 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Paladin guide.lua — "Judgment") | Builder (Holy Power, gedeeld ID met Ret's "2") |
| **2** | Avenger's Shield | 31935 🟢 (addon-data: JustAC InterruptAbilities.lua + SpellArchetypes.lua — "Avenger's Shield") | Builder (ranged, Vanguard-proc via Judgment) |
| **3** | Hammer of the Righteous *(of Blessed Hammer, talent-keuze)* | 88263 🟢 / 204019 🟢 (addon-data: JustAC SpellArchetypes.lua — "Hammer of the Righteous" resp. "Blessed Hammer") | Builder (Holy Power, AoE-cleave inherent) |
| **4** | Shield of the Righteous | 53600 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Paladin guide.lua — "Shield of the Righteous") | Spender (Holy Power → block/mitigatie) |
| **5** | Hammer of Wrath *(nu passief tijdens Avenging Wrath — mogelijk geen losse knop)* | 24275 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Paladin guide.lua — "Hammer of Wrath") | Spender (execute-range, of passief-vervanger van Judgment) |
| **Shift+2** | Avenger's Shield (AoE-treffer, geen aparte AoE-versie — zelfde knop) | — | — |
| **E** | Rebuke | 96231 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua — "Rebuke") | Interrupt (gedeeld met Holy) |
| **Q** | *(geen dedicated movement-spell gevonden — Protection heeft doorgaans geen dash)* | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | Movement |
| **Z** | Divine Shield | 642 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Divine Shield") | Kleine defensive (gedeeld met Holy) |
| **C** | Guardian of Ancient Kings | 86659 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Guardian of Ancient Kings") | Grote defensive (nu 3 min CD in Midnight) |
| **V** | Cleanse | 4987 🟢 (addon-data: JustAC SpellCategories.lua — "Cleanse") | Dispel (gedeeld met Holy) |
| **F1** | Avenging Wrath | 31884 🟢 (addon-data: BliZzi_Interrupts PartyCooldowns.lua — "Avenging Wrath") | Grote cooldown (burst, gedeeld met Holy) |
| **Shift+F1** | Divine Toll | 304971 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | Grote cooldown (instant Holy Power burst) |
| **F** | Consecration | 26573 🟢 (addon-data: ClassCodex Paladin guide.lua — "Consecration", Prot-rotatie) | Utility (ground AoE, on-cooldown houden) |
| **R** | Hand of Reckoning | 62124 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Paladin guide.lua — "Hand of Reckoning") | Utility (taunt) |
| **X** | Blessing of Protection | 1022 🟢 (addon-data: JustAC SpellCategories.lua — "Blessing of Protection") | Utility (party-safety, gedeeld met Holy) |

~15 binds. **Ret Paladin** (bestaande map) gebruikt Judgment al op **2** met dezelfde ID
(20271) — hier op **1** omdat Prot's builder-prioriteit anders is (Judgment eerst voor Vanguard-
proc); overlappende class-utility (Rebuke, Divine Shield, Cleanse, Avenging Wrath, Blessing of
Protection) staat consistent op dezelfde toets als Holy hierboven. Movement-anker **Q** net als
bij Holy niet ingevuld — Protection heeft van oudsher geen eigen gap-closer/dash.

---

## ⚡ Elemental Shaman

Kern: Voltaic Blaze (instant Flame Shock + garandeert Lava Burst-crit) → Lava Burst on-cooldown
bij Lava Surge-proc → Earth Shock als Maelstrom bijna vol. Stormkeeper pre-pull. Tier-set voegt
geen nieuwe knop toe (extra Stormkeeper-charge). Veel ankers **gedeeld met Enhancement Shaman**
(zelfde class-utility: Wind Shear, Astral Shift, Ghost Wolf, Spirit Walk, Hex, Purge, Capacitor
Totem, Tremor Totem) — hieronder bewust identiek gehouden.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Lava Burst | 51505 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Shaman guide.lua — "Lava Burst") | Builder (Lava Surge-proc, gegarandeerde crit) |
| **2** | Voltaic Blaze | 470057 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Shaman guide.lua — "Voltaic Blaze") | Builder (instant Flame Shock, filler) |
| **3** | Earth Shock | 8042 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Shaman guide.lua — "Earth Shock") | Builder/Spender (Maelstrom-dump) |
| **4** | Lightning Bolt | 188196 🟢 (addon-data: JustAC SpellArchetypes.lua + RangeReferences.lua — "Lightning Bolt") | Spender (filler, gedeeld ID met Enh's "4") |
| **5** | Flame Shock | 188389 🟢 (addon-data: JustAC SpellArchetypes.lua — "Flame Shock") | Spender (DoT-onderhoud, los indien geen Voltaic Blaze) |
| **Shift+1** | Chain Lightning | 188443 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Shaman guide.lua — "Chain Lightning") | AoE |
| **Shift+3** | Earthquake | 61882 🟢 (addon-data: JustAC SpellArchetypes.lua + ClassCodex Shaman guide.lua — "Earthquake") | AoE (Maelstrom-dump, AoE-variant van Earth Shock) |
| **E** | Wind Shear | 57994 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua — "Wind Shear") | Interrupt (gedeeld met Enh) |
| **Q** | Spirit Walk | 58875 🟢 (addon-data: JustAC SpellDB.lua — "Spirit Walk") | Movement (gedeeld met Enh) |
| **Shift+Q** | Ghost Wolf | 2645 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | Movement (travel, gedeeld met Enh) |
| **Z** | *(geen dedicated self-heal in Ele-kit — Healing Surge is generiek Shaman)* | 8004 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua — "Healing Surge") | Kleine defensive (self-heal, gedeeld ID met Resto) |
| **C** | Astral Shift | 108271 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Astral Shift") | Grote defensive (gedeeld met Enh) |
| **V** | Hex | 51514 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts Core/Data.lua — "Hex") | CC (gedeeld met Enh) |
| **Shift+V** | Purge | 370 🟢 (addon-data: JustAC SpellCategories.lua — "Purge") | Dispel (gedeeld met Enh) |
| **F1** | Fire Elemental | 198067 🟢 (addon-data: JustAC SpellDB.lua — "Fire Elemental") | Grote cooldown (pet-cooldown) |
| **Shift+F1** | Stormkeeper | 191634 🟢 (addon-data: JustAC SpellArchetypes.lua + BliZzi_Interrupts OffensiveCDAlert.lua — "Stormkeeper") | Grote cooldown (buff, pre-pull) |
| **F** | Lightning Lasso | 204437 🟢 (addon-data: JustAC SpellArchetypes.lua — "Lightning Lasso") | Utility (ranged stun/root) |
| **T** | Capacitor Totem | 192058 🟢 (addon-data: JustAC InterruptAbilities.lua + SpellCategories.lua + BliZzi_Interrupts Core/Data.lua — "Capacitor Totem") | CC (AoE stun, gedeeld met Enh) |
| **X** | Tremor Totem | 8143 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | Utility (gedeeld met Enh) |
| **Shift+F2** | Bloodlust / Heroism | 2825 🟢 / 32182 🟢 (addon-data: JustAC SpellCategories.lua — "Bloodlust" resp. "Heroism") | Raid-haste (gedeeld met Enh; faction-afhankelijk) |

~19 binds. **Apex-talent** voor Elemental niet met zekerheid geïdentificeerd in de web-research
(Icy Veins noemde Ancestral Guidance/Elemental Orbit niet expliciet als Apex — die twee ID's
(114911, 383010) zijn hier daarom **niet** in de tabel opgenomen; als Ele een Apex-talent-knop
nodig heeft, ⚠️ in-game controleren welke dat is en op welke overflow-toets (bv. F2) hij moet.

---

## 🌊 Restoration Shaman

Midnight-reductie fors merkbaar: **Cloudburst Totem, Earthen Wall Totem, Ancestral Protection
Totem en Wellspring zijn verwijderd** — Resto verliest bijna de helft van de actieve knoppen en
tijdelijke buffs. Kern: Riptide/Unleash Life/Healing Rain zoveel mogelijk on-cooldown, Healing
Wave/Chain Heal als mana-filler. Apex-talent: **Stormstream Totem** (+30% Healing Stream/
Stormstream-heal). Healer-overlay (§6): ST-heals via mouseover/Click Cast — onderstaand zijn
AoE-heal/cooldown/utility-knoppen, net als Holy Paladin.

| Toets | Ability | ID | Categorie |
|------|---------|----|-----------|
| **1** | Riptide | 61295 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Shaman guide.lua — "Riptide") | Builder (HoT + instant heal, on-cooldown) |
| **2** | Chain Heal | 1064 🟢 (addon-data: ClassCodex Shaman guide.lua — "Chain Heal", Resto-rotatie) | Builder (multi-target filler) |
| **3** | Healing Wave | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | Builder (mana-efficiënte filler) |
| **4** | Unleash Life | 73685 🟢 (addon-data: ClassCodex Shaman guide.lua — "Unleash Life", Resto-rotatie) | Spender (buff volgende cast + Ancestor-proc) |
| **5** | Healing Rain | 73920 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Shaman guide.lua — "Healing Rain") | Spender (ground-AoE heal) |
| **Shift+2** | Chain Heal (al multi-target, geen aparte AoE-knop nodig) | — | — |
| **E** | Wind Shear | 57994 🟢 (addon-data: JustAC InterruptAbilities.lua + BliZzi_Interrupts Core/Data.lua "Wind Shear" [Resto/spec 264: 30s CD]) | Interrupt (gedeeld met Enh/Ele) |
| **Q** | Spirit Walk | 58875 🟢 (addon-data: JustAC SpellDB.lua — "Spirit Walk") | Movement (gedeeld met Enh/Ele) |
| **Shift+Q** | Ghost Wolf | 2645 🟡 (geen addon-data — niet in spell-tabellen aangetroffen) | Movement (travel, gedeeld) |
| **Z** | Healing Surge | 8004 🟢 (addon-data: JustAC SpellCategories.lua + SpellDB.lua — "Healing Surge") | Kleine defensive (snelle self/ally-heal, gedeeld met Enh) |
| **C** | Astral Shift | 108271 🟢 (addon-data: JustAC SpellCategories.lua + BliZzi_Interrupts PartyCooldowns.lua — "Astral Shift") | Grote defensive (gedeeld met Enh/Ele) |
| **V** | Purify Spirit | ⚠️ ID onbekend — in-game dumpen (geen addon-data; Resto krijgt "Improved Purify Spirit" i.p.v. Cleanse Spirit 51886 volgens bron) | Dispel (curse/magic) |
| **F1** | Healing Tide Totem | ⚠️ ID onbekend — in-game dumpen (geen addon-data) | Grote cooldown (raid-heal-burst) |
| **Shift+F1** | Ascendance | 114049 🟡 (geen directe addon-data voor 114049; ⚠️ let op: JustAC SpellDB.lua noemt Elemental-Ascendance = **114050** — 114049 zou de Restoration-variant zijn (spec-variant), maar niet addon-bevestigd — in-game verifiëren) | Grote cooldown (heal-duplicatie) |
| **F** | Healing Stream Totem | 5394 🟢 (addon-data: JustAC SpellCategories.lua + ClassCodex Shaman guide.lua — "Healing Stream Totem") | Utility (passieve group-heal, on-cooldown) |
| **R** | Spirit Link Totem | 98008 🟢 (addon-data: JustAC SpellCategories.lua — "Spirit Link Totem") | Utility (HP-verdeling, raid-CD) |
| **T** | Ancestral Spirit | 2008 🟢 (addon-data: JustAC SpellCategories.lua — "Ancestral Spirit") | Utility (out-of-combat rez; **geen** combat-rez gevonden — Midnight heeft mogelijk aparte brez, ⚠️ controleren) |

~16 binds. **Kritiek punt:** Healing Tide Totem (grote raid-cooldown, normaal een kernknop voor
Resto) kon **niet** met een bevestigde ID gevonden worden in deze research-ronde — expliciet
⚠️ i.p.v. gegokt. Combat-rez (Ancestral Spirit is out-of-combat-only volgens bron) is een gat:
Resto Shaman had in eerdere patches vaak geen eigen brez, dus dit kan kloppen, maar **in-game
bevestigen.**

---

## Samenvatting / bronnen

**Web-bronnen (research, juli 2026):**
- Icy Veins — Marksmanship/Survival Hunter, Holy/Protection Paladin, Elemental/Restoration
  Shaman DPS/Healing/Tank rotation+abilities-pagina's (12.0.7): https://www.icy-veins.com/wow/
  (per-spec paden, zie individuele zoekopdrachten hierboven — Icy Veins bevat **geen**
  spell-ID's, alleen kit-beschrijvingen)
- Wowhead — losse spell-pagina's per ability (ID's uit URL, bv.
  https://www.wowhead.com/spell=19434/aimed-shot ). Voor Survival Hunter en Restoration Shaman
  Apex-content: Wowhead Midnight class-guides (https://www.wowhead.com/guide/classes/...)
- Method.gg — Elemental Shaman + Holy Paladin guide-intro's (talent/hero-talent-keuzes):
  https://www.method.gg/guides/elemental-shaman , https://www.method.gg/guides/holy-paladin

**Never-lie status:** geen enkel spell-ID in dit document is verzonnen. Alles is 🟡 (Wowhead-
URL gevonden, datum/patch niet expliciet Midnight-bevestigd tenzij vermeld) of ⚠️ (expliciet
niet gevonden). **Alle 🟡's + ⚠️'s moeten door Rob/Cisca in-game (tooltip/`/dump`) bevestigd
worden voordat dit doc naar `Modules/KeybindingData.lua` wordt overgezet** — zie werkwijze in
`docs/KEYBIND_MAP_frost-mage_enh-shaman.md` §"Volgende stap".

## Volgende stap
1. In-game bevestigen: alle 🟡-ID's (tooltip/`/dump C_Spell.GetSpellInfo(id)`) + alle ⚠️-gaten
   opvullen (vooral: Wailing Arrow, Volley/Explosive Shot MM, Flamefang Pitch, Howl of the Pack
   Leader-activatie, Paladin movement-anker Q, Ele Apex-talent, Healing Wave/Purify Spirit/
   Healing Tide Totem Resto).
2. Pas daarna encoderen in `Modules/KeybindingData.lua` (nieuwe `slotsHunterMM`/`slotsHunterSV`/
   `slotsPaladinHoly`/`slotsPaladinProt`/`slotsShamanEle`/`slotsShamanResto` — zelfde patroon als
   `slotsMage`/`slotsShaman` nu voor Frost Mage/Enhancement).
3. Deze 6 specs niet mengen met de bestaande BM Hunter/Ret Paladin/Enh Shaman-kolommen in
   `KeybindingReference.columns` zonder overleg — apart controleren of het datamodel generiek
   genoeg is (zelfde open punt als in de Frost Mage/Enh Shaman-map genoteerd).
