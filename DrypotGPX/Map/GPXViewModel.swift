//
//  MapModel.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-16.
//

import Foundation
import CoreLocation

class GPXViewModel: ObservableObject {
    
    let manager = GPXManager()
    
    var tracks = [[CLLocationCoordinate2D]]()
    
    func loadSampleTrack() {
        manager.loadSample()
        tracks.append(manager.dict.first!.value.tracks[0].segments[0].mapKitCoordinates)
    }
    
}
