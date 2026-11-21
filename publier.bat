@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ======================================================
echo    Publication des assets JDR vers GitHub
echo ======================================================
echo.

echo [*] Synchronisation avec le depot distant...
git pull --rebase
if %errorlevel% neq 0 (
    echo.
    echo ======================================================
    echo [ERREUR] Echec du git pull rebase.
    echo Verifiez votre connexion ou vos identifiants GitHub.
    echo ======================================================
    echo.
    pause
    exit /b 1
)
echo [OK] Synchronisation reussie.
echo.

echo [*] Verification des modifications locales...
set "HAS_CHANGES="
for /f "delims=" %%i in ('git status --porcelain') do (
    set "HAS_CHANGES=1"
    goto :check_done
)
:check_done

if not defined HAS_CHANGES (
    echo ======================================================
    echo [INFO] Aucun changement detecte. Le dossier est a jour.
    echo ======================================================
    echo.
    pause
    exit /b 0
)

echo [*] Changements detectes :
echo.
git status --short
echo.

echo [*] Ajout des fichiers...
git add -A
if %errorlevel% neq 0 (
    echo.
    echo ======================================================
    echo [ERREUR] Echec lors de git add.
    echo ======================================================
    echo.
    pause
    exit /b 1
)

set "COMMIT_DATE=%date%"
set "COMMIT_TIME=%time:~0,5%"
echo [*] Creation du commit horodate...
git commit -m "Update assets %COMMIT_DATE% %COMMIT_TIME%"
if %errorlevel% neq 0 (
    echo.
    echo ======================================================
    echo [ERREUR] Echec lors de la creation du commit.
    echo ======================================================
    echo.
    pause
    exit /b 1
)

echo [*] Publication sur GitHub...
git push
if %errorlevel% neq 0 (
    echo.
    echo ======================================================
    echo [ERREUR] Echec lors du git push.
    echo Verifiez votre connexion Internet et vos droits d'acces.
    echo ======================================================
    echo.
    pause
    exit /b 1
)

echo.
echo ======================================================
echo [SUCCES] Tous les assets ont ete publies sur GitHub !
echo ======================================================
echo.
pause
exit /b 0
