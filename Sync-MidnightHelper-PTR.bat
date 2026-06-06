@echo off
setlocal enabledelayedexpansion

REM One-click sync naar de PTR-client(s) (geen git pull).
REM Detecteert _ptr_ en _xptr_ (PTR 2) automatisch naast _retail_ en
REM synct naar elke gevonden installatie via tools\sync_to_wow.ps1.

set "GAMEROOT=%~dp0..\..\..\.."
set "SYNCED="

for %%D in (_ptr_ _xptr_) do (
	if exist "%GAMEROOT%\%%D\" (
		set "TARGET=%GAMEROOT%\%%D\Interface\AddOns\MidnightHelper"
		if not exist "!TARGET!" mkdir "!TARGET!"
		echo Sync naar %%D ...
		powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tools\sync_to_wow.ps1" -WowAddOnDir "!TARGET!"
		set "SYNCED=1"
	)
)

if not defined SYNCED (
	echo Geen PTR-installatie gevonden naast _retail_ ^(verwacht _ptr_ of _xptr_^).
	echo Installeer de PTR via Battle.net en run dit script opnieuw.
)

echo.
echo Klaar. In de PTR: /reload of herstart de client.
pause
