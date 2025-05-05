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

    var allCaches: Set<GPXCache> = []
    var selectedCaches: Set<GPXCache> = []

    var allPolylines: Set<MKPolyline> = []
    var polylineToCacheMap: [MKPolyline: GPXCache] = [:]

    var cachesToLoad: [GPXCache]?

    public var unselectedFileCaches: Set<GPXCache> {
        return allCaches.subtracting(selectedCaches)
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

