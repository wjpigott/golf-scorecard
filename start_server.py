"""
Production server startup script for Golf Scramble Scorecard
Runs on port 8080 with production-ready settings
"""
from app import app
import sys

if __name__ == '__main__':
    PORT = 8080
    
    print("=" * 60)
    print("  Golf Scramble Scorecard - Starting Server")
    print("=" * 60)
    print(f"Port: {PORT}")
    print(f"Mode: Production")
    print("")
    print("🌐 Server will be accessible at:")
    print(f"   http://localhost:{PORT}")
    print(f"   http://<your-server-ip>:{PORT}")
    print("")
    print("🔧 Admin Panel:")
    print(f"   http://localhost:{PORT}/admin")
    print(f"   Password: golf")
    print("")
    print("Press CTRL+C to stop the server")
    print("=" * 60)
    print("")
    
    try:
        # Run on all interfaces (0.0.0.0) on port 8080
        # Debug mode OFF for production
        app.run(
            host='0.0.0.0',
            port=PORT,
            debug=False,
            threaded=True
        )
    except KeyboardInterrupt:
        print("\n\n✓ Server stopped")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Error starting server: {e}")
        sys.exit(1)
