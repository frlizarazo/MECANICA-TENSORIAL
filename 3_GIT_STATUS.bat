@echo off
chcp 65001 >nul
cd /d "%~dp0"
title Estado del repositorio
git fetch origin >nul 2>&1
echo ===== ESTADO =====
git status
echo.
echo ===== ULTIMOS 15 COMMITS =====
git log --oneline --graph --decorate -15
pause
