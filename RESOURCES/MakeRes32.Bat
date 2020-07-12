@echo off

set curdir=%CD%

cd %~dp0
cd ..

set HmgPath=%CD%

cd %curdir%

set PATH=%HmgPath%\mingw\bin

echo #define HMGRPATH %HmgPath%\RESOURCES > _hmg_resconfig.h

windres -i hmg32.rc -o hmg32.o

pause