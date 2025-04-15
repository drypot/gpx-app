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
    private var gpxPolylinesMap: [GPXFile: [MKPolyline]] = [:]
    private var polylinesGPXMap: [MKPolyline: GPXFile] = [:]

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

    func redrawPolylines(_ polylines: [MKPolyline]) {
        for polyline in polylines {
            removeOverlay(polyline)
            addOverlay(polyline)
        }
    }

//    func redrawPolylines(_ polylines: Set<MKPolyline>) {
//        for polyline in polylines {
//            removeOverlay(polyline)
//            addOverlay(polyline)
//        }
//    }

    func closestGPXFile(from point: NSPoint) -> GPXFile? {
        let closestPolyline = self.closestPolyline(from: point)
        return closestPolyline.flatMap { polylinesGPXMap[$0] }
    }

    private func closestPolyline(from point: NSPoint) -> MKPolyline? {
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

//    func selectedPolylinesContains(_ polyline: MKPolyline) -> Bool {
//        return selectedPolylines.contains(polyline)
//    }


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
        print("dump counts: \(polylines.count) \(selectedPolylines.count) \(gpxPolylinesMap.count) \(polylinesGPXMap.count)")
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
            var filePolylines = [MKPolyline]()
            for track in file.tracks {
                for segment in track.segments {
                    let polyline = GPXUtils.makePolyline(from: segment)
                    filePolylines.append(polyline)
                    polylinesGPXMap[polyline] = file
                }
            }
            newPolylines.append(contentsOf: filePolylines)
            gpxPolylinesMap[file] = filePolylines
        }
        polylines.formUnion(newPolylines)
        addOverlays(newPolylines)
        zoomToFitAllOverlays()
        dumpCount()
    }

    func managerDidRemoveFiles(_ files: [Model.GPXFile]) {

    }

    public func managerDidSelectFile(_ file: Model.GPXFile) {
        let polylines = gpxPolylinesMap[file] ?? []
        selectedPolylines.formUnion(polylines)
        redrawPolylines(polylines)
    }

    func managerDidDeselectFile(_ file: Model.GPXFile) {
        let polylines = gpxPolylinesMap[file] ?? []
        selectedPolylines.subtract(polylines)
        redrawPolylines(polylines)
    }

    public func managerDidDeselectFiles() {

    }

    public func managerDidDeleteSelectedFiles() {

    }

    public func managerDidUndeleteSelectedFiles(_ undoFiles: Set<Model.GPXFile>) {

    }

}
