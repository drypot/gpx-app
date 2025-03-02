//
//  AppDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //print("Current working directory: \(URL.currentDirectory())")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return false
    }
}

/*
 @main
 class AppDelegate: NSObject, NSApplicationDelegate {
 var window: NSWindow!

 func applicationDidFinishLaunching(_ notification: Notification) {
 openFileDialog()
 }

 func openFileDialog() {
 let openPanel = NSOpenPanel()
 openPanel.canChooseFiles = true
 openPanel.canChooseDirectories = false
 openPanel.allowsMultipleSelection = false

 if openPanel.runModal() == .OK, let url = openPanel.url {
 handleFileSelection(url)
 } else {
 NSApp.terminate(nil)
 }
 }

 func handleFileSelection(_ url: URL) {
 print("Selected file: \(url.path)")

 window = NSWindow(
 contentRect: NSMakeRect(100, 100, 600, 400),
 styleMask: [.titled, .closable, .resizable],
 backing: .buffered,
 defer: false
 )
 window.title = "File Viewer"
 window.makeKeyAndOrderFront(nil)
 }
 }

 */
