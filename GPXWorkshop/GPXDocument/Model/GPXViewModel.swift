//
//  GPXViewModel.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import GPXWorkshopSupport

public class GPXViewModel {

    public private(set) var allFileCaches: Set<GPXFileCache> = []
    public private(set) var selectedFileCaches: Set<GPXFileCache> = []

    public private(set) var allPolylines: Set<MKPolyline> = []
    public private(set) var polylineToFileCacheMap: [MKPolyline: GPXFileCache] = [:]

    public weak var view: GPXView!

    public var unselectedFileCaches: Set<GPXFileCache> {
        return allFileCaches.subtracting(selectedFileCaches)
    }

    public init() {
    }

    // MARK: - Find nearest

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
        let p1 = MKMapPoint(view.convert(point, toCoordinateFrom: view))
        let p2 = MKMapPoint(view.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: view))
        let tolerance = p1.distance(to: p2)
        return (p1, tolerance)
    }

    // MARK: - Add/Remove caches

    public func addFileCaches<S: Sequence>(_ caches: S) where S.Element == GPXFileCache {
        for cache in caches {
            addFileCache(cache)
        }
    }

    public func addFileCache(_ cache: GPXFileCache) {
        allFileCaches.insert(cache)

        let polylines = cache.polylines
        for polyline in polylines {
            polylineToFileCacheMap[polyline] = cache
        }
        allPolylines.formUnion(polylines)
        view.addOverlays(polylines)
    }

    public func removeFileCaches<S: Sequence>(_ caches: S) where S.Element == GPXFileCache {
        for cache in caches {
            removeFileCache(cache)
        }
    }

    public func removeFileCache(_ cache: GPXFileCache) {
        allFileCaches.remove(cache)

        let polylines = cache.polylines
        for polyline in polylines {
            polylineToFileCacheMap.removeValue(forKey: polyline)
        }
        allPolylines.subtract(polylines)
        view.removeOverlays(polylines)
    }

    // MARK: - Selection

    public func selectFileCaches(_ caches: Set<GPXFileCache>) {
        for cache in caches {
            selectFileCache(cache)
        }
    }

    public func selectFileCache(_ cache: GPXFileCache) {
        selectedFileCaches.insert(cache)
        view.redrawPolylines(cache.polylines)
    }

    public func deselectFileCaches(_ caches: Set<GPXFileCache>) {
        for cache in caches {
            deselectFileCache(cache)
        }
    }

    public func deselectFileCache(_ cache: GPXFileCache) {
        selectedFileCaches.remove(cache)
        view.redrawPolylines(cache.polylines)
    }

    // MARK: - Delete selected

    public func deleteSelectedFileCaches() {
        let caches = selectedFileCaches
        selectedFileCaches.removeAll()
        removeFileCaches(caches)
    }

    public func restoreSelectedFileCaches(_ caches: Set<GPXFileCache>) {
        selectedFileCaches = caches
        addFileCaches(caches)
    }

}
