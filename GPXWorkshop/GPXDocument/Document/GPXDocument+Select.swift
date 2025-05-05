//
//  GPXDocument+Select.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 4/26/25.
//

import Foundation
import MapKit
import GPXWorkshopSupport

extension GPXDocument {

    @IBAction func selectAll(_ sender: Any?) {
        selectFileCaches(unselectedFileCaches)
    }

    func beginFileCacheSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestFileCache(at: mapPoint, with: tolerance) {
            if selectedCaches.contains(cache) {
                deselectFileCaches(selectedCaches)
            } else {
                undoManager?.beginUndoGrouping()
                deselectFileCaches(selectedCaches)
                selectFileCache(cache)
                undoManager?.endUndoGrouping()
            }
        } else {
            if !selectedCaches.isEmpty {
                deselectFileCaches(selectedCaches)
            }
        }
    }

    func toggleFileCacheSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestFileCache(at: mapPoint, with: tolerance) {
            if selectedCaches.contains(cache) {
                deselectFileCache(cache)
            } else {
                selectFileCache(cache)
            }
        }
    }

    func nearestFileCache(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) -> GPXCache? {
        let polyline = self.nearestPolyline(at: mapPoint, with: tolerance)
        return polyline.flatMap { polylineToCacheMap[$0] }
    }

    func nearestPolyline(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) -> MKPolyline? {
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

    @objc func selectFileCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCaches(caches)
        }
        for cache in caches {
            selectFileCacheCore(cache)
        }
    }

    @objc func selectFileCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCache(cache)
        }
        selectFileCacheCore(cache)
    }

    func selectFileCacheCore(_ cache: GPXCache) {
        selectedCaches.insert(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

    @objc func deselectFileCaches() {
        deselectFileCaches(selectedCaches)
    }

    @objc func deselectFileCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCaches(caches)
        }
        for cache in caches {
            deselectFileCacheCore(cache)
        }
    }

    @objc func deselectFileCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCache(cache)
        }
        deselectFileCacheCore(cache)
    }

    func deselectFileCacheCore(_ cache: GPXCache) {
        selectedCaches.remove(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

}
