//
//  BrowserMapView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit

protocol KeyEventDelegate: AnyObject {
    func handleKeyDown(with event: NSEvent, on view: NSView) -> Bool
}

class BrowserMapView: MKMapView {
    weak var keyEventDelegate: KeyEventDelegate?

    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        if keyEventDelegate?.handleKeyDown(with: event, on: self) != true {
            super.keyDown(with: event)
        }
    }
}
