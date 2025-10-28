@echo off
REM ========================================
REM GitHub Container Registry Login Script
REM ========================================

echo ========================================
echo GitHub Container Registry Login
echo ========================================
echo.

REM Benutzername abfragen
set /p GITHUB_USER="Enter your GitHub username: "

REM Token abfragen (wird nicht angezeigt)
echo.
echo IMPORTANT: Create a Personal Access Token at:
echo https://github.com/settings/tokens
echo.
echo Required permissions:
echo   - write:packages
echo   - read:packages
echo.
set /p GITHUB_TOKEN="Enter your GitHub Personal Access Token: "

REM Login durchführen
echo.
echo Logging in to ghcr.io...
echo %GITHUB_TOKEN% | docker login ghcr.io -u %GITHUB_USER% --password-stdin

if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Login failed!
    echo ========================================
    echo.
    echo Possible reasons:
    echo   - Invalid token
    echo   - Missing permissions (write:packages)
    echo   - Docker not running
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo SUCCESS! Logged in to ghcr.io
echo ========================================
echo.
echo You can now push images with:
echo   docker push ghcr.io/%GITHUB_USER%/image-name:tag
echo.
echo Or use the push-to-ghcr.bat script
echo ========================================
pause

