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
    unowned var segments: MapKitSegments?
    
    init() {
        points = []
    }
    
    init(gpxSegment: GPX.Segment) {
        points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }
}

extension MapKitSegment: Equatable {
    static func == (lhs: MapKitSegment, rhs: MapKitSegment) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MapKitSegment: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class MapKitSegments: ObservableObject {
    @Published private(set) var segments: [MapKitSegment] = []
    @Published private(set) var selection: Set<MapKitSegment> = []
    
    func append(_ segment: MapKitSegment) {
        segments.append(segment)
        segment.segments = self
    }
    
    func appendToSelection(_ segment: MapKitSegment) {
        selection.insert(segment)
    }
    
    func removeFromSelection(_ segment: MapKitSegment) {
        selection.remove(segment)
    }
}

extension MapKitSegments {
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
                        .forEach { segment in self.append(segment) }
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

extension MapKitSegment {
    var isSelected:Bool {
        guard let segments else { return false }
        return segments.selection.contains(self)
    }

    func toggleSelected() {
        guard let segments else { return }
        if isSelected {
            segments.removeFromSelection(self)
        } else {
            segments.appendToSelection(self)
        }
    }
}

