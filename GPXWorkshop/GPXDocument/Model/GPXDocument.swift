//
//  Document.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers
import MapKit
import Model

class GPXDocument: NSDocument {

    let viewModel: GPXViewModel
    var viewController: GPXViewController!

    override init() {
        viewModel = GPXViewModel()
        super.init()
    }

//    override class var autosavesInPlace: Bool {
//        return true
//    }

    override func makeWindowControllers() {
        let windowController = GPXWindowController()
        self.addWindowController(windowController)

        viewController = windowController.contentViewController as? GPXViewController
        viewController.representedObject = self
    }

    override func data(ofType typeName: String) throws -> Data {
        //        return try workplace.data()
        //        return Data()
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
//        do {
//            let polylines = try GPXFile.makePolylines(from: data)
//            workplace.importPolylines(polylines)
//        } catch {
//            Swift.print(error.localizedDescription)
//        }

//        if UTType(typeName) == .gpx {
//            let newURL = fileURL?.deletingPathExtension().appendingPathExtension(".gpxws")
//            self.fileURL = newURL
//        } else {
//        }
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    // 프로그램 종료시 저장할지 묻지 않는다.
    override var isDocumentEdited: Bool {
        return false
    }
}

