# KeystrokeInterceptor

KeystrokeInterceptor is a lightweight macOS application that enhances keyboard functionality by intercepting specific key combinations and performing custom actions.

## Features

- Intercepts Option + Up/Down arrow key presses
- Replaces intercepted keystrokes with multiple arrow key presses
- Supports Option + Shift + Up/Down arrow keys
- Runs in the background
- Starts automatically on system boot

## Requirements

- macOS 10.12 or later
- Xcode Command Line Tools (for compilation)

## Installation

1. Clone or download this repository to your local machine.

2. Open Terminal and navigate to the directory containing the KeystrokeInterceptor files.

3. Make the installation script executable:
   ```
   chmod +x install_keystroke_interceptor.sh
   ```

4. Run the installation script:
   ```
   ./install_keystroke_interceptor.sh
   ```

5. Follow the on-screen instructions. You may be prompted for your administrator password during installation.

6. After installation, you'll need to grant KeystrokeInterceptor accessibility permissions:
   - Open System Preferences
   - Go to Security & Privacy > Privacy > Accessibility
   - Click the lock icon to make changes
   - Check the box next to KeystrokeInterceptor to allow it to control your computer

## Usage

Once installed and granted permissions, KeystrokeInterceptor will run automatically in the background. Here's how it works:

- Pressing Option + Up/Down arrow will trigger 5 Up/Down arrow key presses
- Pressing Option + Shift + Up/Down arrow will trigger 5 Shift + Up/Down arrow key presses

You can adjust the number of key presses by modifying the `numberOfKeystrokes` parameter in the `KeystrokeInterceptor.swift` file and reinstalling.

## Customization

To change the number of keystrokes or modify other behaviors:

1. Open `KeystrokeInterceptor.swift` in a text editor
2. Modify the desired parameters or logic
3. Save the file
4. Run the installation script again to recompile and install the updated version

## Uninstallation

To uninstall KeystrokeInterceptor:

1. Remove the binary:
   ```
   sudo rm /usr/local/bin/KeystrokeInterceptor
   ```

2. Remove it from login items:
   - Open System Preferences
   - Go to Users & Groups
   - Select your user
   - Go to the Login Items tab
   - Remove KeystrokeInterceptor from the list

3. Restart your computer to ensure it's no longer running

## Troubleshooting

If you encounter any issues:

- Ensure you've granted the necessary permissions in System Preferences
- Check the console logs for any error messages
- Try restarting your computer

If problems persist, please open an issue on the GitHub repository.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
