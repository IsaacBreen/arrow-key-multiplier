#!/bin/bash

set -e

echo "Starting Arrow Key Multiplier installation..."

# Define the bundle identifier and plist path
BUNDLE_IDENTIFIER="com.user.ArrowKeyMultiplier"
PLIST_NAME="${BUNDLE_IDENTIFIER}.plist"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/${PLIST_NAME}"
EXECUTABLE_PATH="/usr/local/bin/ArrowKeyMultiplier"
LOG_OUT_PATH="/tmp/${BUNDLE_IDENTIFIER}.out.log"
LOG_ERR_PATH="/tmp/${BUNDLE_IDENTIFIER}.err.log"

# Compile the Swift code
echo "Compiling Arrow Key Multiplier..."
swiftc ArrowKeyMultiplier.swift -o ArrowKeyMultiplier

# Make the binary executable
echo "Setting permissions..."
chmod +x ArrowKeyMultiplier

# Move the binary to /usr/local/bin
echo "Moving Arrow Key Multiplier to ${EXECUTABLE_PATH}..."
sudo mv ArrowKeyMultiplier "${EXECUTABLE_PATH}"

# Create LaunchAgents directory if it doesn't exist
echo "Ensuring LaunchAgents directory exists at ${LAUNCH_AGENTS_DIR}..."
mkdir -p "${LAUNCH_AGENTS_DIR}"

# Create the Launch Agent Plist
echo "Creating Launch Agent plist at ${PLIST_PATH}..."
cat << EOF > "${PLIST_PATH}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>${BUNDLE_IDENTIFIER}</string>
    <key>ProgramArguments</key>
    <array>
        <string>${EXECUTABLE_PATH}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    <key>StandardOutPath</key>
    <string>${LOG_OUT_PATH}</string>
    <key>StandardErrorPath</key>
    <string>${LOG_ERR_PATH}</string>
</dict>
</plist>
EOF

# Unload any existing version of the Launch Agent (ignore errors if not loaded)
echo "Unloading existing Launch Agent (if any)..."
launchctl unload "${PLIST_PATH}" 2>/dev/null || true

# Load the Launch Agent
echo "Loading Launch Agent..."
launchctl load "${PLIST_PATH}"

echo "Arrow Key Multiplier has been installed and configured to start at login."
echo "Output logs will be saved to: ${LOG_OUT_PATH}"
echo "Error logs will be saved to: ${LOG_ERR_PATH}"
echo "You may need to grant it accessibility permissions in System Preferences > Security & Privacy > Privacy > Accessibility."
echo "If it doesn't work immediately, try logging out and logging back in, or restarting your Mac."
echo "Installation complete!"
