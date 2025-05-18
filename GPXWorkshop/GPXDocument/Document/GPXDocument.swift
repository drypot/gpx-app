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
    var polylineToGPXCacheMap: [MKPolyline: GPXCache] = [:]

    var addedGPXCaches: [GPXCache] = []
    var removedGPXCaches: [GPXCache] = []
    var selectionChangedGPXCaches: [GPXCache] = []

    override init() {
        super.init()
    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)
    }

    func flushUpdated() {
        addedGPXCaches.removeAll()
        removedGPXCaches.removeAll()
        selectionChangedGPXCaches.removeAll()
    }
}

