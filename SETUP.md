# Golf Scramble Scorecard - Complete Setup Guide

## ⚠️ IMPORTANT: Python Installation Required

Python is not currently installed on your system. Follow these steps to get started:

## Step 1: Install Python

1. **Download Python 3.11 or later**:
   - Visit: https://www.python.org/downloads/
   - Click "Download Python 3.x.x" (latest version)

2. **Install Python**:
   - Run the downloaded installer
   - ⚠️ **IMPORTANT**: Check "Add Python to PATH" before clicking Install
   - Choose "Install Now"
   - Wait for installation to complete
   - Click "Close"

3. **Verify Installation**:
   - Open a new PowerShell window
   - Run: `python --version`
   - You should see something like "Python 3.11.x"

## Step 2: Install Dependencies

Once Python is installed, open PowerShell in this directory and run:

```powershell
# Navigate to the project directory (if not already there)
cd c:\repos\Golf\scorecard

# Install required packages
pip install -r requirements.txt
```

## Step 3: Initialize the Database

```powershell
python init_db.py
```

This will create:
- A SQLite database file (golf_scramble.db)
- 100 teams (Team1 through Team100)
- Score records for all 18 holes for each team

## Step 4: Run the Application

```powershell
python app.py
```

You should see output like:
```
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://0.0.0.0:5000
```

## Step 5: Access the Application

1. Open your web browser
2. Navigate to: `http://localhost:5000`
3. You'll see the team selection page

## Using the Application

### Team Selection Page
- Browse through 100 teams (Team1 - Team100)
- Teams with a 🔒 icon are currently being edited by someone else
- Click on any available team to start entering scores
- Use the search box to quickly find a specific team

### Scorecard Entry Page
- You'll see all 18 holes with their par values
- For each hole:
  - Click **−** (minus) to decrease score
  - Click **+** (plus) to increase score
  - The score starts at par when you first click + or −
  - Valid scores range from 1 to 15 strokes
- Your total score and relative to par are displayed at the top
- When finished, click "🔓 Unlock & Return" to return to team selection

### Team Locking
- When you select a team, it's automatically locked to prevent others from editing
- Only one person can edit a team at a time
- Teams auto-unlock after 30 minutes of inactivity
- You can manually unlock by clicking "🔓 Unlock & Return"
- If you accidentally select the wrong team, use the unlock button

## Course Information

**Carlinville Country Club**
- 18 holes, Par 72

| Hole | Par | Hole | Par | Hole | Par |
|------|-----|------|-----|------|-----|
| 1    | 4   | 7    | 3   | 13   | 3   |
| 2    | 5   | 8    | 4   | 14   | 4   |
| 3    | 4   | 9    | 4   | 15   | 5   |
| 4    | 3   | 10   | 4   | 16   | 3   |
| 5    | 4   | 11   | 5   | 17   | 4   |
| 6    | 5   | 12   | 4   | 18   | 4   |

## Troubleshooting

### Port 5000 Already in Use
If you see an error about port 5000 being in use, you can change the port in `app.py`:
```python
# Change the last line from:
app.run(debug=True, host='0.0.0.0', port=5000)
# To:
app.run(debug=True, host='0.0.0.0', port=5001)
```
Then access the app at `http://localhost:5001`

### Database Issues
If you need to reset the database:
```powershell
# Delete the database file
Remove-Item golf_scramble.db

# Reinitialize
python init_db.py
```

### Browser Issues
- The app works best on modern browsers (Chrome, Edge, Firefox, Safari)
- Make sure JavaScript is enabled
- Clear your browser cache if you see old data

## Mobile Access

To access from other devices on your local network:

1. Find your computer's IP address:
   ```powershell
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. On your mobile device, open the browser and go to:
   ```
   http://YOUR_IP_ADDRESS:5000
   ```
   (Replace YOUR_IP_ADDRESS with your actual IP)

3. Make sure your firewall allows incoming connections on port 5000

## Next Steps: GitHub Repository

After testing locally, to create a GitHub repository:

```powershell
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Golf Scramble Scorecard application"

# Create repository on GitHub (go to github.com and create new repo named "GolfScramble")

# Link and push
git remote add origin https://github.com/YOUR_USERNAME/GolfScramble.git
git branch -M main
git push -u origin main
```

## Optional: Deploy to IIS

If you want to deploy this to IIS for production use, you'll need:
1. Install `wfastcgi` package
2. Configure IIS with Python handler
3. Set up application pool

Let me know if you need detailed IIS deployment instructions!

## Support

If you encounter any issues:
1. Check that Python is properly installed and in PATH
2. Ensure all dependencies are installed
3. Verify the database was initialized
4. Check the terminal for error messages
5. Try accessing from a different browser
