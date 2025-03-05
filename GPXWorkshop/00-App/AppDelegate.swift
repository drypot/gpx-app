//
//  AppDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowController = BrowserWindowController()

    func applicationWillFinishLaunching(_ notification: Notification) {
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }

//    func openFileDialog() {
//        let openPanel = NSOpenPanel()
//        openPanel.canChooseFiles = true
//        openPanel.canChooseDirectories = false
//        openPanel.allowsMultipleSelection = false
//
//        if openPanel.runModal() == .OK, let url = openPanel.url {
//            handleFileSelection(url)
//        } else {
//            NSApp.terminate(nil)
//        }
//    }
//
//    func handleFileSelection(_ url: URL) {
//        print("Selected file: \(url.path)")
//
//        window = NSWindow(
//            contentRect: NSMakeRect(100, 100, 600, 400),
//            styleMask: [.titled, .closable, .resizable],
//            backing: .buffered,
//            defer: false
//        )
//        window.title = "File Viewer"
//        window.makeKeyAndOrderFront(nil)
//    }

}


