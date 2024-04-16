//
//  GPXManager.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-11.
//

import Foundation
import MapKit

class GPXManager {
    var dict = [UUID: GPX]()
    
    func loadSample() {
        let data = Data(gpxSampleManual.utf8)
        switch GPXParser().parse(data: data) {
        case let .success(gpx):
            dict[gpx.uuid] = gpx
        case .failure(_):
            fatalError()
        }
    }
    
}
