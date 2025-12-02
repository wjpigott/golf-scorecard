@echo off
echo ==========================================
echo Golf Scramble Scorecard - Quick Start
echo ==========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo.
    echo Please install Python from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

echo Python detected! Setting up application...
echo.

REM Install dependencies if not already installed
echo Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

REM Check if database exists
if not exist "golf_scramble.db" (
    echo Database not found. Initializing...
    python init_db.py
    if errorlevel 1 (
        echo ERROR: Failed to initialize database
        pause
        exit /b 1
    )
    echo.
)

echo Starting application...
echo.
echo ==========================================
echo Application will be available at:
echo http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo ==========================================
echo.

python app.py
