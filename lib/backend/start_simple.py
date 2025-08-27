#!/usr/bin/env python3
"""
Simple startup script for EduChat AI Tutor Backend (Python 3.13 Compatible)
"""

import os
import sys
import subprocess

def check_python_version():
    """Check if Python version is compatible"""
    print(f"✅ Python version: {sys.version}")
    return True

def install_simple_requirements():
    """Install simple requirements"""
    print("📦 Installing simple requirements...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "pip", "install", "-r", "requirements_simple.txt"
        ])
        print("✅ Simple requirements installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install simple requirements: {e}")
        print("🔄 Trying minimal requirements...")
        try:
            subprocess.check_call([
                sys.executable, "-m", "pip", "install", "-r", "requirements_minimal.txt"
            ])
            print("✅ Minimal requirements installed successfully")
            return True
        except subprocess.CalledProcessError as e2:
            print(f"❌ Failed to install minimal requirements: {e2}")
            return False

def start_simple_server():
    """Start the simple FastAPI server"""
    print("🚀 Starting Simple EduChat AI Tutor Backend...")
    try:
        subprocess.check_call([
            sys.executable, "main_simple.py"
        ])
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to start server: {e}")
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")

def main():
    """Main startup function"""
    print("🎓 EduChat AI Tutor Backend - Simple Version")
    print("=" * 50)
    print("⚠️  This is a simplified version for Python 3.13")
    print("📚 Full Haystack features require Python 3.11 or 3.12")
    print("=" * 50)
    
    # Check Python version
    check_python_version()
    
    # Change to backend directory
    backend_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(backend_dir)
    
    # Install requirements
    if not install_simple_requirements():
        print("❌ Cannot continue without installing requirements")
        print("\n💡 Solutions:")
        print("1. Use Python 3.11 or 3.12 for full features")
        print("2. Install requirements manually: pip install fastapi uvicorn")
        print("3. Run manually: python main_simple.py")
        return
    
    print("\n🎯 Starting simple server...")
    print("📱 Your Flutter app can now connect to: http://localhost:8000")
    print("📚 Simple AI Tutor system is ready!")
    print("=" * 50)
    
    # Start the server
    start_simple_server()

if __name__ == "__main__":
    main()
