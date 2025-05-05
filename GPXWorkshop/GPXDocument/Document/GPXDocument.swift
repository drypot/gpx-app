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

    var allGPXCaches: Set<GPXCache> = []
    var selectedGPXCaches: Set<GPXCache> = []

    var allPolylines: Set<MKPolyline> = []
    var polylineToGPXCacheMap: [MKPolyline: GPXCache] = [:]

    var gpxCachesToLoad: [GPXCache]?

    public var unselectedGPXCaches: Set<GPXCache> {
        return allGPXCaches.subtracting(selectedGPXCaches)
    }

    weak var viewController: GPXViewController?

    override init() {
        super.init()
    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)

//        viewController = windowController.contentViewController as? GPXViewController
//        viewController?.representedObject = self
    }

}

