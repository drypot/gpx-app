//
//  Workplace.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

class Workplace {
    
    var mapView: MKMapView!
 
    private var polylines: Set<MKPolyline> = []
    private var selectedPolylines: Set<MKPolyline> = []

    func dumpDebugInfo() {
        print("---")
        print("polylines: \(polylines.count)")
    }

    func importGPX(from data: Data) throws {
        let polylines = try MKPolyline.polylines(from: data)
        append(polylines)
    }
    
    func importGPX(from urls: [URL], complete: @escaping () -> Void) {
        Task { [unowned self] in
            let newPolylines = try await MKPolyline.polylines(from: urls)
            Task { @MainActor in
                self.append(newPolylines)
                complete()
            }
        }
    }
    
    func exportGPX() {
        print("Export GPX")
    }
    
    func append(_ newPolylines: [MKPolyline]) {
        newPolylines.forEach { polyline in
            polylines.insert(polyline)
            mapView.addOverlay(polyline)
        }
        zoomToFitAllOverlays()
        mapViewNeedUpdate()
    }

    func zoomToFitAllOverlays() {
        var zoomRect = MKMapRect.null
        mapView.overlays.forEach { overlay in
            zoomRect = zoomRect.union(overlay.boundingMapRect)
        }
        if !zoomRect.isNull {
            let edgePadding = NSEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: false)
        }
    }

    func mapViewNeedUpdate() {
        mapView.needsDisplay = true
    }
    
    func select(_ polyline: MKPolyline) {
        selectedPolylines.insert(polyline)
        updateMapViewOverlay(polyline)
        mapViewNeedUpdate()
    }
    
    func deselect(_ polyline: MKPolyline) {
        selectedPolylines.remove(polyline)
        updateMapViewOverlay(polyline)
        mapViewNeedUpdate()
    }

    func updateMapViewOverlay(_ overlay: MKOverlay) {
        mapView.removeOverlay(overlay)
        mapView.addOverlay(overlay)
    }
    
    func isSelected(_ polyline: MKPolyline) -> Bool {
        return selectedPolylines.contains(polyline)
    }
    
    func toggleSelection(at point: NSPoint) {
        let p1 = MKMapPoint(mapView.convert(point, toCoordinateFrom: mapView))
        let p2 = MKMapPoint(mapView.convert(CGPoint(x: point.x + 10, y: point.y), toCoordinateFrom: mapView))
        let tolerance = p1.distance(to: p2)
        if let closest = closestPolyline(from: p1, tolerance: tolerance) {
            toggleSelection(closest)
        }
    }
    
    func toggleSelection(_ polyline: MKPolyline) {
        if isSelected(polyline) {
            deselect(polyline)
        } else {
            select(polyline)
        }
    }
    
    func closestPolyline(from point: MKMapPoint, tolerance: CLLocationDistance) -> MKPolyline? {
        var closest: MKPolyline?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for polyline in polylines {
            let rect = polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance)
            if !rect.contains(point) {
                continue
            }
            let distance = distance(from: point, to: polyline)
            if distance < tolerance, distance < minDistance {
                minDistance = distance
                closest = polyline
            }
        }
        return closest
    }

    func removeSelected() {
        selectedPolylines.forEach { polyline in
            polylines.remove(polyline)
            mapView.removeOverlay(polyline)
            mapViewNeedUpdate()
        }
    }
}
