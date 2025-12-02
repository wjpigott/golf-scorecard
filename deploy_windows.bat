@echo off
REM Windows deployment script for Golf Scramble Scorecard

echo ======================================================================
echo   Golf Scramble Scorecard - Windows Deployment
echo ======================================================================

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Python detected

REM Install dependencies
echo.
echo Installing dependencies...
python -m pip install -q -r requirements.txt
if errorlevel 1 (
    echo Error: Failed to install dependencies
    pause
    exit /b 1
)
echo Dependencies installed

REM Run deployment
echo.
python deploy.py

echo.
echo ======================================================================
echo Deployment complete!
echo ======================================================================
echo.
echo To start the server:
echo   python start_server.py
echo.
echo Or use start_server.bat for easy startup
echo ======================================================================
pause
