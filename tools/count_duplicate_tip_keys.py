import collections
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]
t = (ROOT / "Addons" / "GuideData.lua").read_text(encoding="utf-8")
pat = re.compile(r'textKey\s*=\s*"(GUIDE_TIP_\d+)"')
c = collections.Counter(pat.findall(t))
dups = [k for k, v in c.items() if v > 1]
print("total tip refs", sum(c.values()))
print("unique keys", len(c))
print("duplicate keys", len(dups))
print("\n".join(dups[:40]))
