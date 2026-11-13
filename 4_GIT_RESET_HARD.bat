@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Descartar cambios locales
echo ATENCION: esto borra TODOS los cambios no subidos y deja la carpeta
echo exactamente igual a la version de GitHub. No se puede deshacer.
echo.
set /p "OK=Escribe SI para continuar: "
if /i not "%OK%"=="SI" (echo Cancelado. & pause & exit /b 0)
git fetch origin
for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD') do set "RAMA=%%b"
git reset --hard origin/%RAMA%
git clean -fd
echo Listo, carpeta igual a GitHub.
pause
