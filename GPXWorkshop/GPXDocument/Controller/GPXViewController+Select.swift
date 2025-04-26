//
//  File.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//


import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXViewController {

    // Find nearest

    func nearestFileCache(to point: NSPoint) -> GPXFileCache? {
        let polyline = self.nearestPolyline(to: point)
        return polyline.flatMap { polylineToFileCacheMap[$0] }
    }

    func nearestPolyline(to point: NSPoint) -> MKPolyline? {
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
        let p1 = MKMapPoint(mapView.convert(point, toCoordinateFrom: mapView))
        let p2 = MKMapPoint(mapView.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: mapView))
        let tolerance = p1.distance(to: p2)
        return (p1, tolerance)
    }
    
    // Select

    @IBAction override func selectAll(_ sender: Any?) {
        selectFileCaches(unselectedFileCaches)
    }

    func beginFileCacheSelection(at point: NSPoint) {
        undoManager?.beginUndoGrouping()
        deselectFileCaches(selectedFileCaches)
        if let cache = nearestFileCache(to: point) {
            selectFileCache(cache)
        }
        undoManager?.endUndoGrouping()
    }

    func toggleFileCacheSelection(at point: NSPoint) {
        if let cache = nearestFileCache(to: point) {
            if selectedFileCaches.contains(cache) {
                deselectFileCache(cache)
            } else {
                selectFileCache(cache)
            }
        }
    }

    @objc func selectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFileCaches), object: caches)
        for cache in caches {
            selectFileCacheCore(cache)
        }
    }

    @objc func selectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(deselectFileCache), object: cache)
        selectFileCacheCore(cache)
    }

    public func selectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.insert(cache)
        redrawPolylines(cache.polylines)
    }

    @objc func deselectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFileCaches), object: caches)
        for cache in caches {
            deselectFileCacheCore(cache)
        }
    }

    @objc func deselectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self, selector: #selector(selectFileCache), object: cache)
        deselectFileCacheCore(cache)
    }

    public func deselectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.remove(cache)
        redrawPolylines(cache.polylines)
    }
}
