@ECHO OFF
TITLE Building in 32 bits...
rem *******************************************************************************
rem SYNTAX
rem *******************************************************************************
rem   build [ /n ] [ /d ] [ /c ] <program.prg> | <project.hbp> [<hbmk2 params>]
rem
rem   /n   no run after build
rem   /d   enabled debugger
rem   /c   console mode
rem
rem
rem   This batch file passes information to hbmk2 to make possible an easy (zero
rem   configuration build of HMG applications).
rem
rem   You can achieve a customized build passing parameters directly to hbmk2.
rem   Please, take a look at hbmk2 help:
rem
rem   hbmk2 --help

rem *******************************************************************************
rem SET DEFAULT OPTIONS
rem *******************************************************************************

SET gtdrivers=-gtgui -gtwin
SET runafterbuild=.t.
SET debug=

rem ******************************************************************************
rem DELETE FILES FROM PREVIOUS BUILD
rem ******************************************************************************

if exist build.log del build.log
if exist error.log del error.log
if exist init.cld del init.cld

rem ******************************************************************************
rem SET HMGPATH
rem ******************************************************************************
rem
rem Using %~dp0 the HMGPATH is automatically set to current (HMG) folder making it
rem portable (zero config)

SET HMGPATH=%~dp0

rem ******************************************************************************
rem SET BINARIES PATHS
rem ******************************************************************************

SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%

rem *******************************************************************************
rem PROCESS PARAMETERS
rem *******************************************************************************
rem
rem /n   no run after build
rem /d   enabled debugger
rem /c   console mode

if "%1"=="" goto VERSION
if /I [%1]==[/n] set runafterbuild=.f.
if /I [%1]==[/n] shift

rem if /I [%1]==[/d] set gtdrivers=-gtwin -gtgui
if /I [%1]==[/d] set debug=-b
rem if /I [%1]==[/d] echo options norunatstartup > init.cld
if /I [%1]==[/d] shift

if /I [%1]==[/c] set gtdrivers=-gtwin -gtgui
if /I [%1]==[/c] shift

rem In case ViewError.exe be not found in the environment setted, will be cutted off:
if not "%ViewError%"=="" if not exist %ViewError%\ViewError.exe SET ViewError=

rem ******************************************************************************
rem Attempt to delete EXE and report if it been executed
rem ******************************************************************************

:CHECKEXE
if exist "%~n1.exe" del "%~n1.exe"
if not exist "%~n1.exe" goto COMPILE_RES
if "%ViewError%"=="" echo x=MSGBOX("%~n1.exe is currently running."+chr(13)+chr(10)+"Close it and try again.",0," ERROR at trying to compile") > %temp%\TEMPmessage.vbs
if "%ViewError%"=="" call %temp%\TEMPmessage.vbs
if exist %temp%\TEMPmessage.vbs del %temp%\TEMPmessage.vbs /f /q
echo Operating System: cannot open output file %~n1.exe: Permission denied > error.log
echo HMG_IDE_NoRunApp >> error.log
if not "%ViewError%"=="" goto VIEWERROR
goto END

rem ******************************************************************************
rem COMPILE RESOURCES
rem ******************************************************************************

:COMPILE_RES

if exist build.log del build.log

echo #define HMGRPATH %HmgPath%\RESOURCES > _hmg_resconfig.h
COPY /b %HMGPATH%\resources\hmg32.rc+"%~n1.rc"+%HMGPATH%\resources\filler _temp.rc >NUL
WINDRES -i _temp.rc -o _temp.o >windres.log 2>&1

rem *******************************************************************************
rem SET PROJECT OUTPUT FILE NAME
rem *******************************************************************************
rem
rem The first parameter sent to hbmk2 is -o%~n1.exe. I've added to it create the
rem application with the project basename (<projectname.hbp> specified by the user.

rem *******************************************************************************
rem SET DEFAULT CONFIGURATION FILE
rem *******************************************************************************
rem
rem The second parameter sent to hbmk2 is the hmg.hbc script to set config required.

rem *******************************************************************************
rem SET QUIET MODE
rem *******************************************************************************
rem
rem The third parameter sent to hbmk2 is -q (Harbour quiet mode)

rem ******************************************************************************
rem CALL HBMK2
rem ******************************************************************************

rem -ldflag="-pthread  -static-libgcc  -static-libstdc++  -static -lpthread"  --> for gcc.exe link pthread library in static mode
rem -trace --> for show execute command line

HBMK2 -q -ldflag="-pthread  -static-libgcc  -static-libstdc++  -static -lpthread" -mt -o"%~n1" %HMGPATH%\hmg32.hbc %gtdrivers% %debug% -q %1 %2 %3 %4 %5 %6 %7 %8 >hbmk.log 2>&1


rem ******************************************************************************
rem CREATE LOGS
rem ******************************************************************************

if errorlevel 1 if exist windres.log copy /a windres.log+hbmk.log error.log >nul
if errorlevel 1 if not exist windres.log copy /a hbmk.log error.log >nul

if errorlevel 0 if exist windres.log copy /a windres.log+hbmk.log build.log >nul
if errorlevel 0 if not exist windres.log copy /a hbmk.log build.log >nul

if exist error.log goto ERROR
goto CLEANUP

rem ******************************************************************************
rem COMPILING ERRORS
rem ******************************************************************************

:ERROR
if not "%ViewError%"=="" echo HMG_IDE_NoRunApp >> error.log
goto VIEWERROR

rem ******************************************************************************
rem CLEANUP
rem ******************************************************************************

:CLEANUP
if exist windres.log del windres.log
if exist hbmk.log del hbmk.log
if exist _hmg_resconfig.h del _hmg_resconfig.h
if exist _temp.rc del _temp.rc
if exist _temp.o del _temp.o

rem ******************************************************************************
rem SHOW LOG
rem ******************************************************************************

:VIEWERROR
if not exist error.log TYPE build.log
if not exist error.log goto RUNAPP
if not "%ViewError%"=="" %ViewError%\ViewError.exe error.log %HmgPath% %1 32
if [%runafterbuild%]==[.f.] goto END
if "%ViewError%"=="" TYPE error.log
rem if "%ViewError%"=="" PAUSE
goto END

rem ******************************************************************************
rem RUN APPLICATION
rem ******************************************************************************

:VERSION
ECHO.
ECHO Build [ /n ] [ /d ] [ /c ] <program.prg> | <project.hbp> [<hbmk2 params>]
ECHO.
ECHO.
ECHO.
PAUSE
GOTO END
:RUNAPP
if [%runafterbuild%]==[.f.] goto END
if exist "%~n1".exe "%~n1".exe
:END
