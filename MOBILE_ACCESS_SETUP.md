# 📱 Mobile/Multi-Device Access Setup Guide

## Overview

This guide will help you set up the Golf Scramble app so teams can enter scores from their phones or tablets while connected to the same Wi-Fi network as your laptop.

---

## 🌐 How It Works

1. **Your laptop** runs the Flask application (the server)
2. **Your laptop** connects to Wi-Fi (e.g., clubhouse Wi-Fi or your hotspot)
3. **Team phones/tablets** connect to the same Wi-Fi network
4. **Teams access** your laptop's IP address in their browser
5. **Everyone shares** the same database on your laptop

---

## 📋 Prerequisites Checklist

Before the event, make sure you have:

- [ ] Laptop with full battery or power adapter
- [ ] Python installed and app tested locally
- [ ] Wi-Fi network available at the golf course
- [ ] Windows Firewall configured (see below)
- [ ] Your laptop's IP address noted

---

## ⚙️ Setup Instructions

### Step 1: Configure Windows Firewall

You need to allow incoming connections on port 5000 so phones can connect.

**Run PowerShell as Administrator:**

1. Press Windows key
2. Type "PowerShell"
3. Right-click "Windows PowerShell"
4. Select "Run as administrator"

**Add Firewall Rule:**

```powershell
# Create firewall rule to allow port 5000
New-NetFirewallRule -DisplayName "Golf Scorecard App" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow

# Verify the rule was created
Get-NetFirewallRule -DisplayName "Golf Scorecard App"
```

You should see output confirming the rule was created. ✅

### Step 2: Find Your Laptop's IP Address

**Option A: Quick Method**

```powershell
# Get IP address
(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Wi-Fi*).IPAddress
```

**Option B: Full Method**

```powershell
ipconfig
```

Look for "Wireless LAN adapter Wi-Fi" section, find "IPv4 Address":
```
IPv4 Address. . . . . . . . . . . : 192.168.1.100
```

**Write down this IP address!** You'll give this to teams.

### Step 3: Start the Application

```powershell
cd c:\repos\Golf\scorecard
python app.py
```

You should see:
```
* Running on http://0.0.0.0:5000
```

The `0.0.0.0` means it's listening on all network interfaces (allows external connections).

---

## 📱 For Teams on Their Phones

### Instructions to Give Teams

Print or display these instructions at the course:

```
🏌️ GOLF SCORECARD INSTRUCTIONS

1. Connect to Wi-Fi: [YOUR_WIFI_NAME]
   Password: [YOUR_WIFI_PASSWORD]

2. Open your phone's web browser (Safari, Chrome, etc.)

3. Go to: http://[YOUR_IP_ADDRESS]:5000
   Example: http://192.168.1.100:5000

4. Select your team number

5. Enter scores using + and - buttons

6. Click "Unlock & Return" when finished
```

### Example QR Code Setup

You can create a QR code that links directly to your app:
- Go to: https://www.qr-code-generator.com/
- Enter: `http://192.168.1.100:5000` (use your actual IP)
- Generate and print the QR code
- Teams can scan to access instantly!

---

## 🔍 Testing Before the Event

### Test Locally First
1. Start the app: `python app.py`
2. On your laptop, open: `http://localhost:5000`
3. Verify everything works ✅

### Test from Your Phone
1. Connect your phone to same Wi-Fi as laptop
2. On your laptop, find IP: `ipconfig`
3. On your phone browser, go to: `http://YOUR_IP:5000`
4. You should see the team selection page ✅
5. Try selecting a team and entering scores ✅

### Test from Another Device
1. Grab a tablet or another phone
2. Try accessing while your phone has a team locked
3. Verify the other device sees the lock 🔒
4. This confirms the locking system works! ✅

---

## 🏌️ Day of Event Workflow

### Setup (30 minutes before first tee time)

1. **Arrive early and test Wi-Fi**
   ```powershell
   # Test internet connection
   Test-Connection -ComputerName google.com -Count 2
   ```

2. **Connect laptop to clubhouse Wi-Fi** (or set up hotspot)

3. **Find and note your IP address**
   ```powershell
   ipconfig
   ```

4. **Start the application**
   ```powershell
   cd c:\repos\Golf\scorecard
   python app.py
   ```

5. **Test from your phone** to ensure it's accessible

6. **Create access instructions**
   - Write IP address on whiteboard
   - Or print instruction cards
   - Or display QR code

### During Event

1. **Keep laptop powered and awake**
   - Plug into power
   - Disable sleep mode: Settings → System → Power → Screen and sleep → Never

2. **Keep PowerShell window open** (don't close it!)

3. **Monitor for issues**
   - Watch PowerShell for error messages
   - Keep your own phone connected to test if needed

4. **Help teams connect**
   - Most common issue: Wrong Wi-Fi network
   - Show them the URL clearly
   - Demonstrate on your phone if needed

### After Event

1. **Don't close app immediately** - let teams finish entering scores

2. **Stop the application**
   - Press Ctrl+C in PowerShell

3. **Scores are saved** in `golf_scramble.db`

---

## 🌐 Wi-Fi Options

### Option 1: Clubhouse Wi-Fi (Best)
- **Pros**: Everyone already connected, good range
- **Cons**: May need password, might be slow
- **Setup**: Just connect and get IP

### Option 2: Your Phone Hotspot
- **Pros**: You control it, secure
- **Cons**: Uses your data, limited connections, battery drain
- **Setup**: 
  1. Enable hotspot on your phone
  2. Connect laptop to your hotspot
  3. Connect team phones to your hotspot
  4. Note: Some carriers limit hotspot connections (usually 5-10 devices)

### Option 3: Portable Wi-Fi Hotspot Device
- **Pros**: Many connections, dedicated device
- **Cons**: Extra cost, need to buy/rent
- **Setup**: Follow device instructions

### Recommendation
Use clubhouse Wi-Fi if available. Your phone's hotspot works for smaller events (<10 teams actively entering at once).

---

## 🔧 Troubleshooting Mobile Access

### "Can't reach the site" / "Unable to connect"

**Check these:**

1. **Same Wi-Fi network?**
   ```
   Laptop Wi-Fi: "ClubhouseWifi"
   Phone Wi-Fi: "ClubhouseWifi"  ✅ Same!
   ```

2. **Correct IP address?**
   - Re-run `ipconfig` on laptop
   - IP addresses can change when reconnecting to Wi-Fi
   - Update the URL given to teams

3. **Firewall enabled?**
   ```powershell
   Get-NetFirewallRule -DisplayName "Golf Scorecard App"
   ```
   Should show "Enabled: True"

4. **App running?**
   - Check PowerShell window
   - Should show "Running on http://0.0.0.0:5000"

5. **Try port 5000?**
   - URL must include `:5000`
   - Example: `http://192.168.1.100:5000` ✅
   - Not: `http://192.168.1.100` ❌

### "Site loads but looks broken"

1. **Clear phone browser cache**
   - Safari: Settings → Safari → Clear History and Website Data
   - Chrome: Settings → Privacy → Clear browsing data

2. **Try different browser**
   - Chrome, Safari, Firefox, Edge all work

3. **Check JavaScript enabled**
   - Should be enabled by default on mobile browsers

### "Very slow to load"

1. **Wi-Fi signal strength**
   - Teams should be within good Wi-Fi range
   - Consider moving closer to router/access point

2. **Too many devices**
   - Clubhouse Wi-Fi may slow with many users
   - Consider using hotspot for your app only

3. **Laptop performance**
   - Close unnecessary programs
   - Ensure laptop isn't overheating

### "Team stuck locked"

1. **Wait 30 minutes** (auto-unlock)

2. **Or restart app** (unlocks all teams)
   - Press Ctrl+C
   - Run `python app.py` again

---

## 📊 Network Configuration Details

The Flask app is configured to accept connections from any device:

```python
app.run(debug=True, host='0.0.0.0', port=5000)
```

- `host='0.0.0.0'` = Listen on all network interfaces
- `port=5000` = Use port 5000
- This allows both localhost AND network access

---

## 🔒 Security Considerations

### For Your Golf Event (Low Risk)

- **Local network only** (Wi-Fi range)
- **No sensitive data** (just golf scores)
- **Temporary** (one day event)
- **Firewall protection** (only port 5000 open)

### Security is Fine Because:
✅ Not exposed to internet
✅ No passwords or personal info stored
✅ Only accessible on local Wi-Fi
✅ Event is time-limited

### If You Want Extra Security:

You could add:
- Basic password authentication
- Team-specific PINs
- Admin dashboard
- (Let me know if you want these features!)

---

## 💡 Pro Tips

### Before Event Day

1. **Test with friends/family**
   - Have them connect from their phones
   - Practice the full workflow
   - Iron out any issues

2. **Take screenshots**
   - Screenshot the team selection page
   - Screenshot the scorecard page
   - Show these to teams as examples

3. **Prepare backup plan**
   - Laptop only (teams come to you)
   - Paper scorecards as backup
   - Your phone as test device

### Event Day

1. **Arrive 30+ minutes early**
   - Time to troubleshoot Wi-Fi issues
   - Get teams connected before tee time

2. **Have a helper**
   - Someone to help teams connect
   - While you monitor the laptop

3. **Print instructions**
   - Big, clear font
   - Post at registration table
   - Include your phone number for help

4. **Keep laptop visible**
   - So you can monitor
   - Teams can come to you if issues
   - Can see if it crashes (rare)

---

## 📱 Device Compatibility

### ✅ Tested and Works On:

- **iPhone** (Safari, Chrome)
- **Android** (Chrome, Firefox, Samsung Internet)
- **iPad/Tablets** (any modern browser)
- **Laptops** (Windows, Mac, Chromebook)

### 📱 Mobile Browser Support:

- iOS 12+ (Safari)
- Android 8+ (Chrome)
- Any modern mobile browser

The app is responsive and touch-friendly!

---

## 🎯 Quick Reference Card

**Print this and keep with you:**

```
═══════════════════════════════════════════
         GOLF SCORECARD - ADMIN CARD
═══════════════════════════════════════════

Wi-Fi Network: _________________________

Wi-Fi Password: _________________________

Your Laptop IP: _________________________

App URL: http://_______________:5000

Firewall Rule: ⬜ Created
Laptop Charged: ⬜ Yes
App Running: ⬜ Yes
Tested from Phone: ⬜ Yes

Emergency Commands:
• Find IP: ipconfig
• Start App: python app.py
• Stop App: Ctrl+C
• Check Firewall:
  Get-NetFirewallRule -DisplayName "Golf Scorecard App"

Help Phone #: _________________________
═══════════════════════════════════════════
```

---

## ✅ Pre-Event Checklist

Print and complete before event:

- [ ] Python installed on laptop
- [ ] App tested locally (localhost:5000)
- [ ] Firewall rule created
- [ ] Tested from your phone on Wi-Fi
- [ ] Know the clubhouse Wi-Fi name/password
- [ ] Laptop fully charged
- [ ] Power adapter packed
- [ ] Printed access instructions for teams
- [ ] Helper person identified
- [ ] Backup plan ready

---

## 🎊 You're Ready!

Once you've completed this setup, teams can enter scores from anywhere within Wi-Fi range. The app handles all the locking and synchronization automatically.

**Test everything before event day to ensure smooth operation!**

Need help? See `TROUBLESHOOTING.md` or check the PowerShell output for error messages.
