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
    weak var undoManager: UndoManager!
 
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
    
    @objc func append(_ polylines: [MKPolyline]) {
        print("in workplace \(String(describing: undoManager))")
        undoManager?.registerUndo(withTarget: self, selector: #selector(delete), object: polylines)
        polylines.forEach { polyline in
            self.polylines.insert(polyline)
            mapView.addOverlay(polyline)
        }
        zoomToFitAllOverlays()
    }
    
    @objc func delete(_ polylines: [MKPolyline]) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(append), object: polylines)
        polylines.forEach { polyline in
            self.polylines.remove(polyline)
            mapView.removeOverlay(polyline)
        }
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
    
    func redrawPolyline(_ polyline: MKPolyline) {
        mapView.removeOverlay(polyline)
        mapView.addOverlay(polyline)
    }

    func redrawPolylines(_ polylines: Set<MKPolyline>) {
        for polyline in polylines {
            mapView.removeOverlay(polyline)
            mapView.addOverlay(polyline)
        }
    }
    
    @objc func selectPolyline(_ polyline: MKPolyline) {
        undoManager.registerUndo(withTarget: self, selector: #selector(deselectPolyline), object: polyline)
        selectedPolylines.insert(polyline)
        redrawPolyline(polyline)
    }
    
    @objc func deselectPolyline(_ polyline: MKPolyline) {
        undoManager.registerUndo(withTarget: self, selector: #selector(selectPolyline), object: polyline)
        selectedPolylines.remove(polyline)
        redrawPolyline(polyline)
    }

    @objc func selectAll() {
        undoManager.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: selectedPolylines)
        let polylinesToRedraw = self.polylines.subtracting(selectedPolylines)
        selectedPolylines = self.polylines
        redrawPolylines(polylinesToRedraw)
    }
    
    @objc func deselectAll() {
        undoManager.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: selectedPolylines)
        let polylinesToRedraw = selectedPolylines
        selectedPolylines.removeAll()
        redrawPolylines(polylinesToRedraw)
    }

    @objc func resetSelectedPolylines(_ polylines: Set<MKPolyline>) {
        undoManager.registerUndo(withTarget: self, selector: #selector(resetSelectedPolylines), object: selectedPolylines)
        var polylinesToRedraw = selectedPolylines.union(polylines)
        selectedPolylines = polylines
        redrawPolylines(polylinesToRedraw)
    }
    
    func select(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        deselectAll()
        toggleSelection(at: point)
        undoManager?.endUndoGrouping()
    }
    
    func toggleSelection(at point: NSPoint) {
        if let closest = closestPolyline(from: point) {
            toggleSelection(closest)
        }
    }
    
    func toggleSelection(_ polyline: MKPolyline) {
        if isSelected(polyline) {
            deselectPolyline(polyline)
        } else {
            selectPolyline(polyline)
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
    
    @objc func deleteSelected() {
        undoManager.registerUndo(withTarget: self, selector: #selector(undeleteSelected), object: selectedPolylines)
        selectedPolylines.forEach { polyline in
            self.polylines.remove(polyline)
            mapView.removeOverlay(polyline)
        }
        selectedPolylines.removeAll()
    }
    
    @objc func undeleteSelected(_ polylines: Set<MKPolyline>) {
        undoManager.registerUndo(withTarget: self, selector: #selector(deleteSelected), object: nil)
        selectedPolylines = polylines
        polylines.forEach { polyline in
            self.polylines.insert(polyline)
            mapView.addOverlay(polyline)
        }
    }
    
    @objc func copyPolylines() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        //pasteboard.writeObjects(Array(selectedPolylines))
    }
    
    @objc func pastePolylines() {
//        let pasteboard = NSPasteboard.general
//        return pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
    }
    
}
