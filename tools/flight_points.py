#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Harvest every flight point from Zygor, keyed by uiMapID, with a diff.

Rob, 16 aug 2026: "als ik ergens anders sta wil ik ook de snelste route." Our
FLIGHT_POINTS covers 23 stops across the 12.x zones; Zygor ships the whole game.

⚠️ THE JOIN IS THE RISKY PART, so it is done from data and not by hand.
LibTaxi keys its stops by Zygor's own map NAME ("Silvermoon City M",
"Atal Aman M/1") and MH keys everything by uiMapID. LibRover carries the
translation — ["Silvermoon City M"] = {[0]=2393} — so the two are joined through
a third file that already agrees with both, instead of me matching zone names by
eye and being wrong about the ones that repeat across expansions.

A name that does not resolve is REPORTED AND DROPPED. Guessing a uiMapID puts a
flight master in the wrong hemisphere, and the player would only find out after
taking the flight.

Faction is kept. Sending an Alliance player to a Horde flight master is a
confident wrong answer, and the data says which is which.

Run after a Zygor update:

    python tools/flight_points.py

Prints a diff against Modules/FlightPointsData.lua and then the full table.
Writes nothing — pasting stays a decision.
"""
import io
import os
import re
import sys

for _s in (sys.stdout, sys.stderr):
    try:
        _s.reconfigure(encoding="utf-8", errors="replace")
    except (AttributeError, ValueError):
        pass

ADDONS = r'E:\World of Warcraft\_retail_\Interface\AddOns'
TAXI = os.path.join(ADDONS, 'ZygorGuidesViewer', 'Libs-Retail',
                    'LibTaxi-1.0', 'data.lua')
ROVER = os.path.join(ADDONS, 'ZygorGuidesViewer', 'Libs-Retail',
                     'LibRover-1.0', 'data.lua')
OURS = os.path.join(ADDONS, 'MidnightHelper', 'Modules', 'FlightPointsData.lua')


def read(p):
    try:
        return io.open(p, encoding='utf-8', errors='replace').read()
    except OSError as e:
        print('kan %s niet lezen: %s' % (p, e))
        sys.exit(1)


# ---- 1. name -> uiMapID, per floor ------------------------------------------
rover = read(ROVER)
name_to_map = {}
for m in re.finditer(r'^\["([^"]+)"\]\s*=\s*\{(.*?)\}\s*,?\s*$', rover, re.M):
    name, body = m.group(1), m.group(2)
    floors = {}
    for f in re.finditer(r'\[(\d+)\]\s*=\s*(\d+)', body):
        floors[int(f.group(1))] = int(f.group(2))
    if floors:
        name_to_map[name] = floors
print('LibRover: %d kaartnamen met een uiMapID' % len(name_to_map))


def resolve(zykey):
    """'Atal Aman M/1' -> uiMapID, honouring the floor suffix."""
    floor = 0
    base = zykey
    if '/' in zykey:
        base, _, f = zykey.rpartition('/')
        try:
            floor = int(f)
        except ValueError:
            base = zykey
    floors = name_to_map.get(base) or name_to_map.get(zykey)
    if not floors:
        return None
    return floors.get(floor) or floors.get(0) or next(iter(floors.values()))


# ---- 2. the taxi stops -------------------------------------------------------
taxi = read(TAXI)
blocks = re.findall(
    r"\['([^']+)'\]\s*=\s*\{(.*?)\n\s*\},", taxi, re.S)
print('LibTaxi: %d blokken' % len(blocks))

points, unresolved = {}, []
for zykey, body in blocks:
    mapID = resolve(zykey)
    rows = []
    for m in re.finditer(
            r'\{name="([^"]+)"\s*,\s*faction="(\w)"\s*,\s*npc="([^"]*)"'
            r'(?:\s*,\s*npcid=(\d+))?\s*,\s*x=([\d.]+)\s*,\s*y=([\d.]+)', body):
        rows.append({
            'name': m.group(1), 'faction': m.group(2), 'npc': m.group(3),
            'x': float(m.group(5)), 'y': float(m.group(6)),
        })
    if not rows:
        continue
    if not mapID:
        unresolved.append((zykey, len(rows)))
        continue
    points.setdefault(mapID, []).extend(rows)

print('opgelost: %d kaarten, %d punten' % (len(points), sum(len(v) for v in points.values())))
if unresolved:
    print()
    print('⚠️ NIET opgelost naar een uiMapID — bewust weggelaten, niet geraden:')
    for zykey, n in sorted(unresolved):
        print('   %-44s %d punt(en)' % (zykey, n))

# ---- 3. diff against what we ship -------------------------------------------
ours = read(OURS)
cur, curmap = {}, None
for line in ours.split('\n'):
    m = re.match(r'\s*\[(\d+)\]\s*=\s*\{', line)
    if m:
        curmap = int(m.group(1))
        cur[curmap] = []
        continue
    m = re.match(r'\s*\{\s*"([^"]+)"\s*,\s*([\d.]+)\s*,\s*([\d.]+)', line)
    if m and curmap:
        cur[curmap].append((m.group(1), float(m.group(2)), float(m.group(3))))

print()
print('=' * 74)
print('DIFF tegen Modules/FlightPointsData.lua')
print('=' * 74)
for mid in sorted(cur):
    have = {n for n, _, _ in cur[mid]}
    theirs = {r['name'] for r in points.get(mid, [])}
    missing = theirs - have
    extra = have - theirs
    if missing:
        print('kaart %-6s wij missen: %s' % (mid, ', '.join(sorted(missing))))
    if extra:
        print('kaart %-6s alleen bij ons: %s' % (mid, ', '.join(sorted(extra))))
newmaps = [m for m in points if m not in cur]
print('kaarten die wij helemaal niet hebben: %d' % len(newmaps))

print()
print('=' * 74)
print('Volledige tabel (uiMapID -> stops). Faction B = beide.')
print('=' * 74)
for mid in sorted(points):
    seen, rows = set(), []
    for r in sorted(points[mid], key=lambda r: r['name']):
        if r['name'] in seen:
            continue
        seen.add(r['name'])
        rows.append(r)
    print('\t[%d] = {' % mid)
    for r in rows:
        print('\t\t{ "%s", %.2f, %.2f, "%s" },' % (r['name'], r['x'], r['y'], r['faction']))
    print('\t},')
