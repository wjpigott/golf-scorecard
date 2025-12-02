# Visual Guide - Golf Scramble Scorecard

## 🎨 What the Application Looks Like

### Page 1: Team Selection Screen

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║              🏌️ Golf Scramble Scorecard                      ║
║              Carlinville Country Club                          ║
║                                                                ║
║         Holes: 18    |    Par: 72    |    Teams: 100         ║
║                                                                ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  Search Team: [_____________________]                         ║
║                                                                ║
╠═══════════╦═══════════╦═══════════╦═══════════╦══════════════╣
║           ║           ║           ║    🔒     ║              ║
║   Team1   ║   Team2   ║   Team3   ║   Team4   ║    Team5     ║
║           ║           ║           ║           ║              ║
║ Score: 0  ║ Score: 68 ║ Score: 73 ║ Score: 71 ║  Score: 0    ║
║    E      ║    -4     ║    +1     ║    -1     ║     E        ║
║           ║           ║           ║           ║              ║
╠═══════════╬═══════════╬═══════════╬═══════════╬══════════════╣
║           ║           ║           ║           ║              ║
║   Team6   ║   Team7   ║   Team8   ║   Team9   ║   Team10     ║
║           ║           ║           ║           ║              ║
║ Score: 75 ║ Score: 0  ║ Score: 69 ║ Score: 0  ║  Score: 0    ║
║    +3     ║    E      ║    -3     ║    E      ║     E        ║
║           ║           ║           ║           ║              ║
╠═══════════╩═══════════╩═══════════╩═══════════╩══════════════╣
║                    ... continues to Team100 ...               ║
╚════════════════════════════════════════════════════════════════╝

Key Features:
• Green cards = Available teams
• Gray cards with 🔒 = Locked by another user
• Click any available team to start scoring
• Scores update in real-time
• Colors: Green (-) Red (+) Black (E)
```

---

### Page 2: Scorecard Entry Screen

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║  Team5                                Total: 72  E             ║
║  Carlinville Country Club                                      ║
║                                                                ║
║  [← Back to Teams]  [🔓 Unlock & Return]                      ║
║                                                                ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║                     ⛳ Score Entry                             ║
║                                                                ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  ┌─────────────────────────────────────────────────────────┐  ║
║  │  Hole 1                                        Par 4    │  ║
║  │                                                         │  ║
║  │           (−)        4         (+)                     │  ║
║  │                      E                                 │  ║
║  └─────────────────────────────────────────────────────────┘  ║
║                                                                ║
║  ┌─────────────────────────────────────────────────────────┐  ║
║  │  Hole 2                                        Par 5    │  ║
║  │                                                         │  ║
║  │           (−)        6         (+)                     │  ║
║  │                     +1                                 │  ║
║  └─────────────────────────────────────────────────────────┘  ║
║                                                                ║
║  ┌─────────────────────────────────────────────────────────┐  ║
║  │  Hole 3                                        Par 4    │  ║
║  │                                                         │  ║
║  │           (−)        3         (+)                     │  ║
║  │                     -1                                 │  ║
║  └─────────────────────────────────────────────────────────┘  ║
║                                                                ║
║  ┌─────────────────────────────────────────────────────────┐  ║
║  │  Hole 4                                        Par 3    │  ║
║  │                                                         │  ║
║  │           (−)        -         (+)                     │  ║
║  │                Not entered                             │  ║
║  └─────────────────────────────────────────────────────────┘  ║
║                                                                ║
║                    ... continues for all 18 holes ...         ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝

Controls:
• (−) button: Decrease score by 1
• (+) button: Increase score by 1
• First click: Sets score to par ± button clicked
• Score range: 1-15 strokes per hole
• Auto-saves on every change
• Total updates automatically
```

---

## 🎨 Color Scheme

### Team Selection Page
- **Background**: Green gradient (golf course theme)
- **Cards**: White with shadow
- **Available teams**: Clean white
- **Locked teams**: Gray with reduced opacity
- **Scores under par**: Green text
- **Scores over par**: Red text
- **Scores at par**: Black text

### Scorecard Page
- **Header**: White card with team info
- **Hole cards**: Light gray background
- **Minus button**: Green circle (52b788)
- **Plus button**: Red circle (ef233c)
- **Score display**: Large, bold, centered
- **Hover effects**: Slight shadow and lift

---

## 📱 Mobile View

```
╔═══════════════════════════╗
║  🏌️ Golf Scramble        ║
║  Carlinville Country Club ║
║  Par 72 | Teams: 100      ║
╠═══════════════════════════╣
║  Search: [___________]    ║
╠═══════════════════════════╣
║  ┌─────────┐ ┌─────────┐ ║
║  │ Team1   │ │ Team2   │ ║
║  │ 0 (E)   │ │ 68 (-4) │ ║
║  └─────────┘ └─────────┘ ║
║  ┌─────────┐ ┌─────────┐ ║
║  │ Team3   │ │ 🔒      │ ║
║  │ 73 (+1) │ │ Team4   │ ║
║  └─────────┘ └─────────┘ ║
╚═══════════════════════════╝

• Stacks to 2 columns
• Touch-friendly buttons
• Swipe to scroll
• Same functionality as desktop
```

---

## 🖱️ User Interactions

### On Team Selection Page:

1. **Hover over available team**
   - Card lifts slightly
   - Shadow increases
   - Cursor becomes pointer

2. **Click on available team**
   - Instant navigation to scorecard
   - Team automatically locked
   - Loading indicator during transition

3. **Try to click locked team**
   - Alert message: "Team is currently being edited"
   - No navigation
   - List refreshes

4. **Search functionality**
   - Type "Team5" → Filters to Team5, Team50-59
   - Type "5" → Shows Team5, Team15, Team25...
   - Instant filtering as you type

### On Scorecard Page:

1. **Click Minus (−) button**
   - First click: Sets score to par - 1
   - Additional clicks: Decrease by 1
   - Minimum: 1 stroke
   - Button grays out at minimum

2. **Click Plus (+) button**
   - First click: Sets score to par + 1
   - Additional clicks: Increase by 1
   - Maximum: 15 strokes
   - Button grays out at maximum

3. **Score updates**
   - Immediate visual feedback
   - Total recalculates instantly
   - Relative to par updates
   - Color changes based on performance

4. **Unlock & Return button**
   - Confirmation dialog
   - Releases lock
   - Returns to team selection

---

## 💡 Visual Feedback

### Success States
- ✅ Score updated successfully
- ✅ Team locked successfully
- ✅ Smooth animations

### Warning States
- ⚠️ Team is locked by another user
- ⚠️ Can't decrease below 1 stroke
- ⚠️ Can't increase above 15 strokes

### Error States
- ❌ Database connection error
- ❌ Lock expired, please reselect team
- ❌ Score update failed

---

## 🎯 Design Principles

1. **Golf-Themed**: Green colors, golf emojis (🏌️, ⛳, 🔒)
2. **Touch-Friendly**: Large buttons (50px circles)
3. **Clear Hierarchy**: Important info stands out
4. **Minimal Text**: Icons and visual cues
5. **Responsive**: Works on all screen sizes
6. **Fast**: No page reloads, instant updates
7. **Accessible**: High contrast, readable fonts

---

## 📊 Status Indicators

### Lock Status
- 🔒 = Team locked by another user
- No icon = Team available

### Score Status
- **Green** = Under par (good!)
- **Red** = Over par (needs improvement)
- **Black** = Even par
- **Gray "−"** = Not yet entered

### Button Status
- **Bright color** = Active, clickable
- **Faded/disabled** = Can't click (at limit)

---

## 🔄 Real-Time Updates

### Automatic Refresh
- Team list refreshes every 30 seconds
- Shows updated scores from all teams
- Lock status updates automatically
- No manual refresh needed

### Manual Actions
- Click team → Instant lock
- Click +/− → Instant save
- Click unlock → Instant release
- All updates persist to database

---

## 📐 Layout Dimensions

### Desktop
- Max width: 1200px (centered)
- Team cards: ~150px wide
- Hole cards: Full width, stacked
- Button circles: 50px diameter
- Font sizes: 1.2em - 2.5em

### Mobile
- Full width layout
- Team cards: 2 columns
- Hole cards: Full width
- Larger touch targets
- Adjusted font sizes

---

This visual guide shows what to expect when you run the application. 
The actual styling is modern, clean, and professional with smooth 
animations and transitions throughout.
