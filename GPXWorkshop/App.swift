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
struct MainEntryPoint {
    static func main() {
        if isTesting() {
            TestApp.main()
        } else {
            MainApp.main()
        }
    }
    private static func isTesting() -> Bool {
        return NSClassFromString("XCTestCase") != nil
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
        DocumentGroup(newDocument: GPXEditDocument()) { file in
            GPXEditView(document: file.$document)
        }
        .commands {
            CustomCommands()
        }
    }
}

class GlobalActions {
    typealias Action = () -> Void
    static let shared = GlobalActions()
    private init() {}
    
    var exportGPX: Action?
}

struct CustomCommands: Commands {
    var body: some Commands {
//        CommandGroup(replacing: .newItem) {
//            Button(action: newFile) {
//                Text("New")
//            }
//            Button(action: openFile) {
//                Text("Open…")
//            }
//            .keyboardShortcut("O", modifiers: .command)
//            Button("Save") {
//                saveFile()
//            }
//            .keyboardShortcut("S", modifiers: .command)
//            Button("Export GPX") {
//                GlobalActions.shared.exportGPX?()
//            }
//            .keyboardShortcut("E", modifiers: [.command, .shift])
//        }

        CommandGroup(after: .newItem) {
            Button(action: importFiles) {
                Text("Import")
            }
            //.keyboardShortcut("I", modifiers: .command)
        }
//        CommandGroup(replacing: .pasteboard) {
//            Button("Cut") {
//                // Implement cut action
//            }
//            .keyboardShortcut("X", modifiers: .command)
//            
//            Button("Copy") {
//                // Implement copy action
//            }
//            .keyboardShortcut("C", modifiers: .command)
//            
//            Button("Paste") {
//                // Implement paste action
//            }
//            .keyboardShortcut("V", modifiers: .command)
//        }
    }
    
    func newFile() {
            
    }
    
    func openFile() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = true
        openPanel.allowedContentTypes = [.gpx]
        openPanel.begin { result in
            if result == .OK {
                print("Selected file: \(openPanel.urls)")
            }
        }
    }
        
    func saveFile() {
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.allowsOtherFileTypes = false
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your document"
        savePanel.prompt = "Save"
        
        if savePanel.runModal() == .OK {
            if let url = savePanel.url {
                // Handle the file URL where the user wants to save
                print("File saved at: \(url.path)")
            }
        }
    }
    
    func importFiles() {
        print("import files")
    }
}

