//
//  MapKitSegments.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation
import MapKit

final class MapKitSegments: ObservableObject {
    @Published private var polylines: Set<MKPolyline> = []
    @Published private var selectedPolylines: Set<MKPolyline> = []
    var needZoomtoFit = false
    
    func addGPXSegment(_ gpxSegment: GPX.Segment) {
        let points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        let poly = MKPolyline(coordinates: points, count: points.count)
        polylines.insert(poly)
    }

    func addGPXSegments(_ gpxSegments: [GPX.Segment]) {
        gpxSegments.forEach { self.addGPXSegment($0) }
    }
    
    func selectPolyline(_ polyline: MKPolyline) {
        selectedPolylines.insert(polyline)
    }
    
    func deselectPolyline(_ polyline: MKPolyline) {
        selectedPolylines.remove(polyline)
    }
    
    func polylineIsSelected(_ polyline: MKPolyline) -> Bool {
        return selectedPolylines.contains(polyline)
    }
    
    func togglePolylineSelection(_ polyline: MKPolyline) {
        if polylineIsSelected(polyline) {
            deselectPolyline(polyline)
        } else {
            selectPolyline(polyline)
        }
    }
    
    func addPolylines(to mapView: MKMapView) {
        polylines.forEach { polyline in
            mapView.addOverlay(polyline)
        }
    }
    
    func appendGPXFiles(fromDirectory url: URL) async {
        var segments: [GPX.Segment] = []
        FilesSequence(url: url)
            //.prefix(10)
            .forEach { url in
                switch GPX.makeGPX(from: url) {
                case .success(let gpx):
                    gpx
                        .tracks
                        .flatMap { $0.segments }
                        .forEach { segments.append($0) }
                case .failure(.readingError(let url)):
                    print("file reading error at \(url)")
                    return
                case .failure(.parsingError(_, let lineNumber)):
                    print("gpx file parsing error at \(lineNumber) from \(url)")
                    return
                }
            }
        await MainActor.run { [segments] in
            self.addGPXSegments(segments)
            self.needZoomtoFit = true
        }
    }
    
    func closestPolyline(at point: CLLocationCoordinate2D, radius: CLLocationDistance) -> MKPolyline? {
        var closest: MKPolyline?
        var closestDistance = Double.greatestFiniteMagnitude
        for polyline in polylines {
            let distance = distanceBetween(point, polyline)
            if distance < radius, distance < closestDistance {
                closestDistance = distance
                closest = polyline
            }
        }
        return closest
    }

}

