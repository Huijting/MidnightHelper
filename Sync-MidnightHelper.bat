@echo off
setlocal

REM One-click sync: git pull + robocopy -> WoW AddOns.
REM This calls the PowerShell script in tools/.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\sync_to_wow.ps1" -Pull

echo.
echo Done. In WoW run: /reload
pause

