#!/bin/bash
# Automated deployment script to Ubuntu server
# This script will copy files and deploy the application

SERVER_IP="x,x.x.x"
SERVER_USER="jpigott"
SERVER_PATH="/home/jpigott/golf-scorecard"
LOCAL_PATH="."

echo "======================================================================"
echo "  Golf Scramble Scorecard - Remote Deployment"
echo "======================================================================"
echo "Target: $SERVER_USER@$SERVER_IP:$SERVER_PATH"
echo ""

# Check if sshpass is available (for password authentication)
if ! command -v sshpass &> /dev/null; then
    echo "⚠️  sshpass not found. You'll need to enter password multiple times."
    echo "   To install: sudo apt-get install sshpass (Linux) or use key-based auth"
    echo ""
    USE_SSHPASS=false
else
    USE_SSHPASS=true
    SERVER_PASSWORD="yourpassword"
fi

# Function to run SSH commands
run_ssh() {
    if [ "$USE_SSHPASS" = true ]; then
        sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_IP" "$1"
    else
        ssh "$SERVER_USER@$SERVER_IP" "$1"
    fi
}

# Function to copy files
copy_files() {
    if [ "$USE_SSHPASS" = true ]; then
        sshpass -p "$SERVER_PASSWORD" scp -o StrictHostKeyChecking=no -r "$1" "$SERVER_USER@$SERVER_IP:$2"
    else
        scp -r "$1" "$SERVER_USER@$SERVER_IP:$2"
    fi
}

echo "📋 Step 1: Creating directory on server..."
run_ssh "mkdir -p $SERVER_PATH"
echo "✓ Directory created"

echo ""
echo "📦 Step 2: Copying application files..."
echo "   This may take a moment..."

# Copy all necessary files
copy_files "app.py" "$SERVER_PATH/"
copy_files "models.py" "$SERVER_PATH/"
copy_files "deploy.py" "$SERVER_PATH/"
copy_files "start_server.py" "$SERVER_PATH/"
copy_files "requirements.txt" "$SERVER_PATH/"
copy_files "deploy_linux.sh" "$SERVER_PATH/"
copy_files "backup_database.sh" "$SERVER_PATH/"
copy_files "templates" "$SERVER_PATH/"

echo "✓ Files copied"

echo ""
echo "🔧 Step 3: Setting up environment on server..."
run_ssh "cd $SERVER_PATH && chmod +x deploy_linux.sh backup_database.sh"
echo "✓ Permissions set"

echo ""
echo "📥 Step 4: Installing dependencies..."
run_ssh "cd $SERVER_PATH && python3 -m pip install --user -q Flask==3.0.0 Flask-SQLAlchemy==3.1.1 Werkzeug==3.0.1"
echo "✓ Dependencies installed"

echo ""
echo "🗄️  Step 5: Initializing database..."
run_ssh "cd $SERVER_PATH && python3 deploy.py" << EOF
y
EOF
echo "✓ Database initialized"

echo ""
echo "🔥 Step 6: Configuring firewall..."
run_ssh "sudo ufw allow 8080/tcp 2>/dev/null || echo 'Firewall rule added (or already exists)'"
echo "✓ Firewall configured"

echo ""
echo "======================================================================"
echo "✓ Deployment Complete!"
echo "======================================================================"
echo ""
echo "🌐 Your application is ready at:"
echo "   http://192.168.88.10:8080"
echo "   http://192.168.88.10:8080/admin (password: golf)"
echo ""
echo "🚀 To start the server, run:"
echo "   ssh $SERVER_USER@$SERVER_IP"
echo "   cd $SERVER_PATH"
echo "   python3 start_server.py"
echo ""
echo "Or run in background:"
echo "   nohup python3 start_server.py > server.log 2>&1 &"
echo ""
echo "======================================================================"
