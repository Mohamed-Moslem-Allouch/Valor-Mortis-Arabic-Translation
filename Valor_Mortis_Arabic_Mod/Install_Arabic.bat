@echo off
setlocal EnableDelayedExpansion
title Valor Mortis - Arabic Translation Patch
color 0B

echo ==============================================================
echo       VALOR MORTIS (2026) - ARABIC TRANSLATION PATCH
echo       Translated by: Mohamed Moslem Allouch
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
echo Found game files in: %PAKS_DIR%

if exist "%PAKS_DIR%\tools\repak.exe" goto :ToolsInPaks
if exist "ValorMortis\Content\Paks\tools\repak.exe" goto :ToolsInRootPaks
if exist "tools\repak.exe" goto :ToolsHere

color 0C
echo [ERROR] Could not find repak.exe or patch files!
echo Please make sure the mod files are extracted properly.
echo.
pause
exit /b 1

:ToolsInPaks
set "TOOLS_DIR=%PAKS_DIR%\tools"
set "PATCH_DIR=%PAKS_DIR%\patch_files"
goto :StartPatch

:ToolsInRootPaks
set "TOOLS_DIR=ValorMortis\Content\Paks\tools"
set "PATCH_DIR=ValorMortis\Content\Paks\patch_files"
goto :StartPatch

:ToolsHere
set "TOOLS_DIR=tools"
set "PATCH_DIR=patch_files"
goto :StartPatch

:StartPatch
set "TARGET_PAK=%PAKS_DIR%\pakchunk0-Windows.pak"
set "BACKUP_PAK=%PAKS_DIR%\pakchunk0-Windows.pak.original"

echo [1/3] Checking backup of original game files...
if exist "%BACKUP_PAK%" goto :BackupDone
copy /y "%TARGET_PAK%" "%BACKUP_PAK%" >nul
echo       Backup created: %BACKUP_PAK%
goto :DoPatch

:BackupDone
echo       Backup already exists: %BACKUP_PAK%

:DoPatch
echo.
echo [2/3] Extracting and patching Arabic localization and fonts...
set "STAGE=%TEMP%\VM_Arabic_Stage_%RANDOM%"
if exist "%STAGE%" rd /s /q "%STAGE%"
mkdir "%STAGE%"

"%TOOLS_DIR%\repak.exe" -a 0x2FA73CDEB02CDDB158A395F170D1D09F2D2084435B95EB8C2F06B974F95195C5 unpack -q -o "%STAGE%" "%BACKUP_PAK%"
if errorlevel 1 goto :UnpackError

xcopy /y /e /s "%PATCH_DIR%\*" "%STAGE%\" >nul

echo.
echo [3/3] Rebuilding Arabic game package (takes ~5 seconds)...
"%TOOLS_DIR%\repak.exe" pack -q --version V11 --path-hash-seed 4168632889 -m "../../../" --compression Oodle "%STAGE%" "%TARGET_PAK%.new"
if errorlevel 1 goto :PackError

move /y "%TARGET_PAK%.new" "%TARGET_PAK%" >nul
rd /s /q "%STAGE%"

color 0A
echo.
echo ==============================================================
echo [SUCCESS] Arabic Translation Installed Successfully!
echo ==============================================================
echo.
echo In-Game Activation:
echo  1. Launch the game.
echo  2. Open Settings -^> Language.
echo  3. Select 'Francais' (replaced with full Arabic).
echo.
echo Translated and edited by: Mohamed Moslem Allouch
echo ==============================================================
echo.
pause
exit /b 0

:UnpackError
color 0C
echo [ERROR] Failed to unpack pakchunk0-Windows.pak!
rd /s /q "%STAGE%"
pause
exit /b 1

:PackError
color 0C
echo [ERROR] Failed to pack new pakchunk0-Windows.pak!
rd /s /q "%STAGE%"
pause
exit /b 1
