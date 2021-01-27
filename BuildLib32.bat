@echo off

rem SYNTAX:  BuilLib.bat  [/nopause]  [/ansi] | [/unicode]

if  "%1" == "/nopause" (
    set nopause=1
) else (
    set nopause=0 )

if "%1" == "/nopause" shift

if "%1" == "/ansi"    goto OP1
if "%1" == "/unicode" goto OP2



:MENU
cls
echo.
echo. *********************************
echo. *   HMG-Unicode Build Library   *
echo. *********************************
echo.
echo.
echo. Build HMG Library to support the character set:
echo. -----------------------------------------------
echo.
echo. 1 - ANSI
echo.
echo. 2 - UNICODE
echo.
echo. 0 - Cancel
echo.
echo.
echo.
set /p option=Select an Option [0, 1, 2] (for default: UNICODE):
if %ERRORLEVEL% NEQ 0 goto OP2
if %option% == 1 goto OP1
if %option% == 2 goto OP2
if %option% == 0 exit
goto MENU


:OP1
cls
echo.
title Build Library:         ANSI
echo. Build Library:         ANSI
echo.
if not exist "INCLUDE\_ANSI.ch" ( goto ERROR1 )
copy INCLUDE\_ANSI.ch  INCLUDE\SET_COMPILE_HMG_UNICODE.ch > nul
if %ERRORLEVEL% NEQ 0 goto ERROR1
echo.ANSI > hmglib.txt
goto BUILDLIB


:OP2
cls
echo.
title Build Library:         UNICODE
echo. Build Library:         UNICODE
echo.
if not exist "INCLUDE\_UNICODE.ch" ( goto ERROR2 )
copy INCLUDE\_UNICODE.ch  INCLUDE\SET_COMPILE_HMG_UNICODE.ch > nul
if %ERRORLEVEL% NEQ 0 goto ERROR2
echo.UNICODE > hmglib.txt
goto BUILDLIB


:ERROR1
echo.
echo. ERROR: file (INCLUDE\_ANSI.ch) not exist or failed copy
echo.
pause
exit


:ERROR2
echo.
echo. ERROR: file (INCLUDE\_UNICODE.ch) not exist or failed copy
echo.
pause
exit


:BUILDLIB
SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
SET HBP_PARAM=-q -i%hmgpath%\include

hbmk2 hmg32.hbp %HBP_PARAM%
echo.

if %nopause% == 0 pause
