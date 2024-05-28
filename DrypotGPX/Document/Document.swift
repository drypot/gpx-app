//
//  Document.swift
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var gpx: UTType {
        UTType("com.topografix.gpx")!
    }
    static var gpxWorkshopBundle: UTType {
        UTType("com.drypot.gpx-workshop")!
    }
}

struct Document: FileDocument {
    
    static var readableContentTypes: [UTType] { [.gpxWorkshopBundle] }
    
    var segments: SegmentViewModel
    var content: String
    
    init() {
        self.segments = SegmentViewModel()
        self.content = "Hello World"
    }
    
    init(configuration: ReadConfiguration) throws {
        let fileWrapper = configuration.file
        guard
            let fileData = fileWrapper.fileWrappers?["data.txt"]?.regularFileContents,
            let content = String(data: fileData, encoding: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.segments = SegmentViewModel()
        self.content = content
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(content.utf8)
        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            "data.txt": FileWrapper(regularFileWithContents: data)
        ])
        return fileWrapper
    }
}
