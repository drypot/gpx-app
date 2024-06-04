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
        let newSegments = try makeSegments(from: data)
        segments.append(newSegments)
    }
    
    func makeSegments(from data: Data) throws -> [MKPolyline] {
        let gpx = try GPX.makeGPX(from: data)
        let newSegments = gpx.tracks
            .flatMap { $0.segments }
            .map { MKPolyline($0) }
        return newSegments
    }
    
    func makeSegments(fromDirectory url: URL) async throws -> [MKPolyline] {
        var newSegments: [MKPolyline] = []
        try FilesSequence(url: url)
            .prefix(10)
            .forEach { url in
                try GPX.makeGPX(from: url)
                    .tracks
                    .flatMap { $0.segments }
                    .map { MKPolyline($0) }
                    .forEach { newSegments.append($0) }
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
            let newSegments = try await makeSegments(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
            segments.append(newSegments)
        }
    }
}
