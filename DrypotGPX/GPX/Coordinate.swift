//
//  Coordiante.swift
//  DrypotGPX
//
//  Created by drypot on 2024-04-02.
//

// 참고
// https://github.com/mmllr/GPXKit/blob/main/Sources/GPXKit/Coordinate.swift

import Foundation

struct Coordinate {
  var latitude: Double
  var longitude: Double
  var elevation: Double = 0
  
  init(latitude: Double, longitude: Double, elevation: Double = .zero) {
    self.latitude = latitude
    self.longitude = longitude
    self.elevation = elevation
  }

  func almostEqual(_ target: Coordinate) -> Bool {
    (self.latitude - target.latitude).magnitude < 0.000001 &&
    (self.longitude - target.longitude).magnitude < 0.000001 &&
    (self.elevation - target.elevation).magnitude < 0.00001
  }

}
