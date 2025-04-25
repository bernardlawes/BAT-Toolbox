@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0launch.ps1"
echo.
echo If you saw any red error text, something failed.
echo.
pause

REM @echo off
REM powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0launch.ps1"