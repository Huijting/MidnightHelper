# Validatierapport — upstream-pakket v0.4

**Datum** 2026-07-30 · **Door** Claude Code · **Herzien** na de goedkeuring met gerichte
wijzigingen (F09-correctie, fixture 10, `world_fallback` ingetrokken)
**Methode** handmatige trace tegen `normalized_ko_catalog_v0.4.yaml`,
`ko_schema_v0.4.yaml` en `fixtures_full_v0.4.json`, plus een machinale controle op
parsebaarheid, refresolutie en mappingdekking

⚠️ **De trace is papieren validatie, geen machinaal bewijs.** Er is geen transpiler en
geen fixture-runner; die mogen nog niet gebouwd worden. Wat hier machinaal is nagekeken:
parsebaarheid, refresolutie, cycli, mappingdekking en copy-key-inventaris. Wat handmatig
is: de tien traces. Het echte bewijs is de 10/10-run uit de poort hieronder.

---

## 1. De harde poort

| Eis | Stand |
|---|---|
| 10/10 fixtures | traceerbaar; machinaal onbewezen tot de runner bestaat |
| alle output-refs resolven | ✅ machinaal gecontroleerd |
| 0 cycli | ✅ |
| alle request-inputs hebben een mapping | ✅ machinaal gecontroleerd |
| alle enUS- en nlNL-copy-keys bestaan | ✅ 36 keys, beide talen, elk met een eigenaar |

## 2. Resolutie van alle output-refs

Zes objecten, **zes** outputs (was zeven; `world_fallback` is ingetrokken), tien
rule-resultaten.

| Object | Outputs | Rule | Resultaat | Resolveert? |
|---|---|---|---|---|
| SYSTEM-STALE-000 | `stale_knowledge` | p1 | lokaal `stale_knowledge` | ✅ |
| WEEKLY-POWER-001 | `vault_ready` | p1 | lokaal `vault_ready` | ✅ |
| | | p2 | `pass_through` | ✅ n.v.t. |
| | | p3 | `pass_through` — **gewijzigd** | ✅ n.v.t. |
| RITUAL-TIER-002 | `ritual_t5`, `ritual_t6` | p1 | lokaal `ritual_t5` | ✅ |
| | | p2 | lokaal `ritual_t6` | ✅ |
| | | p3 (fallback) | extern → CONFIDENCE `unknown_final` | ✅ |
| TIMEBOX-003 | `ask_time`, `shorter_step` | p1 | lokaal `ask_time` | ✅ |
| | | p2 | lokaal `shorter_step` | ✅ |
| | | p3 | extern → CONFIDENCE `unknown_conditional` | ✅ |
| | | p4 | `pass_through` | ✅ n.v.t. |
| CONFIDENCE-004 | `unknown_conditional`, `unknown_ask`, `unknown_final` | p1–p4 | `confidence:` (geen output) | ✅ |
| PREREQUISITE-005 | `prerequisite` | p1 | `pass_through` | ✅ n.v.t. |
| | | p2 | extern → CONFIDENCE `unknown_ask` | ✅ |
| | | p3 | lokaal `prerequisite` | ✅ |

**Externe refs: 3, alle geldig, alle naar CONFIDENCE-004. Geen cycli** — CONFIDENCE-004
heeft zelf geen uitgaande externe refs, dus de refgraaf is een boom van diepte 1.

**Elke output wordt nu door minstens één fixture geraakt.** Dat was vóór deze ronde niet
zo; zie §5.

## 3. Copy-key-dekking

**36 keys**, elk in enUS en nlNL, elk eigendom van precies één object.

| Bron | Keys |
|---|---|
| `copy_catalog_enUS_nlNL_v0.1.json` | 32 |
| `copy_patch_enUS_nlNL_v0.2.json` | 1 vervangen (`MH_KO_TIME_ASK_FIRST_ACTION`) + 4 nieuw (`MH_KO_TIME_SHORT_*`) |
| **Totaal** | **36** = 32 kaart-keys + 4 confidence-labels |

`copy_additions_v0.3.json` is **verwijderd**. Die vier `MH_KO_WORLD_FALLBACK_*`-keys
waren alleen nodig voor de output die nu is ingetrokken, en ze waren door mij
voorgesteld in plaats van door ChatGPT geschreven. Er is dus geen placeholdercopy meer in
het pakket — een verbetering.

## 4. Trace per fixture

Notatie: → = stap in de pipeline (RFC-002 §5.2). "n.t." = niet toepasselijk.

**F01 vault ready** → `recommend` / high / [WEEKLY-POWER] ✅
Niets stale. PREREQ n.t. en RITUAL n.t. (materiële inputs onbekend). WEEKLY-POWER p1 vuurt
→ `vault_ready`. Gate-rules vragen om een schatting die er niet is → drie-waardig, vuren
niet. `missing_inputs` leeg → high, gelijk aan declared → CONFIDENCE niet genoemd.

**F02 ritual T5 vault-only** → `conditional` / medium / [RITUAL, CONFIDENCE] ✅
RITUAL p1 (`vault_only` + `recent_success_tier_5`) → `ritual_t5`, ilvl expliciet
gerapporteerd én als secondary gemarkeerd. Gate-modus: p1 van TIMEBOX is `standalone` en
vuurt niet; p2 en p4 onbekend. `secondary_input_missing` → medium. CONFIDENCE genoemd,
want de response rapporteert `missing_inputs`.

**F03 ritual T6** → `conditional` / medium / [RITUAL, CONFIDENCE] ✅
Als F02, via p2 (`weekly_extra_value_available` + `recent_success_tier_6`).

**F04 sessietijd onbekend** → `ask` / low / [TIMEBOX] ✅
WEEKLY-POWER: p1 nee, p2 nee (geen ritual), p3 `world_vault_activity_selectable` =
`or(and(false, true), false)` = false → geen hand-off. Geen route. Standalone: TIMEBOX p1
→ `ask_time`, `reports_missing: []`. `confidence_direction` houdt het op low in plaats van
high — anders zou een kaart die een *vraag stelt* als "Aanbevolen" op het scherm komen.

**F05 onbekende duur + slecht onderbreekbaar** → `conditional` / unknown / [TIMEBOX, CONFIDENCE] ✅
RITUAL n.t. — `available_tiers` ontbreekt en is required + material, dus **ook de fallback
vuurt niet**. Standalone: p2 nee (drie-waardig), p3 ✓ → extern `unknown_conditional`,
rapporteert `estimated_minutes.max`.

**F06 één prerequisite** → `blocked` / high / [PREREQ] ✅
PREREQ p3 → `prerequisite`, `prerequisite_id` = de **eerste** actionable, nooit de keten.
Blokkerend antwoord in stap 4 beëindigt de pipeline.

**F07 onbekende prerequisite** → `ask` / unknown / [PREREQ, CONFIDENCE] ✅
PREREQ p2 → extern `unknown_ask`, gerapporteerd als `prerequisite_state` via
`missing_input_label`.

**F08 material input missing** → `unknown` / unknown / [RITUAL, CONFIDENCE] ✅
RITUAL **wel** toepasselijk (available, tiers, goal aanwezig). p1 nee, p2 nee
(`null` ≠ `true`), p3 fallback ✓ → extern `unknown_final`, rapporteert drie velden in de
verwachte volgorde. Het contrast met F05 is de kern van de toepasselijkheidsregel: **F05
zwijgt omdat het object niet kan meedoen; F08 spreekt omdat het wél kan meedoen en
constateert dat geen route betrouwbaar te kiezen is.**

**F09 stale na seizoenswissel** → `defer` / unknown / [SYSTEM-STALE] ✅ *gecorrigeerd*
Interface 120100 ≥ 120100 → **beide** versiegebonden S1-objecten stale:
`MH-KO-WEEKLY-POWER-1207-001` en `MH-KO-RITUAL-TIER-1207-002`, beide
`degrade_to_unknown`, geen van beide voedt de aanbeveling. SYSTEM-STALE p1 →
`stale_knowledge`. De speler-zichtbare stale-output blijft uitsluitend eigendom van
SYSTEM-STALE-000.
Dit werkt alleen met `interface_max: null`. Met `120099` vielen beide objecten *buiten
scope*, zou `stale_object_ids` leeg blijven, zou SYSTEM-STALE niet vuren en zou de
response niets melden — het stille falen dat de harde invariant verbiedt.

**F10 route past niet, kies korter** → `conditional` / medium / [RITUAL, TIMEBOX] ✅ *nieuw*
→ 5 RITUAL toepasselijk; p1 vuurt (`vault_only` + een voltooide tier-5-run) → route
`ritual_t5`. Een inhoudelijk geldige route bestaat dus.
→ 6 **gate-modus**. Sessietijd is bekend (20). Buffermodel op de gekozen route:
`3 setup + 25 max + 5 buffer = 33 > 20` → `estimated_total_exceeds_available_time` = true.
TIMEBOX p2 heeft `mode: both` en mag daarom een route afwijzen → `shorter_step`,
`conditional`, medium. De kortere relevante route staat in de request: de delve op
`1 + 8 + 5 = 14 ≤ 20`.
→ 8 `missing_inputs` leeg → high, `min(medium, high)` = medium, gelijk aan declared →
CONFIDENCE niet genoemd.

## 5. Dekking van outputs

| Output | Bewezen door |
|---|---|
| `vault_ready` | F01 |
| `ritual_t5` | F02, F10 |
| `ritual_t6` | F03 |
| `ask_time` | F04 |
| `shorter_step` | **F10 — nieuw; dit was het laatste gat** |
| `unknown_conditional` | F05 |
| `unknown_ask` | F07 |
| `unknown_final` | F08 |
| `prerequisite` | F06 |
| `stale_knowledge` | F09 |

Alle tien de outputs zijn geraakt. Er is geen output meer zonder fixture, en er is geen
fixture die een output test die niet bestaat.

## 6. Rapportageregel bij een afgewezen route — GOEDGEKEURD 2026-07-30

F10 noemt **beide** objecten in `knowledge_object_ids` terwijl `missing_inputs` **leeg**
is, ook al had RITUAL's rule `ritual.live_recommended_item_level` te rapporteren. Dat is
geen tegenstrijdigheid: het zijn twee verschillende vragen. De eerste is *welke kennis
heeft aan de besluitvorming deelgenomen*, de tweede is *welk gat beperkt het antwoord dat
er uiteindelijk staat*.

De vastgelegde regel, in drie delen:

1. `knowledge_object_ids` bevat alle Knowledge Objects die **aantoonbaar aan de
   besluitvorming deelnamen**. In F10 is dat RITUAL (die de route koos die gemeten werd —
   zonder die route had TIMEBOX in standalone-modus gestaan en een ander antwoord
   gegeven) én TIMEBOX (die de route afwees en het antwoord leverde).
2. `missing_inputs` bevat **uitsluitend ontbrekende gegevens die de gekozen eindoutput nog
   beperken**. Het advies "kies iets korters" wordt niet beperkt door een onbekende
   aanbevolen itemlevel, dus die wordt niet gemeld.
3. `reports_missing` van een **afgewezen route vervalt**, *tenzij dat ontbrekende gegeven
   ook de vervangende route of de confidence daarvan beïnvloedt*. In F10 doet het dat
   niet: de kortere route wordt op tijd gekozen, niet op itemlevel, en de confidence van
   `shorter_step` hangt er niet van af.

De uitzondering in deel 3 is de belangrijke: hij voorkomt dat een gegeven dat *wel*
doorwerkt in het vervangende advies stilzwijgend verdwijnt omdat de eerste route sneuvelde.
Wie deze regel implementeert moet dus per afgewezen `reports_missing`-veld nagaan of het
in de vervangende output of in de confidence-resolutie voorkomt, en het alleen dán laten
staan.

F10 blijft daarmee op `"missing_inputs": []`.

## 7. Wat NIET bewezen is

`live_recommended_item_level` is in alle tien de fixtures `null`. Geen enkele trace toont
dus het pad waarin die waarde wél bekend is. Dat blijft zo tot een enumererende meting
in-game aantoont of er überhaupt een leesbare bron bestaat; zolang die er niet is, is er
niets om een fixture omheen te bouwen dat geen verzonnen getal bevat.
