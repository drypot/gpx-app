//
//  Document.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers
import MapKit
import GPXWorkshopSupport

class GPXDocument: NSDocument {

    var allFileCaches: Set<GPXFileCache> = []
    var selectedFileCaches: Set<GPXFileCache> = []

    var allPolylines: Set<MKPolyline> = []
    var polylineToFileCacheMap: [MKPolyline: GPXFileCache] = [:]

    var fileCachesToLoad: [GPXFileCache]?

    public var unselectedFileCaches: Set<GPXFileCache> {
        return allFileCaches.subtracting(selectedFileCaches)
    }

    weak var viewController: GPXViewController?

    override init() {
        super.init()
    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)

        viewController = windowController.contentViewController as? GPXViewController
        viewController?.representedObject = self
        if let fileCachesToLoad {
            undoManager?.disableUndoRegistration()
            addFileCaches(fileCachesToLoad)
            self.fileCachesToLoad = nil
            undoManager?.enableUndoRegistration()
            viewController?.zoomToFitAllOverlays()
        }
    }

}

