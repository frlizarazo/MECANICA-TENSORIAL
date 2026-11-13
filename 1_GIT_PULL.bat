@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Pull - Descargar cambios
echo Descargando cambios de GitHub...
git pull --rebase --autostash
if errorlevel 1 (
  echo [ERROR] Hubo un problema ^(posible conflicto^). Ejecuta 3_GIT_STATUS.bat para ver detalles.
) else (
  echo Listo, todo actualizado.
)
pause
