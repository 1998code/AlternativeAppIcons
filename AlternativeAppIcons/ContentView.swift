//
//  ContentView.swift
//  AlternativeAppIcons
//
//  Created by Ming on 6/8/2022.
//

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Alternative App Icons")
    }
}
