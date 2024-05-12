//
//  MapKitViewModel.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation

class MapKitViewModel: ObservableObject {

    @Published var segment: MapKitSegment
    
    func loadSample() -> GPX {
        let data = Data(gpxSampleManual.utf8)
        switch GPXParser().parse(data: data) {
        case let .success(gpx):
            return gpx
        case .failure(_):
            fatalError()
        }
    }

    init(segment: MapKitSegment = MapKitSegment()) {
        self.segment = segment
    }
}
