"""Scratch script — rewritten per task, always run as tools/_probe.py.

Right now: the Shaman's UI probe — can a stance bar and a pet bar be up together?
"""
import subprocess

LUA = r'C:\Users\RobHu\AppData\Local\Programs\Lua\bin\lua.exe'
SV = (r'E:/World of Warcraft/_retail_/WTF/Account/JOEYWHATEVER/'
      r'SavedVariables/MidnightHelper.lua')

script = r'''
local chunk = assert(loadfile([[__SV__]])); chunk()
local u = MidnightHelperDB.barInventory and MidnightHelperDB.barInventory.ui
if not u then print("geen ui-blok") return end
local keys = {}
for k in pairs(u) do if k ~= "systemNames" then keys[#keys+1] = k end end
table.sort(keys)
for _, k in ipairs(keys) do
  print(string.format("   %-30s %s", k, tostring(u[k])))
end
'''.replace('__SV__', SV)

r = subprocess.run([LUA, '-e', script], capture_output=True, text=True,
                   encoding='utf-8', errors='replace')
print(r.stdout)
if r.stderr.strip():
    print('STDERR:', r.stderr[:600])
