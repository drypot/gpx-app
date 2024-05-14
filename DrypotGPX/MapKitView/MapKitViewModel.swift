//
//  MapKitViewModel.swift
//  DrypotGPX
//
//  Created by Kyuhyun Park on 5/11/24.
//

import Foundation

class MapKitViewModel: ObservableObject {

    @Published var segment: MapKitSegment

    init(segment: MapKitSegment = MapKitSegment()) {
        self.segment = segment
    }
}
