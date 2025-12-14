@echo off
setlocal enabledelayedexpansion
color 0A
title PKG File Merger - Drag and Drop

echo ========================================
echo      PKG FILE MERGER v1.0
echo      DRAG AND DROP VERSION
echo ========================================
echo.

REM Check if files were dragged
if "%~1"=="" (
    echo No files detected!
    echo.
    echo HOW TO USE:
    echo 1. Select all your PKG files in Explorer
    echo 2. Drag and drop them onto this .bat file
    echo 3. Done!
    echo.
    echo OR run the script and paste file paths manually
    echo.
    pause
    exit /b 1
)

REM Count the files
set count=0
:count_loop
if not "%~1"=="" (
    set /a count+=1
    shift
    goto count_loop
)

REM Reset to process files again
shift /-%count%

echo Found %count% file(s)
echo.

if %count% LSS 2 (
    echo [ERROR] You need at least 2 files to merge!
    echo.
    pause
    exit /b 1
)

echo Files to merge:
set num=0
:display_loop
if not "%~1"=="" (
    set /a num+=1
    echo %num%. %~nx1
    shift
    goto display_loop
)
echo.

REM Reset again to process
shift /-%count%

REM Get first file directory for output
set "output_dir=%~dp1"
set "output=%output_dir%merged.pkg"

REM Ask if user wants custom name
set /p "custom=Use custom output name? (Y/N, default is merged.pkg): "
if /i "!custom!"=="Y" (
    set /p "output_name=Enter filename: "
    if not "!output_name!"=="" (
        if /i not "!output_name:~-4!"==".pkg" set "output_name=!output_name!.pkg"
        set "output=%output_dir%!output_name!"
    )
)

echo.
echo Output: !output!
echo.
echo Merging...

REM Delete if exists
if exist "!output!" del "!output!"

REM Merge files
set first=1
:merge_loop
if not "%~1"=="" (
    echo - Processing: %~nx1
    
    if !first!==1 (
        copy /b "%~1" "!output!" >nul 2>&1
        set first=0
    ) else (
        copy /b "!output!" + "%~1" "!output!" >nul 2>&1
    )
    
    if errorlevel 1 (
        echo [ERROR] Failed to merge: %~1
        pause
        exit /b 1
    )
    
    shift
    goto merge_loop
)

echo.
echo ========================================
echo SUCCESS! Files merged successfully!
echo ========================================
echo.
echo Output: !output!

REM Get size
for %%A in ("!output!") do (
    set size=%%~zA
    set /a size_kb=!size! / 1024
    set /a size_mb=!size_kb! / 1024
)

if !size_mb! GTR 0 (
    echo Size: !size_mb! MB
) else if !size_kb! GTR 0 (
    echo Size: !size_kb! KB
) else (
    echo Size: !size! bytes
)

echo.
echo Press any key to exit...
pause >nul
exit /b 0