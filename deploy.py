"""
Deployment script for Golf Scramble Scorecard
Handles database initialization and checks dependencies
"""
import os
import sys
import subprocess

def check_python_version():
    """Ensure Python 3.7+ is installed"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 7):
        print("❌ Error: Python 3.7 or higher is required")
        print(f"   Current version: {version.major}.{version.minor}.{version.micro}")
        sys.exit(1)
    print(f"✓ Python {version.major}.{version.minor}.{version.micro} detected")

def install_dependencies():
    """Install required Python packages"""
    print("\n📦 Installing dependencies...")
    requirements = [
        'Flask==3.0.0',
        'Flask-SQLAlchemy==3.1.1',
        'Werkzeug==3.0.1'
    ]
    
    try:
        for req in requirements:
            print(f"   Installing {req}...")
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', '-q', req])
        print("✓ All dependencies installed")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error installing dependencies: {e}")
        return False

def initialize_database():
    """Initialize the database with teams and admin password"""
    print("\n🗄️  Initializing database...")
    try:
        from models import db, Team, Score, AdminSettings, COURSE_PARS
        from flask import Flask
        
        app = Flask(__name__)
        basedir = os.path.abspath(os.path.dirname(__file__))
        app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{os.path.join(basedir, "golf_scramble.db")}'
        app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
        
        db.init_app(app)
        
        with app.app_context():
            # Check if database already exists
            db_path = os.path.join(basedir, "golf_scramble.db")
            db_exists = os.path.exists(db_path)
            
            if db_exists:
                response = input("   Database already exists. Reinitialize? (y/N): ")
                if response.lower() != 'y':
                    print("✓ Using existing database")
                    return True
            
            # Create fresh database
            db.drop_all()
            db.create_all()
            
            # Create 100 teams
            for i in range(1, 101):
                team = Team(name=f"Team{i}")
                db.session.add(team)
            db.session.commit()
            
            # Create empty score records
            teams = Team.query.all()
            for team in teams:
                for hole_num in range(1, 19):
                    score = Score(team_id=team.id, hole_number=hole_num, strokes=None)
                    db.session.add(score)
            db.session.commit()
            
            # Create admin settings
            admin = AdminSettings(password="golf")
            db.session.add(admin)
            db.session.commit()
            
            print("✓ Database initialized successfully")
            print(f"   - 100 teams created (Team1 - Team100)")
            print(f"   - 1800 score records created")
            print(f"   - Admin password: golf")
            return True
            
    except Exception as e:
        print(f"❌ Error initializing database: {e}")
        return False

def check_port(port):
    """Check if port is available"""
    import socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex(('127.0.0.1', port))
    sock.close()
    return result != 0

def main():
    """Main deployment process"""
    print("=" * 60)
    print("  Golf Scramble Scorecard - Deployment")
    print("=" * 60)
    
    # Step 1: Check Python version
    check_python_version()
    
    # Step 2: Install dependencies
    if not install_dependencies():
        print("\n❌ Deployment failed: Could not install dependencies")
        sys.exit(1)
    
    # Step 3: Initialize database
    if not initialize_database():
        print("\n❌ Deployment failed: Could not initialize database")
        sys.exit(1)
    
    # Step 4: Check port availability
    port = 8080
    print(f"\n🔌 Checking port {port}...")
    if not check_port(port):
        print(f"⚠️  Warning: Port {port} appears to be in use")
        response = input(f"   Continue anyway? (y/N): ")
        if response.lower() != 'y':
            sys.exit(0)
    else:
        print(f"✓ Port {port} is available")
    
    print("\n" + "=" * 60)
    print("✓ Deployment Complete!")
    print("=" * 60)
    print(f"\n📋 Configuration:")
    print(f"   Port: {port}")
    print(f"   Database: golf_scramble.db")
    print(f"   Admin password: golf")
    print(f"\n🚀 To start the application:")
    print(f"   python start_server.py")
    print(f"\n🌐 Access URLs:")
    print(f"   Local:  http://localhost:{port}")
    print(f"   Admin:  http://localhost:{port}/admin")
    print(f"\n   To access from other machines, use your server's IP address")
    print("=" * 60)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Deployment cancelled by user")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        sys.exit(1)
