@echo off

SET HMGPATH=%~dp0
SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%

CALL BuildLib32.bat /nopause

echo.
pause
