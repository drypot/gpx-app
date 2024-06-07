//
//  GPXDocument.swift
//
//  Created by Kyuhyun Park on 5/28/24.
//

import SwiftUI
import UniformTypeIdentifiers
import MapKit

final class GPXDocument: ReferenceFileDocument {
    typealias Snapshot = [MKPolyline]
        
    static var readableContentTypes: [UTType] { [.gpxWorkshopBundle, .gpx] }
    
    var data: Data?
    
    init() {
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }
    
    func snapshot(contentType: UTType) throws -> [MKPolyline] {
        return []
    }
    
    func fileWrapper(snapshot: [MKPolyline], configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data("".utf8)
        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            "data.txt": FileWrapper(regularFileWithContents: data)
        ])
        return fileWrapper
        // return FileWrapper(regularFileWithContents: content)
    }
    
}
