# Arrow Key Multiplier

Arrow Key Multiplier is a lightweight macOS application that enhances keyboard functionality by multiplying arrow key presses when used with modifier keys.

## Features

- Multiplies Option + Up/Down arrow key presses
- Supports Option + Shift + Up/Down arrow keys
- Customizable multiplication factor
- Runs in the background
- Starts automatically on system boot

## Requirements

- macOS 10.12 or later
- Xcode Command Line Tools (for compilation)

## Installation

1. Clone or download this repository to your local machine.

2. Open Terminal and navigate to the directory containing the Arrow Key Multiplier files.

3. Make the installation script executable:
   ```
   chmod +x install_arrow_key_multiplier.sh
   ```

4. Run the installation script:
   ```
   ./install_arrow_key_multiplier.sh
   ```

5. Follow the on-screen instructions. You may be prompted for your administrator password during installation.

6. After installation, you'll need to grant Arrow Key Multiplier accessibility permissions:
   - Open System Preferences
   - Go to Security & Privacy > Privacy > Accessibility
   - Click the lock icon to make changes
   - Check the box next to Arrow Key Multiplier to allow it to control your computer

## Usage

Once installed and granted permissions, Arrow Key Multiplier will run automatically in the background. Here's how it works:

- Pressing Option + Up/Down arrow will trigger multiple Up/Down arrow key presses
- Pressing Option + Shift + Up/Down arrow will trigger multiple Shift + Up/Down arrow key presses

By default, it multiplies the key presses by 5. You can adjust this multiplier by modifying the `multiplier` parameter in the `ArrowKeyMultiplier.swift` file and reinstalling.

## Customization

To change the multiplication factor or modify other behaviors:

1. Open `ArrowKeyMultiplier.swift` in a text editor
2. Modify the desired parameters or logic
3. Save the file
4. Run the installation script again to recompile and install the updated version

## Uninstallation

To uninstall Arrow Key Multiplier:

1. Remove the binary:
   ```
   sudo rm /usr/local/bin/ArrowKeyMultiplier
   ```

2. Remove it from login items:
   - Open System Preferences
   - Go to Users & Groups
   - Select your user
   - Go to the Login Items tab
   - Remove Arrow Key Multiplier from the list

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
