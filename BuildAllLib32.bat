@echo off

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%

CALL BuildLib32.bat /nopause

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%
rem hbmk2 hmg.hbp


rem cd..\..
cd source\crypt
hbmk2 crypt.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\edit
hbmk2 edit.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\editex
hbmk2 editex.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\graph
hbmk2 graph.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\hbvpdf
hbmk2 hbvpdf.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\ini
hbmk2 ini.hbp -i%hmgpath%\include
echo.

cd..\..
cd source\report
hbmk2 report.hbp -i%hmgpath%\include
echo.


cd..\..
cd hfcl\source
hbmk2 hfcl.hbp -i%hmgpath%\include -i%hmgpath%\hfcl\include
echo.

cd..\..

echo.
pause



cd..\..
cd hfcl\source
hbmk2 hfcl.hbp -i%hmgpath%\include -i%hmgpath%\hfcl\include
echo.

cd..\..

echo.
:: pause
