# Troubleshooting Guide

## Common Issues and Solutions

### 1. Python Not Found

**Problem**: Running `python` command shows "Python was not found"

**Solution**:
1. Download Python from https://www.python.org/downloads/
2. During installation, CHECK the box "Add Python to PATH"
3. Restart PowerShell after installation
4. Test with: `python --version`

**Alternative**: Use `py` instead of `python` command:
```powershell
py --version
py -m pip install -r requirements.txt
py init_db.py
py app.py
```

---

### 2. pip Not Found

**Problem**: `pip: The term 'pip' is not recognized`

**Solution**:
```powershell
# Try using python -m pip instead
python -m pip install -r requirements.txt

# Or if using py command
py -m pip install -r requirements.txt
```

---

### 3. Port 5000 Already in Use

**Problem**: `Address already in use` or `Port 5000 is already in use`

**Solution 1** - Use different port:
1. Open `app.py`
2. Change last line from `port=5000` to `port=5001` (or any other port)
3. Access app at `http://localhost:5001`

**Solution 2** - Find and kill process using port 5000:
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill the process (replace XXXX with PID from above)
taskkill /F /PID XXXX
```

---

### 4. Database Locked Error

**Problem**: `database is locked` error when updating scores

**Solution**:
```powershell
# Close all connections to the database
# Stop the Flask app (Ctrl+C)
# Delete and recreate the database
Remove-Item golf_scramble.db
python init_db.py
python app.py
```

---

### 5. Page Won't Load / White Screen

**Problem**: Browser shows blank page or "Unable to connect"

**Checklist**:
1. Is Flask running? Check PowerShell window for errors
2. Is the correct URL? Should be `http://localhost:5000`
3. Try different browser (Chrome, Edge, Firefox)
4. Check browser console (F12) for JavaScript errors
5. Clear browser cache: Ctrl+Shift+Del

**Solution**:
```powershell
# Restart the application
# Press Ctrl+C to stop
python app.py
```

---

### 6. Team Stuck as Locked

**Problem**: Team shows locked even though no one is using it

**Solution**:
The app auto-unlocks after 30 minutes, but you can force unlock:

**Option 1** - Restart app (unlocks all teams):
```powershell
# Stop app: Ctrl+C
# Restart
python app.py
```

**Option 2** - Wait for auto-unlock (30 minutes)

**Option 3** - Modify timeout in `app.py`:
```python
# Change line near top of app.py
LOCK_TIMEOUT_MINUTES = 30  # Change to 5 for 5 minutes
```

---

### 7. Scores Not Saving

**Problem**: Scores disappear after refresh or don't save

**Checklist**:
1. Is team locked by you? (should see your team name at top)
2. Check PowerShell for error messages
3. Ensure database file exists: `golf_scramble.db`
4. Check browser console (F12) for errors

**Solution**:
```powershell
# Check if database exists
Test-Path golf_scramble.db

# If False, reinitialize
python init_db.py
```

---

### 8. Can't Access from Phone/Tablet

**Problem**: Mobile device can't connect to app

**Requirements**:
1. Computer and mobile device on same Wi-Fi network
2. Windows Firewall allows port 5000
3. Use computer's IP address, not "localhost"

**Solution**:
```powershell
# Find your computer's IP address
ipconfig | findstr IPv4

# Note the IP (e.g., 192.168.1.100)
# On mobile device, go to: http://192.168.1.100:5000
```

**Configure Firewall**:
```powershell
# Allow port 5000 through firewall (run as Administrator)
New-NetFirewallRule -DisplayName "Flask Golf App" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

---

### 9. Module Not Found Error

**Problem**: `ModuleNotFoundError: No module named 'flask'` or similar

**Solution**:
```powershell
# Reinstall dependencies
pip install -r requirements.txt

# Or install individually
pip install Flask==3.0.0
pip install Flask-SQLAlchemy==3.1.1
pip install python-dateutil==2.8.2
```

---

### 10. Database Not Initialized

**Problem**: `no such table: teams` or similar database error

**Solution**:
```powershell
# Initialize or reinitialize database
python init_db.py

# You should see output:
# "Database tables created successfully!"
# "Created 100 teams (Team1 - Team100)"
# etc.
```

---

### 11. Slow Performance

**Problem**: App is slow or unresponsive

**Possible Causes**:
1. Too many teams displayed at once
2. Database file is large
3. Low system resources

**Solution**:
```powershell
# Check database size
Get-Item golf_scramble.db | Select-Object Length

# If very large (>100MB), recreate:
Remove-Item golf_scramble.db
python init_db.py
```

---

### 12. Can't Run .bat Files

**Problem**: Double-clicking `start.bat` doesn't work

**Solution 1** - Run from PowerShell:
```powershell
cd c:\repos\Golf\scorecard
.\start.bat
```

**Solution 2** - Change execution policy:
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Solution 3** - Run commands manually:
```powershell
pip install -r requirements.txt
python init_db.py
python app.py
```

---

### 13. Browser Shows Old Version

**Problem**: Changes to app don't appear in browser

**Solution**:
```powershell
# Stop Flask (Ctrl+C)
# Clear browser cache (Ctrl+Shift+Del)
# Restart Flask
python app.py
# Hard refresh in browser (Ctrl+F5)
```

---

### 14. Error on Windows 11

**Problem**: Python installer or pip commands fail on Windows 11

**Solution**:
1. Run PowerShell as Administrator
2. Disable app execution alias for Python:
   - Settings → Apps → Advanced app settings → App execution aliases
   - Turn OFF both Python aliases
3. Install Python normally
4. Restart PowerShell

---

### 15. Git Repository Issues

**Problem**: Can't push to GitHub

**Solution**:
```powershell
# Initialize git repository
cd c:\repos\Golf\scorecard
git init

# Configure git (first time)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Add files
git add .

# Commit
git commit -m "Initial commit"

# Create repository on GitHub.com first, then:
git remote add origin https://github.com/YOUR_USERNAME/GolfScramble.git
git branch -M main
git push -u origin main
```

---

## Getting Help

If none of these solutions work:

1. **Check Python Installation**:
   ```powershell
   python --version
   pip --version
   ```

2. **Check File Structure**:
   ```powershell
   Get-ChildItem -Recurse
   ```

3. **Check for Error Messages**:
   - Look at PowerShell terminal output
   - Check browser console (F12 → Console tab)

4. **Test Database**:
   ```powershell
   python -c "from models import db; print('Models OK')"
   ```

5. **Verify Port Availability**:
   ```powershell
   Test-NetConnection -ComputerName localhost -Port 5000
   ```

---

## Still Need Help?

Document the following information:
- Python version: `python --version`
- Pip version: `pip --version`
- Operating system: Windows version
- Error message: Copy full error text
- What you were trying to do when error occurred
- Screenshot of error (if visual issue)

This will help diagnose the issue more effectively.
