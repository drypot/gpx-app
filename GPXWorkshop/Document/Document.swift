//
//  Document.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/12/24.
//

import Cocoa
import UniformTypeIdentifiers

class Document: NSDocument {

    var workplace = Workplace()
    var dataToLoad: Data?
    
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
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Workplace Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        return try workplace.data()
    }

    override func read(from data: Data, ofType typeName: String) throws {
        if UTType(typeName) == .gpx {
            dataToLoad = data
//            let newURL = fileURL?.deletingPathExtension().appendingPathExtension(".gpxws")
//            self.fileURL = newURL
        } else {
            dataToLoad = data
        }
    }

}

