# Quick command to get your IP address for mobile access
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Golf Scorecard - Network Info" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Get Wi-Fi adapter IP address
$ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*" -ErrorAction SilentlyContinue).IPAddress

if ($ip) {
    Write-Host "Your Laptop IP Address: $ip" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Teams should access:" -ForegroundColor Yellow
    Write-Host "  http://$ip:5000" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host ""
} else {
    Write-Host "WARNING: Wi-Fi adapter not found or not connected" -ForegroundColor Red
    Write-Host ""
    Write-Host "All IPv4 Addresses found:" -ForegroundColor Yellow
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*"} | ForEach-Object {
        Write-Host "  $($_.InterfaceAlias): $($_.IPAddress)" -ForegroundColor White
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Check firewall rule
Write-Host "Checking firewall rule..." -ForegroundColor Yellow
$fwRule = Get-NetFirewallRule -DisplayName "Golf Scorecard App" -ErrorAction SilentlyContinue

if ($fwRule) {
    if ($fwRule.Enabled -eq "True") {
        Write-Host "✓ Firewall rule exists and is enabled" -ForegroundColor Green
    } else {
        Write-Host "⚠ Firewall rule exists but is DISABLED" -ForegroundColor Red
    }
} else {
    Write-Host "✗ Firewall rule NOT found" -ForegroundColor Red
    Write-Host ""
    Write-Host "To create the rule, run PowerShell as Administrator and execute:" -ForegroundColor Yellow
    Write-Host "  New-NetFirewallRule -DisplayName 'Golf Scorecard App' -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow" -ForegroundColor White
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
