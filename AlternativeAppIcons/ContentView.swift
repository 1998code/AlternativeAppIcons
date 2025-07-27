//
//  ContentView.swift
//  AlternativeAppIcons
//
//  Created by Ming on 6/8/2022.
//

import SwiftUI
import UniformTypeIdentifiers

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
    @State private var isDragOver = false
    @State private var customIconImage: NSImage?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Alternative App Icons")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Show preview of selected icon only when there's an actual icon to show
            if (!appIcon.isEmpty && appIcon != "Custom") || (appIcon == "Custom" && customIconImage != nil) {
                VStack {
                    if appIcon == "Custom" && customIconImage != nil {
                        Image(nsImage: customIconImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 5)
                    } else {
                        Image(appIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 5)
                    }
                    
                    Text("Selected: \(appIcon)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            #if os(macOS)
            // Only show note when there's an actual icon selected
            if (!appIcon.isEmpty && appIcon != "Custom") || (appIcon == "Custom" && customIconImage != nil) {
                Text("Note: On macOS, this will change the dock icon temporarily while the app is running.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            // Show drop zone only when Custom is selected
            if appIcon == "Custom" {
                VStack {
                    Text("Drag an image here to customize")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Supports: PNG, JPG, JPEG, SVG")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isDragOver ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                        .frame(width: 200, height: 120)
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(isDragOver ? .blue : .gray)
                                Text("Drop image here")
                                    .font(.caption)
                                    .foregroundColor(isDragOver ? .blue : .gray)
                            }
                        )
                        .onDrop(of: [.fileURL], isTargeted: $isDragOver) { providers in
                            handleDrop(providers: providers)
                            return true
                        }
                }
                .padding()
            }
            #endif
            
            Picker(selection: $appIcon, label: Text("App Icon Picker")) {
                ForEach(appIcons, id: \.self) { icon in
                    Text(icon).tag(icon)
                }
                Text("Custom").tag("Custom")
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
        .onAppear {
            // Apply the default app icon when the app launches
            changeAppIcon(to: appIcon, showAlert: false)
        }
    }
    
    #if os(macOS)
    private func handleDrop(providers: [NSItemProvider]) {
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (data, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            alertMessage = "Error loading file: \(error.localizedDescription)"
                            showAlert = true
                            return
                        }
                        
                        guard let data = data as? Data,
                              let url = URL(dataRepresentation: data, relativeTo: nil) else {
                            alertMessage = "Invalid file data"
                            showAlert = true
                            return
                        }
                        
                        loadCustomIcon(from: url)
                    }
                }
            }
        }
    }
    
    private func loadCustomIcon(from url: URL) {
        // Check if file is an image
        let supportedExtensions = ["png", "jpg", "jpeg", "svg"]
        let fileExtension = url.pathExtension.lowercased()
        
        guard supportedExtensions.contains(fileExtension) else {
            alertMessage = "Unsupported file format. Please use PNG, JPG, JPEG, or SVG files."
            showAlert = true
            return
        }
        
        // Load the image
        if let image = NSImage(contentsOf: url) {
            // Resize image to standard app icon size (1024x1024)
            let resizedImage = resizeImage(image, to: NSSize(width: 1024, height: 1024))
            customIconImage = resizedImage
            
            // Update app icon
            appIcon = "Custom"
            changeAppIcon(to: "Custom")
            
            alertMessage = "Custom icon loaded successfully!"
            showAlert = true
        } else {
            alertMessage = "Could not load image from file"
            showAlert = true
        }
    }
    
    private func resizeImage(_ image: NSImage, to size: NSSize) -> NSImage {
        let resizedImage = NSImage(size: size)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: size))
        resizedImage.unlockFocus()
        return resizedImage
    }
    #endif
    
    private func changeAppIcon(to iconName: String, showAlert: Bool = true) {
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
        if iconName == "Custom" {
            if customIconImage != nil {
                NSApplication.shared.applicationIconImage = customIconImage
                if showAlert {
                    alertMessage = "Dock icon changed to custom image"
                    self.showAlert = true
                }
            }
            // Don't show alert if no custom image is loaded yet
        } else if let image = NSImage(named: iconName) {
            NSApplication.shared.applicationIconImage = image
            if showAlert {
                alertMessage = "Dock icon changed to \(iconName)"
                self.showAlert = true
            }
        } else {
            if showAlert {
                alertMessage = "Could not find icon named \(iconName) in the app bundle"
                self.showAlert = true
            }
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Alternative App Icons")
    }
}
