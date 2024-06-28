#!/bin/bash

set -e

echo "Starting KeystrokeInterceptor installation..."

# Compile the Swift code
echo "Compiling KeystrokeInterceptor..."
swiftc KeystrokeInterceptor.swift -o KeystrokeInterceptor

# Make the binary executable
echo "Setting permissions..."
chmod +x KeystrokeInterceptor

# Move the binary to /usr/local/bin
echo "Moving KeystrokeInterceptor to /usr/local/bin..."
sudo mv KeystrokeInterceptor /usr/local/bin/

# Register for startup
echo "Registering KeystrokeInterceptor for startup..."
/usr/local/bin/KeystrokeInterceptor --register

# Start the application as a background process
echo "Starting KeystrokeInterceptor in the background..."
nohup /usr/local/bin/KeystrokeInterceptor > /dev/null 2>&1 &

echo "KeystrokeInterceptor has been installed, registered for startup, and is now running in the background."
echo "You may need to grant it accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
echo "Installation complete!"