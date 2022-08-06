//
//  ContentView.swift
//  AlternativeAppIcons
//
//  Created by Ming on 6/8/2022.
//

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
