#!/bin/bash
# Simple server setup and start script

echo "Installing dependencies..."
echo "yourpassword" | sudo -S apt update
echo "yourpassword" | sudo -S apt install -y python3-pip python3-flask python3-flask-sqlalchemy

cd /home/jpigott/golf-scorecard

echo "Initializing database..."
python3 deploy.py << EOF
y
EOF

echo "Starting server on port 8080..."
nohup python3 start_server.py > server.log 2>&1 &

sleep 2
echo "Server started!"
echo "Access at: http://192.168.88.10:8080"
