//
//  GPXViewController+File.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/9/25.
//


import Cocoa
import UniformTypeIdentifiers
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    @IBAction func importFiles(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [
//            .gpx,
            UTType(filenameExtension: "gpx")!
        ]
        panel.begin { [unowned self] result in
            guard result == .OK else { return }
            importFilesCommon(from: panel.urls)
        }
    }

    @IBAction func importSamples(_ sender: Any) {
        let urls = [URL(string: "Documents/GPX%20Files%20Subset/", relativeTo:  .currentDirectory())!]
        importFilesCommon(from: urls)
    }

    func importFilesCommon(from urls: [URL]) {
        Task {
            do {
                let caches = try document.gpxCaches(from: urls)
                await MainActor.run {
                    document.addGPXCaches(caches)
                    mapViewController.updateOverlays()
                    mapViewController.zoomToFitAllOverlays()
                    sidebarController.updateItems()
                }
            } catch {
                print(error)
            }
        }
    }

    @IBAction func exportFile(_ sender: Any) {
        fatalError("Test!")
        //        let panel = NSSavePanel()
        //        panel.allowedContentTypes = [.gpx]
        //        panel.begin { result in
        //            guard result == .OK else { return }
        //            guard let url = panel.url else { return }
        //            do {
        //                try self.browser.data().write(to: url)
        //            } catch {
        //                print(error.localizedDescription)
        //            }
        //        }
    }

    // 일단 당분간 사용하지 않는 코드
    // 이상한 짓하지 않고
    // AppKit 기본 openDocument 를 쓰기로 했다.

//    @IBAction func openDocumentCustomized(_ sender: Any?) {
//        let panel = NSOpenPanel()
//        panel.allowedContentTypes = [ .gpx, .gpxWorkshop ]
//        panel.allowsMultipleSelection = true
//        panel.canChooseDirectories = true
//        panel.canChooseFiles = true
//        panel.begin { result in
//            guard result == .OK else { return }
//            let urls = panel.urls
//            var gpxURLs = [URL]()
//            var gpxwsURLs = [URL]()
//            for url in urls {
//                if (url.pathExtension.lowercased() == "gpxws" ) {
//                    gpxwsURLs.append(url)
//                } else {
//                    gpxURLs.append(url)
//                }
//            }
//
//            // import GPX files
//
//            do {
//                let documentController = NSDocumentController.shared
//                let document = try documentController.makeUntitledDocument(ofType: UTType.gpxWorkshop.identifier) as! GPXDocument
//                documentController.addDocument(document)
//                document.undoManager?.disableUndoRegistration()
//                document.importFiles(gpxURLs)
//                document.undoManager?.enableUndoRegistration()
//            } catch {
//                print(error)
//                NSApp.presentError(error)
//            }
//
//            // TODO: gpxws file open
//
//            //            NSDocumentController.shared.openDocument(withContentsOf: url, display: true) { (document, wasAlreadyOpen, error) in
//            //                if let error = error {
//            //                    NSApp.presentError(error)
//            //                }
//            //            }
//        }
//    }
    
}
