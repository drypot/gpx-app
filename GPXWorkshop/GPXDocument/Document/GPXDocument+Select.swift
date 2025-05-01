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
            if selectedFileCaches.contains(cache) {
                deselectFileCaches(selectedFileCaches)
            } else {
                undoManager?.beginUndoGrouping()
                deselectFileCaches(selectedFileCaches)
                selectFileCache(cache)
                undoManager?.endUndoGrouping()
            }
        } else {
            if !selectedFileCaches.isEmpty {
                deselectFileCaches(selectedFileCaches)
            }
        }
    }

    func toggleFileCacheSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestFileCache(at: mapPoint, with: tolerance) {
            if selectedFileCaches.contains(cache) {
                deselectFileCache(cache)
            } else {
                selectFileCache(cache)
            }
        }
    }

    func nearestFileCache(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) -> GPXFileCache? {
        let polyline = self.nearestPolyline(at: mapPoint, with: tolerance)
        return polyline.flatMap { polylineToFileCacheMap[$0] }
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

    @objc func selectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCaches(caches)
        }
        for cache in caches {
            selectFileCacheCore(cache)
        }
    }

    @objc func selectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectFileCache(cache)
        }
        selectFileCacheCore(cache)
    }

    func selectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.insert(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

    @objc func deselectFileCaches() {
        deselectFileCaches(selectedFileCaches)
    }

    @objc func deselectFileCaches(_ caches: Set<GPXFileCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCaches(caches)
        }
        for cache in caches {
            deselectFileCacheCore(cache)
        }
    }

    @objc func deselectFileCache(_ cache: GPXFileCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectFileCache(cache)
        }
        deselectFileCacheCore(cache)
    }

    func deselectFileCacheCore(_ cache: GPXFileCache) {
        selectedFileCaches.remove(cache)
        viewController?.redrawPolylines(cache.polylines)
    }

}
