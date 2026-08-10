"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: what do the layoutType numbers mean, and what does the Paladin use?
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local db = MidnightHelperDB

print("Enum.EditModeLayoutType zoals de client hem geeft:")
local e = db.editModeEnum
if not e or not next(e) then
  print("   NIET GELEZEN")
else
  local keys = {}
  for k in pairs(e) do keys[#keys+1] = k end
  table.sort(keys, function(a,b) return (e[a] or 0) < (e[b] or 0) end)
  for _, k in ipairs(keys) do print(string.format("   %-12s = %s", k, tostring(e[k]))) end
end

print("")
local b = db.editModeBackups and db.editModeBackups[1]
if b then
  print("nieuwste momentopname:", tostring(b.label), " actieve index:", tostring(b.active))
  for i, l in ipairs((b.data and b.data.layouts) or {}) do
    print(string.format("   layout %d  %-16s type=%s", i, tostring(l.layoutName), tostring(l.layoutType)))
  end
end

print("")
print("beheerde vakjes per personage/spec:")
for key, slots in pairs(db.managedSlotsByChar or {}) do
  local n = 0
  for _ in pairs(slots) do n = n + 1 end
  print(string.format("   %-34s %d", key, n))
end
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
