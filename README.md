# AlternativeAppIcons
Cross-platform SwiftUI app that lets users choose alternative app icons on iOS and macOS

<img width="781" height="562" alt="Screenshot 2025-07-12 at 5 26 49 PM" src="https://github.com/user-attachments/assets/90942d82-0a35-4ba5-99bc-bcd8a8a08bfd" />

## Features

### iOS
- ✅ Full alternative app icon support
- ✅ Permanent icon changes that persist between app launches
- ✅ Wheel picker interface
- ✅ Built-in system support via `UIApplication.setAlternateIconName()`

### macOS
- ✅ Temporary dock icon changes while app is running
- ✅ Menu picker interface (platform-appropriate)
- ✅ Icon preview functionality
- ✅ User feedback with clear explanations

## Platform Support
- **iOS 16+** - Full alternate app icon functionality
- **macOS 12+** - Temporary dock icon changes
- **Xcode 14+** - Development environment

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/183251609-f30ad0e8-6fc5-48e1-bb69-47298597c7d3.png)

## How It Works

### iOS Implementation
Uses the native `UIApplication.shared.setAlternateIconName()` API to permanently change the app icon. The changes persist between app launches and are fully supported by the iOS system.

### macOS Implementation
Changes the dock icon temporarily using `NSApplication.shared.applicationIconImage`. While macOS doesn't have built-in alternate app icon support like iOS, this provides a visual demonstration of the different icon options.

## Code Example

```swift
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

struct ContentView: View {
    @AppStorage("appIcon") private var appIcon: String = "AppIcon"
    @State var appIcons = ["AppIcon", "AppIcon 2"]
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Alternative App Icons")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Show preview of selected icon
            if !appIcon.isEmpty {
                VStack {
                    Image(appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                    
                    Text("Selected: \(appIcon)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            #if os(macOS)
            Text("Note: On macOS, this will change the dock icon temporarily while the app is running.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            #endif
            
            Picker(selection: $appIcon, label: Text("App Icon Picker")) {
                ForEach(appIcons, id: \.self) { icon in
                    Text(icon).tag(icon)
                }
            }
            #if os(iOS)
            .pickerStyle(.wheel)
            #else
            .pickerStyle(.menu)
            #endif
            .onChange(of: appIcon) { newIcon in
                changeAppIcon(to: newIcon)
            }
        }
        .padding()
        .alert("App Icon", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func changeAppIcon(to iconName: String) {
        #if os(iOS)
        let iconToSet = iconName == "AppIcon" ? nil : iconName
        
        guard UIApplication.shared.supportsAlternateIcons else {
            alertMessage = "Alternative app icons are not supported on this device."
            showAlert = true
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconToSet) { error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Failed to change app icon: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    alertMessage = "App icon changed successfully to \(iconName)!"
                    showAlert = true
                }
            }
        }
        #elseif os(macOS)
        // On macOS, we can change the dock icon temporarily while the app is running
        if let image = NSImage(named: iconName) {
            NSApplication.shared.applicationIconImage = image
            alertMessage = "Dock icon changed to \(iconName)"
        } else {
            alertMessage = "Could not find icon named \(iconName) in the app bundle"
        }
        showAlert = true
        #endif
    }
}
```

```

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

## Key Features

- **Cross-Platform Compatibility**: Works on both iOS and macOS with platform-appropriate UI
- **Visual Feedback**: Shows preview of selected icon and confirmation alerts
- **Conditional Compilation**: Uses `#if os()` directives for platform-specific code
- **Error Handling**: Proper error handling with user-friendly messages
- **Persistent Settings**: Uses `@AppStorage` to remember user's icon choice

![CleanShot 2022-08-06 at 21 43 56](https://user-images.githubusercontent.com/54872601/183252312-fb8ba89c-edf5-45a4-b1f6-c094c4b38063.gif)

## Tutorial
Original Medium article: https://bit.ly/3A3M5Bs

## License
MIT
