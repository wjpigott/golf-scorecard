# Golf Scramble Scorecard - Deployment Guide

## Quick Deployment to Dell R620 (or any Linux/Windows VM)

### Prerequisites
- Python 3.7 or higher
- Network access on port 8080

---

## Deployment Steps

### 1. Copy Files to Server
Copy the entire `scorecard` folder to your server:
```bash
# Example using SCP (Linux/Mac)
scp -r scorecard/ user@server-ip:/path/to/destination/

# Or use WinSCP, FileZilla, or any file transfer tool
```

### 2. Run Deployment Script
```bash
cd /path/to/scorecard
python deploy.py
```

This script will:
- ✓ Check Python version
- ✓ Install Flask dependencies
- ✓ Initialize database with 100 teams
- ✓ Set admin password to "golf"
- ✓ Check if port 8080 is available

### 3. Start the Server
```bash
python start_server.py
```

The application will be available at:
- **Main App**: `http://server-ip:8080`
- **Admin Panel**: `http://server-ip:8080/admin`

---

## Files Required for Deployment

### Core Application Files
```
scorecard/
├── app.py                  # Main Flask application
├── models.py               # Database models
├── deploy.py               # Deployment script (NEW)
├── start_server.py         # Production startup script (NEW)
├── templates/
│   ├── index.html         # Team selection page
│   ├── scorecard.html     # Score entry page
│   ├── admin.html         # Admin panel
│   └── admin_login.html   # Admin login page
```

### Generated During Deployment
```
├── golf_scramble.db       # SQLite database (created by deploy.py)
```

---

## Configuration Options

### Change Port Number
Edit `start_server.py`, line 9:
```python
PORT = 8080  # Change to any port you need
```

### Change Admin Password
After deployment, you can update the password in the database:
```python
python
>>> from models import db, AdminSettings
>>> from flask import Flask
>>> app = Flask(__name__)
>>> app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///golf_scramble.db'
>>> app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
>>> db.init_app(app)
>>> with app.app_context():
...     admin = AdminSettings.query.first()
...     admin.password = "your-new-password"
...     db.session.commit()
```

---

## Running as a Service (Linux)

### Create systemd service file
```bash
sudo nano /etc/systemd/system/golf-scorecard.service
```

```ini
[Unit]
Description=Golf Scramble Scorecard
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/scorecard
ExecStart=/usr/bin/python3 start_server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Enable and start service
```bash
sudo systemctl daemon-reload
sudo systemctl enable golf-scorecard
sudo systemctl start golf-scorecard
sudo systemctl status golf-scorecard
```

---

## Running as a Service (Windows)

### Using NSSM (Non-Sucking Service Manager)

1. Download NSSM from https://nssm.cc/download
2. Extract and open Command Prompt as Administrator
3. Run:
```cmd
nssm install GolfScorecard
```

4. Configure in the GUI:
   - **Path**: `C:\Python3\python.exe`
   - **Startup directory**: `C:\path\to\scorecard`
   - **Arguments**: `start_server.py`
   - Click "Install service"

5. Start the service:
```cmd
nssm start GolfScorecard
```

---

## Firewall Configuration

### Linux (UFW)
```bash
sudo ufw allow 8080/tcp
sudo ufw reload
```

### Linux (firewalld)
```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Windows
```powershell
# Run as Administrator
New-NetFirewallRule -DisplayName "Golf Scorecard" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
```

---

## Nginx Reverse Proxy (Optional)

If you want to run behind Nginx:

```nginx
server {
    listen 80;
    server_name golf.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

---

## Troubleshooting

### Port Already in Use
```bash
# Linux: Find what's using port 8080
sudo lsof -i :8080

# Windows: Find what's using port 8080
netstat -ano | findstr :8080
```

### Database Locked Error
- Ensure only one instance is running
- Check file permissions on `golf_scramble.db`
- SQLite doesn't handle multiple writers well - consider PostgreSQL for high concurrency

### Can't Access from Other Machines
- Check firewall rules
- Verify server is listening on 0.0.0.0 (not 127.0.0.1)
- Ensure network allows traffic on port 8080

---

## Production Recommendations

### For High Traffic
Consider using a production WSGI server:

```bash
pip install gunicorn

# Run with 4 worker processes
gunicorn -w 4 -b 0.0.0.0:8080 app:app
```

### Database Backup
```bash
# Create backup script
#!/bin/bash
BACKUP_DIR="/backups/golf-scorecard"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
cp golf_scramble.db "$BACKUP_DIR/golf_scramble_$DATE.db"

# Keep only last 10 backups
ls -t $BACKUP_DIR/golf_scramble_*.db | tail -n +11 | xargs rm -f
```

Add to crontab for automatic backups:
```bash
# Backup every hour during event
0 * * * * /path/to/backup-script.sh
```

---

## Support & Maintenance

### View Logs
```bash
# If running as systemd service
sudo journalctl -u golf-scorecard -f

# If running manually, logs go to console
```

### Reset Database
```bash
python deploy.py
# Answer 'y' when asked to reinitialize
```

### Update Application
1. Stop the server
2. Copy new files
3. Restart the server (database persists)

---

## Security Notes

- Change the default admin password after deployment
- Run behind a reverse proxy with HTTPS for production
- Consider adding rate limiting for public-facing deployments
- SQLite is fine for 100 users, but consider PostgreSQL for larger events
