#!/bin/bash

set -e

echo "Starting Arrow Key Multiplier installation..."

# Compile the Swift code
echo "Compiling Arrow Key Multiplier..."
swiftc ArrowKeyMultiplier.swift -o ArrowKeyMultiplier

# Make the binary executable
echo "Setting permissions..."
chmod +x ArrowKeyMultiplier

# Move the binary to /usr/local/bin
echo "Moving Arrow Key Multiplier to /usr/local/bin..."
sudo mv ArrowKeyMultiplier /usr/local/bin/

# Register for startup
echo "Registering Arrow Key Multiplier for startup..."
/usr/local/bin/ArrowKeyMultiplier --register

# Start the application as a background process
echo "Starting Arrow Key Multiplier in the background..."
nohup /usr/local/bin/ArrowKeyMultiplier > /dev/null 2>&1 &

echo "Arrow Key Multiplier has been installed, registered for startup, and is now running in the background."
echo "You may need to grant it accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility"
echo "Installation complete!"
