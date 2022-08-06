# AlternativeAppIcons
Let users choose app icons with SwiftUI on iOS 16

## Preview
![CleanShot 2022-08-06 at 20 45 36](https://user-images.githubusercontent.com/54872601/183250571-5dd40d84-c581-4ea7-969f-edf59d0fa711.gif)

## Environment
- iOS 16
- Xcode 14 beta 4 or above

## Tutorial
Coming soon.

## Demo
```swift
import SwiftUI

struct ContentView: View {
    @AppStorage("appIcon") private var appIcon: String = ""
    @State var appIcons = ["AppIcon", "AppIcon 2"]
    var body: some View {
        Picker(selection: $appIcon, label: Text("App Icon Picker")) {
            ForEach(appIcons, id: \.self) { icon in
                Text(icon).tag(icon)
            }
        }.pickerStyle(.wheel)
        .onChange(of: appIcon) { newIcon in
            UIApplication.shared.setAlternateIconName(newIcon == "AppIcon" ? nil : newIcon)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```
