@echo off
echo ==========================================
echo Initializing Database
echo ==========================================
echo.

python init_db.py
if errorlevel 1 (
    echo ERROR: Failed to initialize database
    pause
    exit /b 1
)

echo.
echo ==========================================
echo Database initialized successfully!
echo ==========================================
pause
