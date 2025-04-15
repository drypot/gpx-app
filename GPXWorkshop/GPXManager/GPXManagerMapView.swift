//
//  GPXManagerMapView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit
import Model

//protocol KeyEventDelegate: AnyObject {
//    func handleKeyDown(with event: NSEvent, on view: NSView) -> Bool
//}

class GPXManagerMapView: MKMapView {

    private var polylines: Set<MKPolyline> = []
    private var selectedPolylines: Set<MKPolyline> = []

    init() {
        super.init(frame: .zero)
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    weak var keyEventDelegate: KeyEventDelegate?

//    // 키를 입력 받기 위해 꼭 필요
//    override var acceptsFirstResponder: Bool {
//        return true
//    }
//
//    // 키를 입력 받기 위해 꼭 필요
//    override func keyDown(with event: NSEvent) {
//        if keyEventDelegate?.handleKeyDown(with: event, on: self) != true {
//            super.keyDown(with: event)
//        }
//    }

    func redrawPolyline(_ polyline: MKPolyline) {
        removeOverlay(polyline)
        addOverlay(polyline)
    }

    func redrawPolylines(_ polylines: Set<MKPolyline>) {
        for polyline in polylines {
            removeOverlay(polyline)
            addOverlay(polyline)
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
            let distance = GPXUtils.calcDistance(from: mapPoint, to: polyline)
            if distance < tolerance, distance < minDistance {
                minDistance = distance
                closest = polyline
            }
        }
        return closest
    }

    func mapPoint(at point: NSPoint) -> (MKMapPoint, CLLocationDistance) {
        let limit = 10.0
        let p1 = MKMapPoint(convert(point, toCoordinateFrom: self))
        let p2 = MKMapPoint(convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: self))
        let tolerance = p1.distance(to: p2)
        return (p1,tolerance)
    }

    func selectedPolylinesContains(_ polyline: MKPolyline) -> Bool {
        return selectedPolylines.contains(polyline)
    }

    func selectedPolylinesInsert(_ polyline: MKPolyline) {
        selectedPolylines.insert(polyline)
        redrawPolyline(polyline)
    }

    func selectedPolylinesRemove(_ polyline: MKPolyline) {
        selectedPolylines.remove(polyline)
        redrawPolyline(polyline)
    }

    func deleteSelected() {
        polylines.subtract(selectedPolylines)
        selectedPolylines.removeAll()
    }

    func undeleteSelected(_ polylines: Set<MKPolyline>) {
        self.polylines = self.polylines.union(polylines)
        selectedPolylines = polylines
    }

    func dumpCount() {
        print("---")
        print("polylines: \(polylines.count)")
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

extension GPXManagerMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            if selectedPolylines.contains(polyline) {
                renderer.strokeColor = .red
            } else {
                renderer.strokeColor = .blue
            }
            renderer.lineWidth = 3.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension GPXManagerMapView: GPXManagerDelegate {

    public func managerDidAddFiles(_ files: [GPXFile]) {
        var newPolylines: [MKPolyline] = []
        for file in files {
            for track in file.tracks {
                for segment in track.segments {
                    newPolylines.append(GPXUtils.makePolyline(from: segment))
                }
            }
        }
        polylines.formUnion(newPolylines)
        Task { @MainActor in
            addOverlays(newPolylines)
            zoomToFitAllOverlays()
        }
    }

    func managerDidRemoveFiles(_ files: [Model.GPXFile]) {

    }

    public func managerDidSelectFile(_ file: Model.GPXFile) {

    }

    public func managerDidUnselectFiles() {

    }

    public func managerDidDeleteSelectedFiles() {

    }

    public func managerDidUndeleteSelectedFiles(_ undoFiles: Set<Model.GPXFile>) {

    }

}
