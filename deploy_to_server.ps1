# PowerShell deployment script to Ubuntu server
# Deploy Golf Scramble Scorecard to 192.168.88.10

$ServerIP = "192.168.88.10"
$Username = "jpigott"
$Password = "P1gotth0use"
$RemotePath = "/home/jpigott/golf-scorecard"
$LocalPath = "."

Write-Host "======================================================================" -ForegroundColor Green
Write-Host "  Golf Scramble Scorecard - Deploy to Ubuntu Server" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "Target: $Username@$ServerIP`:$RemotePath"
Write-Host ""

# Check if we have SSH client
$sshPath = Get-Command ssh -ErrorAction SilentlyContinue
if (-not $sshPath) {
    Write-Host "ERROR: SSH client not found!" -ForegroundColor Red
    Write-Host "Windows 10/11 includes OpenSSH. Enable it with:" -ForegroundColor Yellow
    Write-Host "  Settings > Apps > Optional Features > Add OpenSSH Client" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Or download PuTTY from: https://www.putty.org/" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "Using SSH for deployment..." -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTE: You will be prompted for password multiple times" -ForegroundColor Yellow
Write-Host "Password: $Password" -ForegroundColor Yellow
Write-Host ""
pause

# Create remote directory
Write-Host "Step 1: Creating directory on server..." -ForegroundColor Cyan
ssh "$Username@$ServerIP" "mkdir -p $RemotePath"
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Done" -ForegroundColor Green
} else {
    Write-Host "  Failed - check connection" -ForegroundColor Red
    exit 1
}

# Copy files
Write-Host ""
Write-Host "Step 2: Copying files to server..." -ForegroundColor Cyan
Write-Host "  (This may take a moment...)" -ForegroundColor Gray

$files = @(
    "app.py",
    "models.py", 
    "deploy.py",
    "start_server.py",
    "requirements.txt",
    "deploy_linux.sh",
    "backup_database.sh"
)

foreach ($file in $files) {
    Write-Host "  Copying $file..." -ForegroundColor Gray
    scp "$file" "$Username@$ServerIP`:$RemotePath/"
}

Write-Host "  Copying templates directory..." -ForegroundColor Gray
scp -r "templates" "$Username@$ServerIP`:$RemotePath/"

Write-Host "  Files copied" -ForegroundColor Green

# Set permissions
Write-Host ""
Write-Host "Step 3: Setting permissions..." -ForegroundColor Cyan
ssh "$Username@$ServerIP" "cd $RemotePath && chmod +x deploy_linux.sh backup_database.sh"
Write-Host "  Done" -ForegroundColor Green

# Install dependencies
Write-Host ""
Write-Host "Step 4: Installing Python dependencies..." -ForegroundColor Cyan
ssh "$Username@$ServerIP" "cd $RemotePath && python3 -m pip install --user -q Flask==3.0.0 Flask-SQLAlchemy==3.1.1 Werkzeug==3.0.1"
Write-Host "  Done" -ForegroundColor Green

# Initialize database
Write-Host ""
Write-Host "Step 5: Initializing database..." -ForegroundColor Cyan
$initScript = @"
cd $RemotePath
echo 'y' | python3 << 'PYTHON_SCRIPT'
import sys
sys.path.insert(0, '$RemotePath')
exec(open('deploy.py').read())
PYTHON_SCRIPT
"@
ssh "$Username@$ServerIP" $initScript
Write-Host "  Done" -ForegroundColor Green

# Configure firewall
Write-Host ""
Write-Host "Step 6: Configuring firewall (may require sudo)..." -ForegroundColor Cyan
ssh "$Username@$ServerIP" "echo '$Password' | sudo -S ufw allow 8080/tcp 2>/dev/null || echo 'Firewall configured'"
Write-Host "  Done" -ForegroundColor Green

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your application is ready at:" -ForegroundColor Cyan
Write-Host "  http://192.168.88.10:8080" -ForegroundColor Yellow
Write-Host "  http://192.168.88.10:8080/admin" -ForegroundColor Yellow -NoNewline
Write-Host " (password: golf)" -ForegroundColor Gray
Write-Host ""
Write-Host "To start the server:" -ForegroundColor Cyan
Write-Host "  1. Connect to server:" -ForegroundColor White
Write-Host "     ssh $Username@$ServerIP" -ForegroundColor Gray
Write-Host "  2. Start application:" -ForegroundColor White
Write-Host "     cd golf-scorecard" -ForegroundColor Gray
Write-Host "     python3 start_server.py" -ForegroundColor Gray
Write-Host ""
Write-Host "Or start in background:" -ForegroundColor Cyan
Write-Host "     nohup python3 start_server.py > server.log 2>&1 &" -ForegroundColor Gray
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""

# Offer to start the server now
$response = Read-Host "Would you like to start the server now? (y/N)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host ""
    Write-Host "Starting server on $ServerIP..." -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to return (server will keep running)" -ForegroundColor Yellow
    Write-Host ""
    ssh "$Username@$ServerIP" "cd $RemotePath && nohup python3 start_server.py > server.log 2>&1 &"
    Start-Sleep -Seconds 2
    Write-Host ""
    Write-Host "Server started! Access at http://192.168.88.10:8080" -ForegroundColor Green
}

pause
