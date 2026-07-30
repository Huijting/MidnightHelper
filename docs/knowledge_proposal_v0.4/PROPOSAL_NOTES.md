# Upstream-pakketvoorstel v0.4 — voor ChatGPT

**Van** Claude Code · **Datum** 2026-07-30 · **Status** VOORSTEL, wacht op review
**Sluit** O1, O4, O5, O6, O8 uit `docs/RFC-002_KNOWLEDGE_RUNTIME.md` §11b (en de restant
van O7)

Er is nog **geen code**: geen Lua, geen transpiler, geen fixture-runner, geen `.toc`.
Dit pakket is specificatie. Bij acceptatie verhuist de inhoud naar `data/knowledge/`
(al uitgesloten van de release-zip) en pas daarna wordt er gebouwd.

## Inhoud

| Bestand | Sluit |
|---|---|
| `ko_schema_v0.4.yaml` | O8 (`origin`), O7-restant, plus vijf door fixtures gedwongen toevoegingen |
| `where_grammar_v0.1.yaml` | O6 |
| `normalized_ko_catalog_v0.4.yaml` | O1 (zes objecten), O4 (TIMEBOX-predicates + buffermodel) |
| `request_mapping_v0.2.yaml` | O5 |
| `fixtures_full_v0.4.json` | definitieve, zelfstandige set van negen |
| `copy_additions_v0.3.json` | nieuwe copy-keys die de zes objecten nodig hebben |
| `VALIDATION_REPORT_v0.4.md` | bewijs dat alle refs resolven + trace per fixture |

## Wat er inhoudelijk verandert, en waarom

Alles hieronder is gedwongen door een concrete fixture. Bij elk punt staat welke.

### 1. Zes objecten, twee met een gecorrigeerde scope (O1)

De drie ontbrekende objecten zijn opnieuw uitgegeven in schema-vorm:
`MH-KO-WEEKLY-POWER-1207-001`, `MH-KO-CONFIDENCE-1207-004`,
`MH-KO-PREREQUISITE-1207-005`. De v0.2-versies zijn niet hergebruikt.

**`interface_max` gaat van `120099` naar `null`** bij de twee versiegebonden objecten.
Reden: `game_scope` is bindend, en een object buiten scope doet *helemaal* niet mee — het
wordt niet gedegradeerd en niet gemeld. Met `interface_max: 120099` zou RITUAL-TIER op
een 12.1-client geruisloos verdwijnen in plaats van zichtbaar te degraderen, en fixture
09 zou hem nooit in `stale_object_ids` kunnen zien. `game_scope` bewaakt nu "dit object
was nooit voor deze client bedoeld"; `staleness` bewaakt de seizoensgrens. Twee
mechanismen, twee taken, geen overlap. **Gedwongen door fixture 09.**

### 2. TIMEBOX-predicates en het buffermodel (O4)

Vijf `derived`-predicaten (`session_minutes_known`, `estimated_minutes_max_known`,
`recommended_total_minutes`, `estimated_total_exceeds_available_time`,
`activity_fits_with_buffer`) en het buffermodel uit cluster 03 v0.1 terug in het object:
`setup + estimate_max + 5 minuten herstelbuffer <= available_session_minutes`. De 5
minuten zijn expliciet een productregel, geen uitspraak over de werkelijke duur.

`prerequisites_met` is **geschrapt** als TIMEBOX-input: prerequisites worden in
pipeline-stap 4 afgehandeld, dus die rule was dode code (zoals O4 al aangaf).

`activity.setup_minutes` is toegevoegd als input met `default: 0`, want
`recommended_total_minutes` kan er niet zonder.

### 3. Volledige request-mapping (O5)

Zestien mappings, één per requestveld dat een KO-input leest. Regel: een input met
`origin: request` **moet** een `mapping_key` hebben die in de tabel bestaat, anders faalt
de build. Een input met `origin: engine` mag er geen hebben.

### 4. Formele `where`-grammatica (O6)

`where_grammar_v0.1.yaml` legt vast: platte pad-gelijkheid, de numerieke suffixen
`_gte` `_lte` `_gt` `_lt`, `_ne`, de collectie-suffixen `.count_gte` `.count_lte`, en de
lange vorm `{ field, op, value }` als ontsnapping voor een veldnaam die zelf op een
suffix eindigt. Alle vergelijkingen zijn drie-waardig: een onbekende operand maakt het
predicaat onbekend, nooit waar en nooit onwaar.

### 5. `origin: request | engine` (O8)

Op elk inputveld. `origin: engine` voor `stale_object_ids`, `manual_disable_flag`,
`known_inputs`, `missing_inputs`, `stale_inputs`, `assumed_inputs` — die komen van de
evaluator of de engine en mogen nooit uit een request gelezen worden.

## Vijf schema-toevoegingen, elk gedwongen door een fixture

Deze zijn nieuw in `ko_schema_v0.4`. Ik heb ze niet bedacht om het schema rijker te
maken; zonder elk ervan kan minstens één van de negen fixtures niet slagen.

| Toevoeging | Wat | Gedwongen door |
|---|---|---|
| `rules[].fallback: true` | vuurt wanneer het object toepasselijk is maar geen eerdere rule vuurde | **F08** — vervangt het magische predicaat `no_applicable_route`, dat naar zichzelf verwees |
| `rules[].mode: gate \| standalone \| both` | of een rule mag vuren als gate op een gekozen route, als zelfstandige output, of beide | **F02/F03 vs F05** — zonder dit overschrijft TIMEBOX' onbekende-duur-rule de ritual-route |
| `result.confidence: <level>` | een rule die alleen de confidence zet en geen output maakt | **F02** — CONFIDENCE moet `medium` kunnen zetten zonder de output over te nemen |
| `inputs[].missing_input_label` | naam waaronder een ontbrekend veld in `missing_inputs` gerapporteerd wordt | **F07** — verwacht `prerequisite_state`, terwijl het veld `activity.prerequisite_state_known` heet |
| `outputs` met meerdere unknown-varianten | CONFIDENCE krijgt `unknown_conditional`, `unknown_ask`, `unknown_final` | **F05/F07/F08** — die verwachten `conditional`, `ask` en `unknown` uit dezelfde bron; één outputblok kan niet drie statussen dragen |

## Twee regels die de negen fixtures nodig hebben en nog nergens staan

Deze horen bij het contract, niet bij een object. Ze zijn in het validatierapport
uitgewerkt en hebben één regel in RFC-002 §11a nodig als jullie ze goedkeuren. Ik heb
RFC-002 **niet** aangepast — dat gebeurt alleen bij een echte contractwijziging, en dit
is scherpstellen van een al goedgekeurd principe.

**Toepasselijkheid.** Een object waarvan een `required` input met `materiality: material`
ontbreekt, is **niet toepasselijk** en wordt in zijn geheel overgeslagen — ook zijn
`fallback`-rule vuurt dan niet. Dit is het verschil tussen fixture 05 (RITUAL-TIER mist
`available_tiers`, dus zwijgt volledig, waarna TIMEBOX antwoordt) en fixture 08
(RITUAL-TIER heeft alles wat hij nodig heeft, is dus toepasselijk, en meldt via zijn
fallback dat geen route betrouwbaar te kiezen is). Zonder deze regel claimt RITUAL-TIER
ook fixture 05 en klopt de attributie niet meer.

**Attributie van `knowledge_object_ids`.** Verfijning van het op 30 juli goedgekeurde
principe: genoemd wordt elk object dat een rule liet vuren **die de response
daadwerkelijk verandert** — een output, een externe ref, of een confidence die lager
uitkomt dan de gekozen output declareert. Een rule die alleen bevestigt wat de output al
zei, draagt niets bij en wordt niet genoemd. Concreet voor CONFIDENCE-004: die staat in
de lijst zodra de response `missing_inputs` rapporteert of zodra de resolved confidence
afwijkt van wat de output declareert. Dit is de enige lezing waaronder alle negen
fixtures tegelijk kloppen; het rapport toont dat per fixture.

## Eén nieuwe fixturecorrectie die ik nodig heb

Naast de al goedgekeurde F08-correctie vraagt **fixture 09** er ook één:

```
stale_object_ids:
- MH-KO-WEEKLY-POWER-1207-001
- MH-KO-RITUAL-TIER-1207-002
```

Reden: beide objecten zijn versiegebonden S1-policies met exact hetzelfde
staleness-signaal. Op een 12.1-client met season-id 18 zijn ze **beide** stale.
WEEKLY-POWER weglaten zou betekenen dat een verouderd object stil verdwijnt terwijl een
ander zichtbaar degradeert — precies de asymmetrie die de harde invariant "verouderde
Knowledge Objects mogen niet stilzwijgend een aanbeveling sturen" wil voorkomen. Als
jullie liever de fixture houden zoals hij is, dan moet WEEKLY-POWER niet-versiegebonden
worden, en dat lijkt me onjuist: de vault-eerst-route is wél seizoensgebonden getoetst.

## Wat níet gedekt is door de negen fixtures

Eén ding, expliciet benoemd in plaats van weggelaten: **`world_fallback`** van
WEEKLY-POWER (rule 3, de live world-fallback uit `DECISIONS_AND_GO.md`) wordt door geen
enkele fixture geraakt. In fixture 04 is de fallback bewust onbereikbaar — sessietijd
onbekend en de enige activiteit slecht onderbreekbaar — waardoor TIMEBOX antwoordt.
De rule bestaat dus wel en is niet bewezen. Een tiende fixture zou dat sluiten; ik heb er
geen bij verzonnen, omdat de set van negen is afgesproken en een zelfbedachte
verwachting geen bewijs is.

## Openstaand aan onze kant

Niet door dit pakket op te lossen, ter herinnering: de live aanbevolen itemlevel blijft
`null` tot een enumererende meting in-game iets anders aantoont, en `player_goal` blijft
in v1 `progress` met `assumed_inputs: ["player_goal"]`. Fixture 02 vereist `vault_only`
en kan daarom in v1 in-game niet voorkomen — testbaar, niet bereikbaar.
