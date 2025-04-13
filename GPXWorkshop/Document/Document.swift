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

class Document: NSDocument {

    var workplace = Browser()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        guard !isRunningTests else {
            Swift.print("makeWindowControllers skipped")
            return
        }
        Swift.print("makeWindowControllers")
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Browser Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        return try workplace.data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        do {
            let polylines = try GPX.makePolylines(from: data)
            workplace.importPolylines(polylines)
        } catch {
            Swift.print(error.localizedDescription)
        }

//        if UTType(typeName) == .gpx {
//            let newURL = fileURL?.deletingPathExtension().appendingPathExtension(".gpxws")
//            self.fileURL = newURL
//        } else {
//        }
        
    }

}

