#!/usr/bin/env python3
"""
Startup script for EduChat AI Tutor Backend with Haystack
"""

import os
import sys
import subprocess
import time

def check_python_version():
    """Check if Python version is compatible"""
    if sys.version_info < (3, 8):
        print("❌ Python 3.8 or higher is required")
        print(f"Current version: {sys.version}")
        return False
    print(f"✅ Python version: {sys.version}")
    return True

def install_requirements():
    """Install required packages"""
    print("📦 Installing required packages...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "pip", "install", "-r", "requirements.txt"
        ])
        print("✅ Requirements installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install requirements: {e}")
        return False

def download_spacy_model():
    """Download required spaCy model"""
    print("🌐 Downloading spaCy model...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "spacy", "download", "en_core_web_sm"
        ])
        print("✅ spaCy model downloaded successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to download spaCy model: {e}")
        return False

def start_server():
    """Start the FastAPI server"""
    print("🚀 Starting EduChat AI Tutor Backend...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "uvicorn", "main:app", 
            "--host", "0.0.0.0", "--port", "8000", "--reload"
        ])
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to start server: {e}")
    except KeyboardInterrupt:
        print("\n🛑 Server stopped by user")

def main():
    """Main startup function"""
    print("🎓 EduChat AI Tutor Backend Startup")
    print("=" * 40)
    
    # Check Python version
    if not check_python_version():
        return
    
    # Change to backend directory
    backend_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(backend_dir)
    
    # Install requirements
    if not install_requirements():
        print("❌ Cannot continue without installing requirements")
        return
    
    # Download spaCy model
    if not download_spacy_model():
        print("⚠️  spaCy model download failed, but continuing...")
    
    print("\n🎯 Starting server...")
    print("📱 Your Flutter app can now connect to: http://localhost:8000")
    print("📚 Haystack AI Tutor system is ready!")
    print("=" * 40)
    
    # Start the server
    start_server()

if __name__ == "__main__":
    main()
