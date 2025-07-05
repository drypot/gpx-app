//
//  GPXAppApp.swift
//  GPXApp
//
//  Created by drypot on 2024-04-01.
//

import SwiftUI
import UniformTypeIdentifiers

/*
 How to Bypass SwiftUI App Launch During Unit Testing
 https://qualitycoding.org/bypass-swiftui-app-launch-unit-testing/
 */

//@main
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
        DocumentGroup(newDocument: { WorkplaceDocument() }) { file in
            GPXEditView(document: file.document)
        }
        .commands {
            CustomCommands()
        }
    }
}

struct CustomCommands: Commands {
    
    @FocusedValue(\.activeGPXDocument) var activeDocument
    @Environment(\.newDocument) private var newDocument
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("New") {
                // ReferenceFileDocument 타입 문서는 newDocument(...) 인자로 바로 사용할 수 없다.
                newDocument.callAsFunction { WorkplaceDocument() }
            }
            .keyboardShortcut("N", modifiers: [.command])
            
            Button("Open...") {
                let openPanel = NSOpenPanel()
                openPanel.canChooseFiles = true
                openPanel.canChooseDirectories = true
                openPanel.allowsMultipleSelection = true
                openPanel.allowedContentTypes = [.gpx, .gpxWorkshop]
                openPanel.begin { result in
                    if result != .OK { return }
                    for url in openPanel.urls {
                        openURL(url)
                    }
                }
            }
            .keyboardShortcut("O", modifiers: [.command])
            
            Button("Open Samples") {
                let url = URL(fileURLWithPath: sampleGPXFolderPath)
                openURL(url)
            }
            .keyboardShortcut("N", modifiers: [.command, .shift])
        }
        
        CommandGroup(replacing: .importExport) {
            Button("Import GPX") {
                let openPanel = NSOpenPanel()
                openPanel.canChooseFiles = true
                openPanel.canChooseDirectories = true
                openPanel.allowsMultipleSelection = true
                openPanel.allowedContentTypes = [.gpx]
                openPanel.begin { response in
                    guard response == .OK else { return }
                    Task {
                        do {
                            try await activeDocument?.importGPX(from: openPanel.urls)
                        } catch {
                            print("Failed to import file: \(error)")
                        }
                    }
                }
                
            }
            .keyboardShortcut("I", modifiers: [.command, .shift])
            
            Button("Export as GPX") {
                print("export as gpx")
            }
            .keyboardShortcut("E", modifiers: [.command, .shift])
        }
    }
        
    func openURL(_ url: URL) {
        Task { @MainActor in
            do {
                let document = WorkplaceDocument()
                try await document.importGPX(from: [url])
                newDocument.callAsFunction { document }
            } catch {
                print(error)
            }
        }
    }
      
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

}

