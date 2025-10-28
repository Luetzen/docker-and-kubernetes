@echo off
REM ========================================
REM GitHub Container Registry Push Script
REM ========================================

REM KONFIGURATION - Hier deine Daten eintragen!
set GITHUB_USER=luetzen
set REPO_NAME=docker-and-kubernetes
set VERSION=1.0.0

REM Überprüfen ob eingeloggt
echo Checking Docker login status...
docker info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running!
    pause
    exit /b 1
)

echo.
echo ========================================
echo GitHub Container Registry Push
echo ========================================
echo User: %GITHUB_USER%
echo Repository: %REPO_NAME%
echo Version: %VERSION%
echo ========================================
echo.
echo Press CTRL+C to cancel, or
pause

REM Backend Image
echo.
echo ========================================
echo [1/2] Building Backend Image...
echo ========================================
cd backend
docker build -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:latest -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:%VERSION% .
if errorlevel 1 (
    echo ERROR: Backend build failed!
    cd ..
    pause
    exit /b 1
)

echo Pushing Backend Image...
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:latest
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:%VERSION%
if errorlevel 1 (
    echo ERROR: Backend push failed! Are you logged in?
    echo Run: echo %%GITHUB_TOKEN%% ^| docker login ghcr.io -u %GITHUB_USER% --password-stdin
    cd ..
    pause
    exit /b 1
)
cd ..

REM Frontend Image
echo.
echo ========================================
echo [2/2] Building Frontend Image...
echo ========================================
cd frontend
docker build -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:latest -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:%VERSION% .
if errorlevel 1 (
    echo ERROR: Frontend build failed!
    cd ..
    pause
    exit /b 1
)

echo Pushing Frontend Image...
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:latest
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:%VERSION%
if errorlevel 1 (
    echo ERROR: Frontend push failed!
    cd ..
    pause
    exit /b 1
)
cd ..

REM Nginx Proxy Image
echo.
echo ========================================
echo [3/3] Building Nginx Proxy Image...
echo ========================================
cd nginx
docker build -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:latest -t ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:%VERSION% .
if errorlevel 1 (
    echo ERROR: Nginx build failed!
    cd ..
    pause
    exit /b 1
)

echo Pushing Nginx Proxy Image...
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:latest
docker push ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:%VERSION%
if errorlevel 1 (
    echo ERROR: Nginx push failed!
    cd ..
    pause
    exit /b 1
)
cd ..

REM Erfolg!
echo.
echo ========================================
echo SUCCESS! All images pushed to ghcr.io
echo ========================================
echo.
echo Published images:
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:latest
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/backend:%VERSION%
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:latest
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/frontend:%VERSION%
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:latest
echo   - ghcr.io/%GITHUB_USER%/%REPO_NAME%/nginx-proxy:%VERSION%
echo.
echo View your packages at:
echo https://github.com/%GITHUB_USER%?tab=packages
echo ========================================
pause

