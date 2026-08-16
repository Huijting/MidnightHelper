#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Re-extract the delve Sturdy Chests from HandyNotes_Midnight, with a cross-check.

Rob, 16 aug 2026: "we zullen zeker de posities van HandyNotes zelf blijven checken
en indien mogelijk zelf toepassen om dingen sneller te doen."

⚠️ THIS FILE EXISTS BECAUSE tools/_probe.py DOES NOT SURVIVE. _probe.py is the
scratch script and gets rewritten for every task; the extractor that built
Modules/DelveChestData.lua lived there and would have been gone by the next
question. A tool you intend to run again is not a scratch script.

Run it after a HandyNotes update:

    python tools/delve_chests.py

It prints a ready-to-paste Lua table and, more usefully, a DIFF against what
Modules/DelveChestData.lua currently ships — so a HandyNotes correction shows up
as a line to act on instead of a table to re-read.

It does NOT write anything. Coordinates from another addon are candidates, and
the last step stays a human deciding to paste them.
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
HN = os.path.join(ADDONS, 'HandyNotes_Midnight', 'zones', 'delves.lua')
OURS = os.path.join(ADDONS, 'MidnightHelper', 'Modules', 'DelveChestData.lua')


def read(p):
    try:
        return io.open(p, encoding='utf-8', errors='replace').read()
    except OSError as e:
        print('kan %s niet lezen: %s' % (p, e))
        sys.exit(1)


def from_handynotes():
    t = read(HN)
    maps = {}
    for m in re.finditer(
            r'^local\s+(\w+)\s*=\s*Map\(\{id\s*=\s*(\d+).*?--\s*(.+?)\s*$', t, re.M):
        maps[m.group(1)] = (int(m.group(2)), m.group(3))

    out = {}
    for m in re.finditer(
            r'^(\w+)\.nodes\[(\d{8})\]\s*=\s*SturdyChest\(\{(.*?)\}\)', t, re.M | re.S):
        var, key, body = m.group(1), m.group(2), m.group(3)
        if var not in maps:
            continue
        mid, label = maps[var]
        q = re.search(r'quest\s*=\s*(\d+)', body)
        n = re.search(r'#(\d+)', body)
        out.setdefault(mid, {'label': label, 'rows': []})['rows'].append({
            'x': int(key[:4]) / 100.0, 'y': int(key[4:]) / 100.0,
            'quest': int(q.group(1)) if q else None,
            'n': int(n.group(1)) if n else 99,
        })
    for d in out.values():
        d['rows'].sort(key=lambda r: r['n'])
    return out


def from_ours():
    t = read(OURS)
    body = t[t.index('ns.DELVE_CHESTS = {'):]
    out, cur = {}, None
    for line in body.split('\n'):
        m = re.match(r'\s*\[(\d+)\]\s*=\s*\{', line)
        if m:
            cur = int(m.group(1))
            out[cur] = []
            continue
        m = re.match(r'\s*\{\s*x\s*=\s*([\d.]+),\s*y\s*=\s*([\d.]+),\s*quest\s*=\s*(\d+|nil)',
                     line)
        if m and cur:
            out[cur].append({
                'x': float(m.group(1)), 'y': float(m.group(2)),
                'quest': None if m.group(3) == 'nil' else int(m.group(3)),
            })
        if line.strip() == '}' and cur:
            cur = None
    return out


hn, ours = from_handynotes(), from_ours()

print('=' * 74)
print('DIFF — wat er veranderd is sinds Modules/DelveChestData.lua geschreven werd')
print('=' * 74)
changed = 0
for mid in sorted(set(hn) | set(ours)):
    h = hn.get(mid, {}).get('rows', [])
    o = ours.get(mid, [])
    label = hn.get(mid, {}).get('label', '?')
    if mid not in ours:
        print('NIEUWE KAART %s (%s) met %d kist(en)' % (mid, label, len(h)))
        changed += 1
        continue
    if mid not in hn:
        print('KAART %s staat bij ons maar niet meer in HandyNotes' % mid)
        changed += 1
        continue
    if len(h) != len(o):
        print('KAART %s (%s): wij %d kisten, HandyNotes %d' % (mid, label, len(o), len(h)))
        changed += 1
    for i in range(min(len(h), len(o))):
        a, b = o[i], h[i]
        if abs(a['x'] - b['x']) > 0.02 or abs(a['y'] - b['y']) > 0.02:
            print('KAART %s #%d verplaatst: wij %.2f/%.2f -> HandyNotes %.2f/%.2f'
                  % (mid, i + 1, a['x'], a['y'], b['x'], b['y']))
            changed += 1
        if a['quest'] != b['quest']:
            print('KAART %s #%d quest: wij %s -> HandyNotes %s'
                  % (mid, i + 1, a['quest'], b['quest']))
            changed += 1
if not changed:
    print('niets — onze tabel komt overeen met HandyNotes.')
print()

print('=' * 74)
print('Huidige HandyNotes-data als Lua (alleen plakken als de diff erom vraagt)')
print('=' * 74)
for mid in sorted(hn):
    d = hn[mid]
    print('\t[%d] = { -- %s' % (mid, d['label']))
    for r in d['rows']:
        print('\t\t{ x = %5.2f, y = %5.2f, quest = %s },'
              % (r['x'], r['y'], r['quest'] if r['quest'] else 'nil'))
    print('\t},')
print()
print('%d kaarten, %d kisten' % (len(hn), sum(len(d['rows']) for d in hn.values())))
