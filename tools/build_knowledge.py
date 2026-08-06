#!/usr/bin/env python3
"""
Midnight Helper — Knowledge transpiler (RFC-002, implementation phase 1).

WoW's Lua sandbox has no file I/O: an addon can only read what the .toc loaded as a Lua
chunk. A runtime YAML loader therefore cannot exist. This script is the answer — the
upstream YAML is the source of truth, and it is compiled to a Lua data table at commit
time, never at run time.

    docs/knowledge_proposal_v0.4/*.yaml   ->   Modules/KnowledgeData_S1.lua

It refuses to emit anything that would not survive the approval gate: schema v0.4
violations, unresolved output refs, reference cycles, a request input without a mapping,
or a copy key missing from enUS or nlNL all fail the build with exit 1. A knowledge object
is never transpiled "as well as possible" — that is exactly the silent assumption the
never-lie policy exists to prevent.

It also emits the fixture corpus as Lua (tools/knowledge_fixtures_generated.lua) so the
phase-2 runner needs no JSON parser, for the same reason the addon needs no YAML parser.

Usage:
    python tools/build_knowledge.py            # build, or fail loudly
    python tools/build_knowledge.py --check    # validate only, write nothing

Pure stdlib apart from PyYAML, like the repo's other generators.
"""

from __future__ import annotations

import io
import json
import os
import sys

try:
    import yaml
except ImportError:  # pragma: no cover
    sys.stderr.write("build_knowledge.py needs PyYAML:  pip install pyyaml\n")
    sys.exit(2)

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "docs", "knowledge_proposal_v0.4")

SCHEMA_FILE = os.path.join(SRC, "ko_schema_v0.5.yaml")
CATALOG_FILE = os.path.join(SRC, "normalized_ko_catalog_v0.5.yaml")
MAPPING_FILE = os.path.join(SRC, "request_mapping_v0.3.yaml")
COPY_FILE = os.path.join(SRC, "copy_catalog_enUS_nlNL_v0.3.json")
FIXTURE_FILE = os.path.join(SRC, "fixtures_full_v0.5.json")

OUT_DATA = os.path.join(ROOT, "Modules", "KnowledgeData_S1.lua")
OUT_FIXTURES = os.path.join(ROOT, "tools", "knowledge_fixtures_generated.lua")

# where-grammar v0.1: the closed set of comparison suffixes.
SUFFIX_OPS = ["_gte", "_lte", "_gt", "_lt", "_ne"]
COUNT_OPS = [".count_gte", ".count_lte"]

DERIVED_OPERATORS = {
    "any", "all", "count_gte", "count_lte", "exists", "equals", "sum",
    "gt", "gte", "lt", "lte", "and", "or", "not", "evaluator_result",
    # v0.5: picking a tier out of the list and comparing item levels against it.
    "select_max", "field", "subtract",
}

errors: list[str] = []
notes: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


# ----------------------------------------------------------------------- loading


def load_all():
    schema = yaml.safe_load(io.open(SCHEMA_FILE, encoding="utf-8"))
    catalog = yaml.safe_load(io.open(CATALOG_FILE, encoding="utf-8"))
    mapping = yaml.safe_load(io.open(MAPPING_FILE, encoding="utf-8"))
    copy = json.load(io.open(COPY_FILE, encoding="utf-8"))
    fixtures = json.load(io.open(FIXTURE_FILE, encoding="utf-8"))
    return schema, catalog, mapping, copy, fixtures


# -------------------------------------------------------------------- validation


def validate_inputs(obj, mapping_keys, selectors):
    """Every request input needs a real mapping; engine inputs must not have one."""
    subject_activities = set()
    for i in obj.get("inputs", []):
        for f in ("name", "type", "required", "materiality", "origin"):
            if f not in i:
                err(f"{obj['id']}: input {i.get('name', '?')} is missing required field '{f}'")
        origin = i.get("origin")
        key = i.get("mapping_key")
        if origin == "request":
            if not key:
                err(f"{obj['id']}: request input '{i['name']}' has no mapping_key")
            elif key not in mapping_keys:
                err(f"{obj['id']}: request input '{i['name']}' maps to unknown key '{key}'")
            elif key in selectors:
                subject_activities.add(selectors[key])
        elif origin == "engine":
            if key:
                err(f"{obj['id']}: engine input '{i['name']}' must not carry a mapping_key")
        else:
            err(f"{obj['id']}: input '{i.get('name')}' has invalid origin '{origin}'")
        if i.get("materiality") not in ("material", "secondary", "contextual"):
            err(f"{obj['id']}: input '{i.get('name')}' has invalid materiality")
    return subject_activities


def validate_where(obj, name, where):
    """where-grammar v0.1: short form with a closed suffix set, or the long form."""
    if where is None:
        return
    if isinstance(where, list):
        for item in where:
            if not isinstance(item, dict) or "field" not in item or "op" not in item:
                err(f"{obj['id']}: derived '{name}' long-form where needs field/op/value")
        return
    if not isinstance(where, dict):
        err(f"{obj['id']}: derived '{name}' has a where clause that is neither map nor list")
        return
    for key in where:
        for op in COUNT_OPS:
            if key.endswith(op):
                break
        else:
            for op in SUFFIX_OPS:
                if key.endswith(op):
                    break
        # A bare path is plain equality and always legal; nothing to reject here.
        if key.strip() == "":
            err(f"{obj['id']}: derived '{name}' has an empty where key")


def validate_derived(obj):
    for name, pred in (obj.get("derived") or {}).items():
        if not isinstance(pred, dict):
            err(f"{obj['id']}: derived '{name}' is not a predicate map")
            continue
        op = pred.get("operator")
        if op not in DERIVED_OPERATORS:
            err(f"{obj['id']}: derived '{name}' uses unknown operator '{op}'")
        if op in ("any", "all", "count_gte", "count_lte", "exists", "equals", "select_max", "field") and not pred.get("source"):
            err(f"{obj['id']}: derived '{name}' ({op}) needs a source")
        if op in ("and", "or", "not", "sum", "subtract", "gt", "gte", "lt", "lte") and pred.get("of") is None:
            err(f"{obj['id']}: derived '{name}' ({op}) needs an 'of' list")
        validate_where(obj, name, pred.get("where"))


def validate_rules(obj, outputs_by_id):
    seen_priorities = set()
    for r in obj.get("rules", []):
        pr = r.get("priority")
        if pr in seen_priorities:
            err(f"{obj['id']}: duplicate rule priority {pr}")
        seen_priorities.add(pr)

        has_when = "when" in r
        is_fallback = r.get("fallback") is True
        if has_when == is_fallback:
            err(f"{obj['id']}: rule {pr} must have exactly one of 'when' or 'fallback: true'")
        if is_fallback and has_when:
            err(f"{obj['id']}: fallback rule {pr} may not carry a 'when'")

        mode = r.get("mode", "both")
        if mode not in ("gate", "standalone", "both"):
            err(f"{obj['id']}: rule {pr} has invalid mode '{mode}'")

        res = r.get("result") or {}
        forms = [k for k in ("output_ref", "external_output_ref", "pass_through", "confidence") if k in res]
        if len(forms) != 1:
            err(f"{obj['id']}: rule {pr} must carry exactly one result form, found {forms}")

        if "output_ref" in res and res["output_ref"] not in obj.get("outputs", {}):
            err(f"{obj['id']}: rule {pr} points at unknown local output '{res['output_ref']}'")
        if "external_output_ref" in res:
            e = res["external_output_ref"]
            tgt, ref = e.get("object_id"), e.get("output_ref")
            if tgt not in outputs_by_id:
                err(f"{obj['id']}: rule {pr} points at unknown object '{tgt}'")
            elif ref not in outputs_by_id[tgt]:
                err(f"{obj['id']}: rule {pr} points at unknown output '{tgt}.{ref}'")

        input_names = {i["name"] for i in obj.get("inputs", [])}
        for field in res.get("reports_missing") or []:
            if field not in input_names:
                err(f"{obj['id']}: rule {pr} reports_missing names unknown input '{field}'")
        for field in (res.get("missing_input_effect") or {}):
            if field not in input_names:
                err(f"{obj['id']}: rule {pr} missing_input_effect names unknown input '{field}'")


def detect_cycles(catalog):
    """External output refs must form a DAG. A cycle would make evaluation non-terminating."""
    graph = {}
    for obj in catalog["objects"]:
        targets = set()
        for r in obj.get("rules", []):
            e = (r.get("result") or {}).get("external_output_ref")
            if e:
                targets.add(e["object_id"])
        graph[obj["id"]] = targets

    WHITE, GREY, BLACK = 0, 1, 2
    colour = {k: WHITE for k in graph}
    cycles = []

    def visit(node, path):
        colour[node] = GREY
        for nxt in sorted(graph.get(node, ())):
            if colour.get(nxt) == GREY:
                cycles.append(" -> ".join(path + [nxt]))
            elif colour.get(nxt) == WHITE:
                visit(nxt, path + [nxt])
        colour[node] = BLACK

    for node in sorted(graph):
        if colour[node] == WHITE:
            visit(node, [node])
    for c in cycles:
        err(f"external output ref cycle: {c}")
    return len(cycles)


def check_implicit_contextual(catalog):
    """HARD CONSTRAINT — no knowledge object may rely on implicit contextual resolution.

    Schema v0.4 says a `contextual` input is material when no still-applicable rule can
    resolve without it, and secondary when one can. The evaluator does NOT compute that
    yet: it resolves a reported contextual field to `material` unless the firing rule
    carries an explicit `missing_input_effect`. That simplification is approved for the
    v0.4 catalog precisely because every case that is meant to be `secondary` says so
    explicitly, so nothing is being guessed.

    Until the full analysis is implemented, a new or edited object MUST NOT depend on the
    implicit path. Concretely: if you want `secondary`, declare it. Never assume the
    evaluator will infer it — it will silently give you `material`, which lowers
    confidence to `unknown` and can turn a usable recommendation into "cannot determine".

    This function lists every contextual field that currently resolves implicitly, so the
    set can never grow unnoticed. Run with --strict-materiality to turn them into build
    errors; that switch is what closes this constraint for good, once the catalog declares
    each case (or the evaluator learns the full computation).
    """
    implicit = []
    for obj in catalog["objects"]:
        by_name = {i["name"]: i for i in obj.get("inputs", [])}
        for r in obj.get("rules", []):
            res = r.get("result") or {}
            effects = res.get("missing_input_effect") or {}
            for field in res.get("reports_missing") or []:
                definition = by_name.get(field) or {}
                if definition.get("materiality") == "contextual" and field not in effects:
                    implicit.append("%s rule %s: %s" % (obj["id"], r.get("priority"), field))
    return implicit


def validate_copy(catalog, copy):
    en, nl = copy.get("enUS", {}), copy.get("nlNL", {})
    for obj in catalog["objects"]:
        for k in obj.get("copy_keys", []):
            if k not in en:
                err(f"{obj['id']}: copy key '{k}' missing from enUS")
            if k not in nl:
                err(f"{obj['id']}: copy key '{k}' missing from nlNL")
        # Every key an output actually renders must be declared in copy_keys.
        for ref, out in (obj.get("outputs") or {}).items():
            used = [out.get("title_key"), out.get("why_key"), out.get("first_action_key")]
            used += list(out.get("not_now_keys") or [])
            for k in used:
                if k and k not in obj.get("copy_keys", []):
                    err(f"{obj['id']}: output '{ref}' uses '{k}' which is not in copy_keys")


def validate(schema, catalog, mapping, copy):
    if str(schema.get("schema_version", "")).split(".")[0:2] != ["0", "5"]:
        err(f"schema version {schema.get('schema_version')} is not 0.5.x")
    if str(catalog.get("schema_version", "")).split(".")[0:2] != ["0", "5"]:
        err(f"catalog schema version {catalog.get('schema_version')} is not 0.5.x")

    mapping_keys, selectors = set(), {}
    for m in mapping.get("mappings", []):
        mapping_keys.add(m["mapping_key"])
        sel = m.get("request_selector")
        if sel and isinstance(sel.get("where"), dict) and "activity_id" in sel["where"]:
            selectors[m["mapping_key"]] = sel["where"]["activity_id"]

    required = set(schema.get("required", []))
    outputs_by_id = {o["id"]: set((o.get("outputs") or {}).keys()) for o in catalog["objects"]}

    ids = set()
    for obj in catalog["objects"]:
        oid = obj.get("id", "?")
        if oid in ids:
            err(f"duplicate object id {oid}")
        ids.add(oid)
        for f in sorted(required):
            if f not in obj:
                err(f"{oid}: missing required schema field '{f}'")
        if obj.get("status") not in schema["enums"]["status"]:
            err(f"{oid}: invalid status '{obj.get('status')}'")
        if obj.get("kind") not in schema["enums"]["kind"]:
            err(f"{oid}: invalid kind '{obj.get('kind')}'")
        if obj.get("source_status") not in schema["enums"]["source_status"]:
            err(f"{oid}: invalid source_status '{obj.get('source_status')}'")
        st = obj.get("staleness") or {}
        if st.get("on_stale") not in schema["enums"]["on_stale"]:
            err(f"{oid}: invalid on_stale '{st.get('on_stale')}'")
        for ref, out in (obj.get("outputs") or {}).items():
            if out.get("status") not in schema["enums"]["result_status"]:
                err(f"{oid}: output '{ref}' has invalid status '{out.get('status')}'")
            if out.get("confidence") not in schema["enums"]["confidence"]:
                err(f"{oid}: output '{ref}' has invalid confidence '{out.get('confidence')}'")

        subjects = validate_inputs(obj, mapping_keys, selectors)
        validate_derived(obj)
        validate_rules(obj, outputs_by_id)

        # Build-time derived field: which activity an activity_selector is about. The
        # timebox gate needs to know which activity to measure once a route is chosen.
        if obj.get("kind") == "activity_selector":
            if len(subjects) != 1:
                err(f"{oid}: activity_selector must reference exactly one activity_id, found {sorted(subjects)}")
            else:
                obj["_subject_activity_id"] = sorted(subjects)[0]

    cycles = detect_cycles(catalog)
    validate_copy(catalog, copy)
    return cycles


# ------------------------------------------------------------------ serialisation

LUA_ESCAPES = {"\\": "\\\\", '"': '\\"', "\n": "\\n", "\r": "\\r", "\t": "\\t"}


def lua_string(s: str) -> str:
    out = []
    for ch in s:
        if ch in LUA_ESCAPES:
            out.append(LUA_ESCAPES[ch])
        elif ord(ch) < 32:
            out.append("\\%d" % ord(ch))
        else:
            out.append(ch)
    return '"' + "".join(out) + '"'


def lua_key(k: str) -> str:
    ok = k and (k[0].isalpha() or k[0] == "_") and all(c.isalnum() or c == "_" for c in k)
    return k if ok else "[" + lua_string(k) + "]"


def to_lua(value, indent: int = 1) -> str:
    """Deterministic Lua literal. Keys are sorted, so the same input always gives the
    same bytes — a diff on the generated file always means the source really changed.

    JSON/YAML null becomes the NULL sentinel rather than nil: a nil value would drop the
    key from the table entirely, and 'present but unknown' would become indistinguishable
    from 'absent'. Both mean unknown to the evaluator, but only one of them is a lie about
    what the source said."""
    pad = "\t" * indent
    closing = "\t" * (indent - 1)

    if value is None:
        return "NULL"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, str):
        return lua_string(value)
    if isinstance(value, list):
        if not value:
            return "{}"
        parts = [pad + to_lua(v, indent + 1) + "," for v in value]
        return "{\n" + "\n".join(parts) + "\n" + closing + "}"
    if isinstance(value, dict):
        if not value:
            return "{}"
        parts = []
        for k in sorted(value.keys(), key=str):
            parts.append(pad + lua_key(str(k)) + " = " + to_lua(value[k], indent + 1) + ",")
        return "{\n" + "\n".join(parts) + "\n" + closing + "}"
    raise TypeError("cannot serialise %r" % type(value))


HEADER = """--[[
\t{title}

\tGENERATED FILE — DO NOT EDIT BY HAND.
\tSource:    docs/knowledge_proposal_v0.4/{source}
\tGenerator: tools/build_knowledge.py
\tRegenerate with:  python tools/build_knowledge.py

\tEdits here are lost on the next build. Change the upstream YAML instead.
{extra}]]
"""


def write_atomic(path: str, text: str) -> None:
    """The repo IS the live AddOns folder. A plain open(w) truncates first, so a login in
    that window sees a half-written file — that is how raw locale keys once reached Rob's
    Great Vault popup. os.replace is atomic: the game sees the old file or the new one."""
    io.open(path + ".tmp", "w", encoding="utf-8", newline="").write(text)
    os.replace(path + ".tmp", path)


def emit_data(catalog, mapping) -> str:
    # CATALOG ORDER, deliberately not sorted by id. The pipeline walks this array, and the
    # order is semantic: WEEKLY-POWER must get its turn before RITUAL-TIER, because its
    # rule 2 hands off to the ritual selector with pass_through. Sorting by id put RITUAL
    # first and reversed the two ids in fixture 09's stale list — determinism comes from
    # the source file being ordered, not from re-sorting it here.
    objects = list(catalog["objects"])
    mapping_by_key = {m["mapping_key"]: m for m in mapping.get("mappings", [])}
    body = [
        HEADER.format(
            title="Midnight Helper — Knowledge Objects, Season 1 (RFC-002)",
            source="normalized_ko_catalog_v0.4.yaml",
            extra="\n\tNOT REGISTERED IN MidnightHelper.toc ON PURPOSE. Implementation phase 1 is\n"
                  "\tbuild-and-test only: nothing here reaches a player yet, and every object still\n"
                  "\tcarries status = \"review\", which means not player-visible.\n",
        ),
        "",
        "local _, ns = ...",
        "ns = ns or {}",
        "",
        "-- Sentinel for an upstream null. Distinct from nil so that \"present but unknown\"",
        "-- survives the trip into Lua; both mean unknown to the evaluator.",
        "local NULL = setmetatable({}, { __tostring = function() return \"null\" end })",
        "",
        "local Knowledge = {",
        "\tNULL = NULL,",
        "\tschemaVersion = " + lua_string(str(catalog.get("schema_version"))) + ",",
        "\tcatalogVersion = " + lua_string(str(catalog.get("catalog_version"))) + ",",
        "\t-- request_mapping v0.2, verbatim. The evaluator resolves every KO input name",
        "\t-- through this table; there is no naming convention it may fall back on.",
        "\trequestMapping = " + to_lua(mapping_by_key, 2) + ",",
        "\tobjects = {",
    ]
    for obj in objects:
        body.append("\t\t" + to_lua(obj, 3) + ",")
    body += [
        "\t},",
        "}",
        "",
        "-- Index by id, built once. Order of `objects` is the catalog order and is what the",
        "-- pipeline walks; byId is only for external ref resolution.",
        "Knowledge.byId = {}",
        "for i = 1, #Knowledge.objects do",
        "\tKnowledge.byId[Knowledge.objects[i].id] = Knowledge.objects[i]",
        "end",
        "",
        "ns.KnowledgeData = Knowledge",
        "return Knowledge",
        "",
    ]
    return "\n".join(body)


def emit_fixtures(fixtures) -> str:
    body = [
        HEADER.format(
            title="Midnight Helper — Knowledge fixture corpus (RFC-002 phase 2)",
            source="fixtures_full_v0.4.json",
            extra="\n\tTest data only. Lives in tools/ so it never ships: tools/ is excluded from the\n"
                  "\trelease zip by .pkgmeta and by tools/package.ps1.\n",
        ),
        "",
        "-- Returns a builder so the caller injects ITS null sentinel. Both this corpus and",
        "-- KnowledgeData_S1 have to agree on one null identity, and passing it in is the only",
        "-- way to guarantee that without a shared global.",
        "return function(NULL)",
        "\tlocal fixtures = {",
    ]
    for f in fixtures["fixtures"]:
        body.append("\t\t" + to_lua(f, 3) + ",")
    body += [
        "\t}",
        "\treturn { schemaVersion = "
        + lua_string(str(fixtures.get("schema_version")))
        + ", fixtures = fixtures }",
        "end",
        "",
    ]
    return "\n".join(body)


def main() -> int:
    check_only = "--check" in sys.argv
    strict_materiality = "--strict-materiality" in sys.argv
    schema, catalog, mapping, copy, fixtures = load_all()
    cycles = validate(schema, catalog, mapping, copy)
    implicit = check_implicit_contextual(catalog)

    print("Midnight Helper — knowledge transpiler")
    print("  objects   : %d" % len(catalog["objects"]))
    print("  fixtures  : %d" % len(fixtures["fixtures"]))
    print("  copy keys : %d enUS / %d nlNL" % (len(copy["enUS"]), len(copy["nlNL"])))
    print("  cycles    : %d" % cycles)

    if implicit:
        print("  contextual fields resolving IMPLICITLY to material: %d" % len(implicit))
        for line in implicit:
            print("      " + line)
        print("      HARD CONSTRAINT: a knowledge object may not RELY on this. Declare")
        print("      missing_input_effect when you mean secondary — the evaluator does not")
        print("      infer it yet and will give you material. See check_implicit_contextual.")
        if strict_materiality:
            for line in implicit:
                err("implicit contextual resolution (--strict-materiality): " + line)

    if errors:
        print("\nBUILD FAILED — %d problem(s):" % len(errors))
        for e in errors:
            print("  " + e)
        return 1

    print("  validation: OK")
    if check_only:
        print("\n--check: nothing written.")
        return 0

    write_atomic(OUT_DATA, emit_data(catalog, mapping))
    write_atomic(OUT_FIXTURES, emit_fixtures(fixtures))
    print("\nwrote %s" % os.path.relpath(OUT_DATA, ROOT).replace("\\", "/"))
    print("wrote %s" % os.path.relpath(OUT_FIXTURES, ROOT).replace("\\", "/"))
    return 0


if __name__ == "__main__":
    sys.exit(main())
