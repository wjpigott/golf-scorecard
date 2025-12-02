# Golf Scramble Scorecard - Project Summary

## 📁 Project Structure

```
c:\repos\Golf\scorecard\
│
├── app.py                  # Main Flask application with all API routes
├── models.py               # Database models (Team, Score, course data)
├── init_db.py             # Database initialization script
├── requirements.txt        # Python dependencies
│
├── templates/
│   ├── index.html         # Team selection page
│   └── scorecard.html     # Score entry page
│
├── start.bat              # Windows batch file to start the app
├── init_database.bat      # Windows batch file to initialize database
│
├── SETUP.md               # Complete setup instructions
├── README.md              # Project documentation
└── .gitignore            # Git ignore file

(After initialization)
├── golf_scramble.db       # SQLite database (auto-generated)
```

## 🎯 Features Implemented

### ✅ Team Management
- 100 teams (Team1 - Team100)
- Team selection with search functionality
- Visual lock indicators (🔒) for teams in use
- Real-time score display on team cards

### ✅ Score Entry
- All 18 holes displayed with par values
- Simple +/- buttons for score entry
- Scores display both absolute (e.g., 5) and relative to par (e.g., +1)
- Score validation (1-15 strokes per hole)
- Real-time total score calculation

### ✅ Team Locking System
- Automatic locking when a team is selected
- Prevents multiple users from editing simultaneously
- Auto-unlock after 30 minutes of inactivity
- Manual unlock button
- Session-based lock ownership

### ✅ User Interface
- Mobile-friendly responsive design
- Clean, modern golf-themed interface
- Color-coded scoring (green for under par, red for over par)
- Easy navigation between pages
- Visual feedback for all actions

### ✅ Database
- SQLite for easy local testing (no server required)
- Automatic schema creation
- Persistent storage of all scores
- Transaction support for data integrity

## 🏌️ Course Details

**Carlinville Country Club**
- Total Par: 72
- Holes 1-9 (Front): Par 36
- Holes 10-18 (Back): Par 36

### Hole-by-Hole Par:
```
Hole:  1  2  3  4  5  6  7  8  9  | 10 11 12 13 14 15 16 17 18
Par:   4  5  4  3  4  5  3  4  4  |  4  5  4  3  4  5  3  4  4
```

## 🚀 Quick Start (Once Python is Installed)

**Option 1: Using Batch Files (Easiest)**
```powershell
# Double-click start.bat in Windows Explorer
# Or run from PowerShell:
.\start.bat
```

**Option 2: Manual Commands**
```powershell
# Install dependencies
pip install -r requirements.txt

# Initialize database (first time only)
python init_db.py

# Start application
python app.py
```

**Option 3: Step by Step**
1. Open PowerShell in `c:\repos\Golf\scorecard`
2. Run: `pip install -r requirements.txt`
3. Run: `python init_db.py`
4. Run: `python app.py`
5. Open browser to `http://localhost:5000`

## 📱 How to Use

### For Scorekeepers:
1. **Select Your Team**
   - Go to http://localhost:5000
   - Find your team (use search if needed)
   - Click on your team card
   - Team is now locked to you

2. **Enter Scores**
   - For each hole, use +/- buttons to enter score
   - First click sets score to par ± adjustment
   - Subsequent clicks adjust by 1 stroke
   - Total updates automatically

3. **Finish Up**
   - Click "🔓 Unlock & Return" when done
   - Or just close the browser (auto-unlocks in 30 min)

### For Administrators:
- All scores are stored in `golf_scramble.db`
- To reset all scores: delete database and run `python init_db.py`
- To view raw data: use any SQLite browser tool
- Logs appear in the terminal running the app

## 🔧 API Endpoints

The application provides these REST API endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Team selection page |
| GET | `/scorecard/<team_id>` | Scorecard entry page |
| GET | `/api/teams` | Get all teams with scores |
| GET | `/api/team/<team_id>` | Get specific team details |
| POST | `/api/team/<team_id>/lock` | Lock a team |
| POST | `/api/team/<team_id>/unlock` | Unlock a team |
| POST | `/api/team/<team_id>/score` | Update hole score |
| GET | `/api/course` | Get course information |

## 🎨 Color Coding

- **Green** (Under par): Eagle, birdie
- **Black** (Even par): Par
- **Red** (Over par): Bogey, double bogey, etc.
- **Gray**: Locked teams
- **White**: Available teams

## 💾 Database Schema

### Teams Table
- id (Primary Key)
- name (e.g., "Team1")
- is_locked (Boolean)
- locked_at (Timestamp)
- locked_by (Session ID)

### Scores Table
- id (Primary Key)
- team_id (Foreign Key)
- hole_number (1-18)
- strokes (Actual score)
- updated_at (Timestamp)

## 🌐 Network Access

### Local Only:
- Access from same computer: `http://localhost:5000`

### LAN Access (other devices on same network):
1. Find your IP: `ipconfig` in PowerShell
2. On other devices: `http://YOUR_IP:5000`
3. May need to allow through Windows Firewall

### Internet Access:
- Requires port forwarding or hosting service
- Consider Heroku, PythonAnywhere, or Azure
- Or deploy to IIS on a Windows Server

## 📊 Potential Enhancements

Future features you could add:
- [ ] Leaderboard showing all teams sorted by score
- [ ] Export scores to CSV/Excel
- [ ] Admin dashboard for monitoring
- [ ] Team names instead of Team1, Team2, etc.
- [ ] Multiple courses support
- [ ] Player names within teams
- [ ] Stroke-by-stroke history
- [ ] Live updates using WebSockets
- [ ] Authentication system
- [ ] Score verification/approval workflow

## 🐛 Known Limitations

1. **Single Server**: Only one Flask instance can run at a time
2. **Lock Timeout**: Fixed at 30 minutes (can be changed in `app.py`)
3. **No Authentication**: Anyone can select any team
4. **No Audit Trail**: Score changes are not logged
5. **Browser Sessions**: Closing browser doesn't immediately unlock

## 📞 Support & Questions

If you need help:
1. Check `SETUP.md` for detailed installation steps
2. Review error messages in the PowerShell terminal
3. Verify Python is installed: `python --version`
4. Check dependencies are installed: `pip list`
5. Ensure database exists: look for `golf_scramble.db` file

## 🎉 Ready to Golf!

Once Python is installed and you've run the setup, you're ready for your scramble event!

**Test the app before the event** to ensure everything works on your laptop.
