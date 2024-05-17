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
    
    init(gpxSegment: GPXSegment) {
        points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }
    
}

final class MapKitSegments: ObservableObject {
    @Published var segments: [MapKitSegment] = []
    
    func loadSegments(url: URL) {
        FilesSequence(url: url)
            //.prefix(100)
            .forEach { url in
                guard let data = try? Data(contentsOf: url) else {
                    print("file read error. url: \(url)")
                    return
                }
                switch GPXParser().parse(data: data) {
                case .success(let gpx):
                    gpx
                        .tracks
                        .flatMap { track in track.segments }
                        .map { gpxSegment in MapKitSegment(gpxSegment: gpxSegment) }
                        .forEach { segment in segments.append(segment) }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

