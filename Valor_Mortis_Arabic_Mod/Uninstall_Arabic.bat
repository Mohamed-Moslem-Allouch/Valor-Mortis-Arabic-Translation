@echo off
setlocal EnableDelayedExpansion
title Valor Mortis - Restore Original Game Files
color 0E

echo ==============================================================
echo       VALOR MORTIS - RESTORE ORIGINAL GAME FILES
echo ==============================================================
echo.

cd /d "%~dp0"

if exist "ValorMortis\Content\Paks\pakchunk0-Windows.pak" goto :PaksRoot
if exist "Content\Paks\pakchunk0-Windows.pak" goto :PaksSub
if exist "pakchunk0-Windows.pak" goto :PaksHere

color 0C
echo [ERROR] Could not find pakchunk0-Windows.pak!
echo Please make sure this file is placed in the game folder.
echo.
pause
exit /b 1

:PaksRoot
set "PAKS_DIR=ValorMortis\Content\Paks"
goto :FoundPaks

:PaksSub
set "PAKS_DIR=Content\Paks"
goto :FoundPaks

:PaksHere
set "PAKS_DIR=."
goto :FoundPaks

:FoundPaks
set "TARGET_PAK=%PAKS_DIR%\pakchunk0-Windows.pak"
set "BACKUP_PAK=%PAKS_DIR%\pakchunk0-Windows.pak.original"

if not exist "%BACKUP_PAK%" goto :NoBackup
echo Restoring original pakchunk0-Windows.pak...
copy /y "%BACKUP_PAK%" "%TARGET_PAK%" >nul
echo Original file restored successfully!
goto :CleanMods

:NoBackup
echo [WARNING] No backup file found (%BACKUP_PAK%).

:CleanMods
echo Removing Arabic UI modules...
del /q "%PAKS_DIR%\pakchunk99-Arabic*.pak" 2>nul
del /q "%PAKS_DIR%\pakchunk99-Arabic*.ucas" 2>nul
del /q "%PAKS_DIR%\pakchunk99-Arabic*.utoc" 2>nul

color 0A
echo.
echo ==============================================================
echo [SUCCESS] Restored original game files successfully!
echo ==============================================================
echo.
pause
