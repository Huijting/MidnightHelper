# Kamperen in Forever — onderzoek 17 nov 2026 (overgenomen uit het bericht van Sparring 17-11)

Onderzoek door mh-research (Opus, alleen gelezen) in de sessie van Sparring 17-11, letterlijk overgezet door de bouwchat
zodat het niet in een chat verdwijnt. **Niets hiervan is door de bouwchat nagemeten.** Wat hieronder AFGELEID heet, moet
vóór het bouwen gemeten worden (bv. met `run gamedata` of in het spel).

Rob, letterlijk (via sparring): *"We hebben tegenwoordig kampvuurs waarbij je allerlei power-ups, hoe noem je dat,
tijdelijke buffs kan krijgen. Onder andere bij een campchair, een sharpening wheel, incense candle, manual, lodestone en
fishbowl. Daar hebben we volgens mij ook helemaal niks over. Ik denk dat we meer informatie kunnen geven, zeker als helper
zijnde."* Op het onderzoek: *"Ja, het zal vast mana wel zijn. En dat kampvuuridee moeten we ook gaan bouwen."*
("manual" = Mana Well.) Volgorde: NA de classes.

## Bronnen (volgens sparring)
Blizzard News 13 sep / 21 okt + hotfixes 9, 10, 16 nov; Wowhead Forever-gids "Camping Overview" 13 nov + tooltip-JSON
17 nov; bindonforever.com/camping (build 70888); Spoken QuestText.lua r.17332-17502 + Compendium.lua r.4562-4706; Zygor
...AllianceCLASSICTrial.lua r.400-430.

## Feiten (zoals gemeld)
- Forever-only. In MH alleen ForeverProfGuide.lua r.16-18 ("Not in this version: Camping" / "version B").
- Ontgrendelen ~level 4-6: "The Great Outdoors" (Elwynn 95998, Zephras 96101, Durotar 96604, Mulgore 96605, Tirisfal
  96607): /sit bij een vuur → "Boosted Rest". Dan "Camping 101: Cooking" (bv. 96626) en per beroep
  "Camping 101: <beroep>" (bv. Skinning 96056/97924, Mining 96046). Geen beroepsplek.
- Vuur: Basic Campfire vanaf Cooking 1, 1 Simple Wood (4470) + Flint and Tinder (4471, gereedschap), beide bij de
  Cooking-trainer; 3 objecten. Journeyman (blueprint, Star Wood) 5 objecten, Cooking 90 sinds hotfix 10 nov; Expert
  (Thick Logs) 10. 5 min cooldown; buiten, niet in combat/instance/shapeshift, niet midden in een stad.
- Buff: "Campfire Nearby" 1283391 (passief, 100 yd) → 1 min zitten/stoel/liggen (casten/craften mag, niet bewegen),
  timer "Welcoming Campfire" 1229739 (ook 1289723) → "Camp Benefits" 1229741, 1 uur, met per object een regel.
  Deel-auras verborgen: Extra Strength 1230172 (verborgen GEMETEN), Boosted Intellect 1229513, Boosted Attack Power
  1230164, Boosted Critical Chance 1229519, Spirit 1229718 (alleen bindonforever). Langer: Legacy-perk Permanence
  +50/100%; Pouch of Violet Dust +1 uur (tot de launch-viering begin dec).
- Per speler 1 object, gedeelde cooldown van 1 uur; het object gaat op, is verhandelbaar; 15 min staan (DB, AFGELEID;
  Blizzard eerder ~10). Elke kampbuff botst met één class-buff.
- Objecten tier 1 (skill 20), effect schaalt met character-level:
  | object | beroep | effect | botst met | item / recept |
  |---|---|---|---|---|
  | Camp Chair | Skinning | +2% crit | Moonkin Aura | item 279979, recept 1229517 |
  | Sharpening Wheel | Blacksmithing | +6/11/20/34 Str | Strength of Earth Totem | item 279944, recept 1230171 |
  | Incense Candle | Herbalism | +2/6/12/18/25 Int | Arcane Intellect | |
  | Mana Well | Alchemy | 10/15/20/24/29 mp5 | Blessing of Wisdom | item 279956, recept 1230564 |
  | Lodestone | Mining | +12..90 melee AP | Blessing of Might | item 279960, recept 1230161 |
  | Fish Bowl | Fishing | +8% alle stats | Blessing of Kings | plaatsing 1307245 |
  | First Aid Kit | First Aid | +3..56 Sta | Power Word: Fortitude | |
  | Faction Banner | Tailoring | +14..32 Spirit (eigen factie) | Divine Spirit | |
  | Enchanted Lute | Enchanting | armor/stats/res | Mark of the Wild | |
  | Camp Tent | Leatherworking | rested XP tot 5% level, lockout Boosted Rest 1229451 1 uur | | item 279978 |
  | Reagent Bot | Engineering | verkoper | | |
  Tier 2 (skill 140; Tanning Rack 125) en 3 (300) via blueprints uit dungeons.

## Voorstel (Robs ja geldt voor bouwen; details keuze bouwchat, spelers kiezen via schakelaars)
1. Uitlegkaart "Kamperen" = ForeverProfGuide versie B (per beroep: object, effect, botst met, waar te leren; 5 stappen).
2. "Do this now": Campfire Nearby maar geen Camp Benefits → "ga 1 minuut zitten".
3. Eventueel: beroep ≥ 20 zonder kamprecept → hint.
4. Tooltip op kampobject-items (ForeverItemTips).
5. Opt-in herinnering "geen kampbuff" (standaard uit).
6. `/mh camp`-diagnose (zwijgregel uit CLAUDE.md).
7. Clientnamen per taal meten.

## Let op
Forever HEEFT secret values (ForeverWarnings.lua:211); auras mogelijk verborgen in combat (bewering van de addon Forever
Buffed, All Rights Reserved: geen code overnemen). `ns.Aura` nil = onleesbaar; beslis alleen buiten combat. Eerste test
voor Rob: zijn 1229741 en 1283391 leesbaar.
