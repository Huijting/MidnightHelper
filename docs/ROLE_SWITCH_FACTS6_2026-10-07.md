# Role Academy: feiten ronde 6 (7 okt 2026)

Uitzoekwerk voor N1, N2, N3 en T4 uit `ROLE_SWITCH_REREAD5_NEWCOMER_2026-10-07.md`. Alleen gelezen, geen addon-bestanden
aangeraakt. Uit `docs/` las ik alleen REREAD5, FACTS4 en FACTS5 (mocht volgens de opdracht).

## Bronnen

- **wago.tools DB2 + GlobalStrings, build `12.1.0.69933`** (= live, zie FACTS5), via het browservenster en de CSV-export.
- **Blizzard UI-code:** Gethe/wow-ui-source commit `09b9db7` "12.1.0 (69933)" (22 sep 2026). GEMETEN via de GitHub-API.
- **Gidsen (kandidaat, geen client):** Icy Veins Prot Pal *Rotation* (bijgewerkt 21 aug 2026, changelog 21 sep), *Talents*
  (21 sep), *Easy Mode* (21 sep), *Mythic+* (21 sep). Method Prot Pal *Playstyle & Rotation* (3 sep 2026). Wowhead Prot Pal
  rotatie (12 aug 2026, dus vóór Season 2). warcraft.wiki.gg *Loot* (bewerkt 11 feb 2026). Wowhead-itempagina's (gelezen 7 okt).

---

## 1. Sentinel en Avenging Wrath (N3)

**Kort: Sentinel vervangt Avenging Wrath. Je hebt nooit twee knoppen. De gidsen drukken hem op cooldown, niet "bewaren".**

| Bewering | Status | Bron |
|---|---|---|
| TraitDefinition 107471 = Sentinel 389539 met **OverridesSpellID 31884** (Avenging Wrath). | GEMETEN | DB2 TraitDefinition |
| Die definitie hangt aan node 81497: boom 790, type Single (geen keuzeknoop), alleen zichtbaar voor SpecSet 28 = spec 66 (Prot). Vrij na 20 punten in de boom. | GEMETEN | TraitNodeEntry 102466, TraitNodeXTraitNodeEntry, TraitNode, TraitNodeGroupXTraitCond → TraitCond 20144/48134, SpecSetMember 73 |
| Avenging Wrath is voor Prot een **eigen talent**, node 81483 (ook alleen SpecSet 28, vrij na 8 punten, ouder = Ardent Defender 81481). Ret heeft node 81544, Holy keuzeknoop 81584. | GEMETEN | idem; TraitEdge 132606 |
| Avenging Wrath is dus geen baseline meer: geen rij in SpecializationSpells (positieve controle: 53600 wél gevonden); SkillLineAbility AcquireMethod 3, net als Lay on Hands en BoP (talenten). Echte baseline (Crusader Strike, Shield of the Righteous, Consecration) = 2. | GEMETEN (waarden); "3 = via talent" AFGELEID | SpecializationSpells, SkillLineAbility |
| De tweede Sentinel-definitie 107452 (zonder override) hangt aan geen enkele node. | GEMETEN (positieve controle 102466 in dezelfde tabel) | TraitNodeXTraitNodeEntry |
| Sentinel 389539: 15 stacks Divine Resolve; per stack 2% minder schade (effect -2) en 1% meer max health (effect 1); +10% damage/healing, +10% crit; 20 s; 2 min cooldown. | GEMETEN | Spell, SpellEffect (index 0/3/10/11), SpellMisc dur 18 = 20000 ms, SpellCooldowns 120000 |
| Icy Veins zegt 2% max health per stack; DB2 basiswaarde is 1. Of een talent dat verhoogt: niet gemeten. | GEMETEN (verschil) | Icy Veins Rotation, DB2 |
| Avenging Wrath 31884: damage, healing en crit omhoog, 20 s, 2 min. Geen schadereductie in de tekst. | GEMETEN | Spell, SpellMisc, SpellCooldowns |
| *"Sentinel replaces Avenging Wrath."* Sinds 12.1 houd je ook de crit, dus Sentinel kost geen DPS meer. | kandidaat | Icy Veins Rotation (21 aug/21 sep 2026) |
| Alle 5 Icy Veins-builds (Raid/M+/Delves, Templar en Lightsmith) nemen node 81483 én 81497. | GEMETEN op de pagina | Icy Veins Talents (21 sep 2026) |
| Gebruik: Avenging Wrath (of Sentinel) is "een grote boost voor aanval én verdediging" en moet **zo dicht mogelijk op cooldown**. Uitzonderingen: wachten op een burst-moment, of het pack sterft voor de buff op is. | kandidaat | Method (3 sep 2026) |
| Icy Veins: opener en single-target-prioriteit beginnen met Avenging Wrath. Easy Mode: *"Use Avenging Wrath ... when they are available"*, en "ook defensief nuttig voor self-healing". | kandidaat | Icy Veins Rotation, Easy Mode (21 sep) |

**Spreekt MH zichzelf tegen? Ja (AFGELEID uit de code hieronder + de gidsen).**
- Kaart: `PLAYCARD_66_S1` (nlNL:1148) zegt Avenging Wrath *"als ze klaar zijn"*. Dat klopt met de gidsen.
- Toolkit: `TankToolkit.lua:109` geeft Sentinel `size = "big"` → `TANKKIT_CDDESC_DR_BIG` (nlNL:3628) *"bewaar hem voor de hardste
  klap"*. Blijf leven: `KeybindRoles_Paladin.lua:218` `survival = "big"` → `SURVIVAL_STEP_BIG` (nlNL:1531), zelfde strekking.
- Wie Sentinel heeft (alle Icy Veins-builds), hoort dus over **één knop op de balk** twee dingen: "druk zodra klaar" en "bewaar".
  De gidsen zeggen het eerste.
- De kaart toont de naam via `C_Spell.GetSpellName(31884)` zonder override (`PlayCards.lua:224-245`, `HealerCooldowns.lua:518-527`).
  Een Prot met Sentinel leest dan waarschijnlijk "Avenging Wrath" terwijl zijn balk Sentinel toont. Of GetSpellName de
  override-naam teruggeeft: niet gemeten.
- `KeybindRoles_Paladin.lua:214` zegt *"baseline alle specs"*. Volgens DB2 is het in 12.1 een talent per spec (zie tabel).
  Regel 214 (Avenging Wrath, geen `specs`) en 218 (Sentinel, `specs = {66}`) zijn voor een Prot met Sentinel dezelfde knop.
  Of de keybind-code dat via `FindSpellOverrideByID` goed samenvoegt: niet nagekeken.

---

## 2. Bijna dood: Divine Shield of Lay on Hands? (N2)

**Feiten (GEMETEN in FACTS5 §3, DB2 69933):**
- Divine Shield: *"Cannot be used if you have Forbearance. Causes Forbearance."* Lay on Hands en BoP: *"Cannot be used on a
  target with Forbearance. Causes Forbearance for 30 sec."*
- **Het omgekeerde geldt dus ook:** Lay on Hands op jezelf → 30 s geen Divine Shield. En BoP op jezelf blokkeert beide.
- Alleen het talent Light's Revocation (node 81608) laat Divine Shield door Forbearance heen. **Geen enkele van de 5 Icy
  Veins-builds neemt het** (0/1 in alle 5, GEMETEN op de pagina, 21 sep). Holy Reprieve (103860) ook 0/5.
- Final Stand (node 81504, Divine Shield taunt alles binnen 15 yd) zit in 4 van de 5 Icy Veins-builds. GEMETEN op de pagina.
  Let op: `SURVIVAL_NOTE_FORBEARANCE_TANK` (nlNL:1631) zegt dat vijanden weggaan. Met Final Stand is dat niet zo (AFGELEID).

**Gidsen (kandidaat):**
- **Icy Veins Easy Mode (21 sep 2026):** Lay on Hands = *noodknop als je health al laag is*, om jezelf vol te healen. Divine
  Shield = debuffs weghalen of *dodelijke schade ontwijken*; zonder Final Stand loopt de baas naar de volgende.
- **Icy Veins Rotation (21 aug/21 sep):** Lay on Hands is een noodheal. Voor jezelf liever Word of Glory; Lay on Hands vooral om
  een ander te redden.
- **Method (3 sep):** noemt Lay on Hands niet (0 treffers; positieve controle Word of Glory 5 treffers). Divine Shield: je
  verliest aggro, tenzij Final Stand of Hand of Reckoning. Met Final Stand je sterkste defensive.
- **Wowhead (12 aug 2026, vóór S2):** Divine Shield = *"get out of jail free card"*.
- **Geen gids zegt letterlijk "eerst X, dan Y".**

**Beginnersregel (AFGELEID uit het bovenstaande):** kies er één, want de ander werkt daarna 30 s niet.
- Health al laag, geen grote klap meer onderweg → **Lay on Hands**. Je blijft de tank en je staat weer vol.
- Er komt een klap aan die je ook met volle health niet overleeft → **Divine Shield vóór die klap**. Zonder Final Stand: taunt
  meteen als hij afloopt.
- Heb je Holy Power of Shining Light: eerst Word of Glory (Icy Veins).

---

## 3. Blessing of Protection op jezelf als tank (T4)

- **Method (3 sep 2026), kandidaat:** BoP en Divine Shield op jezelf = aggro kwijt. Tegen **één** vijand los je dat op met Hand
  of Reckoning. Sterk bij een baas met één harde fysieke klap of een gevaarlijke debuff. BoP helpt alleen tegen fysiek.
- **Icy Veins Mythic+ (21 sep), kandidaat:** BoP haalt bleeds weg en het doelwit verliest tijdelijk threat bij fysieke vijanden.
  Beschreven als knop voor groepsleden. De Rotation-pagina bespreekt BoP alleen op anderen. Easy Mode noemt BoP niet
  (0 treffers op "Blessing of"; positieve controle Divine Shield gevonden).
- Geeft Forbearance: daarna 30 s geen Divine Shield en geen Lay on Hands op jezelf. GEMETEN (FACTS5).

**Eén regel (AFGELEID):** *"BoP is voor een groepslid. Op jezelf alleen tegen één baas, vlak vóór een harde fysieke klap of
bleed, en meteen Hand of Reckoning erachteraan. In een pack nooit: dan lopen ze naar je groep."*

---

## 4. Als DPS queuen met Loot Specialization = Protection (N1)

| Bewering | Status | Bron |
|---|---|---|
| Welke rolknoppen je mag aanvinken komt uit `C_LFGList.GetAvailableRoles()` (C-kant). Kan het niet, dan zegt de tooltip `YOUR_CLASS_MAY_NOT_PERFORM_ROLE` of `YOU_ARE_NOT_SPECIALIZED_IN_ROLE` ("You are not specialized for this role."). | GEMETEN | `LFGFrame.lua:452-456, 2241-2259`; GlobalStrings |
| `LFGFrame.lua` en `LFDFrame.lua` noemen loot of Loot Specialization **nergens**. Positieve controle: GetAvailableRoles en SetLFGRoles wél gevonden. Loot is servercode, dus dit bewijst alleen dat de UI rol en loot niet koppelt. | GEMETEN | UI-code 69933 |
| Het menu *Loot Specialization* toont Default + spec 1-4, los van je huidige spec. Ret kan dus Protection kiezen. | GEMETEN | `UnitPopupSharedButtonMixins.lua:1807-1819` |
| `SELECT_LOOT_SPECIALIZATION_TOOLTIP`: *"Your class specialization that is used when giving you specialized loot."* Geen GlobalString koppelt loot aan je rol (zoekopdracht "loot spec" vond 6 strings, geen daarvan over rollen). | GEMETEN | GlobalStrings |
| Dungeons gebruiken personal loot: een willekeurig item **voor je spec**. Loot Specialization geldt voor mobs, quests, bonus rolls, tokens en de Vault. | kandidaat (feb 2026) | warcraft.wiki.gg *Loot* |
| Sinds patch 5.3 (2013) hangt loot in LFR niet meer aan je gekozen rol maar aan je Loot Specialization. Nieuwere bron die rol en loot weer koppelt: niet gevonden. | kandidaat (oud) | Engadget 2013 |
| Dungeonschilden Ward of the Spellbreaker 251105 en Tempest's Shelter 251150: te winnen door specs 65, 66, 73, 262, 264. **Niet door Ret (70).** | kandidaat | Wowhead-itempagina's |
| De vier dungeonschilden (251105, 251150, 251196, 251202): basis-RequiredLevel 78, ilvl 108, BoP. Geen ItemSpecOverride-rijen (tabel gelezen, 64839 rijen). | GEMETEN | ItemSparse, ItemSpecOverride |

**Antwoord (AFGELEID):** ja. Queue als Damage, zet Loot Specialization op Protection, en de dungeonloot wordt Prot-loot, ook
schilden. Kanttekeningen:
- Een schild is niet zeker: personal loot geeft een willekeurig Prot-item van die baas.
- Je krijgt dan ook tank-trinkets en eenhandige wapens, en geen Ret-tweehanders meer.
- Zet hem daarna terug op Default.
- Niet in het spel gemeten. Laat Rob het één keer proberen (Ret, Loot Spec Prot, random Midnight-dungeon).

---

## Wat NIET gemeten is

- In het spel: of de kaart "Avenging Wrath" of "Sentinel" toont, en of Prot-loot als DPS echt valt.
- Waarom Icy Veins 2% max health per Sentinel-stack noemt en DB2 1%.
- Of de keybind-code Avenging Wrath en Sentinel als één knop behandelt.
- Wat de server doet met loot en rol (geen UI-code).
