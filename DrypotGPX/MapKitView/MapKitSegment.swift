//
//  MapKitTrack.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation
import CoreLocation

final class MapKitSegment: Identifiable {
    
    var points: [CLLocationCoordinate2D]
    
    init() {
        points = []
    }
    
    init(gpxSegment: GPX.Segment) {
        points = gpxSegment.points.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
    }
}
