"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: which keys point at an EMPTY slot on bars 1-6, and are they in the layout?
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local db = MidnightHelperDB
local b = db.barInventory
if not b then print("geen barInventory") return end

-- welke vakjes zijn gevuld?
local filled = {}
for _, s in ipairs(b.slots or {}) do filled[s.slot] = s.name or ("<" .. tostring(s.kind) .. ">") end

-- commando -> vakje
local cs = {}
for _, x in ipairs(b.buttonSlots or {}) do cs[x.command] = x.slot end

-- welke toetsen kent de layout?
local inLayout = {}
for _, l in ipairs((db.applyPlan and db.applyPlan.layout) or {}) do
  inLayout[tostring(l.key):upper():gsub("%+", "-")] = l.name
end

local function band(s)
  return s<=12 and 1 or (s>=61 and s<=72 and 2) or (s>=49 and s<=60 and 3)
    or (s>=25 and s<=36 and 4) or (s>=37 and s<=48 and 5) or (s>=145 and s<=156 and 6)
    or (s>=157 and s<=168 and 7) or (s>=169 and s<=180 and 8) or "buiten"
end

print("toetsen die naar een LEEG vakje op balk 1-6 wijzen:")
local n = 0
for _, x in ipairs(b.bindings or {}) do
  local slot = cs[x.command]
  local bar = slot and band(slot)
  if slot and type(bar) == "number" and bar <= 6 and not filled[slot] and x.key1 then
    n = n + 1
    local known = inLayout[x.key1] and ("in layout: " .. inLayout[x.key1]) or "NIET in de layout"
    print(string.format("   %-9s -> vakje %3d (balk %d)   %s", x.key1, slot, bar, known))
  end
end
if n == 0 then print("   geen") end
print("")
print("layout telt", #((db.applyPlan and db.applyPlan.layout) or {}), "toetsen")
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
