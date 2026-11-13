@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Push - Subir cambios
git add -A
git diff --cached --quiet
if not errorlevel 1 (
  echo No hay cambios nuevos para guardar.
) else (
  echo Archivos que se van a subir:
  git status --short
  echo.
  set "MSG="
  set /p "MSG=Describe los cambios (Enter = mensaje automatico): "
  if not defined MSG set "MSG=Actualizacion %date% %time:~0,5%"
  git commit -m "!MSG!"
)
echo.
echo Sincronizando con GitHub...
git pull --rebase --autostash
if errorlevel 1 (
  echo [ERROR] Conflicto al descargar cambios. Ejecuta 3_GIT_STATUS.bat.
  pause & exit /b 1
)
git push
if errorlevel 1 (echo [ERROR] No se pudo subir.) else (echo Listo, cambios subidos a GitHub.)
pause
