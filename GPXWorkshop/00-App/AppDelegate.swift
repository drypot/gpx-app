//
//  AppDelegate.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    //    var windowController = GPXManagerWindowController()

    func applicationWillFinishLaunching(_ notification: Notification) {
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldOpenUntitledFile(_ sender: NSApplication) -> Bool {
        return true
    }

    //    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    //        return .terminateNow
    //    }

    @IBAction func openDocumentCustomized(_ sender: Any?) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [ .gpx, .gpxWorkshop ]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = true
        panel.canChooseFiles = true
        panel.begin { result in
            guard result == .OK else { return }
            let urls = panel.urls
            var gpxURLs = [URL]()
            var gpxwsURLs = [URL]()
            for url in urls {
                if (url.pathExtension.lowercased() == "gpxws" ) {
                    gpxwsURLs.append(url)
                } else {
                    gpxURLs.append(url)
                }
            }

            // import GPX files

            do {
                let document = try NSDocumentController.shared.makeUntitledDocument(ofType: UTType.gpxWorkshop.identifier) as! GPXDocument
                NSDocumentController.shared.addDocument(document)
                document.makeWindowControllers()
                document.importFilesAndShowWindow(gpxURLs)
            } catch {
                print(error)
                NSApp.presentError(error)
            }

            // TODO: gpxws file open

//            NSDocumentController.shared.openDocument(withContentsOf: url, display: true) { (document, wasAlreadyOpen, error) in
//                if let error = error {
//                    NSApp.presentError(error)
//                }
//            }
        }
    }

}


