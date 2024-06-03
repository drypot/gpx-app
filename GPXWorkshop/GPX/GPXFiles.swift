//
//  GPXFiles.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 6/2/24.
//

import Foundation
import MapKit

extension GPX {
    static func makeGPX(from url: URL) -> Result<GPX, Error> {
        guard let data = try? Data(contentsOf: url) else {
            return .failure(.readingError(url))
        }
        return Parser().parse(data)
    }
        
    static func makeSegments(fromDirectory url: URL) async -> [MKPolyline] {
        var newSegments: [MKPolyline] = []
        FilesSequence(url: url)
            .prefix(10)
            .forEach { url in
                switch GPX.makeGPX(from: url) {
                case .success(let gpx):
                    gpx
                        .tracks
                        .flatMap { $0.segments }
                        .map { MKPolyline($0) }
                        .forEach { newSegments.append($0) }
                case .failure(.readingError(let url)):
                    print("file reading error at \(url)")
                    return
                case .failure(.parsingError(_, let lineNumber)):
                    print("gpx file parsing error at \(lineNumber) from \(url)")
                    return
                }
            }
        return newSegments
    }

}
