//
//  MapKitTrack.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation
import CoreLocation

final class MapKitSegment: Identifiable {
    
    var points: [CLLocationCoordinate2D]
    
    init() {
        points = []
    }
    
    init(gpxSegment: GPX.Segment) {
        points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }
    
}

final class MapKitSegments: ObservableObject {
    @Published var segments: [MapKitSegment] = []
    
    func append(fromDirectory url: URL) {
        FilesSequence(url: url)
            .prefix(10)
            .forEach { url in
                switch GPX.makeGPX(from: url) {
                case .success(let gpx):
                    gpx
                        .tracks
                        .flatMap { track in track.segments }
                        .map { gpxSegment in MapKitSegment(gpxSegment: gpxSegment) }
                        .forEach { segment in segments.append(segment) }
                case .failure(.readingError(let url)):
                    print("file reading error at \(url)")
                    return
                case .failure(.parsingError(_, let lineNumber)):
                    print("gpx file parsing error at \(lineNumber) from \(url)")
                    return
                }
            }
    }
    
}

