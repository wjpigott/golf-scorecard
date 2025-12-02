# 🏌️ Golf Scramble Scorecard Application

A modern, mobile-friendly web application for tracking team scores during golf scrambles. Built specifically for Carlinville Country Club with support for up to 100 teams.

![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![Flask](https://img.shields.io/badge/Flask-3.0.0-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## ✨ Features

### 🎯 Core Functionality
- **100 Team Support** - Track scores for up to 100 teams simultaneously
- **Real-Time Locking** - Prevents multiple users from editing the same team's scorecard
- **Intuitive Score Entry** - Simple +/- buttons for quick score input
- **Auto-Calculate Totals** - Automatically calculates total score and relative to par
- **Mobile-Friendly** - Responsive design works on phones, tablets, and computers
- **Persistent Storage** - SQLite database ensures no data loss

### 🔒 Team Locking System
- Automatic team locking when selected
- Visual indicators (🔒) for locked teams
- 30-minute auto-unlock on inactivity
- Manual unlock option
- Session-based ownership

### 📊 Score Display
- Shows both actual score and relative to par
- Color-coded display (green for under par, red for over par)
- Hole-by-hole breakdown
- Running total with overall standing

## 🏌️ Course Information

**Carlinville Country Club - 18 Holes, Par 72**

### Front Nine (Par 36)
| Hole | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|------|---|---|---|---|---|---|---|---|---|
| Par  | 4 | 5 | 4 | 3 | 4 | 5 | 3 | 4 | 4 |

### Back Nine (Par 36)
| Hole | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 |
|------|----|----|----|----|----|----|----|----|----| 
| Par  | 4  | 5  | 4  | 3  | 4  | 5  | 3  | 4  | 4  |

## 🚀 Quick Start

### Prerequisites
- **Python 3.8 or higher** - [Download here](https://www.python.org/downloads/)
- **pip** (comes with Python)
- **Modern web browser** (Chrome, Edge, Firefox, Safari)

### Installation

**Option 1: Using Batch Files (Windows - Easiest)**
```powershell
# Navigate to project directory
cd c:\repos\Golf\scorecard

# Double-click start.bat or run:
.\start.bat
```

**Option 2: Manual Setup**
```powershell
# 1. Install dependencies
pip install -r requirements.txt

# 2. Initialize database
python init_db.py

# 3. Start the application
python app.py

# 4. Open browser to http://localhost:5000
```

### First Time Setup

1. **Install Python**
   - Download from https://www.python.org/downloads/
   - ⚠️ **Important**: Check "Add Python to PATH" during installation
   - Restart your terminal after installation

2. **Clone or Download** this repository
   ```powershell
   cd c:\repos\Golf
   # If using git:
   git clone https://github.com/YOUR_USERNAME/GolfScramble.git scorecard
   cd scorecard
   ```

3. **Run Setup**
   ```powershell
   .\start.bat
   ```

That's it! The app will be available at `http://localhost:5000`

## 📖 Documentation

- **[SETUP.md](SETUP.md)** - Detailed installation instructions
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview and technical details
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

## 💻 Usage Guide

### For Scorekeepers

1. **Select Your Team**
   - Open `http://localhost:5000` in your browser
   - Browse or search for your team
   - Click on your team card to start

2. **Enter Scores**
   - Click **−** to decrease score
   - Click **+** to increase score  
   - First click starts at par, then adjusts by 1
   - Total updates automatically

3. **Finish**
   - Click "🔓 Unlock & Return" when done
   - Or simply close browser (auto-unlocks after 30 min)

### For Event Organizers

- **Monitor Progress**: Refresh team selection page to see all current scores
- **Reset Scores**: Delete `golf_scramble.db` and run `python init_db.py`
- **View Data**: Use any SQLite browser to examine the database
- **Export Data**: Use SQL queries or add export functionality

## 🌐 Network Access

### 📱 Mobile/Multi-Device Access (IMPORTANT for your event!)

Since teams will be entering scores from their phones, follow these steps:

**Quick Setup (3 steps):**

1. **Setup Firewall** (one-time, run PowerShell as Administrator):
   ```powershell
   .\setup_firewall.ps1
   ```
   This allows phones to connect to your laptop.

2. **Get Your IP Address** (on event day):
   ```powershell
   .\get_network_info.ps1
   ```
   This shows the URL teams should use.

3. **Start the App**:
   ```powershell
   python app.py
   ```
   Teams can now access from their phones!

**📖 Complete mobile setup guide: [MOBILE_ACCESS_SETUP.md](MOBILE_ACCESS_SETUP.md)**

### Access from Other Devices

1. **Find your computer's IP address**:
   ```powershell
   # Easy way - run the included script
   .\get_network_info.ps1
   
   # Or manually
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. **Configure Windows Firewall** (run as Administrator):
   ```powershell
   # Easy way - run the included script
   .\setup_firewall.ps1
   
   # Or manually
   New-NetFirewallRule -DisplayName "Golf Scorecard App" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
   ```

3. **Access from mobile/tablet**:
   - Connect to same Wi-Fi as laptop
   - Open browser on device
   - Navigate to `http://YOUR_IP_ADDRESS:5000`
   - Example: `http://192.168.1.100:5000`

## 🏗️ Project Structure

```
scorecard/
├── app.py                    # Main Flask application
├── models.py                 # Database models
├── init_db.py               # Database initialization
├── utils.py                 # Helper utilities
├── requirements.txt         # Python dependencies
├── start.bat               # Quick start script (Windows)
├── init_database.bat       # Database setup script
├── templates/
│   ├── index.html          # Team selection page
│   └── scorecard.html      # Score entry page
├── README.md               # This file
├── SETUP.md               # Detailed setup guide
├── PROJECT_SUMMARY.md     # Technical documentation
└── TROUBLESHOOTING.md     # Problem solving guide
```

## 🛠️ Technology Stack

- **Backend**: Flask (Python web framework)
- **Database**: SQLite (serverless, zero-config)
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Styling**: Custom CSS with responsive design
- **Session Management**: Flask sessions with secure tokens

## 🔧 Configuration

Key settings in `app.py`:

```python
# Lock timeout (minutes)
LOCK_TIMEOUT_MINUTES = 30

# Server port
port=5000

# Debug mode (disable for production)
debug=True
```

## 📱 Browser Compatibility

- ✅ Chrome 90+
- ✅ Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## 🚨 Troubleshooting

### Common Issues

**Python not found?**
- Ensure Python is installed and in PATH
- Try using `py` instead of `python`
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

**Port 5000 in use?**
- Change port in `app.py`: `port=5001`
- Or kill process: `netstat -ano | findstr :5000`

**Database errors?**
- Delete `golf_scramble.db`
- Run `python init_db.py`

**Team stuck locked?**
- Wait 30 minutes (auto-unlock)
- Or restart app to clear all locks

For more help, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## 🎯 Future Enhancements

Potential features for future versions:
- [ ] Leaderboard with live rankings
- [ ] Export scores to CSV/Excel
- [ ] Custom team names
- [ ] Multiple course support
- [ ] Admin dashboard
- [ ] Score history/audit trail
- [ ] WebSocket live updates
- [ ] User authentication
- [ ] Email/SMS notifications

## 📄 License

This project is licensed under the MIT License - feel free to use and modify for your events.

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 📞 Support

Need help?
1. Check [SETUP.md](SETUP.md) for installation help
2. Review [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
3. Check the browser console (F12) for errors
4. Review terminal output for error messages

## 🎉 Acknowledgments

Built for golf scramble events at Carlinville Country Club. Designed to be simple, reliable, and easy to use for tournament organizers and participants.

---

**Ready to tee off?** Install Python, run `start.bat`, and you're ready for your golf scramble!
