"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: where did each bar system sit before the import, and where does the
transplanted one put it? Systems 11/12/13 are the non-numbered bars (pet, stance, extra).
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local db = MidnightHelperDB
local snap
for _, b in ipairs(db.editModeBackups or {}) do
  if b.label == "before-bars-import" then snap = b break end
end
if not snap then print("geen pre-import opname") return end

local function bars(layout)
  local out = {}
  for _, s in ipairs((layout and layout.systems) or {}) do
    if s.system == 0 then out[s.systemIndex] = s end
  end
  return out
end

local function anchor(s)
  local a = s and s.anchorInfo
  if not a then return "?" end
  return string.format("%s -> %s  x=%s y=%s",
    tostring(a.point), tostring(a.relativeTo), tostring(a.offsetX), tostring(a.offsetY))
end

local layouts = snap.data and snap.data.layouts or {}
local src, dst
for _, l in ipairs(layouts) do
  if l.layoutName == "MH V0.1" then src = l end
  if l.layoutName == "test 2" then dst = l end
end
if not (src and dst) then print("layouts niet gevonden in de opname") return end

local a, b = bars(src), bars(dst)
local idx = {}
for i in pairs(a) do idx[#idx+1] = i end
for i in pairs(b) do if not a[i] then idx[#idx+1] = i end end
table.sort(idx)

print("index | van (Mage, wordt gekopieerd)            | naar (Hunter, zoals het was)")
for _, i in ipairs(idx) do
  local same = a[i] and b[i] and anchor(a[i]) == anchor(b[i])
  print(string.format("%5s | %-40s | %s%s", tostring(i),
    anchor(a[i]), anchor(b[i]), same and "   [gelijk]" or "   <-- VERSCHUIFT"))
end
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
