@echo off

SET HMGPATH=%~dp0%
SET HMGPATH1=%HMGPATH:~0,-15%

SET PATH=%HMGPATH1%\harbour-64\bin;%HMGPATH1%\mingw-64\bin;%PATH%

hbmk2 report-64.hbp -i%hmgpath1%\include
pause