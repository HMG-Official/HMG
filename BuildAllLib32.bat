@echo off

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
SET HBP_PARAM=-q -i%hmgpath%\include

CALL BuildLib32.bat /nopause

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
rem hbmk2 hmg.hbp  %HBP_PARAM%


rem cd..\..
cd source\crypt
hbmk2 crypt.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\edit
hbmk2 edit.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\editex
hbmk2 editex.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\graph
hbmk2 graph.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\hbvpdf
hbmk2 hbvpdf.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\HMGSQL
hbmk2 mysqlbridge.hbp  %HBP_PARAM%
hbmk2 pgsqlbridge.hbp  %HBP_PARAM%
hbmk2 sqlitebridge.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\ini
hbmk2 ini.hbp  %HBP_PARAM%
echo.

cd..\..
cd source\report
hbmk2 report.hbp  %HBP_PARAM%
echo.


cd..\..
cd hfcl\source
hbmk2 hfcl.hbp  %HBP_PARAM%  -i%hmgpath%\hfcl\include
echo.

cd..\..

echo.
pause
