//
//  GPXEditDocument.swift
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI
import UniformTypeIdentifiers
import MapKit

final class GPXEditDocument: ReferenceFileDocument {
    typealias Snapshot = [MKPolyline]
        
    static var readableContentTypes: [UTType] { [.gpxWorkshopBundle, .gpx] }
    
    let segments: Segments
    var content: String
    
    init() {
        self.segments = Segments()
        self.content = "Hello World"
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.segments = Segments()
        self.content = "Hello World"
        switch makeSegments(from: data) {
        case .success(let newSegments):
            segments.append(newSegments)
        case .failure(let error):
            throw error
        }
    }
    
    func makeSegments(from data: Data) -> Result<[MKPolyline], Error> {
        var newSegments: [MKPolyline] = []
        switch GPX.makeGPX(from: data) {
        case .success(let gpx):
            newSegments = gpx.tracks
                .flatMap { $0.segments }
                .map { MKPolyline($0) }
            return .success(newSegments)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func makeSegments(fromDirectory url: URL) async -> [MKPolyline] {
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
    
    func snapshot(contentType: UTType) throws -> [MKPolyline] {
        return []
    }
    
    func fileWrapper(snapshot: [MKPolyline], configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            "data.txt": FileWrapper(regularFileWithContents: data)
        ])
        return fileWrapper
    }
    
    func importFiles() {
        Task {
            let newSegments = await makeSegments(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
            segments.append(newSegments)
        }
    }
}
