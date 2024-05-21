//
//  MapKitSegments.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/21/24.
//

import Foundation

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

