//
//  GPXView.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/21/24.
//

import Foundation
import MapKit
import Model

class GPXView: MKMapView {

    private var allPolylines: Set<MKPolyline> = []
    private var gpxToPolylineMap: [GPXCache: [MKPolyline]] = [:]
    private var polylineToGPXMap: [MKPolyline: GPXCache] = [:]

    weak var manager: GPXManager!

    init() {
        super.init(frame: .zero)
        self.delegate = self
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

    func nearestGPXFile(to point: NSPoint) -> GPXCache? {
        let polyline = self.nearestPolyline(to: point)
        return polyline.flatMap { polylineToGPXMap[$0] }
    }

    private func nearestPolyline(to point: NSPoint) -> MKPolyline? {
        let (mapPoint, tolerance) = mapPoint(at: point)
        var nearest: MKPolyline?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        for polyline in allPolylines {
            let rect = polyline.boundingMapRect.insetBy(dx: -tolerance, dy: -tolerance)
            if !rect.contains(mapPoint) {
                continue
            }
            let distance = GPXUtils.calcDistance(from: mapPoint, to: polyline)
            if distance < tolerance, distance < minDistance {
                minDistance = distance
                nearest = polyline
            }
        }
        return nearest
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
        print("dump counts: \(allPolylines.count) \(gpxToPolylineMap.count) \(polylineToGPXMap.count)")
    }

}

extension GPXView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            if let gpx = polylineToGPXMap[polyline] {
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

extension GPXView: GPXManagerDelegate {

    public func managerDidAddGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        for file in files {
            add(file)
        }
        dumpCount()
    }

    private func add(_ file: GPXCache) {
        var polylines = [MKPolyline]()
        for track in file.file.tracks {
            for segment in track.segments {
                let polyline = GPXUtils.makePolyline(from: segment)
                polylines.append(polyline)
                polylineToGPXMap[polyline] = file
            }
        }
        allPolylines.formUnion(polylines)
        gpxToPolylineMap[file] = polylines
        addOverlays(polylines)
    }

    func managerDidRemoveGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        for file in files {
            remove(file)
        }
    }

    private func remove(_ file: GPXCache) {
        let polylines = gpxToPolylineMap[file] ?? []
        allPolylines.subtract(polylines)
        gpxToPolylineMap.removeValue(forKey: file)
        for polyline in polylines {
            polylineToGPXMap.removeValue(forKey: polyline)
        }
        removeOverlays(polylines)
    }

    public func managerDidSelectGPXFile(_ file: GPXCache) {
        let polylines = gpxToPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidDeselectGPXFile(_ file: GPXCache) {
        let polylines = gpxToPolylineMap[file] ?? []
        redrawPolylines(polylines)
    }

    func managerDidSelectGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxToPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeselectGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        var polylines: [MKPolyline] = []
        for file in files {
            polylines.append(contentsOf: gpxToPolylineMap[file] ?? [])
        }
        redrawPolylines(polylines)
    }

    func managerDidDeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        for file in files {
            remove(file)
        }
    }

    func managerDidUndeleteSelectedGPXFiles<S: Sequence>(_ files: S) where S.Element == GPXCache {
        for file in files {
            add(file)
        }
    }

}
