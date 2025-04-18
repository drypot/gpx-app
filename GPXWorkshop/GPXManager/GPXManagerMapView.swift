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
    private var gpxBoxToPolylineMap: [GPXBox: [MKPolyline]] = [:]
    private var polylineToGPXBoxMap: [MKPolyline: GPXBox] = [:]

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

    func closestGPXFile(at point: NSPoint) -> GPXBox? {
        let polyline = self.nearestPolyline(to: point)
        return polyline.flatMap { polylineToGPXBoxMap[$0] }
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
        print("dump counts: \(allPolylines.count) \(gpxBoxToPolylineMap.count) \(polylineToGPXBoxMap.count)")
    }

}

extension GPXManagerMapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = polylineToGPXBoxMap[polyline] {
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

    public func managerDidAddFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        for file in files {
            add(file)
        }
        dumpCount()
    }

    private func add(_ file: GPXBox) {
        var polylines = [MKPolyline]()
        for track in file.value.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
                polylineToGPXBoxMap[polyline] = file
            }
        }
        allPolylines.formUnion(polylines)
        gpxBoxToPolylineMap[file] = polylines
        addOverlays(polylines)
    }

    func managerDidRemoveFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        for file in files {
            remove(file)
        }
    }

    private func remove(_ file: GPXBox) {
        let polylines = gpxBoxToPolylineMap[file] ?? []
        allPolylines.subtract(polylines)
        gpxBoxToPolylineMap.removeValue(forKey: file)
        for polyline in polylines {
            polylineToGPXBoxMap.removeValue(forKey: polyline)
        }
        removeOverlays(polylines)
    }

    public func managerDidSelect(_ file: GPXBox) {
        let polylines = gpxBoxToPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidDeselect(_ file: GPXBox) {
        let polylines = gpxBoxToPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidSelectFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxBoxToPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeselectFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxBoxToPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        for file in files {
            remove(file)
        }
    }

    func managerDidUndeleteSelectedFiles<S: Sequence>(_ files: S) where S.Element == GPXBox {
        for file in files {
            add(file)
        }
    }

}
