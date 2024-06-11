//
//  Globals.swift
//  GPXWorkshop
//
//  Created by Kyuhyun Park on 5/16/24.
//

import Foundation
import UniformTypeIdentifiers

let sampleGPXFolderPath = "Documents/GPX Files Subset"

class GlobalActions {
    typealias Action = () -> Void
    static let shared = GlobalActions()
    private init() {}
    
    var exportGPX: Action?
}

extension UTType {
    static var gpxWorkshopBundle: UTType = UTType(exportedAs: "com.drypot.gpxworkshop")
    static let gpx: UTType = UTType(importedAs: "com.topografix.gpx")
}
