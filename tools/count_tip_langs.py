import pathlib, re

p = pathlib.Path(__file__).resolve().parents[1] / "Addons" / "GuideData.lua"
t = p.read_text(encoding="utf-8")
pat = re.compile(r"\{\s*spell\s*=\s*\d+\s*,\s*text\s*=\s*\"((?:[^\"\\]|\\.)*)\"\s*\}")
dutch = eng = mixed = 0
for m in pat.finditer(t):
    s = m.group(1).replace("\\n", "\n").replace('\\"', '"')
    is_dutch = bool(re.search(r"\b(Gebruik|Houd | je | voor | niet |schade|vijand|altijd|handig)\b", s))
    is_eng = bool(re.search(r"\b(the |your |Your |Use |Keep |For |damage)\b", s))
    if is_dutch:
        dutch += 1
    elif is_eng:
        eng += 1
    else:
        mixed += 1
print("tips", dutch + eng + mixed, "dutch-ish", dutch, "english-ish", eng, "other", mixed)
