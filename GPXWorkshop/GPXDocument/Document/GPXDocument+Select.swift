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

    func beginGPXSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestGPX(at: mapPoint, with: tolerance) {
            if selectedGPXCaches.contains(cache) {
                deselectGPXCaches(selectedGPXCaches)
            } else {
                undoManager?.beginUndoGrouping()
                deselectGPXCaches(selectedGPXCaches)
                selectGPXCache(cache)
                undoManager?.endUndoGrouping()
            }
        } else {
            if !selectedGPXCaches.isEmpty {
                deselectGPXCaches(selectedGPXCaches)
            }
        }
    }

    func toggleGPXSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestGPX(at: mapPoint, with: tolerance) {
            if selectedGPXCaches.contains(cache) {
                deselectGPXCache(cache)
            } else {
                selectGPXCache(cache)
            }
        }
    }

    func nearestGPX(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) -> GPXCache? {
        let polyline = self.nearestPolyline(at: mapPoint, with: tolerance)
        return polyline.flatMap { polylineToGPXCacheMap[$0] }
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

    @objc func selectGPXCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectGPXCaches(caches)
        }
        for cache in caches {
            selectGPXCacheCommon(cache)
        }
    }

    @objc func selectGPXCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectGPXCache(cache)
        }
        selectGPXCacheCommon(cache)
    }

    func selectGPXCacheCommon(_ cache: GPXCache) {
        selectedGPXCaches.insert(cache)
        overlaysToRemove.append(contentsOf: cache.polylines)
        overlaysToAdd.append(contentsOf: cache.polylines)
    }

    @objc func deselectGPXCaches() {
        deselectGPXCaches(selectedGPXCaches)
    }

    @objc func deselectGPXCaches(_ caches: Set<GPXCache>) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectGPXCaches(caches)
        }
        for cache in caches {
            deselectGPXCacheCommon(cache)
        }
    }

    @objc func deselectGPXCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectGPXCache(cache)
        }
        deselectGPXCacheCommon(cache)
    }

    func deselectGPXCacheCommon(_ cache: GPXCache) {
        selectedGPXCaches.remove(cache)
        overlaysToRemove.append(contentsOf: cache.polylines)
        overlaysToAdd.append(contentsOf: cache.polylines)
    }

}
