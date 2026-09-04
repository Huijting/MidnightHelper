@echo off
setlocal
rem One-click copy of the MidnightHelper repo to EVERY installed PTR AddOns folder.
rem Lives in tools\ (excluded from the CurseForge package). Wraps sync_to_wow.ps1
rem (robocopy, skips .git).
rem
rem There are two PTR installs and they are different patches -- measured 4 Sep 2026
rem from .build.info: _ptr_ (wowt) is 12.1.0.69587, _xptr_ (wowxptr) is 12.1.5.69594.
rem This script used to feed only _ptr_, so anything meant for the 12.1.5 client
rem silently landed on the wrong build. Each folder is skipped if it is not installed,
rem so this stays one fixed command line with no arguments (see CLAUDE.md).

set "TOOLS=%~dp0"
set "WOW=E:\World of Warcraft"
set "FAILED="

if exist "%WOW%\_ptr_\WowT.exe" (
	echo === PTR  _ptr_   ^(12.1.0 at time of writing^)
	if not exist "%WOW%\_ptr_\Interface\AddOns\MidnightHelper" mkdir "%WOW%\_ptr_\Interface\AddOns\MidnightHelper"
	powershell -NoProfile -ExecutionPolicy Bypass -File "%TOOLS%sync_to_wow.ps1" -RepoRoot "%TOOLS%.." -WowAddOnDir "%WOW%\_ptr_\Interface\AddOns\MidnightHelper"
	if errorlevel 1 set "FAILED=1"
	echo.
)

if exist "%WOW%\_xptr_\WowT.exe" (
	echo === PTR  _xptr_  ^(12.1.5 at time of writing^)
	if not exist "%WOW%\_xptr_\Interface\AddOns\MidnightHelper" mkdir "%WOW%\_xptr_\Interface\AddOns\MidnightHelper"
	powershell -NoProfile -ExecutionPolicy Bypass -File "%TOOLS%sync_to_wow.ps1" -RepoRoot "%TOOLS%.." -WowAddOnDir "%WOW%\_xptr_\Interface\AddOns\MidnightHelper"
	if errorlevel 1 set "FAILED=1"
	echo.
)

if defined FAILED (
	echo Copy FAILED for at least one PTR - see the messages above.
	pause
	exit /b 1
)

echo.
echo Done. In the PTR client: enable "Load out of date AddOns" at character
echo select ^(the PTR runs a higher interface than the .toc^), then /reload.
pause
