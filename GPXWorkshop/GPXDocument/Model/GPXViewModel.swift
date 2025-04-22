//
//  GPXViewModel.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 8/20/24.
//

import Foundation
import MapKit
import Model

public class GPXViewModel {

    public private(set) var allFiles: Set<GPXFileCache> = []
    public private(set) var selectedFiles: Set<GPXFileCache> = []

    public private(set) var allPolylines: Set<MKPolyline> = []
    public private(set) var polylineToGPXMap: [MKPolyline: GPXFileCache] = [:]

    public weak var gpxView: GPXView!

    public var unselectedFiles: Set<GPXFileCache> {
        return allFiles.subtracting(selectedFiles)
    }

    public init() {
    }

    // MARK: - Find nearest

    func nearestFile(to point: NSPoint) -> GPXFileCache? {
        let polyline = self.nearestPolyline(to: point)
        return polyline.flatMap { polylineToGPXMap[$0] }
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
        let p1 = MKMapPoint(gpxView.convert(point, toCoordinateFrom: gpxView))
        let p2 = MKMapPoint(gpxView.convert(CGPoint(x: point.x + limit, y: point.y), toCoordinateFrom: gpxView))
        let tolerance = p1.distance(to: p2)
        return (p1, tolerance)
    }

    // MARK: - Add/Remove files

    public func addFiles<S: Sequence>(_ files: S) where S.Element == GPXFileCache {
        for file in files {
            addFile(file)
        }
    }

    public func addFile(_ file: GPXFileCache) {
        allFiles.insert(file)

        let polylines = file.polylines
        for polyline in polylines {
            polylineToGPXMap[polyline] = file
        }
        allPolylines.formUnion(polylines)
        gpxView.addOverlays(polylines)
    }

    public func removeFiles<S: Sequence>(_ files: S) where S.Element == GPXFileCache {
        for file in files {
            removeFile(file)
        }
    }

    public func removeFile(_ file: GPXFileCache) {
        allFiles.remove(file)

        let polylines = file.polylines
        for polyline in polylines {
            polylineToGPXMap.removeValue(forKey: polyline)
        }
        allPolylines.subtract(polylines)
        gpxView.removeOverlays(polylines)
    }

    // MARK: - Selection

    public func selectFiles(_ files: Set<GPXFileCache>) {
        for file in files {
            selectFile(file)
        }
    }

    public func selectFile(_ file: GPXFileCache) {
        selectedFiles.insert(file)
        gpxView.redrawPolylines(file.polylines)
    }

    public func deselectFiles(_ files: Set<GPXFileCache>) {
        for file in files {
            deselectFile(file)
        }
    }

    public func deselectFile(_ file: GPXFileCache) {
        selectedFiles.remove(file)
        gpxView.redrawPolylines(file.polylines)
    }

    // MARK: - Delete selected

    public func deleteSelectedFiles() {
        let files = selectedFiles
        selectedFiles.removeAll()
        removeFiles(files)
    }

    public func undeleteSelectedFiles(_ files: Set<GPXFileCache>) {
        selectedFiles = files
        addFiles(files)
    }

}
