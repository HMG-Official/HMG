@echo off

rem SYNTAX:  BuilLib.bat  [/nopause]  [/ansi] | [/unicode]

cls
echo.
::title Build Library:         ANSI
::echo. Build Library:         ANSI
echo.
if not exist "INCLUDE\_ANSI.ch" ( goto ERROR1 )
copy INCLUDE\_ANSI.ch  INCLUDE\SET_COMPILE_HMG_UNICODE.ch > nul
if %ERRORLEVEL% NEQ 0 goto ERROR1
::echo.ANSI > hmglib.txt
goto BUILDLIB


:ERROR1
echo.
echo. ERROR: file (INCLUDE\_ANSI.ch) not exist or failed copy
echo.
pause
exit




:BUILDLIB
SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
echo %PATH%
echo %HMGPATH%
hbmk2 hmg32.hbp
echo.
