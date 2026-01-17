@echo off
REM Windows deployment script to Ubuntu server via PuTTY/WinSCP
REM Run this from Windows PowerShell

echo ======================================================================
echo   Golf Scramble Scorecard - Deploy to Ubuntu Server
echo ======================================================================
echo Target: jpigott@192.168.88.10:/home/jpigott/golf-scorecard
echo.

REM Check if pscp (PuTTY SCP) is available
where pscp >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires PuTTY tools (pscp and plink^)
    echo.
    echo Download from: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
    echo Or use the PowerShell script instead: deploy_to_server.ps1
    echo.
    pause
    exit /b 1
)

set SERVER=192.168.88.10
set USER=jpigott
set PASSWORD=password
set REMOTE_PATH=/home/jpigott/golf-scorecard

echo Step 1: Creating directory on server...
echo mkdir -p %REMOTE_PATH% | plink -pw %PASSWORD% %USER%@%SERVER%
echo Done.
echo.

echo Step 2: Copying files to server...
echo Please enter password when prompted: %PASSWORD%
echo.

pscp -r -pw %PASSWORD% app.py %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% models.py %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% deploy.py %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% start_server.py %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% requirements.txt %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% deploy_linux.sh %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% backup_database.sh %USER%@%SERVER%:%REMOTE_PATH%/
pscp -r -pw %PASSWORD% templates %USER%@%SERVER%:%REMOTE_PATH%/

echo.
echo Step 3: Setting permissions...
echo chmod +x %REMOTE_PATH%/deploy_linux.sh %REMOTE_PATH%/backup_database.sh | plink -pw %PASSWORD% %USER%@%SERVER%
echo.

echo Step 4: Installing dependencies...
echo cd %REMOTE_PATH% ^&^& python3 -m pip install --user -q Flask==3.0.0 Flask-SQLAlchemy==3.1.1 Werkzeug==3.0.1 | plink -pw %PASSWORD% %USER%@%SERVER%
echo.

echo Step 5: Initializing database...
echo y | plink -pw %PASSWORD% %USER%@%SERVER% "cd %REMOTE_PATH% && python3 deploy.py"
echo.

echo ======================================================================
echo Deployment Complete!
echo ======================================================================
echo.
echo Your application is ready at:
echo   http://192.168.88.10:8080
echo   http://192.168.88.10:8080/admin (password: golf^)
echo.
echo To start the server:
echo   1. Open PuTTY and connect to %USER%@%SERVER%
echo   2. cd golf-scorecard
echo   3. python3 start_server.py
echo.
echo ======================================================================
pause
