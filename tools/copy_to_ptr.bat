@echo off
setlocal
rem One-click copy of the MidnightHelper repo to the 12.1 PTR AddOns folder.
rem Lives in tools\ (excluded from the CurseForge package). Wraps sync_to_wow.ps1
rem (robocopy, skips .git). Edit PTR below if your PTR install is elsewhere.

set "TOOLS=%~dp0"
set "PTR=E:\World of Warcraft\_ptr_\Interface\AddOns\MidnightHelper"

if not exist "%PTR%" mkdir "%PTR%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%TOOLS%sync_to_wow.ps1" -RepoRoot "%TOOLS%.." -WowAddOnDir "%PTR%"
if errorlevel 1 (
	echo.
	echo Copy FAILED - see the message above.
	pause
	exit /b 1
)

echo.
echo Done. In the PTR client: enable "Load out of date AddOns" at character
echo select ^(the PTR runs a higher interface than the .toc^), then /reload.
pause
