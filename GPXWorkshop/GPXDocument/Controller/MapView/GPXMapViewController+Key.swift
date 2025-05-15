//
//  GPXMapViewController+Key.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController {

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        let characters = event.charactersIgnoringModifiers ?? ""
        for character in characters {
            switch character {
            case "\u{7F}": // delete
                mainController!.removeSelectedGPXCaches()
            default:
                break
            }
        }
    }
    
}
