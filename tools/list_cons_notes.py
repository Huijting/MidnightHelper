import re
from pathlib import Path
t = Path("Modules/ConsumablesWowheadData.lua").read_text(encoding="utf-8")
notes = sorted(set(re.findall(r'noteEn = "([^"]+)"', t)))
print(len(notes))
for n in notes:
    print("---")
    print(n)
