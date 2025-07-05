//
//  UTType.swift
//  GPXApp
//
//  Created by Kyuhyun Park on 8/20/24.
//

import UniformTypeIdentifiers

extension UTType {
    static let gpxWorkshop: UTType = UTType(exportedAs: "com.drypot.gpxworkshop")
    static let gpx: UTType = UTType(importedAs: "com.topograifx.gpx")
}
