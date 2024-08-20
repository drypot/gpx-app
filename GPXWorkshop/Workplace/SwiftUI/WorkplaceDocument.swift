//
//  WorkplaceDocument.swift
//
//  Created by Kyuhyun Park on 5/11/24.
//

import SwiftUI
import UniformTypeIdentifiers
import MapKit


final class WorkplaceDocument: ReferenceFileDocument {
    typealias Snapshot = [MKPolyline]
        
    static var readableContentTypes: [UTType] { [.gpxWorkshop, .gpx, .folder] }
    
    //var workplace: Workplace!
    
    init() {
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
//        do {
//            workplace.appendSegments(from: data)
//        } catch {
//            print(error)
//        }
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

