# PowerShell script to create Windows Firewall rule for Golf Scorecard app
# Run this as Administrator

Write-Host "========================================" -ForegroundColor Green
Write-Host "  Golf Scorecard - Firewall Setup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator" -ForegroundColor Red
    Write-Host ""
    Write-Host "To run as Administrator:" -ForegroundColor Yellow
    Write-Host "  1. Press Windows key" -ForegroundColor White
    Write-Host "  2. Type 'PowerShell'" -ForegroundColor White
    Write-Host "  3. Right-click 'Windows PowerShell'" -ForegroundColor White
    Write-Host "  4. Select 'Run as administrator'" -ForegroundColor White
    Write-Host "  5. Navigate to this folder and run this script again" -ForegroundColor White
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "✓ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Check if rule already exists
$existingRule = Get-NetFirewallRule -DisplayName "Golf Scorecard App" -ErrorAction SilentlyContinue

if ($existingRule) {
    Write-Host "⚠ Firewall rule already exists" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Do you want to remove and recreate it? (y/n)"
    
    if ($response -eq "y" -or $response -eq "Y") {
        Write-Host "Removing existing rule..." -ForegroundColor Yellow
        Remove-NetFirewallRule -DisplayName "Golf Scorecard App"
        Write-Host "✓ Removed" -ForegroundColor Green
    } else {
        Write-Host "Keeping existing rule" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 0
    }
}

Write-Host ""
Write-Host "Creating firewall rule..." -ForegroundColor Yellow

try {
    # Create the firewall rule
    New-NetFirewallRule `
        -DisplayName "Golf Scorecard App" `
        -Direction Inbound `
        -LocalPort 5000 `
        -Protocol TCP `
        -Action Allow `
        -Profile Private,Domain `
        -Description "Allows inbound connections to Golf Scramble Scorecard web application on port 5000"
    
    Write-Host "✓ Firewall rule created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Details:" -ForegroundColor Cyan
    Write-Host "  Rule Name: Golf Scorecard App" -ForegroundColor White
    Write-Host "  Port: 5000" -ForegroundColor White
    Write-Host "  Protocol: TCP" -ForegroundColor White
    Write-Host "  Direction: Inbound" -ForegroundColor White
    Write-Host "  Action: Allow" -ForegroundColor White
    Write-Host "  Profiles: Private, Domain" -ForegroundColor White
    Write-Host ""
    Write-Host "Your app is now accessible from other devices on your network!" -ForegroundColor Green
    
} catch {
    Write-Host "✗ Failed to create firewall rule" -ForegroundColor Red
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Start the app: python app.py" -ForegroundColor White
Write-Host "  2. Find your IP: run get_network_info.ps1" -ForegroundColor White
Write-Host "  3. Access from phone: http://YOUR_IP:5000" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
