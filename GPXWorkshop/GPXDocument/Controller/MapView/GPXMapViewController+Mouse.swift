//
//  GPXMapViewController+Mouse.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Cocoa
import MapKit
import GPXWorkshopSupport

extension GPXMapViewController {

    override func mouseDown(with event: NSEvent) {
        initialClickLocation = mapView.convert(event.locationInWindow, from: nil)
        isDragging = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard let initialClickLocation else { return }

        let currentClickLocation = mapView.convert(event.locationInWindow, from: nil)

        let dx = currentClickLocation.x - initialClickLocation.x
        let dy = currentClickLocation.y - initialClickLocation.y
        let distance = sqrt(dx * dx + dy * dy)

        if distance > tolerance {
            isDragging = true
//            handleDrag(to: currentLocationInView)
        }
    }

    override func mouseUp(with event: NSEvent) {
        if isDragging {
            //...
        } else {
            if let initialClickLocation {
                if event.modifierFlags.contains(.shift) {
                    handleShiftClick(at: initialClickLocation)
                } else {
                    handleClick(at: initialClickLocation)
                }
            }
        }
        initialClickLocation = nil
        isDragging = false
    }

    func handleClick(at point: NSPoint) {
        let (mapPoint, tolerance) = mapPoint(at: point)
        baseController!.beginGPXSelection(at: mapPoint, with: tolerance)
    }

    func handleShiftClick(at point: NSPoint) {
        let (mapPoint, tolerance) = mapPoint(at: point)
        baseController!.toggleGPXSelection(at: mapPoint, with: tolerance)
    }

    func mapPoint(at point: NSPoint) -> (MKMapPoint, CLLocationDistance) {
        let limit = 10.0
        let p1 = MKMapPoint(mapView.convert(point, toCoordinateFrom: mapView))
        let p2 = MKMapPoint(mapView.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: mapView))
        let tolerance = p1.distance(to: p2)
        return (p1, tolerance)
    }
    
}
