@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set "URL=https://github.com/frlizarazo/MECANICA-TENSORIAL.git"
title Vincular con GitHub

where git >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git no esta instalado. Descargalo de https://git-scm.com/download/win
  pause & exit /b 1
)

rem --- Identidad de git (solo si falta) ---
for /f "delims=" %%a in ('git config --global user.name 2^>nul') do set "GN=%%a"
if not defined GN (
  set /p "GN=Tu nombre para los commits: "
  git config --global user.name "!GN!"
)
for /f "delims=" %%a in ('git config --global user.email 2^>nul') do set "GE=%%a"
if not defined GE (
  set /p "GE=Tu correo de GitHub: "
  git config --global user.email "!GE!"
)

if exist ".git" (
  echo La carpeta ya es un repositorio. Actualizando el remoto...
  git remote remove origin >nul 2>&1
  git remote add origin "%URL%"
  git remote -v
  pause & exit /b 0
)

echo Inicializando repositorio en: %CD%
git init
git remote add origin "%URL%"
echo Descargando informacion de GitHub (puede pedir iniciar sesion)...
git fetch origin
if errorlevel 1 (
  echo [ERROR] No se pudo conectar con GitHub. Revisa internet o tus credenciales.
  pause & exit /b 1
)

set "RAMA="
git rev-parse --verify --quiet origin/main >nul && set "RAMA=main"
if not defined RAMA git rev-parse --verify --quiet origin/master >nul && set "RAMA=master"

if defined RAMA (
  echo El repositorio remoto ya tiene contenido en la rama !RAMA!. Descargandolo...
  git checkout -b !RAMA! --track origin/!RAMA!
  if errorlevel 1 (
    echo [AVISO] Hay archivos locales con el mismo nombre que en GitHub.
    echo Mueve esos archivos fuera de la carpeta y vuelve a ejecutar.
    pause & exit /b 1
  )
  git add -A
  git diff --cached --quiet || (git commit -m "Archivos locales iniciales" && git push)
) else (
  echo El repositorio remoto esta vacio. Subiendo el primer commit...
  git checkout -b main
  git add -A
  git commit -m "Primer commit"
  git push -u origin main
)
echo.
echo Listo. Carpeta vinculada con %URL%
pause
