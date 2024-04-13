//
//  GPXManager.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-11.
//

import Foundation
import MapKit

class GPXManager {
    var sampleGPX: GPX?
    var sampleCoordinates: [CLLocationCoordinate2D]?
    
    func load() {
        let data = Data(gpxSampleManual.utf8)
        switch GPXParser().parse(data: data) {
        case let .success(gpx):
            self.sampleGPX = gpx
        case .failure(_):
            assertionFailure("failed loading gpx file.")
        }
        sampleCoordinates = coordinates(from: sampleGPX!.tracks[0].trackSegments[0].trackPoints)
    }
    
}

let gpxManager = GPXManager()
