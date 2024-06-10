//
//  GPXWorkshopApp.swift
//  GPXWorkshop
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI
import UniformTypeIdentifiers

/*
 How to Bypass SwiftUI App Launch During Unit Testing
 https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
 */

@main
struct Main {
    static func main() {
        if NSClassFromString("XCTestCase") != nil {
            TestApp.main()
        } else {
            MainApp.main()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}

struct MainApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: { GPXDocument() }) { file in
            GPXEditView(document: file.document)
        }
        .commands {
            CustomCommands()
        }
    }
}

struct CustomCommands: Commands {
    
    @FocusedValue(\.activeGPXDocument) var document
    
    var body: some Commands {
        CommandGroup(replacing: .importExport) {
            Button("Import GPX", action: importGPX)
                .keyboardShortcut("I", modifiers: [.command, .shift])
            Button("Export as GPX", action: exportAsGPX)
                .keyboardShortcut("E", modifiers: [.command, .shift])
            
            //.keyboardShortcut("I", modifiers: .command)
        }
    }
    
//    func openFile() {
//        let openPanel = NSOpenPanel()
//        openPanel.canChooseFiles = true
//        openPanel.canChooseDirectories = true
//        openPanel.allowsMultipleSelection = true
//        openPanel.allowedContentTypes = [.gpx]
//        openPanel.begin { result in
//            if result == .OK {
//                print("Selected file: \(openPanel.urls)")
//            }
//        }
//    }
//        
//    func saveFile() {
//        let savePanel = NSSavePanel()
//        savePanel.canCreateDirectories = true
//        savePanel.allowsOtherFileTypes = false
//        savePanel.isExtensionHidden = false
//        savePanel.title = "Save your document"
//        savePanel.prompt = "Save"
//        
//        if savePanel.runModal() == .OK {
//            if let url = savePanel.url {
//                // Handle the file URL where the user wants to save
//                print("File saved at: \(url.path)")
//            }
//        }
//    }

    func importGPX() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedContentTypes = [.gpx]
        openPanel.begin { response in
            guard response == .OK else { return }
            Task {
                do {
                    try await document?.importGPX(from: openPanel.urls)
                } catch {
                    print("Failed to import file: \(error)")
                }
            }
        }
    }
    
    func exportAsGPX() {
        print("export as gpx")
    }
    
}

