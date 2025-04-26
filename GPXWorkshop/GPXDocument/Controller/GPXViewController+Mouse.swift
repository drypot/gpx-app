//
//  GPXViewController+Mouse.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    override func mouseDown(with event: NSEvent) {
        initialClickLocation = gpxView.convert(event.locationInWindow, from: nil)
        isDragging = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation = initialClickLocation else { return }

        let currentLocationInView = gpxView.convert(event.locationInWindow, from: nil)

        let dx = currentLocationInView.x - initialClickLocation.x
        let dy = currentLocationInView.y - initialClickLocation.y
        let distance = sqrt(dx * dx + dy * dy)

        if distance > tolerance {
            isDragging = true
            //            handleDrag(to: currentLocationInView)
        }
    }

    override func mouseUp(with event: NSEvent) {
        if !isDragging, let initialClickLocation = initialClickLocation {
            if event.modifierFlags.contains(.shift) {
                handleShiftClick(at: initialClickLocation)
            } else {
                handleClick(at: initialClickLocation)
            }
        }
        initialClickLocation = nil
        isDragging = false
    }

    func handleClick(at point: NSPoint) {
        beginFileCacheSelection(at: point)
    }

    func handleShiftClick(at point: NSPoint) {
        toggleFileCacheSelection(at: point)
    }

}
