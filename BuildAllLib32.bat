@echo off

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%

CALL BuildLib32.bat /nopause

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
rem hbmk2 hmg.hbp


rem cd..\..
cd source\crypt
hbmk2 crypt.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\edit
hbmk2 edit.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\editex
hbmk2 editex.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\graph
hbmk2 graph.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\hbvpdf
hbmk2 hbvpdf.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\HMGSQL
hbmk2 mysqlbridge.hbp -q -i%hmgpath%\include
hbmk2 pgsqlbridge.hbp -q -i%hmgpath%\include
hbmk2 sqlitebridge.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\ini
hbmk2 ini.hbp -q -i%hmgpath%\include
echo.

cd..\..
cd source\report
hbmk2 report.hbp -q -i%hmgpath%\include
echo.


cd..\..
cd hfcl\source
hbmk2 hfcl.hbp -q -i%hmgpath%\include -i%hmgpath%\hfcl\include
echo.

cd..\..

echo.
pause
