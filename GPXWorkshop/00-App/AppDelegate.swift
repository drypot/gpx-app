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
//        let types = UTType.types(tag: "gpx", tagClass: .filenameExtension, conformingTo: nil)
//        for type in types {
//            print(type.identifier)
//        }
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

    // 일단 당분간 사용하지 않는 코드
    // 이상한 짓하지 않고
    // AppKit 기본 openDocument 를 쓰기로 했다.

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
                let documentController = NSDocumentController.shared
                let document = try documentController.makeUntitledDocument(ofType: UTType.gpxWorkshop.identifier) as! GPXDocument
                documentController.addDocument(document)
                document.undoManager?.disableUndoRegistration()
                document.importFiles(gpxURLs)
                document.undoManager?.enableUndoRegistration()
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


