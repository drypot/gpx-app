//
//  MapKitTrack.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation
import CoreLocation
import Combine

final class MapKitSegment: Identifiable {
    var points: [CLLocationCoordinate2D]
    unowned var segments: MapKitSegments?
    
    init(points: [CLLocationCoordinate2D] = []) {
        self.points = points
    }

    convenience init(gpxSegment: GPX.Segment) {
        let points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        self.init(points: points)
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
    
    //private var appendCancelable: AnyCancellable?
    
    func append(_ segment: MapKitSegment) {
        self.segments.append(segment)
        segment.segments = self
    }
    
    func append(contentsOf segments: [MapKitSegment]) {
        segments.forEach { self.append($0) }
    }
    
    func appendToSelection(_ segment: MapKitSegment) {
        selection.insert(segment)
    }
    
    func removeFromSelection(_ segment: MapKitSegment) {
        selection.remove(segment)
    }
}

extension MapKitSegments {
    func appendGPXFiles(fromDirectory url: URL) async {
        var segmentsToAppend: [MapKitSegment] = []
        var count = 0
        for url in FilesSequence(url: url) {
            switch GPX.makeGPX(from: url) {
            case .success(let gpx):
                gpx
                    .tracks
                    .flatMap { $0.segments }
                    .map { MapKitSegment(gpxSegment: $0) }
                    .forEach { segmentsToAppend.append($0) }
            case .failure(.readingError(let url)):
                print("file reading error at \(url)")
                return
            case .failure(.parsingError(_, let lineNumber)):
                print("gpx file parsing error at \(lineNumber) from \(url)")
                return
            }

            //count += 1
            //if count > 100 { break; }
        }
        await MainActor.run { [segmentsToAppend] in
            self.append(contentsOf: segmentsToAppend)
        }
    }
    
    //
    //    Combine version
    //
    //    func appendGPXFilesRecursively(fromDirectory url: URL) async {
    //        var segmentsToAppend: [MapKitSegment] = []
    //        appendCancelable = FilesPublisher(url: url)
    //            //.prefix(1000)
    //            .sink(receiveCompletion: { completion in
    //                DispatchQueue.main.async {
    //                    self.append(contentsOf: segmentsToAppend)
    //                }
    //            }, receiveValue: { url in
    //                switch GPX.makeGPX(from: url) {
    //                case .success(let gpx):
    //                    gpx
    //                        .tracks
    //                        .flatMap { track in track.segments }
    //                        .map { segment in MapKitSegment(gpxSegment: segment) }
    //                        .forEach { segment in segmentsToAppend.append(segment) }
    //                        //.forEach { segment in self.append(segment) }
    //                case .failure(.readingError(let url)):
    //                    print("file reading error at \(url)")
    //                    return
    //                case .failure(.parsingError(_, let lineNumber)):
    //                    print("gpx file parsing error at \(lineNumber), \(url)")
    //                    return
    //                }
    //            })
    //    }
    
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

