@echo off

set curdir=%CD%

cd %~dp0
cd ..

set HmgPath=%CD%

cd %curdir%

set PATH=%HmgPath%\mingw-64\bin

echo #define HMGRPATH %HmgPath%\RESOURCES > _hmg_resconfig.h

windres -i hmg64.rc -o hmg64.o

pause