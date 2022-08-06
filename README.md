# AlternativeAppIcons
Let users choose app icons with SwiftUI on iOS 16

![ios-16-num-96x96_2x](https://user-images.githubusercontent.com/54872601/183251612-884f62c7-52af-49b4-8870-35909d6ae6a7.png)

## Preview
![CleanShot 2022-08-06 at 20 45 36](https://user-images.githubusercontent.com/54872601/183250571-5dd40d84-c581-4ea7-969f-edf59d0fa711.gif)

## Environment
- iOS 16
- Xcode 14 beta 4 or above

![swiftui-128x128_2x](https://user-images.githubusercontent.com/54872601/183251609-f30ad0e8-6fc5-48e1-bb69-47298597c7d3.png)

## Tutorial
Medium (https://bit.ly/3A3M5Bs)

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

## License
MIT
