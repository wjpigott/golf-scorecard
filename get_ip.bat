@echo off
echo ==========================================
echo Network Information for Mobile Access
echo ==========================================
echo.

echo Checking Wi-Fi connection...
echo.

REM Get Wi-Fi IP Address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
)

REM Remove leading space
set IP=%IP:~1%

if "%IP%"=="" (
    echo ERROR: No IPv4 address found
    echo Make sure you are connected to Wi-Fi
    echo.
    pause
    exit /b 1
)

echo ==========================================
echo YOUR LAPTOP IP ADDRESS: %IP%
echo ==========================================
echo.
echo Teams should access the app at:
echo.
echo     http://%IP%:5000
echo.
echo ==========================================
echo.

echo Full Network Configuration:
echo.
ipconfig | findstr /c:"Wireless LAN" /c:"IPv4 Address" /c:"Subnet Mask" /c:"Default Gateway"
echo.
echo ==========================================
echo.

echo Next Steps:
echo 1. Share this URL with teams: http://%IP%:5000
echo 2. Make sure firewall allows port 5000
echo 3. Start the app with: python app.py
echo.

REM Check if firewall rule exists
netsh advfirewall firewall show rule name="Golf Scorecard App" >nul 2>&1
if errorlevel 1 (
    echo WARNING: Firewall rule not found!
    echo Run this command as Administrator:
    echo New-NetFirewallRule -DisplayName "Golf Scorecard App" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
    echo.
) else (
    echo Firewall rule: OK
    echo.
)

echo ==========================================
pause
