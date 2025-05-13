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

    override init() {
        super.init()
    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)
    }

}

