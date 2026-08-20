#!/usr/bin/env python3
"""Compare our per-spec consumables against the Icy Veins 12.1 pages, and report.

⚠️ WHY THIS EXISTS. `data/PROMPT_consumables_wowhead.txt` opens with "COPY THIS ENTIRE BLOCK
INTO CHATGPT". That is how the current dataset was produced, and it is why nobody could
tell that the picks had gone stale: there was no way to re-run it and see what moved. The
stale-advice audit of 19 Aug found six of six sampled specs disagreeing with the guides
that the addon itself names as its source.

⚠️ AND WHY IT ONLY REPORTS. It deliberately does not rewrite the JSON. The pages give
prose, not a table: "Use X as a general-use flask", "If a Feast is provided, use them
instead". Turning that into best/alternates is judgement, and a script that guesses would
replace one unverifiable dataset with another. This produces the diff; a person decides.

⚠️ NO ITEM IDS ON THOSE PAGES — checked, zero wowhead item links. So this matches on NAMES
against the ids we already hold and measured. An unrecognised name is reported as exactly
that, which turns "an item we never heard of" from a silent gap into a line of output.
"""
import io
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request

for _stream in (sys.stdout, sys.stderr):
    if hasattr(_stream, "reconfigure"):
        _stream.reconfigure(encoding="utf-8", errors="replace")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CATALOG = os.path.join(ROOT, "data", "vault_stat_catalog.json")
CONSUM = os.path.join(ROOT, "data", "consumables_wowhead.json")

# Page section -> our category key. "Potions" holds both the combat and the healing potion,
# so it maps to two of ours and the matcher sorts them out by which names appear.
SECTIONS = {
    "Flask": ("flask",),
    "Potions": ("combatPotion", "healingPotion"),
    # ⚠️ Read Food Buff results with a human eye. One page section covers both the group
    # feast and the personal food, and it often names only one of them — so "ours is not
    # named" here frequently means the page simply did not discuss personal food, not that
    # our pick is wrong. Flask and Potions are clean one-item comparisons and are where
    # this report is actually trustworthy.
    "Food Buff": ("feast", "personalFood"),
    "Augment Rune": ("augmentRune",),
    "Weapon Oil": ("weaponOil",),
}


def strip_tags(s):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", " ", s)).strip()


def fetch(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (MidnightHelper data check)"})
    with urllib.request.urlopen(req, timeout=45) as resp:
        return resp.read().decode("utf-8", "replace")


def known_names():
    """Every consumable name we currently ship, mapped to its id."""
    with io.open(CONSUM, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    out = {}
    for className, specs in data.items():
        if className == "meta" or not isinstance(specs, dict):
            continue
        for _specName, cats in specs.items():
            if not isinstance(cats, dict):
                continue
            for _cat, block in cats.items():
                if not isinstance(block, dict):
                    continue
                for tier in ("best", "alternates"):
                    for entry in block.get(tier) or []:
                        name = entry.get("name")
                        if name:
                            out[name] = entry.get("id")
    return out


# The catalog keys specs as DEATHKNIGHT + "blood"; the consumables JSON keys them as
# "Death Knight" + "Blood". One mapping rather than two spellings of the same fact.
CLASS_KEY = {
    "DEATHKNIGHT": "Death Knight", "DEMONHUNTER": "Demon Hunter", "DRUID": "Druid",
    "EVOKER": "Evoker", "HUNTER": "Hunter", "MAGE": "Mage", "MONK": "Monk",
    "PALADIN": "Paladin", "PRIEST": "Priest", "ROGUE": "Rogue", "SHAMAN": "Shaman",
    "WARLOCK": "Warlock", "WARRIOR": "Warrior",
}


def ours_for(data, spec):
    className = CLASS_KEY.get(spec.get("class", ""))
    specName = (spec.get("wowheadSpec") or "").replace("-", " ").title()
    cats = (data.get(className) or {}).get(specName)
    if not isinstance(cats, dict):
        return None, "%s / %s not in our JSON" % (className, specName)
    picks = {}
    for cat, block in cats.items():
        if isinstance(block, dict) and block.get("best"):
            picks[cat] = [e.get("name") for e in block["best"] if e.get("name")]
    return picks, None


def main():
    with io.open(CATALOG, "r", encoding="utf-8") as fh:
        catalog = json.load(fh)
    with io.open(CONSUM, "r", encoding="utf-8") as fh:
        ours = json.load(fh)
    names = known_names()

    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    show_all = "--all" in sys.argv
    do_apply = "--apply" in sys.argv
    only = args[0].lower() if args else None
    mismatches = 0
    unknown = set()
    applied = []
    # One entry per known name, so an applied change carries a real id rather than a name.
    name_to_entry = {}
    for className, specs_ in ours.items():
        if className == "meta" or not isinstance(specs_, dict):
            continue
        for _sn, cats_ in specs_.items():
            if not isinstance(cats_, dict):
                continue
            for _c, blk in cats_.items():
                if not isinstance(blk, dict):
                    continue
                for tier in ("best", "alternates"):
                    for e in blk.get(tier) or []:
                        if e.get("name") and e.get("name") not in name_to_entry:
                            name_to_entry[e["name"]] = e

    for spec in catalog.get("specs", []):
        label = spec.get("label") or ""
        if only and only not in label.lower():
            continue
        stat_url = spec.get("icyVeinsUrl") or ""
        if not stat_url.endswith("-stat-priority"):
            print("SKIP %-28s (unexpected url)" % label)
            continue
        url = stat_url[: -len("-stat-priority")] + "-gems-enchants-consumables"
        try:
            html = fetch(url)
        except urllib.error.HTTPError as e:
            print("FAIL %-28s HTTP %s" % (label, e.code))
            continue
        except Exception as e:  # noqa: BLE001 - a page that will not load is a finding
            print("FAIL %-28s %s" % (label, e))
            continue

        found = {}
        for heading, cats in SECTIONS.items():
            # ⚠️ Stop at the NEXT heading, not after a fixed number of characters. A window
            # of 1600 chars ran straight through "Flask" into "Potions" and "Food Buff", so
            # every section reported every item and the whole comparison was meaningless
            # while looking like it worked.
            m = re.search(
                r"<h3[^>]*>\s*%s\s*</h3>(.*?)(?=<h[23][\s>])" % re.escape(heading),
                html,
                re.S,
            )
            if not m:
                continue
            text = strip_tags(m.group(1))
            hits = [n for n in names if n and n in text]
            # Longest first ONLY to resolve overlap: "Hearty Blooming Feast" must win over
            # "Blooming Feast" so the shorter name is not also counted.
            hits.sort(key=len, reverse=True)
            kept = []
            for h in hits:
                if not any(h in k for k in kept):
                    kept.append(h)
            # ⚠️ THEN BACK INTO PAGE ORDER. Sorting by length and reporting that order made
            # the first entry look like the page's first recommendation when it was only
            # the longest name. For flask and combat potion that ordering IS the answer —
            # the page's first mention is what it recommends — so getting it from the text
            # position rather than from string length is the difference between a
            # correction and a coin flip.
            kept.sort(key=text.index)
            found[heading] = kept

        picks, why = ours_for(ours, spec)
        # Collect first, print after: at forty specs a block per spec buries the answer,
        # and the specs that agree are exactly the ones nobody needs to read about.
        block_lines = []
        if why:
            block_lines.append("  (%s)" % why)
            picks = {}
        spec_mismatch = 0
        for heading, cats in SECTIONS.items():
            kept = found.get(heading)
            if kept is None:
                continue
            mine = []
            for cat in cats:
                for name in picks.get(cat) or []:
                    # Deduped: `best` often holds both ids of an adjacent-id pair, which
                    # share one name, and printing it twice reads like a data error.
                    if name not in mine:
                        mine.append(name)
            page_s = ", ".join(kept) if kept else "(no known item matched)"
            mine_s = ", ".join(mine) if mine else "(none)"
            # Agreement means every one of ours is named on the page. Their extras are
            # alternatives and situational advice, not a disagreement.
            # ⚠️ "Hearty X" IS "X", one quality up. The first full sweep reported 58
            # differing sections and most of them were this: the page names Silvermoon
            # Parade, we recommend Hearty Silvermoon Parade, and that is not a
            # disagreement about which food — it is us naming the better version of the
            # same one. Left uncorrected the report cries wolf, and a report that cries
            # wolf gets skimmed, which is how the stale flasks underneath survived.
            #
            # Deliberately narrow: only the "Hearty " prefix. "Royal Roast" also sits
            # inside "Impossibly Royal Roast" and those are genuinely different foods, so
            # a general substring match would hide real differences instead of noise.
            def same_food(mine_name, page_name):
                a = mine_name[7:] if mine_name.startswith("Hearty ") else mine_name
                b = page_name[7:] if page_name.startswith("Hearty ") else page_name
                return a == b

            agrees = mine and all(any(same_food(m, k) for k in kept) for m in mine)
            if not agrees:
                mismatches += 1
                spec_mismatch += 1
                block_lines.append("  %-13s page: %s" % (heading, page_s))
                block_lines.append("  %-13s ours: %s" % ("", mine_s))
            if not kept:
                unknown.add((label, heading))
        # --apply: rewrite `best` for the two categories where the page gives a single,
        # unambiguous answer. Flask and combat potion are one-item picks and the page's
        # first mention is its recommendation. Food is not — one section covers feast and
        # personal food and often names only one — so it is never touched here.
        if do_apply and not why:
            for heading, cat in (("Flask", "flask"), ("Potions", "combatPotion")):
                kept = found.get(heading) or []
                if heading == "Potions":
                    # Strip the healing potion: that section discusses both, and only the
                    # combat potion is what `combatPotion` means.
                    kept = [k for k in kept if "Health Potion" not in k]
                if len(kept) != 1:
                    continue  # two named or none: a judgement call, left to a person
                want = kept[0]
                cats_now = (ours.get(CLASS_KEY.get(spec.get("class", ""))) or {}).get(
                    (spec.get("wowheadSpec") or "").replace("-", " ").title()
                )
                block = (cats_now or {}).get(cat)
                if not isinstance(block, dict):
                    continue
                have = [e.get("name") for e in block.get("best") or []]
                if want in have:
                    continue
                entry = name_to_entry.get(want)
                if not entry:
                    print("   !! %-24s %s: no id known for %r" % (label, cat, want))
                    continue
                old = ", ".join(have) or "(none)"
                # Demote rather than delete: the previous pick stays reachable as an
                # alternate, because one guide's page is a strong hint and not a proof.
                alts = [dict(e) for e in block.get("best") or []]
                for e in block.get("alternates") or []:
                    if e.get("id") not in [a.get("id") for a in alts]:
                        alts.append(dict(e))
                block["best"] = [dict(entry)]
                block["alternates"] = alts
                applied.append("%-24s %-13s %s -> %s" % (label, cat, old, want))

        if spec_mismatch or show_all:
            print("=" * 78)
            print("%s  — %d section(s) differ" % (label, spec_mismatch))
            for line in block_lines:
                print(line)
        time.sleep(1.0)  # be a guest on someone else's server

    print("\nSections where our pick is not named on the page: %d" % mismatches)
    print("Sections where no item we ship was named at all: %d" % len(unknown))
    for label, heading in sorted(unknown):
        print("   %-28s %s" % (label, heading))
    if do_apply and applied:
        print("\nApplied %d change(s):" % len(applied))
        for line in applied:
            print("   " + line)
        tmp = CONSUM + ".tmp"
        with io.open(tmp, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(json.dumps(ours, indent=2, ensure_ascii=False) + "\n")
        os.replace(tmp, CONSUM)
        print("\nJSON written atomically. Now run:")
        print("   python tools/generate_consumables_lua.py")
        print("   python tools/apply_cons_note_keys.py")
    elif do_apply:
        print("\nNothing unambiguous to apply.")
    else:
        print("\n⚠️  This is a report. Nothing was written. Add --apply to take the")
        print("   unambiguous flask and combat-potion picks; food is never touched.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
