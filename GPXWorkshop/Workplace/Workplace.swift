//
//  Workplace.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit

class Workplace {
    
    weak var mapView: MKMapView!
 
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
    
    func mapViewNeedUpdate() {
        mapView.needsDisplay = true
    }
    
    func updateMapViewOverlay(_ overlay: MKOverlay) {
        mapView.removeOverlay(overlay)
        mapView.addOverlay(overlay)
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

    func isSelected(_ polyline: MKPolyline) -> Bool {
        return selectedPolylines.contains(polyline)
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

    func deselectAll() {
        var polylines = selectedPolylines
        selectedPolylines.removeAll()
        for polyline in polylines {
            updateMapViewOverlay(polyline)
        }
        mapViewNeedUpdate()
    }

    func select(at point: NSPoint) {
        deselectAll()
        toggleSelection(at: point)
    }
    
    func toggleSelection(at point: NSPoint) {
        if let closest = closestPolyline(from: point) {
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
    
    func closestPolyline(from point: NSPoint) -> MKPolyline? {
        let (mapPoint, tolerance) = mapPoint(at: point)
        var closest: MKPolyline?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for polyline in polylines {
            let rect = polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance)
            if !rect.contains(mapPoint) {
                continue
            }
            let distance = distance(from: mapPoint, to: polyline)
            if distance < tolerance, distance < minDistance {
                minDistance = distance
                closest = polyline
            }
        }
        return closest
    }

    func mapPoint(at point: NSPoint) -> (MKMapPoint, CLLocationDistance) {
        let limit = 10.0
        let p1 = MKMapPoint(mapView.convert(point, toCoordinateFrom: mapView))
        let p2 = MKMapPoint(mapView.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: mapView))
        let tolerance = p1.distance(to: p2)
        return (p1,tolerance)
    }
    
    func removeSelected() {
        selectedPolylines.forEach { polyline in
            polylines.remove(polyline)
            mapView.removeOverlay(polyline)
        }
        mapViewNeedUpdate()
    }
}
