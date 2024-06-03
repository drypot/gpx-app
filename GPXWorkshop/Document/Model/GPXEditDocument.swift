//
//  GPXEditDocument.swift
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI
import UniformTypeIdentifiers

final class GPXEditDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.gpxWorkshopBundle, .gpx] }
    
    let segments: Segments
    var content: String
    
    init() {
        self.segments = Segments()
        self.content = "Hello World"
    }
    
    init(configuration: ReadConfiguration) throws {
        let fileWrapper = configuration.file
        guard
            let fileData = fileWrapper.fileWrappers?["data.txt"]?.regularFileContents,
            let content = String(data: fileData, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.segments = Segments()
        self.content = content
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            "data.txt": FileWrapper(regularFileWithContents: data)
        ])
        return fileWrapper
    }
    
    func importFiles() {
        Task {
            let newSegments = await GPX.makeSegments(fromDirectory: URL(fileURLWithPath: defaultGPXFolderPath))
            segments.append(newSegments)
        }
    }
}
