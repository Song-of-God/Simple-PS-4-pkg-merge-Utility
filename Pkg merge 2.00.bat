@echo off
title PKG Merger - Simple Version
color 0A

echo ========================================
echo      PKG FILE MERGER - SIMPLE
echo ========================================
echo.
echo This version merges ALL .pkg files in
echo the SAME FOLDER as this batch file.
echo.
echo Make sure to:
echo 1. Put this .bat file in the folder with your PKG files
echo 2. Only keep the PKG files you want to merge
echo 3. Run this file
echo.
pause
echo.

REM Change to the directory where the batch file is located
cd /d "%~dp0"

REM Count PKG files
set count=0
for %%F in (*.pkg) do set /a count+=1

if %count%==0 (
    echo [ERROR] No .pkg files found in this folder!
    echo.
    echo Current folder: %CD%
    echo.
    pause
    exit /b 1
)

if %count% LSS 2 (
    echo [ERROR] Only found %count% PKG file.
    echo You need at least 2 files to merge!
    echo.
    pause
    exit /b 1
)

echo Found %count% PKG files in current folder:
echo.
for %%F in (*.pkg) do echo - %%F
echo.

set /p "output=Enter output filename (default: MERGED.pkg): "
if "%output%"=="" set "output=MERGED.pkg"

REM Add extension if missing
echo %output% | findstr /i ".pkg$" >nul
if errorlevel 1 set "output=%output%.pkg"

echo.
echo Creating: %output%
echo.

REM Delete if exists
if exist "%output%" del "%output%" 2>nul

REM Create empty file
type nul > "%output%"

REM Merge all PKG files
set num=0
for %%F in (*.pkg) do (
    REM Skip the output file itself
    if /i not "%%F"=="%output%" (
        set /a num+=1
        echo [!num!/%count%] Merging: %%F
        copy /b "%output%" + "%%F" "%output%.tmp" >nul 2>&1
        if errorlevel 1 (
            echo [ERROR] Failed!
            del "%output%.tmp" 2>nul
            pause
            exit /b 1
        )
        move /y "%output%.tmp" "%output%" >nul 2>&1
    )
)

echo.
echo ========================================
echo SUCCESS!
echo ========================================
echo.
echo Merged file: %output%
for %%A in ("%output%") do echo Size: %%~zA bytes
echo.
pause
exit /b 0