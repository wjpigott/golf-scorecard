#!/bin/bash
# Linux deployment script for Golf Scramble Scorecard

echo "======================================================================"
echo "  Golf Scramble Scorecard - Linux Deployment"
echo "======================================================================"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is not installed"
    echo "   Install with: sudo apt-get install python3 python3-pip"
    exit 1
fi

echo "✓ Python 3 detected"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
python3 -m pip install -q -r requirements.txt || {
    echo "❌ Failed to install dependencies"
    exit 1
}
echo "✓ Dependencies installed"

# Run deployment
echo ""
python3 deploy.py

echo ""
echo "======================================================================"
echo "✓ Deployment complete!"
echo "======================================================================"
echo ""
echo "To start the server:"
echo "  python3 start_server.py"
echo ""
echo "Or to run in background:"
echo "  nohup python3 start_server.py > server.log 2>&1 &"
echo ""
echo "======================================================================"
