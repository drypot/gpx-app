//
//  GPXManagerMapView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit
import Model

class GPXManagerMapView: MKMapView {

    private unowned let manager: GPXManager
    private var allPolylines: Set<MKPolyline> = []
    private var gpxPolylineMap: [GPXFile: [MKPolyline]] = [:]
    private var polylineGPXMap: [MKPolyline: GPXFile] = [:]

    init(manager: GPXManager) {
        self.manager = manager
        super.init(frame: .zero)
        self.delegate = self
        self.manager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Drawing

    func redrawPolyline(_ polyline: MKPolyline) {
        removeOverlay(polyline)
        addOverlay(polyline)
    }

    func redrawPolylines<S: Sequence>(_ polylines: S) where S.Element == MKPolyline {
        for polyline in polylines {
            redrawPolyline(polyline)
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

    // Find nearest

    func closestGPXFile(at point: NSPoint) -> GPXFile? {
        let polyline = self.nearestPolyline(to: point)
        return polyline.flatMap { polylineGPXMap[$0] }
    }

    private func nearestPolyline(to point: NSPoint) -> MKPolyline? {
        let (mapPoint, tolerance) = mapPoint(at: point)
        var closest: MKPolyline?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for polyline in allPolylines {
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

    func dumpCount() {
        print("---")
        print("dump counts: \(allPolylines.count) \(gpxPolylineMap.count) \(polylineGPXMap.count)")
    }

}

extension GPXManagerMapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = polylineGPXMap[polyline] {
                let renderer = MKPolylineRenderer(polyline: polyline)
                if manager.selectedFiles.contains(gpx) {
                    renderer.strokeColor = .red
                } else {
                    renderer.strokeColor = .blue
                }
                renderer.lineWidth = 3.0
                return renderer
            }
        }
        return MKOverlayRenderer(overlay: overlay)
    }

}

extension GPXManagerMapView: GPXManagerDelegate {

    public func managerDidAddFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        for file in files {
            add(file)
        }
        dumpCount()
    }

    private func add(_ file: GPXFile) {
        var polylines = [MKPolyline]()
        for track in file.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
                polylineGPXMap[polyline] = file
            }
        }
        allPolylines.formUnion(polylines)
        gpxPolylineMap[file] = polylines
        addOverlays(polylines)
    }

    func managerDidRemoveFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        for file in files {
            remove(file)
        }
    }

    private func remove(_ file: GPXFile) {
        let polylines = gpxPolylineMap[file] ?? []
        allPolylines.subtract(polylines)
        gpxPolylineMap.removeValue(forKey: file)
        for polyline in polylines {
            polylineGPXMap.removeValue(forKey: polyline)
        }
        removeOverlays(polylines)
    }

    public func managerDidSelect(_ file: Model.GPXFile) {
        let polylines = gpxPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidDeselect(_ file: Model.GPXFile) {
        let polylines = gpxPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidSelectFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeselectFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        for file in files {
            remove(file)
        }
    }

    func managerDidUndeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXFile {
        for file in files {
            add(file)
        }
    }

}
