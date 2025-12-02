# 📱 Mobile Access - Quick Start Guide

## ✅ What's Been Added for Phone Access

I've created everything you need for teams to enter scores from their phones:

### 🆕 New Files Created

1. **MOBILE_ACCESS_SETUP.md** - Complete guide for multi-device setup
2. **setup_firewall.ps1** - Automated firewall configuration
3. **get_network_info.ps1** - Shows your IP address for teams
4. **get_ip.bat** - Alternative IP address tool
5. **TEAM_INSTRUCTIONS.txt** - Printable instructions for teams

---

## 🚀 Quick Setup (After Python is Installed)

### One-Time Setup (Before Event)

**Step 1: Configure Firewall**

Run PowerShell as Administrator:
1. Press Windows key, type "PowerShell"
2. Right-click "Windows PowerShell"
3. Select "Run as administrator"
4. Navigate to the folder:
   ```powershell
   cd c:\repos\Golf\scorecard
   ```
5. Run the firewall setup:
   ```powershell
   .\setup_firewall.ps1
   ```

This opens port 5000 so phones can connect. ✅

---

### Event Day Setup (3 Steps)

**Step 1: Connect to Wi-Fi**
- Connect your laptop to the golf course Wi-Fi
- Or enable your phone's hotspot and connect to it

**Step 2: Find Your IP Address**
```powershell
.\get_network_info.ps1
```

You'll see something like:
```
Your Laptop IP Address: 192.168.1.100
Teams should access: http://192.168.1.100:5000
```

**Step 3: Start the App**
```powershell
python app.py
```

Keep this window open!

---

## 📋 Share With Teams

**Option 1: Write on Whiteboard**
```
Connect to Wi-Fi: [NetworkName]
Password: [Password]

Open browser, go to:
http://192.168.1.100:5000

Select your team number
Use +/- buttons to enter scores
```

**Option 2: Print Instructions**
- Open `TEAM_INSTRUCTIONS.txt`
- Fill in Wi-Fi name, password, and your IP
- Print several copies
- Post at registration table

**Option 3: Create QR Code**
- Go to https://www.qr-code-generator.com/
- Enter: `http://192.168.1.100:5000` (your IP)
- Generate and print
- Teams scan with phone camera

---

## ✅ Testing Checklist

Before event day, test everything:

- [ ] Python installed
- [ ] App runs locally: `http://localhost:5000`
- [ ] Firewall rule created (ran `setup_firewall.ps1`)
- [ ] Can get IP address (ran `get_network_info.ps1`)
- [ ] Tested from your phone on same Wi-Fi
- [ ] Tested team locking (try with 2 devices)
- [ ] Printed team instructions

---

## 🔍 Quick Troubleshooting

### Phones Can't Connect

**Check these in order:**

1. **Same Wi-Fi?**
   - Laptop and phone must be on SAME network
   - Check Wi-Fi name on both devices

2. **Correct URL?**
   - Must include `:5000` at end
   - Example: `http://192.168.1.100:5000` ✅
   - NOT: `http://192.168.1.100` ❌

3. **Firewall enabled?**
   ```powershell
   Get-NetFirewallRule -DisplayName "Golf Scorecard App"
   ```
   Should show "Enabled: True"

4. **App running?**
   - Check PowerShell window
   - Should say "Running on http://0.0.0.0:5000"

5. **IP still same?**
   - IP can change when reconnecting to Wi-Fi
   - Re-run: `.\get_network_info.ps1`

---

## 💡 Pro Tips

### Battery Life
- Keep laptop plugged in
- Disable sleep mode:
  - Settings → System → Power & sleep
  - Set "When plugged in, PC goes to sleep after" to "Never"

### Wi-Fi Options
1. **Clubhouse Wi-Fi** (Best)
   - Everyone already knows password
   - Good coverage
   
2. **Your Phone Hotspot** (Backup)
   - Turn on phone hotspot
   - Connect laptop to hotspot
   - Teams connect to your hotspot
   - Note: Usually limited to 5-10 devices

### Multiple Devices
- The app handles 100 teams simultaneously
- Wi-Fi speed is usually the bottleneck
- Consider clubhouse Wi-Fi over hotspot for many teams

---

## 📊 How Team Locking Works

This is automatic, but good to understand:

1. **Team selects their number** → Team locks to them
2. **Others see lock icon** 🔒 → Can't edit
3. **Team clicks "Unlock & Return"** → Team available again
4. **30 minutes of inactivity** → Auto-unlocks

This prevents two people from editing same team scores!

---

## 🎯 Day-of-Event Commands

Keep these handy:

```powershell
# Navigate to folder
cd c:\repos\Golf\scorecard

# Get your IP address
.\get_network_info.ps1

# Start the app
python app.py

# Stop the app (when done)
# Press: Ctrl+C

# If you need to restart
# Stop with Ctrl+C, then:
python app.py
```

---

## 📱 What Teams Will See

### On Their Phone:

1. **Team Selection Page**
   - Grid of 100 teams
   - Search box at top
   - Can see which teams are locked
   - Tap their team to start

2. **Scorecard Page**
   - All 18 holes listed
   - Big +/- buttons for each hole
   - Total score at top
   - "Unlock & Return" button

3. **It's Touch-Friendly!**
   - Large buttons
   - Easy to use on small screens
   - No typing needed (just tap +/-)

---

## 🎊 You're Set Up for Mobile Access!

**Summary:**
- ✅ Firewall configured (one-time)
- ✅ Scripts to get IP address
- ✅ Team instructions ready to print
- ✅ App accepts connections from network
- ✅ Team locking prevents conflicts

**On event day:**
1. Connect to Wi-Fi
2. Get IP address: `.\get_network_info.ps1`
3. Start app: `python app.py`
4. Share URL with teams

**That's it!** Teams can now enter scores from their phones. 📱⛳

---

## 📞 Resources

- **Full mobile guide**: `MOBILE_ACCESS_SETUP.md`
- **Team instructions**: `TEAM_INSTRUCTIONS.txt` (print this)
- **Troubleshooting**: `TROUBLESHOOTING.md`
- **Main README**: `README.md`

Need help? Check the PowerShell terminal for error messages!
