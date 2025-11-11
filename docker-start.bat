@echo off
REM ViT Food Vision - Docker Quick Start Script (Windows)

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   ViT Food Vision - Docker Setup
echo ========================================
echo.

REM Check Docker installation
docker --version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not installed or not in PATH.
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker Compose is not installed or not in PATH.
    pause
    exit /b 1
)

:menu
echo.
echo Select an option:
echo 1) Build Docker image
echo 2) Start services (docker-compose)
echo 3) Start training container
echo 4) Start demo container
echo 5) Stop all services
echo 6) View logs
echo 7) Enter container shell
echo 8) Clean up (remove images and volumes)
echo.
set /p choice="Enter choice [1-8]: "

if "%choice%"=="1" goto build
if "%choice%"=="2" goto start
if "%choice%"=="3" goto train
if "%choice%"=="4" goto demo
if "%choice%"=="5" goto stop
if "%choice%"=="6" goto logs
if "%choice%"=="7" goto shell
if "%choice%"=="8" goto cleanup
goto menu

:build
echo.
echo Building Docker image...
docker build -t vit-food-vision:latest .
echo Build complete!
pause
goto menu

:start
echo.
echo Starting services with docker-compose...
docker-compose up -d
echo Services started!
echo.
echo Access points:
echo   - Jupyter Lab: http://localhost:8888
echo   - TensorBoard: http://localhost:6006
echo   - Gradio Demo: http://localhost:7860
echo.
echo View logs: docker-compose logs -f
pause
goto menu

:train
echo.
echo Starting training container...
docker run --gpus all -it ^
  -p 8888:8888 ^
  -p 6006:6006 ^
  -v "%cd%\data:/app/data" ^
  -v "%cd%\models:/app/models" ^
  -v "%cd%\logs:/app/logs" ^
  vit-food-vision:latest
goto menu

:demo
echo.
echo Building and starting demo container...
docker build -f Dockerfile.demo -t vit-demo:latest .
docker run --gpus all -p 7860:7860 -it vit-demo:latest
goto menu

:stop
echo.
echo Stopping all services...
docker-compose down
echo Services stopped!
pause
goto menu

:logs
echo.
echo Viewing logs (Press Ctrl+C to exit)...
docker-compose logs -f
goto menu

:shell
echo.
echo Entering container shell...
docker-compose exec vit-training bash
goto menu

:cleanup
echo.
set /p confirm="Warning: This will remove images and volumes. Continue? (y/n): "
if /i "%confirm%"=="y" (
    echo Cleaning up...
    docker-compose down -v
    docker rmi vit-food-vision:latest vit-demo:latest
    docker system prune -a --volumes
    echo Cleanup complete!
) else (
    echo Cancelled.
)
pause
goto menu
