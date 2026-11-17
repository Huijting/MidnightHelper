# Camping in WoW Forever — onderzoek 17 nov 2026 (overgenomen uit het bericht van Sparring 17-11)

Onderzoek door mh-research (Opus, alleen gelezen; docs/ niet gelezen) in de sessie van Sparring 17-11, letterlijk
overgezet door de bouwchat zodat het niet in een chat verdwijnt. **Niet door de bouwchat nagemeten.** ⚠️ Dit bestand
bestond al (korte versie, in git); Sparring en de bouwchat vonden het allebei NIET met Glob en dachten dat het ontbrak.
Op 17 nov vervangen door de volledige tekst; de oude versie had dezelfde feiten, korter (GEMETEN in de git-diff).
Les: een lege Glob bewijst niets zonder positieve controle (silence-is-not-absence).

Rob, letterlijk (via sparring): *"We hebben tegenwoordig kampvuurs waarbij je allerlei power-ups, hoe noem je dat,
tijdelijke buffs kan krijgen. Onder andere bij een campchair, een sharpening wheel, incense candle, manual, lodestone en
fishbowl."* Op het onderzoek: *"Ja, het zal vast mana wel zijn. En dat kampvuuridee moeten we ook gaan bouwen."*

Bronnen: Blizzard News "Gather Around the Campfire in World of Warcraft: Forever" (21 okt 2026) + Deep Dive recap
(13 sep 2026) + Blizzard Hotfixes 9, 10, 16 nov; Wowhead Forever-gids "Camping Overview in Forever" (Serenal, bijgewerkt
13 nov 2026) + Wowhead spellpagina's + tooltip-JSON opgehaald 17 nov (1229741, 1229513, 1229739, 1229451, 1283391,
1230164, 1229519); Wowhead News 22 sep; bindonforever.com/camping (build 70888); wow-forever.gg; Hearthproof; Spoken
QuestText.lua r.17332-17502 + Compendium.lua r.4562-4706 (E:\World of Warcraft\_forever_\Interface\AddOns\Spoken_Quests\Data\);
Zygor ZygorLevelingAllianceCLASSICTrial.lua r.400-430.

## 1. Systeem
- Spel: WoW Forever, niet retail 12.1. GEMETEN (Blizzard 21 okt, 13 sep).
- Quests heten "Camping 101: <beroep>". GEMETEN (Spoken Compendium r.4562-4706, Zygor). Geen beroep maar een systeem
  naast beroepen; kost geen beroepsplek (Wowhead-gids 13 nov).
- Ontgrendelen rond level 4-6: "The Great Outdoors" — Elwynn 95998, Zephras Isle 96101, Durotar 96604, Mulgore 96605,
  Tirisfal 96607 (GEMETEN Zygor + Spoken QuestText). Opdracht: /sit bij het kampvuur → buff "Boosted Rest" (~1 min).
  Daarna "Camping 101: Cooking" (bv. 96626 Elwynn): Cooking leren. Per beroep "Camping 101: <beroep>" (bv. Skinning
  96056/97924, Mining 96046).
- Vuur: Basic Campfire vanaf Cooking 1: 1 Simple Wood (4470) + Flint and Tinder (4471, gereedschap), beide bij de
  Cooking-trainer (Wowhead-gids). 3 objecten per vuur. Journeyman Campfire (blueprint, Star Wood) 5 objecten, Expert
  Campfire (blueprint, Thick Logs) 10 (tooltips + Blizzard). Journeyman sinds hotfix 10 nov op Cooking 90 (was 140).
  Vuur 5 min cooldown; alleen buiten, niet in combat/instances/raids/arena, niet in shapeshift (spell-flags Expert
  Campfire 1307237, Wowhead). Niet midden in een stad (Spoken QuestText r.17345). Vuur doet schade als je erin staat;
  sinds 1 okt niet onder level 5 (één bron).
- Buff krijgen: eerst "Campfire Nearby" 1283391 (passief, effect-radius 100 yd, Wowhead). Dan 1 min zitten
  (zitten/stoel/slapen/liggen/knielen; casten en craften mag, bewegen niet) → timer "Welcoming Campfire" 1229739
  (variant 1289723), 1 min (Wowhead-tooltip; Blizzard dev notes 24 sep via bindonforever). Daarna ÉÉN zichtbare buff
  "Camp Benefits" 1229741, 1 uur (Wowhead tooltip-JSON 17 nov; tekst "Gained the following camp benefits:" + per object
  een regel). Verborgen deel-auras: Extra Strength 1230172 ("Aura is hidden" GEMETEN), Boosted Intellect 1229513,
  Boosted Attack Power 1230164, Boosted Critical Chance 1229519 (lege buff-tekst; hidden niet gecheckt); Spirit 1229718
  (alleen bindonforever).
- Duur/stapelen: buffs van verschillende objecten tellen op in Camp Benefits. Elke kampbuff is mutually exclusive met
  één class-buff (Blizzard 21 okt + tooltips). Langer: Legacy-perk Permanence (+50/100%, Wowhead-gids; ⚠ zie
  Legacy-onderzoek: DB2-basis 100 groepsbuff / 50 kamp); Twitch-toy Pouch of Violet Dust +1 uur (hotfix 9 nov "extra
  hour of duration of the Camp Benefits aura"; tot de launch-viering begin dec). Hearthproof meldt "2 uur"
  (waarschijnlijk de Pouch, AFGELEID).
- Kosten/limieten: per speler 1 object, alle objecten delen 1 uur cooldown (Blizzard + tooltips). Object gaat op bij
  neerzetten, verhandelbaar; neerzetten vraagt het beroep op dat skillniveau (Wowhead-gids). Object staat 15 min (DB
  spell-duur 1307392/1307229; Blizzard schatte eerder ~10 min) — AFGELEID tot gemeten.
- Solo/groep: geen groep nodig (Wowhead News 22 sep, spelersbericht). Faction Banner alleen eigen factie (Blizzard).

## 2. Objecten tier 1 (skill 20)
Effect schaalt met CHARACTER level (tooltip-formules, bv. Lodestone `60<12?12:…90`, GEMETEN); effect + "botst met"
GEMETEN voor alle 11.

| Object (beroep) | Effect lvl 1→60 | Botst met | Grondstoffen | ID | Deel-aura |
|---|---|---|---|---|---|
| Camp Chair (Skinning) | +2% crit spells en attacks | Moonkin Aura | 3 Light Leather, 2 Simple Wood | item 279979 / plaatsing 1307229 | Boosted Critical Chance 1229519 |
| Sharpening Wheel (Blacksmithing) | +6/11/20/34 Strength | Strength of Earth Totem | Rough Stone, Copper Bar | item 279944 / 1307392 | Extra Strength 1230172 (hidden) |
| Incense Candle (Herbalism) | +2/6/12/18/25 Intellect | Arcane Intellect | Peacebloom, Silverleaf | item niet gevonden | Boosted Intellect 1229513 |
| Mana Well (Alchemy) (= Robs "manual") | 10/15/20/24/29 mana per 5 s | Blessing of Wisdom | Peacebloom, Empty Vial | item 279956 | niet gevonden |
| Lodestone (Mining) | +12/20/32/49/67/90 melee AP | Blessing of Might | Rough Stone, Copper Bar | item 279960 | Boosted Attack Power 1230164 |
| Fish Bowl (Fishing) | +8% alle stats | Blessing of Kings | Raw Brilliant Smallfish, Empty Vial | plaatsing 1307245 (bindonforever) | niet gevonden |
| First Aid Kit (First Aid) | +3 tot 56 Stamina | Power Word: Fortitude | 3 Linen Bandage, Refreshing Spring Water | niet gevonden | niet gevonden |
| Faction Banner (Tailoring) | +14/19/27/32 Spirit, eigen factie | Divine Spirit | Bolt of Linen Cloth, Coarse Thread | recipes 1229504 / 1263425 (wow-forever.gg) | 1229718 (bindonforever) |
| Enchanted Lute (Enchanting) | armor 28-308, +2-13 stats, +6-22 res | Mark of the Wild | Simple Wood, Strange Dust | niet gevonden | niet gevonden |
| Camp Tent (Leatherworking) | rested XP tot 5% van een level | niets | 5 Light Leather | item 279978 | lockout "Boosted Rest" 1229451, 1 uur |
| Reagent Bot (Engineering) | reagent-verkoper, geen buff | – | Copper Bolts, Copper Tube | – | – |

Bekende recept-spells: Sharpening Wheel 1230171, Mana Well 1230564, Camp Chair 1229517, Lodestone 1230161 (rest niet
gemeten).
Hogere tiers: tier 2 (skill 140; Tanning Rack 125 sinds hotfix 6 nov) en tier 3 (300) via blueprints uit dungeons;
vervangen tier 1 en houden de buff, behalve Anarchist's Workbench (tooltips + Blizzard). Drops grotendeels onbekend;
gemeld (niet gecheckt): Fishing Rack van Gelihast (Blackfathom Deeps), Tanning Rack van Razorclaw (Shadowfang Keep).
Niet uitgezocht: Cozy Sleeping Bag (questketen vanaf 14, XP-bonus), Adventurer's Tent, Scarlet Banner (cosmetisch).

## 3. Kandidaten uit Forever Leveling Guide (ARR — alleen als aanwijzing, zelf nameten)
Gedeelde object-cooldown spell 1308027 (60 min); Welcoming 60 s zitten óf craften binnen 20 yd; Camp Benefits blijft als
je opstaat; 12 tier-1-objecten incl. Basic Campfire = Cooking; blueprint-dropkansen in hun wowF_Campamento_Datos.lua
(niet overnemen). DB nogmaals: 20 yd (sit-timer) en 35 yd (object-effect) in spelldata, in het spel niet gemeten.

## 4. Wat MH al had (GEMETEN door het onderzoek)
Alleen ForeverProfGuide.lua r.16-18 ("Not in this version: Camping", "Cooking's campfire (that is Camping, version B)").
Wel bruikbaar: Flint and Tinder 4471 in ForeverToolGuard.lua:53, verkopers in ForeverVendorSpots.lua, Simple Wood 4470
in ForeverReagentData.lua, ForeverBuffs.lua (ns.Aura.HasPlayerAura), ForeverItemTips.lua, ForeverDoNow.lua.

## 5. Bouwvoorstel (Robs ja: "dat kampvuuridee moeten we ook gaan bouwen")
(1) uitlegkaart Kamperen = ForeverProfGuide versie B: per beroep object, effect op jouw level, botst met, waar te leren,
5 stappen (hout + Flint and Tinder → vuur → object → 1 min zitten → Camp Benefits 1 uur); (2) "Do this now": Campfire
Nearby maar geen Camp Benefits → "ga 1 minuut zitten"; (3) beroep ≥20 zonder kamprecept → hint; (4) tooltip op
kampobject-items; (5) opt-in herinnering "geen kampbuff" (standaard uit); (6) /mh camp-diagnose (zwijgregel);
(7) clientnamen per taal meten.
API (AFGELEID): C_UnitAuras.GetPlayerAuraBySpellID via ns.Aura.HasPlayerAura voor 1283391, 1229739/1289723, 1229741,
1229451. Forever HEEFT secret values (ForeverWarnings.lua:211, UnitHealth/Power buiten combat, Rob 8 nov); auras
mogelijk verborgen in combat (bewering "Forever Buffed", ARR, kandidaat). Beslis alleen buiten combat; nil = onleesbaar.
Eerste test voor Rob: zijn 1229741 en 1283391 leesbaar?

## 6. Niet gemeten
Leesbaarheid in de client (buiten/in combat); item-ID's Fish Bowl, Incense Candle, First Aid Kit, Lute, Banner;
deel-auras Fish Bowl/Mana Well/Stamina/Lute; echte staduur object; bereik in het spel; clientnamen; buff na doodgaan;
docs/ niet gelezen.
