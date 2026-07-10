@echo off
REM Double-click me after running /mh shots and then /reload in WoW.
REM Cuts every screenshot down to exactly the Midnight Helper window.
REM Output lands in:  <WoW>\_retail_\Screenshots\mh-shots\

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Crop-Shots.ps1"

echo.
pause
