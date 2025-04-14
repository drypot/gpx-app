//
//  GPXManagerMapView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit

protocol KeyEventDelegate: AnyObject {
    func handleKeyDown(with event: NSEvent, on view: NSView) -> Bool
}

class GPXManagerMapView: MKMapView {
    weak var keyEventDelegate: KeyEventDelegate?

    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        if keyEventDelegate?.handleKeyDown(with: event, on: self) != true {
            super.keyDown(with: event)
        }
    }

    func zoomToFitAllOverlays() {
        var zoomRect = MKMapRect.null
        overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }
}
