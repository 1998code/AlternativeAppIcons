# AlternativeAppIcons
Cross-platform SwiftUI app that lets users choose alternative app icons on iOS and macOS

<img width="781" height="562" alt="Screenshot 2025-07-12 at 5 26 49 PM" src="https://github.com/user-attachments/assets/90942d82-0a35-4ba5-99bc-bcd8a8a08bfd" />

## Features

### iOS / iPadOS
- ✅ Full alternative app icon support
- ✅ Permanent icon changes that persist between app launches
- ✅ Wheel picker interface
- ✅ Built-in system support via `UIApplication.setAlternateIconName()`

### macOS
- ✅ Temporary dock icon changes while app is running
- ✅ Menu picker interface (platform-appropriate)
- ✅ **Drag and drop custom icon support**
- ✅ **Custom icon upload with PNG, JPG, JPEG, SVG support**
- ✅ **Automatic image resizing to app icon dimensions**
- ✅ Icon preview functionality
- ✅ User feedback with clear explanations

## Platform Support
- **iOS / iPadOS 16+** - Full alternate app icon functionality
- **macOS 11.5+** - Temporary dock icon changes with custom icon support
- **Xcode 14+** - Development environment

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/183251609-f30ad0e8-6fc5-48e1-bb69-47298597c7d3.png)

## How It Works

### iOS / iPadOS Implementation
Uses the native `UIApplication.shared.setAlternateIconName()` API to permanently change the app icon. The changes persist between app launches and are fully supported by the iOS system.

### macOS Implementation
Changes the dock icon temporarily using `NSApplication.shared.applicationIconImage`. While macOS doesn't have built-in alternate app icon support like iOS, this provides a visual demonstration of the different icon options.

**New: Custom Icon Support**
- Select "Custom" from the picker to enable drag and drop
- Drag image files (PNG, JPG, JPEG, SVG) onto the drop zone
- Images are automatically resized to 1024x1024 (standard app icon size)
- Custom icons are applied immediately to the dock

## Setup Instructions

### 1. Icon Assets
The project includes two app icon sets:
- `AppIcon` - Default icon (Lando character)
- `AppIcon 2` - Alternative icon 

For macOS support, the icons are also configured as individual image assets that can be accessed by name at runtime.

### 2. iOS Configuration
Add your alternative app icons to the `CFBundleIcons` key in your Info.plist:

```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>AppIcon 2</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>AppIcon 2</string>
            </array>
        </dict>
    </dict>
</dict>
```

### 3. macOS Configuration
Ensure your alternative icons are available as named image assets in your Asset Catalog so they can be loaded with `NSImage(named:)`.

**New: Custom Icon Support**
- No additional configuration required for custom icon support
- The app automatically handles image loading, validation, and resizing
- Supports PNG, JPG, JPEG, and SVG file formats
- Images are automatically resized to 1024x1024 pixels

## Key Features

- **Cross-Platform Compatibility**: Works on both iOS and macOS with platform-appropriate UI
- **Visual Feedback**: Shows preview of selected icon and confirmation alerts
- **Conditional Compilation**: Uses `#if os()` directives for platform-specific code
- **Error Handling**: Proper error handling with user-friendly messages
- **Persistent Settings**: Uses `@AppStorage` to remember user's icon choice
- **Custom Icon Support**: Drag and drop functionality for macOS with automatic image processing
- **Smart UI**: Only shows relevant UI elements when they're meaningful

![CleanShot 2022-08-06 at 21 43 56](https://user-images.githubusercontent.com/54872601/183252312-fb8ba89c-edf5-45a4-b1f6-c094c4b38063.gif)

## Tutorial
Medium article: https://bit.ly/3A3M5Bs

## License
MIT
