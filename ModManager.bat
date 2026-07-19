@echo off
setlocal enabledelayedexpansion

set "TARGET_DIR=%AppData%\.minecraft\mods"

if not exist "%TARGET_DIR%" (
    echo [ERROR] Target directory does not exist.
    pause
    exit
)

cd /d "%TARGET_DIR%"

:menu
cls
echo ======================================================
echo           MINECRAFT MOD TOGGLE INTERFACE
echo ======================================================
echo  ID  ^|  STATUS  ^|  MOD NAME
echo ------------------------------------------------------

set count=0

for /f "delims=" %%f in ('dir /b *.jar *.jar.off 2^>nul ^| sort') do (
    set /a count+=1
    set "file[!count!]=%%f"
    
    set "fname=%%f"
   
    if "!fname:~-4!"==".off" (
        set "display=!fname:~0,-8!"
        echo  [!count!]  ^| [ OFF ]  ^| !display!
    ) else (
        set "display=!fname:~0,-4!"
        echo  [!count!]  ^| [  ON ]  ^| !display!
    )
)

if %count%==0 (
    echo.
    echo     [ No mods found in this folder ]
    echo.
)

echo ------------------------------------------------------
echo  [A] ENABLE ALL     [N] DISABLE ALL
echo  [Q] QUIT
echo ======================================================

set "choice="
set /p choice="Selection: "

if /i "%choice%"=="Q" exit
if /i "%choice%"=="A" goto enable_all
if /i "%choice%"=="N" goto disable_all

if not defined file[%choice%] (
    echo.
    echo [!] Invalid selection.
    timeout /t 1 >nul
    goto menu
)

set "selectedFile=!file[%choice%]!"


if "!selectedFile:~-4!"==".off" (  
    set "newname=!selectedFile:~0,-4!"
    ren "!selectedFile!" "!newname!"
) else (
    ren "!selectedFile!" "!selectedFile!.off"
)

goto menu
:enable_all
echo Enabling all...
for /f "delims=" %%f in ('dir /b *.jar.off 2^>nul') do (
    set "oldname=%%f"
    ren "%%f" "!oldname:~0,-4!"
)
goto menu
:disable_all
echo Disabling all...
for /f "delims=" %%f in ('dir /b *.jar 2^>nul') do (
    if /i not "%%f"=="%~nx0" ren "%%f" "%%f.off"
)
goto menu