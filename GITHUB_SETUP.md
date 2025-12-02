# 🚀 GitHub Repository Setup Guide

## Prerequisites
- Git installed on your computer
- GitHub account created
- Application tested and working locally

---

## Step 1: Install Git (if not already installed)

### Check if Git is installed:
```powershell
git --version
```

If you see a version number, Git is installed. Skip to Step 2.

If not installed:
1. Download Git from: https://git-scm.com/download/win
2. Run installer with default options
3. Restart PowerShell
4. Verify: `git --version`

---

## Step 2: Configure Git (First Time Only)

Set your identity for commits:

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Step 3: Initialize Local Repository

In PowerShell, navigate to your project:

```powershell
cd c:\repos\Golf\scorecard

# Initialize git repository
git init

# Add all files to staging
git add .

# Create first commit
git commit -m "Initial commit: Golf Scramble Scorecard application"
```

---

## Step 4: Create GitHub Repository

1. **Go to GitHub**: https://github.com
2. **Sign in** to your account
3. **Click** the "+" icon (top right) → "New repository"
4. **Repository Settings**:
   - **Name**: `GolfScramble`
   - **Description**: `Web application for tracking golf scramble scores`
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README (we have one)
   - **DO NOT** add .gitignore (we have one)
   - **DO NOT** choose a license
5. **Click** "Create repository"

---

## Step 5: Link and Push to GitHub

GitHub will show you commands. Here's what to run:

```powershell
# Add GitHub as remote repository
# Replace YOUR_USERNAME with your actual GitHub username
git remote add origin https://github.com/YOUR_USERNAME/GolfScramble.git

# Verify remote was added
git remote -v

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

### If asked for credentials:
- **Username**: Your GitHub username
- **Password**: Use a Personal Access Token (not your password)

### Creating a Personal Access Token:
1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token (classic)
4. Name: "GolfScramble"
5. Expiration: 90 days (or custom)
6. Select scopes: Check "repo"
7. Generate token
8. **Copy the token** (you won't see it again!)
9. Use this as password when pushing

---

## Step 6: Verify Upload

1. Go to `https://github.com/YOUR_USERNAME/GolfScramble`
2. You should see all your files
3. README.md will display as the main page

---

## Future Updates

After making changes to your code:

```powershell
# Check what changed
git status

# Add changed files
git add .

# Commit changes
git commit -m "Describe what you changed"

# Push to GitHub
git push
```

---

## Common Git Commands

```powershell
# View status of files
git status

# View commit history
git log --oneline

# View differences
git diff

# Add specific file
git add filename.py

# Add all changes
git add .

# Commit with message
git commit -m "Your message here"

# Push to GitHub
git push

# Pull latest from GitHub
git pull

# View remote repositories
git remote -v

# Clone repository (download to new location)
git clone https://github.com/YOUR_USERNAME/GolfScramble.git
```

---

## .gitignore Already Configured

The `.gitignore` file prevents these from being uploaded:
- `__pycache__/` - Python cache files
- `*.db` - Database files (keeps your scores private)
- `venv/` - Virtual environment
- `.env` - Environment variables
- IDE files

This means your database with scores won't be uploaded to GitHub.

---

## Repository Structure on GitHub

Your repository will look like:

```
GolfScramble/
├── README.md                 ← Main page on GitHub
├── SETUP.md
├── PROJECT_SUMMARY.md
├── TROUBLESHOOTING.md
├── VISUAL_GUIDE.md
├── NEXT_STEPS.md
├── GITHUB_SETUP.md
├── app.py
├── models.py
├── init_db.py
├── utils.py
├── requirements.txt
├── start.bat
├── init_database.bat
├── .gitignore
└── templates/
    ├── index.html
    └── scorecard.html

NOT included (ignored):
├── golf_scramble.db         ← Your local database
├── __pycache__/             ← Python cache
└── venv/                    ← Virtual environment
```

---

## Sharing Your Project

Once on GitHub, others can:

### Download and Use:
```powershell
git clone https://github.com/YOUR_USERNAME/GolfScramble.git
cd GolfScramble
pip install -r requirements.txt
python init_db.py
python app.py
```

### Share the Link:
- Repository: `https://github.com/YOUR_USERNAME/GolfScramble`
- Raw files: Click "Raw" button on any file
- Download ZIP: Click "Code" → "Download ZIP"

---

## Making Repository Private vs Public

### Public Repository (Free)
- ✅ Anyone can view code
- ✅ Good for portfolio/sharing
- ✅ Open source contribution
- ❌ Code is visible to everyone

### Private Repository (Free)
- ✅ Only you can see it
- ✅ Invite specific collaborators
- ✅ Keeps your code private
- ✅ Good for personal/business use

You can change this anytime:
- Repository → Settings → Danger Zone → Change visibility

---

## Branch Strategy (Optional)

For future development:

```powershell
# Create new feature branch
git checkout -b feature-name

# Make changes, commit
git add .
git commit -m "Add new feature"

# Push feature branch
git push -u origin feature-name

# Switch back to main
git checkout main

# Merge feature into main
git merge feature-name

# Push updated main
git push
```

---

## Collaboration (Optional)

To add collaborators:
1. Repository → Settings → Collaborators
2. Click "Add people"
3. Enter GitHub username or email
4. They'll get email invitation
5. They can then clone and contribute

---

## GitHub Actions (Advanced - Optional)

You could automate testing with GitHub Actions:

Create `.github/workflows/test.yml`:
```yaml
name: Test Application

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v2
      with:
        python-version: '3.11'
    - run: pip install -r requirements.txt
    - run: python init_db.py
    - run: python -m pytest tests/
```

---

## Releases (Optional)

Create versioned releases:
1. Repository → Releases → "Create a new release"
2. Tag version: `v1.0.0`
3. Release title: "Initial Release"
4. Description: What's included
5. Attach files if needed
6. Publish release

---

## README Badges (Optional)

Add badges to README.md:

```markdown
![Python](https://img.shields.io/badge/python-3.8+-blue.svg)
![Flask](https://img.shields.io/badge/flask-3.0.0-green.svg)
![License](https://img.shields.io/badge/license-MIT-yellow.svg)
```

These appear at the top of your README on GitHub.

---

## Troubleshooting GitHub

### Authentication Failed
- Use Personal Access Token, not password
- Create token at: github.com → Settings → Developer settings

### Large Files
- GitHub has 100MB file size limit
- Database files can be large
- Already ignored in `.gitignore`

### Push Rejected
```powershell
# Pull latest changes first
git pull origin main

# Resolve any conflicts
# Then push again
git push
```

### Wrong Remote
```powershell
# Remove wrong remote
git remote remove origin

# Add correct remote
git remote add origin https://github.com/CORRECT_USERNAME/GolfScramble.git
```

### Forgot to Add .gitignore
```powershell
# If you already committed .db files

# Remove from git (but keep local file)
git rm --cached golf_scramble.db

# Add to .gitignore
echo "*.db" >> .gitignore

# Commit the change
git add .gitignore
git commit -m "Add .gitignore for database files"
git push
```

---

## GitHub Desktop Alternative

Don't like command line? Use GitHub Desktop:
1. Download: https://desktop.github.com/
2. Install and sign in
3. Add existing repository: `c:\repos\Golf\scorecard`
4. Commit and push via GUI

---

## Summary

**Quick Steps:**
1. ✅ Install Git
2. ✅ Configure Git (name, email)
3. ✅ `git init` in project folder
4. ✅ `git add .` and `git commit`
5. ✅ Create repository on github.com
6. ✅ `git remote add origin URL`
7. ✅ `git push -u origin main`
8. ✅ Done!

**Your Repository URL:**
```
https://github.com/YOUR_USERNAME/GolfScramble
```

---

## Next Steps After GitHub

Once on GitHub, you can:
- Share with others
- Clone to different computers
- Collaborate with teammates
- Deploy to hosting services
- Track issues and features
- Create documentation wiki

---

**Ready to upload to GitHub? Follow the steps above!**

If you encounter issues, check the Troubleshooting section or let me know!
