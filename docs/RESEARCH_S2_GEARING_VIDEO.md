# Kandidaten uit een S2-gearing-video (Drowsy Dragon)

**Van:** ONDERZOEK-sessie, 20 aug 2026
**Bron:** transcript van een YouTube-gearingsgids voor Midnight Season 2, aangeleverd door Rob.

⚠️ **Dit zijn KANDIDATEN, geen bewijs.** Een gesproken gids is één persoon zonder
bronvermelding. Alles hieronder is te toetsen tegen de client of tegen Blizzards eigen posts;
niets hiervan mag zonder die toets in de addon. Zelfde regel als de rest van 20 aug.

---

## 1. 🔴 Waar de video het bij het verkeerde eind lijkt te hebben — en wij goed zitten

**De vault-bonusroll.** De video: *"you do need to complete any row of your great vault… either
eight mythic plus runs, six raid boss kills, or eight world activities."*

Blizzards eigen seizoenspost (Kaivax, 1 aug) zegt: *"can be selected by anyone who has unlocked
at least **3 panes**"* — drie vakjes over de rijen heen, niet één volle rij.

✅ `Modules/VaultAdvisor.lua:1072` staat op `VOIDCORE_SLOTS_REQUIRED = 3` en volgt dus de blue
post. **Niets doen.** Genoteerd omdat "een gids zegt iets anders" anders vroeg of laat als
bugmelding terugkomt.

📌 De blue post voegt ook een **timing** toe die de video niet noemt: bonusrolls zijn er pas
vanaf **week 2 (25 aug)**, niet bij seizoensstart.

---

## 2. ✅ Wat onafhankelijk bevestigt wat we al hadden

Deze kwamen vandaag uit officiële bronnen en gamedata; de video zegt hetzelfde. Dat is
geruststellend, geen nieuw bewijs.

- **Ascendant Venomstone uit T11 bountiful delves**, en **niet beschikbaar bij seizoensstart**.
- **Afflicted/Tormented Souls uit Heavy Trunks in T6+ bountiful delves**, met **Prey-rank 4 →
  champion-track** en **rank 9 → hero-track**, één keer per week per character.
- **Hero-track uit de bountiful coffer vereist Delver's Journey rank 9.**

---

## 3. 🎯 Vult twee gaten die sinds de audit van 19 aug openstonden

De stale-advice-audit liet `VOID_INFO_VAULT` en `RITUAL_INFO_VAULT` bewust leeg. De video geeft
er een kandidaat-antwoord op:

> *"the 12.0.7 world content like ritual sites and void assaults, these will give gear up to
> veteran track… it does cap out at 295 item level."*

En: activiteiten op **Val en Naigtal** geven alleen adventurer-track en tot veteran-crests — dus
niet meer terugkomen voor gear.

⚠️ **Te toetsen vóór invullen.** Dit is precies het soort getal waar we vandaag elf keer op
gestruikeld zijn. Robs eigen vault na de reset is de betrouwbaarste bron.

---

## 4. 🆕 Nieuw, MH-relevant, en de moeite van het natrekken waard

Gesorteerd naar wat het meest raakt aan iets dat MH al doet.

### a) De catalyst behoudt nu stats — en MH zegt hier niets over

> *"it will now keep secondary and tertiary stats on the item and any special effects when you
> convert it into a tier piece… Previously the tier items have predetermined stats."*

`Modules/TierSet.lua` bevat geen woord over stats bij conversie (gegrepped: geen treffer op
`stats`, `secondary`, `converts`). Als dit klopt, is het een **gedragsverandering die het advies
omdraait**: voorheen maakte het niet uit welk item je omzette, nu wel — je kiest het item met de
stats die je wilt houden.

**Dit is de sterkste kandidaat in de hele lijst**: het is uitlegbaar, het raakt een keuze die de
speler maakt, en niemand legt het uit. Precies MH's lijn.

### b) De crest-kosten zijn NIET gaan schalen

> *"early in the PTR cycle the upgrades were changed to be scaling… However, this has been
> reverted… It will cost 100 crests in total to take an item from 1/6 to 6/6."*

Als ergens in onze data 150 staat, of een oplopende kostenladder, is dat PTR-materiaal dat live
niet gehaald heeft. **Grep op onze crest-kosten voordat dit iemand geld kost.**

### c) Crest-upgrade → warband-brede korting

> *"you get the feat of strength for each type of crest… and then your entire war band benefits
> from a 50% reduction in crests needed to upgrade items on that crest level."*

Een 50%-korting die warband-breed geldt is een groot ding voor alt-advies, en het hangt aan een
Feat of Strength (dus leesbaar via achievement-API). Kandidaat voor de vault-/crest-kant.

### d) Raid-bonusroll kost nu 1 core in plaats van 2

Ons work-order-onderzoek noteerde "raid 2, bountiful delve 1" — maar dat kwam uit een
**Season 1**-supportartikel. Als dit klopt is het een S2-wijziging.

### e) De vault-raidrij geeft één moeilijkheidsgraad hóger

> *"The Great Vault will always reward the next tier's difficulty level of loot compared to the
> content you completed."* Heroic clear → myth in de vault; mythic raiders → altijd myth 6/6.

Raakt direct wat `VaultAdvisor` de speler vertelt te verwachten.

### f) Overige getallen, allemaal te toetsen

- **Max ilvl in S2 = 344**, van de laatste twee mythic-raidbosses die op **9/6** droppen;
  normaal mythic-raidspul 334.
- **M+ eind-van-dungeon capt op 311** (hero track); myth-track vault nog steeds **+10**, maar
  **myth-crests vanaf +9**.
- **Venomstone: 10 per upgrade** (was 5 in S1), en dekt nu **ook halskettingen**;
  ascended myth = **334**, ascended hero = **321**.
- **Renown-gear is van champion naar veteran-track gezakt** voor S2.
- **De world boss is nu een "layer"** met world/normal/heroic/mythic-varianten.
- **Week 8 (13 okt): Orange Stray** geeft +1 voidcore per week, naast de catalyst in Silvermoon —
  en daarmee vervalt de reis naar de Voidstorm.
- **Crafted gear is relatief minder waard**: een hero-crest-craft kost 80 crests terwijl een
  hero-stuk uit je vault op hetzelfde ilvl 318 nul crests kost.
- **De nieuwe embellishments zijn recent zwaar generfd.**

### g) Twee questnamen die onze delve-kant kunnen gebruiken

- **`Purging the Vaults`** (Vaults of Atal'Utek, Coiled Isle) = de **gegarandeerde** manier om je
  Trovehunter's Bounty-kaart te krijgen. 📌 Dit is dezelfde quest die in de hotfixes van 18 en
  19 aug tweemaal geblokkeerd bleek door items in je inventory — die staat al in
  `docs/PTR_12.1_WATCH.md`.
- **`A Nightmarish Task`** (dood 3 nightmare prey bosses) → `Scalebound Herald's Flute`, waarmee
  je de delve-nemesis betrouwbaar kunt oproepen.

---

## 5. Wat de video zegt over week 1, ter archivering

Niet meer actueel (week 1 is voorbij), maar het bevestigt wat we al wisten: in de pre-season week
waren **alle delve-tiers beschikbaar behalve bountiful**, de Nemesis stond op `?` en niet op
`??`, en er was **geen bonusroll uit de eerste vault**.

---

## 6. Aanbeveling

**Niets hiervan direct encoderen.** Drie dingen zijn het natrekken waard, in deze volgorde:

1. **De catalyst-stats** (§4a) — grootste uitleg-waarde, en MH zegt er nu niets over.
2. **De crest-kosten** (§4b) — als wij 150 of een schalende ladder hebben staan, is dat fout.
3. **Ritual sites en void assaults op veteran/295** (§3) — vult twee bewust lege velden, maar
   juist die twee zijn met Robs eigen vault te meten in plaats van te geloven.

De rest is achtergrond die goed is om te weten, maar niet iets waar de addon vandaag een uitspraak
over hoeft te doen.
