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
            if cache.isSelected {
                deselectAllGPXCaches()
            } else {
                deselectAllGPXCaches()
                selectGPXCache(cache)
            }
        } else {
            deselectAllGPXCaches()
        }
    }

    func toggleGPXSelection(at mapPoint: MKMapPoint, with tolerance: CLLocationDistance) {
        if let cache = nearestGPX(at: mapPoint, with: tolerance) {
            if cache.isSelected {
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
        for cache in allGPXCaches {
            for polyline in cache.polylines {
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
        }
        return nearest
    }

    func selectAllGPXCaches() {
        for cache in allGPXCaches {
            if !cache.isSelected {
                selectGPXCache(cache)
            }
        }
    }

    func deselectAllGPXCaches() {
        for cache in allGPXCaches {
            if cache.isSelected {
                deselectGPXCache(cache)
            }
        }
    }

    // MARK: - Select Core

    func selectGPXCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.deselectGPXCache(cache)
        }
        cache.isSelected = true
        updatedGPXCaches.append(cache)
    }

    func deselectGPXCache(_ cache: GPXCache) {
        undoManager?.registerUndo(withTarget: self) {
            $0.selectGPXCache(cache)
        }
        cache.isSelected = false
        updatedGPXCaches.append(cache)
    }

}
